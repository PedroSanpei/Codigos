-- SELECT COMPARA PO FABRICANTE COM ITEM FABRICANTE OSGT 
SELECT
    a.num_ordem,
    c.part_number       AS ITEM_PO,
    a.cod_fabricante    AS COD_FABRICANTE_PO,
    b.nome_fantasia     AS NOME_FABRICANTE_PO,
    d.part_number_parceiro       AS ITEM_CADASTRADO_OSGT,
    f.cod_parceiro      AS COD_FABRICANTE_CADASTRADO_OSGT,
    f.nome_fantasia     AS NOME_FABRICANTE_CADASTRO_OSGT
FROM
    TRISKMB.itens_ordem           a,
    TRISKMB.sfw_parceiro          b,
    TRISKMB.sfw_produto           c,
    TRISKMB.sfw_produto_parceiro  d,
    TRISKMB.sfw_produto           e,
    TRISKMB.sfw_parceiro          f
WHERE
    a.num_ordem IN ('18146.145',
'17790.145',
'18148.145',
'18139.145',
'17237.145',
'2858.155')
    AND a.cod_fabricante = b.cod_parceiro
    AND a.cod_peca = c.id_produto
    AND d.id_produto = e.id_produto
    AND f.id_parceiro = d.id_parceiro
    AND a.cod_peca = d.id_produto
ORDER BY
    a.num_ordem;
    
-- SELECT COMPARATIVO ITENS/FABRICANTE OSGT X EBS
SELECT
    a.num_ordem,
    a.num_item,
    c.part_number                AS item_po,
    a.cod_fabricante             AS cod_fabricante_po,
    d.mfg_part_num               AS item_po_ebs,
    d.manufacturer_id || 'M'     AS cod_fabricante_ebs,
    f.description                AS nome_fabricante_ebs
FROM
    triskmb.itens_ordem                      a,
    triskmb.sfw_produto                     c,
    apps.mtl_system_items_b@R12DBLINK.A423710.ORACLECLOUD.INTERNAL        e,
    apps.mtl_mfg_part_numbers@R12DBLINK.A423710.ORACLECLOUD.INTERNAL      d,
    apps.mtl_manufacturers@R12DBLINK.A423710.ORACLECLOUD.INTERNAL         f
WHERE
        1 = 1
    AND a.num_ordem IN ('18146.145',
'17790.145',
'18148.145',
'18139.145',
'17237.145',
'2858.155')
    AND c.id_produto = a.cod_peca
    AND a.cod_peca = c.id_produto
    AND d.inventory_item_id = e.inventory_item_id
    AND c.flex_field2 = e.inventory_item_id
    AND d.manufacturer_id = f.manufacturer_id
    AND e.organization_id = '147'
--   and a.num_item in (62053,62054,62055,62056)
 ORDER BY
    a.num_item;
    
---------------------Merge correção fabricante na PO------------------------------------
merge into triskmb.itens_ordem "if"
	using
	(SELECT  pp.id_produto
			,p.cod_parceiro AS fabri
		FROM
			trkmb.sfw_produto_parceiro  pp
		inner join
			trkmb.sfw_parceiro p on
				pp.id_parceiro = p.id_parceiro
	) c
		on (c.id_produto = "if".cod_peca
		--and c.fabri != "if".cod_fabricante
		)
	when matched then
		update set
			"if".cod_fabricante = c.fabri
		where
		
		 --@@ ATUALIZACAO POR PO!!! @@
		"if".num_ordem in
		('2727.155')
		
		/*
		-- @@ ATUALIZACAO POR INVOICE!!! @@
		-- por invoice
	"if".flex_field13 in
('KMB-17A-025',
'KMB-14V-053',
'KMB-1RE-030')
--*/;

----correção fabricante na PO OSGT X OGST------------------------------------
DECLARE
BEGIN
  FOR c IN (SELECT distinct PP.ID_PRODUTO, P.COD_PARCEIRO as fabri, io.num_ordem
    FROM SFW_PRODUTO_PARCEIRO PP, SFW_PARCEIRO P, triskmb.itens_ordem io
   WHERE PP.ID_PARCEIRO = P.ID_PARCEIRO
     and PP.ID_PRODUTO = io.cod_peca
     and num_ordem in ('2550.155',
'2553.155',
'2554.155',
'15920.145',
'2583.155',
'2584.155',
'16140.145',
'2540.155',
'2541.155',
'2539.155',
'2538.155',
'16141.145',
'15996.145') ) ---informar os números das POs
  LOOP
    --
    update triskmb.itens_ordem tio
       set tio.cod_fabricante = c.fabri
     where tio.num_ordem =  c.num_ordem 
     and tio.cod_peca = c.id_produto
     and tio.cod_fabricante <> c.fabri;
     commit;
    --
  END LOOP;
END;

-----------------------correçao fabricante OSGT X EBS------------------
DECLARE
BEGIN
  FOR c IN (SELECT 
            c.id_produto,
            D.MANUFACTURER_ID||'M'   AS fabri, 
            a.num_ordem    

        FROM
            TRISKMB.ITENS_ORDEM A,
            TRISKMB.SFW_PRODUTO C,
            APPS.MTL_MFG_PART_NUMBERS@R12DBLINK D,
            APPS.MTL_SYSTEM_ITEMS_B@R12DBLINK E,
            APPS.MTL_MANUFACTURERS@R12DBLINK F
        WHERE
            D.MANUFACTURER_ID = F.MANUFACTURER_ID
            AND D.INVENTORY_ITEM_ID = E.INVENTORY_ITEM_ID
            AND C.FLEX_FIELD2 = E.INVENTORY_ITEM_ID
            AND c.id_produto = a.cod_peca
            AND E.ORGANIZATION_ID = '147'
            and a.num_ordem in ('14565.145') ) ---informar os números das POs
  LOOP
    --
    update triskmb.itens_ordem tio
       set tio.cod_fabricante = c.fabri
     where tio.num_ordem =  c.num_ordem 
     and tio.cod_peca = c.id_produto
     and tio.cod_fabricante <> c.fabri;
     commit;
    --
  END LOOP;
END;


--------------------------------------------------RESPOSTA CHAMADO-----------------------------------------------------------------------
/*Boa Tarde,

 

Fabricante Corrigido usando as seguintes querys. Também segue evidência:

 

- Query de comparativo:

-- SELECT COMPARA PO FABRICANTE COM ITEM FABRICANTE
SELECT
a.num_ordem,
c.part_number AS ITEM_PO,
a.cod_fabricante AS COD_FABRICANTE_PO,
b.nome_fantasia AS NOME_FABRICANTE_PO,
d.part_number_parceiro AS ITEM_CADASTRADO_OSGT,
f.cod_parceiro AS COD_FABRICANTE_CADASTRADO_OSGT,
f.nome_fantasia AS NOME_FABRICANTE_CADASTRO_OSGT
FROM
itens_ordem a,
sfw_parceiro b,
sfw_produto c,
sfw_produto_parceiro d,
sfw_produto e,
sfw_parceiro f
WHERE
a.num_ordem IN ('2181.155',
'2194.155',
'2195.155',
'2196.155',
'13479.145',
'13480.145',
'13481.145')
AND a.cod_fabricante = b.cod_parceiro
AND a.cod_peca = c.id_produto
AND d.id_produto = e.id_produto
AND f.id_parceiro = d.id_parceiro
AND a.cod_peca = d.id_produto
ORDER BY
a.num_ordem;

 

- Query de correção

merge into triskmb.itens_ordem "if"
using
(SELECT pp.id_produto
,p.cod_parceiro AS fabri
FROM
trkmb.sfw_produto_parceiro pp
inner join
trkmb.sfw_parceiro p on
pp.id_parceiro = p.id_parceiro
) c
on (c.id_produto = "if".cod_peca
--and c.fabri != "if".cod_fabricante
)
when matched then
update set
"if".cod_fabricante = c.fabri
where

--@@ ATUALIZACAO POR PO!!! @@
"if".num_ordem in
('2181.155',
'2194.155',
'2195.155',
'2196.155',
'13479.145',
'13480.145',
'13481.145')

/*
-- @@ ATUALIZACAO POR INVOICE!!! @@
-- por invoice
"if".flex_field13 in
('KMB-17A-025',
'KMB-14V-053',
'KMB-1RE-030')
--*/
