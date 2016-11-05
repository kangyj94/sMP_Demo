<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");

	LoginUserDto loginUserDto        = CommonUtils.getLoginUserDto(request);
	String       categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "";
	String       _menuId             = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String       listHeight          = "$(window).height()- 380 + Number(gridHeightResizePlus)";
	String       listWidth           = "1500";
	String       srcOrderStartDate   = CommonUtils.getCustomDay("DAY", -7);
	String       srcOrderEndDate     = CommonUtils.getCurrentDate();
	boolean      isAdm               = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false ;
	boolean      isClient            = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
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
	String                _srcGroupId            = "";
	String                _srcClientId           = "";
	String                _srcBranchId           = "";
	String                _srcBorgNms            = "";
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
	if("BUY".equals(loginUserDto.getSvcTypeCd()) || "VEN".equals(loginUserDto.getSvcTypeCd())) {
%>
	$("#srcBorgName").attr("disabled", true);
	$("#btnBuyBorg").css("display","none");
<%
	}
%>
	$("#btnBuyBorg").click(function(){
		var borgNm = $("#srcBorgName").val();
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
	
	$("#srcBorgName").keydown(function(e){
		if(e.keyCode == 13){
			$("#btnBuyBorg").click();
		}
	});
	
	$("#srcBorgName").change(function(e){
		if($("#srcBorgName").val() == "") {
			$("#srcGroupId").val("");
			$("#srcClientId").val("");
			$("#srcBranchId").val("");
		}
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
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnUser").click(function(){
		var userNm = $("#srcOrderUserName").val();
		var loginId = "";
		var svcTypeCd = "BUY";
		fnJqmUserInitSearch(userNm, loginId, svcTypeCd, "fnSelectUserCallback");
	});
	
	$("#srcOrderUserName").keydown(function(e){
		if(e.keyCode == 13){
			$("#btnUser").click();
		}
	});
	
	$("#srcOrderUserName").change(function(e){
		if($("#srcOrderUserName").val()=="") {
			$("#srcOrderUserId").val("");
		}
	});
});
/**
 * 사용자검색 Callback Function
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#srcOrderUserName").val(userNm);
	$("#srcOrderUserId").val(userId);
}
</script>
<% //------------------------------------------------------------------------------ %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;

$(document).ready(function() {
	fnInitEvent();
	fnInitDatepicker();
	fnInitGrid();
});

function fnInitDatepicker(){
	$("#srcOrderStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("#srcOrderEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	
	$("#srcOrderStartDate").val("<%=srcOrderStartDate%>");
	$("#srcOrderEndDate").val("<%=srcOrderEndDate%>");
}

function fnInitEvent(){
	$("#srcOrderNumber").keydown(function(e){
		if(e.keyCode == 13){
			$("#srcButton").click();
		}
	});
	
	$("#srcConsIdenName").keydown(function(e){
		if(e.keyCode == 13){
			$("#srcButton").click();
		}
	});
	
	$("#srcButton").click(function(){ 
		$("#srcOrderNumber").val($.trim($("#srcOrderNumber").val()));
		$("#srcConsIdenName").val($.trim($("#srcConsIdenName").val()));
		$("#srcOrderStartDate").val($.trim($("#srcOrderStartDate").val()));
		$("#srcOrderEndDate").val($.trim($("#srcOrderEndDate").val()));
		$("#srcWorkInfoUser").val($.trim($("#srcWorkInfoUser").val()));
		
		fnSearch(); 
	});
	
	$("#question").click(function(){
		branchManual();
	});	//메뉴얼호출
}

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
	$("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  

function fnInitGrid() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderListProgressJQGrid.sys', 
		datatype: 'json',
		mtype : 'POST',
		colNames:[
			'주문번호',	'상품명',	'상품코드',	'규격','수량',		'구매사',
			'공급사',	'고객유형',	'주문일',	//'주문의뢰일',	
			'주문접수일',
			'취소요청일',	'배송일',	'인수일',	'주문취소일',	'중지일',
			'반품일','비고'
		],
		colModel:[
			{name:'ordeIdenNumb',  index:'ordeIdenNumb',  width:110, align:"center", search:false, sortable:false, editable:false }, //주문번호
			{name:'goodName',      index:'goodName',      width:165, align:"left",   search:false, sortable:false, editable:false }, //상품명
			{name:'goodIdenNumb',  index:'goodIdenNumb',  hidden:true }, //상품코드
			{name:'goodSpec',      index:'goodSpec',      width:165, align:"left",   search:false, sortable:false, editable:false }, //규격
			{name:'quantity',      index:'quantity',      width:40, align:"right",sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } 
			}, //수량
			{name:'branchNm',      index:'branchNm',      width:100, align:"left",   search:false, sortable:false, editable:false }, //구매사
			
			{name:'vendorNm',      index:'vendorNm',      width:100, align:"left",   search:false, sortable:false, editable:false }, //공급사
			{name:'workNm',        index:'workNm',        width:80,  align:"left",   search:false, sortable:false, editable:false }, //고객유형
			{name:'regiDateTime',  index:'regiDateTime',  width:65,  align:"center", search:false, sortable:false, editable:false, formatter:fnGridFormatter }, //주문일
// 			{name:'clinDate',      index:'clinDate',      width:65,  align:"center", search:false, sortable:false, editable:false, formatter:fnGridFormatter }, //주문의뢰일
			{name:'purcReceDate',  index:'purcReceDate',  width:65,  align:"center", search:false, sortable:false, editable:false, formatter:fnGridFormatter }, //주문접수일
			
			{name:'cancelReqDate', index:'cancelReqDate', hidden:true }, //취소요청일
			{name:'deliDegrDate',  index:'deliDegrDate',  width:65,  align:"center", search:false, sortable:false, editable:false, formatter:fnGridFormatter }, //배송일
			{name:'purcProcDate',  index:'purcProcDate',  width:65,  align:"center", search:false, sortable:false, editable:false, formatter:fnGridFormatter }, //인수일
			{name:'cancelDate',    index:'cancelDate',    width:65,  align:"center", search:false, sortable:false, editable:false, formatter:fnGridFormatter }, //주문취소일
			{name:'stopDate',      index:'stopDate',      width:65,  align:"center", search:false, sortable:false, editable:false, formatter:fnGridFormatter }, //중지일
			
			{name:'returnDate',    index:'returnDate',    width:65,  align:"center", search:false, sortable:false, editable:false, formatter:fnGridFormatter }, //반품일
			
			{name:'addRepreSequNumb',  index:'addRepreSequNumb',  width:110, align:"center", search:false, sortable:false, editable:false }, //비고
			
		],
		postData : {
			srcGroupId        : $("#srcGroupId").val(),
			srcClientId       : $("#srcClientId").val(),
			srcBranchId       : $("#srcBranchId").val(),
			srcOrderUserId    : $("#srcOrderUserId").val(),
			srcOrderStartDate : $("#srcOrderStartDate").val(),
			srcOrderEndDate   : $("#srcOrderEndDate").val(),
			srcOrderType      : $("#srcOrderType").val()
<%
	if(isAdm){
%>
			,srcWorkInfoUser  : $('#srcWorkInfoUser').val()
<%
	}
%>
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'regiDateTime', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
		loadComplete: function(){},
		onSelectRow: function(rowid, iRow, iCol, e){},
		ondblClickRow: function (rowid, iRow, iCol, e){},
		afterInsertRow: function(rowid, aData){
			fnGridAfterInsertRow(rowid, aData);
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			fnGridOnCellSelect(rowid, iCol, cellcontent, target);
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}

function fnGridOnCellSelect(rowid, iCol, cellcontent, target){
	var cm      = $("#list").jqGrid("getGridParam", "colModel");
	var colName = cm[iCol];
	
	if(colName != undefined && (colName['index'] == "ordeIdenNumb" || colName['index'] == "addRepreSequNumb")) {
		if(cellcontent!='' && cellcontent!='&nbsp;') {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%>
		}
	}
}

function fnSearch() {
	var data = jq("#list").jqGrid("getGridParam", "postData");
	
	data.srcOrderNumber    = $("#srcOrderNumber").val();
	data.srcGroupId        = $("#srcGroupId").val();
	data.srcClientId       = $("#srcClientId").val();
	data.srcBranchId       = $("#srcBranchId").val();
	data.srcOrderUserId    = $("#srcOrderUserId").val();
	data.srcConsIdenName   = $("#srcConsIdenName").val();
	data.srcOrderStartDate = $("#srcOrderStartDate").val();
	data.srcOrderEndDate   = $("#srcOrderEndDate").val();
	data.srcWorkInfoUser   = $("#srcWorkInfoUser").val();
	data.srcOrderType      = $("#srcOrderType").val();
	
	jq("#list").jqGrid("setGridParam", {"page":1});
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function fnGridFormatter(cellValue, options, rowObject, colName){
	if(cellValue == undefined){
		cellValue = "";
	}
	
	if(cellValue != ""){
		cellValue = "<font style=\"font-size: 8pt;\">" + cellValue + "</font>";
	}
	
	return cellValue;
}

function fnNvl(target){
	if(target == undefined){
		target = "";
	}
	
	if(target == null){
		target = "";
	}
	
	target = $.trim(target);
	
	return target;
}

function fnGridAfterInsertRow(rowid, aData){
	var regiDateTime = fnNvl(aData.regiDateTime);
	var clinDate     = fnNvl(aData.clinDate);
	var purcReceDate = fnNvl(aData.purcReceDate);
	var deliDegrDate = fnNvl(aData.deliDegrDate);
	var purcProcDate = fnNvl(aData.purcProcDate);
	var cancelDate   = fnNvl(aData.cancelDate);
	var stopDate     = fnNvl(aData.stopDate);
	var returnDate   = fnNvl(aData.returnDate);
	
	if(regiDateTime != ""){
		$('#list').setCell(rowid, 'regiDateTime', '', {'background-color': 'LemonChiffon'}, '');
	}
	
	if(clinDate != ""){
		$('#list').setCell(rowid, 'clinDate', '', {'background-color': 'LemonChiffon'}, '');
	}
	
	if(purcReceDate != ""){
		$('#list').setCell(rowid, 'purcReceDate', '', {'background-color': 'LemonChiffon'}, '');
	}
	
	if(deliDegrDate != ""){
		$('#list').setCell(rowid, 'deliDegrDate', '', {'background-color': 'LemonChiffon'}, '');
	}
	
	if(purcProcDate != ""){
		$('#list').setCell(rowid, 'purcProcDate', '', {'background-color': 'LemonChiffon'}, '');
	}
	
	if(cancelDate != ""){
		$('#list').setCell(rowid, 'cancelDate', '', {'background-color': 'LemonChiffon'}, '');
	}
	
	if(stopDate != ""){
		$('#list').setCell(rowid, 'stopDate', '', {'background-color': 'LemonChiffon'}, '');
	}
	
	if(returnDate != ""){
		$('#list').setCell(rowid, 'returnDate', '', {'background-color': 'LemonChiffon'}, '');
	}
	
	$("#list").setCell(rowid, 'ordeIdenNumb', '', {color:'#0000ff', cursor: 'pointer'});
	$("#list").setCell(rowid, 'addRepreSequNumb', '', {color:'#0000ff', cursor: 'pointer'});
}

function branchManual(){
	var header = "";
	var manualPath = "";
	//주문진척도/공급사확인
	header = "주문진척도/공급사확인";
	manualPath = "/img/manual/branch/orderListProgress.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
	<table width="1500px" style="margin: 0px;" border="0" cellspacing="0" cellpadding="0">
		<tr>  
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
						</td>
						<td height="29" class='ptitle'>
<%
	if(isAdm){
%>
							주문진척도
<%
	}
	else{
%>
							주문진척도/공급사확인
<%
		if(isClient){
%>
							&nbsp;<span id="question" class="questionButton">도움말</span>
<%
		}
	}
%>
						</td>
						<td align="right" class='ptitle'>
							<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>&nbsp;
						</td>
					</tr>
				</table> 
			</td>
		</tr>
		<tr><td height="1"></td></tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="1500px" style="margin: 0px;" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="100px" />
						<col width="400px" />
						<col width="100px" />
						<col width="400px" />
						<col width="100px" />
						<col width="400px" />
					</colgroup>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td width="100" class="table_td_subject" width="100">주문번호</td>
						<td class="table_td_contents">
							<input id="srcOrderNumber" name="srcOrderNumber" type="text" value="" size="" maxlength="50" style="width:200px" /></td>
						<td width="100" class="table_td_subject">구매사</td>
						<td class="table_td_contents">
							<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 300px" />
							<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
							<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
							<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
								<a href="#">
									<img id="btnBuyBorg" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border: 0px;" />
								</a>
						</td>
						<td width="100" class="table_td_subject">주문명</td>
						<td class="table_td_contents">
							<input id="srcConsIdenName" name="srcConsIdenName" type="text" value="" size="20" maxlength="30" style="width: 200px" />
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td width="100" class="table_td_subject">주문일</td>
						<td class="table_td_contents">
							<input type="text" name="srcOrderStartDate" id="srcOrderStartDate" style="width: 75px;vertical-align: middle;" /> 
							~ 
							<input type="text" name="srcOrderEndDate" id="srcOrderEndDate" style="width: 75px;vertical-align: middle;" />
						</td>
                        <td width="100" class="table_td_subject">주문자</td>
                        <td class="table_td_contents">
<%	
	if(_srcBorgScopeByRoleDto != null) {
		List<UserDto> _srcUserList = _srcBorgScopeByRoleDto.getSrcUserList();
%>
                        	<select id="srcOrderUserId" name="srcOrderUserId" class="select">
<%		
		if(Integer.parseInt(_srcBorgScopeByRoleDto.getBorgScopeCd()) != 1000) {
%>
      							<option value="">전체</option>
<%
		}

		for(UserDto userDto:_srcUserList) {
			String _selected = "";
			
			if(loginUserDto.getUserId().equals(userDto.getUserId())){
				_selected="selected";
			}
%>
      							<option value="<%=userDto.getUserId() %>" <%=_selected %>><%=userDto.getUserNm() %></option>
<%
		}
%>
                        	</select>
<%
	}
	else{
%>
                           <input id="srcOrderUserName" name="srcOrderUserName" type="text" value="" size="20" maxlength="30" style="width: 300px" />
                           <input id="srcOrderUserId" name="srcOrderUserId" type="hidden" value="" size="20" maxlength="30" style="width: 100px" />
                           <a href="#">
                           <img id="btnUser" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
                           </a>
<%
	}
%>
                        </td>
<%
	if(isAdm){
%>                  
                     <td class="table_td_subject" width="100">담당자</td>
                     <td class="table_td_contents" colspan="5">
                        <select id="srcWorkInfoUser" name="srcWorkInfoUser" class="select">
                           <option value="">전체</option>
<% 	
		if(isAdm && workInfoList != null){
			if (workInfoList.size() > 0 ) {
				SmpUsersDto sud = null;
				
				for (int i = 0; i < workInfoList.size(); i++) {
					sud = workInfoList.get(i); 
					String _selected = "";
					
					if(loginUserDto.getUserId().equals(sud.getUserId())){
						_selected="selected";
					}
%>
                           <option value="<%=sud.getUserId()%>" <%=_selected %>><%=sud.getUserNm()%></option>
<%
				}
			}
		}
%>
                        </select>
                     </td>
<%
	}
%>                  
                    </tr>
                    <tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
                    <tr>
						<td width="100" class="table_td_subject" width="100">주문유형</td>
						<td class="table_td_contents" colspan="5">
							<select id="srcOrderType" name="srcOrderType" class="select">
								<option value="">전체</option>
								<option value="add">추가주문</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table> 
			</td>
		</tr>
		<tr><td height="10"></td></tr>
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list"></table>
					<div id="pager"></div>
				</div>
			</td>
		</tr>
	</table>
</form>
</body>
</html>