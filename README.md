# 📌 Netflix Content Analysis Using SQL

## 🔍 Project Overview
This project analyzes Netflix's content catalog using SQL to extract valuable insights about content distribution, genre popularity, country-wise contributions, and industry trends.

## 📊 Key Business Questions Answered:

• How many Movies vs. TV Shows are on Netflix?

• What are the most popular genres and ratings?

• Which countries produce the most content?

• Who are the most featured actors in Netflix's catalog?

• How much violent content exists on Netflix?

• What are the content trends in United States over the last decade?

## 📂 Technologies Used:

• Database: PostgreSQL

• Dataset: Netflix Movies & TV Shows

• SQL Concepts:

	• Aggregation (COUNT, AVG, SUM)
 	
	• Window Functions (RANK, PARTITION BY)
 
	• String Manipulation (SPLIT_PART, STRING_TO_ARRAY)
 
	• Conditional Categorization (CASE WHEN)
 
	• Subqueries & Common Table Expressions (CTE)

## 📝 SQL Queries & Insights

1️⃣ Count the Number of Movies vs. TV Shows

    SELECT type, COUNT(*) AS total_count
    FROM netflix
    GROUP BY type;

✔️ Findings: 

Movies account for ~70% of Netflix’s content, while TV Shows make up ~30%.

📌 Business Insight: 

Netflix invests more in movies than TV Shows, likely due to lower production costs and broader audience reach.

2️⃣ Most Common Ratings for Movies & TV Shows

    WITH RankedRatings AS (
        SELECT type, rating,
               RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
         FROM netflix
        GROUP BY type, rating
    )
    SELECT type, rating AS most_common_rating
    FROM RankedRatings
    WHERE rnk = 1;

✔️ Findings:

Movies: Most common rating is TV-MA (Mature Audiences).

TV Shows: Most common rating is also TV-MA.

📌 Business Insight: 

Netflix’s library skews towards mature content, making parental controls essential.

3️⃣ Find the Top 5 Countries Producing the Most Netflix Content

    SELECT new_country, COUNT(*) AS content_count
    FROM (
        SELECT UNNEST(string_to_array(country, ', ')) AS new_country
        FROM netflix
        WHERE country IS NOT NULL
    ) AS country_split
    GROUP BY new_country
    ORDER BY content_count DESC
    LIMIT 5;

✔️ Findings:

The United States produces the most Netflix content, followed by India, the United Kingdom, Canada, and France. 

📌 Business Insight: 

Netflix’s focus on US-produced content aligns with its largest subscriber base being in North America.

4️⃣ Find the Longest Movie on Netflix

    SELECT title, duration
    FROM netflix
    WHERE type = 'Movie'
    ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
    LIMIT 1;

✔️ Findings:

The longest movie available on Netflix is over 200 minutes long.

📌 Business Insight: 

While most movies are 90-120 minutes long, a niche demand exists for extended storytelling.

5️⃣ Content Growth Over the Last 5 Years

    SELECT title, type, date_added
    FROM netflix
    WHERE date_added IS NOT NULL
    AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
    ORDER BY date_added DESC;

✔️ Findings:

The highest increase in Netflix content occurred in 2020-2021, likely due to the COVID-19 pandemic.

📌 Business Insight: 

Netflix expanded its library significantly to meet increased streaming demand during global lockdowns.

6️⃣ Find the Top 5 Years with the Most US Content

    WITH UnitedStatesTotal AS (
        SELECT COUNT(show_id) AS total_us_releases
        FROM netflix
        WHERE country LIKE '%United States%'
    )
    SELECT
        release_year,
        COUNT(show_id) AS total_release,
        ROUND(
            COUNT(show_id)::numeric / (SELECT total_us_releases FROM UnitedStatesTotal) * 100, 2
        ) AS avg_release
    FROM netflix
    WHERE country LIKE '%United States%' AND release_year IS NOT NULL
    GROUP BY release_year
    ORDER BY avg_release DESC
    LIMIT 5;

✔️ Findings:

Netflix released the most US-based content in 2021 and 2020.

📌 Business Insight: 

The rise in US-produced content aligns with Netflix's focus on regional production strategies.

7️⃣ Categorization of Violent vs. Non-Violent Content
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Violent Content'
            ELSE 'Non-Violent Content'
        END AS category,
        COUNT(*) AS total_count
    FROM netflix
    GROUP BY category;

✔️ Findings:

A significant portion of Netflix content contains themes of "Kill" or "Violence".

📌 Business Insight: 

Netflix should strengthen parental controls and expand family-friendly content offerings.

## 🚀 Key Takeaways

✔️ Netflix’s library is movie-dominated (~70%), with a focus on mature content (TV-MA rated).

✔️ Hollywood A-list actors & US-based content are central to Netflix's strategy.

✔️ Netflix’s content surged during COVID-19 (2020-2021), highlighting pandemic-driven demand.

✔️ Dramas and Comedies dominate, while violent content remains prevalen

### 🔹 Feedback is welcome! Comment, suggest, or connect with me.
 
