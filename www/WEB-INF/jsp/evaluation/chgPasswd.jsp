<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<table width="400" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
				<tr>
					<td width="21" style="background-color: #ea002c; height: 47px;"></td>
					<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
						<h2>비밀번호 변경</h2>
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
                    <input type="hidden" name="oper" value="edit"/>
                    <input type="hidden" name="nonUserId" value="${param.userId}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="2" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="110">변경 비밀번호</td>
                            <td class="table_td_contents4">
                                <input type="password" id="pwd" name="pwd" required title="변경 비밀번호" style="width: 150px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="110">비밀번호 확인</td>
                            <td class="table_td_contents4">
                                <input type="password" id="pwd_cofm" required title="비밀번호 확인" style="width: 150px" maxlength="100"/>
                            </td>
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
                            <button id="btnSave" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
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
    $('#btnSave').click(function (e) {
        if (!$("#frmSave").validate()) {
            return;
        }
        if ($('#pwd').val() != $('#pwd_cofm').val()) {
        	alert('비밀번호가 다릅니다. 다시한번 확인해주세요.');
        	return;
        }
    	$.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/evaluation/updateNonUsers/save.sys', $('#frmSave').serialize(),
	        function(msg) {
    		  var m = eval('(' + msg + ')');
    		  if (m.customResponse.success) {
    			  alert('비밀번호가 정상적으로 변경되었습니다.');
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
</script>