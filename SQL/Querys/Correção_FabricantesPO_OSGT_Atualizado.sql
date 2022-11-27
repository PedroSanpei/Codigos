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
    AND a.num_ordem IN ('18603.145')
    AND c.id_produto = a.cod_peca
    AND a.cod_peca = c.id_produto
    AND d.inventory_item_id = e.inventory_item_id
    AND c.flex_field2 = e.inventory_item_id
    AND d.manufacturer_id = f.manufacturer_id
    AND e.organization_id = '147'
--   and a.num_item in (62053,62054,62055,62056)
 ORDER BY
    a.num_item;
	
	
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
            and a.num_ordem in ('18603.145') ) ---informar os números das POs
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
END;*/
	
