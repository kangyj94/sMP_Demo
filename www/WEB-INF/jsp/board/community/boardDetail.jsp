<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%
	String boardTitle = CommonUtils.getString(request.getAttribute("boardTitle"));	//해당글 제목
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	
	BoardDto boardDto = (BoardDto)request.getAttribute("detailInfo");	//게시물정보
	String board_No = (String)request.getParameter("board_No");
	String board_Type = CommonUtils.getString(boardDto.getBoard_Type());
	String group_No = CommonUtils.getString(boardDto.getGroup_No());
	String parent_Board_No = CommonUtils.getString(boardDto.getParent_Board_No());
	String file_list1 = CommonUtils.getString(boardDto.getFile_List1());
	String file_list2 = CommonUtils.getString(boardDto.getFile_List2());
	String file_list3 = CommonUtils.getString(boardDto.getFile_List3());
	String file_list4 = CommonUtils.getString(boardDto.getFile_List4());
	String attach_file_name1 = CommonUtils.getString(boardDto.getAttach_file_name1());
	String attach_file_name2 = CommonUtils.getString(boardDto.getAttach_file_name2());
	String attach_file_name3 = CommonUtils.getString(boardDto.getAttach_file_name3());
	String attach_file_name4 = CommonUtils.getString(boardDto.getAttach_file_name4());
	String attach_file_path1 = CommonUtils.getString(boardDto.getAttach_file_path1());
	String attach_file_path2 = CommonUtils.getString(boardDto.getAttach_file_path2());
	String attach_file_path3 = CommonUtils.getString(boardDto.getAttach_file_path3());
	String attach_file_path4 = CommonUtils.getString(boardDto.getAttach_file_path4());
	String oper = "";
	String id = "";
	String regi_user_numb = boardDto.getRegi_User_Numb();
	String classify = CommonUtils.getString(boardDto.getClassify());
	String standard = CommonUtils.getString(boardDto.getStandard());
	String attach1 = "0202".equals(board_Type)? "규격서":"첨부파일1";
	String attach2 = "0202".equals(board_Type)? "절차서":"첨부파일2";
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
	//규격서/절차서 구분 코드리스트
	stadardClassifySelect();
});
</script>

<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
function fnClose(){
	window.close();
}

function fnReply() {	
	var popurl = "/board/boardReply.sys";
	document.frm.action = popurl;
	window.open("", 'okplazaReplyPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	document.frm.target = "okplazaReplyPop";
	document.frm.submit();
	
// 	document.frm.action = "/board/boardReply.sys";
// 	document.frm.target = 'selfWin';
// 	window.name = 'selfWin';
// 	document.frm.submit();
}

function fnDelete() { 
	var id = $("#id").val();
	
	if(!confirm("삭제를 하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/board/boardTransGrid.sys?oper=del",
		{
			id:id
		}
	);
	window.opener.fnReloadGrid();
	fnClose();
}



// function fnDelete(){
<%-- 	var popurl = "<%=Constances.SYSTEM_CONTEXT_PATH%>/board/boardTransGrid.sys?oper=del"; --%>
// 	document.frm.action = popurl;
// 	document.frm.target = 'selfWin';
// 	window.name = 'selfWin';
// 	if(!confirm("삭제하시겠습니까?")) return;
// 	document.frm.submit();
// 	window.opener.fnReloadGrid();
// 	window.close();
// }
</script>
<script type="text/javascript">
//규격서/절차서 구분
function stadardClassifySelect(){
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"PROPOSAL_SUGGEST",//신규자재 코드와 같이 사용
			isUse:"1"
		},
		function(arg){
			var codeList= eval('('+arg+')').list;
			for(var i=0; i < codeList.length; i++){
				$("#classify").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			var classify = "<%=classify%>";
			if(classify != ""){
				$("#classify").val(classify);
			}
		}
	);
}

</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<input type="hidden" name="board_No" id="board_No" value="<%=board_No%>" />
<input type="hidden" name="id" id="id" value="<%=board_No%>" />
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
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
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
					<td class="table_td_contents" <%if(!"0202".equals(board_Type)){ %> colspan="3"<%}%> >
						<%=boardDto.getTitle() %>	
					</td>
<%if("0202".equals(board_Type)){ %>
					<td class="table_td_subject">
						구분
					</td>
					<td class="table_td_contents" >
						<select id="classify" name="classify" class="select" disabled="disabled">
							<option value="">전체</option>
						</select>
					</td>
<%}%>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
<%if("0202".equals(board_Type)){ %>
				<tr>
					<td width="60" class="table_td_subject">규격</td>
					<td colspan="3" class="table_td_contents">
						<input type="text" id="standard" name="title" class="input" style="width:78%" value="<%=standard %>"/>	
					</td>
				</tr>
<%} %>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">내용</td>
					<td  valign="top" class="table_td_contents4" colspan="3" style="height: 380px;">
						<%=boardDto.getMessage()%>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						<%=attach1%>
					</td>
					<td  class="table_td_contents">
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val())">
						<span id="attach_file_name1"><%=attach_file_name1 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						<%=attach2%>
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
						첨부파일3
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val())">
						<span id="attach_file_name3"><%=attach_file_name3 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						첨부파일4
					</td>
					<td  class="table_td_contents">
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
					<td width="60" class="table_td_subject" >등록자</td>
					<td class="table_td_contents" >
						<%=regi_user_numb%>
					</td>
					<td width="60" class="table_td_subject">등록일</td>
					<td class="table_td_contents" >
						<%=boardDto.getRegi_Date_Time()%>
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
		
<%	if(("0201").equals(board_Type) || "ADM".equals(userInfoDto.getSvcTypeCd()) && !("0103").equals(board_Type) && !("0202").equals(board_Type)) {	%>
			<button id="ReplyButton" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-reply"></i> 답글</button>
<%	} %>
<%	
	if("ADM".equals(userInfoDto.getSvcTypeCd())) {
		if(userInfoDto.getUserNm().equals(regi_user_numb)){
%>
			<button id="delButton" type="button" class="btn btn-darkgray btn-sm jqmClose"><i class="fa fa-times"></i> 삭제</button>
<%
		}
	} 
%>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
		</td>
	</tr>
</table>
</form>
</body>
</html>