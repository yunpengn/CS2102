-- Question 1
WITH PresentTimes AS (
	SELECT stuid, COUNT(*) AS times
	FROM Presenters
	GROUP BY stuid)
SELECT s.name
FROM Students AS s, PresentTimes as p
WHERE s.stuid = p.stuid
AND p.times = (
	SELECT MAX(times)
	FROM PresentTimes
);

-- Question 2
SELECT p1.stuid, p2.stuid
FROM Presenters p1, Presenters p2
WHERE p1.stuid < p2.stuid
GROUP BY p1.stuid, p2.stuid
HAVING COUNT(*) >= 5;

-- Question 3
SELECT s.name
FROM Students s
WHERE NOT EXISTS (
	SELECT 1
	FROM Presenters p1, Presenters p2, Presenters p3
	WHERE p1.stuid = s.stuid
	AND p2.stuid = s.stuid
	AND p3.stuid = s.stuid
	AND p1.week = p2.week - 1
	AND p2.week = p3.week - 1
);

-- Question 4
WITH PresenterPriority AS (
	SELECT s.name, 
		   (SELECT MAX(week) 
		   	FROM Presenters p1
		   	WHERE p1.stuid = s.stuid) AS lastWeek,
		   (SELECT COUNT(*) 
		   	FROM Presenters p1
		   	WHERE p1.stuid = s.stuid) AS numOfQuestions
	FROM Students)
SELECT name
FROM PresenterPriority
ORDER BY numOfQuestions, lastWeek, name ASC
LIMIT 2;
