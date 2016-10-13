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
	String listHeight = "$(window).height()-360 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String inputVendorNmType = "";
	String vendorNm = "";
	boolean isVendor = false;
	if("VEN".equals(userInfoDto.getSvcTypeCd())) {
		vendorNm = userInfoDto.getBorgNm();
		inputVendorNmType = "disabled='disabled'";
		isVendor = true;
	}
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String businessNum = "";
	if(loginUserDto.getSmpVendorsDto() != null)	businessNum = CommonUtils.getString(loginUserDto.getSmpVendorsDto().getBusinessNum());	
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
	fnAuthBusinessNumberDialog("VEN", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=loginUserDto.getBorgId()%>');
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
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<!-- 공급사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcVendorId = "";
	String _srcVendorName = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	if("VEN".equals(loginUserDto.getSvcTypeCd())) {
		_srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcVendorId = _srcBorgScopeByRoleDto.getSrcBranchId();
		_srcVendorName = _srcBorgScopeByRoleDto.getSrcBorgNms();
	}
%>
	$("#srcVendorName").val("<%=_srcVendorName %>");
	$("#srcVendorId").val("<%=_srcVendorId %>");
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcVendorName").attr("disabled", true);
	$("#btnVendor").css("display","none");
<%	}	%>
	
	$("#btnVendor").click(function(){
		var vendorNm = $("#srcVendorName").val();
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	$("#srcVendorName").keydown(function(e){ if(e.keyCode==13) { $("#btnVendor").click(); } });
	$("#srcVendorName").change(function(e){
		if($("#srcVendorName").val()=="") {
			$("#srcVendorId").val("");
		}
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#srcVendorId").val(vendorId);
	$("#srcVendorName").val(vendorNm);
}
</script>
<% //------------------------------------------------------------------------------ %>


<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcButton").click( function() { 
		$("#srcLoginId").val($.trim($("#srcLoginId").val()));
		$("#srcUserNm").val($.trim($("#srcUserNm").val()));
		fnSearch(); 
	});
	$("#loginButton").click( function() { 
		fnUserLogin();
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
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	
	$("#regButton").click( function() { 
		//addUser();
		$("#authMode").val("A");
		fnAuth();
	});

	$("#modButton").click( function() { 
		$("#authMode").val("D");
		fnAuth();
	});
	
	$("#srcVendorButton").click( function() {
		location.href="/menu/organ/vendorClientList.sys?_menuId=<%=_menuId %>";
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
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organVendorUserListJQGrid.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:[
			'공급사',		'소재지',		'사용자명',		'사용자ID',		'사용자상태',
			'공급사상태',	'로그인여부',	'전화번호',		'이동전화번호',	'Email',
			'Email발송',	'SMS발송',		'휴면여부',	'등록일',		'userId',
			'borgId',		'isUseCd'
		],
		colModel:[
			{name:'vendorNm',		index:'vendorNm',   width:230, align:"left",   search:false, sortable:true, editable:false },	//공급사
			{name:'areaTypeNm',		index:'areaTypeNm', width:80,  align:"center", search:false, sortable:true, editable:false },	//소재지
			{name:'userNm',			index:'userNm',     width:90,  align:"center", search:false, sortable:true, editable:false },	//사용자명.
			{name:'loginId',		index:'loginId',    width:120, align:"center", search:false, sortable:true, editable:false },	//사용자ID
			{name:'isUse',			index:'isUse',      width:90,  align:"center", search:false, sortable:true, editable:false },	//상태
			{name:'borg_IsUse',		index:'borg_IsUse', width:90,  align:"center", search:false, sortable:true, editable:false },	//상태
			{name:'isLogin',		index:'isLogin',    width:90,  align:"center", search:false, sortable:true, editable:false, 
				hidden:true},																										//로그인여부
			{name:'tel',			index:'tel',        width:110, align:"center", search:false, sortable:true, editable:false },	//전화번호
			{name:'mobile',			index:'mobile',     width:110, align:"center", search:false, sortable:true, editable:false },	//이동전화번호
			{name:'eMail',			index:'eMail',      width:160, align:"left",   search:false, sortable:true, editable:false },	//email
			{name:'isEmail',		index:'isEmail',    width:70,  align:"center", search:false, sortable:true, editable:false,
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}},										//EMAIL발송
			{name:'isSms',			index:'isSms',      width:70,  align:"center", search:false, sortable:true, editable:false,
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}},										//SMS발송
			{name:'userLoginYn',	index:'userLoginYn', width:80,  align:"center", search:false, sortable:true, editable:false},	//휴면여부
			{name:'createDate',		index:'createDate', width:80,  align:"center", search:false, sortable:true, editable:false },	//등록일
			{name:'userId',			index:'userId',     hidden:true },	//userId
			{name:'borgId',			index:'borgId',     hidden:true },	//borgId
			{name:'isUseCd',		index:'isUseCd',    hidden:true }
		],
		postData: {
			srcVendorId:$("#srcVendorId").val(),
			srcUserNm:$("#srcUserNm").val(),
			srcLoginId:$("#srcLoginId").val(),
			srcIsUse:$("#srcIsUse").val()
		},
		rowNum:50, rownumbers: false, rowList:[50,100,500,1000], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'userId', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
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
			var belongSvcTypeCd = "VEN";			
			$("#frm #belongBorgId").val(belongBorgId);
			$("#frm #belongSvcTypeCd").val(belongSvcTypeCd);
			$("#frm #moveUserId").val(moveUserId);			
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
		<%if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
			jq("#list").setSelection(rowid);  
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="userNm") {
				$("#authMode").val("D");
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnAuth();")%>
			}
		<%} %>
		},
		afterInsertRow: function(rowid, aData){
		<% if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
			jq("#list").setCell(rowid,'userNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'userNm','',{cursor: 'pointer'});  
			jq("#list").setCell(rowid,'userNm','',{'text-decoration':'underline'});  
        <% } %>
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {mobile: fnSetTelformat(selrowContent.mobile)});
			jq("#list").jqGrid('setRowData', rowid, {tel: fnSetTelformat(selrowContent.tel)});
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function fnUserLogin(rowid){
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
	frm.action = "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/belongSystemLogin.sys";
	frm.target = "_parent";
	frm.submit();	
}

function fnSearch() {
	//jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorId = $("#srcVendorId").val();
	data.srcUserNm = $("#srcUserNm").val();
	data.srcLoginId = $("#srcLoginId").val();
	data.srcIsUse = $("#srcIsUse").val();
	jq("#list").jqGrid("setGridParam", {"page":1 , "datatype":"json"});
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/selectVendorUserDetail.sys?borgId=" + selrowContent.borgId + "&userId=" + selrowContent.userId + "&_menuId=<%=_menuId %>";
		var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=600, height=440, scrollbars=yes, status=no, resizable=yes');
// 	    fnSearch();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function addUser(){
	var popurl = "/organ/organVendorUserReg.sys?_menuId=<%=_menuId %>";
	var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);
    window.open(popurl, 'okplazaPop', 'width=600, height=500, scrollbars=yes, status=no, resizable=yes');
    //fnSearch();
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['공급사', '소재지', '사용자명', '사용자ID', '상태', '로그인여부', '전화번호', '이동전화번호', 'Email발송', 'SMS발송','등록일'];	//출력컬럼명
	var colIds = ['vendorNm','areaTypeNm','userNm','loginId','isUse','isLogin','tel','mobile','isEmail','isSms','createDate'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "공급사 사용자 조회";	//sheet 타이틀
	var excelFileName = "organVendorUserList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = [
		'공급사',		'소재지',		'사용자명',		'사용자ID',		'상태',
		'공급사상태',	'전화번호',		'이동전화번호',	'EMAIL',
		'Email발송',	'SMS발송',		'휴면여부',	'등록일'
	];	//출력컬럼명
	var colIds = [
		'vendorNm',		'areaTypeNm',	'userNm',		'loginId',		'isUse',
		'borg_IsUse',	'tel',			'mobile',		'eMail',
		'isEmail',		'isSms',		'userLoginYn',	'createDate'
	];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "공급사 사용자 조회";	//sheet 타이틀
	var excelFileName = "organVendorUserList";	//file명
	
	var actionUrl = "/organ/organVendorUserListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcVendorId';
	fieldSearchParamArray[1] = 'srcUserNm';
	fieldSearchParamArray[2] = 'srcLoginId';
	fieldSearchParamArray[3] = 'srcIsUse';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//공급사 사용자 조회
	header = "공급사 사용자 조회";
	manualPath = "/img/manual/vendor/organVendorUserList.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;" method="post">
	<input type="hidden" id="belongBorgId" name="belongBorgId"/>
	<input type="hidden" id="belongSvcTypeCd" name="belongSvcTypeCd"/>
	<input type="hidden" id="moveUserId" name="moveUserId"/>
	
	<input type="hidden" id="adminUserId" name="adminUserId"/>
	<input type="hidden" id="adminBorgId" name="adminBorgId"/>
	<input type="hidden" id="adminBorgNm" name="adminBorgNm"/>
	<input type="hidden" id="adminSvcTypeCd" name="adminSvcTypeCd"/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="25" class='ptitle'>공급사 사용자 조회
							<%if(isVendor){ %>
								&nbsp;<span id="question" class="questionButton">도움말</span>
							<%} %>
							</td>
							<td align="right" class='ptitle'>
								<button id='srcVendorButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 공급사 조회</button>
                                <button id='excelAll' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
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
							<td class="table_td_subject" width="100">공급사</td>
							<td colspan="3" class="table_td_contents">
								<input id="srcVendorName" name="srcVendorName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
								<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
								<input id="authMode" name="authMode" type="hidden" value="" />
								<a href="#">
								<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
								</a>
							</td>
							<td class="table_td_subject" width="100">사용자명</td>
							<td class="table_td_contents">
							<input id="srcUserNm" name="srcUserNm" type="text" value="" size="20" maxlength="50" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">사용자ID</td>
							<td colspan="3" class="table_td_contents">
								<input id="srcLoginId" name="srcLoginId" type="text" size="20" maxlength="50" /></td>
							<td class="table_td_subject" width="100">상태</td>
							<td class="table_td_contents">
								<select id="srcIsUse" name="srcIsUse" class="select"> 
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
<%	if("ADM".equals(loginUserDto.getSvcTypeCd()) && "SKTS2015".equals(loginUserDto.getLoginId()) == false){ %> <%--2015.08.06 SKTS2015 ID 접속시 로그인 버튼이 안보이도록 처리 --%>					
					<button id='loginButton' class="btn btn-warning btn-xs" ><i class="fa fa-key"></i> 로그인</button>
<%	} %>					
					<button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-search"></i> 등록</button>
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
</form>
</body>
</html>