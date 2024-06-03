SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';
 
GRANT FILE ON *.* TO 'root'@'localhost';
SET GLOBAL local_infile = 1;
SET GLOBAL sql_mode = '';
 
 
DROP SCHEMA IF EXISTS CASE_JUMP_4;
CREATE SCHEMA CASE_JUMP_4;
USE CASE_JUMP_4;


CREATE TABLE CaseSQL_names (
	imdb_name_id VARCHAR (50)  PRIMARY KEY,
    name VARCHAR (250),
    birth_name VARCHAR(400),
    height VARCHAR(150),
    bio TEXT,
    birth_details TEXT,
    date_of_birth VARCHAR(150),
    place_of_birth VARCHAR(250),
    death_details TEXT,
    date_of_death VARCHAR(100),
    place_of_death VARCHAR(150),
    reason_of_death TEXT,
    spouses_string TEXT,
    spouses INT,
    divorces INT,
    spouses_with_children INT,
    children INT
);
 
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/CASE_SQL/CaseSQL_names.csv"
INTO TABLE CaseSQL_names
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


DROP TABLE IF EXISTS CaseSQL_movies;
CREATE TABLE CaseSQL_movies (
	imdb_title_id VARCHAR(100),
    title VARCHAR(255),
    original_title VARCHAR(255),
    year VARCHAR(100),
    date_published VARCHAR(100),
    genre VARCHAR(255),
    duration FLOAT,
    country VARCHAR(255),
    language VARCHAR(255),
    director VARCHAR(255),
    writer VARCHAR(255),
    production_company VARCHAR(255),
    actors VARCHAR(1000),
    description TEXT,
    avg_vote FLOAT,
    votes FLOAT,
    budget VARCHAR(255),
    usa_gross_income VARCHAR(255),
    worldwide_gross_income VARCHAR(255),
    metascore VARCHAR(255),
    reviews_from_users varchar(255) Null,
    reviews_from_critics varchar(255) Null
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/CASE_SQL/CaseSQL_movies.csv"
INTO TABLE CaseSQL_movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS CaseSQL_title_principals;
CREATE TABLE CaseSQL_title_principals (
		imdb_title_id VARCHAR (100) NOT NULL,
		ordering VARCHAR (100),
		imdb_name_id VARCHAR (100),
		category VARCHAR (100),
		job VARCHAR (50),
		characters text
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/CASE_SQL/CaseSQL_title_principals.csv"
INTO TABLE CaseSQL_title_principals
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS CaseSQL_ratings;
CREATE TABLE CaseSQL_ratings (
   imdb_title_id VARCHAR (10) NOT NULL,
   weighted_average_vote FLOAT,
   total_votes INT,
   mean_vote FLOAT,
   median_vote FLOAT,
   votes_10 INT,
   votes_9 INT,
   votes_8 INT,
   votes_7 INT,
   votes_6 INT,
   votes_5 INT,
   votes_4 INT,
   votes_3 INT,
   votes_2 INT,
   votes_1 INT,
   allgenders_0age_avg_vote FLOAT,
   allgenders_0age_votes FLOAT,
   allgenders_18age_avg_vote FLOAT,
   allgenders_18age_votes INT,
   allgenders_30age_avg_vote FLOAT,
   allgenders_30age_votes INT,
   allgenders_45age_avg_vote FLOAT,
   allgenders_45age_votes INT,
   males_allages_avg_vote FLOAT,
   males_allages_votes INT,
   males_0age_avg_vote FLOAT,
   males_0age_votes INT,
   males_18age_avg_vote FLOAT,
   males_18age_votes INT,
   males_30age_avg_vote FLOAT,
   males_30age_votes INT,
   males_45age_avg_vote FLOAT,
   males_45age_votes INT,
   females_allages_avg_vote FLOAT,
   females_allages_votes INT,
   females_0age_avg_vote decimal,
   females_0age_votes decimal,
   females_18age_avg_vote FLOAT,
   females_18age_votes INT,
   females_30age_avg_vote FLOAT,
   females_30age_votes INT,
   females_45age_avg_vote FLOAT,
   females_45age_votes INT,
   top1000_voters_rating FLOAT,
   top1000_voters_votes INT,
   us_voters_rating FLOAT,
   us_voters_votes INT,
   non_us_voters_rating FLOAT,
   non_us_voters_votes INT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/CASE_SQL/CaseSQL_ratings.csv"
INTO TABLE CaseSQL_ratings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 


select * from casesql_movies limit 5;
select * from casesql_names limit 5;
select * from casesql_ratings limit 5;
select * from casesql_title_principals limit 5;




