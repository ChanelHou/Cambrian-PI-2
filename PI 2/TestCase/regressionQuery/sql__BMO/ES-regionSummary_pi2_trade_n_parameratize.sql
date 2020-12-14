
 --char 20   table  - fromMonth=toMonth=201801
with cur as 
( select t.year_month,t.pi2_product product,s.province,
--chart #accounts
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,t.pi2_product) grandTotalAcct_PEER,
--chart #tradelines
sum(c.fi_name = "BANK OF MONTREAL" ) tradelines_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) tradelines_PEER ,
sum(sum(c.fi_name = "BANK OF MONTREAL" )) over(partition by t.year_month,t.pi2_product) grandTotaltradelines_BMO, 
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  )) over(partition by t.year_month,t.pi2_product)  grandTotaltradelines_PEER ,
--chart Balance$
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.year_month,t.pi2_product)  grandTotalbalance_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.year_month,t.pi2_product)  grandTotalbalance_PEER,
--chart limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,t.pi2_product)  totalCredit_limit_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,t.pi2_product)   totalCredit_limit_PEER,
 --chart deliquencyRate
sum(if(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) Delinq_balance_BMO ,
sum(if(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) Delinq_balance_PEER
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
group by t.year_month, t.pi2_product,s.province )  
select cur.year_month,cur.product product,cur.province,
--chart #accounts
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
--chart #tradelines
 if(grandTotaltradelines_BMO<>0,(tradelines_BMO/grandTotaltradelines_BMO )*100,null) shareTradeline_BMO,
if(grandTotaltradelines_PEER<>0,(tradelines_PEER/grandTotaltradelines_PEER  ) * 100,null) shareTradeline_PEER,

--chart Balance$
if(grandTotalbalance_BMO<>0,( balance_BMO/grandTotalbalance_BMO ) * 100,null) shareBalance_BMO,
if(grandTotalbalance_PEER<>0,(balance_PEER/grandTotalbalance_PEER  ) * 100,null) shareBalance_PEER,
--chart limit
if(totalCredit_limit_BMO<>0,(credit_limit_BMO/totalCredit_limit_BMO  )*100,null) shareLimit_BMO,
if(totalCredit_limit_PEER<>0,(credit_limit_PEER/totalCredit_limit_PEER ) * 100,null) shareLimit_PEER,

--chart utilization
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO * 100,null) shareUtiRate_BMO,
if(totalCredit_limit_PEER<>0,balance_PEER/credit_limit_PEER  * 100,null) shareUtiRate_PEER,
--chart deliquencyRate
Delinq_balance_BMO/balance_BMO*100 deliRate_BMO,
Delinq_balance_PEER/balance_PEER*100 deliRate_PEER,

(if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null)/if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER )*100,null) - 1 ) * 100  performanceDiff_Acct,

 (if(grandTotaltradelines_BMO<>0,(tradelines_BMO/grandTotaltradelines_BMO )*100,null)/if(grandTotaltradelines_PEER<>0,(tradelines_PEER/grandTotaltradelines_PEER  ) * 100,null) - 1 )*100 performanceDiff_tradelines,
 (if(grandTotalbalance_BMO<>0,( balance_BMO/grandTotalbalance_BMO ) * 100,null)/if(grandTotalbalance_PEER<>0,(balance_PEER/grandTotalbalance_PEER  ) * 100,null) - 1 ) * 100  performanceDiff_balance,
 (if(totalCredit_limit_BMO<>0,(credit_limit_BMO/totalCredit_limit_BMO  )*100,null)/ if(totalCredit_limit_PEER<>0,(credit_limit_PEER/totalCredit_limit_PEER ) * 100,null)-1)*100 performanceDiff_limit,
(if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO * 100,null)/if(totalCredit_limit_PEER<>0,balance_PEER/credit_limit_PEER  * 100,null) - 1 ) * 100 performanceDiff_uti,
((Delinq_balance_BMO/balance_BMO)/(Delinq_balance_PEER/balance_PEER)-1)*100 performanceDiff_delinquencyRate

from cur
order by cur.year_month,cur.product  ,cur.province;
 
 
  