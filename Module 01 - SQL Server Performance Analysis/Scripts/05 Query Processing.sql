use AdventureWorks2008R2
go

-- ParseOnly
--		Note: authors table does not exist
set parseonly on
select lname, fname from authors
set parseonly off
go



-- Simplification Process - Contradiction Detection 
--		Note: HumanResources.Employee has a check constraint limiting VacationHours between -40 and 240
-- Compare both Execution Plans to see simplification
select * from HumanResources.Employee where VacationHours > 80

select * from HumanResources.Employee where VacationHours > 300
go

-- Logic contradiction gets simplified too
select * from HumanResources.Employee where VacationHours < 40 and VacationHours > 100
go

-- Simplification Process - Foreign Key Elimination
-- Compare both Execution Plans to see simplification
select soh.SalesOrderID, c.AccountNumber
from Sales.SalesOrderHeader			as soh
	join Sales.Customer				as c			on soh.CustomerID = c.CustomerID
	
select soh.SalesOrderID
from Sales.SalesOrderHeader			as soh
	join Sales.Customer				as c			on soh.CustomerID = c.CustomerID
go



-- Trivial vs Full Plan
-- In Execution Plan click on SELECT nodes and view Properties Window and Optimization Level Property
select * from Sales.SalesOrderDetail where SalesOrderID = 43659
select * from Sales.SalesOrderDetail where ProductID = 870
go



-- View information about Query Plan Optimizations
select * from sys.dm_exec_query_optimizer_info
go


