SELECT 
        a.header_id                                         ID_CABEÇALHO_ORDEM
        ,a.order_number                                     NUM_ORDEM
        ,b.line_id                                          ID_LINHA_ORDEM
        ,b.line_number                                      NUN_LINHA
        ,b.ordered_item                                     ITEM
        ,b.pricing_quantity                                 QTD_ORDEM
        ,c.interface_line_attribute6
        ,d.trx_number                                       NUM_NF_REMESSA
        ,to_char(e.creation_date, 'DD-MM-YYYY HH:MI:SS AM') DT_TRANSAÇÃO_INV
        ,e.transaction_quantity                             QTD_TRANSACIONADA
        ,e.subinventory_code                                SUBINVENTARIO
        ,e.organization_id
        ,g.organization_code                                ORGANIZAÇÃO
        ,e.transaction_type_id                              ID_TIPO_TRANSAÇÃO
        ,CASE WHEN e.transaction_type_id = '33'  AND g.organization_code = 'B01' AND e.subinventory_code = 'KMB_EXP'                                   THEN '1º'
              WHEN e.transaction_type_id = '144' AND g.organization_code = 'B01' AND e.subinventory_code = 'KMB_EXP'                                   THEN '2º'
              WHEN e.transaction_type_id = '143' AND g.organization_code = 'B01' AND e.subinventory_code = 'KMB_EXP'                                   THEN '3º'
              WHEN e.transaction_type_id = '143' AND g.organization_code = 'BT1' AND e.subinventory_code = 'TERC_KCA' AND e.transaction_quantity > 0  THEN '4º'
              WHEN e.transaction_type_id = '143' AND g.organization_code = 'BT1' AND e.subinventory_code = 'TERC_KCA' AND e.transaction_quantity < 0  THEN '5º'
              WHEN e.transaction_type_id = '143' AND g.organization_code = 'B01' AND e.subinventory_code = 'KMB_PRD'                                   THEN '6º'
         END                                                ORDEM_PROCESSO
        ,f.transaction_type_name                            TIPO_TRANSACAO
        ,h.operation_id                                     NUM_RI
        ,j.tpa_receipts_control_id                          NUM_REMESSA_TPMG
        ,j.remaining_balance                                QTD_RESTANTE_PARA_USO
        ,k.invoice_number                                   NF_DEV
        --,e.gl_code_id
        ,CASE  WHEN e.transaction_type_id = '143' AND g.organization_code = 'BT1' AND e.subinventory_code = 'TERC_KCA' AND e.transaction_quantity < 0  THEN  'TRANSAÇÃO SAÍDA DE NF DEVOLUÇÃO KCA'
               WHEN e.transaction_type_id = '143' AND g.organization_code = 'B01' AND e.subinventory_code = 'KMB_PRD'  AND k.invoice_number is not null  THEN 'TRANSAÇÃO ENTRADA DE NF DEVOLUÇÃO KMB'
        END AS TIPO
FROM
        oe_order_headers_all            A
JOIN    oe_order_lines_all              B   ON  a.header_id                 =   b.header_id
JOIN    ra_customer_trx_lines_all       C   ON  b.line_id                   =   c.interface_line_attribute6 AND c.inventory_item_id = b.inventory_item_id
JOIN    ra_customer_trx_all             D   ON  c.customer_trx_id           =   d.customer_trx_id
JOIN    mtl_material_transactions       E   ON  c.interface_line_attribute6 =   e.source_line_id   
JOIN    mtl_transaction_types           F   ON  e.transaction_type_id       =   f.transaction_type_id
JOIN    org_organization_definitions    G   ON  e.organization_id           =   g.organization_id
JOIN    cll_f189_invoices               H   ON  to_char(d.trx_number)       =   to_char(h.invoice_num)  
JOIN    cll_f189_invoice_lines          I   ON  h.invoice_id                =   i.invoice_id    
        AND c.inventory_item_id = i.item_id
JOIN    cll_f513_tpa_receipts_control   J   ON  h.invoice_id                =   j.invoice_id
        AND h.organization_id   =  j.organization_id 
        AND i.item_id = j.inventory_item_id 
LEFT JOIN    cll_f513_tpa_returns_control    K   ON  e.transaction_set_id = k.returned_transaction_id
WHERE   
        h.organization_id   =   '164'
AND     a.header_id         =   '1066795' 
ORDER BY  b.ordered_item , ordem_processo asc;

select * from mtl_material_transactions where source_line_id in (1127323,1127322);
select * from cll_f513_tpa_returns_control where returned_transaction_id = '97185326';

select * from oe_order_headers_all where header_id = '1040546';

describe mtl_material_transactions