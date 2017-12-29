Select SQLServerName  
      ,DatabaseName  
      , CompletionTime
      ,[DurationMilliseconds]  
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
       ,SQLStatement   
--into DBOPS_Local.dbo.SaaS_Queries_2016_SY2016
from DBOPS_Local.dbo.SaaS_Queries_2017_May
--where SQLStatement like '%SELECT Entity_Master.EntityKey%'
--where SQLStatement like '%#ContextIntermediate%'
where SQLStatement like '%SELECT DISTINCT t_10050_0.TableInstanceID%'
--and SQLStatement like 'select cd.ContextId from ContextDetail cd with(nolock) where%'
and SQLStatement not like 'WAITFOR DELAY%'
and SQLStatement not like '%ALTER INDEX%'
and SQLStatement not like 'Rollover_RebuildAllIndices%'
--and SQLStatement like '%eg1.GroupTypeId = 3%'
--and ( left (DatabaseName,6) in ( 'CTX_16') or right (DatabaseName,3)  in ('_16') )
order by  SQLStatement, DatabaseName
--order by DatabaseName, SQLStatement 


SELECT count(1) count, sum( [CPUMilliseconds]) [Total CPU],  avg( [DurationMilliseconds]) [AVG DurationMilliseconds], 
sum( [DurationMilliseconds]) [Total DurationMilliseconds], avg([CPUMilliseconds]) [AVG CPUMilliseconds], 
avg(Reads) [AVG Reads] , avg(Writes) [AVG Writes],
replace(replace(left(SQLStatement,500)     ,char(13),' '),char(10),' ') [SQL]
FROM DBOPS_Local.dbo.SaaS_Queries_2017_May
where  SQLStatement not like 'WITH XMLNAMESPACES %'
and SQLStatement not like 'UPDATE  LYENTERPRISE%'
and SQLStatement not like 'WAITFOR DELAY%'
and SQLStatement not like '%ALTER INDEX%'
and SQLStatement not like 'Rollover_RebuildAllIndices%'
and ( left (DatabaseName,6) in ( 'CTX_17')
or right (DatabaseName,3)  in ('_17') )
group by left(SQLStatement,500)
having count(1) > 5
--order by left(SQLStatement,500)
--order by count(1) desc
order by [Total DurationMilliseconds] desc
