
  select count(*)

from (

select  cmr.uniquenumber,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
 
tr.scheduledpaymentamount,
case   --rule #1
    when tr.narrativecode1acro = '08' or tr.narrativecode2acro = '08' then floor(tr.scheduledpaymentamount * 4.33)
    when tr.narrativecode1acro = 'B5' or tr.narrativecode2acro = 'B5' then floor(tr.scheduledpaymentamount / 6)
    when tr.narrativecode1acro = 'B7' or tr.narrativecode2acro = 'B7' then floor(tr.scheduledpaymentamount * 2)
    when tr.narrativecode1acro = 'B8' or tr.narrativecode2acro = 'B8' then floor(tr.scheduledpaymentamount /2)
    when tr.narrativecode1acro = 'C1' or tr.narrativecode2acro = 'C1' then floor(tr.scheduledpaymentamount * 2.16)
    when tr.narrativecode1acro = 'C8' or tr.narrativecode2acro = 'C8' then floor(tr.scheduledpaymentamount * 4.33)
    when tr.narrativecode1acro = 'C9' or tr.narrativecode2acro = 'C9' then floor(tr.scheduledpaymentamount / 3)
    when tr.narrativecode1acro = 'D0' or tr.narrativecode2acro = 'D0' then floor(tr.scheduledpaymentamount /12)
    else tr.scheduledpaymentamount
  end payment_amt,
 tr.narrativecode1acro,
 tr.narrativecode2acro,
archive
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive -tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201711
     
 
 ) source
join (
select  consumer_key, vintage_month, payment_amt,trade_key
from  pi2_trade_n 
where year_month=201711 ) target
on source.trade_key = target.trade_key
where source.payment_amt = target.payment_amt;  --		211165619


select count(*) from pi2_development_db.pi2_trade_n
where year_month=201711;  --	211165619


select count(*)

from (

select  cmr.uniquenumber,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
 
tr.scheduledpaymentamount,
case   --rule #1
    when tr.narrativecode1acro = '08' or tr.narrativecode2acro = '08' then floor(tr.scheduledpaymentamount * 4.33)
    when tr.narrativecode1acro = 'B5' or tr.narrativecode2acro = 'B5' then floor(tr.scheduledpaymentamount / 6)
    when tr.narrativecode1acro = 'B7' or tr.narrativecode2acro = 'B7' then floor(tr.scheduledpaymentamount * 2)
    when tr.narrativecode1acro = 'B8' or tr.narrativecode2acro = 'B8' then floor(tr.scheduledpaymentamount /2)
    when tr.narrativecode1acro = 'C1' or tr.narrativecode2acro = 'C1' then floor(tr.scheduledpaymentamount * 2.16)
    when tr.narrativecode1acro = 'C8' or tr.narrativecode2acro = 'C8' then floor(tr.scheduledpaymentamount * 4.33)
    when tr.narrativecode1acro = 'C9' or tr.narrativecode2acro = 'C9' then floor(tr.scheduledpaymentamount / 3)
    when tr.narrativecode1acro = 'D0' or tr.narrativecode2acro = 'D0' then floor(tr.scheduledpaymentamount /12)
    else tr.scheduledpaymentamount
  end payment_amt,
 tr.narrativecode1acro,
 tr.narrativecode2acro,
archive
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive -tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201809
     
 
 ) source
join (
select  consumer_key, vintage_month, payment_amt,trade_key
from  pi2_trade_n 
where year_month=201809 ) target
on source.trade_key = target.trade_key
where source.payment_amt = target.payment_amt;  --		212242774


select count(*) from pi2_development_db.pi2_trade_n
where year_month=201809; --212242748

--there are 13 trade_key is duplicate , so 212242774 - 212242748=26



select * ,
case when scheduledpaymentamount <> 0 and scheduledpaymentamount >= target.payment_amt then round(scheduledpaymentamount/target.payment_amt,2)
when scheduledpaymentamount <> 0 and scheduledpaymentamount < target.payment_amt then round(target.payment_amt/scheduledpaymentamount,2)

 else 0 end  payment_Calculate_rate,
case when target.payment_amt=floor(scheduledpaymentamount * 4.33) and (narrativecode1acro = '08' or narrativecode2acro = '08') then
'08 pass'
when target.payment_amt=floor(scheduledpaymentamount / 6) and (narrativecode1acro = 'B5' or narrativecode2acro = 'B5') then
'B5 pass'
when target.payment_amt=floor(scheduledpaymentamount * 2) and (narrativecode1acro = 'B7' or narrativecode2acro = 'B7') then
'B7 pass'
when target.payment_amt=floor(scheduledpaymentamount /2) and (narrativecode1acro = 'B8' or narrativecode2acro = 'B8') then
'B8 pass'
when target.payment_amt=floor(scheduledpaymentamount * 2.16)  and (narrativecode1acro = 'C1' or narrativecode2acro = 'C1') then
'C1 pass'
when target.payment_amt=floor(scheduledpaymentamount * 4.33) and ( narrativecode1acro = 'C8' or narrativecode2acro = 'C8' )then
'C8 pass'
when target.payment_amt=floor(scheduledpaymentamount /3) and (narrativecode1acro = 'C9' or narrativecode2acro = 'C9')  then
'C9 pass'
when target.payment_amt=floor(scheduledpaymentamount /12) and (narrativecode1acro = 'D0' or narrativecode2acro = 'D0') then
'D0 pass'
when target.payment_amt=scheduledpaymentamount  then
'monthly payment pass'
else
'fail'
end  test_status

from (

select  cmr.uniquenumber,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
 
tr.scheduledpaymentamount,
case   --rule #1
    when tr.narrativecode1acro = '08' or tr.narrativecode2acro = '08' then floor(tr.scheduledpaymentamount * 4.33)
    when tr.narrativecode1acro = 'B5' or tr.narrativecode2acro = 'B5' then floor(tr.scheduledpaymentamount / 6)
    when tr.narrativecode1acro = 'B7' or tr.narrativecode2acro = 'B7' then floor(tr.scheduledpaymentamount * 2)
    when tr.narrativecode1acro = 'B8' or tr.narrativecode2acro = 'B8' then floor(tr.scheduledpaymentamount /2)
    when tr.narrativecode1acro = 'C1' or tr.narrativecode2acro = 'C1' then floor(tr.scheduledpaymentamount * 2.16)
    when tr.narrativecode1acro = 'C8' or tr.narrativecode2acro = 'C8' then floor(tr.scheduledpaymentamount * 4.33)
    when tr.narrativecode1acro = 'C9' or tr.narrativecode2acro = 'C9' then floor(tr.scheduledpaymentamount / 3)
    when tr.narrativecode1acro = 'D0' or tr.narrativecode2acro = 'D0' then floor(tr.scheduledpaymentamount /12)
    else tr.scheduledpaymentamount
  end payment_amt,
 tr.narrativecode1acro,
 tr.narrativecode2acro,
archive
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where  substr(tr.membernumber.memberindustrycode,1,1) <>'Y'
and tr.paymentcode.paymentcodenumber  in (0,1,2,3,4,5,7,8,9)
and  acro.archive -tr.ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' , tr.narrativecode2sts) > 1 or 
tr.conditioncode in ('S', 'B') ) 
and floor(archive/100) = 201711
     
and tr.scheduledpaymentamount > 0
 ) source
join (
select  consumer_key, vintage_month, payment_amt,trade_key
from  pi2_trade_n 
where year_month=201711 ) target
on source.trade_key = target.trade_key
where source.payment_amt <> target.payment_amt;  --0
