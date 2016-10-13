<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmDeliveryAddresWindow {
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
* html .jqmDeliveryAddresWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	// Dialog Button Event
	$('#deliveryAddressDialogPop').jqm();	//Dialog 초기화
	$("#btnDeliveryCloseDiv").click(function(){	//Dialog 닫기
		$("#deliveryAddressDialogPop").jqmHide();
		$("#shippingPlaceDiv").val("");
		$("#shippingPhoneNumDiv").val("");
		$("#shippingPostDiv").val("");
		$("#shippingAddressDiv").val("");
		$("#shippingAddressDescDiv").val("");
		fnDeliveryAddressCallback = "";
	});
	$('#btnDeliveryRegDiv').click(function(){
		if($("#shippingPlaceDiv").val()=="") { alert("배송지명은 필수입니다."); $("#shippingPlaceDiv").focus(); return; }
// 		if($("#shippingPhoneNumDiv").val()=="") { alert("배송지 전화번호는 필수입니다."); $("#shippingPhoneNumDiv").focus(); return; }
		if($("#shippingPostDiv").val()=="") { alert("우편번호는 필수입니다."); return; }
		if($("#shippingAddressDescDiv").val()=="") { alert("배송지 상세주소는 필수입니다."); $("#shippingAddressDescDiv").focus(); return; }
		var rtn_shippingPlace = $("#shippingPlaceDiv").val();
		var rtn_shippingPhoneNum = $("#shippingPhoneNumDiv").val();
		var rtn_shippingPost = $("#shippingPostDiv").val();
		var rtn_shippingAddress = $("#shippingAddressDiv").val();
		var rtn_shippingAddressDesc = $("#shippingAddressDescDiv").val();
		eval(fnDeliveryAddressCallback+"('"+rtn_shippingPlace+"','"+rtn_shippingPhoneNum+"','"+rtn_shippingPost+"','"+rtn_shippingAddress+"','"+rtn_shippingAddressDesc+"');");
		$("#btnDeliveryCloseDiv").click();
	});
	$('#btnShippingPostDiv').click(function(){
		fnPostSearchDialog("fnCallBackDeliveryAddress"); 
		$("#deliveryAddressDialogPop").jqmHide();
	});
	$('#deliveryAddressDialogPop').jqm().jqDrag('#deliveryAddressDialogHandle');
});

var fnDeliveryAddressCallback = "";
function fnDeliveryAddressDialog(callbackString) {
	$("#deliveryAddressDialogPop").jqmShow();
	$("#shippingPlaceDiv").val("");
	$("#shippingPhoneNumDiv").val("");
	$("#shippingPostDiv").val("");
	$("#shippingAddressDiv").val("");
	$("#shippingAddressDescDiv").val("");
	fnDeliveryAddressCallback = callbackString;
}

/**
 * 우편번호팝업검색후 선택한 값 세팅
 */
function fnCallBackDeliveryAddress(post, postAddress) {
	$("#deliveryAddressDialogPop").jqmShow();
	$("#shippingPostDiv").val(post);
	$("#shippingAddressDiv").val(postAddress);
	$("#shippingAddressDescDiv").focus();
}
</script>

</head>

<body>
<div class="jqmDeliveryAddresWindow" id="deliveryAddressDialogPop">
	<table width="500"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="deliveryAddressDialogHandle">
					<table id="popup_titlebar_mid2" width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
						<tr>
							<td width="21"><img id="popup_titlebar_left2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47"/></td>
							<td width="22"><img id="popup_titlebar_bullet2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px"/></td>
							<td class="popup_title">배송지팝업</td>
		        			<td width="22" align="right">
		        				<a href="#" class="jqmClose">
		        				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" />
		        				</a>
		        			</td>
							<td width="10" img id="popup_titlebar_right2" src="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
						</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="top" bgcolor="#FFFFFF">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="100">배송지명</td>
									<td class="table_td_contents">
										<input id="shippingPlaceDiv" name="shippingPlaceDiv" type="text" value="" size="50" maxlength="50" style="width:80%"/>
									</td>
								</tr>
								<tr>
									<td colspan="2" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject">배송지 전화번호</td>
									<td class="table_td_contents">
										<input id="shippingPhoneNumDiv" name="shippingPhoneNumDiv" type="text" value="" size="20" maxlength="50"  onkeydown="return onlyNumber(event)"/>(-없이)
									</td>
								</tr>
								<tr>
									<td colspan="2" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject">주소</td>
									<td class="table_td_contents">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td height="25">
													<input id="shippingPostDiv" name="shippingPostDiv" type="text" size="7" class="input_text_none" disabled="disabled"/>
													<a href="#">
													<img id="btnShippingPostDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style='border:0;vertical-align:middle;display:'/>
													</a>
												</td>
											</tr>
											<tr>
												<td height="25">
													<input id="shippingAddressDiv" name="shippingAddressDiv" type="text" size="30" class="input_text_none" disabled="disabled"/>
												</td>
											</tr>
											<tr>
												<td height="25">
													<input id="shippingAddressDescDiv" name="shippingAddressDescDiv" type="text" size="30" maxlength="30"/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
							</table>
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<a href="#">
										<img id="btnDeliveryRegDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_register.gif" style='border:0;'/>
										</a>
										<a href="#">
										<img id="btnDeliveryCloseDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style='border:0;'/>
										</a>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
