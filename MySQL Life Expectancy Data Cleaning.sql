-- World Life Expectancy Data Cleaning

SELECT * 
FROM world_life_expectancy;

-- Identifying Duplicates. Looking for multiple Years per Country. Should be 1 year for every country.
SELECT Country, Year, concat(Country,Year), count(concat(Country,Year))
FROM world_life_expectancy
group by Country, Year, concat(Country,Year)
having count(concat(Country,Year)) > 1;



-- Determining the Row ID for our duplicate rows
Select *
FROM (
	Select Row_ID, 
    concat(Country,Year), 
    Row_Number() Over( Partition by concat(Country,Year) Order By concat(Country,Year)) as Row_Num
	from world_life_expectancy
    ) as Row_table
where Row_Num > 1
;


-- Deleting 3 rows worth of duplicates. Code above may no longer work.
Delete from world_life_expectancy
where 
	Row_ID in (
Select Row_ID
FROM (
	Select Row_ID, 
    concat(Country,Year), 
    Row_Number() Over( Partition by concat(Country,Year) Order By concat(Country,Year)) as Row_Num
	from world_life_expectancy
    ) as Row_table
where Row_Num > 1
)
;



-- Finding rows where status is blank.
Select *
from world_life_expectancy
where Status = '';


-- This shows what goes in the Status Column. Used to determine what is missing in the blank Statuses.
Select distinct(Status)
from world_life_expectancy
where Status <> '';

-- Lists all Countries where Status is Developing.
Select Distinct(Country)
from world_life_expectancy
where Status = 'Developing'

-- Query does not work because we can't use a subquery in an Update statement.
Update world_life_expectancy
set Status = 'Developing'
where Country in (Select Distinct(Country)
				from world_life_expectancy
				where Status = 'Developing');
                
                
-- Have to do an inner join in order to update the status fields all at once.
Update world_life_expectancy t1
join world_life_expectancy t2
on t1.Country = t2.Country
set t1.Status = 'Developing'
where t1.Status = ''
and t2.Status <> ''
and t2.Status = 'Developing';


-- Determining what Status the USA is.
Select *
from world_life_expectancy
where Country = 'United States of America';

-- Updating the USA blank status row to be Developed status
Update world_life_expectancy t1
join world_life_expectancy t2
on t1.Country = t2.Country
set t1.Status = 'Developed'
where t1.Status = ''
and t2.Status <> ''
and t2.Status = 'Developed';


-- Find the rows where Life expectancy is blank.
SELECT * 
FROM world_life_expectancy
where `Life expectancy` = '';


SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
where `Life expectancy` = '';


-- Populate 3 tables where the rows have 2018, 2019, and 2017 data. Using this so we can take the average and put it into blank value.
SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
Round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
join world_life_expectancy t2
	on t1.Country = t2.Country
	and  t1.Year = t2.Year - 1
join world_life_expectancy t3
	on t1.Country = t3.Country
	and  t1.Year = t3.Year + 1
where t1.`Life expectancy` = ''
;


-- Updating the blank Life expectancy rows in t1 to be the average values calculated in the previous query. Can run query to see if there are any blanks.
Update world_life_expectancy t1
join world_life_expectancy t2
	on t1.Country = t2.Country
	and  t1.Year = t2.Year - 1
join world_life_expectancy t3
	on t1.Country = t3.Country
	and  t1.Year = t3.Year + 1
set t1.`Life expectancy` = Round((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = ''
;








