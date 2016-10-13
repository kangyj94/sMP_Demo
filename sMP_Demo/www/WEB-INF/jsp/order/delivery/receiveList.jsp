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
	
	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "";
	//그리드의 width와 Height을 정의
// 	String listHeight = "$(window).height()-273 + Number(gridHeightResizePlus)"+categoryHeightMinus;
	String listHeight = "$(window).height()-360 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
	boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;

	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
	// 날짜 세팅
	String srcOrderStartDate = CommonUtils.getCustomDay("DAY", -7);
	String srcOrderEndDate = CommonUtils.getCurrentDate();
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
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	
	$("#receiveButton").click(function(){ processOrderReceive(); });
	
	$("#srcButton").click(function(){ 
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearch(); 
	});
	$("#allExcelButton").click(function(){ 
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearchReceiveExcelView(); 
	});
	
	// 날짜 세팅
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");
	$("#srcOrderStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcOrderEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
});

//날짜 조회 및 스타일
$(function(){
	$("#srcOrderStartDate").datepicker(
       	{
	   		showOn: "button",
	   		buttonImage: "/img/system/btn_icon_calendar.gif",
	   		buttonImageOnly: true,
	   		dateFormat: "yy-mm-dd"
       	}
	);
	$("#srcOrderEndDate").datepicker(
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
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/selectReceiveList.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'주문일자','납품요청일','출하일자','주문유형', '주문번호','공사명'
		, '출하차수', '배송유형', '송장번호', '고객사', '공급사', '상품명','규격','GOOD_ST_SPEC_DESC', '인수수량', 'disp_good_id',  'good_iden_numb', 'vendorId' , 'deli_type_clas_code', '인수증 출력', 'receipt_num','branchId','is_add', '발주차수'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false, editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter },	//선택
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'deli_degr_date',index:'deli_degr_date', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'orde_type_clas',index:'orde_type_clas', width:60,align:"center",search:false,sortable:true, editable:false ,hidden:true},	//주문유형
			{name:'orde_iden_numb',index:'orde_iden_numb', width:105,align:"center",search:false,sortable:true, editable:false },	//주문번호
			{name:'cons_iden_name',index:'cons_iden_name', width:200,align:"left",search:false,sortable:true, editable:false },	//공사명
			{name:'deli_iden_numb',index:'deli_iden_numb', width:50,align:"center",search:false,sortable:true, editable:false ,hidden:true},	//출하차수
			{name:'deli_type_clas',index:'deli_type_clas', width:90,align:"center",search:false,sortable:true, editable:false },	//배송유형
			{name:'deli_invo_iden',index:'deli_invo_iden', width:80,align:"left",search:false,sortable:true, editable:false },	//송장번호
			{name:'orde_client_name',index:'orde_client_name', width:120,align:"left",search:false,sortable:true, editable:false },	//고객사
			{name:'vendornm',index:'vendornm', width:120,align:"left",search:false,sortable:true, editable:false },	//공급사
			{name:'good_name',index:'good_name', width:180,align:"left",search:false,sortable:true, editable:false },	//상품명
			{name:'good_spec_desc',index:'good_spec_desc', width:180,align:"left",search:false,sortable:true, editable:false },	//규격
			{name:'good_st_spec_desc',index:'good_st_spec_desc', hidden:true, search:false,sortable:true, editable:false },	//규격
			{name:'deli_prod_quan',index:'deli_prod_quan', width:50,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorId',index:'vendorId', hidden:true, search:false,sortable:true, editable:false },
			{name:'deli_type_clas_code',index:'deli_type_clas_code', hidden:true, search:false,sortable:true, editable:false },
			{name:'btn',index:'btn', width:80,align:"center",search:false,sortable:false,align:"left", editable:false,hidden:true },
			{name:'receipt_num',index:'receipt_num',hidden:true},
			{name:'branchId',index:'branchId', hidden:true},
			{name:'is_add',index:'is_add', hidden:true},
			{name:'purc_iden_numb',index:'purc_iden_numb', width:50,align:"center",search:false,sortable:true, editable:false }	//발주차수
		],
		postData: {
// 			srcIsDeliClasExist:$("#srcIsDeliClasExist").val(),
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
			srcVendorId:$("#srcVendorId").val(),
			srcOrderUserId:$("#srcOrderUserId").val(),
			srcOrderStartDate:$('#srcOrderStartDate').val(),
			srcOrderEndDate:$('#srcOrderEndDate').val()
<%	if(isAdm){ 	%>
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
<%	}	%>
		},multiselect: false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200,500], pager: '#pager',
		sortname: 'regi_date_time', sortorder: "desc",
		height: <%=listHeight%>,width:<%=listWidth%>, 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { 
			
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					if(selrowContent.is_add == 'Y'){
						$("#"+rowid).css("background", "#ffeedd");	
					}
				}
			}
			
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.disp_good_id, selrowContent.vendorid);")%> }
<%}else if(isAdm && !spUser){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%} %>
			if(colName != undefined &&colName['index']=="deli_invo_iden") { 
				if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){					
					fnSearchDeliPopup(selrowContent.deli_type_clas_code, selrowContent.deli_invo_iden);
				}
			}
<%if(isAdm){%>
			if(colName != undefined &&colName['index']=="orde_client_name") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchId);")%> 
			}
			if(colName != undefined &&colName['index']=="vendornm") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorId);")%> 
			}
<%}%>
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		afterInsertRow: function(rowid, aData){
<%if(!spUser){%>
			jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
			jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'});  
<%}%>
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){            	
				jq("#list").setCell(rowid,'deli_invo_iden','',{color:'#0000ff'});
				jq("#list").setCell(rowid,'deli_invo_iden','',{cursor: 'pointer'});  
			}
<%if(isAdm){%>
			jq("#list").setCell(rowid,'orde_client_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_client_name','',{cursor: 'pointer'});
			jq("#list").setCell(rowid,'vendornm','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'vendornm','',{cursor: 'pointer'});
<%}%>
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function checkBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
	if($("#chkAllOutputField").is(':checked')) {
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				jq('input:checkbox[name=isCheck_'+rowid+']:not(checked)').attr("checked", true);
			}
		}
	} else {
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
			}
		}
	}
}
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;'/>";
}
/*
 * 리스트 조회
 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1,datatype:"json"});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrdeIdenNumb = $("#srcOrdeIdenNumb").val();
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcVendorId = $("#srcVendorId").val();
	data.srcOrderStartDate = $("#srcOrderStartDate").val();
	data.srcOrderEndDate = $("#srcOrderEndDate").val();
	data.srcOrderUserId = $("#srcOrderUserId").val();
	data.srcWorkInfoUser = $("#srcWorkInfoUser").val();
// 	data.srcIsDeliClasExist= $("#srcIsDeliClasExist").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function fnSearchReceiveExcelView(){
	var colLabels = ['주문일자','납품요청일','출하일자','주문유형', '주문번호','공사명', '발주차수', '출하차수', '배송유형', '송장번호', '고객사', '공급사', '상품명', '규격','인수수량'];
	var colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 'DELI_DEGR_DATE', 'ORDE_TYPE_CLAS', 'ORDE_IDEN_NUMB','CONS_IDEN_NAME', 'PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 'DELI_TYPE_CLAS', 'DELI_INVO_IDEN', 'ORDE_CLIENT_NAME', 'VENDORNM', 'GOOD_NAME', 'GOOD_SPEC_DESC','DELI_PROD_QUAN'];
	var numColIds = ['DELI_PROD_QUAN'];	//숫자표현ID
	var figureColIds = ['PURC_IDEN_NUMB', 'DELI_IDEN_NUMB'];
	var sheetTitle = "인수확인";	//sheet 타이틀
	var excelFileName = "allReceiveList";	//file명
	
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcOrdeIdenNumb';
    fieldSearchParamArray[1] = 'srcGroupId';
    fieldSearchParamArray[2] = 'srcClientId';
    fieldSearchParamArray[3] = 'srcBranchId';
    fieldSearchParamArray[4] = 'srcVendorId';
    fieldSearchParamArray[5] = 'srcOrderStartDate';
    fieldSearchParamArray[6] = 'srcOrderEndDate';
    fieldSearchParamArray[7] = 'srcOrderUserId';
    fieldSearchParamArray[8] = 'srcWorkInfoUser';
//     fieldSearchParamArray[9] = 'srcIsDeliClasExist';
    
    
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/delivery/receiveListExcelView.sys", figureColIds);  
}

function processOrderReceive(){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var deli_iden_numb_array = new Array();
	var deli_prod_quan_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
			    purc_iden_numb_array[arrRowIdx] = selrowContent.purc_iden_numb; 
			    deli_iden_numb_array[arrRowIdx] = selrowContent.deli_iden_numb; 
			    deli_prod_quan_array[arrRowIdx] = selrowContent.deli_prod_quan; 
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
		if(!confirm("선택된 주문 정보를 인수확인하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{ orde_iden_numb_array:orde_iden_numb_array, purc_iden_numb_array:purc_iden_numb_array, deli_iden_numb_array:deli_iden_numb_array, orde_stat_flag:'60' },
			function(arg2){
				if(fnTransResult(arg2, false)) {	//성공시
					$.post(
						"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/orderReceiveProcess.sys",
						{  orde_iden_numb_array:orde_iden_numb_array, purc_iden_numb_array:purc_iden_numb_array
						 , deli_iden_numb_array:deli_iden_numb_array, deli_prod_quan_array:deli_prod_quan_array },
						function(arg){ 
							if(fnAjaxTransResult(arg)) {
								jq("#list").trigger("reloadGrid");
							}
						}
					);
				} else {
					jq("#list").trigger("reloadGrid");
				}
			}
		);
		
// 		$.post(
<%-- 			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/orderReceiveProcess.sys", --%>
// 			{  orde_iden_numb_array:orde_iden_numb_array
// 			 , purc_iden_numb_array:purc_iden_numb_array
// 			 , deli_iden_numb_array:deli_iden_numb_array
// 			 , deli_prod_quan_array:deli_prod_quan_array
// 			}
// 			,function(arg){ 
// 				if(fnAjaxTransResult(arg)) {	
// 					alert("정상적으로 인수확인 처리가 되었습니다.");
// 					jq("#list").trigger("reloadGrid");
// 				}
// 			}
// 		);
	}
}
//택배사 조회
function fnSearchDeliPopup(deli_type_clas_code, deli_invo_iden){
	var deliWebAddr = "";
	var order_deli_type_code = deli_type_clas_code;
	var paramString = "";
	var chkCnt = 0;
    $.post( 
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/delivery/getDeliVendor.sys',
        {deli_type_clas:order_deli_type_code},
        function(arg){
            var codeList= eval('(' + arg + ')').codeList;
            for(var i=0;i<codeList.length;i++) {
            	if(codeList[i].codeVal1 == order_deli_type_code){
            		deliWebAddr = codeList[i].codeVal2;
            		if(order_deli_type_code == "DAESIN"){
            			paramString += "?billno1="+deli_invo_iden.substring(0, 4)+"&billno2="+deli_invo_iden.substring(4, 7)+"&billno3="+deli_invo_iden.substring(7, 13);
            		}else if(order_deli_type_code == "HANIPS"){
            			paramString += "&hawb_no="+deli_invo_iden;
            		}else if(order_deli_type_code == "DHL"){
            			paramString += "&slipno="+deli_invo_iden;
            		}else{
            			paramString = deli_invo_iden;
            		}
            		deliWebAddr += paramString;
                	var scrSizeHeight = 0;
                	scrSizeHeight = screen.height;
                	var windowLeft = (screen.width-900)/2;
                	var windowTop = (screen.height-700)/2;
                	window.open(deliWebAddr,'택배사조회', 'width=900, height=700,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=yes');
                	chkCnt++;
            	}
            }   
            if(chkCnt == 0){
            	alert("일치하는 택배사가 없습니다.");
            }
        }
	);
}
function openReceipt(rowid){
    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	openReceiptPrint(selrowContent.receipt_num,rowid);
}
function openReceiptPrint(receiptNum,i){
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
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "receivePrint"; // reb 파일이름
	oReport.param("receipt_num").value = receiptNum; // 매개변수 세팅
	oReport.param("prodSpec").value 	 	 = prodSpec;
	oReport.param("prodStSpec").value 	 	 = prodStSpec;
	oReport.title = "인수증"; // 제목 세팅
	oReport.open();
}
</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
	//인수확인/송장확인
	header = "인수확인/송장확인";
	manualPath = "/img/manual/branch/receiveList.jpg";
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
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td height="29" class='ptitle'>인수확인
				<%if(isClient){ %>
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
			</table> 
		</td>
	</tr>
	<tr><td height="1"></td></tr>
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
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 100px ; width:90%;" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
					<td class="table_td_subject" width="100">공급업체</td>
					<td class="table_td_contents" >
						<input id="srcVendorName" name="srcVendorName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
						<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
						<a href="#">
							<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
						</a>
					</td>
					<td class="table_td_subject">배송정보입력일</td>
					<td class="table_td_contents">
						<input type="text" name="srcOrderStartDate" id="srcOrderStartDate" style="width: 75px;vertical-align: middle;" /> 
							~ 
						<input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">주문번호</td>
					<td class="table_td_contents" > <input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="20" maxlength="30" /></td>
					<td width="100" class="table_td_subject">주문자</td>
					<td class="table_td_contents">
<%	
	if(_srcBorgScopeByRoleDto != null) {
		List<UserDto> _srcUserList = _srcBorgScopeByRoleDto.getSrcUserList();
%>
						<select id="srcOrderUserId" name="srcOrderUserId" class="select">
<%		if(Integer.parseInt(_srcBorgScopeByRoleDto.getBorgScopeCd()) != 1000) { %>
							<option value="">전체</option>
<%
		}
		for(UserDto userDto:_srcUserList) {
			String _selected = "";
			if(loginUserDto.getUserId().equals(userDto.getUserId())) _selected="selected";
%>
							<option value="<%=userDto.getUserId() %>" <%=_selected %>><%=userDto.getUserNm() %></option>
<%		}%>
						</select>
<%	}else{	%>
						<input id="srcOrderUserName" name="srcOrderUserName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
						<input id="srcOrderUserId" name="srcOrderUserId" type="hidden" value="" size="20" maxlength="30" style="width: 100px" />
						<a href="#">
							<img id="btnUser" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
						</a>
<%	}	%>
					</td>
<%	if(isAdm){ %>
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
<%				} 
			} 
		}%>
						</select>
					</td>
<%	}%>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table> <!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td>
			<table style="width: 100%">
                <tr>
                	<td  align="left">
                		<b>* 배경에 색상이 있는 정보는 추가상품 관련 주문입니다.</b>
                	</td>
                	<td  align="right">
                        <button id='receiveButton' class="btn btn-info btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"> 인수확인 </button>
                	</td>
                </tr>
            </table>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
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
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
</form>
</body>
</html>