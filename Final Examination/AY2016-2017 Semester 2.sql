DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS asset;
DROP TABLE IF EXISTS workfor;
DROP TABLE IF EXISTS assignment;

CREATE TABLE staff (
	sid INT PRIMARY KEY,
	sname varchar(255)
);

CREATE TABLE project (
	pid INT PRIMARY KEY,
	pdesc varchar(500),
	pfrom date,
	pto date
);

CREATE TABLE asset (
	aid INT PRIMARY KEY,
	acat varchar(255),
	adesc varchar(500)
);

CREATE TABLE workfor (
	sid INT REFERENCES staff(sid),
	pid INT REFERENCES project(pid),
	wfrom date,
	wto date,
	PRIMARY KEY (sid, pid)
);

CREATE TABLE assignment (
	aid INT REFERENCES asset(aid),
	sid INT REFERENCES staff(sid),
	pid INT REFERENCES project(pid),
	afrom date,
	ato date,
	PRIMARY KEY (aid, sid, pid)
);

-- Question 2
SELECT s.sname, COUNT(w.pid)
FROM staff s NATURAL JOIN workfor w
WHERE w.wfrom > '2017-03-01' AND w.wto < '2017-04-01'
GROUP BY (s.sname, w.pid)
HAVING COUNT(w.pid) > 20;
