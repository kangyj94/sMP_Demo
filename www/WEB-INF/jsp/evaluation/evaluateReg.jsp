<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.Map" %>
<%
LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
String tomorrow = CommonUtils.getCustomDay("DAY", 1);
if (request.getAttribute("item") != null) {
	tomorrow = (String) ((Map)request.getAttribute("item")).get("DEADLINEDATE"); 
}
%>
<table width="600" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			<tr>
				<td width="21" style="background-color: #ea002c; height: 47px;"></td>
				<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
					<h2>대표상품 등록</h2>
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
                    <form id="frmSave">
                    <input type="hidden" name="oper" value="${empty item ? 'add':'edit'}"/>
                    <input type="hidden" name="idGenSvcNm" value="seqItem"/>
                    <input type="hidden" name="itemId" value="${item.ITEMID}"/>
                    <input type="hidden" name="itemState" value="10"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="2" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="110">품목명1</td>
                            <td class="table_td_contents4">
                                <input type="text" id="itemNm1" name="itemNm1" value="${item.ITEMNM1}" required title="품목명1" style="width: 225px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="110">품목명2</td>
                            <td class="table_td_contents4">
                                <input type="text" id="itemNm2" name="itemNm2" value="${item.ITEMNM2}" required title="품목명2" style="width: 225px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr><td colspan="2" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject9" width="110">연간규모</td>
                            <td class="table_td_contents4">
                                <input type="text" id="yearlySize" name="yearlySize" value="${item.YEARLYSIZE}" requiredNumber title="연간규모" style="width: 106px" maxlength="30"/> 원
                            </td>
                        </tr>
                        <tr><td colspan="2" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject9" width="110">신청마감일</td>
                            <td class="table_td_contents4">
                                <input type="text" name="deadlineDate" id="deadlineDate" value="<%=tomorrow%>" required title="신청마감일" readonly style="width:80px;text-align:center" maxlength="10"/>
                            </td>
                        </tr>
                        <tr><td colspan="2" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject9" width="110">품목유형</td>
                            <td class="table_td_contents4">
		                        <select name="itemType1" id="itemType1" required title="품목유형1"><option value="">유형1</option></select>
		                        <select name="itemType2" id="itemType2" required title="품목유형2"><option value="">유형2</option></select>
		                        <select name="itemType3" id="itemType3"><option value="">유형3</option></select>
                            </td>
                        </tr>
                        <tr><td colspan="2" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject9" width="110">안내서&nbsp;&nbsp;<button id="btnGuidebook" type="button" class="btn btn-primary btn-xs">등록</button></td>
                            <td class="table_td_contents4">
		                        <input type="hidden" id="guidebookAttachFileSeq" name="guidebookAttachFileSeq" value="${item.GUIDEBOOKATTACHFILESEQ}" required title="안내서"/>
		                        <input type="hidden" id="guidebookAttachFilePath" name="guidebookAttachFilePath" value="${item.GUIDEBOOKATTACHFILE_PATH}" />
		                        <a href="javascript:fnAttachFileDownload($('#guidebookAttachFilePath').val());">
		                        <span id="guidebookAttachFileName">${item.GUIDEBOOKATTACHFILE}</span>
		                        </a>
                            </td>
                        </tr>
                        <tr><td colspan="2" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject" width="110">규격서&nbsp;&nbsp;<button id="btnSpecs" type="button" class="btn btn-primary btn-xs">등록</button></td>
                            <td class="table_td_contents4">
                                <input type="hidden" id="specsAttachFileSeq" name="specsAttachFileSeq" value="${item.SPECSATTACHFILESEQ}" title="규격서" />
                                <input type="hidden" id="specsAttachFilePath" name="specsAttachFilePath" value="${item.SPECSATTACHFILE_PATH}" />
                                <a href="javascript:fnAttachFileDownload($('#specsAttachFilePath').val());">
                                <span id="specsAttachFileName">${item.SPECSATTACHFILE}</span>
                                </a>
                            </td>
                        </tr>
                        <tr><td colspan="2" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject" width="110">담당자</td>
                            <td class="table_td_contents4"><%=userDto.getUserNm()%></td>
                        </tr>
                        <tr>
                            <td colspan="2" class="table_top_line"></td>
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
<%@ include file="/WEB-INF/jsp/evaluation/attachFileDiv.jsp" %>
<script type="text/javascript">
$(function() {
    $("#evaluatePop").jqDrag('#userDialogHandle');
    fnDataInit();
    fnDateInit();
    $('#btnGuidebook').click(function() { 
    	fnUploadDialog("안내서 파일 첨부", $("#guidebookAttachFileSeq").val(), "fnCallBackGuidebook"); 
    });
    $('#btnSpecs').click(function() { 
        fnUploadDialog("규격서 파일 첨부", $("#specsAttachFileSeq").val(), "fnCallBackSpecs"); 
    });
    $('#btnSave').click(function (e) {
        if (!$("#frmSave").validate()) {
            return;
        }
        if (!confirm("등록 처리하시겠습니까?\n이후에 수정/삭제할 수 없습니다.")) return;
    	$.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/${empty item ? 'insertItem':'updateItem'}/save.sys', $('#frmSave').serialize(),
	        function(msg) {
    		  var m = eval('(' + msg + ')');
    		  if (m.customResponse.success) {
    			  fnSearch();
    			  $('#evaluatePop').html('');
    		      $('#evaluatePop').jqmHide();
    		  } else {
    			  alert('저장 중 오류가 발생했습니다.');
    		  }
	        }
	    );  
    });
	$('.jqmClose').click(function (e) {
        $('#evaluatePop').html('');
		$('#evaluatePop').jqmHide();
	});
});
//코드 데이터 초기화 
function fnDataInit(){
     $.post(  //조회조건의 품목유형1 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPITEM_ITEMTYPE1",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#itemType1").append("<option value='"+codeList[i].codeVal1+"'" + (codeList[i].codeVal1 == '${item.ITEMTYPE1}' ? ' selected':'') + ">"+codeList[i].codeNm1+"</option>");
             }
         }
     );  
     $.post(  //조회조건의 품목유형2 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPITEM_ITEMTYPE2",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#itemType2").append("<option value='"+codeList[i].codeVal1+"'" + (codeList[i].codeVal1 == '${item.ITEMTYPE2}' ? ' selected':'') + ">"+codeList[i].codeNm1+"</option>");
             }
         }
     );  
     $.post(  //조회조건의 품목유형3 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPITEM_ITEMTYPE3",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#itemType3").append("<option value='"+codeList[i].codeVal1+"'" + (codeList[i].codeVal1 == '${item.ITEMTYPE3}' ? ' selected':'') + ">"+codeList[i].codeNm1+"</option>");
             }
         }
     );
}
//날짜 데이터 초기화 
function fnDateInit() {
    $("#deadlineDate").datepicker(
        {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        }
    );
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}
// 안내서 파일 첨부 
function fnCallBackGuidebook(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
    $("#guidebookAttachFileSeq").val(rtn_attach_seq);
    $("#guidebookAttachFileName").text(rtn_attach_file_name);
    $("#guidebookAttachFilePath").val(rtn_attach_file_path);
}
// 규격서 파일 첨부 
function fnCallBackSpecs(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
    $("#specsAttachFileSeq").val(rtn_attach_seq);
    $("#specsAttachFileName").text(rtn_attach_file_name);
    $("#specsAttachFilePath").val(rtn_attach_file_path);
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