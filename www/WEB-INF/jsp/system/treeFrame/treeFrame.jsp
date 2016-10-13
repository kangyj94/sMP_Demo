<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title><%=Constances.SYSTEM_SERVICE_TITLE%></title>
</head>
<frameset id="parentFrame" rows="0,*" cols="*" frameborder="NO" border="0" framespacing="0" style="size: auto;">
<!-- <frameset id="parentFrame" rows="60,*" cols="*" frameborder="NO" border="0" framespacing="0" style="size: auto;"> -->
<%-- 	<frame src="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys" name="topFrame" marginwidth="0" marginheight="0" frameborder="NO" border="0" noresize="noresize" SCROLLING="NO"> --%>
	<frame src="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/treeFrame/header.sys" name="topFrame" scrolling="No" noresize z-index="100" />
	<frameset rows="*" cols="0,*" id="bodyFrm" framespacing="0" frameborder="NO" border="0" bordercolor="#e25d5b">
<!-- 	<frameset rows="*" cols="250,*" id="bodyFrm" framespacing="0" frameborder="NO" border="0" bordercolor="#e25d5b"> -->
		<frame src="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys" name="frameMenu" marginwidth="0" marginheight="0" frameborder="NO" border="0" noresize="noresize" SCROLLING="NO">
		<frame src="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemDefault.sys?_menuId=0" name="frameMain" marginwidth="0" marginheight="0" frameborder="NO" border="0" SCROLLING="Auto">
<%-- 		<frame src="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/treeFrame/left.sys" name="frameMenu" scrolling="no" style="border: none;" /> --%>
<%-- 		<frame src="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemDefault.sys" name="frameMain" scrolling="Auto" style="border: none;" /> --%>
	</frameset>
</frameset>
</html>