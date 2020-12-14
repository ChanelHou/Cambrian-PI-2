--defect 35 and 36
--chart 67-71,  by all region  by months  ,  
with source as 
( select t.pi2_product product, t.year_month,
--all account 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1') volume_30DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1') volume_30DPD_PEER ,


sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1') volume_60DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1') volume_60DPD_PEER ,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1',balance,0))  balance_90DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1',balance,0))  balance_90DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1') volume_90DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1') volume_90DPD_PEER  

from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month )  
select cur.product , cur.year_month,
--chart 45 ,--chart 47
cur.volume_BMO, 
cur.volume_deli_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) - if(pre.volume_BMO<>0,pre.volume_deli_BMO/pre.volume_BMO*100,null)  deliquency_SinceLast_BMO,
cur.volume_PEER ,
cur.volume_deli_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) deliquencyRate_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) - if(pre.volume_PEER<>0,pre.volume_deli_PEER/pre.volume_PEER*100,null) deliquency_SinceLast_PEER,
--chart 44
cur.balance_deli_BMO,
cur.balance_deli_PEER,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) balanceRate_deli_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) balanceRate_deli_PEER,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) - if(pre.balance_BMO<>0,pre.balance_deli_BMO/pre.balance_BMO*100,null)  deliquencyBalance_SinceLast_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) - if(pre.balance_PEER<>0,pre.balance_deli_PEER/pre.balance_PEER*100,null) deliquencyBalance_SinceLast_PEER,
--chart 46

if(cur.balance_BMO<>0,cur.balance_30DPD_BMO/cur.balance_BMO*100,null) balanceRate_30DPD_BMO,
if(cur.balance_BMO<>0,cur.balance_60DPD_BMO/cur.balance_BMO*100,null) balanceRate_60DPD_BMO, 
if(cur.balance_BMO<>0,cur.balance_90DPD_BMO/cur.balance_BMO*100,null) balanceRate_90DPD_BMO,

if(cur.balance_PEER<>0,cur.balance_30DPD_PEER/cur.balance_PEER*100,null) balanceRate_30DPD_PEER,
if(cur.balance_PEER<>0,cur.balance_60DPD_PEER/cur.balance_PEER*100,null) balanceRate_60DPD_PEER, 
if(cur.balance_PEER<>0,cur.balance_90DPD_PEER/cur.balance_PEER*100,null) balanceRate_90DPD_PEER,

if(cur.volume_BMO<>0,cur.volume_30DPD_BMO/cur.volume_BMO*100,null) volumeRate_30DPD_BMO,
if(cur.volume_BMO<>0,cur.volume_60DPD_BMO/cur.volume_BMO*100,null) volumeRate_60DPD_BMO, 
if(cur.volume_BMO<>0,cur.volume_90DPD_BMO/cur.volume_BMO*100,null) volumeRate_90DPD_BMO,

if(cur.volume_PEER<>0,cur.volume_30DPD_PEER/cur.volume_PEER*100,null) volumeRate_30DPD_PEER,
if(cur.volume_PEER<>0,cur.volume_60DPD_PEER/cur.volume_PEER*100,null) volumeRate_60DPD_PEER, 
if(cur.volume_PEER<>0,cur.volume_90DPD_PEER/cur.volume_PEER*100,null) volumeRate_90DPD_PEER ,

cur.balance_30DPD_BMO,
cur.balance_60DPD_BMO,
cur.balance_90DPD_BMO,
cur.balance_30DPD_PEER,
cur.balance_60DPD_PEER,
cur.balance_90DPD_PEER,
cur.volume_30DPD_BMO,
cur.volume_60DPD_BMO,
cur.volume_90DPD_BMO,
cur.volume_30DPD_PEER,
cur.volume_60DPD_PEER,
cur.volume_90DPD_PEER
 
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  if(mod(cur.year_month,100)=1 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-1)
order by cur.year_month,cur.product;

--chart 67-71,  by specific region  by months     
with source as 
( select t.pi2_product product, t.year_month, s.province,
--all account 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1') volume_30DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1') volume_30DPD_PEER ,


sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1') volume_60DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1') volume_60DPD_PEER ,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1',balance,0))  balance_90DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1',balance,0))  balance_90DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1') volume_90DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1') volume_90DPD_PEER  

from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month,s.province)  
select cur.product , cur.year_month,cur.province,
--chart 45 ,--chart 47
cur.volume_BMO, 
cur.volume_deli_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) - if(pre.volume_BMO<>0,pre.volume_deli_BMO/pre.volume_BMO*100,null)  deliquency_SinceLast_BMO,
cur.volume_PEER ,
cur.volume_deli_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) deliquencyRate_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) - if(pre.volume_PEER<>0,pre.volume_deli_PEER/pre.volume_PEER*100,null) deliquency_SinceLast_PEER,
--chart 44
cur.balance_deli_BMO,
cur.balance_deli_PEER,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) balanceRate_deli_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) balanceRate_deli_PEER,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) - if(pre.balance_BMO<>0,pre.balance_deli_BMO/pre.balance_BMO*100,null)  deliquencyBalance_SinceLast_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) - if(pre.balance_PEER<>0,pre.balance_deli_PEER/pre.balance_PEER*100,null) deliquencyBalance_SinceLast_PEER,
--chart 46

if(cur.balance_BMO<>0,cur.balance_30DPD_BMO/cur.balance_BMO*100,null) balanceRate_30DPD_BMO,
if(cur.balance_BMO<>0,cur.balance_60DPD_BMO/cur.balance_BMO*100,null) balanceRate_60DPD_BMO, 
if(cur.balance_BMO<>0,cur.balance_90DPD_BMO/cur.balance_BMO*100,null) balanceRate_90DPD_BMO,

if(cur.balance_PEER<>0,cur.balance_30DPD_PEER/cur.balance_PEER*100,null) balanceRate_30DPD_PEER,
if(cur.balance_PEER<>0,cur.balance_60DPD_PEER/cur.balance_PEER*100,null) balanceRate_60DPD_PEER, 
if(cur.balance_PEER<>0,cur.balance_90DPD_PEER/cur.balance_PEER*100,null) balanceRate_90DPD_PEER,

if(cur.volume_BMO<>0,cur.volume_30DPD_BMO/cur.volume_BMO*100,null) volumeRate_30DPD_BMO,
if(cur.volume_BMO<>0,cur.volume_60DPD_BMO/cur.volume_BMO*100,null) volumeRate_60DPD_BMO, 
if(cur.volume_BMO<>0,cur.volume_90DPD_BMO/cur.volume_BMO*100,null) volumeRate_90DPD_BMO,

if(cur.volume_PEER<>0,cur.volume_30DPD_PEER/cur.volume_PEER*100,null) volumeRate_30DPD_PEER,
if(cur.volume_PEER<>0,cur.volume_60DPD_PEER/cur.volume_PEER*100,null) volumeRate_60DPD_PEER, 
if(cur.volume_PEER<>0,cur.volume_90DPD_PEER/cur.volume_PEER*100,null) volumeRate_90DPD_PEER ,

cur.balance_30DPD_BMO,
cur.balance_60DPD_BMO,
cur.balance_90DPD_BMO,
cur.balance_30DPD_PEER,
cur.balance_60DPD_PEER,
cur.balance_90DPD_PEER,
cur.volume_30DPD_BMO,
cur.volume_60DPD_BMO,
cur.volume_90DPD_BMO,
cur.volume_30DPD_PEER,
cur.volume_60DPD_PEER,
cur.volume_90DPD_PEER
 
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  if(mod(cur.year_month,100)=1 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-1)
and pre.province=cur.province
order by cur.year_month,cur.product,cur.province;


--only get quarter data  , only for since last month rate or data ,201701-201801
with source as 
( select t.pi2_product product, t.year_month, s.province,
--all account 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_PEER
from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
 and mod(mod(t.year_month,100),3) = 0
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month,s.province )  
select cur.product , cur.year_month,cur.province,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) - if(pre.volume_BMO<>0,pre.volume_deli_BMO/pre.volume_BMO*100,null)  deliquency_SinceLast_BMO,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) deliquencyRate_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) - if(pre.volume_PEER<>0,pre.volume_deli_PEER/pre.volume_PEER*100,null) deliquency_SinceLast_PEER,

if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) deliquencyBalanceRate_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) deliquencyBalanceRate_PEER,

if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) - if(pre.balance_BMO<>0,pre.balance_deli_BMO/pre.balance_BMO*100,null)  deliquency_SinceLast_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) - if(pre.balance_PEER<>0,pre.balance_deli_PEER/pre.balance_PEER*100,null) deliquency_SinceLast_PEER,
 
cur.volume_BMO, 
cur.volume_deli_BMO,
cur.volume_PEER ,
cur.volume_deli_PEER,
cur.balance_BMO,
cur.balance_PEER,
cur.balance_deli_BMO,
cur.balance_deli_PEER
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  if(mod(cur.year_month,100)=3 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-3)
and pre.province=cur.province
order by  cur.year_month,cur.product ,province;
 



--only for by year
with source as 
( select t.pi2_product product, t.year_month, s.province
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_PEER
from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month )  
select cur.product , cur.year_month,
group by t.pi2_product,t.year_month,s.province )  
select cur.product , cur.year_month,cur.province,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) - if(pre.volume_BMO<>0,pre.volume_deli_BMO/pre.volume_BMO*100,null)  deliquency_SinceLast_BMO,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) deliquencyRate_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) - if(pre.volume_PEER<>0,pre.volume_deli_PEER/pre.volume_PEER*100,null) deliquency_SinceLast_PEER,

if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) deliquencyBalanceRate_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) deliquencyBalanceRate_PEER,

if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) - if(pre.balance_BMO<>0,pre.balance_deli_BMO/pre.balance_BMO*100,null)  deliquency_SinceLast_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) - if(pre.balance_PEER<>0,pre.balance_deli_PEER/pre.balance_PEER*100,null) deliquency_SinceLast_PEER,
 
cur.volume_BMO, 
cur.volume_deli_BMO,
cur.volume_PEER ,
cur.volume_deli_PEER,
cur.balance_BMO,
cur.balance_PEER,
cur.balance_deli_BMO,
cur.balance_deli_PEER


from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=   cur.year_month-100
and pre.province=cur.province
order by cur.product,province,cur.year_month,;


 


--chart 72 by risk , 201709-201801
with source as 
( select t.pi2_product product, t.year_month, s.province, s.ers_band,
--all account 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1') volume_30DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1') volume_30DPD_PEER ,


sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1') volume_60DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1') volume_60DPD_PEER ,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1',balance,0))  balance_90DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1',balance,0))  balance_90DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1') volume_90DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1') volume_90DPD_PEER  

from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month,s.province, s.ers_band)  
select cur.product , cur.year_month,cur.province, cur.ers_band,
 
cur.volume_BMO, 
cur.volume_deli_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,

cur.volume_PEER ,
cur.volume_deli_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) deliquencyRate_PEER,

 
cur.balance_deli_BMO,
cur.balance_deli_PEER,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) balanceRate_deli_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) balanceRate_deli_PEER

from source cur
 
order by cur.year_month,cur.product,cur.province, ers_band;

--chart 72 by age , 201709-201801
with source as 
( select t.pi2_product product, t.year_month, s.province, s.consumer_age_cat,
--all account 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1') volume_30DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1') volume_30DPD_PEER ,


sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1') volume_60DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1') volume_60DPD_PEER ,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1',balance,0))  balance_90DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1',balance,0))  balance_90DPD_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1') volume_90DPD_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and trade_status='1') volume_90DPD_PEER  

from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month,s.province, s.consumer_age_cat
)  
select cur.product , cur.year_month,cur.province, cur.consumer_age_cat,
 
cur.volume_BMO, 
cur.volume_deli_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,

cur.volume_PEER ,
cur.volume_deli_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) deliquencyRate_PEER,

 
cur.balance_deli_BMO,
cur.balance_deli_PEER,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) balanceRate_deli_BMO,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) balanceRate_deli_PEER

from source cur
 
order by cur.year_month,cur.product,cur.province, consumer_age_cat;

 