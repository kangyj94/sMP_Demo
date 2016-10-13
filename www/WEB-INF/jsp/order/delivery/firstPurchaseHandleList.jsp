<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
    boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
    boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-255 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");

	// 날짜 세팅
	String srcOrderStartDate = CommonUtils.getCustomDay("MONTH", -6);
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
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });

	$("#srcButton").click(function(){ 
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		fnSearch(); 
	});

	// 날짜 세팅
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");
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
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/firstPurchaseHandleListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'주문일자','납품희망일','주문번호', '고객사', '공급사', '상품명', '상품코드', '단가', '고객인수수량', '매출처리할수량', '매출처리된수량', '내역확인','발주차수','출하차수', 'disp_good_id' , 'good_iden_numb', 'vendorId'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,
				editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter
			},	//선택
			{name:'regi_date_time',index:'regi_date_time', width:70,align:"center",search:false,sortable:true, editable:false },	//주문번호
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },	//주문번호
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"left",search:false,sortable:true, 
				editable:false
			},	//주문번호
			{name:'orde_client_name',index:'orde_client_name', width:180,align:"left",search:false,sortable:true, 
				editable:false 
			},	//고객사
			{name:'vendornm',index:'vendornm', width:180,align:"left",search:false,sortable:true, 
				editable:false 
			},	//공급사
			{name:'good_name',index:'good_name', width:140,align:"left",search:false,sortable:true, 
				editable:false
			},	//상품명
			{name:'good_iden_numb',index:'good_iden_numb', width:70,align:"left",search:false,sortable:true, 
				editable:false
			},	//상품코드
			{name:'sale_unit_pric',index:'sale_unit_pric', width:90,align:"right",search:false,sortable:true,
				editable:false,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//단가
			{name:'deli_prod_quan',index:'deli_prod_quan', width:90,align:"right",search:false,sortable:true,
				editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//고객인수수량
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
                  			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                  			var deli_prod_quan = selrowContent.deli_prod_quan;
                  			var rece_prod_quan = selrowContent.rece_prod_quan;
	  						var inputValue = Number(this.value); 											
                  			var to_do_rece_prod_quan_temp = Number(deli_prod_quan) - Number(rece_prod_quan);
   	  						if(inputValue <= to_do_rece_prod_quan_temp){
      	  						jq("#list").restoreRow(rowid);
      	  						jq("#list").jqGrid('setRowData', rowid, {to_do_rece_prod_quan:inputValue});
      	  						jq('#list').editRow(rowid);
	  						}else{
	  							alert("매출 처리할 수량은 "+to_do_rece_prod_quan_temp+"보다 클 수 없습니다.");
      	  						jq("#list").restoreRow(rowid);
      	  						jq("#list").jqGrid('setRowData', rowid, {to_do_rece_prod_quan:to_do_rece_prod_quan_temp});
      	  						jq('#list').editRow(rowid);
	  						}
	  					}
	  				}]
				}
			},	//매출처리할수량
			{name:'rece_prod_quan',index:'rece_prod_quan', width:90,align:"right",search:false,sortable:true,
				editable:false,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//매출처리된수량
			{name:'btn',index:'btn', width:80,align:"center",search:false,sortable:false,align:"left",
				editable:false 
			},	//내역확인
			{name:'purc_iden_numb',index:'purc_iden_numb', width:60,align:"center",search:false,sortable:false,
				editable:false ,hidden:true
			},	//발주차수
			{name:'deli_iden_numb',index:'deli_iden_numb', width:60,align:"center",search:false,sortable:false,
				editable:false ,hidden:true
			},
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorId',index:'vendorId', hidden:true, search:false,sortable:true, editable:false }
		],
		postData: {
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
			srcVendorId:$("#srcVendorId").val(),
			srcOrderStartDate:$('#srcOrderStartDate').val(),
			srcOrderEndDate:$('#srcOrderEndDate').val()
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
		},multiselect: false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname: 'regi_date_time', sortorder: "desc",
		caption:"선발주 실 인수처리", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
         			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
         			var deli_prod_quan = selrowContent.deli_prod_quan;
         			var rece_prod_quan = selrowContent.rece_prod_quan;
         			var to_do_rece_prod_quan = Number(deli_prod_quan) - Number(rece_prod_quan);
					jq("#list").jqGrid('setRowData', rowid, {to_do_rece_prod_quan:to_do_rece_prod_quan});
					jQuery('#list').jqGrid('editRow',rowid,true);
				}
			}
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					jq("#list").restoreRow(rowid);
					var inputBtn = "<input style='height:22px;width:80px;' type='button' value='내역확인' onclick=\"fnHistoryPop('"+rowid+"');\" />"; 
					jQuery('#list').jqGrid('setRowData',rowid,{btn:inputBtn});
					jQuery('#list').jqGrid('editRow',rowid,true);
				} 
			} 
			
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
<%if(!spUser){%>
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
<%}%>
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
            if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isAdm && !spUser){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%} %>
		},
        afterInsertRow: function(rowid, aData){
<%if(!spUser){%>
     		jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
     		jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'});  
<%}%>
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
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
	var to_do_rece_prod_quan = Number(rowObject.deli_prod_quan) - Number(rowObject.rece_prod_quan);
	var checkBox = "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;' />";
	if(0 == to_do_rece_prod_quan){
      	checkBox = "";
	}
	return checkBox;
}
/* * 내역확인 */
function fnHistoryPop(rowid) {
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
   	var popurl = "/order/delivery/firstPurchaseHandlePop.sys?orde_iden_numb=" + selrowContent.orde_iden_numb + "&purc_iden_numb=" + selrowContent.purc_iden_numb + "&deli_iden_numb=" + selrowContent.deli_iden_numb;
   	var popproperty = "dialogWidth:300px;dialogHeight=310px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);  
   	window.open(popurl, 'okplazaPop', 'width=300, height=310, scrollbars=yes, status=no, resizable=no');
}

/* * 리스트 조회 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrdeIdenNumb = $("#srcOrdeIdenNumb").val();
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcVendorId = $("#srcVendorId").val();
	data.srcOrderStartDate = $("#srcOrderStartDate").val();
	data.srcOrderEndDate = $("#srcOrderEndDate").val();
	data.srcWorkInfoUser = $("#srcWorkInfoUser").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/** * list Excel Export */
function exportExcel() {
	var colLabels = ['주문일자','납품희망일','주문번호', '고객사', '공급사', '상품명', '상품코드', '단가', '고객인수수량', '매출처리된수량'];
	var colIds = ['regi_date_time','requ_deli_date','orde_iden_numb','orde_client_name','vendornm','good_name','good_iden_numb','sale_unit_pric','deli_prod_quan','rece_prod_quan'];	//출력컬럼ID
	var numColIds = ['sale_unit_pric','deli_prod_quan','rece_prod_quan'];	//숫자표현ID
	var figureColIds = ['good_iden_numb'];
	var sheetTitle = "선발주 실 인수처리";	//sheet 타이틀
	var excelFileName = "firstPurchaseHandleList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnFirstPurcReceQuan(){
	if(confirm("선택된 정보를 실인수처리 하시겠습니까?")){
      	var orde_iden_numb_array = new Array();
      	var purc_iden_numb_array = new Array();
      	var deli_iden_numb_array = new Array();
      	var deli_prod_quan_array = new Array();
      	var to_do_rece_prod_quan_array = new Array();
      	var rowCnt = jq("#list").getGridParam('reccount');
      	if(rowCnt>0) {
      		var arrRowIdx = 0 ;
      		for(var i=0; i<rowCnt; i++) {
      			var rowid = $("#list").getDataIDs()[i];
      			jq("#list").restoreRow(rowid);
      			if (jq("#isCheck_"+rowid).attr("checked")) {
      			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
      			    orde_iden_numb_array[arrRowIdx] = selrowContent.orde_iden_numb;
      			    purc_iden_numb_array[arrRowIdx] = selrowContent.purc_iden_numb;
      			    deli_iden_numb_array[arrRowIdx] = selrowContent.deli_iden_numb;
      			    deli_prod_quan_array[arrRowIdx] = selrowContent.deli_prod_quan;
      			    to_do_rece_prod_quan_array[arrRowIdx] = selrowContent.to_do_rece_prod_quan;
      				arrRowIdx++;
      			}
      		}
      		if (arrRowIdx == 0 ) {
      			jq("#dialogSelectRow").dialog();
      			return; 
      		}
      		$.post(
      			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/firstPurchaseHandleTransGrid.sys",
      			{  
      				orde_iden_numb_array:orde_iden_numb_array 
      			,	purc_iden_numb_array:purc_iden_numb_array 
      			,	deli_iden_numb_array:deli_iden_numb_array 
      			,	to_do_rece_prod_quan_array:to_do_rece_prod_quan_array
      			,	deli_prod_quan_array:deli_prod_quan_array
      			}
      			,function(arg){ 
      				if(fnAjaxTransResult(arg)) {	
      					alert("정상적으로 실인수처리가 되었습니다.");
      					jq("#list").trigger("reloadGrid");
      				}
      			}
      		);
      	}
	}
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
							<td height="29" class='ptitle'>선발주 실 인수처리</td>
							<td align="right" class='ptitle'>
								<img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22"  style='border: 0;cursor: pointer;vertical-align:middle;'/>
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
							<td class="table_td_subject" style="width: 100px">고객사</td>
							<td class="table_td_contents" style="width: 400px">
								<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 350px" />
		                        <input id="srcGroupId" name="srcGroupId" type="hidden" value="" style="width: 0px"/>
		                        <input id="srcClientId" name="srcClientId" type="hidden" value="" style="width: 0px"/>
		                        <input id="srcBranchId" name="srcBranchId" type="hidden" value="" style="width: 0px"/>
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
							<td class="table_td_subject" width="100">주문번호</td>
							<td class="table_td_contents">
							<input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="20" maxlength="30" />
							</td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">주문기간</td>
							<td class="table_td_contents">
								<input type="text" name="srcOrderStartDate" id="srcOrderStartDate" style="width: 75px;vertical-align: middle;" /> 
									~ 
								<input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" />
							</td>
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
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td align="right">
                    <a href="javascript:fnFirstPurcReceQuan();">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_receiptProcess.gif" width="86" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
                    </a>
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
</form>
</body>
</html>