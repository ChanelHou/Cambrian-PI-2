--chart 51-52 by month
select  vintage_month, fi_cat,  product_name, account_age,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization
from  (
  
  select   vintage_month,product_name,account_age,
   
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   
  where  vintage_month between ${fromMonth} and ${toMonth}) t
group by  fi_cat, vintage_month,   product_name  ,account_age
order by  fi_cat,product_name, vintage_month,   account_age;

--chart 51-52 by quarter


select  fi_cat, product_name,vintage_year, vintage_quarter,quarter_age,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization
from  (
  
  select   floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,mod(vintage_month,100)+account_age - 3 *ceiling(mod(vintage_month,100)/3) quarter_age ,product_name, 
   
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   
  where  vintage_month between ${fromMonth} and ${toMonth}) t
group by  fi_cat, product_name,vintage_year, vintage_quarter,quarter_age    
order by  fi_cat, product_name,vintage_year, vintage_quarter,quarter_age ;

 --chart 54 , from trade_vintages_o table, by month --defect 32

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
 
 --chart 54 by quarter
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
group by year_month, vintage_year,vintage_quarter,fi_cat;

--trade_count
select 
 t.year_month,t.pi2_product product, t.vintage_month, 
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) count_PEER 

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
  
  t.vintage_month between ${from_vintage_month}  and ${to_vintage_month}  
 and account_age=1
 group by  t.year_month,t.vintage_month,t.pi2_product
 
 


select    vintage_month,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat,   product_name, 
  
sum(trade_count) trade_count 
from  pi2_development_db.trade_vintages_o r
where   
  vintage_month between ${from_vintage_month}  and ${to_vintage_month}  

and account_age =1
 group by   r.vintage_month, case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end, product_name  	 ; 
		 
-- trade count by quarter		 
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



--chart 56  by age by month

with source as (
select year_month, vintage_month, fi_cat,  product_name, orig_age_cat,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month,vintage_month,product_name) grandTotalbalance
from  (
  
  select  year_month,vintage_month,product_name,
  case when   orig_age_cat is null then 'Unknown'
  else orig_age_cat end orig_age_cat,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = ${curMonth}
  and vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  ) tb
group by year_month,vintage_month,   fi_cat, product_name ,orig_age_cat  )

select bmo.*,

bmo.avg_delinquencyRate - PEER.avg_delinquencyRate  variance_to_peer_avg_delinquencyRate,
bmo.total_balance - PEER.total_balance variance_to_peer_total_balance,
bmo.total_balance/bmo.grandTotalBalance totalBalance_MarketShare_BMO,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization - PEER.avg_utilization variance_to_peer_avg_utilization,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization - PEER.active_utilization variance_to_peer_active_utilization
from source bmo
join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_month=peer.vintage_month
and bmo.product_name=peer.product_name
and bmo.orig_age_cat=peer.orig_age_cat
where bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_month,   bmo.fi_cat, bmo.product_name ,bmo.orig_age_cat;

--chart 56 by age by quarter
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
select  year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,product_name, 
  case when   orig_age_cat is null then 'Unknown'
  else orig_age_cat end orig_age_cat,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   where  year_month = ${curMonth}
  and vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  ) tb
group by  fi_cat, product_name,year_month,vintage_year, vintage_quarter,orig_age_cat  )
select bmo.*,
bmo.avg_delinquencyRate - PEER.avg_delinquencyRate  variance_to_peer_avg_delinquencyRate,
bmo.total_balance - PEER.total_balance variance_to_peer_total_balance,
bmo.total_balance/bmo.grandTotalBalance totalBalance_MarketShare_BMO,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization - PEER.avg_utilization variance_to_peer_avg_utilization,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization - PEER.active_utilization variance_to_peer_active_utilization
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



--chart 56  by region by month

with source as (
select year_month, vintage_month, fi_cat,  product_name, orig_province,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month,vintage_month,product_name) grandTotalbalance
from  (
  
  select  year_month,vintage_month,product_name,
  case when   orig_province is null then 'N/A'
  else orig_province end orig_province,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = ${curMonth}
  and vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  ) tb
group by year_month,vintage_month,   fi_cat, product_name ,orig_province  )
select bmo.*,
bmo.avg_delinquencyRate - PEER.avg_delinquencyRate  variance_to_peer_avg_delinquencyRate,
bmo.total_balance - PEER.total_balance variance_to_peer_total_balance,
bmo.total_balance/bmo.grandTotalBalance totalBalance_MarketShare_BMO,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization - PEER.avg_utilization variance_to_peer_avg_utilization,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization - PEER.active_utilization variance_to_peer_active_utilization
from source bmo
left join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_month=peer.vintage_month
and bmo.product_name=peer.product_name
and bmo.orig_province=peer.orig_province
and bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_month,   bmo.fi_cat, bmo.product_name ,bmo.orig_province;

--chart 56 by region by quarter , left join where condition will filter no match record for the left join , so need change where to on 
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
select  year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,product_name, 
  case when   orig_province is null then 'N/A'
  else orig_province end orig_province,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   where  year_month = ${curMonth}
  and vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  ) tb
group by  fi_cat, product_name,year_month,vintage_year, vintage_quarter,orig_province  )
select bmo.*,
bmo.avg_delinquencyRate - PEER.avg_delinquencyRate  variance_to_peer_avg_delinquencyRate,
bmo.total_balance - PEER.total_balance variance_to_peer_total_balance,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization - PEER.avg_utilization variance_to_peer_avg_utilization,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance,
bmo.total_balance/bmo.grandTotalBalance totalBalance_MarketShare_BMO,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization - PEER.active_utilization variance_to_peer_active_utilization
from source bmo
left join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_year=peer.vintage_year
and bmo.vintage_quarter=peer.vintage_quarter
and bmo.product_name=peer.product_name
and bmo.orig_province=peer.orig_province
and bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_year,bmo.vintage_quarter,   bmo.fi_cat, bmo.product_name ,bmo.orig_province;


--chart 56  by risk by month
with source as (
select year_month, vintage_month, fi_cat,  product_name, orig_ers_band,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,
sum(sum(total_balance))  over(partition by fi_cat,year_month,vintage_month,product_name) grandTotalbalance
from  (
   select  year_month,vintage_month,product_name,
  case when   orig_ers_band is null then 'N/A'
  else orig_ers_band end orig_ers_band,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = ${curMonth}
  and vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  ) tb
group by year_month,vintage_month,   fi_cat, product_name ,orig_ers_band  )
select bmo.*,
bmo.avg_delinquencyRate - PEER.avg_delinquencyRate  variance_to_peer_avg_delinquencyRate,
bmo.total_balance - PEER.total_balance variance_to_peer_total_balance,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization - PEER.avg_utilization variance_to_peer_avg_utilization,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance,
bmo.total_balance/bmo.grandTotalBalance totalBalance_MarketShare_BMO,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization - PEER.active_utilization variance_to_peer_active_utilization
from source bmo
join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_month=peer.vintage_month
and bmo.product_name=peer.product_name
and bmo.orig_ers_band=peer.orig_ers_band
where bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_month,   bmo.fi_cat, bmo.product_name ,bmo.orig_ers_band;

--chart 56 by risk by quarter
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
select  year_month, floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,product_name, 
  case when   orig_ers_band is null then 'N/A'
  else orig_ers_band end orig_ers_band,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   where  year_month = ${curMonth}
  and vintage_month between ${VintagefromMonth} and ${VintagetoMonth} 
  ) tb
group by  fi_cat, product_name,year_month,vintage_year, vintage_quarter,orig_ers_band  )
select bmo.*,
bmo.avg_delinquencyRate - PEER.avg_delinquencyRate  variance_to_peer_avg_delinquencyRate,
bmo.total_balance - PEER.total_balance variance_to_peer_total_balance,
bmo.total_balance/bmo.grandTotalBalance totalBalance_MarketShare_BMO,
(bmo.total_balance/bmo.grandTotalBalance - peer.total_balance/peer.grandTotalBalance)*100 variance_to_peer_marketShare_balance,
bmo.avg_utilization - PEER.avg_utilization variance_to_peer_avg_utilization,
bmo.avg_balance - PEER.avg_balance variance_to_peer_avg_balance,
bmo.avg_active_balance - PEER.avg_active_balance variance_to_peer_avg_active_balance,
bmo.active_utilization - PEER.active_utilization variance_to_peer_active_utilization
from source bmo
join source peer
on bmo.year_month = peer.year_month 
and bmo.vintage_year=peer.vintage_year
and bmo.vintage_quarter=peer.vintage_quarter
and bmo.product_name=peer.product_name
and bmo.orig_ers_band=peer.orig_ers_band
where bmo.fi_cat='BMO'
and peer.fi_cat='Peer'
order by bmo.year_month,bmo.vintage_year,bmo.vintage_quarter,   bmo.fi_cat, bmo.product_name ,bmo.orig_ers_band;








--defect 44,chart 56

select year_month, vintage_month, fi_cat,  product_name, orig_age_cat,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization
from  (
  
  select  year_month,vintage_month,product_name,
  case when   orig_age_cat is null then 'Unknown'
  else orig_age_cat end orig_age_cat,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = 201801
  and vintage_month =201601
  and product_name='NCC') tb
group by year_month,vintage_month,   fi_cat, product_name ,orig_age_cat  
order by year_month,vintage_month,   fi_cat, product_name ,orig_age_cat;


--by province

select year_month, vintage_month, fi_cat,  product_name, orig_province ,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization
from  (
  
  select  year_month,vintage_month,product_name,
  case when   orig_province  is null then 'N/A'
  else orig_province  end orig_province ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = 201801
  and vintage_month =201601
  and product_name='NCC') tb
group by year_month,vintage_month,   fi_cat, product_name ,orig_province   
order by year_month,vintage_month,   fi_cat, product_name ,orig_province ;
 
 --by risk
 
 select year_month, vintage_month, fi_cat,  product_name, orig_ers_band ,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization
from  (
  
  select  year_month,vintage_month,product_name,
  case when   orig_ers_band  is null then 'N/A'
  else orig_ers_band  end orig_ers_bande ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
             
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit
  from  pi2_development_db.trade_vintages_o r
   
  where  year_month = 201801
  and vintage_month =201601
  and product_name='NCC') tb
group by year_month,vintage_month,   fi_cat, product_name ,orig_ers_band   
order by year_month,vintage_month,   fi_cat, product_name ,orig_ers_band ;
 

 
 --chart 54 , from trade_vintages_o table, --defect 32

 select sum(orig_cons_age_total)/ sum(orig_cons_age_count) avg_orig_age, 
sum(total_balance) total_balance,
sum(total_balance)/sum(trade_count) avg_balance,
sum(total_credit)/sum(trade_count) avg_limit , 
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(orig_total_score) /sum(orig_score_count) avg_orig_score ,
sum(if(payment_status='90+', total_balance,0))/sum(total_balance)*100 avg_delinquencyRate
from pi2_development_db.trade_vintages_o r
where year_month = 201801
and vintage_month =201601
and product_name="NCC" 
and fi_name = "BANK OF MONTREAL"


select 
 t.year_month,t.pi2_product product, t.vintage_month, 
 
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) count_PEER 

from pi2_trade_n t
join pi2_customer_n c
on t.fi_id = c.fi_id
and c.year_month=greatest( 201609, t.year_month)
--and t.year_month=c.year_month
join pi2_consumer_n    as s 
on t.consumer_key = s.consumer_key
and t.year_month=s.year_month
where 
  
  t.vintage_month between ${from_vintage_month}  and ${to_vintage_month}  
 and account_age=1
 group by  t.year_month,t.vintage_month,t.pi2_product;
 
 
 
 ----2018/11/28
 
 select  vintage_month, fi_cat,  product_name, account_age,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
if(sum(total_credit)<>0,sum(total_balance)/sum(total_credit)*100,null) avg_utilization,
sum(total_balance)/sum(trade_count) avg_balance,
sum(active_total_balance)/sum(active_trade_count) avg_active_balance,
sum(active_total_balance)/sum(active_total_credit)*100 active_utilization,


sum(delinquencyBalance_open)/sum(total_balance_open)*100 avg_delinquencyRate_open,
sum(total_balance_open) total_balance_open,
if(sum(total_credit_open)<>0,sum(total_balance_open)/sum(total_credit_open)*100,null) avg_utilization_open,
sum(total_balance_open)/sum(trade_count_open) avg_balance_open,
sum(active_total_balance_open)/sum(active_trade_count_open) avg_active_balance_open,
sum(active_total_balance_open)/sum(active_total_credit_open)*100 active_utilization_open,
sum(total_balance) -sum(total_balance_open)

from  (
  
  select   vintage_month,product_name,account_age,
   
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
          trade_count, total_balance, 
		  total_credit, 
		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		if(active_flag='Y',trade_count,0) active_trade_count,
		if(active_flag='Y',total_balance,0) active_total_balance,
 if(active_flag='Y',total_credit,0) active_total_credit,
 
 
   if(trade_status='1',trade_count,0)   trade_count_open,
   if(trade_status='1',total_balance, 0)  total_balance_open,
		   if(trade_status='1',total_credit, 0)  total_credit_open,
		if(payment_status='90+' and trade_status='1', total_balance,0) delinquencyBalance_open ,
		if(active_flag='Y' and trade_status='1',trade_count,0) active_trade_count_open,
		if(active_flag='Y' and trade_status='1',total_balance,0) active_total_balance_open,
 if(active_flag='Y' and trade_status='1',total_credit,0) active_total_credit_open
 
 
  from  pi2_development_db.trade_vintages_o r
   
  where  vintage_month between ${fromMonth} and ${toMonth}
  
  ) t
group by  fi_cat, vintage_month,   product_name  ,account_age
order by  fi_cat,product_name, vintage_month,   account_age;


--new defect 68

select  vintage_month, fi_cat,  product_name, account_age,
sum(delinquencyBalance)/sum(total_balance)*100 avg_delinquencyRate,
sum(total_balance) total_balance,
 
sum(delinquencyBalance_open)/sum(total_balance_open)*100 avg_delinquencyRate_open,
sum(total_balance_open) total_balance_open
from  (
    select   vintage_month,product_name,account_age,
        case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end fi_cat, 
         total_balance, 		if(payment_status='90+', total_balance,0) delinquencyBalance ,
		 if(trade_status='1',total_balance, 0)  total_balance_open,
		if(payment_status='90+' and trade_status='1', total_balance,0) delinquencyBalance_open 
 
  from  pi2_development_db.trade_vintages_n r
   
  where  vintage_month =201601
  and product_name='NCC'  
  ) t
  where fi_cat <>'Others'
group by  fi_cat, vintage_month,   product_name  ,account_age
order by  fi_cat,product_name, vintage_month,   account_age;
 
 
  
		 
 