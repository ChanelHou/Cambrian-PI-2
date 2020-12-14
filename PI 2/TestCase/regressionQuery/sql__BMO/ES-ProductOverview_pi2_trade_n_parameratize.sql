
--char 4 no of account
--by month 201803 , 201802
--by quarter 201803,201712
--by year 201803, 201703

--gold 201809,201808
--201809,201806
--201809,201709
With source_new as ( select * from (
with source as 
( select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "fiClient"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, t.pi2_product product, 
count(1) volume,
sum(balance)  balance,
sum(credit_limit)  credit_limit,
round(cast(if(sum(credit_limit)<>0,sum(balance)/sum(credit_limit)*100,0) as decimal(6,3)),2) uti_rate,
sum(payment_status='90+') Delinq_Accts ,
if(count(1)<>0,sum(payment_status='90+')/count(1)*100,null) delinquencyByAcct_rate,
sum(if(payment_status='90+',balance,0))  balance_Deli,
if(sum(balance)<>0,sum(if(payment_status='90+',balance,0))/sum(balance)*100,null) delinquencyByBalance_rate
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month  in ( ${curMonth} , ${preMonth})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,  case when fi_name = "BANK OF MONTREAL" then "fiClient"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   , t.pi2_product ) 
select fiClient.year_month,fiClient.product,
fiClient.volume volume_fiClient,
fiClient.balance balance_fiClient,
fiClient.credit_limit credit_limit_fiClient,
fiClient.uti_rate uti_rate_fiClient,
fiClient.delinquencyByAcct_rate delinquencyByAcct_rate_fiClient,
fiClient.delinquencyByBalance_rate delinquencyByBalance_rate_fiClient,
fiClient.delinq_Accts deli_accts_fiClient,
fiClient.balance_Deli balance_Deli_fiClient,
PEER.volume volume_PEER,
PEER.balance balance_PEER,
PEER.credit_limit credit_limit_PEER,
PEER.delinq_Accts deli_accts_PEER,
PEER.balance_Deli balance_Deli_PEER,
PEER.uti_rate uti_rate_PEER,
PEER.delinquencyByAcct_rate delinquencyByAcct_rate_PEER,
PEER.delinquencyByBalance_rate delinquencyByBalance_rate_PEER
from source fiClient
left join source PEER
on fiClient.year_month=PEER.year_month
and fiClient.product=PEER.product
where fiClient.fi_cat='fiClient'
and PEER.fi_cat='Peer'
) a )
select cur.year_month,cur.product , 
--chart 4 - no of account , chart 1 , accounts
cur.volume_fiClient cur_volume_fiClient ,
pre.volume_fiClient pre_volume_fiClient,
 round(cast(if(pre.volume_fiClient>0,(cur.volume_fiClient/pre.volume_fiClient - 1)*100,0) as decimal(6,3)),3) sinceLastRate_acct_fiClient,
 cur.volume_PEER cur_volume_PEER ,
pre.volume_PEER pre_volume_PEER,
round(cast(if(pre.volume_PEER>0,(cur.volume_PEER/pre.volume_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_PEER,
round(cast(if(pre.volume_fiClient>0,(cur.volume_fiClient/pre.volume_fiClient - 1)*100,0) as decimal(6,3)),2) - round(cast(if(pre.volume_PEER>0,(cur.volume_PEER/pre.volume_PEER - 1)*100,0) as decimal(6,3)),2) variance_volume_ToPeer,
--chart 4 utilization , chart 1 
 cur.uti_rate_fiClient cur_uti_rate_fiClient,
pre.uti_rate_fiClient pre_uti_rate_fiClient,
 (cur.uti_rate_fiClient - pre.uti_rate_fiClient)*100 sinceLast_bps_uti_rate_fiClient,
  cur.uti_rate_PEER cur_uti_rate_PEER,
pre.uti_rate_PEER pre_uti_rate_PEER,
 (cur.uti_rate_PEER - pre.uti_rate_PEER)*100 sinceLast_bps_uti_rate_PEER,
 (cur.uti_rate_fiClient - pre.uti_rate_fiClient) - (cur.uti_rate_PEER - pre.uti_rate_PEER) variance_uti_rate_peer,
 --chart 2 delinquencyByacct , chart 2
 
 
 cur.deli_accts_fiClient cur_deli_accts_fiClient,
 pre.deli_accts_fiClient pre_deli_accts_fiClient,
 if(pre.deli_accts_fiClient<>0,(cur.deli_accts_fiClient/pre.deli_accts_fiClient-1)*100,0) SinceLast_Deli_accts_fiClient,
 cur.deli_accts_PEER cur_deli_accts_PEER,
 pre.deli_accts_PEER pre_deli_accts_PEER,
 if(pre.deli_accts_PEER<>0,(cur.deli_accts_PEER/pre.deli_accts_PEER-1)*100,0) SinceLast_Deli_accts_PEER,
 
  --chart 4 by delinquency by balance
 cur.delinquencyByBalance_rate_fiClient cur_delinquencyByBalance_rate_fiClient,
 pre.delinquencyByBalance_rate_fiClient pre_delinquencyByBalance_rate_fiClient,
 (cur.delinquencyByBalance_rate_fiClient - pre.delinquencyByBalance_rate_fiClient)*100 sinceLast_bps_delinquencyByBalance_rate_fiClient,
  cur.delinquencyByBalance_rate_PEER cur_delinquencyByBalance_rate_PEER,
 pre.delinquencyByBalance_rate_PEER pre_delinquencyByBalance_rate_PEER,
 (cur.delinquencyByBalance_rate_PEER - pre.delinquencyByBalance_rate_PEER)*100 sinceLast_bps_delinquencyByBalance_rate_PEER,
 (cur.delinquencyByBalance_rate_fiClient - pre.delinquencyByBalance_rate_fiClient) - (cur.delinquencyByBalance_rate_PEER - pre.delinquencyByBalance_rate_PEER) variance_delinquency_rate_peer,
pre.volume_fiClient pre_accts,
cur.volume_PEER - cur.volume_fiClient curVariance_accts_peer,
pre.volume_PEER - pre.volume_fiClient preVariance_accts_peer
from source_new cur
left join source_new pre
on pre.product=cur.product
where cur.year_month=${curMonth}
and pre.year_month= ${preMonth}  
order by cur.year_month,cur.product;




----new requirement in 2018-11-09
--AS statet in brd top 2 Charts are adjusted as follows

--Highest risk product is determined as product with lowest avg score at total market

--we determine this by using all product for all FI categories and filter out joint trades.

--Similar to this Largest Growing Product is determined as product with largest growth on total market meaning we take all products for all FI's filter out joint trades and determine LGP, IN top 2 charts figures are shown for the determined product (HRP or LGP) for FI and pee
--201712,201803
--201709,201712
--201703,201803
with source as (
select t.year_month ,t.pi2_product product,
count(1) totalVolume,
sum(s.ers_score) totalScore ,
sum(s.ers_score)/count(1) averageScore

from pi2_trade_n t
 
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month in ( ${preMonth} ,${curMonth})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
 
group by t.pi2_product,t.year_month )
select cur.year_month,cur.product,cur.totalVolume ,cur.totalScore,cur.averageScore,
 (cur.totalVolume/pre.totalVolume  - 1)*100 growthRate
 from source cur
 left join source pre
 on cur.year_month=${curMonth}
 and pre.year_month=${preMonth}
and cur.product=pre.product
order by cur.year_month,cur.product ;


with source as (
select t.year_month ,t.pi2_product product,
count(1) totalVolume,
sum(s.ers_score) totalScore ,
sum(s.ers_score)/count(1) averageScore

from pi2_trade_n t
 
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month in ( ${curMonth},${preMonth} )
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
 and t.pi2_product in (${productList})
group by t.pi2_product,t.year_month )
select cur.year_month,cur.product,cur.totalVolume ,cur.totalScore,cur.averageScore,
 (cur.totalVolume/pre.totalVolume  - 1)*100 growthRate,
 
 
 if(cur.averageScore=min(cur.averageScore)  over(partition by cur.year_month),cur.product,'') highestRiskProduct
 ,
 if((cur.totalVolume/pre.totalVolume  - 1)*100 = max((cur.totalVolume/pre.totalVolume  - 1)*100) over(partition by cur.year_month) ,cur.product,'')  largestGrowthProduct
 from source cur
 join source pre
 on cur.year_month=${curMonth}
 and pre.year_month=${preMonth}
and cur.product=pre.product
order by cur.year_month,cur.product ;



--comment from Marinko  , highestRisk

with source as ( 
select t.pi2_product,
sum(s.ers_score)/count(1) averageScore,

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)

join pi2_consumer_n as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
t.year_month = 201801
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
p by t.pi2_product,t.year_month )
select pi2_product from source 
Where 
order by averageScore Asc limit 1

 