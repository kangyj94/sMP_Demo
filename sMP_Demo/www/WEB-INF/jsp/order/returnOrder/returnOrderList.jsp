<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
	boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
	boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;

	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-35" : loginUserDto.getSvcTypeCd().equals("ADM") ? "-15" :"";
	//그리드의 width와 Height을 정의
// 	String listHeight = "$(window).height()-260 + Number(gridHeightResizePlus)"+categoryHeightMinus;
	String listHeight = "$(window).height()-380 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
	
	// 날짜 세팅
	String srcReturnStartDate = ""; 
	String srcReturnEndDate = CommonUtils.getCurrentDate();
	
	String srcReturnStatFlag = (String)request.getParameter("srcReturnStatFlag") == null ? "" : (String)request.getParameter("srcReturnStatFlag");
	String srcStartDate = (String)request.getParameter("srcStartDate");
	
	if("".equals(srcStartDate) || srcStartDate == null){
		srcReturnStartDate = CommonUtils.getCustomDay("MONTH", -6); 
	}else{
		srcReturnStartDate = CommonUtils.getCustomDay("MONTH", -1); 
	}
    boolean spUser = false;
    List<LoginRoleDto> loginRoleList= (List<LoginRoleDto>)loginUserDto.getLoginRoleList();
    for(LoginRoleDto lrd : loginRoleList){
        if(lrd.getRoleCd().equals("ADM_SPECIAL")){
            spUser = true;
        }
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<%
/**------------------------------------사용자팝업 사용방법---------------------------------
* fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* userNm : 찾고자하는 사용자명
* loginId : 찾고자하는 사용자 Login Id
* svcTypeCd : 찾는사용자의 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영사, "CEN":물륫센타)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(사용자일련번호, 조직일련번호, 서비스유형명, 사용자명, 로그인아이디, 조직명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnUser").click(function(){
		var userNm = $("#srcOrderUserName").val();
		var loginId = "";
		var svcTypeCd = "BUY";
		fnJqmUserInitSearch(userNm, loginId, svcTypeCd, "fnSelectUserCallback");
	});
	$("#srcOrderUserName").keydown(function(e){ if(e.keyCode==13) { $("#btnUser").click(); } });
	$("#srcOrderUserName").change(function(e){
		if($("#srcOrderUserName").val()=="") {
			$("#srcOrderUserId").val("");
		}
	});
});
/**
 * 사용자검색 Callback Function
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#srcOrderUserName").val(userNm);
	$("#srcOrderUserId").val(userId);
}
</script>
<% //------------------------------------------------------------------------------ %>
<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcGroupId = "";
	String _srcClientId = "";
	String _srcBranchId = "";
	String _srcBorgNms = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	if("BUY".equals(loginUserDto.getSvcTypeCd())) {
		_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
		_srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
		_srcBranchId = _srcBorgScopeByRoleDto.getSrcBranchId();
		_srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
		_srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
	}
%>
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
	$("#srcBranchId").val("<%=_srcBranchId %>");
	$("#srcBorgName").val("<%=_srcBorgNms %>");
<%	if("BUY".equals(loginUserDto.getSvcTypeCd()) || "VEN".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcBorgName").attr("disabled", true);
	$("#btnBuyBorg").css("display","none");
<%	}	%>
	
	$("#btnBuyBorg").click(function(){
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
	$("#srcBorgName").keydown(function(e){ if(e.keyCode==13) { $("#btnBuyBorg").click(); } });
	$("#srcBorgName").change(function(e){
		if($("#srcBorgName").val()=="") {
			$("#srcGroupId").val("");
			$("#srcClientId").val("");
			$("#srcBranchId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
// 	alert("groupId : "+groupId+", clientId : "+clientId+", branchId : "+branchId+", borgNm : "+borgNm+", areaType : "+areaType);
	$("#srcGroupId").val(groupId);
	$("#srcClientId").val(clientId);
	$("#srcBranchId").val(branchId);
	$("#srcBorgName").val(borgNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

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
	String _srcVendorName = "";
	String _srcVendorId = "";
	if("VEN".equals(loginUserDto.getSvcTypeCd())) {
		_srcVendorName = loginUserDto.getBorgNm();
		_srcVendorId = loginUserDto.getBorgId();
	}
%>
	$("#srcVendorName").val("<%=_srcVendorName%>");
	$("#srcVendorId").val("<%=_srcVendorId%>");
	$("#btnVendor").click(function(){
		var vendorNm = $("#srcVendorName").val();
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	$("#srcVendorName").keydown(function(e){ if(e.keyCode==13) { $("#btnVendor").click(); } });
	$("#srcVendorName").change(function(e){
		if($("#srcVendorName").val()=="") {
			$("#srcVendorId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#srcVendorId").val(vendorId);
	$("#srcVendorName").val(vendorNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(	//조회조건의 권역세팅
			'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/getCodeList.sys',
			{codeTypeCd:"RETURNSTATUSFLAG", isUse:"1"},
			function(arg){
				var codeList = eval('(' + arg + ')').codeList;
				for(var i=0;i<codeList.length;i++) {
					if (codeList[i].codeVal1 == "<%=srcReturnStatFlag%>"){
						$("#srcReturnStatFlag").append("<option value='"+codeList[i].codeVal1+"' selected>"+codeList[i].codeNm1+"</option>");
					}else{
						$("#srcReturnStatFlag").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
					}
				}
				initList();	//그리드 초기화
			}
		);
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	$("#srcButton").click(function(){ 
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcReturnStartDate").val($.trim($("#srcReturnStartDate").val()));
		$("#srcReturnEndDate").val($.trim($("#srcReturnEndDate").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearch(); 
	});
	$("#allExcelButton").click(function(){ 
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcReturnStartDate").val($.trim($("#srcReturnStartDate").val()));
		$("#srcReturnEndDate").val($.trim($("#srcReturnEndDate").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearchExcelView(); 
	});
	// 날짜 세팅
	$("#srcReturnStartDate").val("<%=srcReturnStartDate%>");
	$("#srcReturnEndDate").val("<%=srcReturnEndDate%>");
	$("#srcReturnStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcReturnEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
});

//날짜 조회 및 스타일
$(function(){
	$("#srcReturnStartDate").datepicker(
       	{
	   		showOn: "button",
	   		buttonImage: "/img/system/btn_icon_calendar.gif",
	   		buttonImageOnly: true,
	   		dateFormat: "yy-mm-dd"
       	}
	);
	$("#srcReturnEndDate").datepicker(
       	{
       		showOn: "button",
       		buttonImage: "/img/system/btn_icon_calendar.gif",
       		buttonImageOnly: true,
       		dateFormat: "yy-mm-dd"
       	}
	);
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(1500);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/returnOrderListJQGrid.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:['반품번호','주문유형','주문번호','발주차수','출하차수','고객사','공급사','반품처리상태','상품명','단가','반품요청수량','반품요청금액','인수수량', 'disp_good_id', 'good_iden_numb', 'vendorid', '반품인수인계증','branchid'],
		colModel:[
			{name:'retu_iden_num',index:'retu_iden_num', width:50,align:"center",search:false,sortable:true, 
				editable:false 
			},	//반품번호
			{name:'orde_type_clas',index:'orde_type_clas', width:50,align:"center",search:false,sortable:true, hidden:true,
				editable:false
			},	//주문유형
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"center",search:false,sortable:true, 
				editable:false
			},	//주문번호
			{name:'purc_iden_numb',index:'purc_iden_numb', width:50,align:"center",search:false,sortable:true,
				editable:false
			},	//발주차수
			{name:'deli_iden_numb',index:'deli_iden_numb', width:50,align:"center",search:false,sortable:true, hidden:true,
				editable:false 
			},	//출하차수
			{name:'orde_client_name',index:'orde_client_name', width:180,align:"left",search:false,sortable:true,
				editable:false 
			},	//고객사
			{name:'vendornm',index:'vendornm', width:190,align:"left",search:false,sortable:true,
				editable:false 
			},	//공급사
			{name:'retu_stat_flag',index:'retu_stat_flag', width:78,align:"center",search:false,sortable:true,
				editable:false 
			},	//반품처리상태
			{name:'good_name',index:'good_name', width:280,align:"left",search:false,sortable:true,
				editable:false 
			},	//상품명
			{name:'orde_requ_pric',index:'orde_requ_pric', width:70,align:"right",search:false,sortable:false,
				editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},	//단가
			{name:'retu_prod_quan',index:'retu_prod_quan', width:70,align:"right",search:false,sortable:false, 
				editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//반품요청수량
			{name:'retu_requ_pric',index:'retu_requ_pric', width:80,align:"right",search:false,sortable:false, 
				editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//반품요청금액
			{name:'rece_prod_quan',index:'rece_prod_quan', width:70,align:"right",search:false,sortable:false, 
				editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorid',index:'vendorid', hidden:true, search:false,sortable:true, editable:false },
			{name:'btn',index:'btn', width:95,align:"center",search:false,sortable:false, editable:false },	//내역확인
			{name:'branchid',index:'branchid', hidden:true}
		],
		postData: {
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
			srcVendorId:$("#srcVendorId").val(),
			srcReturnStartDate:$('#srcReturnStartDate').val(),
			srcReturnEndDate:$('#srcReturnEndDate').val(),
			srcOrderUserId:$("#srcOrderUserId").val(),
			srcReturnStatFlag:$('#srcReturnStatFlag').val()
<%	if(isAdm){ 	%>
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
<%	}	%>
		},multiselect: false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>, width:$(window).width()-50 + Number(gridWidthResizePlus),
		sortname: 'retu_iden_num', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					if(selrowContent.retu_stat_flag == '승인'){
						var inputBtn = "";
						inputBtn += "<button id='srcButton' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' onclick=\"fnReturnReceiptPrint('"+rowid+"');\">";
						inputBtn += "반품인수인계증";
						inputBtn += "</button>";
						jQuery('#list').jqGrid('setRowData',rowid,{btn:inputBtn});
					}
				}
			}
		},
		afterInsertRow: function(rowid, aData){
<%if(!spUser){%>
			jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
			jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'});  
<%}%>
			jq("#list").setCell(rowid,'retu_iden_num','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'retu_iden_num','',{cursor: 'pointer'});
<%	if(isAdm){ 	%>
			jq("#list").setCell(rowid,'orde_client_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_client_name','',{cursor: 'pointer'});
			jq("#list").setCell(rowid,'vendornm','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'vendornm','',{cursor: 'pointer'});
<%}%>
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
<%if(!spUser){%>
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
<%}%>
			if(colName != undefined &&colName['index']=="retu_iden_num") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderRetrunDetailView(cellcontent);")%> }
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isAdm && !spUser){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%} %>
<%if(isAdm){%>
			//구매사 상세 팝업
			if(colName != undefined &&colName['index']=="orde_client_name") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchid);")%>
			}
			//공급사 상세 팝업
			if(colName != undefined &&colName['index']=="vendornm") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorid);")%>
			}
<%}%>
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	jQuery("#list").jqGrid('setGridWidth', 1500);
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/*
 * 리스트 조회
 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1 , datatype :"json"});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrdeIdenNumb = $("#srcOrdeIdenNumb").val();
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcVendorId = $("#srcVendorId").val();
	data.srcReturnStartDate = $("#srcReturnStartDate").val();
	data.srcReturnEndDate = $("#srcReturnEndDate").val();
	data.srcReturnStatFlag = $("#srcReturnStatFlag").val();
	data.srcOrderUserId = $("#srcOrderUserId").val();
	data.srcWorkInfoUser = $("#srcWorkInfoUser").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function exportExcel() {
	var colLabels = ['반품번호','주문유형','주문번호','발주차수','출하차수','고객사','공급사','반품처리상태','상품명','단가','반품요청수량','반품요청금액','인수수량'];
	var colIds =['retu_iden_num', 'orde_type_clas', 'orde_iden_numb', 'purc_iden_numb', 'deli_iden_numb', 'orde_client_name', 'vendornm', 'retu_stat_flag', 'good_name', 'orde_requ_pric', 'retu_prod_quan', 'retu_requ_pric', 'rece_prod_quan'];
	var numColIds = ['orde_requ_pric', 'retu_prod_quan', 'retu_requ_pric', 'rece_prod_quan'];
	var figureColIds = ['retu_iden_num', 'purc_iden_numb', 'deli_iden_numb'];
	var sheetTitle = "반품이력";	//sheet 타이틀
	var excelFileName = "returnOrderList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function fnSearchExcelView(){
	var colLabels = ['반품번호','주문유형','주문번호','발주차수','출하차수','고객사','공급사','반품처리상태','상품명','단가','반품요청수량','반품요청금액','인수수량'];
	var colIds =['RETU_IDEN_NUM', 'ORDE_TYPE_CLAS', 'ORDE_IDEN_NUMB', 'PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 'ORDE_CLIENT_NAME', 'VENDORNM', 'RETU_STAT_FLAG', 'GOOD_NAME', 'ORDE_REQU_PRIC', 'RETU_PROD_QUAN', 'RETU_REQU_PRIC', 'RECE_PROD_QUAN'];
	var numColIds = ['ORDE_REQU_PRIC', 'RETU_PROD_QUAN', 'RETU_REQU_PRIC', 'RECE_PROD_QUAN'];
	var figureColIds = ['RETU_IDEN_NUM', 'PURC_IDEN_NUMB', 'DELI_IDEN_NUMB'];
	var sheetTitle = "반품이력";	//sheet 타이틀
	var excelFileName = "returnOrderList";	//file명
	
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcOrdeIdenNumb';
	fieldSearchParamArray[1] = 'srcGroupId';
	fieldSearchParamArray[2] = 'srcClientId';
	fieldSearchParamArray[3] = 'srcBranchId';
	fieldSearchParamArray[4] = 'srcVendorId';
	fieldSearchParamArray[5] = 'srcReturnStartDate';
	fieldSearchParamArray[6] = 'srcReturnEndDate';
	fieldSearchParamArray[7] = 'srcReturnStatFlag';
	fieldSearchParamArray[8] = 'srcOrderUserId';
	fieldSearchParamArray[9] = 'srcWorkInfoUser';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/returnOrder/returnOrderListExcelView.sys", figureColIds);  
}

function fnOrderRetrunDetailView(id) {
	if( id != null && id != ""){
		var popurl = "/order/returnOrder/returnOrderRegistDetail.sys?retu_iden_num=" + id;
		var popproperty = "dialogWidth:900px;dialogHeight=300px;scroll=no;status=no;resizable=no;";
// 		window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=900, height=300, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function fnReturnReceiptPrint(rowid){
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	var retu_iden_num = selrowContent.retu_iden_num;
	fnOpen(retu_iden_num,rowid);
}
</script>
<%-- 인수증 출력 관련 스크립트 시작 --%>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script language="JavaScript">
function fnOpen(retu_iden_num, i) {
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "returnReceivePrint"; // reb 파일이름

	oReport.param("retu_iden_num").value = retu_iden_num; // 매개변수 세팅
	
	oReport.title = "반품인수인계증"; // 제목 세팅
	oReport.open();
}
</script>
<%-- 인수증 출력 관련 스크립트 끝 --%>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
	//반품이력
	header = "반품이력";
	manualPath = "/img/manual/branch/returnOrderList.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<form id="frm" name="frm" onsubmit="return false;">
	<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
						</td>
						<td height="29" class='ptitle'>반품이력
						<% if(isClient){ %>
							&nbsp;<span id="question" class="questionButton">도움말</span>
						<%} %>
						</td>
						<td align="right" class='ptitle'>
							<button id='allExcelButton' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 엑셀</button>
							<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
								<i class="fa fa-search"></i> 조회
							</button>
						</td>
					</tr>
				</table> <!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td height="1"></td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td width="100" class="table_td_subject" style="width: 100px">고객사</td>
						<td class="table_td_contents" style="width: 400px">
							<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 350px" />
							<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
							<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
							<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
							<a href="#">
								<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
							</a>
						</td>
						<td class="table_td_subject" width="100">공급업체</td>
						<td class="table_td_contents">
							<input id="srcVendorName" name="srcVendorName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
							<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
							<a href="#">
								<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
							</a>
						</td>
						<td width="100" class="table_td_subject" style="width: 100px">주문번호</td>
						<td class="table_td_contents" style="width: 350px">
							<input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="20" maxlength="30" />
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td width="100" class="table_td_subject">반품요청일</td>
						<td class="table_td_contents">
							<input type="text" name="srcReturnStartDate" id="srcReturnStartDate" style="width: 75px;vertical-align: middle;" /> 
								~ 
							<input type="text" name="srcReturnEndDate" id="srcReturnEndDate" style="width: 75px;vertical-align: middle;" />
						</td>
						<td width="100" class="table_td_subject">반품처리상태</td>
						<td class="table_td_contents">
							<select id="srcReturnStatFlag" name="srcReturnStatFlag" class="select" >
								<option value="">전체</option>
							</select>
						</td>
						<td width="100" class="table_td_subject">주문자</td>
						<td class="table_td_contents">
<%	
	if(_srcBorgScopeByRoleDto != null) {
		List<UserDto> _srcUserList = _srcBorgScopeByRoleDto.getSrcUserList();
%>
							<select id="srcOrderUserId" name="srcOrderUserId">
<%		if(Integer.parseInt(_srcBorgScopeByRoleDto.getBorgScopeCd()) != 1000) { %>
								<option value="">전체</option>
<%
		}
		for(UserDto userDto:_srcUserList) {
			String _selected = "";
			if(loginUserDto.getUserId().equals(userDto.getUserId())) _selected="selected";
%>
								<option value="<%=userDto.getUserId() %>" <%=_selected %>><%=userDto.getUserNm() %></option>
<%		} %>
							</select>
<%	} else {	%>
							<input id="srcOrderUserName" name="srcOrderUserName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
							<input id="srcOrderUserId" name="srcOrderUserId" type="hidden" value="" size="20" maxlength="30" style="width: 100px" />
							<a href="#">
								<img id="btnUser" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
							</a>
<%	}	%>
						</td>
					</tr>
<%if(isAdm){ %>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">담당자</td>
						<td class="table_td_contents" colspan="5">
							<select id="srcWorkInfoUser" name="srcWorkInfoUser" class="select">
								<option value="">전체</option>
<% 	
if(isAdm && workInfoList != null){
	if (workInfoList.size() > 0 ) {
		SmpUsersDto sud = null;
		for (int i = 0; i < workInfoList.size(); i++) {
			sud = workInfoList.get(i); 
			String _selected = "";
			if(loginUserDto.getUserId().equals(sud.getUserId())) _selected="selected";
%>
								<option value="<%=sud.getUserId()%>" <%=_selected %>><%=sud.getUserNm()%></option>
<% } } } %>
							</select>
						</td>
					</tr>
<%}%>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table> <!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr><td height="10"></td></tr>
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
</form>
</body>
</html>