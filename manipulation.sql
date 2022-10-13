-- Question 5
-- Use a four-way join to list the course code, school name, and requirement code (ARC_code)
-- for all the courses Converse accepts from Spartanburg Methodist that satisfy a CSC 
-- requirement (ARC_code starts with "CSC").

-- select crs_code, schoolName, ARC_code -- , Equivalence.*
-- from Course inner join Institution on Course.instID = Institution.id
--             inner join Equivalence on Equivalence.ForeignID = Course.id
--             inner join Reqt on Equivalence.ReqtID = Reqt.id
-- where schoolName like 'Spartanburg Methodist%' and ARC_code like 'CSC%';


-- Delete the duplicate rows from Equivalence, querying first to find the ID's
-- Be careful!  With great power comes great responsibility.
-- delete from Equivalence where id=1444 or id=1445;

-- How many duplicate rows are really in Equivalence?
-- select E1.id, E1.ForeignID, E1.ReqtID, E1.ConverseID, E2.id, E2.ForeignID, E2.ReqtID, E2.ConverseID
-- from Equivalence E1 inner join Equivalence E2 on E1.ForeignID = E2.ForeignID
		-- and E1.ConverseID = E2.ConverseID and E1.ReqtID = E2.ReqtID
-- where E1.id > E2.id;  -- why in the world does this not work to ensure different rows in E1 and E2?

-- Insert a new school into Institution (VCOM)
-- Note it does not specify id.  That is automatically generated (autoincrement)
-- Columns are specified out of order, which is OK as long as the values are given
--    in the *same* order as the columns are specified
-- insert into Institution (schoolName, orgCode, address, city, schoolState, zip) 
-- 	values ('Edward Via College of Osteopathic Medicine', '**VCOM**', '350 Howard St.',
--            'Spartanburg', 'SC', '29303');

-- Check and make sure it worked!
-- select * from Institution
-- where schoolName like '%Medicine';

-- Update: change Converse College to Converse University
-- update Institution set schoolName='Converse University' where schoolName='Converse College';
-- Check the WHERE clause beforehand (and also afterwards to check)
-- select * from Institution where schoolName='Converse University';

-- CSC 492
-- select for checking both before insertion and after insertion
-- select * from Course where crs_code = 'CSC492';
-- what is the institution ID for Converse?
-- select * from Institution where schoolName like 'Converse%';
-- insert into Course (crs_code, crs_name, hours, instID)
--      values('CSC492', 'Computer Science Capstone', 3, 1);

-- Converse CSC courses
-- select * from Course where crs_code like 'CSC%';
-- update Course set crs_name='Web Programming I' where crs_code='CSC235';
-- update Course set crs_name='Algorithm Design' where crs_code='CSC203' and instID = 1;