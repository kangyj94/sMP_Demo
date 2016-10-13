<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmBuyBorgWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 590px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#buyBorgSelectButton").click(function(){	//Dialog 선택
		fnJqmSelectBuyBorg();
	});
	$("#srcBuyBorgDivButton").click(function(){
		fnBuyBorgDialogPopSearch();
	});
	$("#srcBorgNmDiv").keydown(function(e){ 
		if(e.keyCode==13) { $("#srcBuyBorgDivButton").click(); } 
	});
	
	// Dialog Button Event
	$('#buyBorgDialogPop').jqm();	//Dialog 초기화
	$("#buyBorgCloseButton").click(function(){	//Dialog 닫기
		$("#borgDivList").jqGrid("setGridParam",{datatype:"local"}).trigger("reloadGrid");
		$("#buyBorgDialogPop").jqmHide();
		$("#srcBorgTypeDiv").val("");
		$("#srcBorgNmDiv").val("");
		fnBuyBorgCallback = "";
	});
	$('#buyBorgDialogPop').jqm().jqDrag('#boyBorgDialogHandle'); 
});

var fnBuyBorgCallback = "";
function fnBuyborgDialog(  borgNm, callbackString) {
	$("#buyBorgDialogPop").jqmShow();
	$("#srcBorgNmDiv").val(borgNm);
	fnBuyBorgCallback = callbackString;
	borgDialogDivInit();
	if( borgNm ){
		$("#srcBuyBorgDivButton").click();
	}
	$("#srcBorgNmDiv").focus();
}

function fnBuyborgDialogForClientId(borgType, isFixed, borgNm, callbackString, clientId) {
	$("#buyBorgDialogPop").jqmShow();
	$("#srcBorgNmDiv").val(borgNm);
	fnBuyBorgCallback = callbackString;
	borgDialogDivInit(); //구매사 조직유형 SELECT-BOX 선택고정
}
</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var borgDivInitCnt = 0;
function borgDialogDivInit() {
	jq("#borgDivList").jqGrid({
		datatype: 'local',
		mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/borgDivListVenOrdReq.sys',
		colNames:['구매사명','권역','BORGID'],
		colModel:[
			{name:'BORGNMS',index:'BORGNMS', width:310,align:"left",search:false,sortable:false,editable:false},//고객사명
			{name:'AREANM',index:'AREANM', width:110,align:"center",search:false,sortable:false,editable:false},//권역
	   		{name:'BORGID',index:'BORGID', hidden:true, key:true}//borgId
		],
		postData: {
			srcBorgNm:$("#srcBorgNmDiv").val(),
		},
		rowNum:10, rownumbers: true, rowList:[10,20,30,50,100,500,1000], pager: '#borgDivPager',
		height:250, width:545, 
		sortname: 'borgNms', sortorder: "asc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { borgDivInitCnt++; },
		afterInsertRow: function(rowid, aData){},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			fnJqmSelectBuyBorg();
		},
		loadError : function(xhr, st, str){ $("#borgDivList").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}

/**
 * 조회조건에 따른 조직 조회
 */
function fnBuyBorgDialogPopSearch(){
	jq("#borgDivList").jqGrid("setGridParam", {"page":1, "rows":10});
	var data = jq("#borgDivList").jqGrid("getGridParam", "postData");
	data.srcBorgNm = $("#srcBorgNmDiv").val();
	jq("#borgDivList").jqGrid("setGridParam", { "postData":data });
	jq("#borgDivList").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

/**
 * 사용자 선택후 Callback 호출
 */
function fnJqmSelectBuyBorg() {
	var buyBorgRow = jq("#borgDivList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( buyBorgRow != null ){
		var selrowContent = jq("#borgDivList").jqGrid('getRowData',buyBorgRow);
		var rtn_branchId = selrowContent.BORGID;
		var rtn_borgNm = selrowContent.BORGNMS;
		eval(fnBuyBorgCallback+"('"+rtn_branchId+"','"+rtn_borgNm+"');");
		$("#buyBorgCloseButton").click();
	} else { alert("처리할 데이터를 선택해 주십시오"); }
}
</script>
</head>
<body>
<div class="jqmBuyBorgWindow" id="buyBorgDialogPop">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="boyBorgDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
							<td style="background-color: #ea002c; height: 47px;color: #fff;font-size: 17px;font-weight: 700;">구매사조회</td>
							<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
								<a href="#" class="jqmClose">
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
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right">
										<a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcBuyBorgDivButton" name="srcBuyBorgDivButton"/></a>
									</td>
								</tr>
							</table>
							<!-- 조회조건 -->
							<table width="100%" class="InputTable">
								<tr>
									<th>구매사명</th>
									<td colspan="5">
										<input id="srcBorgNmDiv" name="srcBorgNmDiv" type="text" value="" size="30" maxlength="30" />
									</td>
								</tr>
							</table>
							
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td style="height: 5px;"></td>
								</tr>
								<tr>
									<td>
										<div id="jqgrid">
											<table id="borgDivList"></table>
											<div id="borgDivPager"></div>
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
										<button id="buyBorgSelectButton" name="buyBorgSelectButton" type="button" class="btn btn-darkgray btn-sm">등록</button>
										<button id="buyBorgCloseButton" name="buyBorgCloseButton" type="button" class="btn btn-default btn-sm">닫기</button>
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
</body>
</html>
