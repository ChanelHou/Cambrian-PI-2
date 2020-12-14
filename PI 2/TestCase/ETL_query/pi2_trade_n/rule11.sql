select distinct active_flag
  
  from pi2_development_db.pi2_trade_n 
  order by active_flag; --N,X,Y
select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,
active_flag,
  case  when  narr_code1 in ( '78', '80') or narr_code2 in ( '78', '80')   or trade_status<>'1'
        then 'N'
        when last_active_age < 3 and trade_status='1'
        then 'Y'
		when last_active_age >= 3
        then 'N'
       else 'X'
  
  end active_flag_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where active_flag = active_flag_cal; --16633482793

    

	select count(*)  
 
  from pi2_trade_n ; --16633482793
  
   select count(*) from (
select trade_key,  vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,rate,
active_flag,
  case  when  narr_code1 in ( '78', '80') or narr_code2 in ( '78', '80')   or trade_status<>'1'
        then 'N'
        when last_active_age < 3 and trade_status='1'
        then 'Y'
		when last_active_age >= 3
        then 'N'
       else 'X'
  
  end active_flag_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where active_flag <> active_flag_cal; --0