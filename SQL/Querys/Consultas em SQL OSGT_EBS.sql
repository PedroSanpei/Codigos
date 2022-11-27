-----Consulta open interface RI - EBS---------------------------------------------------------------------------------------------------
SELECT
        A.invoice_num,
        A.other_expenses,
        A.import_other_val_included_icms

FROM    cll.cll_f189_invoices_interface A
WHERE   SOURCE = 'SOFTWAY'
AND     invoice_num IN ('121')
AND     series = 9;
---------------------------------------------------------------------------------------------------------------------------------------- 
-----SOMA TOTAL DO VALOR TOTAL DAS LINHAS-----------------------------------------------------------------------------------------------
SELECT  
        SUM(ili.total_amount)
FROM    cll.cll_f189_invoice_lines_iface ili
WHERE   1=1
AND     interface_invoice_id IN
                            (SELECT interface_invoice_id
                             FROM   cll.cll_f189_invoices_interface
                             WHERE SOURCE = 'SOFTWAY'
                             AND invoice_num IN ('3886')
                             AND series = 11
                             ) ;
-----------------------------------------------------------------------------------------------------------------------------------------                             
-----Consulta Open Interface RI Header com as linhas - EBS-------------------------------------------------------------------------------
SELECT
        a.*,
        b.error_code,
        b.error_message
FROM
        cll.cll_f189_invoice_lines_iface    a,
        cll.cll_f189_interface_errors       b
WHERE
        a.interface_invoice_id = 
                            (SELECT interface_invoice_id
                             FROM   cll.cll_f189_invoices_interface
                             WHERE  source = 'SOFTWAY'
                             AND    invoice_num IN ( '3418' )
                             AND    series = 11
                             )
AND a.interface_invoice_line_id = b.interface_invoice_line_id;
-----------------------------------------------------------------------------------------------------------------------------------------  
-----Consulta Open Interface RI LINHAS - EBS---------------------------------------------------------------------------------------------
SELECT *
FROM CLL.CLL_F189_INVOICE_LINES_IFACE
WHERE INTERFACE_INVOICE_ID IN
                            (SELECT INTERFACE_INVOICE_ID
                             FROM CLL.CLL_F189_INVOICES_INTERFACE
                             WHERE SOURCE = 'SOFTWAY'
                             and invoice_num IN ('121')
                             and series = 9
                             );
----------------------------------------------------------------------------------------------------------------------------------------- 
-----Consulta tabelas finais RI -EBS-----------------------------------------------------------------------------------------------------
SELECT  A.*
FROM    cll.CLL_F189_STATES              H,
        cll.CLL_F189_FISCAL_ENTITIES_ALL F,
        cll.CLL_F189_INVOICES            A
WHERE   H.STATE_CODE = 'EX'
AND     H.STATE_ID = F.STATE_ID
AND     F.ENTITY_ID = A.ENTITY_ID
AND     INVOICE_NUM IN ('20200021')
AND     SERIES = 11
ORDER BY    INVOICE_ID;
----------------------------------------------------------------------------------------------------------------------------------------- 
SELECT  I.*
FROM    CLL_F189_INVOICE_LINES I
WHERE   INVOICE_ID IN (SELECT   A.INVOICE_ID
                       FROM CLL_F189_STATES H,
                            CLL_F189_FISCAL_ENTITIES_ALL F,
                            CLL_F189_INVOICES            A
                       WHERE H.STATE_CODE = 'EX'
                       AND H.STATE_ID = F.STATE_ID
                       AND F.ENTITY_ID = A.ENTITY_ID
                       AND INVOICE_NUM IN ('20200021')
                       AND SERIES = 11
                       )
ORDER BY I.INVOICE_ID;
-----------------------------------------------------------------------------------------------------------------------------------------
-- Renotificar NotaFiscal RI para Em Elaboração LEMBRETE - DE COMMIT DEPOIS DE EXECUTAR!!!! - OSGT
UPDATE  BS_NOTA_FISCAL A
SET     A.STATUS_NF = 'Em Elaboração.', A.NFE_SEFAZ_STATUS = 'Em Elaboração.'
WHERE   NUM_NF IN (3886)
AND     A.SERIE = 11;
-----------------------------------------------------------------------------------------------------------------------------------------   
-- Renotirficar NotaFiscal RI para Aprovada SEFAZ LEMBRETE - DE COMMIT DEPOIS DE EXECUTAR!!!! - OSGT
UPDATE bs_nota_fiscal A
SET A.status_nf = 'Impressa.', A.nfe_sefaz_status = 'Aprovada - SEFAZ.'
WHERE num_nf IN(3886)
AND A.serie = 11; 
-----------------------------------------------------------------------------------------------------------------------------------------      
-----Consulta a Tabela de Notifação OSGT------------------------------------------------------------------------------------------------- 
SELECT 
        A.*,
        A.ROWID
FROM    oif_export A
WHERE   1 = 1
AND     id_evento = 5521 -- RI
AND     A.pk_number_01 IN
                        (SELECT id_notafiscal
                         FROM bs_nota_fiscal A
                         WHERE 1 = 1
                         --and status in (2, 3, 1)
                         AND num_nf IN
                         ('121')
                         AND A.serie IN (9)
                         )
ORDER BY pk_number_01;
-----------------------------------------------------------------------------------------------------------------------------------------  
-----Select para consultar a chave de acesso da nota-------------------------------------------------------------------------------------  
SELECT 
        A.NUM_NF,
        A.SERIE, 
        A.NFE_SEFAZ_STATUS,
        A.NFE_SEFAZ_CHAVE_ACESSO
FROM    TRBSKMB.NOTA_FISCAL A
WHERE   NUM_NF = 707
AND     SERIE = 3;
-----------------------------------------------------------------------------------------------------------------------------------------  
-----Update para alterar chave de acesso.------------------------------------------------------------------------------------------------
UPDATE      trbskmb.nota_fiscal
SET         nfe_sefaz_chave_acesso = '13210314386045000150550030000007077000005112'
WHERE       num_nf = 707
AND         serie = 3;
----------------------------------------------------------------------------------------------------------------------------------------- 
-----Relatório de Itens  OSGT------------------------------------------------------------------------------------------------------------
SELECT 
            decode(C.id_organizacao, 301, 'KMB', 290, 'KCA') AS org,
            C.part_number,
            stp.descricao AS tipo_produto,
            C.ncm,
            C.descricao_detalhada,
            C.seq_suframa,
            C.cod_prod_suframa,
            C.tipo_prod_suframa,
            C.id_detalhe_suframa,
            C.modelo_prod_suframa,
            nve.cd_atributo_ncm,
            nve.cd_especif_ncm,
            nve.cd_nivel_ncm,
            nve.id_produto,
            nve.cd_nomenc_ncm,
            ncmd.id_detalhe_suframa
FROM        sfw_produto C
LEFT JOIN   trkmb.sfw_produto_nve nve           ON nve.id_produto = C.id_produto
LEFT JOIN   trkmb.sfw_detalhe_ncm_suframa ncmd  ON ncmd.id_detalhe_suframa = C.id_detalhe_suframa
LEFT JOIN   trkmb.sfw_tipo_produto stp          ON stp.tipo_produto = C.F
WHERE       C.id_organizacao IN (290, 301); -- kca e kmb
----------------------------------------------------------------------------------------------------------------------------------------- 
-----Procura em todas as tabelas o que tiver o nome ou número que colocar no campo depois do like.
SELECT
        A.* 
FROM    ALL_TABLES A 
WHERE   A.TABLE_NAME LIKE '%NVE%';
----------------------------------------------------------------------------------------------------------------------------------------- 
-----Select na tabela de Itens-----------------------------------------------------------------------------------------------------------
SELECT * FROM mtl_system_items_b WHERE segment1 = '13008-0572';
----------------------------------------------------------------------------------------------------------------------------------------- 
-----Renotifica PO.----------------------------------------------------------------------------------------------------------------------
BEGIN
  pkg_r12_kmb_notifica_geral_cst.prc_notifica_ordem_compra('9607'); --numero da PO
END; 
(aconselho usar pl SQL usando O usuário trsctkmb E O bd kmbngr)
-----------------------------------------------------------------------------------------------------------------------------------------
-----consulta POs paradas na interfces---------------------------------------------------------------------------------------------------
SELECT DISTINCT 
        OI.ID_IMPORTACAO, 
        OI.NUM_PEDIDO, 
        R.TABLE_NAME, 
        API.MSG_PADRAO --, D.DATA
FROM    TRIOKMB.ERROS_IMPORTACAO E,
        TRIOKMB.REGISTROS_INTERFACES R,
        TRIOKMB.SISTEMA S,
        TRIOKMB.DATA_PROC D,
        TRIOKMB.ERROS_API API,
        TRIOKMB.IS_ORDEM_IMPORTACAO_HEADER OI
WHERE   R.ID = E.ID
AND     S.ID_SISTEMA = E.ID_SISTEMA
AND     D.ID_IMPORTACAO(+) = R.ID_IMPORTACAO
--and   e.obs not like 'Falha no%'
AND     API.ID = E.ID
AND     OI.ID_IMPORTACAO = R.ID_IMPORTACAO
AND     OI.NUM_PEDIDO NOT IN
                        (SELECT NUM_ORDEM 
                         FROM TRISKMB.ORDENS_IMPORTACAO
                         )
AND OI.NUM_PEDIDO = '8924.145'
ORDER BY ID_IMPORTACAO
-----------------------------------------------------------------------------------------------------------------------------------------
-----re-notific itens de POs paradas na interface----------------------------------------------------------------------------------------
DECLARE
BEGIN
FOR cprod IN 
            (SELECT DISTINCT A.part_number, 
                            '151' AS organization_id --colocar o OR_ID correto (151= SP/ 149=KMB Manaus/157 = KCA
             FROM triokmb.is_itens_ordem_importacao A
             WHERE 1=1
             AND num_pedido = '31741.145' -- PO
             AND A.part_number NOT IN
                                    (SELECT B.part_number
                                     FROM trkmb.sfw_produto B
                                     WHERE flex_field1 = 151
                                     )
            ) -- ITENS DE PO NÃO CADASTRADOS
LOOP
--
            pkg_r12_kmb_notifica_geral_cst.prc_notifica_produtos(cprod.part_number,
            cprod.organization_id);
--
END LOOP;
END;
-----------------------------------------------------------------------------------------------------------------------------------------
-----PO CRIADAS EBS COM USUÁRIO----------------------------------------------------------------------------------------------------------
SELECT 
        A.segment1 || '.' || A.org_id AS no_po_osgt,
        A.segment1 AS no_po,
        A.org_id,
        A.po_header_id,
        attribute1 AS no_invoice,
        A.authorization_status AS status,
        A.attribute_category,
        A.interface_source_code,
        B.user_name,
        to_char(A.creation_date, 'dd/mm/yyyy hh24:mi:ss') AS creation_date, 
        to_char(A.last_update_date,'dd/mm/yyyy hh24:mi:ss') AS last_update
FROM    apps.po_headers_all A, apps.fnd_user B
WHERE   1 = 1
AND     A.created_by = B.user_id
AND     segment1 IN ('39866')
--and   authorization_status = 'APPROVED'
--AND   to_char(a.CREATION_DATE, 'dd/mm/yyyy') = '13/02/2019'
ORDER BY 2, 3
-----------------------------------------------------------------------------------------------------------------------------------------
-----Consulta Item - EBS-----------------------------------------------------------------------------------------------------------------
SELECT  * 
FROM    MTL_SYSTEM_ITEMS_B 
WHERE   1=1
--AND   segment1 = '13008-0572'
AND     PRIMARY_UOM_CODE = 'ROL' --Qual a Unidade de Medida ele está
AND     ORGANIZATION_ID = 151 -- Organização (149-MANAUS, 151-SP, 147-Master)
AND     GLOBAL_ATTRIBUTE3  IN (1, 2, 6)--MATERIAL IMPORTADO (origem do item)
ORDER BY 1,2
-----------------------------------------------------------------------------------------------------------------------------------------
-----Verificar se número da nota bate com ID_NOTA---------------------------------------------------------------------------------------- 
SELECT
        *
FROM
        bs_nota_fiscal a
WHERE   id_notafiscal IN ('3668');
-----------------------------------------------------------------------------------------------------------------------------------------
SELECT
        *
FROM
        bs_nota_fiscal A
WHERE   dt_emissao LIKE '10/02/21';
-----------------------------------------------------------------------------------------------------------------------------------------
-----Update no Status da nota na Tabela de notificação-----------------------------------------------------------------------------------
UPDATE  oif_export A
SET     status ='99999' 
WHERE   pk_number_01 IN ('3567','3568','3645','3646','3647','3648','3569','3660','3661','3662','3657','3658','3639','3656','3638','3640','3641');
-----------------------------------------------------------------------------------------------------------------------------------------
update  oif_export a
set     STATUS ='1' 
where   PK_NUMBER_01 IN ('');
-----------------------------------------------------------------------------------------------------------------------------------------
-----Consulta a Tabela de Notifação  Pesquisando por status e quantidade de itens--------------------------------------------------------
SELECT  a.*
FROM    oif_export a 
where pk_number_01 IN 
                    ('3567','3568','3645','3646','3647','3648','3660','3661'
                    ,'3662','3657','3658','3639','3656','3638','3640','3641'
                    );
-----------------------------------------------------------------------------------------------------------------------------------------
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
        where a.id_notafiscal = z.id_notafiscal
        ) as qtd_itens,
       case
            when a.status = 1 then  'EM ESPERA'
            when a.status = 2 then  'SUCESSO'
            when a.status = 3 then  'PROCESSANDO'
            when a.status = 4 then  'ERRO'
       end as Status

from    oif_export a, 
        bs_nota_fiscal z
where   a.pk_number_01 = z.id_notafiscal
--and   z.serie in (11)
and     a.status  in (99999)
--and   z.num_nf in (178,180,181,182,183)
--and   a.pk_number_01 in (3638)
and     a.id_evento in (6002, 6106, 6128) --enviar, inutilizar e cancelar
--and   status_nf <> 'Impressa.'
--and   nfe_sefaz_status like '%Liberada%'
and     to_char(data_transacao, 'yyyy/mm') = '2021/02'
order by  z.processo_di ;
------------------------------------------------------------------------------------------------------------------------------------------ 
---------------------------------------------------------------CASOS RETORNAR PO P6-------------------------------------------------------
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

-- 6. Verificar se a mesma se encontra nas tabelas KTT_PO_HEADER com erro ou não (Erro Status 3) Caso tiver use o select abaixo
select * from DTT_PO_P06_ERROS where invoice_number = '0068997'

-- 7. Após corrigir o Erro reprocessar no WSK e validar o status_id na ktt se estiver 1 ele vai para STG EBS
select id_status from  kmtt_po_headers_interface_stg WHERE DOCUMENT_NUM in ('0068997');

--------------------------------------------------------------------------------------------------------------------------------------------
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
                    hr.fa    e,
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
    
    
--SELECT SERVICE NAME

select value from v$parameter where name like '%service_name%';

-- SELECT BUSCA ERRO NA TELA DE RECEBIMENTO FÍSICO PO (EBS > KMB_PO > Recebimento > Sumário do Status da Transação)
SELECT

    a.interface_transaction_id,
    a.transaction_type,
    a.transaction_status_code,
    c.segment1 COD_ITEM,
    a.primary_quantity,
    a.primary_unit_of_measure,
    a.source_document_code,
    d.segment1 PO,
    b.column_name,
    'Erro Referente a linha: '|| e.line_num LINHA_PO,
    b.error_message,
    b.error_message_name
    
FROM
    rcv_transactions_interface  a,
    po_interface_errors         b,
    mtl_system_items_b          c,
    po_headers_all              d,
    po_lines_all                e
WHERE
    a.interface_transaction_id = b.interface_line_id
AND a.item_id = c.inventory_item_id
AND a.to_organization_id = c.organization_id
AND a.po_header_id = d.po_header_id
AND d.po_header_id = e.po_header_id
AND A.group_id = '442802';


--script para forçar envio de fatura para o AP (renotificar)
--consulta antes
select fi.data_envio_oracle_ap, fi.num_invoice, id_invoice, fi.status_cambio
  from triskmb.faturas_importacao fi
 where 1=1
 and fi.id_invoice in (999) ;

--ALTERA O STATUS PARA 1 
update triskmb.faturas_importacao fi set fi.status_cambio = 1 where fi.id_invoice in (999) ;


--retorna o status para 0
update triskmb.faturas_importacao fi  set fi.status_cambio = 0 where fi.id_invoice in (999) ;


   
--verificar a tabela oif_export se gerou notificação id_evento 5520
select * from oif_export where id_evento = 5520
and  pk_number_01 in (999);

select a.id_evento,
       a.pk_number_01,
       z.processo_di as processo,
      z.nfe_sefaz_chave_acesso,
     --  z.status_nf,
     --  z.nfe_sefaz_status,
     z.dt_emissao,
     decode(z.complementar, 'D', 'NFC','E','NFE') as tipo,
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
          'PROCESSADA'
         when a.status = 3 then
          'PROCESSANDO'
         when a.status = 4 then
          'ERRO'
       end as Status
       

  from oif_export a, bs_nota_fiscal z
 where a.pk_number_01 = z.id_notafiscal
      --and z.serie in (11)
  and a.status in (1,4,3)
  --    and z.num_nf in (2281)
      --and a.pk_number_01 in (723)
   and a.id_evento in (6002) --enviar, inutilizar e cancelar
      --, 6106, 6128)
      --and status_nf <> 'Impressa.'
      --and nfe_sefaz_status like '%Liberada%'
  and to_char(data_transacao, 'yyyy/mm/dd') >= '2022/07/18'
 order by z.num_nf
 
 
 
 
 -- SELECT BUSCA NOTA SAÍDA COM INFORMAÇÕES COMPLETAS
SELECT
    etb.name                    EMPRESA,
    reg.registration_number     CNPJ_EMISSOR,
    rcta.trx_number             NUM_NOTA,
    rctt.name                   TIPO_TRANSAÇÃO,
    rctt.global_attribute3      CFOP,
    jbao.cfo_description,
    rbsa.attribute6             IE,
    rbsa.name                   SERIE,
    jbcte.ELECTRONIC_INV_ACCESS_KEY
    
FROM
    ra_customer_trx_all         rcta,
    ra_batch_sources_all        rbsa,
    ra_cust_trx_types_all       rctt,
    apps.xle_etb_profiles       etb,
    apps.xle_registrations      reg,
    apps.hr_locations_all       hrl,
    apps.xle_jurisdictions_vl   jur,
    jl_br_ap_operations         jbao,
    jl_br_customer_trx_exts     jbcte

    
WHERE
    rcta.batch_source_id            = rbsa.batch_source_id
AND rcta.cust_trx_type_id           = rctt.cust_trx_type_id
AND rcta.customer_trx_id            = jbcte.customer_trx_id
AND rctt.global_attribute3          = jbao.cfo_code
AND hrl.inventory_organization_id   = (select distinct rctla.warehouse_id from ra_customer_trx_lines_all rctla 
                                     where rctla.customer_trx_id = 1129557 and line_type = 'LINE')
AND etb.establishment_id            = reg.source_id
AND reg.source_table                = 'XLE_ETB_PROFILES'
AND hrl.location_id                 = reg.location_id
AND jur.jurisdiction_id             = reg.jurisdiction_id
AND jur.legislative_cat_code        = 'FEDERAL_TAX'
AND sysdate BETWEEN nvl(etb.effective_from, sysdate) AND nvl(etb.effective_to, sysdate)
AND etb.legal_entity_id             = rcta.legal_entity_id
AND to_char(rcta.creation_date, 'YYYY') /*BETWEEN '2020' AND */ ='2022'
AND rcta.org_id                     = '145'
AND rcta.customer_trx_id            = '1133363'


--CONSULTA LOG ENVIO NFE
SELECT NF.NUM_NF,
       SERIE,
       U.NOME,
       ANFE.DT_OCORRENCIA,
       ANFE.DESCRICAO,
       ANFE.DT_ATUALIZACAO

  FROM TRBSKMB.AUDITORIA_NF_ELETRONICA ANFE,
       SFW_USUARIO                     U,
       TRBSKMB.NOTA_FISCAL             NF

 WHERE ANFE.ID_USUARIO = U.ID_INFORMANTE
   AND ANFE.ID_NOTAFISCAL = NF.ID_NOTAFISCAL
   AND NF.NUM_NF = 2996
   AND SERIE = 3

 ORDER BY ANFE.DT_ATUALIZACAO
 
 --CARREGA VIEW DINAMICA (LEMBRAR DE RODAR COMO TRCSTKMB SE A VIEW ESTIVER NO OWNER POREM RODAR NA CONEXÃO DO TRISKMB)
exec PRC_SFW_ATUALIZA_DD_VIEW_DIN('VW_DIAGNOSTICO_PRE_PLI_CST','TRCSTKMB');



--CONSULTA DI com código de vinculação
select distinct 
                di.area_negocio,
                di.num_di,
                di.data_registro_di,
                parc.cod_parceiro,
                parc.razao_social   as fornecedor,
                ad.processo_di,
                ad.cod_vinculacao ||'-'|| vad.descricao  cod_vinc_na_adicao,
                cpl.cod_vinculacao ||'-'|| vpar.descricao  cpl_cod_vinc_no_cadastro
  from trbskmb.adicoes           ad,
       sfw_parceiro              parc,
       sfw_complementar_parceiro cpl,
       trbskmb.di                di,
       sfw_vinculacao            vad,
       sfw_vinculacao            vpar
 where 1=1
      --and ad.cod_vinculacao = 1
      -- and cpl.cod_vinculacao = 1
   and ad.cod_exportador = parc.id_parceiro
   and parc.id_parceiro = cpl.id_parceiro
   and di.area_negocio in ('KCA_AD_AM_006','KMB_AD_AM_001')
   and ad.processo_di = di.processo_di(+)
   and ad.cod_vinculacao = vad.cod_vinculacao (+)
   and cpl.cod_vinculacao = vpar.cod_vinculacao (+)
 order by data_registro_di
 
 --------------------------------PROCESSO PARA FINALIZAR INTERFACE EXECUTANDO E ANALISAR LOCK---------------------


--- INSER PARA PROBLEMAS DE NOTAS APROVADAS NÃO ATUALIZADAS NO TPMG
insert into jl_br_eilog (occurrence_id, 
occurrence_date,
customer_trx_id,
electronic_inv_status,
message_txt,
last_update_date,
last_updated_by,
last_update_login,
creation_date, 
created_by) 
values (XXAVL_BR_EILOG_S.NEXTVAL, -- occurrence_id
'28/07/22', -- occurrence_date 
1158119,-- customer_trx_id
'2', -- electronic_inv_status
'Autorizado o uso da NF-e', -- message_txt
'28/07/22', -- last_update_date,
-1, -- last_updated_by,
17159849 -- last_update_login,
'28/07/22'--creation_date ,
-1-- created_by);

 
 
 -- LIBERA EXECUÇÃO INTERFACE
 UPDATE TRIOKMB.IMPORTACOES_PREVISTAS SET STATUS = 'S' WHERE ID_IMPORTACAO = 1419251;
 
-- Lista de sessoes
SELECT
	coalesce(s.username, '(oracle)') AS username
	,s.osuser
	,s.schemaname
	,s.sid
	,s.serial#
	,p.spid
	,s.lockwait
	,s.status
	,s.service_name
	,s.machine
	,s.program
	,TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
	,s.last_call_et AS last_call_et_secs
	,s.seconds_in_wait
	,s.module
	,s.action
	,s.client_info
	,s.client_identifier
	,p.tracefile
FROM
	v$session s,
	v$process p
WHERE
	s.paddr = p.addr
--and s.sid in (358)
--and upper(s.module) like '%DTT%'
and upper(s.module) like '%IN_OUT%'
--and status = 'ACTIVE'
ORDER BY
	s.logon_Time asc,
	s.status desc,
	s.username,
	s.osuser;

-- ### Habilita trace para sessao (SID)
exec dbms_monitor.session_trace_enable(61);

-- Caminho padrao para o trace
SELECT
	value
FROM
	v$diag_info
WHERE
	name = 'Diag Trace';

-- Tabela com informacoes de caminhos padrao do BD
select * FROM v$diag_info;

-- Arquivo de trace da sessao
SELECT
	s.sid,
	p.tracefile
FROM
	v$session s
JOIN
	v$process p ON
	
		s.paddr = p.addr
--/*
WHERE
	s.sid = 244;
--	p.tracefile like '%OSGTPRDB_lmhb_6005.trc%';
--*/


/*
-- Sessoes derrubadas OSGT (pid, serial)
alter system kill session '187,22465';
alter system kill session '497,5457';
alter system kill session '176,16772';
alter system kill session '362,34153';
-- 28/04/2021
alter system kill session '14,10764';
alter system kill session '44,29215';
alter system kill session '352,64494'
-- 10/05/2021;
alter system kill session '338,8893';
alter system kill session '358,43553';
alter system kill session '517,54477';
-- 17/05/2021
alter system kill session '496,48205';
*/

select * from v$session;
SELECT * FROM v$process;
-------------------------------------------------------------------------------------------------------------------
--------------------------- -----CASO RELACIONADO A RI STATUS "EM REVERSÃO".---------------------------------------
/*1º Faça o Select abaixo para considerar SE o status da PO LOCATIONS está em "FINALLY CLOSED"*/
SELECT
    line_location_id,
    closed_code,
    closed_reason,
    closed_date,
    closed_by
FROM
    apps.po_line_locations_all 
WHERE 
    line_location_id = here line_location_id = ;
/*2º SE Status for igual a "FINALLY CLOSED" rode update abaixo*/
update  apps.po_line_locations_all
set     closed_code   = 'CLOSED FOR RECEIVING',
        closed_reason = null,
        closed_date   = null,
        closed_by     = null
where 
        line_location_id = 4029748;
/*3º Faça o Select abaixo para considerar SE o status da PO LINES está em "FINALLY CLOSED"*/
SELECT
    po_line_id,
    closed_code,
    closed_reason,
    closed_date,
    closed_by
FROM
    apps.po_lines_all 
where 
    po_line_id = ;
/*4º SE Status for igual a "FINALLY CLOSED" rode update abaixo*/
update  apps.po_lines_all
set     closed_code = 'CLOSED',
        closed_reason = null,
        closed_date   = null,
        closed_by     = null
where   po_line_id = 2636679;
/*5º Faça o Select abaixo para considerar SE o status da PO HEADERS está em "FINALLY CLOSED"*/
SELECT
    po_header_id,
    closed_code,
    closed_date
FROM
    apps.po_headers_all 
where po_header_id =;
/*6º SE Status for igual a "FINALLY CLOSED" rode update abaixo*/
update apps.po_headers_all
set closed_code = 'CLOSED',
    closed_date   = null
where po_header_id = 1026700;
----------------------------------------------------------------------------------------------------------------



SELECT
    a.num_nf,
    b.*
FROM
    nota_fiscal a,
    itens_nf    b
where a.id_notafiscal = b.id_notafiscal
and a.dt_emissao between '13/09/2022' and '14/09/2022';

-- ALTERAR SENHA USUÁRIO VIA BANCO OSGT - RODAR NO TRKMB -- SENHA CRIPTOGRAFADA ABAIXO EQUIVALE É ESSA >> Kawa2022***

UPDATE SFW_USUARIO SET S_SENHA_SHA ='b36794453d9dc64aa24adc224baa7bfd078ff425' WHERE USERNAME ='deborah_dourado';



-- RELATÓRIO PAIS X FABRICANTE X NCM
select
d.oi_name,
d.oi_code,
--MB.INVENTORY_ITEM_ID,
MB.GLOBAL_ATTRIBUTE3,
decode(MB.GLOBAL_ATTRIBUTE3,1,'IMPORTADO',2,'IMPORTADO',6,'IMPORTADO','NACIONAL') AS ORIGEM,
MB.SEGMENT1 AS PART_NUMBER,
CATEGORY_CONCAT_SEGS as NCM,
MB.UNIT_WEIGHT AS PESO,
MB.WEIGHT_UOM_CODE AS UN_PESO,
MB.GLOBAL_ATTRIBUTE2 AS NAT_OPER,
UPPER(E.DESCRIPTION) AS TIPO_ITEM,
MB.INVENTORY_ITEM_STATUS_CODE AS STATUS,

MB.DESCRIPTION AS DESC_ITEM,
MB.LONG_DESCRIPTION AS DESC_LONGA,

c.*

FROM APPS.MTL_ITEM_CATEGORIES_V MIC,
APPS.MTL_SYSTEM_ITEMS_FVL MB,
(select --MANUFACTURER_ID ||'M' as COD_PARCEIRO,
MP.MFG_PART_NUM,
mp.INVENTORY_ITEM_ID,
MM.MANUFACTURER_ID as ID_FABRICANTE,
MM.MANUFACTURER_NAME AS FABRICANTE,
trim(MM.description) as des_fabricante,
MM.attribute1 as Codigo_do_Pais,
MM.attribute2 as Logradouro,
MM.attribute3 as Número,
MM.attribute4 as Complemento,
MM.attribute5 as Cidade,
MM.attribute6 as Estado
from apps.MTL_MANUFACTURERS MM, MTL_MFG_PART_NUMBERS MP
WHERE MP.MANUFACTURER_ID = MM.MANUFACTURER_ID) c,

(SELECT hou.NAME OU_name,
hou.short_code,
hou.organization_id OU_id,
hou.set_of_books_id,
hou.business_group_id,
ood.organization_name OI_name,
ood.organization_code OI_code,
ood.organization_id OI_id,
ood.chart_of_accounts_id
FROM hr_operating_units hou, org_organization_definitions ood
WHERE 1 = 1
AND hou.organization_id = ood.operating_unit) d,

(SELECT LOOKUP_CODE, DESCRIPTION
FROM FND_LOOKUP_VALUES_VL
WHERE (nvl('', territory_code) = territory_code or
territory_code is null)
AND lookup_type = 'ITEM_TYPE'
and (LOOKUP_TYPE LIKE 'ITEM_TYPE')
and (VIEW_APPLICATION_ID = '3')
and (SECURITY_GROUP_ID = '0')
order by LOOKUP_CODE) e

WHERE MIC.INVENTORY_ITEM_ID = MB.INVENTORY_ITEM_ID
AND MIC.CATEGORY_SET_ID = 1100000022
AND MB.ORGANIZATION_ID = mic.ORGANIZATION_ID
AND MB.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID (+)
AND MB.ORGANIZATION_ID = d.oi_id
AND MB.ITEM_TYPE = E.LOOKUP_CODE
AND MB.GLOBAL_ATTRIBUTE3 IN (1, 2, 6) --ITENS IMPORTADOS
-- AND MB.SEGMENT1 = ('11054-1840 1A')
ORDER BY 4, 1

--- TABELA DE NUMERACAO NOTA FISCAL

select * from trbskmb.numeracao_nota_fiscal;

UPDATE trbskmb.numeracao_nota_fiscal
SET NUM_NF = '17'
WHERE SERIE = '12'

-- SELECT PARA VISUALIZAR QUAL ITEM DE INSUMO ESTÁ SEM OS FLAGS DE CUSTO (PROCESSO PTP INSUMO - CONTABILIDADE ERRADA)
SELECT
    B.LINE_NUM,
    C.SEGMENT1,
    C.COSTING_ENABLED_FLAG,
    C.INVENTORY_ASSET_FLAG,
    C.DEFAULT_INCLUDE_IN_ROLLUP_FLAG 
FROM
    PO_HEADERS_ALL A,
    PO_LINES_ALL   B,
    MTL_SYSTEM_ITEMS_B C
WHERE
A.PO_HEADER_ID = B.PO_HEADER_ID
AND B.ITEM_ID = C.INVENTORY_ITEM_ID
AND A.SEGMENT1 = '28484'
AND C.COSTING_ENABLED_FLAG != 'Y';

-- VALIDAÇÃO DE PROCESSOS PTP CENÁRIO ATIVO
select DECODE(h.ORG_ID, 155, 'KCA', 145, 'KMB') AS ORG,
       i.organization_id,
       t.INVOICE_TYPE_CODE tipo_nf,
       t.DESCRIPTION desc_tipo_nf,
       h.COMMENTS,
       h.segment1 po,
       d.LINE_NUM linha_PO,
       i.invoice_num nota_fiscal,
       i.operation_id N_RI,
       I.INVOICE_DATE AS DT_NOTA_FISCAL,
       i.INVOICE_AMOUNT vlr_nf,
       l.INVOICE_LINE_ID linha_NF,
       b.segment1 cod_item,
       d.ITEM_DESCRIPTION desc_item_po,
       l.quantity qtde_nf,
       l.UNIT_PRICE vlr_unitario_nf,
       o.OPERATION_ID num_recebimento,
       o.RECEIVE_DATE data_recebimento,
       o.STATUS status_recebimento,
       u.segment3 conta,
       h.INTERFACE_SOURCE_CODE


  from apps.cll_f189_invoices         i,
       apps.cll_f189_invoice_lines    l,
       apps.po_line_locations_all     c,
       apps.cll_f189_ENTRY_OPERATIONS o,
       apps.po_headers_all            h,
       apps.po_lines_all              d,
       apps.mtl_system_items_b        b,
       apps.cll_f189_invoice_types    t,
       apps.gl_code_combinations    u
       
      

 where i.invoice_id = l.invoice_id
   and l.line_location_id = c.line_location_id
   and l.db_code_combination_id = u.code_combination_id
   and d.po_header_id = h.po_header_id
   and c.po_line_id = d.po_line_id
   and b.inventory_item_id = l.item_id
   and b.organization_id = l.organization_id
   and i.OPERATION_ID = o.OPERATION_ID
   and i.ORGANIZATION_ID = o.ORGANIZATION_ID
   and i.INVOICE_TYPE_ID = t.invoice_type_id
   
   and h.ORG_ID = 145
   and t.INVOICE_TYPE_CODE in ('52I_ECP','53I_ECP')
   and I.INVOICE_DATE >= '13-12-2021' --pós golive PTP
  
 order by h.SEGMENT1, d.LINE_NUM;
 
 SELECT * FROM po_headers_all 
 
-----------------------------------CASOS DI COM NVE INCORRETO-------------------------------------------------
--1º PESQUISE PARA VER SE O CAMPO CD_ESPECIF_NCM ESTÁ COM APENAS 1 DÍGITO
SELECT * FROM NVE_ADICAO WHERE PROCESSO_DI = 'KMB-0870/22' AND SEQUENCIA_ADICAO = 842484 ;
--2º APÓS ISSO RODE O UPDATE ABAIXO
update NVE_ADICAO 
set cd_especif_ncm = lpad(cd_especif_ncm,4,'0')
where processo_di = 'KMB-0870/22'
--3º CASO HAJA ERRO DE CONSTRAINT FAÇA A PESQUISA EM LINHAS QUE TEM A SEQUENCIA DE ADIÇÃO DUPLICATAS
SELECT * FROM NVE_ADICAO WHERE PROCESSO_DI = 'KMB-0870/22' AND SEQUENCIA_ADICAO = 842484 ;
--4º FAÇA UM DELETE DAS DUPLICATAS
DELETE FROM NVE_ADICAO WHERE PROCESSO_DI = 'KMB-0870/22' AND SEQUENCIA_ADICAO = 842484 AND CD_ESPECIF_NCM IN ('2','3') AND CD_NOMENC_NCM = '73181500'
----------------------------------------------------------------------------------------------------------------
----------------------------------SELECT PARA VISUALIZAR DIFERENÇAS DE SALDO REMESSA --------------------------------------------------------
with ter_rec as (select inventory_item_id rec_inventory_item_id,
                        tpa_receipts_control_id,
                        invoice_number,
                        received_quantity,
                        remaining_balance
                 from apps.cll_f513_tpa_receipts_control
                 where 1=1
                 and   organization_id = 164
                 --and   inventory_item_id = 7265
                 and   operation_status = 'COMPLETE'
                 and   reversion_flag is null
                 order by inventory_item_id,
                          tpa_receipts_control_id),
     --
     ter_dev as (select inventory_item_id dev_inventory_item_id,
                        tpa_receipts_control_id,
                        sum(devolution_quantity) devolution_quantity
                 from apps.cll_f513_tpa_devolutions_ctrl
                 where 1=1
                 --and   inventory_item_id = 7265
                 and   devolution_status = 'COMPLETE'
                 and   nvl(cancel_flag, 'N') = 'N'
                 group by inventory_item_id,
                          tpa_receipts_control_id
                 order by inventory_item_id,
                          tpa_receipts_control_id)
--
select ter_rec.rec_inventory_item_id,
       ter_rec.tpa_receipts_control_id,
       ter_rec.invoice_number,
       ter_rec.received_quantity,
       --ter_dev.dev_inventory_item_id,
       --ter_dev.tpa_receipts_control_id dev_tpa_receipts_control_id,
       ter_dev.devolution_quantity,
       ter_rec.remaining_balance,
       (ter_rec.received_quantity - ter_dev.devolution_quantity) tpmg_balance       
from ter_rec full outer join ter_dev
on    1=1
and   ter_rec.rec_inventory_item_id   = ter_dev.dev_inventory_item_id
and   ter_rec.tpa_receipts_control_id = ter_dev.tpa_receipts_control_id
where (ter_rec.received_quantity - ter_dev.devolution_quantity) != ter_rec.remaining_balance
order by (ter_rec.received_quantity - ter_dev.devolution_quantity),
         ter_rec.rec_inventory_item_id,
         ter_dev.dev_inventory_item_id;
---------------------------------------------------------------------------------------------------------------------------------------
--- senha git KAWASAKI ATBBM7958gQ449snWcFPWFENzzFs249330A8---------

---------------DATAFIX CASOS DE NOTA DE DEVOLUÇÃO TPMG FORA DO PERÍODO---------------------------------------------
declare
  g_vTitle                      fnd_lookup_values.description                          %TYPE ;
  g_vProgram_name               fnd_concurrent_programs_tl.user_concurrent_program_name%TYPE ;
  g_err_upd_tpa_returns         fnd_lookup_values.description                          %TYPE := 'CLL_F513_ERR_TPA_RETURN_CTRL' ;
  g_vSeparator                  VARCHAR2(10) := '  ' ;
  g_nLength_output              NUMBER := 194 ;
  g_nLength_log                 NUMBER := 77  ;
  --
  -- BUG 29625111 - Start
  g_rec_trans_iface         mtl_transactions_interface    %ROWTYPE ;
  g_rec_trans_lots_iface    mtl_transaction_lots_interface%ROWTYPE ;
  g_rec_serial_num_iface    mtl_serial_numbers_interface  %ROWTYPE ;
  g_rec_remit_control       cll_f513_tpa_remit_control    %ROWTYPE ;
  g_rec_tpa_control_log     cll_f513_tpa_control_log      %ROWTYPE ;
  g_crec_trans_iface        mtl_transactions_interface    %ROWTYPE ;
  g_crec_trans_lots_iface   mtl_transaction_lots_interface%ROWTYPE ;
  g_crec_serial_num_iface   mtl_serial_numbers_interface  %ROWTYPE ;
  g_crec_remit_control      cll_f513_tpa_remit_control    %ROWTYPE ;
  g_crec_tpa_control_log    cll_f513_tpa_control_log      %ROWTYPE ;
  g_rec_tpa_devol_ctrl      cll_f513_tpa_devolutions_ctrl %ROWTYPE ;
  g_crec_tpa_devol_ctrl     cll_f513_tpa_devolutions_ctrl %ROWTYPE ;
  g_msg_retorno             VARCHAR2(1000) ;
  --
  FUNCTION GET_LOOKUP_VALUES (p_lookup_type    IN  VARCHAR2 DEFAULT NULL
                             ,p_lookup_code    IN  VARCHAR2 DEFAULT NULL
                             ) RETURN VARCHAR2 IS
    --
    l_description      fnd_lookup_values_vl.description%type;
    --
  BEGIN
    BEGIN
        SELECT description
          INTO l_description
          FROM apps.fnd_lookup_values_vl
         WHERE lookup_type           = p_lookup_type
           AND lookup_code           = p_lookup_code
           AND NVL(enabled_flag,'N') = 'Y'
           AND NVL(end_date_active,SYSDATE) >= SYSDATE;
    EXCEPTION
      WHEN others THEN
        l_description := NULL;
    END;
    --
    RETURN l_description;
    --
  END GET_LOOKUP_VALUES;
  --
  PROCEDURE INSERT_TPA_CONTROL_LOG_P (rec_tpa_control_log IN cll_f513_tpa_control_log%ROWTYPE, msg_retorno OUT NOCOPY VARCHAR2) IS
  l_msg_retorno  VARCHAR2(1000) ;
  BEGIN
    --
    BEGIN
      --
      INSERT INTO cll_f513_tpa_control_log
           ( attribute_category                                 , attribute1                                         , attribute10
           , attribute11                                        , attribute12                                        , attribute13
           , attribute14                                        , attribute15                                        , attribute16
           , attribute17                                        , attribute18                                        , attribute19
           , attribute2                                         , attribute20                                        , attribute3
           , attribute4                                         , attribute5                                         , attribute6
           , attribute7                                         , attribute8                                         , attribute9
           , cancel_transaction_id                              , created_by                                         , creation_date
           , customer_name                                      , customer_number                                    , customer_trx_id
           , customer_trx_line_id                               , devolution_transaction_id                          , invoice_number
           , item_number                                        , last_update_date                                   , last_updated_by
           , last_update_login                                  , line_number                                        , lot_number
           , operation_id                                       , org_id                                             , process_description
           , process_source                                     , process_status                                     , program_application_id
           , program_id                                         , program_update_date                                , receipt_transaction_id
           , request_id                                         , returned_transaction_id                            , reversion_transaction_id
           , segment1                                           , serial_number                                      , source_locat_code
           , source_locator_code                                , source_subinventory                                , status
           , tpa_control_log_id                                 , tpa_devolutions_control_id                         , tpa_receipt_control_id
           , tpa_remit_control_id                               , tpa_return_control_id                              , transaction_interface_id
           , trx_number
           ) VALUES
           ( rec_tpa_control_log.attribute_category             , rec_tpa_control_log.attribute1                     , rec_tpa_control_log.attribute10
           , rec_tpa_control_log.attribute11                    , rec_tpa_control_log.attribute12                    , rec_tpa_control_log.attribute13
           , rec_tpa_control_log.attribute14                    , rec_tpa_control_log.attribute15                    , rec_tpa_control_log.attribute16
           , rec_tpa_control_log.attribute17                    , rec_tpa_control_log.attribute18                    , rec_tpa_control_log.attribute19
           , rec_tpa_control_log.attribute2                     , rec_tpa_control_log.attribute20                    , rec_tpa_control_log.attribute3
           , rec_tpa_control_log.attribute4                     , rec_tpa_control_log.attribute5                     , rec_tpa_control_log.attribute6
           , rec_tpa_control_log.attribute7                     , rec_tpa_control_log.attribute8                     , rec_tpa_control_log.attribute9
           , rec_tpa_control_log.cancel_transaction_id          , rec_tpa_control_log.created_by                     , rec_tpa_control_log.creation_date
           , rec_tpa_control_log.customer_name                  , rec_tpa_control_log.customer_number                , rec_tpa_control_log.customer_trx_id
           , rec_tpa_control_log.customer_trx_line_id           , rec_tpa_control_log.devolution_transaction_id      , rec_tpa_control_log.invoice_number
           , rec_tpa_control_log.item_number                    , rec_tpa_control_log.last_update_date               , rec_tpa_control_log.last_updated_by
           , rec_tpa_control_log.last_update_login              , rec_tpa_control_log.line_number                    , rec_tpa_control_log.lot_number
           , rec_tpa_control_log.operation_id                   , rec_tpa_control_log.org_id                         , rec_tpa_control_log.process_description
           , rec_tpa_control_log.process_source                 , rec_tpa_control_log.process_status                 , rec_tpa_control_log.program_application_id
           , rec_tpa_control_log.program_id                     , rec_tpa_control_log.program_update_date            , rec_tpa_control_log.receipt_transaction_id
           , rec_tpa_control_log.request_id                     , rec_tpa_control_log.returned_transaction_id        , rec_tpa_control_log.reversion_transaction_id
           , rec_tpa_control_log.segment1                       , rec_tpa_control_log.serial_number                  , rec_tpa_control_log.source_locat_code
           , rec_tpa_control_log.source_locator_code            , rec_tpa_control_log.source_subinventory            , rec_tpa_control_log.status
           , rec_tpa_control_log.tpa_control_log_id             , rec_tpa_control_log.tpa_devolutions_control_id     , rec_tpa_control_log.tpa_receipt_control_id
           , rec_tpa_control_log.tpa_remit_control_id           , rec_tpa_control_log.tpa_return_control_id          , rec_tpa_control_log.transaction_interface_id
           , rec_tpa_control_log.trx_number
           ) ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_msg_retorno := 'TPA_CONTROL_LOG_P: '||SQLERRM ;
    END ;
    --
    msg_retorno := l_msg_retorno ;
    --
  END INSERT_TPA_CONTROL_LOG_P ;
  --
  PROCEDURE INSERT_TRANS_IFACE_P (rec_trans_iface IN mtl_transactions_interface%ROWTYPE, msg_retorno OUT NOCOPY VARCHAR2) IS
  l_msg_retorno  VARCHAR2(1000) := null;
  BEGIN
    --
    BEGIN
      --
      INSERT INTO mtl_transactions_interface
           ( accounting_class                                   , acct_period_id                                     , alternate_bom_designator
           , alternate_routing_designator                       , attribute_category                                 , attribute1
           , attribute10                                        , attribute11                                        , attribute12
           , attribute13                                        , attribute14                                        , attribute15
           , attribute2                                         , attribute3                                         , attribute4
           , attribute5                                         , attribute6                                         , attribute7
           , attribute8                                         , attribute9                                         , bom_revision
           , bom_revision_date                                  , build_sequence                                     , completion_transaction_id
           , containers                                         , content_lpn_id                                     , cost_group_id
           , cost_type_id                                       , created_by                                         , creation_date
           , currency_code                                      , currency_conversion_date                           , currency_conversion_rate
           , currency_conversion_type                           , customer_ship_id                                   , demand_class
           , demand_id                                          , demand_source_delivery                             , demand_source_header_id
           , demand_source_line                                 , department_id                                      , distribution_account_id
           , dsp_segment1                                       , dsp_segment10                                      , dsp_segment11
           , dsp_segment12                                      , dsp_segment13                                      , dsp_segment14
           , dsp_segment15                                      , dsp_segment16                                      , dsp_segment17
           , dsp_segment18                                      , dsp_segment19                                      , dsp_segment2
           , dsp_segment20                                      , dsp_segment21                                      , dsp_segment22
           , dsp_segment23                                      , dsp_segment24                                      , dsp_segment25
           , dsp_segment26                                      , dsp_segment27                                      , dsp_segment28
           , dsp_segment29                                      , dsp_segment3                                       , dsp_segment30
           , dsp_segment4                                       , dsp_segment5                                       , dsp_segment6
           , dsp_segment7                                       , dsp_segment8                                       , dsp_segment9
           , dst_segment1                                       , dst_segment10                                      , dst_segment11
           , dst_segment12                                      , dst_segment13                                      , dst_segment14
           , dst_segment15                                      , dst_segment16                                      , dst_segment17
           , dst_segment18                                      , dst_segment19                                      , dst_segment2
           , dst_segment20                                      , dst_segment21                                      , dst_segment22
           , dst_segment23                                      , dst_segment24                                      , dst_segment25
           , dst_segment26                                      , dst_segment27                                      , dst_segment28
           , dst_segment29                                      , dst_segment3                                       , dst_segment30
           , dst_segment4                                       , dst_segment5                                       , dst_segment6
           , dst_segment7                                       , dst_segment8                                       , dst_segment9
           , employee_code                                      , encumbrance_account                                , encumbrance_amount
           , end_item_unit_number                               , error_code                                         , error_explanation
           , expected_arrival_date                              , expenditure_type                                   , final_completion_flag
           , flow_schedule                                      , freight_code                                       , inventory_item
           , inventory_item_id                                  , item_segment1                                      , item_segment10
           , item_segment11                                     , item_segment12                                     , item_segment13
           , item_segment14                                     , item_segment15                                     , item_segment16
           , item_segment17                                     , item_segment18                                     , item_segment19
           , item_segment2                                      , item_segment20                                     , item_segment3
           , item_segment4                                      , item_segment5                                      , item_segment6
           , item_segment7                                      , item_segment8                                      , item_segment9
           , kanban_card_id                                     , last_update_date                                   , last_updated_by
           , last_update_login                                  , line_item_num                                      , locator_id
           , locator_name                                       , lock_flag                                          , loc_segment1
           , loc_segment10                                      , loc_segment11                                      , loc_segment12
           , loc_segment13                                      , loc_segment14                                      , loc_segment15
           , loc_segment16                                      , loc_segment17                                      , loc_segment18
           , loc_segment19                                      , loc_segment2                                       , loc_segment20
           , loc_segment3                                       , loc_segment4                                       , loc_segment5
           , loc_segment6                                       , loc_segment7                                       , loc_segment8
           , loc_segment9                                       , lpn_id                                             , material_account
           , material_expense_account                           , material_overhead_account                          , mcc_code
           , movement_id                                        , move_transaction_id                                , mrp_code
           , negative_req_flag                                  , new_average_cost                                   , operation_seq_num
           , organization_id                                    , organization_type                                  , org_cost_group_id
           , outside_processing_account                         , overcompletion_primary_qty                         , overcompletion_transaction_id
           , overcompletion_transaction_qty                     , overhead_account                                   , owning_organization_id
           , owning_tp_type                                     , pa_expenditure_org_id                              , parent_id
           , percentage_change                                  , picking_line_id                                    , planning_organization_id
           , planning_tp_type                                   , primary_quantity                                   , primary_switch
           , process_flag                                       , program_application_id                             , program_id
           , program_update_date                                , project_id                                         , qa_collection_id
           , rcv_transaction_id                                 , reason_id                                          , rebuild_activity_id
           , rebuild_item_id                                    , rebuild_job_name                                   , rebuild_serial_number
           , receiving_document                                 , relieve_high_level_rsv_flag                        , relieve_reservations_flag
           , repetitive_line_id                                 , representative_lot_number                          , request_id
           , required_flag                                      , requisition_distribution_id                        , requisition_line_id
           , reservation_quantity                               , resource_account                                   , revision
           , routing_revision                                   , routing_revision_date                              , scheduled_flag
           , scheduled_payback_date                             , schedule_group                                     , schedule_id
           , schedule_number                                    , schedule_update_code                               , secondary_transaction_quantity
           , secondary_uom_code                                 , setup_teardown_code                                , shipment_number
           , shippable_flag                                     , shipped_quantity                                   , ship_to_location_id
           , source_code                                        , source_header_id                                   , source_line_id
           , source_lot_number                                  , source_project_id                                  , source_task_id
           , subinventory_code                                  , substitution_item_id                               , substitution_type_id
           , task_id                                            , to_project_id                                      , to_task_id
           , transaction_action_id                              , transaction_batch_id                               , transaction_batch_seq
           , transaction_cost                                   , transaction_date
           --, transaction_group_id                             , transaction_group_seq                              -- Bug 30001408
           , transaction_header_id                              , transaction_interface_id
           , transaction_mode                                   , transaction_quantity                               , transaction_reference
           , transaction_sequence_id                            , transaction_source_id                              , transaction_source_name
           , transaction_source_type_id                         , transaction_type_id                                , transaction_uom
           , transfer_cost                                      , transfer_cost_group_id                             , transfer_locator
           , transfer_lpn_id                                    , transfer_organization                              , transfer_organization_type
           , transfer_owning_tp_type                            , transfer_percentage                                , transfer_planning_tp_type
           , transfer_price                                     , transfer_subinventory                              , transportation_account
           , transportation_cost                                , trx_source_delivery_id                             , trx_source_line_id
           , ussgl_transaction_code                             , validation_required                                , value_change
           , vendor_lot_number                                  , waybill_airbill                                    , wip_entity_type
           , wip_supply_type                                    , xfer_loc_segment1                                  , xfer_loc_segment10
           , xfer_loc_segment11                                 , xfer_loc_segment12                                 , xfer_loc_segment13
           , xfer_loc_segment14                                 , xfer_loc_segment15                                 , xfer_loc_segment16
           , xfer_loc_segment17                                 , xfer_loc_segment18                                 , xfer_loc_segment19
           , xfer_loc_segment2                                  , xfer_loc_segment20                                 , xfer_loc_segment3
           , xfer_loc_segment4                                  , xfer_loc_segment5                                  , xfer_loc_segment6
           , xfer_loc_segment7                                  , xfer_loc_segment8                                  , xfer_loc_segment9
           , xfr_owning_organization_id                         , xfr_planning_organization_id                       , xml_document_id
           ) VALUES
           ( rec_trans_iface.accounting_class                   , rec_trans_iface.acct_period_id                     , rec_trans_iface.alternate_bom_designator
           , rec_trans_iface.alternate_routing_designator       , rec_trans_iface.attribute_category                 , rec_trans_iface.attribute1
           , rec_trans_iface.attribute10                        , rec_trans_iface.attribute11                        , rec_trans_iface.attribute12
           , rec_trans_iface.attribute13                        , rec_trans_iface.attribute14                        , rec_trans_iface.attribute15
           , rec_trans_iface.attribute2                         , rec_trans_iface.attribute3                         , rec_trans_iface.attribute4
           , rec_trans_iface.attribute5                         , rec_trans_iface.attribute6                         , rec_trans_iface.attribute7
           , rec_trans_iface.attribute8                         , rec_trans_iface.attribute9                         , rec_trans_iface.bom_revision
           , rec_trans_iface.bom_revision_date                  , rec_trans_iface.build_sequence                     , rec_trans_iface.completion_transaction_id
           , rec_trans_iface.containers                         , rec_trans_iface.content_lpn_id                     , rec_trans_iface.cost_group_id
           , rec_trans_iface.cost_type_id                       , rec_trans_iface.created_by                         , rec_trans_iface.creation_date
           , rec_trans_iface.currency_code                      , rec_trans_iface.currency_conversion_date           , rec_trans_iface.currency_conversion_rate
           , rec_trans_iface.currency_conversion_type           , rec_trans_iface.customer_ship_id                   , rec_trans_iface.demand_class
           , rec_trans_iface.demand_id                          , rec_trans_iface.demand_source_delivery             , rec_trans_iface.demand_source_header_id
           , rec_trans_iface.demand_source_line                 , rec_trans_iface.department_id                      , rec_trans_iface.distribution_account_id
           , rec_trans_iface.dsp_segment1                       , rec_trans_iface.dsp_segment10                      , rec_trans_iface.dsp_segment11
           , rec_trans_iface.dsp_segment12                      , rec_trans_iface.dsp_segment13                      , rec_trans_iface.dsp_segment14
           , rec_trans_iface.dsp_segment15                      , rec_trans_iface.dsp_segment16                      , rec_trans_iface.dsp_segment17
           , rec_trans_iface.dsp_segment18                      , rec_trans_iface.dsp_segment19                      , rec_trans_iface.dsp_segment2
           , rec_trans_iface.dsp_segment20                      , rec_trans_iface.dsp_segment21                      , rec_trans_iface.dsp_segment22
           , rec_trans_iface.dsp_segment23                      , rec_trans_iface.dsp_segment24                      , rec_trans_iface.dsp_segment25
           , rec_trans_iface.dsp_segment26                      , rec_trans_iface.dsp_segment27                      , rec_trans_iface.dsp_segment28
           , rec_trans_iface.dsp_segment29                      , rec_trans_iface.dsp_segment3                       , rec_trans_iface.dsp_segment30
           , rec_trans_iface.dsp_segment4                       , rec_trans_iface.dsp_segment5                       , rec_trans_iface.dsp_segment6
           , rec_trans_iface.dsp_segment7                       , rec_trans_iface.dsp_segment8                       , rec_trans_iface.dsp_segment9
           , rec_trans_iface.dst_segment1                       , rec_trans_iface.dst_segment10                      , rec_trans_iface.dst_segment11
           , rec_trans_iface.dst_segment12                      , rec_trans_iface.dst_segment13                      , rec_trans_iface.dst_segment14
           , rec_trans_iface.dst_segment15                      , rec_trans_iface.dst_segment16                      , rec_trans_iface.dst_segment17
           , rec_trans_iface.dst_segment18                      , rec_trans_iface.dst_segment19                      , rec_trans_iface.dst_segment2
           , rec_trans_iface.dst_segment20                      , rec_trans_iface.dst_segment21                      , rec_trans_iface.dst_segment22
           , rec_trans_iface.dst_segment23                      , rec_trans_iface.dst_segment24                      , rec_trans_iface.dst_segment25
           , rec_trans_iface.dst_segment26                      , rec_trans_iface.dst_segment27                      , rec_trans_iface.dst_segment28
           , rec_trans_iface.dst_segment29                      , rec_trans_iface.dst_segment3                       , rec_trans_iface.dst_segment30
           , rec_trans_iface.dst_segment4                       , rec_trans_iface.dst_segment5                       , rec_trans_iface.dst_segment6
           , rec_trans_iface.dst_segment7                       , rec_trans_iface.dst_segment8                       , rec_trans_iface.dst_segment9
           , rec_trans_iface.employee_code                      , rec_trans_iface.encumbrance_account                , rec_trans_iface.encumbrance_amount
           , rec_trans_iface.end_item_unit_number               , rec_trans_iface.error_code                         , rec_trans_iface.error_explanation
           , rec_trans_iface.expected_arrival_date              , rec_trans_iface.expenditure_type                   , rec_trans_iface.final_completion_flag
           , rec_trans_iface.flow_schedule                      , rec_trans_iface.freight_code                       , rec_trans_iface.inventory_item
           , rec_trans_iface.inventory_item_id                  , rec_trans_iface.item_segment1                      , rec_trans_iface.item_segment10
           , rec_trans_iface.item_segment11                     , rec_trans_iface.item_segment12                     , rec_trans_iface.item_segment13
           , rec_trans_iface.item_segment14                     , rec_trans_iface.item_segment15                     , rec_trans_iface.item_segment16
           , rec_trans_iface.item_segment17                     , rec_trans_iface.item_segment18                     , rec_trans_iface.item_segment19
           , rec_trans_iface.item_segment2                      , rec_trans_iface.item_segment20                     , rec_trans_iface.item_segment3
           , rec_trans_iface.item_segment4                      , rec_trans_iface.item_segment5                      , rec_trans_iface.item_segment6
           , rec_trans_iface.item_segment7                      , rec_trans_iface.item_segment8                      , rec_trans_iface.item_segment9
           , rec_trans_iface.kanban_card_id                     , rec_trans_iface.last_update_date                   , rec_trans_iface.last_updated_by
           , rec_trans_iface.last_update_login                  , rec_trans_iface.line_item_num                      , rec_trans_iface.locator_id
           , rec_trans_iface.locator_name                       , rec_trans_iface.lock_flag                          , rec_trans_iface.loc_segment1
           , rec_trans_iface.loc_segment10                      , rec_trans_iface.loc_segment11                      , rec_trans_iface.loc_segment12
           , rec_trans_iface.loc_segment13                      , rec_trans_iface.loc_segment14                      , rec_trans_iface.loc_segment15
           , rec_trans_iface.loc_segment16                      , rec_trans_iface.loc_segment17                      , rec_trans_iface.loc_segment18
           , rec_trans_iface.loc_segment19                      , rec_trans_iface.loc_segment2                       , rec_trans_iface.loc_segment20
           , rec_trans_iface.loc_segment3                       , rec_trans_iface.loc_segment4                       , rec_trans_iface.loc_segment5
           , rec_trans_iface.loc_segment6                       , rec_trans_iface.loc_segment7                       , rec_trans_iface.loc_segment8
           , rec_trans_iface.loc_segment9                       , rec_trans_iface.lpn_id                             , rec_trans_iface.material_account
           , rec_trans_iface.material_expense_account           , rec_trans_iface.material_overhead_account          , rec_trans_iface.mcc_code
           , rec_trans_iface.movement_id                        , rec_trans_iface.move_transaction_id                , rec_trans_iface.mrp_code
           , rec_trans_iface.negative_req_flag                  , rec_trans_iface.new_average_cost                   , rec_trans_iface.operation_seq_num
           , rec_trans_iface.organization_id                    , rec_trans_iface.organization_type                  , rec_trans_iface.org_cost_group_id
           , rec_trans_iface.outside_processing_account         , rec_trans_iface.overcompletion_primary_qty         , rec_trans_iface.overcompletion_transaction_id
           , rec_trans_iface.overcompletion_transaction_qty     , rec_trans_iface.overhead_account                   , rec_trans_iface.owning_organization_id
           , rec_trans_iface.owning_tp_type                     , rec_trans_iface.pa_expenditure_org_id              , rec_trans_iface.parent_id
           , rec_trans_iface.percentage_change                  , rec_trans_iface.picking_line_id                    , rec_trans_iface.planning_organization_id
           , rec_trans_iface.planning_tp_type                   , rec_trans_iface.primary_quantity                   , rec_trans_iface.primary_switch
           , rec_trans_iface.process_flag                       , rec_trans_iface.program_application_id             , rec_trans_iface.program_id
           , rec_trans_iface.program_update_date                , rec_trans_iface.project_id                         , rec_trans_iface.qa_collection_id
           , rec_trans_iface.rcv_transaction_id                 , rec_trans_iface.reason_id                          , rec_trans_iface.rebuild_activity_id
           , rec_trans_iface.rebuild_item_id                    , rec_trans_iface.rebuild_job_name                   , rec_trans_iface.rebuild_serial_number
           , rec_trans_iface.receiving_document                 , rec_trans_iface.relieve_high_level_rsv_flag        , rec_trans_iface.relieve_reservations_flag
           , rec_trans_iface.repetitive_line_id                 , rec_trans_iface.representative_lot_number          , rec_trans_iface.request_id
           , rec_trans_iface.required_flag                      , rec_trans_iface.requisition_distribution_id        , rec_trans_iface.requisition_line_id
           , rec_trans_iface.reservation_quantity               , rec_trans_iface.resource_account                   , rec_trans_iface.revision
           , rec_trans_iface.routing_revision                   , rec_trans_iface.routing_revision_date              , rec_trans_iface.scheduled_flag
           , rec_trans_iface.scheduled_payback_date             , rec_trans_iface.schedule_group                     , rec_trans_iface.schedule_id
           , rec_trans_iface.schedule_number                    , rec_trans_iface.schedule_update_code               , rec_trans_iface.secondary_transaction_quantity
           , rec_trans_iface.secondary_uom_code                 , rec_trans_iface.setup_teardown_code                , rec_trans_iface.shipment_number
           , rec_trans_iface.shippable_flag                     , rec_trans_iface.shipped_quantity                   , rec_trans_iface.ship_to_location_id
           , rec_trans_iface.source_code                        , rec_trans_iface.source_header_id                   , rec_trans_iface.source_line_id
           , rec_trans_iface.source_lot_number                  , rec_trans_iface.source_project_id                  , rec_trans_iface.source_task_id
           , rec_trans_iface.subinventory_code                  , rec_trans_iface.substitution_item_id               , rec_trans_iface.substitution_type_id
           , rec_trans_iface.task_id                            , rec_trans_iface.to_project_id                      , rec_trans_iface.to_task_id
           , rec_trans_iface.transaction_action_id              , rec_trans_iface.transaction_batch_id               , rec_trans_iface.transaction_batch_seq
           , rec_trans_iface.transaction_cost                   , rec_trans_iface.transaction_date
           --, rec_trans_iface.transaction_group_id               , rec_trans_iface.transaction_group_seq              --Bug 30001408
           , rec_trans_iface.transaction_header_id              , rec_trans_iface.transaction_interface_id
           , rec_trans_iface.transaction_mode                   , rec_trans_iface.transaction_quantity               , rec_trans_iface.transaction_reference
           , rec_trans_iface.transaction_sequence_id            , rec_trans_iface.transaction_source_id              , rec_trans_iface.transaction_source_name
           , rec_trans_iface.transaction_source_type_id         , rec_trans_iface.transaction_type_id                , rec_trans_iface.transaction_uom
           , rec_trans_iface.transfer_cost                      , rec_trans_iface.transfer_cost_group_id             , rec_trans_iface.transfer_locator
           , rec_trans_iface.transfer_lpn_id                    , rec_trans_iface.transfer_organization              , rec_trans_iface.transfer_organization_type
           , rec_trans_iface.transfer_owning_tp_type            , rec_trans_iface.transfer_percentage                , rec_trans_iface.transfer_planning_tp_type
           , rec_trans_iface.transfer_price                     , rec_trans_iface.transfer_subinventory              , rec_trans_iface.transportation_account
           , rec_trans_iface.transportation_cost                , rec_trans_iface.trx_source_delivery_id             , rec_trans_iface.trx_source_line_id
           , rec_trans_iface.ussgl_transaction_code             , rec_trans_iface.validation_required                , rec_trans_iface.value_change
           , rec_trans_iface.vendor_lot_number                  , rec_trans_iface.waybill_airbill                    , rec_trans_iface.wip_entity_type
           , rec_trans_iface.wip_supply_type                    , rec_trans_iface.xfer_loc_segment1                  , rec_trans_iface.xfer_loc_segment10
           , rec_trans_iface.xfer_loc_segment11                 , rec_trans_iface.xfer_loc_segment12                 , rec_trans_iface.xfer_loc_segment13
           , rec_trans_iface.xfer_loc_segment14                 , rec_trans_iface.xfer_loc_segment15                 , rec_trans_iface.xfer_loc_segment16
           , rec_trans_iface.xfer_loc_segment17                 , rec_trans_iface.xfer_loc_segment18                 , rec_trans_iface.xfer_loc_segment19
           , rec_trans_iface.xfer_loc_segment2                  , rec_trans_iface.xfer_loc_segment20                 , rec_trans_iface.xfer_loc_segment3
           , rec_trans_iface.xfer_loc_segment4                  , rec_trans_iface.xfer_loc_segment5                  , rec_trans_iface.xfer_loc_segment6
           , rec_trans_iface.xfer_loc_segment7                  , rec_trans_iface.xfer_loc_segment8                  , rec_trans_iface.xfer_loc_segment9
           , rec_trans_iface.xfr_owning_organization_id         , rec_trans_iface.xfr_planning_organization_id       , rec_trans_iface.xml_document_id
           ) ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_msg_retorno := 'INSERT_TRANS_IFACE_P: '||SQLERRM ;
    END ;
    --
    msg_retorno := l_msg_retorno ;
    --
  END INSERT_TRANS_IFACE_P ;
  --
  PROCEDURE INSERT_TRANS_LOTS_IFACE_P (rec_trans_lots_iface IN mtl_transaction_lots_interface%ROWTYPE, msg_retorno OUT NOCOPY VARCHAR2) IS
  l_msg_retorno  VARCHAR2(1000) := null;
  BEGIN
    --
    BEGIN
      --
      INSERT INTO mtl_transaction_lots_interface
           ( age                                                     , attribute_category                                      , attribute1
           , attribute10                                             , attribute11                                             , attribute12
           , attribute13                                             , attribute14                                             , attribute15
           , attribute2                                              , attribute3                                              , attribute4
           , attribute5                                              , attribute6                                              , attribute7
           , attribute8                                              , attribute9                                              , best_by_date
           , c_attribute1                                            , c_attribute10                                           , c_attribute11
           , c_attribute12                                           , c_attribute13                                           , c_attribute14
           , c_attribute15                                           , c_attribute16                                           , c_attribute17
           , c_attribute18                                           , c_attribute19                                           , c_attribute2
           , c_attribute20                                           , c_attribute3                                            , c_attribute4
           , c_attribute5                                            , c_attribute6                                            , c_attribute7
           , c_attribute8                                            , c_attribute9                                            , change_date
           , color                                                   , created_by                                              , creation_date
           , curl_wrinkle_fold                                       , date_code                                               , d_attribute1
           , d_attribute10                                           , d_attribute2                                            , d_attribute3
           , d_attribute4                                            , d_attribute5                                            , d_attribute6
           , d_attribute7                                            , d_attribute8                                            , d_attribute9
           , description                                             , error_code                                              , expiration_action_code
           , expiration_action_date                                  , grade_code                                              , hold_date
           , item_size                                               , last_update_date                                        , last_updated_by
           , last_update_login                                       , length                                                  , length_uom
           , lot_attribute_category                                  , lot_expiration_date                                     , lot_number
           , maturity_date                                           , n_attribute1                                            , n_attribute10
           , n_attribute2                                            , n_attribute3                                            , n_attribute4
           , n_attribute5                                            , n_attribute6                                            , n_attribute7
           , n_attribute8                                            , n_attribute9                                            , origination_date
           , origination_type                                        , parent_item_id                                          , parent_lot_number
           , parent_object_id                                        , parent_object_id2                                       , parent_object_number
           , parent_object_number2                                   , parent_object_type                                      , parent_object_type2
           , place_of_origin                                         , primary_quantity                                        , process_flag
           , product_code                                            , product_transaction_id                                  , program_application_id
           , program_id                                              , program_update_date                                     , reason_code
           , reason_id                                               , recycled_content                                        , request_id
           , retest_date                                             , secondary_transaction_quantity                          , serial_transaction_temp_id
           , source_code                                             , source_line_id                                          , status_id
           , sublot_num                                              , supplier_lot_number                                     , territory_code
           , thickness                                               , thickness_uom                                           , transaction_interface_id
           , transaction_quantity                                    , vendor_id                                               , vendor_name
           , volume                                                  , volume_uom                                              , width
           , width_uom
           ) VALUES
           ( rec_trans_lots_iface.age                                , rec_trans_lots_iface.attribute_category                 , rec_trans_lots_iface.attribute1
           , rec_trans_lots_iface.attribute10                        , rec_trans_lots_iface.attribute11                        , rec_trans_lots_iface.attribute12
           , rec_trans_lots_iface.attribute13                        , rec_trans_lots_iface.attribute14                        , rec_trans_lots_iface.attribute15
           , rec_trans_lots_iface.attribute2                         , rec_trans_lots_iface.attribute3                         , rec_trans_lots_iface.attribute4
           , rec_trans_lots_iface.attribute5                         , rec_trans_lots_iface.attribute6                         , rec_trans_lots_iface.attribute7
           , rec_trans_lots_iface.attribute8                         , rec_trans_lots_iface.attribute9                         , rec_trans_lots_iface.best_by_date
           , rec_trans_lots_iface.c_attribute1                       , rec_trans_lots_iface.c_attribute10                      , rec_trans_lots_iface.c_attribute11
           , rec_trans_lots_iface.c_attribute12                      , rec_trans_lots_iface.c_attribute13                      , rec_trans_lots_iface.c_attribute14
           , rec_trans_lots_iface.c_attribute15                      , rec_trans_lots_iface.c_attribute16                      , rec_trans_lots_iface.c_attribute17
           , rec_trans_lots_iface.c_attribute18                      , rec_trans_lots_iface.c_attribute19                      , rec_trans_lots_iface.c_attribute2
           , rec_trans_lots_iface.c_attribute20                      , rec_trans_lots_iface.c_attribute3                       , rec_trans_lots_iface.c_attribute4
           , rec_trans_lots_iface.c_attribute5                       , rec_trans_lots_iface.c_attribute6                       , rec_trans_lots_iface.c_attribute7
           , rec_trans_lots_iface.c_attribute8                       , rec_trans_lots_iface.c_attribute9                       , rec_trans_lots_iface.change_date
           , rec_trans_lots_iface.color                              , rec_trans_lots_iface.created_by                         , rec_trans_lots_iface.creation_date
           , rec_trans_lots_iface.curl_wrinkle_fold                  , rec_trans_lots_iface.date_code                          , rec_trans_lots_iface.d_attribute1
           , rec_trans_lots_iface.d_attribute10                      , rec_trans_lots_iface.d_attribute2                       , rec_trans_lots_iface.d_attribute3
           , rec_trans_lots_iface.d_attribute4                       , rec_trans_lots_iface.d_attribute5                       , rec_trans_lots_iface.d_attribute6
           , rec_trans_lots_iface.d_attribute7                       , rec_trans_lots_iface.d_attribute8                       , rec_trans_lots_iface.d_attribute9
           , rec_trans_lots_iface.description                        , rec_trans_lots_iface.error_code                         , rec_trans_lots_iface.expiration_action_code
           , rec_trans_lots_iface.expiration_action_date             , rec_trans_lots_iface.grade_code                         , rec_trans_lots_iface.hold_date
           , rec_trans_lots_iface.item_size                          , rec_trans_lots_iface.last_update_date                   , rec_trans_lots_iface.last_updated_by
           , rec_trans_lots_iface.last_update_login                  , rec_trans_lots_iface.length                             , rec_trans_lots_iface.length_uom
           , rec_trans_lots_iface.lot_attribute_category             , rec_trans_lots_iface.lot_expiration_date                , rec_trans_lots_iface.lot_number
           , rec_trans_lots_iface.maturity_date                      , rec_trans_lots_iface.n_attribute1                       , rec_trans_lots_iface.n_attribute10
           , rec_trans_lots_iface.n_attribute2                       , rec_trans_lots_iface.n_attribute3                       , rec_trans_lots_iface.n_attribute4
           , rec_trans_lots_iface.n_attribute5                       , rec_trans_lots_iface.n_attribute6                       , rec_trans_lots_iface.n_attribute7
           , rec_trans_lots_iface.n_attribute8                       , rec_trans_lots_iface.n_attribute9                       , rec_trans_lots_iface.origination_date
           , rec_trans_lots_iface.origination_type                   , rec_trans_lots_iface.parent_item_id                     , rec_trans_lots_iface.parent_lot_number
           , rec_trans_lots_iface.parent_object_id                   , rec_trans_lots_iface.parent_object_id2                  , rec_trans_lots_iface.parent_object_number
           , rec_trans_lots_iface.parent_object_number2              , rec_trans_lots_iface.parent_object_type                 , rec_trans_lots_iface.parent_object_type2
           , rec_trans_lots_iface.place_of_origin                    , rec_trans_lots_iface.primary_quantity                   , rec_trans_lots_iface.process_flag
           , rec_trans_lots_iface.product_code                       , rec_trans_lots_iface.product_transaction_id             , rec_trans_lots_iface.program_application_id
           , rec_trans_lots_iface.program_id                         , rec_trans_lots_iface.program_update_date                , rec_trans_lots_iface.reason_code
           , rec_trans_lots_iface.reason_id                          , rec_trans_lots_iface.recycled_content                   , rec_trans_lots_iface.request_id
           , rec_trans_lots_iface.retest_date                        , rec_trans_lots_iface.secondary_transaction_quantity     , rec_trans_lots_iface.serial_transaction_temp_id
           , rec_trans_lots_iface.source_code                        , rec_trans_lots_iface.source_line_id                     , rec_trans_lots_iface.status_id
           , rec_trans_lots_iface.sublot_num                         , rec_trans_lots_iface.supplier_lot_number                , rec_trans_lots_iface.territory_code
           , rec_trans_lots_iface.thickness                          , rec_trans_lots_iface.thickness_uom                      , rec_trans_lots_iface.transaction_interface_id
           , rec_trans_lots_iface.transaction_quantity               , rec_trans_lots_iface.vendor_id                          , rec_trans_lots_iface.vendor_name
           , rec_trans_lots_iface.volume                             , rec_trans_lots_iface.volume_uom                         , rec_trans_lots_iface.width
           , rec_trans_lots_iface.width_uom
           ) ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_msg_retorno := 'INSERT_TRANS_LOTS_IFACE_P: '||SQLERRM ;
    END ;
    --
    msg_retorno := l_msg_retorno ;
    --
  END INSERT_TRANS_LOTS_IFACE_P ;
  --
  PROCEDURE INSERT_SERIAL_NUM_IFACE_P (rec_serial_num_iface IN mtl_serial_numbers_interface%ROWTYPE, msg_retorno OUT NOCOPY VARCHAR2) IS
  l_msg_retorno  VARCHAR2(1000) := null;
  BEGIN
    --
    BEGIN
      --
      INSERT INTO mtl_serial_numbers_interface
           ( attribute_category                                      , attribute1                                              , attribute10
           , attribute11                                             , attribute12                                             , attribute13
           , attribute14                                             , attribute15                                             , attribute2
           , attribute3                                              , attribute4                                              , attribute5
           , attribute6                                              , attribute7                                              , attribute8
           , attribute9                                              , c_attribute1                                            , c_attribute10
           , c_attribute11                                           , c_attribute12                                           , c_attribute13
           , c_attribute14                                           , c_attribute15                                           , c_attribute16
           , c_attribute17                                           , c_attribute18                                           , c_attribute19
           , c_attribute2                                            , c_attribute20                                           , c_attribute3
           , c_attribute4                                            , c_attribute5                                            , c_attribute6
           , c_attribute7                                            , c_attribute8                                            , c_attribute9
           , created_by                                              , creation_date                                           , cycles_since_mark
           , cycles_since_new                                        , cycles_since_overhaul                                   , cycles_since_repair
           , cycles_since_visit                                      , d_attribute1                                            , d_attribute10
           , d_attribute2                                                                                                      , d_attribute3
           , d_attribute4                                            , d_attribute5                                            , d_attribute6
           , d_attribute7                                            , d_attribute8                                            , d_attribute9
           , error_code                                              , fm_serial_number                                        , last_update_date
           , last_updated_by                                         , last_update_login                                       , n_attribute1
           , n_attribute10                                           , n_attribute2                                            , n_attribute3
           , n_attribute4                                            , n_attribute5                                            , n_attribute6
           , n_attribute7                                            , n_attribute8                                            , n_attribute9
           , number_of_repairs                                       , origination_date                                        , parent_item_id
           , parent_object_id                                        , parent_object_id2                                       , parent_object_number
           , parent_object_number2                                   , parent_object_type                                      , parent_object_type2
           , parent_serial_number                                    , process_flag                                            , product_code
           , product_transaction_id                                  , program_application_id                                  , program_id
           , program_update_date                                     , request_id                                              , serial_attribute_category
           , source_code                                             , source_line_id                                          , status_id
           , status_name                                             , territory_code                                          , time_since_mark
           , time_since_new                                          , time_since_overhaul                                     , time_since_repair
           , time_since_visit                                        , to_serial_number                                        , transaction_interface_id
           , vendor_lot_number                                       , vendor_serial_number
           ) VALUES
           ( rec_serial_num_iface.attribute_category                 , rec_serial_num_iface.attribute1                         , rec_serial_num_iface.attribute10
           , rec_serial_num_iface.attribute11                        , rec_serial_num_iface.attribute12                        , rec_serial_num_iface.attribute13
           , rec_serial_num_iface.attribute14                        , rec_serial_num_iface.attribute15                        , rec_serial_num_iface.attribute2
           , rec_serial_num_iface.attribute3                         , rec_serial_num_iface.attribute4                         , rec_serial_num_iface.attribute5
           , rec_serial_num_iface.attribute6                         , rec_serial_num_iface.attribute7                         , rec_serial_num_iface.attribute8
           , rec_serial_num_iface.attribute9                         , rec_serial_num_iface.c_attribute1                       , rec_serial_num_iface.c_attribute10
           , rec_serial_num_iface.c_attribute11                      , rec_serial_num_iface.c_attribute12                      , rec_serial_num_iface.c_attribute13
           , rec_serial_num_iface.c_attribute14                      , rec_serial_num_iface.c_attribute15                      , rec_serial_num_iface.c_attribute16
           , rec_serial_num_iface.c_attribute17                      , rec_serial_num_iface.c_attribute18                      , rec_serial_num_iface.c_attribute19
           , rec_serial_num_iface.c_attribute2                       , rec_serial_num_iface.c_attribute20                      , rec_serial_num_iface.c_attribute3
           , rec_serial_num_iface.c_attribute4                       , rec_serial_num_iface.c_attribute5                       , rec_serial_num_iface.c_attribute6
           , rec_serial_num_iface.c_attribute7                       , rec_serial_num_iface.c_attribute8                       , rec_serial_num_iface.c_attribute9
           , rec_serial_num_iface.created_by                         , rec_serial_num_iface.creation_date                      , rec_serial_num_iface.cycles_since_mark
           , rec_serial_num_iface.cycles_since_new                   , rec_serial_num_iface.cycles_since_overhaul              , rec_serial_num_iface.cycles_since_repair
           , rec_serial_num_iface.cycles_since_visit                 , rec_serial_num_iface.d_attribute1                       , rec_serial_num_iface.d_attribute10
           , rec_serial_num_iface.d_attribute2                                                                                 , rec_serial_num_iface.d_attribute3
           , rec_serial_num_iface.d_attribute4                       , rec_serial_num_iface.d_attribute5                       , rec_serial_num_iface.d_attribute6
           , rec_serial_num_iface.d_attribute7                       , rec_serial_num_iface.d_attribute8                       , rec_serial_num_iface.d_attribute9
           , rec_serial_num_iface.error_code                         , rec_serial_num_iface.fm_serial_number                   , rec_serial_num_iface.last_update_date
           , rec_serial_num_iface.last_updated_by                    , rec_serial_num_iface.last_update_login                  , rec_serial_num_iface.n_attribute1
           , rec_serial_num_iface.n_attribute10                      , rec_serial_num_iface.n_attribute2                       , rec_serial_num_iface.n_attribute3
           , rec_serial_num_iface.n_attribute4                       , rec_serial_num_iface.n_attribute5                       , rec_serial_num_iface.n_attribute6
           , rec_serial_num_iface.n_attribute7                       , rec_serial_num_iface.n_attribute8                       , rec_serial_num_iface.n_attribute9
           , rec_serial_num_iface.number_of_repairs                  , rec_serial_num_iface.origination_date                   , rec_serial_num_iface.parent_item_id
           , rec_serial_num_iface.parent_object_id                   , rec_serial_num_iface.parent_object_id2                  , rec_serial_num_iface.parent_object_number
           , rec_serial_num_iface.parent_object_number2              , rec_serial_num_iface.parent_object_type                 , rec_serial_num_iface.parent_object_type2
           , rec_serial_num_iface.parent_serial_number               , rec_serial_num_iface.process_flag                       , rec_serial_num_iface.product_code
           , rec_serial_num_iface.product_transaction_id             , rec_serial_num_iface.program_application_id             , rec_serial_num_iface.program_id
           , rec_serial_num_iface.program_update_date                , rec_serial_num_iface.request_id                         , rec_serial_num_iface.serial_attribute_category
           , rec_serial_num_iface.source_code                        , rec_serial_num_iface.source_line_id                     , rec_serial_num_iface.status_id
           , rec_serial_num_iface.status_name                        , rec_serial_num_iface.territory_code                     , rec_serial_num_iface.time_since_mark
           , rec_serial_num_iface.time_since_new                     , rec_serial_num_iface.time_since_overhaul                , rec_serial_num_iface.time_since_repair
           , rec_serial_num_iface.time_since_visit                   , rec_serial_num_iface.to_serial_number                   , rec_serial_num_iface.transaction_interface_id
           , rec_serial_num_iface.vendor_lot_number                  , rec_serial_num_iface.vendor_serial_number
           ) ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_msg_retorno := 'INSERT_SERIAL_NUM_IFACE_P: '||SQLERRM ;
    END ;
    --
    msg_retorno := l_msg_retorno ;
    --
  END INSERT_SERIAL_NUM_IFACE_P ;
  --
  procedure show_log(p_vmessage in varchar2) is
  begin
    dbms_output.put_line(p_vmessage);
  end show_log;
  --
  PROCEDURE insert_log_p ( p_org_id                     IN cll_f513_tpa_control_log.org_id                     %TYPE
                         , p_customer_number            IN cll_f513_tpa_control_log.customer_number            %TYPE
                         , p_customer_name              IN cll_f513_tpa_control_log.customer_name              %TYPE
                         , p_trx_number                 IN cll_f513_tpa_control_log.trx_number                 %TYPE
                         , p_line_number                IN cll_f513_tpa_control_log.line_number                %TYPE
                         , p_lot_number                 IN cll_f513_tpa_control_log.lot_number                 %TYPE
                         , p_serial_number              IN cll_f513_tpa_control_log.serial_number              %TYPE
                         , p_process_status             IN cll_f513_tpa_control_log.process_status             %TYPE
                         , p_process_description        IN cll_f513_tpa_control_log.process_description        %TYPE
                         , p_segment1                   IN cll_f513_tpa_control_log.segment1                   %TYPE
                         , p_source_subinventory        IN cll_f513_tpa_control_log.source_subinventory        %TYPE
                         , p_source_locator_id          IN mtl_item_locations.inventory_location_id            %TYPE
                         , p_operation_id               IN cll_f513_tpa_control_log.operation_id               %TYPE
                         , p_invoice_number             IN cll_f513_tpa_control_log.invoice_number             %TYPE
                         , p_item_number                IN cll_f513_tpa_control_log.item_number                %TYPE
                         , p_tpa_receipt_control_id     IN cll_f513_tpa_control_log.tpa_receipt_control_id     %TYPE
                         , p_receipt_transaction_id     IN cll_f513_tpa_control_log.receipt_transaction_id     %TYPE
                         , p_tpa_devolutions_control_id IN cll_f513_tpa_control_log.tpa_devolutions_control_id %TYPE
                         , p_devolution_transaction_id  IN cll_f513_tpa_control_log.devolution_transaction_id  %TYPE
                         ) IS

  l_nApplication_Id      NUMBER := FND_PROFILE.VALUE('RESP_APPL_ID') ;
  l_nConcProgram_Id      NUMBER ;
  l_vMensagem            VARCHAR2(4000) ;
  l_vLocator             VARCHAR2(120) ;
  --
  BEGIN
    --
    BEGIN
      --
      SELECT concurrent_program_id
        INTO l_nConcProgram_Id
        FROM apps.fnd_concurrent_programs
       WHERE concurrent_program_name = 'CLL_F513_TPA_DEV_PROCESS' ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_nConcProgram_Id := NULL ;
    END ;
    --
    BEGIN
      --
      SELECT        mil.segment1
          || DECODE(mil.segment2 , NULL, NULL, '.' || mil.segment2 )
          || DECODE(mil.segment3 , NULL, NULL, '.' || mil.segment3 )
          || DECODE(mil.segment4 , NULL, NULL, '.' || mil.segment4 )
          || DECODE(mil.segment5 , NULL, NULL, '.' || mil.segment5 )
          || DECODE(mil.segment6 , NULL, NULL, '.' || mil.segment6 )
          || DECODE(mil.segment7 , NULL, NULL, '.' || mil.segment7 )
          || DECODE(mil.segment8 , NULL, NULL, '.' || mil.segment8 )
          || DECODE(mil.segment9 , NULL, NULL, '.' || mil.segment9 )
          || DECODE(mil.segment10, NULL, NULL, '.' || mil.segment10)
          || DECODE(mil.segment11, NULL, NULL, '.' || mil.segment11)
          || DECODE(mil.segment12, NULL, NULL, '.' || mil.segment12)
          || DECODE(mil.segment13, NULL, NULL, '.' || mil.segment13)
          || DECODE(mil.segment14, NULL, NULL, '.' || mil.segment14)
          || DECODE(mil.segment15, NULL, NULL, '.' || mil.segment15)
          || DECODE(mil.segment16, NULL, NULL, '.' || mil.segment16)
          || DECODE(mil.segment17, NULL, NULL, '.' || mil.segment17)
          || DECODE(mil.segment18, NULL, NULL, '.' || mil.segment18)
          || DECODE(mil.segment19, NULL, NULL, '.' || mil.segment19)
          || DECODE(mil.segment20, NULL, NULL, '.' || mil.segment20) locator_code
        INTO l_vLocator
        FROM mtl_item_locations mil
       WHERE inventory_location_id = p_source_locator_id ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_vLocator := NULL ;
    END ;
    --
    -- BUG 29625111 - Start
    g_rec_tpa_control_log := g_crec_tpa_control_log ;
    --
    g_rec_tpa_control_log.tpa_control_log_id         := cll_f513_tpa_control_log_s.NEXTVAL ;
    g_rec_tpa_control_log.org_id                     := p_org_id ;
    g_rec_tpa_control_log.customer_number            := p_customer_number ;
    g_rec_tpa_control_log.customer_name              := p_customer_name ;
    g_rec_tpa_control_log.trx_number                 := p_trx_number ;
    g_rec_tpa_control_log.line_number                := p_line_number ;
    g_rec_tpa_control_log.lot_number                 := p_lot_number ;
    g_rec_tpa_control_log.serial_number              := p_serial_number ;
    g_rec_tpa_control_log.process_status             := p_process_status ;
    g_rec_tpa_control_log.process_description        := p_process_description ;
    g_rec_tpa_control_log.segment1                   := p_segment1 ;
    g_rec_tpa_control_log.source_subinventory        := p_source_subinventory ;
    g_rec_tpa_control_log.operation_id               := p_operation_id ;
    g_rec_tpa_control_log.invoice_number             := p_invoice_number ;
    g_rec_tpa_control_log.item_number                := p_item_number ;
    g_rec_tpa_control_log.tpa_receipt_control_id     := p_tpa_receipt_control_id ;
    g_rec_tpa_control_log.receipt_transaction_id     := p_receipt_transaction_id ;
    g_rec_tpa_control_log.tpa_devolutions_control_id := p_tpa_devolutions_control_id ;
    g_rec_tpa_control_log.devolution_transaction_id  := p_devolution_transaction_id ;
    g_rec_tpa_control_log.process_source             := 'CLL_F189' ;
    g_rec_tpa_control_log.created_by                 := fnd_global.user_id ;
    g_rec_tpa_control_log.creation_date              := SYSDATE ;
    g_rec_tpa_control_log.last_update_date           := SYSDATE ;
    g_rec_tpa_control_log.last_updated_by            := fnd_global.user_id ;
    g_rec_tpa_control_log.last_update_login          := fnd_global.login_id ;
    g_rec_tpa_control_log.request_id                 := fnd_global.conc_request_id ;
    g_rec_tpa_control_log.program_application_id     := l_nApplication_Id ;
    g_rec_tpa_control_log.program_id                 := l_nConcProgram_Id ;
    g_rec_tpa_control_log.program_update_date        := SYSDATE ;
    g_rec_tpa_control_log.source_locat_code          := l_vLocator ;
    g_rec_tpa_control_log.status                     := p_process_status ;
    --
    IF p_process_status <> 'UNSUCCESSFUL' THEN
        g_rec_tpa_control_log.status                 := 'DEVOLVED' ;
    END IF ;
    --
    g_msg_retorno                                    := NULL ;
    --
    INSERT_TPA_CONTROL_LOG_P ( g_rec_tpa_control_log, g_msg_retorno ) ;
    --
    IF g_msg_retorno IS NOT NULL THEN
      SHOW_LOG( g_msg_retorno ) ;
    END IF ;
    --
    -- BUG 29625111 - End
    --
  END insert_log_p ;
  --
  PROCEDURE execute_process_p ( --errbuf             OUT NOCOPY VARCHAR2,
                              -- retcode            OUT NOCOPY NUMBER,
                                p_date_from         IN VARCHAR2,
                                p_date_to           IN VARCHAR2,
                                p_org_id            IN NUMBER,
                                p_tpa_dev_ctrl_id   IN NUMBER DEFAULT NULL -- Enh 29553257
                              ) IS

  --
  l_vCustomer_Name         hz_parties.party_name                         %TYPE ;
  l_vCustomer_Number       hz_cust_accounts.account_number               %TYPE ;
  l_vDocument_Number       hz_cust_acct_sites_all.global_attribute1      %TYPE ;
  l_nProgram_Appl_Id       fnd_concurrent_programs.application_id        %TYPE ;
  l_nProgram_Id            fnd_concurrent_programs.concurrent_program_id %TYPE ;
  l_vResult_Adjust         BOOLEAN := TRUE;
  l_vErro_Insert           VARCHAR2(01) ;
  l_vStatus                VARCHAR2(12) ;
  l_vOperation_Status      VARCHAR2(20) ;
  l_vOperation_Ant         VARCHAR2(25) ;
  l_vOrganization_Ant      VARCHAR2(25) ;
  l_vMensagem              VARCHAR2(4000) ;
  l_vError_Code            VARCHAR2(4000) ;
  l_vError_Explanation     VARCHAR2(4000) ;
  l_vMsg_Receipt           VARCHAR2(4000) ;
  l_vMsg_Devolution        VARCHAR2(4000) ;
  l_nTimeout               NUMBER := NULL ;
  l_nTotal_Iface           NUMBER ;
  l_nTotal_Batch           NUMBER ;
  l_nTotal_Serial          NUMBER ;
  l_nTotal_Error           NUMBER ;
  l_nRemaining_Balance     NUMBER ;
  l_nAdjust_id             NUMBER ;
  l_nSerial_Trans_Tmp_Id   NUMBER ;
  l_dDate_From             DATE ;
  l_dDate_To               DATE ;
  --
  CURSOR c_invoices ( pc_org_id          IN NUMBER
                    , pc_date_from       IN DATE
                    , pc_date_to         IN DATE
                    , pc_tpa_dev_ctrl_id IN NUMBER -- Enh 29553257
                    )  IS
    SELECT rcta.org_id                         org_id
         , rcta.customer_trx_id                customer_trx_id
         , rctla.customer_trx_line_id          customer_trx_line_id
         , rctla.interface_line_attribute1     devolution_operation_id
         , rcta.cust_trx_type_id               cust_trx_type_id
         , rcta.trx_number                     invoice_number
         , rcta.trx_date                       invoice_date
         , jbe.occurrence_date                 sefaz_authorization_date
         , rcta.ship_to_site_use_id            site_use_id
         , rctla.interface_line_context        source
         , rctla.interface_line_attribute2     organizationid
         , rctla.interface_line_attribute3     devolution_invoice_id
         , rctla.interface_line_attribute4     devolution_invoice_line_id
         , rctla.inventory_item_id             inventory_item_id
         , ctdc.tpa_devolutions_control_id     tpa_devolutions_control_id
         , ctdc.item_uom_code                  item_uom_code
         , rctla.uom_code                      uom_code
         , ctdc.devolution_quantity            devolution_quantity
         , ctdc.subinventory                   subinventory
         , ctdc.devolution_item_number         item_number
         , ctdc.locator_id                     locator_id
         , ctdc.parent_lot_number              parent_lot_number
         , ctdc.lot_number                     lot_number
         , ctdc.expiration_date                expiration_date
         , ctdc.serial_number                  serial_number
         , ctdc.devolution_account_id          devolution_account_id
         , ctdc.symbolic_devolution_flag       symbolic_devolution_flag
         , ctrc.tpa_receipts_control_id        tpa_receipts_control_id
         , ctrc.receipt_transaction_id         receipt_transaction_id
         , ctrc.remaining_balance              remaining_balance
         , rctla.line_number                   line_number
         , rctla.description                   description
         , rctla.quantity_invoiced             quantity_invoiced
         , rctla.warehouse_id                  organization_id
         , ccn.stockable_flag                  stockable_flag
         , msi.segment1                        segment1
         , msi.lot_control_code                lot_control_code
         , msi.serial_number_control_code      serial_number_control_code
         , ccn.devolution_transaction_type_id  devolution_transaction_type_id
         --Enh 28431410 - Start
         --, mtt.transaction_action_id           transaction_action_id
         , DECODE(ccn.devolution_transaction_type_id
                 ,NULL
                 ,NULL
                 ,mtt.transaction_action_id
                 )
         --Enh 28431410 - End
         , ood.organization_code               organization_code
         -- Enh 28431410 - Start
         -- lote
         , NULL                                 lot_attribute_category
         , NULL                                 lot_c_attribute1
         , NULL                                 lot_c_attribute2
         , NULL                                 lot_c_attribute3
         , NULL                                 lot_c_attribute4
         , NULL                                 lot_c_attribute5
         , NULL                                 lot_c_attribute6
         , NULL                                 lot_c_attribute7
         , NULL                                 lot_c_attribute8
         , NULL                                 lot_c_attribute9
         , NULL                                 lot_c_attribute10
         , NULL                                 lot_c_attribute11
         , NULL                                 lot_c_attribute12
         , NULL                                 lot_c_attribute13
         , NULL                                 lot_c_attribute14
         , NULL                                 lot_c_attribute15
         , NULL                                 lot_c_attribute16
         , NULL                                 lot_c_attribute17
         , NULL                                 lot_c_attribute18
         , NULL                                 lot_c_attribute19
         , NULL                                 lot_c_attribute20
         , NULL                                 lot_d_attribute1
         , NULL                                 lot_d_attribute2
         , NULL                                 lot_d_attribute3
         , NULL                                 lot_d_attribute4
         , NULL                                 lot_d_attribute5
         , NULL                                 lot_d_attribute6
         , NULL                                 lot_d_attribute7
         , NULL                                 lot_d_attribute8
         , NULL                                 lot_d_attribute9
         , NULL                                 lot_d_attribute10
         , NULL                                 lot_n_attribute1
         , NULL                                 lot_n_attribute2
         , NULL                                 lot_n_attribute3
         , NULL                                 lot_n_attribute4
         , NULL                                 lot_n_attribute5
         , NULL                                 lot_n_attribute6
         , NULL                                 lot_n_attribute7
         , NULL                                 lot_n_attribute8
         , NULL                                 lot_n_attribute9
         , NULL                                 lot_n_attribute10
         --
         , NULL                                 attribute_category_lot
         , NULL                                 attribute1_lot
         , NULL                                 attribute2_lot
         , NULL                                 attribute3_lot
         , NULL                                 attribute4_lot
         , NULL                                 attribute5_lot
         , NULL                                 attribute6_lot
         , NULL                                 attribute7_lot
         , NULL                                 attribute8_lot
         , NULL                                 attribute9_lot
         , NULL                                 attribute10_lot
         , NULL                                 attribute11_lot
         , NULL                                 attribute12_lot
         , NULL                                 attribute13_lot
         , NULL                                 attribute14_lot
         , NULL                                 attribute15_lot
         -- serie
         , NULL                                serial_attribute_category
         , NULL                                serial_c_attribute1
         , NULL                                serial_c_attribute2
         , NULL                                serial_c_attribute3
         , NULL                                serial_c_attribute4
         , NULL                                serial_c_attribute5
         , NULL                                serial_c_attribute6
         , NULL                                serial_c_attribute7
         , NULL                                serial_c_attribute8
         , NULL                                serial_c_attribute9
         , NULL                                serial_c_attribute10
         , NULL                                serial_c_attribute11
         , NULL                                serial_c_attribute12
         , NULL                                serial_c_attribute13
         , NULL                                serial_c_attribute14
         , NULL                                serial_c_attribute15
         , NULL                                serial_c_attribute16
         , NULL                                serial_c_attribute17
         , NULL                                serial_c_attribute18
         , NULL                                serial_c_attribute19
         , NULL                                serial_c_attribute20
         , NULL                                serial_d_attribute1
         , NULL                                serial_d_attribute2
         , NULL                                serial_d_attribute3
         , NULL                                serial_d_attribute4
         , NULL                                serial_d_attribute5
         , NULL                                serial_d_attribute6
         , NULL                                serial_d_attribute7
         , NULL                                serial_d_attribute8
         , NULL                                serial_d_attribute9
         , NULL                                serial_d_attribute10
         , NULL                                serial_n_attribute1
         , NULL                                serial_n_attribute2
         , NULL                                serial_n_attribute3
         , NULL                                serial_n_attribute4
         , NULL                                serial_n_attribute5
         , NULL                                serial_n_attribute6
         , NULL                                serial_n_attribute7
         , NULL                                serial_n_attribute8
         , NULL                                serial_n_attribute9
         , NULL                                serial_n_attribute10
         --
         , NULL                                attribute_category_serie
         , NULL                                attribute1_serie
         , NULL                                attribute2_serie
         , NULL                                attribute3_serie
         , NULL                                attribute4_serie
         , NULL                                attribute5_serie
         , NULL                                attribute6_serie
         , NULL                                attribute7_serie
         , NULL                                attribute8_serie
         , NULL                                attribute9_serie
         , NULL                                attribute10_serie
         , NULL                                attribute11_serie
         , NULL                                attribute12_serie
         , NULL                                attribute13_serie
         , NULL                                attribute14_serie
         , NULL                                attribute15_serie
         -- Enh 28431410 - End
      FROM apps.jl_br_customer_trx_exts             jbcte
         , apps.jl_br_eilog                         jbe
         , apps.ra_customer_trx_all                 rcta
         , apps.ra_customer_trx_lines_all           rctla
         , apps.cll_f513_cust_network               ccn
         , apps.cll_f513_tpa_receipts_control       ctrc
         , apps.mtl_system_items_b                  msi
         , apps.cll_f513_tpa_devolutions_ctrl       ctdc
         , apps.mtl_transaction_types               mtt
         , apps.org_organization_definitions        ood
       WHERE rcta.org_id                       = pc_org_id
         AND rcta.status_trx                   = 'OP'
         AND NVL(ccn.inactive_flag, 'N')       = 'N'
         AND rcta.org_id                       = ccn.operating_unit
         AND ctdc.organization_id              = msi.organization_id
         AND ctdc.inventory_item_id            = msi.inventory_item_id
         AND mtt.transaction_type_id           = ccn.devolution_transaction_type_id
         AND ood.organization_id               = ctdc.organization_id
         AND ccn.stockable_flag                = 'N'
         AND ccn.source_type                   = 'RI'
         AND ( ctrc.cfo_id                     = ccn.in_state_cfop_id
          OR ctrc.cfo_id                       = ccn.out_state_cfop_id )
         AND ctrc.utilization_id               = ccn.utilization_id
         AND ctdc.tpa_receipts_control_id      = ctrc.tpa_receipts_control_id
         AND rctla.interface_line_attribute4   = ctdc.devolution_invoice_line_id
         AND rctla.interface_line_attribute3   = ctdc.devolution_invoice_id
         AND rctla.interface_line_attribute2   = ctdc.organization_id
         AND rctla.interface_line_attribute1   = ctdc.devolution_operation_id
         AND rctla.interface_line_context      = 'CLL F189 INTEGRATED RCV'
         AND rctla.line_type                   = 'LINE'
         AND rcta.customer_trx_id              = rctla.customer_trx_id
         AND jbcte.electronic_inv_status       = jbe.electronic_inv_status
         AND jbcte.customer_trx_id             = jbe.customer_trx_id
         --
         -- Bug 32581652 - begin
         AND jbe.occurrence_id IN (SELECT MIN(jbe2.occurrence_id)
                                     FROM apps.jl_br_eilog                   jbe2
                                    WHERE jbe2.customer_trx_id       = jbcte.customer_trx_id
                                      AND jbe2.electronic_inv_status = '2'
                                )
         -- Bug 32581652 - end
         --
         AND jbcte.customer_trx_id             = rcta.customer_trx_id
         AND jbcte.electronic_inv_status       = '2'
         AND NVL(ctdc.devolution_status, 'x') <> 'COMPLETE'
         AND TRUNC(jbe.occurrence_date)        BETWEEN TRUNC(pc_date_from)
                                                   AND TRUNC(pc_date_to)
         AND ctdc.tpa_devolutions_control_id   = NVL(pc_tpa_dev_ctrl_id, ctdc.tpa_devolutions_control_id) -- Enh 29553257
    --
    UNION
    SELECT rcta.org_id                         org_id
         , rcta.customer_trx_id                customer_trx_id
         , rctla.customer_trx_line_id          customer_trx_line_id
         , rctla.interface_line_attribute1     devolution_operation_id
         , rcta.cust_trx_type_id               cust_trx_type_id
         , rcta.trx_number                     invoice_number
         , rcta.trx_date                       invoice_date
         , jbe.occurrence_date                 sefaz_authorization_date
         , rcta.ship_to_site_use_id            site_use_id
         , rctla.interface_line_context        source
         , rctla.interface_line_attribute2     organizationid
         , rctla.interface_line_attribute3     devolution_invoice_id
         , rctla.interface_line_attribute4     devolution_invoice_line_id
         , rctla.inventory_item_id             inventory_item_id
         , ctdc.tpa_devolutions_control_id     tpa_devolutions_control_id
         , ctdc.item_uom_code                  item_uom_code
         , rctla.uom_code                      uom_code
         , ctdc.devolution_quantity            devolution_quantity
         , ctdc.subinventory                   subinventory
         , ctdc.devolution_item_number         item_number
         , ctdc.locator_id                     locator_id
         , ctdc.parent_lot_number              parent_lot_number
         , ctdc.lot_number                     lot_number
         , ctdc.expiration_date                expiration_date
         , ctdc.serial_number                  serial_number
         , ctdc.devolution_account_id          devolution_account_id
         , ctdc.symbolic_devolution_flag       symbolic_devolution_flag
         , ctrc.tpa_receipts_control_id        tpa_receipts_control_id
         , ctrc.receipt_transaction_id         receipt_transaction_id
         , ctrc.remaining_balance              remaining_balance
         , rctla.line_number                   line_number
         , rctla.description                   description
         , rctla.quantity_invoiced             quantity_invoiced
         , rctla.warehouse_id                  organization_id
         , ccn.stockable_flag                  stockable_flag
         , msi.segment1                        segment1
         , msi.lot_control_code                lot_control_code
         , msi.serial_number_control_code      serial_number_control_code
         , ccn.devolution_transaction_type_id  devolution_transaction_type_id
         --Enh 28431410 - Start
         --, mtt.transaction_action_id           transaction_action_id
         , DECODE(ccn.devolution_transaction_type_id
                 ,NULL
                 ,NULL
                 ,mtt.transaction_action_id
                 )
         --Enh 28431410 - End
         , ood.organization_code               organization_code
         -- Enh 28431410 - Start
         -- lote
         , mln.lot_attribute_category
         , mln.c_attribute1                    lot_c_attribute1
         , mln.c_attribute2                    lot_c_attribute2
         , mln.c_attribute3                    lot_c_attribute3
         , mln.c_attribute4                    lot_c_attribute4
         , mln.c_attribute5                    lot_c_attribute5
         , mln.c_attribute6                    lot_c_attribute6
         , mln.c_attribute7                    lot_c_attribute7
         , mln.c_attribute8                    lot_c_attribute8
         , mln.c_attribute9                    lot_c_attribute9
         , mln.c_attribute10                   lot_c_attribute10
         , mln.c_attribute11                   lot_c_attribute11
         , mln.c_attribute12                   lot_c_attribute12
         , mln.c_attribute13                   lot_c_attribute13
         , mln.c_attribute14                   lot_c_attribute14
         , mln.c_attribute15                   lot_c_attribute15
         , mln.c_attribute16                   lot_c_attribute16
         , mln.c_attribute17                   lot_c_attribute17
         , mln.c_attribute18                   lot_c_attribute18
         , mln.c_attribute19                   lot_c_attribute19
         , mln.c_attribute20                   lot_c_attribute20
         , mln.d_attribute1                    lot_d_attribute1
         , mln.d_attribute2                    lot_d_attribute2
         , mln.d_attribute3                    lot_d_attribute3
         , mln.d_attribute4                    lot_d_attribute4
         , mln.d_attribute5                    lot_d_attribute5
         , mln.d_attribute6                    lot_d_attribute6
         , mln.d_attribute7                    lot_d_attribute7
         , mln.d_attribute8                    lot_d_attribute8
         , mln.d_attribute9                    lot_d_attribute9
         , mln.d_attribute10                   lot_d_attribute10
         , mln.n_attribute1                    lot_n_attribute1
         , mln.n_attribute2                    lot_n_attribute2
         , mln.n_attribute3                    lot_n_attribute3
         , mln.n_attribute4                    lot_n_attribute4
         , mln.n_attribute5                    lot_n_attribute5
         , mln.n_attribute6                    lot_n_attribute6
         , mln.n_attribute7                    lot_n_attribute7
         , mln.n_attribute8                    lot_n_attribute8
         , mln.n_attribute9                    lot_n_attribute9
         , mln.n_attribute10                   lot_n_attribute10
         --
         , mln.attribute_category              attribute_category_lot
         , mln.attribute1                      attribute1_lot
         , mln.attribute2                      attribute2_lot
         , mln.attribute3                      attribute3_lot
         , mln.attribute4                      attribute4_lot
         , mln.attribute5                      attribute5_lot
         , mln.attribute6                      attribute6_lot
         , mln.attribute7                      attribute7_lot
         , mln.attribute8                      attribute8_lot
         , mln.attribute9                      attribute9_lot
         , mln.attribute10                     attribute10_lot
         , mln.attribute11                     attribute11_lot
         , mln.attribute12                     attribute12_lot
         , mln.attribute13                     attribute13_lot
         , mln.attribute14                     attribute14_lot
         , mln.attribute15                     attribute15_lot
         -- serie
         , msn.serial_attribute_category
         , msn.c_attribute1                    serial_c_attribute1
         , msn.c_attribute2                    serial_c_attribute2
         , msn.c_attribute3                    serial_c_attribute3
         , msn.c_attribute4                    serial_c_attribute4
         , msn.c_attribute5                    serial_c_attribute5
         , msn.c_attribute6                    serial_c_attribute6
         , msn.c_attribute7                    serial_c_attribute7
         , msn.c_attribute8                    serial_c_attribute8
         , msn.c_attribute9                    serial_c_attribute9
         , msn.c_attribute10                   serial_c_attribute10
         , msn.c_attribute11                   serial_c_attribute11
         , msn.c_attribute12                   serial_c_attribute12
         , msn.c_attribute13                   serial_c_attribute13
         , msn.c_attribute14                   serial_c_attribute14
         , msn.c_attribute15                   serial_c_attribute15
         , msn.c_attribute16                   serial_c_attribute16
         , msn.c_attribute17                   serial_c_attribute17
         , msn.c_attribute18                   serial_c_attribute18
         , msn.c_attribute19                   serial_c_attribute19
         , msn.c_attribute20                   serial_c_attribute20
         , msn.d_attribute1                    serial_d_attribute1
         , msn.d_attribute2                    serial_d_attribute2
         , msn.d_attribute3                    serial_d_attribute3
         , msn.d_attribute4                    serial_d_attribute4
         , msn.d_attribute5                    serial_d_attribute5
         , msn.d_attribute6                    serial_d_attribute6
         , msn.d_attribute7                    serial_d_attribute7
         , msn.d_attribute8                    serial_d_attribute8
         , msn.d_attribute9                    serial_d_attribute9
         , msn.d_attribute10                   serial_d_attribute10
         , msn.n_attribute1                    serial_n_attribute1
         , msn.n_attribute2                    serial_n_attribute2
         , msn.n_attribute3                    serial_n_attribute3
         , msn.n_attribute4                    serial_n_attribute4
         , msn.n_attribute5                    serial_n_attribute5
         , msn.n_attribute6                    serial_n_attribute6
         , msn.n_attribute7                    serial_n_attribute7
         , msn.n_attribute8                    serial_n_attribute8
         , msn.n_attribute9                    serial_n_attribute9
         , msn.n_attribute10                   serial_n_attribute10
         --
         , msn.attribute_category              attribute_category_serie
         , msn.attribute1                      attribute1_serie
         , msn.attribute2                      attribute2_serie
         , msn.attribute3                      attribute3_serie
         , msn.attribute4                      attribute4_serie
         , msn.attribute5                      attribute5_serie
         , msn.attribute6                      attribute6_serie
         , msn.attribute7                      attribute7_serie
         , msn.attribute8                      attribute8_serie
         , msn.attribute9                      attribute9_serie
         , msn.attribute10                     attribute10_serie
         , msn.attribute11                     attribute11_serie
         , msn.attribute12                     attribute12_serie
         , msn.attribute13                     attribute13_serie
         , msn.attribute14                     attribute14_serie
         , msn.attribute15                     attribute15_serie
         -- Enh 28431410 - End
      FROM apps.jl_br_customer_trx_exts             jbcte
         , apps.jl_br_eilog                         jbe
         , apps.ra_customer_trx_all                 rcta
         , apps.ra_customer_trx_lines_all           rctla
         , apps.cll_f513_cust_network               ccn
         , apps.cll_f513_tpa_receipts_control       ctrc
         , apps.mtl_system_items_b                  msi
         , apps.cll_f513_tpa_devolutions_ctrl       ctdc
         , apps.mtl_transaction_types               mtt
         , apps.org_organization_definitions        ood
         , apps.mtl_lot_numbers                     mln -- Enh 28431410
         , apps.mtl_serial_numbers                  msn -- Enh 28431410
       WHERE rcta.org_id                       = pc_org_id
         AND rcta.status_trx                   = 'OP'
         AND NVL(ccn.inactive_flag, 'N')       = 'N'
         AND rcta.org_id                       = ccn.operating_unit
         AND ctdc.organization_id              = msi.organization_id
         AND ctdc.inventory_item_id            = msi.inventory_item_id
         AND mtt.transaction_type_id           = ccn.devolution_transaction_type_id
         AND ood.organization_id               = ctdc.organization_id
         AND ccn.source_type                   = 'RI'
         AND
           ( ctrc.cfo_id                       = ccn.in_state_cfop_id
          OR ctrc.cfo_id                       = ccn.out_state_cfop_id )
         AND ctrc.utilization_id               = ccn.utilization_id
         AND ctdc.tpa_receipts_control_id      = ctrc.tpa_receipts_control_id
         AND rctla.interface_line_attribute4   = ctdc.devolution_invoice_line_id
         AND rctla.interface_line_attribute3   = ctdc.devolution_invoice_id
         AND rctla.interface_line_attribute2   = ctdc.organization_id
         AND rctla.interface_line_attribute1   = ctdc.devolution_operation_id
         AND rctla.interface_line_context      = 'CLL F189 INTEGRATED RCV'
         AND rctla.line_type                   = 'LINE'
         AND rcta.customer_trx_id              = rctla.customer_trx_id
         AND jbcte.electronic_inv_status       = jbe.electronic_inv_status
         AND jbcte.customer_trx_id             = jbe.customer_trx_id
         --
         -- Bug 32581652 - begin
         AND jbe.occurrence_id IN (SELECT MIN(jbe2.occurrence_id)
                                     FROM apps.jl_br_eilog                   jbe2
                                    WHERE jbe2.customer_trx_id       = jbcte.customer_trx_id
                                      AND jbe2.electronic_inv_status = '2'
                                )
         -- Bug 32581652 - end
         --
         AND jbcte.customer_trx_id             = rcta.customer_trx_id
         AND jbcte.electronic_inv_status       = '2'
         AND NVL(ctdc.devolution_status, 'x') <> 'COMPLETE'
         AND TRUNC(jbe.occurrence_date)        BETWEEN TRUNC(pc_date_from)
                                                   AND TRUNC(pc_date_to)
         -- Enh 28431410 - Start
         AND ctrc.organization_id              = mln.organization_id   (+)
         AND ctrc.inventory_item_id            = mln.inventory_item_id (+)
         AND NVL(ctrc.lot_number, 'x')         = mln.lot_number        (+)
         AND ctrc.inventory_item_id            = msn.inventory_item_id (+)
         AND NVL(ctrc.serial_number, 'x')      = msn.serial_number     (+)
         -- Enh 28431410 - End
         AND ctdc.tpa_devolutions_control_id   = NVL(pc_tpa_dev_ctrl_id, ctdc.tpa_devolutions_control_id) -- Enh 29553257
       ORDER BY 4 ;

  CURSOR c_supplier ( pc_org_id      IN NUMBER
                    , pc_site_use_id IN NUMBER ) IS
    SELECT hp.party_name                                        customer_name
         , hca.account_number                                       customer_number
         , DECODE(SUBSTR(hcasa.global_attribute2, 1, 1),   '2',
                  SUBSTR(hcasa.global_attribute3, 2, 2) || '.' ||
                  SUBSTR(hcasa.global_attribute3, 4, 3) || '.' ||
                  SUBSTR(hcasa.global_attribute3, 7, 3) || '/' ||
                         hcasa.global_attribute4        || '-' ||
                         hcasa.global_attribute5,
                  SUBSTR(hcasa.global_attribute2, 1, 1)  , '1',
                  SUBSTR(hcasa.global_attribute3, 1, 3) || '.' ||
                  SUBSTR(hcasa.global_attribute3, 4, 3) || '.' ||
                  SUBSTR(hcasa.global_attribute3, 7, 3) || '-' ||
                         hcasa.global_attribute5)                   document_number
      FROM apps.hz_cust_accounts          hca
         , apps.hz_cust_site_uses_all     hcsua
         , apps.hz_cust_acct_sites_all    hcasa
         , apps.hz_party_sites            hps
         , apps.hz_parties                hp
         , apps.hz_locations              hl
         , apps.hr_all_organization_units haou
     WHERE hcsua.org_id            = pc_org_id
       AND hcsua.org_id            = haou.organization_id
       AND hcsua.org_id            = hcasa.org_id
       AND hps.location_id         = hl.location_id
       AND hps.party_id            = hp.party_id
       AND
         ( hps.end_date_active     IS NULL
        OR hps.end_date_active     >= TRUNC(SYSDATE) )
       AND
         ( hps.start_date_active   IS NULL
        OR hps.start_date_active   <= TRUNC(SYSDATE) )
       AND hcasa.party_site_id     = hps.party_site_id
       AND hcasa.cust_account_id   = hca.cust_account_id
       AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
       AND hcsua.site_use_code     = 'SHIP_TO'
       AND hcsua.site_use_id       = pc_site_use_id ;

  CURSOR c_balance ( pc_tpa_ctrl_id IN NUMBER ) IS
    SELECT remaining_balance
      FROM apps.cll_f513_tpa_receipts_control
     WHERE tpa_receipts_control_id = pc_tpa_ctrl_id ;

  BEGIN
    --
    l_dDate_From     := TO_DATE(p_date_from, 'YYYY-MM-DD HH24:MI:SS') ;
    l_dDate_To       := TO_DATE(p_date_to  , 'YYYY-MM-DD HH24:MI:SS') ;
    l_vOperation_Ant := NULL ;
    --
    show_log ('Starting process .. : '||TO_CHAR(SYSDATE, 'DD-MM-RRRR HH24:MI:SS')) ;
    show_log (' ') ;
    show_log ('    Parameters .... : p_date_from : '||l_dDate_From) ;
    show_log ('                      p_date_to   : '||l_dDate_To) ;
    show_log ('                      p_org_id    : '||p_org_id) ;
    show_log (' ') ;
    --
    BEGIN
      --
      SELECT application_id
           , concurrent_program_id
        INTO l_nProgram_Appl_Id
           , l_nProgram_Id
        FROM apps.fnd_concurrent_programs
       WHERE concurrent_program_name = 'CLL_F513_TPA_DEV_PROCESS' ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_nProgram_Appl_Id := NULL ;
        l_nProgram_Id      := NULL ;
    END ;
    --
    FOR r_invoices IN c_invoices ( pc_org_id          => p_org_id
                                 , pc_date_from       => l_dDate_From
                                 , pc_date_to         => l_dDate_To
                                 , pc_tpa_dev_ctrl_id => p_tpa_dev_ctrl_id -- Enh 29553257
                                 ) LOOP
      --
      l_vOperation_Ant    := NVL(l_vOperation_Ant   , r_invoices.devolution_operation_id) ;
      l_vOrganization_Ant := NVL(l_vOrganization_Ant, r_invoices.organization_code) ;
      --
      OPEN  c_supplier ( pc_org_id => r_invoices.org_id, pc_site_use_id => r_invoices.site_use_id ) ;
      FETCH c_supplier INTO l_vCustomer_Name, l_vCustomer_Number, l_vDocument_Number ;
      CLOSE c_supplier ;
      --
      OPEN  c_balance ( pc_tpa_ctrl_id => r_invoices.tpa_receipts_control_id );
      FETCH c_balance INTO l_nRemaining_Balance ;
      CLOSE c_balance ;
      --
      l_vOperation_Status := 'COMPLETE' ;
      l_nAdjust_id        := NULL ;
      --
      IF NVL(r_invoices.symbolic_devolution_flag, 'N') <> 'Y' THEN
        l_vMensagem := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                     , p_lookup_code => 'NO_STOCK') ;
      ELSE
        l_vMensagem := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                     , p_lookup_code => 'SYMBOLIC_DEVOLUTION') ;
      END IF ;
      --
      l_vErro_Insert      := NULL ;
      --
      IF r_invoices.receipt_transaction_id IS NOT NULL AND r_invoices.symbolic_devolution_flag <> 'Y' THEN
        --
        BEGIN
          --
          SELECT mtl_material_transactions_s.NEXTVAL
            INTO l_nAdjust_id
            FROM dual ;
        --
        END ;
        --
        l_nSerial_Trans_Tmp_Id := NULL ;
        --
        IF r_invoices.serial_number_control_code <> 1 THEN
            l_nSerial_Trans_Tmp_Id := l_nAdjust_id ;
        END IF ;
        --
        BEGIN
          --
          -- BUG 29625111 - Start
          g_rec_trans_iface := g_crec_trans_iface ;
          --
          g_rec_trans_iface.transaction_interface_id := l_nAdjust_id ;
          g_rec_trans_iface.transaction_header_id    := l_nAdjust_id ;
          g_rec_trans_iface.source_code              := 'CLL_F513-RECEIPT: '|| r_invoices.devolution_operation_id|| '-' || r_invoices.organization_id ;
          g_rec_trans_iface.source_line_id           := r_invoices.devolution_invoice_line_id ;
          g_rec_trans_iface.source_header_id         := r_invoices.devolution_invoice_id ;
          g_rec_trans_iface.process_flag             := 1 ;
          g_rec_trans_iface.transaction_mode         := 3 ;
          g_rec_trans_iface.last_update_date         := SYSDATE ;
          g_rec_trans_iface.last_updated_by          := fnd_global.user_id ;
          g_rec_trans_iface.creation_date            := SYSDATE ;
          g_rec_trans_iface.created_by               := fnd_global.user_id ;
          g_rec_trans_iface.last_update_login        := fnd_global.login_id ;
          g_rec_trans_iface.inventory_item_id        := r_invoices.inventory_item_id ;
          g_rec_trans_iface.organization_id          := r_invoices.organization_id ;
          g_rec_trans_iface.transaction_quantity     := r_invoices.devolution_quantity * (-1) ;
          g_rec_trans_iface.transaction_uom          := r_invoices.uom_code ;
          g_rec_trans_iface.transaction_date         := to_date('01/10/2002 07:00:00','dd/mm/rrrr hh24:mi:ss'); -- ALTERAR PARA A DATA DO PERÍODO QUE DESEJA MOVIMENTAR;
          g_rec_trans_iface.subinventory_code        := r_invoices.subinventory ;
          g_rec_trans_iface.locator_id               := r_invoices.locator_id ;
          g_rec_trans_iface.transaction_type_id      := r_invoices.devolution_transaction_type_id ;
          g_rec_trans_iface.transaction_reference    := r_invoices.tpa_devolutions_control_id ;
          g_rec_trans_iface.distribution_account_id  := r_invoices.devolution_account_id ;
          g_msg_retorno                              := NULL ;
          --
          INSERT_TRANS_IFACE_P ( g_rec_trans_iface, g_msg_retorno ) ;
          --
          IF g_msg_retorno IS NOT NULL THEN
            --
            l_vErro_Insert := 'Y' ;
            --retcode        := 1 ;
            l_nTotal_Error := NVL(l_nTotal_Error, 0) + 1 ;
            --
            l_vMensagem    := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                            , p_lookup_code => 'INSERT_ERROR') ;
            g_msg_retorno  := l_vMensagem||g_msg_retorno ;
            --
            show_log (g_msg_retorno) ;
            show_log ('  customer_trx_id      - '||r_invoices.customer_trx_id) ;
            show_log ('  customer_trx_line_id - '||r_invoices.customer_trx_line_id) ;
            show_log ('  dev_operation_id     - '||r_invoices.tpa_devolutions_control_id) ;
            show_log ('  dev_control_id       - '||r_invoices.devolution_operation_id) ;
          END IF ;
          --
          -- BUG 29625111 - End
          --
          l_nTotal_Iface := NVL(l_nTotal_Iface, 0) + 1 ;
          --
        END ;
        --
        IF r_invoices.lot_control_code <> 1 AND NVL(l_vErro_Insert, 'N') = 'N' THEN
          --
          BEGIN
            --
            -- BUG 29625111 - Start
            g_rec_trans_lots_iface := g_crec_trans_lots_iface ;
            --
            g_rec_trans_lots_iface.transaction_interface_id   := l_nAdjust_id ;
            g_rec_trans_lots_iface.source_code                := 'CLL_F513-RECEIPT: '|| r_invoices.devolution_operation_id || '-' || r_invoices.organization_id ;
            g_rec_trans_lots_iface.source_line_id             := r_invoices.devolution_invoice_line_id ;
            g_rec_trans_lots_iface.last_update_date           := SYSDATE ;
            g_rec_trans_lots_iface.last_updated_by            := fnd_global.user_id ;
            g_rec_trans_lots_iface.creation_date              := SYSDATE ;
            g_rec_trans_lots_iface.created_by                 := fnd_global.user_id ;
            g_rec_trans_lots_iface.last_update_login          := fnd_global.login_id ;
            g_rec_trans_lots_iface.lot_number                 := r_invoices.lot_number ;
            g_rec_trans_lots_iface.lot_expiration_date        := r_invoices.expiration_date ;
            g_rec_trans_lots_iface.transaction_quantity       := r_invoices.devolution_quantity * (-1) ;
            g_rec_trans_lots_iface.serial_transaction_temp_id := l_nSerial_Trans_Tmp_Id ;
            g_rec_trans_lots_iface.process_flag               := 1 ;
            g_rec_trans_lots_iface.parent_lot_number          := r_invoices.parent_lot_number ;
            -- Enh 28431410 - Start
            g_rec_trans_lots_iface.lot_attribute_category     := r_invoices.lot_attribute_category ;
            g_rec_trans_lots_iface.c_attribute1               := r_invoices.lot_c_attribute1 ;
            g_rec_trans_lots_iface.c_attribute2               := r_invoices.lot_c_attribute2 ;
            g_rec_trans_lots_iface.c_attribute3               := r_invoices.lot_c_attribute3 ;
            g_rec_trans_lots_iface.c_attribute4               := r_invoices.lot_c_attribute4 ;
            g_rec_trans_lots_iface.c_attribute5               := r_invoices.lot_c_attribute5 ;
            g_rec_trans_lots_iface.c_attribute6               := r_invoices.lot_c_attribute6 ;
            g_rec_trans_lots_iface.c_attribute7               := r_invoices.lot_c_attribute7 ;
            g_rec_trans_lots_iface.c_attribute8               := r_invoices.lot_c_attribute8 ;
            g_rec_trans_lots_iface.c_attribute9               := r_invoices.lot_c_attribute9 ;
            g_rec_trans_lots_iface.c_attribute10              := r_invoices.lot_c_attribute10 ;
            g_rec_trans_lots_iface.c_attribute11              := r_invoices.lot_c_attribute11 ;
            g_rec_trans_lots_iface.c_attribute12              := r_invoices.lot_c_attribute12 ;
            g_rec_trans_lots_iface.c_attribute13              := r_invoices.lot_c_attribute13 ;
            g_rec_trans_lots_iface.c_attribute14              := r_invoices.lot_c_attribute14 ;
            g_rec_trans_lots_iface.c_attribute15              := r_invoices.lot_c_attribute15 ;
            g_rec_trans_lots_iface.c_attribute16              := r_invoices.lot_c_attribute16 ;
            g_rec_trans_lots_iface.c_attribute17              := r_invoices.lot_c_attribute17 ;
            g_rec_trans_lots_iface.c_attribute18              := r_invoices.lot_c_attribute18 ;
            g_rec_trans_lots_iface.c_attribute19              := r_invoices.lot_c_attribute19 ;
            g_rec_trans_lots_iface.c_attribute20              := r_invoices.lot_c_attribute20 ;
            g_rec_trans_lots_iface.d_attribute1               := r_invoices.lot_d_attribute1 ;
            g_rec_trans_lots_iface.d_attribute2               := r_invoices.lot_d_attribute2 ;
            g_rec_trans_lots_iface.d_attribute3               := r_invoices.lot_d_attribute3 ;
            g_rec_trans_lots_iface.d_attribute4               := r_invoices.lot_d_attribute4 ;
            g_rec_trans_lots_iface.d_attribute5               := r_invoices.lot_d_attribute5 ;
            g_rec_trans_lots_iface.d_attribute6               := r_invoices.lot_d_attribute6 ;
            g_rec_trans_lots_iface.d_attribute7               := r_invoices.lot_d_attribute7 ;
            g_rec_trans_lots_iface.d_attribute8               := r_invoices.lot_d_attribute8 ;
            g_rec_trans_lots_iface.d_attribute9               := r_invoices.lot_d_attribute9 ;
            g_rec_trans_lots_iface.d_attribute10              := r_invoices.lot_d_attribute10 ;
            g_rec_trans_lots_iface.n_attribute1               := r_invoices.lot_n_attribute1 ;
            g_rec_trans_lots_iface.n_attribute2               := r_invoices.lot_n_attribute2 ;
            g_rec_trans_lots_iface.n_attribute3               := r_invoices.lot_n_attribute3 ;
            g_rec_trans_lots_iface.n_attribute4               := r_invoices.lot_n_attribute4 ;
            g_rec_trans_lots_iface.n_attribute5               := r_invoices.lot_n_attribute5 ;
            g_rec_trans_lots_iface.n_attribute6               := r_invoices.lot_n_attribute6 ;
            g_rec_trans_lots_iface.n_attribute7               := r_invoices.lot_n_attribute7 ;
            g_rec_trans_lots_iface.n_attribute8               := r_invoices.lot_n_attribute8 ;
            g_rec_trans_lots_iface.n_attribute9               := r_invoices.lot_n_attribute9 ;
            g_rec_trans_lots_iface.n_attribute10              := r_invoices.lot_n_attribute10 ;
            --
            g_rec_trans_lots_iface.attribute_category       := r_invoices.attribute_category_lot ;
            g_rec_trans_lots_iface.attribute1               := r_invoices.attribute1_lot ;
            g_rec_trans_lots_iface.attribute2               := r_invoices.attribute2_lot ;
            g_rec_trans_lots_iface.attribute3               := r_invoices.attribute3_lot ;
            g_rec_trans_lots_iface.attribute4               := r_invoices.attribute4_lot ;
            g_rec_trans_lots_iface.attribute5               := r_invoices.attribute5_lot ;
            g_rec_trans_lots_iface.attribute6               := r_invoices.attribute6_lot ;
            g_rec_trans_lots_iface.attribute7               := r_invoices.attribute7_lot ;
            g_rec_trans_lots_iface.attribute8               := r_invoices.attribute8_lot ;
            g_rec_trans_lots_iface.attribute9               := r_invoices.attribute9_lot ;
            g_rec_trans_lots_iface.attribute10              := r_invoices.attribute10_lot ;
            g_rec_trans_lots_iface.attribute11              := r_invoices.attribute11_lot ;
            g_rec_trans_lots_iface.attribute12              := r_invoices.attribute12_lot ;
            g_rec_trans_lots_iface.attribute13              := r_invoices.attribute13_lot ;
            g_rec_trans_lots_iface.attribute14              := r_invoices.attribute14_lot ;
            g_rec_trans_lots_iface.attribute15              := r_invoices.attribute15_lot ;
            -- Enh 28431410 - End

            g_msg_retorno                                     := NULL ;
            --
            INSERT_TRANS_LOTS_IFACE_P ( g_rec_trans_lots_iface, g_msg_retorno ) ;
            --
            IF g_msg_retorno IS NOT NULL THEN
              --
              l_vErro_Insert := 'Y' ;
              --retcode        := 1 ;
              l_nTotal_Error := NVL(l_nTotal_Error, 0) + 1 ;
              l_vMensagem    := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                              , p_lookup_code => 'INSERT_ERROR') ;
              g_msg_retorno  := l_vMensagem||g_msg_retorno ;
              --
              ROLLBACK ;
              --
              show_log (g_msg_retorno) ;
              show_log ('  customer_trx_id      - '||r_invoices.customer_trx_id) ;
              show_log ('  customer_trx_line_id - '||r_invoices.customer_trx_line_id) ;
              show_log ('  dev_operation_id     - '||r_invoices.tpa_devolutions_control_id) ;
              show_log ('  dev_control_id       - '||r_invoices.devolution_operation_id) ;
              --
            END IF ;
            --
            -- BUG 29625111 - End
            --
            l_nTotal_Batch := NVL(l_nTotal_Batch, 0) +1 ;
            --
          END ;
          --
        END IF ;
        --
        IF r_invoices.serial_number_control_code <> 1 AND NVL(l_vErro_Insert, 'N') = 'N' THEN
          --
          BEGIN
            --
            -- BUG 29625111 - Start
            g_rec_serial_num_iface := g_crec_serial_num_iface ;
            --
            g_rec_serial_num_iface.transaction_interface_id := l_nAdjust_id ;
            g_rec_serial_num_iface.source_code              := 'CLL_F513-RECEIPT: '|| r_invoices.devolution_operation_id || '-' || r_invoices.organization_id ;
            g_rec_serial_num_iface.source_line_id           := r_invoices.devolution_invoice_line_id ;
            g_rec_serial_num_iface.last_update_date         := SYSDATE ;
            g_rec_serial_num_iface.last_updated_by          := fnd_global.user_id ;
            g_rec_serial_num_iface.creation_date            := SYSDATE ;
            g_rec_serial_num_iface.created_by               := fnd_global.user_id ;
            g_rec_serial_num_iface.last_update_login        := fnd_global.login_id ;
            g_rec_serial_num_iface.fm_serial_number         := r_invoices.serial_number ;
            g_rec_serial_num_iface.to_serial_number         := r_invoices.serial_number ;
            g_rec_serial_num_iface.process_flag             := 1 ;
            -- Enh 28431410 - Start
            g_rec_serial_num_iface.serial_attribute_category  := r_invoices.serial_attribute_category ;
            g_rec_serial_num_iface.c_attribute1               := r_invoices.serial_c_attribute1 ;
            g_rec_serial_num_iface.c_attribute2               := r_invoices.serial_c_attribute2 ;
            g_rec_serial_num_iface.c_attribute3               := r_invoices.serial_c_attribute3 ;
            g_rec_serial_num_iface.c_attribute4               := r_invoices.serial_c_attribute4 ;
            g_rec_serial_num_iface.c_attribute5               := r_invoices.serial_c_attribute5 ;
            g_rec_serial_num_iface.c_attribute6               := r_invoices.serial_c_attribute6 ;
            g_rec_serial_num_iface.c_attribute7               := r_invoices.serial_c_attribute7 ;
            g_rec_serial_num_iface.c_attribute8               := r_invoices.serial_c_attribute8 ;
            g_rec_serial_num_iface.c_attribute9               := r_invoices.serial_c_attribute9 ;
            g_rec_serial_num_iface.c_attribute10              := r_invoices.serial_c_attribute10 ;
            g_rec_serial_num_iface.c_attribute11              := r_invoices.serial_c_attribute11 ;
            g_rec_serial_num_iface.c_attribute12              := r_invoices.serial_c_attribute12 ;
            g_rec_serial_num_iface.c_attribute13              := r_invoices.serial_c_attribute13 ;
            g_rec_serial_num_iface.c_attribute14              := r_invoices.serial_c_attribute14 ;
            g_rec_serial_num_iface.c_attribute15              := r_invoices.serial_c_attribute15 ;
            g_rec_serial_num_iface.c_attribute16              := r_invoices.serial_c_attribute16 ;
            g_rec_serial_num_iface.c_attribute17              := r_invoices.serial_c_attribute17 ;
            g_rec_serial_num_iface.c_attribute18              := r_invoices.serial_c_attribute18 ;
            g_rec_serial_num_iface.c_attribute19              := r_invoices.serial_c_attribute19 ;
            g_rec_serial_num_iface.c_attribute20              := r_invoices.serial_c_attribute20 ;
            g_rec_serial_num_iface.d_attribute1               := r_invoices.serial_d_attribute1 ;
            g_rec_serial_num_iface.d_attribute2               := r_invoices.serial_d_attribute2 ;
            g_rec_serial_num_iface.d_attribute3               := r_invoices.serial_d_attribute3 ;
            g_rec_serial_num_iface.d_attribute4               := r_invoices.serial_d_attribute4 ;
            g_rec_serial_num_iface.d_attribute5               := r_invoices.serial_d_attribute5 ;
            g_rec_serial_num_iface.d_attribute6               := r_invoices.serial_d_attribute6 ;
            g_rec_serial_num_iface.d_attribute7               := r_invoices.serial_d_attribute7 ;
            g_rec_serial_num_iface.d_attribute8               := r_invoices.serial_d_attribute8 ;
            g_rec_serial_num_iface.d_attribute9               := r_invoices.serial_d_attribute9 ;
            g_rec_serial_num_iface.d_attribute10              := r_invoices.serial_d_attribute10 ;
            g_rec_serial_num_iface.n_attribute1               := r_invoices.serial_n_attribute1 ;
            g_rec_serial_num_iface.n_attribute2               := r_invoices.serial_n_attribute2 ;
            g_rec_serial_num_iface.n_attribute3               := r_invoices.serial_n_attribute3 ;
            g_rec_serial_num_iface.n_attribute4               := r_invoices.serial_n_attribute4 ;
            g_rec_serial_num_iface.n_attribute5               := r_invoices.serial_n_attribute5 ;
            g_rec_serial_num_iface.n_attribute6               := r_invoices.serial_n_attribute6 ;
            g_rec_serial_num_iface.n_attribute7               := r_invoices.serial_n_attribute7 ;
            g_rec_serial_num_iface.n_attribute8               := r_invoices.serial_n_attribute8 ;
            g_rec_serial_num_iface.n_attribute9               := r_invoices.serial_n_attribute9 ;
            g_rec_serial_num_iface.n_attribute10              := r_invoices.serial_n_attribute10 ;
            --
            g_rec_serial_num_iface.attribute_category       := r_invoices.attribute_category_serie ;
            g_rec_serial_num_iface.attribute1               := r_invoices.attribute1_serie ;
            g_rec_serial_num_iface.attribute2               := r_invoices.attribute2_serie ;
            g_rec_serial_num_iface.attribute3               := r_invoices.attribute3_serie ;
            g_rec_serial_num_iface.attribute4               := r_invoices.attribute4_serie ;
            g_rec_serial_num_iface.attribute5               := r_invoices.attribute5_serie ;
            g_rec_serial_num_iface.attribute6               := r_invoices.attribute6_serie ;
            g_rec_serial_num_iface.attribute7               := r_invoices.attribute7_serie ;
            g_rec_serial_num_iface.attribute8               := r_invoices.attribute8_serie ;
            g_rec_serial_num_iface.attribute9               := r_invoices.attribute9_serie ;
            g_rec_serial_num_iface.attribute10              := r_invoices.attribute10_serie ;
            g_rec_serial_num_iface.attribute11              := r_invoices.attribute11_serie ;
            g_rec_serial_num_iface.attribute12              := r_invoices.attribute12_serie ;
            g_rec_serial_num_iface.attribute13              := r_invoices.attribute13_serie ;
            g_rec_serial_num_iface.attribute14              := r_invoices.attribute14_serie ;
            g_rec_serial_num_iface.attribute15              := r_invoices.attribute15_serie ;
            -- Enh 28431410 - End
            --
            g_msg_retorno                                   := NULL ;
            --
            INSERT_SERIAL_NUM_IFACE_P ( g_rec_serial_num_iface, g_msg_retorno ) ;
            --
            IF g_msg_retorno IS NOT NULL THEN
              --
              l_vErro_Insert := 'Y' ;
              --retcode        := 1 ;
              l_nTotal_Error := NVL(l_nTotal_Error, 0) + 1 ;
              --
              l_vMensagem    := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                              , p_lookup_code => 'INSERT_ERROR') ;
              g_msg_retorno  := l_vMensagem||g_msg_retorno ;
              --
              ROLLBACK ;
              --
              show_log (g_msg_retorno) ;
              show_log ('  customer_trx_id      - '||r_invoices.customer_trx_id) ;
              show_log ('  customer_trx_line_id - '||r_invoices.customer_trx_line_id) ;
              show_log ('  dev_operation_id     - '||r_invoices.tpa_devolutions_control_id) ;
              show_log ('  dev_control_id       - '||r_invoices.devolution_operation_id) ;
              --
            END IF ;
            --
            -- BUG 29625111 - End
            --
            l_nTotal_Serial := NVL(l_nTotal_Serial, 0) + 1 ;
            --
          END ;
          --
        END IF ;
        --
        IF NVL(l_vErro_Insert, 'N') = 'N' THEN
          --
          l_vError_Code        := NULL ;
          l_vError_Explanation := NULL ;
          l_vResult_Adjust     := TRUE ;
          --
          l_vMensagem          := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                                , p_lookup_code => 'SUCCESSFUL') ;
          --
----          l_vResult_Adjust     := apps.mtl_online_transaction_pub.process_online ( l_nAdjust_id
----                                                                            , l_nTimeout
----                                                                            , l_vError_Code
----                                                                            , l_vError_Explanation ) ;
          --
          IF l_vResult_Adjust = FALSE THEN
            --
            --retcode        := 1 ;
            l_vErro_Insert := 'Y' ;
            l_nTotal_Error := NVL(l_nTotal_Error, 0) + 1 ;
            --
            l_vMensagem    := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                            , p_lookup_code => 'INTERFACE_ERROR') ;
            l_vMensagem    := l_vMensagem||SUBSTR(RTRIM(LTRIM(l_vError_Code))||' '||RTRIM(LTRIM(l_vError_Explanation)), 1, 4000) ;
            --
            show_log (l_vMensagem) ;
            show_log ('  customer_trx_id      - '||r_invoices.customer_trx_id) ;
            show_log ('  customer_trx_line_id - '||r_invoices.customer_trx_line_id) ;
            show_log ('  dev_operation_id     - '||r_invoices.tpa_devolutions_control_id) ;
            show_log ('  dev_control_id       - '||r_invoices.devolution_operation_id) ;
            --
            l_vOperation_Status := 'INVENTORY PENDING' ;
            --
          END IF ;
          --
          -- Enh 29553257 - Start
          --
          BEGIN
            --
----            DELETE apps.mtl_serial_numbers_interface WHERE transaction_interface_id = l_nAdjust_id ;
            null;
            --
          EXCEPTION WHEN OTHERS THEN
            SHOW_LOG('Error deleting mtl_serial_numbers_interface - transaction_interface_id '||l_nAdjust_id||' - '|| SQLERRM);
          END ;
          --
          BEGIN
            --
----            DELETE apps.mtl_transaction_lots_interface WHERE transaction_interface_id = l_nAdjust_id ;
            null;
            --
          EXCEPTION WHEN OTHERS THEN
            SHOW_LOG('Error deleting mtl_transaction_lots_interface - transaction_interface_id '||l_nAdjust_id||' - '|| SQLERRM);
          END ;
          --
          BEGIN
            --
----            DELETE apps.mtl_transactions_interface WHERE transaction_interface_id = l_nAdjust_id ;
            null;
            --
          EXCEPTION WHEN OTHERS THEN
            SHOW_LOG('Error deleting mtl_transactions_interface - transaction_interface_id '||l_nAdjust_id||' - '|| SQLERRM);
          END ;
          --
          -- Enh 29553257 - End
          --
----          COMMIT ;
          --
        END IF ;
        --
      END IF ;
      --
      BEGIN
        --
        l_vMsg_Devolution := NULL ;
        --
        UPDATE apps.cll_f513_tpa_devolutions_ctrl
           SET customer_trx_id            = r_invoices.customer_trx_id
             , cust_trx_type_id           = r_invoices.cust_trx_type_id
             , customer_trx_line_id       = r_invoices.customer_trx_line_id
             , trx_number                 = r_invoices.invoice_number
             , trx_date                   = r_invoices.invoice_date
             , sefaz_authorization_date   = r_invoices.sefaz_authorization_date
             , devolution_transaction_id  = l_nAdjust_id
             , devolution_status          = l_vOperation_Status
             , last_update_date           = SYSDATE
             , last_updated_by            = fnd_global.user_id
             , last_update_login          = fnd_global.login_id
             , program_application_id     = l_nProgram_Appl_Id
             , program_id                 = l_nProgram_Id
             , program_update_date        = SYSDATE
             , error_flag                 = NVL(l_vErro_Insert, 'N')  -- Bug 29553127
         WHERE tpa_devolutions_control_id = r_invoices.tpa_devolutions_control_id ;
        --
        IF SQL%ROWCOUNT > 0 THEN
          l_vMsg_Devolution := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                             , p_lookup_code => 'SUCCESSFUL_DEVOLUTION') ;
        END IF ;
        --
      EXCEPTION
        WHEN OTHERS THEN
          l_vMsg_Devolution := NULL ;
      END ;
      --
      IF l_vOperation_Status = 'COMPLETE' THEN
        --
        BEGIN
          --
          l_vMsg_Receipt := NULL ;
          --
          UPDATE apps.cll_f513_tpa_receipts_control
             SET remaining_balance         = l_nRemaining_Balance - r_invoices.devolution_quantity
               , last_update_date          = SYSDATE
               , last_updated_by           = fnd_global.user_id
               , last_update_login         = fnd_global.login_id
               , program_application_id    = l_nProgram_Appl_Id
               , program_id                = l_nProgram_Id
               , program_update_date       = SYSDATE
           WHERE tpa_receipts_control_id   = r_invoices.tpa_receipts_control_id ;
          --
          IF SQL%ROWCOUNT > 0 THEN
            l_vMsg_Receipt := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                            , p_lookup_code => 'SUCCESSFUL_RECEIPT') ;
          END IF ;
          --
        EXCEPTION
          WHEN OTHERS THEN
            l_vMsg_Receipt := NULL ;
        END ;
        --
      END IF ;
      --
      l_vStatus := 'SUCCESSFUL' ;
      --
      IF NVL(l_vErro_Insert, 'N') = 'Y' THEN
        l_vStatus := 'UNSUCCESSFUL' ;
      END IF ;
      --
      insert_log_p ( p_org_id                     => r_invoices.org_id
                   , p_customer_number            => l_vCustomer_Number
                   , p_customer_name              => l_vCustomer_Name
                   , p_trx_number                 => r_invoices.invoice_number
                   , p_line_number                => r_invoices.line_number
                   , p_lot_number                 => r_invoices.lot_number
                   , p_serial_number              => r_invoices.serial_number
                   , p_process_status             => l_vStatus
                   , p_process_description        => l_vMensagem
                   , p_segment1                   => r_invoices.segment1
                   , p_source_subinventory        => r_invoices.subinventory
                   , p_source_locator_id          => r_invoices.locator_id
                   , p_operation_id               => r_invoices.devolution_operation_id
                   , p_invoice_number             => r_invoices.invoice_number
                   , p_item_number                => r_invoices.item_number
                   , p_tpa_receipt_control_id     => r_invoices.tpa_receipts_control_id
                   , p_receipt_transaction_id     => r_invoices.receipt_transaction_id
                   , p_tpa_devolutions_control_id => r_invoices.tpa_devolutions_control_id
                   , p_devolution_transaction_id  => l_nAdjust_id
                   ) ;
      --
      l_vStatus := 'SUCCESSFUL' ;
      --
      IF l_vMsg_Devolution IS NULL THEN
          l_vStatus         := 'UNSUCCESSFUL' ;
          l_vMsg_Devolution := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                             , p_lookup_code => 'UNSUCCESSFUL_DEVOLUTION') ;
      END IF ;
      --
      insert_log_p ( p_org_id                     => r_invoices.org_id
                   , p_customer_number            => l_vCustomer_Number
                   , p_customer_name              => l_vCustomer_Name
                   , p_trx_number                 => r_invoices.invoice_number
                   , p_line_number                => r_invoices.line_number
                   , p_lot_number                 => r_invoices.lot_number
                   , p_serial_number              => r_invoices.serial_number
                   , p_process_status             => l_vStatus
                   , p_process_description        => l_vMsg_Devolution
                   , p_segment1                   => r_invoices.segment1
                   , p_source_subinventory        => r_invoices.subinventory
                   , p_source_locator_id          => r_invoices.locator_id
                   , p_operation_id               => r_invoices.devolution_operation_id
                   , p_invoice_number             => r_invoices.invoice_number
                   , p_item_number                => r_invoices.item_number
                   , p_tpa_receipt_control_id     => r_invoices.tpa_receipts_control_id
                   , p_receipt_transaction_id     => r_invoices.receipt_transaction_id
                   , p_tpa_devolutions_control_id => r_invoices.tpa_devolutions_control_id
                   , p_devolution_transaction_id  => l_nAdjust_id
                   ) ;
      --
      l_vStatus := 'SUCCESSFUL' ;
      --
      IF l_vMsg_Receipt IS NULL THEN
          l_vStatus      := 'UNSUCCESSFUL' ;
          l_vMsg_Receipt := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                          , p_lookup_code => 'UNSUCCESSFUL_RECEIPT') ;
      END IF ;
      --
      insert_log_p ( p_org_id                     => r_invoices.org_id
                   , p_customer_number            => l_vCustomer_Number
                   , p_customer_name              => l_vCustomer_Name
                   , p_trx_number                 => r_invoices.invoice_number
                   , p_line_number                => r_invoices.line_number
                   , p_lot_number                 => r_invoices.lot_number
                   , p_serial_number              => r_invoices.serial_number
                   , p_process_status             => l_vStatus
                   , p_process_description        => l_vMsg_Receipt
                   , p_segment1                   => r_invoices.segment1
                   , p_source_subinventory        => r_invoices.subinventory
                   , p_source_locator_id          => r_invoices.locator_id
                   , p_operation_id               => r_invoices.devolution_operation_id
                   , p_invoice_number             => r_invoices.invoice_number
                   , p_item_number                => r_invoices.item_number
                   , p_tpa_receipt_control_id     => r_invoices.tpa_receipts_control_id
                   , p_receipt_transaction_id     => r_invoices.receipt_transaction_id
                   , p_tpa_devolutions_control_id => r_invoices.tpa_devolutions_control_id
                   , p_devolution_transaction_id  => l_nAdjust_id
                   ) ;
      --
----      COMMIT ;
      --
    END LOOP ;
    --
----    show_report ( p_nrequest_id        => fnd_global.conc_request_id
----                , p_vOrganization_code => l_vOrganization_Ant
----                , p_dDate_from         => p_date_from
----                , p_dDate_to           => p_date_to
----                , p_nOrg_id            => p_org_id
----                ) ;
    --
  END execute_process_p ;
  --
begin
----------- Esse bloco pega notas da data x até y.
  execute_process_p ( p_date_from         => '2022-09-29 00:00:00', -- Alterar de Acordo com a data da nota
                      p_date_to           => '2022-10-01 00:00:00', -- Alterar de Acordo com a data da nota
                      p_org_id            => 155, -- ORGNIAZAÇÃO
                      p_tpa_dev_ctrl_id   => 39278 -- Enh TPA_CONTROL_ID
                    );
  --
  commit;
  
/*  execute_process_p ( p_date_from         => '2022-09-29 00:00:00',
                      p_date_to           => '2022-10-01 00:00:00',
                      p_org_id            => 155,
                      p_tpa_dev_ctrl_id   => 39272 -- Enh 29553257
                    );
  --
  commit;
  --
    execute_process_p ( p_date_from         => '2022-09-29 00:00:00',
                      p_date_to           => '2022-10-01 00:00:00',
                      p_org_id            => 155,
                      p_tpa_dev_ctrl_id   => 39785 -- Enh 29553257
                    );
  --
  commit;*/
end;
------------------------------------------------------------------------------------------------------------------
-----------------------PROCESSO DE ABERTURA DE LINHAS PO OSGT-----------------------------------------------------
SELECT
    status,
    count(status)
FROM
    triskmb.itens_ordem
WHERE
    num_ordem IN ( '31515.145', '33521145', '33522.145', '33261145', '33260.145',
                   '33263.145', '33264.145', '33177.145', '33173.145', '33165.145',
                   '33179.145', '33168.145', '33171.145', '33172.145', '33262.145',
                   '33265.145', '33286.145' )
GROUP BY  status;

UPDATE triskmb.itens_ordem
SET STATUS = 'A'
WHERE
 num_ordem IN ( '31515.145', '33521145', '33522.145', '33261145', '33260.145',
                   '33263.145', '33264.145', '33177.145', '33173.145', '33165.145',
                   '33179.145', '33168.145', '33171.145', '33172.145', '33262.145',
                   '33265.145', '33286.145' )
AND STATUS = 'F';
-------------------------------------------------------------------------------------------------------------------
----------------------------SELECT TEMPLATE E CAMPOS DE PREENCHIMENTO AUTOMÁTICO-----------------------------------
SELECT 
     a.template_id
    ,a.template_name
    ,c.meaning
    ,b.USER_ATTRIBUTE_NAME
    ,b.ATTRIBUTE_NAME
    ,b.ATTRIBUTE_VALUE
    ,b.ENABLED_FLAG
    ,b.CONTROL_LEVEL
    ,b.CONTROL_LEVEL_DSP
    ,b.ATTRIBUTE_GROUP_ID
    ,b.SEQUENCE
    ,b.REPORT_USER_VALUE
    ,b.MANDATORY_FLAG
    ,b.VALIDATION_CODE
    ,b.DATA_TYPE
    ,b.LAST_UPDATE_DATE
    ,b.LAST_UPDATED_BY
    ,b.CREATION_DATE
    ,b.CREATED_BY
FROM
            mtl_item_templates_all_v    a
    JOIN    mtl_item_templ_attributes_v b   ON  a.template_id           =   b.template_id
    LEFT JOIN    mfg_lookups            c   ON  b.attribute_group_id    =   c.lookup_code
                                            AND c.lookup_type = 'ITEM_CHOICES_GUI'
                           
WHERE
    a.template_id IN (4086)
ORDER BY c.meaning;

----------------------------------------------SELECT PESQUISA DE NOTAS E FORNECEDORES IMPORTAÇÃO KMB----------------------------------------------
SELECT DISTINCT
   A.segment1   po_num,
   C.segment2   categoria,
   D.vendor_name nome_fornecedor,
   A.creation_date,
   A.org_id,
   substr(E.global_attribute10||E.global_attribute11||E.global_attribute12,2,16) cnpj,
   H.invoice_num ,
   H.operation_id,
   I.meaning,
   H.organization_id,
   H.eletronic_invoice_key
FROM
    po_headers_all          A,
    po_lines_all            B,
    mtl_item_categories_v   C,
    ap_suppliers            D,
    ap_supplier_sites_all   E,
    rcv_shipment_lines      F,
    cll_f189_invoice_lines  G,
    cll_f189_invoices       H,
    fnd_lookup_values_vl    I

WHERE   A.po_header_id = B.po_header_id
AND     B.category_id = C.category_id
AND     F.po_line_id = B.po_line_id
AND     F.shipment_header_id = G.shipment_header_id
AND     G.invoice_id = H.invoice_id
AND     A.vendor_id = D.vendor_id
AND     D.vendor_id = E.vendor_id
AND     C.category_id = '42124'
AND     A.creation_date BETWEEN '01/01/2022' AND '21/11/2022'
AND     H.organization_id IN ('149','157')
AND     A.org_id = E.org_id
AND     A.vendor_site_id = E.vendor_site_id
AND     I.lookup_code = H.fiscal_document_model
AND     I.lookup_type = 'CLL_F189_FISCAL_DOCUMENT_MODEL'
ORDER BY creation_date DESC;

-- DIS GERADAS PELO SISTEMA DO DESPACHANTE
SELECT
    area_negocio,
    a.processo_di,
    a.num_di,
    data_registro_di,
    diretorio_destino,
    decode(diretorio_destino, NULL, 'REGISTRO FORA OSGT', 'REGISTRO OSGT') AS via_registro
FROM
    trbskmb.di a
WHERE
    to_char(data_registro_di, 'yy') = '22'
order by data_registro_di asc