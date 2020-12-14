select distinct joint_flag
from pi2_development_db.pi2_trade_n;


select count(*) from 
( select  *,  case when narrativecode1acro = '65' or narrativecode2acro = '65' or rnk > 1 then 'J' else 'P'  end joint_flag_cal  
 
from ( select 
cmr.uniquenumber,tr.conditioncode ,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.ddateopened,
tr.ddatereported,
tr.dmembernumber,
tr.membernumber.memberindustrycode  memberindustrycode,
 tr.paymentcode.paymentcodenumber rate,
tr.accountnumber,
archive ,tr.narrativecode1sts,tr.narrativecode2sts,
tr.narrativecode1acro,
tr.narrativecode2acro,
rank() over(partition by tr.accountnumber, tr.dmembernumber, tr.ddateopened order by tr.ddatereported desc, cmr.uniquenumber ASC) as rnk  
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where floor(archive/100) = 201711

 
 ) a
 
 where  substr(memberindustrycode,1,1) <>'Y'
and rate  in (0,1,2,3,4,5,7,8,9)
and archive -  ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode2sts) > 1 or 
 conditioncode in ('S', 'B') ) 
  ) source
join (
select 
consumer_key,  joint_flag ,  trade_key  
from  pi2_development_db.pi2_trade_n 
where year_month=201711 ) target
on source.trade_key = target.trade_key
where  source.joint_flag_cal <> target.joint_flag;  --0


select count(*) from 
( select  *,  case when narrativecode1acro = '65' or narrativecode2acro = '65' or rnk > 1 then 'J' else 'P'  end joint_flag_cal  
 
from ( select 
cmr.uniquenumber,tr.conditioncode ,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.ddateopened,
tr.ddatereported,
tr.dmembernumber,
tr.membernumber.memberindustrycode  memberindustrycode,
 tr.paymentcode.paymentcodenumber rate,
tr.accountnumber,
archive ,tr.narrativecode1sts,tr.narrativecode2sts,
tr.narrativecode1acro,
tr.narrativecode2acro,
rank() over(partition by tr.accountnumber, tr.dmembernumber, tr.ddateopened order by tr.ddatereported desc, cmr.uniquenumber ASC) as rnk  
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where floor(archive/100) = 201711

 
 ) a
 
 where  substr(memberindustrycode,1,1) <>'Y'
and rate  in (0,1,2,3,4,5,7,8,9)
and archive -  ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode2sts) > 1 or 
 conditioncode in ('S', 'B') ) 
  ) source
join (
select 
consumer_key,  joint_flag ,  trade_key  
from  pi2_development_db.pi2_trade_n 
where year_month=201711 ) target
on source.trade_key = target.trade_key
where  source.joint_flag_cal = target.joint_flag;  --211165619


select count(*) from 
( select  *,  case when narrativecode1acro = '65' or narrativecode2acro = '65' or rnk > 1 then 'J' else 'P'  end joint_flag_cal  
 
from ( select 
cmr.uniquenumber,tr.conditioncode ,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.ddateopened,
tr.ddatereported,
tr.dmembernumber,
tr.membernumber.memberindustrycode  memberindustrycode,
 tr.paymentcode.paymentcodenumber rate,
tr.accountnumber,
archive ,tr.narrativecode1sts,tr.narrativecode2sts,
tr.narrativecode1acro,
tr.narrativecode2acro,
rank() over(partition by tr.accountnumber, tr.dmembernumber, tr.ddateopened order by tr.ddatereported desc, cmr.uniquenumber ASC) as rnk  
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where floor(archive/100) = 201809

 
 ) a
 
 where  substr(memberindustrycode,1,1) <>'Y'
and rate  in (0,1,2,3,4,5,7,8,9)
and archive -  ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode2sts) > 1 or 
 conditioncode in ('S', 'B') ) 
  ) source
join (
select 
consumer_key,  joint_flag ,  trade_key  
from  pi2_development_db.pi2_trade_n 
where year_month=201809 ) target
on source.trade_key = target.trade_key
where  source.joint_flag_cal = target.joint_flag;  --212242760


select count(*) from 
( select  *,  case when narrativecode1acro = '65' or narrativecode2acro = '65' or rnk > 1 then 'J' else 'P'  end joint_flag_cal  
 
from ( select 
cmr.uniquenumber,tr.conditioncode ,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.ddateopened,
tr.ddatereported,
tr.dmembernumber,
tr.membernumber.memberindustrycode  memberindustrycode,
 tr.paymentcode.paymentcodenumber rate,
tr.accountnumber,
archive ,tr.narrativecode1sts,tr.narrativecode2sts,
tr.narrativecode1acro,
tr.narrativecode2acro,
rank() over(partition by tr.accountnumber, tr.dmembernumber, tr.ddateopened order by tr.ddatereported desc, cmr.uniquenumber ASC) as rnk  
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where floor(archive/100) = 201709

 
 ) a
 
 where  substr(memberindustrycode,1,1) <>'Y'
and rate  in (0,1,2,3,4,5,7,8,9)
and archive -  ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode2sts) > 1 or 
 conditioncode in ('S', 'B') ) 
  ) source
join (
select 
consumer_key,  joint_flag ,  trade_key  
from  pi2_development_db.pi2_trade_n 
where year_month=201709 ) target
on source.trade_key = target.trade_key
where  source.joint_flag_cal = target.joint_flag;  -- 210913183 same as the count in pi2_trade_n


select count(*) from 
( select  *,  case when narrativecode1acro = '65' or narrativecode2acro = '65' or rnk > 1 then 'J' else 'P'  end joint_flag_cal  
 
from ( select 
cmr.uniquenumber,tr.conditioncode ,
concat(tr.dmembernumber, lpad(cast(cmr.uniquenumber as string), 12, '0'), cast(tr.ddateopened as string), trim(tr.accountnumber)) trade_key,
tr.ddateopened,
tr.ddatereported,
tr.dmembernumber,
tr.membernumber.memberindustrycode  memberindustrycode,
 tr.paymentcode.paymentcodenumber rate,
tr.accountnumber,
archive ,tr.narrativecode1sts,tr.narrativecode2sts,
tr.narrativecode1acro,
tr.narrativecode2acro,
rank() over(partition by tr.accountnumber, tr.dmembernumber, tr.ddateopened order by tr.ddatereported desc, cmr.uniquenumber ASC) as rnk  
from efx_ca_prod.acro
lateral view explode(tc) exploded_table as tr
where floor(archive/100) = 201802

 
 ) a
 
 where  substr(memberindustrycode,1,1) <>'Y'
and rate  in (0,1,2,3,4,5,7,8,9)
and archive -  ddatereported > 0 
and   NOT ( instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode1sts) > 1 or 
instr( '_AA_AB_AC_AG_BB_FD' ,  narrativecode2sts) > 1 or 
 conditioncode in ('S', 'B') ) 
  ) source
join (
select 
consumer_key,  joint_flag ,  trade_key  
from  pi2_development_db.pi2_trade_n 
where year_month=201802 ) target
on source.trade_key = target.trade_key
where  source.joint_flag_cal = target.joint_flag;   --211131512

select count(*) from pi2_trade_n;   --211131512

 

 