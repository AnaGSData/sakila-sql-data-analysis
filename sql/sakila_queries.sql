-- Connect to the sakila database, which simulates a film rental store
USE sakila; 

-- ============================================
-- 1. Select all film titles without duplicates
-- ============================================

SELECT DISTINCT title AS film_titles_no_duplicates
	FROM film;

-- =============================================
-- 2. Select all film titles with a "PG-13" rating
-- =============================================

SELECT title AS film_titles_PG13, rating
	FROM film
    WHERE rating = 'PG-13';

-- =============================================
-- 3. Find the title and description of all films that contain "amazing" in their description
-- =============================================

SELECT title AS film_title, description
	FROM film
    WHERE description LIKE '%amazing%';

-- =============================================
-- 4. Find the title of all films longer than 120 minutes
-- =============================================

SELECT title AS film_title, length 
	FROM film
    WHERE length > 120;

-- =============================================
-- 5. Show the full name of all actors
-- =============================================

SELECT first_name, last_name
	FROM actor;

-- =============================================
-- 6. Find the first and last names of all actors whose surname is "Gibson"
-- =============================================

SELECT first_name, last_name
	FROM actor
    WHERE last_name = 'Gibson';

-- =============================================
-- 7. Find the full name of all actors whose ID is between 10 and 20
-- =============================================

SELECT first_name, last_name, actor_id
	FROM actor
    WHERE actor_id BETWEEN 10 AND 20;

-- =============================================
-- 8. Select all film titles without a "R" or "PG-13" rating
-- =============================================

SELECT title AS film_title, rating
	FROM film
    WHERE rating <> 'PG-13' AND rating <> 'R';

-- =============================================
-- 9. Count the total number of films for each rating and show the rating and the result
-- =============================================

SELECT COUNT(DISTINCT film_id) AS total_films, rating
	FROM film
    GROUP BY rating;

-- =============================================
-- 10. Find the total number of films rented by each customer, including their ID and full name
-- =============================================
/* Using INNER JOIN to return only records with matching values in the related tables */

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_films_rented
	FROM customer AS c
    INNER JOIN rental AS r
		ON c.customer_id = r.customer_id
	GROUP BY c.customer_id, c.first_name, c.last_name;
		
-- =============================================
-- 11. Find the total number of films rented by each category and show the result and the category name
-- =============================================
/* Using INNER JOIN to return only records with matching values in the related tables */

SELECT COUNT(r.rental_id) AS total_films_rented, ca.category_id, ca.name AS category_name
	FROM rental AS r
	INNER JOIN inventory AS i
		ON r.inventory_id = i.inventory_id
	INNER JOIN film AS f
		ON f.film_id = i.film_id
	INNER JOIN film_category AS fc
		ON fc.film_id = f.film_id
	INNER JOIN category AS ca
		ON ca.category_id = fc.category_id
	GROUP BY ca.category_id, ca.name;
    
-- =============================================
-- 12. Find the average length for each rating and show the rating and the result
-- =============================================

SELECT AVG(length) AS average_length_rating, rating
	FROM film
    GROUP BY rating;

-- =============================================
-- 13. Find the actors (full name) who appear in the film "Indian Love"
-- =============================================
/* Using INNER JOIN to return only records with matching values in the related tables */

SELECT a.first_name, a.last_name, f.title
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON fa.actor_id = a.actor_id
	INNER JOIN film AS f
		ON fa.film_id = f.film_id
	WHERE f.title = 'Indian Love';

-- =============================================
-- 14. Find the title of all films that contain "dog" or "cat" in their description
-- =============================================
/* Using UNION to combine the results of two queries: one that finds films containing "dog" and another that finds films containing "cat"
UNION merges both result sets and removes duplicates automatically */

SELECT title AS film_title, description
	FROM film
	WHERE description LIKE '%dog%'

UNION

SELECT title, description
	FROM film
	WHERE description LIKE '%cat%';

-- =============================================
-- 15. Find actors who do not appear in any film listed in the film_actor table
-- =============================================
/* Using LEFT JOIN to keep all actors and identify those without any matching record in film_actor
Rows with NULL values in the joined table indicate actors who have not appeared in any film */

SELECT a.first_name, a.last_name
	FROM actor AS a
	LEFT JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
	WHERE fa.actor_id IS NULL;

-- =============================================
-- 16. Find the title of all the films whose release_year is between 2005 and 2010
-- =============================================

SELECT title AS film_title, release_year
	FROM film
    WHERE release_year BETWEEN 2005 AND 2010;

-- =============================================
-- 17. Find the title of all the films whose rating is the same as "Family"
-- =============================================

SELECT title AS film_title, rating
	FROM film
    WHERE rating = (
		SELECT rating
			FROM film
            WHERE title = 'Family');
	
-- =============================================
-- 18. Find actors who appear in more than 10 films
-- =============================================
/* Using INNER JOIN to return only records with matching values in the related tables */

SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT f.film_id) AS total_films
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
	INNER JOIN film AS f
		ON fa.film_id = f.film_id
	GROUP BY a.actor_id, a.first_name, a.last_name
    HAVING total_films > 10;

-- =============================================
-- 19. Find the title of films with "R" rating and whose length is longer than 2 hours
-- =============================================

SELECT title AS film_title, rating, length 
	FROM film
    WHERE rating = 'R' AND length > 120;

-- =============================================
-- 20. Find all categories whose average film length is longer than 120 minutes
-- =============================================
/* Using INNER JOIN to return only records with matching values in the related tables */

SELECT ca.category_id, ca.name, AVG(f.length) AS AVG_category_length
	FROM category AS ca
    INNER JOIN film_category AS fc
		ON ca.category_id = fc.category_id
	INNER JOIN film AS f
		ON fc.film_id = f.film_id
	GROUP BY ca.category_id, ca.name
    HAVING AVG_category_length > 120;

-- =============================================
-- 21. Find all actors who appear in at least 5 films and show their name and the number of films for each one
-- =============================================
/* Using INNER JOIN to return only records with matching values in the related tables */

SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT f.film_id) AS total_films
	FROM actor AS a
    INNER JOIN film_actor AS fa
		ON a.actor_id = fa.actor_id
	INNER JOIN film AS f
		ON fa.film_id = f.film_id
	GROUP BY a.actor_id, a.first_name, a.last_name
    HAVING total_films >= 5;

-- =============================================
-- 22. Use a subquery to find rental IDs with a rental period longer than 5 days and select the related films
-- =============================================
/* Using DATEDIFF because rental_date and return_date are DATETIME values, and this function correctly calculates the difference in days 
Using INNER JOIN to return only records with matching values in the related tables */

SELECT f.title AS film_title, DATEDIFF(r.return_date, r.rental_date) AS rental_days
	FROM film AS f
	INNER JOIN inventory AS i
		ON f.film_id = i.film_id
	INNER JOIN rental AS r
		ON r.inventory_id = i.inventory_id
	WHERE r.rental_id IN (
		SELECT rental_id
			FROM rental
			WHERE DATEDIFF(return_date, rental_date) > 5);

-- =============================================
-- 23. Find the full names of all actors who do not appear in any film in the "Horror" category. Use a subquery to find the actors who have appeared in "Horror" films and then exclude them
-- =============================================
/* Using a CTE (temporary result set) to first identify all actors who have appeared in Horror films through film_actor and film_category
Then, the outer query excludes those actors using NOT IN, returning only actors who have never appeared in the Horror category
Using INNER JOIN to return only records with matching values in the related tables */

WITH horror_actors AS (
	SELECT DISTINCT fa.actor_id
		FROM film_actor AS fa
		INNER JOIN film_category AS fc
			ON fc.film_id = fa.film_id
		INNER JOIN category AS ca
			ON fc.category_id = ca.category_id
		WHERE ca.name = 'Horror')

SELECT a.first_name, a.last_name
	FROM actor AS a
    WHERE a.actor_id NOT IN (
		SELECT actor_id
			FROM horror_actors);
            
-- =============================================
-- 24. Find all films in the "Comedy" category whose length is longer than 180 minutes
-- =============================================
/* Using INNER JOIN to return only records with matching values in the related tables */

SELECT f.title AS film_title, f.length, ca.name AS category_name
	FROM film AS f
    INNER JOIN film_category AS fc
		ON f.film_id = fc.film_id
	INNER JOIN category AS ca
		ON ca.category_id = fc.category_id
	WHERE ca.name = 'Comedy' AND f.length > 180;