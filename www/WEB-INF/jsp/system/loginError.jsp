<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%
	Exception exception = (Exception)request.getAttribute("exception");
	String errorMsgString = "";
	String errorMsg = "";
	if(exception != null) {
		errorMsgString = exception.toString();
		errorMsg = errorMsgString.substring(errorMsgString.indexOf(":")+1);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=Constances.SYSTEM_SERVICE_TITLE%></title>
<script type="text/javascript">
<%	if(!"".equals(errorMsg)) {	%>
	alert("<%=errorMsg%>");
	parent.location.href="<%=request.getContextPath() %><%=Constances.SYSTEM_LOGIN_PATH %>";
<%	}	%>
</script>
</head>
</html>