<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-255 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   
	@SuppressWarnings("unchecked")	// 주문유형
	List<CodesDto> orderTypeCode = (List<CodesDto>)request.getAttribute("orderTypeCode");
   
	@SuppressWarnings("unchecked")	// 주문상태
	List<CodesDto> orderStatFlag = (List<CodesDto>)request.getAttribute("orderStatFlag");
    
	@SuppressWarnings("unchecked")	// 배송유형  : "0:시스템코드;1:사용자정의코드"
	List<CodesDto> deliveryType = (List<CodesDto>)request.getAttribute("deliveryType");
    String selBoxDeliType = "0:선택";
	if (deliveryType.size() > 0 ) {
		CodesDto cdData = null;
		for (int i = 0; i < deliveryType.size(); i++) {
			cdData = deliveryType.get(i); 
            selBoxDeliType += ";"+cdData.getCodeVal1()+":"+cdData.getCodeNm1(); 
		}
	}
 
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
    boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
    boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	// 날짜 세팅
	String srcDeliStartDate = CommonUtils.getCustomDay("MONTH", -1);
	String srcDeliEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcUserNm").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	$("#allExcelButton").click(function(){ 
		$("#srcVendorName").val($.trim($("#srcVendorName").val()));
		$("#srcDeliStartDate").val($.trim($("#srcDeliStartDate").val()));
		$("#srcDeliEndDate").val($.trim($("#srcDeliEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		fnSearchDeliComplExcelView(); 
	});
	
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcButton").click(function(){ 
		$("#srcVendorName").val($.trim($("#srcVendorName").val()));
		$("#srcDeliStartDate").val($.trim($("#srcDeliStartDate").val()));
		$("#srcDeliEndDate").val($.trim($("#srcDeliEndDate").val()));
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		fnSearch(); 
	});
	
	// 날짜 세팅
	$("#srcDeliStartDate").val("<%=srcDeliStartDate%>");
	$("#srcDeliEndDate").val("<%=srcDeliEndDate%>");
	$("#srcIsDelivery").val("0");
	
   // 날짜 조회 및 스타일
   $(function(){
   	$("#srcDeliStartDate").datepicker(
          	{
   	   		showOn: "button",
   	   		buttonImage: "/img/system/btn_icon_calendar.gif",
   	   		buttonImageOnly: true,
   	   		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("#srcDeliEndDate").datepicker(
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


$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/deliCompleteListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'주문일자','납품요청일','주문유형', '주문번호', '발주차수', '납품차수', '인수증번호', '상품명', '상품규격', '배송상태',   '출하일','발주수량', '출하수량', '배송유형', '송장(전화)번호', '배송처주소', '주문상태','고객사', '주문자', '인수자', '발주일', '첨부1','첨부2','첨부3', '인수완료일시', '공급사', 'disp_good_id', 'good_iden_numb','vendorId', 'tempDeliType', 'tempInvoNumb', 'deli_type_clas_code', 'path1', 'path2', 'path3','good_st_spec_desc'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false },
			{name:'regi_date_time',index:'regi_date_time', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'orde_type_clas',index:'orde_type_clas', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'purc_iden_numb',index:'purc_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'deli_iden_numb',index:'deli_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'receipt_num',index:'receipt_num', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'good_spec_desc',index:'good_spec_desc', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'isdelivery',index:'isdelivery', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'deli_degr_date',index:'deli_degr_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'purc_requ_quan',index:'purc_requ_quan', width:70,align:"right",search:false,sortable:true, editable:false,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },
			{name:'deli_prod_quan',index:'deli_prod_quan', width:70,align:"right",search:false,sortable:true, editable:false,sorttype:'integer',formatter:'integer',
					formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },
			{name:'deli_type_clas',index:'deli_type_clas', width:130,align:"center",search:false,sortable:true, editable:true
						, edittype:"select",formatter:"select",
				editoptions:{
					value:"<%=selBoxDeliType%>",
					dataEvents:[{
						type:'change',
      					fn:function(e){
      						var rowid = (this.id).split("_")[0];
      						var inputValue = this.value; // 선택값
      						jq("#list").jqGrid('setRowData', rowid, {tempDeliType:$.trim(inputValue)});
      					}
      				}]
				}
			},
			{name:'deli_invo_iden',index:'deli_invo_iden', width:110,align:"left",search:false,sortable:true, editable:true,
				editoptions:{
					maxlength:15,
					dataInit:function(elem){
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "left");
						$(elem).keyup(function(){
                            var val1 = elem.value;
                            var num = new Number(val1);
                            
                            var rowid = (this.id).split("_")[0];
	                        var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	                        if(selrowContent.tempDeliType != "ETC" && selrowContent.tempDeliType != "BUS" && selrowContent.tempDeliType != "TRAIN"){
	                            if(isNaN(num)) {
	                            	alert("숫자만 입력해 주십시오.");
	                            	elem.value = "";
	                            }
	                        }
                            
                            fnOnlyNumberInert(elem.id,elem.value);
                        });
					},	
					dataEvents:[{
						type:'change',
      					fn:function(e){
//       						var rowid = (this.id).split("_")[0];
//       						var inputValue = this.value; 
//       						jq("#list").jqGrid('setRowData', rowid, {tempInvoNumb:$.trim(inputValue)});
      					}
      				}]
				}
			},
			{name:'tran_data_addr',index:'tran_data_addr', width:250,align:"left",search:false,sortable:true, editable:false },
			{name:'deli_stat_flag',index:'deli_stat_flag', width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'orde_client_name',index:'orde_client_name', width:200,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_user_name',index:'orde_user_name', width:70,align:"left",search:false,sortable:true, editable:false },
			{name:'tran_user_name',index:'tran_user_name', width:70,align:"left",search:false,sortable:true, editable:false },
			{name:'clin_date',index:'clin_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'attach_file_name1',index:'attach_file_name1', width:60,align:"rigth",search:false,sortable:true, editable:false },
			{name:'attach_file_name2',index:'attach_file_name2', width:60,align:"rigth",search:false,sortable:true, editable:false },
			{name:'attach_file_name3',index:'attach_file_name3', width:60,align:"rigth",search:false,sortable:true, editable:false },
			{name:'purc_proc_date',index:'purc_proc_date', width:120,align:"center",search:false,sortable:true, editable:false },
			{name:'vendornm',index:'vendornm', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorId',index:'vendorId', hidden:true, search:false,sortable:true, editable:false },
			{name:'tempDeliType',index:'tempDeliType', hidden:true, search:false,sortable:true, editable:false },
			{name:'tempInvoNumb',index:'tempInvoNumb', hidden:true, search:false,sortable:true, editable:false },
			{name:'deli_type_clas_code',index:'deli_type_clas_code', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path1',index:'attach_file_path1', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path2',index:'attach_file_path2', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path3',index:'attach_file_path3', hidden:true, search:false,sortable:true, editable:false },
            {name:'good_st_spec_desc',index:'good_st_spec_desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true}
		],
		postData: {
			srcDeliStartDate:$('#srcDeliStartDate').val(),
			srcDeliEndDate:$('#srcDeliEndDate').val(),
			srcIsDelivery:$('#srcIsDelivery').val(),
			srcCenFlag:"true"
		},multiselect:false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		sortname: 'regi_date_time', sortorder: "desc",
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		caption:"배송완료", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
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
            var rowCnt = jq("#list").getGridParam('reccount');
            for(var idx=0; idx<rowCnt; idx++) {
                var rowid = $("#list").getDataIDs()[idx];
                jq("#list").restoreRow(rowid);
            	var checkBox = "<input id='isCheck_"+rowid+"' name='isCheck_"+rowid+"' type='checkbox' style='border: 0' offval='no' />";
				jQuery('#list').jqGrid('setRowData',rowid,{isCheck:checkBox});
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(selrowContent.deli_type_clas == ""){
					jq('#list').editRow(rowid);
				}
            }
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
        afterInsertRow: function(rowid, aData){
     		jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
     		jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'});  
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
            if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){
         		jq("#list").setCell(rowid,'deli_invo_iden','',{color:'#0000ff'});
         		jq("#list").setCell(rowid,'deli_invo_iden','',{cursor: 'pointer'});  
            }
            if(selrowContent.orde_type_clas == '선정산'){
         		jq("#list").setCell(rowid,'deli_degr_date','',{color:'#0000ff'});
         		jq("#list").setCell(rowid,'deli_degr_date','',{cursor: 'pointer'});  
            }
     		jq("#list").setCell(rowid,'attach_file_name1','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'attach_file_name2','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'attach_file_name3','',{color:'#0000ff'});
     		
			if($.trim(selrowContent.attach_file_name1) != '') {
         		jq("#list").setCell(rowid,'attach_file_name1','',{cursor: 'pointer'});  
			}
			if($.trim(selrowContent.attach_file_name2) != '') {
         		jq("#list").setCell(rowid,'attach_file_name2','',{cursor: 'pointer'});  
			}
			if($.trim(selrowContent.attach_file_name3) != '') {
         		jq("#list").setCell(rowid,'attach_file_name3','',{cursor: 'pointer'});  
			}
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
			if(colName != undefined &&colName['index']=="attach_file_name1" && $.trim(selrowContent.attach_file_name1) != '') {fnAttachFileDownload(selrowContent.attach_file_path1);}
			if(colName != undefined &&colName['index']=="attach_file_name2" && $.trim(selrowContent.attach_file_name2) != '') {fnAttachFileDownload(selrowContent.attach_file_path2);}
			if(colName != undefined &&colName['index']=="attach_file_name3" && $.trim(selrowContent.attach_file_name3) != '') {fnAttachFileDownload(selrowContent.attach_file_path3);}
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.disp_good_id);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%}else if(isAdm){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%} %>
			if(colName != undefined &&colName['index']=="deli_invo_iden") { 
				if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){
					fnSearchDeliPopup(selrowContent.deli_type_clas_code, selrowContent.deli_invo_iden);
				}
			}
			if(colName != undefined &&colName['index']=="deli_degr_date") { 
                if(selrowContent.orde_type_clas == '선정산'){
					fnShowDeliHist(selrowContent.orde_iden_numb, selrowContent.purc_iden_numb, selrowContent.deli_iden_numb);
				}
			}
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
function fnOnlyNumberInert(str1,str2){
	var rowid = str1.split("_")[0];
	var inputValue = str2;  //this.value; 
// 	alert("str1 : "+str1+"\nrowid : "+rowid+"\nvalue : "+inputValue);
	jq("#list").jqGrid('setRowData', rowid, {tempInvoNumb:$.trim(inputValue)});
}
function fnSearch(){
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcDeliStartDate= $("#srcDeliStartDate").val();
	data.srcPurcEndDate= $("#srcDeliEndDate").val();
	data.srcOrdeIdenNumb= $("#srcOrdeIdenNumb").val();
	data.srcOrdeTypeClas= $("#srcOrdeTypeClas").val();
	data.srcDeliStatFlag= $("#srcDeliStatFlag").val();
	data.srcIsDelivery= $("#srcIsDelivery").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
function deliCompleteProcess(){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var deli_iden_numb_array = new Array();
	
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			jq("#list").restoreRow(rowid);
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
			    purc_iden_numb_array[arrRowIdx] =	 selrowContent.purc_iden_numb; 
			    deli_iden_numb_array[arrRowIdx] =	 selrowContent.deli_iden_numb; 
				if(selrowContent.deli_type_clas == ""){
					alert("송장(전화)번호를 저장후 배송완료 처리를 할 수 있습니다.");
					jQuery('#list').jqGrid('editRow',rowid,true);
					return;
				}
         		if("미배송" != selrowContent.isdelivery){
         			alert("선택한 주문의 배송상태를 확인해주십시오.");
					jQuery('#list').jqGrid('editRow',rowid,true);
         			return;
         		}
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
		if(!confirm("선택된 주문 정보를 배송완료처리 하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/updateIsDeliveryTransGrid.sys",
			{  orde_iden_numb_array:orde_iden_numb_array
			 , purc_iden_numb_array:purc_iden_numb_array
			 , deli_iden_numb_array:deli_iden_numb_array
			}
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {	
					alert("정상적으로 배송완료 처리가 되었습니다.");
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
/**
 * list Excel Export
 */
function exportExcel() {
		
	var colLabels = ['주문일자','납품요청일','주문유형', '주문번호', '발주차수', '납품차수', '인수증번호', '상품명', '상품규격', '배송상태',   '출하일','발주수량', '출하수량', '배송유형', '송장(전화)번호', '배송처주소', '주문상태','고객사', '주문자', '인수자', '발주일', '첨부1','첨부2','첨부3', '인수완료일시', '공급사'];
	var colIds = ['regi_date_time', 'requ_deli_date', 'orde_type_clas', 'orde_iden_numb', 'purc_iden_numb', 'deli_iden_numb', 'receipt_num', 'good_name', 'good_spec_desc', 'isdelivery', 'deli_degr_date', 'purc_requ_quan', 'deli_prod_quan', 'deli_type_clas', 'deli_invo_iden', 'tran_data_addr', 'deli_stat_flag','orde_client_name', 'orde_user_name', 'tran_user_name',  'clin_date', 'attach_file_name1', 'attach_file_name2', 'attach_file_name3', 'purc_proc_date', 'vendornm'];
	var numColIds = ['purc_requ_quan','deli_prod_quan'];	//숫자표현ID
	var sheetTitle = "배송완료";	//sheet 타이틀
	var excelFileName = "DeliveryComplete";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function fnSearchDeliComplExcelView(){
	var colLabels = ['주문일자','납품요청일','주문유형', '주문번호', '발주차수', '납품차수', '인수증번호', '상품명', '상품규격', '배송상태',   '출하일','발주수량', '출하수량', '배송유형', '송장(전화)번호', '배송처주소', '주문상태','고객사', '주문자', '인수자', '발주일', '첨부1','첨부2','첨부3', '인수완료일시', '공급사'];
	var colIds = ['REGI_DATE_TIME', 'REQU_DELI_DATE', 'ORDE_TYPE_CLAS', 'ORDE_IDEN_NUMB', 'PURC_IDEN_NUMB', 'DELI_IDEN_NUMB', 'RECEIPT_NUM', 'GOOD_NAME', 'GOOD_SPEC_DESC', 'ISDELIVERY', 'DELI_DEGR_DATE', 'PURC_REQU_QUAN', 'DELI_PROD_QUAN', 'DELI_TYPE_CLAS', 'DELI_INVO_IDEN', 'TRAN_DATA_ADDR', 'DELI_STAT_FLAG','ORDE_CLIENT_NAME', 'ORDE_USER_NAME', 'TRAN_USER_NAME',  'CLIN_DATE', 'ATTACH_FILE_NAME1', 'ATTACH_FILE_NAME2', 'ATTACH_FILE_NAME3', 'PURC_PROC_DATE', 'VENDORNM'];
	var numColIds = ['PURC_REQU_QUAN','DELI_PROD_QUAN'];	//숫자표현id
	var sheetTitle = "배송완료";	//sheet 타이틀
	var excelFileName = "DeliveryComplete";	//file명
	
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcDeliStartDate';
    fieldSearchParamArray[1] = 'srcPurcEndDate';
    fieldSearchParamArray[2] = 'srcDeliEndDate';
    fieldSearchParamArray[3] = 'srcOrdeTypeClas';
    fieldSearchParamArray[4] = 'srcDeliStatFlag';
    fieldSearchParamArray[5] = 'srcIsDelivery';
    fieldSearchParamArray[6] = 'srcCenFlag';
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/delivery/deliCompleteListExcelView.sys");  
}
function openReceipt(){
	var receipt_num_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			jq("#list").restoreRow(rowid);
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    receipt_num_array[arrRowIdx] =	 selrowContent.receipt_num; 
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {   
			jq("#dialogSelectRow").dialog();
			return; 
		}
		for(var i = 0 ; i < receipt_num_array.length ; i++){
			openReceiptPrint(receipt_num_array[i],i);
		}
	}
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
                	window.open(deliWebAddr,'택배사조회', 'width=700, height='+scrSizeHeight+"resizable=yes,menubar=no,status=no,scrollbars=yes");
                	chkCnt++;
            	}
            }   
            if(chkCnt == 0){
            	alert("일치하는 택배사가 없습니다.");
            }
        }
	);
}

function fnShowDeliHist(str1, str2, str3){
  	var popurl = "/order/delivery/deliShowHistPop.sys?orde_iden_numb="+str1+"&purc_iden_numb="+str2+"&deli_iden_numb="+str3;
  	var popproperty = "dialogWidth:550px;dialogHeight=500px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);
    window.open(popurl, 'okplazaPop', 'width=550, height=500, scrollbars=yes, status=no, resizable=no');
}

function saveDeilInvoNumb(){
	if(!confirm("선택한 정보들의 송장정보를 저장하시겠습니까?")){
		return;
	}
	var rowCnt = jq("#list").getGridParam('reccount');
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var deli_iden_numb_array = new Array();
	var deli_type_clas_array = new Array();
	var deli_invo_iden_array = new Array();
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(selrowContent.deli_type_clas != ""){
      				alert("주문번호 ["+selrowContent.orde_iden_numb+"] 발주차수 ["+selrowContent.purc_iden_numb+"] 납품차수 ["+selrowContent.deli_iden_numb+"]의 송장정보가 이미 저장되어있습니다.");
      				return;
      			}
				if(selrowContent.tempDeliType == "" || selrowContent.tempDeliType == "0"){
      				alert("배송유형을 선택해주십시오.");
      				return;
      			}
				if($.trim(selrowContent.tempInvoNumb) == ""){
      				alert("송장번호를 입력하여주십시오.");
      				return;
      			}
			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
			    purc_iden_numb_array[arrRowIdx] =	 selrowContent.purc_iden_numb; 
			    deli_iden_numb_array[arrRowIdx] =	selrowContent.deli_iden_numb; 
			    deli_type_clas_array[arrRowIdx] =	 selrowContent.tempDeliType; 
			    deli_invo_iden_array[arrRowIdx] = selrowContent.tempInvoNumb; 
				arrRowIdx++;
			}
		}
    	if (arrRowIdx == 0 ) {
    		jq("#dialogSelectRow").dialog();
    		return; 
    	}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/setDeliInfoTransGrid.sys",
			{  orde_iden_numb_array:orde_iden_numb_array
			 , purc_iden_numb_array:purc_iden_numb_array
			 , deli_iden_numb_array:deli_iden_numb_array
			 , deli_type_clas_array:deli_type_clas_array
			 , deli_invo_iden_array:deli_invo_iden_array
			}
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {	
					alert("정상적으로 저장되었습니다.");
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}
</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>

</head>
<body>
<form id="frm" name="frm">
<input type="hidden" id="srcCenFlag" name="srcCenFlag" value="true"/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="29" class='ptitle'>송장입력/배송완료</td>
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
							<td width="100" class="table_td_subject">출하일자</td>
							<td class="table_td_contents">
                              <input type="text" name="srcDeliStartDate" id="srcDeliStartDate" style="width: 75px;vertical-align: middle;" /> 
                              ~ 
                              <input type="text" name="srcDeliEndDate" id="srcDeliEndDate" style="width: 75px;vertical-align: middle;" />
							</td>
							<td width="100" class="table_td_subject">주문번호</td>
							<td class="table_td_contents"><input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="" maxlength="20" style="width: 100px" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td width="100" class="table_td_subject">주문상태</td>
							<td class="table_td_contents">
      							<select id="srcDeliStatFlag" name="srcDeliStatFlag" class="select">
                                    <option value="">전체</option>
<%
	if (orderStatFlag.size() > 0 ) {
		CodesDto cdData = null;
		for (int i = 0; i < orderStatFlag.size(); i++) {
			cdData = orderStatFlag.get(i); 
            if(cdData.getCodeVal1().equals("60") || cdData.getCodeVal1().equals("69")|| cdData.getCodeVal1().equals("70")|| cdData.getCodeVal1().equals("80")){ %>
                                    <option value="<%=cdData.getCodeVal1()%>"><%=cdData.getCodeNm1()%></option>
<% } } } %>                                   
      							</select>
                            </td>
							<td width="100" class="table_td_subject">배송상태</td>
							<td colspan="2" class="table_td_contents">
                              <select id="srcIsDelivery" name="srcIsDelivery" class="select">
                                    <option value="">전체</option>
                                    <option value="0">미배송</option>
                                    <option value="1">배송</option>
      						  </select>
                            </td>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr style="height: 10px"> <td></td> </tr>
			<tr>
				<td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>* 배송완료는 배송유형과 송장번호가 입력되어 있어야 합니다.</td>
                            <td align="right">
                                <a href="javascript:saveDeilInvoNumb();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_invo_save.jpg" width="75" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
                                <a href="javascript:deliCompleteProcess();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_deliveryOk.gif" width="75" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
                                <a href="javascript:openReceipt();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_receiptPrint.gif" width="86" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> </a>
            					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
            					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
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
		<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>