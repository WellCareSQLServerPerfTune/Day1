use AdventureWorks2008R2
go

-- Create User Stats
create statistics ListPrice1
    on Production.Product (ListPrice)
    with sample 5 percent
    
create statistics ListPrice2
    on Production.Product (ListPrice)
    with fullscan, norecompute

-- Create Auto Stats on Color
select *
from Production.Product
where Color = 'Blue'
 
 -- Show StatsName, Last Updated, And Type
select name as StatsName
	, stats_date(object_id, stats_id)											as StatsUpdated
	, case when auto_created = 0 and user_created = 0 then 'Yes' else '' end	as IndexCreated
	, case when auto_created = 1 then 'Yes' else '' end							as AutoCreated 
	, case when user_created = 1 then 'Yes' else '' end							as UserCreated 
from sys.stats
where object_id = object_id('Production.Product')

-- Update for all Indexes on Production.Product
update statistics Production.Product

-- Update for only the PK_Product_ProductID Index
update statistics Production.Product PK_Product_ProductID

-- Update Specific Stats
update statistics Production.Product(ListPrice1) 
with fullscan, norecompute

-- View Stats Info for Table
exec sp_autostats 'Production.Product'

-- Update All Stats on DB
exec sp_updatestats

-- Drop Stats Created
drop statistics Production.Product.ListPrice1
drop statistics Production.Product.ListPrice2
drop statistics Production.Product._WA_Sys_00000006_66603565