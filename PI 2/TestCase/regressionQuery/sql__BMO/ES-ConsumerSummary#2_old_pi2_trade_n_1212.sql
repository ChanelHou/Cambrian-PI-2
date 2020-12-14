--by product

--defect 19 
--The numbers in the chart do match the result that excludes missing age and ERS trades.


select t.year_month ,t.pi2_product product,
sum(ers_score)/count(1) avg_score,
sum(consumer_age) / count(1) avg_age,
count(1) volume, 
sum(balance) balance,
sum(credit_limit) credit_limit,
sum(balance)/sum(credit_limit)*100 uti,
sum(case when payment_status='90+' then 1 else 0 end)/count(1)*100 delinquencyRate

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
and c.fi_name = "BANK OF MONTREAL"
and s.ers_band <>'N/A' 
and s.consumer_age_cat <> 'Unknown'

group by t.pi2_product,t.year_month 
order by year_month ,pi2_product;

--this should change according to the product list
select t.year_month ,s.province,
sum(ers_score)/count(1) avg_score,
sum(consumer_age) / count(1) avg_age,
count(1) volume, 
sum(balance) balance,
sum(credit_limit) credit_limit,
sum(balance)/sum(credit_limit)*100 uti,
sum(case when payment_status='90+' then 1 else 0 end)/count(1)*100 delinquencyRate

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
and c.fi_name = "BANK OF MONTREAL"
and s.ers_band <>'N/A' 
and s.consumer_age_cat <> 'Unknown'
and t.pi2_product in ("Installment loan","Revolving loan","Heloc","Mortgage","NCC","Student Loan")

  group by s.province,t.year_month 
order by s.province,t.year_month ;

--BMO BRONze
select t.year_month ,s.province,
sum(ers_score)/count(1) avg_score,
sum(consumer_age) / count(1) avg_age,
count(1) volume, 
sum(balance) balance,
sum(credit_limit) credit_limit,
sum(balance)/sum(credit_limit)*100 uti,
sum(case when payment_status='90+' then 1 else 0 end)/count(1)*100 delinquencyRate

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
t.year_month between ${fromMonth} and ${toMonth}
and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
and t.joint_flag='P'
and c.fi_name = "BANK OF MONTREAL"
and s.ers_band <>'N/A' 
and s.consumer_age_cat <> 'Unknown'
and t.pi2_product in ("Installment loan","NCC")

  group by s.province,t.year_month 
order by s.province,t.year_month 


