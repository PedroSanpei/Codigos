-- SELECT DE VALIDA��O DE TRANSA��O DEVOLU��O TPMG X INV
select 
    a.devolution_operation_id opera��o,
    a.devolution_date data_devolu��o,
    a.subinventory subinvent�rio,
    a.devolution_invoice_line_id,
    f.invoice_number,
    a.trx_number,
    devolution_transaction_id id_tpmg_transa��o,
    b.transaction_id ID_TRANSA��O_INV,
    b.creation_date CRIA��O_TRANSACAO_TABELA,
    b.transaction_date DATA_TRANSA��O,
    b.transaction_quantity,
    c.segment1 ITEM_TRANSFERIDO,
    B.subinventory_code SUBINVENT�RIO_TRANSFERIDOR,
    b.source_code,
    d.transaction_type_name,
    e.segment1||'.'||e.segment2||'.'||e.segment3||'.'||e.segment4||'.'||e.segment5||'.'||e.segment6||'.'||e.segment7||'.'||e.segment8 as CONTA_CONTABIL
    from
    cll_f513_tpa_devolutions_ctrl  a
    LEFT JOIN mtl_material_transactions b ON  a.devolution_transaction_id = b.transaction_set_id
    JOIN MTL_TRANSACTION_TYPES d ON b.transaction_type_id = d.transaction_type_id
    JOIN gl_code_combinations e ON b.distribution_account_id = e.code_combination_id
    JOIN mtl_system_items_b c ON a.inventory_item_id = c.inventory_item_id
    JOIN cll_f513_tpa_receipts_control f on a.tpa_receipts_control_id = f.tpa_receipts_control_id
WHERE
    --a.devolution_operation_id = 1922 -- PESQUISA PELO N� RI 
    f.invoice_number = '39715' -- PESQUISA PELO N� NF DE REMESSA
    --and c.segment1 = '13342-0706' -- PESQUISA PELO N� ITEM
    and c.organization_id = '164';
    
    select * from cll_f513_tpa_devolutions_ctrl where devolution_operation_id = '215' ;
    select * from mtl_material_transactions where transaction_set_id = '97788428';
    SELECT * FROM cll_f513_tpa_receipts_control;
    SELECT segment1||'.'||segment2||'.'||segment3||'.'||segment4||'.'||segment5||'.'||segment6||'.'||segment7||'.'||segment8 FROM gl_code_combinations WHERE code_combination_id = '640043'
    
    

    