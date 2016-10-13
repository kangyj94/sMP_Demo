<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "";

	//그리드의 width와 Height을 정의
// 	String listHeight = "$(window).height()-220 + Number(gridHeightResizePlus)" + categoryHeightMinus;
	String listHeight = "$(window).height()-342 + Number(gridHeightResizePlus)";
// 	String listWidth  = "$(window).width()-52 + Number(gridWidthResizePlus)";
	String listWidth  = "1498";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	int EndYear   = 2003;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
		srcYearArr[i] = (StartYear - i) + "";
	}
	boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<!-- 공급사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcVendorId = "";
	String _srcBorgName = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	if("VEN".equals(loginUserDto.getSvcTypeCd())) {
		_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcVendorId = _srcBorgScopeByRoleDto.getSrcBranchId();
		_srcBorgName = _srcBorgScopeByRoleDto.getSrcBorgNms();
	}
%>
	$("#srcBorgName").val("<%=_srcBorgName %>");
	$("#srcVendorId").val("<%=_srcVendorId %>");
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcBorgName").attr("disabled", true);
	$("#btnBuyBorg").css("display","none");
<%	}	%>
	
	$("#btnBuyBorg").click(function(){
		var vendorNm = $("#srcBorgName").val();
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	$("#srcBorgName").keydown(function(e){ if(e.keyCode==13) { $("#btnBuyBorg").click(); } });
	$("#srcBorgName").change(function(e){
		if($("#srcBorgName").val()=="") {
			$("#srcVendorId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#srcBorgName").val(vendorNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click( function() { fnSearch(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight%>);
	$("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/ebill/ebillVendorListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['발급일자','전표번호', '거래처명', '사업자등록번호', '공급가액', '세액', '세금계산서', '거래명세서', 'pubcode', 'buyi_sequ_numb'],
		colModel:[
			{name:'clos_date',index:'clos_date', width:70,align:"center",search:false,sortable:true,editable:false },
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
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width: <%=listWidth%>,
		sortname: 'clos_date', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
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
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['발급일자','전표번호', '거래처명', '사업자등록번호', '공급가액', '세액'];	//출력컬럼명
	var colIds = ['clos_date','sap_jour_numb','borgNm','businessNum','buyi_requ_amou','buyi_requ_vtax'];	//출력컬럼ID
	var numColIds = ['buyi_requ_amou','buyi_requ_vtax'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "공급사 세금계산서 확인";	//sheet 타이틀
	var excelFileName = "eBillVendorList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['발급일자', '전표번호','거래처명', '사업자등록번호', '공급가액', '세액'];	//출력컬럼명
	var colIds = ['clos_date','sap_jour_numb','borgNm','businessNum','buyi_requ_amou','buyi_requ_vtax'];	//출력컬럼ID
	var numColIds = ['buyi_requ_amou','buyi_requ_vtax'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "공급사 세금계산서 확인";	//sheet 타이틀
	var excelFileName = "allEBillVendorList";	//file명
	
	var actionUrl = "/ebill/ebillVendorListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcStartYear';
	fieldSearchParamArray[1] = 'srcStartMonth';
	fieldSearchParamArray[2] = 'srcEndYear';
	fieldSearchParamArray[3] = 'srcEndMonth';
	fieldSearchParamArray[4] = 'srcBorgName';
	fieldSearchParamArray[5] = 'srcVendorId';
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

function fnEPay(rowid){
	
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	var buyiSequNumb= selrowContent.buyi_sequ_numb;
	
	<%
		String prodSpec = "";
		for(int i = 0 ; i < Constances.PROD_GOOD_SPEC.length ; i++){
			if(i == 0) 	prodSpec = Constances.PROD_GOOD_SPEC[i];
			else		prodSpec += "‡" + Constances.PROD_GOOD_SPEC[i];
		}
        
        String prodStSpec = "";
        for(int i = 0 ; i < Constances.PROD_GOOD_ST_SPEC.length ; i++){
            if(i == 0)  prodStSpec = Constances.PROD_GOOD_ST_SPEC[i];
            else        prodStSpec += "‡" + Constances.PROD_GOOD_ST_SPEC[i];
        }                
	%>
	
	var prodSpec	= '<%=prodSpec%>';
	var prodStSpec	= '<%=prodStSpec%>';
	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "VenParticulars"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;

	oReport.param("buyiSequNumb").value = buyiSequNumb;
	oReport.param("prodSpec").value 	= prodSpec;
	oReport.param("prodStSpec").value 	 	 = prodStSpec;
	
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
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
	<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>공급사 세금계산서 확인
						<%if(isVendor){ %>
							&nbsp;<span id="question" class="questionButton">도움말</span>
						<%} %>
						</td>
						<td align="right" class='ptitle'>
							<button id='excelAll' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
								<i class="fa fa-file-excel-o"></i> 엑셀
							</button>
							<button id="srcButton" name="srcButton" class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
								<i class="fa fa-search"></i> 조회
							</button>
						</td>
					</tr>
				</table> 
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr><td height="1"></td></tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="8" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">공급사</td>
						<td class="table_td_contents">
							<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 300px" />
							<input id="srcVendorId" name="srcVendorId" type="hidden" value="" size="20" maxlength="30" style="width: 300px" />
							<a href="#">
								<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
							</a>
						</td>
                     	<td class="table_td_subject" width="100">발급년월</td>
                     	<td colspan="5" class="table_td_contents">
                        	<select id="srcStartYear" name="srcStartYear" class="select" style="width: 60px;">
<% for(int i = 0 ; i < srcYearArr.length ; i++){ %>
                           		<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", -1).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<% } %>                        
                        	</select> 년
                        
                        	<select id="srcStartMonth" name="srcStartMonth" class="select" style="width: 50px;">
<% for(int i = 0 ; i < 12 ; i++){ %>
                           		<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", -1).split("-")[1]) == (i+1) ? "selected" : "" %>><%=i+1 %></option>
<% } %>                        
                        	</select> 월 ~
                        
                        	<select id="srcEndYear" name="srcEndYear" class="select" style="width: 60px;">
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
					<tr>
						<td colspan="8" class="table_top_line"></td>
					</tr>
				</table> <!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr>
			<td height="5"></td>
		</tr>
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list"></table>
					<div id="pager"></div>
				</div>
			</td>
		</tr>
	</table>
	<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
		<p>처리할 데이터를 선택 하십시오!</p>
	</div>
</body>
</html>