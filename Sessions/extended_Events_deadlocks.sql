CREATE EVENT SESSION [deadlocks] ON SERVER 
ADD EVENT sqlserver.xml_deadlock_report(
    ACTION(sqlserver.client_app_name,sqlserver.database_name,sqlserver.plan_handle,sqlserver.username))
ADD TARGET package0.event_file(SET filename=N'deadlocks'),
ADD TARGET package0.ring_buffer(SET max_events_limit=(10000))
WITH (STARTUP_STATE=OFF)
GO


