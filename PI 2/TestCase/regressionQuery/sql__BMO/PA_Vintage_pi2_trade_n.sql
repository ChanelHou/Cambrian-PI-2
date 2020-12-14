--------------------------20190111
--by month  51 and 52
with source as (
select t.pi2_product product, t.vintage_month,t.account_age ,
--chart 25 count
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) count_PEER ,
--sum(c.fi_name = "BANK OF MONTREAL" ) trade_count_BMO, 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') count_active_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') count_active_PEER ,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) balance_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0)) balance_deli_PEER,


--sum(if(fi_name = "BANK OF MONTREAL" ,balance,0))  trade_balance_BMO,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))  balance_active_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0)) balance_active_PEER,

--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))  credit_limit_active_BMO,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') count_deli_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0)) credit_limit_PEER,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0)) credit_limit_active_PEER,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') count_deli_PEER

from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c

on t.fi_id = c.fi_id
and c.year_month = greatest( 201609, t.year_month)

where 
 t.vintage_month between ${fromMonth} and ${toMonth}
--and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and trade_status= '1'
--and t.joint_flag='P'
and t.account_age <=36
group by t.pi2_product,t.vintage_month,t.account_age )
select product,vintage_month,account_age,
--totalBalance
count_BMO,balance_BMO,
--average balance per account
if(count_BMO<>0,balance_BMO/count_BMO,null) avg_balance_BMO,
--average balance per active account
count_active_BMO,balance_active_BMO,if(count_active_BMO<>0,balance_active_BMO/count_active_BMO,null) avg_active_balance_BMO,
--utilization rate 
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
--utilization active rate
if(credit_limit_active_BMO<>0,balance_active_BMO/credit_limit_active_BMO*100,null) uti_active_BMO,
--delinquencyRate
balance_deli_BMO,if(balance_BMO<>0,balance_deli_BMO/balance_BMO*100,null) delinquencyBalanceRate,
--peer 
count_PEER,balance_PEER,
--average balance per account
if(count_PEER<>0,balance_PEER/count_PEER,null) avg_balance_PEER,
--average balance per active account
count_active_PEER,balance_active_PEER,if(count_active_PEER<>0,balance_active_PEER/count_active_PEER,null) avg_active_balance_PEER,
--utilization rate 
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER,
--utilization active rate
if(credit_limit_active_PEER<>0,balance_active_PEER/credit_limit_active_PEER*100,null) uti_active_PEER,
--delinquencyRate
balance_deli_PEER,if(balance_PEER<>0,balance_deli_PEER/balance_PEER*100,null) delinquencyBalanceRate

from source
order by product,vintage_month,account_age;

 
 --by quarter chart 51 52
 with source as (
select t.pi2_product product, t.vintage_month,t.account_age ,
floor(t.vintage_month/100) vintage_year,
ceiling(mod(vintage_month,100)/3) vintage_quarter, mod(vintage_month,100)+account_age quarter_age,
--chart 25 count
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) count_PEER ,
--sum(c.fi_name = "BANK OF MONTREAL" ) trade_count_BMO, 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') count_active_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') count_active_PEER ,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) balance_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0)) balance_deli_PEER,


--sum(if(fi_name = "BANK OF MONTREAL" ,balance,0))  trade_balance_BMO,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))  balance_active_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0)) balance_active_PEER,

--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))  credit_limit_active_BMO,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') count_deli_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0)) credit_limit_PEER,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0)) credit_limit_active_PEER,
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') count_deli_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
 
where 
 t.vintage_month between ${fromMonth} and ${toMonth}
 and t.account_age <=40
--and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and trade_status= '1'
--and t.joint_flag='P'
group by t.pi2_product,t.vintage_month,t.account_age )
select product,concat(cast(vintage_year as string),'Q',cast(vintage_quarter as string)),quarter_age, (quarter_age - 3*vintage_quarter) quarter_account_age,
--totalBalance
sum(count_BMO),sum(balance_BMO) balance_BMO,
--average balance per account
if(sum(count_BMO)<>0,sum(balance_BMO)/sum(count_BMO),null) avg_balance_BMO,
--average balance per active account
sum(count_active_BMO),sum(balance_active_BMO),if(sum(count_active_BMO)<>0,sum(balance_active_BMO)/sum(count_active_BMO),null) avg_active_balance_BMO,
--utilization rate 
if(sum(credit_limit_BMO)<>0,sum(balance_BMO)/sum(credit_limit_BMO)*100,null) uti_BMO,
--utilization active rate
if(sum(credit_limit_active_BMO)<>0,sum(balance_active_BMO)/sum(credit_limit_active_BMO)*100,null) uti_active_BMO,
--delinquencyRate
sum(balance_deli_BMO),if(sum(balance_BMO)<>0,sum(balance_deli_BMO)/sum(balance_BMO)*100,null) delinquencyBalanceRate_BMO,
--peer 
sum(count_PEER),sum(balance_PEER) balance_Peer,
--average balance per account
if(sum(count_PEER)<>0,sum(balance_PEER)/sum(count_PEER),null) avg_balance_PEER,
--average balance per active account
sum(count_active_PEER),sum(balance_active_PEER),if(sum(count_active_PEER)<>0,sum(balance_active_PEER)/sum(count_active_PEER),null) avg_active_balance_PEER,
--utilization rate 
if(sum(credit_limit_PEER)<>0,sum(balance_PEER)/sum(credit_limit_PEER)*100,null) uti_PEER,
--utilization active rate
if(sum(credit_limit_active_PEER)<>0,sum(balance_active_PEER)/sum(credit_limit_active_PEER)*100,null) uti_active_PEER,
--delinquencyRate
sum(balance_deli_PEER),if(sum(balance_PEER)<>0,sum(balance_deli_PEER)/sum(balance_PEER)*100,null) delinquencyBalanceRate_Peer

from source
group by product,vintage_year,vintage_quarter,quarter_age
order by product,vintage_year,vintage_quarter,quarter_age;
--chart 54 by month
 
 with vintage as ( select 
 t.year_month,t.pi2_product product, t.vintage_month, 
 case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
count(1) trade_count,
sum(balance)  total_balance,
sum(credit_limit)  total_credit,
 
sum(if(payment_status='90+',balance,0))  delinquencyBalance ,
sum(case when ts.ers_score is null then 0 else ts.ers_score end) orig_total_score,
sum(case when ts.ers_score is null then 0 else 1 end) orig_score_count,
sum(case when ts.consumer_age > 0 then ts.consumer_age else 0 end) orig_cons_age_total,
sum(case when ts.consumer_age > 0 then 1 else 0 end) orig_cons_age_count  
 
from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
 
left join(
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1

where t.vintage_month between ${from_vintage_month}  and ${to_vintage_month}  
and t.year_month =  ${selected_month}
and t.joint_flag='P'
 group by  t.year_month,t.vintage_month,t.pi2_product,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end) 
			  
select 
year_month, vintage_month, fi_cat,  product, 
 sum(orig_cons_age_total)/ sum(orig_cons_age_count) avg_orig_age, 
sum(total_balance) total_balance,
sum(total_balance)/sum(trade_count) avg_balance,
 
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(orig_total_score) /sum(orig_score_count) avg_orig_score ,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate 
  
from vintage
group by  year_month,vintage_month,fi_cat,product 
having fi_cat <>'Other';



 


 with vintage as ( select 
t.pi2_product product, t.vintage_month, 
 case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
sum(if(account_age=1,1,0))  trade_count_in_chart54 ,
 sum(if(account_age=1,credit_limit,0))  total_credit_in_chart54 
from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join(
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1

where t.vintage_month between ${from_vintage_month}  and ${to_vintage_month}  

and t.joint_flag='P'
and t.account_age=1
 group by  t.vintage_month,t.pi2_product,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end) 
			  
select 
 vintage_month, fi_cat,  product, 
 sum(trade_count_in_chart54) total_count_inchart54,
 sum(total_credit_in_chart54)/ sum(trade_count_in_chart54) avg_limit  
from vintage
group by  vintage_month,fi_cat,product
having fi_cat <>'Other';



--all the value in chart54
 with vintage as ( select 
t.pi2_product product, t.vintage_month, 
 case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
sum(if(t.year_month=${selected_month},1,0)) trade_count,
sum(if(t.year_month=${selected_month},balance,0))  total_balance,
sum(if(t.year_month=${selected_month},credit_limit,0))  total_credit,
 
sum(if(payment_status='90+' and t.year_month=${selected_month},balance,0))  delinquencyBalance ,
sum(case when ts.ers_score is not null and t.year_month=${selected_month} then   ts.ers_score else 0 end) orig_total_score,
sum(case when ts.ers_score is not null and t.year_month=${selected_month} then   1 else 0 end) orig_score_count,
sum(case when ts.consumer_age > 0 and t.year_month=${selected_month} then ts.consumer_age else 0 end) orig_cons_age_total,
sum(case when ts.consumer_age > 0 and t.year_month=${selected_month} then 1 else 0 end) orig_cons_age_count ,
sum(if(account_age=1,1,0))  trade_count_in_chart54 ,
 sum(if(account_age=1,credit_limit,0))  total_credit_in_chart54 
from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1

where t.vintage_month between ${from_vintage_month}  and ${to_vintage_month}  

and t.joint_flag='P'
 group by  t.vintage_month,t.pi2_product,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end) 
			  
select 
  vintage_month, fi_cat,  product, 
 sum(orig_cons_age_total)/ sum(orig_cons_age_count) avg_orig_age, 
sum(total_balance) total_balance,
sum(total_balance)/sum(trade_count) avg_balance,
 
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(orig_total_score) /sum(orig_score_count) avg_orig_score ,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
 sum(trade_count_in_chart54) total_count_inchart54,
 sum(total_credit_in_chart54)/ sum(trade_count_in_chart54) avg_limit  
from vintage
group by  vintage_month,fi_cat,product
 having fi_cat <>'Other';
 
 --chart 54
 by quarter
 select t.year_month,
 case when mod(t.year_month,100) = 1 then floor(t.year_month/100) - 1  else floor(t.year_month/100) end year ,
case when mod(t.year_month,100) = 1 then 4 else (mod(t.year_month,100)-1)/ 3 end quarter ,
t.pi2_product product,   
 case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
count(1) trade_count,
sum( credit_limit)/count(1)  avg_limit
from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1

where  t.joint_flag='P'
and  mod(t.year_month,100) in ( 1,4,7,10)  
and t.account_age in ( 1,2,3)
 group by t.year_month,
 case when mod(t.year_month,100) = 1 then floor(t.year_month/100) - 1  else floor(t.year_month/100) end   ,
case when mod(t.year_month,100) = 1 then 4 else (mod(t.year_month,100)-1)/ 3 end , 
 
 t.pi2_product,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'  end ;
			  
--chart 54 , by quarter 2
 with vintage as ( select t.year_month,
t.pi2_product product,  floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,
 case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
count(1) trade_count,
sum(balance)  total_balance,
sum( credit_limit )   total_credit,
 
sum(if(payment_status='90+'  ,balance,0))  delinquencyBalance ,
sum(case when ts.ers_score is not null   then   ts.ers_score else 0 end) orig_total_score,
sum(case when ts.ers_score is not null  then   1 else 0 end) orig_score_count,
sum(case when ts.consumer_age > 0  then ts.consumer_age else 0 end) orig_cons_age_total,
sum(case when ts.consumer_age > 0   then 1 else 0 end) orig_cons_age_count  
 
from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1

where t.vintage_month between ${from_vintage_month}  and ${to_vintage_month}  
and t.year_month=${selected_month}
and t.joint_flag='P'
 group by t.year_month,t.pi2_product,
 case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'  end,
              floor(vintage_month/100)  , 
              ceiling(mod(vintage_month,100)/3))  
			  
select 
 year_month, vintage_year,vintage_quarter, fi_cat,  product, 
 sum(orig_cons_age_total)/ sum(orig_cons_age_count) avg_orig_age, 
sum(total_balance) total_balance,
sum(total_balance)/sum(trade_count) avg_balance,
 
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(orig_total_score) /sum(orig_score_count) avg_orig_score ,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate 
from vintage
group by  year_month,vintage_year,vintage_quarter,fi_cat,product;

--by age by month
with source as (
select year_month, vintage_month, fi_cat,  product_name,   orig_age_cat,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month,vintage_month,product_name) grandTotalbalance
from  (
  
  select  t.year_month,vintage_month,t.pi2_product product_name,
  case when   ts.consumer_age_cat is null then 'Unknown'
  else ts.consumer_age_cat end orig_age_cat,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          count(1) trade_count, sum(t.balance) total_balance, 
		  sum(t.credit_limit) total_credit, 
		sum(if(payment_status='90+',  t.balance,0)) delinquencyBalance ,
		sum(if(active_flag='Y',1,0)) active_trade_count,
		sum(if(active_flag='Y', t.balance,0)) active_total_balance,
 sum(if(active_flag='Y',t.credit_limit,0)) active_total_credit
  
  from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1
where  t.year_month = ${curMonth}
  and t.vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  and t.joint_flag='P'
group by t.year_month,vintage_month,   t.pi2_product,
case when   ts.consumer_age_cat is null then 'Unknown'
  else ts.consumer_age_cat end  ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end   

  ) tb 
  group by year_month,vintage_month,   fi_cat, product_name ,orig_age_cat)

select  if(bmo.year_month is not null ,bmo.year_month,peer.year_month) year_month,
if(bmo.vintage_month is not null , bmo.vintage_month,peer.vintage_month) vintage_month,
if(bmo.fi_cat is not null,bmo.fi_cat,peer.fi_cat) fi_cat,
if(bmo.product_name is not null,bmo.product_name,peer.product_name) product_name,
 if(bmo.orig_age_cat is not null, bmo.orig_age_cat,peer.orig_age_cat) orig_age_cat,
nvl(bmo.avg_delinquencyRate,0), 
( nvl(bmo.avg_delinquencyRate,0) - nvl(PEER.avg_delinquencyRate,0) ) * 100 variance_to_peer_avg_delinquencyRate_bps,
nvl(bmo.total_balance,0),bmo.grandTotalBalance,peer.total_balance,peer.grandTotalBalance,
 if(bmo.total_balance is not null , (nvl(bmo.total_balance,0)/bmo.grandTotalBalance - nvl(peer.total_balance,0)/peer.grandTotalBalance)*100 , 0 - nvl(peer.total_balance,0)/peer.grandTotalBalance*100) variance_to_peer_marketShare_balance,
bmo.avg_utilization,

(nvl(bmo.avg_utilization,0) - nvl(PEER.avg_utilization,0))*100 variance_to_peer_avg_utilization_bps,
bmo.avg_balance,
nvl(bmo.avg_balance,0) - nvl(PEER.avg_balance,0) variance_to_peer_avg_balance_dollar,
bmo.avg_active_balance,
nvl(bmo.avg_active_balance,0) - nvl(PEER.avg_active_balance,0) variance_to_peer_avg_active_balance,
bmo.active_utilization,
(nvl(bmo.active_utilization,0) - nvl(PEER.active_utilization,0))*100 variance_to_peer_active_utilization_bps,

peer.year_month,peer.vintage_month, peer.fi_cat,  peer.product_name, peer.orig_age_cat 
from (select * from source where source.fi_cat='BMO') bmo
full outer join ( select * from source where source.fi_cat='Peer')  peer
on bmo.year_month = peer.year_month 
and bmo.vintage_month=peer.vintage_month
and bmo.product_name=peer.product_name
and bmo.orig_age_cat=peer.orig_age_cat
 
order by bmo.year_month,bmo.vintage_month,   bmo.fi_cat, bmo.product_name ,bmo.orig_age_cat;

--by age by quarter
with source as (
select  year_month,vintage_year, vintage_quarter, fi_cat, product_name,orig_age_cat,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month, vintage_year,vintage_quarter,product_name) grandTotalbalance
from  (
  
  select  t.year_month,  t.pi2_product product_name,floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,
  case when   ts.consumer_age_cat is null then 'Unknown'
  else ts.consumer_age_cat end orig_age_cat,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          count(1) trade_count, sum(t.balance) total_balance, 
		  sum(t.credit_limit) total_credit, 
		sum(if(payment_status='90+',  t.balance,0)) delinquencyBalance ,
		sum(if(active_flag='Y',1,0)) active_trade_count,
		sum(if(active_flag='Y', t.balance,0)) active_total_balance,
 sum(if(active_flag='Y',t.credit_limit,0)) active_total_credit
  
  from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, consumer_age_cat,  year_month, province,
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1
where  t.year_month = ${curMonth}
  and t.vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  and t.joint_flag='P'
group by t.year_month,floor(vintage_month/100)  , ceiling(mod(vintage_month,100)/3)  ,  t.pi2_product,
case when   ts.consumer_age_cat is null then 'Unknown'
  else ts.consumer_age_cat end  ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end   

  ) tb 
  group by fi_cat, product_name,year_month,vintage_year, vintage_quarter,orig_age_cat)

select   bmo.year_month, bmo.vintage_year, bmo.vintage_quarter ,bmo.fi_cat,  bmo.product_name, bmo.orig_age_cat,
bmo.avg_delinquencyRate, 
( bmo.avg_delinquencyRate - PEER.avg_delinquencyRate ) * 100 variance_to_peer_avg_delinquencyRate_bps,
bmo.total_balance,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization,

(bmo.avg_utilization - PEER.avg_utilization)*100 variance_to_peer_avg_utilization_bps,
bmo.avg_balance,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance_dollar,
bmo.avg_active_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization,
(bmo.active_utilization - PEER.active_utilization)*100 variance_to_peer_active_utilization_bps
from source bmo
join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_year=peer.vintage_year
and bmo.vintage_quarter=peer.vintage_quarter
and bmo.product_name=peer.product_name
and bmo.orig_age_cat=peer.orig_age_cat
and bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_year,bmo.vintage_quarter,   bmo.fi_cat, bmo.product_name ,bmo.orig_age_cat;


--by province
with source as (
select year_month, vintage_month, fi_cat,  product_name,   orig_province,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month,vintage_month,product_name) grandTotalbalance
from  (
  
  select  t.year_month,vintage_month,t.pi2_product product_name,
  case when   ts.province is null then 'N/A'
  else ts.province end orig_province,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          count(1) trade_count, sum(t.balance) total_balance, 
		  sum(t.credit_limit) total_credit, 
		sum(if(payment_status='90+',  t.balance,0)) delinquencyBalance ,
		sum(if(active_flag='Y',1,0)) active_trade_count,
		sum(if(active_flag='Y', t.balance,0)) active_total_balance,
 sum(if(active_flag='Y',t.credit_limit,0)) active_total_credit
  
  from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month,  
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month,  
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1
where  t.year_month = ${curMonth}
  and t.vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  and t.joint_flag='P'
group by t.year_month,vintage_month,   t.pi2_product,
case when   ts.province is null then 'N/A'
  else ts.province end  ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end   

  ) tb 
  group by year_month,vintage_month,   fi_cat, product_name ,orig_province)

select  bmo.year_month, bmo.vintage_month, bmo.fi_cat,  bmo.product_name, bmo.orig_province,
bmo.avg_delinquencyRate, 
( bmo.avg_delinquencyRate - PEER.avg_delinquencyRate ) * 100 variance_to_peer_avg_delinquencyRate_bps,
bmo.total_balance,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization,

(bmo.avg_utilization - PEER.avg_utilization)*100 variance_to_peer_avg_utilization_bps,
bmo.avg_balance,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance_dollar,
bmo.avg_active_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization,
(bmo.active_utilization - PEER.active_utilization)*100 variance_to_peer_active_utilization_bps
from source bmo
join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_month=peer.vintage_month
and bmo.product_name=peer.product_name
and bmo.orig_province=peer.orig_province
where bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_month,   bmo.fi_cat, bmo.product_name ,bmo.orig_province;

--by age by quarter
with source as (
select  year_month,vintage_year, vintage_quarter, fi_cat, product_name,orig_province,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month, vintage_year,vintage_quarter,product_name) grandTotalbalance
from  (
  
  select  t.year_month,  t.pi2_product product_name,floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,
  case when   ts.province is null then 'N/A'
  else ts.province end orig_province,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          count(1) trade_count, sum(t.balance) total_balance, 
		  sum(t.credit_limit) total_credit, 
		sum(if(payment_status='90+',  t.balance,0)) delinquencyBalance ,
		sum(if(active_flag='Y',1,0)) active_trade_count,
		sum(if(active_flag='Y', t.balance,0)) active_total_balance,
 sum(if(active_flag='Y',t.credit_limit,0)) active_total_credit
  
  from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month ,
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month,  
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1
where  t.year_month = ${curMonth}
  and t.vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  and t.joint_flag='P'
group by t.year_month,floor(vintage_month/100)  , ceiling(mod(vintage_month,100)/3)  ,  t.pi2_product,
case when   ts.province is null then 'N/A'
  else ts.province end  ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end   

  ) tb 
  group by fi_cat, product_name,year_month,vintage_year, vintage_quarter,orig_province)

select   bmo.year_month, bmo.vintage_year, bmo.vintage_quarter ,bmo.fi_cat,  bmo.product_name, bmo.orig_province,
bmo.avg_delinquencyRate, 
( bmo.avg_delinquencyRate - PEER.avg_delinquencyRate ) * 100 variance_to_peer_avg_delinquencyRate_bps,
bmo.total_balance,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization,

(bmo.avg_utilization - PEER.avg_utilization)*100 variance_to_peer_avg_utilization_bps,
bmo.avg_balance,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance_dollar,
bmo.avg_active_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization,
(bmo.active_utilization - PEER.active_utilization)*100 variance_to_peer_active_utilization_bps
from source bmo
join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_year=peer.vintage_year
and bmo.vintage_quarter=peer.vintage_quarter
and bmo.product_name=peer.product_name
and bmo.orig_province=peer.orig_province
and bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_year,bmo.vintage_quarter,   bmo.fi_cat, bmo.product_name ,bmo.orig_province;

--by Risk
with source as (
select year_month, vintage_month, fi_cat,  product_name,   orig_ers_band,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month,vintage_month,product_name) grandTotalbalance
from  (
  
  select  t.year_month,vintage_month,t.pi2_product product_name,
  case when   ts.ers_band is null then 'N/A'
  else ts.ers_band   end orig_ers_band,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          count(1) trade_count, sum(t.balance) total_balance, 
		  sum(t.credit_limit) total_credit, 
		sum(if(payment_status='90+',  t.balance,0)) delinquencyBalance ,
		sum(if(active_flag='Y',1,0)) active_trade_count,
		sum(if(active_flag='Y', t.balance,0)) active_total_balance,
 sum(if(active_flag='Y',t.credit_limit,0)) active_total_credit
  
  from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month,  
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month,  
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1
where  t.year_month = ${curMonth}
  and t.vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  and t.joint_flag='P'
group by t.year_month,vintage_month,   t.pi2_product,
case when   ts.ers_band is null then 'N/A'
  else ts.ers_band   end  ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end   

  ) tb 
  group by year_month,vintage_month,   fi_cat, product_name ,orig_ers_band)

select  bmo.year_month, bmo.vintage_month, bmo.fi_cat,  bmo.product_name, bmo.orig_ers_band,
bmo.avg_delinquencyRate, 
( bmo.avg_delinquencyRate - PEER.avg_delinquencyRate ) * 100 variance_to_peer_avg_delinquencyRate_bps,
bmo.total_balance,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization,

(bmo.avg_utilization - PEER.avg_utilization)*100 variance_to_peer_avg_utilization_bps,
bmo.avg_balance,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance_dollar,
bmo.avg_active_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization,
(bmo.active_utilization - PEER.active_utilization)*100 variance_to_peer_active_utilization_bps
from source bmo
join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_month=peer.vintage_month
and bmo.product_name=peer.product_name
and bmo.orig_ers_band=peer.orig_ers_band
where bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_month,   bmo.fi_cat, bmo.product_name ,bmo.orig_ers_band;

--by age by quarter
with source as (
select  year_month,vintage_year, vintage_quarter, fi_cat, product_name,orig_ers_band,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month, vintage_year,vintage_quarter,product_name) grandTotalbalance
from  (
  
  select  t.year_month,  t.pi2_product product_name,floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,
  case when   ts.ers_band is null then 'N/A'
  else ts.ers_band   end orig_ers_band,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          count(1) trade_count, sum(t.balance) total_balance, 
		  sum(t.credit_limit) total_credit, 
		sum(if(payment_status='90+',  t.balance,0)) delinquencyBalance ,
		sum(if(active_flag='Y',1,0)) active_trade_count,
		sum(if(active_flag='Y', t.balance,0)) active_total_balance,
 sum(if(active_flag='Y',t.credit_limit,0)) active_total_credit
  
  from pi2_development_db.pi2_trade_n t
left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)
left join (
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month ,
        row_number() over (partition by year_month,consumer_key order by ers_score desc, consumer_age desc) rn_s
 from pi2_development_db.pi2_consumer_n
 
) s
on t.consumer_key = s.consumer_key
and t.year_month = s.year_month
and s.rn_s = 1
left join(
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month,  
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1
where  t.year_month = ${curMonth}
  and t.vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  and t.joint_flag='P'
group by t.year_month,floor(vintage_month/100)  , ceiling(mod(vintage_month,100)/3)  ,  t.pi2_product,
case when   ts.ers_band is null then 'N/A'
  else ts.ers_band   end  ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end   

  ) tb 
  group by fi_cat, product_name,year_month,vintage_year, vintage_quarter,orig_ers_band)

select   bmo.year_month, bmo.vintage_year, bmo.vintage_quarter ,bmo.fi_cat,  bmo.product_name, bmo.orig_ers_band,
bmo.avg_delinquencyRate, 
( bmo.avg_delinquencyRate - PEER.avg_delinquencyRate ) * 100 variance_to_peer_avg_delinquencyRate_bps,
bmo.total_balance,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization,

(bmo.avg_utilization - PEER.avg_utilization)*100 variance_to_peer_avg_utilization_bps,
bmo.avg_balance,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance_dollar,
bmo.avg_active_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization,
(bmo.active_utilization - PEER.active_utilization)*100 variance_to_peer_active_utilization_bps
from source bmo
join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_year=peer.vintage_year
and bmo.vintage_quarter=peer.vintage_quarter
and bmo.product_name=peer.product_name
and bmo.orig_ers_band=peer.orig_ers_band
and bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_year,bmo.vintage_quarter,   bmo.fi_cat, bmo.product_name ,bmo.orig_ers_band;


 
 
 

 

 