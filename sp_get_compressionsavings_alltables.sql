--sp_estimate_data_compression_savings Returns the current size of the requested object and estimates the object size for the requested compression state.
--Compression can be evaluated for whole tables or parts of tables. This includes heaps, clustered indexes, nonclustered indexes, indexed views, and table and index partitions.
--The objects can be compressed by using row compression or page compression. If the table, index, or partition is already compressed, you can use this procedure to estimate the size of the table, index, or partition if it is recompressed.
--This procedure runs sp_estimate_data_compression_savings in loop for all tables and estimate savings. Setting a base, we are pulling results only if compression savings are 30% or above in this procedure

IF OBJECT_ID('sp_get_compressionsavings_alltables') IS NOT NULL
    DROP PROCEDURE sp_get_compressionsavings_alltables;
GO
CREATE PROCEDURE sp_get_compressionsavings_alltables
AS
     BEGIN
         DECLARE @Counter INT, @MaxRowCount INT, @tab_name VARCHAR(100);
         SELECT @Counter = 1,
                @MaxRowCount = COUNT(*)
         FROM sys.tables
         WHERE name NOT LIKE '%HF%';
         SELECT DISTINCT
                id = IDENTITY( INT, 1, 1),
                name
         INTO #TablesForCompression
         FROM sys.tables
         WHERE name NOT LIKE '%HF%';
         IF(OBJECT_ID('tempdb..#tmpresults')) IS NOT NULL
             DROP TABLE #tmpresults;
         CREATE TABLE #tmpresults
         (table_name                                     VARCHAR(100),
          schemaname                                     VARCHAR(3),
          indexid                                        INT,
          partitionnumbeer                               INT,
          size_with_current_compression_setting          INT,
          size_with_requested_compression_setting        INT,
          sample_size_with_current_compression_setting   INT,
          sample_size_with_requested_compression_setting INT
         );
         WHILE @Counter <= @MaxRowCount
             BEGIN
                 SELECT @tab_name = name
                 FROM #TablesForCompression
                 WHERE Id = @Counter;
                 INSERT INTO #tmpresults
                 EXEC sp_estimate_data_compression_savings
                      @schema_name = 'dbo',
                      @object_name = @tab_name,
                      @data_compression = 'page',
                      @index_id = NULL,
                      @partition_number = NULL;
                 SELECT @Counter = @Counter + 1;
             END;
         SELECT CAST((CAST(size_with_current_compression_setting AS DECIMAL) - CAST(size_with_requested_compression_setting AS DECIMAL)) / CAST(size_with_current_compression_setting AS DECIMAL) * 100 AS DECIMAL(10, 2)) AS Percentage_reduction,
                *
         FROM #tmpresults
         WHERE size_with_current_compression_setting <> 0
               AND (CAST(size_with_current_compression_setting AS DECIMAL) - CAST(size_with_requested_compression_setting AS DECIMAL)) / CAST(size_with_current_compression_setting AS DECIMAL) * 100 > 30;
     END;
GO

