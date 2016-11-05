<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
%>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<div id="divPopup" style="width:535px;">
	<h1>결재자 관리<a href="#"><img src="/img/contents/btn_close.png" class="jqmClose" /></a></h1>
	<div class="popcont">
		<table width="100%" class="InputTable">
			<tr>
				<th colspan="2" align="center">결재자 조회</th>
			</tr>
			<tr>
				<td style="width: 250px;">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<th width="70">결재자</th>
							<td>
								<input id="div_schAppUserNm" name="div_schAppUserNm" type="text" size="15" maxlength="20"/>
							</td>
						</tr>
						<tr>
							<th width="70">결재사업장</th>
							<td>
								<select class="select" name="div_schAppBranchId" id="div_schAppBranchId"></select>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center" height="70">
								<a href="#">
									<img src="/img/contents/btn_tablesearch.gif" id="div_srcButton" />
								</a>
								<button id="div_btnApprovalAdd" type="button" class="btn btn-darkgray btn-xs">결재자 추가</button>
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<div id="jqgrid">
						<table id="div_approvalTargetList"></table>
					</div>
				</td>
			</tr>
		</table>
	
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td style="height: 10px;"></td></tr>
		</table>
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left">
					<font color="blue">* 순서변경 시 드래그로 변경 하십시오!</font>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<div id="jqgrid">
						<table id="div_approvalUserList"></table>
					</div>
				</td>
			</tr>
		</table>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td align="center">
					<button id="btnApprovalSave" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-save"></i> 저장</button>
					<button id="btnClose" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
$(function() {
	$('.jqmClose').click(function (e) {
		$('#orderApprovalPop').html('');
		$('#orderApprovalPop').jqmHide();
	});
	
	$("#div_schAppUserNm").keydown(function(e){ if(e.keyCode==13) { $("#div_srcButton").click(); } });
	$("#div_schAppBranchId").change(function (e) { $("#div_srcButton").click(); });
	$('#div_srcButton').click(function (e) { fnDivSearch(); });
	$("#div_btnApprovalAdd").click(function (e) {
		var typeRow = $("#div_approvalTargetList").jqGrid('getGridParam','selrow');
		if(typeRow==null) { alert("추가하실 결재자를 선택하십시오!"); return; }
		var selrowContent = $("#div_approvalTargetList").jqGrid('getRowData',typeRow);
		fnAppUserAdd(selrowContent);
	});
	
	<%-- 저장 --%>
	$('#btnApprovalSave').click(function (e) {
		var rowData = $("#div_approvalUserList").jqGrid("getRowData");
		var params = JSON.stringify(rowData) ;
		$.post('/buyCart/saveOrderArpproval.sys', {jsonInfo:params},
			function(msg) {
				var m = eval('(' + msg + ')');
				if (m.customResponse.success) {
					alert("처리 하였습니다.");
					$("#vendorSelect2").html('');
					$("#mana_user_id").val('');
					var vendorSelectValue = "";
					var manaUserIdValue = "";
					for(var i=0;i<rowData.length;i++) {
						if(vendorSelectValue=="") {
							vendorSelectValue = $.trim(rowData[i].appUserNm);
							manaUserIdValue = $.trim(rowData[i].appUserId);
						} else {
							vendorSelectValue += " 〉"+$.trim(rowData[i].appUserNm);
							manaUserIdValue += ","+$.trim(rowData[i].appUserId);
						}
					}
					$("#vendorSelect2").html(vendorSelectValue);
					$("#mana_user_id").val(manaUserIdValue);
					$('.jqmClose').click();
				} else {
					alert('저장 중 오류가 발생했습니다.');
				}
			}
		);
	});
	
	<%-- 사업장 Select Box 세팅 --%>
	$.post(
		"/buyCart/getBranchListByClientId.sys", 
		{},
		function(arg){
			$("#div_schAppBranchId").html("");
			$("#div_schAppBranchId").append("<option value=''>전체</option>");
			var result = eval('(' + arg + ')').list;
			for(var i=0;i<result.length;i++) {
				if(result[i].BRANCHID=='<%=userDto.getBorgId() %>') {
					$("#div_schAppBranchId").append("<option value="+result[i].BRANCHID+" selected>"+result[i].BORGNM+"</option>");
				} else {
					$("#div_schAppBranchId").append("<option value="+result[i].BRANCHID+">"+result[i].BORGNM+"</option>");
				}
			}
			fnApprovalTargetList();
		}
	);
	
	<%-- 결재자 조회 --%>
	$("#div_approvalUserList").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/getApprovalUserList.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['결재자','사업장','삭제','appBranchId','appUserId'],
		colModel:[
			{name:'appUserNm',index:'appUserNm', width:100, align:"center",search:false,sortable:false,
				editable:false
			},	//결재자
			{name:'appBranchNm',index:'appBranchNm', width:200,align:"center",search:false,sortable:false,
				editable:false
			},	//사업장
			{name:'kind', index:'kind', width:50, align:"center", search:false, sortable:false, 
				editable:false, formatter:fnOrderkindFormatter
			}, // 구분
			{name:'appBranchId', index:'appBranchId', hidden:true},
			{name:'appUserId',   index:'appUserId',   hidden:true}
		],
		postData: {
			branchId:'<%=userDto.getBorgId() %>',
			userId:'<%=userDto.getUserId() %>'
		},
		height: 200, width: 500,rownumbers: true,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function(rowid, iRow, iCol, e) {},	
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#div_approvalUserList").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false}
	});
	$('#div_approvalUserList').jqGrid('sortableRows', {disabled: false});
});

<%-- 결재대상자 초기화 및 조회 --%>
function fnApprovalTargetList() {
	$("#div_approvalTargetList").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/getApprovalTargetList.sys',
	//		datatype: 'local',
		datatype: 'json',
		mtype: 'POST',
		colNames:['사업장','결재자','appBranchId','appUserId'],
		colModel:[
			{name:'appBranchNm',index:'appBranchNm', width:170,align:"center",search:false,sortable:false,
				editable:false
			},	//사업장
			{name:'appUserNm',index:'appUserNm', width:70, align:"center",search:false,sortable:false,
				editable:false
			},	//결재자
			{name:'appBranchId', index:'appBranchId', hidden:true},
			{name:'appUserId',   index:'appUserId',   hidden:true}
		],
		postData: {
			clientId:'<%=userDto.getClientId() %>',
			appUserNm:$("#div_schAppUserNm").val(),
			appBranchId:$("#div_schAppBranchId").val()
		},
		height: 150, width: 270,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function(rowid, iRow, iCol, e) {},	
		ondblClickRow: function (rowid, iRow, iCol, e) {
			var selrowContent = $("#div_approvalTargetList").jqGrid('getRowData',rowid);
			fnAppUserAdd(selrowContent);
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#div_approvalTargetList").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false}
	});
}

<%-- 결재자 추가 --%>
function fnAppUserAdd(selrowContent) {
	var rowCnt = $("#div_approvalUserList").getGridParam('reccount');
	var isSame = false;
	for(var i=0; i<rowCnt; i++) {
		var rowid2 = $("#div_approvalUserList").getDataIDs()[i];
		var selrowContent2 = $("#div_approvalUserList").jqGrid('getRowData',rowid2);
		if($.trim(selrowContent.appBranchId)==$.trim(selrowContent2.appBranchId) 
				&& $.trim(selrowContent.appUserId)==$.trim(selrowContent2.appUserId)) {
			isSame = true;
		}
	}
	if(isSame) {
		alert("추가된 결재자가 존재합니다.");
		return ;
	}
	var newRowData = {"appUserNm":$.trim(selrowContent.appUserNm), "appBranchNm":$.trim(selrowContent.appBranchNm),
			"appBranchId":$.trim(selrowContent.appBranchId), "appUserId":$.trim(selrowContent.appUserId)};
	$("#div_approvalUserList").jqGrid('addRowData',rowCnt+1,newRowData);
}

 <%-- 대상결재자 조회 --%>
function fnDivSearch() {
	var data = $("#div_approvalTargetList").jqGrid("getGridParam", "postData");
	data.clientId = '<%=userDto.getClientId() %>';
	data.appUserNm = $("#div_schAppUserNm").val();
	data.appBranchId = $("#div_schAppBranchId").val();
	$("#div_approvalTargetList").jqGrid("setGridParam", { "postData": data, 'datatype':'json' });
	$("#div_approvalTargetList").trigger("reloadGrid");
}

<%-- 삭제 칼럼 포맷 함수 --%>
function fnOrderkindFormatter(cellvalue, options, rowObject) {
	var result   = "";
	result = result + "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif' width='15' height='15' style='border:0;cursor:pointer;' onclick='javascript:fnApprovalLineDel(" + options.rowId + ");'/>";
	return result;
}

<%-- row 삭제 함수 --%>
function fnApprovalLineDel(rowid) {
	$('#div_approvalUserList').jqGrid('delRowData',rowid);
}
</script>
