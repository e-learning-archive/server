-- MySQL dump 10.13  Distrib 5.7.28, for Linux (x86_64)
--
-- Host: localhost    Database: video
-- ------------------------------------------------------
-- Server version	5.7.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `video`;
USE `video`;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `clean_name` varchar(45) NOT NULL,
  `description` text,
  `nextVideoOrder` int(2) NOT NULL DEFAULT '0',
  `parentId` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `iconClass` varchar(45) NOT NULL DEFAULT 'fa fa-folder',
  `users_id` int(11) NOT NULL DEFAULT '1',
  `private` tinyint(1) DEFAULT '0',
  `allow_download` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `clean_name_UNIQUE` (`clean_name`),
  KEY `fk_categories_users1_idx` (`users_id`),
  CONSTRAINT `fk_categories_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Default','default','',0,0,'2019-12-04 14:54:46','2019-12-04 14:54:46','fa fa-folder',1,0,1),(2,'Funny','funny','',1,0,'2019-12-04 15:25:09','2019-12-04 15:25:09','far fa-smile',1,1,0);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_type_cache`
--

DROP TABLE IF EXISTS `category_type_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category_type_cache` (
  `categoryId` int(11) NOT NULL,
  `type` int(2) NOT NULL DEFAULT '0' COMMENT '0=both, 1=audio, 2=video',
  `manualSet` int(1) NOT NULL DEFAULT '0' COMMENT '0=auto, 1=manual',
  UNIQUE KEY `categoryId` (`categoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_type_cache`
--

LOCK TABLES `category_type_cache` WRITE;
/*!40000 ALTER TABLE `category_type_cache` DISABLE KEYS */;
INSERT INTO `category_type_cache` VALUES (1,2,0),(2,0,0),(3,0,0);
/*!40000 ALTER TABLE `category_type_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` text NOT NULL,
  `videos_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `comments_id_pai` int(11) DEFAULT NULL,
  `pin` int(1) NOT NULL DEFAULT '0' COMMENT 'If = 1 will be on the top',
  PRIMARY KEY (`id`),
  KEY `fk_comments_videos1_idx` (`videos_id`),
  KEY `fk_comments_users1_idx` (`users_id`),
  KEY `fk_comments_comments1_idx` (`comments_id_pai`),
  CONSTRAINT `fk_comments_comments1` FOREIGN KEY (`comments_id_pai`) REFERENCES `comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comments_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comments_videos1` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_likes`
--

DROP TABLE IF EXISTS `comments_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `like` int(1) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `users_id` int(11) NOT NULL,
  `comments_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_comments_likes_users1_idx` (`users_id`),
  KEY `fk_comments_likes_comments1_idx` (`comments_id`),
  CONSTRAINT `fk_comments_likes_comments1` FOREIGN KEY (`comments_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comments_likes_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_likes`
--

LOCK TABLES `comments_likes` WRITE;
/*!40000 ALTER TABLE `comments_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configurations`
--

DROP TABLE IF EXISTS `configurations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configurations` (
  `id` int(11) NOT NULL,
  `video_resolution` varchar(12) NOT NULL,
  `users_id` int(11) NOT NULL,
  `version` varchar(10) NOT NULL,
  `webSiteTitle` varchar(45) NOT NULL DEFAULT 'AVideo',
  `language` varchar(6) NOT NULL DEFAULT 'en',
  `contactEmail` varchar(45) NOT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `authGoogle_id` varchar(255) DEFAULT NULL,
  `authGoogle_key` varchar(255) DEFAULT NULL,
  `authGoogle_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `authFacebook_id` varchar(255) DEFAULT NULL,
  `authFacebook_key` varchar(255) DEFAULT NULL,
  `authFacebook_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `authCanUploadVideos` tinyint(1) NOT NULL DEFAULT '0',
  `authCanViewChart` tinyint(2) NOT NULL DEFAULT '0',
  `authCanComment` tinyint(1) NOT NULL DEFAULT '1',
  `head` text,
  `logo` varchar(255) DEFAULT NULL,
  `logo_small` varchar(255) DEFAULT NULL,
  `adsense` text,
  `mode` enum('Youtube','Gallery') DEFAULT 'Youtube',
  `disable_analytics` tinyint(1) DEFAULT '0',
  `disable_youtubeupload` tinyint(1) DEFAULT '0',
  `allow_download` tinyint(1) DEFAULT '0',
  `session_timeout` int(11) DEFAULT '3600',
  `autoplay` tinyint(1) DEFAULT NULL,
  `theme` varchar(45) DEFAULT 'default',
  `smtp` tinyint(1) DEFAULT NULL,
  `smtpAuth` tinyint(1) DEFAULT NULL,
  `smtpSecure` varchar(255) DEFAULT NULL COMMENT '''ssl''; // secure transfer enabled REQUIRED for Gmail',
  `smtpHost` varchar(255) DEFAULT NULL COMMENT '"smtp.gmail.com"',
  `smtpUsername` varchar(255) DEFAULT NULL COMMENT '"email@gmail.com"',
  `smtpPassword` varchar(255) DEFAULT NULL,
  `smtpPort` int(11) DEFAULT NULL,
  `encoderURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_configurations_users1_idx` (`users_id`),
  CONSTRAINT `fk_configurations_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configurations`
--

LOCK TABLES `configurations` WRITE;
/*!40000 ALTER TABLE `configurations` DISABLE KEYS */;
INSERT INTO `configurations` VALUES (1,'858:480',1,'8.0','Gulu lectures','us','nope@none.com','2019-12-04 14:54:46','2019-12-04 14:54:46',NULL,NULL,0,NULL,NULL,0,0,0,0,'','videos/userPhoto/logo.png','view/img/logo32.png','','Youtube',1,1,1,3600,0,'darkly',0,0,'','','','',0,'ENCODER_URL');
/*!40000 ALTER TABLE `configurations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `like` int(1) NOT NULL DEFAULT '0' COMMENT '1 = Like\n0 = Does not metter\n-1 = Dislike',
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `videos_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_likes_videos1_idx` (`videos_id`),
  KEY `fk_likes_users1_idx` (`users_id`),
  CONSTRAINT `fk_likes_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_likes_videos1` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists`
--

DROP TABLE IF EXISTS `playlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `users_id` int(11) NOT NULL,
  `status` enum('public','private','unlisted','favorite','watch_later') NOT NULL DEFAULT 'public',
  PRIMARY KEY (`id`),
  KEY `fk_playlists_users1_idx` (`users_id`),
  CONSTRAINT `fk_playlists_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists`
--

LOCK TABLES `playlists` WRITE;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
INSERT INTO `playlists` VALUES (1,'Favorite','2019-12-05 09:31:27','2019-12-05 09:31:27',2,'favorite'),(2,'Watch Later','2019-12-05 09:31:27','2019-12-05 09:31:27',2,'watch_later');
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists_has_videos`
--

DROP TABLE IF EXISTS `playlists_has_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `playlists_has_videos` (
  `playlists_id` int(11) NOT NULL,
  `videos_id` int(11) NOT NULL,
  `order` int(11) DEFAULT NULL,
  PRIMARY KEY (`playlists_id`,`videos_id`),
  KEY `fk_playlists_has_videos_videos1_idx` (`videos_id`),
  KEY `fk_playlists_has_videos_playlists1_idx` (`playlists_id`),
  CONSTRAINT `fk_playlists_has_videos_playlists1` FOREIGN KEY (`playlists_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_playlists_has_videos_videos1` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists_has_videos`
--

LOCK TABLES `playlists_has_videos` WRITE;
/*!40000 ALTER TABLE `playlists_has_videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `playlists_has_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugins`
--

DROP TABLE IF EXISTS `plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plugins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(45) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `object_data` text,
  `name` varchar(255) NOT NULL,
  `dirName` varchar(255) NOT NULL,
  `pluginversion` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid_UNIQUE` (`uuid`),
  KEY `plugin_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugins`
--

LOCK TABLES `plugins` WRITE;
/*!40000 ALTER TABLE `plugins` DISABLE KEYS */;
INSERT INTO `plugins` VALUES (1,'55a4fa56-8a30-48d4-a0fb-8aa6b3f69033','active','2019-12-05 08:52:54','2019-12-05 15:44:21','{\"logoMenuBarURL\":\"STREAMER_URL\",\"encoderNetwork\":\"https://network.avideo.com/\",\"useEncoderNetworkRecomendation\":false,\"doNotShowEncoderNetwork\":true,\"doNotShowUploadButton\":false,\"uploadButtonDropdownIcon\":\"fas fa-video\",\"uploadButtonDropdownText\":\"\",\"encoderNetworkLabel\":\"\",\"doNotShowUploadMP4Button\":true,\"disablePDFUpload\":false,\"uploadMP4ButtonLabel\":\"\",\"doNotShowImportMP4Button\":true,\"importMP4ButtonLabel\":\"\",\"doNotShowEncoderButton\":false,\"encoderButtonLabel\":\"\",\"doNotShowEmbedButton\":false,\"embedBackgroundColor\":\"white\",\"embedButtonLabel\":\"\",\"doNotShowEncoderHLS\":false,\"doNotShowEncoderResolutionLow\":false,\"doNotShowEncoderResolutionSD\":false,\"doNotShowEncoderResolutionHD\":false,\"doNotShowLeftMenuAudioAndVideoButtons\":false,\"doNotShowWebsiteOnContactForm\":false,\"doNotUseXsendFile\":true,\"makeVideosInactiveAfterEncode\":false,\"usePermalinks\":false,\"disableAnimatedGif\":false,\"removeBrowserChannelLinkFromMenu\":false,\"EnableWavesurfer\":false,\"EnableMinifyJS\":false,\"disableShareAndPlaylist\":false,\"disableEmailSharing\":false,\"disableComments\":false,\"commentsMaxLength\":\"200\",\"commentsNoIndex\":false,\"disableYoutubePlayerIntegration\":false,\"utf8Encode\":false,\"utf8Decode\":false,\"menuBarHTMLCode\":{\"type\":\"textarea\",\"value\":\"\"},\"underMenuBarHTMLCode\":{\"type\":\"textarea\",\"value\":\"\"},\"footerHTMLCode\":{\"type\":\"textarea\",\"value\":\"\"},\"signInOnRight\":true,\"signInOnLeft\":true,\"forceCategory\":false,\"autoPlayAjax\":false,\"disableHelpLeftMenu\":false,\"disableAboutLeftMenu\":false,\"disableContactLeftMenu\":false,\"disableNavbar\":false,\"videosCDN\":\"\",\"useFFMPEGToGenerateThumbs\":false,\"showImageDownloadOption\":false,\"doNotDisplayViews\":false,\"doNotDisplayLikes\":false,\"doNotDisplayCategoryLeftMenu\":false,\"doNotDisplayCategory\":false,\"doNotDisplayGroupsTags\":false,\"doNotDisplayPluginsTags\":false,\"showNotRatedLabel\":false,\"askRRatingConfirmationBeforePlay_G\":false,\"askRRatingConfirmationBeforePlay_PG\":false,\"askRRatingConfirmationBeforePlay_PG13\":false,\"askRRatingConfirmationBeforePlay_R\":false,\"askRRatingConfirmationBeforePlay_NC17\":true,\"askRRatingConfirmationBeforePlay_MA\":true,\"AsyncJobs\":false,\"doNotShowLeftHomeButton\":false,\"doNotShowLeftTrendingButton\":false,\"CategoryLabel\":\"Categories\",\"ShowAllVideosOnCategory\":false,\"hideCategoryVideosCount\":false,\"paidOnlyUsersTellWhatVideoIs\":false,\"paidOnlyShowLabels\":false,\"paidOnlyLabel\":\"Premium\",\"paidOnlyFreeLabel\":\"Free\",\"removeSubscribeButton\":false,\"removeThumbsUpAndDown\":false,\"videoNotFoundText\":{\"type\":\"textarea\",\"value\":\"\"},\"siteMapRowsLimit\":\"100\",\"enableOldPassHashCheck\":true,\"disableHTMLDescription\":false}','CustomizeAdvanced','CustomizeAdvanced','1.0'),(2,'4c1f4f76-b336-4ddc-a4de-184efe715c09','active','2019-12-05 09:34:42','2019-12-05 10:24:29','{\"doNotAllowAnonimusAccess\":false,\"doNotAllowUpload\":true,\"hideCreateAccount\":true,\"hideTabTrending\":true,\"hideTabLive\":true,\"hideTabSubscription\":true,\"hideTabPlayLists\":false,\"EULA\":{\"type\":\"textarea\",\"value\":\"Welcome to Gulu University video lectures\"},\"themeDark\":true,\"portraitImage\":false,\"netflixStyle\":false,\"netflixDateAdded\":true,\"netflixMostPopular\":true,\"netflixMostWatched\":true,\"netflixCategories\":true,\"netflixBigVideo\":true,\"disableWhitelabel\":false}','MobileManager','MobileManager','1.0'),(3,'1apicbec-91db-4357-bb10-ee08b0913778','active','2019-12-05 10:19:16','2019-12-05 10:19:16',NULL,'API','API','1.0');
/*!40000 ALTER TABLE `plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `secret` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscribes`
--

DROP TABLE IF EXISTS `subscribes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscribes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `status` enum('a','i') NOT NULL DEFAULT 'a',
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `users_id` int(11) NOT NULL DEFAULT '1' COMMENT 'subscribes to user channel',
  `notify` tinyint(1) NOT NULL DEFAULT '1',
  `subscriber_users_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_subscribes_users1_idx` (`users_id`),
  KEY `fk_subscribes_users2_idx` (`subscriber_users_id`),
  CONSTRAINT `fk_subscribes_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_subscribes_users2` FOREIGN KEY (`subscriber_users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscribes`
--

LOCK TABLES `subscribes` WRITE;
/*!40000 ALTER TABLE `subscribes` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscribes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(45) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(145) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('a','i') NOT NULL DEFAULT 'a',
  `photoURL` varchar(255) DEFAULT NULL,
  `lastLogin` datetime DEFAULT NULL,
  `recoverPass` varchar(255) DEFAULT NULL,
  `backgroundURL` varchar(255) DEFAULT NULL,
  `canStream` tinyint(1) DEFAULT NULL,
  `canUpload` tinyint(1) DEFAULT NULL,
  `canViewChart` tinyint(1) NOT NULL DEFAULT '0',
  `about` text,
  `channelName` varchar(45) DEFAULT NULL,
  `emailVerified` tinyint(1) NOT NULL DEFAULT '0',
  `analyticsCode` varchar(45) DEFAULT NULL,
  `externalOptions` text,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `zip_code` varchar(45) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `donationLink` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_UNIQUE` (`user`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','','nope@none.com','fcbc6f8eb22ea649e8c9da9c016c2bea','2019-12-04 14:54:46','2019-12-05 15:19:06',1,'a',NULL,'2019-12-05 15:19:06',NULL,NULL,0,0,0,'','5de7c8f4d427f',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_blob`
--

DROP TABLE IF EXISTS `users_blob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_blob` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blob` longblob,
  `users_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_document_image_users1_idx` (`users_id`),
  CONSTRAINT `fk_users_document_image_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_blob`
--

LOCK TABLES `users_blob` WRITE;
/*!40000 ALTER TABLE `users_blob` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_blob` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_groups`
--

DROP TABLE IF EXISTS `users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(45) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_groups`
--

LOCK TABLES `users_groups` WRITE;
/*!40000 ALTER TABLE `users_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_has_users_groups`
--

DROP TABLE IF EXISTS `users_has_users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_has_users_groups` (
  `users_id` int(11) NOT NULL,
  `users_groups_id` int(11) NOT NULL,
  PRIMARY KEY (`users_id`,`users_groups_id`),
  UNIQUE KEY `index_user_groups_unique` (`users_groups_id`,`users_id`),
  KEY `fk_users_has_users_groups_users_groups1_idx` (`users_groups_id`),
  KEY `fk_users_has_users_groups_users1_idx` (`users_id`),
  CONSTRAINT `fk_users_has_users_groups_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_users_has_users_groups_users_groups1` FOREIGN KEY (`users_groups_id`) REFERENCES `users_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_has_users_groups`
--

LOCK TABLES `users_has_users_groups` WRITE;
/*!40000 ALTER TABLE `users_has_users_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_has_users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(190) NOT NULL,
  `clean_title` varchar(190) NOT NULL,
  `description` text,
  `views_count` int(11) NOT NULL DEFAULT '0',
  `views_count_25` int(11) DEFAULT '0',
  `views_count_50` int(11) DEFAULT '0',
  `views_count_75` int(11) DEFAULT '0',
  `views_count_100` int(11) DEFAULT '0',
  `status` enum('a','i','e','x','d','xmp4','xwebm','xmp3','xogg','ximg','u','p','t') NOT NULL DEFAULT 'e' COMMENT 'a = active\ni = inactive\ne = encoding\nx = encoding error\nd = downloading\nu = Unlisted\np = private\nxmp4 = encoding mp4 error \nxwebm = encoding webm error \nxmp3 = encoding mp3 error \nxogg = encoding ogg error \nximg = get image error\nt = Transfering',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `users_id` int(11) NOT NULL,
  `categories_id` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `duration` varchar(15) NOT NULL,
  `type` enum('audio','video','embed','linkVideo','linkAudio','torrent','pdf','image','gallery','article','serie') NOT NULL DEFAULT 'video',
  `videoDownloadedLink` varchar(255) DEFAULT NULL,
  `order` int(10) unsigned NOT NULL DEFAULT '1',
  `rotation` smallint(6) DEFAULT '0',
  `zoom` float DEFAULT '1',
  `youtubeId` varchar(45) DEFAULT NULL,
  `videoLink` varchar(255) DEFAULT NULL,
  `next_videos_id` int(11) DEFAULT NULL,
  `isSuggested` int(1) NOT NULL DEFAULT '0',
  `trailer1` varchar(255) DEFAULT NULL,
  `trailer2` varchar(255) DEFAULT NULL,
  `trailer3` varchar(255) DEFAULT NULL,
  `rate` float(4,2) DEFAULT NULL,
  `can_download` tinyint(1) DEFAULT NULL,
  `can_share` tinyint(1) DEFAULT NULL,
  `rrating` varchar(45) DEFAULT NULL,
  `externalOptions` text,
  `only_for_paid` tinyint(1) DEFAULT NULL,
  `serie_playlists_id` int(11) DEFAULT NULL,
  `sites_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clean_title_UNIQUE` (`clean_title`),
  KEY `fk_videos_users_idx` (`users_id`),
  KEY `fk_videos_categories1_idx` (`categories_id`),
  KEY `index5` (`order`),
  KEY `fk_videos_videos1_idx` (`next_videos_id`),
  KEY `fk_videos_sites1_idx` (`sites_id`),
  KEY `fk_videos_playlists1` (`serie_playlists_id`),
  KEY `videos_status_index` (`status`),
  KEY `is_suggested_index` (`isSuggested`),
  KEY `views_count_index` (`views_count`),
  KEY `filename_index` (`filename`),
  CONSTRAINT `fk_videos_categories1` FOREIGN KEY (`categories_id`) REFERENCES `categories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_videos_playlists1` FOREIGN KEY (`serie_playlists_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_videos_sites1` FOREIGN KEY (`sites_id`) REFERENCES `sites` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_videos_users` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_videos_videos1` FOREIGN KEY (`next_videos_id`) REFERENCES `videos` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos_group_view`
--

DROP TABLE IF EXISTS `videos_group_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos_group_view` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `users_groups_id` int(11) NOT NULL,
  `videos_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_videos_group_view_users_groups1_idx` (`users_groups_id`),
  KEY `fk_videos_group_view_videos1_idx` (`videos_id`),
  CONSTRAINT `fk_videos_group_view_users_groups1` FOREIGN KEY (`users_groups_id`) REFERENCES `users_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_videos_group_view_videos1` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos_group_view`
--

LOCK TABLES `videos_group_view` WRITE;
/*!40000 ALTER TABLE `videos_group_view` DISABLE KEYS */;
/*!40000 ALTER TABLE `videos_group_view` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos_statistics`
--

DROP TABLE IF EXISTS `videos_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `when` datetime NOT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `users_id` int(11) DEFAULT NULL,
  `videos_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `lastVideoTime` int(11) DEFAULT NULL,
  `session_id` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_videos_statistics_users1_idx` (`users_id`),
  KEY `fk_videos_statistics_videos1_idx` (`videos_id`),
  KEY `when_statisci` (`when`),
  KEY `session_id_statistics` (`session_id`),
  CONSTRAINT `fk_videos_statistics_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_videos_statistics_videos1` FOREIGN KEY (`videos_id`) REFERENCES `videos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos_statistics`
--

LOCK TABLES `videos_statistics` WRITE;
/*!40000 ALTER TABLE `videos_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `videos_statistics` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-05 15:47:15
