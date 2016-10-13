<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "";
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-221 + Number(gridHeightResizePlus)"+categoryHeightMinus;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcTitle").attr('checked', true);
	$("#searchText").keydown(function(e){
		if(e.keyCode==13) {
			$("#schButton").click();}
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
	$("#viewButton").click( function() { viewRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
});
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'/board/selectNoticeList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['번호 시퀀스','번호','제목','첨부개수','등록일', '작성자', '조회수'],
		colModel:[
			{name:'board_No',index:'board_No', width:50,align:"center",search:false,sortable:true,
				editable:false, key:true, editrules:{required:true}, hidden:true},													//번호 시퀀스
			{name:'num',index:'num', width:50,align:"center",search:false,sortable:true,editable:false},							//로우넘번호
			{name:'title',index:'title', width:450,align:"left",search:false,sortable:true,	editable:false},						//제목
			{name:'file_list_cnt',index:'file_List_cnt', width:70,align:"center",search:false,sortable:false,editable:false},		//첨부파일갯수
			{name:'regi_Date_Time',index:'regi_Date_Time', width:110,align:"center",search:false,sortable:true,editable:false},		// 등록일
			{name:'regi_User_Numb',index:'regi_User_Numb', width:110,align:"center",search:false,sortable:true,	editable:false},	// 작성자
			{name:'hit_No',index:'hit_No', width:60,align:"center",search:false,sortable:true,editable:false}						//조회수
		],
		postData: {
			srcBoardBorgType:"ADM",
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'board_No', sortorder: "desc",
		caption:"공지사항", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});

//그리드 조회
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcTitle = document.getElementById("srcTitle").checked ? document.getElementById("searchText").value : "";
	data.srcMessage = document.getElementById("srcMessage").checked ? document.getElementById("searchText").value : "";
	data.srcRegi_User_Numb = document.getElementById("srcRegi_User_Numb").checked ? document.getElementById("searchText").value : "";
	data.searchText = $("#searchText").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

//상세보기
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);
		var popurl = "/board/noticeDetail.sys?board_No=" + selrowContent.board_No;
		window.open(popurl, 'okplazaPop', 'width=720, height=500, scrollbars=yes, status=no, resizable=no');
	}else{
		jq( "#dialogSelectRow" ).dialog();
	}
}

//엑셀출력
function exportExcel() {
	var colLabels = ['번호','제목','첨부개수','등록일','작성자','조회수'];	//출력컬럼명
	var colIds = ['board_No','title','file_list_cnt','regi_Date_Time','regi_User_Numb','hit_No'];	//출력컬럼ID
	var numColIds = ['board_No','hit_No','file_list_cnt'];	//숫자표현ID
	var sheetTitle = "공지사항";	//sheet 타이틀
	var excelFileName = "NoticeList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>


</head>
<body>
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>공지사항</td>
					<td align="right">
						<a href="#">
							<img id="srcButton" src="/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
						</a>
					</td>
				</tr>
			</table>
			<!-- Search Context -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="200">
						<table border="0">
							<tr>
								<td><input id="srcTitle" name="srcTitle" type="checkbox" style="border: 0" /></td>
								<td>제목</td>
								<td><input id="srcMessage" name="srcMessage" type="checkbox" style="border: 0" /></td> 
								<td>내용</td>
								<td><input id="srcRegi_User_Numb" name="srcRegi_User_Numb" type="checkbox" style="border: 0" /></td> 
								<td>이름</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents">
						<input id="searchText" name="searchText" type="text" value="" size="100" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td colspan="2" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="2" height='8'></td>
				</tr>
			</table>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" valign="bottom">
						<a href="#"><img id="viewButton" src="/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="colButton" src="/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="excelButton" src="/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					</td>
				</tr>
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
</body>
</html>