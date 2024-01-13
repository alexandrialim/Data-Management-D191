-- CREATE 'DETAILED' TABLE
DROP TABLE IF EXISTS details;
CREATE TABLE details(
rental_id INTEGER,
inventory_id INTEGER,
film_id INTEGER,
category_id INTEGER,
amount NUMERIC(5,2)
);

-- CREATE 'SUMMARY' TABLE 
DROP TABLE IF EXISTS summary;
CREATE TABLE summary(
name VARCHAR(25),
category_id INTEGER,
final_profit NUMERIC(7,2)
);

-- EXTRACT DATA FROM EXISTING TABLES INTO 'DETAILED' TABLE
INSERT INTO details(
rental_id,
inventory_id,
film_id,
category_id,
amount) 
SELECT rental.rental_id, inventory.inventory_id, film.film_id, film_category.category_id, 
payment.amount 
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
INNER JOIN payment ON payment.rental_id = rental.rental_id
ORDER BY film_category.category_id;

-- FUNCTION 
CREATE OR REPLACE FUNCTION rev()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM summary;
	INSERT INTO summary(SELECT category.name, category.category_id, SUM(details.amount)
	FROM category
	INNER JOIN details ON category.category_id = details.category_id
	GROUP BY category.category_id
	ORDER BY SUM(details.amount) DESC);
RETURN NEW;
END; 
$$ LANGUAGE PLPGSQL;

--TRIGGER
CREATE TRIGGER sum_refresh
AFTER INSERT ON details
FOR EACH STATEMENT
EXECUTE FUNCTION rev();

-- STORED PROCEDURE 
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
	amount) 
SELECT rental.rental_id, inventory.inventory_id, film.film_id, 
		payment.amount, film_category.category_id
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON film.film_id = inventory.film_id
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
INNER JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY inventory.inventory_id, rental.rental_id, film.film_id, film_category.category_id, payment.amount
ORDER BY rental.rental_id;
END; $$;

-- VIEW TABLES 
SELECT * FROM details;
SELECT * FROM summary;

-- REFRESH REPORTS
CALL complete_refresh();
