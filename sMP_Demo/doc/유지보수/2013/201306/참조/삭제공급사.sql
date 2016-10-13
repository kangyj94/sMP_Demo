select * from reqSMPVENDORS where VENDORID in ('304704', '304711')

select * from SMPBORGS where BORGID in ('304704', '304711')
select * from SMPVENDORS where VENDORID in ('304704', '304711')
select * from SMPBORGS_USERS where BORGID in ('304704', '304711')
select * from SMPBORGS_USERS_ROLES where BORGID in ('304704', '304711')
select * from SMPUSERS where userid in (select USERID from SMPBORGS_USERS where BORGID in ('304704', '304711'))
select * from SMPRECEIVEINFO where userid in (select USERID from SMPBORGS_USERS where BORGID in ('304704', '304711'))

