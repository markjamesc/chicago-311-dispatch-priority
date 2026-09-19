-- =============================================================================
-- Chicago 311 Stage 4 Method B — CONTROLLED SQL SOURCE DELIVERY
-- Authority: owner Design Gate PASS 2026-09-19 CT (B-leaning hybrid TCD-IG)
-- Role: NONJUDGMENTAL extract + mechanical peer aggregates ONLY.
--
-- FORBIDDEN in SQL outputs:
--   ESCALATE / INCONCLUSIVE / STANDARD, is_eligible, dormant_h thresholds,
--   κ comparisons, urgency, action, selected, ranking.
--
-- ALLOWED:
--   column select, mechanical date cast/parse into typed columns,
--   mechanical envelope filter, peer aggregates (peer_n, peer_p50_h, peer_p75_h).
--
-- Constants (documented; not owner knob κ):
--   T_freeze working = 2026-09-12 23:59:59 America/Chicago (snapshot as-of T)
--   W = 365 days ending at T
--   Open envelope A = STATUS = 'Open' (exact token; R may normalize further)
--
-- Auth: mysql --login-path=chicago311
-- Schema: chicago311  |  Source: raw_311_requests
-- Tables written: src_open_candidates, src_peer_stats, src_extract_lineage
-- =============================================================================

USE chicago311;

SET @T_freeze = CAST('2026-09-12 23:59:59' AS DATETIME);
SET @T_lookback_start = DATE_SUB(@T_freeze, INTERVAL 365 DAY);
SET @extract_ts_utc = UTC_TIMESTAMP();

-- -----------------------------------------------------------------------------
-- Envelope A: Open candidates (~245k). Raw-ish + mechanical typed clocks.
-- No eligibility cuts (dup/legacy/parent remain for R integrity gate).
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS src_open_candidates;
CREATE TABLE src_open_candidates AS
SELECT
  r.SR_NUMBER,
  r.SR_TYPE,
  r.SR_SHORT_CODE,
  r.CREATED_DEPARTMENT,
  r.OWNER_DEPARTMENT,
  r.STATUS,
  r.ORIGIN,
  r.CREATED_DATE,
  r.LAST_MODIFIED_DATE,
  r.CLOSED_DATE,
  r.STREET_ADDRESS,
  r.CITY,
  r.STATE,
  r.ZIP_CODE,
  r.STREET_NUMBER,
  r.STREET_DIRECTION,
  r.STREET_NAME,
  r.STREET_TYPE,
  r.DUPLICATE,
  r.LEGACY_RECORD,
  r.LEGACY_SR_NUMBER,
  r.PARENT_SR_NUMBER,
  r.COMMUNITY_AREA,
  r.WARD,
  r.ELECTRICAL_DISTRICT,
  r.ELECTRICITY_GRID,
  r.POLICE_SECTOR,
  r.POLICE_DISTRICT,
  r.POLICE_BEAT,
  r.PRECINCT,
  r.SANITATION_DIVISION_DAYS,
  r.CREATED_HOUR,
  r.CREATED_DAY_OF_WEEK,
  r.CREATED_MONTH,
  r.X_COORDINATE,
  r.Y_COORDINATE,
  r.LATITUDE,
  r.LONGITUDE,
  r.LOCATION,
  -- Mechanical type_key (coalesce short code then type; blank → NULL for R)
  NULLIF(
    COALESCE(
      NULLIF(TRIM(r.SR_SHORT_CODE), ''),
      NULLIF(TRIM(r.SR_TYPE), '')
    ),
    ''
  ) AS type_key,
  -- Mechanical datetime parses (NULL if unparseable). Accept 'YYYY-MM-DD HH:MM:SS'
  -- and ISO 'YYYY-MM-DDTHH:MM:SS' by replacing T. No timezone conversion here.
  STR_TO_DATE(
    REPLACE(TRIM(r.CREATED_DATE), 'T', ' '),
    '%Y-%m-%d %H:%i:%s'
  ) AS created_ts,
  STR_TO_DATE(
    REPLACE(TRIM(r.LAST_MODIFIED_DATE), 'T', ' '),
    '%Y-%m-%d %H:%i:%s'
  ) AS mod_ts,
  STR_TO_DATE(
    REPLACE(NULLIF(TRIM(r.CLOSED_DATE), ''), 'T', ' '),
    '%Y-%m-%d %H:%i:%s'
  ) AS closed_ts,
  CAST(@T_freeze AS DATETIME) AS t_freeze,
  'STATUS=Open' AS mechanical_envelope,
  'chicago311-raw-frozen-2026-09-12' AS snapshot_id
FROM raw_311_requests r
WHERE r.STATUS = 'Open';

ALTER TABLE src_open_candidates
  ADD PRIMARY KEY (SR_NUMBER),
  ADD KEY idx_type_key (type_key);

-- -----------------------------------------------------------------------------
-- Envelope B: Completed peer aggregates at type_key grain.
-- Mechanical peer definition (NOT judged eligibility / NOT labels):
--   STATUS = 'Completed'
--   DUPLICATE not true-like
--   LEGACY_RECORD not true-like
--   created_ts / closed_ts parseable
--   closed_ts >= created_ts
--   created_ts in [T_freeze - 365d, T_freeze]
-- Percentiles: nearest-rank method — value at rank CEIL(P * n) (1-indexed).
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS src_peer_cycle_stage;
CREATE TABLE src_peer_cycle_stage AS
SELECT
  NULLIF(
    COALESCE(
      NULLIF(TRIM(r.SR_SHORT_CODE), ''),
      NULLIF(TRIM(r.SR_TYPE), '')
    ),
    ''
  ) AS type_key,
  STR_TO_DATE(REPLACE(TRIM(r.CREATED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s') AS created_ts,
  STR_TO_DATE(REPLACE(NULLIF(TRIM(r.CLOSED_DATE), ''), 'T', ' '), '%Y-%m-%d %H:%i:%s') AS closed_ts,
  TIMESTAMPDIFF(
    HOUR,
    STR_TO_DATE(REPLACE(TRIM(r.CREATED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(REPLACE(NULLIF(TRIM(r.CLOSED_DATE), ''), 'T', ' '), '%Y-%m-%d %H:%i:%s')
  ) AS cycle_h
FROM raw_311_requests r
WHERE r.STATUS = 'Completed'
  AND LOWER(TRIM(COALESCE(r.DUPLICATE, ''))) NOT IN ('true', 't', 'y', 'yes', '1')
  AND LOWER(TRIM(COALESCE(r.LEGACY_RECORD, ''))) NOT IN ('true', 't', 'y', 'yes', '1')
  AND NULLIF(TRIM(r.CREATED_DATE), '') IS NOT NULL
  AND NULLIF(TRIM(r.CLOSED_DATE), '') IS NOT NULL
  AND STR_TO_DATE(REPLACE(TRIM(r.CREATED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s') IS NOT NULL
  AND STR_TO_DATE(REPLACE(NULLIF(TRIM(r.CLOSED_DATE), ''), 'T', ' '), '%Y-%m-%d %H:%i:%s') IS NOT NULL
  AND STR_TO_DATE(REPLACE(NULLIF(TRIM(r.CLOSED_DATE), ''), 'T', ' '), '%Y-%m-%d %H:%i:%s')
      >= STR_TO_DATE(REPLACE(TRIM(r.CREATED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s')
  AND STR_TO_DATE(REPLACE(TRIM(r.CREATED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s')
      >= @T_lookback_start
  AND STR_TO_DATE(REPLACE(TRIM(r.CREATED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s')
      <= @T_freeze
  AND NULLIF(
        COALESCE(NULLIF(TRIM(r.SR_SHORT_CODE), ''), NULLIF(TRIM(r.SR_TYPE), '')),
        ''
      ) IS NOT NULL;

ALTER TABLE src_peer_cycle_stage ADD KEY idx_type (type_key), ADD KEY idx_cycle (type_key, cycle_h);

DROP TABLE IF EXISTS src_peer_ranked;
CREATE TABLE src_peer_ranked AS
SELECT
  type_key,
  cycle_h,
  ROW_NUMBER() OVER (PARTITION BY type_key ORDER BY cycle_h ASC) AS rn,
  COUNT(*) OVER (PARTITION BY type_key) AS peer_n
FROM src_peer_cycle_stage;

DROP TABLE IF EXISTS src_peer_stats;
CREATE TABLE src_peer_stats AS
SELECT
  type_key,
  MAX(peer_n) AS peer_n,
  MAX(CASE WHEN rn = CEILING(peer_n * 0.50) THEN cycle_h END) AS peer_p50_h,
  MAX(CASE WHEN rn = CEILING(peer_n * 0.75) THEN cycle_h END) AS peer_p75_h,
  CAST(@T_freeze AS DATETIME) AS t_freeze,
  365 AS lookback_w_days,
  'Completed non-dup non-legacy; closed>=created; created in [T-365d,T]; nearest-rank P50/P75' AS peer_def,
  'empirical_not_city_sla' AS peer_label_note
FROM src_peer_ranked
GROUP BY type_key;

ALTER TABLE src_peer_stats ADD PRIMARY KEY (type_key);

-- Drop large staging tables (keep only deliverables)
DROP TABLE IF EXISTS src_peer_ranked;
DROP TABLE IF EXISTS src_peer_cycle_stage;

-- -----------------------------------------------------------------------------
-- Lineage / freeze record for Source Gate
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS src_extract_lineage;
CREATE TABLE src_extract_lineage AS
SELECT
  'chicago311-raw-frozen-2026-09-12' AS snapshot_id,
  'chicago311.raw_311_requests' AS source_table,
  'STATUS=''Open''' AS envelope_a,
  'Completed peers W=365d ending T_freeze' AS envelope_b,
  CAST(@T_freeze AS DATETIME) AS t_freeze,
  CAST(@T_lookback_start AS DATETIME) AS t_lookback_start,
  @extract_ts_utc AS extract_ts_utc,
  (SELECT COUNT(*) FROM src_open_candidates) AS open_candidate_n,
  (SELECT COUNT(DISTINCT SR_NUMBER) FROM src_open_candidates) AS open_candidate_distinct_sr,
  (SELECT COUNT(*) FROM raw_311_requests WHERE STATUS = 'Open') AS raw_open_n,
  (SELECT COUNT(*) FROM src_peer_stats) AS peer_type_n,
  (SELECT SUM(peer_n) FROM src_peer_stats) AS peer_row_n_sum,
  'no_action_labels' AS judgment_posture,
  'stage4-method-b-source-v1' AS extract_version;

-- Quick sanity SELECTs (printed when script sourced)
SELECT 'LINEAGE' AS section, l.* FROM src_extract_lineage l;
SELECT 'OPEN_COUNT' AS section,
       (SELECT COUNT(*) FROM src_open_candidates) AS extract_open_n,
       (SELECT COUNT(*) FROM raw_311_requests WHERE STATUS='Open') AS raw_open_n;
SELECT 'PEER_TYPES' AS section, COUNT(*) AS type_n, SUM(peer_n) AS peer_rows
FROM src_peer_stats;
