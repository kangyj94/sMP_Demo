<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
List<Map> attachList = ((List)request.getAttribute("attach"));
String LASTEVALSTATE = null;
if (request.getAttribute("part") != null) {
	LASTEVALSTATE = (String) ((Map)request.getAttribute("part")).get("LASTEVALSTATE");
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
					최종 평가
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
                    <form id="frmEval">
                    <input type="hidden" name="oper" value="edit"/>
                    <input type="hidden" name="applId" value="${part.APPLID}"/>
                    <input type="hidden" name="lastEvalState" value="${part.LASTEVALSTATE eq '0' ? '1' : part.LASTEVALSTATE}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="80">품목명</td>
                            <td class="table_td_contents4" width="120">${part.ITEMNM}</td>
                            <td class="table_td_subject" width="80">품목유형</td>
                            <td class="table_td_contents4">${part.ITEMTYPE1},${part.ITEMTYPE2}${not empty part.ITEMTYPE3?',':''}${part.ITEMTYPE3}</td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="80">업체명</td>
                            <td class="table_td_contents4" width="120">${part.VENDORNM}</td>
                            <td class="table_td_subject" width="80">영업담당자</td>
                            <td class="table_td_contents4">${part.BUSICHARGER} (Tel: ${part.BUSIPHONENUM}, Email: ${part.BUSICHARGEREMAIL})</td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="80">최종평가</td>
                            <td class="table_td_contents4" colspan=3>
                                <select id="lastEval" name="lastEval" required title="최종평가">
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="80">평가근거</td>
                            <td class="table_td_contents4" colspan=3>
                                <textarea name="evalBasis" style="width:80%;height:40px">${part.EVALBASIS}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="80">
                                <button type="button" class="btn btn-primary btn-xs btnRegFile" style="position:absolute;margin-left:55px;margin-top:-6px">등록</button>
                                                                          증빙자료
                            </td>
                            <td id="attachFileList" class="table_td_contents4" colspan=3>
                                
                                <% for (Map data : attachList) { %>
                                <div class="attachFile">
                                    <input type="hidden" name="attachFileSeq" value="<%=data.get("ATTACHSEQ")%>" class="attachFileSeq"/>
                                    <input type="hidden" name="attachFilePath" value="<%=data.get("ATTACHPATH")%>" class="attachFilePath" />
                                    <a href="#" onclick="fnAttachFileDownload($(this).prev().val());">
                                        <span class="attachFileName"><%=data.get("ATTACHNAME")%></span>
                                    </a>
                                    <button type="button" class="btn btn-primary btn-xs" onclick="fnDel(this);">삭제</button>
                                </div>
                                <% } %>
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
                            <td colspan="6" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" style="padding-top:2px;padding-bottom:2px" colspan=2> 
                                                                          업체평가&nbsp;&nbsp;<button id="bizButton" type="button" class="btn btn-primary btn-xs" style="vertical-align:1px">내역확인</button>
                            </td>
                            <td class="table_td_subject" style="padding-top:2px;padding-bottom:2px" colspan=2>
                                                                          품질평가&nbsp;&nbsp;<button id="qcButton" type="button" class="btn btn-primary btn-xs" style="vertical-align:1px">내역확인</button>
                            </td>
                            <td class="table_td_subject" style="padding-top:2px;padding-bottom:2px">
                                                                          제품평가&nbsp;&nbsp;<button id="prodButton" type="button" class="btn btn-primary btn-xs" style="vertical-align:1px">내역확인</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
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
                            <td class="table_td_contents4" style="text-align:center">
                               ${part.PASS} 개 PASS / 총 ${part.TESTARTICLE} 개
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="table_top_line"></td>
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
                                <input name="last1ApprvNm" class="userNm" type="text" value="${part.LAST1APPRVNM}" size="14" maxlength="30" style="background-color:#eaeaea;text-align:center">
                                <input name="last1ApprvId" class="userId" type="hidden" value="${part.LAST1APPRVID}"/>
                                <button type="button" class="btnUser btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-search fa-sm"></i></button>
                                <button type="button" class="btnDel btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-times fa-sm"></i></button>                               
                            </td>
                            <td class="table_td_subject" width="120" rowspan=3>
                                Comment
                            </td>
                            <td class="table_td_contents4" width="218" rowspan=3>
                                ${part.LAST1APPRVCOMMENT}
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
                                ${part.LAST1APPRVSTATENM}
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
                                <input name="last2ApprvNm" class="userNm" type="text" value="${part.LAST2APPRVNM}" size="14" maxlength="30" style="background-color:#eaeaea;text-align:center">
                                <input name="last2ApprvId" class="userId" type="hidden" value="${part.LAST2APPRVID}"/>
                                <button type="button" class="btnUser btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-search fa-sm"></i></button>
                                <button type="button" class="btnDel btn btn-default btn-sm" style="padding:3.5px 4px"><i class="fa fa-times fa-sm"></i></button>
                            </td>
                            <td class="table_td_subject" width="120" rowspan=3>
                                Comment
                            </td>
                            <td class="table_td_contents4" width="218" rowspan=3>
                                ${part.LAST2APPRVCOMMENT}
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
                                ${part.LAST2APPRVSTATENM}
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
                            <% if (LASTEVALSTATE != null && (LASTEVALSTATE.equals("0") || LASTEVALSTATE.equals("2"))) { %>
                            <button id="btnEval" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 평가</button>
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
    $('#prodButton').click(function (e) {
        $('#evaluatePop800').html('')
        .load('/evaluation/evaluateProd.sys?applId=${part.APPLID}')
        .jqmShow();
    });
    $('.btnRegFile').click(function() {
        fileTD = $('<div class="attachFile">' + 
		         '<input type="hidden" name="attachFileSeq" class="attachFileSeq"/>' + 
		         '   <input type="hidden" name="attachFilePath" class="attachFilePath" />' + 
		         '   <a href="#" onclick="fnAttachFileDownload($(this).prev().val());">' + 
		         '       <span class="attachFileName">ffffffffff</span>' + 
		         '   </a>' + 
		         '   <button type="button" class="btn btn-primary btn-xs" onclick="fnDel(this);">삭제</button>' + 
		         '</div>');
        var title= "증빙자료 첨부";
        fnUploadDialog(title, null, "fnCallBack"); 
    });
    $(".btnUser").click(function(){
        userTD = $(this).closest('td');
        var userNm = userTD.find('.userNm').val();
        var loginId = "";
        var svcTypeCd = "ADM";
        fnJqmUserInitSearch(userNm, loginId, svcTypeCd, "fnSelectUserCallback");
    });
    $(".userNm").keydown(function(e) { if(e.keyCode==13) { $(this).closest('td').find('.btnUser').click(); } });
    $(".userNm").change(function(e) {
        if($(this).val()=="") {
            $(this).closest('td').find('.userId').val("");
        }
    });
    $(".btnDel").click(function(){
        $(this).closest('td').find('input').val('');
    });
    $('#btnEval').click(function (e) {
        if (!$("#frmEval").validate()) {
            return;
        }
        if (!confirm("최종평가를 처리하시겠습니까?\n이후에 수정할 수 없습니다.")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/updateEvaluateLast.sys', $('#frmEval').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  subGrid.trigger("reloadGrid");
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
                 $("#lastEval").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
             }
             $("#lastEval").val('${part.LASTEVAL}');
         }
     );  
}
var userTD;
// 사용자검색 Callback Function
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
    userTD.find('.userNm').val(userNm);
    userTD.find('.userId').val(userId);
}
function fnDel(obj) {
	$(obj).closest('div').remove();
}
// 파일 첨부 
function fnCallBack(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$('#attachFileList').append(fileTD);
	fileTD.find('.attachFileSeq').val(rtn_attach_seq);
    fileTD.find('.attachFilePath').val(rtn_attach_file_path);
    fileTD.find('.attachFileName').text(rtn_attach_file_name);
    
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
</script>