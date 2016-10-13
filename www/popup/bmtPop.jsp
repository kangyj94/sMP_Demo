<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@page import="java.util.List"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/redmond/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/hmro_green_tree.css" rel=StyleSheet />

<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
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
</script>

<script type="text/javascript">
function fnClose(){
	if(document.frm.pop.checked){		
		setCookie('bmtpop', 'checked', 1);
	}
	window.close();
}

function setCookie(name, value, expiredays) {
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
}
</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form id="frm" name="frm" method="post">
<table width="670" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="670">
			<img src="<%=Constances.SYSTEM_IMAGE_URL%>/popup/img/index_popup.jpg" width="670" height="820"/>
		</td>
	</tr>
	<tr>
		<td class="table_top_line"></td>
	</tr>
	<tr>
		<td>
			<table>
				<tr>
					<td width="13%" class="table_td_subject">
						첨부파일1
					</td>
					<td width="20%" class="table_td_contents">
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="D:/Java/upload/attach/BMT 참여신청서.doc'"/>
						<a href="javascript:fnAttachFileDownload('D:/Java/upload/attach/BMT 참여신청서.doc')">
						<span id="attach_file_name1">BMT 참여신청서.doc</span>
						</a>
					</td>
					<td width="13%" class="table_td_subject">
						첨부파일2
					</td>
					<td width="20%" class="table_td_contents">
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="D:/Java/upload/attach/SKB_광스플리터 요구 Spec.pdf"/>
						<a href="javascript:fnAttachFileDownload('D:/Java/upload/attach/SKB_광스플리터 요구 Spec.pdf')">
						<span id="attach_file_name2">SKB_광스플리터 요구 Spec.pdf</span>
						</a>
					</td>
					<td width="13%" class="table_td_subject">
						첨부파일3
					</td>
					<td width="20%" class="table_td_contents">
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="D:/Java/upload/attach/신규자재제안 시스템 이용방법.pdf"/>
						<a href="javascript:fnAttachFileDownload('D:/Java/upload/attach/신규자재제안 시스템 이용방법.pdf')">
						<span id="attach_file_name2">신규자재제안 시스템 이용방법.pdf</span>
						</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="table_top_line"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
			<table width="60%">
				<tr>
					<td style="vertical-align: top;">
						<input type="checkbox" name="pop" value="1" style="border: 0"/>
					</td>
					<td style="vertical-align: middle;">
						오늘 하루 이 창을 열지 않음
					</td>
					<td>
						<img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_close.gif" style="border: 0;cursor:pointer;" width="65" height="23" onclick="fnClose();"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>