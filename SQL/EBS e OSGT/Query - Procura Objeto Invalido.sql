SELECT
	syn.*
FROM
	dba_synonyms syn
WHERE
	SYNONYM_NAME	IN (select object_name from dba_objects where status !='VALID')
AND TABLE_NAME		IN (select object_name from dba_objects where status !='VALID');

SELECT OWNER, COUNT(1) FROM dba_objects WHERE STATUS != 'VALID' GROUP BY OWNER;


SELECT * FROM USER_OBJECTS WHERE status !='VALID' ;


SELECT * FROM USER_SYNONYMS WHERE SYNONYM_NAME IN (select OBJECT_NAME from user_objects where object_type = 'SYNONYM' AND STATUS != 'VALID')
SELECT OWNER, COUNT(1) FROM dba_objects WHERE STATUS != 'VALID' GROUP BY OWNER;