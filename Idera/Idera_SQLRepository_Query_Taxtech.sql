--server devops\devops
--use SQLdmRepository

--select * from QueryMonitorStatistics q
--join [SQLQueryPlans] p on p.PlanID = q.PlanID
--where q.SQLStatementID = 646571


Select  SQLServerName  ,
      DatabaseName ,
      DATEADD(hh, -5, CompletionTime)
      ,[DurationMilliseconds]  
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
      ,SQLStatementID   
      ,SQLStatement       
from dbo.IderaDiagnosticInformation (nolock) 
--where DatabaseName like 'CTX_AUTO_DELOITTE_LOADTEST_sq2012%'
where 1=1
--and DatabaseName like 'Corptax_AutomatedTests'
and DatabaseName <>'master'
--and DatabaseName like 'ctx_asp_loadtest_2012%'
and DATEADD(hh, -5, CompletionTime) between '2017-06-01 00:00:00.000' and '2017-07-01 00:00:00.000'
--and SQLStatement like '%TableData%'
and SQLStatement not like 'DBCC%' 
and SQLStatement not like '%sp_Rebuild%'
and SQLStatement not like 'update statistics%'
and SQLStatement not like '%alter index%'
and SQLStatement not like 'SELECT Object_Name(Indexes.Object_Id)%'
and SQLStatement not like 'WAITFOR(RECEIVE%'
and SQLStatement not like '/*     -- SE 27.0.0.339%'
and SQLStatement not like 'ALTER TABLE%'
and SQLStatement not like 'CREATE  NONCLUSTERED INDEX%'
--and SQLStatementID = 646571
--and SQLStatement like '%EFDocumentNodeExplicitReferenceGetSP%'
--order by [Reads] desc
--order by [DurationMilliseconds] desc
order by SQLStatement desc
--order by CompletionTime desc
--order by 1 desc

