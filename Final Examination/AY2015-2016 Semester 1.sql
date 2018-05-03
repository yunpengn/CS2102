# 1516 SEM2 PYP
CREATE TABLE warehouse(
	wid INT PRIMARY KEY,
	city VARCHAR(60)
);

CREATE TABLE product(
	pid VARCHAR(60),
	name VARCHAR(70),
	category VARCHAR(70),
	PRIMARY KEY(pid)
);

CREATE TABLE stock(
	wid INT REFERENCES warehouse(wid),
	pid VARCHAR(60) REFERENCES product(pid),
	qty INT,
	PRIMARY KEY(wid, pid)
);

# Exercise 2
INSERT INTO warehouse VALUES(1, 'Fuzhou');
INSERT INTO warehouse VALUES(2, 'Fuzhou');
INSERT INTO warehouse VALUES(3, 'Fuzhou');
INSERT INTO warehouse VALUES(4, 'Beijing');
INSERT INTO warehouse VALUES(5, 'Singapore');
INSERT INTO warehouse VALUES(6, 'Shanghai');
INSERT INTO warehouse VALUES(7, 'Shanghai');
INSERT INTO warehouse VALUES(8, 'London');

# Q11
SELECT DISTINCT w.city
FROM warehouse w
GROUP BY w.city
HAVING COUNT(*) >= 2;

# Q13
INSERT INTO product VALUES('X213', 'haha', 'monitor');
INSERT INTO product VALUES('X214', 'paris', 'monitor');
INSERT INTO product VALUES('X215', 'apple', 'fruit');

INSERT INTO stock VALUES(1, 'X213', 3);
INSERT INTO stock VALUES(2, 'X213', 4);
INSERT INTO stock VALUES(3, 'X213', 5);
INSERT INTO stock VALUES(4, 'X213', 6);
INSERT INTO stock VALUES(5, 'X213', 7);
INSERT INTO stock VALUES(6, 'X213', 8);
INSERT INTO stock VALUES(7, 'X213', 8);
INSERT INTO stock VALUES(8, 'X214', 8);

INSERT INTO stock VALUES(1, 'X215', 50);
INSERT INTO stock VALUES(2, 'X215', 60);
UPDATE stock
SET qty = 50
WHERE wid = 6 AND pid = 'X213';
INSERT INTO stock VALUES(7, 'X214', 60);
INSERT INTO stock VALUES(5, 'X214', 60);
INSERT INTO stock VALUES(4, 'X214', 110);



SELECT s.wid 
FROM stock s
WHERE s.pid = 'X213' 
AND s.qty >= ALL(SELECT s1.qty FROM stock s1
				WHERE s1.pid = 'X213');

#Q14, expected 'haha'

SELECT p.name
FROM product p
WHERE p.pid NOT IN (SELECT s.pid
					FROM stock s, warehouse w
					WHERE s.wid = w.wid
					AND w.city = 'London');

#Q15, expected 'Beijing' AND 'Shanghai'

SELECT w.city
FROM warehouse w, stock s, product p
WHERE p.category = 'monitor' AND s.wid = w.wid
AND s.pid = p.pid
GROUP BY w.wid  # wrong here, don't need to group by 's.qty', even it is used in SUM notation
HAVING SUM(s.qty) >= 100;


