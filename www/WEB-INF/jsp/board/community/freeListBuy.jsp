<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList  = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto        userDto   = CommonUtils.getLoginUserDto(request);
	String              boardType = "0201";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<script>
var jq = jQuery;

$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
	
	$("#searchText").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();}
	});
	
	$("#srcTitle").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	
	$("#srcMessage").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	
	$("#srcRegi_User_Numb").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	
	$("#searchText").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	
	$("#srcButton").click(function(){
		fnTrim("searchText");
		
		fnSearch();
	});
	
	$("#regButton").click(function(){
		fnBoardRegist();
	});
	
	$("#modButton").click(function(){
		fnBoardDetail();
	});
	
	fnInitJqGrid();
});

function fnTrim(id){
	var value = $("#" + id).val();
	
	value = $.trim(value);
	
	$("#" + id).val(value);
}

function fnInitJqGrid() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/board/boardListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			'번호',	'번호 시퀀스',	'제목',	'첨부개수',			'등록일',
			'작성자',	'조회수',		'Lev',	'parent_board_no'
		],
		colModel:[
			{name:'num',            index:'num',             width:50,  align:"center",  search:false, sortable:false},	//번호
			{name:'board_No',       index:'board_No',        hidden:true, key:true},	//번호 시퀀스
			{name:'title',          index:'title',           width:550, align:"left",   search:false, sortable:false, editable:false, formatter:image1},	//제목
			{name:'file_list_cnt',  index:'file_list_cnt',   width:70,  align:"right",  search:false, sortable:false, editable:false},	//첨부개수
			{name:'regi_Date_Time', index:'regi_Date_Time',  width:110, align:"center", search:false, sortable:false, editable:false},	// 등록일
			
			{name:'regi_User_Numb', index:'regi_User_Numb',  width:110, align:"center", search:false, sortable:false, editable:false},	// 작성자
			{name:'hit_No',         index:'hit_No',          width:60,  align:"right",  search:false, sortable:false, editable:false},//조회수
			{name:'Lev',            index:'Lev',             hidden:true},	//Lev
			{name:'parent_board_no',index:'parent_board_no', hidden:true}	//parent_board_no
		],
		postData: { 
 			board_Type:"<%=boardType%>"
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 390,autowidth: true,
		sortname: '', sortorder: '',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		afterInsertRow: function(rowid, aData) {
			$(this).setCell(rowid,'title','',{color:'#0000ff',cursor:'pointer'});
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm      = $("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			
			$('#list').jqGrid('setSelection', rowid); 
			
			if(colName != undefined && colName['name']=="title" ) {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBoardDetail();")%>
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}

function fnSearch() {
	var data = $("#list").jqGrid("getGridParam", "postData");
	
	data.srcTitle          = document.getElementById("srcTitle").checked ? $("#searchText").val() : "";
	data.srcMessage        = document.getElementById("srcMessage").checked ? $("#searchText").val() : "";
 	data.srcRegi_User_Numb = document.getElementById("srcRegi_User_Numb").checked ? $("#searchText").val()  : "";
 	data.searchText        = $("#searchText").val() ;
 	
	$("#list").jqGrid("setGridParam", {"postData": data, "page":1});
	$("#list").trigger("reloadGrid");
}

function image1(cellValue, options, rowObject){
	var space  = "";
    var space2 = "";
    var img    = "<img src='/img/system/icon_reply.gif' border='0'/>";
    
  	for (var i = 0; i<rowObject.lev; i++) {
		space += "&nbsp;&nbsp;&nbsp;";
  	}
  	
  	if (rowObject.parent_Board_No == 0){
		space2 = space + rowObject.title;
  	}
  	else {
		space2 = space + img + rowObject.title;
	}
  	
	return "&nbsp;&nbsp;" + space2;
}

function fnBoardDetail() {
	var moveFlag       = "D";
	var param          = null;
	var id             = $("#list").jqGrid('getGridParam', "selrow" );
	var selrowContent  = null;
	var boardNo        = null;
	var regiUserNumb   = null;
	
	if(id == null){
		alert("데이터를 선택해 주세요.");
		
		return;
	}
	
	selrowContent = jq("#list").jqGrid('getRowData',id);
	boardNo       = selrowContent.board_No;
	regiUserNumb  = selrowContent.regi_User_Numb;
	
	if("<%=userDto.getUserNm() %>" == regiUserNumb) {
		moveFlag = "W";
	}
	
	param = "board_No=" + boardNo;
	param = param + "&board_Type=<%=boardType%>";
	param = param + "&moveFlag=" + moveFlag;

	window.open('', 'boardDetailWrite', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/board/boardDetailWrite.sys", param, 'boardDetailWrite');
}

function fnBoardRegist() {
	var param = "board_Type=<%=boardType%>";
	
	param = param + "&moveFlag=W";
	
	window.open('', 'boardDetailWrite', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/board/boardDetailWrite.sys", param, 'boardDetailWrite');
}

function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
	$("#list").trigger("reloadGrid");
}
</script>
<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>
</head>
<body class="mainBg">
<div id="divWrap">
	<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
	<hr>
	<div id="divBody">
		<div id="divSub">
			<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
			<div id="AllContainer">
				<ul class="Tabarea">
					<li class="on">게시판</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
					<a href="javascript:void(0);">
						<img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/>
					</a>
				</div>
				<table class="InputTable">
					<colgroup>
						<col width="170px" />
						<col width="auto" />
					</colgroup>
					<tr>
						<th>
							<input id="srcTitle" name="srcTitle" type="checkbox" style="border: 0; vertical-align: middle;" checked="checked"/>
							&nbsp;제목&nbsp;&nbsp;
							<input id="srcMessage" name="srcMessage" type="checkbox" style="border: 0;vertical-align: middle;" /> 
							&nbsp;내용&nbsp;&nbsp;
							<input id="srcRegi_User_Numb" name="srcRegi_User_Numb" type="checkbox" style="border: 0;vertical-align: middle;" /> 
							&nbsp;이름
						</th>
						<td>
							<input id="searchText" name="searchText" type="text" value="" size="100" maxlength="30"/>
						</td>
					</tr>
				</table>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
					<tr><td style="height: 5px;"></td></tr>
					<tr>
						<td bgcolor="#FFFFFF">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr><td style="height: 5px;"></td></tr>
								<tr>
									<td align="right" valign="bottom">
										<button id='regButton' class="btn btn-darkgray btn-xs"><i class="fa fa-pencil"></i> 등록</button>
										<button id='modButton' class="btn btn-darkgray btn-xs"><i class="fa fa-plus"></i> 상세</button>
									</td>
								</tr>
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
						</td>
					</tr>
				</table> 
				<div style="height:10px;"></div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
	</div>
	<hr>
</div>
</body>
</html>