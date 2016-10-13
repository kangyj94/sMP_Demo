<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>
<%
	//채권관리
	
	//메뉴id
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-248 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	int EndYear   = 2003;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
		srcYearArr[i] = (StartYear - i) + "";
	}
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click(function(){fnSearch();});
	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });	
	$("#stdMonthExcel").click(function(){ exportStdMonthExcel(); });	
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	$("#srcClientNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	
	$("#srcBusinessNum").keydown(function(e){
			if(e.keyCode == '13'){
			fnSearch();
		}
	});
});

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch(){
	jq("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcClientNm    = $("#srcClientNm").val();
	data.srcBusinessNum = $("#srcBusinessNum").val();
	data.srcAccManageUserId = $("#srcAccManageUserId").val();
	data.srcStandardYear = $("#srcStandardYear").val();
	data.srcStandardMonth = $("#srcStandardMonth").val();
	data.srcEndYear = $("#srcEndYear").val();
	data.srcEndMonth = $("#srcEndMonth").val();
	data.srcIsUse = $("#srcIsUse").val();
	data.srcIsLimit = $("#srcIsLimit").val();
	data.srcTransferStatus = $("#srcTransferStatus").val();
	jq("#list").trigger("reloadGrid");  	
}

//채권별 상세
function onBondsView(clientId){
	if( clientId != "" ){
		var popurl = "/manage/maangeBondsOccurrence.sys?clientId=" + clientId + "&_menuId=<%=_menuId%>&selectType='detail";
		var bondsView = window.open(popurl, 'okplazaPop', 'width=1180, height=800, scrollbars=yes, status=no, resizable=no');
		bondsView.focus();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function exportExcel() {
	var colLabels = ['최초등록일','최종등록일','매출처','사업자등록번호','총채권','수금금액','잔액','평균회수기일','주문제한여부','주문제한횟수'];	//출력컬럼명
	var colIds = ['first_creat_date','creat_date','clientNm','businessNum','sale_tota_amou','rece_pay_amou','balance_amou','avg_day','isLimitStr','sale_over_day'];	//출력컬럼ID
	var numColIds = ['sale_tota_amou','rece_pay_amou','balance_amou','avg_day'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "총 채권현황";	//sheet 타이틀
	var excelFileName = "BondsTotalList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['최초등록일','최종등록일','매출처','사업자등록번호','총채권','수금금액','잔액','평균회수기일','주문제한여부','주문제한횟수'];	//출력컬럼명
	var colIds = ['first_creat_date','creat_date','clientNm','businessNum','sale_tota_amou','rece_pay_amou','balance_amou','avg_day','isLimitStr','sale_over_day'];	//출력컬럼ID
	var numColIds = ['sale_tota_amou','rece_pay_amou','balance_amou','avg_day'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "총 채권현황";	//sheet 타이틀
	var excelFileName = "allBondsTotalList";	//file명
	
	var actionUrl = "/adjust/adjustBondsTotalListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcClientNm';
	fieldSearchParamArray[1] = 'srcBusinessNum';
	fieldSearchParamArray[2] = 'selectType';
	fieldSearchParamArray[3] = 'srcAccManageUserId';
	fieldSearchParamArray[4] = 'srcStandardYear';
	fieldSearchParamArray[5] = 'srcStandardMonth';
	fieldSearchParamArray[6] = 'srcEndYear';
	fieldSearchParamArray[7] = 'srcEndMonth';
	fieldSearchParamArray[8] = 'srcIsUse';
	fieldSearchParamArray[9] = 'srcIsLimitCheck';
	fieldSearchParamArray[10] = 'srcIsLimit';
	fieldSearchParamArray[11] = 'srcTransferStatus';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'/adjust/adjustBondsTotalListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['clientId','최초등록일','최종등록일','매출처','사업자등록번호','사업자','총채권','수금금액','잔액','평균회수기일','채권현황','주문제한여부','주문제한횟수'],
		colModel:[
			{name:'clientId', index:'clientId',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'first_creat_date', index:'first_creat_date',width:100,align:"center",search:false,sortable:true, editable:false },//최초등록일
			{name:'creat_date', index:'creat_date',width:100,align:"center",search:false,sortable:true, editable:false },//최종등록일
			{name:'clientNm', index:'clientNm',width:250,align:"left",search:false,sortable:true, editable:false },//매출처
			{name:'businessNum', index:'businessNum',width:120,align:"center",search:false,sortable:true, editable:false },//사업자등록번호
			{name:'pressentNm',index:'pressentNm',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },//사업자
			{name:'sale_tota_amou',index:'sale_tota_amou',width:120,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//총채권
			{name:'rece_pay_amou',index:'rece_pay_amou',width:120,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수금금액
			{name:'balance_amou',index:'balance_amou',width:120,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//잔액
			{name:'avg_day',index:'avg_day',width:80,align:"center",search:false,sortable:true, editable:false ,
				sorttype:'number',formatter:'number',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 2, prefix:"" }},//평균회수기일
			{name:'bondsInfo',index:'bondsInfo',width:110,align:"center",search:false,sortable:false, editable:false },//채권현황
			{name:'isLimitStr',index:'isLimitStr',width:80,align:"center",search:false,sortable:true, editable:false },//주문제한여부
			{name:'sale_over_day',index:'sale_over_day',width:80,align:"center",search:false,sortable:true, editable:false, hidden:false }//주문제한 횟수
		],
		postData: {
			srcClientNm:$("#srcClientNm").val(),
			srcBusinessNum:$("#srcBusinessNum").val(),
			//srcAccManageUserId:$("#srcAccManageUserId").val(),
			srcStandardYear:$("#srcStandardYear").val(),
			srcStandardMonth:$("#srcStandardMonth").val(),
			srcEndYear:$("#srcEndYear").val(),
			srcEndMonth:$("#srcEndMonth").val(),
			srcIsUse:$("#srcIsUse").val(),
			srcIsLimit:$("#srcIsLimit").val(),
			srcTransferStatus:$("#srcTransferStatus").val(),
			selectType:"list"
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'CLOS_SALE_DATE', sortorder: 'desc',
		caption:"총채권현황", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					var descStr  = "<input type='button' name='bondsView' id='bondsView' value='채권별' onClick=\"javaScript:onBondsView('"+selrowContent.clientId+"')\"/>";
					jq("#list").jqGrid('setRowData', rowid, {bondsInfo:descStr});
				}
			}  			
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true
	});
});
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { manageManual(); });	//메뉴얼호출
});

function manageManual(){
	var header = "";
	var manualPath = "";
	//채권관리
	header = "채권관리";
	manualPath = "/img/manual/manage/manageBondsTotalManual.JPG";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">
						총채권현황 
						&nbsp;<span id="question" class="questionButton">도움말</span>
					</td>
					<td align="right" class="ptitle">
						<a href="#">
							<img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
						</a>
						<a href="#">
							<img id="srcButton" name="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width: 65px; height: 22px;border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />
						</a>
					</td>
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
					<td colspan="8" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="8" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">고객사명</td>
					<td class="table_td_contents">
						<input id="srcClientNm" name="srcClientNm" type="text" value="" size="" maxlength="50" />
					</td>
					<td class="table_td_subject" width="100">사업자등록번호</td>
					<td class="table_td_contents">
						<input id="srcBusinessNum" name="srcBusinessNum" type="text" value="" size="20" maxlength="10" />
					</td>
					<td class="table_td_subject" width="55">검색기간</td>
					<td class="table_td_contents" colspan="3">
						<select id="srcStandardYear" name="srcStandardYear" class="select" style="width: 60px;">
							<option value="">선택</option>
						<%
							for(int i = 0 ; i < srcYearArr.length ; i++){
						%>
							<option value='<%=srcYearArr[i]%>'><%=srcYearArr[i] %></option>
						<%      
							}
						%>
						</select> 년
						<select id="srcStandardMonth" name="srcStandardMonth" class="select" style="width: 60px;">
							<option value="">선택</option>
						<%
							for(int i = 0 ; i < 12 ; i++){
								String monthVal = new Integer(i + 1).toString().length() == 1 ? "0" + new Integer(i + 1) : new Integer(i + 1).toString();
						%>
							<option value='<%=monthVal%>'><%=monthVal %></option>
						<%
							}
						%>
						</select> 월 ~ 
						<select id="srcEndYear" name="srcEndYear" class="select" style="width: 60px;">
							<option value="">선택</option>
						<%
							for(int i = 0 ; i < srcYearArr.length ; i++){
						%>
							<option value='<%=srcYearArr[i]%>'><%=srcYearArr[i] %></option>
						<%      
							}
						%>
						</select> 년
						<select id="srcEndMonth" name="srcEndMonth" class="select" style="width: 60px;">
							<option value="">선택</option>
						<%
							for(int i = 0 ; i < 12 ; i++){
								String monthVal = new Integer(i + 1).toString().length() == 1 ? "0" + new Integer(i + 1) : new Integer(i + 1).toString();
						%>
							<option value='<%=monthVal%>'><%=monthVal %></option>
						<%
							}
						%>
						</select> 월
					</td>
				</tr>
				<tr>
					<td colspan="8" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="40">주문제한</td>
					<td class="table_td_contents">
						<select id="srcIsLimit" name="srcIsLimit" class="select" >
							<option value="">전체</option>
							<option value="0">주문정상</option>
							<option value="1">주문제한</option>
						</select>
					</td>
					<td class="table_td_subject" width="40">상태</td>
					<td class="table_td_contents">
						<select id="srcIsUse" name="srcIsUse" class="select" >
							<option value="">전체</option>
							<option value="1">정상</option>
							<option value="0">종료</option>
						</select>
					</td>
					
				</tr>
				<tr>
					<td colspan="8" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table border="0" width="100%">
				<tr>
					<td align="left" valign="bottom" colspan="5"><font color="red">*</font> 평균회수기간 : Σ { (수금일 - 세금계산서 발급일) * 수금금액 } / 총 채권</td>
					<td align="right" valign="bottom">
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> 
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					</td>
				</tr>
			</table>
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
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<!-------------------------------- Dialog Div Start -------------------------------->
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>