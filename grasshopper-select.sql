-- Plain SELECT.  List all the aircraft.
-- select * from aircraft;

-- Projection, no restriction (gives 2 identical rows)
-- select manufacturer, model from aircraft;

-- Restriction, no projection
-- select * from aircraft
-- where seats < 25;

-- Restriction using exact string matching
-- select * from aircraft where manufacturer = 'British Aerospace';

-- Restriction using inexact string matching (manufacturer starts with 'B')
-- select * from aircraft where manufacturer like 'B%';

-- Restriction using inexact string matching (single-character wildcard)
-- select * from aircraft where model like 'DC-_';

-- Aircraft assigned to flights (join between Aircraft and Flights)
-- select *
-- from aircraft natural join flights;

-- Aircraft assigned to flights, just Origin and Destination from Flights
-- Lots of repeated values.
-- select Aircraft.PlaneID, Model, Origin, Destination
-- from aircraft natural join Flights;

-- Aircraft assigned to flights, just Origin and Destination from Flights
-- Use DISTINCT to suppress repeats.
-- select distinct Aircraft.PlaneID, Model, Origin, Destination
-- from aircraft natural join Flights;

-- Aircraft assigned to flights, just Destination from Flights,
-- outbound only.  Use DISTINCT to suppress repeats.
-- select distinct Aircraft.PlaneID, Model, Destination
-- from aircraft natural join Flights
-- where Origin = 'GSP';

-- time: select return flights after 3:00 PM
-- select * from flights where destination = 'GSP' and arrives > time('15:00:00');

-- date: select the bookings between 3/1/2022 and 3/3/2022
-- select * from bookings where FltDate > date('2021-02-28') and FltDate < date('2021-03-04');
-- The point of using the date() function is that I don't have to care how sqlite stores
-- date values

-- BETWEEN: can be used for dates, strings, etc.  It *includes* both endpoints.
-- Same query as above
-- select * from bookings where FltDate between date('2021-03-01') and date('2021-03-02');

-- Joins: select the first and last names, aircraft model, flight number, and flight date of all
-- passengers scheduled to fly on 3/2
-- select FirstName, LastName, Model, Flights.FltNum, FltDate
-- from ((passengers natural join bookings) natural join Flights) natural join aircraft
-- -- "natural join" join operator doesn't need the join condition specified
-- where FltDate = date('2021-03-02')
-- order by LastName, Departs;

-- Joins: same query, cross-product style.  Join conditions go in WHERE clause
-- select FirstName, LastName, Model, Flights.FltNum, FltDate
-- from passengers, bookings, flights, aircraft
-- where passengers.PsgrID = bookings.PsgrID
--       and bookings.FltNum = flights.FltNum
--       and aircraft.PlaneID = Flights.PlaneID
--       and FltDate = date('2021-03-02')
-- order by LastName, Departs;

-- Joins: same query, join operator style using INNER JOIN.
-- select FirstName, LastName, Model, Flights.FltNum, FltDate
-- from ((passengers inner join bookings on passengers.PsgrID = bookings.PsgrID)
-- 	   inner join flights on flights.FltNum = bookings.FltNum)
--       inner join aircraft on aircraft.PlaneID = flights.PlaneID
-- where FltDate = date('2021-03-02')
-- order by LastName, Departs;

-- Left join: select all the aircraft with flights, being sure to keep all the aircraft
-- select aircraft.PlaneID, Model, FltNum
-- from aircraft left join flights on aircraft.PlaneID = flights.PlaneID
-- order by FltNum;

