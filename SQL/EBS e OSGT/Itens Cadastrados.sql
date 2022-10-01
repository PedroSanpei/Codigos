SELECT  OOD.ORGANIZATION_CODE||'=='||OOD.ORGANIZATION_NAME EMPRESA,
        MSIB.SEGMENT1                           ITEM, 
        MSIB.DESCRIPTION                        DESCRICAO, 
        MSITL.LONG_DESCRIPTION                  DESCRICAO_LONGA,
        MSIB.PRIMARY_UNIT_OF_MEASURE            UOM,
        FLVV.MEANING                            TIPO_ITEM,
        'TEMPLATE XXXX'                         TEMPLATE,
        
        C_INVENT.CATEGORY_SET_NAME              CONJ_CATEG_INV,          
        C_INVENT.SEGMENT1                       CATEGORIA_INV,
        
        C_NCM.CATEGORY_SET_NAME                 CONJ_CATEG_NCM,          
        C_NCM.SEGMENT1                          CATEGORIA_NCM,
        
        C_PLAN.CATEGORY_SET_NAME                CONJ_CATEG_PLAN,          
        C_PLAN.SEGMENT1                         CATEGORIA_PLAN,
        
        C_CUST.CATEGORY_SET_NAME                CONJ_CATEG_CUSTO,          
        C_CUST.SEGMENT1                         CATEGORIA_CUSTO,
        
        C_PO.CATEGORY_SET_NAME                  CONJ_CATEG_PO,          
        C_PO.SEGMENT1                           CATEGORIA_PO,
        
        MANU.MANUFACTURER_NAME                  FABRICANTE,
        MSIB.LIST_PRICE_PER_UNIT                PRECO,
        MSIFV.WEIGHT_UOM_CODE                   UOM_CODE,
        MSIFV.UNIT_WEIGHT                       PESO,
        
        CATALOGO.SEGMENT1                            CATALOGO,
        NICK.ELEMENT_VALUE                           NICKNAME,
        ANO_FAB.ELEMENT_VALUE                        ANO_FABRICACAO,
        ANO_MOD.ELEMENT_VALUE                        ANO_MODELO,
        MSIB.SEGMENT1                                MODELO,
        COR.ELEMENT_VALUE                            COR,
        CILINDRADA.ELEMENT_VALUE                     CILINDRADA,
        POTENCIA.ELEMENT_VALUE                       POTENCIA,
        RENAVAN.ELEMENT_VALUE                        RENAVAN,
        DCRE.ELEMENT_VALUE                           DCR_E,
        NUM_PASS.ELEMENT_VALUE                       NUM_PASSAGEIROS,
        DIST_EIXO.ELEMENT_VALUE                      DISTANCIA_EIXOS,
        PINTURA.ELEMENT_VALUE                        TIPO_PINTURA,
        COMBUSTIVEL.ELEMENT_VALUE                    TIPO_COMBUSTIVEL,
        TIPO_VEICULO.ELEMENT_VALUE                   TIPO_VEICULO,
        ESP_VEICULO.ELEMENT_VALUE                    ESPECIE_VEICULO,
        PBT.ELEMENT_VALUE                            PBT,
        NOME_COMERCIAL.ELEMENT_VALUE                 NOME_COMERCIAL,
        CV.ELEMENT_VALUE                             CV,
        PESO_EMBALAGEM.ELEMENT_VALUE                 PESO_EMBALAGEM,
        LINHA.ELEMENT_VALUE                          LINHA,
        CAT_MOTOR.ELEMENT_VALUE                      CATEGORIA_MOTOR,
        UNID_MEDIDA.ELEMENT_VALUE                    UNIDADE_MEDIDA,
        COR_RENAVAM.ELEMENT_VALUE                    COD_COR__RENAVAM,
        COR_PROD.ELEMENT_VALUE                       COR_PRODUCAO,
        
        OOD.ORGANIZATION_CODE                   ORG,
        MSIB.GLOBAL_ATTRIBUTE2                  UTILIZACAO,
        MSIB.GLOBAL_ATTRIBUTE3                  ORIG,
        MSIB.GLOBAL_ATTRIBUTE4                  FISCAL_TYPE,
        MSIB.GLOBAL_ATTRIBUTE5                  SIT_TRIB_FED,
        MSIB.GLOBAL_ATTRIBUTE6                  SIT_TRIB_EST,        
        MSIB.POSTPROCESSING_LEAD_TIME           LEAD_TIME_POS,
        MSIB.LEAD_TIME_LOT_SIZE                 LEAD_TIME_TAM_LOT,
        MSIB.LEAD_TIME_LOT_SIZE                 LEAD_TIME_LOT_PADRAO,
        MSIB.GLOBAL_ATTRIBUTE9                  CEST
        
FROM MTL_SYSTEM_ITEMS_B             MSIB
    ,MTL_SYSTEM_ITEMS_TL            MSITL
    ,ORG_ORGANIZATION_DEFINITIONS   OOD
    ,FND_LOOKUP_TYPES_VL            FLVT
    ,FND_LOOKUP_VALUES_VL           FLVV
    ,MTL_SYSTEM_ITEMS_FVL           MSIFV
   
    ,(SELECT  MMNA.ORGANIZATION_ID, 
              MMNA.INVENTORY_ITEM_ID,
              MM.MANUFACTURER_NAME
      FROM MTL_MANUFACTURERS          MM,
           MTL_MFG_PART_NUMBERS_ALL_V MMNA
      WHERE MM.MANUFACTURER_ID    = MMNA.MANUFACTURER_ID) MANU
      
    ,(SELECT MIC.INVENTORY_ITEM_ID, 
             MIC.ORGANIZATION_ID,
             MCS.CATEGORY_SET_NAME,
             MC.SEGMENT1
      FROM MTL_ITEM_CATEGORIES            MIC
          ,MTL_CATEGORY_SETS              MCS
          ,MTL_CATEGORIES                 MC
      WHERE MIC.CATEGORY_SET_ID       = MCS.CATEGORY_SET_ID
      AND   MIC.CATEGORY_ID           = MC.CATEGORY_ID
      AND   MCS.CATEGORY_SET_NAME     = 'Inventário') C_INVENT
      
    ,(SELECT MIC.INVENTORY_ITEM_ID, 
             MIC.ORGANIZATION_ID,
             MCS.CATEGORY_SET_NAME,
             MC.SEGMENT1
      FROM MTL_ITEM_CATEGORIES            MIC
          ,MTL_CATEGORY_SETS              MCS
          ,MTL_CATEGORIES                 MC
      WHERE MIC.CATEGORY_SET_ID       = MCS.CATEGORY_SET_ID
      AND   MIC.CATEGORY_ID           = MC.CATEGORY_ID
      AND   MCS.CATEGORY_SET_NAME     = 'FISCAL_CLASSIFICATION') C_NCM
    
     ,(SELECT MIC.INVENTORY_ITEM_ID, 
             MIC.ORGANIZATION_ID,
             MCS.CATEGORY_SET_NAME,
             MC.SEGMENT1
      FROM MTL_ITEM_CATEGORIES            MIC
          ,MTL_CATEGORY_SETS              MCS
          ,MTL_CATEGORIES                 MC
      WHERE MIC.CATEGORY_SET_ID       = MCS.CATEGORY_SET_ID
      AND   MIC.CATEGORY_ID           = MC.CATEGORY_ID
      AND   MCS.CATEGORY_SET_NAME     = 'Planning Category') C_PLAN
    
     ,(SELECT MIC.INVENTORY_ITEM_ID, 
             MIC.ORGANIZATION_ID,
             MCS.CATEGORY_SET_NAME,
             MC.SEGMENT1
      FROM MTL_ITEM_CATEGORIES            MIC
          ,MTL_CATEGORY_SETS              MCS
          ,MTL_CATEGORIES                 MC
      WHERE MIC.CATEGORY_SET_ID       = MCS.CATEGORY_SET_ID
      AND   MIC.CATEGORY_ID           = MC.CATEGORY_ID
      AND   MCS.CATEGORY_SET_NAME     = 'Cost Category') C_CUST
    
    ,(SELECT MIC.INVENTORY_ITEM_ID, 
             MIC.ORGANIZATION_ID,
             MCS.CATEGORY_SET_NAME,
             MC.SEGMENT1
      FROM MTL_ITEM_CATEGORIES            MIC
          ,MTL_CATEGORY_SETS              MCS
          ,MTL_CATEGORIES                 MC
      WHERE MIC.CATEGORY_SET_ID       = MCS.CATEGORY_SET_ID
      AND   MIC.CATEGORY_ID           = MC.CATEGORY_ID
      AND   MCS.CATEGORY_SET_NAME     = 'PO Item Categories') C_PO
      
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               micg.segment1  
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'NICKNAME'
        and   msiv.organization_id <> 147) CATALOGO
    
     ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'NICKNAME'
        and   msiv.organization_id <> 147) NICK
   
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'ANO/FAB'
        and   msiv.organization_id <> 147)  ANO_FAB
       
       ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'ANO/MOD'
        and   msiv.organization_id <> 147)  ANO_MOD
        
           
       ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'COR'
        and   msiv.organization_id <> 147)  COR 
                
        ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'CILINDRADA'
        and   msiv.organization_id <> 147)  CILINDRADA
       
        ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'POTENCIA'
        and   msiv.organization_id <> 147)  POTENCIA
        
        ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'RENAVAM'
        and   msiv.organization_id <> 147)  RENAVAN
        
        ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'DCR-E'
        and   msiv.organization_id <> 147)  DCRE
         
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'NUMERO_PASSAGEIRO'
        and   msiv.organization_id <> 147)  NUM_PASS
     
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'DISTANCIA_EIXOS'
        and   msiv.organization_id <> 147)  DIST_EIXO 
        
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'TIPO_PINTURA'
        and   msiv.organization_id <> 147) PINTURA 
       
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'TIPO_COMBUSTIVEL'
        and   msiv.organization_id <> 147) COMBUSTIVEL
        
       ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'TIPO_VEICULO'
        and   msiv.organization_id <> 147) TIPO_VEICULO 
       
       ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'ESPECIE_VEICULO'
        and   msiv.organization_id <> 147) ESP_VEICULO
       
       ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'PBT'
        and   msiv.organization_id <> 147) PBT
        
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'NOME_COMERCIAL'
        and   msiv.organization_id <> 147) NOME_COMERCIAL
    
       ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'CV'
        and   msiv.organization_id <> 147) CV
        
    ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'PESO EMBALAGEM'
        and   msiv.organization_id <> 147) PESO_EMBALAGEM
        
    ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'LINHA'
        and   msiv.organization_id <> 147) LINHA
       
       ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'CATEGORIA MOTOR'
        and   msiv.organization_id <> 147) CAT_MOTOR
        
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'UNIDADE MEDIDA'
        and   msiv.organization_id <> 147) UNID_MEDIDA
        
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'CODIGO_COR_RENAVAN'
        and   msiv.organization_id <> 147) COR_RENAVAM
       
      ,(select Msiv.inventory_item_id, 
               msiv.organization_id,
               mdev.element_value 
        from mtl_system_items_fvl MSIV
            ,mtl_descr_element_values_v mdev
            ,mtl_item_catalog_groups    micg
        where 1=1        
        and   msiv.item_catalog_group_id = mdev.item_catalog_group_id
        and   msiv.inventory_item_id     = mdev.inventory_item_id
        and   msiv.item_catalog_group_id = micg.item_catalog_group_id
        and   mdev.element_name           = 'COR_PRODUCAO'
        and   msiv.organization_id <> 147) COR_PROD
        
    
        
WHERE 1 = 1 
AND   MSITL.ORGANIZATION_ID     = MSIB.ORGANIZATION_ID
AND   MSITL.INVENTORY_ITEM_ID   = MSIB.INVENTORY_ITEM_ID
AND   MSITL.ORGANIZATION_ID     = OOD.ORGANIZATION_ID

AND   MSITL.INVENTORY_ITEM_ID   = C_INVENT.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = C_INVENT.ORGANIZATION_ID (+)

AND   MSITL.INVENTORY_ITEM_ID   = C_NCM.INVENTORY_ITEM_ID(+)
AND   MSITL.ORGANIZATION_ID     = C_NCM.ORGANIZATION_ID (+)

AND   MSITL.INVENTORY_ITEM_ID   = C_PLAN.INVENTORY_ITEM_ID(+)
AND   MSITL.ORGANIZATION_ID     = C_PLAN.ORGANIZATION_ID(+)

AND   MSITL.INVENTORY_ITEM_ID   = C_CUST.INVENTORY_ITEM_ID(+)
AND   MSITL.ORGANIZATION_ID     = C_CUST.ORGANIZATION_ID(+)

AND   MSITL.INVENTORY_ITEM_ID   = C_PO.INVENTORY_ITEM_ID(+)
AND   MSITL.ORGANIZATION_ID     = C_PO.ORGANIZATION_ID(+)

AND   MSITL.INVENTORY_ITEM_ID   = CATALOGO.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = CATALOGO.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = NICK.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = NICK.ORGANIZATION_ID    (+)


AND   MSITL.INVENTORY_ITEM_ID   = ANO_FAB.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = ANO_FAB.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = ANO_MOD.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = ANO_MOD.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = COR.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = COR.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = CILINDRADA.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = CILINDRADA.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = POTENCIA.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = POTENCIA.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = RENAVAN.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = RENAVAN.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = DCRE.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = DCRE.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = NUM_PASS.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = NUM_PASS.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = DIST_EIXO.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = DIST_EIXO.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = PINTURA.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = PINTURA.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = COMBUSTIVEL.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = COMBUSTIVEL.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = TIPO_VEICULO.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = TIPO_VEICULO.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = ESP_VEICULO.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = ESP_VEICULO.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = PBT.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = PBT.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = NOME_COMERCIAL.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = NOME_COMERCIAL.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = CV.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = CV.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = PESO_EMBALAGEM.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = PESO_EMBALAGEM.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = LINHA.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = LINHA.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = CAT_MOTOR.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = CAT_MOTOR.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = UNID_MEDIDA.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = UNID_MEDIDA.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = COR_RENAVAM.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = COR_RENAVAM.ORGANIZATION_ID    (+)

AND   MSITL.INVENTORY_ITEM_ID   = COR_PROD.INVENTORY_ITEM_ID (+)
AND   MSITL.ORGANIZATION_ID     = COR_PROD.ORGANIZATION_ID    (+)


AND   MSITL.LANGUAGE            = 'PTB'
AND   FLVT.LOOKUP_TYPE          = 'ITEM_TYPE'
AND   FLVT.APPLICATION_ID       = 401  --Inventory
AND   FLVT.LOOKUP_TYPE          = FLVV.LOOKUP_TYPE
AND   OOD.ORGANIZATION_CODE     <> 'MA'
AND   FLVV.LOOKUP_CODE          = NVL(MSIB.ITEM_TYPE,'00')
AND   MSITL.ORGANIZATION_ID     = MSIFV.ORGANIZATION_ID
AND   MSITL.INVENTORY_ITEM_ID   = MSIFV.INVENTORY_ITEM_ID
AND   MSITL.INVENTORY_ITEM_ID   = MANU.INVENTORY_ITEM_ID (+)
--AND   MSITL.ORGANIZATION_ID     = MANU.ORGANIZATION_ID   (+)
--AND   MSIB.ATTRIBUTE1             IS NOT NULL
AND   nvl(MSIB.INVENTORY_ITEM_STATUS_CODE,'XXX') = 'Active'
AND   OOD.ORGANIZATION_CODE     = SOME ('A06','B01')

ORDER BY 2;
