-- Chicago 311 Stage 4 Method B — Controlled SQL Source Delivery
-- Design: stage3-v0.1 (LOCKED) | Contract: SOURCE_DELIVERY_CONTRACT.md
-- Role: NONJUDGMENTAL raw-ish extract only. No is_open/is_eligible/open_age_days/action/selected.
--
-- Mechanical envelope (NOT a judged eligibility rule):
--   STATUS = 'Open'  -- bounds volume vs 14.6M; wider than judged eligibility; no age filter.
--
-- Auth: mysql --login-path=chicago311
-- Schema.table: chicago311.raw_311_requests
-- Target PC workdir: C:\Users\Mark\Documents\R Working Directory\chicago311\sql\source-delivery\

SELECT
  SR_NUMBER,
  SR_TYPE,
  SR_SHORT_CODE,
  CREATED_DEPARTMENT,
  OWNER_DEPARTMENT,
  STATUS,
  ORIGIN,
  CREATED_DATE,
  LAST_MODIFIED_DATE,
  CLOSED_DATE,
  STREET_ADDRESS,
  CITY,
  STATE,
  ZIP_CODE,
  STREET_NUMBER,
  STREET_DIRECTION,
  STREET_NAME,
  STREET_TYPE,
  DUPLICATE,
  LEGACY_RECORD,
  LEGACY_SR_NUMBER,
  PARENT_SR_NUMBER,
  COMMUNITY_AREA,
  WARD,
  ELECTRICAL_DISTRICT,
  ELECTRICITY_GRID,
  POLICE_SECTOR,
  POLICE_DISTRICT,
  POLICE_BEAT,
  PRECINCT,
  SANITATION_DIVISION_DAYS,
  CREATED_HOUR,
  CREATED_DAY_OF_WEEK,
  CREATED_MONTH,
  X_COORDINATE,
  Y_COORDINATE,
  LATITUDE,
  LONGITUDE,
  LOCATION
FROM chicago311.raw_311_requests
WHERE STATUS = 'Open'
ORDER BY SR_NUMBER;
