-- MySQL dump 10.13  Distrib 5.5.31, for osx10.6 (i386)
--
-- Host: 127.0.0.1    Database: tixing_development
-- ------------------------------------------------------
-- Server version	5.5.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `timezone` int(11) DEFAULT '8',
  PRIMARY KEY (`id`),
  KEY `index_devices_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feedbacks`
--

DROP TABLE IF EXISTS `feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `memo` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `installations`
--

DROP TABLE IF EXISTS `installations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `installations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `preferences` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_installations_on_user_id_and_service_id` (`user_id`,`service_id`),
  KEY `index_installations_on_user_id` (`user_id`),
  KEY `index_installations_on_service_id` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jingdong_monitorings`
--

DROP TABLE IF EXISTS `jingdong_monitorings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jingdong_monitorings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `threshold` decimal(10,0) DEFAULT NULL,
  `disabled` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_jingdong_monitorings_on_product_id_and_user_id` (`product_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jingdong_prices`
--

DROP TABLE IF EXISTS `jingdong_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jingdong_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) DEFAULT NULL,
  `price` decimal(8,1) DEFAULT NULL,
  `promotion` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_jingdong_prices_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jingdong_products`
--

DROP TABLE IF EXISTS `jingdong_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jingdong_products` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `price` decimal(8,1) DEFAULT NULL,
  `monitorings_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `netease_monitorings`
--

DROP TABLE IF EXISTS `netease_monitorings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `netease_monitorings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `keyword` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `options` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_netease_monitorings_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sound` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `web_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ipad_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `highlight` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notifications_on_user_id` (`user_id`),
  KEY `index_notifications_on_deleted_at` (`deleted_at`),
  KEY `index_notifications_on_service_id` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpush_apps`
--

DROP TABLE IF EXISTS `rpush_apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpush_apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `environment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `certificate` text COLLATE utf8_unicode_ci,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `connections` int(11) NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `auth_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `access_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `access_token_expiration` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpush_feedback`
--

DROP TABLE IF EXISTS `rpush_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpush_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_token` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `failed_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `app_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rpush_feedback_on_device_token` (`device_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rpush_notifications`
--

DROP TABLE IF EXISTS `rpush_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpush_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `badge` int(11) DEFAULT NULL,
  `device_token` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sound` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'default',
  `alert` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `expiry` int(11) DEFAULT '86400',
  `delivered` tinyint(1) NOT NULL DEFAULT '0',
  `delivered_at` datetime DEFAULT NULL,
  `failed` tinyint(1) NOT NULL DEFAULT '0',
  `failed_at` datetime DEFAULT NULL,
  `error_code` int(11) DEFAULT NULL,
  `error_description` text COLLATE utf8_unicode_ci,
  `deliver_after` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `alert_is_json` tinyint(1) DEFAULT '0',
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `collapse_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delay_while_idle` tinyint(1) NOT NULL DEFAULT '0',
  `registration_ids` mediumtext COLLATE utf8_unicode_ci,
  `app_id` int(11) NOT NULL,
  `retries` int(11) DEFAULT '0',
  `uri` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fail_after` datetime DEFAULT NULL,
  `processing` tinyint(1) NOT NULL DEFAULT '0',
  `priority` int(11) DEFAULT NULL,
  `url_args` text COLLATE utf8_unicode_ci,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rapns_notifications_multi` (`app_id`,`delivered`,`failed`,`deliver_after`),
  KEY `index_rpush_notifications_multi` (`delivered`,`failed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `var` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `value` text COLLATE utf8_unicode_ci,
  `thing_id` int(11) DEFAULT NULL,
  `thing_type` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_settings_on_thing_type_and_thing_id_and_var` (`thing_type`,`thing_id`,`var`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shunfeng_monitorings`
--

DROP TABLE IF EXISTS `shunfeng_monitorings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shunfeng_monitorings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `threshold` decimal(10,0) DEFAULT NULL,
  `disabled` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_shunfeng_monitorings_on_product_id_and_user_id` (`product_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shunfeng_products`
--

DROP TABLE IF EXISTS `shunfeng_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shunfeng_products` (
  `id` bigint(20) NOT NULL,
  `sku` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `promotion` varchar(255) DEFAULT NULL,
  `price` decimal(8,1) DEFAULT NULL,
  `monitorings_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sounds`
--

DROP TABLE IF EXISTS `sounds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sounds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `package` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_digest` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `auth_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sound` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'tixing',
  `silent_at_night` tinyint(1) DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `disabled` tinyint(1) DEFAULT '0',
  `reg_user_agent` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reg_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_name` (`name`),
  KEY `index_users_on_auth_token` (`auth_token`),
  KEY `index_users_on_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `v2ex_monitorings`
--

DROP TABLE IF EXISTS `v2ex_monitorings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `v2ex_monitorings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `keyword` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_v2ex_monitorings_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weibo_followers`
--

DROP TABLE IF EXISTS `weibo_followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weibo_followers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `keyword` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sound` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_weibo_followers_on_uid_and_user_id` (`uid`,`user_id`),
  KEY `index_weibo_followers_on_user_id` (`user_id`),
  KEY `index_weibo_followers_on_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weibo_users`
--

DROP TABLE IF EXISTS `weibo_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weibo_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metadata` text COLLATE utf8_unicode_ci,
  `priority` int(11) DEFAULT '0',
  `last_weibo_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_checked_at` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `followers_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_weibo_users_on_uid` (`uid`),
  KEY `index_weibo_users_on_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-07 22:21:50
INSERT INTO schema_migrations (version) VALUES ('20141013122113');

INSERT INTO schema_migrations (version) VALUES ('20141014004947');

INSERT INTO schema_migrations (version) VALUES ('20141014012017');

INSERT INTO schema_migrations (version) VALUES ('20141014012543');

INSERT INTO schema_migrations (version) VALUES ('20141014013340');

INSERT INTO schema_migrations (version) VALUES ('20141014060940');

INSERT INTO schema_migrations (version) VALUES ('20141014061339');

INSERT INTO schema_migrations (version) VALUES ('20141023110203');

INSERT INTO schema_migrations (version) VALUES ('20141024011559');

INSERT INTO schema_migrations (version) VALUES ('20141024101513');

INSERT INTO schema_migrations (version) VALUES ('20141025043508');

INSERT INTO schema_migrations (version) VALUES ('20141025150328');

INSERT INTO schema_migrations (version) VALUES ('20141027211217');

INSERT INTO schema_migrations (version) VALUES ('20141028040640');

INSERT INTO schema_migrations (version) VALUES ('20141031061651');

INSERT INTO schema_migrations (version) VALUES ('20141102051625');

INSERT INTO schema_migrations (version) VALUES ('20141109083233');

INSERT INTO schema_migrations (version) VALUES ('20141110050959');

INSERT INTO schema_migrations (version) VALUES ('20141112085439');

INSERT INTO schema_migrations (version) VALUES ('20141112085440');

INSERT INTO schema_migrations (version) VALUES ('20141112085441');

INSERT INTO schema_migrations (version) VALUES ('20141116072654');

INSERT INTO schema_migrations (version) VALUES ('20141117133911');

INSERT INTO schema_migrations (version) VALUES ('20141121070045');

INSERT INTO schema_migrations (version) VALUES ('20141122141501');

INSERT INTO schema_migrations (version) VALUES ('20141123034606');

INSERT INTO schema_migrations (version) VALUES ('20141123112748');

INSERT INTO schema_migrations (version) VALUES ('20141129085454');

INSERT INTO schema_migrations (version) VALUES ('20141129133304');

INSERT INTO schema_migrations (version) VALUES ('20141201013919');

INSERT INTO schema_migrations (version) VALUES ('20141201074858');

INSERT INTO schema_migrations (version) VALUES ('20141201082525');

INSERT INTO schema_migrations (version) VALUES ('20141203035556');

INSERT INTO schema_migrations (version) VALUES ('20141203040411');

INSERT INTO schema_migrations (version) VALUES ('20141204021430');

INSERT INTO schema_migrations (version) VALUES ('20141204142341');

INSERT INTO schema_migrations (version) VALUES ('20141205035830');

INSERT INTO schema_migrations (version) VALUES ('20141205064620');

INSERT INTO schema_migrations (version) VALUES ('20141205075754');

INSERT INTO schema_migrations (version) VALUES ('20141207142042');

