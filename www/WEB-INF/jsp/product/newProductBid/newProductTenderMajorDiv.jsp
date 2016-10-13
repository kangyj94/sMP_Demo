<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmWindow {
	display: none;

	position: fixed;
	top: 17%;
	left: 50%;

	margin-left: -300px;
	width: 700px;

	background-color: #EEE;
	color: #333;
	border: 1px solid black;
	padding: 12px;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
	position: absolute;
	top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-------------------------------- Dialog Div Start -------------------------------->
<script type="text/javascript">
$(function(){
	$('#newProductTenderMajorPop').jqm();  //Dialog 초기화
	$("#btnTenNewProductPop").click(function(){
		$('#newProductTenderMajorPop').hide();
		tenNewProduct('proc');
	});

	$("#closeButton, .jqmClose").click(function(){ //Dialog 닫기
		$('#newProductTenderMajorPop').hide();
	});
});


function fnNewProductTenderMajorPop() {
	$("#newProductTenderMajorPop").show();
}
</script>
</head>
<body>
<div class="jqmWindow" id="newProductTenderMajorPop" style="z-index:999;">
	<table width="700" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
					<tr>
						<td width="21" style="background-color: #ea002c; height: 47px;"></td>
							<td style="background-color: #ea002c; height: 47px;color: #fff;font-size: 14px;font-weight: 700;">
								입찰 담당자의 요청 사항과 투찰금액을 재확인하시고, 투찰을 진행해 주시길 바랍니다. 
							</td>
							<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
								<a href="#" class="jqmClose">
									<img src="/img/contents/btn_close.png" class="jqmClose">
								</a>
							</td>
							<td width="10" style="background-color: #ea002c; height: 47px;"></td>
					</tr>
				</table>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
					
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="top" bgcolor="#FFFFFF" style="padding-top: 5px;">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="FINAL_RESULT_PRINT">
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110">입찰 담당자<BR>요청 사항</td>
									<td class="table_td_contents4">
										<textarea name="bidNoteField" id="bidNoteField" style="width: 98%; height: 100px;" disabled="disabled" class="input_text_none"></textarea>
									</td>
								</tr>
								<tr>
									<td colspan="2" height="1" bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110">투찰 금액</td>
									<td class="table_td_contents4"><div id="saleUnitPriceAucField"></div></td>
								</tr>
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
							</table> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="center">
										<button id="btnTenNewProductPop" name="btnTenNewProduct" type="button" class="btn btn-darkgray btn-sm"> 승인</button>
										<button id="closeButton" name="btnTenNewProduct" type="button" class="btn btn-default btn-sm"> 닫기</button>
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
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>