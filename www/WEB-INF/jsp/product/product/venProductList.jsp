<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-250 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");				// 화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);	// 사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String srcRegistStartDate = "2009-01-01"; // 공급사 상품 시작 날짜 세팅													// 날짜 세팅
	String srcRegistEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	// 코드 데이터 조회 
	fnDataInit();
	// 이벤트 등록
	/*--------------------검색에 대한 처리--------------------*/
	$("#excelButton").click(function() {exportExcel();});
	$("#srcButton").click(function() {
		$("#srcGoodIdenNumb").val($.trim($("#srcGoodIdenNumb").val()));
		$("#srcGoodName").val($.trim($("#srcGoodName").val()));
		$("#srcRegistStartDate").val($.trim($("#srcRegistStartDate").val()));
		$("#srcRegistEndDate").val($.trim($("#srcRegistEndDate").val()));
		$("#srcGoodSpecDesc").val($.trim($("#srcGoodSpecDesc").val()));
		$("#srcGoodSameWord").val($.trim($("#srcGoodSameWord").val()));
		$("#srcGoodClasCode").val($.trim($("#srcGoodClasCode").val()));
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
	});
	$("#srcButton").click( function() { fnSearch(); });
	$("#srcGoodIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcGoodName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcRegistStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcRegistEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcGoodSpecDesc").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcGoodSameWord").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcGoodClasCode").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	
	$('#btnOpenPep').click(	function() {	fnVendorProductDetailView( '' , '164' , '304450');	});
	
	
	// DataPicker 등록
	$("#srcRegistStartDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcRegistEndDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;");
	
	//상품구분에 이미지 깜빡임 표시
    setInterval(function(){ $(".blink").fadeOut('slow').fadeIn('slow'); }, 2000);
});

//리싸이즈 설정
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');

//코드 데이터 초기화
function fnDataInit() {
	$.post( //조회조건의 상품구분 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"ORDERGOODSTYPE", isUse:"1"},
		function(arg) {
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcGoodClasCode").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			initComponent();
		}
	);
}

// 컨퍼넌트 초기화
function initComponent() {
	$("#srcRegistStartDate").val("<%=srcRegistStartDate%>");
	$("#srcRegistEndDate").val("<%=srcRegistEndDate%>");
	
	// 그리드 조회
	fnInitJqGridComponent();
}
</script>

<!-- 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcGoodIdenNumb = $('#srcGoodIdenNumb').val();
	data.srcGoodName = $('#srcGoodName').val();
	data.srcRegistStartDate = $('#srcRegistStartDate').val();
	data.srcRegistEndDate = $('#srcRegistEndDate').val();
	data.srcGoodSpecDesc = $('#srcGoodSpecDesc').val();
	data.srcGoodSameWord = $('#srcGoodSameWord').val();
	data.srcGoodClasCode = $('#srcGoodClasCode').val();
	data.srcVendorId = $('#srcVendorId').val();
	data.srcIsUse = $('#srcIsUse').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['상품코드','상품구분','정상여부',		'상품명',	'Ø',				'W',				'D',				'H',				'L',				't',				'규격',				'제질',			'크기',			'총중량(할증포함)',	'색상',			'TYPE',			'실중량kg',		'M(미터)',			'매입단가','단위','재고량','납품소요일수','최소구매수량','카테고리','삼품담당자','제조사','동의어','등록일'];	//출력컬럼명
	var colIds = ['good_Iden_Numb','good_Clas_Code','isUse','good_Name','goodStSpecDesc1',	'goodStSpecDesc2',	'goodStSpecDesc3',	'goodStSpecDesc4',	'goodStSpecDesc5',	'goodStSpecDesc6',	'goodSpecDesc1',	'goodSpecDesc2','goodSpecDesc3','goodSpecDesc4',	'goodSpecDesc5','goodSpecDesc6','goodSpecDesc7','goodSpecDesc8',	'sale_Unit_Pric','orde_Clas_Code','good_Inventory_Cnt','deli_Mini_Day','deli_Mini_Quan','full_Cate_Name','product_manager','make_Comp_Name','good_Same_Word',  'regist_Date'];	//출력컬럼ID
	var numColIds = ['sale_Unit_Pric','deli_Mini_Quan'];	//숫자표현ID
	var sheetTitle = "상품조회";	//sheet 타이틀
	var excelFileName = "venProductList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}


// function detail(){
// 	var popurl = "/product/venProductDetail.sys";
// 	var popproperty = "dialogWidth:900px;dialogHeight=700px;scroll=yes;status=no;resizable=no;";
// 	window.showModalDialog(popurl,null,popproperty);
// }
</script>

<!-------------------------------- Dialog Div Start -------------------------------->
<!-------------------------------- Dialog Div End -------------------------------->

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function fnInitJqGridComponent() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/venProductListJQGrid2.sys',
		datatype:'json',
		mtype:'POST',
		colNames:[
					'상품코드','상품구분','정상여부','상품명','표준규격','상품규격','이미지','매입단가','단위','재고량','납품소요일수','최소구매수량',
					'카테고리','상품담당자','제조사','동의어','하도급법대상여부','등록일','공급사Id','이미지','ORIGINAL_IMG_PATH',
					'goodStSpecDesc1','goodStSpecDesc2','goodStSpecDesc3','goodStSpecDesc4','goodStSpecDesc5','goodStSpecDesc6',
					'goodSpecDesc1','goodSpecDesc2','goodSpecDesc3','goodSpecDesc4','goodSpecDesc5','goodSpecDesc6','goodSpecDesc7','goodSpecDesc8'
					],
		colModel:[
			{ name:'good_Iden_Numb',index:'good_Iden_Numb',width:80,align:"center",search:false,sortable:true,editable:false,classes:'pointer',key:true },//상품코드
			{ name:'good_Clas_Code',index:'good_Clas_Code',width:60,align:"center",search:false,sortable:true,editable:false},//상품구분
			{ name:'isUse',index:'isUse',width:60,align:"center",search:false,sortable:true,editable:false},//정상여부
			{ name:'good_Name', index:'good_Name',width:160,align:"left",search:false,sortable:true,editable:false },//상품명
			{ name:'good_St_Spec_Desc',index:'good_St_Spec_Desc',width:350,align:"left",search:false,sortable:false,editable:false,hidden:true },//표준규격
			{ name:'good_Spec_Desc',index:'good_Spec_Desc',width:350,align:"left",search:false,sortable:false,editable:false },//규격
			{ name:'good_img', index:'good_img',width:37,align:"center",search:false,sortable:false,editable:false },//이미지
			{ name:'sale_Unit_Pric',index:'sale_Unit_Pric',width:60,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" }
			},//매입단가
			{ name:'orde_Clas_Code',index:'orde_Clas_Code',width:60,align:"center",search:false,sortable:false,editable:false },//단위
			{ name:'good_Inventory_Cnt',index:'good_Inventory_Cnt',width:50,align:"center",search:false,sortable:false,editable:false },//재고량
			{ name:'deli_Mini_Day',index:'deli_Mini_Day',width:60,align:"center",search:false,sortable:false,editable:false },//납품소요일수
			{ name:'deli_Mini_Quan',index:'deli_Mini_Quan',width:80,align:"center",search:false,sortable:false,editable:false },//최소구매수량
			{ name:'full_Cate_Name', index:'full_Cate_Name',width:250,align:"left",search:false,sortable:false,editable:false },//카테고리
			{ name:'product_manager',index:'product_manager',width:150,align:"center",search:false,sortable:false,editable:false },//상품담당자
			{ name:'make_Comp_Name',index:'make_Comp_Name',width:100,align:"left",search:false,sortable:false,editable:false },//제조사
			{ name:'good_Same_Word',index:'good_Same_Word',width:100,align:"left",search:false,sortable:false,editable:false },//동의어
			{ name:'issub_Ontract',index:'issub_Ontract',width:100,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"1:Y;0:N"},hidden:true
			},//하도급법대상여부
			
			{ name:'regist_Date',index:'regist_Date',width:70,align:"center",search:false,sortable:false
				,editable:false,formatter:"date"
			},//등록일
			
			{ name:'vendorId',index:'vendorId',hidden:true,search:false },//공급사Id
			{ name:'small_Img_Path',index:'small_Img_Path',hidden:true,search:false },//공급사Id
			{ name:'original_Img_Path',index:'original_Img_Path',hidden:true,search:false },
			{name:'goodStSpecDesc1',index:'goodStSpecDesc1',hidden:true,search:false },//표준규격1
			{name:'goodStSpecDesc2',index:'goodStSpecDesc2',hidden:true,search:false },//표준규격2
			{name:'goodStSpecDesc3',index:'goodStSpecDesc3',hidden:true,search:false },//표준규격3
			{name:'goodStSpecDesc4',index:'goodStSpecDesc4',hidden:true,search:false },//표준규격4
			{name:'goodStSpecDesc5',index:'goodStSpecDesc5',hidden:true,search:false },//표준규격5
			{name:'goodStSpecDesc6',index:'goodStSpecDesc6',hidden:true,search:false },//표준규격6
			{name:'goodSpecDesc1',index:'goodSpecDesc1',hidden:true,search:false },//규격1
			{name:'goodSpecDesc2',index:'goodSpecDesc2',hidden:true,search:false },//규격2
			{name:'goodSpecDesc3',index:'goodSpecDesc3',hidden:true,search:false },//규격3
			{name:'goodSpecDesc4',index:'goodSpecDesc4',hidden:true,search:false },//규격4
			{name:'goodSpecDesc5',index:'goodSpecDesc5',hidden:true,search:false },//규격5
			{name:'goodSpecDesc6',index:'goodSpecDesc6',hidden:true,search:false },//규격6
			{name:'goodSpecDesc7',index:'goodSpecDesc7',hidden:true,search:false },//규격7
			{name:'goodSpecDesc8',index:'goodSpecDesc8',hidden:true,search:false }//규격8
		],
		postData: {
			srcGoodIdenNumb:$('#srcGoodIdenNumb').val(),
			srcGoodName:$('#srcGoodName').val(),
			srcRegistStartDate:$('#srcRegistStartDate').val(),
			srcRegistEndDate:$('#srcRegistEndDate').val(),
			srcGoodSpecDesc:$('#srcGoodSpecDesc').val(),
			srcGoodSameWord:$('#srcGoodSameWord').val(),
			srcGoodClasCode:$('#srcGoodClasCode').val(),
			srcVendorId:$('#srcVendorId').val(),
			srcIsUse:$('#srcIsUse').val()
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname:'good_Name',sortorder:'asc',
		caption:"상품정보조회",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			
			// 품목 표준 규격 설정
			var prodStSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
				prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
			<% }                                                                          %>             
			
			// 품목 규격 설정
			var prodSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
			<% }                                                                       %>
			
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				
				// 규격 화면 로드
				var argStArray = selrowContent.good_St_Spec_Desc.split("‡");
				var argArray = selrowContent.good_Spec_Desc.split("‡");
				
				var prodStSpec = ""; 
				var prodSpec = "";
				
				for(var stIdx = 0 ; stIdx < prodSpcNm.length ; stIdx ++ ) {
					if(argStArray[stIdx] > ' ') {
						prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
					}
				}
				
				if(prodStSpec.length > 0) {
					prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
					prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
				}
				
				for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
					if(argArray[jIdx] > ' ') {
						if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
                        else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
					}
				}
				prodStSpec += prodSpec;
				
				jQuery('#list').jqGrid('setRowData',rowid,{good_Spec_Desc:prodStSpec});
				
				// 동의어 화면 로드
				var argArray2 = selrowContent.good_Same_Word.split("‡");
				var prodSpec2 = "";
				for(var jIdx = 0 ; jIdx < argArray2.length ; jIdx ++ ) {
					if($.trim(argArray2[jIdx]) != '') {
						if(prodSpec2 == '' ) prodSpec2 += argArray2[jIdx];
						else	prodSpec2 += ' , ' + argArray2[jIdx];
					}
				}
				jQuery('#list').jqGrid('setRowData',rowid,{good_Same_Word:prodSpec2});
				
				// img 화면 로드 
				var imgTag = "";
				if($.trim(selrowContent.small_Img_Path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_Img_Path+"' style='width:30px;height:30px;' />";	
				else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:30px;height:30px;' />";
				jQuery('#list').jqGrid('setRowData',rowid,{good_img:imgTag});
				if("10" == selrowContent.good_Clas_Code){
					$("#list").jqGrid('setRowData',rowid,{good_Clas_Code:"일반"});
				}else if("20" == selrowContent.good_Clas_Code){
					var goodName = "<img class='blink' src='/img/system/btn_appointment.jpg'>&nbsp;"+selrowContent.good_Name;
					$("#list").jqGrid('setRowData',rowid,{good_Clas_Code:"지정"});
					$("#list").jqGrid('setRowData',rowid,{good_Name:goodName});
				}else if("30" == selrowContent.good_Clas_Code){
					$("#list").jqGrid('setRowData',rowid,{good_Clas_Code:"수탁"});
				}else if("40" == selrowContent.good_Clas_Code){
					$("#list").jqGrid('setRowData',rowid,{good_Clas_Code:"사급형 지입"});
				}else if("50" == selrowContent.good_Clas_Code){
					$("#list").jqGrid('setRowData',rowid,{good_Clas_Code:"사급"});
				}
				if("1" == selrowContent.isUse){
					$("#list").jqGrid('setRowData',rowid,{isUse:"정상"});
				}else if("0" == selrowContent.isUse){
					$("#list").jqGrid('setRowData',rowid,{isUse:"종료"});
				}
				
			}
			
			fnCheackErrImg();
		},
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			var cm = $("#list").jqGrid('getGridParam','colModel');
			if(cm[iCol]!=undefined && cm[iCol].index == 'good_Iden_Numb') {
				detail(rowid);
			}
	        if(cm[iCol]!=undefined && (cm[iCol].index == 'good_img')){
	        	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	        	var orgImgPath = selrowContent.original_Img_Path;
	        	if($.trim(orgImgPath).length > 0){
	        		window.open("<%=Constances.SYSTEM_IMAGE_PATH%>/" + orgImgPath, '','scrollbars=yes, status=no, resizable=yes');
	        	}
			}
		},
		afterInsertRow:function(rowid, aData) {
			jq("#list").setCell(rowid,'good_Iden_Numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_Iden_Numb','',{cursor:'pointer'});  
		},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
};
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
//그리드 커서
function pointercursor(cellvalue, options, rowObject) {
	var new_formatted_cellvalue = '<span class="pointer">' + cellvalue + '</span>';
	return new_formatted_cellvalue;
}

//이미지 Error 체크
function fnCheackErrImg() {
	$('img').error(function() {
		$(this).attr('src', '<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif');
	});
}

function detail(rowid) {
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	var good_Iden_Numb = selrowContent.good_Iden_Numb;
	var vendorid = $('#srcVendorId').val();
	fnVendorProductDetailView('<%=menuId%>',good_Iden_Numb,vendorid);
}

function fnReLoadDataGrid(){
    jq("#list").trigger("reloadGrid");
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//상품조회/변경
	header = "상품조회/변경";
	manualPath = "/img/manual/vendor/venProductList.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>

<body>
<form id="frm" name="frm" method="post">
<input id="srcVendorName" name="srcVendorName" type="hidden" value="<%=userInfoDto.getBorgNm()%>" />
<input id="srcVendorId" name="srcVendorId" type="hidden" value="<%=userInfoDto.getBorgId()%>" />
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">상품조회/변경
					&nbsp;<span id="question" class="questionButton">도움말</span>
				</td>
				<td align="right" class="ptitle">
					<a href="#"><img id="srcButton"
									src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif"
									style="width:65px;height:22px;border:9px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" /></a></td>
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
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">상품코드</td>
				<td class="table_td_contents">
					<input id="srcGoodIdenNumb" name="srcGoodIdenNumb" type="text" value="" size="" maxlength="20" style="width:90%;" /></td>
				<td class="table_td_subject" width="100">상품명</td>
				<td class="table_td_contents">
					<input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" style="width:90%;" /></td>
				<td class="table_td_subject" width="100">등록일</td>
				<td class="table_td_contents" colspan="3">
					<input id="srcRegistStartDate" name="srcRegistStartDate" type="text" style="width:75px;" /> ~
					<input id="srcRegistEndDate" name="srcRegistEndDate" type="text" style="width:75px;" />
				</td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품규격</td>
				<td class="table_td_contents">
					<input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" style="width:90%;" /></td>
				<td class="table_td_subject">상품동의어</td>
				<td class="table_td_contents">
					<input id="srcGoodSameWord" name="srcGoodSameWord" type="text" value="" size="" maxlength="50" style="width:90%;" /></td>
				<td class="table_td_subject">상품구분</td>
				<td class="table_td_contents">
					<select id="srcGoodClasCode" name="srcGoodClasCode" style="width:80px;" class="select">
						<option value="">전체</option>
					</select>
				</td>
				<td class="table_td_subject">정상여부</td>
				<td class="table_td_contents">
					<select id="srcIsUse" name="srcIsUse" style="width: 80px;" class="select">
						<option value="">전체</option>
						<option value="1" selected="selected">정상</option>
						<option value="0">종료</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="8" height="1" bgcolor="eaeaea"></td>
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
	<td align="right" valign="bottom">

<%-- 		<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 		<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 		<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
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
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size:12px;color:red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>