chart1 - largest growth product
select c.product_name ,c.count_BMO,c.count_PEER,l.count_BMO,l.count_PEER,
 if(l.count_BMO>0,round(((c.count_BMO/l.count_BMO) - 1)*100,2),0)  rateIncreasing ,
 max(if(l.count_BMO>0,round(((c.count_BMO/l.count_BMO) - 1)*100,2),0))  over() max_rateIncreasing,
round(if(l.count_PEER>0,round(((c.count_PEER/l.count_PEER) - 1)*100,2),0),2) rateIncreasing_peer ,
if(if(l.count_BMO>0,round(((c.count_BMO/l.count_BMO) - 1)*100,2),0)=max(if(l.count_BMO>0,round(((c.count_BMO/l.count_BMO) - 1)*100,2),0)) over(),c.product_name,'') max_product
from
( select  t1.product_name , sum( if(fi_name = "BANK OF MONTREAL",trade_count,0)) count_BMO, sum( if(peer_id =3,trade_count,0)) count_PEER 
from trade_vintages_n t1
where   year_month=201801
group by t1.product_name   ) c 
join (
select  t2.product_name , sum( if(fi_name = "BANK OF MONTREAL",trade_count,0)) count_BMO, sum( if(peer_id =3,trade_count,0)) count_PEER 
from trade_vintages_n t2
where   t2.year_month=201712
group by t2.product_name  ) l 
on c.product_name=l.product_name
order by c.product_name


--char 4 no of account
with cur as 
( select t.pi2_product product, 
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3) count_PEER ,
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL") Delinq_Accts_BMO ,
sum(payment_status='90+' and c.peer_id =3) Delinq_Accts_PEER,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_BMO,
sum(if(fi_name = "BANK OF MONTREAL",credit_limit,0))  credit_limit_BMO,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))/sum(if(fi_name = "BANK OF MONTREAL",credit_limit,0))*100 uti_rate_BMO,

sum(if(c.peer_id =3,balance,0))  balance_PEER,
sum(if(c.peer_id =3,credit_limit,0))  credit_limit_PEER
--sum(if(c.peer_id =3,balance,0))/sum(if(c.peer_id =3,credit_limit,0))*100 uti_rate_PEER

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
group by t.pi2_product ) ,

pre as 
( select t.pi2_product product, 
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3) count_PEER ,
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL") Delinq_Accts_BMO ,
sum(payment_status='90+' and c.peer_id =3) Delinq_Accts_PEER,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_BMO,
sum(if(fi_name = "BANK OF MONTREAL",credit_limit,0))  credit_limit_BMO,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))/sum(if(fi_name = "BANK OF MONTREAL",credit_limit,0))*100 uti_rate_BMO,

sum(if(c.peer_id =3,balance,0))  balance_PEER,
sum(if(c.peer_id =3,credit_limit,0))  credit_limit_PEER
--sum(if(c.peer_id =3,balance,0))/sum(if(c.peer_id =3,credit_limit,0))*100 uti_rate_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month=201712
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.pi2_product ) 

select cur.product , 
cur.count_BMO cur_accts ,pre.count_BMO pre_accts, round(cast(if(pre.count_BMO>0,(cur.count_BMO/pre.count_BMO - 1)*100,0) as decimal(6,3)),2) growthRate_BMO,
cur.count_PEER - cur.count_BMO cur_accts_peer,
pre.count_PEER - pre.count_BMO pre_accts_peer, 
round(cast(if(pre.count_PEER - pre.count_BMO>0,((cur.count_PEER-cur.count_BMO)/(pre.count_PEER-pre.count_BMO) - 1)*100,0) as decimal(6,3)),2) growthRate_PEER,
round(cast(if(pre.count_BMO>0,(cur.count_BMO/pre.count_BMO - 1)*100,0) as decimal(6,3)),2) - round(cast(if(pre.count_PEER - pre.count_BMO>0,((cur.count_PEER-cur.count_BMO)/(pre.count_PEER-pre.count_BMO) - 1)*100,0) as decimal(6,3)),2) varianceToPeer,

if(if(pre.count_BMO>0,round(((cur.count_BMO/pre.count_BMO) - 1)*100,2),0)=max(if(pre.count_BMO>0,round(((cur.count_BMO/pre.count_BMO) - 1)*100,2),0)) over(),cur.product,'') max_product,
if(pre.count_BMO>0,(cur.count_BMO/pre.count_BMO - 1)*100,0) noround_growthRate_BMO,
if(pre.count_PEER-pre.count_BMO>0,((cur.count_PEER-cur.count_BMO)/(pre.count_PEER-pre.count_BMO) - 1)*100,0) noround_growthRate_PEER
from cur
join pre
on  
  cur.product=pre.product
  order by cur.product;
  
--char 4 utilizaation rate  , chart 1 uti
  
 with cur as 
( select t.pi2_product product, 
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_BMO,
sum(if(fi_name = "BANK OF MONTREAL",credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL",balance,0))  balance_PEER,
sum(if(c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL",credit_limit,0))  credit_limit_PEER
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
group by t.pi2_product ) ,

pre as 
( select t.pi2_product product, 
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_BMO,
sum(if(fi_name = "BANK OF MONTREAL",credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL",balance,0))  balance_PEER,
sum(if(c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL",credit_limit,0))  credit_limit_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month=201712
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.pi2_product ) 

select cur.product , 
round(cast(if(cur.credit_limit_BMO<>0,cur.balance_BMO/cur.credit_limit_BMO*100,0) as decimal(6,3)),2)   cur_uti_rate_BMO,
round(cast(if(pre.credit_limit_BMO<>0, pre.balance_BMO/pre.credit_limit_BMO*100,0) as decimal(6,3)),2)  pre_uti_rate_BMO,
round(cast(if(cur.credit_limit_BMO<>0,cur.balance_BMO/cur.credit_limit_BMO*100,0)  - if(pre.credit_limit_BMO<>0, pre.balance_BMO/pre.credit_limit_BMO*100,0) as decimal(6,3)),2) * 100 uti_growthRate_BMO,

round(cast(if(cur.credit_limit_PEER<>0,cur.balance_PEER/cur.credit_limit_PEER*100,0) as decimal(6,3)),2) cur_uti_rate_PEER,
round(cast(if(pre.credit_limit_PEER<>0,pre.balance_PEER/pre.credit_limit_PEER*100,0) as decimal(6,3)),2) pre_uti_rate_PEER,
round(cast(if(cur.credit_limit_PEER<>0,cur.balance_PEER/cur.credit_limit_PEER*100,0) -if(pre.credit_limit_PEER<>0,pre.balance_PEER/pre.credit_limit_PEER*100,0)  as decimal(6,3)),2) * 100 uti_growthRate_PEER,

(if(cur.credit_limit_BMO<>0,cur.balance_BMO/cur.credit_limit_BMO*100,0) - if(pre.credit_limit_BMO<>0, pre.balance_BMO/pre.credit_limit_BMO*100,0)) - (if(cur.credit_limit_PEER<>0,cur.balance_PEER/cur.credit_limit_PEER*100,0) - if(pre.credit_limit_PEER<>0,pre.balance_PEER/pre.credit_limit_PEER*100,0)) varianceToPeer,

if(cur.credit_limit_BMO<>0,cur.balance_BMO/cur.credit_limit_BMO*100,0)    noround_cur_uti_rate_BMO,
if(pre.credit_limit_BMO<>0, pre.balance_BMO/pre.credit_limit_BMO*100,0)   noround_pre_uti_rate_BMO,
if(cur.credit_limit_PEER<>0,cur.balance_PEER/cur.credit_limit_PEER*100,0) noround_cur_uti_rate_PEER,
if(pre.credit_limit_PEER<>0,pre.balance_PEER/pre.credit_limit_PEER*100,0) noround_pre_uti_rate_PEER

from cur
join pre
on  
  cur.product=pre.product
  order by cur.product;
  
  
--chart 4  deliquency rate
with cur as 
( select t.pi2_product product, 
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL") Delinq_Accts_BMO ,
sum(payment_status='90+' and c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL") Delinq_Accts_PEER,
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
group by t.pi2_product ) ,
pre as 
( select t.pi2_product product, 
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL") Delinq_Accts_BMO ,
sum(payment_status='90+' and c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL") Delinq_Accts_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where  t.year_month=201712
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.pi2_product ) 
select cur.product , 
cur.count_BMO accts_BMO,
cur.Delinq_Accts_BMO deli_accts_BMO,
round(cast(if(cur.count_BMO>0,(cur.Delinq_Accts_BMO/cur.count_BMO)*100,0) as decimal(6,3)),2) cur_growthRate_BMO,
cur.count_PEER accts_PEER,
cur.delinq_Accts_PEER deli_accts_PEER,
round(cast(if(cur.count_PEER>0,(cur.Delinq_Accts_PEER/cur.count_PEER )*100,0) as decimal(6,3)),2) cur_growthRate_PEER,
pre.count_BMO pre_accts_BMO,
pre.Delinq_Accts_BMO pre_deli_accts_BMO,
round(cast(if(pre.count_BMO>0,(pre.Delinq_Accts_BMO/pre.count_BMO)*100,0) as decimal(6,3)),2) pre_growthRate_BMO,
pre.count_PEER pre_accts_PEER,
pre.delinq_Accts_PEER pre_deli_accts_PEER,
round(cast(if(pre.count_PEER>0,(pre.Delinq_Accts_PEER/pre.count_PEER )*100,0) as decimal(6,3)),2) pre_growthRate_PEER,
(if(cur.count_BMO>0,(cur.Delinq_Accts_BMO/cur.count_BMO)*100,0) - if(pre.count_BMO>0,(pre.Delinq_Accts_BMO/pre.count_BMO)*100,0))*100 bps_BMO,
(if(cur.count_PEER>0,(cur.Delinq_Accts_PEER/cur.count_PEER )*100,0) - if(pre.count_PEER>0,(pre.Delinq_Accts_PEER/pre.count_PEER )*100,0))*100 bps_PEER,
round(cast(if(pre.count_BMO>0,(cur.count_BMO/pre.count_BMO - 1)*100,0) as decimal(6,3)),2) - round(cast(if(pre.count_PEER - pre.count_BMO>0,((cur.count_PEER-cur.count_BMO)/(pre.count_PEER-pre.count_BMO) - 1)*100,0) as decimal(6,3)),2) varianceToPeer,
if(if(cur.count_BMO>0,(cur.Delinq_Accts_BMO/cur.count_BMO)*100,0)=max(if(cur.count_BMO>0,(cur.Delinq_Accts_BMO/cur.count_BMO)*100,0)) over(),cur.product,'') max_product,
from cur
join pre
on  cur.product=pre.product
order by cur.product;


----- for developer

with cur as 
( select t.pi2_product product, 
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL") Delinq_Accts_BMO ,
sum(payment_status='90+' and c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL") Delinq_Accts_PEER
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
group by t.pi2_product ) ,
pre as 
( select t.pi2_product product, 
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL") Delinq_Accts_BMO ,
sum(payment_status='90+' and c.peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL") Delinq_Accts_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where  t.year_month=201712
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.pi2_product ) 
select cur.product , 
round(cast(if(cur.count_BMO>0,(cur.Delinq_Accts_BMO/cur.count_BMO)*100,0) as decimal(6,3)),2) cur_growthRate_BMO,
round(cast(if(pre.count_BMO>0,(pre.Delinq_Accts_BMO/pre.count_BMO)*100,0) as decimal(6,3)),2) pre_growthRate_BMO,
(if(cur.count_BMO>0,(cur.Delinq_Accts_BMO/cur.count_BMO)*100,0) - if(pre.count_BMO>0,(pre.Delinq_Accts_BMO/pre.count_BMO)*100,0))*100 bps_BMO,
round(cast(if(cur.count_PEER>0,(cur.Delinq_Accts_PEER/cur.count_PEER )*100,0) as decimal(6,3)),2) cur_growthRate_PEER,
round(cast(if(pre.count_PEER>0,(pre.Delinq_Accts_PEER/pre.count_PEER )*100,0) as decimal(6,3)),2) pre_growthRate_PEER,
(if(cur.count_PEER>0,(cur.Delinq_Accts_PEER/cur.count_PEER )*100,0) - if(pre.count_PEER>0,(pre.Delinq_Accts_PEER/pre.count_PEER )*100,0))*100 bps_PEER,
round(cast(if(pre.count_BMO>0,(cur.count_BMO/pre.count_BMO - 1)*100,0) as decimal(6,3)),2) - round(cast(if(pre.count_PEER - pre.count_BMO>0,((cur.count_PEER-cur.count_BMO)/(pre.count_PEER-pre.count_BMO) - 1)*100,0) as decimal(6,3)),2) varianceToPeer,
if(if(cur.count_BMO>0,(cur.Delinq_Accts_BMO/cur.count_BMO)*100,0)=max(if(cur.count_BMO>0,(cur.Delinq_Accts_BMO/cur.count_BMO)*100,0)) over(),cur.product,'') max_product
from cur
join pre
on  cur.product=pre.product
order by cur.product;



