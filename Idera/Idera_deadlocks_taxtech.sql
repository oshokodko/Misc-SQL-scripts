--server devops\devops
--use SQLdmRepository

select InstanceName from MonitoredSQLServers

SELECT [DeadlockID]
      ,s.InstanceName
      ,[UTCCollectionDateTime]
      ,cast([XDLData]  as xml) [XDLData]
--	  into #t1
  FROM [Deadlocks] d
  join [MonitoredSQLServers] s on s.SQLServerID = d.SQLServerID
where [UTCCollectionDateTime] between '2017-06-22 14:00:00.000' and '2017-06-27 23:59:00.000'
 --and s.Instancename = 'VSDBC01S12\INSTANCE12'
-- and s.Instancename in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04','VSDBC01S08\INSTANCE08','VSDBC01S09\INSTANCE09')
--and [XDLData] not like '%AuthorizedFunctions%'
--and [XDLData] not like '%GroupMembersGenerated%'
and [XDLData] not like '%LYK1ALLOCATIONAMTACTV%'
--and [XDLData] like '%LYRULEUPDATEPARTNERSHIPSP%'
order by [UTCCollectionDateTime]

--select * from [MonitoredSQLServers]
--select * FROM [Deadlocks] d

 --select [DeadlockID]
 --     ,Instancename
 --     ,[UTCCollectionDateTime]
 --     ,cast( [XDLData]  as xml)
	--  from #t1

--SELECT TOP 1000 [BlockID]
--	   ,s.Instancename
--      ,[XActID]
--      ,[UTCCollectionDateTime]
--      ,[XDLData]
--  FROM [vsdbs01\MONITOR].[SQLdmRepository].[dbo].[Blocks] d
--    join [vsdbs01\MONITOR].[SQLdmRepository].[dbo].[MonitoredSQLServers] s on s.SQLServerID = d.SQLServerID
--where [UTCCollectionDateTime] between '2016-07-01 05:00:00.000' and '2016-08-03 00:00:00.000'
-- --and s.Instancename = 'VSDBC01S01\INSTANCE01'
-- and s.Instancename in ('VSDBC01S01\INSTANCE01','VSDBC01S02\INSTANCE02','VSDBC01S03\INSTANCE03','VSDBC01S04\INSTANCE04','VSDBC01S08\INSTANCE08','VSDBC01S09\INSTANCE09')
----and [XDLData] like '%DataDictionary_Field%'
----and [XDLData] like '%Training%'
----and [XDLData] like '%Save_CreateJob%'
--order by [UTCCollectionDateTime]


