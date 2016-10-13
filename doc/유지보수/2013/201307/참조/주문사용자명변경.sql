주문 번호: SKB1304090007
기존: 김동환
변경: (합)조광통신

주문 번호: SKB041301099, SKB041303016, SKB041301014
기존: 정경남
변경: (주)광주텔레콤

주문 번호: SKB041301014
기존: 정경남
변경: (주)광주텔레콤


SELECT * FROM SMPUSERS WHERE USERNM = '(주)광주텔레콤' --300421
SELECT * FROM SMPBORGS_USERS WHERE USERID = '300421' --BUY0403568
SELECT * FROM SMPUSERS WHERE USERNM = '(합)조광통신' --t2004404


--김상철
select * from smpbranchs where branchid = '304672' --SKB 서부기술팀 (전북)_미매출

--신익희
/*
에이디텔레콤(주)_전송망시설공사_SKT수주공사
에이디텔레콤(주)_2013년광선로시설공사
에이디텔레콤(주)_전용망1군공사
*/
SELECT	b.BORGID
,		c.BORGNM
,		a.*
FROM SMPUSERS a
inner join SMPBORGS_USERS b
	on	a.USERID = b.USERID
inner join SMPBORGS c
	on	b.BORGID = c.BORGID
WHERE USERNM = '신익희' --300421



SELECT * FROM SMPUSERS WHERE USERNM = '김상철' --304672

SELECT a.*
,		b.BORGID
FROM SMPUSERS a
inner join SMPBORGS_USERS b
	on	a.USERID = b.USERID
WHERE USERNM = '신익희' --300421



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

--인수자 변경처리 건
BEGIN TRAN
/*
UPDATE mrordm SET
tran_tele_numb = '01062448756'
,tran_user_name = '신익희'
where orde_iden_numb IN ('SKB1307190001')
--인수자 변경처리 건
*/

COMMIT TRAN


ROLLBACK TRAN



SELECT * FROM SMPBORGS WHERE BORGCD = 'BUY0103665'

SELECT * FROM SMPBORGS WHERE BRANCHID = '304812'

SELECT * FROM SMPBORGS WHERE BRANCHID = '304804'