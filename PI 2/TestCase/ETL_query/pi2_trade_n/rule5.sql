select distinct active_status 
  
  from pi2_development_db.pi2_trade_n 
  order by active_status;  --A,I,X

select count(*) from (
select trade_key,consumer_key, vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,
active_status,
  case when reported_age >= 13  or
            last_active_age >= 4 or
            narr_code1 in ( '78', '80') or
            narr_code2 in ( '78', '80')   
        then 'I'
        when reported_age < 13 and 
            last_active_age < 4
       then 'A'
       else 'X'
  end active_status_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where active_status = active_status_cal;  --16633482793
    

	select count(*)  
 
  from pi2_trade_n ; --16633482793
  
  
  select count(*) from (
select trade_key,consumer_key, vintage_month,  narr_code1,narr_code2,type,reported_age,last_active_age,
active_status,
  case when reported_age >= 13  or
            last_active_age >= 4 or
            narr_code1 in ( '78', '80') or
            narr_code2 in ( '78', '80')   
        then 'I'
        when reported_age < 13 and 
            last_active_age < 4
       then 'A'
       else 'X'
  end active_status_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where active_status<> active_status_cal;  --0
  
  
   