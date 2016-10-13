<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
// 	int listWidth = 450;
	String listHeight = "$(window).height()-384 + Number(gridHeightResizePlus)";
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
<body style="background-color:#ffffff;">
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td class='ptitle'>설문조사</td> 
					<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table>
			<form id="frmSearch">
			<!-- Search Context -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" class="table_top_line"></td>
				</tr>
				<tr>
                    <td class="table_td_subject" width="100">등록일</td>
                    <td class="table_td_contents" colspan=3>
                        <input type="text" name="srcStartDate" id="srcStartDate" value="<%=srcStartDate%>" style="width:80px;text-align:center" maxlength="10" /> 
                        ~ 
                        <input type="text" name="srcEndDate" id="srcEndDate" value="<%=srcEndDate%>" style="width:80px;text-align:center" maxlength="10" />
                    </td>
				</tr>
				<tr>
					<td colspan="2" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="2" height='8'></td>
				</tr>
			</table>
			</form>
            <table width="1500px"  border="0" cellspacing="0" cellpadding="0">
                <col width="450" />
                <col />
                <col width="100%"/>
                <tr>
                    <td align="right" valign="bottom">
                        <button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
                        <button id='delButton' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash-o"></i> 삭제</button>
                    </td>
                </tr>
               <tr><td style="height: 5px;"></td></tr>
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

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<div class="jqmWindow" id="pollPop"></div>
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
    $('#regButton').click(function (e) {
        $('#pollPop').css({'top':'15%','left':'20%'}).html('')
        .load('/board/poll/pollReg.sys')
        .jqmShow();
    });
    
    $("#delButton").click( function() {
        var row = $("#list").jqGrid('getGridParam','selrow');
        if( row != null ) {
            var selrowContent = $("#list").jqGrid('getRowData',row);
            $("#list").jqGrid( 
                'delGridRow', row,{
                    url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/board/deletePoll/save.sys",
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
    $('#pollPop').jqm();
	
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
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectPollList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['제목','구분','기간','댓글개수','좋아요','나빠요','등록일시','등록자','',''],
        colModel:[
            {name:'SUBJECT',width:600},//제목
            {name:'TYPENM',width:60,align:'center'},//구분
            {name:'PERIOD',width:170,align:'center'},//기간
            {name:'COMMENTCNT',width:50,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//딧글개수
            {name:'GOODCNT',width:50,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//좋아요
            {name:'POORCNT',width:50,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//나빠요
            {name:'REGIDATE',width:80,align:'center'},//최종접속일시
            {name:'REGIUSERNM',width:65,align:'center'},//비밀번호변경
            {name:'TYPE',hidden:true},//TYPE
            {name:'POLLID',hidden:true,key:true} //POLLID
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,width:<%=listWidth%>,
        sortname: 'POLLID', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
            $(this).setCell(rowid,'COMMENTCNT','',{color:'#0000ff',cursor:'pointer'});
            
            $(this).setCell(rowid,'SUBJECT','',{color:'#0000ff',cursor:'pointer'});
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
            var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="COMMENTCNT") {
            	$('#pollPop').html('')
                .load('/menu/board/poll/commentList.sys?pollId=' + selrowContent.POLLID + '&type=' + selrowContent.TYPE)
                .jqmShow();
            }
            if(colName != undefined &&colName['name']=="SUBJECT" ) {
            	<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow(selrowContent.POLLID );")%>
            }
        }
    })
    .jqGrid("setLabel", "rn", "순번");
}

function viewRow(pollId){
	
	$('#pollPop').html('')
		.load('/board/poll/pollReg.sys?pollId=' + pollId)
		.jqmShow();
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