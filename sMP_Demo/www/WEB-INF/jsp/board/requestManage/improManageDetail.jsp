<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.ImproDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	ImproDto improDto = (ImproDto)request.getAttribute("detailInfo");	//게시물정보
	String modi_User_Numb = userInfoDto.getUserNm();
	String hand_User_Numb = userInfoDto.getUserNm();
	String modi_User_Date = CommonUtils.getCurrentDate();
	String attach_file_name1 = CommonUtils.getString(improDto.getAttach_file_name1()); //요청자 
	String attach_file_name2 = CommonUtils.getString(improDto.getAttach_file_name2());
	String attach_file_name3 = CommonUtils.getString(improDto.getAttach_file_name3());
	String attach_file_name4 = CommonUtils.getString(improDto.getAttach_file_name4());
	
	String attach_file_path1 = CommonUtils.getString(improDto.getAttach_file_path1()); //요청자 
	String attach_file_path2 = CommonUtils.getString(improDto.getAttach_file_path2());
	String attach_file_path3 = CommonUtils.getString(improDto.getAttach_file_path3());
	String attach_file_path4 = CommonUtils.getString(improDto.getAttach_file_path4());
	
	String hand_file_names1 = CommonUtils.getString(improDto.getHand_File_names1()); //접수자
	String hand_file_names2 = CommonUtils.getString(improDto.getHand_File_names2());
	String hand_file_names3 = CommonUtils.getString(improDto.getHand_File_names3()); 
	String hand_file_names4 = CommonUtils.getString(improDto.getHand_File_names4());
	
	String hand_attach_file_path1 = CommonUtils.getString(improDto.getHand_attach_file_path1());//접수자
	String hand_attach_file_path2 = CommonUtils.getString(improDto.getHand_attach_file_path2());
	String hand_attach_file_path3 = CommonUtils.getString(improDto.getHand_attach_file_path3());
	String hand_attach_file_path4 = CommonUtils.getString(improDto.getHand_attach_file_path4());
	
	String modi_file_names1 = CommonUtils.getString(improDto.getModi_file_names1()); //답변자
	String modi_file_names2 = CommonUtils.getString(improDto.getModi_file_names2());
	String modi_file_names3 = CommonUtils.getString(improDto.getModi_file_names3());
	String modi_file_names4 = CommonUtils.getString(improDto.getModi_file_names4());
	
	String modi_file_path1 = CommonUtils.getString(improDto.getModi_file_path1());//답변자
	String modi_file_path2 = CommonUtils.getString(improDto.getModi_file_path2());
	String modi_file_path3 = CommonUtils.getString(improDto.getModi_file_path3());
	String modi_file_path4 = CommonUtils.getString(improDto.getModi_file_path4());
	
	

	String stat_flag_code = CommonUtils.getString(improDto.getStat_Flag_Code());
	String req_message = CommonUtils.getString(improDto.getReq_Message());
	String hand_message = CommonUtils.getString(improDto.getHand_Message());
	String first = CommonUtils.getString(improDto.getFirst());
	
	String no = CommonUtils.getString(improDto.getNo());//시퀀스
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
	$("#ReplyButton").click( function(){ fnReply();	});
	$("#ReturnButton").click( function() {fnReturnply();});
	$("#HandleButton").click( function() {fnhandling();});
	$("#AnswerButton").click( function() {fnanswer();});
});
</script> 

<!-- 그리드 이벤트 스크립트-->
<script type="text/javascript">
function fnClose(){
	window.opener.fnReloadGrid();
	window.close();
}

//접수
function fnReply() {
	var popurl = "/board/improManageReg.sys?statFlagCode=2&_menuId=<%=_menuId%>&no=<%=no%>";
	window.open(popurl, 'okplazaPop2', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}

//접수반려
function fnReturnply() {
	var popurl = "/board/improManageReg.sys?statFlagCode=3&_menuId=<%=_menuId%>&no=<%=no%>";
	window.open(popurl, 'okplazaPop2', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}
//처리완료
function fnhandling() {
	var popurl = "/board/improManageReg.sys?statFlagCode=4&_menuId=<%=_menuId%>&no=<%=no%>";
	window.open(popurl, 'okplazaPop2', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}
//답변완료
function fnanswer() {
	var popurl = "/board/improManageReg.sys?statFlagCode=5&_menuId=<%=_menuId%>&no=<%=no%>";
	window.open(popurl, 'okplazaPop2', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}


function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
	jq("#list").trigger("reloadGrid");
}
</script>
</head>
<body>
<form id="frm" name="frm" method="post">
<input type="hidden" name="modi_User_Numb" id="modi_User_Numb" value="<%=modi_User_Numb %>" />
<input type="hidden" name="hand_User_Numb" id="hand_User_Numb" value="<%=hand_User_Numb %>" />
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
						<%=improDto.getTitle() %>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>

				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						요청첨부파일1
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val())">
						<span id="attach_file_name1"><%=attach_file_name1 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						요청첨부파일2
					</td>
					<td width="50%" class="table_td_contents">
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
					<td class="table_td_subject" width="60">요청내역</td>
					<td height="400" valign="top" class="table_td_contents4" colspan="3">
						<%=improDto.getMessage()%>
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
<%	if("2".equals(stat_flag_code) || "3".equals(stat_flag_code)) { %>
	<tr>
		<td>
    		<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>접수 정보( <%if("2".equals(stat_flag_code)) {out.println("접수");} else if("3".equals(stat_flag_code)) {out.println("반려");}%>)</td>
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
<!-- 					<a href="javascript:fnAttachFileDownload($('#hand_attach_file_path1').val())"> -->
						<a href="javascript:fnAttachFileDownload('<%=hand_attach_file_path1 %>');">
						<span id="hand_file_name1"><%=hand_file_names1%></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						답변첨부파일2
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=hand_attach_file_path2 %>');">
						<span id="hand_file_name2"><%= hand_file_names2 %></span>
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
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=hand_attach_file_path3 %>');">
						<span id="hand_file_name3"><%= hand_file_names3 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						답변첨부파일4
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=hand_attach_file_path4 %>');">
						<span id="hand_file_name4"><%=hand_file_names4 %></span> 
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
					<td width="60" class="table_td_subject">
						우선순위
					</td>
					<td width="50%" class="table_td_contentsd">
					&nbsp;&nbsp;<span id = "first"> <%=first%></span>
					</td>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">답변내역</td>
					<td height="300" valign="top" class="table_td_contents4" colspan="3">
						<%=hand_message %>
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
<%	//---------------------------------------답글시작----------------------------------------------- %>
<%	if("4".equals(stat_flag_code) || "5".equals(stat_flag_code)){%>
	<tr>
		<td>
    		<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>접수 정보</td>
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
						접수첨부파일1
					</td>
					<td width="50%" class="table_td_contents">
<!-- 					<a href="javascript:fnAttachFileDownload($('#hand_attach_file_path1').val())"> -->
						<a href="javascript:fnAttachFileDownload('<%=hand_attach_file_path1 %>');">
						<span id="hand_file_names1"><%=hand_file_names1 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						접수첨부파일2
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=hand_attach_file_path2 %>');">
						<span id="hand_file_names2"><%=hand_file_names2 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						접수첨부파일3
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=hand_attach_file_path3 %>');">
						<span id="hand_file_names3"><%=hand_file_names3 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						접수첨부파일4
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=hand_attach_file_path4 %>');">
						<span id="hand_file_names4"><%=hand_file_names4 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">접수내역</td>
					<td height="300" valign="top" class="table_td_contents4" colspan="3">
						<%=hand_message %>
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
		<td>
    		<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>접수 정보( <%if("4".equals(stat_flag_code)) {out.println("처리완료");} else if("5".equals(stat_flag_code)) {out.println("답변반려");}%>)</td>
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
						접수첨부파일1
					</td>
					<td width="50%" class="table_td_contents">
<!-- 					<a href="javascript:fnAttachFileDownload($('#hand_attach_file_path1').val())"> -->
						<a href="javascript:fnAttachFileDownload('<%=modi_file_path1 %>');">
						<span id="modi_file_names1"><%=modi_file_names1 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						접수첨부파일2
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=modi_file_path2 %>');">
						<span id="modi_file_names2"><%=modi_file_names2 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">
						접수첨부파일3
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=modi_file_path3 %>');">
						<span id="modi_file_names3"><%=modi_file_names3 %></span>
						</a>
					</td>
					<td width="60" class="table_td_subject">
						접수첨부파일4
					</td>
					<td width="50%" class="table_td_contents">
						<a href="javascript:fnAttachFileDownload('<%=modi_file_path4 %>');">
						<span id="modi_file_names4"><%=modi_file_names4 %></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="60" class="table_td_subject">접수내역</td>
					<td height="300" valign="top" class="table_td_contents4" colspan="3">
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
<%	if("1".equals(stat_flag_code)){	%>
			<button id="ReplyButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-file-text"></i> 접수</button>
			<button id="ReturnButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-reply"></i> 반려</button>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
<%	}%><%else if("2".equals(stat_flag_code)){	%>
			<button id="HandleButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-check-square"></i> 처리완료</button>
			<button id="ReturnButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-reply"></i> 반려</button>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
<%	}%><%else if("3".equals(stat_flag_code)){	%>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
<%	}%><%else if("4".equals(stat_flag_code)){	%>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
<%	}%><%else if("5".equals(stat_flag_code)){	%>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
<%	}%>
<%-- 			<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="border: 0px;" /></a> --%>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</form>
</body>
</html>