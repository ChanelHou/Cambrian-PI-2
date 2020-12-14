select distinct payment_status
  
  from pi2_development_db.pi2_trade_n 
  order by payment_status;  
select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,
payment_status,
  case when instr( '_AK_AL_AM_AN_AQ_BE_BF_BJ_BI_BQ_BT_CE_CJ_CK_CL_CP_CR_CW_CY_FK_EO_EP_EU_FC_FE_FH_FI_HU_HV' , sts_code1   ) > 1 or
		     instr( '_AK_AL_AM_AN_AQ_BE_BF_BJ_BI_BQ_BT_CE_CJ_CK_CL_CP_CR_CW_CY_FK_EO_EP_EU_FC_FE_FH_FI_HU_HV' , sts_code2   ) > 1 or
			 rate in ('7', '8', '9')
        then 'BadDebt'
        when rate in ('4', '5') then '90+'
        when rate = '3' then '60'
        when rate = '2' then '30'
        else 'Satisfactory'
  
  end payment_status_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where payment_status = payment_status_cal;--16633482793

    

	select count(*)  
 
  from pi2_trade_n ; --16633482793
  
  select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,
payment_status,
  case when instr( '_AK_AL_AM_AN_AQ_BE_BF_BJ_BI_BQ_BT_CE_CJ_CK_CL_CP_CR_CW_CY_FK_EO_EP_EU_FC_FE_FH_FI_HU_HV' , sts_code1   ) > 1 or
		     instr( '_AK_AL_AM_AN_AQ_BE_BF_BJ_BI_BQ_BT_CE_CJ_CK_CL_CP_CR_CW_CY_FK_EO_EP_EU_FC_FE_FH_FI_HU_HV' , sts_code2   ) > 1 or
			 rate in ('7', '8', '9')
        then 'BadDebt'
        when rate in ('4', '5') then '90+'
        when rate = '3' then '60'
        when rate = '2' then '30'
        else 'Satisfactory'
  
  end payment_status_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where payment_status <> payment_status_cal;--0