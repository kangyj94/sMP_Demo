<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList                 = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	List<Object>        commodityContractNewList = (List<Object>)request.getAttribute("commodityContractNewList"); //계약서 리스트
	LoginUserDto        loginUserDto             = CommonUtils.getLoginUserDto(request);
	String              _menuId                  = CommonUtils.getRequestMenuId(request);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
.page_table_contents {
	border-left:solid 1px #ccc;
	border-right:solid 1px #ccc;
	border-bottom:solid 1px #ccc;
	color:#000;
	padding-left:15px;
	padding-right:15px;
	height:22px;
	padding-top:4px;
	white-space:nowrap;
	text-align:center;
}
</style>
<script type="text/javascript">
/*
 * 서버와의 한글 통신을 위한 문자 인코딩 함수
 * 
 * @author : sjisbmoc
 * @source : http://kin.naver.com/qna/detail.nhn?d1id=1&dirId=1040201&docId=120691999&qb=dXRmLTgg7ZWc6riA&enc=utf8&section=kin&rank=3&search_sort=0&spq=0&pid=gRsYMwoi5UKssZRmdi0sss--027113&sid=TUAvOw7jP00AAEUhMDk
*/ 
function fncEnCode(param){
    var encode = '';

    for(var i=0; i<param.length; i++){
        var len   = '' + param.charCodeAt(i);
        var token = '' + len.length;
        
        encode  += token + param.charCodeAt(i);
    }

    return encode;
}

<%-- 구매사 계약서 서명 리스트 --%>
function fnBranchContractSign(svcTypeCd, contractVersion,contractNm, contractSpecial){
	var params = '_menuId=<%=_menuId%>';
	
	params = params + '&svcTypeCd=' + svcTypeCd;
	params = params + '&contractVersion=' + contractVersion;
	params = params + '&contractNm=' + fncEnCode(contractNm);
	params = params + "&contractSpecial=" + contractSpecial;
	
	window.open('', 'popContractSign', 'width=600, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/system/popContractSign.sys", params, "popContractSign");
}

<%-- 구매사 계약서 미서명 리스트 --%>
function fnBranchContractNoSign(svcTypeCd, contractVersion,contractNm, contractSpecial){
	var params = '_menuId=<%=_menuId%>';
	
	params = params + '&svcTypeCd=' + svcTypeCd;
	params = params + '&contractVersion=' + contractVersion;
	params = params + '&contractNm=' + fncEnCode(contractNm);
	params = params + "&contractSpecial=" + contractSpecial;
	
	window.open('', 'popContractNoSign', 'width=600, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/system/popContractNoSign.sys", params, "popContractNoSign");
}

<%-- 공급사 계약서 서명 리스트 --%>
function fnVendorContractSign(svcTypeCd, contractVersion,contractNm, contractSpecial){
	var params = '_menuId=<%=_menuId%>';
	
	params = params + '&svcTypeCd=' + svcTypeCd;
	params = params + '&contractVersion=' + contractVersion;
	params = params + '&contractNm=' + fncEnCode(contractNm);
	params = params + "&contractSpecial=" + contractSpecial;
	
	window.open('', 'popContractSign', 'width=600, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/system/popContractSign.sys", params, "popContractSign");
}

<%-- 공급사 계약서 미서명 리스트 --%>
function fnVendorContractNoSign(svcTypeCd, contractVersion,contractNm, contractSpecial){
	var params = '_menuId=<%=_menuId%>';
	
	params = params + '&svcTypeCd=' + svcTypeCd;
	params = params + '&contractVersion=' + contractVersion;
	params = params + '&contractNm=' + fncEnCode(contractNm);
	params = params + "&contractSpecial=" + contractSpecial;
	
	window.open('', 'popContractNoSign', 'width=600, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/system/popContractNoSign.sys", params, "popContractNoSign");
}

<%-- 계약서 수정--%>
function fnContractMod(svcTypeCd, contractVersion, contractSpecial){
	var param = '_menuId=<%=_menuId%>';
	
	param = param + '&svcTypeCd='       + svcTypeCd;
	param = param + '&contractVersion=' + contractVersion;
	param = param + '&contractSpecial=' + contractSpecial;
	
	window.open('', 'popContractMod', 'width=917, height=730, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm('/system/popContractMod.sys', param, 'popContractMod');
}

<%-- --%>
function fnRefresh(){
	location.reload(true);
}
</script>
<title>Insert title here</title>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<form id="frm" name="frm" onsubmit="return false;"></form>
	<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
						</td>
						<td height="29" class='ptitle'>계약서 관리</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="1500px" height="40px" valign="bottom">
				<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" valign="top">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
						</td>
						<td class="stitle">구매사 계약서</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="1500px" height="40px" valign="bottom">
				<table width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td class="table_td_subject" style="text-align: center; width:25%;">계약서</td>
						<td class="table_td_subject" style="text-align: center; width:20%;">버전</td>
						<td class="table_td_subject" style="text-align: center; width:20%;">작성일시</td>
						<td class="table_td_subject" style="text-align: center; width:15%;">작성자</td>
						<td class="table_td_subject" style="text-align: center; width:15%;">내역</td>
					</tr>
<%	
	Map<String, Object> commodityContractNewMap      = null;
	String              svcTypeCd                    = null;
	String              contractVersion              = null;
	String              contractNm                   = null;
	String              contractSpecial              = null;
	String              contractDate                 = null;
	String              contractUserNm               = null;
	int                 buyIdCnt                     = 1;
	int                 i                            = 0;
	int                 commodityContractNewListSize = -1;
	
	if(commodityContractNewList != null){
		commodityContractNewListSize = commodityContractNewList.size();
	}
	
	for(i = 0; i < commodityContractNewListSize; i++){
		commodityContractNewMap = (Map<String, Object>)commodityContractNewList.get(i);
		svcTypeCd               = (String)commodityContractNewMap.get("SVCTYPECD");
		contractVersion         = (String)commodityContractNewMap.get("CONTRACT_VERSION");
		contractSpecial         = (String)commodityContractNewMap.get("CONTRACT_SPECIAL");
		contractNm              = (String)commodityContractNewMap.get("CONTRACTNM");
		contractVersion         = (String)commodityContractNewMap.get("CONTRACT_VERSION");
		contractDate            = (String)commodityContractNewMap.get("CONTRACT_DATE");
		contractUserNm          = (String)commodityContractNewMap.get("CONTRACT_USERNM");
		contractSpecial         = CommonUtils.nvl(contractSpecial, "0");
		
		if("BUY".equals(svcTypeCd)){
%>
					<tr>
						<td class="page_table_contents" id="buyContractNm_<%=buyIdCnt%>" name="buyContractNm_<%=buyIdCnt%>" style="text-align: left;">
							<a href="javascript:fnContractMod('<%=svcTypeCd%>', '<%=contractVersion %>', '<%=contractSpecial %>')" style="color: rgb(0, 0, 255);">
								<%=contractNm%>
							</a>
						</td>
						<td class="page_table_contents" id="buyContractVersion_<%=buyIdCnt%>" name="buyContractVersion_<%=buyIdCnt%>">
							<%=contractVersion%>
						</td>
						<td class="page_table_contents" id="buyContractDate_<%=buyIdCnt%>" name="buyContractDate_<%=buyIdCnt%>">
							<%=contractDate%>
						</td>
						<td class="page_table_contents" id="buyContractUserNm_<%=buyIdCnt%>"name="buyContractUserNm_<%=buyIdCnt%>">
							<%=contractUserNm%>
						</td>
						<td class="page_table_contents" align="center">
							<button id='vendorSignBtn'   class='btn btn-primary btn-xs' onClick="fnBranchContractSign('<%=svcTypeCd%>','<%=contractVersion%>','<%=contractNm%>', '<%=contractSpecial %>')">서명</button>
							<button id='vendorNoSignBtn' class='btn btn-primary btn-xs' onClick="fnBranchContractNoSign('<%=svcTypeCd%>','<%=contractVersion%>','<%=contractNm%>', '<%=contractSpecial %>')">미서명</button>
						</td>
					</tr>		
<%
			buyIdCnt++;
		}
	}
%>
				</table>
			</td>
		</tr>
		<tr height="50px">
			<td></td>
		</tr>
		<tr>
			<td width="100%" height="40px" valign="bottom">
				<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" valign="top">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
						</td>
						<td class="stitle">공급사 계약서</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td width="100%" height="40px" valign="bottom">
				<table width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td class="table_td_subject" style="text-align: center; width:25%;">계약서</td>
						<td class="table_td_subject" style="text-align: center; width:20%;">버전</td>
						<td class="table_td_subject" style="text-align: center; width:20%;">작성일시</td>
						<td class="table_td_subject" style="text-align: center; width:15%;">작성자</td>
						<td class="table_td_subject" style="text-align: center; width:15%;">내역</td>
					</tr>
<%
	int venIdCnt = 1;
	for(i = 0; i < commodityContractNewListSize; i++){
		commodityContractNewMap = (Map<String, Object>)commodityContractNewList.get(i);
		svcTypeCd               = (String)commodityContractNewMap.get("SVCTYPECD");
		contractVersion         = (String)commodityContractNewMap.get("CONTRACT_VERSION");
		contractSpecial         = (String)commodityContractNewMap.get("CONTRACT_SPECIAL");
		contractNm              = (String)commodityContractNewMap.get("CONTRACTNM");
		contractVersion         = (String)commodityContractNewMap.get("CONTRACT_VERSION");
		contractDate            = (String)commodityContractNewMap.get("CONTRACT_DATE");
		contractUserNm          = (String)commodityContractNewMap.get("CONTRACT_USERNM");
		
		if("VEN".equals(svcTypeCd)){
%>
					<tr>
						<td class="page_table_contents" id="venContractNm_<%=venIdCnt%>" name="venContractNm_<%=venIdCnt%>" style="text-align: left;">
							<a href="javascript:fnContractMod('<%=svcTypeCd%>', '<%=contractVersion%>', '0')" style="color: rgb(0, 0, 255);">
								<%=contractNm%>
							</a>
						</td>
						<td class="page_table_contents" id="venContractVersion_<%=venIdCnt%>" name="venContractVersion_<%=venIdCnt%>">
							<%=contractVersion%>
						</td>
						<td class="page_table_contents" id="venContractDate_<%=venIdCnt%>" name="venContractDate_<%=venIdCnt%>">
							<%=contractDate%>
						</td>
						<td class="page_table_contents" id="venContractUserNm_<%=venIdCnt%>"name="venContractUserNm_<%=venIdCnt%>">
							<%=contractUserNm%>
						</td>
						<td class="page_table_contents" align="center">
							<button id='vendorSignBtn' class='btn btn-primary btn-xs' onClick="fnVendorContractSign('<%=svcTypeCd%>','<%=contractVersion%>','<%=contractNm%>', '0')">서명</button>
							<button id='vendorNoSignBtn' class='btn btn-primary btn-xs' onClick="fnVendorContractNoSign('<%=svcTypeCd%>','<%=contractVersion%>','<%=contractNm%>', '0')">미서명</button>
						</td>
					</tr>
<%
			venIdCnt++;
		}
	}
%>
				</table>
			</td>
		</tr>
	</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</body>
</html>