--same as PA_vintage chart 51-52
--vintage_month 201601-201606  ,PA_CohortMatrix_Bymonth_vintage_N.xlsx


 select  vintage_month, case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,product_name, account_age,ers_band ,  consumer_age_cat,
	  sum(if(payment_status='90+',total_balance,0))  delinquencyBalance,
		 sum(total_balance) total_balance,
		sum(trade_count) trade_count,
		  sum(total_credit)  total_credit   ,
		 
		 sum(if(active_flag='Y',total_balance,0)) activeBalance,
		 sum(if(active_flag='Y',trade_count,0))  activeTrade,
		  sum(if(active_flag='Y',total_credit,0))*100 activeCredit
		 
		 from trade_vintages_n  t
  where vintage_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  
group by vintage_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,product_name, account_age,ers_band ,  consumer_age_cat  
			  order by vintage_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,account_age,product_name, ers_band ,  consumer_age_cat ;
			  
			  
--by quarter


select   floor(vintage_month/100) vintage_year, ceiling(mod(vintage_month,100)/3) vintage_quarter,mod(vintage_month,100)+account_age - 3 *ceiling(mod(vintage_month,100)/3) quarter_age ,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,product_name, account_age,ers_band ,  consumer_age_cat,
	  sum(if(payment_status='90+',total_balance,0))  delinquencyBalance,
		 sum(total_balance) total_balance,
		sum(trade_count) trade_count,
		  sum(total_credit)  total_credit   ,
		 
		 sum(if(active_flag='Y',total_balance,0)) activeBalance,
		 sum(if(active_flag='Y',trade_count,0))  activeTrade,
		  sum(if(active_flag='Y',total_credit,0)) activeCredit
		 
		 from trade_vintages_n  t
  where vintage_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  
group by floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3), mod(vintage_month,100)+account_age,case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,product_name, account_age,ers_band ,  consumer_age_cat  
			  order by floor(vintage_month/100) , ceiling(mod(vintage_month,100)/3),  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,account_age,product_name, ers_band ,  consumer_age_cat ;
			  
			  
			  
--no need from pi2_trade_n table
with source as (
select t.pi2_product product, t.vintage_month,t.account_age ,s.ers_band,s.consumer_age_cat,
--chart 25 count
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P') count_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' ) count_PEER ,
sum(c.fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') count_active_BMO, 
sum(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y') count_active_PEER ,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P',balance,0))  balance_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P',balance,0)) balance_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0))  balance_deli_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and payment_status='90+',balance,0)) balance_deli_PEER,

sum(if(fi_name = "BANK OF MONTREAL" and t.joint_flag='P'  and active_flag='Y',balance,0))  balance_active_BMO,
sum(if(c.peer_id =3 and nvl(c.fi_name,'') <> "BANK OF MONTREAL" and t.joint_flag='P' and active_flag='Y' ,balance,0)) balance_active_PEER,
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
group by t.pi2_product,t.vintage_month,t.account_age,s.ers_band,s.consumer_age_cat )
select product,vintage_month,account_age,ers_band,consumer_age_cat,
--totalBalance
count_BMO,balance_BMO,
--average balance per account
if(count_BMO<>0,balance_BMO/count_BMO,null) avg_balance_BMO,
--average balance per active account
count_active_BMO,balance_active_BMO,if(count_active_BMO<>0,balance_active_BMO/count_active_BMO,null) avg_active_balance_BMO,
--utilization rate 
credit_limit_BMO,
if(credit_limit_BMO<>0,balance_BMO/credit_limit_BMO*100,null) uti_BMO,
--utilization active rate
credit_limit_active_BMO,
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
credit_limit_PEER,
if(credit_limit_PEER<>0,balance_PEER/credit_limit_PEER*100,null) uti_PEER,
--utilization active rate
credit_limit_active_PEER,
if(credit_limit_active_PEER<>0,balance_active_PEER/credit_limit_active_PEER*100,null) uti_active_PEER,
--delinquencyRate
balance_deli_PEER,if(balance_PEER<>0,balance_deli_PEER/balance_PEER*100,null) delinquencyBalanceRate

from source
order by product,vintage_month,account_age,ers_band,consumer_age_cat;


