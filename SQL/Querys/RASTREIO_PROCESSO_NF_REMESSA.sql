SELECT
    rcta.customer_trx_id ID,
    rcta.trx_number NUM_NOTA,
    rcta.trx_date DATA_NOTA,
    rctt.name TIPO_TRANSAÇÃO,
    rbsa.name SERIE,
    msib.segment1 ITEM,
    rctla.interface_line_attribute1 ORIGEM
    
FROM
    ra_customer_trx_all rcta,
    ra_customer_trx_lines_all   rctla,
    ra_batch_sources_all    rbsa,
    ra_cust_trx_types_all   rctt,
    mtl_system_items_b  msib
WHERE
    rcta.customer_trx_id = rctla.customer_trx_id
AND rcta.batch_source_id = rbsa.batch_source_id
AND rcta.cust_trx_type_id = rctt.cust_trx_type_id
AND rctla.inventory_item_id = msib.inventory_item_id
AND rctla.warehouse_id = msib.organization_id
AND rcta.customer_trx_id = '1143492'
AND rctla.line_type = 'LINE';

select * from mtl_material_transactions where transaction_set_id = '1143492'