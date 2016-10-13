/*
select	*
from	mcdisplaygood
where	good_iden_numb = '10000001380'
and		areatype = '99'
order by disp_from_date desc
*/

--218
select	aa.*
from	mcdisplaygood aa
left outer join 
(
		select	a.good_iden_numb
		,		a.groupid
		,		a.clientid
		,		a.branchid
		,		a.areaType
		,		a.vendorid
		,		max(a.disp_from_date) as max_date
		,		COUNT(1) as cnt
		from	mcdisplaygood a
		where	final_good_sts = '1'
		group by a.good_iden_numb
		,		a.groupid
		,		a.clientid
		,		a.branchid
		,		a.areaType
		,		a.vendorid
		having COUNT(1) > 1
) bb
	on	aa.good_iden_numb = bb.good_iden_numb
	and	aa.groupid = bb.groupid
	and	aa.clientid = bb.clientid
	and	aa.branchid = bb.branchid
	and	aa.areaType = bb.areaType
	and	aa.vendorid = bb.vendorid
where	aa.disp_from_date <> bb.max_date


begin tran
update	mcdisplaygood
set		final_good_sts = '0'
from	mcdisplaygood aa
left outer join 
(
		select	a.good_iden_numb
		,		a.groupid
		,		a.clientid
		,		a.branchid
		,		a.areaType
		,		a.vendorid
		,		max(a.disp_from_date) as max_date
		,		COUNT(1) as cnt
		from	mcdisplaygood a
		where	final_good_sts = '1'
		group by a.good_iden_numb
		,		a.groupid
		,		a.clientid
		,		a.branchid
		,		a.areaType
		,		a.vendorid
		having COUNT(1) > 1
) bb
	on	aa.good_iden_numb = bb.good_iden_numb
	and	aa.groupid = bb.groupid
	and	aa.clientid = bb.clientid
	and	aa.branchid = bb.branchid
	and	aa.areaType = bb.areaType
	and	aa.vendorid = bb.vendorid
where	aa.disp_from_date <> bb.max_date
order by aa.good_iden_numb

commit tran

rollback tran


