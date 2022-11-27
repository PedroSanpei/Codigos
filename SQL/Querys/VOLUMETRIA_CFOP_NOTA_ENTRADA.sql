select distinct
e.cfo_code CFOP,
e.description,
count(a.invoice_num)CONTAGEM

from
cll_f189_invoices a,
cll_f189_invoice_lines d,
CLL_F189_FISCAL_DOCUMENT_TYPES b,
org_organization_definitions c,
CLL_F189_FISCAL_OPERATIONS e

WHERE
a.fiscal_document_model = b.FISCAL_DOCUMENT_TYPE_CODE
AND a.invoice_id = d.invoice_id
AND a.organization_id = c.organization_id
AND d.cfo_id = e.cfo_id
AND a.creation_date BETWEEN '01-MAIO-2022' AND '29-JUN-2022'
GROUP BY
e.cfo_code,
e.description;


SELECT * FROM CLL_F189_FISCAL_OPERATIONS