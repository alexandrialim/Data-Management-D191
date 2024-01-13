SELECT customer_id FROM rental 
GROUP BY customer_id
HAVING COUNT(*) > 45
ORDER BY customer_id ASC;

SELECT inventory.film_id, inventory.inventory_id, category.name, COUNT(category.name)
FROM rental 
JOIN inventory ON inventory.inventory_id = rental.inventory_id
--select film_category.category_id
--from film_category
JOIN film_category ON inventory.inventory_id = film_category.film_id
--select category.name, count(category.name)
--from category 
JOIN category on film_category.category_id = category.category_id
--where rental.customer_id = 148
GROUP BY inventory.film_id, inventory.inventory_id, category.name
HAVING COUNT(category.name) > 1
ORDER BY COUNT(category.name) desc;


-- CREATE 'DETAILED' TABLE
DROP TABLE IF EXISTS detailed;
CREATE TABLE detailed(
rental_id integer,
inventory_id integer,
film_id integer,
category_id smallint,
amount numeric(5,2),
profit numeric(5,2)
);

-- CREATE 'SUMMARY' TABLE 
DROP TABLE IF EXISTS summary;
CREATE TABLE summary(
name varchar(25),
final_profit numeric(5,2)-- something like that? / profit numeric(5,2)
);

-- EXTRACT DATA FROM EXISTING TABLES INTO 'DETAILED' TABLE
INSERT INTO detailed(
rental_id,
inventory_id,
film_id,
category_id,
amount,
replacement_cost,
total count 
) 
SELECT rental.rental_id, inventory.inventory_id, film.film_id, payment.amount, ?(replacement_cost - amount) as profit?, film_category.category_id,
 -film.replacement_cost, count(inventory.inventory_id) as duplicate
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
INNER JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY inventory.inventory_id, rental.rental_id, -film.replacement_cost, film.film_id, film_category.category_id, payment.amount
ORDER BY duplicate DESC;

-- FUNCTION 
CREATE FUNCTION total_profit()
RETURNS numeric(5,2) AS $$
BEGIN
	SELECT SUM(payment.amount) AS totalprof
	FROM payment 
	WHERE payment.rental_id = payment.rental_id;
	RETURN totalprof;
INSERT INTO summary(
	SELECT DISTINCT category.name, totalprof
	FROM category
	ORDER BY totalprof DESC);
END; $$ LANGUAGE PLPGSQL

