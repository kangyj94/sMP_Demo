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
    width: 550px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
</style>
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
		$("#buyBorgDialogPop").jqmHide();
		$("#srcBorgTypeDiv").val("");
		$("#srcBorgNmDiv").val("");
		fnBuyBorgCallback = "";
	});
	$('#buyBorgDialogPop').jqm().jqDrag('#boyBorgDialogHandle'); 
});
	var fnBuyBorgCallback = "";
	function fnAdjustBorgDialog(borgType, isFixed, borgNm, callbackString, userId) {
		$("#buyBorgDialogPop").jqmShow();
		$("#srcBorgTypeDiv").val(borgType);
		if(isFixed=="1") { $("#srcBorgTypeDiv").attr("disabled","true"); }
		else { $("#srcBorgTypeDiv").removeAttr("disabled"); }
		$("#srcBorgNmDiv").val(borgNm);
		fnBuyBorgCallback = callbackString;
		adjustBorgDialog(userId);
	}
	function fnBuyborgDialogForClientId(borgType, isFixed, borgNm, callbackString, clientId) {
		$("#buyBorgDialogPop").jqmShow();
		$("#srcBorgTypeDiv").val(borgType);
		if(isFixed=="1") { $("#srcBorgTypeDiv").attr("disabled","true"); }
		else { $("#srcBorgTypeDiv").removeAttr("disabled"); }
		$("#srcBorgNmDiv").val(borgNm);
		$("#srcClientIdDiv").val(clientId);
		fnBuyBorgCallback = callbackString;
		borgDialogDivInit();
	
	}
	function adjustBorgDialog(userId){
		var borgCnt = 0;
		if(borgCnt > 0) {
			fnBuyBorgDialogPopSearch();
			return;
		}
		$("#borgDivList").jqGrid({
			url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/adjustBorgDialog.sys',
			datatype:'json',
			mtype:'POST',
			colNames:['조직유형','구매사명','권역','조직코드','areaType','groupId','clientId','branchId','borgId'],
			colModel:[
						{name:'borgTypeNm',index:'borgTypeNm', width:60,align:"center",sortable:true,editable:false},//조직유형
						{name:'borgNms',index:'borgNms', width:300,align:"left",search:false,sortable:true,editable:false},//구매사명
						{name:'areaNm',index:'areaNm', width:60,align:"center",search:false,sortable:true,editable:false},//권역
						{name:'borgCd',index:'borgCd', width:80,align:"center",search:false,sortable:true,editable:false},//조직코드
						
						{name:'areaType',index:'areaType', hidden:true},//areaType
						{name:'groupId',index:'groupId', hidden:true},//groupId
						{name:'clientId',index:'clientId', hidden:true},//clientId
				   		{name:'branchId',index:'branchId', hidden:true},//branchId
				   		{name:'borgId',index:'borgId', hidden:true, key:true}//borgId
					],
			postData: {
				userId:userId,
				srcBorgType:$("#srcBorgTypeDiv").val(),
				srcBorgNm:$("#srcBorgNmDiv").val(),
				srcClientId:$("#srcClientIdDiv").val()
			},
			rowNum:10, rownumbers: true, rowList:[10,20,30,50,100,500,1000], pager: '#borgDivPager',
			height:250, width:510, 
			sortname: 'borgNms', sortorder: "asc", 
			viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
			loadComplete: function() { borgCnt++; },
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
		$("#borgDivList").jqGrid("setGridParam", {"page":1, "rows":10});
		var data = $("#borgDivList").jqGrid("getGridParam", "postData");
		data.srcBorgType = $("#srcBorgTypeDiv").val();
		data.srcBorgNm = $("#srcBorgNmDiv").val();
		data.srcClientId = $("#srcClientIdDiv").val();
		$("#borgDivList").jqGrid("setGridParam", { "postData":data });
		$("#borgDivList").trigger("reloadGrid");
	}
	
	/**
	 * 사용자 선택후 Callback 호출
	 */
	function fnJqmSelectBuyBorg() {
		var buyBorgRow = $("#borgDivList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
		if( buyBorgRow != null ){
			var selrowContent = $("#borgDivList").jqGrid('getRowData',buyBorgRow);
			var rtn_groupId = selrowContent.groupId;
			var rtn_clientId = selrowContent.clientId;
			var rtn_branchId = selrowContent.branchId;
			var rtn_borgNm = selrowContent.borgNms;
			var rtn_areaType = selrowContent.areaType;
			eval(fnBuyBorgCallback+"('"+rtn_groupId+"','"+rtn_clientId+"','"+rtn_branchId+"','"+rtn_borgNm+"','"+rtn_areaType+"');");
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
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>구매사 조회</h2>
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
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="4" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="100">구매사조직유형</td>
									<td class="table_td_contents">
										<select name="srcBorgTypeDiv" id="srcBorgTypeDiv">
											<option value="">전체</option>
											<option value="GRP">그룹</option>
											<option value="CLT">법인</option>
											<option value="BCH">사업장</option>
										</select>
									</td>
									<td class="table_td_subject" width="60">구매사명</td>
									<td class="table_td_contents">
										<input id="srcBorgNmDiv" name="srcBorgNmDiv" type="text" value="" size="20" maxlength="20" />
										<input id="srcClientIdDiv" name="srcClientIdDiv" type="hidden" value="" size="20" maxlength="20" />
									</td>
								</tr>
								<tr>
									<td colspan="4" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="4" height='8'></td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
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
										<button id="buyBorgSelectButton" type="button" class="btn btn-primary btn-sm isWriter"><i class="fa fa-check"></i>선택</button>
										<button id="buyBorgCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
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