
SELECT
    fi.num_invoice          A_NUM_FATURA,
    fi.cod_processo         A_COD_PROCESSO,
    sp.part_number          B_PART_NUMBER,
    sp.descricao_resumida   B_DESCRICAO_PART_NUMBER,
    ifi.qtde                C_QUANTIDADE,
    ifi.preco               C_PRECO,
    ifi.peso_liquido        C_PESO_LIQUIDO,
    ifi.cod_fabricante      C_COD_FABRICANTE,
    spe.nome_fantasia       D_NOME_FABRICANTE,
    ifi.hts                 C_NCM,
    d.num_di                D_NUM_DI,
    to_char(d.data_registro_di,'DD/MM/YYYY')      D_DATA_REGISTRO,
    sdns.DESCRICAO          DESTAQUE_SUFRAMA,
    sp.descricao_detalhada  DESCRICAO_DETALHADA
FROM
        triskmb.faturas_importacao fi
JOIN    triskmb.itens_fatura_importacao ifi ON fi.id_invoice = ifi.id_invoice
JOIN    triskmb.sfw_produto sp ON ifi.cod_peca = sp.id_produto
JOIN    triskmb.sfw_produto_parceiro spp ON sp.id_produto = spp.id_produto
JOIN    triskmb.sfw_parceiro spe ON spp.id_parceiro = spe.id_parceiro
JOIN trbskmb.di  d ON fi.cod_processo = d.processo_di
JOIN    triskmb.sfw_detalhe_ncm_suframa sdns ON sp.ID_DETALHE_SUFRAMA = sdns.id_detalhe_suframa
WHERE
sp.part_number like '26012%'
ORDER BY fi.data desc