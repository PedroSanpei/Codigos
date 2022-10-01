SELECT
    a.trx_number NF_REMESSA,
    c.segment1 COD_ITEM,
    b.operation_id RI_RETORNO,
    b.operation_status STATUS_RETORNO,
    b.invoice_number NF_DEVOLUCAO,
    b.returned_quantity QUANTIDADE_RETORN,
    b.returned_date
    
FROM
    CLL_F513_TPA_REMIT_CONTROL a
JOIN MTL_SYSTEM_ITEMS_B c    ON a.inventory_item_id = c.inventory_item_id
LEFT JOIN CLL_F513_TPA_RETURNS_CONTROL B ON a.tpa_remit_control_id = b.tpa_remit_control_id
WHERE
b.invoice_number in ('62773',
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
--a.trx_number = '39434'
--and c.segment1 = '92062-0010'
AND c.organization_id = '164'
and b.operation_id is not null
AND b.operation_status = 'COMPLETE'
and b.reversion_flag IS NULL
order by c.segment1;