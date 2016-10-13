<%@page import="java.util.HashMap"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.adjust.dto.AdjustDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>
<%
	//그리드의 width와 Height을 정의
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	int EndYear   = 2009;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	String startSelected = CommonUtils.getCustomDay("MONTH", -12).split("-")[0];
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
	   srcYearArr[i] = (StartYear - i) + "";
	}    
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
});
</script>


<style type="text/css">
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
.jqmPop {
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

.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:2px;
    padding-left:2px;
    padding-top:4px;
    padding-bottom:4px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}

</style>


<body class="mainBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
  	<!-- /header -->
    <hr>
		<div id="divBody">
        	<div id="divSub">
            	<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
            	<!--카테고리(S)-->
			
				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">채무관리</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;"><a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a></div>
					<table class="InputTable">
						<colgroup>
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>발급년월</th>
							<td>
								<select id="srcClosStartYear" name="srcClosStartYear" class="select" style="width: 70px;">
<%
	for(int i = 0 ; i < srcYearArr.length ; i++){
%>
									<option value='<%=srcYearArr[i]%>' <%=startSelected.equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%
	}
%>
								</select> 년

								<select id="srcClosStartMonth" name="srcClosStartMonth" class="select" style="width: 50px;">
<%
	for(int i = 0 ; i < 12 ; i++){
%>
									<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%
	}
%>
								</select> 월 ~
								<select id="srcClosEndYear" name="srcClosEndYear" class="select" style="width: 70px;">
<%
	for(int i = 0 ; i < srcYearArr.length ; i++){
%>
									<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%
	}
%>
								</select> 년
								<select id="srcClosEndMonth" name="srcClosEndMonth" class="select" style="width: 70px;">
<%
	for(int i = 0 ; i < 12 ; i++){
%>
									<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%
	}
%>
								</select> 월 
								
							</td>
							<th>사업장</th>
							<td>
								<select id="srcBranchId" name="srcBranchId" class="select">
									<option value="">전체</option>
<%
	@SuppressWarnings("unchecked")	
	List<HashMap<String, Object>> branchList = (List<HashMap<String, Object>>)request.getAttribute("branchList");
 	String borgSelected =  userInfoDto.getBorgId();
	if(branchList != null && branchList.size() > 0){
		for(HashMap<String, Object> listMap : branchList){
%>
									<option value="<%=listMap.get("BRANCHID")%>" <%=borgSelected.equals(listMap.get("BRANCHID")) ? "selected":"" %>><%=listMap.get("BORGNM") %></option>
<%			
			
		}
	}
%>
								</select>
							</td>
							<th>잔액여부</th>
							<td>
								<select id="srcPayStat" name="srcPayStat" class="select">
									<option value="">전체</option>
									<option value="10" selected="selected">있음</option>
									<option value="20">없음</option>
								</select>
							</td>
						</tr>
					</table>
				
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						
							<tr>
								<td bgcolor="#FFFFFF">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr><td style="height: 5px;"></td></tr>
										<tr>
											<td>
												<div id="jqgrid">
													<table id="list"></table>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table> 
					</form>	
					<div style="height:10px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
	<form id="ebillPopFrm" name="ebillPopFrm" onsubmit="return false;" >
		<input id="pubCode" name="pubCode" type="hidden"/>
		<input id="docType" name="docType" type="hidden" value="T"/>
		<input id="userType" name="userType" type="hidden" value="R"/>
	</form>
</body>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click(function(){fnSearch();});
});


</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var setRowId = "";
jq(function() {
	jq("#list").jqGrid({
		url:'/BuyAdjust/adjustBuyBondsCompanyListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['sale_sequ_numb','accManageUserId','전표번호','사업장명','계산서발행일','만기일','총채무','입금금액<br/>(입금일)','잔액','상태','지연일수','거래명세서','pubcode','매출금액','rece_pay_amou'],
		colModel:[
			{name:'sale_sequ_numb', index:'sale_sequ_numb', hidden:true },
			{name:'accManageUserId', index:'accManageUserId',hidden:true },
			{name:'sap_jour_numb', index:'sap_jour_numb', hidden:true },//전표번호
			{name:'branchNm', index:'branchNm',width:150,align:"left"},//사업장명
			{name:'clos_sale_date', index:'clos_sale_date',width:100,align:"center"},//계산서발행일
			{name:'expiration_date',index:'expiration_date',width:100,align:"center"},//만기일
			{name:'sale_tota_amou', index:'sale_tota_amou',width:100,align:"right", sorttype:'integer',formatter:'integer',
					formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},// 총채무
			{name:'payAndDate',index:'payAndDate',width:100,align:"right"},//입금금액(입금일자)
			{name:'none_coll_amou',index:'none_coll_amou',width:100,align:"right", sorttype:'integer',formatter:'integer',
					formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//잔액
			{name:'tran_status_nm',index:'tran_status_nm',width:70,align:"center"},//상태
			{name:'sale_over_day',index:'over_date',width:70,align:"center"},//지연일수
			{name:'eBill',index:'eBill',width:80,align:"center", sortable:false},//거래명세서
			{name:'pubcode',index:'pubcode',hidden:true},//pubcode
			{name:'sale_requ_amou',index:'sale_requ_amou',hidden:true},//매출금액
			{name:'rece_pay_amou',index:'rece_pay_amou',hidden:true}//입금금액
		],
		postData: {
			clientId:'<%=userInfoDto.getClientId()%>',
			srcPayStat:$("#srcPayStat").val(),       
			srcClosStartYear:$("#srcClosStartYear").val(), 
			srcClosStartMonth:$("#srcClosStartMonth").val(), 
			srcClosEndYear:$("#srcClosEndYear").val(),   
			srcClosEndMonth:$("#srcClosEndMonth").val(),
			srcBranchId:"<%=userInfoDto.getSmpBranchsDto().getBranchId()%>"
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100],
		height: 425,autowidth: true,
		sortname: 'clos_sale_date', sortorder: 'desc',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var sum_sale_tota_amou = 0;
			var sum_rece_pay_amou = 0;
			var sum_none_coll_amou = 0;
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				if(setRowId == ""){
					setRowId = $("#list").getDataIDs()[0]; //첫번째 로우 아이디 구하기	
				}

				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					sum_sale_tota_amou += parseInt(selrowContent.sale_tota_amou);
					sum_rece_pay_amou += parseInt(selrowContent.rece_pay_amou);
					sum_none_coll_amou += parseInt(selrowContent.none_coll_amou);  
					if(selrowContent.sale_requ_amou != '0'){
						var eBillStr  = "<a href='#'><img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick=\"javaScript:fnEBill('"+rowid+"')\"/></a>";
						jq("#list").jqGrid('setRowData', rowid, {eBill:eBillStr});
					}
				}

			}
			var userData = jq("#list").jqGrid("getGridParam","userData");
			userData.clos_sale_date = "합계";
			userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
			userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
			userData.payAndDate = fnComma(sum_rece_pay_amou);
			userData.none_coll_amou = fnComma(sum_none_coll_amou);
			jq("#list").jqGrid("footerData","set",userData,false);   
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt > 0) {
				var id = $("#list").jqGrid('getGridParam', "selrow" );
				var selrowContent = jq("#list").jqGrid('getRowData',id);
				
				$("#sel_sale_sequ_numb").val(selrowContent.sale_sequ_numb);
				$("#sel_rece_pay_amou").val(selrowContent.sale_tota_amou);
				
				setRowId = id;
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true,
		footerrow: true,
		userDataOnFooter: true
	});
});

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");

	data.srcPayStat      	= $("#srcPayStat").val();
	data.srcClosStartYear   = $("#srcClosStartYear").val(); 
	data.srcClosStartMonth  = $("#srcClosStartMonth").val();
	data.srcClosEndYear     = $("#srcClosEndYear").val();
	data.srcClosEndMonth    = $("#srcClosEndMonth").val();
	data.clientId        	= '<%=userInfoDto.getClientId()%>'; 
	data.srcBranchId        = $("#srcBranchId").val(); 
	jq("#list").trigger("reloadGrid");     	
}

//3자리수마다 콤마
function fnComma(n) {
   n += '';
   var reg = /(^[+-]?\d+)(\d{3})/;
   while (reg.test(n)){
      n = n.replace(reg, '$1' + ',' + '$2');
   }
   return n;
}


function fnEBill(rowid){
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
	$("#pubCode").val(selrowContent.pubcode);
	
	if($.trim($("#pubCode").val() != "")){
		var iMyHeight;
		width = (window.screen.width-635)/2;
		if(width<0)width=0;
		iMyWidth = width;
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;		
		
		var taxInvoice = window.open('about:blank', "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=700px, height=760px");
		document.ebillPopFrm.action = "http://<%=Constances.EBILL_URL%>/jsp/directTax/TaxViewIndex.jsp";
		document.ebillPopFrm.method = "post";
		document.ebillPopFrm.target = "taxInvoice";
		document.ebillPopFrm.submit();
		document.ebillPopFrm.target="_self";
		$("#pubCode").val("");
		taxInvoice.focus();
	} else { jq( "#dialogSelectRow" ).dialog(); }   
}

</script>
</html>