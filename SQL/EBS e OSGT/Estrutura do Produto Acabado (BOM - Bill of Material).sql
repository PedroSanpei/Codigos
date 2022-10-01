select ood.organization_code,
       msi1.segment1 assembly_item,
       bbom.description assembly_item_description,
       bbom.uom,
       bbom.item_type assembly_item_type,
       bbom.implementation_date assembly_implem_date,
       bbom.bom_enabled_flag,
       msi2.segment1 component_item,
       bic.operation_seq_num,
       bic.item_num component_seq,
       bic.description component_item_description,
       bic.primary_uom_code,
       bic.component_quantity,
       bic.supply_subinventory,
       bic.supply_type,
       bic.implementation_date component_implem_date,
       bic.disable_date
from apps.bom_bill_of_materials_v      bbom,
     apps.bom_inventory_components_v   bic,
     apps.mtl_system_items_b           msi1,
     apps.mtl_system_items_b           msi2,
     apps.org_organization_definitions ood
where msi1.organization_id   = bbom.organization_id
and   msi1.inventory_item_id = bbom.assembly_item_id
and   ood.organization_id    = bbom.organization_id
and   bic.bill_sequence_id   = bbom.bill_sequence_id
and   msi2.organization_id   = ood.organization_id
and   msi2.inventory_item_id = bic.component_item_id
order by ood.organization_code,
         msi1.segment1,
         bic.operation_seq_num,
         bic.item_num;
