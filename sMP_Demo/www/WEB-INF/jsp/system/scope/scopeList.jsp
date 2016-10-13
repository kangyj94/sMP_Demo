<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%
	//그리드의 width와 Height을 정의
	int listWidth = 600;
	String listHeight = "$(window).height()-360 + Number(gridHeightResizePlus)";
	String list2Height = "$(window).height()-360 + Number(gridHeightResizePlus)";
	String list2Width = "890";
	
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	//서비스타입코드 리스트
	List<CodesDto> svcTypeCodeList = (List<CodesDto>)request.getAttribute("svcTypeCodeList");
	String svcTypeCdArrayString = "";
	for(CodesDto codesDto : svcTypeCodeList) {
		if("".equals(svcTypeCdArrayString)) svcTypeCdArrayString = codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
		else svcTypeCdArrayString +=  ";" + codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#srcButton").click( function() {
		var data = jq("#list").jqGrid("getGridParam", "postData");
		data.srcSvcTypeCd = document.getElementById("srcSvcTypeCd").value;
		jq("#list").jqGrid("setGridParam", { "postData": data });
		jq("#list").trigger("reloadGrid");
	});
	$("#viewButton").click( function() { viewRow(); });
	$("#regButton").click( function() { addRow(); });
	$("#modButton").click( function() { editRow(); });
	$("#delButton").click( function() { deleteRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	/*----------영역의 연결 및 해제----------*/
	$("#saveButton").click( function() { 
		var scopeRow = jq("#list").jqGrid('getGridParam','selrow');
		var scopeSelrowContent = jq("#list").jqGrid('getRowData',scopeRow);
		var scopeId = scopeSelrowContent.scopeId;
		
		var connectRowKey = new Array();
		var unConnectRowKey = new Array();
		var selrowArray = jq("#list2").jqGrid('getGridParam','selarrrow');	//현재 선택된 로우들
		var rowCnt = parseInt(jq("#list2").getGridParam('reccount'));
		for(var i=1;i<=rowCnt;i++) {
			var selrowContent = jq("#list2").jqGrid('getRowData',i);
			var orgChecked = selrowContent.isCheck;
			if(orgChecked=="1") {	//원래 연결되어 있는데
				var isCurrentConnect = false;
				for(var j=0;j<selrowArray.length;j++) {
					if((i+"")==selrowArray[j]) { isCurrentConnect = true; break; }
				}
				if(!isCurrentConnect) {	//현재 연결을 해제할 경우
					unConnectRowKey[unConnectRowKey.length] = selrowContent.menuId + ":" + selrowContent.activityId;
				}
			} else {	//원래 연결이 안되어 있는데
				var isCurrentConnect = false;
				for(var j=0;j<selrowArray.length;j++) {
					if((i+"")==selrowArray[j]) { isCurrentConnect = true; break; }
				}
				if(isCurrentConnect) {	//현재 연결이 되어 있는 경우
					connectRowKey[connectRowKey.length] = selrowContent.menuId + ":" + selrowContent.activityId;
				}
			}
		}
		if(connectRowKey.length==0 && unConnectRowKey.length==0) { alert("변경된 내용이 없습니다."); return; }
		if(!confirm("변경된 내용을 저장하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/connectScopeGrid.sys",
			{ scopeId:scopeId, connectRowKey:connectRowKey, unConnectRowKey:unConnectRowKey },
			function(arg){
				if(fnAjaxTransResult(arg)) {
					jq("#list2").trigger("reloadGrid");
				}
			}
		);
	});
	$("#colButton2").click( function() { jq("#list2").jqGrid('columnChooser'); });
});

$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list2").setGridWidth(<%=list2Width%>);
	$("#list2").setGridHeight(<%=list2Height %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var staticNum = 0;	//list2 그리드를 한번만 초기화하기 위해
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/scopeListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['영역코드','영역명','연결된권한','서비스유형','사용여부','영역설명','scopeId'],
		colModel:[
			{name:'scopeCd',index:'scopeCd', width:120,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//영역코드
			{name:'scopeNm',index:'scopeNm', width:150,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20", maxLength:"30"}
			},//영역명
        	{name:'roleNms',index:'roleNms', width:150,align:"left",search:false,sortable:false,
				editable:false,formoptions:{rowpos:3,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}
			},//연결된권한
			{name:'svcTypeCd',index:'svcTypeCd', width:60,align:"center",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"<%=svcTypeCdArrayString %>"}
			},//서비스유형
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:5,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부
			{name:'scopeDesc',index:'scopeDesc', width:200,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:false},formoptions:{rowpos:6,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				edittype:"textarea",editoptions:{rows:'3',cols:'40',maxLength:"100"}
			},//영역설명
        	
			{name:'scopeId',index:'scopeId',hidden:true,search:false,key:true}//scopeId
		],
		postData: { srcSvcTypeCd:$("#srcSvcTypeCd").val() },
		rowNum:0, rownumbers: true, 
		height:<%=listHeight%>,width: <%=listWidth%>,
		sortname: 'scopeId', sortorder: "desc",
		caption:'영역조회',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = parseInt(jq("#list").getGridParam('reccount'));
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];
				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
				var srcScopeId = selrowContent.scopeId;
				var srcScopeNm = selrowContent.scopeNm;
				var srcSvcTypeCd = selrowContent.svcTypeCd;
				if(staticNum==0) {
					fnInitActivityList(srcScopeId,srcScopeNm,srcSvcTypeCd);
					staticNum++;
				}
				jq("#list").setSelection(top_rowid);
			} else {
				jq("#list2").clearGridData();
				jq("#list2").jqGrid("setCaption","&nbsp;");
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var srcScopeId = selrowContent.scopeId;
			var srcScopeNm = selrowContent.scopeNm;
			var srcSvcTypeCd = selrowContent.svcTypeCd;
			fnOnClickActivityList(srcScopeId,srcScopeNm,srcSvcTypeCd);
		},
		afterInsertRow: function(rowid, aData){
			if(aData.isUse == "0"){
				jQuery("#list").setCell(rowid,'scopeCd','',{color:'red'});
				jQuery("#list").setCell(rowid,'scopeNm','',{color:'red'});
				jQuery("#list").setCell(rowid,'scopeDesc','',{color:'red'});
				jQuery("#list").setCell(rowid,'svcTypeCd','',{color:'red'});
				jQuery("#list").setCell(rowid,'isUse','',{color:'red'});
				jQuery("#list").setCell(rowid,'roleNms','',{color:'red'});
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { 
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell" }
	});
});
function fnInitActivityList(srcScopeId,srcScopeNm,srcSvcTypeCd) {
	var connectMenuNm = "<font color='blue'>["+srcScopeNm+"]</font>영역과 <font color='red'>연결된</font> 메뉴화면권한";
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/scopeMenuActivityListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['메뉴명','메뉴코드','메뉴고정여부','메뉴사용','화면권한명', '화면권한코드', '화면권한사용' ,'menuId','activityId','isCheck','menuLevel'],
		colModel:[
			{name:'menuNm',index:'menuNm', width:120,align:"left",search:false,sortable:false},//메뉴명
			{name:'menuCd',index:'menuCd', width:90,align:"left",search:false,sortable:false,editable:false},//메뉴코드
        	{name:'isFixed',index:'isFixed', width:70,align:"center",search:false,sortable:false,editable:false,
        		edittype:"select",formatter:"select",editoptions:{value:"0:아니오;1:예"}
        	},//고정여부
			{name:'menuIsUse',index:'menuIsUse', width:50,align:"center",search:false,sortable:false,editable:false,edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}},//메뉴사용여부
			{name:'activityNm',index:'activityNm', width:70,align:"left",search:false,sortable:false,editable:false},//화면권한명
			{name:'activityCd',index:'activityCd', width:80,align:"left",search:false,sortable:false,editable:false},//화면권한코드
			{name:'activityIsUse',index:'activityIsUse', width:80,align:"center",search:false,sortable:false,editable:false,edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}},//화면권한사용여부
			
			{name:'menuId',index:'menuId',hidden:true,search:false},//menuId
			{name:'activityId',index:'activityId',hidden:true,search:false},//activityId
			{name:'isCheck',index:'isCheck',hidden:true,search:false},//isCheck
			{name:'menuLevel',index:'menuLevel',hidden:true,search:false}//menuLevel
		],
		postData: { srcScopeId:srcScopeId, srcSvcTypeCd:srcSvcTypeCd },multiselect: true,//multikey:"menuId/activityId",multiboxonly:true,
		rowNum:0, rownumbers: false, 
		height:<%=list2Height%>, width:<%=list2Width%>,//autowidth: true, 
		caption:connectMenuNm,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
        afterInsertRow: function(rowid, aData){
        	if(aData.isCheck=="1") {
        		jq('#list2').jqGrid('setSelection', rowid);
        	} else {
        		jq("#list2").setCell(rowid,'menuNm','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'menuCd','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'menuIsUse','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'activityNm','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'activityCd','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'activityIsUse','',{color:'#BFBFBF'});
        	}
			var joinImage = "";
			if(Number(aData.menuLevel)>0) {
				for(var i=1;i<Number(aData.menuLevel);i++) {
					joinImage += "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/empty.gif' style='vertical-align: bottom;'/>";
				}
				joinImage += "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/joinbottom.gif' style='vertical-align: bottom;'/>";
			}
			$("#list2").setCell(rowid,'menuNm',joinImage+aData.menuNm);
		},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell" }
	});
}

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnOnClickActivityList(srcScopeId,srcScopeNm,srcSvcTypeCd) {
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcScopeId = srcScopeId;
	data2.srcSvcTypeCd = srcSvcTypeCd;
	jq("#list2").jqGrid("setCaption", "<font color='blue'>["+srcScopeNm+"]</font>영역과 <font color='red'>연결된</font> 메뉴화면권한");
	jq("#list2").jqGrid("setGridParam", { "postData": data2 });
	jq("#list2").trigger("reloadGrid");
}

/*------------------------------List에 대한 처리-----------------------------------*/
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"500", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function addRow() {
	jq("#list").jqGrid(
		'editGridRow', 'new',{
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveScopeGrid.sys", 
     		editData: {}, recreateForm: true, beforeShowForm: function(form) {},
			width:"410", modal:true, closeAfterAdd: true, reloadAfterSubmit:true,
			beforeSubmit: function (postData) { //대문자로 바꿔서 넘겨줌
			    postData.scopeCd = postData.scopeCd.toUpperCase(); 
			    return [true, '']; 
			},
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
      	}
	);
}
function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if(row==null) { jq( "#dialogSelectRow" ).dialog(); return; }
	var selrowContent = jq("#list").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
	jq("#list").jqGrid('setColProp', 'scopeCd',{editoptions:{
		readonly:true,size:"20",maxLength:"20",
		dataInit: function(elem){
			$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");
		}
	}});
 	selrowContent = jq("#list").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
 	jq("#list").jqGrid(
 		'editGridRow', row,{ 
 			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveScopeGrid.sys", 
   			editData: { scopeId:selrowContent.scopeId },
         	recreateForm: true, beforeShowForm: function(form) {},
          	width:"410", modal:true, closeAfterEdit: true, reloadAfterSubmit:true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
 		}
 	);
	jq("#list").jqGrid('setColProp', 'scopeCd',{editoptions:{
		readonly:false,size:"20",maxLength:"20",
		dataInit: function(elem){
			$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");
		}
	}});
}
function deleteRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if(row==null) { jq( "#dialogSelectRow" ).dialog(); return; }
	var regMenuCnt = jq("#list2").getGridParam('reccount');
	var isCheck = false;
	for(var i=0;i<regMenuCnt;i++) {
		var selrowContent = jq("#list2").jqGrid('getRowData',i);
		if(selrowContent.isCheck=="1") { isCheck = true; break; }
	}
	if(isCheck) { jq( "#dialogSelectRow1" ).dialog(); return; }
	jq("#list").jqGrid( 
		'delGridRow', row,{
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveScopeGrid.sys", 
			beforeShowForm: function(form) {
				jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
				jq('#pData').hide();
				jq('#nData').hide();
			},
			recreateForm: true, reloadAfterSubmit:true, closeAfterDelete: true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}
/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['영역코드','영역명','연결된권한','서비스유형','사용여부','영역설명'];	//출력컬럼명
	var colIds = ['scopeCd','scopeNm','roleNms','svcTypeCd','isUse','scopeDesc'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "영역정보";	//sheet 타이틀
	var excelFileName = "ScopeList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>

</head>
<body>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<form id="frm" name="frm">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>영역 관리</td>
					<td align="right">
						<a href="#"><img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
				</tr>
			</table>

			<!-- Search Context -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">서비스유형</td>
					<td class="table_td_contents">
						<select name="srcSvcTypeCd" id="srcSvcTypeCd">
<%	for(CodesDto codesDto : svcTypeCodeList) { %>
							<option value="<%=codesDto.getCodeVal1() %>"><%=codesDto.getCodeNm1() %></option>
<%	} %>
							<option value="">전체</option>
						</select>
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
				<col width="400"/>
				<col />
				<col />
				<col />
				<tr>
					<td align="right" valign="middle">
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
					<td>&nbsp;&nbsp;</td>
					<td>
						* 연결과 해제는 체크박스 선택여부 입니다.
					</td>
					<td align="right" valign="middle">
						<a href="#"><img id="saveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Save.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
				</tr>
				<tr>
					<td>
						<div id="jqgrid">
							<table id="list"></table>
						</div>
					</td>
					<td></td>
					<td colspan="2">
						<div id="jqgrid">
							<table id="list2"></table>
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
<div id="dialogSelectRow1" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>영역과 연결된 화면권한이 존재합니다.<br/>화면권한과 연결을 끊은신 후 삭제하십시오!</p>
</div>
</form>
</body>
</html>