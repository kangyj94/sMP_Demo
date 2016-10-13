<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%
@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
%>
<title>상품일괄등록</title>
    <%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
</head>
<body>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!--타이틀 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>상품일괄등록</td>
						<td align="right" class="ptitle" >
                            <button id='xlsButton' class="btn btn-primary btn-sm" style=><i class="fa fa-file-excel-o"></i> 엑셀업로드</button>
						</td>
					</tr>
				</table>
				<!--타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">상품코드</td>
						<td class="table_td_contents">
							<input type="text" id="goodIdenNumb" name="goodIdenNumb" value=""/>
						</td>
						<td class="table_td_subject" width="100">상품명</td>
						<td class="table_td_contents">
							<input type="text" id="goodName" name="goodName" value=""/>
						</td>
						<td class="table_td_subject" width="100">수정기간</td>
						<td class="table_td_contents">
							<input type="text" name="productHistoryStartDate" id="productHistoryStartDate" style="width: 75px; vertical-align: middle;" />
							~
							<input type="text" name="productHistoryEndDate" id="productHistoryEndDate" style="width: 75px; vertical-align: middle;" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" height="1" bgcolor="eaeaea"></td>
					</tr>
<!-- 					<tr> -->
<!-- 						<td class="table_td_subject" width="100">구분</td> -->
<!-- 						<td class="table_td_contents"> -->
<!-- 							<select id="division" name="division" class="select"> -->
<!-- 								<option value="">전체</option> -->
<!-- 								<option value="1">신규</option> -->
<!-- 								<option value="2">종료</option> -->
<!-- 								<option value="3">변경</option> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 						<td class="table_td_subject" width="100">변경자명</td> -->
<!-- 						<td class="table_td_contents"> -->
<!-- 							<select class="select"> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 						<td class="table_td_subject" width="100">공급사</td> -->
<!-- 						<td class="table_td_contents"> -->
							
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="top" width="500" rowspan="5">
							<!-- 상품조회 시작 -->
							<div id="jqgrid">
								<table id="list1"></table>
								<div id="pager1"></div>
							</div>
							<!-- 상품조회 끝 -->
						</td>
						<td rowspan="5">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						<!-- 기본상품변경정보 시작 -->
						<td valign="top">
							<div id="jqgrid">
								<table id="list2"></table>
								<div id="pager2"></div>
							</div>
						</td>
						<!-- 기본상품변경정보 끝 -->
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<!-- 공급사별정보 시작 -->
					<tr>
						<td valign="top">
							<div id="jqgrid">
								<table id="list3"></table>
								<div id="pager3"></div>
							</div>
						</td>
					
					</tr>
					<!-- 공급사별정보 끝 -->
				</table>
			</td>
		</tr>
	</table>
</body>
</html>