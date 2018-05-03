-- CS2102 Tutorial 4 Question 2
--
-- Customers (cname, area)
-- Restaurants (rname, area)
-- Pizzas (pizza)
-- Sells (rname, pizza, price)
-- Likes (cname, pizza)

DROP VIEW IF EXISTS qa, qb, qc, qd, qe, qf;

-- Question a
-- For each restaurant, find the price of the most expensive pizzas sold by that restaurant. 
-- Exclude restaurants that do not sell any pizza.
CREATE VIEW qa(rname, maxprice) AS
SELECT DISTINCT rname, MAX(price) AS maxprice
FROM Sells
GROUP BY rname
;

-- Question b
-- For each restaurant that sells some pizza, find the restaurant name and the average price of 
-- its pizzas if its average price is higher than $22. 
-- Use the HAVING clause in your answer.
CREATE VIEW qb(rname, avgprice) AS
SELECT DISTINCT rname, AVG(price) AS avgprice
FROM Sells
GROUP BY rname
HAVING AVG(price) > 22
;

-- Question c
-- For each restaurant that sells some pizza, find the restaurant name and the average price of 
-- its pizzas if its average price is higher than $22.
-- Do not use any HAVING clause in your answer.
CREATE VIEW qc(rname, avgprice) AS
SELECT DISTINCT rname, AVG(price) AS avgprice
FROM Sells s1
WHERE (SELECT AVG(price) FROM Sells s2 WHERE s1.rname = s2.rname) > 22
GROUP BY rname
;


-- Question d
-- For each restaurant R that sells some pizza, let totalPrice(R) denote the total price of all 
-- the pizzas sold by R.  Find all pairs (R, totalPrice(R)) where totalPrice(R) is higher than 
-- the average of totalPrice() over all the restaurants.
CREATE VIEW qd(rname, totalPrice) AS
WITH TotalPrices AS (
	SELECT DISTINCT rname, SUM(price) AS totalPrice
	FROM Sells
	GROUP BY rname)
SELECT DISTINCT rname, totalPrice
FROM TotalPrices
WHERE totalPrice > (SELECT AVG(totalPrice) FROM TotalPrices)
;


-- Question e
-- Find the customer pairs (C1,C2) such that C1 < C2 and they like exactly the same pizzas. 
-- Exclude customer pairs that do not like any pizza. 
-- Do not use the EXCEPT operator in your answer.
CREATE VIEW qe(cname1, cname2) AS
SELECT DISTINCT l1.cname AS cname1, l2.cname AS cname2
FROM Likes l1, Likes l2
WHERE l1.cname < l2.cname
AND NOT EXISTS (
	SELECT l3.pizza
	FROM Likes l3
	WHERE l3.cname = l1.cname
	AND NOT EXISTS (
		SELECT 1
		FROM Likes l4
		WHERE l4.cname = l2.cname
		AND l4.pizza = l3.pizza
	)
)
AND NOT EXISTS (
	SELECT l5.pizza
	FROM Likes l5
	WHERE l5.cname = l2.cname
	AND NOT EXISTS (
		SELECT 1
		FROM Likes l6
		WHERE l6.cname = l1.cname
		AND l6.pizza = l5.pizza
	)
)
;

-- Question f
-- For each restaurant R, increase the prices of its pizzas by x% as follows:
--	x = 20 if R is located in 'Central',
--	x = 10 if R is located in 'East',
--	x = 5, otherwise.
-- Notice: This part will not be run and tested.
CREATE VIEW qf() AS
UPDATE Sells
SET price = case
			when area = 'Central' then price * 1.2
			when area = 'East' then price * 1.1
			else price * 1.05
			end
FROM Restaurants WHERE Sells.rname = Restaurants.rname
;
