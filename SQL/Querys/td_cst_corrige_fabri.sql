CREATE OR REPLACE TRIGGER td_cst_corrige_fabri
BEFORE INSERT OR UPDATE ON TRISKMB.ITENS_ORDEM
FOR EACH ROW
DECLARE
v_fabricante VARCHAR2(20);
--
BEGIN
-- Busca o fabricante correto de acordo com o cadastro do OSGT
SELECT
    D.manufacturer_id||'M'   AS COD_FABRICANTE_EBS
    
INTO v_fabricante

FROM
    TRISKMB.SFW_PRODUTO           C,
    APPS.MTL_MFG_PART_NUMBERS@R12DBLINK.A423710.ORACLECLOUD.INTERNAL D,
    APPS.MTL_SYSTEM_ITEMS_B@R12DBLINK.A423710.ORACLECLOUD.INTERNAL E,
    APPS.MTL_MANUFACTURERS@R12DBLINK.A423710.ORACLECLOUD.INTERNAL F
WHERE
     C.PART_NUMBER = E.SEGMENT1
    AND D.mfg_part_num = E.segment1
    AND D.manufacturer_id = F.manufacturer_id
    --AND E.ORGANIZATION_ID = '147'
;
--
-- Verifica se o cadastro do fabricante esta incorreto
IF ( v_fabricante != :new.cod_fabricante ) THEN
-- Salva uma copia das informacoes da tabela antes de atualizar
INSERT INTO cst_itens_ordem_log VALUES (
:new.num_ordem,
:new.cod_peca,
:new.num_item,
:new.cod_fornecedor,
:new.cod_fabricante,
:new.flex_field13,
v_fabricante,
sysdate
);
--
-- Atualiza fabricante
:new.cod_fabricante := v_fabricante;
--
END IF;
 EXCEPTION

    WHEN OTHERS THEN
        insert into cst_itens_ordem_erro_log values(
	:new.num_ordem,
	:new.cod_peca,
	:new.num_item,
	:new.cod_fornecedor,
	:new.cod_fabricante,
	:new.flex_field13,
	SQLCODE);
END;