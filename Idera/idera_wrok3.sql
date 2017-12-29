SELECT top 3000 SQLServerName  
      ,DatabaseName  
      , CompletionTime
      ,[DurationMilliseconds]  
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
	  ,CompletionTime
      --,[StatementType]   
      ,replace(replace(SQLStatement      ,char(13),' '),char(10),' ')
  FROM [VSDBS01\MONITOR].[SQLdmRepository].[dbo].[IderaDiagnosticInformation]
  --where DatabaseName like 'CTX_AUTO_DELOITTE_LOADTEST_sq2012%'
--where DatabaseName like '%%'
where CompletionTime between '2014-08-26 00:00:00.000' and '2014-09-03 00:00:00.000'
--and DatabaseName like '%timewarner%'
--and SQLStatement like '%TableData%'
and (SQLStatement not like '%dbcc%' and SQLStatement not like '%sp_Rebuild%' ) 
and SQLStatement not like '%RESTORE%'
and SQLStatement not like '%BACKUP%' 
and DatabaseName not like 'msdb'
and SQLServerName in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04')
--and DatabaseName not like '%timewarner%'
and SQLStatement like '%lyFolder%'
--order by [Reads] desc
--order by [DurationMilliseconds] desc
order by [CPUMilliseconds] desc
--order by DatabaseName desc

SELECT count(1) count, sum( [CPUMilliseconds]) [Total CPU],  avg( [DurationMilliseconds]) [AVG DurationMilliseconds], avg([CPUMilliseconds]) [AVG CPUMilliseconds], 
avg(Reads) [AVG Reads] , avg(Writes) [AVG Writes],
replace(replace(SQLStatement      ,char(13),' '),char(10),' ') [SQL]
FROM [VSDBS01\MONITOR].[SQLdmRepository].[dbo].[IderaDiagnosticInformation]
  --where DatabaseName like 'CTX_AUTO_DELOITTE_LOADTEST_sq2012%'
--where DatabaseName like '%%'
where CompletionTime between '2014-08-26 00:00:00.000' and '2014-09-03 00:00:00.000'
and DatabaseName not like '%timewarner%'
--and SQLStatement like '%TableData%'
and (SQLStatement not like '%dbcc%' and SQLStatement not like '%sp_Rebuild%' and SQLStatement not like '%litespeed%') 
and SQLStatement not like '%RESTORE%'
and SQLStatement not like '%BACKUP%' 
and DatabaseName not like 'msdb'
and SQLServerName in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04')
--and SQLStatement like '%CREATE CLUSTERED Index%'
--order by [Reads] desc
--order by [DurationMilliseconds] desc
and not (SQLStatement like 'declare%' or SQLStatement like 'exec%')
group by SQLStatement
order by 2 desc



select  SQLServerName  
      ,DatabaseName  
      , CompletionTime
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
      --,[StatementType]   
      ,SQLStatement   
	  --into #tmpQueries
from [vsdbs01\monitor].[SQLdmRepository].dbo.IderaDiagnosticInformation (nolock)
where CompletionTime between '2014-08-26 00:00:00.000' and '2014-09-03 00:00:00.000'
and (SQLStatement not like '%dbcc%' and SQLStatement not like '%sp_Rebuild%' ) 
and SQLStatement not like '%RESTORE%'
and SQLStatement not like '%BACKUP%' 
and DatabaseName not like 'msdb'
and SQLServerName in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04')
order by SQLStatement desc

select a.*  into #tmpSQL from (
SELECT SQLServerName  
      ,DatabaseName  
      , CompletionTime
      ,[DurationMilliseconds]  
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
      ,replace(replace(SQLStatement      ,char(13),' '),char(10),' ') SQLStatement
  FROM [VSDBS01\MONITOR].[SQLdmRepository].[dbo].[IderaDiagnosticInformation]
where CompletionTime between '2014-08-26 00:00:00.000' and '2014-09-03 00:00:00.000'
--and DatabaseName like '%timewarner%'
--and SQLStatement like '%TableData%'
and (SQLStatement not like '%dbcc%' and SQLStatement not like '%sp_Rebuild%' ) 
and SQLStatement not like '%RESTORE%'
and SQLStatement not like '%BACKUP%' 
and DatabaseName not like 'msdb'
and SQLServerName in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04')
and DatabaseName not like '%timewarner%'
) a

select top 100000 SQLServerName  
      ,DatabaseName  
      , CompletionTime
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
      --,[StatementType]   
      ,SQLStatement   
	  , SPName
	  into #tmpQueries

from #tmpSQL p
join #tmpSPs a on p.SQLStatement like a.SPName
where (SQLStatement not like '%dbcc%' and SQLStatement not like '%sp_Rebuild%' ) 
and SQLStatement not like '%RESTORE%'
and SQLStatement not like '%BACKUP%' 
and DatabaseName not like 'msdb'
and SQLServerName in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04')
order by SQLStatement desc

alter  table #tmpSPs alter column SPName varchar(255) collate SQL_Latin1_General_CP1_CS_AS

select SPName, count(1) from #tmpQueries group by SPName order by 1

