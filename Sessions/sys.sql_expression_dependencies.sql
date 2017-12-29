declare @objectNames varchar(max) =	  'corptax_amount, corptax_amountinstance, corptax_amountlock, corptax_amount, journalentry,journalentry_item' 

     --         'corptax_amountinstance', 
     --         'corptax_amountlock', 
     --         'corptax_amountmline', 
     --         'journalentry', 
     --         'journalentry_item'


SELECT value  FROM STRING_SPLIT(@objectNames, ',');

WITH deps (parent, child, object_type) AS (
       SELECT 
       referencing_object_name = o.name, 
       referenced_entity_name,
       referencing_object_type_desc = o.type_desc 
       FROM sys.sql_expression_dependencies se 
       INNER JOIN sys.objects o 
       ON se.referencing_id = o.[object_id] 
       WHERE referenced_entity_name IN ( SELECT value  FROM STRING_SPLIT(@objectNames, ',') )
    UNION ALL
       SELECT 
       referencing_object_name = o.name, 
       referenced_entity_name,
       referencing_object_type_desc = o.type_desc 
       FROM sys.sql_expression_dependencies se 
       INNER JOIN sys.objects o 
       ON se.referencing_id = o.[object_id] 
       INNER JOIN deps ON deps.parent = referenced_entity_name
       )
SELECT DISTINCT parent, object_type
FROM deps
ORDER BY object_type, parent
