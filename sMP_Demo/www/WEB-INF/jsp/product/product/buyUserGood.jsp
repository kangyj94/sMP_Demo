<%@page import="java.util.Map"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	List<Map<String, Object>> list = (List<Map<String, Object>>)request.getAttribute("list");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>

<style type="text/css">
.jqmPop {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -320px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
}
.jqmOverlay { background-color: #000; }
</style>

</head>

<body class="mainBg">
	<div id="divWrap">
		<!--header-->
		<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
		<!--//header-->
		<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />

				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">관심 상품</li>
					</ul>
					<div class="ListTable">
						<table>
							<colgroup>
								<col width="30px" />
								<col width="530px" />
								<col width="100px" />
								<col width="100px" />
								<col width="140px" />
								<col width="100px" />
							</colgroup>
							<tr>
								<th class="br_l0"><input id="cartCheckAll" name="cartCheckAll" type="checkbox" value="" onclick="javascript:fnCheckAll();" /></th>
								<th>상품정보</th>
								<th>금액</th>
								<th>수량(재고수량)</th>
								<th>공급사</th>
								<th>장바구니담기</th>
							</tr>
<%
	if(list != null && list.size() > 0){
		int cnt = 0;
		for(Map<String, Object> pdtMap : list){
			List<Map<String, Object>> infoList = (List<Map<String, Object>>)pdtMap.get("info");
			cnt++;
%>
							<tr>
								<td align="center" class="br_l0">
									<input id="cartChk_<%=cnt %>" name="cartChk_<%=cnt %>" type="checkbox" value="<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB")) %>" class="cartCheck" />
								</td>
<%
	String appDispStr = "none";
	String addDispStr = "none";
	String optDispStr = "none";

	if("20".equals(CommonUtils.getString(pdtMap.get("GOOD_TYPE")))) appDispStr = "inline";
	if("Y".equals(CommonUtils.getString(pdtMap.get("ADD_GOOD")))) addDispStr = "inline";
	if("Y".equals(CommonUtils.getString(pdtMap.get("REPRE_GOOD")))) optDispStr = "inline";
%>
								<td>
									<div id="appointDiv" class="label" style="display: <%=appDispStr %>;" ><span class="appoint" style="cursor:text;">지정</span></div>
									<div class="label" style="display: <%=addDispStr %>;"><span class="add"  style="cursor:text;">추가</span></div>
									<div class="label" style="display: <%=optDispStr %>;"><span class="option"  style="cursor:text;">옵션</span></div>
									<dl>
										<dt>
											<a id="pdtLink_<%=cnt%>" href="javascript:fnProductDetail('<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"))%>', '<%=cnt%>');">
												<img  id="productImg_<%=cnt%>" src="<%=Constances.SYSTEM_IMAGE_PATH %>/<%=CommonUtils.getString(infoList.get(0).get("IMG_PATH")) %>" onerror="this.src = '/img/layout//img_null.jpg'" width="100px;" height="100px;" />
											</a>
										</dt>
										<dd>
											<p class="bold">
												<a id="pdtLink_<%=cnt%>" href="javascript:fnProductDetail('<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"))%>', '<%=cnt%>');">
												<%=CommonUtils.getString(pdtMap.get("GOOD_NAME")) %>
												</a>
											</p>
											<ul>
												<li>규격&nbsp;&nbsp;&nbsp;&nbsp; : <strong><%=CommonUtils.getString(pdtMap.get("GOOD_SPEC"))%></strong></li>
												<li>공급사 : <strong id="venderNm_<%=cnt%>"><%=CommonUtils.getString(infoList.get(0).get("VENDORNM"))%></strong></li>
											</ul>
										</dd>
									</dl>
								</td>
								<td class="count" >
									<span class="bold" id="sellPriceTxt_<%=cnt%>"><%=CommonUtils.getIntString(infoList.get(0).get("SELL_PRICE")) %></span>
								</td>
								<td class="count">
<%
		if(!"Y".equals(CommonUtils.getString(pdtMap.get("REPRE_GOOD")))){
%>
									<p><input id="inputQuan_<%=cnt%>" name="inputQuan_<%=cnt%>" type="text" style="width:50px;text-align: right;" 
										 value="<%=CommonUtils.getIntString(infoList.get(0).get("DELI_MINI_QUAN"))%>" onkeydown="return onlyNumber(event)" maxlength="9"/> 개</p>
<%					
		}
%> 
									<p id="goodInvCntTxt_<%=cnt%>">( <%=CommonUtils.getIntString(infoList.get(0).get("GOOD_INVENTORY_CNT")) %> 개 )</p>
									
									<input type="hidden" name="selVenderId_<%=cnt%>" 		id="selVenderId_<%=cnt%>" 		value="<%=CommonUtils.getString(infoList.get(0).get("VENDORID"))%>"/>
									<input type="hidden" name="selGoodIdenNumb_<%=cnt%>" 	id="selGoodIdenNumb_<%=cnt%>" 	value="<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"))%>"/>
									<input type="hidden" name="addGoodYn_<%=cnt%>" 			id="addGoodYn_<%=cnt%>" 		value="<%=CommonUtils.getString(pdtMap.get("ADD_GOOD"))%>"/>
									<input type="hidden" name="repreGoodYn_<%=cnt%>" 		id="repreGoodYn_<%=cnt%>" 		value="<%=CommonUtils.getString(pdtMap.get("REPRE_GOOD"))%>"/>
								
								</td>
								<td>
									<ul>
<%			int infoCnt = 0;
			if(infoList != null && infoList.size() > 0 ){
				for(Map<String, Object> infoMap : infoList){
					String eVendorId = CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB")) +"_"+ infoMap.get("VENDORID");
%>
										<li>
											<input type="radio" name="<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB")) %>" id="<%=eVendorId %>" value="<%=eVendorId %>" style="vertical-align: bottom;" 
												<%if(infoCnt == 0 ){ %> checked="checked" <%}%> onclick="javascript:fnSelectVendor('<%=eVendorId %>', '<%=cnt%>');" />
											<label id="selVenderNm_<%=eVendorId %>"  for="radio" style="cursor: pointer;" onclick="javascript:fnSelectVendor('<%=eVendorId %>', '<%=cnt%>');"><%=infoMap.get("VENDORNM") %></label>
										</li>
<%					
					infoCnt++;
				}
			}	
%> 
									</ul>
								</td>
								<td align="center">
									<a href="#;"><img onclick="javascript:fnPopCartInfo('<%=cnt%>');" src="/img/contents/btn_basket.gif" /></a>
								</td>
							</tr>
<%			
		}
	}else{
%>
									<tr>
										<td align="center" colspan="6"><b>관심상품이 없습니다.</b></td>
									</tr>

<%		
	}
%>
						</table>
					</div>
					<div class="mgt_10">
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnSetCheckAll();">전체선택</a>
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnCartDelete();">선택 상품 삭제</a>
					</div>
					<div style="height:10px;"></div>
				</div>
				<!--컨텐츠(E)-->
						
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>	
</body>

<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
});
</script>


<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>
<script type="text/javascript">
function fnSetCheckAll(){
	if($('#cartCheckAll').prop('checked')){
		$('#cartCheckAll').prop('checked', false);
	}else{
		$('#cartCheckAll').prop('checked', true);
	}
	fnCheckAll();
}

function fnCheckAll(){
	if($("#cartCheckAll").prop("checked")){
		$(".cartCheck").prop("checked", true);
	}else{
		$(".cartCheck").prop("checked", false);
	}
}


function fnCartDelete(){
	var cartCnt = $(".cartCheck:checked").length;
	
	var goodIdenNumbs = $(".cartCheck:checked").map(function(){
		return $(this).val();		
	}).get();
	
	if(cartCnt  == 0){
		alert("삭제할 상품을 선택해주세요.");
		return;
	}
	
	if(!confirm("선택하신 상품을 삭제 하시겠습니까?")) return;
		
	$.post(
		'/product/deleteUserGood/save.sys',
		{
			goodIdenNumbs:goodIdenNumbs,
			oper:"del"
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if(result.success){
				fnDynamicForm("/buyProduct/getBuyUserGoodList.sys", "","");				
			}else{
				alert( result.message.join('\n') );
			}
		}
	);	
}



</script>
<script type="text/javascript">
function fnProductDetail(goodIdenNumb, cnt){
	vendorId 	 = $("#selVenderId_" + cnt).val();
	fnProductDetailPop(goodIdenNumb, vendorId);
}


function  fnSelectVendor(val, cnt){
	$.blockUI({});

	$("#" + val).prop("checked", true);
	var goodIdenNumb = val.split("_")[0];
	var vendorId 	 = val.split("_")[1];
    
    $.post(  
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getChoiceVendorInfo.sys',
		{	
        	goodIdenNumb:goodIdenNumb,
        	vendorId:vendorId
        },
		function(arg){
           	var resultMap = eval('(' + arg + ')').resultMap;
           	$("#sellPriceTxt_"+cnt).html(fnComma(resultMap.SELL_PRICE));
           	$("#venderNm_"+cnt).html($("#selVenderNm_"+val).html());
           	$("#selVenderId_"+cnt).val(vendorId);
           	$("#inputQuan_"+cnt).val(resultMap.DELI_MINI_QUAN);
           	$("#pdtLink_"+cnt).attr("href", "javascript:fnProductDetail(' "+goodIdenNumb+" ',' "+cnt+" ')");
           	$("#productImg_"+cnt).attr("src", "/upload/image/"+resultMap.SM_IMG_PATH);
           	
           	if(resultMap.GOOD_CLAS_CODE == '10'){
           		$("#appointDiv").show();
           	}else{
           		$("#appointDiv").hide();
           	}
           	
           	$.unblockUI();
    	}
	);	
}


function fnPopCartInfo(cnt){
	var vendorId 	 = "";
	var goodIdenNumb = "";
	var quan 		 = "";
	var repreGoodYn  = "";
	
	vendorId 	 = $("#selVenderId_" + cnt).val();
	goodIdenNumb = $("#selGoodIdenNumb_" + cnt).val();
	quan 		 = $("#inputQuan_" + cnt).val();
	repreGoodYn  = $("#repreGoodYn_"+cnt).val();
	
	if( (quan == ''|| quan < 1) && repreGoodYn=='N' ){
		alert("수량을 입력해 주세요.");
		return;
	}

	<%-- 
		장바구니 호출 공통 팝업 함수
		(상품상세 팝업 페이지 안에 정의되어 있음) : /WEB-INF/jsp/product/product/buyProductDetailPop.jsp
	--%>
	fnBuyCommonCartPop(vendorId, goodIdenNumb, quan);
	
}

</script>
<link type="text/css" rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/lightslider.css" />
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/lightslider.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>
</html>