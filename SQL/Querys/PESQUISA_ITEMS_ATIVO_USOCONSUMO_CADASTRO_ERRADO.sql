SELECT DISTINCT
    msib.inventory_item_id
    ,msib.creation_date
    ,msib.segment1 COD_ITEM
    ,b.meaning TIPO_ITEM_INVENTARIO
    ,mic.CATEGORY_SET_NAME CATEGORIA_PO_ITEM
    ,mic.CATEGORY_CONCAT_SEGS
    ,mic1.CATEGORY_SET_NAME CATEGORIA_CUSTO
    ,mic1.CATEGORY_CONCAT_SEGS 
    ,msib.organization_id
    ,msib.INVENTORY_ITEM_FLAG ITEM_DE_INVENTÁRIO
    ,msib.STOCK_ENABLED_FLAG  ESTOCAVEL
    ,COSTING_ENABLED_FLAG     CALCULO_DE_CUSTO_ATIVO
    ,INVENTORY_ASSET_FLAG     VALOR_ATIVO_INVENTARIO
    ,DEFAULT_INCLUDE_IN_ROLLUP_FLAG INCLUIR_NA_ROLAGEM
FROM
        mtl_system_items_b      msib    
JOIN    mtl_item_categories_v   mic  ON msib.inventory_item_id = mic.inventory_item_id and msib.organization_id = mic.organization_id
JOIN    mtl_item_categories_v   mic1  ON msib.inventory_item_id = mic1.inventory_item_id and msib.organization_id = mic1.organization_id
JOIN    fnd_lookup_values       b    on  msib.item_type = b.lookup_code 
WHERE
        msib.INVENTORY_ITEM_STATUS_CODE = 'Active'
AND     mic.CATEGORY_SET_ID IN (1100000061)
AND     mic1.CATEGORY_SET_ID IN (1100000063)
AND     mic.CATEGORY_CONCAT_SEGS like '%CONSUMO%'
AND     msib.organization_id in ('149','157')
AND     msib.INVENTORY_ITEM_FLAG != 'N' 
AND     msib.stock_enabled_flag != 'N' 
AND     msib.costing_enabled_flag != 'N' 
AND     msib.inventory_asset_flag!= 'N'
AND     b.lookup_type = 'ITEM_TYPE'
AND     b.language = 'US'
