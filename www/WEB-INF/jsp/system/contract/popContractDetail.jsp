<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
	LoginUserDto        loginUserDto         = CommonUtils.getLoginUserDto(request);
	Map<String, Object> commodityContractNew = (Map<String, Object>)request.getAttribute("commodityContractNew");
	Map<String, String> borgInfo             = (Map<String, String>)request.getAttribute("borgInfo");
	String              newContractVersion   = "";
	String              contractContents     = "";
	String              contractVersion      = "";
	String              svcTypeCd            = "";
	String              contractClassify     = "";
	String              contractDate         = "";
	String              borgNm               = null;
	String              address              = null;
	String              presentNm            = null;
	
	if(commodityContractNew != null){
		contractContents = CommonUtils.getString(commodityContractNew.get("CONTRACT_CONTENTS"));
		contractVersion  = CommonUtils.getString(commodityContractNew.get("CONTRACT_VERSION"));
		svcTypeCd        = CommonUtils.getString(commodityContractNew.get("SVCTYPECD"));
		contractClassify = CommonUtils.getString(commodityContractNew.get("CONTRACT_CLASSIFY"));
		contractDate     = CommonUtils.getString(commodityContractNew.get("CONTRACT_DATE"));
		contractDate     = CommonUtils.nvl(contractDate, CommonUtils.getCurrentDate());
	}
	
	if(loginUserDto != null){
		borgNm    = loginUserDto.getBorgNm();
		svcTypeCd = loginUserDto.getSvcTypeCd();
		
		if("VEN".equals(svcTypeCd)){
			address   = loginUserDto.getSmpVendorsDto().getAddres() + " " + loginUserDto.getSmpVendorsDto().getAddresDesc();
			presentNm = loginUserDto.getSmpVendorsDto().getPressentNm();
		}
		else if("BUY".equals(svcTypeCd)){
			address   = loginUserDto.getSmpBranchsDto().getAddres() + " " + loginUserDto.getSmpBranchsDto().getAddresDesc();
			presentNm = loginUserDto.getSmpBranchsDto().getPressentNm();
		}
	}
	else{
		borgNm    = borgInfo.get("borgNm");
		address   = borgInfo.get("address");
		presentNm = borgInfo.get("presentNm");
		svcTypeCd = request.getParameter("svcTypeCd");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.printArea.js" type="text/javascript"></script>
<%-- <script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script> --%>
<script type="text/javascript">
$(document).ready(function() {
	<%-- 버튼 이벤트 --%>
	$(".btnClose").click(function(){ window.close(); });
	$('form').on('submit',function(){ return false; });
});

function windowPrint() {
	var contractBottomTd1 = "";
	var borgNm            = "<%=borgNm%>";
	var borgAddress       = "<%=address%>";
	var pressentNm        = "<%=presentNm%>";
	
<%
	if(loginUserDto != null){
%>
	contractBottomTd1 = "본 문서는 전자서명법등 관련 법령(전자서명법 제 3조 1항, 2항, 전자거래기본법 제 5조, 7조, 18조)에 의하여 효력이 인정되는 공인인증기관이 발행한 인증서를 사용하여 전자서명된 계약서 입니다.";
<%
	}
%>
	
	$("#contractContents").append("<table width='800px' id='contractBottomTable' align='center'></table>");
	$("#contractBottomTable").append("<tr><td id='contractBottomTd1' style='padding-top:50px;'></td></tr>");
	$("#contractBottomTd1").append("<table width='800px' align='center' border='0' cellspacing='0' cellpadding='0'><tr><td>"+contractBottomTd1+"</td></table>");
	$("#contractBottomTable").append("<tr><td id='contractBottomTd2'></td></tr>");
	$("#contractBottomTd2").append("<table width='800px' align='center' border='0' cellspacing='0' cellpadding='0'><tr><td height='10px'></td></tr><tr><td align='right'>계약일 <%=contractDate %></td></tr></table>");
	
	
<%
	if("VEN".equals(svcTypeCd)){
%>
		$("#contractBottomTable").append("<tr><td id='contractBottomTd3'></td></tr>");
		$("#contractBottomTd3").append("<table width='450px' align='right' border='0' cellspacing='0' cellpadding='0'><tr><td align='right' width='80'>발주사</td><td align='center' width='130'>상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 : </td><td>SK 텔레시스 주식회사</td></tr><tr><td></td><td align='center'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : </td><td>서울 중구 을지로2가 6번지</td></tr><tr><td></td><td align='center'>대표이사 : </td><td>안 승 윤</td></tr><tr><td colspan='3' height='30'></td></tr></table>");
		$("#contractBottomTable").append("<tr><td id='contractBottomTd4'></td></tr>");
		$("#contractBottomTd3").append("<table width='450px' align='right' border='0' cellspacing='0' cellpadding='0'><tr><td align='right' width='80'>공급사</td><td align='center' width='130'>상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 : </td><td>"+borgNm+"</td></tr><tr><td></td><td align='center'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : </td><td>"+borgAddress+"</td></tr><tr><td></td><td align='center'>대표이사 : </td><td>"+pressentNm+"</td></tr><tr><td colspan='3' height='30'></td></tr></table>");
<%
	}
	else if("BUY".equals(svcTypeCd)){
%>
		$("#contractBottomTable").append("<tr><td id='contractBottomTd3'></td></tr>");
		$("#contractBottomTd3").append("<table width='450px' align='right' border='0' cellspacing='0' cellpadding='0'><tr><td align='right' width='80'>구매사</td><td align='center' width='130'>상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 : </td><td>"+borgNm+"</td></tr><tr><td></td><td align='center'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : </td><td>"+borgAddress+"</td></tr><tr><td></td><td align='center'>대표이사 : </td><td>"+pressentNm+"</td></tr><tr><td colspan='3' height='30'></td></tr></table>");
		$("#contractBottomTable").append("<tr><td id='contractBottomTd4'></td></tr>");
		$("#contractBottomTd3").append("<table width='450px' align='right' border='0' cellspacing='0' cellpadding='0'><tr><td align='right' width='80'>공급사</td><td align='center' width='130'>상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 : </td><td>SK 텔레시스 주식회사</td></tr><tr><td></td><td align='center'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : </td><td>서울 중구 을지로2가 6번지</td></tr><tr><td></td><td align='center'>대표이사 : </td><td>안 승 윤</td></tr><tr><td colspan='3' height='30'></td></tr></table>");
<%
	}
%>
	document.body.innerHTML =  document.getElementById("contractContents").innerHTML;
	
	window.print();
	window.close();
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
							<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
							<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
							<td class="popup_title">계약서</td>
							<td width="22" align="right">
								<a href="#" class="jqmClose">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" class="btnClose" width="14" height="13" style="margin-bottom:5px;" />
								</a>
							</td>
							<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
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
									<td colspan="3" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="80">계약버전</td>
									<td class="table_td_contents">
										<input id="nowContractVersion" name="nowContractVersion" type="text" value="<%=contractVersion%>" size="20" maxlength="20" disabled="disabled"/>
									</td>
									<td class="table_td_contents" align="right">
										<a href="javascript:windowPrint();"><img src="/img/system/btn_contract_print.png" width="25px" border="0"/></a>
									</td>
								</tr>
								<tr>
									<td colspan="3" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="3" height='8'></td>
								</tr>
								<tr>
									<td colspan="3" class="pdt_10">
										<div id="contractContents" style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:850; height:480px;; padding:10px 10px 10px 10px;" >
											<%=contractContents%>
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="3" height='8'></td>
								</tr>
								<tr>
									<td colspan="3" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="3">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="3" align="center">
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
</form>
</body>
</html>