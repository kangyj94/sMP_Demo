select * from mrordm where orde_iden_numb = 'SKB1304160002' --LKTN3456
--tran_user_name = '엘케이테크넷(주)'
--regi_user_id = 'LKTN3456'

begin tran
update mrordm set
tran_user_name = '엘케이테크넷(주)'
,regi_user_id = 'LKTN3456'
where orde_iden_numb = 'SKB1304160002'

commit tran


select * from mrordt where orde_iden_numb = 'SKB1304160002' --LKTN3456
select * from mrpurt where orde_iden_numb = 'SKB1304160002' --LKTN3456
select * from mracpt where orde_iden_numb = 'SKB1304160002' --LKTN3456
select * from mrordtlist where orde_iden_numb = 'SKB1304160002' --LKTN3456
--orde_user_id = 'LKTN3456'

begin tran
update mrordtlist set
orde_user_id = 'LKTN3456'
where orde_iden_numb = 'SKB1304160002'

select * From SMPUSERS where USERNM = '엘케이테크넷(주)'



SELECT * FROM SMPUSERS WHERE LOGINID = 'hanwoo22'


SELECT * FROM MSG_DATA WHERE CALL_TO = '01025748887'



select * from mrordm where orde_iden_numb = 'SKB1304260008'
select * from mrordtlist where orde_iden_numb = 'SKB1304260008'
select * From SMPUSERS where USERNM = '제이케이앤티' --jknt3



begin tran
update mrordm set
tran_user_name = '제이케이앤티'
,orde_user_id = 'jknt3'
,regi_user_id = 'jknt3'
where orde_iden_numb = 'SKB1304260008'

begin tran
update mrordtlist set
orde_user_id = 'jknt3'
where orde_iden_numb = 'SKB1304260008'

rollback tran
commit tran



SELECT * FROM 