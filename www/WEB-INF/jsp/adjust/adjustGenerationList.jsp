<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%

	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

	//그리드의 width와 Height을 정의
	int listWidth = 335;
// 	int list3Height = "ADM".equals(userInfoDto.getSvcTypeCd()) ? 185 : 215;
// 	out.println("gridHeightResizePlus:"+Number(gridHeightResizePlus));
	String list1Height = "$(window).height()-450 + Number(gridHeightResizePlus)";
// 	String list2Width = "$(window).width() - 510 + Number(gridWidthResizePlus)";
	String list2Width = "1145";
	
	String list2Height = "$(window).height()-780 + Number(gridHeightResizePlus)";
// 	String list3Height = "$(window).height()-490 + Number(gridHeightResizePlus)";
	String list3Height = "200";
	String list4Height = "$(window).height()-580 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	// 날짜 세팅
	String srcStatDate = CommonUtils.getCurrentDate().substring(0, 8) + "01";
	String srcEndDate = CommonUtils.getCurrentDate();
	
	String srcOrderStatDate = CommonUtils.getCurrentDate().substring(0, 8) + "01";
	String srcOrderEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div {
	white-space:normal !important; height:auto !important; padding:2px;
}
</style>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	
    $("#srcVendorName").keydown(function(e)     {   if(e.keyCode==13) { $("#btnVendor").click(); }                                          });
    $("#srcVendorName").change(function(e)      {   $("#srcVendorName").val("");    $("#srcVendorId").val("");                              });
    $("#btnVendor").click(function()            {   fnVendorSearchOpenPop();                                                                });
    
	$("#srcButtonAdjMaster").click( function() { fnAdjustMasterSearch(); });
	$("#delClientBtn").click( function() { fnDelClientNm(); });
	$("#srcButtonTarget").click( function() { fnSearchTarget(); });
	$("#srcButtonDeli").click( function() { fnSearchDeli(); });
	$("#addTargetMst").click( function() { fnAddTargetMst(); });
	$("#delTargetMst").click( function() { fnDelTargetMst(); });
	$("#adjustCreatButton").click( function() { adjustCreat(); });
	$("#adjustRemoveButton").click( function() { adjustRemove(); });
	
	$("#colButton1").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton1").click(function(){ exportExcel1(); });
	
	$("#colButton2").click( function(){ jq("#list2").jqGrid('columnChooser'); });
	$("#excelButton2").click(function(){ exportExcel2(); });
	
	$("#colButton3").click( function(){ jq("#list4").jqGrid('columnChooser'); });
	$("#excelButton3").click(function(){ exportExcel3(); });
	
	$("#srcConsIdenName").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearchTarget();
		}
	});

	$("#addTargetAll").click( function(){ fnAddTargetAll(); });

	$("#srcOrdeNumb").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearchTarget();
		}
	});
	$("#srcGoodNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearchTarget();
		}
	});
	
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"ORDERTYPECODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length ;i++) {
				if(codeList[i].codeVal1 != '90'){
					$("#srcOrderTypeCd").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				}
			}
		}
	);

<%
	//	공급사 정산일경우 구매사는 SK브로드밴드로 고정되야함
	//	개발현재(2013-01-23) Default Value 를 셋팅
	//	추후 변경요망!!!!!!!!!!!!!!
	String colspan = "3";
	if("VEN".equals( userInfoDto.getSvcTypeCd())){
		colspan = "1";
%>
	$("#borgNm").removeClass();
	$("#borgNm").addClass("input_text_none");
	$("#srcClientBtn").hide();
	$("#delClientBtn").hide();
	$("#borgNm").val("SK그룹 > SK브로드밴드");
	$("#srcClientId").val("304453");	

	$("#venTdId1").show();
	$("#venTdId2").show();
	$("#vendorNm").show();
	$("#vendorId").show();

	$("#vendorNm").removeClass();
	$("#vendorNm").addClass("input_text_none");

	$("#vendorNm").val('<%=userInfoDto.getBorgNm()%>');
	$("#vendorId").val('<%=userInfoDto.getBorgId()%>');

<%		
	}
%>

});

</script>
<%
/**------------------------------------구매사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 구매사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 구매사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 구매사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
   $("#srcClientBtn").click(function(){
      fnBuyborgDialog("", "", "", "fnCallBackClient"); 
   });
});

/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackClient(groupId, clientId, branchId, borgNm, areaType) {
   $("#borgNm").val(borgNm);
   $("#srcClientId").val(clientId);
   $("#srcBranchId").val(branchId);
}
</script>
<% //------------------------------------------------------------------------------ %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcStatDate").val(""); //정산대상 목록 날짜가 안나오도록 설정
	$("#srcEndDate").val("");
	
<%--    $("#srcStatDate").val("<%=srcStatDate%>"); --%>
<%--    $("#srcEndDate").val("<%=srcEndDate%>");   --%>

   $("#srcOrderStatDate").val("<%=srcOrderStatDate%>");
   $("#srcOrderEndDate").val("<%=srcOrderEndDate%>");  
});

// 날짜 조회 및 스타일
$(function(){
	$("#srcStatDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcOrderStatDate").datepicker({
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

$(window).bind('resize', function() {
	$("#list").jqGrid( 'setGridWidth', $(window).width()-390 );
	$("#list").setGridHeight(<%=list1Height%>);
	$("#list3").setGridHeight(<%=list3Height%>);
	$("#list4").setGridHeight(<%=list4Height%>);
	
	$("#list").setGridWidth(<%=list2Width%>);
<%-- 	   $("#list2").setGridWidth(<%=list2Width %>); --%>
<%-- 	   $("#list2").setGridHeight(<%=list2Height %>); --%>
<%-- 	   $("#list4").setGridHeight(<%=list4Height %>); --%>
	   
// 	   $("#list2").setGridHeight($(window).height() - 770 + Number(gridHeightResizePlus));

	}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var staticNum = 0;
var isOnLoad = false;
var _selRowId = -1;
var _top_rowid = -1;
jq(function() {
	<%-- 정산대상 목록 --%>
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
		datatype: 'json',
		multiselect:true,
		mtype: 'POST',
		colNames:['주문<br/>유형','구매사명','주문번호', '주문명','공급사명','상품코드','상품명','인수<br/>수량','매출<br/>단가','매출액','매입<br/>단가','매입액','인수일자', 'sale_sequ_numb', 'buyi_sequ_numb', 'orde_iden_numb','orde_sequ_numb', 'purc_iden_numb', 'deli_iden_numb', 'vendorId', 'listOper', 'good_st_spec_desc', 'good_spec_desc', 'rece_iden_numb', 'sale_conf_quan'],
		colModel:[                                                                                                                                                              
          {name:'orde_type_clas_nm', index:'orde_type_clas_nm',width:32,align:"center",search:false,sortable:true, editable:false, hidden:true },	//주문유형
          {name:'branchNm', index:'branchNm',width:160,align:"left",search:false,sortable:true, editable:false },	//구매사명
          {name:'order_num',index:'order_num',width:120,align:"center",search:false,sortable:true, editable:false,fontcolor:'blue' },	//주문번호
          {name:'cons_iden_name', index:'cons_iden_name',width:160,align:"left",search:false,sortable:true, editable:false },	//주문명
          {name:'vendorNm', index:'vendorNm',width:160,align:"left",search:false,sortable:true, editable:false},	//공급사명
          {name:'good_iden_numb',index:'good_iden_numb',width:70,align:"center",search:false,sortable:true, editable:false },	//상품코드
          {name:'good_name',index:'good_name',width:170,align:"left",search:false,sortable:true, editable:false },	//상품명
          {name:'sale_prod_quan',index:'sale_prod_quan',width:40,align:"right",search:false,sortable:true, editable:false,
              sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
          },	//인수수량
          {name:'sale_prod_pris',index:'sale_prod_pris',width:40,align:"right",search:false,sortable:true, editable:false,
           sorttype:'integer',formatter:'integer',
             formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
          },	//매출단가
          {name:'sale_prod_amou',index:'sale_prod_amou',width:80,align:"right",search:false,sortable:true, editable:false,
           sorttype:'integer',formatter:'integer',
             formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
          },	//매출액
          {name:'purc_prod_pris',index:'purc_prod_pris',width:40,align:"right",search:false,sortable:true, editable:false,
           sorttype:'integer',formatter:'integer',
             formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
          },	//매입단가
          {name:'purc_prod_amou',index:'purc_prod_amou',width:80,align:"right",search:false,sortable:true, editable:false,
           sorttype:'integer',formatter:'integer',
             formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
          },	//매입액
          {name:'rece_regi_date',index:'rece_regi_date',width:70,align:"center",search:false,sortable:true, editable:false },	//인수일자
          {name:'sale_sequ_numb',index:'sale_sequ_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'buyi_sequ_numb',index:'buyi_sequ_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'orde_iden_numb',index:'orde_iden_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'orde_sequ_numb',index:'orde_sequ_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'purc_iden_numb',index:'purc_iden_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'deli_iden_numb',index:'deli_iden_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'vendorId',index:'vendorId',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'listOper',index:'listOper',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'good_st_spec_desc',index:'good_st_spec_desc',width:60,align:"left",search:false,sortable:true, editable:false,hidden:true},
          {name:'good_spec_desc',index:'good_spec_desc',width:60,align:"left",search:false,sortable:true, editable:false,hidden:true},
          
          {name:'rece_iden_numb',index:'rece_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false, hidden:true },
          {name:'sale_conf_quan',index:'sale_conf_quan', width:80,align:"right",search:false,sortable:true, hidden:true,
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
   						var selrowContent = jq("#list").jqGrid('getRowData',rowid);
   						var inputValue = Number(this.value);
   						var chkSaleProdQuanCnt = Number(selrowContent.sale_prod_quan);
   						if(inputValue>chkSaleProdQuanCnt) {
 							jq("#list").restoreRow(rowid);
 							jq("#list").jqGrid('setRowData', rowid, {sale_conf_quan:chkSaleProdQuanCnt});
 							jq('#list').editRow(rowid);
 							alert("실정산수량은 인수수량보다 클수 없습니다.");
 							return;
 						}
 						jq("#list").jqGrid('setRowData', rowid, {sale_conf_quan:inputValue});
   						if(chkSaleProdQuanCnt != inputValue){
   							jq("#list").jqGrid('setRowData', rowid, {listOper:"U"});
   						}else{
   							jq("#list").jqGrid('setRowData', rowid, {listOper:"O"});
   						}
 					 }
   				 }]
 			 }
 		 }
       ],
      postData: {
        srcDate:$("#srcDate").val(),
        srcStatDate:$("#srcStatDate").val(),
        srcEndDate:$("#srcEndDate").val(),
        srcConsIdenName:$("#srcConsIdenName").val(),
        srcClientId:$("#srcClientId").val(),
        srcBranchId:$("#srcBranchId").val(),
        srcOrderTypeCd:$("#srcOrderTypeCd").val(),
        srcOrdeNumb:$("#srcOrdeNumb").val(),
        srcGoodNm:$("#srcGoodNm").val(),
        srcVendorId:$("#srcVendorId").val()
      },
      rowNum:0,
      height: <%=list1Height%>, //autowidth: true,
      width: <%=list2Width%>,
      sortname: 'rece_regi_date', sortorder: 'desc',
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {
      	 var rowCnt = $("#list").getGridParam('reccount');
       	 for(var i=0;i<rowCnt;i++) {
        	var rowid = $("#list").getDataIDs()[i];
          	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
          	jq("#list").setCell(rowid,'order_num','',{color:'#0000ff'});
          	jq("#list").setCell(rowid,'order_num','',{cursor:'pointer'});  
          	jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
          	jq("#list").setCell(rowid,'good_name','',{cursor:'pointer'});         
          	jq("#list").jqGrid('setRowData', rowid, {sale_conf_quan:selrowContent.sale_prod_quan});
          	jq("#list").jqGrid('setRowData', rowid, {listOper:"O"});
       	 }
       	 
       	 
  		// 품목 표준 규격 설정
   		var prodStSpcNm = new Array();
   		<% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
   			prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
   		<% } %>      
             
            // 품목 규격 설정 
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
   				var excelProdStSpec = "";
   				var prodSpec = "";
   			
   				for(var stIdx = 0 ; stIdx < prodStSpcNm.length ; stIdx ++ ) {
   					if(argStArray[stIdx] > ' ') {
   						prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
   					}
   				}
   			
   				if(prodStSpec.length > 0) {
   					prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
   					excelProdStSpec = prodStSpec;
   					prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
   				}
   			
   				for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
   					if(argArray[jIdx] > ' ') {
   						if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
   						else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
   					}
   				}
   				excelProdStSpec += prodSpec;
   				jQuery('#list').jqGrid('setRowData',rowid,{good_spec:excelProdStSpec});
           	}       	 
      },
      onSelectAll:function (aRowids, status){
      	 if(status == false) {
        	$("#sale_requ_amou").val("0");
            $("#purc_requ_amou").val("0");         
      	 } else {
        	var ids = $("#list").jqGrid('getDataIDs');
         	var sale_total_amou = 0;
         	var purc_total_amou = 0;
         	for(var i = 0 ; i < ids.length ; i++){
            	var rowdata = $("#list").getRowData(ids[i]);
                sale_total_amou += parseInt(rowdata.sale_prod_amou);
                purc_total_amou += parseInt(rowdata.purc_prod_amou);                         
         	}
            $("#sale_requ_amou").val(fnComma(sale_total_amou));
            $("#purc_requ_amou").val(fnComma(purc_total_amou));
       	 }
      },
      onSelectRow: function (rowid, iRow, iCol, e) {
          var id = $("#list").getGridParam('selarrrow');
          var ids = $("#list").jqGrid('getDataIDs');
          var sale_total_amou = 0;
          var purc_total_amou = 0;
          var count = 0;
          for (var i = 0; i < ids.length; i++) {
              var check = false;
              $.each(id, function (index, value) {
                  if (value == ids[i]){
                     check = true;
                  }
              });
              if (check) {
                  jq('#list').editRow(ids[i]);
                  var rowdata = $("#list").getRowData(ids[i]);
                  sale_total_amou += parseInt(rowdata.sale_prod_amou);
                  purc_total_amou += parseInt(rowdata.purc_prod_amou);
                  count++;
              }else{
            	  jq("#list").restoreRow(ids[i]);
            	  jq("#list").jqGrid('setRowData', rowid, {listOper:"O"});
              }
          }
          $("#sale_requ_amou").val(fnComma(sale_total_amou));
          $("#purc_requ_amou").val(fnComma(purc_total_amou));
      },
      ondblClickRow: function (rowid, iRow, iCol, e) {},
      onCellSelect: function(rowid, iCol, cellcontent, target){
        var cm = $("#list").jqGrid("getGridParam", "colModel");
        var colName = cm[iCol];
        var selrowContent = jq("#list").jqGrid('getRowData',rowid);
        if(colName['index'] == "order_num"){
          <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, '" +_menuId+ "', selrowContent.purc_iden_numb);")%>
        }
        if(colName['index'] == "good_name"){
          <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView('"+_menuId+"',selrowContent.good_iden_numb, selrowContent.vendorId);")%>
        }
      },
      loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      jsonReader : {root: "list",repeatitems: false,cell: "cell"},
      rownumbers:true
   });
   
   jq("#list2").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustFirstPurchaseHandleListJQGrid.sys',
      datatype: 'json',
      mtype: 'POST',
      colNames:['주문번호','발주차수','납품차수','구매사', '공급사', '상품명', '상품코드', '단가', '고객인수수량', '매출처리할수량', '매출처리된수량', '발주차수','출하차수', 'vendorId'],
      colModel:[
         {name:'orde_iden_numb',index:'orde_iden_numb', width:90,align:"left",search:false,sortable:true, editable:false , fontcolor:'blue'}, //주문번호
         {name:'purc_iden_numb',index:'purc_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},
         {name:'deli_iden_numb',index:'deli_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},         
         {name:'orde_client_name',index:'orde_client_name', width:200,align:"left",search:false,sortable:true, 
            editable:false 
         }, //구매사
         {name:'vendornm',index:'vendornm', width:120,align:"left",search:false,sortable:true, 
            editable:false 
         }, //공급사
         {name:'good_name',index:'good_name', width:140,align:"left",search:false,sortable:true, 
            editable:false
         }, //상품명
         {name:'good_iden_numb',index:'good_iden_numb', width:50,align:"center",search:false,sortable:true, 
            editable:false
         }, //상품코드
         {name:'sale_unit_pric',index:'sale_unit_pric', width:90,align:"right",search:false,sortable:true,
            editable:false,sorttype:'integer',formatter:'integer',
            formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
         }, //단가
         {name:'deli_prod_quan',index:'deli_prod_quan', width:90,align:"right",search:false,sortable:true,
            editable:false ,sorttype:'integer',formatter:'integer',
            formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
         }, //고객인수수량
         {name:'to_do_rece_prod_quan',index:'to_do_rece_prod_quan', width:90,align:"right",search:false,sortable:true,
            editable:true,sorttype:'integer',formatter:'integer',
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
                     var inputValue = Number(this.value);                                 
                     jq("#list2").restoreRow(rowid);
                     jq("#list2").jqGrid('setRowData', rowid, {to_do_rece_prod_quan:inputValue});
                     jq('#list2').editRow(rowid);
                  }
               }]
            }
         }, //매출처리할수량
         {name:'rece_prod_quan',index:'rece_prod_quan', width:90,align:"right",search:false,sortable:true,
            editable:false,sorttype:'integer',formatter:'integer',
            formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
         }, //매출처리된수량
         {name:'purc_iden_numb',index:'purc_iden_numb', width:60,align:"center",search:false,sortable:false,
            editable:false ,hidden:true
         }, //발주차수
         {name:'deli_iden_numb',index:'deli_iden_numb', width:60,align:"center",search:false,sortable:false,
            editable:false ,hidden:true
         },  //출하차수
         {name:'vendorId',index:'vendorId',width:50,align:"center",search:false,sortable:true, editable:false},
      ],
      postData: {
        srcOrderStartDate:$("#srcOrderStatDate").val(),
        srcOrderEndDate:$("#srcOrderEndDate").val()
      },multiselect: false,
      rowNum:0,
      height: <%=list2Height%>,width:<%=list2Width %>,
      sortname: 'orde_iden_numb', sortorder: "asc", 
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {
         
         var rowCnt = jq("#list2").getGridParam('reccount');
         if(rowCnt>0) {
            for(var i=0; i<rowCnt; i++) {
               var rowid = $("#list2").getDataIDs()[i];
               var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
               var deli_prod_quan = selrowContent.deli_prod_quan;
               var rece_prod_quan = selrowContent.rece_prod_quan;
               var to_do_rece_prod_quan = Number(deli_prod_quan) - Number(rece_prod_quan);
               jq("#list2").jqGrid('setRowData', rowid, {to_do_rece_prod_quan:to_do_rece_prod_quan});
	           jq("#list2").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
               jq("#list2").setCell(rowid,'orde_iden_numb','',{cursor:'pointer'});  
	           jq("#list2").setCell(rowid,'good_name','',{color:'#0000ff'});
               jq("#list2").setCell(rowid,'good_name','',{cursor:'pointer'});  
               //jQuery('#list2').jqGrid('editRow',rowid,true);
            }
         }
      },
      onSelectRow: function (rowid, iRow, iCol, e) {},
      ondblClickRow: function (rowid, iRow, iCol, e) {},
      onCellSelect: function(rowid, iCol, cellcontent, target){
          var cm = $("#list2").jqGrid("getGridParam", "colModel");
          var colName = cm[iCol];
          var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
          if(colName['index'] == "orde_iden_numb"){
            <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, '" +_menuId+ "', selrowContent.purc_iden_numb);")%>
          }    	 
          if(colName['index'] == "good_name"){
        	<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView('"+_menuId+"',selrowContent.good_iden_numb, selrowContent.vendorId);")%>
          }          
      },
      loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
      jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
   }); 
   
	<%-- 정산대상 선정 --%>
	jq("#list3").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustGenerationMasterListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		multiselect:true,
		colNames:['setRow','정산명','고객유형','세금계산서구매사','매출총액','지급조건','담당자', 'clientId','branchId','crea_sale_userId','sale_sequ_numb', 'workId'],
		colModel:[
			{name:'setRow', index:'setRow',width:1,align:"left",search:false,sortable:true, editable:true},
			{name:'sale_sequ_name',index:'sale_sequ_name',width:180,align:"left",search:false,sortable:true, editable:false },
			{name:'workNm', index:'workNm',width:140,align:"left",search:false,sortable:true, editable:false },
			{name:'clientNm', index:'clientNm',width:140,align:"left",search:false,sortable:true, editable:false },
			{name:'sale_tota_amou',index:'sale_tota_amou',width:60,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			},
			{name:'payCondNm', index:'payCondNm',width:140,align:"left",search:false,sortable:true, editable:false },
			{name:'crea_sale_usernm',index:'crea_sale_usernm',width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'clientId',index:'clientId',width:60,align:"left",search:false,sortable:true, editable:false ,hidden:true},
			{name:'branchId',index:'branchId',width:60,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'crea_sale_userid',index:'crea_sale_userid',width:60,align:"left",search:false,sortable:true, editable:false,hidden:true },
			{name:'sale_sequ_numb',index:'sale_sequ_numb',width:60,align:"left",search:false,sortable:true, editable:false ,key:true,hidden:true},
			{name:'workId',index:'workId',width:60,align:"left",search:false,sortable:true, editable:false ,hidden:true}
		],
		postData: {
			create_borgid:'<%=userInfoDto.getBorgId()%>',
			create_userid:$("#srcAccUser").val()
		},
		rowNum:0,
		rownumbers: false, 
		height: <%=list3Height%>,width: <%=listWidth%>,
		sortname: 'crea_sale_date', sortorder: 'desc', 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list3").getGridParam('reccount');
			var sale_sequ_numb = "";
			if(rowCnt>0) {
				var top_rowid = $("#list3").getDataIDs()[0]; //첫번째 로우 아이디 구하기
				var selrowContent = jq("#list3").jqGrid('getRowData',top_rowid);
				sale_sequ_numb = selrowContent.sale_sequ_numb;
				if(staticNum==0) {
					staticNum++;
				}else {
					jq("#list4").clearGridData();
				}
				isOnLoad = true;
				var selCnt = 0;
				for(var i = 0 ; i < rowCnt ; i++){
					var grdRowid = $("#list3").getDataIDs()[i];
					if($.trim(_selRowId) == $.trim(grdRowid)){
						selCnt++;
						break;
					}
				}
				if(selCnt > 0){
					jq("#list3").setSelection(_selRowId, true);
					jq('#list3').editRow(_selRowId);
					jq("#list3").restoreRow(_selRowId);
				}else{
					jq("#list3").setSelection(top_rowid, true); 
				}
			}else{
				_selRowId = -1;
				jq("#list4").clearGridData();
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var rowCnt = jq("#list3").getGridParam('reccount');
			if(rowCnt > 0) {
				var id = $("#list3").jqGrid('getGridParam', "selrow" );
				if(id != null) {
					var selrowContent = jq("#list3").jqGrid('getRowData',id);
					 _sale_sequ_numb = selrowContent.sale_sequ_numb;
					fnAdjustCreatListOnClick(selrowContent.sale_sequ_numb, isOnLoad);
					
					$("#borgNm").val(selrowContent.clientNm);
					$("#srcClientId").val(selrowContent.clientId);
					$("#srcBranchId").val(selrowContent.branchId);
					_selRowId = rowid;
// 					fnSearchTarget();
					fnSearchTargetMrordtList();
				} else {
					jq("#list4").clearGridData();
					$("#borgNm").val('');
					$("#srcClientId").val('');
					$("#srcBranchId").val('');
					jq("#list").clearGridData();
				}
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list3").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
	
   jq("#list4").jqGrid({
	  url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
      datatype: 'json',
      mtype: 'POST',
      multiselect:true,
      colNames:['주문유형','주문번호','주문명','상품명','인수수량','매출단가','매출액','매출부가세액','매입단가','매입액','매입부가세액','상품코드','인수일자','주문일자','출하일자', 'sale_sequ_numb', 'buyi_sequ_numb', 'orde_iden_numb','orde_sequ_numb', 'purc_iden_numb', 'deli_iden_numb', 'rece_iden_numb'],
      colModel:[                                                                                                                                                              
         {name:'orde_type_clas_nm', index:'orde_type_clas_nm',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },                                           
         {name:'order_num',index:'order_num',width:130,align:"center",search:false,sortable:true, editable:false },
         {name:'cons_iden_name', index:'cons_iden_name',width:160,align:"left",search:false,sortable:true, editable:false },                                                              
         {name:'good_name',index:'good_name',width:170,align:"left",search:false,sortable:true, editable:false },
         {name:'sale_prod_quan',index:'sale_prod_quan',width:80,align:"right",search:false,sortable:true, editable:false
         ,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'sale_prod_pris',index:'sale_prod_pris',width:80,align:"right",search:false,sortable:true, editable:false
        ,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'sale_prod_amou',index:'sale_prod_amou',width:80,align:"right",search:false,sortable:true, editable:false 
        ,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'sale_prod_tax',index:'sale_prod_tax',width:80,align:"right",search:false,sortable:true, editable:false
        ,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'purc_prod_pris',index:'purc_prod_pris',width:80,align:"right",search:false,sortable:true, editable:false 
       ,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'purc_prod_amou',index:'purc_prod_amou',width:80,align:"right",search:false,sortable:true, editable:false 
       ,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'purc_prod_tax',index:'purc_prod_tax',width:80,align:"right",search:false,sortable:true, editable:false 
       ,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'good_iden_numb',index:'good_iden_numb',width:80,align:"center",search:false,sortable:true, editable:false },
         {name:'rece_regi_date',index:'rece_regi_date',width:70,align:"center",search:false,sortable:true, editable:false },
         {name:'orde_regi_date',index:'orde_regi_date',width:70,align:"center",search:false,sortable:true, editable:false },
         {name:'deli_regi_date',index:'deli_regi_date',width:70,align:"center",search:false,sortable:true, editable:false },
         {name:'sale_sequ_numb',index:'sale_sequ_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'buyi_sequ_numb',index:'buyi_sequ_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'orde_iden_numb',index:'orde_iden_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'orde_sequ_numb',index:'orde_sequ_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'purc_iden_numb',index:'purc_iden_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'deli_iden_numb',index:'deli_iden_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'rece_iden_numb',index:'rece_iden_numb',width:70,align:"center",search:false,sortable:true, editable:false, hidden:true }
      ],
      postData: {
       sale_sequ_numb:_sale_sequ_numb
      },
      rowNum:0, rownumbers:false, 
      height: <%=list4Height%>,width: <%=listWidth%>, 
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {
       isOnLoad = true;
      },
      onSelectRow: function (rowid, iRow, iCol, e) {},
      ondblClickRow: function (rowid, iRow, iCol, e) {},
      onCellSelect: function(rowid, iCol, cellcontent, target){},
      loadError : function(xhr, st, str){ $("#list4").html(xhr.responseText); },
      jsonReader : {root: "list",repeatitems: false,cell: "cell"}
   });

});

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function fnComma(n) {
	   n += '';
	   var reg = /(^[+-]?\d+)(\d{3})/;
	   while (reg.test(n)){
	      n = n.replace(reg, '$1' + ',' + '$2');
	   }
	   return n;
	}

function fnAddTargetAll(){
	var srcStatDate = $("#srcStatDate").val();
	var srcEndDate = $("#srcEndDate").val();
	if(srcStatDate == "" || srcEndDate == ""){
		alert("날짜를 선택 후 일괄 생성해주십시오.");
		return;
	}
	if(!confirm("정산대상을 일괄생성 하시겠습니까?")) return;
	
	$.post(
   		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveAdjustMasterAll.sys", 
   		{	
   			userId:'<%=userInfoDto.getUserId()%>' , 
   			create_borgid:'<%=userInfoDto.getBorgId()%>', 
   			srcDate:$("#srcDate").val(), 
   			srcStatDate:$("#srcStatDate").val(),
   			srcEndDate:$("#srcEndDate").val(),
   			create_userid:$("#srcAccUser").val()
   		},       
   		function(arg){ 
      		if(fnAjaxTransResult(arg)) {  //성공시
      			fnAdjustCreatListReload();
      		}
   		}
	);
}

function fnOnCheckValSum(){
   var id = $("#list").getGridParam('selarrrow');
   var ids = $("#list").jqGrid('getDataIDs');
   var sale_total_amou = 0;
   var purc_total_amou = 0;
   var count = 0;
   for(var i = 0; i < ids.length; i++) {
        var check = false;
        $.each(id, function (index, value) {
        if (value == ids[i])  check = true;
        });
      if (check) {
          var rowdata = $("#list").getRowData(ids[i]);
          sale_total_amou += parseInt(rowdata.sale_prod_amou);
          purc_total_amou += parseInt(rowdata.purc_prod_amou);
          count++;
      }
   }
   $("#sale_requ_amou").val(fnComma(sale_total_amou));
   $("#purc_requ_amou").val(fnComma(purc_total_amou));   
}

function fnDelClientNm() {
   $("#borgNm").val("");
   $("#srcClientId").val("");
   $("#srcBranchId").val("");
}

function fnAddTargetMst() {
	var userId = $('#srcAccUser').val();
	var popurl = "<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustGenerationPop.sys?_menuId="+<%=_menuId%>+"&userId="+userId;
<%-- 	var popurl = "<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustGenerationPop.sys?_menuId=<%=_menuId%>"; --%>
	var popproperty = "dialogWidth:720px;dialogHeight=640px;scroll=yes;status=no;resizable=no;";
//    window.showModalDialog(popurl,self,popproperty);
   window.open(popurl, 'okplazaPop', 'width=720, height=640, scrollbars=yes, status=no, resizable=no');
}

function fnAddTargetMstMulti() {
	var popurl = "<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustGenerationMultiPop.sys?_menuId=<%=_menuId%>";
	var popproperty = "dialogWidth:720px;dialogHeight=640px;scroll=yes;status=no;resizable=no;";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=720, height=640, scrollbars=yes, status=no, resizable=no');
}

function fnDelTargetMst() {
	var selrowArray = jq("#list3").jqGrid('getGridParam','selarrrow');	//현재 선택된 로우들
	if(selrowArray.length==0) {
		alert("삭제할 데이터를 선택해주세요.");
		return;
	}
	if(!confirm("정산대상이 삭제되면 해당 정산생성목록도 초기화됩니다.\n선택한 정산대상건을 삭제하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveAdjustMaster.sys", 
		{
			oper:"multiDel",
			sale_sequ_numb_array:selrowArray
		}, function(arg){ 
			if(fnAjaxTransResult(arg)) {  //성공시
				fnAdjustCreatListReload();
			}
		}
	);
	
/* 	단건 삭제 주석처리(2013-06-27 jameskang)
	var id = $("#list3").jqGrid('getGridParam', "selrow" );
	if(id == null) {
		alert("삭제할 데이터를 선택해주세요.");
		return;
	}
	if(!confirm("정산대상이 삭제되면 해당 정산생성목록도 초기화됩니다.\n선택한 정산대상건을 삭제하시겠습니까?")) return;
	var selrowContent = jq("#list3").jqGrid('getRowData',id);   
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveAdjustMaster.sys", 
		{
			oper:"del", 
			sale_sequ_numb:selrowContent.sale_sequ_numb
		}, function(arg){ 
			if(fnAjaxTransResult(arg)) {  //성공시
				fnAdjustCreatListReload();
			}
		}
	);
*/
}

function fnSearchTarget() {
	var srcStatDate = $("#srcStatDate").val();
	var srcEndDate = $("#srcEndDate").val();
	if(srcStatDate == "" || srcEndDate == ""){
		alert("날짜를 선택 후 조회해 주십시오.");
		return;
	}
   $("#list").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustGenerationListJQGrid.sys'});
   var data = jq("#list").jqGrid("getGridParam", "postData");
      data.srcDate         = $("#srcDate").val();
      data.srcStatDate     = $("#srcStatDate").val();
      data.srcEndDate      = $("#srcEndDate").val();
      data.srcConsIdenName = $("#srcConsIdenName").val();
      data.srcClientId     = $("#srcClientId").val();
      data.srcBranchId     = $("#srcBranchId").val();
      data.srcOrderTypeCd  = $("#srcOrderTypeCd").val();
      data.srcTaxClasCd    = $("#srcTaxClasCd").val();
      data.srcOrdeNumb     = $("#srcOrdeNumb").val();
      data.srcGoodNm     = $("#srcGoodNm").val();
      data.srcVendorId     = $("#srcVendorId").val();
      jq("#list").trigger("reloadGrid");
}


function fnSearchDeli() {
   jq("#list2").jqGrid("setGridParam");
   var data = jq("#list2").jqGrid("getGridParam", "postData");
   data.srcOrderStartDate     = $("#srcOrderStatDate").val();
   data.srcOrderEndDate     = $("#srcOrderEndDate").val();
   jq("#list2").trigger("reloadGrid"); 
}


function fnAdjustMasterSearch() {

   	jq("#list3").jqGrid("setGridParam");
   	var data = jq("#list3").jqGrid("getGridParam", "postData");
   	data.create_userid = $("#srcAccUser").val();
   	jq("#list3").trigger("reloadGrid");
}

var _sale_sequ_numb = "";
function adjustCreat(){
	var id = $("#list").getGridParam('selarrrow');
    var ids = $("#list").jqGrid('getDataIDs');
    var count = 0;
    var updCnt = 0;
    var orde_iden_numb_arr = Array();
    for (var i = 0; i < ids.length; i++) {
    	var check = false;
        $.each(id, function (index, value) {
        	if (value == ids[i])	check = true;
        });
        if (check) {
        	var rowdata = $("#list").getRowData(ids[i]);
        	
        	var confQuan = 0;
        	
        	if($.trim(rowdata.sale_conf_quan).length > 0){
        		confQuan = rowdata.sale_conf_quan;
        	}else{
        		confQuan = rowdata.sale_prod_quan;
        	}
        	
        	orde_iden_numb_arr[count] = rowdata.orde_iden_numb + "|" + rowdata.orde_sequ_numb + "|" + rowdata.purc_iden_numb + "|" + rowdata.deli_iden_numb + "|" + rowdata.rece_iden_numb + "|" + confQuan + "|" + rowdata.listOper;
          	count++;
          	
          	if(rowdata.listOper == "U" && $.trim(rowdata.sale_conf_quan).length > 0){
          		updCnt++;
          	}
        }
   	}
     
    if(count == 0 ){
      alert("정산대상을 선택해주세요.");
      return;
    }
    
    var id2     = $("#list3").jqGrid('getGridParam', "selrow" );
    var rowCnt2 = $("#list3").getGridParam('reccount');
    
    if(rowCnt2 == 0 || id2 == "" || id2 == null){
      alert("정산대상 선정을 선택해주세요.");
      return;
    }
    
    var confMsg = "선택한 목록을 추가하시겠습니까?";
    if(updCnt > 0)confMsg = "정산대상 목록중 정산수량 분할데이터가 존재합니다.\n정산대상이 분할될경우 다시 합칠수없습니다.\n진행하시겠습니까?";
    
    if(!confirm(confMsg)) return;

	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveAdjustCreatList.sys", 
		{  
			oper:"add", 
			sale_sequ_numb:_sale_sequ_numb,
			orde_iden_numb_arr:orde_iden_numb_arr
		},
		function(arg){ 
			fnAjaxTransResult(arg);
			fnSearchTarget();
			fnAdjustCreatListReload();
		}
	);
}

function adjustRemove(){
   var id = $("#list4").getGridParam('selarrrow');
    var ids = $("#list4").jqGrid('getDataIDs');
    var count = 0;
    var orde_iden_numb_arr = Array();
    for (var i = 0; i < ids.length; i++) {
      var check = false;
       $.each(id, function (index, value) {
         if (value == ids[i])
            check = true;
       });
       if (check) {
         var rowdata = $("#list4").getRowData(ids[i]);
         orde_iden_numb_arr[count] = rowdata.orde_iden_numb + "|" + rowdata.orde_sequ_numb + "|" + rowdata.purc_iden_numb + "|" + rowdata.deli_iden_numb + "|" + rowdata.rece_iden_numb;
           count++;
       }
   }
    
   if(count == 0 ){
      alert("삭제할대상을 선택해주세요.");
      return;
   } 
   
   if(!confirm("선택한 목록을 삭제하시겠습니까?")) return;
   
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveAdjustCreatList.sys", 
		{  
			oper:"del", 
			sale_sequ_numb:_sale_sequ_numb,
			orde_iden_numb_arr:orde_iden_numb_arr
		},
		function(arg){ 
			fnAjaxTransResult(arg);
			fnSearchTarget();
			fnAdjustCreatListReload();
		}
	);
}

function fnAdjustCreatListOnClick(sale_sequ_numb, isOnLoad){
   if(isOnLoad){
      $("#list4").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustCreatListJQGrid.sys'});
         var data = jq("#list4").jqGrid("getGridParam", "postData");
         data.sale_sequ_numb = sale_sequ_numb;
         jq("#list4").jqGrid("setGridParam", { "postData": data });
         jq("#list4").trigger("reloadGrid"); 
         isOnLoad = false;
   }
}

function fnAdjustCreatListReload(){
   var data1 = jq("#list").jqGrid("getGridParam", "postData");
    data1.srcDate =  $("#srcDate").val();
    data1.srcStatDate = $("#srcStatDate").val();
    data1.srcEndDate = $("#srcEndDate").val();
    data1.srcConsIdenName =   $("#srcConsIdenName").val();
    data1.srcClientId = $("#srcClientId").val();
    data1.srcBranchId = $("#srcBranchId").val();
    data1.srcOrderTypeCd = $("#srcOrderTypeCd").val();         
   jq("#list").jqGrid("setGridParam", { "postData": data1 });
   jq("#list").trigger("reloadGrid");  

   jq("#list4").clearGridData();
   var data2 = jq("#list4").jqGrid("getGridParam", "postData");
   data2.sale_sequ_numb = _sale_sequ_numb;
   jq("#list4").jqGrid("setGridParam", { "postData": data2 });
   jq("#list4").trigger("reloadGrid");
   
   jq("#list3").trigger("reloadGrid");    
}

//list
function exportExcel1() {
   //var colLabels = ['주문유형','구매사명','주문자','주문번호','주문명','실제구입시공사','공급사명','발주차수','납품차수','인수차수','상품명','규격','인수수량','매출단가','매출액','매출부가세액','매입단가','매입액','매입부가세액','상품코드','인수일자','주문일자','출하일자'];   //출력컬럼명
   //var colIds = ['orde_type_clas_nm','branchNm','orde_user_nm','order_num','cons_iden_name','org_branchnm','vendorNm','purc_iden_numb', 'deli_iden_numb','rece_iden_numb','good_name','good_spec','sale_prod_quan','sale_prod_pris','sale_prod_amou','sale_prod_tax','purc_prod_pris','purc_prod_amou','purc_prod_tax','good_iden_numb','rece_regi_date','orde_regi_date','deli_regi_date'];   //출력컬럼ID
   //var numColIds = ['sale_prod_quan','sale_prod_pris','sale_prod_amou','sale_prod_tax','purc_prod_pris','purc_prod_amou','purc_prod_tax'];   //숫자표현ID
   
   var colLabels = ['주문유형','구매사명','주문번호','주문명','공급사명','상품코드','상품명','인수수량','매출단가','매출액','매입단가','매입액','인수일자']; //출력컬럼명
   var colIds = ['orde_type_clas_nm','branchNm','order_num','cons_iden_name','vendorNm','good_iden_numb','good_name','sale_prod_quan','sale_prod_pris','sale_prod_amou','purc_prod_pris','purc_prod_amou','rece_regi_date']; //출력컬럼ID
   var numColIds = ['sale_prod_quan','sale_prod_pris','sale_prod_amou','purc_prod_pris','purc_prod_amou'];   //숫자표현ID
   var sheetTitle = "정산대상목록"; //sheet 타이틀
   var excelFileName = "AdjustGenerationTargetList";  //file명
   
   fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//list2
function exportExcel2() {
   var colLabels = ['주문번호','발주차수','납품차수', '구매사', '공급사', '상품명', '상품코드', '단가', '고객인수수량', '매출처리할수량', '매출처리된수량', '발주차수','출하차수']; //출력컬럼명
   var colIds = ['orde_iden_numb','purc_iden_numb', 'deli_iden_numb','orde_client_name','vendornm','good_name','good_iden_numb','sale_unit_pric','deli_prod_quan','to_do_rece_prod_quan','rece_prod_quan','purc_iden_numb','deli_iden_numb'];  //출력컬럼ID
   var numColIds = ['sale_unit_pric','deli_prod_quan','to_do_rece_prod_quan','rece_prod_quan']; //숫자표현ID
   var sheetTitle = "선발주목록";  //sheet 타이틀
   var excelFileName = "DeliveryList"; //file명
   
   fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//list4
function exportExcel3() {
   var colLabels = ['주문유형','주문번호','주문명','상품명','인수수량','매출단가','매출액','매출부가세액','매입단가','매입액','매입부가세액','상품코드','인수일자','주문일자','출하일자'];   //출력컬럼명
   var colIds = ['orde_type_clas_nm','order_num','cons_iden_name','good_name','sale_prod_quan','sale_prod_pris','sale_prod_amou','sale_prod_tax','purc_prod_pris','purc_prod_amou','purc_prod_tax','good_iden_numb','rece_regi_date','orde_regi_date','deli_regi_date'];   //출력컬럼ID
   var numColIds = ['sale_prod_quan','sale_prod_pris','sale_prod_amou','sale_prod_tax','purc_prod_pris','purc_prod_amou','purc_prod_tax'];   //숫자표현ID
   var sheetTitle = "정산생성목록"; //sheet 타이틀
   var excelFileName = "AdjustGenerationList";  //file명
   
   fnExportExcel(jq("#list4"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

<%-- 정산대상 인수 목록 검색 --%>
function fnSearchTargetMrordtList(){
	$("#list").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustGenerationListJQGrid.sys'});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcDate         = $("#srcDate").val();
	data.srcStatDate     = $("#srcStatDate").val();
	data.srcEndDate      = $("#srcEndDate").val();
	data.srcConsIdenName = $("#srcConsIdenName").val();
	data.srcClientId     = $("#srcClientId").val();
	data.srcBranchId     = $("#srcBranchId").val();
	data.srcOrderTypeCd  = $("#srcOrderTypeCd").val();
	data.srcTaxClasCd    = $("#srcTaxClasCd").val();
	data.srcOrdeNumb     = $("#srcOrdeNumb").val();
	data.srcGoodNm     = $("#srcGoodNm").val();
	data.srcVendorId     = $("#srcVendorId").val();
	jq("#list").trigger("reloadGrid");
} 


/** * 공급사 검색 */
function fnVendorSearchOpenPop(){
    var vendorNm = $("#srcVendorName").val();   
    fnVendorDialog(vendorNm, "fnCallBackVendor");
}
/** * 공급사 선택 콜백 */
function fnCallBackVendor(vendorId, vendorNm, areaType){
    $("#srcVendorId").val(vendorId);
    $("#srcVendorName").val(vendorNm);
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<body>
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" bgcolor="#FFFFFF">
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">정산생성</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td valign="top">
			<table width="335px" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%">
						<table width="100%">
							<tr>
								<td width="20" valign="top">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
								</td>
								<td class="stitle">정산대상 선정</td>
								<td align="right" class="stitle">
<%	if("ADM".equals(userInfoDto.getSvcTypeCd())){	%>		 
									<button id="addTargetAll" name="addTargetAll" class="btn btn-primary btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>일괄생성</button>
<%	}	%>
									<button id="addTargetMst" name="addTargetMst" class="btn btn-primary btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>추가</button>
									<button id="delTargetMst" name="delTargetMst" class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>삭제</button>
								</td>
							</tr>
<%	if("ADM".equals(userInfoDto.getSvcTypeCd())){	%>									
							<tr>
								<td colspan="3">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td colspan="4" class="table_top_line"></td>
										</tr>
										<tr>
											<td class="table_td_subject" width="100">고객유형운영자</td>
											<td class="table_td_contents">
		                						<select id="srcAccUser" name="srcAccUser" class="select" style="width: 120px;">
                            						<option value="">전체</option>
<%
   @SuppressWarnings("unchecked")
   List<SmpUsersDto> admUserList = (List<SmpUsersDto>) request.getAttribute("admUserList");

   if(admUserList != null && admUserList.size() > 0){

      for(SmpUsersDto userDto : admUserList){
%>                              
                                 					<option value="<%=userDto.getUserId()%>" <%=userDto.getUserId().equals(userInfoDto.getUserId()) ? "selected" : "" %>><%=userDto.getUserNm()%></option>
<%
      }
   }
%>                              
                        						</select>		
											</td>
											<td align="right">
												<button id="srcButtonAdjMaster" name="srcButtonAdjMaster" class="btn btn-default btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-search"></i> 조회</button>
											</td>
										</tr>
										<tr>
											<td colspan="4" class="table_top_line"></td>
										</tr>
									</table>								
								</td>
							</tr>
<%	}	%>													
							<tr>
								<td colspan="3">
									<div id="jqgrid">
										<table id="list3"></table>
									</div>
								</td>
							</tr>
							<tr>
								<td width="20" valign="top">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
								</td>
								<td class="stitle">정산생성 목록</td>
								<td align="right" >
									<button id='excelButton3' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 엑셀</button>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<div id="jqgrid">
										<table id="list4"></table>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
				
		<td width="20">
			<a href="#">
				<img id="adjustCreatButton" name="adjustCreatButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_plus.gif" style="width: 20px; height: 18px; border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" />
			</a>
			<br />
			<br />
			<a href="#">
				<img id="adjustRemoveButton" name="adjustRemoveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_minus.gif" style="width: 20px; height: 18px; border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" />
			</a>
		</td>
		
		<td>
			<table  width="1145px" border="0">
				<tr>
					<td>
						<table width="1145px" border="0">
							<tr>
								<td width="20" valign="top">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
								</td>
								<td class="stitle" width="100%">정산대상 목록</td>
								<td class="stitle" width="110">
									<span class="ptitle">
										<button id='excelButton1' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 엑셀</button>
									</span>
								</td>
								<td>&nbsp;</td>
								<td>
									<button id="srcButtonTarget" name="srcButtonTarget"  class="btn btn-default btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table width="1145px" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="4" class="table_top_line"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">
									<select id="srcDate" name="srcDate" class="select">
										<option value="rece">인수일자</option>
										<option value="deli">출하일자</option>
										<option value="orde">주문일자</option>
									</select>
								</td>
								<td class="table_td_contents">
									<input type="text" name="srcStatDate" id="srcStatDate" style="width: 75px;vertical-align: middle;" /> 
									~ 
									<input type="text" name="srcEndDate" id="srcEndDate" style="width: 75px;vertical-align: middle;" />
								</td>
								<td class="table_td_subject" width="100">주문유형</td>
								<td class="table_td_contents">
									<select id="srcOrderTypeCd" name="srcOrderTypeCd" class="select">
										<option value="">선택하세요</option>
									</select>
								</td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="eaeaea"></td>
							</tr>
							<tr>
								<td class="table_td_subject">구매사</td>
								<td class="table_td_contents">
									<input id="borgNm" name="borgNm" type="text" value="" size="" maxlength="50" style="width: 350px;" class="blue" disabled="disabled" />
									<input id="srcClientId" name="srcClientId" type="hidden" value="" size="" maxlength="50"/>
									<input id="srcBranchId" name="srcBranchId" type="hidden" value="" size="" maxlength="50"/>
									<a href="#">
										<img id="srcClientBtn" name="srcClientBtn" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; vertical-align: middle; border: 0px;" class="icon_search" />
									</a>
									<a href="#"> 
										<img id="delClientBtn" name="delClientBtn" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;"/>
									</a>
								</td>
								<td id="venTdId1" class="table_td_subject" >공급사</td>
								<td id="venTdId2" class="table_td_contents" >
                                    <input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" /> <input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
                                    <a href="#">
                                        <img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; border: 0;" align="middle" class="icon_search" <%=CommonUtils.getDisplayRoleButton(roleList,"COMM_SAVE")%>" />
                                    </a>
								</td>                                       
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="eaeaea"></td>
							</tr>
							<tr>
								<td class="table_td_subject">주문명</td>
								<td class="table_td_contents">
									<input id="srcConsIdenName" name="srcConsIdenName" type="text" value="" size="" maxlength="50" style="width: 350px;" class="blue" />
								</td>
								<td class="table_td_subject">부가세구분</td>
								<td class="table_td_contents">
									<select id="srcTaxClasCd" name="srcTaxClasCd" class="select">
										<option value="">선택하세요</option>
										<option value="10">과세 (10%)</option>
										<option value="20">영세율</option>
										<option value="30">면세</option>
									</select>
								</td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="eaeaea"></td>
							</tr>														
							<tr>
								<td class="table_td_subject">주문번호</td>
								<td class="table_td_contents">
									<input id="srcOrdeNumb" name="srcOrdeNumb" type="text" value="" size="" maxlength="50" style="width: 350px;"/>
								</td>
								<td class="table_td_subject">상품명</td>
								<td class="table_td_contents">
									<input id="srcGoodNm" name="srcGoodNm" type="text" value="" size="" maxlength="50" style="width: 200px;"/>
								</td>
							</tr>
							<tr>
								<td colspan="4" class="table_top_line"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td valign="top" style="padding-top:10px;">
						<div id="jqgrid">
							<table id="list"></table>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<table width="1145px" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="4" class="table_top_line"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">매출총액</td>
								<td class="table_td_contents">
									<input id="sale_requ_amou" name="sale_requ_amou" type="text" value="0" size="" maxlength="50" class="right" disabled="disabled"/>
								</td>
								<td class="table_td_subject" width="100">매입총액</td>
								<td class="table_td_contents">
									<input id="purc_requ_amou" name="purc_requ_amou" type="text" value="0" size="" maxlength="50" class="right" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td colspan="4" class="table_top_line"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
					</td>
				</tr>
<!-- 				<tr> -->
<!-- 					<td> -->
<!-- 						<table width="100%" border="0"> -->
<!-- 							<tr> -->
<!-- 								<td valign="top" width="5px"> -->
<%-- 									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" /> --%>
<!-- 								</td> -->
<!-- 								<td class="stitle" align="left">선발주 목록</td> -->
<!-- 								<td class="stitle" align="right" width="65px"> -->
<!-- 									<a href="#"> -->
<%-- 										<img id="srcButtonDeli" name="srcButtonDeli" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width: 65px; height: 22px; border: 0px; vertical-align: middle;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" /> --%>
<!-- 									</a>                                        -->
<!-- 								</td> -->
<!-- 								<td width="15px"> -->
<%-- 									<a href="#"><img id="colButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
<!-- 								</td> -->
<!-- 								<td width="15px"> -->
<%-- 									<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>                                        --%>
<!-- 								</td>                                        -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<!-- 								<td colspan="5"> -->
<!-- 									<table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!-- 										<tr> -->
<!-- 											<td colspan="2" class="table_top_line"></td> -->
<!-- 										</tr> -->
<!-- 										<tr> -->
<!-- 											<td class="table_td_subject" width="70">주문기간</td> -->
<!-- 											<td class="table_td_contents"> -->
<!-- 												<input type="text" name="srcOrderStatDate" id="srcOrderStatDate" style="width: 75px;vertical-align: middle;" />  -->
<!-- 												~  -->
<!-- 												<input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" /> -->
<!-- 											</td> -->
<!-- 										</tr> -->
<!-- 										<tr> -->
<!-- 											<td colspan="2" class="table_top_line"></td> -->
<!-- 										</tr> -->
<!-- 									</table> -->
<!-- 								</td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<!-- 								<td colspan="5"> -->
<%-- 									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" style="width: 100%; height: 3px;" class="space" /> --%>
<!-- 								</td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<!-- 								<td colspan="5"> -->
<!-- 									<table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!-- 										<tr> -->
<!-- 											<td> -->
<!-- 												<div id="jqgrid"> -->
<!-- 													<table id="list2"></table> -->
<!-- 												</div> -->
<!-- 											</td> -->
<!-- 										</tr> -->
<!-- 									</table> -->
<!-- 								</td> -->
<!-- 							</tr> -->
<!-- 						</table> -->
<!-- 					</td> -->
<!-- 				</tr> -->
			</table>
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>      
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp"%>
</body>
</html>