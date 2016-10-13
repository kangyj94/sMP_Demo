<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.Map" %>
<%
String MIDDLEEVALSTATE = null;
if (request.getAttribute("part") != null) {
    MIDDLEEVALSTATE = (String) ((Map)request.getAttribute("part")).get("MIDDLEEVALSTATE");
}
%>
<table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			<tr>
				<td width="21" style="background-color: #ea002c; height: 47px;"></td>
				<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
					<h2>중간평가</h2>
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
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="60">중간평가</td>
                            <td class="table_td_contents4" colspan=3>
                                <select id="middleEval" name="middleEval" required title="중간평가" disabled>
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table>
                    <!-- 타이틀 시작 -->
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top">
                            <td width="20" valign="middle">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                            </td>
                            <td height="29" class='ptitle'>평가종합</td>
                        </tr>
                    </table>    
                    <!-- 타이틀 끝 -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" style="padding-top:2px;padding-bottom:2px" colspan=2> 
                                                                          업체평가&nbsp;&nbsp;<button id="bizButton" type="button" class="btn btn-primary btn-xs" style="vertical-align:1px">내역확인</button>
                            </td>
                            <td class="table_td_subject" style="padding-top:2px;padding-bottom:2px" colspan=2>
                                                                          품질평가&nbsp;&nbsp;<button id="qcButton" type="button" class="btn btn-primary btn-xs" style="vertical-align:1px">내역확인</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_contents4" style="text-align:center">
                                ${part.BUSIEVALSCORE} 점 / 70 점
                            </td>
                            <td class="table_td_contents4" style="text-align:center">
                                ${part.BUSIRANK} 등 / ${part.APPLCNT} 개 업체
                            </td>
                            <td class="table_td_contents4" style="text-align:center">
                               ${part.QUALITYEVALSCORE} 점 / 30 점
                            </td>
                            <td class="table_td_contents4" style="text-align:center">
                                ${part.QUALITYRANK} 등 / ${part.APPLCNT} 개 업체
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table>
                    <!-- 타이틀 시작 -->
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top">
                            <td width="20" valign="middle">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                            </td>
                            <td height="29" class='ptitle'>결재</td>
                        </tr>
                    </table>    
                    <!-- 타이틀 끝 -->
                    <form id="frmEval">
                    <input type="hidden" name="oper" value="edit"/>
                    <input type="hidden" name="applId" value="${part.APPLID}"/>
                    <input type="hidden" name="apprvCol" value="${part.MIDDLE1APPRVSTATE eq '9' ? 'MIDDLE1':'MIDDLE2'}"/>
                    <input type="hidden" name="isLast" value="${(part.MIDDLE1APPRVSTATE eq '9' and empty part.MIDDLE2APPRVID) or (part.MIDDLE1APPRVSTATE ne '9' and part.MIDDLE2APPRVSTATE eq '9') ? 'Y' : 'N'}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">
                                1차 승인자
                            </td>
                            <td class="table_td_contents4" width="218">
                                <input name="middle1ApprvNm" class="userNm" type="text" value="${part.MIDDLE1APPRVNM}" size="14" maxlength="30" style="background-color:#eaeaea;text-align:center">
                                <input name="middle1ApprvId" class="userId" type="hidden" value="${part.MIDDLE1APPRVID}"/>
                            </td>
                            <td class="table_td_subject" width="120" rowspan=3>
                                Comment
                            </td>
                            <td class="table_td_contents4" width="218" rowspan=3>
                                ${part.MIDDLE1APPRVSTATE eq '9' and part.MIDDLE1APPRVID eq part.USERID ? '<textarea id="apprvComment" name="apprvComment" style="width:100%;height:100%"></textarea>' : part.MIDDLE1APPRVCOMMENT}
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">
                                                                    상태
                            </td>
                            <td class="table_td_contents4" width="218">
                                ${part.MIDDLE1APPRVSTATENM}
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">
                                2차 승인자
                            </td>
                            <td class="table_td_contents4" width="218">
                                <input name="middle2ApprvNm" class="userNm" type="text" value="${part.MIDDLE2APPRVNM}" size="14" maxlength="30" style="background-color:#eaeaea;text-align:center">
                                <input name="middle2ApprvId" class="userId" type="hidden" value="${part.MIDDLE2APPRVID}"/>
                            </td>
                            <td class="table_td_subject" width="120" rowspan=3>
                                Comment
                            </td>
                            <td class="table_td_contents4" width="218" rowspan=3>
                                ${part.MIDDLE1APPRVSTATE ne '9' and part.MIDDLE2APPRVSTATE eq '9' and part.MIDDLE2APPRVID eq part.USERID ? '<textarea id="apprvComment" name="apprvComment" style="width:100%;height:100%"></textarea>' : part.MIDDLE2APPRVCOMMENT}
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="120">
                                                                    상태
                            </td>
                            <td class="table_td_contents4" width="218">
                                ${part.MIDDLE2APPRVSTATENM}
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
                            <% if (MIDDLEEVALSTATE != null && MIDDLEEVALSTATE.equals("9")) { %>
                            <button id="btnApproval" type="button" class="btn btn-success btn-sm"><i class="fa fa-check-square"></i> 승인</button>
                            <button id="btnReturn" type="button" class="btn btn-danger btn-sm"><i class="fa fa-reply"></i> 반려</button>
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
<script type="text/javascript">
$(function() {
    fnDataInit();
	$("#evaluatePop8002").jqDrag('#userDialogHandle');
	$('.jqmClose').click(function (e) {
        $('#evaluatePop8002').html('');
		$('#evaluatePop8002').jqmHide();
	});
	$('#bizButton').click(function (e) {
        $('#evaluatePop800').html('')
        .load('/evaluation/evaluateBusi.sys?applId=${part.APPLID}')
        .jqmShow();
	});
    $('#qcButton').click(function (e) {
        $('#evaluatePop800').html('')
        .load('/evaluation/evaluateQuality.sys?applId=${part.APPLID}')
        .jqmShow();
    });
    $('#btnApproval').click(function (e) {
        if (!confirm("승인 처리하시겠습니까?")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/updatePartApplForMiddleApproval/save.sys', $('#frmEval').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  $('#list').trigger("reloadGrid");
                  $('#evaluatePop8002').html('');
                  $('#evaluatePop8002').jqmHide();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
    $('#btnReturn').click(function (e) {
    	if ($('#apprvComment').val() == '') {
    		alert('코멘트를 입력해주세요.');
    		$('#apprvComment').focus();
    		return;
    	}
        if (!confirm("반려 처리하시겠습니까?")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/updatePartApplForMiddleReturn/save.sys', $('#frmEval').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  $('#list').trigger("reloadGrid");
                  $('#evaluatePop8002').html('');
                  $('#evaluatePop8002').jqmHide();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
});
//코드 데이터 초기화 
function fnDataInit(){
     $.post(  //조회조건의 품목유형1 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"SMPPART_EVAL",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#middleEval").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
             }
             $("#middleEval").val('${part.MIDDLEEVAL}');
         }
     );  
}
var userTD;
// 사용자검색 Callback Function
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	userTD.find('.userNm').val(userNm);
	userTD.find('.userId').val(userId);
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