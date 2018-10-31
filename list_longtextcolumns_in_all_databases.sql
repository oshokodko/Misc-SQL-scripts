IF OBJECT_ID('tempdb..#DatabaseLongTextFields') IS NOT NULL
	BEGIN
		DROP TABLE #DatabaseLongTextFields
	END
	-- This table will contain the current state of all databases on the replica
	CREATE TABLE #DatabaseLongTextFields
		(
		DatabaseName SYSNAME NOT NULL,
		FieldName SYSNAME NOT NULL
		)


DECLARE @name SYSNAME 


DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM MASTER.dbo.sysdatabases 
WHERE name like 'EDDS[0-9]%' ORDER BY  1

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  
declare @sql nvarchar(max)= null
WHILE @@FETCH_STATUS = 0  
BEGIN  

	--set @sql='use ' + QUOTENAME(@name,'[]')
	--EXEC (@sql)
	IF (OBJECT_ID(QUOTENAME(@name,'[]')+'.EDDSDBO.Document') is not null
	AND COL_LENGTH (QUOTENAME(@name,'[]')+'.EDDSDBO.Document', 'ExtractedText') is not null)
	BEGIN
		set @sql ='INSERT #DatabaseLongTextFields (DatabaseName, FieldName)
		SELECT '+QUOTENAME(@name,'''')+', COLUMN_NAME FROM '+QUOTENAME(@name,'[]')+'.INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME=''document'' and DATA_TYPE in (''varchar'', ''nvarchar'') and CHARACTER_MAXIMUM_LENGTH = -1'
		--print @sql
		EXEC (@sql)
	END
    FETCH NEXT FROM db_cursor INTO @name 
END 


CLOSE db_cursor  
DEALLOCATE db_cursor 


select @@serverName SQLName, DatabaseName, FieldName from #DatabaseLongTextFields
order by 1,2,3
