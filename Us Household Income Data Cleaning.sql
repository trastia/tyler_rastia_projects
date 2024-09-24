# US Household Income Data Cleaning

select *
from us_household_income_statistics;

Select *
from us_household_income;

Select Count(*)
from us_household_income
;

-- Update incorrectly labeled ID column.
Alter table householdincome.us_household_income_statistics rename column `ï»¿id` to `id`;

-- Determining if there are duplicate id's
Select id, count(id)
from us_household_income
group by ID
having count(id) > 1
;


-- Identifying the rows that are duplicates. Those that are the second row. This is used as a subquery for the below statement.
select *
from(
Select row_id, id,
row_number() over(partition by id order by id) row_num
from us_household_income
) duplicates
where row_num > 1
;


-- Deleting duplicate rows. Can re-run query that counts the duplicate rows above and there shouldn't be any.
delete from us_household_income
where row_id in (
select row_id
from(
Select row_id, id,
row_number() over(partition by id order by id) row_num
from us_household_income
) duplicates
where row_num > 1)
;


-- Finding any duplicates for this table. Should be none.
Select id, count(id)
from us_household_income_statistics
group by ID
having count(id) > 1
;


-- Identifying misspelled states. **Fun Fact** MySQL is auto correcting the lower case alabama name and grouping it with the 
-- capitalized Alabama naming. As long as it shows in the group by, it should be fine. Can change anyways.
select State_Name, Count(State_Name)
from us_household_income
group by State_Name
having Count(State_Name) = 1
;


-- Updating the misspelled Georgia State Name.
Update us_household_income
set State_Name = 'Georgia'
where State_Name = 'georia'
;


-- Updating mispelled Alabama state name.
Update us_household_income
set State_Name = 'Alabama'
where State_Name = 'alabama'
;

-- Identifying if there are incorrect state abbreviations
Select Distinct State_ab
from us_household_income
order by 1
;


-- Identifying blank data in the Place column.
Select *
from us_household_income
where place = ''
;



-- Determining if missing Place value should have the same value as those in Autauga County.
Select *
from us_household_income
where County = 'Autauga County'
order by 1
;


-- Updating missing Place value to have a value and not be blank.
Update us_household_income
set Place = 'Autaugaville'
where County = 'Autauga County'
and City = 'Vinemont'
;


-- Seeing if there is incorrect data in Type column
Select Type, Count(Type)
from us_household_income
group by Type
;


-- Updating boroughs to be borough to match the rest of the data.
update us_household_income
set type = 'Borough'
where type = 'Boroughs'
;



select ALand, AWater
from us_household_income
where (AWater = 0 or AWater = '' or AWater is Null)
and (ALand = 0 or ALand = '' or ALand is Null)
;