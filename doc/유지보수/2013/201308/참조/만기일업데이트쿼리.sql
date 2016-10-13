select	a.clos_sale_date
,		a.expiration_date
,		a.clos_sale_date+100
,		a.*
from	mssalm a
where	a.sap_jour_numb is not null
and		a.sale_tota_amou > isnull(a.pay_amou,0)
and		a.tran_stat_flag = 0
and		a.expiration_date <> a.clos_sale_date+100
--495
/*
begin tran
update	mssalm
set		expiration_date = clos_sale_date+100
where	sap_jour_numb is not null
and		sale_tota_amou > isnull(pay_amou,0)
and		tran_stat_flag = 0

commit tran

rollback tran
*/