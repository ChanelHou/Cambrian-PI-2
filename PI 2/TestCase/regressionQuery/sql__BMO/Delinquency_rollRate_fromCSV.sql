drop procedure Delinquency_rollRate_barChart;
go
create procedure Delinquency_rollRate_barChart
@fromYearMonth int ,
@fi_cat varchar(50) ,
@tableName varchar(100),
@product varchar(100)
as 

Begin
DECLARE @SQLString nvarchar(max ); 
 declare @bcpcmd nvarchar(2000);
 set @SQLString =N'
select from_month,  
fi_cat ,
product,
from_rate ,
 case when 1.0 * sum(trade_count)>0 then sum(rolled_to_0)/sum(trade_count)*100.0 else null end new_trade,
 case when 1.0 * sum(trade_count)>0 then sum(rolled_to_1)/sum(trade_count)*100.0 else null end current_trade,
 case when 1.0 * sum(trade_count)>0 then sum(rolled_to_2)/sum(trade_count)*100.0 else null end trade_30Days,
 case when 1.0 * sum(trade_count)>0 then sum(rolled_to_3)/sum(trade_count)*100.0 else null end trade_60Days,
 case when 1.0 * sum(trade_count)>0 then sum(rolled_to_4)/sum(trade_count)*100.0 else null end trade_90Days,
 case when 1.0 * sum(trade_count)>0 then sum(rolled_to_5)/sum(trade_count)*100.0 else null end trade_120Days,
 case when 1.0 * sum(trade_count)>0 then sum(rolled_to_bd)/sum(trade_count)*100.0  else null end badDebt__trade,
 case when 1.0 * sum(total_balance)>0 then  sum(bal_rolled_to_0)/sum(total_balance)*100.0 else null end new_balance,
 case when 1.0 * sum(total_balance)>0 then   sum(bal_rolled_to_1)/sum(total_balance)*100.0 else null end current_balance ,
 case when 1.0 * sum(total_balance)>0 then  sum(bal_rolled_to_2)/sum(total_balance)*100.0 else null end balance_30Days,
 case when 1.0 * sum(total_balance)>0 then   sum(bal_rolled_to_3)/sum(total_balance)*100.0 else null end balance60Days,
 case when 1.0 * sum(total_balance)>0 then  sum(bal_rolled_to_4)/sum(total_balance)*100.0 else null end balance_90Days,
 case when 1.0 * sum(total_balance)>0 then   sum(bal_rolled_to_5)/sum(total_balance)*100.0 else null end balance_120Days,
 case when 1.0 * sum(total_balance)>0 then   sum(bal_rolled_to_bd)/sum(total_balance)*100.0 else null end BadDebt_balance
from  ' + @tableName  +
N' where from_month=' + cast ( @fromYearMonth as varchar(10)) + 
N' and fi_cat=''' + @fi_cat + N' '' ' +
N' and product=''' + @product + N' '' ' +
N'group by from_month,fi_cat,product,from_rate
order by from_month,fi_cat,product,from_rate'
 --select @SQLString;
 EXECUTE sp_executesql @SQLString ;
END;
execute Delinquency_rollRate_barChart 201803 ,'BMO','roll_rates_BMO_Gold','Heloc'
execute p_exportByBCP 'Delinquency_rollRate_barChart',N'201803 ,''BMO'' ,''roll_rates_BMO_Gold'',''Heloc''','c:\PI_two\delinquency.csv'