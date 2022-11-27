-- 1º De um drop no DBLINK do TRCSTKMB e do TRITKMB
DROP DATABASE LINK R12DBLINK.A423710.ORACLECLOUD.INTERNAL;

--2º Após dar um drop pode criar novamente lembrando de alterar as informações do CONNECT TO e do INDETIFIED BY e USING.
CREATE DATABASE LINK "R12DBLINK.A423710.ORACLECLOUD.INTERNAL" 
   CONNECT TO "XXISV" IDENTIFIED BY XXISVPRD -- USUÁRIO E SENHA EM "MAIÚSCULO   "
   USING 'K2HOM';
--3º Após criar rode um teste para ver se está funcionando
SELECT * FROM dual@R12DBLINK.A423710.ORACLECLOUD.INTERNAL;
--4º Caso retornar erro de TNS: Não foi possível resolver o identificar de conexão rode o select abaixo na máquina do banco do OSGT
select value from v$parameter where name like '%service_name%';

   
--Select que consulta os Datafiles com o caminho e o tamanho
SELECT
	tablespace_name,
	file_name,
	autoextensible,
	round(bytes/1024/1024,2)	as "Bytes MB",
	round(maxbytes/1024/1024,2) as "Max Bytes MB" 
 FROM dba_data_files where tablespace_name IN ('TR_KMB_DATA','TR_KMB_INDEX');
 
 -- Select verifica o TableSpace tamanho atual e tamanho livre.
 select
	b.tablespace_name,
	tbs_size SizeMb,
	a.free_space FreeMb
from (
	select
		tablespace_name,
		round(sum(bytes)/1024/1024 ,2) as free_space
	from 
		dba_free_space
		group by
			tablespace_name
	) a,
	(select
		 tablespace_name
		,sum(bytes)/1024/1024 as tbs_size
	from
		dba_data_files
	group by
		tablespace_name) b
where
	a.tablespace_name(+) = b.tablespace_name;
 