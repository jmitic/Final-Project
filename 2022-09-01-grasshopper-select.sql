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

-- select return flights after 3:00 PM
-- select * from flights where destination = 'GSP' and arrives > time('15:00:00');

-- Column used in an expression as a column.  Expression is used as column name.
-- select PlaneID, seats*1.2 from aircraft;

-- Column used in an expression as a column, with a function and a specified name for the new column.
-- select PlaneID, round(seats*1.2) as SeatsToSell from aircraft;

-- The column expression can be arbitrarily complicated.
-- select PlaneID, 
-- case when (round(seats*1.2) < seats*1.20) then round(seats*1.2) else (round(seats*1.2)-1) end as SeatsToSell
-- from aircraft;

-- Outer join (keep the airplane that has no flights).  
-- This example also uses a compound condition in the WHERE clause.
-- select distinct Aircraft.PlaneID, Model, Destination
-- from aircraft left join Flights on aircraft.planeid = flights.planeid
-- where origin = 'GSP' or origin is NULL;

-- 3-way join.  Show the airplanes assigned to the flights (and dates) for which
-- tickets have been sold.
-- Use ORDER BY to sort the results by date and flight number.
-- select distinct Aircraft.PlaneID, Flights.FltNum, FltDate
-- from (Flights natural join Aircraft) natural join Bookings
-- order by FltDate, FltNum;

-- 4-way join.  Add the passenger names to the preceding query.
-- select Aircraft.PlaneID, Flights.FltNum, FltDate, FirstName, LastName
-- from ((Flights natural join Aircraft) natural join Bookings) natural join Passengers
-- order by FltDate, FltNum, LastName;

-- Self-join.  Find the folks who are flying more than once on a given day.
-- Output isn't correct on ExtendsClass browser, but is right on SQL Online IDE.
select B1.FltDate, B2.Fltdate, B1.FltNum, B2.FltNum, B1.PsgrID, B2.PsgrID
from Bookings B1 inner join Bookings B2 
on (B1.FltDate = B2.FltDate and B1.PsgrID = B2.PsgrID)
where B1.FltNum < B2.FltNum
order by B1.FltDate, B1.FltNum;