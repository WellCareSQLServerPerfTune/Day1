use AdventureWorks2008R2
go


-- Display All Cached Plans
select * 
from sys.dm_exec_query_stats

-- Display Cached Plans with their Execution Plans
select * 
from sys.dm_exec_query_stats
	cross apply sys.dm_exec_sql_text(plan_handle)

-- Display Cached Plans with their SQL Text
select * from sys.dm_exec_query_stats
cross apply
sys.dm_exec_query_plan(plan_handle)

-- Just Display Execution Plans and SQL Text
select [text], query_plan 
from sys.dm_exec_query_stats
	cross apply sys.dm_exec_query_plan(plan_handle)
	cross apply sys.dm_exec_sql_text(plan_handle)

-- Display SQL Text and Execution Plans for Top 10 Most Expensive Queries by CPU
select top 10 total_worker_time / execution_count as [Avg CPU Time], [text], query_plan 
from sys.dm_exec_query_stats
	cross apply sys.dm_exec_query_plan(plan_handle)
	cross apply sys.dm_exec_sql_text(plan_handle)
order by [Avg CPU Time] desc

-- Display SQL Text and Execution Plans for a specific Object
exec dbo.uspGetEmployeeManagers 2
select [text], query_plan.objectid
from sys.dm_exec_query_stats
	cross apply sys.dm_exec_query_plan(plan_handle)	as query_plan
	cross apply sys.dm_exec_sql_text(sql_handle)	as sql_text
where query_plan.objectid = object_id('dbo.uspGetEmployeeManagers')
go


