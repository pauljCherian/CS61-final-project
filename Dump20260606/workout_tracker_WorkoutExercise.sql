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
) ENGINE=InnoDB AUTO_INCREMENT=354 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WorkoutExercise`
--

LOCK TABLES `WorkoutExercise` WRITE;
/*!40000 ALTER TABLE `WorkoutExercise` DISABLE KEYS */;
INSERT INTO `WorkoutExercise` VALUES (1,1,1,1,''),(2,1,1,2,''),(3,2,2,1,NULL),(4,2,3,2,NULL),(5,2,4,3,NULL),(6,2,5,4,NULL),(7,4,6,1,'3x5 @ 80%'),(8,4,7,2,NULL),(9,4,8,3,NULL),(10,5,9,1,'3x3 @ 80%'),(11,5,3,2,NULL),(12,6,10,1,'6, 6, 5, 5, 4 | 32x1'),(13,7,11,1,'5x2 @ 80%'),(14,7,12,2,'3x3 @ 100%'),(15,7,13,3,'RPE 7'),(16,7,14,4,'RPE 7'),(17,8,9,1,'5x2 @ 80%'),(18,8,15,2,'3x3 @ 100%'),(19,8,16,3,'5x3 @ 75%'),(20,9,17,1,'5x2 @ 80%'),(21,9,18,2,NULL),(22,9,19,3,NULL),(23,9,20,4,NULL),(24,10,21,1,'3RM @ RPE 9'),(25,10,22,2,'Bench Club'),(26,10,23,3,'Bench Club'),(27,10,24,4,'Bench Club'),(28,11,10,1,'5, 5, 4, 4, 3 | 32x1'),(29,12,9,1,'5x2 @ 80% | Little fried going into ot'),(30,13,11,1,'5x2 @ 80%'),(31,13,12,2,'3x3'),(32,14,25,1,'5, 5, 4, 4, 3'),(33,14,26,2,'4x8'),(34,16,6,1,'1rm | Legs fried to start but wanted to see.'),(35,16,6,2,'triples after 1rm'),(36,17,27,1,'2, 2, 2, 1, 1, 1 | Not heavy my tech is ass'),(37,18,28,1,'6 times 2x segments, 1x hang | Pause right above knee. Then get to \"power\" position through only moving up chest but keeping legs where they are. Explode thru legs don\'t be flat footed and get bar up.'),(38,19,9,1,'hands ripped like a mf, went light'),(39,19,16,2,'5x3'),(40,21,10,1,'4,4,4,3,3,4 | 3 secs down, 2 sec hold, explode'),(41,21,29,2,NULL),(42,21,30,3,NULL),(43,21,31,4,NULL),(44,23,11,1,'singles'),(45,24,32,1,'4,4,3,3,2'),(46,24,33,2,NULL),(47,26,6,1,'5x3'),(48,27,27,1,'2,2,2,1,1,1'),(49,28,34,1,'1,1,1,1,1 | Pause at power positions deadlift -> hang shrug -> hang power'),(50,29,9,1,NULL),(51,29,16,2,NULL),(52,30,7,1,NULL),(53,30,35,2,NULL),(54,30,36,3,NULL),(55,30,37,4,NULL),(56,30,38,5,NULL),(57,31,10,1,NULL),(58,31,39,2,NULL),(59,32,40,1,NULL),(60,32,11,2,NULL),(61,33,3,1,'3, 3, 2, 2, 2'),(62,33,33,2,NULL),(63,35,6,1,'5, 5, 4, 4, 4 w/ 3 second eccentric on 2 minute clock | Start with higher hips and sit back further, i. was clean deadlifting before'),(64,36,41,1,'20 snatches @ 95'),(65,36,9,2,NULL),(66,37,27,1,NULL),(67,39,42,1,'1rm | Ugh, I failed my first 285 and then the next one was pretty easy. Do not have the powerlifting form down and was a little nervous.'),(68,39,18,2,'1rm | 205 f 2 in warm up was so light. 225 was smooth. Then I went for 235 and just grinded too hard for a failure. Have a lot more here'),(69,39,6,3,'1rm | Impressed myself a lot. 350 felt upper limits and was slow to get up but man we did it lfg'),(70,41,42,1,NULL),(71,41,43,2,NULL),(72,41,44,3,NULL),(73,41,45,4,NULL),(74,43,3,1,NULL),(75,43,46,2,NULL),(76,43,47,3,NULL),(77,44,48,1,NULL),(78,45,16,1,NULL),(79,45,49,2,NULL),(80,45,50,3,NULL),(81,46,27,1,'2, 2, 2, then singles | Form is still bad needs work'),(82,46,33,2,NULL),(83,47,11,1,'3,3,3,3,3'),(84,47,51,2,NULL),(85,47,52,3,NULL),(86,47,53,4,NULL),(87,47,43,5,NULL),(88,48,18,1,'5x5'),(89,48,54,2,NULL),(90,48,30,3,NULL),(91,48,55,4,NULL),(92,48,56,5,NULL),(93,48,57,6,NULL),(94,48,4,7,NULL),(95,48,7,8,NULL),(96,49,3,1,'4x8 @ 60-65%'),(97,49,58,2,'1x8 at finished weight of 94'),(98,50,2,1,NULL),(99,51,6,1,'3 second ecc'),(100,53,59,1,'3 second ecc, ss with 99'),(101,53,38,2,'3 second ecc, ss with 98'),(102,54,60,1,'segmented clean deadlift + segment hang full clean'),(103,56,16,1,'post metcon'),(104,57,61,1,'3x5, 3x6, 3x7 unbroken wide, standard, narrow grip'),(105,57,22,2,'12, 10, 8, 6'),(106,57,62,3,'3x10 SS with 105'),(107,57,63,4,'3x10 SS with 104'),(108,57,64,5,'3x10 SS with 107'),(109,57,65,6,'3x10 SS with 106'),(110,57,66,7,'30 seconds on, 20 off: BB Curl, Reverse Curl, 1/2 Curl, Curl to Overhead'),(111,58,42,1,NULL),(112,58,29,2,NULL),(113,61,67,1,'3 second eccentric'),(114,63,59,1,'3 second ecc, ss with 99'),(115,63,38,2,'3 second ecc, ss with 98'),(116,64,68,1,'clean deadlift w/ pauses into power clean'),(117,66,18,1,NULL),(118,66,69,2,NULL),(119,66,57,3,NULL),(120,66,70,4,NULL),(121,66,71,5,NULL),(122,66,72,6,NULL),(123,66,73,7,NULL),(124,66,74,8,NULL),(125,66,66,9,NULL),(126,67,42,1,NULL),(127,68,3,1,NULL),(128,68,58,2,NULL),(129,74,9,1,NULL),(130,74,40,2,NULL),(131,76,60,1,NULL),(132,76,11,2,NULL),(133,80,75,1,NULL),(134,80,76,2,NULL),(135,80,9,3,'Pull close to body, legs wide and angled out not shins bending over, and its just a bar don\'t be fucking scared of it'),(136,81,2,1,'touch n go'),(137,82,42,1,'1RM'),(138,86,77,1,NULL),(139,86,57,2,NULL),(140,86,78,3,NULL),(141,86,79,4,NULL),(142,86,80,5,NULL),(143,87,66,1,NULL),(144,88,42,1,NULL),(145,88,81,2,NULL),(146,88,3,3,NULL),(147,88,82,4,NULL),(148,88,33,5,NULL),(149,88,83,6,NULL),(150,88,4,7,NULL),(151,88,84,8,NULL),(152,90,16,1,NULL),(153,90,85,2,NULL),(154,90,86,3,NULL),(155,90,18,4,NULL),(156,89,87,1,NULL),(157,89,14,2,NULL),(158,89,88,3,NULL),(159,89,89,4,NULL),(160,89,90,5,NULL),(161,89,91,6,NULL),(162,89,57,7,NULL),(163,89,43,8,NULL),(164,89,92,9,NULL),(165,92,42,1,NULL),(166,92,93,2,NULL),(167,92,94,3,NULL),(168,92,95,4,NULL),(169,91,3,1,NULL),(170,91,86,2,NULL),(171,91,96,3,NULL),(172,91,14,4,NULL),(173,91,91,5,NULL),(174,91,57,6,NULL),(175,91,97,7,NULL),(176,91,98,8,NULL),(177,91,99,9,NULL),(178,94,100,1,NULL),(179,94,101,2,NULL),(180,94,102,3,NULL),(181,94,98,4,NULL),(182,94,99,5,NULL),(183,95,2,1,NULL),(184,95,42,2,NULL),(185,95,51,3,NULL),(186,95,103,4,NULL),(187,96,104,1,NULL),(188,96,82,2,NULL),(189,96,7,3,NULL),(190,96,105,4,NULL),(191,96,106,5,NULL),(192,96,98,6,NULL),(193,96,90,7,NULL),(194,96,107,8,NULL),(195,97,108,1,NULL),(196,97,81,2,NULL),(197,97,109,3,NULL),(198,97,16,4,NULL),(199,97,46,5,NULL),(200,99,18,1,NULL),(201,99,7,2,NULL),(202,99,110,3,NULL),(203,99,111,4,NULL),(204,99,112,5,NULL),(205,99,90,6,NULL),(206,98,42,1,NULL),(207,98,113,2,NULL),(208,98,3,3,NULL),(209,98,86,4,NULL),(210,98,70,5,NULL),(211,98,4,6,NULL),(212,98,36,7,NULL),(213,98,114,8,NULL),(214,104,6,1,NULL),(215,104,43,2,NULL),(216,104,81,3,NULL),(217,104,109,4,NULL),(218,101,18,1,NULL),(219,101,87,2,NULL),(220,101,115,3,NULL),(221,101,36,4,NULL),(222,101,4,5,NULL),(223,106,116,1,NULL),(224,106,42,2,NULL),(225,114,3,1,NULL),(226,114,110,2,NULL),(227,114,70,3,NULL),(228,114,4,4,NULL),(229,114,115,5,NULL),(230,114,86,6,NULL),(231,114,96,7,NULL),(232,114,112,8,NULL),(233,114,117,9,NULL),(234,114,118,10,NULL),(235,114,119,11,NULL),(236,118,3,1,NULL),(237,118,18,2,NULL),(238,118,120,3,NULL),(239,118,121,4,NULL),(240,118,122,5,NULL),(241,118,123,6,NULL),(242,118,124,7,NULL),(243,115,42,1,NULL),(244,115,125,2,NULL),(245,115,126,3,NULL),(246,115,127,4,NULL),(247,121,3,1,NULL),(248,121,86,2,NULL),(249,121,70,3,NULL),(250,121,4,4,NULL),(251,121,128,5,NULL),(252,121,129,6,NULL),(253,121,36,7,NULL),(254,121,119,8,NULL),(255,122,100,1,NULL),(256,122,43,2,NULL),(257,122,81,3,NULL),(258,122,130,4,NULL),(259,124,18,1,NULL),(260,124,7,2,NULL),(261,124,36,3,NULL),(262,125,42,1,NULL),(263,125,118,2,NULL),(264,125,131,3,NULL),(265,125,126,4,NULL),(266,126,3,1,NULL),(267,126,7,2,NULL),(268,126,110,3,NULL),(269,126,132,4,NULL),(270,126,133,5,NULL),(271,126,134,6,NULL),(272,126,36,7,NULL),(273,126,135,8,NULL),(274,126,136,9,NULL),(275,126,91,10,NULL),(276,127,6,1,NULL),(277,127,81,2,NULL),(278,127,137,3,NULL),(279,127,82,4,NULL),(280,127,112,5,NULL),(281,127,117,6,NULL),(282,127,106,7,NULL),(283,129,42,1,NULL),(284,129,109,2,NULL),(285,129,138,3,NULL),(286,129,139,4,NULL),(287,129,140,5,NULL),(288,130,18,1,NULL),(289,130,110,2,NULL),(290,130,112,3,NULL),(291,130,104,4,NULL),(292,130,97,5,NULL),(293,130,141,6,NULL),(294,131,6,1,NULL),(295,133,18,1,NULL),(296,133,58,2,NULL),(297,133,7,3,NULL),(298,133,142,4,NULL),(299,133,84,5,NULL),(300,133,4,6,NULL),(301,133,143,7,NULL),(302,133,36,8,NULL),(303,133,112,9,NULL),(304,134,100,1,NULL),(305,134,42,2,NULL),(306,134,144,3,NULL),(307,134,145,4,NULL),(308,134,146,5,NULL),(309,134,138,6,NULL),(310,134,146,7,NULL),(311,134,138,8,NULL),(312,134,147,9,NULL),(313,136,3,1,NULL),(314,136,148,2,NULL),(315,136,3,3,NULL),(316,136,148,4,NULL),(317,136,3,5,NULL),(318,136,148,6,NULL),(319,136,70,7,NULL),(320,136,112,8,NULL),(321,136,91,9,NULL),(322,140,42,1,NULL),(323,140,149,2,NULL),(324,140,43,3,NULL),(325,140,125,4,NULL),(326,140,81,5,NULL),(327,140,81,6,NULL),(328,140,81,7,NULL),(329,140,150,8,NULL),(330,140,138,9,NULL),(331,140,151,10,NULL),(332,142,3,1,NULL),(333,142,18,2,NULL),(334,142,110,3,NULL),(335,142,152,4,NULL),(336,142,4,5,NULL),(337,142,57,6,NULL),(338,142,7,7,NULL),(339,142,36,8,NULL),(340,142,153,9,NULL),(341,142,154,10,NULL),(342,143,3,1,NULL),(343,143,7,2,NULL),(344,143,36,3,NULL),(345,143,155,4,NULL),(346,143,36,5,NULL),(347,143,155,6,NULL),(348,143,90,7,NULL),(349,143,84,8,NULL),(350,147,42,1,NULL),(351,147,109,2,NULL),(352,147,138,3,NULL),(353,147,151,4,NULL);
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

-- Dump completed on 2026-06-06 13:09:43
