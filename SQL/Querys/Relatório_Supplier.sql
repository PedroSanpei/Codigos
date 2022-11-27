

SELECT
    asp.VENDOR_ID,
    asp.VENDOR_NAME NOME_FORNECEDOR,
    NVL(asp.VENDOR_NAME_ALT, 'NÃO CADASTRADO') AS NOME_FORNECEDOR_ALT,
    asp.segment1,
    aspa.org_id as ORGANIZAÇÃO,
    asp.CREATION_DATE,
    asp.VENDOR_TYPE_LOOKUP_CODE AS TIPO_FORNECEDOR,
    asp.PAY_GROUP_LOOKUP_CODE AS GRUPO_PAGAMENTO,   
    asp.payment_currency_code,
    aspal.create_awt_dists_type,
    aspa.vendor_site_code,
    aspa.address_line1||','||aspa.address_line2||','||aspa.address_line3||','||aspa.city||'-'||aspa.state||'/'||aspa.country as VENDOR_ADRESS,
    nvl(aspa.zip,'NÃO CADASTRADO') as CEP,
    aspa.global_attribute10||'/'||aspa.global_attribute11||aspa.global_attribute12 as CNPJ,
    nvl(aspa.global_attribute13, 'NÃO CADASTRADO')as INSCRIÇÃO_ESTADUAL,
    nvl(aspa.global_attribute14,'NÃO CADASTRADO') as INSCRIÇÃO_CIDADE,
    NVL(aspa.global_attribute15,'NÃO CADASTRADO') as TIPO_DE_CONTRIBUINTE,
    asp.bank_account_num
FROM    AP_SUPPLIERS asp,
        AP_SUPPLIER_SITES_ALL aspa,
        AP_SYSTEM_PARAMETERS_ALL aspal
WHERE   asp.vendor_id  = aspa.vendor_id
AND     asp.set_of_books_id = aspal.set_of_books_id;
--AND     ASP.VENDOR_ID = '5054';

select * from AP_SUPPLIER_SITES_ALL where vendor_id = '5054';
select * from ap_suppliers where vendor_id = '5054';
SELECT * from AP_SYSTEM_PARAMETERS_ALL;
select * from IBY_EXT_BANK_ACCOUNTS;
SELECT * FROM ALL_TABLES WHERE TABLE_NAME LIKE '%BANK%' AND TABLESPACE_NAME IS NOT NULL AND NUM_ROWS != '0';

SELECT * FROM CE_BANK_UPGRADE_MODES;
