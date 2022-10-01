SELECT

    A.WIP_ENTITY_ID,
    A.WIP_ENTITY_NAME OP_KMB,
    L.MEANING STATUS_OP_KMB,
    TO_CHAR(A.DT_PRODUCAO,'DD/MM/YYYY HH:MM:SS')DT_PRODUCAO,
    TO_CHAR(A.CREATION_DATE,'DD/MM/YYYY HH:MM:SS') DT_CRIACAO,
    A.CD_ITEM MODELO,
    A.NR_CHASSI,
    B.REQUISITION_HEADER_ID,
    B.SEGMENT1 RC,
    B.ATTRIBUTE15,
    b.authorization_status RC_STATUS,
    SUBSTR(B.DESCRIPTION,28,3) TIPO_ORDEM,
    D.SEGMENT1 ITEM,
    E.SEGMENT1 PO,
    F.HEADER_ID,
    F.ORDER_NUMBER OV,
    f.flow_status_code,
    J.WIP_ENTITY_NAME OP_KCA
    
FROM
    DTT_WIP_PROGRAMACAO_OP_V    A
JOIN WIP_DISCRETE_JOBS K ON A.WIP_ENTITY_ID = K.WIP_ENTITY_ID
JOIN FND_LOOKUP_VALUES_VL L ON TO_CHAR(K.STATUS_TYPE) = L.LOOKUP_CODE
---------------------------------------------------------------------------------------
LEFT JOIN  PO_REQUISITION_HEADERS_ALL  B ON A.NR_CHASSI = B.ATTRIBUTE2
JOIN PO_REQUISITION_LINES_ALL C ON B.REQUISITION_HEADER_ID = C.REQUISITION_HEADER_ID
JOIN MTL_SYSTEM_ITEMS_B  D ON C.ITEM_ID = D.INVENTORY_ITEM_ID
----------------------------------------------------------------------------------------
LEFT JOIN PO_HEADERS_ALL E ON B.SEGMENT1 = E.INTERFACE_SOURCE_CODE 
----------------------------------------------------------------------------------------
LEFT JOIN OE_ORDER_HEADERS_ALL F ON B.SEGMENT1 = F.ORIG_SYS_DOCUMENT_REF 
LEFT JOIN OE_ORDER_LINES_ALL G ON F.HEADER_ID = G.HEADER_ID
AND C.ITEM_ID = G.INVENTORY_ITEM_ID
---------------------------------------------------------------------------------------
LEFT JOIN WIP_DISCRETE_JOBS H ON G.LINE_ID = H.SOURCE_LINE_ID
--JOIN FND_LOOKUP_VALUES_VL I ON TO_CHAR(H.STATUS_TYPE) = I.LOOKUP_CODE
LEFT JOIN WIP_ENTITIES J ON H.WIP_ENTITY_ID = J.WIP_ENTITY_ID
---------------------------------FILTROS DE RELACIONAMENTO------------------------------
WHERE   A.ORGANIZATION_ID = D.ORGANIZATION_ID                                           
AND     L.LOOKUP_TYPE = 'WIP_JOB_STATUS'
AND     A.ORGANIZATION_ID = '149'
AND     D.ORGANIZATION_ID = '149'
AND     b.cancel_flag IS NULL
AND     e.cancel_flag = 'N'
---------------------------------FILTROS PESQUISA---------------------------------------
AND     A.WIP_ENTITY_NAME = '361689'                                                  
--AND     A.CREATION_DATE BETWEEN '08/06/2022' AND '09/06/2022'                         
--AND     A.DT_PRODUCAO BETWEEN '20/06/2022' AND '22/06/2022'                           
--AND     f.order_number = '50024'                                                      
--AND       a.wip_entity_name in ('361694')--,'361704')A                                
--AND     A.CD_ITEM = 'ZRT00H-G3A1 CINZA'                                               
---------------------------------ORDERNAR POR-------------------------------------------
ORDER BY a.wip_entity_name desc

