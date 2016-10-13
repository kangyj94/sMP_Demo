<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의  
	String listHeight = "$(window).height()-158 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
    String srcOrdeIdenNumb = (String)request.getAttribute("orde_iden_numb");
    
    String orde_iden_numb = (String)request.getAttribute("orde_iden_numb");
    String purc_iden_numb = (String)request.getAttribute("purc_iden_numb");
    String deli_iden_numb = (String)request.getAttribute("deli_iden_numb");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	
   $("#closeButton").click(function(){ close(); });
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/firstPurchaseHandlePopListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['매출처리일자', '매출수량', '처리자'],
		colModel:[
			{name:'rece_regi_date',index:'rece_regi_date', width:100,align:"center",search:false,sortable:true,
				editable:false
			},	//매출처리일자  
			{name:'sale_prod_quan',index:'sale_prod_quan', width:70,align:"center",search:false,sortable:true,
				editable:false 
			},	//매출수량
			{name:'real_rece_numb',index:'real_rece_numb', width:60,align:"left",search:false,sortable:true,
				editable:false 
			}	//처리자    
		],
		postData: {
			orde_iden_numb:"<%=orde_iden_numb%>",
			purc_iden_numb:"<%=purc_iden_numb%>",
			deli_iden_numb:"<%=deli_iden_numb%>"
		},  
		sortname: 'rece_regi_date', sortorder: "asc",
		rowNum:30, rownumbers: false,
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		caption:"인수처리확인내역", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell"}  
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

</script>

</head>
<body>
<form id="frm" name="frm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="29" class='ptitle'>인수처리확인내역</td>
						</tr>
					</table> 
					<!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list"></table>
					</div>
				</td>
			</tr>
			<tr style="height: 40px">
				<td align="center"> <a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style='border:0;' /></a></td>
			</tr>
		</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>