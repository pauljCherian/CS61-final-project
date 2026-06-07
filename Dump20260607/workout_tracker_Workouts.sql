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
-- Table structure for table `Workouts`
--

DROP TABLE IF EXISTS `Workouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Workouts` (
  `WorkoutID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `WorkoutDate` date NOT NULL DEFAULT (curdate()),
  `Description` varchar(255) DEFAULT NULL,
  `Notes` text,
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`WorkoutID`),
  KEY `idx_workouts_user_date` (`UserID`,`WorkoutDate`),
  CONSTRAINT `fk_workouts_user` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Workouts`
--

LOCK TABLES `Workouts` WRITE;
/*!40000 ALTER TABLE `Workouts` DISABLE KEYS */;
INSERT INTO `Workouts` VALUES (1,1,'2026-01-01','Az Lift',NULL,'2026-06-07 14:38:38'),(2,1,'2026-01-02','az run',NULL,'2026-06-07 14:38:38'),(3,1,'2026-01-03','cf golden gate open gym',NULL,'2026-06-07 14:38:38'),(4,1,'2026-01-04','crossfit open gym',NULL,'2026-06-07 14:38:38'),(5,1,'2026-01-05','first crossfit class',NULL,'2026-06-07 14:38:38'),(6,1,'2026-01-08','Heavy cleans + Pull Accessories',NULL,'2026-06-07 14:38:38'),(7,1,'2026-01-09','Heavy Snatch + Front Squat',NULL,'2026-06-07 14:38:38'),(8,1,'2026-01-10','Heavy Cleans + Push Accessories',NULL,'2026-06-07 14:38:38'),(9,1,'2026-01-11','3RM Squat + Bench Club Workout at CF Golden Gate',NULL,'2026-06-07 14:38:38'),(10,1,'2026-01-12','A: Backsquat B: 12 min AMRAP',NULL,'2026-06-07 14:38:38'),(11,1,'2026-01-12','Heavy Snatch + DU Tech','was a little fried','2026-06-07 14:38:38'),(12,1,'2026-01-13','Heavy Cleans',NULL,'2026-06-07 14:38:38'),(13,1,'2026-01-13','Heavy Press + Upper Accesory WOD',NULL,'2026-06-07 14:38:38'),(14,1,'2026-01-14','Handstand Technique + Zone 2',NULL,'2026-06-07 14:38:38'),(15,1,'2026-01-15','1RM Deadlift + Back Off',NULL,'2026-06-07 14:38:38'),(16,1,'2026-01-15','Split Jerk + for time wod',NULL,'2026-06-07 14:38:38'),(17,1,'2026-01-16','Clean Work + for time wod',NULL,'2026-06-07 14:38:38'),(18,1,'2026-01-17','Snatch Work + Front Squat',NULL,'2026-06-07 14:38:38'),(19,1,'2026-01-18','Short Run to Marina',NULL,'2026-06-07 14:38:38'),(20,1,'2026-01-19','Tempo Pause Squats + Accessories',NULL,'2026-06-07 14:38:38'),(21,1,'2026-01-19','DU Tech + Row Bike Zone 2',NULL,'2026-06-07 14:38:38'),(22,1,'2026-01-20','Clean Singles',NULL,'2026-06-07 14:38:38'),(23,1,'2026-01-20','Strict Press + 6 Min AMRAP',NULL,'2026-06-07 14:38:38'),(24,1,'2026-01-21','Row/Bike + DU Practice',NULL,'2026-06-07 14:38:38'),(25,1,'2026-01-22','Heavy Deadlift',NULL,'2026-06-07 14:38:38'),(26,1,'2026-01-22','Split Jerk Singles + For Time WOD',NULL,'2026-06-07 14:38:38'),(27,1,'2026-01-23','Segmented Cleans + 23.1 (14 min amrap)',NULL,'2026-06-07 14:38:38'),(28,1,'2026-01-24','Heavy Snatches + Front Squats',NULL,'2026-06-07 14:38:38'),(29,1,'2026-01-24','Row/DU/TTB Tech Piece + Upper Hypertrophy',NULL,'2026-06-07 14:38:38'),(30,1,'2026-01-26','Heavy Tempo Squats',NULL,'2026-06-07 14:38:38'),(31,1,'2026-01-27','Heavy Cleans',NULL,'2026-06-07 14:38:38'),(32,1,'2026-01-27','Strict Press + 9 Min AMRAP',NULL,'2026-06-07 14:38:38'),(33,1,'2026-01-27','Row/Bike Zone 2 + Handstands',NULL,'2026-06-07 14:38:38'),(34,1,'2026-01-28','Heavy Deadlift + For Time Strength WOD',NULL,'2026-06-07 14:38:38'),(35,1,'2026-01-29','20 snatches for time @ 95 lbs',NULL,'2026-06-07 14:38:38'),(36,1,'2026-01-29','Push Jerk + For Time WOD',NULL,'2026-06-07 14:38:38'),(37,1,'2026-01-29','Zone 2 + Shoulder Mobility',NULL,'2026-06-07 14:38:38'),(38,1,'2026-01-31','Crossfit Golden Gate Powerlifting Comp','Sore coming in from deadlifts on wednesday but decently fresh (meh)','2026-06-07 14:38:38'),(39,1,'2026-02-01','Arizona Run with Syd',NULL,'2026-06-07 14:38:38'),(40,1,'2026-02-02','5x5 Leg Endurance in AZ',NULL,'2026-06-07 14:38:38'),(41,1,'2026-02-02','Arizona Run with Syd',NULL,'2026-06-07 14:38:38'),(42,1,'2026-02-03','Shoulder Strength with Dad',NULL,'2026-06-07 14:38:38'),(43,1,'2026-02-04','Metcon w/ Mom at AZ Gym',NULL,'2026-06-07 14:38:38'),(44,1,'2026-02-05','Heavy Front Squats',NULL,'2026-06-07 14:38:38'),(45,1,'2026-02-06','Split Jerk + Strength Endurance EMOM',NULL,'2026-06-07 14:38:38'),(46,1,'2026-02-07','Heavy Cleans + Accessories',NULL,'2026-06-07 14:38:38'),(47,1,'2026-02-08','Upper Strength + Hypertrophy',NULL,'2026-06-07 14:38:38'),(48,1,'2026-02-10','Strict Press + AMRAP',NULL,'2026-06-07 14:38:38'),(49,1,'2026-02-10','20 Power Cleans for time -> Zone 2 Row',NULL,'2026-06-07 14:38:38'),(50,1,'2026-02-11','Heavy Deadlifts + 1 min sprint intervals wod',NULL,'2026-06-07 14:38:38'),(51,1,'2026-02-11','Muscle Up Technique -> Zone 2 Row',NULL,'2026-06-07 14:38:38'),(52,1,'2026-02-12','Upper Hypertrophy Work -> EMOM Brutal Wod',NULL,'2026-06-07 14:38:38'),(53,1,'2026-02-13','Clean Complex -> Heavy Chipper',NULL,'2026-06-07 14:38:38'),(54,1,'2026-02-13','Flight Simulator Attempt, DUs, TTBs, Wall Walks',NULL,'2026-06-07 14:38:38'),(55,1,'2026-02-14','Partner Long Wod -> Heavy Front Squats',NULL,'2026-06-07 14:38:38'),(56,1,'2026-02-15','Bench Club',NULL,'2026-06-07 14:38:38'),(57,1,'2026-02-16','Heavy Squat',NULL,'2026-06-07 14:38:38'),(58,1,'2026-02-16','Zone 2 @ Arjun\'s + Sauna',NULL,'2026-06-07 14:38:38'),(59,1,'2026-02-17','Hella DUs -> 20 Min Row',NULL,'2026-06-07 14:38:38'),(60,1,'2026-02-18','Deadlifts -> 3x4min Heavy metcon',NULL,'2026-06-07 14:38:38'),(61,1,'2026-02-18','45 min zone 2 bike',NULL,'2026-06-07 14:38:38'),(62,1,'2026-02-19','Upper Hypertrophy Work -> For Time Wod',NULL,'2026-06-07 14:38:38'),(63,1,'2026-02-20','Clean Complex -> 4x3 min burner',NULL,'2026-06-07 14:38:38'),(64,1,'2026-02-21','Partner Long Wod',NULL,'2026-06-07 14:38:38'),(65,1,'2026-02-22','Upper Hypertrophy',NULL,'2026-06-07 14:38:38'),(66,1,'2026-02-23','Heavy Squats + 21.3',NULL,'2026-06-07 14:38:38'),(67,1,'2026-02-24','Heavy Press + EMOM w/ wall walks and DUs',NULL,'2026-06-07 14:38:38'),(68,1,'2026-02-26','26.1 Prep + 15 min bike + roll + stretch',NULL,'2026-06-07 14:38:38'),(69,1,'2026-02-27','26.1 Friday Night Lights. Wall Balls + Box Jump Overs',NULL,'2026-06-07 14:38:38'),(70,1,'2026-02-28','Duo Wod',NULL,'2026-06-07 14:38:38'),(71,1,'2026-03-01','Stretch, Foam Roll, 15 min bike, Mobility',NULL,'2026-06-07 14:38:38'),(72,1,'2026-03-02','26.1 Solo. Wall Balls + Box Jump Overs',NULL,'2026-06-07 14:38:38'),(73,1,'2026-03-03','Snatch Technique + Snatch Balance',NULL,'2026-06-07 14:38:38'),(74,1,'2026-03-03','Strict Press + AMRAP w/ MUs, DB Clean + Row',NULL,'2026-06-07 14:38:38'),(75,1,'2026-03-04','Squat Clean Complex -> 16.1 -> RMU Work',NULL,'2026-06-07 14:38:38'),(76,1,'2026-03-05','RMU Work',NULL,'2026-06-07 14:38:38'),(77,1,'2026-03-06','26.2 Attempt 1',NULL,'2026-06-07 14:38:38'),(78,1,'2026-03-09','26.2 Attempt 2',NULL,'2026-06-07 14:38:38'),(79,1,'2026-03-09','EMOM Snatch Workout in Vegas @ PVC Crossfit',NULL,'2026-06-07 14:38:38'),(80,1,'2026-03-10','Power Clean Triples -> 6x 1 min work wod',NULL,'2026-06-07 14:38:38'),(81,1,'2026-03-11','1RM Back Squat -> Run Lunge Wod (first W)',NULL,'2026-06-07 14:38:38'),(82,1,'2026-03-12','20 min bike, foam roll, stretch',NULL,'2026-06-07 14:38:38'),(83,1,'2026-03-13','26.3',NULL,'2026-06-07 14:38:38'),(84,1,'2026-03-14','Saturday Morning Duo Workout 6x5min w/ 1 min rest',NULL,'2026-06-07 14:38:38'),(85,1,'2026-03-15','Bench Club',NULL,'2026-06-07 14:38:38'),(86,1,'2026-03-15','Sunday Morning Post Bench Club',NULL,'2026-06-07 14:38:38'),(87,1,'2026-03-17','Juggernaut Week 1 Squat Cycle',NULL,'2026-06-07 14:38:38'),(88,1,'2026-03-18','Upper',NULL,'2026-06-07 14:38:38'),(89,1,'2026-03-19','Front Squat',NULL,'2026-06-07 14:38:38'),(90,1,'2026-03-21','Upper',NULL,'2026-06-07 14:38:38'),(91,1,'2026-03-23','Juggernaut Week 2 Squat Cycle',NULL,'2026-06-07 14:38:38'),(92,1,'2026-03-24','Upper',NULL,'2026-06-07 14:38:38'),(93,1,'2026-03-27','Front Squat',NULL,'2026-06-07 14:38:38'),(94,1,'2026-03-30','Juggernaut Week 3 Squat Cycle',NULL,'2026-06-07 14:38:38'),(95,1,'2026-03-31','Upper',NULL,'2026-06-07 14:38:38'),(96,1,'2026-04-01','Deadlift',NULL,'2026-06-07 14:38:38'),(97,1,'2026-04-03','Lower',NULL,'2026-06-07 14:38:38'),(98,1,'2026-04-04','Upper',NULL,'2026-06-07 14:38:38'),(99,1,'2026-04-06','Juggernaut Week 4 Squat Cycle',NULL,'2026-06-07 14:38:38'),(100,1,'2026-04-07','Upper',NULL,'2026-06-07 14:38:38'),(101,1,'2026-04-07','1.03mi Hard Run',NULL,'2026-06-07 14:38:38'),(102,1,'2026-04-08','4.7mi Run',NULL,'2026-06-07 14:38:38'),(103,1,'2026-04-09','Lower',NULL,'2026-06-07 14:38:38'),(104,1,'2026-04-10','Run',NULL,'2026-06-07 14:38:38'),(105,1,'2026-04-11','Thrusters',NULL,'2026-06-07 14:38:38'),(106,1,'2026-04-11','Bike',NULL,'2026-06-07 14:38:38'),(107,1,'2026-04-13','Juggernaut Week 5 Squat Cycle',NULL,'2026-06-07 14:38:38'),(108,1,'2026-04-15','Hypetrophy Upper',NULL,'2026-06-07 14:38:38'),(109,1,'2026-04-17','Quick legs',NULL,'2026-06-07 14:38:38'),(110,1,'2026-04-18','Hypetrophy pull with colson',NULL,'2026-06-07 14:38:38'),(111,1,'2026-04-19','Hypetrophy push with colson',NULL,'2026-06-07 14:38:38'),(112,1,'2026-04-20','Lower',NULL,'2026-06-07 14:38:38'),(113,1,'2026-04-21','Upper',NULL,'2026-06-07 14:38:38'),(114,1,'2026-04-23','4.52mi Run',NULL,'2026-06-07 14:38:38'),(115,1,'2026-04-24','Lower',NULL,'2026-06-07 14:38:38'),(116,1,'2026-04-25','2x 500m row',NULL,'2026-06-07 14:38:38'),(117,1,'2026-04-27','Quick Upper',NULL,'2026-06-07 14:38:38'),(118,1,'2026-04-28','Juggernaut Week 6 Squat + Abs',NULL,'2026-06-07 14:38:38'),(119,1,'2026-04-28','3.11mi Run',NULL,'2026-06-07 14:38:38'),(120,1,'2026-04-30','Upper (Press + Pull + Arms)',NULL,'2026-06-07 14:38:38'),(121,1,'2026-05-01','Lower (Pause Front Squat + Posterior)',NULL,'2026-06-07 14:38:38'),(122,1,'2026-05-01','5.56mi Run',NULL,'2026-06-07 14:38:38'),(123,1,'2026-05-02','Upper (Bench + Pull ups + Dips)',NULL,'2026-06-07 14:38:38'),(124,1,'2026-05-04','Lower (Squat + Calves + Abs)',NULL,'2026-06-07 14:38:38'),(125,1,'2026-05-05','Upper (Press + Pull Hypertrophy)',NULL,'2026-06-07 14:38:38'),(126,1,'2026-05-06','Deadlift + Pull Accessories',NULL,'2026-06-07 14:38:38'),(127,1,'2026-05-09','500m Row Sprint',NULL,'2026-06-07 14:38:38'),(128,1,'2026-05-11','Lower (Squat + Lunges + Abs)',NULL,'2026-06-07 14:38:38'),(129,1,'2026-05-12','Upper (Bench + Back + Arms)',NULL,'2026-06-07 14:38:38'),(130,1,'2026-05-13','Deadlift',NULL,'2026-06-07 14:38:38'),(131,1,'2026-05-13','4.15mi Run',NULL,'2026-06-07 14:38:38'),(132,1,'2026-05-14','Upper (Bench + Push Press + Arms)',NULL,'2026-06-07 14:38:38'),(133,1,'2026-05-15','Lower (Front Squat + Squat + Accessories)',NULL,'2026-06-07 14:38:38'),(134,1,'2026-05-15','5000m Row',NULL,'2026-06-07 14:38:38'),(135,1,'2026-05-17','6.25mi Run',NULL,'2026-06-07 14:38:38'),(136,1,'2026-05-18','Upper (Press/Pull Supersets)',NULL,'2026-06-07 14:38:38'),(137,1,'2026-05-18','8.06mi Run',NULL,'2026-06-07 14:38:38'),(138,1,'2026-05-20','4.17mi Run',NULL,'2026-06-07 14:38:38'),(139,1,'2026-05-22','15.6mi Long Run',NULL,'2026-06-07 14:38:38'),(140,1,'2026-05-25','Lower (Squat + Posterior + Abs)',NULL,'2026-06-07 14:38:38'),(141,1,'2026-05-26','3.79mi Run',NULL,'2026-06-07 14:38:38'),(142,1,'2026-05-27','Upper (Full Push + Pull Hypertrophy)',NULL,'2026-06-07 14:38:38'),(143,1,'2026-05-29','Upper (Press + Pull + Dips)',NULL,'2026-06-07 14:38:38'),(144,1,'2026-05-30','2.98mi Run',NULL,'2026-06-07 14:38:38'),(145,1,'2026-05-31','6.3mi Run',NULL,'2026-06-07 14:38:38'),(146,1,'2026-06-01','Juggernaut Week 11',NULL,'2026-06-07 14:38:38');
/*!40000 ALTER TABLE `Workouts` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_workouts_after_insert` AFTER INSERT ON `workouts` FOR EACH ROW INSERT INTO AuditLog (TableName, Action, RowID)
VALUES ('Workouts', 'CREATE', NEW.WorkoutID) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_workouts_after_delete` AFTER DELETE ON `workouts` FOR EACH ROW INSERT INTO AuditLog (TableName, Action, RowID)
VALUES ('Workouts', 'DELETE', OLD.WorkoutID) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
