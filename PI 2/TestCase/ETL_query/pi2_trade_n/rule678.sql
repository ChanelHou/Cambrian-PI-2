select distinct  new_account_m,new_account_q,new_account_y
  
  from pi2_development_db.pi2_trade_n 
  order by account_age,new_account_m,new_account_q,new_account_y;
select count(*) from (
select trade_key,consumer_key, vintage_month,   
account_age,new_account_m,new_account_q,new_account_y,
  case when account_age <= 1 then'Y' else 'N' end new_account_m_cal,
  case when account_age <= 2 then'Y' else 'N' end new_account_q_cal,
  case when account_age <= 11 then'Y' else 'N' end new_account_y_cal 
  
  from pi2_development_db.pi2_trade_n) source
  where new_account_m = new_account_m_cal
  and new_account_q=new_account_q_cal
  and new_account_y=new_account_y_cal;  --16633482793
    
select count(*)  
from pi2_trade_n ; --16633482793