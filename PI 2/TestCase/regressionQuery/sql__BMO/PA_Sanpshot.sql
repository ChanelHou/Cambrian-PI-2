--chart 25,26,27,28   -- all accounts by product
--month 201801
--quarter 201712
--years 201801 , 201701
With source_new as ( select * from (
with source as 
( select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, t.pi2_product product, 
count(1) volume,
sum(sum(t.joint_flag='P')) over(partition by t.pi2_product,t.year_month) totalMarketVolume,
sum(balance)  balance,
sum(sum(if(t.joint_flag="P",balance,0))) over(partition by  t.pi2_product,t.year_month)  grandTotalbalance ,
sum(credit_limit)  credit_limit,
sum(sum(if(t.joint_flag="P",credit_limit,0))) over(partition by  t.pi2_product,t.year_month)  grandTotalcredit_limit ,
round(cast(if(sum(credit_limit)<>0,sum(balance)/sum(credit_limit)*100,0) as decimal(6,3)),2) uti_rate,
sum(payment_status='90+') Delinq_Accts ,
if(count(1)<>0,sum(payment_status='90+')/count(1)*100,null) delinquencyByAcct_rate,
sum(if(payment_status='90+',balance,0))  balance_Deli,
if(sum(balance)<>0,sum(if(payment_status='90+',balance,0))/sum(balance)*100,null) delinquencyByBalance_rate
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
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
PEER.delinquencyByBalance_rate delinquencyByBalance_rate_PEER,
BMO.totalMarketVolume   ,
BMO.grandTotalbalance,
BMO.grandTotalcredit_limit
 
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
cur.volume_BMO/cur.totalMarketVolume*100 MarketShare_Volume,


cur.balance_BMO cur_balance_BMO ,
round(cast(if(pre.balance_BMO>0,(cur.balance_BMO/pre.balance_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_BMO,
cur.balance_PEER cur_balance_PEER ,
round(cast(if(pre.balance_PEER>0,(cur.balance_PEER/pre.balance_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_PEER,
cur.balance_BMO/cur.grandTotalbalance*100 MarketShare_balance,
cur.credit_limit_BMO cur_credit_limit_BMO ,
round(cast(if(pre.credit_limit_BMO>0,(cur.credit_limit_BMO/pre.credit_limit_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_BMO,
cur.credit_limit_PEER cur_credit_limit_PEER ,
round(cast(if(pre.credit_limit_PEER>0,(cur.credit_limit_PEER/pre.credit_limit_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_acct_PEER,
cur.credit_limit_BMO/cur.grandTotalcredit_limit*100 MarketShare_limit,
 
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

--chart 25,26,27,28   -- new accounts by month by product
--month 201801
--quarter 201712
--years 201801 , 201701
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
if(sum(balance)<>0,sum(if(payment_status='90+',balance,0))/sum(balance)*100,null) delinquencyByBalance_rate,
sum(sum(t.joint_flag='P')) over(partition by t.pi2_product,t.year_month) totalMarketVolume,
sum(sum(if(t.joint_flag="P",balance,0))) over(partition by  t.pi2_product,t.year_month)  grandTotalbalance ,
 sum(sum(if(t.joint_flag="P",credit_limit,0))) over(partition by  t.pi2_product,t.year_month)  grandTotalcredit_limit 
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month  in ( ${curMonth} , ${preMonth})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'

and t.new_account_m='Y'
and t.account_age=1

--and t.new_account_q='Y'
--and t.new_account_y='Y'
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
PEER.delinquencyByBalance_rate delinquencyByBalance_rate_PEER,
BMO.totalMarketVolume   ,
BMO.grandTotalbalance,
BMO.grandTotalcredit_limit
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
(cur.volume_BMO/pre.volume_BMO - 1)*100    sinceLastRate_acct_BMO,
cur.volume_PEER cur_volume_PEER ,
 (cur.volume_PEER/pre.volume_PEER - 1)*100  sinceLastRate_acct_PEER,
cur.volume_BMO/cur.totalMarketVolume*100 MarketShare_Volume,

cur.balance_BMO cur_balance_BMO ,
 (cur.balance_BMO/pre.balance_BMO - 1)*100  sinceLastRate_acct_BMO,
cur.balance_PEER cur_balance_PEER ,
 (cur.balance_PEER/pre.balance_PEER - 1)*100  sinceLastRate_acct_PEER,
cur.balance_BMO/cur.grandTotalbalance*100 MarketShare_balance,

cur.credit_limit_BMO cur_credit_limit_BMO ,
 (cur.credit_limit_BMO/pre.credit_limit_BMO - 1)*100  sinceLastRate_acct_BMO,
cur.credit_limit_PEER cur_credit_limit_PEER ,
 (cur.credit_limit_PEER/pre.credit_limit_PEER - 1)*100  sinceLastRate_acct_PEER,
cur.credit_limit_BMO/cur.grandTotalcredit_limit*100 MarketShare_limit,
 
cur.uti_rate_BMO cur_uti_rate_BMO,
(cur.uti_rate_BMO - pre.uti_rate_BMO)*100 sinceLast_bps_uti_rate_BMO,
cur.uti_rate_PEER cur_uti_rate_PEER,
(cur.uti_rate_PEER - pre.uti_rate_PEER)*100 sinceLast_bps_uti_rate_PEER 
 
from (select * from source_new where year_month=${curMonth}) cur
left join (select * from source_new where year_month= ${preMonth} ) pre
on pre.product=cur.product
 
order by cur.year_month,cur.product;

--bug IMQA-76
with source_new as  
( select t.year_month,   t.pi2_product product, 
count(1) volume 
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month  in ( 201809,201709)
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'

and t.new_account_Y='Y'
and fi_name = "BANK OF MONTREAL"
 and  t.pi2_product in ("Bank revolving","NCC")
group by t.year_month,  t.pi2_product ) 
select cur.year_month,cur.product , 
 
cur.volume cur__Volume ,
pre.volume ppre_volume,
(cur.volume/pre.volume - 1)*100    sinceLastRate_acct_BMO 

from (select * from source_new where year_month=201809) cur
join (select * from source_new where year_month= 201709 ) pre
on pre.product=cur.product;
 
 


-- this query should change to different version because the product will be different
 

--chart 29 all accounts by risk by month
select  cur.year_month,ers_band,
--chart #accounts
 volumn_BMO,volumn_PEER,grandTotalAcct_BMO,grandTotalAcct_PEER, 
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) AcctDistribution_BMO,
if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER)*100,null) AcctDistribution_PEER,

if(grandTotalAcct_newAcct_M_BMO<>0,(volumn_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) AcctDistribution_M_BMO,
if(grandTotalAcct_newAcct_M_PEER<>0,(volumn_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER)*100,null) AcctDistribution_M_PEER,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volumn_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) AcctDistribution_Q_BMO,
if(grandTotalAcct_newAcct_Q_PEER<>0,(volumn_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER)*100,null) AcctDistribution_Q_PEER,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volumn_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) AcctDistribution_Y_BMO,
if(grandTotalAcct_newAcct_Y_PEER<>0,(volumn_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER)*100,null) AcctDistribution_Y_PEER

from ( select  t.year_month,s.ers_band,
--chart #accounts
sum(c.fi_name = "BANK OF MONTREAL" ) volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) volumn_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) ) over(partition by t.year_month) grandTotalAcct_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.account_age=1 ) volumn_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.account_age=1) volumn_newAcct_M_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.account_age=1)) over(partition by t.year_month) grandTotalAcct_newAcct_M_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.account_age=1 ) ) over(partition by t.year_month) grandTotalAcct_newAcct_M_PEER,


sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' ) volumn_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y') volumn_newAcct_Q_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_q='Y')) over(partition by t.year_month) grandTotalAcct_newAcct_Q_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' ) ) over(partition by t.year_month) grandTotalAcct_newAcct_Q_PEER,


sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' ) volumn_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y') volumn_newAcct_Y_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_y='Y')) over(partition by t.year_month) grandTotalAcct_newAcct_Y_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' ) ) over(partition by t.year_month) grandTotalAcct_newAcct_Y_PEER
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
and t.pi2_product in ("Installment loan","Revolving loan","Heloc","Mortgage","NCC","Student Loan")
group by t.year_month,s.ers_band)  cur
order by  year_month,ers_band;


-- this query should change to different version because the product will be different
--chart 29   accounts  by age by month    -- new accounts by month fail 
select  cur.year_month,cur.consumer_age_cat,
--chart #accounts
 volumn_BMO,volumn_PEER,grandTotalAcct_BMO,grandTotalAcct_PEER, 
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) AcctDistribution_BMO,
if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER)*100,null) AcctDistribution_PEER,

if(grandTotalAcct_newAcct_M_BMO<>0,(volumn_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) AcctDistribution_M_BMO,
if(grandTotalAcct_newAcct_M_PEER<>0,(volumn_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER)*100,null) AcctDistribution_M_PEER,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volumn_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) AcctDistribution_Q_BMO,
if(grandTotalAcct_newAcct_Q_PEER<>0,(volumn_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER)*100,null) AcctDistribution_Q_PEER,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volumn_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) AcctDistribution_Y_BMO,
if(grandTotalAcct_newAcct_Y_PEER<>0,(volumn_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER)*100,null) AcctDistribution_Y_PEER

from ( select  t.year_month,s.consumer_age_cat,
--chart #accounts
sum(c.fi_name = "BANK OF MONTREAL" ) volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) volumn_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) ) over(partition by t.year_month) grandTotalAcct_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.account_age=1 ) volumn_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.account_age=1) volumn_newAcct_M_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.account_age=1)) over(partition by t.year_month) grandTotalAcct_newAcct_M_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.account_age=1 ) ) over(partition by t.year_month) grandTotalAcct_newAcct_M_PEER,


sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' ) volumn_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y') volumn_newAcct_Q_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_q='Y')) over(partition by t.year_month) grandTotalAcct_newAcct_Q_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' ) ) over(partition by t.year_month) grandTotalAcct_newAcct_Q_PEER,


sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' ) volumn_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y') volumn_newAcct_Y_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_y='Y')) over(partition by t.year_month) grandTotalAcct_newAcct_Y_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' ) ) over(partition by t.year_month) grandTotalAcct_newAcct_Y_PEER
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
and t.pi2_product in ("Installment loan","Revolving loan","Heloc","Mortgage","NCC","Student Loan")
group by t.year_month,s.consumer_age_cat)  cur
order by  year_month,cur.consumer_age_cat;



--chart 29 all accounts  by product by month
select  cur.year_month,product,
 volumn_BMO,volumn_PEER,grandTotalAcct_BMO,grandTotalAcct_PEER, 
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) AcctDistribution_BMO,
if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER)*100,null) AcctDistribution_PEER,
if(grandTotalAcct_newAcct_M_BMO<>0,(volumn_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) AcctDistribution_M_BMO,
if(grandTotalAcct_newAcct_M_PEER<>0,(volumn_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER)*100,null) AcctDistribution_M_PEER,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volumn_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) AcctDistribution_Q_BMO,
if(grandTotalAcct_newAcct_Q_PEER<>0,(volumn_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER)*100,null) AcctDistribution_Q_PEER,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volumn_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) AcctDistribution_Y_BMO,
if(grandTotalAcct_newAcct_Y_PEER<>0,(volumn_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER)*100,null) AcctDistribution_Y_PEER

from ( select  t.year_month,t.pi2_product product,
sum(c.fi_name = "BANK OF MONTREAL" ) volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) volumn_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) ) over(partition by t.year_month) grandTotalAcct_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.account_age=1 ) volumn_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.account_age=1) volumn_newAcct_M_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.account_age=1)) over(partition by t.year_month) grandTotalAcct_newAcct_M_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.account_age=1 ) ) over(partition by t.year_month) grandTotalAcct_newAcct_M_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' ) volumn_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y') volumn_newAcct_Q_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_q='Y')) over(partition by t.year_month) grandTotalAcct_newAcct_Q_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' ) ) over(partition by t.year_month) grandTotalAcct_newAcct_Q_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' ) volumn_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y') volumn_newAcct_Y_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_y='Y')) over(partition by t.year_month) grandTotalAcct_newAcct_Y_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' ) ) over(partition by t.year_month) grandTotalAcct_newAcct_Y_PEER
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
and t.pi2_product in ("Installment loan","Revolving loan","Heloc","Mortgage","NCC","Student Loan")
group by t.year_month,t.pi2_product)  cur
order by  year_month,product;


--chart 29 all accounts  by region by month
select  cur.year_month,province,
--chart #accounts
 volumn_BMO,volumn_PEER,grandTotalAcct_BMO,grandTotalAcct_PEER, 
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) AcctDistribution_BMO,
if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER)*100,null) AcctDistribution_PEER,

if(grandTotalAcct_newAcct_M_BMO<>0,(volumn_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) AcctDistribution_M_BMO,
if(grandTotalAcct_newAcct_M_PEER<>0,(volumn_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER)*100,null) AcctDistribution_M_PEER,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volumn_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) AcctDistribution_Q_BMO,
if(grandTotalAcct_newAcct_Q_PEER<>0,(volumn_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER)*100,null) AcctDistribution_Q_PEER,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volumn_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) AcctDistribution_Y_BMO,
if(grandTotalAcct_newAcct_Y_PEER<>0,(volumn_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER)*100,null) AcctDistribution_Y_PEER

from ( select  t.year_month,s.province,
--chart #accounts
sum(c.fi_name = "BANK OF MONTREAL" ) volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) volumn_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) ) over(partition by t.year_month) grandTotalAcct_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.account_age=1 ) volumn_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.account_age=1) volumn_newAcct_M_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.account_age=1)) over(partition by t.year_month) grandTotalAcct_newAcct_M_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.account_age=1 ) ) over(partition by t.year_month) grandTotalAcct_newAcct_M_PEER,


sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' ) volumn_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y') volumn_newAcct_Q_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_q='Y')) over(partition by t.year_month) grandTotalAcct_newAcct_Q_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' ) ) over(partition by t.year_month) grandTotalAcct_newAcct_Q_PEER,


sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' ) volumn_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y') volumn_newAcct_Y_PEER ,
sum(sum( c.fi_name = "BANK OF MONTREAL" and new_account_y='Y')) over(partition by t.year_month) grandTotalAcct_newAcct_Y_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' ) ) over(partition by t.year_month) grandTotalAcct_newAcct_Y_PEER
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
and t.pi2_product in ("Installment loan","Revolving loan","Heloc","Mortgage","NCC","Student Loan")
group by t.year_month,s.province)  cur
order by  year_month,province;







 

 

