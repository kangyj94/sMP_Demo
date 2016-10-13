<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<%
	/*######################## Important(사이트 첫 페이지에서 아래 3변수을 초기화)  ########################*/
	/*###########만약 framework.properties 에서 아래 3변수에 대해 초기화 되어 있으면 초기화된 변수을 읽어 들임###########*/
	if(Constances.SYSTEM_CONTEXT_PATH==null || "".equals(Constances.SYSTEM_CONTEXT_PATH))
		Constances.SYSTEM_CONTEXT_PATH = request.getContextPath();
	if(Constances.SYSTEM_IMAGE_URL==null || "".equals(Constances.SYSTEM_IMAGE_URL))
		Constances.SYSTEM_IMAGE_URL = request.getContextPath();
	if(Constances.SYSTEM_JSCSS_URL==null || "".equals(Constances.SYSTEM_JSCSS_URL))
		Constances.SYSTEM_JSCSS_URL = request.getContextPath();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	$('#loginDialogPop').jqm();	//loginDialog 초기화
	
	$("#loginId").focus();
	$("#loginId").css("ime-mode", "disabled");
	$("#password").css("ime-mode", "disabled");
	$("#loginId").keydown(function(e){
		if(e.keyCode==13) {
			$("#password").focus();
		}
	});
	$("#password").keydown(function(e){
		if(e.keyCode==13) {
			$("#enter").click();
		}
	});
	$("#enter").click(function(){
		var loginId = $.trim($("#loginId").val());
		var password = $.trim($("#password").val());
		if(loginId.length==0) {
			alert("아이디를 입력해 주십시오!");
			$("#loginId").val(loginId);
			$("#loginId").focus();
			return;
		}
		if(password.length==0) {
			alert("패스워드를 입력해 주십시오!");
			$("#password").val(password);
			$("#password").focus();
			return;
		}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/loginCheckPop.sys", 
			{ loginId:loginId, password:password },
			function(arg){
				if(fnTransResult(arg, false)) {
					var result = eval('(' + arg + ')').customResponse;
					var mobile = "";
					for (var i = 0; i < result.message.length; i++) {
						mobile +=  result.message[i];
					}
					if(mobile!="") {	//모바일인증일 경우만 mobile가 넘어옴
						$('#loginDialogPop').jqmShow();	//모바일인증 화면 Display
						fnJqmAuthInit(mobile);	//초기화
					} else {
						fnLogin();
					}
				}
			}
		);
	});
	
	$("#reqBorg").click(function(){
		var popurl = "/organ/reqBranchPop.sys";
		var popproperty = "dialogWidth:970px;dialogHeight=900px;scroll=auto;status=no;resizable=no;";
// 		window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=970, height=900, scrollbars=yes, status=no, resizable=no');
	});

	$("#reqVen").click(function(){
		var popurl = "/organ/reqVendorPop.sys";
		var popproperty = "dialogWidth:910px;dialogHeight=750px;scroll=auto;status=no;resizable=no;";
// 		window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=910, height=750, scrollbars=yes, status=no, resizable=no');
	});
	
	
	$("#password").val('1111');
// 	fnLogin();
	
});

function fnLogin() {
	document.frm.action = "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemLogin.sys";
	document.frm.submit();
}
</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<table cellpadding="2" cellspacing='0' border='0' align="center">
	<tr>
		<td bgcolor="blue">
			<table cellpadding='0' cellspacing='0' border='0' width='100%'>
				<tr>
					<td bgcolor="blue" align=center style="padding:2;padding-bottom:4" height="25">
						<font size=-1 color="white" face="verdana,arial"><b>Enter your login and password</b></font>
					</td>
				</tr>
				<tr>
					<td bgcolor="white" style="padding:5">
						<br/>
						<center>
						<table>
							<tr>
								<td align="left" width="100px"><font face="verdana,arial" size=-1>LoginId:</font></td>
								<td align="left"><input type="text" name="loginId" id="loginId" value="agent1"/></td>
							</tr>
							<tr>
								<td align="left"><font face="verdana,arial" size=-1>Password:</font></td>
								<td align="left"><input type="password" name="password" id="password"/></td>
							</tr>
							<tr>
								<td><font face="verdana,arial" size=-1>&nbsp;</font></td>
								<td align="left">
									<font face="verdana,arial" size=-1>
									<input type="button" name="enter" id="enter" value="Enter"/>
									</font>
								</td>
							</tr>
							<tr>
								<td colspan=2><font face="verdana,arial" size=-1>&nbsp;</font></td>
							</tr>
							<tr>
								<td colspan=2>
									<font face="verdana,arial" size=-1>Lost your username or password? Find it</font> 
									<a href="javascript:alert('Ask The System Administrator');">here</a>!
								</td>
							</tr>
							<tr>
								<td colspan=2>
									<font face="verdana,arial" size=-1>Not member yet? Click</font> 
									<a href="javascript:alert('Ask The System Administrator');">here</a> to register.
								</td>
							</tr>
						</table>
						<!-- 사업장 등록 추가 Start -->
						<table>
							<tr>
								<td colspan=2><font face="verdana,arial" size=-1>&nbsp;</font></td>
							</tr>
							<tr>
								<td colspan=2>
									<a id="reqBorg" href="#">고객법인 등록</a>
								</td>
							</tr>
							<tr>
								<td colspan=2>
									<a id="reqVen" href="#">공급사 등록</a>
								</td>
							</tr>
						</table>
						<!-- 사업장 등록 추가 End -->
						</center>
					</td>
				</tr>
			</table>
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
		</td>
	</tr>
</table>
<%@ include file="/loginCheckPup.jsp" %>
</form>
</body>
</html>