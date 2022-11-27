
-- Consultar se PO foi criada no EBS e verificar se o Status é Aprovada.N
select 
       a.segment1 || '.' || A.ORG_ID as NO_PO_OSGT,
       a.segment1 as NO_PO,
       A.ORG_ID,
       a.PO_HEADER_ID,
       ATTRIBUTE1 AS NO_INVOICE,
       A.AUTHORIZATION_STATUS AS STATUS,
       A.ATTRIBUTE_CATEGORY,
       A.INTERFACE_SOURCE_CODE,
       b.USER_NAME,
       A.CREATION_DATE,
       A.LAST_UPDATE_DATE
  from APPS.po_headers_all a, APPS.fnd_user b
 Where 1 = 1
 and a.CREATED_BY = b.USER_ID
      AND  SEGMENT1 in ('8924')
   --and authorization_status = 'APPROVED'
   --AND to_char(a.CREATION_DATE, 'dd/mm/yyyy') = '13/02/2019'
 ORDER BY 2, 3;
Para obter mais detalhes sobre a PO e seus partnumber use o comando abaixo:

