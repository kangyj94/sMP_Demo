<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpBranchsDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpVendorsDto" %>
<%@ page import="kr.co.bitcube.board.dto.MerequDto"%>
<%
	String replayFlag        = CommonUtils.getString(request.getParameter("replayFlag"));	//답변플래그 Y일경우 답변글
	boolean replayMod        = CommonUtils.getString(request.getParameter("mod")).equals("Y") ? true : false ;
	LoginUserDto userInfoDto = CommonUtils.getLoginUserDto(request);
	MerequDto merequDto      = (MerequDto)request.getAttribute("detailInfo");	//게시물정보
	String title             = "";
	String requ_Stat_Flag    = "";
	String req_Message       = "";
	String message           = "";
	String requ_User_Numb    = userInfoDto.getUserNm();
	String modi_User_Numb    = userInfoDto.getUserNm();
	String oper              = "";
	String no                = ""; 
	String requ_User_Date    = CommonUtils.getCurrentDate();
	String modi_User_Date    = CommonUtils.getCurrentDate();
	String stat_Flag_Code    = ""; 
	String deli_Area_Code    = "";
	String file_list1        = "";
	String file_list2        = "";
	String file_list3        = "";
	String file_list4        = "";
	String attach_file_name1 = "";
	String attach_file_name2 = "";
	String attach_file_name3 = "";
	String attach_file_name4 = "";
	String attach_file_path1 = "";
	String attach_file_path2 = "";
	String attach_file_path3 = "";
	String attach_file_path4 = "";
	String requ_tel_numb     = userInfoDto.getMobile();
	
	String adde_file_res1        = "";
	String adde_file_res2        = "";
	String adde_file_res3        = "";
	String adde_file_res4        = "";
	String res_attach_file_name1 = "";
	String res_attach_file_name2 = "";
	String res_attach_file_name3 = "";
	String res_attach_file_name4 = "";
	String res_attach_file_path1 = "";
	String res_attach_file_path2 = "";
	String res_attach_file_path3 = "";
	String res_attach_file_path4 = "";
	String res_req_message		 = "";
	

	if(merequDto != null) {
		title             = merequDto.getTitle();
		requ_Stat_Flag    = merequDto.getRequ_Stat_Flag();
		message           = merequDto.getMessage();
		requ_User_Numb    = merequDto.getRequ_User_Numb();
		no                = merequDto.getNo();
		stat_Flag_Code    = merequDto.getStat_Flag_Code();
		file_list1        = CommonUtils.getString(merequDto.getFile_List1());
		file_list2        = CommonUtils.getString(merequDto.getFile_List2());
		file_list3        = CommonUtils.getString(merequDto.getFile_List3());
		file_list4        = CommonUtils.getString(merequDto.getFile_List4());
		attach_file_name1 = CommonUtils.getString(merequDto.getAttach_file_name1());
		attach_file_name2 = CommonUtils.getString(merequDto.getAttach_file_name2());
		attach_file_name3 = CommonUtils.getString(merequDto.getAttach_file_name3());
		attach_file_name4 = CommonUtils.getString(merequDto.getAttach_file_name4());
		attach_file_path1 = CommonUtils.getString(merequDto.getAttach_file_path1());
		attach_file_path2 = CommonUtils.getString(merequDto.getAttach_file_path2());
		attach_file_path3 = CommonUtils.getString(merequDto.getAttach_file_path3());
		attach_file_path4 = CommonUtils.getString(merequDto.getAttach_file_path4());
		requ_tel_numb     = CommonUtils.getString(merequDto.getRequ_tel_numb());
		
        adde_file_res1        = CommonUtils.getString(merequDto.getAdde_File_res1());
        adde_file_res2        = CommonUtils.getString(merequDto.getAdde_File_res2());
        adde_file_res3        = CommonUtils.getString(merequDto.getAdde_File_res3());
        adde_file_res4        = CommonUtils.getString(merequDto.getAdde_File_res4());
		res_attach_file_name1 = CommonUtils.getString(merequDto.getRes_attach_file_name1());
		res_attach_file_name2 = CommonUtils.getString(merequDto.getRes_attach_file_name2());
		res_attach_file_name3 = CommonUtils.getString(merequDto.getRes_attach_file_name3());
		res_attach_file_name4 = CommonUtils.getString(merequDto.getRes_attach_file_name4());
		res_attach_file_path1 = CommonUtils.getString(merequDto.getRes_attach_file_path1());
		res_attach_file_path2 = CommonUtils.getString(merequDto.getRes_attach_file_path2());
		res_attach_file_path3 = CommonUtils.getString(merequDto.getRes_attach_file_path3());
		res_attach_file_path4 = CommonUtils.getString(merequDto.getRes_attach_file_path4());
		res_req_message		  = CommonUtils.getString(merequDto.getReq_Message());
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<%
/**------------------------------------사용방법---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
------------------------------------------------------------------------------*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#file_list1").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#file_list2").val(), "fnCallBackAttach2"); });
	$("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#file_list3").val(), "fnCallBackAttach3"); });
	$("#btnAttach4").click(function(){ fnUploadDialog("첨부파일4", $("#file_list4").val(), "fnCallBackAttach4"); });
	$("#btnAttachDel1").click(function(){ fnAttachDel('file_list1'); });
	$("#btnAttachDel2").click(function(){ fnAttachDel('file_list2'); });
	$("#btnAttachDel3").click(function(){ fnAttachDel('file_list3'); });
	$("#btnAttachDel4").click(function(){ fnAttachDel('file_list4'); });
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
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list3").val(rtn_attach_seq);
	$("#attach_file_name3").text(rtn_attach_file_name);
	$("#attach_file_path3").val(rtn_attach_file_path);
}
/**
 * 첨부파일4 파일관리
 */
function fnCallBackAttach4(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list4").val(rtn_attach_seq);
	$("#attach_file_name4").text(rtn_attach_file_name);
	$("#attach_file_path4").val(rtn_attach_file_path);
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
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};


function fnAttachDel(columnName) {
	if(columnName=='file_list1') {
		$("#file_list1").val('');
		$("#attach_file_name1").text('');
		$("#attach_file_path1").val('');
	} else if(columnName=='file_list2') {
		$("#file_list2").val('');
		$("#attach_file_name2").text('');
		$("#attach_file_path2").val('');
	} else if(columnName=='file_list3') {
		$("#file_list3").val('');
		$("#attach_file_name3").text('');
		$("#attach_file_path3").val('');
	} else if(columnName=='file_list4') {
		$("#file_list4").val('');
		$("#attach_file_name4").text('');
		$("#attach_file_path4").val('');
	} 
}
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
    $("#regButton").click( function(){ saveContent(); });
    $("#closeButton").click( function() { fnClose(); });

    nhn.husky.EZCreator.createInIFrame({
		 oAppRef: oEditors,
		 elPlaceHolder: "message",
		 sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
	});
});

function fnClose(){ 
// 	window.opener.fnReloadGrid();
	window.close();
}

</script>
</head>
<body>
<form id="frm" name="frm" method="post" onsubmit="return false;">
<input type="hidden" name="oper" id="oper" value="<%=!"".equals(no) ? "edit" : "add"%>" /> 
<input type="hidden" name="no" id="no" value="<%=no %>" />
<input type="hidden" name="requ_User_Numb" id="requ_User_Numb" value="<%=requ_User_Numb %>" />
<input type="hidden" name="stat_Flag_Code" id="stat_Flag_Code" value="<%=stat_Flag_Code %>" />
<input type="hidden" name="deli_Area_Code" id="deli_Area_Code" value="<%=deli_Area_Code %>" />
<input type="hidden" name="replayFlag" id="replayFlag" value="<%=replayFlag %>" />
<input type="hidden" name="modi_User_Numb" id="modi_User_Numb" value="<%=modi_User_Numb %>" />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>
						<%=("Y".equals(replayFlag)) ? "답변 정보" : "고객의소리" %>
					</td>
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
					<td class="table_td_subject" style="width:60px;">요청명</td>
					<td colspan="3" class="table_td_contents">
						<input type="text" id="title" name="title" class="input" style="width:98%" value="<%=title %>" <%=("Y".equals(replayFlag)) ? "disabled" : "" %> />	
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td style="width:60px;" class="table_td_subject">유형</td>
					<td class="table_td_contents" <%if("Y".equals(replayFlag)){ %> colspan="3" <%} %>>
							<select name="requ_Stat_Flag" id="requ_Stat_Flag"  <%=("Y".equals(replayFlag)) ? "disabled" : "" %> > 
								<option value="1" <%=requ_Stat_Flag.equals("1")? "selected" : "" %> >가격</option>
								<option value="2" <%=requ_Stat_Flag.equals("2")? "selected" : "" %> >품질</option>
								<option value="3" <%=requ_Stat_Flag.equals("3")? "selected" : "" %> >납기</option>
								<option value="4" <%=requ_Stat_Flag.equals("4")? "selected" : "" %> >시스템</option>
								<option value="5" <%=requ_Stat_Flag.equals("5")? "selected" : "" %> >기타</option>
							</select>
					</td>
<%
	if("Y".equals(replayFlag) == false){
%> 
					<td style="width:60px;" class="table_td_subject">연락처</td>
					<td class="table_td_contents">
						<input type="text" id="requ_tel_numb" name="requ_tel_numb" value="<%=requ_tel_numb %>"/>
					</td>
<%
	}
%>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td style="width:60px;" class="table_td_subject">
						<%=("Y".equals(replayFlag)) ? "답변 첨부파일1" : "첨부파일1" %>
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list1" name="file_list1" value="<%=("Y".equals(replayFlag)) ? replayMod ? adde_file_res1 :"" : file_list2 %>"/>
						<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=("Y".equals(replayFlag) ) ? replayMod ? res_attach_file_path1 : "" : attach_file_path1 %>"/>
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path1').val()).replace(/\\/g,'\\\\'));">
						<span id="attach_file_name1"><%=("Y".equals(replayFlag)) ? replayMod ? res_attach_file_name1 : "" : attach_file_name1 %></span>
						</a>				
						<div style="float:right">		
						<button id="btnAttach1" type="button" class="btn btn-darkgray btn-xs">등록</button>
						<button id="btnAttachDel1" type="button" class="btn btn-default btn-xs">삭제</button>
						</div>
					</td>
					<td style="width:60px;" class="table_td_subject">
						<%=("Y".equals(replayFlag)) ? "답변 첨부파일2" : "첨부파일2" %>
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list2" name="file_list2" value="<%=("Y".equals(replayFlag)) ? replayMod ? adde_file_res2 :"" : file_list2 %>"/>
						<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=("Y".equals(replayFlag)) ? replayMod ? res_attach_file_path2 :"" : attach_file_path2 %>"/>
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path2').val()).replace(/\\/g,'\\\\'));">
						<span id="attach_file_name2"><%=("Y".equals(replayFlag)) ? replayMod ? res_attach_file_name2 :"" : attach_file_name2 %></span>
						</a>						
						<div style="float:right">
						<button id="btnAttach2" type="button" class="btn btn-darkgray btn-xs">등록</button>
						<button id="btnAttachDel2" type="button" class="btn btn-default btn-xs">삭제</button>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td style="width:60px;" class="table_td_subject">
						<%=("Y".equals(replayFlag)) ? "답변 첨부파일3" : "첨부파일3" %>
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list3" name="file_list3" value="<%=("Y".equals(replayFlag)) ? replayMod ? adde_file_res3 :"" : file_list3 %>"/>
						<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=("Y".equals(replayFlag)) ? replayMod ? res_attach_file_path3 :"" : attach_file_path3 %>"/>
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path3').val()).replace(/\\/g,'\\\\'));">
						<span id="attach_file_name3"><%=("Y".equals(replayFlag)) ? replayMod ? res_attach_file_name3 :"" : attach_file_name3 %></span>
						</a>						
						<div style="float:right">
						<button id="btnAttach3" type="button" class="btn btn-darkgray btn-xs">등록</button>
						<button id="btnAttachDel3" type="button" class="btn btn-default btn-xs">삭제</button>
						</div>
					</td>
					<td style="width:60px;" class="table_td_subject">
						<%=("Y".equals(replayFlag)) ? "답변 첨부파일4" : "첨부파일4" %>
					</td>
					<td width="50%" class="table_td_contents">
						<input type="hidden" id="file_list4" name="file_list4" value="<%=("Y".equals(replayFlag)) ? replayMod ? adde_file_res4 :"" : file_list4 %>"/>
						<input type="hidden" id="attach_file_path4" name="attach_file_path4" value="<%=("Y".equals(replayFlag)) ? replayMod ? res_attach_file_path4 :"" : attach_file_path4 %>"/>
						<a href="javascript:fnAttachFileDownload(($('#attach_file_path4').val()).replace(/\\/g,'\\\\'));">
						<span id="attach_file_name4"><%=("Y".equals(replayFlag)) ? replayMod ? res_attach_file_name4 :"" : attach_file_name4 %></span>
						</a>						
						<div style="float:right">
						<button id="btnAttach4" type="button" class="btn btn-darkgray btn-xs">등록</button>
						<button id="btnAttachDel4" type="button" class="btn btn-default btn-xs">삭제</button>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" style="width:60px;">
						<%=("Y".equals(replayFlag)) ? "답변내역" : "요청내역" %>
					</td>
					<td colspan="3" height="250" valign="top" class="table_td_contents4">
						<textarea id="message" name="message" required title="내용" style="min-width:450px;height:320px;display:none"><%=("Y".equals(replayFlag)) ? replayMod ? res_req_message :"" : message %></textarea>
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
			<button id="regButton" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-save"></i> 저장</button>
			<button id="closeButton" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
		</td>
	</tr>
</table>
</form>
<script type="text/javascript">
var oEditors = [];
function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
} 

function saveContent() {
	oEditors.getById["message"].exec("UPDATE_CONTENTS_FIELD", []);
	var title          = $("#title").val();
	var message        = $("#message").val();
	var oper           = $("#oper").val();
	var requ_Stat_Flag = $("#requ_Stat_Flag").val();
	var requ_User_Numb = $("#requ_User_Numb").val();
	var modi_User_Numb = $("#modi_User_Numb").val();
	var file_list1     = $("#file_list1").val();
	var file_list2     = $("#file_list2").val();
	var file_list3     = $("#file_list3").val();
	var file_list4     = $("#file_list4").val();
	var no             = $("#no").val();
	var requ_tel_numb  = $("#requ_tel_numb").val();
	
	if(title == ""){
		alert("요청명을 입력해 주십시오.");
		return;
	}
	
	if( ! message || message == '<p>&nbsp;</p>'){
		alert("요청내역을 입력하여 주시기 바랍니다.");
		return;
	}	
	
	if(!confirm("내용을 저장하시겠습니까?")){
		return;
	}
	
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/board/requestManageTransGrid.sys",
		{
			title      : title,      message        : message,        oper          : oper,         requ_Stat_Flag : requ_Stat_Flag, requ_User_Numb : requ_User_Numb,
			file_list1 : file_list1, file_list2     : file_list2,     file_list3    : file_list3,   file_list4     : file_list4,     replayFlag     : $("#replayFlag").val(),
			no         : no,         modi_User_Numb : modi_User_Numb, requ_tel_numb : requ_tel_numb
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			var errors = "";
			if (result.success == false) {
				for (var i = 0; i < result.message.length; i++) {
					errors +=  result.message[i] + "<br/>";
				}
				alert(errors);
			} else {
				alert("처리 하였습니다.");
				
				try{
					window.opener.fnReloadGrid();	
				}
				catch(e){}
				
				fnClose();
			}
		}
	);
}
</script>

<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
</body>
</html>