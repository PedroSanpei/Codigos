 select                                            
                                                    APD.INVOICE_ID,
                                                  -- SFWBR_AP_INVO_LINES_INTER_S.nextval, --INVOICE_LINE_ID,
                                                   APD.TP_LINHA, --LINE_TYPE_LOOKUP_CODE,
                                                   APD.VALOR, --AMOUNT,
                                                   APD.DT_MOVTO, --ACCOUNTING_DATE,
                                                   POL.DESCRICAO_ITEM, --DESCRIPTION,
                                        
                                                   POD.PO_HEADER_ID, --PO_HEADER_ID
                                                   
                                                   POD.PO_LINE_ID, --PO_LINE_ID,
                                                   
                                                   POD.LINE_LOCATION_ID, --PO_LINE_LOCATION_ID,
                                                   
                                                   POD.PO_DISTRIBUTION_ID, --PO_DISTRIBUTION_ID,
                                                   
                                                   POL.UNID_MEDIDA, --PO_UNIT_OF_MEASURE,
                                                   POL.ITEM, --INVENTORY_ITEM_ID,
                                                   POL.DESCRICAO_ITEM, --ITEM_DESCRIPTION,
                                                   APD.QUANTIDADE, --QUANTITY_INVOICED,
                                                   
                                                   APD.PRECO_UNITARIO, --UNIT_PRICE,
                                                   
                                                   APD.ID_CTA, --DIST_CODE_COMBINATION_ID,
                                                   -1, --LAST_UPDATED_BY,
                                                   sysdate, --LAST_UPDATE_DATE,
                                                   -1, --CREATED_BY,
                                                   sysdate, --CREATION_DATE,
                                                   APD.ATTRIBUTE_CATEGORY, --ATTRIBUTE_CATEGORY,
                                                   APD.ATTRIBUTE1, --ATTRIBUTE1,
                                                   APD.ATTRIBUTE2, --ATTRIBUTE2,
                                                   APD.ATTRIBUTE3, --ATTRIBUTE3,
                                                   APD.ATTRIBUTE4, --ATTRIBUTE4,
                                                   APD.ATTRIBUTE5, --ATTRIBUTE5,
                                                   APD.ATTRIBUTE6, --ATTRIBUTE6,
                                                   APD.ATTRIBUTE7, --ATTRIBUTE7,
                                                   APD.ATTRIBUTE8, --ATTRIBUTE8,
                                                   APD.ATTRIBUTE9, --ATTRIBUTE9,
                                                   APD.ATTRIBUTE10, --ATTRIBUTE10,
                                                   APD.ATTRIBUTE11, --ATTRIBUTE11,
                                                   APD.ATTRIBUTE12, --ATTRIBUTE12,
                                                   APD.ATTRIBUTE13, --ATTRIBUTE13,
                                                   APD.ATTRIBUTE14, --ATTRIBUTE14,
                                                   APD.ATTRIBUTE15, --ATTRIBUTE15,
                                                   APD.GLOBAL_ATTRIBUTE_CATEGORY, --GLOBAL_ATTRIBUTE_CATEGORY,
                                                   APD.GLOBAL_ATTRIBUTE1, --GLOBAL_ATTRIBUTE1,
                                                   APD.GLOBAL_ATTRIBUTE2, --GLOBAL_ATTRIBUTE2,
                                                   APD.GLOBAL_ATTRIBUTE3, --GLOBAL_ATTRIBUTE3,
                                                   APD.GLOBAL_ATTRIBUTE4, --GLOBAL_ATTRIBUTE4,
                                                   APD.GLOBAL_ATTRIBUTE5, --GLOBAL_ATTRIBUTE5,
                                                   APD.GLOBAL_ATTRIBUTE6, --GLOBAL_ATTRIBUTE6,
                                                   APD.GLOBAL_ATTRIBUTE7, --GLOBAL_ATTRIBUTE7,
                                                   APD.GLOBAL_ATTRIBUTE8, --GLOBAL_ATTRIBUTE8,
                                                   APD.GLOBAL_ATTRIBUTE9, --GLOBAL_ATTRIBUTE9,
                                                   APD.GLOBAL_ATTRIBUTE10, --GLOBAL_ATTRIBUTE10,
                                                   APD.GLOBAL_ATTRIBUTE11, --GLOBAL_ATTRIBUTE11,
                                                   APD.GLOBAL_ATTRIBUTE12, --GLOBAL_ATTRIBUTE12,
                                                   APD.GLOBAL_ATTRIBUTE13, --GLOBAL_ATTRIBUTE13,
                                                   APD.GLOBAL_ATTRIBUTE14, --GLOBAL_ATTRIBUTE14,
                                                   APD.GLOBAL_ATTRIBUTE15, --GLOBAL_ATTRIBUTE15,
                                                   APD.GLOBAL_ATTRIBUTE16, --GLOBAL_ATTRIBUTE16,
                                                   APD.GLOBAL_ATTRIBUTE17, --GLOBAL_ATTRIBUTE17,
                                                   APD.GLOBAL_ATTRIBUTE18, --GLOBAL_ATTRIBUTE18,
                                                   APD.GLOBAL_ATTRIBUTE19, --GLOBAL_ATTRIBUTE19,
                                                   APD.GLOBAL_ATTRIBUTE20, --GLOBAL_ATTRIBUTE20,
                                                   POD.PO_RELEASE_ID, --PO_RELEASE_ID,
                                                   APD.PROJECT_ID, --PROJECT_ID,
                                                   APD.TASK_ID, --TASK_ID,
                                                   APD.EXPENDITURE_TYPE, --EXPENDITURE_TYPE,
                                                   APD.EXPENDITURE_ITEM_DATE, --EXPENDITURE_ITEM_DATE,
                                                   APD.EXPENDITURE_ORGANIZATION_ID, --EXPENDITURE_ORGANIZATION_ID,
                                                   APD.PROJECT_ACCOUNTING_CONTEXT, --PROJECT_ACCOUNTING_CONTEXT,
                                                   APD.PA_ADDITION_FLAG, --PA_ADDITION_FLAG,
                                                   APD.PA_QUANTITY, --PA_QUANTITY,
                                                   -APD.QUANTIDADE, --STAT_AMOUNT,
                                                   APD.ORG_ID, --ORG_ID,
                                                   APD.REFERENCE_1, --REFERENCE_1,
                                                   APD.REFERENCE_2 --REFERENCE_2
                                            from   xxisv.SFWBR_AP_CONTAS_PAGAR_V      APD,
                                                   xxisv.SFWBR_PO_DISTRIBUTIONS_V     POD,
                                                   xxisv.SFWBR_PO_ITENS_PED_COMPRAS_V POL
                                            where  POL.PO_LINE_ID(+) = POD.PO_LINE_ID
                                            and    POD.PO_DISTRIBUTION_ID(+) = APD.PO_DISTRIBUTION_ID
                                           and    APD.INVOICE_ID = '115000'
                                            and    APD.VALOR > 0
                                            order by dt_movto desc;
                                            
 -- ANÁLISE DE ONDE ELE PUXA AS INFORMAÇÕES                                           
SELECT * FROM APPS.AP_INVOICES_ALL WHERE INVOICE_ID ='115000';
SELECT *FROM APPS.AP_INVOICE_DISTRIBUTIONS_ALL WHERE INVOICE_ID = '115000';
SELECT * FROM APPS.PO_LINES_ALL A WHERE PO_LINE_ID ='4029';

SELECT * FROM APPS.AP_INVOICES_ALL WHERE INVOICE_NUM  like '%4KD-999998%';
SELECT * FROM APPS.AP_INVOICE_LINES_ALL where invoice_id ='1638834';
SELECT *FROM APPS.AP_INVOICE_DISTRIBUTIONS_ALL WHERE INVOICE_ID = '1638834';
SELECT * FROM APPS.PO_DISTRIBUTIONS_ALL WHERE PO_DISTRIBUTION_ID IN ('1733455',
'1733456',
'1733457',
'1733458',
'1733459');

