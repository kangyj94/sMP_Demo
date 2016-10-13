<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%
	BoardDto boardDto = (BoardDto)request.getAttribute("detailInfo");	//게시물정보
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
 });
</script>

<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
 function fnClose(){
 	window.close();
 }
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
    		<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>공지사항</td>
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
					<td class="table_td_subject" style="width: 60px;">제목</td>
					<td class="table_td_contents" colspan="3">
							<select name="board_Type" id="board_Type" disabled="disabled"> 
								<option value="0102" <%=boardDto.getBoard_Type().equals("0102")? "selected" : "" %> >일반공지</option> 
								<option value="0101" <%=boardDto.getBoard_Type().equals("0101")? "selected" : "" %> >팝업공지</option>
								<option value="0111" <%=boardDto.getBoard_Type().equals("0111")? "selected" : "" %> >초기팝업</option>
							</select>
							<select name="board_Borg_Type" id="board_Borg_Type" disabled="disabled"> 
								<option value="ALL">전체</option>
								<option value="BUY" <%=boardDto.getBoard_Borg_Type().equals("BUY")? "selected" : "" %> >고객사</option>
								<option value="VEN" <%=boardDto.getBoard_Borg_Type().equals("VEN")? "selected" : "" %> >공급사</option>
							</select>
							&nbsp;&nbsp;<%=boardDto.getTitle() %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
               		<td class="table_td_subject" style="width: 60px;">기간</td>
					<td class="table_td_contents" colspan="3">
						<%=boardDto.getBoard_Type().equals("0102")? "" : boardDto.getPopup_Start() + " ~ " + boardDto.getPopup_End() %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="width: 60px;">내용</td>
					<td valign="top" class="table_td_contents4" colspan="3" style="height: 250px;">
						<%=boardDto.getMessage()%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="width: 60px;">
						첨부파일1
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
						<span id="attach_file_name1"><%=attach_file_name1 %></span>
						</a>
					</td>
					<td class="table_td_subject" style="width: 60px;">
						첨부파일2
					</td>
					<td class="table_td_contents">
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
					<td class="table_td_subject" style="width: 60px;">
						첨부파일3
					</td>
					<td  class="table_td_contents">
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
						<span id="attach_file_name3"><%=attach_file_name3 %></span>
						</a>
					</td>
					<td class="table_td_subject" style="width: 60px;">
						첨부파일4
					</td>
					<td  class="table_td_contents">
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=attach_file_path4 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
						<span id="attach_file_name4"><%=attach_file_name4 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="width: 60px;">등록자</td>
					<td class="table_td_contents">
						<%=boardDto.getRegi_User_Numb()%>
					</td>
					<td width="60" class="table_td_subject" style="width: 60px;">등록일</td>
					<td class="table_td_contents">
						<%=boardDto.getRegi_Date_Time()%>
					</td>
				</tr>
<!-- 				<tr> -->
<!-- 					<td colspan="4" height='1' bgcolor="eaeaea"></td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td width="100" class="table_td_subject" width="18%">이메일발송여부</td> -->
<!-- 					<td class="table_td_contents" width="32%"> -->
<%-- 						<input id="email_Yn" name="email_Yn" type="checkbox" <%=boardDto.getEmail_Yn().equals("Y") == true ?"checked" : "" %> disabled="disabled" style="border: 0" /> --%>
<!-- 					</td> -->
<!-- 					<td width="100" class="table_td_subject" width="18%">SMS발송여부</td> -->
<!-- 					<td class="table_td_contents" width="32%"> -->
<%-- 						<input id="sms_Yn" name="sms_Yn" type="checkbox" <%=boardDto.getSms_Yn().equals("Y") == true ?"checked" : "" %> disabled="disabled" style="border: 0" /> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
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
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</body>
</html>