<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
	String contractVersion = (String)request.getAttribute("contractVersion");
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	List<Map<String, Object>> list = (List)request.getAttribute("contractVersionList");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.printArea.js" type="text/javascript"></script>
<script type="text/javascript">
$(document).ready(function () {

	$("#selectContractVersion").change(function () { fnContractShow(); });
	fnContractShow();
	
});
var content = "";
var contractDate = "";
function fnContractShow() {
	var contractNo = $("#selectContractVersion").val();
	var borgId = "<%=loginUserDto.getBorgId()%>";
	$.post(
		"/system/systemContractPopupContents.sys",
		{
			contractNo:contractNo,
			borgId:borgId
		},
		function (arg) {
			var result = eval('('+arg+')').commodityContractDetail;
			var resultContractDate = eval('('+arg+')').commodityContractListDate;
			content = result.contractContents;
			contractDate = resultContractDate;
			$("#contractContents").html(result.contractContents);

		}
	);
}

function windowPrint() {
	if(contractDate != ''){
		var contractBottomTd1 = "본 문서는 전자서명법등 관련 법령(전자서명법 제 3조 1항, 2항, 전자거래기본법 제 5조, 7조, 18조)에 의하여 효력이 인정되는 공인인증기관이 발행한 인증서를 사용하여 전자서명된 계약서 입니다.";;
		var borgNm = "<%=loginUserDto.getBorgNm()%>";
		var borgAddress = "";
		var pressentNm = "";
		$("#contractContents").append("<table width='595px' id='contractBottomTable' align='center'></table>");
		$("#contractBottomTable").append("<tr><td id='contractBottomTd1'></td></tr>");
		$("#contractBottomTd1").append("<table width='595px' align='center' border='1' cellspacing='0' cellpadding='0'><tr><td>"+contractBottomTd1+"</td></table>");
		$("#contractBottomTable").append("<tr><td id='contractBottomTd2'></td></tr>");
		$("#contractBottomTd2").append("<table width='595px' align='center' border='0' cellspacing='0' cellpadding='0'><tr><td height='10px'></td></tr><tr><td align='right'>계약일 "+contractDate+"</td></tr></table>");
		<%if("VEN".equals(loginUserDto.getSvcTypeCd())){%>
			borgAddress = "<%=loginUserDto.getSmpVendorsDto().getAddres()%>"+" "+"<%=loginUserDto.getSmpVendorsDto().getAddresDesc()%>";
			pressentNm = "<%=loginUserDto.getSmpVendorsDto().getPressentNm()%>";
			$("#contractBottomTable").append("<tr><td id='contractBottomTd3'></td></tr>");
			$("#contractBottomTd3").append("<table width='450px' align='right' border='0' cellspacing='0' cellpadding='0'><tr><td align='right' width='80'>발주사</td><td align='center' width='130'>상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 : </td><td>SK 텔레시스 주식회사</td></tr><tr><td></td><td align='center'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : </td><td>서울 중구 을지로2가 6번지</td></tr><tr><td></td><td align='center'>대표이사 : </td><td>김 종 식</td></tr><tr><td colspan='3' height='30'></td></tr></table>");
			$("#contractBottomTable").append("<tr><td id='contractBottomTd4'></td></tr>");
			$("#contractBottomTd3").append("<table width='450px' align='right' border='0' cellspacing='0' cellpadding='0'><tr><td align='right' width='80'>공급사</td><td align='center' width='130'>상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 : </td><td>"+borgNm+"</td></tr><tr><td></td><td align='center'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : </td><td>"+borgAddress+"</td></tr><tr><td></td><td align='center'>대표이사 : </td><td>"+pressentNm+"</td></tr><tr><td colspan='3' height='30'></td></tr></table>");
		<%}else if("BUY".equals(loginUserDto.getSvcTypeCd())){%>
			borgAddress = "<%=loginUserDto.getSmpBranchsDto().getAddres()%>"+" "+"<%=loginUserDto.getSmpBranchsDto().getAddresDesc()%>";
			pressentNm = "<%=loginUserDto.getSmpBranchsDto().getPressentNm()%>";
			$("#contractBottomTable").append("<tr><td id='contractBottomTd3'></td></tr>");
			$("#contractBottomTd3").append("<table width='450px' align='right' border='0' cellspacing='0' cellpadding='0'><tr><td align='right' width='80'>구매사</td><td align='center' width='130'>상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 : </td><td>"+borgNm+"</td></tr><tr><td></td><td align='center'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : </td><td>"+borgAddress+"</td></tr><tr><td></td><td align='center'>대표이사 : </td><td>"+pressentNm+"</td></tr><tr><td colspan='3' height='30'></td></tr></table>");
			$("#contractBottomTable").append("<tr><td id='contractBottomTd4'></td></tr>");
			$("#contractBottomTd3").append("<table width='450px' align='right' border='0' cellspacing='0' cellpadding='0'><tr><td align='right' width='80'>공급사</td><td align='center' width='130'>상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호 : </td><td>SK 텔레시스 주식회사</td></tr><tr><td></td><td align='center'>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소 : </td><td>서울 중구 을지로2가 6번지</td></tr><tr><td></td><td align='center'>대표이사 : </td><td>김 종 식</td></tr><tr><td colspan='3' height='30'></td></tr></table>");
		<%}%>
	}
	$("#contractContents").printArea();
	window.close();
}
</script>
</head>
<body>
<div id="contractHeader">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td>
			<!-- 타이틀 시작 -->
				<table width='100%' border='0' cellspacing='0' cellpadding='0' >
					<tr>
						<td width="757" height='64' align='left' rowspan="2">
<%							if("1".equals(contractVersion)){ %>	
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/b_contract.gif" width="620" height="48" />
<%							}else if("2".equals(contractVersion)){%>
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/i_contract.gif" width="620" height="48" />
<%							}else if("3".equals(contractVersion)){%>
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/s_contract.gif" width="620" height="48" />
<%							}else{%>
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/q_contract.gif" width="620" height="48" />
<%							}%>
						</td>
						<td width="137" align="right" rowspan="1">
							<a href="javascript:windowPrint()"><img src="/img/system/btn_contract_print.png" width="25px" border="0"/></a>
						</td>
					</tr>
					<tr>
						<td width="137" align="left" rowspan="1" colspan="2">
							<select id="selectContractVersion">
<%								if(list != null){
								for(int i=0; i<list.size(); i++){ 
%>
								<option value="<%=list.get(i).get("contractNo").toString()%>"><%=list.get(i).get("contractVersion").toString()%></option>
<%
								}
							}
%>
							</select>
						</td>
					</tr>
				</table>
				</td>
			</tr>
 			<!-- 타이틀 시작 -->
			<tr>
				<td>
					<table width='100%' border='0' cellspacing='0' cellpadding='0' >
						<tr>
							<td width='757' height="80">
								<div id="contractContents" style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:720px; height:690px; padding:10px 10px 10px 10px;" >
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<!-- 타이틀 끝 -->	
	</table>
</div>
</body>
</html>