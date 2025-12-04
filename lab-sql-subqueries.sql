USE sakila;

-- 1
SELECT COUNT(*) AS copies_in_inventory
FROM inventory
WHERE film_id=(
    SELECT film_id
	FROM film
    WHERE title = 'Hunchback Impossible'
);

-- 2
SELECT title, length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);

-- 3
SELECT first_name,last_name 
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id =(
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
        )
);

-- 4
SELECT
    f.film_id,
    f.title
FROM film AS f
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 5
SELECT
    first_name,
    last_name,
    email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- 6
SELECT
    f.film_id,
    f.title
FROM film AS f
JOIN film_actor AS fa
    ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 7
SELECT DISTINCT
    f.film_id,
    f.title
FROM payment AS p
JOIN rental AS r
    ON p.rental_id = r.rental_id
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id
WHERE p.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- 8
SELECT
    customer_id AS client_id,
    SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            SUM(amount) AS customer_total
        FROM payment
        GROUP BY customer_id
    ) AS t
);





