<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/redmond/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/hmro_green_tree.css" rel=StyleSheet />


<script type="text/javascript">
function fnClose(){
	if(document.frm.pop.checked){		
		setCookie('festival2', 'checked', 1);
	}
	window.close();
}

function setCookie(name, value, expiredays) {
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	//alert(value);
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
}
</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form id="frm" name="frm" method="post">
<table width="431" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/popup/img/growthProc.jpg" width="431" height="640"/></td>
	</tr>
	<tr>
		<td align="center">
			<table width="60%">
				<tr>
					<td style="vertical-align: top;">
						<input type="checkbox" name="pop" value="1" style="border: 0"/>
					</td>
					<td style="vertical-align: middle;">
						오늘 하루 이 창을 열지 않음
					</td>
					<td>
						<img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_close.gif" style="border: 0;cursor:pointer;" width="65" height="23" onclick="fnClose();"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>