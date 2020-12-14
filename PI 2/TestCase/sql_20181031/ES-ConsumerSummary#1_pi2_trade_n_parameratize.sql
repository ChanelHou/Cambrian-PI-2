--201712-201801
select cur.product product,cur.year_month,cur.ers_band,
--chart #accounts
 volumn_BMO,volumn_PEER,grandTotalAcct_BMO,grandTotalAcct_PEER,grandTotalAcctByBandByProd_Market,grandTotalAcctByprodByYearMonth_Market,
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) AcctDistribution_BMO,
if(grandTotalbalance_BMO<>0,( balance_BMO/grandTotalbalance_BMO ) * 100,null) BalanceDistribution_BMO,
if(totalCredit_limit_BMO<>0,(credit_limit_BMO/totalCredit_limit_BMO  )*100,null) LimitDistribution_BMO,

--MarketShare
if(grandTotalAcctByBandByProd_Market<>0,volumn_BMO/grandTotalAcctByBandByProd_Market*100,null) shareAcctRateByBandByProd,
if(grandTotalbalanceByBandByProd_Market<>0,balance_BMO/grandTotalbalanceByBandByProd_Market*100,null) shareBalanceByBandByProd,
if(grandTotalLimitByBandByProd_Market<>0,credit_limit_BMO/grandTotalLimitByBandByProd_Market*100,null) shareLimitByBandByProd,

if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER)*100,null) AcctDistribution_PEER,
if(grandTotalbalance_PEER<>0,( balance_PEER/grandTotalbalance_PEER ) * 100,null) BalanceDistribution_PEER,
if(totalCredit_limit_PEER<>0,(credit_limit_PEER/totalCredit_limit_PEER  )*100,null) LimitDistribution_PEER

from ( select t.pi2_product product,t.year_month,s.ers_band,
--chart #accounts
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.pi2_product,t.year_month) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.pi2_product,t.year_month) grandTotalAcct_PEER,
sum(sum(t.joint_flag='P' ) ) over(partition by t.pi2_product,t.year_month) grandTotalAcctByprodByYearMonth_Market, 
--chart Balance$
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(t.joint_flag='P' ) grandTotalAcctByBandByProd_Market, 
sum(if(t.joint_flag='P',balance,0)) grandTotalbalanceByBandByProd_Market,
sum(if(t.joint_flag='P',credit_limit,0)) grandTotalLimitByBandByProd_Market,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.pi2_product,t.year_month)  grandTotalbalance_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.pi2_product,t.year_month)  grandTotalbalance_PEER,
--chart limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product,t.year_month)  totalCredit_limit_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product,t.year_month)   totalCredit_limit_PEER
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
group by t.pi2_product,t.year_month,s.ers_band)  cur
order by cur.product  ,year_month,cur.ers_band;


--consumer_age_cat

select cur.product product,cur.year_month,cur.consumer_age_cat,
--chart #accounts
 volumn_BMO,volumn_PEER,grandTotalAcct_BMO,grandTotalAcct_PEER,grandTotalAcctByBandByProd_Market,grandTotalAcctByprodByYearMonth_Market,
if(grandTotalAcct_BMO<>0,(volumn_BMO/grandTotalAcct_BMO)*100,null) AcctDistribution_BMO,
if(grandTotalbalance_BMO<>0,( balance_BMO/grandTotalbalance_BMO ) * 100,null) BalanceDistribution_BMO,
if(totalCredit_limit_BMO<>0,(credit_limit_BMO/totalCredit_limit_BMO  )*100,null) LimitDistribution_BMO,

--MarketShare
if(grandTotalAcctByBandByProd_Market<>0,volumn_BMO/grandTotalAcctByBandByProd_Market*100,null) shareAcctRateByBandByProd,
if(grandTotalbalanceByBandByProd_Market<>0,balance_BMO/grandTotalbalanceByBandByProd_Market*100,null) shareBalanceByBandByProd,
if(grandTotalLimitByBandByProd_Market<>0,credit_limit_BMO/grandTotalLimitByBandByProd_Market*100,null) shareLimitByBandByProd,
 

 if(grandTotalAcct_PEER<>0,(volumn_PEER/grandTotalAcct_PEER)*100,null) AcctDistribution_PEER,
if(grandTotalbalance_PEER<>0,( balance_PEER/grandTotalbalance_PEER ) * 100,null) BalanceDistribution_PEER,
if(totalCredit_limit_PEER<>0,(credit_limit_PEER/totalCredit_limit_PEER  )*100,null) LimitDistribution_PEER

from ( select t.pi2_product product,t.year_month,s.consumer_age_cat,
--chart #accounts
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.pi2_product,t.year_month) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.pi2_product,t.year_month) grandTotalAcct_PEER,
sum(sum(t.joint_flag='P' ) ) over(partition by t.pi2_product,t.year_month) grandTotalAcctByprodByYearMonth_Market, 
--chart Balance$
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(t.joint_flag='P' ) grandTotalAcctByBandByProd_Market, 
sum(if(t.joint_flag='P',balance,0)) grandTotalbalanceByBandByProd_Market,
sum(if(t.joint_flag='P',credit_limit,0)) grandTotalLimitByBandByProd_Market,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.pi2_product,t.year_month)  grandTotalbalance_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.pi2_product,t.year_month)  grandTotalbalance_PEER,

--chart limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product,t.year_month)  totalCredit_limit_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product,t.year_month)   totalCredit_limit_PEER
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
 
group by t.pi2_product,t.year_month,s.consumer_age_cat)  cur
order by cur.product  ,year_month,cur.consumer_age_cat;





--chart 22 , grandTotalMarketShare

select cur.product  ,cur.year_month,
 volumn_BMO, grandTotalAcctByProdByYearMonth_Market,
 if(grandTotalAcctByprodByYearMonth_Market<>0,volumn_BMO/grandTotalAcctByprodByYearMonth_Market*100,null) grandTotalAcctMarketShareByProdByYearMonth,
 balance_BMO,grandTotalbalanceByprodByYearMonth_Market,
 if(grandTotalbalanceByprodByYearMonth_Market<>0,balance_BMO/grandTotalbalanceByprodByYearMonth_Market*100,null) grandTotalBalanceMarketShareByProdByYearMonth
 
 limit_BMO,grandTotalLimitByprodByYearMonth_Market,
 if(grandTotalLimitByprodByYearMonth_Market<>0,limit_BMO/grandTotalLimitByprodByYearMonth_Market*100,null) grandTotalLimitMarketShareByProdByYearMonth

from ( select t.pi2_product product,t.year_month 
 
sum(c.fi_name = "BANK OF MONTREAL" ) volumn_BMO, 
sum(if(fi_name = "BANK OF MONTREAL" ,balance,0))  balance_BMO,
sum(if(fi_name = "BANK OF MONTREAL" ,credit_limit,0))  limit_BMO,
count(1)   grandTotalAcctByProdByYearMonth_Market, 
sum(balance)   grandTotalbalanceByprodByYearMonth_Market,
sum(credit_limit)   grandTotalLimitByprodByYearMonth_Market


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
group by t.pi2_product,t.year_month )  cur
order by cur.product  ,year_month ;

--query for bug
select cur.product product,cur.year_month,cur.ers_band,
--chart #accounts
 volumn_BMO,
grandTotalAcct_PEER,
grandTotalAcctByprodByYearMonth_Market,
--MarketShare
if(grandTotalAcctByprodByYearMonth_Market<>0,volumn_BMO/grandTotalAcctByprodByYearMonth_Market*100,null) shareAcctRateByProd
from ( select t.pi2_product product,t.year_month,s.ers_band,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_BMO, 
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.pi2_product,t.year_month) grandTotalAcct_PEER,
sum(sum(t.joint_flag='P' ) ) over(partition by t.pi2_product,t.year_month) grandTotalAcctByprodByYearMonth_Market
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
group by t.pi2_product,t.year_month,s.ers_band)  cur
order by cur.product  ,year_month,cur.ers_band;