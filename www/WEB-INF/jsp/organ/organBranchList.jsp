<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="crosscert.Hash"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpBranchsDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="java.util.List"%>

<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	//그리드의 width와 Height을 정의
	String listHeight =    "$(window).height()-260 + Number(gridHeightResizePlus)";
	if("ADM".equals(loginUserDto.getSvcTypeCd())){
		listHeight = "$(window).height()-400 + Number(gridHeightResizePlus)";
	}

	@SuppressWarnings("unchecked")    //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String businessNum = "";
	if(loginUserDto.getSmpBranchsDto() != null)    businessNum = CommonUtils.getString(loginUserDto.getSmpBranchsDto().getBusinessNum());
	boolean isClient = "BUY".equals(loginUserDto.getSvcTypeCd()) ? true : false ;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>


<% if(Constances.COMMON_ISREAL_SERVER) { %>
<%
/**------------------------------------공인인증 등록---------------------------------
  파라미터1 : 법인 (CLT), 공급사 (VEN)
  파라미터2 : 사용구분 (REG : 업체등록, ETC : 기타)
  파라미터3 : 공인인증서 인증상태 (0 : 등록, 1 : 생성, 2 : 무시), 공통함수사용
  파라미터4 : 사업자 등록번호 (인증상태값이 1인 경우에만 사용한다. 1이 아닌경우 '' 으로 넘긴다.)
  파라미터5 : CallBack function명
  파라미터6 : 조직ID (법인일경우 ClientId, 사업장일경우 VendorId) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<script type="text/javascript">
var authStep = "";
function fnAuth(){
	//fnGetIsExistPublishAuth(svcTypeCd, borgId) - 현재 세션의 공인인증서 인증상태를 확인 (파라미터3 참조)
	authStep = fnGetIsExistPublishAuth('<%=loginUserDto.getSvcTypeCd()%>','<%=loginUserDto.getBorgId()%>');
	fnAuthBusinessNumberDialog("CLT", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=loginUserDto.getClientId()%>');
}

function fnCallBackAuthBusinessNumber(userDn) {
	if((userDn != "" && userDn != null) || authStep == "2"){
		if("A" == $.trim($("#authMode").val())){
			addRow();
		}else if("D" == $.trim($("#authMode").val())){
			onDetail();
		}
	}
}
</script>
<% //------------------------------------------------------------------------------ %>

<%    }else{ %>
<script type="text/javascript">
function fnAuth(){
	if("A" == $.trim($("#authMode").val())){
		addRow();
	}else if("D" == $.trim($("#authMode").val())){
		onDetail();
	}
}
</script>
<%    } %>

<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcGroupId = "";
	String _srcClientId = "";
	String _srcBranchId = "";
	String _srcBorgNms = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	if("BUY".equals(loginUserDto.getSvcTypeCd())) {
		_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
		_srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
		_srcBranchId = _srcBorgScopeByRoleDto.getSrcBranchId();
		_srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
		_srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
	}
%>
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
	$("#srcBranchId").val("<%=_srcBranchId %>");
    $("#srcBorgName").val("<%=_srcBorgNms %>");
<%
	if("BUY".equals(loginUserDto.getSvcTypeCd())) {%>
		$("#srcBorgName").attr("disabled", true);
		$("#btnBuyBorg").css("display","none");
<%	}%>

	$("#btnBuyBorg").click(function(){
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
	$("#srcBorgName").keydown(function(e){ if(e.keyCode==13) { $("#btnBuyBorg").click(); } });
	$("#srcBorgName").change(function(e){
		if($("#srcBorgName").val()=="") {
			$("#srcGroupId").val("");
			$("#srcClientId").val("");
			$("#srcBranchId").val("");
		}
	});
	$("#srcCorporButton").click(function(){
		location.href="/menu/organ/corporationClientList.sys?_menuId=<%=_menuId %>";
	});

	$("#srcUsrButton").click(function(){
		location.href="/organ/organUserList.sys?_menuId=<%=_menuId %>";
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
	$("#srcGroupId").val(groupId);
	$("#srcClientId").val(clientId);
	$("#srcBranchId").val(branchId);
	$("#srcBorgName").val(borgNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(    //조회조건의 회원사등급 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{
			codeTypeCd:"MEMBERGRADE", isUse:"1"
		},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcBranchGrad").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			$.post(    //조회조건의 권역세팅
				'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
				{codeTypeCd:"DELI_AREA_CODE", isUse:"1"},
				function(arg){
					var codeList = eval('(' + arg + ')').codeList;
					for(var i=0;i<codeList.length;i++) {
						if(codeList[i].codeVal1!="99") {
							$("#srcAreaType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
						}
					}
					initList();    //그리드 초기화
				}
			);
		}
	);
	$("#srcButton").click( function() { 
		fnSearch(); 
	});
<%
	if(loginUserDto.getSvcTypeCd().equals("ADM")){%>
	$("#srcBorgNameLike").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcClientNameLike").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
<%	}%>
	$("#srcBranchGrad").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcAreaType").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcIsUse").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcPressentNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { fnSearch(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	$("#modButton").click(function(){ 
		$("#authMode").val("D");
		fnAuth(); 
	});
//    $("#regButton").click(function(){ addRow(); });
	$("#regButton").click(function(){ 
		$("#authMode").val("A");
		fnAuth(); 
	});
	
	$("#excelButton").click(function(){ 
		fnAllExcelPrintDown();
	});
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").jqGrid( 'setGridWidth', $("#navbar-container").width());
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organBranchListJQGrid.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:['업체코드', '법인명', '사업장명', '사업자등록번호','대표자명', '고객유형', '채권담당자','법인/주문제한','주문제한여부','대금변제일', '권역', '회원사등급', '상태', '선입금여부', '대표전화번호', '우편번호', '주소','상세주소','회사샵(#)메일', '휴면사업장','계약여부','등록일', 'branchId','clientId'],
		colModel:[
			{name:'branchCd',index:'branchCd', width:80,align:"center",search:false,sortable:true,editable:false},						//업체코드
			{name:'borgNm',index:'borgNm', width:170,align:"left",search:false,sortable:true,editable:false},							//법인명
			{name:'branchNm',index:'branchNm', width:200,align:"left",search:false,sortable:true,editable:false},						//사업자명
			{name:'businessNum',index:'businessNum', width:85,align:"center",search:false,sortable:true,editable:false},				//사업자등록번호
			{name:'pressentNm',index:'pressentNm', width:60,align:"center",search:false,sortable:true,editable:false},					//대표자명
			{name:'workNm',index:'workNm', width:95,align:"center",search:false,sortable:true,editable:false},							//고객유형
			{name:'userNm',index:'userNm', width:70,align:"center",search:false,sortable:true,editable:false,hidden:true},				//채권담당자
			{name:'clientStatus',index:'clientStatus', width:90,align:"center",search:false,sortable:false,editable:false},			//법인사용/주문제한 여부
			{name:'isOrderLimit',index:'isOrderLimit', width:75,align:"center",search:false,sortable:true,editable:false},				//주문제한여부
			{name:'autOrderLimitPeriod',index:'autOrderLimitPeriod', width:65,align:"right",search:false,sortable:true,editable:false,formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//결제만기일
			{name:'areaTypeNm',index:'areaTypeNm', width:50,align:"center",search:false,sortable:true,editable:false},					//권역
			{name:'branchGrad',index:'branchGrad', width:65,align:"center",search:false,sortable:true,editable:false},					//회원사등급
			{name:'isUse',index:'isUse', width:40,align:"center",search:false,sortable:true,editable:false},							//상태
			{name:'prePay',index:'prePay', width:65,align:"center",search:false,sortable:true,editable:false},							//선입금 여부
			{name:'phoneNum',index:'phoneNum', width:80,align:"center",search:false,sortable:true,hidden:true,editable:false},			//대표전화번호
			
			{name:'postAddrNum',index:'postAddrNum', width:50,align:"center",search:false,sortable:true,hidden:true,editable:false},	//우편번호
			{name:'addres',index:'addres', width:200,align:"left",search:false,sortable:true,hidden:true,editable:false},				//주소
			{name:'addresDesc',index:'addresDesc', width:200,align:"left",search:false,sortable:true,hidden:true,editable:false},		//상세주소
			{name:'sharp_mail',index:'sharp_mail', width:150,align:"left",search:false,sortable:true,hidden:true,editable:false},		//회사샵메일
			{name:'userLoginYn',index:'userLoginYn', width:70,align:"center",search:false,sortable:true,editable:false},				//휴면사업장
			{name:'contractYn',index:'contractYn', width:70,align:"center",search:false,sortable:true,editable:false},					//계약여부
			{name:'createDate',index:'createDate', width:80,align:"center",search:false,sortable:true,editable:false},					//등록일
			{name:'branchId',index:'branchId', hidden:true},    //branchId
			{name:'clientId',index:'clientId', hidden:true}        //clientId
		],
		postData: {
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
			srcBranchGrad:$("#srcBranchGrad").val(),
			srcAreaType:$("#srcAreaType").val(),
			srcIsUse:$("#srcIsUse").val(),
			srcWorkId:$("#srcWorkId").val(),
			srcAccUser:$("#srcAccUser").val(),
			srcIsOrderLimit:$("#srcIsOrderLimit").val(),
			srcPrePay:$("#srcPrePay").val(),
			srcPressentNm:$("#srcPressentNm").val(),
			srcBusinessNum:$("#srcBusinessNum").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000,5000], pager: '#pager',
		height: <%=listHeight%>, autowidth: true,
		sortname: 'branchId', sortorder: "desc", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,    //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");  
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="branchNm") { 
				jq("#list").setSelection(rowid);  
				$("#authMode").val("D");
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnAuth();")%>
			}
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'branchNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'branchNm','',{cursor: 'pointer'});  
			jq("#list").setCell(rowid,'branchNm','',{'text-decoration':'underline'});  
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcBranchGrad = $("#srcBranchGrad").val();
	data.srcAreaType = $("#srcAreaType").val();
	data.srcIsUse = $("#srcIsUse").val();
	data.srcWorkId = $("#srcWorkId").val();
	data.srcAccUser = $("#srcAccUser").val();
	data.srcIsOrderLimit = $("#srcIsOrderLimit").val();
	data.srcPrePay = $("#srcPrePay").val();
	data.srcPressentNm = $("#srcPressentNm").val();
	data.srcBusinessNum = $("#srcBusinessNum").val();
<%
	if(loginUserDto.getSvcTypeCd().equals("ADM")){%>
		data.srcBorgNameLike= $("#srcBorgNameLike").val();
		data.srcClientNameLike= $("#srcClientNameLike").val();
<%	}%>
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['업체코드','법인명', '사업장명', '사업자등록번호','고객유형',/*'채권담당자',*/'법인사용/주문제한 여부','주문제한여부' ,'권역', '회원사등급', '상태', '선입금여부','대표전화번호', '대표자명', '우편번호', '주소','상세주소', '회사샵(#)메일', '등록일'];    //출력컬럼명
	var colIds = ['branchCd','borgNm', 'branchNm','businessNum','workNm',/*'userNm',*/'clientStatus','isOrderLimit','areaTypeNm','branchGrad','isUse','prePay','phoneNum','pressentNm','postAddrNum','addres','addresDesc','sharp_mail','createDate'];    //출력컬럼ID
	var numColIds = [];    //숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "사업장 조회";    //sheet 타이틀
	var excelFileName = "organBranchList";    //file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['업체코드','법인명', '사업장명', '사업자등록번호','고객유형',/*'채권담당자',*/'법인사용/주문제한 여부','주문제한여부' ,'권역', '회원사등급', '상태', '선입금여부',  '대표전화번호', '대표자명', '우편번호', '주소','상세주소', '회사샵(#)메일','등록일'];    //출력컬럼명
	var colIds = ['branchCd','borgNm', 'branchNm','businessNum','workNm',/*'userNm',*/'clientStatus1','isOrderLimit1','areaTypeNm','branchGrad','isUse', 'prePay', 'phoneNum','pressentNm','postAddrNum','addres','addresDesc','sharp_mail','createDate'];    //출력컬럼ID
	var numColIds = [];    //숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "사업장 조회";    //sheet 타이틀
	var excelFileName = "allOrganBranchList";    //file명
	var actionUrl = "/organ/organBranchListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcGroupId';
	fieldSearchParamArray[1] = 'srcClientId';
	fieldSearchParamArray[2] = 'srcBranchId';
	fieldSearchParamArray[3] = 'srcBranchGrad';
	fieldSearchParamArray[4] = 'srcAreaType';
	fieldSearchParamArray[5] = 'srcIsUse';
	fieldSearchParamArray[6] = 'srcWorkId';
	fieldSearchParamArray[7] = 'srcAccUser';
	fieldSearchParamArray[8] = 'srcPressentNm';
	fieldSearchParamArray[9] = 'srcBusinessNum';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organBranchDetail.sys?branchId=" + selrowContent.branchId + "&clientId=" + selrowContent.clientId+"&_menuId=<%=_menuId %>";
		window.open(popurl, 'okplazaPop', 'width=920, height=780, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }    
}

function addRow(){
	var popurl = "/organ/organBranchReg.sys?_menuId=<%=_menuId %>";
	window.open(popurl, 'okplazaPop', 'width=950, height=850, scrollbars=yes, status=no, resizable=no');
}

//엑셀다운
function fnAllExcelPrintDown(){
	var colLabels		= ['업체코드',	'법인명',	'사업장명',	'사업자등록번호','대표자명',	'고객유형',	/*'채권담당자',*/	'법인사용/주문제한 여부',	'주문제한여부' ,	'대금변제일' ,'권역'		,	'회원사등급',	'상태',		'선입금여부',	'휴면사업장','계약여부',	'등록일'];		//출력컬럼명
	var colIds			= ['branchCd',	'borgNm',	'branchNm',	'businessNum','pressentNm',	'workNm',	/*'userNm',*/		'clientStatus1',			'isOrderLimit1',	'autOrderLimitPeriod'		,'areaTypeNm',	'branchGrad',	'isUse',	'prePay',		'userLoginYn','contractYn',	'createDate'];	//출력컬럼ID 
	var numColIds		= [];						//숫자표현ID
	var sheetTitle		= "사업장조회";				//sheet 타이틀
	var excelFileName	= "BranchList";				//file명
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcClientNameLike';	//법인명
	fieldSearchParamArray[1] = 'srcBorgNameLike';	//사업장명
	fieldSearchParamArray[2] = 'srcBranchGrad';		//회원사등급
	fieldSearchParamArray[3] = 'srcAreaType';		//권역
	fieldSearchParamArray[4] = 'srcIsUse';			//상태
	fieldSearchParamArray[5] = 'srcWorkId';			//고객유형
	fieldSearchParamArray[6] = 'srcGroupId';
	fieldSearchParamArray[7] = 'srcClientId';
	fieldSearchParamArray[8] = 'srcBranchId';
	fieldSearchParamArray[9] = 'srcIsOrderLimit';	//주문제한여부
	fieldSearchParamArray[10] = 'srcPressentNm';	//대표자명
	fieldSearchParamArray[11] = 'srcBusinessNum';	//사업자등록번호
	fieldSearchParamArray[12] = 'srcPrePay';		//선입금여부
// 	fieldSearchParamArray[6] = 'srcAccUser';		//채권담당자
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/organ/organBranchListExcel.sys");
<%-- 	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/organ/branchListExcel.sys"); --%>
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });    //메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
	//사업장관리
	header = "사업장관리";
	manualPath = "/img/manual/branch/organBranchList.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

<style type="text/css">
/* 로우에 손가락 모양 */
/* .ui-jqgrid .ui-jqgrid-btable { cursor : pointer; } */
th.ui-th-column div{
	white-space:normal !important;
	height:auto !important;
	padding:2px;
}
</style>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td height="25" class='ptitle'>사업장 조회
<%						if(isClient){ %>
							&nbsp;<span id="question" class="questionButton">도움말</span>
<%						} %>
					</td>
					<td align="right" class='ptitle'>
<!-- 						<a href="#"> -->
<%--                                 <img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> --%>
<%--                                 <img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> --%>
<!-- 							</a> -->
						<button id='srcCorporButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 법인 조회</button>
						<button id='srcUsrButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 사용자 조회</button>
						<button id='excelButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table> 
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td height="1"></td>
	</tr>
	<tr>
		<td>
<%	if(!loginUserDto.getSvcTypeCd().equals("ADM")){%>
			<!-- 컨텐츠 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">고객사</td>
					<td class="table_td_contents">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 300px" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<input id="authMode" name="authMode" type="hidden" value=""/>
						<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
					<td class="table_td_subject" width="100">회원사등급</td>
					<td class="table_td_contents">
						<select id="srcBranchGrad" name="srcBranchGrad" class="select"> 
							<option value="">전체</option> 
						</select>
					</td>
					<td width="80" class="table_td_subject">권역</td>
					<td class="table_td_contents">
						<select id="srcAreaType" name="srcAreaType" class="select"> 
							<option value="">전체</option> 
						</select>
					</td>
					<td width="80" class="table_td_subject">상태</td>
					<td class="table_td_contents">
						<select id="srcIsUse" name="srcIsUse" class="select"> 
							<option value="1">정상</option>
							<option value="0">종료</option>
							<option value="">전체</option> 
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
<%	} else{ ///////////////////////////////////////       변경분(20130424)       ///////////////////////////////////////////%>                    
			<!-- 컨텐츠 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">법인명</td>
					<td class="table_td_contents">
						<input id="srcClientNameLike" name="srcClientNameLike" type="text" value="" size="20" maxlength="30" style="width: 180px" />
					</td>
					<td class="table_td_subject" width="100">사업장명</td>
					<td class="table_td_contents">
						<input id="srcBorgNameLike" name="srcBorgNameLike" type="text" value="" size="20" maxlength="30" style="width: 180px" />
					</td>
					<td class="table_td_subject" width="100">회원사등급</td>
					<td class="table_td_contents">
						<select id="srcBranchGrad" name="srcBranchGrad" class="select"> 
							<option value="">전체</option> 
						</select>
					</td>
					<td width="80" class="table_td_subject">권역</td>
					<td class="table_td_contents">
						<select id="srcAreaType" name="srcAreaType" class="select"> 
							<option value="">전체</option> 
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="8" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="80" class="table_td_subject">고객유형</td>
					<td class="table_td_contents">
						<select id="srcWorkId" name="srcWorkId" class="select" style="width: 120px;">
							<option value="">전체</option>
<%
	@SuppressWarnings("unchecked")
	List<WorkInfoDto> workInfoList = (List<WorkInfoDto>) request.getAttribute("workInfoList");

	if(workInfoList != null && workInfoList.size() > 0){

		for(WorkInfoDto workInfoDto : workInfoList){
%>
							<option value="<%=workInfoDto.getWorkId()%>"><%=workInfoDto.getWorkNm()%></option>
<%
		}
	}
%>
						</select>
					</td>
					<td width="80" class="table_td_subject" style="display: none;">채권담당자</td>
					<td class="table_td_contents" style="display: none;">
						<select id="srcAccUser" name="srcAccUser" class="select" style="width: 120px;">
							<option value="">전체</option>
<%
	@SuppressWarnings("unchecked")
	List<UserDto> admUserList = (List<UserDto>) request.getAttribute("admUserList");
	if(admUserList != null && admUserList.size() > 0){
		for(UserDto userDto : admUserList){
%>
							<option value="<%=userDto.getUserId()%>"><%=userDto.getUserNm()%></option>
<%
		}
	}
%>
						</select>
					</td>
					<td class="table_td_subject" width="100">정상고객사</td>
					<td class="table_td_contents">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 300px" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<input id="authMode" name="authMode" type="hidden" value=""/>
						<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
					<td class="table_td_subject" width="100">주문제한여부</td>
					<td class="table_td_contents">
						<select id="srcIsOrderLimit" name="srcIsOrderLimit" class="select" >
							<option value="">전체</option>
							<option value="0">주문정상</option>
							<option value="1">주문제한</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="8" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">대표자명</td>
					<td class="table_td_contents">
						<input type="text" id="srcPressentNm" name="srcPressentNm" value=""/>
					</td>
					<td class="table_td_subject" width="100">사업자등록번호</td>
					<td class="table_td_contents" >
						<input type="text" id="srcBusinessNum" name="srcBusinessNum" value=""/>
					</td>
					<td class="table_td_subject" >선입금여부</td>
					<td class="table_td_contents">
						<select class="select" id="srcPrePay" name="srcPrePay" style="width: 125px;">
							<option value="">전체</option>
							<option value="1">예</option>
							<option value="0">아니오</option>
						</select> 
					</td>
					
					<td width="80" class="table_td_subject">상태</td>
					<td class="table_td_contents">
						<select id="srcIsUse" name="srcIsUse" class="select"> 
							<option value="1">정상</option>
							<option value="0">종료</option>
							<option value="">전체</option> 
						</select>
					</td>					
					
				</tr>
				<tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
			</table> <!-- 컨텐츠 끝 -->
<%    } %>
		</td>
	</tr>
	<tr>
		<td height="5"></td>
	</tr>
	<tr>
		<td align="right">
			<button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
<%--                 <a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%--                 <a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%--                 <a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
<%--                 <a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
		</td>
	</tr>
	<tr>
		<td height="1"></td>
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