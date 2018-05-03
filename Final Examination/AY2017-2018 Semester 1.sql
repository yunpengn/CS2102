DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;

CREATE TABLE product (
 	pid INT PRIMARY KEY,
 	pname varchar(255),
 	pdesc varchar(500)
);

CREATE TABLE customer (
 	cid INT PRIMARY KEY,
 	cname varchar(255),
 	country varchar(255)
);

CREATE TABLE orders (
 	pid INT REFERENCES product(pid),
 	cid INT REFERENCES customer(cid),
 	qty INT
);

INSERT INTO customer VALUES (1, 'Agus Suparman', 'Indonesia');
INSERT INTO customer VALUES (2, 'Dewi Rendra', 'Indonesia');
INSERT INTO customer VALUES (3, 'Made Wijiya', 'Indonesia');
INSERT INTO customer VALUES (4, 'Tan Wee Siong', 'Singapore');
INSERT INTO customer VALUES (5, 'Siti Bte Mohamad', 'Singapore');

INSERT INTO product VALUES (1, 'pen', 'A pen.');
INSERT INTO product VALUES (2, 'apple', 'This is not a MacBook.');
INSERT INTO product VALUES (3, 'pizza', 'Very delicious.');

INSERT INTO orders VALUES (1, 1, 100);
INSERT INTO orders VALUES (1, 5, 10);
INSERT INTO orders VALUES (2, 5, 50);
INSERT INTO orders VALUES (3, 4, 5);

SELECT c.country, (CASE 
	WHEN (SELECT 1 FROM orders o1 WHERE o1.cid IN (
		SELECT cid FROM customer c2 WHERE c2.country = c.country)) IS NOT NULL
	THEN (SELECT SUM(o2.qty) FROM orders o2 WHERE o2.cid IN (
		SELECT cid FROM customer c3 WHERE c3.country = c.country))
	ELSE 0
	END
) AS total_quantity
FROM customer c
GROUP BY(c.country);

SELECT c.cname
FROM customer c LEFT OUTER JOIN orders o
ON c.cid = o.cid
WHERE c.country = 'Indonesia' AND o.cid IS NULL;

SELECT c.cname
FROM customer c LEFT OUTER JOIN orders o
ON c.cid = o.cid AND c.country = 'Indonesia'
WHERE o.cid IS NULL;
