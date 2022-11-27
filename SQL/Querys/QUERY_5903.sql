SELECT DISTINCT rct_ret.customer_trx_id       trx_id
              , rct_ret.trx_number            Nota_retorno_ar   
              , rctl_ret.GLOBAL_ATTRIBUTE1    cfop
              , cftdt.devolution_operation_id ri_retorno
              , msi_ret.segment1              cod_produto_retorno 
              , msi_ret.DESCRIPTION           produto_retorno
              , cftdt.operation_id            ri_remessa
              , rctl_rem.GLOBAL_ATTRIBUTE1    cfop_remessa
              , rcta.trx_number               nota_ar_remessa
              , cftdt.returned_quantity       qtd
              , msi_ret.segment1              cod_produto_remessa
              , msi_ret.DESCRIPTION           produto_remessa
              , ELECTRONIC_INV_ACCESS_KEY     chave_acesso_rem 
              , SUBSTR(rctl_ret.INTERFACE_LINE_ATTRIBUTE8,0,(INSTR(rctl_ret.INTERFACE_LINE_ATTRIBUTE8,'.')-1)) ESO            
  FROM apps.ra_customer_trx_all            rct_ret
     , apps.ra_customer_trx_lines_all      rctl_ret
     , apps.ra_batch_sources_all           rbsa
     , apps.cll_f189_invoices          ri_ret
     , apps.cll_f189_invoice_lines     ril_ret
     , apps.cll_f513_tpa_dev_trans_assoc_v cftdt
     , apps.cll_f189_invoices          ri_rem
     , apps.mtl_system_items_b             msi_ret
     , apps.ra_customer_trx_all            rcta
     , apps.cll_f189_invoice_lines     ril_rem
     , apps.ra_customer_trx_lines_all      rctl_rem
     , apps.ra_batch_sources_all           rbsa_rem
     , apps.mtl_system_items_b             msi_rem
     , apps.JL_BR_CUSTOMER_TRX_EXTS        jbcte
    -- , apps.oe_order_headers_all           ooh
  --   , apps.oe_order_lines_all             ool
 WHERE rct_ret.customer_trx_id            = rctl_ret.customer_trx_id
   AND rct_ret.BATCH_SOURCE_ID            = rbsa.BATCH_SOURCE_ID
   AND rct_ret.cust_trx_type_id           = 15013
   AND ri_ret.series                      = rbsa.global_attribute3
   AND rctl_ret.interface_line_attribute3 = to_char(ri_ret.invoice_id)
   AND ri_ret.operation_id                = cftdt.devolution_operation_id
   AND rctl_ret.warehouse_id              = ri_ret.organization_id
   AND rctl_rem.LINE_TYPE                 = 'LINE'
   AND ri_ret.invoice_id                  = ril_ret.invoice_id
   AND cftdt.QUERY_ONLY                   = 'NO'
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
   --AND ooh.header_id                      = ool.header_id
 --  AND rctl_rem.interface_line_attribute1 = TO_CHAR(ooh.order_number)
  -- AND rctl_rem.interface_line_attribute6 = TO_CHAR(ool.line_id)
   --AND rct_ret.customer_trx_id            = 1140935 