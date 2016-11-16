use AdventureWorks2008R2
go

-- Parallel Query
select ProductID, COUNT(*)
from Sales.SalesOrderDetailEnlarged
group by ProductID
go

-- Disable Parallelism
--		Note: With SS2012+ There is a NonParallelPlanReason property on the SELECT node
exec sp_configure 'show advanced options', 1;  
reconfigure with override  
exec sp_configure 'max degree of parallelism', 1;  
reconfigure with override  
go

select ProductID, COUNT(*)
from Sales.SalesOrderDetailEnlarged
group by ProductID
go

exec sp_configure 'max degree of parallelism', 0;  
reconfigure with override  
exec sp_configure 'show advanced options', 0;  
reconfigure with override  
go