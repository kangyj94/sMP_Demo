<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%

	String quick01 = (String)request.getAttribute("quick01");
	String quick02 = (String)request.getAttribute("quick02");
	String quick03 = (String)request.getAttribute("quick03");
	String quick04 = (String)request.getAttribute("quick04");
	String quick05 = (String)request.getAttribute("quick05");

	quick01 = CommonUtils.nvl(quick01, "0");
	quick02 = CommonUtils.nvl(quick02, "0");
	quick03 = CommonUtils.nvl(quick03, "0");
	quick04 = CommonUtils.nvl(quick04, "0");
	quick05 = CommonUtils.nvl(quick05, "0");
%>
<div id="divQuick">
	<div id="quickmenuVen">
		<ul>
			<li>
				<div class="bossQ" style="cursor: pointer;" onclick="javascript:location.href = '/venOrder/venRetOrdProcList.sys?_menuCd=VEN_RECE_RETURN&linkOper=quick';">반품요청<br />물품 (<a href="javascript:void(0);" class="col02" id="quick01"><%=quick01 %></a>)</div>
				<div class="bossQ" style="cursor: pointer;" onclick="javascript:location.href = '/product/bidList.sys?_menuCd=VEN_PDT_BID';">입찰 (<a href="javascript:void(0);" class="col02" id="quick01"><%=quick02 %></a>)</div>
				<div class="bossQ" style="cursor: pointer;" onclick="javascript:location.href = '/proposal/viewProposalListVen.sys?_menuCd=VEN_PDT_PROPOSAL';">신규상품<br />제안 (<a href="javascript:void(0);" class="col02" id="quick03"><%=quick03 %></a>)</div>
				<div class="bossQ" style="cursor: pointer;" onclick="javascript:location.href = '/product/stockProductVenList.sys?_menuCd=VEN_PDT_STOCK';">재고입고<br />필요(<a href="javascript:void(0);" class="col02" id="quick04"><%=quick04 %></a>)</div>
				<div class="bossQ" style="cursor: pointer;" onclick="javascript:location.href = '/venOrder/venOrderProgress.sys?_menuCd=VEN_ORDER_PROC&srcOrderStatusFlag=59&linkOper=quick';">주문취소<br />요청(<a href="javascript:void(0);" class="col02" id="quick05"><%=quick05 %></a>)</div>
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
}
.jqmOverlay { background-color: #000; }
* html .jqmPop {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
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
							<button id='conFirmPopConfirm' class="btn btn-primary btn-xs">확인</button>
							<button id='conFirmPopCancle' class="btn btn-primary btn-xs">취소</button>
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
    $('#conFirmPop').css("top", Math.max(0, (($(window).height() - $('#conFirmPop').outerHeight()) / 2) + $(window).scrollTop()) + "px");
    $('#conFirmPop').css("left", Math.max(0, (($(window).width() - $('#conFirmPop').outerWidth()) / 2) + $(window).scrollLeft()) + "px");
	$('#conFirmPop').jqmShow();
}

$(window).bind('resize', function() { 
	var divQuickLeft = $("#divSub").offset().left;
	var windowWidth  = $(window).width();
	
	divQuickLeft = divQuickLeft + $("#divSub").width();
	divQuickLeft = divQuickLeft + 13;
	
	if(windowWidth <= divQuickLeft){
		divQuickLeft = windowWidth - 93;
	}
	
    $("#divQuick").attr("style", "left:" + divQuickLeft + "px");
}).trigger('resize');

//quick menu
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/vendorQuickMenuCnt.sys',
		{
			oper			: ""			
		},
		function(arg){
			var quickList = "0";
			var quick01   = "0";
			var quick02   = "0";
			var quick03   = "0";
			var quick04   = "0";
			var quick05   = "0";
			
			var quickList = eval('(' + arg + ')').list;
			if(quickList != null){	
				quick01 = quickList.quick01;
				quick02 = quickList.quick02;
				quick03 = quickList.quick03;
				quick04 = quickList.quick04;
				quick05 = quickList.quick05;
			}	
			
			$("#quick01").html(quick01);
			$("#quick02").html(quick02);
			$("#quick03").html(quick03);
			$("#quick04").html(quick04);
			$("#quick05").html(quick05);
			
		}
	);		

</script>