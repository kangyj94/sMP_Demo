<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="java.util.List"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "";
	
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-390 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";
	String businessNum = "";
	if("XXXXXXXXXX".equals(loginUserDto.getLoginId())){
		businessNum = loginUserDto.getBorgNm();
	}else{
		if("BUY".equals(loginUserDto.getSvcTypeCd())){
			businessNum = loginUserDto.getSmpBranchsDto().getBusinessNum();
		}
		if("VEN".equals(loginUserDto.getSvcTypeCd())){
			businessNum = loginUserDto.getSmpVendorsDto().getBusinessNum();
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>


<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#subject").keydown(function(e){if(e.keyCode==13) {
		$("#schButton").click();}
	});
	$("#srcButton").click( function() { fnSearch(); });
	
	$("#regButton").click( function() { regist(); });
	$("#modButton").click( function() { modify(); });
	$("#delButton").click( function() { deleteRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
// 	$("#excelButton").click(function(){ exportExcel(); });
	
	//화면관련 이벤트
	$("#participationDetailPop").hide();
	
});
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight%>);
	$("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');
</script>
<script type="text/javascript">

//글작성
function regist(){
	var popurl = "/board/participationReg.sys?_menuId=<%=_menuId%>";
	var popproperty = "width=830,height=710,scrollbars=yes,status=no,resizable=no;";
	var win =  window.open(popurl,'window',popproperty);
	win.focus();
}

//글수정
function modify(){
	var rowId = $("#list").getGridParam("selrow");
	if(rowId == null){
		alert("수정하실 글의 로우를 선택 해주세요.");
	}else{
		var selrowContent = $("#list").jqGrid("getRowData", rowId);
		var popurl = "/board/participationReg.sys?participationNo="+selrowContent.PARTICIPATION_NO+"&_menuId=<%=_menuId%>";
		var popproperty = "width=830,height=710,scrollbars=yes,status=no,resizable=no;";
		var win =  window.open(popurl,'window',popproperty);
		win.focus();
	}
	
}

//글 상세 페이지
function participationDetail(participationNo){
	var participationFrm = $("#participationFrm");
	with(participationFrm){
		var businessNum	= "<%=businessNum%>";
		var _menuId		= "<%=_menuId%>";
		find("input[name=participationNo]").val(participationNo);
		find("input[name=businessNum]").val(businessNum);
		find("input[name=_menuId]").val(_menuId);
		attr("action","/board/participationDetail.sys");
		submit();
	}
}

function deleteRow(){
	var rowId = $("#list").getGridParam("selrow");
	if(rowId == null){
		alert("삭제하실 글의 로우를 선택 해주세요.");
	}else{
		if(!confirm("삭제 하시겠습니까?")) return;
		var selrowContent = $("#list").jqGrid("getRowData", rowId);
		$.post(
				"/board/deleteParticipation.sys",
			{
				participationNo:selrowContent.PARTICIPATION_NO
			},
			function(arg){
				if(fnAjaxTransResult(arg)){
					$("#list").trigger("reloadGrid");
				}
			}
		);
	}
}

//그리드 리로디드
function fnReLoadDataGrid(){
	$("#list").trigger("reloadGrid");
}
</script>


<script type="text/javascript">
//그리드 관련
jq(function() {
	jq("#list").jqGrid({
		url:'/board/selectParticipationList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[
					'번호','구분','공고','내용','첨부개수','등록일','작성자ID','작성자','BOARD_NO','classify','FILE_LIST1','FILE_LIST2',
					'ATTACH_FILE_NAME1','ATTACH_FILE_NAME2','ATTACH_FILE_PATH1','ATTACH_FILE_PATH2'
		],
		colModel:[
			{name:'NUM',index:'NUM', width:50,align:"center",search:false,sortable:true, editable:false},											//번호
			{name:'CLASSIFY_NM',index:'CLASSIFY_NM', width:80,align:"center",search:false,sortable:true, editable:false},							//구분명
			{name:'SUBJECT',index:'SUBJECT', width:500,align:"left",search:false,sortable:true, editable:false},									//공고
			{name:'CONTENT',index:'CONTENT', width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },						//내용
			{name:'FILE_CNT',index:'FILE_CNT', width:150,align:"center",search:false,sortable:true, editable:false},								//첨부개수
			{name:'INSERT_DATE',index:'INSERT_DATE', width:110,align:"center",search:false,sortable:true, editable:false},							//등록일
			{name:'INSERT_USER_ID',index:'INSERT_USER_ID', width:150,align:"center",search:false,sortable:true, editable:false, hidden:true},		//작성자id
			{name:'INSERT_USER_NM',index:'INSERT_USER_NM', width:150,align:"center",search:false,sortable:true, editable:false, hidden:true},		//작성자 이름
			{name:'PARTICIPATION_NO',index:'PARTICIPATION_NO', width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },	//BOARD_NO
			{name:'CLASSIFY',index:'CLASSIFY', width:80,align:"center",search:false,sortable:true, editable:false, hidden:true},									//구분
			{name:'FILE_LIST1',index:'FILE_LIST1', width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },				//FILE_LIST1
			{name:'FILE_LIST2',index:'FILE_LIST2', width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },				//FILE_LIST2
			{name:'ATTACH_FILE_NAME1',index:'ATTACH_FILE_NAME1', width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },	//ATTACH_FILE_NAME1
			{name:'ATTACH_FILE_NAME2',index:'ATTACH_FILE_NAME2', width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },	//ATTACH_FILE_NAME2
			{name:'ATTACH_FILE_PATH1',index:'ATTACH_FILE_PATH1', width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },	//ATTACH_FILE_PATH1
			{name:'ATTACH_FILE_PATH2',index:'ATTACH_FILE_PATH2', width:60,align:"center",search:false,sortable:true, editable:false, hidden:true } 	//ATTACH_FILE_PATH2
		],  
		postData: {
			subject:$("#subject").val()
		},
		rowNum:0, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		sortname: "AA.PARTICIPATION_NO", sortorder: "DESC", 
		height: <%=listHeight%>,width:<%=listWidth%>,
		caption:"첨여 게시판", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
		loadComplete: function() { 
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var i=0; i<rowCnt; i++){
				var rowid = $("#list").getDataIDs()[i];
				$("#list").setCell(rowid,'SUBJECT','',{color:'#0000ff'});
				$("#list").setCell(rowid,'SUBJECT','',{cursor: 'pointer'});
			}
		},
		afterInsertRow: function(rowid, aData){ },
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined && colName['index']=="SUBJECT") {
				participationDetail(selrowContent.PARTICIPATION_NO);
			}
		},
		loadError : function(xhr, st, str){ alert("에러가 발생하였습니다."); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.subject = $("#subject").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
</script>
</head>

<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<body>
	<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td bgcolor="#FFFFFF">
				<!-- 타이틀 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif"width="14" height="15" />
						</td>
						<td height="29" class='ptitle'>참여게시판</td>
						<td align="right" class='ptitle'>
							<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
						</td>
					</tr>
					<tr><td height="1"></td></tr>
				</table> <!-- Search Context -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" class="table_top_line"></td>
					</tr>
					<tr>
						<td colspan="2" height='1'></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">
							<table>
								<tr>
									<td>공고</td>
								</tr>
							</table>
						</td>
						<td class="table_td_contents">
							<input id="subject" name="subject" type="text" value="" size="100" maxlength="30" />
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
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="right" valign="bottom">
					<%	if("ADM".equals(loginUserDto.getSvcTypeCd())){%>
							<button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
							<button id='modButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 수정</button>
							<button id='delButton' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash-o"></i> 삭제</button>
					<%	}%>
						</td>
					</tr>
					<tr><td height="1"></td></tr>
					<tr>
						<td>
							<div id="jqgrid">
								<table id="list"></table>
								<div id="pager"></div>
							</div>
						</td>
					</tr>
				</table>
				<div id="dialog" title="Feature not supported"
					style="display: none;">
					<p>That feature is not supported.</p>
				</div>
			</td>
		</tr>
	</table>
	<div id="dialogSelectRow" title="Warning"
		style="display: none; font-size: 12px; color: red;">
		<p>처리할 데이터를 선택 하십시오!</p>
	</div>
	<form id="participationFrm" name="participationFrm" target="frameMain">
		<input type="hidden" id="participationNo" name="participationNo" value="" />
		<input type="hidden" id="businessNum" name="businessNum" value="" />
		<input type="hidden" id="_menuId" name="_menuId" value="" />
	</form>
	<%-- <%@ include file="/WEB-INF/jsp/board/participation/participationReg.jsp" %> --%>
</body>
</html>