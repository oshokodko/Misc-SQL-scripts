--waitfor delay '00:00:10'
SELECT count(1) from sys.sysprocesses S where DB_NAME(dbid) like 'SQL_ConnectionTest%'

--select * from sys.sysprocesses S where DB_NAME(dbid) like 'ctx_connectio%'


 select b.name, a.last_execution_time as ExecTime
 from sys.procedures b
 left join sys.dm_exec_procedure_stats a  on a.object_id = b.object_id 
 order by b.name;

 select * from information_schema.ROUTINES
 select * from  sys.procedures
 select * from sys.objects
 select * from sys.schemas

  select * from  information_schema.ROUTINES