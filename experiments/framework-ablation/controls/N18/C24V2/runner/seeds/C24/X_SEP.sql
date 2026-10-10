-- N13 C24 X_SEP: Envelope A as frozen (mechanical SQL envelope STATUS = 'Open'); read-only form of frozen 01_source_extract.sql Envelope A
-- (same text as N13 C52 E1.sql), streamed to a file; ORDER BY SR_NUMBER = the frozen table's primary-key order. No DDL, no writes.
USE chicago311;
SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET @T_freeze = CAST('2026-09-12 23:59:59' AS DATETIME);
SET @T_lookback_start = DATE_SUB(@T_freeze, INTERVAL 365 DAY);
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
  -- Mechanical datetime parses (NULL if unparseable). Formats: ISO, US AM/PM, US 24h.
  -- No timezone conversion here. Failures stay NULL for R integrity gate.
  COALESCE(
    STR_TO_DATE(REPLACE(TRIM(r.CREATED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(TRIM(r.CREATED_DATE), '%m/%d/%Y %h:%i:%s %p'),
    STR_TO_DATE(TRIM(r.CREATED_DATE), '%m/%d/%Y %H:%i:%s'),
    STR_TO_DATE(REPLACE(TRIM(r.CREATED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s.%f')
  ) AS created_ts,
  COALESCE(
    STR_TO_DATE(REPLACE(TRIM(r.LAST_MODIFIED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(TRIM(r.LAST_MODIFIED_DATE), '%m/%d/%Y %h:%i:%s %p'),
    STR_TO_DATE(TRIM(r.LAST_MODIFIED_DATE), '%m/%d/%Y %H:%i:%s'),
    STR_TO_DATE(REPLACE(TRIM(r.LAST_MODIFIED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s.%f')
  ) AS mod_ts,
  CASE WHEN NULLIF(TRIM(r.CLOSED_DATE), '') IS NULL THEN NULL
       ELSE COALESCE(
    STR_TO_DATE(REPLACE(TRIM(r.CLOSED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(TRIM(r.CLOSED_DATE), '%m/%d/%Y %h:%i:%s %p'),
    STR_TO_DATE(TRIM(r.CLOSED_DATE), '%m/%d/%Y %H:%i:%s'),
    STR_TO_DATE(REPLACE(TRIM(r.CLOSED_DATE), 'T', ' '), '%Y-%m-%d %H:%i:%s.%f')
  )
  END AS closed_ts,
  CAST(@T_freeze AS DATETIME) AS t_freeze,
  'STATUS=Open' AS mechanical_envelope,
  'chicago311-raw-frozen-2026-09-12' AS snapshot_id
FROM raw_311_requests r
WHERE r.STATUS = 'Open'
ORDER BY r.SR_NUMBER;
