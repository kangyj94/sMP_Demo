<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmWindow {
    display: none;
    
    position: fixed;
    top: 17%;
    left: 50%;
    
    margin-left: -300px;
    width: 372px;
    
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-------------------------------- Dialog Div Start -------------------------------->
<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#closeButton").click(function(){	//Dialog 닫기
		$('#dialogPop').jqmHide();
	});
	$("#selectButton").click(function(){	//선택
		fnJqmSelectBorgs();
	});
	$("#divSrcBorg").keydown(function(e){
		var tmpSrcText = $.trim($("#divSrcBorg").val());
		if(e.keyCode==13 && tmpSrcText.length>0) {
			fnFindSearchBorg(tmpSrcText);
		}
	});
	
	$('#dialogPop').jqm().jqDrag('#dialogHandle'); 
});

var jq = jQuery;
var treeStaticNum = 0;	//list 그리드를 한번만 초기화하기 위해
var rowTreeCnt = 0;
function fnInitJqmTreeList(lastBorgTypeCd) {
	if(treeStaticNum == 0) {
		jq("#jqmTreeList").jqGrid({
			url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/borgTreeJQGrid.sys',
			datatype: "json",
			mtype: "POST",
		   	colNames:["선택","조직명","조직구분","조직코드","사용여부","treeKey","borgId","borgTypeCd","borgLevel","isLeaf"],
		   	colModel:[
				{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false},	//선택
				
		   		{name:'borgNm',index:'borgNm', width:200,sortable:false},//조직명
		   		{name:'borgTypeNm',index:'borgTypeNm', width:70,align:"center",sortable:false},//조직구분
		   		{name:'borgCd',index:'borgCd', width:70,align:"center",sortable:false},//조직코드
		   		{name:'isUse',index:'isUse', width:50,align:"center",sortable:false,
		   			edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}},//사용여부
		   			
		   		{name:'treeKey',index:'treeKey', hidden:true, key:true},//treeKey
		   		{name:'borgId',index:'borgId', hidden:true},//borgId
		   		{name:'borgTypeCd',index:'borgTypeCd', hidden:true},//borgTypeCd
		   		{name:'level',index:'level', hidden:true},//borgLevel
		   		{name:'isLeaf',index:'isLeaf', hidden:true}//isLeaf
		   	],
		   	postData: { lastBorgTypeCd:lastBorgTypeCd },
		   	rowNum:0, rownumbers: false, 
		   	treeGridModel:'adjacency',
		   	height:350, width:330,
		   	treeGrid: true, hoverrows: false,
			ExpandColumn : 'borgNm',ExpandColClick: true,
			caption: "조직조회",
			viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
			jsonReader : { root: "list", repeatitems: false, cell: "cell" },
			loadComplete: function() {
				if(treeStaticNum++==0) {
					var rowCnt = jq("#jqmTreeList").getGridParam('reccount');
					if(rowCnt>0) {
						var top_rowid = jq("#jqmTreeList").getDataIDs()[0];	//첫번째 로우 아이디 구하기
						setTimeout(function() {
							var recordInfo = jq("#jqmTreeList").getLocalRow(top_rowid);
							jq("#jqmTreeList").expandRow(recordInfo);
							jq("#jqmTreeList").expandNode(recordInfo);
						}, 10);
					}
				}
				rowTreeCnt = this.rows.length;
				for(var i=0;i<rowTreeCnt;i++) {
					var rowTreeid = $("#jqmTreeList").getDataIDs()[i];
					var selrowTreeContent = jq("#jqmTreeList").jqGrid('getRowData',rowTreeid);
					if("CLT"==selrowTreeContent.borgTypeCd) {
						var tmpIsCheck = "<input id='isCheck_"+rowTreeid+"' name='isCheck_"+rowTreeid+"' type='checkbox'  offval='no'  style='border:none;'/>";
			          	jq("#jqmTreeList").jqGrid('setRowData', rowTreeid, {isCheck:tmpIsCheck});
					}
		       	}
			},
			loadError : function(xhr, st, str){ $("#jqmTreeList").html(xhr.responseText); },
			ondblClickRow: function (rowid, iRow, iCol, e) {
				var jqmTreeListSelrowContent = jq("#jqmTreeList").jqGrid('getRowData',rowid);
				if(lastBorgTypeCd == jqmTreeListSelrowContent.borgTypeCd) {
					fnJqmSelectBorg();
				}
			},
			onSelectRow: function (rowid, iRow, iCol, e) {}
		});
	} else if(treeStaticNum > 1) {
		treeStaticNum = 0;
		jq("#jqmTreeList").trigger("reloadGrid");
	}
}

function fnJqmSelectBorg() {
	var borgRow = jq("#jqmTreeList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( borgRow != null ){
		var selrowContent = jq("#jqmTreeList").jqGrid('getRowData',borgRow);
		var borgId = selrowContent.borgId;
		var borgNm = selrowContent.borgNm;
		if(borgId=="") {
			alert("그룹부터 선택 하실 수 있습니다.");
			return;
		}
		var borgIds = new Array();
		var borgNms = new Array();
		borgIds[0] = borgId;
		borgNms[0] = borgNm;
		fnSelectBorgsCallback(borgIds, borgNms);
	} else { alert("처리할 데이터을 선택해 주십시오"); }
}

function fnJqmSelectBorgs() {
	var isChkCnt = 0;
	var borgIds = new Array();
	var borgNms = new Array();
	for(var i=0;i<rowTreeCnt;i++) {
		var rowTreeid = $("#jqmTreeList").getDataIDs()[i];
		if (jq("#isCheck_"+rowTreeid).attr("checked")) {
			var selrowTreeContent = jq("#jqmTreeList").jqGrid('getRowData',rowTreeid);
			borgIds[isChkCnt] = selrowTreeContent.borgId;
			borgNms[isChkCnt++] = selrowTreeContent.borgNm;
		}
	}
	if(isChkCnt==0) {
		alert("선택된 정보가 없습니다.");
		return;
	}
	fnSelectBorgsCallback(borgIds, borgNms);
}

function fnFindSearchBorg(tmpSrcText) {
	var rowCnt = jq("#jqmTreeList").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i=0;i<rowCnt;i++) {
			var tmpRowid = jq("#jqmTreeList").getDataIDs()[i];
			var jqmTreeListSelrowContent = jq("#jqmTreeList").jqGrid('getRowData',tmpRowid);
			var borgNm = jqmTreeListSelrowContent.borgNm;
			if(borgNm.indexOf(tmpSrcText)>-1) {
				jq("#jqmTreeList").setSelection(tmpRowid);
				jq("#isCheck_"+tmpRowid).focus();
				break;
			}
		}
	}
}
</script>
</head>
<body>
<div class="jqmWindow" id="dialogPop">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="dialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
		        			<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
		        			<td class="popup_title">조직 조회</td>
		        			<td width="22" align="right">
		        				<a href="#" class="jqmClose">
		        				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" />
		        				</a>
		        			</td>
		        			<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td valign="top" align="center">
										조회된 조직 찿기 : <input type="text" id="divSrcBorg" name="divSrcBorg" />
									</td>
								</tr>
								<tr>
									<td height='5'></td>
								</tr>
								<tr>
									<td>
										<div id="jqgrid">
											<table id="jqmTreeList"></table>
										</div>
									</td>
								</tr>
								<tr>
									<td height='8'></td>
								</tr>
							</table>
							
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<a href="#"><img id="selectButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_select.gif" style='border:0;' /></a>
										<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border:0;' /></a>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>