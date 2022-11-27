-- OSGT - SYS
SELECT
	syn.*
FROM
	dba_synonyms syn
WHERE
	SYNONYM_NAME	IN (select object_name from dba_objects where status !='VALID')
AND TABLE_NAME		IN (select object_name from dba_objects where status !='VALID');