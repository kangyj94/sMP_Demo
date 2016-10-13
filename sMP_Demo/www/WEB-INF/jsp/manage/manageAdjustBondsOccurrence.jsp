<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.adjust.dto.AdjustDto" %>
<%@ page import="java.util.List" %>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%
	
	//그리드의 width와 Height을 정의
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	String listHeight = "$(window).height()-600 + Number(gridHeightResizePlus)";
	String list2Height = "$(window).height()-600 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	AdjustDto detailInfo = (AdjustDto)request.getAttribute("detailInfo");
	
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

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	//버튼이벤트
	$("#srcButton").click(function(){fnSearch();});
	
	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	$("#colButton2").click( function(){ jq("#list2").jqGrid('columnChooser'); });
	$("#excelButton2").click(function(){ exportExcel2(); });
});




</script>


<script type="text/javascript">
var isOnLoad = false;
var setRowId = "";
jq(function() {
	jq("#list").jqGrid({
		url:'/adjust/adjustBondsCompanyListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['sale_sequ_numb','accManageUserId','전표번호','사업장명','계산서일자','총채권','입금일자','입금액','잔액','구분','만기일','경과월','초과일수'],
		colModel:[
			{name:'sale_sequ_numb', index:'sale_sequ_numb',width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'accManageUserId', index:'accManageUserId',width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'sap_jour_numb', index:'sap_jour_numb',width:100,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'branchNm', index:'branchNm',width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'clos_sale_date', index:'clos_sale_date',width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'sale_tota_amou', index:'sale_tota_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'alram_date',index:'alram_date',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true },//입금일자
			{name:'rece_pay_amou',index:'rece_pay_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//입금액
			{name:'none_coll_amou',index:'none_coll_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
			sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//잔액
			{name:'tran_status_nm',index:'tran_status_nm',width:60,align:"center",search:false,sortable:true, editable:false },//구분
			{name:'expiration_date',index:'expiration_date',width:100,align:"center",search:false,sortable:true, editable:false },//만기일
			{name:'sale_over_month',index:'sale_over_month',width:70,align:"center",search:false,sortable:true, editable:false },//경과월
			{name:'sale_over_day',index:'over_date',width:70,align:"center",search:false,sortable:true, editable:false }//초과일수
		],
		postData: {
			clientId:'<%=detailInfo.getClientId()%>',
			srcPayStat:$("#srcPayStat").val(),
			srcTranStat:$("#srcTranStat").val(),
			srcClosStartYear:$("#srcClosStartYear").val(), 
			srcClosStartMonth:$("#srcClosStartMonth").val(), 
			srcClosEndYear:$("#srcClosEndYear").val(),
			srcClosEndMonth:$("#srcClosEndMonth").val(),
			srcBranchId:$("#srcBranchId").val()
		},
		rowNum:0, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width: <%=listWidth%>,
		sortname: 'clos_sale_date', sortorder: 'desc',
		caption:"발생채권별현황", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var sum_sale_tota_amou = 0;
			var sum_rece_pay_amou = 0;
			var sum_none_coll_amou = 0;
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				if(setRowId == ""){
					setRowId = $("#list").getDataIDs()[0]; //첫번째 로우 아이디 구하기	
				}
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					sum_sale_tota_amou += parseInt(selrowContent.sale_tota_amou);
					sum_rece_pay_amou += parseInt(selrowContent.rece_pay_amou);
					sum_none_coll_amou += parseInt(selrowContent.none_coll_amou);  
				}
				isOnLoad = true;
				jq("#list").setSelection(setRowId);
			}
			var userData = jq("#list").jqGrid("getGridParam","userData");
			userData.clos_sale_date = "합계";
			userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
			userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
			userData.rece_pay_amou = fnComma(sum_rece_pay_amou);
			userData.none_coll_amou = fnComma(sum_none_coll_amou);
			jq("#list").jqGrid("footerData","set",userData,false);
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt > 0) {
				var id = $("#list").jqGrid('getGridParam', "selrow" );
				var selrowContent = jq("#list").jqGrid('getRowData',id);
				fnInitList(selrowContent.sale_sequ_numb, selrowContent.sap_jour_numb, isOnLoad);
				$("#sel_sale_sequ_numb").val(selrowContent.sale_sequ_numb);
				$("#sel_rece_pay_amou").val(selrowContent.sale_tota_amou);
				var userId = '<%=userInfoDto.getUserId()%>';
				if(selrowContent.accManageUserId == userId){
					$("#regButton2").show();
					$("#delButton2").show();
				}else{
					$("#regButton2").hide();
					$("#delButton2").hide();
				}
				setRowId = id;
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true,
		footerrow: true,
		userDataOnFooter: true
	});
	jQuery("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: 'sale_over_month', numberOfColumns: 3, titleText: '<em>지연현황</em>'}
		]
	});

	jq("#list2").jqGrid({
		url:'/system/getBlank.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['recep_alram_id', 'rece_sequ_num', 'sale_sequ_numb', 'rece_pay_amou','전표번호','작성일자','입금예정일자','입금예정금액','통화자','입금일자','내용','처리금액','작성자'],
		colModel:[
			{name:'recep_alram_id',index:'recep_alram_id',width:100,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'rece_sequ_num', index:'rece_sequ_num',width:60,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'sale_sequ_numb', index:'sale_sequ_numb',width:60,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'rece_pay_amou', index:'rece_pay_amou',width:80,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'sap_jour_numb', index:'sap_jour_numb',width:80,align:"center",search:false,sortable:true, editable:false,hidden:true },
			{name:'creat_date', index:'creat_date',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'schedule_date', index:'schedule_date',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'schedule_amou',index:'schedule_amou',width:80,align:"right",search:false,sortable:true, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'tel_user_nm',index:'tel_user_nm',width:80,align:"left",search:false,sortable:true, editable:false },
			{name:'pay_date', index:'pay_date',width:120,align:"center",search:false,sortable:true, editable:false },
			{name:'context',index:'context',width:200,align:"left",search:false,sortable:true, editable:false },
			{name:'rece_pay_amou',index:'rece_pay_amou',width:80,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'rece_user_nm',index:'rece_user_nm',width:80,align:"left",search:false,sortable:true, editable:false }
		],
		postData: {},
		rowNum:0, rownumbers: true, 
		height: <%=list2Height%>, width: <%=listWidth%>, //autowidth: true,
		sortname: 'creat_date', sortorder: 'desc',
		caption:"채권회수활동", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
	jQuery("#list2").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: '전표번호', numberOfColumns: 4, titleText: '<em>채권회수활동</em>'}
		]
	});
});


function fnSearch(){
	jq("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");
	alert(333);
	data.srcPayStat = $("#srcPayStat").val();
	data.srcTranStat = $("#srcTranStat").val();
	data.srcClosStartYear = $("#srcClosStartYear").val(); 
	data.srcClosStartMonth = $("#srcClosStartMonth").val();
	data.srcClosEndYear = $("#srcClosEndYear").val();
	data.srcClosEndMonth = $("#srcClosEndMonth").val();
	data.clientId = '<%=detailInfo.getClientId()%>'; 
	data.srcBranchId = $("#srcBranchId").val(); 
	jq("#list").trigger("reloadGrid");
}

function fnInitList(sale_sequ_numb, sap_jour_numb, isOnLoad) {
	if(isOnLoad){
		$("#list2").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustSalesDepositDescListJQGrid.sys'});
		var data = jq("#list2").jqGrid("getGridParam", "postData");
		data.sale_sequ_numb = sale_sequ_numb;
		data.sap_jour_numb = sap_jour_numb;
		data.isBonds = 'Y';
		jq("#list2").jqGrid("setGridParam", { "postData": data });
		jq("#list2").trigger("reloadGrid"); 		
	}
}

//3자리수마다 콤마
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

//발생채권현황 엑셀다운
function exportExcel() {
	var colLabels = ['사업장명','계산서일자','총채권','입금액','잔액','구분','만기일','지연현황 경과월','지연현황 초과일수'];//출력컬럼명
	var colIds = ['branchNm','clos_sale_date','sale_tota_amou','rece_pay_amou','none_coll_amou','tran_status_nm','expiration_date','sale_over_month','sale_over_day'];  //출력컬럼ID
	var numColIds = ['sale_tota_amou','rece_pay_amou','none_coll_amou']; //숫자표현ID
	var sheetTitle = "발생채권별현황";   //sheet 타이틀
	var excelFileName = "BondsOccurrenceList";   //file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//채권회수 활동 엑셀다운
function exportExcel2() {
	var colLabels = ['작성일자','입금일자','처리금액','내용','작성자'];	//출력컬럼명
	var colIds = ['creat_date','pay_date','rece_pay_amou','context','rece_user_nm'];	//출력컬럼ID
	var numColIds = ['rece_pay_amou'];	//숫자표현ID
	var sheetTitle = "채권회수활동";	//sheet 타이틀
	var excelFileName = "SalesDepositDesc";	//file명
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
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
						<img src="/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">발생채권별현황</td>
					<td align="right" class="ptitle">&nbsp;</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="20" valign="top">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
					</td>
					<td class="stitle">채권목록</td>
					<td align="right" class="stitle">
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
					<td class="table_td_subject" width="100">마감일</td>
					<td class="table_td_contents">
						<select id="srcClosStartYear" name="srcClosStartYear" class="select" style="width: 60px;">
<%
						for(int i = 0 ; i < srcYearArr.length ; i++){
%>
							<option value='<%=srcYearArr[i]%>' <%="2010".equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%
						}
%>
						</select> 년
						<select id="srcClosStartMonth" name="srcClosStartMonth" class="select" style="width: 40px;">
<%
						for(int i = 0 ; i < 12 ; i++){
%>
							<option value='<%=i+1%>' <%="1".equals(i+1 + "") ? "selected" : "" %>><%=i+1 %></option>
<%
						}
%>
						</select> 월 ~
						<select id="srcClosEndYear" name="srcClosEndYear" class="select" style="width: 60px;">
<%
						for(int i = 0 ; i < srcYearArr.length ; i++){
%>
							<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%
						}
%>
						</select> 년
						<select id="srcClosEndMonth" name="srcClosEndMonth" class="select" style="width: 40px;">
<%
 						for(int i = 0 ; i < 12 ; i++){
%>
							<option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%
						}
%>
						</select> 월
					</td>
					<td class="table_td_subject" width="100">관리사업장</td>
					<td class="table_td_contents">
						<select id="srcBranchId" name="srcBranchId" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">잔액여부</td>
					<td class="table_td_contents">
						<select id="srcPayStat" name="srcPayStat" class="select">
							<option value="">전체</option>
							<option value="10" selected="selected">있음</option>
							<option value="20">없음</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">구분</td>
					<td class="table_td_contents">
						<select id="srcTranStat" name="srcTranStat" class="select">
							<option value="">전체</option>
							<option value="0">정상</option>
							<option value="1">관리</option>
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
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<!--그리드 분할 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" valign="bottom">
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> 
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					</td>
				</tr>
				<tr>
					<td valign="top">
						<div id="jqgrid">
							<table id="list"></table>
						</div>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="right" valign="bottom">
						<a href="#"><img id="colButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> 
						<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					</td>
				</tr>
				<tr>
					<td valign="top">
						<div id="jqgrid">
							<table id="list2"></table>
						</div>
					</td>
				</tr>
			</table>
			<!-- 그리드 분할 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<!-- ------------------------------ Dialog Div Start ------------------------------ -->
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>            
<!-- ------------------------------ Dialog Div End ------------------------------ -->
</body>
</html>