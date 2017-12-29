--drop table #ErrorLog

--CREATE TABLE #ErrorLog
--(LogDate datetime,
--ProcessInfo varchar(40),
--[Text]	 Varchar(4000))

--insert #ErrorLog (LogDate,ProcessInfo,[Text])
--EXEC sp_readerrorlog

select distinct [text],
substring([text], 
	patindex('%specified database%', [text]) + len('specified database') + 2,
	patindex('%CLIENT:%', [text]) - patindex('%specified database%', [text]) - len('specified database') - 6),
substring([text], 
	patindex('%specified database%', [text]) + len('specified database') + 2,
	patindex('%CLIENT:%', [text]) - patindex('%specified database%', [text]) - len('specified database') - 6),

from #ErrorLog 
where ProcessInfo='Logon' and [text] like 'login failed for user%'
order by 1 desc

