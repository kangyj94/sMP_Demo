<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String srcConfDate = (String) request.getAttribute("srcConfDate");
	String buyi_sequ_numb = (String)request.getAttribute("buyi_sequ_numb");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#excelButton").click(function(){ exportExcel(); });
	$("#delButton").click(function(){ delMptpay(); });
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustPurchasePaymentDescListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['rece_sequ_num', 'sale_sequ_numb', 'rece_pay_amou','recep_alram_id','전표번호','작성일자','출금일자','처리금액','내용','작성자'],
		colModel:[
			{name:'rece_sequ_num', index:'rece_sequ_num',width:60,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'sale_sequ_numb', index:'sale_sequ_numb',width:60,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'rece_pay_amou', index:'rece_pay_amou',width:80,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'recep_alram_id',index:'recep_alram_id',width:100,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'sap_jour_numb', index:'sap_jour_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'creat_date', index:'creat_date',width:110,align:"center",search:false,sortable:true, editable:false },
			{name:'pay_date', index:'pay_date',width:110,align:"center",search:false,sortable:true, editable:false },
			{name:'rece_pay_amou',index:'rece_pay_amou',width:90,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},         	
			{name:'context',index:'context',width:240,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'rece_user_nm',index:'rece_user_nm',width:90,align:"center",search:false,sortable:true, editable:false }
		],
		postData: {buyi_sequ_numb:'<%=buyi_sequ_numb%>'},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: 140,width:550,//autowidth: true,
		sortname: 'a.creat_date', sortorder: 'asc',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function exportExcel() {
	var colLabels = ['작성일자','출금일자','처리금액','작성자'];	//출력컬럼명
	var colIds = ['creat_date','pay_date','rece_pay_amou','rece_user_nm'];	//출력컬럼ID
	var numColIds = ['rece_pay_amou'];	//숫자표현ID
	var sheetTitle = "매입지급처리 상세보기";	//sheet 타이틀
	var excelFileName = "PurchasePaymentDesc";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function delMptpay(){
	var id = $("#list").jqGrid('getGridParam', "selrow" );
	if(id == null) {
		alert("삭제할 데이터를 선택해주세요.");
		return;
	}	
	var selrowContent = jq("#list").jqGrid('getRowData',id);
	if(!confirm("선택한 데이터를 삭제하시겠습니까?")) return;

	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/savePaymentDetail.sys", 
		{
			oper:"del",
			pay_amou:selrowContent.rece_pay_amou,
			rece_sequ_num:selrowContent.rece_sequ_num,
			buyi_sequ_numb:'<%=buyi_sequ_numb%>',
		},
		function(arg){ 
			if(fnAjaxTransResult(arg)) {  //성공시
				$("#list").trigger("reloadGrid");
				window.opener.$("#list").trigger("reloadGrid");
				//window.close();
			}
		}
	);
}

</script>

</head>
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Global.css">
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">
<body style="width: 551px;">
<table width="550" border="0" cellspacing="0" cellpadding="0" align="center"> 
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif);">
				<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>상세내용</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose" onclick="javaScript:window.close();">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" >
				<tr>
					<td align="right" style="padding: 2px; padding-right: 0px;">
						<button id='delButton' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
							<i class="fa fa-times"></i>삭제
						</button>
						<button id="excelButton" class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							<i class="fa fa-file-excel-o"></i> 엑셀
						</button>
					</td>
				</tr>
				<tr><td height="1"></td></tr>
				<tr>
					<td>
						<div id="jqgrid">
							<table id="list"></table>
						</div>
					</td>
				</tr>
					<tr>
						<td style="height: 10px;"></td>
					</tr>
					<tr>
					<td align="center">
						<button id="closeButton" name="closeButton" class="btn btn-default btn-sm" onclick="javaScript:window.close();">
							<i class="fa fa-times"></i>닫기
						</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>