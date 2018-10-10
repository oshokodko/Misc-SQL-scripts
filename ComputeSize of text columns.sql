declare @sql nvarchar(max)= null
select @sql=COALESCE(@sql +'),0) + IsNull(DATALENGTH('+ COLUMN_NAME, COLUMN_NAME) from INFORMATION_SCHEMA.COLUMNS c where TABLE_NAME='document' and DATA_TYPE in ('varchar', 'nvarchar') and CHARACTER_MAXIMUM_LENGTH = -1
if @sql is not null
	set @sql = 'select (SELECT sum(size * 8 / 1024.00) FROM sys.database_files AS DF where type = 0) AS DBInMb (select sum(IsNull(DATALENGTH('+@sql+'),0))/1024/1024 FROM [Document]) AS TextInMb'

if (@sql is not null)
select @sql

# OR

declare @sql nvarchar(max)= null
select @sql=COALESCE(@sql +'),0) + IsNull(DATALENGTH('+ COLUMN_NAME, COLUMN_NAME) from INFORMATION_SCHEMA.COLUMNS c where TABLE_NAME='document' and DATA_TYPE in ('varchar', 'nvarchar') and CHARACTER_MAXIMUM_LENGTH = -1
if @sql is not null
       set @sql = 'select db_name() as DatabaseName, (select sum(IsNull(DATALENGTH('+@sql+'),0))/1024 FROM [Document]) AS TextInKb'

if (@sql is not null)
exec sp_executesql @sql

exec sp_spaceused 'Document'

exec sp_spaceused  @oneresultset = 1
