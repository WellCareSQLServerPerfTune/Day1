use AdventureWorks2008R2
go

-- Stream Aggregate (Scalar Aggregate)
--		Note: Click on Computer Scalar and Stream Aggregate Operators and 
--			view Defined Values in the Properties Window
select avg(ListPrice) from Production.Product
go
-- Stream Aggregate (Group Aggregate)
--		Note: Sort now required since Stream Aggregate requires sorting by group
select ProductLine, avg(ListPrice) from Production.Product group by ProductLine
go
-- Stream Aggregate with Data Pre-Sorted (SalesOrderID is a PK)
select SalesOrderID, avg(OrderQty) from Sales.SalesOrderDetail group by SalesOrderID
go

-- Hash Aggregate
select TerritoryID, count(*) from Sales.SalesOrderHeader group by TerritoryID
go
-- Hash Aggregate and Sort
select TerritoryID, count(*) from Sales.SalesOrderHeader group by TerritoryID order by TerritoryID
go

-- Stream Aggregate and Force Hash Aggregate with query hint
--		Note: Compare both Execution Plans to one another
select ProductLine, avg(ListPrice) from Production.Product group by ProductLine
go
select ProductLine, avg(ListPrice) from Production.Product group by ProductLine
option (hash group)
go

-- Hash Aggregate and Force Stream Aggregate with query hint
--		Note: Compare both Execution Plans to one another
select TerritoryID, count(*) from Sales.SalesOrderHeader group by TerritoryID
go
select TerritoryID, count(*) from Sales.SalesOrderHeader group by TerritoryID
option(order group)
go

-- Distinct Sort
select distinct(JobTitle) from HumanResources.Employee
go
select JobTitle from HumanResources.Employee group by JobTitle
go

-- Stream Aggregate used because of index
create index IX_JobTitle on HumanResources.Employee(JobTitle)
select distinct(JobTitle) from HumanResources.Employee
drop index HumanResources.Employee.IX_JobTitle
go

-- Hash Aggregate may be used for bigger tables
select distinct(TerritoryID) from Sales.SalesOrderHeader
go