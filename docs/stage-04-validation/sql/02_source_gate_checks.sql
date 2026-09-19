-- =============================================================================
-- Chicago 311 Stage 4 — SQL SOURCE GATE checks
-- Compare extract tables vs raw_311_requests. FAIL ⇒ do not start R-A/R-B.
-- Assumes 01_source_extract.sql already created:
--   src_open_candidates, src_peer_stats, src_extract_lineage
-- =============================================================================

USE chicago311;

-- Results landing table
DROP TABLE IF EXISTS src_gate_results;
CREATE TABLE src_gate_results (
  check_id VARCHAR(64) PRIMARY KEY,
  metric_a VARCHAR(128) NULL,
  metric_b VARCHAR(128) NULL,
  metric_c VARCHAR(128) NULL,
  result ENUM('PASS','FAIL','INFO') NOT NULL,
  detail VARCHAR(512) NULL
);

-- A. Open count extract vs raw
INSERT INTO src_gate_results (check_id, metric_a, metric_b, result, detail)
SELECT
  'A_open_count_match',
  CAST((SELECT COUNT(*) FROM raw_311_requests WHERE STATUS='Open') AS CHAR),
  CAST((SELECT COUNT(*) FROM src_open_candidates) AS CHAR),
  CASE WHEN (SELECT COUNT(*) FROM raw_311_requests WHERE STATUS='Open')
            = (SELECT COUNT(*) FROM src_open_candidates)
       THEN 'PASS' ELSE 'FAIL' END,
  'raw_open_n vs extract_open_n; tolerance = exact match';

-- B. Distinct SR_NUMBER = rowcount
INSERT INTO src_gate_results (check_id, metric_a, metric_b, result, detail)
SELECT
  'B_distinct_sr_equals_rows',
  CAST(COUNT(*) AS CHAR),
  CAST(COUNT(DISTINCT SR_NUMBER) AS CHAR),
  CASE WHEN COUNT(*) = COUNT(DISTINCT SR_NUMBER) THEN 'PASS' ELSE 'FAIL' END,
  'src_open_candidates grain'
FROM src_open_candidates;

-- C. ID coverage vs raw Open
INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'C_id_missing_in_extract',
  CAST(COUNT(*) AS CHAR),
  CASE WHEN COUNT(*)=0 THEN 'PASS' ELSE 'FAIL' END,
  'raw Open SR_NUMBER absent from extract'
FROM raw_311_requests r
LEFT JOIN src_open_candidates d ON r.SR_NUMBER <=> d.SR_NUMBER
WHERE r.STATUS='Open' AND d.SR_NUMBER IS NULL;

INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'C_id_extra_in_extract',
  CAST(COUNT(*) AS CHAR),
  CASE WHEN COUNT(*)=0 THEN 'PASS' ELSE 'FAIL' END,
  'extract SR_NUMBER not in raw Open'
FROM src_open_candidates d
LEFT JOIN raw_311_requests r
  ON d.SR_NUMBER <=> r.SR_NUMBER AND r.STATUS='Open'
WHERE r.SR_NUMBER IS NULL;

-- D. Critical field equality (null-safe)
INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'D_field_mismatch_critical',
  CAST(SUM(CASE WHEN NOT (
       r.STATUS <=> d.STATUS
   AND r.SR_TYPE <=> d.SR_TYPE
   AND r.SR_SHORT_CODE <=> d.SR_SHORT_CODE
   AND r.CREATED_DATE <=> d.CREATED_DATE
   AND r.LAST_MODIFIED_DATE <=> d.LAST_MODIFIED_DATE
   AND r.CLOSED_DATE <=> d.CLOSED_DATE
   AND r.DUPLICATE <=> d.DUPLICATE
   AND r.LEGACY_RECORD <=> d.LEGACY_RECORD
   AND r.LEGACY_SR_NUMBER <=> d.LEGACY_SR_NUMBER
   AND r.PARENT_SR_NUMBER <=> d.PARENT_SR_NUMBER
   AND r.WARD <=> d.WARD
   AND r.COMMUNITY_AREA <=> d.COMMUNITY_AREA
  ) THEN 1 ELSE 0 END) AS CHAR),
  CASE WHEN SUM(CASE WHEN NOT (
       r.STATUS <=> d.STATUS
   AND r.SR_TYPE <=> d.SR_TYPE
   AND r.SR_SHORT_CODE <=> d.SR_SHORT_CODE
   AND r.CREATED_DATE <=> d.CREATED_DATE
   AND r.LAST_MODIFIED_DATE <=> d.LAST_MODIFIED_DATE
   AND r.CLOSED_DATE <=> d.CLOSED_DATE
   AND r.DUPLICATE <=> d.DUPLICATE
   AND r.LEGACY_RECORD <=> d.LEGACY_RECORD
   AND r.LEGACY_SR_NUMBER <=> d.LEGACY_SR_NUMBER
   AND r.PARENT_SR_NUMBER <=> d.PARENT_SR_NUMBER
   AND r.WARD <=> d.WARD
   AND r.COMMUNITY_AREA <=> d.COMMUNITY_AREA
  ) THEN 1 ELSE 0 END)=0 THEN 'PASS' ELSE 'FAIL' END,
  'null-safe <=> on critical raw columns'
FROM raw_311_requests r
INNER JOIN src_open_candidates d ON r.SR_NUMBER <=> d.SR_NUMBER
WHERE r.STATUS='Open';

-- E. STATUS domain Open-only
INSERT INTO src_gate_results (check_id, metric_a, metric_b, result, detail)
SELECT
  'E_status_domain_open_only',
  CAST(COUNT(DISTINCT STATUS) AS CHAR),
  CAST(SUM(STATUS<>'Open') AS CHAR),
  CASE WHEN COUNT(DISTINCT STATUS)=1 AND SUM(STATUS<>'Open')=0 THEN 'PASS' ELSE 'FAIL' END,
  'envelope A must be Open-only'
FROM src_open_candidates;

-- F. CREATED_DATE min/max vs raw Open
INSERT INTO src_gate_results (check_id, metric_a, metric_b, metric_c, result, detail)
SELECT
  'F_created_date_range',
  (SELECT MIN(CREATED_DATE) FROM raw_311_requests WHERE STATUS='Open'),
  (SELECT MAX(CREATED_DATE) FROM raw_311_requests WHERE STATUS='Open'),
  CONCAT(
    (SELECT MIN(CREATED_DATE) FROM src_open_candidates),
    ' .. ',
    (SELECT MAX(CREATED_DATE) FROM src_open_candidates)
  ),
  CASE WHEN
    (SELECT MIN(CREATED_DATE) FROM raw_311_requests WHERE STATUS='Open')
      <=> (SELECT MIN(CREATED_DATE) FROM src_open_candidates)
    AND
    (SELECT MAX(CREATED_DATE) FROM raw_311_requests WHERE STATUS='Open')
      <=> (SELECT MAX(CREATED_DATE) FROM src_open_candidates)
  THEN 'PASS' ELSE 'FAIL' END,
  'metric_a=raw_min metric_b=raw_max metric_c=extract min..max';

-- G. Null profiles (INFO + soft FAIL only if CREATED/STATUS null — unexpected)
INSERT INTO src_gate_results (check_id, metric_a, metric_b, metric_c, result, detail)
SELECT
  'G_null_profile_created_status',
  CAST(SUM(CREATED_DATE IS NULL OR TRIM(CREATED_DATE)='') AS CHAR),
  CAST(SUM(STATUS IS NULL OR TRIM(STATUS)='') AS CHAR),
  CAST(SUM(LAST_MODIFIED_DATE IS NULL OR TRIM(LAST_MODIFIED_DATE)='') AS CHAR),
  CASE WHEN SUM(CREATED_DATE IS NULL OR TRIM(CREATED_DATE)='')=0
        AND SUM(STATUS IS NULL OR TRIM(STATUS)='')=0
       THEN 'PASS' ELSE 'FAIL' END,
  'null/blank CREATED_DATE, STATUS, LAST_MODIFIED_DATE counts'
FROM src_open_candidates;

INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'G_null_closed_date_info',
  CAST(SUM(CLOSED_DATE IS NULL OR TRIM(CLOSED_DATE)='') AS CHAR),
  'INFO',
  'blank CLOSED_DATE count among Open (expected ~all)'
FROM src_open_candidates;

-- H. Checksum strategy: CRC64-like via BIT_XOR(CRC32(SR_NUMBER)) ordered set fingerprint
INSERT INTO src_gate_results (check_id, metric_a, metric_b, result, detail)
SELECT
  'H_sr_checksum_match',
  CAST((SELECT BIT_XOR(CRC32(SR_NUMBER)) FROM raw_311_requests WHERE STATUS='Open') AS CHAR),
  CAST((SELECT BIT_XOR(CRC32(SR_NUMBER)) FROM src_open_candidates) AS CHAR),
  CASE WHEN (SELECT BIT_XOR(CRC32(SR_NUMBER)) FROM raw_311_requests WHERE STATUS='Open')
            = (SELECT BIT_XOR(CRC32(SR_NUMBER)) FROM src_open_candidates)
       THEN 'PASS' ELSE 'FAIL' END,
  'BIT_XOR(CRC32(SR_NUMBER)) set fingerprint raw Open vs extract';

-- I. Peer stats exist at type_key grain; no action labels
INSERT INTO src_gate_results (check_id, metric_a, metric_b, result, detail)
SELECT
  'I_peer_stats_present',
  CAST((SELECT COUNT(*) FROM src_peer_stats) AS CHAR),
  CAST((SELECT COUNT(DISTINCT type_key) FROM src_peer_stats) AS CHAR),
  CASE WHEN (SELECT COUNT(*) FROM src_peer_stats) > 0
        AND (SELECT COUNT(*) FROM src_peer_stats)
            = (SELECT COUNT(DISTINCT type_key) FROM src_peer_stats)
       THEN 'PASS' ELSE 'FAIL' END,
  'peer_stats rowcount = distinct type_key; must be >0';

INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'I_peer_no_null_type_key',
  CAST(SUM(type_key IS NULL OR TRIM(type_key)='') AS CHAR),
  CASE WHEN SUM(type_key IS NULL OR TRIM(type_key)='')=0 THEN 'PASS' ELSE 'FAIL' END,
  'type_key must be non-null in peer_stats'
FROM src_peer_stats;

INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'I_peer_p75_nonneg_when_n',
  CAST(SUM(CASE WHEN peer_n > 0 AND (peer_p75_h IS NULL OR peer_p75_h < 0) THEN 1 ELSE 0 END) AS CHAR),
  CASE WHEN SUM(CASE WHEN peer_n > 0 AND (peer_p75_h IS NULL OR peer_p75_h < 0) THEN 1 ELSE 0 END)=0
       THEN 'PASS' ELSE 'FAIL' END,
  'peer_p75_h present and >=0 when peer_n>0'
FROM src_peer_stats;

-- J. No judged label columns on extract (schema probe)
INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'J_no_judged_columns',
  CAST(SUM(COLUMN_NAME IN (
        'action','classification','label','is_eligible','is_open',
        'ESCALATE','INCONCLUSIVE','STANDARD','dormant_h','kappa','selected'
      )) AS CHAR),
  CASE WHEN SUM(COLUMN_NAME IN (
        'action','classification','label','is_eligible','is_open',
        'ESCALATE','INCONCLUSIVE','STANDARD','dormant_h','kappa','selected'
      ))=0 THEN 'PASS' ELSE 'FAIL' END,
  'INFORMATION_SCHEMA probe for forbidden judged columns on src_open_candidates'
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA='chicago311' AND TABLE_NAME='src_open_candidates';

-- K. Lineage vs freeze expectations
INSERT INTO src_gate_results (check_id, metric_a, metric_b, result, detail)
SELECT
  'K_lineage_open_matches_raw',
  CAST(open_candidate_n AS CHAR),
  CAST(raw_open_n AS CHAR),
  CASE WHEN open_candidate_n = raw_open_n THEN 'PASS' ELSE 'FAIL' END,
  'src_extract_lineage open_candidate_n vs raw_open_n'
FROM src_extract_lineage;

INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'K_lineage_t_freeze',
  CAST(t_freeze AS CHAR),
  CASE WHEN t_freeze = CAST('2026-09-12 23:59:59' AS DATETIME) THEN 'PASS' ELSE 'FAIL' END,
  'T_freeze working must be 2026-09-12 23:59:59'
FROM src_extract_lineage;

-- Status distribution INFO
INSERT INTO src_gate_results (check_id, metric_a, result, detail)
SELECT
  'L_raw_status_dist_info',
  GROUP_CONCAT(CONCAT(STATUS, '=', cnt) ORDER BY STATUS SEPARATOR '; '),
  'INFO',
  'raw STATUS distribution'
FROM (
  SELECT STATUS, COUNT(*) AS cnt FROM raw_311_requests GROUP BY STATUS
) s;

-- Emit results
SELECT * FROM src_gate_results ORDER BY check_id;

SELECT
  CASE WHEN SUM(result='FAIL')=0 THEN 'SOURCE_GATE_PASS' ELSE 'SOURCE_GATE_FAIL' END AS overall,
  SUM(result='PASS') AS pass_n,
  SUM(result='FAIL') AS fail_n,
  SUM(result='INFO') AS info_n
FROM src_gate_results;
