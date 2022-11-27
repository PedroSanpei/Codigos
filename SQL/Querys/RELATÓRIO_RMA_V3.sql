SELECT
     oha.order_number       ordem_rma
    ,oha.order_type_id      cod_rma
    ,(select a.order_number from oe_order_headers_all a where oha.source_document_id = a.header_id) ordem_pai
    ,ott.description        descr_cod_rma
    ,oha.flow_status_code   status_cabeçalho
    ,msib.segment1          cod_item
    ,(select count(*) from oe_order_lines_all b where oha.header_id = b.header_id) TOTAL_ITEM_RMA
    ,ohla.flow_status_code  status_linha
    ,ohla.line_number
    ,oha.ordered_date       criado_em
    ,fu.user_name           usuário_criador_rma
    ,rcta.trx_number        nota_fiscal_rma
    ,sum (coalesce(rctla.extended_amount, rctla.gross_extended_amount)) nff_valor_rma
    ,(SELECT count(*) from ra_customer_trx_lines_all c where rctla.customer_trx_id = c.customer_trx_id and c.line_type = 'LINE') total_item_NF
FROM
            oe_order_headers_all        oha
JOIN        oe_transaction_types_tl     ott     ON  oha.order_type_id = ott.transaction_type_id

JOIN        fnd_user                    fu      ON  oha.created_by = fu.user_id 

JOIN        oe_order_lines_all          ohla    ON  oha.header_id = ohla.header_id

JOIN        mtl_system_items_b          msib    ON  ohla.inventory_item_id = msib.inventory_item_id 
                                                AND ohla.ship_from_org_id = msib.organization_id

LEFT JOIN   ra_customer_trx_all         rcta    ON  to_char(oha.order_number) = rcta.ct_reference
                                                AND oha.org_id = rcta.org_id

JOIN        ra_customer_trx_lines_all   rctla   ON  rctla.customer_trx_id = rcta.customer_trx_id 


WHERE
    oha.order_type_id IN (  SELECT  transaction_type_id
                            FROM    apps.oe_transaction_types_tl
                            WHERE   name LIKE '%RMA%'
                            AND LANGUAGE = 'PTB'
                         )    
AND ohla.FLOW_STATUS_CODE = 'AWAITING_RETURN'
AND rcta.INTERFACE_HEADER_ATTRIBUTE2 LIKE '%RMA%'
AND ott.language = 'PTB'
AND rctla.line_type = 'LINE'
GROUP BY
    oha.order_number       
    ,oha.order_type_id      
    ,oha.source_document_id
    ,ott.description        
    ,oha.flow_status_code   
    ,msib.segment1          
    ,oha.header_id
    ,ohla.flow_status_code  
    ,ohla.line_number
    ,oha.ordered_date       
    ,fu.user_name 
    ,fu.user_id
    ,rcta.trx_number        
    ,rctla.customer_trx_id
ORDER BY oha.order_number;
select * from oe_order_lines_all