use AdventureWorks2008R2
go

-- Enable Time and IO Statistics
set statistics time on
set statistics io on
go

-- Clear Buffer and Procedure Caches
checkpoint
go
dbcc dropcleanbuffers
dbcc freeproccache
go

select p.ProductID, p.Name, sod.UnitPrice * sod.OrderQty as [Total Price]
from Sales.SalesOrderDetail			as sod
	join Production.Product			as p		on sod.ProductID = p.ProductID
where sod.ProductID = 745
go

-- Disable Time and IO Statistics
set statistics time off
set statistics io off
go