use AdventureWorks2008R2
go

-- How many rows in each table
select count(*) from HumanResources.Employee		-- 290 rows
select count(*) from Sales.SalesPerson				--  17 rows

-- Nested Loop Join
--		Note: Top Input (Clustered Index Scan) is Outer Input and Bottom Input (Clustered Index Seek) is Inner Input
--			Number Of Executions: Outer Input fired once, Inner Input fired 17 times
select e.BusinessEntityID, TerritoryID
from HumanResources.Employee		as e
	join Sales.SalesPerson			as sp		on e.BusinessEntityID = sp.BusinessEntityID
go
-- Nested Loop Join - Reverse Table Order
select e.BusinessEntityID, TerritoryID
from Sales.SalesPerson				as sp
	join HumanResources.Employee	as e		on e.BusinessEntityID = sp.BusinessEntityID
go

-- Nested Loop Join with filter
select e.BusinessEntityID, TerritoryID
from HumanResources.Employee		as e
	join Sales.SalesPerson			as sp		on e.BusinessEntityID = sp.BusinessEntityID
where TerritoryID = 1
go

-- Merge Join
select soh.SalesOrderID, sod.SalesOrderDetailID, OrderDate
from Sales.SalesOrderHeader			as soh
	join Sales.SalesOrderDetail		as sod		on soh.SalesOrderID = sod.SalesOrderID
go

-- Hash Join
select soh.SalesOrderID, sod.SalesOrderDetailID
from Sales.SalesOrderHeader			as soh
	join Sales.SalesOrderDetail		as sod		on soh.SalesOrderID = sod.SalesOrderID
go

-- Force Different Join Operators
-- Force Nested Loops to Merge Join
select e.BusinessEntityID, TerritoryID
from Sales.SalesPerson				as sp
	join HumanResources.Employee	as e		on e.BusinessEntityID = sp.BusinessEntityID
go
select e.BusinessEntityID, TerritoryID
from Sales.SalesPerson				as sp
	join HumanResources.Employee	as e		on e.BusinessEntityID = sp.BusinessEntityID
option (merge join)
go

-- Force Merge Join to Hash Join
select soh.SalesOrderID, sod.SalesOrderDetailID, OrderDate
from Sales.SalesOrderHeader			as soh
	join Sales.SalesOrderDetail		as sod		on soh.SalesOrderID = sod.SalesOrderID
go
select soh.SalesOrderID, sod.SalesOrderDetailID, OrderDate
from Sales.SalesOrderHeader			as soh
	join Sales.SalesOrderDetail		as sod		on soh.SalesOrderID = sod.SalesOrderID
option (hash join)
go

-- Force Hash Join to Nested Loops
select soh.SalesOrderID, sod.SalesOrderDetailID
from Sales.SalesOrderHeader			as soh
	join Sales.SalesOrderDetail		as sod		on soh.SalesOrderID = sod.SalesOrderID
go
select soh.SalesOrderID, sod.SalesOrderDetailID
from Sales.SalesOrderHeader			as soh
	join Sales.SalesOrderDetail		as sod		on soh.SalesOrderID = sod.SalesOrderID
option (loop join)
go

-- Outer Joins (Try each with right, left, and full outer join)
select e.BusinessEntityID, TerritoryID
from HumanResources.Employee					as e
	right outer join Sales.SalesPerson			as sp		on e.BusinessEntityID = sp.BusinessEntityID
go

select soh.SalesOrderID, sod.SalesOrderDetailID, OrderDate
from Sales.SalesOrderHeader						as soh
	right outer join Sales.SalesOrderDetail		as sod		on soh.SalesOrderID = sod.SalesOrderID
go

select soh.SalesOrderID, sod.SalesOrderDetailID
from Sales.SalesOrderHeader						as soh
	right outer join	Sales.SalesOrderDetail		as sod		on soh.SalesOrderID = sod.SalesOrderID
go