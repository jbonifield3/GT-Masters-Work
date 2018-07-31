-- CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
-- CREATE USER IF NOT EXISTS gtuser@localhost IDENTIFIED BY 'gtuser_password';

-- set sql_mode=ORACLE; /*MariaDB fake PL/SQL > PSQL/PSM*/

SET default_storage_engine=InnoDB;
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- James: We need to set this because otherwise MariaDB gets confused
-- when we drop the database, and will error with foreign key errors 
-- (CASCADE has no meaning in MariaDB)

SET FOREIGN_KEY_CHECKS=0;

CREATE DATABASE cs6400_su18_team04 
    DEFAULT CHARACTER SET utf8mb4 
    -- DEFAULT COLLATE utf8mb4_unicode_ci
     ;
USE cs6400_su18_team04;

SET FOREIGN_KEY_CHECKS=1;

GRANT SELECT, INSERT, UPDATE, DELETE, FILE ON *.* TO 'gtuser'@'localhost';
GRANT ALL PRIVILEGES ON `gtuser`.* TO 'gtuser'@'localhost';
GRANT ALL PRIVILEGES ON `cs6400_su18_team04`.* TO 'gtuser'@'localhost';
FLUSH PRIVILEGES;

-- Tables 

CREATE TABLE `User` (
  user_id int(15) unsigned NOT NULL AUTO_INCREMENT,
  username varchar(35) NOT NULL,
  password varchar(35) NOT NULL,
  name varchar(255) NOT NULL,
  PRIMARY KEY (user_id),
  UNIQUE KEY username (username)
);

CREATE TABLE `MunicipalityType` (
  municipality_type_id int(15) unsigned NOT NULL AUTO_INCREMENT,
  municipality_type varchar(255) NOT NULL,
  PRIMARY KEY (municipality_type_id)
);

insert into `MunicipalityType` (municipality_type) values ('City'); -- City is 1
insert into `MunicipalityType` (municipality_type) values ('County'); -- County is 2
insert into `MunicipalityType` (municipality_type) values ('State'); -- State is 3
insert into `MunicipalityType` (municipality_type) values ('Country'); -- Country is 4

CREATE TABLE `Municipality` (
   municipality_id int(15) unsigned NOT NULL AUTO_INCREMENT,
   user_id int unsigned NOT NULL, -- FK -- James: like this instead
   municipality_type_id int(15) unsigned NOT NULL,
   PRIMARY KEY (municipality_id),
   FOREIGN KEY (user_id) REFERENCES `User` (user_id),
   FOREIGN KEY (municipality_type_id) REFERENCES `MunicipalityType` (municipality_type_id)
);

CREATE TABLE `IndividualUser` (
   individual_user_id int(15) unsigned NOT NULL AUTO_INCREMENT,
   user_id int(15) unsigned NOT NULL, -- FK -- James: like this instead
   job_title varchar(250) NOT NULL, 
   date_hired date NOT NULL, 
   PRIMARY KEY (individual_user_id),
   FOREIGN KEY (user_id) REFERENCES `User` (user_id)
);

CREATE TABLE `GovernmentAgency` (
   government_agency_id int(15) unsigned NOT NULL AUTO_INCREMENT,
  user_id int unsigned NOT NULL, -- FK -- James: like this instead
   local_office varchar(255) NOT NULL, 
   agency_name varchar(255) NOT NULL, 
   PRIMARY KEY (government_agency_id),
   FOREIGN KEY (user_id) REFERENCES `User` (user_id)
);

CREATE TABLE `Company` (
  company_id int(15) unsigned NOT NULL AUTO_INCREMENT,
  user_id int(15) unsigned NOT NULL, -- FK -- James: like this instead  
  headquarters varchar(255) NOT NULL, 
  no_of_employee int(16) NOT NULL, 
  PRIMARY KEY (company_id),
  FOREIGN KEY (user_id) REFERENCES `User` (user_id)
);

CREATE TABLE `UnitQuantity` (
  unit_quantity_id int(15) unsigned NOT NULL AUTO_INCREMENT,
   unit varchar(35) NOT NULL,
   PRIMARY KEY (unit_quantity_id)
);

CREATE TABLE `ESF` (
  esf_id int(16) unsigned NOT NULL,
  description varchar(255) DEFAULT NULL,
  PRIMARY KEY (esf_id)
  );


CREATE TABLE `ResourceStatus` (
   resource_status_id int(15) unsigned NOT NULL AUTO_INCREMENT,
   resource_status varchar(255) NOT NULL, -- James: Added Not Null
  PRIMARY KEY (resource_status_id)
);  

insert into `ResourceStatus` (resource_status) values('Available');
insert into `ResourceStatus` (resource_status) values('In Use');

CREATE TABLE Resource (
   resource_id int(15) unsigned NOT NULL AUTO_INCREMENT,
   user_id int(15) unsigned NOT NULL, -- FK
   resource_status_id int(15) unsigned Default 1 NOT NULL, -- FK
   resource_name varchar(50) NOT NULL,
   primary_esf_id int(15) unsigned NOT NULL, -- FK
   latitude decimal(10,8) signed NOT NULL,
   longitude decimal(11,8) signed NOT NULL,
   max_distance int(5) DEFAULT NULL,
   cost_amount int(16) NOT NULL,
   unit_quantity_id int(16) unsigned NOT NULL, -- FK
   model varchar(20) DEFAULT NULL,
   PRIMARY KEY (resource_id),
   FOREIGN KEY (user_id) REFERENCES `User` (user_id),
   FOREIGN KEY (primary_esf_id) REFERENCES `ESF` (esf_id),
   FOREIGN KEY (unit_quantity_id) REFERENCES `UnitQuantity` (unit_quantity_id),
   FOREIGN KEY (resource_status_id) REFERENCES `ResourceStatus` (resource_status_id)
);

CREATE TABLE `AdditionalESF` (
   resource_id int(15) unsigned NOT NULL, -- FK
   esf_id int(15) unsigned NOT NULL, -- FK
   PRIMARY KEY (resource_id, esf_id),
   FOREIGN KEY (resource_id) REFERENCES `Resource` (resource_id),
   FOREIGN KEY (esf_id) REFERENCES `ESF` (esf_id)
);

CREATE TABLE `Capability` (
   capability_id int(16) unsigned NOT NULL AUTO_INCREMENT,
   resource_id int(16) unsigned NOT NULL, -- FK
   capabilities varchar(150) NOT NULL,
   PRIMARY KEY (capability_id),
   FOREIGN KEY (resource_id) REFERENCES `Resource` (resource_id),
   UNIQUE KEY (resource_id,capabilities)
);

CREATE TABLE `Declaration` (
   declaration_id int(15) unsigned NOT NULL AUTO_INCREMENT,
   abbreviation varchar(2) NOT NULL,
   description varchar(255) NOT NULL,  
   total_count int(15) unsigned Default '0' NOT NULL,
  PRIMARY KEY (declaration_id)
);

CREATE TABLE `Incident` (
  incident_id int(15) unsigned not null AUTO_INCREMENT,
  declaration_id int(15) unsigned not null, -- FK
  user_id int(15) unsigned NOT NULL, -- FK
  latitude decimal(10,8) signed NOT NULL,
  longitude decimal(11,8) signed NOT NULL,
  description varchar(500) NOT NULL,
  incident_date Timestamp Default CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (incident_id), 
  FOREIGN KEY (declaration_id) REFERENCES `Declaration` (declaration_id),
  FOREIGN KEY (user_id) REFERENCES `User` (user_id)
);
CREATE TABLE `Request` (
  incident_id int(15) unsigned NOT NULL,
  resource_id int(15) unsigned NOT NULL,
  deployment_date datetime DEFAULT NULL,
  user_id int(15) unsigned NOT NULL, -- FK
  return_by date NOT NULL,
  PRIMARY KEY (incident_id,resource_id),
  FOREIGN KEY (incident_id) REFERENCES `Incident` (incident_id),
  FOREIGN KEY (resource_id) REFERENCES `Resource` (resource_id),
  FOREIGN KEY (user_id) REFERENCES `User` (user_id)
);

CREATE TABLE `Incident_Count` (
   incident_id int(16) unsigned NOT NULL , -- FK
   count int(16) unsigned NOT NULL,
   PRIMARY KEY (incident_id),
   FOREIGN KEY (incident_id) REFERENCES `Incident` (incident_id)
);

delimiter //
CREATE TRIGGER Declaration_Count AFTER INSERT ON Incident FOR EACH ROW
Begin
        UPDATE Declaration d SET d.total_count = d.total_count + 1
        where d.declaration_id = NEW.declaration_id;
        
        Insert into Incident_Count 
        select NEW.incident_id,max(d.total_count)
        from Declaration d where d.declaration_id = NEW.declaration_id;
end; //
delimiter ;


-- Create Haversine Function

drop function if exists Haversine;

DELIMITER //

create function Haversine (
  lat_1 FLOAT,
  long_1 FLOAT,
  lat_2 FLOAT,
  long_2 FLOAT)
RETURNS float
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE a FLOAT;
  DECLARE c FLOAT;
  DECLARE r INT;
  set r = 6371;
  
  set a = power(sin(radians(lat_2-lat_1)/2),2) + cos(radians(lat_1))*cos(radians(lat_2))*power(sin((radians(long_2-long_1))/2),2);
  set c = 2*atan2(sqrt(a),sqrt(1-a));

  RETURN r*c;
END //
DELIMITER ;

-- Test Haversine
-- select Haversine(51.5033640,-1276250,33.9020420,-84.4563590) from dual;

-- Populate DB with samples

insert into `User` (username, password, name) values ('lmosdell0', 'uT4U9cc', 'Lorna Mosdell');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(), '8312 Clarendon Plaza', 'Flashset');

insert into `User` (username, password, name) values ('alascell1', 'adzpQ0HC', 'Alberta Lascell');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(),'18 Steensland Point', 'Flashpoint');

insert into `User` (username, password, name) values ('nparriss2', 'tzFRtuJ', 'Nigel Parriss');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(),'2 Pierstorff Park', 'Katz');

insert into `User` (username, password, name) values ('tamorine3', 'FzCA1Tk1oS', 'Tristam Amorine');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(),'86308 Esker Lane', 'Kaymbo');

insert into `User` (username, password, name) values ('bround4', 'nTU3dYE', 'Bel Round');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(), '65 Forest Dale Alley', 'Thoughtmix');

insert into `User` (username, password, name) values ('jreap5', 'i8vmqxhTv', 'Julieta Reap');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(),'9 Stone Corner Alley', 'Lazz');

insert into `User` (username, password, name) values ('codoghesty6', 'QVoA9c', 'Charita O''Doghesty');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(),'2356 Independence Lane', 'Blognation');

insert into `User` (username, password, name) values ('etipton7', 'bvFNd91sRH', 'Essa Tipton');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(),'9438 Milwaukee Plaza', 'Feednation');

insert into `User` (username, password, name) values ('nfollan8', 'T9E5fUB9gL', 'Norean Follan');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(), '26 Superior Pass', 'Realfire');

insert into `User` (username, password, name) values ('cebbing9', 'COpot3c6wxx', 'Caressa Ebbing');
insert into `GovernmentAgency` (user_id, local_office, agency_name) values (LAST_INSERT_ID(), '5779 Farwell Trail', 'Cogidoo');

insert into `User` (username, password, name) values ('qtrevenua', 'QnDttden', 'Quincey Trevenu');
insert into `IndividualUser` (user_id, job_title, date_hired) 
values (LAST_INSERT_ID(), 'Regional Manager', str_to_date('01-01-2010','%c-%d-%Y'));

insert into `User` (username, password, name) values ('lkelwickb', '6WYl0M', 'Lonee Kelwick');
insert into `IndividualUser` (user_id, job_title, date_hired) 
values (LAST_INSERT_ID(), 'Assistant to the Regional Manager', str_to_date('01-01-2011','%c-%d-%Y'));

insert into `User` (username, password, name) values ('jbonifield', 'jimbo', 'James Bonifield');
insert into `IndividualUser` (user_id, job_title, date_hired) 
values (LAST_INSERT_ID(), 'Assistant to the Regional Manager', str_to_date('01-01-2012','%c-%d-%Y'));

insert into `User` (username, password, name) values ('jwolseleyd', 's4YZHW', 'Jessamyn Wolseley');
insert into `IndividualUser` (user_id, job_title, date_hired) 
values (LAST_INSERT_ID(), 'First Responder', str_to_date('01-01-2013','%c-%d-%Y'));

insert into `User` (username, password, name) values ('dondiego', 'godiegogo', 'Diego Carvallo');
insert into `IndividualUser` (user_id, job_title, date_hired) 
values (LAST_INSERT_ID(), 'Nuclear Physicist', str_to_date('09-12-2014','%c-%d-%Y'));

insert into `User` (username, password, name) values ('lsowreye', '1yCXhe', 'Lee Sowrey');
insert into `IndividualUser` (user_id, job_title, date_hired) 
values (LAST_INSERT_ID(), 'First Responder', str_to_date('01-01-2015','%c-%d-%Y'));

insert into `User` (username, password, name) values ('ncometsonf', 'xwIpxL5sp1', 'Nick Cometson');
insert into `IndividualUser` (user_id, job_title, date_hired) 
values (LAST_INSERT_ID(), 'First Responder', str_to_date('01-01-2016','%c-%d-%Y'));

insert into `User` (username, password, name) values ('FEMA', 'BcmIbzLJdor', 'Federal Emergency Managment Agency');
insert into `GovernmentAgency` (user_id, agency_name, local_office) 
values (LAST_INSERT_ID(), 'FEMA', '‎266 Ferst Dr Atlanta, GA 30332');

insert into `User` (username, password, name) values ('GBI', 'fBt67SeL0B', 'Georgia Bureau of Investigation');
insert into `GovernmentAgency` (user_id, agency_name, local_office) 
values (LAST_INSERT_ID(), 'GBI', '825 Techwood Drive NW Atlanta GA 30326');

insert into `User` (username, password, name) values ('FBI', '9IvH8zHTToYv', 'Federal Bureau of Investigation');
insert into `GovernmentAgency` (user_id, agency_name, local_office) 
values (LAST_INSERT_ID(), 'FBI', '825 Techwood Drive NW Atlanta GA 30326');



insert into `User` (username, password, name) values ('tguicej', 'O8eSvM2rT32V', 'Thorsten Guice');
insert into `User` (username, password, name) values ('aheadingk', 'aNV1KBbHDK', 'Ara Heading');
insert into `User` (username, password, name) values ('iquickl', 'jfGq0nuwPU7k', 'Iolanthe Quick');
insert into `User` (username, password, name) values ('odowzellm', 'rDBxT4LJuA1', 'Obadias Dowzell');
insert into `User` (username, password, name) values ('aspradbrown', 'zYtM9aI26YY', 'Arlette Spradbrow');
insert into `User` (username, password, name) values ('sfreckeltono', 'O8FckitNmiHG', 'Sal Freckelton');
insert into `User` (username, password, name) values ('cpavisp', 'xQpBYed0E6U', 'Christiana Pavis');
insert into `User` (username, password, name) values ('gatechx8', 'gatechx8', 'gatechx8 name');



insert into `User` (username, password, name) values ('ewysomer', 'S4b3eZdSV', 'Edie Wysome');
insert into `User` (username, password, name) values ('fbutfields', 'dPoHmrj', 'Florence Butfield');
insert into `User` (username, password, name) values ('gclewartht', 'rpFIZB', 'Giorgi Clewarth');
insert into `User` (username, password, name) values ('pgipsonu', 'pSoUnB', 'Pierson Gipson');
insert into `User` (username, password, name) values ('hensorv', 'HGPECTn', 'Harald Ensor');
insert into `User` (username, password, name) values ('tolliarw', 'hqLuUXFwClf', 'Thain Olliar');
insert into `User` (username, password, name) values ('mruncimanx', 'wFQeMddS', 'Marcile Runciman');
insert into `User` (username, password, name) values ('dboughtony', '6Opxu15u', 'Demetris Boughton');
insert into `User` (username, password, name) values ('sfarryanz', 'FxrN8tZg93', 'Sibyl Farryan');
insert into `User` (username, password, name) values ('jcosgrove10', 'ZBfQkm', 'Janaye Cosgrove');
insert into `User` (username, password, name) values ('mstocks11', 'r5Z6JVDn', 'Margit Stocks');
insert into `User` (username, password, name) values ('rbramo12', 'bz2WBFc93q', 'Ritchie Bramo');
insert into `User` (username, password, name) values ('estrippel13', 'EKKsye9t2AS', 'Edgar Strippel');
insert into `User` (username, password, name) values ('gcasillas14', 'SkjFxNBbJo5', 'Gratiana Casillas');
insert into `User` (username, password, name) values ('skittredge15', 'cKOtFk', 'Sonny Kittredge');
insert into `User` (username, password, name) values ('dbrahms16', 'DR3HbiOhX', 'Doloritas Brahms');
insert into `User` (username, password, name) values ('gwebley17', 'TZ8V5T', 'Gerhard Webley');
insert into `User` (username, password, name) values ('gmatokhnin18', '15q4K8N1aV', 'Gerick Matokhnin');
insert into `User` (username, password, name) values ('psalliss19', '1SwW01kjR', 'Peri Salliss');
insert into `User` (username, password, name) values ('kbraine1a', 'RKLob9mwbkF3', 'Kendrick Braine');
insert into `User` (username, password, name) values ('msussex1b', 'VHSYHOAxeE', 'Maxi Sussex');
insert into `User` (username, password, name) values ('agoodband1c', 'SSoPCanLot2', 'Alaster Goodband');
insert into `User` (username, password, name) values ('Google', 'knowsall', 'Google Inc');
INSERT INTO `Company` (`user_id`, `headquarters`, `no_of_employee`) VALUES (LAST_INSERT_ID(), 'Pasadena CA', '3751');

-- ESFs 
insert into `ESF` (esf_id, description) values (1, 'Transportation');
insert into `ESF` (esf_id, description) values (2, 'Communications');
insert into `ESF` (esf_id, description) values (3, 'Public Works and Engineering');
insert into `ESF` (esf_id, description) values (4, 'Firefighting');
insert into `ESF` (esf_id, description) values (5, 'Emergency Management');
insert into `ESF` (esf_id, description) values (6, 'Mass Care, Emergency Assistance, Housing, and Human Services');
insert into `ESF` (esf_id, description) values (7, 'Logistics Management and Resource Support');
insert into `ESF` (esf_id, description) values (8, 'Public Health and Medical Services');
insert into `ESF` (esf_id, description) values (9, 'Search and Rescue');
insert into `ESF` (esf_id, description) values (10, 'Oil and Hazardous Materials Response');
insert into `ESF` (esf_id, description) values (11, 'Agriculture and Natural Resources');
insert into `ESF` (esf_id, description) values (12, 'Energy');
insert into `ESF` (esf_id, description) values (13, 'Public Safety and Security');
insert into `ESF` (esf_id, description) values (14, 'Long-Term Community Recovery');
insert into `ESF` (esf_id, description) values (15, 'External Affairs');

-- Declarations 
insert into `Declaration` (abbreviation, description) values ('MD', 'Major Disaster Declaration');
insert into `Declaration` (abbreviation, description) values ('ED', 'Emergency Declaration');
insert into `Declaration` (abbreviation, description) values ('FM', 'Fire Management Assistance');
insert into `Declaration` (abbreviation, description) values ('FS', 'Fire Suppression Authorization');

-- UnitQuantity
insert into `UnitQuantity` (unit) values ('hour');
insert into `UnitQuantity` (unit) values ('day');
insert into `UnitQuantity` (unit) values ('week');

-- 
insert into `User` (username, password, name) values ('cityoflight', 'cityoflight', 'New York #51');
insert into `Municipality` (user_id, municipality_type_id) values (LAST_INSERT_ID(),3);
insert into `Resource` (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (51,"51R1",9,70,20,50,100,3);
insert into Resource (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (51,"51R2",9,30,50,120,140,2);
insert into Resource (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (51,"51R3",9,30,50,120,140,2);
insert into Resource (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (51,"51R4",9,30,50,120,140,2);
insert into Resource (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (51,"51R5",4,70,20,50,100,3);
insert into Resource (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (51,"51R6",4,70,20,50,100,3);
insert into Resource (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (51,"51R7",4,70,20,50,100,3);

insert into `User` (username, password, name) values ('countyofpuppy', '6WYl0M', 'Puppy County');
insert into `Municipality` (user_id, municipality_type_id) values (LAST_INSERT_ID(),2);
insert into `Resource` (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (52,'Helicopter',9,39,75,50,300,3);

insert into `User` (username, password, name) values ('stateoftrance', 's1BwN6', 'State of Trance');
insert into `Municipality` (user_id, municipality_type_id) values (LAST_INSERT_ID(),1);
insert into `Resource` (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (53,'Long bus',1,75,39,30,200,1);

insert into `User` (username, password, name) values ('countryoffreedom', 's4YZHW', 'Freedom Country');
insert into `Municipality` (user_id, municipality_type_id) values (LAST_INSERT_ID(),4);
insert into `Resource` (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
  values (54,'Unlimited Solar Energy',12,70,20,80,100,2);


insert into `Resource` (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
values (27,'27R0',3,70,20,50,100,3);
insert into `Resource` (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
values (27,'27R1',4,70,20,50,100,3);
insert into `Resource` (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
values (27,'27R2',4,70,20,50,100,3);
insert into `Resource` (user_id,resource_name,primary_esf_id,latitude,longitude,max_distance,cost_amount,unit_quantity_id) 
values (27,'27R3',4,70,20,50,100,3);


-- Incident
insert into `Incident` (declaration_id, user_id, latitude, longitude, description)
select 1, u.user_id, ( RAND() * (90-(-90))) +(-90) , ( RAND() * (180-(-180))) +(-180), CONCAT('inc submitted by user: ',u.user_id,' ', u.name)
from `User` u;

-- insert into `Incident` (incident_id, declaration_id, user_id, latitude, longitude, description) VALUES (55, 1, 51, 15 , 20, 'inc 55 (manual insert) submitted by user 51');
-- insert into `Incident` (incident_id, declaration_id, user_id, latitude, longitude, description) VALUES (56, 1, 51, 15 , 20, 'inc 56 (manual insert) submitted by user 51');

-- Request user_id ==> This incident is requested by this user_id ==> incident_id is the same with user_id because of the way how we create Incident table.

INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) 
SELECT  i.incident_id, i.user_id, FLOOR(RAND()*(SELECT MAX(r.resource_id) FROM Resource r)+1),DATE_ADD(CURRENT_DATE(), INTERVAL 10 DAY)
FROM Incident i;


-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (2, 2 , 3, DATE_ADD(CURRENT_DATE(), INTERVAL 20 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (3, 3 , 2 , DATE_ADD(CURRENT_DATE(), INTERVAL 30 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (4, 4 , 1, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (27, 27 , 1, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- -- DEPLOY ACTION FROM USER 51 TO REQUEST FROM USER 27
-- -- UPDATE `Resource` Set resource_status_id = 2 WHERE resource_id = 1 and user_id = 51; 
-- -- UPDATE `Request` SET deployment_date = CURRENT_DATE() WHERE resource_id = 1 and incident_id = 27;
-- -- 

-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (27, 27 , 7, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (27, 27 , 9, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (27, 27 , 3, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));

-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (51, 51 , 8, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (51, 51 , 9, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (51, 51 , 12, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));

-- DEPLOY ACTION FROM USER 27 TO REQUEST FROM USER 51
-- UPDATE Resource Set resource_status_id = 2 WHERE resource_id = 12 and user_id = 27; 
-- UPDATE Request SET deployment_date = CURRENT_DATE() WHERE resource_id = 12 and incident_id = 51;
-- 



-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (55, 51 , 12, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (56, 51 , 14, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (55, 51 , 13, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (56, 51 , 13, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));

-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (3, 3 , 14, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (8, 8 , 13, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));

-- !!! GOTTA CHECK TO RESTRAINT THIS KIND OF REQUEST. request their own resource. (NEED TO DO THIS ON THE SEARCH RESULT SCREEN)
-- INSERT INTO `Request`  (incident_id, user_id, resource_id, return_by) Values (51, 51 , 3, DATE_ADD(CURRENT_DATE(), INTERVAL 40 DAY));
-- !!!


commit;
