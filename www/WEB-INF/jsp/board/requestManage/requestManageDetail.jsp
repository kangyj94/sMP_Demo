<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.MerequDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	MerequDto merequDto = (MerequDto)request.getAttribute("detailInfo");	//게시물정보
	String modi_User_Numb = userInfoDto.getUserNm();
	String modi_User_Date = CommonUtils.getCurrentDate();
	String attach_file_name1 = CommonUtils.getString(merequDto.getAttach_file_name1());
	String attach_file_name2 = CommonUtils.getString(merequDto.getAttach_file_name2());
	String attach_file_name3 = CommonUtils.getString(merequDto.getAttach_file_name3());
	String attach_file_name4 = CommonUtils.getString(merequDto.getAttach_file_name4());
	String attach_file_path1 = CommonUtils.getString(merequDto.getAttach_file_path1());
	String attach_file_path2 = CommonUtils.getString(merequDto.getAttach_file_path2());
	String attach_file_path3 = CommonUtils.getString(merequDto.getAttach_file_path3());
	String attach_file_path4 = CommonUtils.getString(merequDto.getAttach_file_path4());
	String stat_flag_code = CommonUtils.getString(merequDto.getStat_Flag_Code());
	
	String res_attach_file_name1 = CommonUtils.getString(merequDto.getRes_attach_file_name1());
	String res_attach_file_name2 = CommonUtils.getString(merequDto.getRes_attach_file_name2());
	String res_attach_file_name3 = CommonUtils.getString(merequDto.getRes_attach_file_name3());
	String res_attach_file_name4 = CommonUtils.getString(merequDto.getRes_attach_file_name4());
	String res_attach_file_path1 = CommonUtils.getString(merequDto.getRes_attach_file_path1());
	String res_attach_file_path2 = CommonUtils.getString(merequDto.getRes_attach_file_path2());
	String res_attach_file_path3 = CommonUtils.getString(merequDto.getRes_attach_file_path3());
	String res_attach_file_path4 = CommonUtils.getString(merequDto.getRes_attach_file_path4());
	String req_message = CommonUtils.getString(merequDto.getReq_Message());
	String requ_tel_numb = CommonUtils.getString(merequDto.getRequ_tel_numb());
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

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
</script>

<!--버튼 이벤트 스크립트-->
<script type="text/javascript">
 $(document).ready(function(){
     $("#closeButton").click( function() { fnClose(); });
     $("#ReplyButton").click( function() { fnReply(); });
     $("#ReplyModButton").click( function() { fnReplyMod(); });
 });
</script>

<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
function fnClose(){
	window.opener.fnReloadGrid();
	window.close();
}

function fnReply() {
//     window.close();
//     if(window.dialogArguments != null ){
<%--         var params = 'no=<%=merequDto.getNo() %>&replayFlag=Y';   --%>
//         window.dialogArguments.fnReply(params);    
//     }
    var params = 'no=<%=merequDto.getNo() %>&replayFlag=Y';
    var popurl = "/board/requestManageWrite.sys?"+params;
	window.open(popurl, 'requestManageReply', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
    
//     window.opener.fnReply(params);    
// 	window.close();
}
function fnReplyMod() {
    var params = 'no=<%=merequDto.getNo() %>&replayFlag=Y&mod=Y';
    var popurl = "/board/requestManageWrite.sys?"+params;
	window.open(popurl, 'requestManageReply', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}

function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
	$("#list").trigger("reloadGrid");
}
</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<input type="hidden" name="modi_User_Numb" id="modi_User_Numb" value="<%=modi_User_Numb %>" />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
    		<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>요구사항 정보</td>
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
					<td width="60" class="table_td_subject">요청명</td>
					<td class="table_td_contents" colspan="3">
						<%=merequDto.getTitle() %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">유형</td>
					<td class="table_td_contents">
						<select name="requ_Stat_Flag" id="requ_Stat_Flag" disabled="disabled"> 
							<option value="1" <%=merequDto.getRequ_Stat_Flag().equals("1")? "selected" : "" %> >가격</option>
							<option value="2" <%=merequDto.getRequ_Stat_Flag().equals("2")? "selected" : "" %> >품질</option>
							<option value="3" <%=merequDto.getRequ_Stat_Flag().equals("3")? "selected" : "" %> >납기</option>
							<option value="4" <%=merequDto.getRequ_Stat_Flag().equals("4")? "selected" : "" %> >시스템</option>
							<option value="5" <%=merequDto.getRequ_Stat_Flag().equals("5")? "selected" : "" %> >기타</option>
						</select>
					</td>
					<td width="60" class="table_td_subject">연락처</td>
					<td class="table_td_contents">
						<%=requ_tel_numb %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						요청첨부파일1
					</td>
					<td  class="table_td_contents">
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val())">
						<span id="attach_file_name1"><%=attach_file_name1 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						요청첨부파일2
					</td>
					<td  class="table_td_contents">
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val())">
						<span id="attach_file_name2"><%=attach_file_name2 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						요청첨부파일3
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val())">
						<span id="attach_file_name3"><%=attach_file_name3 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						요청첨부파일4
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=attach_file_path4 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val())">
						<span id="attach_file_name4"><%=attach_file_name4 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">요청내역</td>
					<td height="210" valign="top" class="table_td_contents4" colspan="3">
						<%=merequDto.getMessage()%>
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
<%	//---------------------------------------답글시작----------------------------------------------- %>
<%	if("2".equals(stat_flag_code)) {	%>
	<tr>
		<td>
    		<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>답변 정보</td>
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
					<td width="60" class="table_td_subject">
						답변첨부파일1
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=res_attach_file_path1 %>');">
						<span id="res_attach_file_name1"><%=res_attach_file_name1 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						답변첨부파일2
					</td>
					<td  width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=res_attach_file_path2 %>');">
						<span id="res_attach_file_name2"><%=res_attach_file_name2 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						답변첨부파일3
					</td>
					<td class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=res_attach_file_path3 %>');">
						<span id="res_attach_file_name3"><%=res_attach_file_name3 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						답변첨부파일4
					</td>
					<td  class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=res_attach_file_path4 %>');">
						<span id="res_attach_file_name4"><%=res_attach_file_name4 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">답변내역</td>
					<td height="190" valign="top" class="table_td_contents4" colspan="3">
						<%=req_message %>
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
<%	} %>
<%	//---------------------------------------답글종료----------------------------------------------- %>
	<tr>
		<td align="center">
<%	if(!"2".equals(stat_flag_code) && "ADM".equals(userInfoDto.getSvcTypeCd())) {	%>
			<button id="ReplyButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-reply"></i> 답글</button>
<%	} %>
<%	if("2".equals(stat_flag_code) && "ADM".equals(userInfoDto.getSvcTypeCd())) {	%>
			<button id="ReplyModButton" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-reply"></i> 답글수정</button>
<%	} %>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</form>
</body>
</html>