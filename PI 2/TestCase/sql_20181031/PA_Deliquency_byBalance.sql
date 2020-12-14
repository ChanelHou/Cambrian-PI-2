--chart 37-40,  by all account  by months  , chart 44 , the balance $ is fine , but the rate is not correct, the deliquenctRate is not correct for all the charts.
with source as 
( select t.pi2_product product, t.year_month,
--all account 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_PEER,

sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1')  account_30DPD_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1')  account_30DPD_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1')  account_60DPD_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1')  account_60DPD_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt')  account_BadDebt_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt')  account_BadDebt_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1',balance,0))  balance_30DPD_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1',balance,0))  balance_60DPD_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt',balance,0))  balance_BadDebt_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt',balance,0))  balance_BadDebt_PEER,

--new account
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and account_age=1) volume_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and account_age=1 ) volume_newAcct_M_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and account_age=1,balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and account_age=1,balance,0))  balance_newAcct_M_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1,balance,0))  balance_deli_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1,balance,0))  balance_deli_newAcct_M_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_m='Y' and account_age=1,balance,0))  balance_30DPD_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_m='Y' and account_age=1,balance,0))  balance_30DPD_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_m='Y' and account_age=1,balance,0))  balance_60DPD_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_m='Y' and account_age=1,balance,0))  balance_60DPD_newAcct_M_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_m='Y' and account_age=1,balance,0))  balance_BadDebt_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_m='Y' and account_age=1,balance,0))  balance_BadDebt_newAcct_M_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_m='Y' and account_age=1)  account_30DPD_newAcct_M_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_m='Y' and account_age=1)  account_30DPD_newAcct_M_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_m='Y' and account_age=1)  account_60DPD_newAcct_M_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_m='Y' and account_age=1)  account_60DPD_newAcct_M_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_m='Y' and account_age=1)  account_BadDebt_newAcct_M_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_m='Y' and account_age=1)  account_BadDebt_newAcct_M_PEER,


--new account by quarter
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y' ) volume_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y'  ) volume_newAcct_Q_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y' ,balance,0))  balance_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y' ,balance,0))  balance_newAcct_Q_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y' ) volume_deli_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y' ) volume_deli_newAcct_Q_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y' ,balance,0))  balance_deli_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y' ,balance,0))  balance_deli_newAcct_Q_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_q='Y' ,balance,0))  balance_30DPD_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_q='Y' ,balance,0))  balance_30DPD_newAcct_Q_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_q='Y' ,balance,0))  balance_60DPD_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_q='Y' ,balance,0))  balance_60DPD_newAcct_Q_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_q='Y' ,balance,0))  balance_BadDebt_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_q='Y' ,balance,0))  balance_BadDebt_newAcct_Q_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_q='Y' )  account_30DPD_newAcct_Q_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_q='Y' )  account_30DPD_newAcct_Q_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_q='Y' )  account_60DPD_newAcct_Q_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_q='Y' )  account_60DPD_newAcct_Q_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_q='Y' )  account_BadDebt_newAcct_Q_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_q='Y' )  account_BadDebt_newAcct_Q_PEER,
--new account by year
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y' ) volume_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y'  ) volume_newAcct_Y_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y' ,balance,0))  balance_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y' ,balance,0))  balance_newAcct_Y_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y' ) volume_deli_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y' ) volume_deli_newAcct_Y_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y' ,balance,0))  balance_deli_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y' ,balance,0))  balance_deli_newAcct_Y_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_y='Y' ,balance,0))  balance_30DPD_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_y='Y' ,balance,0))  balance_30DPD_newAcct_Y_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_y='Y' ,balance,0))  balance_60DPD_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_y='Y' ,balance,0))  balance_60DPD_newAcct_Y_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_y='Y' ,balance,0))  balance_BadDebt_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_y='Y' ,balance,0))  balance_BadDebt_newAcct_Y_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_y='Y' )  account_30DPD_newAcct_Y_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='30' and trade_status='1' and new_account_y='Y' )  account_30DPD_newAcct_Y_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_y='Y' )  account_60DPD_newAcct_Y_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='60' and trade_status='1' and new_account_y='Y' )  account_60DPD_newAcct_Y_PEER,
sum(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_y='Y' )  account_BadDebt_newAcct_Y_BMO,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='BadDebt' and new_account_y='Y' )  account_BadDebt_newAcct_Y_PEER

from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 ( t.year_month between ${fromMonth} and ${toMonth} or t.year_month in (201601,201701,201706))
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month )  
select cur.product , cur.year_month,
--chart 45 , by volume
cur.volume_BMO, 
cur.volume_deli_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) - if(pre.volume_BMO<>0,pre.volume_deli_BMO/pre.volume_BMO*100,null)  deliquency_SinceLast_BMO,
cur.volume_PEER ,
cur.volume_deli_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) deliquencyRate_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) - if(pre.volume_PEER<>0,pre.volume_deli_PEER/pre.volume_PEER*100,null) deliquency_SinceLast_PEER,
--chart 45 by balance
cur.balance_BMO, 
cur.balance_deli_BMO,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) deliquencyRate_BMO,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) - if(pre.balance_BMO<>0,pre.balance_deli_BMO/pre.balance_BMO*100,null)  deliquency_SinceLast_BMO,
cur.balance_PEER ,
cur.balance_deli_PEER,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) deliquencyRate_PEER,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) - if(pre.balance_PEER<>0,pre.balance_deli_PEER/pre.balance_PEER*100,null) deliquency_SinceLast_PEER,
--chart 44
cur.balance_deli_BMO,
cur.balance_deli_PEER,
if(pre.balance_deli_BMO<>0,(cur.balance_deli_BMO/pre.balance_deli_BMO -1)*100,null) deliquencyBalance_SinceLast_BMO,
if(pre.balance_deli_PEER<>0,(cur.balance_deli_PEER/pre.balance_deli_PEER -1)*100,null) deliquencyBalance_SinceLast_PEER,
--chart 46
cur.balance_30DPD_BMO,
cur.balance_60DPD_BMO,
cur.balance_BadDebt_BMO,
cur.balance_30DPD_PEER,
cur.balance_60DPD_PEER,
cur.balance_BadDebt_PEER,
if(cur.balance_BMO<>0,cur.balance_30DPD_BMO/cur.balance_BMO*100,null) balanceRate_30DPD_BMO,
if(cur.balance_BMO<>0,cur.balance_60DPD_BMO/cur.balance_BMO*100,null) balanceRate_60DPD_BMO, 
if(cur.balance_BMO<>0,cur.balance_BadDebt_BMO/cur.balance_BMO*100,null) balanceRate_BadDebt_BMO,
if(cur.balance_BMO<>0,cur.balance_deli_BMO/cur.balance_BMO*100,null) balanceRate_deli_BMO,

if(cur.balance_PEER<>0,cur.balance_30DPD_PEER/cur.balance_PEER*100,null) balanceRate_30DPD_PEER,
if(cur.balance_PEER<>0,cur.balance_60DPD_PEER/cur.balance_PEER*100,null) balanceRate_60DPD_PEER, 
if(cur.balance_PEER<>0,cur.balance_BadDebt_PEER/cur.balance_PEER*100,null) balanceRate_BadDebt_PEER,
if(cur.balance_PEER<>0,cur.balance_deli_PEER/cur.balance_PEER*100,null) balanceRate_deli_PEER,

--new account by month
--chart 45 by balance
cur.balance_newAcct_M_BMO, 
cur.balance_deli_newAcct_M_BMO,
if(cur.balance_newAcct_M_BMO<>0,cur.balance_deli_newAcct_M_BMO/cur.balance_newAcct_M_BMO*100,null) deliquencyRate_newAcct_M_BMO,
if(cur.balance_newAcct_M_BMO<>0,cur.balance_deli_newAcct_M_BMO/cur.balance_newAcct_M_BMO*100,null) - if(pre.balance_newAcct_M_BMO<>0,pre.balance_deli_newAcct_M_BMO/pre.balance_newAcct_M_BMO*100,null)  deliquency_SinceLast_newAcct_M_BMO,
cur.balance_newAcct_M_PEER ,
cur.balance_deli_newAcct_M_PEER,
if(cur.balance_newAcct_M_PEER<>0,cur.balance_deli_newAcct_M_PEER/cur.balance_newAcct_M_PEER*100,null) deliquencyRate_newAcct_M_PEER,
if(cur.balance_newAcct_M_PEER<>0,cur.balance_deli_newAcct_M_PEER/cur.balance_newAcct_M_PEER*100,null) - if(pre.balance_newAcct_M_PEER<>0,pre.balance_deli_newAcct_M_PEER/pre.balance_newAcct_M_PEER*100,null) deliquency_SinceLast_newAcct_M_PEER,
--chart 45 by volume

cur.volume_newAcct_M_BMO, 
cur.volume_deli_newAcct_M_BMO,
if(cur.volume_newAcct_M_BMO<>0,cur.volume_deli_newAcct_M_BMO/cur.volume_newAcct_M_BMO*100,null) deliquencyRate_newAcct_M_BMO,
if(cur.volume_newAcct_M_BMO<>0,cur.volume_deli_newAcct_M_BMO/cur.volume_newAcct_M_BMO*100,null) - if(pre.volume_newAcct_M_BMO<>0,pre.volume_deli_newAcct_M_BMO/pre.volume_newAcct_M_BMO*100,null)  deliquency_SinceLast_newAcct_M_BMO,
cur.volume_newAcct_M_PEER ,
cur.volume_deli_newAcct_M_PEER,
if(cur.volume_newAcct_M_PEER<>0,cur.volume_deli_newAcct_M_PEER/cur.volume_newAcct_M_PEER*100,null) deliquencyRate_newAcct_M_PEER,
if(cur.volume_newAcct_M_PEER<>0,cur.volume_deli_newAcct_M_PEER/cur.volume_newAcct_M_PEER*100,null) - if(pre.volume_newAcct_M_PEER<>0,pre.volume_deli_newAcct_M_PEER/pre.volume_newAcct_M_PEER*100,null) deliquency_SinceLast_newAcct_M_PEER,
--chart 44
cur.balance_deli_newAcct_M_BMO,
cur.balance_deli_newAcct_M_PEER,
if(pre.balance_deli_newAcct_M_BMO<>0,(cur.balance_deli_newAcct_M_BMO/pre.balance_deli_newAcct_M_BMO -1)*100,null) deliquencyBalance_SinceLast_newAcct_M_BMO,
if(pre.balance_deli_newAcct_M_PEER<>0,(cur.balance_deli_newAcct_M_PEER/pre.balance_deli_newAcct_M_PEER -1)*100,null) deliquencyBalance_SinceLast_newAcct_M_PEER,
--chart 46
cur.balance_30DPD_newAcct_M_BMO,
cur.balance_60DPD_newAcct_M_BMO,
cur.balance_BadDebt_newAcct_M_BMO,
cur.balance_30DPD_newAcct_M_PEER,
cur.balance_60DPD_newAcct_M_PEER,
cur.balance_BadDebt_newAcct_M_PEER,
if(cur.balance_newAcct_M_BMO<>0,cur.balance_30DPD_newAcct_M_BMO/cur.balance_newAcct_M_BMO*100,null) balanceRate_30DPD_newAcct_M_BMO,
if(cur.balance_newAcct_M_BMO<>0,cur.balance_60DPD_newAcct_M_BMO/cur.balance_newAcct_M_BMO*100,null) balanceRate_60DPD_newAcct_M_BMO, 
if(cur.balance_newAcct_M_BMO<>0,cur.balance_BadDebt_newAcct_M_BMO/cur.balance_newAcct_M_BMO*100,null) balanceRate_BadDebt_newAcct_M_BMO,
if(cur.balance_newAcct_M_BMO<>0,cur.balance_deli_newAcct_M_BMO/cur.balance_newAcct_M_BMO*100,null) balanceRate_deli_newAcct_M_BMO,

if(cur.balance_newAcct_M_PEER<>0,cur.balance_30DPD_newAcct_M_PEER/cur.balance_newAcct_M_PEER*100,null) balanceRate_30DPD_newAcct_M_PEER,
if(cur.balance_newAcct_M_PEER<>0,cur.balance_60DPD_newAcct_M_PEER/cur.balance_newAcct_M_PEER*100,null) balanceRate_60DPD_newAcct_M_PEER, 
if(cur.balance_newAcct_M_PEER<>0,cur.balance_BadDebt_newAcct_M_PEER/cur.balance_newAcct_M_PEER*100,null) balanceRate_BadDebt_newAcct_M_PEER,
if(cur.balance_newAcct_M_PEER<>0,cur.balance_deli_newAcct_M_PEER/cur.balance_newAcct_M_PEER*100,null) balanceRate_deli_newAcct_M_PEER,
--new account by quarter
cur.balance_newAcct_Q_BMO, 
cur.balance_deli_newAcct_Q_BMO,
if(cur.balance_newAcct_Q_BMO<>0,cur.balance_deli_newAcct_Q_BMO/cur.balance_newAcct_Q_BMO*100,null) deliquencyRate_newAcct_Q_BMO,
if(cur.balance_newAcct_Q_BMO<>0,cur.balance_deli_newAcct_Q_BMO/cur.balance_newAcct_Q_BMO*100,null) - if(pre.balance_newAcct_Q_BMO<>0,pre.balance_deli_newAcct_Q_BMO/pre.balance_newAcct_Q_BMO*100,null)  deliquency_SinceLast_newAcct_Q_BMO,
cur.balance_newAcct_Q_PEER ,
cur.balance_deli_newAcct_Q_PEER,
if(cur.balance_newAcct_Q_PEER<>0,cur.balance_deli_newAcct_Q_PEER/cur.balance_newAcct_Q_PEER*100,null) deliquencyRate_newAcct_Q_PEER,
if(cur.balance_newAcct_Q_PEER<>0,cur.balance_deli_newAcct_Q_PEER/cur.balance_newAcct_Q_PEER*100,null) - if(pre.balance_newAcct_Q_PEER<>0,pre.balance_deli_newAcct_Q_PEER/pre.balance_newAcct_Q_PEER*100,null) deliquency_SinceLast_newAcct_Q_PEER,


cur.volume_newAcct_Q_BMO, 
cur.volume_deli_newAcct_Q_BMO,
if(cur.volume_newAcct_Q_BMO<>0,cur.volume_deli_newAcct_Q_BMO/cur.volume_newAcct_Q_BMO*100,null) deliquencyRate_newAcct_Q_BMO,
if(cur.volume_newAcct_Q_BMO<>0,cur.volume_deli_newAcct_Q_BMO/cur.volume_newAcct_Q_BMO*100,null) - if(pre.volume_newAcct_Q_BMO<>0,pre.volume_deli_newAcct_Q_BMO/pre.volume_newAcct_Q_BMO*100,null)  deliquency_SinceLast_newAcct_Q_BMO,
cur.volume_newAcct_Q_PEER ,
cur.volume_deli_newAcct_Q_PEER,
if(cur.volume_newAcct_Q_PEER<>0,cur.volume_deli_newAcct_Q_PEER/cur.volume_newAcct_Q_PEER*100,null) deliquencyRate_newAcct_Q_PEER,
if(cur.volume_newAcct_Q_PEER<>0,cur.volume_deli_newAcct_Q_PEER/cur.volume_newAcct_Q_PEER*100,null) - if(pre.volume_newAcct_Q_PEER<>0,pre.volume_deli_newAcct_Q_PEER/pre.volume_newAcct_Q_PEER*100,null) deliquency_SinceLast_newAcct_Q_PEER,
--chart 44
cur.balance_deli_newAcct_Q_BMO,
cur.balance_deli_newAcct_Q_PEER,
if(pre.balance_deli_newAcct_Q_BMO<>0,(cur.balance_deli_newAcct_Q_BMO/pre.balance_deli_newAcct_Q_BMO -1)*100,null) deliquencyBalance_SinceLast_newAcct_Q_BMO,
if(pre.balance_deli_newAcct_Q_PEER<>0,(cur.balance_deli_newAcct_Q_PEER/pre.balance_deli_newAcct_Q_PEER -1)*100,null) deliquencyBalance_SinceLast_newAcct_Q_PEER,
--chart 46
cur.balance_30DPD_newAcct_Q_BMO,
cur.balance_60DPD_newAcct_Q_BMO,
cur.balance_BadDebt_newAcct_Q_BMO,
cur.balance_30DPD_newAcct_Q_PEER,
cur.balance_60DPD_newAcct_Q_PEER,
cur.balance_BadDebt_newAcct_Q_PEER,
if(cur.balance_newAcct_Q_BMO<>0,cur.balance_30DPD_newAcct_Q_BMO/cur.balance_newAcct_Q_BMO*100,null) balanceRate_30DPD_newAcct_Q_BMO,
if(cur.balance_newAcct_Q_BMO<>0,cur.balance_60DPD_newAcct_Q_BMO/cur.balance_newAcct_Q_BMO*100,null) balanceRate_60DPD_newAcct_Q_BMO, 
if(cur.balance_newAcct_Q_BMO<>0,cur.balance_BadDebt_newAcct_Q_BMO/cur.balance_newAcct_Q_BMO*100,null) balanceRate_BadDebt_newAcct_Q_BMO,
if(cur.balance_newAcct_Q_BMO<>0,cur.balance_deli_newAcct_Q_BMO/cur.balance_newAcct_Q_BMO*100,null) balanceRate_deli_newAcct_Q_BMO,

if(cur.balance_newAcct_Q_PEER<>0,cur.balance_30DPD_newAcct_Q_PEER/cur.balance_newAcct_Q_PEER*100,null) balanceRate_30DPD_newAcct_Q_PEER,
if(cur.balance_newAcct_Q_PEER<>0,cur.balance_60DPD_newAcct_Q_PEER/cur.balance_newAcct_Q_PEER*100,null) balanceRate_60DPD_newAcct_Q_PEER, 
if(cur.balance_newAcct_Q_PEER<>0,cur.balance_BadDebt_newAcct_Q_PEER/cur.balance_newAcct_Q_PEER*100,null) balanceRate_BadDebt_newAcct_Q_PEER,
if(cur.balance_newAcct_Q_PEER<>0,cur.balance_deli_newAcct_Q_PEER/cur.balance_newAcct_Q_PEER*100,null) balanceRate_deli_newAcct_Q_PEER,
--new account by year,
cur.balance_newAcct_Y_BMO, 
cur.balance_deli_newAcct_Y_BMO,
if(cur.balance_newAcct_Y_BMO<>0,cur.balance_deli_newAcct_Y_BMO/cur.balance_newAcct_Y_BMO*100,null) deliquencyRate_newAcct_Y_BMO,
if(cur.balance_newAcct_Y_BMO<>0,cur.balance_deli_newAcct_Y_BMO/cur.balance_newAcct_Y_BMO*100,null) - if(pre.balance_newAcct_Y_BMO<>0,pre.balance_deli_newAcct_Y_BMO/pre.balance_newAcct_Y_BMO*100,null)  deliquency_SinceLast_newAcct_Y_BMO,
cur.balance_newAcct_Y_PEER ,
cur.balance_deli_newAcct_Y_PEER,
if(cur.balance_newAcct_Y_PEER<>0,cur.balance_deli_newAcct_Y_PEER/cur.balance_newAcct_Y_PEER*100,null) deliquencyRate_newAcct_Y_PEER,
if(cur.balance_newAcct_Y_PEER<>0,cur.balance_deli_newAcct_Y_PEER/cur.balance_newAcct_Y_PEER*100,null) - if(pre.balance_newAcct_Y_PEER<>0,pre.balance_deli_newAcct_Y_PEER/pre.balance_newAcct_Y_PEER*100,null) deliquency_SinceLast_newAcct_Y_PEER,

cur.volume_newAcct_Y_BMO, 
cur.volume_deli_newAcct_Y_BMO,
if(cur.volume_newAcct_Y_BMO<>0,cur.volume_deli_newAcct_Y_BMO/cur.volume_newAcct_Y_BMO*100,null) deliquencyRate_newAcct_Y_BMO,
if(cur.volume_newAcct_Y_BMO<>0,cur.volume_deli_newAcct_Y_BMO/cur.volume_newAcct_Y_BMO*100,null) - if(pre.volume_newAcct_Y_BMO<>0,pre.volume_deli_newAcct_Y_BMO/pre.volume_newAcct_Y_BMO*100,null)  deliquency_SinceLast_newAcct_Y_BMO,
cur.volume_newAcct_Y_PEER ,
cur.volume_deli_newAcct_Y_PEER,
if(cur.volume_newAcct_Y_PEER<>0,cur.volume_deli_newAcct_Y_PEER/cur.volume_newAcct_Y_PEER*100,null) deliquencyRate_newAcct_Y_PEER,
if(cur.volume_newAcct_Y_PEER<>0,cur.volume_deli_newAcct_Y_PEER/cur.volume_newAcct_Y_PEER*100,null) - if(pre.volume_newAcct_Y_PEER<>0,pre.volume_deli_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER*100,null) deliquency_SinceLast_newAcct_Y_PEER,
--chart 44
cur.balance_deli_newAcct_Y_BMO,
cur.balance_deli_newAcct_Y_PEER,
if(pre.balance_deli_newAcct_Y_BMO<>0,(cur.balance_deli_newAcct_Y_BMO/pre.balance_deli_newAcct_Y_BMO -1)*100,null) deliquencyBalance_SinceLast_newAcct_Y_BMO,
if(pre.balance_deli_newAcct_Y_PEER<>0,(cur.balance_deli_newAcct_Y_PEER/pre.balance_deli_newAcct_Y_PEER -1)*100,null) deliquencyBalance_SinceLast_newAcct_Y_PEER,
--chart 46
cur.balance_30DPD_newAcct_Y_BMO,
cur.balance_60DPD_newAcct_Y_BMO,
cur.balance_BadDebt_newAcct_Y_BMO,
cur.balance_30DPD_newAcct_Y_PEER,
cur.balance_60DPD_newAcct_Y_PEER,
cur.balance_BadDebt_newAcct_Y_PEER,
if(cur.balance_newAcct_Y_BMO<>0,cur.balance_30DPD_newAcct_Y_BMO/cur.balance_newAcct_Y_BMO*100,null) balanceRate_30DPD_newAcct_Y_BMO,
if(cur.balance_newAcct_Y_BMO<>0,cur.balance_60DPD_newAcct_Y_BMO/cur.balance_newAcct_Y_BMO*100,null) balanceRate_60DPD_newAcct_Y_BMO, 
if(cur.balance_newAcct_Y_BMO<>0,cur.balance_BadDebt_newAcct_Y_BMO/cur.balance_newAcct_Y_BMO*100,null) balanceRate_BadDebt_newAcct_Y_BMO,
if(cur.balance_newAcct_Y_BMO<>0,cur.balance_deli_newAcct_Y_BMO/cur.balance_newAcct_Y_BMO*100,null) balanceRate_deli_newAcct_Y_BMO,

if(cur.balance_newAcct_Y_PEER<>0,cur.balance_30DPD_newAcct_Y_PEER/cur.balance_newAcct_Y_PEER*100,null) balanceRate_30DPD_newAcct_Y_PEER,
if(cur.balance_newAcct_Y_PEER<>0,cur.balance_60DPD_newAcct_Y_PEER/cur.balance_newAcct_Y_PEER*100,null) balanceRate_60DPD_newAcct_Y_PEER, 
if(cur.balance_newAcct_Y_PEER<>0,cur.balance_BadDebt_newAcct_Y_PEER/cur.balance_newAcct_Y_PEER*100,null) balanceRate_BadDebt_newAcct_Y_PEER,
if(cur.balance_newAcct_Y_PEER<>0,cur.balance_deli_newAcct_Y_PEER/cur.balance_newAcct_Y_PEER*100,null) balanceRate_deli_newAcct_Y_PEER
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  if(mod(cur.year_month,100)=1 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-1)
order by cur.year_month,cur.product;





--only for by year
with source as 
( select t.pi2_product product, t.year_month,
--all account 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_PEER,
--new account
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and account_age=1) volume_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and account_age=1 ) volume_newAcct_M_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and account_age=1,balance,0))  balance_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_m='Y' and account_age=1,balance,0))  balance_newAcct_M_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1,balance,0))  balance_deli_newAcct_M_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1,balance,0))  balance_deli_newAcct_M_PEER,
--new account by quarter
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y') volume_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y' ) volume_newAcct_Q_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_q='Y',balance,0))  balance_newAcct_Q_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y') volume_deli_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y') volume_deli_newAcct_Q_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y',balance,0))  balance_deli_newAcct_Q_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y',balance,0))  balance_deli_newAcct_Q_PEER,
--new account by year
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y') volume_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y' ) volume_newAcct_Y_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and new_account_y='Y',balance,0))  balance_newAcct_Y_PEER,

sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y') volume_deli_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y') volume_deli_newAcct_Y_PEER ,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y',balance,0))  balance_deli_newAcct_Y_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y',balance,0))  balance_deli_newAcct_Y_PEER
from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
 and mod(mod(t.year_month,100),3) = 0
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
--chart 45 ,--chart 47
cur.volume_BMO, 
cur.volume_deli_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) - if(pre.volume_BMO<>0,pre.volume_deli_BMO/pre.volume_BMO*100,null)  deliquency_SinceLast_BMO,
cur.volume_PEER ,
cur.volume_deli_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) deliquencyRate_PEER,
if(cur.volume_PEER<>0,cur.volume_deli_PEER/cur.volume_PEER*100,null) - if(pre.volume_PEER<>0,pre.volume_deli_PEER/pre.volume_PEER*100,null) deliquency_SinceLast_PEER,
--chart 44
cur.balance_BMO,
cur.balance_PEER,
cur.balance_deli_BMO,
cur.balance_deli_PEER,
if(pre.balance_deli_BMO<>0,(cur.balance_deli_BMO/pre.balance_deli_BMO -1)*100,null) deliquencyBalance_SinceLast_BMO,
if(pre.balance_deli_PEER<>0,(cur.balance_deli_PEER/pre.balance_deli_PEER -1)*100,null) deliquencyBalance_SinceLast_PEER,

--new account by month
cur.volume_newAcct_M_BMO, 
cur.volume_deli_newAcct_M_BMO,
if(cur.volume_newAcct_M_BMO<>0,cur.volume_deli_newAcct_M_BMO/cur.volume_newAcct_M_BMO*100,null) deliquencyRate_newAcct_M_BMO,
if(cur.volume_newAcct_M_BMO<>0,cur.volume_deli_newAcct_M_BMO/cur.volume_newAcct_M_BMO*100,null) - if(pre.volume_newAcct_M_BMO<>0,pre.volume_deli_newAcct_M_BMO/pre.volume_newAcct_M_BMO*100,null)  deliquency_SinceLast_newAcct_M_BMO,
cur.volume_newAcct_M_PEER ,
cur.volume_deli_newAcct_M_PEER,
if(cur.volume_newAcct_M_PEER<>0,cur.volume_deli_newAcct_M_PEER/cur.volume_newAcct_M_PEER*100,null) deliquencyRate_newAcct_M_PEER,
if(cur.volume_newAcct_M_PEER<>0,cur.volume_deli_newAcct_M_PEER/cur.volume_newAcct_M_PEER*100,null) - if(pre.volume_newAcct_M_PEER<>0,pre.volume_deli_newAcct_M_PEER/pre.volume_newAcct_M_PEER*100,null) deliquency_SinceLast_newAcct_M_PEER,
--chart 44
cur.balance_deli_newAcct_M_BMO,
cur.balance_deli_newAcct_M_PEER,
if(pre.balance_deli_newAcct_M_BMO<>0,(cur.balance_deli_newAcct_M_BMO/pre.balance_deli_newAcct_M_BMO -1)*100,null) deliquencyBalance_SinceLast_newAcct_M_BMO,
if(pre.balance_deli_newAcct_M_PEER<>0,(cur.balance_deli_newAcct_M_PEER/pre.balance_deli_newAcct_M_PEER -1)*100,null) deliquencyBalance_SinceLast_newAcct_M_PEER,
--chart 46
if(cur.balance_newAcct_M_BMO<>0,cur.balance_deli_newAcct_M_BMO/cur.balance_newAcct_M_BMO*100,null) balanceRate_deli_newAcct_M_BMO,
if(cur.balance_newAcct_M_PEER<>0,cur.balance_deli_newAcct_M_PEER/cur.balance_newAcct_M_PEER*100,null) balanceRate_deli_newAcct_M_PEER,
--new account by quarter
cur.volume_newAcct_Q_BMO, 
cur.volume_deli_newAcct_Q_BMO,
if(cur.volume_newAcct_Q_BMO<>0,cur.volume_deli_newAcct_Q_BMO/cur.volume_newAcct_Q_BMO*100,null) deliquencyRate_newAcct_Q_BMO,
if(cur.volume_newAcct_Q_BMO<>0,cur.volume_deli_newAcct_Q_BMO/cur.volume_newAcct_Q_BMO*100,null) - if(pre.volume_newAcct_Q_BMO<>0,pre.volume_deli_newAcct_Q_BMO/pre.volume_newAcct_Q_BMO*100,null)  deliquency_SinceLast_newAcct_Q_BMO,
cur.volume_newAcct_Q_PEER ,
cur.volume_deli_newAcct_Q_PEER,
if(cur.volume_newAcct_Q_PEER<>0,cur.volume_deli_newAcct_Q_PEER/cur.volume_newAcct_Q_PEER*100,null) deliquencyRate_newAcct_Q_PEER,
if(cur.volume_newAcct_Q_PEER<>0,cur.volume_deli_newAcct_Q_PEER/cur.volume_newAcct_Q_PEER*100,null) - if(pre.volume_newAcct_Q_PEER<>0,pre.volume_deli_newAcct_Q_PEER/pre.volume_newAcct_Q_PEER*100,null) deliquency_SinceLast_newAcct_Q_PEER,
--chart 44
cur.balance_deli_newAcct_Q_BMO,
cur.balance_deli_newAcct_Q_PEER,
if(pre.balance_deli_newAcct_Q_BMO<>0,(cur.balance_deli_newAcct_Q_BMO/pre.balance_deli_newAcct_Q_BMO -1)*100,null) deliquencyBalance_SinceLast_newAcct_Q_BMO,
if(pre.balance_deli_newAcct_Q_PEER<>0,(cur.balance_deli_newAcct_Q_PEER/pre.balance_deli_newAcct_Q_PEER -1)*100,null) deliquencyBalance_SinceLast_newAcct_Q_PEER,
--chart 46
if(cur.balance_newAcct_Q_BMO<>0,cur.balance_deli_newAcct_Q_BMO/cur.balance_newAcct_Q_BMO*100,null) balanceRate_deli_newAcct_Q_BMO,
if(cur.balance_newAcct_Q_PEER<>0,cur.balance_deli_newAcct_Q_PEER/cur.balance_newAcct_Q_PEER*100,null) balanceRate_deli_newAcct_Q_PEER,
--new account by year,
cur.volume_newAcct_Y_BMO, 
cur.volume_deli_newAcct_Y_BMO,
if(cur.volume_newAcct_Y_BMO<>0,cur.volume_deli_newAcct_Y_BMO/cur.volume_newAcct_Y_BMO*100,null) deliquencyRate_newAcct_Y_BMO,
if(cur.volume_newAcct_Y_BMO<>0,cur.volume_deli_newAcct_Y_BMO/cur.volume_newAcct_Y_BMO*100,null) - if(pre.volume_newAcct_Y_BMO<>0,pre.volume_deli_newAcct_Y_BMO/pre.volume_newAcct_Y_BMO*100,null)  deliquency_SinceLast_newAcct_Y_BMO,
cur.volume_newAcct_Y_PEER ,
cur.volume_deli_newAcct_Y_PEER,
if(cur.volume_newAcct_Y_PEER<>0,cur.volume_deli_newAcct_Y_PEER/cur.volume_newAcct_Y_PEER*100,null) deliquencyRate_newAcct_Y_PEER,
if(cur.volume_newAcct_Y_PEER<>0,cur.volume_deli_newAcct_Y_PEER/cur.volume_newAcct_Y_PEER*100,null) - if(pre.volume_newAcct_Y_PEER<>0,pre.volume_deli_newAcct_Y_PEER/pre.volume_newAcct_Y_PEER*100,null) deliquency_SinceLast_newAcct_Y_PEER,
--chart 44
cur.balance_deli_newAcct_Y_BMO,
cur.balance_deli_newAcct_Y_PEER,
if(pre.balance_deli_newAcct_Y_BMO<>0,(cur.balance_deli_newAcct_Y_BMO/pre.balance_deli_newAcct_Y_BMO -1)*100,null) deliquencyBalance_SinceLast_newAcct_Y_BMO,
if(pre.balance_deli_newAcct_Y_PEER<>0,(cur.balance_deli_newAcct_Y_PEER/pre.balance_deli_newAcct_Y_PEER -1)*100,null) deliquencyBalance_SinceLast_newAcct_Y_PEER,
--chart 46
if(cur.balance_newAcct_Y_BMO<>0,cur.balance_deli_newAcct_Y_BMO/cur.balance_newAcct_Y_BMO*100,null) balanceRate_deli_newAcct_Y_BMO,
if(cur.balance_newAcct_Y_PEER<>0,cur.balance_deli_newAcct_Y_PEER/cur.balance_newAcct_Y_PEER*100,null) balanceRate_deli_newAcct_Y_PEER


from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=   cur.year_month-100
 
order by cur.year_month,cur.product;


--chart 47 by region,
--fromMonth 201712-201802


with source as 
( select t.year_month,t.pi2_product product,s.province,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
count(1) volume, 
sum(payment_status='90+') volume_deli, 
sum(balance)  balance ,
sum(if(payment_status='90+',balance,0))  balance_deli,

sum(new_account_m='Y' and account_age=1 ) volume_newAcct_M, 
sum(payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M, 
sum(if(new_account_m='Y' and account_age=1,balance,0) ) balance_newAcct_M, 
sum(if(payment_status='90+' and new_account_m='Y' and account_age=1,balance,0)) balance_deli_newAcct_M, 

sum(new_account_q='Y' ) volume_newAcct_Q, 
sum(payment_status='90+' and new_account_q='Y') volume_deli_newAcct_Q, 
sum(if(new_account_q='Y' ,balance,0) ) balance_newAcct_Q, 
sum(if(payment_status='90+' and new_account_q='Y' ,balance,0)) balance_deli_newAcct_Q, 

sum(new_account_y='Y' ) volume_newAcct_Y, 
sum(payment_status='90+' and new_account_y='Y') volume_deli_newAcct_Y, 
sum(if(new_account_y='Y' ,balance,0) ) balance_newAcct_Y, 
sum(if(payment_status='90+' and new_account_y='Y' ,balance,0)) balance_deli_newAcct_Y  
from pi2_trade_o t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_o    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
( t.year_month between ${fromMonth} and ${toMonth} or t.year_month in (201601,201701))
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  ,s.province )  
select cur.year_month,cur.fi_cat,cur.product  ,cur.province,

cur.balance,
cur.balance_deli,
if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) deliquenctBalanceRate_BMO,

cur.balance_newAcct_M, 
cur.balance_deli_newAcct_M,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_BMO,

cur.balance_newAcct_Q, 
cur.balance_deli_newAcct_Q,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_BMO,
cur.balance_newAcct_Y, 
cur.balance_deli_newAcct_Y,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_BMO,

peer.balance balance_PEER,
peer.balance_deli,
if(peer.balance<>0,peer.balance_deli /peer.balance *100,null) deliquenctBalanceRate_PEER,

peer.balance_newAcct_M, 
peer.balance_deli_newAcct_M,
if(peer.balance_newAcct_M<>0,peer.balance_deli_newAcct_M/peer.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_PEER,

peer.balance_newAcct_Q, 
peer.balance_deli_newAcct_Q,
if(peer.balance_newAcct_Q<>0,peer.balance_deli_newAcct_Q/peer.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_PEER,
peer.balance_newAcct_Y, 
peer.balance_deli_newAcct_Y,
if(peer.balance_newAcct_Y<>0,peer.balance_deli_newAcct_Y/peer.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_PEER,

cur.volume,
cur.volume_deli,
if(cur.volume<>0,cur.volume_deli /cur.volume *100,null) deliquenctvolumeRate_BMO,
cur.volume_newAcct_M, 
cur.volume_deli_newAcct_M,
if(cur.volume_newAcct_M<>0,cur.volume_deli_newAcct_M/cur.volume_newAcct_M*100,null) deliquencyRate_newAcct_M_BMO,
cur.volume_newAcct_Q, 
cur.volume_deli_newAcct_Q,
if(cur.volume_newAcct_Q<>0,cur.volume_deli_newAcct_Q/cur.volume_newAcct_Q*100,null) deliquencyRate_newAcct_Q_BMO,
cur.volume_newAcct_Y, 
cur.volume_deli_newAcct_Y,
if(cur.volume_newAcct_Y<>0,cur.volume_deli_newAcct_Y/cur.volume_newAcct_Y*100,null) deliquencyRate_newAcct_Y_BMO,
peer.balance,
peer.balance_deli,
if(peer.balance<>0,peer.balance_deli /peer.balance *100,null) deliquenctbalanceRate_PEER,
peer.balance_newAcct_M, 
peer.balance_deli_newAcct_M,
if(peer.balance_newAcct_M<>0,peer.balance_deli_newAcct_M/peer.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_PEER,
peer.balance_newAcct_Q, 
peer.balance_deli_newAcct_Q,
if(peer.balance_newAcct_Q<>0,peer.balance_deli_newAcct_Q/peer.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_PEER,
peer.balance_newAcct_Y, 
peer.balance_deli_newAcct_Y,
if(peer.balance_newAcct_Y<>0,peer.balance_deli_newAcct_Y/peer.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_PEER
from source cur
join source peer
on cur.year_month=peer.year_month
and cur.product=peer.product
and cur.province=peer.province
where cur.fi_cat="BMO"
and peer.fi_cat='Peer'
order by year_month,fi_cat,product  ,province;

--chart 47 by risk,
--fromMonth 201712-201802
with source as 
( select t.year_month,t.pi2_product product,s.ers_band,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
count(1) volume, 
sum(payment_status='90+') volume_deli, 
sum(balance)  balance ,
sum(if(payment_status='90+',balance,0))  balance_deli,

sum(new_account_m='Y' and account_age=1 ) volume_newAcct_M, 
sum(payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M, 
sum(if(new_account_m='Y' and account_age=1,balance,0) ) balance_newAcct_M, 
sum(if(payment_status='90+' and new_account_m='Y' and account_age=1,balance,0)) balance_deli_newAcct_M, 

sum(new_account_q='Y' ) volume_newAcct_Q, 
sum(payment_status='90+' and new_account_q='Y') volume_deli_newAcct_Q, 
sum(if(new_account_q='Y' ,balance,0) ) balance_newAcct_Q, 
sum(if(payment_status='90+' and new_account_q='Y' ,balance,0)) balance_deli_newAcct_Q, 

sum(new_account_y='Y' ) volume_newAcct_Y, 
sum(payment_status='90+' and new_account_y='Y') volume_deli_newAcct_Y, 
sum(if(new_account_y='Y' ,balance,0) ) balance_newAcct_Y, 
sum(if(payment_status='90+' and new_account_y='Y' ,balance,0)) balance_deli_newAcct_Y  
from pi2_trade_o t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_o    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
( t.year_month between ${fromMonth} and ${toMonth} or t.year_month in (201601,201701))
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  ,s.ers_band )  
select cur.year_month,cur.fi_cat,cur.product  ,cur.ers_band,


if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) deliquenctBalanceRate_BMO,
if(peer.balance<>0,peer.balance_deli /peer.balance *100,null) deliquenctBalanceRate_PEER,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_BMO,
if(peer.balance_newAcct_M<>0,peer.balance_deli_newAcct_M/peer.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_PEER,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_BMO,
if(peer.balance_newAcct_Q<>0,peer.balance_deli_newAcct_Q/peer.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_PEER,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_BMO,
if(peer.balance_newAcct_Y<>0,peer.balance_deli_newAcct_Y/peer.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_PEER

from source cur
join source peer
on cur.year_month=peer.year_month
and cur.product=peer.product
and cur.ers_band=peer.ers_band
where cur.fi_cat="BMO"
and peer.fi_cat='Peer'
order by year_month,fi_cat,product  ,ers_band;


--by age
--by age , 201712-201801
with source as 
( select t.year_month,t.pi2_product product,s.consumer_age_cat,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
count(1) volume, 
sum(payment_status='90+') volume_deli, 
sum(balance)  balance ,
sum(if(payment_status='90+',balance,0))  balance_deli,

sum(new_account_m='Y' and account_age=1 ) volume_newAcct_M, 
sum(payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M, 
sum(if(new_account_m='Y' and account_age=1,balance,0) ) balance_newAcct_M, 
sum(if(payment_status='90+' and new_account_m='Y' and account_age=1,balance,0)) balance_deli_newAcct_M, 

sum(new_account_q='Y' ) volume_newAcct_Q, 
sum(payment_status='90+' and new_account_q='Y') volume_deli_newAcct_Q, 
sum(if(new_account_q='Y' ,balance,0) ) balance_newAcct_Q, 
sum(if(payment_status='90+' and new_account_q='Y' ,balance,0)) balance_deli_newAcct_Q, 

sum(new_account_y='Y' ) volume_newAcct_Y, 
sum(payment_status='90+' and new_account_y='Y') volume_deli_newAcct_Y, 
sum(if(new_account_y='Y' ,balance,0) ) balance_newAcct_Y, 
sum(if(payment_status='90+' and new_account_y='Y' ,balance,0)) balance_deli_newAcct_Y  
from pi2_trade_o t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_o    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
( t.year_month between ${fromMonth} and ${toMonth} or t.year_month in (201601,201701))
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  ,s.consumer_age_cat )  
select cur.year_month,cur.fi_cat,cur.product  ,cur.consumer_age_cat,


if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) deliquenctBalanceRate_BMO,
if(peer.balance<>0,peer.balance_deli /peer.balance *100,null) deliquenctBalanceRate_PEER,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_BMO,
if(peer.balance_newAcct_M<>0,peer.balance_deli_newAcct_M/peer.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_PEER,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_BMO,
if(peer.balance_newAcct_Q<>0,peer.balance_deli_newAcct_Q/peer.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_PEER,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_BMO,
if(peer.balance_newAcct_Y<>0,peer.balance_deli_newAcct_Y/peer.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_PEER

from source cur
join source peer
on cur.year_month=peer.year_month
and cur.product=peer.product
and cur.consumer_age_cat=peer.consumer_age_cat
where cur.fi_cat="BMO"
and peer.fi_cat='Peer'
order by year_month,fi_cat,product  ,consumer_age_cat;


--chart 44 

with source as 
( select t.pi2_product product, t.year_month,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
--all account 
sum(balance)  balance,
sum(if(payment_status='90+',balance,0))  balance_deli,
sum(if(payment_status='30' and trade_status='1',balance,0))  balance_30DPD,
sum(if(payment_status='60' and trade_status='1',balance,0))  balance_60DPD,
sum(if(payment_status='90+' and trade_status='1',balance,0))  balance_90DPD,
sum(if(payment_status='BadDebt',balance,0))  balance_BadDebt,
--new account
sum(if(new_account_m='Y' and account_age=1,balance,0))  balance_newAcct_M,
sum(if(payment_status='90+' and new_account_m='Y' and account_age=1,balance,0))  balance_deli_newAcct_M,
sum(if(payment_status='30' and trade_status='1' and new_account_m='Y' and account_age=1,balance,0))  balance_30DPD_newAcct_M,
sum(if(payment_status='60' and trade_status='1' and new_account_m='Y' and account_age=1,balance,0))  balance_60DPD_newAcct_M,
sum(if(payment_status='90+' and trade_status='1' and new_account_m='Y' and account_age=1,balance,0))  balance_90DPD_newAcct_M,
sum(if(payment_status='BadDebt' and new_account_m='Y' and account_age=1,balance,0))  balance_BadDebt_newAcct_M,
--new account by quarter
sum(if(new_account_q='Y' and account_age=1,balance,0))  balance_newAcct_Q,
sum(if(payment_status='90+' and new_account_q='Y' and account_age=1,balance,0))  balance_deli_newAcct_Q,
sum(if(payment_status='30' and trade_status='1' and new_account_q='Y' and account_age=1,balance,0))  balance_30DPD_newAcct_Q,
sum(if(payment_status='60' and trade_status='1' and new_account_q='Y' and account_age=1,balance,0))  balance_60DPD_newAcct_Q,
sum(if(payment_status='90+' and trade_status='1' and new_account_q='Y' and account_age=1,balance,0))  balance_90DPD_newAcct_Q,
sum(if(payment_status='BadDebt' and new_account_q='Y' and account_age=1,balance,0))  balance_BadDebt_newAcct_Q, 
--new account by year
sum(if(new_account_Y='Y' and account_age=1,balance,0))  balance_newAcct_Y,
sum(if(payment_status='90+' and new_account_Y='Y' and account_age=1,balance,0))  balance_deli_newAcct_Y,
sum(if(payment_status='30' and trade_status='1' and new_account_Y='Y' and account_age=1,balance,0))  balance_30DPD_newAcct_Y,
sum(if(payment_status='60' and trade_status='1' and new_account_Y='Y' and account_age=1,balance,0))  balance_60DPD_newAcct_Y,
sum(if(payment_status='90+' and trade_status='1' and new_account_Y='Y' and account_age=1,balance,0))  balance_90DPD_newAcct_Y,
sum(if(payment_status='BadDebt' and new_account_Y='Y' and account_age=1,balance,0))  balance_BadDebt_newAcct_Y
from pi2_development_db.pi2_trade_o t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_o    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 ( t.year_month between ${fromMonth} and ${toMonth} or t.year_month in (201601,201701,201706))
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag="P"
group by t.year_month,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,t.pi2_product )  
select  cur.year_month,cur.fi_cat,cur.product ,
--chart 45 by balance
cur.balance,
cur.balance_deli,
if(pre.balance_deli<>0,(cur.balance_deli/pre.balance_deli -1)*100,null) deliquencyBalance_SinceLast,
if(cur.balance<>0,cur.balance_deli/cur.balance*100,null) deliquencyRate,
if(cur.balance<>0,cur.balance_deli/cur.balance*100,null) - if(pre.balance<>0,pre.balance_deli/pre.balance*100,null)  deliquencyRate_SinceLast_bps,
--chart 46
cur.balance_30DPD,
cur.balance_60DPD,
cur.balance_90DPD,
cur.balance_BadDebt,

 --new account by month
--chart 45 by balance
cur.balance_newAcct_M, 
cur.balance_deli_newAcct_M,
if(pre.balance_deli_newAcct_M<>0,(cur.balance_deli_newAcct_M/pre.balance_deli_newAcct_M -1)*100,null) deliquencyBalance_SinceLast_newAcct_M,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) - if(pre.balance_newAcct_M<>0,pre.balance_deli_newAcct_M/pre.balance_newAcct_M*100,null)  deliquency_SinceLast_newAcct_M,
--chart 46
cur.balance_30DPD_newAcct_M,
cur.balance_60DPD_newAcct_M,
cur.balance_90DPD_newAcct_M,
cur.balance_BadDebt_newAcct_M,
 

--new account by quarter
cur.balance_30DPD_newAcct_Q,
cur.balance_60DPD_newAcct_Q,
cur.balance_90DPD_newAcct_Q,
cur.balance_BadDebt_newAcct_Q,
 

--new account by year
cur.balance_30DPD_newAcct_Y,
cur.balance_60DPD_newAcct_Y,
cur.balance_90DPD_newAcct_Y,
cur.balance_BadDebt_newAcct_Y
 
 
from source cur
left join source pre
on pre.product=cur.product
and pre.fi_cat=cur.fi_cat
and pre.year_month=  if(mod(cur.year_month,100)=1 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-1)
order by cur.year_month,cur.fi_cat,cur.product;

--chart 47 by age,
--fromMonth 201712-201802

with cur as 
( select t.year_month,t.pi2_product product,s.consumer_age_cat,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER ,


sum(c.fi_name = "BANK OF MONTREAL" and new_account_m='Y' and account_age=1 and t.joint_flag='P') volume_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_m='Y' and account_age=1 and t.joint_flag='P') volume_newAcct_M_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_m='Y' and account_age=1) volume_deli_newAcct_M_PEER ,


sum(c.fi_name = "BANK OF MONTREAL" and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_q='Y' and t.joint_flag='P') volume_newAcct_Q_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y') volume_deli_newAcct_Q_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_q='Y') volume_deli_newAcct_Q_PEER ,

sum(c.fi_name = "BANK OF MONTREAL" and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  and new_account_y='Y' and t.joint_flag='P') volume_newAcct_Y_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y') volume_deli_newAcct_Y_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+' and new_account_y='Y') volume_deli_newAcct_Y_PEER
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
select year_month,cur.product ,cur.consumer_age_cat,
--chart #accounts
volume_BMO, 
volume_deli_BMO,
if(cur.volume_BMO<>0,cur.volume_deli_BMO/cur.volume_BMO*100,null) deliquencyRate_BMO,

volume_newAcct_M_BMO, 
volume_deli_newAcct_M_BMO,
if(cur.volume_newAcct_M_BMO<>0,cur.volume_deli_newAcct_M_BMO/cur.volume_newAcct_M_BMO*100,null) deliquencyRate_newAcct_M_BMO,

volume_newAcct_Q_BMO, 
volume_deli_newAcct_Q_BMO,
if(cur.volume_newAcct_Q_BMO<>0,cur.volume_deli_newAcct_Q_BMO/cur.volume_newAcct_Q_BMO*100,null) deliquencyRate_newAcct_Q_BMO,
volume_newAcct_Y_BMO, 
volume_deli_newAcct_Y_BMO,
if(cur.volume_newAcct_Y_BMO<>0,cur.volume_deli_newAcct_Y_BMO/cur.volume_newAcct_Y_BMO*100,null) deliquencyRate_newAcct_Y_BMO

from cur
order by year_month,product  ,consumer_age_cat;

 --by quarter for chart 
 with source as 
( select t.pi2_product product, t.year_month,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
--all account 
sum(balance)  balance,
sum(if(payment_status='90+',balance,0))  balance_deli,
--new account
sum(if(new_account_m='Y' and account_age=1,balance,0))  balance_newAcct_M,
sum(if(payment_status='90+' and new_account_m='Y' and account_age=1,balance,0))  balance_deli_newAcct_M,
--new account by quarter
sum(if(new_account_q='Y' and account_age=1,balance,0))  balance_newAcct_Q,
sum(if(payment_status='90+' and new_account_q='Y' and account_age=1,balance,0))  balance_deli_newAcct_Q,
--new account by year
sum(if(new_account_Y='Y' and account_age=1,balance,0))  balance_newAcct_Y,
sum(if(payment_status='90+' and new_account_Y='Y' and account_age=1,balance,0))  balance_deli_newAcct_Y
from pi2_development_db.pi2_trade_o t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_o    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
   t.year_month between ${fromMonth} and ${toMonth}  
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag="P"
and mod(mod(t.year_month,100),3) = 0
group by t.year_month,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,t.pi2_product )  
select  cur.year_month,cur.fi_cat,cur.product ,
--chart 45 by balance
cur.balance,
cur.balance_deli,
if(pre.balance_deli<>0,(cur.balance_deli/pre.balance_deli -1)*100,null) deliquencyBalance_SinceLast,
if(cur.balance<>0,cur.balance_deli/cur.balance*100,null) deliquencyRate,
if(cur.balance<>0,cur.balance_deli/cur.balance*100,null) - if(pre.balance<>0,pre.balance_deli/pre.balance*100,null)  deliquencyRate_SinceLast_bps,
--new account by month
 
cur.balance_newAcct_M, 
cur.balance_deli_newAcct_M,
if(pre.balance_deli_newAcct_M<>0,(cur.balance_deli_newAcct_M/pre.balance_deli_newAcct_M -1)*100,null) deliquencyBalance_SinceLast_newAcct_M,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) - if(pre.balance_newAcct_M<>0,pre.balance_deli_newAcct_M/pre.balance_newAcct_M*100,null)  deliquency_SinceLast_newAcct_M,
 
cur.balance_newAcct_Q, 
cur.balance_deli_newAcct_Q,
if(pre.balance_deli_newAcct_Q<>0,(cur.balance_deli_newAcct_Q/pre.balance_deli_newAcct_Q -1)*100,null) deliquencyBalance_SinceLast_newAcct_Q,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) - if(pre.balance_newAcct_Q<>0,pre.balance_deli_newAcct_Q/pre.balance_newAcct_Q*100,null)  deliquency_SinceLast_newAcct_Q,  
cur.balance_newAcct_Y, 
cur.balance_deli_newAcct_Y,
if(pre.balance_deli_newAcct_Y<>0,(cur.balance_deli_newAcct_Y/pre.balance_deli_newAcct_Y -1)*100,null) deliquencyBalance_SinceLast_newAcct_Y,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) - if(pre.balance_newAcct_Y<>0,pre.balance_deli_newAcct_Y/pre.balance_newAcct_Y*100,null)  deliquency_SinceLast_newAcct_Y 
from source cur
left join source pre
on pre.product=cur.product
and pre.fi_cat=cur.fi_cat
and pre.year_month=  if(mod(cur.year_month,100)=3 ,(floor(cur.year_month/100) -1) *100 + 12, cur.year_month-3)
order by cur.year_month,cur.fi_cat,cur.product;

