use AdventureWorks2008R2
go

select * from HumanResources.Employee
where Gender = 'F'

-- Create Index on Gender
create index IX_Employee_Gender
on HumanResources.Employee(Gender)

-- View Stats | Details
dbcc show_statistics ('HumanResources.Employee', IX_Employee_Gender)

-- Clean Up
drop index IX_Employee_Gender
on HumanResources.Employee

