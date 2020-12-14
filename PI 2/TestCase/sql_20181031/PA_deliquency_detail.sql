with cur as 
( select t.year_month, t.vintage_month,t.pi2_product product,ts.province,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalAcct_PEER,
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') volume_active_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') volume_active_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL" and active_flag='Y')) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalAcct_active_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ) ) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalAcct_active_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) balance_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0)))  over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalbalance_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalbalance_PEER,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))  balance_active_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0)) balance_active_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalbalance_active_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0))) over(partition by t.year_month,t.vintage_month,t.pi2_product)  grandTotalbalance_active_PEER,

--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))  credit_limit_active_BMO,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalcredit_limit_BMO,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))) over(partition by t.year_month,t.vintage_month,t.pi2_product)  grandTotalcredit_limit_active_BMO,


sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0)) credit_limit_PEER,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0)) credit_limit_active_PEER,

sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalcredit_limit_PEER,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))) over(partition by t.year_month,t.vintage_month,t.pi2_product) grandTotalcredit_limit_active_PEER,

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0)) balance_deli_PEER

from pi2_trade_o t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month

left join pi2_development_db.pi2_consumer_n ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month


where 
t.vintage_month=${vintage_month}
 and t.year_month=${currMonth}
 
group by t.year_month,t.vintage_month,t.pi2_product,ts.province )  
select year_month,cur.product product,province,
--chart #acvolumes
volume_BMO, 
grandTotalAcct_BMO,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
volume_PEER ,
grandTotalAcct_PEER,
if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) - if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) variance_to_peer ,

--totalBalance
balance_BMO, 
grandTotalBalance_BMO,
if(grandTotalBalance_BMO<>0,(balance_BMO/grandTotalBalance_BMO)*100,null) shareAcct_BMO,
balance_PEER ,
grandTotalBalance_PEER,
if(grandTotalBalance_PEER<>0,(balance_PEER/grandTotalBalance_PEER )*100,null) shareAcct_PEER,
if(grandTotalBalance_BMO<>0,(balance_BMO/grandTotalBalance_BMO)*100,null) - if(grandTotalBalance_PEER<>0,(balance_PEER/grandTotalBalance_PEER )*100,null) variance_to_peer ,
--averageBalance Per acvolume
if(volume_BMO<>0,(balance_BMO/volume_BMO)*100,null) avg_balance_BMO,
if(volume_PEER<>0,(balance_PEER/volume_PEER)*100,null) avg_balance_PEER,
--average balance per active acvolume
volume_active_BMO,balance_active_BMO,if(volume_active_BMO<>0,balance_active_BMO/volume_active_BMO,null) avg_active_balance_BMO,
volume_active_PEER,balance_active_PEER,if(volume_active_PEER<>0,balance_active_PEER/volume_active_PEER,null) avg_active_balance_PEER,
--utilization rate 
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER,
--utilization active rate
if(credit_limit_active_BMO<>0,balance_active_BMO/credit_limit_active_BMO*100,null) uti_active_BMO,
if(credit_limit_active_PEER<>0,balance_active_PEER/credit_limit_active_PEER*100,null) uti_active_PEER,
--delinquencyRate
balance_deli_BMO,if(balance_BMO<>0,balance_deli_BMO/balance_BMO*100,null) delinquencyBalanceRate_BMO,
balance_deli_PEER,if(balance_PEER<>0,balance_deli_PEER/balance_PEER*100,null) delinquencyBalanceRate_PEER
from cur
order by year_month,product  ,province;