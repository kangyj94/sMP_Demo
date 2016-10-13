<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.HashSet"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="kr.co.bitcube.product.dto.ProductDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="java.util.Map"%>
<%@page import="java.math.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
	List<ActivitiesDto>       roleList        = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	List<Map<String, Object>> list            = (List<Map<String, Object>>)request.getAttribute("list");
	List<Map<String, Object>> cate            = (List<Map<String, Object>>)session.getAttribute("cate");
	String                    inputWord       = CommonUtils.getString(request.getParameter("inputWord"));
	String                    prevWord        = CommonUtils.getString(request.getParameter("prevWord"));
	String                    srcCateId       = CommonUtils.getString(request.getParameter("srcCateId"));
	String                    setCateId       = CommonUtils.getString(request.getParameter("setCateId"));
	Map<String, String>       managerUserInfo = (Map<String, String>)request.getAttribute("managerUserInfo");
	double                    currCnt         = Double.parseDouble(CommonUtils.nvl(CommonUtils.getString(request.getAttribute("pCnt")), "0"));
	String                    srcGoodName	  = CommonUtils.getString(request.getParameter("srcGoodName"));    	
	String                    srcGoodSpec	  = CommonUtils.getString(request.getParameter("srcGoodSpec"));    
	String                    srcGoodIdenNumb = CommonUtils.getString(request.getParameter("srcGoodIdenNumb"));    
	String                    srcVendorNm	  = CommonUtils.getString(request.getParameter("srcVendorNm"));    
	String                    srcGoodClasCode = CommonUtils.getString(request.getParameter("srcGoodClasCode"));    
	
	
	if("".equals(prevWord)){
		prevWord = "＋" + inputWord; 
	}
%>
<head>


<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>

</head>

<body class="mainBg">
	<div id="divWrap">
		<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>  
    	<hr>
        	<div id="divBody">
            	<div id="divSub">
					<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
            		
           			<div id="CategoryAll" class="CategoryDiv" style="display:none;" onmouseout="javascript:document.getElementById('CategoryAll').style.display='none';" onmouseover="javascript:document.getElementById('CategoryAll').style.display='block';">
<%
	if(cate != null){
		String              topCateName       = null;
		String              topCateId         = null;
		String              midCateName       = null;
		String              midCateId         = null;
		String              dtlCateName       = null;
		String              dtlCateId         = null;
		String              beforeTopCateId   = null;
		String              beforeMidCateId   = null;
		String              nextTopCateId     = null;
		String              nextMidCateId     = null;
		Map<String, Object> cateInfo          = null;
		Map<String, Object> beforeCateInfo    = null;
		Map<String, Object> nextCateInfo      = null;
		int                 i                 = 0;
		int                 cateSize          = cate.size();
		int                 lastIndex         = cateSize - 1;
%>
		<ul>
<%
		for(i = 0 ; i < cateSize ; i++){
			cateInfo    = cate.get(i);
			topCateName = CommonUtils.getString(cateInfo.get("TOP_CATE_NAME"));
			topCateId   = CommonUtils.getString(cateInfo.get("TOP_CATE_ID"));
			midCateName = CommonUtils.getString(cateInfo.get("MID_CATE_NAME"));
			midCateId   = CommonUtils.getString(cateInfo.get("MID_CATE_ID"));
			dtlCateName = CommonUtils.getString(cateInfo.get("DTL_CATE_NAME"));
			dtlCateId   = CommonUtils.getString(cateInfo.get("DTL_CATE_ID"));
			
			if(i == 0){
				beforeTopCateId = "";
				beforeMidCateId = "";
			}
			else{
				beforeCateInfo  = cate.get(i - 1);
				beforeTopCateId = CommonUtils.getString(beforeCateInfo.get("TOP_CATE_ID"));  
				beforeMidCateId = CommonUtils.getString(beforeCateInfo.get("MID_CATE_ID"));  
			}
			
			if(i == lastIndex){
				nextTopCateId = "";
				nextMidCateId = "";
			}
			else{
				nextCateInfo  = cate.get(i + 1);
				nextTopCateId = CommonUtils.getString(nextCateInfo.get("TOP_CATE_ID"));
				nextMidCateId = CommonUtils.getString(nextCateInfo.get("MID_CATE_ID"));
			}
			
			if(beforeTopCateId.equals(topCateId) == false){ // 대분류 시작 
%>
							<li class="OneDepht"><%=topCateName %></li>
<%
			}
			
			if(beforeMidCateId.equals(midCateId) == false){ // 중분류 시작
%>
							<li>
								<dl>
									<dt><%=midCateName %></dt>
<%
			}
%>
									<dd onclick="javascript:fnSearchCate('<%=topCateId %>','<%=midCateId %>', '<%=dtlCateId %>');">
										<p>
											<a href="javascript:void(0);"><%=dtlCateName %></a>
               							</p>
               						</dd>
<%
			if((i != 0) && ((i % 15) == 0)){
%>
								</dl>
							</li>
						</ul>
						<ul>
							<li>
								<dl>
<%
			}

			if(nextMidCateId.equals(midCateId) == false){ // 중분류 종료
%>
								</dl>
<%
			}

			if(nextTopCateId.equals(topCateId) == false){ // 대분류 종료
%>
							</li>
<%
			}
		}
%>
						</ul>
<%
	}
%>
           			</div>
<%
	if(cate != null){
		String              topCateName       = null;
		String              topCateId         = null;
		String              topCateCd         = null;
		String              midCateName       = null;
		String              midCateId         = null;
		String              dtlCateName       = null;
		String              dtlCateId         = null;
		String              beforeTopCateId   = null;
		String              beforeMidCateId   = null;
		String              nextTopCateId     = null;
		String              nextMidCateId     = null;
		Map<String, Object> cateInfo          = null;
		Map<String, Object> beforeCateInfo    = null;
		Map<String, Object> nextCateInfo      = null;
		int                 i                 = 0;
		int                 cateSize          = cate.size();
		int                 lastIndex         = cateSize - 1;
		int                 cateCount         = 0;
	
		for(i = 0 ; i < cateSize ; i++){
			cateInfo    = cate.get(i);
			topCateName = CommonUtils.getString(cateInfo.get("TOP_CATE_NAME"));
			topCateId   = CommonUtils.getString(cateInfo.get("TOP_CATE_ID"));
			topCateCd   = CommonUtils.getString(cateInfo.get("TOP_CATE_CD"));
			midCateName = CommonUtils.getString(cateInfo.get("MID_CATE_NAME"));
			midCateId   = CommonUtils.getString(cateInfo.get("MID_CATE_ID"));
			dtlCateName = CommonUtils.getString(cateInfo.get("DTL_CATE_NAME"));
			dtlCateId   = CommonUtils.getString(cateInfo.get("DTL_CATE_ID"));
			
			if(i == 0){
				beforeTopCateId = "";
				beforeMidCateId = "";
			}
			else{
				beforeCateInfo  = cate.get(i - 1);
				beforeTopCateId = CommonUtils.getString(beforeCateInfo.get("TOP_CATE_ID"));  
				beforeMidCateId = CommonUtils.getString(beforeCateInfo.get("MID_CATE_ID"));  
			}
			
			if(i == lastIndex){
				nextTopCateId = "";
				nextMidCateId = "";
			}
			else{
				nextCateInfo  = cate.get(i + 1);
				nextTopCateId = CommonUtils.getString(nextCateInfo.get("TOP_CATE_ID"));
				nextMidCateId = CommonUtils.getString(nextCateInfo.get("MID_CATE_ID"));
			}
			
			if(beforeTopCateId.equals(topCateId) == false){ // 대분류 시작
				cateCount = 0;
%>
				<div id="Category<%=topCateCd %>" class="CategoryDiv" style="display:none;" onmouseout="javascript:document.getElementById('Category<%=topCateCd %>').style.display='none';" onmouseover="javascript:document.getElementById('Category<%=topCateCd %>').style.display='block';">
						<ul>
							<li class="OneDepht"><%=topCateName %></li>
<%
			}
			
			cateCount++;
			
			if(beforeMidCateId.equals(midCateId) == false){ // 중분류 시작
%>
							<li>
								<dl>
									<dt><%=midCateName %></dt>
<%
			}
%>
									<dd onclick="javascript:fnSearchCate('<%=topCateId %>','<%=midCateId %>', '<%=dtlCateId %>');">
										<p>
											<a href="javascript:void(0);"><%=dtlCateName %></a>
               							</p>
               						</dd>
<%
			if((cateCount != 0) && ((cateCount % 15) == 0)){
%>
								</dl>
							</li>
						</ul>
						<ul>
							<li>
								<dl>
<%
			}

			if(nextMidCateId.equals(midCateId) == false){ // 중분류 종료
%>
								</dl>
							</li>
<%
			}

			if(nextTopCateId.equals(topCateId) == false){ // 대분류 종료
%>
						</ul>
           			</div>
<%
			}
		}
	}
%>
					<div id="divCategory">
<!-- 						<h2 onmouseover="javascript:fnCategoryDivShow('CategoryAll');" id="CategoryAllli" onmouseout="javascript:document.getElementById('CategoryAll').style.display='none';"> -->
						<h2>
							<img src="/img/layout/category_all.gif" />
						</h2>
							<ul>
<%
	if(cate != null){
		String              topCateName       = null;
		String              topCateId         = null;
		String              topCateCd         = null;
		String              midCateName       = null;
		String              midCateId         = null;
		String              beforeTopCateId   = null;
		String              beforeMidCateId   = null;
		String              nextTopCateId     = null;
		String              nextMidCateId     = null;
		Map<String, Object> cateInfo          = null;
		Map<String, Object> beforeCateInfo    = null;
		Map<String, Object> nextCateInfo      = null;
		int                 i                 = 0;
		int                 cateSize          = cate.size();
		int                 lastIndex         = cateSize - 1;
	
		for(i = 0 ; i < cateSize ; i++){
			cateInfo    = cate.get(i);
			topCateName = CommonUtils.getString(cateInfo.get("TOP_CATE_NAME"));
			topCateId   = CommonUtils.getString(cateInfo.get("TOP_CATE_ID"));
			topCateCd   = CommonUtils.getString(cateInfo.get("TOP_CATE_CD"));
			midCateName = CommonUtils.getString(cateInfo.get("MID_CATE_NAME"));
			midCateId   = CommonUtils.getString(cateInfo.get("MID_CATE_ID"));
			
			if(i == 0){
				beforeTopCateId = "";
				beforeMidCateId = "";
			}
			else{
				beforeCateInfo  = cate.get(i - 1);
				beforeTopCateId = CommonUtils.getString(beforeCateInfo.get("TOP_CATE_ID"));  
				beforeMidCateId = CommonUtils.getString(beforeCateInfo.get("MID_CATE_ID"));  
			}
			
			if(i == lastIndex){
				nextTopCateId = "";
				nextMidCateId = "";
			}
			else{
				nextCateInfo  = cate.get(i + 1);
				nextTopCateId = CommonUtils.getString(nextCateInfo.get("TOP_CATE_ID"));
				nextMidCateId = CommonUtils.getString(nextCateInfo.get("MID_CATE_ID"));
			}
			
			if(beforeTopCateId.equals(topCateId) == false){ // 대분류 시작
%>
				<li onmouseover="javascript:fnCategoryDivShow('Category<%=topCateCd %>');" id="Category<%=topCateCd %>li" onmouseout="javascript:document.getElementById('Category<%=topCateCd %>').style.display='none';">
              		<span><%=topCateName %></span>
              	</li>
              	<li>
              		<div style="line-height: 2.2em;">
<%
			}
			
			if(beforeMidCateId.equals(midCateId) == false){ // 중분류 시작
%>
						<a href="javascript:fnSearchCate('<%=topCateId %>','<%=midCateId %>', '');" ><%=midCateName %></a>
<%
			}
			
			if(nextTopCateId.equals(topCateId) == false){ // 대분류 종료
%>
					</div>
				</li>
<%
			}
		}
	}

	if(managerUserInfo != null){
		String userNm = managerUserInfo.get("userNm");
		String tel    = managerUserInfo.get("tel");
		String email  = managerUserInfo.get("email");
%>
				<li style="background-image:url(/img/layout/cs_center.gif); height: 70px; text-align: right; padding-right: 1px; background-repeat: no-repeat;">
					<div style="line-height: 15px; color: #F67F25; font-size:15px; font-weight: bold;"><%=tel %></div>
					<div style="line-height: 10px; font-size:15px; font-weight: bold;"><%=email %></div>
					<div style="line-height: 10px; font-weight: bold; color: black;"><font style="color: #888;">담당자 :</font> <%=userNm %></div>
				</li>
<%
	}
%>
			</ul>
		</div>
		<!--카테고리(E)-->

        				<!--컨텐츠(S)-->
        				<div id="divContainer">                    
          					<!--내용변경되는 부분-->
          					<div id="divContant">
          						<h2>상품검색</h2>
          						<div style="position:absolute; right:0; margin-top:-30px;">
<!-- 									<a href="#;"><img src="/img/contents/btn_excelDN.gif" id="allExcelButton" name="allExcelButton"></a> -->
								</div>
          						<div class="SRC mgb_10">
          							<table>
          								<tr>
          									<td style="padding-left:54px;line-height:35px;" align="left" colspan="6">
			          							<label><input type="checkbox" 	id="searchType1"	name="searchType1" 	onclick="javascript:fnSearchType('1');" style="vertical-align: middle;"/>&nbsp;결과내 검색(상품코드,자재BP사)</label>
												<label><input type="checkbox" 	id="searchType2" 	name="searchType2" 	onclick="javascript:fnSearchType('2');" style="vertical-align: middle;"/>&nbsp;검색어 제외</label>
			          							<input type="text" 		id="inputWord" 		name="inputWord" 	class="src" placeholder="검색어를 입력하세요" size="80" />
			          							<input type="hidden" 	id="prevWord" 		name="prevWord" 	/>
			          							<input type="hidden" 	id="srcCateId" 		name="srcCateId" 	value="<%=srcCateId%>"/>
			          							<input type="hidden" 	id="setCateId" 		name="setCateId" 	value="<%=setCateId%>"/>          									
          									</td>
          									<td style="padding-left:24px;" align="left" rowspan="3">
												<a href="#;"><img src="/img/contents/big_search.gif" onclick="javascript:fnSearch();" /></a>          									
          									</td>
          								</tr>
          							
          								<tr>
          									<td style="padding-left:54px;line-height:27px;" align="left">상품명</td>
          									<td style="padding-left:20px;line-height:27px;" align="left">
          										<input type="text" style="width:120px;" id="srcGoodName" name="srcGoodName" value="<%=srcGoodName%>"/>
          									</td>
          									<td style="padding-left:40px;line-height:27px;" align="left">규격</td>
          									<td style="padding-left:20px;line-height:27px;" align="left">
          										<input type="text" style="width:150px;" id="srcGoodSpec" name="srcGoodSpec" value="<%=srcGoodSpec%>"/>
          									</td>
          									<td style="padding-left:40px;line-height:27px;" align="left">상품코드</td>
          									<td style="padding-left:20px;line-height:27px;" align="left">
          										<input type="text" style="width:100px;" id="srcGoodIdenNumb" name="srcGoodIdenNumb" value="<%=srcGoodIdenNumb%>"/>
          									</td>
          								</tr>
          								<tr>
          									<td style="padding-left:54px;line-height:27px;" align="left">공급사</td>
          									<td style="padding-left:20px;line-height:27px;" align="left">
          										<input type="text" style="width:120px;" id="srcVendorNm" name="srcVendorNm" value="<%=srcVendorNm%>"/>
          									</td>
          									<td style="padding-left:40px;line-height:27px;" align="left">상품유형</td>
          									<td style="padding-left:20px;line-height:27px;" colspan="3" align="left" id="srcGoodClasCode">
          										<label><input style="margin-top:-1px; vertical-align:middle;" type="radio" name="srcGoodClasCode" value="" <%if("".equals(srcGoodClasCode)){%>checked<%}%>/> 전체</label>
          									</td>
          								</tr>
          							</table>
          						</div>
          						<p id="searchWordTxt" class="total" style="font-size: 12pt;"></p>
          						<div class="alignIcon">
          						    <label style="float:left;margin-top:4px"><input onclick="setGoodtype(this.checked);" type="checkbox" ${param.goodtype_yn eq 'N'?'':'checked'} style="vertical-align:-2px"/> 지정자재 우선</label>
          						    <c:if test="${param.orderString eq 'TTT'}">
                                    <span style="color:#ea0001"><i class="fa fa-check"></i><a href="javascript:setOrderBy('TTT');" style="color:#ea0001;font-weight:bold">최근구매순</a></span>
                                    </c:if>
                                    <c:if test="${param.orderString ne 'TTT'}">
                                    <span>&#8226;<a href="javascript:setOrderBy('ASCII_ORDER');">최근구매순</a></span>
                                    </c:if>
          						    <c:if test="${empty param.orderString or param.orderString eq 'ASCII_ORDER'}">
          							<span style="color:#ea0001"><i class="fa fa-check"></i><a href="javascript:setOrderBy('ASCII_ORDER');" style="color:#ea0001;font-weight:bold">가나다순</a></span>
          							</c:if>
                                    <c:if test="${not (empty param.orderString or param.orderString eq 'ASCII_ORDER')}">
                                    <span>&#8226;<a href="javascript:setOrderBy('ASCII_ORDER');">가나다순</a></span>
                                    </c:if>
                                    <c:if test="${param.orderString eq 'ORDER_CNT'}">
                                    <span style="color:#ea0001"><i class="fa fa-check"></i><a href="javascript:setOrderBy('ORDER_CNT');" style="color:#ea0001;font-weight:bold">누적판매순</a></span>
          							</c:if>
                                    <c:if test="${param.orderString ne 'ORDER_CNT'}">
                                    <span>&#8226;<a href="javascript:setOrderBy('ORDER_CNT');">누적판매순</a></span>
                                    </c:if>
                                    <c:if test="${param.orderString eq 'INSERT_DATE'}">
                                    <span style="color:#ea0001"><i class="fa fa-check"></i><a href="javascript:setOrderBy('INSERT_DATE');" style="color:#ea0001;font-weight:bold">최신등록순</a></span>
                                    </c:if>
                                    <c:if test="${param.orderString ne 'INSERT_DATE'}">
                                    <span>&#8226;<a href="javascript:setOrderBy('INSERT_DATE');">최신등록순</a></span>
                                    </c:if>
          							<input type="hidden" id="orderString" name="orderString" value="" />
                                    <input type="hidden" id="goodtype_yn" name="goodtype_yn" value="${param.goodtype_yn}" />
          							<select id="pCnt" style="width:70px;" class="pdtList" onchange="javascript:fnSearch();">
            							<option <%if(30 == currCnt){ %> selected="selected" <%}%> value="30">30개씩 보기</option>
            							<option <%if(60 == currCnt){ %> selected="selected" <%}%> value="60">60개씩 보기</option>
            							<option <%if(90 == currCnt){ %> selected="selected" <%}%> value="90">90개씩 보기</option>
          							</select>
            						<a href="#;"><img id="listView" src="/img/contents/btn_imgList_on.gif" /></a>
            						<a href="#;"><img id="gridView" src="/img/contents/btn_testList_off.gif" /></a>
            					</div>
          						<div class="ListTab">
            						<a href="javascript:void(0);" id="goToPrevSlide" class="back"><img src="/img/contents/tab_back.png" /></a>
            						<div class="slid">
            							<ul id="responsive">
            							
            								<li>
            									<span id="cateAll" class="cateSpan_ On" onclick="javascript:fnSearchCate('','', '');"><a href="#;" >전체</a></span>
            								</li>
<%
int cateIdx = 1;
for(int i = 0 ; i < cate.size() ; i++){
	String topCateName = ""; 
	String topCateId = "";
	if(i == 0){
		topCateName = CommonUtils.getString(cate.get(i).get("TOP_CATE_NAME"));
		topCateId = CommonUtils.getString(cate.get(i).get("TOP_CATE_ID"));
	}else{
		if(CommonUtils.getString(cate.get(i-1).get("TOP_CATE_NAME")).equals(CommonUtils.getString(cate.get(i).get("TOP_CATE_NAME")))){
			topCateName = "";	
			topCateId = "";	
		}else{
			topCateName = CommonUtils.getString(cate.get(i).get("TOP_CATE_NAME"));	
			topCateId = CommonUtils.getString(cate.get(i).get("TOP_CATE_ID"));	
		}
	}
	if(!"".equals(topCateName)){
		String sClass = "";
		if(topCateId.equals(setCateId)) {
			sClass = "On";
%>
										<script type="text/javascript">
											$("#cateAll").prop("class", "");
										</script>
<%			
		}
%>										
              								<li>
              									<span class="cateSpan_<%=topCateId%> <%=sClass%>" onclick="javascript:fnSearchCate('<%=topCateId%>','', '');"><a href="#;"><%=topCateName %></a></span>
              								</li>
<%		
		cateIdx++;
	}
}
%>
											<%// slide 작업시 마지막 li가 보이지 않는 문제가 발생하여 더미 데이터 등록 %>            						
              								<li>
              									<span>&nbsp;</span>
              								</li>
										</ul>
            						</div>
            						<a href="javascript:void(0);" id="goToNextSlide" class="next"><img src="/img/contents/tab_next.png" /></a>
          						</div>
          						<table class="SRCTable pdtList" >
          							<colgroup>
            							<col width="459px" />
            							<col width="150px" />
            							<col width="165px" />
          							</colgroup>
<%
	if(list != null && list.size() > 0){
		int cnt = 0;
		for(Map<String, Object> pdtMap : list){
			List<Map<String, Object>> infoList = (List<Map<String, Object>>)pdtMap.get("info");
			cnt++;
// 			String thumbImg = CommonUtils.getString(infoList.get(0).get("IMG_PATH"));
			String thumbImg = CommonUtils.getString(infoList.get(0).get("LARGE_IMG_PATH"));
			
			String 	 goodName     = CommonUtils.getString(pdtMap.get("GOOD_NAME"));
			String 	 goodSpec	  = CommonUtils.getString(pdtMap.get("GOOD_SPEC"));
			String	 goodIdenNumb = CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"));
			
			String[] prevWords = prevWord.split("\\‡");
			
			for(int i = 0 ; i < prevWords.length ; i++){
				if(prevWords[i].startsWith("＋")){
					String oldChar = prevWords[i].replace("＋", "");
					if(!"".equals(oldChar)){
						goodName = goodName.replace(oldChar, "<font size='3px;' color='red'>"+oldChar+"</font>");
					}
				}
			}
			
			if(!"".equals(srcGoodName)){
				goodName = goodName.replace(srcGoodName.toUpperCase(), "<font size='3px;' color='red'>"+srcGoodName.toUpperCase()+"</font>");
			}
			
			System.out.println(goodName);
			
			if(!"".equals(srcGoodSpec)){
				goodSpec = goodSpec.replace(srcGoodSpec, "<font size='3px;' color='red'>"+srcGoodSpec+"</font>");
			}
			
			if(!"".equals(srcGoodIdenNumb)){
				goodIdenNumb = goodIdenNumb.replace(srcGoodIdenNumb, "<font size='3px;' color='red'>"+srcGoodIdenNumb+"</font>");
			}
%>
          							<tr>
            							<td>
              								<dl>
                								<dt>
                									<a href="javascript:fnProductDetail('<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"))%>', '<%=cnt%>');" >
                										<img id="productImg_<%=cnt%>" src="/upload/image/<%=thumbImg %>" width="100px;" height="100px;" onerror="this.src='/img/layout/img_null.jpg';"/>
                									</a>
                								</dt>
                								<dd>
                									<p class="bold">
                										<a href="javascript:fnProductDetail('<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"))%>', '<%=cnt%>');" ><font color="black"><%=goodName %></font></a>
                									</p>
                  									<ul>
                    									<li style="width:100%;font-weight: 900;" >규격&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <strong><%=goodSpec%></strong></li>
                    									<li>상품코드 : <strong><%=goodIdenNumb %></strong></li>
                    									<li>표준납기일 : <strong id="deliMiniDayTxt_<%=cnt%>"><%=CommonUtils.getString(infoList.get(0).get("DELI_MINI_DAY")) %> 일</strong></li>
                    									<li style="font-weight: 900;">제조원&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <strong id="makeCompNameTxt_<%=cnt%>"><%=CommonUtils.getString(infoList.get(0).get("MAKE_COMP_NAME")) %></strong></li>
<%if( "Y".equals(CommonUtils.getString(pdtMap.get("REPRE_GOOD")))  == false){  //옵션상품이 아닐때만 최소구매수량 출력 %>
                    									<li>최소구매수량 : <strong id="minOrdQuanTxt_<%=cnt%>"><%=CommonUtils.getString(infoList.get(0).get("DELI_MINI_QUAN")) %> 개</strong></li>
<%}else{ %>
                                                                        <strong id="minOrdQuanTxt_<%=cnt%>" style="display: none"></strong>
<%} %>
                    									<li style="font-weight: 900;">공급가&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 
                    										<strong>
                    											<span class="bold" id="sellPriceTxt_<%=cnt%>"><%=CommonUtils.getIntString(infoList.get(0).get("SELL_PRICE")) %> 원</span>
                    										</strong>
                    									</li>
                   									</ul>
<%--                   									<span class="bold" id="sellPriceTxt_<%=cnt%>"><%=CommonUtils.getIntString(infoList.get(0).get("SELL_PRICE")) %> 원</span> --%>
                  								</dd>
                							</dl>
<%
			String appDispStr = "none";
			String addDispStr = "none";
			String optDispStr = "none";
		
			if("20".equals(CommonUtils.getString(pdtMap.get("GOOD_TYPE")))) appDispStr = "display";
			if("Y".equals(CommonUtils.getString(pdtMap.get("ADD_GOOD")))) addDispStr = "display";
			if("Y".equals(CommonUtils.getString(pdtMap.get("REPRE_GOOD")))) optDispStr = "display";
%>
                                        <div class="label" >
                                            <span class="add" style="display: <%=addDispStr%>;cursor: text;">추가</span>
                                            <span class="option" style="display: <%=optDispStr %>;cursor: text;">옵션</span>
                                            <span class="appoint" style="display: <%=appDispStr %>;cursor: text;">지정</span>
                                        </div>
              							</td>
            							<td>
              								<ul>
              								
<%			int infoCnt = 0;
			int deliMiniQuan = 0;
			if(infoList != null && infoList.size() > 0 ){
				for(Map<String, Object> infoMap : infoList){
					String eVendorId = CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB")) +"_"+ infoMap.get("VENDORID");
					if(infoCnt == 0){
						try{
                               BigDecimal deliMiniQuanBD = (BigDecimal)infoMap.get("DELI_MINI_QUAN"); 
                               deliMiniQuan = deliMiniQuanBD.intValue();
						}catch(Exception e){
                               deliMiniQuan = 0;
						}
					}
					
					String vendorNm = CommonUtils.getString(infoMap.get("VENDORNM"));
					if(!"".equals(srcVendorNm)){
						vendorNm = vendorNm.replace(srcVendorNm, "<font size='3px;' color='red'>"+srcVendorNm+"</font>");
					}					
%>
                								<li>
                									<input type="radio" name="<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB")) %>" id="<%=eVendorId %>" value="<%=eVendorId %>"  style="vertical-align: bottom;"
                											<%if(infoCnt == 0 ){ %> checked="checked" <%}%> onclick="javascript:fnSelectVendor('<%=eVendorId %>', '<%=cnt%>');" />
                									<label for="radio" style="cursor: pointer;" onclick="javascript:fnSelectVendor('<%=eVendorId %>', '<%=cnt%>');"><%=vendorNm %></label>
                								</li>
<%					
					infoCnt++;
				}
			}	
%>              								
                							</ul>
              							</td>
            							<td class="count">
            								<input type="hidden" name="minOrdQuan_<%=cnt%>" 		id="minOrdQuan_<%=cnt%>" 		value="<%=CommonUtils.getString(infoList.get(0).get("DELI_MINI_QUAN"))%>"/>
            								<input type="hidden" name="selVenderId_<%=cnt%>" 		id="selVenderId_<%=cnt%>" 		value="<%=CommonUtils.getString(infoList.get(0).get("VENDORID"))%>"/>
            								<input type="hidden" name="selGoodIdenNumb_<%=cnt%>" 	id="selGoodIdenNumb_<%=cnt%>" 	value="<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"))%>"/>
            								<input type="hidden" name="addGoodYn_<%=cnt%>" 			id="addGoodYn_<%=cnt%>" 		value="<%=CommonUtils.getString(pdtMap.get("ADD_GOOD"))%>"/>
            								<input type="hidden" name="repreGoodYn_<%=cnt%>" 		id="repreGoodYn_<%=cnt%>" 		value="<%=CommonUtils.getString(pdtMap.get("REPRE_GOOD"))%>"/>
              								<ul>
                								<li>재고 : <span><strong class="f16" id="goodInvCntTxt_<%=cnt%>"><%=CommonUtils.getIntString(infoList.get(0).get("GOOD_INVENTORY_CNT")) %></strong> 개</span></li>
<%
			if(!"Y".equals(CommonUtils.getString(pdtMap.get("REPRE_GOOD")))){
%>
<%--                 								<li>수량 : <span><input id="inputQuan_<%=cnt%>" name="inputQuan_<%=cnt%>"  value="<%=deliMiniQuan %>" maxlength="9" --%>
                								<li>수량 : <span>
                                            <input type="checkbox" style="margin-right:5px;vertical-align:-4px"/><input id="inputQuan_<%=cnt%>" name="inputQuan_<%=cnt%>"  value="" maxlength="9"
                													type="text" style="width:50px;text-align: right;"  onkeydown="return onlyNumber(event)"/> 개</span></li>
<%					
			}


			String btnImgPath = "btn_basket.gif";
			if("Y".equals(CommonUtils.getString(pdtMap.get("ADD_GOOD")))) btnImgPath = "btn_basket_add1.gif";
			if("Y".equals(CommonUtils.getString(pdtMap.get("REPRE_GOOD")))) btnImgPath = "btn_basket_opt.gif";
%>                								
                								<li class="mgt_15">
                									<a href="#;"><img onclick="javascript:fnPopCartInfo('<%=cnt%>');" src="/img/contents/<%=btnImgPath%>" /></a>
                									<a href="#;"><img onclick="javascript:fnSetUserGood('<%=cnt%>');" src="/img/contents/btn_favorite.gif" /></a>
                								</li>
                							</ul>
              							</td>
          							</tr>
<%			
		}
	}else{
%>
									<tr>
										<td align="center" colspan="3"><b>조회된 상품이 없습니다.</b></td>
									</tr>

<%		
	}
%>          							
          						</table>
          
      					<!--페이징 -->
      							
							<span class="pdtList"> <%@ include file="/WEB-INF/jsp/common/pager.jsp" %> </span>
      					<!--// 페이징 -->
							      					
      						<div id="jqgrid" class="pdtGrid" style="display: none;">
								<table id="pdtGridList"></table>
								<div id="pdtGgridPager"></div>
							</div>
      					</div>
      					<!--//내용변경되는 부분-->
                        <div id="chk-cart">선택상품 장바구니</div>
    				</div>
    			<!--컨텐츠(E)-->
    			</div>
        		<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
    		</div>
    	<hr>
    </div>
</body>

<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>

<script>
var viewFlag = "list";  // list, grid 
$(document).ready(function() {
	
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});

	$("#prevWord").val("<%=prevWord%>");
	$("#inputWord").blur();
	$("#searchType1").prop("checked", true);
	$("#searchType2").prop("checked", false);
	
	$("#listView").click(function(){ 
		fnSetList("list"); 
	});
	$("#gridView").click(function(){
		$("#searchType1").prop("checked","checked");
		fnSetList("grid"); 
	});
	
	fnSetSearchWordTxt();
	    
	$("#inputWord").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});

	$("#srcGoodName").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
	$("#srcGoodSpec").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
	$("#srcVendorNm").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
	$("#srcGoodIdenNumb").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
	
	
	var responsive = $('#responsive').lightSlider({
		autoWidth : true,
        item      : 10,
        loop      : false,
        slideMove : 1,
        slideMargin : 0,
        speed     : 600,
        pager     : false,
        controls  : false
    });
	
	$('#goToPrevSlide').click(function(){
		responsive.goToPrevSlide(); 
    });
	
	$('#goToNextSlide').click(function(){
		responsive.goToNextSlide(); 
    });
	
//	responsive.goToSlide(<%=cateIdx%>);
// 	responsive.goToSlide(0);
//  	responsive.goToSlide(1);
	
	$("#allExcelButton").click(function(){
		var colLabels = ["상품코드","상품명","규격","상품구분","판매단가","재고수량","최소구매수량","공급사","제조사","판매수","등록일"];
		var colIds = ["GOOD_IDEN_NUMB","GOOD_NAME","GOOD_SPEC","GOOD_TYPE","SELL_PRICE","GOOD_INVENTORY_CNT","DELI_MINI_DAY","VENDORNM","MAKE_COMP_NAME","ORDER_CNT","INSERT_DATE_STRING"];
		var numColIds = ["SELL_PRICE","DELI_MINI_DAY"];
		var sheetTitle = "상품검색";	//sheet 타이틀
		var excelFileName = "productSearchResult";	//file명
		var fieldSearchParamArray = new Array();
	    fieldSearchParamArray[0] = 'prevWord';
	    fieldSearchParamArray[1] = 'srcCateId';
	    fnExportExcelToSvc('', colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,"/buyProduct/productResultListExcel.sys");
	});
	fnDataInit();
});

function fnSrcWordDel(index){
	var srcTextTemp  = $.trim($("#prevWord").val());
	var srcTextTempArr = srcTextTemp.split("‡");
	srcTextTempArr.splice(index,1);
	var srcTextTempReuslt = "";
	for(var i =0 ; i < srcTextTempArr.length; i++){
		if(i==0){
            srcTextTempReuslt = srcTextTempArr[i];
		}else{
            srcTextTempReuslt += "‡"+srcTextTempArr[i];
		}
	}
	
	if(srcTextTempReuslt.indexOf('＋') == -1){
        srcTextTempReuslt = "";
	}
	
	
	$("#prevWord").val(srcTextTempReuslt);
	$.blockUI({});
	var searchType = 'Y';
	
	if(viewFlag=="grid"){
		$("#pdtGridList").jqGrid("setGridParam", {"page":1});
		var data = $("#pdtGridList").jqGrid("getGridParam", "postData");
		data.searchType	= searchType;
		data.inputWord	= $.trim($('#inputWord').val());
		data.prevWord	= $.trim($('#prevWord').val());
		data.srcCateId	= $.trim($('#srcCateId').val());
		data.setCateId	= $.trim($('#setCateId').val());
		data.orderString= $.trim($('#orderString').val());
		$("#pdtGridList").jqGrid("setGridParam", { postData: data, datatype:"json"});
		$("#pdtGridList").trigger("reloadGrid");
		$.unblockUI();
	}else{//list
		var params = "";
		params += "searchType=" + searchType;
		params += "&inputWord=" + $.trim($('#inputWord').val());
		params += "&prevWord="  + $.trim($('#prevWord').val());
		params += "&srcCateId=" + $.trim($('#srcCateId').val());
		params += "&setCateId=" + $.trim($('#setCateId').val());
		params += "&orderString=" + $.trim($('#orderString').val());
		params += "&pCnt="  + ($.trim($('#pCnt').val()) == "" ? 30 : $.trim($('#pCnt').val()));
		params += "&pIdx="  + ($.trim($('#pIdx').val()) == "" ? 1 : $.trim($('#pIdx').val()));
		fnDynamicForm("/buyProduct/productResultList.sys", params,"");
	}
}

function fnSetSearchWordTxt(){
	var prevWordArray = $.trim($("#prevWord").val()).split("‡");
	var sSearchWordTxt = "";
	var eSearchWordTxt = "";
	var sPrefix = "";
	var ePrefix = "";
	var eCnt = 0;
	var sCnt = 0;
	
	for(var i = 0 ; i < prevWordArray.length ; i++){
		if(prevWordArray[i].indexOf('＋') > -1){
			
			if(sCnt != 0) sPrefix = ",";
			if(prevWordArray[i].substring(1) != ''){
// 				sSearchWordTxt += sPrefix + " '" + prevWordArray[i].substring(1) + "'";
				sSearchWordTxt += sPrefix + " '" + prevWordArray[i].substring(1) + "' <a href='javascript:fnSrcWordDel(\""+i+"\")'><img src='/img/FR/close_icon.gif' width='15px' heigth='15px' /></a>";
				sCnt++;
			}else{
				sSearchWordTxt += '';
			}
		}
		
		if(prevWordArray[i].indexOf('－') > -1){
			if(eCnt != 0) ePrefix = ",";
			if(prevWordArray[i].substring(1) != ''){
// 				eSearchWordTxt += ePrefix + " '" + prevWordArray[i].substring(1) + "'";
				eSearchWordTxt += ePrefix + " '" + prevWordArray[i].substring(1) + "' <a href='javascript:fnSrcWordDel(\""+i+"\")'><img src='/img/FR/close_icon.gif' width='15px' heigth='15px' /></a>";
				eCnt++;
			}else{
				eSearchWordTxt += '';
			}
		}
	}
	
	var resultTxt = "";
	
	if(sCnt > 0 || eCnt > 0){
		if(eCnt == 0) 	resultTxt = "<strong>"+sSearchWordTxt + "</strong> 의 검색결과";
		else {
			if(sSearchWordTxt=='') {
				resultTxt = "<strong>" + eSearchWordTxt + "</strong> 을(를) 제외한 검색결과";
			} else {
				resultTxt = "<strong>"+sSearchWordTxt + "</strong> 중 <strong>" + eSearchWordTxt + "</strong> 을(를) 제외한 검색결과";
			}
		}
// 		resultTxt += "(총 39개 카테고리/전체 <strong>253,315</strong>개 상품)";
	}else{
		resultTxt = "&nbsp;";
	}
	
	$("#searchWordTxt").html(resultTxt);
}
// list,grid 목록 
function fnSetList(flag){
	viewFlag = flag;
	if(viewFlag =="grid"){
		$("#gridView").attr("src","/img/contents/btn_testList_on.gif");
		$("#listView").attr("src","/img/contents/btn_imgList_off.gif");
		$(".pdtGrid").show();
		$(".pdtList").hide();
		fnSearch();
	}else{//list
		if($("#searchType1").prop("checked")==false && $("#searchType2").prop("checked") == false){
			$("#searchType1").prop("checked",true);
		}
		$('#pIdx').val("1");
		fnSearch();
	}
}


//3자리수마다 콤마
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
	n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}


function fnSearchType(kind){
	if(kind == '1'){
		$("#searchType2").prop("checked", false);
	}else if(kind == '2'){
		$("#searchType1").prop("checked", false);
	}
}

function setOrderBy(orderString){
	$("#orderString").val(orderString);
	fnSearch();
}

function setGoodtype(yn){
    $("#goodtype_yn").val(yn ? 'Y':'N');
    fnSearch();
}

function fnSearch(){
	$.blockUI({});
	var searchType = 'N';
	
	if($("#searchType1").prop("checked") || $("#searchType2").prop("checked")){
		if($("#searchType1").prop("checked")){
			$("#prevWord").val($("#prevWord").val() + "‡＋" + $("#inputWord").val());
			searchType = 'Y';
		}
		
		if($("#searchType2").prop("checked")){
			$("#prevWord").val($("#prevWord").val() + "‡－" + $("#inputWord").val());
			searchType = 'Y';
		}
	}else{
		$("#prevWord").val("＋"+$("#inputWord").val());
	}
	
	var srcGoodClasCode = $(":radio[name='srcGoodClasCode']:checked").val();

	if(viewFlag=="grid"){
		$("#pdtGridList").jqGrid("setGridParam", {"page":1});
		var data = $("#pdtGridList").jqGrid("getGridParam", "postData");
		data.searchType		= searchType;
		data.inputWord		= $.trim($('#inputWord').val());
		data.prevWord		= $.trim($('#prevWord').val());
		data.srcCateId		= $.trim($('#srcCateId').val());
		data.setCateId		= $.trim($('#setCateId').val());
		data.srcGoodName	= $.trim($('#srcGoodName').val());
		data.srcGoodSpec	= $.trim($('#srcGoodSpec').val());
		data.srcGoodIdenNumb= $.trim($('#srcGoodIdenNumb').val());
		data.srcVendorNm	= $.trim($('#srcVendorNm').val());
		data.srcGoodClasCode= srcGoodClasCode;
	
		
		data.goodtype_yn	= $.trim($('#goodtype_yn').val());
        data.orderString    = $.trim($('#orderString').val());
		$("#pdtGridList").jqGrid("setGridParam", { postData: data, datatype:"json"});
		$("#pdtGridList").trigger("reloadGrid");
		$.unblockUI();
	}else{//list
		var params = "";
		params += "searchType=" 	 + searchType;
		params += "&inputWord=" 	 + $.trim($('#inputWord').val());
		params += "&prevWord="  	 + $.trim($('#prevWord').val());
		params += "&srcCateId=" 	 + $.trim($('#srcCateId').val());
		params += "&setCateId=" 	 + $.trim($('#setCateId').val());
		params += "&orderString=" 	 + $.trim($('#orderString').val());
        params += "&goodtype_yn="    + $.trim($('#goodtype_yn').val());
		params += "&srcGoodName="	 + $.trim($('#srcGoodName').val());
		params += "&srcGoodSpec="	 + $.trim($('#srcGoodSpec').val());
		params += "&srcGoodIdenNumb="+ $.trim($('#srcGoodIdenNumb').val());
		params += "&srcVendorNm="	 + $.trim($('#srcVendorNm').val());
		params += "&srcGoodClasCode="+ srcGoodClasCode;
		params += "&pCnt="  + ($.trim($('#pCnt').val()) == "" ? 30 : $.trim($('#pCnt').val()));
		params += "&pIdx="  + ($.trim($('#pIdx').val()) == "" ? 1 : $.trim($('#pIdx').val()));
		fnDynamicForm("/buyProduct/productResultList.sys", params,"");
	}
}

function fnPageSearch(pagingFlag){
	$.blockUI({});
	
	var searchType = 'Y';

	if($.trim($("#inputWord").val()) != ''){
		$("#prevWord").val("＋"+$("#inputWord").val());
	}
	
	var params = "";
	
	var srcGoodClasCode = $(":radio[name='srcGoodClasCode']:checked").val();
	
	params += "searchType=" + searchType;
	params += "&inputWord=" + $.trim($('#inputWord').val());
	params += "&prevWord="  + $.trim($('#prevWord').val());
	params += "&srcCateId=" + $.trim($('#srcCateId').val());
	params += "&setCateId=" + $.trim($('#setCateId').val());
	params += "&orderString=" + $.trim($('#orderString').val());
	params += "&srcGoodName="	 + $.trim($('#srcGoodName').val());
	params += "&srcGoodSpec="	 + $.trim($('#srcGoodSpec').val());
	params += "&srcGoodIdenNumb="+ $.trim($('#srcGoodIdenNumb').val());
	params += "&srcVendorNm="	 + $.trim($('#srcVendorNm').val());
	params += "&srcGoodClasCode="+ srcGoodClasCode;	
	
	params += "&pCnt="  + ($.trim($('#pCnt').val()) == "" ? 30 : $.trim($('#pCnt').val()));
	params += "&pIdx="  + ($.trim($('#pIdx').val()) == "" ? 1 : $.trim($('#pIdx').val()));
	
	fnDynamicForm("/buyProduct/productResultList.sys", params,"");
}

function fnGoPage(){
	fnPageSearch();
	
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
           	$("#makeCompNameTxt_" + cnt).html(resultMap.MAKE_COMP_NAME);
           	$("#minOrdQuanTxt_" + cnt).html(resultMap.DELI_MINI_QUAN+" 개");
           	$("#deliMiniDayTxt_"+cnt).html(resultMap.DELI_MINI_DAY + " 일");
           	$("#sellPriceTxt_"+cnt).html(fnComma(Math.round(resultMap.SELL_PRICE))+" 원");
           	$("#goodInvCntTxt_"+cnt).html(fnComma(resultMap.GOOD_INVENTORY_CNT));
           	$("#selVenderId_"+cnt).val(vendorId);
           	$("#productImg_"+cnt).attr("src", "/upload/image/"+resultMap.SM_IMG_PATH);
           	
           	if(resultMap.GOOD_CLAS_CODE == '10'){
           		$("#appointDiv").show();
           	}else{
           		$("#appointDiv").hide();
           	}
           	
//            	if(resultMap.REPRE_GOOD != 'Y'){
//                 $("#inputQuan_"+cnt).val(resultMap.DELI_MINI_QUAN);
//            	}
           	
           	$.unblockUI();
    	}
	);	
}




function fnPopCartInfo(cnt){
	var vendorId 	 = "";
	var goodIdenNumb = "";
	var quan 		 = "";
	var addGoodYn	 = "";
	var repreGoodYn  = "";
	if(viewFlag=='grid'){ // grid일때 cnt == rowid
		$("#pdtGridList").restoreRow(cnt);
		var selrowContent = $("#pdtGridList").jqGrid('getRowData',cnt);
		vendorId 	 = selrowContent.VENDORID;
		goodIdenNumb = selrowContent.GOOD_IDEN_NUMB;
		quan 		 = selrowContent.QUAN;
		addGoodYn	 = selrowContent.ADD_GOOD;
		repreGoodYn  = selrowContent.REPRE_GOOD;
		if(selrowContent.REPRE_GOOD=='N' ){
			$('#pdtGridList').editRow(cnt);  
		}
	}else{//list
		vendorId 	 = $("#selVenderId_" + cnt).val();
		goodIdenNumb = $("#selGoodIdenNumb_" + cnt).val();
		quan 		 = $("#inputQuan_" + cnt).val();
		addGoodYn	 = $("#addGoodYn_"+cnt).val();
		repreGoodYn  = $("#repreGoodYn_"+cnt).val();
	}

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

function fnProductDetail(goodIdenNumb, cnt){
	vendorId 	 = $("#selVenderId_" + cnt).val();
	fnProductDetailPop(goodIdenNumb, vendorId);
}

function fnSetUserGood(cnt){
	var goodIdenNumb;
	
	if(viewFlag=='grid'){ // grid일때 cnt == rowid
		var selrowContent = $("#pdtGridList").jqGrid('getRowData',cnt);
		goodIdenNumb = selrowContent.GOOD_IDEN_NUMB;
	}else{//list
		goodIdenNumb = $("#selGoodIdenNumb_" + cnt).val();
	}

	fnPopSetUserGood(goodIdenNumb);
		
}

function fnSearchCate(topCateId, midCateId, dtlCateId){
	var srcCateId = topCateId;
	
	if(midCateId != ''){
		srcCateId = midCateId;
	}
	
	if(dtlCateId != ''){
		srcCateId = dtlCateId;
	}
	
	$("#srcCateId").val(srcCateId);
	$("#setCateId").val(topCateId);
	if(viewFlag=='grid'){
		$("[class^=cateSpan_]").removeClass("On");	
		$(".cateSpan_"+topCateId).addClass("On");
	}
	fnSearch();	
}
		
function fnCategoryDivShow(id){
	$.each($(".CategoryDiv"), function(){
		$(this).attr("style", "display:none");
	});
	
	var position        = $("#" + id + "li").position();
	var top             = position.top;
// 	var top             = position.top + 70;
	var viewPercentInfo = null;
	var vertical        = null;
	var height          = null;
	
	document.getElementById(id).style.top     = top + "px";
	document.getElementById(id).style.display = "block";
	
	height          = $("#" + id).height();
	viewPercentInfo = fnViewPercent(id);
	vertical        = viewPercentInfo.vertical;
	
	if(vertical < 100){
		top = (top - (height * (100 - vertical)) / 100) - 30;
		
		if(top < 0){
			top = 0;
		}
		
		document.getElementById(id).style.top = top + "px";
	}
}

<%-- 상품검색 결과를 그리드로 볼 경우 진열되는 테이블 --%>
$(function() {
	$("#pdtGridList").jqGrid({
		url:'/buyProduct/productResultGridList.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:['상품코드','상품정보<br/>[상품명/규격/공급사]','상품구분','금액<br/>(표준납기일)','수량','버튼','VENDORID','ADD_GOOD','REPRE_GOOD','DELI_MINI_QUAN'],
		colModel:[
			{name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:100,align:"center"},	//상품코드
			{name:'GOOD_INFO',index:'GOOD_INFO', width:320,align:"left"},	//상품정보
			{name:'PDT_STATE',index:'PDT_STATE', width:70,align:"center"},	//상품구분
			{name:'SELL_PRICE',index:'SELL_PRICE', width:130,align:"right"} ,//금액
			{name:'QUAN',index:'QUAN', width:80,align:"center", width:80,search:false,sortable:false, editable:true,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },				
				editoptions:{
					maxlength:10,
					dataInit:function(elem){
						$(elem).numeric();
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "right");
					}	
					,dataEvents:[{
						type:'change',
						fn:function(e){
							var rowid = (this.id).split("_")[0];
							var inputValue = Number(this.value); 											// 입력수량
							var selrowContent = $("#pdtGridList").jqGrid('getRowData',rowid);
							var deliMiniQuan = Number(selrowContent.DELI_MINI_QUAN);
							if( inputValue < deliMiniQuan  ){
								alert("최소 구매수량이상( "+deliMiniQuan+" ) 입력이 가능합니다.");
								inputValue = deliMiniQuan;
							}
							$("#pdtGridList").restoreRow(rowid);
							$("#pdtGridList").jqGrid('setRowData', rowid, {QUAN:inputValue});
							$('#pdtGridList').editRow(rowid);
						}
					}]
				}
			},
			{name:'BTN',width:70,align:'center'},//버튼
			{name:'VENDORID',hidden:true},
			{name:'ADD_GOOD',hidden:true},
			{name:'REPRE_GOOD',hidden:true},
			{name:'DELI_MINI_QUAN',hidden:true}
		],
		postData: {},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pdtGgridPager',
		height: 500,width: 825,
		sortname: '', sortorder: "",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			FnUpdatePagerIcons(this);
			var rowCnt = $("#pdtGridList").getGridParam('reccount');
			if(rowCnt>0) {
				var selrowContent, rowid ;
				for(var i=0; i<rowCnt; i++) {
					rowid = $("#pdtGridList").getDataIDs()[i];
					selrowContent = $("#pdtGridList").jqGrid('getRowData',rowid);
					if(selrowContent.REPRE_GOOD=='N' ){
						$('#pdtGridList').editRow(rowid);  
					}
				}
			}
			
			fnSetSearchWordTxt();
			$("#inputWord").val("");
// 			$("#searchType1").prop("checked",false);
// 			$("#searchTyp21").prop("checked",false);
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow: function(rowid, aData) {
			//btn
			var btn	= '<button onclick="javascript:fnPopCartInfo('+rowid+');" class="btn btn-danger btn-xs" >장바구니</button><br/>';
			btn	   += '<button onclick="javascript:fnSetUserGood('+rowid+');" class="btn btn-default btn-xs" >관심상품</button>'; 
			$(this).setCell(rowid, 'BTN', btn);
			
			$(this).setCell(rowid,'GOOD_IDEN_NUMB','',{color:'#0000ff',cursor:'pointer'});
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = $("#pdtGridList").jqGrid('getRowData',rowid);
			var cm = $("#pdtGridList").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['name']=="GOOD_IDEN_NUMB" ) {
				fnProductDetailPop(selrowContent.GOOD_IDEN_NUMB , selrowContent.VENDORID);
			}
			
		},
		loadError : function(xhr, st, str){ $("#pdtGridList").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}); 

//코드 데이터 초기화 
function fnDataInit(){
     $.post(  //조회조건의 품목유형1 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"ORDERGOODSTYPE",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             var srcGoodClasCode = '<%=srcGoodClasCode%>';
             for(var i=0;i<codeList.length;i++) {
            	 if(codeList[i].codeVal1 == srcGoodClasCode){
	                 $("#srcGoodClasCode").append('<label><input type="radio" checked style="margin-top:-3px; vertical-align:middle;" name="srcGoodClasCode" value="'+codeList[i].codeVal1+'"/> '+codeList[i].codeNm1+'</label>');
            	 }else{
            		 $("#srcGoodClasCode").append('<label><input type="radio" style="margin-top:-3px; vertical-align:middle;" name="srcGoodClasCode" value="'+codeList[i].codeVal1+'"/> '+codeList[i].codeNm1+'</label>');
            	 }
             }
         }
     );
}
</script>
<%// slider start! %>
<link type="text/css" rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/lightslider.css" />
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/lightslider.js" type="text/javascript"></script>
<%// slider end! %>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>
</html>