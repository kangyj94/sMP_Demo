<!-- 사용하지않는페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="java.util.List"%>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-215 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	String board_Type = (String)request.getAttribute("board_Type");
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcTitle").attr('checked', true);
	$("#searchText").keydown(function(e){if(e.keyCode==13) {
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
	$("#regButton").click( function() { regist(); });
	$("#modButton").click( function() { modify(); });
	$("#delButton").click( function() { deleteRow(); });
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/board/boardListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['번호','제목','첨부개수','등록일','작성자','조회수','Lev'],
		colModel:[
			{name:'board_No',index:'board_No', width:50,align:"center",search:false,sortable:false,
				editable:false, key:true, editrules:{required:true}
			},	//번호 
			{name:'title',index:'title', width:450,align:"left",search:false,sortable:false,
				editable:false, formatter:image1
			},	//제목
			{name:'file_list_cnt',index:'file_list_cnt', width:70,align:"center",search:false,sortable:false,
				editable:false
			},	//첨부개수
			{name:'regi_Date_Time',index:'regi_Date_Time', width:110,align:"center",search:false,sortable:false,
				editable:false
			},	// 등록일
			{name:'regi_User_Numb',index:'regi_User_Numb', width:110,align:"center",search:false,sortable:false,
				editable:false
			},	// 작성자
			{name:'hit_No',index:'hit_No', width:60,align:"center",search:false,sortable:false,
				editable:false 
			},//조회수
			{name:'Lev',index:'Lev', width:60,align:"center",search:false,sortable:false,
				editable:false ,hidden:true
			}//조회수
		],
		postData: { 
 			board_Type:"<%=board_Type%>" 
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: '', sortorder: '',
 		caption:"자료실",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},	
		ondblClickRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if (selrowContent.regi_User_Numb == "<%=userInfoDto.getUserNm()%>") {			
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","modify();")%>
		 	} else { 
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")%>
		 	}
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcTitle = document.getElementById("srcTitle").checked ? document.getElementById("searchText").value : "";
	data.srcMessage = document.getElementById("srcMessage").checked ? document.getElementById("searchText").value : "";
 	data.srcRegi_User_Numb = document.getElementById("srcRegi_User_Numb").checked ? document.getElementById("searchText").value : "";
 	data.searchText = document.frmFile.searchText.value;
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/board/boardDetail.sys?board_No=" + selrowContent.board_No;
		var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
	    window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function regist(){
	var popurl = "/board/boardWrite.sys?board_Type=<%=board_Type%>";
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
	//window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}

function modify(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/board/boardWrite.sys?board_No=" + selrowContent.board_No;
		var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
		//window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function deleteRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ) {
		jq("#list").jqGrid( 
			'delGridRow', row,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/board/boardTransGrid.sys",
				recreateForm: true,beforeShowForm: function(form) {
					jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
					jq('#pData').hide(); jq('#nData').hide();  
				},
				reloadAfterSubmit:true,closeAfterDelete: true,
				afterSubmit: function(response, postdata){
					return fnJqTransResult(response, postdata);
				}
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
	jq("#list").trigger("reloadGrid");
}

<%
/**
 * 답변에 뿌려질 그림 데이터
 */
%>
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
  	return space2;
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['번호','제목','등록일','작성자','조회수'];	//출력컬럼명
	var colIds = ['board_No','title','regi_Date_Time','regi_User_Numb','hit_No'];	//출력컬럼ID
	var numColIds = ['board_No','hit_No'];	//숫자표현ID
	var sheetTitle = "게시판";	//sheet 타이틀
	var excelFileName = "List";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>
<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
<% if(board_Type.equals("0103")){ %>
					<td height="29" class='ptitle'>자료실</td>
<% } else if(board_Type.equals("0201")) { %>
					<td height="29" class='ptitle'>게시판</td>
<% } else if(board_Type.equals("0202")) { %>
				<td height="29" class='ptitle'>자재관련문의</td>
<% }%>
					<td align="right">
						<a href="#">
							<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22"
							style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
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
						<table>
							<tr>
								<td><input id="srcTitle" name="srcTitle" type="checkbox" style="border:0px;" /></td>
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
					<% if("ADM".equals(userInfoDto.getSvcTypeCd())) { %> 
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<%} else if(!"ADM".equals(userInfoDto.getSvcTypeCd()) && "0103".equals(board_Type)) { %> 
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<%}	else if("regi_User_Numb".equals(userInfoDto.getLoginId())) {	%>
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<% } else if(!"regi_User_Numb".equals(userInfoDto.getLoginId())) {	%>
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<%} %>
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
</form>
</body>
</html>