select FI.NUM_INVOICE AAAA_NUM_INVOICE,
       FI.COD_PROCESSO AAA_COD_PROCESSO_INVOICE,
       FI.DATA AA_DATA_INVOICE,
       fi.data_embarque A_DATA_EMBARQUE_INVOICE,
       fi.ref_embarque BBB_REF_EMBARQUE_INVOICE,
       FI.Peso BB_PESO_INVOICE,
       FI.Valor B_VALOR_INVOICE,
       fi.moeda CCC_MOEDA_INVOICE,
       fi.terms CC_INCOTERM_INVOICE,
       fi.id_area C_AREA_NEGOCIO_INVOICE,
       fi.cod_via_transporte DDD_VIA_TRANSPORTE_INVOICE,
       fi.pais_procedencia || ' - ' || paisproc.desc_pais DD_PAIS_PROCEDENCIA_INVOICE,
       desp.cod_parceiro || ' - ' || desp.razao_social D_DESPACHANTE_INVOICE,
       decode(fi.status_li, 'O', 'LI''s OK', 'LI''s NAO OK') EEE_STATUS_LI_GERAL_INVOICE,
       forn.cod_parceiro || ' - ' || forn.razao_social EE_EXPORTADOR_INVOICE,
       pais_forn.desc_pais E_PAIS_EXPORTADOR_INVOICE,
       nvl((select descricao from sfw_complementar_parceiro cpp, sfw_vinculacao vinc where vinc.cod_vinculacao = cpp.cod_vinculacao and cpp.id_parceiro = forn.id_parceiro),'Não há vinculação') VINCULACAO_EXPORTADOR_INVOICE,
       decode((select cp.aliado_imp from sfw_complementar_parceiro cp where cp.id_parceiro = forn.id_parceiro),'S','SIM','NAO') ALIADO_FORNECEDOR_INVOICE,
       p.part_number FFF_PART_NUMBER_ITEM,
       p.ncm FF_NCM_ITEM,
       p.descricao_resumida F_DESC_RESUMIDA_ITEM,
       p.descricao_detalhada GGG_DESC_DETALHADA_ITEM,
       ifi.num_item_aux GG_NUM_ITEM_INVOICE,
       ifi.num_ordem G_NUM_ORDEM,
       ifi.num_item HHH_NUM_ITEM_ORDEM,
       mi.qtde HH_QTDE_ITEM,
       mi.cod_um_qtde H_UNIDADE_MEDIDA_ITEM,
       mi.preco III_VALOR_UNIT_ITEM,
       mi.qtde * mi.preco II_VALOR_TOTAL_ITEM,
       mi.vmcv_unit I_VMCV_UNIT_ITEM,
       mi.qtde * mi.vmcv_unit JJJ_VMCV_TOTAL_ITEM,
       mi.vmle_unit JJ_VMLE_UNIT_ITEM,
       mi.qtde * mi.vmle_unit J_VMLE_TOTAL_ITEM,
       mi.peso_liquido KKK_PESO_LIQUIDO_ITEM,
       mi.qtde * mi.peso_liquido KK_PESO_LIQUIDO_TOTAL_ITEM,
       mi.pais_origem K_PAIS_ORIGEM_ITEM,
       mi.id_regime || ' - ' || ra.descricao LLL_REGIME_ADUANEIRO_ITEM,
       mi.cod_externo_cfop LL_CFOP_COMPLEMENTAR_ITEM,
       fabri.cod_parceiro || ' - ' || fabri.razao_social L_FABRICANTE_ITEM,
       pais_fabri.desc_pais MMM_PAIS_FABRICANTE_ITEM,
       fabri.logradouro || ' - ' || fabri.numero || ' - ' ||
       fabri.bairro_parc || ' - ' || fabri.cidade MM_ENDERECO_FABRICANTE_ITEM,
       mi.FLEX_FIELD20 M_SEQUENCIA_SUFRAMA_ITEM,
       sdns.DESCRICAO DESTAQUE_SUFRAMA,
       mi.FLEX_FIELD21 NNN_COD_SUFRAMA_ITEM,
       mi.FLEX_FIELD22 NN_TIPO_SUFRAMA_ITEM,
       mi.FLEX_FIELD23 N_MODELO_SUFRAMA_ITEM,
       mi.FLEX_FIELD24 OOO_DETALHE_SUFRAMA_ITEM,
       (select descricao
          from SFW_TAB_REG_TRIBUTARIO_SISCOME
         where codigo = ra.ii_regime_tributacao) OO_REGIME_II_ITEM,
       ra.ii_fundamento_legal O_FUNDAMENTO_LEGAL_II_ITEM,
       is_fnc_is_busca_aliquota_ii(null,
                                   sysdate,
                                   sysdate,
                                   imi.cod_peca_macro) PPPP_ALIQ_II_ITEM,
       (select descricao
          from bs_beneficio_ipi
         where cod_beneficio_ipi = ra.ipi_beneficio) PPP_REGIME_IPI_ITEM,
       is_fnc_is_busca_aliquota_ipi(null,
                                    sysdate,
                                    sysdate,
                                    imi.cod_peca_macro) PP_ALIQ_IPI_ITEM,
       (select descricao from is_regime_icms where id_icms = ra.id_icms) P_REGIME_ICMS_ITEM,
       (select picm.aliquota_icms_prod
          from sfw_produtos_icms picm
         where picm.id_produto = mi.cod_peca_macro
           and UF = 'AM') QQQQ_ALIQ_ICMS_ITEM,
       (select descricao
          from is_regime_pis_cofins
         where id_pis_cofins = ra.id_pis_cofins) QQQ_REGIME_PIS_COFINS_ITEM,
       ra.pis_cofins_cd_fund_leg_regim QQ_FUND_LEGAL_PIS_COFINS_ITEM,
       nvl(p.pis,
           (select s.aliquota_pis
              from sfw_tab_ncm_siscomex s
             where s.ncm = p.ncm)) Q_ALIQ_PIS_ITEM,
       nvl(p.cofins,
           (select s.aliquota_cofins
              from sfw_tab_ncm_siscomex s
             where s.ncm = p.ncm)) RRRR_ALIQ_COFINS_ITEM,
       DECODE(mi.necessita_li, 'S', 'SIM', 'NAO') RRR_NECESSITA_LI_ITEM,
       item_li.identificacao RR_IDENTIFICACAO_LI_ITEM,
       hli.num_li R_NUM_LI_ITEM,
       hli.status_li SSSS_STATUS_LI_ITEM,
       (select decode(valida, 'S', 'SIM', 'NAO')
          from is_licencas_importacao liimport
         where liimport.identificacao_li = hli.identificacao) SSS_LI_VALIDA_ITEM,
         (select num_destaque_ncm from sfw_destaque_ncm_produto where id_produto = p.id_produto and rownum = 1) SS_DESTAQUE_NCM_ITEM,
         (select CD_ATRIBUTO_NCM from sfw_produto_nve where id_produto = p.id_produto and CD_NOMENC_NCM = p.ncm and rownum = 1) S_NVE_ITEM --#999 Pedro Sanepi 30/06/2022
  from is_faturas_importacao      fi,
       is_itens_fatura_importacao ifi,
       is_item_macro_item         imi,
       is_macro_item              mi,
       sfw_produto                p,
       sfw_parceiro               desp,
       sfw_pais                   paisproc,
       sfw_parceiro               forn,
       sfw_pais                   pais_forn,
       is_regime_aduaneiro        ra,
       sfw_parceiro               fabri,
       sfw_pais                   pais_fabri,
       bs_item_li                 item_li,
       bs_li                      hli,
       sfw_detalhe_ncm_suframa    sdns

 where fi.id_invoice = ifi.id_invoice
   and ifi.num_item = imi.num_item
   and sdns.id_detalhe_suframa (+)= p.ID_DETALHE_SUFRAMA
   and ifi.cod_peca = imi.cod_peca
   and ifi.id_invoice = imi.id_invoice
   and ifi.num_ordem = imi.num_ordem
   and imi.cod_peca_macro = mi.cod_peca_macro
   and imi.num_item_macro = mi.num_item_macro
   and imi.id_invoice_macro = mi.id_invoice_macro
   and p.id_produto = ifi.cod_peca
   and desp.id_parceiro(+) = fi.id_despachante
   and paisproc.cod_pais_siscomex_imp(+) = fi.pais_procedencia
   and forn.cod_parceiro = fi.divisao_venda
   and pais_forn.cod_pais(+) = forn.cod_pais
   and mi.id_regime = ra.id_regime(+)
   and fabri.cod_parceiro(+) = mi.cod_fabricante
   and pais_fabri.cod_pais(+) = fabri.cod_pais
   and mi.id_item_li = item_li.id_item_li(+)
   and item_li.identificacao = hli.identificacao(+)
   and fi.id_invoice = 7385
 order by fi.cod_processo, fi.num_invoice, ifi.num_item_aux asc;
