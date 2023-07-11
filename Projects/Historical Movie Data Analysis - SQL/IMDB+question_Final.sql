USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    COUNT(*)
FROM
    movie;
-- 7997
SELECT 
    COUNT(id)
FROM
    movie;
-- 7997
SELECT 
    COUNT(*)
FROM
    genre;
-- '14662'
SELECT 
    COUNT(movie_id)
FROM
    genre;
-- '14662'
SELECT 
    COUNT(*)
FROM
    director_mapping;
-- '3867'
SELECT 
    COUNT(movie_id)
FROM
    director_mapping;
-- '3867'
SELECT 
    COUNT(*)
FROM
    names;
-- '25735'
SELECT 
    COUNT(id)
FROM
    names;
-- '25735'
SELECT 
    COUNT(*)
FROM
    ratings;
-- '7997'
SELECT 
    COUNT(movie_id)
FROM
    ratings;
-- '7997'
SELECT 
    COUNT(*)
FROM
    role_mapping;
-- '15615'
SELECT 
    COUNT(movie_id)
FROM
    role_mapping; 
-- '15615'



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- 4 columns have null values - country, worlwide_gross_income,languages, production_company
SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS ID_null,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_null,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_null,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_null,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_null,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_null,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worldwide_null,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_null,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_null
FROM
    movie;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Year Wise -- 
SELECT 
    year 'Year', COUNT(id) 'number_of_movies'
FROM
    movie
GROUP BY year
ORDER BY year;

-- Month Wise--
SELECT 
    MONTH(date_published) 'month_num',
    COUNT(id) 'number_of_movies'
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);





/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- 1059 movies released in either USA or India and in the year 2019

SELECT 
    COUNT(id) Total_Number_of_Movies
FROM
    movie
WHERE
    (country LIKE '%USA%'
        OR country LIKE '%India%')
        AND year = 2019;









/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT
    (genre)
FROM
    genre;
/* 
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/










/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Drama has the highest num of movies with 4285 releases
-- Type your code below:
SELECT 
    g.genre, COUNT(m.id) AS Total_Number_of_Movies
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC;









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- '3289' movies of single genre
-- Type your code below:
With Genre_count as(
SELECT 
    movie_id, COUNT(genre) AS num_of_movies
FROM
    genre
GROUP BY movie_id
HAVING COUNT(genre) = 1)

SELECT 
    COUNT(movie_id) AS 'No of movies with 1 genre'
FROM
    Genre_count;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    genre, ROUND(AVG(duration),2) 'avg_duration'
FROM
    genre AS g
        INNER JOIN
    movie AS m ON g.movie_id = m.id
GROUP BY genre;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
-- Thriller is 3rd in rank


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH Genre_Rank_By_Movie_Count AS (
SELECT 
    g.genre as genre , COUNT(m.id) as movie_count,
    rank() over( order by COUNT(m.id) desc) as genre_rank
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY g.genre
)
SELECT 
    *
FROM
    Genre_Rank_By_Movie_Count
WHERE
    genre = 'Thriller'
    ;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) max_median_rating
FROM
    ratings;

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH Movie_Rank_Based_On_Avg_Rating AS (
SELECT 
    m.title, r.avg_rating, 
	dense_rank () over ( order by r.avg_rating desc) as movie_rank
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
    )
    SELECT 
    *
FROM
    Movie_Rank_Based_On_Avg_Rating
WHERE
    movie_rank <= 10
    ;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, COUNT(movie_id) AS movie_Count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;









/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
-- Dream Warrior Pictures and National Theater Live

SELECT m.production_company,
       Count(m.id)                    'movie_count',
       Dense_rank()
         OVER (
           ORDER BY Count(m.id) DESC) AS prod_company_rank
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  r.avg_rating > 8 and m.production_company IS NOT NULL
GROUP  BY m.production_company;  










-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    g.genre, COUNT(m.id) 'movie_count'
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    MONTH(m.date_published) = 3
        AND m.country = 'USA'
        AND m.year = '2017'
        AND r.total_votes > 1000
GROUP BY genre;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
    m.title, r.avg_rating, g.genre
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.title LIKE 'The%' AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
-- 361 movies is the answer
SELECT 
    r.median_rating, COUNT(id) AS Total_Movie_Count
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8
GROUP BY r.median_rating; 


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
-- Yes. Germany gets more votes in total, even scores higher on avg votes per mov
SELECT 
    m.country,
    SUM(r.total_votes) 'Total Votes',
    ROUND(AVG(r.total_votes), 2) 'Avg Votes'
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.country LIKE 'Germany'
        OR m.country LIKE 'Italy'
GROUP BY m.country;


/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;








/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Tricky one
-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

WITH top3_genre_above8_ratings
     AS (SELECT g.genre                              AS genre,
                Count(g.movie_id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(g.movie_id) DESC) AS genre_rank
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
                INNER JOIN ratings r
                        ON r.movie_id = m.id
         WHERE  avg_rating > 8
         GROUP  BY g.genre),
     top_director
     AS (SELECT n.NAME,
                Count(d.movie_id)                    AS movie_count,
                Dense_rank()
                  OVER (
                    ORDER BY Count(d.movie_id) DESC) AS director_rank
         FROM   movie mv
                INNER JOIN director_mapping d
                        ON mv.id = d.movie_id
                INNER JOIN ratings rt
                        ON mv.id = rt.movie_id
                INNER JOIN names n
                        ON d.name_id = n.id
                INNER JOIN genre gn
                        ON gn.movie_id = mv.id
         WHERE  rt.avg_rating > 8
                AND gn.genre IN (SELECT genre
                                 FROM   top3_genre_above8_ratings
                                 WHERE  genre_rank <= 3)
         GROUP  BY n.NAME
         ORDER  BY movie_count DESC)
SELECT NAME AS director_name,
       movie_count, director_rank
FROM   top_director
WHERE  director_rank <= 3
LIMIT 3; 


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Mammootty with 8 and Mohanlal with 5

SELECT 
    n.name 'actor_name', COUNT(m.id) 'movie_count'
FROM
    movie AS m
        INNER JOIN
    role_mapping AS rm ON m.id = rm.movie_id
        INNER JOIN
    names AS n ON rm.name_id = n.id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    r.median_rating >= 8
        AND rm.category = 'actor'
GROUP BY n.name
ORDER BY COUNT(m.id) DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Marvel, 20th Century Fox, Warner Bros are the top 3

WITH production_company_rank
     AS (SELECT m.production_company,
                Sum(total_votes)                    AS vote_count,
                Dense_rank()
                  OVER (
                    ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         GROUP  BY m.production_company
         ORDER  BY vote_count DESC)
SELECT *
FROM   production_company_rank
WHERE  prod_comp_rank <= 3; 



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Top actor is vijay sethupathi

SELECT n.NAME                                                'actor_name',
       Sum(r.total_votes)                                    'total_votes',
       Count(m.id)                                           'movie_count',
       Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes)'actor_avg_rating',
       Dense_rank()
         OVER(
           ORDER BY Sum(r.avg_rating*r.total_votes)/Sum(r.total_votes) DESC, SUM(r.total_votes) DESC)
                                                             'actor_rank'
FROM   movie AS m
       INNER JOIN role_mapping AS rm
               ON m.id = rm.movie_id
       INNER JOIN names AS n
               ON rm.name_id = n.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  rm.category = 'actor'
       AND m.country LIKE'%India%'
GROUP  BY n.NAME
HAVING Count(m.id) >= 5; 

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Taapsee Pannu

WITH top_actress_hindi_india
     AS (SELECT n.NAME
                AS
                actress_name
                   ,
                Sum(r.total_votes)
                   AS total_votes,
                Count(m.id)
                AS
                   movie_count,
                Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2)
                AS
                actress_avg_rating,
                Dense_rank()
                  OVER (
                    ORDER BY
                  Round(Sum(r.avg_rating*r.total_votes)/Sum(r.total_votes), 2)
                  DESC)
                                                                      AS
                actress_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN role_mapping rm
                        ON m.id = rm.movie_id
                INNER JOIN names n
                        ON rm.name_id = n.id
         WHERE  rm.category = 'actress'
                AND m.country = 'India'
                AND m.languages LIKE '%Hindi%'
         GROUP  BY n.NAME
         HAVING Count(m.id) >= 3)
SELECT *
FROM   top_actress_hindi_india
WHERE  actress_rank <= 5; 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT 
    m.title,
    r.avg_rating,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS 'Rating'
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    genre = 'Thriller';



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:
-- running_total_duration???
-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
       Round(Avg(duration), 2)                      AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding) AS running_total_duration,
       Avg(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS 10 preceding)        AS moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- There are some movies with INR. Need to convert them to $
SELECT 
    *
FROM
    movie
WHERE
    worlwide_gross_income LIKE '%INR%';
-- The Villain, Shatamanam Bhavati, Winner
-- used IUSD = 82 INR
-- Update these 3 records with $ values

UPDATE movie 
SET 
    worlwide_gross_income = '$ 3048781'
WHERE
    id = 'tt6568474';
UPDATE movie 
SET 
    worlwide_gross_income = '$ 15853658'
WHERE
    id = 'tt6203302';
UPDATE movie 
SET 
    worlwide_gross_income = '$ 6469512'
WHERE
    id = 'tt6417204';


WITH top_3_genre_by_moviecount
     AS (SELECT g.genre                        AS gnere,
                Count(m.id),
                Dense_rank ()
                  OVER (
                    ORDER BY Count(m.id) DESC) AS genre_rank
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
         GROUP  BY g.genre
         ORDER  BY Count(m.id) DESC),
     top5_movie_rank_by_income
     AS (SELECT gn.genre,
                year,
                mv.title                                     AS movie_name,
                mv.worlwide_gross_income,
                Dense_rank()
                  OVER (
                    partition BY year
                    ORDER BY (Cast(Substring(worlwide_gross_income, 3, Length(
                  worlwide_gross_income)) AS DOUBLE)) DESC ) AS movie_rank
         FROM   movie mv
                INNER JOIN genre gn
                        ON mv.id = gn.movie_id
         WHERE  gn.genre IN (SELECT gnere
                             FROM   top_3_genre_by_moviecount
                             WHERE  genre_rank <= 3))
SELECT *
FROM   top5_movie_rank_by_income
WHERE  movie_rank <= 5; 



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Star Cinema and 20th Century Fox
WITH production_company_rank as (
SELECT 
    m.production_company, 
    COUNT(m.id) AS movie_count, 
    rank() over (order by count(m.id) desc) as prod_comp_rank
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
		POSITION(',' IN m.languages)>0
        AND m.production_company IS NOT NULL
        AND r.median_rating >= 8
GROUP BY m.production_company
ORDER BY movie_count DESC
)
SELECT 
    *
FROM
    production_company_rank
WHERE
    prod_comp_rank <= 2;





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Tricky for choosing top3!
-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Parvathy, Susan, Amanda, Denise
WITH Actress_Superhit_MovieCount_Drama_Rank as (
SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    Round(Sum(r.avg_rating*r.total_votes)/Sum(r.total_votes),2) AS actress_avg_rating,
	dense_rank () over (order by count(m.id) desc ) as actress_rank
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    role_mapping rm ON m.id = rm.movie_id
        INNER JOIN
    names n ON rm.name_id = n.id
        INNER JOIN
    genre g ON m.id = g.movie_id
WHERE
    rm.category = 'actress'
        AND r.avg_rating > 8
        AND g.genre = 'Drama'
GROUP BY n.name
)
Select * from Actress_Superhit_MovieCount_Drama_Rank where actress_rank <=3 ;



-- Tricky - column 'Average inter movie duration in days'
/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH movie_date_info AS
(
           SELECT     dm.name_id,
                      dm.movie_id,
                      m.date_published,
                      Lead (date_published,1) OVER (partition BY dm.name_id ORDER BY date_published, dm.movie_id) AS next_movie_date
           FROM       movie                                                                                       AS m
           INNER JOIN director_mapping                                                                            AS dm
           ON         m.id = dm.movie_id
           INNER JOIN names AS n
           ON         n.id =dm.name_id), date_difference AS
(
       SELECT *,
              Datediff(next_movie_date, date_published ) 'Diff'
       FROM   movie_date_info) , avg_inter_days AS
(
         SELECT   name_id,
                  Avg(diff) AS avg_inter_movie_days
         FROM     date_difference
         GROUP BY name_id), top_result AS
(
           SELECT     dm.name_id                                          AS director_id,
                      n.NAME                                              AS director_name,
                      Count(dm.movie_id)                                  AS number_of_movies,
                      Round(avg_inter_movie_days)                         AS avg_inter_movie_days,
                      Round(Avg(r.avg_rating))                            AS avg_rating,
                      Round(Sum(r.total_votes))                           AS total_votes,
                      Round(Min(r.avg_rating))                            AS min_rating,
                      Round(Max(r.avg_rating))                            AS max_rating,
                      Row_number() OVER(ORDER BY Count(dm.movie_id) DESC) AS director_row_rank
           FROM       names                                               AS n
           INNER JOIN director_mapping                                    AS dm
           ON         n.id=dm.name_id
           INNER JOIN ratings AS r
           ON         dm.movie_id=r.movie_id
           INNER JOIN movie AS m
           ON         m.id=r.movie_id
           INNER JOIN avg_inter_days AS a
           ON         a.name_id=dm.name_id
           GROUP BY   director_id)
SELECT *
FROM   top_result LIMIT 9;