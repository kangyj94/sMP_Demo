<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String step01 = (String)request.getAttribute("headerStep01");
	String step02 = (String)request.getAttribute("headerStep02");
	String step03 = (String)request.getAttribute("headerStep03");
	String step04 = (String)request.getAttribute("headerStep04");
	String step05 = (String)request.getAttribute("headerStep05");

	step01 = CommonUtils.nvl(step01, "-1");
	step02 = CommonUtils.nvl(step02, "0");
	step03 = CommonUtils.nvl(step03, "0");
	step04 = CommonUtils.nvl(step04, "0");
	step05 = CommonUtils.nvl(step05, "0");
	
	if(!"-1".equals(step01)) {	//값을 가져올때만
%>
<div id="step">
	<ul>
		<a href="/venOrder/venOrderPurchaseList.sys?_menuCd=VEN_ORD_PURC" target="_self">
			<li class="step01">
				<p>접수대기 <%=step01 %>건</p>
				<p class="f12 col04">- 주문접수 하기</p>
			</li>
		</a>
		<a href="/venOrder/deliProcList.sys?_menuCd=VEN_ORD_DELI" target="_self">
			<li class="step02">출하대기 <%=step02 %>건
				<p class="f12 col04">- 물품 발송하기</p>
			</li>
		</a>
		<a href="/venOrder/venOrderProgress.sys?_menuCd=VEN_ORDER_PROC&srcOrderStatusFlag=60" target="_self">
		<li class="step03">배송중 <%=step03 %>건
			<p class="f12 col04">- 물품위치추적</p>
		</li></a>
		<a href="/venOrder/venOrdReceStandBy.sys?_menuCd=VEN_RECE_STANDBY" target="_self">
		<li class="step04">인수대기 <%=step04 %>건
			<p class="f12 col04">- 인수대기 리스트</p>
		</li></a>
		<a href="/venOrder/venOrderHistList.sys?_menuCd=VEN_ORD_SCH&srcIsBill=0" target="_self">
		<li class="step05">정산대기 <%=step05 %>건
			<p class="f12 col04">- 정산 내역확인</p>
		</li></a>
	</ul>
</div>
<%	}	%>