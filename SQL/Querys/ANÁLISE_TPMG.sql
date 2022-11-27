-----Comparação de lançamentos devolução TPMG e registro no INV sumariado por item
select ter_inventory_item_id,
       trx_inventory_item_id,
       sum(devolution_quantity) devolution_quantity,
       sum(primary_quantity) primary_quantity
from (
      with trx_dev as (select inventory_item_id trx_inventory_item_id,
                              sum(abs(primary_quantity)) primary_quantity
                       from apps.mtl_material_transactions
                       where 1=1
                       and   organization_id = 164
                       and   transaction_type_id = 140
                       group by inventory_item_id
                       order by inventory_item_id),
           --
           ter_dev as (select inventory_item_id ter_inventory_item_id,
                              sum(devolution_quantity) devolution_quantity
                       from apps.cll_f513_tpa_devolutions_ctrl
                       where 1=1
                       and   devolution_status = 'COMPLETE'
                       and   nvl(cancel_flag, 'N') = 'N'
                       group by inventory_item_id
                       order by inventory_item_id)
      --
      select ter_dev.ter_inventory_item_id,
             ter_dev.devolution_quantity,
             trx_dev.trx_inventory_item_id,
             trx_dev.primary_quantity
      from trx_dev full outer join ter_dev
      on    1=1
      and   trx_dev.trx_inventory_item_id     = ter_dev.ter_inventory_item_id
      )
group by ter_inventory_item_id,
         trx_inventory_item_id
order by ter_inventory_item_id;


--Comparação de lançamentos recebimentos TPMG e registro no INV sumariado por item
select ter_inventory_item_id,
       trx_inventory_item_id,
       sum(received_quantity) received_quantity,
       sum(primary_quantity) primary_quantity
from (with trx_rec as (select inventory_item_id trx_inventory_item_id,
                              sum(primary_quantity) primary_quantity
                       from apps.mtl_material_transactions mmt
                       where 1=1
                       and   organization_id = 164
                       and   transaction_type_id = 144
                       and   not exists (select 1
                                         from apps.cll_f513_tpa_devolutions_ctrl cfdev
                                         where cfdev.cancel_transaction_id = mmt.transaction_set_id)
                       group by inventory_item_id
                       order by inventory_item_id),
           --
           ter_rec as (select inventory_item_id ter_inventory_item_id,
                              sum(received_quantity) received_quantity
                       from apps.cll_f513_tpa_receipts_control
                       where 1=1
                       and   organization_id = 164
                       and   operation_status = 'COMPLETE'
                       and   reversion_flag is null
                       group by inventory_item_id
                       order by inventory_item_id)
      --
      select ter_rec.ter_inventory_item_id,
             ter_rec.received_quantity,
             trx_rec.trx_inventory_item_id,
             trx_rec.primary_quantity
      from trx_rec full outer join ter_rec
      on    1=1
      and   trx_rec.trx_inventory_item_id = ter_rec.ter_inventory_item_id)
group by ter_inventory_item_id,
         trx_inventory_item_id
order by ter_inventory_item_id;


--Comparação de lançamentos de devolução TPMG e registro no INV detalhado por lançamento de NF
with trx_dev as (select inventory_item_id trx_inventory_item_id,
                        transaction_set_id,
                        transaction_reference,
                        transaction_type_id,
                        sum(abs(primary_quantity)) primary_quantity
                 from apps.mtl_material_transactions
                 where 1=1
                 and   organization_id = 164
                 --and   inventory_item_id = 7265
                 and   transaction_type_id = 140
                 group by inventory_item_id,
                          transaction_set_id,
                          transaction_reference,
                          transaction_type_id
                 order by inventory_item_id,
                          to_number(transaction_reference),
                          transaction_set_id),
     --
     ter_dev as (select inventory_item_id ter_inventory_item_id,
                        devolution_transaction_id,
                        tpa_devolutions_control_id,
                        sum(devolution_quantity) devolution_quantity
                 from apps.cll_f513_tpa_devolutions_ctrl
                 where 1=1
                 --and   inventory_item_id = 7265
                 and   devolution_status = 'COMPLETE'
                 and   nvl(cancel_flag, 'N') = 'N'
                 group by inventory_item_id,
                          devolution_transaction_id,
                          tpa_devolutions_control_id
                 order by inventory_item_id,
                          tpa_devolutions_control_id,
                          devolution_transaction_id)
--
select ter_dev.ter_inventory_item_id,
       ter_dev.tpa_devolutions_control_id,
       ter_dev.devolution_transaction_id,
       ter_dev.devolution_quantity,
       trx_dev.trx_inventory_item_id,
       trx_dev.transaction_reference,
       trx_dev.transaction_set_id,
       trx_dev.primary_quantity
from trx_dev full outer join ter_dev
on    1=1
and   trx_dev.trx_inventory_item_id     = ter_dev.ter_inventory_item_id
and   trx_dev.transaction_set_id    = ter_dev.devolution_transaction_id
and   trx_dev.transaction_reference = ter_dev.tpa_devolutions_control_id
order by ter_dev.ter_inventory_item_id,
         trx_dev.trx_inventory_item_id;


--Comparação de lançamentos de recebimentos TPMG e registro no INV detalhado por lançamento de NF
with trx_rec as (select inventory_item_id trx_inventory_item_id,
                        transaction_set_id,
                        to_number(transaction_reference) transaction_reference,
                        transaction_type_id,
                        sum(primary_quantity) primary_quantity
                 from apps.mtl_material_transactions mmt
                 where 1=1
                 and   organization_id = 164
                 and   transaction_type_id = 144
                 --and   inventory_item_id = 7265
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
     ter_rec as (select inventory_item_id ter_inventory_item_id,
                        receipt_transaction_id,
                        tpa_receipts_control_id,
                        sum(received_quantity) received_quantity
                 from apps.cll_f513_tpa_receipts_control
                 where 1=1
                 and   organization_id = 164
                 --and   inventory_item_id = 7265
                 and   operation_status = 'COMPLETE'
                 and   reversion_flag is null
                 group by inventory_item_id,
                          receipt_transaction_id,
                          tpa_receipts_control_id
                 order by inventory_item_id,
                          tpa_receipts_control_id,
                          receipt_transaction_id)
--
select ter_rec.ter_inventory_item_id,
       ter_rec.tpa_receipts_control_id,
       ter_rec.receipt_transaction_id,
       ter_rec.received_quantity,
       trx_rec.trx_inventory_item_id,
       trx_rec.transaction_reference,
       trx_rec.transaction_set_id,
       trx_rec.primary_quantity
from trx_rec full outer join ter_rec
on    1=1
and   trx_rec.trx_inventory_item_id = ter_rec.ter_inventory_item_id
and   trx_rec.transaction_set_id    = ter_rec.receipt_transaction_id
and   trx_rec.transaction_reference = ter_rec.receipt_transaction_id
order by ter_rec.ter_inventory_item_id,
         trx_rec.trx_inventory_item_id;




select inventory_item_id, sum(primary_transaction_quantity) inv_balance
from apps.mtl_onhand_quantities_detail
where organization_id = 164
and   inventory_item_id = some(4196,4199,6805,6809,6813,7016,7257,7258,7265,7268,7274,7280,7282,7286,7292,9475,9542,9543,10346,11657,15189,375031,393067,393068,393069,419039,452031,452032)
group by inventory_item_id;