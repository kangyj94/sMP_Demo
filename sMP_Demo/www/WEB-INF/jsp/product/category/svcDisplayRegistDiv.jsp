<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmWindow {
	display: none;
	
	position: fixed;
	top: 17%;
	left: 50%;
	
	margin-left: -300px;
	width: 500px;
	
	background-color: #EEE;
	color: #333;
	border: 1px solid black;
	padding: 12px;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
	position: absolute;
	top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-------------------------------- Dialog Div Start -------------------------------->
<script type="text/javascript">
$(function() {
	$("#dialogPop").jqm();	//Dialog 초기화
	$('#dialogPop').jqm().jqDrag('#dialogHandle');
	$("#closeButton").click(function() {	//Dialog 닫기
		$('#dialogPop').jqmHide();
	});
	$("#regJqmButton").click(function() {
		fnJqmAddDisp();
	});
});

var fnBuyBorgCallback = "";
function fnDisplayRegistDialog(callbackString) {
	$("#txtJqmCateDispName").val("");
	$("#txtJqmCateDispDesc").val("");
	$("#selectJqmIsDispUse").val("1");
	fnCategoryCallback = "";
	$("#dialogPop").jqmShow();	//필수
	fnCategoryCallback = callbackString;
}

/**
 * 진열정보 입력후 Callback 호출(Parent페이지에 반드시 fnAddDispCallback 함수 존재해야 함)
 */
function fnJqmAddDisp() {
	var jqmCateDispName = document.getElementById("txtJqmCateDispName");
	var jqmCateDispDesc = document.getElementById("txtJqmCateDispDesc");
	var jqmIsDispUse = document.getElementById("selectJqmIsDispUse");
	
	if(jqmCateDispName.value == "") {
		alert("진열명을 입력해 주십시오.");
		jqmCateDispName.focus();
		return;
	} else if(jqmCateDispDesc.value == "") {
		alert("진열 설명을 입력해 주십시오.");
		jqmCateDispDesc.focus();
		return;
	} else {
		eval(fnCategoryCallback+"('"+jqmCateDispName.value+"','"+jqmCateDispDesc.value+"','"+jqmIsDispUse.value+"');");
	}
}
</script>
</head>
<body>
<div class="jqmWindow" id="dialogPop">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<div id="dialogHandle">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
					<tr>
						<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
						<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
						<td class="popup_title">진열정보 등록</td>
						<td width="22" align="right">
							<a href="#" class="jqmClose">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" /></a></td>
						<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
					</tr>
				</table>
			</div>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" /></td>
					<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
					<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
				</tr>
				<tr>
					<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
					<td bgcolor="#FFFFFF">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2" class="table_top_line"></td>
							</tr>
							<tr>
								<td colspan="2" height='1' bgcolor="eaeaea"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">진열명</td>
								<td class="table_td_contents">
									<input id="txtJqmCateDispName" name="txtJqmCateDispName" type="text" value="" size="20" maxlength="30" style="width:200px;" /></td>
							</tr>
							<tr>
								<td colspan="2" height='1' bgcolor="eaeaea"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">진열 설명</td>
								<td class="table_td_contents">
									<input id="txtJqmCateDispDesc" name="txtJqmCateDispDesc" type="text" value="" size="20" maxlength="30" style="width:300px;" /></td>
							</tr>
							<tr>
								<td colspan="2" height='1' bgcolor="eaeaea"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">사용 여부</td>
								<td class="table_td_contents">
									<select name="selectJqmIsDispUse" id="selectJqmIsDispUse">
										<option value="0">아니요</option>
										<option value="1" selected="selected">예</option>
									</select></td>
							</tr>
							<tr>
								<td colspan="2" height='1' bgcolor="eaeaea"></td>
							</tr>
							<tr>
								<td colspan="4" class="table_top_line"></td>
							</tr>
							<tr>
								<td colspan="4" height='8'></td>
							</tr>
						</table>
						
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="center">
									<a href="#"><img id="regJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_ok.gif" style="border:0;" /></a>
									<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style="border:0;" /></a>
								</td>
							</tr>
						</table>
					</td>
					<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
				</tr>
				<tr>
					<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" /></td>
					<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
					<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>