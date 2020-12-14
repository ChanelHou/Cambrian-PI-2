--same as PA_vintage chart 51-52
--vintage_month 201601-201606  ,PA_CohortMatrix_Bymonth_vintage_N.xlsx




select * 
from 
 (select  vintage_month, case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,product_name, account_age,orig_ers_band ,  orig_province,
	  sum(if(payment_status='90+',total_balance,0))  delinquencyBalance,
		 sum(total_balance) total_balance,
		sum(trade_count) trade_count,
		  sum(total_credit)  total_credit   ,
		 
		 sum(if(active_flag='Y',total_balance,0)) activeBalance,
		 sum(if(active_flag='Y',trade_count,0))  activeTrade,
		  sum(if(active_flag='Y',total_credit,0))  activeCredit
		 
		 from trade_vintages_o  t
  where vintage_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and account_age between  ${MOB1} and  ${MOB2}
  
group by vintage_month,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,product_name, account_age,orig_ers_band ,  orig_province  
			   ) a 
where fi_cat <>'Other';
			  
			  
--by quarter

select * from (
select   concat(cast (floor(vintage_month/100) as string),"Q", cast(ceiling(mod(vintage_month,100)/3) as string)) vintage_quarter,
mod(vintage_month,100)+account_age - 3 *ceiling(mod(vintage_month,100)/3) quarter_age ,
case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end fi_cat,product_name, account_age,orig_ers_band ,  orig_province,
	  sum(if(payment_status='90+',total_balance,0))  delinquencyBalance,
		 sum(total_balance) total_balance,
		sum(trade_count) trade_count,
		  sum(total_credit)  total_credit   ,
		 
		 sum(if(active_flag='Y',total_balance,0)) activeBalance,
		 sum(if(active_flag='Y',trade_count,0))  activeTrade,
		  sum(if(active_flag='Y',total_credit,0)) activeCredit
		 
		 from trade_vintages_o  t
  where vintage_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
 
group by concat(cast (floor(vintage_month/100) as string),"Q", cast(ceiling(mod(vintage_month,100)/3) as string)), mod(vintage_month,100)+account_age - 3 *ceiling(mod(vintage_month,100)/3),case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end ,product_name, account_age,orig_ers_band ,  orig_province  
			 ) a
where fi_cat <>'Other'		
and quarter_age between ${age1} and ${age2}	  ;


 


 
 

