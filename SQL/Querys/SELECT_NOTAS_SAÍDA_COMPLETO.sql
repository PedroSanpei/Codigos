-- SELECT BUSCA NOTA SAÍDA COM INFORMAÇÕES COMPLETAS
SELECT
    etb.name                    EMPRESA,
    rcta.customer_trx_id,
    rbsa.attribute1             CNPJ_EMISSOR,
    rcta.trx_number             NUM_NOTA,
    rctt.name                   TIPO_TRANSAÇÃO,
    (SELECT distinct global_attribute1 FROM ra_customer_trx_lines_all where customer_trx_id = rcta.customer_trx_id and line_type = 'LINE' and line_number = '1') CFOP,
    jbao.cfo_description,
    rbsa.name                   SERIE,
    rbsa.attribute6             IE,
    jbcte.ELECTRONIC_INV_ACCESS_KEY
    
FROM
    
    ra_customer_trx_all         rcta,
    ra_batch_sources_all        rbsa,
    ra_cust_trx_types_all       rctt,
    apps.xle_etb_profiles       etb,
    apps.xle_registrations      reg,
    apps.hr_locations_all       hrl,
    apps.xle_jurisdictions_vl   jur,
    jl_br_ap_operations         jbao,
    jl_br_customer_trx_exts     jbcte

    
WHERE
    rcta.batch_source_id            = rbsa.batch_source_id
AND rcta.cust_trx_type_id           = rctt.cust_trx_type_id
AND rcta.customer_trx_id            = jbcte.customer_trx_id
AND rctt.global_attribute3          = jbao.cfo_code
AND hrl.inventory_organization_id   = (select distinct rctla.warehouse_id from ra_customer_trx_lines_all rctla 
                                       where rctla.customer_trx_id = rcta.customer_trx_id and line_type = 'LINE')
AND etb.establishment_id            = reg.source_id
AND reg.source_table                = 'XLE_ETB_PROFILES'
AND hrl.location_id                 = reg.location_id
AND jur.jurisdiction_id             = reg.jurisdiction_id
AND jur.legislative_cat_code        = 'FEDERAL_TAX'
AND sysdate BETWEEN nvl(etb.effective_from, sysdate) AND nvl(etb.effective_to, sysdate)
AND etb.legal_entity_id             = rcta.legal_entity_id
AND to_char(rcta.creation_date, 'YYYY') BETWEEN '2020' AND '2022'
ORDER BY rcta.creation_date asc



