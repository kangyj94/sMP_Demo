<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%
	String listHeight = "$(window).height()-430 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String srcSuggestStDate = CommonUtils.getCustomDay("YEAR", -1);
	String srcSuggestEndDate = CommonUtils.getCurrentDate();
	@SuppressWarnings("unchecked")	
	List<Map<String,Object>> codeList = (List<Map<String,Object>>)request.getAttribute("codeList");
	@SuppressWarnings("unchecked")	
	List<Map<String,Object>> b2bAdmList = (List<Map<String,Object>>)request.getAttribute("b2bAdmList");
	@SuppressWarnings("unchecked")	
	List<Map<String,Object>> finalUserList = (List<Map<String,Object>>)request.getAttribute("finalUserList");
	boolean isClient = "BUY".equals(loginUserDto.getSvcTypeCd())? true:false;
	boolean isVendor = "VEN".equals(loginUserDto.getSvcTypeCd())? true:false;
	String srcFinalProcStatFlagNm = request.getParameter("srcFinalProcStatFlagNm");
	
	srcFinalProcStatFlagNm = CommonUtils.nvl(srcFinalProcStatFlagNm);
	
	// 2016-03-09  신규제안건 클릭시 조회 조건 변경 - 처리 상태 : 전체 --> 접수대기로 변경 
	boolean isExistSrcFlag = false;
	try{
		isExistSrcFlag	=	Boolean.parseBoolean(CommonUtils.getString(request.getParameter("srcFlag")));
	}catch(Exception e){
		isExistSrcFlag = false;
	}
	if(isExistSrcFlag){
        srcFinalProcStatFlagNm = "10";
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){  
   $("#btnAttach1").click(function(){ fnUploadDialog("PPT파일", $("#firstattachseq").val(), "fnCallBackAttach1","5"); });
   $("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2","5"); });
   $("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#thirdattachseq").val(), "fnCallBackAttach3","5"); });
   $("#btnAttach4").click(function(){ fnUploadDialog("첨부파일(SKTS)", $("#fourthattachseq").val(), "fnCallBackAttach4","10"); });
   suggestTargetSelect();
});
/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#firstattachseq").val(rtn_attach_seq);
   $("#attach_file_name1").text(rtn_attach_file_name);
   $("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#secondattachseq").val(rtn_attach_seq);
   $("#attach_file_name2").text(rtn_attach_file_name);
   $("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#thirdattachseq").val(rtn_attach_seq);
   $("#attach_file_name3").text(rtn_attach_file_name);
   $("#attach_file_path3").val(rtn_attach_file_path);
}
/**
 * 첨부파일4 파일관리
 */
function fnCallBackAttach4(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#fourthattachseq").val(rtn_attach_seq);
   $("#attach_file_name4").text(rtn_attach_file_name);
   $("#attach_file_path4").val(rtn_attach_file_path);
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
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {

	$.post
	( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/selectProposalDetailRole.sys',
		{ receiptNum:'' },
		function(arg){
			var userRoleObj = eval('(' + arg + ')').userInfo;
			var final_role = userRoleObj.FINAL_ROLE;
			var is_adm = userRoleObj.IS_ADM;
			if(final_role == "N" && is_adm == "N"){
			   $("#srcSuitableUserNm").attr("disabled",true); 
			   $("#srcAppraisalUserNm").attr("disabled",true); 
			}
		}
	);
	$.post
	( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/selectProposalCntText.sys',
		{ },
		function(arg){
			var cntInfoObj = eval('(' + arg + ')').cntInfo;
			$("#proposalCntText").html("<b>총 "+cntInfoObj.ALL_CNT+"건 : 접수대기 "+cntInfoObj.ACCEPT_WAITING_CNT+ "건, 검토중 "+cntInfoObj.ACCEPT_CNT+"건, 적합 "+cntInfoObj.SUITABLE_Y_CNT+"건, 부적합 "+cntInfoObj.SUITABLE_N_CNT+"건, 채택 "+cntInfoObj.APPR_Y_CNT+"건, 미채택 "+cntInfoObj.APPR_N_CNT+"건 </b> &nbsp;&nbsp;");
		}
	);
	$("#allExcelButton").click(function(){ fnAllExcelPrintDown();});
	$("#srcOrdeIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); } });
	$("#srcButton").click(function(){ 
		$("#srcSuggestTitle").val($.trim($("#srcSuggestTitle").val()));
		$("#srcSuggestName").val($.trim($("#srcSuggestName").val()));
		fnSearch(); 
	});
	$("#regiBtn").click(function(){ // 신규자재 제안 등록화면 열기
		fnOpenDetailView("R");
	});
	$("#excelButton").click(function(){ 
		exportExcel();
	});
	
	$("#question").click( function() { manageManual(); });	//메뉴얼호출
	
	// 날짜 세팅
	$("#srcSuggestStDate").val("<%=srcSuggestStDate%>");
	$("#srcSuggestEndDate").val("<%=srcSuggestEndDate%>");
	
   // 날짜 조회 및 스타일
   $(function(){
   	$("#srcSuggestStDate").datepicker(
          	{
   	   		showOn: "button",
   	   		buttonImage: "/img/system/btn_icon_calendar.gif",
   	   		buttonImageOnly: true,
   	   		dateFormat: "yy-mm-dd"
          	}
   	);
   	$("#srcSuggestEndDate").datepicker(
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
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
      	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/selectProposalList.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['접수번호','처리상태','제안대상','사업자명','사업자번호','제안명','자재유형','제안일','접수일'
		          ,'SKTS검토일','최종평가일','제안자','제안자 연락처','접수자','SKTS검토자','SKTS검토자 연락처','최종평가자'
		          ,'SKTS검토결과','SKTS검토의견','최종평가','최종평가의견','주요내용'
		          ,'FINALPROCSTATFLAG','FILELIST1','FILELIST2','FILELIST3','FILELIST4','SUGGESTPHONE','SUGGESTEMAIL'
		          ,'SUITABLESTAT','APPRAISALSTAT'
		          ,'ATTACH_FILE_NAME1','ATTACH_FILE_NAME2','ATTACH_FILE_NAME3','ATTACH_FILE_NAME4','ATTACH_FILE_PATH1','ATTACH_FILE_PATH2','ATTACH_FILE_PATH3','ATTACH_FILE_PATH4'
		          ,'제안대상 값'
		          ],
		colModel:[
			{name:'RECEIPTNUM',index:'RECEIPTNUM', width:50,align:"center",search:false,sortable:true, editable:false, key:true },//접수번호
			{name:'FINALPROCSTATFLAG_NM',index:'FINALPROCSTATFLAG_NM', width:60,align:"center",search:false,sortable:true, editable:false },//처리상태
			{name:'SUGGESTTARGET',index:'SUGGESTTARGET', width:70,align:"center",search:false, editable:false },//제안대상
			{name:'BUSSINESSNM',index:'BUSSINESSNM', width:150,align:"left",search:false,sortable:true, editable:false },//사업자명
			{name:'BUSINESSNUM',index:'BUSINESSNUM', width:66,align:"center",search:false,sortable:true, editable:false },//사업자번호
			{name:'SUGGESTTITLE',index:'SUGGESTTITLE', width:150,align:"left",search:false,sortable:true, editable:false },//제안명
			{name:'MATERIALTYPE',index:'MATERIALTYPE', width:100,align:"left",search:false,sortable:true, editable:false },//자재유형
			{name:'SUGGESTDATE',index:'SUGGESTDATE', width:70,align:"center",search:false,sortable:true, editable:false },//제안일
			{name:'ACCEPTDATE',index:'ACCEPTDATE', width:70,align:"center",search:false,sortable:true, editable:false },//접수일
			{name:'SUITABLEDATE',index:'SUITABLEDATE', width:70,align:"center",search:false,sortable:true, editable:false },//SKTS검토일
			{name:'APPRAISALDATE',index:'APPRAISALDATE', width:70,align:"center",search:false,sortable:true, editable:false },//최종평가일
			{name:'SUGGESTNAME',index:'SUGGESTNAME', width:60,align:"center",search:false,sortable:true, editable:false },//제안자
			{name:'SUGGESTPHONE',index:'SUGGESTPHONE', width:120,align:"center",search:false,sortable:true, editable:false },//제안자 연락처
			{name:'ACCEPT_USER_NM',index:'ACCEPT_USER_NM', width:60,align:"center",search:false,sortable:true, editable:false },//접수자
			{name:'SUITABLE_USER_NM',index:'SUITABLE_USER_NM', width:80,align:"center",search:false,sortable:true, editable:false },//SKTS검토자
			{name:'SUITABLE_MOBILE',index:'SUITABLE_MOBILE', width:100,align:"center",search:false,sortable:true, editable:false },//SKTS검토자 연락처
			{name:'APPRAISAL_USER_NM',index:'APPRAISAL_USER_NM', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'SUITABLESTAT_NM',index:'SUITABLESTAT_NM', width:90,align:"center",search:false,sortable:true, editable:false },
			{name:'SUITABLECONTENT',index:'SUITABLECONTENT', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'APPRAISALSTAT_NM',index:'APPRAISALSTAT_NM', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'APPRAISALCONTENT',index:'APPRAISALCONTENT', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'SUGGESTCONTENT',index:'SUGGESTCONTENT', width:200,align:"left",search:false,sortable:true, editable:false },
			{name:'FINALPROCSTATFLAG',index:'FINALPROCSTATFLAG',hidden:true, width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'FILELIST1',index:'FILELIST1',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'FILELIST2',index:'FILELIST2',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'FILELIST3',index:'FILELIST3',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'FILELIST4',index:'FILELIST4',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'SUGGESTPHONE',index:'SUGGESTPHONE',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'SUGGESTEMAIL',index:'SUGGESTEMAIL',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'SUITABLESTAT',index:'SUITABLESTAT',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'APPRAISALSTAT',index:'APPRAISALSTAT',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'ATTACH_FILE_NAME1',index:'ATTACH_FILE_NAME1',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'ATTACH_FILE_NAME2',index:'ATTACH_FILE_NAME2',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'ATTACH_FILE_NAME3',index:'ATTACH_FILE_NAME3',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'ATTACH_FILE_NAME4',index:'ATTACH_FILE_NAME4',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'ATTACH_FILE_PATH1',index:'ATTACH_FILE_PATH1',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'ATTACH_FILE_PATH2',index:'ATTACH_FILE_PATH2',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'ATTACH_FILE_PATH3',index:'ATTACH_FILE_PATH3',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'ATTACH_FILE_PATH4',index:'ATTACH_FILE_PATH4',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'SUGGESTTARGETVAL',index:'SUGGESTTARGETVAL',hidden:true, width:70,align:"center",search:false,sortable:true, editable:false }
			
		],  
		postData: {
			srcSuggestStDate:$("#srcSuggestStDate").val(),
			srcSuggestEndDate:$("#srcSuggestEndDate").val(),
			srcFinalProcStatFlagNm : $("#srcFinalProcStatFlagNm").val()
		},
		multiselect:false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		sortname: "RECEIPTNUM", sortorder: "DESC", 
		height: <%=listHeight%>,width:<%=listWidth%>,
// 		caption:"신규자재 제안 리스트", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	
		loadComplete: function() { },
		afterInsertRow: function(rowid, aData){ 
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {SUGGESTPHONE: fnSetTelformat(selrowContent.SUGGESTPHONE)});
			jq("#list").jqGrid('setRowData', rowid, {SUITABLE_MOBILE: fnSetTelformat(selrowContent.SUITABLE_MOBILE)});
		},
		onSelectRow: function (rowid, iRow, iCol, e) { 
			var detailData = jq("#list").jqGrid('getRowData',rowid);
			fnOpenDetailView("D",detailData);
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){ },
		loadError : function(xhr, st, str){ alert("에러가 발생하였습니다."); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>
<script type="text/javascript">
function fnSearch(){
	if($.trim($("#srcSuggestStDate").val()) == ""){ alert("조회시작일을 선택하여주십시오."); return; }
	if($.trim($("#srcSuggestEndDate").val()) == ""){ alert("조회종료일을 선택하여주십시오."); return; }
    jq("#list").jqGrid("setGridParam", {"page":1});
    var data = jq("#list").jqGrid("getGridParam", "postData");
    data.srcSuggestStDate = $("#srcSuggestStDate").val();
    data.srcSuggestEndDate = $("#srcSuggestEndDate").val();
    data.srcSuggestTitle = $("#srcSuggestTitle").val();
    data.srcSuggestName = $("#srcSuggestName").val();
    data.srcSuitableUserNm = $("#srcSuitableUserNm").val();
    data.srcAppraisalUserNm = $("#srcAppraisalUserNm").val();
    data.srcFinalProcStatFlagNm = $("#srcFinalProcStatFlagNm").val();
    data.srcSuggestTarget = $("#srcSuggestTarget").val();
    jq("#list").jqGrid("setGridParam", { "postData": data });
    jq("#list").trigger("reloadGrid");
}

function fnOpenDetailView(flag,selRowContent){
	if(flag == "R"){
		fnProposalDetailDiv("processProposalAfter",flag,new Object());
	}else{
		fnProposalDetailDiv("processProposalAfter",flag,selRowContent);
	}
}

function fnAllExcelPrintDown(){
	var colLabels =['접수번호','처리상태','제안대상','사업자명','사업자번호','제안명','자재유형','제안일','접수일' ,'SKTS검토일','최종평가일','제안자','제안자 연락처','접수자','SKTS검토자','SKTS검토자 연락처','최종평가자' ,'SKTS검토결과','SKTS검토의견','최종평가','최종평가의견','주요내용'];
	var colIds = ['RECEIPTNUM', 'FINALPROCSTATFLAG_NM','SUGGESTTARGET', 'BUSSINESSNM', 'BUSINESSNUM', 'SUGGESTTITLE', 'MATERIALTYPE', 'SUGGESTDATE', 'ACCEPTDATE', 'SUITABLEDATE', 'APPRAISALDATE', 'SUGGESTNAME', 'SUGGESTPHONE', 'ACCEPT_USER_NM', 'SUITABLE_USER_NM', 'SUITABLE_MOBILE','APPRAISAL_USER_NM', 'SUITABLESTAT_NM', 'SUITABLECONTENT', 'APPRAISALSTAT_NM', 'APPRAISALCONTENT', 'SUGGESTCONTENT'];
    var numColIds = [];
    var figureColIds = ['RECEIPTNUM','BUSINESSNUM'];
    var sheetTitle = "자재제안리스트";
    var excelFileName = "proposal";   
    var fieldSearchParamArray = new Array();
    fieldSearchParamArray[0] = 'srcSuggestStDate';
    fieldSearchParamArray[1] = 'srcSuggestEndDate';
    fieldSearchParamArray[2] = 'srcSuggestTitle';
    fieldSearchParamArray[3] = 'srcSuggestName';
    fieldSearchParamArray[4] = 'srcSuitableUserNm';
    fieldSearchParamArray[5] = 'srcAppraisalUserNm';
    fieldSearchParamArray[6] = 'srcFinalProcStatFlagNm';
    fieldSearchParamArray[7] = 'srcSuggestTarget';
	var tmpExcelUrl = "/proposal/selectProposalListExcel.sys";
    fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,tmpExcelUrl, figureColIds);  
}

function exportExcel() {
	var colLabels =['접수번호','처리상태','제안대상','사업자명','사업자번호','제안명','자재유형','제안일','접수일' ,'SKTS검토일','최종평가일','제안자','제안자 연락처','접수자','SKTS검토자','SKTS검토자 연락처','최종평가자' ,'SKTS검토결과','SKTS검토의견','최종평가','최종평가의견','주요내용'];
	var colIds = ['RECEIPTNUM', 'FINALPROCSTATFLAG_NM','SUGGESTTARGET', 'BUSSINESSNM', 'BUSINESSNUM', 'SUGGESTTITLE', 'MATERIALTYPE', 'SUGGESTDATE', 'ACCEPTDATE', 'SUITABLEDATE', 'APPRAISALDATE', 'SUGGESTNAME', 'SUGGESTPHONE', 'ACCEPT_USER_NM', 'SUITABLE_USER_NM', 'SUITABLE_MOBILE','APPRAISAL_USER_NM', 'SUITABLESTAT_NM', 'SUITABLECONTENT', 'APPRAISALSTAT_NM', 'APPRAISALCONTENT', 'SUGGESTCONTENT'];
    var numColIds = [];
	var sheetTitle = "자재제안리스트";	//sheet 타이틀
	var excelFileName = "proposal";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function suggestTargetSelect() {
	$.post(
		"/proposal/suggestTargetSelect.sys",
		function(arg){
			var result = eval("("+arg+")");
			for(var i=0; i<result.list.length;i++){
				$("#suggestTarget").append("<option value="+result.list[i].codeVal1+">"+result.list[i].codeNm1+"</opiton>");
				$("#srcSuggestTarget").append("<option value="+result.list[i].codeVal1+">"+result.list[i].codeNm1+"</opiton>");
			}
			
		}
	);
}
</script>
<script type="text/javascript">
function manageManual(){
	var header = "신규 자재 제안하기";
	var manualPath = "";
	var popUrl = "";
	<%if(isClient || isVendor){%>
		//구매사, 공급사 공용 화면임
		manualPath = "/img/manual/branch/viewProposalList.jpg";
		popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	<%}else{%>
		//매니저권한관련이라당장은 주석처리
		//manualPath = "/img/manageManual/viewProposalListManual.JPG";
		//popUrl = "/manage/manageManual.sys?header="+header+"&manualPath="+manualPath;
	<%}%>
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>

<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
		<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="1500px" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top" style="height: 29px">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td class='ptitle'>신규자재제안
							<%if(isClient || isVendor){%>
								&nbsp;<img src=/img/system/btn_icon_search.gif id="question" style="cursor: pointer"/>
							<%}%>
							</td>
							<td align="right" class='ptitle'>
								<button id='allExcelButton' class="btn btn-success btn-sm" ><i class="fa fa-file-excel-o"></i> 엑셀</button>
								<button id='srcButton' class="btn btn-default btn-sm" ><i class="fa fa-search"></i> 조회</button>
<!--                                 <img id="allExcelButton" src="/img/system/btn_type3_orderResultExcel.gif" width="130" height="22" style="cursor:pointer;"/> -->
<!--                                 <img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style="cursor: pointer;"/> -->
                            </td>
						</tr>
						<tr style="height: 3px;"><td></td></tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="1500px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr> 
						<tr>
							<td class="table_td_subject" width="100">제안일자</td>
							<td class="table_td_contents">
                              <input type="text" name="srcSuggestStDate" id="srcSuggestStDate" style="width: 75px;vertical-align: middle;" /> 
                              ~ 
                              <input type="text" name="srcSuggestEndDate" id="srcSuggestEndDate" style="width: 75px;vertical-align: middle;" />
                            </td>
							<td width="100" class="table_td_subject">제안명</td>
							<td class="table_td_contents">
								<input id="srcSuggestTitle" name="srcSuggestTitle" type="text" value="" size="" maxlength="50" style="width: 100px" />
                            </td>
							<td width="100" class="table_td_subject">제안자</td>
							<td class="table_td_contents">
								<input id="srcSuggestName" name="srcSuggestName" type="text" value="" size="" maxlength="50" style="width: 100px" />
							</td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td width="100" class="table_td_subject">SKTS검토자</td>
							<td class="table_td_contents">
								<select id="srcSuitableUserNm" class="select">
									<option value="">선택</option>
<%
if(b2bAdmList.size() > 0){
	for(Map<String, Object> admMap : b2bAdmList){
%>
									<option value="<%=admMap.get("USERID").toString()%>"><%=admMap.get("USERNM").toString() %></option>
<%
	}
}
%>
								</select>
							</td>
							<td width="100" class="table_td_subject">최종평가자</td>
							<td class="table_td_contents">
								<select id="srcAppraisalUserNm" class="select">
									<option value="">선택</option>
<%
if(finalUserList.size() > 0){
	for(Map<String, Object> finalMap : finalUserList){
%>
									<option value="<%=finalMap.get("USERID").toString()%>"><%=finalMap.get("USERNM").toString() %></option>
<%
	}
}
%>
								</select>
                            </td>
							<td width="100" class="table_td_subject">처리상태</td>
							<td class="table_td_contents">
								<select id="srcFinalProcStatFlagNm" class="select">
									<option value="">전체</option>
<%
if(codeList.size() > 0){
	for(Map<String, Object> codeMap : codeList){
%>
									<option value="<%=codeMap.get("CODE_VAL")%>" <%if(srcFinalProcStatFlagNm.equals(codeMap.get("CODE_VAL"))){ %>selected="selected" <%} %>><%=codeMap.get("CODE_NM")%></option>
<%
	}
}
%>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td width="100" class="table_td_subject">
								제안대상
							</td>
							<td class="table_td_contents">
								<select id="srcSuggestTarget" name="srcSuggestTarget" class="select" style="width:80px;">
									<option value="">선택</option>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table>
				</td>
	 		</tr>
	 		<tr><td height="5"></td></tr>
			<tr>
				<td>
				<table width="1500px" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left"><b> * 처리 Process : <font color="red">접수대기 > 검토중 > 적합,부적합 > 채택,미채택</font></b></td>
						<td align="right">
							<span id="proposalCntText"></span>
						</td>
						<td align="right" style="width:110px">
							<button id='regiBtn' class="btn btn-primary btn-xs" ><i class="fa fa-file-o"></i> 제안하기</button>
<%-- 							<a href="#;"><img id="regiBtn" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_write.gif" width="85" height="23" style='border:0;' /></a> --%>
<%-- 							<a href="#;"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;' /></a> --%>
						</td>
					</tr>
					<tr style="height: 1px;"><td></td></tr>
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
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<%@ include file="/WEB-INF/jsp/proposal/svcProposalDetailDiv.jsp" %>
<%@ include file="/WEB-INF/jsp/common/attachFileDivForProporsal.jsp" %>
</form>
</body>
</html>