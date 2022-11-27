-- Consulta a Tabela de Notifação    - OSGT
select a.*, a.rowid
from oif_export a
where 1 = 1
--and id_evento = 5521 -- RI
and a.pk_number_01 in
(select id_notafiscal
from bs_nota_fiscal a
where 1 = 1
--and status in (2, 3, 1)
and num_nf in
('1006',
'1007',
'1008',
'1009',
'1010',
'1011',
'1012',
'1013',
'1014',
'1015',
'1016',
'1017',
'1018',
'1019',
'1020',
'1021',
'1022')
and a.serie in (3))
order by pk_number_01;

SELECT * from oif_export where pk_number_01 = '1021' 

