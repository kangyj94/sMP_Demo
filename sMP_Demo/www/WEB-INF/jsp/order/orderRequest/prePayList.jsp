<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%
	String              _menuId         = CommonUtils.getRequestMenuId(request); //그리드의 width와 Height을 정의
	String              listHeight      = "$(window).height()-360 + Number(gridHeightResizePlus)";
	String              listWidth       = "1500";
	String              orderStartDate	= CommonUtils.getCustomDay("DAY", -3); // 날짜 세팅
	String              orderEndDate    = CommonUtils.getCurrentDate();
	List<CodesDto>      orderStatusList = (List<CodesDto>)request.getAttribute("orderStatusList"); //주문유형
	@SuppressWarnings("unchecked")
	List<SmpUsersDto>   workInfoList    = (List<SmpUsersDto>)request.getAttribute("workInfoList");
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList        = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	LoginUserDto        loginUserDto    = CommonUtils.getLoginUserDto(request);
	
	String prePayType = CommonUtils.getString(request.getParameter("prePayType"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
.jqmPrePayWindow {
	display: none;
	position: fixed;
	top: 17%;
	left: 50%;
	margin-left: -300px;
	width: 650px;
	background-color: #EEE;
	color: #333;
	border: 1px solid black;
	padding: 12px;
}

.prePayBorg_contents{
	font-weight:bold;
	padding-left:20px;
	padding-right:20px;
/* 	height:25px; */
	padding-top:4px;
	border-left: solid 1px #ccc;
	border-right: solid 1px #ccc;
	border-bottom: solid 1px #ccc;
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
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	// 날짜 세팅
	$("#orderStartDate").val("<%=orderStartDate%>");
	$("#orderEndDate").val("<%=orderEndDate%>");
	
	// 날짜 조회 및 스타일
	$(function(){
		$("#orderStartDate").datepicker({
			showOn: "button",
			buttonImage: "/img/system/btn_icon_calendar.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		});
		$("#orderEndDate").datepicker({
			showOn: "button",
			buttonImage: "/img/system/btn_icon_calendar.gif",
			buttonImageOnly: true,
			dateFormat: "yy-mm-dd"
		});
		$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	});
	
	$("#popPrePayBranch").jqm();
	
	//버튼이벤트
	$("#srcButton").click(function(){ fnSearch(); });
	$("#prePayBranchListBtn").click(function(){ prePayBranchList(); });	//선입금현황 업체 팝업
	$("#borgNmBtn").click(function(){ fnborgNmSearch(); });				//선입금업체 검색
	$("#prePayPurcBtn").click(function(){ fnPrePayPurcReceive(); });	//선입금업체 발주처리
	$("#allExcelButton").click(function(){ fnAllExcelPrintDown();	});
	
	<%-- 엔터 키 이벤트 --%>
	$("#orderStartDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#orderEndtDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#prePayType").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#orderStatusFlag").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
	$("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>
<script type="text/javascript">
$(function() {
	<%-- 선입금 리스트 --%>
	$("#list").jqGrid({
		url:'/order/orderRequest/getAdmPrePayList.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			"<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",	'주문일',			'납품요청일',		'납품예정일',			'고객유형',
			'공사담당자',																							'주문번호',		'주문명',			'주문유형',			'여신',
			'선입금',																								'주문상태',		'구매사',			'주문자',				'공급사',
			'공급사 전화번호',																						'상품명',			'규격',			'판매단가',			'수량',
			'판매금액',																							'매입단가',		'매입금액',		'긴급여부',			'vendorid',
			'good_iden_numb',																					'branchId',		'is_add_good',	'orde_iden_numb',	'orde_sequ_numb',
			'order_status',																						'ISDISTRIBUTE'
		],
		colModel:[
			{name:'isCheck',          index:'isCheck',           width:30,  align:"center", search:false, sortable:false, editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}, formatter:checkboxFormatter,frozen:true},
			{name:'REGI_DATE_TIME',   index:'REGI_DATE_TIME',    width:100, align:"center", search:false, sortable:true,  editable:false, sorttype:"date",                                             formatter:"date"},//주문일자
			{name:'REQU_DELI_DATE',   index:'REQU_DELI_DATE',    width:70,  align:"center", search:false, sortable:true,  editable:false, sorttype:"date",                                             formatter:"date"},//납품요청일
			{name:'DELI_SCHE_DATE',   index:'DELI_SCHE_DATE',    width:70,  align:"center", search:false, sortable:true,  editable:false},				//납품예정일
			{name:'WORKNM',           index:'WORKNM',            width:100, align:"center", search:false, sortable:true,  editable:false},							//고객유형
			
			{name:'WORKUSER',         index:'WORKUSER',          width:60,  align:"center", search:false, sortable:true,  editable:false},							//공사담당자
			{name:'ORDER_NUMB',       index:'ORDER_NUMB',        width:110, align:"left",   search:false, sortable:true,  editable:false, key:true},				//주문번호
			{name:'CONS_IDEN_NAME',   index:'CONS_IDEN_NAME',    width:120, align:"left",   search:false, sortable:true,  editable:false },				//주문명
			{name:'ORDE_TYPE_CLAS',   index:'ORDE_TYPE_CLAS',    width:50,  align:"center", search:false, sortable:true,  editable:false ,hidden:true},			//주문유형
			{name:'LOAN_YN',          index:'LOAN_YN',           width:40,  align:"center", search:false, sortable:true,  editable:false },							//여신여부
			
			{name:'PREPAY_YN',        index:'PREPAY_YN',         width:40,  align:"center", search:false, sortable:true,  editable:false },						//선입금여부
			{name:'ORDER_STATUS',     index:'ORDER_STATUS',      width:100, align:"center", search:false, sortable:true,  editable:false },		//주문상태
			{name:'ORDE_CLIENT_NAME', index:'ORDE_CLIENT_NAME',  width:200, align:"left",   search:false, sortable:true,  editable:false },		//구매사
			{name:'ORDE_USER_NAME',   index:'ORDE_USER_NAME',    width:50,  align:"center", search:false, sortable:true,  editable:false},				//주문자
			{name:'VENDOR_NAME',      index:'VENDOR_NAME',       width:120, align:"left",   search:false, sortable:true,  editable:false},					//공급사
			
			{name:'PHONENUM',         index:'PHONENUM',          width:90,  align:"center", search:false, sortable:true,  editable:false},							//공급사 전화번호
			{name:'GOOD_NAME',        index:'GOOD_NAME',         width:140, align:"left",   search:false, sortable:true,  editable:false },						//상품명
			{name:'GOOD_SPEC',        index:'GOOD_SPEC',         width:140, align:"left",   search:false, sortable:true,  editable:false },				//상품규격
			{name:'SELL_PRICE',       index:'SELL_PRICE',        width:70,  align:"right",  search:false, sortable:true,  editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},								//판매단가
			{name:'ORDE_REQU_QUAN',   index:'ORDE_REQU_QUAN',    width:70,  align:"right",  search:false, sortable:true,  editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},								//수량
			
			{name:'TOTAL_SELL_PRICE', index:'TOTAL_SELL_PRICE',  width:80,  align:"right",  search:false, sortable:true,  editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},								//판매금액
			{name:'SALE_UNIT_PRIC',   index:'SALE_UNIT_PRIC',    width:80,  align:"right",  search:false, sortable:true,  editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},								//매입단가
			{name:'TOTAL_SALE_PRICE', index:'TOTAL_SALE_PRICE',  width:80,  align:"right",  search:false, sortable:true,  editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},								//매입금액
			{name:'EMER_ORDE_CLAS',   index:'EMER_ORDE_CLAS',    hidden:true},			//긴급여부
			{name:'VENDORID',         index:'VENDORID',          hidden:true},									//공급사ID
			
			{name:'GOOD_IDEN_NUMB',   index:'GOOD_IDEN_NUMB',    hidden:true},
			{name:'BRANCHID',         index:'BRANCHID',          hidden:true},//사업장ID
			{name:'IS_ADD_GOOD',      index:'IS_ADD_GOOD',       hidden:true},//is_add_good
			{name:'ORDE_IDEN_NUMB',   index:'ORDE_IDEN_NUMB',    hidden:true},		//주문번호
			{name:'ORDE_SEQU_NUMB',   index:'ORDE_SEQU_NUMB',    hidden:true},		//주문차수
			
			{name:'ORDER_STATUS_FLAG',index:'ORDER_STATUS_FLAG', hidden:true},			//주문상태
			{name:'ISDISTRIBUTE',     index:'ISDISTRIBUTE',      hidden:true}				//물량배분 여부
		],
		postData: {
			orderStartDate  : $("#orderStartDate").val(), //주문일
			orderEndDate    : $("#orderEndDate").val(), //주문일
			orderStatusFlag : $("#orderStatusFlag").val(), //주문상태
			prePayType      : $("#prePayType").val(), //유형
			srcGroupId      : $("#srcGroupId").val(),
			
			srcClientId     : $("#srcClientId").val(),
			srcBranchId     : $("#srcBranchId").val(),
			srcWorkInfoUser : $("#srcWorkInfoUser").val()
		},
		rowNum:30, rownumbers: true, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'regi_date_time', sortorder: "desc",
		loadui: 'disable',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, 
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			var tempPric = "";
			
			if(rowCnt == 0){
				$("#total_sum_pric").html(tempPric);
			}
			else{
				var userdata       = $("#list").getGridParam('userData');
				var ordeRequQuan   = userdata.ordeRequQuan;
				var totalSellPrice = userdata.totalSellPrice;
				var total_record   = fnComma(Number($("#list").getGridParam('records')));
				
				tempPric = "<b>총 "+total_record+" 건의 주문 총수량 : " + ordeRequQuan + " , 금액 합계 : "+ totalSellPrice+" 원 </b>";
				
				$("#total_sum_pric").html(tempPric);
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow: function(rowid, aData){
			//주문번호
			$("#list").setCell(rowid,'ORDER_NUMB','',{color:'#0000ff'});
			$("#list").setCell(rowid,'ORDER_NUMB','',{cursor: 'pointer'});
			//구매사
			$("#list").setCell(rowid,'ORDE_CLIENT_NAME','',{color:'#0000ff'});
			$("#list").setCell(rowid,'ORDE_CLIENT_NAME','',{cursor: 'pointer'});
			//공급사
			$("#list").setCell(rowid,'VENDOR_NAME','',{color:'#0000ff'});
			$("#list").setCell(rowid,'VENDOR_NAME','',{cursor: 'pointer'});
			//상품명
			$("#list").setCell(rowid,'GOOD_NAME','',{color:'#0000ff'});
			$("#list").setCell(rowid,'GOOD_NAME','',{cursor: 'pointer'});
			
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			//주문 상세
			if(colName != undefined &&colName['index']=="ORDER_NUMB") { 
				if(colName != undefined &&colName['index']=="ORDER_NUMB") { 
					<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> 
				}
			}
			//구매사 상세
			if(colName != undefined &&colName['index']=="ORDE_CLIENT_NAME") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.BRANCHID);")%>
			}
			//공급사 상세
			if(colName != undefined &&colName['index']=="VENDOR_NAME") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.VENDORID);")%>
			}
			//상품상세
			if(colName != undefined &&colName['index']=="GOOD_NAME") { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnPopProductDetail("+_menuId+", selrowContent.GOOD_IDEN_NUMB, selrowContent.VENDORID);")%>
			}
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell", userdata:"userdata"}
	});
    jQuery("#list").jqGrid('setFrozenColumns');
	
	<%-- 선입금 업체 현황 --%>
	$("#prePayBorgList").jqGrid({
		url:'/order/orderRequest/selectPrePayBranchList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['사업자등록번호','업체명','고객유형','주문제한','종료'],
		colModel:[
			{name:'BUSINESSNUM',index:'BUSINESSNUM', width:150,align:"center",search:false, sortable:true, editable:false},	//사업자등록번호
			{name:'BRANCHNM',index:'BRANCHNM', width:130,align:"center",search:false, sortable:true, editable:false},	//업체명
			{name:'WORKNM',index:'WORKNM', width:130,align:"center",search:false, sortable:true, editable:false},	//고객유형
			{name:'ISORDERLIMIT',index:'ISORDERLIMIT', width:70,align:"center",search:false, sortable:true, editable:false},	//주문제한
			{name:'ISUSE',index:'ISUSE', width:70,align:"center",search:false, sortable:true, editable:false},	//종료
			
		],
		postData: {
			borgNm:$("#borgNm").val()
		},
		rowNum:15, rownumbers: true, rowList:[15,30,50], pager: '#prePayBorgPager',
		width:605,
		sortname: 'branchnm', sortorder: "desc",
		loadui: 'disable',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, 
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow: function(rowid, aData){},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){alert("에러가 발생하였습니다.");},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
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
		jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>').appendTo('body').submit().remove();
	}
};

function checkboxFormatter(cellvalue, options, rowObject) {
	var rtnStr = "";
	var tmpBoolean = true;
	if(rowObject.ISDISTRIBUTE == "1" || rowObject.ORDER_STATUS_FLAG != "10") tmpBoolean = false;
	if(tmpBoolean) rtnStr ="<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;' onclick=\"fnIsChecked('"+options.rowId+"')\" />";
	return  rtnStr;
}
function fnIsChecked(rowid){
	if($("#isCheck_" + rowid ).prop("checked") == true){
		$("#isCheck_" + rowid ).prop("checked",false);
	}else{
		$("#isCheck_" + rowid ).prop("checked",true);
	}
}

function fnSearch(){
	var data = $("#list").jqGrid("getGridParam", "postData");
	
	data.orderStartDate  = $("#orderStartDate").val();
	data.orderEndDate    = $("#orderEndDate").val();
	data.orderStatusFlag = $("#orderStatusFlag").val();
	data.prePayType      = $("#prePayType").val();
	data.srcWorkInfoUser = $("#srcWorkInfoUser").val();
	data.srcGroupId      = $("#srcGroupId").val();
	data.srcClientId     = $("#srcClientId").val();
	data.srcBranchId     = $("#srcBranchId").val();
	
	$("#list").jqGrid("setGridParam", { "postData": data, "page":1 });
	$("#list").trigger("reloadGrid");
}

<%-- 일괄 엑셀 다운로드 --%>
function fnAllExcelPrintDown(){
	var colLabels = [	'주문일',		'납품요청일',		'납품예정일',	'고객유형',			'공사담당자',																							
	                 	'주문번호',		'주문명',			'여신',			'선입금',			'주문상태',		
	                 	'구매사',		'주문자',			'공급사',		'공급사 전화번호',	'상품명',		
	                 	'규격',			'판매단가',			'수량',			'판매금액',			'매입단가',		
	                 	'매입금액'
	                 ];
	var colIds =[	'REGI_DATE_TIME',  	'REQU_DELI_DATE',  'DELI_SCHE_DATE',  'WORKNM',         	'WORKUSER',        
	             	'ORDER_NUMB',      	'CONS_IDEN_NAME',  'LOAN_YN',         'PREPAY_YN',      	'ORDER_STATUS',    
	             	'ORDE_CLIENT_NAME',	'ORDE_USER_NAME',  'VENDOR_NAME',     'PHONENUM',        	'GOOD_NAME',       
	             	'GOOD_SPEC',       	'SELL_PRICE',      'ORDE_REQU_QUAN',  'TOTAL_SELL_PRICE',	'SALE_UNIT_PRIC',  
	             	'TOTAL_SALE_PRICE'
	             ]; 
	var numColIds = ['SELL_PRICE','ORDE_REQU_QUAN','TOTAL_SELL_PRICE','SALE_UNIT_PRIC','TOTAL_SALE_PRICE'];  //숫자표현ID
	var sheetTitle = "선입금,여신초과 주문처리";    //sheet 타이틀
	var excelFileName = "prePayList";    //file명
	
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'orderStartDate';
	fieldSearchParamArray[1] = 'orderEndDate';
	fieldSearchParamArray[2] = 'orderStatusFlag';
	fieldSearchParamArray[3] = 'prePayType';
	fieldSearchParamArray[4] = 'srcWorkInfoUser';
	fieldSearchParamArray[5] = 'srcGroupId';
	fieldSearchParamArray[6] = 'srcClientId';
	fieldSearchParamArray[7] = 'srcBranchId';
	
	
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/order/orderRequest/getAdmPrePayListExcel.sys");  
}



<%-- 선입금 현황 페이지 --%>
function prePayBranchList(){
	fnborgNmSearch();
	$("#popPrePayBranch").jqmShow();
}

function fnborgNmSearch() {
	jq("#prePayBorgList").jqGrid("setGridParam", {"page":1});
	var data = jq("#prePayBorgList").jqGrid("getGridParam", "postData");
	data.borgNm = $("#borgNm").val();
	jq("#prePayBorgList").jqGrid("setGridParam", { "postData": data });
	jq("#prePayBorgList").trigger("reloadGrid");
}


<%-- 선입금 주문 주문의뢰 상태로 변경 --%>
function fnPrePayPurcReceive(){
	var orde_iden_numb_array	= new Array();
	var orde_sequ_numb_array	= new Array();
	var rowCnt = $("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if($("#isCheck_"+rowid).attr("checked")) {
				var selrowContent = $("#list").jqGrid('getRowData',rowid);
				if(selrowContent.ORDER_STATUS_FLAG != '10'){
					alert(selrowContent.GOOD_NAME+" 주문의 주문상태를 확인해 주세요.");
					$("#list").trigger("reloadGrid");
					return;
				}
				orde_iden_numb_array[arrRowIdx]	= selrowContent.ORDE_IDEN_NUMB;
				orde_sequ_numb_array[arrRowIdx]	= selrowContent.ORDE_SEQU_NUMB;
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			$("#dialogSelectRow").dialog();
			return; 
		}
		if(!confirm("선택된 주문 정보를 주문의뢰 하시겠습니까?")) return;
		$.post(
			"/order/purchase/prePayPurcReceive.sys",
			{
				orde_iden_numb_array:orde_iden_numb_array,
				orde_sequ_numb_array:orde_sequ_numb_array
			},
			function(arg){
				var result = arg.customResponse;
				if(result.success == false) {
					alert(result.message);
					$("#list").trigger("reloadGrid");
				}else{
					alert("처리 했습니다.");
					$("#list").trigger("reloadGrid");
				}
			},
			"json"
		);
	}
}
<%-- 상품상세 팝업 --%>
function fnPopProductDetail(menuId, goodIdenNumb, vendorId){
	var url = '/product/popProductAdm.sys?_menuId='+menuId+'&good_iden_numb=' + goodIdenNumb + '&vendorid=' + vendorId;
	window.open(url, 'okplazaPop', 'width=917, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>선입금/여신초과 주문처리</td>
					<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
						<button id='prePayBranchListBtn' class='btn btn-primary btn-sm' style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">선입금 업체 현황</button>
						<button id='allExcelButton' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table>
			<table width="1500px" style="margin-left: 0px;"  border="0" cellspacing="0" cellpadding="0">
				<colgroup>
						<col width="100px" />
						<col width="400px" />
						<col width="100px" />
						<col width="400px" />
						<col width="100px" />
						<col width="400px" />
				</colgroup>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject">구매사</td>
					<td class="table_td_contents">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 85%" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<a href="javascript:void(0);">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
					<td class="table_td_subject">유형</td>
					<td class="table_td_contents">
						<select id="prePayType" name="prePayType" class="select">
							<option value="0">전체</option>
							<option value="1">여신여부</option>
							<option value="2" <%=("2".equals(prePayType)) ? "selected" : "" %>>선입금여부</option>
						</select>
					</td>
					<td class="table_td_subject">주문상태</td>
					<td class="table_td_contents">
						<select id="orderStatusFlag" name="orderStatusFlag" class="select">
							<option value="">전체</option>
<%
	for(int i=0; i<orderStatusList.size(); i++){
%>
							<option value="<%=orderStatusList.get(i).getCodeNm1()%>" <%if("주문요청".equals(orderStatusList.get(i).getCodeNm1())){out.print("selected=\"selected\"");} %>  ><%=orderStatusList.get(i).getCodeNm1()%></option>
<%
	}
%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject">주문일</td>
					<td class="table_td_contents">
						<input type="text" name="orderStartDate" id="orderStartDate" style="width: 75px;vertical-align: middle;" /> 
						~ 
						<input type="text" name="orderEndDate" id="orderEndDate" style="width: 75px;vertical-align: middle;" />
					</td>
					<td class="table_td_subject">공사담당자</td>
					<td class="table_td_contents" colspan="4">
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
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='5'></td>
				</tr>
			</table>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" valign="bottom">
						<span id="total_sum_pric"></span>&nbsp;
						<button id='prePayPurcBtn' class='btn btn-danger btn-xs' >발주처리</button>
					</td>
				</tr>
				<tr><td height="1"></td></tr>
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
<div id="popPrePayBranch" name="popPrePayBranch" class="jqmPrePayWindow">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="width:500px;">
		<tr>
			<td>
				<div id="vendorDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
						<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-size: 17px;font-weight: 700;">
		        				<h3>선입금 업체 현황</h3>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<table width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td colspan="3" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="3" height='1'></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="100px">
										업체명
									</td>
									<td class="prePayBorg_contents" width="370px"  style="border: 0px; padding-top: 0px;">
										<input type="text" id="borgNm" name="borgNm" size="60" style="margin-top: 0px;"/>
									</td>
									<td align="right">
									<a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcVendorDivButton" name="srcVendorDivButton"/></a>
									</td>
								</tr>
								<tr>
									<td colspan="3" height='1'></td>
								</tr>
								<tr>
									<td colspan="3" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="3" height='10'></td>
								</tr>
								<tr>
									<td colspan="3">
										<div id="jqgrid">
											<table id="prePayBorgList"></table>
											<div id="prePayBorgPager"></div>
										</div>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</form>
</body>
</html>