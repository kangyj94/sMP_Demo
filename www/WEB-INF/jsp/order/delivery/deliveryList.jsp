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
	String listHeight = "$(window).height()-255 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   
	@SuppressWarnings("unchecked")	// 주문유형
	List<CodesDto> orderTypeCode = (List<CodesDto>)request.getAttribute("orderTypeCode");
    
	@SuppressWarnings("unchecked")	// 배송유형  : "0:시스템코드;1:사용자정의코드"
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
    
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
    boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
    boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	// 날짜 세팅
	String srcPurcStartDate = CommonUtils.getCustomDay("MONTH", -1);
	String srcPurcEndDate = CommonUtils.getCurrentDate();
   
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
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcButton").click(function(){ 
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearch(); 
	});
	$("#allExcelButton").click(function(){ 
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcPurcStartDate").val($.trim($("#srcPurcStartDate").val()));
		$("#srcPurcEndDate").val($.trim($("#srcPurcEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearchExcelView(); 
	});
	
	// 날짜 세팅
	$("#srcPurcStartDate").val("<%=srcPurcStartDate%>");
	$("#srcPurcEndDate").val("<%=srcPurcEndDate%>");
	
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
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/deliveryListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'주문일자', '납품요청일','발주접수일','주문유형','고객유형', '주문번호', '발주차수', '상품명', '상품규격', '발주수량', '출하된수량', '출하할수량', '배송처주소', '구매사', '주문자명', '인수자명', '인수자 연락처', '단가','발주 총금액', '발주일','비고' ,'공사명','첨부1','첨부2','첨부3', '공급사명', 'vendorId', 'branchId','disp_good_id' , 'good_iden_numb', 'path1', 'path2', 'path3','good_st_spec_desc'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter,frozen:true},
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'purc_rece_date',index:'purc_rece_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'orde_type_clas',index:'orde_type_clas', width:50,align:"center",search:false,sortable:true, editable:false },
			{name:'worknm',index:'worknm', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'purc_iden_numb',index:'purc_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'good_spec_desc',index:'good_spec_desc', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'purc_requ_quan',index:'purc_requ_quan', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'deli_prod_quan',index:'deli_prod_quan', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'to_do_deli_prod_quan',index:'to_do_deli_prod_quan', width:80,align:"right",search:false,sortable:true, editable:true,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },				
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
							var inputValue = Number(this.value); 											// 입력수량
							var selrowContent = jq("#list").jqGrid('getRowData',rowid);
							var purc_requ_quan = selrowContent.purc_requ_quan;
							var deli_prod_quan = selrowContent.deli_prod_quan;
							var to_do_deli_prod_quan = Number(purc_requ_quan) - Number(deli_prod_quan);
							if(to_do_deli_prod_quan < inputValue){
								alert("출하 할 수량은 "+to_do_deli_prod_quan+" 이상 입력할 수 없습니다.");
								jq("#list").restoreRow(rowid);
								jq("#list").jqGrid('setRowData', rowid, {to_do_deli_prod_quan:to_do_deli_prod_quan});
								jq('#list').editRow(rowid);
								return;
							}
							jq("#list").restoreRow(rowid);
							jq("#list").jqGrid('setRowData', rowid, {to_do_deli_prod_quan:inputValue});
							jq('#list').editRow(rowid);
						}
					}]
				}
			},
			{name:'tran_data_addr',index:'tran_data_addr', width:220,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_client_name',index:'orde_client_name', width:200,align:"left",search:false,sortable:true, editable:false },//구매사명
			{name:'orde_user_name',index:'orde_user_name', width:50,align:"left",search:false,sortable:true, editable:false },
			{name:'tran_user_name',index:'tran_user_name', width:50,align:"rigth",search:false,sortable:true, editable:false },
			{name:'tran_tele_numb',index:'tran_tele_numb', width:90,align:"rigth",search:false,sortable:true, editable:false },
			{name:'sale_unit_pric',index:'sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//단가
			{name:'total_sale_unit_pric',index:'total_sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//금액
			{name:'clin_date',index:'clin_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'adde_text_desc',index:'adde_text_desc', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'cons_iden_name',index:'cons_iden_name', width:170,align:"left",hidden:false, search:false,sortable:true, editable:false },//공사명
			{name:'attach_file_name1',index:'attach_file_name1', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'attach_file_name2',index:'attach_file_name2', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'attach_file_name3',index:'attach_file_name3', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'vendornm',index:'vendornm', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'vendorId',index:'vendorId',hidden:true},//공급사ID
			{name:'branchId',index:'branchId',hidden:true},//구매사ID
			{name:'disp_good_id',index:'disp_good_id', hidden:true},
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true},
			{name:'attach_file_path1',index:'attach_file_path1', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path2',index:'attach_file_path2', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path3',index:'attach_file_path3', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_st_spec_desc',index:'good_st_spec_desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true }//표준규격
		],  
		postData: {
			srcVendorId:$('#srcVendorId').val(),
			srcPurcStartDate:$('#srcPurcStartDate').val(),
			srcPurcEndDate:$('#srcPurcEndDate').val()
<%	if(isAdm){ 	%>
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
<%	}	%>
		},multiselect:false ,
		rowNum:30, rownumbers: false, rowList:[30,50], pager: '#pager',
		sortname: 'regi_date_time', sortorder: "desc",
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		caption:"출하", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					var purc_requ_quan = selrowContent.purc_requ_quan;
					var deli_prod_quan = selrowContent.deli_prod_quan;
					var to_do_deli_prod_quan = Number(purc_requ_quan) - Number(deli_prod_quan);
					jq('#list').editRow(rowid);  
				}
			}
		},
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
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
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
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
            if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%}else if(isAdm){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
			if(colName != undefined &&colName['index']=="orde_client_name") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchId);")%> 
			}
			if(colName != undefined &&colName['index']=="vendornm") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorId);")%> 
			}
<%} %>
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
	jQuery("#list").jqGrid('setFrozenColumns');
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function checkBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;

	if($("#chkAllOutputField").prop("checked") == true){
		$("#chkAllOutputField").prop("checked",false);
	}else{
		$("#chkAllOutputField").prop("checked",true);
	}
	
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
	var checkBox = "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' style='border: 0' offval='no' onclick=\"fnIsChecked('"+options.rowId+"')\" />";
	var purc_requ_quan = rowObject.purc_requ_quan;
	var deli_prod_quan = rowObject.deli_prod_quan;
	var to_do_deli_prod_quan = Number(purc_requ_quan) - Number(deli_prod_quan);
	if(0 == to_do_deli_prod_quan){
      	checkBox = "";
	}
	return checkBox;
}

function fnIsChecked(rowid){
	if($("#isCheck_" + rowid ).prop("checked") == true){
		$("#isCheck_" + rowid ).prop("checked",false);
	}else{
		$("#isCheck_" + rowid ).prop("checked",true);
	}
}

function fnSearch(){
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorId= $("#srcVendorId").val();
	data.srcPurcStartDate= $("#srcPurcStartDate").val();
	data.srcPurcEndDate= $("#srcPurcEndDate").val();
	data.srcOrdeIdenNumb= $("#srcOrdeIdenNumb").val();
	data.srcOrdeTypeClas= $("#srcOrdeTypeClas").val();
	data.srcWorkInfoUser = $("#srcWorkInfoUser").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
/** list Excel Export */
function exportExcel() {
	
	var colLabels =['주문일자', '납품요청일','발주접수일','주문유형', '주문번호', '발주차수', '상품명', '상품규격', '발주수량', '출하된수량',  '배송처주소', '구매사', '주문자명', '인수자명', '인수자 연락처', '단가','발주 총금액', '발주일','비고','공사명', '첨부1','첨부2','첨부3', '공급사명'];
	var colIds = ['regi_date_time', 'requ_deli_date', 'purc_rece_date', 'orde_type_clas', 'orde_iden_numb', 'purc_iden_numb', 'good_name', 'good_spec_desc', 'purc_requ_quan', 'deli_prod_quan',  'tran_data_addr', 'orde_client_name', 'orde_user_name', 'tran_user_name', 'tran_tele_numb', 'sale_unit_pric', 'total_sale_unit_pric', 'clin_date','adde_text_desc' ,'cons_iden_name','attach_file_name1', 'attach_file_name2', 'attach_file_name3', 'vendornm'];
	var numColIds = ['purc_requ_quan','deli_prod_quan','sale_unit_pric','total_sale_unit_pric'];
	var figureColIds = ['purc_iden_numb'];
	var sheetTitle = "출하_인수증출력";	
	var excelFileName = "deliveryList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function forEditGrid(){
	var rowCnt = jq("#list").getGridParam('reccount');
	for(var i=0; i<rowCnt; i++) {
		var rowid = $("#list").getDataIDs()[i];
		if (jq("#isCheck_"+rowid).attr("checked")) {
			jQuery('#list').jqGrid('editRow',rowid,true);
		}
	}
}

function processDelivery(){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var to_do_deli_prod_quan_array = new Array();
	var vendorIdArray = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
				jq("#list").restoreRow(rowid);
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
			    purc_iden_numb_array[arrRowIdx] =	 selrowContent.purc_iden_numb; 
         		if("" == $.trim(selrowContent.to_do_deli_prod_quan)){
         			alert("주문번호["+selrowContent.orde_iden_numb+"] , 발주차수["+selrowContent.purc_iden_numb+"] 의 출하할수량을 입력해주십시오.");
         			forEditGrid();
         			return;
         		}
			    to_do_deli_prod_quan_array[arrRowIdx] =	 selrowContent.to_do_deli_prod_quan; 
			    vendorIdArray[arrRowIdx] =	 selrowContent.vendorId; 
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
      		for(var i=0; i<rowCnt; i++) {
      			var rowid = $("#list").getDataIDs()[i];
      			jq("#list").editRow(rowid);
      		}
			return; 
		}
		if(!confirm("선택된 주문 정보를 출하처리 하시겠습니까?")){
      		for(var i=0; i<rowCnt; i++) {
      			var rowid = $("#list").getDataIDs()[i];
      			jq("#list").editRow(rowid);
      		}
			return; 
		}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{ orde_iden_numb_array:orde_iden_numb_array, purc_iden_numb_array:purc_iden_numb_array, prod_quan_array:to_do_deli_prod_quan_array, orde_stat_flag:'50' },
			function(arg){ 
				if(fnTransResult(arg, false)) {	//성공시
					$.post(
						"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/insertDeliveryTransGrid.sys",
						{  orde_iden_numb_array:orde_iden_numb_array
						 , purc_iden_numb_array:purc_iden_numb_array
						 , to_do_deli_prod_quan_array:to_do_deli_prod_quan_array
						 , vendorIdArray:vendorIdArray
						},
						function(arg2){
			            	var result = eval('(' + arg2 + ')').customResponse;
			            	if (result.success == false) {
			                  	var errors = "";
			            		for (var i = 0; i < result.message.length; i++) {
			            			errors +=  result.message[i] + "<br/>";
			            		}
			            		alert(errors);
			            	} else {
			            		var successMassage = "";
			            		for (var i = 0; i < result.message.length; i++) {
			            			successMassage +=  result.message[i];
			            		}
			            		var trim_successMassage = $.trim(successMassage);
			                  	if(trim_successMassage !=''){
			                      	if(trim_successMassage.length == 1){
			                      		fnOpen(trim_successMassage,0);
			                      	}else{
			                      		var receiptNumArry = 	trim_successMassage.split(",");
			                      		for(var k = 0 ; k < receiptNumArry.length; k++){
			                          		fnOpen(receiptNumArry[k],k);
			                      		}
			                      	}
			                  	}
			            	}
			            	jq("#list").trigger("reloadGrid");
						}
					);
				} else {
					jq("#list").trigger("reloadGrid");
				}
			}
		);

// 		$.post(
<%-- 			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/insertDeliveryTransGrid.sys", --%>
// 			{  orde_iden_numb_array:orde_iden_numb_array
// 			 , purc_iden_numb_array:purc_iden_numb_array
// 			 , to_do_deli_prod_quan_array:to_do_deli_prod_quan_array
// 			 , vendorIdArray:vendorIdArray
// 			}
// 			,function(arg){ 
//             	var result = eval('(' + arg + ')').customResponse;
//             	if (result.success == false) {
//                   	var errors = "";
//             		for (var i = 0; i < result.message.length; i++) {
//             			errors +=  result.message[i] + "<br/>";
//             		}
//             		alert(errors);
//             	} else {
//             		var successMassage = "";
//             		for (var i = 0; i < result.message.length; i++) {
//             			successMassage +=  result.message[i];
//             		}
//             		var trim_successMassage = $.trim(successMassage);
//                   	if(trim_successMassage !=''){
//                       	if(trim_successMassage.length == 1){
//                       		fnOpen(trim_successMassage,0);
//                       	}else{
//                       		var receiptNumArry = 	trim_successMassage.split(",");
//                       		for(var k = 0 ; k < receiptNumArry.length; k++){
//                           		fnOpen(receiptNumArry[k],k);
//                       		}
//                       	}
//                   	}
// 					jq("#list").trigger("reloadGrid");
//             	}
// 			}
// 		);
	}
}
function fnDeliReject(){
	var rowCnt = jq("#list").getGridParam('reccount');
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
      			var deli_prod_quan = selrowContent.deli_prod_quan;
      			var orde_iden_numb = selrowContent.orde_iden_numb;
      			var purc_iden_numb= selrowContent.purc_iden_numb;
      			orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
			    purc_iden_numb_array[arrRowIdx] = selrowContent.purc_iden_numb; 
      			if(deli_prod_quan > 0){
      				alert("이미 출하된 수량이 있는 주문번호 ["+orde_iden_numb+"] 발주차수 ["+purc_iden_numb+"] 는 발주접수상태로 변경이 불가합니다.");
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
	if(confirm("선택된 주문 정보를 발주접수상태로 변경하시겠습니까?")){
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{ orde_iden_numb_array:orde_iden_numb_array, purc_iden_numb_array:purc_iden_numb_array, orde_stat_flag:'50' },
			function(arg){
				if(fnTransResult(arg, false)) {	//성공시
					fnStatChangeReasonDialog("processDeliReject");
				} else {
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
function processDeliReject(reason){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
			    purc_iden_numb_array[arrRowIdx] =	 selrowContent.purc_iden_numb; 
				arrRowIdx++;
			}
		}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/updatePurcStatusTransGrid.sys",
			{  orde_iden_numb_array:orde_iden_numb_array
			 , purc_iden_numb_array:purc_iden_numb_array
    		 , reason:reason
			}
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {
// 					alert("정상적으로 발주접수상태로 변경되었습니다.");
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
function processDeliReject_cancel(){}
function fnSearchExcelView(){
	var colLabels =['주문일자', '납품요청일','발주접수일','주문유형', '주문번호', '발주차수', '상품명', '상품규격', '발주수량', '출하된수량',  '배송처주소', '구매사', '주문자명', '인수자명', '인수자 연락처', '단가','발주 총금액', '발주일','비고','공사명', '첨부1','첨부2','첨부3', '공급사명'];
	var colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 'PURC_RECE_DATE', 'ORDE_TYPE_CLAS', 'ORDE_IDEN_NUMB', 'PURC_IDEN_NUMB', 'GOOD_NAME', 'GOOD_SPEC_DESC', 'PURC_REQU_QUAN', 'DELI_PROD_QUAN',  'TRAN_DATA_ADDR', 'ORDE_CLIENT_NAME', 'ORDE_USER_NAME', 'TRAN_USER_NAME', 'TRAN_TELE_NUMB', 'SALE_UNIT_PRIC', 'TOTAL_SALE_UNIT_PRIC', 'CLIN_DATE','ADDE_TEXT_DESC' ,'CONS_IDEN_NAME','ATTACH_FILE_NAME1', 'ATTACH_FILE_NAME2', 'ATTACH_FILE_NAME3', 'VENDORNM'];
	var numColIds = ['PURC_REQU_QUAN','DELI_PROD_QUAN','SALE_UNIT_PRIC','TOTAL_SALE_UNIT_PRIC'];	
	var figureColIds = ['PURC_IDEN_NUMB'];
	var sheetTitle = "출하_인수증출력";	
	var excelFileName = "allDeliveryList";	//file명
	
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcVendorId';
    fieldSearchParamArray[1] = 'srcPurcStartDate';
    fieldSearchParamArray[2] = 'srcPurcEndDate';
    fieldSearchParamArray[3] = 'srcOrdeIdenNumb';
    fieldSearchParamArray[4] = 'srcWorkInfoUser';
    
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/delivery/deliveryListExcelView.sys", figureColIds);  
}
</script>
<%-- 인수증 출력 관련 스크립트 시작 --%>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script language="JavaScript">
function fnOpen(receiptNum, i) {
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
<%-- 인수증 출력 관련 스크립트 끝 --%>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { manageManual(); });	//메뉴얼호출
});

function manageManual(){
	var header = "";
	var manualPath = "";
	//출하/인수증출력
	header = "출하/인수증출력";
	manualPath = "/img/manual/vendor/deliveryList.jpg";

	var popUrl = "/manage/manageManual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=950, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//출하/인수증충력
	header = "출하/인수증충력";
	manualPath = "/img/manual/vendor/deliveryList.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<body>
<form id="frm" name="frm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="29" class='ptitle'>2.출하/인수증출력
							<%if(isVendor){ %>
								&nbsp;<span id="question" class="questionButton">도움말</span>
							<%} %>
							</td>
							<td align="right" class='ptitle'>
								<img id="allExcelButton" src="/img/system/btn_type3_orderResultExcel.gif" width="130" height="22" style="cursor:pointer;"/>
								<img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style="cursor: pointer;"/>
							</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
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
							<td class="table_td_subject" width="100">공급사</td>
							<td class="table_td_contents">
								<input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" style="width: 150px" />&nbsp;<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18"  style="vertical-align: middle; cursor: pointer;" /><input type="hidden" id="srcVendorId" name="srcVendorId" value=""/></td>
							<td width="100" class="table_td_subject">발주접수일자</td>
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
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
            <tr><td height="10"></td></tr>
			<tr>
				<td align="right"> 
                    <a href="javascript:processDelivery();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_consignment.gif" width="75" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
                    <a href="javascript:fnDeliReject();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderChange.gif" width="133" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
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