<%@page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--페이징 -->
<%
	int pIdx 	 = Integer.parseInt(CommonUtils.nvl(CommonUtils.getString(request.getAttribute("pIdx"))	 , "0"));
	pIdx = pIdx > 0 ? pIdx : 1;

	int pCnt 	 = Integer.parseInt(CommonUtils.nvl(CommonUtils.getString(request.getAttribute("pCnt"))	 , "0"));
	int total 	 = Integer.parseInt(CommonUtils.nvl(CommonUtils.getString(request.getAttribute("total"))	 , "0"));
	int records  = Integer.parseInt(CommonUtils.nvl(CommonUtils.getString(request.getAttribute("records")) , "0"));
	int pageSize = 10;
	int currPage  = new Double(Math.ceil(pIdx/pageSize)).intValue();
	if(currPage > 0 && pIdx%pageSize == 0){
		currPage = currPage - 1;
	}
	int startPage = currPage == 0 ? 1 : (currPage * pageSize) + 1;
	int endPage   = currPage == 0 ? 11 : startPage + pageSize;
	
%>
<input type="hidden" id="pIdx" name="pIdx">

<%
	if(total > 0){
%>




<div class="divPageNum">
	<ol>
		<li class="PageNumBtn">
			<a href="#;" title="이전" onclick="javascript:$('#pIdx').val('1');fnGoPage();"><img src="/img/contents/btn_page_end.gif" alt="이전" style="vertical-align:middle;" /></a> 
			<a href="#;" title="이전" onclick="javascript:$('#pIdx').val('<%=startPage-10%>');fnGoPage();"><img src="/img/contents/btn_page_back.gif" alt="이전" style="vertical-align:middle;" /></a>
		</li>
<%
	for(int i = startPage ; i < endPage ; i++){
		if(i <= total){
			
%>
		<li <%if(pIdx==(i)){%>class="Active"<%}%> onclick="javascript:$('#pIdx').val('<%=i%>');fnGoPage();" style="cursor: pointer;"> <%=i%></li>
<%		
		}
	}
%>		
		<li class="PageNumBtn">
			<a href="#;" title="다음" onclick="javascript:$('#pIdx').val('<%=endPage%>');fnGoPage();"><img src="/img/contents/btn_page_next.gif" alt="다음" style="vertical-align:middle;" /></a> 
			<a href="#;" title="다음" onclick="javascript:$('#pIdx').val('<%=total%>');fnGoPage();"><img src="/img/contents/btn_page_first.gif" alt="다음" style="vertical-align:middle;" /></a>
		</li>
	</ol>
</div>

<%		
	}
%>