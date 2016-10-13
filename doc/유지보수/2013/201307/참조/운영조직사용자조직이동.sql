select * from SMPUSERS where LOGINID = 'sktelecom'

select * from SMPBORGS_USERS where USERID = 'sktelecom'

select * from SMPBORGS where BORGID = '13'

--delete SMPBORGS_USERS where USERID = 'sktelecom'

select * from SMPBORGS where BORGCD = 'BUY0203370' --BUY0203370

update	SMPBORGS_USERS
set		BORGID = 'BUY0203370'
where	USERID = 'sktelecom'


select * from SMPBORGS_USERS_ROLES where USERID = 'sktelecom'
--delete SMPBORGS_USERS_ROLES where USERID = 'sktelecom'



select * from SMPBORGS WHERE BRANCHID = '304812'

select * from SMPBORGS WHERE BRANCHID = '304804'

select * from SMPBORGS WHERE BRANCHID = 'BUY0103665'

select * from SMPBRANCHS WHERE BRANCHID = 'BUY0103665'

select * from SMPBRANCHS WHERE BRANCHID = '304804'

select * from SMPBRANCHS WHERE BRANCHID = '304812'

SELECT * FROM SMPBRANCHS WHERE BUSINESSNUM = '1078737395'