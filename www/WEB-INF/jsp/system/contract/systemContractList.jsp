<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-245 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	systemContractList();	//그리드 초기화
	$("#srcSearchButton").click(function(){ fnSearch(); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#allExcelButton").click(function(){ exportExcelToSvc(); });
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>
<script type="text/javascript">
function systemContractList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/contractListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['순번','고객사','사업자등록번호','법인명','사업장명','특별계약','사용자ID','사용자명','계약 VER','변경 계약일'],
		colModel:[
			{name:'contractNo',index:'contractNo', width:80, align:"center",search:false,sortable:true, hidden:true},//순번
			{name:'contractClassify',index:'contractClassify', width:120, align:"center",search:false,sortable:true},//구분
			{name:'businessNum',index:'businessNum', width:120, align:"center",search:false,sortable:true},//사업자등록번호
			{name:'borgNm',index:'borgNm', width:180, align:"center",search:false,sortable:true},//법인명
			{name:'branchNm',index:'branchNm', width:180, align:"center",search:false,sortable:true},//사업장, 공급사 명
			{name:'contractSpecial',index:'contractSpecial', width:180, align:"center",search:false,sortable:true},//계약구분
			{name:'userId',index:'userId', width:100, align:"center",search:false,sortable:true},//사용자 아이디
			{name:'userNm',index:'userNm', width:100, align:"center",search:false,sortable:true},//사용자명
			{name:'contractVersion',index:'contractVersion', width:100, align:"center",search:false,sortable:true},//계약 VER
			{name:'contractDate',index:'contractDate', width:120, align:"center",search:false,sortable:true, 
				sorttype:"date", editable:false,formatter:"date"},//변경 계약일
		],
		postData: {
			srcBorgNm:$("#srcBorgNm").val(),
			srcContractVersion:$("#srcContractVersion").val(),
			srcBusinessNum :$("#srcBusinessNum").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'contractNo', sortorder: "DESC",
		caption:"물품공급계약서 서명 내역",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true
	});
}

//검색펑션
function fnSearch() {
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcBorgNm = $("#srcBorgNm").val();
	data.srcContractVersion = $("#srcContractVersion").val();
	data.srcBusinessNum = $("#srcBusinessNum").val();
	jq("#list").jqGrid("setGridParam", { "postData":data});
	jq("#list").trigger("reloadGrid");
}

//엑셀 출력
function exportExcel() {
	var colLabels = ['고객사','사업자등록번호','법인명','사업장명','특별계약','사용자ID','사용자명','계약 VER','변경 계약일'];//출력컬럼명
	var colIds = ['contractClassify','businessNum','borgNm','branchNm','contractSpecial','userId','userNm','contractVersion','contractDate'];	//출력컬럼ID
	var numColIds = ['businessNum'];	//숫자표현ID
	var sheetTitle = "물품공급계약서 서명내역";	//sheet 타이틀
	var excelFileName = "systemContarctList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['고객사','사업자등록번호','법인명','사업장명','특별계약','사용자ID','사용자명','계약 VER','변경 계약일'];//출력컬럼명
	var colIds = ['contractClassify','businessNum','borgNm','branchNm','contractSpecial','userId','userNm','contractVersion','contractDate'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var sheetTitle = "물품공급계약서 서명내역";	//sheet 타이틀
	var excelFileName = "systemAllContarctList";	//file명
	
	var actionUrl = "/system/systemContractListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcContractVersion';

	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

</script>
<title>Insert title here</title>
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
						<td height="29" class='ptitle'>물품공급계약서 서명내역</td>
						<td align="right">
							<a href="#">
								<img id="allExcelButton" src="/img/system/btn_type3_orderResultExcel.gif" width="130" height="22" style="cursor:pointer;"/>
								<img id="srcSearchButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
							</a>
						</td>
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

						<td class="table_td_subject" width="100">계약버전</td>
						<td class="table_td_contents">
							<input type="text" id="srcContractVersion" name="srcContractVersion">
						</td>
						<td class="table_td_subject" width="100">법인명</td>
						<td class="table_td_contents">
							<input type="text" id="srcBorgNm" name="srcBorgNm" value=""/>
<!-- 							<a href="#"> -->
<!-- 								<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" /> -->
<!-- 							</a> -->
						</td>
						<td class="table_td_subject" width="100">사업자등록번호</td>
						<td class="table_td_contents">
							<input type="text" id="srcBusinessNum" name="srcBusinessNum" value=""/>
						</td>
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
			<td align="right">
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
</form>
</body>
</html>