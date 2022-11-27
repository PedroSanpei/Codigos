select 
    'SET-22' AS TRANSITO,   
    A.*,
    B.invoice_num,
    B.CREATION_DATE DATA_ENTRADA_INTERFACE,
    nvl(B.STATUS,'Não Processado') AS STATUS_AP
from
    (select
        NUM_INVOICE,
        DT_INVOICE,
        nu_conhecimento,
        DATA_CONHECIMENTO,
        COD_PROCESSO,
        DT_CRIACAO_PROC,
        DT_CRIACAO_FATURA,
        ID_AREA,
        MODAL,
        PO,
        PO_HEADER_ID,
        DT_CRIACAO_PO,
        NUM_DI,
        DATA_REGISTRO_DI,
        NF_EMITIDA,
        '03_PO_EBS/PO_OSGT' as source
            
     from trcstkmb.v_is_acomp_processos_cst@k2osgt_trkmb ap
     where ap.num_invoice in (
                                select DISTINCT L1.invoice_number
                                from apps.DTT_PO_ARQ_A01_L1@k2prd L1
                                where ETD LIKE  '%SET-22'
                             )
     union
     select
        a.attribute1    as NUM_INVOICE,
        null            as DT_INVOICE,
        null            as nu_conhecimento,
        null            as DATA_CONHECIMENTO,
        null            as COD_PROCESSO,
        null            as DT_CRIACAO_PROC,
        null            as DT_CRIACAO_FATURA,
        null            as ID_AREA,
        null            as MODAL,
        a.SEGMENT1      as PO,
        to_char(a.PO_HEADER_ID) as PO_HEADER_ID,
        a.CREATION_DATE as DT_CRIACAO_PO,
        null            as NUM_DI,
        null            as DATA_REGISTRO_DI,
        null            as NF_EMITIDA,
        '02_PO_EBS'  as ORIGEM
     from apps.po_headers_all@k2prd a, apps.fnd_user@k2prd b
     Where 1 = 1
     and a.CREATED_BY = b.USER_ID
     and a.CANCEL_FLAG = 'N'
     and ATTRIBUTE1 in      (
                                select DISTINCT L1.invoice_number
                                from apps.DTT_PO_ARQ_A01_L1@k2prd L1
                                where ETD LIKE '%SET-22'
                              )
       and a.PO_HEADER_ID not in
                             (
                                select PO_HEADER_ID
                                from trcstkmb.v_is_acomp_processos_cst@k2osgt_trkmb ap
                                where ap.num_invoice in
                                                       (
                                                            select DISTINCT L1.invoice_number
                                                            from apps.DTT_PO_ARQ_A01_L1@k2prd L1
                                                            where ETD LIKE '%SET-22'
                                                        )
                              )
     union
     select distinct
        L1.invoice_number as NUM_INVOICE,
        null as DT_INVOICE,
        null as nu_conhecimento,
        null as DATA_CONHECIMENTO,
        null as COD_PROCESSO,
        null as DT_CRIACAO_PROC,
        null as DT_CRIACAO_FATURA,
        null as ID_AREA,
        null as MODAL,
        null as PO,
        null as PO_HEADER_ID,
        null as DT_CRIACAO_PO,
        null as NUM_DI,
        null as DATA_REGISTRO_DI,
        null as NF_EMITIDA,
        '01_A01' as source
     from apps.DTT_PO_ARQ_A01_L1@k2prd L1
     where ETD LIKE '%SET-22'
     and L1.invoice_number not in
                             (
                                select a.attribute1
                                from apps.po_headers_all@k2prd a, apps.fnd_user@k2prd b
                                Where 1 = 1
                                and a.CREATED_BY = b.USER_ID
                                and a.CANCEL_FLAG = 'N'
                                and ATTRIBUTE1 in      (
                                                            select DISTINCT L1.invoice_number
                                                            from apps.DTT_PO_ARQ_A01_L1@k2prd L1
                                                            where ETD LIKE '%SET-22'
                                                        )
                             )
     union
     select distinct 
        a.attribute1    as NUM_INVOICE,
        null            as DT_INVOICE,
        null            as nu_conhecimento,
        null            as DATA_CONHECIMENTO,
        null            as COD_PROCESSO,
        null            as DT_CRIACAO_PROC,
        null            as DT_CRIACAO_FATURA,
        null            as ID_AREA,
        null            as MODAL,
        a.SEGMENT1      as PO,
        to_char(a.PO_HEADER_ID) as PO_HEADER_ID,
        a.CREATION_DATE as DT_CRIACAO_PO,
        null            as NUM_DI,
        null            as DATA_REGISTRO_DI,
        null            as NF_EMITIDA,
        '02_PO_EBS_SEM_A01'  as ORIGEM
     from apps.po_headers_all@k2prd a,
          (
                select pv.vendor_id,
                pvsa.vendor_site_id,
                pv.vendor_name      as fornecedor,
                pv.vendor_name_alt  as nome_fantasia,
                pvsa.state
                FROM apps.po_vendors@k2prd pv, apps.po_vendor_sites_all@k2prd pvsa
                 where pv.vendor_id = pvsa.vendor_id
          ) b,
          apps.po_line_locations_all@k2prd c,
          apps.fnd_user@k2prd d,
          HR.HR_LOCATIONS_ALL@k2prd e
     Where 1 = 1
     and a.VENDOR_ID = b.vendor_id
     and a.vendor_site_id = b.vendor_site_id
     and a.PO_HEADER_ID = c.PO_HEADER_ID
     and a.CREATED_BY = d.USER_ID
     and a.SHIP_TO_LOCATION_ID = e.location_id
     and  a.INTERFACE_SOURCE_CODE IS NULL
     and e.location_code in    ('KMB_AD_AM_001', 'KCA_AD_AM_006', 'KMB_AD_AM_003')
     and b.state = 'EX'
     and to_char(a.creation_date, 'YYYY/MM') = '2022/09'
     and a.PO_HEADER_ID not in
                              (
                                    select PO_HEADER_ID
                                    from trcstkmb.v_is_acomp_processos_cst@k2osgt_trkmb ap
                                    where to_char(ap.dt_criacao_po, 'YYYY/MM') =  '2022/09'
                              )
                
     union
     select distinct 
        NUM_INVOICE,
        DT_INVOICE,
        nu_conhecimento,
        DATA_CONHECIMENTO,
        COD_PROCESSO,
        DT_CRIACAO_PROC,
        DT_CRIACAO_FATURA,
        ID_AREA,
        MODAL,
        PO,
        AP.PO_HEADER_ID,
        DT_CRIACAO_PO,
        NUM_DI,
        DATA_REGISTRO_DI,
        NF_EMITIDA,
        '03_PO_EBS/PO_OSGT_SEM_A01' as source
     from   apps.po_headers_all@k2prd a,
            (
                select pv.vendor_id,
                pvsa.vendor_site_id,
                pv.vendor_name      as fornecedor,
                pv.vendor_name_alt  as nome_fantasia,
                pvsa.state
                from apps.po_vendors@k2prd pv, apps.po_vendor_sites_all@k2prd pvsa
                where pv.vendor_id = pvsa.vendor_id
            ) b,
            apps.po_line_locations_all@k2prd c,
            apps.fnd_user@k2prd d,
            HR.HR_LOCATIONS_ALL@k2prd e,
            trcstkmb.v_is_acomp_processos_cst@k2osgt_trkmb ap
     Where 1 = 1
     and a.VENDOR_ID = b.vendor_id
     and a.vendor_site_id = b.vendor_site_id
     and a.PO_HEADER_ID = c.PO_HEADER_ID
     and a.CREATED_BY = d.USER_ID
     and a.SHIP_TO_LOCATION_ID = e.location_id
     and  a.INTERFACE_SOURCE_CODE IS NULL
     and a.PO_HEADER_ID = ap.PO_HEADER_ID
     and e.location_code in    ('KMB_AD_AM_001', 'KCA_AD_AM_006', 'KMB_AD_AM_003')
     and b.state = 'EX'
     and to_char(a.creation_date, 'YYYY/MM') = '2022/09'
     and to_char(ap.dt_criacao_po, 'YYYY/MM') = '2022/09'
    ) A
LEFT JOIN apps.ap_invoices_interface@k2prd B ON a.num_invoice = regexp_substr(b.invoice_num,'[^#]+') and a.cod_processo = b.attribute13
/*WHERE 
A.NUM_INVOICE = '4KD-220709'*/
order by a.source, a.data_conhecimento, a.data_registro_di, nf_emitida;


select * from apps.ap_invoices_interface@k2prd