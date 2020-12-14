select distinct product_name
  
  from pi2_development_db.pi2_trade_n 
  order by product_code; 


  
select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,industry_code ,sts_code1  ,sts_code2,
product_code,
  case when type='M' or 
            industry_code in ('FM', 'RE') or 
			instr('_EQ_FI_FH_HL_HU_FJ', sts_code1) > 1 or 
			instr('_EQ_FI_FH_HL_HU_FJ', sts_code2) > 1 
	   then 'A'
       when industry_code in ('FA', 'FZ', 'AN', 'AU', 'AT') or sts_code1 = 'AO' or sts_code2 = 'AO'    then 'L'
       when type='R' and   industry_code = 'ON'    then 'B'
       when industry_code = 'ON' and    nvl(type, ' ') <> 'R'    then 'C' 
 	   when (instr('_BN_CZ_EN_EO_EP_FZ_JH', sts_code1) > 1 or instr('_BN_CZ_EN_EO_EP_FZ_JH', sts_code2) > 1)    then '8'
       when type in ('R','C') and   industry_code='BB' and nvl(sts_code1, ' ') <> 'JC' and 	nvl(sts_code2, ' ') <> 'JC' and
 		   (sts_code1 = 'AX' or sts_code2 = 'AX' or credit_limit < 50000)
       then 'G'
       -- Credit Union Unsecured **;
       when type in ('R', 'C') and 
	        industry_code in ('FC', 'FS') and 
	        nvl(sts_code1, ' ') <> 'JC' and
	        nvl(sts_code2, ' ') <> 'JC' and
	       (sts_code1 = 'AX' or sts_code2 = 'AX' or credit_limit < 50000)
	  then 'K'
       -- Bank Heloc **
	   -- handle AX  above narrative also which is personal loc
       when type in ('R','C') and
            industry_code = 'BB'  and
			(sts_code1 = 'JC' or sts_code2 = 'JC' or credit_limit >= 50000) 
       then 'D' 
       -- Credit Union Heloc **;
       when type in ('R', 'C') and
	        industry_code in ('FC', 'FS') and
			(sts_code1 = 'JC' OR sts_code2 = 'JC' OR credit_limit >= 50000)
       then 'H'
	   -- Bank Loan (without auto) **;
       when type = 'I' and	        industry_code='BB' 	  then 'E'
      -- Bank Open **;
      when type = 'O' and	       industry_code='BB'	  then 'F'
      -- Credit Union Loan **;
      when type = 'I' and	       industry_code in ('FC', 'FS')       then 'I'                               
      -- Credit Union Open **;                           
      when type = 'O' and	       industry_code in ('FC', 'FS') 	  then 'J'
      -- Sales Finance **;
      when industry_code = 'FF' 	  then 'M'
      -- Personal Finance **;
      when industry_code = 'FP' 	  then 'N'                             
      -- Retail **;
      when substr(industry_code, 1, 1) in ('A', 'C', 'D', 'G', 'H', 'J', 'L', 'S')  and
	       trim(industry_code) not in ('AN', 'AU', 'AT') 
	  then 'O'
      -- Telco **;
      when industry_code = 'UT' 	  then 'P'
      -- Government **;
      when substr(industry_code,1,1) = 'V' 	  then 'Q'
      else 'R'
   
  
  end product_code_cal 
  
  from pi2_development_db.pi2_trade_n ) source
  where product_code = product_code_cal;--	16633482793
    

	select count(*)  
 
  from pi2_trade_n ; --16633482793
  
  
  select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,industry_code ,sts_code1  ,sts_code2,
product_code,
  case when type='M' or 
            industry_code in ('FM', 'RE') or 
			instr('_EQ_FI_FH_HL_HU_FJ', sts_code1) > 1 or 
			instr('_EQ_FI_FH_HL_HU_FJ', sts_code2) > 1 
	   then 'A'
       when industry_code in ('FA', 'FZ', 'AN', 'AU', 'AT') or sts_code1 = 'AO' or sts_code2 = 'AO'    then 'L'
       when type='R' and   industry_code = 'ON'    then 'B'
       when industry_code = 'ON' and    nvl(type, ' ') <> 'R'    then 'C' 
 	   when (instr('_BN_CZ_EN_EO_EP_FZ_JH', sts_code1) > 1 or instr('_BN_CZ_EN_EO_EP_FZ_JH', sts_code2) > 1)    then '8'
       when type in ('R','C') and   industry_code='BB' and nvl(sts_code1, ' ') <> 'JC' and 	nvl(sts_code2, ' ') <> 'JC' and
 		   (sts_code1 = 'AX' or sts_code2 = 'AX' or credit_limit < 50000)
       then 'G'
       -- Credit Union Unsecured **;
       when type in ('R', 'C') and 
	        industry_code in ('FC', 'FS') and 
	        nvl(sts_code1, ' ') <> 'JC' and
	        nvl(sts_code2, ' ') <> 'JC' and
	       (sts_code1 = 'AX' or sts_code2 = 'AX' or credit_limit < 50000)
	  then 'K'
       -- Bank Heloc **
	   -- handle AX  above narrative also which is personal loc
       when type in ('R','C') and
            industry_code = 'BB'  and
			(sts_code1 = 'JC' or sts_code2 = 'JC' or credit_limit >= 50000) 
       then 'D' 
       -- Credit Union Heloc **;
       when type in ('R', 'C') and
	        industry_code in ('FC', 'FS') and
			(sts_code1 = 'JC' OR sts_code2 = 'JC' OR credit_limit >= 50000)
       then 'H'
	   -- Bank Loan (without auto) **;
       when type = 'I' and	        industry_code='BB' 	  then 'E'
      -- Bank Open **;
      when type = 'O' and	       industry_code='BB'	  then 'F'
      -- Credit Union Loan **;
      when type = 'I' and	       industry_code in ('FC', 'FS')       then 'I'                               
      -- Credit Union Open **;                           
      when type = 'O' and	       industry_code in ('FC', 'FS') 	  then 'J'
      -- Sales Finance **;
      when industry_code = 'FF' 	  then 'M'
      -- Personal Finance **;
      when industry_code = 'FP' 	  then 'N'                             
      -- Retail **;
      when substr(industry_code, 1, 1) in ('A', 'C', 'D', 'G', 'H', 'J', 'L', 'S')  and
	       trim(industry_code) not in ('AN', 'AU', 'AT') 
	  then 'O'
      -- Telco **;
      when industry_code = 'UT' 	  then 'P'
      -- Government **;
      when substr(industry_code,1,1) = 'V' 	  then 'Q'
      else 'R'
   
  
  end product_code_cal 
  
  from pi2_development_db.pi2_trade_n ) source
  where product_code<> product_code_cal;--0
  
  