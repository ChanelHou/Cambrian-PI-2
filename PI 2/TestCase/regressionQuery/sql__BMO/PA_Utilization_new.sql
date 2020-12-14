--chart 37-40,  by all account  by months ,can use same data as es-overview
--first three chart same as PA_snapshot , 
With source_new as ( select * from (
with source as 
( select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, t.pi2_product product, 
count(1) volume,
sum(balance)  balance,
sum(credit_limit)  credit_limit,
sum(balance)/sum(credit_limit)*100 uti_rate,

sum(if(new_account_m='Y' and t.account_age=1,1,0))   newAcct_M ,
sum(if(new_account_m='Y' and t.account_age=1,balance,0))  balance_newAcct_M ,
sum(if(new_account_m='Y' and t.account_age=1,credit_limit,0))  credit_limit_newAcct_M ,


 sum(if(new_account_q='Y' ,1,0))   newAcct_Q ,
sum(if( new_account_q='Y' ,balance,0))  balance_newAcct_Q ,
sum(if( new_account_q='Y' ,credit_limit,0))  credit_limit_newAcct_Q ,
sum(if( new_account_y='Y' ,1,0))   newAcct_Y ,
sum(if( new_account_y='Y' ,balance,0))  balance_newAcct_Y ,
sum(if( new_account_y='Y' ,credit_limit,0))  credit_limit_newAcct_Y 

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
PEER.volume volume_PEER,
PEER.balance balance_PEER,
PEER.credit_limit credit_limit_PEER,
PEER.uti_rate uti_rate_PEER,

BMO.newAcct_M newAcct_M_BMO,
BMO.balance_newAcct_M balance_newAcct_M_BMO,
BMO.credit_limit_newAcct_M credit_limit_newAcct_M_BMO,
BMO.balance_newAcct_M/BMO.credit_limit_newAcct_M*100 uti_BMO_newAcct_M,

PEER.newAcct_M newAcct_M_PEER,
PEER.balance_newAcct_M balance_newAcct_M_PEER,
PEER.credit_limit_newAcct_M credit_limit_newAcct_M_PEER,
PEER.balance_newAcct_M/PEER.credit_limit_newAcct_M*100 uti_PEER_newAcct_M,

BMO.newAcct_Q newAcct_Q_BMO,
BMO.balance_newAcct_Q balance_newAcct_Q_BMO,
BMO.credit_limit_newAcct_Q credit_limit_newAcct_Q_BMO,
PEER.newAcct_Q newAcct_Q_PEER,
PEER.balance_newAcct_Q balance_newAcct_Q_PEER,
PEER.credit_limit_newAcct_Q credit_limit_newAcct_Q_PEER,
BMO.balance_newAcct_Q/BMO.credit_limit_newAcct_Q*100 uti_BMO_newAcct_Q,
PEER.balance_newAcct_Q/PEER.credit_limit_newAcct_Q*100 uti_PEER_newAcct_Q,

BMO.newAcct_Y newAcct_Y_BMO,
BMO.balance_newAcct_Y balance_newAcct_Y_BMO,
BMO.credit_limit_newAcct_Y credit_limit_newAcct_Y_BMO,
PEER.newAcct_Y newAcct_Y_PEER,
PEER.balance_newAcct_Y balance_newAcct_Y_PEER,
PEER.credit_limit_newAcct_Y credit_limit_newAcct_Y_PEER,
BMO.balance_newAcct_Y/BMO.credit_limit_newAcct_Y*100 uti_BMO_newAcct_Y,
PEER.balance_newAcct_Y/PEER.credit_limit_newAcct_Y*100 uti_PEER_newAcct_Y
 
from source BMO
join source PEER
on BMO.year_month=PEER.year_month
and BMO.product=PEER.product
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
) a )
select cur.year_month,cur.product , 
--chart 4 - no of account , chart 1 , accounts
cur.uti_rate_BMO cur_uti_rate_BMO,
(cur.uti_rate_BMO - pre.uti_rate_BMO)*100 sinceLast_bps_uti_rate_BMO,
cur.uti_rate_PEER cur_uti_rate_PEER,
(cur.uti_rate_PEER - pre.uti_rate_PEER)*100 sinceLast_bps_uti_rate_PEER ,

cur.balance_BMO cur_balance_BMO ,
(cur.balance_BMO/pre.balance_BMO - 1)*100  sinceLastRate_acct_BMO,
cur.balance_PEER cur_balance_PEER ,
(cur.balance_PEER/pre.balance_PEER - 1)*100 sinceLastRate_acct_PEER,

cur.credit_limit_BMO cur_credit_limit_BMO ,
(cur.credit_limit_BMO/pre.credit_limit_BMO - 1)*100 sinceLastRate_acct_BMO,
cur.credit_limit_PEER cur_credit_limit_PEER ,
(cur.credit_limit_PEER/pre.credit_limit_PEER - 1)*100 sinceLastRate_acct_PEER,

cur.uti_BMO_newAcct_M cur_uti_BMO_newAcct_M,
(cur.uti_BMO_newAcct_M - pre.uti_BMO_newAcct_M)*100 sinceLast_bps_uti_BMO_newAcct_M,
cur.uti_PEER_newAcct_M cur_uti_PEER_newAcct_M,
(cur.uti_PEER_newAcct_M - pre.uti_PEER_newAcct_M)*100 sinceLast_bps_uti_PEER_newAcct_M ,

cur.balance_newAcct_M_BMO cur_balance_newAcct_M_BMO ,
(cur.balance_newAcct_M_BMO/pre.balance_newAcct_M_BMO - 1)*100  sinceLastRate_acct_BMO,
cur.balance_newAcct_M_PEER cur_balance_newAcct_M_PEER ,
(cur.balance_newAcct_M_PEER/pre.balance_newAcct_M_PEER - 1)*100 sinceLastRate_acct_PEER,

cur.credit_limit_newAcct_M_BMO cur_credit_limit_newAcct_M_BMO ,
(cur.credit_limit_newAcct_M_BMO/pre.credit_limit_newAcct_M_BMO - 1)*100 sinceLastRate_acct_BMO,
cur.credit_limit_newAcct_M_PEER cur_credit_limit_newAcct_M_PEER ,
(cur.credit_limit_newAcct_M_PEER/pre.credit_limit_newAcct_M_PEER - 1)*100 sinceLastRate_acct_PEER,


 cur.uti_BMO_newAcct_Q cur_uti_BMO_newAcct_Q,
(cur.uti_BMO_newAcct_Q - pre.uti_BMO_newAcct_Q)*100 sinceLast_bps_uti_BMO_newAcct_Q,
cur.uti_PEER_newAcct_Q cur_uti_PEER_newAcct_Q,
(cur.uti_PEER_newAcct_Q - pre.uti_PEER_newAcct_Q)*100 sinceLast_bps_uti_PEER_newAcct_Q ,

cur.balance_newAcct_Q_BMO cur_balance_newAcct_Q_BMO ,
(cur.balance_newAcct_Q_BMO/pre.balance_newAcct_Q_BMO - 1)*100  sinceLastRate_acct_BMO,
cur.balance_newAcct_Q_PEER cur_balance_newAcct_Q_PEER ,
(cur.balance_newAcct_Q_PEER/pre.balance_newAcct_Q_PEER - 1)*100 sinceLastRate_acct_PEER,

cur.credit_limit_newAcct_Q_BMO cur_credit_limit_newAcct_Q_BMO ,
(cur.credit_limit_newAcct_Q_BMO/pre.credit_limit_newAcct_Q_BMO - 1)*100 sinceLastRate_acct_BMO,
cur.credit_limit_newAcct_Q_PEER cur_credit_limit_newAcct_Q_PEER ,
(cur.credit_limit_newAcct_Q_PEER/pre.credit_limit_newAcct_Q_PEER - 1)*100 sinceLastRate_acct_PEER,

cur.uti_BMO_newAcct_Y cur_uti_BMO_newAcct_Y,
(cur.uti_BMO_newAcct_Y - pre.uti_BMO_newAcct_Y)*100 sinceLast_bps_uti_BMO_newAcct_Y,
cur.uti_PEER_newAcct_Y cur_uti_PEER_newAcct_Y,
(cur.uti_PEER_newAcct_Y - pre.uti_PEER_newAcct_Y)*100 sinceLast_bps_uti_PEER_newAcct_Y ,

cur.balance_newAcct_Y_BMO cur_balance_newAcct_Y_BMO ,
(cur.balance_newAcct_Y_BMO/pre.balance_newAcct_Y_BMO - 1)*100  sinceLastRate_acct_BMO,
cur.balance_newAcct_Y_PEER cur_balance_newAcct_Y_PEER ,
(cur.balance_newAcct_Y_PEER/pre.balance_newAcct_Y_PEER - 1)*100 sinceLastRate_acct_PEER,

cur.credit_limit_newAcct_Y_BMO cur_credit_limit_newAcct_Y_BMO ,
(cur.credit_limit_newAcct_Y_BMO/pre.credit_limit_newAcct_Y_BMO - 1)*100 sinceLastRate_acct_BMO,
cur.credit_limit_newAcct_Y_PEER cur_credit_limit_newAcct_Y_PEER ,
(cur.credit_limit_newAcct_Y_PEER/pre.credit_limit_newAcct_Y_PEER - 1)*100 sinceLastRate_acct_PEER


 
from source_new cur
left join source_new pre
on pre.product=cur.product
where cur.year_month=${curMonth}
and pre.year_month= ${preMonth}  
order by cur.year_month,cur.product;





--bar chart

    select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, t.pi2_product product, 
count(1) volume,
sum(balance)  balance,
sum(credit_limit)  credit_limit,
sum(balance)/sum(credit_limit)*100 uti_rate,
sum(balance)/count(1) avg_balance,
sum(credit_limit)/count(1) avg_limit,
sum(if(new_account_m='Y' and t.account_age=1,1,0))   newAcct_M ,
sum(if(new_account_m='Y' and t.account_age=1,balance,0))  balance_newAcct_M ,
sum(if(new_account_m='Y' and t.account_age=1,credit_limit,0))  credit_limit_newAcct_M ,
sum(if(new_account_m='Y' and t.account_age=1,balance,0)) /sum(if(new_account_m='Y' and t.account_age=1,credit_limit,0))*100 uti_rate_newAcct_M,
sum(if(new_account_m='Y' and t.account_age=1,balance,0))/sum(if(new_account_m='Y' and t.account_age=1,1,0)) avg_balance_newAcct_M,
sum(if(new_account_m='Y' and t.account_age=1,credit_limit,0))/sum(if(new_account_m='Y' and t.account_age=1,1,0))   avg_limit_newAcct_M,


 sum(if(new_account_q='Y' ,1,0))   newAcct_Q ,
sum(if( new_account_q='Y' ,balance,0))  balance_newAcct_Q ,
sum(if( new_account_q='Y' ,credit_limit,0))  credit_limit_newAcct_Q ,
sum(if( new_account_q='Y' ,balance,0))/sum(if( new_account_q='Y' ,credit_limit,0))*100 uti_rate_newAcct_q,
sum(if( new_account_q='Y' ,balance,0))/ sum(if(new_account_q='Y' ,1,0))  avg_balance_newAcct_Q,
sum(if( new_account_q='Y' ,credit_limit,0))/sum(if(new_account_q='Y' ,1,0)) avg_limit_newAcct_Q,


sum(if( new_account_y='Y' ,1,0))   newAcct_Y ,
sum(if( new_account_y='Y' ,balance,0))  balance_newAcct_Y ,
sum(if( new_account_y='Y' ,credit_limit,0))  credit_limit_newAcct_Y ,
sum(if( new_account_y='Y' ,balance,0)) /sum(if( new_account_y='Y' ,credit_limit,0))*100  uti_rate_newAcct_Y,
sum(if( new_account_y='Y' ,balance,0))/sum(if( new_account_y='Y' ,1,0)) avg_balance_newAcct_Y,
sum(if( new_account_y='Y' ,credit_limit,0)) /sum(if( new_account_y='Y' ,1,0)) avg_limit_newAcct_Y
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month  between ${fromMonth} and ${preMonth} 
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   , t.pi2_product  
order by t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   , t.pi2_product 

--IMQA-76
--IMQA-25
select sum(balance),
sum(credit_limit),
sum(balance)/sum(credit_limit) * 100

from pi2_trade_n t
left join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
 
where 
 
  ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
and new_account_m='Y' and t.account_age=1
and t.year_month=201305
and fi_name = 'BANK OF MONTREAL'
and pi2_product='Installment loan'		  
 
	  
 


--chart 42 by region,
--fromMonth 201712-201802


with cur as 
( select t.year_month,t.pi2_product product,s.province,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
--new account
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,balance,0))  balance_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,credit_limit,0))  credit_limit_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,credit_limit,0))  credit_limit_newAcct_M_PEER,

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
cur.balance_BMO/cur.credit_limit_BMO*100 cur_uti_BMO, 
(cur.balance_BMO/cur.credit_limit_BMO - cur.balance_PEER/cur.credit_limit_PEER) * 100 variance_to_peer,
cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO*100 cur_uti_newAcct_M_BMO, 
(cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO - cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER) * 100 variance__newAcct_M_to_peer,
cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO*100 cur_uti_newAcct_Q_BMO, 
(cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO - cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER) * 100 variance__newAcct_Q_to_peer,
cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO*100 cur_uti_newAcct_Y_BMO, 
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
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,balance,0))  balance_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,credit_limit,0))  credit_limit_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,credit_limit,0))  credit_limit_newAcct_M_PEER,

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
cur.balance_BMO/cur.credit_limit_BMO*100 cur_uti_BMO, 
(cur.balance_BMO/cur.credit_limit_BMO - cur.balance_PEER/cur.credit_limit_PEER) * 100 variance_to_peer,
cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO*100 cur_uti_newAcct_M_BMO, 
(cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO - cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER) * 100 variance__newAcct_M_to_peer,
cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO*100 cur_uti_newAcct_Q_BMO, 
(cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO - cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER) * 100 variance__newAcct_Q_to_peer,
cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO*100 cur_uti_newAcct_Y_BMO, 
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
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,balance,0))  balance_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,credit_limit,0))  credit_limit_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and t.account_age=1,credit_limit,0))  credit_limit_newAcct_M_PEER,

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
cur.balance_BMO/cur.credit_limit_BMO*100 cur_uti_BMO, 
(cur.balance_BMO/cur.credit_limit_BMO - cur.balance_PEER/cur.credit_limit_PEER) * 100 variance_to_peer,
cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO*100 cur_uti_newAcct_M_BMO, 
(cur.balance_newAcct_M_BMO/cur.credit_limit_newAcct_M_BMO - cur.balance_newAcct_M_PEER/cur.credit_limit_newAcct_M_PEER) * 100 variance__newAcct_M_to_peer,
cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO*100 cur_uti_newAcct_Q_BMO, 
(cur.balance_newAcct_Q_BMO/cur.credit_limit_newAcct_Q_BMO - cur.balance_newAcct_Q_PEER/cur.credit_limit_newAcct_Q_PEER) * 100 variance__newAcct_Q_to_peer,
cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO*100 cur_uti_newAcct_Y_BMO, 
(cur.balance_newAcct_Y_BMO/cur.credit_limit_newAcct_Y_BMO - cur.balance_newAcct_Y_PEER/cur.credit_limit_newAcct_Y_PEER) * 100 variance__newAcct_Y_to_peer
from cur
order by year_month,product  ,consumer_age_cat;



 