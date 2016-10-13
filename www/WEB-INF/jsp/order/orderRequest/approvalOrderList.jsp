<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="java.util.List"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String clientOrderStatus = request.getParameter("srcOrderStatusFlag") == null ? "" : request.getParameter("srcOrderStatusFlag");

	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isDiv = (Boolean)request.getAttribute("isDiv") == null ? false : true;
	boolean orderCancel = request.getAttribute("orderCancel") == null ? false : true;
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
    boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
    boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;

    String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : loginUserDto.getSvcTypeCd().equals("ADM") ? "-25" :"";
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-275 + Number(gridHeightResizePlus)"+categoryHeightMinus;

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<CodesDto> codeList = (List<CodesDto>)request.getAttribute("codeList");
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
    
	// 날짜 세팅
	String srcOrderStartDate = CommonUtils.getCustomDay("DAY", -7);
    if(!clientOrderStatus.equals("")){
		srcOrderStartDate = CommonUtils.getCustomDay("MONTH", -1); 
    }
	String srcOrderEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>


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
function fnSelectSupervisorUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#srcSupervisorUserName").val(userNm);
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
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
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
});

// 날짜 조회 및 스타일
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
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'주문일자','납품요청일','주문번호','공사명', '주문유형',  '주문상태', '고객사', '공급사', '공급사 전화번호','주문자', '상품명', '규격','판매단가', '수량', '판매금액', <%if(!isClient){%>'매입단가', '매입금액', <%}%> '긴급여부','disp_good_id', 'vendorid', 'good_iden_numb', 'good_st_spec_desc'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false, editable:false,sorttype:"date", editable:false,formatter:"date"},//주문일자
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false,sorttype:"date", editable:false,formatter:"date"},//납품요청일
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"left",search:false,sortable:true, editable:false},//주문번호
			{name:'cons_iden_name',index:'cons_iden_name', width:120,align:"left",search:false,sortable:true, editable:false },//공사명
			{name:'orde_type_clas',index:'orde_type_clas', width:50,align:"center",search:false,sortable:true, editable:false },//주문유형
			{name:'order_status_flag',index:'order_status_flag', width:150,align:"left",search:false,sortable:true, editable:false },//주문상태
			{name:'orde_client_name',index:'orde_client_name', width:200,align:"left",search:false,sortable:true, editable:false },//고객사
			{name:'vendor_name',index:'vendor_name', width:120,align:"left",search:false,sortable:true, editable:false},//공급사
			{name:'phonenum',index:'phonenum', width:90,align:"right",search:false,sortable:true, editable:false},//공급사
			{name:'orde_user_name',index:'orde_user_name', width:50,align:"left",search:false,sortable:true, editable:false},//주문자
			{name:'good_iden_name',index:'good_iden_name', width:140,align:"left",search:false,sortable:true, editable:false },//상품명
			{name:'good_spec_desc',index:'good_spec_desc', width:140,align:"left",search:false,sortable:true, editable:false },//상품규격
			{name:'sell_price',index:'sell_price', width:70,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매단가
			{name:'orde_requ_quan',index:'orde_requ_quan', width:70,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수량
			{name:'total_sell_price',index:'total_sell_price', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매금액
<%if(!isClient){%>			
			{name:'sale_unit_pric',index:'sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입단가
			{name:'total_sale_price',index:'total_sale_price', width:80,align:"right",search:false,sortable:true, editable:false,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입금액
<%}%>			
			{name:'emer_orde_clas',index:'emer_orde_clas', width:50,align:"center",search:false,sortable:true, editable:false },
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false},
			{name:'vendorid',index:'vendorid', hidden:true, search:false,sortable:true, editable:false},
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false},
            {name:'good_st_spec_desc',index:'good_st_spec_desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true }//표준규격
		],
		postData: {
			srcGroupId:$("#srcGroupId").val()
			,srcClientId:$("#srcClientId").val()
			,srcBranchId:$("#srcBranchId").val()
			,srcOrderUserId:$("#srcOrderUserId").val()
			,srcOrderStartDate:$('#srcOrderStartDate').val()
			,srcOrderEndDate:$('#srcOrderEndDate').val()
<%	if(isAdm){ 	%>
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
<%	}	%>
<%	if(isClient){ 	%>
			,srcApproveUserId:"<%=loginUserDto.getUserId()%>"
<%	}	%>
			,srcOrderStatusFlag:"승인요청"
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname: 'regi_date_time', sortorder: "desc",
		caption:"주문조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	
		loadComplete: function() {
            // 품목 표준 규격 설정
            var prodStSpcNm = new Array();
            <% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
                prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
            <% } %>
            
            // 품목 규격 property 추출
            var prodSpcNm = new Array();
            <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
                prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
            <% }                                                                       %>
            var rowCnt = jq("#list").getGridParam('reccount');
            for(var idx=0; idx<rowCnt; idx++) {
                var rowid = $("#list").getDataIDs()[idx];
                
                jq("#list").restoreRow(rowid);
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                
                // 규격 화면 로드
                var argStArray = selrowContent.good_st_spec_desc.split("‡");
                var argArray = selrowContent.good_spec_desc.split("‡");
                
                var prodStSpec = "";
                var prodSpec = "";
                
                for(var stIdx = 0 ; stIdx < prodSpcNm.length ; stIdx ++ ) {
                    if(argStArray[stIdx] > ' ') {
                        prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
                    }
                }
                
                if(prodStSpec.length > 0) {
                    prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
                    prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
                }
                
                for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
                    if($.trim(argArray[jIdx]) > ' ') {
                         if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
                         else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
                    }
                }
                prodStSpec += prodSpec;
                jQuery('#list').jqGrid('setRowData',rowid,{good_spec_desc:prodStSpec});
            }
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
        afterInsertRow: function(rowid, aData){
     		jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
     		jq("#list").setCell(rowid,'good_iden_name','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'good_iden_name','',{cursor: 'pointer'});  
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
            if(colName != undefined &&colName['index']=="good_iden_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_iden_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isAdm){%>
			if(colName != undefined &&colName['index']=="good_iden_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%} %>
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
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;'/>";
}
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

function orderApproval(){
	var orde_iden_numb_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
		if(!confirm("선택된 정보를 승인처리 하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderRequestApproval.sys",
			{  
				orde_iden_numb_array:orde_iden_numb_array 
			}
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {	
					alert("정상적으로 승인처리가 되었습니다.");
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
function orderReject(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
	}
	if(confirm("선택된 정보를 반려처리하시겠습니까?")){
      	fnStatChangeReasonDialog("processOrderReject");
	}
}
function processOrderReject(reason){
	var orde_iden_numb_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
				arrRowIdx++;
			}
		}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderRequestReject.sys",
			{  orde_iden_numb_array:orde_iden_numb_array 
			  ,reason:reason
			}
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {	
					alert("정상적으로 반려처리가 되었습니다.");
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
function processOrderReject_cancel(){}
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
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/*
 * 엑셀 출력
 */
function exportExcel() {
	var colLabels = ['주문일자','납품요청일','주문번호','공사명', '주문유형',  '주문상태', '고객사', '공급사', '공급사 전화번호','주문자', '상품명', '규격','판매단가', '수량', '판매금액', <%if(!isClient){%>'매입단가', '매입금액', <%}%> '긴급여부'];
	var colIds = ['regi_date_time', 'requ_deli_date', 'orde_iden_numb', 'cons_iden_name', 'orde_type_clas', 'order_status_flag', 'orde_client_name', 'vendor_name', 'phonenum', 'orde_user_name', 'good_iden_name', 'good_spec_desc', 'sell_price', 'orde_requ_quan', 'total_sell_price', <%if(!isClient){%>'sale_unit_pric', 'total_sale_price', <%}%>'emer_orde_clas' ];
	var numColIds = ['sell_price','orde_requ_quan','total_sell_price'<%if(!isClient){%>,'sale_unit_pric','total_sale_price'<%}%>];	
	var sheetTitle = "주문승인조회";	//sheet 타이틀
	var excelFileName = "OrderApprovalList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnAllExcelPrintDown(){
	var colLabels = ['주문일자','납품요청일','주문번호','공사명', '주문유형',  '주문상태', '고객사', '공급사', '공급사 전화번호','주문자', '상품명', '규격','판매단가', '수량', '판매금액', <%if(!isClient){%>'매입단가', '매입금액', <%}%> '긴급여부'];
	var colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 'ORDE_IDEN_NUMB', 'CONS_IDEN_NAME', 'ORDE_TYPE_CLAS', 'ORDER_STATUS_FLAG', 'ORDE_CLIENT_NAME', 'VENDOR_NAME', 'PHONENUM', 'ORDE_USER_NAME', 'GOOD_IDEN_NAME', 'GOOD_SPEC_DESC', 'SELL_PRICE', 'ORDE_REQU_QUAN', 'TOTAL_SELL_PRICE', <%if(!isClient){%>'SALE_UNIT_PRIC', 'TOTAL_SALE_PRICE', <%}%>'EMER_ORDE_CLAS' ];
	var numColIds = ['SELL_PRICE','ORDE_REQU_QUAN','TOTAL_SELL_PRICE'<%if(!isClient){%>,'SALE_UNIT_PRIC','TOTAL_SALE_PRICE'<%}%>];	
	var sheetTitle = "주문승인조회";	//sheet 타이틀
	var excelFileName = "OrderApprovalList";	//file명
    
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
    
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/orderRequest/orderListExcel.sys");  
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
 *	주문조회 페이지로 이동한다. 
 */
function fnGoOrderList() {
	$('#frm').attr('action','/order/orderRequest/orderList.sys');
	$('#frm').attr('Target','_self');
	$('#frm').attr('method','post');
	$('#frm').submit();
}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
   <form id="frm" name="frm">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>주문승인조회</td>
                     <td align="right" class='ptitle'>
                        <img id="allExcelButton" src="/img/system/btn_type3_orderResultExcel.gif" width="130" height="22" style="cursor:pointer;"/>
                        <img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style="cursor:pointer;"/>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">주문번호</td>
                     <td class="table_td_contents">
                        <input id="srcOrderNumber" name="srcOrderNumber" type="text" value="" size="" maxlength="50" style="width: 100px" />
                     </td>
                     <td width="100" class="table_td_subject">고객사</td>
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
                        <select id="srcOrderStatusFlag" name="srcOrderStatusFlag" class="select" onchange="javascript:changeOrderStatusFlag();" disabled="disabled">
                           <option value="승인요청" selected="selected">승인요청</option>
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
							<option value="" >전체</option>
<%
		}
		for(UserDto userDto:_srcUserList) {
			String _selected = "";
			if(loginUserDto.getUserId().equals(userDto.getUserId())) //_selected="selected";
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
                     <td class="table_td_contents" >
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
               </table>
               <!-- 컨텐츠 끝 -->
            </td>
         </tr>
         <tr><td height="10" align="left"></td></tr>
         <tr>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td><%if(!orderCancel){%>* 주문의 상세내용 및 주문 취소는 상세화면에서 확인해주십시오.<%} %></td>
                        <td align="right">
                            <a href="javascript:orderApproval();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_return_approval.jpg" width="62" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
                            <a href="javascript:orderReject();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_return_reject.jpg" width="62" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
                           <a href="#"> <img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> </a>
                           <a href="#"> <img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> </a>
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
    <%@ include file="/WEB-INF/jsp/common/svcStatChangeReasonDiv.jsp" %>
      <%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp"%>
   </form>
</body>
</html>