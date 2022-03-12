SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Database: `webtoon`
--
DROP DATABASE IF EXISTS webtoon;
CREATE DATABASE IF NOT EXISTS `webtoon` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `webtoon`;

create table `account`(
	account_id			int				unique not null,
    account_name		varchar(15)		not null,
	account_dob			date			not null,
    age					int				not null,
    account_gender		varchar(1)		not null,
    account_nationality	varchar(15)		not null,
    account_email		varchar(40)		not null,
    PRIMARY KEY (account_id),
    CONSTRAINT chk_account_gender CHECK (account_gender = "M" or account_gender = "F")
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `device`(
	device_id			int				unique not null,
    device_name			varchar(15) 	not null,
    device_address		varchar(15)		not null,
    device_type			varchar(15)		not null,
	device_login_date	date			not null,
    account_id			int				not null,
    PRIMARY KEY (device_id),
    CONSTRAINT FK_account_device FOREIGN KEY (account_id) REFERENCES `account`(account_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `payment`(
	transaction_no			int				unique not null,
    transaction_date		date			not null,
    transaction_detail		varchar(20)	not null,
    transaction_coin		int				not null,
    transaction_status		char(1)			not null,
    transaction_moneyamount	decimal(9, 2)	not null,
    account_id				int				not null,
    PRIMARY KEY (transaction_no),
    CONSTRAINT FK_account_payment FOREIGN KEY (account_id) REFERENCES `account`(account_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `comic`(
	comic_id				int				unique not null,
    comic_name				varchar(15)		not null,
    comic_description		varchar(400)	not null,
    comic_author			varchar(15)		not null,
    comic_rating			decimal(4,2)	not null,
    comic_follower			int				not null,
    first_date_publish		date			not null,
    comic_genre				varchar(15)		not null,
    PRIMARY KEY (comic_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `episode`(
	episode_id			int				unique not null,
	cmc_id				int				not null,
    episode_date		date			not null,
    episode_title		varchar(100)	not null,
    free_release_date	date			not null,
    day_of_free_release	int				not null,
    free_view_flag		char(1)			not null,
    PRIMARY KEY (episode_id),
    CONSTRAINT FK_comic_episode FOREIGN KEY (cmc_id) REFERENCES `comic`(comic_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `comment`(
	comment_id		int				unique not null,
    comment_text	varchar(100)	not null,
    comment_date	date			not null,
    deleted_date	date,
    updated_date	date,
    episode_id		int				not null,
    account_id		int				not null,
    PRIMARY KEY (comment_id),
    CONSTRAINT FK_episode_comments FOREIGN KEY (episode_id) REFERENCES `episode`(episode_id),
    CONSTRAINT FK_account_comment FOREIGN KEY (account_id) REFERENCES `account`(account_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `character`(
	character_id		int				unique not null,
    cmc_id				int				not null,
    character_fname		varchar(15)		not null,
    character_lname		varchar(15)		,
    character_role		varchar(30)		not null,
    character_age		int				not null,
    character_gender	varchar(1)		not null,
    character_nation	varchar(15)		not null,
    character_habit		varchar(30)		,
    PRIMARY KEY (character_id),
    CONSTRAINT FK_comic_character FOREIGN KEY (cmc_id) REFERENCES `comic`(comic_id),
    CONSTRAINT chk_gender_character CHECK (character_gender = "M" or character_gender = "F")
    
);create table `reply`(
	cmt_id				int,
    reply_id			int				unique not null,
    reply_text			varchar(300)	not null,
    reply_date			date			not null,
    deleted_date		date,
    updated_date		date,
    account_id			int				not null,
    PRIMARY KEY (reply_id),
    CONSTRAINT FK_comment_reply FOREIGN KEY (cmt_id) REFERENCES `comment`(comment_id),
    CONSTRAINT FK_account_reply FOREIGN KEY (account_id) REFERENCES `account`(account_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `rate`(
	account_id			int				not null,
    comic_id			int				not null,
    rating_score		decimal(4,2)	not null,
    PRIMARY KEY (account_id,comic_id),
    CONSTRAINT FK_comic_rate FOREIGN KEY (comic_id) REFERENCES `comic`(comic_id),
    CONSTRAINT FK_account_rate FOREIGN KEY (account_id) REFERENCES `account`(account_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `share`(
	account_id			int				not null,
    comic_id			int				not null,
    share_date			date,
    share_text			varchar(300),
    webtoon_link		varchar(100),
    PRIMARY KEY (account_id,comic_id),
    CONSTRAINT FK_comic_share FOREIGN KEY (comic_id) REFERENCES `comic`(comic_id),
    CONSTRAINT FK_account_share FOREIGN KEY (account_id) REFERENCES `account`(account_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `follow`(
	account_id			int				not null,
    comic_id			int				not null,	
    follow_date			date,
    PRIMARY KEY (account_id,comic_id),
    CONSTRAINT FK_comic_follow FOREIGN KEY (comic_id) REFERENCES `comic`(comic_id),
    CONSTRAINT FK_account_follow FOREIGN KEY (account_id) REFERENCES `account`(account_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `read`(
	account_id			int				not null,
    episode_id			int				not null,
    read_date			date,
    PRIMARY KEY (account_id,episode_id),
    CONSTRAINT FK_account_read FOREIGN KEY (account_id) REFERENCES `account`(account_id),
	CONSTRAINT FK_episode_read FOREIGN KEY (episode_id) REFERENCES `episode`(episode_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `download`(
	account_id			int				not null,
	episode_id			int				not null,
    download_date		date,
    PRIMARY KEY (account_id,episode_id),
    CONSTRAINT FK_account_download FOREIGN KEY (account_id) REFERENCES `account`(account_id),
    CONSTRAINT FK_episode_download FOREIGN KEY (episode_id) REFERENCES `episode`(episode_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

create table `like`(
	account_id			int				not null,
	comment_id			int				not null,
	liked_value			int,
	disliked_value		int,
    PRIMARY KEY (account_id,comment_id),
	CONSTRAINT FK_account_likes FOREIGN KEY (account_id) REFERENCES `account`(account_id),
	CONSTRAINT FK_comment_likes FOREIGN KEY (comment_id) REFERENCES `comment`(comment_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
--

INSERT INTO `account` (ACCOUNT_ID,ACCOUNT_NAME,ACCOUNT_DOB,ACCOUNT_GENDER,ACCOUNT_NATIONALITY,ACCOUNT_EMAIL,AGE) VALUES
(1,'Siranut','2002-07-04','M','THAI','Siranut.poko@hotmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(2,'Waris','2001-10-27','M','THAI','Waris2544@gmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(3,'Jittiwat','2001-08-10','M','THAI','Jittiwat@gmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(4,'Nathan','2001-11-05','M','PERUVIAN','Nathan.kkk@gmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(5,'Arth','2002-01-31','M','JAPANESE','Arth.wiwat@hotmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(6,'Kaewalin','2002-05-30','F','THAI','kaewalinmuk@gmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(7,'Chanisara','2002-04-02','F','THAI','fifafafifi@gmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(8,'Pattanan','2002-02-01','F','THAI','pattanan.tai@hotmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(9,'Thanakij','2001-08-20','M','THAI','20.bank@gmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB)),
(10,'Paul','1993-03-15','M','FRANCE','Fpaul.gm@gmail.com',YEAR(CURDATE())-YEAR(ACCOUNT_DOB));

INSERT INTO `device` (DEVICE_ID,DEVICE_NAME,DEVICE_ADDRESS,DEVICE_TYPE,DEVICE_LOGIN_DATE,ACCOUNT_ID) VALUES
(10001,"GLUAY","192.168.1.1","IPHONE 11",'2020-08-02',"1"),
(10002,"M","102.107.16.75","IPHONE 8 plus",'2021-10-08',"2"),
(10003,"YOYO","233.69.20.189","Huawei Mate 20",'2021-08-11',"3"),
(10004,"3K","226.177.185.66","Samsung s8",'2021-01-30',"4"),
(10005,"Arth","22.72.156.51","IPHONE 12",'2021-02-20',"5"),
(10006,"MUK","104.96.119.111","IPHONE 10",'2021-05-30',"6"),
(10007,"fafi","105.104.222.42","IPHONE 7",'2020-04-28',"7"),
(10008,"TAIII","103.42.170.132","IPHONE 11",'2019-03-08',"8"),
(10009,"FAH","207.8.137.232","IPHONE 13",'2019-03-05',"9"),
(10010,"jose's phone","124.249.187.2","Galaxy z flip 3",'2021-11-05',"5"),
(10011,"Wad","111.429.247.4","IPHONE 11",'2021-09-06',"4"),
(10012,"BooMy","156.264.145.8","Galaxy z flip 3",'2020-11-05',"6"),
(10013,"Inzter","234.229.156.5","IPHONE 11",'2021-01-05',"6"),
(10014,"Peko","154.158.146.3","Computer",'2020-11-06',"10"),
(10015,"Weeboo","192.244.155.2","Computer",'2021-11-01',"8"),
(10016,"IPhone","189.249.817.4","Galaxy z flip 3",'2021-08-06',"1");

INSERT INTO `payment` (TRANSACTION_NO,TRANSACTION_DATE,TRANSACTION_DETAIL,TRANSACTION_COIN,TRANSACTION_STATUS,TRANSACTION_MONEYAMOUNT,ACCOUNT_ID) VALUES
(11035,'2021-06-28',"VISA",200,'Y',69.00,1),
(11036,'2021-06-30',"MASTERCARD",3380,'N',1050.00,2),
(11037,'2021-07-01',"MASTERCARD",440,'Y',149.00,2),
(11038,'2021-07-16',"VISA",200,'Y',69.00,4),
(11039,'2021-08-05',"PAYPAL",440,'Y',149.00,5),
(11040,'2021-08-28',"MASTERCARD",200,'N',69.00,6),
(11041,'2021-08-30',"VISA",440,'Y',149.00,6),
(11042,'2021-09-02',"MASTERCARD",997,'Y',349.00,8),
(11043,'2021-10-15',"PAYPAL",997,'Y',349.00,9),
(11044,'2021-11-08',"VISA",3380,'Y',1050.00,10),
(11045,'2021-05-18',"MASTERCARD",3380,'N',1050.00,2),
(11046,'2021-05-19',"MASTERCARD",3380,'Y',1050.00,2),
(11047,'2021-17-05',"PAYPAL",200,'Y',69.00,5),
(11048,'2020-12-27',"VISA",440,'N',149.00,4),
(11049,'2020-12-28',"VISA",440,'Y',149.00,4),
(11050,'2019-10-15',"MASTERCARD",997,'Y',349.00,7),
(11051,'2019-11-14',"PAYPAL",997,'N',349.00,9),
(11052,'2019-11-15',"VISA",3380,'Y',1050.00,1),
(11053,'2018-09-08',"PAYPAL",200,'Y',69.00,9),
(11054,'2020-07-26',"VISA",440,'Y',149.00,10),
(11055,'2021-02-23',"PAYPAL",200,'Y',69.00,5),
(11056,'2019-02-15',"MASTERCARD",200,'Y',69.00,6),
(11057,'2020-12-19',"MASTERCARD",200,'N',69.00,7),
(11058,'2020-12-20',"MASTERCARD",3380,'Y',1050.00,8),
(11059,'2018-05-21',"PAYPAL",3380,'Y',1050.00,5),
(11060,'2019-06-17',"MASTERCARD",440,'Y',149.00,6),
(11061,'2020-04-05',"MASTERCARD",440,'Y',149.00,7),
(11062,'2021-09-30',"PAYPAL",3380,'Y',1050.00,9),
(11063,'2020-03-10',"VISA",3380,'N',1050.00,10),
(11064,'2020-03-13',"VISA",440,'Y',149.00,10);


INSERT INTO `comic`(COMIC_ID,COMIC_NAME,COMIC_DESCRIPTION,COMIC_AUTHOR,COMIC_RATING,COMIC_FOLLOWER,FIRST_DATE_PUBLISH,COMIC_GENRE) VALUES
(101,"ชะตาวันสิ้นโลก","เดี๋ยวนะ สถานการณ์นี่มันคุ้นๆ? โลกใบเดิมพลิกผันไปในชั่วพริบตา! ชีวิตพนักงานบริษัทธรรมดาๆ ของผมเปลี่ยนแปลงไปอย่างฉับพลัน นี่มันโลกในนิยายที่มีผมอ่านอยู่แค่คนเดียวนี่!","sing N song",9.92,413900,'2020-07-03',"Fantasy"),
(102,"ความลับของนางฟ้า","เธอสวยจนใครๆ ก็เรียกว่า นางฟ้า แต่เบื้องหลังความสวยนั้น มี ความลับ บางอย่างซ่อนอยู่!","เหมียว",9.74,2300000,'2018-05-04',"Romance"),
(103,"นาโนมาชิน","เรื่องราวของชอนยออุนลูกนอกสมรสภายในพรรคมารที่ได้เป็นเทวบุตรมารรุ่นที่ 2 และอยู่เหนือประมุขพรรคมาร","กึมกังบุลกเว",9.91,279000,'2020-09-21',"Action"),
(104,"LOOKISM","จากหนุ่มอ้วนอัปลักษณ์ บ้านจน แถมยังถูกแกล้งที่โรงเรียนไม่เว้นแต่ละวัน วันหนึ่ง เขาตื่นขึ้น และพบว่า ตนเองกลายเป็นหนุ่มหล่อสุดเพอร์เฟ็คต์!! นี่เกิดอะไรขึ้นกับเขากันนะ?!!","ปาร์คแทจุน",9.77,2100000,'2015-11-04',"Action"),
(105,"Good Morning Professor","เคน นายแบบหนุ่ม ผู้ใช้ชีวิตเสเพลไปวันๆ ได้ย้ายห้องเช่ามาที่แมนชั่นแห่งหนึ่ง ด้วยความเมาจนจำห้องผิด เขาจึงได้เจอกับ นรงค์ อาจารย์มหาวิทยาลัยที่ใช้ชีวิตต่างกับเขาสุดขั้ว แต่ดูเหมือนว่าทั้งสองคนจะมีสิ่งที่สามารถเติมเต็มส่วนที่ขาดหายไปของอีกฝ่ายได้อย่างน่าประหลาด","Tako",9.89,113500,'2021-07-29',"Boys Love"),
(106,"BAD GUY","คังจีอุงใช้ชีวิตเป็นคนดีมาตลอด 10 ปีเพราะซูจิน คนที่เขาชอบเคยบอกว่าชอบคนดี แต่หลังจากเห็นซูจินคบกับเด็กเกเร จีอุงก็ตัดสินใจใหม่ ว่าจะพยายามเป็นคนเลวกว่าคนที่ซูจินคบให้ได้!","ดุมส์",9.86,340700,'2020-11-25',"Action"),
(107,"รักนี้ต้องปฏิวัติ","รักแรกปิ๊งมันเป็นอย่างนี้เอง! แต่งานนี้เห็นท่าจะไม่หมู เพราะสาวเท่อย่างเธอไม่ชายตามองหนุ่มติ๋มอย่างเขาเลยสักนิด แบบนี้ก็มีแต่ต้องตามตื้อเท่านั้นแล้วล่ะ!","232",9.69,256400,'2016-10-31',"Drama"),
(108,"กลั้นน้ำตา","บางครั้ง คนเราก็ต้องมีเรื่องที่ต้องกลั้นน้ำตากันบ้าง","Pixel Ghost",9.62,392900,'2017-01-21',"Daily life"),
(109,"ไก่ทอดคลุกซอส","เครื่องจักรประหลาดได้เปลี่ยนมนุษย์ให้เป็นไก่ทอดคลุกซอส... มีเบาะแสโผล่มามากมายแต่ไหนยังจะมีการหายตัวไปของคนที่เกี่ยวข้องอีก ความลับของเครื่องจักรนี้คืออะไรกันแน่นะ?","พัคจีดก",8.98,18400,'2021-11-01',"Thriller"),
(110,"Troll Trap","ตอนแรกเป็นหมาฉัน ต่อมาก็เป็นฉัน ที่รับรู้ว่ามีบางอย่างผิดปกติกับน้องชาย แล้วก็ถูกอย่างที่ฉันคิด มีตัวประหลาดกำลังสิงร่างเขาอยู่จริงๆ!","U. bi",9.74,86000,'2021-10-05',"Fantasy");


INSERT INTO `episode`(CMC_ID,EPISODE_ID,EPISODE_DATE,EPISODE_TITLE,FREE_RELEASE_DATE,DAY_OF_FREE_RELEASE,FREE_VIEW_FLAG) VALUES
(101,5000,'2020-07-03',"000. บทนำ ",'2020-07-03',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(102,6173,'2021-09-06',"Ep. 173 ",'2021-09-06',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(103,7064,'2021-10-18',"064. บทที่ 25 การสอบระดับสามที่แสนจะอันตราย(1)",'2022-02-22',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'N'),
(104,8362,'2021-10-27',"Ep. 362 ",'2021-10-27',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(105,9009,'2021-09-09',"Ep.09 เป็นห่วง? ",'2021-09-09',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(106,10054,'2021-10-27',"Ep.54",'2022-01-17',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'N'),
(107,1374,'2021-11-15',"Ep. 374 ชนวน",'2021-11-15',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(108,2565,'2020-09-26',"Ep. 565 เลี้ยงเลย",'2020-09-26',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(109,3001,'2021-11-01',"Ep.1 ",'2021-11-01',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(110,4005,'2021-10-19',"Ep.5 ",'2021-10-19',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(101,5068,'2021-10-08',"Ep.15 โลกที่ไร้ราชา ",'2021-10-08',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(102,6181,'2021-11-08',"Ep.181 ",'2021-11-08',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(103,7065,'2021-11-22',"Ep.065 บทที่ 25 การสอบระดับสามทีแสนจะอันราย(2)",'2022-02-05',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'N'),
(104,8365,'2021-11-11',"Ep.365 ",'2021-11-11',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(105,9017,'2021-11-04',"Ep.17 การเปลี่ยนแปลง ",'2021-11-04',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(106,10050,'2021-10-20',"Ep.50 ",'2021-10-20',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(107,1373,'2021-11-08',"Ep.373 โอกาส ",'2021-11-08',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(108,2744,'2021-11-15',"Ep.744 คอยเป็นห่วง ",'2021-11-15',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(109,3005,'2021-11-15',"Ep.5 ",'2021-11-15',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y'),
(110,4008,'2021-11-09',"Ep.8 ",'2021-11-09',DATEDIFF(FREE_RELEASE_DATE,CURDATE()),'Y');

INSERT INTO `comment`(COMMENT_ID,COMMENT_TEXT,COMMENT_DATE,DELETED_DATE,UPDATED_DATE,EPISODE_ID,ACCOUNT_ID) VALUES
(50001,"เปิดมานึกว่า solo leveling ss2 ออกแล้วซะอีก",'2020-07-05',NULL,NULL,5000,1),
(61731,"พ่อซูโฮหล่อจริงง",'2020-07-03',NULL,NULL,6173,2),
(70641,"ฆ่ามันเลยนายท่าน!!!",'2021-11-03',NULL,NULL,7064,3),
(83621,"ว้าว สกิลใหม่ ถ้าสกิลใหม่+ไร้สติ = พระเจ้า (หรือเปล่า)",'2021-09-30',NULL,NULL,8362,4),
(90091,"คนเขียนไม่ต้องกังวลนะคะ ยิ่งโควิดยิ่งชอบอ่านค่ะ และเรื่องนี้ก็ช่วยเยียวยาจิตใจได้ดีมากๆ ด้วยค่ะ",'2021-08-26',NULL,NULL,9009,5),
(100541,"นี่สินะที่เรียกว่า ป้ายยา",'2021-10-27',NULL,NULL,10054,6),
(13741,"รับความจริงไม่ได้ก็ใช้กำลังสินะ เเกงไอ้เด็กน้อย",'2021-11-01',NULL,NULL,1374,7),
(25651,"-อยากกินอะไรแพงๆ แบบเรือดำน้ำจัง- ....พี่พีชได้กล่าวไว้....",'2020-09-26',NULL,NULL,2565,8),
(30011,"เห็นลายเส้นก็รู้เลย5555555 fc มันฝรั่งจ้า 55555",'2021-11-01',NULL,NULL,3001,9),
(40051,"เพื่อน นั่นแม่นายเหรอ..",'2021-10-08',NULL,NULL,4005,10),
(50681,"ดกจายิ้มน่ารักมาก โอยยย ใจมัมมีเหลวไปหมดแล้วนะ",'2021-10-15',NULL,NULL,5068,1),
(61811,"หิวเเสงที่แท้ทรู",'2021-10-18',NULL,NULL,6181,2),
(70651,"มันส์ม๊ากกกกก",'2021-11-22',NULL,NULL,7065,3),
(83651,"ระดับจงกอนจุนกูเยอะจังวะตอนนี้ใครกากบ้างเอาจริงๆเนี่ย",'2021-10-21',NULL,NULL,8365,4),
(90171,"รออาจารย์เปลี่ยนเสื้ออีก7วัน;-;",'2021-10-14',NULL,NULL,9017,5),
(100501,"ยอมเจ็บตัวเพื่อเป็นพี่เขยแห่งหัวหน้าแก๊งหมีไฟ ดีกว่าจะเป็นหัวหน้าแก๊งนักเลงมัธยมพี่เขยคิดการไกล",'2021-09-29',NULL,NULL,10050,6),
(13731,"TOPอารัมตอนนี้MVP พูดแทนคนอ่านเฉย5555",'2021-10-25',NULL,NULL,1373,7),
(27441,"เดี๋ยวนะ หมอนั่นมันมีคนเอาด้วยหรอ !!?",'2021-11-15',NULL,NULL,2744,8),
(30051,"ตำรวจคือคนส่งของแน่เลย แค่โกนหนวด!!",'2021-11-02',NULL,NULL,3005,9),
(40081,"หัวหลุดไปเลย มีระบบเหมาทั้งเรื่องไหม พร้อมเปย์เรื่องนี้มาก",'2021-10-06',NULL,NULL,4008,10);

INSERT INTO `character`(CMC_ID,CHARACTER_ID,CHARACTER_FNAME,CHARACTER_LNAME,CHARACTER_ROLE,CHARACTER_AGE,CHARACTER_GENDER,CHARACTER_NATION,CHARACTER_HABIT) VALUES
(101,354,"Song","Jin Wu","Protagonist",18,"M","KOREAN","Sily"),
(102,364,"Joo Kyung",NULL,"Protagonist",21,"F","KOREAN","Self confident"),
(103,374,"Cheon ","Yeo-Woon","Protagonist",NULL,"M","CHINESE","Strive"),
(104,384,"Park","Hyung-Seok","Protagonist",18,"M","KOREAN","Innocent"),
(105,394,"วิสุทธิ์","วงษ์วานิช","Protagonist",22,"M","THAI",NULL),
(106,404,"Kang","Ji Woon","Protagonist",18,"M","KOREAN","Sily"),
(107,414,"Gong","Joo Young","Protagonist",17,"M","KOREAN",NULL),
(108,424,"NULL",NULL,"Protagonist",NULL,"M","THAI",NULL),
(109,434,"Mina",NULL,"Protagonist",18,"F","KOREAN","Innocent"),
(110,444,"Ji","Hyun","Protagonist",18,"F","KOREAN","Brave");

INSERT INTO `reply`(CMT_ID,REPLY_ID,REPLY_TEXT,REPLY_DATE,DELETED_DATE,UPDATED_DATE,ACCOUNT_ID) VALUES
(50001,500010,"ผมไม่รู้นะว่ามีด้วย แต่ภาพกับเนื้อเรื่องดูน่าสนใจมากครับ",'2020-07-03',NULL,NULL,1),
(61731,617310,"จริงงงงมากกก",'2021-01-01','2021-01-02',NULL,2),
(70641,706410,"++++",'2021-01-01',NULL,'2021-01-01',2),
(83621,836210,"ฮยองซอกก็อปท่าถีบหน้าที่จินซองถีบหน้าโยฮันมาสินะ",'2021-09-30',NULL,NULL,4),
(90091,900910,"+++++",'2021-09-10',NULL,NULL,5),
(100541,1005410,"555",'2021-10-29',NULL,NULL,6),
(13741,137410,"จริง..ยอมรับความจริงว่าตัวเองไม่ได้รักเขา",'2021-11-01',NULL,NULL,7),
(25651,256510,"เสี่ยงคุกนะพี่พีช",'2020-09-26',NULL,NULL,8),
(30011,300110,"ภาพมันฝรั่งแอบแซ่บกับข้าวโพดยังติดตาเราอยู่เลย 5555 kfc มันฝรั่งนะครัฟๆ",'2021-11-01',NULL,NULL,9),
(40051,400510,"อ้าวหวัดดี จอดี้",'2021-10-19',NULL,NULL,10),
(50681,506810,"กะอักเลือดกองโตสิครับรอไร",'2021-10-16',NULL,NULL,1),
(61811,618110,"55555",'2021-11-08',NULL,NULL,2),
(70651,706510,"+++ครับ",'2021-11-22',NULL,NULL,3),
(83651,836510,"“มาแทซู” นามสกุล “มา” แบบนี้ มีความเป็นไปได้ไหมที่จะเกี่ยวข้องกับ “มาโชอิล”",'2021-10-21',NULL,NULL,4),
(90171,901710,"เหลือไม่กี่บาทเองงั้นต้องนั่งรอ 7 วันค่ะ;-;",'2021-11-04',NULL,NULL,5),
(100501,1005010,"โชคดีที่เยจีชอบพระเอกพอดี ชีวิตพี่เขยดูท่าจะโรยด้วยกลีบกุหลาบซะแล้ว 555555",'2021-10-20',NULL,NULL,6),
(13731,137310,"ผมมีสปอย",'2021-11-08',NULL,NULL,7),
(27441,274410,"ใช่ไง ไม่เหมือนพระเอกเรื่องนี้สักหน่อย",'2021-11-15',NULL,NULL,8),
(30051,300510,"เดี๊ยว เขาไม่มีหนวดอยู่แล้ว",'2021-11-16',NULL,NULL,9),
(40081,400810,"+++โครตมันเลยค่ะะโครตชอบ กรี๊ด",'2021-11-02',NULL,NULL,10);

INSERT INTO `rate`(ACCOUNT_ID,COMIC_ID,RATING_SCORE) VALUES
(1,101,10.00),
(1,102,7.00),
(2,102,9.00),
(2,105,9.00),
(2,106,4.00),
(2,107,9.00),
(2,109,8.00),
(2,110,4.00),
(3,101,8.00),
(3,103,6.00),
(4,101,5.00),
(4,102,2.00),
(5,108,10.00),
(6,105,8.60),
(6,106,8.30),
(6,108,8.10),
(7,109,6.00),
(9,101,8.70),
(9,105,2.00),
(9,106,8.70),
(9,108,2.00),
(10,104,9.00),
(10,105,8.00),
(10,107,7.90),
(10,108,8.80),
(10,109,10.00),
(10,110,9.00);

INSERT INTO `share`(ACCOUNT_ID,COMIC_ID,SHARE_DATE,SHARE_TEXT,WEBTOON_LINK) VALUES
(1,101,'2021-07-03',"อ่านชะตาวันสิ้นโลก อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/fantasy/omniscient-reader/list?title_no=2106'),
(1,102,'2019-05-18',"ความลับของนางฟ้า อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/romance/goddess/list?title_no=1380'),
(3,103,'2020-10-25',"นาโนมาชิน อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/action/nano-mashin/list?title_no=2171'),
(3,104,'2015-11-23',"LOOKISM อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/action/lookism/list?title_no=576'),
(1,105,'2021-07-03',"Good Morning Professor อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/bl-gl/good-morning-professor/list?title_no=3120'),
(1,106,'2020-12-03',"BAD GUY อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/comedy/badguy/list?title_no=2342'),
(1,107,'2018-10-25',"รักนี้ต้องปฏิวัติ อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/drama/love-revolution/list?title_no=800'),
(2,108,'2020-05-05',"กลั้นน้ำตา อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/slice-of-life/try-not-to-cry/list?title_no=930'),
(6,109,'2021-11-03',"ไก่ทอดคลุกซอส อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/thriller/fried-chicken/list?title_no=3627'),
(1,110,'2021-11-03',"Troll Trap อ่านยัง สนุกแรง!ติดตามได้ที่ LINE WEBTOON",'https://www.webtoons.com/th/fantasy/trolltrap/list?title_no=3520');

INSERT INTO `follow`(ACCOUNT_ID,COMIC_ID,FOLLOW_DATE) VALUES
(1,101,'2020-03-03'),
(1,102,'2021-07-01'),
(1,103,'2021-05-15'),
(1,104,'2020-07-06'),
(1,105,'2020-01-03'),
(2,104,'2021-10-13'),
(2,108,'2021-10-11'),
(2,109,'2021-10-13'),
(2,110,'2021-10-18'),
(3,101,'2019-11-23'),
(3,102,'2019-11-29'),
(4,104,'2020-05-05'),
(5,108,'2021-01-14'),
(5,110,'2021-06-03'),
(5,109,'2021-07-18'),
(6,105,'2019-01-04'),
(6,103,'2019-05-18'),
(7,102,'2019-04-15'),
(7,103,'2019-02-08'),
(9,105,'2019-03-03'),
(10,107,'2019-02-04'),
(10,108,'2019-08-03'),
(10,104,'2019-04-03'),
(10,105,'2019-02-16'),
(10,106,'2020-02-03');

INSERT INTO `read`(ACCOUNT_ID,EPISODE_ID,READ_DATE) VALUES
(1,5000,'2020-07-03'),
(1,4005,'2021-10-20'),
(1,5068,'2021-10-09'),
(2,6173,'2021-09-06'),
(2,6181,'2021-11-09'),
(2,1374,'2021-11-15'),
(2,2744,'2021-11-20'),
(3,7064,'2021-10-18'),
(3,7065,'2021-11-15'),
(3,10050,'2021-10-25'),
(4,8362,'2021-10-27'),
(4,3001,'2021-11-01'),
(4,9017,'2021-11-15'),
(4,8365,'2021-11-12'),
(5,2565,'2020-09-26'),
(5,9009,'2021-09-09'),
(5,9017,'2021-11-05'),
(5,10054,'2021-09-10'),
(6,10054,'2021-10-27'),
(6,10050,'2021-10-22'),
(6,8362,'2021-10-28'),
(7,1373,'2021-11-09'),
(7,7064,'2021-10-19'),
(8,2744,'2021-11-16'),
(8,6173,'2021-09-07'),
(9,3005,'2021-11-15'),
(9,5000,'2020-07-04'),
(10,4005,'2021-10-19'),
(10,4008,'2021-11-09'),
(10,9017,'2021-11-20');

INSERT INTO `download`(ACCOUNT_ID,EPISODE_ID,DOWNLOAD_DATE) VALUES
(1,5000,'2020-07-03'),
(1,6173,'2021-10-20'),
(1,5068,'2021-10-09'),
(2,9017,'2021-09-06'),
(2,6181,'2021-11-09'),
(2,1374,'2021-11-15'),
(2,6173,'2021-11-20'),
(3,7064,'2021-10-18'),
(3,7065,'2021-11-15'),
(3,10050,'2021-10-25'),
(4,8362,'2021-10-27'),
(4,3001,'2021-11-01'),
(4,9017,'2021-11-15'),
(4,8365,'2021-11-12'),
(5,2565,'2020-09-26'),
(5,10050,'2021-09-09'),
(5,9017,'2021-11-05'),
(5,10054,'2021-09-10'),
(6,10054,'2021-10-27'),
(6,10050,'2021-10-22'),
(6,6173,'2021-10-28'),
(7,1373,'2021-11-09'),
(7,6173,'2021-10-19'),
(8,2744,'2021-11-16'),
(8,6173,'2021-09-07'),
(9,4008,'2021-11-15'),
(9,5000,'2020-07-04'),
(10,4005,'2021-10-19'),
(10,5000,'2021-11-09'),
(10,4008,'2021-11-20');

INSERT INTO `like`(ACCOUNT_ID,COMMENT_ID,LIKED_VALUE,DISLIKED_VALUE) VALUES
(1,50001,1,NULL),
(1,13731,1,NULL),
(1,50681,1,NULL),
(2,70651,1,NULL),
(2,100541,NULL,1),
(2,61731,1,NULL),
(3,83621,NULL,1),
(3,61811,NULL,1),
(3,70641,1,NULL),
(4,83621,1,NULL),
(4,90171,NULL,1),
(4,70641,1,NULL),
(5,90091,NULL,1),
(5,83651,NULL,1),
(5,70641,NULL,1),
(6,13731,1,NULL),
(6,100541,1,NULL),
(6,30051,NULL,1),
(7,13741,1,NULL),
(7,100501,1,NULL),
(7,40081,1,NULL),
(8,25651,NULL,1),
(8,30051,NULL,1),
(8,100541,NULL,1),
(9,30011,1,NULL),
(9,27441,NULL,1),
(10,40051,1,NULL),
(10,40081,1,NULL),
(10,50001,1,NULL),
(10,70651,1,NULL);

--
--

select *
from `account`;

select *
from `device`;

select *
from `payment`;

select *
from `comic`;

select *
from `episode`;

select *
from `comment`;

select *
from `character`;

select *
from `reply`;

select *
from `rate`;

select *
from `share`;

select *
from `follow`;

select *
from `read`;

select *
from `download`;

select *
from `like`;