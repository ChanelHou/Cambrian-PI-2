
 --chart 54 , from trade_vintages_o table, --defect 32

 select 
year_month, vintage_month, fi_cat,  product_name, 
 sum(orig_cons_age_total)/ sum(orig_cons_age_count) avg_orig_age, 
sum(total_balance) total_balance,
sum(total_balance)/sum(trade_count) avg_balance,
sum(total_credit)/sum(trade_count) avg_limit ,  
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(orig_total_score) /sum(orig_score_count) avg_orig_score ,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate
from  (
  
  select  vintage_month,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
        product_name,
         
          trade_count, total_balance, total_credit, total_score, 
		  score_count, orig_total_score, orig_score_count, orig_cons_age_total, orig_cons_age_count,  r.year_month,
 if(payment_status='90+', total_balance,0) delinquencyBalance    
  
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = ${pYear_Month} 
  and vintage_month between ${pStart_VintageMonth} and ${pEnd_VintageMonth}
) tb
group by year_month,vintage_month,   fi_cat, product_name   
 order by year_month,vintage_month,   fi_cat, product_name ;
 
 
 
 --chart 54 , from trade_vintages_o table, --defect 32

 select 
year_month, vintage_month, fi_cat,  product_name, 
 sum(orig_cons_age_total)/ sum(orig_cons_age_count) avg_orig_age, 
sum(total_balance) total_balance,
sum(total_balance)/sum(trade_count) avg_balance,
sum(total_credit)/sum(trade_count) avg_limit ,  
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(orig_total_score) /sum(orig_score_count) avg_orig_score ,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate
from  (
  
  select  vintage_month,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
        product_name,
         
          trade_count, total_balance, total_credit, total_score, 
		  score_count, orig_total_score, orig_score_count, orig_cons_age_total, orig_cons_age_count,  r.year_month,
 if(payment_status='90+', total_balance,0) delinquencyBalance    
  
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = 201801
  and vintage_month =201601
  and product_name='NCC') tb
group by year_month,vintage_month,   fi_cat, product_name   
 order by year_month,vintage_month,   fi_cat, product_name ;
 
 
 --account_age
 select year_month,  
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat,   product_name, 
  
sum(trade_count) trade_count 
from  pi2_development_db.trade_vintages_o r
where  year_month =201601
and account_age =1
 group by year_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end, product_name     ; 