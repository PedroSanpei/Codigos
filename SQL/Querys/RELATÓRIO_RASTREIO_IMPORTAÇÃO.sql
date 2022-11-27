SELECT DISTINCT
     l1.invoice_number                                      "1-INVOICE_A01"
    ,l1.etd                                                 "1.1-DATA_REC_A01"
    ,pha.segment1                                           "2-EBS_PO_NUMBER"
    ,pha.attribute1                                         "2.1-INVOICE_NUMBER_PO"
    ,pha.creation_date                                      "2.2-DATA_CRIAÇÃO_PO"
    ,pha.authorization_status                               "2.3-STATUS_PO"
    ,io.num_ordem                                           "3-OSGT_PO_NUMBER"
    ,fi.num_invoice                                         "4-OSGT_INVOICE_NUMBER"
    ,fi.data                                                "4.1-DATA_CRIAÇÃO_FATURA"
    ,(select    max(afi.data_alteracao) 
      from      triskmb.alteracoes_fatura_importacao afi
      where     fi.id_invoice= afi.id_invoice)              "4.2-DATA_ALTERAÇÃO_FATURA"
    ,fi.cod_via_transporte                                  "4.3-MODALIDAE"
    ,pi.cod_processo                                        "5-CODIGO_PROCESSO"
    ,pi.house                                               "5.1-NUM_CONHECIMENTO"
    ,pi.data_criacao                                        "5.2-DATA_CRIACAO_PROCESSO"
    ,pi.data_conhecimento                                   "5.3-DATA_CONHECIMENTO"
    ,pi.id_area                                             "5.4-AREA"
    ,fi.data_envio_oracle_ap                                "6-DATA_ENVIO_ORACLE_AP"
    ,aii.invoice_num                                        "7-INVOICE_NUMBER_AP"
    ,aii.invoice_id
    ,to_char(aii.creation_date,'dd/mm/yyyy hh:mm')          "7.1-DATA_ENTRADA_AP"
    ,aii.status                                             "7.2-STATUS_INVOICE_AP"
    ,(select distinct listagg(air.reject_lookup_code) within group(order by air.parent_id)
      from apps.ap_interface_rejections@r12dblink.a423710.oraclecloud.internal      air
      left join apps.ap_invoices_interface@r12dblink.a423710.oraclecloud.internal   ai2 on air.parent_id = ai2.invoice_id
      where ai2.invoice_id = aii.invoice_id 
      and   aii.status = 'REJECTED'
      and   ai2.source = 'SOFTWAY'
      and   ai2.status = 'REJECTED')                        "7.3-REJEIÇÃO_CABEÇALHO_AO"
      

FROM
            apps.dtt_po_arq_a01_l1@R12DBLINK.A423710.ORACLECLOUD.INTERNAL          l1
LEFT JOIN   apps.po_headers_all@R12DBLINK.A423710.ORACLECLOUD.INTERNAL             pha      ON  l1.invoice_number = attribute1
LEFT JOIN   triskmb.itens_ordem                                                    io       ON  pha.segment1 = regexp_substr(num_ordem, '[^.]+') 
                                                                                            AND pha.org_id = io.flex_field3
LEFT JOIN   triskmb.ordens_importacao                                              oi       ON  io.num_ordem = oi.num_ordem
LEFT JOIN   triskmb.faturas_importacao                                             fi       ON  oi.nome_cliente = fi.num_invoice
LEFT JOIN   triskmb.processos_importacao                                           pi       ON  fi.cod_processo = pi.cod_processo
LEFT JOIN   apps.ap_invoices_interface@R12DBLINK.A423710.ORACLECLOUD.INTERNAL      aii      ON  fi.num_invoice = regexp_substr(aii.invoice_num,'[^#]+')
                                                                                            AND fi.cod_processo = aii.attribute13
                                                                                            AND aii.source = 'SOFTWAY'
                                                                                            /*AND aii.status = 'REJECTED'*/
                                                                                           

WHERE   l1.etd like '%SET-22%'
AND     decode(pha.cancel_flag, 'N','ATIVO','Y', 'CANCELADO',null,'null') != 'CANCELADO' 

ORDER BY  l1.invoice_number ,l1.etd asc
;