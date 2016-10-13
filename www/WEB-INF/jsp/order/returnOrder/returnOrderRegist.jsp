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

	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "";
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-360 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");

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
		fnSearchExcelView(); 
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/selectReturnOrderRegist.sys', 
		editurl: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",	//활성화된 컬럼정보을 가지고 오기 위한 Dummy controller
		datatype: 'local',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'주문일자', '납품요청일', '인수일자', '주문유형','주문번호','반품가능수량','반품요청', '인수증 출력'
		,'공사명','출하차수', '인수차수','배송유형','송장번호','고객사','공급사','상품명', '규격','GOOD_ST_SPEC_DESC','주문수량','인수수량'
		,'sum_return_request_quan','good_clas_type', 'disp_good_id', 'good_iden_numb', 'vendorId', 'deli_type_clas_code'
		, 'receipt_num', 'receivecancelable', 'tmp_return_able_quan','branchId', 'is_add','발주차수'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false },
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'purc_proc_date',index:'purc_proc_date', width:70,align:"center",search:false,sortable:true, editable:false },	//주문유형
			{name:'orde_type_clas',index:'orde_type_clas', width:60,align:"center",search:false,sortable:true, editable:false ,hidden:true},	//주문유형
			{name:'orde_iden_numb',index:'orde_iden_numb', width:105,align:"center",search:false,sortable:true, editable:false },	//주문번호
			{name:'return_requ_quan',index:'return_requ_quan', width:70,align:"right",search:false,sortable:true,
				editable:true,sorttype:'integer',formatter:'integer',
				editoptions:{
					maxlength:10,
					dataInit:function(elem){
						$(elem).numeric();
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "right");
					},	
					dataEvents:[{
						type:'change',
	  					fn:function(e){
	  						var rowid = (this.id).split("_")[0];
// 	  						var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	  						var inputValue = Number(this.value);
// 	  						if(inputValue <= 0){
// 								alert("반품요청수량을 확인해주십시오.");
// 								jq("#list").restoreRow(rowid);
// 								jq("#list").jqGrid('setRowData', rowid, {rece_prod_quan:chkDeliProdQuanCnt});
// 								jq('#list').editRow(rowid);
// 	  						}
// 	  						var chkDeliProdQuanCnt = Number(selrowContent.rece_prod_quan) - Number(selrowContent.sum_return_request_quan); 	
// 	  						if(inputValue>chkDeliProdQuanCnt) {
// 								alert("인수수량 보다 반품요청수량이 많을 수 없습니다.");
// 								jq("#list").restoreRow(rowid);
// 								jq("#list").jqGrid('setRowData', rowid, {rece_prod_quan:chkDeliProdQuanCnt});
// 								jq('#list').editRow(rowid);
// 								return;
// 							}
							jq("#list").restoreRow(rowid);
							jq("#list").jqGrid('setRowData', rowid, {return_requ_quan:inputValue});
							jq('#list').editRow(rowid);
						}
	  				}]
				}
			},	//반품요청수량
			{name:'btn',index:'btn', width:60,align:"center",search:false,sortable:false,align:"left", editable:false },	//내역확인
			{name:'btn1',index:'btn1', width:80,align:"center",search:false,sortable:false,align:"left", editable:false },
			{name:'cons_iden_name',index:'cons_iden_name', width:250,align:"left",search:false,sortable:true, editable:false },	//공사명
			{name:'deli_iden_numb',index:'deli_iden_numb', width:50,align:"center",search:false,sortable:true, editable:false ,hidden:true},	//출하차수
			{name:'rece_iden_numb',index:'rece_iden_numb', width:50,align:"center",search:false,sortable:true, editable:false ,hidden:true},	//출하차수
			{name:'deli_type_clas',index:'deli_type_clas', width:80,align:"center",search:false,sortable:true, editable:false },	//배송유형
			{name:'deli_invo_iden',index:'deli_invo_iden', width:80,align:"left",search:false,sortable:true, editable:false },	//송장번호
			{name:'orde_client_name',index:'orde_client_name', width:180,align:"left",search:false,sortable:true, editable:false },	//고객사
			{name:'vendornm',index:'vendornm', width:180,align:"left",search:false,sortable:true, editable:false },	//공급사
			{name:'good_name',index:'good_name', width:180,align:"left",search:false,sortable:true, editable:false },	//상품명
			{name:'good_spec_desc',index:'good_spec_desc', width:180,align:"left",search:false,sortable:true, editable:false },	
			{name:'good_st_spec_desc',index:'good_st_spec_desc', hidden:true,search:false,sortable:true, editable:false },	
			{name:'orde_requ_quan',index:'orde_requ_quan', width:50,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },	//주문수량
			{name:'rece_prod_quan',index:'rece_prod_quan', width:50,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },	// 인수수량
			{name:'sum_return_request_quan',index:'sum_return_request_quan', search:false,sortable:false, editable:false, hidden:true,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//주문유형
			{name:'good_clas_type',index:'good_clas_type', search:false,sortable:false, editable:false, hidden:true },
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorId',index:'vendorId', hidden:true, search:false,sortable:true, editable:false },
			{name:'deli_type_clas_code',index:'deli_type_clas_code', hidden:true, search:false,sortable:true, editable:false },
			{name:'receipt_num',index:'receipt_num',hidden:true},
			{name:'receivecancelable',index:'receivecancelable', search:false,sortable:false, editable:false, hidden:true,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'tmp_return_able_quan',index:'tmp_return_able_quan',hidden:true},
			{name:'branchId',index:'branchId',hidden:true},
			{name:'is_add',index:'is_add',hidden:true},
			{name:'purc_iden_numb',index:'purc_iden_numb', width:50,align:"center",search:false,sortable:true, editable:false }	//발주차수
		],
		postData: {
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
			srcVendorId:$("#srcVendorId").val(),
			srcOrderStartDate:$('#srcOrderStartDate').val(),
			srcOrderEndDate:$('#srcOrderEndDate').val(),
			srcOrderUserId:$("#srcOrderUserId").val()
<%	if(isAdm){ 	%>
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
<%	}	%>
		},multiselect: false,
		rowNum:30, rownumbers: false, rowList:[30,50], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'regi_date_time', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				var return_requ_quan = Number(selrowContent.rece_prod_quan) - Number(selrowContent.sum_return_request_quan);
				if(selrowContent.rece_iden_numb != '' && return_requ_quan > 0 &&"과거상품" != selrowContent.orde_type_clas){
					jq("#list").jqGrid('setRowData', rowid, {return_requ_quan:return_requ_quan});
					jq("#list").jqGrid('setRowData', rowid, {tmp_return_able_quan:return_requ_quan});
					//var inputBtn = "<input style='height:22px;width:80px;' type='button' value='반품요청' onclick=\"fnReturn_requ_Button('"+rowid+"');\" />";
					var inputBtn = "";
					inputBtn += "<button id='srcButton' class='btn btn-danger btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' onclick=\"fnReturn_requ_Button('"+rowid+"');\">";
					inputBtn += "반품요청";
					inputBtn += "</button>";
					jQuery('#list').jqGrid('setRowData',rowid,{btn:inputBtn});
					jQuery('#list').jqGrid('editRow',rowid,true);
				}
				if(selrowContent.receipt_num != ''){
					var inputBtn = "";
					inputBtn += "<button id='srcButton' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' onclick=\"openReceipt('"+rowid+"');\">";
					inputBtn += "인수증 출력";
					inputBtn += "</button>";
					jq('#list').jqGrid('setRowData',rowid,{btn1:inputBtn});
				}
				if(Number(selrowContent.receivecancelable) == 0 && Number(selrowContent.rece_iden_numb) < 2 && Number(selrowContent.sum_return_request_quan) == 0 && Number(selrowContent.rece_prod_quan) >= 0){
					var chkBox = "<input id='isCheck_"+rowid+"' name='isCheck_"+rowid+"' type='checkbox'  offval='no'  style='border:none;'/>";
					jq('#list').jqGrid('setRowData',rowid,{isCheck:chkBox});
				}
				
                if(selrowContent.is_add == 'Y'){
                    $("#"+rowid).css("background", "#ffeedd");	
                }
			}
		},
		afterInsertRow: function(rowid, aData){
<%if(!isVendor && !spUser){%>
			jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
<%}%>
<%if(!spUser){%>
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
		onSelectRow: function (rowid, iRow, iCol, e) {
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
<%if(!isVendor && !spUser){%>
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
<%}%>
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%}else if(isAdm && !spUser){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%} %>
			if(colName != undefined &&colName['index']=="deli_invo_iden") { 
				if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){					
					fnSearchDeliPopup(selrowContent.deli_type_clas_code, selrowContent.deli_invo_iden);
				}
			}
<%if(isAdm){%>
			//구매사 상세 팝업
			if(colName != undefined &&colName['index']=="orde_client_name") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchId);")%>
			}
			//공급사 상세 팝업
			if(colName != undefined &&colName['index']=="vendornm") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorId);")%>
			}
<%}%>
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
/*
 * 리스트 조회
 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1, datatype:"json"});
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
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/**
 * 인수취소
 */
function fnReceiveCancel(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
      			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
//       			if("90" == selrowContent.orde_type_clas_code ||"50" == selrowContent.orde_type_clas_code){
//       				alert("주문번호["+selrowContent.orde_iden_numb+"] 발주차수 ["+selrowContent.purc_iden_numb+"]의 주문유형을 확인바랍니다.");
//       				return;
//       			}
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
	}
	if(!confirm("선택된 인수 주문 정보를 인수취소처리를 하시겠습니까?")){
		return;
	}
	fnStatChangeReasonDialog("receiveCancelProcess");
}
function receiveCancelProcess(reason){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var deli_iden_numb_array = new Array();
	var rece_iden_numb_array = new Array();
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
            	rece_iden_numb_array[arrRowIdx] = selrowContent.rece_iden_numb;
				arrRowIdx++;
			}
		}
		
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{ 	orde_iden_numb_array:orde_iden_numb_array, 
				purc_iden_numb_array:purc_iden_numb_array, 
				deli_iden_numb_array:deli_iden_numb_array, 
				rece_iden_numb_array:rece_iden_numb_array, 
				orde_stat_flag:'70' },
			function(arg2){
				if(fnTransResult(arg2, false)) {	//성공시
					$.post(
			    		"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/receiveCancelOrderProcessTransGrid.sys",
						{  
			    			orde_iden_numb_array:orde_iden_numb_array
			    			, purc_iden_numb_array:purc_iden_numb_array
			    			, deli_iden_numb_array:deli_iden_numb_array
			    			, rece_iden_numb_array:rece_iden_numb_array
							, reason:reason
						}
						,function(arg){ 
			    			if(fnAjaxTransResult(arg)) {
			    				jq("#list").trigger("reloadGrid");
			    			}else{
			    				var msg = eval('(' + arg + ')').customResponse;
			    				alert(msg.message[0]);
			    			}
						}
					);
				} else {
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
function receiveCancelProcess_cancel(){
}
/*
 * 반품요청버튼
 */
var return_rowid;
function fnReturn_requ_Button(rowid) {
	return_rowid = rowid;
	jq("#list").restoreRow(rowid);
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	if(Number(selrowContent.return_requ_quan) <=0) {
		alert("반품요청수량이 0 이거나 0 보다 작을 수 없습니다.");
      	jq('#list').editRow(rowid);
      	return_rowid ="";
		return;
	}
	var chkDeliProdQuanCnt = Number(selrowContent.rece_prod_quan) - Number(selrowContent.sum_return_request_quan);	//반품가능수량
	if(Number(selrowContent.return_requ_quan) > chkDeliProdQuanCnt) {
		alert("반품가능항 수량은 "+chkDeliProdQuanCnt+" 입니다. 반품요청수량을 다시 확인해주시기 바랍니다.");
      	jq('#list').editRow(rowid);
      	return_rowid ="";
		return;
	}
// 	if(confirm(selrowContent.return_requ_quan+" 수량만큼 반품요청하시겠습니까?")){
      	fnStatChangeReasonDialog("returnRequestProcess");
// 	}else{
//       	jq('#list').editRow(rowid);
//       	return_rowid ="";
// 	}
}
function returnRequestProcess(reason){
	if(!confirm("반품요청을 진행하시겠습니까?")){
      	jq('#list').editRow(return_rowid);
      	return_rowid ="";
      	return;
	}
	jq('#list').saveRow(return_rowid);
	var selrowContent = jq("#list").jqGrid('getRowData',return_rowid);
	var orde_iden_numb = selrowContent.orde_iden_numb;
	var purc_iden_numb = selrowContent.purc_iden_numb;
	var deli_iden_numb = selrowContent.deli_iden_numb;
	var rece_iden_numb = selrowContent.rece_iden_numb;
	var return_requ_quan = selrowContent.return_requ_quan;
	
	//반품가능수량 가져오기
	var returnProdQuanCnt = 0;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getReturnProdQuanCnt.sys", 
		{ 	orde_iden_numb:orde_iden_numb, 
			purc_iden_numb:purc_iden_numb, 
			deli_iden_numb:deli_iden_numb, 
			rece_iden_numb:rece_iden_numb },
		function(arg2){
			returnProdQuanCnt = eval('(' + arg2 + ')').returnProdQuan;
			if(Number(returnProdQuanCnt) <= 0) {
				alert("반품이 가능하지 않습니다.");
				jq("#list").trigger("reloadGrid");
				return;
			}
			if(Number(return_requ_quan) > Number(returnProdQuanCnt)) {
				alert("반품가능 수량은 "+returnProdQuanCnt+" 입니다.");
				jq("#list").trigger("reloadGrid");
				return;
			}
			
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/returnOrderProcessTransGrid.sys",
				{  orde_iden_numb:orde_iden_numb
				 , purc_iden_numb:purc_iden_numb
				 , deli_iden_numb:deli_iden_numb
				 , rece_iden_numb:rece_iden_numb
				 , return_requ_quan:return_requ_quan
				 , reason:reason
				}
				,function(arg){ 
					if(fnAjaxTransResult(arg)) {
						jq("#list").trigger("reloadGrid");
					}
				}
			);
			return_rowid ="";
		}
	);
}
function returnRequestProcess_cancel(){
  	jq('#list').editRow(return_rowid);
  	return_rowid ="";
}

function fnSearchExcelView(){
	var colLabels = ['주문일자', '납품요청일', '인수일자', '주문유형','주문번호','공사명','발주차수','출하차수', '인수차수','배송유형','송장번호','고객사','공급사','상품명','규격','주문수량','인수수량','반품(요청)수량'];
	var colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 'PURC_PROC_DATE', 'ORDE_TYPE_CLAS', 'ORDE_IDEN_NUMB','CONS_IDEN_NAME', 'PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 'RECE_IDEN_NUMB', 'DELI_TYPE_CLAS', 'DELI_INVO_IDEN', 'ORDE_CLIENT_NAME', 'VENDORNM', 'GOOD_NAME', 'GOOD_SPEC_DESC','ORDE_REQU_QUAN', 'RECE_PROD_QUAN', 'SUM_RETURN_REQUEST_QUAN'];
	var numColIds = ['ORDE_REQU_QUAN','RECE_PROD_QUAN','SUM_RETURN_REQUEST_QUAN'];
	var figureColIds = ['PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 'RECE_IDEN_NUMB'];
	var sheetTitle = "인수내역";	//sheet 타이틀
	var excelFileName = "returnOrderRegist";	//file명
	
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
   
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/returnOrder/returnOrderRegistExcelView.sys", figureColIds);  
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

	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "receivePrint"; // reb 파일이름
	oReport.param("receipt_num").value = receiptNum; // 매개변수 세팅
	
	oReport.title = "인수증"; // 제목 세팅
	oReport.open();
}

/**
 * 거래명세서 출력 (2013-02-06 by Kave)
 */
function fnParticularsTargetBranchs(){
	var srcGroupId        = $("#srcGroupId").val();
	var srcClientId       = $("#srcClientId").val();
	var srcBranchId       = $("#srcBranchId").val();
	var srcVendorId       = $("#srcVendorId").val();
	var srcOrderStartDate = $("#srcOrderStartDate").val();
	var srcOrderEndDate   = $("#srcOrderEndDate").val();
	var srcOrderUserId	  = $("#srcOrderUserId").val();
	var srcOrdeIdenNumb	  = $("#srcOrdeIdenNumb").val();
	var srcWorkInfoUser = $("#srcWorkInfoUser").val();
	
	$.post(	//조회조건의 회원사등급 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/getParticularsTargetBranchs.sys',
		{
			srcGroupId:srcGroupId,
			srcClientId:srcClientId,
			srcBranchId:srcBranchId,
			srcVendorId:srcVendorId,
			srcOrderStartDate:srcOrderStartDate,
			srcOrderEndDate:srcOrderEndDate,
			srcOrderUserId:srcOrderUserId,
			srcOrdeIdenNumb:srcOrdeIdenNumb,
			srcWorkInfoUser:srcWorkInfoUser
		},
		function(arg){
			var branchList = eval('(' + arg + ')').list;
			
			if(branchList.length == 0) {
				alert("출력할 내용이 없습니다.");
				return;
			}
			
			for(var i = 0 ; i < branchList.length ; i++){
				fnParticulars(branchList[i], i);
			}
		}
	);	
} 
 
function fnParticulars(obj ,idx){

	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	
	//검색조건
	var srcGroupId        = $("#srcGroupId").val();
	var srcClientId       = $("#srcClientId").val();
	var srcBranchId       = $("#srcBranchId").val();
	var srcVendorId       = $("#srcVendorId").val();
	var srcOrderStartDate = $("#srcOrderStartDate").val();
	var srcOrderEndDate   = $("#srcOrderEndDate").val();
	var srcOrderUserId	  = $("#srcOrderUserId").val();
	var srcOrdeIdenNumb	  = $("#srcOrdeIdenNumb").val();
	
	var oReport = GetfnParamSet(idx); // 필수
	oReport.rptname = "Particulars"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;

	oReport.param("srcGroupId").value 		= obj.groupId;
	oReport.param("srcClientId").value 		= obj.clientId;
	oReport.param("srcBranchId").value 		= obj.branchId;
	oReport.param("srcVendorId").value 		= srcVendorId;
	oReport.param("srcOrderStartDate").value = srcOrderStartDate;
	oReport.param("srcOrderEndDate").value 	 = srcOrderEndDate;
	oReport.param("srcOrderUserId").value 	 = srcOrderUserId;
	oReport.param("srcOrdeIdenNumb").value 	 = srcOrdeIdenNumb;
	

	oReport.title = "거래명세서"; // 제목 세팅
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
	//인수내역/반품신청
	header = "인수내역/반품신청";
	manualPath = "/img/manual/branch/returnOrderRegist.jpg";
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
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td height="29" class='ptitle'>인수내역 / 반품신청
					<% if(isClient){ %>
						&nbsp;<span id="question" class="questionButton">도움말</span>
					<%} %>
					</td>
					<td align="right" class='ptitle'>
						<button class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" onclick="fnParticularsTargetBranchs();">
							<i class="fa fa-print"></i> 거래명세서출력
						</button>
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
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
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
					<td width="100" class="table_td_subject">공급업체</td>
					<td class="table_td_contents">
					<input id="srcVendorName" name="srcVendorName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
						<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
						<a href="#">
							<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
						</a>
					</td>
					<td class="table_td_subject">인수일</td>
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
					<td class="table_td_contents">
						<input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="20" maxlength="30" />
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
<%	}else{%>
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
<%}%>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table> 
			<!-- 컨텐츠 끝 -->
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
                        <button id='srcButton' class="btn btn-info btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" onclick="fnReceiveCancel();"> <i class="fa fa-check-square-o"></i> 인수취소 </button>
                	</td>
                </tr>
            </table>
		</td>
	</tr>
	<tr>
		<td height="1"></td>
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
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<%@ include file="/WEB-INF/jsp/common/svcStatChangeReasonDiv.jsp" %>
</form>
</body>
</html>