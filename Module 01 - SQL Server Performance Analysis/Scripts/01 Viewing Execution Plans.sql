use AdventureWorks2008R2
go

select p.ProductID, p.Name, sod.UnitPrice * sod.OrderQty as [Total Price]
from Sales.SalesOrderDetail			as sod
	join Production.Product			as p		on sod.ProductID = p.ProductID
where sod.ProductID = 745
go

select p.ProductID, p.Name, sod.UnitPrice * sod.OrderQty as [Total Price]
from Sales.SalesOrderDetail			as sod
	join Production.Product			as p		on sod.ProductID = p.ProductID
where p.ProductID = 745
go



-- Set Commands to View XML or Text Execution Plans
-- Turn off GUI Include Actual Execution Plan

--set showplan_xml on				-- Estimated XML
--set statistics xml on				-- Actual XML
--set showplan_text on				-- Estimated Text
--set showplan_all on				-- Estimated Text with more info
--set statistics profile on			-- Actual Text
go

select * from Production.Product
go

--set showplan_xml off				-- Estimated XML
--set statistics xml off			-- Actual XML
--set showplan_text off				-- Estimated Text
--set showplan_all off				-- Estimated Text with more info
--set statistics profile off		-- Actual Text
go



-- Execution Plan Warnings
-- SQL Server 2008 Warnings: NoJoinPredicate, ColumnsWithNoStatistics
-- SQL Server 2012 Warnings:  SpillToTempDb, PlanAffectingConvert, UnMatchedIndexes, FullUpdateForOnlineIndexBuild
select *
from Production.Product					as p
	, Production.ProductSubcategory		as ps
where p.ProductSubcategoryID = ps.ProductSubcategoryID

select *
from Production.Product					as p
	, Production.ProductSubcategory		as ps
go