<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.adjust.dto.AdjustDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   //그리드의 width와 Height을 정의
   int listWidth = 700;
   String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   String listHeight = "$(window).height()-370 + Number(gridHeightResizePlus)";
   String list2Height = "$(window).height()-635 + Number(gridHeightResizePlus)";
   String list3Height = "$(window).height()-630 + Number(gridHeightResizePlus)";
   String list4Height = "$(window).height()-690 + Number(gridHeightResizePlus)";

   @SuppressWarnings("unchecked")
   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   AdjustDto detailInfo = (AdjustDto)request.getAttribute("detailInfo");
   AdjustDto priceInfo  = (AdjustDto)request.getAttribute("priceInfo");
   List<CodesDto> bondType = (List<CodesDto>)request.getAttribute("bondType");
   int EndYear   = 2003;
   int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
   int yearCnt = StartYear - EndYear + 1;
   String[] srcYearArr = new String[yearCnt];
   for(int i = 0 ; i < yearCnt ; i++){
      srcYearArr[i] = (StartYear - i) + "";
   }    
   LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
.jqmList2Window1 {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -370px;
    width: 720px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmList2Window2 {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -440px;
    width: 840px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmList2Window3 {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -290px;
    width: 540px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
</style>

<%
/**------------------------------------사용방법---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
------------------------------------------------------------------------------*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">

$(function(){
	// Dialog Button Event
	$('#list2Pop').jqm();	//Dialog 초기화
	$('#list3Pop').jqm();	//Dialog 초기화
	$('#historyPop').jqm();	//Dialog 초기화
	$("#list2CloseButton").click(function(){	//Dialog 닫기
		$("#list2Pop").jqmHide();
	});
	$("#list3CloseButton").click(function(){	//Dialog 닫기
		$("#list3Pop").jqmHide();
	});
	$("#hisCloseButton").click(function(){	//Dialog 닫기
		$("#historyPop").jqmHide();
	});
	$('#list2Pop').jqm().jqDrag('#dialogHandle1'); 
	$('#list3Pop').jqm().jqDrag('#dialogHandle2'); 
	$('#historyPop').jqm().jqDrag('#dialogHandle3'); 
	
	$("#phoneNum").val( fnSetTelformat( $("#phoneNum").val() ) );
});

var jq = jQuery;
$(document).ready(function() {
	
	$("#attachButton").click(function(){ fnUploadDialog("첨부파일", $("#attach_seq").val(), "fnCallBackAttach"); });

	$("#saveButton").click(function(){
		$("#manage_type").val("");
		$("#contents").val("");
		$("#attach_seq").val("");
		$("#attach_file_name").html("");
		$("#attach_file_path").val("");
		$("#hisSaveButton").show();
		$("#hisModButton").hide();
		$("#historyPop").jqmShow();
	});

	$("#modButton").click(function(){
		var id = $("#list4").jqGrid('getGridParam', "selrow" );
		
		if(id == null){
			alert("수정할 데이터를 선택해 주세요.");
			return;
		}
		
		var selrowContent = jq("#list4").jqGrid('getRowData',id);
		
		$("#manage_type").val(selrowContent.MANAGE_TYPE);
		$("#contents").val(selrowContent.CONTENTS);
		$("#attach_seq").val(selrowContent.ATTACH_SEQ == "0" ? "" : selrowContent.ATTACH_SEQ);
		$("#attach_file_name").html(selrowContent.FILE_NAME);
		$("#attach_file_path").val(selrowContent.FILE_PATH);
		$("#hisSaveButton").hide();
		$("#hisModButton").show();
		$("#historyPop").jqmShow();
	});

	$("#hisSaveButton").click(function(){
		var id = $("#list").jqGrid('getGridParam', "selrow" );
		var selrowContent = jq("#list").jqGrid('getRowData',id);
		
		var sale_sequ_numb 	= selrowContent.sale_sequ_numb;
		var manage_type 	= $.trim($("#manage_type").val());
		var contents 		= $.trim($("#contents").val());
		var attach_seq 		= $.trim($("#attach_seq").val());
		
		if(manage_type == ''){
			alert("관리유형을 선택해 주세요.");
			return;
		}
		
		if(contents == ''){
			alert("내용을 입력해 주세요.");
			return;
		}
		
		if(!confirm("채권관리 History 를 저장하시겠습니까?"))return;
		
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/saveBondsHistory.sys',
			{
				oper			: "add"			,
				sale_sequ_numb  : sale_sequ_numb,
				manage_type 	: manage_type	,
				contents 		: contents 	 	,
				attach_seq 		: attach_seq 
			},
			function(arg){
				if(fnAjaxTransResult(arg)) {
					$("#historyPop").jqmHide();
					fnBondsHistory(sale_sequ_numb, isOnLoad);
				}
			}
		);		
	});
	
	$("#hisModButton").click(function(){
		var id = $("#list").jqGrid('getGridParam', "selrow" );
		var selrowContent = jq("#list").jqGrid('getRowData',id);

		var id2 = $("#list4").jqGrid('getGridParam', "selrow" );
		var selrowContent2 = jq("#list4").jqGrid('getRowData',id2);
		
		var sale_sequ_numb 	= selrowContent.sale_sequ_numb;
		var manage_type 	= $.trim($("#manage_type").val());
		var contents 		= $.trim($("#contents").val());
		var attach_seq 		= $.trim($("#attach_seq").val());
		
		if(manage_type == ''){
			alert("관리유형을 선택해 주세요.");
			return;
		}
		
		if(contents == ''){
			alert("내용을 입력해 주세요.");
			return;
		}
		
		if(!confirm("채권관리 History 를 수정하시겠습니까?"))return;
	
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/saveBondsHistory.sys',
			{
				oper			: "mod"			,
				bond_manage_id  : selrowContent2.BOND_MANAGE_ID,
				sale_sequ_numb  : sale_sequ_numb,
				manage_type 	: manage_type	,
				contents 		: contents 	 	,
				attach_seq 		: attach_seq 
			},
			function(arg){
				if(fnAjaxTransResult(arg)) {
					$("#historyPop").jqmHide();
					fnBondsHistory(sale_sequ_numb, isOnLoad);
				}
			}
		);		
	});
	
	$("#sale_tota_amou").val($.number("<%=detailInfo.getSale_tota_amou()%>"));
	$("#balance_amou").val($.number("<%=detailInfo.getBalance_amou()%>"));   	
	$("#avg_day").val($.number("<%=detailInfo.getAvg_day()%>", 2));

	$("#none_clos_requ_pric").val($.number("<%=priceInfo.getNone_clos_requ_pric()%>"));
	$("#none_clos_purc_pric").val($.number("<%=priceInfo.getNone_clos_purc_pric()%>"));
	$("#none_clos_deli_pric").val($.number("<%=priceInfo.getNone_clos_deli_pric()%>"));
	$("#none_sale_prod_amou").val($.number("<%=priceInfo.getNone_sale_prod_amou()%>"));
	
	$("#srcButton").click(function(){fnSearch();});
	$("#regButton2").click(function(){fnAddBonds();});
	$("#delButton2").click(function(){fnDelBonds();});
	
	$("#excelButton").click(function(){ exportExcel(); });
	$("#regButton2").hide();
	$("#delButton2").hide();
});

$(window).bind('resize', function() {
   $("#list").setGridHeight(<%=listHeight %>);
   $("#list2").setGridHeight(<%=list2Height %>);
//    $("#list2").setGridWidth($(window).width() - 780 + Number(gridWidthResizePlus));
<%--    $("#list2").setGridHeight(<%=listHeight %>); --%>
   $("#list3").setGridWidth($(window).width() - 60 + Number(gridWidthResizePlus));
}).trigger('resize');

/**
 * 첨부파일 파일관리
 */
function fnCallBackAttach(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
// 	alert(rtn_attach_seq+" : "+rtn_attach_file_name+" : "+rtn_attach_file_path);
	$("#attach_seq").val(rtn_attach_seq);
	$("#attach_file_name").html("<b>" + rtn_attach_file_name + "</b>");
	$("#attach_file_path").val(rtn_attach_file_path);
}

function exportExcel() {
	var colLabels = ['전표번호','사업장명','계산서일자','결제만기일','주문제한일','총채권','입금일자','입금액','잔액','관리구분','지연 초과일','반제'];   //출력컬럼명
	var colIds = ['sap_jour_numb','branchNm','clos_sale_date','end_sale_date','expiration_date','sale_tota_amou','alram_date','rece_pay_amou','none_coll_amou','tran_status_nm','sale_over_day','rece_user_nm'];  //출력컬럼ID
	var numColIds = ['sale_tota_amou','rece_pay_amou','none_coll_amou','sale_over_day']; //숫자표현ID
	var sheetTitle = "채권목록";   //sheet 타이틀
	var excelFileName = "BondsList";   //file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var isOnLoad = false;   //list2, 그리드를 한번만 초기화하기 위해
var setRowId = "";
jq(function() {
	jq("#list").jqGrid({
    	url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBondsCompanyListJQGrid.sys',
      	datatype: 'json',
      	mtype: 'POST',
      	colNames:['sale_sequ_numb','accManageUserId','전표번호','사업장명','계산서일자','결제만기일','주문제한일','총채권','입금일자','입금액','잔액','관리구분','거래내역서','지연 초과일','반제','최종입금일'],
      	colModel:[
         	{name:'sale_sequ_numb', index:'sale_sequ_numb',width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },
         	{name:'accManageUserId', index:'accManageUserId',width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },
         	{name:'sap_jour_numb', index:'sap_jour_numb',width:75,align:"center",search:false,sortable:true, editable:false },
         	{name:'branchNm', index:'branchNm',width:120,align:"left",search:false,sortable:true, editable:false },
         	{name:'clos_sale_date', index:'clos_sale_date',width:70,align:"center",search:false,sortable:true, editable:false },
         	{name:'end_sale_date', index:'end_sale_date',width:70,align:"center",search:false,sortable:true, editable:false },
         	{name:'expiration_date', index:'expiration_date',width:70,align:"center",search:false,sortable:true, editable:false },//주문제한일
         	{name:'sale_tota_amou', index:'sale_tota_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'alram_date',index:'alram_date',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true },//입금일자
//          	{name:'sale_pay_date',index:'sale_pay_date',width:100,align:"center",search:false,sortable:true, editable:false },//수금완료일자
         	{name:'rece_pay_amou',index:'rece_pay_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//입금액
         	{name:'none_coll_amou',index:'none_coll_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//잔액
         	{name:'tran_status_nm',index:'tran_status_nm',width:60,align:"center",search:false,sortable:true, editable:false },//구분
         	{name:'sale_detail',index:'sale_detail',width:60,align:"center",search:false,sortable:true, editable:false },//거래내역서
         	{name:'sale_over_day',index:'over_date',width:70,align:"center",search:false,sortable:true, editable:false },//초과일수
         	{name:'rece_user_nm',index:'rece_user_nm',width:50,align:"center",search:false,sortable:true, editable:false},//반제
         	{name:'sale_pay_date', index:'sale_pay_date',width:70,align:"center",search:false,sortable:true, editable:false },//반제일         	
      	],
      	postData: {
         	clientId:'<%=detailInfo.getClientId()%>',
         	srcPayStat:$("#srcPayStat").val(),       
         	srcTranStat:$("#srcTranStat").val(),      
         	srcClosStartYear:$("#srcClosStartYear").val(), 
         	srcClosStartMonth:$("#srcClosStartMonth").val(), 
         	srcClosEndYear:$("#srcClosEndYear").val(),   
         	srcClosEndMonth:$("#srcClosEndMonth").val(),
         	srcBranchId:$("#srcBranchId").val()
      	},
      	rowNum:0, rownumbers: false, rowList:[30,50,100], pager: '#pager',
      	height: <%=listHeight%>,autowidth: true,
      	sortname: 'clos_sale_date', sortorder: 'desc',
      	caption:"", 
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {
        	var sum_sale_tota_amou = 0;
          	var sum_rece_pay_amou = 0;
          	var sum_none_coll_amou = 0;
          	var rowCnt = jq("#list").getGridParam('reccount');
          	if(rowCnt>0) {
          		if(setRowId == ""){
          			setRowId = $("#list").getDataIDs()[0]; //첫번째 로우 아이디 구하기	
          		}

             	for(var i=0; i<rowCnt; i++) {
                	var rowid = $("#list").getDataIDs()[i];
                	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                	sum_sale_tota_amou += parseInt(selrowContent.sale_tota_amou);
                	sum_rece_pay_amou += parseInt(selrowContent.rece_pay_amou);
                	sum_none_coll_amou += parseInt(selrowContent.none_coll_amou);  
             	}
             	isOnLoad = true;
             	jq("#list").setSelection(setRowId);
          	}
          	var userData = jq("#list").jqGrid("getGridParam","userData");
          	userData.clos_sale_date = "합계";
          	userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
          	userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
          	userData.rece_pay_amou = fnComma(sum_rece_pay_amou);
          	userData.none_coll_amou = fnComma(sum_none_coll_amou);
          	jq("#list").jqGrid("footerData","set",userData,false);   
      	},
      	onSelectRow: function (rowid, iRow, iCol, e) {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt > 0) {
  				var id = $("#list").jqGrid('getGridParam', "selrow" );
  				var selrowContent = jq("#list").jqGrid('getRowData',id);
//   				fnInitList(selrowContent.sale_sequ_numb, selrowContent.sap_jour_numb, isOnLoad);
//   				fnProdDetail(selrowContent.sale_sequ_numb, isOnLoad);
//   				fnBondsHistory(selrowContent.sale_sequ_numb, isOnLoad);
  				$("#sel_sale_sequ_numb").val(selrowContent.sale_sequ_numb);
  				$("#sel_rece_pay_amou").val(selrowContent.sale_tota_amou);
  				
  				var userId = '<%=userInfoDto.getUserId()%>';
  				
  				if(selrowContent.accManageUserId == userId){
  					$("#regButton2").show();
  					$("#delButton2").show();
  				}else{
  					$("#regButton2").hide();
  					$("#delButton2").hide();
  				}
  				setRowId = id;
			}       		
      	},
		afterInsertRow:function(rowid,aData) {
      		var selrowContent = jq("#list").jqGrid('getRowData',rowid);
      		if(selrowContent.rece_user_nm != ''){
				jq("#list").setCell(rowid,'rece_user_nm','',{color:'#0000ff'});
				jq("#list").setCell(rowid,'rece_user_nm','',{cursor:'pointer'});
      		}
      		
      		jq('#list').jqGrid('setRowData',rowid,{sale_detail:"<a onclick='javascript:fnProdDetail(\""+selrowContent.sale_sequ_numb+"\",\","+isOnLoad+"\");' id='detailButton' class='btn btn-default btn-xs' ><i class='fa fa-search'></i>보기</a>"});
      		
		},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){
      		var selrowContent = jq("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
      		if(colName != undefined && colName['name']=="rece_user_nm" && selrowContent.rece_user_nm != ''){
				fnInitList(selrowContent.sale_sequ_numb, selrowContent.sap_jour_numb, isOnLoad);
      		}
      	},
      	loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      	jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
      	rownumbers:true,
      	footerrow: true,
      	userDataOnFooter: true
   	});

   	jq("#list2").jqGrid({
      	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
      	datatype: 'json',
      	mtype: 'POST',
      	colNames:['recep_alram_id', 'rece_sequ_num', 'sale_sequ_numb', 'rece_pay_amou','입금액','입금일자','처리자','처리일','처리설명','입금예정일자','입금예정금액','통화자'],
      	colModel:[
         	{name:'recep_alram_id',index:'recep_alram_id',width:100,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'rece_sequ_num', index:'rece_sequ_num',width:60,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'sale_sequ_numb', index:'sale_sequ_numb',width:60,align:"center",search:false,sortable:true, editable:false,hidden:true },
        	{name:'rece_pay_amou', index:'rece_pay_amou',width:80,align:"center",search:false,sortable:true, editable:false,hidden:true },
        	{name:'rece_pay_amou',index:'rece_pay_amou',width:80,align:"right",search:false,sortable:true, editable:false , 
             sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'pay_date', index:'pay_date',width:80,align:"center",search:false,sortable:true, editable:false },                
            {name:'rece_user_nm',index:'rece_user_nm',width:80,align:"left",search:false,sortable:true, editable:false },        	
         	{name:'creat_date', index:'creat_date',width:80,align:"center",search:false,sortable:true, editable:false },
         	{name:'context',index:'context',width:250,align:"left",search:false,sortable:true, editable:false },
         	{name:'schedule_date', index:'schedule_date',width:80,align:"center",search:false,sortable:true, editable:false,hidden:true },
         	{name:'schedule_amou',index:'schedule_amou',width:80,align:"right",search:false,sortable:true, editable:false ,
         	sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },hidden:true},
         	{name:'tel_user_nm',index:'tel_user_nm',width:80,align:"left",search:false,sortable:true, editable:false,hidden:true }
      	],
      	postData: {},
      	rowNum:0, rownumbers: true, 
      	height: <%=list2Height%>, width: 680,//autowidth: true,
      	sortname: 'creat_date', sortorder: 'desc',
      	caption:"", 
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {},
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){},
      	loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
      	jsonReader : {root: "list",repeatitems: false,cell: "cell"}
   	});
   	jQuery("#list2").jqGrid('setGroupHeaders', {
      	useColSpanStyle: true,
      	groupHeaders:[
         	{startColumnName: '전표번호', numberOfColumns: 4, titleText: '<em>채권회수활동</em>'}
      	]
   	});      
   
	jq("#list3").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['주문번호','상품명','상품규격','good_st_spec_desc','수량','단가','금액','부가세','합계','vendorId', 'good_iden_numb', 'buyi_sequ_numb'],
		colModel:[
            {name:'order_num',index:'order_num',width:100,align:"left",search:false,sortable:true, editable:false },
            {name:'good_name',index:'good_name',width:150,align:"left",search:false,sortable:true, editable:false },
            {name:'good_spec_desc',index:'good_spec_desc', width:140,align:"left",search:false,sortable:true, editable:false },//상품규격
            {name:'good_st_spec_desc',index:'good_st_spec_desc',hidden:true },//표준규격
            {name:'sale_prod_quan',index:'sale_prod_quan',width:50,align:"right",search:false,sortable:true, editable:false,
             sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'sale_prod_pris',index:'sale_prod_pris',width:60,align:"right",search:false,sortable:true, editable:false,
             sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	
            {name:'sale_prod_amou',index:'sale_prod_amou',width:80,align:"right",search:false,sortable:true, editable:false,
             sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'sale_prod_tax',index:'sale_prod_tax',width:60,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//부가세
			{name:'sale_tota_amou',index:'sale_tota_amou',width:80,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//합계
            {name:'vendorId',index:'vendorId',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
            {name:'good_iden_numb',index:'good_iden_numb',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
            {name:'buyi_sequ_numb',index:'buyi_sequ_numb',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true }
		],
      	postData: {srcOrdeNumb:$("#srcOrdeNumb").val()},
      	rowNum:0, rownumbers: true, 
      	height: <%=listHeight%>,width: 800,//autowidth: true,
      	sortname: 'ORDE_REGI_DATE', sortorder: "DESC",
      	caption:"", 
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {
      		
            //------ 품목 표준 규격 설정 start
            var prodStSpcNm = new Array();
<% 	for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
			prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
<% 	}	%>
			var prodSpcNm = new Array();
<% 	for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
			prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
<%	}	%>
			//------ 품목 표준 규격 설정 end
      		
        	var rowCnt = $("#list3").getGridParam('reccount');
       	 	for(var i=0;i<rowCnt;i++) {
       			var rowid = $("#list3").getDataIDs()[i];
       			var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
       			var lastRowId = $("#list3").getDataIDs()[rowCnt-1];
       			
       			if(lastRowId != rowid){
	         		jq("#list3").setCell(rowid,'order_num','',{color:'#0000ff'});
	       		 	jq("#list3").setCell(rowid,'order_num','',{cursor:'pointer'});  
	       		 	jq("#list3").setCell(rowid,'good_name','',{color:'#0000ff'});
	       			jq("#list3").setCell(rowid,'good_name','',{cursor:'pointer'});
       			}
       			
       			
       			//------ 품목 표준 규격 설정 start
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
				jq('#list3').jqGrid('setRowData',rowid,{good_spec_desc:prodStSpec});
    			//------ 품목 표준 규격 설정 end
       	 	}
      	},
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = $("#list3").jqGrid("getGridParam", "colModel");
    	    var colName = cm[iCol];
    	    var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
    	    var rowCnt = $("#list3").getGridParam('reccount');
    	    var lastRowId = $("#list3").getDataIDs()[rowCnt-1];
    			
    		if(lastRowId != rowid){
	    	    if(colName['index'] == "order_num"){
	    	    	<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, '" +_menuId+ "', selrowContent.purc_iden_numb);")%>
	    	    }         
	    	    if(colName['index'] == "good_name"){
	            	<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView('"+_menuId+"',selrowContent.good_iden_numb, selrowContent.vendorId);")%>
	    	    }    	     
    			
    		}
      	},
      	loadError : function(xhr, st, str){ $("#list3").html(xhr.responseText); },
//       	jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
      	jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
   	jq("#list4").jqGrid({
      	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
      	datatype: 'json',
      	mtype: 'POST',
      	colNames:['등록일자', '관리유형', '내용', '등록자', '첨부파일', '','','',''],
      	colModel:[
         	{name:'REG_DT',index:'REG_DT',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'MANAGE_TYPE_NM', index:'MANAGE_TYPE_NM',width:120,align:"left",search:false,sortable:true, editable:false },
			{name:'CONTENTS', index:'CONTENTS',width:400,align:"left",search:false,sortable:true, editable:false },
			{name:'REG_NM', index:'REG_NM',width:80,align:"left",search:false,sortable:true, editable:false },
        	{name:'FILE_NAME', index:'FILE_NAME',width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'MANAGE_TYPE', index:'MANAGE_TYPE',width:120,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'ATTACH_SEQ', index:'ATTACH_SEQ',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'BOND_MANAGE_ID', index:'BOND_MANAGE_ID',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'FILE_PATH', index:'FILE_PATH',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true }
      	],
      	postData: {},
      	rowNum:0, rownumbers: true, 
      	height: <%=list4Height%>, autowidth: true,
      	sortname: '', sortorder: '',
      	caption:"", 
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {
      		
        	var rowCnt = $("#list4").getGridParam('reccount');
       	 	for(var i = 0 ; i < rowCnt ; i++) {
       			var rowid = $("#list4").getDataIDs()[i];
       			var selrowContent = jq("#list4").jqGrid('getRowData',rowid);
      		
      			jq('#list4').jqGrid('setRowData',rowid,{FILE_NAME:"<a onclick='javascript:fnAttachFileDownload(\""+selrowContent.FILE_PATH+"\");' style='cursor:pointer;' ><font color='blue'>"+selrowContent.FILE_NAME+"</font></a>"});
       	 	}
      	},
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){},
      	loadError : function(xhr, st, str){ $("#list4").html(xhr.responseText); },
      	jsonReader : {root: "list",repeatitems: false,cell: "cell"}
   	});	
	
});

function fnDetail(cellValue, options, rowObject){
	var rtnStr = "";
	rtnStr = "<a onclick='javascript:fnProdDetail(\""+cellValue+"\",\","+isOnLoad+"\");' id='detailButton' class='btn btn-default btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class='fa fa-search'></i>보기</a>";
	return rtnStr;
}

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");

	data.srcPayStat      	= $("#srcPayStat").val();
	data.srcTranStat     	= $("#srcTranStat").val();
	data.srcClosStartYear   = $("#srcClosStartYear").val(); 
	data.srcClosStartMonth  = $("#srcClosStartMonth").val();
	data.srcClosEndYear     = $("#srcClosEndYear").val();
	data.srcClosEndMonth    = $("#srcClosEndMonth").val();
	data.clientId        	= '<%=detailInfo.getClientId()%>'; 
	data.srcBranchId        = $("#srcBranchId").val(); 
	jq("#list").trigger("reloadGrid");     	
}

function fnInitList(sale_sequ_numb, sap_jour_numb, isOnLoad) {
	if(isOnLoad){
		$("#list2Pop").jqmShow();
		$("#list2").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustSalesDepositDescListJQGrid.sys'});
	    var data = jq("#list2").jqGrid("getGridParam", "postData");
	    data.sale_sequ_numb = sale_sequ_numb;
	    data.sap_jour_numb = sap_jour_numb;
	    data.isBonds = 'Y';
	    jq("#list2").jqGrid("setGridParam", { "postData": data });
	    jq("#list2").trigger("reloadGrid"); 		
	}
}

function fnProdDetail(sale_sequ_numb, isOnLoad){
	if(isOnLoad){
		$("#list3Pop").jqmShow();
   		$("#list3").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustSalesConfirmDetailListJQGrid.sys'});
   		var data = jq("#list3").jqGrid("getGridParam", "postData");
   		data.sale_sequ_numb = sale_sequ_numb;
   		jq("#list3").jqGrid("setGridParam", { "postData": data });
   		jq("#list3").trigger("reloadGrid");	
	}	
}


function fnBondsHistory(sale_sequ_numb, isOnLoad){
	if(isOnLoad){
   		$("#list4").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBondsHistListJQGrid.sys'});
   		var data = jq("#list4").jqGrid("getGridParam", "postData");
   		data.sale_sequ_numb = sale_sequ_numb;
   		jq("#list4").jqGrid("setGridParam", { "postData": data });
   		jq("#list4").trigger("reloadGrid");	
	}	
}
</script>


<script type="text/javascript">
/**
 * 파일다운로드
 */
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
	};
};
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

//3자리수마다 콤마
function fnComma(n) {
   n += '';
   var reg = /(^[+-]?\d+)(\d{3})/;
   while (reg.test(n)){
      n = n.replace(reg, '$1' + ',' + '$2');
   }
   return n;
}

function fnAddBonds() {
	var obj = $("#sel_sale_sequ_numb").val();
	if( obj != "" ){
    var popurl = "/adjust/adjustSalesBondsDetailPop.sys?sale_sequ_numb=" + obj + "&_menuId=<%=_menuId%>";
    	var popproperty = "dialogWidth:580px;dialogHeight=470px;scroll=yes;status=no;resizable=no;";
     	//window.showModalDialog(popurl,self,popproperty);
     	window.open(popurl, '', 'width=580, height=440, scrollbars=yes, status=no, resizable=no');
 	} else { jq( "#dialogSelectRow" ).dialog(); }   
}

function fnDelBonds(){
	var id = $("#list2").jqGrid('getGridParam', "selrow" );
	
   	if(id == null) {
		alert("삭제할 데이터를 선택해주세요.");
	    return;
	}	

   	var selrowContent = jq("#list2").jqGrid('getRowData',id);
   	
   	if(!confirm("선택한 데이터를 삭제하시겠습니까?")) return;

   	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveDepositDetail.sys", 
   		{
      		oper:"del", 
      		sale_sequ_numb:selrowContent.sale_sequ_numb,
      		rece_sequ_num:selrowContent.rece_sequ_num,
      		sel_rece_pay_amou:$("#sel_rece_pay_amou").val(),
      		pay_amou:selrowContent.rece_pay_amou
   		},       
   
   		function(arg){ 
    		if(fnAjaxTransResult(arg)) {  //성공시
    			fnSearch();
      		}
   		}
	);    	
}

</script>
</head>

<body>
	<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
         	<tr>
            	<td>
               	<!-- 타이틀 시작 -->
               		<table width="100%" border="0" cellspacing="0" cellpadding="0">
                  		<tr valign="top">
                     		<td width="20" valign="middle">
                        		<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
                     		</td>
                     		<td height="29" class="ptitle">발생채권별현황</td>
                     		<td align="right" class="ptitle">&nbsp;</td>
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
                     		<td colspan="8" class="table_top_line"></td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
                  		</tr>
                  		<tr>
                     		<td class="table_td_subject" width="60">회사명</td>
                     		<td class="table_td_contents">
                        		<input id="clientNm" name="clientNm" type="text" value="<%=detailInfo.getClientNm() %>" size="" maxlength="50" class="input_none" readonly="readonly"/>
                     		</td>
                     		<td class="table_td_subject" width="100">사업자등록번호</td>
                     		<td class="table_td_contents">
                        		<input id="businessNum" name="businessNum" type="text" value="<%=detailInfo.getBusinessNum() %>" size="" maxlength="50" class="input_none" readonly="readonly"/>
                     		</td>
                     		<td class="table_td_subject" width="80">총채권액</td>
                     		<td class="table_td_contents">
                        		<input id="sale_tota_amou" name="sale_tota_amou" type="text" value="" size="" maxlength="50" class="input_none" readonly="readonly" style="text-align: right;"/>
                     		</td>
                     		<td class="table_td_subject" width="100">미마감주문금액</td> 
                     		<td class="table_td_contents">   
                        		<input id="none_clos_requ_pric" name="none_clos_requ_pric" type="text" value="" size="" maxlength="50" class="input_none" readonly="readonly" style="text-align: right;"/>
                     		</td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
                  		</tr>
                  		<tr>
                     		<td class="table_td_subject">주소</td>
                     		<td colspan="3" class="table_td_contents">
                        		<input id="addres" name="addres" type="text" value="<%=detailInfo.getAddres()%>" size="" maxlength="50" style="width: 408px" class="input_none" readonly="readonly"/>
                     		</td>
                     		<td class="table_td_subject">총채권잔액</td>
                     		<td class="table_td_contents">
                        		<input id="balance_amou" name="balance_amou" type="text" value="" size="" maxlength="50" class="input_none" readonly="readonly" style="text-align: right;"/>
                     		</td>
                     		<td class="table_td_subject">미마감발주금액</td>
                     		<td class="table_td_contents">
                        		<input id="none_clos_purc_pric" name="none_clos_purc_pric" type="text" value="" size="" maxlength="50" class="input_none" readonly="readonly" style="text-align: right;"/>
                     		</td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
                  		</tr>
                  		<tr>
                     		<td class="table_td_subject">대표자</td>
		                    <td class="table_td_contents">
                        		<input id="pressentNm" name="pressentNm" type="text" value="<%=detailInfo.getPressentNm() %>" size="" maxlength="50" class="input_none" readonly="readonly"/>
                     		</td>
                     		<td class="table_td_subject">전화번호</td>
                     		<td class="table_td_contents">
                        		<input id="phoneNum" name="phoneNum" type="text" value="<%=detailInfo.getPhoneNum() %>" size="" maxlength="50" class="input_none" readonly="readonly"/>
                     		</td>
                     		<td class="table_td_subject">평균회수기일</td>
                     		<td class="table_td_contents">
                        		<input id="avg_day" name="avg_day" type="text" value="" size="" maxlength="50" class="input_none" readonly="readonly" style="text-align: right;"/>
                     		</td>
                     		<td class="table_td_subject">미마감출하금액</td>
                     		<td class="table_td_contents">
                        		<input id="none_clos_deli_pric" name="none_clos_deli_pric" type="text" value="" size="" maxlength="50" class="input_none" readonly="readonly" style="text-align: right;"/>
                     		</td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
                  		</tr>
                  		<tr>
                     		<td class="table_td_subject">결재은행</td>
                     		<td colspan="3" class="table_td_contents">
                        		<input id="bankNm" name="bankNm" type="text" value="<%= CommonUtils.getString(detailInfo.getBankNm()) %>" size="" maxlength="50" style="width: 408px" class="input_none" readonly="readonly"/>
                     		</td>
                     		<td>
                        		<input type="hidden" id="sel_sale_sequ_numb" name="sel_sale_sequ_numb"/>
                     		</td>
                     		<td>
                        		<input type="hidden" id="sel_rece_pay_amou" name="sel_rece_pay_amou"/>
                     		</td>
	
                     		<td class="table_td_subject">미마감인수금액</td>
                     		<td class="table_td_contents">
                        		<input id="none_sale_prod_amou" name="none_sale_prod_amou" type="text" value="" size="" maxlength="50" class="input_none" readonly="readonly" style="text-align: right;"/>
                     		</td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" class="table_top_line"></td>
                  		</tr>
               		</table>
               		<!-- 컨텐츠 끝 -->
            	</td>
         	</tr>
         	<tr>
            	<td>&nbsp;</td>
         	</tr>
         	<tr>
            	<td>
               	<!-- 타이틀 시작 -->
               		<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                  		<tr>
                     		<td width="20" valign="top">
                        		<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                     		</td>
                     		<td class="stitle">채권목록</td>
                     		<td align="right" class="stitle">
                     			<a class="btn btn-success btn-xs" id="excelButton"><i class="fa fa-file-excel-o"></i> 엑셀</a>
								<a id='srcButton' class='btn btn-primary btn-sm' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class='fa fa-search'></i> 조회</a>                        		
                     		</td>
                  		</tr>
               		</table>
               		<!-- 타이틀 끝 -->
               		<!-- 컨텐츠 시작 -->
               		<table width="100%" border="0" cellspacing="0" cellpadding="0">
                  		<tr>
                     		<td colspan="8" class="table_top_line"></td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
                  		</tr>
                  		<tr>
                     		<td class="table_td_subject" width="100">마감일</td>
                     		<td class="table_td_contents">
                          		<select id="srcClosStartYear" name="srcClosStartYear" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                           			<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("YEAR", -1).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                        		</select> 년
                        
                        		<select id="srcClosStartMonth" name="srcClosStartMonth" class="select" style="width: 40px;">
<%
   for(int i = 0 ; i < 12 ; i++){
%>
                           			<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%      
   }
%>                        
                        		</select> 월 ~                          
                        
                        		<select id="srcClosEndYear" name="srcClosEndYear" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                           			<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                        		</select> 년
                        
                        		<select id="srcClosEndMonth" name="srcClosEndMonth" class="select" style="width: 40px;">
<%
   for(int i = 0 ; i < 12 ; i++){
%>
                           			<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%      
   }
%>                        
                        		</select> 월            
                     		</td>
                     
							<td class="table_td_subject" width="100">관리사업장</td>
							<td class="table_td_contents">
                    			<select id="srcBranchId" name="srcBranchId" class="select" style="width:100px;" >
                        			<option value="">전체</option>
<%
	@SuppressWarnings("unchecked")	
	List<HashMap<String, Object>> branchList = (List<HashMap<String, Object>>)request.getAttribute("branchList");
	if(branchList != null && branchList.size() > 0){
		for(HashMap<String, Object> listMap : branchList){
			System.out.println(listMap.get("BORGNM") + " : " + listMap.get("BRANCHID"));
%>
                        				<option value="<%=listMap.get("BRANCHID")%>"><%=listMap.get("BORGNM") %></option>
<%			
			
		}
	}
%>                        	

                        		</select>
                   			</td>					
					
                     
                     		<td class="table_td_subject" width="100">잔액여부</td>
                     		<td class="table_td_contents">
                        		<select id="srcPayStat" name="srcPayStat" class="select">
                          	 		<option value="">전체</option>
                           			<option value="10" selected="selected">있음</option>
                           			<option value="20">없음</option>
                        		</select>
                     		</td>
                     		<td class="table_td_subject" width="100">구분</td>
                     		<td class="table_td_contents">
                        		<select id="srcTranStat" name="srcTranStat" class="select">
                           			<option value="">전체</option>
                           			<option value="0">정상</option>
                           			<option value="1">관리</option>
                        		</select>
                     		</td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
                  		</tr>
                  		<tr>
                     		<td colspan="8" class="table_top_line"></td>
                  		</tr>
               		</table>
               		<!-- 컨텐츠 끝 -->
            	</td>
         	</tr>
         	<tr>
            	<td>&nbsp;</td>
         	</tr>
         	<tr>
            	<td>
               		<!-- 그리드 분할-->
               		<table width="100%" border="0" cellspacing="0" cellpadding="0">
                  		<col width="700" />
                  		<col />
                  		<col width="100%" />
                  		<tr>
                     		<td valign="top" colspan="2">
		                    	<div id="jqgrid">
                           			<table id="list"></table>
                        		</div>
                     		</td>
                  		</tr>
               		</table>
               		<!-- 그리드 분할-->
            	</td>
         	</tr>
			<tr>
            	<td>&nbsp;</td>
         	</tr>
<!--        		<tr> -->
<!--             	<td> -->
<!--                		<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0"> -->
<!--                   		<tr> -->
<!--                      		<td width="20" valign="top"> -->
<%--                         		<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" /> --%>
<!--                      		</td> -->
<!--                      		<td class="stitle">채권관리 History</td> -->
<!--                      		<td align="right" class="stitle"> -->
<%-- 								<a id='saveButton' class='btn btn-warning btn-sm' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class='fa fa-plus'></i> 등록</a>                        		 --%>
<%-- 								<a id='modButton' class='btn btn-warning btn-sm' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class='fa fa-search'></i> 수정</a>                        		 --%>
<!--                      		</td> -->
<!--                   		</tr> -->
                  		
<!-- 						<tr> -->
<!--                     		<td colspan="3" height="5"></td> -->
<!--                  		</tr>                  		 -->
                  		
<!--                   		<tr> -->
<!--                      		<td valign="top" colspan="3"> -->
<!-- 		                    	<div id="jqgrid"> -->
<!--                            			<table id="list4"></table> -->
<!--                         		</div> -->
<!--                      		</td> -->
<!--                   		</tr>                  		 -->
<!--                		</table>            	 -->
<!--             	</td>         	 -->
         	
<!--        		</tr> -->
		</table>
    	<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
    		<p>처리할 데이터를 선택 하십시오!</p>
		</div>
    	<!-------------------------------- Dialog Div Start -------------------------------->
    	<div id="dialog" title="Feature not supported" style="display:none;">
       		<p>That feature is not supported.</p>
    	</div>            
      
		<div class="jqmList2Window1" id="list2Pop">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div id="dialogHandle1">
							<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
				      			<tr>
				        			<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
				        			<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
				        			<td class="popup_title">반제이력</td>
				        			<td width="22" align="right">
				        				<a href="#" class="jqmClose">
				        				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" />
				        				</a>
				        			</td>
				        			<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
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
									<!-- 조회조건 -->
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td>
												<div id="jqgrid">
													<table id="list2"></table>
												</div>
											</td>
										</tr>
										<tr>
											<td height='8'></td>
										</tr>
									</table>
									
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td align="center">
												<a id='list2CloseButton' class='btn btn-primary btn-sm' ><i class='fa fa-search'></i> 닫기</a>
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
      
		<div class="jqmList2Window2" id="list3Pop">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<div id="dialogHandle2">
							<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
				      			<tr>
				        			<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
				        			<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
				        			<td class="popup_title">매출상세이력</td>
				        			<td width="22" align="right">
				        				<a href="#" class="jqmClose">
				        				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" />
				        				</a>
				        			</td>
				        			<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
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
									<!-- 조회조건 -->
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td>
												<div id="jqgrid">
													<table id="list3"></table>
												</div>
											</td>
										</tr>
										<tr>
											<td height='8'></td>
										</tr>
									</table>
									
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td align="center">
												<a id='list3CloseButton' class='btn btn-primary btn-sm' ><i class='fa fa-search'></i> 닫기</a>
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
      <!-------------------------------- Dialog Div End -------------------------------->
   	</form>
</body>
</html>