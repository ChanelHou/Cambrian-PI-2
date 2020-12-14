--char 5   region
--  201803 , 201803
--gold 201809,201806
 --201809-201812
select t.year_month,t.pi2_product product, s.province,
sum(c.fi_name = "BANK OF MONTREAL") count_FIclient, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_FIclient,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL",balance,0))  balance_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between   ${Month1} and ${Month2} 
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.province
order by t.year_month,t.pi2_product,s.province



--char 6   Age Cohort
 
select t.year_month, t.pi2_product product, s.consumer_age_cat,
sum(c.fi_name = "BANK OF MONTREAL") count_FIclient, sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_FIclient,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL",balance,0))  balance_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between   ${Month1} and ${Month2} 
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.consumer_age_cat
order by t.year_month, t.pi2_product,s.consumer_age_cat
  
--char 7   Risk Cohort
 
select t.year_month,t.pi2_product product, s.ers_band,
sum(c.fi_name = "BANK OF MONTREAL") count_FIclient, sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL") count_PEER ,
sum(if(fi_name = "BANK OF MONTREAL",balance,0))  balance_FIclient,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL",balance,0))  balance_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month between   ${Month1} and ${Month2} 
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
group by t.year_month,t.pi2_product,s.ers_band
order by t.year_month,t.pi2_product,s.ers_band;

--char 8   Risk Cohort  -- digit
--by month 201803 , 201802
--by quarter 201803,201712 
--by year 201803, 201703
 

with source as 
( select t.year_month, t.pi2_product product, 
--chart 8
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_FIclient, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
sum(t.joint_flag='P') volumn_Market,
--chart 9
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_FIclient,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(if(t.joint_flag='P',balance,0))  balance_Market,
--chart 10
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_FIclient,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
sum(if(t.joint_flag='P',credit_limit,0))  credit_limit_Market,
--chart 11
if(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)   uti_rate_FIclient,
if(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)  uti_rate_PEER,
--chart 12
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') Delinq_Accts_FIclient ,
sum(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P') Delinq_Accts_PEER,
if(sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P')<>0,sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P')/sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P'),null)*100 deliquencyRate_FIclient,
if(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' )<>0,sum(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P')/sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ),null)*100 deliquencyRate_PEER,

sum(if(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P', balance,0)) Delinq_Balance_FIclient ,
sum(if(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) Delinq_Balance_PEER,
 
 
--chart 13
sum(c.fi_name = "BANK OF MONTREAL" ) tradelines_FIclient, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL"  ) tradelines_PEER ,
count(1)  tradelines_Market
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
group by  t.year_month, t.pi2_product )
select cur.year_month,pre.year_month,cur.product , 
--chart 8
cur.volumn_FIclient, 
cur.volumn_PEER ,
cur.volumn_Market,
cur.volumn_FIclient/cur.volumn_Market*100 volumnRateOfMarket,
cur.volumn_FIclient - pre.volumn_FIclient volumn_movement_FIclient,
cur.volumn_PEER - pre.volumn_PEER volumn_movement_PEER,

--chart 9
cur.balance_FIclient,
cur.balance_PEER,
cur.balance_Market,
cur.balance_FIclient/cur.balance_Market*100 balanceRateOfMarket,
if(pre.balance_FIclient<>0,(cur.balance_FIclient/pre.balance_FIclient-1)*100,null) balanceRate_FIclient,
if(pre.balance_PEER<>0,(cur.balance_PEER/pre.balance_PEER-1)*100,null) balanceRate_PEER,
--chart 10
cur.credit_limit_FIclient,
cur.credit_limit_PEER,
cur.credit_limit_Market,
cur.credit_limit_FIclient/cur.credit_limit_Market*100 limitRateOfMarket,
if(pre.credit_limit_FIclient<>0,(cur.credit_limit_FIclient/pre.credit_limit_FIclient-1)*100,null) credit_limitRate_FIclient,
if(pre.credit_limit_PEER<>0,(cur.credit_limit_PEER/pre.credit_limit_PEER-1)*100,null) credit_limitRate_PEER,

----chart 11
cur.uti_rate_FIclient cur_uti_rate_FIclient,
pre.uti_rate_FIclient pre_uti_rate_FIclient,
 (cur.uti_rate_FIclient - pre.uti_rate_FIclient) * 100 uti_FIclient_BPS,
cur.uti_rate_PEER cur_uti_rate_PEER,
pre.uti_rate_PEER pre_uti_rate_PEER,
(cur.uti_rate_PEER - pre.uti_rate_PEER) * 100 uti_PEER_BPS,

----chart 12
cur.Delinq_Accts_FIclient ,
cur.Delinq_Accts_PEER,
cur.deliquencyRate_FIclient,
cur.deliquencyRate_PEER,
(cur.deliquencyRate_FIclient - pre.deliquencyRate_FIclient) * 100 deliquencyRate_FIclient_BPS,
(cur.deliquencyRate_PEER - pre.deliquencyRate_PEER) * 100 deliquencyRate_PEER_BPS,

if(cur.balance_FIclient<>0,cur.Delinq_Balance_FIclient/cur.balance_FIclient*100,null) delinquencyBalanceRate_FIclient,
if(cur.balance_PEER<>0,cur.Delinq_Balance_PEER/cur.balance_PEER*100,null) delinquencyBalanceRate_PEER,
(if(cur.balance_FIclient<>0,cur.Delinq_Balance_FIclient/cur.balance_FIclient*100,null) - if(pre.balance_FIclient<>0,pre.Delinq_Balance_FIclient/pre.balance_FIclient*100,null)) * 100 DelinquencyRate_balance_BPS,
(if(cur.balance_PEER<>0,cur.Delinq_Balance_PEER/cur.balance_PEER*100,null) - if(pre.balance_PEER<>0,pre.Delinq_Balance_PEER/pre.balance_PEER*100,null)) * 100 DelinquencyRate_balance_BPS,

----chart 13
cur.tradelines_FIclient, 
cur.tradelines_PEER ,
cur.tradelines_Market,
cur.tradelines_FIclient/cur.tradelines_Market*100,
cur.tradelines_FIclient-pre.tradelines_FIclient tradelines_movement_FIclient,
cur.tradelines_PEER-pre.tradelines_PEER  tradelines_movement_PEER
from source cur
join source pre
on  cur.product=pre.product
and cur.year_month=${curMonth}
and pre.year_month=${preMonth}
 order by cur.product;
 
 
 
 --char 8   Risk Cohort  -- line chart
--by month  201612,201803,
 
  select t.pi2_product product, t.year_month,
--chart 8
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volumn_FIclient, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volumn_PEER ,
sum(sum(t.joint_flag='P')) over(partition by t.pi2_product) volumn_Market,
--chart 9
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_FIclient,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(sum(if(t.joint_flag='P',balance,0))) over(partition by t.pi2_product) balance_Market,
--chart 10
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_FIclient,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
sum(sum(if(t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product) credit_limit_Market,
--chart 11
if(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)   uti_rate_FIclient,
if(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)  uti_rate_PEER,
--chart 12
sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') Delinq_Accts_FIclient ,
sum(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P') Delinq_Accts_PEER,
if(sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P')<>0,sum(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P')/sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P'),null)*100 deliquencyRate_FIclient,
if(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' )<>0,sum(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P')/sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ),null)*100 deliquencyRate_PEER,


sum(if(payment_status='90+' and c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))*100 Delinq_balance_FIclient ,
sum(if(payment_status='90+' and c.peer_id =3 and c.fi_name <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))*100 Delinq_balance_PEER,
--chart 13
sum(c.fi_name = "BANK OF MONTREAL" ) tradelines_FIclient, 
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
group by t.pi2_product,t.year_month
order by  product ,  year_month 
 
 
 
 

  

