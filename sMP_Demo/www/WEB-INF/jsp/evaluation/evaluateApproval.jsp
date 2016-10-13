<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
// 	int listWidth = 450;
	String listHeight = "$(window).height()-385 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
    // 날짜 세팅
    String srcStartDate = CommonUtils.getCustomDay("MONTH", -1);
    String srcEndDate = CommonUtils.getCurrentDate();
    
    LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
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
					<td class='ptitle'>지정자재 업체평가 결재</td> 
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
				<tr><td height="1"></td></tr>
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
                    <td class="table_td_subject" width="100">담당자</td>
                    <td class="table_td_contents">
                        <input id="srcChargerNm" name="srcChargerNm" type="text"/>
                    </td>
				</tr>
                <tr>
                    <td colspan="6" class="table_middle_line"></td>
                </tr>
                <tr>
                    <td class="table_td_subject" width="100">결재처리</td>
                    <td class="table_td_contents">
                        <select id="srcApproval" name="srcApproval">
                            <option value="Y">예</option>
                            <option value="">전체</option>
                            <option value="N">아니오</option>
                        </select>
                    </td>
                    <td class="table_td_subject" width="100">마감일</td>
                    <td class="table_td_contents" colspan=3>
                        <input type="text" name="srcStartDate" id="srcStartDate" value="<%=srcStartDate%>" style="width:80px;text-align:center" maxlength="10" /> 
                        ~ 
                        <input type="text" name="srcEndDate" id="srcEndDate" value="<%=srcEndDate%>" style="width:80px;text-align:center" maxlength="10" />
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
    fnDateInit();
	fnGridInit();
	$('#srcButton').click(function (e) {
		fnSearch();
	});
    $('#xlsButton').click(function (e) {
        var colLabels = ['품목명','연간규모','등록일','마감일','담당자','업체명','중간평가 결재자','최종평가 결재자'];   //출력컬럼명
        var colIds = ['ITEMNM','YEARLYSIZE','REGIDATE','DEADLINEDATE','CHARGERNM','VENDORNM','MIDDLEAPPRVNM','LASTAPPRVNM'];   //출력컬럼ID
        var numColIds = ['YEARLYSIZE'];  //숫자표현ID
        var sheetTitle = "지정자재 업체평가 결재"; //sheet 타이틀
        var excelFileName = "evaluateApprovalList";  //file명
        var fieldSearchParamArray = new Array();     //파라메타 변수ID
		fieldSearchParamArray[0] = 'srcItemNm';
		fieldSearchParamArray[1] = 'srcVendorNm';
		fieldSearchParamArray[2] = 'srcChargerNm';
		fieldSearchParamArray[3] = 'srcApproval';
		fieldSearchParamArray[4] = 'srcStartDate';
		fieldSearchParamArray[5] = 'srcEndDate';

		fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/evaluation/selectApprovalApplList/excel.sys");
    });
	$('#frmSearch').search();
    $('#evaluatePop800').jqm();
    $('#evaluatePop8002').jqm();
	
});
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
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/selectApprovalApplList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['품목명','연간규모','등록일','마감일','담당자','업체명','중간평가 결재자','중간결재','최종평가 결재자','최종결재','','','','','','','','','','','','',''],
        colModel:[
            {name:'ITEMNM',width:260},//품목명
            {name:'YEARLYSIZE',width:80,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//연간규모
            {name:'REGIDATE',width:80,align:"center"},//등록일
            {name:'DEADLINEDATE',width:80,align:"center"},//마감일
            {name:'CHARGERNM',width:60,align:"center"},//담당자
            {name:'VENDORNM',width:220},//업체명
            {name:'MIDDLEAPPRVNM',width:105},//중간평가 결재자
            {name:'MIDDLEAPPRV',width:60,align:'center'},//중간결재
            {name:'LASTAPPRVNM',width:105},  //최종평가 결재자
            {name:'LASTAPPRV',width:60,align:'center'},//최종결재
            {name:'APPLID',hidden:true,key:true}, //APPLID
            {name:'MIDDLE1APPRVID',hidden:true}, // MIDDLE1APPRVID
            {name:'MIDDLE1APPRVNM',hidden:true}, // MIDDLE1APPRVNM
            {name:'MIDDLE1APPRVSTATE',hidden:true}, // MIDDLE1APPRVSTATE
            {name:'MIDDLE2APPRVID',hidden:true}, // MIDDLE2APPRVID
            {name:'MIDDLE2APPRVNM',hidden:true}, // MIDDLE2APPRVNM
            {name:'MIDDLE2APPRVSTATE',hidden:true}, // MIDDLE2APPRVSTATE
            {name:'LAST1APPRVID',hidden:true}, // LAST1APPRVID
            {name:'LAST1APPRVNM',hidden:true}, // LAST1APPRVNM
            {name:'LAST1APPRVSTATE',hidden:true}, // LAST1APPRVSTATE
            {name:'LAST2APPRVID',hidden:true}, // LAST2APPRVID
            {name:'LAST2APPRVNM',hidden:true}, // LAST2APPRVNM
            {name:'LAST2APPRVSTATE',hidden:true} // LAST2APPRVSTATE
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,width:<%=listWidth%>,
        sortname: 'APPLID', sortorder: 'desc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	var middleApprvNm = '';
        	var middleApprv = '';
        	if (aData.MIDDLE1APPRVSTATE == '9') {
        		middleApprvNm = aData.MIDDLE1APPRVNM;
        		if (aData.MIDDLE1APPRVID == '<%=userDto.getUserId()%>') {
                    middleApprv = '<button type="button" class="btn btn-primary btn-xs">결재</button>';
        		}
        	} else if (aData.MIDDLE1APPRVSTATE == '90') {
        		middleApprvNm = '<span style="color:#009933">' + aData.MIDDLE1APPRVNM + '</span>';
        		middleApprv = '<span style="color:#009933;text-decoration:underline">승인</span>';
            } else if (aData.MIDDLE1APPRVSTATE == '2') {
                middleApprvNm = '<span style="color:#ff0000">' + aData.MIDDLE1APPRVNM + '</span>';
                middleApprv = '<span style="color:#ff0000;text-decoration:underline">반려</span>';
        	}
        	if (middleApprvNm != '' && aData.MIDDLE2APPRVSTATE) {
        		middleApprvNm = middleApprvNm + ' > ';
        	}
            if (aData.MIDDLE2APPRVSTATE == '9') {
                middleApprvNm = middleApprvNm + aData.MIDDLE2APPRVNM;
                if (aData.MIDDLE1APPRVSTATE != '9' && aData.MIDDLE2APPRVID == '<%=userDto.getUserId()%>') {
                    middleApprv = '<button type="button" class="btn btn-primary btn-xs">결재</button>';
                }
            } else if (aData.MIDDLE2APPRVSTATE == '90') {
                middleApprvNm = middleApprvNm + '<span style="color:#009933">' + aData.MIDDLE2APPRVNM + '</span>';
                middleApprv = '<span style="color:#009933;text-decoration:underline">승인</span>';
            } else if (aData.MIDDLE2APPRVSTATE == '2') {
                middleApprvNm = middleApprvNm + '<span style="color:#ff0000">' + aData.MIDDLE2APPRVNM + '</span>';
                middleApprv = '<span style="color:#ff0000;text-decoration:underline">반려</span>';
            }
            $(this).setCell(rowid, 'MIDDLEAPPRVNM', middleApprvNm);
            $(this).setCell(rowid, 'MIDDLEAPPRV', middleApprv);
            
            var lastApprvNm = '';
            var lastApprv = '';
            if (aData.LAST1APPRVSTATE == '9') {
                lastApprvNm = aData.LAST1APPRVNM;
                if (aData.LAST1APPRVID == '<%=userDto.getUserId()%>') {
                    lastApprv = '<button type="button" class="btn btn-primary btn-xs">결재</button>';
                }
            } else if (aData.LAST1APPRVSTATE == '90') {
                lastApprvNm = '<span style="color:#009933">' + aData.LAST1APPRVNM + '</span>';
                lastApprv = '<span style="color:#009933;text-decoration:underline">승인</span>';
            } else if (aData.LAST1APPRVSTATE == '2') {
                lastApprvNm = '<span style="color:#ff0000">' + aData.LAST1APPRVNM + '</span>';
                lastApprv = '<span style="color:#ff0000;text-decoration:underline">반려</span>';
            }
            if (lastApprvNm != '' && aData.LAST2APPRVSTATE) {
                lastApprvNm = lastApprvNm + ' > ';
            }
            if (aData.LAST2APPRVSTATE == '9') {
                lastApprvNm = lastApprvNm + aData.LAST2APPRVNM;
                if (aData.LAST2APPRVID == '<%=userDto.getUserId()%>') {
                    lastApprv = '<button type="button" class="btn btn-primary btn-xs">결재</button>';
                }
            } else if (aData.LAST2APPRVSTATE == '90') {
                lastApprvNm = lastApprvNm + '<span style="color:#009933">' + aData.LAST2APPRVNM + '</span>';
                lastApprv = '<span style="color:#009933;text-decoration:underline">승인</span>';
            } else if (aData.LAST2APPRVSTATE == '2') {
                lastApprvNm = lastApprvNm + '<span style="color:#ff0000">' + aData.LAST2APPRVNM + '</span>';
                lastApprv = '<span style="color:#ff0000;text-decoration:underline">반려</span>';
            }
            $(this).setCell(rowid, 'LASTAPPRVNM', lastApprvNm);
            $(this).setCell(rowid, 'LASTAPPRV', lastApprv);
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if (cellcontent == '&nbsp;') return;
            if(colName != undefined &&colName['name']=="MIDDLEAPPRV") {
                $('#evaluatePop8002').html('')
                .load('/evaluation/evaluateMiddle2.sys?applId=' + selrowContent.APPLID)
                .jqmShow();
            }
            if(colName != undefined &&colName['name']=="LASTAPPRV") {
                $('#evaluatePop8002').html('')
                .load('/evaluation/evaluateLast2.sys?applId=' + selrowContent.APPLID)
                .jqmShow();
            }
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