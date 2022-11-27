--CHECK_PROCESSO_PLANO PRODU플O.XLSX
SELECT 
a.wip_entity_id,
a.wip_entity_name OP_KMB,
a.cd_item MODELO,
a.nr_chassi,
e.segment1 ITENS,
--c.segment1 OP_ITENS,
a.dt_producao,
a.creation_date DT_CRIA플O,
d.segment1 REQ_KMB,
--d.creation_date,
d.authorization_status,
substr(d.description,28,3) TIPO_ORDEM,
g.segment1 OC_KMB,
h.order_number OV_KCA,
h.flow_status_code,
l.wip_entity_name OP_KCA,
m.meaning STATUS_OP_KCA

FROM 
dtt_wip_programacao_op_v a

LEFT JOIN po_requisition_headers_all d ON a.nr_chassi = d.attribute2 -- VINCULO DA ASSOCIA플O WIP COM AS LINHAS DA REQUISI플O
JOIN po_requisition_lines_all f ON d.requisition_header_id = f.requisition_header_id -- VINCULO REQ LINHA COM HEADER
JOIN mtl_system_items_b  e ON f.item_id = e.inventory_item_id -- VINCULO DO ITEM REQ COM MTL_SYSTEM

LEFT JOIN po_headers_all g ON d.segment1 = g.interface_source_code -- VINCULO REQ COM OC

LEFT JOIN oe_order_headers_all h ON d.segment1 = h.orig_sys_document_ref -- VINCULO OV com REQUISI플O
JOIN oe_order_lines_all i ON h.header_id = i.header_id
LEFT JOIN WIP_DISCRETE_JOBS k on i.line_id = k.source_line_id
JOIN fnd_lookup_values_vl m ON to_char(k.status_type) = m.lookup_code
LEFT JOIN wip_entities l ON k.wip_entity_id = l.wip_entity_id

WHERE 
             a.organization_id = '149'
AND     e.organization_id = '149'
AND     i.inventory_item_id = f.item_id
/*AND     a.wip_entity_name in ('350893',
'350894',
'350895',
'350896',
'350897',
'350898',
'350899',
'350900',
'350901',
'350902',
'350903')*/
--AND  a.creation_date BETWEEN '07/04/2022' AND '08/04/2022'
AND  a.dt_producao BETWEEN '07/06/2022' AND '09/06/2022'
AND m.lookup_type            = 'WIP_JOB_STATUS'
and    d.authorization_status = 'APPROVED'
and a.cd_item = 'LE650H-B3A1 VERDE'
ORDER BY a.wip_entity_name;

select * from oe_order_headers_all where order_number = '44378';
select * from dtt_wip_op_assoc_op_detail where job_master_id = '375846'