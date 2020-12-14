select distinct product_name
  
  from pi2_development_db.pi2_trade_n 
  order by product_name; 


  
select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,industry_code ,sts_code1  ,sts_code2,
product_name,
  case when   type='M' or 
            industry_code  in ('FM', 'RE') or 
			instr('_EQ_FI_FH_HL_HU_FJ', sts_code1  ) > 1 or 
			instr('_EQ_FI_FH_HL_HU_FJ', sts_code2) > 1 
	   then 'Mortgage'
       -- Auto **;
       when industry_code  in ('FA', 'FZ', 'AN', 'AU', 'AT') or 
	        sts_code1   = 'AO' or 
			sts_code2 = 'AO' 
	   then 'Auto'
        -- National Credit Card **;         
       when type='R' and   industry_code  = 'ON'    then 'National Credit Card'
       -- Charge Card **;
       when industry_code  = 'ON' and nvl(type, '') <> 'R'  	   then 'Charge Card' 
	   -- Student Loan **;
	   when (instr('_BN_CZ_EN_EO_EP_FZ_JH', sts_code1  ) > 1 or instr('_BN_CZ_EN_EO_EP_FZ_JH', sts_code2) > 1) 	   then 'Student Loan'
	   -- Bank Unsecured **;
       when type in ('R','C') and   industry_code ='BB' and
			nvl(sts_code1  , ' ') <> 'JC' and  nvl(sts_code2, ' ') <> 'JC' and
 		   (sts_code1   = 'AX' or sts_code2 = 'AX' or credit_limit < 50000)
       then 'Bank Unsecured'
       -- Credit Union Unsecured **;
       when type in ('R', 'C') and  industry_code  in ('FC', 'FS') and 
	        nvl(sts_code1  , ' ') <> 'JC' and      nvl(sts_code2, ' ') <> 'JC' and
	       (sts_code1   = 'AX' or sts_code2 = 'AX' or credit_limit < 50000)
	  then 'Credit Union Unsecured'
       -- Bank Heloc **
	   -- handle AX  above narrative also which is personal loc
       when type in ('R','C') and        industry_code  = 'BB'  and
			(sts_code1   = 'JC' or sts_code2 = 'JC' or credit_limit >= 50000) 
       then 'Bank Heloc' 
       -- Credit Union Heloc **;
       when type in ('R', 'C') and      industry_code  in ('FC', 'FS') and
			(sts_code1   = 'JC' OR sts_code2 = 'JC' OR credit_limit >= 50000)
       then 'Credit Union Heloc'
	   -- Bank Loan (without auto) **;
       when type = 'I' and       industry_code ='BB' 	  then 'Bank Loan'
    
      when type = 'O' and     industry_code ='BB'	  then 'Bank Open'
     
      when type = 'I' and     industry_code  in ('FC', 'FS')       then 'Credit Union Loan'                               
                        
      when type = 'O' and      industry_code  in ('FC', 'FS') 	  then 'Credit Union Open'
     
      when industry_code  = 'FF' 	  then 'Sales Finance'
      
      when industry_code  = 'FP' 	  then 'Personal Finance'                             
    
      when substr(industry_code , 1, 1) in ('A', 'C', 'D', 'G', 'H', 'J', 'L', 'S')  and  trim(industry_code ) not in ('AN', 'AU', 'AT')   then 'Retail'
  
      when industry_code  = 'UT'   then 'Telco'
    
      when substr(industry_code ,1,1) = 'V' 	  then 'Government'
      else 'Other'
   
  
  end product_name_cal 
  
  from pi2_development_db.pi2_trade_n ) source
  where product_name = product_name_cal;--16633482793
    

	select count(*)  
 
  from pi2_trade_n ; --16633482793
  
 select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,industry_code ,sts_code1  ,sts_code2,
product_name,
  case when   type='M' or 
            industry_code  in ('FM', 'RE') or 
			instr('_EQ_FI_FH_HL_HU_FJ', sts_code1  ) > 1 or 
			instr('_EQ_FI_FH_HL_HU_FJ', sts_code2) > 1 
	   then 'Mortgage'
       -- Auto **;
       when industry_code  in ('FA', 'FZ', 'AN', 'AU', 'AT') or 
	        sts_code1   = 'AO' or 
			sts_code2 = 'AO' 
	   then 'Auto'
        -- National Credit Card **;         
       when type='R' and   industry_code  = 'ON'    then 'National Credit Card'
       -- Charge Card **;
       when industry_code  = 'ON' and nvl(type, '') <> 'R'  	   then 'Charge Card' 
	   -- Student Loan **;
	   when (instr('_BN_CZ_EN_EO_EP_FZ_JH', sts_code1  ) > 1 or instr('_BN_CZ_EN_EO_EP_FZ_JH', sts_code2) > 1) 	   then 'Student Loan'
	   -- Bank Unsecured **;
       when type in ('R','C') and   industry_code ='BB' and
			nvl(sts_code1  , ' ') <> 'JC' and  nvl(sts_code2, ' ') <> 'JC' and
 		   (sts_code1   = 'AX' or sts_code2 = 'AX' or credit_limit < 50000)
       then 'Bank Unsecured'
       -- Credit Union Unsecured **;
       when type in ('R', 'C') and  industry_code  in ('FC', 'FS') and 
	        nvl(sts_code1  , ' ') <> 'JC' and      nvl(sts_code2, ' ') <> 'JC' and
	       (sts_code1   = 'AX' or sts_code2 = 'AX' or credit_limit < 50000)
	  then 'Credit Union Unsecured'
       -- Bank Heloc **
	   -- handle AX  above narrative also which is personal loc
       when type in ('R','C') and        industry_code  = 'BB'  and
			(sts_code1   = 'JC' or sts_code2 = 'JC' or credit_limit >= 50000) 
       then 'Bank Heloc' 
       -- Credit Union Heloc **;
       when type in ('R', 'C') and      industry_code  in ('FC', 'FS') and
			(sts_code1   = 'JC' OR sts_code2 = 'JC' OR credit_limit >= 50000)
       then 'Credit Union Heloc'
	   -- Bank Loan (without auto) **;
       when type = 'I' and       industry_code ='BB' 	  then 'Bank Loan'
    
      when type = 'O' and     industry_code ='BB'	  then 'Bank Open'
     
      when type = 'I' and     industry_code  in ('FC', 'FS')       then 'Credit Union Loan'                               
                        
      when type = 'O' and      industry_code  in ('FC', 'FS') 	  then 'Credit Union Open'
     
      when industry_code  = 'FF' 	  then 'Sales Finance'
      
      when industry_code  = 'FP' 	  then 'Personal Finance'                             
    
      when substr(industry_code , 1, 1) in ('A', 'C', 'D', 'G', 'H', 'J', 'L', 'S')  and  trim(industry_code ) not in ('AN', 'AU', 'AT')   then 'Retail'
  
      when industry_code  = 'UT'   then 'Telco'
    
      when substr(industry_code ,1,1) = 'V' 	  then 'Government'
      else 'Other'
   
  
  end product_name_cal 
  
  from pi2_development_db.pi2_trade_n ) source
  where product_name <> product_name_cal;--0