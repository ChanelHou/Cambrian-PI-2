--by quarter chart 51-52

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
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
 t.vintage_month between ${fromMonth} and ${toMonth}
--and ((trade_status= '1' or trade_status='3') and last_active_age <=12)
--and trade_status= '1'
--and t.joint_flag='P'
group by t.pi2_product,t.vintage_month,t.account_age )
select product,vintage_year,vintage_quarter,quarter_age, (quarter_age - 3*vintage_quarter) quarter_account_age,
--totalBalance
sum(count_BMO),sum(balance_BMO),
--average balance per account
if(sum(count_BMO)<>0,sum(balance_BMO)/sum(count_BMO),null) avg_balance_BMO,
--average balance per active account
sum(count_active_BMO),sum(balance_active_BMO),if(sum(count_active_BMO)<>0,sum(balance_active_BMO)/sum(count_active_BMO),null) avg_active_balance_BMO,
--utilization rate 
if(sum(credit_limit_BMO)<>0,sum(balance_BMO)/sum(credit_limit_BMO)*100,null) uti_BMO,
--utilization active rate
if(sum(credit_limit_active_BMO)<>0,sum(balance_active_BMO)/sum(credit_limit_active_BMO)*100,null) uti_active_BMO,
--delinquencyRate
sum(balance_deli_BMO),if(sum(balance_BMO)<>0,sum(balance_deli_BMO)/sum(balance_BMO)*100,null) delinquencyBalanceRate,
--peer 
sum(count_PEER),sum(balance_PEER),
--average balance per account
if(sum(count_PEER)<>0,sum(balance_PEER)/sum(count_PEER),null) avg_balance_PEER,
--average balance per active account
sum(count_active_PEER),sum(balance_active_PEER),if(sum(count_active_PEER)<>0,sum(balance_active_PEER)/sum(count_active_PEER),null) avg_active_balance_PEER,
--utilization rate 
if(sum(credit_limit_PEER)<>0,sum(balance_PEER)/sum(credit_limit_PEER)*100,null) uti_PEER,
--utilization active rate
if(sum(credit_limit_active_PEER)<>0,sum(balance_active_PEER)/sum(credit_limit_active_PEER)*100,null) uti_active_PEER,
--delinquencyRate
sum(balance_deli_PEER),if(sum(balance_PEER)<>0,sum(balance_deli_PEER)/sum(balance_PEER)*100,null) delinquencyBalanceRate

from source
group by product,vintage_year,vintage_quarter,quarter_age
order by product,vintage_year,vintage_quarter,quarter_age;


--chart 54 , total account by quarter
select year_month,  
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat,   product_name, 
  
sum(trade_count) trade_count 
from  pi2_development_db.trade_vintages_o r
where  year_month in (201604,201607)
and account_age in ( 1,2,3)
 group by year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end, product_name     ; 

		 
--chart 54
select year_month, vintage_year,vintage_quarter,fi_cat, 
product_name, 
sum(trade_count) trade_count, sum(total_balance) total_balance, sum(total_credit) total_credit, 
sum(total_score) total_score, sum(score_count) score_count, sum(orig_total_score) orig_total_score, sum(orig_score_count) orig_score_count,
sum(orig_score_count_notNA) orig_score_count_notNA,sum(orig_total_score_notNA) orig_total_score_notNA,
sum(orig_cons_age_total) orig_cons_age_total, sum(orig_cons_age_count) orig_cons_age_count,
sum(delinquencyBalance) delinquencyBalance,
  sum(trade_status_count) trade_status_count,    
  sum(active_count) active_count
from  (
  
  select  year_month,  floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
        product_name,
         
          trade_count, total_balance, total_credit, total_score, score_count, orig_total_score, orig_score_count, orig_cons_age_total, orig_cons_age_count ,
 if(payment_status='90+', total_balance,0) delinquencyBalance   ,
 if(orig_ers_band='N/A',orig_score_count,0) orig_score_count_notNA,
 if(orig_ers_band='N/A',orig_total_score,0) orig_total_score_notNA,
 if(r.trade_count=1,r.trade_count,0) trade_status_count,
 if(r.active_flag='Y',r.trade_count,0) active_count
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = ${pYear_Month} 
  and vintage_month between ${pStart_VintageMonth} and ${pEnd_VintageMonth}
) tb
group by year_month, vintage_year,vintage_quarter,fi_cat, 
product_name    ;

--20181018 
--chart 56 by region by account
with cur as 
( select t.year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,t.pi2_product product,ts.province,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
 
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_PEER,
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') volume_active_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') volume_active_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL" and active_flag='Y')) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_active_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ) ) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_active_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) balance_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0)))  over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_PEER,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))  balance_active_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0)) balance_active_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_active_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product)  grandTotalbalance_active_PEER,

--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))  credit_limit_active_BMO,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_BMO,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product)  grandTotalcredit_limit_active_BMO,


sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0)) credit_limit_PEER,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0)) credit_limit_active_PEER,

sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_PEER,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_active_PEER,

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0)) balance_deli_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month

left join pi2_development_db.pi2_consumer_n ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month


where 
t.vintage_month between ${pStart_VintageMonth} and ${pEnd_VintageMonth}
 and t.year_month=${currMonth}
 
group by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3)  ,t.pi2_product,ts.province )  
select year_month,vintage_year,vintage_quarter,cur.product product,province,
--chart #acvolumes
volume_BMO, 
volume_deli_BMO,
volume_deli_PEER,
grandTotalAcct_BMO,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
volume_PEER ,
grandTotalAcct_PEER,
if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) - if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) variance_to_peer ,

--totalBalance
balance_BMO, 
grandTotalBalance_BMO,
if(grandTotalBalance_BMO<>0,(balance_BMO/grandTotalBalance_BMO)*100,null) shareAcct_BMO,
balance_PEER ,
grandTotalBalance_PEER,
if(grandTotalBalance_PEER<>0,(balance_PEER/grandTotalBalance_PEER )*100,null) shareAcct_PEER,
if(grandTotalBalance_BMO<>0,(balance_BMO/grandTotalBalance_BMO)*100,null) - if(grandTotalBalance_PEER<>0,(balance_PEER/grandTotalBalance_PEER )*100,null) variance_to_peer ,
--averageBalance Per acvolume
if(volume_BMO<>0,(balance_BMO/volume_BMO)*100,null) avg_balance_BMO,
if(volume_PEER<>0,(balance_PEER/volume_PEER)*100,null) avg_balance_PEER,
--average balance per active acvolume
volume_active_BMO,balance_active_BMO,if(volume_active_BMO<>0,balance_active_BMO/volume_active_BMO,null) avg_active_balance_BMO,
volume_active_PEER,balance_active_PEER,if(volume_active_PEER<>0,balance_active_PEER/volume_active_PEER,null) avg_active_balance_PEER,
--utilization rate 
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER,
--utilization active rate
if(credit_limit_active_BMO<>0,balance_active_BMO/credit_limit_active_BMO*100,null) uti_active_BMO,
if(credit_limit_active_PEER<>0,balance_active_PEER/credit_limit_active_PEER*100,null) uti_active_PEER,
--delinquencyRate
balance_deli_BMO,if(balance_BMO<>0,balance_deli_BMO/balance_BMO*100,null) delinquencyBalanceRate_BMO,
balance_deli_PEER,if(balance_PEER<>0,balance_deli_PEER/balance_PEER*100,null) delinquencyBalanceRate_PEER
from cur
order by year_month,vintage_quarter,product  ,province;


--20181018 
--chart 56 by age by account
with cur as 
( select t.year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,t.pi2_product product,ts.ers_band,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
 
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_PEER,
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') volume_active_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') volume_active_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL" and active_flag='Y')) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_active_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ) ) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_active_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) balance_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0)))  over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_PEER,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))  balance_active_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0)) balance_active_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_active_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product)  grandTotalbalance_active_PEER,

--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))  credit_limit_active_BMO,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_BMO,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product)  grandTotalcredit_limit_active_BMO,


sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0)) credit_limit_PEER,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0)) credit_limit_active_PEER,

sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_PEER,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_active_PEER,

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0)) balance_deli_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month

left join pi2_development_db.pi2_consumer_n ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month


where 
t.vintage_month between ${pStart_VintageMonth} and ${pEnd_VintageMonth}
 and t.year_month=${currMonth}
 
group by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3)  ,t.pi2_product,ts.ers_band )  
select year_month,vintage_year,vintage_quarter,cur.product product,ers_band,
--chart #acvolumes
volume_BMO, 
volume_deli_BMO,
volume_deli_PEER,
grandTotalAcct_BMO,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
volume_PEER ,
grandTotalAcct_PEER,
if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) - if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) variance_to_peer ,

--totalBalance
balance_BMO, 
grandTotalBalance_BMO,
if(grandTotalBalance_BMO<>0,(balance_BMO/grandTotalBalance_BMO)*100,null) shareAcct_BMO,
balance_PEER ,
grandTotalBalance_PEER,
if(grandTotalBalance_PEER<>0,(balance_PEER/grandTotalBalance_PEER )*100,null) shareAcct_PEER,
if(grandTotalBalance_BMO<>0,(balance_BMO/grandTotalBalance_BMO)*100,null) - if(grandTotalBalance_PEER<>0,(balance_PEER/grandTotalBalance_PEER )*100,null) variance_to_peer ,
--averageBalance Per acvolume
if(volume_BMO<>0,(balance_BMO/volume_BMO)*100,null) avg_balance_BMO,
if(volume_PEER<>0,(balance_PEER/volume_PEER)*100,null) avg_balance_PEER,
--average balance per active acvolume
volume_active_BMO,balance_active_BMO,if(volume_active_BMO<>0,balance_active_BMO/volume_active_BMO,null) avg_active_balance_BMO,
volume_active_PEER,balance_active_PEER,if(volume_active_PEER<>0,balance_active_PEER/volume_active_PEER,null) avg_active_balance_PEER,
--utilization rate 
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER,
--utilization active rate
if(credit_limit_active_BMO<>0,balance_active_BMO/credit_limit_active_BMO*100,null) uti_active_BMO,
if(credit_limit_active_PEER<>0,balance_active_PEER/credit_limit_active_PEER*100,null) uti_active_PEER,
--delinquencyRate
balance_deli_BMO,if(balance_BMO<>0,balance_deli_BMO/balance_BMO*100,null) delinquencyBalanceRate_BMO,
balance_deli_PEER,if(balance_PEER<>0,balance_deli_PEER/balance_PEER*100,null) delinquencyBalanceRate_PEER
from cur
order by year_month,vintage_quarter,product  ,ers_band;



with cur as 
( select t.year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,t.pi2_product product,ts.consumer_age_cat,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
 
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL")) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) ) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_PEER,
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') volume_active_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') volume_active_PEER ,
sum(sum(t.joint_flag='P' and c.fi_name = "BANK OF MONTREAL" and active_flag='Y')) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_active_BMO,
sum(sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ) ) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalAcct_active_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) balance_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0)))  over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_PEER,
 
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))  balance_active_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0)) balance_active_PEER,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalbalance_active_BMO,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product)  grandTotalbalance_active_PEER,

--chart 27 limit
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))  credit_limit_BMO,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))  credit_limit_active_BMO,

sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_BMO,
sum(sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product)  grandTotalcredit_limit_active_BMO,


sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0)) credit_limit_PEER,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0)) credit_limit_active_PEER,

sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_PEER,
sum(sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y',credit_limit,0))) over(partition by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),t.pi2_product) grandTotalcredit_limit_active_PEER,

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER,
sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0)) balance_deli_PEER

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month

left join pi2_development_db.pi2_consumer_n ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month


where 
t.vintage_month between ${pStart_VintageMonth} and ${pEnd_VintageMonth}
 and t.year_month=${currMonth}
 
group by t.year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3)  ,t.pi2_product,ts.consumer_age_cat )  
select year_month,vintage_year,vintage_quarter,cur.product product,consumer_age_cat,
--chart #acvolumes
volume_BMO, 
volume_deli_BMO,
volume_deli_PEER,
grandTotalAcct_BMO,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) shareAcct_BMO,
volume_PEER ,
grandTotalAcct_PEER,
if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) shareAcct_PEER,
if(grandTotalAcct_BMO<>0,(volume_BMO/grandTotalAcct_BMO)*100,null) - if(grandTotalAcct_PEER<>0,(volume_PEER/grandTotalAcct_PEER )*100,null) variance_to_peer ,

--totalBalance
balance_BMO, 
grandTotalBalance_BMO,
if(grandTotalBalance_BMO<>0,(balance_BMO/grandTotalBalance_BMO)*100,null) shareAcct_BMO,
balance_PEER ,
grandTotalBalance_PEER,
if(grandTotalBalance_PEER<>0,(balance_PEER/grandTotalBalance_PEER )*100,null) shareAcct_PEER,
if(grandTotalBalance_BMO<>0,(balance_BMO/grandTotalBalance_BMO)*100,null) - if(grandTotalBalance_PEER<>0,(balance_PEER/grandTotalBalance_PEER )*100,null) variance_to_peer ,
--averageBalance Per acvolume
if(volume_BMO<>0,(balance_BMO/volume_BMO)*100,null) avg_balance_BMO,
if(volume_PEER<>0,(balance_PEER/volume_PEER)*100,null) avg_balance_PEER,
--average balance per active acvolume
volume_active_BMO,balance_active_BMO,if(volume_active_BMO<>0,balance_active_BMO/volume_active_BMO,null) avg_active_balance_BMO,
volume_active_PEER,balance_active_PEER,if(volume_active_PEER<>0,balance_active_PEER/volume_active_PEER,null) avg_active_balance_PEER,
--utilization rate 
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER,
--utilization active rate
if(credit_limit_active_BMO<>0,balance_active_BMO/credit_limit_active_BMO*100,null) uti_active_BMO,
if(credit_limit_active_PEER<>0,balance_active_PEER/credit_limit_active_PEER*100,null) uti_active_PEER,
--delinquencyRate
balance_deli_BMO,if(balance_BMO<>0,balance_deli_BMO/balance_BMO*100,null) delinquencyBalanceRate_BMO,
balance_deli_PEER,if(balance_PEER<>0,balance_deli_PEER/balance_PEER*100,null) delinquencyBalanceRate_PEER
from cur
order by year_month,vintage_quarter,product  ,consumer_age_cat;




--vintage_o table by risk
with source as 
( select  year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,product_name, 
case when orig_ers_band is null then 'N/A' else orig_ers_band end orig_ers_band_cat,

case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
			  
sum(trade_count) volume, 
sum(sum(trade_count)) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalAcct,
sum(if( active_flag='Y', trade_count,0)) volume_active,
sum(sum(if( active_flag='Y', trade_count,0))) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalAcct_active,
sum(total_balance) balance, 

sum(sum(total_balance)) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name)  grandTotalbalance,
sum(if( active_flag='Y', total_balance,0)) balance_active,
sum(sum(if( active_flag='Y', total_balance,0))) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalbalance_active,
sum(total_credit) credit_limit, 
sum(if( active_flag='Y',total_credit,0)) credit_limit_active, 
sum(if(payment_status='90+',total_balance,0)) balance_deli , 
 
sum(if(payment_status='90+',trade_count,0)) volume_deli 
from  pi2_development_db.trade_vintages_o 
where  year_month = ${pYear_Month} 
and vintage_month between ${pStart_VintageMonth} and ${pEnd_VintageMonth}
 
group by year_month, floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,
product_name,case when orig_ers_band is null then 'N/A' else orig_ers_band end )
select c.year_month,c.vintage_year,c.vintage_quarter,c.product_name,c.orig_ers_band_cat,
--chart #acvolumes
c.volume volume_BMO, 
c.volume_deli volume_deli_BMO,
peer.volume_deli volume_deli_peer,
c.grandTotalAcct grandTotalAcct_BMO,
if(c.grandTotalAcct<>0,(c.volume/c.grandTotalAcct)*100,null) shareAcct_BMO,
peer.volume volume_PEER ,
peer.grandTotalAcct grandTotalAcct_PEER,
if(peer.grandTotalAcct<>0,(peer.volume/peer.grandTotalAcct )*100,null) shareAcct_PEER,
if(c.grandTotalAcct<>0,(c.volume/c.grandTotalAcct)*100,null) - if(peer.grandTotalAcct <>0,(peer.volume/peer.grandTotalAcct )*100,null) variance_to_peer ,

--totalBalance
c.balance balance_BMO, 
c.grandTotalbalance grandTotalBalance_BMO,
if(c.grandTotalBalance<>0,(c.balance/c.grandTotalBalance)*100,null) shareAcct_BMO,
peer.balance balance_PEER ,
peer.grandTotalBalance grandTotalBalance_PEER,
if(peer.grandTotalBalance<>0,(peer.balance/peer.grandTotalBalance )*100,null) shareAcct_PEER,
if(c.grandTotalBalance<>0,(c.balance/c.grandTotalBalance)*100,null) - if(peer.grandTotalBalance<>0,(peer.balance/peer.grandTotalBalance )*100,null) variance_to_peer ,
--averageBalance Per acvolume
if(c.volume<>0,(c.balance/c.volume) ,null) avg_balance_BMO,
if(peer.volume<>0,(peer.balance/peer.volume) ,null) avg_balance_PEER,
--average balance per active acvolume
c.volume_active,c.balance_active,if(c.volume_active<>0,c.balance_active/c.volume_active,null) avg_active_balance_BMO,
peer.volume_active,peer.balance_active,if(peer.volume_active<>0,peer.balance_active/peer.volume_active,null) avg_active_balance_PEER,
--utilization rate 
if(c.credit_limit<>0,c.balance/c.credit_limit*100,null) uti_BMO,
if(peer.credit_limit<>0,peer.balance/peer.credit_limit*100,null) uti_PEER,
--utilization active rate
if(c.credit_limit_active<>0,c.balance_active/c.credit_limit_active*100,null) uti_active_BMO,
if(peer.credit_limit_active<>0,peer.balance_active/peer.credit_limit_active*100,null) uti_active_PEER,
--delinquencyRate
c.balance_deli,if(c.balance<>0,c.balance_deli/c.balance*100,null) delinquencyBalanceRate_BMO,
peer.balance_deli ,if(peer.balance <>0,peer.balance_deli /peer.balance *100,null) delinquencyBalanceRate_PEER
from source c 
join source peer
on c.year_month=peer.year_month
and c.vintage_year=peer.vintage_year 
and c.vintage_quarter=peer.vintage_quarter
and c.product_name=peer.product_name
and c.orig_ers_band_cat=peer.orig_ers_band_cat
where c.fi_cat='BMO'
and peer.fi_cat="Peer" 
order by c.year_month,c.vintage_quarter,c.product_name  ,c.orig_ers_band_cat;



-- by age  201801,201601-201606
with source as 
( select  year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,product_name, 
case when orig_age_cat  is null then 'Unknown' else orig_age_cat  end orig_age_cat_new,

case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
			  
sum(trade_count) volume, 
sum(sum(trade_count)) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalAcct,
sum(if( active_flag='Y', trade_count,0)) volume_active,
sum(sum(if( active_flag='Y', trade_count,0))) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalAcct_active,
sum(total_balance) balance, 

sum(sum(total_balance)) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name)  grandTotalbalance,
sum(if( active_flag='Y', total_balance,0)) balance_active,
sum(sum(if( active_flag='Y', total_balance,0))) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalbalance_active,
sum(total_credit) credit_limit, 
sum(if( active_flag='Y',total_credit,0)) credit_limit_active, 
sum(if(payment_status='90+',total_balance,0)) balance_deli , 
 
sum(if(payment_status='90+',trade_count,0)) volume_deli 
from  pi2_development_db.trade_vintages_o 
where  year_month = ${pYear_Month} 
and vintage_month between ${pStart_VintageMonth} and ${pEnd_VintageMonth}
 
group by year_month, floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,
product_name,case when orig_age_cat  is null then 'Unknown' else orig_age_cat  end )
select c.year_month,c.vintage_year,c.vintage_quarter,c.product_name,c.orig_age_cat_new,
--chart #acvolumes
c.volume volume_BMO, 
c.volume_deli volume_deli_BMO,
peer.volume_deli volume_deli_peer,
c.grandTotalAcct grandTotalAcct_BMO,
if(c.grandTotalAcct<>0,(c.volume/c.grandTotalAcct)*100,null) shareAcct_BMO,
peer.volume volume_PEER ,
peer.grandTotalAcct grandTotalAcct_PEER,
if(peer.grandTotalAcct<>0,(peer.volume/peer.grandTotalAcct )*100,null) shareAcct_PEER,
if(c.grandTotalAcct<>0,(c.volume/c.grandTotalAcct)*100,null) - if(peer.grandTotalAcct <>0,(peer.volume/peer.grandTotalAcct )*100,null) variance_to_peer ,

--totalBalance
c.balance balance_BMO, 
c.grandTotalbalance grandTotalBalance_BMO,
if(c.grandTotalBalance<>0,(c.balance/c.grandTotalBalance)*100,null) shareAcct_BMO,
peer.balance balance_PEER ,
peer.grandTotalBalance grandTotalBalance_PEER,
if(peer.grandTotalBalance<>0,(peer.balance/peer.grandTotalBalance )*100,null) shareAcct_PEER,
if(c.grandTotalBalance<>0,(c.balance/c.grandTotalBalance)*100,null) - if(peer.grandTotalBalance<>0,(peer.balance/peer.grandTotalBalance )*100,null) variance_to_peer ,
--averageBalance Per acvolume
if(c.volume<>0,(c.balance/c.volume) ,null) avg_balance_BMO,
if(peer.volume<>0,(peer.balance/peer.volume) ,null) avg_balance_PEER,
--average balance per active acvolume
c.volume_active,c.balance_active,if(c.volume_active<>0,c.balance_active/c.volume_active,null) avg_active_balance_BMO,
peer.volume_active,peer.balance_active,if(peer.volume_active<>0,peer.balance_active/peer.volume_active,null) avg_active_balance_PEER,
--utilization rate 
if(c.credit_limit<>0,c.balance/c.credit_limit*100,null) uti_BMO,
if(peer.credit_limit<>0,peer.balance/peer.credit_limit*100,null) uti_PEER,
--utilization active rate
if(c.credit_limit_active<>0,c.balance_active/c.credit_limit_active*100,null) uti_active_BMO,
if(peer.credit_limit_active<>0,peer.balance_active/peer.credit_limit_active*100,null) uti_active_PEER,
--delinquencyRate
c.balance_deli,if(c.balance<>0,c.balance_deli/c.balance*100,null) delinquencyBalanceRate_BMO,
peer.balance_deli ,if(peer.balance <>0,peer.balance_deli /peer.balance *100,null) delinquencyBalanceRate_PEER
from source c 
join source peer
on c.year_month=peer.year_month
and c.vintage_year=peer.vintage_year 
and c.vintage_quarter=peer.vintage_quarter
and c.product_name=peer.product_name
and c.orig_age_cat_new=peer.orig_age_cat_new
where c.fi_cat='BMO'
and peer.fi_cat="Peer" 
order by c.year_month,c.vintage_quarter,c.product_name  ,c.orig_age_cat_new;


-- by province  201801,201601-201606
with source as 
( select  year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,product_name, 
case when orig_province  is null then 'N/A' else orig_province  end orig_province_new,

case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
			  
sum(trade_count) volume, 
sum(sum(trade_count)) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalAcct,
sum(if( active_flag='Y', trade_count,0)) volume_active,
sum(sum(if( active_flag='Y', trade_count,0))) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalAcct_active,
sum(total_balance) balance, 

sum(sum(total_balance)) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name)  grandTotalbalance,
sum(if( active_flag='Y', total_balance,0)) balance_active,
sum(sum(if( active_flag='Y', total_balance,0))) over(partition by year_month,floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,product_name) grandTotalbalance_active,
sum(total_credit) credit_limit, 
sum(if( active_flag='Y',total_credit,0)) credit_limit_active, 
sum(if(payment_status='90+',total_balance,0)) balance_deli , 
 
sum(if(payment_status='90+',trade_count,0)) volume_deli 
from  pi2_development_db.trade_vintages_o 
where  year_month = ${pYear_Month} 
and vintage_month between ${pStart_VintageMonth} and ${pEnd_VintageMonth}
 
group by year_month, floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end,
product_name,case when orig_province  is null then 'U/A' else orig_province  end  )
select c.year_month,c.vintage_year,c.vintage_quarter,c.product_name,c.orig_province_new,
--chart #acvolumes
c.volume volume_BMO, 
c.volume_deli volume_deli_BMO,
peer.volume_deli volume_deli_peer,
c.grandTotalAcct grandTotalAcct_BMO,
if(c.grandTotalAcct<>0,(c.volume/c.grandTotalAcct)*100,null) shareAcct_BMO,
peer.volume volume_PEER ,
peer.grandTotalAcct grandTotalAcct_PEER,
if(peer.grandTotalAcct<>0,(peer.volume/peer.grandTotalAcct )*100,null) shareAcct_PEER,
if(c.grandTotalAcct<>0,(c.volume/c.grandTotalAcct)*100,null) - if(peer.grandTotalAcct <>0,(peer.volume/peer.grandTotalAcct )*100,null) variance_to_peer ,

--totalBalance
c.balance balance_BMO, 
c.grandTotalbalance grandTotalBalance_BMO,
if(c.grandTotalBalance<>0,(c.balance/c.grandTotalBalance)*100,null) shareAcct_BMO,
peer.balance balance_PEER ,
peer.grandTotalBalance grandTotalBalance_PEER,
if(peer.grandTotalBalance<>0,(peer.balance/peer.grandTotalBalance )*100,null) shareAcct_PEER,
if(c.grandTotalBalance<>0,(c.balance/c.grandTotalBalance)*100,null) - if(peer.grandTotalBalance<>0,(peer.balance/peer.grandTotalBalance )*100,null) variance_to_peer ,
--averageBalance Per acvolume
if(c.volume<>0,(c.balance/c.volume) ,null) avg_balance_BMO,
if(peer.volume<>0,(peer.balance/peer.volume) ,null) avg_balance_PEER,
--average balance per active acvolume
c.volume_active,c.balance_active,if(c.volume_active<>0,c.balance_active/c.volume_active,null) avg_active_balance_BMO,
peer.volume_active,peer.balance_active,if(peer.volume_active<>0,peer.balance_active/peer.volume_active,null) avg_active_balance_PEER,
--utilization rate 
if(c.credit_limit<>0,c.balance/c.credit_limit*100,null) uti_BMO,
if(peer.credit_limit<>0,peer.balance/peer.credit_limit*100,null) uti_PEER,
--utilization active rate
if(c.credit_limit_active<>0,c.balance_active/c.credit_limit_active*100,null) uti_active_BMO,
if(peer.credit_limit_active<>0,peer.balance_active/peer.credit_limit_active*100,null) uti_active_PEER,
--delinquencyRate
c.balance_deli,if(c.balance<>0,c.balance_deli/c.balance*100,null) delinquencyBalanceRate_BMO,
peer.balance_deli ,if(peer.balance <>0,peer.balance_deli /peer.balance *100,null) delinquencyBalanceRate_PEER
from source c 
join source peer
on c.year_month=peer.year_month
and c.vintage_year=peer.vintage_year 
and c.vintage_quarter=peer.vintage_quarter
and c.product_name=peer.product_name
and c.orig_province_new=peer.orig_province_new
where c.fi_cat='BMO'
and peer.fi_cat="Peer" 
order by c.year_month,c.vintage_quarter,c.product_name  ,c.orig_province_new;

--deliquency -------------------------------------------------------------------------------

with cur as 
( select t.year_month, t.vintage_month,t.pi2_product product,ts.ers_band,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') volume_BMO, 

sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) volume_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+') volume_deli_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' ,balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ,balance,0)) balance_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0)) balance_deli_PEER

from pi2_trade_o t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month

left join pi2_development_db.pi2_consumer_n ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month


where 
t.vintage_month=${vintage_month}
 and t.year_month=${currMonth}
 
group by t.year_month,t.vintage_month,t.pi2_product,ts.ers_band )  
select year_month,cur.product product,ers_band,
 
volume_BMO, 
volume_deli_BMO,
if(volume_BMO<>0,volume_deli_BMO/volume_BMO*100,null) delinquencyVolumeRate_BMO,
volume_PEER ,
volume_deli_PEER,
if(volume_PEER<>0,volume_deli_PEER/volume_PEER*100,null) delinquencyVolumeRate_PEER,
 
balance_BMO, 
balance_PEER ,
 
balance_deli_BMO,if(balance_BMO<>0,balance_deli_BMO/balance_BMO*100,null) delinquencyBalanceRate_BMO,
balance_deli_PEER,if(balance_PEER<>0,balance_deli_PEER/balance_PEER*100,null) delinquencyBalanceRate_PEER
from cur
order by year_month,product  ,ers_band;
--from trade_vintages_o

with cur as 
( select t.year_month, t.vintage_month,  product_name,orig_ers_band,
sum(if(fi_name = "BANK OF MONTREAL",trade_count ,0) ) volume_BMO, 

sum(if(peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL" ,trade_count ,0) ) volume_PEER ,
sum(if(fi_name = "BANK OF MONTREAL"  and payment_status='90+',trade_count ,0)) volume_deli_BMO, 
sum(if(peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL"  and payment_status='90+',trade_count ,0)) volume_deli_PEER,

sum(if(fi_name = "BANK OF MONTREAL"  and payment_status='90+',total_balance,0))  balance_deli_BMO,
sum(if(peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL"  and payment_status='90+',total_balance,0)) balance_deli_PEER,
sum(if(fi_name = "BANK OF MONTREAL"  ,total_balance,0))  balance_BMO,
sum(if(peer_id =3 and nvl(fi_name,'') <> "BANK OF MONTREAL"  ,total_balance,0)) balance_PEER

from trade_vintages_o t
 
where 
t.vintage_month=${vintage_month}
 and t.year_month=${currMonth}
 
group by t.year_month,t.vintage_month,t.product_name,orig_ers_band )  
select year_month,cur.product_name product_name,orig_ers_band,
 
volume_BMO, 
volume_deli_BMO,
if(volume_BMO<>0,volume_deli_BMO/volume_BMO*100,null)
volume_PEER ,
volume_deli_PEER,
if(volume_PEER<>0,volume_deli_PEER/volume_PEER*100,null)
--totalBalance
balance_BMO, 
balance_PEER ,
--delinquencyRate
balance_deli_BMO,if(balance_BMO<>0,balance_deli_BMO/balance_BMO*100,null) delinquencyBalanceRate_BMO,
balance_deli_PEER,if(balance_PEER<>0,balance_deli_PEER/balance_PEER*100,null) delinquencyBalanceRate_PEER
from cur
order by year_month,product_name  ,orig_ers_band;

 
 