SELECT 
    TableName = t.NAME,
    TableSchema = s.Name,
    RowCounts = p.rows
FROM sys.tables t
INNER JOIN    sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
WHERE    t.is_ms_shipped = 0 
and t.Name like 'tft%'
and p.rows>0
GROUP BY    t.NAME, s.Name, p.Rows
ORDER BY    p.rows desc, t.Name


--select 'select * from '+table_name from INFORMATION_SCHEMA.TABLES where TABLE_TYPE='BASE TABLE' and table_name like '%client'