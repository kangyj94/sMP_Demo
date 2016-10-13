<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmCancelReasonWindow {
    display: none;
    
    position: fixed;
    top: 17%;
    left: 50%;
    
    margin-left: -300px;
    width: 500px;
    
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}

.jqmOverlay { background-color: #000; }

* html .jqmCancelReasonWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-------------------------------- Dialog Div Start -------------------------------->
<script type="text/javascript">
$(function() {
    $("#cancelReasonDialogPop").jqm();      //Dialog 초기화
    $('#cancelReasonDialogPop').jqm().jqDrag('#dialogHandle');
    $("#regJqmButton").click(function() {
        fnJqmAddCancelReason();
    });
    $("#cloJqmButton").click(function() {   //Dialog 닫기
        $('#cancelReasonDialogPop').jqmHide();
        $("#txtJqmCancelReason").val("");
        fnCancelReasonCallback = "";
    });
});

var fnCancelReasonCallback = "";
function fnCancelReasonDialog(callbackString) {
    $("#cancelReasonDialogPop").jqmShow();  //필수
    $("#cancelReasonDiv").focus();
    fnCancelReasonCallback = callbackString;
}

/**
 * 반려(취소) 사유 입력후 Callback 호출(Parent페이지에 반드시 fnCallBackCancelReason 함수 존재해야 함)
 */
function fnJqmAddCancelReason() {
    var jqmCancelReason = document.getElementById("txtJqmCancelReason");
    eval(fnCancelReasonCallback+"('"+jqmCancelReason.value+"');");
    $("#cloJqmButton").click();
}
</script>
</head>
<body>
<div class="jqmCancelReasonWindow" id="cancelReasonDialogPop">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <div id="dialogHandle">
                <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                    <tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-size: 17px;font-weight: 700;">
		        				<h3>반려(취소) 사유</h3>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
                </table>
            </div>
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" /></td>
                    <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
                    <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
                </tr>
                <tr>
                    <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                    <td bgcolor="#FFFFFF">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="2" class="table_top_line"></td>
                            </tr>
                            <tr>
                                <td colspan="2" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject" width="100">반려(취소) 사유</td>
                                <td class="table_td_contents">
                                    <input id="txtJqmCancelReason" name="txtJqmCancelReason" type="text" value="" size="20" maxlength="100" style="width:300px;" /></td>
                            </tr>
                            <tr>
                                <td colspan="2" height='1' bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="table_top_line"></td>
                            </tr>
                            <tr>
                                <td colspan="4" height='8'></td>
                            </tr>
                        </table>
                        
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="center">
									<button id="regJqmButton" type="button" class="btn btn-primary btn-sm isWriter"><i class="fa fa-check"></i>반려</button>
									<button id="cloJqmButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                </tr>
                <tr>
                    <td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" /></td>
                    <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                    <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>