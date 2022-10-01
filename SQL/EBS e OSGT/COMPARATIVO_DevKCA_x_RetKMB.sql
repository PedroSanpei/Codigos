with kca as (SELECT
    a.invoice_number NF_REMESSA,
    c.segment1 COD_ITEM,
    b.devolution_operation_id RI_DEVOLUCAO,
    b.devolution_status STATUS_DEVOLUCAO,
    b.trx_number,
    b.devolution_quantity QUANTIDADE_DEVOLVIDA,
    b.devolution_date
FROM
    cll_f513_tpa_receipts_control a
JOIN MTL_SYSTEM_ITEMS_B c ON a.inventory_item_id = c.inventory_item_id
LEFT JOIN CLL_F513_TPA_DEVOLUTIONS_CTRL B ON a.tpa_receipts_control_id = b.tpa_receipts_control_id
WHERE
 --b.trx_number in ('62462')
--c.segment1 = '92062-0010'
--AND A.invoice_number = '39434'
c.organization_id = '164'
and b.cancel_flag IS NULL
--and b.devolution_status = 'COMPLETE'
and b.devolution_operation_id is not null),
kmb as(SELECT
    a.trx_number NF_REMESSA,
    c.segment1 COD_ITEM,
    b.operation_id RI_RETORNO,
    b.operation_status STATUS_RETORNO,
    b.invoice_number ,
    b.returned_quantity QUANTIDADE_RETORN,
    b.new_subinventory SUBINVENTÁRIO_RET,
    b.returned_date
    
FROM
    CLL_F513_TPA_REMIT_CONTROL a
JOIN MTL_SYSTEM_ITEMS_B c    ON a.inventory_item_id = c.inventory_item_id
LEFT JOIN CLL_F513_TPA_RETURNS_CONTROL B ON a.tpa_remit_control_id = b.tpa_remit_control_id
WHERE
--b.invoice_number in ('62462,05')
--a.trx_number = '39434'
--and c.segment1 = '92062-0010'
c.organization_id = '164'
and b.operation_id is not null
AND b.operation_status = 'COMPLETE'
and b.reversion_flag IS NULL)

select 
	kca.*,
    kmb.*,
    case when kmb.nf_remessa = kca.nf_remessa then 'VERDADEIRO'
    else 'FALSO'
    end as valid_nf_rem,
    case when kmb.cod_item = kca.cod_item then 'VERDADEIRO'
    ELSE 'FALSO'
    end as valid_item,
    case when kca.trx_number = REGEXP_SUBSTR(kmb.invoice_number,'[^,$]+') then 'VERDADEIRO'
    ELSE 'FALSO'
    end as valid_nf_dev,
    case when kmb.quantidade_retorn = kca.quantidade_devolvida then 'VERDADEIRO'
    ELSE 'FALSO'
    end as valid_qtd,
    case when kmb.subinventário_ret = 'KMB_PRD' then 'VERDADEIRO'
    else 'FALSO'
    end as valid_subintário
from
	kca
left join
	kmb on
		kca.trx_number = REGEXP_SUBSTR(kmb.invoice_number,'[^,$]+')
    and  kca.cod_item = kmb.cod_item
    and kca.nf_remessa = kmb.nf_remessa
order by 5 ASC,2 ;
