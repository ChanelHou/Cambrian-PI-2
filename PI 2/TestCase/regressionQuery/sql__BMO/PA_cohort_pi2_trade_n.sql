 
--by month
with source as (
select t.pi2_product product_name, t.vintage_month,t.account_age ,ts.ers_band orig_ers_band,ts.province orig_province,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
			  
			   sum(if(payment_status='90+',t.balance,0))  delinquencyBalance,
		 sum(t.balance) total_balance,
		count(1) trade_count,
		  sum(t.credit_limit)  total_credit   ,
		 
		 sum(if(active_flag='Y', t.balance,0)) activeBalance,
		 sum(if(active_flag='Y',1,0))  activeTrade,
		  sum(if(active_flag='Y',t.credit_limit,0))  activeCredit
   from pi2_development_db.pi2_trade_n t

left join (
  select fi_name, fi_id, year_month, peer_id
  from pi2_development_db.pi2_customer_n 
 
) c
on t.fi_id = c.fi_id
and  c.year_month = greatest( 201609, t.year_month)

left join(
 select consumer_key, ers_band, ers_score, consumer_age, province,  year_month,  
        row_number() over (partition by year_month, consumer_key order by ers_score desc, consumer_age desc) rn_ts
 from pi2_development_db.pi2_consumer_n

) ts
on ts.consumer_key = t.consumer_key
and ts.year_month = t.vintage_month
and ts.rn_Ts = 1
where 
 t.vintage_month between ${fromMonth} and ${toMonth}
 and t.joint_flag='P'
 and account_age between  ${MOB1} and  ${MOB2}
group by t.pi2_product,t.vintage_month,t.account_age,ts.ers_band,ts.province ,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end)
select * from source 
where fi_cat <>'Other';

--by quarter
with source as (
select t.pi2_product product_name, ts.ers_band orig_ers_band,ts.province orig_province,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,
			  concat(cast (floor(vintage_month/100) as string),"Q", cast(ceiling(mod(vintage_month,100)/3) as string)) vintage_quarter,
mod(vintage_month,100)+account_age - 3 *ceiling(mod(vintage_month,100)/3) quarter_age ,account_age,
			   sum(if(payment_status='90+',t.balance,0))  delinquencyBalance,
		 sum(t.balance) total_balance,
		count(1) trade_count,
		  sum(t.credit_limit)  total_credit   ,
		 
		 sum(if(active_flag='Y', t.balance,0)) activeBalance,
		 sum(if(active_flag='Y',1,0))  activeTrade,
		  sum(if(active_flag='Y',t.credit_limit,0))  activeCredit
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
where 
 t.vintage_month between ${fromMonth} and ${toMonth}
 and t.joint_flag='P'
 and account_age BETWEEN ${m1} AND ${m2}
group by t.pi2_product, ts.ers_band,ts.province ,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'  end,
concat(cast (floor(vintage_month/100) as string),"Q", cast(ceiling(mod(vintage_month,100)/3) as string)), 
mod(vintage_month,100)+account_age - 3 *ceiling(mod(vintage_month,100)/3),account_age )
select * from source 
where fi_cat <>'Other';

