<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "50";

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

//리사이징
// $(window).bind('resize', function() { 
//     $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
// }).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['권한코드', '권한명', '권한설명'],
		colModel:[
			{name:'권한코드',index:'권한코드', width:90,align:"center",search:false,sortable:true, editable:false },
			{name:'권한명',index:'권한명', width:200,align:"center",search:false,sortable:true, editable:false },
			{name:'권한설명',index:'권한설명', width:90,align:"center",search:false,sortable:true, editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		caption:"권한정보", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%--CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")// 개발시 주석 삭제--%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
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
							<td height="29" class='ptitle'>공급사상세</td>
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
							<td class="stitle">공급사 일반정보</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
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
							<td class="table_td_subject9" width="100">공급사명</td>
							<td colspan="5" class="table_td_contents"><input id="srcLoginId4" name="srcLoginId4" type="text" value="" size="40" maxlength="50" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">사업자등록번호</td>
							<td class="table_td_contents"><input id="srcLoginId" name="srcLoginId" type="text" value="" size="3" maxlength="3" /> - <input id="srcLoginId8" name="srcLoginId8" type="text" value="" size="2" maxlength="2" /> - <input id="srcLoginId9" name="srcLoginId9" type="text" value="" size="5" maxlength="5" /></td>
							<td class="table_td_subject9" width="100">법인등록번호</td>
							<td class="table_td_contents"><input id="srcUserNm3" name="srcUserNm3" type="text" value="" size="6" maxlength="6" /> - <input id="srcUserNm12" name="srcUserNm8" type="text" value="" size="7" maxlength="7" /></td> <td class="table_td_subject9" width="100">업종</td>
							<td class="table_td_contents"><input id="srcLoginId13" name="srcLoginId13" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">업태</td>
							<td class="table_td_contents"><input id="srcLoginId" name="srcLoginId" type="text" value="" size="20" maxlength="30" /></td>
							<td class="table_td_subject9" width="100">대표자명</td>
							<td class="table_td_contents"><input id="srcLoginId12" name="srcLoginId12" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
							<td class="table_td_subject9" width="100">대표전화번호</td>
							<td class="table_td_contents"><input id="srcUserNm2" name="srcUserNm2" type="text" value="" size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">회사이메일</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId" name="srcLoginId" type="text" value="" size="20" maxlength="30" /> ex)admin@unpamsbank.com</td>
							<td class="table_td_subject" width="100">홈페이지</td>
							<td class="table_td_contents"><input id="srcLoginId11" name="srcLoginId11" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">주소</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId6" name="srcLoginId6" type="text" value="" size="10" maxlength="10" /> <img src="/img/system/btn_icon_search.gif" width="20" height="18" align="absmiddle" class='icon_search' /> <input id="srcLoginId7" name="srcLoginId7" type="text" value="" size="20" maxlength="30" style="width: 50%" /></td>
							<td class="table_td_subject" width="100">상세주소</td>
							<td class="table_td_contents"><input id="srcLoginId10" name="srcLoginId10" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">팩스번호</td>
							<td class="table_td_contents"><input id="srcLoginId" name="srcLoginId" type="text" value="" size="20" maxlength="30" /></td>
							<td class="table_td_subject" width="100">참고사항</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId5" name="srcLoginId5" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">첨부파일</td>
							<td colspan="5" class="table_td_contents"><input type="file" name="fileField" id="fileField" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">로그인인증</td>
							<td class="table_td_contents"><select class="select" id="srcIsDefault3" name="srcIsDefault3"> <option>선택하세요</option> </select></td>
							<td class="table_td_subject9" width="100">권역</td>
							<td colspan="3" class="table_td_contents"><select class="select" id="srcIsDefault6" name="srcIsDefault6"> <option>선택하세요</option> </select></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" height="27" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
							<td class="stitle">결제정보</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
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
							<td class="table_td_subject9" width="100">결제조건</td>
							<td class="table_td_contents"><select class="select" id="srcIsDefault" name="srcIsDefault"> <option>선택하세요</option> </select> <input id="srcLoginId17" name="srcLoginId17" type="text" value="" size="20" maxlength="30" style="width: 20px" /> 일</td>
							<td class="table_td_subject9" width="100">회계담당자명</td>
							<td class="table_td_contents"><input id="srcLoginId15" name="srcLoginId15" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
							<td class="table_td_subject9" width="100">회계이동전화</td>
							<td class="table_td_contents"><input id="srcLoginId16" name="srcLoginId16" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">은행코드</td>
							<td class="table_td_contents"><select class="select" id="srcIsDefault2" name="srcIsDefault2"> <option>선택하세요</option> </select></td>
							<td class="table_td_subject9" width="100">예금주명</td>
							<td class="table_td_contents"><input id="srcLoginId14" name="srcLoginId14" type="text" value="" size="20" maxlength="30" style="width: 98%" /></td>
							<td class="table_td_subject9" width="100">계좌번호</td>
							<td class="table_td_contents"><input id="srcLoginId2" name="srcLoginId2" type="text" value="" size="15" maxlength="20" /> (-없이)</td>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" height="27" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
							<td class="stitle">담당자 정보</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="4" class="table_top_line"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">로그인ID</td>
							<td colspan="3" class="table_td_contents"><input id="srcUserNm4" name="srcUserNm4" type="text" value="" size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">비밀번호</td>
							<td class="table_td_contents"><input id="srcUserNm" name="srcUserNm" type="text" value="" size="20" maxlength="30" /></td>
							<td width="100" class="table_td_subject9">비밀번호 확인</td>
							<td class="table_td_contents"><input id="srcLoginId3" name="srcLoginId3" type="text" value="" size="20" maxlength="30" class="input_text_none" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">성명</td>
							<td class="table_td_contents"><input id="srcUserNm5" name="srcUserNm5" type="text" value="" size="20" maxlength="30" /></td>
							<td width="100" class="table_td_subject9">전화번호</td>
							<td class="table_td_contents"><input id="srcUserNm7" name="srcUserNm7" type="text" value="" size="20" maxlength="30" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">이동전화번호</td>
							<td class="table_td_contents"><input id="srcLoginId21" name="srcLoginId19" type="text" value="" size="" maxlength="50" style="width: 98%" /></td>
							<td width="100" class="table_td_subject9">이메일</td>
							<td class="table_td_contents"><input id="srcLoginId20" name="srcLoginId20" type="text" value="" size="" maxlength="50" style="width: 98%" /></td>
						</tr>
						<tr>
							<td colspan="4" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject9" width="100">권한정보</td>
							<td colspan="3" class="table_td_contents4">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="50" valign="top" align="right"><img src="/img/system/btn_icon_plus.gif" width="20" height="18" /> <img src="/img/system/btn_icon_minus.gif" width="20" height="18" /></td>
									</tr>
									<tr>
										<td height="50" valign="top">
											<div id="jqgrid">
												<table id="list"></table>
											</div>
										</td>
									</tr>
							</table>
							</td>
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

<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>