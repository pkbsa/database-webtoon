-- Queries --

-- (1) Find Account Using gmail
select account_name, account_email
from `account`
where account_email LIKE "%gmail%"
order by account_name ASC;

-- (2) Find Account Born Before 2002
select account_name, account_dob
from `account`
where YEAR(account_dob) < 2002
order by account_name ASC;

-- (3) Find Account that is Male
select account_name, account_gender
from `account`
where account_gender = "M"
order by account_name ASC;

-- (4) Find Account who nationality is not Thai
select account_name, account_nationality
from `account`
where account_nationality not like "THAI"
order by account_name ASC;

-- (5) Find the account that is Thai
select account_nationality , count(account_nationality)
from `account`
where account_nationality = "THAI"
group by account_nationality;

-- (6) List all Device type
select distinct device_type
from device
order by device_type ASC;

-- (7) List all account id who have more than 1 device
select account_id, count(device_type)
from device
group by account_id
having count(device_type) > 1
order by account_id ASC;

-- (8) List all device_name that is not login in 365 days
select device_name, datediff(curdate(),device_login_date) As "Last Login Day"
from device
where datediff(curdate(),device_login_date) > 365
order by datediff(curdate(),device_login_date) DESC;

-- (9) List all transaction Number that is paid by Mastercard
select transaction_no, transaction_detail
from payment
where transaction_detail like "%mastercard%"
order by transaction_no ASC;

-- (10) List all success transaction
select transaction_no, transaction_detail
from payment
where transaction_status = 'Y'
order by transaction_no ASC;

-- (11) List all success where coin is more than 440
select transaction_no, transaction_coin,transaction_moneyamount
from payment
where transaction_status = 'Y' and transaction_coin > 440
order by transaction_no ASC;

-- (12) List all successs transaction detail
select transaction_detail, count(transaction_no)
from payment
where  transaction_status = "Y"
group by transaction_detail;

-- (13) List all comic that have rating more than 9.8
select *
from comic
where comic_rating > 9.8;

-- (14) List all comic that have follower more than 100000 and publish before 2020
select *
from comic
where (comic_follower > 100000) and (YEAR(first_date_publish) < 2020);

-- (15) List all action comic name
select comic_name, comic_genre
from comic 
where (comic_genre LIKE "%action%")
order by comic_name ASC;

-- (16) List all character whose name begins with “J” and have age more than 17
select *
from `character`
where (character_fname like "J%") and (character_age > 17);

-- (17) List all character whose role is “Protagonist”
select *
from `character`
where character_role = "Protagonist";

-- (18) List reply text that was replied account’s id 2
select reply_text, cmt_id
from reply
where (account_id = 2);

-- (19) List account ID and Comic ID that have rating more than 7
select account_id, comic_id
from rate
where (rating_score > 7);

-- (20) List all share data that share in November
select *
from `share`
where MONTH(share_date) = 11;

-- (21) Show the account’s name who rate comic “ชะตาวันสิ้นโลก” and is male
select account_name, rating_score, account_gender
from `account` 
inner join rate on `account`.account_id = rate.account_id
inner join comic on rate.comic_id = comic.comic_id
where account_gender = "M" and comic_name like "%ชะตาวันสิ้นโลก%";

-- (22) Show top 3 comic that most of people rate
select comic_name, comic_rating, count(rating_score) as num_rating
from comic 
inner join rate on comic.comic_id = rate.comic_id
group by rate.comic_id
order by count(rating_score) DESC, comic_rating DESC
limit 3;

-- (23) Show list of account who have pay coin more than 500 and name begins with “W”
select distinct at.account_id, account_name, transaction_coin
from `account` at 
inner join payment pt on at.account_id = pt.account_id
where account_name like "W%" and transaction_coin > 500;

-- (24) Show list name of device “iphone” who have payment with "VISA"
select Distinct device_name,transaction_detail,device_type
from device
left outer join payment on device.account_id = payment.account_id
where transaction_detail like "VISA" and device_type like "%IPhone%";

-- (25) List all account email and their device name who are male
 select account_email, device_name, account_gender
 from account
 left outer join device on `account`.account_id = device.account_id
 where account_gender = "M";

-- (26) Show all comment from comic name “BAD GUY” and is a women
select comment_text, comic_name, account_name ,account_gender
from `comment`
inner join episode on `comment`.episode_id = episode.episode_id
inner join comic on comic.comic_id = episode.cmc_id
inner join `account` on `account`.account_id = `comment`.account_id
where account_gender = "F" and comic_name like "%BAD GUY%";

-- (27) Show total rating from comic that character not have last name and gender male
select distinct comic_name, comic_rating
from comic
left outer join `character` on comic.comic_id = `character`.cmc_id
where character_lname is null; 

-- (28) Show all reply and account name that is from comic “นาโนมาชิน” and “LOOKISM”
select cmt_id, comic_name, reply_id, reply_text, reply_date, account_name
from reply
left outer join `comment` on `comment`.comment_id = reply.cmt_id
left outer join `account` on `account`.account_id = reply.account_id
left outer join episode on episode.episode_id = `comment`.episode_id
left outer join comic on comic.comic_id = episode.cmc_id
where (comic_name like "%นาโนมาชิน%") or (comic_name like "%LOOKISM%");

-- (29) Show top 3 account who dislike comment the most
select `account`.account_id,account_name,count(`account`.account_id) AS "disliked times"
from `like`
left outer join `account` on `account`.account_id = `like`.account_id
where disliked_value = 1
group by `account`.account_id
order by count(`account`.account_id) DESC, `account`.account_id ASC
limit 3;

-- (30) Show top 3  comic that have be read
select comic_id, comic_name, count(comic_id) AS "read times"
from `read`
left outer join episode on episode.episode_id = `read`.episode_id
left outer join comic on comic.comic_id = episode.cmc_id
where YEAR(read_date) = 2021
group by comic_id
order by count(comic_id) desc
limit 3;

-- (31) Show list of comic name that account id, 5, follow 
select comic.comic_id, comic_name, follow_date
from follow
left outer join comic on comic.comic_id = follow.comic_id
where account_id = 5;

-- (32) Show top 5 comic that have most amount of download
select comic_id, comic_name, count(comic_id)
from download
left outer join episode on episode.episode_id = download.episode_id
left outer join comic on comic.comic_id = episode.cmc_id
group by comic_id
order by count(comic_id) DESC
limit 5;

-- (33) Show number of rate of comic id 101-105 and comic name
select comic.comic_id, comic_name, count(rate.comic_id) AS "rate times"
from comic
right outer join rate on rate.comic_id = comic.comic_id
where (comic.comic_id >= 101) and (comic.comic_id <= 105)
group by comic.comic_id
order by comic_id ASC;

-- (34) Show comic that have been download under 2021 and comic name
select comic_id,comic_name ,count(comic_id) as "download times"
from download
left outer join episode on episode.episode_id = download.episode_id
left outer join comic on comic.comic_id = episode.cmc_id
where YEAR(download_date) = 2021
group by comic_id
order by count(comic_id) DESC;

-- (35) Show episode title that be in comic “BAD GUY” and can read by free
select episode_title ,comic.comic_name ,free_view_flag
from episode
left outer join comic on comic.comic_id = episode.cmc_id
where comic_name = "BAD GUY" and free_view_flag = "Y"
order by episode_title ASC;

-- (36) Show list account who like the comment and the comment text in comic “Troll trap” 
select `like`.account_id, account_name , `comment`.comment_id, comment_text, liked_value
from `like`
left outer join `account` on `account`.account_id = `like`.account_id
left outer join `comment` on `comment`.comment_id = `like`.comment_id
left outer join episode on episode.episode_id = `comment`.episode_id
left outer join comic on comic.comic_id = episode.cmc_id
where (liked_value = 1) and (comic_name like "Troll trap")
order by account_id ASC;

-- (37) Show comic that have account id, 1, read and follow
select distinct comic_name
from comic
right outer join episode on episode.cmc_id = comic.comic_id
right outer join `read` on `read`.episode_id = episode.episode_id
right outer join follow on follow.comic_id = comic.comic_id
where (follow.account_id = 1) and (`read`.account_id = 1)
order by comic_name ASC;

-- (38) Show comic that have character region korean and account_id 4 follow the comic
select distinct comic_name
from `character`
left outer join comic on comic.comic_id = `character`.cmc_id
left outer join follow on follow.comic_id = comic.comic_id
left outer join `account` on `account`.account_id = follow.account_id
where character_nation like "%KOREAN%" and (follow.account_id = 4)
order by comic_name ASC;

-- (39) Show total of average rating of all comic and comic name with amount of people who rate it
select distinct comic.comic_id,comic_name, avg(rating_score), count(account_id)
from comic
right outer join rate on rate.comic_id = comic.comic_id  
group by comic_id
order by comic.comic_id asc;

-- (40) Show the comment text that was replied by account id 7
select cmt_id, comment_text, comment_date, reply_text, reply_date
from reply
left outer join `comment` on `comment`.comment_id = reply.cmt_id
where reply.account_id = 7
order by cmt_id ASC


