-- 000_anastasia_schema.sql

-- Set the default character set and collation for the database
ALTER DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci;

-- Set the default storage engine to InnoDB
SET default_storage_engine = 'InnoDB';

--
-- Table structure for table `2fa_secrets`
--

DROP TABLE IF EXISTS `2fa_secrets`;
CREATE TABLE `2fa_secrets` (
  `ckey` varchar(50) NOT NULL,
  `secret` varchar(64) NOT NULL,
  `date_setup` datetime NOT NULL DEFAULT current_timestamp(),
  `last_time` datetime DEFAULT NULL,
  PRIMARY KEY (`ckey`) USING BTREE
);

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `admin_rank` varchar(32) NOT NULL DEFAULT 'Administrator',
  `level` int(2) NOT NULL DEFAULT 0,
  `flags` int(16) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`)
);

--
-- Table structure for table `admin_log`
--

DROP TABLE IF EXISTS `admin_log`;
CREATE TABLE `admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `adminip` varchar(18) NOT NULL,
  `log` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `adminckey` (`adminckey`)
);

--
-- Table structure for table `ban`
--

DROP TABLE IF EXISTS `ban`;
CREATE TABLE `ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bantime` datetime NOT NULL,
  `ban_round_id` int(11) DEFAULT NULL,
  `serverip` varchar(32) NOT NULL,
  `bantype` varchar(32) NOT NULL,
  `reason` mediumtext NOT NULL,
  `job` varchar(32) DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `rounds` int(11) DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `a_ckey` varchar(32) NOT NULL,
  `a_computerid` varchar(32) NOT NULL,
  `a_ip` varchar(32) NOT NULL,
  `who` mediumtext NOT NULL,
  `adminwho` mediumtext NOT NULL,
  `edits` mediumtext DEFAULT NULL,
  `unbanned` tinyint(1) DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_round_id` int(11) DEFAULT NULL,
  `unbanned_ckey` varchar(32) DEFAULT NULL,
  `unbanned_computerid` varchar(32) DEFAULT NULL,
  `unbanned_ip` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`),
  KEY `computerid` (`computerid`),
  KEY `ip` (`ip`)
);

--
-- Table structure for table `changelog`
--

DROP TABLE IF EXISTS `changelog`;
CREATE TABLE `changelog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pr_number` int(11) NOT NULL,
  `date_merged` datetime NOT NULL DEFAULT current_timestamp(),
  `author` varchar(32) NOT NULL,
  `cl_type` enum('FIX','WIP','TWEAK','SOUNDADD','SOUNDDEL','CODEADD','CODEDEL','IMAGEADD','IMAGEDEL','SPELLCHECK','EXPERIMENT') NOT NULL,
  `cl_entry` text NOT NULL,
  PRIMARY KEY (`id`)
);

--
-- Table structure for table `characters`
--

DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `slot` int(2) NOT NULL,
  `OOC_Notes` longtext NOT NULL,
  `real_name` varchar(55) NOT NULL,
  `name_is_always_random` tinyint(1) NOT NULL,
  `gender` varchar(11) NOT NULL,
  `age` smallint(4) NOT NULL,
  `species` varchar(45) NOT NULL,
  `language` varchar(45) NOT NULL,
  `hair_colour` varchar(7) NOT NULL DEFAULT '#000000',
  `secondary_hair_colour` varchar(7) NOT NULL DEFAULT '#000000',
  `facial_hair_colour` varchar(7) NOT NULL DEFAULT '#000000',
  `secondary_facial_hair_colour` varchar(7) NOT NULL DEFAULT '#000000',
  `skin_tone` smallint(4) NOT NULL,
  `skin_colour` varchar(7) NOT NULL DEFAULT '#000000',
  `marking_colours` varchar(255) NOT NULL DEFAULT 'head=%23000000&body=%23000000&tail=%23000000',
  `head_accessory_colour` varchar(7) NOT NULL DEFAULT '#000000',
  `hair_style_name` varchar(45) NOT NULL,
  `facial_style_name` varchar(45) NOT NULL,
  `marking_styles` varchar(255) NOT NULL DEFAULT 'head=None&body=None&tail=None',
  `head_accessory_style_name` varchar(45) NOT NULL,
  `alt_head_name` varchar(45) NOT NULL,
  `eye_colour` varchar(7) NOT NULL DEFAULT '#000000',
  `underwear` longtext NOT NULL,
  `undershirt` longtext NOT NULL,
  `backbag` longtext DEFAULT NULL,
  `b_type` varchar(45) NOT NULL,
  `alternate_option` smallint(4) NOT NULL,
  `job_support_high` mediumint(8) NOT NULL,
  `job_support_med` mediumint(8) NOT NULL,
  `job_support_low` mediumint(8) NOT NULL,
  `job_medsci_high` mediumint(8) NOT NULL,
  `job_medsci_med` mediumint(8) NOT NULL,
  `job_medsci_low` mediumint(8) NOT NULL,
  `job_engsec_high` mediumint(8) NOT NULL,
  `job_engsec_med` mediumint(8) NOT NULL,
  `job_engsec_low` mediumint(8) NOT NULL,
  `job_karma_high` mediumint(8) NOT NULL,
  `job_karma_med` mediumint(8) NOT NULL,
  `job_karma_low` mediumint(8) NOT NULL,
  `flavor_text` longtext NOT NULL,
  `med_record` longtext NOT NULL,
  `sec_record` longtext NOT NULL,
  `gen_record` longtext NOT NULL,
  `disabilities` mediumint(8) NOT NULL,
  `player_alt_titles` longtext NOT NULL,
  `organ_data` longtext NOT NULL,
  `rlimb_data` longtext NOT NULL,
  `nanotrasen_relation` varchar(45) NOT NULL,
  `speciesprefs` int(1) NOT NULL,
  `socks` longtext NOT NULL,
  `body_accessory` longtext NOT NULL,
  `gear` longtext NOT NULL,
  `autohiss` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`)
);

--
-- Table structure for table `connection_log`
--

DROP TABLE IF EXISTS `connection_log`;
CREATE TABLE `connection_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `result` enum('ESTABLISHED','DROPPED - IPINTEL','DROPPED - BANNED','DROPPED - INVALID') NOT NULL DEFAULT 'ESTABLISHED',
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`),
  KEY `ip` (`ip`),
  KEY `computerid` (`computerid`)
);

--
-- Table structure for table `customuseritems`
--

DROP TABLE IF EXISTS `customuseritems`;
CREATE TABLE `customuseritems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cuiCKey` varchar(36) NOT NULL,
  `cuiRealName` varchar(60) NOT NULL,
  `cuiPath` varchar(255) NOT NULL,
  `cuiItemName` text DEFAULT NULL,
  `cuiDescription` text DEFAULT NULL,
  `cuiReason` text DEFAULT NULL,
  `cuiPropAdjust` text DEFAULT NULL,
  `cuiJobMask` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cuiCKey` (`cuiCKey`)
);

--
-- Table structure for table `db_metadata`
--

DROP TABLE IF EXISTS `db_metadata`;
CREATE TABLE `db_metadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sql_file` int(11) NOT NULL DEFAULT 0,
  `sql_version` int(11) NOT NULL DEFAULT 25,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `uuid` uuid NOT NULL DEFAULT uuid(),
  `version` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `date_created` (`date_created`)
);

--
-- Table structure for table `death`
--

DROP TABLE IF EXISTS `death`;
CREATE TABLE `death` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pod` text NOT NULL COMMENT 'Place of death',
  `coord` text NOT NULL COMMENT 'X, Y, Z POD',
  `tod` datetime NOT NULL COMMENT 'Time of death',
  `job` text NOT NULL,
  `special` text NOT NULL,
  `name` text NOT NULL,
  `byondkey` text NOT NULL,
  `laname` text NOT NULL COMMENT 'Last attacker name',
  `lakey` text NOT NULL COMMENT 'Last attacker key',
  `gender` text NOT NULL,
  `bruteloss` int(11) NOT NULL,
  `brainloss` int(11) NOT NULL,
  `fireloss` int(11) NOT NULL,
  `oxyloss` int(11) NOT NULL,
  PRIMARY KEY (`id`)
);

--
-- Table structure for table `donators`
--

DROP TABLE IF EXISTS `donators`;
CREATE TABLE `donators` (
  `patreon_name` varchar(32) NOT NULL,
  `tier` int(2) DEFAULT NULL,
  `ckey` varchar(32) DEFAULT NULL COMMENT 'Manual Field',
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`patreon_name`),
  KEY `ckey` (`ckey`)
);

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `round_id` int(8) NOT NULL,
  `key_name` varchar(32) NOT NULL,
  `key_type` enum('text','amount','tally','nested tally','associative') NOT NULL,
  `version` tinyint(3) unsigned NOT NULL,
  `json` longtext NOT NULL,
  PRIMARY KEY (`id`)
);

--
-- Table structure for table `ip2group`
--

DROP TABLE IF EXISTS `ip2group`;
CREATE TABLE `ip2group` (
  `ip` varchar(18) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `groupstr` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`ip`),
  KEY `groupstr` (`groupstr`)
);

--
-- Table structure for table `ipintel`
--

DROP TABLE IF EXISTS `ipintel`;
CREATE TABLE `ipintel` (
  `ip` int(10) unsigned NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `intel` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`ip`)
);

--
-- Table structure for table `karma`
--

DROP TABLE IF EXISTS `karma`;
CREATE TABLE `karma` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spendername` text NOT NULL,
  `spenderkey` text NOT NULL,
  `receivername` text NOT NULL,
  `receiverkey` text NOT NULL,
  `receiverrole` text DEFAULT NULL,
  `receiverspecial` text DEFAULT NULL,
  `isnegative` tinyint(1) DEFAULT NULL,
  `spenderip` text NOT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
);

--
-- Table structure for table `karmatotals`
--

DROP TABLE IF EXISTS `karmatotals`;
CREATE TABLE `karmatotals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `byondkey` varchar(30) NOT NULL,
  `karma` int(11) NOT NULL,
  `karmaspent` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `byondkey` (`byondkey`)
);

--
-- Table structure for table `legacy_population`
--

DROP TABLE IF EXISTS `legacy_population`;
CREATE TABLE `legacy_population` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playercount` int(11) DEFAULT NULL,
  `admincount` int(11) DEFAULT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
);

--
-- Table structure for table `library`
--

DROP TABLE IF EXISTS `library`;
CREATE TABLE `library` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` mediumtext NOT NULL,
  `title` mediumtext NOT NULL,
  `content` mediumtext NOT NULL,
  `category` mediumtext NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `flagged` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`),
  KEY `flagged` (`flagged`)
);

--
-- Table structure for table `memo`
--

DROP TABLE IF EXISTS `memo`;
CREATE TABLE `memo` (
  `ckey` varchar(32) NOT NULL,
  `memotext` text NOT NULL,
  `timestamp` datetime NOT NULL,
  `last_editor` varchar(32) DEFAULT NULL,
  `edits` text DEFAULT NULL,
  PRIMARY KEY (`ckey`)
);

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `notetext` text NOT NULL,
  `timestamp` datetime NOT NULL,
  `round_id` int(11) DEFAULT NULL,
  `adminckey` varchar(32) NOT NULL,
  `last_editor` varchar(32) DEFAULT NULL,
  `edits` text DEFAULT NULL,
  `server` varchar(50) NOT NULL,
  `crew_playtime` mediumint(8) unsigned DEFAULT 0,
  `automated` tinyint(3) unsigned DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`)
);

--
-- Table structure for table `oauth_tokens`
--

DROP TABLE IF EXISTS `oauth_tokens`;
CREATE TABLE `oauth_tokens` (
  `ckey` varchar(32) NOT NULL,
  `token` varchar(32) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `ckey` (`ckey`)
);

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `firstseen` datetime NOT NULL,
  `lastseen` datetime NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `lastadminrank` varchar(32) NOT NULL DEFAULT 'Player',
  `ooccolor` varchar(7) DEFAULT '#b82e00',
  `UI_style` varchar(10) DEFAULT 'Midnight',
  `UI_style_color` varchar(7) DEFAULT '#ffffff',
  `UI_style_alpha` smallint(4) DEFAULT 255,
  `be_role` longtext DEFAULT NULL,
  `default_slot` smallint(4) DEFAULT 1,
  `toggles` int(11) DEFAULT NULL,
  `toggles_2` int(11) DEFAULT 0,
  `sound` mediumint(8) DEFAULT 31,
  `volume_mixer` longtext DEFAULT NULL,
  `lastchangelog` varchar(32) NOT NULL DEFAULT '0',
  `exp` longtext DEFAULT NULL,
  `clientfps` smallint(4) DEFAULT 0,
  `atklog` smallint(4) DEFAULT 0,
  `fuid` bigint(20) DEFAULT NULL,
  `fupdate` smallint(4) DEFAULT 0,
  `parallax` tinyint(1) DEFAULT 8,
  `byond_date` date DEFAULT NULL,
  `2fa_status` enum('DISABLED','ENABLED_IP','ENABLED_ALWAYS') NOT NULL DEFAULT 'DISABLED',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ckey` (`ckey`),
  KEY `lastseen` (`lastseen`),
  KEY `computerid` (`computerid`),
  KEY `ip` (`ip`),
  KEY `fuid` (`fuid`),
  KEY `fupdate` (`fupdate`)
);

--
-- Table structure for table `playtime_history`
--

DROP TABLE IF EXISTS `playtime_history`;
CREATE TABLE `playtime_history` (
  `ckey` varchar(32) NOT NULL,
  `date` date NOT NULL,
  `time_living` smallint(6) NOT NULL,
  `time_ghost` smallint(6) NOT NULL,
  PRIMARY KEY (`ckey`,`date`)
);

--
-- Table structure for table `privacy`
--

DROP TABLE IF EXISTS `privacy`;
CREATE TABLE `privacy` (
  `ckey` varchar(32) NOT NULL,
  `datetime` datetime NOT NULL,
  `consent` bit(1) NOT NULL,
  PRIMARY KEY (`ckey`)
);

--
-- Table structure for table `round`
--

DROP TABLE IF EXISTS `round`;
CREATE TABLE `round` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `initialize_datetime` datetime NOT NULL,
  `start_datetime` datetime DEFAULT NULL,
  `shutdown_datetime` datetime DEFAULT NULL,
  `end_datetime` datetime DEFAULT NULL,
  `server_ip` int(10) unsigned NOT NULL,
  `server_port` smallint(5) unsigned NOT NULL,
  `commit_hash` char(40) DEFAULT NULL,
  `game_mode` varchar(32) DEFAULT NULL,
  `game_mode_result` varchar(64) DEFAULT NULL,
  `end_state` varchar(64) DEFAULT NULL,
  `shuttle_name` varchar(64) DEFAULT NULL,
  `map_name` varchar(32) DEFAULT NULL,
  `station_name` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

--
-- Table structure for table `vpn_whitelist`
--

DROP TABLE IF EXISTS `vpn_whitelist`;
CREATE TABLE `vpn_whitelist` (
  `ckey` varchar(32) NOT NULL,
  `reason` text DEFAULT NULL,
  PRIMARY KEY (`ckey`)
);

--
-- Table structure for table `watch`
--

DROP TABLE IF EXISTS `watch`;
CREATE TABLE `watch` (
  `ckey` varchar(32) NOT NULL,
  `reason` mediumtext NOT NULL,
  `timestamp` datetime NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `last_editor` varchar(32) DEFAULT NULL,
  `edits` mediumtext DEFAULT NULL,
  PRIMARY KEY (`ckey`)
);

--
-- Table structure for table `whitelist`
--

DROP TABLE IF EXISTS `whitelist`;
CREATE TABLE `whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `job` mediumtext DEFAULT NULL,
  `species` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ckey` (`ckey`)
);
