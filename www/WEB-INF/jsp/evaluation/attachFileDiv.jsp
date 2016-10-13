<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%-- <%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %> --%>
<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
$(function(){
	var btnUpload=$('#attachImportButton');
	var status=$('#status');
	new AjaxUpload(btnUpload, {
		action: '<%=Constances.SYSTEM_CONTEXT_PATH%>/common/attachEvalFileUpload.sys',
		name: 'uploadFile',
		data: {},
		onSubmit: function(file, ext){
			specialLetters = /[!@#$%^&''""]/;
			if(specialLetters.test(file)){
				alert("파일에 특수문자[!@#$%^&'"+'"'+"]를 \n제거해 주세요.");
				return false;
			}else{
				this.setData({
					'attach_seq':$("#attach_seq").val()
				});
				if(!confirm("파일을 등록하시겠습니까?")) return false;
				status.text('Uploading..................');
			}
		},
		onComplete: function(file, response){
			var result = eval('(' + response + ')').customResponse;
			if (result.success == false) {
				var errors = "";
				for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
				status.text(errors);
			} else {
				status.text('');
				$('#attach_title').text("");
				$("#attach_seq").val("");
				$('#uploadDialogPop').jqmHide();
				
				var rtn_attach_seq = result.message[0];
				var rtn_attach_file_name = result.message[1];
				var rtn_attach_file_path = result.message[2];
				rtn_attach_file_path = rtn_attach_file_path.replace(/\\/g,"\\\\");
				
				eval(fnCallback+"('"+rtn_attach_seq+"','"+rtn_attach_file_name+"','"+rtn_attach_file_path+"');");
			}
		}
	});
	
	// Dialog Button Event
	$('#uploadDialogPop').jqm();	//Dialog 초기화
	$("#attachCloseButton").click(function(){	//Dialog 닫기
		$('#uploadDialogPop').jqmHide();
		$("#attach_seq").val("");
		$('#attach_title').text("");
		$('#status').text("");
	});
	$('#uploadDialogPop').jqm().jqDrag('#uploadDialogHandle'); 
});

var fnCallback = "";
function fnUploadDialog(attach_title, attach_seq, callbackString) {
	$('#uploadDialogPop').jqmShow();
	$("#attach_seq").val(attach_seq);
	$('#attach_title').text(attach_title);
	$('#status').text("");
	fnCallback = callbackString;
}
</script>
</head>

<!-------------------------------- Dialog Div Start -------------------------------->
<body>
<input type="hidden" id="attach_seq" name="attach_seq" />
<div class="jqmWindow" id="uploadDialogPop">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="uploadDialogHandle">
					<table id="popup_titlebar_mid1" width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2><span id="attach_title"></span></h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<!-- 타이틀 -->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20"><img id="bullet01" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet01.gif" align="bottom"/></td>
									<td class='ptitle'>사용방법</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr valign="top">
									<td height="23px" class="table_td_contents">1. 파일등록버튼을 클릭하여 업로드할 파일을 선택합니다.</td>
								</tr>
								<tr valign="top">
									<td height="23px" class="table_td_contents">2. 파일등록 여부 확인창에 확인을 누르면 파일이 업로드 됩니다.</td>
								</tr>
								<tr valign="top">
									<td height="23px" class="table_td_contents">3. 파일은 10메가바이트 이상 등록할 수 없습니다.</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
							<span id="status" style="color: #FF0000"></span>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="attachImportButton" type="button" class="btn btn-primary btn-sm isWriter"><i class="fa fa-check"></i>선택</button>
										<button id="attachCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>