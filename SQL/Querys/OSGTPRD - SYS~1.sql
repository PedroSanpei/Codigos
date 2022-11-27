select * from dba_objects where status !='VALID';

SELECT 'DROP SYNONYM ' || OBJECT_NAME || ';' FROM dba_objects where status !='VALID';
