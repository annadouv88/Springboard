
/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name 
FROM Facilities 
WHERE membercost != 0;

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) 
FROM Facilities 
WHERE membercost = 0;

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance 
FROM Facilities
WHERE membercost < .2*monthlymaintenance;


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT * 
FROM Facilities
WHERE facid IN (1,5);

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, 
	CASE 
		WHEN monthlymaintenance > 100 THEN 'expensive'
		ELSE 'cheap'
	END AS monthlymaintenance
FROM Facilities;


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM Members
ORDER BY joindate DESC;

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT f.name AS court_name, CONCAT(m.firstname,' ', m.surname) AS member_name

FROM Bookings as b
LEFT JOIN Members as m
ON b.memid = m.memid
LEFT JOIN Facilities as f
ON b.facid = f.facid

WHERE b.facid IN (SELECT facid 
			FROM Facilities 
			WHERE name LIKE 'Tennis Court%')

ORDER BY member_name;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name AS facility, CONCAT(m.firstname, ' ', m.surname) AS member_name,  CASE 
     WHEN b.memid = 0 THEN b.slots * f.guestcost
     ELSE b.slots * f.membercost
     END AS cost
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE DATE(b.starttime) = '2012-09-14' AND (CASE 
      WHEN b.memid = 0 AND (b.slots* f.guestcost > 30) THEN b.slots * f.guestcost
      WHEN b.memid != 0 AND (b.slots* f.membercost > 30) THEN b.slots * f.membercost
      END IS NOT NULL)
ORDER BY cost DESC

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT facility, member_name, cost 
FROM
	(SELECT f.name AS facility, 
		CONCAT(m.firstname, ' ', m.surname) AS member_name,  
 		CASE 
     			WHEN b.memid = 0 THEN b.slots * f.guestcost
     			ELSE b.slots * f.membercost
     			END AS cost,
 		DATE(b.starttime) as date
	FROM Bookings as b
	LEFT JOIN Facilities as f
	ON b.facid = f.facid
	LEFT JOIN Members as m
	ON b.memid = m.memid) AS subquery
WHERE date = '2012-09-14' AND cost >30
ORDER BY cost DESC;


