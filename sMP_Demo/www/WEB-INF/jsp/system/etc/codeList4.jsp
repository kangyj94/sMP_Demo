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
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var subClickFlag = false;	//서브그리드의 더블클릭 시 메인그리드의 함수호출을 막기위한 플래그
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codeTypeListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['유형코드', '유형명','유형구분','사용여부', '유형설명', 'codeTypeId'],
		colModel:[
			{name:'codeTypeCd',index:'codeTypeCd', width:130,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//유형코드
			{name:'codeTypeNm',index:'codeTypeNm', width:150,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"30"}
			},//유형명
			{name:'codeFlag',index:'codeFlag', width:120,align:"center",search:false,sortable:true,
				editable:true,formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"0:시스템코드;1:사용자정의코드"}
			},//유형구분
			{name:'isUse',index:'isUse', width:80,align:"center",search:false,sortable:true,
				editable:true,formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부
			{name:'codeTypeDesc',index:'codeTypeDesc', width:500,align:"left",search:false,sortable:false,
				editable:true,formoptions:{rowpos:5,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				edittype:"textarea",editoptions:{rows:'3',cols:'40',maxLength:"100"}
			},//유형설명
			
			{name:'codeTypeId',index:'codeTypeId',hidden:true,search:false,key:true}//codeTypeId	
		],
		postData: {
			srcCodeTypeCd:$('#srcCodeTypeCd').val(),
			srcCodeTypeNm:$('#srcCodeTypeNm').val(),
			srcCodeFlag:$('#srcCodeFlag').val()
		},
		postData: {},subGrid: true,
		subGridOptions:{"plusicon":"ui-icon-triangle-1-e","minusicon":"ui-icon-triangle-1-s","openicon":"ui-icon-arrowreturn-1-e"},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'codeTypeId', sortorder: "desc",
		caption:"코드유형조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			if(!subClickFlag) {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")%>
			}
			subClickFlag = false;
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		subGridRowExpanded: function(subgrid_id,row_id) {
 			var data = {subgrid:subgrid_id, rowid:row_id};
			$("#"+jQuery.jgrid.jqID(subgrid_id)).load('<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codeTypesDetailInfo.sys',data);
		},
		subGridRowColapsed: function(subgrid_id, row_id) {
			var subgrid_table_id;
			subgrid_table_id = subgrid_id+"_t";
			$("#"+subgrid_table_id).remove();
		}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
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
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>상세그리드</td>
					<td align="right">
						<a href="#"><img id="srcButton"
									src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif"
									height="22"
									style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					</td>
				</tr>
			</table>
			
			<!-- Search Context -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">유형코드</td>
					<td class="table_td_contents">
						<input id="srcCodeTypeCd" name="srcCodeTypeCd" type="text" value="" size="20" maxlength="20"/>
					</td>
					<td class="table_td_subject" width="100">유형명</td>
					<td class="table_td_contents">
						<input id="srcCodeTypeNm" name="srcCodeTypeNm" type="text" value="" size="20" maxlength="30"/>
					</td>
					<td class="table_td_subject" width="100">코드구분</td>
					<td class="table_td_contents">
						<select name="srcCodeFlag" id="srcCodeFlag">
							<option value="">전체</option>
							<option value="0">시스템코드</option>
							<option value="1">사용자정의코드</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='8'></td>
				</tr>
			</table>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" valign="bottom">
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