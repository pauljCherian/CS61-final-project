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
-- Table structure for table `AuditLog`
--

DROP TABLE IF EXISTS `AuditLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AuditLog` (
  `AuditID` int NOT NULL AUTO_INCREMENT,
  `TableName` varchar(50) NOT NULL,
  `Action` enum('CREATE','DELETE') NOT NULL,
  `RowID` int NOT NULL,
  `ChangedBy` varchar(128) NOT NULL DEFAULT (current_user()),
  `ChangedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`AuditID`),
  KEY `idx_audit_table_action` (`TableName`,`Action`),
  KEY `idx_audit_changed_at` (`ChangedAt`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AuditLog`
--

LOCK TABLES `AuditLog` WRITE;
/*!40000 ALTER TABLE `AuditLog` DISABLE KEYS */;
INSERT INTO `AuditLog` VALUES (1,'Users','CREATE',1,'root@localhost','2026-06-07 14:38:38'),(2,'Workouts','CREATE',1,'root@localhost','2026-06-07 14:38:38'),(3,'Workouts','CREATE',2,'root@localhost','2026-06-07 14:38:38'),(4,'Workouts','CREATE',3,'root@localhost','2026-06-07 14:38:38'),(5,'Workouts','CREATE',4,'root@localhost','2026-06-07 14:38:38'),(6,'Workouts','CREATE',5,'root@localhost','2026-06-07 14:38:38'),(7,'Workouts','CREATE',6,'root@localhost','2026-06-07 14:38:38'),(8,'Workouts','CREATE',7,'root@localhost','2026-06-07 14:38:38'),(9,'Workouts','CREATE',8,'root@localhost','2026-06-07 14:38:38'),(10,'Workouts','CREATE',9,'root@localhost','2026-06-07 14:38:38'),(11,'Workouts','CREATE',10,'root@localhost','2026-06-07 14:38:38'),(12,'Workouts','CREATE',11,'root@localhost','2026-06-07 14:38:38'),(13,'Workouts','CREATE',12,'root@localhost','2026-06-07 14:38:38'),(14,'Workouts','CREATE',13,'root@localhost','2026-06-07 14:38:38'),(15,'Workouts','CREATE',14,'root@localhost','2026-06-07 14:38:38'),(16,'Workouts','CREATE',15,'root@localhost','2026-06-07 14:38:38'),(17,'Workouts','CREATE',16,'root@localhost','2026-06-07 14:38:38'),(18,'Workouts','CREATE',17,'root@localhost','2026-06-07 14:38:38'),(19,'Workouts','CREATE',18,'root@localhost','2026-06-07 14:38:38'),(20,'Workouts','CREATE',19,'root@localhost','2026-06-07 14:38:38'),(21,'Workouts','CREATE',20,'root@localhost','2026-06-07 14:38:38'),(22,'Workouts','CREATE',21,'root@localhost','2026-06-07 14:38:38'),(23,'Workouts','CREATE',22,'root@localhost','2026-06-07 14:38:38'),(24,'Workouts','CREATE',23,'root@localhost','2026-06-07 14:38:38'),(25,'Workouts','CREATE',24,'root@localhost','2026-06-07 14:38:38'),(26,'Workouts','CREATE',25,'root@localhost','2026-06-07 14:38:38'),(27,'Workouts','CREATE',26,'root@localhost','2026-06-07 14:38:38'),(28,'Workouts','CREATE',27,'root@localhost','2026-06-07 14:38:38'),(29,'Workouts','CREATE',28,'root@localhost','2026-06-07 14:38:38'),(30,'Workouts','CREATE',29,'root@localhost','2026-06-07 14:38:38'),(31,'Workouts','CREATE',30,'root@localhost','2026-06-07 14:38:38'),(32,'Workouts','CREATE',31,'root@localhost','2026-06-07 14:38:38'),(33,'Workouts','CREATE',32,'root@localhost','2026-06-07 14:38:38'),(34,'Workouts','CREATE',33,'root@localhost','2026-06-07 14:38:38'),(35,'Workouts','CREATE',34,'root@localhost','2026-06-07 14:38:38'),(36,'Workouts','CREATE',35,'root@localhost','2026-06-07 14:38:38'),(37,'Workouts','CREATE',36,'root@localhost','2026-06-07 14:38:38'),(38,'Workouts','CREATE',37,'root@localhost','2026-06-07 14:38:38'),(39,'Workouts','CREATE',38,'root@localhost','2026-06-07 14:38:38'),(40,'Workouts','CREATE',39,'root@localhost','2026-06-07 14:38:38'),(41,'Workouts','CREATE',40,'root@localhost','2026-06-07 14:38:38'),(42,'Workouts','CREATE',41,'root@localhost','2026-06-07 14:38:38'),(43,'Workouts','CREATE',42,'root@localhost','2026-06-07 14:38:38'),(44,'Workouts','CREATE',43,'root@localhost','2026-06-07 14:38:38'),(45,'Workouts','CREATE',44,'root@localhost','2026-06-07 14:38:38'),(46,'Workouts','CREATE',45,'root@localhost','2026-06-07 14:38:38'),(47,'Workouts','CREATE',46,'root@localhost','2026-06-07 14:38:38'),(48,'Workouts','CREATE',47,'root@localhost','2026-06-07 14:38:38'),(49,'Workouts','CREATE',48,'root@localhost','2026-06-07 14:38:38'),(50,'Workouts','CREATE',49,'root@localhost','2026-06-07 14:38:38'),(51,'Workouts','CREATE',50,'root@localhost','2026-06-07 14:38:38'),(52,'Workouts','CREATE',51,'root@localhost','2026-06-07 14:38:38'),(53,'Workouts','CREATE',52,'root@localhost','2026-06-07 14:38:38'),(54,'Workouts','CREATE',53,'root@localhost','2026-06-07 14:38:38'),(55,'Workouts','CREATE',54,'root@localhost','2026-06-07 14:38:38'),(56,'Workouts','CREATE',55,'root@localhost','2026-06-07 14:38:38'),(57,'Workouts','CREATE',56,'root@localhost','2026-06-07 14:38:38'),(58,'Workouts','CREATE',57,'root@localhost','2026-06-07 14:38:38'),(59,'Workouts','CREATE',58,'root@localhost','2026-06-07 14:38:38'),(60,'Workouts','CREATE',59,'root@localhost','2026-06-07 14:38:38'),(61,'Workouts','CREATE',60,'root@localhost','2026-06-07 14:38:38'),(62,'Workouts','CREATE',61,'root@localhost','2026-06-07 14:38:38'),(63,'Workouts','CREATE',62,'root@localhost','2026-06-07 14:38:38'),(64,'Workouts','CREATE',63,'root@localhost','2026-06-07 14:38:38'),(65,'Workouts','CREATE',64,'root@localhost','2026-06-07 14:38:38'),(66,'Workouts','CREATE',65,'root@localhost','2026-06-07 14:38:38'),(67,'Workouts','CREATE',66,'root@localhost','2026-06-07 14:38:38'),(68,'Workouts','CREATE',67,'root@localhost','2026-06-07 14:38:38'),(69,'Workouts','CREATE',68,'root@localhost','2026-06-07 14:38:38'),(70,'Workouts','CREATE',69,'root@localhost','2026-06-07 14:38:38'),(71,'Workouts','CREATE',70,'root@localhost','2026-06-07 14:38:38'),(72,'Workouts','CREATE',71,'root@localhost','2026-06-07 14:38:38'),(73,'Workouts','CREATE',72,'root@localhost','2026-06-07 14:38:38'),(74,'Workouts','CREATE',73,'root@localhost','2026-06-07 14:38:38'),(75,'Workouts','CREATE',74,'root@localhost','2026-06-07 14:38:38'),(76,'Workouts','CREATE',75,'root@localhost','2026-06-07 14:38:38'),(77,'Workouts','CREATE',76,'root@localhost','2026-06-07 14:38:38'),(78,'Workouts','CREATE',77,'root@localhost','2026-06-07 14:38:38'),(79,'Workouts','CREATE',78,'root@localhost','2026-06-07 14:38:38'),(80,'Workouts','CREATE',79,'root@localhost','2026-06-07 14:38:38'),(81,'Workouts','CREATE',80,'root@localhost','2026-06-07 14:38:38'),(82,'Workouts','CREATE',81,'root@localhost','2026-06-07 14:38:38'),(83,'Workouts','CREATE',82,'root@localhost','2026-06-07 14:38:38'),(84,'Workouts','CREATE',83,'root@localhost','2026-06-07 14:38:38'),(85,'Workouts','CREATE',84,'root@localhost','2026-06-07 14:38:38'),(86,'Workouts','CREATE',85,'root@localhost','2026-06-07 14:38:38'),(87,'Workouts','CREATE',86,'root@localhost','2026-06-07 14:38:38'),(88,'Workouts','CREATE',87,'root@localhost','2026-06-07 14:38:38'),(89,'Workouts','CREATE',88,'root@localhost','2026-06-07 14:38:38'),(90,'Workouts','CREATE',89,'root@localhost','2026-06-07 14:38:38'),(91,'Workouts','CREATE',90,'root@localhost','2026-06-07 14:38:38'),(92,'Workouts','CREATE',91,'root@localhost','2026-06-07 14:38:38'),(93,'Workouts','CREATE',92,'root@localhost','2026-06-07 14:38:38'),(94,'Workouts','CREATE',93,'root@localhost','2026-06-07 14:38:38'),(95,'Workouts','CREATE',94,'root@localhost','2026-06-07 14:38:38'),(96,'Workouts','CREATE',95,'root@localhost','2026-06-07 14:38:38'),(97,'Workouts','CREATE',96,'root@localhost','2026-06-07 14:38:38'),(98,'Workouts','CREATE',97,'root@localhost','2026-06-07 14:38:38'),(99,'Workouts','CREATE',98,'root@localhost','2026-06-07 14:38:38'),(100,'Workouts','CREATE',99,'root@localhost','2026-06-07 14:38:38'),(101,'Workouts','CREATE',100,'root@localhost','2026-06-07 14:38:38'),(102,'Workouts','CREATE',101,'root@localhost','2026-06-07 14:38:38'),(103,'Workouts','CREATE',102,'root@localhost','2026-06-07 14:38:38'),(104,'Workouts','CREATE',103,'root@localhost','2026-06-07 14:38:38'),(105,'Workouts','CREATE',104,'root@localhost','2026-06-07 14:38:38'),(106,'Workouts','CREATE',105,'root@localhost','2026-06-07 14:38:38'),(107,'Workouts','CREATE',106,'root@localhost','2026-06-07 14:38:38'),(108,'Workouts','CREATE',107,'root@localhost','2026-06-07 14:38:38'),(109,'Workouts','CREATE',108,'root@localhost','2026-06-07 14:38:38'),(110,'Workouts','CREATE',109,'root@localhost','2026-06-07 14:38:38'),(111,'Workouts','CREATE',110,'root@localhost','2026-06-07 14:38:38'),(112,'Workouts','CREATE',111,'root@localhost','2026-06-07 14:38:38'),(113,'Workouts','CREATE',112,'root@localhost','2026-06-07 14:38:38'),(114,'Workouts','CREATE',113,'root@localhost','2026-06-07 14:38:38'),(115,'Workouts','CREATE',114,'root@localhost','2026-06-07 14:38:38'),(116,'Workouts','CREATE',115,'root@localhost','2026-06-07 14:38:38'),(117,'Workouts','CREATE',116,'root@localhost','2026-06-07 14:38:38'),(118,'Workouts','CREATE',117,'root@localhost','2026-06-07 14:38:38'),(119,'Workouts','CREATE',118,'root@localhost','2026-06-07 14:38:38'),(120,'Workouts','CREATE',119,'root@localhost','2026-06-07 14:38:38'),(121,'Workouts','CREATE',120,'root@localhost','2026-06-07 14:38:38'),(122,'Workouts','CREATE',121,'root@localhost','2026-06-07 14:38:38'),(123,'Workouts','CREATE',122,'root@localhost','2026-06-07 14:38:38'),(124,'Workouts','CREATE',123,'root@localhost','2026-06-07 14:38:38'),(125,'Workouts','CREATE',124,'root@localhost','2026-06-07 14:38:38'),(126,'Workouts','CREATE',125,'root@localhost','2026-06-07 14:38:38'),(127,'Workouts','CREATE',126,'root@localhost','2026-06-07 14:38:38'),(128,'Workouts','CREATE',127,'root@localhost','2026-06-07 14:38:38'),(129,'Workouts','CREATE',128,'root@localhost','2026-06-07 14:38:38'),(130,'Workouts','CREATE',129,'root@localhost','2026-06-07 14:38:38'),(131,'Workouts','CREATE',130,'root@localhost','2026-06-07 14:38:38'),(132,'Workouts','CREATE',131,'root@localhost','2026-06-07 14:38:38'),(133,'Workouts','CREATE',132,'root@localhost','2026-06-07 14:38:38'),(134,'Workouts','CREATE',133,'root@localhost','2026-06-07 14:38:38'),(135,'Workouts','CREATE',134,'root@localhost','2026-06-07 14:38:38'),(136,'Workouts','CREATE',135,'root@localhost','2026-06-07 14:38:38'),(137,'Workouts','CREATE',136,'root@localhost','2026-06-07 14:38:38'),(138,'Workouts','CREATE',137,'root@localhost','2026-06-07 14:38:38'),(139,'Workouts','CREATE',138,'root@localhost','2026-06-07 14:38:38'),(140,'Workouts','CREATE',139,'root@localhost','2026-06-07 14:38:38'),(141,'Workouts','CREATE',140,'root@localhost','2026-06-07 14:38:38'),(142,'Workouts','CREATE',141,'root@localhost','2026-06-07 14:38:38'),(143,'Workouts','CREATE',142,'root@localhost','2026-06-07 14:38:38'),(144,'Workouts','CREATE',143,'root@localhost','2026-06-07 14:38:38'),(145,'Workouts','CREATE',144,'root@localhost','2026-06-07 14:38:38'),(146,'Workouts','CREATE',145,'root@localhost','2026-06-07 14:38:38'),(147,'Workouts','CREATE',146,'root@localhost','2026-06-07 14:38:38');
/*!40000 ALTER TABLE `AuditLog` ENABLE KEYS */;
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
