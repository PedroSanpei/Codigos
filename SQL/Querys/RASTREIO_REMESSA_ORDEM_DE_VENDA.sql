SELECT DISTINCT
    A.order_number                              "KMB_ORDEM_VENDA",
    A.trx_number                                "KMB_NF_REMESSA",
    A.NAME                                      "KMB_TIPO_ORDEM",
    A.segment1                                  "1-KMB_ITEM_TRANSACIONADO",    
    A.transaction_type_name                     "1-KMB_TRANSAÇÃO",
    A.transaction_quantity                      "1-KMB_QTD_TRANSACIONADA",
    A.subinventory_code                         "1-KMB_SUBINVENTARIO",
    A.organization_code                         "1-KMB_ORG_TRANSAÇÃO",
    to_char(A.creation_date, 'dd/mm/yy hh:mm')  "1-KMB_DATA_TRANSAÇÃO",
    C.segment1                                  "2-KMB_ITEM_TRANSACIONADO",    
    C.transaction_type_name                     "2-KMB_TRANSAÇÃO",
    C.transaction_quantity                      "2-KMB_QTD_TRANSACIONADA",
    C.subinventory_code                         "2-KMB_SUBINVENTARIO",
    C.organization_code                         "2-KMB_ORG_TRANSAÇÃO",
    to_char(C.creation_date, 'dd/mm/yy hh:mm')  "2-KMB_DATA_TRANSAÇÃO",
    B.segment1                                  "3-KMB_ITEM_TRANSACIONADO",    
    B.transaction_type_name                     "3-KMB_TRANSAÇÃO",
    B.transaction_quantity                      "3-KMB_QTD_TRANSACIONADA",
    B.subinventory_code                         "3-KMB_SUBINVENTARIO",
    B.organization_code                         "3-KMB_ORG_TRANSAÇÃO",
    to_char(B.creation_date, 'dd/mm/yy hh:mm')  "3-KMB_DATA_TRANSAÇÃO",
    D.segment1                                  "4-KMB_ITEM_TRANSACIONADO",    
    D.transaction_type_name                     "4-KMB_TRANSAÇÃO",
    D.transaction_quantity                      "4-KMB_QTD_TRANSACIONADA",
    D.subinventory_code                         "4-KMB_SUBINVENTARIO",
    D.organization_code                         "4-KMB_ORG_TRANSAÇÃO",
    to_char(D.creation_date, 'dd/mm/yy hh:mm')  "4-KMB_DATA_TRANSAÇÃO",
    F.segment1                                  "7-KMB_ITEM_TRANSACIONADO",
    F.transaction_type_name                     "7-KMB_TRANSAÇÃO",
    F.SOMA_QUANTIDADE_SAÍDA                     "7-KMB_SOMA_QTD_SAÍDA",
    F.subinventory_code                         "7-KMB_SUBINVENTARIO",
    F.organization_code                         "7-KMB_KMB_ORG_TRANSAÇÃO",
    G.segment1                                  "8-KMB_ITEM_TRANSACIONADO",
    G.transaction_type_name                     "8-KMB_TRANSAÇÃO",
    G.soma_quantidade_entrada                   "8-KMB_SOMA_QTD_ENTRADA",
    G.subinventory_code                         "8-KMB_SUBINVENTARIO",
    G.organization_code                         "8-KMB_KMB_ORG_TRANSAÇÃO",
    E.operation_id                              "5-KCA_RI",
    E.invoice_num                               "5-KCA_NUM_REMESSA",
    E.segment1                                  "5-KCA_ITEM_TRANSACIONADO", 
    E.transaction_type_name                     "5-KCA_TRANSAÇÃO",
    E.transaction_quantity                      "5-KCA_QTD_TRANSACIONADA",
    E.subinventory_code                         "5-KCA_SUBINVENTÁRIO",
    E.organization_code                         "5-KCA_ORG_TRANSAÇÃO",
    to_char(E.creation_date, 'dd/mm/yy hh:mm')  "5-KCA_DATA_TRANSAÇÃO",
    H.segment1                                  "6-KCA_ITEM_TRANSACIONADO",     
    H.transaction_type_name                     "6-KCA_TRANSAÇÃO",
    H.subinventory_code                         "6-KCA_SUBINVENTÁRIO",
    H.SOMA_QUANTIDADE_DEVOLVIDA                 "6-KCA_SOMA_QTD_DEVOLVIDA",
    H.organization_code                         "6-KCA_ORG_TRANSAÇÃO",
    H.NFS_DEVOLUÇÃO                             "6-KCA_NF_DEVOLUÇÃO"
FROM 
(SELECT
    mtt.source_line_id,
    ooha.order_type_id,
    ottl.name,
    ooha.order_number,
    rcta.trx_number,
    mtt.transaction_id,
    mtt.creation_date,
    ood.organization_code,
    msib.inventory_item_id,
    msib.segment1,
    mtt.subinventory_code,
    mtt.transaction_type_id,
    mttp.transaction_type_name,
    mtt.transaction_quantity
FROM
         apps.mtl_material_transactions      mtt
    JOIN apps.oe_order_lines_all             oola    ON mtt.source_line_id = oola.line_id
    JOIN apps.oe_order_headers_all           ooha    ON oola.header_id = ooha.header_id
    JOIN apps.oe_transaction_types_tl        ottl    ON ooha.order_type_id = ottl.transaction_type_id
    JOIN apps.org_organization_definitions   ood     ON mtt.organization_id = ood.organization_id
    JOIN apps.mtl_system_items_b             msib    ON mtt.inventory_item_id = msib.inventory_item_id
                                                AND mtt.organization_id = msib.organization_id
    JOIN apps.mtl_transaction_types          mttp    ON  mtt.transaction_type_id = mttp.transaction_type_id  
    JOIN apps.ra_customer_trx_lines_all      rctla   ON  oola.line_id = rctla.interface_line_attribute6 and oola.org_id = rctla.org_id
    JOIN apps.ra_customer_trx_all            rcta    ON  rctla.customer_trx_id = rcta.customer_trx_id 
WHERE
    mtt.organization_id = '149'
    AND mtt.transaction_type_id = 33
    AND ottl.transaction_type_id = '1356'
    AND ottl.language = 'PTB') A
LEFT JOIN
(SELECT
    mtt.source_line_id,
    ooha.order_number,
    rcta.trx_number,
    mtt.transaction_id,
    mtt.creation_date,
    ood.organization_code,
    msib.segment1,
    mtt.subinventory_code,
    mtt.transaction_type_id,
    mttp.transaction_type_name,
    mtt.transaction_quantity
FROM
         apps.mtl_material_transactions      mtt
    JOIN apps.oe_order_lines_all             oola    ON mtt.source_line_id = oola.line_id
    JOIN apps.oe_order_headers_all           ooha    ON oola.header_id = ooha.header_id
    JOIN apps.org_organization_definitions   ood     ON mtt.organization_id = ood.organization_id
    JOIN apps.mtl_system_items_b             msib    ON mtt.inventory_item_id = msib.inventory_item_id
                                                AND mtt.organization_id = msib.organization_id
    JOIN apps.mtl_transaction_types          mttp    ON  mtt.transaction_type_id = mttp.transaction_type_id
    JOIN apps.ra_customer_trx_lines_all      rctla   ON  oola.line_id = rctla.interface_line_attribute6 and oola.org_id = rctla.org_id
    JOIN apps.ra_customer_trx_all            rcta    ON  rctla.customer_trx_id = rcta.customer_trx_id
WHERE
    mtt.organization_id = '149'
    AND mtt.transaction_type_id = 143
    AND mtt.transaction_quantity < 0)  B       ON A.SOURCE_LINE_ID = B.SOURCE_LINE_ID
LEFT JOIN
(SELECT
    mtt.source_line_id,
    ooha.order_number,
    rcta.trx_number,
    mtt.transaction_id,
    mtt.creation_date,
    ood.organization_code,
    msib.segment1,
    mtt.subinventory_code,
    mtt.transaction_type_id,
    mttp.transaction_type_name,
    mtt.transaction_quantity
FROM
        apps. mtl_material_transactions      mtt
    JOIN apps.oe_order_lines_all             oola    ON mtt.source_line_id = oola.line_id
    JOIN apps.oe_order_headers_all           ooha    ON oola.header_id = ooha.header_id
    JOIN apps.org_organization_definitions   ood     ON mtt.organization_id = ood.organization_id
    JOIN apps.mtl_system_items_b             msib    ON mtt.inventory_item_id = msib.inventory_item_id
                                                AND mtt.organization_id = msib.organization_id
    JOIN apps.mtl_transaction_types          mttp    ON  mtt.transaction_type_id = mttp.transaction_type_id
    JOIN apps.ra_customer_trx_lines_all      rctla   ON  oola.line_id = rctla.interface_line_attribute6 and oola.org_id = rctla.org_id
    JOIN apps.ra_customer_trx_all            rcta    ON  rctla.customer_trx_id = rcta.customer_trx_id
WHERE
    mtt.organization_id = '149'
    AND mtt.transaction_type_id = 144)  C       ON B.SOURCE_LINE_ID = C.SOURCE_LINE_ID
LEFT JOIN		
(SELECT
    mtt.source_line_id,
    ooha.order_number,
    rcta.trx_number,
    mtt.transaction_id,
    mtt.creation_date,
    ood.organization_code,
    msib.inventory_item_id,
    msib.segment1,
    mtt.subinventory_code,
    mtt.transaction_type_id,
    mttp.transaction_type_name,
    mtt.transaction_quantity
FROM
         apps.mtl_material_transactions      mtt
    JOIN apps.oe_order_lines_all             oola    ON mtt.source_line_id = oola.line_id
    JOIN apps.oe_order_headers_all           ooha    ON oola.header_id = ooha.header_id
    JOIN apps.org_organization_definitions   ood     ON mtt.organization_id = ood.organization_id
    JOIN apps.mtl_system_items_b             msib    ON mtt.inventory_item_id = msib.inventory_item_id
                                                     AND mtt.organization_id = msib.organization_id
    JOIN apps.mtl_transaction_types          mttp    ON  mtt.transaction_type_id = mttp.transaction_type_id
    JOIN apps.ra_customer_trx_lines_all      rctla   ON  oola.line_id = rctla.interface_line_attribute6 and oola.org_id = rctla.org_id
    JOIN apps.ra_customer_trx_all            rcta    ON  rctla.customer_trx_id = rcta.customer_trx_id
WHERE
    mtt.organization_id = '165'
    AND mtt.transaction_type_id = 143
    AND mtt.transaction_quantity > 0)  D       ON C.SOURCE_LINE_ID = D.SOURCE_LINE_ID
LEFT JOIN
(SELECT
    mtt.source_line_id,
    cfil.invoice_line_id,
    cfi.operation_id,
    cfi.invoice_num,
    mtt.transaction_id,
    mtt.creation_date,
    ood.organization_code,
    cfil.organization_id,
    msib.inventory_item_id,
    msib.segment1,
    mtt.subinventory_code,
    mtt.transaction_type_id,
    mttp.transaction_type_name,
    mtt.transaction_quantity
FROM
         apps.mtl_material_transactions mtt
    JOIN apps.cll_f189_invoice_lines        cfil    ON mtt.source_line_id = cfil.invoice_line_id
    JOIN apps.cll_f189_invoices             cfi     ON cfil.invoice_id = cfi.invoice_id
    JOIN apps.org_organization_definitions  ood     ON mtt.organization_id = ood.organization_id
    JOIN apps.mtl_system_items_b            msib    ON mtt.inventory_item_id = msib.inventory_item_id
                                                    AND mtt.organization_id = msib.organization_id
    JOIN apps.mtl_transaction_types         mttp    ON mtt.transaction_type_id = mttp.transaction_type_id
    
WHERE
        mtt.organization_id = '164'
    AND mtt.transaction_type_id = 144)  E       ON  D.TRX_NUMBER = E.INVOICE_NUM
                                                AND E.ORGANIZATION_ID = '164'
                                                AND D.INVENTORY_ITEM_ID = E.inventory_item_id
LEFT JOIN
(SELECT
    cftrc.invoice_line_id,
    msib.segment1,
    mttp.transaction_type_name,
    mtt.subinventory_code,
    sum(mtt.transaction_quantity) SOMA_QUANTIDADE_DEVOLVIDA,
    ood.organization_code,
    listagg(cftdc.trx_number, ', ') WITHIN GROUP ( ORDER BY cftdc.devolution_date) NFS_DEVOLUÇÃO
FROM    apps.mtl_material_transactions      mtt
JOIN    apps.cll_f513_tpa_devolutions_ctrl  cftdc   on  mtt.transaction_set_id = cftdc.devolution_transaction_id
JOIN    apps.cll_f513_tpa_receipts_control  cftrc   on  cftdc.tpa_receipts_control_id = cftrc.tpa_receipts_control_id
JOIN    apps.org_organization_definitions   ood     ON  mtt.organization_id = ood.organization_id
JOIN    apps.mtl_system_items_b             msib    ON mtt.inventory_item_id = msib.inventory_item_id
                                                    AND mtt.organization_id = msib.organization_id
JOIN apps.mtl_transaction_types             mttp    ON  mtt.transaction_type_id = mttp.transaction_type_id                                                    
WHERE
/*    cftrc.invoice_line_id IN ( 4245201, 4245202, 4245203, 4245204, 4245205,
                         4245206, 4245207, 4245208, 4245209, 4245210,
                         4245211, 4245212)
AND*/ cftdc.cancel_flag is null
AND cftdc.devolution_status = 'COMPLETE'
GROUP BY
    ood.organization_code,
    msib.segment1,
    mttp.transaction_type_name,
    mtt.subinventory_code,
    cftrc.invoice_line_id)  H   ON  E.invoice_line_id = H.invoice_line_id
LEFT JOIN
(SELECT
    mtt.source_line_id,
    ooha.order_number,
    rcta.trx_number,
    mttp.transaction_type_name,
    ood.organization_code,
    msib.segment1,
    mtt.subinventory_code,
    sum(mtt.transaction_quantity) SOMA_QUANTIDADE_SAÍDA
FROM
         apps.mtl_material_transactions      mtt
    JOIN apps.oe_order_lines_all             oola    ON mtt.source_line_id = oola.line_id
    JOIN apps.oe_order_headers_all           ooha    ON oola.header_id = ooha.header_id
    JOIN apps.org_organization_definitions   ood     ON mtt.organization_id = ood.organization_id
    JOIN apps.mtl_system_items_b             msib    ON mtt.inventory_item_id = msib.inventory_item_id
                                                     AND mtt.organization_id = msib.organization_id
    JOIN apps.mtl_transaction_types          mttp    ON  mtt.transaction_type_id = mttp.transaction_type_id
    JOIN apps.ra_customer_trx_lines_all      rctla   ON  oola.line_id = rctla.interface_line_attribute6 and oola.org_id = rctla.org_id
    JOIN apps.ra_customer_trx_all            rcta    ON  rctla.customer_trx_id = rcta.customer_trx_id
WHERE
    mtt.organization_id = '165'
    AND mtt.transaction_type_id = 143
    AND mtt.transaction_quantity < 0
GROUP BY 
    mtt.source_line_id,
    ooha.order_number,
    rcta.trx_number,
    ood.organization_code,
    msib.segment1,
    mtt.subinventory_code,
    mttp.transaction_type_name)  F    ON D.SOURCE_LINE_ID = F.SOURCE_LINE_ID
LEFT JOIN
(SELECT
    mtt.source_line_id,
    ooha.order_number,
    rcta.trx_number,
    ood.organization_code,
    msib.segment1,
    mttp.transaction_type_name,
    mtt.subinventory_code,
    sum(mtt.transaction_quantity) SOMA_QUANTIDADE_ENTRADA
FROM
         apps.mtl_material_transactions      mtt
    JOIN apps.oe_order_lines_all             oola    ON mtt.source_line_id = oola.line_id
    JOIN apps.oe_order_headers_all           ooha    ON oola.header_id = ooha.header_id
    JOIN apps.org_organization_definitions   ood     ON mtt.organization_id = ood.organization_id
    JOIN apps.mtl_system_items_b             msib    ON mtt.inventory_item_id = msib.inventory_item_id
                                                AND mtt.organization_id = msib.organization_id
    JOIN apps.mtl_transaction_types          mttp    ON  mtt.transaction_type_id = mttp.transaction_type_id
    JOIN apps.ra_customer_trx_lines_all      rctla   ON  oola.line_id = rctla.interface_line_attribute6 and oola.org_id = rctla.org_id
    JOIN apps.ra_customer_trx_all            rcta    ON  rctla.customer_trx_id = rcta.customer_trx_id
WHERE
    mtt.organization_id = '149'
    AND mtt.transaction_type_id = 143
    AND mtt.transaction_quantity > 0
    AND source_line_id IN ( 1221705, 1221706, 1221707, 1221708, 1221709,
                        1221710, 1221711, 1221699, 1221700, 1221701,
                        1221702, 1221703, 1221704 )
GROUP BY 
    mtt.source_line_id,
    ooha.order_number,
    rcta.trx_number,
    ood.organization_code,
    msib.segment1,
    mtt.subinventory_code,
    mttp.transaction_type_name)  G    ON F.SOURCE_LINE_ID = G.SOURCE_LINE_ID

WHERE /*A.source_line_id IN ( 1221705, 1221706, 1221707, 1221708, 1221709,
                        1221710, 1221711, 1221699, 1221700, 1221701,
                        1221702, 1221703, 1221704 )
AND */A.ORDER_TYPE_ID = 1356
AND A.CREATION_DATE BETWEEN '01/10/2022' AND '01/11/2022'
ORDER BY a.order_number ,a.segment1 ,a.transaction_quantity asc