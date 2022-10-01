SELECT
    msib.segment1 as part_number,
    mic.category_concat_segs AS valor_categoria
    --msib.organization_id,
    --mic.category_set_id,
    --mic.category_set_name
    --count(msib.segment1)
FROM
    apps.mtl_item_categories_v    mic,
    apps.mtl_system_items_b   msib
WHERE
        msib.inventory_item_id = mic.inventory_item_id
    --AND msib.segment1 = '13008-0572'
    AND msib.organization_id = '151'
    AND msib.organization_id = mic.organization_id
    AND mic.category_set_id = '1100000063'
    --AND UPPER(category_concat_segs) like '%' 
/*GROUP BY 
    mic.category_concat_segs,
    msib.organization_id,
    mic.category_set_id,
    mic.category_set_name; -- Filtro somente para saber a categoria do item*/;

select * from mtl_;


