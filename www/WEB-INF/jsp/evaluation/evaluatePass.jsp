<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
// 	int listWidth = 450;
	String listHeight = "$(window).height()-355 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
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
					<td class='ptitle'>합격업체</td> 
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
					<td class="table_td_subject" width="100">품목명</td>
					<td class="table_td_contents">
						<input id="srcItemNm" name="srcItemNm" type="text"/>
					</td>
					<td class="table_td_subject" width="100">업체명</td>
                    <td class="table_td_contents">
                        <input id="srcVendorNm" name="srcVendorNm" type="text"/>
					</td>
                    <td class="table_td_subject" width="100">사업자등록번호</td>
                    <td class="table_td_contents">
                        <input id="srcBusinessNum" name="srcBusinessNum" type="text"/>
                    </td>
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

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<div class="jqmWindow w800" id="evaluatePop800"></div>
<div class="jqmWindow w8002" id="evaluatePop8002"></div>
<script type="text/javascript">
$(function(){
    $.ajaxSetup ({
        cache: false
    });
	fnGridInit();
	$('#srcButton').click(function (e) {
		fnSearch();
	});
    $('#xlsButton').click(function (e) {
        var colLabels = ['품목명','업체명','사업자등록번호','등록업체','합격일시','처리자'];   //출력컬럼명
        var colIds = ['ITEMNM','VENDORNM','BUSINESSNUM','REGVENDOR','LASTEVALDATE','LASTEVALNM'];   //출력컬럼ID
        var numColIds = [];  //숫자표현ID
        var sheetTitle = "합격업체"; //sheet 타이틀
        var excelFileName = "passVendorList";  //file명
        var fieldSearchParamArray = new Array();     //파라메타 변수ID
		fieldSearchParamArray[0] = 'srcItemNm';
		fieldSearchParamArray[1] = 'srcVendorNm';
		fieldSearchParamArray[2] = 'srcBusinessNum';
	
		var excelFileName = "evaluatePassList";  //file명

		fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/evaluation/selectPassApplList/excel.sys");
	});
    
	$('#frmSearch').search();
    $('#evaluatePop800').jqm();
    $('#evaluatePop8002').jqm();
	
});
//그리드 초기화
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/selectPassApplList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['품목명','업체명','사업자등록번호','등록업체','합격일시','처리자','평가확인','APPLID'],
        colModel:[
            {name:'ITEMNM',width:200},//품목명
            {name:'VENDORNM',width:200},//업체명
            {name:'BUSINESSNUM',width:100,align:'center'},//사업자등록번호
            {name:'REGVENDOR',width:80,align:'center'},//등록업체
            {name:'LASTEVALDATE',width:160,align:'center'},//합격일시
            {name:'LASTEVALNM',width:80,align:'center'},//처리자
            {name:'EVALCONFIRM',width:50,align:'center',sortable:false}, //평가확인
            {name:'APPLID',hidden:true,key:true} //APPLID
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,width:<%=listWidth%>,
        sortname: 'APPLID', sortorder: 'desc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
            $(this).setCell(rowid, 'EVALCONFIRM', "<button type='button' class='btn btn-primary btn-xs'>확인</button>"); 
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="EVALCONFIRM") {
                $('#evaluatePop8002').html('')
                .load('/evaluation/evaluateLast.sys?applId=' + selrowContent.APPLID)
                .jqmShow();
            }
        }
    })
    .jqGrid("setLabel", "rn", "순번");
}
// Resizing
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight%>);
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