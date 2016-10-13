<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%
	String boardTitle = CommonUtils.getString(request.getAttribute("boardTitle"));	//해당글 제목
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	BoardDto boardDto = (BoardDto)request.getAttribute("detailInfo");	//게시물정보
	String oper = "";
	String board_No = request.getParameter("board_No");
	String board_Type = boardDto.getBoard_Type();
	String title = boardDto.getTitle();
	String message = "";
	String regi_User_Numb = userInfoDto.getUserNm();
	String regi_Date_Time = CommonUtils.getCurrentDate();
	String group_No = boardDto.getGroup_No();
	String parent_Board_No = boardDto.getBoard_No();
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


<script type="text/javascript">
 $(document).ready(function(){
	$("#regButton").click( function(){ saveContent();});
	$("#closeButton").click( function() { fnClose(); });
	

	nhn.husky.EZCreator.createInIFrame({
		 oAppRef: oEditors,
		 elPlaceHolder: "message",
		 sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
	});
	
 });

function fnClose(){
	window.close();
}
</script>
</head>
<body> 
<form id="frm" name="frm" method="post">
<input type="hidden" name="oper" id="oper" value="<%=!"".equals(board_No) ? "add" : "edit"%>" /> 
<input type="hidden" name="board_No" id="board_No" value="<%=board_No%>" />
<input type="hidden" name="group_No" id="group_No" value="<%=group_No%>" />
<input type="hidden" name="parent_Board_No" id="parent_Board_No" value="<%=parent_Board_No%>" />
<input type="hidden" name="board_Type" id="board_Type" value="<%=board_Type%>" />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'><%=boardTitle %></td>
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
					<td colspan="3" class="table_td_contents">
						<img src='/img/system/icon_reply.gif' border='0'/>	
						<input type="text" id="title" name="title" class="input" style="width:68%; background-color: #eaeaea;" value="[답변]<%=title%>" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">내용</td>
					<td colspan="3" height="150" class="table_td_contents4">
						<textarea id="message" name="message" required title="내용" style="min-width:450px;height:320px;display:none"><%=message%></textarea>
					</td> 
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						첨부파일1
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1 %>"/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path1').val()).replace(/\\/g,'\\\\'));">
						<span id="attach_file_name1"><%=attach_file_name1 %></span>
						</a>					
						<button id="btnAttach1" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel1" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일2
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2 %>"/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path2').val()).replace(/\\/g,'\\\\'));">
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
					<td class="table_td_contents">
						<input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3 %>"/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path3').val()).replace(/\\/g,'\\\\'));">
						<span id="attach_file_name3"><%=attach_file_name3 %></span>
						</a>					
						<button id="btnAttach3" type="button" class="btn btn-primary btn-xs">등록</button>
						<button id="btnAttachDel3" type="button" class="btn btn-default btn-xs">삭제</button>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일4
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list4" name="file_list4" value="<%=file_list4 %>"/>
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=attach_file_path4 %>"/>
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path4').val()).replace(/\\/g,'\\\\'));">
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
					<td width="60" class="table_td_subject" >등록자</td>
					<td class="table_td_contents">
						<input type="text" id="regi_User_Numb" name="regi_User_Numb" value="<%=regi_User_Numb %>" style="border: none;" />
					</td>
					<td width="" class="table_td_subject">등록일</td>
					<td class="table_td_contents">
						<%=regi_Date_Time%>
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
			<button id="regButton" type="button" class="btn btn-danger btn-sm"><i class="fa fa-save"></i> 저장</button>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
		</td>
	</tr>
</table>
</form>
<script type="text/javascript">
var oEditors = [];
function saveContent() { 
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
	var oper = $("#oper").val();
	var title = $("#title").val();
	var message = $("#message").val();
	var board_Type = document.getElementById("board_Type").value;
	var regi_User_Numb = document.getElementById("regi_User_Numb").value;
	var board_No = document.getElementById("board_No").value;
	var group_No = document.getElementById("group_No").value;
	var parent_Board_No = document.getElementById("parent_Board_No").value;
	var file_list1 = $("#file_list1").val();
	var file_list2 = $("#file_list2").val();
	var file_list3 = $("#file_list3").val();
	var file_list4 = $("#file_list4").val();
	if(title == ""){
		alert("제목을 입력해 주십시오.");
		return;
	}
	if( ! message || message == '<p>&nbsp;</p>'){
		alert("내용을 입력하여 주시기 바랍니다.");
		return;
	}	
	if(!confirm("내용을 저장하시겠습니까?")) return;
	
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/board/boardReplyTransGrid.sys",
		{ 	oper:oper, title:title, message:message, board_Type:board_Type, regi_User_Numb:regi_User_Numb,
			board_No:board_No, group_No:group_No, parent_Board_No:parent_Board_No, file_list1:file_list1, file_list2:file_list2, 
			file_list3:file_list3, file_list4:file_list4
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
// 				window.dialogArguments.fnReloadGrid();
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

<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
</body>
</html>