SELECT DISTINCT
         a.invoice_num,
         a.invoice_date,
         a.creation_date,
         a.status,
         a.source,
         a.invoice_type_lookup_code,
         a.invoice_amount, 
         a.description as invoice_description,
         d.description as erro_description
FROM
    apps.ap_invoices_interface a,
    apps.AP_INVOICE_LINES_INTERFACE b,
    apps.ap_interface_rejections c,
    apps.ap_lookup_codes d
WHERE
    1=1
AND a.invoice_id = b.invoice_id
AND a.source = 'SOFTWAY'
AND a.STATUS = 'REJECTED'
AND TO_CHAR(b.creation_date,'DD/MM/YYYY')  = TO_CHAR(SYSDATE-1, 'DD/MM/YYYY')
AND c.parent_id = b.invoice_line_id
AND c.reject_lookup_code = d.lookup_code;
--AND a.INVOICE_NUM LIKE '%TDKMB-210501%'--COLOCAR NÚMERO DA FATURA;



SELECT DISTINCT
         a.invoice_num,
         a.invoice_date,
         a.creation_date,
         a.status,
         a.source,
         a.invoice_type_lookup_code,
         a.invoice_amount, 
         a.description as invoice_description,
         d.description as erro_description
into     
        &invoice_num,
        &invoice_date,
        &creation_date,
        &status,
        &source,
        &invoice_type_lookup_code,
        &invoice_amount, 
        &invoice_description,
        &erro_description
         
FROM
    apps.ap_invoices_interface a,
    apps.AP_INVOICE_LINES_INTERFACE b,
    apps.ap_interface_rejections c,
    apps.ap_lookup_codes d
WHERE
    1=1
AND a.invoice_id = b.invoice_id
AND a.source = 'SOFTWAY'
AND a.STATUS = 'REJECTED'
AND TO_CHAR(b.creation_date,'DD/MM/YYYY')  = TO_CHAR(SYSDATE, 'DD/MM/YYYY')
AND c.parent_id = b.invoice_line_id
AND c.reject_lookup_code = d.lookup_code
AND a.rowid = :rowid;