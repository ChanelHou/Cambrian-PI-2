--IMQA-78  item 1 and 2 for phase 2

-30-33,  by months
--30-33,  
--201210-201809
With source_new as ( select * from (
with source as 
( select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, t.pi2_product product, 
count(1) tradelines,
sum(t.joint_flag='P') volume,
sum(new_account_m='Y' and account_age=1 and t.joint_flag='P') volume_newAcct_M  ,
sum(new_account_m='Y' and account_age=1  ) tradelines_newAcct_M 

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where  t.year_month  between   ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
group by t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   , t.pi2_product ) 
select BMO.year_month,BMO.product,
BMO.volume volume_BMO,
BMO.tradelines tradelines_BMO,
PEER.volume volume_PEER,
PEER.tradelines tradelines_PEER,
BMO.volume_newAcct_M volume_newAcct_M_BMO,
BMO.tradelines_newAcct_M tradelines_newAcct_M_BMO,
PEER.volume_newAcct_M volume_newAcct_M_PEER,
PEER.tradelines_newAcct_M tradelines_newAcct_M_PEER
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
cur.tradelines_BMO cur_tradelines_BMO ,
round(cast(if(pre.tradelines_BMO>0,(cur.tradelines_BMO/pre.tradelines_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_BMO,
cur.tradelines_PEER cur_tradelines_PEER ,
round(cast(if(pre.tradelines_PEER>0,(cur.tradelines_PEER/pre.tradelines_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_PEER,
cur.volume_newAcct_M_BMO cur_volume_newAcct_M_BMO ,
round(cast(if(pre.volume_newAcct_M_BMO>0,(cur.volume_newAcct_M_BMO/pre.volume_newAcct_M_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_volume_newAcct_M_BMO,
cur.volume_newAcct_M_PEER cur_volume_newAcct_M_PEER ,
round(cast(if(pre.volume_newAcct_M_PEER>0,(cur.volume_newAcct_M_PEER/pre.volume_newAcct_M_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_volume_newAcct_M_PEER,
cur.tradelines_newAcct_M_BMO cur_tradelines_newAcct_M_BMO ,
round(cast(if(pre.tradelines_newAcct_M_BMO>0,(cur.tradelines_newAcct_M_BMO/pre.tradelines_newAcct_M_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_newAcct_M_BMO,
cur.tradelines_newAcct_M_PEER cur_tradelines_newAcct_M_PEER ,
round(cast(if(pre.tradelines_newAcct_M_PEER>0,(cur.tradelines_newAcct_M_PEER/pre.tradelines_newAcct_M_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_newAcct_M_PEER
from source_new cur
left join source_new pre
on pre.product=cur.product
where pre.year_month=  if(mod(cur.year_month,100)=1 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-1) 
order by cur.year_month,cur.product;
--201709-201809
--by years
With source_new as ( select * from (
with source as 
( select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, t.pi2_product product, 
count(1) tradelines,
sum(t.joint_flag='P') volume,
sum(new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y  ,
sum(new_account_y='Y'  ) tradelines_newAcct_Y
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where  t.year_month  between   ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
group by t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   , t.pi2_product ) 
select BMO.year_month,BMO.product,
BMO.volume volume_BMO,
BMO.tradelines tradelines_BMO,
PEER.volume volume_PEER,
PEER.tradelines tradelines_PEER,
BMO.volume_newAcct_Y volume_newAcct_Y_BMO,
BMO.tradelines_newAcct_Y tradelines_newAcct_Y_BMO,
PEER.volume_newAcct_Y volume_newAcct_Y_PEER,
PEER.tradelines_newAcct_Y tradelines_newAcct_Y_PEER 
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
cur.tradelines_BMO cur_tradelines_BMO ,
round(cast(if(pre.tradelines_BMO>0,(cur.tradelines_BMO/pre.tradelines_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_BMO,
cur.tradelines_PEER cur_tradelines_PEER ,
round(cast(if(pre.tradelines_PEER>0,(cur.tradelines_PEER/pre.tradelines_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_PEER,
cur.volume_newAcct_Y_BMO cur_volume_newAcct_Y_BMO ,
round(cast(if(pre.volume_newAcct_Y_BMO>0,(cur.volume_newAcct_Y_BMO/pre.volume_newAcct_Y_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_volume_newAcct_Y_BMO,
cur.volume_newAcct_Y_PEER cur_volume_newAcct_Y_PEER ,
round(cast(if(pre.volume_newAcct_Y_PEER>0,(cur.volume_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_volume_newAcct_Y_PEER,

cur.tradelines_newAcct_Y_BMO cur_tradelines_newAcct_Y_BMO ,
round(cast(if(pre.tradelines_newAcct_Y_BMO>0,(cur.tradelines_newAcct_Y_BMO/pre.tradelines_newAcct_Y_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_newAcct_Y_BMO,
cur.tradelines_newAcct_Y_PEER cur_tradelines_newAcct_Y_PEER ,
round(cast(if(pre.tradelines_newAcct_Y_PEER>0,(cur.tradelines_newAcct_Y_PEER/pre.tradelines_newAcct_Y_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_newAcct_Y_PEER
from source_new cur
left join source_new pre
on pre.product=cur.product
where  pre.year_month=  cur.year_month-100
order by cur.year_month,cur.product;
--by quarter

--201806-201809
With source_new as ( select * from (
with source as 
( select t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, t.pi2_product product, 
count(1) tradelines,
sum(t.joint_flag='P') volume,
sum(new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q  ,
sum(new_account_q='Y'  ) tradelines_newAcct_Q  

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where  t.year_month  between   ${fromMonth} and ${toMonth}
  and mod(mod(t.year_month,100),3) = 0
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
group by t.year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   , t.pi2_product ) 
select BMO.year_month,BMO.product,
BMO.volume volume_BMO,
BMO.tradelines tradelines_BMO,
PEER.volume volume_PEER,
PEER.tradelines tradelines_PEER,
BMO.volume_newAcct_Q volume_newAcct_Q_BMO,
BMO.tradelines_newAcct_Q tradelines_newAcct_Q_BMO,
PEER.volume_newAcct_Q volume_newAcct_Q_PEER,
PEER.tradelines_newAcct_Q tradelines_newAcct_Q_PEER

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
cur.tradelines_BMO cur_tradelines_BMO ,
round(cast(if(pre.tradelines_BMO>0,(cur.tradelines_BMO/pre.tradelines_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_BMO,
cur.tradelines_PEER cur_tradelines_PEER ,
round(cast(if(pre.tradelines_PEER>0,(cur.tradelines_PEER/pre.tradelines_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_PEER,
cur.volume_newAcct_Q_BMO cur_volume_newAcct_Q_BMO ,
round(cast(if(pre.volume_newAcct_Q_BMO>0,(cur.volume_newAcct_Q_BMO/pre.volume_newAcct_Q_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_volume_newAcct_Q_BMO,
cur.volume_newAcct_Q_PEER cur_volume_newAcct_Q_PEER ,
round(cast(if(pre.volume_newAcct_Q_PEER>0,(cur.volume_newAcct_Q_PEER/pre.volume_newAcct_Q_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_volume_newAcct_Q_PEER,

cur.tradelines_newAcct_Q_BMO cur_tradelines_newAcct_Q_BMO ,
round(cast(if(pre.tradelines_newAcct_Q_BMO>0,(cur.tradelines_newAcct_Q_BMO/pre.tradelines_newAcct_Q_BMO - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_newAcct_Q_BMO,
cur.tradelines_newAcct_Q_PEER cur_tradelines_newAcct_Q_PEER ,
round(cast(if(pre.tradelines_newAcct_Q_PEER>0,(cur.tradelines_newAcct_Q_PEER/pre.tradelines_newAcct_Q_PEER - 1)*100,0) as decimal(6,3)),2) sinceLastRate_tradelines_newAcct_Q_PEER
from source_new cur
left join source_new pre
on pre.product=cur.product
where    pre.year_month=  if(mod(cur.year_month,100)=3 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-3)
order by cur.year_month,cur.product;



-- by years chart 32,33

with source as 
( select t.pi2_product product, t.year_month,
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(c.fi_name = "BANK OF MONTREAL" ) tradelines_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) tradelines_PEER ,
--new account
sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P') volume_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P') volume_newAcct_M_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' ) tradelines_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' ) tradelines_newAcct_M_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' ) tradelines_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' ) tradelines_newAcct_Q_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' ) tradelines_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y')  tradelines_newAcct_Y_PEER 
from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and c.year_month=greatest( 201609, t.year_month)
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
cur.volume_BMO, 
pre.volume_BMO,
if(pre.volume_BMO<>0,(cur.volume_BMO/pre.volume_BMO -1)*100,null) volumeRate_BMO_sinceLast,
cur.volume_PEER ,
pre.volume_PEER,
if(pre.volume_PEER<>0,(cur.volume_PEER/pre.volume_PEER -1)*100,null) volumeRate_PEER_sinceLast,
 
--cur.balance_BMO,
--if(pre.balance_BMO<>0,cur.balance_BMO/pre.balance_BMO-1)*100,null) balanceRate_BMO_sinceLast,
--cur.balance_PEER,
--if(pre.balance_PEER<>0,cur.balance_PEER/pre.balance_PEER-1)*100,null) balanceRate_PEER_sinceLast,
--chart 31
cur.tradelines_BMO, 
if(pre.tradelines_BMO<>0,(cur.tradelines_BMO/pre.tradelines_BMO-1)*100,null) tradelinesRate_BMO_sinceLast,
cur.tradelines_PEER ,
if(pre.tradelines_PEER<>0,(cur.tradelines_PEER/pre.tradelines_PEER-1)*100,null) tradelinesRate_PEER_sinceLast,

cur.volume_newAcct_M_BMO,
if(pre.volume_newAcct_M_BMO<>0,(cur.volume_newAcct_M_BMO/pre.volume_newAcct_M_BMO-1)*100,null) volumeRate_newAcct_M_BMO_sinceLast,
cur.volume_newAcct_M_PEER,
if(pre.volume_newAcct_Y_PEER<>0,(cur.volume_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER-1)*100,null) volumeRate_newAcct_Y_PEER_sinceLast,
cur.tradelines_newAcct_M_BMO, 
if(pre.tradelines_newAcct_M_BMO<>0,(cur.tradelines_newAcct_M_BMO/pre.tradelines_newAcct_M_BMO-1)*100,null) tradelinesRate_newAcct_M_BMO_sinceLast,
cur.tradelines_newAcct_M_PEER ,
if(pre.tradelines_newAcct_M_PEER<>0,(cur.tradelines_newAcct_M_PEER/pre.tradelines_newAcct_M_PEER-1)*100,null) tradelinesRate_newAcct_M_PEER_sinceLast,

cur.volume_newAcct_Q_BMO,
if(pre.volume_newAcct_Q_BMO<>0,(cur.volume_newAcct_Q_BMO/pre.volume_newAcct_Q_BMO-1)*100,null) volumeRate_newAcct_Q_BMO_sinceLast,
cur.volume_newAcct_Q_PEER,
if(pre.volume_newAcct_Q_PEER<>0,(cur.volume_newAcct_Q_PEER/pre.volume_newAcct_Q_PEER-1)*100,null) volumeRate_newAcct_Q_PEER_sinceLast,
cur.tradelines_newAcct_Q_BMO, 
if(pre.tradelines_newAcct_Q_BMO<>0,(cur.tradelines_newAcct_Q_BMO/pre.tradelines_newAcct_Q_BMO-1)*100,null) tradelinesRate_newAcct_Q_BMO_sinceLast,
cur.tradelines_newAcct_Q_PEER ,
if(pre.tradelines_newAcct_Q_PEER<>0,(cur.tradelines_newAcct_Q_PEER/pre.tradelines_newAcct_Q_PEER-1)*100,null) tradelinesRate_newAcct_Q_PEER_sinceLast,

cur.volume_newAcct_Y_BMO,
if(pre.volume_newAcct_Y_BMO<>0,(cur.volume_newAcct_Y_BMO/pre.volume_newAcct_Y_BMO-1)*100,null) volumeRate_newAcct_Y_BMO_sinceLast,
cur.volume_newAcct_Y_PEER,
if(pre.volume_newAcct_Y_PEER<>0,(cur.volume_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER-1)*100,null) volumeRate_newAcct_Y_PEER_sinceLast,

cur.tradelines_newAcct_Y_BMO, 
if(pre.tradelines_newAcct_Y_BMO<>0,(cur.tradelines_newAcct_Y_BMO/pre.tradelines_newAcct_Y_BMO-1)*100,null) tradelinesRate_newAcct_Y_BMO_sinceLast,
cur.tradelines_newAcct_Y_PEER ,
if(pre.tradelines_newAcct_Y_PEER<>0,(cur.tradelines_newAcct_Y_PEER/pre.tradelines_newAcct_Y_PEER-1)*100,null) tradelinesRate_newAcct_Y_PEER_sinceLast
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  cur.year_month-100
order by  cur.year_month,cur.product ;


-- by quarter chart 32,33

with source as 
( select t.pi2_product product, t.year_month,
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(c.fi_name = "BANK OF MONTREAL" ) tradelines_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) tradelines_PEER ,
--new account
sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P') volume_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P') volume_newAcct_M_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' ) tradelines_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' ) tradelines_newAcct_M_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' ) tradelines_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' ) tradelines_newAcct_Q_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' ) tradelines_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y')  tradelines_newAcct_Y_PEER 
from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and c.year_month=greatest( 201609, t.year_month)
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where  t.year_month between ${fromMonth} and ${toMonth}
  and mod(mod(t.year_month,100),3) = 0
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month )  
select cur.product , cur.year_month,
--chart 30
cur.volume_BMO, 
pre.volume_BMO,
if(pre.volume_BMO<>0,(cur.volume_BMO/pre.volume_BMO -1)*100,null) volumeRate_BMO_sinceLast,
cur.volume_PEER ,
pre.volume_PEER,
if(pre.volume_PEER<>0,(cur.volume_PEER/pre.volume_PEER -1)*100,null) volumeRate_PEER_sinceLast,
 
--cur.balance_BMO,
--if(pre.balance_BMO<>0,cur.balance_BMO/pre.balance_BMO-1)*100,null) balanceRate_BMO_sinceLast,
--cur.balance_PEER,
--if(pre.balance_PEER<>0,cur.balance_PEER/pre.balance_PEER-1)*100,null) balanceRate_PEER_sinceLast,
--chart 31
cur.tradelines_BMO, 
if(pre.tradelines_BMO<>0,(cur.tradelines_BMO/pre.tradelines_BMO-1)*100,null) tradelinesRate_BMO_sinceLast,
cur.tradelines_PEER ,
if(pre.tradelines_PEER<>0,(cur.tradelines_PEER/pre.tradelines_PEER-1)*100,null) tradelinesRate_PEER_sinceLast,

cur.volume_newAcct_M_BMO,
if(pre.volume_newAcct_M_BMO<>0,(cur.volume_newAcct_M_BMO/pre.volume_newAcct_M_BMO-1)*100,null) volumeRate_newAcct_M_BMO_sinceLast,
cur.volume_newAcct_M_PEER,
if(pre.volume_newAcct_Y_PEER<>0,(cur.volume_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER-1)*100,null) volumeRate_newAcct_Y_PEER_sinceLast,
cur.tradelines_newAcct_M_BMO, 
if(pre.tradelines_newAcct_M_BMO<>0,(cur.tradelines_newAcct_M_BMO/pre.tradelines_newAcct_M_BMO-1)*100,null) tradelinesRate_newAcct_M_BMO_sinceLast,
cur.tradelines_newAcct_M_PEER ,
if(pre.tradelines_newAcct_M_PEER<>0,(cur.tradelines_newAcct_M_PEER/pre.tradelines_newAcct_M_PEER-1)*100,null) tradelinesRate_newAcct_M_PEER_sinceLast,

cur.volume_newAcct_Q_BMO,
if(pre.volume_newAcct_Q_BMO<>0,(cur.volume_newAcct_Q_BMO/pre.volume_newAcct_Q_BMO-1)*100,null) volumeRate_newAcct_Q_BMO_sinceLast,
cur.volume_newAcct_Q_PEER,
if(pre.volume_newAcct_Q_PEER<>0,(cur.volume_newAcct_Q_PEER/pre.volume_newAcct_Q_PEER-1)*100,null) volumeRate_newAcct_Q_PEER_sinceLast,
cur.tradelines_newAcct_Q_BMO, 
if(pre.tradelines_newAcct_Q_BMO<>0,(cur.tradelines_newAcct_Q_BMO/pre.tradelines_newAcct_Q_BMO-1)*100,null) tradelinesRate_newAcct_Q_BMO_sinceLast,
cur.tradelines_newAcct_Q_PEER ,
if(pre.tradelines_newAcct_Q_PEER<>0,(cur.tradelines_newAcct_Q_PEER/pre.tradelines_newAcct_Q_PEER-1)*100,null) tradelinesRate_newAcct_Q_PEER_sinceLast,

cur.volume_newAcct_Y_BMO,
if(pre.volume_newAcct_Y_BMO<>0,(cur.volume_newAcct_Y_BMO/pre.volume_newAcct_Y_BMO-1)*100,null) volumeRate_newAcct_Y_BMO_sinceLast,
cur.volume_newAcct_Y_PEER,
if(pre.volume_newAcct_Y_PEER<>0,(cur.volume_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER-1)*100,null) volumeRate_newAcct_Y_PEER_sinceLast,

cur.tradelines_newAcct_Y_BMO, 
if(pre.tradelines_newAcct_Y_BMO<>0,(cur.tradelines_newAcct_Y_BMO/pre.tradelines_newAcct_Y_BMO-1)*100,null) tradelinesRate_newAcct_Y_BMO_sinceLast,
cur.tradelines_newAcct_Y_PEER ,
if(pre.tradelines_newAcct_Y_PEER<>0,(cur.tradelines_newAcct_Y_PEER/pre.tradelines_newAcct_Y_PEER-1)*100,null) tradelinesRate_newAcct_Y_PEER_sinceLast
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  if(mod(cur.year_month,100)=3 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-3)
order by  cur.year_month,cur.product ;
 

--chart 34 by region,
--fromMonth 201712-201802


with cur as 
( select t.year_month,t.pi2_product product,s.province,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,t.pi2_product) grandTotalAcct_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) volume_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) volume_newAcct_M_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P' and account_age=1 )) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_M_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_M_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Q_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Q_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_Y='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Y_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_Y='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Y_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.province )  
select year_month,cur.product product,cur.province,
--chart #accounts
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) - if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) variance_to_peer ,
if(grandTotalAcct_newAcct_M_BMO<>0,(volume_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) shareAcct_newAcct_M_BMO,
if(grandTotalAcct_newAcct_M_PEER<>0,(volume_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER )*100,null) shareAcct_newAcct_M_PEER,
if(grandTotalAcct_newAcct_M_BMO<>0,(volume_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) - if(grandTotalAcct_newAcct_M_PEER<>0,(volume_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER )*100,null) variance_newAcct_M_to_peer ,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volume_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) shareAcct_newAcct_Q_BMO,
if(grandTotalAcct_newAcct_Q_PEER<>0,(volume_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER )*100,null) shareAcct_newAcct_Q_PEER,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volume_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) - if(grandTotalAcct_newAcct_Q_PEER<>0,(volume_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER )*100,null) variance_newAcct_Q_to_peer ,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volume_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) shareAcct_newAcct_Y_BMO,
if(grandTotalAcct_newAcct_Y_PEER<>0,(volume_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER )*100,null) shareAcct_newAcct_Y_PEER,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volume_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) - if(grandTotalAcct_newAcct_Y_PEER<>0,(volume_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER )*100,null) variance_newAcct_Y_to_peer 
from cur
order by year_month,product  ,province;

--risk
with cur as 
( select t.year_month,t.pi2_product product,s.ers_band,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,t.pi2_product) grandTotalAcct_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) volume_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) volume_newAcct_M_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P' and account_age=1 )) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_M_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_M_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Q_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Q_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_Y='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Y_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_Y='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Y_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.ers_band )  
select year_month,cur.product product,cur.ers_band,
--chart #accounts
volume_BMO, 
grandTotalAcct_BMO,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
volume_PEER ,
grandTotalAcct_PEER,
if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) - if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) variance_to_peer ,

volume_newAcct_M_BMO, 
grandTotalAcct_newAcct_M_BMO,
if(grandTotalAcct_newAcct_M_BMO<>0,(volume_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) shareAcct_newAcct_M_BMO,
volume_newAcct_M_PEER ,
grandTotalAcct_newAcct_M_PEER,
if(grandTotalAcct_newAcct_M_PEER<>0,(volume_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER )*100,null) shareAcct_newAcct_M_PEER,
if(grandTotalAcct_newAcct_M_BMO<>0,(volume_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) - if(grandTotalAcct_newAcct_M_PEER<>0,(volume_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER )*100,null) variance_newAcct_M_to_peer ,


volume_newAcct_Q_BMO, 
grandTotalAcct_newAcct_Q_BMO,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volume_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) shareAcct_newAcct_Q_BMO,
volume_newAcct_Q_PEER ,
grandTotalAcct_newAcct_Q_PEER,
if(grandTotalAcct_newAcct_Q_PEER<>0,(volume_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER )*100,null) shareAcct_newAcct_Q_PEER,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volume_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) - if(grandTotalAcct_newAcct_Q_PEER<>0,(volume_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER )*100,null) variance_newAcct_Q_to_peer ,

volume_newAcct_Y_BMO, 
grandTotalAcct_newAcct_Y_BMO,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volume_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) shareAcct_newAcct_Y_BMO,
volume_newAcct_Y_PEER ,
grandTotalAcct_newAcct_Y_PEER,
if(grandTotalAcct_newAcct_Y_PEER<>0,(volume_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER )*100,null) shareAcct_newAcct_Y_PEER,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volume_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) - if(grandTotalAcct_newAcct_Y_PEER<>0,(volume_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER )*100,null) variance_newAcct_Y_to_peer 
from cur
order by year_month,product  ,ers_band;

--age
with cur as 
( select t.year_month,t.pi2_product product,s.consumer_age_cat,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,t.pi2_product) grandTotalAcct_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) volume_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) volume_newAcct_M_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P' and account_age=1 )) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_M_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P' and account_age=1 ) ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_M_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Q_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Q_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_Y='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Y_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_Y='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Y_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.consumer_age_cat )  
select year_month,cur.product product,cur.consumer_age_cat,
--chart #accounts
volume_BMO, 
grandTotalAcct_BMO,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
volume_PEER ,
grandTotalAcct_PEER,
if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) - if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) variance_to_peer ,

volume_newAcct_M_BMO, 
grandTotalAcct_newAcct_M_BMO,
if(grandTotalAcct_newAcct_M_BMO<>0,(volume_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) shareAcct_newAcct_M_BMO,
volume_newAcct_M_PEER ,
grandTotalAcct_newAcct_M_PEER,
if(grandTotalAcct_newAcct_M_PEER<>0,(volume_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER )*100,null) shareAcct_newAcct_M_PEER,
if(grandTotalAcct_newAcct_M_BMO<>0,(volume_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) - if(grandTotalAcct_newAcct_M_PEER<>0,(volume_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER )*100,null) variance_newAcct_M_to_peer ,


volume_newAcct_Q_BMO, 
grandTotalAcct_newAcct_Q_BMO,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volume_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) shareAcct_newAcct_Q_BMO,
volume_newAcct_Q_PEER ,
grandTotalAcct_newAcct_Q_PEER,
if(grandTotalAcct_newAcct_Q_PEER<>0,(volume_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER )*100,null) shareAcct_newAcct_Q_PEER,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volume_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) - if(grandTotalAcct_newAcct_Q_PEER<>0,(volume_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER )*100,null) variance_newAcct_Q_to_peer ,

volume_newAcct_Y_BMO, 
grandTotalAcct_newAcct_Y_BMO,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volume_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) shareAcct_newAcct_Y_BMO,
volume_newAcct_Y_PEER ,
grandTotalAcct_newAcct_Y_PEER,
if(grandTotalAcct_newAcct_Y_PEER<>0,(volume_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER )*100,null) shareAcct_newAcct_Y_PEER,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volume_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) - if(grandTotalAcct_newAcct_Y_PEER<>0,(volume_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER )*100,null) variance_newAcct_Y_to_peer 
from cur
order by year_month,product  ,consumer_age_cat;



 

 -- hive
 
 with source as 
( select t.pi2_product product, t.year_month,
 
sum(if(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P',1,0)) volume_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',1,0) ) volume_PEER ,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(if(c.fi_name = "BANK OF MONTREAL" ,1,0)) tradelines_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" ,1,0) ) tradelines_PEER ,
--new account
sum(if(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P',1,0)) volume_newAcct_M_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P',1,0)) volume_newAcct_M_PEER ,
sum(if(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P',1,0)) volume_newAcct_Q_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P',1,0)) volume_newAcct_Q_PEER ,
sum(if(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' and t.joint_flag='P',1,0)) volume_newAcct_Y_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' and t.joint_flag='P',1,0)) volume_newAcct_Y_PEER ,
sum(if(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' ,1,0)) tradelines_newAcct_M_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y',1,0) ) tradelines_newAcct_M_PEER ,
sum(if(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' ,1,0)) tradelines_newAcct_Q_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' ,1,0)) tradelines_newAcct_Q_PEER ,
sum(if(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' ,1,0)) tradelines_newAcct_Y_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y',1,0))  tradelines_newAcct_Y_PEER 
from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and c.year_month=greatest( 201609, t.year_month)
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
cur.volume_BMO, 
pre.volume_BMO,
if(pre.volume_BMO<>0,(cur.volume_BMO/pre.volume_BMO -1)*100,null) volumeRate_BMO_sinceLast,
cur.volume_PEER ,
pre.volume_PEER,
if(pre.volume_PEER<>0,(cur.volume_PEER/pre.volume_PEER -1)*100,null) volumeRate_PEER_sinceLast,
 
--cur.balance_BMO,
--if(pre.balance_BMO<>0,cur.balance_BMO/pre.balance_BMO-1)*100,null) balanceRate_BMO_sinceLast,
--cur.balance_PEER,
--if(pre.balance_PEER<>0,cur.balance_PEER/pre.balance_PEER-1)*100,null) balanceRate_PEER_sinceLast,
--chart 31
cur.tradelines_BMO, 
if(pre.tradelines_BMO<>0,(cur.tradelines_BMO/pre.tradelines_BMO-1)*100,null) tradelinesRate_BMO_sinceLast,
cur.tradelines_PEER ,
if(pre.tradelines_PEER<>0,(cur.tradelines_PEER/pre.tradelines_PEER-1)*100,null) tradelinesRate_PEER_sinceLast,

cur.volume_newAcct_M_BMO,
if(pre.volume_newAcct_M_BMO<>0,(cur.volume_newAcct_M_BMO/pre.volume_newAcct_M_BMO-1)*100,null) volumeRate_newAcct_M_BMO_sinceLast,
cur.volume_newAcct_M_PEER,
if(pre.volume_newAcct_Y_PEER<>0,(cur.volume_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER-1)*100,null) volumeRate_newAcct_Y_PEER_sinceLast,
cur.tradelines_newAcct_M_BMO, 
if(pre.tradelines_newAcct_M_BMO<>0,(cur.tradelines_newAcct_M_BMO/pre.tradelines_newAcct_M_BMO-1)*100,null) tradelinesRate_newAcct_M_BMO_sinceLast,
cur.tradelines_newAcct_M_PEER ,
if(pre.tradelines_newAcct_M_PEER<>0,(cur.tradelines_newAcct_M_PEER/pre.tradelines_newAcct_M_PEER-1)*100,null) tradelinesRate_newAcct_M_PEER_sinceLast,

cur.volume_newAcct_Q_BMO,
if(pre.volume_newAcct_Q_BMO<>0,(cur.volume_newAcct_Q_BMO/pre.volume_newAcct_Q_BMO-1)*100,null) volumeRate_newAcct_Q_BMO_sinceLast,
cur.volume_newAcct_Q_PEER,
if(pre.volume_newAcct_Q_PEER<>0,(cur.volume_newAcct_Q_PEER/pre.volume_newAcct_Q_PEER-1)*100,null) volumeRate_newAcct_Q_PEER_sinceLast,
cur.tradelines_newAcct_Q_BMO, 
if(pre.tradelines_newAcct_Q_BMO<>0,(cur.tradelines_newAcct_Q_BMO/pre.tradelines_newAcct_Q_BMO-1)*100,null) tradelinesRate_newAcct_Q_BMO_sinceLast,
cur.tradelines_newAcct_Q_PEER ,
if(pre.tradelines_newAcct_Q_PEER<>0,(cur.tradelines_newAcct_Q_PEER/pre.tradelines_newAcct_Q_PEER-1)*100,null) tradelinesRate_newAcct_Q_PEER_sinceLast,

cur.volume_newAcct_Y_BMO,
if(pre.volume_newAcct_Y_BMO<>0,(cur.volume_newAcct_Y_BMO/pre.volume_newAcct_Y_BMO-1)*100,null) volumeRate_newAcct_Y_BMO_sinceLast,
cur.volume_newAcct_Y_PEER,
if(pre.volume_newAcct_Y_PEER<>0,(cur.volume_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER-1)*100,null) volumeRate_newAcct_Y_PEER_sinceLast,

cur.tradelines_newAcct_Y_BMO, 
if(pre.tradelines_newAcct_Y_BMO<>0,(cur.tradelines_newAcct_Y_BMO/pre.tradelines_newAcct_Y_BMO-1)*100,null) tradelinesRate_newAcct_Y_BMO_sinceLast,
cur.tradelines_newAcct_Y_PEER ,
if(pre.tradelines_newAcct_Y_PEER<>0,(cur.tradelines_newAcct_Y_PEER/pre.tradelines_newAcct_Y_PEER-1)*100,null) tradelinesRate_newAcct_Y_PEER_sinceLast
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  cur.year_month-100;
 