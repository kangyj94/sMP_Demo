<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.Map"%>
<%
	Map<String, String> userDetailInfo = (Map<String, String>)request.getAttribute("userDetailInfo");
	String              userNm         = userDetailInfo.get("userNm");
	String              loginId        = userDetailInfo.get("loginId");
	String              tel            = userDetailInfo.get("tel");
	String              mobile         = userDetailInfo.get("mobile");
	String              email          = userDetailInfo.get("email");
	String              isEmail        = userDetailInfo.get("isEmail");
	String              isSms          = userDetailInfo.get("isSms");
%>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Global.css">
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">
<style type="text/css" media="screen">
    th.ui-th-column div{
        white-space:normal !important;
        height:auto !important;
    }
    input[type=radio]{vertical-align: middle;}
</style>
<script type="text/javascript">
$(document).ready(function(){
	$.ajaxSetup ({
        cache: false
    });
	
	$('#btnSave').click(function(e){
		fnBtnSaveOnClick();
	});
	
	$("#tel").val(fnSetTelformat($("#tel").val()));
	$("#mobile").val(fnSetTelformat($("#mobile").val()));
});

function fnBtnSaveOnClick(){
	var userNm   = $("#userNm").val();
	var password = $("#password").val();
	var tel      = $("#tel").val();
	var mobile   = $("#mobile").val();
	var email    = $("#email").val();
	var isSms    = $("#isSms").val();
	var isEmail  = $("#isEmail").val();
	
	if(userNm == ""){
		alert("사용자명을 입력하여 주시기 바랍니다.");
		
		$("#userNm").focus();
		
		return;
	}
	
	if(tel == ""){
		alert("전화번호를 입력하여 주시기 바랍니다.");
		
		$("#tel").focus();
		
		return;
	}
	
	if(mobile == ""){
		alert("핸드폰 번호를 입력하여 주시기 바랍니다.");
		
		$("#mobile").focus();
		
		return;
	}
	
	if(email == ""){
		alert("이메일을 입력하여 주시기 바랍니다.");
		
		$("#email").focus();
		
		return;
	}
	
	if(confirm("저장하시겠습니까?") == false){
		return;
	}
	
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/updateUser.sys',
		{
			userNm : userNm, password : password, tel : tel, mobile : mobile, email : email,
			isSms  : isSms,  isEmail  : isEmail
		},
		function(arg) {
			var customResponse = eval('(' + arg + ')').customResponse;
			
			if(customResponse.success == false){
				alert(customResponse.message);
			}
			else{
				alert("처리 되었습니다.");
				
				self.close();
			}
		}
	);
}
</script>
</head>
<body style="width: 450px;">
<div id="divPopup" style="width:100%;">
	<div class="popcont">
		<h2>운영사용자 수정</h2>
		<table class="InputTable" style="border: 0px;">
			<colgroup>
				<col width="100px" />
				<col width="*" />
			</colgroup>
			<tr>
				<th class="check">사용자명</th>
				<td>
					<input id="userNm" name="userNm" value="<%=userNm %>" title="사용자명" type="text" style="width:90%"/>
				</td>
			</tr>
			<tr>
				<th>사용자ID</th>
				<td><%=loginId %></td>
			</tr>
			<tr>
				<th>패스워드</th>
				<td>
					<input id="password" name="password" value="" title="패스워드" type="password" style="width:90%"/>
				</td>
			</tr>
			<tr>
				<th class="check">전화번호</th>
				<td>
					<input id="tel" name="tel" value="<%=tel %>" title="전화번호" type="text" style="width:90%"/>
				</td>
			</tr>
			<tr>
				<th class="check">핸드폰</th>
				<td>
					<input id="mobile" name="mobile" value="<%=mobile %>" title="핸드폰" type="text" style="width:90%"/>
				</td>
			</tr>
			<tr>
				<th class="check">이메일</th>
				<td>
					<input id="email" name="email" value="<%=email %>" title="이메일" type="text" style="width:90%"/>
				</td>
			</tr>
			<tr>
				<th>SMS발송</th>
				<td>
					<select id="isSms" name="isSms">
						<option value="1" <%if("1".equals(isSms)) {%> selected="selected" <%} %>>발송</option>
						<option value="0" <%if("0".equals(isSms)) {%> selected="selected" <%} %>>미발송</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>Email발송</th>
				<td>
					<select id="isEmail" name="isEmail">
						<option value="1" <%if("1".equals(isEmail)) {%> selected="selected" <%} %>>발송</option>
						<option value="0" <%if("0".equals(isEmail)) {%> selected="selected" <%} %>>미발송</option>
					</select>
				</td>
			</tr>
		</table>
		<div class="Ac mgt_10">
			<button id="btnSave" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
			<button type="button" class="btn btn-default btn-sm btnClose" onclick="javascript:self.close();"><i class="fa fa-times"></i> 닫기</button>  
		</div>
	</div>
</div>
</body>
</html>