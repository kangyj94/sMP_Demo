<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.AttachInfoDto" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.List" %>

<%
	String [] attachNames = request.getParameterValues("attachNames");	//첨부파일제목
	//첨부한 첨부파일 일련번호(첨부파일 제목과 같은 순서대로) 먄약 attachNames={"첨부1", "첨부2", "첨부3"} 이고 등록된 첨부파일Seq가 첨부3만 있다면 attach_seq={"","","213"} 이런식으로 와야 함
	String [] attach_seq = request.getParameterValues("attach_seq");
	@SuppressWarnings("unchecked")
	List<AttachInfoDto> attachList = (List<AttachInfoDto>)request.getAttribute("attachList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
	
}

function nFileDownload(attachFilePath) {
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys", 
		{ attachFilePath:attachFilePath },
		function(arg){
		}
	);
}
</script>
</head>

<body>
<table width="600"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
				<tr>
					<td width="21">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
					</td>
					<td width="22">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px "/>
					</td>
					<td class="popup_title">첨부파일 관리</td>
					<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
				</tr>
			</table>
			<table width="100%"  border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="20" height="20">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/>
					</td>
					<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
					<td width="20">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/>
					</td>
				</tr>
				<tr>
					<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
					<td valign="top" bgcolor="#FFFFFF">
						<!-- 컨텐츠 시작 -->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2" class="table_top_line"></td>
							</tr>
<%	for(int i=0;i<attachNames.length;i++) {	%>
							<tr>
								<td class="table_td_subject" width="60"><%=attachNames[i] %></td>
								<td class="table_td_contents">
									<input type="file" id="attachFile" name="attachFile" size="30" />
									<input type="hidden" id="attach_seq" name="attach_seq" value="<%=CommonUtils.getString(attach_seq[i]) %>"/>
<%		
		if(attach_seq[i]!=null && !"".equals(attach_seq[i]) && attachList!=null) { 
			for(AttachInfoDto attachInfoDto : attachList) {
				if(attach_seq[i].equals(attachInfoDto.getAttach_seq())) {
%>
									<a href="javascript:fnFileDownload('<%=attachInfoDto.getAttach_file_path() %>');">
										<%=attachInfoDto.getAttach_file_name() %>
									</a>
<%
				}
			}
		} 
%>
								</td>
							</tr>
<%		if(i!=attachNames.length-1) {	%>
							<tr>
								<td colspan="2" height='1' bgcolor="eaeaea"></td>
							</tr>
<%
		}
	} 
%>
							<tr>
								<td colspan="2" class="table_top_line"></td>
							</tr>
						</table>
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="center">
									<a href="#"><img id="selectButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_register.gif" width="65" height="23" border="0"/></a>
									<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" width="65" height="23" border="0"/></a>
								</td>
							</tr>
						</table>
						<!-- 컨텐츠 끝 -->
					</td>
					<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
				</tr>
				<tr>
					<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
					<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
					<td height="20"><img src="img/system/box_corner_3.gif" width="20" height="20"/></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>