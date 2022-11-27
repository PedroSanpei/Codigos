/* ATUALIZAR INFORMA��ES TELA ESO
ATEN��O!!!! USAR SOMENTE EM CASOS NO QUAL FOI FEITO O FATURAMENTO DA ESO ANTIGA POR�M COM A OC E REQ NOVA.
1� Alterar a orig_sys_document_ref do ESO antiga faturada para a requisi��o atual. Depois fazer a altera��o orig_sys_document_ref
da ESO nova com a requisi��o cancelada (antiga)
*/
SELECT
    *
FROM
    oe_order_headers_all
WHERE
    order_number = '50769'; -- N�mero da ESO nova

UPDATE oe_order_headers_all
SET
    orig_sys_document_ref = '59584'
WHERE
    header_id = '1040099';

UPDATE oe_order_lines_all
SET
    orig_sys_document_ref = '59584'
WHERE
    header_id = '1040099'; 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*2� Alterar na WIP_ASSOCI_DETAIL_OP a REQUISITION_LINE para a Requisi��o na qual foi faturada. Ao Rodar ele ir� pedir o
WIP_ENTITY depois o n�mero da requisi��o antiga e depois a requisi��o nova.
*/
declare
  cursor op_kmb is
    select *
    from apps.dtt_wip_op_assoc_op_detail
    where job_master_id = :ID_OP_KMB;
  --
  l_req_line_id_new    number;
  l_req_line_id_old    number;
  l_req_num_new        varchar2(10);
  l_req_num_old        varchar2(10);
begin
  dbms_output.put_line('Alterando OP KMB ID '||:ID_OP_KMB||' da requisi��o '||:l_req_num_old||' para a requisi��o '||:l_req_num_new);
  for c_op_kmb in op_kmb loop
    select prla.requisition_line_id
    into l_req_line_id_old
    from apps.po_requisition_headers_all prha,
         apps.po_requisition_lines_all   prla
    where prha.segment1 = :l_req_num_old
    and   prla.item_id  = c_op_kmb.assembly_detail_id
    and   prla.requisition_header_id = prha.requisition_header_id;
    --
    select prla.requisition_line_id
    into l_req_line_id_new
    from apps.po_requisition_headers_all prha,
         apps.po_requisition_lines_all   prla
    where prha.segment1 = :l_req_num_new
    and   prla.item_id  = c_op_kmb.assembly_detail_id
    and   prla.requisition_header_id = prha.requisition_header_id;
    --
    update apps.dtt_wip_op_assoc_op_detail
    set requisition_line_id = l_req_line_id_new
    where job_master_id       = c_op_kmb.job_master_id
    and   assembly_detail_id  = c_op_kmb.assembly_detail_id
    and   requisition_line_id = l_req_line_id_old;
    --
    dbms_output.put_line('Alterou REQUISITION_LINE_ID do ASSEMBLY_DETAIL_ID '||c_op_kmb.assembly_detail_id||' de '||l_req_line_id_old||' para '||l_req_line_id_new);
    --
  end loop;
  --
  dbms_output.put_line('===================================================================================================');
  --
  --commit;
end;

