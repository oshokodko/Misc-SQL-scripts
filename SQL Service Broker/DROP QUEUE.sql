SET NOCOUNT OFF;
DECLARE @ObjName varchar(255)
DECLARE @count INT = 0

declare @pattern varchar(2256) = 'SqlQueryNotificationService-%'
--declare @pattern varchar(2256) = 'http://schemas.microsoft.com/SQL/Notifications/QueryNotificationService'

 --Retrieve orphaned conversation handles that belong to auto-generated SqlDependency queues and iterate over each of them
DECLARE handleCursor CURSOR
FOR 
SELECT q.name FROM sys.service_queues q 
left join sys.services e WITH(NOLOCK) on q.object_id = e.service_queue_id  where e.name is null

DECLARE @Rows INT
SELECT @Rows = COUNT(*) FROM sys.service_queues q 
left join sys.services e WITH(NOLOCK) on q.object_id = e.service_queue_id where e.name is null
select @Rows

WHILE @ROWS>0
BEGIN
    OPEN handleCursor

    FETCH NEXT FROM handleCursor INTO @ObjName

    BEGIN TRANSACTION

    WHILE @@FETCH_STATUS = 0
    BEGIN

		DECLARE @query as nvarchar(200);
		SET @query = N'drop queue [' + @ObjName + ']'
		print @query
		EXEC sp_executesql @query

        -- Move to the next item
	    FETCH NEXT FROM handleCursor INTO @ObjName
    
	    SET @count= @count+1

		IF @count > 1000
		BEGIN
			BREAK;
		END
	END

    COMMIT TRANSACTION
    print @count

    CLOSE handleCursor;

    IF @count > 100
    BEGIN
        BREAK;
    END

	SELECT @Rows = COUNT(*) FROM sys.service_queues q 
	left join sys.services e WITH(NOLOCK) on q.object_id = e.service_queue_id where e.name is null
END

SELECT @Rows = COUNT(*) FROM sys.service_queues q 
left join sys.services e WITH(NOLOCK) on q.object_id = e.service_queue_id where e.name is null
select @Rows

DEALLOCATE handleCursor;