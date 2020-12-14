--chart 25,26,27,28   -- all accounts by product
--month 201801
--quarter 201712
--years 201601-201801
with cur as 
( select t.pi2_product product, t.year_month,
--chart 25 count
sum(c.fi_name = "BANK OF MONTREAL" ) count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) count_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" )) over(partition by t.year_month) count_Market_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" )) over(partition by t.year_month) count_Market_PEER,
--chart 26 balance
sum(if(fi_name = "BANK OF MONTREAL" ,balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,balance,0))  balance_PEER,
sum(sum(if(c.fi_name = "BANK OF MONTREAL" ,balance,0))) over(partition by t.year_month) balance_Market_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ,balance,0))) over(partition by t.year_month) balance_Market_PEER,
--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" ,credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,credit_limit,0))  credit_limit_PEER,
sum(sum(if(c.fi_name = "BANK OF MONTREAL" ,credit_limit,0))) over(partition by t.year_month) credit_limit_Market_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ,credit_limit,0))) over(partition by t.year_month) credit_limit_Market_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
and t.pi2_product in ('Installment loan','NCC')
group by t.year_month ,t.pi2_product)  
select year_month,product,
count_BMO,
if(count_Market_BMO<>0,count_BMO/count_Market_BMO*100,null) shareAcc_BMO,
if(count_Market_PEER<>0,count_PEER/count_Market_PEER*100,null) shareAcc_PEER,
--balance
balance_BMO,
if(balance_Market_BMO<>0,balance_BMO/balance_Market_BMO*100,null) share_balance_BMO,
if(balance_Market_PEER<>0,balance_PEER/balance_Market_PEER*100,null) share_balance_PEER,
--limit
credit_limit_BMO,
if(credit_limit_Market_BMO<>0,credit_limit_BMO/credit_limit_Market_BMO*100,null) share_credit_limit_BMO,
if(credit_limit_Market_PEER<>0,credit_limit_PEER/credit_limit_Market_PEER*100,null) share_credit_limit_PEER,

if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER
from cur
order by  cur.year_month,cur.product ; 


--by risk
with cur as 
( select ers_band  ,t.year_month,
--chart 25 count
sum(c.fi_name = "BANK OF MONTREAL" ) count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) count_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" )) over(partition by t.year_month) count_Market_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" )) over(partition by t.year_month) count_Market_PEER,
--chart 26 balance
sum(if(fi_name = "BANK OF MONTREAL" ,balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,balance,0))  balance_PEER,
sum(sum(if(c.fi_name = "BANK OF MONTREAL" ,balance,0))) over(partition by t.year_month) balance_Market_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ,balance,0))) over(partition by t.year_month) balance_Market_PEER,
--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" ,credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,credit_limit,0))  credit_limit_PEER,
sum(sum(if(c.fi_name = "BANK OF MONTREAL" ,credit_limit,0))) over(partition by t.year_month) credit_limit_Market_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ,credit_limit,0))) over(partition by t.year_month) credit_limit_Market_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.pi2_product in ('Installment loan','NCC')
and t.joint_flag='P'
group by t.year_month ,ers_band)  
select year_month,ers_band,
count_BMO,
if(count_Market_BMO<>0,count_BMO/count_Market_BMO*100,null) shareAcc_BMO,
if(count_Market_PEER<>0,count_PEER/count_Market_PEER*100,null) shareAcc_PEER,
--balance
balance_BMO,
if(balance_Market_BMO<>0,balance_BMO/balance_Market_BMO*100,null) share_balance_BMO,
if(balance_Market_PEER<>0,balance_PEER/balance_Market_PEER*100,null) share_balance_PEER,
--limit
credit_limit_BMO,
if(credit_limit_Market_BMO<>0,credit_limit_BMO/credit_limit_Market_BMO*100,null) share_credit_limit_BMO,
if(credit_limit_Market_PEER<>0,credit_limit_PEER/credit_limit_Market_PEER*100,null) share_credit_limit_PEER,
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER
from cur
order by  cur.year_month,cur.ers_band ; 

--by province

with cur as 
( select s.province  ,t.year_month,
--chart 25 count
sum(c.fi_name = "BANK OF MONTREAL" ) count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) count_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" )) over(partition by t.year_month) count_Market_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" )) over(partition by t.year_month) count_Market_PEER,
--chart 26 balance
sum(if(fi_name = "BANK OF MONTREAL" ,balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,balance,0))  balance_PEER,
sum(sum(if(c.fi_name = "BANK OF MONTREAL" ,balance,0))) over(partition by t.year_month) balance_Market_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ,balance,0))) over(partition by t.year_month) balance_Market_PEER,
--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" ,credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,credit_limit,0))  credit_limit_PEER,
sum(sum(if(c.fi_name = "BANK OF MONTREAL" ,credit_limit,0))) over(partition by t.year_month) credit_limit_Market_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ,credit_limit,0))) over(partition by t.year_month) credit_limit_Market_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.pi2_product in ('Installment loan','NCC')
and t.joint_flag='P'
group by t.year_month ,s.province)  
select year_month,province,
count_BMO,
if(count_Market_BMO<>0,count_BMO/count_Market_BMO*100,null) shareAcc_BMO,
if(count_Market_PEER<>0,count_PEER/count_Market_PEER*100,null) shareAcc_PEER,
--balance
balance_BMO,
if(balance_Market_BMO<>0,balance_BMO/balance_Market_BMO*100,null) share_balance_BMO,
if(balance_Market_PEER<>0,balance_PEER/balance_Market_PEER*100,null) share_balance_PEER,
--limit
credit_limit_BMO,
if(credit_limit_Market_BMO<>0,credit_limit_BMO/credit_limit_Market_BMO*100,null) share_credit_limit_BMO,
if(credit_limit_Market_PEER<>0,credit_limit_PEER/credit_limit_Market_PEER*100,null) share_credit_limit_PEER,
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER
from cur
order by  cur.year_month,cur.province ; 

--by age

with cur as 
( select s.consumer_age_cat  ,t.year_month,
--chart 25 count
sum(c.fi_name = "BANK OF MONTREAL" ) count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) count_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" )) over(partition by t.year_month) count_Market_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" )) over(partition by t.year_month) count_Market_PEER,
--chart 26 balance
sum(if(fi_name = "BANK OF MONTREAL" ,balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,balance,0))  balance_PEER,
sum(sum(if(c.fi_name = "BANK OF MONTREAL" ,balance,0))) over(partition by t.year_month) balance_Market_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ,balance,0))) over(partition by t.year_month) balance_Market_PEER,
--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" ,credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,credit_limit,0))  credit_limit_PEER,
sum(sum(if(c.fi_name = "BANK OF MONTREAL" ,credit_limit,0))) over(partition by t.year_month) credit_limit_Market_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ,credit_limit,0))) over(partition by t.year_month) credit_limit_Market_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.pi2_product in ('Installment loan','NCC')
and t.joint_flag='P'
group by t.year_month ,s.consumer_age_cat)  
select year_month,consumer_age_cat,
count_BMO,
count_PEER,count_Market_BMO,
count_Market_PEER,
if(count_Market_BMO<>0,count_BMO/count_Market_BMO*100,null) shareAcc_BMO,
if(count_Market_PEER<>0,count_PEER/count_Market_PEER*100,null) shareAcc_PEER,
--balance
balance_BMO,
balance_PEER,balance_Market_BMO,
balance_Market_PEER,
if(balance_Market_BMO<>0,balance_BMO/balance_Market_BMO*100,null) share_balance_BMO,
if(balance_Market_PEER<>0,balance_PEER/balance_Market_PEER*100,null) share_balance_PEER,
--limit
credit_limit_BMO,
credit_limit_PEER,credit_limit_Market_BMO,
credit_limit_Market_PEER,
if(credit_limit_Market_BMO<>0,credit_limit_BMO/credit_limit_Market_BMO*100,null) share_credit_limit_BMO,
if(credit_limit_Market_PEER<>0,credit_limit_PEER/credit_limit_Market_PEER*100,null) share_credit_limit_PEER,

if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER
from cur
order by  cur.year_month,cur.consumer_age_cat ; 

