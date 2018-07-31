-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: cs6400_fa17_team001
-- ------------------------------------------------------
-- Server version	5.7.17
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,POSTGRESQL' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table "AdminUser"
--

DROP TABLE IF EXISTS "AdminUser";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "AdminUser" (
  "adminID" int(16) unsigned NOT NULL,
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "lastlogin" datetime DEFAULT NULL,
  PRIMARY KEY ("adminID"),
  UNIQUE KEY "email" ("email"),
  CONSTRAINT "fk_AdminUser_email_User_email" FOREIGN KEY ("email") REFERENCES "User" ("email")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "AdminUser"
--

LOCK TABLES "AdminUser" WRITE;
/*!40000 ALTER TABLE "AdminUser" DISABLE KEYS */;
INSERT INTO "AdminUser" VALUES (1,'admin01@gtonline.com','2017-07-02 17:40:30'),(2,'admin02@gtonline.com','2017-07-02 17:40:30'),(3,'admin03@gtonline.com','2017-07-02 17:40:30');
/*!40000 ALTER TABLE "AdminUser" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "Attend"
--

DROP TABLE IF EXISTS "Attend";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "Attend" (
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "schoolname" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "yeargraduated" int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY ("email","schoolname","yeargraduated"),
  KEY "schoolname" ("schoolname"),
  CONSTRAINT "fk_Attend_email_RegularUser_email" FOREIGN KEY ("email") REFERENCES "RegularUser" ("email"),
  CONSTRAINT "fk_Attend_schoolname_School_schoolname" FOREIGN KEY ("schoolname") REFERENCES "School" ("schoolname")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "Attend"
--

LOCK TABLES "Attend" WRITE;
/*!40000 ALTER TABLE "Attend" DISABLE KEYS */;
INSERT INTO "Attend" VALUES ('admin03@gtonline.com','Atlanta Art College',2000),('jcortez@gatech.edu','Atlanta Art College',1976),('admin02@gtonline.com','Atlanta High School',1969),('admin03@gtonline.com','Atlanta High School',1997),('danderson@gatech.edu','Atlanta High School',2008),('jcortez@gatech.edu','Atlanta High School',1973),('jcross@gatech.edu','Atlanta High School',2000),('msimpson@gatech.edu','Atlanta High School',1965),('smeadows@gatech.edu','Atlanta High School',1971),('admin01@gtonline.com','Atlanta Tech College',2005),('jcross@gatech.edu','Atlanta Tech College',2003),('kblack@gatech.edu','Atlanta Tech College',2007),('jmartin@gatech.edu','Carnegie Mellon University',2016),('sbrown@gatech.edu','Carnegie Mellon University',1993),('cboone@gatech.edu','Georgia Art College',1987),('sflowers@gatech.edu','Georgia Art College',1973),('smeadows@gatech.edu','Georgia Art College',1974),('dgeorge@gatech.edu','Georgia Institute of Technology',2013),('jcross@gatech.edu','Georgia Institute of Technology',2007),('kblack@gatech.edu','Georgia Institute of Technology',2011),('swiggins@gatech.edu','Georgia Institute of Technology',1995),('bsuarez@gatech.edu','Georgia Junior College',2006),('danderson@gatech.edu','Georgia Junior College',2011),('dgeorge@gatech.edu','Georgia Junior College',2009),('swiggins@gatech.edu','Georgia Military Academy',1991),('jmartin@gatech.edu','Georgia Military College',2012),('msimpson@gatech.edu','Georgia Military College',1968),('admin02@gtonline.com','Georgia Perimeter College',1972),('michael@bluthco.com','Georgia Perimeter College',1991),('sbrown@gatech.edu','Georgia Perimeter College',1989),('slopez@gatech.edu','Georgia Technical College',1994),('bsuarez@gatech.edu','Lakeside High School',2003),('jmartin@gatech.edu','Lakeside High School',2009),('kblack@gatech.edu','Lakeside High School',2004),('michael@bluthco.com','Lakeside High School',1988),('sbrown@gatech.edu','Lakeside High School',1986),('swiggins@gatech.edu','Lakeside High School',1988),('admin03@gtonline.com','Massachusetts Institue of Technology',2004),('cboone@gatech.edu','Massachusetts Institue of Technology',1991),('slopez@gatech.edu','Massachusetts Institue of Technology',1998),('smeadows@gatech.edu','Massachusetts Institue of Technology',1978),('admin01@gtonline.com','North Springs High School',2002),('cboone@gatech.edu','North Springs High School',1984),('dgeorge@gatech.edu','North Springs High School',2006),('sflowers@gatech.edu','North Springs High School',1970),('slopez@gatech.edu','North Springs High School',1991),('admin02@gtonline.com','Stanford University',1976),('msimpson@gatech.edu','Stanford University',1972),('admin01@gtonline.com','University of California',2009),('jcortez@gatech.edu','University of California',1980),('michael@bluthco.com','University of California',1995),('bsuarez@gatech.edu','University of Georgia',2010),('danderson@gatech.edu','University of Georgia',2015),('sflowers@gatech.edu','University of Georgia',1977);
/*!40000 ALTER TABLE "Attend" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "Comment"
--

DROP TABLE IF EXISTS "Comment";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "Comment" (
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "dateandtime" datetime NOT NULL,
  "commenttext" varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  "suemail" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "sudateandtime" datetime NOT NULL,
  PRIMARY KEY ("email","dateandtime"),
  KEY "suemail" ("suemail","sudateandtime"),
  CONSTRAINT "fk_Comment_suemail_sudatetime_StatusUpdate_email_datetime" FOREIGN KEY ("suemail", "sudateandtime") REFERENCES "StatusUpdate" ("email", "dateandtime")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "Comment"
--

LOCK TABLES "Comment" WRITE;
/*!40000 ALTER TABLE "Comment" DISABLE KEYS */;
INSERT INTO "Comment" VALUES ('admin01@gtonline.com','2017-06-07 17:40:30','Focused client-server budgetary management','kblack@gatech.edu','2017-05-02 12:00:30'),('admin01@gtonline.com','2017-06-14 17:40:30','Customizable radical conglomeration','cboone@gatech.edu','2017-03-02 16:50:22'),('admin02@gtonline.com','2017-06-11 17:40:30','Focused scalable secured line','bsuarez@gatech.edu','2017-04-02 11:21:55'),('admin02@gtonline.com','2017-06-15 17:40:30','Optimized global success','smeadows@gatech.edu','2017-04-02 11:21:55'),('admin03@gtonline.com','2017-06-14 17:40:30','Grass-roots multi-state approach','jmartin@gatech.edu','2017-03-02 16:50:22'),('admin03@gtonline.com','2017-06-30 17:40:30','Programmable zero tolerance Internet solution','jcortez@gatech.edu','2017-03-02 16:50:22'),('bsuarez@gatech.edu','2017-06-21 17:40:30','Re-engineered impactful process improvement','jcortez@gatech.edu','2017-05-02 12:00:30'),('cboone@gatech.edu','2017-06-10 17:40:30','Enterprise-wide grid-enabled parallelism','admin03@gtonline.com','2017-03-02 16:50:22'),('cboone@gatech.edu','2017-06-29 17:40:30','Team-oriented methodical instruction set','admin02@gtonline.com','2017-05-02 12:00:30'),('danderson@gatech.edu','2017-06-04 17:40:30','Enterprise-wide attitude-oriented extranet','admin01@gtonline.com','2017-04-02 11:21:55'),('danderson@gatech.edu','2017-06-16 17:40:30','Extended context-sensitive framework','cboone@gatech.edu','2017-03-02 16:50:22'),('dgeorge@gatech.edu','2017-06-04 17:40:30','Persistent attitude-oriented middleware','jcross@gatech.edu','2017-04-02 11:21:55'),('dgeorge@gatech.edu','2017-06-06 17:40:30','Progressive cohesive methodology','msimpson@gatech.edu','2017-03-02 16:50:22'),('jcortez@gatech.edu','2017-06-20 17:40:30','Customizable optimizing time-frame','kblack@gatech.edu','2017-05-02 12:00:30'),('jcortez@gatech.edu','2017-06-24 17:40:30','Re-engineered system-worthy protocol','michael@bluthco.com','2017-05-02 12:00:30'),('jcross@gatech.edu','2017-06-11 17:40:30','Open-architected mobile interface','slopez@gatech.edu','2017-04-02 11:21:55'),('jcross@gatech.edu','2017-06-16 17:40:30','Exclusive exuding forecast','smeadows@gatech.edu','2017-03-02 16:50:22'),('jmartin@gatech.edu','2017-06-10 17:40:30','Implemented optimal knowledge user','admin02@gtonline.com','2017-04-02 11:21:55'),('jmartin@gatech.edu','2017-06-19 17:40:30','Virtual systematic system engine','admin03@gtonline.com','2017-03-02 16:50:22'),('kblack@gatech.edu','2017-06-07 17:40:30','Grass-roots clear-thinking model','sflowers@gatech.edu','2017-05-02 12:00:30'),('kblack@gatech.edu','2017-06-17 17:40:30','Configurable fresh-thinking Graphical User Interfa','jcross@gatech.edu','2017-03-02 16:50:22'),('michael@bluthco.com','2017-06-04 17:40:30','Operative 3rdgeneration application','jmartin@gatech.edu','2017-03-02 16:50:22'),('michael@bluthco.com','2017-06-12 17:40:30','Balanced optimizing collaboration','swiggins@gatech.edu','2017-03-02 16:50:22'),('msimpson@gatech.edu','2017-06-20 17:40:30','Open-source logistical capacity','bsuarez@gatech.edu','2017-03-02 16:50:22'),('msimpson@gatech.edu','2017-06-26 17:40:30','Right-sized 24hour strategy','sflowers@gatech.edu','2017-03-02 16:50:22'),('sbrown@gatech.edu','2017-06-08 17:40:30','Synergized modular monitoring','michael@bluthco.com','2017-04-02 11:21:55'),('sbrown@gatech.edu','2017-06-19 17:40:30','Function-based fresh-thinking hardware','admin01@gtonline.com','2017-03-02 16:50:22'),('sflowers@gatech.edu','2017-06-25 17:40:30','Focused dedicated Graphic Interface','sbrown@gatech.edu','2017-03-02 16:50:22'),('sflowers@gatech.edu','2017-06-30 17:40:30','Stand-alone human-resource implementation','danderson@gatech.edu','2017-04-02 11:21:55'),('slopez@gatech.edu','2017-06-09 17:40:30','Fundamental context-sensitive info-mediaries','swiggins@gatech.edu','2017-03-02 16:50:22'),('slopez@gatech.edu','2017-06-27 17:40:30','Grass-roots composite open architecture','dgeorge@gatech.edu','2017-03-02 16:50:22'),('smeadows@gatech.edu','2017-06-11 17:40:30','Function-based empowering definition','slopez@gatech.edu','2017-05-02 12:00:30'),('smeadows@gatech.edu','2017-06-19 17:40:30','Profit-focused eco-centric implementation','msimpson@gatech.edu','2017-04-02 11:21:55'),('swiggins@gatech.edu','2017-06-16 17:40:30','Face-to-face tangible matrix','dgeorge@gatech.edu','2017-03-02 16:50:22'),('swiggins@gatech.edu','2017-06-28 17:40:30','Open-architected zero tolerance projection','danderson@gatech.edu','2017-04-02 11:21:55');
/*!40000 ALTER TABLE "Comment" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "Employer"
--

DROP TABLE IF EXISTS "Employer";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "Employer" (
  "employername" varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY ("employername")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "Employer"
--

LOCK TABLES "Employer" WRITE;
/*!40000 ALTER TABLE "Employer" DISABLE KEYS */;
INSERT INTO "Employer" VALUES ('Adams: Cox and Snyder'),('Ayala-Jones'),('Bolton: Gallegos and Mitchell'),('Brown-Lindsey'),('Cantu and Sons'),('Carter-Foster'),('Carter-Turner'),('Chambers: Brown and Walters'),('Frost-Mejia'),('Guerra Ltd'),('Gutierrez: Roberts and Newman'),('Jones-Berry'),('Knight-Graham'),('Long: Evans and Morris'),('Mathis Ltd'),('Mccall: Salinas and Evans'),('Murphy: Lee and Green'),('Peterson-Monroe'),('Peterson: Thomas and Fernandez'),('Ramirez Inc'),('Roman Inc'),('Schmitt-Pennington'),('Scott-Walter'),('Shannon and Sons'),('Simmons Inc'),('Smith-Li'),('Smith: Bishop and Tanner'),('Smith: Powell and Barnes'),('Snyder Inc'),('Walsh Group'),('Watson Group'),('Williams-Peters'),('Williams: Anderson and Juarez'),('Wilson: Taylor and Hicks'),('Wright-Hall'),('Young Inc');
/*!40000 ALTER TABLE "Employer" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "Employment"
--

DROP TABLE IF EXISTS "Employment";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "Employment" (
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "employername" varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  "jobtitle" varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY ("email","employername"),
  KEY "employername" ("employername"),
  CONSTRAINT "fk_Employment_email_RegularUser_email" FOREIGN KEY ("email") REFERENCES "RegularUser" ("email"),
  CONSTRAINT "fk_Employment_employername_Employer_employername" FOREIGN KEY ("employername") REFERENCES "Employer" ("employername")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "Employment"
--

LOCK TABLES "Employment" WRITE;
/*!40000 ALTER TABLE "Employment" DISABLE KEYS */;
INSERT INTO "Employment" VALUES ('admin01@gtonline.com','Ayala-Jones','Art Gallery Manager'),('admin01@gtonline.com','Long: Evans and Morris','Radio Producer'),('admin02@gtonline.com','Carter-Turner','Scientist: Marine'),('admin02@gtonline.com','Williams: Anderson and Juarez','Wellsite Geologist'),('admin03@gtonline.com','Bolton: Gallegos and Mitchell','Public House Manager'),('admin03@gtonline.com','Roman Inc','Designer: Textile'),('bsuarez@gatech.edu','Cantu and Sons','Professor Emeritus'),('bsuarez@gatech.edu','Wright-Hall','Civil Service Administrator'),('cboone@gatech.edu','Gutierrez: Roberts and Newman','Administrator: Sports'),('cboone@gatech.edu','Scott-Walter','Contracting Civil Engineer'),('danderson@gatech.edu','Peterson-Monroe','Television Production Assistant'),('danderson@gatech.edu','Young Inc','Materials Engineer'),('dgeorge@gatech.edu','Shannon and Sons','Quantity Surveyor'),('dgeorge@gatech.edu','Williams-Peters','Garment/textile Technologist'),('jcortez@gatech.edu','Guerra Ltd','Microbiologist'),('jcortez@gatech.edu','Mathis Ltd','Ship Broker'),('jcross@gatech.edu','Simmons Inc','Agricultural Engineer'),('jcross@gatech.edu','Smith-Li','Building Control Surveyor'),('jmartin@gatech.edu','Brown-Lindsey','Music Therapist'),('jmartin@gatech.edu','Wilson: Taylor and Hicks','Health And Safety Adviser'),('kblack@gatech.edu','Jones-Berry','Fashion Designer'),('kblack@gatech.edu','Walsh Group','Teacher: Early Years/pre'),('michael@bluthco.com','Frost-Mejia','Lecturer: Further Education'),('michael@bluthco.com','Smith: Bishop and Tanner','Engineer: Petroleum'),('msimpson@gatech.edu','Schmitt-Pennington','Engineer: Communications'),('msimpson@gatech.edu','Watson Group','Biomedical Scientist'),('sbrown@gatech.edu','Carter-Foster','Insurance Claims Handler'),('sbrown@gatech.edu','Snyder Inc','Lighting Technician: Broadcasting/film/video'),('sflowers@gatech.edu','Adams: Cox and Snyder','Fish Farm Manager'),('sflowers@gatech.edu','Knight-Graham','Retail Manager'),('slopez@gatech.edu','Murphy: Lee and Green','Health Service Manager'),('slopez@gatech.edu','Smith: Powell and Barnes','Retail Merchandiser'),('smeadows@gatech.edu','Mccall: Salinas and Evans','Visual Merchandiser'),('smeadows@gatech.edu','Ramirez Inc','Food Technologist'),('swiggins@gatech.edu','Chambers: Brown and Walters','Community Education Officer'),('swiggins@gatech.edu','Peterson: Thomas and Fernandez','Research Officer: Political Party');
/*!40000 ALTER TABLE "Employment" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "Friendship"
--

DROP TABLE IF EXISTS "Friendship";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "Friendship" (
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "friendemail" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "relationship" varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  "dateconnected" date DEFAULT NULL,
  PRIMARY KEY ("email","friendemail"),
  KEY "friendemail" ("friendemail"),
  CONSTRAINT "fk_Friendship_email_RegularUser_email" FOREIGN KEY ("email") REFERENCES "RegularUser" ("email") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_Friendship_freindemail_RegularUser_email" FOREIGN KEY ("friendemail") REFERENCES "RegularUser" ("email") ON DELETE CASCADE ON UPDATE CASCADE
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "Friendship"
--

LOCK TABLES "Friendship" WRITE;
/*!40000 ALTER TABLE "Friendship" DISABLE KEYS */;
INSERT INTO "Friendship" VALUES ('admin01@gtonline.com','admin02@gtonline.com','Sibling',NULL),('admin01@gtonline.com','jcortez@gatech.edu','Cousin',NULL),('admin01@gtonline.com','jcross@gatech.edu','Mentor','2017-05-28'),('admin01@gtonline.com','slopez@gatech.edu','Coworker',NULL),('admin01@gtonline.com','smeadows@gatech.edu','Sweetheart','2017-05-02'),('admin01@gtonline.com','swiggins@gatech.edu','Coworker','2012-07-02'),('admin02@gtonline.com','bsuarez@gatech.edu','Parent',NULL),('admin02@gtonline.com','jcortez@gatech.edu','Mentor','2016-10-02'),('admin02@gtonline.com','kblack@gatech.edu','Mentor',NULL),('admin02@gtonline.com','msimpson@gatech.edu','Sibling','1999-07-02'),('admin02@gtonline.com','sbrown@gatech.edu','Mentor','2013-07-02'),('admin02@gtonline.com','sflowers@gatech.edu','Parent',NULL),('admin03@gtonline.com','admin02@gtonline.com','Coworker','2001-07-02'),('admin03@gtonline.com','danderson@gatech.edu','Facebook',NULL),('admin03@gtonline.com','jmartin@gatech.edu','Bestie',NULL),('admin03@gtonline.com','slopez@gatech.edu','Facebook','2017-02-02'),('admin03@gtonline.com','smeadows@gatech.edu','LinkedIn','2017-05-02'),('bsuarez@gatech.edu','admin01@gtonline.com','Sibling','2017-06-18'),('bsuarez@gatech.edu','danderson@gatech.edu','Facebook',NULL),('bsuarez@gatech.edu','dgeorge@gatech.edu','Peer','1990-07-02'),('bsuarez@gatech.edu','michael@bluthco.com','Parent',NULL),('bsuarez@gatech.edu','msimpson@gatech.edu','Grandchild',NULL),('cboone@gatech.edu','admin01@gtonline.com','Grandchild',NULL),('cboone@gatech.edu','admin03@gtonline.com','Colleague',NULL),('cboone@gatech.edu','bsuarez@gatech.edu','Cousin','2009-07-02'),('cboone@gatech.edu','jcortez@gatech.edu','Peer','2017-04-30'),('cboone@gatech.edu','jmartin@gatech.edu','Partner',NULL),('cboone@gatech.edu','michael@bluthco.com','Child','2017-02-26'),('danderson@gatech.edu','admin03@gtonline.com','Partner','2017-02-05'),('danderson@gatech.edu','jcortez@gatech.edu','Sweetheart',NULL),('danderson@gatech.edu','kblack@gatech.edu','Parent','1993-07-02'),('danderson@gatech.edu','sbrown@gatech.edu','Coworker',NULL),('danderson@gatech.edu','sflowers@gatech.edu','Facebook','2017-02-12'),('danderson@gatech.edu','smeadows@gatech.edu','Sweetheart',NULL),('dgeorge@gatech.edu','cboone@gatech.edu','Cousin','2017-01-15'),('dgeorge@gatech.edu','danderson@gatech.edu','Coworker','2017-03-19'),('dgeorge@gatech.edu','jcortez@gatech.edu','LinkedIn',NULL),('dgeorge@gatech.edu','jcross@gatech.edu','Sibling',NULL),('dgeorge@gatech.edu','sflowers@gatech.edu','Cousin','2012-07-02'),('jcortez@gatech.edu','admin02@gtonline.com','Sibling','2010-07-02'),('jcortez@gatech.edu','dgeorge@gatech.edu','Parent','2017-03-12'),('jcortez@gatech.edu','jmartin@gatech.edu','Colleague','2016-09-02'),('jcortez@gatech.edu','sbrown@gatech.edu','Parent',NULL),('jcortez@gatech.edu','smeadows@gatech.edu','Bestie',NULL),('jcortez@gatech.edu','swiggins@gatech.edu','Cousin',NULL),('jcross@gatech.edu','admin02@gtonline.com','Coworker',NULL),('jcross@gatech.edu','admin03@gtonline.com','Cousin',NULL),('jcross@gatech.edu','bsuarez@gatech.edu','Cousin',NULL),('jcross@gatech.edu','jmartin@gatech.edu','Sweetheart','2010-07-02'),('jcross@gatech.edu','sbrown@gatech.edu','Mentor','2005-07-02'),('jcross@gatech.edu','swiggins@gatech.edu','LinkedIn','2010-07-02'),('jmartin@gatech.edu','cboone@gatech.edu','Partner',NULL),('jmartin@gatech.edu','kblack@gatech.edu','LinkedIn','2014-07-02'),('jmartin@gatech.edu','michael@bluthco.com','Parent',NULL),('jmartin@gatech.edu','sflowers@gatech.edu','Peer',NULL),('jmartin@gatech.edu','slopez@gatech.edu','Facebook','2017-03-26'),('kblack@gatech.edu','cboone@gatech.edu','Facebook','2016-06-02'),('kblack@gatech.edu','danderson@gatech.edu','Facebook','2017-04-09'),('kblack@gatech.edu','dgeorge@gatech.edu','Grandchild','2017-01-29'),('kblack@gatech.edu','michael@bluthco.com','Colleague',NULL),('kblack@gatech.edu','msimpson@gatech.edu','Sweetheart',NULL),('kblack@gatech.edu','smeadows@gatech.edu','Partner',NULL),('michael@bluthco.com','admin01@gtonline.com','Sibling',NULL),('michael@bluthco.com','dgeorge@gatech.edu','Mentor',NULL),('michael@bluthco.com','jcortez@gatech.edu','Sweetheart','2017-03-26'),('michael@bluthco.com','jcross@gatech.edu','Colleague','2017-01-15'),('michael@bluthco.com','msimpson@gatech.edu','Sweetheart',NULL),('michael@bluthco.com','smeadows@gatech.edu','Parent','2015-09-02'),('msimpson@gatech.edu','admin02@gtonline.com','Sibling',NULL),('msimpson@gatech.edu','cboone@gatech.edu','Partner',NULL),('msimpson@gatech.edu','jcross@gatech.edu','Child','2017-03-19'),('msimpson@gatech.edu','jmartin@gatech.edu','Facebook','2005-07-02'),('msimpson@gatech.edu','slopez@gatech.edu','Significant Other','2017-02-05'),('msimpson@gatech.edu','swiggins@gatech.edu','LinkedIn',NULL),('sbrown@gatech.edu','admin02@gtonline.com','Sweetheart',NULL),('sbrown@gatech.edu','danderson@gatech.edu','Facebook','2017-05-14'),('sbrown@gatech.edu','dgeorge@gatech.edu','Significant Other',NULL),('sbrown@gatech.edu','jcross@gatech.edu','Grandchild','2014-07-02'),('sbrown@gatech.edu','kblack@gatech.edu','Significant Other',NULL),('sbrown@gatech.edu','swiggins@gatech.edu','Parent','1994-07-02'),('sflowers@gatech.edu','admin01@gtonline.com','Mentor','2016-07-02'),('sflowers@gatech.edu','admin03@gtonline.com','Parent','2016-08-02'),('sflowers@gatech.edu','bsuarez@gatech.edu','Coworker',NULL),('sflowers@gatech.edu','cboone@gatech.edu','Sweetheart','2017-04-02'),('sflowers@gatech.edu','msimpson@gatech.edu','Grandchild',NULL),('sflowers@gatech.edu','sbrown@gatech.edu','Grandchild',NULL),('slopez@gatech.edu','jmartin@gatech.edu','Facebook',NULL),('slopez@gatech.edu','kblack@gatech.edu','Facebook','2017-03-26'),('slopez@gatech.edu','sflowers@gatech.edu','Colleague','1996-07-02'),('slopez@gatech.edu','swiggins@gatech.edu','Parent','2013-07-02'),('smeadows@gatech.edu','admin01@gtonline.com','Mentor',NULL),('smeadows@gatech.edu','michael@bluthco.com','Cousin',NULL),('smeadows@gatech.edu','sbrown@gatech.edu','Coworker',NULL),('smeadows@gatech.edu','sflowers@gatech.edu','Partner','2016-12-18'),('smeadows@gatech.edu','slopez@gatech.edu','Facebook','2009-07-02'),('swiggins@gatech.edu','admin03@gtonline.com','Facebook','2017-01-29'),('swiggins@gatech.edu','bsuarez@gatech.edu','Grandchild',NULL),('swiggins@gatech.edu','kblack@gatech.edu','Bestie','2003-07-02'),('swiggins@gatech.edu','msimpson@gatech.edu','Child',NULL);
/*!40000 ALTER TABLE "Friendship" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "RegularUser"
--

DROP TABLE IF EXISTS "RegularUser";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "RegularUser" (
  "regularUserID" int(16) unsigned NOT NULL,
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "birthdate" date NOT NULL,
  "gender" enum('Male','Female') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  "currentcity" varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  "hometown" varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY ("regularUserID"),
  UNIQUE KEY "email" ("email"),
  CONSTRAINT "fk_RegularUser_email_User_email" FOREIGN KEY ("email") REFERENCES "User" ("email")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "RegularUser"
--

LOCK TABLES "RegularUser" WRITE;
/*!40000 ALTER TABLE "RegularUser" DISABLE KEYS */;
INSERT INTO "RegularUser" VALUES (1,'michael@bluthco.com','1970-10-15','Male','Port Timothy','East Sydneyfort'),(2,'jmartin@gatech.edu','1991-06-25','Male','East Ashleymouth','Lake Emma'),(3,'jcross@gatech.edu','1982-07-24','Male','Reynoldsfort','Lauraberg'),(4,'bsuarez@gatech.edu','1985-01-17','Male','West Joshua','Port Jonathan'),(5,'msimpson@gatech.edu','1947-10-12','Male','Port Tiffany','Maryfurt'),(6,'danderson@gatech.edu','1990-08-17','Male','Jordanbury','Lake Natashaburgh'),(7,'swiggins@gatech.edu','1970-04-27','Male','Peggystad','Anthonyside'),(8,'dgeorge@gatech.edu','1988-07-28','Male','Maysfurt','Prattfurt'),(9,'jcortez@gatech.edu','1955-03-27','Female','East Rachelhaven','Clementsburgh'),(10,'smeadows@gatech.edu','1953-04-26','Female','Marcland','Lake Angela'),(11,'sbrown@gatech.edu','1968-11-11','Female','East Alexisport','Joshuahaven'),(12,'cboone@gatech.edu','1966-05-19','Female','Veronicaview','New Ericmouth'),(13,'kblack@gatech.edu','1986-07-11','Female','Lake Katherine','Perkinsville'),(14,'sflowers@gatech.edu','1952-11-10','Female','Christineland','Lake Joshuamouth'),(15,'slopez@gatech.edu','1973-05-09','Female','New Vanessa','Kevinfort'),(16,'admin01@gtonline.com','1984-09-03','Female','Thompsonhaven','Phillipberg'),(17,'admin02@gtonline.com','1951-10-20','Male','New Brendafort','Vanessafort'),(18,'admin03@gtonline.com','1979-07-10','Female','Kellyland','Lake Taylorfurt');
/*!40000 ALTER TABLE "RegularUser" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "School"
--

DROP TABLE IF EXISTS "School";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "School" (
  "schoolname" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "schooltype" varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY ("schoolname"),
  KEY "schooltype" ("schooltype"),
  CONSTRAINT "fk_School_schooltype_SchoolType_typename" FOREIGN KEY ("schooltype") REFERENCES "SchoolType" ("typename")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "School"
--

LOCK TABLES "School" WRITE;
/*!40000 ALTER TABLE "School" DISABLE KEYS */;
INSERT INTO "School" VALUES ('Atlanta Art College','Art Institue'),('Atlanta College of Art','Art Institue'),('Georgia Art College','Art Institue'),('Georgia Junior College','Community College'),('Georgia Perimeter College','Community College'),('Stanford Brown Junior College','Community College'),('Atlanta High School','High School'),('Lakeside High School','High School'),('North Springs High School','High School'),('Georgia Military Academy','Military'),('Georgia Military College','Military'),('Atlanta Tech College','Technical College'),('Atlanta Technical College','Technical College'),('Georgia Technical College','Technical College'),('California Institute of Technology','University'),('Carnegie Mellon University','University'),('Georgia Institute of Technology','University'),('Massachusetts Institue of Technology','University'),('Stanford University','University'),('University of California','University'),('University of Colorado','University'),('University of Georgia','University');
/*!40000 ALTER TABLE "School" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "SchoolType"
--

DROP TABLE IF EXISTS "SchoolType";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "SchoolType" (
  "typename" varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY ("typename")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "SchoolType"
--

LOCK TABLES "SchoolType" WRITE;
/*!40000 ALTER TABLE "SchoolType" DISABLE KEYS */;
INSERT INTO "SchoolType" VALUES ('Art Institue'),('Community College'),('High School'),('Military'),('Technical College'),('University');
/*!40000 ALTER TABLE "SchoolType" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "StatusUpdate"
--

DROP TABLE IF EXISTS "StatusUpdate";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "StatusUpdate" (
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "dateandtime" datetime NOT NULL,
  "statustext" varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY ("email","dateandtime"),
  KEY "dateandtime" ("dateandtime"),
  CONSTRAINT "fk_StatusUpdate_email_RegularUser_email" FOREIGN KEY ("email") REFERENCES "RegularUser" ("email")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "StatusUpdate"
--

LOCK TABLES "StatusUpdate" WRITE;
/*!40000 ALTER TABLE "StatusUpdate" DISABLE KEYS */;
INSERT INTO "StatusUpdate" VALUES ('admin01@gtonline.com','2017-03-02 16:50:22','Compatible modular toolset'),('admin01@gtonline.com','2017-04-02 11:21:55','Automated bandwidth-monitored definition'),('admin01@gtonline.com','2017-05-02 12:00:30','Robust bi-directional application'),('admin02@gtonline.com','2017-03-02 16:50:22','Synchronized even-keeled protocol'),('admin02@gtonline.com','2017-04-02 11:21:55','Operative zero-defect knowledgebase'),('admin02@gtonline.com','2017-05-02 12:00:30','Total motivating encoding'),('admin03@gtonline.com','2017-03-02 16:50:22','Multi-tiered directional hierarchy'),('admin03@gtonline.com','2017-04-02 11:21:55','Expanded 24hour implementation'),('admin03@gtonline.com','2017-05-02 12:00:30','Function-based analyzing superstructure'),('bsuarez@gatech.edu','2017-03-02 16:50:22','Open-architected next generation task-force'),('bsuarez@gatech.edu','2017-04-02 11:21:55','Diverse 6thgeneration success'),('bsuarez@gatech.edu','2017-05-02 12:00:30','Mandatory next generation adapter'),('cboone@gatech.edu','2017-03-02 16:50:22','Business-focused clear-thinking methodology'),('cboone@gatech.edu','2017-04-02 11:21:55','Realigned uniform complexity'),('cboone@gatech.edu','2017-05-02 12:00:30','Multi-layered 6thgeneration success'),('danderson@gatech.edu','2017-03-02 16:50:22','Multi-lateral encompassing portal'),('danderson@gatech.edu','2017-04-02 11:21:55','Re-contextualized actuating conglomeration'),('danderson@gatech.edu','2017-05-02 12:00:30','User-centric secondary moratorium'),('dgeorge@gatech.edu','2017-03-02 16:50:22','Function-based user-facing paradigm'),('dgeorge@gatech.edu','2017-04-02 11:21:55','Grass-roots client-server leverage'),('dgeorge@gatech.edu','2017-05-02 12:00:30','Persistent disintermediate project'),('jcortez@gatech.edu','2017-03-02 16:50:22','Reverse-engineered object-oriented hub'),('jcortez@gatech.edu','2017-04-02 11:21:55','Sharable static toolset'),('jcortez@gatech.edu','2017-05-02 12:00:30','Synergistic multimedia protocol'),('jcross@gatech.edu','2017-03-02 16:50:22','Programmable radical flexibility'),('jcross@gatech.edu','2017-04-02 11:21:55','Team-oriented stable toolset'),('jcross@gatech.edu','2017-05-02 12:00:30','Total heuristic support'),('jmartin@gatech.edu','2017-03-02 16:50:22','Proactive 3rdgeneration Graphic Interface'),('jmartin@gatech.edu','2017-04-02 11:21:55','Adaptive user-facing groupware'),('jmartin@gatech.edu','2017-05-02 12:00:30','Open-architected didactic conglomeration'),('kblack@gatech.edu','2017-03-02 16:50:22','Optional 5thgeneration challenge'),('kblack@gatech.edu','2017-04-02 11:21:55','Proactive stable moratorium'),('kblack@gatech.edu','2017-05-02 12:00:30','Business-focused holistic forecast'),('michael@bluthco.com','2017-03-02 16:50:22','Networked impactful forecast'),('michael@bluthco.com','2017-04-02 11:21:55','Ergonomic radical artificial intelligence'),('michael@bluthco.com','2017-05-02 12:00:30','Progressive zero tolerance strategy'),('msimpson@gatech.edu','2017-03-02 16:50:22','Self-enabling homogeneous middleware'),('msimpson@gatech.edu','2017-04-02 11:21:55','Networked asynchronous process improvement'),('msimpson@gatech.edu','2017-05-02 12:00:30','Networked stable process improvement'),('sbrown@gatech.edu','2017-03-02 16:50:22','Diverse motivating frame'),('sbrown@gatech.edu','2017-04-02 11:21:55','Public-key discrete website'),('sbrown@gatech.edu','2017-05-02 12:00:30','Front-line even-keeled middleware'),('sflowers@gatech.edu','2017-03-02 16:50:22','Realigned encompassing pricing structure'),('sflowers@gatech.edu','2017-04-02 11:21:55','Public-key object-oriented database'),('sflowers@gatech.edu','2017-05-02 12:00:30','Versatile intermediate model'),('slopez@gatech.edu','2017-03-02 16:50:22','Enhanced encompassing software'),('slopez@gatech.edu','2017-04-02 11:21:55','Exclusive 24hour system engine'),('slopez@gatech.edu','2017-05-02 12:00:30','Devolved bifurcated core'),('smeadows@gatech.edu','2017-03-02 16:50:22','Open-architected human-resource ability'),('smeadows@gatech.edu','2017-04-02 11:21:55','Persevering homogeneous encoding'),('smeadows@gatech.edu','2017-05-02 12:00:30','Ergonomic 6thgeneration implementation'),('swiggins@gatech.edu','2017-03-02 16:50:22','Switchable neutral artificial intelligence'),('swiggins@gatech.edu','2017-04-02 11:21:55','Enhanced human-resource emulation'),('swiggins@gatech.edu','2017-05-02 12:00:30','Profit-focused full-range focus group');
/*!40000 ALTER TABLE "StatusUpdate" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "User"
--

DROP TABLE IF EXISTS "User";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "User" (
  "userID" int(16) unsigned NOT NULL,
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "password" varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  "firstname" varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  "lastname" varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY ("userID"),
  UNIQUE KEY "email" ("email")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "User"
--

LOCK TABLES "User" WRITE;
/*!40000 ALTER TABLE "User" DISABLE KEYS */;
INSERT INTO "User" VALUES (1,'michael@bluthco.com','michael123','Michael','Bluth'),(2,'jmartin@gatech.edu','password123','John','Martin'),(3,'jcross@gatech.edu','password123','Jeffrey','Cross'),(4,'bsuarez@gatech.edu','password123','Brandon','Suarez'),(5,'msimpson@gatech.edu','password123','Michael','Simpson'),(6,'danderson@gatech.edu','password123','Don','Anderson'),(7,'swiggins@gatech.edu','password123','Samuel','Wiggins'),(8,'dgeorge@gatech.edu','password123','Derek','George'),(9,'jcortez@gatech.edu','password123','Jessica','Cortez'),(10,'smeadows@gatech.edu','password123','Sarah','Meadows'),(11,'sbrown@gatech.edu','password123','Sara','Brown'),(12,'cboone@gatech.edu','password123','Crystal','Boone'),(13,'kblack@gatech.edu','password123','Karen','Black'),(14,'sflowers@gatech.edu','password123','Sandra','Flowers'),(15,'slopez@gatech.edu','password123','Stacy','Lopez'),(16,'admin01@gtonline.com','admin123','Dana','Thomas'),(17,'admin02@gtonline.com','admin123','David','Vargas'),(18,'admin03@gtonline.com','admin123','Debra','Cohen');
/*!40000 ALTER TABLE "User" ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table "UserInterest"
--

DROP TABLE IF EXISTS "UserInterest";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "UserInterest" (
  "email" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  "Interest" varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY ("email","Interest"),
  CONSTRAINT "fk_UserInterest_email_RegularUser_email" FOREIGN KEY ("email") REFERENCES "RegularUser" ("email")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table "UserInterest"
--

LOCK TABLES "UserInterest" WRITE;
/*!40000 ALTER TABLE "UserInterest" DISABLE KEYS */;
INSERT INTO "UserInterest" VALUES ('admin01@gtonline.com','hunting'),('admin01@gtonline.com','reading'),('admin01@gtonline.com','skiing'),('admin01@gtonline.com','volleyball'),('admin02@gtonline.com','collecting'),('admin02@gtonline.com','golf'),('admin02@gtonline.com','listening to music'),('admin02@gtonline.com','travel'),('admin03@gtonline.com','gaming'),('admin03@gtonline.com','swimming'),('admin03@gtonline.com','theater'),('admin03@gtonline.com','wood working'),('bsuarez@gatech.edu','art'),('bsuarez@gatech.edu','base jumping'),('bsuarez@gatech.edu','kayaking'),('bsuarez@gatech.edu','riding lightrail'),('cboone@gatech.edu','hiking'),('cboone@gatech.edu','reading'),('cboone@gatech.edu','theater'),('cboone@gatech.edu','travel'),('danderson@gatech.edu','gaming'),('danderson@gatech.edu','gardening'),('danderson@gatech.edu','listening to music'),('danderson@gatech.edu','swimming'),('dgeorge@gatech.edu','art'),('dgeorge@gatech.edu','listening to music'),('dgeorge@gatech.edu','skiing'),('dgeorge@gatech.edu','wood working'),('jcortez@gatech.edu','base jumping'),('jcortez@gatech.edu','camping'),('jcortez@gatech.edu','cooking'),('jcortez@gatech.edu','swimming'),('jcross@gatech.edu','football/soccer'),('jcross@gatech.edu','skiing'),('jcross@gatech.edu','theater'),('jcross@gatech.edu','volleyball'),('jmartin@gatech.edu','collecting'),('jmartin@gatech.edu','cooking'),('jmartin@gatech.edu','hiking'),('jmartin@gatech.edu','wood working'),('kblack@gatech.edu','collecting'),('kblack@gatech.edu','gaming'),('kblack@gatech.edu','golf'),('kblack@gatech.edu','playing piano'),('michael@bluthco.com','golf'),('michael@bluthco.com','hunting'),('michael@bluthco.com','playing piano'),('michael@bluthco.com','reading'),('msimpson@gatech.edu','automobiles'),('msimpson@gatech.edu','billiards'),('msimpson@gatech.edu','bird watching'),('msimpson@gatech.edu','movies'),('sbrown@gatech.edu','classical music'),('sbrown@gatech.edu','football/soccer'),('sbrown@gatech.edu','kayaking'),('sbrown@gatech.edu','photography'),('sflowers@gatech.edu','automobiles'),('sflowers@gatech.edu','bird watching'),('sflowers@gatech.edu','gardening'),('sflowers@gatech.edu','riding lightrail'),('slopez@gatech.edu','classical music'),('slopez@gatech.edu','cooking'),('slopez@gatech.edu','photography'),('slopez@gatech.edu','playing piano'),('smeadows@gatech.edu','billiards'),('smeadows@gatech.edu','hunting'),('smeadows@gatech.edu','movies'),('smeadows@gatech.edu','volleyball'),('swiggins@gatech.edu','camping'),('swiggins@gatech.edu','classical music'),('swiggins@gatech.edu','photography'),('swiggins@gatech.edu','travel');
/*!40000 ALTER TABLE "UserInterest" ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-07-02 17:41:13
