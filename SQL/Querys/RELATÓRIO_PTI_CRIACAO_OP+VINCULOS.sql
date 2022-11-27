--- RELATÓRIO WIP RASTREAMENTO OP KMB, REQ KMB, OC KMB e OP KCA
--- !!!LEMBRANDO QUE É APENAS PARA ORDENS CRIADAS E NÃO CONCLUÍDAS!!!
select distinct
    e.wip_entity_name    num_op_kmb,
    e.model_item         modelo,
    d.segment1           subconjunto,
    e.dt_producao DT_PRODUCAO,
    e.creation_date DT_CRIAÇÃO,
    c.segment1           num_rec_kmb,
    b.quantity,
    b.unit_price         price_rec,
    f.segment1           num_oc_kmb,
    k.unit_price         price_oc,
    g.order_number       num_ov_kca,
    j.wip_entity_name    num_op_kca
from
    dtt_wip_op_assoc_op_detail  a,
    po_requisition_lines_all    b,
    po_requisition_headers_all  c,
    mtl_system_items_b          d,
    dtt_wip_programacao_op_v    e,
    po_headers_all              f,
    oe_order_headers_all        g,
    oe_order_lines_all          h,
    wip_reservations_v          i,
    wip_entities                j,
    po_lines_all                k
where
    a.requisition_line_id = b.requisition_line_id
    and b.requisition_header_id = c.requisition_header_id
    and b.item_id = d.inventory_item_id
   -- and e.wip_entity_name in ( '340664' ) -- PESQUISAR PELA OP KMB
    and e.dt_producao BETWEEN '01-ABR-2022' AND '04-ABR-2022' -- PESQUISAR PELA DATA
    and d.organization_id = '149'
    and a.job_master_id = e.wip_entity_id -- VINCULO OP KMB
    and f.interface_source_code = c.segment1 -- VINCULO REQUISIÇÃO COM ORDEM DE COMPRA
    and nvl(g.orig_sys_document_ref,'nulo') = c.segment1 -- VINCULO REQUISIÇÃO COM ORDEM DE VENDA
    and h.header_id = g.header_id
    and h.line_id = i.demand_source_line_id
    and i.wip_entity_id  = j.wip_entity_id
    and i.inventory_item_id = d.inventory_item_id
    and k.item_id = d.inventory_item_id
    and f.po_header_id = k.po_header_id
    ORDER BY 
    e.wip_entity_name; 