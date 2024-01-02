USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
 
-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT TABLE_NAME AS Table_Name, -- Selecting each table of the schema.
	   TABLE_ROWS AS Number_of_rows  -- Selecting the total number of rows in each table of the schema.
FROM information_schema.TABLES
WHERE table_schema = 'imdb';


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

/* Where ever the entry is null it will return 1 otherwise 0 and sum of all such 1's 
will give the total number of null values in that column. */

SELECT
  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null, 
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null, 
  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null,
  SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null,
  SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null,
  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null,
  SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null,
  SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null,
  SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null
FROM movie;

-- Country, Worlwide_gross_income, Languages and Production_company are the columns having null values


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

SELECT YEAR(date_published) AS Year, 
	   count(id) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- 2017 has the highest number of movies released.

SELECT MONTH(date_published) AS month_num, 
	   count(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY number_of_movies DESC;

-- Month of March has the highest number of movies released.


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT count(DISTINCT id) AS number_of_movies
FROM movie
WHERE country LIKE '%USA%' OR country LIKE '%India%' 
GROUP BY year
HAVING year = '2019';

-- 1059 movies were produced in the USA or India in the year 2019


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre 
FROM genre;

/* Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-Fi, Crime, Mystery
are the main movie genres found from the given dataset */

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, count(id) AS number_of_movies
FROM genre g
INNER JOIN movie m
	ON m.id = g.movie_id
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1 ;

-- Drama genre has the highest number of movies produced


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH count_genre AS
(
SELECT movie_id, 
	   count(genre) AS genre_count
FROM genre
GROUP BY movie_id
)
SELECT count(movie_id) AS number_of_movies
FROM count_genre
WHERE genre_count = 1;

-- There are 3289 movies belonging to only one genre


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

SELECT g.genre, 
	   ROUND(AVG(m.duration), 2) AS avg_duration
FROM genre g
INNER JOIN movie m
	ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC;

-- Action genre has the highest average duration of the movies


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH Thriller_rank AS
(
SELECT g.genre, 
	   count(m.id) AS movie_count,
	   RANK() OVER(ORDER BY count(m.id) DESC) AS Genre_Rank
FROM genre g
INNER JOIN movie m
	ON g.movie_id = m.id
GROUP BY genre
)
SELECT *
FROM Thriller_rank
WHERE genre = 'thriller';

-- The rank of Thriller genre in terms of number of movies produced is 3


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

SELECT MIN(avg_rating) AS min_avg_rating,
	   MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM ratings;
    

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

WITH movie_rank_table AS -- created a CTE as movie_rank_table
(
SELECT title, 
	   avg_rating,
	   ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM ratings r
INNER JOIN movie m
	ON r.movie_id = m.id
)
SELECT *
FROM movie_rank_table
WHERE movie_rank <= 10;

-- The highest average rating is 10 for the movie Kirket having rank 1


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

SELECT median_rating, 
	   count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;


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

/* creating a CTE  as production_ranking which ranks the production companies with respect to movie count
having average rating greater than 8 */

WITH production_ranking AS 
(
SELECT production_company, 
	   count(id) AS movie_count,
	   RANK() OVER(ORDER BY count(id) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY movie_count DESC
)
SELECT *
FROM production_ranking
WHERE prod_company_rank = 1;

/* Rank is used and hence there are two outputs having the same rank as 1. 
Dream warrior pictures and national theatre live have the same movie count having average rating greater than 8 */

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

SELECT genre,
	   count(id) AS movie_count
FROM movie m
INNER JOIN genre g
	ON m.id = g.movie_id
INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE MONTH(date_published) = 3 AND
	  YEAR(date_published) = 2017 AND
      country LIKE '%USA%' AND
      total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- Drama genre has the highest number of movies released during march 2017 in the USA having total votes greater than 1000


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

SELECT title, 
	   avg_rating,
       genre
FROM movie m
INNER JOIN ratings r
	ON m.id = r.movie_id
INNER JOIN genre g
	ON m.id = g.movie_id
WHERE title LIKE 'The%' AND avg_rating > 8
GROUP BY title
ORDER BY avg_rating DESC;

/* As Theeran movie is given in the sample output while putting the like condition in the where clause we used 'The%'. 
If we wanted only those movies whose first word is 'The' and not the first three letters then we would have used 'The %' in 
the like condition of the where clause. The only difference is of a space after the word 'the' */


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(id) AS number_of_movies
FROM movie m
INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE median_rating = 8 AND date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT languages, 
	   sum(total_votes) AS votes
FROM movie m
INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE languages LIKE '%German%' 
UNION
SELECT languages, 
	   sum(total_votes) AS votes
FROM movie m
INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE languages LIKE '%Italian%'
ORDER BY votes DESC;

/* The first part before union gives the total number of votes for all those movies where language column contains German 
 and the next half gives the total number of votes for all those movies where language column contains Italian.
 After union we can see that German movies get more votes than Italian movies */

-- Answer is Yes

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
  SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
  SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
  SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
  SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

-- Height, Date_of_birth and known_for_movies are the column having null values


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

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
-- Type your code below:
/*
First create a CTE to find the top three genres having most number of movies with an average rating > 8
*/

WITH genre_summary AS
( 
SELECT genre, 
	   COUNT(id) AS number_of_movies
FROM genre g
INNER JOIN movie m
	ON m.id = g.movie_id
INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 3
) 
SELECT n.name AS director_name, 
	   count(dr.movie_id) AS movie_count
FROM names n
INNER JOIN director_mapping dr
	ON n.id = dr.name_id
INNER JOIN genre g
	ON dr.movie_id = g.movie_id
INNER JOIN ratings r
	ON r.movie_id = dr.movie_id,
genre_summary
WHERE g.genre in (genre_summary.genre) AND avg_rating > 8
GROUP BY name
ORDER BY count(dr.movie_id) DESC
LIMIT 3;

/* James Mangold, Anthony Russo and Soubin Shahir are the top three directors in the 
top three genres whose movies have an average rating > 8 */

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

SELECT n.name AS actor_name, 
	   count(m.id) AS movie_count
FROM names n
INNER JOIN role_mapping r
	ON n.id = r.name_id
INNER JOIN movie m
	ON r.movie_id = m.id
INNER JOIN ratings ra
	ON m.id = ra.movie_id
WHERE ra.median_rating >= 8 AND r.category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/*
Mammootty and Mohanlal are the top two actors whose movies have a median rating >= 8
*/

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

SELECT production_company, 
	   sum(total_votes) AS vote_count,
	   RANK() OVER(ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
	ON m.id = r.movie_id
GROUP BY production_company
ORDER BY prod_comp_rank
LIMIT 3;
 
/* Marvel Studios, Twentieth Century Fox and Warner Bros. are the top three 
production houses based on the number of votes received by their movies
*/

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

-- Weighted average is taken by taking the sum of (avg_ratings * total_votes) and dividing it by sum of total_votes

SELECT n.name AS actor_name, 
	   sum(r.total_votes) AS total_votes,
       count(m.id) AS movie_count,
       ROUND((sum(r.avg_rating*r.total_votes)/ sum(r.total_votes)), 2) AS actor_avg_rating,
       RANK() OVER(ORDER BY ROUND((sum(r.avg_rating*r.total_votes)/ sum(r.total_votes)), 2) DESC) AS actor_rank
FROM ratings r
INNER JOIN movie m
	ON r.movie_id = m.id
INNER JOIN role_mapping rm
	ON m.id = rm.movie_id
INNER JOIN names n
	ON rm.name_id = n.id
WHERE rm.category = 'actor' AND m.country = 'India'
GROUP BY actor_name
HAVING movie_count >= 5;

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

SELECT n.name AS actress_name, 
	   sum(r.total_votes) AS total_votes,
       count(m.id) AS movie_count,
       ROUND((sum(r.avg_rating*r.total_votes)/ sum(r.total_votes)), 2) AS actress_avg_rating,
       RANK() OVER(ORDER BY ROUND((sum(r.avg_rating*r.total_votes)/ sum(r.total_votes)), 2) DESC) AS actress_rank
FROM ratings r
INNER JOIN movie m
	ON r.movie_id = m.id
INNER JOIN role_mapping rm
	ON m.id = rm.movie_id
INNER JOIN names n
	ON rm.name_id = n.id
WHERE rm.category = 'actress' AND m.country = 'India' AND m.languages LIKE '%Hindi%'
GROUP BY actress_name
HAVING movie_count >= 3
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. */ 


/* Now let us divide all the thriller movies in the following categories and find out their numbers.*/
/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
-- Use case statements to classify the movies from thriller genre into the given categories

SELECT m.title, 
	   r.avg_rating,
CASE
	WHEN r.avg_rating > 8 THEN 'Superhit movies'
    WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
    WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One_time_watch movies'
    WHEN r.avg_rating < 5 THEN 'Flop movies'
END AS rating_category
FROM ratings r
INNER JOIN movie m
	ON r.movie_id = m.id
INNER JOIN genre g
	ON m.id = g.movie_id
WHERE g.genre = 'thriller'
ORDER BY m.title;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

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

/* Running total is obtained by taking the Sum of average of the duration of all the preceding rows from the current row.
Moving Average is obtained by taking the average of average duration of the preceding rows */ 

SELECT g.genre, 
	   ROUND(AVG(m.duration), 2) AS avg_duration,
       SUM(ROUND(AVG(m.duration), 2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       AVG(ROUND(AVG(m.duration), 2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie m
INNER JOIN genre g
	ON m.id = g.movie_id
GROUP BY g.genre;

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

-- Top 3 Genres based on most number of movies
/* First create a CTE to find the top three genres with respect to number of movies */

WITH top_genre AS
(
SELECT genre, 
	   COUNT(id) AS number_of_movies
FROM genre g
INNER JOIN movie m
	ON m.id = g.movie_id
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 3
),
top5 AS 
(
SELECT g.genre, 
	   m.year,
       m.title AS movie_name,
       m.worlwide_gross_income,
       /* In the worlwide_gross_income column some values are in $ and some are in INR. First we converted INR values 
       to $ using substring function in the RANK function so that the values will be sorted and ranked correctly using the $ value*/
       RANK() OVER(PARTITION BY m.year ORDER BY (CASE WHEN worlwide_gross_income LIKE 'INR%' THEN ROUND((SUBSTRING(worlwide_gross_income, 5)/ 75), 2) 
       ELSE SUBSTRING(worlwide_gross_income, 3)
       END) DESC ) AS movie_rank
FROM movie m
INNER JOIN genre g
	ON m.id = g.movie_id,
top_genre
WHERE g.genre in (top_genre.genre)
)
SELECT *
FROM top5
WHERE movie_rank <=5;


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

SELECT m.production_company,
	   count(m.id) AS movie_count,
       RANK() OVER(ORDER BY count(m.id) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
	ON m.id = r.movie_id
WHERE r.median_rating >= 8 AND m.production_company IS NOT NULL AND POSITION(',' IN m.languages) > 0
-- If the number of ',' in languages column of a row is greater than 0 that means it is a multilingual movie
GROUP BY production_company
LIMIT 2;

/* Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits 
(median rating >= 8) among multilingual movies */
    
-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


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

SELECT n.name AS actress_name,
	   sum(r.total_votes) AS total_votes,
       count(m.id) AS movie_count,
       ROUND(AVG(r.avg_rating), 2) AS actress_avg_rating,
       RANK() OVER(ORDER BY count(m.id) DESC) AS actress_rank
FROM ratings r
INNER JOIN movie m
	ON r.movie_id = m.id
INNER JOIN role_mapping rm
	ON m.id = rm.movie_id
INNER JOIN names n
	ON rm.name_id = n.id
INNER JOIN genre g
	ON m.id = g.movie_id
WHERE rm.category = 'actress' AND r.avg_rating > 8 AND g.genre = 'Drama'
GROUP BY actress_name
LIMIT 3;

/* The top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre are:
Parvathy Thiruvothu
Susan Brown
Amanda Lawrence */

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

/*
First create a CTE to fetch the next movie date using LEAD function and find the date difference between the next movie date and
publishing date of a movie using datediff function. 
*/

WITH next_date_summary AS
(
SELECT d.name_id, 
	   n.name,
	   d.movie_id,
       m.duration,
       date_published,
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
INNER JOIN movie m
	ON d.movie_id = m.id
INNER JOIN names n
	ON d.name_id = n.id
),
date_diff AS
(
SELECT *,
	   Datediff(next_movie_date, date_published) AS date_difference
FROM next_date_summary  
)
SELECT dd.name_id AS director_id,
	   dd.name AS director_name,
       count(dd.movie_id) AS number_of_movies,
       Round(Avg(date_difference)) AS avg_inter_movie_days,
	   Round(Avg(r.avg_rating),2) AS avg_rating,
	   Sum(r.total_votes) AS total_votes,
	   Min(r.avg_rating) AS min_rating,
	   Max(r.avg_rating) AS max_rating,
	   Sum(dd.duration) AS total_duration
FROM date_diff dd
INNER JOIN ratings r
	ON dd.movie_id = r.movie_id
GROUP BY director_id
ORDER BY number_of_movies DESC
LIMIT 9;

