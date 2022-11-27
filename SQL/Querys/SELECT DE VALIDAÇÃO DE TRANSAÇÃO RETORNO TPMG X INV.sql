  --- -- SELECT DE VALIDAÇÃO DE TRANSAÇÃO RETORNO TPMG X INV
SELECT DISTINCT
    a.operation_id,
    a.returned_date,
    a.new_subinventory,
    a.invoice_number,
    h.trx_number NF_REMESSA,
    a.returned_transaction_id ID_TPMG_TRANSACTION,
    b.transaction_id ID_TRANSAÇÃO_INV,
    b.creation_date CRIAÇÃO_TRANSACAO_TABELA_INV,
    b.transaction_date DATA_TRANSAÇÃO_INV,
    B.TRANSACTION_QUANTITY,
      c.segment1 ITEM_TRANSFERIDO,
    B.subinventory_code SUBINVENTÁRIO_TRANSFERIDOR,
    b.source_code,
    d.transaction_type_name,
    g.attribute9 ESO,
    e.segment1||'.'||e.segment2||'.'||e.segment3||'.'||e.segment4||'.'||e.segment5||'.'||e.segment6||'.'||e.segment7||'.'||e.segment8 as CONTA_CONTABIL
    
FROM
    cll_f513_tpa_returns_control  a
    LEFT JOIN mtl_material_transactions  b ON a.returned_transaction_id = b.transaction_set_id
    JOIN MTL_TRANSACTION_TYPES d ON b.transaction_type_id = d.transaction_type_id
    JOIN mtl_system_items_b c ON a.inventory_item_id = c.inventory_item_id
    JOIN gl_code_combinations e ON b.distribution_account_id = e.code_combination_id
    LEFT JOIN cll_f513_tpa_devolutions_ctrl f ON f.trx_number =  REGEXP_SUBSTR(a.invoice_number,'[^,]+')
    JOIN cll_f189_invoice_lines g ON f.devolution_invoice_line_id = g.invoice_line_id 
    JOIN cll_f513_tpa_remit_control h ON a.tpa_remit_control_id = h.tpa_remit_control_id
WHERE
    --a.operation_id = 96830 -- PESQUISA PELO Nº RI 
    h.trx_number = '39651' -- PESQUISA PELO Nº NF DE REMESSA
    and c.segment1 = '13342-0706' -- PESQUISA PELO Nº ITEM
    and a.organization_id = '149';

    
    select * from cll_f513_tpa_remit_control;