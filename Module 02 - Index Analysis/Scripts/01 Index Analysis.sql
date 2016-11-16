use AdventureWorks2008R2
go

-- Missing Index Message in Execution Plan tab
select PurchaseOrderNumber, OrderDate, ShipDate, SalesPersonID
from Sales.SalesOrderHeader
where PurchaseOrderNumber like 'PO5%' and SalesPersonID is not null
go

-- Create Schema
create schema Test
go

-- Create Heap Table
select *
into Test.SalesOrderHeader
from Sales.SalesOrderHeader
go


-- Query to test index performance
--		Suggestion: Move this to another query window for easy execution
--		Note: Inital data access operator is a table scan
--		Note: 781 Logical Reads 
set statistics io on
set statistics time on
go

select PurchaseOrderNumber, OrderDate, ShipDate, SalesPersonID
from Test.SalesOrderHeader
where PurchaseOrderNumber like 'PO5%' and SalesPersonID is not null

set statistics io off
set statistics time off
go


-- Add Non-Clustered Index
--		Note: Nothing changed with execution plan or logical reads
create index IX_SalesOrderHeader_PurchaseOrderNumber 
on Test.SalesOrderHeader(PurchaseOrderNumber)

drop index Test.SalesOrderHeader.IX_SalesOrderHeader_PurchaseOrderNumber

-- Add Composite Non-Clustered Index
--		Note: Using Non-Clustered Index now with RID Lookup
--		Note: 255 Logical Reads 
create index IX_SalesOrderHeader_PurchaseOrderNumber_SalesPersonID
on Test.SalesOrderHeader(PurchaseOrderNumber, SalesPersonID)



-- Add Clustered Index
--		Note: Using Non-Clustered Index now with Key Lookup
--		Note: 778 Logical Reads 
--		Note: What happened?  For each Key Lookup not only have to read single data page, but also branch pages
create clustered index IX_SalesOrderHeader_SalesOrderID
on Test.SalesOrderHeader(SalesOrderID)

drop index Test.SalesOrderHeader.IX_SalesOrderHeader_SalesOrderID

-- Add Unique Clustered Index
--		Note: Still 778 Logical Reads, no change
create unique clustered index IX_SalesOrderHeader_SalesOrderID
on Test.SalesOrderHeader(SalesOrderID)

drop index Test.SalesOrderHeader.IX_SalesOrderHeader_SalesOrderID

-- Add PK Constraint which by default adds Clustered Index
--		Note: Still 778 Logical Reads, no change
alter table Test.SalesOrderHeader
add constraint PK_SalesOrderHeader_SalesOrderID primary key (SalesOrderID)



drop index Test.SalesOrderHeader.IX_SalesOrderHeader_PurchaseOrderNumber_SalesPersonID

-- Covering Index
--		Note: 5 Logical Reads, Getting Better
--		Note: Execution plan only using this NonClustered Index
create index IX_SalesOrderHeader_PurchaseOrderNumber_SalesPersonID_OrderDate_ShipDate
on Test.SalesOrderHeader(PurchaseOrderNumber, SalesPersonID)
include (OrderDate, ShipDate)

drop index Test.SalesOrderHeader.IX_SalesOrderHeader_PurchaseOrderNumber_SalesPersonID_OrderDate_ShipDate

-- Filtered Index
--		Note: 4 Logical Reads, Boom!
create index IX_SalesOrderHeader_PurchaseOrderNumber_SalesPersonID_OrderDate_ShipDate_Filtered
on Test.SalesOrderHeader(PurchaseOrderNumber, SalesPersonID)
include (OrderDate, ShipDate)
where PurchaseOrderNumber is not null and SalesPersonID is not null


 -- Cleanup 
 drop table Test.SalesOrderHeader
 drop schema Test