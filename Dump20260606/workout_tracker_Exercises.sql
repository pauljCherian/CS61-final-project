-- MySQL dump 10.13  Distrib 8.0.45, for macos15 (arm64)
--
-- Host: 127.0.0.1    Database: workout_tracker
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'ffecb282-2d27-11f1-ad49-01e67fc86fd3:1-685';

--
-- Table structure for table `Exercises`
--

DROP TABLE IF EXISTS `Exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Exercises` (
  `ExerciseID` int NOT NULL AUTO_INCREMENT,
  `ExerciseName` varchar(150) NOT NULL,
  PRIMARY KEY (`ExerciseID`),
  UNIQUE KEY `ExerciseName` (`ExerciseName`)
) ENGINE=InnoDB AUTO_INCREMENT=156 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Exercises`
--

LOCK TABLES `Exercises` WRITE;
/*!40000 ALTER TABLE `Exercises` DISABLE KEYS */;
INSERT INTO `Exercises` VALUES (85,'abs'),(49,'atg back extension'),(89,'atg rotator cuff'),(93,'atg shoulder roto'),(81,'back extension'),(21,'back squat'),(44,'backwards resistance treadmill'),(26,'barbell row'),(63,'bb high pull'),(65,'bb pendlay row'),(64,'bb reverse row'),(62,'bb row'),(18,'bench'),(61,'bench complex'),(1,'Bench Press'),(144,'bulgarian split squats'),(117,'cable curl'),(55,'cable face pull'),(112,'cable row'),(132,'cable row ss'),(126,'calf machine'),(153,'chest flies'),(71,'chest fly'),(11,'clean'),(17,'clean + jerk'),(60,'clean complex'),(12,'clean pull'),(78,'close grip bench'),(54,'ctb pull ups'),(66,'curl circuit'),(143,'db alt curl'),(38,'db bench'),(45,'db calf raise'),(90,'db curl'),(72,'db floor press'),(137,'db hammer curl'),(136,'db hammer curls'),(70,'db inc bench'),(4,'db inc curl'),(135,'db inc curls'),(104,'db inc press'),(149,'db lunges'),(105,'db raise'),(43,'db rdl'),(30,'db rotator cuff'),(74,'db row'),(114,'db skull'),(83,'db snatch'),(79,'db tri extension'),(139,'db walking lunges'),(6,'deadlift'),(67,'deadlifts'),(109,'decline ab'),(22,'decline bench'),(24,'decline push up'),(118,'decline sit up'),(130,'decline sit ups'),(124,'dip'),(36,'dips'),(127,'dragon ab'),(131,'dragon ab raise'),(138,'dragon leg raise'),(88,'face pull'),(23,'floor bench'),(50,'forwards resistance treadmill'),(103,'front rack lunge'),(16,'front squat'),(29,'ghd back extension'),(39,'ghd back extensions'),(20,'ghd sit up'),(107,'ghd sit ups'),(119,'hammer curl'),(76,'hang snatch'),(99,'hanging knee raise'),(5,'hanging leg raises'),(111,'inc db bench'),(146,'inc sit up'),(120,'incline bench'),(150,'incline sit up'),(123,'katana tri'),(94,'kb shoulder walks'),(52,'kot elevated lunge'),(73,'landmine press'),(110,'lat pd'),(96,'lat push down'),(121,'lat raise'),(125,'leg extension'),(151,'machine calf raise'),(155,'machine press'),(87,'machine row'),(91,'overhead rope tri'),(51,'overhead squat'),(115,'overhead v tri'),(100,'pause front squat'),(10,'pause squat'),(122,'pec dec'),(2,'power clean'),(68,'power clean complex'),(41,'power snatch'),(154,'preacher curl'),(141,'preacher machine'),(13,'pull up'),(7,'pull ups'),(46,'push jerk'),(58,'push press'),(57,'push ups'),(134,'push ups as'),(133,'reverse lat pd ss'),(35,'ring pull ups'),(14,'ring row'),(98,'rope ab'),(129,'rope cable tri'),(128,'rope face pull'),(97,'rope hammer curl'),(56,'rope pulldown'),(84,'rope tri'),(80,'row circuit'),(59,'sa db press'),(33,'sa db row'),(53,'sa db snatch'),(31,'sa kb overhead squat'),(95,'sa kb press'),(25,'seated press'),(32,'seated strict press'),(34,'segmented clean + hang power clean'),(28,'segmented clean deadlift + hang power clean'),(142,'side raises'),(140,'single leg db rdl'),(147,'sl calf raise'),(102,'sled push'),(145,'slow leg extension'),(148,'slow pull ups'),(9,'snatch'),(40,'snatch balance'),(48,'snatch complex'),(75,'snatch high pull'),(15,'snatch pull'),(27,'split jerk'),(42,'squat'),(47,'strict ctb'),(19,'strict hspu'),(3,'strict press'),(108,'tempo deadlift'),(116,'thrusters'),(152,'tri overhead'),(106,'tri push down'),(8,'ttb'),(69,'underhand fly'),(37,'v-ups'),(101,'walking db lunge'),(113,'walking db lungs'),(92,'wall ball'),(86,'weighted pull up'),(82,'weighted pull ups'),(77,'wide grip bench');
/*!40000 ALTER TABLE `Exercises` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-06 13:09:44
