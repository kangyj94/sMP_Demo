<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%
	LoginUserDto              loginUserDto  = CommonUtils.getLoginUserDto(request);
	List<Map<String, Object>> cate          = (List<Map<String, Object>>)session.getAttribute("cate");
	List<BoardDto>            noticeList    = (List<BoardDto>)request.getAttribute("noticeList");
	List<BoardDto>            emergencyList = (List<BoardDto>)request.getAttribute("emergencyList");
	Map<String,Object>        smileEvalInfo = (Map<String, Object>)request.getAttribute("smileEvalInfo");
	Map<String, String>       bondInfo      = (Map<String, String>)request.getAttribute("bondInfo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Global.css">
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/custom.common.js" type="text/javascript"></script>
<script>
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
		top = (top - (height * (100 - vertical)) / 100) - 30;
		
		if(top < 0){
			top = 0;
		}
		
		document.getElementById(id).style.top = top + "px";
	}
}

function fnSearchCate(topCateId, midCateId, dtlCateId){
	var srcCateId = topCateId;
	var params    = "";
	
	if(midCateId != ''){
		srcCateId = midCateId;
	}
	
	if(dtlCateId != ''){
		srcCateId = dtlCateId;
	}
	
	params += "searchType=N";
	params += "&inputWord=";
	params += "&prevWord=";
	params += "&srcCateId=" + srcCateId;
	params += "&setCateId=" + topCateId;
	params += "&pCnt=30";
	params += "&pIdx=1";
	
	fnDynamicForm("/buyProduct/productResultList.sys", params, "");
}

function fnNoticeDetailPop(boardNo){
	var params = "board_No=" + boardNo;
	
	window.open("", 'noticeDetailPop', 'width=720, height=510, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/board/noticeDetail.sys", params, "noticeDetailPop");
}

function vocGo(){	
	window.open("", 'requestManageWrite', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/board/requestManageWrite.sys", "", "requestManageWrite");
}
</script>
</head>
<body>
<div id="divBody" style="position: absolute;">
	<div id="divSub">
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
              		<div>
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
%>
				<li>
					<img src="/img/layout/cs_center.gif" />
				</li>
			</ul>
		</div>
        <div id="divContainer">
			<div id="vendorMain">
				<div class="visual">
					<span style="position:absolute; z-index:99; left:0; top:135px;">
						<img src="/img/contents/event_pre.png"/>
					</span>
					<span style="position:absolute; z-index:99; right:5px; top:135px;">
						<img src="/img/contents/event_next.png"/>
					</span>
					<img src="/img/contents/event01.jpg" />
				</div>
				<div class="BoxCont mgr_15">
					<div class="Notice">
						<h2>공지사항 <span>
							<a href="/menu/board/community/noticeListBuy.sys?_menuCd=BUY_COMM_NOTI" target="_self">
								<img src="/img/contents/main_more.gif" />
							</a>
						</span></h2>
						<dl class="mgt_5">
<%
	if(noticeList != null){
		BoardDto noticeInfo     = null;
		String   title          = null;
		String   regDateTime    = null;
		String   boardNo        = null;
		String   isNew          = null;
		String   importantYn    = null;
		int      noticeListSize = noticeList.size();
		int      i              = 0;
		
		for(i = 0; i < noticeListSize; i++){
			noticeInfo  = noticeList.get(i);
			title       = noticeInfo.getTitle();
			regDateTime = noticeInfo.getRegi_Date_Time();
			boardNo     = noticeInfo.getBoard_No();
			isNew       = noticeInfo.getIsNew();
			importantYn = noticeInfo.getImportantYn();
			
			if("Y".equals(importantYn)){
				isNew = "N";
			}
%>
							<dt>
<%
			if("Y".equals(isNew)){
%>
								<img src="/img/contents/icon_notice02.gif" />
<%
			}

			if("Y".equals(importantYn)){
%>							
								<img src="/img/contents/icon_notice03.gif" />
<%
			}
%>
								<a href="javascript:fnNoticeDetailPop('<%=boardNo %>');"><%=title %></a>
							</dt>
							<dd><%=regDateTime %></dd>
<%
		}
	}
%>
						</dl>
					</div>
				</div>
				<div class="BoxCont">
					<h2>자재대금 Issue 업체 현황</h2>
					<table width="100%">
						<colgroup>
							<col width="25%" />
							<col width="25%" />
							<col width="25%" />
							<col width="25%" />
						</colgroup>
						<tr>
							<th>구분</th>
							<th>90일 초과</th>
							<th>150일 초과</th>
							<th>소 계</th>
						</tr>
<%
	if(bondInfo != null){
		String amount90      = bondInfo.get("amount90");
		String amount150     = bondInfo.get("amount150");
		String amountSum     = bondInfo.get("amountSum");
		String amount90Rate  = bondInfo.get("amount90Rate");
		String amount150Rate = bondInfo.get("amount150Rate");
		String amountSumRate = bondInfo.get("amountSumRate");
		String amount90Cnt   = bondInfo.get("amount90Cnt");
		String amount150Cnt  = bondInfo.get("amount150Cnt");
		String amountSumCnt  = bondInfo.get("amountSumCnt");
%>
						<tr>
							<td style="text-align: left;">채권 금액</td>
							<td style="text-align: right;"><%=amount90 %></td>
							<td style="text-align: right;"><%=amount150 %></td>
							<td style="text-align: right;"><%=amountSum %></td>
						</tr>
						<tr>
							<td style="text-align: left;">점유율</td>
							<td style="text-align: right;"><%=amount90Rate %>%</td>
							<td style="text-align: right;"><%=amount150Rate %>%</td>
							<td style="text-align: right;"><%=amountSumRate %>%</td>
						</tr>
						<tr>
							<td style="text-align: left;">업체 수</td>
							<td style="text-align: right;"><%=amount90Cnt %></td>
							<td style="text-align: right;"><%=amount150Cnt %></td>
							<td style="text-align: right;"><%=amountSumCnt %></td>
						</tr>
<%
	}
%>
					</table>
				</div>
				<ul class="banner">
					<li>
						<img src="/img/contents/main_banner01_1.gif" usemap="#Map" border="0" />
						<map name="Map" id="Map">
							<area shape="rect" coords="104,13,171,32" href="javascript:fnContractView('B');" />
							<area shape="rect" coords="102,32,195,50" href="javascript:fnContractView('S');" />
							<input type="hidden" id="contractBView" />
							<input type="hidden" id="contractSView" />
						</map>
					</li>
					<li>
						<a href="javascript:alert('준비중입니다.');">
							<img src="/img/contents/main_banner02.gif" />
						</a>
					</li>
					<li>
						<a href="javascript:vocGo();">
							<img src="/img/contents/main_banner03.gif" />
						</a>
					</li>
					<li>
						<a href="javascript:alert('준비중입니다.');">
							<img src="/img/contents/main_banner04.gif" />
						</a>
					</li>
					<li>
						<a href="javascript:window.open('http://113366.com/okplaza','remoteManagePop', 'width=950, height=700, scrollbars=yes, status=no, resizable=no');void(0);">
							<img src="/img/contents/main_banner05.gif" />
						</a>
					</li>
					<li>
						<a href="/proposal/viewProposalList.sys?_menuCd=MANAGE_NEWMATERIAL" target="_parent">
							<img src="/img/contents/main_banner06.gif" />
						</a>
					</li>
				</ul>
				<div class="Alarm">
					<div class="slide">
						<marquee direction="left">
<%
	if(emergencyList != null){
		BoardDto noticeInfo        = null;
		String   title             = null;
		String   boardNo           = null;
		int      emergencyListSize = emergencyList.size();
		int      i                 = 0;
		
		for(i = 0; i < emergencyListSize; i++){
			noticeInfo  = emergencyList.get(i);
			title       = noticeInfo.getTitle();
			boardNo     = noticeInfo.getBoard_No();
			title       = CommonUtils.getByteSubstring(title, 50, "..."); // 제목 길이 조정
%>

							<a href="javascript:fnNoticeDetailPop('<%=boardNo %>');"><%=title %></a>
							<img src="/img/contents/icon_new.png" />
							&nbsp;&nbsp;&nbsp;
<%
		}
	}
%>
						</marquee>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function() {
	fnContractToDoList();
});
	
function fnContractToDoList(){
	$.post(
		"/common/contractToDoList.sys",
		{
			borgId:"<%=loginUserDto.getBorgId()%>"
		},
		function(arg){
			var svcTypeCd	= arg.svcTypeCd;
			var list		= arg.list;
			var listLength	= list.length;
			var i           = 0;
			var listInfo    = null;
			var classify    = null;
			var version     = null;
			
			if(listLength > 0){
				for(i = 0; i < listLength; i++){
					listInfo = list[i];
					classify = listInfo.CONTRACT_CLASSIFY;
					version  = listInfo.CONTRACT_VERSION;
					
					if("S" == classify){
						document.getElementById("contractSView").value = version;
					}
					else if("B" == classify){
						document.getElementById("contractBView").value = version;
					}
				}
			}
		},
		"json"
	);
}

function fnContractView(contractClassify) {
	var params          = 'svcTypeCd=VEN';
	var contractVersion = null;
	
	if("S" == contractClassify){
		contractVersion = document.getElementById("contractSView").value;
	}
	else if("B" == contractClassify){
		contractVersion = document.getElementById("contractBView").value;
	}
	
	params = params + '&contractVersion='+contractVersion;
	
	window.open('', 'popContractDetail', 'width=917, height=720, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/common/popContractDetail.sys", params, "popContractDetail");
}
</script>
</body>
</html>