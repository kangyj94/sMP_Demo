<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
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
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var oEditors = [];

$(document).ready(function(){
    $("#regButton").click(function(){
    	saveContent();
    });
    
    $("#closeButton").click(function(){
    	fnClose();
    });
    
    nhn.husky.EZCreator.createInIFrame({
		 oAppRef: oEditors,
		 elPlaceHolder: "message",
		 sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
	});
});

function fnClose(){
	window.close();
}

function saveContent() { // 글 등록시 saveContent() 사용해서 저장
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
	
	var title       = $("#title").val();
	var emailStr    = $("#email").val();
	var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
	var tel         = $("#tel").val();
	var message     = $("#message").val();
	var file_list1  = $("#file_list1").val();
	var file_list2  = $("#file_list2").val();
	var file_list3  = $("#file_list3").val();
	var file_list4  = $("#file_list4").val();
	
	if(email_regex.test(emailStr) == false){
		alert("메일주소가 잘못되었습니다. \n다시 입력해주세요.");
		
		return;
	}
	
	if(title == ""){
		alert("제목을 입력해 주십시오.");
		
		return;
	}
	
	if((message == "") || (message == "<p>&nbsp;</p>")){
		alert('내용을 입력해 주십시요');
		
		return;
	}
	
	if(confirm("내용을 송부하시겠습니까?") == false){
		return;
	}
	
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/voc/regVoc.sys",
		{
			title      : title,
			message    : message,
			email      : emailStr,
			tel        : tel,
			file_list1 : file_list1,
			file_list2 : file_list2,
			file_list3 : file_list3,
			file_list4 : file_list4
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse; 
			var errors = "";
			
			if (result.success == false) {
				for (var i = 0; i < result.message.length; i++) {
					errors +=  result.message[i] + "<br/>";
				}
				
				alert(errors);
			}
			else{
				alert("처리 하였습니다.");
				
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
</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>고객의 소리</td>
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
					<td width="100" class="table_td_subject">제목</td>
					<td class="table_td_contents">
						<input type="text" id="title" name="title" class="input" style="width:100%" value=""/>	
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">이메일</td>
					<td class="table_td_contents">
						<input type="text" id="email" name="email" class="input" style="width:90%" value="<%=loginUserDto.getEmail()%>"/>	
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">연락처</td>
					<td class="table_td_contents">
						<input type="text" id="tel" name="tel" class="input" style="width:70%" value="<%=loginUserDto.getMobile()%>" onkeydown="return onlyNumber(event);"/>	
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">내용</td>
					<td colspan="3" height="150" class="table_td_contents4">
						<textarea id="message" name="message" required title="내용" style="min-width:450px;height:300px;display:none"></textarea>
					</td> 
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="18%" class="table_td_subject">
						첨부파일1
						<a href="#">
							<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value=""/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value=""/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
							<span id="attach_file_name1"></span>
						</a>
					</td>
					<td width="18%" class="table_td_subject">
						첨부파일2
						<a href="#">
							<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value=""/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value=""/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
							<span id="attach_file_name2"></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="18%" class="table_td_subject">
						첨부파일3
						<a href="#">
							<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="file_list3" name="file_list3" value=""/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value=""/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
							<span id="attach_file_name3"></span>
						</a>
					</td>
					<td width="18%" class="table_td_subject">
						첨부파일4
						<a href="#">
							<img id="btnAttach4" name="btnAttach4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="file_list4" name="file_list4" value=""/>
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value=""/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
							<span id="attach_file_name4"></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
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
			<span id="regButton" style="cursor:pointer;"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_send.gif" width="65" height="23" /> </span>
			<span id="closeButton" style="cursor:pointer;"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" width="65" height="23" /></span>
		</td>
	</tr>
</table>
</form>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
</body>
</html>