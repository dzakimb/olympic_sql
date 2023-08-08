show databases;

CREATE DATABASE olympics;

USE olympics;

SHOW TABLES;

DROP TABLE supermarket;

SELECT * FROM olympics;

-- 1. Find total no of summer olympic games
-- 2. Find  for each sport, how many games where they played
-- 3. Compare 1 & 2

(select count(DISTINCT games) as total_summer_games 
from olympics where season='Summer');

-- 2.
select DISTINCT sport, games from olympics
where season='summer' order by games
;

select sport, count(games) as count
from olympics
group by sport
order by count desc;


-- Coding SQL challenge by: https://techtfq.com/blog/practice-writing-sql-queries-using-real-dataset
-- Using data olympycs from kaggle: https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results?select=athlete_events.csv

-- 1. How many olympics games have been held?
select count(distinct games) from olympics;
-- So there were 51 olympic games held

--2. List down all Olympics games helf so far
select distinct games, season, city from olympics as all_olympic order by games;


-- 3. Mention the total no of nations who participated in each olympics game?
select games, count(distinct noc) from olympics 
group by games
order by games;
-- total nation were 230 nation that participate in each olympics, we don't use team because there were team that NOW
-- is 2 different nation


-- 4.	Which year saw the highest and lowest no of countries participating in olympics?
-- I do with max and min
select 
    concat(games_max_info.games, ' - ', games_max_info.count_nation) as highest_country,
    concat(games_min_info.games, ' - ', games_min_info.count_nation) as lowest_country
from 
    (select games, count_nation
    from 
    (select games, count(DISTINCT noc) as count_nation
    from olympics
    group by games) as n
    where count_nation = 
        (select max(count_nation) 
        from 
            (select games, count(DISTINCT noc) as count_nation
            from olympics
            group by games) as o)) as games_max_info
join
    (select games, count_nation
    from 
    (select games, count(DISTINCT noc) as count_nation
    from olympics
    group by games) as n
    where count_nation = 
        (select min(count_nation) 
        from 
            (select games, count(DISTINCT noc) as count_nation
            from olympics
            group by games) as o)) as games_min_info;

-- I do with order by and limit
select 
    concat(games_max_info.games, ' - ', games_max_info.count_nation) as highest_country,
    concat(games_min_info.games, ' - ', games_min_info.count_nation) as lowest_country
from 
    (select games, count(DISTINCT noc) as count_nation
    from olympics
    GROUP BY games
    order by count_nation desc limit 1) as games_max_info
    join 
    (select games, count(DISTINCT noc) as count_nation
    from olympics
    GROUP BY games
    order by count_nation limit 1) as games_min_info;




-- 5.	Which nation has participated in all of the olympic games?
select * from olympics;

select region
from noc_region
where noc in
    (select n.noc
    from
        (select noc, count(distinct games) as count_games
        from olympics 
        group by noc) as n
        where count_games = (select count(DISTINCT games) from olympics));
select sport, count_games FROM
    (select sport, count(distinct games) as count_games
    from olympics
    group by sport) as m
    where count_games = 
        (select max(count_games) from
        (select sport, count(distinct games) as count_games
        from olympics 
        group by sport) as N);

-- 6.	Identify the sport which was played in all summer olympics.
select sport, count(distinct games) as count_games
from olympics
group by sport
having count_games =    
    (select count(DISTINCT games) as max_games
    from olympics
    group by sport
    order by max_games desc
    limit 1);

select distinct season
from olympics;






select distinct sport
from olympics
where season = "summer";
select 
from
    (select games, sport
    from olympics
    where season = "summer");

-- 7.	Which Sports were just played only once in the olympics?

select sport, count(distinct);
select distinct o.sport, count_games, concat(o.year, ' ', o.season) 
from olympics o
join (
    select *
    from
    (select sport, count(DISTINCT games) as count_games
    from olympics
    GROUP BY sport) as n 
    where count_games = 1) d on o.sport = d.sport
order by o.sport;


select concat(Year, ' ', Season) 
FROM
    (select `Year`, `Season` FROM olympics) as m ;


-- 8.	Fetch the total no of sports played in each olympic games.
select games, count(distinct sport) as count_sport
from olympics
group by games order by count_sport desc, games;




-- 9.	Fetch details of the oldest athletes to win a gold medal.
select name, sex, age, sport, team, games, event, medal 
from olympics
where medal ='Gold' and age = (select age 
    from olympics
    where medal='Gold'
    order by age desc limit 1)
order by age desc;




-- 10.	Find the Ratio of male and female athletes participated in all olympic games.

SELECT concat(cast(t1.count_gender_male/t2.count_gender_female as decimal(5,2)), " : ", 1) as `ratio men vs women` from
    (select count(id) as count_gender_male from olympics
    where sex = 'm'
    group by sex) as t1
    JOIN
    (select count(id) as count_gender_female from olympics
    where sex='f'
    group by sex) as t2;


select convert(decimal(3,2), 2./3) decimaldivision;

select cast(1/2 as decimal(10,2));


-- 11.	Fetch the top 5 athletes who have won the most gold medals.
use olympics;
select t1.name, t2.team, t1.count_medal
from
    (select name, count(medal) as count_medal
    from olympics
    where medal = 'gold'
    group by name 
    order by count_medal desc) as t1
    JOIN
    (select name, team
    from olympics
    group by name, team) as t2
    on t1.name = t2.name
    order by t1.count_medal desc limit 5 ;
select team from olympics;
-- 12.	Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
select name, team, count(medal) as count_medal
from olympics
group by name, team order by count_medal desc;



-- 13.	Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
select team, count(medal) as count_medal, rank
from olympics
group by team 
order by count_medal desc limit 5;

select t1.region, t2.count_medal, RANK() OVER(ORDER BY t2.count_medal desc) as rank_column
from
    noc_region as t1
    JOIN
    (select noc, count(medal) as count_medal
    from olympics
    group by noc) as t2
    on t1.noc = t2.noc
    order by count_medal DESC;
show tables;

-- 14.	List down total gold, silver and broze medals won by each country.
select t1.region, t2.bronze_medal,;

SELECT t2.region, t1.gold, t1.silver, t1.bronze
    from 
    noc_region as t2
    join
    (select noc, 
    count(case when medal='gold' then 1 else null end) gold,
    count(case when medal='silver' then 1 else null end) silver,
    count(case when medal='bronze' then 1 else null end) bronze
    from olympics
    GROUP BY noc) as t1
    on t2.noc=t1.noc
    order by gold desc, silver desc, bronze desc;


-- 15.	List down total gold, silver and broze medals won by each country corresponding to each olympic games.
SELECT t1.games, t2.region AS country, t1.gold, t1.silver, t1.bronze
    from 
    noc_region as t2
    join
    (select games, noc, 
    count(case when medal='gold' then 1 else null end) gold,
    count(case when medal='silver' then 1 else null end) silver,
    count(case when medal='bronze' then 1 else null end) bronze
    from olympics
    GROUP BY games, noc) as t1
    on t2.noc=t1.noc
    order by games, country;
-- 16.	Identify which country won the most gold, most silver and most bronze medals in each olympic games.
SELECT t1.games, t2.region AS country, t1.gold, t1.silver, t1.bronze
    from 
    noc_region as t2
    join
    (select games, noc, 
    count(case when medal='gold' then 1 else null end) gold,
    count(case when medal='silver' then 1 else null end) silver,
    count(case when medal='bronze' then 1 else null end) bronze
    from olympics
    GROUP BY games, noc) as t1
    on t2.noc=t1.noc
    order by games, country;
use olympics;
-- 17.	Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
select games, noc, gold
from
(select 
    games, noc,
    count(case when medal='gold' then 1 else null end) as gold,
    count(case when medal='silver' then 1 else null end) as silver,
    count(case when medal='bronze' then 1 else null end) as bronze
FROM
    olympics group by games, noc
    order by games) as t1
order by games, gold desc;


SELECT t2.games,
from
    (select 
        games, noc,
        count(case when medal='gold' then 1 else null end) as gold,
        count(case when medal='silver' then 1 else null end) as silver,
        count(case when medal='bronze' then 1 else null end) as bronze
    FROM
        olympics group by games, noc
        order by games) as t1
JOIN
    (select distinct games
    from olympics) as t2;
;

select concat(country, ' - ', max_gold);
select games, noc, count(case when medal='gold' then 1 else null end) as gold
from olympics 
group by games, noc
order by games, gold desc;
select gold_rank.games, 
concat(region_gold.region, ' - ', gold_rank.gold) country_max_gold, 
concat(region_silver.region, ' - ', silver_rank.silver) country_max_silver,
concat(region_bronze.region, ' - ', bronze_rank.bronze) country_max_bronze
from
    (SELECT games, noc, gold
    FROM (
        SELECT 
            games,
            noc,
            gold,
            ROW_NUMBER() OVER (PARTITION BY games ORDER BY gold DESC) AS row_num
        FROM 
            (select games, noc, count(case when medal='gold' then 1 else null end) as gold
            from olympics 
            group by games, noc
            order by games, gold desc) as t1
    ) ranked_noc
    WHERE row_num = 1) gold_rank
    JOIN
    (select region, noc
    from noc_region) region_gold
    on region_gold.noc = gold_rank.noc
    join
    (SELECT games, noc, silver
    FROM (
        SELECT 
            games,
            noc,
            silver,
            ROW_NUMBER() OVER (PARTITION BY games ORDER BY silver DESC) AS row_num
        FROM 
            (select games, noc, count(case when medal='silver' then 1 else null end) as silver
            from olympics 
            group by games, noc
            order by games, silver desc) as t2
    ) ranked_noc
    WHERE row_num = 1) silver_rank
    on gold_rank.games = silver_rank.games
    JOIN
    (select region, noc
    from noc_region) region_silver
    on region_silver.noc = silver_rank.noc
    join
    (SELECT games, noc, bronze
    FROM (
        SELECT 
            games,
            noc,
            bronze,
            ROW_NUMBER() OVER (PARTITION BY games ORDER BY bronze DESC) AS row_num
        FROM 
            (select games, noc, count(case when medal='bronze' then 1 else null end) as bronze
            from olympics 
            group by games, noc
            order by games, bronze desc) as t3
    ) ranked_noc
    WHERE row_num = 1) bronze_rank
    on bronze_rank.games = silver_rank.games
    JOIN
    (select region, noc
    from noc_region) region_bronze
    on region_bronze.noc = bronze_rank.noc
    order by games
    ;



show tables;
    SELECT 
        games,
        noc,
        gold,
        ROW_NUMBER() OVER (PARTITION BY games ORDER BY gold DESC) AS row_num
    FROM 
        (select games, noc, count(case when medal='gold' then 1 else null end) as gold
        from olympics 
        group by games, noc
        order by games, gold desc) as t1;


-- 18.	Which countries have never won gold medal but have won silver/bronze medals?
select noc_region.region, noc_region.noc,gold, silver, bronze
from 
    (select noc , 
    count(case when medal='gold' then 1 else null end) as gold,
    count(case when medal='silver' then 1 else null end) as silver,
    count(case when medal='bronze' then 1 else null end) as bronze
    from olympics 
    GROUP BY noc) s
    join 
    noc_region
    on noc_region.noc = s.noc
where gold = 0 and (silver != 0 or bronze !=0 )
order by silver desc, bronze desc;

select noc, medal
from olympics
where noc = 'par';
-- 19.	In which Sport/event, India has won highest medals.
select sport, medal_count
from
(select region, sport, count(medal) as medal_count
from olympics
join noc_region
on noc_region.noc = olympics.noc
GROUP BY noc_region.region, olympics.sport) as t1
where t1.region = "india"
order by medal_count desc limit 1;

-- 20.	Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
select games, region, sport, total_medals
FROM
    (select games, noc, sport, count(medal) as total_medals
    from olympics
    group by games, noc, sport) as t1
    join 
    noc_region
    on noc_region.noc = t1.noc
WHERE
    sport = 'hockey' and region = 'india'
ORDER BY
    total_medals desc;

