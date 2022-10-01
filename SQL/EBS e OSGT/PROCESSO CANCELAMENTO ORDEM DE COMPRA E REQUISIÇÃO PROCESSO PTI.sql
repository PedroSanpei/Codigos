--PROCESSO CANCELAMENTO ORDEM DE COMPRA E REQUISIÇÃO PROCESSO PTI
1º - select requisition_line_id,line_location_id from po_requisition_lines_all where requisition_header_id = '840130'; -- LINE LOCATION NULO
2º-select * from po_req_distributions_all where requisition_line_id in ('949304','949305'); -- PEGAR O DISTRIBUITION_ID
3º- select * from po_distributions_all where req_distribution_id in(951218,951219); -- PEGAR O LINE_LOCATION_ID E FAZER UM UPDATE NA LINES

-- UPDATE PARA ATUALIZAR O LINE_LOCATION de acordo com o line_location do po_distributions_all
/*update po_requisition_lines_all
set line_location_id = '2794941'
where requisition_line_id = '907193';*/

SELECT 
    a.segment1,
    b.requisition_line_id,
    b.line_location_id LINE_LOCATION_ID_REQ,
    d.line_location_id,
    'UPDATE po_requisition_lines_all set line_location_id = '||d.line_location_id||' where requisition_line_id = ' ||b.requisition_line_id||';' CONCATENADO
FROM
    po_requisition_headers_all  a,
    po_requisition_lines_all    b,
    po_req_distributions_all c,
    po_distributions_all d
where
a.requisition_header_id = b.requisition_header_id
AND b.requisition_line_id = c.requisition_line_id
AND c.distribution_id = d.req_distribution_id
AND a.segment1 in ('61063',
'61064',
'61066',
'61067',
'61068',
'61073',
'61074',
'61075',
'61076',
'61077',
'61081',
'61084',
'61090',
'61099',
'61100',
'61102',
'61103',
'61104',
'61107',
'61106',
'61116',
'61112',
'61115',
'61117',
'61118',
'61119',
'61122',
'61123',
'61124',
'61125',
'61126',
'61127',
'61129'
) -- número da requisição
;

UPDATE po_requisition_lines_all set line_location_id = 3748096 where requisition_line_id = 955849;
UPDATE po_requisition_lines_all set line_location_id = 3748097 where requisition_line_id = 955640;
UPDATE po_requisition_lines_all set line_location_id = 3748098 where requisition_line_id = 955641;
UPDATE po_requisition_lines_all set line_location_id = 3748099 where requisition_line_id = 955642;
UPDATE po_requisition_lines_all set line_location_id = 3748100 where requisition_line_id = 955635;
UPDATE po_requisition_lines_all set line_location_id = 3748106 where requisition_line_id = 955644;
UPDATE po_requisition_lines_all set line_location_id = 3748107 where requisition_line_id = 955692;
UPDATE po_requisition_lines_all set line_location_id = 3748108 where requisition_line_id = 955696;
UPDATE po_requisition_lines_all set line_location_id = 3748109 where requisition_line_id = 955697;
UPDATE po_requisition_lines_all set line_location_id = 3748110 where requisition_line_id = 955695;
UPDATE po_requisition_lines_all set line_location_id = 3748116 where requisition_line_id = 955701;
UPDATE po_requisition_lines_all set line_location_id = 3748117 where requisition_line_id = 955702;
UPDATE po_requisition_lines_all set line_location_id = 3748118 where requisition_line_id = 955707;
UPDATE po_requisition_lines_all set line_location_id = 3748122 where requisition_line_id = 955712;
UPDATE po_requisition_lines_all set line_location_id = 3748123 where requisition_line_id = 955713;
UPDATE po_requisition_lines_all set line_location_id = 3748124 where requisition_line_id = 955717;
UPDATE po_requisition_lines_all set line_location_id = 3748128 where requisition_line_id = 955730;
UPDATE po_requisition_lines_all set line_location_id = 3748129 where requisition_line_id = 955731;
UPDATE po_requisition_lines_all set line_location_id = 3748130 where requisition_line_id = 955737;
UPDATE po_requisition_lines_all set line_location_id = 3748164 where requisition_line_id = 955802;
UPDATE po_requisition_lines_all set line_location_id = 3748165 where requisition_line_id = 955800;
UPDATE po_requisition_lines_all set line_location_id = 3748166 where requisition_line_id = 955808;
UPDATE po_requisition_lines_all set line_location_id = 3748169 where requisition_line_id = 955801;
UPDATE po_requisition_lines_all set line_location_id = 3748170 where requisition_line_id = 955807;
UPDATE po_requisition_lines_all set line_location_id = 3748173 where requisition_line_id = 955811;
UPDATE po_requisition_lines_all set line_location_id = 3748174 where requisition_line_id = 955815;
UPDATE po_requisition_lines_all set line_location_id = 3748178 where requisition_line_id = 955835;
UPDATE po_requisition_lines_all set line_location_id = 3748179 where requisition_line_id = 955834;
UPDATE po_requisition_lines_all set line_location_id = 3748180 where requisition_line_id = 955838;
UPDATE po_requisition_lines_all set line_location_id = 3748183 where requisition_line_id = 955836;
UPDATE po_requisition_lines_all set line_location_id = 3748184 where requisition_line_id = 955837;
UPDATE po_requisition_lines_all set line_location_id = 3748205 where requisition_line_id = 955711;
UPDATE po_requisition_lines_all set line_location_id = 3748206 where requisition_line_id = 955710;
UPDATE po_requisition_lines_all set line_location_id = 3748225 where requisition_line_id = 955844;
UPDATE po_requisition_lines_all set line_location_id = 3748226 where requisition_line_id = 955843;
UPDATE po_requisition_lines_all set line_location_id = 3748258 where requisition_line_id = 955724;
UPDATE po_requisition_lines_all set line_location_id = 3748259 where requisition_line_id = 955725;
UPDATE po_requisition_lines_all set line_location_id = 3748260 where requisition_line_id = 955727;
UPDATE po_requisition_lines_all set line_location_id = 3748310 where requisition_line_id = 955693;
UPDATE po_requisition_lines_all set line_location_id = 3748311 where requisition_line_id = 955694;
UPDATE po_requisition_lines_all set line_location_id = 3748312 where requisition_line_id = 955698;
UPDATE po_requisition_lines_all set line_location_id = 3748318 where requisition_line_id = 955728;
UPDATE po_requisition_lines_all set line_location_id = 3748319 where requisition_line_id = 955732;
UPDATE po_requisition_lines_all set line_location_id = 3748320 where requisition_line_id = 955736;
UPDATE po_requisition_lines_all set line_location_id = 3748321 where requisition_line_id = 955735;
UPDATE po_requisition_lines_all set line_location_id = 3748322 where requisition_line_id = 955734;
UPDATE po_requisition_lines_all set line_location_id = 3748332 where requisition_line_id = 955820;
UPDATE po_requisition_lines_all set line_location_id = 3748333 where requisition_line_id = 955823;
UPDATE po_requisition_lines_all set line_location_id = 3748334 where requisition_line_id = 955825;
UPDATE po_requisition_lines_all set line_location_id = 3748335 where requisition_line_id = 955824;
UPDATE po_requisition_lines_all set line_location_id = 3748336 where requisition_line_id = 955822;
UPDATE po_requisition_lines_all set line_location_id = 3748340 where requisition_line_id = 955826;
UPDATE po_requisition_lines_all set line_location_id = 3748341 where requisition_line_id = 955821;
UPDATE po_requisition_lines_all set line_location_id = 3748345 where requisition_line_id = 955638;
UPDATE po_requisition_lines_all set line_location_id = 3748346 where requisition_line_id = 955639;
UPDATE po_requisition_lines_all set line_location_id = 3748347 where requisition_line_id = 955643;
UPDATE po_requisition_lines_all set line_location_id = 3748352 where requisition_line_id = 955700;
UPDATE po_requisition_lines_all set line_location_id = 3748353 where requisition_line_id = 955691;
UPDATE po_requisition_lines_all set line_location_id = 3748359 where requisition_line_id = 955718;
UPDATE po_requisition_lines_all set line_location_id = 3748360 where requisition_line_id = 955722;
UPDATE po_requisition_lines_all set line_location_id = 3748361 where requisition_line_id = 955720;
UPDATE po_requisition_lines_all set line_location_id = 3748362 where requisition_line_id = 955723;
UPDATE po_requisition_lines_all set line_location_id = 3748363 where requisition_line_id = 955721;
UPDATE po_requisition_lines_all set line_location_id = 3748397 where requisition_line_id = 955699;
UPDATE po_requisition_lines_all set line_location_id = 3748398 where requisition_line_id = 955704;
UPDATE po_requisition_lines_all set line_location_id = 3748399 where requisition_line_id = 955705;
UPDATE po_requisition_lines_all set line_location_id = 3748400 where requisition_line_id = 955706;
UPDATE po_requisition_lines_all set line_location_id = 3748401 where requisition_line_id = 955703;
UPDATE po_requisition_lines_all set line_location_id = 3748419 where requisition_line_id = 955809;
UPDATE po_requisition_lines_all set line_location_id = 3748420 where requisition_line_id = 955817;
UPDATE po_requisition_lines_all set line_location_id = 3748421 where requisition_line_id = 955814;
UPDATE po_requisition_lines_all set line_location_id = 3748422 where requisition_line_id = 955812;
UPDATE po_requisition_lines_all set line_location_id = 3748423 where requisition_line_id = 955816;
UPDATE po_requisition_lines_all set line_location_id = 3748427 where requisition_line_id = 955810;
UPDATE po_requisition_lines_all set line_location_id = 3748428 where requisition_line_id = 955813;
UPDATE po_requisition_lines_all set line_location_id = 3748429 where requisition_line_id = 955819;
UPDATE po_requisition_lines_all set line_location_id = 3748435 where requisition_line_id = 955828;
UPDATE po_requisition_lines_all set line_location_id = 3748436 where requisition_line_id = 955830;
UPDATE po_requisition_lines_all set line_location_id = 3748437 where requisition_line_id = 955832;
UPDATE po_requisition_lines_all set line_location_id = 3748438 where requisition_line_id = 955831;
UPDATE po_requisition_lines_all set line_location_id = 3748439 where requisition_line_id = 955829;
UPDATE po_requisition_lines_all set line_location_id = 3748445 where requisition_line_id = 955839;
UPDATE po_requisition_lines_all set line_location_id = 3748446 where requisition_line_id = 955846;
UPDATE po_requisition_lines_all set line_location_id = 3748447 where requisition_line_id = 955841;
UPDATE po_requisition_lines_all set line_location_id = 3748448 where requisition_line_id = 955847;
UPDATE po_requisition_lines_all set line_location_id = 3748449 where requisition_line_id = 955842;
UPDATE po_requisition_lines_all set line_location_id = 3748452 where requisition_line_id = 955645;
UPDATE po_requisition_lines_all set line_location_id = 3748453 where requisition_line_id = 955646;
UPDATE po_requisition_lines_all set line_location_id = 3748466 where requisition_line_id = 955719;
UPDATE po_requisition_lines_all set line_location_id = 3748467 where requisition_line_id = 955726;
UPDATE po_requisition_lines_all set line_location_id = 3748470 where requisition_line_id = 955729;
UPDATE po_requisition_lines_all set line_location_id = 3748471 where requisition_line_id = 955733;
UPDATE po_requisition_lines_all set line_location_id = 3748477 where requisition_line_id = 955799;
UPDATE po_requisition_lines_all set line_location_id = 3748478 where requisition_line_id = 955805;
UPDATE po_requisition_lines_all set line_location_id = 3748479 where requisition_line_id = 955803;
UPDATE po_requisition_lines_all set line_location_id = 3748480 where requisition_line_id = 955804;
UPDATE po_requisition_lines_all set line_location_id = 3748481 where requisition_line_id = 955806;
UPDATE po_requisition_lines_all set line_location_id = 3748485 where requisition_line_id = 955833;
UPDATE po_requisition_lines_all set line_location_id = 3748486 where requisition_line_id = 955818;
UPDATE po_requisition_lines_all set line_location_id = 3748487 where requisition_line_id = 955827;
UPDATE po_requisition_lines_all set line_location_id = 3748491 where requisition_line_id = 955840;
UPDATE po_requisition_lines_all set line_location_id = 3748492 where requisition_line_id = 955845;
UPDATE po_requisition_lines_all set line_location_id = 3748493 where requisition_line_id = 955848;
UPDATE po_requisition_lines_all set line_location_id = 3748496 where requisition_line_id = 955637;
UPDATE po_requisition_lines_all set line_location_id = 3748497 where requisition_line_id = 955636;
UPDATE po_requisition_lines_all set line_location_id = 3748505 where requisition_line_id = 955708;
UPDATE po_requisition_lines_all set line_location_id = 3748506 where requisition_line_id = 955709;
UPDATE po_requisition_lines_all set line_location_id = 3748507 where requisition_line_id = 955715;
UPDATE po_requisition_lines_all set line_location_id = 3748508 where requisition_line_id = 955716;
UPDATE po_requisition_lines_all set line_location_id = 3748509 where requisition_line_id = 955714;



    