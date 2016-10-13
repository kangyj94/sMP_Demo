<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	String header = request.getAttribute("header").toString();
	String manualPath = request.getAttribute("manualPath").toString();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
	.titleHeader {
		background-color:#dbeaf7; 
		font-weight:; 
		text-align:center; 
		height:20px; 
		padding-top:4px;
		font-style:arial;
		font-size:20px;
		white-space:nowrap
	}
</style>
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td>
		<!-- 타이틀 시작 -->
			<table width='100%' border='0' cellspacing='0' cellpadding='0' >
				<tr>
					<td>&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td class="table_top_line"></td>
				</tr>
				<tr>
					<td class="titleHeader" id="titleHeader" >
						<b><%=header %></b>
					</td>
				</tr>
				<tr>
					<td class="table_top_line"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width='100%' border='0' cellspacing='0' cellpadding='0' >
				<tr>
					<td>
						<img src="<%=manualPath %>" width="1030" height="720"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>