SELECT ooh.order_number                   ESO
     , rcta.trx_number                    NOTA
     , rcta.trx_date                      
     , rctl.global_attribute1             CFOP
     , (SELECT DISTINCT pha.SEGMENT1
          FROM apps.po_headers_all             pha
             , apps.po_distributions_all       pda
             , apps.po_req_distributions_all   prda
             , apps.po_requisition_lines_all   prla
             , apps.po_requisition_headers_all prha
         WHERE pha.po_header_id           = pda.po_header_id
           AND pda.req_distribution_id    = prda.distribution_id
           AND prda.requisition_line_id   = prla.requisition_line_id
           AND prha.interface_source_code = 'KMB_WIP'
           AND prha.type_lookup_code      = 'PURCHASE'
           AND prha.authorization_status  = 'APPROVED'
           AND prla.requisition_header_id = prha.requisition_header_id
           AND prha.segment1              = ooh.ORIG_SYS_DOCUMENT_REF
           AND pha.CANCEL_FLAG            = 'N'
           and rownum = 1) PO_NUMBER
              , ( SELECT we.WIP_ENTITY_NAME        "OP_KMB"
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
                     AND ooha.header_id       = ooh.header_id 
                     and rownum = 1) OP
                , ( SELECT MSIB.ATTRIBUTE1
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
                       AND ooha.header_id       = ooh.header_id 
                       and rownum = 1) MODELO              
                , (SELECT CASE WHEN dwj.DETAIL_ASSEMBLY_TYPE = 'MOTOR' THEN
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
                       AND ooha.header_id       = ooh.header_id 
                       and rownum = 1 ) CHASSI      , ooh.header_id     
  FROM apps.oe_order_headers_all      ooh
     , apps.oe_order_lines_all        ool
     , apps.ra_customer_trx_all       rcta
     , apps.ra_customer_trx_lines_all rctl
 WHERE ooh.header_id = ool.header_id
   AND rcta.interface_header_context = 'ORDER ENTRY'
   AND rctl.interface_line_context = 'ORDER ENTRY'
   AND rctl.interface_line_attribute1 = TO_CHAR(ooh.order_number)
   AND rctl.interface_line_attribute6 = TO_CHAR(ool.line_id)
   AND rctl.customer_trx_id = rcta.customer_trx_id
   AND rctl.global_attribute1 IN (5109,5124)
   AND rcta.customer_trx_id in ('1136947');
