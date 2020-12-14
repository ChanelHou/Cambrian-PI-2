--chart 25,26,27,28   -- new accounts by quarter by product
--month 201801
--quarter 201712,201709
--years 201801 , 201701
select  cur_count_BMO, 
cur_count_PEER ,
round(cast(if(pre_count_BMO>0,(cur_count_BMO/pre_count_BMO - 1)*100,0) as decimal(6,3)),2) growthRate_BMO,
round(cast(if(pre_count_PEER>0,((cur_count_PEER)/(pre_count_PEER) - 1)*100,0) as decimal(6,3)),2) growthRate_PEER,

cur_count_BMO/cur_count_Market*100 volumnRateOfMarket,
--chart 26
cur_balance_BMO,
cur_balance_PEER,
round(cast(if(pre_balance_BMO>0,(cur_balance_BMO/pre_balance_BMO - 1)*100,0) as decimal(6,3)),2) growthRate_balance_BMO,
round(cast(if(pre_balance_PEER>0,((cur_balance_PEER)/(pre_balance_PEER) - 1)*100,0) as decimal(6,3)),2) growthRate_balance_PEER,
cur_balance_BMO/cur_balance_Market*100 balanceRateOfMarket,
--chart 27
cur_credit_limit_BMO,
cur_credit_limit_PEER,
round(cast(if(pre_credit_limit_BMO>0,(cur_credit_limit_BMO/pre_credit_limit_BMO - 1)*100,0) as decimal(6,3)),2) growthRate_credit_limit_BMO,
round(cast(if(pre_credit_limit_PEER >0,((cur_credit_limit_PEER)/(pre_credit_limit_PEER) - 1)*100,0) as decimal(6,3)),2) growthRate_credit_limit_PEER,
cur_credit_limit_BMO/cur_credit_limit_Market*100 limitRateOfMarket,
----chart 28
cur_uti_rate_BMO  ,
cur_uti_rate_PEER  ,
(cur_uti_rate_BMO - pre_uti_rate_BMO) * 100 uti_bps_BMO,
(cur_uti_rate_PEER - pre_uti_rate_PEER) * 100 uti_bps_PEER) from (
select cur.product , cur.year_month,
--chart 25
case when year_month=${fromMonth} then 'from' 
when year_month=${toMonth} then 'to' 
else 'other'
end year_month_cat,
sum(if(year_month=${fromMonth},count_BMO, 0)) cur_count_BMO,
sum(if(year_month=${toMonth},count_BMO,0)) pre_count_BMO,

sum(if(year_month=${fromMonth},count_PEER, 0)) cur_count_PEER,
sum(if(year_month=${toMonth},count_PEER,0)) pre_count_PEER,

 
sum(if(year_month=${fromMonth},count_Market,0)) cur_count_Market,
sum(if(year_month=${fromMonth},balance_BMO, 0)) cur_balance_BMO,
sum(if(year_month=${toMonth},balance_BMO,0)) pre_balance_BMO,
sum(if(year_month=${fromMonth},balance_PEER, 0)) cur_balance_PEER,
sum(if(year_month=${toMonth},balance_PEER,0)) pre_balance_PEER,
sum(if(year_month=${fromMonth},balance_Market, 0)) cur_balance_Market,
 
sum(if(year_month=${fromMonth},credit_limit_BMO, 0)) cur_credit_limit_BMO,
sum(if(year_month=${toMonth},credit_limit_BMO,0)) pre_credit_limit_BMO,
sum(if(year_month=${fromMonth},credit_limit_PEER, 0)) cur_credit_limit_PEER,
sum(if(year_month=${toMonth},credit_limit_PEER,0)) pre_credit_limit_PEER,
 
sum(if(year_month=${fromMonth},credit_limit_Market, 0)) cur_credit_limit_Market
 
sum(if(year_month=${fromMonth},uti_rate_BMO, 0)) cur_uti_rate_BMO,
sum(if(year_month=${toMonth},uti_rate_BMO,0)) pre_uti_rate_BMO,
sum(if(year_month=${fromMonth},uti_rate_PEER, 0)) cur_uti_rate_PEER,
sum(if(year_month=${toMonth},uti_rate_PEER,0)) pre_uti_rate_PEER,
 
from 
( select t.pi2_product product, t.year_month,
--chart 25 count
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) count_PEER ,
sum(sum(t.joint_flag='P')) over(partition by t.pi2_product) count_Market,
--chart 26 balance
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_PEER,
sum(sum(if(t.joint_flag='P',balance,0))) over(partition by t.pi2_product) balance_Market,
--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_PEER,
sum(sum(if(t.joint_flag='P',credit_limit,0))) over(partition by t.pi2_product) credit_limit_Market,
--chart 28 utilization
if(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)   uti_rate_BMO,
if(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))<>0,sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))/sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))*100,null)  uti_rate_PEER
from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.year_month in ( ${fromMonth} , ${toMonth})
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and t.new_account_q='Y'
--and t.joint_flag='P'
group by t.pi2_product,t.year_month ) cur ) source

 
 