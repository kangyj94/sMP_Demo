<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	BoardDto boardDto = (BoardDto)request.getAttribute("detailInfo");	//게시물정보
	String oper = "";
	String board_No = request.getParameter("board_No");
	String board_Type = boardDto.getBoard_Type();
	String title = boardDto.getTitle();
	String message = "";
	String regi_User_Numb = userInfoDto.getUserNm();
	String regi_Date_Time = CommonUtils.getCurrentDate();
	String req_Sale_Amout = "";
	String tran_Vehi_Proc = "";
	String user_Phon_Numb = userInfoDto.getMobile(); 
	String user_Mail_Addr = userInfoDto.getEmail(); 
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

<!--버튼 이벤트 스크립트-->
<script type="text/javascript">
 $(document).ready(function(){
	$("#regButton").click( function(){ saveContent();});
	$("#closeButton").click( function() { fnClose(); });
	Editor.getCanvas().setCanvasSize({height:250});	//daum editor height 지정
 });
</script>    

<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
 function fnClose(){
 	window.close();
 }
 
 function fnAttachDel(file_list, columnName) {
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/board/attachDelete.sys",
			{ board_no:'<%=board_No %>', file_list:file_list, columnName:columnName },
			function(arg){
				var result = eval('(' + arg + ')').customResponse;
				var errors = "";
				if (result.success == false) {
					for (var i = 0; i < result.message.length; i++) {
						errors +=  result.message[i] + "<br/>";
					}
					alert(errors);
				} else {
					if(columnName=='file_list1') {
						$("#file_list1").val('');
						$("#attach_file_name1").text('');
						$("#attach_file_path1").val('');
						$("#btnAttachDel1").css("display","none");
					} else if(columnName=='file_list2') {
						$("#file_list2").val('');
						$("#attach_file_name2").text('');
						$("#attach_file_path2").val('');
						$("#btnAttachDel2").css("display","none");
					} else if(columnName=='file_list3') {
						$("#file_list3").val('');
						$("#attach_file_name3").text('');
						$("#attach_file_path3").val('');
						$("#btnAttachDel3").css("display","none");
					} else if(columnName=='file_list4') {
						$("#file_list4").val('');
						$("#attach_file_name4").text('');
						$("#attach_file_path4").val('');
						$("#btnAttachDel4").css("display","none");
					}
					alert("처리 하였습니다.");
				}
			}
		);
	}
</script>
</head>
<body onload="loadContent();">  <!--  daumEditor 수정 시 내용 가져올 때 필수 조건 -->
<form id="frm" name="frm" method="post">
<input type="hidden" name="oper" id="oper" value="<%=!"".equals(board_No) ? "add" : "edit"%>" /> 
<input type="hidden" name="board_No" id="board_No" value="<%=board_No%>" />
<input type="hidden" name="group_No" id="group_No" value="<%=group_No%>" />
<input type="hidden" name="parent_Board_No" id="parent_Board_No" value="<%=parent_Board_No%>" />
<input type="hidden" name="board_Type" id="board_Type" value="<%=board_Type%>" />
<input type="hidden" name="user_Phon_Numb" id="user_Phon_Numb" value="<%=user_Phon_Numb%>" />
<input type="hidden" name="user_Mail_Addr" id="user_Mail_Addr" value="<%=user_Mail_Addr%>" />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
    		<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>벼룩시장</td>
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
					<td class="table_td_subject">작성자</td>
					<td colspan="3" class="table_td_contents">
						<input type="text" id="regi_User_Numb" name="regi_User_Numb" value="<%=regi_User_Numb %>" style="border: none;" />
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">제목</td>
					<td colspan="3" class="table_td_contents">
						<img src='/img/system/icon_reply.gif' border='0'/>	
						<input type="text" id="title" name="title" class="input" style="width:68%; background-color: #eaeaea;" value="[답변]<%=title%>" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
<%	if("0203".equals(board_Type)) {	%>
				<tr>
					<td width="100" class="table_td_subject">판매가격</td>
					<td colspan="3" class="table_td_contents">
						<input type="text" id="req_Sale_Amout" name="req_Sale_Amout" class="input" style="width:68%" value="<%=req_Sale_Amout %>"/>	
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">배송방법</td>
					<td colspan="3" class="table_td_contents">
						<input type="text" id="tran_Vehi_Proc" name="tran_Vehi_Proc" class="input" style="width:68%" value="<%=tran_Vehi_Proc %>"/>	
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
<%	} else { %>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea">
						<input type="hidden" id="req_Sale_Amout" name="req_Sale_Amout"/>
						<input type="hidden" id="tran_Vehi_Proc" name="tran_Vehi_Proc"/>
					</td>
				</tr>
<%	} %>
				<tr>
					<td class="table_td_subject">전화번호</td>
					<td colspan="3" class="table_td_contents">
						<%=user_Phon_Numb%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">E-Mail</td>
					<td colspan="3" class="table_td_contents">
						<%=user_Mail_Addr%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">내용</td>
					<td colspan="3" height="150" class="table_td_contents4">
						<%@ include file = "/daumeditor/editorbox.jsp" %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">
						첨부파일1
						<a href="#">
						<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value="<%=file_list1 %>"/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
						<span id="attach_file_name1"><%=attach_file_name1 %></span>
						</a>
<%	if(!"".equals(file_list1)) {	%>
						<a href="javascript:fnAttachDel('<%=file_list1 %>','file_list1');">
						<img id="btnAttachDel1" name="btnAttachDel1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
						</a>
<%	} %>
					</td>
					<td width="100" class="table_td_subject">
						첨부파일2
						<a href="#">
						<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value="<%=file_list2 %>"/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
						<span id="attach_file_name2"><%=attach_file_name2 %></span>
						</a>
<%	if(!"".equals(file_list2)) {	%>
						<a href="javascript:fnAttachDel('<%=file_list2 %>','file_list2');">
						<img id="btnAttachDel2" name="btnAttachDel2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
						</a>
<%	} %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">
						첨부파일3
						<a href="#">
						<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list3" name="file_list3" value="<%=file_list3 %>"/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
						<span id="attach_file_name3"><%=attach_file_name3 %></span>
						</a>
<%	if(!"".equals(file_list3)) {	%>
						<a href="javascript:fnAttachDel('<%=file_list3 %>','file_list3');">
						<img id="btnAttachDel3" name="btnAttachDel3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
						</a>
<%	} %>
					</td>
					<td width="100" class="table_td_subject">
						첨부파일4
						<a href="#">
						<img id="btnAttach4" name="btnAttach4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
						</a>
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list4" name="file_list4" value="<%=file_list4 %>"/>
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=attach_file_path4 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
						<span id="attach_file_name4"><%=attach_file_name4 %></span>
						</a>
<%	if(!"".equals(file_list4)) {	%>
						<a href="javascript:fnAttachDel('<%=file_list4 %>','file_list4');">
						<img id="btnAttachDel4" name="btnAttachDel4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
						</a>
<%	} %>
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
			<span id="regButton" style="cursor:pointer;"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_save.gif" width="65" height="23" /></span>
			<span id="closeButton" style="cursor:pointer;"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" width="65" height="23" /></span>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</form>
<script type="text/javascript">
function saveContent() { // 글 등록시 saveContent() 사용해서 저장
	var regi_User_Numb = document.getElementById("regi_User_Numb").value;
	var title = $("#title").val();
	var message = Editor.getContent();
	var oper = $("#oper").val();
	var board_Type = document.getElementById("board_Type").value;
	var req_Sale_Amout = document.getElementById("req_Sale_Amout").value;
	var tran_Vehi_Proc = document.getElementById("tran_Vehi_Proc").value;
	var user_Phon_Numb = document.getElementById("user_Phon_Numb").value;
	var board_No = document.getElementById("board_No").value;
	var user_Mail_Addr = document.getElementById("user_Mail_Addr").value;
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
<%	if("0203".equals(board_Type)) {	%>
	if(req_Sale_Amout == ""){
		alert("판매가격을 입력해 주십시오.");
		return;
	}
	if(tran_Vehi_Proc == ""){
		alert("배송방법을 입력해 주십시오.");
		return;
	}
<%	}	%>
	if(user_Phon_Numb == ""){
		alert("전화번호를 입력해 주십시오.");
		return;
	}
	var validator = new Trex.Validator();
	if (!validator.exists(message)) {
		alert('내용을 입력해 주십시요');
		return false;
	}
	if(!confirm("내용을 저장하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/board/fleaMarketReplyTransGrid.sys",
		{ 	regi_User_Numb:regi_User_Numb, title:title, message:message, oper:oper, board_Type:board_Type, 
			req_Sale_Amout:req_Sale_Amout, tran_Vehi_Proc:tran_Vehi_Proc, user_Phon_Numb:user_Phon_Numb, board_No:board_No,
			user_Mail_Addr:user_Mail_Addr, regi_User_Numb:regi_User_Numb, group_No:group_No, parent_Board_No:parent_Board_No
			, file_list1:file_list1, file_list2:file_list2, file_list3:file_list3, file_list4:file_list4
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
	
/**
 * Editor.save()를 호출한 경우 데이터가 유효한지 검사하기 위해 부르는 콜백함수로
 * 상황에 맞게 수정하여 사용한다.
 * 모든 데이터가 유효할 경우에 true를 리턴한다.
 * @function
 * @param {Object} editor - 에디터에서 넘겨주는 editor 객체
 * @returns {Boolean} 모든 데이터가 유효할 경우에 true
 */
function validForm(editor) {
// Place your validation logic here
	var frm     = document.getElementById("frm");
	var title   = document.getElementById("title");
	
	if(title.value == ""){
		alert("제목을 입력해 주십시오.");
		
		title.focus();
		
		return;
	}
       var validator = new Trex.Validator();
       var desc = editor.getContent();
       if (!validator.exists(desc)) {
           alert('내용을 입력해 주십시요');
           return false;
       }
	return true;
}

/**
 * Editor.save()를 호출한 경우 validForm callback 이 수행된 이후
 * 실제 form submit을 위해 form 필드를 생성, 변경하기 위해 부르는 콜백함수로
 * 각자 상황에 맞게 적절히 응용하여 사용한다.
 * @function
 * @param {Object} editor - 에디터에서 넘겨주는 editor 객체
 * @returns {Boolean} 정상적인 경우에 true
 */
function setForm(editor) {
	var formGenerator = editor.getForm();
	var desc = editor.getContent();
		formGenerator.createField(
		tx.textarea({
		    'name': "desc", // 본문 내용을 필드를 생성하여 값을 할당하는 부분
		    'style': { 'display': "none" }
		}, desc)
	);
		/* 아래의 코드는 첨부된 데이터를 필드를 생성하여 값을 할당하는 부분으로 상황에 맞게 수정하여 사용한다.
		 첨부된 데이터 중에 주어진 종류(image,file..)에 해당하는 것만 배열로 넘겨준다. */
		var images = editor.getAttachments('image');
		for (var i = 0, len = images.length; i < len; i++) {
	    // existStage는 현재 본문에 존재하는지 여부
		if (images[i].existStage) {
	    // data는 팝업에서 execAttach 등을 통해 넘긴 데이터
		    formGenerator.createField(
			tx.input({
			    'type': "hidden",
			    'name': 'tx_attach_image',
			    'value': images[i].data.imageurl // 예에서는 이미지경로만 받아서 사용
			}));
		}
	}
		var files = editor.getAttachments('file');
		for (var i = 0, len = files.length; i < len; i++) {
			formGenerator.createField(
			tx.input({
			    'type': "hidden",
			    'name': 'tx_attach_file',
			    'value': files[i].data.attachurl
			})
		);
	}
      return true;
}
</script>
<textarea id="tx_load_content" cols="80" rows="10" style="display:none;"><%=message%></textarea> <!--  daumEditor 수정 시 내용 가져올 때 필수 조건 -->
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
</body>
</html>