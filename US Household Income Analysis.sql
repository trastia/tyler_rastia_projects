select *
from us_household_income_statistics;

Select *
from us_household_income;

-- What is the sum of land and water in each state. Ordered by the state with the most land.
Select State_Name, Sum(ALand), Sum(AWater)
from us_household_income
group by State_Name
Order By Sum(ALand) desc
;


-- What is the sum of land and water in each state. Ordered by the state with the most wtaer.
Select State_Name, Sum(ALand), Sum(AWater)
from us_household_income
group by State_Name
Order By Sum(AWater) desc
;


-- Top 10 states by most land
Select State_Name, Sum(ALand), Sum(AWater)
from us_household_income
group by State_Name
Order By Sum(ALand) desc
limit 10
;


-- Top 10 states by most water
Select State_Name, Sum(ALand), Sum(AWater)
from us_household_income
group by State_Name
Order By Sum(AWater) desc
limit 10
;


-- Joining tables
Select *
from us_household_income u
join us_household_income_statistics us
on u.id = us.id
;

-- Alot of date with states not reporting their salaries so a lot of data had zeroes. Filtering this out.
Select *
from us_household_income u
inner join us_household_income_statistics us
on u.id = us.id
where Mean <> 0
;



Select u.State_Name, County,`Type`, `Primary`, Mean, Median
from us_household_income u
inner join us_household_income_statistics us
on u.id = us.id
where Mean <> 0
;


-- Sorting by average and median incomes and ordering by mean income. Can arrange by the highest or lowest.
Select u.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_household_income u
inner join us_household_income_statistics us
on u.id = us.id
where Mean <> 0
group by State_Name
order by 2 desc
limit 10
;


Select u.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_household_income u
inner join us_household_income_statistics us
on u.id = us.id
where Mean <> 0
group by State_Name
order by 3 desc
limit 10
;


-- Mean and Median salaries based on the type of area people live. Less data in areas like CPD, County, and Municipality.
Select Type, round(Avg(Mean),1), round(Avg(Median),1), count(Type)
from us_household_income u
inner join us_household_income_statistics us
on u.id = us.id
where Mean <> 0
group by Type
order by 2 desc
;



Select Type, round(Avg(Mean),1), round(Avg(Median),1), count(Type)
from us_household_income u
inner join us_household_income_statistics us
on u.id = us.id
where Mean <> 0
group by Type
order by 3 desc
;


-- Filtering out some outliers. Those Types with a low count.
Select Type, round(Avg(Mean),1), round(Avg(Median),1), count(Type)
from us_household_income u
inner join us_household_income_statistics us
on u.id = us.id
where Mean <> 0
group by Type
having Count(type) > 100
order by 2 desc
;


-- Highest mean salaries per state and city.
Select u.State_Name, City, round(avg(mean),1)
from us_household_income u
join us_household_income_statistics us
on u.id = us.id
group by State_Name, City
order by 3 desc
;