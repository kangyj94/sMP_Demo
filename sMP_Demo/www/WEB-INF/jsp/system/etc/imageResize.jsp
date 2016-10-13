<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList        = (List<ActivitiesDto>) request.getAttribute("useActivityList"); //화면권한가져오기(필수)
	@SuppressWarnings("unchecked")
	List<CodesDto>      imageResizeType = (List<CodesDto>) request.getAttribute("imageResizeType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>

<!-- file Upload 스크립트 -->
<script type="text/javascript">
$(function(){
	var btnUpload=$('#importButton');
	var status=$('#status');
	new AjaxUpload(btnUpload, {
		action: '<%=Constances.SYSTEM_CONTEXT_PATH%>/common/imageResizeProcess.sys',
		name: 'imageFile',
		data: {},
		onSubmit: function(file, ext){
		    if(!(ext && /^(jpg|jpeg|gif)$/.test(ext))) {
	             alert('이미지 파일(jpg,jpeg,gif) 파일만 등록 가능합니다.');
	            //status.text("이미지 파일만 등록 가능합니다.");   // extension is not allowed
	            return false;
	         }
			if(!confirm("이미지를 등록하시겠습니까?")){
				return false;
			}
			status.text('Uploading...');
		},
		onComplete: function(file, response){
			status.text('');
			var result  = eval("(" +response + ")");
<%
	if((imageResizeType != null) && (imageResizeType.size() > 0)){
		int      i         = 0;
		CodesDto codesDto  = null;
		String   codeName1 = null;
		for(i = 0; i < imageResizeType.size(); i++){
			codesDto  = imageResizeType.get(i);
			codeName1 = codesDto.getCodeNm1();
%>
			var <%=codeName1 %> = document.getElementById("<%=codeName1 %>");
			<%=codeName1 %>.src = "<%=Constances.SYSTEM_CONTEXT_PATH%><%=Constances.SYSTEM_IMAGE_PATH %>/" + result.<%=codeName1 %>;
			alert(result.<%=codeName1 %>);
<%
		}
	}
%>
			alert(result.ORGIN);
		}
	});
});
</script>
</head>

<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>이미지 리사이즈</td>
					<td align="right">
						&nbsp;
					</td>
				</tr>
			</table>
			<table>
				<tr>
<%
	int imageResizeTypeSize = 0;
	if((imageResizeType != null) && (imageResizeType.size() > 0)){
		int      i          = 0;
		CodesDto codesDto   = null;
		String   codeValue1 = null;
		String   codeValue2 = null;
		String   codeName1  = null;
		imageResizeTypeSize = imageResizeType.size();
		for(i = 0; i < imageResizeType.size(); i++){
			codesDto   = imageResizeType.get(i);
			codeValue1 = codesDto.getCodeVal1();
			codeValue2 = codesDto.getCodeVal2();
			codeName1  = codesDto.getCodeNm1();
%>
					<td valign="bottom">
						<%=codeName1 %>
						<br/>
						<a href="#">
						<img id="<%=codeName1 %>" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_<%=codeValue1 %>.gif" alt="<%=codeName1 %>" style="border: 0px;"/>
						</a>
					</td>
<%
		}
	}
%>
				</tr>
<%	if(imageResizeTypeSize > 0){	%>
				<tr>
					<td colspan="<%=imageResizeTypeSize %>">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td colspan="<%=imageResizeTypeSize %>">
						<span id="status" style="color: #FF0000"></span>
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type4_register.gif" id="importButton"/>
					</td>
				</tr>
<%	}	%>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>