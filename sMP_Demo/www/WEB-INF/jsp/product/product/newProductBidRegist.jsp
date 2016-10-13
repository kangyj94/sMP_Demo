<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-524 + Number(gridHeightResizePlus)";
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
		colNames:['공급사명','공급사코드','등록일','대표자','담당자','담당자연락처'],
		colModel:[
			{name:'공급사명',index:'공급사명',width:400,align:"center",search:false,sortable:true, editable:false },
			{name:'공급사코드', index:'공급사코드',width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'등록일',index:'등록일',width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'대표자',index:'대표자',width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'담당자',index:'담당자',width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'담당자연락처',index:'담당자연락처',width:120,align:"center",search:false,sortable:true, editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: '', sortorder: '',
		caption:"대표상품정보", 
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
				<td height="29" class="ptitle">입찰생성</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height: 27px" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">입찰품목 카테고리</td>
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
				<td colspan="2" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="2" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">상품카테고리</td>
				<td colspan="5" class="table_td_contents">
					<input id="srcLoginId4" name="srcLoginId4" type="text" value="" size="" maxlength="50" style="width:400px" class="blue" />
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_inquiry.gif" style="width:40px;height:18px;" align="middle" class="icon_search" /></td>
			</tr>
			<tr>
				<td colspan="2" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="2" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif"style="width:5px;height:5px;" class="bullet_stitle"/></td>
				<td class="stitle">대표상품정보</td>
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
				<td class="table_td_subject" width="100">입찰명</td>
				<td class="table_td_contents">
					<input id="srcLoginId3" name="srcLoginId3" type="text" value="" size="20" maxlength="30" /></td>
				<td class="table_td_subject" width="100">입찰상태</td>
				<td class="table_td_contents">
					<select class="select_none" id="srcIsDefault" name="srcIsDefault">
						<option>선택하세요</option>
					</select></td>
				<td class="table_td_subject" width="100">입찰번호</td>
				<td class="table_td_contents">
					<input id="srcLoginId10" name="srcLoginId10" type="text" value="" size="20" maxlength="30" class="input_text_none" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">대표품목명</td>
				<td colspan="3" class="table_td_contents">
					<input id="srcLoginId19" name="srcLoginId19" type="text" value="" size="20" maxlength="30" /></td>
				<td class="table_td_subject">입찰종료일자</td>
				<td class="table_td_contents">
					<select class="select" id="srcIsDefault3" name="srcIsDefault3">
						<option>선택하세요</option>
					</select>
					<select class="select" id="srcIsDefault3" name="srcIsDefault3">
						<option>00</option>
					</select>시
					<select class="select" id="srcIsDefault3" name="srcIsDefault3">
						<option>00</option>
					</select>분</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">대표규격</td>
				<td colspan="3" class="table_td_contents">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>Φ
								<input id="srcLoginId" name="srcLoginId" type="text" value="" size="5" maxlength="5" /></td>
							<td>W
								<input id="srcLoginId2" name="srcLoginId2" type="text" value="" size="5" maxlength="5" /></td>
							<td>D
								<input id="srcLoginId5" name="srcLoginId5" type="text" value="" size="5" maxlength="5" /></td>
							<td>H
								<input id="srcLoginId6" name="srcLoginId6" type="text" value="" size="5" maxlength="5" /></td>
							<td>L
								<input id="srcLoginId7" name="srcLoginId7" type="text" value="" size="5" maxlength="5" /></td>
							<td>기타
								<input id="srcLoginId8" name="srcLoginId8" type="text" value="" size="5" maxlength="5" /></td>
						</tr>
					</table></td>
				<td class="table_td_subject">희망가격</td>
				<td class="table_td_contents">
					<input id="srcLoginId9" name="srcLoginId9" type="text" value="" size="20" maxlength="30" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">요청사항</td>
				<td colspan="5" class="table_td_contents4">
					<textarea name="textarea" id="textarea" cols="45" rows="10" style="width:730px; height:50px"></textarea></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">첨부파일</td>
				<td colspan="3" class="table_td_contents">
					<span class="table_td_contents"><input type="file" name="fileField" id="fileField" style="width:400px;" /></span></td>
				<td class="table_td_subject">투찰시 공인인증서 사용여부</td>
				<td class="table_td_contents">
					<select class="select" id="srcIsDefault3" name="srcIsDefault3">
						<option>선택하세요</option>
					</select></td>
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
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">대표상품정보</td>
				<td height="17px" align="right" valign="bottom">
					<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
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
<tr>
	<td align="center"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_bidCreate.gif" style="width:85px;height:23px;" /></td>
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