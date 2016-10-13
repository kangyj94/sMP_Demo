<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%
	List<Map<String, Object>> cate          = (List<Map<String, Object>>)session.getAttribute("cate");
	List<BoardDto>            noticeList    = (List<BoardDto>)request.getAttribute("noticeList");
	List<BoardDto>            emergencyList = (List<BoardDto>)request.getAttribute("emergencyList");
	Map<String,Object>        smileEvalInfo = (Map<String, Object>)request.getAttribute("smileEvalInfo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %> 
<script type="text/javascript">
function fnContentOnLoad(){
	var content = document.getElementById("content");
	var height  = 0;
	
	try{
		height = content.contentWindow.document.getElementById("divBody").scrollHeight;
		
		height = height + 20;
		
		if(height < 500){
			height = 500;
		}
	}
	catch(e){
		height = 500;
	}
	
	content.height = height + "px";
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
	<iframe id="content"  src="/system/managerManagementIframe.sys" scrolling="no" style="border: 0px; width: 1500px;" onLoad="javascript:fnContentOnLoad();"/>
</body>
</html>