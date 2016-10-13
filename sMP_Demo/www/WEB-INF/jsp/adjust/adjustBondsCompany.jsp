<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.adjust.dto.AdjustDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	String listHeight = "$(window).height()-640 + Number(gridHeightResizePlus)";
	String list2Height = "$(window).height()-680 + Number(gridHeightResizePlus)";
	
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
	
	//System.out.println("CommonUtils.getString(detailInfo.getIsLimit()) : " + CommonUtils.getString(detailInfo.getIsLimit()));
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	List<LoginRoleDto> loginRoleList = loginUserDto.getLoginRoleList();
	boolean isAdmApp = false;	//승인자여부
	boolean isAdmPower = false;	//파워운영자
	for(LoginRoleDto loginRoleDto : loginRoleList) {
		if("ADM_APP".equals(loginRoleDto.getRoleCd().trim())) {
			isAdmApp = true;
			break;
		}
		//파워운영자권한
		if("MRO_ADMIN002".equals(loginRoleDto.getRoleCd().trim())){
			isAdmPower = true;
			break;
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<style type="text/css">
.jqmPopWindow {
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
.jqmOverlay { background-color: #000; }
</style>

<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
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
	$('#historyPop').jqm();	//Dialog 초기화
	$("#hisCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#historyPop").jqmHide();
	});
	$('#historyPop').jqm().jqDrag('#dialogHandle'); 

	$("#phoneNum").val( fnSetTelformat( $("#phoneNum").val() ) );
	
});

var jq = jQuery;
$(document).ready(function() {
	
	$("#attachButton1").click(function(){ fnUploadDialog("첨부파일1", $("#attach_seq1").val(), "fnCallBackAttach1"); });
	$("#attachButton2").click(function(){ fnUploadDialog("첨부파일2", $("#attach_seq2").val(), "fnCallBackAttach2"); });
	$("#attachButton3").click(function(){ fnUploadDialog("첨부파일3", $("#attach_seq3").val(), "fnCallBackAttach3"); });
	$("#attachButton4").click(function(){ fnUploadDialog("첨부파일4", $("#attach_seq4").val(), "fnCallBackAttach4"); });
	$("#attachButton5").click(function(){ fnUploadDialog("첨부파일5", $("#attach_seq5").val(), "fnCallBackAttach5"); });
	
	$("#saveButton").click(function(){
		$("#manage_type").val("");
		$("#contents").val("");
		$("#attach_seq1").val("");
		$("#attach_seq2").val("");
		$("#attach_seq3").val("");
		$("#attach_seq4").val("");
		$("#attach_seq5").val("");
		$("#attach_file_name1").html("");
		$("#attach_file_path1").val("");
		$("#attach_file_name2").html("");
		$("#attach_file_path2").val("");
		$("#attach_file_name3").html("");
		$("#attach_file_path3").val("");
		$("#attach_file_name4").html("");
		$("#attach_file_path4").val("");
		$("#attach_file_name5").html("");
		$("#attach_file_path5").val("");
		$("#hisSaveButton").show();
		$("#hisModButton").hide();
		$("#historyPop").jqmShow();
	});

	$("#modButton").click(function(){
		var id = $("#list2").jqGrid('getGridParam', "selrow" );
		
		if(id == null){
			alert("수정할 데이터를 선택해 주세요.");
			return;
		}
		
		var selrowContent = jq("#list2").jqGrid('getRowData',id);
		
		$("#manage_type").val(selrowContent.MANAGE_TYPE);
		$("#contents").val(selrowContent.CONTENTS);
		$("#attach_seq1").val(selrowContent.ATTACH_SEQ1 == "0" ? "" : selrowContent.ATTACH_SEQ1);
		$("#attach_seq2").val(selrowContent.ATTACH_SEQ2 == "0" ? "" : selrowContent.ATTACH_SEQ2);
		$("#attach_seq3").val(selrowContent.ATTACH_SEQ3 == "0" ? "" : selrowContent.ATTACH_SEQ3);
		$("#attach_seq4").val(selrowContent.ATTACH_SEQ4 == "0" ? "" : selrowContent.ATTACH_SEQ4);
		$("#attach_seq5").val(selrowContent.ATTACH_SEQ5 == "0" ? "" : selrowContent.ATTACH_SEQ5);
		$("#attach_file_name1").html(selrowContent.FILE_NAME1);
		$("#attach_file_path1").val(selrowContent.FILE_PATH1);
		$("#attach_file_name2").html(selrowContent.FILE_NAME2);
		$("#attach_file_path2").val(selrowContent.FILE_PATH2);
		$("#attach_file_name3").html(selrowContent.FILE_NAME3);
		$("#attach_file_path3").val(selrowContent.FILE_PATH3);
		$("#attach_file_name4").html(selrowContent.FILE_NAME4);
		$("#attach_file_path4").val(selrowContent.FILE_PATH4);
		$("#attach_file_name5").html(selrowContent.FILE_NAME5);
		$("#attach_file_path5").val(selrowContent.FILE_PATH5);
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
		var attach_seq1		= $.trim($("#attach_seq1").val());
		var attach_seq2		= $.trim($("#attach_seq2").val());
		var attach_seq3		= $.trim($("#attach_seq3").val());
		var attach_seq4		= $.trim($("#attach_seq4").val());
		var attach_seq5		= $.trim($("#attach_seq5").val());
		
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
				clientId  		: '<%=detailInfo.getClientId()%>',
				manage_type 	: manage_type	,
				contents 		: contents 	 	,
				attach_seq1		: attach_seq1	, 
				attach_seq2		: attach_seq2 	,
				attach_seq3		: attach_seq3 	,
				attach_seq4		: attach_seq4 	,
				attach_seq5		: attach_seq5 
			},
			function(arg){
				if(fnAjaxTransResult(arg)) {
					$("#historyPop").jqmHide();
					fnBondsHistory();
				}
			}
		);		
	});
	
	$("#hisModButton").click(function(){
		var id = $("#list").jqGrid('getGridParam', "selrow" );
		var selrowContent = jq("#list").jqGrid('getRowData',id);

		var id2 = $("#list2").jqGrid('getGridParam', "selrow" );
		var selrowContent2 = jq("#list2").jqGrid('getRowData',id2);
		
		var manage_type 	= $.trim($("#manage_type").val());
		var contents 		= $.trim($("#contents").val());
		var attach_seq1		= $.trim($("#attach_seq1").val());
		var attach_seq2		= $.trim($("#attach_seq2").val());
		var attach_seq3		= $.trim($("#attach_seq3").val());
		var attach_seq4		= $.trim($("#attach_seq4").val());
		var attach_seq5		= $.trim($("#attach_seq5").val());
		
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
				clientId  		: '<%=detailInfo.getClientId()%>',
				manage_type 	: manage_type	,
				contents 		: contents 	 	,
				attach_seq1 	: attach_seq1	, 
				attach_seq2 	: attach_seq2 	,
				attach_seq3 	: attach_seq3 	,
				attach_seq4 	: attach_seq4 	,
				attach_seq5 	: attach_seq5 
			},
			function(arg){
				if(fnAjaxTransResult(arg)) {
					$("#historyPop").jqmHide();
					fnBondsHistory();
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
	$("#isLimitButton").click(function(){fnIsLimit();});
	
	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton1").click(function(){ exportExcel1(); });
	$("#excelButton2").click(function(){ exportExcel2(); });
	$('#limitTimeButton').click(function(){ timeExpention();});
	$("#expiration_date").val('<%=CommonUtils.getCustomDay("DAY", 0)%>');
	$('#transferStatusButton').click(function(){ transferStatusChange();});
});
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var setRowId = "";
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBondsCompanyListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",
		          '사업장명','계산서일자','결제만기일','주문제한일','총채권','입금액','잔액','관리구분','이관여부','sale_sequ_numb','transfer_status_flag','transfer_status_type'],
		colModel:[
			{name:'isCheck',index:'isCheck',width:30,align:"center",search:false,sortable:false,editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
			{name:'branchNm', index:'branchNm',width:110,align:"left",search:false,sortable:true, editable:false },
			{name:'clos_sale_date', index:'clos_sale_date',width:110,align:"center",search:false,sortable:true, editable:false },
			
			{name:'end_sale_date', index:'end_sale_date',width:110,align:"center",search:false,sortable:true, editable:false },
			
			{name:'expiration_date',index:'expiration_date',width:110,align:"center",search:false,sortable:false,
				formatter: 'text',
				editable:false,edittype: 'text',
				editoptions: {
					readonly:'readonly',
					size: 9,maxlengh: 10,dataInit: function (element) {
						$(element).datepicker({ dateFormat: 'yy-mm-dd' });
					},
					dataEvents:[{
					type:'change',
						fn:function(e){
						var inputValue = this.value;	// 입력 날짜
						var rowid = (this.id).split("_")[0];
						jq("#list").restoreRow(rowid);
						jq("#list").jqGrid('setRowData', rowid, {expiration_date:inputValue});
	//  					jq("#"+this.id).parent("td:nth-child(12)").attr("title",this.value);
						}
					}]
				},
				editrules: {date: false}
			},//만기일			
			{name:'sale_tota_amou', index:'sale_tota_amou',width:110,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//총채권
			{name:'rece_pay_amou',index:'rece_pay_amou',width:110,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//입금액
			{name:'none_coll_amou',index:'none_coll_amou',width:110,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			

			{name:'tran_status_nm',index:'tran_status_nm',width:90,align:"center",search:false,sortable:true, editable:false },//구분
			{name:'transfer_status',index:'transfer_status',width:90,align:"center",search:false,sortable:true, editable:true, 
				edittype:"select",formatter:"select",
				editoptions: {
					value:'0:예;1:아니오',
					dataEvents:[{
						type:'change',
						fn:function(e){
							var rowid = (this.id).split("_")[0];
							var inputValue = this.value; // 선택값
							jq("#list").jqGrid('setRowData', rowid, {transfer_status:$.trim(inputValue)});
//	       					$("#"+this.id+" > option[value="+inputValue+"]").attr("selected",true);
	      				}
	      			}]
				}
			},//이관여부				
// 			{name:'businessNum', index:'businessNum',width:110,align:"center",search:false,sortable:true, editable:false },
// 			{name:'alram_date',index:'alram_date',width:110,align:"center",search:false,sortable:true, editable:false, hidden:true },//입금일자
// 			{name:'sale_pay_date',index:'sale_pay_date',width:110,align:"center",search:false,sortable:true, editable:false },//수금완료일자
// 			{name:'sale_over_month',index:'sale_over_month',width:90,align:"center",search:false,sortable:true, editable:false },//경과월
// 			{name:'sale_over_day',index:'sale_over_day',width:90,align:"center",search:false,sortable:true, editable:false },//초과일수
			{name:'sale_sequ_numb',index:'sale_sequ_numb',search:false, editable:false,hidden:true},//매출아이디
			{name:'transfer_status_flag',index:'transfer_status_flag',search:false, editable:false,hidden:true},
			{name:'transfer_status_type',index:'transfer_status_type',search:false, editable:false,hidden:true}//이관여부를 예,아니오로 출력
		],
		postData: {
			clientId:'<%=detailInfo.getClientId()%>',
			srcPayStat:$("#srcPayStat").val(),       
			srcTranStat:$("#srcTranStat").val(),      
			srcClosStartYear:$("#srcClosStartYear").val(), 
			srcClosStartMonth:$("#srcClosStartMonth").val(), 
			srcClosEndYear:$("#srcClosEndYear").val(),   
			srcClosEndMonth:$("#srcClosEndMonth").val(),   
			srcTransferStatus:$("#srcTransferStatus").val()   
		},
		rowNum:0, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'clos_sale_date', sortorder: 'asc',
		caption:"", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var sum_sale_tota_amou = 0;
			var sum_rece_pay_amou = 0;
			var sum_none_coll_amou = 0;
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt==0) {
				jq("#chkAllOutputField").attr("checked", false);
			}
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					jq("#list").restoreRow(rowid);
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					sum_sale_tota_amou += parseInt(selrowContent.sale_tota_amou);
					sum_rece_pay_amou += parseInt(selrowContent.rece_pay_amou);
					sum_none_coll_amou += parseInt(selrowContent.none_coll_amou);
					jq("#list").jqGrid('setRowData', rowid, {transfer_status_flag:selrowContent.transfer_status});
					jq('#list').editRow(rowid);
				}
          		if(setRowId == ""){
          			setRowId = $("#list").getDataIDs()[0]; //첫번째 로우 아이디 구하기	
          		}
				jq("#list").setSelection(setRowId);
			}
			var userData = jq("#list").jqGrid("getGridParam","userData");
			userData.clos_sale_date = "합계";
			userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
			userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
			userData.rece_pay_amou = fnComma(sum_rece_pay_amou);
			userData.none_coll_amou = fnComma(sum_none_coll_amou);
			jq("#list").jqGrid("footerData","set",userData,false);
// 			var rowData = jq('#list').jqGrid('getRowData',rowId);
			fnBondsHistory();
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt > 0) {
  				var id = $("#list").jqGrid('getGridParam', "selrow" );
  				var selrowContent = jq("#list").jqGrid('getRowData',id);
  				setRowId = id;
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = $("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
// 			if(colName['index'] == "expiration_date"){
// 				jq('#list').jqGrid('editRow',rowid,true); 
// 			}
			var data = $('#list').getRowData(rowid);
// 			if(data.tran_status_nm == '관리') {
// 				$('#list').editRow(rowid,'1', false);
// 			}
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell", userdata:"userdata" },
		rownumbers:true,
		footerrow: true,
		userDataOnFooter: true
	});
	
   	jq("#list2").jqGrid({
      	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
      	datatype: 'json',
      	mtype: 'POST',
      	colNames:['등록일자', '관리유형', '내용', '등록자', '첨부파일1','첨부파일2','첨부파일3','첨부파일4','첨부파일5', '','','','','','','','','','','',''],
      	colModel:[
         	{name:'REG_DT',index:'REG_DT',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'MANAGE_TYPE_NM', index:'MANAGE_TYPE_NM',width:120,align:"left",search:false,sortable:true, editable:false },
			{name:'CONTENTS', index:'CONTENTS',width:400,align:"left",search:false,sortable:true, editable:false },
			{name:'REG_NM', index:'REG_NM',width:80,align:"left",search:false,sortable:true, editable:false },
        	{name:'FILE_NAME1', index:'FILE_NAME1',width:100,align:"left",search:false,sortable:true, editable:false },
        	{name:'FILE_NAME2', index:'FILE_NAME2',width:100,align:"left",search:false,sortable:true, editable:false },
        	{name:'FILE_NAME3', index:'FILE_NAME3',width:100,align:"left",search:false,sortable:true, editable:false },
        	{name:'FILE_NAME4', index:'FILE_NAME4',width:100,align:"left",search:false,sortable:true, editable:false },
        	{name:'FILE_NAME5', index:'FILE_NAME5',width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'MANAGE_TYPE', index:'MANAGE_TYPE',width:120,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'ATTACH_SEQ1', index:'ATTACH_SEQ1',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'ATTACH_SEQ2', index:'ATTACH_SEQ2',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'ATTACH_SEQ3', index:'ATTACH_SEQ3',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'ATTACH_SEQ4', index:'ATTACH_SEQ4',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'ATTACH_SEQ5', index:'ATTACH_SEQ5',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'BOND_MANAGE_ID', index:'BOND_MANAGE_ID',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'FILE_PATH1', index:'FILE_PATH1',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'FILE_PATH2', index:'FILE_PATH2',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'FILE_PATH3', index:'FILE_PATH3',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'FILE_PATH4', index:'FILE_PATH4',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
        	{name:'FILE_PATH5', index:'FILE_PATH5',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true }
      	],
      	postData: {},
      	rowNum:0, rownumbers: true, 
      	height: <%=list2Height%>, autowidth: true,
      	sortname: '', sortorder: '',
      	caption:"", 
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {
      		
        	var rowCnt = $("#list2").getGridParam('reccount');
       	 	for(var i = 0 ; i < rowCnt ; i++) {
       			var rowid = $("#list2").getDataIDs()[i];
       			var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
      		
      			jq('#list2').jqGrid('setRowData',rowid,{FILE_NAME1:"<a onclick='javascript:fnAttachFileDownload(\""+selrowContent.FILE_PATH1+"\");' style='cursor:pointer;' ><font color='blue'>"+selrowContent.FILE_NAME1+"</font></a>"});
      			jq('#list2').jqGrid('setRowData',rowid,{FILE_NAME2:"<a onclick='javascript:fnAttachFileDownload(\""+selrowContent.FILE_PATH2+"\");' style='cursor:pointer;' ><font color='blue'>"+selrowContent.FILE_NAME2+"</font></a>"});
      			jq('#list2').jqGrid('setRowData',rowid,{FILE_NAME3:"<a onclick='javascript:fnAttachFileDownload(\""+selrowContent.FILE_PATH3+"\");' style='cursor:pointer;' ><font color='blue'>"+selrowContent.FILE_NAME3+"</font></a>"});
      			jq('#list2').jqGrid('setRowData',rowid,{FILE_NAME4:"<a onclick='javascript:fnAttachFileDownload(\""+selrowContent.FILE_PATH4+"\");' style='cursor:pointer;' ><font color='blue'>"+selrowContent.FILE_NAME4+"</font></a>"});
      			jq('#list2').jqGrid('setRowData',rowid,{FILE_NAME5:"<a onclick='javascript:fnAttachFileDownload(\""+selrowContent.FILE_PATH5+"\");' style='cursor:pointer;' ><font color='blue'>"+selrowContent.FILE_NAME5+"</font></a>"});
       	 	}
      	},
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){},
      	loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
      	jsonReader : {root: "list",repeatitems: false,cell: "cell"}
   	});		
	
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
//구분이 관리일경우 이벤트 발생이안되게 처리
function editableFalse(rowid) {
	var rowData = $("list").jqGrid('getRowData',rowid);
}



//3자리수마다 콤마
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
	n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcPayStat      = $("#srcPayStat").val();
	data.srcTranStat     = $("#srcTranStat").val();
	data.srcClosStartYear   = $("#srcClosStartYear").val(); 
	data.srcClosStartMonth  = $("#srcClosStartMonth").val();
	data.srcClosEndYear     = $("#srcClosEndYear").val();
	data.srcClosEndMonth    = $("#srcClosEndMonth").val();
	data.srcTransferStatus    = $("#srcTransferStatus").val();
	data.clientId        = '<%=detailInfo.getClientId()%>'; 
	jq("#list").trigger("reloadGrid");     
}

function fnIsLimit(){
	if(!confirm("해당 법인의 주문제한여부를 변경하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/updateSmpBorgsIsLimit.sys", 
		{
			clientId:'<%=detailInfo.getClientId()%>',
			isLimit:$("#isLimit").val()
		},

		function(arg){ 
			if(fnAjaxTransResult(arg)) {  //성공시
			}
		}
	); 	
}

function exportExcel1() {
	var colLabels = ['계산서일자','사업장명','사업자등록번호','총채권','입금액','잔액','구분','이관여부','계산서일자','결제만기일','주문제한일'];   //출력컬럼명
	var colIds = ['clos_sale_date','branchNm','businessNum','sale_tota_amou','rece_pay_amou','none_coll_amou','tran_status_nm','transfer_status_type','clos_sale_date','end_sale_date','expiration_date'];  //출력컬럼ID
	var numColIds = ['sale_tota_amou','rece_pay_amou','none_coll_amou']; //숫자표현ID
	var sheetTitle = "업체별채권현황";   //sheet 타이틀
	var excelFileName = "BondsCompanyList";   //file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function exportExcel2() {
	var colLabels = ['등록일자', '관리유형', '내용', '등록자'];   //출력컬럼명
	var colIds = ['REG_DT','MANAGE_TYPE_NM','CONTENTS','REG_NM'];  //출력컬럼ID
	var numColIds = []; //숫자표현ID
	var sheetTitle = "채권관리History";   //sheet 타이틀
	var excelFileName = "Bonds_History";   //file명
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//만기일 변경 펑션
function timeExpention() {
	var rowCnt = $('#list').getGridParam('reccount');
	var expiration_date_Arr = Array();
	var sale_sequ_numb_Arr = Array();
	var cnt = 0;
	if(rowCnt > 0){
		for(var i =0; i<rowCnt; i++){
			var rowid = $('#list').getDataIDs()[i];
			if($("#isCheck_"+rowid).attr("checked")) {
				var selrowContent = $("#list").jqGrid('getRowData',rowid);
		 		if('관리' == selrowContent.tran_status_nm){
					alert('관리 상태가 만기일인 것은 변경을 할 수없습니다.');
					return;
				}else{
					expiration_date_Arr[i] = selrowContent.expiration_date;
				 	sale_sequ_numb_Arr[i] = selrowContent.sale_sequ_numb;
						
				}
				cnt++;	
			}
		}
		if(cnt == 0){
			alert('만기일을 변경하실 로우를 체크해 주십시오.');
			return;
		}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/modExpirationDate.sys",
			{
				expiration_date_Arr:expiration_date_Arr,
				sale_sequ_numb_Arr:sale_sequ_numb_Arr
			},
			function(arg){ 
				if(fnAjaxTransResult(arg)) {
					fnSearch();
				}
			}
		);
	}
	
}
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox'  offval='no'  style='border:none;'/>";
}
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
	}else{
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
			}
		}
	}
}

//이관여부
function transferStatusChange() {
	var transfer_status_Arr = Array();
	var sale_sequ_numb_Arr = Array();
	var cnt = 0;
	var rowCnt = $('#list').getGridParam('reccount');
	if(rowCnt > 0){
		for(var i =0; i<rowCnt; i++){
			var rowid = $('#list').getDataIDs()[i];
			if($("#isCheck_"+rowid).attr("checked")) {
				var selrowContent = $("#list").jqGrid('getRowData',rowid);
				if(selrowContent.transfer_status != ""){
					transfer_status_Arr[i] = selrowContent.transfer_status;
					sale_sequ_numb_Arr[i] = selrowContent.sale_sequ_numb;
					cnt++;
				}
			}	
		}
		if(cnt > 0){
			$.post(
					"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/transferStatusChange.sys",
			 		{
						transfer_status_Arr:transfer_status_Arr,
						sale_sequ_numb_Arr:sale_sequ_numb_Arr
			 		},
			 		function(arg){ 
			 			if(fnAjaxTransResult(arg)) {
			 				fnSearch();
			 			}
			 		}
			);
		}else{
			alert("이관여부를 선택하여 주십시오.");
		}
	}
}

function fnBondsHistory(){
	$("#list2").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBondsHistListJQGrid.sys'});
   	var data = jq("#list2").jqGrid("getGridParam", "postData");
   	data.clientId = '<%=detailInfo.getClientId()%>';
  	jq("#list2").jqGrid("setGridParam", { "postData": data });
  	jq("#list2").trigger("reloadGrid");	
}

/**
 * 첨부파일 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#attach_seq1").val(rtn_attach_seq);
	$("#attach_file_name1").html("<b>" + rtn_attach_file_name + "</b>");
	$("#attach_file_path1").val(rtn_attach_file_path);
}
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#attach_seq2").val(rtn_attach_seq);
	$("#attach_file_name2").html("<b>" + rtn_attach_file_name + "</b>");
	$("#attach_file_path2").val(rtn_attach_file_path);
}
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#attach_seq3").val(rtn_attach_seq);
	$("#attach_file_name3").html("<b>" + rtn_attach_file_name + "</b>");
	$("#attach_file_path3").val(rtn_attach_file_path);
}
function fnCallBackAttach4(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#attach_seq4").val(rtn_attach_seq);
	$("#attach_file_name4").html("<b>" + rtn_attach_file_name + "</b>");
	$("#attach_file_path4").val(rtn_attach_file_path);
}
function fnCallBackAttach5(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#attach_seq5").val(rtn_attach_seq);
	$("#attach_file_name5").html("<b>" + rtn_attach_file_name + "</b>");
	$("#attach_file_path5").val(rtn_attach_file_path);
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

</head>

<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
	<table width="98%" border="0" cellspacing="0" cellpadding="4" align="center">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
						</td>
						<td height="29" class="ptitle">업체별채권현황</td>
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
<!--					<td class="table_td_subject">지연이자</td> -->
<!--					<td class="table_td_contents"> -->
<!--						<input id="srcLoginId3" name="srcLoginId3" type="text" value="" size="" maxlength="50" class="input_none" readonly="readonly" style="text-align: right;"/> -->
<!--					</td> -->

						<td class="table_td_subject">주문제한여부</td>
						<td class="table_td_contents">
							<select id="isLimit" name="isLimit" style="width: 80px;vertical-align: bottom;" class="select">
								<option value="0" <%= CommonUtils.getString(detailInfo.getIsLimit()).equals("0") || CommonUtils.getString(priceInfo.getIsLimit()).equals("") ? "selected" : "" %> >주문정상</option>
								<option value="1" <%= CommonUtils.getString(detailInfo.getIsLimit()).equals("1") ? "selected" : "" %> >주문제한</option>
							</select>
							<a id='isLimitButton' class='btn btn-warning btn-xs'><i style="width: 5px;height: 1px;"></i>수정</a>
						
<%-- 							<select id="isLimit" name="isLimit" style="width: 80px;" class="select" <%=isAdmPower ? "" : "disabled"%> title="파워운영자만이 주문제한여부를 설정할 수 있습니다."> --%>
<%-- 								<option value="0" <%= CommonUtils.getString(detailInfo.getIsLimit()).equals("0") || CommonUtils.getString(priceInfo.getIsLimit()).equals("") ? "selected" : "" %> >주문정상</option> --%>
<%-- 								<option value="1" <%= CommonUtils.getString(detailInfo.getIsLimit()).equals("1") ? "selected" : "" %> >주문제한</option> --%>
<!-- 							</select> -->
<%-- <%	if(isAdmPower) { %> --%>
<%-- 							<a id='isLimitButton' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>;'><i style="width: 5px;height: 1px;"></i>수정</a> --%>
							
<%-- <%	} %> --%>
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
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" valign="top">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
						</td>
						<td class="stitle">채권목록</td>
						<td align="right" class="stitle">
							<a class="btn btn-success btn-xs" id="excelButton1"><i class="fa fa-file-excel-o"></i> 엑셀</a>
							<a id='srcButton' class='btn btn-primary btn-xs'><i class="fa fa-search"></i> 조 회</a>
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
						<td class="table_td_subject" width="100">마감년월</td>
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
						<td class="table_td_subject" width="90">이관여부</td>
						<td class="table_td_contents">
							<select id="srcTransferStatus" name="srcTransferStatus" class="select">
								<option value="">전체</option>
								<option value="0">예</option>
								<option value="1">아니오</option>
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
			<td align="right" valign="bottom">
<%-- 				<a id='transferStatusButton' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>;'><i class="fa fa-save"></i> 이관처리</a> --%>
				<a id='transferStatusButton' class='btn btn-warning btn-xs'><i class="fa fa-save"></i> 이관처리</a>
			</td>
		</tr>
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list"></table>
				</div>
			</td>
		</tr>

      	<tr>
           	<td>
            	<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                	<tr>
                  		<td width="20" valign="top">
                       		<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                   		</td>
                   		<td class="stitle">채권관리 History</td>
                   		<td align="right" class="stitle">
                   			<a class="btn btn-success btn-xs" id="excelButton2"><i class="fa fa-file-excel-o"></i> 엑셀</a>
							<a id='saveButton' class='btn btn-warning btn-xs'><i class='fa fa-plus'></i> 등록</a>                        		
							<a id='modButton' class='btn btn-warning btn-xs'><i class='fa fa-search'></i> 수정</a>
<%-- 							<a id='saveButton' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class='fa fa-plus'></i> 등록</a>                        		 --%>
<%-- 							<a id='modButton' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class='fa fa-search'></i> 수정</a> --%>
                   		</td>
                	</tr>
					<tr>
                   		<td colspan="3" height="5"></td>
               		</tr>                  		
                 		
               		<tr>
                   		<td valign="top" colspan="3">
	                    	<div id="jqgrid">
                       			<table id="list2"></table>
                       		</div>
                   		</td>
               		</tr>                  		
           		</table>            	
           	</td>         	
   		</tr>		
	</table>
	<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
		<p>처리할 데이터를 선택 하십시오!</p>
	</div>
	<!-------------------------------- Dialog Div Start -------------------------------->
	<div id="dialog" title="Feature not supported" style="display:none;">
		<p>That feature is not supported.</p>
	</div>      
		<!-------------------------------- Dialog Div End -------------------------------->
		
		
	<div class="jqmPopWindow" id="historyPop" style="z-index: 2">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div id="dialogHandle">
						<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>채권관리 History</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose" >
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
								<!-- 조회조건 -->
			               		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			                  		<tr>
			                     		<td colspan="8" class="table_top_line"></td>
			                  		</tr>
			                  		<tr>
			                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
			                  		</tr>
			                  		<tr>
			                     		<td class="table_td_subject" width="60"><font color='red'>*</font> 관리유형</td>
			                     		<td class="table_td_contents" colspan="3">
			                				<select id="manage_type">     		
			                					<option value="">선택</option>
<%	for(CodesDto codesDto : bondType) { %>
												<option value="<%=codesDto.getCodeVal1() %>"><%=codesDto.getCodeNm1() %></option>
<%	}	%>										                     		
			                     		</td>
			                     	</tr>
			                     	<tr>	
			                     		<td class="table_td_subject" width="100"><font color='red'>*</font> 내용</td>
			                     		<td class="table_td_contents" colspan="3">
			                        		<textarea id="contents" name="contents" rows="5" cols="" style="width: 98%;height: 200px;"></textarea>
			                     		</td>
			                  		</tr>
			                  		<tr>
			                     		<td class="table_td_subject" width="60" style="height: 34px;" >
			                     			첨부1 &nbsp;
			                     			<a id='attachButton1' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>;'><i class='fa fa-plus'></i> 등록</a>
			                     		</td>
			                     		<td class="table_td_contents" width="200">
			                     			<div id="attach_file_name1"></div>
			                        		<input id="attach_seq1" 		name="attach_seq1" 		type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                        		<input id="attach_file_path1" 	name="attach_file_path1" type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                     		</td>
			                     		<td class="table_td_subject" width="60" style="height: 34px;" >
			                     			첨부2 &nbsp;
			                     			<a id='attachButton2' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>;'><i class='fa fa-plus'></i> 등록</a>
			                     		</td>
			                     		<td class="table_td_contents" width="200">
			                     			<div id="attach_file_name2"></div>
			                        		<input id="attach_seq2" 		name="attach_seq2" 		type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                        		<input id="attach_file_path2" 	name="attach_file_path2" type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                     		</td>
			                     	</tr>	
			                  		<tr>
			                     		<td class="table_td_subject" width="60" style="height: 34px;" >
			                     			첨부3 &nbsp;
			                     			<a id='attachButton3' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>;'><i class='fa fa-plus'></i> 등록</a>
			                     		</td>
			                     		<td class="table_td_contents">
			                     			<div id="attach_file_name3"></div>
			                        		<input id="attach_seq3" 		name="attach_seq3" 		type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                        		<input id="attach_file_path3" 	name="attach_file_path3" type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                     		</td>
			                     		<td class="table_td_subject" width="60" style="height: 34px;" >
			                     			첨부4 &nbsp;
			                     			<a id='attachButton4' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>;'><i class='fa fa-plus'></i> 등록</a>
			                     		</td>
			                     		<td class="table_td_contents">
			                     			<div id="attach_file_name4"></div>
			                        		<input id="attach_seq4" 		name="attach_seq4" 		type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                        		<input id="attach_file_path4" 	name="attach_file_path4" type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                     		</td>
			                     	</tr>	
			                  		<tr>
			                     		<td class="table_td_subject" width="60" style="height: 34px;" >
			                     			첨부5 &nbsp;
			                     			<a id='attachButton5' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>;'><i class='fa fa-plus'></i> 등록</a>
			                     		</td>
			                     		<td class="table_td_contents">
			                     			<div id="attach_file_name5"></div>
			                        		<input id="attach_seq5" 		name="attach_seq5" 		type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                        		<input id="attach_file_path5" 	name="attach_file_path5" type="hidden" style="width: 98%;" type="text" size="" maxlength="50" class="input_none"/>
			                     		</td>
			                     	</tr>	
									<tr>
			                     		<td colspan="8" height="1" bgcolor="eaeaea"></td>
			                  		</tr>
			                  		<tr>
			                     		<td colspan="8" class="table_top_line"></td>
			                  		</tr>			                  		
			                  	</table>
			                  	
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
			                     		<td height="10"></td>
			                  		</tr>									
									<tr>
										<td align="center">
											<a id='hisSaveButton' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class='fa fa-save'></i> 저장</a>
											<a id='hisModButton' class='btn btn-warning btn-xs' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class='fa fa-save'></i> 수정</a>
											<a id='hisCloseButton' class='btn btn-primary btn-xs' style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" ><i class='fa fa-search'></i> 닫기</a>
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