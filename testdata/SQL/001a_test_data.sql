-- 001a_test_data.sql

--
-- Insert some test data
--

INSERT INTO `characters` (`id`, `ckey`, `slot`, `OOC_Notes`, `real_name`, `name_is_always_random`, `gender`, `age`, `species`, `language`, `hair_colour`, `secondary_hair_colour`, `facial_hair_colour`, `secondary_facial_hair_colour`, `skin_tone`, `skin_colour`, `marking_colours`, `head_accessory_colour`, `hair_style_name`, `facial_style_name`, `marking_styles`, `head_accessory_style_name`, `alt_head_name`, `eye_colour`, `underwear`, `undershirt`, `backbag`, `b_type`, `alternate_option`, `job_support_high`, `job_support_med`, `job_support_low`, `job_medsci_high`, `job_medsci_med`, `job_medsci_low`, `job_engsec_high`, `job_engsec_med`, `job_engsec_low`, `job_karma_high`, `job_karma_med`, `job_karma_low`, `flavor_text`, `med_record`, `sec_record`, `gen_record`, `disabilities`, `player_alt_titles`, `organ_data`, `rlimb_data`, `nanotrasen_relation`, `speciesprefs`, `socks`, `body_accessory`, `gear`, `autohiss`, `date_created`, `date_updated`, `uuid`, `version`)
VALUES (1,'veloxi',1,'','Katlyn Hudson',0,'female',26,'Human','None','#ffff99','#000000','#ffff99','#000000',34,'#ffffcc','head=%23000000&body=%23000000&tail=%23000000','#000000','Spiky Ponytail','Shaved','head=None&body=Hive+Tattoo&tail=None','None','None','#0000ff','Ladies Black','I Love NT Shirt','Department Backpack','A+',2,0,0,4114,0,20,0,1,0,528,0,0,0,'','','','',0,'','','','Loyal',0,'Pantyhose','','lipstick%2c+red&Gold+ring&dress+shoes',0,'2025-01-18 21:30:24','2025-01-18 21:31:02','6d978a57-d5e3-11ef-bb75-0242ac110002',0);

INSERT INTO `player` (`id`, `ckey`, `firstseen`, `lastseen`, `ip`, `computerid`, `lastadminrank`, `ooccolor`, `UI_style`, `UI_style_color`, `UI_style_alpha`, `be_role`, `default_slot`, `toggles`, `toggles_2`, `sound`, `volume_mixer`, `lastchangelog`, `exp`, `clientfps`, `atklog`, `fuid`, `fupdate`, `parallax`, `byond_date`, `2fa_status`, `date_created`, `date_updated`, `uuid`, `version`)
VALUES (1,'veloxi','2025-01-18 21:25:59','2025-01-20 22:26:15','127.0.0.1','1234567890','Host','#b82e00','Midnight','#ffffff',255,'',1,14721343,4558,4079,'{\"1024\":100,\"1023\":100,\"1022\":100,\"1021\":100,\"1020\":100,\"1019\":100,\"1018\":100,\"1017\":100}','0',NULL,0,0,NULL,0,8,'2018-02-17','DISABLED','2025-01-18 21:25:59','2025-01-20 22:26:15','cf8e5157-d5e2-11ef-bb75-0242ac110002',0);

INSERT INTO `privacy` (`id`, `ckey`, `datetime`, `consent`, `date_created`, `date_updated`, `uuid`, `version`)
VALUES (1,'veloxi','2025-01-20 22:26:21',1,'2025-01-20 22:26:21','2025-01-20 22:26:21','9364a265-d77d-11ef-9a1e-0242ac110002',0);
