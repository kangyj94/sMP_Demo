<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#divGnb").mouseout(function () {
		$("#snb_vdr").hide();
	});
	$("#snb_vdr").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#snb_vdr").mouseout(function () {
		$("#snb_vdr").hide();
	});
});

var jq = jQuery;

$(document).ready(function() {
	$("#srcTitle").attr('checked', true);
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
		$("#searchText").val($.trim($("#searchText").val()));
	});
	$("#srcButton").click( function() { fnSearch(); });
	
});

$(function() {
	$("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/board/noticeListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			'번호 시퀀스',	'번호',	'제목',	'첨부개수',	'등록일',
			'작성자',		'조회수'
		],
		colModel:[
			{name:'board_No',       index:'board_No',       hidden:true, key:true},	//번호 시퀀스
			{name:'num',            index:'num',            width:50,    align:"center", search:false, sortable:true,  editable:false},	//로우넘번호
			{name:'title',          index:'title',          width:550,   align:"left",   search:false, sortable:true,  editable:false},	//제목
			{name:'file_list_cnt',  index:'file_List_cnt',  width:70,    align:"center", search:false, sortable:false, editable:false},	//첨부파일갯수
			{name:'regi_Date_Time', index:'regi_Date_Time', width:110,   align:"center", search:false, sortable:true,  editable:false},	// 등록일
			{name:'regi_User_Numb', index:'regi_User_Numb', width:110,   align:"center", search:false, sortable:true,  editable:false},	// 작성자
			{name:'hit_No',         index:'hit_No',         width:60,    align:"center", search:false, sortable:true,  editable:false}	//조회수
		],
		postData:{
			srcBoardBorgType : "VEN"
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: 500,autowidth: true,
		sortname: 'board_No', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			FnUpdatePagerIcons(this);
		},
		afterInsertRow: function(rowid, aData) {
			var title = "&nbsp;&nbsp;" + aData.title;
			
			$(this).setCell(rowid,'title','',{color:'#0000ff',cursor:'pointer'});
			$('#list').jqGrid('setRowData', rowid, {title : title});
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			var cm            = $("#list").jqGrid("getGridParam", "colModel");
			var colName       = cm[iCol];
			
			if(colName != undefined &&colName['name']=="title" ) {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow(rowid);")%>
			}
			
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});

function fnSearch() {
	$("#list").jqGrid("setGridParam", {"page":1});
	var data = $("#list").jqGrid("getGridParam", "postData");
	data.srcTitle = document.getElementById("srcTitle").checked ? $("#searchText").val() : "";
	data.srcMessage = document.getElementById("srcMessage").checked ? $("#searchText").val() : "";
 	data.srcRegi_User_Numb = document.getElementById("srcRegi_User_Numb").checked ? $("#searchText").val()  : "";
 	data.searchText = $("#searchText").val() ;
	$("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").trigger("reloadGrid");
}

function viewRow(rowid) {
	if( rowid != null ){
		var selrowContent = $("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
		var popurl        = "/board/noticeDetail.sys?board_No=" + selrowContent.board_No;
		var popproperty   = "dialogWidth:720px;dialogHeight=500px;scroll=auto;status=no;resizable=no;";
		
	    window.open(popurl, 'okplazaPop', 'width=720, height=510, scrollbars=yes, status=no, resizable=no');
	    
	}
	else{
		$( "#dialogSelectRow" ).dialog();
	}
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

<body class="subBg">
<div id="divWrap">
	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
	<!-- /header -->
	<hr>
	<div id="divBody">
		<div id="divSub">
			<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />            	<!--카테고리(S)-->


		<!--컨텐츠(S)-->
			<div id="AllContainer">
				<ul class="Tabarea">
					<li class="on">공지사항</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;"><a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a></div>
				<table class="InputTable">
					<colgroup>
						<col width="170px" />
						<col width="auto" />
					</colgroup>
					<tr>
						<th>
							<input id="srcTitle" name="srcTitle" type="checkbox" style="border: 0;vertical-align: middle;" />
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
			</div>
			<!--컨텐츠(E)-->
		</div>
        	<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>
</html>