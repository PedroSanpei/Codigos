SELECT
    a.invoice_number NF_REMESSA,
    c.segment1 COD_ITEM,
    b.devolution_operation_id RI_DEVOLUCAO,
    b.devolution_status STATUS_DEVOLUCAO,
    b.trx_number NF_DEVOLUCAO,
    b.devolution_quantity QUANTIDADE_DEVOLVIDA,
    b.devolution_date
    
FROM
    cll_f513_tpa_receipts_control a
JOIN MTL_SYSTEM_ITEMS_B c ON a.inventory_item_id = c.inventory_item_id
LEFT JOIN CLL_F513_TPA_DEVOLUTIONS_CTRL B ON a.tpa_receipts_control_id = b.tpa_receipts_control_id
WHERE
 b.trx_number in ('62773',
'62774',
'62775',
'62790',
'62791',
'62801',
'62802',
'62811',
'62814',
'62815',
'62816',
'62818',
'62824',
'62828')
--c.segment1 = '92062-0010'
--AND A.invoice_number = '39434'
and c.organization_id = '164'

and b.cancel_flag IS NULL
and b.devolution_operation_id is not null
order by b.devolution_date, b.trx_number ;

