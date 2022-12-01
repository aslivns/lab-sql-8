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
SELECT s.store_id, CONCAT('$', ROUND(SUM(p.amount),2)) AS total_revenue
FROM store s      
JOIN staff stf
ON s.store_id = stf.store_id
JOIN payment p
ON stf.staff_id = p.staff_id
GROUP BY s.store_id;

-- 3. Which film categories are longest?
SELECT c.name AS adf, SUM(f.length) AS duration
FROM film f 
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c 
ON c.category_id = fc.category_id
GROUP BY name
ORDER BY duration DESC;

-- 4. Display the most frequently rented movies in descending order.
SELECT f.title AS movie, COUNT(*) AS rental_amount
FROM film f 
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY f.title DESC;

-- 5. List the top five genres in gross revenue in descending order.
SELECT c.name, CONCAT('$', FORMAT(SUM(p.amount),2)) AS 'Gross Revenue'
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?

SELECT f.film_id, f.title, s.store_id, i.inventory_id, COUNT(*) as count
FROM inventory i 
JOIN store s
USING (store_id) JOIN 
film f USING (film_id)
where f.title = 'Academy Dinosaur' and s.store_id = 1
GROUP BY title;

-- 7. Get all pairs of actors that worked together.

SELECT fa1.film_id, a1.first_name, a1.last_name, a2.first_name, a2.last_name
FROM film_actor fa1
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN film_actor fa2
JOIN actor a2 ON fa2.actor_id = a2.actor_id
ON (fa1.actor_id <> fa2.actor_id) AND (fa1.film_id = fa2.film_id)
GROUP BY fa1.film_id;


-- 8. Get all pairs of customers that have rented the same film more than 3 times.
-- this code doesnt work
SELECT f1.title, c1.first_name, c1.last_name, c2.first_name, c2.last_name, COUNT(*)

FROM customer c1
JOIN rental r1 ON c1.customer_id = r1.customer_id 
JOIN inventory i1 on i1.inventory_id = r1.inventory_id
JOIN film f1 on i1.film_id = f1.film_id

JOIN customer c2
JOIN rental r2 ON c2.customer_id = r2.customer_id 
JOIN inventory i2 on i2.inventory_id = r2.inventory_id
JOIN film f2 on i2.film_id = f2.film_id

WHERE (f1.film_id = f2.film_id) AND COUNT(*) > 3; 

-- 9. For each film, list actor that has acted in more films. */

  