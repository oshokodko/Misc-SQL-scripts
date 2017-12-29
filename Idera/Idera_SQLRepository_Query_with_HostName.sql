Select  X.SQLServerName  
      ,X.DatabaseName  
      ,DATEADD(hh, -6, X.CompletionTime) CompletionTime
      ,X.[DurationMilliseconds]  
      ,X.[CPUMilliseconds]  
      ,X.[Reads]  
      ,X.[Writes]  
      --,[StatementType] 
	  ,replace(replace(X.SQLStatement      ,char(13),' '),char(10),' ')  
	  ,X.HostName
      --,SQLStatement       
from 

(SELECT  	   
	   MSS.InstanceName as SQLServerName
      ,[UTCCollectionDateTime]
      ,SDN.DatabaseName
      ,[CompletionTime]
      ,[DurationMilliseconds]
      ,[CPUMilliseconds]
      ,[Reads]
      ,[Writes]
      ,[StatementType] 
      ,SS.SQLStatement  
	  ,QM.[HostNameID] 
	  ,HN.HostName 
  FROM [vsdbs01\MONITOR].[SQLdmRepository].[dbo].[QueryMonitorStatistics] QM with(nolock) 
  inner join  [vsdbs01\MONITOR].[SQLdmRepository].[dbo].MonitoredSQLServers MSS  with(nolock) on
  (
    QM.SQLServerID = MSS.SQLServerID
   ) 
   inner join  [vsdbs01\MONITOR].[SQLdmRepository].[dbo].SQLStatements SS with(nolock) on
  (
    QM.SQLStatementID = SS.SQLStatementID
   ) 
   inner join [vsdbs01\MONITOR].[SQLdmRepository].dbo.SQLServerDatabaseNames SDN with(nolock) on
   (
     QM.DatabaseID = SDN.DatabaseID
    )
	inner join [vsdbs01\MONITOR].[SQLdmRepository].[dbo].[HostNames] HN with(nolock) 
	on QM.HostNameID = HN.HostNameID
  where 1=1
  and CompletionTime between '2015-04-15' and '2015-04-18'
  --and UTCCollectionDateTime > DATEADD(hh, -50, GetUTCDate())
  -- UTCCollectionDateTime < '2010-12-01'
  --and SS.SQLStatement not like '%shrink%' and 
  --and SS.SQLStatement not like 'BACKUP database%'
  --and SS.SQLStatement not like '%restore%database%'
  --and SS.SQLStatement not like '%RESTORE database%'
  --and SS.SQLStatement not like '%backup%database%'
  --and SS.SQLStatement not like '%dbcc%'
  --and SS.SQLStatement not like '%sp_Rebuild%'
  --and SS.SQLStatement not like '%doctor%'
  --and SS.SQLStatement not like '%sp_updatestats%'
  and QM.DurationMilliseconds > 1000
  and SDN.DatabaseName like '%150230%' ) X  

where 1=1
--and X.DatabaseName like '%CTX_140518%'
--and DATEADD(hh, -5, X.CompletionTime) between '2015-01-30 00:00:00.000' and '2015-01-01 00:00:00.000'
--and SQLStatement like '%TableData%'
--and (X.SQLStatement not like '%dbcc%' and X.SQLStatement not like '%sp_Rebuild%' and X.SQLStatement not like '%doctor%' and X.SQLStatement not like '%sp_updatestats%')
--and SQLStatement like '%CREATE CLUSTERED Index%'
--order by [Reads] desc
--order by X.[DurationMilliseconds] desc
--order by SQLStatement desc
--order by CompletionTime desc
order by 4 desc 

