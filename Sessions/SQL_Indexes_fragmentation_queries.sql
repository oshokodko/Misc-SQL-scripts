select distinct 
i.name, i.object_id, i.index_id,
( select min(AVG_FRAGMENTATION_IN_PERCENT) AS AvgPageFragmentation from
sys.dm_db_index_physical_stats (DB_ID(), i.object_id, i.index_id , 1, N'DETAILED') ) AvgPageFragmentation
from #temp_indexes i 

select distinct 
t.name, i.object_id, i.index_id
into #temp_indexes
from 
sys.dm_db_index_usage_stats i JOIN 
sys.tables t ON (t.object_id = i.object_id) JOIN 
sys.schemas s ON (t.schema_id = s.schema_id) 
where database_id = db_id() 
and last_user_update is not null and last_user_update > dateadd(day,-1,getdate())


SELECT 
 DB_NAME(DATABASE_ID) AS [DatabaseName],
 OBJECT_NAME(OBJECT_ID) AS TableName,
 SI.NAME AS IndexName,
 INDEX_TYPE_DESC AS IndexType,
 AVG_FRAGMENTATION_IN_PERCENT AS AvgPageFragmentation,
 PAGE_COUNT AS PageCounts
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, N'DETAILED') DPS
INNER JOIN sysindexes SI 
ON DPS.OBJECT_ID = SI.ID AND DPS.INDEX_ID = SI.INDID
where dps.OBJECT_ID in (
select distinct i.object_id
from 
sys.dm_db_index_usage_stats i JOIN 
sys.tables t ON (t.object_id = i.object_id) JOIN 
sys.schemas s ON (t.schema_id = s.schema_id) 
where 
database_id = db_id() 
and last_user_update is not null and last_user_update > dateadd(day,-1,getdate())
)
AND dps.PAGE_COUNT > 10000




ORDER BY AvgPageFragmentation desc
GO

