<%@page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String cartCount = (String)request.getAttribute("cartCount");

	cartCount = CommonUtils.nvl(cartCount, "0");
	
	String quick04 = (String)request.getAttribute("quick04");
	String quick05 = (String)request.getAttribute("quick05");
	
	quick04 = CommonUtils.nvl(quick04, "0");
	quick05 = CommonUtils.nvl(quick05, "0");
%>
<div id="divQuick">
	<div id="quickmenu">
		<ul>
			<li class="quick01" onclick="javascript:fnBuyCartInfo();">
				<div style="background:url(/img/layout/basket_count.png) no-repeat; width:18px; height:18px; position:absolute; left:40px; top:10px; text-align:center;">
					<a href="javascript:void(0);" style="color:#fff; letter-spacing:-1px;"><div id="cartCntDivId"><%=cartCount %></div></a>
				</div>
				<span>장바구니</span>
			</li>
			<li class="quick02" onclick="javascript:goPage('/buyProduct/getBuyUserGoodList.sys');"><span>관심상품</span></li>
			<li class="quick03" onclick="javascript:fnOrderResultSearchBuy();"><span>구매이력조회</span></li>
			
			<li class="quick04" onclick="javascript:fnBuyOrderCancel();">
				<div style="background:url(/img/layout/basket_count.png) no-repeat; width:18px; height:18px; position:absolute; left:40px; top:239px; text-align:center;">
					<a href="javascript:void(0);" style="color:#fff; letter-spacing:-1px;"><div id="cartCntDivId"><%=quick04 %></div></a>
				</div>
				<span>주문 취소 미승인</span>
			</li>
			
			<li class="quick05" onclick="javascript:fnBuyReturnRequest();">
				<div style="background:url(/img/layout/basket_count.png) no-repeat; width:18px; height:18px; position:absolute; left:40px; top:310px; text-align:center;">
					<a href="javascript:void(0);" style="color:#fff; letter-spacing:-1px;"><div id="cartCntDivId"><%=quick05 %></div></a>
				</div>
				<span>반품 요청 미승인</span>
			</li>
		</ul>
	</div>
	<p class="Ac">
		<a href="#">
			<img src="/img/layout/top.gif" />
		</a>
	</p>
</div>
<style type="text/css">
.jqmPop {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -400px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
    z-index:9999;
}
.jqmOverlay { background-color: #000; }
* html .jqmPop {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
#conFirmPopMessage{
    font-size: medium;
    font-weight: 700;
}
</style>
<div id="conFirmPop" class="jqmPop" style="font_size: 12px; display: none;">
	<div>
		<div id="divPopup"  style="width:400px;">
			<div id="conFirmPopDrag">
				<h1>Confirm<a href="javascript:void(0);"><img id="conFirmPopCloseButton" src="/img/contents/btn_close.png"></a></h1>
			</div>		  		
			<div class="popcont">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" class="table_top_line"></td>
					</tr>
					<tr>
						<td id="conFirmPopMessage">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" height="20">&nbsp;</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<button id='conFirmPopConfirm' class="btn btn-danger btn-xs" style="height: 28px;">확인</button>
							<button id='conFirmPopCancle' class="btn btn-primary btn-xs" style="height: 28px;">취소</button>
						</td>
					</tr>
				</table>
			</div>
		</div>    	
	</div>
</div>
<script type="text/javascript">
$(document).ready(function() {
	$("#conFirmPopCloseButton").click(function(){
		$("#conFirmPop").jqmHide();
	});
	
    $("#conFirmPopCancle").click(function(){
    	$("#conFirmPop").jqmHide();
    });
    
	$('#conFirmPop').jqm().jqDrag('#conFirmPopDrag');
});

function confirmMessage(message, callback) {
	$("#conFirmPopMessage").html(message);
	$("#conFirmPopConfirm").unbind('click');
	$("#conFirmPopConfirm").click(function(){
		callback();
		$("#conFirmPop").jqmHide();
	});
	$('#conFirmPop').css("position","absolute");
	$('#conFirmPop').css("top", Math.max(0, (($(window).height() - $('#conFirmPop').outerHeight()) /4) + $(window).scrollTop()) + "px");
    $('#conFirmPop').css("left", Math.max(0, (($(window).width() - $('#conFirmPop').outerWidth()) / 2) + $(window).scrollLeft()) + "px");
	$('#conFirmPop').jqmShow();
}

function goPage(url){
	location.href = url;
}

function fnOrderResultSearchBuy(){
	fnDynamicForm("/buyOrder/orderResultSearchBuy.sys", "_menuCd=BUY_ORDER_INFO", '_self');
}
</script>