
--Data Cleaning Steps
--First step: do a select * , to have a look at all columns
SELECT * 
  FROM [BreakfastCereals].[dbo].[cereals]

--select the max and min values across columns to check for any outliers

--potass value has an outlier: min(potass) is -1
select min(potass), max(potass) from 
cereals;

--carbo value has  an outlier as well : min(carbo) is -1
select min(carbo), max(carbo) from 
cereals

--sugars value has an outlier : min(sugars) is -1
select min(sugars), max(sugars) from 
cereals

--We can either take the avg of the respective values of potass, sugars, carbo and then impute or just replace the outlier value by 0
--1) confirm that these columns contain outliers 
select potass, sugars,carbo
from cereals 
order by potass, sugars,carbo

--2) take avg of potass, sugars, carbo  values and then update the column containing outliers with the respective values
select avg(potass), max(potass),avg(carbo),  max(carbo), avg(sugars),max(sugars)
from cereals
 
update cereals
set potass= 
	(select avg(potass)
	from cereals)
where potass=-1

update cereals
set sugars = 
	(select avg(sugars) 
	from cereals)
where sugars=-1

update cereals
set carbo=
	(select avg(carbo) 
	from cereals)
where carbo=-1

select * from cereals

update cereals
set potass= round(potass,0)

commit;

--Checking for nulls across the all the columns of the dataset- there are no NULLS
SELECT * 
FROM cereals
where (name + 
		 mfr+
		 type + 
		 cast(calories as nvarchar(20)) +
		 cast(protein as nvarchar(20)) +
		 cast(fat as nvarchar(20)) +
		 cast(fiber as nvarchar(20)) +
		 cast(carbo as nvarchar(20)) +
		 cast(sugars as nvarchar(20)) +
		 cast(potass as nvarchar(20)) +
		 cast(shelf as nvarchar(20)) +
		 cast(weight as nvarchar(20)) +
		 cast(cups as nvarchar(20)) +
		 cast(rating as nvarchar(20)) ) is null

--Data Wrangling Steps
--Replacing 'H' by 'Hot' and 'C' by 'Cold' in the type column

select * from 
cereals

select type, case 
				when type= 'C' then 'Cold'
				when  type= 'H' then 'Hot'
				else type
				end
from 
cereals

--update the table with the new wrangled values
update cereals 
set type=case 
				when type= 'C' then 'Cold'
				when  type= 'H' then 'Hot'
				else type
				end
 
select * from 
cereals

--Similar to the Hot/Cold values, I also replaced the mfr column with actual manufacturer names, to make for convenient reading
select distinct mfr, count(mfr)
from cereals 
group by mfr

select mfr, case 
				when mfr= 'A' then 'American Home Products'
				when mfr= 'G' then 'General Mills'
				when mfr= 'K' then 'Kelloggs'
				when mfr= 'N' then 'Nabisco'
				when mfr= 'P' then 'Post'
				when mfr= 'Q' then 'Quaker Oats'
				when mfr= 'R' then 'Ralston Purina'
				else mfr
				end
from 
cereals

update cereals
set mfr=case 
				when mfr= 'A' then 'American Home Products'
				when mfr= 'G' then 'General Mills'
				when mfr= 'K' then 'Kelloggs'
				when mfr= 'N' then 'Nabisco'
				when mfr= 'P' then 'Post'
				when mfr= 'Q' then 'Quaker Oats'
				when mfr= 'R' then 'Ralston Purina'
				else mfr
				end

select * from cereals;

--Rounded rating to 2 numbers after decimal point for clean reading
select rating, round(rating,2)
from cereals;

update cereals
set rating = round(rating,2)

commit;

select * from cereals;

--Exploratory Data Analysis of this dataset

--Most number of cereals in the market come from Mfrs like General Mills and Kelloggs followed by Post
select mfr, count(mfr)
from cereals
group by mfr
order by mfr

--List the cereals by brands/mfr
select mfr,name
from cereals
order by mfr

--cereal and their rating amongst each manufacturer
select mfr,name,rating
from cereals
order by mfr, rating desc

--cereal with highest sugar content- Golden Crip/Smacks have the highest
select name , sugars
from cereals
order by sugars desc

--cereal with highest fat content- 100%Natural Bran has the highest
select name , fat
from cereals
order by fat desc

--cereal with highest preservatives - All bran has highest potassium content and Corn Flakes/Rice Krispies have high sodium content
select name , potass, sodium
from cereals
order by  potass desc, sodium desc

--cereal with high protein and vitamin - All bran has highest potassium content and Corn Flakes/Rice Krispies have high sodium content
select name , protein,vitamins
from cereals
order by  protein desc, vitamins desc 

/*
Which are the top 5 cereals, in terms of less preservatives, less sugar, and more protein/vitamins. I have excluded rating as rating is often based on sugars
and we are talking about processed sugar in the cereals so high rating does not necessaily mean healthy.
*/
select top(5)  mfr, name, vitamins, protein, potass, sugars, sodium
from cereals
order by vitamins desc, protein desc , potass , sodium,sugars

commit;

/*
Conclusion:
I can draw insights from the EDA that  Kelloggs 'Product 19' and General Mills 'Total Corn Flakes' are best choice of breakfast cereals amongst their peers; they have
least amount of sugars, reasonably less sodium, significantly less potassium and average protein.
*/