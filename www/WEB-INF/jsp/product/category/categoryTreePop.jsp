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
	width: 700px;
	height: 400px;
	
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
$(function(){
	$("#closeButton").click(function(){	//Dialog 닫기
		$('#dialogPop').jqmHide();
	});
	$("#selectButton").click(function(){	//선택
		fnJqmSelectBorg();
	});
	$('#dialogPop').jqm().jqDrag('#dialogHandle'); 
});

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
						<td class="popup_title">진열카테고리 조회</td>
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
								<td>컨텐츠(그리드) 위치</td>
							</tr>
							<tr>
								<td height='8'></td>
							</tr>
						</table>
						
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="center">
									<a href="#"><img id="selectButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_select.gif" style='border:0;' /></a>
									<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border:0;' /></a>
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