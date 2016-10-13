select	a.a1
,		a.a2
,		a.a4
,		b.sale_sequ_numb
,		b.clientid
,		b.branchid
,		c.BRANCHNM
,		b.tran_stat_flag
,		b.sale_tota_amou
,		b.pay_amou
,		b.sale_over_month
,		b.sale_over_day
,		b.expiration_date
,		b.clos_sale_date
,		DATEADD(day, 40, b.clos_sale_date) 
from	z_temp_table a
left outer join mssalm b
	on	a.a5 = b.branchid
	and	a.a1 = b.clos_sale_date
inner join SMPBRANCHS c
	on	b.branchid = c.BRANCHiD
/*
2013-10-08 00:00:00.000
2013-11-08 00:00:00.000
2013-11-08 00:00:00.000
2013-11-08 00:00:00.000
2013-11-08 00:00:00.000
2013-11-08 00:00:00.000
2013-11-08 00:00:00.000
2013-11-08 00:00:00.000
2013-11-08 00:00:00.000
2013-11-08 00:00:00.000
*/

select * from SMPBORGS where BORGID in (
'GEN131'
,'304592'
,'304681'
,'GEN336'
,'GEN122'
,'GEN068'
,'GEN049'
,'GEN279'
,'GEN229'
,'GEN215'
)



/*

begin tran

update	mssalm
set		expiration_date = DATEADD(day, 40, b.clos_sale_date) 
from	z_temp_table a
left outer join mssalm b
	on	a.a5 = b.branchid
	and	a.a1 = b.clos_sale_date
inner join SMPBRANCHS c
	on	b.branchid = c.BRANCHiD

commit tran

rollback tran

*/
	
select * From MSG_DATA
select * from MSG_LOG_201309
	
	
	
	
select * from mssalm
	
select DATEADD(day, 40, A.clos_sale_date) 


	
--유빈스 동작행복센터(2)
--유지텔레콤(주) 금천광명행복센터
--(주)아이앤디텔레콤 인천서구행복센터
(주)굿모닝철원방송_행복센터 --2013-07-31, 810000001
주식회사 월드정보통신_전북행복센터 --2013-07-31, 5320000001
--씨케이앤지 남대구행복센터
--태영통신(주) 춘천행복센터(2)
--(주)대선텔레콤 청주행복센터
--글로넷텔레콤(주) 광주남부행복센터
--민화통신(주) 동수원행복센터

select * from SMPBRANCHS where BRANCHCd = '5320000001'

select	a.a4
,		a.a5
,		b.BRANCHCD
,		b.BRANCHiD
,		b.BRANCHNM
from	z_temp_table a
inner join SMPBRANCHS b
	on	a.a4 = b.BRANCHCD
