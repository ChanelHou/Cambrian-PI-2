 with source as 
(  select  from_month,  fi_cat,product_name, consumer_age_cat ,  
		sum(rf_trades_ex01)/sum(trade_count)*100 rollForward_rate_eX01_byTrade,
		sum(rf_balance_ex01)/sum(total_balance)*100 rollForward_rate_eX01_byBalance 
        
from (
 
 select rolling.*,           
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
 from (  
  
select p1.year_month from_month, p2.year_month to_month,p1.province, p1.ers_band, p1.consumer_age_cat, 
      case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat,  p1.product_name ,
       cast(count(*) as int) trade_count, p1.rate from_rate,
       cast(sum(case when p2.rate = '0' then 1 else 0 end) as int) rolled_to_0,
       cast(sum(case when p2.rate = '1' then 1 else 0 end) as int) rolled_to_1,
       cast(sum(case when p2.rate = '2' then 1 else 0 end) as int) rolled_to_2,
       cast(sum(case when p2.rate = '3' then 1 else 0 end) as int) rolled_to_3,
       cast(sum(case when p2.rate = '4' then 1 else 0 end) as int) rolled_to_4,
       cast(sum(case when p2.rate = '5' then 1 else 0 end) as int) rolled_to_5,
       cast(sum(case when p2.rate = '7' then 1 else 0 end) as int) rolled_to_7,
       cast(sum(case when p2.rate = '8' then 1 else 0 end) as int) rolled_to_8,
       cast(sum(case when p2.rate = '9' then 1 else 0 end) as int) rolled_to_9, 
       sum(p1.balance) total_balance,
       sum(case when p2.rate = '0' then p1.balance else 0 end) bal_rolled_to_0,
       sum(case when p2.rate = '1' then p1.balance else 0 end) bal_rolled_to_1,
       sum(case when p2.rate = '2' then p1.balance else 0 end) bal_rolled_to_2,
       sum(case when p2.rate = '3' then p1.balance else 0 end) bal_rolled_to_3,
       sum(case when p2.rate = '4' then p1.balance else 0 end) bal_rolled_to_4,
       sum(case when p2.rate = '5' then p1.balance else 0 end) bal_rolled_to_5,
       sum(case when p2.rate = '7' then p1.balance else 0 end) bal_rolled_to_7,
       sum(case when p2.rate = '8' then p1.balance else 0 end) bal_rolled_to_8,
       sum(case when p2.rate = '9' then p1.balance else 0 end) bal_rolled_to_9,
       p1.trade_status rolled_from_status, 
       p2.trade_status rolled_to_status,   
       cast(sum(case when p1.rate  in ('7', '8', '9') then 1 else 0 end) as int) rolled_from_7plus, 
       cast(sum(case when p2.rate  in ('7', '8', '9') then 1 else 0 end) as int) rolled_to_7plus, 
       sum(case when p1.rate in ('7', '8', '9') then p1.balance else 0 end) bal_rolled_from_7plus,
       sum(case when p2.rate in ('7', '8', '9') then p1.balance else 0 end) bal_rolled_to_7plus,
       p1.year_month
	   
from 

(select t.year_month, t.trade_key, t.rate, t.balance, t.trade_status, pi2_product product_name, c.province, c.ers_band, c.consumer_age_cat, 
         case when cu.fi_name is null then 'Other' else cu.fi_name end fi_name,
         case when cu.peer_id is null then 13 else cu.peer_id end peer_id
  from pi2_development_db.pi2_trade_n t
  left join pi2_development_db.pi2_customer_n cu
  
  
  on cu.fi_id =t.fi_id
  and cu.year_month = greatest( 201609, t.year_month)  
  join pi2_development_db.pi2_consumer_n c
  on c.year_month = t.year_month
  and c.consumer_key = t.consumer_key
  where c.year_month = t.year_month
  and joint_flag = 'P'
  and trade_status = '1'
  and t.year_month between ${Month1} and ${Month2}) p1 
 join
 
(select t.year_month, t.trade_key, t.rate, t.balance, t.trade_status
  from pi2_development_db.pi2_trade_n t
  where  joint_flag = 'P') p2
 
on p2.trade_key = p1.trade_key
and p2.year_month = if(mod(p1.year_month,100) = 12 , (floor(p1.year_month/100)+ 1)* 100 + 1 , p1.year_month+ 1)

group by p1.year_month, p2.year_month, p1.province, p1.ers_band, p1.consumer_age_cat, case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   ,  p1.product_name, p1.rate, p1.trade_status, p2.trade_status ) rolling 
			  
where fi_cat <>'Other' 			  
) a
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


--hive
 with source as 
(  select  from_month,  fi_cat,product_name, consumer_age_cat ,  
		sum(rf_trades_ex01)/sum(trade_count)*100 rollForward_rate_eX01_byTrade,
		sum(rf_balance_ex01)/sum(total_balance)*100 rollForward_rate_eX01_byBalance 
        
from (
 
 select rolling.*,           
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
 from (  
  
select p1.year_month from_month, p2.year_month to_month,p1.province, p1.ers_band, p1.consumer_age_cat, 
      case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end  fi_cat,  p1.product_name ,
       cast(count(*) as int) trade_count, p1.rate from_rate,
       cast(sum(case when p2.rate = '0' then 1 else 0 end) as int) rolled_to_0,
       cast(sum(case when p2.rate = '1' then 1 else 0 end) as int) rolled_to_1,
       cast(sum(case when p2.rate = '2' then 1 else 0 end) as int) rolled_to_2,
       cast(sum(case when p2.rate = '3' then 1 else 0 end) as int) rolled_to_3,
       cast(sum(case when p2.rate = '4' then 1 else 0 end) as int) rolled_to_4,
       cast(sum(case when p2.rate = '5' then 1 else 0 end) as int) rolled_to_5,
       cast(sum(case when p2.rate = '7' then 1 else 0 end) as int) rolled_to_7,
       cast(sum(case when p2.rate = '8' then 1 else 0 end) as int) rolled_to_8,
       cast(sum(case when p2.rate = '9' then 1 else 0 end) as int) rolled_to_9, 
       sum(p1.balance) total_balance,
       sum(case when p2.rate = '0' then p1.balance else 0 end) bal_rolled_to_0,
       sum(case when p2.rate = '1' then p1.balance else 0 end) bal_rolled_to_1,
       sum(case when p2.rate = '2' then p1.balance else 0 end) bal_rolled_to_2,
       sum(case when p2.rate = '3' then p1.balance else 0 end) bal_rolled_to_3,
       sum(case when p2.rate = '4' then p1.balance else 0 end) bal_rolled_to_4,
       sum(case when p2.rate = '5' then p1.balance else 0 end) bal_rolled_to_5,
       sum(case when p2.rate = '7' then p1.balance else 0 end) bal_rolled_to_7,
       sum(case when p2.rate = '8' then p1.balance else 0 end) bal_rolled_to_8,
       sum(case when p2.rate = '9' then p1.balance else 0 end) bal_rolled_to_9,
       p1.trade_status rolled_from_status, 
       p2.trade_status rolled_to_status,   
       cast(sum(case when p1.rate  in ('7', '8', '9') then 1 else 0 end) as int) rolled_from_7plus, 
       cast(sum(case when p2.rate  in ('7', '8', '9') then 1 else 0 end) as int) rolled_to_7plus, 
       sum(case when p1.rate in ('7', '8', '9') then p1.balance else 0 end) bal_rolled_from_7plus,
       sum(case when p2.rate in ('7', '8', '9') then p1.balance else 0 end) bal_rolled_to_7plus,
       p1.year_month
	   
from 

(select t.year_month, t.trade_key, t.rate, t.balance, t.trade_status, pi2_product product_name, c.province, c.ers_band, c.consumer_age_cat, 
         case when cu.fi_name is null then 'Other' else cu.fi_name end fi_name,
         case when cu.peer_id is null then 13 else cu.peer_id end peer_id
  from pi2_development_db.pi2_trade_n t
  left join pi2_development_db.pi2_customer_n cu
  on cu.fi_id =t.fi_id
  and cu.year_month =  201609  
  join pi2_development_db.pi2_consumer_n c
  on c.year_month = t.year_month
  and c.consumer_key = t.consumer_key
  where c.year_month = t.year_month
  and joint_flag = 'P'
  and trade_status = '1'
  and t.year_month between ${Month1} and ${Month2}) p1 
 join
 
(select t.year_month, t.trade_key, t.rate, t.balance, t.trade_status
  from pi2_development_db.pi2_trade_n t
  where  joint_flag = 'P') p2
 
on p2.trade_key = p1.trade_key
and p2.year_month = if(p1.year_month%100 = 12 , (floor(p1.year_month/100)+ 1)* 100 + 1 , p1.year_month+ 1)

group by p1.year_month, p2.year_month, p1.province, p1.ers_band, p1.consumer_age_cat, case when fi_name = "BANK OF MONTREAL" then "BMO"
              when  peer_id =3 then 'Peer'
              else 'Other'
			  end   ,  p1.product_name, p1.rate, p1.trade_status, p2.trade_status ) rolling 
			  
where fi_cat <>'Other' 			  
) a
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


			  
 

			  
 