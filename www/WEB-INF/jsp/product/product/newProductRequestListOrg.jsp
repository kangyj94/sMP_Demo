<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-268 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#detButton").click( function() { detail(); });
});
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['상품명','상품규격','요청일자','예상매입단가','진행상태','입찰번호','등록조직','등록자'],
		colModel:[
			{name:'상품명',index:'상품명',width:180,align:"center",search:false,sortable:true, editable:false },
			{name:'상품규격', index:'상품규격',width:180,align:"center",search:false,sortable:true, editable:false },
			{name:'요청일자',index:'요청일자',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'예상매입단가',index:'예상매입단가',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'진행상태',index:'진행상태',width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'입찰번호',index:'입찰번호',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'등록조직',index:'등록조직',width:180,align:"center",search:false,sortable:true, editable:false },
			{name:'등록자',index:'등록자',width:80,align:"center",search:false,sortable:true, editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: '', sortorder: '',
		caption:"상품조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function detail(){
	var popurl = "/product/newProductRequestDetail.sys";
	var popproperty = "dialogWidth:900px;dialogHeight=250px;scroll=yes;status=no;resizable=no;";
// 	window.showModalDialog(popurl,null,popproperty);
	window.open(popurl, 'okplazaPop', 'width=900, height=250, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>

<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">고객사상품등록요청</td>
				<td align="right" class="ptitle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width:65px;height:22px;" /></td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="4" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">고객사</td>
				<td class="table_td_contents">
					<input id="srcLoginId4" name="srcLoginId4" type="text" value="" size="" maxlength="50" style="width:375px" />
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;" align="middle"/></td>
				<td class="table_td_subject" width="150">요청일자
					<select id="srcIsDefault2" name="srcIsDefault2" class="select">
						<option>선택하세요</option>
					</select></td>
				<td class="table_td_contents">
					<select id="srcIsDefault3" name="srcIsDefault3" class="select">
						<option>선택하세요</option>
					</select> ~
					<select id="srcIsDefault4" name="srcIsDefault4" class="select">
						<option>선택하세요</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품명</td>
				<td class="table_td_contents">
					<input id="srcLoginId" name="srcLoginId" type="text" value="" size="" maxlength="50" style="width:400px" /></td>
				<td class="table_td_subject">진행상태</td>
				<td class="table_td_contents">
					<select id="srcIsDefault" name="srcIsDefault" class="select">
						<option>선택하세요</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품규격</td>
				<td colspan="3" class="table_td_contents">
					<input id="srcLoginId" name="srcLoginId" type="text" value="" size="" maxlength="50" style="width:400px" /></td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="4" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
	</td>
</tr>
<tr>
	<td height="27px" align="right" valign="bottom">
		<a href="#"><span id="detButton">고객사상품등록요청조회상세</span></a>
		<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
		<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
		<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
		<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
		<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
		<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
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
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<!-------------------------------- Dialog Div Start -------------------------------->
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>