-- In this lab, you will be using the Sakila database of movie rentals.

USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id , c.city, co.country
FROM store s 
JOIN address a
ON s.address_id=a.address_id
JOIN city c
ON a.address_id=c.city_id
JOIN country co
ON c.country_id=co.country_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.
-- took store_id from tables store+staff, and then joined staff+payment tables on staff_id
SELECT s.store_id,ROUND(SUM(p.amount),2) AS total_revenue
FROM store s      
JOIN staff stf
ON s.store_id = stf.store_id
JOIN payment p
ON stf.staff_id = p.staff_id
GROUP BY s.store_id;

-- 3. Which film categories are longest?
SELECT c.name AS genre, ROUND(AVG(f.length),2) AS avg_duration
FROM film f 
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c 
ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_duration DESC;

-- 4. Display the most frequently rented movies in descending order.
SELECT f.title AS movie, COUNT(*) AS rental_amount
FROM film f 
JOIN inventory i USING(film_id)
JOIN rental r USING(inventory_id)
GROUP BY f.title
ORDER BY rental_amount DESC;

-- 5. List the top five genres in gross revenue in descending order.
SELECT c.name AS genre, ROUND(SUM(p.amount),2) AS gross_revenue
FROM category c
JOIN film_category fc USING(category_id)
JOIN inventory i USING(film_id)
JOIN rental r USING(inventory_id)
JOIN payment p USING(rental_id)
GROUP BY c.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?

SELECT f.title, i.store_id, COUNT(*) as count
FROM film f
JOIN inventory i  USING (film_id)
WHERE f.title = 'Academy Dinosaur' AND store_id = 1
GROUP BY title;

-- 7. Get all pairs of actors that worked together.
USE sakila;
SELECT fa1.film_id AS film, fa1.actor_id AS first_actor, fa2.actor_id AS second_actor
FROM film_actor fa1
JOIN film_actor fa2
WHERE (fa1.actor_id < fa2.actor_id) AND (fa1.film_id = fa2.film_id);


-- 8. Get all pairs of customers that have rented the same film more than 3 times.

CREATE TEMPORARY TABLE t1 AS (
SELECT i.film_id, r.rental_id, r.customer_id, r.inventory_id
FROM rental r
JOIN inventory i
USING(inventory_id));
CREATE TEMPORARY TABLE t2 AS (
SELECT i.film_id, r.rental_id, r.customer_id, r.inventory_id
FROM rental r
JOIN inventory i
USING(inventory_id));
SELECT count(t1.film_id), t1.customer_id AS customer1, t2.customer_id AS customer2
FROM t1
JOIN t2
ON t1.inventory_id = t2.inventory_id AND t1.customer_id > t2.customer_id
GROUP BY t1.customer_id, t2.customer_id
HAVING count(t1.film_id) > 3;

-- 9. For each film, list actor that has acted in more films. 

CREATE TEMPORARY TABLE t3 AS (
SELECT COUNT(*) AS count, fa.actor_id AS actor, f.film_id 
FROM film_actor fa JOIN film f USING (film_id) 
GROUP BY actor_id
);

CREATE TEMPORARY TABLE t4 AS (
SELECT COUNT(*) AS count, fa.actor_id AS actor, f.film_id 
FROM film_actor fa JOIN film f USING (film_id) 
GROUP BY actor_id 
);

SELECT t3.actor AS actor1, t4.actor AS actor2,
FROM t3 JOIN t4 
ON t3.film_id = t4.film_id AND t3.count > t4.count;



  