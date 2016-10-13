<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmRoleDivWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 500px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmRoleDivWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	// Dialog Button Event
	$('#jqmRoleDivDialogPop').jqm();	//Dialog 초기화
	$("#jqmRoleDivCloseButton").click(function(){	//Dialog 닫기
		$("#jqmRoleDivDialogPop").jqmHide();
		_svcTypeCd = "";
		fnJqmRoleDivCallback = "";
	});
	$('#jqmRoleDivSelectButton').click(function(){
		fnJqmRoleDivSelect();
	});
	$('#jqmRoleDivDialogPop').jqm().jqDrag('#jqmRoleDivDialogHandle');
});

var fnJqmRoleDivCallback = "";
var _svcTypeCd = "";
function fnJqmAddRoleListInit(svcTypeCd, callbackString) {
	$("#jqmRoleDivDialogPop").jqmShow();
	_svcTypeCd = svcTypeCd;
	fnJqmRoleDivCallback = callbackString;
	fnJqmRoleDivListInit();
}

function fnJqmRoleDivSelect() {
	var jqmRoleRow = jq("#jqmRoleDivList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( jqmRoleRow != null ) {
		var selrowContent = jq("#jqmRoleDivList").jqGrid('getRowData',jqmRoleRow);
		var rtn_roleId = selrowContent.roleId;
		var rtn_roleCd = selrowContent.roleCd;
		var rtn_roleNm = selrowContent.roleNm;
		var rtn_isDefault = "0";
		var rtn_borgScopeCd = selrowContent.borgScopeCd;
		var rtn_roleDesc = selrowContent.roleDesc;
		eval(fnJqmRoleDivCallback+"('"+rtn_roleId+"','"+rtn_roleCd+"','"+rtn_roleNm+"','"+rtn_isDefault+"','"+rtn_borgScopeCd+"','"+rtn_roleDesc+"');");
		$("#jqmRoleDivCloseButton").click();
	} else { alert("처리할 데이터을 선택해 주십시오"); }
}
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var jqmRoleDivListInitCnt = 0;
function fnJqmRoleDivListInit() {
	if(jqmRoleDivListInitCnt>0) {
		fnJqmRoleDivListDialogPopSearch();
		return;
	}
	jq("#jqmRoleDivList").jqGrid({
		datatype: 'json', mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/roleListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['권한코드','권한명','서비스유형','조직허용범위','권한설명','roleId','borgScopeCd'],
		colModel:[
			{name:'roleCd',index:'roleCd', width:120,align:"left",search:false,sortable:true,
				editable:false
			},//권한코드
			{name:'roleNm',index:'roleNm', width:150,align:"left",search:false,sortable:true,
				editable:false
			},//권한명
			{name:'svcTypeCd',index:'svcTypeCd', width:60,align:"center",search:false,sortable:false,
				editable:false
			},//서비스유형
			{name:'borgScopeNm',index:'borgScopeNm', width:80,align:"center",search:false,sortable:false,
				editable:false
			},//조직허용범위
			{name:'roleDesc',index:'roleDesc', width:200,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:false},formoptions:{rowpos:8,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				edittype:"textarea",editoptions:{rows:'3',cols:'40',maxLength:"100"}
			},//권한설명
        	
			{name:'roleId',index:'roleId',hidden:true,search:false,key:true},//roleId
			{name:'borgScopeCd',index:'borgScopeCd',hidden:true,search:false}//borgScopeCd
		],
		postData: {
			srcSvcTypeCd:_svcTypeCd, srcIsUse:'1'
		},
		rowNum:0, rownumbers: true, 
		height:200, width:455, 
		sortname: 'roleId', sortorder: "desc",
		caption:"권한조회",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { jqmRoleDivListInitCnt++; },
		onSelectRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow: function(rowid, aData){},
		ondblClickRow: function (rowid, iRow, iCol, e) { 
			fnJqmRoleDivSelect();
		},
		loadError : function(xhr, st, str){ $("#jqmRoleDivList").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell" }
	});
}

function fnJqmRoleDivListDialogPopSearch() {
	var data = jq("#jqmRoleDivList").jqGrid("getGridParam", "postData");
	data.srcSvcTypeCd = _svcTypeCd;
	data.srcIsUse = '1';
	jq("#jqmRoleDivList").jqGrid("setGridParam", { "postData":data });
	jq("#jqmRoleDivList").trigger("reloadGrid");
}
</script>

</head>

<body>
<div class="jqmRoleDivWindow" id="jqmRoleDivDialogPop">
	<table width="400"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="jqmRoleDivDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
						<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
<%-- 		        			<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td> --%>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h3>권한검색</h3>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="middle" bgcolor="#FFFFFF">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<div id="jqmRoleDivId">
								<table id="jqmRoleDivList"></table>
							</div>
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="jqmRoleDivSelectButton" type="button" class="btn btn-primary btn-sm isWriter"><i class="fa fa-check"></i>선택</button>
										<button id="jqmRoleDivCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>