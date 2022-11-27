-- 
-- Select 1 - MTL
--
select ( select organization_code
           from apps.org_organization_definitions
          where organization_id = x.organization_id ) Organização,
       'MTL' Origem_transacao, x.period_name, x.transaction_id, x.data_transacao, x.transacao,
       x.segment1, x.segment2, x.segment3, x.segment4, x.segment5, x.segment6, x.segment7,
       x.item, 
       TRANSLATE(x.descr_item, 'x'||CHR(10)||CHR(13), 'x') descr_item, 
       x.categoria_produto, 
       x.volume, 
       case when x.volume < 0 then 
            'SAIDA'
       else
            'ENTRADA'
       end   tipo_transação,
       x.debito, x.credito, x.Lacto_contabil, 
       decode(nvl(x.cost_element_id,1), 1, 'Material', 
                                2, 'Materia Overhead', 
                                3, 'Resource',
                                4, 'Outside Processing',
                                5, 'Overhead', 
                                x.cost_element_id )            Elemento_Custo,
       --                         
       case when transaction_type_id in (35,17,43,44,25,90,91) then
       --   *** Assembly Completion ***
       --   *** WIP Component issue ***
            (  select substr(wip_entity_name, 1, 15)
                 from apps.wip_entities
                where wip_entity_id = x.transaction_source_id)
       end                                                     numero_op,
       --
       ( select FLV.MEANING
           from apps.wip_discrete_jobs wdj, apps.fnd_lookup_values flv
          where wdj.organization_id = x.organization_id
            and wdj.wip_entity_id   = x.transaction_source_id
            and flv.lookup_code = wdj.status_type
            and flv.lookup_type = 'WIP_JOB_STATUS'
            and flv.language    = 'PTB'    )                   status_op,
       --
       case when transaction_type_id in ( 33, 141,142, 143 ) then
       --   *** Sales Order Issue ***
            ( select 'NF : '||substr(rcta.trx_number, 1, 15)||
                     ' PEDIDO : '||substr(ooh.order_number,1, 15)
                  -- rcta.trx_number, rcta.trx_date, rcta.customer_trx_id, ooh.order_number, ooh.org_id, ooh.header_id,
                  -- ool.line_id, rctl.customer_trx_id, rctl.inventory_item_id, rctl.unit_selling_price
                from apps.oe_order_lines_all ool, 
                     apps.oe_order_headers_all ooh,
                     apps.ra_customer_trx_all rcta, 
                     apps.ra_customer_trx_lines_all rctl
               where ool.line_id           =  x.trx_source_line_id
                and  ool.inventory_item_id =  x.inventory_item_id
                and  ooh.header_id         = ool.header_id
                and  rctl.customer_trx_id  = rcta.customer_trx_id
                and  rctl.sales_order      = ooh.order_number
                and  rctl.interface_line_attribute6 = ool.line_id
                 and rownum = 1 )
        else
            ( select ' PEDIDO : '||substr(ooha.order_number,1, 15)
                from apps.oe_order_headers_all ooha,
                     apps.oe_order_lines_all   oola
               where ooha.header_id            = oola.header_id
                 and oola.line_id              = x.trx_source_line_id
                 and oola.inventory_item_id    = x.inventory_item_id
                 and rownum = 1 )
        end                                               Num_NF_Pedido_Venda,
        --
        case when transaction_type_id in (18, 36) then
        --   *** Receiving ***
             ( select 'NF: '||substr(ri.invoice_num,1,15)||' RI: '||substr(to_char(ri.operation_id), 1, 15)||
                      '  PEDIDO: '||ph.segment1
                 from apps.cll_f189_invoices    ri,
                      apps.po_headers_all       ph,
                      apps.rcv_shipment_headers rsh,
                      apps.rcv_transactions     rt
                where rt.transaction_id         =  x.rcv_transaction_id
                  and ph.po_header_id           =  rt.po_header_id
                  and rsh.shipment_header_id    =  rt.shipment_header_id
                  and to_char(ri.operation_id)  =  rsh.receipt_num
                  and ri.organization_id        =  x.organization_id
                  and rownum = 1 )
        else
         ( select 'NF: '||substr(ri.invoice_num,1,15)||' RI: '||substr(to_char(ri.operation_id), 1, 15)
             from apps.cll_f189_invoices ri
            where to_char(ri.operation_id) = x.transaction_reference
              and ri.organization_id = x.organization_id
              and rownum = 1 )
        end                                        Num_NF_Pedido_Compra
   --
   from (select cpp.period_name,
                gcc.code_combination_id,
                gcc.segment1,
                gcc.segment2,
                gcc.segment3,
                gcc.segment4,
                gcc.segment5,
                gcc.segment6,
                gcc.segment7,
                msi.concatenated_segments item,
                msi.inventory_item_id,
                substr(msi.description,1,50)   descr_item,
                categ.categoria_produto,
                substr(caetv.description,1,50) transacao,
                mmt.organization_id,
                mmt.transaction_id,
                trunc(mmt.transaction_date) data_transacao,
                mmt.transaction_type_id,
                mmt.transaction_source_id,
                mmt.picking_line_id,
                mmt.trx_source_line_id,
                mmt.rcv_transaction_id,
                mmt.transaction_reference,
                sq.cost_element_id,
                sum(nvl(mmt.primary_quantity, 0))     volume,
                sum(nvl(round(sq.accounted_dr,10),0)) debito,
                sum(nvl(round(sq.accounted_cr,10),0)) credito,
                sum(nvl(round(sq.accounted_dr,10),0))-sum(nvl(round(sq.accounted_cr,10),0)) Lacto_contabil
           from apps.cst_pac_periods cpp
              , (select cal.code_combination_id,
                        cah.accounting_event_id,
                        cah.period_id,
                        cal.cost_element_id,
                        sum(nvl(round(cal.accounted_dr,10),0)) accounted_dr,
                        sum(nvl(round(cal.accounted_cr,10),0)) accounted_cr
                   from apps.cst_ae_lines   cal
                      , apps.cst_ae_headers cah
                  where cal.ae_header_id = cah.ae_header_id
                    AND cah.cost_group_id = ( select cost_group_id
                                                from apps.cst_cost_groups ccg
                                               where cost_group = 'GC_KMB' ) -----p_cost_group_id
                    AND cah.cost_type_id =  1020  -- 1020 KMB / 1022 KCA------------ p_cost_type_id
                    AND cah.period_id   = ( select pac_period_id
                                                 from apps.cst_pac_periods
                                                where period_name = 'ABR-22'
                                                  and legal_entity = ( select legal_entity
                                                                         from APPS.ORG_ORGANIZATION_DEFINITIONS
                                                                        where organization_name = 'KMB_IO_AM_001'))----p_pac_period_id
                    AND cah.acct_event_source_table = 'MMT'
                   group by cal.code_combination_id,
                            cah.accounting_event_id,
                            cah.period_id,
                            cal.cost_element_id ) sq
              , apps.gl_code_combinations gcc
              , apps.mtl_system_items_b_kfv msi
              , apps.mtl_material_transactions mmt
              , apps.cst_accounting_event_types_v caetv
              , ( select mmt.transaction_id, 
                         mc.segment1 || '.' || mc.segment2 || '.' || 
                         mc.segment3|| '.' || mc.segment4   categoria_produto
                   from apps.mtl_material_transactions     mmt
                      , apps.mtl_item_categories           mic
                      , apps.mtl_categories                mc
                  where mmt.transaction_id      = mmt.transaction_id
                    and mmt.inventory_item_id   = mic.inventory_item_id
                    and mmt.organization_id     = mic.organization_id
                    and mic.category_set_id     = 1100000063
                    and mc.category_id          = mic.category_id
                    and mc.structure_id         = 50450 )                categ
          WHERE cpp.pac_period_id = sq.period_id
            AND sq.code_combination_id = gcc.code_combination_id
            AND sq.accounting_event_id = mmt.transaction_id
            AND categ.transaction_id   = mmt.transaction_id (+)
            AND msi.organization_id = ( select organization_id
                                          from APPS.ORG_ORGANIZATION_DEFINITIONS
                                         where organization_name = 'KMB_IO_AM_001' ) ----p_organization_id
            AND msi.inventory_item_id = mmt.inventory_item_id
            AND mmt.organization_id = nvl(mmt.owning_organization_id, mmt.organization_id)
            AND mmt.organization_id = ( select organization_id
                                          from APPS.ORG_ORGANIZATION_DEFINITIONS
                                         where organization_name = 'KMB_IO_AM_001' ) ----p_organization_id
            AND msi.inventory_item_id = mmt.inventory_item_id
            AND nvl(mmt.owning_tp_type,2) = 2
-------------                  AND mmt.transaction_source_id = 306034 ------------------< OP
            AND mmt.transaction_date <= TRUNC(TO_DATE('30-ABR-2022')) + .99999
            AND mmt.transaction_date >= TRUNC(TO_DATE('01-ABR-2022')) 
            AND caetv.transaction_type_id = mmt.transaction_type_id
            AND caetv.transaction_action_id = mmt.transaction_action_id
            AND caetv.transaction_type_flag = 'INV'
          group by cpp.period_name,
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
                substr(msi.description,1,50),
                categ.categoria_produto,
                substr(caetv.description,1,50),
                mmt.organization_id,
                mmt.transaction_id,
                trunc(mmt.transaction_date),
                mmt.transaction_type_id,
                mmt.transaction_source_id,
                mmt.picking_line_id,
                mmt.trx_source_line_id,
                mmt.rcv_transaction_id,
                mmt.transaction_reference,
                sq.cost_element_id
            ) x
--            
UNION
--
-- Select 2 - WIP
--
select ( select organization_code
           from apps.org_organization_definitions
          where organization_id = x.organization_id ) Organização,
       'WIP' Origem_transacao, x.period_name, x.transaction_id, x.data_transacao, x.transacao,
       x.segment1, x.segment2, x.segment3, x.segment4, x.segment5, x.segment6, x.segment7,
       x.item, 
       TRANSLATE(x.descr_item, 'x'||CHR(10)||CHR(13), 'x') descr_item,
       x.categoria_produto, x.volume, 
       case when x.volume < 0 then 
            'SAIDA'
       else
            'ENTRADA'
       end   tipo_transação,
       x.debito, x.credito, x.Lacto_contabil,       
       decode(nvl(x.cost_element_id,1), 1, 'Material', 
                                      2, 'Materia Overhead', 
                                      3, 'Resource',
                                      4, 'Outside Processing',
                                      5, 'Overhead', 
                                      x.cost_element_id )            Elemento_Custo,
       --   *** Assembly Completion ***
       --   *** WIP Component issue ***
       ( select substr(wip_entity_name, 1, 15)
           from apps.wip_entities
          where wip_entity_id = x.transaction_id )  numero_op,
       --
       ( select FLV.MEANING
           from apps.wip_discrete_jobs wdj, apps.fnd_lookup_values flv
          where wdj.organization_id = x.organization_id
            and wdj.wip_entity_id   = x.transaction_id
            and flv.lookup_code = wdj.status_type
            and flv.lookup_type = 'WIP_JOB_STATUS'
            and flv.language    = 'PTB'    )           status_op,
      --
      null                                             Num_NF_Pedido_Venda,
      null                                             Num_NF_Pedido_Compra
      -- 
      from (  select cpp.period_name,
                     gcc.code_combination_id,
                     gcc.segment1,
                     gcc.segment2,
                     gcc.segment3,
                     gcc.segment4,
                     gcc.segment5,
                     gcc.segment6,
                     gcc.segment7,
                     msi.segment1         item,
                     wt.primary_item_id   INVENTORY_ITEM_ID,
                     substr(msi.description,1,50)      descr_item,
                     categ.categoria_produto,
                     substr(ml.meaning,1,25) transacao,
                     wt.organization_id,
                     wt.wip_entity_id  transaction_id,
                     trunc(wt.transaction_date) data_transacao,
                     null    transaction_type_id,
                     null    transaction_source_id,
                     null    picking_line_id,
                     null    trx_source_line_id,
                     null    rcv_transaction_id,
                     null    transaction_reference,
                     sq.cost_element_id,
                     sum(nvl(wt.primary_quantity, 0))      volume,
                     sum(nvl(round(sq.accounted_dr,10),0)) debito,
                     sum(nvl(round(sq.accounted_cr,10),0)) credito,
                     sum(nvl(round(sq.accounted_dr,10),0))-sum(nvl(round(sq.accounted_cr,10),0)) Lacto_contabil
                from apps.cst_pac_periods cpp
                   , (select cal.code_combination_id,
                             cah.accounting_event_id,
                             cah.period_id,
                             cal.cost_element_id,
                             sum(nvl(round(cal.accounted_dr,10),0)) accounted_dr,
                             sum(nvl(round(cal.accounted_cr,10),0)) accounted_cr
                        from apps.cst_ae_lines   cal
                           , apps.cst_ae_headers cah
                       where cal.ae_header_id = cah.ae_header_id
                         AND cah.cost_group_id = ( select cost_group_id
                                                from apps.cst_cost_groups ccg
                                               where cost_group = 'GC_KMB' ) -----p_cost_group_id
                         AND cah.cost_type_id = 1020  -- 1020 KMB / 1022 KCA------------ p_cost_type_id
                         AND cah.period_id = ( select pac_period_id
                                                 from apps.cst_pac_periods
                                                where period_name = 'ABR-22'
                                                  and legal_entity = ( select legal_entity
                                                                         from APPS.ORG_ORGANIZATION_DEFINITIONS
                                                                        where organization_name = 'KMB_IO_AM_001'))----p_pac_period_id
                         AND cah.acct_event_source_table = 'WT'
                       group by cal.code_combination_id,
                                cah.accounting_event_id,
                                cah.period_id,
                                cal.cost_element_id ) sq
                   , apps.gl_code_combinations gcc
                   , apps.wip_transactions wt
                   , apps.mtl_system_items_b_kfv msi
                   , apps.mfg_lookups ml
                   , ( select mic.inventory_item_id, mic.organization_id , 
                        mc.segment1 || '.' || mc.segment2 || '.' || 
                        mc.segment3|| '.' || mc.segment4   categoria_produto
                  from  apps.mtl_item_categories           mic
                      , apps.mtl_categories                mc
                  where mic.category_set_id     = 1100000063
                    and mc.category_id          = mic.category_id
                    and mc.structure_id         = 50450 )                categ
                 WHERE cpp.pac_period_id = sq.period_id
                   AND sq.code_combination_id = gcc.code_combination_id
                   AND sq.accounting_event_id = wt.transaction_id
                   AND categ.inventory_item_id   = wt.primary_item_id (+)
                   AND categ.organization_id     = wt.organization_id  (+)
                   AND wt.organization_id        = ( select organization_id
                                                       from APPS.ORG_ORGANIZATION_DEFINITIONS
                                                      where organization_name = 'KMB_IO_AM_001' ) ----p_organization_id
      -------------                  AND wt.wip_entity_id   = 306034 -----------------------< OP
                  AND wt.transaction_date <= TRUNC(TO_DATE('30-ABR-2022')) + .99999
                  AND wt.transaction_date >= TRUNC(TO_DATE('01-ABR-2022'))
                  AND msi.organization_id   = wt.organization_id (+)
                  AND msi.inventory_item_id = wt.primary_item_id (+)
                  AND ml.lookup_code = wt.transaction_type
                  AND ml.lookup_type = 'WIP_TRANSACTION_TYPE_SHORT'
              group by cpp.period_name,
                       gcc.code_combination_id,
                       gcc.segment1,
                       gcc.segment2,
                       gcc.segment3,
                       gcc.segment4,
                       gcc.segment5,
                       gcc.segment6,
                       gcc.segment7,
                       wt.primary_item_id, msi.segment1, categ.categoria_produto, substr(msi.description,1,50),
                       substr(ml.meaning,1,25),
                       wt.organization_id,
                       wt.wip_entity_id, 
                       trunc(wt.transaction_date),
                       null, null, null, null,null, null,
                       sq.cost_element_id
            ) x;
   
   