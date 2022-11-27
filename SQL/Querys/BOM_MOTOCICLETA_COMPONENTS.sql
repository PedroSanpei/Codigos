--SELECT MODELO MOTO
SELECT DISTINCT
    bom.assembly_item_id,
    msib.segment1,
    msib.description,
    com.operation_seq_num,
    com.component_item_id,
    msib1.segment1

FROM 
    bom_bill_of_materials     bom,
    mtl_system_items_b        msib,
    bom_inventory_components  com,
    mtl_system_items_b        msib1
      
where
    bom.assembly_item_id = msib.inventory_item_id
AND 
    bom.bill_sequence_id = com.bill_sequence_id
AND 
    bom.organization_id = com.pk2_value
AND 
    com.component_item_id = msib1.inventory_item_id
AND
    com.operation_seq_num IN ('10','30')
AND 
    msib.segment1 IN ('EN650D-J3A1 PRETA');
--AND com.component_item_id  ;


-- SELECT ITENS X MOTO (Itens KMB e KCA)
SELECT DISTINCT
    bom.assembly_item_id,
    msib.segment1,
    msib.description,
    com.operation_seq_num,
    bom.organization_id,
    com.component_item_id,
    msib1.segment1,
    msib1.description,
    com.component_quantity,
    com.quantity_related,
    com.so_basis,
    com.pick_components,
    com.supply_subinventory
FROM
    bom_bill_of_materials     bom,
    bom_inventory_components  com,
    mtl_system_items_b        msib,
    mtl_system_items_b        msib1
WHERE
        1 = 1
    AND bom.assembly_item_id = msib.inventory_item_id
    AND com.component_item_id = msib1.inventory_item_id
    AND bom.bill_sequence_id = com.bill_sequence_id
    AND bom.organization_id = com.pk2_value
    AND msib.segment1 IN ('EN650D-J3A1  BK1', 'EN650D-J3A1  MTG');
    
    

select * from mtl_system_items_b where inventory_item_id = '368017';

select * from bill_sequence_id;