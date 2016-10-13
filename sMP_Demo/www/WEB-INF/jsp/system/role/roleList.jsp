<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%
	//그리드의 width와 Height을 정의
	int listWidth = 650;
	String listHeight	= "$(window).height()-370 + Number(gridHeightResizePlus)";
	String list2Height	= "$(window).height()-370 + Number(gridHeightResizePlus)";
	String list2Width	= "840";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	//서비스타입코드 리스트
	List<CodesDto> svcTypeCodeList = (List<CodesDto>)request.getAttribute("svcTypeCodeList");
	String svcTypeCdArrayString = "";
	for(CodesDto codesDto : svcTypeCodeList) {
		if("".equals(svcTypeCdArrayString)) svcTypeCdArrayString = codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
		else svcTypeCdArrayString +=  ";" + codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
	}
	@SuppressWarnings("unchecked")	//조직허용범위 리스트
	List<CodesDto> borgScopeList = (List<CodesDto>)request.getAttribute("borgScopeList");
	String borgScopeCdArrayString = "";
	for(CodesDto codesDto : borgScopeList) {
		if("".equals(borgScopeCdArrayString)) borgScopeCdArrayString = codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
		else borgScopeCdArrayString +=  ";" + codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#srcRoleCd").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcRoleNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() {
		var data = jq("#list").jqGrid("getGridParam", "postData");
		data.srcSvcTypeCd = $("#srcSvcTypeCd").val();
		data.srcRoleCd = $("#srcRoleCd").val();
		data.srcRoleNm = $("#srcRoleNm").val();
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
	$("#viewButton2").click( function() { viewRow2(); });
	$("#saveButton").click( function() { 
		var roleRow = jq("#list").jqGrid('getGridParam','selrow');
		var roleSelrowContent = jq("#list").jqGrid('getRowData',roleRow);
		var roleId = roleSelrowContent.roleId;
		
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
					unConnectRowKey[unConnectRowKey.length] = selrowContent.scopeId;
				}
			} else {	//원래 연결이 안되어 있는데
				var isCurrentConnect = false;
				for(var j=0;j<selrowArray.length;j++) {
					if((i+"")==selrowArray[j]) { isCurrentConnect = true; break; }
				}
				if(isCurrentConnect) {	//현재 연결이 되어 있는 경우
					connectRowKey[connectRowKey.length] = selrowContent.scopeId;
				}
			}
		}
		if(connectRowKey.length==0 && unConnectRowKey.length==0) { alert("변경된 내용이 없습니다."); return; }
		if(!confirm("변경된 내용을 저장하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/connectRoleGrid.sys",
			{ roleId:roleId, connectRowKey:connectRowKey, unConnectRowKey:unConnectRowKey },
			function(arg){
				if(fnAjaxTransResult(arg)) {
					jq("#list2").trigger("reloadGrid");
				}
			}
		);
	});
	$("#colButton2").click( function() { jq("#list2").jqGrid('columnChooser'); });
	$("#excelButton2").click(function(){ exportExcel2(); });
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/roleListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['권한코드','권한명','서비스유형','조직허용범위','사용여부','사용자초기권한여부','사용자초기허용범위','권한설명','roleId'],
		colModel:[
			{name:'roleCd',index:'roleCd', width:120,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//권한코드
			{name:'roleNm',index:'roleNm', width:150,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20", maxLength:"30"}
			},//권한명
			{name:'svcTypeCd',index:'svcTypeCd', width:60,align:"center",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",
				editoptions:{
					value:"<%=svcTypeCdArrayString %>",
					dataEvents: [{	
						type:'change',
						fn:function(e){
							var svcTypeCd = this.value;
							var codeVal2 = "";
							if(svcTypeCd != "BUY") codeVal2 = "5000";	//서비스유형이 고객사가 아닐 경우 조직허용범위는 사업장만 가능
							$.post(	
								'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
								{codeTypeCd:"BORGSCOPECD", isUse:"1", codeVal2:codeVal2},
								function(arg){
									var codeList = eval('(' + arg + ')').codeList;
									$("#borgScopeCd").html("");
									$("#initBorgScopeCd").html("");
									for(var i=0;i<codeList.length;i++) {
										$("#borgScopeCd").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
										$("#initBorgScopeCd").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
									}
								}
							);
						}
					}]
				}
			},//서비스유형
			{name:'borgScopeCd',index:'borgScopeCd', width:80,align:"center",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editrules:{required:true},
				editoptions:{ value:"<%=borgScopeCdArrayString %>" }
			},//조직허용범위
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:5,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부
			{name:'initIsRole',index:'initIsRole', width:80,align:"center",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:6,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"0:아니오;1:초기권한"}
			},//사용자초기권한여부
			{name:'initBorgScopeCd',index:'initBorgScopeCd', width:80,align:"center",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:7,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{ value:"<%=borgScopeCdArrayString %>" }
			},//사용자초기허용범위
			{name:'roleDesc',index:'roleDesc', width:200,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:false},formoptions:{rowpos:8,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				edittype:"textarea",editoptions:{rows:'3',cols:'40',maxLength:"100"}
			},//권한설명
			{name:'roleId',index:'roleId',hidden:true,search:false,key:true}
		],
		postData: {
			srcSvcTypeCd:$("#srcSvcTypeCd").val()
			,srcRoleCd:$("#srcRoleCd").val()
			,srcRoleNm:$("#srcRoleNm").val()
		},
		rowNum:0, rownumbers: true, 
		height:<%=listHeight%>,width: <%=listWidth%>, 
		sortname: 'roleId', sortorder: "desc",
		caption:"권한조회",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = parseInt(jq("#list").getGridParam('reccount'));
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];
				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
				var srcRoleId = selrowContent.roleId;
				var srcRoleNm = selrowContent.roleNm;
				var srcSvcTypeCd = selrowContent.svcTypeCd;
				if(staticNum==0) {
					fnInitList(srcRoleId,srcRoleNm,srcSvcTypeCd);
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
			var srcRoleId = selrowContent.roleId;
			var srcRoleNm = selrowContent.roleNm;
			var srcSvcTypeCd = selrowContent.svcTypeCd;
			fnOnClickList(srcRoleId,srcRoleNm,srcSvcTypeCd);
		},
		afterInsertRow: function(rowid, aData){
			if(aData.isUse == "0"){
				jq("#list").setCell(rowid,'roleCd','',{color:'red'});
				jq("#list").setCell(rowid,'roleNm','',{color:'red'});
				jq("#list").setCell(rowid,'svcTypeCd','',{color:'red'});
				jq("#list").setCell(rowid,'borgScopeCd','',{color:'red'});
				jq("#list").setCell(rowid,'isUse','',{color:'red'});
				jq("#list").setCell(rowid,'roleDesc','',{color:'red'});
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { 
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell" }
	});
});
var _roleName = "";	//연결된 영역 엑셀 출력 시 선택된 권한명을 출력하기 위해
function fnInitList(srcRoleId,srcRoleNm,srcSvcTypeCd) {
	_roleName = srcRoleNm;
	var connectMenuNm = "<font color='blue'>["+srcRoleNm+"]</font>권한과 <font color='red'>연결된</font> 영역정보";
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/roleScopeListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['영역코드','영역명','사용여부','영역설명','scopeId','isCheck'],
		colModel:[
			{name:'scopeCd',index:'scopeCd', width:120,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}
			},//영역코드
			{name:'scopeNm',index:'scopeNm', width:150,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20", maxLength:"30"}
			},//영역명
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부
			{name:'scopeDesc',index:'scopeDesc', width:200,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:false},formoptions:{rowpos:4,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				edittype:"textarea",editoptions:{rows:'3',cols:'40',maxLength:"100"}
			},//영역설명
			
			{name:'scopeId',index:'scopeId',hidden:true,search:false},
			{name:'isCheck',index:'isCheck',hidden:true,search:false}
		],
		postData: { srcRoleId:srcRoleId, srcSvcTypeCd:srcSvcTypeCd },multiselect: true,
		rowNum:0, rownumbers: false, 
		height:<%=list2Height%>,width:<%=list2Width%>, 
		sortname: 'scopeId', sortorder: "desc",
		caption:connectMenuNm,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
        afterInsertRow: function(rowid, aData){
        	if(aData.isCheck=="1") {
        		jq('#list2').jqGrid('setSelection', rowid);
        	} else {
        		jq("#list2").setCell(rowid,'scopeCd','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'scopeNm','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'isUse','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'scopeDesc','',{color:'#BFBFBF'});
        	}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { 
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow2();") %>
		},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell" }
	});
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnOnClickList(srcRoleId,srcRoleNm,srcSvcTypeCd) {
	_roleName = srcRoleNm;
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcRoleId = srcRoleId;
	data2.srcSvcTypeCd = srcSvcTypeCd;
	jq("#list2").jqGrid("setCaption", "<font color='blue'>["+srcRoleNm+"]</font>권한과 <font color='red'>연결된</font> 영역정보");
	jq("#list2").jqGrid("setGridParam", { "postData": data2 });
	jq("#list2").trigger("reloadGrid");
}

/*------------------------------List에 대한 처리-----------------------------------*/
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function addRow() {
	jq("#list").jqGrid('setColProp', 'borgScopeCd',{editoptions:{value:"5000:사업장"}});
	jq("#list").jqGrid('setColProp', 'initBorgScopeCd',{editoptions:{value:"5000:사업장"}});
	jq("#list").jqGrid(
		'editGridRow', 'new',{
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveRoleGrid.sys", 
			editData: {}, recreateForm: true, beforeShowForm: function(form) {},
			width:"450", modal:true, closeAfterAdd: true, reloadAfterSubmit:true,
			beforeSubmit: function (postData) { //대문자로 바꿔서 넘겨줌
			    postData.roleCd = postData.roleCd.toUpperCase(); 
			    return [true, '']; 
			},
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
      	}
	);
	jq("#list").jqGrid('setColProp', 'borgScopeCd',{editoptions:{value:"<%=borgScopeCdArrayString %>"}});
	jq("#list").jqGrid('setColProp', 'initBorgScopeCd',{editoptions:{value:"<%=borgScopeCdArrayString %>"}});
}

function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if(row==null) { jq( "#dialogSelectRow" ).dialog(); return; }
	var selrowContent = jq("#list").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
	
	jq("#list").jqGrid('setColProp', 'roleCd',{editoptions:{readonly:true}});
 	selrowContent = jq("#list").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
 	if(selrowContent.svcTypeCd != "BUY") {
 		jq("#list").jqGrid('setColProp', 'borgScopeCd',{editoptions:{value:"5000:사업장"}});
 		jq("#list").jqGrid('setColProp', 'initBorgScopeCd',{editoptions:{value:"5000:사업장"}});
 	}
 	jq("#list").jqGrid(
 		'editGridRow', row,{ 
 			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveRoleGrid.sys", 
   			editData: { roleId:selrowContent.roleId },
         	recreateForm: true, beforeShowForm: function(form) {},
          	width:"450", modal:true, closeAfterEdit: true, reloadAfterSubmit:true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
 		}
 	);
	jq("#list").jqGrid('setColProp', 'roleCd',{editoptions:{readonly:false}});
	jq("#list").jqGrid('setColProp', 'borgScopeCd',{editoptions:{value:"<%=borgScopeCdArrayString %>"}});
	jq("#list").jqGrid('setColProp', 'initBorgScopeCd',{editoptions:{value:"<%=borgScopeCdArrayString %>"}});
}

function deleteRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if(row==null) { jq( "#dialogSelectRow" ).dialog(); return; }
	jq("#list").jqGrid( 
		'delGridRow', row,{
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveRoleGrid.sys", 
			beforeShowForm: function(form) {
				jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '권한정보을 삭제하시겠습니까?<br>연결된 영역이 존재하면 삭제와 동시에 연결도 끊어집니다.' + '</span>');
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
	var colLabels = ['권한코드','권한명','서비스유형','조직허용범위','사용여부','권한설명'];	//출력컬럼명
	var colIds = ['roleCd','roleNm','svcTypeCd','borgScopeCd','isUse', 'roleDesc'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "권한정보";	//sheet 타이틀
	var excelFileName = "RoleList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function viewRow2() {
	var row = jq("#list2").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list2").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
/**
 * list2 Excel Export
 */
function exportExcel2() {
	var colLabels = ['연결여부','영역코드','영역명','사용여부','영역설명'];	//출력컬럼명
	var colIds = ['isCheck','scopeCd','scopeNm','isUse','scopeDesc'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = _roleName+"과 연결된 영역정보";	//sheet 타이틀
	var excelFileName = "ScopeList";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<!-- <form id="frm" name="frm"> -->
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>권한 관리</td>
					<td align="right" class='ptitle'>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i> 조회
						</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<!-- Search Context -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
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
					<td class="table_td_subject" width="100">권한코드</td>
					<td class="table_td_contents">
						<input id="srcRoleCd" name="srcRoleCd" type="text" value="" size="20" maxlength="20"/>
					</td>
					<td class="table_td_subject" width="100">권한명</td>
					<td class="table_td_contents">
						<input id="srcRoleNm" name="srcRoleNm" type="text" value="" size="20" maxlength="30"/>
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
		</td>
	</tr>
	<tr>
		<td>
			<table width="1500px" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
				<col width="810" />
				<col />
				<col width="100%"/>
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
						<font color="red">*</font> 연결과 해제는 체크박스 선택여부 입니다.
					</td>
					<td width="100px" align="right" valign="middle">
						<a href="#"><img id="viewButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="saveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Save.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
				</tr>
				<tr>
					<td rowspan="3">
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
<!-- </form> -->
</body>
</html>