<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.ChatDto" %>
<%@ page import="java.util.List"%>
<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String userId = request.getParameter("userId");
	String branchId = request.getParameter("branchId");
	String userNm = request.getParameter("userNm");
	@SuppressWarnings("unchecked")
	List<ChatDto> chatList = (List<ChatDto>)request.getAttribute("chatList");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%-- <%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %> --%>
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/redmond/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/hmro_green_tree.css" rel=StyleSheet />
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.layout.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/i18n/grid.locale-kr.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.alphanumeric.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/Validation.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.ui.datepicker-ko.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.formatCurrency-1.4.0.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.maskedinput-1.3.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jshashtable-2.1.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.blockUI.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/custom.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jqgrid.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.money.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.number.js" type="text/javascript"></script>
<style type="text/css">
<!--
body, table, tr, td, select, input, textarea {
	font-family:돋움 ;
	font-size:9pt;
	color:#333333;
	word-break:break-all;
	line-height:1.4;
	scrollbar-face-color:#DDDDDD;
	scrollbar-highlight-color: #CCCCCC;
	scrollbar-shadow-color: #CCCCCC;
	scrollbar-3dlight-color: #F5F5F5;
	scrollbar-darkshadow-color: #F5F5F5;
	scrollbar-track-color: #F0F0F0;
	scrollbar-arrow-color: #FFFFFF;
}

#talkTextArea .chatter { font-weight: bold; color: #0066FF; }
#talkTextArea .msg { padding-left:14px; color: #666666; }
#talkTextAreaContainer { height:100%; margin-bottom:2px; border:1px solid #AAAAAA; }
#talkTextArea
 {
  height:270px; text-align:left; line-height:1.5em; 
padding-left:10px; padding-top:10px; overflow:auto; 
margin-bottom:2px; display:block; background-color: azure;
 }
#frm_chat_inform { clear:left; padding-left:10px; color:#996633; font-size:9pt; height :12px; }
-->
</style>
<script type="text/javascript">
var _checkInterVal = 0;	//창을 띄워서 아무것도 하지 않으면 창을 닫기 위한 체크수
var _closeInterVal = 20*<%=Constances.CHAT_MESSENGER_CLOSE_MINUTE %>;	//뒤에 숫자는 시간의 분(20분 안에 어떠한 체팅작업이 없다면 창을 닫음)
$(document).ready(function() {
	jQuery("#inputText").keydown(function(e){
		if(e.keyCode==13) { sendMessage(); return false; }
	});
	
	var talkTextArea = document.getElementById("talkTextArea");
<%	for(ChatDto chatDto : chatList) {	%>
	if('<%=chatDto.getFromUserNm() %>'=='<%=userNm %>') {
		talkTextArea.innerHTML = talkTextArea.innerHTML + "<br/><font color='#0000CD'><%=chatDto.getFromUserNm() %> > </font><%=chatDto.getMessage() %>";
	} else {
		talkTextArea.innerHTML = talkTextArea.innerHTML + "<br/><font color='#228822'><%=chatDto.getFromUserNm() %> > </font><%=chatDto.getMessage() %>";
	}
	talkTextArea.scrollTop = talkTextArea.scrollHeight;
<%	}	%>
	
	setInterval(fnChatDataReceive,1000*<%=Constances.CHAT_MESSENGER_SECOND %>);	//3초마다 한번씩 채팅 받음
});

function fnChatDataReceive() {
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/chatDataReceive.sys",
		{ userId:'<%=userId %>', branchId:'<%=branchId %>' },
		function(arg){
			var talkTextArea = document.getElementById("talkTextArea");
			var result = eval('(' + arg + ')').customResponse;
			for (var i = 0; i < result.message.length; i++) {
				talkTextArea.innerHTML = talkTextArea.innerHTML + "<br/><font color='#0000CD'><%=userNm %> > </font>"+result.message[i];
				talkTextArea.scrollTop = talkTextArea.scrollHeight;
				_checkInterVal = 0;
			}
		}
	);
	
	if(opener==null) window.close();
	if(opener.closed) window.close();
	if(++_checkInterVal > _closeInterVal) {
		window.close();
	}
}

function sendMessage(){
	var messageObj = document.getElementById("inputText");
	if(messageObj.value != "") {
		var talkTextArea = document.getElementById("talkTextArea");
		talkTextArea.innerHTML = talkTextArea.innerHTML + "<br/><font color='#228822'><%=loginUserDto.getUserNm() %> > </font>"+messageObj.value;
		talkTextArea.scrollTop = talkTextArea.scrollHeight;
		
		//상대방에게 채팅을 보냄
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/chatDataSend.sys",
			{ userId:'<%=userId %>', branchId:'<%=branchId %>', userNm:'<%=userNm %>', message:messageObj.value },
			function(arg){}
		);
		_checkInterVal = 0;
	}
	messageObj.value = "";
}

/**
 * 채팅 내용확인하는 팝업창 호출하는 메소드
 */
function setPastMessagePop(userId, branchId, userNm){
	var chatTarget = userId+"_"+branchId+"_chatList";
	var chatFrm = document.createElement("form");
	chatFrm.name = "chatListForm";
	chatFrm.method = "post";
	chatFrm.action = "<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/getWebChatPop.sys";
	chatFrm.target = chatTarget;
	
	var userIdObj = document.createElement("input");
	userIdObj.type = "hidden";
	userIdObj.name = "userId";
	userIdObj.value = userId;
	chatFrm.insertBefore(userIdObj, null);
	
	var branchIdObj = document.createElement("input");
	branchIdObj.type = "hidden";
	branchIdObj.name = "branchId";
	branchIdObj.value = branchId;
	chatFrm.insertBefore(branchIdObj, null);
	
	var userNmObj = document.createElement("input");
	userNmObj.type = "hidden";
	userNmObj.name = "userNm";
	userNmObj.value = userNm;
	chatFrm.insertBefore(userNmObj, null);
	
	window.open("", chatTarget, "width=510,height=400,scrollbars=no,resizable=no");
	document.body.insertBefore(chatFrm, null);
	chatFrm.submit();
}
</script>
</head>
<body style="background-color: #f9f1ee">
	<input type="hidden" name="userId" id="userId" value="<%=userId %>"/>
	<input type="hidden" name="branchId" id="branchId" value="<%=branchId %>"/>
	<input type="hidden" name="userNm" id="userNm" value="<%=userNm %>"/>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="30">
			
			<font style="color: #F58026;font-weight: 700;">
				&nbsp;<%=userNm %>님
			</font>
			<font style="color: #F58026;font-weight: 300;">
			과의 대화
			</font>
		</td>
		<td align="right">
			<a href="javascript:void(0);" onclick="javascript:setPastMessagePop('<%=userId%>','<%=branchId%>','<%=userNm%>');">
				<font style="color: #F58026;font-weight: 300;">
					대화내용보기
				</font>
			</a>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<div id="talkTextAreaContainer">
				<div id="talkTextArea" ></div>
			</div>
		</td>
	</tr>
	<tr>
		<td height="70" colspan="2">
			<table width="100%" border="0" cellpadding="0">
				<tr>
					<td width="895">
						<textarea name="chat_msgbox" id="inputText"  class="msg" style="width:95%; height:70px;border:1px solid #AAAAAA;" ></textarea>
					</td>
					<td width="60">
						<div align="center">
							<img alt="Send" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/webChat/send.gif" onclick="javascript:sendMessage();" style="cursor: pointer;" width="47px" height="37px">
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>