SELECT
    a.trx_number NUM_NOTA,
    b.name NOME_TRANSACAO,
    b.description DESCRICAO_TRANSACAO ,
    b.global_attribute3 CFOP,
    b.global_attribute4 DESCRICAO_CFOP,
    c.attribute2 SERIE,
    c.name SERIE_DESCRICAO,
    c.attribute1 CNPJ,
    c.attribute6 IE    
    
FROM
    ra_customer_trx_all a,
    ra_cust_trx_types_all b,
    ra_batch_sources_all c
WHERE
    a.cust_trx_type_id = b.cust_trx_type_id
AND a.org_id = b.org_id
AND a.batch_source_id = c.batch_source_id
AND a.org_id = '155'
AND a.creation_date BETWEEN '01-MAI-2022' AND '29-JUN-2022'