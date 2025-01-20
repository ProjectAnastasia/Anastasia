-- 000a_test_data.sql

--
-- Update schema version of Anastasia game database
--

-- `sql_version` is 0

DELETE FROM `db_metadata`;
INSERT INTO `db_metadata` (`sql_version`) VALUES (0);

-- TODO: just testing, remove this before merge

DROP TABLE IF EXISTS `bad_table`;
CREATE TABLE `bad_table` (
  `id` int(11) NOT NULL,
  `ckey` varchar(50) NOT NULL,
  `secret` varchar(64) NOT NULL,
  `date_setup` datetime NOT NULL DEFAULT current_timestamp(),
  `last_time` datetime DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `uuid` uuid NOT NULL DEFAULT uuid(),
  `version` int(11) NOT NULL DEFAULT 0,
  KEY (`id`),
  -- UNIQUE KEY (`ckey`)
  PRIMARY KEY (`ckey`)
);
