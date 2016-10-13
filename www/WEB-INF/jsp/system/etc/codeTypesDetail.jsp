<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.system.dto.CodeTypesDto" %>
<%
	CodeTypesDto detailInfo   = null;
	String       codeTypeId   = null;
	String       codeTypeCd   = null;
	String       codeTypeNm   = null;
	String       codeTypeDesc = null;
	String       codeFlag     = null;
	String       isUse        = null;
	
	detailInfo = (CodeTypesDto)request.getAttribute("detailInfo");
	
	if(detailInfo != null){
		codeTypeId   = detailInfo.getCodeTypeId();
		codeTypeCd   = detailInfo.getCodeTypeCd(); 
		codeTypeNm   = detailInfo.getCodeTypeNm();
		codeTypeDesc = detailInfo.getCodeTypeDesc();
		codeFlag     = detailInfo.getCodeFlag();
		isUse        = detailInfo.getIsUse();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
</head>

<body>
<table width="100%"  border="0" cellspacing="2" cellpadding="2" align="left" bgcolor="">
	<col width="30" />
	<col width="80" />
	<tr>
		<td>&nbsp;</td>
		<td style="font-weight: bold;">* 유형코드 :</td>
		<td><%=codeTypeCd %></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td style="font-weight: bold;">* 유형명 :</td>
		<td><%=codeTypeNm %></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td style="font-weight: bold;">* 유형구분 :</td>
<%
if(codeFlag.equals("0")) {
%>
		<td>시스템코드</td>
<%
} else {
%>
		<td>사용자정의코드</td>
<%
}
%>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td style="font-weight: bold;">* 사용여부 :</td>
<%
if(isUse.equals("0")) {
%>
		<td>미사용</td>
<%
} else {
%>
		<td>사용</td>
<%
}
%>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td style="font-weight: bold;">* 유형설명 :</td>
		<td><%=codeTypeDesc %></td>
	</tr>
</table>
</body>
</html>