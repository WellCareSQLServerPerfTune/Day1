use AdventureWorks2008R2
go

-- Table Scan
select * from DatabaseLog
go

-- Custered Index Scan
select * from Person.Address
go

-- Index Scan (Covering Index = IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode)
--		Note: AddressID is not in index column list, but is included since non-clustered index
--			  using either PK column or RowID to refer back to base table
select AddressID, City, StateProvinceID from Person.Address
go

-- Clustered Index Seek
select AddressID, StateProvinceID from Person.Address where AddressID = 12037
go

-- Index Seek (1 row returned)
select AddressID, StateProvinceID from Person.Address where StateProvinceID = 32
go
-- Index Seek (Many rows returned, same execution plan as previous)
select AddressID, StateProvinceID from Person.Address where StateProvinceID = 9
go

-- Key Lookup (Bookmark Lookup to clustered index table)
select * from Person.Address
where StateProvinceID = 32
go
-- Clustered Index Scan - So many rows returned, better to scan than bookmark lookup
select * from Person.Address
where StateProvinceID = 9
go

-- RID Lookup (Bookmark Lookup to heap table)
create index IX_Object on DatabaseLog(Object)
select * from DatabaseLog where Object = 'City'
drop index DatabaseLog.IX_Object
go