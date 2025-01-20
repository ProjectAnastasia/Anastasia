-- 000a_test_data.sql

--
-- Update schema version of Anastasia game database
--

-- `sql_version` is 0

DELETE FROM `db_metadata`;
INSERT INTO `db_metadata` (`sql_version`) VALUES (0);
