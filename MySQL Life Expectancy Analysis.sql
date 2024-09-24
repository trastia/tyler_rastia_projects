-- World Life Expectancy Data Analysis


Select *
from world_life_expectancy
;


-- Min/Max Liufe Expectancy and the strides each country has made over 15 year span.
Select Country, min(`Life expectancy`), max(`Life expectancy`), round(max(`Life expectancy`) - min(`Life expectancy`),1) as Life_Increase_15_Years
from world_life_expectancy
group by Country
having min(`Life expectancy`) <> 0
and max(`Life expectancy`) <> 0
Order by Life_Increase_15_Years desc
;


-- Average Life expantancy accross the world per year.
Select Year, Round(Avg(`Life expectancy`),2)
from world_life_expectancy
where `Life expectancy` <> 0
and `Life expectancy` <> 0
Group by Year
Order by Year
;


-- Correlation between life expectancy and other columns. Higher GDP typically has higher life expectancy.
Select Country, round(avg(`Life expectancy`),1) as Avg_Life_Exp, round(avg(GDP),1) as Avg_GDP 
from world_life_expectancy
Group by Country
having Avg_Life_Exp > 0
and Avg_GDP > 0
order by Avg_GDP desc
;


-- High GPD has a higher life expectancy. Lower GDP has a lower life expectancy. 
-- You could do a similar correlation with Life expectancy and other columns to find their correlation.
Select
Sum(case when GDP >= 1500 then 1 else 0 end) High_GDP_Count,
Avg(case when GDP >= 1500 then `Life expectancy` else Null end) High_GDP_Life_Expectancy,
Sum(case when GDP <= 1500 then 1 else 0 end) Low_GDP_Count,
Avg(case when GDP <= 1500 then `Life expectancy` else Null end) Low_GDP_Life_Expectancy
from world_life_expectancy
;


-- Avg Life Expectancy in developing vs developed countries.
Select Status, round(Avg(`Life expectancy`),1)
from world_life_expectancy
group by Status
;


-- How many developed vs developing countries to see if averages are swayed by the counts.
Select Status, count(distinct Country)
from world_life_expectancy
group by Status
;


-- Combining 2 querys above for developing and developed countries.
Select Status, count(distinct Country), round(Avg(`Life expectancy`),1)
from world_life_expectancy
group by Status
;


-- Seeing the correlation between BMI and Avg Life Expectancy.
Select Country, round(Avg(`Life expectancy`),1) as Avg_Life_Exp, round(avg(BMI), 1) as Avg_BMI
from world_life_expectancy
group by Country
having Avg_Life_Exp > 0
and Avg_BMI > 0
order by Avg_BMI
;


-- Rolling total. Adding each line of adult mortality together for each year per country.
Select Country, Year, `Life expectancy`, `Adult Mortality`, 
Sum(`Adult Mortality`) over(Partition by Country Order by Year) as Rolling_Total
from world_life_expectancy
Where Country Like '%United States%'
;