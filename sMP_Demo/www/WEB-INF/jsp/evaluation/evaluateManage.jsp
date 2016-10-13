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

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
    // 날짜 세팅
    String srcStartDate = CommonUtils.getCustomDay("MONTH", -1);
    String srcEndDate = CommonUtils.getCurrentDate();
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
					<td class='ptitle'>대상품목관리/평가</td> 
					<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
						<button id='xlsButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-file-excel-o"></i>
							엑셀
						</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
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
					<td class="table_td_subject" width="100">품목명</td>
					<td class="table_td_contents">
						<input id="srcItemNm" name="srcItemNm" type="text"/>
					</td>
					<td class="table_td_subject" width="100">품목유형</td>
					<td class="table_td_contents" colspan='3'>
						<select name="srcItemType1" id="srcItemType1"><option value="">유형1</option></select>
						<select name="srcItemType2" id="srcItemType2"><option value="">유형2</option></select>
						<select name="srcItemType3" id="srcItemType3"><option value="">유형3</option></select>
					</td>
				</tr>
				<tr>
					<td colspan="6" class="table_middle_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">품목상태</td>
					<td class="table_td_contents">
                        <select id="srcItemState" name="srcItemState" style="min-width:80px;" class="select">
                            <option value="">전체</option>
                        </select>
					</td>
					<td class="table_td_subject" width="100">등록일</td>
					<td class="table_td_contents">
                        <input type="text" name="srcStartDate" id="srcStartDate" value="<%=srcStartDate%>" style="width:80px;text-align:center" maxlength="10" /> 
                        ~ 
                        <input type="text" name="srcEndDate" id="srcEndDate" value="<%=srcEndDate%>" style="width:80px;text-align:center" maxlength="10" />
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
						<button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
							<i class="fa fa-plus"></i>
							등록
						</button>
						<!-- button id='modButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
							<i class="fa fa-pencil"></i>
							수정
						</button>
						<button id='delButton' class="btn btn-danger btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
							<i class="fa fa-trash-o"></i>
							삭제
						</button -->
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
<style type="text/css">
.jqmWindow {
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
.jqmWindow.w800 {
    left: 10%;
    width: 800px;
}
.jqmWindow.w8002 {
    top: 10%;
    left: 5%;
    width: 800px;
    z-index: 1002;
}

#uploadDialogPop {
    top: 10%;
    left: 25%;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<div class="jqmWindow" id="evaluatePop"></div>
<div class="jqmWindow w800" id="evaluatePop800"></div>
<div class="jqmWindow w8002" id="evaluatePop8002"></div>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<script type="text/javascript">
$(function(){
    $.ajaxSetup ({
        cache: false
    });
	fnDataInit();
	fnDateInit();
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
		fieldSearchParamArray[4] = 'srcItemType3';
		fieldSearchParamArray[5] = 'srcItemState';
		fieldSearchParamArray[6] = 'srcStartDate';
		fieldSearchParamArray[7] = 'srcEndDate';
		fieldSearchParamArray[8] = 'srcChargerNm';
		var excelFileName = "evaluateManageList";  //file명

		fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/evaluation/selectItemList/excel.sys");
	});
	$('#regButton').click(function (e) {
		$('#evaluatePop').html('')
		.load('/menu/evaluation/evaluateReg.sys')
		.jqmShow();
	});
    $('#modButton').click(function (e) {
        var row = $("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
        if( row != null ){
            var selrowContent = $("#list").jqGrid('getRowData',row);
            if (selrowContent.ITEMSTATE != '10') {
                alert("'접수 중' 상태일때만 수정/삭제가 가능합니다. 확인 바랍니다.");
                return;
            }
            $('#evaluatePop').html('')
            .load('/evaluation/evaluateReg.sys?itemId=' + selrowContent.ITEMID)
            .jqmShow();
        } else { $( "#dialogSelectRow" ).dialog(); }
    });
    $("#delButton").click( function() {
        var row = $("#list").jqGrid('getGridParam','selrow');
        if( row != null ) {
            var selrowContent = $("#list").jqGrid('getRowData',row);
            if (selrowContent.ITEMSTATE != '10') {
                alert("'접수 중' 상태일때만 수정/삭제가 가능합니다. 확인 바랍니다.");
                return;
            }
            $("#list").jqGrid( 
                'delGridRow', row,{
                    url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/evaluation/deleteItem/save.sys",
                    recreateForm: true,beforeShowForm: function(form) {
                        var dlgDiv = $("#delmodlist");
                        var parentDiv = dlgDiv.parent(); // div#gbox_list
                        var dlgWidth = dlgDiv.width();
                        var parentWidth = parentDiv.width();
                        var dlgHeight = dlgDiv.height();
                        var parentHeight = parentDiv.height();
                        dlgDiv.css('top', Math.round((parentHeight-dlgHeight)/2) + "px");
                        dlgDiv.css('left', Math.round((parentWidth-dlgWidth)/2) + "px");
                        $(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
                        $('#pData').hide(); $('#nData').hide();  
                    },
                    reloadAfterSubmit:true,closeAfterDelete: true,
                    afterSubmit: function(response, postdata){
                        return fnJqTransResult(response, postdata);
                    }
                }
            );
        } else { $( "#dialogSelectRow" ).dialog(); }
    });
	$('#frmSearch').search();
    $('#evaluatePop').jqm();
    $('#evaluatePop800').jqm();
    $('#evaluatePop8002').jqm();
	
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
     $.post(  //조회조건의 품목유형3 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPITEM_ITEMTYPE3",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#srcItemType3").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
             }
         }
     );   
     $.post(  //조회조건의 품목상태 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPITEM_ITEMSTATE",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#srcItemState").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
             }
         }
     );
}
//날짜 데이터 초기화 
function fnDateInit() {
    $("#srcStartDate").datepicker(
        {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        }
    );
    $("#srcEndDate").datepicker(
        {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        }
    );
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}
var subGrid = null;
//그리드 초기화
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/selectItemList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['품목명','연간규모','품목유형1','품목유형2','품목유형3','안내서','규격서','등록일','마감일','품목상태','신청업체','담당자','','','',''],
        colModel:[
            {name:'ITEMNM',width:225},//품목명
            {name:'YEARLYSIZE',width:80,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//연간규모
            {name:'ITEMTYPE1',width:60},//품목유형1
            {name:'ITEMTYPE2',width:60},//품목유형2
            {name:'ITEMTYPE3',width:60},//품목유형3
            {name:'GUIDEBOOKATTACHFILE',width:230},//안내서
            {name:'SPECSATTACHFILE',width:100},//규격서
            {name:'REGIDATE',width:70,align:"center"},//등록일
            {name:'DEADLINEDATE',width:70,align:"center"},//마감일
            {name:'ITEMSTATENM',width:60,align:"center"},//품목상태
            {name:'APPLCNT',width:50,align:'center',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, suffix:"개" }},//신청업체
            {name:'CHARGERNM',width:60,align:"center"},//담당자
            {name:'ITEMID',hidden:true,key:true},//ITEMID
            {name:'ITEMSTATE',hidden:true,key:true},//ITEMSTATE
            {name:'GUIDEBOOKATTACHFILE_PATH',hidden:true},
            {name:'SPECSATTACHFILE_PATH',hidden:true}
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,width: <%=listWidth%>,
        sortname: 'ITEMID', sortorder: 'desc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	if (aData.ITEMSTATE == '10') {
        	    $("#list").setCell(rowid,'ITEMSTATENM','',{color:'#0000ff'});
        	} else if (aData.ITEMSTATE == '20') {
                $("#list").setCell(rowid,'ITEMSTATENM','',{color:'#ff0000'});
        	}
            $(this).setCell(rowid,'GUIDEBOOKATTACHFILE','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
            $(this).setCell(rowid,'SPECSATTACHFILE','',{color:'#0000ff',cursor: 'pointer','text-decoration':'underline'});
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="GUIDEBOOKATTACHFILE" && $.trim(selrowContent.GUIDEBOOKATTACHFILE) != '') {fnAttachFileDownload(selrowContent.GUIDEBOOKATTACHFILE_PATH);}
            if(colName != undefined &&colName['name']=="SPECSATTACHFILE" && $.trim(selrowContent.SPECSATTACHFILE) != '') {fnAttachFileDownload(selrowContent.SPECSATTACHFILE_PATH);}
            if(colName != undefined &&colName['name']=="SPECSATTACHFILE" && $.trim(selrowContent.SPECSATTACHFILE) != '') {fnAttachFileDownload(selrowContent.SPECSATTACHFILE_PATH);}
        },
        subGrid:true,
        subGridUrl: '<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/selectPartApplList/list.sys',
        subGridRowExpanded: function (grid_id, rowId) {
            var subgridTableId = grid_id + "_t";
            $("#" + grid_id).html("<table id='" + subgridTableId + "'></table>");
            $("#" + subgridTableId).jqGrid({
                url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/selectPartApplList/list.sys',
                datatype: 'json',
                mtype: 'POST',
                postData: {itemId:rowId},
                colNames:['업체명','신용등급<br/>(20)','경영전략<br/>(10)','생산기술<br/>(5)','개발기술<br/>(5)','납품실적<br/>(20)','품질경영<br/>(30)','품질 인증<br/>(5)','품질기기<br/>(5)','신인도<br/>(±10)','총점<br/>(100)','업체','품질','중간','제품','최종','APPLID','PARTSTATE','BUSIEVALSTATE','QUALITYEVALSTATE','MIDDLEEVALSTATE','PRODEVALSTATE','LASTEVALSTATE'],
                colModel:[
                    {name:'VENDORNM',width:120},//품목명
                    {name:'CREDITGRADESCORE',width:50,align:'center'},//신용등급
                    {name:'COMPINTROSCORE',width:50,align:'center'},//경영전략
                    {name:'FACTORYREGISCORE',width:50,align:'center'},//생산기술
                    {name:'LABSCORE',width:50,align:'center'},//개발기술
                    {name:'DELIVERYRESULTSCORE',width:50,align:'center'},//납품실적
                    {name:'QUALITYMAGTSCORE',width:50,align:'center'},//품질경영
                    {name:'QCSCORE',width:50,align:'center'},//품질 인증
                    {name:'OWNEQUIPSCORE',width:50,align:'center'},//품질기기
                    {name:'CREDITSCORE',width:50,align:'center'},//신인도
                    {name:'BUSIEVALSCORE',width:50,align:'center'},//총점
                    {name:'BUSIEVALSTATENM',width:50,align:'center'},//업체
                    {name:'QUALITYEVALSTATENM',width:50,align:'center'},//품질
                    {name:'MIDDLEEVALSTATENM',width:50,align:'center'},//중간
                    {name:'PRODEVALSTATENM',width:50,align:'center'},//제품
                    {name:'LASTEVALSTATENM',width:50,align:'center'},//최종
                    {name:'APPLID',hidden:true,key:true},//APPLID
                    {name:'PARTSTATE',hidden:true},//신청상태
                    {name:'BUSIEVALSTATE',hidden:true},//업체
                    {name:'QUALITYEVALSTATE',hidden:true},//품질
                    {name:'MIDDLEEVALSTATE',hidden:true},//중간
                    {name:'PRODEVALSTATE',hidden:true},//제품
                    {name:'LASTEVALSTATE',hidden:true} //최종
                ],
                jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
                height:'100%',
                afterInsertRow: function(rowid, aData) {
                	if (aData.PARTSTATE == 10 || aData.BUSIEVALSTATE == 10) {
                        $(this).setCell(rowid, 'BUSIEVALSTATENM', "조회",{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
                	} else if (aData.BUSIEVALSTATE == 0) { 
                		$(this).setCell(rowid, 'BUSIEVALSTATENM', "<button type='button' class='btn btn-primary btn-xs'>평가</button>"); 
                	} else if (aData.BUSIEVALSTATE == 1) {
                		$(this).setCell(rowid, 'BUSIEVALSTATENM', "<button type='button' class='btn btn-primary btn-xs'>수정</button>");
                	}
               		if (aData.QUALITYEVALSTATE == 0) { 
               			$(this).setCell(rowid, 'QUALITYEVALSTATENM', "<button type='button' class='btn btn-primary btn-xs'>평가</button>");
               		} else if (aData.QUALITYEVALSTATE == 1) {
                        $(this).setCell(rowid, 'QUALITYEVALSTATENM', "<button type='button' class='btn btn-primary btn-xs'>수정</button>");
               		} else if (aData.QUALITYEVALSTATE == 10) {
                        $(this).setCell(rowid, 'QUALITYEVALSTATENM', "조회",{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
                    }
                    if (aData.MIDDLEEVALSTATE == 0) { 
                        $(this).setCell(rowid, 'MIDDLEEVALSTATENM', "<button type='button' class='btn btn-primary btn-xs'>평가</button>");
                    } else if (aData.MIDDLEEVALSTATE == 2) {
                        $(this).setCell(rowid, 'MIDDLEEVALSTATENM', "<button type='button' class='btn btn-danger btn-xs'>반려</button>");
                    } else if (aData.MIDDLEEVALSTATE == 90) {
                        $(this).setCell(rowid, 'MIDDLEEVALSTATENM', "합격",{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
                    } else if (aData.MIDDLEEVALSTATE == 99) {
                        $(this).setCell(rowid, 'MIDDLEEVALSTATENM', "불합격",{color:'#ff0000',cursor:'pointer','text-decoration':'underline'});
                    } else if (aData.MIDDLEEVALSTATE == 9) {
                        $(this).setCell(rowid, 'MIDDLEEVALSTATENM', "결재중",{color:'#009933',cursor:'pointer','text-decoration':'underline'});
                    }
                    if (aData.PRODEVALSTATE == 0) { 
                        $(this).setCell(rowid, 'PRODEVALSTATENM', "<button type='button' class='btn btn-primary btn-xs'>평가</button>");
                    } else if (aData.PRODEVALSTATE == 1) {
                        $(this).setCell(rowid, 'PRODEVALSTATENM', "<button type='button' class='btn btn-primary btn-xs'>수정</button>");
                    } else if (aData.PRODEVALSTATE == 10) {
                        $(this).setCell(rowid, 'PRODEVALSTATENM', "조회",{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
                    }
                    if (aData.LASTEVALSTATE == 0) { 
                        $(this).setCell(rowid, 'LASTEVALSTATENM', "<button type='button' class='btn btn-primary btn-xs'>평가</button>");
                    } else if (aData.LASTEVALSTATE == 2) {
                        $(this).setCell(rowid, 'LASTEVALSTATENM', "<button type='button' class='btn btn-danger btn-xs'>반려</button>");
                    } else if (aData.LASTEVALSTATE == 90) {
                        $(this).setCell(rowid, 'LASTEVALSTATENM', "합격",{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
                    } else if (aData.LASTEVALSTATE == 99) {
                        $(this).setCell(rowid, 'LASTEVALSTATENM', "불합격",{color:'#ff0000',cursor:'pointer','text-decoration':'underline'});
                    } else if (aData.LASTEVALSTATE == 9) {
                        $(this).setCell(rowid, 'LASTEVALSTATENM', "결재중",{color:'#009933',cursor:'pointer','text-decoration':'underline'});
                    }
                },
                onCellSelect: function(rowid, iCol, cellcontent, target) {
                    var selrowContent = $(this).jqGrid('getRowData',rowid);
                    var cm = $(this).jqGrid("getGridParam", "colModel");
                    var colName = cm[iCol];
                    subGrid = $(this);
                    if (cellcontent == '&nbsp;') return;
                    if(colName != undefined &&colName['name']=="BUSIEVALSTATENM") {
                        $('#evaluatePop800').html('')
                        .load('/evaluation/evaluateBusi.sys?applId=' + selrowContent.APPLID)
                        .jqmShow();
                    }
                    if(colName != undefined &&colName['name']=="QUALITYEVALSTATENM") {
                        $('#evaluatePop800').html('')
                        .load('/evaluation/evaluateQuality.sys?applId=' + selrowContent.APPLID)
                        .jqmShow();
                    }
                    if(colName != undefined &&colName['name']=="MIDDLEEVALSTATENM") {
                        $('#evaluatePop8002').html('')
                        .load('/evaluation/evaluateMiddle.sys?applId=' + selrowContent.APPLID)
                        .jqmShow();
                    }
                    if(colName != undefined &&colName['name']=="PRODEVALSTATENM") {
                        $('#evaluatePop800').html('')
                        .load('/evaluation/evaluateProd.sys?applId=' + selrowContent.APPLID)
                        .jqmShow();
                    }
                    if(colName != undefined &&colName['name']=="LASTEVALSTATENM") {
                        $('#evaluatePop8002').html('')
                        .load('/evaluation/evaluateLast.sys?applId=' + selrowContent.APPLID)
                        .jqmShow();
                    }
                }
            });
        }
    })
    .jqGrid("setLabel", "rn", "순번");
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
</script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
</body>
</html>