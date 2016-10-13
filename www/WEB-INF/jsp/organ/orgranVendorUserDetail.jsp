<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcUserNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
//개발시 삭제
function onDetail(){
	var popurl = "/order/orderRequest/orderDetail.sys";
	var popproperty = "dialogWidth:900px;dialogHeight=700px;scroll=yes;status=no;resizable=no;";
// 	window.showModalDialog(popurl,null,popproperty);
	window.open(popurl, 'okplazaPop', 'width=900, height=700, scrollbars=yes, status=no, resizable=no');
}

</script>
</head>
<body>
<form id="frm" name="frm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="29" class='ptitle'>공급사용자등록</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" height="27" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
							<td class="stitle">사용자 정보</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 컨텐츠 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="4" class="table_top_line"></td>
						</tr>
						<tr>
							<td class="table_td_subject9">사업장</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId6" name="srcLoginId6" type="text" value="" size="" maxlength="50" style="width: 80%" /> <img src="/img/system/btn_icon_search.gif" width="20" height="18" align="absmiddle" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9">성명</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId2" name="srcLoginId2" type="text" value="" size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">아이디</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId4" name="srcLoginId4" type="text" value="" size="20" maxlength="30" /> <img src="/img/system/btn_type2_check.gif" width="75" height="18" align="absmiddle" class='icon_search' /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">비밀번호</td> <td class="table_td_contents"><input id="srcLoginId3" name="srcLoginId3" type="text" value="" size="20" maxlength="30" /></td>
							<td class="table_td_subject9" width="100">비밀번호 확인</td>
							<td class="table_td_contents"><input id="srcLoginId18" name="srcLoginId18" type="text" value="" size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">전화번호</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId19" name="srcLoginId19" type="text" value="" size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">이동전화번호</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId21" name="srcLoginId21" type="text" value="" size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9">이메일</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId" name="srcLoginId" type="text" value="" size="30" maxlength="30" /> ex)admin@unpamsbank.com</td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9">상태</td>
							<td colspan="3" class="table_td_contents"><select class="select" id="srcIsDefault6" name="srcIsDefault6"> <option>선택하세요</option> </select></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject">종료사유</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId5" name="srcLoginId5" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject">참고사항</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId5" name="srcLoginId5" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject">이메일 발송여부</td>
							<td colspan="3" class="table_td_contents"><label><input class="input_none radio" type="checkbox" name="checkbox2" value="checkbox" /> 발주의뢰</label> <label><input class="input_none radio" type="checkbox" name="checkbox2" value="checkbox" /> 인수확인</label> <label><input class="input_none radio" type="checkbox" name="checkbox2" value="checkbox" /> 입찰통보</label> <label><input class="input_none radio" type="checkbox" name="checkbox2" value="checkbox" /> 낙찰통보</label></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject">SMS 발송여부</td>
							<td colspan="3" class="table_td_contents"><label><input class="input_none radio" type="checkbox" name="checkbox2" value="checkbox" /> 발주의뢰</label> <label><input class="input_none radio" type="checkbox" name="checkbox2" value="checkbox" /> 인수확인</label> <label><input class="input_none radio" type="checkbox" name="checkbox2" value="checkbox" /> 입찰통보</label> <label><input class="input_none radio" type="checkbox" name="checkbox2" value="checkbox" /> 낙찰통보</label></td>
						</tr>
						<tr>
							<td colspan="4" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td align="center"><img src="/img/system/btn_type5_save.gif" width="65" height="23" /> <img src="/img/system/btn_type5_close.gif" width="65" height="23" /></td>
			</tr>
		</table>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>