<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-330 + Number(gridHeightResizePlus)";	
	
	String businessNum = "1220481427"; // 사업자 번호로 참가여부 확인 

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
</head>

<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<body>
<table width="98%" style="margin-left: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF" align="center">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td class='ptitle'>지정자재 신규 신청</td> 
					<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
						<button id='srcButton' class="btn btn-default btn-sm">
							<i class="fa fa-search"></i>
							조회
						</button>
						<button id='xlsButton' class="btn btn-default btn-sm">
							<i class="fa fa-file-excel-o"></i>
							엑셀
						</button>
					</td>
				</tr>
			</table>
			<form id="frmSearch">
			<input type="hidden" name="srcBusinessNum" value="${businessNum}"/>
			<!-- Search Context -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
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
					<td class="table_td_contents">
						<select name="srcItemType1" id="srcItemType1"><option value="">유형1</option></select>
						<select name="srcItemType2" id="srcItemType2"><option value="">유형2</option></select>
						<select name="srcItemType3" id="srcItemType3"><option value="">유형3</option></select>
					</td>
                    <td class="table_td_subject" width="100">참가여부</td>
                    <td class="table_td_contents">
                        <select id="srcPartState" name="srcPartState" style="min-width:80px;" class="select">
                            <option value="">전체</option>
                            <option value="Y">참가</option>
                            <option value="N">미참가</option>
                        </select>
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
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
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
    left: 10%;
    width: 800px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
    z-index: 1003;
}

#uploadDialogPop {
    top: 10%;
    left: 15%;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<div class="jqmWindow" id="evaluatePop"></div>
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
        var colLabels = ['품목명','연간규모','품목유형1','품목유형2','품목유형3','안내서','규격서','등록일','마감일','품목상태','참가상태','담당자'];   //출력컬럼명
        var colIds = ['ITEMNM','YEARLYSIZE','ITEMTYPE1','ITEMTYPE2','ITEMTYPE3','GUIDEBOOKATTACHFILE','SPECSATTACHFILE','REGIDATE','DEADLINEDATE','ITEMSTATENM','PARTSTATENM','CHARGERNM'];   //출력컬럼ID
        var numColIds = ['YEARLYSIZE'];  //숫자표현ID
        var sheetTitle = "지정자재 신규업체 신청"; //sheet 타이틀
        var excelFileName = "evaluateApplList";  //file명
        
        fnExportExcel($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
    });
	$('#frmSearch').search();
    $('#evaluatePop').jqm();
	
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
//그리드 초기화
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/selectItemListForV/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['품목명','연간규모','품목유형1','품목유형2','품목유형3','안내서','규격서','등록일','마감일','품목상태','참가상태','담당자','참가신청','','','','','',''],
        colModel:[
            {name:'ITEMNM',width:120},//품목명
            {name:'YEARLYSIZE',width:80,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//연간규모
            {name:'ITEMTYPE1',width:60},//품목유형1
            {name:'ITEMTYPE2',width:60},//품목유형2
            {name:'ITEMTYPE3',width:60},//품목유형3
            {name:'GUIDEBOOKATTACHFILE',width:100},//안내서
            {name:'SPECSATTACHFILE',width:100},//규격서
            {name:'REGIDATE',width:80,align:"center"},//등록일
            {name:'DEADLINEDATE',width:80,align:"center"},//마감일
            {name:'ITEMSTATENM',width:60,align:"center"},//품목상태
            {name:'PARTSTATENM',width:60,align:"center"},//참가상태
            {name:'CHARGERNM',width:60,align:"center"},//담당자
            {name:'PARTAPPL',width:60,align:"center"},//참가신청
            {name:'ITEMID',hidden:true,key:true},//ITEMID
            {name:'APPLID',hidden:true,key:true},//APPLID
            {name:'ITEMSTATE',hidden:true,key:true},//ITEMSTATE
            {name:'PARTSTATE',hidden:true,key:true},//PARTSTATE
            {name:'GUIDEBOOKATTACHFILE_PATH',hidden:true},
            {name:'SPECSATTACHFILE_PATH',hidden:true}
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,autowidth:true,
        sortname: 'ITEMID', sortorder: 'DESC',
        caption:"지정자재 대상품목", 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	if (aData.ITEMSTATE == '10') {
        		$(this).setCell(rowid,'ITEMSTATENM','',{color:'#0000ff'});
        	    if (aData.APPLID) {
        	        $(this).setCell(rowid, 'PARTAPPL', "<button type='button' class='btn btn-primary btn-xs'>수정</button>");
        	    } else {
        	    	$(this).setCell(rowid, 'PARTAPPL', "<button type='button' class='btn btn-primary btn-xs'>신청</button>");
        	    }
        	} else if (aData.APPLID) {
        		$(this).setCell(rowid, 'PARTAPPL', '신청내역',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        	}
        	if (aData.PARTSTATE ==  '10') {
                $(this).setCell(rowid,'PARTSTATENM','',{color:'#0000ff'});
        	} else if (aData.PARTSTATE == '99') {
        		$(this).setCell(rowid,'PARTSTATENM','',{color:'#ff0000'});
            } else if (aData.PARTSTATE == '90') {
            	$(this).setCell(rowid,'PARTSTATENM','',{color:'#009933'});
        	}
	        $(this).setCell(rowid,'GUIDEBOOKATTACHFILE','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
	        $(this).setCell(rowid,'SPECSATTACHFILE','',{color:'#0000ff',cursor: 'pointer','text-decoration':'underline'});
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
            if (cellcontent == '&nbsp;') return;
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="GUIDEBOOKATTACHFILE" && $.trim(selrowContent.GUIDEBOOKATTACHFILE) != '') {fnAttachFileDownload(selrowContent.GUIDEBOOKATTACHFILE_PATH);}
            if(colName != undefined &&colName['name']=="SPECSATTACHFILE" && $.trim(selrowContent.SPECSATTACHFILE) != '') {fnAttachFileDownload(selrowContent.SPECSATTACHFILE_PATH);}
            if(colName != undefined &&colName['name']=="PARTAPPL") {
            	$('#evaluatePop').html('')
                .load('/evaluation/evaluateAppl.sys?itemId=' + selrowContent.ITEMID + '&applId=' + selrowContent.APPLID)
                .jqmShow();
            }
        }
    })
    .jqGrid("setLabel", "rn", "순번");
}
// Resizing
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
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