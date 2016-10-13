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


	
--���� �����ູ����(2)
--�����ڷ���(��) ��õ�����ູ����
--(��)���̾ص��ڷ��� ��õ�����ູ����
(��)�¸��ö�����_�ູ���� --2013-07-31, 810000001
�ֽ�ȸ�� �����������_�����ູ���� --2013-07-31, 5320000001
--�����̾��� ���뱸�ູ����
--�¿����(��) ��õ�ູ����(2)
--(��)�뼱�ڷ��� û���ູ����
--�۷γ��ڷ���(��) ���ֳ����ູ����
--��ȭ���(��) �������ູ����

select * from SMPBRANCHS where BRANCHCd = '5320000001'

select	a.a4
,		a.a5
,		b.BRANCHCD
,		b.BRANCHiD
,		b.BRANCHNM
from	z_temp_table a
inner join SMPBRANCHS b
	on	a.a4 = b.BRANCHCD
