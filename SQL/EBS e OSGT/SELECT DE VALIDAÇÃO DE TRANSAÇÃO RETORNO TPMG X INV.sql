  --- -- SELECT DE VALIDA플O DE TRANSA플O RETORNO TPMG X INV
SELECT DISTINCT
    a.operation_id,
    a.returned_date,
    a.new_subinventory,
    a.invoice_number,
    a.returned_transaction_id ID_TPMG_TRANSACTION,
    b.transaction_id ID_TRANSA플O_INV,
    b.creation_date CRIA플O_TRANSACAO_TABELA_INV,
    b.transaction_date DATA_TRANSA플O_INV,
    B.TRANSACTION_QUANTITY,
      c.segment1 ITEM_TRANSFERIDO,
    B.subinventory_code SUBINVENT핾IO_TRANSFERIDOR,
    b.source_code,
    d.transaction_type_name,
    e.segment1||'.'||e.segment2||'.'||e.segment3||'.'||e.segment4||'.'||e.segment5||'.'||e.segment6||'.'||e.segment7||'.'||e.segment8 as CONTA_CONTABIL
    
FROM
    cll_f513_tpa_returns_control  a
    LEFT JOIN mtl_material_transactions  b ON a.returned_transaction_id = b.transaction_set_id
     JOIN MTL_TRANSACTION_TYPES d ON b.transaction_type_id = d.transaction_type_id
    JOIN mtl_system_items_b c ON a.inventory_item_id = c.inventory_item_id
    JOIN gl_code_combinations e ON b.distribution_account_id = e.code_combination_id
WHERE
    a.operation_id = 79219

    and a.organization_id = '149';
    
    select * from cll_f513_tpa_returns_control;