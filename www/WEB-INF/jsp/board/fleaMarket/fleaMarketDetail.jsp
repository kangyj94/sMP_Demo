<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	BoardDto boardDto = (BoardDto)request.getAttribute("detailInfo");	//게시물정보
	String board_No = (String)request.getParameter("board_No");
	String board_Type = request.getParameter("board_Type");
	String group_No = null;
	String parent_Board_No = null;
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
	String regi_user_numb = boardDto.getRegi_User_Numb();
	String oper = "";
	String id = "";
	
	if(boardDto!=null) {
		group_No = boardDto.getGroup_No();
		parent_Board_No = boardDto.getParent_Board_No();
		board_Type = boardDto.getBoard_Type();
	}
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
     $("#delButton").click( function(){ fnDelete(); });
 });
</script>

<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
function fnClose(){
	window.close();
}

function fnReply() {	
	document.frm.action = "/board/fleaMarketReply.sys";
	document.frm.target = 'selfWin';
	window.name = 'selfWin';
	document.frm.submit();
}

function fnDelete(){
	var popurl = "<%=Constances.SYSTEM_CONTEXT_PATH%>/board/fleaMarketTransGrid.sys?oper=del";
	document.frm.action = popurl;
	document.frm.target = 'selfWin';
	window.name = 'selfWin';
	document.frm.submit();
	window.opener.fnReloadGrid();
	window.close();
}
</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<input type="hidden" name="board_No" id="board_No" value="<%=board_No%>" />
<input type="hidden" name="group_No" id="group_No" value="<%=group_No%>" />
<input type="hidden" name="parent_Board_No" id="parent_Board_No" value="<%=parent_Board_No%>" />
<input type="hidden" name="board_Type" id="board_Type" value="<%=board_Type%>" />
<input type="hidden" name="id" id="id" value="<%=board_No%>" />
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
					<td class="table_td_contents" colspan="3">
						<%=boardDto.getRegi_User_Numb()%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="100" class="table_td_subject">제목</td>
					<td class="table_td_contents" colspan="3">
							<%=boardDto.getTitle() %>	
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
<%	if("0203".equals(board_Type)) {	%>
				<tr>
					<td class="table_td_subject">판매가격</td>
					<td class="table_td_contents" colspan="3">
						<%=boardDto.getReq_Sale_Amout()%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">배송방법</td>
					<td class="table_td_contents" colspan="3">
						<%=boardDto.getTran_Vehi_Proc()%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
<%	} %>
				<tr>
					<td class="table_td_subject">전화번호</td>
					<td class="table_td_contents" colspan="3">
						<%=boardDto.getUser_Phon_Numb()%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">E-Mail</td>
					<td class="table_td_contents" colspan="3">
						<%=boardDto.getUser_Mail_Addr()%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">내용</td>
					<td height="250" valign="top" class="table_td_contents4" colspan="3">
						<%=boardDto.getMessage()%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="18%" class="table_td_subject">
						첨부파일1
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
						<span id="attach_file_name1"><%=attach_file_name1 %></span>
						</a>
					</td>
					<td width="18%" class="table_td_subject">
						첨부파일2
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attach_file_path2 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
						<span id="attach_file_name2"><%=attach_file_name2 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="18%" class="table_td_subject">
						첨부파일3
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
						<span id="attach_file_name3"><%=attach_file_name3 %></span>
						</a>
					</td>
					<td width="18%" class="table_td_subject">
						첨부파일4
					</td>
					<td width="32%" class="table_td_contents">
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=attach_file_path4 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
						<span id="attach_file_name4"><%=attach_file_name4 %></span>
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
			<a href="#"><img id="ReplyButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_write_reply.jpg" style="border: 0px;" /></a>
<%	if(regi_user_numb.equals(userInfoDto.getUserNm())) {	%>
			<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_write_delete.jpg" style="border: 0px;" /></a>
<%	}	%>
			<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="border: 0px;" /></a>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</form>
</body>
</html>