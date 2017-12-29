exec [dbo].[RebuildAllIndices]

sp_msforeachtable'UPDATE STATISTICS ? WITH FULLSCAN, COLUMNS'

DBCC FREEPROCCACHE


