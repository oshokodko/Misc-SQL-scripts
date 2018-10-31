DECLARE @name SYSNAME 


DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM MASTER.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb') 

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  
declare @sql nvarchar(max)= null
WHILE @@FETCH_STATUS = 0  
BEGIN  

set @sql='use ' + QUOTENAME(@name,'[]') +'; select db_name()'
exec (@sql)
      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

