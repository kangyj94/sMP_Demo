<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	String _menuId = CommonUtils.getRequestMenuId(request);

   //그리드의 width와 Height을 정의
   String listHeight = "$(window).height()-358 + Number(gridHeightResizePlus)";
//    String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
   String listWidth = "1500";

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
	
	//메인페이지 경영정보 에서 보낸파라미터
	String transferStatus = CommonUtils.getString(request.getParameter("flag1"));//이관여부
	String isLimit = CommonUtils.getString(request.getParameter("flag2"));//주문제한여부
	
	String menuTitle = "채권관리";
	if (userInfoDto.isSKBMng() == true || userInfoDto.isSKTMng() ==true) { menuTitle = "자재대금 결제현황";} 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
.ui-jqgrid .ui-jqgrid-htable th div {
	white-space:normal !important; height:auto !important; padding:2px;
}
</style>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

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

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBondsTotalListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
// 		colNames:['clientId','최초등록일','최종등록일','매출처','사업자등록번호','사업자','총채권','수금금액','잔액','평균회수기일','채권현황','주문제한여부','채권 담당자','상태','이관여부','주문제한 횟수'],
		colNames:['clientId','최초등록일','최종등록일','매출처','사업자등록번호','사업자','총채권','수금금액','잔액','누적<br/>평균회수기일','연간<br/>평균회수기일','채권현황','주문제한'/*,'채권 담당자','상태'*/,'채권이관','선입금여부','주문제한횟수'],
		colModel:[
			{name:'clientId', index:'clientId',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },
			{name:'first_creat_date', index:'first_creat_date',width:75,align:"center",search:false,sortable:true, editable:false },//최초등록일
			{name:'creat_date', index:'creat_date',width:75,align:"center",search:false,sortable:true, editable:false },//최종등록일
			{name:'clientNm', index:'clientNm',width:200,align:"left",search:false,sortable:true, editable:false },//매출처
			{name:'businessNum', index:'businessNum',width:85,align:"center",search:false,sortable:true, editable:false },//사업자등록번호
			{name:'pressentNm',index:'pressentNm',width:90,align:"center",search:false,sortable:true, editable:false, hidden:true },//사업자
			{name:'sale_tota_amou',index:'sale_tota_amou',width:100,align:"right",search:false,sortable:true, editable:false ,
			sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//총채권
			{name:'rece_pay_amou',index:'rece_pay_amou',width:100,align:"right",search:false,sortable:true, editable:false ,
			sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//수금금액
			{name:'balance_amou',index:'balance_amou',width:100,align:"right",search:false,sortable:true, editable:false ,
			sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//잔액
			{name:'avg_day',index:'avg_day',width:90,align:"center",search:false,sortable:true, editable:false ,
			sorttype:'number',formatter:'number',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 1, prefix:"" }},//평균회수기일
			{name:'avg_day2',index:'avg_day2',width:90,align:"center",search:false,sortable:true, editable:false ,
				sorttype:'number',formatter:'number',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 1, prefix:"" }},//평균회수기일
			{name:'bondsInfo',index:'bondsInfo',width:140,align:"center",search:false,sortable:false, editable:false },	//채권현황
			{name:'isLimitStr',index:'isLimitStr',width:80,align:"center",search:false,sortable:true, editable:false },	//주문제한
// 			{name:'userNm',index:'userNm',width:80,align:"center",search:false,sortable:true, editable:false, hidden:false },
// 			{name:'isUse',index:'isUse',width:80,align:"center",search:false,sortable:true, editable:false, hidden:false },
			{name:'transfer_status',index:'transfer_status',width:80,align:"center",search:false,sortable:true, editable:false, hidden:false },//이관여부
			{name:'isprepay',index:'isprepay',width:65,align:"center",search:false,sortable:true, editable:false, hidden:false },//선입금여부
			{name:'sale_over_day',index:'sale_over_day',width:100,align:"center",search:false,sortable:true, editable:false, hidden:false }//주문제한 횟수
		],
		postData: {
		   	srcClientNm:$("#srcClientNm").val(),
		   	srcBusinessNum:$("#srcBusinessNum").val(),
		   	srcAccManageUserId:$("#srcAccManageUserId").val(),
		   	srcStandardYear:$("#srcStandardYear").val(),
		   	srcStandardMonth:$("#srcStandardMonth").val(),
		   	srcEndYear:$("#srcEndYear").val(),
		   	srcEndMonth:$("#srcEndMonth").val(),
		   	srcIsUse:$("#srcIsUse").val(),
		   	srcIsLimit:$("#srcIsLimit").val(),
		   	srcTransferStatus:$("#srcTransferStatus").val(),
		   	srcPrePay:$("#srcPrePay").val(),
		   	selectType:"list"
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'CLOS_SALE_DATE', sortorder: 'desc',
		caption:"", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					var descStr  = "<a onClick=\"javaScript:onBranchView('"+selrowContent.clientId+"')\" id='detailButton' class='btn btn-default btn-xs' style='padding-top: 0px;padding-bottom: 0px;border-radius: 5px;'><i class='fa fa-search'></i>업체별</a>";
					    descStr += "&nbsp;";
						descStr += "<a onClick=\"javaScript:onBondsView('"+selrowContent.clientId+"')\" id='detailButton' class='btn btn-default btn-xs' style='padding-top: 0px;padding-bottom: 0px;border-radius: 5px;'><i class='fa fa-search'></i>채권별</a>";
					jq("#list").jqGrid('setRowData', rowid, {bondsInfo:descStr});
				}
			}
			var userData = $("#list").jqGrid("getGridParam","userData");
			$("#userDataText").html(" * 총채권 : "+$.number(userData.SALESUM)+" 원, &nbsp;&nbsp;&nbsp; 총잔액 : "+$.number(userData.REMAINSUM)+" 원");
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell", userdata:"userdata"},
		rownumbers:true
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch(){
	var startYear = $("#srcStandardYear").val();
	var startMonth = $("#srcStandardMonth").val();
	var endYear = $("#srcEndYear").val();
	var endMonth = $("#srcEndMonth").val();
	if(startYear.length>0 || startMonth.length>0 || endYear.length>0 || endMonth.length>0) {
		if(startYear.length==0 || startMonth.length==0 || endYear.length==0 || endMonth.length==0) {
			alert("검색기간은 모두 입력하셔야 합니다.");
			return;
		}
	}
	
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
   	data.srcPrePay = $("#srcPrePay").val();
   	jq("#list").trigger("reloadGrid");  	
}

//업체별 상세
function onBranchView(clientId){
	if( clientId != "" ){
		var popurl = "/adjust/adjustBondsCompany.sys?clientId=" + clientId + "&_menuId=<%=_menuId%>&selectType='detail'";
		var popproperty = "dialogWidth:1100px;dialogHeight=680px;scroll=yes;status=no;resizable=no;";
		//window.showModalDialog(popurl,self,popproperty);
		var branchView = window.open(popurl, 'okplazaPop', 'width=1100, height=850, scrollbars=yes, status=no, resizable=no');
		branchView.focus();
	} else { jq( "#dialogSelectRow" ).dialog(); }      	
}

//채권별 상세
function onBondsView(clientId){
	if( clientId != "" ){
		var popurl = "/adjust/adjustBondsOccurrence.sys?clientId=" + clientId + "&_menuId=<%=_menuId%>&selectType='detail";
		var popproperty = "dialogWidth:1180px;dialogHeight=800px;scroll=yes;status=no;resizable=no;";
		var bondsView = window.open(popurl, 'okplazaPop', 'width=1180, height=800, scrollbars=yes, status=no, resizable=no');
		//window.showModalDialog(popurl,self,popproperty);
		bondsView.focus();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function exportExcel() {
	var colLabels = ['최초등록일','최종등록일','매출처','사업자등록번호','사업자','총채권','수금금액','잔액','평균회수기일','주문제한여부','채권담당자','상태','이관여부','주문제한 횟수'];	//출력컬럼명
	var colIds = ['first_creat_date','creat_date','clientNm','businessNum','pressentNm','sale_tota_amou','rece_pay_amou','balance_amou','avg_day','isLimitStr','userNm','isUse','transfer_status','sale_over_day'];	//출력컬럼ID
	var numColIds = ['sale_tota_amou','rece_pay_amou','balance_amou','avg_day'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "총 채권현황";	//sheet 타이틀
	var excelFileName = "BondsTotalList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['최초등록일','최종등록일','매출처','사업자등록번호','사업자','총채권','수금금액','잔액','평균회수기일','주문제한여부','채권담당자','상태','이관여부','주문제한 횟수'];	//출력컬럼명
	var colIds = ['firstCreatDate','creat_date','clientNm','businessNum','pressentNm','sale_tota_amou','rece_pay_amou','balance_amou','avg_day','isLimitStr','userNm','isUse','transfer_status','sale_over_day'];	//출력컬럼ID
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

function exportStdMonthExcel(){
	var selMon = $("#selMon").val();
	var srcStdMonthStandard  = $("#srcStdMonthStandard").val();
	var colLabels;
	var colIds;
	var numColIds;
	var figureColIds;
	var resultDate = new Date();
	resultDate.setYear($("#stdYear").val());
	resultDate.setMonth($("#stdMonth").val()-1);
	if("0"==srcStdMonthStandard){
		if(selMon == "3"){
			var tmpDate = new Array();
			for(var i=0;i<4;i++) {
				if(i==3) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['업체코드','사업자번호','업체명','채권담당자','고객유형','결제조건','잔액','당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월이상'+tmpDate[3],'계'];	//출력컬럼명
			colIds = ['BRANCHID','BUSINESSNUM','BRANCHNM','USERNM','WORKNM','PAYBILLTYPE','TOTAL','M0','M1','M2','M3','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}else if(selMon == "5"){
			var tmpDate = new Array();
			for(var i=0;i<6;i++) {
				if(i==5) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['업체코드','사업자번호','업체명','채권담당자','고객유형','결제조건','잔액','당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월'+tmpDate[3],'4개월'+tmpDate[4],'5개월이상'+tmpDate[5],'계'];	//출력컬럼명
			colIds = ['BRANCHID','BUSINESSNUM','BRANCHNM','USERNM','WORKNM','PAYBILLTYPE','TOTAL','M0','M1','M2','M3','M4','M5','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','M4','M5','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}else if(selMon == "6"){
			var tmpDate = new Array();
			for(var i=0;i<7;i++) {
				if(i==6) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['업체코드','사업자번호','업체명','채권담당자','고객유형','결제조건','잔액','당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월'+tmpDate[3],'4개월'+tmpDate[4],'5개월'+tmpDate[5],'6개월이상'+tmpDate[6],'계'];	//출력컬럼명
			colIds = ['BRANCHID','BUSINESSNUM','BRANCHNM','USERNM','WORKNM','PAYBILLTYPE','TOTAL','M0','M1','M2','M3','M4','M5','M6','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','M4','M5','M6','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}else if(selMon == "12"){
			var tmpDate = new Array();
			for(var i=0;i<13;i++) {
				if(i==12) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['업체코드','사업자번호','업체명','채권담당자','고객유형','결제조건','잔액','당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월'+tmpDate[3]
						,'4개월'+tmpDate[4],'5개월'+tmpDate[5],'6개월'+tmpDate[6],'7개월'+tmpDate[7],'8개월'+tmpDate[8],'9개월'+tmpDate[9]
						,'10개월'+tmpDate[10],'11개월'+tmpDate[11],'12개월이상'+tmpDate[12],'계'];	//출력컬럼명
			colIds = ['BRANCHID','BUSINESSNUM','BRANCHNM','USERNM','WORKNM','PAYBILLTYPE','TOTAL','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}else if(selMon == "30"){
			var tmpDate = new Array();
			for(var i=0;i<32;i++) {
				if(i==31) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['업체코드','사업자번호','업체명','채권담당자','고객유형','결제조건','잔액',
			             '당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월'+tmpDate[3],'4개월'+tmpDate[4],'5개월'+tmpDate[5],
			             '6개월'+tmpDate[6],'7개월'+tmpDate[7],'8개월'+tmpDate[8],'9개월'+tmpDate[9],'10개월'+tmpDate[10],
			             '11개월'+tmpDate[11],'12개월'+tmpDate[12],'13개월'+tmpDate[13],'14개월'+tmpDate[14],'15개월'+tmpDate[15],
			             '16개월'+tmpDate[16],'17개월'+tmpDate[17],'18개월'+tmpDate[18],'19개월'+tmpDate[19],'20개월'+tmpDate[20],
			             '21개월'+tmpDate[21],'22개월'+tmpDate[22],'23개월'+tmpDate[23],'24개월'+tmpDate[24],'25개월'+tmpDate[25],
			             '26개월'+tmpDate[26],'27개월'+tmpDate[27],'28개월'+tmpDate[28],'29개월'+tmpDate[29],'30개월'+tmpDate[30],
			             '31개월이상'+tmpDate[31],'계'];	//출력컬럼명
			colIds = ['BRANCHID','BUSINESSNUM','BRANCHNM','USERNM','WORKNM','PAYBILLTYPE','TOTAL','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','M13','M14','M15','M16','M17','M18','M19','M20','M21','M22','M23','M24','M25','M26','M27','M28','M29','M30', 'M31','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','M13','M14','M15','M16','M17','M18','M19','M20','M21','M22','M23','M24','M25','M26','M27','M28','M29','M30','M31','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}
	}else{
		if(selMon == "3"){
			var tmpDate = new Array();
			for(var i=0;i<4;i++) {
				if(i==3) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['법인코드','사업자번호','법인명','잔액','당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월이상'+tmpDate[3],'계'];	//출력컬럼명
			colIds = ['CLIENTID','BUSINESSNUM','CLIENTNM','TOTAL','M0','M1','M2','M3','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}else if(selMon == "6"){
			var tmpDate = new Array();
			for(var i=0;i<7;i++) {
				if(i==6) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['법인코드','사업자번호','법인명','잔액','당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월'+tmpDate[3],'4개월'+tmpDate[4],'5개월'+tmpDate[5],'6개월이상'+tmpDate[6],'계'];	//출력컬럼명
			colIds = ['CLIENTID','BUSINESSNUM','CLIENTNM','TOTAL','M0','M1','M2','M3','M4','M5','M6','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','M4','M5','M6','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}else if(selMon == "12"){
			var tmpDate = new Array();
			for(var i=0;i<13;i++) {
				if(i==12) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['법인코드','사업자번호','법인명','잔액','당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월'+tmpDate[3],
			             '4개월'+tmpDate[4],'5개월'+tmpDate[5],'6개월'+tmpDate[6],'7개월'+tmpDate[7],'8개월'+tmpDate[8],'9개월'+tmpDate[9],
			             '10개월'+tmpDate[10],'11개월'+tmpDate[11],'12개월이상'+tmpDate[12],'계'];	//출력컬럼명
			colIds = ['CLIENTID','BUSINESSNUM','CLIENTNM','TOTAL','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}else if(selMon == "30"){
			var tmpDate = new Array();
			for(var i=0;i<32;i++) {
				if(i==31) tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월~)";
				else tmpDate[i] = "("+resultDate.getFullYear()+"년 "+(resultDate.getMonth()+1)+"월)";
				resultDate.setMonth(resultDate.getMonth()-1);
			}
			colLabels = ['법인코드','사업자번호','법인명','잔액','당월분'+tmpDate[0],'1개월'+tmpDate[1],'2개월'+tmpDate[2],'3개월'+tmpDate[3],
			             '4개월'+tmpDate[4],'5개월'+tmpDate[5],'6개월'+tmpDate[6],'7개월'+tmpDate[7],'8개월'+tmpDate[8],'9개월'+tmpDate[9],
			             '10개월'+tmpDate[10],'11개월'+tmpDate[11],'12개월'+tmpDate[12],'13개월'+tmpDate[13],'14개월'+tmpDate[14],'15개월'+tmpDate[15],
			             '16개월'+tmpDate[16],'17개월'+tmpDate[17],'18개월'+tmpDate[18],'19개월'+tmpDate[19],'20개월'+tmpDate[20],'21개월'+tmpDate[21],
			             '22개월'+tmpDate[22],'23개월'+tmpDate[23],'24개월'+tmpDate[24],'25개월'+tmpDate[25],'26개월'+tmpDate[26],'27개월'+tmpDate[27],
			             '28개월'+tmpDate[28],'29개월'+tmpDate[29],'30개월'+tmpDate[30],'31개월이상'+tmpDate[31],'계'];	//출력컬럼명
			colIds = ['CLIENTID','BUSINESSNUM','CLIENTNM','TOTAL','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','M13','M14','M15',
			          'M16','M17','M18','M19','M20','M21','M22','M23','M24','M25','M26','M27','M28','M29','M30','M31','TOTAL'];	//출력컬럼ID
			numColIds = ['TOTAL','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','M10','M11','M12','M13','M14','M15','M16','M17','M18','M19',
			             'M20','M21','M22','M23','M24','M25','M26','M27','M28','M29','M30','M31','TOTAL'];	//숫자표현ID
			figureColIds = ['BUSINESSNUM'];
		}
	}
	
	var sheetTitle = "채권월령표";	//sheet 타이틀
	var excelFileName = "BondsTotalStdMonth";	//file명
	var actionUrl = "/adjust/adjustBondsTotalStdMonthExcel.sys";
	
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'stdYear';
	fieldSearchParamArray[1] = 'stdMonth';
	fieldSearchParamArray[2] = 'selMon';
	fieldSearchParamArray[3] = 'srcAccManageUserId';
	fieldSearchParamArray[4] = 'srcBusinessNum';
	fieldSearchParamArray[5] = 'srcStdMonthStandard';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명	
}
</script>
</head>

<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 2px;">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle"><%=menuTitle %></td>
					<td align="right" class="ptitle">
						<a id='excelAll' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' class='btn btn-primary btn-sm' ><i class='fa fa-search'></i>&nbsp;일괄 Excel 출력하기</a>
						<a id='srcButton' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' class='btn btn-primary btn-sm' ><i class='fa fa-search'></i>&nbsp;조회</a>
					</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">구매사명</td>
					<td class="table_td_contents" width="25%">
						<input id="srcClientNm" name="srcClientNm" type="text" value="" size="" maxlength="50" />
					</td>
					<td class="table_td_subject">사업자등록번호</td>
					<td class="table_td_contents" width="35%">
						<input id="srcBusinessNum" name="srcBusinessNum" type="text" value="" size="20" maxlength="10" />
					</td>
					<td class="table_td_subject" width="100">채권이관여부</td>
					<td class="table_td_contents" width="15%">
						<select id="srcTransferStatus" name="srcTransferStatus" class="select" style="width: 60px;">
							<option value="">전체</option>
							<option value="0">Y</option>
							<option value="1">N</option>
						</select>
					</td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="40">주문제한</td>
                     <td class="table_td_contents">
                        <select id="srcIsLimit" name="srcIsLimit" class="select" >
                        	<option value="">전체</option>
                        	<option value="0">주문정상</option>
                        	<option value="1" <%=isLimit.equals("1")? "selected":"" %>>주문제한</option>
                        </select>
                     </td>
                     <td class="table_td_subject" width="55">검색기간</td>
                     <td class="table_td_contents">
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
					<td class="table_td_subject" width="100">선입금여부</td>
					<td class="table_td_contents">
						<select id="srcPrePay" name="srcPrePay" class="select" style="width: 60px;">
							<option value="">전체</option>
							<option value="1">Y</option>
							<option value="0">N</option>
						</select>
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
			<td width="1500px" height="20px" valign="bottom" align="left">
				<span id="userDataText"></span>
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
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>

      <!-------------------------------- Dialog Div Start -------------------------------->
      <!-------------------------------- Dialog Div End -------------------------------->
   </form>
</body>
</html>