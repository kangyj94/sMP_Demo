<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%
String periodFrom = CommonUtils.getCurrentDate();
String periodTo = CommonUtils.getCustomDay("MONTH", 1);
%>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<table width="600" border="0" cellspacing="0" cellpadding="0">
					
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
				<tr>
					<td width="21" style="background-color: #ea002c; height: 47px;"></td>
					<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
						<h2>설문조사 ${empty poll ? '등록':'수정'}</h2>
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
                    <form id="frm" name="frm" method="post">
                    <input type="hidden" name="oper" value="${empty poll ? 'add':'edit'}"/>
                    <input type="hidden" name="idGenSvcNm" value="seqPoll"/>
                    <input type="hidden" name="pollId" value="${poll.POLLID}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="60">제목</td>
                            <td class="table_td_contents4" colspan=3>
                                <input type="text" name="subject" value="${poll.SUBJECT}" required title="제목" style="width:450px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="60">유형</td>
                            <td class="table_td_contents4">
                                <select name="type" id="type">
                                    <option value="BUY">고객사</option>
                                    <option value="VEN">공급사</option>                                    
                                </select>
                            </td>
                            <td class="table_td_subject9" width="60">기간</td>
                            <td class="table_td_contents4">
		                        <input type="text" id="periodFrom" name="periodFrom" value="<%=periodFrom%>" required title="기간시작일" style="width:80px;text-align:center" maxlength="10" /> 
		                        ~ 
		                        <input type="text" id="periodTo" name="periodTo" value="<%=periodTo%>" required title="기간종료일" style="width:80px;text-align:center" maxlength="10" />
                            </td>
                        </tr>
                        <tr><td colspan="4" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject9" width="60">팝업크기</td>
                            <td class="table_td_contents4" colspan=3> 
                                                                            가로 / 세로 <input type="text" name="width" value="${poll.WIDTH}" required title="가로" style="width:50px" maxlength="3"/>px / <input type="text" name="height" value="${poll.HEIGHT}" required title="세로" style="width:50px" maxlength="3"/>px
                            </td>
                        </tr>
                        <tr><td colspan="4" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject" width="60">내용</td>
                            <td class="table_td_contents4" colspan=3>
                            <textarea id="content" name="content" required title="내용" style="min-width:450px;height:195px;display:none">${poll.CONTENT}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table> 
                    </form>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="center">
                            <button id="btnSave" type="button" class="btn btn-danger btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
                            <button id="btnClose" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
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
<script type="text/javascript">
$(document).ready(function () {
	var type =   '${poll.TYPE}';
	if ( type=='VEN' ){		$("#type").val("VEN");		}
	else{						$("#type").val("BUY");		}
});

var oEditors = [];
$(function() {
	nhn.husky.EZCreator.createInIFrame({
		 oAppRef: oEditors,
		 elPlaceHolder: "content",
		 sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
	});
    $("#pollPop").jqDrag('#userDialogHandle');
    fnDateInit();
    $('#btnSave').click(function (e) {
    	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
        if (!$("#frm").validate()) {
            return;
        }
        if (!confirm("${empty poll ? '등록':'수정'} 처리하시겠습니까?")) return;
        
        $('#content').val(fnReplaceAll($("#content").val(), unescape("%uFEFF"), ""));
        
        
    	$.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/board/${empty poll ? "insert":"update"}Poll/save.sys', $('#frm').serialize(),
	        function(msg) {
    		  var m = eval('(' + msg + ')');
    		  if (m.customResponse.success) {
    			  fnSearch();
    			  $('#pollPop').html('');
    		      $('#pollPop').jqmHide();
    		  } else {
    			  alert('저장 중 오류가 발생했습니다.');
    		  }
	        }
	    );  
    });
	$('.jqmClose').click(function (e) {
        $('#pollPop').html('');
		$('#pollPop').jqmHide();
	});
	
});

function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
}

//날짜 데이터 초기화 
function fnDateInit() {
    $("#periodFrom").datepicker({
        showOn: "button",
        buttonImage: "/img/system/btn_icon_calendar.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
    });
    $("#periodTo").datepicker({
        showOn: "button",
        buttonImage: "/img/system/btn_icon_calendar.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
    });
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}
</script>
