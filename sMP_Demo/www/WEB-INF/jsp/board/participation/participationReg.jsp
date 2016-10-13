<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>

<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	Map<String, Object> participationBoardDetail = (Map)request.getAttribute("participationBoardDetail");
	String participationNo = "";
	String classify = "";
	String subject = "";
	String content = "";
	String fileList1 = "";
	String fileList2 = "";
	String attachFileName1 = "";
	String attachFileName2 = "";
	String attachFilePath1 = "";
	String attachFilePath2 = "";
	String insertUserId = "";
	String insertUserNm = "";
	String insertDate = "";

	if(participationBoardDetail != null){
		participationNo = participationBoardDetail.get("PARTICIPATION_NO").toString();
		classify = participationBoardDetail.get("CLASSIFY").toString();
		subject = participationBoardDetail.get("SUBJECT").toString();
		content = participationBoardDetail.get("CONTENT").toString();
		fileList1 = participationBoardDetail.get("FILE_LIST1").toString();
		fileList2 = participationBoardDetail.get("FILE_LIST2").toString();
		attachFileName1 = participationBoardDetail.get("ATTACH_FILE_NAME1").toString();
		attachFileName2 = participationBoardDetail.get("ATTACH_FILE_NAME2").toString();
		attachFilePath1 = participationBoardDetail.get("ATTACH_FILE_PATH1").toString();
		attachFilePath2 = participationBoardDetail.get("ATTACH_FILE_PATH2").toString();
		insertUserId = participationBoardDetail.get("INSERT_USER_ID").toString();
		insertUserNm = participationBoardDetail.get("INSERT_USER_NM").toString();
		insertDate = participationBoardDetail.get("INSERT_DATE").toString();
	}
	
	String buyBusinessNum = "";
	if("BUY".equals(userDto.getSvcTypeCd())){
		buyBusinessNum = userDto.getSmpBranchsDto().getBusinessNum().toString();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<style type="text/css">
.jqmWindow {
	display: none;
	position: fixed;
	top: 5%;
	left: 30%;
	
	margin-left: -300px;
	width: 825px;
	
	background-color: #EEE;
	color: #333;
	border: 1px solid black;
	padding: 12px;
	z-index: 1003;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
	position: absolute;
	top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<%@ include file="/WEB-INF/jsp/common/attachFileDivForProporsal.jsp" %>
<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#file_list1").val(), "fnCallBackAttach1","2"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#file_list2").val(), "fnCallBackAttach2","2"); });
});
/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list1").val(rtn_attach_seq);
	$("#attach_file_name1").text(rtn_attach_file_name);
	$("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list2").val(rtn_attach_seq);
	$("#attach_file_name2").text(rtn_attach_file_name);
	$("#attach_file_path2").val(rtn_attach_file_path);
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
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>
<script type="text/javascript">
var oEditors = [];
$(function(){
	//버튼이벤트
	$("#regiJqmButton").click(function(){ participationReg(); });//등록
	$("#modiJqmButton").click(function(){ participationModi(); });//수정
	$("#delJqmButton").click(function(){ participationDel(); });//삭제
	$("#closeButton, .jqmClose").click(function(){ window.close();});//닫기
	
	//버튼레이아웃
	buttonLayout();
	
	//구분 셀렉트 박스
	classifySelectBox();
	
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "content",
		sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
	});
});

//구분 셀렉트 박스
function classifySelectBox(){
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
			$("#classify").val(<%=classify%>);
		}
	);
}



//참여게시판 validation
var participationValidation = function(){
	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
	var classify = $("#classify").val();//구분
	var subject = $("#subject").val();//공고
	var content = $("#content").val();
	
	//공고
	if($.trim(subject) == ""){
		alert("공고를 입력해주세요.");
		return false;
	}
	
	//구분
	if($.trim(classify) == ""){
		alert("구분을 선택해주세요.");
		return false;
	}
	
	//내용
	if($.trim(content) == ""){
		alert("내용을 입력해주세요.");
		return false;
	}
	
	return true;
}

//참여게시판 등록
function participationReg(){
	var loginId = "<%=userDto.getLoginId()%>";
	if(!participationValidation()) return;
	
	var message = $("#content").val();
	message = message.replace(unescape("%uFEFF"), "");
	$.post(
		"/board/insertParticipation/save.sys",
		{
			oper:"add",
			idGenSvcNm:"seqParticipation",
			classify:$("#classify").val(),				//구분
			subject:$("#subject").val(),				//공고
			insertUserId:"<%=userDto.getUserId()%>",	//등록자ID
			insertUserNm:"<%=userDto.getBorgNms()%>",	//등록자명
			content:message,				//내용
			fileList1:$("#file_list1").val(),			//첨부파일1
			fileList2:$("#file_list2").val(),			//첨부파일2
			borgType:"<%=userDto.getSvcTypeCd()%>"
		},
		function(arg){
			if(fnAjaxTransResult(arg)){
				opener.fnReLoadDataGrid();
				window.close();
			}
		}
	);
}

//참여게시판 수정
function participationModi(){
	if(!participationValidation()) return;
	var participationNo = "<%=participationNo%>";
	$.post(
		"/board/updateParticipation/save.sys",
		{
			oper:"edit",
			classify:$("#classify").val(),			//구분
			subject:$("#subject").val(),			//공고
			content:Editor.getContent(),			//내용
			modUserId:"<%=userDto.getUserId()%>",	//수정자ID
			modUserNm:"<%=userDto.getBorgNms()%>",	//수정자명
			fileList1:$("#file_list1").val(),		//첨부파일1
			fileList2:$("#file_list2").val(),		//첨부파일2
			participationNo:participationNo			//참여게시판 Seq
		},
		function(arg){
			if(fnAjaxTransResult(arg)){
				opener.fnReLoadDataGrid();
				window.close();
			}
		}
	);
}

//참여게시판 삭제
function participationDel(){
	var participationNo = "<%=participationNo%>";
	if(participationNo != ""){
		$.post(
			"/board/deleteParticipation.sys",
			{
				participationNo:participationNo
			},
			function(arg){
				if(fnAjaxTransResult(arg)){
					opener.fnReLoadDataGrid();
					window.close();
				}
			}
		);
	}else{
		alert("해당 글의 시퀀스가 없습니다.");
	}
}
</script>

<script type="text/javascript">
function validForm() {
	var frm		= document.getElementById("frm");
	var title	= document.getElementById("title");
	
	//제목
	if(title.value == ""){
		alert("제목을 입력해 주십시오.");
		title.focus();
		
		return;
	}
	
	//내용
	
	
	return true;
}

//버튼 감추기/보이기
function buttonLayout(){
	var participationNo = "<%=participationNo%>";
	if(participationNo != ""){
		$("#regiJqmButton").hide();
	}else{
		$("#modiJqmButton").hide();
		$("#delJqmButton").hide();
	}
}
</script>

</head>
<body>
<!-- <div class="jqmWindow" id="participationDetailPop"> -->
<form id="frm" name="frm">
	<table width="800" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
					   <tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>참여게시판</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
				</table>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" /></td>
						<td width="100%"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif" width="100%" height="20" /></td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="top" bgcolor="#FFFFFF">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="6" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">공고</td>
									<td class="table_td_contents4" colspan="5">
										<input type="text" id="subject" name="subject" value="<%=subject%>" style="width: 225px" maxlength="100"/>
									</td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">구분</td>
									<td class="table_td_contents4" colspan="5">
										<select id="classify" name="classify" class="select">
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">작성자</td>
									<td class="table_td_contents4" colspan="5">
										<span id="userNm">
										<%
											if(participationBoardDetail != null){
										%>
											<%=insertUserNm%>
										<%
											}else{
										%>
											<%=userDto.getBorgNms()%>
										<%
											}
										%>
										</span>
									</td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">내용</td>
									<td class="table_td_contents4" colspan="5">
										<textarea id="content" name="content" required title="내용" style="min-width:450px;height:245px;display:none"></textarea>
									</td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">
										<table>
											<tr>
												<td>첨부파일1</td>
											</tr>
											<tr>
												<td>
													<a href="#">
														<img id="btnAttach1" name="btnAttach1" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
													</a>
												</td>
											</tr>
										</table>
									</td>
									<td class="table_td_contents">
										<input type="hidden" id="file_list1" name="file_list1" value="<%=fileList1%>"/>
										<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=attachFilePath1%>"/>
										<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
											<span id="attach_file_name1">
												<%=attachFileName1 %>
											</span>
										</a>
									</td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">
										<table>
											<tr>
												<td>첨부파일2</td>
											</tr>
											<tr>
												<td>
													<a href="#">
														<img id="btnAttach2" name="btnAttach2" src="/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
													</a>
												</td>
											</tr>
										</table>
									</td>
									<td class="table_td_contents">
										<input type="hidden" id="file_list2" name="file_list2" value="<%=fileList2%>"/>
										<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=attachFilePath2%>"/>
										<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
											<span id="attach_file_name2">
												<%=attachFileName2%>
											</span>
										</a>
									</td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td colspan="6" class="table_top_line"></td>
								</tr>
							</table> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="center">
										<button id="regiJqmButton" type="button" class="btn btn-danger btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
											<i class="fa fa-floppy-o"></i> 저장
										</button>
										<button id='modiJqmButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
											<i class="fa fa-pencil"></i> 수정
										</button>
										<button id='delJqmButton' class="btn btn-danger btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
											<i class="fa fa-trash-o"></i> 삭제
										</button>
										<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose">
											<i class="fa fa-times"></i> 닫기
										</button>

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
</form>
</body>
</html>