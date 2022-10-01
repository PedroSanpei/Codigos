-- @@@ DEVE SER EXECUTADO COM O TRITKMB @@@
DECLARE
-- Variavel para salvar o comando
V_COMMAND VARCHAR(4000) := NULL;

BEGIN
-- Loop que popula cursor REC
FOR REC IN (SELECT * FROM ALL_SYNONYMS WHERE DB_LINK LIKE '%INTERNAL%') LOOP

--V_COMMAND := 'create or replace synonym ' || rec.synonym_name || ' for ' || REC.TABLE_OWNER || '.' || rec.table_name ||'@'||'R12DBLINK.SUB10221744180.EBSVCN.ORACLEVCN.COM';
--SELECT 'create or replace synonym ' || rec.synonym_name || ' for ' || 'TRIOKMB' || '.' || rec.table_name FROM (select * from USER_SYNONYMS where table_owner = 'IMPORT_USER') REC;
-- Executa comandos
EXECUTE IMMEDIATE V_COMMAND;

 END LOOP;
END;


CREATE [OR REPLACE] [PUBLIC] SYNONYM [schema .] synonym_name
  FOR [schema .] object_name [@ dblink];
  
  
  