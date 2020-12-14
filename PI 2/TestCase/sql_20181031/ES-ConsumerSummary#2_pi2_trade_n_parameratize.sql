--by product

select cur.product  ,cur.year_month,
 volumn_BMO, 
 volumn_BMO_deliquency,
if( volumn_BMO<>0, volumn_BMO_deliquency/volumn_BMO*100,null) deliquencyRate_BMO,
volumn_BMO_ersBandnotNA,
volumn_BMO_Age_notNA,
 balance_BMO, 
 limit_BMO, 
 totalScore_BMO_notNA,
 if(limit_BMO<>0,balance_BMO/limit_BMO*100,null) utilization_BMO,

 if(volumn_BMO_ersBandnotNA<>0,totalScore_BMO_notNA/volumn_BMO_ersBandnotNA,null) ave_score,
 if(volumn_BMO_Age_notNA<>0,totalAge_BMO_notNA/volumn_BMO_Age_notNA,null) ave_age

from ( select t.pi2_product product,t.year_month ,
count(1) volumn_BMO, 
sum(balance)  balance_BMO,
sum(credit_limit) limit_BMO,
sum(payment_status='90+') volumn_BMO_deliquency,
sum(s.ers_band<>'N/A') volumn_BMO_ersBandnotNA,
sum(if(s.ers_band<>'N/A') balance_BMO_ersBandNotNA,
sum(if(s.ers_band<>'N/A',s.ers_score,0)) totalScore_BMO_notNA,
sum(if(s.consumer_age_cat<>'Unknown',s.consumer_age,0)) totalAge_BMO_notNA,
sum(s.consumer_age_cat<>'Unknown') volumn_BMO_Age_notNA
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
and c.fi_name = "BANK OF MONTREAL"
group by t.pi2_product,t.year_month )  cur
order by cur.product  ,year_month ;


--by region

select  cur.year_month, province,
 volumn_BMO, 
 volumn_BMO_deliquency,
if( volumn_BMO<>0, volumn_BMO_deliquency/volumn_BMO*100,null) deliquencyRate_BMO,
 balance_BMO, 
 limit_BMO, 
 if(limit_BMO<>0,balance_BMO/limit_BMO*100,null) utilization_BMO,

 if(volumn_BMO_ersBandnotNA<>0,totalScore_BMO_notNA/volumn_BMO_ersBandnotNA,null) ave_score,
 if(volumn_BMO_Age_notNA<>0,totalAge_BMO_notNA/volumn_BMO_Age_notNA,null) ave_age

from ( select  t.year_month , s.province,
count(1) volumn_BMO, 
sum(balance)  balance_BMO,
sum(credit_limit) limit_BMO,
sum(payment_status='90+') volumn_BMO_deliquency,
sum(s.ers_band<>'N/A') volumn_BMO_ersBandnotNA,
sum(if(s.ers_band<>'N/A',s.ers_score,0)) totalScore_BMO_notNA,
sum(if(s.consumer_age_cat<>'Unknown',s.consumer_age,0)) totalAge_BMO_notNA,
sum(s.consumer_age_cat<>'Unknown') volumn_BMO_Age_notNA
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
and c.fi_name = "BANK OF MONTREAL"
group by s.province,t.year_month )  cur
order by  year_month, province ;


--defect 19
-----actual 

select t.pi2_product product ,
count(1) volume, 
sum(balance) balance,
sum(credit_limit) credit_limit,
sum(balance)/sum(credit_limit)*100 uti,
sum(ers_score)/count(1) avg_score,
sum(payment_status='90+')/count(1)*100 delinquencyRate
from pi2_trade_o t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
join pi2_consumer_o as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
t.year_month =201801
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
and c.fi_name = "BANK OF MONTREAL"
and s.consumer_age_cat<>'Unknown'
group by t.pi2_product 
order by pi2_product ;

--expected 
select t.pi2_product product ,
count(1) volume, 
sum(balance) balance,
sum(credit_limit) credit_limit,
sum(balance)/sum(credit_limit)*100 uti,
sum(if(s.ers_band<>'N/A',s.ers_score,0))/sum(s.ers_band<>'N/A') avg_score,
sum(payment_status='90+')/count(1)*100 delinquencyRate
from pi2_trade_o t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
 
join pi2_consumer_o as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
t.year_month =201801
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
and c.fi_name = "BANK OF MONTREAL"
group by t.pi2_product  
order by pi2_product    ;