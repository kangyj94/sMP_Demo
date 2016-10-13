<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-400 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	// 날짜 세팅
	String srcReqStartDate	= CommonUtils.getCustomDay("YEAR", -1);
	String srcReqEndDate 	= CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<script type="text/javascript">
//////////////////////////////		초기화		/////////////////////////////////
var jq = jQuery;
$(document).ready(function(){
    // 날짜 세팅
    $("#srcReqStartDate").val("<%=srcReqStartDate%>");
    $("#srcReqEndDate").val("<%=srcReqEndDate%>");

    // 날짜 조회 및 스타일
    $(function(){
        $("#srcReqStartDate").datepicker( {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        });
        $("#srcReqEndDate").datepicker( {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        });
        $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
    });
	$("#srcButton").click(function(){fnSearch();});//Dialog 닫기
    
	// BMT 화면 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#bmtFinal').jqm();	//Dialog 초기화
	$('#bmtFinal').jqm().jqDrag('#processDialogHandle'); 
	$("#btmClsBtn, .jqmClose").click(function(){$("#bmtFinal").jqmHide();});//Dialog 닫기
	$("#btmAppBtn").click(function(){ fnBmtApproval('A'); });
	$("#btmRtnBtn").click(function(){ fnBmtApproval('R'); });	
	
	// 품질관리 화면 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#qualityChk').jqm();	//Dialog 초기화
	$('#qualityChk').jqm().jqDrag('#processDialogHandle'); 
	$("#qualityClsBtn, .jqmClose").click(function(){	$("#qualityChk").jqmHide(); });//Dialog 닫기
	$('#qualityAppBtn').click(function (e) { fnQualityApproval('A'); });
	$('#qualityRtnBtn').click(function (e) { fnQualityApproval('R'); });
	
	// VOC 화면 초기화  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	$('#vocReg').jqm();	//Dialog 초기화
	$('#vocReg').jqm().jqDrag('#vocProcDialogHandle'); 
	$("#vocClsBtn, .jqmClose").click(function(){	$("#vocReg").jqmHide(); });//Dialog 닫기
	$('#vocAppBtn').click(function (e) { fnVocApproval('A'); });
	$('#vocRtnBtn').click(function (e) { fnVocApproval('R'); });
	
	
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
	
});
</script>

<script type="text/javascript">
//////////////////////////////		리사이징		/////////////////////////////////
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>
<script type="text/javascript">
//////////////////////////////		JqGrid		/////////////////////////////////
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/selectQualityApprovalList/list.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:[ 	'APPTYPECD','결재유형',	'소싱명',		'규격',			'공급사',	'품목유형1',	'품목유형2',	'요청',		'결재자',	
		           	'처리',		'APPSTEP', 		'CURRSTEP',		'APPKIND1',	'APPKIND2', 'APPNM1', 	'APPNM2', 	'SOURCINGID',	'BUSINESSNUM',	
		           	'QUALITYID','QUALITYYYYY',	'QUALITY_KIND',	'APPKEY'			],
		colModel:[
			{name:'APPTYPECD'		,index:'APPTYPECD'		, width:80,align:"center",search:false,sortable:false, editable:false, hidden:true },
			{name:'APPTYPE'			,index:'APPTYPE'		, width:80,align:"center",search:false,sortable:false, editable:false },
			{name:'SOURCINGNM'		,index:'SOURCINGNM'		, width:150,align:"left",search:false,sortable:false, editable:false },
			{name:'SPEC'			,index:'SPEC'			, width:180,align:"left",search:false,sortable:false, editable:false },
			{name:'BUSSINESSNM'		,index:'BUSSINESSNM'	, width:150,align:"left",search:false,sortable:false, editable:false },
			{name:'PRODTYPE1_NM'	,index:'PRODTYPE1_NM'	, width:80,align:"center",search:false,sortable:false, editable:false },
			{name:'PRODTYPE2_NM'	,index:'PRODTYPE2_NM'	, width:80,align:"center",search:false,sortable:false, editable:false },
			{name:'REQNM'			,index:'REQNM'			, width:140,align:"center",search:false,sortable:false, editable:false },
			{name:'APPNM'			,index:'APPNM'			, width:180,align:"center",search:false,sortable:false, editable:false },
			{name:'REQKIND'			,index:'REQKIND'		, width:100,align:"center",search:false,sortable:false, editable:false },
			{name:'APPSTEP'			,index:'APPSTEP'		, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'CURRSTEP'		,index:'CURRSTEP'		, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'APPKIND1'		,index:'APPKIND1'		, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'APPKIND2'		,index:'APPKIND2'		, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'APPNM1'			,index:'APPNM1'			, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'APPNM2'			,index:'APPNM2'			, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'SOURCINGID'		,index:'SOURCINGID'		, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'BUSINESSNUM'		,index:'BUSINESSNUM'	, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'QUALITYID'		,index:'QUALITYID'		, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'QUALITYYYYY'		,index:'QUALITYYYYY'	, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'QUALITY_KIND'	,index:'QUALITY_KIND'	, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true },
			{name:'APPKEY'			,index:'APPKEY'			, width:100,align:"left",search:false,sortable:false, editable:false, hidden:true }
		],  
		postData: {
			srcApprType:$('#srcApprType').val()
			,srcReqStartDate:$('#srcReqStartDate').val()
			,srcReqEndDate:$('#srcReqEndDate').val()
			,srcAppr:$('#srcAppr').val()
			,userId:$('#userId').val()
		},
		multiselect:false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	
		loadComplete: function() { },
		afterInsertRow: function(rowid, aData){
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
        	var sText = "";
        	$(this).setCell(rowid, 'APPTYPECD', selrowContent.APPTYPE);
        	
        	if($.trim(selrowContent.APPTYPE) == '10'){
        		sText = "BMT";
        	}else if($.trim(selrowContent.APPTYPE) == '20'){
        		sText = "품질검사/실사";
        	}else if($.trim(selrowContent.APPTYPE) == '30'){
        		sText = "VOC";
        	}
            
            var sText2 	= "";
            var color	= "";
            var color2 	= "";
            if($.trim(selrowContent.APPKIND1) == '')		color = "#aaaaaa";
            else if($.trim(selrowContent.APPKIND1) == '10')	color = "green";
            else if($.trim(selrowContent.APPKIND1) == '20')	color = "#ff0000";

            sText2 = "<font color='"+color+"'>"+selrowContent.APPNM1+"</font>";	
            
            if($.trim(selrowContent.APPNM2) != ''){
                if($.trim(selrowContent.APPKIND2) == '')		color2 = "#aaaaaa";
                else if($.trim(selrowContent.APPKIND2) == '10')	color2 = "green";
                else if($.trim(selrowContent.APPKIND2) == '20')	color2 = "#ff0000";
	            
            	sText2 += " > "+"<font color='"+color2+"'>"+selrowContent.APPNM2+"</font>";	
            }
            
            var sText3 = "";
            var reqKind = $.trim(selrowContent.REQKIND);
            var currStep = $.trim(selrowContent.CURRSTEP);
            if( currStep != 'E' ){
            	if($.trim(selrowContent.APPTYPE) == '10'){
	            	sText3 = "<button type='button' onclick=\"javascript:fnBmtApprovalPop('"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"','"+selrowContent.CURRSTEP+"');\" class='btn btn-primary btn-xs'>결재</button>"
            	}else if($.trim(selrowContent.APPTYPE) == '20'){
	            	sText3 = "<button type='button' onclick=\"javascript:fnQualityApprovalPop('"+selrowContent.QUALITY_KIND+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"','"+selrowContent.CURRSTEP+"');\" class='btn btn-primary btn-xs'>결재</button>"
            	}else if($.trim(selrowContent.APPTYPE) == '30'){
            		sText3 = "<button type='button' onclick=\"javascript:fnVocApprovalPop('"+selrowContent.APPKEY+"','"+selrowContent.CURRSTEP+"');\" class='btn btn-primary btn-xs'>결재</button>"
            	}
            }else{
            	if($.trim(selrowContent.APPTYPE) == '10'){
            		if(reqKind == '90' || reqKind == '99'){ //승인
	            		sText3 = "<a href='#' onclick=\"javascript:fnBmtApprovalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"','"+selrowContent.CURRSTEP+"');\" ><font color='green' style=\"text-decoration:underline;\">승인</font></a>";
            		}else if(reqKind == '20' || reqKind == '29'){ //반려
            			sText3 = "<a href='#' onclick=\"javascript:fnBmtApprovalPop('"+selrowContent.SOURCINGID+"', '"+selrowContent.BUSINESSNUM+"','"+selrowContent.CURRSTEP+"');\" ><font color='red' style=\"text-decoration:underline;\">반려</font></a>";
            		}
            	}else if($.trim(selrowContent.APPTYPE) == '20'){
            		if(reqKind == '90' || reqKind == '99'){ //승인
            			sText3 = "<a href='#' onclick=\"javascript:fnQualityApprovalPop('"+selrowContent.QUALITY_KIND+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"','"+selrowContent.CURRSTEP+"');\"><font color='green' style=\"text-decoration:underline;\">승인</font></a>"
            		}else if(reqKind == '20' || reqKind == '29'){ //반려
            			sText3 = "<a href='#' onclick=\"javascript:fnQualityApprovalPop('"+selrowContent.QUALITY_KIND+"','"+selrowContent.QUALITYID+"','"+selrowContent.QUALITYYYYY+"','"+selrowContent.SOURCINGID+"','"+selrowContent.BUSINESSNUM+"','"+selrowContent.CURRSTEP+"');\"><font color='red' style=\"text-decoration:underline;\">반려</font></a>"
            		}
            	}else if($.trim(selrowContent.APPTYPE) == '30'){
            		if(reqKind == '90'){ //승인
            			sText3 = "<a href='#' onclick=\"javascript:fnVocApprovalPop('"+selrowContent.APPKEY+"','"+selrowContent.CURRSTEP+"');\"><font color='green' style=\"text-decoration:underline;\">승인</font></a>"
            		}else if(reqKind == '20'){ //반려
            			sText3 = "<a href='#' onclick=\"javascript:fnVocApprovalPop('"+selrowContent.APPKEY+"','"+selrowContent.CURRSTEP+"');\"><font color='red' style=\"text-decoration:underline;\">반려</font></a>"
            		}
            	}
            }
            
            $(this).setCell(rowid, 'APPTYPE', sText);
            $(this).setCell(rowid, 'APPNM'	, sText2);
            $(this).setCell(rowid, 'REQKIND', sText3);
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){ },
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<script type="text/javascript">
//////////////////////////////		화면 기능		/////////////////////////////////

function fnSearch() {
    $("#list")
    .jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()})
    .trigger("reloadGrid");
}

function fnBmtApprovalPop(sid,bnum, cStep){
    $("#spanBmtFinalSourcingNm").html("");
    $("#spanBtmFinalDivSpec").html("");
    $("#spanBtmFinalItem1").html("");
    $("#spanBtmFinalItem2").html("");
    $("#spanBtmFinalS").html("");
    $("#spanBtmFinalP").html("");
    $("#btmFinalLabTest").html("");
    $("#btmFinalFieldTest").html("");
    $("#final_file_seq1").val("");
    $("#final_file1").html("");
    $("#bmtFinal_appKind1").html("");
    $("#bmtFinal_appKind2").html("");
    
    
	$.blockUI();
	$.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/selectSourcingLabFieldInfo/detailObj/object.sys",
        {
        	sourcingid:sid
        	,businessnum:bnum
        },
        function(arg){
			var resultMap = eval('(' + arg + ')').detailObj;
			
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
            
            if($.trim(resultMap.FINAL_GRADEFILE_PATH) != "" && $.trim(resultMap.FINAL_GRADEFILE_NAME) != "" ){
                var tempPFileNm = "<a href=\"javascript:fnAttachFileDownload('"+resultMap.FINAL_GRADEFILE_PATH+"')\"><font color='#0000ff'>"+resultMap.FINAL_GRADEFILE_NAME+"</font></a>";
                $("#final_file1").html(tempPFileNm);
                $("#final_file_seq1").val(resultMap.FINAL_GRADEFILE);
            }
            $("#bmtSourcingId").val(resultMap.SOURCINGID);
            $("#bmtBusinissnum").val(resultMap.BUSINESSNUM);
            
            $("#bmt1stApprUserId").val(resultMap.FINAL_APPID1);
            $("#bmt1stApprUserNm").val(resultMap.FINAL_APPID1_NM);
            $("#bmt2ndApprUserId").val(resultMap.FINAL_APPID2);
            $("#bmt2ndApprUserNm").val(resultMap.FINAL_APPID2_NM);
            $("#bmtFinal_appKind1").html(resultMap.FINAL_APPKIND1_NM);
            $("#bmtFinal_appKind2").html(resultMap.FINAL_APPKIND2_NM);
//             $("#bmtFinal_appcomment1").prop("readonly",true);
//             $("#bmtFinal_appcomment2").prop("readonly",true);
            $("#bmtFinal_appcomment1").val(resultMap.FINAL_APPCOMMENT1);
            $("#bmtFinal_appcomment2").val(resultMap.FINAL_APPCOMMENT2);
            
           	$("#bmtFinalYn").val(resultMap.FINAL_YN);
           	$("#bmtAppStep").val(cStep);
           	
            if($.trim($("#bmt2ndApprUserNm").val()) == ''){
	            $("#bmtIsLastAppr").val("Y");
            }else{
                if($.trim(resultMap.FINAL_APPKIND1_NM) == ''){
                	$("#bmtIsLastAppr").val('N');
                }else{
                	$("#bmtIsLastAppr").val('Y');
                }
            }
            
            if('E' == cStep){
            	$("#btmAppBtn").hide();
            	$("#btmRtnBtn").hide();
            }else{
            	$("#btmAppBtn").show();
            	$("#btmRtnBtn").show();
            }
            
            var userId = '<%=loginUserDto.getUserId()%>';
            
            if(cStep == '1'){
            	if($.trim($("#bmt1stApprUserId").val()) != userId){
                	$("#btmAppBtn").hide();
                	$("#btmRtnBtn").hide();            		
            	}else{
                	$("#btmAppBtn").show();
                	$("#btmRtnBtn").show();            		
            	}
            }else if(cStep == '2'){
            	if($.trim($("#bmt2ndApprUserId").val()) != userId){
                	$("#btmAppBtn").hide();
                	$("#btmRtnBtn").hide();            		
            	}else{
                	$("#btmAppBtn").show();
                	$("#btmRtnBtn").show();            		
            	}
            }
            
            $("#bmtFinal").jqmShow();
            $.unblockUI();
        }
	);
}

function fnBmtApproval(kind){
	var confirmTxt = "";
	
	if('A' == kind){
		confirmTxt = "승인하시겠습니까?";	
	}else{
		confirmTxt = "반려하시겠습니까?";	
	}
	
	if(!confirm(confirmTxt))return;
	
	var bmtFinalYn 		= $("#bmtFinalYn").val();
	var bmtAppStep 		= $("#bmtAppStep").val();
	var bmtIsLastAppr 	= $("#bmtIsLastAppr").val();
	var bmtSourcingId 	= $("#bmtSourcingId").val();
	var bmtBusinissnum 	= $("#bmtBusinissnum").val();
	
	var bmtFinalAppcomment1 	= $("#bmtFinal_appcomment1").val();
	var bmtFinalAppcomment2 	= $("#bmtFinal_appcomment2").val();
	var bmt2ndApprUserId		= $("#bmt2ndApprUserId").val();
	
	$.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/setSourcingApproval.sys",
        {
        	kind:kind,
        	sourcingId:bmtSourcingId, 
        	businessNum:bmtBusinissnum,
        	appStep:bmtAppStep,
        	finalYn:bmtFinalYn,
        	isLastAppr:bmtIsLastAppr,
        	bmtFinalAppcomment1:bmtFinalAppcomment1,
        	bmtFinalAppcomment2:bmtFinalAppcomment2,
        	bmt2ndApprUserId:bmt2ndApprUserId
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
                $("#bmtFinal").jqmHide();
                fnSearch();
            }
        }
	);	
}


function fnQualityApprovalPop(kind,qualityid,qualityyyyy,sourcingid,businessnum,cStep){
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
            
            $("#qualitydateQualityChk").val(resultMap.QUALITYDATE);
            
            $(".qualityCheck_yn").each(function(index){
                if($(this).val() == $.trim(resultMap.QUALITYYN)){
                    $(this).prop("checked",true);
                }
            });
            
            var chkVal = $("input:radio[name='qualityCheck_yn']:checked").val();  
            
            if(chkVal == '90')		$("#qualityCheck_td").html("<font color='green'>적합</font>");	
            else if(chkVal == '99')	$("#qualityCheck_td").html("<font color='red'>부적합</font>")
            
            $("#qualityYn").val(chkVal);
            
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
            $("#quality_part_seq").val(resultMap.QUALITY_PART_SEQ);
            $("#quality_mst_sourcintId").val(resultMap.SOURCINGID);
            $("#quality_mst_businissnum").val(resultMap.BUSINESSNUM);
            $("#quality_mst_qualityid").val(resultMap.QUALITYID);
            $("#quality_mst_qualityyyyy").val(resultMap.QUALITYYYYY);
            $("#purposeQualityChk").val(resultMap.PURPOSE);
            $("#quality1stApprUserId").val(resultMap.APPID1);
            $("#quality1stApprUserNm").val(resultMap.APPID1_NM);
            $("#quality2ndApprUserId").val(resultMap.APPID2);
            $("#quality2ndApprUserNm").val(resultMap.APPID2_NM);
            $("#qualitychk_qualitydesc").val(resultMap.QUALITYDESC);
            $("#qualityChk_appcomment1").val(resultMap.APPCOMMENT1);
            $("#qualityChk_appcomment2").val(resultMap.APPCOMMENT2);
            
            
            $("#qualityChk_appKind1").html(resultMap.APPKIND1_NM);
            $("#qualityChk_appKind2").html(resultMap.APPKIND2_NM);
//             $("#qualityChk_appcomment1").prop("readonly",true);
//             $("#qualityChk_appcomment2").prop("readonly",true);
            
            $("#qualityAppStep").val(cStep);
            
            if($.trim($("#quality2ndApprUserNm").val()) == ''){
	            $("#qualityIsLastAppr").val("Y");
            }else{
                if($.trim(resultMap.APPKIND1_NM) == ''){
                	$("#qualityIsLastAppr").val('N');
                }else{
                	$("#qualityIsLastAppr").val('Y');
                }
            }
            
            if('E' == cStep){
            	$("#qualityAppBtn").hide();
            	$("#qualityRtnBtn").hide();
            }else{
            	$("#qualityAppBtn").show();
            	$("#qualityRtnBtn").show();
            }
            
            var userId = '<%=loginUserDto.getUserId()%>';
            
            if(cStep == '1'){
            	if($.trim($("#quality1stApprUserId").val()) != userId){
                	$("#qualityAppBtn").hide();
                	$("#qualityRtnBtn").hide();            		
            	}else{
                	$("#qualityAppBtn").show();
                	$("#qualityRtnBtn").show();            		
            	}
            }else if(cStep == '2'){
            	if($.trim($("#quality2ndApprUserId").val()) != userId){
                	$("#qualityAppBtn").hide();
                	$("#qualityRtnBtn").hide();            		
            	}else{
                	$("#qualityAppBtn").show();
                	$("#qualityRtnBtn").show();            		
            	}
            }
            
            
//             if(!resultMap.REQKIND){
//                 $("#qualityAppBtn").show();
//                 $("#qualityRtnBtn").show();
//             }else if(resultMap.REQKIND == "0"){
//                 $("#qualityAppBtn").hide();
//                 $("#qualityRtnBtn").show();
//             }else{
//                 $("#qualityAppBtn").hide();
//                 $("#qualityRtnBtn").hide();
//                 $("#qualityChk_1stUserDeleteBtn").hide();
//                 $("#qualityChk_2ndUserDeleteBtn").hide();
//                 $("#qualityChk_1stUserBtn").hide();
//                 $("#qualityChk_2ndUserBtn").hide();
//             }
            $("#qualityChk").jqmShow();
            
            $.unblockUI();
        }
	);
}



function fnQualityApproval(kind){
	var confirmTxt = "";
	
	if('A' == kind){
		confirmTxt = "승인하시겠습니까?";	
	}else{
		confirmTxt = "반려하시겠습니까?";	
	}
	
	if(!confirm(confirmTxt))return;
	
	var qualityYn 			= $("#qualityYn").val();
	var qualityPartSeq 		= $("#quality_part_seq").val();
	var qualityAppStep 		= $("#qualityAppStep").val();
	var qualityIsLastAppr 	= $("#qualityIsLastAppr").val();
	
	var qualityChkAppcomment1 = $("#qualityChk_appcomment1").val();
	var qualityChkAppcomment2 = $("#qualityChk_appcomment2").val();
	var quality2ndApprUserId  = $("#quality2ndApprUserId").val();
	
	$.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/setQualityApproval.sys",
        {
        	kind:kind,
        	qualityPartSeq:qualityPartSeq, 
        	appStep:qualityAppStep,
        	qualityYn:qualityYn,
        	isLastAppr:qualityIsLastAppr,
        	qualityChkAppcomment1:qualityChkAppcomment1,
        	qualityChkAppcomment2:qualityChkAppcomment2,
        	quality2ndApprUserId:quality2ndApprUserId
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
                $("#qualityChk").jqmHide();
                fnSearch();
            }
        }
	);	
}

function fnSetTreatResult(kind){
	if(kind == '20'){
		$("#vocTempButton").show();
		$("#vocSaveButton").hide();
	}else {
		$("#vocTempButton").hide();
		$("#vocSaveButton").show();
	}
}

function fnVocApprovalPop(vocId, cStep){
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
            vocid:vocId
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
            if($.trim(resultMap.REQFILE1_NAME) != "" && $.trim(resultMap.REQFILE1_PATH) != "" ){
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
            
            $(".vocProc_treatresult").each(function(index){
            	var treatResult = $.trim(resultMap.TREATRESULT) == '10' ? '20' : $.trim(resultMap.TREATRESULT); 
            	
                if($(this).val() == treatResult){
                    $(this).prop("checked",true);
                }
                
                if(treatResult == '30' || treatResult == '40'){
            		$("#vocAppBtn").hide();
            		$("#vocRtnBtn").hide();
                	$("#vocProc_treatresult_30").prop("checked",true);
                }else if(treatResult == '99') {
            		$("#vocAppBtn").hide();
            		$("#vocRtnBtn").hide();
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
           
            $("#1stVocUserNm").val(resultMap.APPNM1);
            $("#1stVocUserId").val(resultMap.APPID1);
            $("#voc_appcomment1").val(resultMap.APPCOMMENT1);
            
            $("#2ndVocUserNm").val(resultMap.APPNM2);
            $("#2ndVocUserId").val(resultMap.APPID2);
            $("#voc_appcomment2").val(resultMap.APPCOMMENT2);
            
            $("#vocAppStep").val(cStep);
            
            if($.trim($("#2ndVocUserNm").val()) == ''){
	            $("#vocIsLastAppr").val("Y");
            }else{
                if($.trim(resultMap.APPKIND1_NM) == ''){
                	$("#vocIsLastAppr").val('N');
                }else{
                	$("#vocIsLastAppr").val('Y');
                }
            }
            
            if('E' == cStep){
            	$("#vocAppBtn").hide();
            	$("#vocRtnBtn").hide();
            }else{
            	$("#vocAppBtn").show();
            	$("#vocRtnBtn").show();
            }
            
            var userId = '<%=loginUserDto.getUserId()%>';
            
            if(cStep == '1'){
            	if($.trim($("#1stVocUserId").val()) != userId){
                	$("#vocAppBtn").hide();
                	$("#vocRtnBtn").hide();            		
            	}else{
                	$("#vocAppBtn").show();
                	$("#vocRtnBtn").show();            		
            	}
            }else if(cStep == '2'){
            	if($.trim($("#2ndVocUserId").val()) != userId){
                	$("#vocAppBtn").hide();
                	$("#vocRtnBtn").hide();            		
            	}else{
                	$("#vocAppBtn").show();
                	$("#vocRtnBtn").show();            		
            	}
            }            
            
            var appStr1 = fnGetString(resultMap.APPKIND1_NM) == '' ? '' : fnGetString(resultMap.APPKIND1_NM) + (fnGetString(resultMap.APPDATE1) == '' ? '' : ' ('+resultMap.APPDATE1+')');
            var appStr2 = fnGetString(resultMap.APPKIND2_NM) == '' ? '' : fnGetString(resultMap.APPKIND2_NM) + (fnGetString(resultMap.APPDATE2) == '' ? '' : ' ('+resultMap.APPDATE2+')');
            
            $("#voc_appKind1").html(appStr1);
            $("#voc_appKind2").html(appStr2);
            
            $("#vocReg").jqmShow();
            $.unblockUI();
        }
    );
}


function fnVocApproval(kind){
	var confirmTxt = "";
	
	if('A' == kind){
		confirmTxt = "승인하시겠습니까?";	
	}else{
		confirmTxt = "반려하시겠습니까?";	
	}
	
	if(!confirm(confirmTxt))return;
	
	var vocId 			= $("#vocProc_vocid").val();
	var vocAppStep 		= $("#vocAppStep").val();
	var vocIsLastAppr 	= $("#vocIsLastAppr").val();
	
	var vocAppcomment1 	= $("#voc_appcomment1").val();
	var vocAppcomment2 	= $("#voc_appcomment2").val();
	var vocUserId 		= $("#2ndVocUserId").val();
	
	
	$.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/setVocApproval.sys",
        {
        	kind:kind,
        	vocId:vocId,
        	appStep:vocAppStep,
        	isLastAppr:vocIsLastAppr,
        	vocAppcomment1:vocAppcomment1,
        	vocAppcomment2:vocAppcomment2,
        	vocUserId:vocUserId
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
                $("#vocReg").jqmHide();
                fnSearch();
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

</script>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frmSearch" name="frmSearch" onsubmit="return false;">
		<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
						<tr valign="top" style="height: 29px">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td class='ptitle'>품질관리 결재
							</td>
							<td align="right" class='ptitle'>
								<button id='allExcelButton' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 일괄엑셀</button>
								<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
									<i class="fa fa-search"></i> 조회
								</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td height="1"></td></tr>
			<tr>
				<td>
					<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr> 
						<tr>
							<td class="table_td_subject" width="100">결재유형</td>
							<td class="table_td_contents">
								<input type="hidden" name="userId" id="userId" value="<%=loginUserDto.getUserId() %>" /> 
								<select id="srcApprType" name="srcApprType">
									<option value="">전체</option>
									<option value="10">BMT</option>
									<option value="20">품질관리/실사</option>
									<option value="30">VOC</option>
								</select>
							</td>
							<td width="100" class="table_td_subject">요청일</td>
							<td class="table_td_contents">
								<input type="text" name="srcReqStartDate" id="srcReqStartDate" style="width: 75px;vertical-align: middle;" /> 
								~ 
								<input type="text" name="srcReqEndDate" id="srcReqEndDate" style="width: 75px;vertical-align: middle;" />
							</td>
							<td width="100" class="table_td_subject">결재처리</td>
							<td class="table_td_contents">
								<select id="srcAppr" name="srcAppr">
									<option value="">전체</option>
									<option value="Y" selected="selected">예</option>
									<option value="N">아니오</option>
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

.bmtWindow.bmtFinal {
	top: 25%;
    left: 30%;
    width: 700px;
}

.bmtWindow.qualityChk {
	top: 25%;
    left: 30%;
    width: 700px;
}

.bmtWindow.vocReg {
	top: 15%;
    left: 30%;
    width: 700px;
}

.jqmOverlay { background-color: #000; }

* html .bmtWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<div class="bmtWindow bmtFinal" id="bmtFinal">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="processDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>BMT 결재</h1>
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
										<input type="hidden" id="bmtAppStep" value=""/>
										<input type="hidden" id="bmtIsLastAppr" value=""/>
										<input type="hidden" id="bmtFinalYn" value=""/>
										<input type="hidden" id="bmtSourcingId" value=""/>
										<input type="hidden" id="bmtBusinissnum" value=""/>
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
									<td class="table_td_subject">품질기준</td>
									<td class="table_td_contents"><span id="spanBtmFinalItem2"></span></td>
									<td class="table_td_subject">공급사</td>
									<td class="table_td_contents"><span id="spanBtmFinalVendorNm"></span></td>
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
									<td class="table_td_subject">성적서</td>
									<td class="table_td_contents" colspan="3">
										<input type="hidden" id="final_file_seq1" value=""/>
										<span id="final_file1"></span>
									</td>
								</tr>                               
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">Lab Test</td>
									<td class="table_td_contents"><span id="btmFinalLabTest"></span></td>
									<td class="table_td_subject">Field Test</td>
									<td class="table_td_contents"><span id="btmFinalFieldTest"></span></td>
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
										<input type="text" id="bmt1stApprUserNm" value="" readonly="readonly"/>
										<input type="hidden" id="bmt1stApprUserId" value=""/>
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
										<input type="text" id="bmt2ndApprUserNm" value="" readonly="readonly"/>
										<input type="hidden" id="bmt2ndApprUserId" value=""/>
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
										<button id="btmAppBtn" type="button" class="btn btn-success btn-sm"><i class="fa fa-close"></i>승인</button>
										<button id="btmRtnBtn" type="button" class="btn btn-danger btn-sm"><i class="fa fa-close"></i>반려</button>
										<button id="btmClsBtn" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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
		        				<h2>품질 검사/실사 결재</h1>
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
										<input type="hidden" id="quality_part_seq" value=""/>
										<input type="hidden" id="qualityAppStep" value=""/>
										<input type="hidden" id="qualityIsLastAppr" value=""/>
										<input type="hidden" id="qualityYn" value=""/>
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
										<input type="text" id="purposeQualityChk" value="" style="width: 80%" readonly="readonly"/>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">적합여부</td>
									<td class="table_td_contents" id="qualityCheck_td">
										<label for="qualityCheck_yn90"><input type="radio" class="qualityCheck_yn" name="qualityCheck_yn" id="qualityCheck_yn90" value="90"/>적합</label>
										<label for="qualityCheck_yn99"><input type="radio" class="qualityCheck_yn" name="qualityCheck_yn" id="qualityCheck_yn99" value="99"/>부적합</label>
									</td>
									<td class="table_td_subject">품질검사일</td>
									<td class="table_td_contents">
										<input type="text" id="qualitydateQualityChk" value=""  size="12" readonly="readonly"/>
									</td>
								</tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>
								<tr>
									<td class="table_td_subject">결과보고서</td>
									<td class="table_td_contents">
										<input type="hidden" id="quality_file_seq2" value=""/>
										<span id="quality_file2"></span>
									</td>
									<td class="table_td_subject">성적서</td>
									<td class="table_td_contents">
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
										<textarea rows="2" cols="10" style="width:80%; height: 30px;margin-bottom: 3px;margin-top: 3px;" id="qualitychk_qualitydesc" readonly="readonly"></textarea>
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
										<input type="text" id="quality1stApprUserNm" value="" readonly="readonly"/>
										<input type="hidden" id="quality1stApprUserId" value=""/>
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
										<input type="text" id="quality2ndApprUserNm" value="" readonly="readonly"/>
										<input type="hidden" id="quality2ndApprUserId" value=""/>
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
										<button id="qualityAppBtn" type="button" class="btn btn-success btn-sm"><i class="fa fa-close"></i>승인</button>
										<button id="qualityRtnBtn" type="button" class="btn btn-danger btn-sm"><i class="fa fa-close"></i>반려</button>
										<button id="qualityClsBtn" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
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


<div class="bmtWindow vocReg" id="vocReg">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td bgcolor="#FFFFFF">
				<div id="vocProcDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>품질 VOC 결재</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" onclick="javascript:$('#vocReg').jqmHide();">
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
                                                    <input type="hidden" id="vocAppStep" 	name="vocAppStep"/>
                                                    <input type="hidden" id="vocIsLastAppr" name="vocIsLastAppr"/>
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
										<label for="vocProc_treatresult_20"><input type="radio" class="vocProc_treatresult" name="vocProc_treatresult" id="vocProc_treatresult_20" value="20" disabled="disabled" />처리 중</label>
										<label for="vocProc_treatresult_30"><input type="radio" class="vocProc_treatresult" name="vocProc_treatresult" id="vocProc_treatresult_30" value="30" disabled="disabled" />완료</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="table_middle_line"></td>
                                </tr>	
                                <tr>
                                    <td class="table_td_subject" width="100" >판정결과</td>
                                    <td class="table_td_contents">
                                    	<select class="select" id="vocProc_judgmentresult" disabled="disabled">
                                    		<option value="">선택</option>
                                    	</select>
                                    </td>
                                    <td class="table_td_subject" width="100" >조치결과</td>
                                    <td class="table_td_contents">
                                    	<select class="select" id="vocProc_measureresult" disabled="disabled">
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
                                        <input id="vocProc_measurefile1" name="vocProc_measurefile1" type="hidden"/>
                                        <span id="span_vocProc_measurefile1"></span>
                                    </td>
                                    <td class="table_td_subject" width="100">첨부2</td>
                                    <td class="table_td_contents">
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
                                        <textarea id="vocProc_measuredesc" rows="3" style="height: 100px; width: 98%; margin-top: 3px; margin-bottom: 3px;" readonly="readonly" ></textarea>
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
										<input type="text" id="1stVocUserNm" value="" readonly="readonly"/>
										<input type="hidden" id="1stVocUserId" value=""/>
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
										<input type="text" id="2ndVocUserNm" value="" readonly="readonly"/>
										<input type="hidden" id="2ndVocUserId" value=""/>
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
										<button id="vocAppBtn" type="button" class="btn btn-success btn-sm" style="margin-top: 9px;"><i class="fa fa-close"></i>승인</button>
										<button id="vocRtnBtn" type="button" class="btn btn-danger btn-sm" style="margin-top: 9px;"><i class="fa fa-close"></i>반려</button>										
										<button id="vocClsBtn" type="button" class="btn btn-default btn-sm" style="margin-top: 9px;"><i class="fa fa-close"></i>닫기</button>
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