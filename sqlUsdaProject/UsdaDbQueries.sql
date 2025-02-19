-- Creating Tables one time run instruction

/*CREATE TABLE cheese_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Domain TEXT,
    Value INTEGER
);

CREATE TABLE honey_production (
    Year INTEGER,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Value INTEGER
);

CREATE TABLE milk_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Domain TEXT,
    Value INTEGER
);

CREATE TABLE coffee_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Value INTEGER
);

CREATE TABLE egg_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Value INTEGER
);

CREATE TABLE state_lookup (
    State TEXT,
    State_ANSI INTEGER
);

CREATE TABLE yogurt_production (
    Year INTEGER,
    Period TEXT,
    Geo_Level TEXT,
    State_ANSI INTEGER,
    Commodity_ID INTEGER,
    Domain TEXT,
    Value INTEGER
);*/

-- Viewing the result
SELECT TOP (1000) *
FROM [usAgricultureProject].[dbo].[coffee_production]
SELECT TOP (1000) *
FROM [usAgricultureProject].[dbo].[milk_production]

-- Total milk production for the year 2023
SELECT SUM(M.Value) as Total_Milk_Production
from usAgricultureProject.dbo.milk_production as M
where M.Year = 2023;

-- Total coffee production data for the year 2015
SELECT SUM(CO.Value) as Total_Coffee_Production
FROM usAgricultureProject.dbo.coffee_production as CO
where CO.Year = 2015;

-- Average honey production for the year 2022
SELECT AVG(H.Value) as Average_Honey_Production
FROM usAgricultureProject.dbo.honey_production as H
where H.Year = 2022;

-- State names with their corresponding ANSI codes from the state_lookup table
SELECT ST.State_ANSI ,ST.State
FROM usAgricultureProject.dbo.state_lookup ST
-- Iowa Specifically (uncomment this)
--WHERE ST.State = 'Iowa';

-- Highest yogurt production value for the year 2022
SELECT MAX(P.Value) MAX_YOGHURT_PRODUCTION_2022
FROM usAgricultureProject.DBO.yogurt_production P
WHERE P.Year = 2022;

-- States where both honey and milk were produced in 2022
SELECT*
FROM usAgricultureProject.DBO.state_lookup SL
LEFT JOIN usAgricultureProject.DBO.honey_production HP
ON SL.State_ANSI  = HP.State_ANSI
LEFT JOIN usAgricultureProject.DBO.milk_production MP
ON SL.State_ANSI = MP.State_ANSI
WHERE HP.Year = 2022 
 AND MP.Year = 2022;
-- Checking if New Mexico produced both honey and milk in 2022 (uncomment this)
--AND SL.State = 'NEW MEXICO';

-- The total yogurt production for states that also produced cheese in 2022
SELECT
 SUM(YP.Value) TOTAL_YOGHURT_PRODUCTION
FROM usAgricultureProject.DBO.yogurt_production YP
WHERE YP.Year = '2022'
 AND YP.State_ANSI IN (
  SELECT DISTINCT
   CP.State_ANSI
  FROM usAgricultureProject.DBO.cheese_production CP
  WHERE CP.Year = '2022'
 );

-- The Cheese Department wants to focus their marketing efforts on states had cheese production greater than 100 million in April 2023 
SELECT L.State,L.State_ANSI
FROM usAgricultureProject.dbo.cheese_production P
INNER JOIN usAgricultureProject.dbo.state_lookup L
ON P.State_ANSI = L.State_ANSI
WHERE P.Value > 100000000
 AND P.Period = 'APR'
 AND P.Year = 2023;

-- For a cross-commodity report, listing all states with their cheese production values even if they didn’t produce any in April of 2023
SELECT L.State, SUM(P.Value) as TOTAL_CHEESE_PRODUCTION
FROM usAgricultureProject.dbo.state_lookup L
LEFT JOIN usAgricultureProject.dbo.cheese_production P
ON L.State_ANSI = P.State_ANSI
WHERE P.Period = 'APR'
 AND P.Year = 2023
GROUP BY L.State

-- Finding out how many states are missing from milk_production
SELECT COUNT(DISTINCT S.State) COUNT_OF_MISSING_MILK_PRODUCTION_STATE_IN_2023
FROM usAgricultureProject.DBO.state_lookup S
LEFT JOIN usAgricultureProject.DBO.milk_production P
ON S.State_ANSI = P.State_ANSI
 AND P.Year = 2023
WHERE P.State_ANSI IS NULL;

--The average coffee production for all years where the honey production exceeded 1 million.
SELECT AVG(P.Value) AVERAGE_COFFEE_PRODUCTION
FROM usAgricultureProject.DBO.coffee_production P
WHERE P.Year IN (
 SELECT
  HP.Year
 FROM usAgricultureProject.dbo.honey_production HP
 WHERE HP.Value > 1000000
);