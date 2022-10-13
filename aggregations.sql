-- How many bookings do we have, by date?
-- select FltDate, count(*) as NumBookings
-- from Bookings
-- group by FltDate;

-- How many bookings do we have, by flight?
-- select FltNum, count(*) as NumBookings
-- from Bookings
-- group by FltNum;

-- Join with aggregation
-- How many bookings do we have, by flight and time of day?
-- select FltNum, Departs, count(*) as NumBookings
-- from Bookings natural join Flights
-- where Departs > time('08:59:00')
-- group by FltNum, Departs
-- order by Departs;

-- Join with aggregation, HAVING, sorting on the aggregated column
-- Who are our most frequent fliers?
-- select FirstName, LastName, count(*) as NumFlights
-- from Bookings natural join Passengers
-- group by FirstName, LastName
-- having NumFlights > 4
-- order by NumFlights desc, LastName, FirstName;

-- Aggregation functions other than COUNT
-- What's the most seats on any Grasshopper airplane?
-- select max(Seats) as MaxSeats
-- from Aircraft;

-- Aggregation functions other than COUNT
-- What's the least number of seats on any Grasshopper airplane?
-- select min(Seats) as MinSeats
-- from Aircraft;

-- SELF-JOINS
-- Find the flights that connect with other flights
select F1.FltNum as Flight1, F1.Arrives as Arrives, F1.Destination as Airport,
       F2.Departs as Departs, F2.FltNum as Flight2
from Flights F1 inner join Flights F2 on F1.Destination = F2.Origin
where F1.Arrives < F2.Departs;
