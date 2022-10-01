SELECT * FROM APPS.PO_HEADERS_ALL WHERE SEGMENT1 = '11040';
SELECT * FROM APPS.PO_ACTION_HISTORY WHERE OBJECT_TYPE_CODE = 'PO' AND OBJECT_ID = '1001191';
SELECT * FROM APPS.po_agents_v where agent_id = '127';
select * from apps.per_person_types;
select * from apps.per_all_people_f where PERSON_ID = '801' ;
select * from apps.hr_locations_all_tl;
select * from apps.per_all_assignments_f where assignment_id = '861';
SELECT * FROM ALL_TABLES WHERE OWNER ='PO';
SELECT * FROM APPS.PO_ACTION_HISTORY where object_id = '1001191';
/*
-- Tabela PO_HEADERS_ALL
SEGMENT1 -- Nº PO
COMMENTS -- Descrição
CREATION_DATE -- Data de Criação
CREATED_BY  -- Responsável pela criação da PO

-- Tabela PO_ACTION_HISTORY
ACTION_CODE -- ACTION_CODE = 'SUBMIT'
OBJECT_ID -- PO_HEADER_ID = OBJETC_ID
EMPLOYEE_ID -- AGENT_ID = EMPLOYEE_ID
*/

-- SELECT NECESSÁRIO PARA CRIAR O ALERT AVISO VALIDATION RI
SELECT DISTINCT
    pha.SEGMENT1 as PO_NUM,
    pha.COMMENTS as DESCRIÇÃO,
    to_char(pha.CREATION_DATE, 'dd/mm/rrrr hh24:mi') as DATA_CRIAÇÃO,
    pap.first_name ||' '||pap.last_name as NOME_COMPRADOR,
    pha.authorization_status as STATUS,
    case when
					hrl1.location_code like 'KMB_AD_SP%' then 'fiscal_sp@kawasakibrasil.com'
					else ''
    end as email,
    case when
                pah.action_code = 'SUBMIT' then 'NECESSITA APROVAÇÃO'
    end as next_action
FROM
    APPS.PO_HEADERS_ALL pha,
    APPS.PO_LINES_ALL pla,
    APPS.per_all_people_f pap,
    APPS.po_action_history pah,
    apps.per_all_assignments_f paaf,
    apps.hr_locations_all_tl hrl1

WHERE
    pha.po_header_id = pla.po_header_id
AND pha.po_header_id = pah.object_id
AND pha.authorization_status = 'IN PROCESS'
AND pah.action_code = 'SUBMIT'
AND pha.agent_id = pap.person_id
AND pap.person_id = paaf.assignment_id
AND paaf.LOCATION_ID = hrl1.LOCATION_ID
and   hrl1.language = userenv('LANG');
--AND pha.segment1 = '11040';
    



SELECT DISTINCT
    pha.segment1,
    pha.comments,
    to_char(pha.creation_date, 'dd/mm/rrrr hh24:mi')        AS creation_date,
    pap.first_name|| ' '|| pap.last_name                    AS nome_comprador,
    pha.authorization_status                                AS status,
    CASE
        WHEN hrl1.location_code LIKE 'KMB_AD_SP%' THEN
            'fiscal_sp@kawasakibrasil.com'
        ELSE''
    END                                                     AS email,
    CASE
        WHEN pah.action_code IS NULL THEN
            'NECESSITA APROVAÇÃO'
    END                                                     AS next_action
INTO
    &segment1,
    &comments,
    &creation_date,
    &nome_comprador,
    &status,
    &email,
    &next_action
FROM
    apps.po_headers_all           pha,
    apps.po_lines_all             pla,
    apps.per_all_people_f         pap,
    apps.po_action_history        pah,
    apps.per_all_assignments_f    paaf,
    apps.hr_locations_all_tl      hrl1
WHERE
        pha.po_header_id = pla.po_header_id
    AND pha.po_header_id = pah.object_id
    AND pha.authorization_status = 'IN PROCESS'
    AND pah.action_code = 'SUBMIT'
    AND pha.agent_id = pap.person_id
    AND pap.person_id = paaf.assignment_id
    AND paaf.location_id = hrl1.location_id
    AND hrl1.language = userenv('LANG')
    AND pha.rowid = :rowid