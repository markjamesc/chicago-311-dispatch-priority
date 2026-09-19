-- SQL Source Gate vs chicago311.raw_311_requests
-- Mechanical envelope: STATUS='Open'
-- FAIL any check ⇒ do not start R-A/R-B.
-- Assumes delivered package loaded as chicago311.source_open_envelope
--   OR compare against same predicate on raw (preferred when extract = SELECT * FROM raw WHERE Open).

-- A. Envelope rowcount equality (raw vs mechanical predicate)
SELECT 'A_envelope_rowcount' AS check_id,
       (SELECT COUNT(*) FROM chicago311.raw_311_requests WHERE STATUS='Open') AS raw_n,
       (SELECT COUNT(*) FROM chicago311.source_open_envelope) AS delivered_n,
       CASE WHEN (SELECT COUNT(*) FROM chicago311.raw_311_requests WHERE STATUS='Open')
                 = (SELECT COUNT(*) FROM chicago311.source_open_envelope)
            THEN 'PASS' ELSE 'FAIL' END AS result;

-- B. Distinct SR_NUMBER = rowcount (delivered)
SELECT 'B_distinct_sr_equals_rows' AS check_id,
       COUNT(*) AS row_n,
       COUNT(DISTINCT SR_NUMBER) AS distinct_n,
       CASE WHEN COUNT(*) = COUNT(DISTINCT SR_NUMBER) THEN 'PASS' ELSE 'FAIL' END AS result
FROM chicago311.source_open_envelope;

-- C. ID coverage: no missing / no extra vs raw Open
SELECT 'C_id_missing_in_delivered' AS check_id,
       COUNT(*) AS missing_n,
       CASE WHEN COUNT(*)=0 THEN 'PASS' ELSE 'FAIL' END AS result
FROM chicago311.raw_311_requests r
LEFT JOIN chicago311.source_open_envelope d ON r.SR_NUMBER <=> d.SR_NUMBER
WHERE r.STATUS='Open' AND d.SR_NUMBER IS NULL;

SELECT 'C_id_extra_in_delivered' AS check_id,
       COUNT(*) AS extra_n,
       CASE WHEN COUNT(*)=0 THEN 'PASS' ELSE 'FAIL' END AS result
FROM chicago311.source_open_envelope d
LEFT JOIN chicago311.raw_311_requests r
  ON d.SR_NUMBER <=> r.SR_NUMBER AND r.STATUS='Open'
WHERE r.SR_NUMBER IS NULL;

-- D. Critical field equality (null-safe <=>) sample: STATUS, SR_TYPE, CREATED_DATE, DUPLICATE, PARENT, LEGACY
SELECT 'D_field_mismatch_critical' AS check_id,
       SUM(CASE WHEN NOT (
            r.STATUS <=> d.STATUS
        AND r.SR_TYPE <=> d.SR_TYPE
        AND r.CREATED_DATE <=> d.CREATED_DATE
        AND r.LAST_MODIFIED_DATE <=> d.LAST_MODIFIED_DATE
        AND r.CLOSED_DATE <=> d.CLOSED_DATE
        AND r.DUPLICATE <=> d.DUPLICATE
        AND r.LEGACY_RECORD <=> d.LEGACY_RECORD
        AND r.LEGACY_SR_NUMBER <=> d.LEGACY_SR_NUMBER
        AND r.PARENT_SR_NUMBER <=> d.PARENT_SR_NUMBER
        AND r.WARD <=> d.WARD
        AND r.COMMUNITY_AREA <=> d.COMMUNITY_AREA
       ) THEN 1 ELSE 0 END) AS mismatch_n,
       CASE WHEN SUM(CASE WHEN NOT (
            r.STATUS <=> d.STATUS
        AND r.SR_TYPE <=> d.SR_TYPE
        AND r.CREATED_DATE <=> d.CREATED_DATE
        AND r.LAST_MODIFIED_DATE <=> d.LAST_MODIFIED_DATE
        AND r.CLOSED_DATE <=> d.CLOSED_DATE
        AND r.DUPLICATE <=> d.DUPLICATE
        AND r.LEGACY_RECORD <=> d.LEGACY_RECORD
        AND r.LEGACY_SR_NUMBER <=> d.LEGACY_SR_NUMBER
        AND r.PARENT_SR_NUMBER <=> d.PARENT_SR_NUMBER
        AND r.WARD <=> d.WARD
        AND r.COMMUNITY_AREA <=> d.COMMUNITY_AREA
       ) THEN 1 ELSE 0 END)=0 THEN 'PASS' ELSE 'FAIL' END AS result
FROM chicago311.raw_311_requests r
INNER JOIN chicago311.source_open_envelope d ON r.SR_NUMBER <=> d.SR_NUMBER
WHERE r.STATUS='Open';

-- E. STATUS domain (envelope must be Open-only)
SELECT 'E_status_domain' AS check_id,
       COUNT(DISTINCT STATUS) AS status_n,
       SUM(STATUS<>'Open') AS non_open_n,
       CASE WHEN COUNT(DISTINCT STATUS)=1 AND SUM(STATUS<>'Open')=0 THEN 'PASS' ELSE 'FAIL' END AS result
FROM chicago311.source_open_envelope;

-- F. CREATED_DATE range vs raw Open
SELECT 'F_created_date_range' AS check_id,
       (SELECT MIN(CREATED_DATE) FROM chicago311.raw_311_requests WHERE STATUS='Open') AS raw_min,
       (SELECT MAX(CREATED_DATE) FROM chicago311.raw_311_requests WHERE STATUS='Open') AS raw_max,
       (SELECT MIN(CREATED_DATE) FROM chicago311.source_open_envelope) AS del_min,
       (SELECT MAX(CREATED_DATE) FROM chicago311.source_open_envelope) AS del_max,
       CASE WHEN
         (SELECT MIN(CREATED_DATE) FROM chicago311.raw_311_requests WHERE STATUS='Open')
           <=> (SELECT MIN(CREATED_DATE) FROM chicago311.source_open_envelope)
         AND
         (SELECT MAX(CREATED_DATE) FROM chicago311.raw_311_requests WHERE STATUS='Open')
           <=> (SELECT MAX(CREATED_DATE) FROM chicago311.source_open_envelope)
       THEN 'PASS' ELSE 'FAIL' END AS result;

-- G. Duplicate SR_NUMBER in delivered (must be 0)
SELECT 'G_dup_sr_number' AS check_id,
       COUNT(*) - COUNT(DISTINCT SR_NUMBER) AS dup_n,
       CASE WHEN COUNT(*) = COUNT(DISTINCT SR_NUMBER) THEN 'PASS' ELSE 'FAIL' END AS result
FROM chicago311.source_open_envelope;
