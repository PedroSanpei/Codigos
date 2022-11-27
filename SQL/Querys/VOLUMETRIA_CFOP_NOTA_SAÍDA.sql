SELECT
    b.global_attribute3 CFOP,
    d.cfo_description DESCRICAO_CFOP,
    count(a.trx_number) CONTAGEM_NOTAS,
    c.attribute1 CNPJ,
    c.attribute6 IE,
    a.org_id
    
FROM
    ra_customer_trx_all a,
    ra_cust_trx_types_all b,
    ra_batch_sources_all c,
    jl_br_ap_operations d
WHERE
    a.cust_trx_type_id = b.cust_trx_type_id
AND a.org_id = b.org_id
AND b.global_attribute3 = d.cfo_code
AND a.batch_source_id = c.batch_source_id
AND b.global_attribute3 is not null
AND a.creation_date BETWEEN '01-ABR-2022' AND '29-JUN-2022'
group by b.global_attribute3 ,
    d.cfo_description,
    c.attribute1 ,
    c.attribute6,
    a.org_id
order by a.org_id ;

SELECT * FROM JL_BR_AP_OPERATIONS
