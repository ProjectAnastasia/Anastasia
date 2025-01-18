-- 001_anastasia_data.sql

--
-- Insert rows for Anastasia administrative staff
--

-- `level` determined from code/modules/admin/permissionverbs/permissionedit.dm
-- `flags` determined from code/__DEFINES/admin.dm

DELETE FROM `admin` WHERE ckey = 'akuen';
INSERT INTO `admin` (`ckey`, `admin_rank`, `level`, `flags`) VALUES ('akuen', 'BDFL', -1, 131071);
DELETE FROM `admin` WHERE ckey = 'veloxi';
INSERT INTO `admin` (`ckey`, `admin_rank`, `level`, `flags`) VALUES ('veloxi', 'Host', -1, 131071);

--
-- Update schema version of Anastasia game database
--

-- `sql_version` is 1, which is 001_anastasia_data.sql (you are here!)

DELETE FROM `db_metadata`;
INSERT INTO `db_metadata` (`sql_version`) VALUES (1);
