with trx_rec as (select inventory_item_id,
                        transaction_set_id,
                        to_number(transaction_reference) transaction_reference,
                        transaction_type_id,
                        sum(primary_quantity) primary_quantity
                 from apps.mtl_material_transactions mmt
                 where 1=1
                 and   organization_id = 164
                 and   transaction_type_id = 144
                 --and   inventory_item_id = 6809
                 and   not exists (select 1
                                   from apps.cll_f513_tpa_devolutions_ctrl cfdev
                                   where cfdev.cancel_transaction_id = mmt.transaction_set_id)
                 group by inventory_item_id,
                          transaction_set_id,
                          transaction_reference,
                          transaction_type_id
                 order by inventory_item_id,
                          to_number(transaction_reference),
                          transaction_set_id),
     --
     ter_rec as (select inventory_item_id,
                        receipt_transaction_id,
                        tpa_receipts_control_id,
                        sum(received_quantity) received_quantity
                 from apps.cll_f513_tpa_receipts_control
                 where 1=1
                 and   organization_id = 164
                 --and   inventory_item_id = 6809
                 and   operation_status = 'COMPLETE'
                 and   reversion_flag is null
                 group by inventory_item_id,
                          receipt_transaction_id,
                          tpa_receipts_control_id
                 order by inventory_item_id,
                          tpa_receipts_control_id,
                          receipt_transaction_id)
--
select ter_rec.inventory_item_id,
       ter_rec.tpa_receipts_control_id,
       ter_rec.receipt_transaction_id,
       ter_rec.received_quantity,
       trx_rec.inventory_item_id,
       trx_rec.transaction_reference,
       trx_rec.transaction_set_id,
       trx_rec.primary_quantity
from trx_rec full outer join ter_rec
on    1=1
and   trx_rec.inventory_item_id     = ter_rec.inventory_item_id
and   trx_rec.transaction_set_id    = ter_rec.receipt_transaction_id
and   trx_rec.transaction_reference = ter_rec.receipt_transaction_id;