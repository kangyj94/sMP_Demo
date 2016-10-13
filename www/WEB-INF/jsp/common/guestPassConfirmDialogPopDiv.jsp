<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<div class="guestJqmWindow" id="guestPassConfirmDialogPop">
	<table width="300"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="guestPassConfirmDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_mid.gif');">
						<tr>
							<td width="21">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_left.gif" width="21" height="47" />
							</td>
							<td width="22">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px "/>
							</td>
							<td class="popup_title">
								<span id="loginCheckSpan">
								비밀번호 확인
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
									<td class="txt_notice_red">비밀번호를 입력해 주십시오</td>
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
										<input type="password" id="nonePwDiv" name="nonePwDiv" maxlength="15"/>
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
										<button id='nonePwConfirmDiv' class="btn btn-primary btn-sm" href="#">
											<i class="fa fa-check fa-fw"></i>
											확인
										</button>
										<button id='nonePwCloseDiv' class="btn btn-default btn-sm" href="#">
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
	$("#guestPassConfirmDialogPop").jqm().jqDrag("#guestPassConfirmDialogHandle");
	$("#nonePwCloseDiv").on("click",function(){
		$("#guestPassConfirmDialogPop").jqmHide();
	});
	
	$("#nonePwConfirmDiv").on("click",function(){
		var nonePwDiv = $.trim($("#nonePwDiv").val());
		if(nonePwDiv=='') {
			alert("암호를 입력해 주십시오!");
			$("#nonePwDiv").focus();
			return;
		}
		var businessNum = $.trim($("#businessNum1").val()) + $.trim($("#businessNum2").val()) + $.trim($("#businessNum3").val());
		$.post(
			"/system/guestConfirm.sys",
			{
				businessNum:businessNum,
				guestPassword:nonePwDiv
			},
			function(arg){
				var result = eval('(' + arg + ')').customResponse;
				if(result.success == false){
					alert("암호를 확인해 주십시오\n암호를 잊어 버렸을 경우 고객지원센타로 연락주십시오");
// 					var errors = "";
// 					$("#dialog").html("<font size='2'>암호를 확인해 주십시오<br/>암호를 잊어버렸을 경우 고객지원센타로 연락주십시오</font>");
// 					$("#dialog").dialog({
// 						title: '암호확인',modal: true,
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
});
</script>
</body>
</html>