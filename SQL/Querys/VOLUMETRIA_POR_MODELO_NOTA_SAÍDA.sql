SELECT

    'NFe - 55' MODELO_NOTA,
    count(rcta.trx_number) CONTAGEM_NOTAS
    
FROM
    ra_customer_trx_all rcta
    ,ra_cust_trx_types_all  rctta
    ,hr_operating_units hou
WHERE
    rcta.cust_trx_type_id = rctta.cust_trx_type_id
AND rcta.org_id = hou.organization_id
AND rcta.creation_date between '01-MAI-2022' and '29-JUN-2022'
ORDER BY hou.name
;

select * from hr_operating_units