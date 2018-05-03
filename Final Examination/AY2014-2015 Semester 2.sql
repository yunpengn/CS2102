CREATE TABLE person(
	pid INT PRIMARY KEY,
	pname VARCHAR(13),
	pcity VARCHAR(13)
);

CREATE TABLE company(
	cid INT PRIMARY KEY,
	cname VARCHAR(13),
	ccity VARCHAR(13)
);

CREATE TABLE workfor(
	pid INT REFERENCES person(pid),
	cid INT REFERENCES company(cid),
	PRIMARY KEY(pid, cid)
);

INSERT INTO person VALUES(1, 'haha', 'SG');
INSERT INTO person VALUES(2, 'haha', 'SG');
INSERT INTO person VALUES(3, 'haha', 'SG');
INSERT INTO person VALUES(4, 'haha', 'SG');
INSERT INTO person VALUES(5, 'haha', 'SG');
INSERT INTO company VALUES(1, 'FYT', 'SG');

INSERT INTO workfor VALUES(1, 1);
INSERT INTO workfor VALUES(2, 1);
INSERT INTO workfor VALUES(3, 1);
INSERT INTO workfor VALUES(4, 1);
INSERT INTO workfor VALUES(5, 1);

# selected: 1,2
# expected: 1
INSERT INTO company VALUES(2, 'YQS', 'SG');
INSERT INTO company VALUES(3, 'YQSS', 'SG');
INSERT INTO workfor VALUES(1, 2);
INSERT INTO workfor VALUES(2, 3);



UPDATE person
SET pcity = 'BG'
WHERE pid = 3;

#CORRECT ANSWER
SELECT c.cid 
FROM company c
WHERE c.ccity = ALL(
SELECT p.pcity
FROM workfor w, person p
WHERE c.cid = w.cid
AND w.pid = p.pid
);

#WRONG MEANING BUT CORRECT ANSWER
SELECT c.ccid
FROM company c, person p, workfor w
WHERE c.cid = w.cid 
AND w.pid = p.pid
GROUP BY c.cid
HAVING COUNT(DISTINCT p.pcity) = 1;

#
