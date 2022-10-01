--CHECK_PROCESSO_PLANO PRODU��O.XLSX
SELECT 
a.wip_entity_name OP_KMB,
a.cd_item MODELO,
c.segment1 OP_ITENS,
a.dt_producao,
a.creation_date DT_CRIA��O,
f.segment1 REQ_KMB,
e.segment1 REQ_ITENS,
g.segment1 OC_KMB,
h.order_number OV_KCA,
k.wip_entity_name OP_KCA,
nvl(l.STATUS_TYPE_DISP,'Conclu�do') STATUS_OP_KCA

FROM 
dtt_wip_programacao_op_v a
JOIN dtt_wip_op_assoc_op_detail b ON a.wip_entity_id = b.job_master_id -- VINCULO PLANO WIP COM ASSOCIA��O WIP
JOIN mtl_system_items_b c ON b.assembly_detail_id = c.inventory_item_id -- VINCULO DO ITEM OP COM MTL_SYSTEM

LEFT JOIN po_requisition_lines_all d ON b.requisition_line_id = d.requisition_line_id -- VINCULO DA ASSOCIA��O WIP COM AS LINHAS DA REQUISI��O
JOIN mtl_system_items_b  e ON d.item_id = e.inventory_item_id -- VINCULO DO ITEM REQ COM MTL_SYSTEM
JOIN po_requisition_headers_all f ON d.requisition_header_id = f.requisition_header_id -- VINCULO REQ LINHA COM HEADER

LEFT JOIN po_headers_all g ON f.segment1 = g.interface_source_code -- VINCULO REQ COM OC

LEFT JOIN oe_order_headers_all h ON f.segment1 = h.orig_sys_document_ref -- VINCULO OV com REQUISI��O
JOIN oe_order_lines_all i ON h.header_id = i.header_id

LEFT JOIN wip_reservations_v j ON i.line_id = j.demand_source_line_id 
LEFT JOIN wip_entities k ON j.wip_entity_id = k.wip_entity_id
LEFT JOIN WIP_DISCRETE_JOBS_V l on k.wip_entity_id = l.wip_entity_id
WHERE 
             c.organization_id = '149'
AND     e.organization_id = '149'
AND     i.inventory_item_id = d.item_id
--AND     a.wip_entity_name = '340929'
AND  a.creation_date BETWEEN '06/04/2022' AND '07/04/2022'
