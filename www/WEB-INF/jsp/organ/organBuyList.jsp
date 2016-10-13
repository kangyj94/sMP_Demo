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
	@SuppressWarnings("unchecked")    
	List<ActivitiesDto> roleList             = (List<ActivitiesDto>)request.getAttribute("useActivityList"); //화면권한가져오기(필수)
	LoginUserDto        userDto              = CommonUtils.getLoginUserDto(request);
	String              listHeight           = "$(window).height()-260 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String              _menuId              = CommonUtils.getRequestMenuId(request);
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
					<ul class="Tabarea">
						<li class="on">사업장관리</li>
					</ul>
						
					<input id="srcBorgName" name="srcBorgName" type="hidden" value="" />
					<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
					<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
					<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
					<input id="authMode" name="authMode" type="hidden" value=""/>
					
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
							<th>회원사등급</th>
							<td>
								<select id="srcBranchGrad" name="srcBranchGrad"> 
									<option value="">전체</option> 
								</select>
							</td>
							<th>권역</th>
							<td>
								<select id="srcAreaType" name="srcAreaType"> 
									<option value="">전체</option> 
								</select>
							</td>
							<th>상태</th>
							<td>
								<select id="srcIsUse" name="srcIsUse"> 
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
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
	<form id="ebillPopFrm" name="ebillPopFrm" onsubmit="return false;">
		<input id="pubCode" name="pubCode" type="hidden"/>
		<input id="docType" name="docType" type="hidden" value="T"/>
		<input id="userType" name="userType" type="hidden" value="R"/>
	</form>
</body>


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
		addRow();
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
			addRow();
		}
		else if("D" == $.trim($("#authMode").val())){
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

<script type="text/javascript">
$(document).ready(function(){
<%
	String _srcGroupId = "";
	String _srcClientId = "";
	String _srcBranchId = "";
	String _srcBorgNms = "";
	SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
	_srcBorgScopeByRoleDto = userDto.getSrcBorgScopeByRoleDto();
	_srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
	_srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
	_srcBranchId = _srcBorgScopeByRoleDto.getSrcBranchId();
	_srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
	_srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
	
%>
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
	$("#srcBranchId").val("<%=_srcBranchId %>");
	$("#srcBorgName").val("<%=_srcBorgNms %>");
	

});

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
	$("#regButton").click(function(){ 
		$("#authMode").val("A");
		fnAuth(); 
	});
});
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/buyOrgan/organBuyListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['업체코드', '사업장명', '사업자등록번호', '고객유형', '채권<br/>담당자','법인사용/<br>주문제한 여부','주문제한<br/>여부', '권역', '회원사<br/>등급', '상태', '선입금<br/>여부',
		          '대표전화번호', '대표자명', '우편번호', '주소','상세주소','회사샵(#)메일', '등록일', 'branchId','clientId'],
		colModel:[
			{name:'branchCd',index:'branchCd', width:80,align:"center",hidden:true},						//업체코드
			{name:'branchNm',index:'branchNm', width:195,align:"left"},						//사업자명
			{name:'businessNum',index:'businessNum', width:100,align:"center"},				//사업자등록번호
			{name:'workNm',index:'workNm', width:130,align:"center"},							//고객유형
			{name:'userNm',index:'userNm', width:65,align:"center"},							//채권담당자
			{name:'clientStatus',index:'clientStatus', width:100,align:"center"},			//법인사용/주문제한 여부
			{name:'isOrderLimit',index:'isOrderLimit', width:60,align:"center"},				//주문제한여부
			{name:'areaTypeNm',index:'areaTypeNm', width:40,align:"center"},					//권역
			{name:'branchGrad',index:'branchGrad', width:50,align:"center"},					//회원사등급
			{name:'isUse',index:'isUse', width:40,align:"center"},							//상태
			{name:'prePay',index:'prePay', width:60,align:"center"},							//선입금 여부
			{name:'phoneNum',index:'phoneNum', width:80,align:"center",hidden:true},			//대표전화번호
			{name:'pressentNm',index:'pressentNm', width:60,align:"center",hidden:true},		//대표자명
			{name:'postAddrNum',index:'postAddrNum', width:50,align:"center",hidden:true},	//우편번호
			{name:'addres',index:'addres', width:200,align:"left",hidden:true},				//주소
			{name:'addresDesc',index:'addresDesc', width:200,align:"left",hidden:true},		//상세주소
			{name:'sharp_mail',index:'sharp_mail', width:150,align:"left",hidden:true},		//회사샵메일
			{name:'createDate',index:'createDate', width:80,align:"center"},					//등록일
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
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 425, autowidth: true,
		sortname: 'branchId', sortorder: "desc", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,    //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			//FnUpdatePagerIcons(this);
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");  
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="branchNm") { 
				jq("#list").setSelection(rowid);  
				$("#authMode").val("D");
				fnAuth();
			}
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'branchNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'branchNm','',{cursor: 'pointer'});  
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
	data.srcPrePay = $("#srcPrePay").val();

	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/buyOrgan/organBuyDetail.sys?branchId=" + selrowContent.branchId + "&clientId=" + selrowContent.clientId+"&_menuId=<%=_menuId %>";
		window.open(popurl, 'okplazaPop', 'width=920, height=800, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }    
}

function addRow(){
	var popurl = "/buyOrgan/organBuyReg.sys?_menuId=<%=_menuId %>";
	window.open(popurl, 'okplazaPop', 'width=950, height=760, scrollbars=yes, status=no, resizable=no');
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


</html>