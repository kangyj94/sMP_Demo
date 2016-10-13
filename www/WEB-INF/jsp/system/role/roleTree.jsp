<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	int listWidth = 300;
	String listHeight	= "$(window).height()-300 + Number(gridHeightResizePlus)";
	String list2Height	= "$(window).height()-320 + Number(gridHeightResizePlus)";
	String list2Width	= "1185";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#viewButton").click( function() { viewRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
});
	
$(window).bind('resize', function() { 
	$("#treeList").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(<%=list2Width%>);
	$("#list").setGridHeight(<%=list2Height %>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var staticNum = 0;	//list 그리드를 한번만 초기화하기 위해
jq(function() {
	jq("#treeList").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/roleTreeJQGrid.sys',
		datatype: "json",
		mtype: "POST",
	   	colNames:["권한/영역 명","구분","key","level"],
	   	colModel:[
	   		{name:'name',index:'name', width:230,sortable:false},
	   		{name:'typeName',index:'typeName', width:50, align:"center",sortable:false},
	   		
	   		{name:'treeKey',index:'treeKey', hidden:true, key:true},
	   		{name:'level',index:'level', hidden:true}
	   	],
	   	rowNum:0, rownumbers: false, 
	   	treeGridModel:'adjacency',
	   	height:<%=listHeight%>, width:<%=listWidth%>,
	   	treeGrid: true, hoverrows: false,
		ExpandColumn : 'name',ExpandColClick: true,
		caption: "권한 및 영역",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		jsonReader : { root: "list", repeatitems: false, cell: "cell" },
		loadComplete: function() {
			if(staticNum==0) {
				fnInitList(0,"메뉴정보");
				staticNum++;
			}
		},
		loadError : function(xhr, st, str){ $("#treeList").html(xhr.responseText); },
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#treeList").jqGrid('getRowData',rowid);
			var treeKey = selrowContent.treeKey;
			var srcSelName = selrowContent.name;
			var srcSrcFlag = treeKey.split("∥")[0];
			var srcId = treeKey.split("∥")[1];
			var connectServiceNm = "<font color='blue'>["+srcSelName+"]</font>과 <font color='red'>연결된</font> 메뉴정보";
			fnOnClickList(srcId, connectServiceNm, srcSrcFlag);
		}
	});
});
function fnInitList(srcId, connectServiceNm) {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/roleMenuListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['메뉴명','메뉴코드','메뉴고정여부','화면권한명','화면권한코드','menuLevel'],
		colModel:[
			{name:'menuNm',index:'menuNm', width:150,align:"left",search:false,sortable:false,formoptions:{rowpos:1}},//메뉴명
			{name:'menuCd',index:'menuCd', width:100,align:"left",search:false,sortable:false,formoptions:{rowpos:2}},//메뉴코드
			{name:'isFixed',index:'isFixed', width:70,align:"center",search:false,sortable:false,
				editable:false,edittype:"select",formoptions:{rowpos:3},
				formatter:"select",editoptions:{value:"0:아니오;1:예"}
			},//고정여부
			{name:'activityNm',index:'activityNm', width:150,align:"left",search:false,sortable:false,formoptions:{rowpos:4}},//화면권한명
			{name:'activityCd',index:'activityCd', width:210,align:"left",search:false,sortable:false,formoptions:{rowpos:5}},//화면권한코드
			{name:'menuLevel',index:'menuLevel',hidden:true,search:false}//menuLevel
		],
		postData: { srcId:srcId, srcSrcFlag:"" },
		rowNum:0, rownumbers:false, 
		height:<%=list2Height%>, width: <%=list2Width%>, 
		caption:connectServiceNm, 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		afterInsertRow: function(rowid, aData){
			var joinImage = "";
			if(Number(aData.menuLevel)>0) {
				for(var i=1;i<Number(aData.menuLevel);i++) {
					joinImage += "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/empty.gif' style='vertical-align: bottom;'/>";
				}
				joinImage += "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/joinbottom.gif' style='vertical-align: bottom;'/>";
			}
			$("#list").setCell(rowid,'menuNm',joinImage+aData.menuNm);
		},
		onSelectRow:function(rowid, iRow, iCol, e){
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell" }
	});
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function fnOnClickList(srcId, connectServiceNm, srcSrcFlag) {
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcId = srcId;
	data.srcSrcFlag = srcSrcFlag;
	jq("#list").jqGrid("setCaption", connectServiceNm);
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['메뉴명','메뉴코드','화면권한명','화면권한코드'];	//출력컬럼명
	var colIds = ['menuNm','menuCd','activityNm','activityCd'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "영역과 연결된 메뉴정보";	//sheet 타이틀
	var excelFileName = "ConnectMenuList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm">
<table width="1500px" style="margin-bottom: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>권한 메뉴 조회</td>
				</tr>
			</table>
			<table width="1500px" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
				<col width="200" />
				<col />
				<col width="100%"/>
				<tr>
					<td>
						<div id="jqgrid">
							<table id="treeList"></table>
						</div>
					</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						<table width="100%" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									* 좌측의 권한/영역을 선택하시면 연결된 메뉴정보을 보실 수 있습니다.
								</td>
								<td align="right">
									<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<div id="jqgrid">
										<table id="list"></table>
									</div>
								</td>
							</tr>
						</table>
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