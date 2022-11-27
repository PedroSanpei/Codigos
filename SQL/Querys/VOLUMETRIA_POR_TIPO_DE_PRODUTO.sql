SELECT
    f.meaning TIPO_PRODUTO,
    count(f.meaning) CONTAGEM_ITEM_PRODUTO,
    g.organization_name
FROM
    ra_customer_trx_all a,
    ra_customer_trx_lines_all c,
    mtl_system_items_b d,
    fnd_lookup_types_vl e,
    fnd_lookup_values_vl f,
    org_organization_definitions g
WHERE
a.customer_trx_id = c.customer_trx_id
--AND a.trx_number = '25337'
AND c.inventory_item_id = d.inventory_item_id
AND c.warehouse_id = d.organization_id
and c.warehouse_id = g.organization_id
AND  e.lookup_type = 'ITEM_TYPE'
AND e.application_id = 401	--Inventory
AND e.lookup_type = f.lookup_type
AND f.lookup_code = nvl(d.item_type, '00')
AND a.org_id = '145'
AND a.creation_date BETWEEN '01-MAI-2022' AND '29-JUN-2022'
GROUP by 
f.meaning,
g.organization_name;
