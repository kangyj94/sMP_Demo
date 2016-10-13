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
    <link rel="stylesheet" type="text/css" href="/css/Global.css">
    <link rel="stylesheet" type="text/css" href="/css/Default.css">
</head>
<body style="width:500px;">
  <div id="divPopup" style="width:500px;">
  <h1>배송지 정보<a href="javascript:window.close();"><img src="/img/contents/btn_close.png"></a></h1>
    <div class="popcont">
      <table class="InputTable">
      <colgroup>
      	<col width="100px" />
        <col width="130px" />
        <col width="100px" />
        <col width="auto" />
      </colgroup>
        <tr>
          <th>인수자</th>
          <td><%=CommonUtils.getString(deliInfo.get("TRAN_USER_NAME")) %></td>
          <th>인수자 연락처</th>
          <td><%=CommonUtils.getString(deliInfo.get("TRAN_TELE_NUMB")) %></td>
        </tr>
        <tr>
          <th>배송처 주소</th>
          <td colspan="3"><%=CommonUtils.getString(deliInfo.get("TRAN_DATA_ADDR")) %></td>
        </tr>
        <tr>
          <th>첨부1</th>
          <td colspan="3">
              <input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=CommonUtils.getString(deliInfo.get("ATTACH_FILE_PATH1")) %>"/>
              <a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
                  <%=CommonUtils.getString(deliInfo.get("ATTACH_FILE_NAME1")) %>
              </a>
          </td>
        </tr>
        <tr>
          <th>첨부2</th>
          <td colspan="3">
              <input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=CommonUtils.getString(deliInfo.get("ATTACH_FILE_PATH2")) %>"/>
              <a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
                  <%=CommonUtils.getString(deliInfo.get("ATTACH_FILE_NAME2")) %>
              </a>
          </td>
        </tr>
        <tr>
          <th>첨부3</th>
          <td colspan="3">
              <input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=CommonUtils.getString(deliInfo.get("ATTACH_FILE_PATH3")) %>"/>
              <a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
                  <%=CommonUtils.getString(deliInfo.get("ATTACH_FILE_NAME3")) %>
              </a>
          </td>
        </tr>
      </table>
      <div class="Ac mgt_10"><span><button  class="btn btn-default btn-sm" onclick="javascript:window.close();">닫기</button></span></div>
              
    </div>
  </div>
</body>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<script>
function fnAttachFileDownload(attach_file_path) {
	var url = "/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}
jQuery.download = function(url, data, method){
	// url과 data를 입력받음
	if( url && data ){ 
		// data 는  string 또는 array/object 를 파라미터로 받는다.
		data = typeof data == 'string' ? data : jQuery.param(data);
		// 파라미터를 form의  input으로 만든다.
		var inputs = '';
		jQuery.each(data.split('&'), function(){ 
			var pair = this.split('=');
			inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
		});
		// request를 보낸다.
		jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>').appendTo('body').submit().remove();
	};
};
</script>
</html>