with cur as 
( select t.year_month,t.pi2_product product,s.province,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,t.pi2_product) grandTotalAcct_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P') volumn_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P') volumn_newAcct_M_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_M_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_M_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P') volumn_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') volumn_newAcct_Q_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Q_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Q_PEER,
sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' and t.joint_flag='P') volumn_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' and t.joint_flag='P') volumn_newAcct_Y_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" and new_account_Y='Y' and t.joint_flag='P')) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Y_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_Y='Y' and t.joint_flag='P') ) over (partition by t.year_month,t.pi2_product) grandTotalAcct_newAcct_Y_PEER

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
select cur.product product,cur.province,
--chart #accounts
volumn_BMO, 
grandTotalAcct_BMO,
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
volumn_PEER ,
grandTotalAcct_PEER,
if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) - if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER )*100,null) variance_to_peer ,

volumn_newAcct_M_BMO, 
grandTotalAcct_newAcct_M_BMO,
if(grandTotalAcct_newAcct_M_BMO<>0,(volumn_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) shareAcct_newAcct_M_BMO,
volumn_newAcct_M_PEER ,
grandTotalAcct_newAcct_M_PEER,
if(grandTotalAcct_newAcct_M_PEER<>0,(volumn_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER )*100,null) shareAcct_newAcct_M_PEER,
if(grandTotalAcct_newAcct_M_BMO<>0,(volumn_newAcct_M_BMO/grandTotalAcct_newAcct_M_BMO)*100,null) - if(grandTotalAcct_newAcct_M_PEER<>0,(volumn_newAcct_M_PEER/grandTotalAcct_newAcct_M_PEER )*100,null) variance_newAcct_M_to_peer ,


volumn_newAcct_Q_BMO, 
grandTotalAcct_newAcct_Q_BMO,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volumn_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) shareAcct_newAcct_Q_BMO,
volumn_newAcct_Q_PEER ,
grandTotalAcct_newAcct_Q_PEER,
if(grandTotalAcct_newAcct_Q_PEER<>0,(volumn_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER )*100,null) shareAcct_newAcct_Q_PEER,
if(grandTotalAcct_newAcct_Q_BMO<>0,(volumn_newAcct_Q_BMO/grandTotalAcct_newAcct_Q_BMO)*100,null) - if(grandTotalAcct_newAcct_Q_PEER<>0,(volumn_newAcct_Q_PEER/grandTotalAcct_newAcct_Q_PEER )*100,null) variance_newAcct_Q_to_peer ,

volumn_newAcct_Y_BMO, 
grandTotalAcct_newAcct_Y_BMO,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volumn_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) shareAcct_newAcct_Y_BMO,
volumn_newAcct_Y_PEER ,
grandTotalAcct_newAcct_Y_PEER,
if(grandTotalAcct_newAcct_Y_PEER<>0,(volumn_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER )*100,null) shareAcct_newAcct_Y_PEER,
if(grandTotalAcct_newAcct_Y_BMO<>0,(volumn_newAcct_Y_BMO/grandTotalAcct_newAcct_Y_BMO)*100,null) - if(grandTotalAcct_newAcct_Y_PEER<>0,(volumn_newAcct_Y_PEER/grandTotalAcct_newAcct_Y_PEER )*100,null) variance_newAcct_Y_to_peer 
from cur
order by year_month,product  ,province;