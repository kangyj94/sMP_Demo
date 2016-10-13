<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	String individualContractDetail = request.getAttribute("individualContractDetail").toString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
	
</script>
</head>
<body>
<div id="contractHeader">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td>
			<!-- 타이틀 시작 -->
				<table width='100%' border='0' cellspacing='0' cellpadding='0' >
					<tr>
						<td width="757" height='64' align='left' rowspan="2">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/i_contract.gif" width="100%" height="48" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
			<!-- 타이틀 시작 -->
		<tr>
			<td>
				<table width='100%' border='0' cellspacing='0' cellpadding='0' >
					<tr>
						<td width='757' height="80">
							<div id="contractContents" style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:720px; height:690px;; padding:10px 10px 10px 10px;" >
								<%=individualContractDetail%>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
			<!-- 타이틀 끝 -->	
	</table>
</div>
</body>
</html>