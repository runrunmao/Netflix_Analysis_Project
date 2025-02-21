-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id      VARCHAR(20),
    type         VARCHAR(10),
    title        VARCHAR(150),
    director     VARCHAR(208),
    casts        VARCHAR(1000),
    country      VARCHAR(150),
    date_added   VARCHAR(50),
    release_year INT NULL,
    rating       VARCHAR(10),
    duration     VARCHAR(15),
    listed_in    VARCHAR(100),
    description  VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT(*) AS total_content FROM netflix;

SELECT DISTINCT type FROM netflix;

-- Business Problems

-- 1. Count the Number of Movies vs TV Shows
SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY type;

-- 2. Find the Most Common Rating for Movies and TV Shows
WITH RankedRatings AS (
	SELECT 
		type, 
		rating, 
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as rnk
	FROM netflix
	GROUP BY type, rating
)
SELECT type, rating AS most_common_rating
FROM RankedRatings
WHERE rnk = 1;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT title
FROM netflix
WHERE type = 'Movie' AND release_year = 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT new_country, COUNT(*) AS content_count
FROM(
	SELECT UNNEST(string_to_array(country, ', ')) AS new_country
	FROM netflix
	WHERE country IS NOT NULL
) AS country_split
GROUP BY new_country
ORDER BY content_count DESC
LIMIT 5;

-- 5. Identify the Longest Movie
SELECT title, duration
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;

-- 6. Find Content Added in the Last 5 Years
SELECT title, type, date_added
FROM netflix
WHERE date_added IS NOT NULL
AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY date_added DESC;

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT title, type, director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. List All TV Shows with More Than 5 Seasons
SELECT title, duration
FROM netflix
WHERE type = 'TV Show'
AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;

-- 9. Count the Number of Content Items in Each Genre
SELECT genre, COUNT(*) AS content_count
FROM (
    SELECT UNNEST(string_to_array(listed_in, ', ')) AS genre
    FROM netflix
    WHERE listed_in IS NOT NULL
) AS genre_split
GROUP BY genre
ORDER BY content_count DESC;

-- Find each year and the average number of content released in India on netflix. 
-- Return top 5 year with highest avg content release!
WITH IndiaTotal AS (
    SELECT COUNT(show_id) AS total_india_releases
    FROM netflix
    WHERE country LIKE '%India%'
)
SELECT 
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric / (SELECT total_india_releases FROM IndiaTotal) * 100, 2
    ) AS avg_release
FROM netflix
WHERE country LIKE '%India%' AND release_year IS NOT NULL
GROUP BY release_year
ORDER BY avg_release DESC
LIMIT 5;

-- 11. List All Movies that are Documentaries
SELECT title, type, listed_in
FROM netflix
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';

-- 12. Find All Content Without a Director
SELECT *
FROM netflix
WHERE director IS NULL OR director = '';

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT COUNT(*) AS total_movies
FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND type = 'Movie'
AND EXTRACT(YEAR FROM CURRENT_DATE) - release_year <= 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
WITH IndiaActor AS (
	SELECT UNNEST(string_to_array(casts, ',')) AS actor 
	FROM netflix
	WHERE country LIKE '%India%'
	AND casts IS NOT NULL
	AND type = 'Movie'
)
SELECT actor, COUNT(*) AS movie_count
FROM IndiaActor
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    CASE 
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Violent Content'
        ELSE 'Non-Violent Content'
    END AS category,
    COUNT(*) AS total_count
FROM netflix
GROUP BY category;



