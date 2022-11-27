-- Consulta a Tabela de Notifação    
SELECT
    a.*,
    a.rowid
FROM
    oif_export a
WHERE
        1 = 1
--and id_evento = 5521 -- RI
            AND a.pk_number_01 IN (
        SELECT
            id_notafiscal
        FROM
            bs_nota_fiscal a
        WHERE
                1 = 1
and status in (99999,1)
                                    --AND num_nf IN ( '2258', '2259', '2260', '2313', '2314',
                           -- '2315', '2316', '2323', '2324', '2325',
                            --'2326',
                            --'2327',
                            --'2328',
                            --'2329',
                            --'2330',
                            --'2309')
           -- AND a.serie IN ( 11 )
    )
ORDER BY
    pk_number_01;

-- Verificar se número da nota bate com ID_NOTA 
SELECT
    *
FROM
    bs_nota_fiscal a
WHERE id_notafiscal IN ('3668');

SELECT
    *
FROM
    bs_nota_fiscal a
WHERE DT_EMISSAO LIKE '10/02/21';

-- Update no Status da nota na Tabela de notificação 
update oif_export a
set STATUS ='1' where PK_NUMBER_01 IN ('4064');

-- Update no Status da Nota da Tabela de Notificação usando o número da Nota Fiscal e SERIE
update trcstkmb.oif_export a
   set STATUS = '1'
 where PK_NUMBER_01 IN (select id_notafiscal
                          from trcstkmb.bs_nota_fiscal a
                         where num_nf in ('155')
                           and a.serie in (9));

update oif_export a
set STATUS ='1' where PK_NUMBER_01 IN ('');

---- Consulta a Tabela de Notifação  Pesquisando por status e quantidade de itens
SELECT *FROM oif_export a where pk_number_01 IN ('3567','3568','3645','3646','3647','3648','3660','3661','3662','3657','3658','3639','3656','3638','3640','3641');


select a.id_evento,
       a.pk_number_01,
       z.processo_di as processo,
       z.nfe_sefaz_chave_acesso,
       z.status_nf,
       z.nfe_sefaz_status,
       z.num_nf,
       z.serie,
       a.data_transacao,
       a.status,
       (select COUNT(1)
          from trbskmb.itens_nf a
         where a.id_notafiscal = z.id_notafiscal) as qtd_itens,
       case
         when a.status = 1 then
          'EM ESPERA'
         when a.status = 2 then
          'SUCESSO'
         when a.status = 3 then
          'PROCESSANDO'
         when a.status = 4 then
          'ERRO'
       end as Status

  from oif_export a, bs_nota_fiscal z
 where a.pk_number_01 = z.id_notafiscal
      --and z.serie in (11)
   and a.status  in (99999)
      --and z.num_nf in (178,180,181,182,183)
  --    and a.pk_number_01 in (3638)
   and a.id_evento in (6002, 6106, 6128) --enviar, inutilizar e cancelar
      --, 6106, 6128)
      --and status_nf <> 'Impressa.'
      --and nfe_sefaz_status like '%Liberada%'
      
   and to_char(data_transacao, 'yyyy/mm') = '2021/02'
 order by  z.processo_di ;
