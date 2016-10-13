<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	int listWidth = 285;
	String listHeight  = "$(window).height()-300 + Number(gridHeightResizePlus)";
	String list2Height = "$(window).height()-425 + Number(gridHeightResizePlus)";
	String list2Width  = "1200";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	//조직허용범위리스트
	List<CodesDto> borgScopeList = (List<CodesDto>)request.getAttribute("borgScopeList");
	String borgScopeArrayString = "";
	for(CodesDto codesDto : borgScopeList) {
		if("".equals(borgScopeArrayString)) borgScopeArrayString = codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
		else borgScopeArrayString +=  ";" + codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<%
/**------------------------------------사용자팝업 사용방법---------------------------------
* fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* userNm : 찾고자하는 사용자명
* loginId : 찾고자하는 사용자 Login Id
* svcTypeCd : 찾는사용자의 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영자)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(사용자일련번호, 조직일련번호, 서비스유형명, 사용자명, 로그인아이디, 조직명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#regButton").click(function(){
		var treeRow = $("#treeList").jqGrid('getGridParam','selrow');
		if(treeRow==null) { alert("좌측의 권한이 선택되지 않았습니다.\n사용자추가는 선택된 권한의 사용자추가 입니다."); return; }
		var selrowContent = $("#treeList").jqGrid('getRowData',treeRow);
		var svcTypeCd = selrowContent.svcTypeCd;
		if(svcTypeCd=="") { alert("좌측의 권한이 선택되지 않았습니다.\n사용자추가는 선택된 권한의 사용자추가 입니다."); return; }

		fnJqmUserInitSearch("", "", svcTypeCd, "fnSelectUserCallback");
	});
});
/**
 * 사용자검색 Callback Function
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	var treeRow = $("#treeList").jqGrid('getGridParam','selrow');
	if(treeRow==null) { alert("좌측의 권한이 선택되지 않았습니다.\n사용자추가는 선택된 권한의 사용자추가 입니다."); return; }
	var selrowContent = jq("#treeList").jqGrid('getRowData',treeRow);
	var roleId = selrowContent.treeKey;
	var svcTypeCd = selrowContent.svcTypeCd;
	var borgScopeCd = selrowContent.borgScopeCd;
	if(svcTypeCd=="") { alert("좌측의 권한이 선택되지 않았습니다.\n사용자추가는 선택된 권한의 사용자추가 입니다."); return; }
	var borgScopeArray = "";
<%	
	for(CodesDto codesDto : borgScopeList) {
		String borgScopeCd = codesDto.getCodeVal1();
		String borgScopeNm = codesDto.getCodeNm1();
%>
	if(svcTypeCd!="BUY") {	//고객사가 아닌조직은 기본Scope을 가져감
		if(Number(borgScopeCd)==Number("<%=borgScopeCd%>")) {
			borgScopeArray = "<%=borgScopeCd%>:<%=borgScopeNm%>";
		}
	} else {
		if(Number(borgScopeCd) >= Number("<%=borgScopeCd%>")) {
			if(borgScopeArray=="") borgScopeArray = "<%=borgScopeCd%>:<%=borgScopeNm%>";
			else borgScopeArray += ";<%=borgScopeCd%>:<%=borgScopeNm%>";
		}
	}
<%	}	%>
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/roleMemberCheck.sys", 
		{ roleId:roleId, userId:userId, borgId:borgId },
		function(arg){ 
			var result = eval('(' + arg + ')').customResponse;
			if (result.success == false) {
				alert("이미 등록된 사용자입니다.");
			} else {
				addRow(borgScopeArray, roleId, userId, borgId, svcTypeNm, userNm, loginId, borgNms);
				$('#dialogPop').jqmHide();
			}
		}
	);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
	$("#srcUserNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcLoginId").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click(function(){
		$("#srcUserNm").val($.trim($("#srcUserNm").val()));
		$("#srcLoginId").val($.trim($("#srcLoginId").val()));
		
		fnSearch();
	});
	$("#viewButton").click( function() { viewRow(); });
	$("#modButton").click( function() { 
		var rowid = jq("#list").jqGrid('getGridParam','selrow');
		if(rowid==null) { alert("사용자을 선택해 주십시오!"); return; }
		var selrowContent = jq("#list").jqGrid('getRowData',rowid);
		var roleId = selrowContent.roleId;
		var userId = selrowContent.userId;
		var borgId = selrowContent.borgId;
		editRow(roleId, userId, borgId); 
	});
	$("#delButton").click( function() { 
		var rowid = jq("#list").jqGrid('getGridParam','selrow');
		if(rowid==null) { alert("사용자을 선택해 주십시오!"); return; }
		var selrowContent = jq("#list").jqGrid('getRowData',rowid);
		var roleId = selrowContent.roleId;
		var userId = selrowContent.userId;
		var borgId = selrowContent.borgId;
		deleteRow(roleId, userId, borgId); 
	});
	$("#colButton").click( function() { $("#list").jqGrid('columnChooser'); });
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
var _roleNm = "";
jq(function() {
	jq("#treeList").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/roleMemberTreeJQGrid.sys',
		datatype: "json",
		mtype: "POST",
	   	colNames:["권한명","조직허용범위","svcTypeCd","svcTypeNm","treeKey","level"],
	   	colModel:[
	   		{name:'name',index:'name', width:185,sortable:false},//권한명
	   		{name:'borgScopeCd',index:'borgScopeCd', width:70,align:"center",sortable:false,formatter:"select",editoptions:{value:"<%=borgScopeArrayString %>"}},//조직허용범위

	   		{name:'svcTypeCd',index:'svcTypeCd', hidden:true},//svcTypeCd
	   		{name:'svcTypeNm',index:'svcTypeNm', hidden:true},//svcTypeNm
	   		{name:'treeKey',index:'treeKey', hidden:true, key:true},//treeKey
	   		{name:'level',index:'level', hidden:true}//level
	   	],
	   	rowNum:0, rownumbers: false, 
	   	treeGridModel:'adjacency',
	   	height:<%=listHeight%>, width:<%=listWidth%>,
	   	treeGrid: true, hoverrows: false,
		ExpandColumn : 'name',ExpandColClick: true,
		caption: "권한",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		jsonReader : { root: "list", repeatitems: false, cell: "cell" },
		loadComplete: function() {
			if(staticNum==0) {
				fnInitList(0,"권한사용자 <font color='red'>(좌측그리드의 권한을 선택해 주십시오!)</font>");
				staticNum++;
			}
		},
		loadError : function(xhr, st, str){ $("#treeList").html(xhr.responseText); },
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#treeList").jqGrid('getRowData',rowid);
			if(selrowContent.level=='1') {	//권한명을 클릭했을 경우
				var srcRoleNm = selrowContent.name;
				var srcRoleId = selrowContent.treeKey;
				var connectRoleNm = "<font color='blue'>["+srcRoleNm+"]</font>과 <font color='red'>연결된</font> 사용자정보";
				$("#stcRoleNm").val(srcRoleNm);
				$("#srcUserNm").val('');
				$("#srcLoginId").val('');
				_roleNm = srcRoleNm;
				fnOnClickList(srcRoleId, connectRoleNm, '', '', '');
			}
		}
	});
});
function fnInitList(srcRoleId, connectRoleNm) {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/roleMemberListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['서비스유형','권한명','사용자명','조직허용범위','Login ID','기본권한','업체조직명','svcTypeCd','roleId','userId','borgId'],
		colModel:[
			{name:'svcTypeNm',index:'svcTypeNm', width:60,align:"left",sortable:false,
				editable:true,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				editoptions:{disabled:true}
			},//서비스유형
			{name:'roleNm',index:'roleNm', width:120,align:"left",search:false,sortable:false,
				editable:true,formoptions:{rowpos:2,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				editoptions:{disabled:true}
			},//권한명
			{name:'userNm',index:'userNm', width:70,align:"left",search:false,sortable:true,
				editable:true,formoptions:{rowpos:3,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				editoptions:{disabled:true}
			},//사용자명
			{name:'borgScopeCd',index:'borgScopeCd', width:80,align:"center",sortable:false,
				editable:true,formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"<%=borgScopeArrayString %>"}
			},//조직허용범위
			{name:'loginId',index:'loginId', width:100,align:"left",search:false,sortable:true,
				editable:true,formoptions:{rowpos:5,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				editoptions:{disabled:true}
			},//사용자ID
			{name:'isDefault',index:'isDefault', width:60,align:"center",sortable:true,
				editable:true,formoptions:{rowpos:6,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"0:아니오;1:기본권한"}
			},//기본권한
			{name:'borgNms',index:'borgNms', width:350,align:"left",search:false,sortable:true,
				editable:true,formoptions:{rowpos:7,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				edittype:"textarea",editoptions:{rows:'3', cols:'40', disabled:true}
			},//업체조직명
			
			{name:'svcTypeCd',index:'svcTypeCd', hidden:true},//svcTypeCd
			{name:'roleId',index:'roleId', hidden:true},//roleId
			{name:'userId',index:'userId', hidden:true},//userId
			{name:'borgId',index:'borgId', hidden:true}	//borgId
		],
		postData: { srcRoleId:srcRoleId },
		rowNum:30, rownumbers: true, rowList:[30,50,100,500,1000], pager: '#pager',
		height:<%=list2Height%>,width: <%=list2Width%>, 
		sortname: 'borgNms', sortorder: "asc",
		caption:connectRoleNm, 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(data) {},
		afterInsertRow: function(rowid, aData){},
		onSelectRow:function(rowid, iRow, iCol, e){
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnOnClickList(srcRoleId, connectRoleNm, srcUserNm, srcLoginId, srcIsDefault) {
	$("#srcUserNm").val(srcUserNm);
	$("#srcLoginId").val(srcLoginId);
	$("#srcIsDefault").val(srcIsDefault);
	jq("#list").jqGrid("setGridParam", {"page":1, "rows":30});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcRoleId = srcRoleId;
	data.srcUserNm = srcUserNm;
	data.srcLoginId = srcLoginId;
	data.srcIsDefault = srcIsDefault;
	jq("#list").jqGrid("setCaption", connectRoleNm);
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
function fnSearch() {
	var row = jq("#treeList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
		var tmpLevel = Number(selrowContent.level);
		if(tmpLevel<1) {
			alert("권한을 먼저 선택해 주십시오\n선택된 권한의 사용자조회 입니다.");
			return;
		}
		var srcRoleNm = selrowContent.name;
		var srcRoleId = selrowContent.treeKey;
		var connectRoleNm = "<font color='blue'>["+srcRoleNm+"]</font>과 <font color='red'>연결된</font> 사용자정보";
		var srcUserNm = $("#srcUserNm").val();
		var srcLoginId = $("#srcLoginId").val();
		var srcIsDefault = $("#srcIsDefault").val();
		
		fnOnClickList(srcRoleId, connectRoleNm, srcUserNm, srcLoginId, srcIsDefault);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function addRow(borgScopeArray, roleId, userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	jq("#list").jqGrid('setColProp', 'svcTypeNm',{editoptions:{disabled:true, defaultValue:svcTypeNm}});
	jq("#list").jqGrid('setColProp', 'roleNm',{editoptions:{disabled:true, defaultValue:$("#stcRoleNm").val()}});
	jq("#list").jqGrid('setColProp', 'userNm',{editoptions:{disabled:true, defaultValue:userNm}});
	jq("#list").jqGrid('setColProp', 'loginId',{editoptions:{disabled:true, defaultValue:loginId}});
	jq("#list").jqGrid('setColProp', 'borgNms',{editoptions:{disabled:true, rows:'3', cols:'40', defaultValue:borgNms}});
	jq("#list").jqGrid('setColProp', 'borgScopeCd',{editoptions:{value:borgScopeArray}});
	jq("#list").jqGrid(
		'editGridRow', 'new',{
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveUserRoleGrid.sys", 
			editData: {roleId:roleId, userId:userId, borgId:borgId},
			recreateForm: true,beforeShowForm: function(form) {},
			width:"400",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
	jq("#list").jqGrid('setColProp', 'borgScopeCd',{editoptions:{value:"<%=borgScopeArrayString %>"}});
}
function editRow(roleId, userId, borgId) {
	var treeRow = $("#treeList").jqGrid('getGridParam','selrow');
	if(treeRow==null) { alert("좌측의 권한이 선택되지 않았습니다."); return; }
	var selrowContent = jq("#treeList").jqGrid('getRowData',treeRow);
	var svcTypeCd = selrowContent.svcTypeCd;
	var borgScopeCd = selrowContent.borgScopeCd;
	if(svcTypeCd=="") { alert("좌측의 권한이 선택되지 않았습니다."); return; }
	var borgScopeArray = "";
<%	
	for(CodesDto codesDto : borgScopeList) {
		String borgScopeCd = codesDto.getCodeVal1();
		String borgScopeNm = codesDto.getCodeNm1();
%>
	if(svcTypeCd!="BUY") {	//고객사가 아닌조직은 기본Scope을 가져감
		if(Number(borgScopeCd)==Number("<%=borgScopeCd%>")) {
			borgScopeArray = "<%=borgScopeCd%>:<%=borgScopeNm%>";
		}
	} else {
		if(Number(borgScopeCd) >= Number("<%=borgScopeCd%>")) {
			if(borgScopeArray=="") borgScopeArray = "<%=borgScopeCd%>:<%=borgScopeNm%>";
			else borgScopeArray += ";<%=borgScopeCd%>:<%=borgScopeNm%>";
		}
	}
<%	}	%>
	jq("#list").jqGrid('setColProp', 'borgScopeCd',{editoptions:{value:borgScopeArray}});
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid(
			'editGridRow', row,{ 
				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveUserRoleGrid.sys",
				editData: {roleId:roleId, userId:userId, borgId:borgId},
				recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
				afterSubmit : function(response, postdata){ 
					return fnJqTransResult(response, postdata);
				}
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
	jq("#list").jqGrid('setColProp', 'borgScopeCd',{editoptions:{value:"<%=borgScopeArrayString %>"}});
}
function deleteRow(roleId, userId, borgId) {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ) {
		jq("#list").jqGrid( 
			'delGridRow', row,{
				delData:{roleId:roleId, userId:userId, borgId:borgId},
				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveUserRoleGrid.sys",
				recreateForm: true,beforeShowForm: function(form) {
					jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
					jq('#pData').hide();jq('#nData').hide();  
				},
				reloadAfterSubmit:true,closeAfterDelete: true,
				afterSubmit: function(response, postdata){
					return fnJqTransResult(response, postdata);
				}
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}


/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['서비스유형','권한명','사용자명','조직허용범위','사용자ID','기본권한','업체조직명'];	//출력컬럼명
	var colIds = ['svcTypeCd','roleNm','userNm','borgScopeCd','loginId','isDefault','borgNms'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = _roleNm+" 의 사용자";	//sheet 타이틀
	var excelFileName = "RoleMemberList";	//file명
	
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
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>권한 사용자 조회</td>
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
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="5" class="table_top_line"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">권한명</td>
								<td class="table_td_contents">
									<input id="stcRoleNm" name="stcRoleNm" type="text" value="" size="20" style="background-color: #eaeaea;" readonly="readonly"/>
								</td>
								<td class="table_td_subject" width="100">사용자명</td>
								<td colspan="2" class="table_td_contents">
									<input id="srcUserNm" name="srcUserNm" type="text" value="" size="20" maxlength="30"/>
								</td>
							</tr>
							<tr>
								<td colspan="5" height='1' bgcolor="eaeaea"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">사용자ID</td>
								<td class="table_td_contents">
									<input id="srcLoginId" name="srcLoginId" type="text" value="" size="20" maxlength="30"/>
								</td>
								<td class="table_td_subject" width="100">기본권한여부</td>
								<td class="table_td_contents">
									<select id="srcIsDefault" name="srcIsDefault">
										<option value="">전체</option>
										<option value="1">기본권한</option>
										<option value="0">아니오</option>
									</select>
								</td>
								<td>
									<a href="#"><img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
								</td>
							</tr>
							<tr>
								<td colspan="5" class="table_top_line"></td>
							</tr>
						</table>
						<br/>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="right">
									<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
									<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
									<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
									<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
								</td>
							</tr>
						</table>
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