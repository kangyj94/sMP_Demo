--사업장 코드 전환건에 대한 내역
--DELETE FROM z_temp_table
SELECT * FROM z_temp_table

INSERT INTO z_temp_table (a1,a2,a3) VALUES ('ONS1307230002','안승학','ONS0000022')

select * from z_temp_table --임시 temp 테이블에 메일로 온 자료를 우선 담는다.

-- 주문번호를 자른다
select substring(a1,0,CHARINDEX('-',a1))
from	z_temp_table


update z_temp_table
set a1 = substring(a1,0,CHARINDEX('-',a1))
-- 주문번호를 자른다
--25


select	a1,a2, a3
from	z_temp_table
group by a1,a2, a3


-- 해당 주문자가 올바르게 있는지 확인
select	C.USERID
,		C.USERNM
from	SMPBORGS_USERS a
inner join SMPBORGS b
	ON	A.BORGID = B.BORGID
INNER JOIN SMPUSERS C
	ON	A.USERID = C.USERID
WHERE	B.BORGCD = 'ONS0000012'
-- 해당 주문자가 올바르게 있는지 확인


--사업장 코드에 따른 그룹 아이디, 법인 아이디, 사업장 아이디를 확인한다.
SELECT	A.groupid
,		A.clientid
,		A.branchid
,		B.A1
,		C.GROUPID
,		C.CLIENTID
,		C.BORGID
,		C.BORGNM
,		B.A3
FROM	mrordm A
INNER JOIN (
		select	a1,a2, a3
		from	z_temp_table
		group by a1,a2, a3
) B
	ON	A.orde_iden_numb = substring(B.a1,0,CHARINDEX('-',B.a1))
INNER JOIN SMPBORGS C
	ON	B.A3 = C.BORGCD

BEGIN TRAN

UPDATE	mrordm
SET		branchid = C.BORGID
FROM	mrordm A
INNER JOIN (
		select	a1,a2, a3
		from	z_temp_table
		group by a1,a2, a3
) B
	ON	A.orde_iden_numb = substring(B.a1,0,CHARINDEX('-',B.a1))
INNER JOIN SMPBORGS C
	ON	B.A3 = C.BORGCD

COMMIT TRAN	
	
rollback tran


--인수내역에도 그룹ID, 법인ID, 사업장ID가 있으므로 자료가 존재한다면 같이 업데이트 한다.
SELECT	A.groupid
,		A.clientid
,		A.branchid
,		C.GROUPID
,		C.CLIENTID
,		C.BORGID
,		B.A3
FROM	mrordtlist A
INNER JOIN (
		select	a1,a2, a3
		from	z_temp_table
		group by a1,a2, a3
) B
	ON	A.orde_iden_numb = substring(B.a1,0,CHARINDEX('-',B.a1))
INNER JOIN SMPBORGS C
	ON	B.A3 = C.BORGCD
	
BEGIN TRAN

UPDATE	mrordtlist
SET		branchid = C.BORGID
FROM	mrordtlist A
INNER JOIN (
		select	a1,a2, a3
		from	z_temp_table
		group by a1,a2, a3
) B
	ON	A.orde_iden_numb = substring(B.a1,0,CHARINDEX('-',B.a1))
INNER JOIN SMPBORGS C
	ON	B.A3 = C.BORGCD
	
COMMIT TRAN

ROLLBACK TRAN




SELECT * FROM SMPBORGS WHERE BORGCD = 'ONS0000014'

SELECT * FROM SMPBORGS WHERE BRANCHID = '304804'

