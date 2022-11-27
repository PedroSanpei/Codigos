-- 
-- Select 1 - MTL
--
SELECT
    (SELECT  organization_code FROM apps.org_organization_definitions WHERE organization_id = x.organization_id) organização,
     'MTL'                         origem_transacao,
     x.period_name,
     x.transaction_id,
     x.data_transacao,
     x.transacao,
     x.segment1,
     x.segment2,
     x.segment3,
     x.segment4,
     x.segment5,
     x.segment6,
     x.segment7,
     x.item,
     translate(x.descr_item, 'x'|| CHR(10) || CHR(13), 'x')      descr_item,
     x.categoria_produto,
     x.volume,
     CASE WHEN x.volume < 0 THEN 'SAIDA' ELSE 'ENTRADA' END  tipo_transação,
     x.debito,
     x.credito,
     x.lacto_contabil,
     decode(nvl(x.cost_element_id, 1), 1, 'Material', 2, 'Materia Overhead',3, 'Resource',4,'Outside Processing',5,'Overhead',
     x.cost_element_id)                                      elemento_custo,                        
     CASE WHEN transaction_type_id IN ( 35, 17, 43, 44, 25, 90, 91 ) THEN
        (SELECT substr(wip_entity_name, 1, 15)FROM apps.wip_entities 
         WHERE  wip_entity_id = x.transaction_source_id)
     END           numero_op,
     (SELECT flv.meaning 
      FROM  apps.wip_discrete_jobs wdj, 
            apps.fnd_lookup_values flv
      WHERE wdj.organization_id = x.organization_id
      AND wdj.wip_entity_id = x.transaction_source_id
      AND flv.lookup_code = wdj.status_type
      AND flv.lookup_type = 'WIP_JOB_STATUS'
      AND flv.language = 'PTB')                                                       tatus_op,
     CASE WHEN transaction_type_id IN ( 33, 141, 142, 143 ) THEN
    --   *** Sales Order Issue ***
        (SELECT 'NF : '|| substr(rcta.trx_number, 1, 15)|| ' PEDIDO : '|| substr(ooh.order_number, 1, 15)
         FROM   apps.oe_order_lines_all           ool,
                apps.oe_order_headers_all         ooh,
                apps.ra_customer_trx_all          rcta,
                apps.ra_customer_trx_lines_all    rctl
         WHERE  ool.line_id = x.trx_source_line_id
         AND ool.inventory_item_id = x.inventory_item_id
         AND ooh.header_id = ool.header_id
         AND rctl.customer_trx_id = rcta.customer_trx_id
         AND rctl.sales_order = ooh.order_number
         AND rctl.interface_line_attribute6 = ool.line_id
         AND ROWNUM = 1)
     ELSE
        (SELECT ' PEDIDO : '|| substr(ooha.order_number, 1, 15)
         FROM   apps.oe_order_headers_all    ooha,
                apps.oe_order_lines_all      oola
         WHERE  ooha.header_id = oola.header_id
         AND oola.line_id = x.trx_source_line_id
         AND oola.inventory_item_id = x.inventory_item_id
         AND ROWNUM = 1) 
     END                                                 num_nf_pedido_venda,
            --
     CASE WHEN transaction_type_id IN ( 18, 36 ) THEN--   *** Receiving ***
        (SELECT'NF: '|| substr(ri.invoice_num, 1, 15)|| ' RI: '|| substr(to_char(ri.operation_id), 1, 15)|| '  PEDIDO: '                        || ph.segment1
         FROM   apps.cll_f189_invoices       ri,
                apps.po_headers_all          ph,
                apps.rcv_shipment_headers    rsh,
                apps.rcv_transactions        rt
         WHERE  rt.transaction_id = x.rcv_transaction_id
         AND ph.po_header_id = rt.po_header_id
         AND rsh.shipment_header_id = rt.shipment_header_id
         AND to_char(ri.operation_id) = rsh.receipt_num
         AND ri.organization_id = x.organization_id
         AND ROWNUM = 1)
     ELSE
        (SELECT 'NF: '|| substr(ri.invoice_num, 1, 15)|| ' RI: '|| substr(to_char(ri.operation_id), 1, 15)
         FROM   apps.cll_f189_invoices ri
         WHERE  to_char(ri.operation_id) = x.transaction_reference
         AND ri.organization_id = x.organization_id
         AND ROWNUM = 1)
     END                           num_nf_pedido_compra
       --
FROM
     (SELECT
      cpp.period_name,
      gcc.code_combination_id,
      gcc.segment1,
      gcc.segment2,
      gcc.segment3,
      gcc.segment4,
      gcc.segment5,
      gcc.segment6,
      gcc.segment7,
      msi.concatenated_segments           item,
      msi.inventory_item_id,
      substr(msi.description, 1, 50)      descr_item,
      categ.categoria_produto,
      substr(caetv.description, 1, 50)    transacao,
      mmt.organization_id,
      mmt.transaction_id,
      trunc(mmt.transaction_date)         data_transacao,
      mmt.transaction_type_id,
      mmt.transaction_source_id,
      mmt.picking_line_id,
      mmt.trx_source_line_id,
      mmt.rcv_transaction_id,
      mmt.transaction_reference,
      sq.cost_element_id,
      SUM(nvl(mmt.primary_quantity, 0))  volume,
      SUM(nvl(round(sq.accounted_dr, 10), 0)) debito,
      SUM(nvl(round(sq.accounted_cr, 10), 0)) credito,
      SUM(nvl(round(sq.accounted_dr, 10), 0)) - SUM(nvl(round(sq.accounted_cr, 10), 0))lacto_contabil
      FROM  apps.cst_pac_periods                 cpp,
     (SELECT
      cal.code_combination_id,
      cah.accounting_event_id,
      cah.period_id,
      cal.cost_element_id,
      SUM(nvl(round(cal.accounted_dr, 10), 0))                 accounted_dr,
      SUM(nvl(round(cal.accounted_cr, 10), 0))                 accounted_cr
      FROM  apps.cst_ae_lines      cal,
            apps.cst_ae_headers    cah
      WHERE cal.ae_header_id = cah.ae_header_id
      AND cah.cost_group_id = (SELECT cost_group_id 
                               FROM   apps.cst_cost_groups ccg
                               WHERE  cost_group = 'GC_KCA') -----p_cost_group_id
      AND cah.cost_type_id = 1022  -- 1020 KMB / 1022 KCA------------ p_cost_type_id
      AND cah.period_id = (SELECT pac_period_id
                           FROM   apps.cst_pac_periods
                           WHERE  period_name = 'ABR-22'
                           AND legal_entity = (SELECT legal_entity
                                               FROM   apps.org_organization_definitions
                                               WHERE  organization_name = 'KCA_IO_AM_006'))----p_pac_period_id
      AND cah.acct_event_source_table = 'MMT'
      GROUP BY
      cal.code_combination_id,
      cah.accounting_event_id,
      cah.period_id,
      cal.cost_element_id)                  sq,
      apps.gl_code_combinations            gcc,
      apps.mtl_system_items_b_kfv          msi,
      apps.mtl_material_transactions       mmt,
      apps.cst_accounting_event_types_v    caetv,
     (SELECT
      mmt.transaction_id,
      mc.segment1|| '.'|| mc.segment2|| '.'|| mc.segment3|| '.'|| mc.segment4 categoria_produto
      FROM  apps.mtl_material_transactions    mmt,
            apps.mtl_item_categories          mic,
            apps.mtl_categories               mc
      WHERE mmt.transaction_id = mmt.transaction_id
      AND mmt.inventory_item_id = mic.inventory_item_id
      AND mmt.organization_id = mic.organization_id
      AND mic.category_set_id = 1100000063
      AND mc.category_id = mic.category_id
      AND mc.structure_id = 50450)              categ
      WHERE
      cpp.pac_period_id = sq.period_id
      AND sq.code_combination_id = gcc.code_combination_id
      AND sq.accounting_event_id = mmt.transaction_id
      AND categ.transaction_id = mmt.transaction_id (+)
      AND msi.organization_id = (SELECT organization_id
                                 FROM   apps.org_organization_definitions
                                 WHERE  organization_name = 'KCA_IO_AM_006') ----p_organization_id
      AND msi.inventory_item_id = mmt.inventory_item_id
      AND mmt.organization_id = nvl(mmt.owning_organization_id, mmt.organization_id)
      AND mmt.organization_id = (SELECT organization_id
                                 FROM   apps.org_organization_definitions
                                 WHERE organization_name = 'KCA_IO_AM_006') ----p_organization_id
      AND msi.inventory_item_id = mmt.inventory_item_id
      AND nvl(mmt.owning_tp_type, 2) = 2
    -------------                  AND mmt.transaction_source_id = 306034 ------------------< OP
      AND mmt.transaction_date <= trunc(to_date('30-ABR-2022')) +.99999
      AND mmt.transaction_date >= trunc(to_date('01-ABR-2022'))
      AND caetv.transaction_type_id = mmt.transaction_type_id
      AND caetv.transaction_action_id = mmt.transaction_action_id
      AND caetv.transaction_type_flag = 'INV'
      GROUP BY
      cpp.period_name,
      gcc.code_combination_id,
      gcc.segment1,
      gcc.segment2,
      gcc.segment3,
      gcc.segment4,
      gcc.segment5,
      gcc.segment6,
      gcc.segment7,
      msi.concatenated_segments,
      msi.inventory_item_id,
      substr(msi.description, 1, 50),
      categ.categoria_produto,
      substr(caetv.description, 1, 50),
      mmt.organization_id,
      mmt.transaction_id,
      trunc(mmt.transaction_date),
      mmt.transaction_type_id,
      mmt.transaction_source_id,
      mmt.picking_line_id,
      mmt.trx_source_line_id,
      mmt.rcv_transaction_id,
      mmt.transaction_reference,
      sq.cost_element_id) x
--            
UNION
--
-- Select 2 - WIP
--
SELECT
    (SELECT organization_code
     FROM   apps.org_organization_definitions
     WHERE  organization_id = x.organization_id)     organização,
     'WIP'                         origem_transacao,
     x.period_name,
     x.transaction_id,
     x.data_transacao,
     x.transacao,
     x.segment1,
     x.segment2,
     x.segment3,
     x.segment4,
     x.segment5,
     x.segment6,
     x.segment7,
     x.item,
     translate(x.descr_item, 'x'|| CHR(10)|| CHR(13), 'x') descr_item,
     x.categoria_produto,
     x.volume,
     CASE WHEN x.volume < 0 THEN 'SAIDA' 
     ELSE 'ENTRADA'
     END                        tipo_transação,
     x.debito,
     x.credito,
     x.lacto_contabil,
     decode(nvl(x.cost_element_id, 1), 1, 'Material', 2, 'Materia Overhead',3,'Resource',4,'Outside Processing',5,'Overhead',
     x.cost_element_id)    elemento_custo,
     (SELECT    substr(wip_entity_name, 1, 15)
      FROM      apps.wip_entities
      WHERE     wip_entity_id = x.transaction_id)   numero_op,
       --
     (SELECT    flv.meaning
      FROM      apps.wip_discrete_jobs    wdj,
                apps.fnd_lookup_values    flv
      WHERE     wdj.organization_id = x.organization_id
      AND wdj.wip_entity_id = x.transaction_id
      AND flv.lookup_code = wdj.status_type
      AND flv.lookup_type = 'WIP_JOB_STATUS'
      AND flv.language = 'PTB') status_op,
      --
      NULL  num_nf_pedido_venda,
      NULL  num_nf_pedido_compra
      -- 
FROM
    (SELECT
     cpp.period_name,
     gcc.code_combination_id,
     gcc.segment1,
     gcc.segment2,
     gcc.segment3,
     gcc.segment4,
     gcc.segment5,
     gcc.segment6,
     gcc.segment7,
     msi.segment1   item,
     wt.primary_item_id inventory_item_id,
     substr(msi.description, 1, 50) descr_item,
     categ.categoria_produto,
     substr(ml.meaning, 1, 25)  transacao,
     wt.organization_id,    
     wt.wip_entity_id   transaction_id,
     trunc(wt.transaction_date) data_transacao,
     NULL   transaction_type_id,
     NULL   transaction_source_id,
     NULL   picking_line_id,
     NULL   trx_source_line_id,
     NULL   rcv_transaction_id,
     NULL   transaction_reference,
     sq.cost_element_id,
     SUM(nvl(wt.primary_quantity, 0))   volume,
     SUM(nvl(round(sq.accounted_dr, 10), 0))    debito,
     SUM(nvl(round(sq.accounted_cr, 10), 0))    credito,
     SUM(nvl(round(sq.accounted_dr, 10), 0)) - SUM(nvl(round(sq.accounted_cr, 10), 0))  lacto_contabil
     FROM
     apps.cst_pac_periods           cpp,
     (SELECT    cal.code_combination_id,
                cah.accounting_event_id,
                cah.period_id,
                cal.cost_element_id,
                SUM(nvl(round(cal.accounted_dr, 10), 0))                 accounted_dr,
                SUM(nvl(round(cal.accounted_cr, 10), 0))                 accounted_cr
      FROM      apps.cst_ae_lines      cal,
                apps.cst_ae_headers    cah
      WHERE     cal.ae_header_id = cah.ae_header_id
      AND cah.cost_group_id = (SELECT   cost_group_id
                               FROM     apps.cst_cost_groups ccg
                               WHERE    cost_group = 'GC_KCA') -----p_cost_group_id
      AND cah.cost_type_id = 1022 -- 1020 KMB / 1022 KCA------------ p_cost_type_id
      AND cah.period_id = (SELECT       pac_period_id
                           FROM         apps.cst_pac_periods
                           WHERE        period_name = 'ABR-22'
                           AND legal_entity = (SELECT   legal_entity
                                               FROM     apps.org_organization_definitions
                                               WHERE    organization_name = 'KCA_IO_AM_006'))----p_pac_period_id
      AND cah.acct_event_source_table = 'WT'
      GROUP BY
      cal.code_combination_id,
      cah.accounting_event_id,
      cah.period_id,
      cal.cost_element_id)  sq,
      apps.gl_code_combinations      gcc,
      apps.wip_transactions          wt,
      apps.mtl_system_items_b_kfv    msi,
      apps.mfg_lookups               ml,
      (SELECT   mic.inventory_item_id,
                mic.organization_id,
                mc.segment1|| '.'|| mc.segment2|| '.'|| mc.segment3|| '.'|| mc.segment4 categoria_produto
       FROM     apps.mtl_item_categories    mic,
                apps.mtl_categories         mc
       WHERE    mic.category_set_id = 1100000063
       AND mc.category_id = mic.category_id
       AND mc.structure_id = 50450) categ
       WHERE
       cpp.pac_period_id = sq.period_id
       AND sq.code_combination_id = gcc.code_combination_id
       AND sq.accounting_event_id = wt.transaction_id
       AND categ.inventory_item_id = wt.primary_item_id (+)
       AND categ.organization_id = wt.organization_id (+)
       AND wt.organization_id = (SELECT organization_id
                                 FROM   apps.org_organization_definitions
                                 WHERE  organization_name = 'KCA_IO_AM_006') ----p_organization_id
      -------------                  AND wt.wip_entity_id   = 306034 -----------------------< OP
       AND wt.transaction_date <= trunc(to_date('30-ABR-2022')) +.99999
       AND wt.transaction_date >= trunc(to_date('01-ABR-2022'))
       AND msi.organization_id = wt.organization_id (+)
       AND msi.inventory_item_id = wt.primary_item_id (+)
       AND ml.lookup_code = wt.transaction_type
       AND ml.lookup_type = 'WIP_TRANSACTION_TYPE_SHORT'
       GROUP BY
       cpp.period_name,
       gcc.code_combination_id,
       gcc.segment1,
       gcc.segment2,
       gcc.segment3,
       gcc.segment4,
       gcc.segment5,
       gcc.segment6,
       gcc.segment7,
       wt.primary_item_id,
       msi.segment1,
       categ.categoria_produto,
       substr(msi.description, 1, 50),
       substr(ml.meaning, 1, 25),
       wt.organization_id,
       wt.wip_entity_id,
       trunc(wt.transaction_date),
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       sq.cost_element_id) x;
                                               