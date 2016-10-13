<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@page import="java.util.List"%>

<%
	BoardDto boardDto = (BoardDto)request.getAttribute("detailInfo");	
	String board_No = boardDto.getBoard_No();
	String title = boardDto.getTitle();
	String popup_Start = boardDto.getPopup_Start();
	String popup_End = boardDto.getPopup_End();
	String message = boardDto.getMessage();
	String file_list1 = CommonUtils.getString(boardDto.getFile_List1());
	String file_list2 = CommonUtils.getString(boardDto.getFile_List2());
	String file_list3 = CommonUtils.getString(boardDto.getFile_List3());
	String file_list4 = CommonUtils.getString(boardDto.getFile_List4());
	String attach_file_name1 = (CommonUtils.getString(boardDto.getAttach_file_name1())).length() < 22 ?  (CommonUtils.getString(boardDto.getAttach_file_name1())) : (CommonUtils.getString(boardDto.getAttach_file_name1())).substring(0,22)+"...";
	String attach_file_name2 = (CommonUtils.getString(boardDto.getAttach_file_name2())).length() < 22 ?  (CommonUtils.getString(boardDto.getAttach_file_name2())) : (CommonUtils.getString(boardDto.getAttach_file_name2())).substring(0,22)+"...";
	String attach_file_name3 = (CommonUtils.getString(boardDto.getAttach_file_name3())).length() < 22 ?  (CommonUtils.getString(boardDto.getAttach_file_name3())) : (CommonUtils.getString(boardDto.getAttach_file_name3())).substring(0,22)+"...";
	String attach_file_name4 = (CommonUtils.getString(boardDto.getAttach_file_name4())).length() < 22 ?  (CommonUtils.getString(boardDto.getAttach_file_name4())) : (CommonUtils.getString(boardDto.getAttach_file_name4())).substring(0,22)+"...";
	String attach_file_path1 = CommonUtils.getString(boardDto.getAttach_file_path1());
	String attach_file_path2 = CommonUtils.getString(boardDto.getAttach_file_path2());
	String attach_file_path3 = CommonUtils.getString(boardDto.getAttach_file_path3());
	String attach_file_path4 = CommonUtils.getString(boardDto.getAttach_file_path4());
	LoginUserDto loginUserDto = (LoginUserDto)request.getSession().getAttribute(Constances.SESSION_NAME);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type='text/css'>
.ptitle {font-size:12px; font-weight:bold; letter-spacing:-1px; color:#000000; padding-top:1px;;vertical-align:middle;text-align:center}
.xtitle {font-size:30px; font-weight:bold; letter-spacing:-1px; color:#000000; padding-top:1px;padding-left:60px;vertical-align:middle;text-align:left}
.pcontent {font-size:12px; letter-spacing:-1px; color:#000000; padding-top:1px; padding-left:20px;vertical-align:top;text-align:left }
</style>

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
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};

function fnClose(){
	if(document.frm.pop.checked){
		setCookie("frm_<%=board_No%>",<%=board_No%>, 1);
	}
	window.close();
}

function setCookie(name, value, expiredays) {
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
} 

function fnContractOpener(contractVersion){
	var name = "frm_<%=board_No%>";
	var value = "<%=board_No%>";
	var expiredays = 1;
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	var cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
	var borgType = "<%=loginUserDto.getSvcTypeCd()%>";
	window.opener.commodityContractLink(contractVersion, cookie, borgType);
	window.close();
}
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
    $("#closeButton").click(function(){ fnClose();});

});
</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width='600' border='0' cellspacing='0' cellpadding='0'>
				<tr>
					<td width="600" height='64' colspan='3' align='right' valign='bottom' style="background-image: url('/img/system/mail_form_img_01.gif');">
							공지기간 : <%=popup_Start + " ~ " + popup_End%>
					</td>
				</tr>
				<tr>
					<td colspan='3' width='600' height="80" style="background-image: url('/img/system/mail_form_title.jpg');" >
						<table>
							<tr>
								<td class="xtitle">
									<%=title%>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width='51' style="background-image: url('/img/system/mail_form_img_02.jpg');">&nbsp;</td>
					<td width='478' class='pcontent'>
						<div style="height:400px; overflow:auto;"><%=message%></div>
					</td>
<%-- 					<div overflow="visible"><td width='478' height='150' class='pcontent'><%=message%></td> --%>
					<td width='51' style="background-image: url('/img/system/mail_form_img_03.jpg');">&nbsp;</td>
				</tr>
				<tr>
					<td width="600" colspan="3" height="13" style="background-image: url('/img/system/bottomImage.jpg'); background-repeat:no-repeat;"></td>
				</tr>
				<tr>
					<td colspan="3" height="15" style="background-image: url('/img/system/mail_form_line.jpg');">&nbsp;</td>
				</tr>
<%	if(!"".equals(file_list1.length()<0) && !"".equals(file_list2.length()<0) && !"".equals(file_list3.length()<0) && !"".equals(file_list4.length()<0)) {%>
				<tr>
					<td colspan="3" width="600" height="13" style="background-image: url('/img/system/topImage.jpg');"></td>
				</tr>
				<tr>
					<td width="51" style="background-image: url('/img/system/mail_form_img_02.jpg');">&nbsp;</td>
					<td width='478'>
						<table width="478">
							<tr>
<%	if(!"".equals(file_list1)) {	%>
								<td class='ptitle' width="15%">
									첨부파일1
								</td>
								<td class='pcontent' width="35%">
									<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
									<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val())">
									<span id="attach_file_name1"><%=attach_file_name1 %></span>
									</a>
								</td>
<%	} %>						
<%	if(!"".equals(file_list2)) {	%>	
								<td class='ptitle' width="15%">
									첨부파일2
								</td>
								<td class='pcontent' width="35%">
									<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
									<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val())">
									<span id="attach_file_name2"><%=attach_file_name2 %></span>
									</a>
								</td>
							</tr>
<%	} %>
<%	if(!"".equals(file_list3)) {	%>	
							<tr>
								<td class='ptitle'>
									첨부파일3
								</td>
								<td class='pcontent'>
									<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
									<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val())">
									<span id="attach_file_name3"><%=attach_file_name3 %></span>
									</a>
								</td>
<%	} %>
<%	if(!"".equals(file_list4)) {	%>									
								<td class='ptitle'>
									첨부파일4
								</td>
								<td class='pcontent'>
									<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=attach_file_path4 %>"/>
									<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val())">
									<span id="attach_file_name4"><%=attach_file_name4 %></span>
									</a>
								</td>
<%	} %>
							</tr>
						</table>
					</td>
					<td width='51' style="background-image: url('/img/system/mail_form_img_03.jpg');"></td>
				</tr>
				
				<tr>
					<td colspan='3'><img src='/img/system/mail_form_img_04.gif' width='600' height='80' /></td>
				</tr>
<%	}else{ %>
				<tr>
					<td colspan='3'><img src='/img/system/newfooter.jpg' width='600' height='60'/></td>
				</tr>
<%	} %>
				
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
			<table width="43%">
				<tr>
					<td style="vertical-align: top;">
						<input type="checkbox" name="pop" value="1" style="border: 0"/>
					</td>
					<td style="vertical-align: middle;">
						오늘 하루 이 창을 열지 않음
					</td>
					<td>
						<a href='#'><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_close.gif" style="border: 0" width="65" height="23" /></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>