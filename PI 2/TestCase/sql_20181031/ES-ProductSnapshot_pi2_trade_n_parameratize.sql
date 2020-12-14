--char 5   region
--  201801 , 201712
 
select t.pi2_product product, s.province,
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL",balance,0))  balance_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month in ( ${Month1}, ${Month2})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.pi2_product,s.province
order by t.pi2_product,s.province



--char 6   Age Cohort
--by month 201801 , 201712
--by quarter 201712,201709
--by year 201801, 201701
select t.pi2_product product, s.consumer_age_cat,
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL",balance,0))  balance_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
t.year_month in ( ${Month1}, ${Month2})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.pi2_product,s.consumer_age_cat
order by t.pi2_product,s.consumer_age_cat
  
--char 7   Risk Cohort
--by month 201801 , 201712
--by quarter 201712,201709
--by year 201801, 201701
select t.pi2_product product, s.ers_band,
sum(c.fi_name = "BANK OF MONTREAL") count_BMO, sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL",balance,0))  balance_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
t.year_month in ( ${Month1}, ${Month2})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.pi2_product,s.ers_band
order by t.pi2_product,s.ers_band;

--char 8   Risk Cohort  -- digit
--by month 201801 , 201712
--by quarter 201712,201709
--by year 201801, 201701
-- chart 12 failure 

with source as 
( select t.pi2_product product, 
--chart 8
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
sum(sum(t.joint_flag='P')) over(partition by t.pi2_product) volumn_Market,
--chart 9
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(sum(if(t.joint_flag='P',balance,0))) over(partition by t.pi2_product) balance_Market,
--chart 10
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
sum(sum(if(t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product) credit_limit_Market,
--chart 11
if(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)   uti_rate_BMO,
if(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)  uti_rate_PEER,
--chart 12
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') Delinq_Accts_BMO ,
sum(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P') Delinq_Accts_PEER,
if(sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P')<>0,sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P')/sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P'),null) deliquencyRate_BMO,
if(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' )<>0,sum(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P')/sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ),null) deliquencyRate_PEER,

sum(if(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P', balance,0)) Delinq_Balance_BMO ,
sum(if(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) Delinq_Balance_PEER,
 
 
--chart 13
sum(c.fi_name = "BANK OF MONTREAL" ) tradelines_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) tradelines_PEER ,
sum(count(1)) over(partition by t.pi2_product) tradelines_Market
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month in (${curMonth} ,${preMonth})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product )
select cur.product , 
--chart 8
cur.volumn_BMO, 
cur.volumn_PEER ,
cur.volumn_Market,
cur.volumn_BMO/cur.volumn_Market*100 volumnRateOfMarket,
cur.volumn_BMO - pre.volumn_BMO volumn_movement_BMO,
cur.volumn_PEER - pre.volumn_PEER volumn_movement_PEER,

--chart 9
cur.balance_BMO,
cur.balance_PEER,
cur.balance_Market,
cur.balance_BMO/cur.balance_Market*100 balanceRateOfMarket,
if(pre.balance_BMO<>0,(cur.balance_BMO/pre.balance_BMO-1)*100,null) balanceRate_BMO,
if(pre.balance_PEER<>0,(cur.balance_PEER/pre.balance_PEER-1)*100,null) balanceRate_PEER,
--chart 10
cur.credit_limit_BMO,
cur.credit_limit_PEER,
cur.credit_limit_Market,
cur.credit_limit_BMO/cur.credit_limit_Market*100 limitRateOfMarket,
if(pre.credit_limit_BMO<>0,(cur.credit_limit_BMO/pre.credit_limit_BMO-1)*100,null) credit_limitRate_BMO,
if(pre.credit_limit_PEER<>0,(cur.credit_limit_PEER/pre.credit_limit_PEER-1)*100,null) credit_limitRate_PEER,

----chart 11
cur.uti_rate_BMO cur_uti_rate_BMO,
pre.uti_rate_BMO pre_uti_rate_BMO,
 (cur.uti_rate_BMO - pre.uti_rate_BMO) * 100 uti_BMO_BPS,
cur.uti_rate_PEER cur_uti_rate_PEER,
pre.uti_rate_PEER pre_uti_rate_PEER,
(cur.uti_rate_PEER - pre.uti_rate_PEER) * 100 uti_PEER_BPS,

----chart 12
cur.Delinq_Accts_BMO ,
cur.Delinq_Accts_PEER,
cur.deliquencyRate_BMO,
cur.deliquencyRate_PEER,
(cur.deliquencyRate_BMO - pre.deliquencyRate_BMO) * 100 deliquencyRate_BMO_BPS,
(cur.deliquencyRate_PEER - pre.deliquencyRate_PEER) * 100 deliquencyRate_PEER_BPS,

if(cur.balance_BMO<>0,cur.Delinq_Balance_BMO/cur.balance_BMO*100,null) delinquencyBalanceRate_BMO,
if(cur.balance_PEER<>0,cur.Delinq_Balance_PEER/cur.balance_PEER*100,null) delinquencyBalanceRate_PEER,
(if(cur.balance_BMO<>0,cur.Delinq_Balance_BMO/cur.balance_BMO*100,null) - if(pre..balance_BMO<>0,pre..Delinq_Balance_BMO/pre..balance_BMO*100,null)) * 100 DelinquencyRate_balance_BPS,
(if(cur.balance_PEER<>0,cur.Delinq_Balance_PEER/cur.balance_PEER*100,null) - if(pre..balance_PEER<>0,pre..Delinq_Balance_PEER/pre..balance_PEER*100,null)) * 100 DelinquencyRate_balance_BPS,

----chart 13
cur.tradelines_BMO, 
cur.tradelines_PEER ,
cur.tradelines_Market,
cur.tradelines_BMO/cur.tradelines_Market*100,
cur.tradelines_BMO-pre.tradelines_BMO tradelines_movement_BMO,
cur.tradelines_PEER-pre.tradelines_PEER  tradelines_movement_PEER
from source cur
join source pre
on  cur.product=pre.product
where cur.year_month=${curMonth}
and pre.year_month=${preMonth}
 order by cur.product;
 
 
 
 --char 8   Risk Cohort  -- line chart
--by month 201801 , 201712
--by quarter 201712,201709
--by year 201801, 201701
-- chart 12 failure, deliquencyRate 

with cur as 
( select t.pi2_product product, t.year_month,
--chart 8
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
sum(sum(t.joint_flag='P')) over(partition by t.pi2_product) volumn_Market,
--chart 9
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(sum(if(t.joint_flag='P',balance,0))) over(partition by t.pi2_product) balance_Market,
--chart 10
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
sum(sum(if(t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product) credit_limit_Market,
--chart 11
if(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)   uti_rate_BMO,
if(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)  uti_rate_PEER,
--chart 12
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') Delinq_Accts_BMO ,
sum(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P') Delinq_Accts_PEER,
if(sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P')<>0,sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P')/sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P'),null) deliquencyRate_BMO,
if(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' )<>0,sum(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P')/sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ),null) deliquencyRate_PEER,
--chart 13
sum(c.fi_name = "BANK OF MONTREAL" ) tradelines_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) tradelines_PEER ,
sum(count(1)) over(partition by t.pi2_product) tradelines_Market
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between  ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.joint_flag='P'
group by t.pi2_product,t.year_month )  
select cur.product , cur.year_month,
--chart 8
cur.volumn_BMO, 
cur.volumn_PEER ,
--chart 9
cur.balance_BMO,
cur.balance_PEER,

--chart 10
cur.credit_limit_BMO,
cur.credit_limit_PEER,

----chart 11
cur.uti_rate_BMO cur_uti_rate_BMO,
cur.uti_rate_PEER cur_uti_rate_PEER,
----chart 12
cur.deliquencyRate_BMO,
cur.deliquencyRate_PEER,
----chart 13
cur.tradelines_BMO, 
cur.tradelines_PEER 
from cur
order by cur.product , cur.year_month;
 
 
 
 

  

