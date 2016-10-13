<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<%
	String userId = request.getParameter("userId");
	String branchId = request.getParameter("branchId");
	String userNm = request.getParameter("userNm");
	
	String tmpCurrentDate = CommonUtils.getCurrentDate();
	int currentYyyyInt = Integer.parseInt(tmpCurrentDate.substring(0, 4));
	String currentMmString = tmpCurrentDate.substring(5, 7);
	int currentMmInt = Integer.parseInt(currentMmString);
%>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcSearchButton").click(function(){
		fnChatMessageSearch();
	});
	jq(function() {
		jq("#list").jqGrid({
			url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/getWebChatMessageList.sys',
			datatype: 'json', mtype: 'POST',
			colNames:['발신자', '수신자', '내용', '전송일시'],
			colModel:[
				{name:'fromUserNm', index:'fromUserNm', width:60, align:"left", search:false, sortable:false, editable:false},
				{name:'toUserNm', index:'toUserNm', width:60, align:"left", search:false, sortable:false, editable:false},
				{name:'message', index:'message', width:225, align:"left", search:false, sortable:false, editable:false},
				{name:'createDate', index:'createDate', width:105, align:"center", search:false, sortable:false, editable:false}
			],
			postData: { userId:'<%=userId %>', branchId:'<%=branchId %>', srcYyyyMn:'<%=currentYyyyInt%><%=currentMmString%>' },
			rowNum:10, rowList:[10,20,30,50], height:230, width:490,
			shrinkToFit:false, multiselect:false, pager:'#pager', rownumbers:false, viewrecords:true,
			caption:"<%=userNm%> 님과의 대화내용", emptyrecords:"Empty records", loadonce:false,
			jsonReader:{ root:"list", page:"page", total:"total", records:"records", repeatitems:false, cell:"cell" }
    	});
	});
});

function fnChatMessageSearch() {
	jq("#list").clearGridData();
	jq("#list").jqGrid("setGridParam", {"page":1});
    var data = jq("#list").jqGrid("getGridParam", "postData");
    data.userId= '<%=userId %>';
    data.branchId= '<%=branchId %>';
    var srcYyyy = $("#srcYyyy").val();
    var srcMm = $("#srcMm").val();
    if(srcMm.length==1) srcMm = "0"+srcMm;
    data.srcYyyyMn= srcYyyy + srcMm;
    jq("#list").jqGrid("setGridParam", { "postData": data });
    jq("#list").trigger("reloadGrid");
}
</script>
</head>
<body>
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" valign="middle" class='ptitle'><%=userNm%> 님과의 대화내용 조회</td>
					</tr>
				</table> 
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="80">년/월</td>
						<td class="table_td_contents">
							<select name="srcYyyy" id="srcYyyy" class="select">
<%	for(int i=currentYyyyInt;i>=2013;i--) { %>
								<option value='<%=i%>'><%=i%></option>
<%	} %>
							</select>년&nbsp; 
							<select name="srcMm" id="srcMm" class="select">
<%	for(int i=1;i<=12;i++) { %>
								<option value='<%=i%>' <%if(i==currentMmInt) out.println("selected"); %>><%=i%></option>
<%	} %>
							</select>월
						</td>
						<td align="right" class='ptitle' valign="top">
							<img id="srcSearchButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" width="65" height="22" style="cursor:pointer;"/>
						</td>
					</tr>
					<tr>
						<td colspan="3" class="table_top_line"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td height="5"></td></tr>
	</table>
	<div id="jqgrid" align="left">
		<table id="list"></table>
		<div id="pager"></div>
	</div>
</body>
</html>