
-- CS2102 Assignment 3

DROP VIEW IF EXISTS q1, q2, q3, q4, q5, q6, q7, q8, q9, q10;
DROP VIEW IF EXISTS qa, qb, qc, qd, qe, qf, qg, qh, qi, qj;
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Sells;
DROP TABLE IF EXISTS Restaurants;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Pizzas;

CREATE TABLE Pizzas (
	pizza 			VARCHAR(50),
	PRIMARY KEY (pizza)
);

CREATE TABLE Restaurants (
	rname 			VARCHAR(50),
	area			VARCHAR(10),
	PRIMARY KEY (rname)
);


CREATE TABLE Customers (
	cname 			VARCHAR(50),
	area			VARCHAR(10),
	PRIMARY KEY (cname)
);

CREATE TABLE Sells (
	rname 			VARCHAR(50),
	pizza			VARCHAR(50),
	price			INTEGER,
	PRIMARY KEY (rname,pizza),
	FOREIGN KEY (rname) REFERENCES Restaurants (rname),
	FOREIGN KEY (pizza) REFERENCES Pizzas (pizza)
);

CREATE TABLE Likes (
	cname 			VARCHAR(50),
	pizza			VARCHAR(50),
	PRIMARY KEY (cname,pizza),
	FOREIGN KEY (cname) REFERENCES Customers (cname),
	FOREIGN KEY (pizza) REFERENCES Pizzas (pizza)
);


