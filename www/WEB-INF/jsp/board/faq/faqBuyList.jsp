<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String srcFromDt = CommonUtils.getCustomDay("YEAR", -1);
	String srcEndDt = CommonUtils.getCurrentDate();
	String Session_auth	= null;
	String deli_Area_Code = null;
	deli_Area_Code = userDto.getAreaType();
	String board_Type = (String)request.getAttribute("board_Type");
	
	String replayFlag = CommonUtils.getString(request.getParameter("replayFlag"));	//답변플래그 Y일경우 답변글
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
.ui-jqgrid .ui-jqgrid-bdiv {
    position: relative;
    margin: 0em;
    padding: 0;
    overflow: hidden;
}

.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:2px;
    padding-left:2px;
    padding-top:4px;
    padding-bottom:4px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}


</style>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
});
</script>

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
            {name:'TITLE',width:650},//제목
            {name:'READ_CNT',width:80,align:'center',sorttype:'integer',formatter:'integer', hidden:true,
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//조회수
            {name:'CREATE_USERID',width:60,align:'center', hidden:true},//등록자
            {name:'CREATE_DATE',width:100,align:'center', hidden:true}//등록일
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:15, rownumbers:true, rowList:[15,30,50,100], pager: '#pager',
        height:425,autowidth:true,
        sortname: 'FAQ_SEQ', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadComplete: function() {
			//FnUpdatePagerIcons(this);
		},
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {},
        onCellSelect: function(rowid, iCol, cellcontent, target) {},
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
// 조회 등록/수정/삭제 후에도 처리하기에 꼭 펑션으로 사용함. 
function fnSearch() {
    $("#list")
    .jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()})
    .trigger("reloadGrid");
}
</script>


<body class="mainBg">
	<div id="divWrap">
		<!-- header -->
		<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
		<!-- /header -->
		<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />

		<!--컨텐츠(S)-->
		<div id="AllContainer">
			<ul class="Tabarea">
				<li class="on">FAQ</li>
			</ul>
			<div style="position:absolute; right:0; margin-top:-30px;"><a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a></div>
			<form id="frmSearch" onsubmit="return false;">
			<input id="srcSvcType" name="srcSvcType" value="BUY" type="hidden"/>
			<table class="InputTable">
				<colgroup>
					<col width="120px" />
					<col width="auto" />
					<col width="120px" />
					<col width="auto" />
				</colgroup>
			
				
				<tr>
					<th>유형</th>
					<td>
						<select id="srcFaqType" name="srcFaqType" style="min-width:100px;" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<th>제목</th>
					<td>
						<input id="srcTitle" name="srcTitle" type="text"/>
					</td>
				</tr>
			</table>
			</form>
			<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;" >
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td bgcolor="#FFFFFF">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr><td style="height: 5px;"></td></tr>
							<tr>
								<td>
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
			<div style="height:10px;"></div>
		</div>
        <!--컨텐츠(E)-->
		</div>
        	<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>
</html>