

select * from z_temp_table


select	a.a1
,		a.a2
,		b.cate_id
from	z_temp_table a
inner join mccategorymaster b
	on	a.a2 = b.cate_cd
inner join mcgood c
	on	a.a1 = c.good_iden_numb
	
	
begin tran	
update	mcgood
set		cate_id = b.cate_id
from	z_temp_table a
inner join mccategorymaster b
	on	a.a2 = b.cate_cd
inner join mcgood c
	on	a.a1 = c.good_iden_numb


commit tran

rollback tran


select * From mccategorymaster where cate_cd = 'M001010003'