/*Para analisar esse caso pegamos dentro do forms em diagnósticos o nome do bloco que era assignment e fizemos pesquisas no google referente a
tabelas de assignment, e nelas fizemos as ligações abaixo.
Devemos analisar se há campos repetidos, capos principais tais como PERSON_ID, Location_ code*/
Select LOCATION_CODE, COUNT(1) from apps.hr_locations_all_tl WHERE LANGUAGE = 'US' GROUP BY LOCATION_CODE HAVING COUNT(1)>1;  
SELECT * FROM apps.per_all_assignments_f;
SELECT PERSON_ID, COUNT(1) from apps.per_all_people_f WHERE PERSON_TYPE_ID = '2120' GROUP BY PERSON_ID HAVING COUNT(1)>1;
select * from apps.per_person_types where person_type_id in ('2120','2123'); 


SELECT pas.location_id, pas.person_id, hrl1.location_code FROM APPS.per_all_assignments_f pas, APPS.per_all_people_f paf, apps.hr_locations_all_tl hrl1, apps.per_person_types ppt
WHERE 1=1
AND pas.PERSON_ID = paf.PERSON_ID
AND pas.LOCATION_ID = hrl1.LOCATION_ID
AND hrl1.LANGUAGE = 'US'
AND paf.person_type_id = '2120'


