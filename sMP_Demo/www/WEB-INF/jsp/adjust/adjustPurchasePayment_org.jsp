<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-255 + Number(gridHeightResizePlus)";
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
		colNames:['선택','공급사','매입확정일자','매입금액','부가세','합계','출금금액','미지급금액','전송상태','SAP전표번호','전송일자','전자세금계산서','거래명세서'],
		colModel:[
			{name:'선택',index:'선택',width:30,align:"center",search:false,sortable:true, editable:false },
			{name:'공급사', index:'공급사',width:160,align:"center",search:false,sortable:true, editable:false },
			{name:'매입확정일자',index:'매입확정일자',width:160,align:"center",search:false,sortable:true, editable:false },
			{name:'매입금액',index:'매입금액',width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'부가세',index:'부가세',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'합계',index:'합계',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'출금금액', index:'출금금액',width:160,align:"center",search:false,sortable:true, editable:false },
			{name:'미지급금액',index:'미지급금액',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'전송상태',index:'전송상태',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'SAP전표번호',index:'SAP전표번호',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'전송일자',index:'전송일자',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'전자세금계산서',index:'전자세금계산서',width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'거래명세서',index:'거래명세서',width:70,align:"center",search:false,sortable:true, editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: '', sortorder: '',
		caption:"매입지급처리", 
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
				<td height="29" class="ptitle">매입지급처리</td>
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
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">공급사</td>
				<td class="table_td_contents">
					<input id="srcLoginId" name="srcLoginId" type="text" value="" size="20" maxlength="30" />
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;" align="middle" class="icon_search" /></td>
				<td class="table_td_subject" width="100">지급여부</td>
				<td class="table_td_contents">
					<select id="srcIsDefault3" name="srcIsDefault3" class="select">
						<option>선택하세요</option>
					</select></td>
				<td class="table_td_subject" width="100">매입확정일자</td>
				<td class="table_td_contents">
					<select id="srcIsDefault" name="srcIsDefault" class="select">
						<option>선택하세요</option>
					</select> ~
					<select id="srcIsDefault2" name="srcIsDefault2" class="select">
						<option>선택하세요</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">사업자등록번호</td>
				<td colspan="5" class="table_td_contents">
					<input id="srcLoginId2" name="srcLoginId3" type="text" value="" size="20" maxlength="30" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
	</td>
</tr>
<tr>
	<td height="40px" align="right" valign="bottom">
		<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_withdrawConfirm.gif" style="width:75px;height:22px;" />
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