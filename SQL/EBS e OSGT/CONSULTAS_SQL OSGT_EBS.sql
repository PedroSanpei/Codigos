    --consulta open interface RI - EBS
SELECT
-- a.*
 a.invoice_num, a.other_expenses, a.import_other_val_included_icms
  FROM CLL.CLL_F189_INVOICES_INTERFACE a
 WHERE SOURCE = 'SOFTWAY'
  and invoice_num IN ('121')
   and series = 9;
   
--iten open
SELECT sum(ili.TOTAL_AMOUNT)
  FROM CLL.CLL_F189_INVOICE_LINES_IFACE ili
 WHERE 1=1
   and INTERFACE_INVOICE_ID IN
       (SELECT INTERFACE_INVOICE_ID
          FROM CLL.CLL_F189_INVOICES_INTERFACE
         WHERE SOURCE = 'SOFTWAY'
         and invoice_num IN ('3886')
   and series = 11) ;

-- Consulta Open Interface RI Header com as linhas - EBS
SELECT
    a.*,
    b.error_code,
    b.error_message
FROM
    cll.cll_f189_invoice_lines_iface    a,
    cll.cll_f189_interface_errors       b
WHERE
        a.interface_invoice_id = (
            SELECT
                interface_invoice_id
            FROM
                cll.cll_f189_invoices_interface
            WHERE
                    source = 'SOFTWAY'
                AND invoice_num IN ( '3418' )
                AND series = 11
        )
    AND a.interface_invoice_line_id = b.interface_invoice_line_id;

SELECT *
  FROM CLL.CLL_F189_INVOICE_LINES_IFACE
 WHERE INTERFACE_INVOICE_ID IN
       (SELECT INTERFACE_INVOICE_ID
          FROM CLL.CLL_F189_INVOICES_INTERFACE
         WHERE SOURCE = 'SOFTWAY'
         and invoice_num IN ('121')
        and series = 9);

--Consulta tabelas finais RI -EBS
SELECT A.*
  FROM cll.CLL_F189_STATES              H,
       cll.CLL_F189_FISCAL_ENTITIES_ALL F,
       cll.CLL_F189_INVOICES            A
 WHERE H.STATE_CODE = 'EX'
   AND H.STATE_ID = F.STATE_ID
   AND F.ENTITY_ID = A.ENTITY_ID
   AND INVOICE_NUM IN ('20200021')
   AND SERIES = 11
 ORDER BY INVOICE_ID;
 
SELECT I.*
FROM   CLL_F189_INVOICE_LINES I
WHERE  INVOICE_ID IN (SELECT A.INVOICE_ID
  FROM CLL_F189_STATES              H,
       CLL_F189_FISCAL_ENTITIES_ALL F,
       CLL_F189_INVOICES            A
 WHERE H.STATE_CODE = 'EX'
   AND H.STATE_ID = F.STATE_ID
   AND F.ENTITY_ID = A.ENTITY_ID
   AND INVOICE_NUM IN ('20200021')
   AND SERIES = 11)
ORDER BY I.INVOICE_ID;

-- Renotificar NotaFiscal RI para Em Elaboração LEMBRETE - DE COMMIT DEPOIS DE EXECUTAR!!!! - OSGT
update bs_nota_fiscal a
   set a.status_nf = 'Em Elaboração.', a.nfe_sefaz_status = 'Em Elaboração.'
 where num_nf in (3886)
   and a.serie = 11;
   
-- Renotirficar NotaFiscal RI para Aprovada SEFAZ LEMBRETE - DE COMMIT DEPOIS DE EXECUTAR!!!! - OSGT
update bs_nota_fiscal a
   set a.status_nf = 'Impressa.', a.nfe_sefaz_status = 'Aprovada - SEFAZ.'
 where num_nf in(3886)
   and a.serie = 11; 
   
-- Consulta a Tabela de Notifação    - OSGT
select a.*, a.rowid
from oif_export a
where 1 = 1
and id_evento = 5521 -- RI
and a.pk_number_01 in
(select id_notafiscal
from bs_nota_fiscal a
where 1 = 1
--and status in (2, 3, 1)
and num_nf in
('121')
and a.serie in (9))
order by pk_number_01;

-- Select para consultar a chave de acesso da nota
select a.num_nf, a.serie, a.nfe_sefaz_status, a.nfe_sefaz_chave_acesso
  from trbskmb.nota_fiscal a
 where num_nf = 707
   and serie = 3;
  
  -- Update para alterar chave de acesso. 
--update trbskmb.nota_fiscal
--set NFE_SEFAZ_CHAVE_ACESSO = '13210314386045000150550030000007077000005112'
--where num_nf = 707
-- and serie = 3;

-- Relatório de Itens  OSGT
SELECT decode(c.id_organizacao, 301, 'KMB', 290, 'KCA') AS ORG,
       c.part_number,
       stp.descricao as tipo_produto,
       c.ncm,
       c.descricao_detalhada,
       c.seq_suframa,
       c.cod_prod_suframa,
       c.tipo_prod_suframa,
       c.id_detalhe_suframa,
       c.modelo_prod_suframa,
       nve.cd_atributo_ncm,
       nve.CD_ESPECIF_NCM,
       nve.CD_NIVEL_NCM,
       nve.ID_PRODUTO,
       nve.CD_NOMENC_NCM,
       ncmd.id_detalhe_suframa
  FROM sfw_produto c
  LEFT JOIN trkmb.sfw_produto_nve nve
    on nve.id_produto = c.id_produto
  LEFT JOIN TRKMB.sfw_detalhe_ncm_suframa ncmd
    on ncmd.id_detalhe_suframa = c.id_detalhe_suframa
  LEFT JOIN TRKMB.SFW_TIPO_PRODUTO stp
    on stp.tipo_produto = c.f
 where c.ID_ORGANIZACAO in (290, 301); -- kca e kmb
 
 -- Procura em todas as tabelas o que tiver o nome ou número que colocar no campo depois do like.
 select a.* from all_tables a where a.TABLE_NAME like '%NVE%';
 
 -- Select na tabela de Itens
 select * from MTL_SYSTEM_ITEMS_B where segment1 = '13008-0572';

-- Renotifica PO. 
 begin
  pkg_r12_kmb_notifica_geral_cst.prc_notifica_ordem_compra('9607'); --numero da PO
end; 
(Aconselho usar PL SQL usando o usuário TRSCTKMB e o BD KMBNGR)

--consulta POs paradas na interfces
select distinct oi.id_importacao, oi.num_pedido, R.TABLE_NAME, api.msg_padrao --, D.DATA
from TRIOKMB.ERROS_IMPORTACAO E,
TRIOKMB.REGISTROS_INTERFACES R,
TRIOKMB.SISTEMA S,
TRIOKMB.DATA_PROC D,
TRIOKMB.erros_api api,
TRIOKMB.is_ordem_importacao_header oi
where R.ID = E.ID
and S.ID_SISTEMA = E.ID_SISTEMA
and D.ID_IMPORTACAO(+) = R.ID_IMPORTACAO
-- and e.obs not like 'Falha no%'
and api.id = e.id
and oi.id_importacao = r.id_importacao
and oi.num_pedido not in
(select num_ordem from triskmb.ordens_importacao)
and oi.num_pedido = '8924.145'
ORDER BY ID_IMPORTACAO


--re-notific itens de POs paradas na interface
DECLARE
BEGIN
FOR cPROD IN (SELECT distinct a.part_number, '151' AS ORGANIZATION_ID --colocar o OR_ID correto (151= SP/ 149=KMB Manaus/157 = KCA
FROM TRIOKMB.IS_ITENS_ORDEM_IMPORTACAO a
where 1=1
and num_pedido = '8924.145' -- PO
and a.part_number not in
(select b.part_number
from trkmb.sfw_produto b
where FLEX_FIELD1 = 151)) -- ITENS DE PO NÃO CADASTRADOS
LOOP
--
PKG_R12_KMB_NOTIFICA_GERAL_CST.PRC_NOTIFICA_PRODUTOS(cPROD.PART_NUMBER,
cPROD.ORGANIZATION_ID);
--
END LOOP;
END;


--PO CRIADAS EBS COM USUÁRIO
select 
       a.segment1 || '.' || A.ORG_ID as NO_PO_OSGT,
       a.segment1 as NO_PO,
       A.ORG_ID,
       a.PO_HEADER_ID,
       ATTRIBUTE1 AS NO_INVOICE,
       A.AUTHORIZATION_STATUS AS STATUS,
       A.ATTRIBUTE_CATEGORY,
       A.INTERFACE_SOURCE_CODE,
       b.USER_NAME,
       to_char(A.CREATION_DATE, 'dd/mm/yyyy hh24:mi:ss') as creation_date, 
       to_char(A.LAST_UPDATE_DATE,'dd/mm/yyyy hh24:mi:ss') as last_update
  from apps.po_headers_all a, apps.fnd_user b
 Where 1 = 1
 and a.CREATED_BY = b.USER_ID
      AND  SEGMENT1 in ('39866')
   --and authorization_status = 'APPROVED'
   --AND to_char(a.CREATION_DATE, 'dd/mm/yyyy') = '13/02/2019'
 ORDER BY 2, 3
 
-- Consulta Item - EBS
select * from MTL_SYSTEM_ITEMS_B 
where 1=1
--AND segment1 = '13008-0572'
AND primary_uom_code = 'ROL' --Qual a Unidade de Medida ele está
AND ORGANIZATION_ID = 151 -- Organização (149-MANAUS, 151-SP, 147-Master)
AND GLOBAL_ATTRIBUTE3  IN (1, 2, 6)--MATERIAL IMPORTADO (origem do item)
ORDER BY 1,2


-- Verificar se número da nota bate com ID_NOTA 
SELECT
    *
FROM
    bs_nota_fiscal a
WHERE id_notafiscal IN ('3668');

SELECT
    *
FROM
    bs_nota_fiscal a
WHERE DT_EMISSAO LIKE '10/02/21';

-- Update no Status da nota na Tabela de notificação 
update oif_export a
set STATUS ='99999' where PK_NUMBER_01 IN ('3567','3568','3645','3646','3647','3648','3569','3660','3661','3662','3657','3658','3639','3656','3638','3640','3641');

update oif_export a
set STATUS ='1' where PK_NUMBER_01 IN ('');

---- Consulta a Tabela de Notifação  Pesquisando por status e quantidade de itens
SELECT *FROM oif_export a where pk_number_01 IN ('3567','3568','3645','3646','3647','3648','3660','3661','3662','3657','3658','3639','3656','3638','3640','3641');


select a.id_evento,
       a.pk_number_01,
       z.processo_di as processo,
       z.nfe_sefaz_chave_acesso,
       z.status_nf,
       z.nfe_sefaz_status,
       z.num_nf,
       z.serie,
       a.data_transacao,
       a.status,
       (select COUNT(1)
          from trbskmb.itens_nf a
         where a.id_notafiscal = z.id_notafiscal) as qtd_itens,
       case
         when a.status = 1 then
          'EM ESPERA'
         when a.status = 2 then
          'SUCESSO'
         when a.status = 3 then
          'PROCESSANDO'
         when a.status = 4 then
          'ERRO'
       end as Status

  from oif_export a, bs_nota_fiscal z
 where a.pk_number_01 = z.id_notafiscal
      --and z.serie in (11)
   and a.status  in (99999)
      --and z.num_nf in (178,180,181,182,183)
  --    and a.pk_number_01 in (3638)
   and a.id_evento in (6002, 6106, 6128) --enviar, inutilizar e cancelar
      --, 6106, 6128)
      --and status_nf <> 'Impressa.'
      --and nfe_sefaz_status like '%Liberada%'
      
   and to_char(data_transacao, 'yyyy/mm') = '2021/02'
 order by  z.processo_di ;
 
 
 
 
 
 
 
 --------------------------------------------------------------CASOS RETORNAR PO P6--------------------------------------------------------
select segment1 from PO_HEADERS_ALL -- EBS
Where attribute1 = '0059739';

--1UPDATE para colocar a invoice com outro nome 
update PO_HEADERS_ALL -- EBS
set attribute1 = '0059739_cancelada'
Where segment1 = 10330;

--2 Consulte antes de deletar
SELECT * FROM KWK_PO_HEADERS_INTERFACE_STG WHERE DOCUMENT_NUM = '0062243'; --EBS
SELECT * FROM KWK_PO_LINES_INTERFACE_STG a WHERE DOCUMENT_NUM ='0062243'; -- EBS

DELETE FROM KWK_PO_LINES_INTERFACE_STG a WHERE DOCUMENT_NUM ='0059739'; -- EBS
DELETE FROM KWK_PO_HEADERS_INTERFACE_STG WHERE DOCUMENT_NUM = '0059739'; -- EBS



--3. RETORNA STATUS DA INVOICE P6 WSK - WSK BANCO CIGAM
SELECT * FROM PARTS_INVOICE WHERE NU_INVOICE in ('0059739'); -- WSK
UPDATE PARTS_INVOCE -- WSK
SET ID_STATUS = null
WHERE NU_INVOICE = '0059739';

-- 4 DELETA O HEADER E A LINHA DESTA INVOICE - WSK BANCO CIGAM -- WSK
DELETE kmtt_po_lines_interface_stg WHERE DOCUMENT_NUM in ('0059739');
DELETE kmtt_po_headers_interface_stg WHERE DOCUMENT_NUM in ('0059739');


-- 5. APLICA O STATUS PROCESSADO NA STAGE DO PASSO 4 (SEMPRE LEMBRE DE SELECIONAR O COMANDO ANTES DE RODAR --WSK
/*BEGIN
 KMPR_KMTT_PO_INTERFACE();
END;*/


--------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------- Processo importar P6 de PRD para HML--------------------------------------
---------------------------------------------------- Processo importar P6 de PRD para HML--------------------------------------
-- 1° Fazer um select no CIGAM PRD para validar se essa INVOICE está em PRD
select * from parts_invoice@CIGAM_OFICIAL a where nu_invoice = '0060828';
select * from parts_invoice_item@CIGAM_OFICIAL where nu_invoice = '0060828';
-- 2° Fazer a cópia da Invoice de PRD para HML do Header e das linhas para CIGAM Teste
    -- Insert Header
insert into parts_invoice
select * from parts_invoice@CIGAM_OFICIAL where nu_invoice = '0060828';
    -- Insert Linhas
insert into parts_invoice_item
select * from parts_invoice_item@CIGAM_OFICIAL where nu_invoice = '0060828';

-- 3° Alterar o status da Invoice para Null seria igual a não processada
UPDATE PARTS_INVOICE
SET ID_STATUS = null
WHERE NU_INVOICE = '0060828';

-- 4° Rodar a procedure que irá inserir essa invoice no EBS / Validar no WSK em Pedidos - Compra > P6 > Gerar e irá aparecer se tem alguma com erro. Caso não ele irá rodar a procedure abaixo:
/*BEGIN
 KMPR_KMTT_PO_INTERFACE() -- Não necessita colocar  parâmeto;
END;*/
/*Ou abra a procedure e rode KMPR_KMTT_PO_INTERFACE*/
-- 5° Checar no EBS se já existe ou se o status está "Pending" 
SELECT * FROM apps.KWK_PO_HEADERS_INTERFACE_STG@K2HOM WHERE DOCUMENT_NUM = '0060828';
SELECT * FROM apps.KWK_PO_LINES_INTERFACE_STG@K2HOM a WHERE DOCUMENT_NUM ='0060828';

-- 6° Rodar concurrent


---------------------------------------------------------------------------------------------------------------------------------


-- INVALIDAR ITEM CADASTRADO ERRADO PARA SUBIR NOVAMENTE
update apps.mtl_system_items_b
set segment1 = '-13008-0572' -- Número do ITEM ou PART_NUMBER
where inventory_item_id = 46134; -- INVENTORY_ITEM_ID do PART_NUMBER

--3 linhas atualizadas.
--commit


----------------------------------------------------------------IMPORTANDO O CADASTRO CORRIGIDO DOS ITENS DO EXCEL PARA O BD---------------------------------------------------------
--1º Crie um backup da Tabela fazendo uma cópia
CREATE TABLE kwk_item_temp_iface_backup as (select * from kwk_item_temp_iface);
--2° Depois deleta ou limpe a tabela original.
DELETE FROM kwk_item_temp_iface;A
--3°Abre o excel e tire tudo que tive Enter(ctrl+j), Aspas Simples('), Ecomercial(&), Barra Invertida (\) e substitui por '||CHR()||' cada um podemos ver no ASCII.
https://www.ascii-code.com/
--3.1 Lembrar de apagar todos os itens que forem modelos para não subir para a interface. Você consegue validar isso por usar essa Query 
SELECT * FROM KWK_ITEM_TEMP_IFACE WHERE NCM = 'N/A' AND ORG ='MA';
--4° Depois fazer uma contatenação ="insert into kwk_item_temp_iface (cd_material, description, long_description, ncm, cest, tipo_mat, ORG) values('"&B7&"','"&E7&"','"&F7&"','"&G7&"','"&H7&"','"&J7&"','"&K7&"');"
--5° Após ter dado o insert na tabela provisória tem que fazer a correção no campo cest
	UPDATE kwk_item_temp_iface 
	set cest = replace(cest,'.','')-- retira e substitui pontos do campo cest;

	
-- Selects usados para fazer a consulta	
SELECT * FROM kwk_item_temp_iface;

SELECT COUNT(1) FROM kwk_item_temp_iface;



-- Comandos para criar um novo DF (20/07)
ALTER TABLESPACE TR_KMB_DATA ADD DATAFILE '+DATA' SIZE 50m AUTOEXTEND ON NEXT 50m MAXSIZE UNLIMITED; 

-- Altera o tamanho do Data File 
ALTER DATABASE DATAFILE 
'+DATA/OSGTPRDB_GRU1X7/DATAFILE/tr_kmb_index.271.1027474511' -- Caminho do Data File que você consegue pegar usando o select Consulta DataFiles com o caminho e tamanho
RESIZE 20G;

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
    
    
 -- CONSULTA OOS MAIORES OBJETOS DO BANCO
SELECT
	*
FROM
	(SELECT
		s.tablespace_name,
		s.owner,
		s.segment_name,
		s.segment_type,
		to_char(trunc(s.bytes /(1024 * 1024)), '999G999G999', 'NLS_NUMERIC_CHARACTERS=,.') AS "SIZE (GB)",
		l.table_name,
		l.column_name 
	from
		 dba_segments s
		,dba_lobs l
	where
		s.OWNER = l.OWNER(+)
	and s.tablespace_name = l.tablespace_name(+)
	and s.segment_name = l.SEGMENT_NAME(+)
	order by
		bytes desc
	) x
where 
rownum <= 10;   

SELECT
    tablespace_name,
    file_name,
    autoextensible,
    round(bytes/1024/1024,2)    as "Bytes MB",
    round(maxbytes/1024/1024,2) as "Max Bytes MB" 
 FROM dba_data_files;


/*Script aplicado para correção do fabricante na PO.
Deve ser feito antes da PO entrar na fatura. Se a PO já estiver na fatura, deve ser retirada da fatura  e aplicar a correção na PO.*/

----correção fabricante na PO------------------------------------
DECLARE
BEGIN
  FOR c IN (SELECT distinct PP.ID_PRODUTO, P.COD_PARCEIRO as fabri, io.num_ordem
    FROM SFW_PRODUTO_PARCEIRO PP, SFW_PARCEIRO P, triskmb.itens_ordem io
   WHERE PP.ID_PARCEIRO = P.ID_PARCEIRO
     and PP.ID_PRODUTO = io.cod_peca
     and num_ordem in ('1.145','2.145') ) ---informar os números das POs
  LOOP
    --
    update triskmb.itens_ordem tio
       set tio.cod_fabricante = c.fabri
     where tio.num_ordem =  c.num_ordem 
     and tio.cod_peca = c.id_produto
     and tio.cod_fabricante <> c.fabri;
     commit;
    --
  END LOOP;
END;


-- Tabela que consulta Transação NF Sefaz (Tela AR-TRANSAÇÕES-TRANSAÇÕES)
select c.TRX_NUMBER, C., a. 
  from APPS.JL_BR_CUSTOMER_TRX_EXTS a, -- DADOS NA NFE_ELETRONICA
       APPS.RA_CUSTOMER_TRX_ALL     c
 where c.CUSTOMER_TRX_ID = a.CUSTOMER_TRX_ID
   and trx_number = '66176' --NÚMERO DA NOTA
   
--CONSULTA NOTIFICAÇÃO DE PRODUTO NO EBS
SELECT N.CREATION_DATE, T.SEGMENT1, N.*
FROM CLL_F255_NOTIFICATIONS N, mtl_system_items_b T
WHERE ISV_NAME = 'SFTCMX'
AND EVENT_NAME IN ('oracle.apps.cll.mtl_system_items_b')
AND PARAMETER_VALUE2 = T.INVENTORY_ITEM_ID
AND EXPORT_STATUS = 5 -- 5 erro na notificação do lado do EBS
AND T.SEGMENT1 IN ('RCP2-SS7R-I-42P-6-200-P1-M-B-ML', 'RPCON-42P',
'HD-30AX', 'RCP2-SA7C-I-56P-4-800-P1-M-BR', 'RGW-CC',
'TS-180', 'PCON-C-56PI-NP-2-0')
ORDER BY N.CREATION_DATE DESC;

--Renotifica PO
begin
  pkg_r12_kmb_notifica_geral_cst.prc_notifica_ordem_compra('12616'); --numero da PO
end; 
(Aconselho usar PL SQL usando o usuário TRCTKMB e o BD KMBNGR)

--consulta notifcação de PO no EBS
SELECT DISTINCT PO.SEGMENT1,
PO.PO_HEADER_ID,
EXPORT_STATUS,
NT.CREATION_DATE
FROM apps.CLL_F255_NOTIFICATIONS NT, APPS.PO_HEADERS_ALL PO
WHERE ISV_NAME = 'SFTCMX'
AND EVENT_NAME = 'oracle.apps.cll.po_headers'
AND PARAMETER_VALUE1 = PO.PO_HEADER_ID
AND PO.SEGMENT1 in ('12790') -- NUMERO DA PO
-- AND EXPORT_STATUS = 1 -- STATUS 1 = NOTIFICADA PARA INTERFACE ; 4 = ERRO
order by NT.creation_date desc



---------------------Merge correção fabricante na PO------------------------------------
merge into triskmb.itens_ordem "if"
	using
	(SELECT  pp.id_produto
			,p.cod_parceiro AS fabri
		FROM
			trkmb.sfw_produto_parceiro  pp
		inner join
			trkmb.sfw_parceiro p on
				pp.id_parceiro = p.id_parceiro
	) c
		on (c.id_produto = "if".cod_peca
		--and c.fabri != "if".cod_fabricante
		)
	when matched then
		update set
			"if".cod_fabricante = c.fabri
		where
		/*
		 --@@ ATUALIZACAO POR PO!!! @@
		"if".num_ordem in
		('11470.145','11769.145')
		
		/*
		-- @@ ATUALIZACAO POR INVOICE!!! @@
		-- por invoice
	"if".flex_field13 in
('KMB-17A-025',
'KMB-14V-053',
'KMB-1RE-030')
--*/

-- SELECT CONTA QUANTIDADE REGISTROS POR PO.
select num_ordem, flex_field13, count(1) from triskmb.itens_ordem where num_ordem in ('2018.155',
'2019.155',
'2020.155',
'2021.155',
'2022.155',
'2023.155',
'2024.155',
'2025.155',
'2026.155',
'2027.155',
'2028.155',
'2029.155',
'2030.155'
);group by num_ordem, flex_field13;
;

SELECT a.num_ordem, a.flex_field13,a.cod_fabricante, b.nome_fantasia 
from itens_ordem a, sfw_parceiro b where a.num_ordem in ('2116.155',
'2122.155',
'2117.155',
'2119.155',
'12979.145'
)
AND a.cod_fabricante = b.cod_parceiro
order by a.num_ordem;


-- Select para ver as linhas da PO - OSGT
select
	linhas.num_ordem,
	linhas.cod_fabricante as fabri_ordem,
	parceiro.cod_parceiro as fabri_osgt,
	linhas.num_item,
	row_number() over (order by linhas.num_item asc) as linha,
	linhas.*
from 
	triskmb.itens_ordem linhas

inner join
	trkmb.sfw_produto_parceiro cad_item on
		cad_item.id_produto = linhas.cod_peca

inner join
	trkmb.sfw_parceiro parceiro on
		parceiro.id_parceiro = cad_item.id_parceiro
where
	linhas.num_ordem in ('12769.145')
order by 
	linhas.num_item
;

--Consulta tabelas finais RI -EBS
SELECT A.*
  FROM CLL_F189_STATES              H,
       CLL_F189_FISCAL_ENTITIES_ALL F,
       CLL_F189_INVOICES            A
 WHERE H.STATE_CODE = 'EX'
   AND H.STATE_ID = F.STATE_ID
   AND F.ENTITY_ID = A.ENTITY_ID
   AND INVOICE_NUM IN ('3181','3182','3183','3184')
   AND SERIES = 11
 ORDER BY INVOICE_ID;
 
 -- CONSULTA PO por NF - OSGT
SELECT num_nf,
       serie,
       A.PEDIDO,
       A.SENF,
       id_notafiscal,
       status_nf,
       nfe_sefaz_status,
       dt_emissao,
       dt_entrada,
       dt_atualizacao,
       dt_cancelamento,
       nfe_sefaz_chave_acesso
  FROM TRBSKMB.NOTA_FISCAL A
 WHERE num_nf IN ('987',
                  '988',
                  '989',
                  '990',
                  '991',
                  '992',
                  '993',
                  '994',
                  '995',
                  '996',
                  '997')
AND
    serie = 3;
    
    
-- Select Despesas de Custo (OSGT>Import>Custos)
SELECT ID_DESPESA, VALOR_PREVISTO, VALOR
  FROM TRISKMB.DESPESAS_PROCESSO
 WHERE COD_PROCESSO = 'KSP-0040/21'
 --AND ID_DESPESA = 'Taxa Emissão DI'
 
 
 -- Relação de Usuários OSGT
SELECT
	sis.id_sistema,
	sis.descricao,
	sis.user_oracle,
	get_decrypto(sis.password) pass_oracle,
	cm.s_user soft_user,
	decode(cm.s_cripto, 'S', get_decrypto(cm.s_pass), cm.s_pass) soft_user_pass,
	cm.s_role role_user,
	cm.s_schema_owner schema_owner,
	decode(cm.s_cripto, 'S', get_decrypto(cm.s_owner_pass), cm.s_owner_pass) schema_owner_pass,
	cm.s_tns tns,
	cm.s_sigla sigla,
	cm.S_TABLESPACE_INDEX_1M,
	S_TABLESPACE_DATA_1M
FROM
	triokmb.sistema	sis
	LEFT JOIN
		sfw_cm_schema cm ON
			sis.user_oracle = cm.s_schema_owner;
select * from triokmb.sistema;
			SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM DBA_OBJECTS WHERE STATUS <> 'VALID';
            
            
-- SELECT PO COM LINHAS - IDENTIFICADOR Categoria Revenda e Matéria Prima
SELECT a.PO_HEADER_ID, a.segment1, b.item_id,b.category_id, b.item_description, b.transaction_reason_code FROM po_headers_all a, po_lines_all b 
WHERE a.PO_HEADER_ID = b.PO_HEADER_ID
AND a.segment1 = '13035'
AND b.category_id != '18149'; -- (18149 = Revenda; 18145 = Matéria Prima


-- SELECT MOSTRA PO e FABRICANTE por linha
SELECT a.num_ordem, a.flex_field13,a.cod_fabricante, b.nome_fantasia 
from itens_ordem a, sfw_parceiro b where a.num_ordem in ('2116.155',
'2122.155',
'2117.155',
'2119.155',
'12979.145'
)
AND a.cod_fabricante = b.cod_parceiro
order by a.num_ordem;


-- SELECT COMPARA PO FABRICANTE COM ITEM FABRICANTE
SELECT
    a.num_ordem,
    c.part_number       AS ITEM_PO,
    a.cod_fabricante    AS COD_FABRICANTE_PO,
    b.nome_fantasia     AS NOME_FABRICANTE_PO,
    d.part_number_parceiro       AS ITEM_CADASTRADO_OSGT,
    f.cod_parceiro      AS COD_FABRICANTE_CADASTRADO_OSGT,
    f.nome_fantasia     AS NOME_FABRICANTE_CADASTRO_OSGT
FROM
    itens_ordem           a,
    sfw_parceiro          b,
    sfw_produto           c,
    sfw_produto_parceiro  d,
    sfw_produto           e,
    sfw_parceiro          f
WHERE
    a.num_ordem IN ('13025.145',
'2128.155',
'2129.155',
'2127.155')
    AND a.cod_fabricante = b.cod_parceiro
    AND a.cod_peca = c.id_produto
    AND d.id_produto = e.id_produto
    AND f.id_parceiro = d.id_parceiro
    AND a.cod_peca = d.id_produto
ORDER BY
    a.num_ordem;
    
-- SELECT COMPARA PO FABRICANTE COM ITEM FABRICANTE OSGT + EBS
SELECT
    a.num_ordem,
    c.part_number       AS ITEM_PO,
    a.cod_fabricante    AS COD_FABRICANTE_PO,
    b.nome_fantasia     AS NOME_FABRICANTE_PO,
    d.part_number_parceiro       AS ITEM_CADASTRADO_OSGT,
    f.cod_parceiro      AS COD_FABRICANTE_CADASTRADO_OSGT,
    f.nome_fantasia     AS NOME_FABRICANTE_CADASTRO_OSGT,
    CONCAT(g.manufacturer_id,'M') COD_FABRICANTE_EBS,
    g.description AS NOME_FABRICANTE_EBS
FROM
    TRISKMB.itens_ordem           a,
    TRISKMB.sfw_parceiro          b,
    TRISKMB.sfw_produto           c,
    TRISKMB.sfw_produto_parceiro  d,
    TRISKMB.sfw_produto           e,
    TRISKMB.sfw_parceiro          f,
    MTL_MANUFACTURERS@r12dblink g
WHERE
    /*a.num_ordem IN ('13025.145',
'2128.155',
'2129.155',
'2127.155')
    AND*/ a.cod_fabricante = b.cod_parceiro
    AND a.cod_peca = c.id_produto
    AND d.id_produto = e.id_produto
    AND f.id_parceiro = d.id_parceiro
    AND f.cod_parceiro = concat(g.manufacturer_id,'M')
    AND a.cod_peca = d.id_produto
ORDER BY
    a.num_ordem;
    

-- Query para descobrir ordem da KMB
select wdj1.wip_entity_name OP_KCA,
       wdj2.wip_entity_name OP_KMB,
       wdj2.wip_entity_id   ID_OP_KMB,
       wdj1.wip_entity_id   ID_OP_KCA
from APPS.WIP_DISCRETE_JOBS_V wdj1,
     APPS.WIP_DISCRETE_JOBS_V wdj2,
     APPS.WIP_DISCRETE_JOBS    wdj,
     apps.oe_order_lines_all oela,
     APPS.PO_REQUISITION_HEADERS_ALL prha,
     apps.dtt_wip_chassi_motor dwcm
where wdj2.WIP_ENTITY_NAME in ('276140') -- Se caso quiser procurar da KCA para KMB é só inverter o user wdj1.
and   wdj.WIP_ENTITY_ID = wdj1.WIP_ENTITY_ID
and   oela.line_id = wdj.SOURCE_LINE_ID
and   prha.requisition_header_id = oela.SOURCE_DOCUMENT_ID
and   dwcm.nr_chassi = prha.ATTRIBUTE2
and   wdj2.WIP_ENTITY_ID = dwcm.ID_ORDEM_PRODUCAO; 


--consulta valor de ICMS enviado para SEFAZ
Select sum(icms_valor_bc_51) as base_icms, sum(icms_valor) as valor_icms
  from trbskmb.nf_eletronica_item
 where CODIGO_NF = 5129
 
-- Select Simula cálculo ICMS OSGT  
Select a.part_number,
       iar.base_icms,
       iar.vlr_icms_devido,
       round(iar.base_icms, 2) as base_arr,
       round(iar.base_icms, 2) * 0.18 as vl,
       round(round(iar.base_icms, 2) * 0.18, 2) as vl_arr
  from trbskmb.nota_fiscal        nf,
       trbskmb.itens_nf           a,
       trbskmb.item_adicao_rateio iar
 where nf.id_notafiscal = a.id_notafiscal
   and nf.num_nf = 196
   and a.processo_di = 'KSP-0050/21' 
   and a.processo_di = iar.processo_di
   and a.part_number = iar.part_number
   and a.id_item_adicao = iar.id_item_adicao

--select consulta de tabelas
select a.* from all_tables a where a.TABLE_NAME like '%TRANSACTION%';

-- RELATÓRIO RMA PROCESSO - A TERMINAR
SELECT
    oha.order_number AS NUM_RMA,
    oha.order_type_id AS  COD_RMA,
    ott.description AS DESC_COD_RMA,
    oha.flow_status_code as STATUS,
    fu.user_name as USUÁRIO,
    rcta.trx_number AS NF
FROM
    apps.oe_order_headers_all       oha,
    apps.oe_transaction_types_tl    ott,
    apps.fnd_user fu,
    apps.RA_CUSTOMER_TRX_ALL RCTA
WHERE
        oha.order_type_id = transaction_type_id
    AND oha.order_type_id IN (
        SELECT
            transaction_type_id
        FROM
            apps.oe_transaction_types_tl
        WHERE
            name LIKE '%RMA%'
            AND LANGUAGE = 'PTB'
    )
AND OTT.LANGUAGE = 'PTB'
AND oha.created_by = fu.user_id
AND rcta.INTERFACE_HEADER_ATTRIBUTE2 = ott.DESCRIPTION;


 --consulta NF courier 
   SELECT inf.bs_icms, inf.vlr_icms
     FROM trbskmb.nota_fiscal nf, trbskmb.itens_nf INF
    WHERE NF.NUM_NF = 200
      AND NF.SERIE = 9
      AND NF.ID_NOTAFISCAL = INF.ID_NOTAFISCAL
      
--COMANDO PARA DESBLOQUEAR CONTA SQL
ALTER USER username ACCOUNT UNLOCK

--COSULTA FATURA POR NÚMERO DE LI
SELECT *
  FROM TRISKMB.FATURAS_IMPORTACAO      FI WHERE FI.ID_INVOICE IN
  (SELECT ID_INVOICE_MACRO
          FROM MACRO_ITEM
         WHERE 1=1 
         AND IDENTIFICACAO_LI = ('A-14V-056-1/4'))--lI
         
--CONSULTA PARCEIRO OSGT
select cod_parceiro,--party_site_id + S
       razao_social,
       cnpj,
       flex_field1 as party_id_EBS,
       flex_field2 as party_site_id_EBS,
       flex_field3 as vendor_site_id_EBS
  from sfw_parceiro
 where cod_parceiro = '31470S';
 
 --CONSULTA FORNECEDOR NO EBS
Select VENDOR_SITE_ID,
       PARTY_SITE_ID,
       PARTY_ID,
       ORG_ID,
       APS.CREATION_DATE,
       APS.LAST_UPDATE_DATE,
       APL.CREATION_DATE,
       APL.LAST_UPDATE_DATE
  from apps.ap_suppliers aps, apps.ap_supplier_sites_all apl
 where aps.vendor_id = apl.vendor_id
   AND PARTY_SITE_ID = 31470
   AND VENDOR_SITE_ID = 13929
   and org_id = 145



 -- SELECT CHECA SE FOI GERADO NOVA DI (CASOS DE INUTILIZAÇÃO SEM AGUARDE DE RESPOSTA SEFAZ)
SELECT
    a.id_notafiscal,
    a.part_number,
    a.id_adicao,
    a.processo_di,
    b.part_number,
    b.processo_di,
    b.id_adicao
FROM
    itens_nf            a,
    item_adicao_rateio  b
WHERE
    id_notafiscal = '5097'
AND a.processo_di = b.processo_di;-- Se os valores do ID_ADICAO forem diferentes quer dizer que há uma nova DI em andamento para gerar uma nova nota


-- Select fabricantes EBS
select MANUFACTURER_ID ||'M' as COD_PARCEIRO,
       MANUFACTURER_ID,
       MANUFACTURER_NAME,
       description,
       attribute1        as Codigo_do_Pais,
       attribute2        as Logradouro,
       attribute3        as Número,
       attribute4        as Complemento,
       attribute5        as Cidade,
       attribute6        as Estado
  from apps.MTL_MANUFACTURERs
  order by 3;
  
  
  --consulta log ordens de compra
select * from triskmb.log_ordens_importacao
where descricao like '%Fabricante%' --onde houve alteração de fabricante
and usuario is null
and descricao like '%31470S%' -- ONDE tem ateração do fabricante para 31470S
order by data_log asc;  

-- Procurar Fatura na Interface do AP.
select * from apps.ap_invoices_interface
where 1=1
and invoice_num like '%KMB-0674/21%'
order by creation_date desc;

-- SELECT DE NOTIFICAÇÃO DE PO DO LADO DO EBS PARA O OSGT
SELECT DISTINCT
    po.segment1,
    po.po_header_id,
    export_status,
    nt.creation_date,
    nt.last_update_date,
    nt.return_message    
FROM
    apps.cll_f255_notifications    nt,
    apps.po_headers_all            po
WHERE
        isv_name = 'SFTCMX'
    AND event_name = 'oracle.apps.cll.po_headers'
    AND parameter_value1 = po.po_header_id
---AND PO.SEGMENT1 in ('11020') -- NUMERO DA PO
    AND export_status = 1--  STATUS 1 = NOTIFICADA PARA INTERFACE ; 4 = ERRO
ORDER BY
    segment1 DESC;
    
--consulta log ordens de compra
select * from triskmb.log_ordens_importacao where num_ordem = '11016.145';

--CONSULTTA INTERFACE AP HEADER
SELECT INVOICE_ID FROM APPS.AP_INVOICES_INTERFACE
WHERE INVOICE_NUM = '4428606';

--CONSULTTA INTERFACE AP HEADER - LINHA
SELECT * from APPS.AP_INVOICE_LINES_INTERFACE
where invoice_id in (SELECT INVOICE_ID FROM APPS.AP_INVOICES_INTERFACE WHERE INVOICE_NUM = '4428606');

-- Análise de Erros de LOOKUP_TYPE LINE da Invoice AP.
SELECT
    a.invoice_id,
    a.invoice_num,
    b.invoice_line_id,
    b.line_type_lookup_code as INVOICE_LINE_TYPE, -- Dica: Olhar esse campo pois ele indica para você onde na tabela ap_lookup_codes. Por exemplo (line_type) = Campo lookup_type que tem que ter valor INVOICE LINE TYPE. _(lookup_code) = Campo Lookup Code.
    a.invoice_type_lookup_code INVOICE_HEADER_TYPE,
    to_char(a.creation_date, 'dd/mm/yyyy hh24:mi:ss'),
    a.status
FROM
    apps.ap_invoices_interface a,
    apps.ap_invoice_lines_interface b
WHERE A.INVOICE_ID = B.INVOICE_ID
AND invoice_num LIKE '%TDKMB-210501%';

--SELECT DE ERRO DA INTERFACE DO AP
SELECT DISTINCT
         a.invoice_num,
         a.invoice_date,
         a.vendor_id,
         a.vendor_site_id,
         a.party_id,
         a.party_site_id,
         a.status,
         a.source,
         a.invoice_type_lookup_code,
         a.invoice_amount, 
         a.description as invoice_description,
         d.description as erro_description
FROM
    apps.ap_invoices_interface a,
    apps.AP_INVOICE_LINES_INTERFACE b,
    apps.ap_interface_rejections c,
    apps.ap_lookup_codes d
WHERE
    1=1
AND a.invoice_id = b.invoice_id
AND a.source = 'SOFTWAY'
AND a.STATUS = 'REJECTED'
AND b.invoice_id = c.parent_id  -- Se o erro for na linha troque o b.invoice_id por b.invoice_line_id
AND c.reject_lookup_code = d.lookup_code
AND a.invoice_num like '%64090%';

-- SELECT TRAZ NÚMERO DE DI PRD QUE NÃO TEM HML
SELECT
    diprd.processo_di,
    diprd.num_di
FROM
    trbskmb.di@kmbngrprd diprd
WHERE
    NOT EXISTS (SELECT * FROM trbskmb.di dihml
        WHERE
            diprd.num_di = dihml.num_di);

-- SELECT DE NOTAS COM REJEIÇÃO NA INTERFACE + INFORMAÇÃO DA PO (TRCSTKMB)
SELECT DISTINCT
    a.interface_invoice_id, a.source, a.invoice_num, a.series, c.pedido, a.organization_id, a.location_code, b.error_code, b.error_message
FROM
    cll.cll_f189_invoices_interface@R12DBLINK.A423710.ORACLECLOUD.INTERNAL    a,
    apps.cll_f189_interface_errors@R12DBLINK.A423710.ORACLECLOUD.INTERNAL b,
    trbskmb.nota_fiscal c
WHERE
    a.invoice_num IN ('3549', '3590', '3591', '3592', '3593',
                     '3594', '3595', '3623', '3624', '3625',
                     '3631')
AND a.series = '11'
AND a.interface_invoice_id = b.interface_invoice_id
AND a.invoice_num = c.num_nf
AND a.series = c.serie;

-- SELECT VERIFICAR CONDIÇÃO PAGAMENTO ENTRE PO EBS X OSGT (TRCSTKMB)
SELECT
    a.num_ordem as NUM_ORDEM_OSGT,
    a.data_geracao,
    a.cod_condicao COND_PAGT_OSGT,
    b.descricao,
    c.segment1 as NUM_ORDEM_EBS,
    c.creation_date,
    c.terms_id,
    d.name AS COND_PAGT_EBS
FROM
    triskmb.ordens_importacao    a,
    triskmb.bs_profile_broker    b,
    po_headers_all@R12DBLINK.A423710.ORACLECLOUD.INTERNAL c,
    AP_TERMS@R12DBLINK.A423710.ORACLECLOUD.INTERNAL d
WHERE
    a.cod_condicao = b.id_profile
AND a.flex_field1 = c.po_header_id
AND c.terms_id = d.term_id
AND a.NUM_ORDEM in ('13233.145',
'12696.145',
'13475.145',
'13232.145',
'13235.145',
'12978.145');

--consultas DIs registradas no sistema do despachante
select 
area_negocio,
count(1) as qtd,
       to_CHAR(data_registro_di, 'YYYY/MM') AS DT_REGISTRO_DI
  from trbskmb.di a
 where diretorio_destino is null --registrada DI no sistema do despachante (quando não faz pelo OSGT não registra esse diretório)
   and area_negocio not in ('KMB_AD_SP_004') -- todas menos SP
 group by to_char(data_registro_di, 'YYYY/MM'),area_negocio
 order by to_char(data_registro_di, 'YYYY/MM'),area_negocio

-- SELECT DIFERENÇA DE DIAS ENTRE DATA CONHECIMENTO E LANÇAMENTO
SELECT
    a.num_ordem,
    b.cod_processo,
    a.data_geracao as DATA_CREATION_PO,
    c.data_conhecimento,
    c.data_criacao as DATA_LANCAMENTO,
    round(c.data_criacao - c.data_conhecimento, 0) as DIFERENÇA_DIAS
FROM
    ordens_importacao     a,
    faturas_importacao    b,
    processos_importacao  c
WHERE
a.nome_cliente = b.num_invoice
AND
b.cod_processo = c.cod_processo
AND
a.id_area = 'KCA_AD_AM_006' -- KMB_AD_SP_004 (SP), KMB_AD_AM_001 (MAN), KCA_AD_AM_006 (KCA)
AND to_char(c.data_criacao, 'yyyy/mm') BETWEEN '2021/07' AND '2021/08' -- Pesquisar data inicial até final.
order by diferença_dias desc;

--SELECTS INVENTÁRIO FÍSICO
select *
from apps.mtl_physical_inventories
where organization_id = 151;

select *
from apps.mtl_physical_inventory_tags
where physical_inventory_id = 2013;

select *
from apps.mtl_physical_adjustments
where physical_inventory_id = 2013;

select *
from apps.mtl_onhand_serial_v
where organization_id = 151;

--consultas DIs registradas no sistema do despachante
select 
area_negocio,
count(1) as qtd,
       to_CHAR(data_registro_di, 'YYYY/MM') AS DT_REGISTRO_DI
  from trbskmb.di a
 where diretorio_destino is null --registrada DI no sistema do despachante (quando não faz pelo OSGT não registra esse diretório)
   and area_negocio not in ('KMB_AD_SP_004') -- todas menos SP
 group by to_char(data_registro_di, 'YYYY/MM'),area_negocio
 order by to_char(data_registro_di, 'YYYY/MM'),area_negocio
 
 -- select pega notas rejeitadas + mensagem erro
SELECT
    nf.num_nf,
    nf.serie,
    nf.id_notafiscal,
    nf.status_nf,
    nf.nfe_sefaz_status,
    ane.descricao
FROM
    nota_fiscal              nf,
    auditoria_nf_eletronica  ane
WHERE
    nf.id_notafiscal = ane.id_notafiscal
    AND nfe_sefaz_status = 'Rejeitada - SEFAZ.'
    AND nf.status_nf = 'Em Elaboração.'
    AND ane.descricao like '%Rejei%o:%';
    
-- select para Papéis Uusário

SELECT * FROM WF_LOCAL_ROLES; -- Após fazer atualização de funcionários rodar concurrent no adm sistema CREATE FND_RESP WF ROLES

--CONSULTA BASE ICMS
Select a.part_number,
       iar.base_icms,
       iar.vlr_icms_devido,
       round(iar.base_icms, 2) as base_arr_JSON,--enviado no Json
       round(iar.base_icms, 2) * 0.18 as vl_icms_JSON,--enviado no Json
       round(round(iar.base_icms, 2) * 0.18, 2) as vl_arr_xml -- vl no xml com 2 casas
  from trbskmb.nota_fiscal        nf,
       trbskmb.itens_nf           a, 
       trbskmb.item_adicao_rateio iar
 where nf.id_notafiscal = a.id_notafiscal
   and nf.num_nf = 165
   and a.processo_di = 'KSP-0018/21' 
   and a.processo_di = iar.processo_di
   and a.part_number = iar.part_number
   and a.id_item_adicao = iar.id_item_adicao

-- DELETE CABEÇALHO DA INVOICE NA OPEN INTERFACE
DELETE 
  FROM CLL.CLL_F189_INVOICES_INTERFACE a
 WHERE SOURCE = 'SOFTWAY'
  and invoice_num IN ('3886')
   and series = 11;
   
   
   -- DELETE LINHAS DA INVOICE NA OPEN INTERFACE
  DELETE
  FROM CLL.CLL_F189_INVOICE_LINES_IFACE ili
   WHERE 1=1
   and INTERFACE_INVOICE_ID IN
       (SELECT INTERFACE_INVOICE_ID
          FROM CLL.CLL_F189_INVOICES_INTERFACE
         WHERE SOURCE = 'SOFTWAY'
         and invoice_num IN ('3886')
   and series = 11) ;
   
   
-- SELECT DE RESPONSABILIDADES POR USUÁRIO:
SELECT
    a.user_id,
    c.user_name,
    b.responsibility_key,
    a.start_date,
    a.end_date,
    a.creation_date,
    e.location_code,
    CASE WHEN c.user_name not in ('MARCELO.SOUZA','ALESSANDRA.FREITAS','KAREM.PAIVA')
    THEN 'RETIRAR RESP.'
ELSE 'RESPONSABILIDADE CONFERE'
END AS RESULTADO
        
FROM
    apps.fnd_user_resp_groups_direct a,
    apps.fnd_responsibility b,
    apps.fnd_user c,
    apps.per_all_assignments_f d,
    APPS.hr_locations_all_tl e
WHERE
     a.responsibility_id = b.responsibility_id 
AND
     a.responsibility_application_id = b.application_id
AND
     a.user_id = c.user_id
AND
     c.employee_id = d.person_id
AND
     d.location_id = e.location_id
AND
    e.language = 'US'
AND  
     b.responsibility_key in ('KMB_INV_ADM') -- Filtro puxando por responsabilidade;
     
-- select erros na interface AR
SELECT
    rila.interface_line_id,
    rila.interface_line_attribute1,
    rila.interface_line_attribute2,
    rila.description,
    rila.amount,
    riea.message_text
    
FROM
    apps.ra_interface_lines_all rila,
    apps.RA_INTERFACE_ERRORS_ALL riea
WHERE
        rila.interface_line_id = riea.interface_line_id
AND     interface_line_attribute1 = '27076';



-- SELECT DTT - Transferência Subinventário Destino
select /*+ index (MTL_MATERIAL_TRANSACTIONS_N1) */ rec.po_line_id
     , rec.line_num
     , rec.po_header_id
     , rec.numero_po
     , rec.shipment_header_id
     , rec.transaction_id
     , rec.quantidade_copias
     , rec.invoice_number
     , rec.control_number
     , rec.numero_lote
     , rec.numero_lote_sc
     , rec.packing_slip --
     , rec.codigo_item
     , rec.modelo_item
     , rec.descricao_item
     , rec.numero_caixa
     , rec.linha
     , rec.quantidade
     , nvl(mmt.transaction_quantity, 0) quantidade_transferida
     , mmt.transaction_date data_transferencia
     , rec.subinventario_origem
     , mmt.subinventory_code subinventario_destino
     , nvl((select 'Y'
             from mtl_secondary_inventories msi
            where msi.organization_id = rec.organization_id
              and msi.secondary_inventory_name = mmt.subinventory_code
              and msi.attribute2 = '1'), 'N') sub_defeituoso_flag
     , rec.organization_id
     , rec.inventory_item_id
     , (select fu.user_name
          from fnd_user fu
         where fu.user_id = mmt.created_by) usuario
     , mmt.transaction_reference referencia
     , rec.cod_barras_flag -- (Indica se tem o modelo da moto preenchido)
     , rec.status_flag
     , rec.transaction_date
  from (select pla.po_line_id
              ,pla.line_num line_num
              ,pha.po_header_id
              ,pha.segment1 numero_po
              ,rt_deliver.shipment_header_id
              ,rt_deliver.transaction_id
              ,rt_deliver.attribute1 quantidade_copias
              ,pha.attribute1 invoice_number
              ,pla.attribute1 control_number
              ,pla.attribute2 numero_lote
              --,rt_deliver.vendor_lot_num numero_lote_sc
              ,nvl(rt_deliver.vendor_lot_num, (select vendor_lot_num
                                                 from rcv_transactions rt2
                                                where rt2.shipment_line_id = rt_deliver.shipment_line_id
                                                  and rt2.transaction_type = 'RECEIVE' ))  numero_lote_sc
              ,(select packing_slip
                  from rcv_shipment_headers rsh
                 where rsh.shipment_header_id = rsl.shipment_header_id) packing_slip --
              ,msib.segment1 codigo_item
              ,nvl(pha.attribute2,
                   (select drsr.codigo_modelo
                       from dtt_ri_status_recebimento drsr
                      where drsr.inventory_item_id = pla.item_id
                        and drsr.organization_id =
                            plla.ship_to_organization_id
                        and ((drsr.invoice_lote = pha.attribute1) or
                            (drsr.invoice_lote = pla.attribute2)))) modelo_item
              ,msib.description descricao_item
              ,pla.attribute3 numero_caixa
              ,substr(pla.attribute1, length(pla.attribute1) - 3) linha
              ,rsl.quantity_received quantidade -- commentado PLA.QUANTITY QUANTIDADE
              ,rt_deliver.subinventory subinventario_origem
              ,plla.ship_to_organization_id organization_id
              ,pla.item_id                  inventory_item_id
              ,case
                  when pla.attribute1 is not null and
                       pha.attribute2 is not null then
                   'Y'
                  else
                   'N'
               end cod_barras_flag
              ,nvl((select codigo_status
                     from dtt_ri_status_recebimento drsr
                    where drsr.organization_id =
                          plla.ship_to_organization_id
                      and drsr.inventory_item_id = pla.item_id
                       and drsr.invoice_lote = rt_deliver.vendor_lot_num), 'L') status_flag
             , rt_deliver.transaction_date
          from po.rcv_transactions      rt_deliver
             , rcv_shipment_lines       rsl
             , mtl_system_items_b    msib
             , po_line_locations_all plla
             , po_lines_all          pla
             , po_headers_all        pha
         where 1 = 1
           and pha.po_header_id = pla.po_header_id
           and rsl.shipment_line_id = rt_deliver.shipment_line_id
           and nvl(pha.cancel_flag, 'N') = 'N'
           and pla.po_line_id = plla.po_line_id
           and msib.inventory_item_id = pla.item_id
           and msib.organization_id = plla.ship_to_organization_id
           and pla.po_line_id = rt_deliver.po_line_id
           and nvl(rt_deliver.transaction_type, 'DELIVER') = 'DELIVER'
           and pha.segment1 = '15320'
     ) rec
     , mtl_material_transactions mmt
 where mmt.inventory_item_id(+) = rec.inventory_item_id
   and mmt.organization_id  (+) = rec.organization_id
   and mmt.transaction_date (+) > rec.transaction_date -1
   and mmt.source_line_id   (+) = rec.transaction_id
   and mmt.source_code      (+) = 'TRF KWK'
   and mmt.transaction_quantity(+) > 0
   ;
   
   
--SELECT CASO - ORDEM DE VENDA PARADA NA INTERFACE (Tipo Fiscal Linha)

SELECT
    b.ordered_item,
    c.description,
    b.*,
    c.global_attribute8 as Aplicativo,
    c.global_attribute2 as CONDICAO_TRANSACAO ,
    c.global_attribute3 as ORIGEM_ITEM,
    c.global_attribute4 as TIPO_FISCAL_ITEM,
    c.global_attribute5 as SIT_TRIBUT_FEDERAL,
    c.global_attribute6 as SIT_TRIBUT_ESTADUAL
FROM
    apps.oe_order_headers_all    a,
    apps.oe_order_lines_all      b,
    apps.mtl_system_items_b      c
WHERE
        a.order_number = '27685' -- Nº da Ordem de Venda
    AND b.header_id = a.header_id
    AND b.ordered_item = c.segment1
    AND c.organization_id = '149' -- colocar o OR_ID correto (151= SP/ 149=KMB Manaus/157 = KCA
    AND b.global_attribute8 IS NULL;
    
    
-- select para pegar processos completos por regime aduaneiro
SELECT DISTINCT
    a.num_ordem,
    b.num_invoice,
    b.cod_processo,
    a.id_regime,
    c.descricao,
    d.num_nf||'-'||d.serie AS NUM_NF
FROM
    itens_fatura_importacao  a,
    faturas_importacao       b,
    regime_aduaneiro         c,
    trbskmb.nota_fiscal     d
WHERE
        a.id_invoice = b.id_invoice
    AND a.id_regime = c.id_regime
--and     b.num_invoice = 'MKD-TST007'
    AND b.cod_processo = d.processo_di 
    AND d.nfe_sefaz_status = 'Aprovada - SEFAZ.'
    AND c.descricao like 'ZFM-Indust. KMB' -- Usar Tabela REGIME_ADUANEIO
;

------------------------------PROCESSO DE TRANSFERÊNCIA DE SUBINVENTÁRIO DE DESTINO: IDENTIFICAR DUPLICATAS E REMOVE-LAS------------------------------------------------
--PASSO 01
SELECT PHA.PO_HEADER_ID
                 ,PLA.PO_LINE_ID
                 ,PHA.SEGMENT1     NUMERO_PO
                 ,PHA.ATTRIBUTE1   INVOICE_NUMBER
                 ,pha.attribute2    modelo_moto --rgenaro 18/08/2020
                 ,PLA.ATTRIBUTE1 NUMERO_CONTROLE
                 ,PLA.ATTRIBUTE2
                 ,PLA.ITEM_ID
                 ,PHA.CREATION_DATE
            /*INTO LN_PO_HEADER_ID,
                 LN_PO_LINE_ID,
                 LV_NUMERO_OC,
                 LV_INVOICE,
                 l_modelo_moto, --rgenaro 18/08/2020
                 LV_NUMERO_CONTROLE,
                 LV_NUMERO_LOTE,
                 LN_INVENTORY_ITEM_ID*/
            FROM apps.PO_LINES_ALL   PLA
                ,apps.PO_HEADERS_ALL PHA
                ,apps.PO_LINE_LOCATIONS_ALL PLLA
            WHERE 1 = 1
             AND PLA.PO_HEADER_ID = PHA.PO_HEADER_ID
             AND PLLA.PO_LINE_ID = PLA.PO_LINE_ID
             AND PHA.AUTHORIZATION_STATUS = 'APPROVED'
             AND PLLA.SHIP_TO_ORGANIZATION_ID = 149 --:CONTROLE.ORGANIZATION_ID
             --> USANDO O QUE FOI DIGITADO EM INVOICE, NO CAMPO DE NUMERO DE CONTROLE
             AND PLA.ATTRIBUTE1 = 'KMB-H2KZ0100258';--P_NUMERO_CONTROLE;

--PASSO 02       -- O Que não tiver recebimento é a duplicata        
SELECT DISTINCT
   e.po_header_id,
   e.segment1 as NUMERO_PO, 
   a. *
FROM
    apps.cll_f189_entry_operations    a,
    cll_f189_invoices                 b,
    cll_f189_invoice_lines            c,
    po_line_locations_all             d,
    po_headers_all                    e
WHERE
        1 = 1
    AND a.organization_id = 149
    AND a.operation_id = b.operation_id
    AND b.invoice_id = c.invoice_id
    AND c.line_location_id = d.line_location_id
    AND d.po_header_id = e.po_header_id
    AND e.segment1 in ('14689','14742'); -- NÚMERO DA PO;
    
                                                                    
--PASSO 03                                                                
update apps.po_lines_all
set ATTRIBUTE1 = null
where 1=1
and po_header_id in (992927);
-----------------------------------------------------------------------------FIM------------------------------------------------------------------------------------
    
--calculo total NF
SELECT
b.*
   --sum(b.extended_amount) as TOTAL
FROM
    ra_customer_trx_all        a,
    ra_customer_trx_lines_all  b
WHERE
    trx_number = '15303'
AND a.CUSTOMER_TRX_ID ='1105475'
AND a.customer_trx_id = b.customer_trx_id
--AND b.line_type = 'TAX'

-- RELATÓRIO FORNECEDORES DAS ÚLTIMAS COMPRAS
SELECT distinct 
                c.vendor_name   FORNECEDOR,
                c.segment1 CODIGO,
                c.vendor_type_lookup_code TIPO,
                f.GLOBAL_ATTRIBUTE10||f.GLOBAL_ATTRIBUTE11||f.GLOBAL_ATTRIBUTE12 as CNPJ,
                f.global_attribute13 INSCRIÇÃO_ESTADUAL,
                f.global_attribute14 INSCRIÇÃO_MUNICIPAL,
                CASE WHEN f.org_id = '145' THEN 'KMB_OU' WHEN f.org_id = '155' THEN 'KCA_OU' END EMPRESA, 
                to_char(b.creation_date,'DD-MON-RRRR') DATA_ULTIMA_COMPRA,
                d.segment1      COD_ITEM,
                d.description,
                a.unit_price,
                a.quantity,
                d.organization_id,
                e.user_name COMPRADOR,
                f.address_line1||', Nº'||f.address_line2||', '||f.address_line3||'- '||f.city||'/'||f.state||'/'||f.country||' CEP:'||f.zip as ENDEREÇO_FORNECEDOR
  FROM po_lines_all       a,
       po_headers_all     b,
       ap_suppliers       c,
       mtl_system_items_b d,
       fnd_user           e,
       ap_supplier_sites_all f
       
 WHERE a.po_header_id = b.po_header_id
   AND b.vendor_id = c.vendor_id
   AND b.created_by = e.user_id
   AND a.item_id = d.inventory_item_id
   AND c.vendor_id = f.vendor_id
   and b.creation_date =
       (select Max(x.creation_date)
          from po_headers_all x, po_lines_all y, mtl_system_items_b z
         where x.po_header_id = y.po_header_id
           and y.item_id = z.inventory_item_id
           and z.segment1 = d.segment1
           and z.organization_id in('149','157'))
    and d.organization_id in ('149','157')
 order by 8 desc;
 
-- SELECT DATA DE PAGAMENTO POs de REQUISIÇÕES
 SELECT DISTINCT
pha.segment1 AS NUM_PO,
pha.note_to_vendor DESCRIÇÃO,
cfi.invoice_num NUM_NFF,
cfi.terms_date DATA_PAGAMENTO
FROM 
    PO_LINE_LOCATIONS_ALL PLLA,
    CLL_F189_INVOICE_LINES CFIL,
    CLL_F189_INVOICES      CFI,
    PO_HEADERS_ALL         PHA
WHERE
1=1
AND PHA.PO_HEADER_ID = PLLA.PO_HEADER_ID
AND CFI.INVOICE_ID = CFIL.INVOICE_ID
AND cfil.line_location_id = plla.line_location_id
AND pha.segment1 = '8899' -- NÚMERO PO
order by cfi.terms_date asc;

-- SELECT RMA + NF PAI
WITH rma AS (
    SELECT
        rcta.customer_trx_id                customer_trx_id_rma,
        rcta.trx_number                     num_nff_retorno,
        rbsa.name                           tipo_nff_rma,
        COUNT(rctla.customer_trx_id)        quantidade_linhas_rma,
        SUM(rctla.extended_amount)          valor_rma,
        rcta.interface_header_attribute1    num_order_rma,
        rcta.interface_header_attribute2    tipo_order_rma,
        rcta.creation_date                  creation_date_rma,
        rcta.previous_customer_trx_id       customer_trx_nff
    FROM
        ra_customer_trx_all        rcta,
        ra_batch_sources_all       rbsa,
        ra_customer_trx_lines_all  rctla
    WHERE
            1 = 1
        AND rcta.customer_trx_id = rctla.customer_trx_id
        AND rcta.batch_source_id = rbsa.batch_source_id
        AND rcta.org_id = rctla.org_id
        AND rcta.batch_source_id = '8002'
        AND rctla.line_type = 'LINE'
    GROUP BY
        rcta.trx_number,
        rbsa.name,
        rcta.interface_header_attribute1,
        rcta.interface_header_attribute2,
        rcta.creation_date,
        rcta.customer_trx_id,
        rcta.previous_customer_trx_id
    ORDER BY
        rcta.creation_date DESC
)
SELECT
    rcta.customer_trx_id                customer_trx_id_nff,
    rcta.trx_number                     num_nff,
    rbsa.name                           tipo_nff,
    COUNT(rctla.customer_trx_id)        quantidade_linhas_nff,
    SUM(rctla.extended_amount),
    rcta.interface_header_attribute1    num_order_nff,
    rcta.interface_header_attribute2    tipo_order_nff,
    rcta.creation_date                  creation_date_nf,
    rma.customer_trx_id_rma,
    rma.num_nff_retorno,
    rma.tipo_nff_rma,
    rma.quantidade_linhas_rma,
    rma.valor_rma,
    rma.num_order_rma,
    rma.tipo_order_rma,
    rma.creation_date_rma,
    rma.customer_trx_nff
FROM
    ra_customer_trx_all        rcta,
    ra_batch_sources_all       rbsa,
    ra_customer_trx_lines_all  rctla,
    rma
WHERE
        1 = 1
    AND rcta.customer_trx_id = rctla.customer_trx_id
    AND rcta.batch_source_id = rbsa.batch_source_id
    AND rcta.org_id = rctla.org_id
    AND rctla.line_type = 'LINE'
    AND rma.customer_trx_nff = rcta.customer_trx_id
GROUP BY
    rcta.trx_number,
    rbsa.name,
    rcta.interface_header_attribute1,
    rcta.interface_header_attribute2,
    rcta.creation_date,
    rcta.customer_trx_id,
    rma.customer_trx_id_rma,
    rma.num_nff_retorno,
    rma.tipo_nff_rma,
    rma.quantidade_linhas_rma,
    rma.valor_rma,
    rma.num_order_rma,
    rma.tipo_order_rma,
    rma.creation_date_rma,
    rma.customer_trx_nff
ORDER BY
    rcta.creation_date DESC 
    
    
--CONSULTA PROCESSOS
select pi.data_criacao,
       pi.cod_processo,
       pi.data_conhecimento,
       fi.num_invoice,
       pi.tipo_conhecimento as modal,
       fi.PO,
       di.num_di,
       di.data_registro_di,
       nf.num_nf,
       nf.dt_emissao,
       nf.nfe_sefaz_status
  from TRISKMB.PROCESSOS_IMPORTACAO pi,
       trbskmb.nota_fiscal nf,
       trbskmb.di di,
       (select distinct a.cod_processo, a.num_invoice, b.num_ordem as PO
          from TRISKMB.faturas_importacao      a,
               TRISKMB.itens_fatura_importacao b
         where a.id_invoice = b.id_invoice
           ) fi
 where pi.cod_processo = nf.processo_di(+)
   and pi.cod_processo = di.processo_di(+)
   and pi.cod_processo = fi.cod_processo
  --    and pi.cod_processo = 'KMB-1238/21'
   and pi.id_area in ('KMB_AD_AM_001', 'KCA_AD_AM_006')
  and to_char(pi.data_criacao, 'yyyy/mm/dd')>  '2021/12/06' --transição e pós golive
 order by pi.data_criacao desc, pi.cod_processo 

-- SELECT PROCURA CONTA CONTA CONTÁBIL DA DISTRIBUIÇÃO DA PO
SELECT DISTINCT
    a.po_header_id,
    c.segment1 NUM_PO,
    a.accrual_account_id,
    b.segment1||'.'||b.segment2||'.'||b.segment3||'.'||b.segment4||'.'||b.segment5||'.'||b.segment6||'.'||b.segment7||'.'||b.segment8 as ACCRUAL_ACCOUNT
FROM
    po_distributions_all  a,
    gl_code_combinations  b,
    po_headers_all c
WHERE
    a.accrual_account_id = b.CODE_COMBINATION_ID
and a.po_header_id = c.po_header_id
--and   a.po_header_id in ('996867') -- Colocar Header_id das POs
--and   c.segment1 in ('') -- Colocar números da PO 
and    c.attribute1 in ('4KD-211008') -- Pesquisar pelos número da Invoice;


--SELECT QUE FAZ CONSULTA DE NOTIFICAÇÕES DE PO PARA OSGT
select *
  from cll.cll_f255_notifications n
 where n.event_name = 'oracle.apps.cll.po_headers'
   and n.return_code = 0
   and n.export_status = 1
   and n.creation_date > '17-JAN-22';
   
-- DESBLOQUEAR USUÁRIO DE BANCO
alter user xxavl identified by xxavlprd account unlock;

-------------------------------------------------------script para forçar envio de fatura para o AP---------------------------------------------------------
-- 1º consulte antes
select fi.data_envio_oracle_ap, id_invoice, fi.status_cambio
  from triskmb.faturas_importacao fi
 where fi.id_invoice = 4993
   and fi.data_envio_oracle_ap is not null;

-- 2º ALTERA O STATUS PARA 1 para criar a notificação
update faturas_importacao fi
   set fi.status_cambio = 1
 where fi.id_invoice = 4993
   and fi.data_envio_oracle_ap is not null;
-- 3º verificar a tabela oif_export se gerou notificação id_evento 5520
select a.*, a.rowid
from oif_export a
where 1 = 1
and id_evento = 5520

-- 4º retorna o status para 0
update faturas_importacao fi
   set fi.status_cambio = 0
 where fi.id_invoice = 4993
   and fi.data_envio_oracle_ap is not null;
-------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------PROCESSO DE VALIDAÇÃO DE RETENÇÃO: QUANTIDADE FATURADA NÃO BATE COM A QUANTIDADE SOLICITADA---------------------------------------

-- 1º SELECT QUE TRAZ A LINE_LOCATION e PO_HEADER_ID VINCULADA  COM A OPERATION_ID DO RI

/*                                                    ANOTAÇÕES
Com base nessa informação conseguimos usar a LINE_LOCATION_ID para verificar se a PO está vinculada a outro OPERATION_ID*/
SELECT * FROM APPS.PO_LINE_LOCATIONS_ALL
WHERE 1 = 1
AND LINE_LOCATION_ID IN (SELECT LINE_LOCATION_ID FROM APPS.CLL_F189_INVOICE_LINES WHERE INVOICE_ID IN (SELECT INVOICE_ID FROM APPS.CLL_F189_INVOICES
WHERE ORGANIZATION_ID IN (SELECT ORGANIZATION_ID FROM APPS.mtl_parameters where ORGANIZATION_CODE = 'B01')
AND OPERATION_ID = '82452')); 

-- 2º SELECT PESQUISA NOTAS OSGT QUE VÃO PARA O RI + PO
SELECT
    num_nf, processo_di, a.pedido, a.senf, id_notafiscal, status_nf, nfe_sefaz_status,
    dt_emissao, dt_entrada, dt_atualizacao, dt_cancelamento, nfe_sefaz_chave_acesso
FROM
    trbskmb.nota_fiscal a
WHERE
    num_nf IN ( '539', '543', '549', '548', '541',
                '551', '546', '538', '545', '544',
                '552', '542', '536', '537', '550',
                '547',
                '540' )
    AND serie = 14;

-- 3º SELECT QUE PESQUISA SE A LINE_LOCATION ESTÁ VINCULADA COM MAIS DE UM OPERATION_ID DO RI
SELECT DISTINCT CFI.OPERATION_ID, CFI.INVOICE_NUM, PHA.SEGMENT1, CFI.ATTRIBUTE3,CFH.HOLD_CODE
FROM PO_HEADERS_ALL PHA, PO_LINES_ALL PLA, PO_LINE_LOCATIONS_ALL PLLA, CLL_F189_INVOICE_LINES CFIL, MTL_PARAMETERS MP ,CLL_F189_INVOICES CFI, CLL_F189_HOLDS CFH
WHERE   PHA.PO_HEADER_ID = PLA.PO_HEADER_ID
AND     PLA.PO_LINE_ID = PLLA.PO_LINE_ID
AND PLLA.LINE_LOCATION_ID  = CFIL.LINE_LOCATION_ID 
AND CFIL.ORGANIZATION_ID = MP.ORGANIZATION_ID
AND MP.ORGANIZATION_CODE = 'B01'
AND CFIL.INVOICE_ID = CFI.INVOICE_ID
AND CFI.OPERATION_ID = CFH.OPERATION_ID
AND PHA.SEGMENT1 IN ('16209','16216','16214','16206');

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- select erro na interface RI
SELECT DISTINCT
    A.INVOICE_NUM,
    A.SERIES,
    C.ERROR_CODE,
    C.ERROR_MESSAGE
FROM
    CLL.CLL_F189_INVOICES_INTERFACE     A,
    CLL.CLL_F189_INVOICE_LINES_IFACE    B,
    CLL.CLL_F189_INTERFACE_ERRORS       C
WHERE
        A.INTERFACE_INVOICE_ID = B.INTERFACE_INVOICE_ID
    AND B.INTERFACE_INVOICE_ID = C.INTERFACE_INVOICE_ID
    AND INVOICE_NUM IN ('594',
'595',
'596',
'597',
'598',
'599',
'600',
'601',
'602',
'603')
    AND A.SOURCE = 'SOFTWAY';
    
-- SELECT COMPARATIVO FABRICANTE ITENS ORDEM OSGT x ITENS EBS
SELECT
    D.manufacturer_id||'M'   AS COD_FABRICANTE_EBS
    
FROM
    TRISKMB.ITENS_ORDEM           A,
    TRISKMB.SFW_PARCEIRO          B,
    TRISKMB.SFW_PRODUTO           C,
    APPS.MTL_MFG_PART_NUMBERS@R12DBLINK.A423710.ORACLECLOUD.INTERNAL D,
    APPS.MTL_SYSTEM_ITEMS_B@R12DBLINK.A423710.ORACLECLOUD.INTERNAL E,
    APPS.MTL_MANUFACTURERS@R12DBLINK.A423710.ORACLECLOUD.INTERNAL F
WHERE
    A.NUM_ORDEM IN ('18490.145',
'18492.145',
'18489.145',
'18491.145')
    AND A.COD_FABRICANTE = B.COD_PARCEIRO
    AND A.COD_PECA = C.ID_PRODUTO
    AND C.PART_NUMBER = E.SEGMENT1
    AND D.mfg_part_num = E.segment1
    AND D.manufacturer_id = F.manufacturer_id
    --AND E.ORGANIZATION_ID = '147'
ORDER BY
    A.NUM_ORDEM;
    
    
-- SELECT QUANTIDADE DE VEZES A PO FOI NOTIFICADA NA TABELA NOTIF. EBS
select 
	SEGMENT1,
	ceil(CONTAGEM_TOTAL / CONTAGEM2) as vezes_notificada
from (
SELECT 
    po.segment1,
   count(po.po_header_id) CONTAGEM_TOTAL,
   (select count(pl.po_header_id) from po_lines_all pl where po.po_header_id = pl.po_header_id) contagem2
     
FROM
    apps.cll_f255_notifications    nt,
    apps.po_headers_all            po
    
WHERE
        nt.isv_name = 'SFTCMX'
    AND nt.event_name = 'oracle.apps.cll.po_headers'
    AND nt.parameter_value1 = po.po_header_id
---AND PO.SEGMENT1 in ('11020') -- NUMERO DA PO
    AND export_status = 1--  STATUS 1 = NOTIFICADA PARA INTERFACE ; 4 = ERRO
    group by po.segment1,
        po.po_header_id
ORDER BY
    CONTAGEM_TOTAL desc
	);
 
 
-- select consulta RIs INVOICE PENDING x NF REMESSA
SELECT DISTINCT
    cftd.devolution_operation_id OPERATION_ID_RET,
    cfi.invoice_num,
    cftd.devolution_quantity QUANTITY_RET,
    cftrc.operation_id OPERATION_ID_REM,
    cftrc.invoice_number NF_REMESSAA,
    cftrc.remaining_balance QUANTITY_REM
FROM
    cll_f513_tpa_devolutions_ctrl  cftd,
    cll_f189_invoices              cfi,
    cll_f513_tpa_receipts_control  cftrc
WHERE
        cftd.org_id = '155'
    AND cftd.devolution_invoice_id = cfi.invoice_id
    AND cftd.tpa_receipts_control_id = cftrc.tpa_receipts_control_id ;
    
    
-- select valida se a informação suframa da fatura bate com o suframa DEFAUL
SELECT sp.part_number,
       sp.ncm,
       sp.seq_suframa,
       sp.cod_prod_suframa,
       sp.tipo_prod_suframa,
       sp.modelo_prod_suframa,
       sd.detalhe,
       sc.*
  FROM triskmb.itens_ordem io,
       sfw_produto sp,
       sfw_detalhe_ncm_suframa sd,
       (select * from trcstkmb.SFW_PRODUTO_SUFRAMAS_CST a where a.s_default = 'S') sc
 WHERE io.cod_peca = sp.id_produto
     and io.cod_peca = sc.n_id_produto(+)
      
   AND sp.id_detalhe_suframa = sd.id_detalhe_suframa
   AND io.num_ordem = '18303.145';
   
   
   -- select traz entidade relacionado com organização
   
   SELECT
    hrl.inventory_organization_id,
    etb.legal_entity_id,
    reg.location_id,
    hrl.location_code,
    hrl.inventory_organization_id,
    reg.registration_id,
    reg.registration_number,
    jur.legislative_cat_code legislative_category,
    hrl.ADDRESS_LINE_1||','||hrl.ADDRESS_LINE_2||','||hrl.ADDRESS_LINE_3||','||hrl.TOWN_OR_CITY||','||hrl.COUNTRY||','||hrl.POSTAL_CODE||','||hrl.REGION_1||','||hrl.REGION_2 as endereço

FROM
    apps.xle_etb_profiles        etb,
    apps.xle_registrations       reg,
    apps.hr_locations_all        hrl,
    apps.xle_jurisdictions_vl    jur
WHERE
        etb.establishment_id = reg.source_id
    AND reg.source_table = 'XLE_ETB_PROFILES'
    AND hrl.location_id = reg.location_id
    AND jur.jurisdiction_id = reg.jurisdiction_id
    AND jur.legislative_cat_code = 'FEDERAL_TAX'
    AND sysdate BETWEEN nvl(etb.effective_from, sysdate) AND nvl(etb.effective_to, sysdate)
    AND etb.legal_entity_id = (
        SELECT
            legal_entity
        FROM
            apps.org_organization_definitions
        WHERE
                organization_id = 165 -- ORGANIZATION ID 165 é a ORGANIZAÇÃO CODE AT1 DE NOME KCA_CT_AM_006 ELA FICA ABAIXO DA ORG ID 155
            AND ROWNUM = 1
    )
    AND hrl.inventory_organization_id = 165;

SELECT
    *
FROM
        hr_locations_all; --  
        
        
-- Comando para visualizar impressora na máquina de aplicação
sudo watch -n1 sudo lpstat -u applmgr

--- excluir linhas da interface -- LEMBRAR DE COLOCAR O ID DO TIPO DE NOTA E AS OPERAÇÕES
DECLARE
  
  CURSOR C_RI IS
    SELECT cii.interface_invoice_id invoice_id
      FROM apps.cll_f189_invoices_interface cii
     WHERE invoice_type_id = 55966  -- Colocar o TIPO DE NOTA
       AND interface_operation_id BETWEEN 3018 AND 3020; -- Colocar o Operation
       
  R_RI C_RI%ROWTYPE;
  
  
BEGIN
  
  FOR R_RI IN C_RI LOOP
        
    DELETE FROM cll_f513_tpa_receipts_control 
     WHERE /*invoice_line_id = r_ri.invoice_line_id
       AND */invoice_id      = r_ri.invoice_id;
       
    DELETE FROM cll_f513_tpa_devolutions_ctrl
     WHERE /*invoice_line_id = r_ri.invoice_line_id
       AND*/ devolution_invoice_id = r_ri.invoice_id;
       
    DELETE FROM cll_f513_tpa_dev_iface
     WHERE interface_invoice_id      = r_ri.invoice_id;
       --AND interface_invoice_line_id = r_ri.invoice_line_id; 
           
    DELETE FROM cll_f189_invoice_lines_iface
     WHERE interface_invoice_id      = r_ri.invoice_id;
      -- AND interface_invoice_line_id = r_ri.invoice_line_id;
           
    DELETE FROM cll_f189_invoices_interface
     WHERE interface_invoice_id = r_ri.invoice_id;    
  
  END LOOP;
  
  COMMIT;  
  
END;


-- select para pegar JSON de resposta e JSON de envio de uma nota
select
	ava.JSON_REQUEST as json_envio,
	ava.JSON_RESPONSE as json_resposta,
--	ava.status,
	ava.*
from xxavl.xxavl_registro_solicitacoes ava
inner join
	apps.ra_customer_trx_all ar on
		ar.customer_trx_id = json_value(ava.chave_tabela, '$.customer_trx_id')
where
	ar.trx_number = '4324';
    
-- SELECT PARA VALIDAR QUAL O GRUPO DE CUSTO PAC ESTÁ VINCULADO A ORGANIZAÇÃO
 
select * from APPS.CST_COST_GROUP_ASSIGNMENTS
Where cost_group_id = ( select COST_GROUP_ID from  apps.cst_cost_groups 
                         where cost_group  = 'GC_CBU' )
  and organization_id = (   select organization_id from APPS.ORG_ORGANIZATION_DEFINITIONS2
                            where organization_code = 'BT1' );


--- RELATÓRIO WIP OP X REC
--- RELATÓRIO WIP OP X REC
SELECT DISTINCT
    e.wip_entity_id,
    e.wip_entity_name NUM_OP_KMB,
    e.model_item MODELO,
    d.segment1 ITEM,
    e.dt_producao,
    c.segment1 NUM_REC_KMB,
    b.quantity,
    b.unit_price,
    f.segment1 NUM_OC_KMB,
    g.order_number NUM_OV_KCA,
   j.wip_entity_name NUM_OP_KCA
FROM
    dtt_wip_op_assoc_op_detail  a,
    po_requisition_lines_all    b,
    po_requisition_headers_all c,
    mtl_system_items_b d,
    dtt_wip_programacao_op_v e,
    po_headers_all f,
    oe_order_headers_all g,
    oe_order_lines_all h,
    wip_reservations_v i,
    wip_entities j
WHERE
a.requisition_line_id = b.requisition_line_id
and b.requisition_header_id = c.requisition_header_id
and b.item_id = d.inventory_item_id
and e.wip_entity_name in ('340681')
--and   a.job_master_id in ('340650')
and d.organization_id = '149'
and a.job_master_id = e.wip_entity_id
and f.interface_source_code = c.segment1
and g.orig_sys_document_ref = c.segment1
and h.header_id = g.header_id 
and h.line_id = i.demand_source_line_id
and i.wip_entity_id = j.wip_entity_id
and i.organization_id = 157
and i.inventory_item_id = d.inventory_item_id

;
-- SELECT DE VALIDAÇÃO DE TRANSAÇÃO RETORNO TPMG X INV
select 
    a.devolution_operation_id operação,
    a.devolution_date data_devolução,
    a.subinventory subinventário,
    a.devolution_invoice_line_id,
    devolution_transaction_id id_tpmg_transação,
    b.transaction_id ID_TRANSAÇÃO_INV,
    b.creation_date CRIAÇÃO_TRANSACAO_TABELA,
    b.transaction_date DATA_TRANSAÇÃO,
    c.segment1 ITEM_TRANSFERIDO
    from
    cll_f513_tpa_devolutions_ctrl  a
    LEFT JOIN mtl_material_transactions b ON  a.devolution_transaction_id = b.transaction_set_id
    JOIN mtl_system_items_b c ON a.inventory_item_id = c.inventory_item_id
WHERE
    a.devolution_operation_id = 7 -- COLOCAR NÚMERO DO RI da Devolução
    and c.organization_id = '164';
    
    
    --- -- SELECT DE VALIDAÇÃO DE TRANSAÇÃO RETORNO TPMG X INV
SELECT DISTINCT
    a.invoice_number,
    c.segment1 ITEM_TRANSFERIDO,
    b.transaction_id ID_TRANSAÇÃO_INV,
    b.creation_date CRIAÇÃO_TRANSACAO_TABELA_INV,
    b.transaction_date DATA_TRANSAÇÃO_INV,
    B.subinventory_code SUBINVENTÁRIO_TRANSFERIDOR,
    B.TRANSACTION_QUANTITY
    
FROM
    cll_f513_tpa_returns_control  a
    LEFT JOIN mtl_material_transactions  b ON a.returned_transaction_id = b.transaction_set_id
    JOIN mtl_system_items_b c ON a.inventory_item_id = c.inventory_item_id
WHERE
    a.invoice_number = 70032
    and a.organization_id = '149';

--- -- SELECT DE VALIDAÇÃO DE TRANSAÇÃO REMESSA TPMG X INV
SELECT DISTINCT
    a.trx_number,
    c.segment1 ITEM_TRANSFERIDO,
    b.transaction_id ID_TRANSAÇÃO_INV,
    b.creation_date CRIAÇÃO_TRANSACAO_TABELA_INV,
    b.transaction_date DATA_TRANSAÇÃO_INV,
    B.subinventory_code SUBINVENTÁRIO_TRANSFERIDOR,
    B.TRANSACTION_QUANTITY
    
FROM
    CLL_F513_TPA_REMIT_CONTROL  a
    LEFT JOIN mtl_material_transactions  b ON a.transfer_transaction_id = b.transaction_set_id
    JOIN mtl_system_items_b c ON a.inventory_item_id = c.inventory_item_id
WHERE
    a.trx_number = 70009
    and a.organization_id = '149';
    
    select * from mtl_material_transactions;
    
-- select status da trigger
select trigger_name, status from all_triggers where trigger_name = 'DTT_RI_TPA_DEVOLV_BI_TRG';

-- UPDATE STATUS EBS DE CASOS QUE A NF CANCELADA NA SEFAZ PORÉM O STATUS É DE REJEIÇÃO NO EBS
1-
UPDATE jl_br_eilog
SET
    electronic_inv_status = 4,
    message_txt = 'Cancelada',
    last_update_date = sysdate
WHERE
    customer_trx_id = 1143260;


2 -
update JL_BR_CUSTOMER_TRX_EXTS set
    electronic_inv_web_address = 'C - CANCELAMENTO',
electronic_inv_status = 4,
electronic_inv_access_key = '13220414386045000150550010000615671566982511',
electronic_inv_protocol = '113222041719008',
last_update_date = sysdate
WHERE
    customer_trx_id = 1143260;

select * from JL_BR_CUSTOMER_TRX_EXTS     where customer_trx_id = 1143260;

--select transação de retorno devolução KMB
select 
    a.  operation_id operação,
    a.returned_date data_devolução,
    a.new_subinventory subinventário,
    a.returned_quantity,
    --a.devolution_invoice_line_id,
    a.returned_transaction_id id_tpmg_transação,
    b.transaction_id ID_TRANSAÇÃO_INV,
    b.creation_date CRIAÇÃO_TRANSACAO_TABELA,
    b.transaction_date DATA_TRANSAÇÃO,
    b.PERIODIC_PRIMARY_QUANTITY,
    b.TRANSFER_SUBINVENTORY,
    b.last_update_date,
    c.segment1 ITEM_TRANSFERIDO,
    d.transaction_type_name
    from
    CLL_F513_TPA_RETURNS_CONTROL  a
    LEFT JOIN mtl_material_transactions b ON  a.returned_transaction_id = b.transaction_set_id
    JOIN mtl_system_items_b c ON a.inventory_item_id = c.inventory_item_id
    JOIN MTL_TRANSACTION_TYPES d ON b.transaction_type_id = d.transaction_type_id
WHERE
    a.operation_id = 93947
 -- COLOCAR NÚMERO DO RI da Devolução
    and c.organization_id = '149';
    
    SELECT * FROM CLL_F513_TPA_RETURNS_CONTROL
    SELECT * FROM mtl_material_transactions;

-- objetos bloqueados
SELECT B.Owner, B.Object_Name, A.Oracle_Username, A.OS_User_Name  
FROM V$Locked_Object A, All_Objects B
WHERE A.Object_ID = B.Object_ID;

-- Formata arquivo trace dentro do Puttin usuário oracle
tkprof [NOME DO ARQUIVO] [NOME DO ARQUIVO NOVO.txt] WAITS=YES SYS=NO SORT=EXEELA,FCHELA,EXECP;


-- SELECT PARA IDENTIFICAR DIFERENÇAS NA CONTA TRANSITÓRIA DE LUCRO INTERORG
select ood.organization_code,
       ccg.cost_group,
       msi.segment1,
       msi.description,
       gcc1.concatenated_segments conta_lucro_interorg,
       gcc2.concatenated_segments conta_estoque_item,
       sum(nvl(cal.accounted_dr,0)) accounted_dr,
       sum(nvl(cal.accounted_cr,0)) accounted_cr,
       sum(nvl(cal.accounted_dr,0)) - sum(nvl(cal.accounted_cr,0)) accounted_value
from apps.cst_ae_lines cal,
     apps.cst_ae_headers cah,
     apps.mtl_material_transactions    mmt,
     apps.gl_code_combinations_kfv     gcc1,
     apps.gl_code_combinations_kfv     gcc2,
     apps.mtl_system_items_fvl         msi,
     apps.cst_cost_group_assignments   ccga,
     apps.cst_cost_groups              ccg,
     apps.mtl_item_categories_v        mic,
     apps.mtl_fiscal_cat_accounts      mfca,
     apps.org_organization_definitions ood
where 1=1
and   cal.ae_header_id            = cah.ae_header_id
and   cah.accounting_event_id     = mmt.transaction_id
and   cal.ae_line_type_code       = 34
and   mmt.organization_id         = some(149,165)
and   mmt.transaction_type_id     = 143
and   mmt.transaction_date        between to_date('01/04/2022 00:00:00', 'dd/mm/rrrr hh24:mi:ss') and to_date('30/04/2022 23:59:59', 'dd/mm/rrrr hh24:mi:ss')
and   sign(mmt.primary_quantity)  = -1
and   ood.organization_id         = mmt.organization_id
and   msi.organization_id         = mmt.organization_id
and   msi.inventory_item_id       = mmt.inventory_item_id
and   gcc1.code_combination_id    = cal.code_combination_id
and   gcc2.code_combination_id    = mfca.material_account
and   ccga.organization_id        = mmt.organization_id
and   ccg.cost_group_id           = ccga.cost_group_id
and   mic.category_set_id         = 1100000063
and   mic.organization_id         = mmt.organization_id
and   mic.inventory_item_id       = mmt.inventory_item_id
and   mfca.cost_group_id          = ccga.cost_group_id
and   mfca.category_id            = mic.category_id
group by ood.organization_code,
         ccg.cost_group,
         msi.segment1,
         msi.description,
         gcc1.concatenated_segments,
         gcc2.concatenated_segments
order by ood.organization_code desc,
         ccg.cost_group,
         msi.segment1,
         msi.description,
         gcc1.concatenated_segments,
         gcc2.concatenated_segments;
         
-- RELATÓRIO DE OP KMB ANUAL
select org,
             nr_ordem_producao,
             cd_modelo,
             cor,
             cd_nick_name,
             nr_chassi,
             ds_status_op,
             nr_motor,
             linha,
             dt_plano,
             dt_criacao,
             dt_fechamento,
             dt_liberação,
             dt_kmb10,
             dt_kmb30,
             dt_kmb50
      from (select replace(replace(mps.organization_code,chr(13)),chr(10)) org,
                   replace(replace(wes.wip_entity_name,chr(13)),chr(10)) nr_ordem_producao,
                   replace(replace(msi.attribute1,chr(13)),chr(10)) cd_modelo,
                   replace(replace(mev.element_value,chr(13)),chr(10)) cor,
                   replace(replace(dpo.nick_name,chr(13)),chr(10)) cd_nick_name,
                   replace(replace(dpo.nr_chassi,chr(13)),chr(10)) nr_chassi,
                   replace(replace( dpo.nr_motor,chr(13)),chr(10)) nr_motor,
                   wdj.line_code linha,
                   dpo.creation_date dt_criacao,
                   wdj.date_closed dt_fechamento,
                   wdj.date_released dt_liberação,
                   flv.meaning ds_status_op,
                   wdj.scheduled_start_date dt_plano,
                   (select date_last_moved
                    from apps.wip_operations_v
                    where 1 = 1
                    and   wip_entity_id     = wdj.wip_entity_id
                    and   operation_seq_num = '10') dt_kmb10,
                   (select date_last_moved
                    from apps.wip_operations_v
                    where 1 = 1
                    and   wip_entity_id     = wdj.wip_entity_id
                    and   operation_seq_num = '30') dt_kmb30,
                   (select date_last_moved
                    from apps.wip_operations_v
                    where 1 = 1
                    and   wip_entity_id     = wdj.wip_entity_id
                    and   operation_seq_num = '50') dt_kmb50
            from fnd_lookup_values flv,
                 wip_discrete_jobs_v wdj,
                 dtt_wip_programacao_op dpo,
                 apps.wip_entities wes,
                 mtl_descr_element_values_v mev,
                 mtl_system_items_b msi,
                 mtl_parameters mps
            where 1=1
            and   dpo.wip_entity_id              = wes.wip_entity_id
            and   flv.lookup_type                = 'WIP_JOB_STATUS'
            --
            --and   wdj.scheduled_start_date between to_date(nvl(:p_scheduled_start_date, to_char(wdj.scheduled_start_date, 'RRRR/MM/DD HH24:MI:SS')),'RRRR/MM/DD HH24:MI:SS') and
            --                                       to_date(nvl(:p_scheduled_end_date, to_char(wdj.scheduled_start_date, 'RRRR/MM/DD HH24:MI:SS')),'RRRR/MM/DD HH24:MI:SS')+.99999
            --
            and   wdj.scheduled_start_date  between '01/12/2020' and '31/05/2022'

            --
            and   flv.language                   = userenv('LANG')
            and   flv.lookup_code                = wdj.status_type
            and   mev.element_name               = 'COR'
            and   mev.item_catalog_group_id      = 2
            and   mev.inventory_item_id          = msi.inventory_item_id
            and   wdj.organization_id            = wes.organization_id
            and   wdj.wip_entity_id              = wes.wip_entity_id
            and   wes.primary_item_id            = msi.inventory_item_id
            and   wes.organization_id            = msi.organization_id
            and   msi.organization_id            = mps.organization_id
            and   mps.organization_id            = 149)
            order by dt_plano
            
-- SELECT PARA VERIFICAR OS CONCURRENTS 
select fu.user_name,
       conc.request_id,
       conc.parent_request_id,
       fcr.oracle_session_id,
       decode(conc.phase_code, 'C', 'Completed',
                               'I', 'Inactive',
                               'P', 'Pending',
                               'R', 'Running') phase_code,
       decode(conc.status_code,'D', 'Cancelled',
                               'U', 'Disabled',
                               'E', 'Error',
                               'M', 'No Manager',
                               'R', 'Normal',
                               'I', 'Normal',
                               'C', 'Normal',
                               'H', 'On Hold',
                               'W', 'Paused',
                               'B', 'Resuming',
                               'P', 'Scheduled',
                               'Q', 'Standby',
                               'S', 'Suspended',
                               'X', 'Terminated',
                               'T', 'Terminating',
                               'A', 'Waiting',
                               'Z', 'Waiting',
                               'G', 'Warning') status_code,
       conc.requested_start_date,
       conc.actual_start_date,
       conc.actual_completion_date,
       conc.program_short_name,
       conc.user_concurrent_program_name,
       conc.argument_text,
       fcr.resubmit_interval,
       fcr.resubmit_interval_unit_code
from apps.fnd_conc_req_summary_v conc,
     apps.fnd_concurrent_requests fcr,
     apps.fnd_user fu
where 1=1
--and   fu.user_name = 'ASLISBOA'
--and   conc.argument_text like '%63000%' --'%56002%'
--and   conc.request_id = 320555279 --some(17094828, 17090628)
--and   conc.user_concurrent_program_name like '%Terceiros%'
and   conc.program_short_name like 'CLL_F513%' --some('WSCMTM','WICTMS','INCTCM','CMCTCM','CMCACW')
--and   conc.phase_code != 'C'
--and   conc.status_code = 'E'
and   fu.user_id = conc.requested_by
and   fcr.request_id = conc.request_id
order by conc.actual_completion_date desc;


-- STATUS OPS.
SELECT
    a.wip_entity_id,
    c.wip_entity_name,
    b.meaning
FROM
    wip_discrete_jobs     a,
    fnd_lookup_values_vl  b,
    wip_entities          c
WHERE
    a.wip_entity_id IN ( '382879', '382880', '382881', '382882', '382883',
                       '382884', '382885', '382886', '382887', '382888',
                       '382889',
                       '382890',
                       '382891',
                       '382892',
                       '382893',
                       '382894',
                       '382895' )
    AND to_char(a.status_type) = b.lookup_code
    AND b.lookup_type = 'WIP_JOB_STATUS'
    AND a.wip_entity_id = c.wip_entity_id;

-- select erro interface om
SELECT DISTINCT
    orig_sys_document_ref,
    b.message_text
FROM
    oe_headers_iface_all A,
    oe_processing_msgs_vl B
WHERE
A.orig_sys_document_ref = b.original_sys_document_ref
AND orig_sys_document_ref IN ( '63477', '63490', '63483', '63486', '63456',
                               '63459', '63471', '63493', '63495', '63496',
                               '63450','63469','63484','63467','63468','63485',
                               '63472','63475','63466','63479','63481','63452',
                               '63464','63465','63470' );
                               
UPDATE CLL_F513_TPA_DEVOLUTIONS_CTRL
SET subinventory = 'TERC_KMB'
WHERE
TPA_DEVOLUTIONS_CONTROL_ID = '27116';


--Consulta PO de fornecedor internacional com status de recebimento aberta
SELECT DISTINCT 
                    a.segment1                 AS no_po,
                    a.attribute1               AS no_invoice,
                    a.attribute3               AS processo,
                    a.cancel_flag,
                    a.interface_source_code    AS source,
                    a.creation_date,
                    d.user_name                AS usuario_criacao,
                    b.fornecedor,
                    b.uf,
                    b.nome_fantasia            AS sigla_forn,
                    nu_forn_ebs,
                    h.segment1||'.'||h.segment2||'.'||h.segment3||'.'||h.segment4||'.'||h.segment5||'.'||h.segment6||'.'||h.segment7||'.'||h.segment8 CONTA
FROM
                    po_headers_all         a,
                    (SELECT
                            pv.segment1           AS nu_forn_ebs,
                            pv.vendor_id,
                            pvsa.vendor_site_id,
                            pvsa.party_site_id,
                            pv.vendor_name        AS fornecedor,
                            pv.vendor_name_alt    AS nome_fantasia,
                            pvsa.state            AS uf
                        FROM
                            po_vendors           pv,
                            po_vendor_sites_all  pvsa
                        WHERE
                            pv.vendor_id = pvsa.vendor_id)                      b,
                    po_line_locations_all  c,
                    fnd_user               d,
                    hr.hr_locations_all    e,
                    po_lines_all           f,
                    po_distributions_all   g,
                    gl_code_combinations   h
WHERE
1 = 1
AND a.vendor_id = b.vendor_id
AND a.vendor_site_id = b.vendor_site_id
AND a.po_header_id = c.po_header_id
AND a.created_by = d.user_id
AND a.ship_to_location_id = e.location_id
--and  a.INTERFACE_SOURCE_CODE = 'A01'
--and a.closed_code = 'OPEN' --Status de fechamento
--and a.CANCEL_FLAG = 'N'
--and b.uf = 'EX' --fornecedor internacional
--and c.CLOSED_CODE = 'OPEN'
--and a.PO_HEADER_ID in  ()
--and e.location_code in    ('KMB_AD_AM_001', 'KCA_AD_AM_006', 'KMB_AD_AM_003')
AND a.segment1 = 27761
AND b.uf = 'EX'
AND f.po_line_id  = g.po_line_id
AND a.po_header_id = f.po_header_id
AND f.po_line_id  = g.po_line_id
AND g.code_combination_id = h.code_combination_id
--and  d.USER_NAME  like '%LARISSA%'
--  and a.ATTRIBUTE1 in ('0066412','0066413','0066414','0066464','0066465','0066466','0066467','0066468','0066469','0066470','0066471')
ORDER BY
    a.creation_date DESC