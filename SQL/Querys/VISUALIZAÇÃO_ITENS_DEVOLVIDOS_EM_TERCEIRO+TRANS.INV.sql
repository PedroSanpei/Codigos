with trx_dev as (select inventory_item_id,
                        transaction_set_id,
                        transaction_reference,
                        transaction_type_id,
                        sum(abs(primary_quantity)) primary_quantity
                 from apps.mtl_material_transactions
                 where 1=1
                 and   organization_id = 164
                 and   transaction_type_id = 140
                 group by inventory_item_id,
                          transaction_set_id,
                          transaction_reference,
                          transaction_type_id
                 order by inventory_item_id,
                          to_number(transaction_reference),
                          transaction_set_id),
     --
     ter_dev as (select inventory_item_id,
                        devolution_transaction_id,
                        tpa_devolutions_control_id,
                        trx_number,
                        sum(devolution_quantity) devolution_quantity
                 from apps.cll_f513_tpa_devolutions_ctrl
                 where 1=1
                 and   devolution_status = 'COMPLETE'
                 and   nvl(cancel_flag, 'N') = 'N'
                 group by inventory_item_id,
                          devolution_transaction_id,
                          tpa_devolutions_control_id,
                          trx_number
                 order by inventory_item_id,
                          tpa_devolutions_control_id,
                          devolution_transaction_id)
--
select ter_dev.inventory_item_id,
       ter_dev.tpa_devolutions_control_id,
       ter_dev.trx_number,
       ter_dev.devolution_transaction_id,
       ter_dev.devolution_quantity,
       trx_dev.inventory_item_id,
       trx_dev.transaction_reference,
       trx_dev.transaction_set_id,
       trx_dev.primary_quantity
from trx_dev full outer join ter_dev
on    1=1
and   trx_dev.inventory_item_id     = ter_dev.inventory_item_id
and   trx_dev.transaction_set_id    = ter_dev.devolution_transaction_id
and   trx_dev.transaction_reference = ter_dev.tpa_devolutions_control_id;