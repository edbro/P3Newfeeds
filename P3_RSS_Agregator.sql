/*
  P3_RSS_Agregator.sql - First Version RSS Agregator
     
   Author:  Grace, George Wong, Ed Brovick
  
  Here are a few notes on things below that may not be self evident:
  
  INDEXES: You'll see indexes below for example:
  
  INDEX SurveyID_index(SurveyID)
  
  Any field that has highly unique data that is either searched on or used as a join should be indexed, which speeds up a  
  search on a tall table, but potentially slows down an add or delete
  
  TIMESTAMP: MySQL currently only supports one date field per table to be automatically updated with the current time.  We'll use a 
  field in a few of the tables named LastUpdated:
  
  LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP
  
  The other date oriented field we are interested in, DateAdded we'll do by hand on insert with the MySQL function NOW().
  
  CASCADES: In order to avoid orphaned records in deletion of a Survey, we'll want to get rid of the associated Q & A, etc. 
  We therefore want a 'cascading delete' in which the deletion of a Survey activates a 'cascade' of deletions in an 
  associated table.  Here's what the syntax looks like:  
  
  FOREIGN KEY (SurveyID) REFERENCES wn16_surveys(SurveyID) ON DELETE CASCADE
  
  The above is from the Questions table, which stores a foreign key, SurveyID in it.  This line of code tags the foreign key to 
  identify which associated records to delete.
  
  Be sure to check your cascades by deleting a survey and watch all the related table data disappear!
  
  
*/


SET foreign_key_checks = 0; #turn off constraints temporarily

#since constraints cause problems, drop tables first, working backward
DROP TABLE IF EXISTS wn16_P3_User;
DROP TABLE IF EXISTS wn16_P3_Categories;
DROP TABLE IF EXISTS wn16_P3_subCategories;
DROP TABLE IF EXISTS wn16_P3_Articles;
DROP TABLE IF EXISTS wn16_P3_Source;

  
#all tables must be of type InnoDB to do transactions, foreign key constraints
# The User Table is all all users and adminstators
CREATE TABLE wn16_P3_User(
    UserID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Username VARCHAR(16) Default '', 
    Role VARCHAR(32) Default '',
    Fname VARCHAR(32) Default '', 
    Lname VARCHAR(32) Default '', 
    Email VARCHAR(60) Default '',
    Datejoined DATETIME,
    LastUpdated TIMESTAMP DEFAULT 0 on Update CURRENT_TIMESTAMP,
    pwd VARCHAR (16),
    PRIMARY KEY (UserID)
    )ENGINE=INNODB;
    

#assigning first survey to AdminID == 1
#INSERT INTO wn16_surveys VALUES (NULL,1,'Our First Survey','Description of Survey',NOW(),NOW()); 

#foreign key field must match size and type, hence SurveyID is INT UNSIGNED
CREATE TABLE wn16_P3_Categories(
    CategoryID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Categoryname VARCHAR(64) Default '',
    PRIMARY KEY (CategoryID)
)ENGINE=INNODB;

INSERT INTO wn16_P3_Categories (Categoryname) VALUES ('Computer');
INSERT INTO wn16_P3_Categories (Categoryname) VALUES ('Mobile Device');
INSERT INTO wn16_P3_Categories (Categoryname) VALUES ('Game');


#INSERT INTO wn16_questions VALUES (NULL,1,'Do You Like Cookies?','We like cookies!',NOW(),NOW());
#INSERT INTO wn16_questions VALUES (NULL,1,'Favorite Toppings?','We like chocolate!',NOW(),NOW());

CREATE TABLE wn16_P3_subCategories(
    subCategoryID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CategoryID INT UNSIGNED DEFAULT 0,
    subCategoryName TEXT DEFAULT '',
    PRIMARY KEY (subCategoryID),
    FOREIGN KEY (CategoryID) REFERENCES wn16_P3_Categories(CategoryID) ON DELETE CASCADE
    )ENGINE=INNODB;
    
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (1, 'Software');
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (1, 'Hardware');
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (1, 'Accessories');
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (2, 'Reviews');
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (2, 'Upcoming/Release');
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (2, 'Competition/Events');
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (3, 'Cellphone');
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (3, 'Laptops');
INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (3, 'Tablets');
#INSERT INTO wn16_P3_subCategories (CategoryID, subCategoryName) VALUES (1, 'XX');


    

CREATE TABLE wn16_P3_Articles(
    ArticleID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    #subCategoryID REFERENCES wn16_P3_subCategories(subCategoryID),
    subCategoryID INT UNSIGNED,
    SourceID INT UNSIGNED,
    Title VARCHAR(64) Default '',
    Content VARCHAR(256) Default '',
    Description VARCHAR(512) Default '',
    Time_Stamp TIMESTAMP DEFAULT 0 on Update CURRENT_TIMESTAMP,
    PRIMARY KEY (ArticleID),
    FOREIGN KEY (subCategoryID) REFERENCES wn16_P3_subCategories(subCategoryID) ON DELETE CASCADE,
    FOREIGN KEY (SourceID) REFERENCES win16_P3_Source(SourceID) ON DELETE CASCADE
    )ENGINE=INNODB;
    
CREATE TABLE wn16_P3_Source(
    SourceID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    subCategoryID INT UNSIGNED,
    Sitename VARCHAR(128) Default '',
    URL VARCHAR(256),
    PRIMARY KEY (SourceID),
    FOREIGN KEY (subCategoryID) REFERENCES wn16_P3_subCategories(subCategoryID) ON DELETE CASCADE
    ) ENGINE=INNODB;

INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (1,"engadget.com","http://www.engadget.com/rss.xml");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (1,"computerweekly.com","http://www.computerweekly.com/rss/Enterprise-software.xml");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (1,"techradar.com","http://www.techradar.com/rss/news/software");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (1,"techradar.com","http://www.techradar.com/rss/reviews/pc-mac");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (1,"techradar.com","http://feeds2.feedburner.com/techradar/software-news");


INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (2,"computerweekly.com","http://www.computerweekly.com/rss/IT-hardware.xml");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (2,"techradar.com","http://www.techradar.com/rss/reviews/pc-mac");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (2,"techradar.com","http://feeds2.feedburner.com/techradar/computing-components-news");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (2,"techrepublic.com","http://techrepublic.com.feedsportal.com");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (2,"techrepublic.com","http://techrepublic.com.feedsportal.com/c/35463/f/670887/index.rss");



INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (3,"techradar.com","http://www.techradar.com/rss/reviews/pc-mac");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (3,"techradar.com","http://www.techradar.com/rss/reviews/gadgets");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (3,"techradar.com","http://feeds.webservice.techradar.com/rss/reviews/gadgets");

INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"techcrunch.com","http://feeds.feedburner.com/TechCrunch/gaming");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"techradar.com","http://www.techradar.com/rss/news/gaming");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"techradar.com","http://feeds2.feedburner.com/techradar/gaming-news");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"techradar.com","http://feeds2.feedburner.com/techradar/gaming-reviews");

INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"nbcnews.com","http://feeds.nbcnews.com/feeds/topstories");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,".bit-tech.net","http://feeds2.feedburner.com/bit-tech/gaming");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"dailygame.net","http://www.dailygame.net/rss.xml");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"gamegossip.com","http://www.gamegossip.com/syndication/headlines.xml");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"slashdot.org","http://games.slashdot.org/games.rss");

INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"gamespot.com","http://www.gamespot.com/misc/rss/gam...dates_news.xml");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (4,"gamemarketwatch.com","http://www.gamemarketwatch.com/gmw.xml");



INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (5,"techradar.com","http://feeds2.feedburner.com/techradar/gaming-reviews");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (5,"techradar.com","http://feeds2.feedburner.com/techradar/gaming-news");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (5,"gadgets.ndtv.com","http://gadgets.ndtv.com/rss/games/features");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (5,"gadgets.ndtv.com","http://gadgets.ndtv.com/rss/games/news");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (5,"geek.com","http://www.geek.com/category/games/");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (5,"velocityvctor.com","http://www.velocityvector.com/newvideogames.rss");



INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (6,"techradar.com","http://www.techradar.com/rss/news/world-of-tech");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (6,"nbcnews.com","http://feeds.nbcnews.com/feeds/topstories");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (6,"nintendo.com","https://www.nintendo.com/feed");

INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (7,"mobilecrunch.com","http://www.infoworld.com/category/mobile-technology/index.rss");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (7,"infoworld.com","http://www.infoworld.com/blog/mobile-edge/index.rss");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (7,"infoworld.com","http://www.computerweekly.com/rss/Mobile-technology.xml");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (7,"techradar.com","http://www.techradar.com/rss/news/phone-and-communications");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (7,"techradar.com","http://feeds2.feedburner.com/techradar/phone-and-communications-news");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (7,"techradar.com","http://feeds2.feedburner.com/techradar/phone-reviews");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (7,"techradar.com","http://www.techradar.com/rss/reviews/phones");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (7,"digitaltrends.com","feed://www.digitaltrends.com/mobile/feed/");

INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"techradar.com","http://www.techradar.com/rss/news/mobile-computing");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"techradar.com","http://www.techradar.com/rss/news/portable-devices");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"techradar.com","http://www.techradar.com/rss/reviews/pc-mac");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"techradar.com","http://feeds2.feedburner.com/techradar/mobile-computing-news");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"techradar.com","http://feeds2.feedburner.com/techradar/portable-devices-news");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"pcadvisor.co.uk","http://www.pcadvisor.co.uk/latest/rss");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"notebookcheck.net","http://www.notebookcheck.net/News.152.100.html");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"pcworld.com","http://www.pcworld.com/category/laptop-computers/index.rss");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (8,"laptopmag.com","http://feeds.feedburner.com/laptopmag");

INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (9,"techradar.com","http://www.techradar.com/rss/news/portable-devices");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (9,"techradar.com","http://www.techradar.com/rss/reviews/pc-mac");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (9,"techradar.com","http://feeds2.feedburner.com/techradar/portable-devices-news");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (9,"nbcnews.com","http://feeds.nbcnews.com/feeds/topstories");
INSERT INTo wn16_P3_Source (subCategoryID,Sitename, URL) VALUES (9,"pcworld.com","http://www.pcworld.com/category/tablets/index.rss");


select * from wn16_P3_Categories join wn16_P3_subCategories on wn16_P3_Categories.CategoryID = wn16_P3_subCategories.CategoryID;



#SET foreign_key_checks = 1; #turn foreign key check back on