<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	BoardDto boardDto = (BoardDto)request.getAttribute("detailInfo");	//게시물정보
	String board_Type = "";
	String board_Borg_Type = "";
	String title = "";
	String message = "";
	String popup_Start = CommonUtils.getCurrentDate();
	String popup_End = CommonUtils.getCustomDay("MONTH", 1);
	String regi_User_Numb = userInfoDto.getUserNm();
	String regi_BorgId = userInfoDto.getBorgId();
	String email_Yn = "";
	String sms_Yn = "";
	String oper = "";
	String board_No = ""; 
	String regi_Date_Time = CommonUtils.getCurrentDate();
	String file_list1 = "";
	String file_list2 = "";
	String file_list3 = "";
	String file_list4 = "";
	String attach_file_name1 = "";
	String attach_file_name2 = "";
	String attach_file_name3 = "";
	String attach_file_name4 = "";
	String attach_file_path1 = "";
	String attach_file_path2 = "";
	String attach_file_path3 = "";
	String attach_file_path4 = "";
	String importantYn       = "";
	String emergencyYn       = "";
	
	String workInfo = "";
	if(boardDto!=null) {
		board_Type = boardDto.getBoard_Type();
		board_Borg_Type = boardDto.getBoard_Borg_Type();
		title = boardDto.getTitle();
		message = boardDto.getMessage();
		popup_Start = boardDto.getPopup_Start();
		popup_End = boardDto.getPopup_End();
		regi_User_Numb = boardDto.getRegi_User_Numb();
		regi_Date_Time = boardDto.getRegi_Date_Time();
		regi_BorgId = boardDto.getRegi_BorgId();
		email_Yn = boardDto.getEmail_Yn();
		sms_Yn = boardDto.getSms_Yn();
		board_No = boardDto.getBoard_No();
		file_list1 = CommonUtils.getString(boardDto.getFile_List1());
		file_list2 = CommonUtils.getString(boardDto.getFile_List2());
		file_list3 = CommonUtils.getString(boardDto.getFile_List3());
		file_list4 = CommonUtils.getString(boardDto.getFile_List4());
		attach_file_name1 = CommonUtils.getString(boardDto.getAttach_file_name1());
		attach_file_name2 = CommonUtils.getString(boardDto.getAttach_file_name2());
		attach_file_name3 = CommonUtils.getString(boardDto.getAttach_file_name3());
		attach_file_name4 = CommonUtils.getString(boardDto.getAttach_file_name4());
		attach_file_path1 = CommonUtils.getString(boardDto.getAttach_file_path1());
		attach_file_path2 = CommonUtils.getString(boardDto.getAttach_file_path2());
		attach_file_path3 = CommonUtils.getString(boardDto.getAttach_file_path3());
		attach_file_path4 = CommonUtils.getString(boardDto.getAttach_file_path4());
		workInfo = CommonUtils.getString(boardDto.getWorkInfo());
		importantYn = boardDto.getImportantYn();
		emergencyYn = boardDto.getEmergencyYn();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- Datepicker Z-index Setting(because of editor z-index) -->
<style type="text/css">
.ui-datepicker { z-index: 1003 !important; /* must be > than popup editor (1002) */ }
</style>
<%
/**------------------------------------사용방법---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
------------------------------------------------------------------------------*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#file_list1").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#file_list2").val(), "fnCallBackAttach2"); });
	$("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#file_list3").val(), "fnCallBackAttach3"); });
	$("#btnAttach4").click(function(){ fnUploadDialog("첨부파일4", $("#file_list4").val(), "fnCallBackAttach4"); });
	$("#btnAttachDel1").click(function(){ fnAttachDel('file_list1'); });
	$("#btnAttachDel2").click(function(){ fnAttachDel('file_list2'); });
	$("#btnAttachDel3").click(function(){ fnAttachDel('file_list3'); });
	$("#btnAttachDel4").click(function(){ fnAttachDel('file_list4'); });
	
});
/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list1").val(rtn_attach_seq);
	$("#attach_file_name1").text(rtn_attach_file_name);
	$("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list2").val(rtn_attach_seq);
	$("#attach_file_name2").text(rtn_attach_file_name);
	$("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list3").val(rtn_attach_seq);
	$("#attach_file_name3").text(rtn_attach_file_name);
	$("#attach_file_path3").val(rtn_attach_file_path);
}
/**
 * 첨부파일4 파일관리
 */
function fnCallBackAttach4(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list4").val(rtn_attach_seq);
	$("#attach_file_name4").text(rtn_attach_file_name);
	$("#attach_file_path4").val(rtn_attach_file_path);
}
/**
 * 파일다운로드
 */
function fnAttachFileDownload(attach_file_path) {
	var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}

jQuery.download = function(url, data, method){
    // url과 data를 입력받음
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};

function fnAttachDel(columnName) {
	if(columnName=='file_list1') {
		$("#file_list1").val('');
		$("#attach_file_name1").text('');
		$("#attach_file_path1").val('');
	} else if(columnName=='file_list2') {
		$("#file_list2").val('');
		$("#attach_file_name2").text('');
		$("#attach_file_path2").val('');
	} else if(columnName=='file_list3') {
		$("#file_list3").val('');
		$("#attach_file_name3").text('');
		$("#attach_file_path3").val('');
	} else if(columnName=='file_list4') {
		$("#file_list4").val('');
		$("#attach_file_name4").text('');
		$("#attach_file_path4").val('');
	} 
}
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	
	$("#regButton").click(function(){	saveContent();	});
	$("#closeButton").click(function(){	fnClose();	});

	$("#popup_Start").val("<%=popup_Start%>");
	$("#popup_End").val("<%=popup_End%>");
	

	//버튼 이벤트
	$("#board_Borg_Type").change(function(){ workInfoChange(); });
	
	//공지사항 수정시 고객유형 값 매칭
	var workInfo = "<%=workInfo%>";
	if(workInfo != "" && '<%=board_Type%>'=='0101'){
		workInfoDiv();
		$("#workIdSave").val(workInfo);
		$("#workInfoDiv").show();
	}
	if('<%=board_Type%>'=='0111') {
		$("#board_Borg_Type").val('');
		$("#board_Borg_Type").attr("disabled",true);
	}
	
	if($("#board_Type").val()=="0102") {
		$("#popup_Start").val("");
		$("#popup_End").val("");
		$("#popup_Start").attr("disabled",true);
		$("#popup_End").attr("disabled",true);
		$("#popup_Start").datepicker({ showOn:"" });
		$("#popup_End").datepicker({ showOn:"" });
	}
	

	nhn.husky.EZCreator.createInIFrame({
		 oAppRef: oEditors,
		 elPlaceHolder: "message",
		 sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
	});
	
});

$(function(){
	$("#popup_Start").datepicker(
       	{
	   		showOn: "button",
	   		buttonImage: "/img/system/btn_icon_calendar.gif",
	   		buttonImageOnly: true,
	   		dateFormat: "yy-mm-dd"
       	}
	);
	$("#popup_End").datepicker(
       	{
       		showOn: "button",
       		buttonImage: "/img/system/btn_icon_calendar.gif",
       		buttonImageOnly: true,
       		dateFormat: "yy-mm-dd"
       	}
	);
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

function fnClose(){
	window.close();
}

function CalendarView(calval){
	$("#board_Borg_Type").attr("disabled",false);
	if(calval == "0101" || calval == "0111") {
		$("#popup_Start").datepicker("enable");
 		$("#popup_End").datepicker("enable");
 		if(calval == "0111") {
 			$("#checkedWorkInfo").html("");
 			$("#board_Borg_Type").val('');
 			$("#board_Borg_Type").attr("disabled",true);
 		}
 	} 
// 	else if(calval == "0102") {
// 		$("#popup_Start").datepicker("disable");
//  		$("#popup_End").datepicker("disable");	
//  	}
}


var oEditors = [];
function saveContent() {
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
	
	var title           = $("#title").val();
	var message         = $("#message").val();
	var oper            = $("#oper").val();
	var board_Borg_Type = $("#board_Borg_Type").val();
	var email_Yn        = "N";
	var sms_Yn          = "N";
	var board_Type      = document.getElementById("board_Type").value;
	var popup_Start     = document.getElementById("popup_Start").value;
	var popup_End       = document.getElementById("popup_End").value;
	var file_list1      = $("#file_list1").val();
	var file_list2      = $("#file_list2").val();
	var file_list3      = $("#file_list3").val();
	var file_list4      = $("#file_list4").val();
	var regi_BorgId     = $("#regi_BorgId").val();
	var workId          = $("#workIdSave").val();
	var regi_User_Numb  = document.getElementById("regi_User_Numb").value;
	var board_No        = document.getElementById("board_No").value;
	var important       = "N";
	var emergency       = "N";
	
	if(document.getElementById("email_Yn").checked){
		email_Yn = "Y";
	}
	
	if(document.getElementById("sms_Yn").checked){
		sms_Yn = "Y";
	}
	
	if(document.getElementById("important").checked){
		important = "Y";
	}
	
	if(document.getElementById("emergency").checked){
		emergency = "Y";
	}
	
	if(workId == ""){
		$("#workInfoAllChk").attr("checked", true);
		workInfoAllCheckFlag();
		workId = $("#workIdSave").val();
	}

// 	if(board_Type=="0102") {
// 		popup_Start = "";
// 		popup_End = "";
// 	}
	
	if(title == ""){
		alert("제목을 입력해 주십시오.");
		
		return;
	}
	if( ! message || message == '<p>&nbsp;</p>'){
		alert("내용을 입력하여 주시기 바랍니다.");
		
		return;
	}	
	
	if(!confirm("내용을 저장하시겠습니까?")){
		return;
	}
	
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/board/noticeTransGrid.sys",
		{
			title       : title,       message    : message,    oper        : oper,         board_Type : board_Type, board_Borg_Type : board_Borg_Type, 
			email_Yn    : email_Yn,    sms_Yn     : sms_Yn,     popup_Start : popup_Start , popup_End  : popup_End,  regi_User_Numb  : regi_User_Numb,
			board_No    : board_No,    file_list1 : file_list1, file_list2  : file_list2,   file_list3 : file_list3, file_list4      : file_list4,
			regi_BorgId : regi_BorgId, workId     : workId,     important   : important,    emergency  : emergency
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			var errors = "";
			if (result.success == false) {
				for (var i = 0; i < result.message.length; i++) {
					errors +=  result.message[i] + "<br/>";
				}
				alert(errors);
			} else {
				alert("처리 하였습니다.");
				window.opener.fnReloadGrid();
				fnClose();
			}
		}
	);
}

function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
}

//고객유형을 체크박스 DIV생성
function workInfoDiv() {
$("#workTable").empty();
var cnt = 0;
	$.post(
		"/board/selectWorkInfo/list.sys",
		{},
		function(arg){
			var workList = eval("("+arg+")").list;
			var htmlStr = "";
			htmlStr += "<tr><td align='center'>고객유형</td><td align='left'><input type='checkbox' id='workInfoAllChk' name='workInfoAllChk' value='All' onclick ='workInfoAllCheckFlag();'>전체선택</td></tr>"
			for(var i=0; i<workList.length; i++){
				if(i%2 == 0){
					htmlStr +="<tr>";
				}
				htmlStr += "<td><input type='checkbox' id='"+workList[i].WORKID+"' name='workInfoChk' value='"+workList[i].WORKNM+"' onclick ='workInfoCheckFlag();'>"+workList[i].WORKNM+"</input></td>";
				if(i%2 == 1){
					htmlStr +="</tr>";
				}
				++cnt;
			}
			htmlStr += "<tr><td></td><td><input type='button' value='선택' onclick='workInfoSelect();'/><input type='button' value='닫기' onclick='workInfoDivClose();'/></td></tr>";
			$("#workTable").append(htmlStr);
			var chkCnt = modCheckedWorkInfo();
			if(chkCnt == cnt){
				$("#workInfoAllChk").attr("checked", true);
				workInfoAllCheckFlag();
			}else{
				checkedWorkInfo();
			}
		}
	);
}

//팝업공지 이고 고객사 일때 해당되는 이벤트
function workInfoChange(){
	var svcType = $("#board_Borg_Type").val();
	var boardType = $("#board_Type").val();
	if(boardType == "0101"){
		if(svcType == "BUY"){
			workInfoDiv();//고객유형 DIV생성
			$("#workInfoDiv").show();
		}else{
			$("#workInfoDiv").hide();
			//체크된 고객유형없애기
			workInfoNotChecked();
		}
	}
}

//체크된 고객유형 삭제
function workInfoNotChecked(){
	$("input:checkbox[name='workInfoChk']").attr("checked", false);
	$("#workInfoAllChk").attr("checked", false);
	$("#checkedWorkInfo").html("");
}

//고객유형 전체 체크 유효성검사
function workInfoAllCheckFlag(){
	if($("#workInfoAllChk").is(":checked")){
		//전체선택 할 경우 모든고객유형 체크
		$("input:checkbox[name='workInfoChk']").attr("checked", true);
	}else{
		$("input:checkbox[name='workInfoChk']").attr("checked", false);
	}
}

//고객유형 체크 유효성검사
function workInfoCheckFlag(){
	if($("input:checkbox[name='workInfoChk']").is(":checked")){
		//고객유형을 선택한뒤 전체 선택을 하게되면 체크된 고객유형은 삭제 되고 전체 선택됨
		if($("#workInfoAllChk").is(":checked")){
			$("#workInfoAllChk").attr("checked", false);
		}
	}
}

//고객유형 체크 펑션
function workInfoSelect(){
	var cnt = 0;
	var workInfoName = "";
	var workId = "†";
	$("input:checkbox[name='workInfoChk']").each(function(){
		if(this.checked){
			if(cnt ==0){
				workInfoName = $(this).val();
			}
			workId += this.id+"†";
			cnt++;
		}
	});
	$("#workIdSave").val("");
	$("#workIdSave").val(workId);
	if(cnt > 0){
		$("#checkedWorkInfo").html("<a href='javascript:checkedWorkInfo();'>"+workInfoName+" 외 "+--cnt+"건 </a>");
	}else{
		$("#checkedWorkInfo").html("<a href='javascript:checkedWorkInfo();'>"+workInfoName+"</a>");
	}
	$("#workInfoDiv").hide();
}

//체크된 고객유형 매칭
function checkedWorkInfo(){
	var workIdSave = $("#workIdSave").val();
	var workIdSaveArr = new Array(); 
	$("#workInfoDiv").show();
	workIdSaveArr = workIdSave.split("†");
	for(var i=0; i<workIdSaveArr.length; i++){
		if(workIdSaveArr[i] != ""){
			$("input:checkbox[id='"+workIdSaveArr[i]+"']").attr("checked", true);
		}
	}
}

//글수정시 고객유형체크
var modCheckedWorkInfo = function (){
	var workIdSave = $("#workIdSave").val();
	var workIdSaveArr = new Array(); 
	$("#workInfoDiv").show();
	workIdSaveArr = workIdSave.split("†");
	var cnt = 0;
	for(var i=0; i<workIdSaveArr.length; i++){
		if(workIdSaveArr[i] != ""){
			++cnt;
		}
	}
	return cnt;
}


//고객유형 DIV 닫기(DIV를 닫으면 고객유형 전체로 체크)
function workInfoDivClose(){
	$("#workInfoDiv").hide();
	//체크된 고객유형없애기
	workInfoNotChecked();
	$("#workIdSave").val("");
}

</script>
<style type="text/css">
input[type=checkbox] {vertical-align: bottom;}
</style>
</head>
<form id="frm" name="frm" method="post">
<input type="hidden" name="oper" id="oper" value="<%=!"".equals(board_No) ? "edit" : "add"%>" /> 
<input type="hidden" name="board_No" id="board_No" value="<%=board_No %>" />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>공지사항</td>
				</tr>
			</table>    
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">제목</td>
					<td class="table_td_contents" colspan="4">
<!-- 						<table width="100%"  border="0" cellspacing="0" cellpadding="0"> -->
<!-- 							<tr> -->
<!-- 								<td width="330"> -->
									<select name="board_Type" id="board_Type" onchange="javascript:CalendarView(this.value);" <%=boardDto==null ? "" : "disabled" %>>
										<option value="0101" <%=board_Type.equals("0101") ? "selected" : "" %> >팝업공지</option>
										<option value="0111" <%=board_Type.equals("0111") ? "selected" : "" %> >초기팝업</option>
										<option value="0102" <%=board_Type.equals("0102") ? "selected" : "" %> >일반공지</option>
									</select>
									<select name="board_Borg_Type" id="board_Borg_Type"> 
										<option value="ALL">전체</option>
										<option value="BUY" <%=board_Borg_Type.equals("BUY")? "selected" : "" %> >고객사</option>
										<option value="VEN" <%=board_Borg_Type.equals("VEN")? "selected" : "" %> >공급사</option>
									</select> 
									<input type="checkbox" id="important" <%if("Y".equals(importantYn)){ %> checked="checked" <%} %>/> 중요
									<input type="checkbox" id="emergency" <%if("Y".equals(emergencyYn)){ %> checked="checked" <%} %>/> 긴급공지
									<span id="checkedWorkInfo" style="color:#2478FF;"></span>
									
									<input type="text" id="title" name="title" class="input" style="width:78%" value="<%=title %>"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
               		<td width="60" class="table_td_subject">기간</td>
					<td colspan="3" class="table_td_contents">
						<input type="text" name="popup_Start" id="popup_Start" style="width: 75px;vertical-align: middle;"/>
							~
						<input type="text" name="popup_End" id="popup_End" style="width: 75px;vertical-align: middle;" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">내용</td>
					<td colspan="3" height="150" class="table_td_contents4">
						<textarea id="message" name="message" required title="내용" style="min-width:450px;height:305px;display:none"><%=message%></textarea>
					</td> 
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						첨부파일1
					</td>
					<td width="32%" class="table_td_contents">
						
						<input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1 %>"/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
						<span id="attach_file_name1"><%=attach_file_name1 %></span>
						</a>						
						<button id="btnAttach1" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel1" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일2
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2 %>"/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
						<span id="attach_file_name2"><%=attach_file_name2 %></span>
						</a>						
						<button id="btnAttach2" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel2" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						첨부파일3
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3 %>"/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
						<span id="attach_file_name3"><%=attach_file_name3 %></span>
						</a>						
						<button id="btnAttach3" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel3" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일4
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="file_list4" name="file_list4" value="<%=file_list4 %>"/>
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=attach_file_path4 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
						<span id="attach_file_name4"><%=attach_file_name4 %></span>
						</a>						
						<button id="btnAttach4" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel4" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject" width="20%">등록자</td>
					<td class="table_td_contents" width="40%">
						<input type="text" id="regi_User_Numb" name="regi_User_Numb" value="<%=regi_User_Numb %>" style="border: none;" />
					</td>
					<td width="60" class="table_td_subject" width="20%">등록일</td>
					<td class="table_td_contents" width="40%">
						<%=regi_Date_Time%>
					</td>
				</tr>
<!-- 				<tr> -->
<!-- 					<td colspan="4" height='1' bgcolor="eaeaea"></td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td width="100" class="table_td_subject" width="20%">이메일발송여부</td> -->
<!-- 					<td class="table_td_contents" width="40%"> -->
<%-- 						<input id="email_Yn" name="email_Yn" type="checkbox" <%=email_Yn.equals("Y")?"checked" : "" %> style="border: 0" /> --%>
<!-- 					</td> -->
<!-- 					<td width="100" class="table_td_subject" width="20%">SMS발송여부</td> -->
<!-- 					<td class="table_td_contents" width="40%" > -->
<%-- 						<input id="sms_Yn" name="sms_Yn" type="checkbox" <%=sms_Yn.equals("Y")?"checked" : "" %> style="border: 0" /> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
				<tr>
					<td colspan="4" class="table_top_line">
						<input id="email_Yn" name="email_Yn" type="hidden" />
						<input id="sms_Yn" name="sms_Yn" type="hidden" />
					</td>
				</tr>
			</table>    
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
			<button id="regButton" type="button" class="btn btn-danger btn-sm"><i class="fa fa-save"></i> 저장</button>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
		</td>
	</tr>
</table>
</form>

<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>

<div id="workInfoDiv" style="position: absolute; width: 360px; height: 120px; left: 350px; top: 10px; background-color: white; display: none; z-index: 5000;">
	<table border="2" cellpadding="0" cellspacing="0" style="border-color:#dbeaf7; width: 100%; height: 100%; background-color: white;">
		<tr>
			<td>
				<input type="hidden" id="workIdSave" name="workIdSave" value=""/>
				<table border="0" style="width: 100%; height: 100%;" id="workTable">
				</table>
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
</body>
</html>