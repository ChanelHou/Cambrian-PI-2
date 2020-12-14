
--char 4 no of account
--by month 201801 , 201712
--by quarter 201712,201709
--by year 201801, 201701
With source_new as ( select * from (
with source as 
( select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
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
group by t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   , t.pi2_product ) 
select BMO.year_month,BMO.product,
BMO.volume volume_BMO,
BMO.balance balance_BMO,
BMO.credit_limit credit_limit_BMO,
BMO.uti_rate uti_rate_BMO,
BMO.delinquencyByAcct_rate delinquencyByAcct_rate_BMO,
BMO.delinquencyByBalance_rate delinquencyByBalance_rate_BMO,
BMO.delinq_Accts deli_accts_BMO,
BMO.balance_Deli balance_Deli_BMO,
PEER.volume volume_PEER,
PEER.balance balance_PEER,
PEER.credit_limit credit_limit_PEER,
PEER.delinq_Accts deli_accts_PEER,
PEER.balance_Deli balance_Deli_PEER,
PEER.uti_rate uti_rate_PEER,
PEER.delinquencyByAcct_rate delinquencyByAcct_rate_PEER,
PEER.delinquencyByBalance_rate delinquencyByBalance_rate_PEER
from source BMO
join source PEER
on BMO.year_month=PEER.year_month
and BMO.product=PEER.product
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
) a )
select cur.year_month,cur.product , 
--chart 4 - no of account , chart 1 , accounts
cur.volume_BMO cur_volume_BMO ,
pre.volume_BMO pre_volume_BMO,
 round(cast(if(pre.volume_BMO>0,(cur.volume_BMO/pre.volume_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_BMO,
 cur.volume_PEER cur_volume_PEER ,
pre.volume_PEER pre_volume_PEER,
round(cast(if(pre.volume_PEER>0,(cur.volume_PEER/pre.volume_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_PEER,
round(cast(if(pre.volume_BMO>0,(cur.volume_BMO/pre.volume_BMO - 1)*100,0) as decimal(6,3)),2) - round(cast(if(pre.volume_PEER>0,(cur.volume_PEER/pre.volume_PEER - 1)*100,0) as decimal(6,3)),2) variance_volume_ToPeer,
--chart 4 utilization , chart 1 
 cur.uti_rate_BMO cur_uti_rate_BMO,
pre.uti_rate_BMO pre_uti_rate_BMO,
 (cur.uti_rate_BMO - pre.uti_rate_BMO)*100 sinceLast_bps_uti_rate_BMO,
  cur.uti_rate_PEER cur_uti_rate_PEER,
pre.uti_rate_PEER pre_uti_rate_PEER,
 (cur.uti_rate_PEER - pre.uti_rate_PEER)*100 sinceLast_bps_uti_rate_PEER,
 (cur.uti_rate_BMO - pre.uti_rate_BMO) - (cur.uti_rate_PEER - pre.uti_rate_PEER) variance_uti_rate_peer,
 --chart 2 delinquencyByacct , chart 2
 
 
 cur.deli_accts_BMO cur_deli_accts_BMO,
 pre.deli_accts_BMO pre_deli_accts_BMO,
 if(pre.deli_accts_BMO<>0,(cur.deli_accts_BMO/pre.deli_accts_BMO-1)*100,0) SinceLast_Deli_accts_BMO,
 cur.deli_accts_PEER cur_deli_accts_PEER,
 pre.deli_accts_PEER pre_deli_accts_PEER,
 if(pre.deli_accts_PEER<>0,(cur.deli_accts_PEER/pre.deli_accts_PEER-1)*100,0) SinceLast_Deli_accts_PEER,
 
  --chart 4 by delinquency by balance
 cur.delinquencyByBalance_rate_BMO cur_delinquencyByBalance_rate_BMO,
 pre.delinquencyByBalance_rate_BMO pre_delinquencyByBalance_rate_BMO,
 (cur.delinquencyByBalance_rate_BMO - pre.delinquencyByBalance_rate_BMO)*100 sinceLast_bps_delinquencyByBalance_rate_BMO,
  cur.delinquencyByBalance_rate_PEER cur_delinquencyByBalance_rate_PEER,
 pre.delinquencyByBalance_rate_PEER pre_delinquencyByBalance_rate_PEER,
 (cur.delinquencyByBalance_rate_PEER - pre.delinquencyByBalance_rate_PEER)*100 sinceLast_bps_delinquencyByBalance_rate_PEER,
 (cur.delinquencyByBalance_rate_BMO - pre.delinquencyByBalance_rate_BMO) - (cur.delinquencyByBalance_rate_PEER - pre.delinquencyByBalance_rate_PEER) variance_delinquency_rate_peer,
if(if(pre.volume_BMO>0,round(((cur.volume_BMO/pre.volume_BMO) - 1)*100,2),0)=max(if(pre.volume_BMO>0,round(((cur.volume_BMO/pre.volume_BMO) - 1)*100,2),0)) over(),cur.product,'') max_product,
pre.volume_BMO pre_accts,
cur.volume_PEER - cur.volume_BMO curVariance_accts_peer,
pre.volume_PEER - pre.volume_BMO preVariance_accts_peer
from source_new cur
left join source_new pre
on pre.product=cur.product
where cur.year_month=${curMonth}
and pre.year_month= ${preMonth}  
order by cur.year_month,cur.product;

 
  
 


