create procedure p_ES_ProductSnap_tradeLine 
@curYearMonth int,
@preYearMonth int
as 

Begin
   with source as 
( select t.year_month,  product, 
--chart 8
sum(CASE When fi ='BMO' Then nb_account Else 0 End ) volume_BMO, 
sum(CASE When fi ='Peer Group' Then nb_account Else 0 End ) volume_PEER ,
sum(nb_account) volume_Market
from trade t
where   year_month in (@curYearMonth ,@preYearMonth)
group by  year_month, product )
select 
cur.product,
cur.volume_BMO, 
cur.volume_PEER ,
cur.volume_Market,
1.0*cur.volume_BMO/cur.volume_Market*100.0 volumeRateOfMarket,
cur.volume_BMO - pre.volume_BMO volume_movement_BMO,
cur.volume_PEER - pre.volume_PEER volume_movement_PEER
from source cur
join source pre
on  cur.product=pre.product
where cur.year_month=@curYearMonth
and pre.year_month=@preYearMonth
 order by cur.product;
End;

create procedure p_ES_ProductSnap_allExceptTradeLine 
@curYearMonth int,
@preYearMonth int
as 

Begin
   with source as 
( select t.year_month,  product, 
--chart 8
sum(CASE When fi ='BMO' Then nb_account Else 0 End ) volume_BMO, 
sum(CASE When fi ='Peer Group' Then nb_account Else 0 End ) volume_PEER ,
sum(nb_account) volume_Market,
--chart 9
sum(CASE When fi ='BMO' Then total_balance Else 0 End ) balance_BMO,
sum(CASE When fi ='Peer Group' Then total_balance Else 0 End ) balance_PEER  ,
sum(total_balance) balance_Market,
--chart 10

sum(CASE When fi ='BMO' Then total_limit Else 0 End ) credit_limit_BMO,
sum(CASE When fi ='Peer Group' Then total_limit Else 0 End ) credit_limit_PEER,  
sum(total_limit) credit_limit_Market,

  
--chart 12
sum(CASE When fi ='BMO' and delinquency_cat='90Days' Then nb_account Else 0 End ) Delinq_acct_BMO,
sum(CASE When fi ='Peer Group' and delinquency_cat='90Days' Then nb_account Else 0 End ) Delinq_acct_PEER , 
sum(CASE When fi ='BMO' and delinquency_cat='90Days' Then total_balance Else 0 End ) Delinq_Balance_BMO,
sum(CASE When fi ='Peer Group' and delinquency_cat='90Days' Then total_balance Else 0 End ) Delinq_Balance_PEER  
 
 
from trade t
 
where   year_month in (@curYearMonth ,@preYearMonth)
and t.joint_flag='P'
group by  year_month, product )
select 
cur.product,
cur.volume_BMO, 
cur.volume_PEER ,
cur.volume_Market,
1.0*cur.volume_BMO/cur.volume_Market*100.0 volumeRateOfMarket,
cur.volume_BMO - pre.volume_BMO volume_movement_BMO,
cur.volume_PEER - pre.volume_PEER volume_movement_PEER ,
 
cur.balance_BMO,
cur.balance_PEER,
cur.balance_Market,
1.0*cur.balance_BMO/cur.balance_Market*100 balanceRateOfMarket,
1.0*(cur.balance_BMO/pre.balance_BMO-1)*100 balanceRate_BMO,
1.0*(cur.balance_PEER/pre.balance_PEER-1)*100  balanceRate_PEER,
 
 --chart 10
cur.credit_limit_BMO,
cur.credit_limit_PEER,
cur.credit_limit_Market,
1.0*cur.credit_limit_BMO/cur.credit_limit_Market*100 limitRateOfMarket,
(1.0*cur.credit_limit_BMO/pre.credit_limit_BMO-1)*100 credit_limitRate_BMO,
(1.0*cur.credit_limit_PEER/pre.credit_limit_PEER-1)*100 credit_limitRate_PEER,

----chart 11
 1.0*cur.balance_BMO/cur.credit_limit_BMO*100  cur_uti_rate_BMO,
  1.0*pre.balance_BMO/pre.credit_limit_BMO*100 pre_uti_rate_BMO,
  (1.0*cur.balance_BMO/cur.credit_limit_BMO*100 - 1.0*pre.balance_BMO/pre.credit_limit_BMO*100)*100 uti_BMO_BPS,
 1.0*cur.balance_PEER/cur.credit_limit_PEER*100  cur_uti_rate_PEER,
  1.0*pre.balance_PEER/pre.credit_limit_PEER*100 pre_uti_rate_PEER,
  (1.0*cur.balance_PEER/cur.credit_limit_PEER*100 - 1.0*pre.balance_PEER/pre.credit_limit_PEER*100)*100 uti_PEER_BPS,
    

----chart 12
1.0*cur.Delinq_acct_BMO/cur.volume_BMO*100 delinquencyvolumeRate_BMO,
1.0*cur.Delinq_acct_PEER/cur.volume_PEER*100  delinquencyvolumeRate_PEER,
(1.0*cur.Delinq_acct_BMO/cur.volume_BMO*100 - 1.0*pre.Delinq_acct_BMO/pre.volume_BMO*100) * 100 DelinquencyRate_volume_BPS,
(1.0*cur.Delinq_acct_Peer/cur.volume_PEER*100 - 1.0*pre.Delinq_acct_PEER/pre.volume_PEER*100) * 100 DelinquencyRate_volume_PEER_BPS  ,
1.0*cur.Delinq_Balance_BMO/cur.balance_BMO*100 delinquencyBalanceRate_BMO,
1.0*cur.Delinq_Balance_PEER/cur.balance_PEER*100  delinquencyBalanceRate_PEER,
(1.0*cur.Delinq_Balance_BMO/cur.balance_BMO*100 - 1.0*pre.Delinq_Balance_BMO/pre.balance_BMO*100) * 100 DelinquencyRate_balance_BPS,
(1.0*cur.Delinq_Balance_Peer/cur.balance_PEER*100 - 1.0*pre.Delinq_Balance_PEER/pre.balance_PEER*100) * 100 DelinquencyRate_balance_PEER_BPS 
from source cur
join source pre
on  cur.product=pre.product
where cur.year_month=@curYearMonth
and pre.year_month=@preYearMonth
 order by cur.product;
End;
drop procedure p_ES_ProductSnap_byMeasures;

create procedure p_ES_ProductSnap_byMeasures 
@curYearMonth int ,
@groupbyField varchar(30)
as 

Begin
DECLARE @SQLString nvarchar(500); 
DECLARE @ParmDefinition nvarchar(500);  

SET @ParmDefinition = N'@YearMonth INT,@byField varchar(30)';

SET @SQLString = N'select year_month,product,' +  @groupbyField +  
N' ,sum(CASE When fi =''BMO'' Then nb_account Else 0 End ) count_BMO,
sum(CASE When fi =''Peer Group'' Then nb_account Else 0 End ) count_PEER , 
sum(CASE When fi =''BMO'' Then total_balance Else 0 End ) balance_BMO,
sum(CASE When fi =''Peer Group'' Then total_balance Else 0 End ) balance_PEER  
from dbo.trade 
 where   year_month = ' + cast(@curYearMonth as varchar(10)) +
 N' and joint_flag=''P''' +
 N' group by year_month,product,' + @groupbyField +
N' order by 1,2,3';

select @SQLString;

  EXECUTE sp_executesql @SQLString;
End;

drop procedure p_ES_ProductSnap_allExceptTradeLine_byAllYearMonth ;
create procedure p_ES_ProductSnap_allExceptTradeLine_byAllYearMonth 
@fromYearMonth int 
as 
Begin
  
select t.year_month,  product, 
--chart 8
sum(CASE When fi ='BMO' Then nb_account Else 0 End ) volume_BMO, 
sum(CASE When fi ='Peer Group' Then nb_account Else 0 End ) volume_PEER ,
--chart 9
sum(CASE When fi ='BMO' Then total_balance Else 0 End ) balance_BMO,
sum(CASE When fi ='Peer Group' Then total_balance Else 0 End ) balance_PEER  ,
--chart 10
sum(CASE When fi ='BMO' Then total_limit Else 0 End ) credit_limit_BMO,
sum(CASE When fi ='Peer Group' Then total_limit Else 0 End ) credit_limit_PEER,  
--chart 11
1.0* sum(CASE When fi ='BMO' Then total_balance Else 0 End )/sum(CASE When fi ='BMO' Then total_limit Else 0 End )*100 uti_BMO,
1.0* sum(CASE When fi ='Peer Group' Then total_balance Else 0 End )/sum(CASE When fi ='Peer Group' Then total_limit Else 0 End )*100 uti_PEER,
--chart 12
1.0*sum(CASE When fi ='BMO' and delinquency_cat='90Days' Then nb_account Else 0 End )/sum(CASE When fi ='BMO' Then nb_account Else 0 End )*100 Delinq_acctRate_BMO,
1.0*sum(CASE When fi ='Peer Group' and delinquency_cat='90Days' Then nb_account Else 0 End )/sum(CASE When fi ='Peer Group' Then nb_account Else 0 End )*100  Delinq_acctRate_PEER , 
1.0*sum(CASE When fi ='BMO' and delinquency_cat='90Days' Then total_balance Else 0 End )/sum(CASE When fi ='BMO' Then total_balance Else 0 End )*100 Delinq_Balance_BMO,
1.0*sum(CASE When fi ='Peer Group' and delinquency_cat='90Days' Then total_balance Else 0 End )/sum(CASE When fi ='Peer Group' Then total_balance Else 0 End )*100  Delinq_Balance_PEER  
from trade t
where   year_month >= @fromYearMonth  
and t.joint_flag='P'
group by  product,year_month
 order by product,year_month ;
End;


create procedure p_ES_ProductSnap_tradeLine_allTime
@fromYearMonth int 
as 

Begin
    select t.year_month,  product, 
--chart 13
sum(CASE When fi ='BMO' Then nb_account Else 0 End ) volume_BMO, 
sum(CASE When fi ='Peer Group' Then nb_account Else 0 End ) volume_PEER  
 
from trade t
where   year_month >=@fromYearMonth
group by  year_month, product 
 order by  product,year_month;
End;

EXEC p_ES_ProductSnap_tradeLine @curYearMonth = 201803, @preYearMonth=201802;
EXEC p_ES_ProductSnap_allExceptTradeLine @curYearMonth = 201803, @preYearMonth=201802;
EXEC p_ES_ProductSnap_byMeasures @curYearMonth = 201803,@groupbyField='province';
EXEC p_ES_ProductSnap_byMeasures @curYearMonth = 201803,@groupbyField='consumer_age_cat';
EXEC p_ES_ProductSnap_byMeasures @curYearMonth = 201803,@groupbyField='ers_band';

--line chart
EXEC p_ES_ProductSnap_allExceptTradeLine_byAllYearMonth @fromYearMonth = 201612;
 EXEC p_ES_ProductSnap_tradeLine_allTime @fromYearMonth = 201612;