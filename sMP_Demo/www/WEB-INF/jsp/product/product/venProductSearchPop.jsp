<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.HashSet"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="kr.co.bitcube.product.dto.ProductDto"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@page import="java.util.Map"%>
<%@page import="java.math.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String inputWord = CommonUtils.getString(request.getParameter("inputWord"));
	String prevWord = CommonUtils.getString(request.getParameter("prevWord"));
	String srcCateId = CommonUtils.getString(request.getParameter("srcCateId"));
	String setCateId = CommonUtils.getString(request.getParameter("setCateId"));

	
	List<Map<String, Object>> list = (List<Map<String, Object>>)request.getAttribute("list");
	List<Map<String, Object>> cate = (List<Map<String, Object>>)session.getAttribute("cate");
	double currCnt = Double.parseDouble(CommonUtils.nvl(CommonUtils.getString(request.getAttribute("pCnt")), "0"));
	
	if("".equals(prevWord)){
		prevWord = "＋" + inputWord; 
	}
	
%>
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<link rel="stylesheet" href="/jq/assets/css/ace.min.css" id="main-ace-style" />
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<%-- <%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %> --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
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

.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:2px;
    padding-left:2px;
    padding-top:4px;
    padding-bottom:4px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}
.ui-jqgrid tr.jqgrow td {
	font-weight: normal; 
	overflow: hidden; 
	white-space: nowrap; 
	height:50px; 
	padding: 0 2px 0 2px;
	border-bottom-width: 1px; 
/*  	border-bottom-color: inherit;	 */
 	border-bottom-style: solid;
}
</style>
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
						<h2 onmouseover="javascript:fnCategoryDivShow('CategoryAll');" id="CategoryAllli" onmouseout="javascript:document.getElementById('CategoryAll').style.display='none';">
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
		Map<String, Object> cateInfo          = null;
		Map<String, Object> beforeCateInfo    = null;
		int                 i                 = 0;
		int                 cateSize          = cate.size();
	
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
			
			if(beforeTopCateId.equals(topCateId) == false){ 
%>
				<li onmouseover="javascript:fnCategoryDivShow('Category<%=topCateCd %>');" id="Category<%=topCateCd %>li" onmouseout="javascript:document.getElementById('Category<%=topCateCd %>').style.display='none';">
              		<span><%=topCateName %></span>
              	</li>
<%
			}
			
			if(beforeMidCateId.equals(midCateId) == false){
%>
				<li>
					<div>
						<a href="#;" onclick="javascript:fnSearchCate('<%=topCateId %>','<%=midCateId %>', '');" ><%=midCateName %></a>
					</div>
                </li>
<%
			}
		}
	}
%>
				<li>
					<img src="/img/layout/cs_center.gif" />
				</li>
			</ul>
		</div>
		<!--카테고리(E)-->

        				<!--컨텐츠(S)-->
        				<div id="divContainer">                    
          					<!--내용변경되는 부분-->
          					<div id="divContant">
          						<h2>상품검색</h2>
          						<div class="SRC mgb_10">
          							<input type="checkbox" 	id="searchType1"	name="searchType1" 	onclick="javascript:fnSearchType('1');"/><label>결과내재검색</label>
									<input type="checkbox" 	id="searchType2" 	name="searchType2" 	onclick="javascript:fnSearchType('2');"/><label>검색어 제외</label>
          							<input type="text" 		id="inputWord" 		name="inputWord" 	class="src" placeholder="검색어를 입력하세요" size="80" onblur="javascript:this.value = '';"/>
          							<input type="hidden" 	id="prevWord" 		name="prevWord" 	/>
          							<input type="hidden" 	id="repreGoodNumb" 	name="repreGoodNumb" 	/>
          							<input type="hidden" 	id="srcCateId" 		name="srcCateId" 	value="<%=srcCateId%>"/>
          							<input type="hidden" 	id="setCateId" 		name="setCateId" 	value="<%=setCateId%>"/>
          							<a href="#;"><img src="/img/contents/btn_search.gif" onclick="javascript:fnSearch();" /></a>
          						</div>
          						<p id="searchWordTxt" class="total"></p>
          						<div class="alignIcon"><span>&#8226;<a href="#">누적판매순</a></span><span>&#8226;<a href="#">최신등록순</a></span>
          							<select id="pCnt" style="width:70px;" class="pdtList">
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
%>
          							<tr>
            							<td>
              								<dl>
                								<dt><img src="<%=CommonUtils.getString(pdtMap.get("IMG_PATH")) %>"  onerror="this.src = '/img/layout/img_null.jpg'" /></dt>
                								<dd>
                									<p class="bold">
                										<a href="javascript:fnProductDetail('<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"))%>', '<%=cnt%>');" ><%=CommonUtils.getString(pdtMap.get("GOOD_NAME")) %></a>
                									</p>
                  									<ul>
                    									<li style="width:100%;">규격 : <strong><%=CommonUtils.getString(pdtMap.get("GOOD_SPEC"))%></strong></li>
                    									<li>상품코드 : <strong><%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB")) %></strong></li>
                    									<li>표준납기일 : <strong id="deliMiniDayTxt_<%=cnt%>"><%=CommonUtils.getString(infoList.get(0).get("DELI_MINI_DAY")) %> 일</strong></li>
                    									<li>제조원 : <strong id="makeCompNameTxt_<%=cnt%>"><%=CommonUtils.getString(infoList.get(0).get("MAKE_COMP_NAME")) %></strong></li>
                   									</ul>
                  									<span class="bold" id="sellPriceTxt_<%=cnt%>"><%=CommonUtils.getIntString(infoList.get(0).get("SELL_PRICE")) %> 원</span>
                  								</dd>
                							</dl>
<%
	String appDispStr = "none";
	String addDispStr = "none";
	String optDispStr = "none";

	if("20".equals(CommonUtils.getString(pdtMap.get("GOOD_TYPE")))) appDispStr = "inline";
	if("Y".equals(CommonUtils.getString(pdtMap.get("ADD_GOOD")))) addDispStr = "inline";
	if("Y".equals(CommonUtils.getString(pdtMap.get("REPRE_GOOD")))) optDispStr = "inline";
%>
                                            <div class="label" style="display: <%=appDispStr %>;"><span class="appoint" style="cursor: text;">지정</span></div>
                                            <div class="label" style="display: <%=addDispStr %>;"><span class="add" style="cursor: text;">추가</span></div>
                                            <div class="label" style="display: <%=optDispStr %>;"><span class="option" style="cursor: text;">옵션</span></div>									
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
%>
                								<li>
                									<input type="radio" name="<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB")) %>" id="<%=eVendorId %>" value="<%=eVendorId %>" <%if(infoCnt == 0 ){ %> checked="checked" <%}%> onclick="javascript:fnSelectVendor('<%=eVendorId %>', '<%=cnt%>');" />
                									<label for="radio" style="cursor: pointer;" onclick="javascript:fnSelectVendor('<%=eVendorId %>', '<%=cnt%>');"><%=infoMap.get("VENDORNM") %></label>
                								</li>
<%					
						infoCnt++;
					}
				}	%>              								
                							</ul>
              							</td>
            							<td class="count">
            								<input type="hidden" name="selVenderId_<%=cnt%>" 		id="selVenderId_<%=cnt%>" 		value="<%=CommonUtils.getString(infoList.get(0).get("VENDORID"))%>"/>
            								<input type="hidden" name="selGoodIdenNumb_<%=cnt%>" 	id="selGoodIdenNumb_<%=cnt%>" 	value="<%=CommonUtils.getString(pdtMap.get("GOOD_IDEN_NUMB"))%>"/>
            								<input type="hidden" name="addGoodYn_<%=cnt%>" 			id="addGoodYn_<%=cnt%>" 		value="<%=CommonUtils.getString(pdtMap.get("ADD_GOOD"))%>"/>
            								<input type="hidden" name="repreGoodYn_<%=cnt%>" 		id="repreGoodYn_<%=cnt%>" 		value="<%=CommonUtils.getString(pdtMap.get("REPRE_GOOD"))%>"/>
              								<ul>
                								<li>재고 : <span><strong class="f16" id="goodInvCntTxt_<%=cnt%>"><%=CommonUtils.getIntString(infoList.get(0).get("GOOD_INVENTORY_CNT")) %></strong> 개</span></li>
<%
				if(!"Y".equals(CommonUtils.getString(pdtMap.get("REPRE_GOOD")))){
%>
                								<li>수량 : <span><input id="inputQuan_<%=cnt%>" name="inputQuan_<%=cnt%>"  value="<%=deliMiniQuan %>" maxlength="9"
                													type="text" style="width:50px;text-align: right;"  onkeydown="return onlyNumber(event)"/> 개</span></li>
<%					
				}
%>                								
                								<li class="mgt_15">
                									<a href="#;"><img onclick="javascript:fnPopCartInfo('<%=cnt%>');" src="/img/contents/btn_basket.gif" /></a>
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
    				</div>
    			<!--컨텐츠(E)-->
    			</div>
        		<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
    		</div>
    	<hr>
    </div>
    <!-- 옵션팝업 -->
    <div id="optionPop" class="jqmPop">
    	<div id="optionPopDrag">
		  	<div id="divPopup" style="width: 600px;">
		  		<div id="popDrag1">
			  		<h1>옵션선택<a href="#;"><img id="optionCloseButton1" src="/img/contents/btn_close.png"></a></h1>
		  		</div>
		    	<div class="popcont">
		      		<table class="InputTable" id="commonOptTable"></table>
		      		<div class="GridList">
						<table>
							<tr>
				            	<td>
				               		<div id="jqgrid">
				                  		<table id="list"></table>
				               		</div>
				            	</td>
				         	</tr>		        			
		      			</table>
		      		</div>
		      		<div class="Ac mgt_10">
<%-- 		      			<a id='newSpecReqButton' 	class="btn btn-warning btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-save"></i>신규규격요청</a> --%>
<%-- 		      			<a id='saveCartButton'   	class="btn btn-warning btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-save"></i>장바구니 담기</a> --%>
		      			<a id='newSpecReqButton' 	class="btn btn-warning btn-xs"><i class="fa fa-save"></i>신규규격요청</a>
		      			<a id='saveOptCartButton'  	class="btn btn-warning btn-xs"><i class="fa fa-save"></i>장바구니 담기</a>
		      			<a id='optionCloseButton2'  class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
		      		</div>
		    	</div>
		  	</div>
	  	</div>  
  	</div>
  	
    <div id="addPop" class="jqmPop">
    	<div id="addPopDrag">
  			<div id="divPopup" style="width:600px;">
  				<div id="popDrag2">
	  				<h1>추가상품 선택<a href="#;"><img id="addCloseButton1" src="/img/contents/btn_close.png"></a></h1>
  				</div>
    			<div class="popcont">
    				<table class="SRCTable" id="addPdtTable"></table>
    				<div class="Ac mgt_10">
		      			<a id='saveAddCartButton'class="btn btn-warning btn-xs"><i class="fa fa-save"></i>장바구니 담기</a>
		      			<a id='addCloseButton2'  class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
    				</div>
    			</div>
  			</div>      
    	</div>
    </div>  	
</body>

<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>
<script>
var viewFlag = "list";  // list, grid 
$(document).ready(function() {
	$('#optionPop').jqm();	//Dialog 초기화
	$("#optionCloseButton1").click(function(){$("#optionPop").jqmHide();});
	$("#optionCloseButton2").click(function(){$("#optionPop").jqmHide();});
	$('#optionPop').jqm().jqDrag('#popDrag1');

	$('#addPop').jqm();	//Dialog 초기화
	$("#addCloseButton1").click(function(){$("#addPop").jqmHide();});
	$("#addCloseButton2").click(function(){$("#addPop").jqmHide();});
	$('#addPop').jqm().jqDrag('#popDrag2');
	
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
    $("#snb").mouseover(function () {$("#snb").show();});
    $("#snb").mouseout(function () {$("#snb").hide();});
    
    $("#prevWord").val("<%=prevWord%>");
	$("#inputWord").blur();
	$("#searchType1").prop("checked", false);
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
	
	$("#saveOptCartButton").click(function(){
		var commonOptCnt = Number($("#commonOptCnt").val());
		var commonOpt = "";
		
		for(var i = 0 ; i < commonOptCnt ; i++ ){
			var optVal = $.trim($("#commonOpt_" + i).val());
			if(optVal == ''){
				alert("공통옵션을 선택해 주세요.");
				$("#commonOpt_" + i).focus();
				return;
			}
			if(i == 0)	commonOpt = optVal;
			else		commonOpt += ", "+optVal;
		}
		
		var goodNumbs = new Array();			
		var ordQuans = new Array();			
		var vendorIds = new Array();			
		var chkCnt = 0;
		var id = $("#list").getGridParam('selarrrow');
	    var ids = $("#list").jqGrid('getDataIDs');
	    var repreGoodNumb = $("#repreGoodNumb").val();

	    if(repreGoodNumb == ''){
	    	return;
	    }
	    
	    for (var i = 0; i < ids.length; i++) {
	    	var check = false;
	        $.each(id, function (index, value) {
	        	if (value == ids[i])	check = true;
	        });
	        if (check) {
	        	var rowdata = $("#list").getRowData(ids[i]);
	        	goodNumbs[chkCnt] = rowdata.GOOD_IDEN_NUMB;
	        	vendorIds[chkCnt] = rowdata.VENDORID;
// 	        	alert(vendorIds[chkCnt] = rowdata.VENDORID);
	        	
	        	if($.trim($("#setQty_"+ids[i]).val()) == ''){
	        		alert("["+rowdata.GOOD_SPEC+"] 상품의 수량을 입력해 주세요.");
	        		return;
	        	}
	        	ordQuans[chkCnt] = $("#setQty_"+ids[i]).val();
	        	chkCnt++;
	        }
	    }
	    if(chkCnt == 0){
	    	alert("옵션 상품을 선택해 주세요.");
	    	return;
	    }
	    
	    if(!confirm("해당 옵션 상품을 장바구니에 담으시겠습니까?"))return;
		
	    $.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/setCartInfo.sys',
			{	
	        	kind:"OPT",
				commonOpt:commonOpt,
				goodNumbs:goodNumbs,
	        	repreGoodNumb:repreGoodNumb,
	        	ordQuans:ordQuans,
	        	vendorIds:vendorIds
	        },
			function(arg){
	           	var result = eval('(' + arg + ')').customResponse;
	           	
	           	if(result.success){
	           		if(!confirm("장바구니로 이동하시겠습니까?"))return;
	           		fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
	           	}
	        }
		);			
	});
	
	$("#saveAddCartButton").click(function(){
		var repreGoodNumb = $("#repreGoodNumb").val();
	    if(repreGoodNumb == ''){
	    	return;
	    }
		
		var ordQuans 		= new Array();			
		var vendorIds 		= new Array();	
		var goodNumbs 		= new Array();	
		
		var selIdx = jQuery('[name=addPdtSel]:checked').val();
		
		var repreIdx = $("#repreCnt_"+selIdx).val();
		
	    if(selIdx == undefined){
	    	alert("추가하실 상품을 선택해주세요.");
	    	return;
	    }
	    
		$("#selGoodIdenNumb_"+repreIdx).val();
	    vendorIds[0] 	= $("#selVenderId_"+repreIdx).val();
		ordQuans[0] 	= $("#inputQuan_"+repreIdx).val();
		goodNumbs[0] 	= $("#selGoodIdenNumb_"+repreIdx).val();
		
		vendorIds[1] 	= $("#addVendorId_"+selIdx).val();
		ordQuans[1] 	= $("#addOrdQuan_"+selIdx).val();
		goodNumbs[1] 	= $("#addGoodIdenNumb_"+selIdx).val();
		
		if(!confirm("해당 추가 상품을 장바구니에 담으시겠습니까?"))return;
		
    	$.post(
   			'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/setCartInfo.sys',
   			{	
               	kind:"ADD",
               	repreGoodNumb:repreGoodNumb,
               	goodNumbs:goodNumbs,
   	        	vendorIds:vendorIds,            	
   	        	ordQuans:ordQuans
   	        },
   			function(arg){
   	           	var result = eval('(' + arg + ')').customResponse;
   	           	
   	           	if(result.success){
   	           		if(!confirm("장바구니로 이동하시겠습니까?"))return;
   	           		fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
	           	}else{
	           		alert(result.message);
   	           	}
   	        }
   		);	
	});
	
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
	
<%-- 	responsive.goToSlide(<%=cateIdx%>); --%>
// 	responsive.goToSlide(0);
//  	responsive.goToSlide(1);
	
});

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
				sSearchWordTxt += sPrefix + " '" + prevWordArray[i].substring(1) + "'";
				sCnt++;
			}else{
				sSearchWordTxt += '';
			}
		}
		
		if(prevWordArray[i].indexOf('－') > -1){
			if(eCnt != 0) ePrefix = ",";
			if(prevWordArray[i].substring(1) != ''){
				eSearchWordTxt += ePrefix + " '" + prevWordArray[i].substring(1) + "'";
				eCnt++;
			}else{
				eSearchWordTxt += '';
			}
		}
	}
	
	var resultTxt = "";
	
	if(sCnt > 0){
		if(eCnt == 0) 	resultTxt = "<strong>"+sSearchWordTxt + "</strong> 의 검색결과";
		else			resultTxt = "<strong>"+sSearchWordTxt + "</strong> 중 <strong>" + eSearchWordTxt + "</strong> 을(를) 제외한 검색결과";
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
	

	if(viewFlag=="grid"){
		$("#pdtGridList").jqGrid("setGridParam", {"page":1});
		var data = $("#pdtGridList").jqGrid("getGridParam", "postData");
		data.searchType	= searchType;
		data.inputWord	= $.trim($('#inputWord').val());
		data.prevWord	= $.trim($('#prevWord').val());
		data.srcCateId	= $.trim($('#srcCateId').val());
		data.setCateId	= $.trim($('#setCateId').val());
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
		params += "&pCnt="  + ($.trim($('#pCnt').val()) == "" ? 30 : $.trim($('#pCnt').val()));
		params += "&pIdx="  + ($.trim($('#pIdx').val()) == "" ? 1 : $.trim($('#pIdx').val()));
		fnDynamicForm("/buyProduct/productResultList.sys", params,"");
	}
}

function fnPageSearch(){
	$.blockUI({});
	
	var searchType = 'N';

	if($.trim($("#inputWord").val()) != ''){
		$("#prevWord").val("＋"+$("#inputWord").val());
	}
	
	var params = "";
	
	params += "searchType=" + searchType;
	params += "&inputWord=" + $.trim($('#inputWord').val());
	params += "&prevWord="  + $.trim($('#prevWord').val());
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
           	$("#deliMiniDayTxt_"+cnt).html(resultMap.DELI_MINI_DAY + " 일");
           	$("#sellPriceTxt_"+cnt).html(fnComma(resultMap.SELL_PRICE)+" 원");
           	$("#goodInvCntTxt_"+cnt).html(fnComma(resultMap.GOOD_INVENTORY_CNT));
           	$("#selVenderId_"+cnt).val(vendorId);
           	
           	if(resultMap.GOOD_CLAS_CODE == '10'){
           		$("#appointDiv").show();
           	}else{
           		$("#appointDiv").hide();
           	}
           	
           	if(resultMap.REPRE_GOOD != 'Y'){
                $("#inputQuan_"+cnt).val(resultMap.DELI_MINI_QUAN);
           	}
           	
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
	//옵션상품 팝업
	if(repreGoodYn == 'Y'){
		fnOptionSearch(goodIdenNumb, vendorId);
	    $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getProductOption.sys',
    		{	
            	goodIdenNumb:goodIdenNumb,
            	vendorId:vendorId
            },
    		function(arg){
               	var resultMap = eval('(' + arg + ')').resultMap;
               	var optList = resultMap.commonOptList;
               	var commonOptHtml = "";
               	var optCnt = 0;
               	
               	if(optList.length > 0 && $.trim(optList[0].OPTION_NAME) != ''){
               		commonOptHtml+="<colgroup>";
               		commonOptHtml+="	<col width='100px'/>";
               		commonOptHtml+="	<col width='auto'/>";
               		commonOptHtml+="	<col width='100px'/>";
               		commonOptHtml+="	<col width='auto'/>";
               		commonOptHtml+="</colgroup>";
	               	for(var i = 0 ; i < optList.length ; i++){
	               		if($.trim(optList[i].OPTION_NAME) != ''){
	               			var optValues = $.trim(optList[i].OPTION_VALUE).split(";");
		              		commonOptHtml+="<tr>";
	               			commonOptHtml+="	<th>" + $.trim(optList[i].OPTION_NAME) + "</th>";
	               			commonOptHtml+="	<td>";
	               			commonOptHtml+="		<select name='commonOpt_"+optCnt+"' id='commonOpt_"+optCnt+"' style='width:200px;''>";
	               			commonOptHtml+="			<option value=''>선택</option>";
	               			for(var j = 0 ; j < optValues.length ; j++){
	               				commonOptHtml+="		<option value='"+optValues[j]+"'>"+optValues[j]+"</option>";
	               			}
	               			commonOptHtml+="		</select>";
	               			commonOptHtml+="	</td>";
		              		commonOptHtml+="</tr>";
		              		optCnt++;
	               		}
	               	}
               		commonOptHtml+="		<tr style='display:none;'>";
               		commonOptHtml+="			<td>";
               		commonOptHtml+="				<input type='text' id='commonOptCnt' name='commonOptCnt' value='"+optCnt+"'/>";
               		commonOptHtml+="			</td>";
               		commonOptHtml+="		</tr>";
	               	
	               	$("#repreGoodNumb").val(goodIdenNumb);
              		$("#commonOptTable").html(commonOptHtml);
              		$("#optionPop").jqmShow();
               	}
        	}
    	);	
	    return;
	}	
	
	//추가상품 팝업
	if(addGoodYn == 'Y'){
	    $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/product/getAddPdtList/list.sys',
    		{	
            	goodIdenNumb:goodIdenNumb
            },
    		function(arg){
               	var result = eval('(' + arg + ')').list;
               	var commonAddHtml = "";
               	if(result.length > 0){
               		
               		commonAddHtml+="<colgroup>";
               		commonAddHtml+="	<col width='30px'/>";
               		commonAddHtml+="	<col width='auto'/>";
               		commonAddHtml+="</colgroup>";
               		
	               	for(var i = 0 ; i < result.length ; i++){
    					commonAddHtml+="<tr>";
	    				commonAddHtml+="	<td align='center'><input id='addPdtSel_"+i+"' name='addPdtSel' type='radio' value='"+i+"' /></td>";
	    				commonAddHtml+="	<td class='bgGray'>";
	      				commonAddHtml+="		<dl>";
	      				commonAddHtml+="			<dt><img src='/img/contents/product_photo.jpg' /></dt>";
	      				commonAddHtml+="			<dd>";
	      				commonAddHtml+="				<p class='bold'>"+result[i].GOOD_NAME+"</p>";
	        			commonAddHtml+="				<ul>";
	          			commonAddHtml+="					<li style='width:100%;'>규격 : <strong>"+result[i].GOOD_SPEC+"</strong></li>";
	          			commonAddHtml+="					<li>상품코드 : <strong>"+result[i].GOOD_IDEN_NUMB+"</strong></li>";
	          			commonAddHtml+="					<li>표준납기일 : <strong>"+result[i].DELI_MINI_DAY+" 일</strong></li>";
	          			commonAddHtml+="					<li>공급사 : <strong>"+result[i].VENDORNM+"</strong></li>";
	          			commonAddHtml+="					<input type='hidden' id='addGoodIdenNumb_"+i+"' name='addGoodIdenNumb_"+i+"' value='"+result[i].GOOD_IDEN_NUMB+"'/>";
	          			commonAddHtml+="					<input type='hidden' id='addVendorId_"+i+"' name='addVendorId_"+i+"' value='"+result[i].VENDORID+"'/>";
	          			commonAddHtml+="					<input type='hidden' id='addOrdQuan_"+i+"' name='addOrdQuan_"+i+"' value='"+quan+"'/>";
	          			commonAddHtml+="					<input type='hidden' id='repreCnt_"+i+"' name='repreCnt_"+i+"' value='"+cnt+"'/>";
	          			commonAddHtml+="				</ul>";
	        			commonAddHtml+="				<p class='bold'>"+fnComma(result[i].SELL_PRICE)+" 원</p>";
	        			commonAddHtml+="			</dd>";
	      				commonAddHtml+="		</dl>";
	  					commonAddHtml+="	</td>";
	  					commonAddHtml+="</tr>";
	  					
	               	}
	               	$("#repreGoodNumb").val(goodIdenNumb);
					$("#addPdtTable").html(commonAddHtml);
					$("#addPop").jqmShow();						
               	}
            }
    	);
	    return;
	}
	
	
	
	vendorId 	 = $("#selVenderId_" + cnt).val();
	goodIdenNumb = $("#selGoodIdenNumb_" + cnt).val();
	quan 		 = $("#inputQuan_" + cnt).val();
	addGoodYn	 = $("#addGoodYn_"+cnt).val();
	repreGoodYn  = $("#repreGoodYn_"+cnt).val();
	
	var goodNumbs = new Array();
	var ordQuans  = new Array();
	var vendorIds = new Array();
	
	ordQuans[0]  = quan;
	goodNumbs[0] = goodIdenNumb;
	vendorIds[0] = vendorId;
	
	if(!confirm("해당 상품을 장바구니에 담으시겠습니까?"))return;
	
    $.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/setCartInfo.sys',
		{	
        	kind:"ETC",
			goodNumbs:goodNumbs,
        	ordQuans:ordQuans,
        	vendorIds:vendorIds
        },
		function(arg){
           	var result = eval('(' + arg + ')').customResponse;
           	
           	if(result.success){
           		if(!confirm("장바구니로 이동하시겠습니까?"))return;
           		fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
	        }else{
	           	alert(result.message);
           	}
        }
	);	
}

function fnOptionSearch(goodIdenNumb, vendorId){
	$("#list").jqGrid('setGridParam', {url:'/product/getOptionPdtList/list.sys'});
   	var data = $("#list").jqGrid("getGridParam", "postData");
   	data.goodIdenNumb  	= goodIdenNumb;
   	data.vendorId 		= vendorId;
   	$("#list").trigger("reloadGrid");  	
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

	if( ! confirm("해당 상품을 관심상품에 담으시겠습니까?") ){ return;}
	
	$.post(
		'/buyProduct/setUserGood.sys',
		{	
			goodIdenNumb : goodIdenNumb
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;

			if(result.success){
				if(!confirm("관심상품 페이지로 이동하시겠습니까?"))return;
				fnDynamicForm("/buyProduct/getBuyUserGoodList.sys", "","");
			}else{
				var errs = result.message;
				var msg = "";
				for(var i=0 ; i < errs.length; i++){
					msg += errs[i];
				}
				alert(msg);
			}
		}
	);	
	
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
		
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
//옵션 그리드
$("#list").jqGrid({
	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
	multiselect:true,
	datatype: "json",
	mtype:'POST',
	colNames:['GOOD_IDEN_NUMB','VENDORID','규격', '단가', '재고', '수량'],
	colModel:[
		{name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB',width:200,align:"left",search:false,sortable:true,editable:false, hidden:true },//상품ID
		{name:'VENDORID',index:'VENDORID',width:200,align:"left",search:false,sortable:true,editable:false, hidden:true },//공급사ID
		{name:'GOOD_SPEC',index:'GOOD_SPEC',width:200,align:"left",search:false,sortable:true,editable:false },//규격
		{name:'SELL_PRICE',index:'SELL_PRICE',width:120,align:"right",search:false,sortable:false,
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
		},//단가			
		{name:'GOOD_INVENTORY_CNT',index:'GOOD_INVENTORY_CNT',width:80,align:"right",search:false,sortable:false,
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
		},//수량	
		{name:'SET_QTY', index:'SET_QTY',align:"center", width:85,search:false,sortable:false, editable:true}//수량
	],
	postData: {},
	rowNum:0,rownumbers:false,rowList:[30,50,100,500],
	height:250,width:550,
	sortname:'good_Name',sortorder:'Desc',
	viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
	loadComplete:function() {
		var rowCnt = $("#list").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				var selrowContent = $("#list").jqGrid('getRowData',rowid);
				var descStr  = "<input type='text' id='setQty_"+rowid+"' name='setQty_"+rowid+"' value='1' size='6' maxlength=9 onkeydown='return onlyNumber(event)' style='text-align:right;' />";
				$("#list").jqGrid('setRowData', rowid, {SET_QTY:descStr});
			}
		} 
	},
	ondblClickRow:function(rowid,iRow,iCol,e) {},
	onCellSelect:function(rowid,iCol,cellcontent,target) {},
	afterInsertRow: function(rowid, aData){},
	loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
	jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
});

</script>
<%-- 상품검색 결과를 그리드로 볼 경우 진열되는 테이블 --%>
<script type="text/javascript">
$(function() {
	$("#pdtGridList").jqGrid({
		url:'/buyProduct/productResultGridList.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:['상품코드','상품정보<br/>[상품명/규격/공급사]','상품구분','금액<br/>(표준납기일)','수량','버튼','VENDORID','ADD_GOOD','REPRE_GOOD','DELI_MINI_QUAN'],
		colModel:[
			{name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB', width:100,align:"center"},	//상품코드
			{name:'GOOD_INFO',index:'GOOD_INFO', width:250,align:"left"},	//상품정보
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
			$("#searchType1").prop("checked",false);
			$("#searchTyp21").prop("checked",false);
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
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailPop(selrowContent.GOOD_IDEN_NUMB , selrowContent.VENDORID);")%>
			}
			
		},
		loadError : function(xhr, st, str){ $("#pdtGridList").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});

function fnCategoryDivShow(id){
	$.each($(".CategoryDiv"), function(){
		$(this).attr("style", "display:none");
	});
	
	var position        = $("#" + id + "li").position();
	var top             = position.top + 70;
	var viewPercentInfo = null;
	var vertical        = null;
	var height          = null;
	
	document.getElementById(id).style.top     = top + "px";
	document.getElementById(id).style.display = "block";
	
	height          = $("#" + id).height();
	viewPercentInfo = fnViewPercent(id);
	vertical        = viewPercentInfo.vertical;
	
	if(vertical < 100){
		top = top - (height * (100 - vertical)) / 100;
		
		if(top < 0){
			top = 0;
		}
		
		document.getElementById(id).style.top = top + "px";
	}
}
</script>
<%// slider start! %>
<link type="text/css" rel="stylesheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/lightslider.css" />
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/lightslider.js" type="text/javascript"></script>
<%// slider end! %>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>
</html>