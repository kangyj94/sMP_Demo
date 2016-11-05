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
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList             = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	LoginUserDto        userDto              = CommonUtils.getLoginUserDto(request);
	String              listHeight           = "$(window).height()-300 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String              _menuCd              = request.getParameter("_menuCd");
	String              businessNum          = CommonUtils.getString(userDto.getSmpBranchsDto().getBusinessNum());	
	Boolean             isContractExcludeClt = (Boolean)request.getAttribute("isContractExcludeClt");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
});
</script>

<style type="text/css">
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
.jqmPop {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -320px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
}
.jqmOverlay { background-color: #000; }

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


</style>

<body class="mainBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
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
							<th>고객사</th>
							<td>
								<span id="srcBorgName"></span>
<!-- 								<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 300px" disabled="disabled" /> -->
								<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
								<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
								<input id="authMode" name="authMode" type="hidden" value=""/>
							</td>
							<th>사용자명</th>
							<td>
								<input id="srcUserNm" name="srcUserNm" type="text" size="20" maxlength="50" />
							</td>
							<th>고객유형</th>
							<td>
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
							<th>사용자ID</th>
							<td>
								<input id="srcLoginId" name="srcLoginId" type="text" size="20" maxlength="50" />
							</td>
							<th>사용자상태</th>
							<td>
								<select id="srcIsUse" name="srcIsUse" class="select"> 
									<option value="1">정상</option>
									<option value="0">종료</option>
									<option value="">전체</option>
								</select>	 
							</td>
							<th>감독여부</th>
							<td>
								<select id="srcIsDirect" name="srcIsDirect" class="select"> 
									<option value="">전체</option>
									<option value="Y">예</option>
									<option value="N">아니요</option> 
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
					<div style="height:10px;">
					</div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
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
<%
	if(isContractExcludeClt == false){
%>
	//fnGetIsExistPublishAuth(svcTypeCd, borgId) - 현재 세션의 공인인증서 인증상태를 확인 (파라미터3 참조)
	authStep = fnGetIsExistPublishAuth('<%=userDto.getSvcTypeCd()%>','<%=userDto.getBorgId()%>');
	fnAuthBusinessNumberDialog("CLT", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=userDto.getClientId()%>');
<%
	}
	else{
%>
	if("A" == $.trim($("#authMode").val())){
		addUser();
	}
	else if("D" == $.trim($("#authMode").val())){
		onDetail();
	}
<%
	}
%>

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


<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$('form').on('submit',function(){ return false; });
	
<%
	String _srcGroupId = "";
	String _srcClientId = "";
	String _srcBorgNms = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;

	_srcBorgScopeByRoleDto = userDto.getSrcBorgScopeByRoleDto();
	_srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
	_srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
	_srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
// 	_srcBorgNms = _srcBorgNms.substring(0,_srcBorgNms.indexOf("&gt;") );
%>
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
<%-- 	$("#srcBorgName").val("<%=_srcBorgNms %>"); --%>
	$("#srcBorgName").html("<%=_srcBorgNms %>");

	$("#srcButton").click( function() { 
		$("#srcUserNm").val($.trim($("#srcUserNm").val()));
		$("#srcLoginId").val($.trim($("#srcLoginId").val()));
		fnSearch(); 
	});
	
	$("#regButton").click( function() {
		//addUser();
		$("#authMode").val("A");
		fnAuth();
	});

	$("#srcUserNm").on("keydown",function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
			return false;
		}
	});
	$("#srcLoginId").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
			return false;
		}
	});
	$("#srcIsUse").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
			return false;
		}
	});
	
	//컨퍼넌트 초기화 
	fnInitJqGridComponent();
});

</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
function fnInitJqGridComponent(){
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/buyOrgan/organBuyUserListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['borgId', '사업장명', '권역', '사용자명', '사용자ID', '사용자<br/>상태', '고객사<br/>상태','감독<br/>여부','고객유형', '로그인<br/>여부', '전화번호', '이동전화번호','Email<br/>발송','SMS<br/>발송', '등록일', 'userId', 'isUseCd'],
		colModel:[
			{name:'borgId',index:'borgId', hidden:true},	//고객사
			{name:'borgNm',index:'borgNm', width:235,align:"left"},	//고객사
			{name:'areaTypeNm',index:'areaTypeNm',hidden:true },	//권역
			{name:'userNm',index:'userNm', width:80,align:"center",search:false,sortable:true, 
				editable:false 
			},	//사용자명
			{name:'loginId',index:'loginId', width:80,align:"center",search:false,sortable:true,
				editable:false 
			},	//사용자ID
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:true,
				editable:false 
			},	//사용자상태
			{name:'borg_IsUse',index:'borg_IsUse', hidden:true},	//사업장상태
			{name:'isDirect',index:'isDirect', width:60,align:"center",search:false,sortable:true,
				editable:false 
			},	//감독여부
			{name:'workNm',index:'workNm', hidden:true},	//고객유형
			{name:'isLogin',index:'isLogin', width:50,align:"center",search:false,sortable:true,
				editable:false 
			},	//로그인여부
			{name:'tel',index:'tel', width:100,align:"center",search:false,sortable:true,
				editable:false 
			},	//전화번호
			{name:'mobile',index:'mobile', width:100,align:"center",search:false,sortable:true, 
				editable:false
			},	//이동전화번호
			{name:'isEmail',index:'isEmail', width:50,align:"center",sortable:true,
				editable:false,
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}
			},	//EMAIL발송
			{name:'isSms',index:'isSms', width:50,align:"center",sortable:true,
				editable:false,
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}
			},	//SMS발송
			{name:'createDate',index:'createDate', width:80,align:"center",search:false,sortable:true,
				editable:false 
			},	//등록일
			{name:'userId',index:'userId', hidden:true 
			},	//userId
			{name:'isUseCd',index:'isUseCd', hidden:true 
			}	//isUseCd
		],
		postData: {
			srcGroupId:$("#srcGroupId").val(),
			srcClientId:$("#srcClientId").val(),
			srcUserNm:$("#srcUserNm").val(),
			srcLoginId:$("#srcLoginId").val(),
			srcIsUse:$("#srcIsUse").val(),
			srcIsDirect:$("#srcIsDirect").val(),
			srcIsDirect:$("#srcWorkId").val()
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 425,autowidth: true,
		sortname: 'userId', sortorder: "desc",
// 		caption:"사용자 조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(){
			//FnUpdatePagerIcons(this);
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
		onSelectRow: function (rowid, iRow, iCol, e) {},
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
				$("#belongBorgId").val(belongBorgId);
				$("#belongSvcTypeCd").val(belongSvcTypeCd);
				$("#moveUserId").val(moveUserId);
				$("#authMode").val("D");
				fnAuth();
			}
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'userNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'userNm','',{cursor: 'pointer'});  
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
// 		gridview:true
	}); 
};

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcUserNm = $("#srcUserNm").val();
	data.srcLoginId = $("#srcLoginId").val();
	data.srcIsUse = $("#srcIsUse").val();
	data.srcIsDirect = $("#srcIsDirect").val();
	data.srcWorkId = $("#srcWorkId").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

function addUser(){
	var popurl = "/buyOrgan/organUserRegBuy.sys?_menuCd=<%=_menuCd %>";
	window.open(popurl, 'okplazaPop', 'width=600, height=520, scrollbars=yes, status=no, resizable=yes');
    //fnSearch();
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/buyOrgan/organUserDetailBuy.sys?borgId=" + selrowContent.borgId + "&userId=" + selrowContent.userId + "&_menuCd=<%=_menuCd %>";
	    window.open(popurl, 'okplazaPop', 'width=600, height=510, scrollbars=yes, status=no, resizable=yes');
// 	    fnSearch();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}
</script>

</html>