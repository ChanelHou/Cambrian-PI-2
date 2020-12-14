truncate table roll_rates_BMO_Gold;
truncate table roll_rates_q_BMO_Gold;
truncate table trade_BMO_Gold;
truncate table vintages_BMO_Gold;
truncate table vintages_o_BMO_Gold;
select count(*) from roll_rates_BMO_Gold;
select count(*) from roll_rates_q_BMO_Gold;
select count(*) from trade_BMO_Gold;
select count(*) from vintages_BMO_Gold;
select count(*) from vintages_o_BMO_Gold;

with source as 
( select t.product , t.year_month,
sum(nb_account) volume,
sum(total_balance)  balance,
sum( case when delinquency_cat='90+' then nb_account else 0 end) volume_deli, 
sum(case when delinquency_cat='60Days' then nb_account else 0 end ) volume_30DPD, 
sum(case when delinquency_cat='30Days' then nb_account else 0 end ) volume_60DPD, 
sum(case when delinquency_cat='90+' then total_balance else 0 end ) balance_deli,
sum(case when delinquency_cat='30Days' then total_balance else 0 end ) balance_30DPD, 
sum(case when delinquency_cat='60Days' then total_balance else 0 end ) balance_60DPD
from  trade_BMO_Gold t
where  t.year_month between 201210 and 201809
group by t.product,t.year_month )  
select cur.product , cur.year_month,
cur.volume_deli/cur.volume*100.0 deliquencyRate,
(cur.volume_deli/cur.volume*100.0 - pre.volume_deli/pre.volume*100.0 ) *100.0 deliquencyVolume_SinceLast_BPS,
cur.balance_deli/cur.balance*100.0 delinquencyRate_Balance,
(cur.balance_deli/cur.balance*100.0 - pre.balance_deli/pre.balance*100.0)*100.0  deliquencyBalance_SinceLast_BPS,
cur.balance_30DPD/cur.balance*100.0 balanceRate_30DPD,
cur.balance_60DPD/cur.balance*100.0 balanceRate_60DPD, 
cur.balance_deli/cur.balance*100.0 balanceRate_90DPD,
cur.volume_30DPD/cur.volume*100.0 volumeRate_30DPD,
cur.volume_60DPD/cur.volume*100.0 volumeRate_60DPD, 
cur.volume_deli/cur.volume*100.0 volumeRate_90DPD
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  case when  cur.year_month % 100 =1 then (floor(cur.year_month/100) -1) *100 + 12 else cur.year_month-1 end
order by cur.year_month,cur.product;
go
drop procedure p_delinquency_trend_byMonth;
go
create procedure p_delinquency_trend_byMonth 
@fromYearMonth int ,
@toYearMonth int ,
@groupbyField varchar(100)
as 

Begin
DECLARE @SQLString nvarchar(2000); 

SET @SQLString = N'
with source as 
( select ' + @groupbyField + N',
sum(nb_account) volume,
sum(total_balance)  balance,
sum( case when delinquency_cat=''90+'' then nb_account else 0 end) volume_deli, 
sum(case when delinquency_cat=''60Days'' then nb_account else 0 end ) volume_30DPD, 
sum(case when delinquency_cat=''30Days'' then nb_account else 0 end ) volume_60DPD, 
sum(case when delinquency_cat=''90+'' then total_balance else 0 end ) balance_deli,
sum(case when delinquency_cat=''30Days'' then total_balance else 0 end ) balance_30DPD, 
sum(case when delinquency_cat=''60Days'' then total_balance else 0 end ) balance_60DPD
from  trade_BMO_Gold cur
where  cur.year_month between ' + cast (@fromYearMonth as varchar(6)) + N'and ' + cast( @toYearMonth as varchar(6))+ 
N'group by ' + @groupbyField +N' )  
select ' + @groupbyField +N',
1.0* cur.volume_deli/cur.volume*100.0 deliquencyRate,
1.0* (cur.volume_deli/cur.volume*100.0 - pre.volume_deli/pre.volume*100.0 ) *100.0 deliquencyVolume_SinceLast_BPS,
1.0* cur.balance_deli/cur.balance*100.0 delinquencyRate_Balance,
1.0* (cur.balance_deli/cur.balance*100.0 - pre.balance_deli/pre.balance*100.0)*100.0  deliquencyBalance_SinceLast_BPS,
1.0* cur.balance_30DPD/cur.balance*100.0 balanceRate_30DPD,
1.0* cur.balance_60DPD/cur.balance*100.0 balanceRate_60DPD, 
1.0* cur.balance_deli/cur.balance*100.0 balanceRate_90DPD,
1.0* cur.volume_30DPD/cur.volume*100.0 volumeRate_30DPD,
1.0* cur.volume_60DPD/cur.volume*100.0 volumeRate_60DPD, 
cur.volume_deli/cur.volume*100.0 volumeRate_90DPD
from source cur
left join source pre
on pre.product=cur.product
and pre.year_month=  case when  cur.year_month % 100 =1 then (floor(cur.year_month/100) -1) *100 + 12 else cur.year_month-1 end  
order by ' + @groupbyField;
select @SQLString;

 EXECUTE sp_executesql @SQLString;
End;


EXEC p_delinquency_trend_byMonth  @fromYearMonth =201210 ,
@toYearMonth =201809 ,
@groupbyField ='cur.year_month,cur.product';

EXEC p_delinquency_trend_byMonth  @fromYearMonth =201210 ,
@toYearMonth =201809 ,
@groupbyField ='cur.year_month,cur.product,cur.province';


SELECT substring('a,b', 1, CHARINDEX(',','a,b')-1) col1,
substring('a,b', CHARINDEX(',','a,b')+1, LEN('a,b')) col2

select STRING_SPLIT ('1,2,3,4,5,6,7,8,9,10,11,12,13,14,15', ',') 
 
 
 