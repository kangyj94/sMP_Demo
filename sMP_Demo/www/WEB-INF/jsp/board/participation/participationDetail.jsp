<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
	
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");


	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String participationNo = request.getParameter("participationNo");
	String width = "$(window).width()-20 + Number(gridWidthResizePlus)";
	
	List<Map<String, Object>> list = (List)request.getAttribute("list");
	
	String businessNum = "";
	String insertUserNm = "";
	String loginId = userDto.getLoginId();
	if("XXXXXXXXXX".equals(loginId)){
		businessNum = userDto.getBorgNm();
		insertUserNm = userDto.getBorgNms();
	}else{
		insertUserNm = userDto.getUserNm();
		if("BUY".equals(userDto.getSvcTypeCd())){
			businessNum = userDto.getSmpBranchsDto().getBusinessNum();
		}else if("".equals(userDto.getSvcTypeCd())){
			businessNum = userDto.getSmpVendorsDto().getBusinessNum();
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	
	//button event
	$("#btnCmmentWrite").click(function(){ commentWrite(); });//하단 답글작성
	
	//구분 셀렉트 박스
	classifySelect();
	
	//답글감추기
	commentWriteLevHide();
});

</script>

<script type="text/javascript">
//구분 셀렉트 박스
function classifySelect(){
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
			$("#classify").attr("disabled",true);
			//상세내용
			participationDetail();
		}
	);
}

//data bind
function participationDetail(){
	var participationNo = "<%=participationNo%>";
	$.post(
		"/board/selectParticipationDetail/participationDetail/object.sys",
		{
			participationNo:participationNo
		},
		function(arg){
			var result = eval('('+arg+')').participationDetail;
			$("#subject").html(result.SUBJECT);
			$("#classify").val(result.CLASSIFY)
			$("#insertUserNm").html(result.INSERT_USER_NM);
			$("#participationContent").html(result.CONTENT);
			$("#file_list1").val(result.FILE_LIST1);
			$("#file_list2").val(result.FILE_LIST2);
			$("#attach_file_name1").html(result.ATTACH_FILE_NAME1);
			$("#attach_file_name2").html(result.ATTACH_FILE_NAME2);
			$("#attach_file_path1").val(result.ATTACH_FILE_PATH1);
			$("#attach_file_path2").val(result.ATTACH_FILE_PATH2);
			
		}
	);
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
		jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>').appendTo('body').submit().remove();
	};
};

/**
 * 파일다운로드
 */
function fnCommentAttachFileDownload1(seq) {
	var attach_file_path = $("#attach_file_path1_lev"+seq).val();
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

/**
 * 파일다운로드
 */
function fnCommentAttachFileDownload2(seq) {
	var attach_file_path = $("#attach_file_path2_lev"+seq).val();
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


//게시글의 답글 입력
function commentWrite(){
	var participationNo = "<%=participationNo%>";
	var commentContent = $("#commentContent").val();
	if(commentContent == ""){
		alert("내용을 입력해 주세요.");
		return;
	}
	var businessNum = "<%=businessNum%>";
	var insertUserNm = "<%=insertUserNm%>";
	
	$.post(
		"/board/insertParticipationComment/save.sys",
		{
			participationNo:participationNo,
			idGenSvcNm:"seqParticipationComment",
			oper:"add",
			insertUserId:"<%=userDto.getUserId()%>",
			insertUserNm:insertUserNm,
			svcType:"<%=userDto.getSvcTypeCd()%>",
			content:commentContent,
			businessNum:businessNum,
			fileList1:$("#comment_file_list1").val(),
			fileList2:$("#comment_file_list2").val(),
		},
		function(arg){
			if(fnAjaxTransResult(arg)){
				self.location.reload();
			}
		}
	);
}

//답글의 게시글 보이기
function showComment(flag, i, content){
	//답글 등록시
	if(flag == 10){
		if($("#commentWriteLev"+i).css("display") == "none"){
			$("#commentWriteLev"+i).css("display", "block");
		}else{
			$("#commentWriteLev"+i).css("display", "none");
			$("#commentContentLev"+i).val("");
			$("#comment_file_list1_lev"+i).val("");
			$("#comment_attach_file_path1_lev"+i).val("");
			$("#comment_attach_file_name1_lev"+i).html("");
			$("#comment_file_list2_lev"+i).val("");
			$("#comment_attach_file_path2_lev"+i).val("");
			$("#comment_attach_file_name2_lev"+i).html("");
		}
	}else if(flag == 20){//답글 수정시
		if($("#commentList"+i).css("display") != "none" ){
			$("#commentList"+i).hide();
			$("#commentListMod"+i).show();
			$("#commentListContentMod"+i).html(content);
		}else{
			$("#commentList"+i).show();
			$("#commentListMod"+i).hide();
		}
	}
}

//답글의 답글 달기
function commentWriteLev(group, lev, i){
	var participationNo = "<%=participationNo%>";
	var content = $("#commentContentLev"+i).val();
	if(content == ""){
		alert("내용을 입력해 주세요.");
		return;
	}
	var businessNum = "<%=businessNum%>";
	var insertUserNm = "<%=insertUserNm%>";
	
	var comment_file_list1_lev = $("#comment_file_list1_lev"+i).val();
	var comment_file_list2_lev = $("#comment_file_list2_lev"+i).val();
	$.post(
		"/board/insertParticipationCommentLev/save.sys",
		{
			participationNo:participationNo,
			oper:"add",
			idGenSvcNm:"seqParticipationComment",
			insertUserId:"<%=userDto.getUserId()%>",
			insertUserNm:insertUserNm,
			svcType:"<%=userDto.getSvcTypeCd()%>",
			content:content,
			businessNum:businessNum,
			group:group,
			lev:lev+1,
			fileList1:comment_file_list1_lev,
			fileList2:comment_file_list2_lev
		},  
		function(arg){
			if(fnAjaxTransResult(arg)){
				self.location.reload();
			}
		}
	);
}

//자신이 작성한 답글 수정
function commentMod(commentNo, i){
	var content	= $("#commentListContentMod"+i).val();
	var loginId	= "<%=userDto.getLoginId()%>";
	if(content == ""){
		alert("내용을 입력해 주세요.");
		return;
	}
	confirm("수정하시겠습니까?");
	var modUserNm = "<%=insertUserNm%>";
	$.post(
		"/board/updateParticipationComment/save.sys",
		{
			oper:"edit",
			participationNo:"<%=participationNo%>",
			commentNo:commentNo,
			content:content,
			modUserId:loginId, 
			modUserNm:modUserNm
		},
		function(arg){
			if(fnAjaxTransResult(arg)){
				self.location.reload();
			}
		}
	);
}

//자신이 작성한 답글의 답글 수정
function commentLevMod(commentNo, i){
	
	var modUserNm = "<%=insertUserNm%>";
	var content	= $("#commentListContentMod"+i).val();
	var loginId	= "<%=userDto.getLoginId()%>";
	if(content == ""){
		alert("내용을 입력해 주세요.");
		return;
	}
	confirm("수정하시겠습니까?");
	$.post(
		"/board/updateParticipationComment/save.sys",
		{
			oper:"edit",
			participationNo:"<%=participationNo%>",
			commentNo:commentNo,
			content:$("#commentListContentLevMod"+i).val(),
			modUserId:loginId, 
			modUserNm:modUserNm
		},
		function(arg){
			if(fnAjaxTransResult(arg)){
				self.location.reload();
			}
		}
	);
}

//답글 삭제 상태로 변경
function commentDel(commentNo){
	$.post(
		"/board/updateParticipationCommentDel/save.sys",
		{
			oper:"edit",
			commentNo:commentNo
		},
		function(arg){
			if(fnAjaxTransResult(arg)){
				self.location.reload();
			}
		}
	);
}

//답글의 답글 수정 보이기/감추기
function showCommentLev(flag, i, content) {
	if(flag == 10){//답글 수정시
		if($("#commentListLev"+i).css("display") != "none" ){
			$("#commentListLev"+i).hide();
			$("#commentListLevMod"+i).show();
			$("#commentListContentLevMod"+i).html(content);
		}else{
			$("#commentListLev"+i).show();
			$("#commentListLevMod"+i).hide();
		}
	}
}

//답글창, 수정창 감추기
function commentWriteLevHide(){
	$("tr[name='commentWriteLev']").css("display", "none");
	$("tr[name='commentModLev']").css("display", "none");
	$("div[name='commentListMod']").hide();
	$("div[name='commentListLevMod']").hide();
}
</script>
<%@ include file="/WEB-INF/jsp/common/attachFileDivCommnet.jsp" %>
<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
* seq 어느 답글인지 알기 위해 만든 값
*/
%>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#commentBtnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#comment_file_list1").val(), "fnCallBackCommentAttach1","2",""); });//하단 답글 첨부파일1 
	$("#commentBtnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#comment_file_list2").val(), "fnCallBackCommentAttach2","2",""); });//하단 답글 첨부파일2
});


function commentAttchLev1(seq){
	fnUploadDialog("첨부파일1", $("#comment_file_list1_lev"+seq).val(), "fnCallBackCommentAttach1_lev","2", seq);
}

function commentAttchLev2(seq){
	fnUploadDialog("첨부파일2", $("#comment_file_list2_lev"+seq).val(), "fnCallBackCommentAttach2_lev","2", seq);
}

function fnCallBackCommentAttach1_lev(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path, seq) {
	$("#comment_file_list1_lev"+seq).val(rtn_attach_seq);
	$("#comment_attach_file_name1_lev"+seq).text(rtn_attach_file_name);
	$("#comment_attach_file_path1_lev"+seq).val(rtn_attach_file_path);
}

function fnCallBackCommentAttach2_lev(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path, seq) {
	$("#comment_file_list2_lev"+seq).val(rtn_attach_seq);
	$("#comment_attach_file_name2_lev"+seq).text(rtn_attach_file_name);
	$("#comment_attach_file_path2_lev"+seq).val(rtn_attach_file_path);
}

/**
 * 하단 답글 첨부파일1 파일관리
 */
function fnCallBackCommentAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path, seq) {
	$("#comment_file_list1").val(rtn_attach_seq);
	$("#comment_attach_file_name1").text(rtn_attach_file_name);
	$("#comment_attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 하단 답글 첨부파일1 파일관리
 */
function fnCallBackCommentAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#comment_file_list2").val(rtn_attach_seq);
	$("#comment_attach_file_name2").text(rtn_attach_file_name);
	$("#comment_attach_file_path2").val(rtn_attach_file_path);
}

</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body style="background-color:#ffffff;">
<table width="98%" style="margin-left: 12px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>참여게시판 상세</td>
				</tr>
				<tr><td height="5"></td></tr>
			</table>
			<!-- Search Context -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="150px" align="center">
						공고
					</td>
					<td class="table_td_contents">
						<span id="subject"></span>
					</td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" align="center">
						구분
					</td>
					<td class="table_td_contents">
						<select id="classify" class="select">
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" align="center">
						작성자
					</td>
					<td class="table_td_contents">
						<span id="insertUserNm"></span>
					</td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" align="center">
						내용
					</td>
					<td class="table_td_contents">
						<div id="participationContent" style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:90%; height:240px;; padding:10px 10px 10px 10px;" >
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" align="center">
						첨부파일1
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value=""/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value=""/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
							<span id="attach_file_name1"></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" align="center">
						첨부파일2
					</td>
					<td class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value=""/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value=""/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
							<span id="attach_file_name2"></span>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="2" height='1'></td>
				</tr>
				<tr>
					<td colspan="2" class="table_top_line"></td>
				</tr>
			</table>
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
		</td>
	</tr>
	<tr>
		<td height="10"></td>
	</tr>
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>답글</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3" class="table_top_line"></td>
				</tr>
<% 
	for(int i=0; i<list.size(); i++){
		int group = Integer.parseInt(list.get(i).get("GROUP_NO").toString());
		int lev = Integer.parseInt(list.get(i).get("LEV_NO").toString());
		int lineIsUse = Integer.parseInt(list.get(i).get("LINE_ISUSE").toString());
		String fileList1 = list.get(i).get("FILE_LIST1").toString();
		String fileList2 = list.get(i).get("FILE_LIST2").toString();
		String fileName1 = list.get(i).get("ATTACH_FILE_NAME1").toString();
		String fileName2 = list.get(i).get("ATTACH_FILE_NAME2").toString();
		String filePath1 = list.get(i).get("ATTACH_FILE_PATH1").toString();
		String filePath2 = list.get(i).get("ATTACH_FILE_PATH2").toString();
		String content = list.get(i).get("CONTENT").toString();
		int commentNo = Integer.parseInt(list.get(i).get("COMMENT_NO").toString());
		String isUse = list.get(i).get("ISUSE").toString();
		if(0==lev){
%>
				<!-- 최상단 덧글 시작-->
				<tr>
					<td width="20%" height="30" class="table_td_contents5">
						<b>
							<%=list.get(i).get("INSERT_USER_NM").toString()%>
						</b>
					</td>
					<td width="28%" class="table_td_contents">
						<%=list.get(i).get("INSERT_DATE").toString()%>
						&nbsp;&nbsp;
							<a href="javascript:showComment('10', <%=i%>, '')">
								<span id='btnComment' class='questionButton'>답글</span>
							</a>
					</td>
					<td width="52%" class="table_td_contents" align="right">
<%	
					if("1".equals(isUse)){
						if("XXXXXXXXXX".equals(userDto.getLoginId())){
							if(userDto.getBorgNm().equals(list.get(i).get("BUSINESS_NUM"))){
								
%>
								<a href="javascript:showComment('20', <%=i%>, '<%=content%>')">
									<span id='btnCommentMod' class='questionButton'>수정</span>
								</a>
								<a href="javascript:commentDel('<%=commentNo%>')">
									<span class='questionButton'>삭제</span>
								</a>
<%
							}
						}else{
							if(userDto.getUserId().equals(list.get(i).get("INSERT_USER_ID"))){
%>								
								<a href="javascript:showComment('20', <%=i%>, '<%=content%>')">
									<span id='btnCommentMod' class='questionButton'>수정</span>
								</a>
								<a href="javascript:commentDel('<%=commentNo%>')">
									<span class='questionButton'>삭제</span>
								</a>
<%
							}
						}
					}%>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="table_td_contents5">
						<div id="commentList<%=i%>" name="commentList">
							<%=content%>
						</div>
						<div id="commentListMod<%=i%>" name="commentListMod">
							<table>
								<tr>
									<td width="70%" style="padding-right:5px;">
										<textarea id="commentListContentMod<%=i%>" name="commentListContentMod<%=i%>" style="width:715px; height:58px;">
										</textarea>
									</td>
									<td width="20%">
										<a href="javascript:commentMod(<%=commentNo%>, <%=i%>)">
											<span class='questionButton'>확인</span>
										</a>
										<br/><br/>
										<span class='questionButton'>취소</span>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="table_td_contents5" align="right">
						<input type="hidden" id="file_list1_lev<%=i%>" name="file_list1_lev<%=i%>" value="<%=fileList1%>"/>
						<input type="hidden" id="attach_file_path1_lev<%=i%>" name="attach_file_path1_lev<%=i%>" value="<%=filePath1%>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path1_lev<%=i%>').val());">
							<%=fileName1%>
						</a>
					</td>
				</tr>
				<tr>
					<td colspan="3" class="table_td_contents5" align="right">
						<input type="hidden" id="file_list2_lev<%=i%>" name="file_list2_lev<%=i%>" value="<%=fileList2%>"/>
						<input type="hidden" id="attach_file_path2_lev<%=i%>" name="attach_file_path2_lev<%=i%>" value="<%=filePath2%>"/>
						<a href="javascript:fnAttachFileDownload($('#attach_file_path2_lev<%=i%>').val());">
							<%=fileName2%>
						</a>
					</td>
				</tr>
				<!-- 최상단 덧글 끝-->
				<!-- 최상단 덧글 수정창 시작-->
				<tr >
					<td colspan="3" style="display: none;">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="3" height="30"></td>
							</tr>
							<tr>
								<td width="2%"></td>
								<td width="98%">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												답글
											</td>
											<td width="70%" style="padding-right:5px;">
												<textarea id="commentContentLevMod<%=i%>" name="commentContentLevMod<%=i%>" style="width:715px; height:58px;"></textarea>
											</td>
											<td width="20%">
												<a href="javascript:commentWriteMod()">
													<span id='question' class='questionButton'>확인</span>
												</a>
												<br/><br/>
												<span id='question' class='questionButton'>취소</span>
											</td>
										</tr>
										<tr>
											<td colspan="3" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												<table>
													<tr>
														<td>첨부파일1</td>
													</tr>
													<tr>
														<td>
															<a href="#">
																<img id="" name="" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td colspan="3" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												<table>
													<tr>
														<td>첨부파일2</td>
													</tr>
													<tr>
														<td>
															<a href="#">
																<img id="commentBtnAttach2" name="commentBtnAttach2" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td colspan="3" height='1' bgcolor="eaeaea"></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="2%"></td>
								<td class="table_top_line"></td>
							</tr>
							<tr>
								<td colspan="2" height="15"></td>
							</tr>							
						</table>
					</td>
				</tr>
				<!-- 최상단 덧글 수정창 끝-->

				<!-- 덧글의 덧글 글쓰기창 시작 -->
				<tr id="commentWriteLev<%=i%>" name="commentWriteLev">
					<td colspan="3">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="5%"></td>
								<td colspan="2" width="95%" style="height:1px;background-image:url('/img/system/comment_line.png')"></td>
							</tr>
							<tr>
								<td colspan="3" height="15"></td>
							</tr>
							<tr>
								<td width="5%"></td>
								<td width="2%"><img src='/img/system/icon/ico_reply.gif' height='10' style='border:0;'/></td>
								<td width="93%">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												답글
											</td>
											<td width="70%" style="padding-right:5px;">
												<textarea id="commentContentLev<%=i%>" name="commentContentLev<%=i%>" style="width:615px; height:58px;"></textarea>
											</td>
											<td width="20%">
												<a href="javascript:commentWriteLev(<%=group%>,<%=lev%>,<%=i%>)">
													<span class='questionButton'>등록</span>
												</a>
											</td>
										</tr>
										<tr>
											<td colspan="3" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												<table>
													<tr>
														<td>첨부파일1</td>
													</tr>
													<tr>
														<td>
															<a href='javascript:commentAttchLev1(<%=i%>)'>
																<img id="commentBtnAttach1_lev" name="commentBtnAttach1_lev" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>
														</td>
													</tr>
												</table>
											</td>
											<td colspan="2" height='1' class="table_td_contents5">
												<input type="hidden" id="comment_file_list1_lev<%=i%>" name="comment_file_list1_lev<%=i%>" value=""/>
												<input type="hidden" id="comment_attach_file_path1_lev<%=i%>" name="comment_attach_file_path1_lev<%=i%>" value=""/>
												<a href="javascript:fnCommentAttachFileDownload1(<%=i%>);">
													<span id="comment_attach_file_name1_lev<%=i%>"></span>
												</a>
											</td>
										</tr>
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												<table>
													<tr>
														<td>첨부파일2</td>
													</tr>
													<tr>
														<td>
															<a href='javascript:commentAttchLev2(<%=i%>)'>
																<img id="commentBtnAttach2_lev" name="commentBtnAttach2_lev" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>
														</td>
													</tr>
												</table>
											</td>
											<td colspan="2" height='1' class="table_td_contents5">
												<input type="hidden" id="comment_file_list2_lev<%=i%>" name="comment_file_list2_lev<%=i%>" value=""/>
												<input type="hidden" id="comment_attach_file_path2_lev<%=i%>" name="comment_attach_file_path2_lev<%=i%>" value=""/>
												<a href="javascript:fnCommentAttachFileDownload2(<%=i%>);">
													<span id="comment_attach_file_name2_lev<%=i%>"></span>
												</a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3" height="15"></td>
							</tr>
						</table>
					</td>
				</tr>				
				<!-- 덧글의 덧글 글쓰기창 끝 -->
<%
		}else if(1==lev){
%>	
				<!-- 덧글의 덧글 시작 -->
				<tr>
					<td colspan="3">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="5%"></td>
								<td colspan="2" width="95%" style="height:1px;background-image:url('/img/system/comment_line.png')"></td>
							</tr>
							<tr>
								<td width="5%"></td>
								<td width="2%"><img src='/img/system/icon/ico_reply.gif' height='10' style='border:0;'/></td>
								<td width="93%">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="20%" height="30" class="table_td_contents5">
												<b><%=list.get(i).get("INSERT_USER_NM")%></b>
											</td>
											<td width="28%" class="table_td_contents">
											</td>
											<td width="52%" class="table_td_contents" align="right">
<%											if("1".equals(isUse)){
												if("XXXXXXXXXX".equals(userDto.getLoginId())){
													if(userDto.getBorgNm().equals(list.get(i).get("BUSINESS_NUM"))){
%>
														<a href="javascript:showCommentLev('10', <%=i%>, '<%=content%>')">
															<span id='question' class='questionButton'>수정</span>
														</a>
														<a href="javascript:commentDel('<%=commentNo%>')">
															<span id='question' class='questionButton'>삭제</span>
														</a>
<%													}
												}else{
													if(userDto.getUserId().equals(list.get(i).get("INSERT_USER_ID"))){
%>
														<a href="javascript:showCommentLev('10', <%=i%>, '<%=content%>')">
															<span id='question' class='questionButton'>수정</span>
														</a>
														<a href="javascript:commentDel('<%=commentNo%>')">
															<span id='question' class='questionButton'>삭제</span>
														</a>
<%
													}
												}
											}
%>
											</td>
										</tr>
										<tr>
											<td colspan="3" class="table_td_contents5">
												<div id="commentListLev<%=i%>" name="commentListLev">
													<%=list.get(i).get("CONTENT").toString()%>
												</div>
												<div id="commentListLevMod<%=i%>" name="commentListLevMod">
													<table>
														<tr>
															<td width="70%" style="padding-right:5px;">
																<textarea id="commentListContentLevMod<%=i%>" name="commentListContentLevMod<%=i%>" style="width:715px; height:58px;">
																</textarea>
															</td>
															<td width="20%">
																<a href="javascript:commentLevMod(<%=commentNo%>, <%=i%>)">
																	<span id='question' class='questionButton'>확인</span>
																</a>
																<br/><br/>
																<span id='question' class='questionButton'>취소</span>
															</td>
														</tr>
													</table>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="3" class="table_td_contents5" align="right">
												<input type="hidden" id="file_list1_lev<%=i%>" name="file_list1_lev<%=i%>" value="<%=fileList1%>"/>
												<input type="hidden" id="attach_file_path1_lev<%=i%>" name="attach_file_path1_lev<%=i%>" value="<%=filePath1%>"/>
												<a href="javascript:fnAttachFileDownload($('#attach_file_path1_lev<%=i%>').val());">
													<%=fileName1%>
												</a>
											</td>
										</tr>
										<tr>
											<td colspan="3" class="table_td_contents5" align="right">
												<input type="hidden" id="file_list2_lev<%=i%>" name="file_list2_lev<%=i%>" value="<%=fileList2%>"/>
												<input type="hidden" id="attach_file_path2_lev<%=i%>" name="attach_file_path2_lev<%=i%>" value="<%=filePath2%>"/>
												<a href="javascript:fnAttachFileDownload($('#attach_file_path2_lev<%=i%>').val());">
													<%=fileName2%>
												</a>
											</td>
										</tr>
									</table>
								</td>	
							</tr>
						</table>
					</td>					
				</tr>
				<!-- 덧글의 덧글 끝 -->
<%
		}
%>
<%
			if(1==lineIsUse){
%>
				<!-- 최상단 덧글구분 라인 -->
				<tr>
					<td colspan="3" bgcolor="#DDDDDD" height="1"></td>
				</tr>
				<!-- 최상단 덧글구분 라인 -->
<% 
			}
%>
<% 
	}
%>				
				<tr>
					<td colspan="3" class="table_top_line"></td>
				</tr>
				<!-- 최상단 덧글 입력창 시작-->
				<tr>
					<td colspan="3">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="3" height="30"></td>
							</tr>
							<tr>
								<td width="2%"></td>
								<td class="table_top_line"></td>
							</tr>
							<tr>
								<td width="100%">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td colspan="2" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												답글
											</td>
											<td width="70%">
												<textarea id="commentContent" name="commentContent" style="width:715px; height:58px;"></textarea>
												<span id="btnCmmentWrite" class='questionButton' style="vertical-align: top; margin-top: 20px;">등록</span>
											</td>
										</tr>
										<tr>
											<td colspan="2" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												<table>
													<tr>
														<td>첨부파일1</td>
													</tr>
													<tr>
														<td>
															<a href="#">
																<img id="commentBtnAttach1" name="commentBtnAttach1" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>
														</td>
													</tr>
												</table>
											</td>
											<td>
												<input type="hidden" id="comment_file_list1" name="comment_file_list1" value=""/>
												<input type="hidden" id="comment_attach_file_path1" name="comment_attach_file_path1" value=""/>
												<a href="javascript:fnAttachFileDownload($('#comment_attach_file_path1').val());">
													<span id="comment_attach_file_name1"></span>
												</a>
											</td>
										</tr>
										<tr>
											<td colspan="2" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td class="table_td_subject" width="10%" align="center">
												<table>
													<tr>
														<td>첨부파일2</td>
													</tr>
													<tr>
														<td>
															<a href="#">
																<img id="commentBtnAttach2" name="commentBtnAttach2" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
															</a>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td colspan="2" height='1' bgcolor="eaeaea"></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="2%"></td>
								<td class="table_top_line"></td>
							</tr>
							<tr>
								<td colspan="2" height="15"></td>
							</tr>							
						</table>
					</td>
				</tr>
				<!-- 최상단 덧글 입력창 끝-->
			</table>
		</td>
	</tr>
	

</table>
</body>
</html>