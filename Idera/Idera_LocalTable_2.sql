Select SQLStatement   , count(1)
from DBOPS_Local.dbo.SaaS_Queries_2016a   
where  SQLStatement not like 'WITH XMLNAMESPACES %'
and SQLStatement not like 'UPDATE  LYENTERPRISE%'
and SQLStatement not like 'WAITFOR DELAY%'
and SQLStatement like '%dbo.fn_%'
and left (DatabaseName,6) not in ( 'CTX_15',  'CTX_14')
group by SQLStatement
order by 2 desc
--order by  DatabaseName desc
--order by DatabaseName, SQLStatement desc

--SELECT count(1) count, sum( [CPUMilliseconds]) [Total CPU],  avg( [DurationMilliseconds]) [AVG DurationMilliseconds], 
--sum( [DurationMilliseconds]) [Total DurationMilliseconds], avg([CPUMilliseconds]) [AVG CPUMilliseconds], 
--avg(Reads) [AVG Reads] , avg(Writes) [AVG Writes],
--replace(replace(left(SQLStatement,100)     ,char(13),' '),char(10),' ') [SQL]
--FROM DBOPS_Local.dbo.SaaS_Queries_2016
--group by left(SQLStatement,100)
--order by [Total DurationMilliseconds] desc