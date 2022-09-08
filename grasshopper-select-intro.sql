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
select * from flights where destination = 'GSP' and arrives > time('15:00:00');