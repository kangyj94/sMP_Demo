�ֹ� ��ȣ: SKB1304090007
����: �赿ȯ
����: (��)�������

�ֹ� ��ȣ: SKB041301099, SKB041303016, SKB041301014
����: ���泲
����: (��)�����ڷ���

�ֹ� ��ȣ: SKB041301014
����: ���泲
����: (��)�����ڷ���


SELECT * FROM SMPUSERS WHERE USERNM = '(��)�����ڷ���' --300421
SELECT * FROM SMPBORGS_USERS WHERE USERID = '300421' --BUY0403568
SELECT * FROM SMPUSERS WHERE USERNM = '(��)�������' --t2004404


--���ö
select * from smpbranchs where branchid = '304672' --SKB ���α���� (����)_�̸���

--������
/*
���̵��ڷ���(��)_���۸��ü�����_SKT���ְ���
���̵��ڷ���(��)_2013�Ɽ���νü�����
���̵��ڷ���(��)_�����1������
*/
SELECT	b.BORGID
,		c.BORGNM
,		a.*
FROM SMPUSERS a
inner join SMPBORGS_USERS b
	on	a.USERID = b.USERID
inner join SMPBORGS c
	on	b.BORGID = c.BORGID
WHERE USERNM = '������' --300421



SELECT * FROM SMPUSERS WHERE USERNM = '���ö' --304672

SELECT a.*
,		b.BORGID
FROM SMPUSERS a
inner join SMPBORGS_USERS b
	on	a.USERID = b.USERID
WHERE USERNM = '������' --300421



SELECT * FROM mrordm WHERE orde_iden_numb IN ('SKB1307190001')


SELECT	A.orde_iden_numb
,		A.groupid
,		A.clientid
,		A.branchid
,		A.orde_user_id
,		(SELECT BORGNM FROM SMPBORGS WHERE BORGID = A.clientid)
,		(SELECT BORGNM FROM SMPBORGS WHERE BORGID = A.branchid)
,		(SELECT USERNM FROM SMPUSERS WHERE USERID = A.orde_user_id)
FROM	mrordm A
WHERE	A.orde_iden_numb IN ('SKB1304090007')



SELECT	A.orde_iden_numb
,		A.clin_user_id
,		(SELECT USERNM FROM SMPUSERS WHERE USERID = A.clin_user_id)
FROM	mrpurt A
WHERE	A.orde_iden_numb IN ('SKB1304090007')


SELECT	A.orde_iden_numb
,		A.rece_proc_id
,		(SELECT USERNM FROM SMPUSERS WHERE USERID = A.rece_proc_id)
FROM	mracpt A
WHERE	A.orde_iden_numb IN ('SKB1304090007')


SELECT	A.orde_iden_numb
,		A.groupid
,		A.clientid
,		A.branchid
,		A.orde_user_id
,		(SELECT BORGNM FROM SMPBORGS WHERE BORGID = A.clientid)
,		(SELECT BORGNM FROM SMPBORGS WHERE BORGID = A.branchid)
,		(SELECT USERNM FROM SMPUSERS WHERE USERID = A.orde_user_id)
FROM	mrordtlist A
WHERE	A.orde_iden_numb IN ('SKB1304090007')



BEGIN TRAN
/*
UPDATE	mrordm
SET		orde_user_id = 't2004404'
WHERE	orde_iden_numb IN ('SKB1304090007')
*/

BEGIN TRAN
/*
UPDATE	mrordtlist
SET		orde_user_id = 't2004404'
WHERE	orde_iden_numb IN ('SKB1304090007')
*/


COMMIT TRAN

ROLLBACK TRAN



SELECT	A.orde_iden_numb
,		A.groupid
,		A.clientid
,		A.branchid
,		A.orde_user_id
,		(SELECT BORGNM FROM SMPBORGS WHERE BORGID = A.clientid)
,		(SELECT BORGNM FROM SMPBORGS WHERE BORGID = A.branchid)
,		(SELECT USERNM FROM SMPUSERS WHERE USERID = A.orde_user_id)
FROM	mrordm A
WHERE	A.orde_iden_numb IN ('SKB1307190001')

--jeju456

SELECT	A.orde_iden_numb
,		A.clin_user_id
,		(SELECT USERNM FROM SMPUSERS WHERE USERID = A.clin_user_id)
FROM	mrpurt A
WHERE	A.orde_iden_numb IN ('SKB1307190001')

select * from mrordtlist where orde_iden_numb IN ('SKB1307190001')






select * from mrordm where orde_iden_numb IN ('SKB1307190001')

--�μ��� ����ó�� ��
BEGIN TRAN
/*
UPDATE mrordm SET
tran_tele_numb = '01062448756'
,tran_user_name = '������'
where orde_iden_numb IN ('SKB1307190001')
--�μ��� ����ó�� ��
*/

COMMIT TRAN


ROLLBACK TRAN



SELECT * FROM SMPBORGS WHERE BORGCD = 'BUY0103665'

SELECT * FROM SMPBORGS WHERE BRANCHID = '304812'

SELECT * FROM SMPBORGS WHERE BRANCHID = '304804'