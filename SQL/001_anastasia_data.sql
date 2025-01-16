-- 001_anastasia_data.sql

--
-- Insert rows for Anastasia administrative staff
--

-- `level` determined from code/modules/admin/permissionverbs/permissionedit.dm
-- `flags` determined from code/__DEFINES/admin.dm

DELETE FROM `admin` WHERE ckey = 'akuen';
INSERT INTO `admin` (`ckey`, `admin_rank`, `level`, `flags`) VALUES ('akuen', 'Head of Staff', -1, 131071);
DELETE FROM `admin` WHERE ckey = 'veloxi';
INSERT INTO `admin` (`ckey`, `admin_rank`, `level`, `flags`) VALUES ('veloxi', 'Hosting Provider', -1, 131071);

--
-- Update schema version of Anastasia game database
--

-- `sql_file` is 1, which is 001_anastasia_data.sql (you are here!)
-- `sql_version` is 25, the version of the database schema inherited from Paradise Station

DELETE FROM `db_metadata`;
INSERT INTO `db_metadata` (`sql_file`, `sql_version`) VALUES (1, 25);
