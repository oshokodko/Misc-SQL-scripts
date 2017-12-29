SET NOCOUNT OFF;
DECLARE @handle UniqueIdentifier
DECLARE @count INT = 0

declare @pattern varchar(2256) = 'SqlQueryNotificationService-%'
--declare @pattern varchar(2256) = 'http://schemas.microsoft.com/SQL/Notifications/QueryNotificationService'

-- Retrieve orphaned conversation handles that belong to auto-generated SqlDependency queues and iterate over each of them
DECLARE handleCursor CURSOR
FOR 
SELECT [conversation_handle]
FROM sys.conversation_endpoints WITH(NOLOCK)
WHERE
    far_service COLLATE SQL_Latin1_General_CP1_CI_AS like @pattern COLLATE SQL_Latin1_General_CP1_CI_AS AND
    far_service COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT name COLLATE SQL_Latin1_General_CP1_CI_AS FROM sys.service_queues)

DECLARE @Rows INT
SELECT @Rows = COUNT(*) FROM sys.conversation_endpoints WITH(NOLOCK)
WHERE
    far_service COLLATE SQL_Latin1_General_CP1_CI_AS like @pattern COLLATE SQL_Latin1_General_CP1_CI_AS AND
    far_service COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT name COLLATE SQL_Latin1_General_CP1_CI_AS FROM sys.service_queues)

WHILE @ROWS>0
BEGIN
    OPEN handleCursor

    FETCH NEXT FROM handleCursor 
    INTO @handle

    BEGIN TRANSACTION

    WHILE @@FETCH_STATUS = 0
    BEGIN

        -- End the conversation and clean up any remaining references to it
        END CONVERSATION @handle WITH CLEANUP
		print @handle

        -- Move to the next item
        FETCH NEXT FROM handleCursor INTO @handle
        SET @count= @count+1
    END

    COMMIT TRANSACTION
    print @count

    CLOSE handleCursor;

    IF @count > 100000
    BEGIN
        BREAK;
    END

    SELECT @Rows = COUNT(*) FROM sys.conversation_endpoints WITH(NOLOCK)
    WHERE
        far_service COLLATE SQL_Latin1_General_CP1_CI_AS like @pattern COLLATE SQL_Latin1_General_CP1_CI_AS AND
        far_service COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN (SELECT name COLLATE SQL_Latin1_General_CP1_CI_AS FROM sys.service_queues)
END
DEALLOCATE handleCursor;