<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
// 	int listWidth = 450;
	String listHeight = "$(window).height()-368 + Number(gridHeightResizePlus)";
	String listWidth = "1500";

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
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td class='ptitle'>FAQ 관리</td> 
					<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i>
							조회
						</button>
					</td>
				</tr>
			</table>
			<form id="frmSearch" onsubmit="return false;">
			<!-- Search Context -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				
				<tr>
					<td class="table_td_subject" width="100">유형</td>
					<td class="table_td_contents">
						<select id="srcFaqType" name="srcFaqType" style="min-width:80px;" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">서비스유형</td>
					<td class="table_td_contents">
						<select id="srcSvcType" name="srcSvcType" style="min-width:80px;" class="select">
							<option value="">전체</option>
							<option value="BUY">구매사</option>
							<option value="VEN">공급사</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">제목</td>
					<td class="table_td_contents">
						<input id="srcTitle" name="srcTitle" type="text"/>
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
						<button id='delButton' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
							<i class="fa fa-trash-o"></i>
							삭제
						</button> 
					</td>
				</tr>
				<tr><td height="5"></td></tr>
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
<div class="jqmWindow" id="faqPop"></div>

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
	$('#regButton').click(function (e) {
		$('#faqPop').html('')
		.load('/board/faqRegPop.sys')
		.jqmShow();
	});
	
    $("#delButton").click( function() {
    	var row = $("#list").jqGrid('getGridParam','selrow');
    	if( ! row ){
    		alert("처리할 데이터를 선택하시기 바랍니다.");
    		return;	
    	}
    	
    	var FAQ_SEQ = $("#list").jqGrid("getRowData",row).FAQ_SEQ;
    	
    	$.post(
    		"/board/deleteFaqManage/save.sys",
    		{
    			FAQ_SEQ		: FAQ_SEQ ,
    			oper		: 'del'
    		},
    		function(args){
    			if ( fnAjaxTransResult(args)) {
    				fnSearch();
    			} 
    		}
    	);

    });
	$('#frmSearch').search();
    $('#faqPop').jqm();
	
});
//코드 데이터 초기화 
function fnDataInit(){
	 $.post(  //조회조건의 faq유형 세팅
	     '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
	     {
	         codeTypeCd:"FAQ_TYPE",
	         isUse:"1"
	     },
	     function(arg){
	         var codeList = eval('(' + arg + ')').codeList;
	         for(var i=0;i<codeList.length;i++) {
	             $("#srcFaqType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
	         }
	     }
	 );  
}

var subGrid = null;
//그리드 초기화
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectFapList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['순번','유형','서비스유형','제목','조회수','등록자','등록일'],
        colModel:[
            {name:'FAQ_SEQ',hidden:true,key:true},//ITEMID
            {name:'FAQ_TYPE_NM',width:120},//유형
            {name:'SVC_TYPE_NM',width:120},//서비스유형
            {name:'TITLE',width:600},//제목
            {name:'READ_CNT',width:80,align:'center',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//조회수
            {name:'CREATE_USERID',width:60,align:'center'},//등록자
            {name:'CREATE_DATE',width:100,align:'center'}//등록일
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,width:<%=listWidth%>,
        sortname: 'FAQ_SEQ', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
            $(this).setCell(rowid,'TITLE','',{color:'#0000ff',cursor:'pointer'});
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="TITLE" ) {
            	$('#faqPop').html('')
               .load('/board/faqRegPop.sys?faq_seq=' + rowid)
               .jqmShow();
                
            }
            
        },
        subGrid:true,
        subGridUrl: '<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectFapList/list.sys',
        subGridRowExpanded: function (grid_id, rowId) {
            var subgridTableId = grid_id + "_t";
            $("#" + grid_id).html("<table id='" + subgridTableId + "'></table>");
            $("#" + subgridTableId).jqGrid({
                url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectFapList/list.sys',
                datatype: 'json',
                mtype: 'POST',
                postData: {faq_seq:rowId},
                colNames:['답변'],
                colModel:[
                    {name:'ANSWER',width:800, sortable:false}//답변
                ],
                jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
                height:'100%',
                afterInsertRow: function(rowid, aData) {
                	$(".ui-subgrid .ui-jqgrid-htable").hide();
                },
                onCellSelect: function(rowid, iCol, cellcontent, target) {}
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
</script>

<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
</body>
</html>