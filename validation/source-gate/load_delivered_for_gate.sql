-- Load TSV into chicago311.source_open_envelope for Source Gate (PC).
-- Adjust LOCAL INFILE / secure_file_priv as needed on DESKTOP-RPECRM9.

DROP TABLE IF EXISTS chicago311.source_open_envelope;
CREATE TABLE chicago311.source_open_envelope LIKE chicago311.raw_311_requests;
-- Prefer: LOAD DATA LOCAL INFILE '...' INTO TABLE ... or mysqlimport.
-- Alternative when extract is exact Open subset of raw: CREATE TABLE ... AS SELECT * FROM raw WHERE STATUS='Open';
CREATE TABLE chicago311.source_open_envelope AS
SELECT * FROM chicago311.raw_311_requests WHERE STATUS = 'Open';
