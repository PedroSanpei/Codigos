SELECT DISTINCT
     invoice_num
     ,cffo.cfo_code
     ,cfit.invoice_type_code
     ,flvv.meaning
     ,flvv.description
     ,cfi.fiscal_document_model
     ,cfi.eletronic_invoice_key
     ,cfi.organization_id
FROM
            cll_f189_invoices cfi
JOIN        cll_f189_invoice_lines cfil ON cfil.invoice_id = cfi.invoice_id
LEFT JOIN   cll_f189_fiscal_operations cffo ON cffo.cfo_id = cfil.cfo_id
JOIN   cll_f189_invoice_types cfit ON cfit.invoice_type_id = cfi.invoice_type_id
JOIN        fnd_lookup_values_vl flvv ON flvv.lookup_code = cfi.fiscal_document_model
WHERE
1 = 1
AND flvv.lookup_type = 'CLL_F189_FISCAL_DOCUMENT_MODEL'
/*GROUP BY invoice_num, cffo.cfo_code, cfi.organization_id,cfit.invoice_type_code*/
     ;

