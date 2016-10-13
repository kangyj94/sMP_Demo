<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
</script>
</head>

<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">상품등록 요청</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">상품등록정보</td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">공급업체명</td>
				<td colspan="3" class="table_td_contents">
					<input id="srcLoginId" name="srcLoginId2" type="text" value="" size="20" maxlength="30" style="width:400px" /></td>
				<td class="table_td_subject">공급사상품등록요청상태</td>
				<td class="table_td_contents">
					<select id="srcIsDefault" name="srcIsDefault" class="select_none">
						<option>선택하세요</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">공급사상품등록요청일</td>
				<td class="table_td_contents">
					<input id="srcLoginId2" name="srcLoginId" type="text" value="" size="20" maxlength="30" class="input_text_none" /></td>
				<td class="table_td_subject" width="100">상품등록일</td>
				<td class="table_td_contents">
					<input id="srcLoginId10" name="srcLoginId10" type="text" value="" size="20" maxlength="30" class="input_text_none" /></td>
				<td class="table_td_subject" width="100">상품코드</td>
				<td class="table_td_contents">
					<input id="srcLoginId14" name="srcLoginId14" type="text" value="" size="20" maxlength="30" class="input_text_none" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품명</td>
				<td colspan="3" class="table_td_contents">
					<input id="srcLoginId11" name="srcLoginId11" type="text" value="" size="20" maxlength="30" style="width:400px;" /></td>
				<td class="table_td_subject">운영사상품담당자</td>
				<td class="table_td_contents">
					<input id="srcLoginId14" name="srcLoginId14" type="text" value="" size="20" maxlength="30" class="input_text_none" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품규격</td>
				<td colspan="5" class="table_td_contents">
				<input id="srcLoginId3" name="srcLoginId3" type="text" value="" size="20" maxlength="30" style="width:400px;" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">단위</td>
				<td class="table_td_contents">
					<select id="srcIsDefault5" name="srcIsDefault5" class="select">
						<option>선택하세요</option>
					</select></td>
				<td class="table_td_subject">최소주문수량</td>
				<td class="table_td_contents">
					<input id="srcLoginId12" name="srcLoginId12" type="text" value="" size="20" maxlength="30" /></td>
				<td class="table_td_subject">납품소요일</td>
				<td class="table_td_contents">
					<input id="srcUserNm2" name="srcUserNm2" type="text" value="" size="10" maxlength="10" />일</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품이미지</td>
				<td colspan="5">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="table_td_contents">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="25">
											<input id="srcLoginId9" name="srcLoginId9" type="text" value="" size="20" maxlength="30" style="width:95%" /></td>
										<td width="20" height="25">
											<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;" /></td>
									</tr>
									<tr>
										<td colspan="2" height="25">
											<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageOK.gif" style="width:75px;height:18px;" />
											<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageDelete.gif" style="width:75px;height:18px;" /></td>
									</tr>
								</table>
							</td>
							<td class="table_td_subject" width="100">대표상품이미지</td>
							<td valign="top" class="table_td_contents4">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_100.gif" style="width:100px;height:100px;" />
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_70.gif" style="width:70px;height:70px;" />
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" style="width:50px;height:50px;" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품설명</td>
				<td colspan="5" class="table_td_contents">
					<textarea name="textarea" id="textarea" cols="45" rows="10" style="width:730px; height:50px"></textarea></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품 동의어</td>
				<td colspan="5" class="table_td_contents">
					<table width="98%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<input id="srcLoginId5" name="srcLoginId5" type="text" value="" size="20" maxlength="30" /></td>
							<td>
								<input id="srcLoginId6" name="srcLoginId6" type="text" value="" size="20" maxlength="30" /></td>
							<td>
								<input id="srcLoginId7" name="srcLoginId7" type="text" value="" size="20" maxlength="30" /></td>
							<td>
								<input id="srcLoginId8" name="srcLoginId8" type="text" value="" size="20" maxlength="30" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td align="center">
		<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_approval2.gif" style="width:110px;height:23px;" />
		<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_cancel2.gif" style="width:110px;height:23px;" /></td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<!-------------------------------- Dialog Div Start -------------------------------->
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>