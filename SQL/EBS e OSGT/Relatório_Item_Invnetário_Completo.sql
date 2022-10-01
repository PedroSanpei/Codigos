SELECT
    ood.organization_code            empresa,
    msib.segment1                    item,
    msib.description                 descricao,
    msitl.long_description           descricao_longa,
    msib.primary_unit_of_measure     uom,
    flvv.meaning                     tipo_item,
    msib.inventory_item_status_code status_item,
    c_invent.category_set_name       conj_categ_inv,
    c_invent.description                categoria_inv,
    c_ncm.segment1                   categoria_ncm,
    c_plan.category_set_name         conj_categ_plan,
    c_plan.segment1                  categoria_plan,
    c_cust.category_set_name         conj_categ_custo,
    c_cust.segment1                  categoria_custo,
    c_po.category_set_name           conj_categ_po,
    c_po.segment1                    categoria_po,
    msifv.weight_uom_code            uom_code,
    msifv.unit_weight                peso,
    catalogo.segment1                catalogo,
    nick.element_value               nickname,
    ano_fab.element_value            ano_fabricacao,
    ano_mod.element_value            ano_modelo,
    msib.segment1                    modelo,
    cor.element_value                cor,
    cilindrada.element_value         cilindrada,
    potencia.element_value           potencia,
    renavan.element_value            renavan,
    dcre.element_value               dcr_e,
    num_pass.element_value           num_passageiros,
    dist_eixo.element_value          distancia_eixos,
    pintura.element_value            tipo_pintura,
    combustivel.element_value        tipo_combustivel,
    tipo_veiculo.element_value       tipo_veiculo,
    esp_veiculo.element_value        especie_veiculo,
    pbt.element_value                pbt,
    nome_comercial.element_value     nome_comercial,
    cv.element_value                 cv,
    peso_embalagem.element_value     peso_embalagem,
    linha.element_value              linha,
    cat_motor.element_value          categoria_motor,
    unid_medida.element_value        unidade_medida,
    cor_renavam.element_value        cod_cor__renavam,
    cor_prod.element_value           cor_producao,
    ood.organization_code            org,
    msib.global_attribute2           utilizacao,
    msib.global_attribute3           orig,
    msib.global_attribute4           fiscal_type,
    msib.global_attribute5           sit_trib_fed,
    msib.global_attribute6           sit_trib_est,
    msib.postprocessing_lead_time    lead_time_pos,
    msib.lead_time_lot_size          lead_time_tam_lot,
    msib.lead_time_lot_size          lead_time_lot_padrao,
    msib.global_attribute9           cest,
    msib.cost_of_sales_account       conta_id,
    glcode.segment1                  empresa,
    glcode.segment2                  centro_de_custo,
    glcode.segment3                  conta_contabil,
    glcode.segment4                  local,
    glcode.segment5                  produto,
    glcode.segment6                  intercompany,
    glcode.segment7                  futuro1,
    glcode.segment8                  futuro2,
    msifv.expense_account       conta_despesa_id,
    glcode2.segment1                  empresa_despesa,
    glcode2.segment2                  centro_de_custo_despesa,
    glcode2.segment3                  conta_contabil_despesa,
    glcode2.segment4                  local_despesa,
    glcode2.segment5                  produto_despesa,
    glcode2.segment6                  intercompany_despesa,
    glcode2.segment7                  futuro1_despesa,
    glcode2.segment8                  futuro2_despesa
FROM
    mtl_system_items_b            msib,
    mtl_system_items_tl           msitl,
    org_organization_definitions  ood,
    fnd_lookup_types_vl           flvt,
    fnd_lookup_values_vl          flvv,
    mtl_system_items_fvl          msifv,
    gl_code_combinations_v        glcode,
    gl_code_combinations_v        glcode2,
    (
        SELECT
            mmna.organization_id,
            mmna.inventory_item_id,
            mm.manufacturer_name
        FROM
            mtl_manufacturers           mm,
            mtl_mfg_part_numbers_all_v  mmna
        WHERE
            mm.manufacturer_id = mmna.manufacturer_id
    )                             manu,
    (
        SELECT
            mic.inventory_item_id,
            mic.organization_id,
            mcs.category_set_name,
            mc.description
        FROM
            mtl_item_categories  mic,
            mtl_category_sets    mcs,
            mtl_categories       mc
        WHERE
                mic.category_set_id = mcs.category_set_id
            AND mic.category_id = mc.category_id
            AND mcs.category_set_name in ('Inventário','Cost Category','PO Item Categories','Planning Category','FISCAL_CLASSIFICATION')
    )                             c_invent,
    (
        SELECT
            mic.inventory_item_id,
            mic.organization_id,
            mcs.category_set_name,
            mc.segment1
        FROM
            mtl_item_categories  mic,
            mtl_category_sets    mcs,
            mtl_categories       mc
        WHERE
                mic.category_set_id = mcs.category_set_id
            AND mic.category_id = mc.category_id
            AND mcs.category_set_name = 'FISCAL_CLASSIFICATION'
    )                             c_ncm,
    (
        SELECT
            mic.inventory_item_id,
            mic.organization_id,
            mcs.category_set_name,
            mc.segment1
        FROM
            mtl_item_categories  mic,
            mtl_category_sets    mcs,
            mtl_categories       mc
        WHERE
                mic.category_set_id = mcs.category_set_id
            AND mic.category_id = mc.category_id
            AND mcs.category_set_name = 'Planning Category'
    )                             c_plan,
    (
        SELECT
            mic.inventory_item_id,
            mic.organization_id,
            mcs.category_set_name,
            mc.segment1
        FROM
            mtl_item_categories  mic,
            mtl_category_sets    mcs,
            mtl_categories       mc
        WHERE
                mic.category_set_id = mcs.category_set_id
            AND mic.category_id = mc.category_id
            AND mcs.category_set_name = 'Cost Category'
    )                             c_cust,
    (
        SELECT
            mic.inventory_item_id,
            mic.organization_id,
            mcs.category_set_name,
            mc.segment1
        FROM
            mtl_item_categories  mic,
            mtl_category_sets    mcs,
            mtl_categories       mc
        WHERE
                mic.category_set_id = mcs.category_set_id
            AND mic.category_id = mc.category_id
            AND mcs.category_set_name = 'PO Item Categories'
    )                             c_po,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            micg.segment1
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'NICKNAME'
            AND msiv.organization_id <> 147
    )                             catalogo,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'NICKNAME'
            AND msiv.organization_id <> 147
    )                             nick,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'ANO/FAB'
            AND msiv.organization_id <> 147
    )                             ano_fab,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'ANO/MOD'
            AND msiv.organization_id <> 147
    )                             ano_mod,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'COR'
            AND msiv.organization_id <> 147
    )                             cor,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'CILINDRADA'
            AND msiv.organization_id <> 147
    )                             cilindrada,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'POTENCIA'
            AND msiv.organization_id <> 147
    )                             potencia,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'RENAVAM'
            AND msiv.organization_id <> 147
    )                             renavan,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'DCR-E'
            AND msiv.organization_id <> 147
    )                             dcre,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'NUMERO_PASSAGEIRO'
            AND msiv.organization_id <> 147
    )                             num_pass,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'DISTANCIA_EIXOS'
            AND msiv.organization_id <> 147
    )                             dist_eixo,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'TIPO_PINTURA'
            AND msiv.organization_id <> 147
    )                             pintura,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'TIPO_COMBUSTIVEL'
            AND msiv.organization_id <> 147
    )                             combustivel,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'TIPO_VEICULO'
            AND msiv.organization_id <> 147
    )                             tipo_veiculo,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'ESPECIE_VEICULO'
            AND msiv.organization_id <> 147
    )                             esp_veiculo,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'PBT'
            AND msiv.organization_id <> 147
    )                             pbt,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'NOME_COMERCIAL'
            AND msiv.organization_id <> 147
    )                             nome_comercial,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'CV'
            AND msiv.organization_id <> 147
    )                             cv,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'PESO EMBALAGEM'
            AND msiv.organization_id <> 147
    )                             peso_embalagem,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'LINHA'
            AND msiv.organization_id <> 147
    )                             linha,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'CATEGORIA MOTOR'
            AND msiv.organization_id <> 147
    )                             cat_motor,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'UNIDADE MEDIDA'
            AND msiv.organization_id <> 147
    )                             unid_medida,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'CODIGO_COR_RENAVAN'
            AND msiv.organization_id <> 147
    )                             cor_renavam,
    (
        SELECT
            msiv.inventory_item_id,
            msiv.organization_id,
            mdev.element_value
        FROM
            mtl_system_items_fvl        msiv,
            mtl_descr_element_values_v  mdev,
            mtl_item_catalog_groups     micg
        WHERE
                1 = 1
            AND msiv.item_catalog_group_id = mdev.item_catalog_group_id
            AND msiv.inventory_item_id = mdev.inventory_item_id
            AND msiv.item_catalog_group_id = micg.item_catalog_group_id
            AND mdev.element_name = 'COR_PRODUCAO'
            AND msiv.organization_id <> 147
    )                             cor_prod
WHERE
        1 = 1
    AND glcode.code_combination_id = msib.cost_of_sales_account
    AND msib.cost_of_sales_account = glcode.code_combination_id
    AND msitl.organization_id = msib.organization_id
    AND msitl.inventory_item_id = msib.inventory_item_id
    AND msitl.organization_id = ood.organization_id
    AND msitl.inventory_item_id = c_invent.inventory_item_id (+)
    AND msitl.organization_id = c_invent.organization_id (+)
    AND msitl.inventory_item_id = c_ncm.inventory_item_id (+)
    AND msitl.organization_id = c_ncm.organization_id (+)
    AND msitl.inventory_item_id = c_plan.inventory_item_id (+)
    AND msitl.organization_id = c_plan.organization_id (+)
    AND msitl.inventory_item_id = c_cust.inventory_item_id (+)
    AND msitl.organization_id = c_cust.organization_id (+)
    AND msitl.inventory_item_id = c_po.inventory_item_id (+)
    AND msitl.organization_id = c_po.organization_id (+)
    AND msitl.inventory_item_id = catalogo.inventory_item_id (+)
    AND msitl.organization_id = catalogo.organization_id (+)
    AND msitl.inventory_item_id = nick.inventory_item_id (+)
    AND msitl.organization_id = nick.organization_id (+)
    AND msitl.inventory_item_id = ano_fab.inventory_item_id (+)
    AND msitl.organization_id = ano_fab.organization_id (+)
    AND msitl.inventory_item_id = ano_mod.inventory_item_id (+)
    AND msitl.organization_id = ano_mod.organization_id (+)
    AND msitl.inventory_item_id = cor.inventory_item_id (+)
    AND msitl.organization_id = cor.organization_id (+)
    AND msitl.inventory_item_id = cilindrada.inventory_item_id (+)
    AND msitl.organization_id = cilindrada.organization_id (+)
    AND msitl.inventory_item_id = potencia.inventory_item_id (+)
    AND msitl.organization_id = potencia.organization_id (+)
    AND msitl.inventory_item_id = renavan.inventory_item_id (+)
    AND msitl.organization_id = renavan.organization_id (+)
    AND msitl.inventory_item_id = dcre.inventory_item_id (+)
    AND msitl.organization_id = dcre.organization_id (+)
    AND msitl.inventory_item_id = num_pass.inventory_item_id (+)
    AND msitl.organization_id = num_pass.organization_id (+)
    AND msitl.inventory_item_id = dist_eixo.inventory_item_id (+)
    AND msitl.organization_id = dist_eixo.organization_id (+)
    AND msitl.inventory_item_id = pintura.inventory_item_id (+)
    AND msitl.organization_id = pintura.organization_id (+)
    AND msitl.inventory_item_id = combustivel.inventory_item_id (+)
    AND msitl.organization_id = combustivel.organization_id (+)
    AND msitl.inventory_item_id = tipo_veiculo.inventory_item_id (+)
    AND msitl.organization_id = tipo_veiculo.organization_id (+)
    AND msitl.inventory_item_id = esp_veiculo.inventory_item_id (+)
    AND msitl.organization_id = esp_veiculo.organization_id (+)
    AND msitl.inventory_item_id = pbt.inventory_item_id (+)
    AND msitl.organization_id = pbt.organization_id (+)
    AND msitl.inventory_item_id = nome_comercial.inventory_item_id (+)
    AND msitl.organization_id = nome_comercial.organization_id (+)
    AND msitl.inventory_item_id = cv.inventory_item_id (+)
    AND msitl.organization_id = cv.organization_id (+)
    AND msitl.inventory_item_id = peso_embalagem.inventory_item_id (+)
    AND msitl.organization_id = peso_embalagem.organization_id (+)
    AND msitl.inventory_item_id = linha.inventory_item_id (+)
    AND msitl.organization_id = linha.organization_id (+)
    AND msitl.inventory_item_id = cat_motor.inventory_item_id (+)
    AND msitl.organization_id = cat_motor.organization_id (+)
    AND msitl.inventory_item_id = unid_medida.inventory_item_id (+)
    AND msitl.organization_id = unid_medida.organization_id (+)
    AND msitl.inventory_item_id = cor_renavam.inventory_item_id (+)
    AND msitl.organization_id = cor_renavam.organization_id (+)
    AND msitl.inventory_item_id = cor_prod.inventory_item_id (+)
    AND msitl.organization_id = cor_prod.organization_id (+)
    AND msitl.language = 'PTB'
    AND flvt.lookup_type = 'ITEM_TYPE'
    AND flvt.application_id = 401	--Inventory
	    AND flvt.lookup_type = flvv.lookup_type
    AND ood.organization_code IN ( 'MA', 'B01', 'B02', 'B03', 'B04',
                                   'B05', 'A05', 'A06',
                                   'B07',
                                   'B08',
                                   'B09' )
    AND flvv.lookup_code = nvl(msib.item_type, '00')
    AND msitl.organization_id = msifv.organization_id
    AND msitl.inventory_item_id = msifv.inventory_item_id
    AND msitl.inventory_item_id = manu.inventory_item_id (+)
    AND nvl(msib.inventory_item_status_code, 'XXX') = 'Active'
    AND glcode2.code_combination_id = msifv.expense_account
   --AND msib.segment1 = 'SER019'