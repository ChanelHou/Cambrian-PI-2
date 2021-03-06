-- for chart 44,45 , since Last need to execut two times for year and quarter
-- 
--by quarter , 201712,201709
--by year , 201801,201701
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
sum(if(new_account_q='Y' ,balance,0))  balance_newAcct_Q,
sum(if(payment_status='90+' and new_account_q='Y' ,balance,0))  balance_deli_newAcct_Q,
--new account by year
sum(if(new_account_Y='Y' ,balance,0))  balance_newAcct_Y,
sum(if(payment_status='90+' and new_account_Y='Y' ,balance,0))  balance_deli_newAcct_Y
from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where t.year_month in( ${curMonth},${preMonth})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag="P"
group by t.year_month,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,t.pi2_product )  
select  cur.year_month,cur.fi_cat,cur.product ,
--chart 45 by balance
cur.balance_deli,
if(pre.balance_deli<>0,(cur.balance_deli/pre.balance_deli -1)*100,null) deliquencyBalance_SinceLast,
if(cur.balance<>0,cur.balance_deli/cur.balance*100,null) deliquencyRate,
(if(cur.balance<>0,cur.balance_deli/cur.balance*100,null) - if(pre.balance<>0,pre.balance_deli/pre.balance*100,null))*100  deliquencyRate_SinceLast_bps,
  --new account by month
cur.balance_deli_newAcct_M,
if(pre.balance_deli_newAcct_M<>0,(cur.balance_deli_newAcct_M/pre.balance_deli_newAcct_M -1)*100,null) deliquencyBalance_SinceLast_newAcct_M,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M,
(if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) - if(pre.balance_newAcct_M<>0,pre.balance_deli_newAcct_M/pre.balance_newAcct_M*100,null))*100  deliquency_SinceLast_newAcct_M,
--new account by quarter
cur.balance_deli_newAcct_Q,
if(pre.balance_deli_newAcct_Q<>0,(cur.balance_deli_newAcct_Q/pre.balance_deli_newAcct_Q -1)*100,null) deliquencyBalance_SinceLast_newAcct_Q,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q,
(if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) - if(pre.balance_newAcct_Q<>0,pre.balance_deli_newAcct_Q/pre.balance_newAcct_Q*100,null))*100  deliquency_SinceLast_newAcct_Q,
--new account by year
cur.balance_deli_newAcct_Y,
if(pre.balance_deli_newAcct_Y<>0,(cur.balance_deli_newAcct_Y/pre.balance_deli_newAcct_Y -1)*100,null) deliquencyBalance_SinceLast_newAcct_Y,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y,
(if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) - if(pre.balance_newAcct_Y<>0,pre.balance_deli_newAcct_Y/pre.balance_newAcct_Y*100,null))*100  deliquency_SinceLast_newAcct_Y
from source cur
left join source pre
on pre.product=cur.product
and pre.fi_cat=cur.fi_cat
and pre.year_month=  ${preMonth}
and cur.year_month=${curMonth}
order by cur.year_month,cur.fi_cat,cur.product;


--chart 44-47,  by all account /new accounts by months , by quarter, by years  , chart 44 , the balance $ is fine , but the rate is not correct, the deliquenctRate is not correct for all the charts.
--by month 
--201701-201801    in 20181119
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
sum(if(new_account_q='Y' ,balance,0))  balance_newAcct_Q,
sum(if(payment_status='90+' and new_account_q='Y' ,balance,0))  balance_deli_newAcct_Q,
sum(if(payment_status='30' and trade_status='1' and new_account_q='Y' ,balance,0))  balance_30DPD_newAcct_Q,
sum(if(payment_status='60' and trade_status='1' and new_account_q='Y' ,balance,0))  balance_60DPD_newAcct_Q,
sum(if(payment_status='90+' and trade_status='1' and new_account_q='Y' ,balance,0))  balance_90DPD_newAcct_Q,
sum(if(payment_status='BadDebt' and new_account_q='Y' ,balance,0))  balance_BadDebt_newAcct_Q, 
--new account by year
sum(if(new_account_Y='Y' ,balance,0))  balance_newAcct_Y,
sum(if(payment_status='90+' and new_account_Y='Y' ,balance,0))  balance_deli_newAcct_Y,
sum(if(payment_status='30' and trade_status='1' and new_account_Y='Y' ,balance,0))  balance_30DPD_newAcct_Y,
sum(if(payment_status='60' and trade_status='1' and new_account_Y='Y' ,balance,0))  balance_60DPD_newAcct_Y,
sum(if(payment_status='90+' and trade_status='1' and new_account_Y='Y' ,balance,0))  balance_90DPD_newAcct_Y,
sum(if(payment_status='BadDebt' and new_account_Y='Y' ,balance,0))  balance_BadDebt_newAcct_Y
from pi2_development_db.pi2_trade_n t
join pi2_development_db.pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_development_db.pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 ( t.year_month between ${fromMonth} and ${toMonth} )
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag="P"
group by t.year_month,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,t.pi2_product )  
select  cur.year_month,cur.fi_cat,cur.product ,
--chart 45 by balance
cur.balance_deli,
if(pre.balance_deli<>0,(cur.balance_deli/pre.balance_deli -1)*100,null) deliquencyBalance_SinceLast,
if(cur.balance<>0,cur.balance_deli/cur.balance*100,null) deliquencyRate,
(if(cur.balance<>0,cur.balance_deli/cur.balance*100,null) - if(pre.balance<>0,pre.balance_deli/pre.balance*100,null))*100  deliquencyRate_SinceLast_bps,
--chart 46
cur.balance_30DPD,
cur.balance_60DPD,
cur.balance_90DPD,
cur.balance_BadDebt,
 --new account by month
--chart 45 by balance
cur.balance_deli_newAcct_M,
if(pre.balance_deli_newAcct_M<>0,(cur.balance_deli_newAcct_M/pre.balance_deli_newAcct_M -1)*100,null) deliquencyBalance_SinceLast_newAcct_M,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M,
(if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) - if(pre.balance_newAcct_M<>0,pre.balance_deli_newAcct_M/pre.balance_newAcct_M*100,null))*100  deliquency_SinceLast_newAcct_M,
--chart 46
cur.balance_30DPD_newAcct_M,
cur.balance_60DPD_newAcct_M,
cur.balance_90DPD_newAcct_M,
cur.balance_BadDebt_newAcct_M,
--new account by quarter
cur.balance_deli_newAcct_Q,
if(pre.balance_deli_newAcct_Q<>0,(cur.balance_deli_newAcct_Q/pre.balance_deli_newAcct_Q -1)*100,null) deliquencyBalance_SinceLast_newAcct_Q,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q,
(if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) - if(pre.balance_newAcct_Q<>0,pre.balance_deli_newAcct_Q/pre.balance_newAcct_Q*100,null))*100  deliquency_SinceLast_newAcct_Q,
cur.balance_30DPD_newAcct_Q,
cur.balance_60DPD_newAcct_Q,
cur.balance_90DPD_newAcct_Q,
cur.balance_BadDebt_newAcct_Q,
--new account by year
cur.balance_deli_newAcct_Y,
if(pre.balance_deli_newAcct_Y<>0,(cur.balance_deli_newAcct_Y/pre.balance_deli_newAcct_Y -1)*100,null) deliquencyBalance_SinceLast_newAcct_Y,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y,
(if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) - if(pre.balance_newAcct_Y<>0,pre.balance_deli_newAcct_Y/pre.balance_newAcct_Y*100,null))*100  deliquency_SinceLast_newAcct_Y,
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


--chart 47 by region,
--fromMonth 201712-201802


with source as 
( select t.year_month,t.pi2_product product,s.province,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
sum(balance)  balance ,
sum(if(payment_status='90+',balance,0))  balance_deli,
sum(if(new_account_m='Y' and account_age=1,balance,0) ) balance_newAcct_M, 
sum(if(payment_status='90+' and new_account_m='Y' and account_age=1,balance,0)) balance_deli_newAcct_M, 
sum(if(new_account_q='Y' ,balance,0) ) balance_newAcct_Q, 
sum(if(payment_status='90+' and new_account_q='Y' ,balance,0)) balance_deli_newAcct_Q, 
sum(if(new_account_y='Y' ,balance,0) ) balance_newAcct_Y, 
sum(if(payment_status='90+' and new_account_y='Y' ,balance,0)) balance_deli_newAcct_Y  
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
( t.year_month between ${fromMonth} and ${toMonth} )
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  ,s.province )  
select cur.year_month,cur.fi_cat,cur.product  ,cur.province,
if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) deliquenctBalanceRate_BMO,
if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) - if(peer.balance<>0,peer.balance_deli /peer.balance *100,null) variance_to_Peer,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_BMO,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) - if(peer.balance_newAcct_M<>0,peer.balance_deli_newAcct_M/peer.balance_newAcct_M*100,null) variance_to_Peer_newAcct_M,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_BMO,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) - if(peer.balance_newAcct_Q<>0,peer.balance_deli_newAcct_Q/peer.balance_newAcct_Q*100,null) variance_to_Peer_newAcct_Q,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_BMO,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) - if(peer.balance_newAcct_Y<>0,peer.balance_deli_newAcct_Y/peer.balance_newAcct_Y*100,null) variance_to_Peer_newAcct_Y
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
sum(balance)  balance ,
sum(if(payment_status='90+',balance,0))  balance_deli,
sum(if(new_account_m='Y' and account_age=1,balance,0) ) balance_newAcct_M, 
sum(if(payment_status='90+' and new_account_m='Y' and account_age=1,balance,0)) balance_deli_newAcct_M, 
sum(if(new_account_q='Y' ,balance,0) ) balance_newAcct_Q, 
sum(if(payment_status='90+' and new_account_q='Y' ,balance,0)) balance_deli_newAcct_Q, 
sum(if(new_account_y='Y' ,balance,0) ) balance_newAcct_Y, 
sum(if(payment_status='90+' and new_account_y='Y' ,balance,0)) balance_deli_newAcct_Y  
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
( t.year_month between ${fromMonth} and ${toMonth} )
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  ,s.ers_band )  
select cur.year_month,cur.fi_cat,cur.product  ,cur.ers_band,
if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) deliquenctBalanceRate_BMO,
if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) - if(peer.balance<>0,peer.balance_deli /peer.balance *100,null) variance_to_Peer,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_BMO,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) - if(peer.balance_newAcct_M<>0,peer.balance_deli_newAcct_M/peer.balance_newAcct_M*100,null) variance_to_Peer_newAcct_M,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_BMO,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) - if(peer.balance_newAcct_Q<>0,peer.balance_deli_newAcct_Q/peer.balance_newAcct_Q*100,null) variance_to_Peer_newAcct_Q,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_BMO,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) - if(peer.balance_newAcct_Y<>0,peer.balance_deli_newAcct_Y/peer.balance_newAcct_Y*100,null) variance_to_Peer_newAcct_Y
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
sum(balance)  balance ,
sum(if(payment_status='90+',balance,0))  balance_deli,
sum(if(new_account_m='Y' and account_age=1,balance,0) ) balance_newAcct_M, 
sum(if(payment_status='90+' and new_account_m='Y' and account_age=1,balance,0)) balance_deli_newAcct_M, 
sum(if(new_account_q='Y' ,balance,0) ) balance_newAcct_Q, 
sum(if(payment_status='90+' and new_account_q='Y' ,balance,0)) balance_deli_newAcct_Q, 
sum(if(new_account_y='Y' ,balance,0) ) balance_newAcct_Y, 
sum(if(payment_status='90+' and new_account_y='Y' ,balance,0)) balance_deli_newAcct_Y  
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
( t.year_month between ${fromMonth} and ${toMonth} )
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  ,s.consumer_age_cat )  
select cur.year_month,cur.fi_cat,cur.product  ,cur.consumer_age_cat,
if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) deliquenctBalanceRate_BMO,
if(cur.balance<>0,cur.balance_deli /cur.balance *100,null) - if(peer.balance<>0,peer.balance_deli /peer.balance *100,null) variance_to_Peer,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) deliquencyRate_newAcct_M_BMO,
if(cur.balance_newAcct_M<>0,cur.balance_deli_newAcct_M/cur.balance_newAcct_M*100,null) - if(peer.balance_newAcct_M<>0,peer.balance_deli_newAcct_M/peer.balance_newAcct_M*100,null) variance_to_Peer_newAcct_M,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) deliquencyRate_newAcct_Q_BMO,
if(cur.balance_newAcct_Q<>0,cur.balance_deli_newAcct_Q/cur.balance_newAcct_Q*100,null) - if(peer.balance_newAcct_Q<>0,peer.balance_deli_newAcct_Q/peer.balance_newAcct_Q*100,null) variance_to_Peer_newAcct_Q,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) deliquencyRate_newAcct_Y_BMO,
if(cur.balance_newAcct_Y<>0,cur.balance_deli_newAcct_Y/cur.balance_newAcct_Y*100,null) - if(peer.balance_newAcct_Y<>0,peer.balance_deli_newAcct_Y/peer.balance_newAcct_Y*100,null) variance_to_Peer_newAcct_Y
from source cur
join source peer
on cur.year_month=peer.year_month
and cur.product=peer.product
and cur.consumer_age_cat=peer.consumer_age_cat
where cur.fi_cat="BMO"
and peer.fi_cat='Peer'
order by year_month,fi_cat,product  ,consumer_age_cat;

