<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%
	Map<String,Object> deliInfo = (Map<String,Object>)request.getAttribute("deliInfo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
</head>

<body style="width:500px;">
  <div id="divPopup" style="width:500px;">
  <h1>배송정보<a href="#" onclick="javaScript:window.close();"><img src="/img/contents/btn_close.png"></a></h1>
    <div class="popcont">
      <table class="InputTable">
      <colgroup>
      	<col width="100px" />
        <col width="auto" />
      </colgroup>
        <tr>
          <th>상품</th>
          <td><b><%= CommonUtils.nvl((String)deliInfo.get("GOOD_NAME"), "")  %></b><br/>규격 : <%= CommonUtils.nvl((String)deliInfo.get("GOOD_SPEC"), "")  %></td>
        </tr>
        <tr>
          <th>공급사</th>
          <td><%= CommonUtils.nvl((String)deliInfo.get("VENDORNM"), "")  %></td>
        </tr>
        <tr>
          <th>배송유형</th>
          <td><%= CommonUtils.nvl((String)deliInfo.get("DELI_TYPE_CLAS"), "")  %></td>
        </tr>
        <tr>
          <th>전화번호</th>
          <td><%= CommonUtils.nvl((String)deliInfo.get("DELI_INVO_IDEN"), "")  %></td>
        </tr>
      </table>
      <div class="Ac mgt_10">
        <button class="btn btn-default btn-sm" onclick="javaScript:window.close();">닫기</button>
      </div>
    </div>
  </div>
</body>
</html>