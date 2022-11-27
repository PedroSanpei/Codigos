--Comparativo_ITEM_EBS_ITEM_WSK
SELECT
    kmbp.cd_material as part_number_wsk,
    kmbuc.item_usage_class as valor_categoria_wsk,
    msib.segment1 as part_number_ebs,
    mic.category_concat_segs AS valor_categoria_ebs,
CASE 
WHEN kmbp.COUNTRY_ORIGIN_CD  = 'BRA' THEN 'NATIONAL'
ELSE 'IMPORTED'
END as CATEGORIA_TIPO
FROM
    kmtb_parts       kmbp,
    kmtb_usage_code  kmbuc,
     apps.mtl_item_categories_v@k2hom    mic,
    apps.mtl_system_items_b@k2hom   msib
WHERE
        1 = 1
    AND kmbp.cd_material =  msib.segment1
    AND kmbp.usage_cd = kmbuc.usage_cd
    AND msib.inventory_item_id = mic.inventory_item_id
    --AND msib.segment1 = '13008-0572'
    AND msib.organization_id = '151'
    AND msib.organization_id = mic.organization_id
    AND mic.category_set_id = '1100000063';
    --and kmbp.country_origin_cd = 'BRA'
    --and kmbuc.usage_cd = '2'



SELECT
    msib.segment1 as part_number,
    mic.category_concat_segs AS valor_categoria
    --msib.organization_id,
    --mic.category_set_id,
    --mic.category_set_name
    --count(msib.segment1)
FROM
    apps.mtl_item_categories_v@k2hom    mic,
    apps.mtl_system_items_b@k2hom   msib
WHERE
        msib.inventory_item_id = mic.inventory_item_id
    --AND msib.segment1 = '13008-0572'
    AND msib.organization_id = '151'
    AND msib.organization_id = mic.organization_id
    AND mic.category_set_id = '1100000063'
    --AND UPPER(category_concat_segs) LIKE '%MATERIAL%' 
/*GROUP BY 
    mic.category_concat_segs,
    msib.organization_id,
    mic.category_set_id,
    mic.category_set_name; -- Filtro somente para saber a categoria do item*/;
    
SELECT * FROM kmtb_parts;