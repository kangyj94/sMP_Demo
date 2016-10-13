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
	String listHeight = "$(window).height()-247+ Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	// 주문유형
	List<CodesDto> orderTypeCode = (List<CodesDto>)request.getAttribute("orderTypeCode");
   
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	// 날짜 세팅
	String srcGoodRegiDateStart = CommonUtils.getCustomDay("MONTH", -1);
	String srcGoodRegiDateEnd = CommonUtils.getCurrentDate();
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
	
	$("#srcGoodNm").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcGoodIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcButton").click(function(){ 
		$("#srcGoodNm").val($.trim($("#srcGoodNm").val()));
		$("#srcGoodIdenNumb").val($.trim($("#srcGoodIdenNumb").val()));
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcGoodRegiDateStart").val($.trim($("#srcGoodRegiDateStart").val()));
		$("#srcGoodRegiDateEnd").val($.trim($("#srcGoodRegiDateEnd").val()));
		fnSearch(); 
	});
	
	// 날짜 세팅
	$("#srcGoodRegiDateStart").val("<%=srcGoodRegiDateStart%>");
	$("#srcGoodRegiDateEnd").val("<%=srcGoodRegiDateEnd%>");
	
   // 날짜 조회 및 스타일
   $(function(){
   	$("#srcGoodRegiDateStart").datepicker(
          	{
   	   		showOn: "button",
   	   		buttonImage: "/img/system/btn_icon_calendar.gif",
   	   		buttonImageOnly: true,
   	   		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("#srcGoodRegiDateEnd").datepicker(
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/cenStockCntSearchJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['상품명',  '상품규격','상품코드', '공급사명','재고수량', '매입단가',  '등록일자', '입고내역', 'vendorid','good_St_Spec_Desc'],
		colModel:[
			{name:'good_Name',index:'good_Name', width:180,align:"left",search:false,sortable:true, editable:false },
			{name:'good_Spec_Desc',index:'good_Spec_Desc', width:180,align:"left",search:false,sortable:true, editable:false },
			{name:'good_Iden_Numb',index:'good_Iden_Numb', width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'vendorNm',index:'vendorNm', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'good_Inventory_Cnt',index:'good_Inventory_Cnt', width:90,align:"right",search:false,sortable:true, editable:false, formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'sale_Unit_Pric',index:'sale_Unit_Pric', width:90,align:"right",search:false,sortable:true, editable:false, formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'regist_Date',index:'regist_Date', width:90,align:"center",search:false,sortable:true, editable:false },
			{name:'상품삭제',index:'상품삭제', width:70,align:"center",search:false,sortable:false, editable:false,formatter:detailButton},
			{name:'vendorId',index:'vendorId', hidden:true},
			{name:'good_St_Spec_Desc',index:'good_St_Spec_Desc',hidden:true}
		],  
		postData: {
			srcGoodRegiDateStart:$("#srcGoodRegiDateStart").val(),
			srcGoodRegiDateEnd:$("#srcGoodRegiDateEnd").val()
		},multiselect:false ,
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		sortname: 'regist_date', sortorder: "asc",
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		caption:"수탁상품 재고조회", 
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
                var argStArray = selrowContent.good_St_Spec_Desc.split("‡");
                var argArray = selrowContent.good_Spec_Desc.split("‡");
                
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
                jQuery('#list').jqGrid('setRowData',rowid,{good_Spec_Desc:prodStSpec});
            }
		},
        afterInsertRow: function(rowid, aData){ },
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="good_Name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_Iden_Numb, selrowContent.vendorId);")%> }
		},
        afterInsertRow: function(rowid, aData){
     		jq("#list").setCell(rowid,'good_Name','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'good_Name','',{cursor: 'pointer'});  
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
function detailButton(cellValue, options, rowObject){
	var str = "<input type='button' value='재고내역' onclick='javascript:fnDetailPop("+rowObject.good_Iden_Numb+",\""+rowObject.vendorId+"\");'>";
	return str;
}
function fnDetailPop(str1, str2){
   	var popurl = "/product/cenStockCntSearchPop.sys?good_iden_numb=" + str1 + "&vendorid=" + str2;
   	var popproperty = "dialogWidth:500px;dialogHeight=520px;scroll=no;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);
   	window.open(popurl, 'okplazaPop', 'width=500, height=520, scrollbars=yes, status=no, resizable=no');
}
function fnSearch(){
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcGoodNm= $("#srcGoodNm").val();
	data.srcGoodIdenNumb= $("#srcGoodIdenNumb").val();
	data.srcGoodRegiDateStart= $("#srcGoodRegiDateStart").val();
	data.srcGoodRegiDateEnd= $("#srcGoodRegiDateEnd").val();
	data.srcVendorId= $("#srcVendorId").val();
	data.srcExistStock= $("#srcExistStock").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/** list Excel Export */
function exportExcel() {
	var colLabels = ['주문유형', '주문번호', '발주차수', '상품명', '상품규격', '발주의뢰일/주문일', '발주수량', '납품요청일', '배송처주소', '고객사', '주문자명', '인수자명', '첨부갯수', '공급사명'];
	var colIds = ['orde_type_clas', 'orde_iden_numb', 'purc_iden_numb', 'good_name', 'good_spec_desc', 'clin_date', 'purc_requ_quan', 'requ_deli_date', 'tran_data_addr', 'orde_client_name', 'orde_user_name', 'tran_user_name', 'attach_cnt', 'vendornm'];
	var numColIds = ['purc_iden_numb','purc_requ_quan', 'attach_cnt'];	
	var sheetTitle = "발주접수";	
	var excelFileName = "purchaseList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
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
							<td height="29" class='ptitle'>수탁상품 재고조회</td>
							<td align="right" class='ptitle'><img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style="cursor: pointer;"/></td>
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
							<td class="table_td_subject" width="100">상품명</td>
							<td class="table_td_contents">
                                 <input id="srcGoodNm" name="srcGoodNm" type="text" value="" size="" maxlength="50" style="width: 100px" />
                            </td>
							<td class="table_td_subject" width="100">상품코드</td>
							<td class="table_td_contents">
                                 <input id="srcGoodIdenNumb" name="srcGoodIdenNumb" type="text" value="" size="" maxlength="50" style="width: 100px" />
                            </td>
							<td width="100" class="table_td_subject">등록일자</td>
							<td class="table_td_contents">
                              <input type="text" name="srcGoodRegiDateStart" id="srcGoodRegiDateStart" style="width: 75px;vertical-align: middle;" /> 
                              ~ 
                              <input type="text" name="srcGoodRegiDateEnd" id="srcGoodRegiDateEnd" style="width: 75px;vertical-align: middle;" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
							<td width="100" class="table_td_subject">공급업체</td>
							<td class="table_td_contents">
                                <input id="srcVendorName" name="srcVendorName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
                                <input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
                                <a href="#">
                                <img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
                                </a>
                             </td>
							<td width="100" class="table_td_subject">재고 존재 여부</td>
							<td colspan="3" class="table_td_contents">
                              <select id="srcExistStock" name="srcExistStock" class="select" >
                                 <option value="">전체</option>
                                 <option value="1">재고있음</option>
                                 <option value="0">재고없음</option>
                              </select>
                            </td>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr style="height: 10px" > <td></td> </tr>
			<tr>
				<td align="right">
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