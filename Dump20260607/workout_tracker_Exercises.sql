-- MySQL dump 10.13  Distrib 9.6.0, for macos15 (arm64)
--
-- Host: localhost    Database: workout_tracker
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'ee1dfa1e-2d60-11f1-a222-79c67808bc96:1-733';

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
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Exercises`
--

LOCK TABLES `Exercises` WRITE;
/*!40000 ALTER TABLE `Exercises` DISABLE KEYS */;
INSERT INTO `Exercises` VALUES (84,'abs'),(48,'atg back extension'),(88,'atg rotator cuff'),(92,'atg shoulder roto'),(80,'back extension'),(20,'back squat'),(43,'backwards resistance treadmill'),(25,'barbell row'),(62,'bb high pull'),(64,'bb pendlay row'),(63,'bb reverse row'),(61,'bb row'),(17,'bench'),(60,'bench complex'),(143,'bulgarian split squats'),(116,'cable curl'),(54,'cable face pull'),(111,'cable row'),(131,'cable row ss'),(125,'calf machine'),(152,'chest flies'),(70,'chest fly'),(10,'clean'),(16,'clean + jerk'),(59,'clean complex'),(11,'clean pull'),(77,'close grip bench'),(53,'ctb pull ups'),(65,'curl circuit'),(142,'db alt curl'),(37,'db bench'),(44,'db calf raise'),(89,'db curl'),(71,'db floor press'),(136,'db hammer curl'),(135,'db hammer curls'),(69,'db inc bench'),(3,'db inc curl'),(134,'db inc curls'),(103,'db inc press'),(148,'db lunges'),(104,'db raise'),(42,'db rdl'),(29,'db rotator cuff'),(73,'db row'),(113,'db skull'),(82,'db snatch'),(78,'db tri extension'),(138,'db walking lunges'),(5,'deadlift'),(66,'deadlifts'),(108,'decline ab'),(21,'decline bench'),(23,'decline push up'),(117,'decline sit up'),(129,'decline sit ups'),(123,'dip'),(35,'dips'),(126,'dragon ab'),(130,'dragon ab raise'),(137,'dragon leg raise'),(87,'face pull'),(22,'floor bench'),(49,'forwards resistance treadmill'),(102,'front rack lunge'),(15,'front squat'),(28,'ghd back extension'),(38,'ghd back extensions'),(19,'ghd sit up'),(106,'ghd sit ups'),(118,'hammer curl'),(75,'hang snatch'),(98,'hanging knee raise'),(4,'hanging leg raises'),(110,'inc db bench'),(145,'inc sit up'),(119,'incline bench'),(149,'incline sit up'),(122,'katana tri'),(93,'kb shoulder walks'),(51,'kot elevated lunge'),(72,'landmine press'),(109,'lat pd'),(95,'lat push down'),(120,'lat raise'),(124,'leg extension'),(150,'machine calf raise'),(154,'machine press'),(86,'machine row'),(90,'overhead rope tri'),(50,'overhead squat'),(114,'overhead v tri'),(99,'pause front squat'),(9,'pause squat'),(121,'pec dec'),(1,'power clean'),(67,'power clean complex'),(40,'power snatch'),(153,'preacher curl'),(140,'preacher machine'),(12,'pull up'),(6,'pull ups'),(45,'push jerk'),(57,'push press'),(56,'push ups'),(133,'push ups as'),(132,'reverse lat pd ss'),(34,'ring pull ups'),(13,'ring row'),(97,'rope ab'),(128,'rope cable tri'),(127,'rope face pull'),(96,'rope hammer curl'),(55,'rope pulldown'),(83,'rope tri'),(79,'row circuit'),(58,'sa db press'),(32,'sa db row'),(52,'sa db snatch'),(30,'sa kb overhead squat'),(94,'sa kb press'),(24,'seated press'),(31,'seated strict press'),(33,'segmented clean + hang power clean'),(27,'segmented clean deadlift + hang power clean'),(141,'side raises'),(139,'single leg db rdl'),(146,'sl calf raise'),(101,'sled push'),(144,'slow leg extension'),(147,'slow pull ups'),(8,'snatch'),(39,'snatch balance'),(47,'snatch complex'),(74,'snatch high pull'),(14,'snatch pull'),(26,'split jerk'),(41,'squat'),(46,'strict ctb'),(18,'strict hspu'),(2,'strict press'),(107,'tempo deadlift'),(115,'thrusters'),(151,'tri overhead'),(105,'tri push down'),(7,'ttb'),(68,'underhand fly'),(36,'v-ups'),(100,'walking db lunge'),(112,'walking db lungs'),(91,'wall ball'),(85,'weighted pull up'),(81,'weighted pull ups'),(76,'wide grip bench');
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

-- Dump completed on 2026-06-07 14:42:47
