
--DBCC SHRINKDATABASE  (Ctx_frag_2017_bb, 2, TRUNCATEONLY )

--Check Index State
SELECT dbt.area as FragmentationArea, Object_Name(Indexes.Object_Id) AS TableName, 
Indexes.name As IndexName, Page_count, SysIndexes.Rows as Row_Count,
IndexStats.Avg_Fragmentation_In_Percent FragmentationPercent, IndexStats.Record_Count,
CASE WHEN datediff(hour, Stats_Date(indexes.object_id, indexes.index_id), getdate()) > 24 OR SysIndexes.rowmodctr > 0.1 
OR SysIndexes.Rows > 0.1 * record_count THEN 1 ELSE 0 END NeedRebuild
FROM sys.dm_db_index_physical_stats(Db_Id(), Null, Null, Null, NULL) IndexStats
INNER JOIN sys.indexes Indexes with (nolock) ON Indexes.Object_Id = IndexStats.Object_Id And Indexes.Index_Id = IndexStats.Index_Id
INNER JOIN sys.sysindexes SysIndexes with (nolock) on ( SysIndexes.Id = Indexes.object_id and SysIndexes.IndId = Indexes.Index_Id)
INNER JOIN DataBase_Table dbt with (nolock) on (Object_Name(Indexes.Object_Id) = dbt.TableName)
WHERE indexstats.database_id = DB_ID()  and   (avg_fragmentation_in_percent > 10   ) and  Indexes.index_id > 0
and page_count > 1000
order by 1

