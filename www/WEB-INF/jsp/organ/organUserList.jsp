<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="java.util.List"%>

<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-400 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
    String _menuCd = request.getParameter("_menuCd");
	
	String businessNum = "";
	if(loginUserDto.getSmpBranchsDto() != null)	businessNum = CommonUtils.getString(loginUserDto.getSmpBranchsDto().getBusinessNum());	
	boolean isClient = "BUY".equals(loginUserDto.getSvcTypeCd()) ? true : false ;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<% 	if(Constances.COMMON_ISREAL_SERVER) { %>
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
			addUser();
		}else if("D" == $.trim($("#authMode").val())){
			onDetail();
		}
	}
}
</script>
<%	}else{ %>
<script type="">
	function fnAuth(){
		if("A" == $.trim($("#authMode").val())){
			addUser();
		}else if("D" == $.trim($("#authMode").val())){
			onDetail();
		}
	}
</script>
<%	} %>
<% //------------------------------------------------------------------------------ %>

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
<%	if("BUY".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcBorgName").attr("disabled", true);
	$("#btnBuyBorg").css("display","none");
<%	}	%>
	
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
    
    $("#srcBranchButton").click(function(){
        location.href="/organ/organBranchList.sys?_menuId=<%=_menuId %>";
    });
	
	//엑셀출력
	$("#excelButton").click(function(){ 
		fnAllExcelPrintDown();
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
// 	alert("groupId : "+groupId+", clientId : "+clientId+", branchId : "+branchId+", borgNm : "+borgNm+", areaType : "+areaType);
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
	$("#srcButton").click( function() { 
		fnSearch(); 
	});
	$("#loginButton").click( function() { 
		fnUserLogin();
	});
	$("#regButton").click( function() { 
		//addUser();
		$("#authMode").val("A");
		fnAuth();
	});
	$("#modButton").click( function() { 
//		onDetail(); 
		$("#authMode").val("D");
		fnAuth();
	});
	$("#srcButton").click( function() { 
		$("#srcUserNm").val($.trim($("#srcUserNm").val()));
		fnSearch(); 
	});
	$("#srcButton").click( function() { 
		$("#srcLoginId").val($.trim($("#srcLoginId").val()));
		fnSearch(); 
	});
	$("#srcUserNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcLoginId").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcIsUse").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { fnSearch(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	
	//컨퍼넌트 초기화 
	fnInitJqGridComponent();
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
function fnInitJqGridComponent(){
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organUserListJQGrid.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:[
			'borgId',	'고객사',		'권역',		'사용자명',		'사용자ID',
			'사용자상태',	'고객사상태',	'감독여부',		'고객유형',		'로그인여부',
			'전화번호',		'이동전화번호',	'Email',	'Email발송',	'SMS발송','휴면여부',
			'등록일',		'userId',	'isUseCd'
		],
		colModel:[
			{name:'borgId',     index:'borgId',     hidden:true},	//고객사
			{name:'branchNm',   index:'branchNm',   width:300, align:"left",   search:false, sortable:true, editable:false},	//고객사
			{name:'areaTypeNm', index:'areaTypeNm', width:70,  align:"center", search:false, sortable:true, editable:false },	//권역
			{name:'userNm',     index:'userNm',     width:60,  align:"center", search:false, sortable:true, editable:false },	//사용자명
			{name:'loginId',    index:'loginId',    width:80,  align:"center", search:false, sortable:true, editable:false },	//사용자ID
			{name:'isUse',      index:'isUse',      width:80,  align:"center", search:false, sortable:true, editable:false },	//사용자상태
			{name:'borg_IsUse', index:'borg_IsUse', width:80,  align:"center", search:false, sortable:true, editable:false },	//사업장상태
			{name:'isDirect',   index:'isDirect',   width:50,  align:"center", search:false, sortable:true, editable:false },	//감독여부
			{name:'workNm',     index:'workNm',     width:120, align:"left",   search:false, sortable:true, editable:false, hidden:true },	//고객유형
			{name:'isLogin',    index:'isLogin',    width:60,  align:"center", search:false, sortable:true, editable:false, hidden:true },	//로그인여부
			{name:'tel',        index:'tel',        width:110,  align:"center", search:false, sortable:true, editable:false },	//전화번호
			{name:'mobile',     index:'mobile',     width:110,  align:"center", search:false, sortable:true, editable:false},	//이동전화번호
			{name:'eMail',      index:'eMail',      width:160, align:"left",   search:false, sortable:true, editable:false},	//이동전화번호
			{name:'isEmail',    index:'isEmail',    width:70,  align:"center", search:false, sortable:true, editable:false, edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}},	//EMAIL발송
			{name:'isSms',      index:'isSms',      width:70,  align:"center", search:false, sortable:true, editable:false, edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}},	//SMS발송
			{name:'userLoginYn',      index:'userLoginYn',      width:50, align:"center",   search:false, sortable:true, editable:false},	//휴면여부
			{name:'createDate', index:'createDate', width:80,  align:"center", search:false, sortable:true, editable:false },	//등록일
			{name:'userId',     index:'userId',     hidden:true },	//userId
			{name:'isUseCd',    index:'isUseCd',    hidden:true }	//isUseCd
		],
		postData: {
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcBranchId:$("#srcBranchId").val(),
			srcUserNm:$("#srcUserNm").val(),
			srcLoginId:$("#srcLoginId").val(),
			srcIsUse:$("#srcIsUse").val(),
			srcIsDirect:$("#srcIsDirect").val(),
			srcWorkId:$("#srcWorkId").val(),
			srcBorgIsUse:$("#srcBorgIsUse").val()
		},
		rowNum:50, rownumbers: false, rowList:[50,100,500,1000], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'userId', sortorder: "desc",
// 		caption:"사용자 조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(){
			var rowCnt = $(this).getGridParam('reccount');
			if(rowCnt > 0){
				for(var i=0; i<rowCnt; i++){
					var rowid = $(this).getDataIDs()[i];
					var selrowContent = $(this).jqGrid('getRowData',rowid);
					var tel = selrowContent.tel;
					tel = fnSetTelformat(tel);
					var mobile = selrowContent.mobile;
					mobile = fnSetTelformat(mobile);
					$(this).jqGrid('setRowData',rowid,{tel:tel});
					$(this).jqGrid('setRowData',rowid,{mobile:mobile});
				}
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
            var moveUserId = selrowContent.userId;
            var belongBorgId = selrowContent.borgId;
            var belongSvcTypeCd = "BUY";			
            $("#frm #belongBorgId").val(belongBorgId);
            $("#frm #belongSvcTypeCd").val(belongSvcTypeCd);
            $("#frm #moveUserId").val(moveUserId);
            $("#frm #authMode").val("D");
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");  
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="userNm") { 
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				jq("#list").setSelection(rowid);  
				var moveUserId = selrowContent.userId;
				var belongBorgId = selrowContent.borgId;
				var belongSvcTypeCd = "BUY";			
                $("#frm #belongBorgId").val(belongBorgId);
                $("#frm #belongSvcTypeCd").val(belongSvcTypeCd);
                $("#frm #moveUserId").val(moveUserId);
                $("#frm #authMode").val("D");
				$("#authMode").val("D");
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnAuth();")%>
			}
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'userNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'userNm','',{cursor: 'pointer'});  
			jq("#list").setCell(rowid,'userNm','',{'text-decoration':'underline'});  
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
// 		gridview:true
	}); 
};
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function fnUserLogin(){
	if("" == $.trim($("#frm #belongBorgId").val()) || "" == $.trim($("#frm #belongSvcTypeCd").val()) || "" == $.trim($("#frm #moveUserId").val())){
		alert("로그인할 사용자를 선택해주세요.");
		return;
	}
<%	if("ADM".equals(loginUserDto.getSvcTypeCd())){ %>
	$("#adminUserId").val('<%=loginUserDto.getUserId() %>');
	$("#adminBorgId").val('<%=loginUserDto.getBorgId() %>');
	$("#adminBorgNm").val('<%=loginUserDto.getBorgNm() %>');
	$("#adminSvcTypeCd").val('<%=loginUserDto.getSvcTypeCd() %>');
<%	}	%>
    // alert( "adminUserId : "+$("#adminUserId").val() +"\nadminBorgId : "+$("#adminBorgId").val() +"\nadminBorgNm : "+$("#adminBorgNm").val() +"\nadminSvcTypeCd : "+$("#adminSvcTypeCd").val() +"\nbelongBorgId : "+$("#frm #belongBorgId").val() +"\nbelongSvcTypeCd : "+$("#frm #belongSvcTypeCd").val() +"\nmoveUserId : "+$("#frm #moveUserId").val());
	frm.action = "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/belongSystemLogin.sys";
	frm.target = "_parent";
	frm.submit();	
}

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcUserNm = $("#srcUserNm").val();
	data.srcLoginId = $("#srcLoginId").val();
	data.srcIsUse = $("#srcIsUse").val();
	data.srcIsDirect = $("#srcIsDirect").val();
	data.srcWorkId = $("#srcWorkId").val();
	data.srcBorgIsUse = $("#srcBorgIsUse").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

function addUser(){
	var popurl = "/organ/organUserReg.sys?_menuCd=<%=_menuCd %>";
	window.open(popurl, 'okplazaPop', 'width=600, height=630, scrollbars=yes, status=no, resizable=yes');
    //fnSearch();
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organUserDetail.sys?borgId=" + selrowContent.borgId + "&userId=" + selrowContent.userId + "&_menuCd=<%=_menuCd %>";
	    window.open(popurl, 'okplazaPop', 'width=600, height=650, scrollbars=yes, status=no, resizable=yes');
// 	    fnSearch();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

//엑셀다운
function fnAllExcelPrintDown(){
	var colLabels				= ['고객사',	'권역',			'사용자명',	'사용자ID',	'사용자상태',	'고객사상태',	'감독여부',	'전화번호',	'이동전화번호',	'Email',	'Email발송',	'SMS발송',	'휴면여부',		'등록일'];		//출력컬럼명
	var colIds					= ['branchNm',	'areaTypeNm',	'userNm',	'loginId',	'isUse',		'borg_IsUse',	'isDirect',	'tel',		'mobile',		'email',	'isEmail',		'isSms',	'userLoginYn',	'createDate'];	//출력컬럼ID
	var numColIds				= [];				//숫자표현ID
	var sheetTitle				= "사용자 조회";	//sheet 타이틀
	var excelFileName			= "OrganUserList";	//file명
	var fieldSearchParamArray = new Array();
	
	fieldSearchParamArray[0] = 'srcGroupId';
	fieldSearchParamArray[1] = 'srcClientId';
	fieldSearchParamArray[2] = 'srcBranchId';
	fieldSearchParamArray[3] = 'srcUserNm';		//사용자명
	fieldSearchParamArray[4] = 'srcWorkId';		//고객유형
	fieldSearchParamArray[5] = 'srcLoginId';	//사용자ID
	fieldSearchParamArray[6] = 'srcIsUse';		//사용자 상태
	fieldSearchParamArray[7] = 'srcIsDirect';	//감독여부
	fieldSearchParamArray[8] = 'srcBorgIsUse';	//고객사상태
	
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/organ/userListExcel.sys");
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
	//사용자관리
	header = "사용자관리";
	manualPath = "/img/manual/branch/organUserList.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;" method="post">
	<input type="hidden" id="belongBorgId" name="belongBorgId" />
	<input type="hidden" id="belongSvcTypeCd" name="belongSvcTypeCd" />
	<input type="hidden" id="moveUserId" name="moveUserId"/>
	
	<input type="hidden" id="adminUserId" name="adminUserId"/>
	<input type="hidden" id="adminBorgId" name="adminBorgId"/>
	<input type="hidden" id="adminBorgNm" name="adminBorgNm"/>
	<input type="hidden" id="adminSvcTypeCd" name="adminSvcTypeCd"/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
					<td height="25" class='ptitle'>사용자 조회
<%-- <%	if(isClient){ %> --%>
<!-- 						&nbsp;<span id="question" class="questionButton">도움말</span> -->
<%-- <%	} %> --%>
					</td>
					<td align="right" class='ptitle'>
<!-- 								<a href="#"> -->
<%-- 									<img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> --%>
<%-- 									<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> --%>
<!-- 								</a> -->
						<button id='srcCorporButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 법인 조회</button>
						<button id='srcBranchButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 사업장 조회</button>
						<button id='excelButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">고객사</td>
					<td class="table_td_contents">
						<input id="srcBorgName" name="srcBorgName" type="text" value="" maxlength="30" style="width: 80%;" />
						<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
						<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
						<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
						<input id="authMode" name="authMode" type="hidden" value=""/>
						<a href="#">
							<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
						</a>
					</td>
					<td class="table_td_subject" width="100">사용자명</td>
					<td class="table_td_contents"><input id="srcUserNm" name="srcUserNm" type="text" size="20" maxlength="50" /></td>
					<td class="table_td_subject" width="100">고객유형</td>
					<td class="table_td_contents">
						<select id="srcWorkId" name="srcWorkId" class="select">
							<option value="">전체</option>
<%

	@SuppressWarnings("unchecked")	//고객유형
	List<WorkInfoDto> workInfoList = (List<WorkInfoDto>)request.getAttribute("workInfoList");
	for(int i = 0 ; i < workInfoList.size() ; i++){
%>
							<option value="<%=workInfoList.get(i).getWorkId()%>"><%=workInfoList.get(i).getWorkNm() %></option>
<%		
	}
%>								
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">사용자ID</td>
					<td class="table_td_contents">
						<input id="srcLoginId" name="srcLoginId" type="text" size="20" maxlength="50" /> 
					</td> 
					<td class="table_td_subject" width="100">사용자상태</td>
					<td class="table_td_contents">
						<select id="srcIsUse" name="srcIsUse" class="select"> 
							<option value="1">정상</option>
							<option value="0">종료</option>
							<option value="">전체</option> 
						</select>
					</td>
					<td class="table_td_subject" width="100">감독여부</td>
					<td class="table_td_contents">
						<select id="srcIsDirect" name="srcIsDirect" class="select"> 
							<option value="">전체</option>
							<option value="Y">예</option>
							<option value="N">아니요</option> 
						</select>
					</td>							
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">고객사상태</td>
					<td class="table_td_contents" colspan="5">
						<select id="srcBorgIsUse" name="srcBorgIsUse" class="select"> 
							<option value="1">정상</option>
							<option value="0">종료</option>
							<option value="">전체</option> 
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table> <!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td height="5"></td>
	</tr>
	<tr>
		<td align="right">
<%	if("ADM".equals(loginUserDto.getSvcTypeCd()) && "SKTS2015".equals(loginUserDto.getLoginId()) == false ){ %>	 <%--2015.08.06 SKTS2015 ID 접속시 로그인 버튼이 안보이도록 처리 --%>				
<%-- 					<a href="#"><img id="loginButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_login.gif" height="22" style='border:0;' /></a> --%>
			<button id='loginButton' class="btn btn-warning btn-xs" ><i class="fa fa-key"></i> 로그인</button>
<%	} %>					
			<button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
<%-- 					<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 					<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
<%-- 					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
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