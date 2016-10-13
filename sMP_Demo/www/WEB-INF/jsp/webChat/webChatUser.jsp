<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.dto.ChatLoginDto" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%-- <%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %> --%>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<%-- <link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/redmond/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" media="screen" /> --%>
<%-- <link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" /> --%>
<%-- <link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/hmro_green_tree.css" rel=StyleSheet /> --%>
<%-- <link rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/font-awesome-4.5.0/css/font-awesome.min.css" /> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.layout.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/i18n/grid.locale-kr.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqGrid.min.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.alphanumeric.pack.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/Validation.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.ui.datepicker-ko.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.formatCurrency-1.4.0.pack.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.maskedinput-1.3.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jshashtable-2.1.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.blockUI.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/custom.common.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jqgrid.common.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.money.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.number.js" type="text/javascript"></script> --%>

<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#borgUserNm").keydown(function(e){
		if(e.keyCode==13) { fnChatLoginSearch(); }
	});
});

$(document).ready(function() {
	jq("#webChatUserListTable").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/webChat/chatLoginList.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['조직명', '로그인 사용자', 'userid', 'branchid'],
	   	colModel:[
			{name:'branchNm', index:'branchNm', width:200, align:"center", search:false, sortable:false, editable:false},
			{name:'userNm', index:'userNm', width:90, align:"center", search:false, sortable:false, editable:false},
			{name:'userId', index:'userId', search:false, sortable:false, editable:false, hidden:true},
			{name:'branchId', index:'branchId', search:false, sortable:false, editable:false, hidden:true}
	   	],
		postData: { borgUserNm:$('#borgUserNm').val() },
		rowNum:0,
		height: 330,
		width:300,
   		shrinkToFit:false,
   		rownumbers: false,
      	viewrecords: true,
      	emptyrecords: "Empty records",
      	loadonce: false,
      	gridview:true,
        loadui: 'disable',
      	ondblClickRow: function(rowid, iRow, iCol, e){
      		var selrowContent = jq("#webChatUserListTable").jqGrid('getRowData',rowid);
      		var userId    = selrowContent.userId;
      		var branchId  = selrowContent.branchId;
      		var userNm  = selrowContent.userNm;
  			opener._getWebChatPop(userId, branchId, userNm);	//채팅창 호출
      	},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
  	});
	
	setInterval(fnChatLoginSearch,1000*<%=Constances.CHAT_LOGINUSER_SECOND %>);	//5초마다 한번씩 채팅 로그인 사용자 확인
});

function fnChatLoginSearch() {
	if(opener==null) window.close();
	if(opener.closed) window.close();
	
	var data = jq("#webChatUserListTable").jqGrid("getGridParam", "postData");
	data.borgUserNm = $("#borgUserNm").val();
	jq("#webChatUserListTable").jqGrid("setGridParam", { "postData": data });
	jq("#webChatUserListTable").trigger("reloadGrid");
}
</script>
</head>
<body style="width: 320px; padding: 0px; margin: 0px; " >
			<!-- Search Context -->
			<ul class="Tabarea">
					<li class="on" style="font-weight: 900; width: 100%;height: 25px;line-height: 1.8em;text-align: center;">채팅</li>
				</ul>
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >
	<tr>
		<td align="center">
			<table class="InputTable" width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<th width="90">조직or사용자명</th>
					<td class="table_td_contents">
						<input id="borgUserNm" name="borgUserNm" type="text" value="" size="30" maxlength="30"/>
					</td>
				</tr>
			</table>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr><td style="height: 3px;"></td></tr>
				<tr>
					<td valign="top" align="center">
						<div id="jqgrid">
							<table id="webChatUserListTable"></table>
						</div>
					</td>
				</tr>
				<tr><td style="height: 3px;"></td></tr>
			</table>
			
		</td>
	</tr>
	<tr>
		<td align="center">
			<button id="closeButton" type="button" style="cursor: pointer;" class="btn btn-default btn-sm" onclick="javaScript:window.close();"><i class="fa fa-times"></i> 닫기</button>
		</td>
	</tr>
</table>
</body>
</html>