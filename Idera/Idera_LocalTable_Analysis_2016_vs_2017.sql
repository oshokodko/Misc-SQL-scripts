Select SQLServerName  
      ,DatabaseName  
      , CompletionTime
      ,[DurationMilliseconds]  
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
       ,SQLStatement   
from DBOPS_Local.dbo.SaaS_Queries_2016_SY2017
where left(SQLStatement,50) not in 
( 
select left (SQLStatement,50)
from DBOPS_Local.dbo.SaaS_Queries_2016_SY2016
)
and SQLStatement not like '%Query_View%' and SQLStatement not like '%fn_INT_GetEntityListByClmnfile%' and SQLStatement like '%>=%' and SQLStatement like '%<=%' 
order by  SQLStatement 
