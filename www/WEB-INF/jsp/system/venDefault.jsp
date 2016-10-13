<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.Map"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<% 
	List<BoardDto>            noticeList         = (List<BoardDto>)request.getAttribute("noticeList");
	List<BoardDto>            emergencyList      = (List<BoardDto>)request.getAttribute("emergencyList");
	List<Map<String, String>> branchBestList     = (List<Map<String, String>>)request.getAttribute("branchBestList");
	List<Map<String, String>> goodBestList       = (List<Map<String, String>>)request.getAttribute("goodBestList");
	List<Map<String, String>> taxList            = (List<Map<String, String>>)request.getAttribute("taxList");
	Map<String,Object>        smileEvalInfo      = (Map<String, Object>)request.getAttribute("smileEvalInfo");
	Map<String, String>       supplyInfo         = (Map<String, String>)request.getAttribute("supplyInfo");
	Map<String, String>       smileInfo          = (Map<String, String>)request.getAttribute("smileInfo");
	Map<String, String>       venManagerUserInfo = (Map<String, String>)request.getAttribute("venManagerUserInfo");
	Map<String, String>       productList        = (Map<String, String>)request.getAttribute("productList");
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui.js" type="text/javascript"></script>

<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
#smilePopJqm {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -320px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
}
.jqmOverlay { background-color: #000; }
#smilePopJqm {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#divGnb").mouseout(function () {
		$("#snb_vdr").hide();
	});
	$("#snb_vdr").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#snb_vdr").mouseout(function () {
		$("#snb_vdr").hide();
	});

	fnContractToDoList();
});

function fnNoticeDetailPop(boardNo){
	var params = "board_No=" + boardNo;
	
	window.open("", 'noticeDetailPop', 'width=720, height=510, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/board/noticeDetail.sys", params, "noticeDetailPop");
}

function vocGo(){	
	window.open("", 'requestManageWrite', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/board/requestManageWrite.sys", "", "requestManageWrite");
}
function fnReloadGrid(){}

//세금계산서
function fnEBill(pubCode){
	$("#pubCode").val(pubCode);
	if($.trim($("#pubCode").val() != "")){
		var iMyHeight;
		width = (window.screen.width-635)/2;
		if(width<0)width=0;
		iMyWidth = width;
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		
		window.open("http://<%=Constances.EBILL_URL%>/jsp/directTax/TaxViewIndex.jsp?pubCode="+pubCode+"&docType=T&userType=R", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=700px, height=760px");
		
		document.ebillPopFrm.action = "http://<%=Constances.EBILL_URL%>/jsp/directTax/TaxViewIndex.jsp";
		document.ebillPopFrm.method = "post";
		document.ebillPopFrm.target = "taxInvoice";
		document.ebillPopFrm.submit();
		document.ebillPopFrm.target="_self";
		$("#pubCode").val("");
		taxInvoice.focus();
	} else { jq( "#dialogSelectRow" ).dialog(); }   
}

//거래명세서
function fnEPay(saleSequNumb){
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	
	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "BchParticulars"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;
	oReport.param("saleSequNumb").value = saleSequNumb;
	
	oReport.title = "거래명세서"; // 제목 세팅
	oReport.open();
}
</script>
<%-- 스마일 통계 관련 스크립트 --%>
<% if( smileEvalInfo != null && (Boolean)smileEvalInfo.get("isSmile")==true ){ %>
<script type="text/javascript">
$(document).ready(function(){
	fnSmileEvalPop();
});

function fnSmileEvalPop(){
	$('#smilePopJqm').jqm({modal:true});
	$('#smilePopJqm').jqm().jqDrag('#smilePopDrag');
	$('#smilePopJqm').jqmShow();

}
function fnSmileEval(){
	var smileArr= $(".smileId");
	var cnt = smileArr.length; 
	var smileIdArr		= new Array();
	var targetSvcCdArr	= new Array();
	var evalArr			= new Array();
	var id;

	for( var i=0 ; i < cnt ; i++){
		id = smileArr[i].value ;
		if( $("input[name*=evalA_"+id+"]").is(":checked")==false ){
			alert("모든 설문 문항에 대한 답변을 처리하여 주시기 바랍니다.");
			return;
		}
		smileIdArr.push( $("#smileId_"+id).val()  );
		targetSvcCdArr.push( $("#targetSvcCd_"+id).val() );
		evalArr.push( $("input[name=evalA_"+id+"]:checked").val() );
	}	
	
	if( smileIdArr.length != cnt || targetSvcCdArr.length != cnt || evalArr.length != cnt  ){
		alert( "데이터가 올바르지 않습니다.");
		return;
	}


	$("#smilePopJqm").jqmHide();
	$.ajax({
		url : "/evaluate/setSmileEval.sys",
		type : "post",
		dataType : "json",
		data : {
			smileIdArr : smileIdArr ,
			targetSvcCdArr : targetSvcCdArr,
			evalArr : evalArr
		},
		success : function( arg ){
			var result = arg.customResponse;
			if( result.success == true ){
				alert( "설문에 참여하여 주셔서 감사합니다." );
			}else{
				alert( result.message );
			}
		}
	});	
}
</script>
<% } %>
<%-- /스마일 통계 관련 스크립트 --%>

</head>

<body class="subBg">
<div id="divWrap">
	<!--header-->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
	<!--//header-->
	<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
				<!--Top5 (S)-->
				<div id="divTop5">
					<h2><img src="/img/layout/top5.gif" /></h2>
					<ul>
						<li class="Stitle">
							<i class="fa fa-shopping-cart" style="color: #F67F25; padding-right: 2px;"></i>
							<strong class="col01">구매사별</strong><span style="font-size:11px; position:absolute; right:5px;">(백만원)</span>
						</li>
						<li>
							<table>
<%
	if(branchBestList != null){
		Map<String, String> branchBestInfo     = null;
		String              branchNm           = null;
		String              buyiTotaAmou       = null;
		int                 branchBestListSize = branchBestList.size();
		int                 i                  = 0;
		
		for(i = 0; i < branchBestListSize; i++){
			branchBestInfo = branchBestList.get(i);
			branchNm       = branchBestInfo.get("branchNm");
			buyiTotaAmou   = branchBestInfo.get("buyiTotaAmou");
%>
								<tr>
									<td style="text-align: left; line-height:1.3em;border-bottom-color: gray; padding-top: 7px; padding-bottom: 7px; height: 25px; font-size: 11px;"><%=branchNm.trim() %></td>
									<td><span style="float: right; color: #F67F25; font-size: medium;"><b><%=buyiTotaAmou %></b></span></td>
								</tr>
<%
			if(i != (branchBestListSize - 1)){
%>
								<tr>
									<td colspan="2">
										<div style="height: 1px; background-color: #ccc;">&nbsp;</div>
									</td>										
								</tr>
<%
			}
		}
	}
%>
							</table>
						</li>
						<li class="Stitle">
							<i class="fa fa-cubes" style="color: #F67F25; padding-right: 2px;"></i>
							<strong class="col01">상품별</strong><span style="font-size:11px; position:absolute; right:5px;">(백만원)</span>
						</li>
						<li>
							<table>
<%
	if(goodBestList != null){
		Map<String, String> goodBestInfo     = null;
		String              goodName           = null;
		String              buyiTotaAmou       = null;
		int                 goodBestListSize = goodBestList.size();
		int                 i                  = 0;
		
		for(i = 0; i < goodBestListSize; i++){
			goodBestInfo = goodBestList.get(i);
			goodName       = goodBestInfo.get("goodName");
			buyiTotaAmou   = goodBestInfo.get("buyiTotaAmou");
%>
								<tr>
									<td style="text-align: left; line-height:1.3em;border-bottom-color: gray; padding-top: 7px; padding-bottom: 7px; height: 25px; font-size: 11px;"><%=goodName.trim() %></td>
									<td><span style="float: right; color: #F67F25; font-size: medium;"><b><%=buyiTotaAmou %></b></span></td>
								</tr>
<%
			if(i != (goodBestListSize - 1)){
%>
								<tr>
									<td colspan="2">
										<div style="height: 1px; background-color: #ccc;">&nbsp;</div>
									</td>										
								</tr>
<%
			}
		}
	}
%>
							</table>
						</li>
<%
	if(venManagerUserInfo != null){
		String userNm = venManagerUserInfo.get("userNm");
		String tel    = venManagerUserInfo.get("tel");
%>
						<li style="background-image:url(/img/layout/cs_center.gif); height: 47px; text-align: right; padding-right: 1px;">
							<span style="color: #F67F25; font-size:15px; font-weight: bold;"><%=tel %></span>
							<p style="line-height: 0.5px; font-weight: bold; color: black;"><font style="color: #888;">담당자 :</font> <%=userNm %></p>
						</li>
<%
	}
%>
					</ul>
				</div>
				<!--카테고리(E)-->
				<!--컨텐츠(S)-->
				<div id="divContainer">
					<div id="vendorMain">
						<div class="BoxCont mgr_15">
							<h2>공급현황 <font color="gray" size="2">(<%=CommonUtils.getCustomDay("DAY", -1) %> 기준)</font><span style="font-size: x-small">(단위 : 백만원)</span></h2>
							<table width="100%">
								<colgroup>
									<col width="20%" />
									<col width="20%" />
									<col width="20%" />
									<col width="20%" />
									<col width="20%" />
								</colgroup>
								<tr>
									<th rowspan="2">구분</th>
									<th colspan="3">최근 3개월 현황</th>
									<th rowspan="2">누적</th>
								</tr>
<%
	String twoMonthAgo = CommonUtils.getCustomDay("MONTH", -2);
	String oneMonthAgo = CommonUtils.getCustomDay("MONTH", -1);
	String thisMonth   = CommonUtils.getCurrentDateTime();
	
	twoMonthAgo = twoMonthAgo.substring(5, 7);
	oneMonthAgo = oneMonthAgo.substring(5, 7);
	thisMonth   = thisMonth.substring(5, 7);
%>
								<tr>
									<th><%=twoMonthAgo %>월</th>
									<th><%=oneMonthAgo %>월</th>
									<th><%=thisMonth %>월</th>
								</tr>
<%
	if(supplyInfo != null){
		String supply01 = supplyInfo.get("supply01");
		String supply02 = supplyInfo.get("supply02");
		String supply03 = supplyInfo.get("supply03");
		String supply04 = supplyInfo.get("supply04");
		String supply11 = supplyInfo.get("supply11");
		String supply12 = supplyInfo.get("supply12");
		String supply13 = supplyInfo.get("supply13");
		String supply14 = supplyInfo.get("supply14");
%>
								<tr>
									<td height="30">
										<strong>당해년도</strong>
									</td>
									<td height="30" style="text-align: right;"><%=supply01 %></td>
									<td height="30" style="text-align: right;"><%=supply02 %></td>
									<td height="30" style="text-align: right;"><%=supply03 %></td>
									<td height="30" style="text-align: right;"><%=supply04 %></td>
								</tr>
								<tr>
									<td height="30">
										<strong>전년도</strong>
									</td>
									<td height="30" style="text-align: right;"><%=supply11 %></td>
									<td height="30" style="text-align: right;"><%=supply12 %></td>
									<td height="30" style="text-align: right;"><%=supply13 %></td>
									<td height="30" style="text-align: right;"><%=supply14 %></td>
								</tr>
<%
	}
%>
							</table>
							<div class="Notice mgt_10">
								<h2>공지사항 <span>
									<a href="/menu/board/community/noticeListVen.sys?_menuCd=VEN_CS_NOTICE" target="_self">
										<img src="/img/contents/main_more.gif" />
									</a>
								</span></h2>
								<dl class="mgt_10">
<%
	if(noticeList != null){
		BoardDto noticeInfo           = null;
		String   title                = null;
		String   regDateTime          = null;
		String   boardNo              = null;
		String   isNew                = null;
		String   importantYn          = null;
		int      noticeListSize       = noticeList.size();
		int      i                    = 0;
		
		for(i = 0; i < noticeListSize; i++){
			noticeInfo  = noticeList.get(i);
			title       = noticeInfo.getTitle();
			regDateTime = noticeInfo.getRegi_Date_Time();
			boardNo     = noticeInfo.getBoard_No();
			isNew       = noticeInfo.getIsNew();
			importantYn = noticeInfo.getImportantYn();
			title       = CommonUtils.getByteSubstring(title, 50, "..."); // 제목 길이 조정
			
			if("Y".equals(importantYn)){
				isNew = "N";
			}
%>
							<dt>
<%
			if("Y".equals(isNew)){
%>
								<img src="/img/contents/icon_notice02.gif" />
<%
			}

			if("Y".equals(importantYn)){
%>							
								<img src="/img/contents/icon_notice03.gif" />
<%
			}
%>
								<a href="javascript:fnNoticeDetailPop('<%=boardNo %>');"><%=title %></a>
							</dt>
							<dd><%=regDateTime %></dd>
<%
		}
	}
%>
							</dl>
						</div>
					</div>
					<div class="BoxCont">
						<h2>
							상품현황 <font color="gray" size="2">(<%=CommonUtils.getCustomDay("DAY", -1) %> 기준)</font>
							<span style="position: absolute; margin-top: 10px;margin-left: 290px;">
								<a href="/product/productVenList.sys?_menuCd=VEN_PDT_MANAGE" target="_self">
									<img src="/img/contents/main_more.gif" />
								</a>
							</span>
						</h2>
						<table width="100%">
							<colgroup>
								<col width="auto" />
								<col width="15%" />
								<col width="15%" />
								<col width="15%" />
								<col width="15%" />
								<col width="15%" />
							</colgroup>
<%
	if(productList != null){
		String info01 = productList.get("info01");
		String info02 = productList.get("info02");
		String info03 = productList.get("info03");
		String info04 = productList.get("info04");
		String info05 = productList.get("info05");
		String info06 = productList.get("info06");
		String info07 = productList.get("info07");
		String info08 = productList.get("info08");
		String info09 = productList.get("info09");
		String info10 = productList.get("info10");
		String info11 = productList.get("info11");
		String info12 = productList.get("info12");
		String info13 = productList.get("info13");
		String info14 = productList.get("info14");
		String info15 = productList.get("info15");
%>
							<tr>
								<th rowspan="2">구분</th>
								<th colspan="4">당월</th>
								<th rowspan="2">누적</th>
							</tr>
							<tr>
								<th>신규</th>
								<th>변경</th>
								<th>종료</th>
								<th>소계</th>
							</tr>
							<tr>
								<td>
									<strong>일반</strong>
								</td>
								<td style="text-align: right;"><%=info01 %></td>
								<td style="text-align: right;"><%=info02 %></td>
								<td style="text-align: right;"><%=info03 %></td>
								<td style="text-align: right;"><%=info04 %></td>
								<td style="text-align: right;"><%=info05 %></td>
							</tr>
							<tr>
								<td>
									<strong>지정</strong>
								</td>
								<td style="text-align: right;"><%=info06 %></td>
								<td style="text-align: right;"><%=info07 %></td>
								<td style="text-align: right;"><%=info08 %></td>
								<td style="text-align: right;"><%=info09 %></td>
								<td style="text-align: right;"><%=info10 %></td>
							</tr>
							<tr>
								<td>
									<strong>총계</strong>
								</td>
								<td style="text-align: right;"><%=info11 %></td>
								<td style="text-align: right;"><%=info12 %></td>
								<td style="text-align: right;"><%=info13 %></td>
								<td style="text-align: right;"><%=info14 %></td>
								<td style="text-align: right;"><%=info15 %></td>
							</tr>
<%
	}
%>
						</table>
						<h2 class="mgt_5">
							세금계산서
							<span style="position: absolute; margin-top: 10px;margin-left: 290px;">
								<a href="/venAdjust/ebillVenList.sys?_menuCd=VEN_ACC_TAX" target="_self">
									<img src="/img/contents/main_more.gif" />
								</a>
							</span>
						</h2>
						<table width="100%">
							<colgroup>
								<col width="25%" />
								<col width="25%" />
								<col width="25%" />
								<col width="25%" />
							</colgroup>
							<tr>
								<th>발행일</th>
								<th>금액</th>
								<th>세금계산서</th>
								<th>거래내역서</th>
							</tr>
<%
	if(taxList != null){
		Map<String, String> taxInfo      = null;
		String              busiSequNumb = null;
		String              closBuyiDate = null;
		String              buyiTotaAmou = null;
		String              pubCode      = null;
		int                 taxListSize  = taxList.size();
		int                 i            = 0;
		
		for(i = 0; i < taxListSize; i++){
			taxInfo = taxList.get(i);
			busiSequNumb = taxInfo.get("busiSequNumb");
			closBuyiDate = taxInfo.get("closBuyiDate");
			buyiTotaAmou = taxInfo.get("buyiTotaAmou");
			pubCode      = taxInfo.get("pubCode");
%>

							<tr>
								<td><%=closBuyiDate %></td>
								<td style="text-align: right;"><%=buyiTotaAmou %></td>
								<td>
<%
			if("".equals(buyiTotaAmou) == false) {
%>
									<a href='javascript:void(0);'>
										<img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick="javaScript:fnEBill('<%=pubCode %>')"/>
									</a>
<%
			}
%>
								</td>
								<td>
<%
			if("".equals(buyiTotaAmou) == false) {
%>
									<a href='javascript:void(0);'>
										<img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick="javaScript:fnEPay('<%=busiSequNumb %>')"/>
									</a>
<%
			}
%>
								</td>
							</tr>
<%
		}
		
		for(i = 3 - taxListSize; i > 0; i-- ){
%>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
<%
		}
	}
%>
						</table>
						<h2 class="mgt_5">스마일 지수</h2>
						<table width="100%">
							<colgroup>
								<col width="50%" />
								<col width="50%" />
							</colgroup>
							<tr>
								<th>당월</th>
								<th>누적</th>
							</tr>
<%
	if(smileInfo != null){
		String t = smileInfo.get("t");
		String a = smileInfo.get("a");
%>
							<tr>
								<td style="text-align: right;"><%=a %></td>
								<td style="text-align: right;"><%=t %></td>
							</tr>
<%
	}
%>
						</table>
					</div>
					<ul class="banner">
						<li>
							<img src="/img/contents/main_banner01_1.gif" usemap="#Map" />
							<map name="Map" id="Map">
								<area shape="rect" coords="104,13,171,32" href="javascript:fnContractView('B');" />
								<area shape="rect" coords="102,32,195,50" href="javascript:fnContractView('S');" />
								<input type="hidden" id="contractBView" />
								<input type="hidden" id="contractSView" />
							</map>
						</li>
						<li>
							<a href="javascript:alert('준비중입니다.');">
								<img src="/img/contents/main_banner02.gif" />
							</a>
						</li>
						<li>
							<a href="javascript:vocGo();">
								<img src="/img/contents/main_banner03.gif" />
							</a>
						</li>
						<li>
							<a href="https://www.docusharp.com/member/join.jsp" target="_blank">
								<img src="/img/contents/main_banner04.gif" />
							</a>
						</li>
						<li>
							<a href="javascript:window.open('http://113366.com/okplaza','remoteManagePop', 'width=950, height=700, scrollbars=yes, status=no, resizable=no');void(0);">
								<img src="/img/contents/main_banner05_1.gif" />
							</a>
						</li>
						<li>
							<a href="/proposal/viewProposalListVen.sys?_menuCd=VEN_PDT_PROPOSAL" target="_self">
								<img src="/img/contents/main_banner06_ven.gif" />
							</a>
						</li>
					</ul>
					<div class="Alarm">
						<div class="slide" style="width: 645px;">
							<marquee direction="left" onmouseover=stop() onmouseout=start()>
<%
	if(emergencyList != null){
		BoardDto noticeInfo        = null;
		String   title             = null;
		String   boardNo           = null;
		int      emergencyListSize = emergencyList.size();
		int      i                 = 0;
		
		for(i = 0; i < emergencyListSize; i++){
			noticeInfo  = emergencyList.get(i);
			title       = noticeInfo.getTitle();
			boardNo     = noticeInfo.getBoard_No();
%>

								<a style="color:#002060;font-weight:bold" href="javascript:fnNoticeDetailPop('<%=boardNo %>');"><%=title %></a>
								<img src="/img/contents/icon_new.png" />
								&nbsp;&nbsp;&nbsp;
<%
		}
	}
%>
							</marquee>
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
	<hr>
</div>
	<%--업체평가 팝업 --%>
<%if( smileEvalInfo != null && (Boolean)smileEvalInfo.get("isSmile")==true ){ %>
	<div id="smilePopJqm">	
		<div id="divPopup" style="width:600px;">
			<div id="smilePopDrag">
				<h1>스마일 지수 조사<a href="#;"></a></h1>
			</div>
			<div class="popcont">
			<p class="mgb_10"><img src="/img/contents/img_smile.gif" /></p>
				<div class="GridList">
					<table>
						<colgroup>
							<col width="120px" />
							<col width="auto" />
							<col width="120px" />
						</colgroup>
						<tr>
							<th>조사영역</th>
							<th colspan="2">설문내용</th>
						</tr>
<%
		List<Map<String,Object>> smileList = (List<Map<String,Object>>)smileEvalInfo.get("smileList");
		Map<String,Object> smile = null;
		String smileId = null;
		if( smileList  != null && smileList.size() > 0){
			int admCnt = (Integer)smileEvalInfo.get("admCnt");
			int venCnt = (Integer)smileEvalInfo.get("venCnt") ;
			for( int i=1 ; i < smileList.size()+1 ; i++){
				smile = (HashMap<String,Object>)smileList.get(i-1);
				smileId = CommonUtils.getString( smile.get("SMILE_ID") );
%>
				<tr>
<% 				if( i == 1 ){%>
					<td rowspan="<%=admCnt%>" align="center">
						<strong>SKTS</strong>
					</td>
<%				}	%>
					<td>
						<p><%=CommonUtils.getString( smile.get("EVAL_CONTENTS")) %></p>
						<input type="hidden" id="smileId_<%=smileId %>"  name="smileId_<%=smileId %>" class="smileId" value="<%=smileId %>"/>
						<input type="hidden" id="targetSvcCd_<%=smileId %>" name="targetSvcCd_<%=smileId %>" value="<%=smile.get("TARGET_SVCTYPECD")%>"></input>			
					</td>
					<td align="center">
						<input type="radio" name="evalA_<%=smileId %>"  value="100" /> <label for="radio">Yes</label> 
						<input type="radio" name="evalA_<%=smileId %>"  value="0" /> <label for="radio">No</label>
					</td>
				</tr>

<%			
			}//end of for
		}
%>
					</table>
				</div>
				<p class="col02 mgt_5">고객님의 작은 목소리를 경청 하겠습니다. 참여해 주셔서 감사합니다.</p>
				<div class="Ar mgt_10">
					<button class="btn btn-darkgray btn-xs"  onclick="javascript:fnSmileEval();"> 보내기</button>
				</div>
			</div>
		</div>
	</div>
<% } %>		
	<%--/업체평가 팝업 --%>
<script type="text/javascript">
function fnContractToDoList(){
	$.post(
		"/common/contractToDoList.sys",
		{
			borgId:"<%=loginUserDto.getBorgId()%>"
		},
		function(arg){
			var svcTypeCd	= arg.svcTypeCd;
			var list		= arg.list;
			var listLength	= list.length;
			var i           = 0;
			var listInfo    = null;
			var classify    = null;
			var version     = null;
			
			if(listLength > 0){
				for(i = 0; i < listLength; i++){
					listInfo = list[i];
					classify = listInfo.CONTRACT_CLASSIFY;
					version  = listInfo.CONTRACT_VERSION;
					
					if("Q" == classify){
						document.getElementById("contractSView").value = version;
					}
					else if("B" == classify){
						document.getElementById("contractBView").value = version;
					}
				}
			}
		},
		"json"
	);
}

function fnContractView(contractClassify) {
	var params          = 'svcTypeCd=VEN';
	var contractVersion = null;
	
	if("S" == contractClassify){
		contractVersion = document.getElementById("contractSView").value;
	}
	else if("B" == contractClassify){
		contractVersion = document.getElementById("contractBView").value;
	}
	
	params = params + '&contractVersion='+contractVersion;
	
	window.open('/common/popContractDetail.sys', 'popContractDetail', 'width=917, height=720, scrollbars=yes, status=no, resizable=no');
	
// 	fnDynamicForm("/common/popContractDetail.sys", params, "popContractDetail");
}
</script>
<!-- 설문조사 팝업 처리 시작 -->
<div id="pollPop"></div>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script type="text/javascript">
$(function() {
    $.ajaxSetup ({
        cache: false
    });
    $('#pollPop').load('/board/poll/popup.sys');
});
</script>
<!-- 설문조사 팝업 처리 끝 -->
</body>
</html>