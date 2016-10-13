<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmVendorWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 530px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmVendorWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#vendorSelectButton").click(function(){	//Dialog 선택
		fnJqmSelectVendor();
	});
	$("#srcVendorDivButton").click(function(){
		fnVendorDialogPopSearch();
	});
	$("#srcVendorNmDiv").keydown(function(e){ 
		if(e.keyCode==13) { $("#srcVendorDivButton").click(); } 
	});
	// Dialog Button Event
	$('#vendorDialogPop').jqm();	//Dialog 초기화
	$("#vendorCloseButtonTemp").click(function(){	//Dialog 닫기
        $("#vendorCloseButton").click();
	});
	$("#vendorCloseButton").click(function(){	//Dialog 닫기
		$("#vendorDialogPop").jqmHide();
		$("#srcAreaTypeDiv").val("");
		$("#srcVendorNmDiv").val("");
		fnVendorCallback = "";
	});
	$('#vendorDialogPop').jqm().jqDrag('#vendorDialogHandle'); 
});

var fnVendorCallback = "";
function fnVendorDialog(vendorNm, callbackString) {
	$("#vendorDialogPop").jqmShow();
	$("#srcVendorNmDiv").val(vendorNm);
	$("#srcVendorNmDiv").focus();
	fnVendorCallback = callbackString;
	vendorDialogDivInit();
}
</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var vendorDivInitCnt = 0;
function vendorDialogDivInit() {
	if(vendorDivInitCnt>0) {
		fnVendorDialogPopSearch();
		return;
	}
	jq("#vendorDivList").jqGrid({
		datatype: 'json', mtype: 'POST',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/quality/qualityVendorInfo/list.sys',
		colNames:[ '사업자번호' ,'공급사명' ,'연락처' ,'상태' ],
		colModel:[
			{name:'BUSINESSNUM',index:'BUSINESSNUM', width:90,align:"center",sortable:true,editable:false},//사업자번호
			{name:'BUSSINESSNM',index:'BUSSINESSNM', width:170,align:"left",search:false,sortable:true,editable:false},// 공급사명
			{name:'SUGGESTPHONE',index:'SUGGESTPHONE', width:100,align:"center",search:false,sortable:true,editable:false},// 연락처
			{name:'STATE_NM',index:'STATE_NM', width:55,align:"center",search:false,sortable:true,editable:false}// 상태 
		],
		postData: {
			businessnum:$("#srcVendorBnDiv").val(),
			bussinessnm:$("#srcVendorNmDiv").val()
		},
		rowNum:10, rownumbers: true, rowList:[10,20,30,50,100,500,1000], pager: '#vendorDivPager',
		height:250, width:490, 
		sortname: 'borgNm', sortorder: "asc", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			vendorDivInitCnt++; 
		},
		afterInsertRow: function(rowid, aData){
			var selrowContent = $("#vendorDivList").jqGrid('getRowData',rowid);
			if(selrowContent.STATE_NM == "종료"){
                $(this).setCell(rowid,'STATE_NM','',{color:'#ff0000'});
			}else if(selrowContent.STATE_NM == "비회원"){
                $(this).setCell(rowid,'STATE_NM','',{color:'#00ff00'});
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			fnJqmSelectVendor();
		},
		loadError : function(xhr, st, str){ $("#vendorDivList").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}

/**
 * 조회조건에 따른 조직 조회
 */
function fnVendorDialogPopSearch(){
	jq("#vendorDivList").jqGrid("setGridParam", {"page":1, "rows":10});
	var data = jq("#vendorDivList").jqGrid("getGridParam", "postData");
	data.bussinessnm = $("#srcVendorNmDiv").val();
	data.businessnum = $("#srcVendorBnDiv").val();
	jq("#vendorDivList").jqGrid("setGridParam", { "postData":data });
	jq("#vendorDivList").trigger("reloadGrid");
}

/**
 * 사용자 선택후 Callback 호출
 */
function fnJqmSelectVendor() {
	var buyBorgRow = jq("#vendorDivList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( buyBorgRow != null ){
		var selrowContent = jq("#vendorDivList").jqGrid('getRowData',buyBorgRow);
		var rtn_businessnum = selrowContent.BUSINESSNUM;
		var rtn_bussinessnm = selrowContent.BUSSINESSNM;
		var rtn_suggestphone = selrowContent.SUGGESTPHONE;
		eval(fnVendorCallback+"('"+rtn_businessnum+"','"+rtn_bussinessnm+"','"+rtn_suggestphone+"');");
		$("#vendorCloseButton").click();
	} else { alert("처리할 데이터을 선택해 주십시오"); }
}
</script>
</head>
<body>

<div class="jqmVendorWindow" id="vendorDialogPop">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="vendorDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h3>공급사 조회</h3>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;">
		        				<img id="vendorCloseButtonTemp" src="/img/contents/btn_close.png">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td style="height: 2px;"></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="right">
										<a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcVendorDivButton" name="srcVendorDivButton"/></a>
									</td>
								</tr>
								<tr><td style="height: 2px;"></td></tr>
							</table>
							<!-- 조회조건 -->
							<table class="InputTable"  width="100%" style="padding-top: 5px;">
								<tr>
									<th width="90">공급사명</th>
									<td>
										<input id="srcVendorNmDiv" name="srcVendorNmDiv" type="text" value="" size="20" maxlength="20" />
									</td>
									<th width="85">사업자번호</th>
									<td>
										<input id="srcVendorBnDiv" name="srcVendorBnDiv" type="text" value="" size="20" maxlength="20" />
									</td>
								</tr>
							</table>
							
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr><td style="height: 2px;"></td></tr>
								<tr>
									<td>
										<div id="jqgrid">
											<table id="vendorDivList"></table>
											<div id="vendorDivPager"></div>
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
										<button id="vendorSelectButton" type="button" class="btn btn-primary btn-sm isWriter"><i class="fa fa-check"></i>선택</button>
										<button id="vendorCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
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
