<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.Map" %>
<%
String PRODEVALSTATE = null;
if (request.getAttribute("part") != null) {
	PRODEVALSTATE = (String) ((Map)request.getAttribute("part")).get("PRODEVALSTATE");
}
%>
<table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			<tr>
				<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
				<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
				<td class="popup_title">
					제품 평가
				</td>
				<td width="22" align="right">
                    <a href="#" class="jqmClose">
                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" />
                    </a>
                </td>
                <td width="10" img id="popup_titlebar_right1" src="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
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
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">품목명</td>
                            <td class="table_td_contents4" width="120">${part.ITEMNM}</td>
                            <td class="table_td_subject" width="60">품목유형</td>
                            <td class="table_td_contents4">${part.ITEMTYPE1},${part.ITEMTYPE2}${not empty part.ITEMTYPE3?',':''}${part.ITEMTYPE3}</td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">업체명</td>
                            <td class="table_td_contents4" width="120">${part.VENDORNM}</td>
                            <td class="table_td_subject" width="60">영업담당자</td>
                            <td class="table_td_contents4">${part.BUSICHARGER} (Tel: ${part.BUSIPHONENUM}, Email: ${part.BUSICHARGEREMAIL})</td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table>
                    <br/>
                    <form id="frmSave">
                    <input type="hidden" name="oper" value="edit"/>
                    <input type="hidden" name="applId" value="${part.APPLID}"/>
                    <input type="hidden" name="prodEvalState" value="${part.PRODEVALSTATE eq '0' ? '1' : part.PRODEVALSTATE}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="6" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9">평가일정</td>
                            <td class="table_td_contents4" colspan=2>
                                <input type="text" name="evalStartDate" id="evalStartDate" value="${part.EVALSTARTDATE}" required title="평가일정시작일" readonly style="width:80px;text-align:center" maxlength="10"/>~
                                <input type="text" name="evalEndDate" id="evalEndDate" value="${part.EVALENDDATE}" required title="평가일정종료일" readonly style="width:80px;text-align:center" maxlength="10"/>
                                
                            </td>
                            <td class="table_td_subject9">평가장소</td>
                            <td class="table_td_contents4" colspan=2>
                                <input type="text" name="evalLocation" value="${part.EVALLOCATION}" required title="평가장소" style="width:200px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="100">시험항목수</td>
                            <td class="table_td_contents4" width="150">
                                <input type="text" id="testArticle" name="testArticle" value="${part.TESTARTICLE}" requiredNumber title="시험항목수" style="width:80px" maxlength="3"/>
                            </td>
                            <td class="table_td_subject9" width="100">PASS수</td>
                            <td class="table_td_contents4" width="150">
                                <input type="text" id="pass" name="pass" value="${part.PASS}" requiredNumber title="PASS수" style="width:80px" maxlength="3"/>
                            </td>
                            <td class="table_td_subject9" width="100">FAIL수</td>
                            <td class="table_td_contents4" width="150">
                                <input type="text" id="fail" name="fail" value="${part.FAIL}" requiredNumber title="FAIL수" style="width:80px" maxlength="3"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="table_top_line"></td>
                        </tr>
                    </table>
                    <br/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">시험성적서</td>
                            <td class="table_td_contents4" colspan=3>
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" ${empty part.TESTRESULTATTACHSEQ ? '':'style="display:none"'}>등록</button>
                                <input type="hidden" id="testResultAttachSeq" name="testResultAttachSeq" value="${part.TESTRESULTATTACHSEQ}" class="attachFileSeq" title="시험성적서"/>
                                <input type="hidden" id="testResultAttachPath" name="testResultAttachPath" value="${part.TESTRESULTATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#testResultAttachPath').val());">
                                <span id="testResultAttachName" class="attachFileName">${part.TESTRESULTATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.TESTRESULTATTACHSEQ ? 'style="display:none"':''}>삭제</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">시험보고서</td>
                            <td class="table_td_contents4" colspan=3>
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" ${empty part.TESTREPORTATTACHSEQ ? '':'style="display:none"'}>등록</button>
                                <input type="hidden" id="testReportAttachSeq" name="testReportAttachSeq" value="${part.TESTREPORTATTACHSEQ}" class="attachFileSeq" title="시험보고서"/>
                                <input type="hidden" id="testReportAttachPath" name="testReportAttachPath" value="${part.TESTREPORTATTACHPATH}" class="attachFilePath" />
                                <a href="javascript:fnAttachFileDownload($('#testReportAttachPath').val());">
                                <span id="testReportAttachName" class="attachFileName">${part.TESTREPORTATTACHNAME}</span>
                                </a>
                                <button type="button" class="btn btn-primary btn-xs btnDelFile" ${empty part.TESTREPORTATTACHSEQ ? 'style="display:none"':''}>삭제</button>
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
                            <% if (PRODEVALSTATE != null && (PRODEVALSTATE.equals("0") || PRODEVALSTATE.equals("1"))) { %>
                            <button id="btnSave" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 평가</button>
                            <% } %>
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
<%@ include file="/WEB-INF/jsp/evaluation/attachFileDiv.jsp" %>
<script type="text/javascript">
var fileTD;
$(function() {
	fnDateInit();
	$("#evaluatePop800").jqDrag('#userDialogHandle');
    $('.btnRegFile').click(function() {
        fileTD = $(this).closest('td');
        var attachFileSeq = fileTD.find('.attachFileSeq');
        var title= attachFileSeq.attr('title') + " 첨부";
        fnUploadDialog(title, attachFileSeq.val(), "fnCallBack"); 
    });
    $('.btnDelFile').click(function() {
        var file = $(this).closest('td');
        file.find('.attachFileSeq').val('');
        file.find('.attachFilePath').val('');
        file.find('.attachFileName').html(''); 
        file.find('.helptext').show();
        file.find('.btnRegFile').show();
        $(this).hide();
    });
    $('#btnSave').click(function (e) {
        if (!$("#frmSave").validate()) {
            return;
        }
        var test = parseInt($('#testArticle').val(), 10);
        var pass = parseInt($('#pass').val(), 10);
        var fail = parseInt($('#fail').val(), 10);
        if (test != pass + fail) {
        	alert('시험항목수는 PASS수와 FAIL수의 합이 같아야 합니다.\n다시 입력해주세요.');
        	return;
        }
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/updatePartApplForProd/save.sys', $('#frmSave').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  subGrid.trigger("reloadGrid");
                  $('#evaluatePop800').html('');
                  $('#evaluatePop800').jqmHide();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
	$('.jqmClose').click(function (e) {
        $('#evaluatePop800').html('');
		$('#evaluatePop800').jqmHide();
	});
});
//날짜 데이터 초기화 
function fnDateInit() {
    $("#evalStartDate,#evalEndDate").datepicker(
        {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        }
    );
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}
// 파일 첨부 
function fnCallBack(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
    fileTD.find('.attachFileSeq').val(rtn_attach_seq);
    fileTD.find('.attachFilePath').val(rtn_attach_file_path);
    fileTD.find('.attachFileName').text(rtn_attach_file_name);
    fileTD.find('.btnRegFile').hide();
    fileTD.find('.btnDelFile').show();
}
// 파일다운로드
function fnAttachFileDownload(attach_file_path) {
    var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
    var data = "attachFilePath="+attach_file_path;
    $.download(url,data,'post');
}
jQuery.download = function(url, data, method) {
    // url과 data를 입력받음
    if( url && data ) {
        // data 는 string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의 input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function() {
            var pair = new Array();
            pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />';
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
</script>