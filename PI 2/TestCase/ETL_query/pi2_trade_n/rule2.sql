select distinct delinquency_cat
from pi2_trade_n;

select consumer_key, vintage_month, payment_amt,trade_key,delinquency_cat,
 case when rate in ('5', '8', '9')
            OR narr_code1   in ( '11','12','13','14','17','22','32','36','43','46','48','51','56','74','79','92', 'A4','B2','B3','D1','D2','D3','D6','G6')
            OR narr_code2   in ( '11','12','13','14','17','22','32','36','43','46','48','51','56','74','79','92', 'A4','B2','B3','D1','D2','D3','D6','G6')
        then 'BadDebt'
        when rate = '4' then '90Days'
        when rate = '3' then '60Days'
        when rate = '2' then '30Days'
        else 'Current'
  end delinquency_cat_cal
  from pi2_trade_n
  where delinquency_cat<>delinquency_cat_cal;  --0
  
   select count(*) from 
(select consumer_key, vintage_month, payment_amt,trade_key,delinquency_cat,
 case when rate in ('5', '8', '9')
            OR narr_code1   in ( '11','12','13','14','17','22','32','36','43','46','48','51','56','74','79','92', 'A4','B2','B3','D1','D2','D3','D6','G6')
            OR narr_code2   in ( '11','12','13','14','17','22','32','36','43','46','48','51','56','74','79','92', 'A4','B2','B3','D1','D2','D3','D6','G6')
        then 'BadDebt'
        when rate = '4' then '90Days'
        when rate = '3' then '60Days'
        when rate = '2' then '30Days'
        else 'Current'
  end delinquency_cat_cal
  from pi2_trade_n)  source
  where delinquency_cat=delinquency_cat_cal;  --16633482793
  
  select count(*)  
 
  from pi2_trade_n ; --16633482793