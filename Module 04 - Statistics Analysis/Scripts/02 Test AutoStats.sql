use AdventureWorks2008R2
go

-- Create Test Schema
create Schema Test
go

-- Create Test.Product with No Rows
select * 
into Test.Person
from Person.Person
where BusinessEntityID = 0

select * from Test.Person

-- Create Indexes
create clustered index PK_Person_BusinessEntityID
on Test.Person(BusinessEntityID)

create nonclustered index IX_Person_LastName
on Test.Person(LastName)

-- Views Stats in Object Explorer, Details has no stats
dbcc show_statistics ('Test.Person', PK_Person_BusinessEntityID)
dbcc show_statistics ('Test.Person', IX_Person_LastName)

-- Add Some Rows
insert into Test.Person
	select * from Person.Person

-- Views Stats in Object Explorer, Details has no stats
dbcc show_statistics ('Test.Person', PK_Person_BusinessEntityID)
dbcc show_statistics ('Test.Person', IX_Person_LastName)

-- Turn Off Auto Update of Stats
exec sp_autostats 'Test.Person', 'Off'

-- Cause Auto-Update to Happen, Turn on Execution Plan
-- View Estimated Rows vs Actual Rows
select * 
from Test.Person
where LastName = 'Diaz'

-- Views Stats in Object Explorer, Details has no stats
dbcc show_statistics ('Test.Person', PK_Person_BusinessEntityID)
dbcc show_statistics ('Test.Person', IX_Person_LastName)

-- Try Again with Autostats turned back on
exec sp_autostats 'Test.Person', 'On'

-- Clean Up
drop table Test.Person
drop schema Test