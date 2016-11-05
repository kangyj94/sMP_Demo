<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-280 + Number(gridHeightResizePlus)";

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
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
});

//리사이징
$(window).bind('resize', function() { 
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:[],
		colModel:[
			{name:'주문번호',index:'주문번호', width:90,align:"center",search:false,sortable:true, editable:false },
			{name:'주문유형',index:'주문유형', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'주문일자',index:'주문일자', width:90,align:"center",search:false,sortable:true, editable:false },
			{name:'고객사',index:'고객사', width:250,align:"left",search:false,sortable:true, editable:false },
			{name:'주문자',index:'주문자', width:90,align:"left",search:false,sortable:true, editable:false },
			{name:'주문명',index:'주문명', width:250,align:"left",search:false,sortable:true, editable:false },
			{name:'주문상태',index:'주문상태', width:170,align:"center",search:false,sortable:true, editable:false },
			{name:'상품명',index:'상품명', width:200,align:"left",search:false,sortable:true, editable:false },
			{name:'판매단가',index:'판매단가', width:90,align:"right",search:false,sortable:true, editable:false },
			{name:'수량',index:'수량', width:90,align:"right",search:false,sortable:true, editable:false },
			{name:'판매금액',index:'판매금액', width:90,align:"right",search:false,sortable:true, editable:false },
			{name:'매입단가',index:'매입단가', width:90,align:"right",search:false,sortable:true, editable:false },
			{name:'매입금액',index:'매입금액', width:90,align:"right",search:false,sortable:false, editable:false },
			{name:'납품요청일',index:'납품요청일', width:90,align:"center",search:false,sortable:false, editable:false }
		],
		postData: {},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		caption:"물량배분 주문조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/**
 * list Excel Export
 개발시 수정 부분
 */
function exportExcel() {
	var colLabels = ['유형코드','유형명','유형구분','사용여부','유형설명'];	//출력컬럼명
	var colIds = ['codeTypeCd','codeTypeNm','codeFlag','isUse','codeTypeDesc'];	//출력컬럼ID
	var numColIds = ['codeFlag','isUse'];	//숫자표현ID
	var sheetTitle = "코드유형";	//sheet 타이틀
	var excelFileName = "CodeTypeList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
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
							<td height="29" class='ptitle'>주문조회(물량배분 발주처리)</td>
							<td align="right" class='ptitle'><img src="/img/system/btn_type3_search.gif" width="65" height="22" /></td>
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
							<td class="table_td_subject" width="100">주문번호</td>
							<td class="table_td_contents"><input id="srcLoginId4" name="srcLoginId4" type="text" value="" size="" maxlength="50" style="width:100px" /></td>
							<td width="100" class="table_td_subject">고객사</td>
							<td colspan="3" class="table_td_contents"><input id="srcLoginId7" name="srcLoginId2" type="text" value="" size="20" maxlength="30" style="width:350px " /> <img src="/img/system/btn_icon_search.gif" width="20" height="18" align="absmiddle" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">공급업체</td>
							<td class="table_td_contents"><input id="srcLoginId" name="srcLoginId" type="text" value="" size="20" maxlength="30" style="width: 100px" /> <img src="/img/system/btn_icon_search.gif" width="20" height="18" align="absmiddle" /></td>
							<td class="table_td_subject">상품코드</td>
							<td class="table_td_contents"><input id="srcLoginId2" name="srcLoginId3" type="text" value="" size="20" maxlength="30" style="width: 100px" /> <img src="/img/system/btn_icon_search.gif" width="20" height="18" align="absmiddle" /></td>
							<td width="100" class="table_td_subject">상품명</td>
							<td class="table_td_contents"><input id="srcLoginId4" name="srcLoginId4" type="text" value="" size="" maxlength="50" style="width: 100px" /></td> </tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">주문상태</td>
							<td class="table_td_contents">
							<select id="srcIsDefault3" name="srcIsDefault3" class="select" disabled="disabled">
									<option>주문요청(물량배분)</option>
							</select></td>
							<td class="table_td_subject">주문일</td>
							<td class="table_td_contents">
							<select id="srcIsDefault" name="srcIsDefault" class="select">
									<option>선택하세요</option>
							</select> ~ <select id="srcIsDefault2" name="srcIsDefault2" class="select">
									<option>선택하세요</option>
							</select></td>
							<td width="100" class="table_td_subject">주문자</td>
							<td class="table_td_contents"><input id="srcLoginId3" name="srcLoginId5" type="text" value="" size="20" maxlength="30" style="width: 100px" /> <img src="/img/system/btn_icon_search.gif" width="20" height="18" align="absmiddle" /></td>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> 
					<!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr height="10">
				<td></td>
			</tr>
			<tr>
				<td align="right">
					* 더블클릭 하시면 주문상세정보를 보실 수 있습니다.
					<input type="button"  value="주문상세 테스트 페이지 열기" onclick="javascript:onDetail();"/>
					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				</td>
			</tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list"></table>
						<div id="pager"></div>
					</div>
				</td>
			</tr>
		</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>