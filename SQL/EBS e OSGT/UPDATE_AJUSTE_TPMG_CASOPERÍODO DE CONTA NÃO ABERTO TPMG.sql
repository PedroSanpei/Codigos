declare
  g_vTitle                      fnd_lookup_values.description                          %TYPE ;
  g_vProgram_name               fnd_concurrent_programs_tl.user_concurrent_program_name%TYPE ;
  g_err_upd_tpa_returns         fnd_lookup_values.description                          %TYPE := 'CLL_F513_ERR_TPA_RETURN_CTRL' ;
  g_vSeparator                  VARCHAR2(10) := '  ' ;
  g_nLength_output              NUMBER := 194 ;
  g_nLength_log                 NUMBER := 77  ;
  --
  -- BUG 29625111 - Start
  g_rec_trans_iface         mtl_transactions_interface    %ROWTYPE ;
  g_rec_trans_lots_iface    mtl_transaction_lots_interface%ROWTYPE ;
  g_rec_serial_num_iface    mtl_serial_numbers_interface  %ROWTYPE ;
  g_rec_remit_control       cll_f513_tpa_remit_control    %ROWTYPE ;
  g_rec_tpa_control_log     cll_f513_tpa_control_log      %ROWTYPE ;
  g_crec_trans_iface        mtl_transactions_interface    %ROWTYPE ;
  g_crec_trans_lots_iface   mtl_transaction_lots_interface%ROWTYPE ;
  g_crec_serial_num_iface   mtl_serial_numbers_interface  %ROWTYPE ;
  g_crec_remit_control      cll_f513_tpa_remit_control    %ROWTYPE ;
  g_crec_tpa_control_log    cll_f513_tpa_control_log      %ROWTYPE ;
  g_rec_tpa_devol_ctrl      cll_f513_tpa_devolutions_ctrl %ROWTYPE ;
  g_crec_tpa_devol_ctrl     cll_f513_tpa_devolutions_ctrl %ROWTYPE ;
  g_msg_retorno             VARCHAR2(1000) ;
  --
  FUNCTION GET_LOOKUP_VALUES (p_lookup_type    IN  VARCHAR2 DEFAULT NULL
                             ,p_lookup_code    IN  VARCHAR2 DEFAULT NULL
                             ) RETURN VARCHAR2 IS
    --
    l_description      fnd_lookup_values_vl.description%type;
    --
  BEGIN
    BEGIN
        SELECT description
          INTO l_description
          FROM apps.fnd_lookup_values_vl
         WHERE lookup_type           = p_lookup_type
           AND lookup_code           = p_lookup_code
           AND NVL(enabled_flag,'N') = 'Y'
           AND NVL(end_date_active,SYSDATE) >= SYSDATE;
    EXCEPTION
      WHEN others THEN
        l_description := NULL;
    END;
    --
    RETURN l_description;
    --
  END GET_LOOKUP_VALUES;
  --
  PROCEDURE INSERT_TPA_CONTROL_LOG_P (rec_tpa_control_log IN cll_f513_tpa_control_log%ROWTYPE, msg_retorno OUT NOCOPY VARCHAR2) IS
  l_msg_retorno  VARCHAR2(1000) ;
  BEGIN
    --
    BEGIN
      --
      INSERT INTO cll_f513_tpa_control_log
           ( attribute_category                                 , attribute1                                         , attribute10
           , attribute11                                        , attribute12                                        , attribute13
           , attribute14                                        , attribute15                                        , attribute16
           , attribute17                                        , attribute18                                        , attribute19
           , attribute2                                         , attribute20                                        , attribute3
           , attribute4                                         , attribute5                                         , attribute6
           , attribute7                                         , attribute8                                         , attribute9
           , cancel_transaction_id                              , created_by                                         , creation_date
           , customer_name                                      , customer_number                                    , customer_trx_id
           , customer_trx_line_id                               , devolution_transaction_id                          , invoice_number
           , item_number                                        , last_update_date                                   , last_updated_by
           , last_update_login                                  , line_number                                        , lot_number
           , operation_id                                       , org_id                                             , process_description
           , process_source                                     , process_status                                     , program_application_id
           , program_id                                         , program_update_date                                , receipt_transaction_id
           , request_id                                         , returned_transaction_id                            , reversion_transaction_id
           , segment1                                           , serial_number                                      , source_locat_code
           , source_locator_code                                , source_subinventory                                , status
           , tpa_control_log_id                                 , tpa_devolutions_control_id                         , tpa_receipt_control_id
           , tpa_remit_control_id                               , tpa_return_control_id                              , transaction_interface_id
           , trx_number
           ) VALUES
           ( rec_tpa_control_log.attribute_category             , rec_tpa_control_log.attribute1                     , rec_tpa_control_log.attribute10
           , rec_tpa_control_log.attribute11                    , rec_tpa_control_log.attribute12                    , rec_tpa_control_log.attribute13
           , rec_tpa_control_log.attribute14                    , rec_tpa_control_log.attribute15                    , rec_tpa_control_log.attribute16
           , rec_tpa_control_log.attribute17                    , rec_tpa_control_log.attribute18                    , rec_tpa_control_log.attribute19
           , rec_tpa_control_log.attribute2                     , rec_tpa_control_log.attribute20                    , rec_tpa_control_log.attribute3
           , rec_tpa_control_log.attribute4                     , rec_tpa_control_log.attribute5                     , rec_tpa_control_log.attribute6
           , rec_tpa_control_log.attribute7                     , rec_tpa_control_log.attribute8                     , rec_tpa_control_log.attribute9
           , rec_tpa_control_log.cancel_transaction_id          , rec_tpa_control_log.created_by                     , rec_tpa_control_log.creation_date
           , rec_tpa_control_log.customer_name                  , rec_tpa_control_log.customer_number                , rec_tpa_control_log.customer_trx_id
           , rec_tpa_control_log.customer_trx_line_id           , rec_tpa_control_log.devolution_transaction_id      , rec_tpa_control_log.invoice_number
           , rec_tpa_control_log.item_number                    , rec_tpa_control_log.last_update_date               , rec_tpa_control_log.last_updated_by
           , rec_tpa_control_log.last_update_login              , rec_tpa_control_log.line_number                    , rec_tpa_control_log.lot_number
           , rec_tpa_control_log.operation_id                   , rec_tpa_control_log.org_id                         , rec_tpa_control_log.process_description
           , rec_tpa_control_log.process_source                 , rec_tpa_control_log.process_status                 , rec_tpa_control_log.program_application_id
           , rec_tpa_control_log.program_id                     , rec_tpa_control_log.program_update_date            , rec_tpa_control_log.receipt_transaction_id
           , rec_tpa_control_log.request_id                     , rec_tpa_control_log.returned_transaction_id        , rec_tpa_control_log.reversion_transaction_id
           , rec_tpa_control_log.segment1                       , rec_tpa_control_log.serial_number                  , rec_tpa_control_log.source_locat_code
           , rec_tpa_control_log.source_locator_code            , rec_tpa_control_log.source_subinventory            , rec_tpa_control_log.status
           , rec_tpa_control_log.tpa_control_log_id             , rec_tpa_control_log.tpa_devolutions_control_id     , rec_tpa_control_log.tpa_receipt_control_id
           , rec_tpa_control_log.tpa_remit_control_id           , rec_tpa_control_log.tpa_return_control_id          , rec_tpa_control_log.transaction_interface_id
           , rec_tpa_control_log.trx_number
           ) ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_msg_retorno := 'TPA_CONTROL_LOG_P: '||SQLERRM ;
    END ;
    --
    msg_retorno := l_msg_retorno ;
    --
  END INSERT_TPA_CONTROL_LOG_P ;
  --
  PROCEDURE INSERT_TRANS_IFACE_P (rec_trans_iface IN mtl_transactions_interface%ROWTYPE, msg_retorno OUT NOCOPY VARCHAR2) IS
  l_msg_retorno  VARCHAR2(1000) := null;
  BEGIN
    --
    BEGIN
      --
      INSERT INTO mtl_transactions_interface
           ( accounting_class                                   , acct_period_id                                     , alternate_bom_designator
           , alternate_routing_designator                       , attribute_category                                 , attribute1
           , attribute10                                        , attribute11                                        , attribute12
           , attribute13                                        , attribute14                                        , attribute15
           , attribute2                                         , attribute3                                         , attribute4
           , attribute5                                         , attribute6                                         , attribute7
           , attribute8                                         , attribute9                                         , bom_revision
           , bom_revision_date                                  , build_sequence                                     , completion_transaction_id
           , containers                                         , content_lpn_id                                     , cost_group_id
           , cost_type_id                                       , created_by                                         , creation_date
           , currency_code                                      , currency_conversion_date                           , currency_conversion_rate
           , currency_conversion_type                           , customer_ship_id                                   , demand_class
           , demand_id                                          , demand_source_delivery                             , demand_source_header_id
           , demand_source_line                                 , department_id                                      , distribution_account_id
           , dsp_segment1                                       , dsp_segment10                                      , dsp_segment11
           , dsp_segment12                                      , dsp_segment13                                      , dsp_segment14
           , dsp_segment15                                      , dsp_segment16                                      , dsp_segment17
           , dsp_segment18                                      , dsp_segment19                                      , dsp_segment2
           , dsp_segment20                                      , dsp_segment21                                      , dsp_segment22
           , dsp_segment23                                      , dsp_segment24                                      , dsp_segment25
           , dsp_segment26                                      , dsp_segment27                                      , dsp_segment28
           , dsp_segment29                                      , dsp_segment3                                       , dsp_segment30
           , dsp_segment4                                       , dsp_segment5                                       , dsp_segment6
           , dsp_segment7                                       , dsp_segment8                                       , dsp_segment9
           , dst_segment1                                       , dst_segment10                                      , dst_segment11
           , dst_segment12                                      , dst_segment13                                      , dst_segment14
           , dst_segment15                                      , dst_segment16                                      , dst_segment17
           , dst_segment18                                      , dst_segment19                                      , dst_segment2
           , dst_segment20                                      , dst_segment21                                      , dst_segment22
           , dst_segment23                                      , dst_segment24                                      , dst_segment25
           , dst_segment26                                      , dst_segment27                                      , dst_segment28
           , dst_segment29                                      , dst_segment3                                       , dst_segment30
           , dst_segment4                                       , dst_segment5                                       , dst_segment6
           , dst_segment7                                       , dst_segment8                                       , dst_segment9
           , employee_code                                      , encumbrance_account                                , encumbrance_amount
           , end_item_unit_number                               , error_code                                         , error_explanation
           , expected_arrival_date                              , expenditure_type                                   , final_completion_flag
           , flow_schedule                                      , freight_code                                       , inventory_item
           , inventory_item_id                                  , item_segment1                                      , item_segment10
           , item_segment11                                     , item_segment12                                     , item_segment13
           , item_segment14                                     , item_segment15                                     , item_segment16
           , item_segment17                                     , item_segment18                                     , item_segment19
           , item_segment2                                      , item_segment20                                     , item_segment3
           , item_segment4                                      , item_segment5                                      , item_segment6
           , item_segment7                                      , item_segment8                                      , item_segment9
           , kanban_card_id                                     , last_update_date                                   , last_updated_by
           , last_update_login                                  , line_item_num                                      , locator_id
           , locator_name                                       , lock_flag                                          , loc_segment1
           , loc_segment10                                      , loc_segment11                                      , loc_segment12
           , loc_segment13                                      , loc_segment14                                      , loc_segment15
           , loc_segment16                                      , loc_segment17                                      , loc_segment18
           , loc_segment19                                      , loc_segment2                                       , loc_segment20
           , loc_segment3                                       , loc_segment4                                       , loc_segment5
           , loc_segment6                                       , loc_segment7                                       , loc_segment8
           , loc_segment9                                       , lpn_id                                             , material_account
           , material_expense_account                           , material_overhead_account                          , mcc_code
           , movement_id                                        , move_transaction_id                                , mrp_code
           , negative_req_flag                                  , new_average_cost                                   , operation_seq_num
           , organization_id                                    , organization_type                                  , org_cost_group_id
           , outside_processing_account                         , overcompletion_primary_qty                         , overcompletion_transaction_id
           , overcompletion_transaction_qty                     , overhead_account                                   , owning_organization_id
           , owning_tp_type                                     , pa_expenditure_org_id                              , parent_id
           , percentage_change                                  , picking_line_id                                    , planning_organization_id
           , planning_tp_type                                   , primary_quantity                                   , primary_switch
           , process_flag                                       , program_application_id                             , program_id
           , program_update_date                                , project_id                                         , qa_collection_id
           , rcv_transaction_id                                 , reason_id                                          , rebuild_activity_id
           , rebuild_item_id                                    , rebuild_job_name                                   , rebuild_serial_number
           , receiving_document                                 , relieve_high_level_rsv_flag                        , relieve_reservations_flag
           , repetitive_line_id                                 , representative_lot_number                          , request_id
           , required_flag                                      , requisition_distribution_id                        , requisition_line_id
           , reservation_quantity                               , resource_account                                   , revision
           , routing_revision                                   , routing_revision_date                              , scheduled_flag
           , scheduled_payback_date                             , schedule_group                                     , schedule_id
           , schedule_number                                    , schedule_update_code                               , secondary_transaction_quantity
           , secondary_uom_code                                 , setup_teardown_code                                , shipment_number
           , shippable_flag                                     , shipped_quantity                                   , ship_to_location_id
           , source_code                                        , source_header_id                                   , source_line_id
           , source_lot_number                                  , source_project_id                                  , source_task_id
           , subinventory_code                                  , substitution_item_id                               , substitution_type_id
           , task_id                                            , to_project_id                                      , to_task_id
           , transaction_action_id                              , transaction_batch_id                               , transaction_batch_seq
           , transaction_cost                                   , transaction_date
           --, transaction_group_id                             , transaction_group_seq                              -- Bug 30001408
           , transaction_header_id                              , transaction_interface_id
           , transaction_mode                                   , transaction_quantity                               , transaction_reference
           , transaction_sequence_id                            , transaction_source_id                              , transaction_source_name
           , transaction_source_type_id                         , transaction_type_id                                , transaction_uom
           , transfer_cost                                      , transfer_cost_group_id                             , transfer_locator
           , transfer_lpn_id                                    , transfer_organization                              , transfer_organization_type
           , transfer_owning_tp_type                            , transfer_percentage                                , transfer_planning_tp_type
           , transfer_price                                     , transfer_subinventory                              , transportation_account
           , transportation_cost                                , trx_source_delivery_id                             , trx_source_line_id
           , ussgl_transaction_code                             , validation_required                                , value_change
           , vendor_lot_number                                  , waybill_airbill                                    , wip_entity_type
           , wip_supply_type                                    , xfer_loc_segment1                                  , xfer_loc_segment10
           , xfer_loc_segment11                                 , xfer_loc_segment12                                 , xfer_loc_segment13
           , xfer_loc_segment14                                 , xfer_loc_segment15                                 , xfer_loc_segment16
           , xfer_loc_segment17                                 , xfer_loc_segment18                                 , xfer_loc_segment19
           , xfer_loc_segment2                                  , xfer_loc_segment20                                 , xfer_loc_segment3
           , xfer_loc_segment4                                  , xfer_loc_segment5                                  , xfer_loc_segment6
           , xfer_loc_segment7                                  , xfer_loc_segment8                                  , xfer_loc_segment9
           , xfr_owning_organization_id                         , xfr_planning_organization_id                       , xml_document_id
           ) VALUES
           ( rec_trans_iface.accounting_class                   , rec_trans_iface.acct_period_id                     , rec_trans_iface.alternate_bom_designator
           , rec_trans_iface.alternate_routing_designator       , rec_trans_iface.attribute_category                 , rec_trans_iface.attribute1
           , rec_trans_iface.attribute10                        , rec_trans_iface.attribute11                        , rec_trans_iface.attribute12
           , rec_trans_iface.attribute13                        , rec_trans_iface.attribute14                        , rec_trans_iface.attribute15
           , rec_trans_iface.attribute2                         , rec_trans_iface.attribute3                         , rec_trans_iface.attribute4
           , rec_trans_iface.attribute5                         , rec_trans_iface.attribute6                         , rec_trans_iface.attribute7
           , rec_trans_iface.attribute8                         , rec_trans_iface.attribute9                         , rec_trans_iface.bom_revision
           , rec_trans_iface.bom_revision_date                  , rec_trans_iface.build_sequence                     , rec_trans_iface.completion_transaction_id
           , rec_trans_iface.containers                         , rec_trans_iface.content_lpn_id                     , rec_trans_iface.cost_group_id
           , rec_trans_iface.cost_type_id                       , rec_trans_iface.created_by                         , rec_trans_iface.creation_date
           , rec_trans_iface.currency_code                      , rec_trans_iface.currency_conversion_date           , rec_trans_iface.currency_conversion_rate
           , rec_trans_iface.currency_conversion_type           , rec_trans_iface.customer_ship_id                   , rec_trans_iface.demand_class
           , rec_trans_iface.demand_id                          , rec_trans_iface.demand_source_delivery             , rec_trans_iface.demand_source_header_id
           , rec_trans_iface.demand_source_line                 , rec_trans_iface.department_id                      , rec_trans_iface.distribution_account_id
           , rec_trans_iface.dsp_segment1                       , rec_trans_iface.dsp_segment10                      , rec_trans_iface.dsp_segment11
           , rec_trans_iface.dsp_segment12                      , rec_trans_iface.dsp_segment13                      , rec_trans_iface.dsp_segment14
           , rec_trans_iface.dsp_segment15                      , rec_trans_iface.dsp_segment16                      , rec_trans_iface.dsp_segment17
           , rec_trans_iface.dsp_segment18                      , rec_trans_iface.dsp_segment19                      , rec_trans_iface.dsp_segment2
           , rec_trans_iface.dsp_segment20                      , rec_trans_iface.dsp_segment21                      , rec_trans_iface.dsp_segment22
           , rec_trans_iface.dsp_segment23                      , rec_trans_iface.dsp_segment24                      , rec_trans_iface.dsp_segment25
           , rec_trans_iface.dsp_segment26                      , rec_trans_iface.dsp_segment27                      , rec_trans_iface.dsp_segment28
           , rec_trans_iface.dsp_segment29                      , rec_trans_iface.dsp_segment3                       , rec_trans_iface.dsp_segment30
           , rec_trans_iface.dsp_segment4                       , rec_trans_iface.dsp_segment5                       , rec_trans_iface.dsp_segment6
           , rec_trans_iface.dsp_segment7                       , rec_trans_iface.dsp_segment8                       , rec_trans_iface.dsp_segment9
           , rec_trans_iface.dst_segment1                       , rec_trans_iface.dst_segment10                      , rec_trans_iface.dst_segment11
           , rec_trans_iface.dst_segment12                      , rec_trans_iface.dst_segment13                      , rec_trans_iface.dst_segment14
           , rec_trans_iface.dst_segment15                      , rec_trans_iface.dst_segment16                      , rec_trans_iface.dst_segment17
           , rec_trans_iface.dst_segment18                      , rec_trans_iface.dst_segment19                      , rec_trans_iface.dst_segment2
           , rec_trans_iface.dst_segment20                      , rec_trans_iface.dst_segment21                      , rec_trans_iface.dst_segment22
           , rec_trans_iface.dst_segment23                      , rec_trans_iface.dst_segment24                      , rec_trans_iface.dst_segment25
           , rec_trans_iface.dst_segment26                      , rec_trans_iface.dst_segment27                      , rec_trans_iface.dst_segment28
           , rec_trans_iface.dst_segment29                      , rec_trans_iface.dst_segment3                       , rec_trans_iface.dst_segment30
           , rec_trans_iface.dst_segment4                       , rec_trans_iface.dst_segment5                       , rec_trans_iface.dst_segment6
           , rec_trans_iface.dst_segment7                       , rec_trans_iface.dst_segment8                       , rec_trans_iface.dst_segment9
           , rec_trans_iface.employee_code                      , rec_trans_iface.encumbrance_account                , rec_trans_iface.encumbrance_amount
           , rec_trans_iface.end_item_unit_number               , rec_trans_iface.error_code                         , rec_trans_iface.error_explanation
           , rec_trans_iface.expected_arrival_date              , rec_trans_iface.expenditure_type                   , rec_trans_iface.final_completion_flag
           , rec_trans_iface.flow_schedule                      , rec_trans_iface.freight_code                       , rec_trans_iface.inventory_item
           , rec_trans_iface.inventory_item_id                  , rec_trans_iface.item_segment1                      , rec_trans_iface.item_segment10
           , rec_trans_iface.item_segment11                     , rec_trans_iface.item_segment12                     , rec_trans_iface.item_segment13
           , rec_trans_iface.item_segment14                     , rec_trans_iface.item_segment15                     , rec_trans_iface.item_segment16
           , rec_trans_iface.item_segment17                     , rec_trans_iface.item_segment18                     , rec_trans_iface.item_segment19
           , rec_trans_iface.item_segment2                      , rec_trans_iface.item_segment20                     , rec_trans_iface.item_segment3
           , rec_trans_iface.item_segment4                      , rec_trans_iface.item_segment5                      , rec_trans_iface.item_segment6
           , rec_trans_iface.item_segment7                      , rec_trans_iface.item_segment8                      , rec_trans_iface.item_segment9
           , rec_trans_iface.kanban_card_id                     , rec_trans_iface.last_update_date                   , rec_trans_iface.last_updated_by
           , rec_trans_iface.last_update_login                  , rec_trans_iface.line_item_num                      , rec_trans_iface.locator_id
           , rec_trans_iface.locator_name                       , rec_trans_iface.lock_flag                          , rec_trans_iface.loc_segment1
           , rec_trans_iface.loc_segment10                      , rec_trans_iface.loc_segment11                      , rec_trans_iface.loc_segment12
           , rec_trans_iface.loc_segment13                      , rec_trans_iface.loc_segment14                      , rec_trans_iface.loc_segment15
           , rec_trans_iface.loc_segment16                      , rec_trans_iface.loc_segment17                      , rec_trans_iface.loc_segment18
           , rec_trans_iface.loc_segment19                      , rec_trans_iface.loc_segment2                       , rec_trans_iface.loc_segment20
           , rec_trans_iface.loc_segment3                       , rec_trans_iface.loc_segment4                       , rec_trans_iface.loc_segment5
           , rec_trans_iface.loc_segment6                       , rec_trans_iface.loc_segment7                       , rec_trans_iface.loc_segment8
           , rec_trans_iface.loc_segment9                       , rec_trans_iface.lpn_id                             , rec_trans_iface.material_account
           , rec_trans_iface.material_expense_account           , rec_trans_iface.material_overhead_account          , rec_trans_iface.mcc_code
           , rec_trans_iface.movement_id                        , rec_trans_iface.move_transaction_id                , rec_trans_iface.mrp_code
           , rec_trans_iface.negative_req_flag                  , rec_trans_iface.new_average_cost                   , rec_trans_iface.operation_seq_num
           , rec_trans_iface.organization_id                    , rec_trans_iface.organization_type                  , rec_trans_iface.org_cost_group_id
           , rec_trans_iface.outside_processing_account         , rec_trans_iface.overcompletion_primary_qty         , rec_trans_iface.overcompletion_transaction_id
           , rec_trans_iface.overcompletion_transaction_qty     , rec_trans_iface.overhead_account                   , rec_trans_iface.owning_organization_id
           , rec_trans_iface.owning_tp_type                     , rec_trans_iface.pa_expenditure_org_id              , rec_trans_iface.parent_id
           , rec_trans_iface.percentage_change                  , rec_trans_iface.picking_line_id                    , rec_trans_iface.planning_organization_id
           , rec_trans_iface.planning_tp_type                   , rec_trans_iface.primary_quantity                   , rec_trans_iface.primary_switch
           , rec_trans_iface.process_flag                       , rec_trans_iface.program_application_id             , rec_trans_iface.program_id
           , rec_trans_iface.program_update_date                , rec_trans_iface.project_id                         , rec_trans_iface.qa_collection_id
           , rec_trans_iface.rcv_transaction_id                 , rec_trans_iface.reason_id                          , rec_trans_iface.rebuild_activity_id
           , rec_trans_iface.rebuild_item_id                    , rec_trans_iface.rebuild_job_name                   , rec_trans_iface.rebuild_serial_number
           , rec_trans_iface.receiving_document                 , rec_trans_iface.relieve_high_level_rsv_flag        , rec_trans_iface.relieve_reservations_flag
           , rec_trans_iface.repetitive_line_id                 , rec_trans_iface.representative_lot_number          , rec_trans_iface.request_id
           , rec_trans_iface.required_flag                      , rec_trans_iface.requisition_distribution_id        , rec_trans_iface.requisition_line_id
           , rec_trans_iface.reservation_quantity               , rec_trans_iface.resource_account                   , rec_trans_iface.revision
           , rec_trans_iface.routing_revision                   , rec_trans_iface.routing_revision_date              , rec_trans_iface.scheduled_flag
           , rec_trans_iface.scheduled_payback_date             , rec_trans_iface.schedule_group                     , rec_trans_iface.schedule_id
           , rec_trans_iface.schedule_number                    , rec_trans_iface.schedule_update_code               , rec_trans_iface.secondary_transaction_quantity
           , rec_trans_iface.secondary_uom_code                 , rec_trans_iface.setup_teardown_code                , rec_trans_iface.shipment_number
           , rec_trans_iface.shippable_flag                     , rec_trans_iface.shipped_quantity                   , rec_trans_iface.ship_to_location_id
           , rec_trans_iface.source_code                        , rec_trans_iface.source_header_id                   , rec_trans_iface.source_line_id
           , rec_trans_iface.source_lot_number                  , rec_trans_iface.source_project_id                  , rec_trans_iface.source_task_id
           , rec_trans_iface.subinventory_code                  , rec_trans_iface.substitution_item_id               , rec_trans_iface.substitution_type_id
           , rec_trans_iface.task_id                            , rec_trans_iface.to_project_id                      , rec_trans_iface.to_task_id
           , rec_trans_iface.transaction_action_id              , rec_trans_iface.transaction_batch_id               , rec_trans_iface.transaction_batch_seq
           , rec_trans_iface.transaction_cost                   , rec_trans_iface.transaction_date
           --, rec_trans_iface.transaction_group_id               , rec_trans_iface.transaction_group_seq              --Bug 30001408
           , rec_trans_iface.transaction_header_id              , rec_trans_iface.transaction_interface_id
           , rec_trans_iface.transaction_mode                   , rec_trans_iface.transaction_quantity               , rec_trans_iface.transaction_reference
           , rec_trans_iface.transaction_sequence_id            , rec_trans_iface.transaction_source_id              , rec_trans_iface.transaction_source_name
           , rec_trans_iface.transaction_source_type_id         , rec_trans_iface.transaction_type_id                , rec_trans_iface.transaction_uom
           , rec_trans_iface.transfer_cost                      , rec_trans_iface.transfer_cost_group_id             , rec_trans_iface.transfer_locator
           , rec_trans_iface.transfer_lpn_id                    , rec_trans_iface.transfer_organization              , rec_trans_iface.transfer_organization_type
           , rec_trans_iface.transfer_owning_tp_type            , rec_trans_iface.transfer_percentage                , rec_trans_iface.transfer_planning_tp_type
           , rec_trans_iface.transfer_price                     , rec_trans_iface.transfer_subinventory              , rec_trans_iface.transportation_account
           , rec_trans_iface.transportation_cost                , rec_trans_iface.trx_source_delivery_id             , rec_trans_iface.trx_source_line_id
           , rec_trans_iface.ussgl_transaction_code             , rec_trans_iface.validation_required                , rec_trans_iface.value_change
           , rec_trans_iface.vendor_lot_number                  , rec_trans_iface.waybill_airbill                    , rec_trans_iface.wip_entity_type
           , rec_trans_iface.wip_supply_type                    , rec_trans_iface.xfer_loc_segment1                  , rec_trans_iface.xfer_loc_segment10
           , rec_trans_iface.xfer_loc_segment11                 , rec_trans_iface.xfer_loc_segment12                 , rec_trans_iface.xfer_loc_segment13
           , rec_trans_iface.xfer_loc_segment14                 , rec_trans_iface.xfer_loc_segment15                 , rec_trans_iface.xfer_loc_segment16
           , rec_trans_iface.xfer_loc_segment17                 , rec_trans_iface.xfer_loc_segment18                 , rec_trans_iface.xfer_loc_segment19
           , rec_trans_iface.xfer_loc_segment2                  , rec_trans_iface.xfer_loc_segment20                 , rec_trans_iface.xfer_loc_segment3
           , rec_trans_iface.xfer_loc_segment4                  , rec_trans_iface.xfer_loc_segment5                  , rec_trans_iface.xfer_loc_segment6
           , rec_trans_iface.xfer_loc_segment7                  , rec_trans_iface.xfer_loc_segment8                  , rec_trans_iface.xfer_loc_segment9
           , rec_trans_iface.xfr_owning_organization_id         , rec_trans_iface.xfr_planning_organization_id       , rec_trans_iface.xml_document_id
           ) ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_msg_retorno := 'INSERT_TRANS_IFACE_P: '||SQLERRM ;
    END ;
    --
    msg_retorno := l_msg_retorno ;
    --
  END INSERT_TRANS_IFACE_P ;
  --
  PROCEDURE INSERT_TRANS_LOTS_IFACE_P (rec_trans_lots_iface IN mtl_transaction_lots_interface%ROWTYPE, msg_retorno OUT NOCOPY VARCHAR2) IS
  l_msg_retorno  VARCHAR2(1000) := null;
  BEGIN
    --
    BEGIN
      --
      INSERT INTO mtl_transaction_lots_interface
           ( age                                                     , attribute_category                                      , attribute1
           , attribute10                                             , attribute11                                             , attribute12
           , attribute13                                             , attribute14                                             , attribute15
           , attribute2                                              , attribute3                                              , attribute4
           , attribute5                                              , attribute6                                              , attribute7
           , attribute8                                              , attribute9                                              , best_by_date
           , c_attribute1                                            , c_attribute10                                           , c_attribute11
           , c_attribute12                                           , c_attribute13                                           , c_attribute14
           , c_attribute15                                           , c_attribute16                                           , c_attribute17
           , c_attribute18                                           , c_attribute19                                           , c_attribute2
           , c_attribute20                                           , c_attribute3                                            , c_attribute4
           , c_attribute5                                            , c_attribute6                                            , c_attribute7
           , c_attribute8                                            , c_attribute9                                            , change_date
           , color                                                   , created_by                                              , creation_date
           , curl_wrinkle_fold                                       , date_code                                               , d_attribute1
           , d_attribute10                                           , d_attribute2                                            , d_attribute3
           , d_attribute4                                            , d_attribute5                                            , d_attribute6
           , d_attribute7                                            , d_attribute8                                            , d_attribute9
           , description                                             , error_code                                              , expiration_action_code
           , expiration_action_date                                  , grade_code                                              , hold_date
           , item_size                                               , last_update_date                                        , last_updated_by
           , last_update_login                                       , length                                                  , length_uom
           , lot_attribute_category                                  , lot_expiration_date                                     , lot_number
           , maturity_date                                           , n_attribute1                                            , n_attribute10
           , n_attribute2                                            , n_attribute3                                            , n_attribute4
           , n_attribute5                                            , n_attribute6                                            , n_attribute7
           , n_attribute8                                            , n_attribute9                                            , origination_date
           , origination_type                                        , parent_item_id                                          , parent_lot_number
           , parent_object_id                                        , parent_object_id2                                       , parent_object_number
           , parent_object_number2                                   , parent_object_type                                      , parent_object_type2
           , place_of_origin                                         , primary_quantity                                        , process_flag
           , product_code                                            , product_transaction_id                                  , program_application_id
           , program_id                                              , program_update_date                                     , reason_code
           , reason_id                                               , recycled_content                                        , request_id
           , retest_date                                             , secondary_transaction_quantity                          , serial_transaction_temp_id
           , source_code                                             , source_line_id                                          , status_id
           , sublot_num                                              , supplier_lot_number                                     , territory_code
           , thickness                                               , thickness_uom                                           , transaction_interface_id
           , transaction_quantity                                    , vendor_id                                               , vendor_name
           , volume                                                  , volume_uom                                              , width
           , width_uom
           ) VALUES
           ( rec_trans_lots_iface.age                                , rec_trans_lots_iface.attribute_category                 , rec_trans_lots_iface.attribute1
           , rec_trans_lots_iface.attribute10                        , rec_trans_lots_iface.attribute11                        , rec_trans_lots_iface.attribute12
           , rec_trans_lots_iface.attribute13                        , rec_trans_lots_iface.attribute14                        , rec_trans_lots_iface.attribute15
           , rec_trans_lots_iface.attribute2                         , rec_trans_lots_iface.attribute3                         , rec_trans_lots_iface.attribute4
           , rec_trans_lots_iface.attribute5                         , rec_trans_lots_iface.attribute6                         , rec_trans_lots_iface.attribute7
           , rec_trans_lots_iface.attribute8                         , rec_trans_lots_iface.attribute9                         , rec_trans_lots_iface.best_by_date
           , rec_trans_lots_iface.c_attribute1                       , rec_trans_lots_iface.c_attribute10                      , rec_trans_lots_iface.c_attribute11
           , rec_trans_lots_iface.c_attribute12                      , rec_trans_lots_iface.c_attribute13                      , rec_trans_lots_iface.c_attribute14
           , rec_trans_lots_iface.c_attribute15                      , rec_trans_lots_iface.c_attribute16                      , rec_trans_lots_iface.c_attribute17
           , rec_trans_lots_iface.c_attribute18                      , rec_trans_lots_iface.c_attribute19                      , rec_trans_lots_iface.c_attribute2
           , rec_trans_lots_iface.c_attribute20                      , rec_trans_lots_iface.c_attribute3                       , rec_trans_lots_iface.c_attribute4
           , rec_trans_lots_iface.c_attribute5                       , rec_trans_lots_iface.c_attribute6                       , rec_trans_lots_iface.c_attribute7
           , rec_trans_lots_iface.c_attribute8                       , rec_trans_lots_iface.c_attribute9                       , rec_trans_lots_iface.change_date
           , rec_trans_lots_iface.color                              , rec_trans_lots_iface.created_by                         , rec_trans_lots_iface.creation_date
           , rec_trans_lots_iface.curl_wrinkle_fold                  , rec_trans_lots_iface.date_code                          , rec_trans_lots_iface.d_attribute1
           , rec_trans_lots_iface.d_attribute10                      , rec_trans_lots_iface.d_attribute2                       , rec_trans_lots_iface.d_attribute3
           , rec_trans_lots_iface.d_attribute4                       , rec_trans_lots_iface.d_attribute5                       , rec_trans_lots_iface.d_attribute6
           , rec_trans_lots_iface.d_attribute7                       , rec_trans_lots_iface.d_attribute8                       , rec_trans_lots_iface.d_attribute9
           , rec_trans_lots_iface.description                        , rec_trans_lots_iface.error_code                         , rec_trans_lots_iface.expiration_action_code
           , rec_trans_lots_iface.expiration_action_date             , rec_trans_lots_iface.grade_code                         , rec_trans_lots_iface.hold_date
           , rec_trans_lots_iface.item_size                          , rec_trans_lots_iface.last_update_date                   , rec_trans_lots_iface.last_updated_by
           , rec_trans_lots_iface.last_update_login                  , rec_trans_lots_iface.length                             , rec_trans_lots_iface.length_uom
           , rec_trans_lots_iface.lot_attribute_category             , rec_trans_lots_iface.lot_expiration_date                , rec_trans_lots_iface.lot_number
           , rec_trans_lots_iface.maturity_date                      , rec_trans_lots_iface.n_attribute1                       , rec_trans_lots_iface.n_attribute10
           , rec_trans_lots_iface.n_attribute2                       , rec_trans_lots_iface.n_attribute3                       , rec_trans_lots_iface.n_attribute4
           , rec_trans_lots_iface.n_attribute5                       , rec_trans_lots_iface.n_attribute6                       , rec_trans_lots_iface.n_attribute7
           , rec_trans_lots_iface.n_attribute8                       , rec_trans_lots_iface.n_attribute9                       , rec_trans_lots_iface.origination_date
           , rec_trans_lots_iface.origination_type                   , rec_trans_lots_iface.parent_item_id                     , rec_trans_lots_iface.parent_lot_number
           , rec_trans_lots_iface.parent_object_id                   , rec_trans_lots_iface.parent_object_id2                  , rec_trans_lots_iface.parent_object_number
           , rec_trans_lots_iface.parent_object_number2              , rec_trans_lots_iface.parent_object_type                 , rec_trans_lots_iface.parent_object_type2
           , rec_trans_lots_iface.place_of_origin                    , rec_trans_lots_iface.primary_quantity                   , rec_trans_lots_iface.process_flag
           , rec_trans_lots_iface.product_code                       , rec_trans_lots_iface.product_transaction_id             , rec_trans_lots_iface.program_application_id
           , rec_trans_lots_iface.program_id                         , rec_trans_lots_iface.program_update_date                , rec_trans_lots_iface.reason_code
           , rec_trans_lots_iface.reason_id                          , rec_trans_lots_iface.recycled_content                   , rec_trans_lots_iface.request_id
           , rec_trans_lots_iface.retest_date                        , rec_trans_lots_iface.secondary_transaction_quantity     , rec_trans_lots_iface.serial_transaction_temp_id
           , rec_trans_lots_iface.source_code                        , rec_trans_lots_iface.source_line_id                     , rec_trans_lots_iface.status_id
           , rec_trans_lots_iface.sublot_num                         , rec_trans_lots_iface.supplier_lot_number                , rec_trans_lots_iface.territory_code
           , rec_trans_lots_iface.thickness                          , rec_trans_lots_iface.thickness_uom                      , rec_trans_lots_iface.transaction_interface_id
           , rec_trans_lots_iface.transaction_quantity               , rec_trans_lots_iface.vendor_id                          , rec_trans_lots_iface.vendor_name
           , rec_trans_lots_iface.volume                             , rec_trans_lots_iface.volume_uom                         , rec_trans_lots_iface.width
           , rec_trans_lots_iface.width_uom
           ) ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_msg_retorno := 'INSERT_TRANS_LOTS_IFACE_P: '||SQLERRM ;
    END ;
    --
    msg_retorno := l_msg_retorno ;
    --
  END INSERT_TRANS_LOTS_IFACE_P ;
  --
  PROCEDURE INSERT_SERIAL_NUM_IFACE_P (rec_serial_num_iface IN mtl_serial_numbers_interface%ROWTYPE, msg_retorno OUT NOCOPY VARCHAR2) IS
  l_msg_retorno  VARCHAR2(1000) := null;
  BEGIN
    --
    BEGIN
      --
      INSERT INTO mtl_serial_numbers_interface
           ( attribute_category                                      , attribute1                                              , attribute10
           , attribute11                                             , attribute12                                             , attribute13
           , attribute14                                             , attribute15                                             , attribute2
           , attribute3                                              , attribute4                                              , attribute5
           , attribute6                                              , attribute7                                              , attribute8
           , attribute9                                              , c_attribute1                                            , c_attribute10
           , c_attribute11                                           , c_attribute12                                           , c_attribute13
           , c_attribute14                                           , c_attribute15                                           , c_attribute16
           , c_attribute17                                           , c_attribute18                                           , c_attribute19
           , c_attribute2                                            , c_attribute20                                           , c_attribute3
           , c_attribute4                                            , c_attribute5                                            , c_attribute6
           , c_attribute7                                            , c_attribute8                                            , c_attribute9
           , created_by                                              , creation_date                                           , cycles_since_mark
           , cycles_since_new                                        , cycles_since_overhaul                                   , cycles_since_repair
           , cycles_since_visit                                      , d_attribute1                                            , d_attribute10
           , d_attribute2                                                                                                      , d_attribute3
           , d_attribute4                                            , d_attribute5                                            , d_attribute6
           , d_attribute7                                            , d_attribute8                                            , d_attribute9
           , error_code                                              , fm_serial_number                                        , last_update_date
           , last_updated_by                                         , last_update_login                                       , n_attribute1
           , n_attribute10                                           , n_attribute2                                            , n_attribute3
           , n_attribute4                                            , n_attribute5                                            , n_attribute6
           , n_attribute7                                            , n_attribute8                                            , n_attribute9
           , number_of_repairs                                       , origination_date                                        , parent_item_id
           , parent_object_id                                        , parent_object_id2                                       , parent_object_number
           , parent_object_number2                                   , parent_object_type                                      , parent_object_type2
           , parent_serial_number                                    , process_flag                                            , product_code
           , product_transaction_id                                  , program_application_id                                  , program_id
           , program_update_date                                     , request_id                                              , serial_attribute_category
           , source_code                                             , source_line_id                                          , status_id
           , status_name                                             , territory_code                                          , time_since_mark
           , time_since_new                                          , time_since_overhaul                                     , time_since_repair
           , time_since_visit                                        , to_serial_number                                        , transaction_interface_id
           , vendor_lot_number                                       , vendor_serial_number
           ) VALUES
           ( rec_serial_num_iface.attribute_category                 , rec_serial_num_iface.attribute1                         , rec_serial_num_iface.attribute10
           , rec_serial_num_iface.attribute11                        , rec_serial_num_iface.attribute12                        , rec_serial_num_iface.attribute13
           , rec_serial_num_iface.attribute14                        , rec_serial_num_iface.attribute15                        , rec_serial_num_iface.attribute2
           , rec_serial_num_iface.attribute3                         , rec_serial_num_iface.attribute4                         , rec_serial_num_iface.attribute5
           , rec_serial_num_iface.attribute6                         , rec_serial_num_iface.attribute7                         , rec_serial_num_iface.attribute8
           , rec_serial_num_iface.attribute9                         , rec_serial_num_iface.c_attribute1                       , rec_serial_num_iface.c_attribute10
           , rec_serial_num_iface.c_attribute11                      , rec_serial_num_iface.c_attribute12                      , rec_serial_num_iface.c_attribute13
           , rec_serial_num_iface.c_attribute14                      , rec_serial_num_iface.c_attribute15                      , rec_serial_num_iface.c_attribute16
           , rec_serial_num_iface.c_attribute17                      , rec_serial_num_iface.c_attribute18                      , rec_serial_num_iface.c_attribute19
           , rec_serial_num_iface.c_attribute2                       , rec_serial_num_iface.c_attribute20                      , rec_serial_num_iface.c_attribute3
           , rec_serial_num_iface.c_attribute4                       , rec_serial_num_iface.c_attribute5                       , rec_serial_num_iface.c_attribute6
           , rec_serial_num_iface.c_attribute7                       , rec_serial_num_iface.c_attribute8                       , rec_serial_num_iface.c_attribute9
           , rec_serial_num_iface.created_by                         , rec_serial_num_iface.creation_date                      , rec_serial_num_iface.cycles_since_mark
           , rec_serial_num_iface.cycles_since_new                   , rec_serial_num_iface.cycles_since_overhaul              , rec_serial_num_iface.cycles_since_repair
           , rec_serial_num_iface.cycles_since_visit                 , rec_serial_num_iface.d_attribute1                       , rec_serial_num_iface.d_attribute10
           , rec_serial_num_iface.d_attribute2                                                                                 , rec_serial_num_iface.d_attribute3
           , rec_serial_num_iface.d_attribute4                       , rec_serial_num_iface.d_attribute5                       , rec_serial_num_iface.d_attribute6
           , rec_serial_num_iface.d_attribute7                       , rec_serial_num_iface.d_attribute8                       , rec_serial_num_iface.d_attribute9
           , rec_serial_num_iface.error_code                         , rec_serial_num_iface.fm_serial_number                   , rec_serial_num_iface.last_update_date
           , rec_serial_num_iface.last_updated_by                    , rec_serial_num_iface.last_update_login                  , rec_serial_num_iface.n_attribute1
           , rec_serial_num_iface.n_attribute10                      , rec_serial_num_iface.n_attribute2                       , rec_serial_num_iface.n_attribute3
           , rec_serial_num_iface.n_attribute4                       , rec_serial_num_iface.n_attribute5                       , rec_serial_num_iface.n_attribute6
           , rec_serial_num_iface.n_attribute7                       , rec_serial_num_iface.n_attribute8                       , rec_serial_num_iface.n_attribute9
           , rec_serial_num_iface.number_of_repairs                  , rec_serial_num_iface.origination_date                   , rec_serial_num_iface.parent_item_id
           , rec_serial_num_iface.parent_object_id                   , rec_serial_num_iface.parent_object_id2                  , rec_serial_num_iface.parent_object_number
           , rec_serial_num_iface.parent_object_number2              , rec_serial_num_iface.parent_object_type                 , rec_serial_num_iface.parent_object_type2
           , rec_serial_num_iface.parent_serial_number               , rec_serial_num_iface.process_flag                       , rec_serial_num_iface.product_code
           , rec_serial_num_iface.product_transaction_id             , rec_serial_num_iface.program_application_id             , rec_serial_num_iface.program_id
           , rec_serial_num_iface.program_update_date                , rec_serial_num_iface.request_id                         , rec_serial_num_iface.serial_attribute_category
           , rec_serial_num_iface.source_code                        , rec_serial_num_iface.source_line_id                     , rec_serial_num_iface.status_id
           , rec_serial_num_iface.status_name                        , rec_serial_num_iface.territory_code                     , rec_serial_num_iface.time_since_mark
           , rec_serial_num_iface.time_since_new                     , rec_serial_num_iface.time_since_overhaul                , rec_serial_num_iface.time_since_repair
           , rec_serial_num_iface.time_since_visit                   , rec_serial_num_iface.to_serial_number                   , rec_serial_num_iface.transaction_interface_id
           , rec_serial_num_iface.vendor_lot_number                  , rec_serial_num_iface.vendor_serial_number
           ) ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_msg_retorno := 'INSERT_SERIAL_NUM_IFACE_P: '||SQLERRM ;
    END ;
    --
    msg_retorno := l_msg_retorno ;
    --
  END INSERT_SERIAL_NUM_IFACE_P ;
  --
  procedure show_log(p_vmessage in varchar2) is
  begin
    dbms_output.put_line(p_vmessage);
  end show_log;
  --
  PROCEDURE insert_log_p ( p_org_id                     IN cll_f513_tpa_control_log.org_id                     %TYPE
                         , p_customer_number            IN cll_f513_tpa_control_log.customer_number            %TYPE
                         , p_customer_name              IN cll_f513_tpa_control_log.customer_name              %TYPE
                         , p_trx_number                 IN cll_f513_tpa_control_log.trx_number                 %TYPE
                         , p_line_number                IN cll_f513_tpa_control_log.line_number                %TYPE
                         , p_lot_number                 IN cll_f513_tpa_control_log.lot_number                 %TYPE
                         , p_serial_number              IN cll_f513_tpa_control_log.serial_number              %TYPE
                         , p_process_status             IN cll_f513_tpa_control_log.process_status             %TYPE
                         , p_process_description        IN cll_f513_tpa_control_log.process_description        %TYPE
                         , p_segment1                   IN cll_f513_tpa_control_log.segment1                   %TYPE
                         , p_source_subinventory        IN cll_f513_tpa_control_log.source_subinventory        %TYPE
                         , p_source_locator_id          IN mtl_item_locations.inventory_location_id            %TYPE
                         , p_operation_id               IN cll_f513_tpa_control_log.operation_id               %TYPE
                         , p_invoice_number             IN cll_f513_tpa_control_log.invoice_number             %TYPE
                         , p_item_number                IN cll_f513_tpa_control_log.item_number                %TYPE
                         , p_tpa_receipt_control_id     IN cll_f513_tpa_control_log.tpa_receipt_control_id     %TYPE
                         , p_receipt_transaction_id     IN cll_f513_tpa_control_log.receipt_transaction_id     %TYPE
                         , p_tpa_devolutions_control_id IN cll_f513_tpa_control_log.tpa_devolutions_control_id %TYPE
                         , p_devolution_transaction_id  IN cll_f513_tpa_control_log.devolution_transaction_id  %TYPE
                         ) IS

  l_nApplication_Id      NUMBER := FND_PROFILE.VALUE('RESP_APPL_ID') ;
  l_nConcProgram_Id      NUMBER ;
  l_vMensagem            VARCHAR2(4000) ;
  l_vLocator             VARCHAR2(120) ;
  --
  BEGIN
    --
    BEGIN
      --
      SELECT concurrent_program_id
        INTO l_nConcProgram_Id
        FROM apps.fnd_concurrent_programs
       WHERE concurrent_program_name = 'CLL_F513_TPA_DEV_PROCESS' ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_nConcProgram_Id := NULL ;
    END ;
    --
    BEGIN
      --
      SELECT        mil.segment1
          || DECODE(mil.segment2 , NULL, NULL, '.' || mil.segment2 )
          || DECODE(mil.segment3 , NULL, NULL, '.' || mil.segment3 )
          || DECODE(mil.segment4 , NULL, NULL, '.' || mil.segment4 )
          || DECODE(mil.segment5 , NULL, NULL, '.' || mil.segment5 )
          || DECODE(mil.segment6 , NULL, NULL, '.' || mil.segment6 )
          || DECODE(mil.segment7 , NULL, NULL, '.' || mil.segment7 )
          || DECODE(mil.segment8 , NULL, NULL, '.' || mil.segment8 )
          || DECODE(mil.segment9 , NULL, NULL, '.' || mil.segment9 )
          || DECODE(mil.segment10, NULL, NULL, '.' || mil.segment10)
          || DECODE(mil.segment11, NULL, NULL, '.' || mil.segment11)
          || DECODE(mil.segment12, NULL, NULL, '.' || mil.segment12)
          || DECODE(mil.segment13, NULL, NULL, '.' || mil.segment13)
          || DECODE(mil.segment14, NULL, NULL, '.' || mil.segment14)
          || DECODE(mil.segment15, NULL, NULL, '.' || mil.segment15)
          || DECODE(mil.segment16, NULL, NULL, '.' || mil.segment16)
          || DECODE(mil.segment17, NULL, NULL, '.' || mil.segment17)
          || DECODE(mil.segment18, NULL, NULL, '.' || mil.segment18)
          || DECODE(mil.segment19, NULL, NULL, '.' || mil.segment19)
          || DECODE(mil.segment20, NULL, NULL, '.' || mil.segment20) locator_code
        INTO l_vLocator
        FROM mtl_item_locations mil
       WHERE inventory_location_id = p_source_locator_id ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_vLocator := NULL ;
    END ;
    --
    -- BUG 29625111 - Start
    g_rec_tpa_control_log := g_crec_tpa_control_log ;
    --
    g_rec_tpa_control_log.tpa_control_log_id         := cll_f513_tpa_control_log_s.NEXTVAL ;
    g_rec_tpa_control_log.org_id                     := p_org_id ;
    g_rec_tpa_control_log.customer_number            := p_customer_number ;
    g_rec_tpa_control_log.customer_name              := p_customer_name ;
    g_rec_tpa_control_log.trx_number                 := p_trx_number ;
    g_rec_tpa_control_log.line_number                := p_line_number ;
    g_rec_tpa_control_log.lot_number                 := p_lot_number ;
    g_rec_tpa_control_log.serial_number              := p_serial_number ;
    g_rec_tpa_control_log.process_status             := p_process_status ;
    g_rec_tpa_control_log.process_description        := p_process_description ;
    g_rec_tpa_control_log.segment1                   := p_segment1 ;
    g_rec_tpa_control_log.source_subinventory        := p_source_subinventory ;
    g_rec_tpa_control_log.operation_id               := p_operation_id ;
    g_rec_tpa_control_log.invoice_number             := p_invoice_number ;
    g_rec_tpa_control_log.item_number                := p_item_number ;
    g_rec_tpa_control_log.tpa_receipt_control_id     := p_tpa_receipt_control_id ;
    g_rec_tpa_control_log.receipt_transaction_id     := p_receipt_transaction_id ;
    g_rec_tpa_control_log.tpa_devolutions_control_id := p_tpa_devolutions_control_id ;
    g_rec_tpa_control_log.devolution_transaction_id  := p_devolution_transaction_id ;
    g_rec_tpa_control_log.process_source             := 'CLL_F189' ;
    g_rec_tpa_control_log.created_by                 := fnd_global.user_id ;
    g_rec_tpa_control_log.creation_date              := SYSDATE ;
    g_rec_tpa_control_log.last_update_date           := SYSDATE ;
    g_rec_tpa_control_log.last_updated_by            := fnd_global.user_id ;
    g_rec_tpa_control_log.last_update_login          := fnd_global.login_id ;
    g_rec_tpa_control_log.request_id                 := fnd_global.conc_request_id ;
    g_rec_tpa_control_log.program_application_id     := l_nApplication_Id ;
    g_rec_tpa_control_log.program_id                 := l_nConcProgram_Id ;
    g_rec_tpa_control_log.program_update_date        := SYSDATE ;
    g_rec_tpa_control_log.source_locat_code          := l_vLocator ;
    g_rec_tpa_control_log.status                     := p_process_status ;
    --
    IF p_process_status <> 'UNSUCCESSFUL' THEN
        g_rec_tpa_control_log.status                 := 'DEVOLVED' ;
    END IF ;
    --
    g_msg_retorno                                    := NULL ;
    --
    INSERT_TPA_CONTROL_LOG_P ( g_rec_tpa_control_log, g_msg_retorno ) ;
    --
    IF g_msg_retorno IS NOT NULL THEN
      SHOW_LOG( g_msg_retorno ) ;
    END IF ;
    --
    -- BUG 29625111 - End
    --
  END insert_log_p ;
  --
  PROCEDURE execute_process_p ( --errbuf             OUT NOCOPY VARCHAR2,
                              -- retcode            OUT NOCOPY NUMBER,
                                p_date_from         IN VARCHAR2,
                                p_date_to           IN VARCHAR2,
                                p_org_id            IN NUMBER,
                                p_tpa_dev_ctrl_id   IN NUMBER DEFAULT NULL -- Enh 29553257
                              ) IS

  --
  l_vCustomer_Name         hz_parties.party_name                         %TYPE ;
  l_vCustomer_Number       hz_cust_accounts.account_number               %TYPE ;
  l_vDocument_Number       hz_cust_acct_sites_all.global_attribute1      %TYPE ;
  l_nProgram_Appl_Id       fnd_concurrent_programs.application_id        %TYPE ;
  l_nProgram_Id            fnd_concurrent_programs.concurrent_program_id %TYPE ;
  l_vResult_Adjust         BOOLEAN := TRUE;
  l_vErro_Insert           VARCHAR2(01) ;
  l_vStatus                VARCHAR2(12) ;
  l_vOperation_Status      VARCHAR2(20) ;
  l_vOperation_Ant         VARCHAR2(25) ;
  l_vOrganization_Ant      VARCHAR2(25) ;
  l_vMensagem              VARCHAR2(4000) ;
  l_vError_Code            VARCHAR2(4000) ;
  l_vError_Explanation     VARCHAR2(4000) ;
  l_vMsg_Receipt           VARCHAR2(4000) ;
  l_vMsg_Devolution        VARCHAR2(4000) ;
  l_nTimeout               NUMBER := NULL ;
  l_nTotal_Iface           NUMBER ;
  l_nTotal_Batch           NUMBER ;
  l_nTotal_Serial          NUMBER ;
  l_nTotal_Error           NUMBER ;
  l_nRemaining_Balance     NUMBER ;
  l_nAdjust_id             NUMBER ;
  l_nSerial_Trans_Tmp_Id   NUMBER ;
  l_dDate_From             DATE ;
  l_dDate_To               DATE ;
  --
  CURSOR c_invoices ( pc_org_id          IN NUMBER
                    , pc_date_from       IN DATE
                    , pc_date_to         IN DATE
                    , pc_tpa_dev_ctrl_id IN NUMBER -- Enh 29553257
                    )  IS
    SELECT rcta.org_id                         org_id
         , rcta.customer_trx_id                customer_trx_id
         , rctla.customer_trx_line_id          customer_trx_line_id
         , rctla.interface_line_attribute1     devolution_operation_id
         , rcta.cust_trx_type_id               cust_trx_type_id
         , rcta.trx_number                     invoice_number
         , rcta.trx_date                       invoice_date
         , jbe.occurrence_date                 sefaz_authorization_date
         , rcta.ship_to_site_use_id            site_use_id
         , rctla.interface_line_context        source
         , rctla.interface_line_attribute2     organizationid
         , rctla.interface_line_attribute3     devolution_invoice_id
         , rctla.interface_line_attribute4     devolution_invoice_line_id
         , rctla.inventory_item_id             inventory_item_id
         , ctdc.tpa_devolutions_control_id     tpa_devolutions_control_id
         , ctdc.item_uom_code                  item_uom_code
         , rctla.uom_code                      uom_code
         , ctdc.devolution_quantity            devolution_quantity
         , ctdc.subinventory                   subinventory
         , ctdc.devolution_item_number         item_number
         , ctdc.locator_id                     locator_id
         , ctdc.parent_lot_number              parent_lot_number
         , ctdc.lot_number                     lot_number
         , ctdc.expiration_date                expiration_date
         , ctdc.serial_number                  serial_number
         , ctdc.devolution_account_id          devolution_account_id
         , ctdc.symbolic_devolution_flag       symbolic_devolution_flag
         , ctrc.tpa_receipts_control_id        tpa_receipts_control_id
         , ctrc.receipt_transaction_id         receipt_transaction_id
         , ctrc.remaining_balance              remaining_balance
         , rctla.line_number                   line_number
         , rctla.description                   description
         , rctla.quantity_invoiced             quantity_invoiced
         , rctla.warehouse_id                  organization_id
         , ccn.stockable_flag                  stockable_flag
         , msi.segment1                        segment1
         , msi.lot_control_code                lot_control_code
         , msi.serial_number_control_code      serial_number_control_code
         , ccn.devolution_transaction_type_id  devolution_transaction_type_id
         --Enh 28431410 - Start
         --, mtt.transaction_action_id           transaction_action_id
         , DECODE(ccn.devolution_transaction_type_id
                 ,NULL
                 ,NULL
                 ,mtt.transaction_action_id
                 )
         --Enh 28431410 - End
         , ood.organization_code               organization_code
         -- Enh 28431410 - Start
         -- lote
         , NULL                                 lot_attribute_category
         , NULL                                 lot_c_attribute1
         , NULL                                 lot_c_attribute2
         , NULL                                 lot_c_attribute3
         , NULL                                 lot_c_attribute4
         , NULL                                 lot_c_attribute5
         , NULL                                 lot_c_attribute6
         , NULL                                 lot_c_attribute7
         , NULL                                 lot_c_attribute8
         , NULL                                 lot_c_attribute9
         , NULL                                 lot_c_attribute10
         , NULL                                 lot_c_attribute11
         , NULL                                 lot_c_attribute12
         , NULL                                 lot_c_attribute13
         , NULL                                 lot_c_attribute14
         , NULL                                 lot_c_attribute15
         , NULL                                 lot_c_attribute16
         , NULL                                 lot_c_attribute17
         , NULL                                 lot_c_attribute18
         , NULL                                 lot_c_attribute19
         , NULL                                 lot_c_attribute20
         , NULL                                 lot_d_attribute1
         , NULL                                 lot_d_attribute2
         , NULL                                 lot_d_attribute3
         , NULL                                 lot_d_attribute4
         , NULL                                 lot_d_attribute5
         , NULL                                 lot_d_attribute6
         , NULL                                 lot_d_attribute7
         , NULL                                 lot_d_attribute8
         , NULL                                 lot_d_attribute9
         , NULL                                 lot_d_attribute10
         , NULL                                 lot_n_attribute1
         , NULL                                 lot_n_attribute2
         , NULL                                 lot_n_attribute3
         , NULL                                 lot_n_attribute4
         , NULL                                 lot_n_attribute5
         , NULL                                 lot_n_attribute6
         , NULL                                 lot_n_attribute7
         , NULL                                 lot_n_attribute8
         , NULL                                 lot_n_attribute9
         , NULL                                 lot_n_attribute10
         --
         , NULL                                 attribute_category_lot
         , NULL                                 attribute1_lot
         , NULL                                 attribute2_lot
         , NULL                                 attribute3_lot
         , NULL                                 attribute4_lot
         , NULL                                 attribute5_lot
         , NULL                                 attribute6_lot
         , NULL                                 attribute7_lot
         , NULL                                 attribute8_lot
         , NULL                                 attribute9_lot
         , NULL                                 attribute10_lot
         , NULL                                 attribute11_lot
         , NULL                                 attribute12_lot
         , NULL                                 attribute13_lot
         , NULL                                 attribute14_lot
         , NULL                                 attribute15_lot
         -- serie
         , NULL                                serial_attribute_category
         , NULL                                serial_c_attribute1
         , NULL                                serial_c_attribute2
         , NULL                                serial_c_attribute3
         , NULL                                serial_c_attribute4
         , NULL                                serial_c_attribute5
         , NULL                                serial_c_attribute6
         , NULL                                serial_c_attribute7
         , NULL                                serial_c_attribute8
         , NULL                                serial_c_attribute9
         , NULL                                serial_c_attribute10
         , NULL                                serial_c_attribute11
         , NULL                                serial_c_attribute12
         , NULL                                serial_c_attribute13
         , NULL                                serial_c_attribute14
         , NULL                                serial_c_attribute15
         , NULL                                serial_c_attribute16
         , NULL                                serial_c_attribute17
         , NULL                                serial_c_attribute18
         , NULL                                serial_c_attribute19
         , NULL                                serial_c_attribute20
         , NULL                                serial_d_attribute1
         , NULL                                serial_d_attribute2
         , NULL                                serial_d_attribute3
         , NULL                                serial_d_attribute4
         , NULL                                serial_d_attribute5
         , NULL                                serial_d_attribute6
         , NULL                                serial_d_attribute7
         , NULL                                serial_d_attribute8
         , NULL                                serial_d_attribute9
         , NULL                                serial_d_attribute10
         , NULL                                serial_n_attribute1
         , NULL                                serial_n_attribute2
         , NULL                                serial_n_attribute3
         , NULL                                serial_n_attribute4
         , NULL                                serial_n_attribute5
         , NULL                                serial_n_attribute6
         , NULL                                serial_n_attribute7
         , NULL                                serial_n_attribute8
         , NULL                                serial_n_attribute9
         , NULL                                serial_n_attribute10
         --
         , NULL                                attribute_category_serie
         , NULL                                attribute1_serie
         , NULL                                attribute2_serie
         , NULL                                attribute3_serie
         , NULL                                attribute4_serie
         , NULL                                attribute5_serie
         , NULL                                attribute6_serie
         , NULL                                attribute7_serie
         , NULL                                attribute8_serie
         , NULL                                attribute9_serie
         , NULL                                attribute10_serie
         , NULL                                attribute11_serie
         , NULL                                attribute12_serie
         , NULL                                attribute13_serie
         , NULL                                attribute14_serie
         , NULL                                attribute15_serie
         -- Enh 28431410 - End
      FROM apps.jl_br_customer_trx_exts             jbcte
         , apps.jl_br_eilog                         jbe
         , apps.ra_customer_trx_all                 rcta
         , apps.ra_customer_trx_lines_all           rctla
         , apps.cll_f513_cust_network               ccn
         , apps.cll_f513_tpa_receipts_control       ctrc
         , apps.mtl_system_items_b                  msi
         , apps.cll_f513_tpa_devolutions_ctrl       ctdc
         , apps.mtl_transaction_types               mtt
         , apps.org_organization_definitions        ood
       WHERE rcta.org_id                       = pc_org_id
         AND rcta.status_trx                   = 'OP'
         AND NVL(ccn.inactive_flag, 'N')       = 'N'
         AND rcta.org_id                       = ccn.operating_unit
         AND ctdc.organization_id              = msi.organization_id
         AND ctdc.inventory_item_id            = msi.inventory_item_id
         AND mtt.transaction_type_id           = ccn.devolution_transaction_type_id
         AND ood.organization_id               = ctdc.organization_id
         AND ccn.stockable_flag                = 'N'
         AND ccn.source_type                   = 'RI'
         AND ( ctrc.cfo_id                     = ccn.in_state_cfop_id
          OR ctrc.cfo_id                       = ccn.out_state_cfop_id )
         AND ctrc.utilization_id               = ccn.utilization_id
         AND ctdc.tpa_receipts_control_id      = ctrc.tpa_receipts_control_id
         AND rctla.interface_line_attribute4   = ctdc.devolution_invoice_line_id
         AND rctla.interface_line_attribute3   = ctdc.devolution_invoice_id
         AND rctla.interface_line_attribute2   = ctdc.organization_id
         AND rctla.interface_line_attribute1   = ctdc.devolution_operation_id
         AND rctla.interface_line_context      = 'CLL F189 INTEGRATED RCV'
         AND rctla.line_type                   = 'LINE'
         AND rcta.customer_trx_id              = rctla.customer_trx_id
         AND jbcte.electronic_inv_status       = jbe.electronic_inv_status
         AND jbcte.customer_trx_id             = jbe.customer_trx_id
         --
         -- Bug 32581652 - begin
         AND jbe.occurrence_id IN (SELECT MIN(jbe2.occurrence_id)
                                     FROM apps.jl_br_eilog                   jbe2
                                    WHERE jbe2.customer_trx_id       = jbcte.customer_trx_id
                                      AND jbe2.electronic_inv_status = '2'
                                )
         -- Bug 32581652 - end
         --
         AND jbcte.customer_trx_id             = rcta.customer_trx_id
         AND jbcte.electronic_inv_status       = '2'
         AND NVL(ctdc.devolution_status, 'x') <> 'COMPLETE'
         AND TRUNC(jbe.occurrence_date)        BETWEEN TRUNC(pc_date_from)
                                                   AND TRUNC(pc_date_to)
         AND ctdc.tpa_devolutions_control_id   = NVL(pc_tpa_dev_ctrl_id, ctdc.tpa_devolutions_control_id) -- Enh 29553257
    --
    UNION
    SELECT rcta.org_id                         org_id
         , rcta.customer_trx_id                customer_trx_id
         , rctla.customer_trx_line_id          customer_trx_line_id
         , rctla.interface_line_attribute1     devolution_operation_id
         , rcta.cust_trx_type_id               cust_trx_type_id
         , rcta.trx_number                     invoice_number
         , rcta.trx_date                       invoice_date
         , jbe.occurrence_date                 sefaz_authorization_date
         , rcta.ship_to_site_use_id            site_use_id
         , rctla.interface_line_context        source
         , rctla.interface_line_attribute2     organizationid
         , rctla.interface_line_attribute3     devolution_invoice_id
         , rctla.interface_line_attribute4     devolution_invoice_line_id
         , rctla.inventory_item_id             inventory_item_id
         , ctdc.tpa_devolutions_control_id     tpa_devolutions_control_id
         , ctdc.item_uom_code                  item_uom_code
         , rctla.uom_code                      uom_code
         , ctdc.devolution_quantity            devolution_quantity
         , ctdc.subinventory                   subinventory
         , ctdc.devolution_item_number         item_number
         , ctdc.locator_id                     locator_id
         , ctdc.parent_lot_number              parent_lot_number
         , ctdc.lot_number                     lot_number
         , ctdc.expiration_date                expiration_date
         , ctdc.serial_number                  serial_number
         , ctdc.devolution_account_id          devolution_account_id
         , ctdc.symbolic_devolution_flag       symbolic_devolution_flag
         , ctrc.tpa_receipts_control_id        tpa_receipts_control_id
         , ctrc.receipt_transaction_id         receipt_transaction_id
         , ctrc.remaining_balance              remaining_balance
         , rctla.line_number                   line_number
         , rctla.description                   description
         , rctla.quantity_invoiced             quantity_invoiced
         , rctla.warehouse_id                  organization_id
         , ccn.stockable_flag                  stockable_flag
         , msi.segment1                        segment1
         , msi.lot_control_code                lot_control_code
         , msi.serial_number_control_code      serial_number_control_code
         , ccn.devolution_transaction_type_id  devolution_transaction_type_id
         --Enh 28431410 - Start
         --, mtt.transaction_action_id           transaction_action_id
         , DECODE(ccn.devolution_transaction_type_id
                 ,NULL
                 ,NULL
                 ,mtt.transaction_action_id
                 )
         --Enh 28431410 - End
         , ood.organization_code               organization_code
         -- Enh 28431410 - Start
         -- lote
         , mln.lot_attribute_category
         , mln.c_attribute1                    lot_c_attribute1
         , mln.c_attribute2                    lot_c_attribute2
         , mln.c_attribute3                    lot_c_attribute3
         , mln.c_attribute4                    lot_c_attribute4
         , mln.c_attribute5                    lot_c_attribute5
         , mln.c_attribute6                    lot_c_attribute6
         , mln.c_attribute7                    lot_c_attribute7
         , mln.c_attribute8                    lot_c_attribute8
         , mln.c_attribute9                    lot_c_attribute9
         , mln.c_attribute10                   lot_c_attribute10
         , mln.c_attribute11                   lot_c_attribute11
         , mln.c_attribute12                   lot_c_attribute12
         , mln.c_attribute13                   lot_c_attribute13
         , mln.c_attribute14                   lot_c_attribute14
         , mln.c_attribute15                   lot_c_attribute15
         , mln.c_attribute16                   lot_c_attribute16
         , mln.c_attribute17                   lot_c_attribute17
         , mln.c_attribute18                   lot_c_attribute18
         , mln.c_attribute19                   lot_c_attribute19
         , mln.c_attribute20                   lot_c_attribute20
         , mln.d_attribute1                    lot_d_attribute1
         , mln.d_attribute2                    lot_d_attribute2
         , mln.d_attribute3                    lot_d_attribute3
         , mln.d_attribute4                    lot_d_attribute4
         , mln.d_attribute5                    lot_d_attribute5
         , mln.d_attribute6                    lot_d_attribute6
         , mln.d_attribute7                    lot_d_attribute7
         , mln.d_attribute8                    lot_d_attribute8
         , mln.d_attribute9                    lot_d_attribute9
         , mln.d_attribute10                   lot_d_attribute10
         , mln.n_attribute1                    lot_n_attribute1
         , mln.n_attribute2                    lot_n_attribute2
         , mln.n_attribute3                    lot_n_attribute3
         , mln.n_attribute4                    lot_n_attribute4
         , mln.n_attribute5                    lot_n_attribute5
         , mln.n_attribute6                    lot_n_attribute6
         , mln.n_attribute7                    lot_n_attribute7
         , mln.n_attribute8                    lot_n_attribute8
         , mln.n_attribute9                    lot_n_attribute9
         , mln.n_attribute10                   lot_n_attribute10
         --
         , mln.attribute_category              attribute_category_lot
         , mln.attribute1                      attribute1_lot
         , mln.attribute2                      attribute2_lot
         , mln.attribute3                      attribute3_lot
         , mln.attribute4                      attribute4_lot
         , mln.attribute5                      attribute5_lot
         , mln.attribute6                      attribute6_lot
         , mln.attribute7                      attribute7_lot
         , mln.attribute8                      attribute8_lot
         , mln.attribute9                      attribute9_lot
         , mln.attribute10                     attribute10_lot
         , mln.attribute11                     attribute11_lot
         , mln.attribute12                     attribute12_lot
         , mln.attribute13                     attribute13_lot
         , mln.attribute14                     attribute14_lot
         , mln.attribute15                     attribute15_lot
         -- serie
         , msn.serial_attribute_category
         , msn.c_attribute1                    serial_c_attribute1
         , msn.c_attribute2                    serial_c_attribute2
         , msn.c_attribute3                    serial_c_attribute3
         , msn.c_attribute4                    serial_c_attribute4
         , msn.c_attribute5                    serial_c_attribute5
         , msn.c_attribute6                    serial_c_attribute6
         , msn.c_attribute7                    serial_c_attribute7
         , msn.c_attribute8                    serial_c_attribute8
         , msn.c_attribute9                    serial_c_attribute9
         , msn.c_attribute10                   serial_c_attribute10
         , msn.c_attribute11                   serial_c_attribute11
         , msn.c_attribute12                   serial_c_attribute12
         , msn.c_attribute13                   serial_c_attribute13
         , msn.c_attribute14                   serial_c_attribute14
         , msn.c_attribute15                   serial_c_attribute15
         , msn.c_attribute16                   serial_c_attribute16
         , msn.c_attribute17                   serial_c_attribute17
         , msn.c_attribute18                   serial_c_attribute18
         , msn.c_attribute19                   serial_c_attribute19
         , msn.c_attribute20                   serial_c_attribute20
         , msn.d_attribute1                    serial_d_attribute1
         , msn.d_attribute2                    serial_d_attribute2
         , msn.d_attribute3                    serial_d_attribute3
         , msn.d_attribute4                    serial_d_attribute4
         , msn.d_attribute5                    serial_d_attribute5
         , msn.d_attribute6                    serial_d_attribute6
         , msn.d_attribute7                    serial_d_attribute7
         , msn.d_attribute8                    serial_d_attribute8
         , msn.d_attribute9                    serial_d_attribute9
         , msn.d_attribute10                   serial_d_attribute10
         , msn.n_attribute1                    serial_n_attribute1
         , msn.n_attribute2                    serial_n_attribute2
         , msn.n_attribute3                    serial_n_attribute3
         , msn.n_attribute4                    serial_n_attribute4
         , msn.n_attribute5                    serial_n_attribute5
         , msn.n_attribute6                    serial_n_attribute6
         , msn.n_attribute7                    serial_n_attribute7
         , msn.n_attribute8                    serial_n_attribute8
         , msn.n_attribute9                    serial_n_attribute9
         , msn.n_attribute10                   serial_n_attribute10
         --
         , msn.attribute_category              attribute_category_serie
         , msn.attribute1                      attribute1_serie
         , msn.attribute2                      attribute2_serie
         , msn.attribute3                      attribute3_serie
         , msn.attribute4                      attribute4_serie
         , msn.attribute5                      attribute5_serie
         , msn.attribute6                      attribute6_serie
         , msn.attribute7                      attribute7_serie
         , msn.attribute8                      attribute8_serie
         , msn.attribute9                      attribute9_serie
         , msn.attribute10                     attribute10_serie
         , msn.attribute11                     attribute11_serie
         , msn.attribute12                     attribute12_serie
         , msn.attribute13                     attribute13_serie
         , msn.attribute14                     attribute14_serie
         , msn.attribute15                     attribute15_serie
         -- Enh 28431410 - End
      FROM apps.jl_br_customer_trx_exts             jbcte
         , apps.jl_br_eilog                         jbe
         , apps.ra_customer_trx_all                 rcta
         , apps.ra_customer_trx_lines_all           rctla
         , apps.cll_f513_cust_network               ccn
         , apps.cll_f513_tpa_receipts_control       ctrc
         , apps.mtl_system_items_b                  msi
         , apps.cll_f513_tpa_devolutions_ctrl       ctdc
         , apps.mtl_transaction_types               mtt
         , apps.org_organization_definitions        ood
         , apps.mtl_lot_numbers                     mln -- Enh 28431410
         , apps.mtl_serial_numbers                  msn -- Enh 28431410
       WHERE rcta.org_id                       = pc_org_id
         AND rcta.status_trx                   = 'OP'
         AND NVL(ccn.inactive_flag, 'N')       = 'N'
         AND rcta.org_id                       = ccn.operating_unit
         AND ctdc.organization_id              = msi.organization_id
         AND ctdc.inventory_item_id            = msi.inventory_item_id
         AND mtt.transaction_type_id           = ccn.devolution_transaction_type_id
         AND ood.organization_id               = ctdc.organization_id
         AND ccn.source_type                   = 'RI'
         AND
           ( ctrc.cfo_id                       = ccn.in_state_cfop_id
          OR ctrc.cfo_id                       = ccn.out_state_cfop_id )
         AND ctrc.utilization_id               = ccn.utilization_id
         AND ctdc.tpa_receipts_control_id      = ctrc.tpa_receipts_control_id
         AND rctla.interface_line_attribute4   = ctdc.devolution_invoice_line_id
         AND rctla.interface_line_attribute3   = ctdc.devolution_invoice_id
         AND rctla.interface_line_attribute2   = ctdc.organization_id
         AND rctla.interface_line_attribute1   = ctdc.devolution_operation_id
         AND rctla.interface_line_context      = 'CLL F189 INTEGRATED RCV'
         AND rctla.line_type                   = 'LINE'
         AND rcta.customer_trx_id              = rctla.customer_trx_id
         AND jbcte.electronic_inv_status       = jbe.electronic_inv_status
         AND jbcte.customer_trx_id             = jbe.customer_trx_id
         --
         -- Bug 32581652 - begin
         AND jbe.occurrence_id IN (SELECT MIN(jbe2.occurrence_id)
                                     FROM apps.jl_br_eilog                   jbe2
                                    WHERE jbe2.customer_trx_id       = jbcte.customer_trx_id
                                      AND jbe2.electronic_inv_status = '2'
                                )
         -- Bug 32581652 - end
         --
         AND jbcte.customer_trx_id             = rcta.customer_trx_id
         AND jbcte.electronic_inv_status       = '2'
         AND NVL(ctdc.devolution_status, 'x') <> 'COMPLETE'
         AND TRUNC(jbe.occurrence_date)        BETWEEN TRUNC(pc_date_from)
                                                   AND TRUNC(pc_date_to)
         -- Enh 28431410 - Start
         AND ctrc.organization_id              = mln.organization_id   (+)
         AND ctrc.inventory_item_id            = mln.inventory_item_id (+)
         AND NVL(ctrc.lot_number, 'x')         = mln.lot_number        (+)
         AND ctrc.inventory_item_id            = msn.inventory_item_id (+)
         AND NVL(ctrc.serial_number, 'x')      = msn.serial_number     (+)
         -- Enh 28431410 - End
         AND ctdc.tpa_devolutions_control_id   = NVL(pc_tpa_dev_ctrl_id, ctdc.tpa_devolutions_control_id) -- Enh 29553257
       ORDER BY 4 ;

  CURSOR c_supplier ( pc_org_id      IN NUMBER
                    , pc_site_use_id IN NUMBER ) IS
    SELECT hp.party_name                                        customer_name
         , hca.account_number                                       customer_number
         , DECODE(SUBSTR(hcasa.global_attribute2, 1, 1),   '2',
                  SUBSTR(hcasa.global_attribute3, 2, 2) || '.' ||
                  SUBSTR(hcasa.global_attribute3, 4, 3) || '.' ||
                  SUBSTR(hcasa.global_attribute3, 7, 3) || '/' ||
                         hcasa.global_attribute4        || '-' ||
                         hcasa.global_attribute5,
                  SUBSTR(hcasa.global_attribute2, 1, 1)  , '1',
                  SUBSTR(hcasa.global_attribute3, 1, 3) || '.' ||
                  SUBSTR(hcasa.global_attribute3, 4, 3) || '.' ||
                  SUBSTR(hcasa.global_attribute3, 7, 3) || '-' ||
                         hcasa.global_attribute5)                   document_number
      FROM apps.hz_cust_accounts          hca
         , apps.hz_cust_site_uses_all     hcsua
         , apps.hz_cust_acct_sites_all    hcasa
         , apps.hz_party_sites            hps
         , apps.hz_parties                hp
         , apps.hz_locations              hl
         , apps.hr_all_organization_units haou
     WHERE hcsua.org_id            = pc_org_id
       AND hcsua.org_id            = haou.organization_id
       AND hcsua.org_id            = hcasa.org_id
       AND hps.location_id         = hl.location_id
       AND hps.party_id            = hp.party_id
       AND
         ( hps.end_date_active     IS NULL
        OR hps.end_date_active     >= TRUNC(SYSDATE) )
       AND
         ( hps.start_date_active   IS NULL
        OR hps.start_date_active   <= TRUNC(SYSDATE) )
       AND hcasa.party_site_id     = hps.party_site_id
       AND hcasa.cust_account_id   = hca.cust_account_id
       AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
       AND hcsua.site_use_code     = 'SHIP_TO'
       AND hcsua.site_use_id       = pc_site_use_id ;

  CURSOR c_balance ( pc_tpa_ctrl_id IN NUMBER ) IS
    SELECT remaining_balance
      FROM apps.cll_f513_tpa_receipts_control
     WHERE tpa_receipts_control_id = pc_tpa_ctrl_id ;

  BEGIN
    --
    l_dDate_From     := TO_DATE(p_date_from, 'YYYY-MM-DD HH24:MI:SS') ;
    l_dDate_To       := TO_DATE(p_date_to  , 'YYYY-MM-DD HH24:MI:SS') ;
    l_vOperation_Ant := NULL ;
    --
    show_log ('Starting process .. : '||TO_CHAR(SYSDATE, 'DD-MM-RRRR HH24:MI:SS')) ;
    show_log (' ') ;
    show_log ('    Parameters .... : p_date_from : '||l_dDate_From) ;
    show_log ('                      p_date_to   : '||l_dDate_To) ;
    show_log ('                      p_org_id    : '||p_org_id) ;
    show_log (' ') ;
    --
    BEGIN
      --
      SELECT application_id
           , concurrent_program_id
        INTO l_nProgram_Appl_Id
           , l_nProgram_Id
        FROM apps.fnd_concurrent_programs
       WHERE concurrent_program_name = 'CLL_F513_TPA_DEV_PROCESS' ;
      --
    EXCEPTION
      WHEN OTHERS THEN
        l_nProgram_Appl_Id := NULL ;
        l_nProgram_Id      := NULL ;
    END ;
    --
    FOR r_invoices IN c_invoices ( pc_org_id          => p_org_id
                                 , pc_date_from       => l_dDate_From
                                 , pc_date_to         => l_dDate_To
                                 , pc_tpa_dev_ctrl_id => p_tpa_dev_ctrl_id -- Enh 29553257
                                 ) LOOP
      --
      l_vOperation_Ant    := NVL(l_vOperation_Ant   , r_invoices.devolution_operation_id) ;
      l_vOrganization_Ant := NVL(l_vOrganization_Ant, r_invoices.organization_code) ;
      --
      OPEN  c_supplier ( pc_org_id => r_invoices.org_id, pc_site_use_id => r_invoices.site_use_id ) ;
      FETCH c_supplier INTO l_vCustomer_Name, l_vCustomer_Number, l_vDocument_Number ;
      CLOSE c_supplier ;
      --
      OPEN  c_balance ( pc_tpa_ctrl_id => r_invoices.tpa_receipts_control_id );
      FETCH c_balance INTO l_nRemaining_Balance ;
      CLOSE c_balance ;
      --
      l_vOperation_Status := 'COMPLETE' ;
      l_nAdjust_id        := NULL ;
      --
      IF NVL(r_invoices.symbolic_devolution_flag, 'N') <> 'Y' THEN
        l_vMensagem := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                     , p_lookup_code => 'NO_STOCK') ;
      ELSE
        l_vMensagem := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                     , p_lookup_code => 'SYMBOLIC_DEVOLUTION') ;
      END IF ;
      --
      l_vErro_Insert      := NULL ;
      --
      IF r_invoices.receipt_transaction_id IS NOT NULL AND r_invoices.symbolic_devolution_flag <> 'Y' THEN
        --
        BEGIN
          --
          SELECT mtl_material_transactions_s.NEXTVAL
            INTO l_nAdjust_id
            FROM dual ;
        --
        END ;
        --
        l_nSerial_Trans_Tmp_Id := NULL ;
        --
        IF r_invoices.serial_number_control_code <> 1 THEN
            l_nSerial_Trans_Tmp_Id := l_nAdjust_id ;
        END IF ;
        --
        BEGIN
          --
          -- BUG 29625111 - Start
          g_rec_trans_iface := g_crec_trans_iface ;
          --
          g_rec_trans_iface.transaction_interface_id := l_nAdjust_id ;
          g_rec_trans_iface.transaction_header_id    := l_nAdjust_id ;
          g_rec_trans_iface.source_code              := 'CLL_F513-RECEIPT: '|| r_invoices.devolution_operation_id|| '-' || r_invoices.organization_id ;
          g_rec_trans_iface.source_line_id           := r_invoices.devolution_invoice_line_id ;
          g_rec_trans_iface.source_header_id         := r_invoices.devolution_invoice_id ;
          g_rec_trans_iface.process_flag             := 1 ;
          g_rec_trans_iface.transaction_mode         := 3 ;
          g_rec_trans_iface.last_update_date         := SYSDATE ;
          g_rec_trans_iface.last_updated_by          := fnd_global.user_id ;
          g_rec_trans_iface.creation_date            := SYSDATE ;
          g_rec_trans_iface.created_by               := fnd_global.user_id ;
          g_rec_trans_iface.last_update_login        := fnd_global.login_id ;
          g_rec_trans_iface.inventory_item_id        := r_invoices.inventory_item_id ;
          g_rec_trans_iface.organization_id          := r_invoices.organization_id ;
          g_rec_trans_iface.transaction_quantity     := r_invoices.devolution_quantity * (-1) ;
          g_rec_trans_iface.transaction_uom          := r_invoices.uom_code ;
          g_rec_trans_iface.transaction_date         := to_date('01/05/2022 07:00:00','dd/mm/rrrr hh24:mi:ss'); --r_invoices.sefaz_authorization_date ;
          g_rec_trans_iface.subinventory_code        := r_invoices.subinventory ;
          g_rec_trans_iface.locator_id               := r_invoices.locator_id ;
          g_rec_trans_iface.transaction_type_id      := r_invoices.devolution_transaction_type_id ;
          g_rec_trans_iface.transaction_reference    := r_invoices.tpa_devolutions_control_id ;
          g_rec_trans_iface.distribution_account_id  := r_invoices.devolution_account_id ;
          g_msg_retorno                              := NULL ;
          --
          INSERT_TRANS_IFACE_P ( g_rec_trans_iface, g_msg_retorno ) ;
          --
          IF g_msg_retorno IS NOT NULL THEN
            --
            l_vErro_Insert := 'Y' ;
            --retcode        := 1 ;
            l_nTotal_Error := NVL(l_nTotal_Error, 0) + 1 ;
            --
            l_vMensagem    := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                            , p_lookup_code => 'INSERT_ERROR') ;
            g_msg_retorno  := l_vMensagem||g_msg_retorno ;
            --
            show_log (g_msg_retorno) ;
            show_log ('  customer_trx_id      - '||r_invoices.customer_trx_id) ;
            show_log ('  customer_trx_line_id - '||r_invoices.customer_trx_line_id) ;
            show_log ('  dev_operation_id     - '||r_invoices.tpa_devolutions_control_id) ;
            show_log ('  dev_control_id       - '||r_invoices.devolution_operation_id) ;
          END IF ;
          --
          -- BUG 29625111 - End
          --
          l_nTotal_Iface := NVL(l_nTotal_Iface, 0) + 1 ;
          --
        END ;
        --
        IF r_invoices.lot_control_code <> 1 AND NVL(l_vErro_Insert, 'N') = 'N' THEN
          --
          BEGIN
            --
            -- BUG 29625111 - Start
            g_rec_trans_lots_iface := g_crec_trans_lots_iface ;
            --
            g_rec_trans_lots_iface.transaction_interface_id   := l_nAdjust_id ;
            g_rec_trans_lots_iface.source_code                := 'CLL_F513-RECEIPT: '|| r_invoices.devolution_operation_id || '-' || r_invoices.organization_id ;
            g_rec_trans_lots_iface.source_line_id             := r_invoices.devolution_invoice_line_id ;
            g_rec_trans_lots_iface.last_update_date           := SYSDATE ;
            g_rec_trans_lots_iface.last_updated_by            := fnd_global.user_id ;
            g_rec_trans_lots_iface.creation_date              := SYSDATE ;
            g_rec_trans_lots_iface.created_by                 := fnd_global.user_id ;
            g_rec_trans_lots_iface.last_update_login          := fnd_global.login_id ;
            g_rec_trans_lots_iface.lot_number                 := r_invoices.lot_number ;
            g_rec_trans_lots_iface.lot_expiration_date        := r_invoices.expiration_date ;
            g_rec_trans_lots_iface.transaction_quantity       := r_invoices.devolution_quantity * (-1) ;
            g_rec_trans_lots_iface.serial_transaction_temp_id := l_nSerial_Trans_Tmp_Id ;
            g_rec_trans_lots_iface.process_flag               := 1 ;
            g_rec_trans_lots_iface.parent_lot_number          := r_invoices.parent_lot_number ;
            -- Enh 28431410 - Start
            g_rec_trans_lots_iface.lot_attribute_category     := r_invoices.lot_attribute_category ;
            g_rec_trans_lots_iface.c_attribute1               := r_invoices.lot_c_attribute1 ;
            g_rec_trans_lots_iface.c_attribute2               := r_invoices.lot_c_attribute2 ;
            g_rec_trans_lots_iface.c_attribute3               := r_invoices.lot_c_attribute3 ;
            g_rec_trans_lots_iface.c_attribute4               := r_invoices.lot_c_attribute4 ;
            g_rec_trans_lots_iface.c_attribute5               := r_invoices.lot_c_attribute5 ;
            g_rec_trans_lots_iface.c_attribute6               := r_invoices.lot_c_attribute6 ;
            g_rec_trans_lots_iface.c_attribute7               := r_invoices.lot_c_attribute7 ;
            g_rec_trans_lots_iface.c_attribute8               := r_invoices.lot_c_attribute8 ;
            g_rec_trans_lots_iface.c_attribute9               := r_invoices.lot_c_attribute9 ;
            g_rec_trans_lots_iface.c_attribute10              := r_invoices.lot_c_attribute10 ;
            g_rec_trans_lots_iface.c_attribute11              := r_invoices.lot_c_attribute11 ;
            g_rec_trans_lots_iface.c_attribute12              := r_invoices.lot_c_attribute12 ;
            g_rec_trans_lots_iface.c_attribute13              := r_invoices.lot_c_attribute13 ;
            g_rec_trans_lots_iface.c_attribute14              := r_invoices.lot_c_attribute14 ;
            g_rec_trans_lots_iface.c_attribute15              := r_invoices.lot_c_attribute15 ;
            g_rec_trans_lots_iface.c_attribute16              := r_invoices.lot_c_attribute16 ;
            g_rec_trans_lots_iface.c_attribute17              := r_invoices.lot_c_attribute17 ;
            g_rec_trans_lots_iface.c_attribute18              := r_invoices.lot_c_attribute18 ;
            g_rec_trans_lots_iface.c_attribute19              := r_invoices.lot_c_attribute19 ;
            g_rec_trans_lots_iface.c_attribute20              := r_invoices.lot_c_attribute20 ;
            g_rec_trans_lots_iface.d_attribute1               := r_invoices.lot_d_attribute1 ;
            g_rec_trans_lots_iface.d_attribute2               := r_invoices.lot_d_attribute2 ;
            g_rec_trans_lots_iface.d_attribute3               := r_invoices.lot_d_attribute3 ;
            g_rec_trans_lots_iface.d_attribute4               := r_invoices.lot_d_attribute4 ;
            g_rec_trans_lots_iface.d_attribute5               := r_invoices.lot_d_attribute5 ;
            g_rec_trans_lots_iface.d_attribute6               := r_invoices.lot_d_attribute6 ;
            g_rec_trans_lots_iface.d_attribute7               := r_invoices.lot_d_attribute7 ;
            g_rec_trans_lots_iface.d_attribute8               := r_invoices.lot_d_attribute8 ;
            g_rec_trans_lots_iface.d_attribute9               := r_invoices.lot_d_attribute9 ;
            g_rec_trans_lots_iface.d_attribute10              := r_invoices.lot_d_attribute10 ;
            g_rec_trans_lots_iface.n_attribute1               := r_invoices.lot_n_attribute1 ;
            g_rec_trans_lots_iface.n_attribute2               := r_invoices.lot_n_attribute2 ;
            g_rec_trans_lots_iface.n_attribute3               := r_invoices.lot_n_attribute3 ;
            g_rec_trans_lots_iface.n_attribute4               := r_invoices.lot_n_attribute4 ;
            g_rec_trans_lots_iface.n_attribute5               := r_invoices.lot_n_attribute5 ;
            g_rec_trans_lots_iface.n_attribute6               := r_invoices.lot_n_attribute6 ;
            g_rec_trans_lots_iface.n_attribute7               := r_invoices.lot_n_attribute7 ;
            g_rec_trans_lots_iface.n_attribute8               := r_invoices.lot_n_attribute8 ;
            g_rec_trans_lots_iface.n_attribute9               := r_invoices.lot_n_attribute9 ;
            g_rec_trans_lots_iface.n_attribute10              := r_invoices.lot_n_attribute10 ;
            --
            g_rec_trans_lots_iface.attribute_category       := r_invoices.attribute_category_lot ;
            g_rec_trans_lots_iface.attribute1               := r_invoices.attribute1_lot ;
            g_rec_trans_lots_iface.attribute2               := r_invoices.attribute2_lot ;
            g_rec_trans_lots_iface.attribute3               := r_invoices.attribute3_lot ;
            g_rec_trans_lots_iface.attribute4               := r_invoices.attribute4_lot ;
            g_rec_trans_lots_iface.attribute5               := r_invoices.attribute5_lot ;
            g_rec_trans_lots_iface.attribute6               := r_invoices.attribute6_lot ;
            g_rec_trans_lots_iface.attribute7               := r_invoices.attribute7_lot ;
            g_rec_trans_lots_iface.attribute8               := r_invoices.attribute8_lot ;
            g_rec_trans_lots_iface.attribute9               := r_invoices.attribute9_lot ;
            g_rec_trans_lots_iface.attribute10              := r_invoices.attribute10_lot ;
            g_rec_trans_lots_iface.attribute11              := r_invoices.attribute11_lot ;
            g_rec_trans_lots_iface.attribute12              := r_invoices.attribute12_lot ;
            g_rec_trans_lots_iface.attribute13              := r_invoices.attribute13_lot ;
            g_rec_trans_lots_iface.attribute14              := r_invoices.attribute14_lot ;
            g_rec_trans_lots_iface.attribute15              := r_invoices.attribute15_lot ;
            -- Enh 28431410 - End

            g_msg_retorno                                     := NULL ;
            --
            INSERT_TRANS_LOTS_IFACE_P ( g_rec_trans_lots_iface, g_msg_retorno ) ;
            --
            IF g_msg_retorno IS NOT NULL THEN
              --
              l_vErro_Insert := 'Y' ;
              --retcode        := 1 ;
              l_nTotal_Error := NVL(l_nTotal_Error, 0) + 1 ;
              l_vMensagem    := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                              , p_lookup_code => 'INSERT_ERROR') ;
              g_msg_retorno  := l_vMensagem||g_msg_retorno ;
              --
              ROLLBACK ;
              --
              show_log (g_msg_retorno) ;
              show_log ('  customer_trx_id      - '||r_invoices.customer_trx_id) ;
              show_log ('  customer_trx_line_id - '||r_invoices.customer_trx_line_id) ;
              show_log ('  dev_operation_id     - '||r_invoices.tpa_devolutions_control_id) ;
              show_log ('  dev_control_id       - '||r_invoices.devolution_operation_id) ;
              --
            END IF ;
            --
            -- BUG 29625111 - End
            --
            l_nTotal_Batch := NVL(l_nTotal_Batch, 0) +1 ;
            --
          END ;
          --
        END IF ;
        --
        IF r_invoices.serial_number_control_code <> 1 AND NVL(l_vErro_Insert, 'N') = 'N' THEN
          --
          BEGIN
            --
            -- BUG 29625111 - Start
            g_rec_serial_num_iface := g_crec_serial_num_iface ;
            --
            g_rec_serial_num_iface.transaction_interface_id := l_nAdjust_id ;
            g_rec_serial_num_iface.source_code              := 'CLL_F513-RECEIPT: '|| r_invoices.devolution_operation_id || '-' || r_invoices.organization_id ;
            g_rec_serial_num_iface.source_line_id           := r_invoices.devolution_invoice_line_id ;
            g_rec_serial_num_iface.last_update_date         := SYSDATE ;
            g_rec_serial_num_iface.last_updated_by          := fnd_global.user_id ;
            g_rec_serial_num_iface.creation_date            := SYSDATE ;
            g_rec_serial_num_iface.created_by               := fnd_global.user_id ;
            g_rec_serial_num_iface.last_update_login        := fnd_global.login_id ;
            g_rec_serial_num_iface.fm_serial_number         := r_invoices.serial_number ;
            g_rec_serial_num_iface.to_serial_number         := r_invoices.serial_number ;
            g_rec_serial_num_iface.process_flag             := 1 ;
            -- Enh 28431410 - Start
            g_rec_serial_num_iface.serial_attribute_category  := r_invoices.serial_attribute_category ;
            g_rec_serial_num_iface.c_attribute1               := r_invoices.serial_c_attribute1 ;
            g_rec_serial_num_iface.c_attribute2               := r_invoices.serial_c_attribute2 ;
            g_rec_serial_num_iface.c_attribute3               := r_invoices.serial_c_attribute3 ;
            g_rec_serial_num_iface.c_attribute4               := r_invoices.serial_c_attribute4 ;
            g_rec_serial_num_iface.c_attribute5               := r_invoices.serial_c_attribute5 ;
            g_rec_serial_num_iface.c_attribute6               := r_invoices.serial_c_attribute6 ;
            g_rec_serial_num_iface.c_attribute7               := r_invoices.serial_c_attribute7 ;
            g_rec_serial_num_iface.c_attribute8               := r_invoices.serial_c_attribute8 ;
            g_rec_serial_num_iface.c_attribute9               := r_invoices.serial_c_attribute9 ;
            g_rec_serial_num_iface.c_attribute10              := r_invoices.serial_c_attribute10 ;
            g_rec_serial_num_iface.c_attribute11              := r_invoices.serial_c_attribute11 ;
            g_rec_serial_num_iface.c_attribute12              := r_invoices.serial_c_attribute12 ;
            g_rec_serial_num_iface.c_attribute13              := r_invoices.serial_c_attribute13 ;
            g_rec_serial_num_iface.c_attribute14              := r_invoices.serial_c_attribute14 ;
            g_rec_serial_num_iface.c_attribute15              := r_invoices.serial_c_attribute15 ;
            g_rec_serial_num_iface.c_attribute16              := r_invoices.serial_c_attribute16 ;
            g_rec_serial_num_iface.c_attribute17              := r_invoices.serial_c_attribute17 ;
            g_rec_serial_num_iface.c_attribute18              := r_invoices.serial_c_attribute18 ;
            g_rec_serial_num_iface.c_attribute19              := r_invoices.serial_c_attribute19 ;
            g_rec_serial_num_iface.c_attribute20              := r_invoices.serial_c_attribute20 ;
            g_rec_serial_num_iface.d_attribute1               := r_invoices.serial_d_attribute1 ;
            g_rec_serial_num_iface.d_attribute2               := r_invoices.serial_d_attribute2 ;
            g_rec_serial_num_iface.d_attribute3               := r_invoices.serial_d_attribute3 ;
            g_rec_serial_num_iface.d_attribute4               := r_invoices.serial_d_attribute4 ;
            g_rec_serial_num_iface.d_attribute5               := r_invoices.serial_d_attribute5 ;
            g_rec_serial_num_iface.d_attribute6               := r_invoices.serial_d_attribute6 ;
            g_rec_serial_num_iface.d_attribute7               := r_invoices.serial_d_attribute7 ;
            g_rec_serial_num_iface.d_attribute8               := r_invoices.serial_d_attribute8 ;
            g_rec_serial_num_iface.d_attribute9               := r_invoices.serial_d_attribute9 ;
            g_rec_serial_num_iface.d_attribute10              := r_invoices.serial_d_attribute10 ;
            g_rec_serial_num_iface.n_attribute1               := r_invoices.serial_n_attribute1 ;
            g_rec_serial_num_iface.n_attribute2               := r_invoices.serial_n_attribute2 ;
            g_rec_serial_num_iface.n_attribute3               := r_invoices.serial_n_attribute3 ;
            g_rec_serial_num_iface.n_attribute4               := r_invoices.serial_n_attribute4 ;
            g_rec_serial_num_iface.n_attribute5               := r_invoices.serial_n_attribute5 ;
            g_rec_serial_num_iface.n_attribute6               := r_invoices.serial_n_attribute6 ;
            g_rec_serial_num_iface.n_attribute7               := r_invoices.serial_n_attribute7 ;
            g_rec_serial_num_iface.n_attribute8               := r_invoices.serial_n_attribute8 ;
            g_rec_serial_num_iface.n_attribute9               := r_invoices.serial_n_attribute9 ;
            g_rec_serial_num_iface.n_attribute10              := r_invoices.serial_n_attribute10 ;
            --
            g_rec_serial_num_iface.attribute_category       := r_invoices.attribute_category_serie ;
            g_rec_serial_num_iface.attribute1               := r_invoices.attribute1_serie ;
            g_rec_serial_num_iface.attribute2               := r_invoices.attribute2_serie ;
            g_rec_serial_num_iface.attribute3               := r_invoices.attribute3_serie ;
            g_rec_serial_num_iface.attribute4               := r_invoices.attribute4_serie ;
            g_rec_serial_num_iface.attribute5               := r_invoices.attribute5_serie ;
            g_rec_serial_num_iface.attribute6               := r_invoices.attribute6_serie ;
            g_rec_serial_num_iface.attribute7               := r_invoices.attribute7_serie ;
            g_rec_serial_num_iface.attribute8               := r_invoices.attribute8_serie ;
            g_rec_serial_num_iface.attribute9               := r_invoices.attribute9_serie ;
            g_rec_serial_num_iface.attribute10              := r_invoices.attribute10_serie ;
            g_rec_serial_num_iface.attribute11              := r_invoices.attribute11_serie ;
            g_rec_serial_num_iface.attribute12              := r_invoices.attribute12_serie ;
            g_rec_serial_num_iface.attribute13              := r_invoices.attribute13_serie ;
            g_rec_serial_num_iface.attribute14              := r_invoices.attribute14_serie ;
            g_rec_serial_num_iface.attribute15              := r_invoices.attribute15_serie ;
            -- Enh 28431410 - End
            --
            g_msg_retorno                                   := NULL ;
            --
            INSERT_SERIAL_NUM_IFACE_P ( g_rec_serial_num_iface, g_msg_retorno ) ;
            --
            IF g_msg_retorno IS NOT NULL THEN
              --
              l_vErro_Insert := 'Y' ;
              --retcode        := 1 ;
              l_nTotal_Error := NVL(l_nTotal_Error, 0) + 1 ;
              --
              l_vMensagem    := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                              , p_lookup_code => 'INSERT_ERROR') ;
              g_msg_retorno  := l_vMensagem||g_msg_retorno ;
              --
              ROLLBACK ;
              --
              show_log (g_msg_retorno) ;
              show_log ('  customer_trx_id      - '||r_invoices.customer_trx_id) ;
              show_log ('  customer_trx_line_id - '||r_invoices.customer_trx_line_id) ;
              show_log ('  dev_operation_id     - '||r_invoices.tpa_devolutions_control_id) ;
              show_log ('  dev_control_id       - '||r_invoices.devolution_operation_id) ;
              --
            END IF ;
            --
            -- BUG 29625111 - End
            --
            l_nTotal_Serial := NVL(l_nTotal_Serial, 0) + 1 ;
            --
          END ;
          --
        END IF ;
        --
        IF NVL(l_vErro_Insert, 'N') = 'N' THEN
          --
          l_vError_Code        := NULL ;
          l_vError_Explanation := NULL ;
          l_vResult_Adjust     := TRUE ;
          --
          l_vMensagem          := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                                , p_lookup_code => 'SUCCESSFUL') ;
          --
----          l_vResult_Adjust     := apps.mtl_online_transaction_pub.process_online ( l_nAdjust_id
----                                                                            , l_nTimeout
----                                                                            , l_vError_Code
----                                                                            , l_vError_Explanation ) ;
          --
          IF l_vResult_Adjust = FALSE THEN
            --
            --retcode        := 1 ;
            l_vErro_Insert := 'Y' ;
            l_nTotal_Error := NVL(l_nTotal_Error, 0) + 1 ;
            --
            l_vMensagem    := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                            , p_lookup_code => 'INTERFACE_ERROR') ;
            l_vMensagem    := l_vMensagem||SUBSTR(RTRIM(LTRIM(l_vError_Code))||' '||RTRIM(LTRIM(l_vError_Explanation)), 1, 4000) ;
            --
            show_log (l_vMensagem) ;
            show_log ('  customer_trx_id      - '||r_invoices.customer_trx_id) ;
            show_log ('  customer_trx_line_id - '||r_invoices.customer_trx_line_id) ;
            show_log ('  dev_operation_id     - '||r_invoices.tpa_devolutions_control_id) ;
            show_log ('  dev_control_id       - '||r_invoices.devolution_operation_id) ;
            --
            l_vOperation_Status := 'INVENTORY PENDING' ;
            --
          END IF ;
          --
          -- Enh 29553257 - Start
          --
          BEGIN
            --
----            DELETE apps.mtl_serial_numbers_interface WHERE transaction_interface_id = l_nAdjust_id ;
            null;
            --
          EXCEPTION WHEN OTHERS THEN
            SHOW_LOG('Error deleting mtl_serial_numbers_interface - transaction_interface_id '||l_nAdjust_id||' - '|| SQLERRM);
          END ;
          --
          BEGIN
            --
----            DELETE apps.mtl_transaction_lots_interface WHERE transaction_interface_id = l_nAdjust_id ;
            null;
            --
          EXCEPTION WHEN OTHERS THEN
            SHOW_LOG('Error deleting mtl_transaction_lots_interface - transaction_interface_id '||l_nAdjust_id||' - '|| SQLERRM);
          END ;
          --
          BEGIN
            --
----            DELETE apps.mtl_transactions_interface WHERE transaction_interface_id = l_nAdjust_id ;
            null;
            --
          EXCEPTION WHEN OTHERS THEN
            SHOW_LOG('Error deleting mtl_transactions_interface - transaction_interface_id '||l_nAdjust_id||' - '|| SQLERRM);
          END ;
          --
          -- Enh 29553257 - End
          --
----          COMMIT ;
          --
        END IF ;
        --
      END IF ;
      --
      BEGIN
        --
        l_vMsg_Devolution := NULL ;
        --
        UPDATE apps.cll_f513_tpa_devolutions_ctrl
           SET customer_trx_id            = r_invoices.customer_trx_id
             , cust_trx_type_id           = r_invoices.cust_trx_type_id
             , customer_trx_line_id       = r_invoices.customer_trx_line_id
             , trx_number                 = r_invoices.invoice_number
             , trx_date                   = r_invoices.invoice_date
             , sefaz_authorization_date   = r_invoices.sefaz_authorization_date
             , devolution_transaction_id  = l_nAdjust_id
             , devolution_status          = l_vOperation_Status
             , last_update_date           = SYSDATE
             , last_updated_by            = fnd_global.user_id
             , last_update_login          = fnd_global.login_id
             , program_application_id     = l_nProgram_Appl_Id
             , program_id                 = l_nProgram_Id
             , program_update_date        = SYSDATE
             , error_flag                 = NVL(l_vErro_Insert, 'N')  -- Bug 29553127
         WHERE tpa_devolutions_control_id = r_invoices.tpa_devolutions_control_id ;
        --
        IF SQL%ROWCOUNT > 0 THEN
          l_vMsg_Devolution := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                             , p_lookup_code => 'SUCCESSFUL_DEVOLUTION') ;
        END IF ;
        --
      EXCEPTION
        WHEN OTHERS THEN
          l_vMsg_Devolution := NULL ;
      END ;
      --
      IF l_vOperation_Status = 'COMPLETE' THEN
        --
        BEGIN
          --
          l_vMsg_Receipt := NULL ;
          --
          UPDATE apps.cll_f513_tpa_receipts_control
             SET remaining_balance         = l_nRemaining_Balance - r_invoices.devolution_quantity
               , last_update_date          = SYSDATE
               , last_updated_by           = fnd_global.user_id
               , last_update_login         = fnd_global.login_id
               , program_application_id    = l_nProgram_Appl_Id
               , program_id                = l_nProgram_Id
               , program_update_date       = SYSDATE
           WHERE tpa_receipts_control_id   = r_invoices.tpa_receipts_control_id ;
          --
          IF SQL%ROWCOUNT > 0 THEN
            l_vMsg_Receipt := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                            , p_lookup_code => 'SUCCESSFUL_RECEIPT') ;
          END IF ;
          --
        EXCEPTION
          WHEN OTHERS THEN
            l_vMsg_Receipt := NULL ;
        END ;
        --
      END IF ;
      --
      l_vStatus := 'SUCCESSFUL' ;
      --
      IF NVL(l_vErro_Insert, 'N') = 'Y' THEN
        l_vStatus := 'UNSUCCESSFUL' ;
      END IF ;
      --
      insert_log_p ( p_org_id                     => r_invoices.org_id
                   , p_customer_number            => l_vCustomer_Number
                   , p_customer_name              => l_vCustomer_Name
                   , p_trx_number                 => r_invoices.invoice_number
                   , p_line_number                => r_invoices.line_number
                   , p_lot_number                 => r_invoices.lot_number
                   , p_serial_number              => r_invoices.serial_number
                   , p_process_status             => l_vStatus
                   , p_process_description        => l_vMensagem
                   , p_segment1                   => r_invoices.segment1
                   , p_source_subinventory        => r_invoices.subinventory
                   , p_source_locator_id          => r_invoices.locator_id
                   , p_operation_id               => r_invoices.devolution_operation_id
                   , p_invoice_number             => r_invoices.invoice_number
                   , p_item_number                => r_invoices.item_number
                   , p_tpa_receipt_control_id     => r_invoices.tpa_receipts_control_id
                   , p_receipt_transaction_id     => r_invoices.receipt_transaction_id
                   , p_tpa_devolutions_control_id => r_invoices.tpa_devolutions_control_id
                   , p_devolution_transaction_id  => l_nAdjust_id
                   ) ;
      --
      l_vStatus := 'SUCCESSFUL' ;
      --
      IF l_vMsg_Devolution IS NULL THEN
          l_vStatus         := 'UNSUCCESSFUL' ;
          l_vMsg_Devolution := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                             , p_lookup_code => 'UNSUCCESSFUL_DEVOLUTION') ;
      END IF ;
      --
      insert_log_p ( p_org_id                     => r_invoices.org_id
                   , p_customer_number            => l_vCustomer_Number
                   , p_customer_name              => l_vCustomer_Name
                   , p_trx_number                 => r_invoices.invoice_number
                   , p_line_number                => r_invoices.line_number
                   , p_lot_number                 => r_invoices.lot_number
                   , p_serial_number              => r_invoices.serial_number
                   , p_process_status             => l_vStatus
                   , p_process_description        => l_vMsg_Devolution
                   , p_segment1                   => r_invoices.segment1
                   , p_source_subinventory        => r_invoices.subinventory
                   , p_source_locator_id          => r_invoices.locator_id
                   , p_operation_id               => r_invoices.devolution_operation_id
                   , p_invoice_number             => r_invoices.invoice_number
                   , p_item_number                => r_invoices.item_number
                   , p_tpa_receipt_control_id     => r_invoices.tpa_receipts_control_id
                   , p_receipt_transaction_id     => r_invoices.receipt_transaction_id
                   , p_tpa_devolutions_control_id => r_invoices.tpa_devolutions_control_id
                   , p_devolution_transaction_id  => l_nAdjust_id
                   ) ;
      --
      l_vStatus := 'SUCCESSFUL' ;
      --
      IF l_vMsg_Receipt IS NULL THEN
          l_vStatus      := 'UNSUCCESSFUL' ;
          l_vMsg_Receipt := get_lookup_values ( p_lookup_type => 'CLL_F513_TPA_DEVOLUTION_CTRL'
                                                                          , p_lookup_code => 'UNSUCCESSFUL_RECEIPT') ;
      END IF ;
      --
      insert_log_p ( p_org_id                     => r_invoices.org_id
                   , p_customer_number            => l_vCustomer_Number
                   , p_customer_name              => l_vCustomer_Name
                   , p_trx_number                 => r_invoices.invoice_number
                   , p_line_number                => r_invoices.line_number
                   , p_lot_number                 => r_invoices.lot_number
                   , p_serial_number              => r_invoices.serial_number
                   , p_process_status             => l_vStatus
                   , p_process_description        => l_vMsg_Receipt
                   , p_segment1                   => r_invoices.segment1
                   , p_source_subinventory        => r_invoices.subinventory
                   , p_source_locator_id          => r_invoices.locator_id
                   , p_operation_id               => r_invoices.devolution_operation_id
                   , p_invoice_number             => r_invoices.invoice_number
                   , p_item_number                => r_invoices.item_number
                   , p_tpa_receipt_control_id     => r_invoices.tpa_receipts_control_id
                   , p_receipt_transaction_id     => r_invoices.receipt_transaction_id
                   , p_tpa_devolutions_control_id => r_invoices.tpa_devolutions_control_id
                   , p_devolution_transaction_id  => l_nAdjust_id
                   ) ;
      --
----      COMMIT ;
      --
    END LOOP ;
    --
----    show_report ( p_nrequest_id        => fnd_global.conc_request_id
----                , p_vOrganization_code => l_vOrganization_Ant
----                , p_dDate_from         => p_date_from
----                , p_dDate_to           => p_date_to
----                , p_nOrg_id            => p_org_id
----                ) ;
    --
  END execute_process_p ;
  --
begin
                      execute_process_p ( p_date_from         => '2022-04-01 00:00:00',
                      p_date_to           => '2022-05-31 00:00:00',
                      p_org_id            => 155, -- colocar unidade organizacional
                      p_tpa_dev_ctrl_id   => 7662 -- informar o TPA_ID ou ID de transação da Linha com erro
                    );
end;


-- SELECT DE VALIDAÇÃO DE TRANSAÇÃO DEVOLUÇÃO TPMG X INV
select 
    a.devolution_operation_id operação,
    a.devolution_date data_devolução,
    a.subinventory subinventário,
    a.devolution_invoice_line_id,
    devolution_transaction_id id_tpmg_transação,
    b.transaction_id ID_TRANSAÇÃO_INV,
    b.creation_date CRIAÇÃO_TRANSACAO_TABELA,
    b.transaction_date DATA_TRANSAÇÃO,
    b.transaction_quantity,
    c.segment1 ITEM_TRANSFERIDO
    from
    cll_f513_tpa_devolutions_ctrl  a
    LEFT JOIN mtl_material_transactions b ON  a.devolution_transaction_id = b.transaction_set_id
    JOIN mtl_system_items_b c ON a.inventory_item_id = c.inventory_item_id
WHERE
    a.devolution_operation_id = 215 -- COLOCAR NÚMERO DO RI da Devolução
    and c.organization_id = '164';
    
select * from mtl_transactions_interface where organization_id = '164';
select segment1 from mtl_system_items_b where inventory_item_id = '6805'