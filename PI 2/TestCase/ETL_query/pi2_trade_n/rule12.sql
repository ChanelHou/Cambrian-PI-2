select distinct trade_status
  
  from pi2_development_db.pi2_trade_n 
  order by trade_status; --1,2,3
select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,sts_code1,sts_code2,
trade_status,
   case 
   --when instr( '_AA_AB_AC_AG_BB_FD' , sts_code1) > 1 or
	--	     instr( '_AA_AB_AC_AG_BB_FD' , sts_code2) > 1 or
      --       tr.conditioncode in ('S', 'B') 
	    --then 4
        when balance = 0 and type IN ('I', 'M', 'L') 
        then '2'
		when balance = 0 and  credit_limit = 0 and type IN ('R', 'C') 
        then '2'
		when instr( '_AT_AV_AY_BC_BD_BP_CG_CX_ER_ET_EV_FM_HM_JF' , sts_code1) > 1 or
		     instr( '_AT_AV_AY_BC_BD_BP_CG_CX_ER_ET_EV_FM_HM_JF' , sts_code2) > 1
        then '2'    
		when reported_age >24
		then '2'
        when instr( '_AK_AL_AM_AN_AQ_BE_BF_BJ_BI_BQ_BT_CE_CJ_CK_CL_CP_CR_CW_CY_FK_EO_EP_EU_FC_FE_FH_FI_HU_HV' , sts_code1) > 1 or
		     instr( '_AK_AL_AM_AN_AQ_BE_BF_BJ_BI_BQ_BT_CE_CJ_CK_CL_CP_CR_CW_CY_FK_EO_EP_EU_FC_FE_FH_FI_HU_HV' , sts_code2) > 1 or
			 rate in ('7', '8', '9')
	    then '3'
	    else '1'
  
  end trade_status_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where trade_status = trade_status_cal;  --16633482793

    

	select count(*)  
 
  from pi2_trade_n ; --16633482793
  
  select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,sts_code1,sts_code2,
trade_status,
   case 
   --when instr( '_AA_AB_AC_AG_BB_FD' , sts_code1) > 1 or
	--	     instr( '_AA_AB_AC_AG_BB_FD' , sts_code2) > 1 or
      --       tr.conditioncode in ('S', 'B') 
	    --then 4
        when balance = 0 and type IN ('I', 'M', 'L') 
        then '2'
		when balance = 0 and  credit_limit = 0 and type IN ('R', 'C') 
        then '2'
		when instr( '_AT_AV_AY_BC_BD_BP_CG_CX_ER_ET_EV_FM_HM_JF' , sts_code1) > 1 or
		     instr( '_AT_AV_AY_BC_BD_BP_CG_CX_ER_ET_EV_FM_HM_JF' , sts_code2) > 1
        then '2'    
		when reported_age >24
		then '2'
        when instr( '_AK_AL_AM_AN_AQ_BE_BF_BJ_BI_BQ_BT_CE_CJ_CK_CL_CP_CR_CW_CY_FK_EO_EP_EU_FC_FE_FH_FI_HU_HV' , sts_code1) > 1 or
		     instr( '_AK_AL_AM_AN_AQ_BE_BF_BJ_BI_BQ_BT_CE_CJ_CK_CL_CP_CR_CW_CY_FK_EO_EP_EU_FC_FE_FH_FI_HU_HV' , sts_code2) > 1 or
			 rate in ('7', '8', '9')
	    then '3'
	    else '1'
  
  end trade_status_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where trade_status <> trade_status_cal;  --0