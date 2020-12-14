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


select c.product_name ,c.count_BMO,c.count_PEER,l.count_BMO,l.count_PEER,
cast(if(l.count_BMO>0,(c.count_BMO/l.count_BMO - 1)*100,0) as decimal(6,2))   rateIncreasing ,
 max(cast(if(l.count_BMO>0,(c.count_BMO/l.count_BMO - 1)*100,0) as decimal(6,2)))  over() max_rateIncreasing,
cast(if(l.count_PEER>0,(c.count_PEER/l.count_PEER - 1)*100,0) as decimal(6,2)) rateIncreasing_peer ,
if(cast(if(l.count_BMO>0,(c.count_BMO/l.count_BMO - 1)*100,0) as decimal(6,2))=max(cast(if(l.count_BMO>0,(c.count_BMO/l.count_BMO - 1)*100,0) as decimal(6,2)))  over(),c.product_name,'') max_product
from
( select  t1.product_name , sum( if(fi_name = "BANK OF MONTREAL",trade_count,0)) count_BMO, sum( if(peer_id =3,trade_count,0)) count_PEER 
from trade_vintages_n t1
where   year_month=201801
group by t1.product_name   ) c 
left join (
select  t2.product_name , sum( if(fi_name = "BANK OF MONTREAL",trade_count,0)) count_BMO, sum( if(peer_id =3,trade_count,0)) count_PEER 
from trade_vintages_n t2
where   t2.year_month=201712
group by t2.product_name  ) l 
on c.product_name=l.product_name
order by c.product_name;


 select  
       count(*) trade_count, 
       sum(balance) total_balance, 
       sum(credit_limit) total_credit,
        
       cast( sum(balance)/sum(credit_limit) * 100 as decimal(6,2)) Utilization_Rate
from 

( select * from pi2_development_db.pi2_trade_n
where  
 	  joint_flag = 'P'
     and vintage_month >= 201201
	 and year_month=201801

 ) t
join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
  
) c
on t.fi_id = c.fi_id
and t.year_month=c.year_month

join pi2_development_db.pi2_consumer_n s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
where  
  pi2_product='Auto Finance'
and joint_flag='P'
and fi_name='BANK OF MONTREAL'

--it is different from the chart
select pi2_product,count(*) , sum(balance),sum(credit_limit)
from pi2_trade_n
where year_month=201801
and joint_flag='P'
group by pi2_product;

select product_name,count(*) , sum(balance),sum(credit_limit)
from pi2_trade_n
where year_month=201801
and joint_flag='P'
group by product_name;

--deliquency rateIncreasing
chart 4:

Delinquency Rate:
with cur as 
( select t.pi2_product product, 
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3) count_PEER ,
sum(delinquency_cat='90Days' and c.fi_name = "BANK OF MONTREAL") Delinquent_Accounts_BMO ,
sum(delinquency_cat='90Days' and c.peer_id =3) Delinquent_Accounts_PEER,
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
and rate in ('0', '1', '2', '3', '4', '5', '7', '8', '9')
and t.joint_flag="P" 
and t.vintage_month >=201201
group by t.pi2_product ) ,

 pre as 
( select t.pi2_product product, 
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3) count_PEER ,
sum(delinquency_cat='90Days' and c.fi_name = "BANK OF MONTREAL") Delinquent_Accounts_BMO ,
sum(delinquency_cat='90Days' and c.peer_id =3) Delinquent_Accounts_PEER,
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
and rate in ('0', '1', '2', '3', '4', '5', '7', '8', '9')
and t.joint_flag="P" 
and t.vintage_month >=201201
group by t.pi2_product ) 

select cur.product , cur.count_BMO,cur.count_PEER,pre.count_BMO,pre.count_PEER,

cast(if(pre.count_BMO>0,(cur.count_BMO/pre.count_BMO - 1)*100,0) as decimal(6,2)) account_rate_BMO,
cast(if(pre.count_PEER>0,(cur.count_PEER/pre.count_PEER - 1)*100,0) as decimal(6,2)) account_rate_PEER,
if(if(pre.count_BMO>0,round(((cur.count_BMO/pre.count_BMO) - 1)*100,2),0)=max(if(pre.count_BMO>0,round(((cur.count_BMO/pre.count_BMO) - 1)*100,2),0)) over(),cur.product,'') max_product,

cur.Delinquent_Accounts_BMO, cur.Delinquent_Accounts_PEER,
pre.Delinquent_Accounts_BMO, pre.Delinquent_Accounts_PEER,

cast(if(pre.Delinquent_Accounts_BMO>0,(cur.Delinquent_Accounts_BMO/pre.Delinquent_Accounts_BMO - 1)*100,0) as decimal(6,2)) Delinquent_rate_BMO,
cast(if(pre.Delinquent_Accounts_PEER>0,(cur.Delinquent_Accounts_PEER/pre.Delinquent_Accounts_PEER - 1)*100,0) as decimal(6,2)) Delinquent_rate_PEER,

if(if(pre.Delinquent_Accounts_BMO>0,(cur.Delinquent_Accounts_BMO/pre.Delinquent_Accounts_BMO - 1)*100,0)=max(if(pre.Delinquent_Accounts_BMO>0,(cur.Delinquent_Accounts_BMO/pre.Delinquent_Accounts_BMO - 1)*100,0)) over(),cur.product,'') max_Deli_product,

if(cur.credit_limit_BMO<>0,cur.balance_BMO/cur.credit_limit_BMO*100,0) cur_uti_rate_BMO,
if(cur.credit_limit_PEER<>0,cur.balance_PEER/cur.credit_limit_PEER*100,0) cur_uti_rate_PEER,
if(pre.credit_limit_BMO<>0, pre.balance_BMO/pre.credit_limit_BMO*100,0)   pre_uti_rate_BMO,
if(pre.credit_limit_PEER<>0,pre.balance_PEER/pre.credit_limit_PEER*100,0) pre_uti_rate_PEER,
 

(if(cur.credit_limit_BMO<>0,cur.balance_BMO/cur.credit_limit_BMO*100,0) - if(pre.credit_limit_BMO<>0, pre.balance_BMO/pre.credit_limit_BMO*100,0)) * 100 uti_bps_BMO,
(if(cur.credit_limit_PEER<>0,cur.balance_PEER/cur.credit_limit_PEER*100,0) - if(pre.credit_limit_PEER<>0,pre.balance_PEER/pre.credit_limit_PEER*100,0)) * 100 uti_bps_PEER
from cur
join pre
on  
  cur.product=pre.product
  order by cur.product;
  
--chart 4 , no of accounts
select c.product_name ,c.count_BMO cur_accts,l.count_BMO pre_accts ,
cast(if(l.count_BMO>0,(c.count_BMO/l.count_BMO - 1)*100,0) as decimal(6,2))  growthRate_BMO ,
c.count_PEER cur_accts_peer ,l.count_PEER pre_accts_peer,
cast(if(l.count_PEER>0,(c.count_PEER/l.count_PEER - 1)*100,0) as decimal(6,2)) growthRate_peer ,
max(cast(if(l.count_BMO>0,(c.count_BMO/l.count_BMO - 1)*100,0) as decimal(6,2)))  over() max_growthRate_BMO,
if(cast(if(l.count_BMO>0,(c.count_BMO/l.count_BMO - 1)*100,0) as decimal(6,2))=max(cast(if(l.count_BMO>0,(c.count_BMO/l.count_BMO - 1)*100,0) as decimal(6,2)))  over(),c.product_name,'') maxGrowth_product
from
( select  t1.product_name , sum( if(fi_name = "BANK OF MONTREAL",trade_count,0)) count_BMO, sum( if(peer_id =3,trade_count,0)) count_PEER 
from trade_vintages_n t1
where   year_month=201801
group by t1.product_name   ) c 
left join (
select  t2.product_name , sum( if(fi_name = "BANK OF MONTREAL",trade_count,0)) count_BMO, sum( if(peer_id =3,trade_count,0)) count_PEER 
from trade_vintages_n t2
where   t2.year_month=201712
group by t2.product_name  ) l 
on c.product_name=l.product_name
order by c.product_name;

--chart 4 , utilization rate
select c.product_name ,
cast( if(c.credit_BMO<>0,c.balance_BMO/c.credit_BMO*100,0) as decimal(8,2)) Rate_BMO,
cast( if(l.credit_BMO<>0,l.balance_BMO/l.credit_BMO*100,0) as decimal(8,2)) pre_Rate_BMO,
floor((if(c.credit_BMO<>0,c.balance_BMO/c.credit_BMO*100,0) - if(l.credit_BMO<>0,l.balance_BMO/l.credit_BMO*100,0)) * 100) growthRate_BMO,
 
cast( if(c.credit_PEER<>0,c.balance_PEER/c.credit_PEER*100,0)  as decimal(8,2)) Rate_PEER,
cast( if(l.credit_PEER<>0,l.balance_PEER/l.credit_PEER*100,0)   as decimal(8,2))pre_Rate_PEER,
floor((if(c.credit_PEER<>0,c.balance_PEER/c.credit_PEER*100,0) - if(l.credit_PEER<>0,l.balance_PEER/l.credit_PEER*100,0)) * 100) growthRate_PEER,

cast (( if(c.credit_BMO<>0,c.balance_BMO/c.credit_BMO*100,0) - if(l.credit_BMO<>0,l.balance_BMO/l.credit_BMO*100,0) ) - (if(c.credit_PEER<>0,c.balance_PEER/c.credit_PEER*100,0) - l.balance_PEER/l.credit_PEER*100)  as decimal(8,2)) varianceToPeer,

c.balance_BMO/c.credit_BMO*100 		noRound_Rate_BMO,
l.balance_BMO/l.credit_BMO*100 		noRound_pre_Rate_BMO,
                                    noRound_
c.balance_PEER/c.credit_PEER*100 	noRound_Rate_PEER,
l.balance_PEER/l.credit_PEER*100 	noRound_pre_Rate_PEER
from
( select  t1.product_name , 
sum( if(fi_name = "BANK OF MONTREAL",total_balance ,0)) balance_BMO, sum( if(peer_id =3,total_balance ,0)) balance_PEER ,
sum( if(fi_name = "BANK OF MONTREAL",total_credit ,0)) credit_BMO, sum( if(peer_id =3,total_credit ,0)) credit_PEER 
from trade_vintages_n t1
where   year_month=201801
group by t1.product_name   ) c 
left join (
select  t2.product_name , 
sum( if(fi_name = "BANK OF MONTREAL",total_balance ,0)) balance_BMO, sum( if(peer_id =3,total_balance ,0)) balance_PEER ,
sum( if(fi_name = "BANK OF MONTREAL",total_credit ,0)) credit_BMO, sum( if(peer_id =3,total_credit ,0)) credit_PEER 
from trade_vintages_n t2
where   t2.year_month=201712
group by t2.product_name  ) l 
on c.product_name=l.product_name
order by c.product_name;

--chart 4 , deliquency Rate





 
