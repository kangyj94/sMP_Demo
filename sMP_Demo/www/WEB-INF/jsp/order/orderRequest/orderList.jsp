<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%
	String _menuId = CommonUtils.getRequestMenuId(request);
	String clientOrderStatus = request.getParameter("srcOrderStatusFlag") == null ? "" : request.getParameter("srcOrderStatusFlag");
	
	LoginUserDto loginUserDto = CommonUtils.getLoginUserDto(request);
	boolean isDiv = (Boolean)request.getAttribute("isDiv") == null ? false : true;
	boolean orderCancel = request.getAttribute("orderCancel") == null ? false : true;
	boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
	boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
	boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	
	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : loginUserDto.getSvcTypeCd().equals("ADM") ? "-25" :"";
	//그리드의 width와 Height을 정의
// 	String listHeight = "$(window).height()-275 + Number(gridHeightResizePlus)"+categoryHeightMinus;
	String listHeight = "$(window).height()-430 + Number(gridHeightResizePlus)";
	String listWidth = "1500";
	
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<CodesDto> codeList = (List<CodesDto>)request.getAttribute("codeList");
	
	@SuppressWarnings("unchecked")
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
	
	@SuppressWarnings("unchecked")//상품담당자
	List<SmpUsersDto> productManagerList = (List<SmpUsersDto>)request.getAttribute("productManagerList");
	
	if(!isDiv && !orderCancel){
		for(CodesDto cd : codeList){
			if(clientOrderStatus.equals(cd.getCodeVal1())){
				clientOrderStatus = cd.getCodeNm1();
			}
		}
	}
	// 날짜 세팅 
	String srcOrderStartDate = CommonUtils.getCustomDay("DAY", -3);
	if(!clientOrderStatus.equals("")){
		srcOrderStartDate = CommonUtils.getCustomDay("MONTH", -1); 
	}
	String srcOrderEndDate = CommonUtils.getCurrentDate();
	
	boolean spUser = false;
	boolean isBuilder = false;
	List<LoginRoleDto> loginRoleList= (List<LoginRoleDto>)loginUserDto.getLoginRoleList();
	for(LoginRoleDto lrd : loginRoleList){
		if(lrd.getRoleCd().equals("ADM_SPECIAL")){
			spUser = true;
		}
		if("BUY_BUILDER".equals(lrd.getRoleCd())){
			isBuilder = true;
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<style type="text/css">
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
.ui-jqgrid tr.jqgrow td {
	font-weight: normal; 
	overflow: hidden; 
	white-space: nowrap; 
/* 	height:50px;  */
	padding: 0 2px 0 2px;
	border-bottom-width: 1px; 
  	border-bottom-color: inherit;
 	border-bottom-style: solid;
}
</style>

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
<%  if("BUY".equals(loginUserDto.getSvcTypeCd()) || "VEN".equals(loginUserDto.getSvcTypeCd())) {    %>
    $("#srcBorgName").attr("disabled", true);
    $("#btnBuyBorg").css("display","none");
<%  }   %>
    
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
    
  //선입금여부 최초페이지 로딩시 '아니오'로 나오게 처리
	$('#prepay').val("0");
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
//  alert("groupId : "+groupId+", clientId : "+clientId+", branchId : "+branchId+", borgNm : "+borgNm+", areaType : "+areaType);
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

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcOrderNumber").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcGoodsName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcGoodsId").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	
	$("#srcButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcGoodsId").val($.trim($("#srcGoodsId").val()));
		$("#srcGoodsName").val($.trim($("#srcGoodsName").val()));
		$("#srcOrderStatusFlag").val($.trim($("#srcOrderStatusFlag").val()));
		$("#srcOrderUserId").val($.trim($("#srcOrderUserId").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearch(); 
	});
	$("#allExcelButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcGoodsId").val($.trim($("#srcGoodsId").val()));
		$("#srcGoodsName").val($.trim($("#srcGoodsName").val()));
		$("#srcOrderStatusFlag").val($.trim($("#srcOrderStatusFlag").val()));
		$("#srcOrderUserId").val($.trim($("#srcOrderUserId").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnAllExcelPrintDown();
	});
	
	// 날짜 세팅
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");
	
	$("#srcOrderStartDate").change(function(){ 
		startDateCompare();
	});
	$("#srcOrderEndDate").change(function(){ 
		endDateCompare();
	});
});

// 날짜 조회 및 스타일
$(function(){
	$("#srcOrderStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcOrderEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderListIncludeTotalSumJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			'주문일자',				'납품요청일',			'납품예정일',			'고객유형',				'주문번호',
			'공사명',				'주문<br/>유형',		'주문상태',			'구매사',				'주문자',
			'공급사',				'공급사 전화번호',	'상품명',			'규격',					'판매단가',
			'수량',					'판매금액',			'매입단가',			'매입금액',				'긴급여부',
			'disp_good_id',			'vendorid',			'good_iden_numb',	'good_st_spec_desc',	'sum_total_sale_unit_pric',
			'sum_orde_requ_quan',	'branchId',			'is_add_good'
		],
		colModel:[
			{name:'regi_date_time',           index:'regi_date_time',           width:70,  align:"center",  search:false, sortable:true, editable:false, sorttype:"date", editable:false,formatter:"date"},//주문일자
			{name:'requ_deli_date',           index:'requ_deli_date',           width:70,  align:"center",  search:false, sortable:true, editable:false, sorttype:"date", editable:false,formatter:"date"},//납품요청일
			{name:'deli_sche_date',           index:'deli_sche_date',           width:70,  align:"center",  search:false, sortable:true, editable:false},//납품예정일
			{name:'worknm',                   index:'worknm',                   width:100, align:"left",    search:false, sortable:true, editable:false},//고객유형
			{name:'orde_iden_numb',           index:'orde_iden_numb',           width:120, align:"center",  search:false, sortable:true, editable:false, key:true},//주문번호
			
			{name:'cons_iden_name',           index:'cons_iden_name',           width:120, align:"left",    search:false, sortable:true, editable:false },//공사명
			{name:'orde_type_clas',           index:'orde_type_clas',           width:30,  align:"center",  search:false, sortable:true, editable:false ,hidden:true},//주문유형
			{name:'order_status_flag',        index:'order_status_flag',        width:90,  align:"center",  search:false, sortable:true, editable:false },//주문상태
			{name:'orde_client_name',         index:'orde_client_name',         width:120, align:"left",    search:false, sortable:true, editable:false },//구매사
			{name:'orde_user_name',           index:'orde_user_name',           width:60,  align:"centere", search:false, sortable:true, editable:false},//주문자
			
			{name:'vendor_name',              index:'vendor_name',              width:120, align:"left",    search:false, sortable:true, editable:false},//공급사
			{name:'phonenum',                 index:'phonenum',                 width:90,  align:"center",  search:false, sortable:true, editable:false},//공급사 전화번호
			{name:'good_iden_name',           index:'good_iden_name',           width:140, align:"left",    search:false, sortable:true, editable:false },//상품명
			{name:'good_spec_desc',           index:'good_spec_desc',           width:140, align:"left",    search:false, sortable:true, editable:false },//상품규격
			{name:'sell_price',               index:'sell_price',               width:70,  align:"right",   search:false, sortable:true, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매단가
			
			{name:'orde_requ_quan',           index:'orde_requ_quan',           width:40,  align:"right",   search:false, sortable:true, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수량
			{name:'total_sell_price',         index:'total_sell_price',         width:80,  align:"right",   search:false, sortable:true, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매금액
			{name:'sale_unit_pric',           index:'sale_unit_pric',           width:80,  align:"right",   search:false, sortable:true, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입단가
			{name:'total_sale_price',         index:'total_sale_price',         width:80,  align:"right",   search:false, sortable:true, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입금액
			{name:'emer_orde_clas',           index:'emer_orde_clas',           hidden:true},
			
			{name:'disp_good_id',             index:'disp_good_id',             hidden:true},
			{name:'vendorid',                 index:'vendorid',                 hidden:true},//공급사ID
			{name:'good_iden_numb',           index:'good_iden_numb',           hidden:true},
			{name:'good_st_spec_desc',        index:'good_st_spec_desc',        hidden:true},//표준규격
			{name:'sum_total_sale_unit_pric', index:'sum_total_sale_unit_pric', hidden:true},
			
			{name:'sum_orde_requ_quan',       index:'sum_orde_requ_quan',       hidden:true},
			{name:'branchId',                 index:'branchId',                 hidden:true},//사업장ID
			{name:'is_add_good',              index:'is_add_good',              hidden:true}//is_add_good
		],
		postData: {
			srcGroupId:$("#srcGroupId").val()
			,srcClientId:$("#srcClientId").val()
			,srcBranchId:$("#srcBranchId").val()
			,srcOrderUserId:$("#srcOrderUserId").val()
			,srcOrderStartDate:$('#srcOrderStartDate').val()
			,srcOrderEndDate:$('#srcOrderEndDate').val()
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
			,prepay:$('#prepay').val()
			,srcProductManagerUser:$('#srcProductManagerUser').val()
<%  if(isDiv){  %>
			,srcOrderStatusFlag:"주문요청"
<%  }else if(orderCancel){  %>
			,srcOrderStatusFlag:"주문취소"
<%  }else if(!clientOrderStatus.equals("")){    %>
			,srcOrderStatusFlag:"<%=clientOrderStatus%>"
<%  }   %>
		},
		rowNum:30, rownumbers: true, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'regi_date_time', sortorder: "desc",
		loadui: 'disable',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, 
		loadComplete: function() {

			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt==0){
				var tempPric = "";
				$("#total_sum_pric").html(tempPric);
			}
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(idx == 0){
					var total_record = fnComma(Number(jq("#list").getGridParam('records')));
					var tempPric = fnComma(Number(selrowContent.sum_total_sale_unit_pric));
					var tempPric2 = fnComma(Number(selrowContent.sum_orde_requ_quan));
					tempPric = "<b>총 "+total_record+" 건의 주문 총수량 : " + tempPric2 + " , 금액 합계 : "+ tempPric+" 원 </b>";
					$("#total_sum_pric").html(tempPric);
				}

				//선입금여부 로우데이터 변환
				var prepay = selrowContent.prepay;
				var prepayNm = "";
				if(prepay=="1"){
					prepayNm = "예";
				}else{
					prepayNm = "아니오";
				}
				jQuery('#list').jqGrid('setRowData',rowid,{prepay:prepayNm});
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow: function(rowid, aData){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});
			jq("#list").setCell(rowid,'vendor_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'vendor_name','',{cursor: 'pointer'});
			jq("#list").setCell(rowid,'orde_client_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_client_name','',{cursor: 'pointer'});
			jq("#list").setCell(rowid,'good_iden_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_iden_name','',{cursor: 'pointer'});
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {phonenum: fnSetTelformat(selrowContent.phonenum)});
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="orde_iden_numb") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> 
			}
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="good_iden_name") {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%>
			}
			//사업장 상세 팝업 호출
			if(colName != undefined &&colName['index']=="orde_client_name") {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchId);")%>
			}
			//공급사 상세 팝업 호출
			if(colName != undefined &&colName['index']=="vendor_name") {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorid);")%>
			}
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/*
 * 리스트 조회
 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrderNumber = $("#srcOrderNumber").val();
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcVendorId = $("#srcVendorId").val();
	data.srcGoodsName = $("#srcGoodsName").val();
	data.srcGoodsId = $("#srcGoodsId").val();
	data.srcOrderStatusFlag = $("#srcOrderStatusFlag").val();
	data.srcOrderUserId = $("#srcOrderUserId").val();
	data.srcOrderStartDate = $("#srcOrderStartDate").val();
	data.srcOrderEndDate = $("#srcOrderEndDate").val();
	data.srcWorkInfoUser = $("#srcWorkInfoUser").val();
	data.srcProductManagerUser = $("#srcProductManagerUser").val();
	data.prepay = $("#prepay").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

// 상태 변경시 자동 조회
function changeOrderStatusFlag(){
    $("#srcButton").click();
}

/**
 * 장바구니 페이지로 이동 
 */
function fnGoCartPage() {
    // 비어있는 함수
    $('#frm').attr('action','/order/cart/cartMstInfo.sys');
    $('#frm').attr('Target','_self');
    $('#frm').attr('method','post');
    $('#frm').submit();
}
/**
 *  주문조회 페이지로 이동한다. 
 */
function fnGoOrderList() {
    $('#frm').attr('action','/order/orderRequest/orderList.sys');
    $('#frm').attr('Target','_self');
    $('#frm').attr('method','post');
    $('#frm').submit();
}

/** 일괄 엑셀 다운로드 function*/
function fnAllExcelPrintDown(){
	var colLabels = ['주문일자','납품요청일','고객유형','주문번호','공사명', '주문유형','선입금여부',  '주문상태', '구매사','주문자', '공급사', '공급사 전화번호', '상품 담당자', '상품명', '규격','판매단가', '수량', '판매금액', '매입단가', '매입금액',  '긴급여부'];
	var colIds =['REGI_DATE_TIME','REQU_DELI_DATE','WORKNM','ORDE_IDEN_NUMB','CONS_IDEN_NAME','ORDE_TYPE_CLAS','PREPAYNM','ORDER_STATUS_FLAG','ORDE_CLIENT_NAME','ORDE_USER_NAME','VENDOR_NAME','PHONENUM' ,'PRODUCT_MANAGER', 'GOOD_IDEN_NAME' ,'GOOD_SPEC_DESC' ,'SELL_PRICE' ,'ORDE_REQU_QUAN' ,'TOTAL_SELL_PRICE', 'SALE_UNIT_PRIC' ,'TOTAL_SALE_PRICE', 'EMER_ORDE_CLAS']; 
	var numColIds = ['SELL_PRICE','ORDE_REQU_QUAN','TOTAL_SELL_PRICE','SALE_UNIT_PRIC','TOTAL_SALE_PRICE'];  //숫자표현ID
	var sheetTitle = "주문조회";    //sheet 타이틀
	var excelFileName = "OrderList";    //file명
	
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcOrderNumber';
	fieldSearchParamArray[1] = 'srcGroupId';
	fieldSearchParamArray[2] = 'srcClientId';
	fieldSearchParamArray[3] = 'srcBranchId';
	fieldSearchParamArray[4] = 'srcVendorId';
	fieldSearchParamArray[5] = 'srcGoodsName';
	fieldSearchParamArray[6] = 'srcGoodsId';
	fieldSearchParamArray[7] = 'srcOrderStatusFlag';
	fieldSearchParamArray[8] = 'srcOrderUserId';
	fieldSearchParamArray[9] = 'srcOrderStartDate';
	fieldSearchParamArray[10] = 'srcOrderEndDate';
	fieldSearchParamArray[11] = 'srcWorkInfoUser';
	fieldSearchParamArray[12] = 'prepay';
	fieldSearchParamArray[13] = 'srcProductManagerUser';
	
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/orderRequest/orderListExcel.sys");  
}

// 3자리수마다 콤마
function fnComma(n) {
	 n += '';
	 var reg = /(^[+-]?\d+)(\d{3})/;
	 while (reg.test(n)){
		 n = n.replace(reg, '$1' + ',' + '$2');
	 }
	 return n;
}

//날짜비교
function startDateCompare(){
	var orderStartDate = new Date($("#srcOrderStartDate").val());
	var orderEndDate = new Date($("#srcOrderEndDate").val());
	var endDate = orderEndDate.getDate();
	orderEndDate.setDate(endDate -365);
	var year = orderEndDate.getFullYear();
	var month = orderEndDate.getMonth()+1;
	var day = orderEndDate.getDate();
	if(month < 10){
		month = "0"+month;
	}
	if(day < 10){
		day = "0"+day;
	}
	var getDate = year+"-"+month+"-"+day;
	if(orderStartDate < orderEndDate){
		alert("날짜 범위가 1년을 넘을수 없습니다.");
		$("#srcOrderStartDate").val(getDate);
		return;
	}
}



//날짜비교
function endDateCompare(){
	var orderStartDate = new Date($("#srcOrderStartDate").val());
	var orderEndDate = new Date($("#srcOrderEndDate").val());
	
	var endDate = orderStartDate.getDate();
	orderStartDate.setDate(endDate +365);
	var year = orderStartDate.getFullYear();
	var month = orderStartDate.getMonth()+1;
	var day = orderStartDate.getDate();
	if(month < 10){
		month = "0"+month;
	}
	if(day < 10){
		day = "0"+day;
	}
	var getDate = year+"-"+month+"-"+day;
	if(orderStartDate < orderEndDate){
		alert("날짜 범위가 1년을 넘을수 없습니다.");
		$("#srcOrderEndDate").val(getDate);
		return;
	}
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
<%	if(orderCancel){ %>
	//주문취소내역
	header = "주문취소내역";
	manualPath = "/img/manual/branch/orderCancelList.jpg";
<%	}else{ %>
	//주문조회
	header = "주문내역확인/주문취소";
	manualPath = "/img/manual/branch/orderList.jpg";
<%} %>
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<!-- <form id="frm" name="frm" onsubmit="return false;"> -->
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'><%if(isDiv){ %>물량배분 발주처리<%}else if(orderCancel){ %>주문취소내역<%}else{ %>주문조회<%} %>
					<%if(!isAdm){ %>
						&nbsp;<span id="question" class="questionButton">도움말</span>
					<%}%>
					</td>
					<td align="right" class='ptitle'>
						<button id='allExcelButton' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcButton' class="btn btn-default btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
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
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">주문번호</td>
					<td class="table_td_contents">
						<input id="srcOrderNumber" name="srcOrderNumber" type="text" value="" size="" maxlength="50" style="width: 150px" />
					</td>
					<td width="100" class="table_td_subject">구매사</td>
					<td colspan="3" class="table_td_contents">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 350px" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">공급업체</td>
					<td class="table_td_contents">
						<input id="srcVendorName" name="srcVendorName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
						<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
						<a href="#">
							<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
						</a>
					</td>
					<td class="table_td_subject">상품코드</td>
					<td class="table_td_contents">
						<input id="srcGoodsId" name="srcGoodsId" type="text" value="" size="20" maxlength="30" style="width: 100px" />
					</td>
					<td width="100" class="table_td_subject">상품명</td>
					<td class="table_td_contents">
						<input id="srcGoodsName" name="srcGoodsName" type="text" value="" size="" maxlength="50" style="width: 100px" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">주문상태</td>
					<td class="table_td_contents">
						<select id="srcOrderStatusFlag" name="srcOrderStatusFlag" class="select" onchange="javascript:changeOrderStatusFlag();" <%if(isDiv||orderCancel){out.print("disabled='disabled'");} %>>
							<option value="">전체</option>
<%  
if(!isDiv&&!orderCancel){
	if (codeList.size() > 0 ) {
		CodesDto cdData = null;
		for (int i = 0; i < codeList.size(); i++) {
			cdData = codeList.get(i); 
%>
							<option value="<%=cdData.getCodeNm1()%>"  <%if(!clientOrderStatus.equals("") &&clientOrderStatus.equals(cdData.getCodeNm1())){ out.print("selected");}%>><%=cdData.getCodeNm1()%></option>
<% } } } 
if(isDiv){%>
							<option value="주문요청" selected="selected">주문요청</option>
<% }else if(orderCancel){%>
							<option value="주문취소" selected="selected">주문취소</option>
<% }%>
						</select>
					</td>
					<td class="table_td_subject">주문일</td>
					<td class="table_td_contents">
						<input type="text" name="srcOrderStartDate" id="srcOrderStartDate" style="width: 75px;vertical-align: middle;" /> 
						~ 
						<input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
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
<%		} %>
						</select>
<%	} else {%>
						<input id="srcOrderUserName" name="srcOrderUserName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
						<input id="srcOrderUserId" name="srcOrderUserId" type="hidden" value="" size="20" maxlength="30" style="width: 100px" />
						<a href="#">
							<img id="btnUser" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
						</a>
<%  }   %>
					</td>
				</tr>
<%if(isAdm){ %>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100"> 상품 담당자 </td>
					<td class="table_td_contents">
						<select id="srcProductManagerUser" name="srcProductManagerUser" class="select">
							<option value="">전체</option>
<%
		if (productManagerList != null && productManagerList.size() > 0 ) {
			SmpUsersDto sud = null;
			for (int i = 0; i < productManagerList.size(); i++) {
				sud = productManagerList.get(i);
				String _selected = "";
				if(loginUserDto.getUserId().equals(sud.getUserId())) _selected="selected";
%>
							<option value="<%=sud.getUserId()%>" <%=_selected %>><%=sud.getUserNm()%></option>
<%
			}
		}
%>
						</select>
					</td>
					<td class="table_td_subject" width="100">선입금여부</td>
					<td class="table_td_contents">
						<select id="prepay" name="prepay" class="select">
							<option value="">전체</option>
							<option value="1">예</option>
							<option value="0">아니오</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">공사담당자</td>
					<td class="table_td_contents" colspan="3">
						<select id="srcWorkInfoUser" name="srcWorkInfoUser" class="select">
							<option value="">전체</option>
<%
		if (workInfoList != null && workInfoList.size() > 0 ) {
			SmpUsersDto sud = null;
			for (int i = 0; i < workInfoList.size(); i++) {
				sud = workInfoList.get(i);
				String _selected = "";
				if(loginUserDto.getUserId().equals(sud.getUserId())) _selected="selected";
%>
							<option value="<%=sud.getUserId()%>" <%=_selected %>><%=sud.getUserNm()%></option>
<%
			}
		}
%>
						</select>
					</td>
				</tr>
<%}%>
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
               </table>
               <!-- 컨텐츠 끝 -->
            </td>
         </tr>
         <tr><td height="10" align="left"></td></tr>
         <tr>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td><%if(!orderCancel){%><font color="red">*</font> 주문의 상세내용 및 주문 취소는 상세화면에서 확인해주십시오.<%} %></td>
                        <td align="right">
                           <span id="total_sum_pric"></span>&nbsp;
                        </td>
                    </tr>
               </table>
           </td>
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
        <div id="dialog" title="Feature not supported" style="display:none;">
            <p>That feature is not supported.</p>
        </div>
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>데이터를 선택 하십시오.</p>
      </div>
      <%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp"%>
<!--    </form> -->
</body>
</html>