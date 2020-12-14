with source as (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
         case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance,
		 
		case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='3' then rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='4' then rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='5' then if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
              else 0
         END rf_notDerog_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='4' then bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='5' then if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              else 0
         END rf_notDerog_balance,
		 
		 
		 
         case  when from_rate='0' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades_ex01,
         case when from_rate='0' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance_ex01,
         case
              when from_rate='0' then 0
              when from_rate='1' then rolled_to_0
              when from_rate='2' then rolled_to_0 + rolled_to_1
              when from_rate='3' then rolled_to_0 + rolled_to_1 + rolled_to_2
              when from_rate='4' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3
              when from_rate='5' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4
              -- when from_rate='7' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5
              -- when from_rate='8' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7
              -- when from_rate='9' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8
              when from_rate in ('7', '8', '9') then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5
              else 0
         END rb_trades,
                 case
              when from_rate='0' then 0
              when from_rate='1' then bal_rolled_to_0
              when from_rate='2' then bal_rolled_to_0 + bal_rolled_to_1
              when from_rate='3' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2
              when from_rate='4' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3
              when from_rate='5' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4
              -- when from_rate='7' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5
              -- when from_rate='8' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7
              --when from_rate='9' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8
              when from_rate in ('7', '8', '9') then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7
              else 0
        END rb_balance
  from TRADE_ROLLING_N  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )
)
select  from_month,  fi_cat,product_name, province,  
        
         sum(trade_count) trade_count,  
         sum(total_balance) total_balance,  
         sum(rf_trades) rf_trades, sum(rf_balance) rf_balance, sum(rb_trades) rb_trades, sum(rb_balance) rb_balance, 
         sum(rf_trades_ex01) rf_trades_ex01, sum(rf_balance_ex01) rf_balance_ex01 ,
		 
		 sum(rf_notDerog_balance) rf_notDerog_balance,
		 sum(rf_notDerog_trades) rf_notDerog_trades
from  source
group by from_month,  fi_cat ,product_name,province;



with source as (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
         case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance,
		 
		case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='3' then rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='4' then rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='5' then if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
              else 0
         END rf_notDerog_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='4' then bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='5' then if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              else 0
         END rf_notDerog_balance,
		 
		 
		 
         case  when from_rate='0' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades_ex01,
         case when from_rate='0' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance_ex01,
         case
              when from_rate='0' then 0
              when from_rate='1' then rolled_to_0
              when from_rate='2' then rolled_to_0 + rolled_to_1
              when from_rate='3' then rolled_to_0 + rolled_to_1 + rolled_to_2
              when from_rate='4' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3
              when from_rate='5' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4
              -- when from_rate='7' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5
              -- when from_rate='8' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7
              -- when from_rate='9' then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8
              when from_rate in ('7', '8', '9') then rolled_to_0 + rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5
              else 0
         END rb_trades,
                 case
              when from_rate='0' then 0
              when from_rate='1' then bal_rolled_to_0
              when from_rate='2' then bal_rolled_to_0 + bal_rolled_to_1
              when from_rate='3' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2
              when from_rate='4' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3
              when from_rate='5' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4
              -- when from_rate='7' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5
              -- when from_rate='8' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7
              --when from_rate='9' then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8
              when from_rate in ('7', '8', '9') then bal_rolled_to_0 + bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7
              else 0
        END rb_balance
  from TRADE_ROLLING_N  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )
)
select  from_month,  fi_cat,product_name, province,  
        
         sum(trade_count) trade_count,  
         sum(total_balance) total_balance,  
         sum(rf_trades) rf_trades, sum(rf_balance) rf_balance, sum(rb_trades) rb_trades, sum(rb_balance) rb_balance, 
         sum(rf_trades_ex01) rf_trades_ex01, sum(rf_balance_ex01) rf_balance_ex01 ,
		 
		 sum(rf_notDerog_balance) rf_notDerog_balance,
		 sum(rf_notDerog_trades) rf_notDerog_trades
from  source
group by from_month,  fi_cat ,product_name,province;


--by age

with source as (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
         case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance,
		 
		case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='3' then rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='4' then rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='5' then if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
              else 0
         END rf_notDerog_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='4' then bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='5' then if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              else 0
         END rf_notDerog_balance,

         case  when from_rate='0' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades_ex01,
         case when from_rate='0' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance_ex01
   from TRADE_ROLLING_N  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )
)
select  from_month,  fi_cat,product_name, consumer_age_cat ,  
		sum(rf_trades_ex01)/sum(trade_count)*100 rollForward_rate_eX01_byTrade,
		sum(rf_balance_ex01)/sum(total_balance) rollForward_rate_eX01_byBalance,
        sum(rf_notDerog_trades)/sum(trade_count)*100 rollForward_rate_notDerog_byTrade,
		sum(rf_notDerog_balance)/sum(total_balance) rollForward_rate_notDerog_byBalance,
         sum(trade_count) trade_count,  
         sum(total_balance) total_balance,  
         sum(rf_trades) rf_trades, sum(rf_balance) rf_balance,  
         sum(rf_trades_ex01) rf_trades_ex01, sum(rf_balance_ex01) rf_balance_ex01 ,
		 
		 sum(rf_notDerog_balance) rf_notDerog_balance,
		 sum(rf_notDerog_trades) rf_notDerog_trades
from  source
group by from_month,  fi_cat ,product_name,consumer_age_cat ;

----exclude rate 0, defect 48 , view by balance , the total value is not correct.

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
   from TRADE_ROLLING_N  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,ers_band  )
select BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.ers_band ,  
		BMO.rollForward_rate_eX01_byTrade,
		BMO.rollForward_rate_eX01_byBalance,
         BMO.rollForward_rate_eX01_byTrade - PEER.rollForward_rate_eX01_byTrade   ,
		BMO.rollForward_rate_eX01_byBalance - PEER.rollForward_rate_eX01_byBalance
from source BMO
join source PEER
on BMO.from_month=PEER.from_month
and BMO.product_name=PEER.product_name
and BMO.ers_band=PEER.ers_band
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
order by BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.ers_band;


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
   from TRADE_ROLLING_N  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,consumer_age_cat  )
select BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.consumer_age_cat ,  
		BMO.rollForward_rate_eX01_byTrade,
		BMO.rollForward_rate_eX01_byBalance,
         BMO.rollForward_rate_eX01_byTrade - PEER.rollForward_rate_eX01_byTrade   ,
		BMO.rollForward_rate_eX01_byBalance - PEER.rollForward_rate_eX01_byBalance
from source BMO
join source PEER
on BMO.from_month=PEER.from_month 
and BMO.product_name=PEER.product_name
and BMO.consumer_age_cat=PEER.consumer_age_cat
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
order by BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.consumer_age_cat;

--by quarter

with source as 
(  select  from_month,  fi_cat,product_name, ers_band ,  
		sum(rf_trades)/sum(trade_count)*100 rollForward_rate_byTrade,
		sum(rf_balance)/sum(total_balance)*100 rollForward_rate_byBalance  
    
        
from (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
  case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              else 0
         END rf_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
               else 0
         END rf_balance
from TRADE_ROLLING_Q  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,ers_band  )
select BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.ers_band ,  
		  BMO.rollForward_rate_byTrade,
		  BMO.rollForward_rate_byBalance,
		  BMO.rollForward_rate_byTrade   - PEER.rollForward_rate_byTrade,
		  BMO.rollForward_rate_byBalance - PEER.rollForward_rate_byBalance
from source BMO
join source PEER
on BMO.from_month=PEER.from_month 
and BMO.product_name=PEER.product_name
and BMO.ers_band=PEER.ers_band
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
order by BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.ers_band;



with source as 
(  select  from_month,  fi_cat,product_name, province ,  
		sum(rf_trades_ex01)/sum(trade_count)*100 rollForward_rate_eX01_byTrade,
		sum(rf_balance_ex01)/sum(total_balance)*100 rollForward_rate_eX01_byBalance ,
		sum(rf_trades)/sum(trade_count)*100 rollForward_rate_byTrade,
		sum(rf_balance)/sum(total_balance)*100 rollForward_rate_byBalance,
        sum(rf_notDerog_trades)/sum(trade_count)*100 rollForward_rate_notDerog_byTrade,
		sum(rf_notDerog_balance)/sum(total_balance)*100 rollForward_rate_notDerog_byBalance,
         sum(trade_count) trade_count,  
         sum(total_balance) total_balance,  
         sum(rf_trades) rf_trades, sum(rf_balance) rf_balance,  
         sum(rf_trades_ex01) rf_trades_ex01, sum(rf_balance_ex01) rf_balance_ex01 ,
		 
		 sum(rf_notDerog_balance) rf_notDerog_balance,
		 sum(rf_notDerog_trades) rf_notDerog_trades
        
from (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
  case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance,
		 
		case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='3' then rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='4' then rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='5' then if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
              else 0
         END rf_notDerog_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='4' then bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='5' then if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              else 0
         END rf_notDerog_balance,

         case  when from_rate='0' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades_ex01,
         case when from_rate='0' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance_ex01
   from TRADE_ROLLING_Q  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,province  )
select BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.province ,  
		  BMO.rollForward_rate_byTrade,
		  BMO.rollForward_rate_byBalance,
		  BMO.rollForward_rate_byTrade   - PEER.rollForward_rate_byTrade,
		  BMO.rollForward_rate_byBalance - PEER.rollForward_rate_byBalance,
		BMO.rollForward_rate_eX01_byTrade,
		BMO.rollForward_rate_eX01_byBalance,
         BMO.rollForward_rate_eX01_byTrade - PEER.rollForward_rate_eX01_byTrade   ,
		BMO.rollForward_rate_eX01_byBalance - PEER.rollForward_rate_eX01_byBalance,
		
		  BMO.trade_count,

          BMO.rollForward_rate_notDerog_byTrade,
		  BMO.rollForward_rate_notDerog_byBalance,
          BMO.trade_count,  
          BMO.total_balance,  
          BMO.rf_trades,  
		  BMO.rf_balance,  
          BMO.rf_trades_ex01,   
		  BMO.rf_balance_ex01 ,
		  BMO.rf_notDerog_balance,
		  BMO.rf_notDerog_trades
		
from source BMO
join source PEER
on BMO.from_month=PEER.from_month 
and BMO.product_name=PEER.product_name
and BMO.province=PEER.province
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
order by BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.province;
         
         
         
with source as 
(  select  from_month,  fi_cat,product_name, ers_band ,  
		sum(rf_trades_ex01)/sum(trade_count)*100 rollForward_rate_eX01_byTrade,
		sum(rf_balance_ex01)/sum(total_balance)*100 rollForward_rate_eX01_byBalance ,
		sum(rf_trades)/sum(trade_count)*100 rollForward_rate_byTrade,
		sum(rf_balance)/sum(total_balance)*100 rollForward_rate_byBalance,
        sum(rf_notDerog_trades)/sum(trade_count)*100 rollForward_rate_notDerog_byTrade,
		sum(rf_notDerog_balance)/sum(total_balance)*100 rollForward_rate_notDerog_byBalance,
         sum(trade_count) trade_count,  
         sum(total_balance) total_balance,  
         sum(rf_trades) rf_trades, sum(rf_balance) rf_balance,  
         sum(rf_trades_ex01) rf_trades_ex01, sum(rf_balance_ex01) rf_balance_ex01 ,
		 
		 sum(rf_notDerog_balance) rf_notDerog_balance,
		 sum(rf_notDerog_trades) rf_notDerog_trades
        
from (
  select t.*,  case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat, 
         
  case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance,
		 
		case  when from_rate='0' then rolled_to_1 + rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='3' then rolled_to_4 + rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='4' then rolled_to_5 + if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
               when from_rate='5' then if(rolled_from_status='3',0,rolled_to_7) + if(rolled_from_status='3',0,rolled_to_8) + if(rolled_from_status='3',0,rolled_to_9)
              else 0
         END rf_notDerog_trades,
         case when from_rate='0' then bal_rolled_to_1 + bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='4' then bal_rolled_to_5 + if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              when from_rate='5' then if(rolled_from_status='3',0,bal_rolled_to_7) + if(rolled_from_status='3',0,bal_rolled_to_8) + if(rolled_from_status='3',0,bal_rolled_to_9)
              else 0
         END rf_notDerog_balance,

         case  when from_rate='0' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='1' then rolled_to_2 + rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='2' then rolled_to_3 + rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='3' then rolled_to_4 + rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='4' then rolled_to_5 + rolled_to_7 + rolled_to_8 + rolled_to_9
               when from_rate='5' then rolled_to_7 + rolled_to_8 + rolled_to_9
              -- when from_rate='7' then rolled_to_8 + rolled_to_9
              -- when from_rate='8' then rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_trades_ex01,
         case when from_rate='0' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='1' then bal_rolled_to_2 + bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='2' then bal_rolled_to_3 + bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='3' then bal_rolled_to_4 + bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='4' then bal_rolled_to_5 + bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              when from_rate='5' then bal_rolled_to_7 + bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='7' then bal_rolled_to_8 + bal_rolled_to_9
              -- when from_rate='8' then bal_rolled_to_9
              -- when from_rate='9' then 0
              else 0
         END rf_balance_ex01
   from TRADE_ROLLING_Q  t
  where year_month between ${pStart_YearMonth} and ${pEnd_YearMonth}
  and ((rolled_from_status= '1' or rolled_from_status='3')  )) a 
group by from_month,  fi_cat ,product_name,ers_band  )
select BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.ers_band ,  
		  BMO.rollForward_rate_byTrade,
		  BMO.rollForward_rate_byBalance,
		  BMO.rollForward_rate_byTrade   - PEER.rollForward_rate_byTrade,
		  BMO.rollForward_rate_byBalance - PEER.rollForward_rate_byBalance,
		BMO.rollForward_rate_eX01_byTrade,
		BMO.rollForward_rate_eX01_byBalance,
         BMO.rollForward_rate_eX01_byTrade - PEER.rollForward_rate_eX01_byTrade   ,
		BMO.rollForward_rate_eX01_byBalance - PEER.rollForward_rate_eX01_byBalance,
		
		  BMO.trade_count,

          BMO.rollForward_rate_notDerog_byTrade,
		  BMO.rollForward_rate_notDerog_byBalance,
          BMO.trade_count,  
          BMO.total_balance,  
          BMO.rf_trades,  
		  BMO.rf_balance,  
          BMO.rf_trades_ex01,   
		  BMO.rf_balance_ex01 ,
		  BMO.rf_notDerog_balance,
		  BMO.rf_notDerog_trades
		
from source BMO
join source PEER
on BMO.from_month=PEER.from_month 
and BMO.product_name=PEER.product_name
and BMO.ers_band=PEER.ers_band
where BMO.fi_cat='BMO'
and PEER.fi_cat='Peer'
order by BMO.from_month,  BMO.fi_cat,BMO.product_name, BMO.ers_band;


-- chart 75 by quarter

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
