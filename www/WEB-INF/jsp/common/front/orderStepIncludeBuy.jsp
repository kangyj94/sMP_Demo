<%@page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String step01 = (String)request.getAttribute("headerStep01");
	String step02 = (String)request.getAttribute("headerStep02");
	String step03 = (String)request.getAttribute("headerStep03");
	String step04 = (String)request.getAttribute("headerStep04");
	String step05 = (String)request.getAttribute("headerStep05");

	step01 = CommonUtils.nvl(step01, "-1");
	step02 = CommonUtils.nvl(step02, "-1");
	step03 = CommonUtils.nvl(step03, "-1");
	step04 = CommonUtils.nvl(step04, "-1");
	step05 = CommonUtils.nvl(step05, "-1");
	
	if(!"-1".equals(step01)) {	//값을 가져올때만
%>
<div id="step">
	<ul>
		<a href="javascript:location.href='/menu/order/delivery/deliListBuy.sys?_menuCd=BUY_ORDER_DELIVERY&srcOrderStatusFlag=A';">
			<li class="step01">
				<p>주문 <%=step01 %>건</p>
				<p class="f12 col04">- 주문 취소하기</p>
			</li>
		</a>
		<a href="javascript:location.href='/menu/order/delivery/deliListBuy.sys?_menuCd=BUY_ORDER_DELIVERY&srcOrderStatusFlag=B' ;">
			<li class="step02">배송준비 <%=step02 %>건
				<p class="f12 col04">- 주문내역 확인</p>
			</li>
		</a>
		<a href="javascript:location.href='/menu/order/delivery/deliListBuy.sys?_menuCd=BUY_ORDER_DELIVERY&srcOrderStatusFlag=C';">
			<li class="step03">배송 <%=step03 %>건
				<p class="f12 col04">- 배송위치추적</p>
			</li>
		</a>
		<a href="javascript:location.href='/buyOrder/clientReceiveList.sys?_menuCd=BUY_RECEIVE_LIST&srcOrderStatusFlag=D';">
			<li class="step04">인수대기 <%=step04 %>건
				<p class="f12 col04">- 인수대기 리스트</p>
			</li>
		</a>
		<a href="javascript:location.href='/buyOrder/orderResultSearchBuy.sys?_menuCd=BUY_ORDER_INFO&srcIsBill=0';">
			<li class="step05">정산대기 <%=step05 %>건
				<p class="f12 col04">- 정산대기 리스트</p>
			</li>
		</a>
	</ul>
</div>
<%	}	%>