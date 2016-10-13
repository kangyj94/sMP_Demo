<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.system.dao.CodeDao"%>
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

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
    // 날짜 세팅
    
	int EndYear   = 2008;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
	   srcYearArr[i] = (StartYear - i) + "";
	}
	
	String currDate = CommonUtils.getCurrentDate();
	
	List<CodesDto> qualityStdList = (List<CodesDto>)request.getAttribute("qualityStdList");
	List<UserDto>  adminUserList  = (List<UserDto>)request.getAttribute("adminUserList");
			
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
					<td class='ptitle'>품질 관리 현황</td> 
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
					<td class="table_td_subject" width="100">연도</td>
					<td class="table_td_contents">
						<select id="stdQualityYear" name="stdQualityYear" class="select" style="width: 70px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
							<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
						</select> 
					</td>
					<td class="table_td_subject" width="100">소싱명</td>
					<td class="table_td_contents">
						<input id="srcItemNm" name="srcItemNm" type="text"/>
					</td>
					<td class="table_td_subject" width="100">업체명</td>
					<td class="table_td_contents">
						<input id="srcVendorNm" name="srcVendorNm" type="text"/>
					</td>					

				</tr>
				<tr>
					<td colspan="6" class="table_middle_line"></td>
				</tr>
				<tr>
				
					<td class="table_td_subject" width="100">품목유형</td>
					<td class="table_td_contents">
						<select name="srcItemType1" id="srcItemType1" class="select"><option value="">유형1 전체</option></select>
						<select name="srcItemType2" id="srcItemType2" class="select"><option value="">유형2 전체</option></select>
					</td>				
				

					<td class="table_td_subject" width="100">담당자</td>
					<td class="table_td_contents">
						<input id="srcChargerNm" name="srcChargerNm" type="text"/>
					</td>
					<td class="table_td_subject" width="100">사용여부</td>
					<td class="table_td_contents">
						<select id="srcIsUse" name="srcIsUse">
							<option value="" >전체</option>
							<option value="Y" selected="selected">사용</option>
							<option value="N">종료</option>
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
					<td colspan="6" height='8'></td>
				</tr>
			</table>
			</form>
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
<!-- 				<col width="450" /> -->
<!-- 				<col /> -->
<!-- 				<col width="100%"/> -->
				<tr>
				
					<td align="left" valign="bottom">
						<span id="qualitySummarySpan" >
							※ <b>품질검사(실적/대상) : 0/0 (0%), VOC(완료/등록) :  0/0 (0%)</b>
						</span>
					</td>
				
					<td align="right" valign="bottom">
						<button id='openButton' class="btn btn-primary btn-xs">
							<i class="fa fa-plus"></i> Open All
						</button>
						<button id='closeButton' class="btn btn-primary btn-xs">
							<i class="fa fa-minus"></i> Close All
						</button>
						<button id='transButton' class="btn btn-warning btn-xs">
							<i class="fa fa-save" <%=CommonUtils.getDisplayRoleButton(roleList,"COMM_SAVE")%>></i> 자료이관
						</button>
					</td>
				</tr>
				<tr><td height="1" colspan="2"></td></tr>
				<tr>
					<td valign="top" colspan="2">
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
	fnSummary();
	
	$('#srcButton').click(function (e) {
		fnSearch();
	});
	
	$('#transButton').click(function (e) {
		fnQualityTransfer();
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
		fieldSearchParamArray[9] = 'srcIsUse';
		var excelFileName = "evaluateManageList";  //file명

		fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/evaluation/selectItemList/excel.sys");
	});
	
	$('#frmSearch').search();
	
	// subGrid 처리
	$('#openButton').click(function (e) {
		var rowCnt = jq("#list").getGridParam('reccount');
		for(var i = 0; i < rowCnt; i++){
            var rowid = $("#list").getDataIDs()[i];
            $("#list").expandSubGridRow(rowid);
            fnSummary();
		}
	});
	$('#closeButton').click(function (e) {
		var rowCnt = jq("#list").getGridParam('reccount');
		for(var i = 0; i < rowCnt; i++){
            var rowid = $("#list").getDataIDs()[i];
           	$("#list").toggleSubGridRow(rowid);
		}
	});
	
	// 공급사 Final 화면 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#qualityChk').jqm();	//Dialog 초기화
	$('#qualityChk').jqm().jqDrag('#processDialogHandle'); 
	$('#btnFinalAttach1').click(function (e) { fnLftdDivFileUpload($("#quality_file_seq1").val(), "quality_file_seq1"); });
	$('#btnFinalAttach2').click(function (e) { fnLftdDivFileUpload($("#quality_file_seq2").val(), "quality_file_seq2"); });
	$("#qualityCheck_CloseButton, .jqmClose").click(function(){	$("#qualityChk").jqmHide(); });//Dialog 닫기
	$('#qualityCheck_Temp_SaveButton').click(function (e) { fnSaveQualityChkInfo('T'); });
	$('#qualityCheck_SaveButton').click(function (e) { fnSaveQualityChkInfo('S'); });
    $("#qualityChk_1stUserBtn").click(function(){ 
        var userNm 		= $("#1stApprUserNm").val();
        var svcTypeCd 	= "ADM";
        fnJqmUserInitSearch(userNm, "", svcTypeCd, "fnSelectUserCallback");
    });
    $("#qualityChk_2ndUserBtn").click(function(){
        var userNm 		= $("#2ndApprUserNm").val();
        var svcTypeCd 	= "ADM";
        fnJqmUserInitSearch(userNm, "", svcTypeCd, "fnSelectUserCallback2");
    });
    $("#qualityChk_1stUserDeleteBtn").click(function(){
		$("#1stApprUserNm").val("");
		$("#1stApprUserId").val("");
    });
    $("#qualityChk_2ndUserDeleteBtn").click(function(){
		$("#2ndApprUserNm").val("");
		$("#2ndApprUserId").val("");
    });
	$("#1stApprUserNm").keydown(function(e){ if(e.keyCode==13) { $("#qualityChk_1stUserBtn").click(); } });
	$("#1stApprUserNm").change(function(e){ if($("#1stApprUserNm").val()=="") { $("#1stApprUserNm").val(""); } });
	$("#2ndApprUserNm").keydown(function(e){ if(e.keyCode==13) { $("#qualityChk_2ndUserBtn").click(); } });
	$("#2ndApprUserNm").change(function(e){ if($("#1stApprUserNm").val()=="") { $("#1stApprUserNm").val(""); } });
	

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
		rowNum:30, rownumbers: true, rowList:[10,20,30,50,100,500,1000], pager: '#processFileDivPager',
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
	
	
	//voc 등록 초기화
	$('#vocRegDiv').jqm();	//Dialog 초기화
	$("#vocRegCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#vocRegDiv").jqmHide();
		fnBondsCallback = "";
	});
	$('#vocRegDiv').jqm().jqDrag('#vocRegDialogHandle');	
	
	//voc 처리 초기화
	$('#vocProc').jqm();	//Dialog 초기화
	$("#vocProcCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#vocProc").jqmHide();
	});
	$('#vocProc').jqm().jqDrag('#vocProcDialogHandle');	
	
	//voc 리스트 초기화
	$('#vocListDiv').jqm();	//Dialog 초기화
	$("#vocListCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#vocListDiv").jqmHide();
		fnBondsCallback = "";
	});
	$('#vocListDiv').jqm().jqDrag('#vocListDialogHandle');	
	$('#srcVocButton').click(function (e) {
		fnSrcVocList();
	});
	
	
	
    $("#voc_1stUserBtn").click(function(){ 
        var userNm 		= $("#1stVocUserNm").val();
        var svcTypeCd 	= "ADM";
        fnJqmUserInitSearch(userNm, "", svcTypeCd, "fnSelectUserCallback3");
    });
    $("#voc_2ndUserBtn").click(function(){
        var userNm 		= $("#2ndVocUserNm").val();
        var svcTypeCd 	= "ADM";
        fnJqmUserInitSearch(userNm, "", svcTypeCd, "fnSelectUserCallback4");
    });
    $("#voc_1stUserDeleteBtn").click(function(){
		$("#1stVocUserNm").val("");
		$("#1stVocUserId").val("");
    });
    $("#voc_2ndUserDeleteBtn").click(function(){
		$("#2ndVocUserNm").val("");
		$("#2ndVocUserId").val("");
    });
	$("#1stVocUserNm").keydown(function(e){ if(e.keyCode==13) { $("#voc_1stUserBtn").click(); } });
	$("#1stVocUserNm").change(function(e){ if($("#1stVocUserNm").val()=="") { $("#1stVocUserNm").val(""); } });
	$("#2ndVocUserNm").keydown(function(e){ if(e.keyCode==13) { $("#voc_2ndUserBtn").click(); } });
	$("#2ndVocUserNm").change(function(e){ if($("#1stVocUserNm").val()=="") { $("#1stVocUserNm").val(""); } });	
	
	
	$("#vocListGrid").jqGrid({
		datatype: 'json', 
		mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
		colNames:[ '소싱명','규격','업체명','상태','요청자(요청일)','접수자(접수일)','처리자(처리일)','판정결과' ,'VOCID' ,'QUALITYID' ,'QUALITYYYYY' ,'SOURCINGID' ,'BUSINESSNUM' ],
		colModel:[
			{name:'SOURCINGNM'		,index:'SOURCINGNM'		, width:130,align:"left",sortable:false,editable:false},
			{name:'SPEC'			,index:'SPEC'			, width:140,align:"left",search:false,sortable:false,editable:false},
			{name:'BUSSINESSNM'		,index:'BUSSINESSNM'	, width:120,align:"left",search:false,sortable:false,editable:false},
			{name:'TREATRESULT_NM'	,index:'TREATRESULT_NM'	, width:60,align:"center",search:false,sortable:false,editable:false},
			{name:'REQ_INFO'		,index:'REQ_INFO'		, width:130,align:"center",search:false,sortable:false,editable:false},
			{name:'RECIPT_INFO'		,index:'RECIPT_INFO'	, width:130,align:"center",search:false,sortable:false,editable:false},
			{name:'MEASURE_INFO'	,index:'MEASURE_INFO'	, width:130,align:"center",search:false,sortable:false,editable:false},
			{name:'JUDGMENTRESULT_NM',index:'JUDGMENTRESULT_NM', width:100,align:"center",search:false,sortable:false,editable:false},
			{name:'VOCID'			,index:'VOCID'			, width:140,align:"center",search:false,sortable:false,editable:false,hidden:true},
			{name:'QUALITYID'		,index:'QUALITYID'		, width:140,align:"center",search:false,sortable:false,editable:false,hidden:true},
			{name:'QUALITYYYYY'		,index:'QUALITYYYYY'	, width:140,align:"center",search:false,sortable:false,editable:false,hidden:true},
			{name:'SOURCINGID'		,index:'SOURCINGID'		, width:140,align:"center",search:false,sortable:false,editable:false,hidden:true},
			{name:'BUSINESSNUM'		,index:'BUSINESSNUM'	, width:140,align:"center",search:false,sortable:false,editable:false,hidden:true}
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[10,20,30,50,100,500,1000], pager: '#vocListDivPager',
		height:250, width:980, 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {  },
		afterInsertRow: function(rowid, aData){
			var selrowContent = $("#vocListGrid").jqGrid('getRowData',rowid);
        	var pText = "<a href='#' onclick=\"javascript:fnVocProcDetail('"+selrowContent.VOCID+"');\"><font color='blue'>"+selrowContent.TREATRESULT_NM+"</font></a>";
        	$(this).setCell(rowid, 'TREATRESULT_NM', pText);
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#vocListGrid").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});		
	
	
	// 공급사 상태변경 레이어 팝업 초기화
	$('#venregSaveButton').click(function (e) { fnSaveVenStatus(); });
	$('#venRegDiv').jqm();	//Dialog 초기화
	$("#venregCloseButton, .jqmClose").click(function(){	$("#venRegDiv").jqmHide(); });//Dialog 닫기
	$('#venRegDiv').jqm().jqDrag('#processDialogHandle'); 
});
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
             }
         }
     );  
     
     
     
     // 품질 Voc 조치에 필요한 코드값 : 판정결과
	 $.post(  
	     '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
	     {
	         codeTypeCd:"SMPVOC_DECISION",
	         isUse:"1"
	     },
	     function(arg){
	         var codeList = eval('(' + arg + ')').codeList;
	         for(var i=0;i<codeList.length;i++) {
	             $("#vocProc_judgmentresult").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
	         }
	     }
	 );  
     // 품질 Voc 조치에 필요한 코드값 : 조치결과
     $.post(  
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPVOC_MEASURE",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#vocProc_measureresult").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
             }
         }
     );  
}
//날짜 조회 및 스타일
$(function(){
	$("#reqDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

var subGrid = null;
//그리드 초기화
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/qualityManageList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['소싱명','규격','품목유형1','품목유형2','품질기준','규격서','절차서','담당자','업체수','사용여부', 'SOURCINGID' ,'SPEC_FILE_SEQ' ,'SPEC_FILE_NAME' ,'SPEC_FILE_PATH' ,'PROC_FILE_SEQ' ,'PROC_FILE_NAME' ,'PROC_FILE_PATH','QUALITYID','QUALITYSTDCD','QUALITYYYYY','MANAGERID' ],
        colModel:[
            {name:'SOURCINGNM'		,width:180	},//소싱명
            {name:'SPEC'			,width:200},//규격
            {name:'PRODTYPE1'		,width:70	,align:"center"},//품목유형1
            {name:'PRODTYPE2'		,width:70	,align:"center"},//품목유형2
            {name:'QUALITYSTD'		,width:110	,align:"center", formatter:fnQualityStd},//품질기준
            {name:'STANDARDFILE'	,width:180	,align:"left"},//규격서
            {name:'PROCESSFILE'		,width:180	,align:"left"},//절차서
            {name:'MANAGERNM'		,width:100	,align:"center", formatter:fnAdminUsers},//담당자
            {name:'VENDORCNT'		,width:80	,align:"right"},//업체수
            {name:'ISUSE'			,width:80	,align:"right"},//사용여부
            {name:'SOURCINGID'		,width:80,hidden:true},//key
            {name:'SPEC_FILE_SEQ'	,width:80,hidden:true},
            {name:'SPEC_FILE_NAME'	,width:80,hidden:true},
            {name:'SPEC_FILE_PATH'	,width:80,hidden:true},
            {name:'PROC_FILE_SEQ'	,width:80,hidden:true},
            {name:'PROC_FILE_NAME'	,width:80,hidden:true},
            {name:'PROC_FILE_PATH'	,width:80,hidden:true},
            {name:'QUALITYID'		,width:80,hidden:true,key:true},
            {name:'QUALITYSTDCD'	,width:80,hidden:true},
            {name:'QUALITYYYYY'		,width:80,hidden:true},
            {name:'MANAGERID'		,width:80,hidden:true},//담당자
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30,rownumbers:true,  rowList:[30,50,100,200], pager: '#pager',
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
            $("#qualityStd_" + rowid).val(selrowContent.QUALITYSTDCD);
            $("#admUser_" + rowid).val(selrowContent.MANAGERID);
            
            var isUse = fnGetString(selrowContent.ISUSE, 'Y');
            
            if(isUse == 'Y'){
            	$(this).setCell(rowid,'ISUSE', "사용 <button type='button' onclick=\"javascript:fnSetQualityIsUse('"+rowid+"','N');\" class='btn btn-warning btn-xs'>종료</button>");
            }else{
            	$(this).setCell(rowid,'ISUSE', "종료 <button type='button' onclick=\"javascript:fnSetQualityIsUse('"+rowid+"','Y');\" class='btn btn-primary btn-xs'>사용</button>");
            }
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) { },
        subGrid:true,
        subGridUrl: '<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/selectPartApplList/list.sys',
        subGridRowExpanded: function (grid_id, rowid) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
        	var qualityStdCd= selrowContent.QUALITYSTDCD;
        	var sourcingId  = selrowContent.SOURCINGID;
        	var qualityId  	= selrowContent.QUALITYID;
        	var sourcingNm	= selrowContent.SOURCINGNM;
        	var spec		= selrowContent.SPEC;
        	
            var subgridTableId = grid_id + "_t";
            $("#" + grid_id).html("<table id='" + subgridTableId + "'></table>");
            $("#" + subgridTableId).jqGrid({
                url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/qualityVendorList/list.sys',
                datatype: 'json',
                mtype: 'POST',
                postData: {itemId:rowid},
                colNames:['업체명','상태','VOC','1분기','2분기','3분기','4분기','전반기','후반기','1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월', '상태' 
                          ,'QUALITYID' ,'QUALITYYYYY' ,'SOURCINGID' ,'BUSINESSNUM','VENDORSTATUS_CODE' ,'QUARTER1_KIND' ,'QUARTER2_KIND' ,'QUARTER3_KIND' ,'QUARTER4_KIND' ,'FIRSTHALF_KIND' ,'SECONDHALF_KIND',
                          'M1_KIND','M2_KIND','M3_KIND','M4_KIND','M5_KIND','M6_KIND','M7_KIND','M8_KIND','M9_KIND','M10_KIND','M11_KIND','M12_KIND'],
                colModel:[
                    {name:'VENDORNM'			,width:120},				//업체명
                    {name:'VENDORSTATUS'		,width:80,align:'center'},	//상태
                    {name:'VOC'					,width:100,align:'right'},	//VOC
                    {name:'QUARTER1'			,width:100,align:'center'},	//1분기
                    {name:'QUARTER2'			,width:100,align:'center'},	//2분기
                    {name:'QUARTER3'			,width:100,align:'center'},	//3분기
                    {name:'QUARTER4'			,width:100,align:'center'},	//4분기
                    {name:'FIRSTHALF'			,width:100,align:'center'},	//전반기
                    {name:'SECONDHALF'			,width:100,align:'center'},	//후반기
                    {name:'M1'					,width:80,align:'center'},	//1월
                    {name:'M2'					,width:80,align:'center'},	//2월
                    {name:'M3'					,width:80,align:'center'},	//3월
                    {name:'M4'					,width:80,align:'center'},	//4월
                    {name:'M5'					,width:80,align:'center'},	//5월
                    {name:'M6'					,width:80,align:'center'},	//6월
                    {name:'M7'					,width:80,align:'center'},	//7월
                    {name:'M8'					,width:80,align:'center'},	//8월
                    {name:'M9'					,width:80,align:'center'},	//9월
                    {name:'M10'					,width:80,align:'center'},	//10월
                    {name:'M11'					,width:80,align:'center'},	//11월
                    {name:'M12'					,width:80,align:'center'},	//12월
                    {name:'QUALITYSTATUS'		,width:100,align:'right', hidden:true},	//상태
                    {name:'QUALITYID'			,width:100,align:'right', hidden:true},	//QUALITYID
                    {name:'QUALITYYYYY'			,width:100,align:'right', hidden:true},	//QUALITYYYYY
                    {name:'SOURCINGID'			,width:100,align:'right', hidden:true},	//SOURCINGID
                    {name:'BUSINESSNUM'			,width:100,align:'right', hidden:true},	//BUSINESSNUM
                    {name:'VENDORSTATUS_CODE'	,width:100,align:'right', hidden:true},	//VENDORSTATUS_CODE
                    {name:'QUARTER1_KIND'		,width:100,align:'right', hidden:true},	//QUARTER1_KIND
                    {name:'QUARTER2_KIND'		,width:100,align:'right', hidden:true},	//QUARTER2_KIND
                    {name:'QUARTER3_KIND'		,width:100,align:'right', hidden:true},	//QUARTER3_KIND
                    {name:'QUARTER4_KIND'		,width:100,align:'right', hidden:true},	//QUARTER4_KIND
                    {name:'FIRSTHALF_KIND'		,width:100,align:'right', hidden:true},	//FIRSTHALF_KIND
                    {name:'SECONDHALF_KIND'		,width:100,align:'right', hidden:true},	//SECONDHALF_KIND
                    {name:'M1_KIND'				,width:100,align:'right', hidden:true},	//M1_KIND
                    {name:'M2_KIND'				,width:100,align:'right', hidden:true},	//M2_KIND
                    {name:'M3_KIND'				,width:100,align:'right', hidden:true},	//M3_KIND
                    {name:'M4_KIND'				,width:100,align:'right', hidden:true},	//M4_KIND
                    {name:'M5_KIND'				,width:100,align:'right', hidden:true},	//M5_KIND
                    {name:'M6_KIND'				,width:100,align:'right', hidden:true},	//M6_KIND
                    {name:'M7_KIND'				,width:100,align:'right', hidden:true},	//M7_KIND
                    {name:'M8_KIND'				,width:100,align:'right', hidden:true},	//M8_KIND
                    {name:'M9_KIND'				,width:100,align:'right', hidden:true},	//M9_KIND
                    {name:'M10_KIND'			,width:100,align:'right', hidden:true},	//M10_KIND
                    {name:'M11_KIND'			,width:100,align:'right', hidden:true},	//M11_KIND
                    {name:'M12_KIND'			,width:100,align:'right', hidden:true},	//M12_KIND
                ],
				postData: {
                    qualityId:qualityId,
                    qualityYyyy:$("#stdQualityYear").val(),
                    sourcingId:sourcingId,
                },
                jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
                height:'100%',
                afterInsertRow: function(rowid, aData) {
                	var selrowContent 	=	$("#" + subgridTableId).jqGrid('getRowData',rowid);
                	
                	var subGridQualityid	=	selrowContent.QUALITYID;
                	var subGridQualityyyyy	=	selrowContent.QUALITYYYYY;
                	var subGridSourcingid	=	selrowContent.SOURCINGID;
                	var subGridBusinessnum	=	selrowContent.BUSINESSNUM;
                	var subGridVendornm	=	selrowContent.VENDORNM;
                	var vendorPopText	=	"<a href='#' onclick=\"javascript:fnVendorStatPop('"+subGridQualityid+"','"+subGridQualityyyyy+"','"+subGridSourcingid+"','"+subGridBusinessnum+"');\"><font color='#0000ff'> "+ subGridVendornm+"</font></a>";
                	$(this).setCell(rowid,'VENDORNM', vendorPopText);
                	$(this).setCell(rowid,'VENDORNM',"",{color:'#0000ff',cursor: 'pointer','text-decoration':'underline'});
                	
                	var cntTxt = "<a href='#' onclick=\"javascript:fnVocList('"+sourcingNm+"','"+spec+"','"+selrowContent.VENDORNM+"');\"><font color='#0000ff'> "+ selrowContent.VOC+" 건 </font></a>";
                	$(this).setCell(rowid,'VOC', cntTxt +"  <button type='button' onclick=\"javascript:fnVocPop('"+qualityId+"','"+$("#stdQualityYear").val()+"','"+sourcingId+"','"+selrowContent.BUSINESSNUM+"');\" class='btn btn-primary btn-xs'>등록</button>");
                	$(this).setCell(rowid,'VOC',"",{color:'#0000ff',cursor: 'pointer'});
                	
                	var subGridVEndCode	= selrowContent.VENDORSTATUS_CODE;
                	var colorTempText	= "";
                	if(subGridVEndCode == "10"){
                		colorTempText = "green";
                	}else if(subGridVEndCode == "20"){
                		colorTempText = "#aaaaaa";
                	}else if(subGridVEndCode == "90"){
                		colorTempText = "red";
                	}
                	$(this).setCell(rowid,'VENDORSTATUS',"",{color:colorTempText});
                    
                    fnSetQuarterText($(this), selrowContent, rowid, "QUARTER1"	, 	'1'	,selrowContent.QUARTER1_KIND, 	selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "QUARTER2"	, 	'2'	,selrowContent.QUARTER2_KIND, 	selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "QUARTER3"	, 	'3'	,selrowContent.QUARTER3_KIND, 	selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "QUARTER4"	, 	'4'	,selrowContent.QUARTER4_KIND, 	selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "FIRSTHALF"	,	'F'	,selrowContent.FIRSTHALF_KIND, 	selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "SECONDHALF", 	'S'	,selrowContent.SECONDHALF_KIND, selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M1", 			'M1',selrowContent.M1_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M2", 			'M2',selrowContent.M2_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M3", 			'M3',selrowContent.M3_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M4", 			'M4',selrowContent.M4_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M5", 			'M5',selrowContent.M5_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M6", 			'M6',selrowContent.M6_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M7", 			'M7',selrowContent.M7_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M8", 			'M8',selrowContent.M8_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M9", 			'M9',selrowContent.M9_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M10", 			'M10',selrowContent.M10_KIND, 		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M11", 			'M11',selrowContent.M11_KIND,		selrowContent.VENDORSTATUS_CODE);
                    fnSetQuarterText($(this), selrowContent, rowid, "M12", 			'M12',selrowContent.M12_KIND, 		selrowContent.VENDORSTATUS_CODE);
                },
                loadComplete: function() {
                	if(qualityStdCd == '0'){
	                  	$('#'+subgridTableId).hideCol('QUARTER1');
	                  	$('#'+subgridTableId).hideCol('QUARTER2');
	                  	$('#'+subgridTableId).hideCol('QUARTER3');
	                  	$('#'+subgridTableId).hideCol('QUARTER4');
	                  	$('#'+subgridTableId).hideCol('FIRSTHALF');
	                  	$('#'+subgridTableId).hideCol('SECONDHALF');
	                  	$('#'+subgridTableId).showCol('M1');
	                  	$('#'+subgridTableId).showCol('M2');
	                  	$('#'+subgridTableId).showCol('M3');
	                  	$('#'+subgridTableId).showCol('M4');
	                  	$('#'+subgridTableId).showCol('M5');
	                  	$('#'+subgridTableId).showCol('M6');
	                  	$('#'+subgridTableId).showCol('M7');
	                  	$('#'+subgridTableId).showCol('M8');
	                  	$('#'+subgridTableId).showCol('M9');
	                  	$('#'+subgridTableId).showCol('M10');
	                  	$('#'+subgridTableId).showCol('M11');
	                  	$('#'+subgridTableId).showCol('M12');                		
                	}else if(qualityStdCd == '10'){
	                  	$('#'+subgridTableId).showCol('QUARTER1');
	                  	$('#'+subgridTableId).showCol('QUARTER2');
	                  	$('#'+subgridTableId).showCol('QUARTER3');
	                  	$('#'+subgridTableId).showCol('QUARTER4');
	                  	$('#'+subgridTableId).hideCol('FIRSTHALF');
	                  	$('#'+subgridTableId).hideCol('SECONDHALF');
	                  	$('#'+subgridTableId).hideCol('M1');
	                  	$('#'+subgridTableId).hideCol('M2');
	                  	$('#'+subgridTableId).hideCol('M3');
	                  	$('#'+subgridTableId).hideCol('M4');
	                  	$('#'+subgridTableId).hideCol('M5');
	                  	$('#'+subgridTableId).hideCol('M6');
	                  	$('#'+subgridTableId).hideCol('M7');
	                  	$('#'+subgridTableId).hideCol('M8');
	                  	$('#'+subgridTableId).hideCol('M9');
	                  	$('#'+subgridTableId).hideCol('M10');
	                  	$('#'+subgridTableId).hideCol('M11');
	                  	$('#'+subgridTableId).hideCol('M12');
              		}else if(qualityStdCd == '20'){
	                  	$('#'+subgridTableId).hideCol('QUARTER1');
	                  	$('#'+subgridTableId).hideCol('QUARTER2');
	                  	$('#'+subgridTableId).hideCol('QUARTER3');
	                  	$('#'+subgridTableId).hideCol('QUARTER4');
	                  	$('#'+subgridTableId).showCol('FIRSTHALF');
	                  	$('#'+subgridTableId).showCol('SECONDHALF');
	                  	$('#'+subgridTableId).hideCol('M1');
	                  	$('#'+subgridTableId).hideCol('M2');
	                  	$('#'+subgridTableId).hideCol('M3');
	                  	$('#'+subgridTableId).hideCol('M4');
	                  	$('#'+subgridTableId).hideCol('M5');
	                  	$('#'+subgridTableId).hideCol('M6');
	                  	$('#'+subgridTableId).hideCol('M7');
	                  	$('#'+subgridTableId).hideCol('M8');
	                  	$('#'+subgridTableId).hideCol('M9');
	                  	$('#'+subgridTableId).hideCol('M10');
	                  	$('#'+subgridTableId).hideCol('M11');
	                  	$('#'+subgridTableId).hideCol('M12');	                  	
              		}else if(qualityStdCd == '30'){
	                  	$('#'+subgridTableId).hideCol('QUARTER1');
	                  	$('#'+subgridTableId).hideCol('QUARTER2');
	                  	$('#'+subgridTableId).hideCol('QUARTER3');
	                  	$('#'+subgridTableId).hideCol('QUARTER4');
	                  	$('#'+subgridTableId).hideCol('FIRSTHALF');
	                  	$('#'+subgridTableId).hideCol('SECONDHALF');
	                  	$('#'+subgridTableId).hideCol('M1');
	                  	$('#'+subgridTableId).hideCol('M2');
	                  	$('#'+subgridTableId).hideCol('M3');
	                  	$('#'+subgridTableId).hideCol('M4');
	                  	$('#'+subgridTableId).hideCol('M5');
	                  	$('#'+subgridTableId).hideCol('M6');
	                  	$('#'+subgridTableId).hideCol('M7');
	                  	$('#'+subgridTableId).hideCol('M8');
	                  	$('#'+subgridTableId).hideCol('M9');
	                  	$('#'+subgridTableId).hideCol('M10');
	                  	$('#'+subgridTableId).hideCol('M11');
	                  	$('#'+subgridTableId).hideCol('M12');
              		}                	
                },
                
                onCellSelect: function(rowid, iCol, cellcontent, target) {}
            });
            if(qualityStdCd == '0'){
               	$("#" + subgridTableId).jqGrid('setGroupHeaders', {
            		useColSpanStyle: true,
            		groupHeaders:[{startColumnName: 'M1', numberOfColumns: 12, titleText: '품질검사'}]
            	});            	
            }
            else if(qualityStdCd == '10'){
               	$("#" + subgridTableId).jqGrid('setGroupHeaders', {
            		useColSpanStyle: true,
            		groupHeaders:[{startColumnName: 'QUARTER1', numberOfColumns: 4, titleText: '품질검사'}]
            	});
      		}else if(qualityStdCd == '20'){
              	$("#" + subgridTableId).jqGrid('setGroupHeaders', {
            		useColSpanStyle: true,
            		groupHeaders:[{startColumnName: 'FIRSTHALF', numberOfColumns: 2, titleText: '품질검사'}]
            	});
      		}
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

function fnQualityStd(cellValue, options, rowObject){
	var rtnStr = "";
	rtnStr = "<select id='qualityStd_"+options.rowId+"' name='qualityStd_"+options.rowId+"' class='select' style='width:80px;' \">";
	<%
	if(qualityStdList != null && qualityStdList.size() > 0){
		for(CodesDto dto : qualityStdList){
	%>
			rtnStr += "<option value='<%=dto.getCodeVal1()%>'><%=dto.getCodeNm1()%></option>";
	<%				
		}
	}
	%>
	rtnStr += "</select>";
	rtnStr += " <button type='button' onclick=\"javascript:fnSetQualityStd('"+options.rowId+"');\" class='btn btn-warning btn-xs'><i class='fa fa-save'></i></button>";
	return rtnStr;
}

function fnAdminUsers(cellValue, options, rowObject){
	var rtnStr = "";
	rtnStr = "<select id='admUser_"+options.rowId+"' name='admUser_"+options.rowId+"' class='select' style='width:70px;' \">";
	<%
	if(qualityStdList != null && qualityStdList.size() > 0){
		for(UserDto dto : adminUserList){
	%>
			rtnStr += "<option value='<%=dto.getUserId()%>'><%=dto.getUserNm()%></option>";
	<%				
		}
	}
	%>
	rtnStr += "</select>";
	rtnStr += " <button type='button' onclick=\"javascript:fnSetManager('"+options.rowId+"');\" class='btn btn-warning btn-xs'><i class='fa fa-save'></i></button>";
	return rtnStr;
}

function fnSetQualityStd(rowid){
	var selrowContent =	$("#list").jqGrid('getRowData',rowid);
	
	var qualityId 	= selrowContent.QUALITYID;
	var qualityYYYY = selrowContent.QUALITYYYYY;
	var sourcingId	= selrowContent.SOURCINGID;
	var qualityStdCd= $("#qualityStd_"+rowid).val();
	
	if(!confirm("품질기준이 변경되면 기존에 등록 되어진\n품질검사 내역이 모두 삭제됩니다.\n\n 품질기준을 변경하시겠습니까?"))return;
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/setQualityStd.sys",
		{
			qualityId:qualityId,
			qualityYYYY:qualityYYYY,
			sourcingId:sourcingId,
			qualityStdCd:qualityStdCd
			
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
 				fnSearch();
			}
		}
	);	
}

function fnSetManager(rowid){
	var selrowContent =	$("#list").jqGrid('getRowData',rowid);
	
	var qualityId 	= selrowContent.QUALITYID;
	var qualityYYYY = selrowContent.QUALITYYYYY;
	var sourcingId	= selrowContent.SOURCINGID;
	var managerId   = $("#admUser_"+rowid).val();
	
	if(!confirm("담당자를 변경하시겠습니까?"))return;
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/setManager.sys",
		{
			qualityId:qualityId,
			qualityYYYY:qualityYYYY,
			sourcingId:sourcingId,
			managerId:managerId
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
				fnSearch();
			}
		}
	);	
}

function fnSetQualityIsUse(rowid, isUse){
	var selrowContent =	$("#list").jqGrid('getRowData',rowid);
	
	var qualityId 	= selrowContent.QUALITYID;
	var qualityYYYY = selrowContent.QUALITYYYYY;
	var sourcingId	= selrowContent.SOURCINGID;
	
	var confirmStr = "";
	
	if('Y' == isUse)confirmStr = "해당 품목정보의 사용여부를 [사용]으로 변경하시겠습니까?"; 
	else  			confirmStr = "해당 품목정보의 사용여부를 [종료]로 변경하시겠습니까?"; 
	
	if(!confirm(confirmStr))return;
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/setQualityIsUse.sys",
		{
			qualityId:qualityId,
			qualityYYYY:qualityYYYY,
			sourcingId:sourcingId,
			isUse:isUse
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
				fnSearch();
			}
		}
	);	
}

function fnQualityTransfer(){
	if(!confirm("이관 하시겠습니까?"))return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/saveTransQualityData.sys",
		{},
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
				fnSearch();
			}
		}
	);	
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
    fnSummary();
}

function fnSummary(){
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/getQualitySummary/qualitySummary/object.sys',
		{
			qualityYYYY:$("#stdQualityYear").val()
		},
		function(arg){
			var qualitySummary = eval('(' + arg + ')').qualitySummary;
			var qualityCnt 	= qualitySummary == null ? '0' : qualitySummary.QUALITYCNT;	 
			var checkCnt 	= qualitySummary == null ? '0' : qualitySummary.CHECKCNT;
			var qualityRate = qualitySummary == null ? '0' : qualitySummary.QUALITYRATE;
			var vocCnt 		= qualitySummary == null ? '0' : qualitySummary.VOCCNT;
			var compCnt 	= qualitySummary == null ? '0' : qualitySummary.COMPCNT;
			var vocRate 	= qualitySummary == null ? '0' : qualitySummary.VOCRATE;
			
			$("#qualitySummarySpan").html("※ <b>품질검사(실적/대상) : "+checkCnt+"/"+qualityCnt+" ("+qualityRate+"%), VOC(완료/등록) :  "+compCnt+"/"+vocCnt+" ("+vocRate+"%)</b>");
		}
	);	
	
}

// 파일다운로드
function fnAttachFileDownload(attach_file_path) {
    var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
    var data = "attachFilePath="+attach_file_path;
    $.download(url,data,'post');
}
jQuery.download = function(url, data, method) {
    // url과 data를 입력받음
    if( url && data ) {
        // data 는 string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의 input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function() {
            var pair = new Array();
            pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />';
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
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

function vocFileAttach1(){
	fnUploadDialog("첨부파일1", $("#vocAttachSeq1").val() ,"fnCallBackVocFile1" ,"9", "");
}

function fnCallBackVocFile1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path, seq) {
	$("#vocAttachSeq1").val(rtn_attach_seq);
	if(rtn_attach_file_name.length > 10){
		rtn_attach_file_name = rtn_attach_file_name.substring(0,10) +"...";
	}
	$("#vocAttachSpan1").html("<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>");
}

function vocFileAttach2(){
	fnUploadDialog("첨부파일2", $("#vocAttachSeq2").val() ,"fnCallBackVocFile2" ,"9", "");
}

function fnCallBackVocFile2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path, seq) {
	$("#vocAttachSeq2").val(rtn_attach_seq);
	if(rtn_attach_file_name.length > 10){
		rtn_attach_file_name = rtn_attach_file_name.substring(0,10) +"...";
	}
	$("#vocAttachSpan2").html("<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>");
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
function fnVocPop(qualityId, qualityYyyy, sourcingId, businessNum){
	var tmp = "";
	tmp += qualityId + "\n";
	tmp += qualityYyyy + "\n";
	tmp += sourcingId + "\n";
	tmp += businessNum + "\n";
// 	alert(tmp);
	 $.post(
	     '<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/qualityVendorDetail/vocDetail/object.sys',
	     {
	    	 qualityId:qualityId,
	    	 qualityYyyy:qualityYyyy,
	    	 sourcingId:sourcingId,
	    	 businessNum:businessNum
	     },
	     function(arg){
	         var vocDetail = eval('(' + arg + ')').vocDetail;
	         $("#vocSourcingNm").html(vocDetail.SOURCINGNM);
	         $("#vocSpec").html(vocDetail.SPEC);
	         $("#vocProdType").html(vocDetail.PRODTYPE);
	         $("#vocQualityStd").html(vocDetail.QUALITYSTD);
	         $("#vocVendorNm").html(vocDetail.BUSSINESSNM);
	         $("#vocSpecFileName").html("<a href=\"javascript:fnAttachFileDownload('"+vocDetail.SPEC_FILE_PATH+"')\"><font color='#0000ff'>"+vocDetail.SPEC_FILE_NAME+"</font></a>");
	         $("#vocProcFileName").html("<a href=\"javascript:fnAttachFileDownload('"+vocDetail.PROC_FILE_PATH+"')\"><font color='#0000ff'>"+vocDetail.PROC_FILE_NAME+"</font></a>");

	         $("#vocQualityId").val(qualityId);
	         $("#vocQualityYYYY").val(qualityYyyy);
	         $("#vocSourcingId").val(sourcingId);
	         $("#vocBusinessNum").val(businessNum);
	         
	         $("#reqClientNm").val("");
	         $("#reqClientId").val("");
	         $("#reqUserNm").val("");
	         $("#reqDate").val("<%=currDate%>");
	         $("#reqTel").val("");
	         $("#vocAttachSeq1").val("");
	         $("#vocAttachSpan1").html("");
	         $("#vocAttachSeq2").val("");
	         $("#vocAttachSpan2").html("");
	         $("#reqDesc").val("");
	         
	         $("#vocRegDiv").jqmShow();         
	     }
	 );  	
}

function fnVocReg(){
	var qualityId   = $("#vocQualityId").val();
	var qualityYYYY = $("#vocQualityYYYY").val();
	var sourcingId  = $("#vocSourcingId").val();
	var businessNum = $("#vocBusinessNum").val();
    var reqBorgId   = $("#reqClientId").val();
    var reqUserNm   = $("#reqUserNm").val();
    var reqDate     = $("#reqDate").val();
    var reqTel 	  	= $("#reqTel").val();
    var reqFile1  	= $("#vocAttachSeq1").val();
    var reqFile2 	= $("#vocAttachSeq2").val();
    var reqDesc   	= $("#reqDesc").val();
	
    if(!confirm("작성하신 내용을 접수 하시겠습니까?"))return;
    
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/vocRegist.sys",
		{
				qualityId:qualityId
			,	qualityYYYY:qualityYYYY
			,	sourcingId:sourcingId
			,	businessNum:businessNum
			,	reqBorgId:reqBorgId
			,	reqUserNm:reqUserNm
			,	reqDate:reqDate
			,	reqTel:reqTel
			,	reqFile1:reqFile1
			,	reqFile2:reqFile2
			,	reqDesc:reqDesc   	
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
		        $("#vocQualityId").val("");
		        $("#vocQualityYYYY").val("");
		        $("#vocSourcingId").val("");
		        $("#vocBusinessNum").val("");
		        $("#reqClientNm").val("");
		        $("#reqClientId").val("");
		        $("#reqUserNm").val("");
		        $("#reqDate").val("<%=currDate%>");
		        $("#reqTel").val("");
		        $("#vocAttachSeq1").val("");
		        $("#vocAttachSpan1").html("");
		        $("#vocAttachSeq2").val("");
		        $("#vocAttachSpan2").html("");
		        $("#reqDesc").val("");
		        $("#vocRegDiv").jqmHide();
            	$("#list").toggleSubGridRow(qualityId);
            	$("#list").expandSubGridRow(qualityId);
            	fnSummary();
			}
		}
	);    
}

function fnVocList(sourcingNm, spec, vendorNm){
<%-- 	$("#vocListGrid").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/vocList/list.sys'}); --%>
	$("#vocListGrid").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/selectVocList/list.sys'});
   	var data = jq("#vocListGrid").jqGrid("getGridParam", "postData");
   	data.vocYear 		= $("#vocYear").val();
   	data.vocSourcingNm 	= sourcingNm;
   	data.vocSpec 		= spec;
   	data.vocVendorNm 	= vendorNm;
  	jq("#vocListGrid").jqGrid("setGridParam", { "postData": data });
  	jq("#vocListGrid").trigger("reloadGrid");
  	
  	$("#vocListSourcingNm").val(sourcingNm);
  	$("#vocListSpec").val(spec);
  	$("#vocListVendorNm").val(vendorNm);  	
  	
	$("#vocListDiv").jqmShow();
}

function fnSrcVocList(){
	$("#vocListGrid").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/selectVocList/list.sys'});
   	var data = jq("#vocListGrid").jqGrid("getGridParam", "postData");
   	data.vocYear 		= $("#vocYear").val();
   	data.vocSourcingNm 	= $("#vocListSourcingNm").val();
   	data.vocSpec 		= $("#vocListSpec").val();
   	data.vocVendorNm 	= $("#vocListVendorNm").val();
   	data.vocStatus 	= $("#vocStatus").val();
  	jq("#vocListGrid").jqGrid("setGridParam", { "postData": data });
  	jq("#vocListGrid").trigger("reloadGrid");
}



function fnVendorStatPop(qualityid, qualityyyyy, sourcingid, businessnum){
	$.post(
        "/quality/selectVendorStatPop/qvObj/object.sys",
        {
            qualityid:qualityid
            ,qualityyyyy:qualityyyyy
            ,sourcingid:sourcingid
            ,businessnum:businessnum
        },
        function(arg){
            var qvObj = eval('(' + arg + ')').qvObj;
            var bussinessnm		= qvObj.BUSSINESSNM;
            var businessnum		= qvObj.BUSINESSNUM;
            var suggestphone	= qvObj.SUGGESTPHONE;
            var vendorstatus	= qvObj.VENDORSTATUS;
            var changedesc		= qvObj.CHANGEDESC;
            $("#spanVendorNmVenDiv").html(bussinessnm);
            $("#spanBussinessVenDiv").html(businessnum);
            $("#spanPhoneVenDiv").html(suggestphone);
            $("#vendorStatusVenDiv").val(vendorstatus);
            $("#changeDescVenDiv").val(changedesc);
            $("#qualityidVenDiv").val(qualityid);
            $("#qualityyyyyVenDiv").val(qualityyyyy);
            $("#sourcingidVenDiv").val(sourcingid);
            $("#businessnumVenDiv").val(businessnum);
            $("#venRegDiv").jqmShow();
        }
	);
}
function fnSaveVenStatus(){
	var qualityid 		= $("#qualityidVenDiv").val();
	var qualityyyyy 	= $("#qualityyyyyVenDiv").val();
	var sourcingid 		= $("#sourcingidVenDiv").val();
	var businessnum 	= $("#businessnumVenDiv").val();
	var vendorStatus 	= $("#vendorStatusVenDiv").val();
	var changeDesc 		= $("#changeDescVenDiv").val();
	$.blockUI();
	$.post(
        "/quality/updateQualityVenStatus.sys",
        {
            qualityid:qualityid
            ,qualityyyyy:qualityyyyy
            ,sourcingid:sourcingid
            ,businessnum:businessnum
            ,vendorStatus:vendorStatus
            ,changeDesc:changeDesc
        },
        function(arg){
			if($.parseJSON(arg).customResponse.success){
				alert("처리가 완료되었습니다.");
				$("#venRegDiv").jqmHide();
            	$("#list").toggleSubGridRow(qualityid);
            	$("#list").expandSubGridRow(qualityid);
            	fnSummary();
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

function fnQualityChkPop(kind,qualityid,qualityyyyy,sourcingid,businessnum){
    $("#spanQualityChkSourcingNm").html("");
    $("#spanQualityChkDivSpec").html("");
    $("#spanQualityChkItem1").html("");
    $("#spanQualityChkItem2").html("");
    $("#spanQualityChkS").html("");
    $("#spanQualityChkP").html("");
    $(".qualityCheck_yn").each(function(index){
        $(this).prop("checked",false);
    });
    $("#quality_file_seq1").val("");
    $("#quality_file1").html("");
    $("#quality_file_seq2").val("");
    $("#quality_file2").html("");
    $("#qualityChk_appKind1").html("");
    $("#qualityChk_appKind2").html("");
    fnInitDatePicker();
	$.blockUI();
	$.post(
        "/quality/selectQualityCheck/detailObj/object.sys",
        {
            kind:kind
            ,qualityid:qualityid
            ,qualityyyyy:qualityyyyy
            ,sourcingid:sourcingid
            ,businessnum:businessnum
        },
        function(arg){
			var resultMap = eval('(' + arg + ')').detailObj;
			
            $("#spanQualityChkSourcingNm").html(resultMap.SOURCINGNM);
            $("#spanQualityChkDivSpec").html(resultMap.SPEC);
            $("#spanQualityChkItem1").html(resultMap.PRODTYPE1_NM+" / "+resultMap.PRODTYPE2_NM);
            $("#spanQualityChkItem2").html(resultMap.QUALITYSTD_NM);
            $("#spanQualityChkVendorNm").html(resultMap.BUSSINESSNM);
            if($.trim(resultMap.SPEC_FILE_PATH) != "" && $.trim(resultMap.SPEC_FILE_NAME) != "" ){
                var tempSFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.SPEC_FILE_PATH+"')\"><font color='#0000ff'>"+resultMap.SPEC_FILE_NAME+"</font></a>";
                $("#spanQualityChkS").html(tempSFileNm);
            }else{
                $("#spanQualityChkS").html("");
            }
            if($.trim(resultMap.PROC_FILE_PATH) != "" && $.trim(resultMap.PROC_FILE_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.PROC_FILE_PATH+"')\"><font color='#0000ff'>"+resultMap.PROC_FILE_NAME+"</font></a>";
                $("#spanQualityChkP").html(tempPFileNm);
            }else{
                $("#spanQualityChkP").html("");
            }
            
            $(".qualityCheck_yn").each(function(index){
                if($(this).val() == $.trim(resultMap.QUALITYYN)){
                    $(this).prop("checked",true);
                }
            });
            
            if($.trim(resultMap.RESULTFILE_PATH) != "" && $.trim(resultMap.RESULTFILE_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.RESULTFILE_PATH+"')\"><font color='#0000ff'>"+resultMap.RESULTFILE_NAME+"</font></a>";
                $("#quality_file1").html(tempPFileNm);
                $("#quality_file_seq1").val(resultMap.RESULTFILE);
            }
            if($.trim(resultMap.GRADEFILE_PATH) != "" && $.trim(resultMap.GRADEFILE_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.GRADEFILE_PATH+"')\"><font color='#0000ff'>"+resultMap.GRADEFILE_NAME+"</font></a>";
                $("#quality_file2").html(tempPFileNm);
                $("#quality_file_seq2").val(resultMap.GRADEFILE);
            }
            
            $("#quality_kind").val(kind);
            $("#quality_mst_sourcintId").val(resultMap.SOURCINGID);
            $("#quality_mst_businissnum").val(resultMap.BUSINESSNUM);
            $("#quality_mst_qualityid").val(resultMap.QUALITYID);
            $("#quality_mst_qualityyyyy").val(resultMap.QUALITYYYYY);
            $("#purposeQualityChk").val(resultMap.PURPOSE);
            $("#1stApprUserId").val(resultMap.APPID1);
            $("#1stApprUserNm").val(resultMap.APPID1_NM);
            $("#2ndApprUserId").val(resultMap.APPID2);
            $("#2ndApprUserNm").val(resultMap.APPID2_NM);
            $("#qualitychk_qualitydesc").val(resultMap.QUALITYDESC);
            $("#qualityChk_appcomment1").val(resultMap.APPCOMMENT1);
            $("#qualityChk_appcomment2").val(resultMap.APPCOMMENT2);
            $("#qualityChk_quality_part_seq").val(resultMap.QUALITY_PART_SEQ);
            
            var appDate1 = fnGetString(resultMap.APPDATE1) == '' ? '' : ' ('+resultMap.APPDATE1+')';
            var appDate2 = fnGetString(resultMap.APPDATE2) == '' ? '' : ' ('+resultMap.APPDATE2+')';
            
            $("#qualityChk_appKind1").html(fnGetString(resultMap.APPKIND1_NM) + appDate1);
            $("#qualityChk_appKind2").html(fnGetString(resultMap.APPKIND2_NM) + appDate2);
            $("#qualityChk_appcomment1").prop("readonly",true);
            $("#qualityChk_appcomment2").prop("readonly",true);
            
            if(!resultMap.REQKIND){
                $("#qualityCheck_Temp_SaveButton").show();
                $("#qualityCheck_SaveButton").show();
                $("#qualityChk_1stUserBtn").show();
                $("#qualityChk_2ndUserBtn").show();
                $("#qualityChk_1stUserDeleteBtn").show();
                $("#qualityChk_2ndUserDeleteBtn").show();                      
            }else if(resultMap.REQKIND == "0" || resultMap.REQKIND == "20" ){
                $("#qualityCheck_Temp_SaveButton").hide();
                $("#qualityCheck_SaveButton").show();
                $("#qualityChk_1stUserBtn").show();
                $("#qualityChk_2ndUserBtn").show();
                $("#qualityChk_1stUserDeleteBtn").show();
                $("#qualityChk_2ndUserDeleteBtn").show();                
            }else{
                $("#qualityCheck_Temp_SaveButton").hide();
                $("#qualityCheck_SaveButton").hide();
                $("#qualityChk_1stUserDeleteBtn").hide();
                $("#qualityChk_2ndUserDeleteBtn").hide();
                $("#qualityChk_1stUserBtn").hide();
                $("#qualityChk_2ndUserBtn").hide();
            }
            $("#qualityChk").jqmShow();
            
            $.unblockUI();
        }
	);
}

function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#1stApprUserId").val(userId);
	$("#1stApprUserNm").val(userNm);
}

function fnSelectUserCallback2(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#2ndApprUserId").val(userId);
	$("#2ndApprUserNm").val(userNm);
}

function fnSelectUserCallback3(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#1stVocUserId").val(userId);
	$("#1stVocUserNm").val(userNm);
}

function fnSelectUserCallback4(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#2ndVocUserId").val(userId);
	$("#2ndVocUserNm").val(userNm);
}

function fnLftdDivFileUpload(attachSeq, attachId){
	fnUploadDialog("첨부파일", attachSeq ,"fnCallBackProcessLftdFile" ,"9", attachId);
}
function fnCallBackProcessLftdFile(rtn_attach_seq,rtn_attach_file_name,rtn_attach_file_path,seq){
    if(seq == "quality_file_seq1"){
        $("#quality_file_seq1").val(rtn_attach_seq);
        var templftd_file1 = "<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>";
        $("#quality_file1").html(templftd_file1);
    }else{
        $("#quality_file_seq2").val(rtn_attach_seq);
        var templftd_file2 = "<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>";
        $("#quality_file2").html(templftd_file2);
    }
    
}
function fnInitDatePicker(){
	$("#qualitydateQualityChk").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd",
	});
	$("#qualitydateQualityChk").val("<%=CommonUtils.getCurrentDate()%>");
}

function fnSaveQualityChkInfo(saveKind){
	var confirmTempMsg = " 하시겠습니까?";
	if(saveKind == "T"){
		confirmTempMsg ="임시저장을"+confirmTempMsg;
	}else if(saveKind == "S"){
		confirmTempMsg ="승인요청을"+confirmTempMsg;
	}
	var saveKindTmp				= saveKind;
	var qualityCheck_yn			= $("input[name=qualityCheck_yn]:checked").val();
    var purposeQualityChk 		= $("#purposeQualityChk").val();
    var quality_file_seq1 		= $("#quality_file_seq1").val();
    var quality_file_seq2 		= $("#quality_file_seq2").val();
    var quality_kind 			= $("#quality_kind").val();
    var quality_sourcingId 		= $("#quality_mst_sourcintId").val();
    var quality_businissnum 	= $("#quality_mst_businissnum").val();
    var quality_qualityid 		= $("#quality_mst_qualityid").val();
    var quality_qualityyyyy 	= $("#quality_mst_qualityyyyy").val();
    var tmp1stApprUserId 		= $("#1stApprUserId").val();
    var tmp2ndApprUserId 		= $("#2ndApprUserId").val();
    var qualitydateQualityChk 	= $("#qualitydateQualityChk").val();
    var qualitychk_qualitydesc  = $("#qualitychk_qualitydesc").val();
    var quality_qualityPartSeq  = $("#qualityChk_quality_part_seq").val();
    
	if($.trim(purposeQualityChk).length == 0){
		alert("검사목적을 입력하여 주십시오.");
		return false;
	}
	if($.trim(qualityCheck_yn).length == 0){
		alert("적합여부를 선택하여 주십시오.");
		return false;
	}
	if($.trim(qualitydateQualityChk).length == 0){
		alert("품질검사일을 입력하여주십시오.");
		return false;
	}
	if($.trim(tmp1stApprUserId).length == 0){
		alert("1차 승인자를 선택하여 주십시오.");
		return false;
	}
// 	if($.trim(tmp2ndApprUserId).length == 0){
// 		alert("2차 승인자를 선택하여 주십시오.");
// 		return false;
// 	}
	if(!confirm(confirmTempMsg)) return false;
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/saveQualityReqInfo.sys",
        {  
            	saveKindTmp:saveKindTmp
            ,	qualityCheck_yn:qualityCheck_yn
            ,	purposeQualityChk:purposeQualityChk
            ,	quality_file_seq1:quality_file_seq1
            ,	quality_file_seq2:quality_file_seq2
            ,	quality_kind:quality_kind
            ,	quality_sourcingId:quality_sourcingId
            ,	quality_businissnum:quality_businissnum
            ,	quality_qualityid:quality_qualityid
            ,	quality_qualityyyyy:quality_qualityyyyy
            ,	tmp1stApprUserId:tmp1stApprUserId
            ,	tmp2ndApprUserId:tmp2ndApprUserId
            ,	qualitydateQualityChk:qualitydateQualityChk
            ,	qualitychk_qualitydesc:qualitychk_qualitydesc
            ,	quality_qualityPartSeq:quality_qualityPartSeq
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
                $("#qualityChk").jqmHide();
            	$("#list").toggleSubGridRow(quality_qualityid);
            	$("#list").expandSubGridRow(quality_qualityid);
            	fnSummary();
            }
        }
    );
}
function fnSetQuarterText(listObj, selrowContent, rowid, columnName, qKind, qStatus, vStatus){
	if(vStatus == '10'){
	    if($.trim(qStatus) != ''){
	        var temp_quarter_kind = qStatus;
	        if(temp_quarter_kind == '0'){
	            listObj.setCell(rowid,	columnName	, "  <a href='#' onclick=\"javascript:fnQualityChkPop('"+qKind+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"');\" ><font color='#aaaaaa' style=\"text-decoration:underline;\">임시저장</font></a>");
	        }else if(temp_quarter_kind == '10'){
	            listObj.setCell(rowid,	columnName	, "  <a href='#' onclick=\"javascript:fnQualityChkPop('"+qKind+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"');\" ><font color='#007eff' style=\"text-decoration:underline;\">승인 중</font><font color='green' style=\"text-decoration:underline;\">(적합)</font></a>");
	        }else if(temp_quarter_kind == '19'){
	            listObj.setCell(rowid,	columnName	, "  <a href='#' onclick=\"javascript:fnQualityChkPop('"+qKind+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"');\" ><font color='#007eff' style=\"text-decoration:underline;\">승인 중</font><font color='red' style=\"text-decoration:underline;\">(부적합)</font></a>");
	        }else if(temp_quarter_kind == '20'){
	            listObj.setCell(rowid,	columnName	, "  <a href='#' onclick=\"javascript:fnQualityChkPop('"+qKind+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"');\" ><font color='red' style=\"text-decoration:underline;\">반려</font><font color='green' style=\"text-decoration:underline;\">(적합)</font></a>");
	        }else if(temp_quarter_kind == '29'){
	            listObj.setCell(rowid,	columnName	, "  <a href='#' onclick=\"javascript:fnQualityChkPop('"+qKind+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"');\" ><font color='red' style=\"text-decoration:underline;\">반려</font><font color='red' style=\"text-decoration:underline;\">(부적합)</font></a>");
	        }else if(temp_quarter_kind == '90'){
	            listObj.setCell(rowid,	columnName	, "  <a href='#' onclick=\"javascript:fnQualityChkPop('"+qKind+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"');\" ><font color='green' style=\"text-decoration:underline;\">적합</font></a>");
	        }else if(temp_quarter_kind == '99'){
	            listObj.setCell(rowid,	columnName	, "  <a href='#' onclick=\"javascript:fnQualityChkPop('"+qKind+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"');\" ><font color='red' style=\"text-decoration:underline;\">부적합</font></a>");
	        }
	    }else{
	        listObj.setCell(rowid,	columnName	, "  <button type='button' onclick=\"javascript:fnQualityChkPop('"+qKind+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"');\" class='btn btn-primary btn-xs'>등록</button>");
	    }
	}else{
		listObj.setCell(rowid,	columnName	, " ");
	}
}

function fnVocProcDetail(vocid){
    $("#vocProc_vocid").val("");
    $("#vocProc_sourcingnm").html("");
    $("#vocProc_spec").html("");
    $("#vocProc_prodtype").html("");
    $("#vocProc_qualitystd").html("");
    $("#vocProc_vendornm").html("");
    $("#vocProc_specfilename").html("");
    $("#vocProc_procfilename").html("");
    $("#vocProc_reqborgnm").html("");
    $("#vocProc_requsernm").html("");
    $("#vocProc_reqdate").html("");
    $("#vocProc_reqtel").html("");
    $("#vocProc_attachspan1").html("");
    $("#vocProc_attachspan2").html("");
    $("#vocProc_reqdesc").val("");
    $(".vocProc_treatresult").each(function(index){
        $(this).prop("checked",false);
    });
    $("#vocProc_judgmentresult").val("");
    $("#vocProc_measureresult").val("");
    $("#span_vocProc_measurefile1").html("");
    $("#vocProc_measurefile1").val("");
    $("#span_vocProc_measurefile2").html("");
    $("#vocProc_measurefile2").val("");
    $("#vocProc_measuredesc").val("");
	$.blockUI();
	$.post(
        "/quality/selectVocDetailInfo/detailObj/object.sys",
        {
            vocid:vocid
        },
        function(arg){
			var resultMap = eval('(' + arg + ')').detailObj;
			
            $("#vocProc_vocid").val(resultMap.VOCID);
            $("#vocProc_sourcingnm").html(resultMap.SOURCINGNM);
            $("#vocProc_spec").html(resultMap.SPEC);
            $("#vocProc_prodtype").html(resultMap.PRODTYPE1_NM+" / "+resultMap.PRODTYPE2_NM);
            $("#vocProc_qualitystd").html(resultMap.QUALITYSTD_NM);
            $("#vocProc_vendornm").html(resultMap.BUSSINESSNM);
            if($.trim(resultMap.SPEC_FILE_NAME) != "" && $.trim(resultMap.SPEC_FILE_PATH) != "" ){
                var tempSFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.SPEC_FILE_PATH+"')\"><font color='#0000ff'>"+resultMap.SPEC_FILE_NAME+"</font></a>";
                $("#vocProc_specfilename").html(tempSFileNm);
            }else{
                $("#vocProc_specfilename").html("");
            }
            if($.trim(resultMap.PROC_FILE_NAME) != "" && $.trim(resultMap.PROC_FILE_PATH) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.PROC_FILE_PATH+"')\"><font color='#0000ff'>"+resultMap.PROC_FILE_NAME+"</font></a>";
                $("#vocProc_procfilename").html(tempPFileNm);
            }else{
                $("#vocProc_procfilename").html("");
            }
            
            $("#vocProc_reqborgnm").html(resultMap.BORGNM);
            $("#vocProc_requsernm").html(resultMap.REQ_REG_USER);
            $("#vocProc_reqdate").html(resultMap.REQDATE);
            $("#vocProc_reqtel").html(resultMap.REQTEL);
            if($.trim(resultMap.REQFILE2_NAME) != "" && $.trim(resultMap.REQFILE1_PATH) != "" ){
                var tempSFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.REQFILE1_PATH+"')\"><font color='#0000ff'>"+resultMap.REQFILE1_NAME+"</font></a>";
                $("#vocProc_attachspan1").html(tempSFileNm);
            }else{
                $("#vocProc_attachspan1").html("");
            }
            if($.trim(resultMap.REQFILE2_NAME) != "" && $.trim(resultMap.REQFILE2_PATH) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.REQFILE2_PATH+"')\"><font color='#0000ff'>"+resultMap.REQFILE2_NAME+"</font></a>";
                $("#vocProc_attachspan2").html(tempPFileNm);
            }else{
                $("#vocProc_attachspan2").html("");
            }
            $("#vocProc_reqdesc").val(resultMap.REQDESC);
            
        	$("#vocProc_treatresult_20").prop("disabled",false);
        	$("#vocProc_treatresult_30").prop("disabled",false);
        	$("#vocProc_judgmentresult").prop("disabled",false);
        	$("#vocProc_measureresult").prop("disabled",false);
        	$("#vocFile1").show();
        	$("#vocFile2").show();
        	$("#vocProc_measuredesc").prop("readonly",false);
        	
        	$("#voc_1stUserBtn").show();
        	$("#voc_2ndUserBtn").show();
        	$("#voc_1stUserDeleteBtn").show();
        	$("#voc_2ndUserDeleteBtn").show();
        	
        	$("#1stVocUserNm").prop("readonly",false);
        	$("#2ndVocUserNm").prop("readonly",false);
        	$("#voc_appcomment1").prop("readonly",false);
        	$("#voc_appcomment2").prop("readonly",false);	
            
            $(".vocProc_treatresult").each(function(index){
            	var treatResult = $.trim(resultMap.TREATRESULT) == '10' ? '20' : $.trim(resultMap.TREATRESULT); 
                if($(this).val() == treatResult){
                    $(this).prop("checked",true);
                }
                if(treatResult == '30' || treatResult == '40'){
	        		fnSetDisabledVoc();	
	        		$("#vocTempButton").hide();
	        		$("#vocSaveButton").hide();
                	$("#vocProc_treatresult_30").prop("checked",true);
                }else if(treatResult == '99') {
            		$("#vocTempButton").hide();
            		$("#vocSaveButton").show();
            		$("#vocProc_treatresult_30").prop("checked",true);
            	}
                
            });
            $("#vocProc_judgmentresult").val(resultMap.JUDGMENTRESULT);
            $("#vocProc_measureresult").val(resultMap.MEASURERESULT);
            if($.trim(resultMap.MEASUREFILE1_PATH) != "" && $.trim(resultMap.MEASUREFILE1_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.MEASUREFILE1_PATH+"')\"><font color='#0000ff'>"+resultMap.MEASUREFILE1_NAME+"</font></a>";
                $("#span_vocProc_measurefile1").html(tempPFileNm);
                $("#vocProc_measurefile1").val(resultMap.MEASUREFILE1);
            }
            if($.trim(resultMap.MEASUREFILE2_PATH) != "" && $.trim(resultMap.MEASUREFILE2_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.MEASUREFILE2_PATH+"')\"><font color='#0000ff'>"+resultMap.MEASUREFILE2_NAME+"</font></a>";
                $("#span_vocProc_measurefile2").html(tempPFileNm);
                $("#vocProc_measurefile2").val(resultMap.MEASUREFILE2);
            }
            $("#vocProc_measuredesc").val(resultMap.MEASUREDESC);
            if(resultMap.JUDGMENTRESULT == "30"){
                $("#vocProcButton").hide();
            }else{
                $("#vocProcButton").show();
            }
            
            var appStr1 = fnGetString(resultMap.APPKIND1_NM) == '' ? '' : fnGetString(resultMap.APPKIND1_NM) + (fnGetString(resultMap.APPDATE1) == '' ? '' : ' ('+resultMap.APPDATE1+')');
            var appStr2 = fnGetString(resultMap.APPKIND2_NM) == '' ? '' : fnGetString(resultMap.APPKIND2_NM) + (fnGetString(resultMap.APPDATE2) == '' ? '' : ' ('+resultMap.APPDATE2+')');
            
            $("#voc_appKind1").html(appStr1);
            $("#voc_appKind2").html(appStr2);            
            
    		$("#1stVocUserNm").val(fnGetString(resultMap.APPNM1));
    		$("#1stVocUserId").val(fnGetString(resultMap.APPID1));
    		
    		$("#2ndVocUserNm").val(fnGetString(resultMap.APPNM2));
    		$("#2ndVocUserId").val(fnGetString(resultMap.APPID2));
            
            
            $("#vocProc").jqmShow();
            $.unblockUI();
        }
    );
}

function fnVocProcClose(){
    $("#vocProc").jqmHide();
}


function vocProc_FileAttach1(){
	fnUploadDialog("첨부1", $("#vocProc_measurefile1").val() ,"fnCallBackVocMeasurefile1" ,"9", "");
}
function vocProc_FileAttach2(){
	fnUploadDialog("첨부2", $("#vocProc_measurefile2").val() ,"fnCallBackVocMeasurefile2" ,"9", "");
}

function fnCallBackVocMeasurefile1(rtn_attach_seq,rtn_attach_file_name,rtn_attach_file_path){
	$("#vocProc_measurefile1").val(rtn_attach_seq);
	if(rtn_attach_file_name.length > 10){
		rtn_attach_file_name = rtn_attach_file_name.substring(0,10) +"...";
	}
	$("#span_vocProc_measurefile1").html("<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>");
}
function fnCallBackVocMeasurefile2(rtn_attach_seq,rtn_attach_file_name,rtn_attach_file_path){
	$("#vocProc_measurefile2").val(rtn_attach_seq);
	if(rtn_attach_file_name.length > 10){
		rtn_attach_file_name = rtn_attach_file_name.substring(0,10) +"...";
	}
	$("#span_vocProc_measurefile2").html("<a href=\"javascript:fnAttachFileDownload('"+rtn_attach_file_path+"')\"><font color='#0000ff'>"+rtn_attach_file_name+"</font></a>");
}
function fnVocProc(kind){
	var treatresult		= $("input[name=vocProc_treatresult]:checked").val();
	var judgmentresult 	= $("#vocProc_judgmentresult").val();
	var measureresult 	= $("#vocProc_measureresult").val();
	var measurefile1 	= $("#vocProc_measurefile1").val();
	var measurefile2 	= $("#vocProc_measurefile2").val();
	var measuredesc 	= $("#vocProc_measuredesc").val();
	var vocid 			= $("#vocProc_vocid").val();
	var appUserId1 		= $("#1stVocUserId").val();
	var appUserId2 		= $("#2ndVocUserId").val();
	var vocAppcomment1 	= $("#voc_appcomment1").val();
	var vocAppcomment2 	= $("#voc_appcomment2").val();
	
	if($.trim(treatresult).length == 0){
		alert("처리결과를 선택하여 주십시오.");
		return false;
	}
	if($.trim(judgmentresult).length == 0){
		alert("판정결과를 선택하여 주십시오.");
		return false;
	}
	if($.trim(treatresult) == "30"){
        if($.trim(measureresult).length == 0){
            alert("조치결과를 입력하여 주십시오.");
            return false;
        }
	}
	if(kind == 'A'){
		if($.trim(appUserId1).length == 0){
			alert("승인자를 입력하여 주십시오.");
			return;
		}	
	}
	
	var confirmStr = kind == 'A' ? '승인요청' : '임시저장';
	
	if(!confirm(confirmStr + " 하시겠습니까?")) return false;
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/saveVocProcInfo.sys",
        {  
            	treatresult:treatresult
            ,	judgmentresult:judgmentresult
            ,	measureresult:measureresult
            ,	measurefile1:measurefile1
            ,	measurefile2:measurefile2
            ,	measuredesc:measuredesc
            ,	vocid:vocid
            ,	appUserId1:appUserId1
            ,	appUserId2:appUserId2
            ,	kind:kind
            ,	vocAppcomment1:vocAppcomment1
            ,	vocAppcomment2:vocAppcomment2
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
                $("#vocProc").jqmHide();
                fnSrcVocList();
            }
        }
    );
}

function fnSetTreatResult(kind){
	if(kind == '20'){
		$("#vocTempButton").show();
		$("#vocSaveButton").hide();
	}else if(kind == '30') {
		$("#vocTempButton").hide();
		$("#vocSaveButton").show();
	}
}

function fnSetDisabledVoc(){
	$("#vocProc_treatresult_20").prop("disabled",true);
	$("#vocProc_treatresult_30").prop("disabled",true);
	$("#vocProc_judgmentresult").prop("disabled",true);
	$("#vocProc_measureresult").prop("disabled",true);
	$("#vocFile1").hide();
	$("#vocFile2").hide();
	$("#vocProc_measuredesc").prop("readonly",true);
	
	$("#voc_1stUserBtn").hide();
	$("#voc_2ndUserBtn").hide();
	$("#voc_1stUserDeleteBtn").hide();
	$("#voc_2ndUserDeleteBtn").hide();
	
	$("#1stVocUserNm").prop("readonly",true);
	$("#2ndVocUserNm").prop("readonly",true);
	$("#voc_appcomment1").prop("readonly",true);
	$("#voc_appcomment2").prop("readonly",true);
}
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
   $("#srcReqClientBtn").click(function(){
      fnBuyborgDialog("CLT", "1", "", "fnCallBackClient"); 
   });
});

/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackClient(groupId, clientId, branchId, borgNm, areaType) {
	$("#reqClientNm").val(borgNm);
	$("#reqClientId").val(clientId);
}
</script>
<% //------------------------------------------------------------------------------ %>
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
.bmtWindow.vocReg {
    top: 25%;
    left: 30%;
    width: 650px;
}
.bmtWindow.vocList {
    top: 25%;
    left: 30%;
    width: 1020px;
}
.bmtWindow.vocProc {
    top: 18%;
    left: 30%;
    width: 700px;
}

.bmtWindow.ven {
	top: 25%;
    left: 30%;
    width: 400px;
}

.bmtWindow.qualityChk {
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
                                        <button id='srcStandardButton' class="btn btn-default btn-sm"><i class="fa fa-search"></i>조회</button>							
                                    </td>
                                </tr>				
                                <tr>
                                    <td colspan="4" height='1'></td>
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
                                        <input id="srcSourcingNms" name="srcSourcingNms" type="text"/>
                                    </td>
                                    <td class="table_td_subject" width="100">규격</td>
                                    <td class="table_td_contents">
                                        <input id="srcSpecs" name="srcSpecs" type="text"/>
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
										<button id="standardCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
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
                                        <button id='srcProcessButton' class="btn btn-default btn-sm"><i class="fa fa-search"></i>조회</button>							
                                    </td>
                                </tr>				
                                <tr>
                                    <td colspan="4" height='1'></td>
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
										<button id="processCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
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
		        				<h2>공급사 상태변경</h2>
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
									<td  class="table_td_subject">공급사</td>
									<td  class="table_td_contents">
										<input type="hidden" value="" id="qualityidVenDiv" name="qualityidVenDiv"/>
										<input type="hidden" value="" id="qualityyyyyVenDiv" name="qualityyyyyVenDiv"/>
										<input type="hidden" value="" id="sourcingidVenDiv" name="sourcingidVenDiv"/>
										<input type="hidden" value="" id="businessnumVenDiv" name="businessnumVenDiv"/>
										<span id="spanVendorNmVenDiv"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">사업자번호</td>
									<td class="table_td_contents"><span id="spanBussinessVenDiv"></span></td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">연락처</td>
									<td class="table_td_contents">
                                        <span id="spanPhoneVenDiv"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">상태</td>
									<td class="table_td_contents">
										<select id="vendorStatusVenDiv" class="select">
											<option value="10">공급</option>
											<option value="20">적격사</option>
											<option value="90">Pool Out</option>
										</select>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">변경사항</td>
									<td class="table_td_contents">
										<textarea rows="4" id="changeDescVenDiv" name="changeDescVenDiv" style="width:236px; height: 80px" ></textarea>
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


<div class="bmtWindow vocReg" id="vocRegDiv">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td bgcolor="#FFFFFF">
				<div id="vocRegDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>품질 VOC 접수</h2>
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
                                    <td colspan="4" height='5'></td>
                                </tr>				
                                <tr>
                                    <td colspan="4">
                                        <!-- 타이틀 시작 -->
                                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top">
                                                <td width="20" valign="middle">
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                                                </td>
                                                <td height="29" class='ptitle'>상품정보
                                                    <input type="hidden" id="vocQualityId" 		name="vocQualityId"/>
                                                    <input type="hidden" id="vocQualityYYYY" 	name="vocQualityYYYY"/>
                                                    <input type="hidden" id="vocSourcingId" 	name="vocSourcingId"/>
                                                    <input type="hidden" id="vocBusinessNum" 	name="vocBusinessNum"/>
                                                
                                                </td>
                                            </tr>
                                        </table>    
                                        <!-- 타이틀 끝 -->			
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='5'></td>
                                </tr>						
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='1'></td>
                                </tr>
                                <tr>
                                    <td class="table_td_subject" width="100" >소싱명</td>
                                    <td class="table_td_contents" colspan="3" id="vocSourcingNm"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">규격</td>
                                    <td class="table_td_contents" id="vocSpec"></td>
                                    <td class="table_td_subject" width="100">상품유형</td>
                                    <td class="table_td_contents" id="vocProdType"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">품질기준</td>
                                    <td class="table_td_contents" id="vocQualityStd"></td>
                                    <td class="table_td_subject" width="100">공급사</td>
                                    <td class="table_td_contents" id="vocVendorNm"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">규격서</td>
                                    <td class="table_td_contents" id="vocSpecFileName"></td>
                                    <td class="table_td_subject" width="100">절차서</td>
                                    <td class="table_td_contents" id="vocProcFileName"></td>
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
                                    <td colspan="4" height='5'></td>
                                </tr>				
                                <tr>
                                    <td colspan="4">
                                        <!-- 타이틀 시작 -->
                                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top">
                                                <td width="20" valign="middle">
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                                                </td>
                                                <td height="29" class='ptitle'>요청접수</td>
                                            </tr>
                                        </table>    
                                        <!-- 타이틀 끝 -->			
                                    </td>
                                                            
                                </tr>
                                <tr>
                                    <td colspan="4" height='5'></td>
                                </tr>						
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='1'></td>
                                </tr>
                                <tr>
                                    <td class="table_td_subject" width="100" >요청법인</td>
                                    <td class="table_td_contents">
                                        <input id="reqClientNm" name="reqClientNm" type="text" readonly="readonly"/>
                                        <input id="reqClientId" name="reqClientId" type="hidden"/>
                                        <a href="#">
                                            <img id="srcReqClientBtn" name="srcReqClientBtn" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; vertical-align: middle; border: 0px;" class="icon_search" />
                                        </a>							
                                    </td>
                                    <td class="table_td_subject" width="100" >팀/요청자</td>
                                    <td class="table_td_contents">
                                        <input id="reqUserNm" name="reqUserNm" type="text" maxlength="100"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">요청일</td>
                                    <td class="table_td_contents">
                                        <input id="reqDate" name="reqDate" type="text" value="<%=currDate%>" readonly="readonly"/>
                                        
                                    </td>
                                    <td class="table_td_subject" width="100">연락처</td>
                                    <td class="table_td_contents">
                                        <input id="reqTel" name="reqTel" type="text" maxlength="20" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">첨부1</td>
                                    <td class="table_td_contents">
                                        <button type='button' onclick="javascript:vocFileAttach1();" class='btn btn-primary btn-xs'>등록</button>
                                        <input id="vocAttachSeq1" name="vocAttachSeq1" type="hidden"/>
                                        <span id="vocAttachSpan1"></span>
                                    </td>
                                    <td class="table_td_subject" width="100">첨부2</td>
                                    <td class="table_td_contents">
                                        <button type='button' onclick="javascript:vocFileAttach2();" class='btn btn-primary btn-xs'>등록</button>
                                        <input id="vocAttachSeq2" name="vocAttachSeq2" type="hidden"/>
                                        <span id="vocAttachSpan2"></span>							
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">요청내용</td>
                                    <td class="table_td_contents" colspan="3">
                                        <textarea id="reqDesc" name="reqDesc" rows="3" style="height: 100px; width: 98%; "  ></textarea>
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
									<td align="center">
										<button id="vocRegButton" type="button" class="btn btn-danger btn-sm" onclick="javascript:fnVocReg();"><i class="fa fa-save"></i> 접수</button>
										<button id="vocRegCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
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


<div class="bmtWindow vocList" id="vocListDiv">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td bgcolor="#FFFFFF">
				<div id="vocListDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>VOC 현황</h2>
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
                                    <td colspan="6" height='5'></td>
                                </tr>				
                                <tr>
                                    <td colspan="6" height="30" valign="top">
                                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    * 상태를 클릭하시면 상세화면과 처리를 하실 수 있습니다.
                                                </td>
                                                <td align="right">
                                                    <button id='srcVocButton' class="btn btn-default btn-sm"><i class="fa fa-search"></i>조회</button>		
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>				
                                <tr>
                                    <td colspan="6" height='1'></td>
                                </tr>				
                                <tr>
                                    <td colspan="6" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="6" height='1'></td>
                                </tr>
                                <tr>
                                    <td class="table_td_subject" width="100">연도</td>
                                    <td class="table_td_contents">
                                        <select id="vocYear" name="vocYear" class="select" style="width: 70px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                                            <option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                                        </select> 
                                    </td>
                                    <td class="table_td_subject" width="100">소싱명</td>
                                    <td class="table_td_contents">
                                        <input id="vocListSourcingNm" name="vocListSourcingNm" type="text"/>
                                    </td>
                                    <td class="table_td_subject" width="100">규격</td>
                                    <td class="table_td_contents">
                                        <input id="vocListSpec" name="vocListSpec" type="text"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" class="table_middle_line"></td>
                                </tr>						
                                <tr>
                                    <td class="table_td_subject" width="100">공급사</td>
                                    <td class="table_td_contents">
                                        <input id="vocListVendorNm" name="vocListVendorNm" type="text"/>
                                    </td>
                                    <td class="table_td_subject" width="100">상태</td>
                                    <td class="table_td_contents" colspan="3">
                                        <select id="vocStatus" class="select">
                                        	<option value="">전체</option>
                                        	<option value="10">접수</option>
                                        	<option value="20">처리중</option>
                                        	<option value="30">완료</option>
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
                                    <td colspan="6" height='8'></td>
                                </tr>
                            </table>				
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div id="jqgrid">
											<table id="vocListGrid"></table>
											<div id="vocListDivPager"></div>
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
										<button id="vocListCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
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
			</tdㅓ>
		</tr>
	</table>
</div>


<div class="bmtWindow vocProc" id="vocProc">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td bgcolor="#FFFFFF">
				<div id="vocProcDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>품질 VOC 조치</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" onclick="javascript:fnVocProcClose();">
		        				<img src="/img/contents/btn_close.png"   >
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
                            <table width="100%"  border="0" cellspacing="0" cellpadding="0" style="display: none;">
                                <tr>
                                    <td colspan="4" height='5'></td>
                                </tr>				
                                <tr>
                                    <td colspan="4">
                                        <!-- 타이틀 시작 -->
                                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top">
                                                <td width="20" valign="middle">
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                                                </td>
                                                <td height="29" class='ptitle'>상품정보
                                                    <input type="hidden" id="vocProc_vocid" name="vocProc_vocid"/>
                                                </td>
                                            </tr>
                                        </table>    
                                        <!-- 타이틀 끝 -->			
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='5'></td>
                                </tr>						
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='1'></td>
                                </tr>
                                <tr>
                                    <td class="table_td_subject" width="100" >소싱명</td>
                                    <td class="table_td_contents" colspan="3">
                                    	<span id="vocProc_sourcingnm"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">규격</td>
                                    <td class="table_td_contents">
                                    	<span  id="vocProc_spec"></span>
                                    </td>
                                    <td class="table_td_subject" width="100">상품유형</td>
                                    <td class="table_td_contents">
                                    	<span  id="vocProc_prodtype"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">품질기준</td>
                                    <td class="table_td_contents">
                                    	<span id="vocProc_qualitystd"></span>
                                    </td>
                                    <td class="table_td_subject" width="100">공급사</td>
                                    <td class="table_td_contents">
                                    	<span id="vocProc_vendornm"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">규격서</td>
                                    <td class="table_td_contents" >
										<span id="vocProc_specfilename"></span>
                                    </td>
                                    <td class="table_td_subject" width="100">절차서</td>
                                    <td class="table_td_contents" >
                                    	<span id="vocProc_procfilename"></span>
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
                                    <td colspan="4" height='5'></td>
                                </tr>				
                                <tr>
                                    <td colspan="4">
                                        <!-- 타이틀 시작 -->
                                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top">
                                                <td width="20" valign="middle">
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                                                </td>
                                                <td height="29" class='ptitle'>요청접수</td>
                                            </tr>
                                        </table>    
                                        <!-- 타이틀 끝 -->			
                                    </td>
                                                            
                                </tr>
                                <tr>
                                    <td colspan="4" height='5'></td>
                                </tr>						
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='1'></td>
                                </tr>
                                <tr>
                                    <td class="table_td_subject" width="100" >요청법인</td>
                                    <td class="table_td_contents">
                                    	<span id="vocProc_reqborgnm"></span>
                                    </td>
                                    <td class="table_td_subject" width="100" >팀/요청자</td>
                                    <td class="table_td_contents">
                                    	<span id="vocProc_requsernm"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">요청일</td>
                                    <td class="table_td_contents">
                                    	<span id="vocProc_reqdate"></span>
                                    </td>
                                    <td class="table_td_subject" width="100">연락처</td>
                                    <td class="table_td_contents">
                                    	<span id="vocProc_reqtel"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">첨부1</td>
                                    <td class="table_td_contents">
                                        <span id="vocProc_attachspan1"></span>
                                    </td>
                                    <td class="table_td_subject" width="100">첨부2</td>
                                    <td class="table_td_contents">
                                        <span id="vocProc_attachspan2"></span>							
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">요청내용</td>
                                    <td class="table_td_contents" colspan="3">
                                        <textarea id="vocProc_reqdesc" rows="3" style="height: 100px; width: 98%; background-color: #aaaaaa;margin-top: 3px;margin-bottom: 3px;"  readonly="readonly" ></textarea>
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
                                    <td colspan="4" height='5'></td>
                                </tr>				
                                <tr>
                                    <td colspan="4">
                                        <!-- 타이틀 시작 -->
                                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top">
                                                <td width="20" valign="middle">
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                                                </td>
                                                <td height="29" class='ptitle'>조치정보</td>
                                            </tr>
                                        </table>    
                                        <!-- 타이틀 끝 -->			
                                    </td>
                                                            
                                </tr>
                                <tr>
                                    <td colspan="4" height='5'></td>
                                </tr>						
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                                <tr>
                                    <td colspan="4" height='1'></td>
                                </tr>
                                <tr>
                                    <td class="table_td_subject" width="100" >처리결과</td>
                                    <td class="table_td_contents" colspan="3">
										<label for="vocProc_treatresult_20"><input type="radio" class="vocProc_treatresult" name="vocProc_treatresult" id="vocProc_treatresult_20" value="20" onclick="javascript:fnSetTreatResult('20');"/>처리 중</label>
										<label for="vocProc_treatresult_30"><input type="radio" class="vocProc_treatresult" name="vocProc_treatresult" id="vocProc_treatresult_30" value="30" onclick="javascript:fnSetTreatResult('30');"/>완료</label>
<!-- 										<label for="vocProc_treatresult_40"><input type="radio" class="vocProc_treatresult" name="vocProc_treatresult" id="vocProc_treatresult_40" value="40" onclick="javascript:fnSetTreatResult('40');"/>완료</label> -->
<!-- 										<label for="vocProc_treatresult_99"><input type="radio" class="vocProc_treatresult" name="vocProc_treatresult" id="vocProc_treatresult_99" value="99" onclick="javascript:fnSetTreatResult('99');"/>완료</label> -->
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100" >판정결과</td>
                                    <td class="table_td_contents">
                                    	<select class="select" id="vocProc_judgmentresult">
                                    		<option value="">선택</option>
                                    	</select>
                                    </td>
                                    <td class="table_td_subject" width="100" >조치결과</td>
                                    <td class="table_td_contents">
                                    	<select class="select" id="vocProc_measureresult">
                                    		<option value="">선택</option>
                                    	</select>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">첨부1</td>
                                    <td class="table_td_contents">
                                        <button id="vocFile1" type='button' onclick="javascript:vocProc_FileAttach1();" class='btn btn-primary btn-xs'>등록</button>
                                        <input id="vocProc_measurefile1" name="vocProc_measurefile1" type="hidden"/>
                                        <span id="span_vocProc_measurefile1"></span>
                                    </td>
                                    <td class="table_td_subject" width="100">첨부2</td>
                                    <td class="table_td_contents">
                                        <button id="vocFile2" type='button' onclick="javascript:vocProc_FileAttach2();" class='btn btn-primary btn-xs'>등록</button>
                                        <input id="vocProc_measurefile2" name="vocProc_measurefile2" type="hidden"/>
                                        <span id="span_vocProc_measurefile2"></span>

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100">조치내용</td>
                                    <td class="table_td_contents" colspan="3">
                                        <textarea id="vocProc_measuredesc" rows="3" style="height: 100px; width: 98%; margin-top: 3px; margin-bottom: 3px;" ></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
                            </table>
                            
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
										<input type="text" id="1stVocUserNm" value=""/>
										<input type="hidden" id="1stVocUserId" value=""/>
                                        <button id="voc_1stUserBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-search fa-sm"></i></button>
                                        <button id="voc_1stUserDeleteBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-times fa-sm"></i></button>
									</td>
									<td class="table_td_subject" rowspan="3" style="width:60px">Comment</td>
									<td class="table_td_contents" rowspan="3">
										<textarea rows="2" cols="10" style="width:200px; height: 30px" id="voc_appcomment1"></textarea>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">상태</td>
									<td class="table_td_contents">
										<span id="voc_appKind1"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="5" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject" rowspan="3">2차승인</td>
									<td class="table_td_subject">승인자</td>
									<td class="table_td_contents">
										<input type="text" id="2ndVocUserNm" value=""/>
										<input type="hidden" id="2ndVocUserId" value=""/>
                                        <button id="voc_2ndUserBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-search fa-sm"></i></button>
                                        <button id="voc_2ndUserDeleteBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-times fa-sm"></i></button>
									</td>
									<td class="table_td_subject" rowspan="3">Comment</td>
									<td class="table_td_contents" rowspan="3">
										<textarea rows="2" cols="10" style="width:200px; height: 30px" id="voc_appcomment2"></textarea>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">상태</td>
									<td class="table_td_contents">
										<span id="voc_appKind2"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="5" class="table_top_line"></td>
                                </tr>
							</table>                            
                            
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="vocTempButton" type="button" class="btn btn-warning btn-sm" style="margin-top: 8px;display: none;" onclick="javascript:fnVocProc('T');"><i class="fa fa-close"></i>임시저장</button>
										<button id="vocSaveButton" type="button" class="btn btn-danger btn-sm" style="margin-top: 8px;display: none;" onclick="javascript:fnVocProc('A');"><i class="fa fa-close"></i>승인요청</button>
										<button id="vocProcCloseButton" type="button" class="btn btn-default btn-sm" style="margin-top: 8px;"><i class="fa fa-close"></i>닫기</button>
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



<div class="bmtWindow qualityChk" id="qualityChk">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="processDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>품질 검사/실사</h1>
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
										<input type="hidden" id="quality_kind" value=""/>
										<input type="hidden" id="quality_mst_sourcintId" value=""/>
										<input type="hidden" id="quality_mst_businissnum" value=""/>
										<input type="hidden" id="quality_mst_qualityid" value=""/>
										<input type="hidden" id="quality_mst_qualityyyyy" value=""/>
										<span id="spanQualityChkSourcingNm"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">규격</td>
									<td class="table_td_contents"><span id="spanQualityChkDivSpec"></span></td>
									<td class="table_td_subject">상품유형</td>
									<td class="table_td_contents"><span id="spanQualityChkItem1"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">품질기준</td>
									<td class="table_td_contents"><span id="spanQualityChkItem2"></span></td>
									<td class="table_td_subject">공급사</td>
									<td class="table_td_contents"><span id="spanQualityChkVendorNm"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">규격서</td>
									<td class="table_td_contents"><span id="spanQualityChkS"></span></td>
									<td class="table_td_subject">절차서</td>
									<td class="table_td_contents"><span id="spanQualityChkP"></span></td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
							</table>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                	<tr valign="top">
                                        <td width="20" valign="middle">
                                            <img width="14" height="15" src="/img/system/bullet_ptitle1.gif">
                                        </td>
                                        <td height="29" class="ptitle">품질 검사/실시</td>
                                    </tr>
                                </tbody>
                            </table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="4" class="table_top_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">검사목적</td>
									<td class="table_td_contents" colspan="3">
										<input type="text" id="purposeQualityChk" value="" style="width: 80%"/>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">적합여부</td>
									<td class="table_td_contents">
										<label for="qualityCheck_yn90"><input type="radio" class="qualityCheck_yn" name="qualityCheck_yn" id="qualityCheck_yn90" value="90"/>적합</label>
										<label for="qualityCheck_yn99"><input type="radio" class="qualityCheck_yn" name="qualityCheck_yn" id="qualityCheck_yn99" value="99"/>부적합</label>
									</td>
									<td class="table_td_subject">품질검사일</td>
									<td class="table_td_contents">
										<input type="text" id="qualitydateQualityChk" value=""  size="12"/>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">결과보고서</td>
									<td class="table_td_contents">
										<button id='btnFinalAttach2' class="btn btn-darkgray btn-xs" >등록</button>
										<input type="hidden" id="quality_file_seq2" value=""/>
										<span id="quality_file2"></span>
									</td>
									<td class="table_td_subject">성적서</td>
									<td class="table_td_contents">
										<button id='btnFinalAttach1' class="btn btn-darkgray btn-xs" >등록</button>
										<input type="hidden" id="quality_file_seq1" value=""/>
										<span id="quality_file1"></span>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">검사내용</td>
									<td class="table_td_contents" colspan="3">
										<textarea rows="2" cols="10" style="width:80%; height: 30px;margin-bottom: 3px;margin-top: 3px;" id="qualitychk_qualitydesc" ></textarea>
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
                                        <button id="qualityChk_1stUserBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-search fa-sm"></i></button>
                                        <button id="qualityChk_1stUserDeleteBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-times fa-sm"></i></button>
									</td>
									<td class="table_td_subject" rowspan="3" style="width:60px">Comment</td>
									<td class="table_td_contents" rowspan="3">
										<textarea rows="2" cols="10" style="width:200px; height: 30px" id="qualityChk_appcomment1"></textarea>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">상태</td>
									<td class="table_td_contents">
										<span id="qualityChk_appKind1"></span>
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
                                        <button id="qualityChk_2ndUserBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-search fa-sm"></i></button>
                                        <button id="qualityChk_2ndUserDeleteBtn" class="btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-times fa-sm"></i></button>
									</td>
									<td class="table_td_subject" rowspan="3">Comment</td>
									<td class="table_td_contents" rowspan="3">
										<textarea rows="2" cols="10" style="width:200px; height: 30px" id="qualityChk_appcomment2"></textarea>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">상태</td>
									<td class="table_td_contents">
										<span id="qualityChk_appKind2"></span>
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
										<button id="qualityCheck_Temp_SaveButton" type="button" class="btn btn-gray btn-sm"><i class="fa fa-close"></i>임시저장</button>
										<button id="qualityCheck_SaveButton" type="button" class="btn btn-danger btn-sm"><i class="fa fa-close"></i>승인요청</button>
										<button id="qualityCheck_CloseButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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

<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</body>
</html>