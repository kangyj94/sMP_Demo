<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	int EndYear   = 2009;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
		srcYearArr[i] = (StartYear - i) + "";
	}
	
	String managementFlag = (String)request.getParameter("flag1");
	String startDate = (String)request.getParameter("startDate");
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
						<li class="on">세금계산서</li>
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
								<input id="srcClientId" name="srcClientId" type="hidden" value="" size="20" maxlength="30" />
								<input id="srcBranchId" name="srcBranchId" type="hidden" value="" size="20" maxlength="30" />
								<select id="srcStartYear" name="srcStartYear" class="select" style="width: 70px;">
<%	for(int i = 0 ; i < srcYearArr.length ; i++){ 
		if("1".equals(managementFlag)){
%>		
									<option value='<%=srcYearArr[i]%>' <%= startDate.substring(0, 4).equals(srcYearArr[i])? "selected":""%>><%=srcYearArr[i] %></option>
<%		}else{%>	
									<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", -1).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%		}
	}
%>
								</select> 년
								<select id="srcStartMonth" name="srcStartMonth" class="select" style="width: 50px;">
<%	for(int i = 0 ; i < 12 ; i++){ 
		if("1".equals(managementFlag)){
%>
									<option value='<%=i+1%>' <%=Integer.parseInt(startDate.substring(5, 7))==(i+1) ? "selected" : "" %>><%=i+1 %></option>
<%		}else{ %>
									<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", -1).split("-")[1]) == (i+1) ? "selected" : "" %>><%=i+1 %></option>
<%		}
	}
%>
								</select> 월 ~
								<select id="srcEndYear" name="srcEndYear" class="select" style="width: 70px;">
<%	for(int i = 0 ; i < srcYearArr.length ; i++){ 
		if("1".equals(managementFlag)){
%>
									<option value='<%=srcYearArr[i]%>' <%= startDate.substring(0, 4).equals(srcYearArr[i])? "selected":""%>><%=srcYearArr[i] %></option>
<%		}else{ %>
									<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%		}
	}
%>
								</select> 년
								<select id="srcEndMonth" name="srcEndMonth" class="select" style="width: 50px;">
<%	for(int i = 0 ; i < 12 ; i++){ 
		if("1".equals(managementFlag)){
%>
									<option value='<%=i+1%>' <%=Integer.parseInt(startDate.substring(5, 7))==(i+1) ? "selected" : "" %>><%=i+1 %></option>
<%		}else{ %>
									<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == (i+1) ? "selected" : "" %>><%=i+1 %></option>
<%		}
	}
%>
								</select> 월
								
							</td>
						</tr>
					</table>
				
					<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;" >
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						
							<tr>
								<td bgcolor="#FFFFFF">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr><td style="height: 5px;"></td></tr>
										<tr>
											<td align="right" valign="bottom">
												<button id='excelAll' class="btn btn-darkgray btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
													<i class="fa fa-file-excel-o"></i> 엑셀
												</button>
											</td>
										</tr>
										
										<tr><td style="height: 5px;"></td></tr>
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
					</form>	
					<div style="height:10px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>

<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcGroupId = "";
	String _srcClientId = "";
	String _srcBranchId = "";
	String _srcBorgNms = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	
	_srcBorgScopeByRoleDto = userDto.getSrcBorgScopeByRoleDto();
	_srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
	_srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
	_srcBranchId = _srcBorgScopeByRoleDto.getSrcBranchId();
	_srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
	_srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
	
%>
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
	$("#srcBranchId").val("<%=_srcBranchId %>");
	$("#srcBorgName").val("<%=_srcBorgNms.split("\\>")[_srcBorgNms.split("\\>").length-1].trim() %>");

	$("#srcBorgName").attr("disabled", true);

});

</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click( function() { fnSearch(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
});

</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'/buyEbill/ebillBranchListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['발급일자','전표번호','정산명', '거래처명', '사업자등록번호', '공급가액', '세액', '합계','세금<BR/>계산서', '거래<BR/>명세서', 'pubcode', 'sale_sequ_numb', '안전용품<BR/>구매증명서'],
		colModel:[
			{name:'clos_date',index:'clos_date', width:70,align:"center"},//발급일자
			{name:'sap_jour_numb',index:'sap_jour_numb', width:90,align:"center",hidden:true},//전표번호
			{name:'sale_sequ_name',index:'sale_sequ_name', width:220,align:"left"},//정산명
			{name:'borgNm',index:'borgNm', width:220,align:"left"},//거래처명
			{name:'businessNum',index:'businessNum', width:100,align:"center",hidden:true},//사업자등록번호
			{name:'sale_requ_amou',index:'sale_requ_amou', width:90,align:"right", 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//공급가액
			{name:'sale_requ_vtax',index:'sale_requ_vtax', width:80,align:"right",search:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//세액
			{name:'sale_tota_amou',index:'sale_tota_amou', width:90,align:"right",search:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//합계
			{name:'eBill',index:'eBill', width:50,align:"center",search:false,sortable:false,editable:false},//세금계산서
			{name:'ePay',index:'ePay', width:50,align:"center",search:false,sortable:false,editable:false},//거래명세서
			{name:'pubcode',index:'pubcode', width:50,align:"center",search:false,sortable:true,editable:false, hidden:true},
			{name:'sale_sequ_numb',index:'sale_sequ_numb', width:60,align:"center",search:false,sortable:true,editable:false, hidden:true},
			{name:'eSaveCertificate',index:'eSaveCertificate', width:65,align:"center",hidden:false} //안전용품 구매 증명서 
		],
		postData: {
			srcStartYear:$("#srcStartYear").val(),
			srcStartMonth:$("#srcStartMonth").val(),
			srcEndYear:$("#srcEndYear").val(),
			srcEndMonth:$("#srcEndMonth").val(),
			srcBorgName:$("#srcBorgName").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 425,autowidth: true,
		sortname: 'clos_date', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			//FnUpdatePagerIcons(this);
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
					var rowid = $("#list").getDataIDs()[i];
					var eBillStr  = "<a href='#'><img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick=\"javaScript:fnEBill('"+rowid+"')\"/></a>";
					var ePayStr   = "<a href='#'><img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick=\"javaScript:fnEPay('"+rowid+"')\"/></a>";
					var eSaveCertificateStr   = "<a href='#'><img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick=\"javaScript:eSaveCertificate('"+rowid+"')\"/></a>";
					
					if(selrowContent.sale_requ_amou != '0'){
						jq("#list").jqGrid('setRowData', rowid, {eBill:eBillStr});
					}
					
					jq("#list").jqGrid('setRowData', rowid, {ePay:ePayStr});
					jq("#list").jqGrid('setRowData', rowid, {eSaveCertificate:eSaveCertificateStr});
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
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}


function exportExcelToSvc() {
// 	var colLabels = ['발급일자','전표번호','정산명', '거래처명', '사업자등록번호', '공급가액', '세액','합계'];	//출력컬럼명
// 	var colIds = ['clos_date','sap_jour_numb','sale_sequ_name','borgNm','businessNum','sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//출력컬럼ID
	var colLabels = ['발급일자','정산명', '거래처명','공급가액', '세액','합계'];	//출력컬럼명
	var colIds = ['clos_date','sale_sequ_name','borgNm','sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "고객사 세금계산서 확인";	//sheet 타이틀
	var excelFileName = "eBillBranchList";	//file명
	
	var actionUrl = "/buyEbill/ebillBranchListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcStartYear';
	fieldSearchParamArray[1] = 'srcStartMonth';
	fieldSearchParamArray[2] = 'srcEndYear';
	fieldSearchParamArray[3] = 'srcEndMonth';
	fieldSearchParamArray[4] = 'srcBorgName';
	fieldSearchParamArray[5] = 'srcClientId';
	fieldSearchParamArray[6] = 'srcBranchId';
	
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
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

/**
 * 거래명세서 출력 (2013-02-13 by Kave)
 */
function fnEPay(rowid){
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	var saleSequNumb= selrowContent.sale_sequ_numb;
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
/**
 * 안전거래용품 인증서
 */
function eSaveCertificate(rowid){
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	var saleSequNumb= selrowContent.sale_sequ_numb;
	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "BchSaveCertificate"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;
	oReport.param("saleSequNumb").value = saleSequNumb;
	
	oReport.title = "안전거래인증서"; // 제목 세팅
	oReport.open();		
}
</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
</html>