<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
// 	int listWidth = 450;
	String listHeight = "$(window).height()-415 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";
	String _menuId    = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
    // 날짜 세팅
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css" media="screen">
    th.ui-th-column div{
        white-space:normal !important;
        height:auto !important;
    }
</style>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td class='ptitle'>BMT 관리 현황</td> 
					<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
<!-- 						<button id='xlsButton' class="btn btn-success btn-sm"> -->
<!-- 							<i class="fa fa-file-excel-o"></i> -->
<!-- 							엑셀 -->
<!-- 						</button> -->
						<button id='srcButton' class="btn btn-default btn-sm">
							<i class="fa fa-search"></i>
							조회
						</button>
					</td>
				</tr>
			</table>
			<form id="frmSearch">
			<!-- Search Context -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">소싱명</td>
					<td class="table_td_contents">
						<input id="srcItemNm" name="srcItemNm" type="text"/>
						<input id="qualityYYYY" name="qualityYYYY" type="hidden" value="<%=CommonUtils.getCurrentDate().substring(0, 4) %>" />
					</td>
					<td class="table_td_subject" width="100">품목유형</td>
					<td class="table_td_contents" colspan='3'>
						<select name="srcItemType1" id="srcItemType1" class="select"><option value="">유형1 전체</option></select>
						<select name="srcItemType2" id="srcItemType2" class="select"><option value="">유형2 전체</option></select>
					</td>
				</tr>
				<tr>
					<td colspan="6" class="table_middle_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">업체명</td>
					<td class="table_td_contents">
						<input id="srcVendorNm" name="srcVendorNm" type="text"/>
					</td>
					<td class="table_td_subject" width="100">담당자</td>
					<td class="table_td_contents">
						<input id="srcChargerNm" name="srcChargerNm" type="text"/>
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='8'></td>
				</tr>
			</table>
			</form>
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<col width="450" />
				<col />
				<col width="100%"/>
				<tr>
					<td align="right" valign="bottom">
						<button id='openButton' class="btn btn-primary btn-xs">
							<i class="fa fa-plus"></i> Open All
						</button>
						<button id='closeButton' class="btn btn-primary btn-xs">
							<i class="fa fa-minus"></i> Close All
						</button>
						<button id='regButton' class="btn btn-warning btn-xs">
							<i class="fa fa-save"></i> 등록
						</button>
<!-- 						<button id='transButton' class="btn btn-warning btn-xs"> -->
<!-- 							<i class="fa fa-save"></i> 자료이관 -->
<!-- 						</button> -->
					</td>
				</tr>
				<tr><td height="1"></td></tr>
				<tr>
					<td valign="top">
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
<%@ include file="/WEB-INF/jsp/common/attachFileDivCommnet.jsp" %>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<script type="text/javascript">
$(function(){
    $.ajaxSetup ({
        cache: false
    });
	fnDataInit();
	fnGridInit();
	
	$('#srcButton').click(function (e) {
		fnSearch();
	});
	$('#xlsButton').click(function (e) {
		var colLabels = ['품목명','연간규모','품목유형1','품목유형2','품목유형3','안내서','규격서','등록일','마감일','품목상태','신청업체','담당자'];   //출력컬럼명
		var colIds = ['ITEMNM','YEARLYSIZE','ITEMTYPE1','ITEMTYPE2','ITEMTYPE3','GUIDEBOOKATTACHFILE','SPECSATTACHFILE','REGIDATE','DEADLINEDATE','ITEMSTATENM','APPLCNT','CHARGERNM'];   //출력컬럼ID
		var numColIds = ['YEARLYSIZE'];  //숫자표현ID
		var sheetTitle = "대상품목관리"; //sheet 타이틀
		var fieldSearchParamArray = new Array();     //파라메타 변수ID
		fieldSearchParamArray[0] = 'srcItemNm';
		fieldSearchParamArray[1] = 'srcCodeTypeNm';
		fieldSearchParamArray[2] = 'srcItemType1';
		fieldSearchParamArray[3] = 'srcItemType2';
		fieldSearchParamArray[5] = 'srcItemState';
		fieldSearchParamArray[8] = 'srcChargerNm';
		var excelFileName = "evaluateManageList";  //file명

		fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/evaluation/selectItemList/excel.sys");
	});
	
	$('#frmSearch').search();

	// 규격서 초기화//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#srcStandardButton').click(function (e) {
		fnSearchStandard();
	});
	$("#srcSourcingNms").keydown(function(e){ if(e.keyCode==13) { $("#srcStandardButton").click(); } });
	$("#srcSpecs").keydown(function(e){ if(e.keyCode==13) { $("#srcStandardButton").click(); } });
	
	$('#standardFileDiv').jqm();	//Dialog 초기화
	$("#standardCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#standardFileDiv").jqmHide();
		fnBondsCallback = "";
	});
	$('#standardFileDiv').jqm().jqDrag('#standardDialogHandle'); 
	$("#standardFileGrid").jqGrid({
		datatype: 'json', 
		mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
		colNames:['소싱명','규격','규격서','등록자(등록일)','SOURCINGID','ATTACH_SEQ','ISDISPLAYFILE','FILE_PATH'],
		colModel:[
			{name:'SOURCINGNM',index:'SOURCINGNM', width:150,align:"left",sortable:false,editable:false},
			{name:'SPEC',index:'SPEC', width:180,align:"left",search:false,sortable:false,editable:false},
			{name:'FILE_NAME',index:'FILE_NAME',align:"left", width:150,search:false,sortable:false,editable:false},
			{name:'REGUSER',index:'REGUSER', width:140,align:"center",search:false,sortable:false,editable:false},
			{name:'SOURCINGID',index:'SOURCINGID', hidden:true},
			{name:'ATTACH_SEQ',index:'ATTACH_SEQ', hidden:true},
			{name:'ISDISPLAYFILE',index:'ISDISPLAYFILE', hidden:true},
			{name:'FILE_PATH',index:'FILE_PATH', hidden:true}
		],
		postData: {},
		rowNum:30,  rowList:[10,20,30,50,100,500,1000], pager: '#standardFileDivPager',
		height:250, width:680, 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {  },
		afterInsertRow: function(rowid, aData){
			var selrowContent = $("#standardFileGrid").jqGrid('getRowData',rowid);
        	var sText = "";
        	if($.trim(selrowContent.FILE_PATH) != '' && $.trim(selrowContent.FILE_NAME) != ''){
        		sText = "<a href=\"javascript:fnAttachFileDownload('"+selrowContent.FILE_PATH+"')\"><font color='#0000ff'>"+selrowContent.FILE_NAME+"</font></a>";
        	}
			if(selrowContent.ISDISPLAYFILE == "Y"){
                $(this).setCell(rowid, 'FILE_NAME', "<button type='button' onclick=\"javascript:fnFileUpload('S','"+selrowContent.ATTACH_SEQ+"','"+selrowContent.SOURCINGID+"');\" class='btn btn-primary btn-xs'>등록</button>"+sText);
			}else{
                $(this).setCell(rowid, 'FILE_NAME', sText);
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#standardFileGrid").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});	
	
	
	// 절차서 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#srcProcessButton').click(function (e) {
		fnSearchProcess();
	});
	$("#srcSourcingNmp").keydown(function(e){ if(e.keyCode==13) { $("#srcProcessButton").click(); } });
	$("#srcSpecp").keydown(function(e){ if(e.keyCode==13) { $("#srcProcessButton").click(); } });
	
	$('#processFileDiv').jqm();	//Dialog 초기화
	$("#processCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#processFileDiv").jqmHide();
		fnBondsCallback = "";
	});
	$('#processFileDiv').jqm().jqDrag('#processDialogHandle'); 
	$("#processFileGrid").jqGrid({
		datatype: 'json', 
		mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
		colNames:['소싱명','규격','절차서','등록자(등록일)','SOURCINGID','ATTACH_SEQ','ISDISPLAYFILE','FILE_PATH'],
		colModel:[
			{name:'SOURCINGNM',index:'SOURCINGNM', width:150,align:"left",sortable:false,editable:false},
			{name:'SPEC',index:'SPEC', width:180,align:"left",search:false,sortable:false,editable:false},
			{name:'FILE_NAME',index:'FILE_NAME',align:"left", width:150,search:false,sortable:false,editable:false},
			{name:'REGUSER',index:'REGUSER', width:140,align:"center",search:false,sortable:false,editable:false},
			{name:'SOURCINGID',index:'SOURCINGID', hidden:true},
			{name:'ATTACH_SEQ',index:'ATTACH_SEQ', hidden:true},
			{name:'ISDISPLAYFILE',index:'ISDISPLAYFILE', hidden:true},
			{name:'FILE_PATH',index:'FILE_PATH', hidden:true}
		],
		postData: {},
		rowNum:30,  rowList:[10,20,30,50,100,500,1000], pager: '#processFileDivPager',
		height:250, width:680, 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {  },
		afterInsertRow: function(rowid, aData){
			var selrowContent = $("#processFileGrid").jqGrid('getRowData',rowid);
        	var pText = "";
        	if($.trim(selrowContent.FILE_PATH) != '' && $.trim(selrowContent.FILE_NAME) != ''){
        		pText = "<a href=\"javascript:fnAttachFileDownload('"+selrowContent.FILE_PATH+"')\"><font color='#0000ff'>"+selrowContent.FILE_NAME+"</font></a>";
        	}
			if(selrowContent.ISDISPLAYFILE == "Y"){
                $(this).setCell(rowid, 'FILE_NAME', "<button type='button' onclick=\"javascript:fnFileUpload('P','"+selrowContent.ATTACH_SEQ+"','"+selrowContent.SOURCINGID+"');\" class='btn btn-primary btn-xs'>등록</button>"+pText);
			}else{
                $(this).setCell(rowid, 'FILE_NAME', pText);
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#processFileGrid").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});	
	
	// 등록 화면 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#regSaveButton').click(function (e) { fnRegSourcing(); });
	$('#regDiv').jqm();	//Dialog 초기화
	$("#regCloseButton, .jqmClose").click(function(){	$("#regDiv").jqmHide(); });//Dialog 닫기
	$('#regDiv').jqm().jqDrag('#processDialogHandle'); 
	
	$('#sRegAttach').click(function (e) { fnUploadDialog("규격서", "" ,"fnSRegAttachCallBack" ,"9"); });
	$('#pRegAttach').click(function (e) { fnUploadDialog("절차서", "" ,"fnPRegAttachCallBack" ,"9"); });
	
	// 공급사 등록/수정 화면 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#venregSaveButton').click(function (e) { fnSaveSourcingVen(); });
	$('#venRegDiv').jqm();	//Dialog 초기화
	$("#venregCloseButton, .jqmClose").click(function(){	$("#venRegDiv").jqmHide(); });//Dialog 닫기
	$('#venRegDiv').jqm().jqDrag('#processDialogHandle'); 
	
    $("#btnVendor").click(function()            {   fnVendorSearchOpenPop();});
    $("#vendorNmVenDiv").keydown(function(e)     {   if(e.keyCode==13) { $("#btnVendor").click(); } });
    
	// 공급사 Lab/Field test 화면 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#lftd_SaveButton').click(function (e) { fnSaveSourcingTestInfo(); });
	$('#labFieldTest').jqm();	//Dialog 초기화
	$("#lftd_CloseButton, .jqmClose").click(function(){	$("#labFieldTest").jqmHide(); });//Dialog 닫기
	$('#labFieldTest').jqm().jqDrag('#processDialogHandle'); 
	$('#btnLftdAttach1').click(function (e) { fnLftdDivFileUpload($("#lftd_file_seq1").val(), "lftd_file_seq1"); });
	$('#btnLftdAttach2').click(function (e) { fnLftdDivFileUpload($("#lftd_file_seq2").val(), "lftd_file_seq2"); });
	
	// 공급사 Final 화면 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#bmtFinal').jqm();	//Dialog 초기화
	$('#bmtFinal').jqm().jqDrag('#processDialogHandle'); 
	$('#btnFinalAttach1').click(function (e) {	fnFinalDivFileUpload($("#final_file_seq1").val(), "final_file_seq1"); });
	$("#btmFinal_CloseButton, .jqmClose").click(function(){	$("#bmtFinal").jqmHide(); });//Dialog 닫기
	$('#btmFinal_Temp_SaveButton').click(function (e) { fnSaveSourcingFinalInfo('T'); });
	$('#btmFinal_SaveButton').click(function (e) { fnSaveSourcingFinalInfo('S'); });
    $("#bmtFinal_1stUserBtn").click(function(){ 
        var userNm 		= $("#1stApprUserNm").val();
        var svcTypeCd 	= "ADM";
        fnJqmUserInitSearch(userNm, "", svcTypeCd, "fnSelectUserCallback");
    });
    $("#bmtFinal_2ndUserBtn").click(function(){
        var userNm 		= $("#2ndApprUserNm").val();
        var svcTypeCd 	= "ADM";
        fnJqmUserInitSearch(userNm, "", svcTypeCd, "fnSelectUserCallback2");
    });
    $("#bmtFinal_1stUserDeleteBtn").click(function(){
		$("#1stApprUserNm").val("");
		$("#1stApprUserId").val("");
    });
    $("#bmtFinal_2ndUserDeleteBtn").click(function(){
		$("#2ndApprUserNm").val("");
		$("#2ndApprUserId").val("");
    });
	$("#1stApprUserNm").keydown(function(e){ if(e.keyCode==13) { $("#bmtFinal_1stUserBtn").click(); } });
	$("#1stApprUserNm").change(function(e){ if($("#1stApprUserNm").val()=="") { $("#1stApprUserNm").val(""); } });
	$("#2ndApprUserNm").keydown(function(e){ if(e.keyCode==13) { $("#bmtFinal_2ndUserBtn").click(); } });
	$("#2ndApprUserNm").change(function(e){ if($("#1stApprUserNm").val()=="") { $("#1stApprUserNm").val(""); } });
	
	
	// subGrid 처리
	$('#openButton').click(function (e) {
		var rowCnt = jq("#list").getGridParam('reccount');
		for(var i = 0; i < rowCnt; i++){
            var rowid = $("#list").getDataIDs()[i];
            $("#list").expandSubGridRow(rowid);
		}
	});
	$('#closeButton').click(function (e) {
		var rowCnt = jq("#list").getGridParam('reccount');
		for(var i = 0; i < rowCnt; i++){
            var rowid = $("#list").getDataIDs()[i];
           	$("#list").toggleSubGridRow(rowid);
		}
	});
	$('#transButton').click(function (e) {
		fnTransferData();
	});
	$('#regButton').click(function (e) {
		$("#regDiv").jqmShow();
	});
});
function fnVendorSearchOpenPop(){
    var vendorNm = $("#vendorNmVenDiv").val();   
    fnVendorDialog(vendorNm, "fnCallBackVendor");
}
function fnCallBackVendor(businessnum, bussinessnm, suggestphone){
    $("#vendorNmVenDiv").val(bussinessnm);
    $("#sourcingBusiNumbVenDiv").val(businessnum);
    $("#spanBusiNumbVenDiv").html(businessnum);
    $("#spanVendorTelVenDiv").html(suggestphone);
}
function fnSaveSourcingVen(){
	if(!confirm("입력한 정보를 저장하시겠습니까?")) return;
	$.blockUI();
	$.post(
        "/quality/saveSourcingVenInfo.sys",
        {
        	businessnum:$("#sourcingBusiNumbVenDiv").val()
        	,sourcingid:$("#venSourcingId").val()
        	,sourcingdesc:$("#sourcingDescVenDiv").val()
        },
        function(arg){
			if($.parseJSON(arg).customResponse.success){
				alert("처리가 완료되었습니다.");
				$("#venRegDiv").jqmHide();
            	$("#list").toggleSubGridRow($("#venSourcingId").val());
            	$("#list").expandSubGridRow($("#venSourcingId").val());
			}else{
				var errorMsg = "";
				for(var i =0; i < $.parseJSON(arg).customResponse.message.length;i++){
					if(i==0){
                        errorMsg = $.parseJSON(arg).customResponse.message[i];
					}else{
                        errorMsg += "\n"+$.parseJSON(arg).customResponse.message[i];
					}
				}
				alert(errorMsg);
			}
            $.unblockUI();
        }
	);
}
//코드 데이터 초기화 
function fnDataInit(){
	 $.post(  //조회조건의 품목유형1 세팅
	     '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
	     {
	         codeTypeCd:"SMPITEM_ITEMTYPE1",
	         isUse:"1"
	     },
	     function(arg){
	         var codeList = eval('(' + arg + ')').codeList;
	         for(var i=0;i<codeList.length;i++) {
	             $("#srcItemType1").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
	             $("#regItemType1").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
	         }
	     }
	 );  
     $.post(  //조회조건의 품목유형2 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPITEM_ITEMTYPE2",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#srcItemType2").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
                 $("#regItemType2").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
             }
         }
     );  
}
//날짜 데이터 초기화 

var subGrid = null;
//그리드 초기화////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/bmtManageList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['소싱명','규격','품목유형1','품목유형2','품질기준','규격서','절차서','담당자','업체수', '이관', 'SOURCINGID' ,'SPEC_FILE_SEQ' ,'SPEC_FILE_NAME' ,'SPEC_FILE_PATH' ,'PROC_FILE_SEQ' ,'PROC_FILE_NAME' ,'PROC_FILE_PATH', 'QUALITYID' ],
        colModel:[
            {name:'SOURCINGNM'		,width:180},//소싱명
            {name:'SPEC'			,width:200},//규격
            {name:'PRODTYPE1'		,width:70	,align:"center"},//품목유형1
            {name:'PRODTYPE2'		,width:70	,align:"center"},//품목유형2
            {name:'QUALITYSTD'		,width:130	,align:"center", hidden:true},//품질기준
            {name:'STANDARDFILE'	,width:180	,align:"left"},//규격서
            {name:'PROCESSFILE'		,width:180	,align:"left"},//절차서
            {name:'MANAGERNM'		,width:80},//담당자
            {name:'VENDORCNT'		,width:80	,align:"right"},//업체수
            {name:'TRANSBTN'		,width:40	,align:"center"},//이관
            {name:'SOURCINGID'		,width:80,hidden:true,key:true},//key
            {name:'SPEC_FILE_SEQ'		,width:80,hidden:true},
            {name:'SPEC_FILE_NAME'		,width:80,hidden:true},
            {name:'SPEC_FILE_PATH'		,width:80,hidden:true},
            {name:'PROC_FILE_SEQ'		,width:80,hidden:true},
            {name:'PROC_FILE_NAME'		,width:80,hidden:true},
            {name:'PROC_FILE_PATH'		,width:80,hidden:true},
            {name:'QUALITYID'			,width:80,hidden:true}
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true,  rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,width: <%=listWidth%>,
        sortname: '', sortorder: '',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
        	var sText = "";
        	var pText = "";
        	if($.trim(selrowContent.SPEC_FILE_PATH) != '' && $.trim(selrowContent.SPEC_FILE_NAME) != ''){
        		sText = "<a href=\"javascript:fnAttachFileDownload('"+selrowContent.SPEC_FILE_PATH+"')\"><font color='#0000ff'>"+selrowContent.SPEC_FILE_NAME+"</font></a>";
        	}
        	if($.trim(selrowContent.PROC_FILE_PATH) != '' && $.trim(selrowContent.PROC_FILE_NAME) != ''){
        		pText = "<a href=\"javascript:fnAttachFileDownload('"+selrowContent.PROC_FILE_PATH+"')\"><font color='#0000ff'>"+selrowContent.PROC_FILE_NAME+"</font></a>";
        	}
        	
            $(this).setCell(rowid,'STANDARDFILE','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
            $(this).setCell(rowid,'STANDARDFILE', "<button type='button' onclick=\"javascript:fnStandardFilePop('"+selrowContent.SOURCINGNM+"', '"+selrowContent.SPEC+"');\" class='btn btn-primary btn-xs'>관리</button>"+sText);
            $(this).setCell(rowid,'PROCESSFILE','',{color:'#0000ff',cursor: 'pointer','text-decoration':'underline'});
            $(this).setCell(rowid,'PROCESSFILE', "<button type='button' onclick=\"javascript:fnProcessFilePop('"+selrowContent.SOURCINGNM+"', '"+selrowContent.SPEC+"');\" class='btn btn-primary btn-xs'>관리</button>"+pText);
            $(this).setCell(rowid,'VENDORCNT', selrowContent.VENDORCNT+"  <button type='button' onclick=\"javascript:fnVendorRegPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.SOURCINGNM+"', '"+selrowContent.SPEC+"');\" class='btn btn-primary btn-xs'>등록</button>");
            
//             if('' == $.trim(selrowContent.QUALITYID)){
            $(this).setCell(rowid,'TRANSBTN', "<button type='button' onclick=\"javascript:fnTransRowData('"+selrowContent.SOURCINGID+"');\" class='btn btn-primary btn-xs'>이관</button>");            
//             }
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) { },
        subGrid:true,
        subGridUrl: '<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/selectSourcingVendorList/list.sys',
        subGridRowExpanded: function (grid_id, rowId) {
            var subgridTableId = grid_id + "_t";
            $("#" + grid_id).html("<table id='" + subgridTableId + "'></table>");
            $("#" + subgridTableId).jqGrid({
                url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/selectSourcingVendorList/list.sys',
                datatype: 'json',
                mtype: 'POST',
                postData: {sourcingid:rowId},
                colNames:['SOURCINGID','BUSINESSNUM','업체명','Lab Test','Field Test','최종'],
                colModel:[
                    {name:'SOURCINGID',width:150 , hidden:true},
                    {name:'BUSINESSNUM',width:100,align:'left',key:true, hidden:true},
                    {name:'BUSSINESSNM',width:170,align:'left'},
                    {name:'LAB_YN_NM',width:100,align:'center'},
                    {name:'FIELD_YN_NM',width:100,align:'center'},
                    {name:'FINAL_YN',width:100,align:'center'}
                ],
                jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
                height:'100%',
                afterInsertRow: function(rowid, aData) {
                    var selrowContent = $(this).jqGrid('getRowData',rowid);
                    $(this).setCell(rowid,'BUSSINESSNM','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
                    
                    if($.trim(selrowContent.LAB_YN_NM) != ''){
                    	var temp_color = selrowContent.LAB_YN_NM;
                    	if(temp_color == '적합'){
                    		temp_color = "green";
                    	}else if(temp_color == '부적합'){
                    		temp_color = "#ff0000";
                    	}else if(temp_color == '미실시'){
                    		temp_color = "#aaaaaa";
                    	}
                        $(this).setCell(rowid,'LAB_YN_NM', "  <a href='#' onclick=\"javascript:fnBmtTestPop('L','"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='"+temp_color+"' style=\"text-decoration:underline;\">"+selrowContent.LAB_YN_NM+"</font></a>");
                    }else{
                        $(this).setCell(rowid,'LAB_YN_NM', "  <button type='button' onclick=\"javascript:fnBmtTestPop('L','"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" class='btn btn-primary btn-xs'>등록</button>");
                    }
                    
                    if($.trim(selrowContent.FIELD_YN_NM) != ''){
                    	var temp_color = selrowContent.FIELD_YN_NM;
                    	if(temp_color == '적합'){
                    		temp_color = "green";
                    	}else if(temp_color == '부적합'){
                    		temp_color = "#ff0000";
                    	}else if(temp_color == '미실시'){
                    		temp_color = "#aaaaaa";
                    	}
                        $(this).setCell(rowid,'FIELD_YN_NM', "  <a href='#' onclick=\"javascript:fnBmtTestPop('F','"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='"+temp_color+"' style=\"text-decoration:underline;\">"+selrowContent.FIELD_YN_NM+"</font></a>");
                    }else{
                        $(this).setCell(rowid,'FIELD_YN_NM', "  <button type='button' onclick=\"javascript:fnBmtTestPop('F','"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" class='btn btn-primary btn-xs'>등록</button>");
                    }
                    
                    if($.trim(selrowContent.FINAL_YN) != ''){
                    	var tempFinalYn = selrowContent.FINAL_YN;
                    	if(tempFinalYn == '0'){
                            $(this).setCell(rowid,'FINAL_YN', "  <a href='#' onclick=\"javascript:fnBmtFinalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='#aaaaaa' style=\"text-decoration:underline;\">임시저장</font></a>");
                    	}else if(tempFinalYn == '10'){
                            $(this).setCell(rowid,'FINAL_YN', "  <a href='#' onclick=\"javascript:fnBmtFinalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='#007eff' style=\"text-decoration:underline;\">승인 중</font><font color='green' style=\"text-decoration:underline;\">(적합)</font></a>");
                    	}else if(tempFinalYn == '19'){
                            $(this).setCell(rowid,'FINAL_YN', "  <a href='#' onclick=\"javascript:fnBmtFinalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='#007eff' style=\"text-decoration:underline;\">승인 중</font><font color='red' style=\"text-decoration:underline;\">(부적합)</font></a>");
                    	}else if(tempFinalYn == '20'){
                            $(this).setCell(rowid,'FINAL_YN', "  <a href='#' onclick=\"javascript:fnBmtFinalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='red' style=\"text-decoration:underline;\">반려</font><font color='green' style=\"text-decoration:underline;\">(적합)</font></a>");
                    	}else if(tempFinalYn == '29'){
                            $(this).setCell(rowid,'FINAL_YN', "  <a href='#' onclick=\"javascript:fnBmtFinalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='red' style=\"text-decoration:underline;\">반려</font><font color='red' style=\"text-decoration:underline;\">(부적합)</font></a>");
                    	}else if(tempFinalYn == '90'){
                            $(this).setCell(rowid,'FINAL_YN', "  <a href='#' onclick=\"javascript:fnBmtFinalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='green' style=\"text-decoration:underline;\">적합</font></a>");
                    	}else if(tempFinalYn == '99'){
                            $(this).setCell(rowid,'FINAL_YN', "  <a href='#' onclick=\"javascript:fnBmtFinalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" ><font color='red' style=\"text-decoration:underline;\">부적합</font></a>");
                    	}
                    }else{
                        $(this).setCell(rowid,'FINAL_YN', "  <button type='button' onclick=\"javascript:fnBmtFinalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"');\" class='btn btn-primary btn-xs'>등록</button>");
                    }
                },
                onCellSelect: function(rowid, iCol, cellcontent, target) {
                    var selrowContent = $(this).jqGrid('getRowData',rowid);
                    var cm = $(this).jqGrid("getGridParam", "colModel");
                    var colName = cm[iCol];
                    if (cellcontent == '&nbsp;') return;
                    if(colName != undefined &&colName['name']=="BUSSINESSNM") {
                        fnVendorModPop(selrowContent.SOURCINGID, selrowContent.BUSINESSNUM);
                    }
                }
            });
           	$("#" + subgridTableId).jqGrid('setGroupHeaders', {
        		useColSpanStyle: true,
        		groupHeaders:[{startColumnName: 'LAB_YN', numberOfColumns: 3, titleText: 'BMT'}]
        	});  
        }
    });
	$("#list").jqGrid("setLabel", "rn", "순번");
	$("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: 'SOURCINGNM', numberOfColumns: 4, titleText: '상품정보'},
			{startColumnName: 'QUALITYSTD', numberOfColumns: 5, titleText: '품질정보'}
		]
	});
}
// Resizing
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');
// 조회 등록/수정/삭제 후에도 처리하기에 꼭 펑션으로 사용함. 
function fnSearch() {
    $("#list")
    .jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()})
    .trigger("reloadGrid");
}

function fnSearchStandard() {
	jq("#standardFileGrid").jqGrid("setGridParam", {"page":1});
   	var data = jq("#standardFileGrid").jqGrid("getGridParam", "postData");
   	data.sourcingnm = $("#srcSourcingNms").val();
   	data.spec = $("#srcSpecs").val();
	jq("#standardFileGrid").jqGrid("setGridParam", { "postData": data });
	jq("#standardFileGrid").trigger("reloadGrid");
}

function fnSearchProcess() {
	jq("#processFileGrid").jqGrid("setGridParam", {"page":1});
   	var data = jq("#processFileGrid").jqGrid("getGridParam", "postData");
   	data.sourcingnm = $("#srcSourcingNmp").val();
   	data.spec = $("#srcSpecp").val();
	jq("#processFileGrid").jqGrid("setGridParam", { "postData": data });
	jq("#processFileGrid").trigger("reloadGrid");
}
function fnStandardFilePop(sourcingnm, spec){
	$("#standardFileGrid").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/standardFileList/list.sys'});
   	var data = jq("#standardFileGrid").jqGrid("getGridParam", "postData");
   	data.sourcingnm = sourcingnm;
   	data.spec = spec;
  	jq("#standardFileGrid").jqGrid("setGridParam", { "postData": data });
  	jq("#standardFileGrid").trigger("reloadGrid");
  	$("#srcSourcingNms").val(sourcingnm);
  	$("#srcSpecs").val(spec);
	$("#standardFileDiv").jqmShow();
}

function fnProcessFilePop(sourcingnm, spec){
	$("#processFileGrid").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/processFileList/list.sys'});
   	var data = jq("#processFileGrid").jqGrid("getGridParam", "postData");
   	data.sourcingnm = sourcingnm;
   	data.spec = spec;
  	jq("#processFileGrid").jqGrid("setGridParam", { "postData": data });
  	jq("#processFileGrid").trigger("reloadGrid");
  	$("#srcSourcingNmp").val(sourcingnm);
  	$("#srcSpecp").val(spec);
	$("#processFileDiv").jqmShow();
}

function fnVendorRegPop(sId,sNm,sSp){
  	$("#venSourcingId").val(sId);
  	$("#vendorNmVenDiv").val("");
    $("#vendorNmVenDiv").prop("readonly",false);
  	$("#spanSoursingNmVenDiv").html(sNm);
  	$("#sourcingBusiNumbVenDiv").val("");
  	$("#spanSpecNmVenDiv").html(sSp);
    $("#spanBusiNumbVenDiv").html("");
    $("#spanVendorTelVenDiv").html("");
    $("#sourcingDescVenDiv").html("");
	$("#venRegDiv").jqmShow();
	$("#btnVendor").show();
}
function fnVendorModPop(sId,bNum){
	$.blockUI();
	$.post(
        "/quality/selectSourcingVendorList/detailObj/object.sys",
        {
        	sourcingid:sId
        	,businessnum:bNum
        },
        function(arg){
			var resultMap = eval('(' + arg + ')').detailObj;
            $("#venSourcingId").val(resultMap.SOURCINGID);
            $("#vendorNmVenDiv").val(resultMap.BUSSINESSNM);
            $("#vendorNmVenDiv").prop("readonly",true);
            $("#spanSoursingNmVenDiv").html(resultMap.SOURCINGNM);
            $("#sourcingBusiNumbVenDiv").val(resultMap.BUSINESSNUM);
            $("#spanSpecNmVenDiv").html(resultMap.SPEC);
            $("#spanBusiNumbVenDiv").html(resultMap.BUSINESSNUM);
            $("#spanVendorTelVenDiv").html(resultMap.SUGGESTPHONE);
            $("#sourcingDescVenDiv").html(resultMap.SOURCINGDESC);
            $("#venRegDiv").jqmShow();
            $("#btnVendor").hide();
            $.unblockUI();
        }
	);
}


function fnFileUpload(fileKind, attachSeq, sourcingId){
	var uploadTitle = "";
	var uploadCallBack = "";
	if(fileKind == 'S'){
		uploadTitle = "규격서";
		uploadCallBack = "fnCallBackStandardFile";
	}else if(fileKind == 'P'){
		uploadTitle = "절차서";
		uploadCallBack = "fnCallBackProcessFile";
	}
	fnUploadDialog(uploadTitle, "" ,uploadCallBack ,"9", sourcingId);
}
</script>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
/*규격서 콜백*/
function fnCallBackStandardFile(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path, seq) {
	fnQualityFileSave(rtn_attach_seq, seq, "S");
}
/*절차서 콜백*/
function fnCallBackProcessFile(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path, seq) {
	fnQualityFileSave(rtn_attach_seq, seq, "P");	
}

function fnQualityFileSave(attach_seq, sourcingId, kind){
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/qualityFileSave.sys",
		{
			kind:kind,
			attach_seq:attach_seq,
			sourcingId:sourcingId
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			var errors = "";
			if (result.success == false) {
				for (var i = 0; i < result.message.length; i++) {
					errors +=  result.message[i] + "<br/>";
				}
				alert(errors);
			} else {
				alert("처리 하였습니다.");
				if(kind == 'S'){
					$("#standardFileGrid").jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()}).trigger("reloadGrid");					
				}else if(kind == 'P'){
					$("#processFileGrid").jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()}).trigger("reloadGrid");
				}
			}
		}
	);	
}

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
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};

function fnAttachDel(columnName) {
	if(columnName=='lftd_file_seq2') {
		$("#file_list1").val('');
		$("#attach_file_name1").text('');
		$("#attach_file_path1").val('');
	} else if(columnName=='FIELD_FILE2') {
		$("#file_list2").val('');
		$("#attach_file_name2").text('');
		$("#attach_file_path2").val('');
	} 
}


function fnBmtTestPop(kind, sid, bnum){
	var kindTitle = "";
	var isLab = false;
	if(kind =="L"){
		isLab = true;
		kindTitle = "Lab";
	}else{
		kindTitle = "Field";
	}
  	$("#lftd_kind").val(kind);
  	$("#labFieldTestTitle1").html(kindTitle);
  	$("#labFieldTestTitle2").html(kindTitle);
  	
    $("#lftd_sdate").val("");
    $("#lftd_edate").val("");
    
    $("#lftd_file_seq1").val("");
    $("#lftd_file1").html("");
    $("#lftd_file_seq2").val("");
    $("#lftd_file2").html("");
    $("#lftd_desc").val("");
    
  	fnlabFieldTestInitDatePicker();
    $(".lftd_yn").each(function(index){
        $(this).prop("checked",false);
    });
	
	$.blockUI();
	$.post(
        "/quality/selectSourcingLabFieldInfo/detailObj/object.sys",
        {
        	sourcingid:sid
        	,businessnum:bnum
        },
        function(arg){
			var resultMap = eval('(' + arg + ')').detailObj;
			
            $("#lftd_sourcingid").val(resultMap.SOURCINGID);
            $("#lftd_businessnum").val(resultMap.BUSINESSNUM);
            
            $("#spanLabFieldTestDivSourcingNm").html(resultMap.SOURCINGNM);
            $("#spanLabFieldTestDivSpec").html(resultMap.SPEC);
            $("#spanLabFieldTestDivItem1").html(resultMap.PRODTYPE1_NM+" / "+resultMap.PRODTYPE2_NM);
            $("#spanLabFieldTestDivItem2").html(resultMap.QUALITYSTD_NM);
            $("#spanLabFieldTestDivVendorNm").html(resultMap.BUSSINESSNM);
            if($.trim(resultMap.SPEC_FILE_PATH) != "" && $.trim(resultMap.SPEC_FILE_NAME) != "" ){
                var tempSFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.SPEC_FILE_PATH+"')\"><font color='#0000ff'>"+resultMap.SPEC_FILE_NAME+"</font></a>";
                $("#spanLabFieldTestDivS").html(tempSFileNm);
            }else{
                $("#spanLabFieldTestDivS").html("");
            }
            if($.trim(resultMap.PROC_FILE_PATH) != "" && $.trim(resultMap.PROC_FILE_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.PROC_FILE_PATH+"')\"><font color='#0000ff'>"+resultMap.PROC_FILE_NAME+"</font></a>";
                $("#spanLabFieldTestDivP").html(tempPFileNm);
            }else{
                $("#spanLabFieldTestDivP").html("");
            }
            if(isLab){
            	$("#lftd_purpose").val(resultMap.LAB_PURPOSE);
            	
            	$(".lftd_yn").each(function(index){
            		if($(this).val() == $.trim(resultMap.LAB_YN)){
            			$(this).prop("checked",true);
            		}
            	});
            	
            	if(resultMap.LAB_DATE_FROM){
                    $("#lftd_sdate").val(resultMap.LAB_DATE_FROM);
            	}
            	if(resultMap.LAB_DATE_TO){
                    $("#lftd_edate").val(resultMap.LAB_DATE_TO);
            	}
            	
                if($.trim(resultMap.LAB_FILE1_NAME) != "" && $.trim(resultMap.LAB_FILE1_PATH) != "" ){
                    var templftd_file1 = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.LAB_FILE1_PATH+"')\"><font color='#0000ff'>"+resultMap.LAB_FILE1_NAME+"</font></a>";
                    $("#lftd_file1").html(templftd_file1);
                    $("#lftd_file_seq1").val(resultMap.LAB_FILE1);
                }
                if($.trim(resultMap.LAB_FILE2_NAME) != "" && $.trim(resultMap.LAB_FILE2_PATH) != "" ){
                    var templftd_file2 = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.LAB_FILE2_PATH+"')\"><font color='#0000ff'>"+resultMap.LAB_FILE2_NAME+"</font></a>";
                    $("#lftd_file2").html(templftd_file2);
                    $("#lftd_file_seq2").val(resultMap.LAB_FILE2);
                }
                
            	$("#lftd_desc").val(resultMap.LAB_DESC);
            }else{
            	$("#lftd_purpose").val(resultMap.FIELD_PURPOSE);
            	$(".lftd_yn").each(function(index){
            		if($(this).val() == $.trim(resultMap.FIELD_YN)){
            			$(this).prop("checked",true);
            		}
            	});
            	
            	if(resultMap.FIELD_DATE_FROM){
                    $("#lftd_sdate").val(resultMap.FIELD_DATE_FROM);
            	}
            	if(resultMap.FIELD_DATE_TO){
                    $("#lftd_edate").val(resultMap.FIELD_DATE_TO);
            	}
            	
                if($.trim(resultMap.FIELD_FILE1_NAME) != "" && $.trim(resultMap.FIELD_FILE1_PATH) != "" ){
                    var templftd_file1 = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.FIELD_FILE1_PATH+"')\"><font color='#0000ff'>"+resultMap.FIELD_FILE1_NAME+"</font></a>";
                    $("#lftd_file1").html(templftd_file1);
                    $("#lftd_file_seq1").val(resultMap.FIELD_FILE1);
                }
                if($.trim(resultMap.FIELD_FILE2_NAME) != "" && $.trim(resultMap.FIELD_FILE2_PATH) != "" ){
                    var templftd_file2 = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.FIELD_FILE2_PATH+"')\"><font color='#0000ff'>"+resultMap.FIELD_FILE2_NAME+"</font></a>";
                    $("#lftd_file2").html(templftd_file2);
                    $("#lftd_file_seq2").val(resultMap.FIELD_FILE2);
                }
            	$("#lftd_desc").val(resultMap.FIELD_DESC);
            }
            
            $("#labFieldTest").jqmShow();
			
            $.unblockUI();
        }
	);
}


function fnLftdDivFileUpload(attachSeq, attachId){
	fnUploadDialog("첨부파일", attachSeq ,"fnCallBackProcessLftdFile" ,"9", attachId);
}
function fnCallBackProcessLftdFile(rtn_attach_seq,rtn_attach_file_name,rtn_attach_file_path,seq){
    if(seq == "lftd_file_seq1"){
        $("#lftd_file_seq1").val(rtn_attach_seq);
        var templftd_file1 = "<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>";
        $("#lftd_file1").html(templftd_file1);
    }else{
        $("#lftd_file_seq2").val(rtn_attach_seq);
        var templftd_file2 = "<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>";
        $("#lftd_file2").html(templftd_file2);
    }
}

function fnSRegAttachCallBack(rtn_attach_seq,rtn_attach_file_name,rtn_attach_file_path,seq){
    $("#sReg_file_seq").val(rtn_attach_seq);
    var templftd_file1 = "<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>";
    $("#sReg_file1").html(templftd_file1);	
}

function fnPRegAttachCallBack(rtn_attach_seq,rtn_attach_file_name,rtn_attach_file_path,seq){
    $("#pReg_file_seq").val(rtn_attach_seq);
    var templftd_file1 = "<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>";
    $("#pReg_file1").html(templftd_file1);
}


function fnSaveSourcingTestInfo(){
	var lftd_kind 			= $("#lftd_kind").val();
	var lftd_purpose 		= $("#lftd_purpose").val();
	var lftd_yn 			= $("input[name=lftd_yn]:checked").val();
	var lftd_sdate 			= $("#lftd_sdate").val();
	var lftd_edate 			= $("#lftd_edate").val();
	var lftd_file_seq1 		= $("#lftd_file_seq1").val();
	var lftd_file_seq2 		= $("#lftd_file_seq2").val();
	var lftd_desc 			= $("#lftd_desc").val();
	var lftd_sourcingid 	= $("#lftd_sourcingid").val();
	var lftd_businessnum 	= $("#lftd_businessnum").val();
	if($.trim(lftd_purpose).length == 0){
		alert("검사목적을 입력하여 주십시오.");
		return false;
	}
	if($.trim(lftd_yn).length == 0){
		alert("적합여부를 선택하여 주십시오.");
		return false;
	}
	if($.trim(lftd_sdate).length == 0){
		alert("일정 시작일을 입력하여 주십시오.");
		return false;
	}
	if($.trim(lftd_edate).length == 0){
		alert("일정 종료일을 입력하여 주십시오.");
		return false;
	}
	if(!confirm("입력한 정보를 저장하시겠습니까?")) return false;
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/saveQualityTestInfo.sys",
        {  
            	lftd_kind:lftd_kind
            ,	lftd_purpose:lftd_purpose
            ,	lftd_yn:lftd_yn
            ,	lftd_sdate:lftd_sdate
            ,	lftd_edate:lftd_edate
            ,	lftd_file_seq1:lftd_file_seq1
            ,	lftd_file_seq2:lftd_file_seq2
            ,	lftd_desc:lftd_desc
            ,	lftd_sourcingid:lftd_sourcingid
            ,	lftd_businessnum:lftd_businessnum
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
            	alert("처리하였습니다.");
                $("#labFieldTest").jqmHide();
            	$("#list").toggleSubGridRow(lftd_sourcingid);
            	$("#list").expandSubGridRow(lftd_sourcingid);
            }
        }
    );
}

function fnlabFieldTestInitDatePicker(){
	$("#lftd_sdate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd",
	});
	
	$("#lftd_edate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd",
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	
	$("#lftd_sdate").val("<%=CommonUtils.getCustomDay("DAY", -7)%>");
	$("#lftd_edate").val("<%=CommonUtils.getCurrentDate()%>");
}

function fnBmtFinalPop(sid,bnum){
    $("#spanBmtFinalSourcingNm").html("");
    $("#spanBtmFinalDivSpec").html("");
    $("#spanBtmFinalItem1").html("");
    $("#spanBtmFinalItem2").html("");
    $("#spanBtmFinalS").html("");
    $("#spanBtmFinalP").html("");
    $("#btmFinalLabTest").html("");
    $("#btmFinalFieldTest").html("");
    $(".btmFinal_yn").each(function(index){
        $(this).prop("checked",false);
    });
    $("#final_file_seq1").val("");
    $("#final_file1").html("");
	$.blockUI();
	$.post(
        "/quality/selectSourcingLabFieldInfo/detailObj/object.sys",
        {
        	sourcingid:sid
        	,businessnum:bnum
        },
        function(arg){
			var resultMap = eval('(' + arg + ')').detailObj;
			if(!resultMap.LAB_YN || !resultMap.FIELD_YN){
				alert("Lab test 와 Field Test 를 완료 해야만 등록할 수 있습니다.");
				return false;
			}
			
            $("#spanBmtFinalSourcingNm").html(resultMap.SOURCINGNM);
            $("#spanBtmFinalDivSpec").html(resultMap.SPEC);
            $("#spanBtmFinalItem1").html(resultMap.PRODTYPE1_NM+" / "+resultMap.PRODTYPE2_NM);
            $("#spanBtmFinalItem2").html(resultMap.QUALITYSTD_NM);
            $("#spanBtmFinalVendorNm").html(resultMap.BUSSINESSNM);
            if($.trim(resultMap.SPEC_FILE_PATH) != "" && $.trim(resultMap.SPEC_FILE_NAME) != "" ){
                var tempSFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.SPEC_FILE_PATH+"')\"><font color='#0000ff'>"+resultMap.SPEC_FILE_NAME+"</font></a>";
                $("#spanBtmFinalS").html(tempSFileNm);
            }else{
                $("#spanBtmFinalS").html("");
            }
            if($.trim(resultMap.PROC_FILE_PATH) != "" && $.trim(resultMap.PROC_FILE_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.PROC_FILE_PATH+"')\"><font color='#0000ff'>"+resultMap.PROC_FILE_NAME+"</font></a>";
                $("#spanBtmFinalP").html(tempPFileNm);
            }else{
                $("#spanBtmFinalP").html("");
            }
            var labtestTempStr = resultMap.LAB_YN;
            if(labtestTempStr == '90'){
            	labtestTempStr = "<font color='green'>"+resultMap.LAB_TEST+"</font>";
            }else if(labtestTempStr == '99'){
            	labtestTempStr = "<font color='red'>"+resultMap.LAB_TEST+"</font>";
            }else if(labtestTempStr == '95'){
            	labtestTempStr = "<font color='#aaaaaa'>"+resultMap.LAB_TEST+"</font>";
            }
            $("#btmFinalLabTest").html(labtestTempStr);
            
            var fieldtestTempStr = resultMap.FIELD_YN;
            if(fieldtestTempStr == '90'){
            	fieldtestTempStr = "<font color='green'>"+resultMap.FIELD_TEST+"</font>";
            }else if(fieldtestTempStr == '99'){
            	fieldtestTempStr = "<font color='red'>"+resultMap.FIELD_TEST+"</font>";
            }else if(fieldtestTempStr == '95'){
            	fieldtestTempStr = "<font color='#aaaaaa'>"+resultMap.FIELD_TEST+"</font>";
            } 
            $("#btmFinalFieldTest").html(fieldtestTempStr);
            
            $(".btmFinal_yn").each(function(index){
                if($(this).val() == $.trim(resultMap.FINAL_YN)){
                    $(this).prop("checked",true);
                }
            });
            
            if($.trim(resultMap.FINAL_GRADEFILE_PATH) != "" && $.trim(resultMap.FINAL_GRADEFILE_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.FINAL_GRADEFILE_PATH+"')\"><font color='#0000ff'>"+resultMap.FINAL_GRADEFILE_NAME+"</font></a>";
                $("#final_file1").html(tempPFileNm);
                $("#final_file_seq1").val(resultMap.FINAL_GRADEFILE);
            }
            $("#final_mst_sourcingId").val(resultMap.SOURCINGID);
            $("#final_mst_businissnum").val(resultMap.BUSINESSNUM);
            
            $("#1stApprUserId").val(resultMap.FINAL_APPID1);
            $("#2ndApprUserId").val(resultMap.FINAL_APPID2);
            
            var appDate1 = fnGetString(resultMap.FINAL_APPDATE1) == '' ? '' : ' ('+resultMap.FINAL_APPDATE1+')';
            var appDate2 = fnGetString(resultMap.FINAL_APPDATE2) == '' ? '' : ' ('+resultMap.FINAL_APPDATE2+')';

            $("#1stApprUserNm").val(resultMap.FINAL_APPID1_NM);
            $("#2ndApprUserNm").val(resultMap.FINAL_APPID2_NM);
            
            $("#bmtFinal_appKind1").html(fnGetString(resultMap.FINAL_APPKIND1_NM) + appDate1);
            $("#bmtFinal_appKind2").html(fnGetString(resultMap.FINAL_APPKIND2_NM) + appDate2);
            $("#bmtFinal_appcomment1").prop("readonly",true);
            $("#bmtFinal_appcomment2").prop("readonly",true);
            $("#bmtFinal_appcomment1").val(resultMap.FINAL_APPCOMMENT1);
            $("#bmtFinal_appcomment2").val(resultMap.FINAL_APPCOMMENT2);
            
            if(!resultMap.FINAL_REQKIND){
                $("#btmFinal_Temp_SaveButton").show();
                $("#btmFinal_SaveButton").show();
                $("#bmtFinal_1stUserBtn").show();
                $("#bmtFinal_2ndUserBtn").show();
                $("#bmtFinal_1stUserDeleteBtn").show();
                $("#bmtFinal_2ndUserDeleteBtn").show();
            }else if(resultMap.FINAL_REQKIND == "0" || resultMap.FINAL_REQKIND == "20" || resultMap.FINAL_REQKIND == "29" || resultMap.FINAL_REQKIND == "99"){
                $("#btmFinal_Temp_SaveButton").hide();
                $("#btmFinal_SaveButton").show();
                $("#bmtFinal_1stUserBtn").show();
                $("#bmtFinal_2ndUserBtn").show();
                $("#bmtFinal_1stUserDeleteBtn").show();
                $("#bmtFinal_2ndUserDeleteBtn").show();
            }else{	
                $("#btmFinal_Temp_SaveButton").hide();
                $("#btmFinal_SaveButton").hide();
                $("#bmtFinal_1stUserDeleteBtn").hide();
                $("#bmtFinal_2ndUserDeleteBtn").hide();
                $("#bmtFinal_1stUserBtn").hide();
                $("#bmtFinal_2ndUserBtn").hide();
            }
            
            $("#bmtFinal").jqmShow();
            
            $.unblockUI();
        }
	);
}
function fnFinalDivFileUpload(attachSeq, attachId){
	fnUploadDialog("첨부파일", attachSeq ,"fnCallBackProcessFinalFile" ,"9", attachId);
}
function fnCallBackProcessFinalFile(rtn_attach_seq,rtn_attach_file_name,rtn_attach_file_path,seq){
    $("#final_file_seq1").val(rtn_attach_seq);
    var templftd_file1 = "<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>";
    $("#final_file1").html(templftd_file1);
}

function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#1stApprUserId").val(userId);
	$("#1stApprUserNm").val(userNm);
}
function fnSelectUserCallback2(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#2ndApprUserId").val(userId);
	$("#2ndApprUserNm").val(userNm);
}


function fnSaveSourcingFinalInfo(kind){
	var confirmTempMsg = " 하시겠습니까?";
	if(kind == "T"){
		confirmTempMsg ="임시저장을"+confirmTempMsg;
	}else if(kind == "S"){
		confirmTempMsg ="승인요청을"+confirmTempMsg;
	}
	var final_kind 				= kind;
	var final_mst_sourcingId	= $("#final_mst_sourcingId").val();
	var final_mst_businissnum	= $("#final_mst_businissnum").val();
	var btmFinal_yn				= $("input[name=btmFinal_yn]:checked").val();
	var final_file_seq1			= $("#final_file_seq1").val();
	var final_1stApprUserId		= $("#1stApprUserId").val();
	var final_2ndApprUserId		= $("#2ndApprUserId").val();
	if($.trim(btmFinal_yn).length == 0){
		alert("적합여부를 선택하여 주십시오.");
		return false;
	}
	if($.trim(final_1stApprUserId).length == 0){
		alert("1차 승인자를 선택하여 주십시오.");
		return false;
	}
// 	if($.trim(final_2ndApprUserId).length == 0){
// 		alert("2차 승인자를 선택하여 주십시오.");
// 		return false;
// 	}
	if(!confirm(confirmTempMsg)) return false;
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/saveBmtFinalReqInfo.sys",
        {  
            	final_kind:final_kind
            ,	final_mst_sourcingId:final_mst_sourcingId
            ,	final_mst_businissnum:final_mst_businissnum
            ,	btmFinal_yn:btmFinal_yn
            ,	final_file_seq1:final_file_seq1
            ,	final_1stApprUserId:final_1stApprUserId
            ,	final_2ndApprUserId:final_2ndApprUserId
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
            	alert("처리하였습니다.");
                $("#bmtFinal").jqmHide();
            	$("#list").toggleSubGridRow(final_mst_sourcingId);
            	$("#list").expandSubGridRow(final_mst_sourcingId);
            }
        }
    );
}

function fnTransferData(){
	
	if(!confirm("자료를 이관하시겠습니까?")) return false;
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/saveTransBmtData.sys",
        
        function(arg){
            var result = eval('(' + arg + ')').customResponse;
            if (result.success == false) {
                  var errors = "";
                for (var i = 0; i < result.message.length; i++) {
                    errors +=  result.message[i] + "<br/>";
                }
                alert(errors);
            } else {
            	alert("처리하였습니다.");
            }
        }
    );	
}
function fnTransRowData(sourcingId){
	if(!confirm("자료를 이관하시겠습니까?")) return false;
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/saveTransBmtRowData.sys",
        {sourcingId:sourcingId},
        function(arg){
            var result = eval('(' + arg + ')').customResponse;
            if (result.success == false) {
                  var errors = "";
                for (var i = 0; i < result.message.length; i++) {
                    errors +=  result.message[i] + "<br/>";
                }
                alert(errors);
            } else {
            	alert("처리하였습니다.");
            	fnSearch();
            }
        }
    );	
}

function fnRegSourcing(){
	var regSourcingNm 	= $.trim($("#regSourcingNm").val());		
	var regSpec			= $.trim($("#regSpec").val());
	var regItemType1	= $.trim($("#regItemType1").val());
	var regItemType2	= $.trim($("#regItemType2").val());
	var sRegFileSeq		= $.trim($("#sReg_file_seq").val());
	var pRegFileSeq		= $.trim($("#pReg_file_seq").val());
	
	if('' == regSourcingNm) {
		alert("소싱명을 입력해 주세요");
		$("#regSourcingNm").focus();
		return;
	}
	
	if('' == regSpec) {
		alert("규격을 입력해 주세요.");
		$("#regSpec").focus();
		return;
	}
	
	if('' == regItemType1) {
		alert("품목유형1 을 입력해 주세요");
		$("#regItemType1").focus();
		return;
	}
	
	if('' == regItemType2) {
		alert("품목유형2 을 입력해 주세요");
		$("#regItemType2").focus();
		return;
	}
	
	
	if(!confirm("BMT 를 생성하시겠습니까?")) return false;
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/saveRegSourcing.sys",
        {  
        	regSourcingNm:regSourcingNm,
        	regSpec:regSpec,
        	regItemType1:regItemType1,
        	regItemType2:regItemType2,
        	sRegFileSeq:sRegFileSeq,
        	pRegFileSeq:pRegFileSeq
    	},
        function(arg){
            var result = eval('(' + arg + ')').customResponse;
            if (result.success == false) {
                  var errors = "";
                for (var i = 0; i < result.message.length; i++) {
                    errors +=  result.message[i] + "<br/>";
                }
                alert(errors);
            } else {
            	alert("처리하였습니다.");
            	$("#regDiv").jqmHide();
            	fnSearch();
            }
        }
    );	
}

</script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.bmtWindow {
    display: none;
    position: absolute;
    top: 5%;
    left: 20%;
    width: 600px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
    z-index: 1003;
}
.bmtWindow.std {
	top: 25%;
    left: 30%;
    width: 720px;
}
.bmtWindow.prc {
	top: 25%;
    left: 30%;
    width: 720px;
}
.bmtWindow.ven {
	top: 25%;
    left: 30%;
    width: 400px;
}

.bmtWindow.labFieldTest {
	top: 25%;
    left: 30%;
    width: 700px;
}
.bmtWindow.bmtFinal {
	top: 25%;
    left: 30%;
    width: 700px;
}

.bmtWindow.reg {
	top: 25%;
    left: 30%;
    width: 700px;
}

.jqmOverlay { background-color: #000; }

* html .bmtWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<div class="bmtWindow std" id="standardFileDiv">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="standardDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>규격서 관리</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose"  >
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
                            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4" height='5'></td>
                                </tr>				
                                <tr>
                                    <td colspan="4" align="right" height="30" valign="top">
                                        <button id='srcStandardButton' class="btn btn-default btn-sm"><i class="fa fa-search"></i> 조회</button>
                                    </td>
                                </tr>				
                                <tr>
                                    <td colspan="4" style="height: 3px"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                	
                                    <td class="table_td_subject" width="100">소싱명</td>
                                    <td class="table_td_contents">
                                        <input id="srcSourcingNms" name="srcSourcingNms" type="text"/>
                                    </td>
                                    <td class="table_td_subject" width="100">규격</td>
                                    <td class="table_td_contents">
                                        <input id="srcSpecs" name="srcSpecs" type="text"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="height: 8px"></td>
                                </tr>
                            </table>				

							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="standardFileGrid"></table>
											<div id="standardFileDivPager"></div>
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
										<button id="standardCloseButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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

<div class="bmtWindow prc" id="processFileDiv">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="processDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>절차서 관리</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose"  >
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
                            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4" height='5'></td>
                                </tr>				
                                <tr>
                                    <td colspan="4" align="right" height="30" valign="top">
                                        <button id='srcProcessButton' class="btn btn-default btn-sm"><i class="fa fa-search"></i> 조회</button>
                                    </td>
                                </tr>				
                                <tr>
                                    <td colspan="4" style="height: 3px"></td>
                                </tr>				
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='1'></td>
                                </tr>
                                <tr>
                                    <td class="table_td_subject" width="100">소싱명</td>
                                    <td class="table_td_contents">
                                        <input id="srcSourcingNmp" name="srcSourcingNmp" type="text"/>
                                    </td>
                                    <td class="table_td_subject" width="100">규격</td>
                                    <td class="table_td_contents">
                                        <input id="srcSpecp" name="srcSpecp" type="text"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='1'></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='8'></td>
                                </tr>
                            </table>				

							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="processFileGrid"></table>
											<div id="processFileDivPager"></div>
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
										<button id="processCloseButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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

<div class="bmtWindow ven" id="venRegDiv">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="processDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>공급사 등록/수정</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose"  >
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
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="2" class="table_top_line"></td>
                                </tr>
								<tr>
									<td  class="table_td_subject">소싱명</td>
									<td  class="table_td_contents">
										<span id="spanSoursingNmVenDiv"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">규격</td>
									<td class="table_td_contents"><span id="spanSpecNmVenDiv"></span></td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">공급사명</td>
									<td class="table_td_contents">
										<input type="hidden"  id="sourcingBusiNumbVenDiv" name="sourcingBusiNumbVenDiv" value=""/>
										<input type="hidden"  id="venSourcingId" name="venSourcingId" value=""/>
                                        <input type="text" id="vendorNmVenDiv" name="vendorNmVenDiv" style="width: 150px">
                                        <a href="#"> <img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; border: 0;" align="middle" class="icon_search" <%=CommonUtils.getDisplayRoleButton(roleList,"COMM_READ")%>" /> </a>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">사업자번호</td>
									<td class="table_td_contents"><span id="spanBusiNumbVenDiv"></span></td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">연락처</td>
									<td class="table_td_contents"><span id="spanVendorTelVenDiv"></span></td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">참고사항</td>
									<td class="table_td_contents">
										<textarea rows="4" id="sourcingDescVenDiv" name="sourcingDescVenDiv" style="width:236px; height: 80px" ></textarea>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_top_line"></td>
                                </tr>
							</table>
							<p style="height: 5px"></p>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="venregSaveButton" type="button" class="btn btn-danger btn-sm"><i class="fa fa-close"></i>저장</button>
										<button id="venregCloseButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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

<div class="bmtWindow reg" id="regDiv">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="processDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>BMT 등록</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose"  >
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
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
								<tr>
									<td  class="table_td_subject" width="100"><font color="red">*</font> 소싱명</td>
									<td  class="table_td_contents" colspan="3">
										<input type="text" id="regSourcingNm" name="regSourcingNm" style="width: 98%" />
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject"><font color="red">*</font> 규격</td>
									<td class="table_td_contents" colspan="3">
										<input type="text" id="regSpec" name="regSpec" style="width: 98%" />
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject"><font color="red">*</font> 품목유형</td>
									<td class="table_td_contents" colspan="3">
										<select name="regItemType1" id="regItemType1" class="select" style="width: 100px;" ><option value="">선택</option></select>
										<select name="regItemType2" id="regItemType2" class="select" style="width: 100px;" ><option value="">선택</option></select>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">규격서</td>
									<td class="table_td_contents">
										<button id='sRegAttach' class="btn btn-darkgray btn-xs" >등록</button>
										<input type="hidden" id="sReg_file_seq" value=""/>
										<span id="sReg_file1"></span>
									</td>
									<td class="table_td_subject" width="100">절차서</td>
									<td class="table_td_contents">
										<button id='pRegAttach' class="btn btn-darkgray btn-xs" >등록</button>
										<input type="hidden" id="pReg_file_seq" value=""/>
										<span id="pReg_file1"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
							</table>
							<p style="height: 5px"></p>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="regSaveButton" type="button" class="btn btn-danger btn-sm"><i class="fa fa-close"></i>저장</button>
										<button id="regCloseButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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

<div class="bmtWindow labFieldTest" id="labFieldTest">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="processDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>BMT(<span id="labFieldTestTitle1"></span> Test)</h1>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose"  >
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
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                	<tr valign="top">
                                        <td width="20" valign="middle">
                                            <img width="14" height="15" src="/img/system/bullet_ptitle1.gif">
                                        </td>
                                        <td height="29" class="ptitle">상품정보</td>
                                    </tr>
                                </tbody>
                            </table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
								<tr>
									<td  class="table_td_subject">소싱명</td>
									<td  class="table_td_contents" colspan="3">
										<span id="spanLabFieldTestDivSourcingNm"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">규격</td>
									<td class="table_td_contents"><span id="spanLabFieldTestDivSpec"></span></td>
									<td class="table_td_subject">상품유형</td>
									<td class="table_td_contents"><span id="spanLabFieldTestDivItem1"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
<!-- 									<td class="table_td_subject">품질기준</td> -->
<!-- 									<td class="table_td_contents"><span id="spanLabFieldTestDivItem2"></span></td> -->
									<td class="table_td_subject">공급사</td>
									<td class="table_td_contents" colspan="3"><span id="spanLabFieldTestDivVendorNm"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">규격서</td>
									<td class="table_td_contents"><span id="spanLabFieldTestDivS"></span></td>
									<td class="table_td_subject">절차서</td>
									<td class="table_td_contents"><span id="spanLabFieldTestDivP"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
							</table>
							<br/>
		        			<h5></h5>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                	<tr valign="top">
                                        <td width="20" valign="middle">
                                            <img width="14" height="15" src="/img/system/bullet_ptitle1.gif">
                                        </td>
                                        <td height="29" class="ptitle"><span id="labFieldTestTitle2"></span> Test</td>
                                    </tr>
                                </tbody>
                            </table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
								<tr>
									<td  class="table_td_subject">검사목적</td>
									<td  class="table_td_contents" colspan="3">
										<input type="hidden" id="lftd_sourcingid" value="" />
										<input type="hidden" id="lftd_businessnum" value="" />
										<input type="hidden" id="lftd_kind" value="" />
										<input type="text" id="lftd_purpose" value="" style="width: 90%"/>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">적합여부</td>
									<td class="table_td_contents">
										<label for="lftd_yn90"><input type="radio" class="lftd_yn" name="lftd_yn" id="lftd_yn90" value="90"/>적합</label>
										<label for="lftd_yn99"><input type="radio" class="lftd_yn" name="lftd_yn" id="lftd_yn99" value="99"/>부적합</label>
										<label for="lftd_yn95"><input type="radio" class="lftd_yn" name="lftd_yn" id="lftd_yn95" value="95"/>미실시</label>
									</td>
									<td class="table_td_subject">일정</td>
									<td class="table_td_contents">
										<input type="text" id="lftd_sdate" size="12"/>
										~<input type="text" id="lftd_edate" size="12"/>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">첨부1</td>
									<td class="table_td_contents">
										<button id='btnLftdAttach1' class="btn btn-darkgray btn-xs" >등록</button>
										<input type="hidden" id="lftd_file_seq1" value=""/>
										<span id="lftd_file1"></span>
									</td>
									<td class="table_td_subject">첨부2</td>
									<td class="table_td_contents">
										<button id='btnLftdAttach2' class="btn btn-darkgray btn-xs">등록</button>
										<input type="hidden" id="lftd_file_seq2" value=""/>
										<span id="lftd_file2"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">검사내용</td>
									<td class="table_td_contents" colspan="3">
										<textarea rows="4" id="lftd_desc" name="lftd_desc" style="width:90%; height: 80px" ></textarea>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
							</table>
							<p style="height: 5px"></p>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="lftd_SaveButton" type="button" class="btn btn-danger btn-sm"><i class="fa fa-close"></i>저장</button>
										<button id="lftd_CloseButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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

<div class="bmtWindow bmtFinal" id="bmtFinal">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="processDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>BMT(최종)</h1>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose"  >
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
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                	<tr valign="top">
                                        <td width="20" valign="middle">
                                            <img width="14" height="15" src="/img/system/bullet_ptitle1.gif">
                                        </td>
                                        <td height="29" class="ptitle">상품정보</td>
                                    </tr>
                                </tbody>
                            </table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
								<tr>
									<td  class="table_td_subject">소싱명</td>
									<td  class="table_td_contents" colspan="3">
										<input type="hidden" id="final_mst_sourcingId" value=""/>
										<input type="hidden" id="final_mst_businissnum" value=""/>
										<span id="spanBmtFinalSourcingNm"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">규격</td>
									<td class="table_td_contents"><span id="spanBtmFinalDivSpec"></span></td>
									<td class="table_td_subject">상품유형</td>
									<td class="table_td_contents"><span id="spanBtmFinalItem1"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
<!-- 									<td class="table_td_subject">품질기준</td> -->
<!-- 									<td class="table_td_contents"><span id="spanBtmFinalItem2"></span></td> -->
									<td class="table_td_subject">공급사</td>
									<td class="table_td_contents" colspan="3"><span id="spanBtmFinalVendorNm"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">규격서</td>
									<td class="table_td_contents"><span id="spanBtmFinalS"></span></td>
									<td class="table_td_subject">절차서</td>
									<td class="table_td_contents"><span id="spanBtmFinalP"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
							</table>
							<br/>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                	<tr valign="top">
                                        <td width="20" valign="middle">
                                            <img width="14" height="15" src="/img/system/bullet_ptitle1.gif">
                                        </td>
                                        <td height="29" class="ptitle">성적서</td>
                                    </tr>
                                </tbody>
                            </table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">Lab Test</td>
									<td class="table_td_contents"><span id="btmFinalLabTest"></span></td>
									<td class="table_td_subject">Field Test</td>
									<td class="table_td_contents"><span id="btmFinalFieldTest"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">적합여부</td>
									<td class="table_td_contents">
										<label for="btmFinal_yn90"><input type="radio" class="btmFinal_yn" name="btmFinal_yn" id="btmFinal_yn90" value="90"/>적합</label>
										<label for="btmFinal_yn99"><input type="radio" class="btmFinal_yn" name="btmFinal_yn" id="btmFinal_yn99" value="99"/>부적합</label>
									</td>
									<td class="table_td_subject">성적서</td>
									<td class="table_td_contents">
										<button id='btnFinalAttach1' class="btn btn-darkgray btn-xs" >등록</button>
										<input type="hidden" id="final_file_seq1" value=""/>
										<span id="final_file1"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
							</table>
							<br/>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                	<tr valign="top">
                                        <td width="20" valign="middle">
                                            <img width="14" height="15" src="/img/system/bullet_ptitle1.gif">
                                        </td>
                                        <td height="29" class="ptitle">결재</td>
                                    </tr>
                                </tbody>
                            </table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="5" class="table_top_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject" rowspan="3" style="width: 40px">1차승인</td>
									<td class="table_td_subject" style="width: 40px">승인자</td>
									<td class="table_td_contents">
										<input type="text" id="1stApprUserNm" value=""/>
										<input type="hidden" id="1stApprUserId" value=""/>
                                        <button id="bmtFinal_1stUserBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-search fa-sm"></i></button>
                                        <button id="bmtFinal_1stUserDeleteBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-times fa-sm"></i></button>
									</td>
									<td class="table_td_subject" rowspan="3" style="width:60px">Comment</td>
									<td class="table_td_contents" rowspan="3">
										<textarea rows="2" cols="10" style="width:200px; height: 30px" id="bmtFinal_appcomment1"></textarea>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">상태</td>
									<td class="table_td_contents">
										<span id="bmtFinal_appKind1"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="5" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject" rowspan="3">2차승인</td>
									<td class="table_td_subject">승인자</td>
									<td class="table_td_contents">
										<input type="text" id="2ndApprUserNm" value=""/>
										<input type="hidden" id="2ndApprUserId" value=""/>
                                        <button id="bmtFinal_2ndUserBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-search fa-sm"></i></button>
                                        <button id="bmtFinal_2ndUserDeleteBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-times fa-sm"></i></button>
									</td>
									<td class="table_td_subject" rowspan="3">Comment</td>
									<td class="table_td_contents" rowspan="3">
										<textarea rows="2" cols="10" style="width:200px; height: 30px" id="bmtFinal_appcomment2"></textarea>
									</td>

								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">상태</td>
									<td class="table_td_contents">
										<span id="bmtFinal_appKind2"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="5" class="table_top_line"></td>
                                </tr>
							</table>
							<p style="height: 5px"></p>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="btmFinal_Temp_SaveButton" type="button" class="btn btn-gray btn-sm"><i class="fa fa-close"></i>임시저장</button>
										<button id="btmFinal_SaveButton" type="button" class="btn btn-danger btn-sm"><i class="fa fa-close"></i>승인요청</button>
										<button id="btmFinal_CloseButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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

<%@ include file="/WEB-INF/jsp/quality/vendorListDivForQuality.jsp"%>

<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>

</body>
</html>