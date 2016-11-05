<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%
   String listHeight = "50"; //그리드의 width와 Height을 정의

   @SuppressWarnings("unchecked")   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList    = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   String              borgId      = (String)request.getAttribute("borgId");
   SmpUsersDto         userDto     = (SmpUsersDto)request.getAttribute("userDto");
   LoginUserDto        userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>


<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	//전화번호 형식으로
	$("#tel").val(  fnSetTelformat($("#tel").val()) );
	$("#mobile").val( fnSetTelformat($("#mobile").val()) );
	$("#srcUserNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});

	$("#saveButton").click(function(){
		fnApply();
	});
	//주문결제사용여부
	$("#isOrderApproval").change(function() {
		if($(this).val()=="0") {
			$.post(
				"/organ/selectBranchApprovalOrderCnt/branchApprovalOrderCnt/object.sys", 
				{ branchId:'<%=userDto.getBorgId() %>',userId:'<%=userDto.getUserId() %>' },
				function(arg){
					var result = eval('(' + arg + ')').branchApprovalOrderCnt;
					var orderCnt = $.number(orderCnt);
					if(orderCnt!=0) {
						alert("주문승인중 상태의 주문이 존재합니다.\n주문결제 사용을 미사용 하기 위해서는 모든승인이 완료되어야 합니다.");
						$("#isOrderApproval").val("1");
					}
				}
			);
		}
	});
});
</script>


<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnChangeChkValue(obj){
	var chgObj = "$('#" + obj + "')";
	   
   	if(obj == "isEmail"){
    	if(eval(chgObj).val() == "0"){
 		   	$("#emailByPurchase").val("0");
		   	$("#emailByDelivery").val("0");
		   	$("#emailByRegisterGood").val("0");		   
		   
		   	$("#emailByPurchase").attr("checked", false);
		   	$("#emailByDelivery").attr("checked", false);
		   	$("#emailByRegisterGood").attr("checked", false);   	           
      	} else {
 		   	$("#emailByPurchase").val("1");
		   	$("#emailByDelivery").val("1");
		   	$("#emailByRegisterGood").val("1");		   
		   
		   	$("#emailByPurchase").attr("checked", true);
		   	$("#emailByDelivery").attr("checked", true);
		   	$("#emailByRegisterGood").attr("checked", true);   	
      	}
   	}else if(obj == "isSms") {
    	if(eval(chgObj).val() == "0"){
 		   	$("#smsByPurchase").val("0");
		   	$("#smsByDelivery").val("0");
		   	$("#smsByRegisterGood").val("0");      		   

		   	$("#smsByPurchase").attr("checked", false);
		   	$("#smsByDelivery").attr("checked", false);
		   	$("#smsByRegisterGood").attr("checked", false);              
      	} else {
 		   	$("#smsByPurchase").val("1");
		   	$("#smsByDelivery").val("1");
		   	$("#smsByRegisterGood").val("1");      		   

		   	$("#smsByPurchase").attr("checked", true);
		   	$("#smsByDelivery").attr("checked", true);
		   	$("#smsByRegisterGood").attr("checked", true);           
      	}      
   	}

   	if(obj.indexOf("email") != -1) {
   		if(eval(chgObj).val()=="0") eval(chgObj).val("1");
  		else if(eval(chgObj).val()=="1") eval(chgObj).val("0");
      	
  		if($("#isEmail").val() == "0"){
      		$("#isEmail").val("1");
      	}else{
      		if($("#emailByPurchase").val() == "0" 
      		&& $("#emailByDelivery").val() == "0" 
      		&& $("#emailByRegisterGood	").val() == "0"){
      			$("#isEmail").val("0");
      		}
      	}     
   	}else if(obj.indexOf("sms") != -1) {
   		if(eval(chgObj).val()=="0") eval(chgObj).val("1");
  		else if(eval(chgObj).val()=="1") eval(chgObj).val("0");
      	
  		if($("#isSms").val() == "0"){
      		$("#isSms").val("1");
      	}else{
      		if($("#smsByPurchase").val() == "0" 
      		&& $("#smsByDelivery").val() == "0" 
      		&& $("#smsByRegisterGood").val() == "0"){
      			$("#isSms").val("0");
      		}
      	}
   	}
}


function fnIsValidation(){
	var userNm = $.trim($("#userNm").val());
	var loginId = $.trim($("#loginId").val());
	var pwd = $.trim($("#pwd").val());
	var pwdConfirm = $.trim($("#pwdConfirm").val());
	var tel = $.trim($("#tel").val());
	var mobile = $.trim($("#mobile").val());
	var eMail = $.trim($("#eMail").val());
	var isUse = $.trim($("#isUse").val());
	
	if(userNm == ""){
		$("#dialog").html("<font size='2'>성명을 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return false;
	}
	
	if(loginId == ""){
		$("#dialog").html("<font size='2'>로그인ID를 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return false;
	}

	if(pwd == ""){
		$("#dialog").html("<font size='2'>비밀번호를 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return false;
	}

	if(pwdConfirm == ""){
		$("#dialog").html("<font size='2'>비밀번호확인을 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return false;
	}else{
		if(pwd != pwdConfirm){
	 		$("#dialog").html("<font size='2'>입력하신 비밀번호가 다릅니다. \n다시확인해주세요.</font>");
			$("#dialog").dialog({
				title: 'Success',modal: true,
				buttons: {"Ok": function(){$(this).dialog("close");} }
			});						 
			
			return false;
		}
	}

	if(tel == ""){
		$("#dialog").html("<font size='2'>전화번호를 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return false;
	}

	if(mobile == ""){
		$("#dialog").html("<font size='2'>이동전화번호를 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return false;
	}
	 
	if(eMail == ""){
		$("#dialog").html("<font size='2'>E-MAIL을 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return false;
	}else{
		email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
		if(!email_regex.test(eMail)){
			$("#dialog").html("<font size='2'>E-MAIL 유형을 확인해주세요.</font>");
			$("#dialog").dialog({
				title: 'Success',modal: true,
				buttons: {"Ok": function(){$(this).dialog("close");} }
			});				 
			return false; 
		}
	}		

	if(isUse == ""){
		$("#dialog").html("<font size='2'>상태를 선택해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return false;
	}
	return true;
}

function fnApply(){
	var isValidation = fnIsValidation();
	if(isValidation == true){
		if(!confirm("수정한 내용을 저장하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveUserDetail.sys", 
			{	
				oper:"upd", 
				userId:$.trim($("#userId").val()),
				userNm:$.trim($("#userNm").val()),
				loginId:$.trim($("#loginId").val()),
				borgId:'<%=borgId%>',
				pwd:$.trim($("#pwd").val()),
				tel:$.trim($("#tel").val()),
				mobile:$.trim($("#mobile").val()),
				eMail:$.trim($("#eMail").val()),
				isUse:$.trim($("#isUse").val()),
				endCauseDesc:$.trim($("#endCauseDesc").val()),
				userNote:$.trim($("#userNote").val()),
				isEmail:$.trim($("#isEmail").val()),
				isSms:$.trim($("#isSms").val()),
				emailByPurchase:$.trim($("#emailByPurchase").val()),
				emailByDelivery:$.trim($("#emailByDelivery").val()),
				emailByRegisterGood:$.trim($("#emailByRegisterGood").val()),
				smsByPurchase:$.trim($("#smsByPurchase").val()),
				smsByDelivery:$.trim($("#smsByDelivery").val()),
				smsByRegisterGood:$.trim($("#smsByRegisterGood").val()),
				isOrderApproval:$("#isOrderApproval").val(),
				isDefaultBorgs:$.trim($("#isDefaultBorgs").val())
			},
			function(arg){
				if(fnAjaxTransResult(arg)) {
				}
			}
		);
	}
}
</script>
</head>
<body>
<form id="frm" name="frm" onsubmit="return false;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3">
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>사용자 상세</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
				<tr>
					<td width="20" valign="top">
						<img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
					</td>
					<td class="stitle">사용자 정보</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<!-- 컨텐츠 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject">사업장</td>
					<td colspan="3" class="table_td_contents">
						<input id="branchNm" name="branchNm" type="text" value="<%=userDto.getBranchNm() %>" size="" maxlength="50" style="width: 80%" class="input_text_none" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="background-color:darkgray;">성명</td>
					<td colspan="3" class="table_td_contents">
						<input id="userId" name="userId" type="hidden" value="<%=userDto.getUserId() %>" size="20" maxlength="30" />
						<input id="userNm" name="userNm" type="text" value="<%=userDto.getUserNm() %>" size="20" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">아이디</td>
					<td colspan="3" class="table_td_contents">
						<input id="loginId" name="loginId" type="text" value="<%=userDto.getLoginId() %>" size="20" maxlength="30" class="input_text_none" disabled="disabled"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100" style="background-color:darkgray;">
						비밀번호
						<button class="btn btn-darkgray btn-xs" onClick="window.open('/findPw.jsp','findPw','width=415, height=250')">SMS전송</button>
					</td>
					<td class="table_td_contents">
						<input id="pwd" name="pwd" type="password" value="<%=userDto.getPwd() %>" size="20" maxlength="30" style="ime-mode: disabled;"/>
					</td>
					<td class="table_td_subject" width="100" style="background-color:darkgray;">비밀번호 확인</td>
					<td class="table_td_contents">
						<input id="pwdConfirm" name="pwdConfirm" type="password" value="<%=userDto.getPwd() %>" size="20" maxlength="30" style="ime-mode: disabled;"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100" style="background-color:darkgray;">전화번호</td>
					<td colspan="3" class="table_td_contents">
						<input id="tel" name="tel" type="text" value="<%=userDto.getTel() %>" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100" style="background-color:darkgray;">이동전화번호</td>
					<td colspan="3" class="table_td_contents">
						<input id="mobile" name="mobile" type="text" value="<%=userDto.getMobile() %>" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="background-color:darkgray;">이메일</td>
					<td colspan="3" class="table_td_contents">
						<input id="eMail" name="eMail" type="text" value="<%=userDto.geteMail() %>" size="40" maxlength="40" style="ime-mode: disabled;"/> ex)admin@unpamsbank.com
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="background-color:darkgray;">상태</td>
					<td class="table_td_contents">
						<select class="select" id="isUse" name="isUse" >
							<option value="1" <%=userDto.getIsUse().equals("1") ? "selected" : "" %>>정상</option>
							<option value="0" <%=userDto.getIsUse().equals("0") ? "selected" : "" %>>종료</option>
						</select>
					</td>
					<td class="table_td_subject9">주문결재자 여부</td>
					<td class="table_td_contents">
						<select class="select" id="isOrderApproval" name="isOrderApproval">
							<option value="0">아니요</option>
<%	if("1".equals(userDto.getIsBranchOrderApproval())) {	//사업장의 주문결재여부가 [예] 인경우	%>
							<option value="1" <%=("1".equals(userDto.getIsOrderApproval())) ? "selected" : "" %> >예</option>
<%	} %>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">종료사유</td>
					<td colspan="3" class="table_td_contents">
						<input id="endCauseDesc" name="endCauseDesc" type="text" value="<%=userDto.getEndCauseDesc() == null ? "" : userDto.getEndCauseDesc() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">참고사항</td>
					<td colspan="3" class="table_td_contents">
						<input id="userNote" name="userNote" type="text" value="<%=userDto.getUserNote() == null ? "" : userDto.getUserNote() %>" size="20" maxlength="30" style="width: 98%" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
							<tr>
								<td width="50%">이메일 발송</td>
								<td>&nbsp;</td>
								<td>
									<select class="select" id="isEmail" name="isEmail" onchange="fnChangeChkValue('isEmail')">
										<option value="1" <%=userDto.getIsEmail().equals("1") ? "selected" : "" %>>발송</option>
										<option value="0" <%=userDto.getIsEmail().equals("0") ? "selected" : "" %>>미발송</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
					<td colspan="3" class="table_td_contents">  
						<label>
							<input id="emailByPurchase" name="emailByPurchase" class="input_none radio" type="checkbox" value="<%=userDto.getEmailByPurchase() %>" style="vertical-align: middle;top:3px; " 
							<%=userDto.getEmailByPurchase().equals("1") ? "checked" : "" %> onclick="javaScript:fnChangeChkValue('emailByPurchase');"/> 발주접수
						</label> 
						<label>
							<input id="emailByDelivery" name="emailByDelivery" class="input_none radio" type="checkbox" value="<%=userDto.getEmailByDelivery() %>"  style="vertical-align: middle;top:3px; "
							<%=userDto.getEmailByDelivery().equals("1") ? "checked" : "" %> onclick="javaScript:fnChangeChkValue('emailByDelivery');"/> 출하
						</label> 
						<label>
							<input id="emailByRegisterGood" name="emailByRegisterGood" class="input_none radio" type="checkbox" value="<%=userDto.getEmailByRegisterGood() %>" style="vertical-align: middle;top:3px; " 
							<%=userDto.getEmailByRegisterGood().equals("1") ? "checked" : "" %> onclick="javaScript:fnChangeChkValue('emailByRegisterGood');"/> 상품등록처리
						</label> 
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
							<tr>
								<td width="50%">SMS 발송</td>
								<td>&nbsp;</td>
								<td>
									<select class="select" id="isSms" name="isSms" onchange="fnChangeChkValue('isSms')">
										<option value="1" <%=userDto.getIsSms().equals("1") ? "selected" : "" %>>발송</option>
										<option value="0" <%=userDto.getIsSms().equals("0") ? "selected" : "" %>>미발송</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
					<td colspan="3" class="table_td_contents">
						<label>
							<input id="smsByPurchase" name="smsByPurchase" class="input_none radio" type="checkbox" value="<%=userDto.getSmsByPurchase() %>"  style="vertical-align: middle;top:3px; "
							<%=userDto.getSmsByPurchase().equals("1") ? "checked" : "" %> onclick="javaScript:fnChangeChkValue('smsByPurchase');"/> 발주접수
						</label> 
						<label>
							<input id="smsByDelivery" name="smsByDelivery" class="input_none radio" type="checkbox" value="<%=userDto.getSmsByDelivery() %>"  style="vertical-align: middle;top:3px; "
							<%=userDto.getSmsByDelivery().equals("1") ? "checked" : "" %> onclick="javaScript:fnChangeChkValue('smsByDelivery');"/> 출하
						</label> 
						<label>
							<input id="smsByRegisterGood" name="smsByRegisterGood" class="input_none radio" type="checkbox" value="<%=userDto.getSmsByRegisterGood() %>"  style="vertical-align: middle;top:3px; "
							<%=userDto.getSmsByRegisterGood().equals("1") ? "checked" : "" %> onclick="javaScript:fnChangeChkValue('smsByRegisterGood');"/> 상품등록처리
						</label> 
					</td>
				</tr>
				<tr>
					<td class="table_td_subject">
						사용자 기본조직
					</td>
					<td colspan="3" class="table_td_contents">
						<select class="select" id="isDefaultBorgs" name="isDefaultBorgs" <%if(userInfoDto.getUserId().equals(userDto.getUserId())){ %> disabled="disabled" <%} %>>
<%
	@SuppressWarnings("unchecked")
	List<SmpUsersDto> branchList = (List<SmpUsersDto>)request.getAttribute("branchList");

	if(branchList != null && branchList.size() > 0){
		for(int i = 0 ; i < branchList.size() ; i++){
%>
							<option value="<%=branchList.get(i).getBorgId() %>" <%=branchList.get(i).getIsDefault().equals("1") ? "selected" : "" %> ><%=branchList.get(i).getBranchNm() %></option>
<%			
		}
	}
%>
						</select> 
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td align="center" colspan="3">
			<button id='saveButton' class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
			<button id='closeButton' class="btn btn-default btn-sm" onclick="javaScript:window.close();"><i class="fa fa-times"></i> 닫기</button>
		</td>
	</tr>
</table>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>      
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>