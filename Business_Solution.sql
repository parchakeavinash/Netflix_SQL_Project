select * from netflix;

-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems
-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY 1

-- 2. Find the most common rating for movies and TV shows

WITH RatingRank AS (
    SELECT type,
           rating,
           COUNT(*) AS rating_count,
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
)
SELECT type,
       rating
FROM RatingRank
WHERE ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE type = 'Movie' and release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix

select 
	unnest(string_to_array(country,',')) as country,
	count(*) as total_content
from netflix
group by 1
order by count(*) desc
limit 5;

-- seconds methods using subquery
select * 
from
(
select 
	unnest(string_to_array(country,',')) as country,
	count(*) as total_content
from netflix
group by 1)
where country is not null
order by total_content desc
limit 5;

-- 5. Identify the longest movie

select * from netflix
where type = 'Movie' and duration is not null
order by SPLIT_PART(duration,' ',1)::int desc;
	

-- 6. Find content added in the last 5 years

select *
from netflix
where TO_DATE(date_added,'Month DD,YYYY') >= current_date - interval '5 years';
-- to_date function convert string date into date type like 'month DD, YYYY' int 'january 01, 2021'

-- select *
-- from netflix
-- where date_added >= current_date - interval '5 years'; 
-- above qeury will not work here because data_added table has string records we have to define that format in order to get result

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select *
from
(
select *,
	unnest(string_to_array(director,',')) as director_name
from netflix)
where director_name = 'Rajiv Chilaka'

-- total_movie of Rajiv chilka is 22  correct query

select count(*)
from netflix
where director = 'Rajiv Chilaka';

-- from above query it shows 19 count

-- 8. List all TV shows with more than 5 seasons
select count(*) 
from netflix
where type = 'TV Show'
		and SPLIT_PART(duration,' ',1)::int >5;
		
	
-- 9. Count the number of content items in each genre
		
select 
	unnest(string_to_array(listed_in,',')) as genre,
	count(*) as total_content
from netflix
group by 1
order by 2 desc;

-- 10. Find all content without a director
select * 
from netflix
where director is null;

-- 11. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where 
		casts  like '%Salman Khan%'
		and 
		release_year > extract(year from current_date) - 10;
		
-- concept practice	
select 
	extract(year from to_date(date_added,'Month DD, YYYY')) as year,
	extract(month from to_date(date_added,'Month DD, YYYY')) as year,
	extract(day from to_date(date_added,'Month DD, YYYY')) as year
from netflix;


-- 12. Find the top 10 actors who have appeared in the highest number of movies produced in India.
-- limit 10
-- group by india
-- where country = india
select 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	count(*) 
from netflix
where country = 'India'
group by 1	
order by 2 desc
limit 10;

-- 13. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !

-- total_content = count(*) by yearly / count(*) wherer country = 'india'

select 
	extract(year from to_date(date_added,'Month DD, YYYY')) as year,
	count(*) as yearly_Content,
	round(count(*)::numeric / (select count(*) from netflix where country= 'India')::numeric* 100,2) as average_content_per_year
from netflix
where country ='India'
group by 1
order by 3 desc;



select * from netflix;