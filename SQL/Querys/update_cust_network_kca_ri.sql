SELECT
    *
FROM
    CLL_F513_CUST_NETWORK
    WHERE inactive_flag = 'N'
    and operating_unit = '155';
    
UPDATE CLL_F513_CUST_NETWORK
SET IN_STATE_CFOP_ID  = '2406'
WHERE cust_network_id = 3005;

UPDATE CLL_F513_CUST_NETWORK
SET UTILIZATION_ID = '77'
WHERE cust_network_id = 3005;

UPDATE CLL_F513_CUST_NETWORK
SET RECEIPT_TRANSACTION_TYPE_ID = '144'
WHERE cust_network_id = 3005;

UPDATE CLL_F513_CUST_NETWORK
SET DEVOLUTION_TRANSACTION_TYPE_ID = 140
WHERE cust_network_id = 3005;

UPDATE CLL_F513_CUST_NETWORK
SET IN_STATE_CFOP_ID = 2406
WHERE cust_network_id = 3005;

UPDATE  CLL_F513_CUST_NETWORK
SET alert_days = '30'
WHERE cust_network_id = '3005'