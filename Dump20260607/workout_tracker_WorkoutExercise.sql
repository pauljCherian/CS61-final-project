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
-- Table structure for table `WorkoutExercise`
--

DROP TABLE IF EXISTS `WorkoutExercise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WorkoutExercise` (
  `WorkoutExerciseID` int NOT NULL AUTO_INCREMENT,
  `WorkoutID` int NOT NULL,
  `ExerciseID` int NOT NULL,
  `OrderNum` int DEFAULT NULL,
  `Notes` text,
  PRIMARY KEY (`WorkoutExerciseID`),
  UNIQUE KEY `uq_we_workout_order` (`WorkoutID`,`OrderNum`),
  KEY `idx_we_workout` (`WorkoutID`),
  KEY `idx_we_exercise` (`ExerciseID`),
  CONSTRAINT `fk_we_exercise` FOREIGN KEY (`ExerciseID`) REFERENCES `Exercises` (`ExerciseID`),
  CONSTRAINT `fk_we_workout` FOREIGN KEY (`WorkoutID`) REFERENCES `Workouts` (`WorkoutID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=352 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WorkoutExercise`
--

LOCK TABLES `WorkoutExercise` WRITE;
/*!40000 ALTER TABLE `WorkoutExercise` DISABLE KEYS */;
INSERT INTO `WorkoutExercise` VALUES (1,1,1,1,NULL),(2,1,2,2,NULL),(3,1,3,3,NULL),(4,1,4,4,NULL),(5,3,5,1,'3x5 @ 80%'),(6,3,6,2,NULL),(7,3,7,3,NULL),(8,4,8,1,'3x3 @ 80%'),(9,4,2,2,NULL),(10,5,9,1,'6, 6, 5, 5, 4 | 32x1'),(11,6,10,1,'5x2 @ 80%'),(12,6,11,2,'3x3 @ 100%'),(13,6,12,3,'RPE 7'),(14,6,13,4,'RPE 7'),(15,7,8,1,'5x2 @ 80%'),(16,7,14,2,'3x3 @ 100%'),(17,7,15,3,'5x3 @ 75%'),(18,8,16,1,'5x2 @ 80%'),(19,8,17,2,NULL),(20,8,18,3,NULL),(21,8,19,4,NULL),(22,9,20,1,'3RM @ RPE 9'),(23,9,21,2,'Bench Club'),(24,9,22,3,'Bench Club'),(25,9,23,4,'Bench Club'),(26,10,9,1,'5, 5, 4, 4, 3 | 32x1'),(27,11,8,1,'5x2 @ 80% | Little fried going into ot'),(28,12,10,1,'5x2 @ 80%'),(29,12,11,2,'3x3'),(30,13,24,1,'5, 5, 4, 4, 3'),(31,13,25,2,'4x8'),(32,15,5,1,'1rm | Legs fried to start but wanted to see.'),(33,15,5,2,'triples after 1rm'),(34,16,26,1,'2, 2, 2, 1, 1, 1 | Not heavy my tech is ass'),(35,17,27,1,'6 times 2x segments, 1x hang | Pause right above knee. Then get to \"power\" position through only moving up chest but keeping legs where they are. Explode thru legs don\'t be flat footed and get bar up.'),(36,18,8,1,'hands ripped like a mf, went light'),(37,18,15,2,'5x3'),(38,20,9,1,'4,4,4,3,3,4 | 3 secs down, 2 sec hold, explode'),(39,20,28,2,NULL),(40,20,29,3,NULL),(41,20,30,4,NULL),(42,22,10,1,'singles'),(43,23,31,1,'4,4,3,3,2'),(44,23,32,2,NULL),(45,25,5,1,'5x3'),(46,26,26,1,'2,2,2,1,1,1'),(47,27,33,1,'1,1,1,1,1 | Pause at power positions deadlift -> hang shrug -> hang power'),(48,28,8,1,NULL),(49,28,15,2,NULL),(50,29,6,1,NULL),(51,29,34,2,NULL),(52,29,35,3,NULL),(53,29,36,4,NULL),(54,29,37,5,NULL),(55,30,9,1,NULL),(56,30,38,2,NULL),(57,31,39,1,NULL),(58,31,10,2,NULL),(59,32,2,1,'3, 3, 2, 2, 2'),(60,32,32,2,NULL),(61,34,5,1,'5, 5, 4, 4, 4 w/ 3 second eccentric on 2 minute clock | Start with higher hips and sit back further, i. was clean deadlifting before'),(62,35,40,1,'20 snatches @ 95'),(63,35,8,2,NULL),(64,36,26,1,NULL),(65,38,41,1,'1rm | Ugh, I failed my first 285 and then the next one was pretty easy. Do not have the powerlifting form down and was a little nervous.'),(66,38,17,2,'1rm | 205 f 2 in warm up was so light. 225 was smooth. Then I went for 235 and just grinded too hard for a failure. Have a lot more here'),(67,38,5,3,'1rm | Impressed myself a lot. 350 felt upper limits and was slow to get up but man we did it lfg'),(68,40,41,1,NULL),(69,40,42,2,NULL),(70,40,43,3,NULL),(71,40,44,4,NULL),(72,42,2,1,NULL),(73,42,45,2,NULL),(74,42,46,3,NULL),(75,43,47,1,NULL),(76,44,15,1,NULL),(77,44,48,2,NULL),(78,44,49,3,NULL),(79,45,26,1,'2, 2, 2, then singles | Form is still bad needs work'),(80,45,32,2,NULL),(81,46,10,1,'3,3,3,3,3'),(82,46,50,2,NULL),(83,46,51,3,NULL),(84,46,52,4,NULL),(85,46,42,5,NULL),(86,47,17,1,'5x5'),(87,47,53,2,NULL),(88,47,29,3,NULL),(89,47,54,4,NULL),(90,47,55,5,NULL),(91,47,56,6,NULL),(92,47,3,7,NULL),(93,47,6,8,NULL),(94,48,2,1,'4x8 @ 60-65%'),(95,48,57,2,'1x8 at finished weight of 94'),(96,49,1,1,NULL),(97,50,5,1,'3 second ecc'),(98,52,58,1,'3 second ecc, ss with 99'),(99,52,37,2,'3 second ecc, ss with 98'),(100,53,59,1,'segmented clean deadlift + segment hang full clean'),(101,55,15,1,'post metcon'),(102,56,60,1,'3x5, 3x6, 3x7 unbroken wide, standard, narrow grip'),(103,56,21,2,'12, 10, 8, 6'),(104,56,61,3,'3x10 SS with 105'),(105,56,62,4,'3x10 SS with 104'),(106,56,63,5,'3x10 SS with 107'),(107,56,64,6,'3x10 SS with 106'),(108,56,65,7,'30 seconds on, 20 off: BB Curl, Reverse Curl, 1/2 Curl, Curl to Overhead'),(109,57,41,1,NULL),(110,57,28,2,NULL),(111,60,66,1,'3 second eccentric'),(112,62,58,1,'3 second ecc, ss with 99'),(113,62,37,2,'3 second ecc, ss with 98'),(114,63,67,1,'clean deadlift w/ pauses into power clean'),(115,65,17,1,NULL),(116,65,68,2,NULL),(117,65,56,3,NULL),(118,65,69,4,NULL),(119,65,70,5,NULL),(120,65,71,6,NULL),(121,65,72,7,NULL),(122,65,73,8,NULL),(123,65,65,9,NULL),(124,66,41,1,NULL),(125,67,2,1,NULL),(126,67,57,2,NULL),(127,73,8,1,NULL),(128,73,39,2,NULL),(129,75,59,1,NULL),(130,75,10,2,NULL),(131,79,74,1,NULL),(132,79,75,2,NULL),(133,79,8,3,'Pull close to body, legs wide and angled out not shins bending over, and its just a bar don\'t be fucking scared of it'),(134,80,1,1,'touch n go'),(135,81,41,1,'1RM'),(136,85,76,1,NULL),(137,85,56,2,NULL),(138,85,77,3,NULL),(139,85,78,4,NULL),(140,85,79,5,NULL),(141,86,65,1,NULL),(142,87,41,1,NULL),(143,87,80,2,NULL),(144,87,2,3,NULL),(145,87,81,4,NULL),(146,87,32,5,NULL),(147,87,82,6,NULL),(148,87,3,7,NULL),(149,87,83,8,NULL),(150,89,15,1,NULL),(151,89,84,2,NULL),(152,89,85,3,NULL),(153,89,17,4,NULL),(154,88,86,1,NULL),(155,88,13,2,NULL),(156,88,87,3,NULL),(157,88,88,4,NULL),(158,88,89,5,NULL),(159,88,90,6,NULL),(160,88,56,7,NULL),(161,88,42,8,NULL),(162,88,91,9,NULL),(163,91,41,1,NULL),(164,91,92,2,NULL),(165,91,93,3,NULL),(166,91,94,4,NULL),(167,90,2,1,NULL),(168,90,85,2,NULL),(169,90,95,3,NULL),(170,90,13,4,NULL),(171,90,90,5,NULL),(172,90,56,6,NULL),(173,90,96,7,NULL),(174,90,97,8,NULL),(175,90,98,9,NULL),(176,93,99,1,NULL),(177,93,100,2,NULL),(178,93,101,3,NULL),(179,93,97,4,NULL),(180,93,98,5,NULL),(181,94,1,1,NULL),(182,94,41,2,NULL),(183,94,50,3,NULL),(184,94,102,4,NULL),(185,95,103,1,NULL),(186,95,81,2,NULL),(187,95,6,3,NULL),(188,95,104,4,NULL),(189,95,105,5,NULL),(190,95,97,6,NULL),(191,95,89,7,NULL),(192,95,106,8,NULL),(193,96,107,1,NULL),(194,96,80,2,NULL),(195,96,108,3,NULL),(196,96,15,4,NULL),(197,96,45,5,NULL),(198,98,17,1,NULL),(199,98,6,2,NULL),(200,98,109,3,NULL),(201,98,110,4,NULL),(202,98,111,5,NULL),(203,98,89,6,NULL),(204,97,41,1,NULL),(205,97,112,2,NULL),(206,97,2,3,NULL),(207,97,85,4,NULL),(208,97,69,5,NULL),(209,97,3,6,NULL),(210,97,35,7,NULL),(211,97,113,8,NULL),(212,103,5,1,NULL),(213,103,42,2,NULL),(214,103,80,3,NULL),(215,103,108,4,NULL),(216,100,17,1,NULL),(217,100,86,2,NULL),(218,100,114,3,NULL),(219,100,35,4,NULL),(220,100,3,5,NULL),(221,105,115,1,NULL),(222,105,41,2,NULL),(223,113,2,1,NULL),(224,113,109,2,NULL),(225,113,69,3,NULL),(226,113,3,4,NULL),(227,113,114,5,NULL),(228,113,85,6,NULL),(229,113,95,7,NULL),(230,113,111,8,NULL),(231,113,116,9,NULL),(232,113,117,10,NULL),(233,113,118,11,NULL),(234,117,2,1,NULL),(235,117,17,2,NULL),(236,117,119,3,NULL),(237,117,120,4,NULL),(238,117,121,5,NULL),(239,117,122,6,NULL),(240,117,123,7,NULL),(241,114,41,1,NULL),(242,114,124,2,NULL),(243,114,125,3,NULL),(244,114,126,4,NULL),(245,120,2,1,NULL),(246,120,85,2,NULL),(247,120,69,3,NULL),(248,120,3,4,NULL),(249,120,127,5,NULL),(250,120,128,6,NULL),(251,120,35,7,NULL),(252,120,118,8,NULL),(253,121,99,1,NULL),(254,121,42,2,NULL),(255,121,80,3,NULL),(256,121,129,4,NULL),(257,123,17,1,NULL),(258,123,6,2,NULL),(259,123,35,3,NULL),(260,124,41,1,NULL),(261,124,117,2,NULL),(262,124,130,3,NULL),(263,124,125,4,NULL),(264,125,2,1,NULL),(265,125,6,2,NULL),(266,125,109,3,NULL),(267,125,131,4,NULL),(268,125,132,5,NULL),(269,125,133,6,NULL),(270,125,35,7,NULL),(271,125,134,8,NULL),(272,125,135,9,NULL),(273,125,90,10,NULL),(274,126,5,1,NULL),(275,126,80,2,NULL),(276,126,136,3,NULL),(277,126,81,4,NULL),(278,126,111,5,NULL),(279,126,116,6,NULL),(280,126,105,7,NULL),(281,128,41,1,NULL),(282,128,108,2,NULL),(283,128,137,3,NULL),(284,128,138,4,NULL),(285,128,139,5,NULL),(286,129,17,1,NULL),(287,129,109,2,NULL),(288,129,111,3,NULL),(289,129,103,4,NULL),(290,129,96,5,NULL),(291,129,140,6,NULL),(292,130,5,1,NULL),(293,132,17,1,NULL),(294,132,57,2,NULL),(295,132,6,3,NULL),(296,132,141,4,NULL),(297,132,83,5,NULL),(298,132,3,6,NULL),(299,132,142,7,NULL),(300,132,35,8,NULL),(301,132,111,9,NULL),(302,133,99,1,NULL),(303,133,41,2,NULL),(304,133,143,3,NULL),(305,133,144,4,NULL),(306,133,145,5,NULL),(307,133,137,6,NULL),(308,133,145,7,NULL),(309,133,137,8,NULL),(310,133,146,9,NULL),(311,135,2,1,NULL),(312,135,147,2,NULL),(313,135,2,3,NULL),(314,135,147,4,NULL),(315,135,2,5,NULL),(316,135,147,6,NULL),(317,135,69,7,NULL),(318,135,111,8,NULL),(319,135,90,9,NULL),(320,139,41,1,NULL),(321,139,148,2,NULL),(322,139,42,3,NULL),(323,139,124,4,NULL),(324,139,80,5,NULL),(325,139,80,6,NULL),(326,139,80,7,NULL),(327,139,149,8,NULL),(328,139,137,9,NULL),(329,139,150,10,NULL),(330,141,2,1,NULL),(331,141,17,2,NULL),(332,141,109,3,NULL),(333,141,151,4,NULL),(334,141,3,5,NULL),(335,141,56,6,NULL),(336,141,6,7,NULL),(337,141,35,8,NULL),(338,141,152,9,NULL),(339,141,153,10,NULL),(340,142,2,1,NULL),(341,142,6,2,NULL),(342,142,35,3,NULL),(343,142,154,4,NULL),(344,142,35,5,NULL),(345,142,154,6,NULL),(346,142,89,7,NULL),(347,142,83,8,NULL),(348,146,41,1,NULL),(349,146,108,2,NULL),(350,146,137,3,NULL),(351,146,150,4,NULL);
/*!40000 ALTER TABLE `WorkoutExercise` ENABLE KEYS */;
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
