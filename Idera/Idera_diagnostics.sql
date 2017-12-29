--drop table DBOPS_Local.dbo.SaaS_Queries_2017_a
Select SQLServerName  
      ,DatabaseName  
      ,DATEADD(hh, -6, CompletionTime) CompletionTime
      ,[DurationMilliseconds]  
      ,[CPUMilliseconds]  
      ,[Reads]  
      ,[Writes]  
      --,[StatementType]   
       ,replace(replace(SQLStatement      ,char(13),' '),char(10),' ') SQLStatement   
	   into DBOPS_Local.dbo.SaaS_Queries_2017_May
from [vsdbs01\monitor, 1582].[SQLdmRepository].dbo.IderaDiagnosticInformation
--where DatabaseName like 'CTX_AUTO_DELOITTE_LOADTEST_sq2012%'
--where DatabaseName like '%%'
where CompletionTime between '2017-04-29 00:00:00.000' and '2017-05-28 00:00:00.000'
--and SQLStatement like '%CorpTax_CacheState%'
and (SQLStatement not like '%dbcc%' 
		and SQLStatement not like '%sp_Rebuild%'  
		and SQLStatement not like '%RESTORE%'
		and SQLStatement not like '%BACKUP%' 
		and SQLStatement not like '%data_space_id%' 
		and SQLStatement not like '%Standard identifying info%' 
		and SQLStatement not like '%alter index%'     ) 
--and SQLStatement like 'INSERT into #ContextIntermediate%'
--and left (DatabaseName,6) not in ( 'CTX_15',  'CTX_14')
and ( left (DatabaseName,6) in ( 'CTX_17') or right (DatabaseName,3)  in ('_17') )
--and DatabaseName ='CTX_170141'
--and DatabaseName ='CTX_160088'
--and DatabaseName like'CTX_Training_ptr%'
--and SQLStatement like '%ENTITYDELETE_LOGICAL%'
--and (SQLStatement like '%Session_Authorization%' or SQLStatement like '%AuthorizedFunctions%' )
--and (SQLStatement like '%LYCALCHEADERGet16SP%' )
--and SQLStatement like '%tmpADEPage%'
--and SQLStatement like 'SELECT t_1.TableInstanceID,t_1.ContextID,t_2.TableInstanceID,t_2.ContextID,t_2.AdjDes FROM CalcLine%'
--and SQLStatement like '%UPDATE  LYENTERPRISE %'
and DatabaseName not like 'msdb'
and DatabaseName <> 'master'
and DatabaseName <> 'AdfsConfiguration'
--and DatabaseName in ( 'CTX_160397', 'CTX_160443')
--and DatabaseName in ('CTX_160413', 'CTX_160397')
--and SQLServerName in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04','VSDBC01S08\INSTANCE08')
and SQLServerName in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04','VSDBC01S08\INSTANCE08','VSDBC01S09\INSTANCE09')
--and SQLServerName in ('VSDBC01S03\INSTANCE03')
--and SQLServerName in ('VSDBC01S02\INSTANCE02')
--and SQLServerName in ('vsdbc03s19\instance19')
order by SQLStatement desc
--order by CompletionTime desc
--order by [DurationMilliseconds] desc

-- SaveAmount_MapContextId  UPDATE s WITH (ROWLOCK)     SET   s.ContextId = x.ContextId     from CorptaxAmount_Stage s inner join #tempContextDetail t ON     (        s.CaseKey = t.CaseId      and s.EntityKey = t.EntityId      and s.CalendarPeriodKey = t.PeriodId     and s.LocationKey = t.LocationId      )     inner join ContextDetail x WITH (NOLOCK) on     (  x.EnterpriseId =@EnterpriseId      and x.CaseId = t.CaseId      and x.PeriodId = t.PeriodId      and x.EntityId = t.EntityId      and x.LocationId = t.LocationId      and x.BasketId = 0      and x.SubBasketId = 0      and SubPartFTypeId = 0      and CountryId = 0      and CurrencyId = 0      and TaxAllocationId = 0     )     WHERE s.JobId = @JobId     AND s.ContextId is null     AND s.ErrorMask = 0

--SELECT count(1) count, sum( [CPUMilliseconds]) [Total CPU],  avg( [DurationMilliseconds]) [AVG DurationMilliseconds], avg([CPUMilliseconds]) [AVG CPUMilliseconds], 
--avg(Reads) [AVG Reads] , avg(Writes) [AVG Writes],
--replace(replace(SQLStatement     ,char(13),' '),char(10),' ') [SQL]
--FROM SaaS_Queries_2016
--group by SQLStatement
--order by [Total CPU] desc

--SELECT count(1) count, sum( [CPUMilliseconds]) [Total CPU],  avg( [DurationMilliseconds]) [AVG DurationMilliseconds], 
--sum( [DurationMilliseconds]) [Total DurationMilliseconds], avg([CPUMilliseconds]) [AVG CPUMilliseconds], 
--avg(Reads) [AVG Reads] , avg(Writes) [AVG Writes],
--replace(replace(left(SQLStatement,100)     ,char(13),' '),char(10),' ') [SQL]
--FROM SaaS_Queries_2016
--group by left(SQLStatement,100)
--order by [Total DurationMilliseconds] desc

--SELECT SQLServerName  ,DatabaseName,
--	  [CPUMilliseconds] ,[DurationMilliseconds], [CPUMilliseconds], Reads, Writes,
--replace(replace(SQLStatement     ,char(13),' '),char(10),' ') [SQL]
--FROM SaaS_Queries_2016
--where  SQLStatement like '%fn_get_entitycode%'
----where  SQLStatement like 'SELECT t_1.TableInstanceID,t_1.ContextID,t_2.TableInstanceID,t_2.ContextID,t_2.AdjDes FROM CalcLine%'
--order by SQLStatement

