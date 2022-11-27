SELECT DISTINCT rct_ret.customer_trx_id       trx_id
              , rct_ret.trx_number            Nota_retorno_ar   
              , RCTL_RET.GLOBAL_ATTRIBUTE1    CFOP
              , CFTDT.DEVOLUTION_OPERATION_ID RI_RETORNO
              , MSI_RET.SEGMENT1              COD_PRODUTO_RETORNO 
              , MSI_RET.DESCRIPTION           PRODUTO_RETORNO
              , CFTDT.OPERATION_ID            RI_REMESSA
              , RCTL_REM.GLOBAL_ATTRIBUTE1    CFOP_REMESSA
              , RCTA.TRX_NUMBER               NOTA_AR_REMESSA
              , MSI_RET.SEGMENT1              COD_PRODUTO_REMESSA
              , MSI_RET.DESCRIPTION           PRODUTO_REMESSA
              , ELECTRONIC_INV_ACCESS_KEY     CHAVE_ACESSO_REM
              , SUBSTR(rctl_ret.INTERFACE_LINE_ATTRIBUTE8,0,(INSTR(rctl_ret.INTERFACE_LINE_ATTRIBUTE8,'.')-1)) ESO
              ,(SELECT DISTINCT we.WIP_ENTITY_NAME        "OP_KMB"
                    FROM apps.oe_order_lines_all         oola
                       , apps.oe_order_headers_all       ooha
                       , apps.wip_entities                we   
                       , apps.wip_discrete_jobs           wdj
                       , apps.mtl_system_items_b          msib
                       , apps.dtt_wip_programacao_op_v    dwp 
                       , apps.dtt_wip_job_details_v       dwj
                       , apps.dtt_wip_op_assoc_op_detail  dwo
                   WHERE ooha.header_id       = oola.header_id
                     AND oola.line_id         = dwo.oe_line_id
                     AND we.wip_entity_id     = wdj.wip_entity_id
                     AND wdj.wip_entity_id    = dwp.wip_entity_id
                     AND wdj.organization_id  = we.organization_id
                     AND wdj.organization_id  = dwp.organization_id
                     AND we.primary_item_id   = msib.inventory_item_id
                     AND we.organization_id   = msib.organization_id
                     AND dwo.job_master_id    = we.wip_entity_id
                     AND dwo.job_detail_id    = dwj.JOB_DETAIL_ID                          
                     AND ooha.ORDER_NUMBER    = REGEXP_SUBSTR(rctl_ret.INTERFACE_LINE_ATTRIBUTE8,'[^.$]+')) OP
                    ,( SELECT DISTINCT MSIB.ATTRIBUTE1
                      FROM apps.oe_order_lines_all         oola
                         , apps.oe_order_headers_all       ooha
                         , apps.wip_entities                we   
                         , apps.wip_discrete_jobs           wdj
                         , apps.mtl_system_items_b          msib
                         , apps.dtt_wip_programacao_op_v    dwp 
                         , apps.dtt_wip_job_details_v       dwj
                         , apps.dtt_wip_op_assoc_op_detail  dwo
                     WHERE ooha.header_id         = oola.header_id
                       AND oola.line_id       = dwo.oe_line_id
                       AND we.wip_entity_id     = wdj.wip_entity_id
                       AND wdj.wip_entity_id    = dwp.wip_entity_id
                       AND wdj.organization_id  = we.organization_id
                       AND wdj.organization_id  = dwp.organization_id
                       AND we.primary_item_id   = msib.inventory_item_id
                       AND we.organization_id   = msib.organization_id
                       AND dwo.job_master_id    = we.wip_entity_id
                       AND dwo.job_detail_id    = dwj.JOB_DETAIL_ID                          
                       AND ooha.ORDER_NUMBER = REGEXP_SUBSTR(rctl_ret.INTERFACE_LINE_ATTRIBUTE8,'[^.$]+') ) MOD
                       , ( SELECT DISTINCT CASE WHEN dwj.DETAIL_ASSEMBLY_TYPE = 'MOTOR' THEN
                             dwp.nr_motor
                           WHEN dwj.DETAIL_ASSEMBLY_TYPE = 'CHASSI' THEN
                             dwp.nr_chassi
                           END "CHASSI_MOTOR"
                      FROM apps.oe_order_lines_all         oola
                         , apps.oe_order_headers_all       ooha
                         , apps.wip_entities                we   
                         , apps.wip_discrete_jobs           wdj
                         , apps.mtl_system_items_b          msib
                         , apps.dtt_wip_programacao_op_v    dwp 
                         , apps.dtt_wip_job_details_v       dwj
                         , apps.dtt_wip_op_assoc_op_detail  dwo
                     WHERE ooha.header_id         = oola.header_id
                       AND oola.line_id       = dwo.oe_line_id
                       AND we.wip_entity_id     = wdj.wip_entity_id
                       AND wdj.wip_entity_id    = dwp.wip_entity_id
                       AND wdj.organization_id  = we.organization_id
                       AND wdj.organization_id  = dwp.organization_id
                       AND we.primary_item_id   = msib.inventory_item_id
                       AND we.organization_id   = msib.organization_id
                       AND dwo.job_master_id    = we.wip_entity_id
                       AND dwo.job_detail_id    = dwj.JOB_DETAIL_ID                          
                       AND ooha.ORDER_NUMBER    = REGEXP_SUBSTR(rctl_ret.INTERFACE_LINE_ATTRIBUTE8,'[^.$]+') ) CHASSI
from
apps.ra_customer_trx_all            rct_ret
, apps.ra_customer_trx_lines_all      rctl_ret
, apps.ra_batch_sources_all           rbsa
, apps.cll_f189_invoices          ri_ret
, apps.cll_f189_invoice_lines     ril_ret
, apps.cll_f513_tpa_dev_trans_assoc_v cftdt
, apps.ra_customer_trx_lines_all      rctl_rem
, apps.cll_f189_invoices          ri_rem
, apps.mtl_system_items_b             msi_ret
, apps.ra_customer_trx_all            rcta
, apps.cll_f189_invoice_lines     ril_rem
, apps.ra_batch_sources_all           rbsa_rem
, apps.mtl_system_items_b             msi_rem
, apps.JL_BR_CUSTOMER_TRX_EXTS        jbcte  



WHERE rct_ret.customer_trx_id            = rctl_ret.customer_trx_id
AND rct_ret.customer_trx_id            = 1150944
AND rct_ret.BATCH_SOURCE_ID            = rbsa.BATCH_SOURCE_ID
AND rct_ret.cust_trx_type_id           = 15012
AND ri_ret.series                      = rbsa.global_attribute3
AND rctl_ret.interface_line_attribute3 = to_char(ri_ret.invoice_id)
AND ri_ret.operation_id                = cftdt.devolution_operation_id
AND rctl_ret.warehouse_id              = ri_ret.organization_id
AND rctl_rem.LINE_TYPE                 = 'LINE'
AND ri_ret.invoice_id                  = ril_ret.invoice_id
--AND cftdt.QUERY_ONLY                   = 'NO'
AND rctl_ret.inventory_item_id         = ril_ret.item_id
AND cftdt.dev_inventory_item_id        = rctl_ret.inventory_item_id
AND cftdt.operation_id                 = ri_rem.operation_id
AND cftdt.DEV_ORGANIZATION_ID          = ri_rem.Organization_Id
AND rctl_ret.inventory_item_id         = msi_ret.inventory_item_id
AND rctl_ret.warehouse_id              = msi_ret.organization_id
AND rcta.trx_number                    = TO_CHAR(ri_rem.invoice_num)
AND rcta.cust_trx_type_id              = 13030
AND rcta.customer_trx_id               = rctl_rem.customer_trx_id
AND ri_rem.invoice_id                  = ril_rem.invoice_id
AND rctl_rem.inventory_item_id         = ril_rem.item_id
AND rcta.batch_source_id               = rbsa_rem.batch_source_id
AND ri_rem.series                      = to_number(rbsa_rem.global_attribute3)
AND rctl_rem.inventory_item_id         = msi_rem.inventory_item_id
AND rctl_rem.warehouse_id              = msi_rem.organization_id
AND rcta.customer_trx_id               = jbcte.customer_trx_id 