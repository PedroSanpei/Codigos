
with num_filter as(
	select
		seq.sequence_name,
		regexp_replace(seq.sequence_name, '[^0-9]') as num,
		seq.last_number,
		seq.min_value,
		seq.max_value,
		seq.increment_by
	from
		all_sequences seq
	WHERE
		seq.sequence_name LIKE 'JL_BR_TRX_NUM_%_%_S%'
)
SELECT
	num_filter.sequence_name,
	substr(num_filter.num, -3) as OU,
	substr(num_filter.num, 0, length(num_filter.num) -3) as batch_source_id,
	bat.name,
	num_filter.last_number,
	num_filter.min_value,
	num_filter.max_value,
	num_filter.increment_by
FROM
	num_filter

inner join
	apps.ra_batch_sources_all bat on
		bat.org_id = to_number(substr(num_filter.num, -3))
	and bat.batch_source_id = to_number(substr(num_filter.num, 0, length(num_filter.num) -3))
;

SELECT * FROM
	all_sequences seq
WHERE
	seq.sequence_name LIKE 'JL_BR_TRX_NUM_%_145_S%';

select r.text, lr.display_name
from wf_resources r, wf_local_roles lr
where r.name='WF_ADMIN_ROLE'
and r.text=lr.name(+);

select * from ra_batch_sources_all;