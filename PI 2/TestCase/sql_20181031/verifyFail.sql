 select t.*
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month=201801
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P' 
and payment_status='90+'
and c.fi_name = "BANK OF MONTREAL"
and t.pi2_product='Auto Finance' 