<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-400 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	// 주문유형
	List<CodesDto> orderTypeCode = (List<CodesDto>)request.getAttribute("orderTypeCode");
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
	boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
	boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	// 날짜 세팅
	String srcPurcStartDate = CommonUtils.getCustomDay("DAY", -7);
	String srcPurcEndDate = CommonUtils.getCurrentDate();
	
	// 날짜 세팅
	String srcOrdeStartDate = CommonUtils.getCustomDay("DAY", -7);
	String srcOrdeEndDate = CommonUtils.getCurrentDate();
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
	String _srcVendorName = "";
	String _srcVendorId = "";
	if("VEN".equals(loginUserDto.getSvcTypeCd())) {
		_srcVendorName = loginUserDto.getBorgNm();
		_srcVendorId = loginUserDto.getBorgId();
	}
%>
	$("#srcVendorName").val("<%=_srcVendorName%>");
	$("#srcVendorId").val("<%=_srcVendorId%>");
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcVendorName").attr("disabled", true);
	$("#btnVendor").css("display","none");
<%	}	%>

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
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
<%if(isAdm){%>
		$("#srcOrdeStartDate").val($.trim($("#srcOrdeStartDate").val()));
		$("#srcOrdeEndDate").val($.trim($("#srcOrdeEndDate").val()));
<%}%>
		fnSearch(); 
	});
    $("#allExcelButton").click(function(){ 
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
<%if(isAdm){%>
		$("#srcOrdeStartDate").val($.trim($("#srcOrdeStartDate").val()));
		$("#srcOrdeEndDate").val($.trim($("#srcOrdeEndDate").val()));
<%}%>
		fnAllExcelPrint(); 
	});
	
	// 날짜 세팅
	$("#srcPurcStartDate").val("<%=srcPurcStartDate%>");
	$("#srcPurcEndDate").val("<%=srcPurcEndDate%>");
	$("#srcPurcStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcPurcEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
<%if(isAdm){%>
	$("#srcOrdeStartDate").val("<%=srcOrdeStartDate%>");
	$("#srcOrdeEndDate").val("<%=srcOrdeEndDate%>");
	$("#srcOrdeStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcOrdeEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
<%}%>
	
   // 날짜 조회 및 스타일
   $(function(){
   	$("#srcPurcStartDate").datepicker(
          	{
   	   		showOn: "button",
   	   		buttonImage: "/img/system/btn_icon_calendar.gif",
   	   		buttonImageOnly: true,
   	   		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("#srcPurcEndDate").datepicker(
          	{
          		showOn: "button",
          		buttonImage: "/img/system/btn_icon_calendar.gif",
          		buttonImageOnly: true,
          		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
   });
   
<%if(isAdm){%>
   // 날짜 조회 및 스타일
   $(function(){
   	$("#srcOrdeStartDate").datepicker(
          	{
   	   		showOn: "button",
   	   		buttonImage: "/img/system/btn_icon_calendar.gif",
   	   		buttonImageOnly: true,
   	   		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("#srcOrdeEndDate").datepicker(
          	{
          		showOn: "button",
          		buttonImage: "/img/system/btn_icon_calendar.gif",
          		buttonImageOnly: true,
          		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
   });
<%}%>
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/selectPurchaseList.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />", '주문일자', '납품요청일','납품예정일','발주의뢰일','주문유형', '고객유형', '주문번호'
		, '상품명', '상품규격',  '발주수량', '배송처주소', '구매사', '주문자명', '인수자명', '인수자 연락처','대표번호', '단가','발주 총금액' ,'비고','주문명', '첨부1','첨부2','첨부3', '공급사명', 'orde_type_clas_code', 'disp_good_id', 'good_iden_numb','vendorid', 'path1', 'path2', 'path3','good_st_spec_desc','공급사 대표번호','주문자 전화번호','branchId', '발주차수'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false },//주문일자
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },//납품요청일
			{name:'deli_sche_date',index:'deli_sche_date',width:80,align:"center",search:false,sortable:false,
				formatter: 'text',
				editable:true,edittype: 'text',
				editoptions: {
					readonly:'readonly',
					size: 9,maxlengh: 10,dataInit: function (element) {
						$(element).datepicker({ dateFormat: 'yy-mm-dd' });
					},
					dataEvents:[{
						type:'change',
						fn:function(e){
							var inputValue = this.value; 											// 입력 날짜
							var rowid = (this.id).split("_")[0];
							jq("#list").restoreRow(rowid);
							jq("#list").jqGrid('setRowData', rowid, {deli_sche_date:inputValue});
						}
					}]
				},
				editrules: {date: false}
			 },//납품예정일
			{name:'clin_date',index:'clin_date', width:70,align:"center",search:false,sortable:true, editable:false },//발주의뢰일
			{name:'orde_type_clas',index:'orde_type_clas', width:50,align:"center",search:false,sortable:true, editable:false,hidden:true },//주문유형
			{name:'worknm',index:'worknm', width:100,align:"left",search:false,sortable:true, editable:false },//고객유형
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"center",search:false,sortable:true, editable:false },//주문번호
			{name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false },//상품명
			{name:'good_spec_desc',index:'good_spec_desc', width:100,align:"left",search:false,sortable:true, editable:false },//상품규격
			{name:'purc_requ_quan',index:'purc_requ_quan', width:50,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//발주수량
			{name:'tran_data_addr',index:'tran_data_addr', width:220,align:"left",search:false,sortable:true, editable:false },//배송처주소
			{name:'orde_client_name',index:'orde_client_name', width:120,align:"left",search:false,sortable:true, editable:false },//구매사
			{name:'orde_user_name',index:'orde_user_name', width:60,align:"center",search:false,sortable:true, editable:false },//주문자명
			{name:'tran_user_name',index:'tran_user_name', width:60,align:"center",search:false,sortable:true, editable:false },//인수자명
			{name:'tran_tele_numb',index:'tran_tele_numb', width:80,align:"center",search:false,sortable:true, editable:false },//인수자연락처
			{name:'phoneNum',index:'phoneNum', width:80,align:"center",search:false,sortable:true, editable:false },//대표번호
			{name:'sale_unit_pric',index:'sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//단가
			{name:'total_sale_unit_pric',index:'total_sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//금액
			{name:'adde_text_desc',index:'adde_text_desc', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'cons_iden_name',index:'cons_iden_name', width:170,align:"left",hidden:false, search:false,sortable:true, editable:false },//주문명
			{name:'attach_file_name1',index:'attach_file_name1', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'attach_file_name2',index:'attach_file_name2', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'attach_file_name3',index:'attach_file_name3', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'vendornm',index:'vendornm', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_type_clas_code',index:'orde_type_clas_code', hidden:true, search:false,sortable:true, editable:false },
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorid',index:'vendorid', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path1',index:'attach_file_path1', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path2',index:'attach_file_path2', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path3',index:'attach_file_path3', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_st_spec_desc',index:'good_st_spec_desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },//표준규격
			{name:'vendorPhonenum', index:'vendorPhonenum', width:80,align:"center",hidden:false, search:false,sortable:true, editable:false },//공급사대표번호
			{name:'orderUserMobile', index:'orderUserMobile', width:80,align:"center",hidden:false, search:false,sortable:true, editable:false },//주문자전화번호
			{name:'branchId',index:'branchId', hidden:true, search:false,sortable:true, editable:false },//구매사ID
			{name:'purc_iden_numb',index:'purc_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }}//발주차수
		],  
		postData: {
			srcOrdeStatFlag:"40"
			,srcVendorId:$('#srcVendorId').val()
			,srcPurcStartDate:$('#srcPurcStartDate').val()
			,srcPurcEndDate:$('#srcPurcEndDate').val()
<%if(isAdm){%>
			,srcOrdeStartDate:$('#srcOrdeStartDate').val()
			,srcOrdeEndDate:$('#srcOrdeEndDate').val()
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
<%	}	%>
		},multiselect:false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		sortname: 'regi_date_time', sortorder: "desc", 
		height: <%=listHeight%>,width:<%=listWidth%>,
		caption:"발주접수", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { },
		afterInsertRow: function(rowid, aData){
<%if(!isVendor){%>
			jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
<%}%>
			jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'});  
			
			jq("#list").setCell(rowid,'attach_file_name1','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'attach_file_name2','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'attach_file_name3','',{color:'#0000ff'});
			
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if($.trim(selrowContent.attach_file_name1) != '') {
				jq("#list").setCell(rowid,'attach_file_name1','',{cursor: 'pointer'});  
			}
			if($.trim(selrowContent.attach_file_name2) != '') {
				jq("#list").setCell(rowid,'attach_file_name2','',{cursor: 'pointer'});  
			}
			if($.trim(selrowContent.attach_file_name3) != '') {
				jq("#list").setCell(rowid,'attach_file_name3','',{cursor: 'pointer'});  
			}
<%if(isAdm){%>
			jq("#list").setCell(rowid,'orde_client_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_client_name','',{cursor: 'pointer'});
			jq("#list").setCell(rowid,'vendornm','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'vendornm','',{cursor: 'pointer'});
<%}%>
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {tran_tele_numb: fnSetTelformat(selrowContent.tran_tele_numb)});
			jq("#list").jqGrid('setRowData', rowid, {phoneNum: fnSetTelformat(selrowContent.phoneNum)});
			jq("#list").jqGrid('setRowData', rowid, {vendorPhonenum: fnSetTelformat(selrowContent.vendorPhonenum)});
			jq("#list").jqGrid('setRowData', rowid, {orderUserMobile: fnSetTelformat(selrowContent.orderUserMobile)});
			
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="attach_file_name1" && $.trim(selrowContent.attach_file_name1) != '') {fnAttachFileDownload(selrowContent.attach_file_path1);}
			if(colName != undefined &&colName['index']=="attach_file_name2" && $.trim(selrowContent.attach_file_name2) != '') {fnAttachFileDownload(selrowContent.attach_file_path2);}
			if(colName != undefined &&colName['index']=="attach_file_name3" && $.trim(selrowContent.attach_file_name3) != '') {fnAttachFileDownload(selrowContent.attach_file_path3);}
<%if(!isVendor){%>
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+",selrowContent.purc_iden_numb);")%> }
<%}%>
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isAdm){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%} %>
<%if(isAdm){%>
			//구매사 상세 팝업
			if(colName != undefined &&colName['index']=="orde_client_name") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchId);")%>
			}
			//공급사 상세 팝업
			if(colName != undefined &&colName['index']=="vendornm") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorid);")%>
			}
<%}%>
			if(colName['index'] == "deli_sche_date"){
				$('#list').jqGrid('editRow',rowid,true); 
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
function fnAttachFileDownload(attach_file_path) {
	var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}
jQuery.download = function(url, data, method){
    // url과 data를 입력받음
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');  
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    }
};

function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;'/>";
}
function fnSearch(){
	var data = jq("#list").jqGrid("getGridParam", "postData");
	
	data.srcVendorId= $("#srcVendorId").val();
	data.srcPurcStartDate= $("#srcPurcStartDate").val();
	data.srcPurcEndDate= $("#srcPurcEndDate").val();
	data.srcOrdeIdenNumb= $("#srcOrdeIdenNumb").val();
	data.srcOrdeTypeClas= $("#srcOrdeTypeClas").val();
	data.srcWorkInfoUser = $("#srcWorkInfoUser").val();
	
	data.srcOrdeStartDate= $("#srcOrdeStartDate").val();
	data.srcOrdeEndDate= $("#srcOrdeEndDate").val();
	
	$("#list").jqGrid("setGridParam", {"page":1 , "datatype":"json"});
	$("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
function processPurcReceive(){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var deli_sche_date_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
				purc_iden_numb_array[arrRowIdx] = selrowContent.purc_iden_numb;
				deli_sche_date_array[arrRowIdx] = selrowContent.deli_sche_date;
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
		if(!confirm("선택된 주문 정보를 발주접수 하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{
				orde_iden_numb_array:orde_iden_numb_array,
				purc_iden_numb_array:purc_iden_numb_array,
				orde_stat_flag:'40' 
			},
			function(arg){ 
				if(fnTransResult(arg, false)) {	//성공시
					$.post(
						"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/updatePurcReceiveStatusTransGrid.sys",
						{
							orde_iden_numb_array:orde_iden_numb_array,
							purc_iden_numb_array:purc_iden_numb_array,
							deli_sche_date_array:deli_sche_date_array
						},
						function(arg2){
							fnAjaxTransResult(arg2);
							jq("#list").trigger("reloadGrid");
						}
					);
				} else {
					jq("#list").trigger("reloadGrid");
				}
			}
		);
		
// 		$.post(
<%-- 			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/updatePurcReceiveStatusTransGrid.sys", --%>
// 			{  orde_iden_numb_array:orde_iden_numb_array
// 			 , purc_iden_numb_array:purc_iden_numb_array
// 			}
// 			,function(arg){
// 				var orderFlag = arg.list;
// 				var result = '';
// 				var cnt = 0;
// 				var count = 0;
// 				for(var i=0; i<orderFlag.length;i++){
// 					var orde_iden_numb = orderFlag[i].orde_iden_numb;
// 					var orde_sequ_numb = orderFlag[i].orde_sequ_numb;
// 					var orde_stat_flag = orderFlag[i].orde_stat_flag;
// 					var purc_iden_numb = orderFlag[i].purc_iden_numb;
// 					if('주문취소' == orde_stat_flag || '주문요청' == orde_stat_flag || '승인요청' == orde_stat_flag){
// 						result += "주문번호 : "+orde_iden_numb+"-"+orde_sequ_numb+"-"+purc_iden_numb+" 는 "+orde_stat_flag+" 상태 이므로 발주 접수를 할수없습니다. \n";
// 						cnt++;
// 					}else{
// 						count++;
// 					}
// 				}
// 				if(cnt > 0){
// 					alert(result);
// 				}else if(count > 0){
// 					alert("정상적으로 발주접수 처리가 되었습니다.");	
// 				}
// 				jq("#list").trigger("reloadGrid");
// 			}
//  			,"json"
// 		);
	}
}
// function processPurcReceive(){
// 	var orde_iden_numb_array = new Array(); 
// 	var purc_iden_numb_array = new Array();
// 	var rowCnt = jq("#list").getGridParam('reccount');
// 	if(rowCnt>0) {
// 		var arrRowIdx = 0 ;
// 		for(var i=0; i<rowCnt; i++) {
// 			var rowid = $("#list").getDataIDs()[i];
// 			if (jq("#isCheck_"+rowid).attr("checked")) {
// 			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
// 			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
// 			    purc_iden_numb_array[arrRowIdx] =	 selrowContent.purc_iden_numb; 
// 				arrRowIdx++;
// 			}
// 		}
// 		if (arrRowIdx == 0 ) {
// 			jq("#dialogSelectRow").dialog();
// 			return; 
// 		}
// 		if(!confirm("선택된 주문 정보를 발주접수 하시겠습니까?")) return;
// 		$.post(
<%-- 			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/updatePurcReceiveStatusTransGrid.sys", --%>
// 			{  orde_iden_numb_array:orde_iden_numb_array
// 			 , purc_iden_numb_array:purc_iden_numb_array
// 			}
// 			,function(arg){ 
// 				if(fnAjaxTransResult(arg)) {	
// 					alert("정상적으로 발주접수 처리가 되었습니다.");
// 					jq("#list").trigger("reloadGrid");
// 				}
// 			}
// 		);
// 	}
// }
function fnPurcReject(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
      			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
      			if("90" == selrowContent.orde_type_clas_code ||"50" == selrowContent.orde_type_clas_code){
      				alert("주문번호["+selrowContent.orde_iden_numb+"] 발주차수 ["+selrowContent.purc_iden_numb+"]의 주문유형을 확인바랍니다.");
      				return;
      			}
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
	}
// 	if(confirm("선택된 주문 정보를 발주거부 하시겠습니까?")){
      	fnStatChangeReasonDialog("processPurcReject");
// 	}
}
function processPurcReject(reason){
	if(!confirm("선택된 주문 정보를 발주거부 하시겠습니까?")){
		return;
	}
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	
	var vendorPhonenum_array = new Array(); //공급사 대표번호
	var orderUserMobile_array = new Array(); //인수자번호
	var vendorNm_array = new Array(); //공급사명
	
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
			    purc_iden_numb_array[arrRowIdx] = selrowContent.purc_iden_numb;
			    vendorPhonenum_array[arrRowIdx] = selrowContent.vendorPhonenum;
			    orderUserMobile_array[arrRowIdx] = selrowContent.orderUserMobile;
			    vendorNm_array[arrRowIdx] = selrowContent.vendornm;
				arrRowIdx++;
			}
		}
		
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{ orde_iden_numb_array:orde_iden_numb_array, purc_iden_numb_array:purc_iden_numb_array, orde_stat_flag:'40' },
			function(arg2){ 
				if(fnTransResult(arg2, false)) {	//성공시
					$.post(
						"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/updatePurcRejectStatusTransGrid.sys",
						{  orde_iden_numb_array:orde_iden_numb_array
						 , purc_iden_numb_array:purc_iden_numb_array
			    		 , reason:reason
			    		 , vendorPhonenum_array:vendorPhonenum_array
			    		 , orderUserMobile_array:orderUserMobile_array
			    		 , vendorNm_array:vendorNm_array
						},
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
	}
}
function processPurcReject_cancel(){}

/** 일괄 엑셀 다운로드 function*/
function fnAllExcelPrint(){
	var colLabels = ['주문일자', '납품요청일','발주의뢰일','주문유형', '주문번호', '발주차수', '상품명', '상품규격',  '발주수량', '배송처주소', '구매사', '주문자명', '인수자명', '인수자 연락처', '대표번호', '단가','발주 총금액' , '비고','주문명', '공급사명','공급사 대표번호','주문자 전화번호'];  	
	var colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 'CLIN_DATE', 'ORDE_TYPE_CLAS', 'ORDE_IDEN_NUMB', 'PURC_IDEN_NUMB', 'GOOD_NAME', 'GOOD_SPEC_DESC', 'PURC_REQU_QUAN', 'TRAN_DATA_ADDR', 'ORDE_CLIENT_NAME', 'ORDE_USER_NAME', 'TRAN_USER_NAME', 'TRAN_TELE_NUMB', 'PHONENUM', 'SALE_UNIT_PRIC','TOTAL_SALE_UNIT_PRIC','ADDE_TEXT_DESC','CONS_IDEN_NAME', 'VENDORNM','VENDORPHONENUM','ORDERUSERMOBILE'];
	var numColIds = ['PURC_REQU_QUAN','SALE_UNIT_PRIC','TOTAL_SALE_UNIT_PRIC'];	
	var figureColIds = ['PURC_IDEN_NUMB'];
	var sheetTitle = "발주접수";	
	var excelFileName = "allPurchaseList";	//file명
	
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcVendorId';
    fieldSearchParamArray[1] = 'srcPurcStartDate';
    fieldSearchParamArray[2] = 'srcPurcEndDate';
    fieldSearchParamArray[3] = 'srcOrdeIdenNumb';
    fieldSearchParamArray[4] = 'srcWorkInfoUser';
<%if(isAdm){%>
    fieldSearchParamArray[5] = 'srcOrdeStartDate';
    fieldSearchParamArray[6] = 'srcOrdeEndDate';
<%}%>
    
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/purchase/purcListExcel.sys",figureColIds);  
}
</script>
<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//발주접수
	header = "발주접수";
	manualPath = "/img/manual/vendor/purchaseList.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
		<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
						<tr valign="top" style="height: 29px">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td class='ptitle'>1.발주접수
<%							if(isVendor){ %>
								&nbsp;<span id="question" class="questionButton">도움말</span>
<%							}%>
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
					<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr> 
						<tr>
							<td class="table_td_subject" width="100">공급사</td>
							<td class="table_td_contents">
								<input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" style="width: 150px" />&nbsp;<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18"  style="vertical-align: middle; cursor: pointer;" /><input type="hidden" id="srcVendorId" name="srcVendorId" value=""/></td>
							<td width="100" class="table_td_subject">발주의뢰일자</td>
							<td class="table_td_contents">
								<input type="text" name="srcPurcStartDate" id="srcPurcStartDate" style="width: 75px;vertical-align: middle;" /> 
								~ 
								<input type="text" name="srcPurcEndDate" id="srcPurcEndDate" style="width: 75px;vertical-align: middle;" />
							</td>
							<td width="100" class="table_td_subject">주문번호</td>
							<td class="table_td_contents"><input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="" maxlength="50" style="width: 100px" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">주문유형</td>
							<td class="table_td_contents">
								<select id="srcOrdeTypeClas" name="srcOrdeTypeClas" class="select">
									<option value="">전체</option>
<%
	if (orderTypeCode.size() > 0 ) {
		CodesDto cdData = null;
		for (int i = 0; i < orderTypeCode.size(); i++) {
			cdData = orderTypeCode.get(i); 
%>
									<option value="<%=cdData.getCodeVal1()%>"><%=cdData.getCodeNm1()%></option>
<% }}%>
								</select>
							</td>
							<td width="100" class="table_td_subject">주문일자</td>
							<td class="table_td_contents">
								<input type="text" name="srcOrdeStartDate" id="srcOrdeStartDate" style="width: 75px;vertical-align: middle;" /> 
								~ 
								<input type="text" name="srcOrdeEndDate" id="srcOrdeEndDate" style="width: 75px;vertical-align: middle;" />
							</td>
<%if(isAdm){ %>
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
<%}%>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td height="5"></td></tr>
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<font color="red">*</font> 납품예정일은 반드시 입력 해 주십시오
							</td>
							<td align="right">
								<button class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' onclick="processPurcReceive();">
									발주접수
								</button>
								<%-- 
								<button class="btn btn-info btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' onclick="fnPurcReject();">
									발주거부
								</button>
								--%>
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