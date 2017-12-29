select (DATALENGTH(Content)/250000 * 250) Blob_Size_in_k , count(1) number_off_records, sum(DATALENGTH(Content))/1000 total_size_k
 from alldocstreams group by DATALENGTH(Content)/250000 order by 1

 select sum((DATALENGTH(Content)/1000)) total_size_k, count(1) number_off_records
 from alldocstreams
 where DATALENGTH(Content) > 1000000

 select a.RecordGroup, sum(a.RecordsSize)/1000000 total_size_mb, count(1) number_off_records
 from (
 select case when (DATALENGTH(Content) < 250000) then '0 - 250k'
			 when (DATALENGTH(Content) < 500000) then '250 - 500k'
			 when (DATALENGTH(Content) < 750000) then '500 - 750k'
			 when (DATALENGTH(Content) < 750000) then '750 - 1000k'
			 else 'Above 1000k' end as RecordGroup, 
			 DATALENGTH(Content) RecordsSize
			 from alldocstreams
) a group by a.RecordGroup
order by 1 

 select sum((DATALENGTH(Content)/1000)) total_size_k, count(1) number_off_records
 from alldocstreams
 where DATALENGTH(Content) < 1000000

 select count(1) from alldocstreams

 select sum((DATALENGTH(Content)/1000)) total_size_k, count(1) number_off_records
 from alldocstreams
 where DATALENGTH(Content) < 1000000

 select sum((DATALENGTH(Content)/1000)) total_size_k, count(1) number_off_records
 from alldocstreams
 where DATALENGTH(Content) > 1000000

 from alldocstreams group by DATALENGTH(Content)/100000 order by 1