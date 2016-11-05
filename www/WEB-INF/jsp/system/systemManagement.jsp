<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
	LoginUserDto              loginUserDto       = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	List<BoardDto>            noticeList         = (List<BoardDto>)request.getAttribute("noticeList");
	List<Map<String, String>> batchList          = (List<Map<String, String>>)request.getAttribute("batchList");
	//List<Map<String, String>> productRequestList = (List<Map<String, String>>)request.getAttribute("productRequestList");
	Map<String, String>       sideCount          = (Map<String, String>)request.getAttribute("sideCount");
	Map<String, String>       vocCount           = (Map<String, String>)request.getAttribute("vocCount");
	Map<String, String>       smilePoint         = (Map<String, String>)request.getAttribute("smilePoint");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
 
<style>
div.grayLine {
	height:0px;
	border-top:  1px dotted #ccc;
	border-bottom: 0px;
	border-left: 0px;
	border-right: 0px;
	padding-top: 0px;
	padding-bottom: 0px;
	padding-left: 0px;
	padding-right: 0px;
}
</style>

<script type="text/javascript">
function fnNoticeDetailPop(boardNo){
	var params = "board_No=" + boardNo;
	
	window.open("", 'noticeDetailPop', 'width=720, height=510, scrollbars=yes, status=no, resizable=yes');
	
	fnDynamicForm("/board/noticeDetail.sys", params, "noticeDetailPop");
}

function MM_preloadImages() { //v3.0
	var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
	var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function fnNewProductRequestListForAdm(){
	fnDynamicForm("/product/newProductRequestListForAdm.sys", "_menuCd=ADM_NEWPROD_REQU&srcFlag=true", "_self");	
}

function fnOrderPrePayList(){
	fnDynamicForm("/order/orderRequest/orderPrePayList.sys", "_menuCd=ADM_ORDER_PREPAY&prePayType=2", "_self");	
}

function fnOrganClientRegistRequestList(){
	fnDynamicForm("/organ/organClientRegistRequestList.sys", "_menuCd=ADM_ORGAN_REGI_REQST&srcFlag=true", "_self");
}

function fnProductRequestRegistList(){
	fnDynamicForm("/product/productRequestRegistList.sys", "_menuCd=ADM_PROD_REQU_REGI&srcFlag=true", "_self");
}

function fnProductRequestDiscontinuanceList(){
	fnDynamicForm("/product/productRequestDiscontinuanceList.sys", "_menuCd=ADM_PROD_REQU_DISC&srcFlag=true", "_self");
}

function fnOrderDivList(){
	fnDynamicForm("/order/orderRequest/orderDivList.sys", "_menuCd=ADM_ORDER_DIV_LIST", "_self");
}

function fnOrganVendorRegistRequestList(){
	fnDynamicForm("/organ/organVendorRegistRequestList.sys", "_menuCd=ADM_ORGAN_VENDOR_REG&srcFlag=true", "_self");
}

function fnViewProposalList(){
	fnDynamicForm("/proposal/viewProposalList.sys", "_menuCd=ADM_NEWMATERIAL&srcFlag=true", "_self");
}

function vocGo(){	
	window.open("", 'requestManageWrite', 'width=720, height=600, scrollbars=yes, status=no, resizable=yes');
	
	fnDynamicForm("/board/requestManageWrite.sys", "", "requestManageWrite");
}

$(document).ready(function() {
	fnContractToDoList();
	fnSideBarInfo();
});

function fnSideBarInfo() {
	$.post(
		"/system/getSideBarInfo.sys",
		function(arg) {
			$("#brc01").html("상품등록 요청 (<a href='javascript:void(0);' class='col02'>"+arg.brc01+"</a>)");
			$("#ven03").html("물량배분 (<a href='javascript:void(0);' class='col02'>"+arg.ven03+"</a>)");
			$("#brc02").html("선입금주문처리 (<a href='javascript:void(0);' class='col02'>"+arg.brc02+"</a>)");
			$("#brc03").html("구매사등록요청 (<a href='javascript:void(0);' class='col02'>"+arg.brc03+"</a>)");

			$("#ven01").html("상품등록요청 (<a href='javascript:void(0);' class='col02'>"+arg.ven01+"</a>)");
			$("#ven02").html("상품변경요청 (<a href='javascript:void(0);' class='col02'>"+arg.ven02+"</a>)");
			$("#ven04").html("공급사등록요청 (<a href='javascript:void(0);' class='col02'>"+arg.ven04+"</a>)");
		},
		"json"
	);
}
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
	
	window.open('', 'popContractDetail', 'width=917, height=720, scrollbars=yes, status=no, resizable=yes');
	
	fnDynamicForm("/common/popContractDetail.sys", params, "popContractDetail");
}
</script>
</head>
<%-- --%> 
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css"> 
<body onload="MM_preloadImages('/img/contents/boss_quickbanner01_over.gif','/img/contents/boss_quickbanner02_over.gif','/img/contents/boss_quickbanner03_over.gif')">
	<div id="bossMain" style="height: 620px;">
		<div class="BoxCont" style="padding-right: 20px;">
			<h2><i class="fa fa-area-chart" style="color: #DF0223;"></i>&nbsp;매출현황&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="/analysis/analysisSummaryList.sys?_menuCd=ADM_ANAL_SUM" target="_self">
 				<img src="/img/contents/main_more.gif">
 			</a>
			<span style="position:absolute; margin-left:430px; font-size: x-small;">단위 : 백만원</span></h2>
			<table width="100%">
				<colgroup>
					<col width="14%" />
					<col width="14%" />
					<col width="14%" />
					<col width="14%" />
					<col width="14%" />
					<col width="14%" />
					<col width="16%" />
				</colgroup>
				<tr>
					<th colspan="4">당월</th>
					<th colspan="3">년간누적</th>
				</tr>
				<tr>
					<th>주문금액</th>
					<th>배송중</th>
					<th>인수금액</th>
					<th>매출처리</th>
					<th>매출</th>
					<th>매출이익</th>
					<th>이익율</th>
				</tr>
<%
	if(batchList != null){
		Map<String, String> info     = null;
		String              infoType = null;
		String              info01   = null;
		String              info02   = null;
		String              info03   = null;
		String              info04   = null;
		String              info05   = null;
		String              info06   = null;
		String              info07   = null;
		int                 i        = 0;
		int                 lisSize  = batchList.size();
		
		for(i = 0; i < lisSize; i++){
			info     = batchList.get(i);
			infoType = info.get("infoType");
			
			if("1".equals(infoType)){
				info01   = info.get("info01");   
				info02   = info.get("info02");   
				info03   = info.get("info03"); 
				info04   = info.get("info04");   
				info05   = info.get("info05");  
				info06   = info.get("info06");
				info07   = info.get("info07");
%>
				<tr>
					<td style="text-align: right;"><%=info01 %></td>
					<td style="text-align: right;"><%=info02 %></td>
					<td style="text-align: right;"><%=info03 %></td>
					<td style="text-align: right;"><%=info04 %></td>
					<td style="text-align: right;"><%=info05 %></td>
					<td style="text-align: right;"><%=info06 %></td>
					<td style="text-align: right;"><%=info07 %> %</td>
				</tr>
<%
			}
		}	
	}
%>

			</table>
			<div class="space-4"></div>
			<h2 class="mgt_10"><i class="fa fa-balance-scale" style="color: #DF0223;"></i>&nbsp;채권현황&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="/adjust/adjustBondsSummary.sys?_menuCd=ADM_ADJU_SUMMARY" target="_self">
 				<img src="/img/contents/main_more.gif">
 			</a>
			<span style="position:absolute; margin-left:430px; font-size: x-small;">단위 : 백만원</span></h2>
			<table width="100%">
				<colgroup>
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
				</colgroup>
				<tr>
					<th>채권금액(전월 말)</th>
					<th>당월 수금액</th>
					<th>채권잔액</th>
					<th>정상채권 회수율</th>
					<th>주문제한 업체수</th>
				</tr>
<%
	if(batchList != null){
		Map<String, String> info     = null;
		String              infoType = null;
		String              info01   = null;
		String              info02   = null;
		String              info03   = null;
		String              info04   = null;
		String              info05   = null;
		int                 i        = 0;
		int                 lisSize  = batchList.size();
		
		for(i = 0; i < lisSize; i++){
			info     = batchList.get(i);
			infoType = info.get("infoType");
			      
			if("2".equals(infoType)){
				info01   = info.get("info01");  
				info02   = info.get("info02");  
				info03   = info.get("info03");
				info04   = info.get("info04");  
				info05   = info.get("info05");
%>
				<tr>
					<td style="text-align: right;"><%=info01 %></td>
					<td style="text-align: right;"><%=info02 %></td>
					<td style="text-align: right;"><%=info03 %></td>
					<td style="text-align: right;"><%=info04 %> %</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/adjust/adjustBondsTotal.sys?_menuCd=ADM_ADJU_BOND&flag2=1" target="_self">
							<font color="blue"><%=info05 %></font>
						</a>
					</td>
				</tr>
<%
			}
		}	
	}
%>
			</table>
			<table width="100%" class="mgt_5">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tr>
					<th>구분</th>
					<th>정상채권</th>
					<th>관리채권</th>
					<th>장기채권</th>
				</tr>
<%
	if(batchList != null){
		Map<String, String> info     = null;
		String              infoType = null;
		String              info01   = null;
		String              info02   = null;
		String              info03   = null;
		String              info04   = null;
		String              info05   = null;
		String              info06   = null;
		String              info07   = null;
		String              info08   = null;
		String              info09   = null;
		int                 i        = 0;
		int                 lisSize  = batchList.size();
		
		for(i = 0; i < lisSize; i++){
			info     = batchList.get(i);
			infoType = info.get("infoType");
			      
			if("3".equals(infoType)){
				info01   = info.get("info01");   
				info02   = info.get("info02");   
				info03   = info.get("info03"); 
				info04   = info.get("info04");   
				info05   = info.get("info05");
				info06   = info.get("info06");
				info07   = info.get("info07");
				info08   = info.get("info08");
				info09   = info.get("info09");
%>
				<tr>
					<td style="text-align: left;">
						<strong>채권 액</strong>
					</td>
					<td style="text-align: right;"><%=info01 %></td>
					<td style="text-align: right;"><%=info02 %></td>
					<td style="text-align: right;"><%=info03 %></td>
				</tr>
				<tr>
					<td style="text-align: left;">
						<strong>점유율</strong>
					</td>
					<td style="text-align: right;"><%=info04 %> %</td>
					<td style="text-align: right;"><%=info05 %> %</td>
					<td style="text-align: right;"><%=info06 %> %</td>
				</tr>
				<tr>
					<td style="text-align: left;">
						<strong>업체 수</strong>
					</td>
					<td style="text-align: right;"><%=info07 %></td>
					<td style="text-align: right;"><%=info08 %></td>
					<td style="text-align: right;"><%=info09 %></td>
				</tr>
<%
			}
		}	
	}
%>
			</table>
			<div class="space-4"></div>
			<h2 class="mgt_10"><i class="fa fa-commenting" style="color: #DF0223;"></i>&nbsp;고객 VOC 현황</h2>
			<table width="100%" class="mgt_5">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tr>
					<th>구분</th>
					<th>요청</th>
					<th>조치 중</th>
					<th>종결(누적)</th>
				</tr>
<%
	if(vocCount != null){
 		String vocRequest        = vocCount.get("vocRequest");
 		String vocAccept         = vocCount.get("vocAccept");
 		String vocEnd            = vocCount.get("vocEnd");
 		String newProductRequest = vocCount.get("newProductRequest");
 		String newProductAccept  = vocCount.get("newProductAccept");
 		String newProductEnd     = vocCount.get("newProductEnd");
 		String qnaRequest        = vocCount.get("qnaRequest");
 		String qnaEnd            = vocCount.get("qnaEnd");
%>
				<tr>
					<td style="text-align: left;">
						<strong>유지보수</strong>
					</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/menu/board/repair/repairListAdm.sys?_menuCd=ADM_BOARD_MAINTENANC&srcState=0" target="_self">
							<font color='blue'><%=vocRequest %></font>
						</a>
					</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/menu/board/repair/repairListAdm.sys?_menuCd=ADM_BOARD_MAINTENANC&srcState=10" target="_self">
							<font color='blue'><%=vocAccept %></font>
						</a>
					</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/menu/board/repair/repairListAdm.sys?_menuCd=ADM_BOARD_MAINTENANC&srcState=90" target="_self">
							<font color='blue'><%=vocEnd %></font>
						</a>
					</td>
				</tr>
				<tr>
					<td style="text-align: left;">
						<strong>Q&amp;A</strong>
					</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/board/requestManageList.sys?_menuCd=ADM_BOARD_REQU&srcStatFlagCode=0" target="_self">
							<font color='blue'><%=qnaRequest %></font>
						</a>
					</td>
					<td style="text-align: right;">-</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/board/requestManageList.sys?_menuCd=ADM_BOARD_REQU&srcStatFlagCode=2" target="_self">
							<font color='blue'><%=qnaEnd %></font>
						</a>
					</td>
				</tr>				
				<tr>
					<td style="text-align: left;">
						<strong>신규상품제안</strong>
					</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/proposal/viewProposalList.sys?_menuCd=ADM_NEWMATERIAL&srcFinalProcStatFlagNm=10" target="_self">
							<font color='blue'><%=newProductRequest %></font>
						</a>
					</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/proposal/viewProposalList.sys?_menuCd=ADM_NEWMATERIAL&srcFinalProcStatFlagNm=20" target="_self">
							<font color='blue'><%=newProductAccept %></font>
						</a>
					</td>
					<td style="text-align: right; color: blue; text-decoration: underline;">
						<a href="/proposal/viewProposalList.sys?_menuCd=ADM_NEWMATERIAL&srcFinalProcStatFlagNm=41" target="_self">
							<font color='blue'><%=newProductEnd %></font>
						</a>
					</td>
				</tr>
<%
	}
%>
			</table>
		</div>
		<div class="BoxCont">
			<h2><i class="fa fa-building" style="color: #DF0223;"></i>&nbsp;고객사 현황</h2>
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
					<th colspan="3">당월</th>
					<th rowspan="2">누적</th>
				</tr>
				<tr>
					<th>신규</th>
					<th>종료</th>
					<th>소계</th>
				</tr>
<%
	if(batchList != null){
		Map<String, String> info     = null;
		String              infoType = null;
		String              info01   = null;
		String              info02   = null;
		String              info03   = null;
		String              info04   = null;
		String              info05   = null;
		String              info06   = null;
		String              info07   = null;
		String              info08   = null;
		int                 i        = 0;
		int                 lisSize  = batchList.size();
		
		for(i = 0; i < lisSize; i++){
			info     = batchList.get(i);
			infoType = info.get("infoType");
			      
			if("4".equals(infoType)){
				info01   = info.get("info01");   
				info02   = info.get("info02");   
				info03   = info.get("info03"); 
				info04   = info.get("info04");   
				info05   = info.get("info05");
				info06   = info.get("info06");
				info07   = info.get("info07");
				info08   = info.get("info08");
%>
				<tr>
					<td style="text-align: left;">
						<strong>구매사</strong>
					</td>
					<td style="text-align: right;"><%=info01 %></td>
					<td style="text-align: right;"><%=info02 %></td>
					<td style="text-align: right;"><%=info03 %></td>
					<td style="text-align: right;"><%=info04 %></td>
				</tr>
				<tr>
					<td style="text-align: left;">
						<strong>공급사</strong>
					</td>
					<td style="text-align: right;"><%=info05 %></td>
					<td style="text-align: right;"><%=info06 %></td>
					<td style="text-align: right;"><%=info07 %></td>
					<td style="text-align: right;"><%=info08 %></td>
				</tr>
<%
			}
		}	
	}
%>
			</table>
			<div class="space-6"></div>
			<h2 class="mgt_10"><i class="fa fa-cubes" style="color: #DF0223;"></i>&nbsp;상품 현황
 				<span style="position:absolute; margin-left:520px;margin-top: 5px;">
					<a href="/product/productAdmList.sys?_menuCd=ADM_PROD_SEARCH" target="_self">
	 					<img src="/img/contents/main_more.gif">
	 				</a>
 				</span>
 			</h2>
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
					<th colspan="3">당월</th>
					<th rowspan="2">누적</th>
				</tr>
				<tr>
					<th>신규</th>
					<th>종료</th>
					<th>소계</th>
				</tr>
<%
	if(batchList != null){
		Map<String, String> info     = null;
		String              infoType = null;
		String              info01   = null;
		String              info02   = null;
		String              info03   = null;
		String              info04   = null;
		String              info05   = null;
		String              info06   = null;
		String              info07   = null;
		String              info08   = null;
		String              info09   = null;
		String              info10   = null;
		String              info11   = null;
		String              info12   = null;
		int                 i        = 0;
		int                 lisSize  = batchList.size();
		
		for(i = 0; i < lisSize; i++){
			info     = batchList.get(i);
			infoType = info.get("infoType");
			      
			if("5".equals(infoType)){
				info01   = info.get("info01");   
				info02   = info.get("info02");   
				info03   = info.get("info03"); 
				info04   = info.get("info04");   
				info05   = info.get("info05");
				info06   = info.get("info06");
				info07   = info.get("info07");
				info08   = info.get("info08");
				info09   = info.get("info09");
				info10   = info.get("info10");
				info11   = info.get("info11");
				info12   = info.get("info12");
%>
				<tr>
					<td style="text-align: left;">
						<strong>총 계</strong>
					</td>
					<td style="text-align: right;"><%=info01 %></td>
					<td style="text-align: right;"><%=info02 %></td>
					<td style="text-align: right;"><%=info03 %></td>
					<td style="text-align: right;"><%=info04 %></td>
				</tr>
				<tr>
					<td style="text-align: left;">
						<strong>지정</strong>
					</td>
					<td style="text-align: right;"><%=info05 %></td>
					<td style="text-align: right;"><%=info06 %></td>
					<td style="text-align: right;"><%=info07 %></td>
					<td style="text-align: right;"><%=info08 %></td>
				</tr>
				<tr>
					<td style="text-align: left;">
						<strong>일반</strong>
					</td>
					<td style="text-align: right;"><%=info09 %></td>
					<td style="text-align: right;"><%=info10 %></td>
					<td style="text-align: right;"><%=info11 %></td>
					<td style="text-align: right;"><%=info12 %></td>
				</tr>
<%
			}
		}	
	}
%>
			</table> 
			<div class="Notice mgt_20">
				<h2>
					<i class="fa fa-bullhorn" style="color: #DF0223;"></i>&nbsp;공지사항
 					<span style="position:absolute; margin-left:520px;margin-top: 10px;">
 						<a href="/board/noticeList.sys?_menuCd=ADM_BOARD_COMU_NOTI" target="_self">
 							<img src="/img/contents/main_more.gif" />
 						</a>
 					</span>
				</h2>
				<dl class="mgt_10">
<%
	if(noticeList != null){
		BoardDto noticeInfo     = null;
		String   title          = null;
		String   regDateTime    = null;
		String   boardNo        = null;
		String   isNew          = null;
		String   importantYn    = null;
		int      noticeListSize = noticeList.size();
		int      i              = 0;
		
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
		
		<table style="border-top: #000 !important;">
			<tr>
				<td style="border:solid 0px #000; padding:5px 8px; vertical-align:middle; text-align:center;">
					<div class="grayLine" />
				</td>
			</tr>
		</table>
		
		<div class="BoxBottom2">
			<table style="border-top: grey !important;">
				<tr>
					<th rowspan="3" width="100px">스마일지수</th>
					<th colspan="2" height="5px">SKTS</th>
					<th rowspan="2">공급사</th>
				</tr>
				<tr>
					<th>구매사</th>
					<th>공급사</th>
				</tr>
<%
	if(smilePoint != null){
		String sktsBuyMonth = smilePoint.get("sktsBuyMonth");
 		String sktsVenMonth = smilePoint.get("sktsVenMonth");
 		String venMonth     = smilePoint.get("venMonth");
%>
				<tr>
					<td style="text-align: right;"><%=sktsBuyMonth %></td>
					<td style="text-align: right;"><%=sktsVenMonth %></td>
					<td style="text-align: right;"><%=venMonth %></td>
				</tr>
<%
	}
%>
			</table>
		</div>
		<div class="BoxBottom">
			<span>
				<a href="javascript:fnContractView('B');">
					<img src="/img/contents/document01.gif" name="docu01" id="docu01" width="145px;" onmouseover="MM_swapImage('docu01','','/img/contents/document01_over.gif',1)" onmouseout="MM_swapImgRestore()" />
				</a>
				<input type="hidden" id="contractBView" />
			</span>
			<span class="mgl_5">
				<a href="javascript:fnContractView('S');">
					<img src="/img/contents/document02.gif" name="docu02" id="docu02" width="145px;" onmouseover="MM_swapImage('docu02','','/img/contents/document02_over.gif',1)" onmouseout="MM_swapImgRestore()" />
				</a>
				<input type="hidden" id="contractSView" />
			</span>
			<span class="mgl_5">
				<a href="/upload/sample/SKTS_B2B_VENDOR_SELECTION_GUIDE(20160201).doc">
					<img src="/img/contents/document03.gif" name="docu03" id="docu03" width="145px;" onmouseover="MM_swapImage('docu03','','/img/contents/document03_over.gif',1)" onmouseout="MM_swapImgRestore()" />
				</a>
			</span>
			<span class="mgl_5">
				<a href="/upload/sample/SKTS_B2B_VENDOR_RESTRICTION_GUIDE_(20160202).doc">
					<img src="/img/contents/document04.gif" name="docu04" id="docu04" width="145px;" onmouseover="MM_swapImage('docu04','','/img/contents/document04_over.gif',1)" onmouseout="MM_swapImgRestore()" />
				</a>
			</span>
		</div>
		<div class="BoxBottom3">
			<span>
				<a href="javascript:vocGo();">
					<img src="/img/contents/boss_quickbanner01.gif" name="quick01" id="quick01" width="145px;" onmouseover="MM_swapImage('quick01','','/img/contents/boss_quickbanner01_over.gif',1)" onmouseout="MM_swapImgRestore()" />
				</a>
			</span>
			<span class="mgl_5">
				<a href="https://www.docusharp.com/member/join.jsp" target="_blank">
					<img src="/img/contents/boss_quickbanner02.gif" name="quick02" id="quick02" width="145px;" onmouseover="MM_swapImage('quick02','','/img/contents/boss_quickbanner02_over.gif',1)" onmouseout="MM_swapImgRestore()" />
				</a>
			</span>
			<span class="mgl_5">
				<a href="javascript:window.open('http://113366.com/okplaza','remoteManagePop', 'width=950, height=700, scrollbars=yes, status=no, resizable=yes');void(0);">
					<img src="/img/contents/boss_quickbanner03.gif" name="quick03" id="quick03" width="145px;" onmouseover="MM_swapImage('quick03','','/img/contents/boss_quickbanner03_over.gif',1)" onmouseout="MM_swapImgRestore()" />
				</a>
			</span>
		</div>
		<div id="bossQuick">
			<div id="quickmenu">
				<ul>
<%
// 	if(sideCount != null){
// 		String brc01 = sideCount.get("brc01");
// 		String brc02 = sideCount.get("brc02");
// 		String brc03 = sideCount.get("brc03");
// 		String ven01 = sideCount.get("ven01");
// 		String ven02 = sideCount.get("ven02");
// 		String ven03 = sideCount.get("ven03");
// 		String ven04 = sideCount.get("ven04");
// 		String ven05 = sideCount.get("ven05");
%>
<!-- 					<li class="hd">구매사</li> -->
<!-- 					<li> -->
<%-- 						<div class="bossQ" style="cursor: pointer;" onclick="javascript:fnNewProductRequestListForAdm();">상품등록 요청 (<a href="javascript:void(0);" class="col02"><%=brc01 %></a>)</div> --%>
<%-- 						<div class="bossQ" style="cursor: pointer;" onclick="javascript:fnOrderDivList();">물량배분 (<a href="javascript:void(0);" class="col02"><%=ven03 %></a>)</div> --%>
<%-- 						<div class="bossQ" style="cursor: pointer;" onclick="javascript:fnOrderPrePayList();">선입금주문처리 (<a href="javascript:void(0);" class="col02"><%=brc02 %></a>)</div> --%>
<%-- 						<div class="bossQ" style="cursor: pointer;" onclick="javascript:fnOrganClientRegistRequestList();">구매사등록요청 (<a href="javascript:void(0);" class="col02"><%=brc03 %></a>)</div> --%>
<!-- 					</li> -->
<!-- 					<li class="hd mgt_5">공급사</li> -->
<!-- 					<li> -->
<%-- 						<div class="bossQ" style="cursor: pointer;height: 35px;" onclick="javascript:fnProductRequestRegistList();">상품등록요청 (<a href="javascript:void(0);" class="col02"><%=ven01 %></a>)</div> --%>
<%-- 						<div class="bossQ" style="cursor: pointer;height: 35px;" onclick="javascript:fnProductRequestDiscontinuanceList();">상품변경요청 (<a href="javascript:void(0);" class="col02"><%=ven02 %></a>)</div> --%>
<%-- 						<div class="bossQ" style="cursor: pointer;height: 35px;" onclick="javascript:fnOrganVendorRegistRequestList();">공급사등록요청 (<a href="javascript:void(0);" class="col02"><%=ven04 %></a>)</div> --%>
<%-- 						<div class="bossQ" style="cursor: pointer;" onclick="javascript:fnViewProposalList();">신규제안 건 (<a href="javascript:void(0);" class="col02"><%=ven05 %></a>)</div> --%>
<!-- 					</li> -->
<%
// 	}
%>

					<li class="hd">구매사</li>
					<li>
						<div id="brc01" class="bossQ" style="cursor: pointer;" onclick="javascript:fnNewProductRequestListForAdm();"></div>
						<div id="ven03" class="bossQ" style="cursor: pointer;" onclick="javascript:fnOrderDivList();"></div>
						<div id="brc02" class="bossQ" style="cursor: pointer;" onclick="javascript:fnOrderPrePayList();"></div>
						<div id="brc03" class="bossQ" style="cursor: pointer;" onclick="javascript:fnOrganClientRegistRequestList();"></div>
					</li>
					<li class="hd mgt_5">공급사</li>
					<li>
						<div id="ven01" class="bossQ" style="cursor: pointer;height: 35px;" onclick="javascript:fnProductRequestRegistList();"></div>
						<div id="ven02" class="bossQ" style="cursor: pointer;height: 35px;" onclick="javascript:fnProductRequestDiscontinuanceList();"></div>
						<div id="ven04" class="bossQ" style="cursor: pointer;height: 35px;" onclick="javascript:fnOrganVendorRegistRequestList();"></div>
					</li>
				</ul>
			</div>
		</div>
		
		<table style="border-top: #000 !important;">
			<tr>
				<td style="border:solid 0px #000; padding:5px 8px; vertical-align:middle; text-align:center;">
					<div class="grayLine" />
				</td>
			</tr>
		</table>
		
	</div>
</body>
</html>