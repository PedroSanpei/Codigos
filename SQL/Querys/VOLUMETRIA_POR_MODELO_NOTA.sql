select 
b.efd_type MODELO_NOTA,
b.FISCAL_DOCUMENT_TYPE_CODE COD_MODELO_NOTA,
count(a.invoice_num) CONTAGEM_NOTAS,
c.organization_name

from
cll_f189_invoices a,
CLL_F189_FISCAL_DOCUMENT_TYPES b,
org_organization_definitions c

WHERE
a.fiscal_document_model = b.FISCAL_DOCUMENT_TYPE_CODE
AND a.organization_id = c.organization_id
AND a.creation_date BETWEEN '01-MAIO-2022' AND '29-JUN-2022'
GROUP BY
b.efd_type,
b.FISCAL_DOCUMENT_TYPE_CODE,
c.organization_name