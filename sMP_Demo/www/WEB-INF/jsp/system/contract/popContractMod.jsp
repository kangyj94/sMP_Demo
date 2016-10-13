<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
	@SuppressWarnings("unchecked") //화면권한가져오기(필수)
	List<ActivitiesDto> roleList             = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	LoginUserDto        loginUserDto         = CommonUtils.getLoginUserDto(request);
	Map<String, Object> commodityContractNew = (Map<String, Object>)request.getAttribute("commodityContractNew");
	String              listHeight           = "$(window).height()-645 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String              _menuId              = CommonUtils.getRequestMenuId(request);
	String              getDate              = CommonUtils.getCurrentDate();
	String              newContractVersion   = "";
	String              contractContents     = "";
	String              contractVersion      = "";
	String              svcTypeCd            = "";
	String              contractClassify     = "";
	String              contractSpecial      = "";
	
	if(commodityContractNew != null){
		contractContents = CommonUtils.getString(commodityContractNew.get("CONTRACT_CONTENTS"));
		contractVersion	 = CommonUtils.getString(commodityContractNew.get("CONTRACT_VERSION"));
		svcTypeCd		 = CommonUtils.getString(commodityContractNew.get("SVCTYPECD"));
		contractClassify = CommonUtils.getString(commodityContractNew.get("CONTRACT_CLASSIFY"));
		getDate          = getDate.replaceAll("-", "");
		getDate          = getDate.substring(2, 8);
		contractSpecial  = CommonUtils.getString(commodityContractNew.get("CONTRACT_SPECIAL"));
		
		if("S".equals(contractClassify)){
			newContractVersion = contractClassify;
			
			if("10".equals(contractSpecial)){
				newContractVersion = newContractVersion + "1_" + getDate + "V1.0";
			}
			else if("20".equals(contractSpecial)){
				newContractVersion = newContractVersion + "2_" + getDate + "V1.0";
			}
			else if("30".equals(contractSpecial)){
				newContractVersion = newContractVersion + "3_" + getDate + "V1.0";
			}
			else if("40".equals(contractSpecial)){
				newContractVersion = newContractVersion + "4_" + getDate + "V1.0";
			}
			else if("50".equals(contractSpecial)){
				newContractVersion = newContractVersion + "5_" + getDate + "V1.0";
			}
		}
		else{
			newContractVersion  = contractClassify + getDate + "V1.0";
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var jq = jQuery;
var oEditors = [];
$(document).ready(function() {
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "contractContents",
		sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
	});
	
	if(oEditors.length > 0) {
		oEditors.getById["contractContents"].exec('UPDATE_CONTENTS_FIELD', []);
	}
	
	<%-- 버튼 이벤트 --%>
	$("#contractSaveBtn").click(function(){ contractSave(); });
	$(".btnClose").click(function(){ window.close(); });
	
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');

<%-- 계약서 저장 --%>
function contractSave(){
	oEditors.getById["contractContents"].exec("UPDATE_CONTENTS_FIELD", []);
	var nowContractVersion	= $("#nowContractVersion").val();		//현재 계약버전
	var newContractVersion	= $("#newContractVersion").val();		//수정 계약버전
	var newContractClassify	= $("#newContractClassify").val();		//계약서 유형
	var contractContents	= $("#contractContents").val();			//상세 내용
	// 정연백 과장님 요청으로 인한 임시 주석 처리 start!(2016-02-04)
	/*
	if(nowContractVersion == newContractVersion){
		alert("현재 계약버전과 수정 계약버전이 동일 합니다.\n수정 계약버전을 변경해 주세요.");
		$("#newContractVersion").focus();
		return;
	}else{
		//수정 계약버전의 계약서 유형 체크
		var newContractVersionClassify = newContractVersion.substring(0, 1);
		
		if(newContractVersionClassify != newContractClassify){
			alert("수정 계약버전의 계약서 유형이 현재 계약버전과 다릅니다.\n동일하게 수정해 주세요. ");
			
			return;
		}
		//수정 계약버전의 날짜 체크
		var getDate                = "<%=getDate%>";
		var newContractVersionDate = null;
		
		if("S" == newContractClassify){
<%
	if("50".equals(contractSpecial)){
%>
			newContractVersionDate = newContractVersion.substring(1,7);
<%
	}
	else{
%>
			newContractVersionDate = newContractVersion.substring(3,9);
<%
	}
%>

		}
		else{
			newContractVersionDate = newContractVersion.substring(1,7);
		}
		
		if(newContractVersionDate != getDate){
			alert(newContractVersionDate + " 수정 계약버전의 날짜가 현재 날짜와 다릅니다.");
			
			return;
		}
	}
	*/
	// 임시 주석 처리 end!
	
	contractContents = fnReplaceAll(contractContents, unescape("%uFEFF"), ""); 
	
	$.post(
		"/borgSvc/contractSave/save.sys",
		{
			nowContractVersion:nowContractVersion,
			newContractVersion:newContractVersion,
			contractContents:contractContents,
			svcTypeCd:'<%=svcTypeCd%>',
			contractSpecial:'<%=contractSpecial%>'
		},
		function(arg){
			var result = eval("("+arg+")");
			var customResponse = result.customResponse;
			if(customResponse.success == false){
				alert(customResponse.message);
				window.opener.fnRefresh();
				window.close();
			}else{
				alert("처리 되었습니다.");
				window.opener.fnRefresh();
				window.close();
			}
		}
	);
	
}

function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
} 

</script>
<title>Insert title here</title>
</head>
<body>
<form id="frm" name="frm" onsubmit="return false;">
	<input type="hidden" id="newContractClassify" name="newContractClassify" value="<%=contractClassify%>"/> 
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="vendorDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
						<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>계약서 작성</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="btnClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<!-- 조회조건 -->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="4" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="80">현재 계약버전</td>
									<td class="table_td_contents">
										<input id="nowContractVersion" name="nowContractVersion" type="text" value="<%=contractVersion%>" size="20" maxlength="20" disabled="disabled"/>
									</td>
									<td class="table_td_subject" width="80">수정 계약버전</td>
									<td class="table_td_contents">
										<input id="newContractVersion" name="newContractVersion" type="text" value="<%=newContractVersion%>" size="20" maxlength="20" />
									</td>
								</tr>
								<tr>
									<td colspan="4" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="4" height='8'></td>
								</tr>
								<tr>
									<td colspan="4" class="pdt_10">
										<table class="InputTable" width="100%"  border="0" cellpadding="0" cellspacing="0">
											<colgroup>
<!-- 												<col width="80px" /> -->
												<col width="auto" />
											</colgroup>
											<tr>
<!-- 												<th>상세설명</th> -->
												<td><textarea id="contractContents" name="contractContents" required title="상세설명" style="height:500px;display:none"><%=contractContents%></textarea></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="4">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="4" align="center">
										<button id="contractSaveBtn" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 계약서 저장</button>
										<button type="button" class="btn btn-default btn-sm btnClose"><i class="fa fa-times"></i> 닫기</button>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>