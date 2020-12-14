--by month by Age , consider null value
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


--by risk consider null value
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
  else ts.ers_band end orig_ers_band,
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
case when   ts.ers_band is null then 'N/A'
  else ts.ers_band end  ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end   

  ) tb 
  group by year_month,vintage_month,   fi_cat, product_name ,orig_ers_band)

select  if(bmo.year_month is not null ,bmo.year_month,peer.year_month) year_month,
if(bmo.vintage_month is not null , bmo.vintage_month,peer.vintage_month) vintage_month,
if(bmo.fi_cat is not null,bmo.fi_cat,peer.fi_cat) fi_cat,
if(bmo.product_name is not null,bmo.product_name,peer.product_name) product_name,
 if(bmo.orig_ers_band is not null, bmo.orig_ers_band,peer.orig_ers_band) orig_ers_band,
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

peer.year_month,peer.vintage_month, peer.fi_cat,  peer.product_name, peer.orig_ers_band 
from (select * from source where source.fi_cat='BMO') bmo
full outer join ( select * from source where source.fi_cat='Peer')  peer
on bmo.year_month = peer.year_month 
and bmo.vintage_month=peer.vintage_month
and bmo.product_name=peer.product_name
and bmo.orig_ers_band=peer.orig_ers_band
 
order by bmo.year_month,bmo.vintage_month,   bmo.fi_cat, bmo.product_name ,bmo.orig_ers_band;


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
case when   ts.province is null then 'N/A'
  else ts.province end  ,
         case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
         end   

  ) tb 
  group by year_month,vintage_month,   fi_cat, product_name ,orig_province)

select  if(bmo.year_month is not null ,bmo.year_month,peer.year_month) year_month,
if(bmo.vintage_month is not null , bmo.vintage_month,peer.vintage_month) vintage_month,
if(bmo.fi_cat is not null,bmo.fi_cat,peer.fi_cat) fi_cat,
if(bmo.product_name is not null,bmo.product_name,peer.product_name) product_name,
 if(bmo.orig_province is not null, bmo.orig_province,peer.orig_province) orig_province,
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

peer.year_month,peer.vintage_month, peer.fi_cat,  peer.product_name, peer.orig_province 
from (select * from source where source.fi_cat='BMO') bmo
full outer join ( select * from source where source.fi_cat='Peer')  peer
on bmo.year_month = peer.year_month 
and bmo.vintage_month=peer.vintage_month
and bmo.product_name=peer.product_name
and bmo.orig_province=peer.orig_province
 
order by bmo.year_month,bmo.vintage_month,   bmo.fi_cat, bmo.product_name ,bmo.orig_province;