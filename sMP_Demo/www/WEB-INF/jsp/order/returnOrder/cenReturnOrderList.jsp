<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-255 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
    boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
    boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	// 날짜 세팅
	String srcReturnStartDate = CommonUtils.getCustomDay("MONTH", -1);
	String srcReturnEndDate = CommonUtils.getCurrentDate();
   
	@SuppressWarnings("unchecked")	
	List<CodesDto> returnTypeCode = (List<CodesDto>)request.getAttribute("returnTypeCode");
    
    boolean isCen = request.getAttribute("isCen") == null ? false : true;
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
<%	if("BUY".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcBorgName").attr("disabled", true);
	$("#btnBuyBorg").css("display","none");
<%	}	%>
	
	$("#btnBuyBorg").click(function(){
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("BCH", "1", borgNm, "fnCallBackBuyBorg"); 
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

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click( function() { 
		$("#srcOrdeIdenNumb").val($.trim($("#srcOrdeIdenNumb").val()));
		fnSearch(); 
	});
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	// 날짜 세팅
	$("#srcReturnStartDate").val("<%=srcReturnStartDate%>");
	$("#srcReturnEndDate").val("<%=srcReturnEndDate%>");

});

// 날짜 조회 및 스타일
$(function(){
	$("#srcReturnStartDate").datepicker(
       	{
	   		showOn: "button",
	   		buttonImage: "/img/system/btn_icon_calendar.gif",
	   		buttonImageOnly: true,
	   		dateFormat: "yy-mm-dd"
       	}
	);
	$("#srcReturnEndDate").datepicker(
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/venReturnOrderListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['선택','반품번호', '반품사유', '고객사', '주문번호', '발주차수', '출하차수','상품명', '단가', '주문수량', '주문금액', '인수수량', '반품요청수량', '반품상태', 'vendorid', 'good_iden_numb'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
			{name:'retu_iden_num',index:'retu_iden_num', width:60,align:"center",search:false,sortable:true, editable:false  ,sorttype:'integer'},
			{name:'retu_rese_text',index:'retu_rese_text', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_client_name',index:'orde_client_name', width:200,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'purc_iden_numb',index:'purc_iden_numb', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'deli_iden_numb',index:'deli_iden_numb', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'sale_unit_pric',index:'sale_unit_pric', width:70,align:"right",search:false,sortable:true, editable:false  ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'orde_requ_quan',index:'orde_requ_quan', width:70,align:"right",search:false,sortable:true, editable:false  ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'tot_sale_pric',index:'tot_sale_pric', width:90,align:"right",search:false,sortable:true, editable:false  ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'rece_prod_quan',index:'rece_prod_quan', width:70,align:"right",search:false,sortable:false, editable:false  ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'retu_prod_quan',index:'retu_prod_quan', width:80,align:"right",search:false,sortable:false, editable:false  ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'retu_stat_flag',index:'retu_stat_flag', width:70,align:"center",search:false,sortable:false, editable:false },
			{name:'vendorid',index:'vendorid',hidden:true,search:false,sortable:false, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb',hidden:true,search:false,sortable:false, editable:false }
		],
		postData: {
<%if(!isCen){%>			
			srcVendorId:"<%=loginUserDto.getBorgId()%>",
<%}%>
			srcReturnStartDate:$('#srcReturnStartDate').val(),
			srcReturnEndDate:$('#srcReturnEndDate').val()
<%if(isCen){%>			
			,srcIsCen:'1'
<%}%>
		},multiselect: false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		sortname: 'retu_iden_num', sortorder: "desc",
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		caption:"반품요청내역", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
        afterInsertRow: function(rowid, aData){
     		jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'});  
     		jq("#list").setCell(rowid,'retu_iden_num','',{color:'#0000ff'});
     		jq("#list").setCell(rowid,'retu_iden_num','',{cursor: 'pointer'});  
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="retu_iden_num") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderRetrunDetailView(cellcontent);")%> }
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
            if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%}else if(isAdm){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorid);")%> }
<%} %>
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"} 
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function checkboxFormatter(cellvalue, options, rowObject) {
	var checkBox = "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;' />";
	if("요청"!=rowObject.retu_stat_flag){
      	checkBox = "";
	}
	return checkBox;
}

function exportExcel() {
	var colLabels = ['반품번호', '반품사유', '고객사', '주문번호', '발주차수', '출하차수','상품명', '단가', '주문수량', '주문금액', '인수수량', '반품요청수량', '반품상태'];
	var colIds = ['retu_iden_num', 'retu_rese_text', 'orde_client_name', 'orde_iden_numb', 'purc_iden_numb', 'deli_iden_numb', 'good_name', 'sale_unit_pric', 'orde_requ_quan', 'tot_sale_pric', 'rece_prod_quan', 'retu_prod_quan' ,'retu_stat_flag'];
	var numColIds = ['sale_unit_pric', 'orde_requ_quan', 'tot_sale_pric', 'rece_prod_quan', 'retu_prod_quan' ];
	var sheetTitle = "반품처리_이력";	//sheet 타이틀
	var excelFileName = "vendorReturnOrderList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/*
 * 리스트 조회
 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcOrdeIdenNumb= $("#srcOrdeIdenNumb").val();
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcVendorId = $("#srcVendorId").val();
	data.srcReturnStartDate = $("#srcReturnStartDate").val();
	data.srcReturnEndDate = $("#srcReturnEndDate").val();
	data.srcReturnStatFlag = $("#srcReturnStatFlag").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

// 수탁상품 반품승인
function orderReturnApproval(){
	var orde_iden_numb_array = new Array();
	var purc_iden_numb_array = new Array();
	var deli_iden_numb_array = new Array();
	var return_iden_numb_array = new Array();
	var retu_prod_quan_array = new Array();
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
			    return_iden_numb_array[arrRowIdx] = selrowContent.retu_iden_num;
			    retu_prod_quan_array[arrRowIdx] = selrowContent.retu_prod_quan;
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
		if(!confirm("선택된 반품요청 정보를 승인처리 하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/cenOrderReturnApprovalTransGrid.sys",
			{  
				orde_iden_numb_array:orde_iden_numb_array 
			,	purc_iden_numb_array:purc_iden_numb_array 
			,	deli_iden_numb_array:deli_iden_numb_array 
			,	return_iden_numb_array:return_iden_numb_array 
			,	retu_prod_quan_array:retu_prod_quan_array 
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
function orderReturnReject(){
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
	if(confirm("선택된 반품요청 정보를 반려처리하시겠습니까?")){
      	fnStatChangeReasonDialog("processOrderReturnReject");
	}
}
function processOrderReturnReject(reason){
	var return_iden_numb_array = new Array(); 
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
			    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			    return_iden_numb_array[arrRowIdx] = selrowContent.retu_iden_num;
				arrRowIdx++;
			}
		}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/venOrderReturnRejectTransGrid.sys",
			{  return_iden_numb_array:return_iden_numb_array 
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
function processOrderReturnReject_cancel(){}

function fnOrderRetrunDetailView(str1){
   	var popurl = "/order/returnOrder/venReturnOrderRegistDetail.sys?retu_iden_num=" + str1
   	var popproperty = "dialogWidth:800px;dialogHeight=330px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);  
    window.open(popurl, 'okplazaPop', 'width=800, height=330, scrollbars=yes, status=no, resizable=no');
}
</script>

</head>
<body>
<form id="frm" name="frm">
<input type="hidden" id="srcVendorId" name="srcVendorId" value="<%=loginUserDto.getBorgId()%>"/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="29" class='ptitle'>반품처리/이력</td>
							<td align="right" class='ptitle'><img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style="cursor: pointer;"/></td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
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
							<td width="100" class="table_td_subject">고객사</td>
							<td colspan="5" class="table_td_contents">
                                 <input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 350px" />
                                 <input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
                                 <input id="srcClientId" name="srcClientId" type="hidden" value=""/>
                                 <input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
            					 <a href="#"> <img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" /> </a>
                            </td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject">반품요청일</td>
							<td class="table_td_contents">
                              <input type="text" name="srcReturnStartDate" id="srcReturnStartDate" style="width: 75px;vertical-align: middle;" /> 
                              ~ 
                              <input type="text" name="srcReturnEndDate" id="srcReturnEndDate" style="width: 75px;vertical-align: middle;" />
                            </td>
							<td width="100" class="table_td_subject">주문번호</td>
							<td class="table_td_contents"><input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="20" maxlength="30" /></td>
							<td width="100" class="table_td_subject">반품처리상태</td>
							<td class="table_td_contents">
                              <select id="srcReturnStatFlag" name="srcReturnStatFlag" class="select">
									<option value="">전체</option>
<%if(returnTypeCode.size() > 0){ 
   for(CodesDto cd : returnTypeCode){
%>                              
									<option value="<%=cd.getCodeVal1()%>"><%=cd.getCodeNm1() %></option>
<%}} %>                              
							  </select>
                            </td>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td align="right">
                        <a href="javascript:orderReturnApproval();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_return_approval.jpg" width="62" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
                        <a href="javascript:orderReturnReject();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_return_reject.jpg" width="62" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
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
<%@ include file="/WEB-INF/jsp/common/svcStatChangeReasonDiv.jsp" %>
</form>
</body>
</html>