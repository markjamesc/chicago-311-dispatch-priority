-- N13 C24 SQL counts (read-only): total rows, rows per STATUS, rows in the frozen SQL envelope (STATUS = 'Open')
USE chicago311;
SELECT 'total', COUNT(*) FROM raw_311_requests;
SELECT CONCAT('status=', STATUS), COUNT(*) FROM raw_311_requests GROUP BY STATUS ORDER BY STATUS;
SELECT 'envelope_open', COUNT(*) FROM raw_311_requests WHERE STATUS = 'Open';
