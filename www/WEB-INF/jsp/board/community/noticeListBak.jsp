<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-215 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	 $("#srcButton").click( function() { fnSearch(); });
	 $("#viewButton").click( function() { fnView(); });
	 $("#regButton").click( function() { fnReg(); });
	 $("#modButton").click( function() { fnMod(); });
	 $("#delButton").click( function() { fnDel(); });
	 $("#colButton").click( function() { fnCol(); });
	 $("#excelButton").click( function() { fnExcel(); });
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/board/noticeListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['번호','제목','첨부파일갯수','등록일','작성자','조회수'],
		colModel:[
			{name:'board_No',index:'board_No', width:50,align:"center",search:false,sortable:false,
				editable:false
			},	//번호 
			{name:'title',index:'title', width:450,align:"left",search:false,sortable:false,
				editable:false
			},	//제목
			{name:'file_list_cnt',index:'file_list_cnt', width:80,align:"center",search:false,sortable:false,
				editable:false
			},	//첨부파일갯수
			{name:'regi_Date_Time',index:'regi_Date_Time', width:110,align:"center",search:false,sortable:true,
				editable:false
			},	// 등록일
			{name:'regi_User_Numb',index:'regi_User_Numb', width:110,align:"center",search:false,sortable:false,
				editable:false
			},	// 이름
			{name:'hit_No',index:'hit_No', width:60,align:"center",search:false,sortable:false,
				editable:false, 
			}	//조회수
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname:"board_No", sortorder:"desc",
		caption:"공지사항", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnView();")%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch(){
 	alert("조회!");
}

function fnView(){
 	alert("뷰!");
}

function fnReg(){
 	alert("등록!");
}

function fnMod(){
 	alert("수정!");
}

function fnDel(){
 	alert("삭제!");
}

function fnCol(){
 	alert("COL!");
}

function fnExcel(){
 	alert("엑셀!");
}
</script>
</head>
<body>
	<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
			<tr>
				<td bgcolor="#FFFFFF">
					<!-- 타이틀 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
							</td>
							<td height="29" class='ptitle'>공지사항</td>
							<td align="right">
								<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0; cursor:pointer; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
							</td>
						</tr>
					</table>
					<!-- Search Context -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="2" class="table_top_line"></td>
						</tr>
						<tr>
							<td colspan="2" height='1'></td>
						</tr>
						<tr>
							<td class="table_td_subject">
								<input type="checkbox" />제목
								<input type="checkbox" />내용
								<input type="checkbox" />작성자
							</td>
							<td class="table_td_contents">
								<input type="text"></input>
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
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="right" valign="bottom">
								<img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0; cursor:pointer; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
								<img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0; cursor:pointer; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
								<img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0; cursor:pointer; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
								<img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0; cursor:pointer; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
								<img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0; cursor:pointer; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
								<img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0; cursor:pointer; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
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
					<div id="dialog" title="Feature not supported" style="display: none;">
						<p>That feature is not supported.</p>
					</div>
				</td>
			</tr>
		</table>
		<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
			<p>처리할 데이터를 선택 하십시오!</p>
		</div>
	</form>
</body>
</html>