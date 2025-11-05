-- Most senior employee based on job title? 
-- Based on this csv file we can just find the highest role 
-- In a more complicated file, I will need to find which roles are receiving the reports
-- to narrow the search down
SELECT title, first_name, last_name
FROM employee
WHERE title = 'Senior General Manager';
-- Countries with the most invoices
SELECT 
	billing_country, 
	COUNT(invoice_id) AS total_invoices,
	DENSE_RANK() OVER (ORDER BY COUNT(invoice_id) DESC) AS rank
FROM invoice
GROUP BY billing_country;
-- Suppose we want to throw a promotional Music Festival in the city that made the most money
-- for the store 
-- Could've just used invoice table, but I will find the total using the invoice_line and
-- compare it to the total in the invoice table as a double check
-- If there are any disparities, I won't consider the invoice valid 
WITH invoice_line_cte AS (
	SELECT  
		invoice_id, 
		SUM(unit_price * quantity) AS total
	FROM invoice_line
	GROUP BY invoice_id
	ORDER BY invoice_id
),
promotional_city AS (
	SELECT 
		inv.billing_city,
		SUM(inv.total) AS invoice_total
	FROM invoice AS inv
	INNER JOIN invoice_line_cte AS sinv
		ON inv.invoice_id = sinv.invoice_id
		AND inv.total = sinv.total
	GROUP BY inv.billing_city
	ORDER BY SUM(inv.total) DESC 
)
SELECT *
FROM promotional_city
WHERE invoice_total = (
	SELECT MAX(invoice_total)
	FROM promotional_city
);
-- Finding the best customer - the customer that spent the most 
-- I will use the previous cte, approaching this problem with a similar concept
-- The return will be the customer information with his/her invoice total
WITH invoice_line_cte AS (
	SELECT  
		invoice_id, 
		SUM(unit_price * quantity) AS total
	FROM invoice_line
	GROUP BY invoice_id
	ORDER BY invoice_id
),
invoice_cte AS (
	SELECT 
		inv.customer_id,
		SUM(inv.total) AS invoice_total
	FROM invoice AS inv
	INNER JOIN invoice_line_cte AS sinv
		ON inv.invoice_id = sinv.invoice_id
		AND inv.total = sinv.total
	GROUP BY inv.customer_id
	ORDER BY SUM(inv.total) DESC 
),
customer_cte AS (
	SELECT *
	FROM invoice_cte
	WHERE invoice_total = (
		SELECT MAX(invoice_total)
		FROM invoice_cte
	)
)
SELECT 
	c.customer_id,
	inv.invoice_total,
	c.first_name,
	c.last_name,
	c.company,
	c.address,
	c.city,
	c.country,
	c.postal_code,
	c.phone,
	c.email,
	c.support_rep_id
FROM customer AS c
INNER JOIN customer_cte AS inv
	ON c.customer_id = inv.customer_id;
-- Suppose we wanted to find the top three invoice sales 
SELECT  
	invoice_id, 
	SUM(unit_price * quantity) AS total
FROM invoice_line
GROUP BY invoice_id
ORDER BY SUM(unit_price * quantity) DESC
LIMIT 3;
-- Suppose we want to find all Rock Music listeners and return by email, first name &
-- last name
-- Return the list in alphabetical order by email
-- A customer is considered a Rock Music listener if they purchase at least one track
-- that is Rock
WITH rock_invoices AS (
	SELECT 
		line.invoice_id
	FROM invoice_line AS line
	INNER JOIN track
		ON line.track_id = track.track_id
	INNER JOIN genre
		ON track.genre_id = genre.genre_id
	WHERE track.genre_id = 1 AND genre.name = 'Rock'
	GROUP BY line.invoice_id
	ORDER BY line.invoice_id ASC
)
SELECT 
	DISTINCT(c.email),
	c.first_name,
	c.last_name
FROM rock_invoices AS ri
INNER JOIN invoice AS inv
	ON ri.invoice_id = inv.invoice_id
INNER JOIN customer AS c
	ON inv.customer_id = c.customer_id
ORDER BY c.email ASC;
-- Suppose we want to invite the Rock artists who have written the most rock music
-- The query will return the Artist name with their total Rock track counts 
-- Let's say we only want artist with the top 10 most Rock tracks
-- If composer does not exist or NULL, assume an artist could not be identified
-- If tracks have multiple artist names, then these combination of artists will count as 
-- an unique artist under the assumption that all three artists need to be invited
-- if they have a large enough track total
SELECT 
	t.composer,
	COUNT(t.genre_id) AS track_total
FROM track AS t
INNER JOIN genre AS g
	ON t.genre_id = g.genre_id 
	AND g.name = 'Rock'
	AND t.composer IS NOT NULL
GROUP BY t.composer
ORDER BY COUNT(t.genre_id) DESC
LIMIT 10;
-- Finding all songs that have song lengths longer than the average song length
SELECT 
	name AS song,
FROM track 
WHERE milliseconds > (
	SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;
-- We want to find the amount a customer has spent on each artist
-- Return customer name, artist name, total spent on each artist
-- If the composer is null, assume the artist cannot be identified 
WITH composer_cte AS (
	SELECT 
		line.invoice_id, 
		t.composer,
		SUM(line.unit_price * line.quantity) AS cost
	FROM invoice_line AS line
	INNER JOIN track AS t
		ON line.track_id = t.track_id
		AND t.composer IS NOT NULL
	GROUP BY line.invoice_id, t.composer
	ORDER BY line.invoice_id
),
customer_cte AS (
	SELECT 
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		cc.composer,
		cc.cost AS total_spent_on_artist
	FROM invoice AS inv
	INNER JOIN composer_cte AS cc
		ON inv.invoice_id = cc.invoice_id
	INNER JOIN customer AS c
	 	ON inv.customer_id = c.customer_id
	ORDER BY cc.cost DESC
)
-- There are 3000+ rows returned; too much information to be used in a meaningful manner
-- However, from this table, I can find further information with ease from this table 
-- Some Examples: total artist sales, how many customers are interested in an artist
-- Instead, I'm going to return the customer(s) that spent the most on an artist and more than 5.00
SELECT 
	customer_name,
	composer,
	MAX(total_spent_on_artist) AS max_spent
FROM customer_cte
WHERE total_spent_on_artist >= 5.00
GROUP BY composer, customer_name
ORDER BY MAX(total_spent_on_artist) DESC;