--����� �ڵ� ��ȯ�ǿ� ���� ����
--DELETE FROM z_temp_table
SELECT * FROM z_temp_table

INSERT INTO z_temp_table (a1,a2,a3) VALUES ('ONS1307230002','�Ƚ���','ONS0000022')

select * from z_temp_table --�ӽ� temp ���̺� ���Ϸ� �� �ڷḦ �켱 ��´�.

-- �ֹ���ȣ�� �ڸ���
select substring(a1,0,CHARINDEX('-',a1))
from	z_temp_table


update z_temp_table
set a1 = substring(a1,0,CHARINDEX('-',a1))
-- �ֹ���ȣ�� �ڸ���
--25


select	a1,a2, a3
from	z_temp_table
group by a1,a2, a3


-- �ش� �ֹ��ڰ� �ùٸ��� �ִ��� Ȯ��
select	C.USERID
,		C.USERNM
from	SMPBORGS_USERS a
inner join SMPBORGS b
	ON	A.BORGID = B.BORGID
INNER JOIN SMPUSERS C
	ON	A.USERID = C.USERID
WHERE	B.BORGCD = 'ONS0000012'
-- �ش� �ֹ��ڰ� �ùٸ��� �ִ��� Ȯ��


--����� �ڵ忡 ���� �׷� ���̵�, ���� ���̵�, ����� ���̵� Ȯ���Ѵ�.
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


--�μ��������� �׷�ID, ����ID, �����ID�� �����Ƿ� �ڷᰡ �����Ѵٸ� ���� ������Ʈ �Ѵ�.
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

