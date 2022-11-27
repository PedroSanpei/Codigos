SELECT
    cfi.operation_id,
    asp.vendor_name             EMPRESA,
    cffea.document_number       CNPJ,
    cfi.invoice_num             NUM_NOTA,
    cfit.invoice_type_code      TRANSAÇÃO,
    cfit.description            DESC_TRANSACAO,
    (select distinct cffo.cfo_code from cll_f189_invoice_lines cfil, cll_f189_fiscal_operations cffo 
     where cfil.invoice_id = cfi.invoice_id and cfil.cfo_id = cffo.cfo_id and item_number = '1') CFOP,
    cffea.ie                    INSCRIÇÃO_ESTADUAL,
    cfi.series                  SERIE,
    cfi.eletronic_invoice_key   CHAVE_ELETRONICA
    
FROM
    cll_f189_invoices               cfi,
    cll_f189_invoice_types          cfit,
    cll_f189_fiscal_entities_all    cffea,
    ap_supplier_sites_all           aspa,
    ap_suppliers                    asp
WHERE
    cfi.invoice_type_id     = cfit.invoice_type_id
AND cfi.entity_id           = cffea.entity_id
AND cffea.vendor_site_id    = aspa.vendor_site_id
AND aspa.vendor_id          = asp.vendor_id
AND asp.vendor_name like    '%KAWASAKI%'
--AND cfi.eletronic_invoice_key = '13200109137895000185550110000000011000004333'
--AND invoice_id = '2093947'