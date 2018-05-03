DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS registration CASCADE;

CREATE TABLE customer (
	cid INT PRIMARY KEY,
	cname VARCHAR(13),
	ccity VARCHAR(13)
);

CREATE TABLE event (
	eid INT PRIMARY KEY,
	ename VARCHAR(13),
	ecity VARCHAR(13)
);

CREATE TABLE registration (
	cid INT REFERENCES customer(cid) ON UPDATE CASCADE ON DELETE CASCADE,
	eid INT REFERENCES event(eid) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(eid, cid)
);

INSERT INTO customer VALUES(1, 'FYT', 'SG');
INSERT INTO customer VALUES(2, 'FYH', 'SG');
INSERT INTO customer VALUES(3, 'FYJ', 'SG');
INSERT INTO customer VALUES(4, 'FYQ', 'SG');
INSERT INTO customer VALUES(5, 'FYK', 'Paris');

INSERT INTO event VALUES(1, 'drink', 'SG');
INSERT INTO event VALUES(2, 'eat', 'BG');
INSERT INTO event VALUES(3, 'eat', 'SG');
INSERT INTO event VALUES(4, 'eat', 'SG');
INSERT INTO event VALUES(5, 'eat', 'SG');
INSERT INTO event VALUES(6, 'eat', 'HA');
INSERT INTO event VALUES(7, 'eat', 'HA');
INSERT INTO event VALUES(8, 'eat', 'HA');
INSERT INTO event VALUES(9, 'eat', 'HA');
INSERT INTO event VALUES(10, 'draw', 'London');
INSERT INTO event VALUES(11, 'see', 'London');
INSERT INTO event VALUES(12, 'jump', 'Paris');

INSERT INTO registration VALUES(1, 1);
INSERT INTO registration VALUES(1, 3);
INSERT INTO registration VALUES(1, 4);
INSERT INTO registration VALUES(1, 5);
INSERT INTO registration VALUES(1, 12);
INSERT INTO registration VALUES(2, 1);
INSERT INTO registration VALUES(3, 2);
INSERT INTO registration VALUES(4, 2);
INSERT INTO registration VALUES(4, 10);
INSERT INTO registration VALUES(5, 10);
INSERT INTO registration VALUES(4, 11);
INSERT INTO registration VALUES(3, 11);
INSERT INTO registration VALUES(5, 12);

-- Question 11
SELECT cname -- DISTINCT is optional here, depending on how you interpreted the question.
FROM customer NATURAL JOIN registration NATURAL JOIN event
WHERE ccity = ecity;

-- Question 13
With EventTimes AS (
	SELECT e.ecity, COUNT(*) AS times
	FROM event e
	GROUP BY e.ecity)
SELECT DISTINCT e.ecity
FROM EventTimes e
WHERE e.times >= ALL (SELECT times FROM EventTimes);
-- Alternative solution
With EventTimes AS (
	SELECT e.ecity, COUNT(*) AS times
	FROM event e
	GROUP BY e.ecity
), EventTimesMax AS (
	SELECT max(times) AS max
	FROM EventTimes
)
SELECT e.ecity
FROM event e, EventTimesMax max
GROUP BY e.ecity, max.max
HAVING COUNT(*) = max.max;

-- Question 14
SELECT e.ename
FROM event e
WHERE e.ecity = 'London'
AND NOT EXISTS (SELECT * FROM registration r, customer c
				WHERE r.eid = e.eid
				AND r.cid = c.cid
				AND c.ccity = 'Paris');

-- Question 15
SELECT cname
FROM customer NATURAL JOIN registration
GROUP BY cid
HAVING COUNT(*) = (
	SELECT COUNT(*) 
	FROM event 
	WHERE ecity = ccity
);
