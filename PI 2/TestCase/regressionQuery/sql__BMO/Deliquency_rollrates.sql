
----exclude rate 0, defect 48 , view by balance , the total value is not correct by risk 
--by month need to change table from trade_vintages_Q to trade_vintages_N
IMQA-43
 There has been change in requirements, We have changed labels as bellow

0 = New

1 = Current

2 = 30 Days

3 = 60 Days

4 = 90 Days

5 = 120+ Days

7, 8., 9 ratings have been combined and counted together as BadDebt

Since there is not roll back from BadDebt that line has been removed from the visual


--by age
with source as 
(  select  from_month,  fi_cat,product_name, consumer_age_cat ,  
		sum(rf_trades_ex01)/sum(trade_count)*100 rollForward_rate_eX01_byTrade,
		sum(rf_balance_ex01)/sum(total_balance)*100 rollForward_rate_eX01_byBalance 
        
from (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
         case  when from_rate='0' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
 
              else 0
         END rf_trades_ex01,
         case when from_rate='0' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
  
              else 0
         END rf_balance_ex01
   from TRADE_ROLLING_Q  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,consumer_age_cat  )
select BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.consumer_age_cat ,  
		BMO.rollForward_rate_eX01_byTrade,
		        (BMO.rollForward_rate_eX01_byTrade - PEER.rollForward_rate_eX01_byTrade  )*100 variance_to_peer_bps_trade, 
		BMO.rollForward_rate_eX01_byBalance,
 		(BMO.rollForward_rate_eX01_byBalance - PEER.rollForward_rate_eX01_byBalance)*100 variance_to_peer_bps_balance
from source BMO
join source PEER
on BMO.from_month=PEER.from_month 
and BMO.product_name=PEER.product_name
and BMO.consumer_age_cat=PEER.consumer_age_cat
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
order by BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.consumer_age_cat;

--by quarter defect 43

--by quarter by risk
with source as 
(  select  from_month,  fi_cat,product_name, ers_band ,  
		sum(rf_trades_ex01)/sum(trade_count)*100 rollForward_rate_eX01_byTrade,
		sum(rf_balance_ex01)/sum(total_balance)*100 rollForward_rate_eX01_byBalance 
        
from (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
         case  when from_rate='0' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
 
              else 0
         END rf_trades_ex01,
         case when from_rate='0' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
  
              else 0
         END rf_balance_ex01
   from TRADE_ROLLING_Q  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,ers_band  )
select BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.ers_band ,  
		BMO.rollForward_rate_eX01_byTrade,
		(BMO.rollForward_rate_eX01_byTrade - PEER.rollForward_rate_eX01_byTrade)*100   variance_to_peer_bps_trade ,
		BMO.rollForward_rate_eX01_byBalance,

		(BMO.rollForward_rate_eX01_byBalance - PEER.rollForward_rate_eX01_byBalance)*100 variance_to_peer_bps_balance
from source BMO
join source PEER
on BMO.from_month=PEER.from_month
and BMO.product_name=PEER.product_name
and BMO.ers_band=PEER.ers_band
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
order by BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.ers_band;

--by region

with source as 
(  select  from_month,  fi_cat,product_name, province ,  
		sum(rf_trades_ex01)/sum(trade_count)*100 rollForward_rate_eX01_byTrade,
		sum(rf_balance_ex01)/sum(total_balance)*100 rollForward_rate_eX01_byBalance 
        
from (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
         case  when from_rate='0' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
 
              else 0
         END rf_trades_ex01,
         case when from_rate='0' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
  
              else 0
         END rf_balance_ex01
   from TRADE_ROLLING_Q  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,province  )
select BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.province ,  
		BMO.rollForward_rate_eX01_byTrade,
		(BMO.rollForward_rate_eX01_byTrade - PEER.rollForward_rate_eX01_byTrade)*100   variance_to_peer_bps_trade ,
		BMO.rollForward_rate_eX01_byBalance,

		(BMO.rollForward_rate_eX01_byBalance - PEER.rollForward_rate_eX01_byBalance)*100 variance_to_peer_bps_balance
from source BMO
join source PEER
on BMO.from_month=PEER.from_month
and BMO.product_name=PEER.product_name
and BMO.province=PEER.province
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
order by BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.province;
   
         
 


-- chart 75 by quarter
--by month , should change table to trade_rolling_n , and 201601-201801

--201603-201803
with source as 
(  select  from_month,  fi_cat,product_name,  sum(trade_count) trade_count, from_rate_n from_rate,
         sum(rolled_to_0) rolled_to_0, sum(rolled_to_1) rolled_to_1, sum(rolled_to_2) rolled_to_2,
         sum(rolled_to_3) rolled_to_3, sum(rolled_to_4) rolled_to_4, sum(rolled_to_5) rolled_to_5,
         -- sum(rolled_to_7) rolled_to_7, sum(rolled_to_8) rolled_to_8, sum(rolled_to_9) rolled_to_9,
         sum(rolled_to_7 + rolled_to_8 + rolled_to_9) rolled_to_bd,
         sum(total_balance) total_balance, sum(bal_rolled_to_0) bal_rolled_to_0, sum(bal_rolled_to_1) bal_rolled_to_1, sum(bal_rolled_to_2) bal_rolled_to_2, sum(bal_rolled_to_3) bal_rolled_to_3,
         sum(bal_rolled_to_4) bal_rolled_to_4, sum(bal_rolled_to_5) bal_rolled_to_5,
         -- sum(bal_rolled_to_7) bal_rolled_to_7, sum(bal_rolled_to_8) bal_rolled_to_8, sum(bal_rolled_to_9) bal_rolled_to_9,
         sum(bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9) bal_rolled_to_bd
        
from (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
                                             end  fi_cat, 
         case  when from_rate in ('7', '8', '9') then 'BD' else from_rate end from_rate_n 
   from TRADE_ROLLING_Q  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,from_rate_n  )
select from_month,  fi_cat ,product_name,from_rate ,
                             rolled_to_0/trade_count*100 new_trade,
                             rolled_to_1/trade_count*100 current_trade,
                             rolled_to_2/trade_count*100 30Days_trade,
                             rolled_to_3/trade_count*100 60Days_trade,
                             rolled_to_4/trade_count*100 90Days_trade,
                             rolled_to_5/trade_count*100 120Days_trade,
                             rolled_to_bd/trade_count*100   badDebt__trade,
                               bal_rolled_to_0/total_balance*100 new_balance,
                             bal_rolled_to_1/total_balance*100 current_balance,
                             bal_rolled_to_2/total_balance*100 30Days_balance,
                             bal_rolled_to_3/total_balance*100 60Days_balance,
                             bal_rolled_to_4/total_balance*100 90Days_balance,
                             bal_rolled_to_5/total_balance*100 120Days_balance,
                             bal_rolled_to_bd/total_balance*100 BadDebt_balance
from source 
order by from_month,fi_cat,product_name,from_rate;
