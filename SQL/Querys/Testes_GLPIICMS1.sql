Select a.part_number,
iar.base_icms,
iar.vlr_icms_devido,
round(iar.base_icms, 2) as base_arr,
round(iar.base_icms, 2) * 0.18 as vl

from trbskmb.itens_nf a, trbskmb.item_adicao_rateio iar
where a.processo_di = iar.processo_di
and a.part_number = iar.part_number
and a.id_item_adicao = iar.id_item_adicao
and a.processo_di = 'KSP-0050/21';
-- and a.part_number = '56075-2589'

;


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
 WHERE num_nf IN ('196')
AND
    serie = 9;
