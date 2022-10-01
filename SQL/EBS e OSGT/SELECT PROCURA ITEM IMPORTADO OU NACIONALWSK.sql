-- FILTER ACESSORIES NATIONAL
SELECT
    kmbp.cd_material as part_number,
    kmbuc.item_usage_class as valor_categoria
/*CASE 
WHEN kmbp.COUNTRY_ORIGIN_CD  = 'BRA' THEN 'NATIONAL'
ELSE 'IMPORTED'
END as CATEGORIA_TIPO*/
FROM
    kmtb_parts       kmbp,
    kmtb_usage_code  kmbuc
WHERE
        1 = 1
    AND kmbp.usage_cd = kmbuc.usage_cd;
    --and kmbp.country_origin_cd = 'BRA'
    --and kmbuc.usage_cd = '2'

-- FILTER ACESSORIES IMPORTED
SELECT kmbp.*, kmbuc.item_usage_class,
CASE 
WHEN kmbp.COUNTRY_ORIGIN_CD  = 'BRA' THEN 'NATIONAL'
ELSE 'IMPORTED'
END as CATEGORIA_TIPO
FROM
    kmtb_parts kmbp,kmtb_usage_code kmbuc
    where 1 = 1
    and kmbp.usage_cd = kmbuc.usage_cd
    and kmbp.country_origin_cd != 'BRA'
    and kmbuc.usage_cd = '2';
    
-- FILTER SPARE PARTS NATIONAL
SELECT kmbp.*, kmbuc.item_usage_class,
CASE 
WHEN kmbp.COUNTRY_ORIGIN_CD  = 'BRA' THEN 'NATIONAL'
ELSE 'IMPORTED'
END as CATEGORIA_TIPO
FROM
    kmtb_parts kmbp,kmtb_usage_code kmbuc
    where 1 = 1
    and kmbp.usage_cd = kmbuc.usage_cd
    and kmbp.country_origin_cd = 'BRA'
    and kmbuc.usage_cd = '1';

-- FILTER SPARE PARTS IMPORTED
SELECT kmbp.*, kmbuc.item_usage_class,
CASE 
WHEN kmbp.COUNTRY_ORIGIN_CD  = 'BRA' THEN 'NATIONAL'
ELSE 'IMPORTED'
END as CATEGORIA_TIPO
FROM
    kmtb_parts kmbp,kmtb_usage_code kmbuc
    where 1 = 1
    and kmbp.usage_cd = kmbuc.usage_cd
    and kmbp.country_origin_cd != 'BRA'
    and kmbuc.usage_cd = '1';
