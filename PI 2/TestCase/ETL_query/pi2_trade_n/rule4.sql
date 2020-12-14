select count(*) from (
select trade_key,consumer_key, vintage_month,  narr_code1,narr_code2,type,balance,last_active_age,
status,
 case when rate IN ('7', '8', '9')  
            OR ( narr_code1 IN ('11', '12', '36', '42', '47', '86') or 
                 narr_code2 IN ('11', '12', '36', '42', '47', '86')
               )
            OR ( (narr_code1 IN ('22', '59', '90', 'A1' , 'A2') or 
                  narr_code2 IN ('22', '59', '90', 'A1' , 'A2')
                 ) 
                 and last_active_age > 12
               )
       then 'W'
       when (narr_code1 IN('22', '59', '90', 'A1', 'A2') or 
             narr_code2 IN('22', '59', '90', 'A1', 'A2')
            ) 
            and last_active_age < 13
       then 'S'
       when (narr_code1 IN( '01', '02', '13', '14', '20', '25', '28', '29', '32', '33', '41', '58', '60', '92', '95', 'A4', 'B2', 'B3', 'D3', 'D6', 'F8') or
             narr_code2 IN( '01', '02', '13', '14', '20', '25', '28', '29', '32', '33', '41', '58', '60', '92', '95', 'A4', 'B2', 'B3', 'D3', 'D6', 'F8')
            )
            OR (balance = 0 and type IN('M', 'I') )
       then 'C'
       else 'O'
  end status_cal
  
  from pi2_development_db.pi2_trade_n) source
  where status = status_cal;  --16633482793
      select count(*)  
 
  from pi2_trade_n ; --16633482793
  
  
  select count(*) from (
select trade_key,consumer_key, vintage_month,  narr_code1,narr_code2,type,balance,last_active_age,
status,
 case when rate IN ('7', '8', '9')  
            OR ( narr_code1 IN ('11', '12', '36', '42', '47', '86') or 
                 narr_code2 IN ('11', '12', '36', '42', '47', '86')
               )
            OR ( (narr_code1 IN ('22', '59', '90', 'A1' , 'A2') or 
                  narr_code2 IN ('22', '59', '90', 'A1' , 'A2')
                 ) 
                 and last_active_age > 12
               )
       then 'W'
       when (narr_code1 IN('22', '59', '90', 'A1', 'A2') or 
             narr_code2 IN('22', '59', '90', 'A1', 'A2')
            ) 
            and last_active_age < 13
       then 'S'
       when (narr_code1 IN( '01', '02', '13', '14', '20', '25', '28', '29', '32', '33', '41', '58', '60', '92', '95', 'A4', 'B2', 'B3', 'D3', 'D6', 'F8') or
             narr_code2 IN( '01', '02', '13', '14', '20', '25', '28', '29', '32', '33', '41', '58', '60', '92', '95', 'A4', 'B2', 'B3', 'D3', 'D6', 'F8')
            )
            OR (balance = 0 and type IN('M', 'I') )
       then 'C'
       else 'O'
  end status_cal
  
  from pi2_development_db.pi2_trade_n) source
  where status <> status_cal;  --0