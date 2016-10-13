select	a.*
from	mrordtlist a
where	a.orde_iden_numb = 'GEN1308210098' and a.orde_sequ_numb = '1'
--sale_sequ_numb = '33588'
--buyi_sequ_numb = 33483
update mrordtlist set buyi_sequ_numb = null where orde_iden_numb = 'GEN1308210098' and orde_sequ_numb = '1'

select	a.*
from	mrordtlist a
where	a.orde_iden_numb = 'GEN1308100007' and a.orde_sequ_numb = '1'
--sale_sequ_numb = '33588'
--buyi_sequ_numb = 33485
update mrordtlist set buyi_sequ_numb = null where orde_iden_numb = 'GEN1308100007' and orde_sequ_numb = '1'

select	a.*
from	mrordtlist a
where	a.orde_iden_numb = 'GEN1308070062' and a.orde_sequ_numb = '2'
--sale_sequ_numb = '33197'
--buyi_sequ_numb = 33591


select * From mssalm where sale_sequ_numb = '33588'
select * From mssalm where sale_sequ_numb = '33197'


select * from msbuym where buyi_sequ_numb = '33483'
select * from msbuym where buyi_sequ_numb = '33485'
select * from msbuym where buyi_sequ_numb = '33591'



select * from mrordtlist where buyi_sequ_numb = '33485'
select * from msbuym where buyi_sequ_numb = '33485'
select * from mptpay where buyi_sequ_numb = '33485'



select * from msbuym order by convert(int,buyi_sequ_numb) desc