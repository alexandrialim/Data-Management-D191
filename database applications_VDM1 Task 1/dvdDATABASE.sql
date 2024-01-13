-- CREATE 'DETAILED' TABLE
DROP TABLE IF EXISTS details;
CREATE TABLE details(
rental_id integer,
inventory_id integer,
film_id integer,
category_id smallint,
amount numeric(5,2),
replacement_cost numeric(5,2),
dup integer
);

-- CREATE 'SUMMARY' TABLE 
DROP TABLE IF EXISTS summary;
CREATE TABLE summary(
name varchar(25),
final_profit numeric(5,2)-- something like that? / profit numeric(5,2)
);

-- EXTRACT DATA FROM EXISTING TABLES INTO 'DETAILED' TABLE
INSERT INTO details(
rental_id,
inventory_id,
film_id,
category_id,
amount,
replacement_cost,
dup 
) 
SELECT rental.rental_id, inventory.inventory_id, film.film_id, payment.amount, film_category.category_id,
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
RETURNS TRIGGER AS $$
BEGIN
DELETE FROM summary;
	SELECT SUM(payment.amount) AS totalprof
	FROM payment 
	WHERE payment.rental_id = payment.rental_id;
	RETURN totalprof;
INSERT INTO summary(
	SELECT DISTINCT category.name, totalprof
	FROM category
	ORDER BY totalprof DESC);
END; 
$$ LANGUAGE PLPGSQL;

--TRIGGER
CREATE TRIGGER sum_refresh
AFTER INSERT ON details
FOR EACH STATEMENT
EXECUTE FUNCTION total_profit();

-- STORE PROCEDURE 
CREATE PROCEDURE complete_refresh()
LANGUAGE PLPGSQL
AS $$ 
BEGIN 
DELETE FROM details;
INSERT INTO details(
	rental_id,
	inventory_id,
	film_id,
	category_id,
	amount,
	replacement_cost,
	) 
SELECT rental.rental_id, inventory.inventory_id, film.film_id, payment.amount, film_category.category_id,
 	-film.replacement_cost, count(inventory.inventory_id) as duplicate
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
INNER JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY inventory.inventory_id, rental.rental_id, -film.replacement_cost, film.film_id, film_category.category_id, payment.amount
ORDER BY duplicate DESC;
END; $$;

-- Refresh reports
CALL complete_refresh();
