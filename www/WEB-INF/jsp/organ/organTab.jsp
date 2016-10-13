<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
</head>
<body>

<div id="tempTabRadio">
    <input type="radio" id="tempTabRadio1" name="tempTabRadio" checked="checked"><label for="tempTabRadio1">법인 조회</label>
    <input type="radio" id="tempTabRadio2" name="tempTabRadio"><label for="tempTabRadio2">사업장 조회</label>
    <input type="radio" id="tempTabRadio3" name="tempTabRadio"><label for="tempTabRadio3">사용자 조회</label>
</div>
<iframe id="tmpViewArea" name="tmpViewArea" frameborder="0" style="width: 100%;height: 100%" src="/menu/organ/corporationClientList.sys?_menuCd=ADM_SYS_BORG_SVC"></iframe>
</body>
<script type="text/javascript">
$(document).ready(function(){
	$( "#tempTabRadio" ).buttonset();   
    $("#tempTabRadio1").click(function(){
        $( "#tmpViewArea" ).attr("src","/menu/organ/corporationClientList.sys?_menuCd=ADM_SYS_BORG_SVC");
    });
    $("#tempTabRadio2").click(function(){
        $( "#tmpViewArea" ).attr("src","/organ/organBranchList.sys?_menuCd=ADM_ORGAN_BRNCH_LIST");
    });
    $("#tempTabRadio3").click(function(){
        $( "#tmpViewArea" ).attr("src","/organ/organUserList.sys?_menuCd=ADM_ORGAN_USER_LIST");
    });	
});
</script>

</html>