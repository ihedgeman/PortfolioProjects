/****** This is the PLL 2020 player stats data
	There were 155 players on the roaster for the whole league ******/
SELECT *
  FROM [PLLproject].[dbo].[PLL2020]

--Data Cleaning
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Extracting only the player name from the player column
SELECT 
	TRIM(TRANSLATE(Player, '.0123456789|', '            ')) AS PlayerName,
	Player
FROM PLLproject..PLL2020 



--Extracting player number from the player column
SELECT
	TRIM(RIGHT(Player, 2)) AS PlayerNumber,
	Player
FROM PLLproject..PLL2020 


-- Adding the PlayerName and PlayerNumber columns 
ALTER TABLE PLL2020
ADD PlayerName Nvarchar(255);

UPDATE PLL2020
SET PlayerName = TRIM(TRANSLATE(Player, '.0123456789|', '            '))

ALTER TABLE PLL2020
ADD PlayerNumber int;

UPDATE PLL2020
SET PlayerNumber = TRIM(RIGHT(Player, 2)


--Remove %, & '-' in the Sh%, Fo%, & SV% columns 
SELECT	
		TRIM(TRANSLATE("Sh%", '%-', '  ')) AS ShotPercent,
		TRIM(TRANSLATE("FO%", '%-', '  ')) AS FOGOPercent,
		TRIM(TRANSLATE("Sv%", '%-', '  ')) AS SavePercent,
		TRIM(TRANSLATE("Sv", '%-', '  ')) AS Saves
FROM PLLproject..PLL2020 

-- Adding columns 

ALTER TABLE PLL2020 
ADD ShotPercent float;

UPDATE PLL2020
SET ShotPercent = TRIM(TRANSLATE("Sh%", '%-', '  '))

ALTER TABLE PLL2020
ADD FOGOPercent float;

UPDATE PLL2020 
SET FOGOPercent = TRIM(TRANSLATE("FO%", '%-', '  '))


ALTER TABLE PLL2020 
ADD SavePercent float;

UPDATE PLL2020
SET SavePercent = TRIM(TRANSLATE("Sv%", '%-', '  '))

ALTER TABLE PLL2020 
ADD Saves float;

UPDATE PLL2020
SET Saves = TRIM(TRANSLATE("Sv", '%-', '  '))

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Rank of the most GBs
SELECT PlayerName, GB, Pos, Club
FROM PLLproject..PLL2020 
ORDER BY GB DESC;

--Most saves 
SELECT PlayerName, Club, Saves, SavePercent
FROM PLLproject..PLL2020 
WHERE Pos = 'G'
ORDER BY Saves Desc; 


-- Who made the most 2pt Shots
SELECT "2G", PlayerName, Pos, Club
FROM PLLproject..PLL2020 
ORDER BY 1 DESC;

-- How many 2pt shots were made
SELECT SUM("2G") AS Total2PointGoals
FROM PLLproject..PLL2020 

--Percentage of a goal being a 2pt goal
SELECT SUM("2G") / SUM("1G" + "2G") AS Percent2ptGoals
FROM PLLproject..PLL2020

--Percentage of a goal being a 1pt goal
SELECT SUM("1G") / SUM("1G" + "2G") AS Percent1ptGoals
FROM PLLproject..PLL2020

-- Total clubs 
SELECT DISTINCT(club) AS TotalClubs
FROM PLLproject..PLL2020



