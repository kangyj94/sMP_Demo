<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-300 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String inputVendorNmType = "";
	String vendorNm = "";
	
	vendorNm = userDto.getBorgNm();
	inputVendorNmType = "disabled='disabled'";
	
	

	String _menuId = request.getParameter("_menuId")==null ? "" : (String)request.getParameter("_menuId");
	if("".equals(_menuId)) _menuId = request.getAttribute("_menuId")==null ? "" : (String)request.getAttribute("_menuId");
	
	String businessNum = "";
	if(userDto.getSmpVendorsDto() != null)	businessNum = CommonUtils.getString(userDto.getSmpVendorsDto().getBusinessNum());	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#divGnb").mouseout(function () {
		$("#snb_vdr").hide();
	});
	$("#snb_vdr").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#snb_vdr").mouseout(function () {
		$("#snb_vdr").hide();
	});
});
</script>



<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>


<body class="subBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
  	<!-- /header -->
    <hr>
		<div id="divBody">
        	<div id="divSub">
            	<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
            	<!--카테고리(S)-->
			
				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<form id="frm" name="frm" onsubmit="return false;">
						<input type="hidden" id="belongBorgId" name="belongBorgId"/>
						<input type="hidden" id="belongSvcTypeCd" name="belongSvcTypeCd"/>
						<input type="hidden" id="moveUserId" name="moveUserId"/>
						<input type="hidden" id="adminUserId" name="adminUserId"/>
						<input type="hidden" id="adminBorgId" name="adminBorgId"/>
						<input type="hidden" id="adminBorgNm" name="adminBorgNm"/>
						<input type="hidden" id="adminSvcTypeCd" name="adminSvcTypeCd"/>
						<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
						<input id="authMode" name="authMode" type="hidden" value="" />
					<ul class="Tabarea">
						<li class="on">사용자관리</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;">
						<a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a>
					</div>
					<table class="InputTable">
						<colgroup>
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
							<col width="100px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>사용자명</th>
							<td>
								<input id="srcUserNm" name="srcUserNm" type="text" size="20" maxlength="50" />
							</td>
							<th>사용자ID</th>
							<td>
								<input id="srcLoginId" name="srcLoginId" type="text" size="20" maxlength="50" />
							</td>
							<th>상태</th>
							<td>
								<select id="srcIsUse" name="srcIsUse" class="select"> 
									<option value="1">정상</option>
									<option value="0">종료</option>
									<option value="">전체</option>
								</select>	 
							</td>
						</tr>
					</table>
				
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						
							<tr>
								<td bgcolor="#FFFFFF">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr><td style="height: 5px;"></td></tr>
										<tr>
											<td align="right">
												<button id='regButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
											</td>
										</tr>
										<tr><td style="height: 5px;"></td></tr>
										<tr>
											<td>
												<div id="jqgrid">
													<table id="list"></table>
													<div id="pager"></div>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table> 
					</form>	
					<div style="height:10px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>

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
	authStep = fnGetIsExistPublishAuth('<%=userDto.getSvcTypeCd()%>','<%=userDto.getBorgId()%>');
	fnAuthBusinessNumberDialog("VEN", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=userDto.getBorgId()%>');
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
<script type="text/javascript">
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


<!-- 공급사검색관련 스크립트 -->
<script type="text/javascript">
var jq = $;
$(document).ready(function(){
<%
	String _srcVendorId = "";
	String _srcVendorName = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;

	_srcBorgScopeByRoleDto = userDto.getSrcBorgScopeByRoleDto();
	_srcVendorId = _srcBorgScopeByRoleDto.getSrcBranchId();
	_srcVendorName = _srcBorgScopeByRoleDto.getSrcBorgNms();

%>
	$("#srcVendorName").val("<%=_srcVendorName %>");
	$("#srcVendorId").val("<%=_srcVendorId %>");
	$("#srcVendorName").attr("disabled", true);
	$("#btnVendor").css("display","none");
	$("#srcButton").click( function() { 
		$("#srcLoginId").val($.trim($("#srcLoginId").val()));
		$("#srcUserNm").val($.trim($("#srcUserNm").val()));
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
	
	$("#regButton").click( function() {
		//addUser();
		$("#authMode").val("A");
		fnAuth();
	});	
});

jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/venOrgan/organVenUserListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			'사업장명',	'소재지',	'사용자명',	'사용자ID',		'사용자상태',
			'공급사상태',	'로그인여부',	'전화번호',	'이동전화번호',	'Email발송',
			'SMS발송',	'등록일',	'userId',	'borgId',		'isUseCd'
		],
		colModel:[
			{name:'vendorNm',   index:'vendorNm',   hidden:true},	//공급사
			{name:'areaTypeNm', index:'areaTypeNm', hidden:true},	//소재지
			{name:'userNm',     index:'userNm',     width:110, align:"center", search:false, sortable:true, editable:false},	//사용자명.
			{name:'loginId',    index:'loginId',    width:140, align:"center", search:false, sortable:true, editable:false},	//사용자ID
			{name:'isUse',      index:'isUse',      width:110, align:"center", search:false, sortable:true, editable:false},	//사용자상태
			
			{name:'borg_IsUse', index:'borg_IsUse', hidden:true},	//공급사상태
			{name:'isLogin',    index:'isLogin',    hidden:true},	//로그인여부
			{name:'tel',        index:'tel',        width:130, align:"center", search:false,  sortable:true,  editable:false},	//전화번호
			{name:'mobile',     index:'mobile',     width:130, align:"center", search:false,  sortable:true,  editable:false},	//이동전화번호
			{name:'isEmail',    index:'isEmail',    width:110, align:"center", sortable:true, editable:false, edittype:"select", formatter:"select", editoptions:{value:"1:발송;0:미발송"}},	//EMAIL발송
			
			{name:'isSms',      index:'isSms',      width:110, align:"center", sortable:true, editable:false, edittype:"select", formatter:"select", editoptions:{value:"1:발송;0:미발송"}},	//SMS발송
			{name:'createDate', index:'createDate', width:100, align:"center", search:false,  sortable:true,  editable:false},	//등록일
			{name:'userId',index:'userId', hidden:true},	//userId
			{name:'borgId',index:'borgId', hidden:true},	//borgId
			{name:'isUseCd',index:'isUseCd', hidden:true}
		],
		postData: {
			srcVendorId:$("#srcVendorId").val(),
			srcUserNm:$("#srcUserNm").val(),
			srcLoginId:$("#srcLoginId").val(),
			srcIsUse:$("#srcIsUse").val()
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 425,autowidth: true,
		sortname: 'userId', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			FnUpdatePagerIcons(this);
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
			$("#belongBorgId").val(belongBorgId);
			$("#belongSvcTypeCd").val(belongSvcTypeCd);
			$("#moveUserId").val(moveUserId);			
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){
		<%if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
			jq("#list").setSelection(rowid);  
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="userNm") {
				$("#authMode").val("D");
				fnAuth();
            }
		<%} %>
		},
		afterInsertRow: function(rowid, aData){
		<% if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
			jq("#list").setCell(rowid,'userNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'userNm','',{cursor: 'pointer'});    
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

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorId = $("#srcVendorId").val();
	data.srcUserNm = $("#srcUserNm").val();
	data.srcLoginId = $("#srcLoginId").val();
	data.srcIsUse = $("#srcIsUse").val();
	jq("#list").jqGrid("setGridParam", { postData: data , datatype:"json" });
	jq("#list").trigger("reloadGrid");
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/selectVendorUserDetail.sys?borgId=" + selrowContent.borgId + "&userId=" + selrowContent.userId + "&_menuId=<%=_menuId %>";
		var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=600, height=415, scrollbars=yes, status=no, resizable=yes');
// 	    fnSearch();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function addUser(){
	var popurl = "/organ/organVendorUserReg.sys?_menuId=<%=_menuId %>";
	var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);
    window.open(popurl, 'okplazaPop', 'width=600, height=400, scrollbars=yes, status=no, resizable=yes');
    //fnSearch();
}

</script>
</html>