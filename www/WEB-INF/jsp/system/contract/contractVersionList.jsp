<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-200 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function(){
	$("#srcButton").click(function(){ fnSearch(); });
	$("#regButton").click(function(){ regButton(); });//계약서 등록
	$("#modButton").click(function(){ fnModify(); });//계약서 수정
	$("#delButton").click(function(){ fnDelete(); });//계약서 삭제

});

function fnSearch() {
	
}

function regButton() {
	var popurl = "/system/systemContractReg.sys";
	var popproperty = "dialogWidth:720px;dialogHeight=700px;scroll=auto;status=no;resizable=no;";
	window.open(popurl, 'okplazaPop', 'width=720, height=700, scrollbars=yes, status=no, resizable=no');
}

/**
 * 계약서 수정
 */
function fnModify() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/system/systemContractReg.sys?contractNo="+selrowContent.contractNo;
		var popproperty = "dialogWidth:720px;dialogHeight=700px;scroll=auto;status=no;resizable=no;";
		window.open(popurl, 'okplazaPop', 'width=720, height=700, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function fnDetail() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/system/systemContractDetail.sys?contractNo="+selrowContent.contractNo;
		var popproperty = "dialogWidth:720px;dialogHeight=700px;scroll=auto;status=no;resizable=no;";
		window.open(popurl, 'okplazaPop', 'width=720, height=700, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

// function fnDelete() {
// 	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
// 	if( row != null ){
// 		if(!confirm("선택된 계약정보를 삭제 하시겠습니까?")){ return; }
// 		var selrowContent = jq("#list").jqGrid('getRowData',row);
// 		$.post(
// 			"/system/systemContractDelete.sys",
// 			{
// 				contractNo:selrowContent.contractNo
// 			},
// 			function (arg) {
// 				if(fnAjaxTransResult(arg)) {  //성공시
// 					fnReloadGrid()
// 				}else{
// 					fnReloadGrid();
// 				}
// 			}
// 		);
// 	}
// }


function fnDelete() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ) {
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		jq("#list").jqGrid( 
			'delGridRow', row,{
				url:"/system/systemContractDelete.sys?contractNo="+selrowContent.contractNo,
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

jq(function() {
	jq("#list").jqGrid({
		url:'/system/systemContractListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['번호','계약버전','계약구분','특별계약 구분','등록일','작성자'],
		colModel:[
			{name:'contractNo',index:'contractNo', width:50,align:"center",search:false,sortable:false,
				editable:false, key:true, editrules:{required:true}
			},//번호 
			{name:'contractVersion',index:'contractVersion', width:150,align:"center",search:false,sortable:false,
				editable:false
			},//계약버전
			{name:'contractClassify',index:'contractClassify', width:110,align:"center",search:false,sortable:false,
				editable:false
			},// 계약구분
			{name:'contractSpecial',index:'contractSpecial', width:150,align:"center",search:false,sortable:false,
				editable:false
			},//계약버전
			{name:'contractDate',index:'contractDate', width:110,align:"center",search:false,sortable:false,
				editable:false
			},//등록일
			{name:'contractUserNm',index:'contractUserNm', width:110,align:"center",search:false,sortable:false,
				editable:false
			}// 작성자
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: '', sortorder: '',
 		caption:"계약서 버전 리스트",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnDetail();")%>
		},	
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});

function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
	jq("#list").trigger("reloadGrid");
}

</script>
<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
</head>
<body>
<form>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left">
		<tr>
			<td>
				<!-- 타이틀 시작  -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="20" valign="middle">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
						</td>
						<td height="29" class='ptitle'>계약서 버전 관리</td>
						<td align="right">
							<a href="#">
								<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22"
								style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
							</a>
						</td>
					</tr>
				</table>
				<!-- 타이틀 끝  -->
			</td>
		</tr>
<!-- 		<tr> -->
<!-- 			<td colspan="6" height='1' bgcolor="eaeaea"></td> -->
<!-- 		</tr> -->
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" class="table_top_line"></td>
					</tr>
					<tr>
						<td colspan="2" height="1" bgcolor="eaeaea"></td>
					</tr>	
					<tr>
						<td class="table_td_subject" width="100">제목</td>
						<td class="table_td_contents">
							<input type="text" id="contractTitle" name="contractTitle" size="100">
						</td>
					</tr>
					<tr>
						<td colspan="2" class="table_top_line"></td>
					</tr>
					<tr>
						<td colspan="2"> &nbsp;</td>
					</tr>
					<tr>
						<td align="right" colspan="2">
							<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
							<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
							<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div id="jqGrid">
								<table id="list"></table>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>