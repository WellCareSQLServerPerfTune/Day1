use AdventureWorks2008R2
go

-- Since there is no GUI, need to figure out what events, actions, and predicates are available in 2008R2
-- List of Events
select pkg.name as PackageName, obj.name as EventName 
from sys.dm_xe_packages				as pkg 
	inner join sys.dm_xe_objects	as obj			on pkg.guid = obj.package_guid 
where obj.object_type = 'event' 
order by 1, 2
go

-- List of Actions
select pkg.name as PackageName, obj.name as ActionName 
from sys.dm_xe_packages				as pkg 
	inner join sys.dm_xe_objects	as obj			on pkg.guid = obj.package_guid 
where obj.object_type = 'action' 
order by 1, 2

-- List of Predicates
select pkg.name as PackageName, obj.name as PredicateName 
from sys.dm_xe_packages				as pkg 
	inner join sys.dm_xe_objects	as obj			on pkg.guid = obj.package_guid 
where obj.object_type = 'pred_source' 
order by 1, 2



-- No database_name predicate, so will need the database_id
-- Find AdventureWorks2008R2 Database_ID
select db_id('AdventureWorks2008R2')
go

-- Create a Session
drop event session [Execution Plans from AdventureWorks] on server
create event session [Execution Plans from AdventureWorks] on server 
add event sqlserver.sql_statement_completed(
    action(sqlserver.plan_handle,sqlserver.sql_text)
    where ([sqlserver].[database_id]=5))                        -- Use database_id found above here
add target package0.ring_buffer
with (STARTUP_STATE=OFF,max_dispatch_latency = 1seconds)
go



-- View Active Sessions
select name, create_time from sys.dm_xe_sessions;

-- Start Session
alter event session [Execution Plans from AdventureWorks] on server state=start

-- Display Event Data
select cast(stargets.target_data as xml) 
from sys.dm_xe_session_targets		as stargets 
	join sys.dm_xe_sessions			as sessions		on sessions.address = stargets.event_session_address 
where sessions.name = 'Execution Plans from AdventureWorks' 

-- Stop Session
alter event session [Execution Plans from AdventureWorks] on server state=stop
go
