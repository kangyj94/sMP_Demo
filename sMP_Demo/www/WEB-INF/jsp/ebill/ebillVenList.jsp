<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = request.getParameter("_menuId")==null ? "" : (String)request.getParameter("_menuId");
	if("".equals(_menuId)) _menuId = request.getAttribute("_menuId")==null ? "" : (String)request.getAttribute("_menuId");
	

	
	int EndYear   = 2009;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
		srcYearArr[i] = (StartYear - i) + "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
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
});
</script>




<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>


<body class="subBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
  	<!-- /header -->
    <hr>
		<div id="divBody">
        	<div id="divSub">
            	<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
            	<!--카테고리(S)-->
			
				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">세금계산서 확인</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;"><a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a></div>
					<table class="InputTable">
						<colgroup>
							<col width="100px" />
							<col width="auto" />
						</colgroup>                  
						<tr>
							<th>발급년월</th>
							<td>
								<input id="srcBorgName" name="srcBorgName" type="hidden" value="" size="20" maxlength="30"  />
								<input id="srcVendorId" name="srcVendorId" type="hidden" value="" size="20" maxlength="30" />
								
								<select id="srcStartYear" name="srcStartYear" class="select" style="width: 70px;">
<% for(int i = 0 ; i < srcYearArr.length ; i++){ %>
									<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", -1).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<% } %>
								</select> 년
								<select id="srcStartMonth" name="srcStartMonth" class="select" style="width: 50px;">
<% for(int i = 0 ; i < 12 ; i++){ %>
									<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", -1).split("-")[1]) == (i+1) ? "selected" : "" %>><%=i+1 %></option>
<% } %>
								</select> 월 ~
								<select id="srcEndYear" name="srcEndYear" class="select" style="width: 70px;">
<% for(int i = 0 ; i < srcYearArr.length ; i++){ %>
									<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<% } %>
								</select> 년
								<select id="srcEndMonth" name="srcEndMonth" class="select" style="width: 50px;">
<% for(int i = 0 ; i < 12 ; i++){ %>
									<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == (i+1) ? "selected" : "" %>><%=i+1 %></option>
<% } %>
								</select> 월
							</td>
						</tr>
					</table>
				
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td bgcolor="#FFFFFF">
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr style="height: 5px;"><td></td></tr>
									<tr>
										<td>
											<div id="jqgrid">
												<table id="list"></table>
												<div id="pager"></div>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table> 
					<div style="height:10px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>

<!-- 공급사검색관련 스크립트 -->
<script type="text/javascript">
var jq = $;
$(document).ready(function(){
<%
	String _srcVendorId = "";
	String _srcBorgName = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
	_srcVendorId = _srcBorgScopeByRoleDto.getSrcBranchId();
	_srcBorgName = _srcBorgScopeByRoleDto.getSrcBorgNms();

%>
	$("#srcBorgName").val("<%=_srcBorgName %>");
	$("#srcVendorId").val("<%=_srcVendorId %>");
	$("#srcBorgName").attr("disabled", true);
	$("#srcButton").click( function() { fnSearch(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
});

 
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/venAdjust/ebillVenListJQGrid.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:['발급일자','전표번호', '거래처명', '사업자등록번호', '공급가액', '세액', '세금계산서', '거래명세서', 'pubcode', 'buyi_sequ_numb'],
		colModel:[
			{name:'clos_date',index:'clos_date', width:85,align:"center",search:false,sortable:true,editable:false },
			{name:'sap_jour_numb',index:'sap_jour_numb', width:120,align:"center",search:false,sortable:true,editable:false },
			{name:'borgNm',index:'borgNm', width:200,align:"left",search:false,sortable:true,editable:false },
			{name:'businessNum',index:'businessNum', width:90,align:"center",search:false,sortable:true,editable:false },
			{name:'buyi_requ_amou',index:'buyi_requ_amou', width:90,align:"right",search:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//공급가액
			{name:'buyi_requ_vtax',index:'buyi_requ_vtax', width:90,align:"right",search:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//세액
			{name:'eBill',index:'eBill', width:80,align:"center",search:false,sortable:false,editable:false},
			{name:'ePay',index:'ePay', width:80,align:"center",search:false,sortable:false,editable:false},
			{name:'pubcode',index:'pubcode', width:80,align:"center",search:false,sortable:true,editable:false, hidden:true},
			{name:'buyi_sequ_numb',index:'buyi_sequ_numb', width:80,align:"center",search:false,sortable:true,editable:false, hidden:true}
		],
		postData: {
			srcStartYear:$("#srcStartYear").val(),
			srcStartMonth:$("#srcStartMonth").val(),
			srcEndYear:$("#srcEndYear").val(),
			srcEndMonth:$("#srcEndMonth").val(),
			srcBorgName:$("#srcBorgName").val(),
			srcVendorId:$("#srcVendorId").val()
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 425, autowidth: true,
		sortname: 'clos_date', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			FnUpdatePagerIcons(this);
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
					var eBillStr  = "<a href='#'><img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick=\"javaScript:fnEBill('"+rowid+"')\"/></a>";
					var ePayStr   = "<a href='#'><img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick=\"javaScript:fnEPay('"+rowid+"')\"/></a>";
					
					if($.trim(selrowContent.pubcode) != ""){
						jq("#list").jqGrid('setRowData', rowid, {eBill:eBillStr});
					}
					
					jq("#list").jqGrid('setRowData', rowid, {ePay:ePayStr});
				}
			}  		
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcStartYear = $("#srcStartYear").val();
	data.srcStartMonth = $("#srcStartMonth").val();
	data.srcEndYear = $("#srcEndYear").val();
	data.srcEndMonth = $("#srcEndMonth").val();
	data.srcBorgName = $("#srcBorgName").val();
	data.srcVendorId = $("#srcVendorId").val();
	jq("#list").jqGrid("setGridParam", { "postData": data, datatype : "json" });
	jq("#list").trigger("reloadGrid");
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
		
		window.open("http://<%=Constances.EBILL_URL%>/jsp/directTax/TaxViewIndex.jsp?pubCode="+selrowContent.pubcode+"&docType=T&userType=R", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=700px, height=760px");
		
		$("#pubCode").val("");
		taxInvoice.focus();
	} else { jq( "#dialogSelectRow" ).dialog(); }   
}

function fnEPay(rowid){
	
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	var buyiSequNumb= selrowContent.buyi_sequ_numb;
	
	
	
	
	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "VenParticulars"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;

	oReport.param("buyiSequNumb").value = buyiSequNumb;
	
	oReport.title = "거래명세서"; // 제목 세팅
	oReport.open();		
}
</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//공급사 세금계산서 확인
	header = "공급사 세금계산서 확인";
	manualPath = "/img/manual/vendor/ebillVendorList.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</html>