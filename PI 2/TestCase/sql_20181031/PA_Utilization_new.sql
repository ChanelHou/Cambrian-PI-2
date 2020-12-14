--chart 37-40,  by all account  by months ,can use same data as es-overview
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
round(cast(if(pre.volume_BMO>0,(cur.volume_BMO/pre.volume_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_BMO,
cur.volume_PEER cur_volume_PEER ,
round(cast(if(pre.volume_PEER>0,(cur.volume_PEER/pre.volume_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_PEER,

cur.balance_BMO cur_balance_BMO ,
round(cast(if(pre.balance_BMO>0,(cur.balance_BMO/pre.balance_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_BMO,
cur.balance_PEER cur_balance_PEER ,
round(cast(if(pre.balance_PEER>0,(cur.balance_PEER/pre.balance_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_PEER,

cur.credit_limit_BMO cur_credit_limit_BMO ,
round(cast(if(pre.credit_limit_BMO>0,(cur.credit_limit_BMO/pre.credit_limit_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_BMO,
cur.credit_limit_PEER cur_credit_limit_PEER ,
round(cast(if(pre.credit_limit_PEER>0,(cur.credit_limit_PEER/pre.credit_limit_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_PEER,

 
cur.uti_rate_BMO cur_uti_rate_BMO,
(cur.uti_rate_BMO - pre.uti_rate_BMO)*100 sinceLast_bps_uti_rate_BMO,
cur.uti_rate_PEER cur_uti_rate_PEER,
(cur.uti_rate_PEER - pre.uti_rate_PEER)*100 sinceLast_bps_uti_rate_PEER 
 
from source_new cur
left join source_new pre
on pre.product=cur.product
where cur.year_month=${curMonth}
and pre.year_month= ${preMonth}  
order by cur.year_month,cur.product;

--chart 40 defect 25
select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, t.pi2_product product, 
--count(1) volume,
sum(balance)  balance,
sum(credit_limit)  credit_limit,
round(cast(if(sum(credit_limit)<>0,sum(balance)/sum(credit_limit)*100,0) as decimal(6,3)),2) uti_rate,
 sum(balance) /count(1) avg_balance,
 sum(credit_limit)/count(1) avg_credit
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month  between   ${fromMonth} and ${toMonth} 
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   , t.pi2_product  ;
			  
			  




--only get quarter data  , only for since last month rate or data
with source as 
( select t.pi2_product product, t.year_month,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,

--new account
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_PEER

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
 and mod(mod(t.year_month,100),3) = 0
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month )  
select cur.product , cur.year_month,
--utilizationRate
cur.balance_BMO/cur.credit_limit_BMO*100 cur_uti_BMO, 
pre.balance_BMO/pre.credit_limit_BMO*100 pre_uti_BMO,
((cur.balance_BMO/cur.credit_limit_BMO*100) - (pre.balance_BMO/pre.credit_limit_BMO*100)) * 100 uti_BMO_sinceLast,
cur.balance_PEER/cur.credit_limit_PEER cur_uti_PEER, 
pre.balance_PEER/pre.credit_limit_PEER pre_uti_PEER,
((cur.balance_PEER/cur.credit_limit_PEER*100) - (pre.balance_PEER/pre.credit_limit_PEER*100)) * 100 uti_PEER_sinceLast,

--balance
cur.balance_BMO cur_balance_BMO, 
pre.balance_BMO pre_balance_BMO,
if(pre.balance_BMO<>0,(cur.balance_BMO/pre.balance_BMO -1)*100,null) balanceRate_BMO_sinceLast,
cur.balance_PEER ,
pre.balance_PEER,
if(pre.balance_PEER<>0,(cur.balance_PEER/pre.balance_PEER -1)*100,null) balanceRate_PEER_sinceLast,

--limit
cur.credit_limit_BMO, 
pre.credit_limit_BMO,
if(pre.credit_limit_BMO<>0,(cur.credit_limit_BMO/pre.credit_limit_BMO -1)*100,null) credit_limitRate_BMO_sinceLast,
cur.credit_limit_PEER ,
pre.credit_limit_PEER,
if(pre.credit_limit_PEER<>0,(cur.credit_limit_PEER/pre.credit_limit_PEER -1)*100,null) credit_limitRate_PEER_sinceLast,


--utilizationRate
cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO cur_uti_newAcct_M_BMO, 
pre.balance_newAcct_M_BMO/pre.credit_limit_newAcct_M_BMO pre_uti_newAcct_M_BMO,
((cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO*100) - (pre.balance_newAcct_M_BMO/pre.credit_limit_newAcct_M_BMO*100)) * 100 uti_newAcct_M_BMO_sinceLast,
cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER cur_uti_newAcct_M_PEER, 
pre.balance_newAcct_M_PEER/pre.credit_limit_newAcct_M_PEER pre_uti_newAcct_M_PEER,
((cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER*100) - (pre.balance_newAcct_M_PEER/pre.credit_limit_newAcct_M_PEER*100)) * 100 uti_newAcct_M_PEER_sinceLast,

--balance
cur.balance_newAcct_M_BMO, 
pre.balance_newAcct_M_BMO,
if(pre.balance_newAcct_M_BMO<>0,(cur.balance_newAcct_M_BMO/pre.balance_newAcct_M_BMO -1)*100,null) balanceRate_newAcct_M_BMO_sinceLast,
cur.balance_newAcct_M_PEER ,
pre.balance_newAcct_M_PEER,
if(pre.balance_newAcct_M_PEER<>0,(cur.balance_newAcct_M_PEER/pre.balance_newAcct_M_PEER -1)*100,null) balanceRate_newAcct_M_PEER_sinceLast,

--limit
cur.credit_limit_newAcct_M_BMO, 
pre.credit_limit_newAcct_M_BMO,
if(pre.credit_limit_newAcct_M_BMO<>0,(cur.credit_limit_newAcct_M_BMO/pre.credit_limit_newAcct_M_BMO -1)*100,null) credit_limitRate_newAcct_M_BMO_sinceLast,
cur.credit_limit_newAcct_M_PEER ,
pre.credit_limit_newAcct_M_PEER,
if(pre.credit_limit_newAcct_M_PEER<>0,(cur.credit_limit_newAcct_M_PEER/pre.credit_limit_newAcct_M_PEER -1)*100,null) credit_limitRate_newAcct_M_PEER_sinceLast,


--utilizationRate
cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO cur_uti_newAcct_Q_BMO, 
pre.balance_newAcct_Q_BMO/pre.credit_limit_newAcct_Q_BMO pre_uti_newAcct_Q_BMO,
((cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO*100) - (pre.balance_newAcct_Q_BMO/pre.credit_limit_newAcct_Q_BMO*100)) * 100 uti_newAcct_Q_BMO_sinceLast,
cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER cur_uti_newAcct_Q_PEER, 
pre.balance_newAcct_Q_PEER/pre.credit_limit_newAcct_Q_PEER pre_uti_newAcct_Q_PEER,
((cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER*100) - (pre.balance_newAcct_Q_PEER/pre.credit_limit_newAcct_Q_PEER*100)) * 100 uti_newAcct_Q_PEER_sinceLast,

--balance
cur.balance_newAcct_Q_BMO, 
pre.balance_newAcct_Q_BMO,
if(pre.balance_newAcct_Q_BMO<>0,(cur.balance_newAcct_Q_BMO/pre.balance_newAcct_Q_BMO -1)*100,null) balanceRate_newAcct_Q_BMO_sinceLast,
cur.balance_newAcct_Q_PEER ,
pre.balance_newAcct_Q_PEER,
if(pre.balance_newAcct_Q_PEER<>0,(cur.balance_newAcct_Q_PEER/pre.balance_newAcct_Q_PEER -1)*100,null) balanceRate_newAcct_Q_PEER_sinceLast,

--limit
cur.credit_limit_newAcct_Q_BMO, 
pre.credit_limit_newAcct_Q_BMO,
if(pre.credit_limit_newAcct_Q_BMO<>0,(cur.credit_limit_newAcct_Q_BMO/pre.credit_limit_newAcct_Q_BMO -1)*100,null) credit_limitRate_newAcct_Q_BMO_sinceLast,
cur.credit_limit_newAcct_Q_PEER ,
pre.credit_limit_newAcct_Q_PEER,
if(pre.credit_limit_newAcct_Q_PEER<>0,(cur.credit_limit_newAcct_Q_PEER/pre.credit_limit_newAcct_Q_PEER -1)*100,null) credit_limitRate_newAcct_Q_PEER_sinceLast,

--utilizationRate
cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO cur_uti_newAcct_Y_BMO, 
pre.balance_newAcct_Y_BMO/pre.credit_limit_newAcct_Y_BMO pre_uti_newAcct_Y_BMO,
((cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO*100) - (pre.balance_newAcct_Y_BMO/pre.credit_limit_newAcct_Y_BMO*100)) * 100 uti_newAcct_Y_BMO_sinceLast,
cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER cur_uti_newAcct_Y_PEER, 
pre.balance_newAcct_Y_PEER/pre.credit_limit_newAcct_Y_PEER pre_uti_newAcct_Y_PEER,
((cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER*100) - (pre.balance_newAcct_Y_PEER/pre.credit_limit_newAcct_Y_PEER*100)) * 100 uti_newAcct_Y_PEER_sinceLast,

--balance
cur.balance_newAcct_Y_BMO, 
pre.balance_newAcct_Y_BMO,
if(pre.balance_newAcct_Y_BMO<>0,(cur.balance_newAcct_Y_BMO/pre.balance_newAcct_Y_BMO -1)*100,null) balanceRate_newAcct_Y_BMO_sinceLast,
cur.balance_newAcct_Y_PEER ,
pre.balance_newAcct_Y_PEER,
if(pre.balance_newAcct_Y_PEER<>0,(cur.balance_newAcct_Y_PEER/pre.balance_newAcct_Y_PEER -1)*100,null) balanceRate_newAcct_Y_PEER_sinceLast,

--limit
cur.credit_limit_newAcct_Y_BMO, 
pre.credit_limit_newAcct_Y_BMO,
if(pre.credit_limit_newAcct_Y_BMO<>0,(cur.credit_limit_newAcct_Y_BMO/pre.credit_limit_newAcct_Y_BMO -1)*100,null) credit_limitRate_newAcct_Y_BMO_sinceLast,
cur.credit_limit_newAcct_Y_PEER ,
pre.credit_limit_newAcct_Y_PEER,
if(pre.credit_limit_newAcct_Y_PEER<>0,(cur.credit_limit_newAcct_Y_PEER/pre.credit_limit_newAcct_Y_PEER -1)*100,null) credit_limitRate_newAcct_Y_PEER_sinceLast
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  if(mod(cur.year_month,100)=3 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-3)
 
order by cur.year_month,cur.product;


--only for by year
with source as 
( select t.pi2_product product, t.year_month,
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(sum(if(t.joint_flag='P',balance,0))) over(partition by t.pi2_product) balance_Market,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
sum(sum(if(t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product) credit_limit_Market,

--new account
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_PEER,
sum(sum(if(t.joint_flag='P' and new_account_m='Y' ,balance,0))) over(partition by t.pi2_product) balance_newAcct_M_Market,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_PEER,
sum(sum(if(t.joint_flag='P' and new_account_m='Y',credit_limit,0))) over(partition by t.pi2_product) credit_limit_newAcct_M_Market,


 sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_PEER,
sum(sum(if(t.joint_flag='P' and new_account_q='Y' ,balance,0))) over(partition by t.pi2_product) balance_newAcct_Q_Market,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_PEER,
sum(sum(if(t.joint_flag='P' and new_account_q='Y',credit_limit,0))) over(partition by t.pi2_product) credit_limit_newAcct_Q_Market,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_PEER,
sum(sum(if(t.joint_flag='P' and new_account_y='Y' ,balance,0))) over(partition by t.pi2_product) balance_newAcct_Y_Market,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_PEER,
sum(sum(if(t.joint_flag='P' and new_account_y='Y',credit_limit,0))) over(partition by t.pi2_product) credit_limit_newAcct_Y_Market
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
--chart 30
cur.volumn_BMO, 
cur.volumn_PEER ,

--utilizationRate
cur.balance_BMO/cur.credit_limit_BMO cur_uti_BMO, 
pre.balance_BMO/pre.credit_limit_BMO pre_uti_BMO,
((cur.balance_BMO/cur.credit_limit_BMO*100) - (pre.balance_BMO/pre.credit_limit_BMO*100)) * 100 uti_BMO_sinceLast,
cur.balance_PEER/cur.credit_limit_PEER cur_uti_PEER, 
pre.balance_PEER/pre.credit_limit_PEER pre_uti_PEER,
((cur.balance_PEER/cur.credit_limit_PEER*100) - (pre.balance_PEER/pre.credit_limit_PEER*100)) * 100 uti_PEER_sinceLast,

--balance
cur.balance_BMO, 
pre.balance_BMO,
if(pre.balance_BMO<>0,(cur.balance_BMO/pre.balance_BMO -1)*100,null) balanceRate_BMO_sinceLast,
cur.balance_PEER ,
pre.balance_PEER,
if(pre.balance_PEER<>0,(cur.balance_PEER/pre.balance_PEER -1)*100,null) balanceRate_PEER_sinceLast,

--limit
cur.credit_limit_BMO, 
pre.credit_limit_BMO,
if(pre.credit_limit_BMO<>0,(cur.credit_limit_BMO/pre.credit_limit_BMO -1)*100,null) credit_limitRate_BMO_sinceLast,
cur.credit_limit_PEER ,
pre.credit_limit_PEER,
if(pre.credit_limit_PEER<>0,(cur.credit_limit_PEER/pre.credit_limit_PEER -1)*100,null) credit_limitRate_PEER_sinceLast,


--utilizationRate
cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO cur_uti_newAcct_M_BMO, 
pre.balance_newAcct_M_BMO/pre.credit_limit_newAcct_M_BMO pre_uti_newAcct_M_BMO,
((cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO*100) - (pre.balance_newAcct_M_BMO/pre.credit_limit_newAcct_M_BMO*100)) * 100 uti_newAcct_M_BMO_sinceLast,
cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER cur_uti_newAcct_M_PEER, 
pre.balance_newAcct_M_PEER/pre.credit_limit_newAcct_M_PEER pre_uti_newAcct_M_PEER,
((cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER*100) - (pre.balance_newAcct_M_PEER/pre.credit_limit_newAcct_M_PEER*100)) * 100 uti_newAcct_M_PEER_sinceLast,

--balance
cur.balance_newAcct_M_BMO, 
pre.balance_newAcct_M_BMO,
if(pre.balance_newAcct_M_BMO<>0,(cur.balance_newAcct_M_BMO/pre.balance_newAcct_M_BMO -1)*100,null) balanceRate_newAcct_M_BMO_sinceLast,
cur.balance_newAcct_M_PEER ,
pre.balance_newAcct_M_PEER,
if(pre.balance_newAcct_M_PEER<>0,(cur.balance_newAcct_M_PEER/pre.balance_newAcct_M_PEER -1)*100,null) balanceRate_newAcct_M_PEER_sinceLast,

--limit
cur.credit_limit_newAcct_M_BMO, 
pre.credit_limit_newAcct_M_BMO,
if(pre.credit_limit_newAcct_M_BMO<>0,(cur.credit_limit_newAcct_M_BMO/pre.credit_limit_newAcct_M_BMO -1)*100,null) credit_limitRate_newAcct_M_BMO_sinceLast,
cur.credit_limit_newAcct_M_PEER ,
pre.credit_limit_newAcct_M_PEER,
if(pre.credit_limit_newAcct_M_PEER<>0,(cur.credit_limit_newAcct_M_PEER/pre.credit_limit_newAcct_M_PEER -1)*100,null) credit_limitRate_newAcct_M_PEER_sinceLast,


--utilizationRate
cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO cur_uti_newAcct_Q_BMO, 
pre.balance_newAcct_Q_BMO/pre.credit_limit_newAcct_Q_BMO pre_uti_newAcct_Q_BMO,
((cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO*100) - (pre.balance_newAcct_Q_BMO/pre.credit_limit_newAcct_Q_BMO*100)) * 100 uti_newAcct_Q_BMO_sinceLast,
cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER cur_uti_newAcct_Q_PEER, 
pre.balance_newAcct_Q_PEER/pre.credit_limit_newAcct_Q_PEER pre_uti_newAcct_Q_PEER,
((cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER*100) - (pre.balance_newAcct_Q_PEER/pre.credit_limit_newAcct_Q_PEER*100)) * 100 uti_newAcct_Q_PEER_sinceLast,

--balance
cur.balance_newAcct_Q_BMO, 
pre.balance_newAcct_Q_BMO,
if(pre.balance_newAcct_Q_BMO<>0,(cur.balance_newAcct_Q_BMO/pre.balance_newAcct_Q_BMO -1)*100,null) balanceRate_newAcct_Q_BMO_sinceLast,
cur.balance_newAcct_Q_PEER ,
pre.balance_newAcct_Q_PEER,
if(pre.balance_newAcct_Q_PEER<>0,(cur.balance_newAcct_Q_PEER/pre.balance_newAcct_Q_PEER -1)*100,null) balanceRate_newAcct_Q_PEER_sinceLast,

--limit
cur.credit_limit_newAcct_Q_BMO, 
pre.credit_limit_newAcct_Q_BMO,
if(pre.credit_limit_newAcct_Q_BMO<>0,(cur.credit_limit_newAcct_Q_BMO/pre.credit_limit_newAcct_Q_BMO -1)*100,null) credit_limitRate_newAcct_Q_BMO_sinceLast,
cur.credit_limit_newAcct_Q_PEER ,
pre.credit_limit_newAcct_Q_PEER,
if(pre.credit_limit_newAcct_Q_PEER<>0,(cur.credit_limit_newAcct_Q_PEER/pre.credit_limit_newAcct_Q_PEER -1)*100,null) credit_limitRate_newAcct_Q_PEER_sinceLast,

--utilizationRate
cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO cur_uti_newAcct_Y_BMO, 
pre.balance_newAcct_Y_BMO/pre.credit_limit_newAcct_Y_BMO pre_uti_newAcct_Y_BMO,
((cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO*100) - (pre.balance_newAcct_Y_BMO/pre.credit_limit_newAcct_Y_BMO*100)) * 100 uti_newAcct_Y_BMO_sinceLast,
cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER cur_uti_newAcct_Y_PEER, 
pre.balance_newAcct_Y_PEER/pre.credit_limit_newAcct_Y_PEER pre_uti_newAcct_Y_PEER,
((cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER*100) - (pre.balance_newAcct_Y_PEER/pre.credit_limit_newAcct_Y_PEER*100)) * 100 uti_newAcct_Y_PEER_sinceLast,

--balance
cur.balance_newAcct_Y_BMO, 
pre.balance_newAcct_Y_BMO,
if(pre.balance_newAcct_Y_BMO<>0,(cur.balance_newAcct_Y_BMO/pre.balance_newAcct_Y_BMO -1)*100,null) balanceRate_newAcct_Y_BMO_sinceLast,
cur.balance_newAcct_Y_PEER ,
pre.balance_newAcct_Y_PEER,
if(pre.balance_newAcct_Y_PEER<>0,(cur.balance_newAcct_Y_PEER/pre.balance_newAcct_Y_PEER -1)*100,null) balanceRate_newAcct_Y_PEER_sinceLast,

--limit
cur.credit_limit_newAcct_Y_BMO, 
pre.credit_limit_newAcct_Y_BMO,
if(pre.credit_limit_newAcct_Y_BMO<>0,(cur.credit_limit_newAcct_Y_BMO/pre.credit_limit_newAcct_Y_BMO -1)*100,null) credit_limitRate_newAcct_Y_BMO_sinceLast,
cur.credit_limit_newAcct_Y_PEER ,
pre.credit_limit_newAcct_Y_PEER,
if(pre.credit_limit_newAcct_Y_PEER<>0,(cur.credit_limit_newAcct_Y_PEER/pre.credit_limit_newAcct_Y_PEER -1)*100,null) credit_limitRate_newAcct_Y_PEER_sinceLast


from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=   cur.year_month-100
 
order by cur.year_month,cur.product;


--chart 42 by region,
--fromMonth 201712-201802


with cur as 
( select t.year_month,t.pi2_product product,s.province,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
--new account
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_PEER

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
--and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.province )  
select year_month,cur.product product,cur.province,
--utilizationRate
cur.balance_BMO,
cur.credit_limit_BMO,
cur.balance_BMO/cur.credit_limit_BMO*100 cur_uti_BMO, 
cur.balance_PEER, 
cur.credit_limit_PEER, 
cur.balance_PEER/cur.credit_limit_PEER*100 cur_uti_PEER, 
(cur.balance_BMO/cur.credit_limit_BMO - cur.balance_PEER/cur.credit_limit_PEER) * 100 variance_to_peer,

cur.balance_newAcct_M_BMO,
cur.credit_limit_newAcct_M_BMO,
cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO*100 cur_uti_newAcct_M_BMO, 
cur.balance_newAcct_M_PEER, 
cur.credit_limit_newAcct_M_PEER, 
cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER*100 cur_uti_newAcct_M_PEER, 
(cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO - cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER) * 100 variance__newAcct_M_to_peer,

cur.balance_newAcct_Q_BMO,
cur.credit_limit_newAcct_Q_BMO,
cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO*100 cur_uti_newAcct_Q_BMO, 
cur.balance_newAcct_Q_PEER, 
cur.credit_limit_newAcct_Q_PEER, 
cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER*100 cur_uti_newAcct_Q_PEER, 
(cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO - cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER) * 100 variance__newAcct_Q_to_peer,
 
 cur.balance_newAcct_Y_BMO,
cur.credit_limit_newAcct_Y_BMO,
cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO*100 cur_uti_newAcct_Y_BMO, 
cur.balance_newAcct_Y_PEER, 
cur.credit_limit_newAcct_Y_PEER, 
cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER*100 cur_uti_newAcct_Y_PEER, 
(cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO - cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER) * 100 variance__newAcct_Y_to_peer

from cur
order by year_month,product  ,province;

--risk
with cur as 
( select t.year_month,t.pi2_product product,s.ers_band,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
--new account
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_PEER

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
--and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.ers_band )  
select year_month,cur.product product,cur.ers_band,
cur.balance_BMO,
cur.credit_limit_BMO,
cur.balance_BMO/cur.credit_limit_BMO*100 cur_uti_BMO, 
cur.balance_PEER, 
cur.credit_limit_PEER, 
cur.balance_PEER/cur.credit_limit_PEER*100 cur_uti_PEER, 
(cur.balance_BMO/cur.credit_limit_BMO - cur.balance_PEER/cur.credit_limit_PEER) * 100 variance_to_peer,

cur.balance_newAcct_M_BMO,
cur.credit_limit_newAcct_M_BMO,
cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO*100 cur_uti_newAcct_M_BMO, 
cur.balance_newAcct_M_PEER, 
cur.credit_limit_newAcct_M_PEER, 
cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER*100 cur_uti_newAcct_M_PEER, 
(cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO - cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER) * 100 variance__newAcct_M_to_peer,

cur.balance_newAcct_Q_BMO,
cur.credit_limit_newAcct_Q_BMO,
cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO*100 cur_uti_newAcct_Q_BMO, 
cur.balance_newAcct_Q_PEER, 
cur.credit_limit_newAcct_Q_PEER, 
cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER*100 cur_uti_newAcct_Q_PEER, 
(cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO - cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER) * 100 variance__newAcct_Q_to_peer,
 
 cur.balance_newAcct_Y_BMO,
cur.credit_limit_newAcct_Y_BMO,
cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO*100 cur_uti_newAcct_Y_BMO, 
cur.balance_newAcct_Y_PEER, 
cur.credit_limit_newAcct_Y_PEER, 
cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER*100 cur_uti_newAcct_Y_PEER, 
(cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO - cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER) * 100 variance__newAcct_Y_to_peer
from cur
order by year_month,product  ,ers_band;

--age
with cur as 
( select t.year_month,t.pi2_product product,s.consumer_age_cat,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
--new account
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',balance,0))  balance_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y',credit_limit,0))  credit_limit_newAcct_M_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',credit_limit,0))  credit_limit_newAcct_Q_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',credit_limit,0))  credit_limit_newAcct_Y_PEER

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
--and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.consumer_age_cat )  
select year_month,cur.product product,cur.consumer_age_cat,
cur.balance_BMO,
cur.credit_limit_BMO,
cur.balance_BMO/cur.credit_limit_BMO*100 cur_uti_BMO, 
cur.balance_PEER, 
cur.credit_limit_PEER, 
cur.balance_PEER/cur.credit_limit_PEER*100 cur_uti_PEER, 
(cur.balance_BMO/cur.credit_limit_BMO - cur.balance_PEER/cur.credit_limit_PEER) * 100 variance_to_peer,

cur.balance_newAcct_M_BMO,
cur.credit_limit_newAcct_M_BMO,
cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO*100 cur_uti_newAcct_M_BMO, 
cur.balance_newAcct_M_PEER, 
cur.credit_limit_newAcct_M_PEER, 
cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER*100 cur_uti_newAcct_M_PEER, 
(cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO - cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER) * 100 variance__newAcct_M_to_peer,

cur.balance_newAcct_Q_BMO,
cur.credit_limit_newAcct_Q_BMO,
cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO*100 cur_uti_newAcct_Q_BMO, 
cur.balance_newAcct_Q_PEER, 
cur.credit_limit_newAcct_Q_PEER, 
cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER*100 cur_uti_newAcct_Q_PEER, 
(cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO - cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER) * 100 variance__newAcct_Q_to_peer,
 
 cur.balance_newAcct_Y_BMO,
cur.credit_limit_newAcct_Y_BMO,
cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO*100 cur_uti_newAcct_Y_BMO, 
cur.balance_newAcct_Y_PEER, 
cur.credit_limit_newAcct_Y_PEER, 
cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER*100 cur_uti_newAcct_Y_PEER, 
(cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO - cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER) * 100 variance__newAcct_Y_to_peer
from cur
order by year_month,product  ,consumer_age_cat;



 