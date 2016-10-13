<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-200 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	Map<String, Object> detailInfo = (Map<String, Object>)request.getAttribute("contractDetail");
	String contractVersion = "";
	String contractClassify = "";
	String contractContents = "";
	String contractDate = "";
	String contractUserNm = "";
	String contractSpecial = "";
	if(detailInfo != null){
		contractVersion = (String)detailInfo.get("contractVersion");
		contractClassify = (String)detailInfo.get("contractClassify");
		contractContents = (String)detailInfo.get("contractContents");
		contractDate = (String)detailInfo.get("contractDate");
		contractUserNm = (String)detailInfo.get("contractUserNm");
		contractSpecial = (String)detailInfo.get("contractSpecial");
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function(){
	$("#closeButton").click(function(){ fnClose(); });
	contractVersion();
});

function fnClose() {
	window.close();
	
}

function contractVersion() {
	var version = $("#contractVersion1").val();
	var contractSpecial = "<%=contractSpecial%>";
	if(version == "30"){
		$.post(
			"/organ/contractSpecialList.sys",
			function(arg){
				var result = eval("("+arg+")");
				$("#contarctClassifyTR").append("<td class='table_td_subject' id='specialContrarctTD1'>특별계약</td>");
				$("#contarctClassifyTR").append("<td class='table_td_contents' id='specialContrarctTD2'><select id='contractSpecial'></select></td>");
				$("#contractSpecial").append("<option value=''>선택하세요.</option>");
				for(var i=0; i<result.list.length; i++){
					$("#contractSpecial").append("<option value='"+result.list[i].codeVal1+"'>"+result.list[i].codeNm1+"</option>");
				}
				if(contractSpecial != "null"){					
					$("#contractSpecial").val(contractSpecial);
				}
				$("#contractClassify").val('BUY');
				$("#contractClassify").attr('disabled',true);
			}
		);
	}else{
		$("#specialContrarctTD1").remove();
		$("#specialContrarctTD2").remove();
		$("#contractClassify").val('BUY');
		$("#contractClassify").attr('disabled',false);
	}
}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
</head>
<body>
<form>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
    		<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>물품공급 계약서 상세</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">계약 버전</td>
					<td class="table_td_contents" colspan="3">
						<%=contractVersion %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">계약 구분</td>
					<td class="table_td_contents" colspan="3">
						<%=contractClassify %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">계약 내용</td>
					<td height="250" valign="top" class="table_td_contents4" colspan="3">
						<%=contractContents %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>

				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject" width="18%">등록자</td>
					<td class="table_td_contents" width="32%">
						<%=contractUserNm %>
					</td>
					<td width="100" class="table_td_subject" width="18%">등록일</td>
					<td class="table_td_contents" width="32%">
						<%=contractDate %>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">	
			<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_write_delete.jpg" style="border: 0px; " /></a>
			<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="border: 0px;" /></a>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</form>
</body>
</html>