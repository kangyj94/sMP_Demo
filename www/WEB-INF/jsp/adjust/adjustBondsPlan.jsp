<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   	//그리드의 width와 Height을 정의
   	String listHeight = "$(window).height()-455 + Number(gridHeightResizePlus)";
//    	String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
   	String listWidth = "1500";

   	@SuppressWarnings("unchecked")
   	//화면권한가져오기(필수)
   	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	List<CodesDto> contractSpecialList = (List<CodesDto>)request.getAttribute("contractSpecialList");
	
	// 날짜 세팅
	
	int EndYear   = 2009;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
		srcYearArr[i] = (StartYear - i) + "";
	}   	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:2px;
    padding-left:2px;
    padding-top:4px;
    padding-bottom:4px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}
.ui-jqgrid tr.jqgrow td {
	font-weight: normal; 
	overflow: hidden; 
	white-space: nowrap; 
	height:50px; 
	padding: 0 2px 0 2px;
	border-bottom-width: 1px; 
	border-bottom-color: inherit; 
	border-bottom-style: solid;
}
</style>

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$("#srcButton").click(function(){fnSearch();});
	$("#saveButton").click(function(){fnPlanSave();});
	
	$("#srcClientNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#excelAll").click(function(){
		var colLabels = ['사업자번호','사업장명','고객유형','계산서일자','채권금액','채권만기일','회수금액','회수일','평균회수일','채권유형','미회수금액','계획금액 소계','계획금액1','계획일1','계획금액2','계획일2']
		var colIds =['BUSINESSNUM','BRANCHNM','CONTRACT_SPECIAL_NM','CLOS_SALE_DATE','SALE_TOTA_AMOU','EXPIRATION_DATE','PAY_AMOU','PAY_AMOU_DATE','AVG_REV_AMOU_DATE','BONDS_TYPE','REMAIN_AMOU','SUM_AMOU','BOND_PLAN_AMOU1','BOND_PLAN_DATE1','BOND_PLAN_AMOU2','BOND_PLAN_DATE2'];
		var numColIds = ['SALE_TOTA_AMOU','PAY_AMOU','REMAIN_AMOU','SUM_AMOU','BOND_PLAN_AMOU1','BOND_PLAN_AMOU2'];
		var sheetTitle = "채권회수계획";
		var excelFileName = "AdjustBondsPlan";
		var fieldSearchParamArray = new Array();
		fieldSearchParamArray[0] = 'srcYear';
		fieldSearchParamArray[1] = 'srcMonth';
		fieldSearchParamArray[2] = 'srcBranchNm';
		fieldSearchParamArray[3] = 'srcBondType';
		fieldSearchParamArray[4] = 'srcContractSpecial';
		fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,"/adjust/adjustBondsPlanListJQGridExcel.sys");
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBondsPlanListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['<input type="checkbox" id="checkAll" name="checkAll" onclick="javascript:fnCheckall(event);" class="chkbox"/>','사업자번호','사업장명','고객유형','계산서일자','채권금액','채권만기일','회수금액<br>(회수일)','평균<br/>회수일','채권<br/>유형','PAY_AMOU_TMP','미회수금액','소계','계획금액1<br>계획일1','계획금액2<br>계획일2', '계획금액1_Temp','계획일1_Temp','계획금액2_Temp','계획일2_Temp', 'SALE_SEQU_NUMB'],
		colModel:[
			{name:'WITHDRAW_YN',index:'WITHDRAW_YN',width:30,align:"center",search:false,sortable:false, editable:false,formatter:fnCheckbox},//계획금액1 계획일1
			{name:'BUSINESSNUM', index:'BUSINESSNUM',width:80,align:"center",search:false,sortable:false, editable:false},//사업자번호
			{name:'BRANCHNM', index:'BRANCHNM',width:200,align:"left",search:false,sortable:false, editable:false },//사업장명
			{name:'CONTRACT_SPECIAL_NM', index:'CONTRACT_SPECIAL_NM',width:100,align:"left",search:false,sortable:false, editable:false },//고객유형
			{name:'CLOS_SALE_DATE', index:'CLOS_SALE_DATE',width:80,align:"center",search:false,sortable:false, editable:false },//계산서일자
			{name:'SALE_TOTA_AMOU', index:'SALE_TOTA_AMOU',width:100,align:"right",search:false,sortable:false, editable:false, 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//채권금액	
			{name:'EXPIRATION_DATE',index:'EXPIRATION_DATE',width:80,align:"center",search:false,sortable:false, editable:false },//채권만기일
			{name:'PAY_AMOU',index:'PAY_AMOU',width:100,align:"right",search:false,sortable:false, editable:false },//회수금액 (회수일)
			{name:'AVG_REV_AMOU_DATE',index:'AVG_REV_AMOU_DATE',width:60,align:"right",search:false,sortable:false, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//평균회수일
			{name:'BONDS_TYPE',index:'BONDS_TYPE',width:50,align:"center",search:false,sortable:false, editable:false },//채권유형
			{name:'PAY_AMOU_TMP',index:'PAY_AMOU_TMP',width:70,align:"right",search:false,sortable:false, editable:false, hidden:true },//PAY_AMOU_TMP
			{name:'REMAIN_AMOU',index:'REMAIN_AMOU',width:100,align:"right",search:false,sortable:false, editable:false, hidden:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//미회수금액
			{name:'SUM_AMOU',index:'SUM_AMOU',width:100,align:"right",search:false,sortable:false, editable:false ,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//소계
			{name:'PLANINFO1',index:'PLANINFO1',width:120,align:"center",search:false,sortable:false, editable:false,formatter:fnBondPlanEditor1},//계획금액1 계획일1
			{name:'PLANINFO2',index:'PLANINFO2',width:120,align:"center",search:false,sortable:false, editable:false,formatter:fnBondPlanEditor2},//계획금액2 계획일2
			{name:'BOND_PLAN_AMOU1',index:'BOND_PLAN_AMOU1',width:60,align:"center",search:false,sortable:false, editable:false, hidden:true },
			{name:'BOND_PLAN_DATE1',index:'BOND_PLAN_DATE1',width:60,align:"center",search:false,sortable:false, editable:false, hidden:true },
			{name:'BOND_PLAN_AMOU2',index:'BOND_PLAN_AMOU2',width:60,align:"center",search:false,sortable:false, editable:false, hidden:true },
			{name:'BOND_PLAN_DATE2',index:'BOND_PLAN_DATE2',width:60,align:"center",search:false,sortable:false, editable:false, hidden:true },
			{name:'SALE_SEQU_NUMB',index:'SALE_SEQU_NUMB',width:60,align:"center",search:false,sortable:false, editable:false, hidden:true }
		],
		postData: {
			srcDate    		   : $("#srcYear").val() + $("#srcMonth").val(), 
			srcBranchNm 	   : $("#srcBranchNm").val(),
			srcBondType 	   : $("#srcBondType").val(),                   
			srcContractSpecial : $("#srcContractSpecial").val()
		},
// 		rowNum:0, rownumbers:false, 
		rowNum:15, rownumbers: true, rowList:[15,30,50,100,500], pager: '#pager',
		height: <%=listHeight%>,width: <%=listWidth %>,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $("#list").getGridParam('reccount');
			for(var i=0;i<rowCnt;i++) {
				var rowid = $("#list").getDataIDs()[i];
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				fnDatepicker("planDate1_"+rowid);
				fnDatepicker("planDate2_"+rowid);
				
				if(selrowContent.BOND_PLAN_AMOU1 != ''){
					$("#planAmou1_" + rowid).val(fnInputComma(selrowContent.BOND_PLAN_AMOU1));
					$("#planDate1_" + rowid).val(selrowContent.BOND_PLAN_DATE1);
				}
				
				if(selrowContent.BOND_PLAN_AMOU2 != ''){
					$("#planAmou2_" + rowid).val(fnInputComma(selrowContent.BOND_PLAN_AMOU2));
					$("#planDate2_" + rowid).val(selrowContent.BOND_PLAN_DATE2);
				}
			}
			var userData = $("#list").jqGrid("getGridParam","userData");
			var tmpValue = "";
			tmpValue += "[총 채권 합 : <font color='red'>"+fnInputComma(userData.SUM_SALE_TOTA_AMOU)+"</font> ";
			tmpValue += "미회수채권 합 : <font color='red'>"+fnInputComma(userData.SUM_REMAIN_AMOU)+"</font>]&nbsp;&nbsp;&nbsp;&nbsp;";
			tmpValue += "[계획(M+0)금액 합 : <font color='red'>"+fnInputComma(userData.SUM_PLAN_AMOU_1MONTH)+"</font> ";
			tmpValue += "계획(M+1)금액 합 : <font color='red'>"+fnInputComma(userData.SUM_PLAN_AMOU_2MONTH)+"</font> ";
			tmpValue += "계획(M+2)금액 합 : <font color='red'>"+fnInputComma(userData.SUM_PLAN_AMOU_3MONTH)+"</font>]";
			$("#displayPlanSum").html(tmpValue);
			$("#list").jqGrid("footerData","set",userData,false);
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell",userdata:"userData"}
	});
	
	jq("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
			groupHeaders:[
				{startColumnName: 'SUM_AMOU', numberOfColumns: 3, titleText: '채권 회수 계획'}
			]
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch(){
	jq("#list").jqGrid("setGridParam", {"page":1});
   	var data = jq("#list").jqGrid("getGridParam", "postData");
   	data.srcDate    		= $("#srcYear").val() + $("#srcMonth").val();
   	data.srcBranchNm 		= $("#srcBranchNm").val();
   	data.srcBondType 		= $("#srcBondType").val();
   	data.srcContractSpecial = $("#srcContractSpecial").val();
   	jq("#list").trigger("reloadGrid");  	
}

function fnPlanSave(){
	var rowCnt = jq("#list").getGridParam('reccount');
	var saleSequArr  = new Array();
	var planAmou1Arr = new Array();
	var planDate1Arr = new Array();
	var planAmou2Arr = new Array();
	var planDate2Arr = new Array();
	var chkCnt = 0;
	if(rowCnt>0) {
		try{
			for(var i = 0 ; i < rowCnt ; i++){
				var rowid = $("#list").getDataIDs()[i];
				if($("#chkbox_" + rowid).prop("checked")){
					
					var planAmou1 = fnInputUncomma($.trim($("#planAmou1_" + rowid).val()));
					var planDate1 = $.trim($("#planDate1_" + rowid).val());
					var planAmou2 = fnInputUncomma($.trim($("#planAmou2_" + rowid).val()));
					var planDate2 = $.trim($("#planDate2_" + rowid).val());
					
					if(planAmou1 != ''){
						if(planDate1 == ''){
							alert(rowid + " 행의 계획일1 을 입력해 주세요.");
							return;
						}
					}
					
					if(planAmou2 != ''){
						
						if(planAmou1 == ''){
							alert(rowid + " 행의 계획금액1 을 입력해 주세요.");
							return;
						}
						
						if(planDate1 == ''){
							alert(rowid + " 행의 계획일1 을 입력해 주세요.");
							return;
						}
						
						if(planDate2 == ''){
							alert(rowid + " 행의 계획일2 을 입력해 주세요.");
							return;
						}
					}
					saleSequArr[chkCnt]  = $("#list").jqGrid('getRowData',rowid).SALE_SEQU_NUMB;
					planAmou1Arr[chkCnt] = planAmou1;
					planDate1Arr[chkCnt] = planDate1;
					planAmou2Arr[chkCnt] = planAmou2;
					planDate2Arr[chkCnt] = planDate2;
					chkCnt++;
				}
			}			
		}catch(e){}
	}
	
	if(chkCnt == 0){
		alert("저장할 데이터를 선택해 주세요.");
		return;
	}
	
	if(!confirm("선택한 데이터를 저장하시겠습니까?"))return;
	
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/saveBondsPlan.sys',
		{
			saleSequArr:saleSequArr,
			planAmou1Arr:planAmou1Arr,
			planDate1Arr:planDate1Arr,
			planAmou2Arr:planAmou2Arr,
			planDate2Arr:planDate2Arr
		},
		function(arg){
			if(fnAjaxTransResult(arg)) {
				fnSearch();
			}
		}
	);	
}

function fnBondPlanEditor1(cellValue, options, rowObject){
	var rtnStr = "";
	rtnStr = "<p><input type='text' id='planAmou1_"+options.rowId+"' name='planAmou1_"+options.rowId+"' style='width: 100px;vertical-align: middle;text-align:right;' onkeyup='javascript:fnSetField(1,"+options.rowId+");' onchange='javascript:fnSetField(1,"+options.rowId+");' /></p>";
	rtnStr += "<span style='line-height:7%'><br></span>";
	rtnStr += "<p><input type='text' id='planDate1_"+options.rowId+"' name='planDate1_"+options.rowId+"' value='' readonly style='width: 75px;vertical-align: middle;text-align:center;' onchange='javascript:fnSetField(1,"+options.rowId+");'/></p>";
	return rtnStr;
}

function fnBondPlanEditor2(cellValue, options, rowObject){
	var rtnStr = "";
	rtnStr = "<p><input type='text' id='planAmou2_"+options.rowId+"' name='planAmou2_"+options.rowId+"' style='width: 100px;vertical-align: middle;text-align:right;' onkeyup='javascript:fnSetField(2,"+options.rowId+");' onchange='javascript:fnSetField(2,"+options.rowId+");' /></p>";
	rtnStr += "<span style='line-height:7%'><br></span>";
	rtnStr += "<p><input type='text' id='planDate2_"+options.rowId+"' name='planDate2_"+options.rowId+"' value='' readonly style='width: 75px;vertical-align: middle;text-align:center;' onchange='javascript:fnSetField(2,"+options.rowId+");' /></p>";
	return rtnStr;
}

function fnCheckbox(cellValue, options, rowObject){
	var rtnStr = "";
	
	if(cellValue == 'N'){
		rtnStr = "<input type='checkbox' id='chkbox_"+options.rowId+"' name='chkbox_"+options.rowId+"' class='chkbox' onclick='javascript:fnSetPlans("+options.rowId+")' />";
	}
	
	return rtnStr;
}

function fnDatepicker(id){
	$("#" + id).datepicker(
    {
    	showOn: "button",
        buttonImage: "/img/system/btn_icon_calendar.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
//         ,minDate:0
	});
	
  	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}


function fnCheckall(e) {
	e = e||event;
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
	if($("#checkAll").is(':checked')) {
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0) {
			$(".chkbox").prop("checked", true);
			
			for(var i = 0 ; i < rowCnt ; i++){
				var rowid = $("#list").getDataIDs()[i];
				fnSetPlans(rowid);
			}
		}
	}else{
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0) {
			$(".chkbox").prop("checked", false);
		}
	}
}

function fnSetField(kind, id){
	if($.trim($("#palnAmou" + kind + "_" + id).val()) != '' || $.trim($("#palnDate" + kind + "_" + id).val()) != ''){
		$("#chkbox_" + id).prop("checked", true);
	}
	
	var planAmou1 = $.trim($("#planAmou1_" + id).val()) == '' ? 0 : Number(fnInputUncomma($.trim($("#planAmou1_" + id).val()))) ;
	var planAmou2 = $.trim($("#planAmou2_" + id).val()) == '' ? 0 : Number(fnInputUncomma($.trim($("#planAmou2_" + id).val()))) ;
	var sumAmou = planAmou1 + planAmou2;
	var totaAmou = Number($("#list").jqGrid('getRowData',id).REMAIN_AMOU);
	
	if(kind==1) {
		var planAmou2_tmp = totaAmou - planAmou1;
		if(planAmou2==0 && planAmou1>=totaAmou) {
			$("#planAmou1_" + id).val(fnInputComma(totaAmou));
		} else if(planAmou2!=0 && (planAmou1+planAmou2)>=totaAmou) {
			if(planAmou1>=totaAmou) {
				$("#planAmou1_" + id).val(fnInputComma(totaAmou));
				$("#planAmou2_" + id).val('');
			} else {
				$("#planAmou1_" + id).val(fnInputComma(planAmou1));
				$("#planAmou2_" + id).val(fnInputComma(planAmou2_tmp));
			}
		} else {
			$("#planAmou1_" + id).val(fnInputComma(planAmou1));
		}
	} else if(kind==2) {
		var planAmou1_tmp = totaAmou - planAmou2;
		if(planAmou1==0 && planAmou2>=totaAmou) {
			$("#planAmou2_" + id).val(fnInputComma(totaAmou));
		} else if(planAmou1!=0 && (planAmou1+planAmou2)>=totaAmou) {
			if(planAmou2>=totaAmou) {
				$("#planAmou2_" + id).val(fnInputComma(totaAmou));
				$("#planAmou1_" + id).val('');
			} else {
				$("#planAmou2_" + id).val(fnInputComma(planAmou2));
				$("#planAmou1_" + id).val(fnInputComma(planAmou1_tmp));
			}
		} else {
			$("#planAmou2_" + id).val(fnInputComma(planAmou2));
		}
	}
	var tmpAmou1 = $.trim($("#planAmou1_" + id).val()) == '' ? 0 : Number(fnInputUncomma($.trim($("#planAmou1_" + id).val())));
	var tmpAmou2 = $.trim($("#planAmou2_" + id).val()) == '' ? 0 : Number(fnInputUncomma($.trim($("#planAmou2_" + id).val())));
	var tmpSum = tmpAmou1 + tmpAmou2;
	$("#list").jqGrid('setRowData', id, {SUM_AMOU:tmpSum});
}

function fnSetPlans(id){
	if($("#chkbox_" + id).prop("checked")){
		var selrowContent = jq("#list").jqGrid('getRowData',id);
		
		var clos_sale_date = selrowContent.CLOS_SALE_DATE;
		var closDate = new Date(clos_sale_date.split("-")[1] + "/" + clos_sale_date.split("-")[2] + "/" + clos_sale_date.split("-")[0]);
		var today	 = new Date();
		
		closDate.setDate(closDate.getDate()+Number(selrowContent.AVG_REV_AMOU_DATE));
		
// 		if(today <= closDate){
		if($.trim($("#planDate1_" + id).val()) == ''){
			var setYear  = closDate.getFullYear();
			var setMonth = (closDate.getMonth() + 1) < 10 ? "0"+(closDate.getMonth()+1) : (closDate.getMonth()+1);
			var setDate  = closDate.getDate() < 10 ? "0"+closDate.getDate() : closDate.getDate();
			$("#planDate1_" + id).val(setYear + "-" + setMonth + "-" + setDate);
		}
// 		}
		if(today > closDate){
			$("#"+id).css("background", "#e0ffff");
		}
		
		if($.trim($("#planAmou1_" + id).val()) == ''){
			var tmpValue = fnInputComma($("#list").jqGrid('getRowData',id).REMAIN_AMOU);
			$("#planAmou1_" + id).val(tmpValue);
			$("#list").jqGrid('setRowData', id, {SUM_AMOU:fnInputUncomma($("#planAmou1_" + id).val())});
		}
	}
}

//콤마찍기
function fnInputComma(str) {
str = String(str);
return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
//콤마풀기
function fnInputUncomma(str) {
str = String(str);
return str.replace(/[^\d]+/g, '');
}
function fnInputCommaFormat(obj) {
obj.value = fnInputComma(fnInputUncomma(obj.value));
}
</script>
</head>

<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<body>
<!-- <form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data"> -->
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0" style="margin-top: 2px;">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">채권회수계획</td>
					<td align="right" class="ptitle">
						<button id='excelAll' class="btn btn-success btn-xs"><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcButton' class="btn btn-primary btn-xs"><i class="fa fa-search"></i> 조회</button>
<%-- 						<a id='srcButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>						 --%>
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
					<td colspan="8" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="8" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">계획년월</td>
					<td class="table_td_contents">
					
						<select id="srcYear" name="srcYear" class="select" style="width: 100px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
							<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
						</select> 년
                        <select id="srcMonth" name="srcMonth" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < 12 ; i++){
	   String monthVal = new Integer(i + 1).toString().length() == 1 ? "0" + new Integer(i + 1) : new Integer(i + 1).toString();
%>
							<option value='<%=monthVal%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=monthVal %></option>
<%      
   }
%>                        
						</select> 월							

					</td>
					<td class="table_td_subject" width="100">고객유형</td>
					<td class="table_td_contents">
						<select id="srcContractSpecial" class="select" style="width: 150px;">
							<option value="">전체</option>
<%	for(CodesDto codesDto : contractSpecialList) { %>
							<option value="<%=codesDto.getCodeVal1() %>"><%=codesDto.getCodeNm1() %></option>
<%	}	%>						
						</select>
					</td>
                  </tr>
                  <tr>
                     <td colspan="8" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">구매사</td>
                     <td class="table_td_contents">
                        <input id="srcBranchNm" name="srcBranchNm" style="width: 300px;height: 23px;"/>
                     </td>
                     <td class="table_td_subject" width="100">채권유형</td>
                     <td class="table_td_contents" >
						<select id="srcBondType" class="select" style="width: 70px;">
							<option value="">전체</option>
							<option value="0">정상</option>
							<option value="1">관리</option>
							<option value="2">장기</option>
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
			<td width="1500px" height="40px" valign="bottom">
				<table border="0" width="100%">
					<tr>
						<td align="right" valign="bottom"><span id="displayPlanSum"></span></td>
	            		<td align="right" width="100px;" valign="middle">
	            			<a id='saveButton' class="btn btn-warning btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 저장</button>
	            		</td>
	            	</tr>
	            	<tr>
	            		<td colspan="2" height="3px" ></td>
	            	</tr>
	            </table>
            </td>
         </tr>
         <tr>
            <td>
               <div id="jqgrid"  style="margin-top:8px;">
                  <table id="list"></table>
                  <div id="pager"></div>
               </div>
            </td>
         </tr>
<!--          <tr> -->
<!--             <td height="10">&nbsp;</td> -->
<!--          </tr> -->
      </table>
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>

      <!-------------------------------- Dialog Div Start -------------------------------->
      <!-------------------------------- Dialog Div End -------------------------------->
<!--    </form> -->
</body>
</html>