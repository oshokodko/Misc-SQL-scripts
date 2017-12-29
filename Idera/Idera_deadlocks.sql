SELECT [DeadlockID]
      ,s.Instancename
      ,[UTCCollectionDateTime]
      ,[XDLData]  
	  into #t1
  FROM [SQLdmRepository].[dbo].[Deadlocks] d
  join [SQLdmRepository].[dbo].[MonitoredSQLServers] s on s.SQLServerID = d.SQLServerID
where [UTCCollectionDateTime] between '2017-01-18 14:00:00.000' and '201-01-18 23:59:00.000'
and s.Instancename = 'instance name'
and [XDLData] like '%db nane%'
order by [UTCCollectionDateTime]

 select [DeadlockID]
      ,Instancename
      ,[UTCCollectionDateTime]
      ,cast( [XDLData]  as xml)
	  from #t1

SELECT TOP 1000 [BlockID]
	   ,s.Instancename
      ,[XActID]
      ,[UTCCollectionDateTime]
      ,[XDLData]
  FROM [SQLdmRepository].[dbo].[Blocks] d
    join [SQLdmRepository].[dbo].[MonitoredSQLServers] s on s.SQLServerID = d.SQLServerID
where [UTCCollectionDateTime] between '2016-07-01 05:00:00.000' and '2016-08-03 00:00:00.000'
 and s.Instancename = 'bla'
 and [XDLData] like '%bla%'
order by [UTCCollectionDateTime]


