select * from z_temp_table


select	b.orde_iden_numb
,		b.orde_sequ_numb
,		b.orde_requ_pric
,		b.sale_unit_pric
,		a.a2
,		a.a3
from	z_temp_table a
inner join mrordt b
		on	a.a1 = b.orde_iden_numb+'-'+b.orde_sequ_numb

/*
select * into mrordt_20130702 from mrordt
select * into mrpurt_20130702 from mrpurt
select * into mrordtlist_20130702 from mrordtlist
*/

/*		
begin tran
update	mrordt
set		orde_requ_pric = a.a2
,		sale_unit_pric = a.a3
from	z_temp_table a
inner join mrordt b
		on	a.a1 = b.orde_iden_numb+'-'+b.orde_sequ_numb
*/

select	b.orde_iden_numb
,		b.orde_sequ_numb
,		b.orde_requ_pric
,		b.sale_unit_pric
,		a.a2
,		a.a3
from	z_temp_table a
inner join mrpurt b
		on	a.a1 = b.orde_iden_numb+'-'+b.orde_sequ_numb

/*
begin tran
update	mrpurt
set		orde_requ_pric = a.a2
,		sale_unit_pric = a.a3
from	z_temp_table a
inner join mrpurt b
		on	a.a1 = b.orde_iden_numb+'-'+b.orde_sequ_numb
*/

select	b.orde_iden_numb
,		b.orde_sequ_numb
,		b.sale_prod_pris
,		b.sale_prod_amou
,		b.purc_prod_pris
,		b.purc_prod_amou
,		a.a2
,		(a.a2*b.sale_prod_quan) as sale
,		a.a3
,		(a.a3*b.sale_prod_quan) as purc
from	z_temp_table a
inner join mrordtlist b
		on	a.a1 = b.orde_iden_numb+'-'+b.orde_sequ_numb
/*
begin tran
update	mrordtlist
set		sale_prod_pris = a.a2
,		sale_prod_amou = (a.a2*b.sale_prod_quan)
,		purc_prod_pris = a.a3
,		purc_prod_amou = (a.a3*b.sale_prod_quan)
from	z_temp_table a
inner join mrordtlist b
		on	a.a1 = b.orde_iden_numb+'-'+b.orde_sequ_numb
*/		
		
commit tran

rollback tran