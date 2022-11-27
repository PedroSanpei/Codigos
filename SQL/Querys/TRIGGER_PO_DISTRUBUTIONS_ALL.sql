create or replace TRIGGER XXKAW_PO_ACCRUAL_ACCT_IMP_TRG BEFORE
  INSERT ON "PO"."PO_DISTRIBUTIONS_ALL" FOR EACH ROW
--when ( NEW.organization_id IS NOT NULL
--    AND NEW.code_combination_id IS NOT NULL and NEW.REFERENCE in ('ITEM', 'SUPPLIER', 'CUSTOMER RETURN', 'RETURN')
--  )
DECLARE
    -- +=================================================================+
    -- |            Copyright (c) 2021 LUZCON                    |
    -- |            São Paulo - SP, Brasil, All rights reserved.         |
    -- +=================================================================+
    -- | FILENAME                                                        |
    -- |   XXGWB_PO_ACCRUAL_ACCT_IMPORT_TRG                              |
    -- |                                                                 |
    -- | PURPOSE                                                         |
    -- |   Trocar a conta AP ACCRUAL para a conta de                     |
    -- |   Mercadoria em trânsito                                        |
    -- | [DESCRIPTION]                                                   |
    -- |                   |
    -- |                                                                 |
    -- | [PARAMETERS]                                                    |
    -- |                                                                 |
    -- | CREATED BY                                                      |
    -- |   Gustavo Lopes Sobral                                                    |
    -- |   Note:                                                         |
    -- |                                                                 |
    -- | ALTERED BY                                                      |
    -- |                                                                 |
    -- +=================================================================+
    --
  v_segment1                gl_code_combinations.segment1%TYPE;
  v_segment2                gl_code_combinations.segment2%TYPE;
  v_segment3                gl_code_combinations.segment3%TYPE;
  v_segment4                gl_code_combinations.segment4%TYPE;
  v_segment5                gl_code_combinations.segment5%TYPE;
  v_segment6                gl_code_combinations.segment6%TYPE;
  v_segment7                gl_code_combinations.segment7%TYPE;
  v_segment8                gl_code_combinations.segment8%TYPE;
  v_concat_segs             gl_code_combinations_kfv.concatenated_segments%TYPE;
  p_chart_of_accounts_id    NUMBER;
  w_new_ccid                NUMBER;
  v_coa_id                  NUMBER;
  --
  --
  -- recupera os segmentos atuais
BEGIN
  BEGIN
    SELECT  gcc.segment1, gcc.segment2, gcc.segment3, gcc.segment4, gcc.segment5
    ,       gcc.segment6, gcc.segment7, gcc.segment8, gcc.chart_of_accounts_id
    INTO    v_segment1, v_segment2, v_segment3, v_segment4, v_segment5
    ,       v_segment6, v_segment7, v_segment8, v_coa_id
    FROM    gl_code_combinations gcc
    WHERE   code_combination_id = :new.accrual_account_id
    ;
  EXCEPTION
    WHEN OTHERS THEN raise_application_error(-20002, SQLCODE||' - '||SQLERRM);
  END;
  --
  BEGIN

    v_concat_segs := v_segment1||'.'||v_segment2||'.'||'11570030'||'.'||v_segment4||'.'||
                     v_segment5||'.'||v_segment6||'.'||v_segment7||'.'||v_segment8;
                     
    select code_combination_id into w_new_ccid
    from gl_code_combinations_kfv
    where concatenated_segments = v_concat_segs
    and chart_of_accounts_id = v_coa_id;
   
    --
                      
    :new.accrual_account_id := w_new_ccid;
  END;
    --
END;