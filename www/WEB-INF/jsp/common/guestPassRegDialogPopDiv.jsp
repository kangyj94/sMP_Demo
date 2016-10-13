<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
.guestJqmWindow {
	display: none;
	
	position: fixed;
	top: 17%;
	left: 50%;
	
	margin-left: -300px;
	width: 300px;
	
	background-color: #EEE;
	color: #333;
	border: 1px solid black;
	padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .guestJqmWindow {
	position: absolute;
	top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
</head>

<body>
<div class="guestJqmWindow" id="guestPassRegDialogPop">
	<table width="300"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="guestPassRegDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_mid.gif');">
						<tr>
							<td width="21">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_left.gif" width="21" height="47" />
							</td>
							<td width="22">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px "/>
							</td>
							<td class="popup_title">
								<span>
								비밀번호 등록
								</span>
							</td>
							<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_right.gif');">&nbsp;</td>
						</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/>
						</td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="top" bgcolor="#FFFFFF">
							<!-- 타이틀 시작 -->
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="15" height="27" valign="top" >
										<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/bullet_stitle_red.gif" width="5" height="5" class="bullet_stitle" />
									</td>
									<td class="txt_notice_red">비밀번호를 입력/확인해 주십시오</td>
								</tr>
							</table>
							<!-- 타이틀 끝 -->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="80">비밀번호</td>
									<td class="table_td_contents">
										<input type="password" id="noneRegPw1Div" name="noneRegPw1Div" maxlength="15"/>
									</td>
								</tr>
								<tr>
									<td colspan="2" class="table_middle_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="80">비밀번호 확인</td>
									<td class="table_td_contents">
										<input type="password" id="noneRegPw2Div" name="noneRegPw2Div" maxlength="15"/>
									</td>
								</tr>
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
							</table>
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id='noneRegDiv' class="btn btn-primary btn-sm">
											<i class="fa fa-floppy-o fa-fw"></i>
											저장
										</button>
										<button id='noneCloseDiv' class="btn btn-default btn-sm">
											<i class="fa fa-times fa-fw"></i>
											닫기
										</button>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>

<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script type="text/javascript">
$(document).ready(function() {
	$("#guestPassRegDialogPop").jqm().jqDrag("#guestPassRegDialogHandle"); 
	$("#noneCloseDiv").on("click",function(){
		$("#guestPassRegDialogPop").jqmHide();
	});
	$("#noneRegDiv").on("click",function(){
		var noneRegPw1Div = $.trim($("#noneRegPw1Div").val());
		var noneRegPw2Div = $.trim($("#noneRegPw2Div").val());
		if(noneRegPw1Div=='' || noneRegPw2Div=='') {
			alert("암호를 입력해 주십시오!");
			$("#noneRegPw1Div").focus();
			return;
		}
		if(noneRegPw1Div!=noneRegPw2Div) {
			alert("암호를 확인해 주십시오!"); return;
		}
		var bussName = $.trim($("#bussName").val());
		var businessNum = $.trim($("#businessNum1").val()) + $.trim($("#businessNum2").val()) + $.trim($("#businessNum3").val());
		var guestPassword = $("#noneRegPw1Div").val();
		$.post(
			"/system/guestRegist.sys",
			{	bussName:bussName,
				businessNum:businessNum,
				guestPassword:guestPassword
			},
			function(arg){
				var result = eval('(' + arg + ')').customResponse;
				if(result.success == false){
					var errors = "";
					for(var i = 0; i < result.message.length; i++) { errors += result.message[i] + "\n"; }
					alert(errors);
// 					$("#dialog").html("<font size='2'>"+errors+"</font>");
// 					$("#dialog").dialog({
// 						title: 'ERROR',modal: true,
// 						buttons: {"Ok": function(){$(this).dialog("close");} }
// 					});
				} else {
					var nonUserId = result.newIdx;
					document.frm.action = "/system/guestLogin.sys?nonUserId="+nonUserId;
					document.frm.submit();
				}
			}
		);
	});
	$("#noneRegPw1Div").on("keydown",function(e){
		if(e.keyCode==13) {
			$("#noneRegPw2Div").focus(); 
			$("#noneRegPw2Div").click();
		}
	});
	$("#noneRegPw2Div").on("click",function(e){
		var noneRegPw1Div = $.trim($("#noneRegPw1Div").val());
		if(noneRegPw1Div.length<6) {
			alert("암호는 최소6자 이상 입력하십시오!");
			$("#noneRegPw1Div").focus();
			return;
		}
	})
	$("#noneRegPw2Div").on("keydown",function(e){
		if(e.keyCode==13) { $("#noneRegDiv").click(); }
	});
});
</script>

</body>
</html>