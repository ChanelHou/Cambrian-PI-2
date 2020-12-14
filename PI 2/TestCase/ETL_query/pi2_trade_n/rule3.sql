--rule 14product_code Other should be 'O', not "Other"
 select distinct product_code
 from pi2_trade_n 
  order by product_code;
  
  
  select distinct pi2_product
from pi2_development_db.pi2_trade_n
 
order by pi2_product;
  
  
select count(*)
from (

select    trade_key,rate,  
pi2_product,
product_code ,
case 
when product_code ='A' then 'Mortgage'	 			 
when product_code ='B' then 'NCC' 					 
when product_code ='C' then 'NCC'					 
when product_code ='D' then 'Heloc'					 
when product_code ='H' then 'Heloc'					 
when product_code ='E' then 'Bank installment loan'	 
when product_code ='I' then 'Bank installment loan'	 
when product_code ='F' then 'Bank revolving'			 
when product_code ='G' then 'Bank revolving'			 
when product_code ='J' then 'Bank revolving'			 
when product_code ='K' then 'Bank revolving'			 
when product_code ='L' then 'Auto Finance'			 
when product_code ='M' then 'Personal / Sales Finance'	 
when product_code ='N' then 'Personal / Sales Finance' 	 
when product_code ='O' then 'Retail Finance' 		 
when product_code ='P' then 'Telco'					 
when product_code ='8' then 'Student Loan'			 
when product_code ='Q' then 'Other'					 
when product_code ='R' then 'Other'					 
  end  pi2_product_cal 
	   
from  pi2_trade_n ) source
where pi2_product <> pi2_product_cal; --0


select count(*)
from (

select    trade_key,rate,  
pi2_product,
product_code ,
case 
when product_code ='A' then 'Mortgage'	 			 
when product_code ='B' then 'NCC' 					 
when product_code ='C' then 'NCC'					 
when product_code ='D' then 'Heloc'					 
when product_code ='H' then 'Heloc'					 
when product_code ='E' then 'Bank installment loan'	 
when product_code ='I' then 'Bank installment loan'	 
when product_code ='F' then 'Bank revolving'			 
when product_code ='G' then 'Bank revolving'			 
when product_code ='J' then 'Bank revolving'			 
when product_code ='K' then 'Bank revolving'			 
when product_code ='L' then 'Auto Finance'			 
when product_code ='M' then 'Personal / Sales Finance'	 
when product_code ='N' then 'Personal / Sales Finance' 	 
when product_code ='O' then 'Retail Finance' 		 
when product_code ='P' then 'Telco'					 
when product_code ='8' then 'Student Loan'			 
when product_code ='Q' then 'Other'					 
when product_code ='R' then 'Other'					 
  end  pi2_product_cal 
	   
from  pi2_trade_n ) source
where pi2_product = pi2_product_cal;  --16633482793


  select count(*)  
 
  from pi2_trade_n ; --16633482793
 