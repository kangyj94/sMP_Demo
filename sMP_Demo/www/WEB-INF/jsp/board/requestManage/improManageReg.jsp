<%@page import="kr.co.bitcube.board.dto.ImproDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String statFlagCode = "".equals(request.getAttribute("statFlagCode").toString()) ? "":request.getAttribute("statFlagCode").toString();
	String no = "".equals(request.getAttribute("no").toString()) ? "":request.getAttribute("no").toString();
	
	
	ImproDto improDto = (ImproDto)request.getAttribute("detailInfo");	//게시물정보
	String title = "";
	String first = "";
	String message = "";
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

	if(improDto!=null) {
		title = improDto.getTitle();
		first = improDto.getFirst();
 		message = improDto.getMessage(); 		
		file_list1 = CommonUtils.getString(improDto.getFile_List1());
		file_list2 = CommonUtils.getString(improDto.getFile_List2());
		file_list3 = CommonUtils.getString(improDto.getFile_List3());
		file_list4 = CommonUtils.getString(improDto.getFile_List4());
		attach_file_name1 = CommonUtils.getString(improDto.getAttach_file_name1());
		attach_file_name2 = CommonUtils.getString(improDto.getAttach_file_name2());
		attach_file_name3 = CommonUtils.getString(improDto.getAttach_file_name3());
		attach_file_name4 = CommonUtils.getString(improDto.getAttach_file_name4());
		attach_file_path1 = CommonUtils.getString(improDto.getAttach_file_path1());
		attach_file_path2 = CommonUtils.getString(improDto.getAttach_file_path2());
		attach_file_path3 = CommonUtils.getString(improDto.getAttach_file_path3());
		attach_file_path4 = CommonUtils.getString(improDto.getAttach_file_path4());
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

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
		jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>').appendTo('body').submit().remove();
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

<%-- 버튼 이벤트 스크립트 --%>
<script type="text/javascript">
$(document).ready(function(){
	//저장
	$("#regButton").click( function(){ 
		saveContent(); 
	});
	//닫기
	$("#closeButton").click( function() {
		fnClose(); 
	});
	
	nhn.husky.EZCreator.createInIFrame({
		 oAppRef: oEditors,
		 elPlaceHolder: "message",
		 sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
	});
	//
	statFlagCode();
});

function valid(){
// 	var title = $("#title").val();
	var message = $("#message").val();
// 	if(title == ""){
// 		alert("요청명을 입력해 주십시오.");
// 		return false;
// 	}
	var validator = new Trex.Validator();
	if (!validator.exists(message)) {
		alert('내역을 입력해 주십시요');
		return false;
	}
	return true;
}

//등록
function saveContent() { 		// 글 등록시 saveContent() 사용해서 저장
	var statFlagCode = "<%=statFlagCode%>";
	var no = "<%=no%>";
	
// 	alert(statFlagCode);
// 	alert(no);
// 	return;
	if(statFlagCode == "" && no != ""){
		updateImproManage3();
	}else if(statFlagCode == ""){
		insertImproManage2();
	}else if(statFlagCode == "2"){
		updateImproManageHand();
	}else if(statFlagCode == "3"){
		updateImproManageReturn();
	}else if(statFlagCode == "4"){
		updateImproManageHandle();
	}else if(statFlagCode == "5"){
		updateImproManageAnswer();
	}
}

//닫기
function fnClose(){
	window.close();
}
	
function statFlagCode(){
	var statFlagCode = "<%=statFlagCode%>";
	if(statFlagCode == ""){
		$("#titleName").html("요청명");
		$("#titleTr1").show();
	}else if(statFlagCode == "2"){
		$("#titleName").html("접수명");
		$("#titleTr1").hide();
	}else if(statFlagCode == "3"){
		$("#titleName").html("반려명");
		$("#titleTr1").hide();
	}else if(statFlagCode == "4"){
		$("#titleName").html("처리완료명");
		$("#titleTr1").hide();
	}else if(statFlagCode == "5"){
		$("#titleName").html("답변반려");
		$("#titleTr1").hide();
	}
}
var oEditors = [];
function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
} 

function insertImproManage2(){
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
// 	if(!valid()) return;
	var title = $("#title").val();//요청명
	var message =  $("#message").val();
	var requ_User_Numb = $("#requ_User_Numb").val();
	var hand_User_Numb = $("#hand_User_Numb").val();
	var modi_User_Numb = $("#modi_User_Numb").val();
	var file_list1 = $("#file_list1").val();
	var file_list2 = $("#file_list2").val();
	var file_list3 = $("#file_list3").val();
	var file_list4 = $("#file_list4").val();
	var no = $("#no").val();
	
	if(!confirm("저장하시겠습니까?")) return;
	
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	
	$.post(
		"/boardSvc/regImproManage/save.sys" ,
		{
			title:title, 
			message:message,
			oper:"add",
			idGenSvcNm:"seqImpro",
			requ_User_Numb:"<%=userInfoDto.getUserId()%>",		//요청자ID
			borgId:"<%=userInfoDto.getBorgId()%>",				//회원사Id
			file_list1:$("#file_list1").val(),					//첨부파일1
			file_list2:$("#file_list2").val(),					//첨부파일2
			file_list3:$("#file_list3").val(),					//첨부파일3
			file_list4:$("#file_list4").val()					//첨부파일4
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

function updateImproManage3(){
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
// 	if(!valid()) return;
	var title = $("#title").val();//요청명
	var message =  $("#message").val();
	var requ_User_Numb = $("#requ_User_Numb").val();
	var hand_User_Numb = $("#hand_User_Numb").val();
	var modi_User_Numb = $("#modi_User_Numb").val();
	var file_list1 = $("#file_list1").val();
	var file_list2 = $("#file_list2").val();
	var file_list3 = $("#file_list3").val();
	var file_list4 = $("#file_list4").val();
	var no = $("#no").val();
	if(!confirm("저장하시겠습니까?")) return;
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	$.post(
		"/board/updateImproManage3/save.sys",
		{
			title:title, 
			message:message,
			no:"<%=no%>",
			oper:"edit",
			//파라미터 확인
			//기존 file_List1 -> xml 정의 file_list1
			//제대로 철자 쓸것 
			//file_list1 이명칭으로 변경 후 수정 잘됨
			file_list1:file_list1,								//첨부파일1
			file_list2:file_list2,								//첨부파일2
			file_list3:file_list3,								//첨부파일3
			file_list4:file_list4								//첨부파일4
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
				//opener.opener.fnReloadGrid();
				fnClose();
			}
		}
	);
}
/* 접수자 접수버튼*/
function updateImproManageHand(){
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);	

// 	if(!valid()) return;
	var message =  $("#message").val();
	var first = $("#first").val();
	var file_list1 = $("#file_list1").val();
	var file_list2 = $("#file_list2").val();
	var file_list3 = $("#file_list3").val();
	var file_list4 = $("#file_list4").val();
	
	if(!confirm("저장하시겠습니까?")) return;
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	$.post(
		"/board/updateImproManageHand/save.sys",
		{
			oper:"edit",
			no:"<%=no%>",
			first:first,
			handMessage:message,
			hand_User_Numb:"<%=userInfoDto.getUserNm()%>",		//접수자
			file_list1:$("#file_list1").val(),								//첨부파일1
			file_list2:$("#file_list2").val(),								//첨부파일2
			file_list3:$("#file_list3").val(),								//첨부파일3
			file_list4:$("#file_list4").val()								//첨부파일4
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
				//opener.fnReloadGrid();
				//$(opener.opener).attr("href", "javascript:fnReloadGrid();");
				fnClose();
			}
		}
	);
}
//접수자 반려버튼
function updateImproManageReturn(){
	
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
// 	if(!valid()) return;
	var message =  $("#message").val();
	var file_list1 = $("#file_list1").val();
	var file_list2 = $("#file_list2").val();
	var file_list3 = $("#file_list3").val();
	var file_list4 = $("#file_list4").val();
	
	if(!confirm("저장하시겠습니까?")) return;
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	$.post(
		"/board/updateImproManageReturn/save.sys",
		{
			oper:"edit",
			no:"<%=no%>",
			handMessage:message,
			hand_User_Numb:"<%=userInfoDto.getUserNm()%>",
			file_list1:$("#file_list1").val(),					//첨부파일1
			file_list2:$("#file_list2").val(),					//첨부파일2
			file_list3:$("#file_list3").val(),					//첨부파일3
			file_list4:$("#file_list4").val()					//첨부파일4
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
				//parent.window.opener.fnReloadGrid();
				fnClose();
			}
		}
	);
}
//답변자 처리완료
function updateImproManageHandle(){
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
// 	if(!valid()) return;
	var message = $("#message").val();
	var file_list1 = $("#file_list1").val();
	var file_list2 = $("#file_list2").val();
	var file_list3 = $("#file_list3").val();
	var file_list4 = $("#file_list4").val();
	
	if(!confirm("저장하시겠습니까?")) return;
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	$.post(
		"/board/updateImproManageHandle/save.sys",
		{
			oper:"edit",
			no:"<%=no%>",
			req_Message:message,
			modi_User_Numb:"<%=userInfoDto.getUserNm()%>",		//답변자
			file_list1:$("#file_list1").val(),					//첨부파일1
			file_list2:$("#file_list2").val(),					//첨부파일2
			file_list3:$("#file_list3").val(),					//첨부파일3
			file_list4:$("#file_list4").val()					//첨부파일4
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
				//opener.opener.fnReloadGrid();
				fnClose();
			}
		}
	);
}
//답변자 반려
function updateImproManageAnswer(){
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
// 	if(!valid()) return;
	var message = $("#message").val();
	var file_list1 = $("#file_list1").val();
	var file_list2 = $("#file_list2").val();
	var file_list3 = $("#file_list3").val();
	var file_list4 = $("#file_list4").val();
	
	if(!confirm("저장하시겠습니까?")) return;
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	$.post(
		"/board/updateImproManageAnswer/save.sys",
		{
			oper:"edit",
			no:"<%=no%>",
			req_Message:message,
			modi_User_Numb:"<%=userInfoDto.getUserNm()%>",		//답변자
			file_list1:$("#file_list1").val(),					//첨부파일1
			file_list2:$("#file_list2").val(),					//첨부파일2
			file_list3:$("#file_list3").val(),					//첨부파일3
			file_list4:$("#file_list4").val()					//첨부파일4
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
				//opener.opener.fnReloadGrid();
				fnClose();
			}
		}
	);
}

// function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
// 	jq("#list").trigger("reloadGrid");
// }

</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>
						요청사항정보
					</td>
				</tr>
			</table>    
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	
	<%	if("".equals(statFlagCode)||"1".equals(statFlagCode)||"3".equals(statFlagCode)||"4".equals(statFlagCode)||"5".equals(statFlagCode)) { %>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr id="titleTr1">
					<td width="60" class="table_td_subject">
						<span id="titleName"></span>
					</td>
					<td colspan="3" class="table_td_contents">
						<input type="text" id="title" name="title" class="input" style="width:68%" value="<%=title %>" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						첨부파일1
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value="<%=(!"".equals(statFlagCode)) ? "" : file_list1 %>"/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=(!"".equals(statFlagCode)) ? "" : attach_file_path1 %>"/> 
<!-- 						<a href="javascript:fnAttachFileDownload(($('#attach_file_path1').val()).replace(/\\/g,'\\\\'));"> -->
						<a href="javascript:fnAttachFileDownload('<%=(!"".equals(statFlagCode)) ? "" : attach_file_path1 %>');">
							<span id="attach_file_name1"><%=(!"".equals(statFlagCode)) ? "" : attach_file_name1 %></span>
						</a>
										
						<button id="btnAttach1" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel1" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일2
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value="<%=(!"".equals(statFlagCode)) ? "" : file_list2 %>"/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=(!"".equals(statFlagCode)) ? "" : attach_file_path2 %>"/>
<!-- 						<a href="javascript:fnAttachFileDownload(($('#attach_file_path2').val()).replace(/\\/g,'\\\\'));"> -->
						<a href="javascript:fnAttachFileDownload('<%=(!"".equals(statFlagCode)) ? "" : attach_file_path2 %>');">
							<span id="attach_file_name2"><%=(!"".equals(statFlagCode)) ? "" : attach_file_name2 %></span>
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
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list3" name="file_list3" value="<%=(!"".equals(statFlagCode)) ? "" : file_list3 %>"/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=(!"".equals(statFlagCode)) ? "" : attach_file_path3 %>"/>
<!-- 						<a href="javascript:fnAttachFileDownload(($('#attach_file_path3').val()).replace(/\\/g,'\\\\'));"> -->
						<a href="javascript:fnAttachFileDownload('<%=(!"".equals(statFlagCode)) ? "" : attach_file_path3 %>');">
							<span id="attach_file_name3"><%=(!"".equals(statFlagCode)) ? "" : attach_file_name3 %></span>
						</a>
						<button id="btnAttach3" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel3" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일4
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list4" name="file_list4" value="<%=(!"".equals(statFlagCode)) ? "" : file_list4 %>"/>
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=(!"".equals(statFlagCode)) ? "" : file_list4 %>"/>
<!-- 						<a href="javascript:fnAttachFileDownload(($('#attach_file_path4').val()).replace(/\\/g,'\\\\'));"> -->
						<a href="javascript:fnAttachFileDownload('<%=(!"".equals(statFlagCode)) ? "" : attach_file_path4 %>');">
							<span id="attach_file_name4"><%=(!"".equals(statFlagCode)) ? "" : attach_file_name4 %></span>				
						</a>
						<button id="btnAttach4" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel4" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						요청내역 
					</td>
					<td colspan="3" height="250" valign="top" class="table_td_contents4">
						<textarea id="message" name="message" required title="내용" style="min-width:450px;height:305px;display:none"><%=(!"".equals(statFlagCode)) ? "" :message%></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<%	} %>
	
	
	<%	if("2".equals(statFlagCode)) { %>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr id="titleTr1">
					<td width="60" class="table_td_subject">
						<span id="titleName"></span>
					</td>
					<td colspan="3" class="table_td_contents">
						<input type="text" id="title" name="title" class="input" style="width:68%" value="<%=title %>" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						첨부파일1
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value="<%= (!"".equals(statFlagCode)) ? "" : file_list1 %>"/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=(!"".equals(statFlagCode)) ? "" : attach_file_path1  %>"/> 
						<a href="javascript:fnAttachFileDownload('<%=(!"".equals(statFlagCode)) ? "" : attach_file_path1 %>');">
							<span id="attach_file_name1"><%= (!"".equals(statFlagCode)) ? "" : attach_file_name1 %></span>
						</a>				
						<button id="btnAttach1" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel1" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일2
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value="<%=(!"".equals(statFlagCode)) ? "" : file_list2 %>"/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=(!"".equals(statFlagCode)) ? "" : attach_file_path2 %>"/>
						<a href="javascript:fnAttachFileDownload('<%=(!"".equals(statFlagCode)) ? "" : attach_file_path2 %>');">
							<span id="attach_file_name2"><%=(!"".equals(statFlagCode)) ? "" : attach_file_name2 %></span>				
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
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list3" name="file_list3" value="<%=(!"".equals(statFlagCode)) ? "" : file_list3 %>"/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=(!"".equals(statFlagCode)) ? "" : attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload('<%=(!"".equals(statFlagCode)) ? "" : attach_file_path3 %>');">
							<span id="attach_file_name3"><%=(!"".equals(statFlagCode)) ? "" : attach_file_name3 %></span>				
						</a>
						<button id="btnAttach3" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel3" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일4
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list4" name="file_list4" value="<%=(!"".equals(statFlagCode)) ? "" : file_list4 %>"/>
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=(!"".equals(statFlagCode)) ? "" : file_list4 %>"/>
						<a href="javascript:fnAttachFileDownload('<%=(!"".equals(statFlagCode)) ? "" : attach_file_path4 %>');">
							<span id="attach_file_name4"><%=(!"".equals(statFlagCode)) ? "" : attach_file_name4 %></span>				
						</a>
						<button id="btnAttach4" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel4" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
					<td width="60" class="table_td_subject">
						우선순위
					</td>
					<td  class="table_td_contentsd" colspan="3">
					&nbsp;&nbsp;<input type="text" id="first" name="first"	style="width:20%;" value=""/>
					</td>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						접수내역 
					</td>
					<td colspan="3" height="250" valign="top" class="table_td_contents4">
						<textarea id="message" name="message" required title="내용" style="min-width:450px;height:305px;display:none"><%=(!"".equals(statFlagCode)) ? "" :message%></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<%	} %>
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
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
</body>
</html>