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
-- Table structure for table `CardioSessions`
--

DROP TABLE IF EXISTS `CardioSessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CardioSessions` (
  `CardioID` int NOT NULL AUTO_INCREMENT,
  `WorkoutID` int NOT NULL,
  `ActivityType` varchar(150) DEFAULT NULL,
  `Duration` int DEFAULT NULL,
  `Distance` decimal(10,2) DEFAULT NULL,
  `Units` enum('mi','km','m') DEFAULT NULL,
  `Intensity` tinyint DEFAULT NULL,
  `Notes` text,
  PRIMARY KEY (`CardioID`),
  KEY `idx_cardio_workout` (`WorkoutID`),
  CONSTRAINT `fk_cardio_workout` FOREIGN KEY (`WorkoutID`) REFERENCES `Workouts` (`WorkoutID`) ON DELETE CASCADE,
  CONSTRAINT `cardiosessions_chk_1` CHECK ((`Duration` >= 0)),
  CONSTRAINT `cardiosessions_chk_2` CHECK ((`Distance` >= 0)),
  CONSTRAINT `cardiosessions_chk_3` CHECK (((`Intensity` >= 1) and (`Intensity` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CardioSessions`
--

LOCK TABLES `CardioSessions` WRITE;
/*!40000 ALTER TABLE `CardioSessions` DISABLE KEYS */;
INSERT INTO `CardioSessions` VALUES (1,2,'run',2358,4.16,'mi',2,'just light (steady)'),(2,3,'row',1613,5033.00,'m',2,'technique work (technique)'),(3,4,'row',1531,5028.00,'m',2,'(technique)'),(4,14,'assault bike',621,3.26,'mi',2,'(steady)'),(5,14,'row',1929,6034.00,'m',2,'(steady)'),(6,14,'bike',1237,8926.00,'m',2,'(steady, 132w)'),(7,19,'run',1292,2.40,'mi',2,'with sydney to the marina! (steady)'),(8,21,'row',1920,6100.00,'m',2,'(steady)'),(9,21,'bike',1827,13768.00,'m',2,'(steady, 150w)'),(10,24,'row',1853,6023.00,'m',2,'split up 15 mins w/ DUs between (steady)'),(11,24,'bike',1818,13633.00,'m',2,'(steady, 148w)'),(12,33,'row',2950,10024.00,'m',2,'maybe pumped it a little too hard but (steady)'),(13,33,'bike',1800,14024.00,'m',2,'(steady, 155w)'),(14,37,'ski',600,2000.00,'m',2,'(steady)'),(15,37,'bike',2580,17000.00,'m',2,'tried to no sweat it (steady, 145w)'),(16,39,'run',3660,6.55,'mi',2,'(steady)'),(17,41,'run',2302,4.28,'mi',3,'2 miles, 1 quick one at 8 min, then cool down all kinda high hr (tempo)'),(18,49,'row',2430,7750.00,'m',2,'pretty chill. kept like 2:35 and just coasted. (steady)'),(19,51,'row',3010,10153.00,'m',2,'(steady)'),(20,58,'ski',600,2074.00,'m',2,'(steady)'),(21,58,'row',1200,4181.00,'m',2,'(steady)'),(22,58,'bike',1866,13.10,'mi',2,'(steady)'),(23,59,'row',1214,4300.00,'m',2,'(steady)'),(24,61,'bike',2765,16.50,'mi',2,'(steady)'),(25,101,'run',394,1.03,'mi',4,'(hard)'),(26,102,'run',2792,4.70,'mi',2,NULL),(27,104,'run',4620,8.04,'mi',2,NULL),(28,106,'bike',2700,10.00,'mi',2,NULL),(29,116,'row',NULL,1000.00,'m',4,'2 500m efforts at 90% w/ 5 min break (hard)'),(30,114,'run',2693,4.52,'mi',2,'(easy)'),(31,119,'run',1503,3.11,'mi',3,'(mid)'),(32,122,'run',3029,5.56,'mi',2,NULL),(33,131,'run',2458,4.15,'mi',2,NULL),(34,127,'row',94,500.00,'m',4,'(hard)'),(35,134,'row',1440,5000.00,'m',3,NULL),(36,135,'run',3660,6.25,'mi',2,NULL),(37,137,'run',4980,8.06,'mi',2,NULL),(38,138,'run',2202,4.17,'mi',2,NULL),(39,139,'run',8280,15.60,'mi',2,NULL),(40,141,'run',2089,3.79,'mi',2,NULL),(41,144,'run',1474,2.98,'mi',3,NULL),(42,145,'run',3600,6.28,'mi',2,NULL);
/*!40000 ALTER TABLE `CardioSessions` ENABLE KEYS */;
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
