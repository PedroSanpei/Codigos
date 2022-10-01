--consulta open interface RI
SELECT
-- a.*
 a.invoice_num, a.other_expenses, a.import_other_val_included_icms
  FROM CLL.CLL_F189_INVOICES_INTERFACE a
 WHERE SOURCE = 'SOFTWAY'
  and invoice_num IN ('121')
   and series = 9;

-- Consulta Open Interface RI Header com as linhas
SELECT * FROM CLL.CLL_F189_INVOICE_LINES_IFACE WHERE INTERFACE_INVOICE_ID =(SELECT INTERFACE_INVOICE_ID FROM CLL.CLL_F189_INVOICES_INTERFACE
 WHERE SOURCE = 'SOFTWAY'
  and invoice_num IN ('121')
   and series = 9);

--iten open
SELECT *
  FROM CLL.CLL_F189_INVOICE_LINES_IFACE
 WHERE INTERFACE_INVOICE_ID IN
       (SELECT INTERFACE_INVOICE_ID
          FROM CLL.CLL_F189_INVOICES_INTERFACE
         WHERE SOURCE = 'SOFTWAY'
         and invoice_num IN ('121')
        and series = 9);

--Consulta tabelas finais RI
SELECT A.*
  FROM CLL_F189_STATES              H,
       CLL_F189_FISCAL_ENTITIES_ALL F,
       CLL_F189_INVOICES            A
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

-- Renotificar NotaFiscal RI para Em Elaboração LEMBRETE - DE COMMIT DEPOIS DE EXECUTAR!!!!
update bs_nota_fiscal a
   set a.status_nf = 'Em Elaboração.', a.nfe_sefaz_status = 'Em Elaboração.'
 where num_nf in (121)
   and a.serie = 9;
   
-- Renotirficar NotaFiscal RI para Aprovada SEFAZ LEMBRETE - DE COMMIT DEPOIS DE EXECUTAR!!!!
update bs_nota_fiscal a
   set a.status_nf = 'Impressa.', a.nfe_sefaz_status = 'Aprovada - SEFAZ.'
 where num_nf in(121)
   and a.serie = 9; 
   
-- Consulta a Tabela de Notifação    
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

-- Select para consultar a chave de acesso
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
select
DECODE(A.ID_ORGANIZACAO, 301, 'KMB', 290, 'KCA') AS ORG,
A.PART_NUMBER,
A.NCM,
A.DESCRICAO_RESUMIDA,
A.DESCRICAO_DETALHADA,
A.SEQ_SUFRAMA,
A.COD_PROD_SUFRAMA,
A.TIPO_PROD_SUFRAMA,
A.MODELO_PROD_SUFRAMA,
B.DETALHE,
c.cd_nivel_ncm AS NVE_nivel_ncm,
c.cd_atributo_ncm AS NVE_atributo_ncm,
c.cd_especif_ncm AS NVE_especif_ncm
from TRKMB.SFW_PRODUTO A, TRKMB.sfw_detalhe_ncm_suframa B, SFW_PRODUTO_NVE C
where a.id_detalhe_suframa = b.id_detalhe_suframa(+)
AND a.id_produto = c.id_produto(+)
order by 1,2,3
