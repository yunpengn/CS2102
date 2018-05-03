-- CS2102 Tutorial 3 Question 2
--
-- Customers (cname, area)
-- Restaurants (rname, area)
-- Pizzas (pizza)
-- Sells (rname, pizza, price)
-- Likes (cname, pizza)

DROP VIEW IF EXISTS qa, qb, qc, qd, qe, qf;

-- Question a
-- Find pizzas that Alice likes but Bob does not like.
CREATE VIEW qa (pizza) AS
SELECT pizza
FROM Likes
WHERE cname = 'Alice'
EXCEPT
SELECT pizza
FROM Likes
WHERE cname = 'Bob'
;

-- Question b
-- For each customer, find the pizzas sold by restaurants that are located in the same area as the customer's area. 
-- Exclude customers whose associated set of pizzas is empty.
CREATE VIEW qb (cname, pizza) AS
SELECT DISTINCT cname, pizza
FROM Restaurants r  
     NATURAL JOIN 
     Sells s 
     NATURAL JOIN
     Customers c
;

-- Question c
-- For each customer, find the pizzas sold by restaurants that are located in the same area as the customer's area. 
-- Include customers whose associated set of pizzas is empty.
CREATE VIEW qc (cname, pizza) AS
SELECT DISTINCT cname, pizza
FROM Customers c 
     LEFT OUTER JOIN 
     Sells s 
     NATURAL JOIN
     Restaurants r
     ON c.area = r.area
;


-- Question d
-- Find pizzas that are sold by at most one restaurant in each area; exclude pizzas that are not sold by any restaurant. 
-- Do not use any UNIQUE subquery in your answer.
CREATE VIEW qd (pizza) AS
SELECT DISTINCT pizza
FROM Sells
EXCEPT
SELECT DISTINCT s1.pizza
FROM Restaurants r1, Restaurants r2, Sells s1, Sells s2
WHERE s1.pizza = s2.pizza
AND r1.rname = s1.rname
AND r2.rname = s2.rname
AND r1.rname <> r2.rname
AND r1.area = r2.area
;


-- Question e
-- Find all restaurant pairs (R1,R2) such that the price of the most expensive pizza sold by R1 is higher than that for R2.
CREATE VIEW qe (rname1, rname2) AS
SELECT r1.rname AS rname1, r2.rname AS rname2
FROM Restaurants r1, Restaurants r2
WHERE 
	(SELECT MAX(s1.price) FROM Sells s1 WHERE s1.rname = r1.rname) >
    (SELECT MAX(s2.price) FROM Sells s2 WHERE s2.rname = r2.rname)
;

-- Question f
-- Find the most expensive pizzas and the restaurants that sell them (at the most expensive price)。
-- Do not use any aggregate function in your answer.
CREATE VIEW qf (pizza, rname) AS
SELECT pizza, rname
FROM Sells
WHERE price >= ALL(SELECT price FROM Sells)
;

