<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList           = (List<ActivitiesDto>) request.getAttribute("useActivityList"); // 화면권한가져오기(필수)
	LoginUserDto        userInfoDto        = CommonUtils.getLoginUserDto(request);
	String              vendorid           = "";
	String              vendornm           = "";
	String              svcTypeCd          = userInfoDto.getSvcTypeCd();
	String              listHeight         = "$(window).height()-360 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String              listWidth          = "1500";
	String              menuId             = CommonUtils.getRequestMenuId(request);
	String              srcInsertStartDate = CommonUtils.getCustomDay("DAY", -7); // 날짜 세팅
	String              srcInsertEndDate   = CommonUtils.getCurrentDate();
	String              managementFlag     = CommonUtils.getString(request.getParameter("flag1"));
	String              startDate          = CommonUtils.getString(request.getParameter("startDate"));
	String              endDate            = CommonUtils.getString(request.getParameter("endDate"));
	boolean             isVendor           = false;
	
	if(svcTypeCd.equals("VEN")){
		vendorid = userInfoDto.getBorgId();
		vendornm = userInfoDto.getBorgNm();
		isVendor = true;
	}
			
	// 2016-03-09 상품 등록요청 조회 기간 변경 : 1주 --> 1년   
	boolean isExistSrcFlag = false;
	try{
		isExistSrcFlag	=	Boolean.parseBoolean(CommonUtils.getString(request.getParameter("srcFlag")));
	}catch(Exception e){
		isExistSrcFlag = false;
	}
	if(isExistSrcFlag){
		srcInsertStartDate 	= CommonUtils.getCustomDay("YEAR", -1);
		srcInsertEndDate 	= CommonUtils.getCurrentDate();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
.jqmWindow {
	display: none;
	position: absolute;
	top: 5%;
	left: 3%;
	width: 850px;
	background-color: #EEE;
	color: #333;
	z-index: 1003;
}
.jqmOverlay { background-color: #000; }
</style>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	// 코드 데이터 조회 
	fnDataInit();
	
	// 이벤트 등록
	/*--------------------검색에 대한 처리--------------------*/
	$("#srcButton").click(function() {
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcGoodName").val($.trim($("#srcGoodName").val()));
		$("#srcInsertStartDate").val($.trim($("#srcInsertStartDate").val()));
		$("#srcInsertEndDate").val($.trim($("#srcInsertEndDate").val()));
		$("#srcGoodSpecDesc").val($.trim($("#srcGoodSpecDesc").val()));
		$("#srcAppSts").val($.trim($("#srcAppSts").val()));
	});
	$("#srcButton").click(function() { fnSearch(); });
	$("#srcVendorNm").keydown(function(e) { if(e.keyCode==13) { $("#btnVendor").click(); }});
	$("#srcVendorNm").change(function(e) {	$("#srcVendorNm").val(""); $("#srcVendorId").val(""); });
	$("#srcGoodName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcInsertStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcInsertEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcGoodSpecDesc").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcAdminUserNm").keydown(function(e) { if(e.keyCode==13) { $("#btnUser").click(); }});
	$("#srcAdminUserNm").change(function(e) {	$("#srcAdminUserNm").val(""); $("#srcAdminUserId").val(""); });
	$("#srcAppSts").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	
	$("#btnVendor").click(function() { fnSearchVendor(); });
	$("#btnUser").click(function() { fnSearchUser(); });
	
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	
	// DataPicker 등록
	$("#srcInsertStartDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcInsertEndDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:3px;vertical-align:middle;cursor:pointer;");
	
	$('#productPop').jqm();
})

//리싸이즈 설정
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');

//코드 데이터 초기화
function fnDataInit() {
	$.post( //조회조건의 상품구분 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"REQAPPSTATE", isUse:"1"},
		function(arg) {
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcAppSts").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			initComponent();
		}
	);
}

//컨퍼넌트 초기화
function initComponent() {
	$("#srcVendorNm").val('<%=vendornm%>');
	$("#srcVendorId").val('<%=vendorid%>');
	if('<%=svcTypeCd%>' == "VEN") {
		$("#srcVendorNm").attr("disabled", true);
		$('#srcVendorNm').attr("class","input_text_none");
		$("#btnVendor").css("display","none");
	}
	if("<%=managementFlag%>" != ""){
		$("#srcInsertStartDate").val("<%=startDate%>");
		$("#srcInsertEndDate").val("<%=endDate%>");
	}else{
		$("#srcInsertStartDate").val("<%=srcInsertStartDate%>");
		$("#srcInsertEndDate").val("<%=srcInsertEndDate%>");
	}
	$("#srcAppSts").val('0');
	
	// 그리드 조회
	fnInitJqGridComponent();
}
</script>

<!-- 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorId = $('#srcVendorId').val();
	data.srcGoodName = $('#srcGoodName').val();
	data.srcInsertStartDate = $('#srcInsertStartDate').val();
	data.srcInsertEndDate = $('#srcInsertEndDate').val();
	data.srcGoodSpecDesc = $('#srcGoodSpecDesc').val();
	data.srcAdminUserId = $('#srcAdminUserId').val();
	data.srcAppSts = $('#srcAppSts').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function exportExcelToSvc() {
	var colLabels = ['상품등록요청','공급사명','상품명','상품규격','상품코드','매입단가','단위','납품소요일수','최소구매수량','제조사','처리상태','등록일'];//출력컬럼명
	var colIds = ['req_Good_Id','vendorNm','good_Name','good_Spec_Desc','good_Iden_Numb','sale_Unit_Pric','orde_Clas_Code','deli_Mini_Day','deli_Mini_Quan','make_Comp_Name','app_Sts','insert_Date'];//출력컬럼ID
	var numColIds = ['good_Iden_Numb','sale_Unit_Pric','deli_Mini_Day','deli_Mini_Quan'];//숫자표현ID
	var sheetTitle = "상품등록요청정보";//sheet 타이틀
	var excelFileName = "GoodRequestRegistList";//file명
	
	var actionUrl = "/product/productRequestRegistListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcVendorId';
	fieldSearchParamArray[1] = 'srcGoodName';
	fieldSearchParamArray[2] = 'srcInsertStartDate';
	fieldSearchParamArray[3] = 'srcInsertEndDate';
	fieldSearchParamArray[4] = 'srcGoodSpecDesc';
	fieldSearchParamArray[5] = 'srcAdminUserId';
	fieldSearchParamArray[6] = 'srcAppSts';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<!-------------------------------- Dialog Div Start -------------------------------->
<%
/**------------------------------------공급사팝업 사용방법---------------------------------
 * fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
 * borgNm : 찾고자하는 공급사명
 * callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
 */
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp"%>
<script type="text/javascript">
/**
 * 공급사 검색
 */
function fnSearchVendor() {
 	var vendorNm = $("#srcVendorNm").val();
 	fnVendorDialog(vendorNm, "fnCallBackVendor");
}
/**
 * 공급사 선택 콜백
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#srcVendorId").val(vendorId);
	$("#srcVendorNm").val(vendorNm);
}
</script>
<%
/**------------------------------------사용자팝업 사용방법---------------------------------
* fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* userNm : 찾고자하는 사용자명
* loginId : 찾고자하는 사용자 Login Id
* svcTypeCd : 찾는사용자의 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영사, "CEN":물륫센타)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(사용자일련번호, 조직일련번호, 서비스유형명, 사용자명, 로그인아이디, 조직명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<script type="text/javascript">
/**
 * 운영사담당자 검색
 */
function fnSearchUser() {
	var userNm = $("#srcAdminUserNm").val();
	var loginId = "";
	var svcTypeCd = "ADM";
	fnJqmUserInitSearch(userNm, loginId, svcTypeCd, "fnSelectUserCallback");
}
/**
 * 운영사담당자 선택 콜백
 */
 function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#srcAdminUserNm").val(userNm);
	$("#srcAdminUserId").val(userId);
}
</script>
<!-------------------------------- Dialog Div End -------------------------------->

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function fnInitJqGridComponent() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productRequestRegistListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			'상품등록요청',	'상품코드',			'구분',				'상품명',		'상품규격',
			'공급사',		'이미지',				'상품설명',			'매입단가',	'단위',
			'납품소요일수',	'최소구매수량',			'제조사',				'처리상태',	'요청일',
			'공급사Id',	'small_Img_Path',	'original_Img_Path'
		],
		colModel:[
			{ name:'req_Good_Id',       index:'req_Good_Id',       width:80,  align:"left",   search:false, sortable:false, editable:false, key:true },//상품등록요청Seq
			{ name:'good_Iden_Numb',    index:'good_Iden_Numb',    width:90,  align:"center", search:false, sortable:true,  editable:false },//상품코드
			{ name:'good_clas_name',    index:'good_clas_name',    width:50,  align:"center", search:false, sortable:false, editable:false, key:true },//상품등록요청Seq
			{ name:'good_Name',         index:'good_Name',         width:150, align:"left",   search:false, sortable:true,  editable:false },//공급사명
			{ name:'good_Spec_Desc',    index:'good_Spec_Desc',    width:280, align:"left",   search:false, sortable:false, editable:false },//규격
			
			{ name:'vendorNm',          index:'vendorNm',          width:150, align:"left",   search:false, sortable:true,  editable:false },//상품명
			{ name:'good_img',          index:'good_img',          width:50,  align:"center", search:false, sortable:false, editable:false },//이미지
			{ name:'desc_yn',           index:'desc_yn',           width:50,  align:"center", search:false, sortable:false, editable:false },//이미지
			{ name:'sale_Unit_Pric',    index:'sale_Unit_Pric',    width:60,  align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" }},//매입단가
			{ name:'orde_Clas_Code',    index:'orde_Clas_Code',    width:50,  align:"center", search:false, sortable:false, editable:false },//단위
			
			{ name:'deli_Mini_Day',     index:'deli_Mini_Day',     width:70,  align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" } },//납품소요일수
			{ name:'deli_Mini_Quan',    index:'deli_Mini_Quan',    width:70,  align:"right",  search:false, sortable:false, editable:false, sorttype:'integer', formatter:'integer', formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" } },//최소구매수량
			{ name:'make_Comp_Name',    index:'make_Comp_Name',    width:100, align:"left",   search:false, sortable:false, editable:false },//제조사
			{ name:'app_Sts',           index:'app_Sts',           width:80,  align:"center", search:false, sortable:false},//처리상태
			{ name:'insert_Date',       index:'insert_Date',       width:70,  align:"center", search:false, sortable:false, editable:false, formatter:"date"},//등록일
			
			{ name:'vendorId',          index:'vendorId',          hidden:true},//공급사Id
			{ name:'small_Img_Path',    index:'small_Img_Path',    hidden:true},
			{ name:'original_Img_Path', index:'original_Img_Path', hidden:true}// 오리지날이미지path
		],
		postData: {
			srcVendorId:$('#srcVendorId').val(),
			srcGoodName:$('#srcGoodName').val(),
			srcInsertStartDate:$('#srcInsertStartDate').val(),
			srcInsertEndDate:$('#srcInsertEndDate').val(),
			srcGoodSpecDesc:$('#srcGoodSpecDesc').val(),
			srcAdminUserId:$('#srcAdminUserId').val(),
			srcAppSts:$('#srcAppSts').val()
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight%>,width:$(window).width()-55 + Number(gridWidthResizePlus),
		sortname:'insert_date',sortorder:'desc', 
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				
				// img 화면 로드 
				var imgTag = ""; 
				if($.trim(selrowContent.small_Img_Path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_Img_Path+"' style='width:30px;height:30px;' />";	
				else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:30px;height:30px;' />";
				
				jQuery('#list').jqGrid('setRowData',rowid,{good_img:imgTag});
				if(selrowContent.good_Iden_Numb == "0") {
					jQuery('#list').jqGrid('setRowData',rowid,{good_Iden_Numb:''});
				}
				
			}
			
			fnCheackErrImg();
			
		},
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			var cm            = $("#list").jqGrid('getGridParam','colModel');
			var colName       = cm[iCol];
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			
			if(colName != undefined && colName['index'] == 'req_Good_Id') {
				var req_Good_Id = FNgetGridDataObj('list', rowid, 'req_Good_Id');
				
				fnReqProductDetailView('<%=menuId%>',req_Good_Id);
			}
			
			if(colName !=undefined && colName['index'] == 'good_Iden_Numb') {
				var good_Iden_Numb = FNgetGridDataObj('list', rowid, 'good_Iden_Numb');
				var vendorId       = FNgetGridDataObj('list', rowid, 'vendorId');
				
				if(good_Iden_Numb != '') {
					if('<%=svcTypeCd%>' == "VEN") {// 공급사 사용자
						fnVendorProductDetailView('<%=menuId%>', good_Iden_Numb, vendorId);
					}
					else if('<%=svcTypeCd%>' == "ADM") {// 운영사 사용자
						fnProductDetailView('<%= menuId %>', good_Iden_Numb, vendorId);
					}
				}
			}
			
			if(colName != undefined && colName['index'] == "good_img") {
				var orgImgPath = selrowContent.original_Img_Path;
				
				if($.trim(orgImgPath).length > 0){
					$('#productPop').css({'width':'500px','top':'15%','left':'20%'}).html('')
					.load('/menu/product/product/popBigImage.sys?bigImage='+orgImgPath)
					.jqmShow();
				}
				else{
					alert('이미지가 존재하지 않습니다.'); return;
				}
				
			}
			
			if(colName != undefined &&colName['name'] == "desc_yn") {
				if(selrowContent.desc_yn == 'Y') {
					funcDescView(selrowContent.req_Good_Id);
				}
			}
		},
		afterInsertRow:function(rowid, aData) {
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			
			jq("#list").setCell(rowid,'req_Good_Id','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'req_Good_Id','',{cursor:'pointer'});
			jq("#list").setCell(rowid,'good_Iden_Numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_Iden_Numb','',{cursor:'pointer'});
			jq("#list").setCell(rowid,'good_img','',{cursor: 'pointer'});
			
			if(selrowContent.desc_yn == 'Y') {
        		$(this).setCell(rowid,'desc_yn','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        	}
		},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
	jQuery("#list").jqGrid('setGridWidth', 1500);
	
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
	//공급사상품등록요청이력
	header = "공급사상품등록요청이력";
	manualPath = "/img/manual/vendor/productRequestRegistList.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}

function funcDescView(reqGoodId) {
	$('#productPop').css({'width':'700px','top':'40%','left':'40%'}).html('')
    .load('/menu/product/product/popReqProductDesc.sys?reqGoodId=' + reqGoodId)
    .jqmShow();
}
</script>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" method="post">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="1500px" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">공급사상품등록요청조회
					<%if(isVendor){ %>
						&nbsp;<span id="question" class="questionButton">도움말</span>
					<%} %> 
				</td>
				<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
					<button id='excelAll' type='button' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
					<button id='srcButton' type='button' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
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
				<td class="table_td_subject" width="100">공급사</td>
				<td class="table_td_contents">
					<input id="srcVendorNm" name="srcVendorNm" type="text" value="" size="" maxlength="50" />
					<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
					<img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;border:0px;vertical-align:middle;cursor:pointer;" /></td>
				<td class="table_td_subject" width="100">상품명</td>
				<td class="table_td_contents">
					<input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" /></td>
				<td class="table_td_subject" width="100">요청일자</td>
				<td class="table_td_contents">
					<input id="srcInsertStartDate" name="srcInsertStartDate" type="text" style="width:75px;" /> ~
					<input id="srcInsertEndDate" name="srcInsertEndDate" type="text" style="width:75px;" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품규격</td>
				<td class="table_td_contents">
					<input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" /></td>
<!-- 				<td class="table_td_subject">담당운영자</td> -->
<!-- 				<td class="table_td_contents"> -->
<!-- 					<input id="srcAdminUserNm" name="srcAdminUserNm" type="text" value="" size="" maxlength="50" /> -->
<!-- 					<input id="srcAdminUserId" name="srcAdminUserId" type="hidden" value="" /> -->
<%-- 					<img id="btnUser" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20;height:18px;border:0;" align="middle" class="icon_search" /></td> --%>
				<td class="table_td_subject">처리상태</td>
				<td class="table_td_contents" colspan="3">
					<select id="srcAppSts" name="srcAppSts" style="width:100px;" class="select">
						<option value="">전체</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr><td height="10"></td></tr>
		</table>
		<!-- 컨텐츠 끝 -->
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
<div id="dialogSelectRow" title="Warning" style="display:none;font-size:12px;color:red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div class="jqmWindow" id="productPop"></div>
</form>
</body>
</html>