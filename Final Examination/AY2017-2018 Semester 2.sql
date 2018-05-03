DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Profs;
DROP TABLE IF EXISTS Offerings;
DROP TABLE IF EXISTS Enrolls;

CREATE TABLE Students (
	sid integer PRIMARY KEY,
	sname varchar(50) NOT NULL,
	major varchar(50) NOT NULL
);

CREATE TABLE Courses (
	cid integer PRIMARY KEY,
	cname varchar(50) NOT NULL,
	cdept varchar(50) NOT NULL
);

CREATE TABLE Profs (
	pid integer PRIMARY KEY,
	pname varchar(50) NOT NULL,
	pdept varchar(50) NOT NULL
);

CREATE TABLE Offerings (
	semester integer CHECK (semester IN (1, 2, 3, 4, 5, 6, 7, 8)),
	cid integer,
	pid integer NOT NULL,
	PRIMARY KEY (semester, cid),
	FOREIGN KEY (pid) REFERENCES Profs(pid),
	FOREIGN KEY (cid) REFERENCES Courses(cid)
);

CREATE TABLE Enrolls (
	sid integer,
	cid integer,
	semester integer,
	score integer NOT NULL,
	PRIMARY KEY (sid, cid, semester),
	FOREIGN KEY (sid) REFERENCES Students(sid),
	FOREIGN KEY (semester, cid) REFERENCES Offerings(semester, cid)
);
