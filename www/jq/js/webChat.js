//by jameskang(return contextPath)
function getContextPath(){
    return serverContextPath;
}

/**
 * 웹 체팅을 하기 위한 자바스크립트 코드 모음
 * 
 * 웹채팅을 하기 위해 페이지 로드시 다음 메소드를 반드시 수행하여야 한다.
 * webChatInit(chatCallAddressValue, selfNameValue, isTalkValue);
 * 
 * 채팅을 팝업창으로 진행할 경우 로그인 사용자 팝업창을 호출하기 위해서는 아래의 메소드를 수행하어야 한다.
 * setWebChatLoginPop(contextPath);
 * 
 * 웹 채팅을 하기 위해서는 다음의 파일이 필요하다
 * ~. jquery 관련 자바 스크립트 파일
 * ~. jqgrid 관련 자바 스크립트 파일
 * ~. drag관련 자바 스크립트 파일
 * 
 * 페이지에는 다음의 아이디를 가진 table 객체가 존재하여야 한다. id : webChatUserListTable
 * 
 * @author : tytolee
 * @sincece : 2012-05-22
 */
var chatQueue       = new Array(); // 사용자가 입력한 메세지를 담을 큐
var chatRequest     = new Array(); // 서버와의 통신을 위한 request Array
var chatCallAddress = "";          // 웹 채팅 url
var selfName        = "";          // 로그인 사용자 대화명
var messageSeq      = 0;

// drag를 구현하기 위해 변수추가 start!(2012-05-31, tytolee)
var topValue;
var leftValue;
// drag를 구현하기 위해 변수추가 end!(2012-05-31, tytolee)

var jq            = jQuery;
var chatPopArray  = new Array();
var chatUserArray = new Array();
var isTalkPop     = true; // 채팅창을 열것인가?
var intervalObj   = null; // 반복객체 컨트롤을 위해 변수추가(2012-06-07, tytolee)
var chatLoginPop  = null;
var serverContextPath = "";

/**
 * 웹채팅 초기화 메소드
 * 
 * @author tytolee
 * @param chatCallAddressValue (웹체팅 요청 서버 주소)
 * @param selfNameValue (페이지 로드 사용자 명)
 * @param isTalkValue (팝업채팅창인지 여부, true : 채팅팝업, false : Div)
 * @since 2012-05-24
 * @modify - (팝업창 호출일 경우 케이스 추가, tytolee)
 * @modify 2012-06-07 (파라미터 추가, tytolee)
 * @modify 2012-06-07 (반복 객체 설정, tytolee)
 * @modify 2012-06-19 (반복시간 변경, tytolee)
 */
function webChatInit(chatCallAddressValue, selfNameValue, isTalkValue){
	chatCallAddress = chatCallAddressValue;
	selfName        = selfNameValue;
	isTalkPop       = isTalkValue;
	
	if(isTalkPop){ // 팝업창 호출
		intervalObj = setInterval("sendQueue()",500);
	}
	else{
		jq("#webChatUserListTable").jqGrid({
	   		datatype: 'local',
			colNames:['로그인 사용자', '사용자번호'],
		   	colModel:[
				{name:'toMemberBorgNm', index:'toMemberBorgNm', width:100, align:"center", search:false, sortable:false, editable:false},
				{name:'toMemberName', index:'toMemberName', width:170, align:"center", search:false, sortable:false, editable:false},
				{name:'toMemberNo',   index:'toMemberNo',   width:160, align:"center", search:false, sortable:false, editable:false, hidden:true}
		   	],
			rowNum:0,
			height: 330,
			width:270,
	   		caption:"채팅창",
	   		shrinkToFit:false,
	   		rownumbers: false,
	      	viewrecords: true,
	      	emptyrecords: "Empty records",
	      	loadonce: false,
	      	ondblClickRow: function(rowid, iRow, iCol, e){
	      		var selrowContent = jq("#webChatUserListTable").jqGrid('getRowData',rowid);
	      		var toMemberNo    = selrowContent.toMemberNo;
	      		
      			var toMemberNoDiv = document.getElementById(toMemberNo + "Div");
    			
    			if(toMemberNoDiv == null){ // 채팅창이 존재하지 않을 경우
    				createWebChatDiv(toMemberNo);
    			}
	      	},
	      	loadComplete: function(){
	      		//setInterval("sendQueue()",500); // 반복 객체 설정(2012-06-07, tytolee)
	      		//intervalObj = setInterval("sendQueue()",500); // 반복 시간 변경(2012-06-19, tytolee)
	      		intervalObj = setInterval("sendQueue()",1000);
	      	}
	  	});
	}
}

/**
 * 사용가능한 request 인덱스를 반환하는 메소드
 * 
 * @author tytolee
 * @returns -1 : 사용가능한 request 없음, 그 외 : 사용가능한 인덱스
 * @since : 2012-05-22
 */
function getFreeChatRequestIndex(){
	var i = 0;
	
	for(i = 0; i < 2; i++){
		if((typeof(chatRequest[i]) == 'undefined') || (chatRequest[i].readyState == 4)){
			return i;
		}
	}
	
	return -1;
}

/**
 * 현재 서버 응답 대기중인 request 인덱스를 반환하는 메소드
 * 
 * @author tytolee
 * @returns -1 : 응답 대기중인 request 없음, 그 외 : 응답대기 중인 인덱스
 * @since : 2012-05-22
 */
function getWaitChatRequestIndex(){
	var i = 0;
	
	for(i = 0; i < 2; i++){
		if((typeof(chatRequest[i]) != 'undefined') && (chatRequest[i].readyState == 1)){
			return i;
		}
	}
	
	return -1;
}

/**
 * Ajax 통신을 위한 객체를 반환한다.
 * 
 * @author -
 * @returns request 객체
 * @since -
 */
function getAjaxRequest(){
	if(window.ActiveXObject){
		try{
			return new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch(e){
			try{
				return new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(e){
				return null;
			}
		}
	}
	else if(window.XMLHttpRequest){
		return new XMLHttpRequest();
	}
	else{
		return null;
	}
}

/**
 * 웹 체팅 request를 서버에 요청하는 메소드
 * 
 * @author tytolee
 * @param request : 서버와 통신할 request객체
 * @param params : 서버에 전달할 파라미터 (name=value&name1=value1 이런식으로 전달)
 * @param callback : 콜벡 메소드
 * @param method : 전송방식 (GET 또는 POST, 미입력 또는 다른 문자 입력시 GET 방식 전달)
 * @since 2012-05-22
 */
function sendWebChatRequest(request, params, callback, method){
	var httpMethod  = null;
	var httpParams  = null;
	var httpUrl     = null;
	var httpRequest = null;
	
	httpRequest = request;
	
	if(method == null){
		httpMethod = 'GET';
	}
	else if((method != 'GET') && (method != 'POST')){
		httpMethod = 'GET';
	}
	else{
		httpMethod = method;
	}
	
	if((params != null) && (params != "")){
		httpParams = params + "&ajax=Y";
	}
	
	httpUrl = chatCallAddress;
	
	if((httpMethod == "GET") && (httpParams != null)){
		httpUrl = httpUrl + "?" + httpParams;
	}
	
	httpRequest.open(httpMethod, httpUrl, true);
	httpRequest.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charaset=UTF-8");
	//httpRequest.onreadystatechange = callback;
	
	if(httpMethod == "GET"){
		httpRequest.send(null);
	}
	else{
		httpRequest.send(httpParams);
	}
}

/**
 * 큐에 담긴 내용을 서버에 전달
 * 
 * @author tytolee
 * @since 2012-05-22
 * @modify 2012-05-30 (메세지 번호 설정 추가, tytolee)
 */
function sendQueue(){
	var slot     = null;
	var message  = null;
	var waitSlot = null;
	
	slot = getFreeChatRequestIndex(); //  사용가능한 request 인덱스를 반환
	
	if(slot < 0){ // 사용 가능한 자원 없음
		return;
	}
	
	if((typeof(chatRequest[slot]) != 'undefined') && (chatRequest[slot].readyState != 4)){ // 유효한 자원이 아닌 경우
		return;
	}
	
	if(chatQueue.length == 0){ // 큐에 담긴 내용이 없음
		waitSlot = getWaitChatRequestIndex(); // 현재 서버 응답 대기중인 request 인덱스를 반환
		
		if(waitSlot != -1){ // 응답 대기중인 request가 존재함
			return;
		}
		else{
			message = "message=&isBusy=0"; // 서버에 빈 메세지 전송을 위한 설정
		}
	}
	else{
		message   = "toMemberNo=" + chatQueue[0].toMemberNo + "&message=" + chatQueue[0].message + "&isBusy=1";
		chatQueue = chatQueue.slice(1, chatQueue.length);
	}
	
	message = message + "&messageSeq=" + messageSeq; // 메세지 번호 설정 추가(2012-05-30, tytolee)
	
	chatRequest[slot] = getAjaxRequest(); // Ajax 통신을 위한 객체를 반환
	
	chatRequest[slot].onreadystatechange = function(){
		sendQueueCallback(chatRequest[slot]);
	};
	
	sendWebChatRequest(chatRequest[slot], message, sendQueueCallback, 'POST'); // request 호출
}

/**
 * sendQueue Callback 메소드
 * 
 * @author tytolee
 * @since 2012-05-22
 * @modify 2012-05-30 (메세지 시컨스 설정, tytolee)
 * @modify 2012-06-07 (세션 종료시 설정, tytolee)
 */
function sendQueueCallback(chatRequest){
	if((chatRequest.readyState == 4) && (chatRequest.status == 200)){
		var result          = eval("(" + chatRequest.responseText + ")");
		var webChatDtoArray = result.webChatDto;
		var messageSeqValue = result.messageSeq;
		var j               = 0;
		
		messageSeq = messageSeqValue; // 메세지 시컨스 설정(2012-05-30, tytolee)
		
		for(j = 0; j < webChatDtoArray.length; j++){
			webChatDtoProcess(webChatDtoArray[j]);
		}
	}
}

/**
 * 서버에서 받아온 내용을 처리하는 메소드
 * 
 * @author tytolee
 * @param webChatDto
 * @since 2012-06-18
 */
function webChatDtoProcess(webChatDto){
	var message         = webChatDto.message;
	var fromMemberNo    = webChatDto.fromMemberNo;
	var fromMemberName  = webChatDto.fromMemberName;
	var fromMemberBorgNm= webChatDto.fromMemberBorgNm;
	var type            = webChatDto.type;
	
	if(message != ""){ // 메세지가 존재할 경우에만 처리
		setWebChatMessageServer(fromMemberNo, fromMemberName, message); // 서버에서 온 메세지를 설정
	}
	else if(type != ""){ // 타입이 존재할 경우에만 처리
		if(type == "LOGIN"){
			setWebChatLogin(fromMemberNo, fromMemberName, fromMemberBorgNm); // 로그인 처리
		}
		else if(type == "LOGOUT"){
			setWebChatLogout(fromMemberNo);
		}
		else if(type == "SESSIONOUT"){ // 세션 종료시
			clearInterval(intervalObj);
		}
	}
}

/**
 * 사용자가 입력한 채팅 내용을 큐에 담는 메소드
 * 
 * @author tytolee
 * @param toMemberNo : 받을 사용자 번호
 * @param message : 메세지
 * @since 2012-05-22
 */
function send(toMemberNoValue, messageValue){
	var queueObject = new Object();
	
	queueObject.toMemberNo      = toMemberNoValue;
	queueObject.message         = messageValue;
	chatQueue[chatQueue.length] = queueObject;
}

/**
 * 채팅창 Div를 생성하는 메소드
 * 
 * @param fromMemberNo
 * @since 2012-05-22
 * @modify 2012-05-31 (메세지 출력 태그 변경, tytolee)
 */
function createWebChatDiv(fromMemberNo){
	var fromMemberNoDiv = document.createElement("div");
	var body            = document.getElementsByTagName("body");
	
	fromMemberNoDiv.id = fromMemberNo + "Div";
	fromMemberNoDiv.style.backgroundColor = "gray";
	fromMemberNoDiv.style.width = "175px";
	fromMemberNoDiv.style.position = "absolute";
	fromMemberNoDiv.innerHTML = 
		"<table>" +
			"<tr>" +
				"<td align='right'>" +
					"<a href='javascript:void(0);' onClick='javascript:removeWebChatDiv(" + fromMemberNo + ");'>" +
						"닫기" +
					"</a>" +
				"</td>" +
			"</tr>" +
			"<tr>" + 
				"<td>" +
					//"<textarea rows='5' cols='17' id='" + fromMemberNo + "Textarea'></textarea>" + // 자연스런 메세지 출력을 위해 변경(2012-05-30, tytolee)
					"<div style='width : 165px; height : 120px; text-align:left; line-height:1.5em; padding-left:10px; padding-top:10px; overflow:auto; margin-bottom:2px; display:block;' id='" + fromMemberNo + "Textarea'></div>" +
				"</td>" +
			"</tr>" +
			"<tr>" +
				"<td>" +
					"<input type='text' id='" + fromMemberNo+ "Text' style=\"width:120px\"/>" +
					"<input type='button' onClick='javascript:sendMessage(" + fromMemberNo + ");' value='Send' width='35px'/>" +
				"</td>" +
			"</tr>" +
		"</table>";
	
	body[0].appendChild(fromMemberNoDiv);
	
	$("#" + fromMemberNo + "Text").keydown(
		function(e){
			if(e.keyCode==13) {
				sendMessage(fromMemberNo);
			}
		});
	
	$("#" + fromMemberNo + "Div").drag(
		function( ev, dd ){
			$(this).css(
				{
					top: dd.offsetY,
					left: dd.offsetX
				}
			);
		});
}

/**
 * 채팅창 Div를 제거하는 메소드
 * 
 * @author tytolee
 * @param memberNo
 * @since 2012-05-31
 */
function removeWebChatDiv(memberNo){
	var memberNoDiv = document.getElementById(memberNo + "Div");
	var body        = document.getElementsByTagName("body");
	
	body[0].removeChild(memberNoDiv);
}

/**
 * 서버로부터 받은 메세지를 Div에 설정하는 메소드
 * 
 * @author tytolee
 * @param fromMemberNo
 * @param message
 * @since 2012-05-22
 * @modify 2012-05-31 (메세지 출력 태그 변경으로 인한 소스 수정, tytolee)
 */
function setDivMessageServer(fromMemberNo, fromMemberName, message){
	var fromMemberNoTextarea = document.getElementById(fromMemberNo + "Textarea");
	
	// fromMemberNoTextarea.value = fromMemberNoTextarea.value + "\r\n" + fromMemberName + " > " + message; // 태그가 변경되어 주석처리(2012-05-31, tytolee)
	fromMemberNoTextarea.innerHTML = fromMemberNoTextarea.innerHTML + "<br/>" + fromMemberName + " > " + message;
	fromMemberNoTextarea.scrollTop = fromMemberNoTextarea.scrollHeight;
}

/**
 * 자신이 쓴 메세지를 Div에 설정하는 메소드
 * 
 * @author tytolee
 * @param fromMemberNo
 * @param message
 * @since 2012-05-24
 * @modify 2012-05-31 (메세지 출력 태그 변경으로 인한 소스 수정, tytolee)
 */
function setDivMessageSelf(fromMemberNo, message){
	var fromMemberNoTextarea = document.getElementById(fromMemberNo + "Textarea");
	
	//fromMemberNoTextarea.value = fromMemberNoTextarea.value + "\r\n" + selfName + " > " + message;
	fromMemberNoTextarea.innerHTML = fromMemberNoTextarea.innerHTML + "<br/>" + selfName + " > " + message;
	fromMemberNoTextarea.scrollTop = fromMemberNoTextarea.scrollHeight;
}

/**
 * 사용자가 입력한 채팅 내용을 큐에 담는 메소드
 * 
 * @author tytolee
 * @param toMemberNo
 * @since 2012-05-22
 * @modify 2012-05-31 (메세지 있을 경우에만 전달하도록 수정, tytolee)
 */
function sendMessage(toMemberNo){
	var messageValue = document.getElementById(toMemberNo + "Text");
	
	if(messageValue.value != ""){ // 메세지 내용이 있을 경우
		setDivMessageSelf(toMemberNo, messageValue.value); // 대화창에 자신이 입력한 내용을 출력
		send(toMemberNo, messageValue.value);              // 사용자가 입력한 채팅 내용을 큐에 담는다.
	}
	
	messageValue.value = "";
}

/**
 * 채팅 팝업창을 가져오는 메소드
 * 
 * @author tytolee 
 * @param memberNo (조회할 멤버 번호)
 * @param memberName (조회할 멤버 이름)
 * @returns Object (윈도우 오브젝트)
 * @since 2012-06-04
 * @modify 2012-06-20 (파라미터 추가, tytolee)
 * @modify 2012-06-20 (팝업창 생성 파라미터 변경, tytolee)
 */
function getWebChatPop(memberNo, memberName){
	var i = 0;
	
	for(i = 0; i < chatUserArray.length; i++){
		if(chatUserArray[i] == memberNo){
			if(chatPopArray[i].closed){
				return creatWebChatPop(memberNo, memberName); // 새로운 채팅 팝업창을 생성하여 반환
			}
			else{
				return chatPopArray[i]; // 오 픈된 팝업창을 반환
			}
		}
	}
	
	//return creatWebChatPop(memberNo); // 파라미터 변경(2012-06-20, tytolee)
	return creatWebChatPop(memberNo, memberName); // 새로운 채팅 팝업창을 생성하여 반환
}

/**
 * 새로운 채팅 팝업창을 생성하여 반환하는 메소드
 * 
 * @author tytolee
 * @param memberNo
 * @param memberName
 * @returns Object (윈도우 오브젝트)
 * @since 2012-06-04
 * @modify 2012-06-20 (파라미터 추가, tytolee)
 */
function creatWebChatPop(memberNo, memberName){
	var pop = window.open(getContextPath()+"/webChat/talkWebChatPop.sys?memberNo=" + memberNo + "&selfName=" + fncEnCode(selfName) + "&memberName=" + fncEnCode(memberName), memberNo, "width=300,height=400,scrollbars=no,resizable=no");
	var i   = 0;
	
	for(i = 0; i < chatUserArray.length; i++){
		if(chatUserArray[i] == memberNo){ // 한번 생성 되었던 사용자라면
			if(chatPopArray[i].closed){
				chatPopArray[i] = pop;
			}
			
			return chatPopArray[i];
		}
	}
	
	chatUserArray[chatUserArray.length] = memberNo;
	chatPopArray[chatPopArray.length]   = pop;
	
	return chatPopArray[chatPopArray.length - 1];
}

/**
 * 채팅 팝업창에 서버에서 받은 메세지를 입력하는 메소드
 * 
 * @author tytolee
 * @param pop (팝업창 객체)
 * @param fromMemberName (전송자 명)
 * @param message (메세지)
 * @since 2012-06-04
 */
function setPopMessageServer(pop, fromMemberName, message){
	try{
		pop.getMessage(fromMemberName, message);
	}
	catch(e){
		messageSeq = Number(messageSeq) - 1;
	}
}

/**
 * 로그인 사용자 팝업창을 호출하는 메소드
 * @param contextPath (서버의 contextPath -> 최상단 getContextPath()에서 가져와 사용)
 * @author tytolee
 * @since 2012-06-07
 */
function setWebChatLoginPop(contextPath){
	serverContextPath = contextPath;
	if((chatLoginPop != null) && (!chatLoginPop.closed)){ // 팝업창이 존재하고 아직 닫히지 않았다면
		return;
	}
	
	if(isTalkPop){ // 팝업창 대화일 경우에만 호출
		chatLoginPop = window.open(getContextPath()+"/webChat/moveWebChatPop.sys", "webChat", "width=300,height=400,scrollbars=no,resizable=no");
	}
}

/**
 * 서버에서 온 메세지를 설정하는 메소드
 * 
 * @author tytolee
 * @param fromMemberNo
 * @param fromMemberName
 * @param message
 * @since 2012-06-07
 */
function setWebChatMessageServer(fromMemberNo, fromMemberName, message){
	if(isTalkPop){// 팝업창 호출
		//var pop = getWebChatPop(fromMemberNo); // 파라미터 변경으로 인한 수정(2012-06-20, tytolee)
		var pop = getWebChatPop(fromMemberNo, fromMemberName);
		
		setPopMessageServer(pop, fromMemberName, message); // 팝업창에 메세지 전달
	}
	else{
		var fromMemberNoDiv = document.getElementById(fromMemberNo + "Div");
		
		if(fromMemberNoDiv == null){ // 채팅창이 존재하지 않을 경우
			createWebChatDiv(fromMemberNo);
		}
		
		setDivMessageServer(fromMemberNo, fromMemberName, message); // 채팅창에 메세지를 추가하는 메소드
	}
}

/**
 * 사용자 로그인을 처리하는 메소드
 * 
 * @author tytolee
 * @param fromMemberNo
 * @param fromMemberName
 * @since 2012-06-07
 */
function setWebChatLogin(fromMemberNo, fromMemberName, fromMemberBorgNm){
	if(isTalkPop){// 팝업창 호출
		if((chatLoginPop != null) && (!chatLoginPop.closed)){ // 팝업창이 존재하고 아직 닫히지 않았다면
			try{
				chatLoginPop.setWebChatLogin(fromMemberNo, fromMemberName, fromMemberBorgNm);
			}
			catch(e){
				messageSeq = Number(messageSeq) - 1;
			}
		}
	}
	else{
		var records = $('#webChatUserListTable').jqGrid('getDataIDs');
		
		for(var i = 0; i < records.length; i++){ // 중복 사용자 등록 제외
			if(records[i] == fromMemberNo){
				return;
			}					
		}
		
		jQuery("#webChatUserListTable").addRowData(
			fromMemberNo,
			{
				toMemberBorgNm:fromMemberBorgNm,
				toMemberName:fromMemberName,
				toMemberNo:fromMemberNo
			}
		);
	}
}

/**
 * 사용자 로그 아웃을 처리하는 메소드
 * 
 * @author tytolee
 * @param fromMemberNo
 * @since 2012-06-07
 */
function setWebChatLogout(fromMemberNo){
	if(isTalkPop){// 팝업창 호출
		if((chatLoginPop != null) && (!chatLoginPop.closed)){ // 팝업창이 존재하고 아직 닫히지 않았다면
			chatLoginPop.setWebChatLogout(fromMemberNo);
		}
	}
	else{
		jq('#webChatUserListTable').jqGrid('delRowData', fromMemberNo);
	}
}

/*
 * 서버와의 한글 통신을 위한 문자 인코딩 함수
 * 
 * @author : sjisbmoc
 * @source : http://kin.naver.com/qna/detail.nhn?d1id=1&dirId=1040201&docId=120691999&qb=dXRmLTgg7ZWc6riA&enc=utf8&section=kin&rank=3&search_sort=0&spq=0&pid=gRsYMwoi5UKssZRmdi0sss--027113&sid=TUAvOw7jP00AAEUhMDk
 */
function fncEnCode(param){
    var encode = '';

    for(var i=0; i<param.length; i++){
        var len   = '' + param.charCodeAt(i);
        var token = '' + len.length;
        
        encode  += token + param.charCodeAt(i);
    }

    return encode;
}