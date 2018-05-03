-- CS2102 Assignment 3
--
-- Customers (cname, area)
-- Restaurants (rname, area)
-- Pizzas (pizza)
-- Sells (rname, pizza, price)
-- Likes (cname, pizza)

-- Matriculation Number: A0162492A
-- Duplicate records are removed from all query results.

DROP VIEW IF EXISTS qa, qb, qc, qd, qe, qf, qg, qh, qi, qj;
DROP VIEW IF EXISTS q1, q2, q3, q4, q5, q6, q7, q8, q9, q10;

-- Question 1
-- Find all restaurants that sell some pizza that Alice likes.
CREATE VIEW q1 (rname) AS
SELECT DISTINCT rname
FROM Sells
WHERE pizza IN (
	SELECT pizza
	FROM Likes
	WHERE cname = 'Alice'
)
;

-- Question 2
-- Find all pizzas sold by restaurants that are located in the same area as Bob.
CREATE VIEW q2 (pizza) AS
SELECT DISTINCT pizza
FROM Sells
WHERE rname IN (
	SELECT rname
	FROM Restaurants
	WHERE area = (
		SELECT min(area)
		FROM Customers
		WHERE cname = 'Bob'
	)
)
;

-- Question 3
-- Find all customers who like at least two different pizzas.
CREATE VIEW q3 (cname) AS
SELECT DISTINCT cname
FROM Likes
GROUP BY cname
HAVING COUNT(DISTINCT pizza) >= 2
;

-- Question 4
-- Given two restaurants R1 and R2, we say that R1 is more expensive than R2 if for every pizza P 
-- that is sold by both R1 and R2, R1's selling price for P is higher than R2's selling price for P.
-- Find all pairs of restaurants (R1,R2) where R1 is more expensive than R2.
-- Exclude restaurant pairs that do not sell any common pizza.
CREATE VIEW q4 (rname1, rname2) AS
SELECT DISTINCT s1.rname AS rname1, s2.rname AS rname2
FROM Sells s1, Sells s2
WHERE EXISTS (
	SELECT 1
	FROM Sells s3, Sells s4
	WHERE s3.rname = s1.rname
	AND s4.rname = s2.rname
	AND s3.pizza = s4.pizza
) AND NOT EXISTS (
	SELECT pizza
	FROM Sells s5
	WHERE s5.rname = s1.rname
	AND EXISTS (
		SELECT 1
		FROM Sells s6
		WHERE s6.rname = s2.rname
		AND s5.pizza = s6.pizza
		AND s5.price <= s6.price
	)
)
;

-- Question 5
-- Find all customers such that every restaurant that is co-located with them sells only pizzas that 
-- they like.
-- Exclude customers who are not co-located with any restaurant.
CREATE VIEW q5 (cname) AS
SELECT DISTINCT c.cname
FROM Customers c
WHERE EXISTS (
	SELECT 1
	FROM Restaurants r1
	WHERE r1.area = c.area
) AND NOT EXISTS (
	SELECT s.rname
	FROM Sells s NATURAL JOIN Restaurants r2
	WHERE r2.area = c.area
	AND s.pizza NOT IN (
		SELECT l.pizza
		FROM Likes l
		WHERE l.cname = c.cname
	)
)
;

-- Question 6
-- You are given a budget of $40 to buy two distinct pizzas from the same restaurant.
-- Find all restaurants that you could buy from (without exceeding your budget).
CREATE VIEW q6 (rname) AS
SELECT DISTINCT s1.rname
FROM Sells s1, Sells s2
WHERE s1.rname = s2.rname
AND s1.pizza <> s2.pizza
AND s1.price + s2.price <= 40
;

-- Question 7
-- Three friends (Moe, Larry, and Curly) plan to share three pizzas for dinner at a restaurant 
-- that must satisfy all these requirements: 
-- 	(a) the three pizzas ordered must be distinct pizzas,
--	(b) the total cost of the three pizzas must not exceed $80,
-- 	(c) each of the three pizzas must be liked by at least one of the friends, and 
--	(d) each of the friends must like at least two of the three pizzas (the pair of pizzas liked 
--		by each of them do not necessarily have to be the same).
-- Find all (R, P1, P2, P3, TP) tuples where the three friends could share the pizzas {P1, P2, P3}
-- from the restaurant R with a total cost of TP such that P1 < P2 < P3.
CREATE VIEW q7 (rname, pizza1, pizza2, pizza3, totalPrice) AS
SELECT DISTINCT
	s1.rname,
	s1.pizza AS pizza1,
	s2.pizza AS pizza2,
	s3.pizza AS pizza3,
	(s1.price + s2.price + s3.price) AS totalPrice
FROM Sells s1, Sells s2, Sells s3
WHERE s1.rname = s2.rname
AND s2.rname = s3.rname
AND s1.pizza < s2.pizza
AND s2.pizza < s3.pizza
AND (s1.price + s2.price + s3.price) <= 80
AND EXISTS (
	SELECT 1
	FROM Likes l1
	WHERE l1.pizza = s1.pizza
	AND l1.cname IN ('Moe', 'Larry', 'Curly')
)
AND EXISTS (
	SELECT 1
	FROM Likes l2
	WHERE l2.pizza = s2.pizza
	AND l2.cname IN ('Moe', 'Larry', 'Curly')
)
AND EXISTS (
	SELECT 1
	FROM Likes l3
	WHERE l3.pizza = s3.pizza
	AND l3.cname IN ('Moe', 'Larry', 'Curly')
)
AND (
	SELECT COUNT(DISTINCT pizza)
	FROM Likes l4
	WHERE l4.cname = 'Moe'
	AND l4.pizza IN (s1.pizza, s2.pizza, s3.pizza)
) >= 2
AND (
	SELECT COUNT(DISTINCT pizza)
	FROM Likes l5
	WHERE l5.cname = 'Larry'
	AND l5.pizza IN (s1.pizza, s2.pizza, s3.pizza)
) >= 2
AND (
	SELECT COUNT(DISTINCT pizza)
	FROM Likes l6
	WHERE l6.cname = 'Curly'
	AND l6.pizza IN (s1.pizza, s2.pizza, s3.pizza)
) >= 2
;

-- Question 8
-- Given a restaurant R, let numPizza(R) denote the number of pizzas sold by R and priceRange(R) 
-- denote the difference between the maximum and minimum prices of pizzas sold by R.
-- If R does not sell any pizzas, then numPizza(R) = 0 and priceRange(R) = 0.
-- Given two restaurants, R1 and R2, we say that R1 is more diverse than R2 if either
-- 	(a) numPizza(R1) > numPizza(R2) and priceRange(R1) >= priceRange(R2), or 
--	(b) numPizza(R1) >= numPizza(R2) and priceRange(R1) > priceRange(R2).
-- Find all restaurants R such that there does not exist any restaurant R2 that is more diverse than R.
CREATE VIEW q8 (rname) AS
SELECT DISTINCT r1.rname
FROM Restaurants r1
WHERE NOT EXISTS (
	SELECT r2.rname
	FROM Restaurants r2
	WHERE (
		(SELECT COUNT(DISTINCT s1.pizza)
		FROM Sells s1
		WHERE s1.rname = r2.rname) > 
		(SELECT COUNT(DISTINCT s2.pizza)
		FROM Sells s2
		WHERE s2.rname = r1.rname)
		AND
		(SELECT 
			CASE
			WHEN (MAX(s3.price) - MIN(s3.price)) IS NOT NULL
			THEN MAX(s3.price) - MIN(s3.price)
			ELSE 0
			END 
		FROM Sells s3
		WHERE s3.rname = r2.rname) >= 
		(SELECT
			CASE
			WHEN (MAX(s4.price) - MIN(s4.price)) IS NOT NULL
			THEN MAX(s4.price) - MIN(s4.price)
			ELSE 0
			END 
		FROM Sells s4
		WHERE s4.rname = r1.rname)
	) OR (
		(SELECT COUNT(DISTINCT s5.pizza)
		FROM Sells s5
		WHERE s5.rname = r2.rname) >= 
		(SELECT COUNT(DISTINCT s6.pizza)
		FROM Sells s6
		WHERE s6.rname = r1.rname)
		AND
		(SELECT
			CASE
			WHEN (MAX(s7.price) - MIN(s7.price)) IS NOT NULL
			THEN MAX(s7.price) - MIN(s7.price)
			ELSE 0
			END 
		FROM Sells s7
		WHERE s7.rname = r2.rname) > 
		(SELECT
			CASE
			WHEN (MAX(s8.price) - MIN(s8.price)) IS NOT NULL
			THEN MAX(s8.price) - MIN(s8.price)
			ELSE 0
			END 
		FROM Sells s8
		WHERE s8.rname = r1.rname)
	)
)
;

-- Question 9

-- For each distinct area A in Customers.area, find the following information: 
-- (a) the area name A,
-- (b) the total number of customers located in A,
-- (c) the total number of restaurants located in A, and
-- (d) the price of the most expensive pizza sold by restaurants in A; if there are no restaurants selling 
-- 	   pizzas in A, show the value 0.
CREATE VIEW q9 (area, numCustomers, numRestaurants, maxPrice) AS
SELECT DISTINCT area, 
	   COUNT(*) AS numCustomers,
	   (SELECT COUNT(DISTINCT rname) 
	   	FROM Restaurants r1 
	   	WHERE r1.area = c.area) AS numRestaurants,
	   CASE
	   WHEN NOT EXISTS (
	   		SELECT pizza 
	   		FROM Sells NATURAL JOIN Restaurants r2 
	   		WHERE r2.area = c.area) 
	   THEN 0
	   ELSE 
	   (SELECT MAX(price) 
	   	FROM Sells NATURAL JOIN Restaurants r3 
	   	WHERE r3.area = c.area)
	   END as maxPrice
FROM Customers c
GROUP BY area
;

-- Question 10
-- Find all restaurants that satisfy the following conditions.
-- 	(a) the restaurant must sell at least three pizzas,
--	(b) at least one of the pizzas sold by the restaurant must be cheaper than $20, and
--	(c) for each distinct area A in Customers.area, there must be at least two customers located in A who like 
--		at least one pizza sold by the restaurant. Note that the two customers do not necessarily like the same 
--		pizza sold by the restaurant.
CREATE VIEW q10 (rname) AS
SELECT DISTINCT r.rname
FROM Restaurants r
WHERE (
	SELECT COUNT(*) 
	FROM Sells s1 
	WHERE s1.rname = r.rname
	) >= 3
AND EXISTS (
	SELECT 1 
	FROM Sells s2 
	WHERE s2.rname = r.rname 
	AND s2.price < 20)
AND NOT EXISTS (
	SELECT c1.area
	FROM Customers c1
	WHERE (
		SELECT COUNT(DISTINCT l.cname)
		FROM Likes l NATURAL JOIN Customers c2
		WHERE c2.area = c1.area
		AND l.pizza IN (
			SELECT pizza
			FROM Sells s3
			WHERE s3.rname = r.rname
		)
	) < 2
)
;
