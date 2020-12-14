--for no dupliocate trade key year_month , the non-rule fields will be same ,  for example 201801
--for has duplicate trade_key year_month, it has some non-rule fields have variance , for example 201809

--test case 2:  exclude trades 

select * from 
( select  cmr.uniquenumber,
tr.ddateopened, 
tr.ddatereported,
tr.dmembernumber,
tr.ddateoflastactivity,
tr.accountnumber, 
tr.membernumber.memberindustrycode industry_code,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.paymentcode.portfoliotype type, 
  tr.paymentcode.paymentcodenumber rate, 
  tr.highcreditamount credit_limit, 
  tr.balanceamount balance,
  tr.narrativecode1acro,
  tr.narrativecode2acro ,
  tr.scheduledpaymentamount,
  tr.pastdueamount past_due_amt,
  tr.conditioncode ,
  tr.paymentcode.portfoliotype,
  tr.narrativecode1sts,
  tr.narrativecode2sts,
  tr.dmembernumber fi_id,
  archive,instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts),instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts)
from efx_ca_prod.acro   
 lateral view explode(tc) exploded_table as tr
where  (substr(tr.membernumber.memberindustrycode,1,1) ='Y'
or tr.paymentcode.paymentcodenumber  not in (0,1,2,3,4,5,7,8,9)
or  acro.archive -tr.ddatereported < 0 
or  ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) )
and floor(archive/100) = 201611  
) source join    
( 
select  consumer_key, vintage_month, account_age, reported_age, last_active_age, industry_code, trade_key, 
       type, rate, credit_limit, balance, payment_amt, past_due_amt,  delinquency_cat , narr_code1, narr_code2, sts_code1, sts_code2 ,trade_status
from  pi2_development_db.pi2_trade_n
where year_month=201611 ) target
where source.trade_key = target.trade_key
 limit 10 ; --no result
 
select count(*) exclude_count --impala
from  pi2_trade_n p
where  
    reported_age   < 0 
or nvl(Rate,'6') = '6' 
or substr(industry_code, 1, 1) = 'Y' 
or trade_status='4' 
or instr( '_AA_AB_AC_AG_BB_FD' ,p.sts_code1) > 1 
or instr( '_AA_AB_AC_AG_BB_FD' ,p.sts_code2)> 1 
or  p.conditioncode in ('S', 'B');  --0


--test case 4
select   year_month,count(*)
from  pi2_trade_n p
group by year_month
order by p.year_month ;


--test 5 , comparing record counts between source and target

 

--target:
 
select count(*)  from pi2_development_db.pi2_trade_n 
where year_month=201711;--	211165619

--source:
select count(*)
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive -tr.ddatereported > 0 
and not ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and archive = 20171130 ;--211165619

 select count(*)
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive -tr.ddatereported > 0 
and not ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and archive = 20180930 ; --212242748

select count(*)  from pi2_development_db.pi2_trade_n 
where year_month=201809;--212242748

select count(*)
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive -tr.ddatereported > 0 
and not ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and archive = 20120131 ;--192633818

select count(*) from pi2_trade_n where year_month=201201;  --192633818



--duplicate key , fail
 select trade_key,year_month,count(*) from pi2_trade_n p2  
group by p2.trade_key ,year_month having count(*) > 1

--
--quarter:
select  substr(cast(timeperiod as string), 5,2) ,quarter
from pi2_trade_n p
 group by substr(cast(timeperiod as string), 5,2) , quarter
order by p.quarter (impala)


-- some duplicate key will result the field not match
 
select * ,
if (uniquenumber=consumer_key,  'consumer_key pass', 'consumer_key fail'),
if (floor(ddateopened/100)=vintage_month, 'vintage_month pass','vintage_month fail'),
if (nvl(source.account_age,0) = nvl(target.account_age,0), 'account_age pass','account_age fail'),
if (nvl(source.reported_age,0) = nvl(target.reported_age,0) , 'reported_age pass','reported_age fail'),
if (nvl(source.last_active_age,0) =nvl(target.last_active_age,0)  ,  'last_active_age pass', 'last_active_age fail'),
if (source.industry_code=target.industry_code,'industry_code pass','industry_code fail'),
if (portfoliotype=target.type,  'type pass', 'type fail'),
if (source.rate=target.rate, 'rate pass', 'rate fail'),
if (highcreditamount=credit_limit,'credit_limit pass','credit_limit fail'),
if (balanceamount=balance, 'balance pass', 'balance fail'),
if (source.past_due_amt=target.past_due_amt,'past_due_amt pass','past_due_amt fail'),
if (source.fi_id=target.fi_id,'fi_id pass','fi_id fail'),
if (narrativecode1acro=target.narr_code1,  'narr_code1 pass', 'narr_code1 fail'),
if (narrativecode2acro=narr_code2, 'narr_code2 pass', 'narr_code2 fail'),
if ( narrativecode1sts=target.sts_code1,  'sts_code1 pass', 'sts_code1 fail'),
if ( narrativecode2sts=sts_code2, 'sts_code2 pass', 'sts_code2 fail'),
if (source.conditioncode=target.conditioncode,'conditioncode pass','conditioncode fail') , -- conditioncode should be ''
if (archive=timeperiod,'timeperiod pass',' timeperiod fail'),
if (floor(archive/10000) = year, 'year pass','year fail'),

floor(archive-ddateoflastactivity)/100


from (
select  cmr.uniquenumber,
tr.ddateopened,
tr.ddatereported,
tr.ddateoflastactivity,
tr.membernumber.memberindustrycode industry_code,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.paymentcode.portfoliotype portfoliotype,
tr.paymentcode.paymentcodenumber rate,
tr.highcreditamount highcreditamount, 
tr.balanceamount,
 tr.pastdueamount past_due_amt,
tr.dmembernumber fi_id, 
tr.narrativecode1acro,
tr.narrativecode2acro,
tr.narrativecode1sts,
tr.narrativecode2sts,
tr.conditioncode,
archive ,
substr(cast(archive as string), 5,2) month_archive,
 default.getMonthsDiff(archive, tr.ddateopened) account_age,
  default.getMonthsDiff(archive, tr.ddatereported) reported_age,
  default.getMonthsDiff(archive, tr.ddateoflastactivity) last_active_age
 
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive - tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201809
 ) source
join (
select  consumer_key,vintage_month,account_age,reported_age,   
last_active_age,industry_code  ,type,           
rate,credit_limit,balance ,past_due_amt  , fi_id  ,        
narr_code1 ,narr_code2 ,sts_code1,sts_code2,conditioncode , timeperiod  ,year ,quarter,trade_key,delinquency_cat,
status,joint_flag
from  pi2_development_db.pi2_trade_n 
where year_month=201809 ) target
on source.trade_key = target.trade_key 
where (
 uniquenumber<>consumer_key 
or floor(ddateopened/100)<>vintage_month 
or nvl(source.account_age,0)<> nvl(target.account_age,0) 
or nvl(source.reported_age,0)<> nvl(target.reported_age,0) 
or nvl(source.last_active_age,0)<>nvl(target.last_active_age,0)  
or source.industry_code<>target.industry_code 
or portfoliotype<>target.type 
or source.rate<>target.rate 
or highcreditamount<>credit_limit 
or balanceamount<>balance 
or source.past_due_amt<>target.past_due_amt 
or source.fi_id<>target.fi_id 
or narrativecode1acro<>target.narr_code1 
or narrativecode2acro<>narr_code2 
or  narrativecode1sts<>target.sts_code1 
or  narrativecode2sts<>sts_code2 
or source.conditioncode<>target.conditioncode 
or archive<>timeperiod 
or floor(archive/10000) <> year)
limit 10

--duplicate trade_key
select * from pi2_trade_n p1
where 
p1.year_month=201711 and 
exists ( select 1 from pi2_trade_n p2 where p2.year_month = 201711 and p1.trade_key = p2.trade_key
group by p2.trade_key  having count(*) > 1);


--null value , 

select count(*) from pi2_trade_n 
where last_active_age is null
and year_month=201809;--6892913


select  count(*)
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive - tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201809
and tr.ddateoflastactivity is null;--6892913

select  count(*)
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive - tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201808
and tr.ddateoflastactivity is null;--6856339
select count(*) from pi2_trade_n 
where last_active_age is null
and year_month=201808; --6856339
 
select * ,
if (uniquenumber=consumer_key,  'consumer_key pass', 'consumer_key fail'),
if (floor(ddateopened/100)=vintage_month, 'vintage_month pass','vintage_month fail'),
if (nvl(source.account_age,0) = nvl(target.account_age,0), 'account_age pass','account_age fail'),
if (nvl(source.reported_age,0) = nvl(target.reported_age,0) , 'reported_age pass','reported_age fail'),
if (nvl(source.last_active_age,0) =nvl(target.last_active_age,0)  ,  'last_active_age pass', 'last_active_age fail'),
if (source.industry_code=target.industry_code,'industry_code pass','industry_code fail'),
if (portfoliotype=target.type,  'type pass', 'type fail'),
if (source.rate=target.rate, 'rate pass', 'rate fail'),
if (highcreditamount=credit_limit,'credit_limit pass','credit_limit fail'),
if (balanceamount=balance, 'balance pass', 'balance fail'),
if (source.past_due_amt=target.past_due_amt,'past_due_amt pass','past_due_amt fail'),
if (source.fi_id=target.fi_id,'fi_id pass','fi_id fail'),
if (narrativecode1acro=target.narr_code1,  'narr_code1 pass', 'narr_code1 fail'),
if (narrativecode2acro=narr_code2, 'narr_code2 pass', 'narr_code2 fail'),
if ( narrativecode1sts=target.sts_code1,  'sts_code1 pass', 'sts_code1 fail'),
if ( narrativecode2sts=sts_code2, 'sts_code2 pass', 'sts_code2 fail'),
if (source.conditioncode=target.conditioncode,'conditioncode pass','conditioncode fail') , -- conditioncode should be ''
if (archive=timeperiod,'timeperiod pass',' timeperiod fail'),
if (floor(archive/10000) = year, 'year pass','year fail'),

floor(archive-ddateoflastactivity)/100


from (
select  cmr.uniquenumber,
tr.ddateopened,
tr.ddatereported,
tr.ddateoflastactivity,
tr.membernumber.memberindustrycode industry_code,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.paymentcode.portfoliotype portfoliotype,
tr.paymentcode.paymentcodenumber rate,
tr.highcreditamount highcreditamount, 
tr.balanceamount,
 tr.pastdueamount past_due_amt,
tr.dmembernumber fi_id, 
tr.narrativecode1acro,
tr.narrativecode2acro,
tr.narrativecode1sts,
tr.narrativecode2sts,
tr.conditioncode,
archive ,
substr(cast(archive as string), 5,2) month_archive,
 default.getMonthsDiff(archive, tr.ddateopened) account_age,
  default.getMonthsDiff(archive, tr.ddatereported) reported_age,
  default.getMonthsDiff(archive, tr.ddateoflastactivity) last_active_age
 
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive - tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201809
 ) source
join (
select  consumer_key,vintage_month,account_age,reported_age,   
last_active_age,industry_code  ,type,           
rate,credit_limit,balance ,past_due_amt  , fi_id  ,        
narr_code1 ,narr_code2 ,sts_code1,sts_code2,conditioncode , timeperiod  ,year ,quarter,trade_key,delinquency_cat,
status,joint_flag
from  pi2_development_db.pi2_trade_n 
where year_month=201809 ) target
on source.trade_key = target.trade_key 
where (
 uniquenumber<>consumer_key 
or floor(ddateopened/100)<>vintage_month 
--or nvl(source.account_age,0)<> nvl(target.account_age,0) 
--or nvl(source.reported_age,0)<> nvl(target.reported_age,0) 
--or nvl(source.last_active_age,0)<>nvl(target.last_active_age,0)  
or source.industry_code<>target.industry_code 
or portfoliotype<>target.type 
or source.rate<>target.rate 
or highcreditamount<>credit_limit 
or balanceamount<>balance 
or source.past_due_amt<>target.past_due_amt 
or source.fi_id<>target.fi_id 
or narrativecode1acro<>target.narr_code1 
or narrativecode2acro<>narr_code2 
or  narrativecode1sts<>target.sts_code1 
or  narrativecode2sts<>sts_code2 
or source.conditioncode<>target.conditioncode 
or archive<>timeperiod 
or floor(archive/10000) <> year)
limit 10



 
 
 
 ------------
 select count(*)


from (
select  cmr.uniquenumber,
tr.ddateopened,
tr.ddatereported,
tr.ddateoflastactivity,
tr.membernumber.memberindustrycode industry_code,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.paymentcode.portfoliotype portfoliotype,
tr.paymentcode.paymentcodenumber rate,
tr.highcreditamount highcreditamount, 
tr.balanceamount,
 tr.pastdueamount past_due_amt,
tr.dmembernumber fi_id, 
tr.narrativecode1acro,
tr.narrativecode2acro,
tr.narrativecode1sts,
tr.narrativecode2sts,
tr.conditioncode,
archive ,
substr(cast(archive as string), 5,2) month_archive,
 default.getMonthsDiff(archive, tr.ddateopened) account_age,
  default.getMonthsDiff(archive, tr.ddatereported) reported_age,
  default.getMonthsDiff(archive, tr.ddateoflastactivity) last_active_age
 
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive - tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201601
 ) source
join (
select  consumer_key,vintage_month,account_age,reported_age,   
last_active_age,industry_code  ,type,           
rate,credit_limit,balance ,past_due_amt  , fi_id  ,        
narr_code1 ,narr_code2 ,sts_code1,sts_code2,conditioncode , timeperiod  ,year ,quarter,trade_key,delinquency_cat,
status,joint_flag
from  pi2_development_db.pi2_trade_n 
where year_month=201601 ) target
on source.trade_key = target.trade_key 
where (
 uniquenumber<>consumer_key 
or floor(ddateopened/100)<>vintage_month 
or nvl(source.account_age,0)<> nvl(target.account_age,0) 
or nvl(source.reported_age,0)<> nvl(target.reported_age,0) 
or nvl(source.last_active_age,0)<>nvl(target.last_active_age,0)  
or source.industry_code<>target.industry_code 
or portfoliotype<>target.type 
or source.rate<>target.rate 
or highcreditamount<>credit_limit 
or balanceamount<>balance 
or source.past_due_amt<>target.past_due_amt 
or source.fi_id<>target.fi_id 
or narrativecode1acro<>target.narr_code1 
or narrativecode2acro<>narr_code2 
or  narrativecode1sts<>target.sts_code1 
or  narrativecode2sts<>sts_code2 
or source.conditioncode<>target.conditioncode 
or archive<>timeperiod 
or floor(archive/10000) <> year)   ; --12


select year_month,trade_key,count(*)
from pi2_trade_n
where year_month=201601
group by year_month,trade_key
having count(*) > 1;  --6


select * ,
if (uniquenumber=consumer_key,  'consumer_key pass', 'consumer_key fail'),
if (floor(ddateopened/100)=vintage_month, 'vintage_month pass','vintage_month fail'),
if (nvl(source.account_age,0) = nvl(target.account_age,0), 'account_age pass','account_age fail'),
if (nvl(source.reported_age,0) = nvl(target.reported_age,0) , 'reported_age pass','reported_age fail'),
if (nvl(source.last_active_age,0) =nvl(target.last_active_age,0)  ,  'last_active_age pass', 'last_active_age fail'),
if (source.industry_code=target.industry_code,'industry_code pass','industry_code fail'),
if (portfoliotype=target.type,  'type pass', 'type fail'),
if (source.rate=target.rate, 'rate pass', 'rate fail'),
if (highcreditamount=credit_limit,'credit_limit pass','credit_limit fail'),
if (balanceamount=balance, 'balance pass', 'balance fail'),
if (source.past_due_amt=target.past_due_amt,'past_due_amt pass','past_due_amt fail'),
if (source.fi_id=target.fi_id,'fi_id pass','fi_id fail'),
if (narrativecode1acro=target.narr_code1,  'narr_code1 pass', 'narr_code1 fail'),
if (narrativecode2acro=narr_code2, 'narr_code2 pass', 'narr_code2 fail'),
if ( narrativecode1sts=target.sts_code1,  'sts_code1 pass', 'sts_code1 fail'),
if ( narrativecode2sts=sts_code2, 'sts_code2 pass', 'sts_code2 fail'),
if (source.conditioncode=target.conditioncode,'conditioncode pass','conditioncode fail') , -- conditioncode should be ''
if (archive=timeperiod,'timeperiod pass',' timeperiod fail'),
if (floor(archive/10000) = year, 'year pass','year fail'),

floor(archive-ddateoflastactivity)/100


from (
select  cmr.uniquenumber,
tr.ddateopened,
tr.ddatereported,
tr.ddateoflastactivity,
tr.membernumber.memberindustrycode industry_code,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.paymentcode.portfoliotype portfoliotype,
tr.paymentcode.paymentcodenumber rate,
tr.highcreditamount highcreditamount, 
tr.balanceamount,
 tr.pastdueamount past_due_amt,
tr.dmembernumber fi_id, 
tr.narrativecode1acro,
tr.narrativecode2acro,
tr.narrativecode1sts,
tr.narrativecode2sts,
tr.conditioncode,
archive ,
substr(cast(archive as string), 5,2) month_archive,
 default.getMonthsDiff(archive, tr.ddateopened) account_age,
  default.getMonthsDiff(archive, tr.ddatereported) reported_age,
  default.getMonthsDiff(archive, tr.ddateoflastactivity) last_active_age
 
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive - tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201701
 ) source
join (
select  consumer_key,vintage_month,account_age,reported_age,   
last_active_age,industry_code  ,type,           
rate,credit_limit,balance ,past_due_amt  , fi_id  ,        
narr_code1 ,narr_code2 ,sts_code1,sts_code2,conditioncode , timeperiod  ,year ,quarter,trade_key,delinquency_cat,
status,joint_flag
from  pi2_development_db.pi2_trade_n 
where year_month=201701 ) target
on source.trade_key = target.trade_key 
where (
 uniquenumber<>consumer_key 
or floor(ddateopened/100)<>vintage_month 
or nvl(source.account_age,0)<> nvl(target.account_age,0) 
or nvl(source.reported_age,0)<> nvl(target.reported_age,0) 
or nvl(source.last_active_age,0)<>nvl(target.last_active_age,0)  
or source.industry_code<>target.industry_code 
or portfoliotype<>target.type 
or source.rate<>target.rate 
or highcreditamount<>credit_limit 
or balanceamount<>balance 
or source.past_due_amt<>target.past_due_amt 
or source.fi_id<>target.fi_id 
or narrativecode1acro<>target.narr_code1 
or narrativecode2acro<>narr_code2 
or  narrativecode1sts<>target.sts_code1 
or  narrativecode2sts<>sts_code2 
or source.conditioncode<>target.conditioncode 
or archive<>timeperiod 
or floor(archive/10000) <> year)   --2 , duplicate trade_key

--execute the above query for 201801 is 0

 select count(*)


from (
select  cmr.uniquenumber,
tr.ddateopened,
tr.ddatereported,
tr.ddateoflastactivity,
tr.membernumber.memberindustrycode industry_code,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.paymentcode.portfoliotype portfoliotype,
tr.paymentcode.paymentcodenumber rate,
tr.highcreditamount highcreditamount, 
tr.balanceamount,
 tr.pastdueamount past_due_amt,
tr.dmembernumber fi_id, 
tr.narrativecode1acro,
tr.narrativecode2acro,
tr.narrativecode1sts,
tr.narrativecode2sts,
tr.conditioncode,
archive ,
substr(cast(archive as string), 5,2) month_archive,
 default.getMonthsDiff(archive, tr.ddateopened) account_age,
  default.getMonthsDiff(archive, tr.ddatereported) reported_age,
  default.getMonthsDiff(archive, tr.ddateoflastactivity) last_active_age
 
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive - tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201701
 ) source
join (
select  consumer_key,vintage_month,account_age,reported_age,   
last_active_age,industry_code  ,type,           
rate,credit_limit,balance ,past_due_amt  , fi_id  ,        
narr_code1 ,narr_code2 ,sts_code1,sts_code2,conditioncode , timeperiod  ,year ,quarter,trade_key,delinquency_cat,
status,joint_flag
from  pi2_development_db.pi2_trade_n 
where year_month=201701 ) target
on source.trade_key = target.trade_key 
where (
 uniquenumber=consumer_key 
and floor(ddateopened/100)=vintage_month 
and nvl(source.account_age,0)= nvl(target.account_age,0) 
and nvl(source.reported_age,0)= nvl(target.reported_age,0) 
and nvl(source.last_active_age,0)=nvl(target.last_active_age,0)  
and source.industry_code=target.industry_code 
and portfoliotype=target.type 
and source.rate=target.rate 
and highcreditamount=credit_limit 
and balanceamount=balance 
and source.past_due_amt=target.past_due_amt 
and source.fi_id=target.fi_id 
and narrativecode1acro=target.narr_code1 
and narrativecode2acro=narr_code2 
and  narrativecode1sts=target.sts_code1 
and  narrativecode2sts=sts_code2 
and source.conditioncode=target.conditioncode 
and archive=timeperiod 
and floor(archive/10000) = year)    ;--212318262  ,212318262 

--execute the above query for 201706 , 210816822




 