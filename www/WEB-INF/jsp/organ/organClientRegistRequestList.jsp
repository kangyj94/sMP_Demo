<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-320 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	
	//String srcRegisterCd = request.getAttribute("srcRegisterCd") == null ? "10" : (String)request.getAttribute("srcRegisterCd");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String menuCd = (String)request.getAttribute("menuCd");

	String srcRegisterCd	= "";
	String title			= "";
	
	if("ADM_ORGAN_REGI_REQST".equals(menuCd)){
		srcRegisterCd = "10";
		title = "구매사 등록요청";
	}else if("ADM_ORGAN_CONF_REQ".equals(menuCd)){
		srcRegisterCd = "20";//구매사 승인요청
		title = "구매사 승인요청";
	}else if("ADM_ORGAN_APRV_CLT".equals(menuCd)){
		srcRegisterCd = "30";//구매사 승인
		title = "구매사 승인";
	}
	
	// 2016-03-09  구매사 등록요청 조회 조건 : 상태 전체 --> 등록요청 
	boolean isExistSrcFlag = false;
	try{
		isExistSrcFlag	=	Boolean.parseBoolean(CommonUtils.getString(request.getParameter("srcFlag")));
	}catch(Exception e){
		isExistSrcFlag 	= false;
	}
	if(isExistSrcFlag){
		srcRegisterCd	= "10";
	}
	
	// 2016-05-04 상태검색조건 변경(이희택 팀장 : 승인 요청, 정기홍상무, 파워유저권한 : 1차 승인)
	if("301017".equals(userInfoDto.getUserId())){
		srcRegisterCd = "20";
	}
	else if("300550".equals(userInfoDto.getUserId()) && "MRO_ADMIN002".equals(userInfoDto.getLoginRoleList().get(0).getRoleCd())){
		srcRegisterCd = "30";
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(	//조회조건의 상태
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"REQ_BORG_TYPE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcRegisterCd").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			$("#srcRegisterCd").val('<%=srcRegisterCd%>');
		}
	);	

	$("#srcClientNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { fnClientSearch(); });
	$("#modButton").click( function() { onDetail(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	
	
	
    $("#srcClientNm").keydown(function(key){ if(key.keyCode == 13){ $("#srcButton").click(); } });
    $("#srcRegisterCd").change(function(){ $("#srcButton").click(); });
    $("#srcWorkId").change(function(){ $("#srcButton").click(); });
    $("#srcAccUser").change(function(){ $("#srcButton").click(); });
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(1500);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">

jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organClientRegistRequestListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			'branchId',		'clientId',	'법인명',		'사업자등록번호',	'고객유형',
			'채권담당자',		'권역',		'대표전화번호',	'대표자명',		'우편번호',
			'주소',			'상태',		'요청일',		'1차승인일',		'최종승인일',
			'승인일(등록일)'
		],
		colModel:[
			{name:'branchId',     index:'branchId',     width:120, align:"left",   search:false, sortable:false,  editable:false, hidden:true },
			{name:'clientId',     index:'clientId',     width:120, align:"left",   search:false, sortable:false,  editable:false, hidden:true },
			{name:'clientNm',     index:'clientNm',     width:180, align:"left",   search:false, sortable:false,  editable:false },
			{name:'businessNum',  index:'businessNum',  width:80,  align:"center", search:false, sortable:false,  editable:false },
			{name:'workNm',       index:'workNm',       width:140, align:"center", search:false, sortable:false,  editable:false },
			
			{name:'userNm',       index:'userNm',       width:60,  align:"center", search:false, sortable:false,  editable:false },
			{name:'areaType',     index:'areaType',     width:60,  align:"center", search:false, sortable:false,  editable:false },
			{name:'phoneNum',     index:'phoneNum',     width:90,  align:"left",   search:false, sortable:false,  editable:false },
			{name:'pressentNm',   index:'pressentNm',   width:60,  align:"center", search:false, sortable:false,  editable:false, hidden:true},
			{name:'postAddrNum',  index:'postAddrNum',  width:60,  align:"center", search:false, sortable:false,  editable:false, hidden:true },
			
			{name:'addres',       index:'addres',       width:370, align:"left",   search:false, sortable:false,  editable:false },
			{name:'registerCd',   index:'registerCd',   width:70,  align:"center", search:false, sortable:false,  editable:false },
			{name:'registerDate', index:'registerDate', width:70,  align:"center", search:false, sorttype:"date", editable:false, formatter:"date" },
			{name:'checkDate',    index:'checkDate',    width:70,  align:"center", search:false, sorttype:"date", editable:false, formatter:"date" },
			{name:'appDate',      index:'registerDate', width:70,  align:"center", search:false, sorttype:"date", editable:false, formatter:"date" },
			
			{name:'confirDate',   index:'confirDate',   width:75,  align:"center", search:false, sorttype:"date", editable:false, formatter:"date", hidden:true}
		],
		postData: {srcRegisterCd:'<%=srcRegisterCd%>', srcWorkId:$("#srcWorkId").val(), srcAccUser:$("#srcAccUser").val()},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'a.registerDate', sortorder: "desc", //요청일 순서 수정(registerDate > a.registerDate)
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $(this).getGridParam('reccount');
			if(rowCnt > 0){
				for(var i=0; i<rowCnt; i++){
					var rowid = $(this).getDataIDs()[i];
 					var selrowContent = $(this).jqGrid('getRowData',rowid);
 					var phoneNum = selrowContent.phoneNum;
 					phoneNum = fnSetTelformat(phoneNum);
 					$(this).jqGrid('setRowData',rowid,{phoneNum:phoneNum});
				}
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['index']=="clientNm") { 
<%				if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
					jq("#list").setSelection(rowid);  
					onDetail();
<%				} %>
			}
		},
		afterInsertRow: function(rowid, aData){
<%			if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
				jq("#list").setCell(rowid,'clientNm','',{color:'#0000ff'}); 
				jq("#list").setCell(rowid,'clientNm','',{cursor: 'pointer'});  
				jq("#list").setCell(rowid,'clientNm','',{'text-decoration':'underline'});  
<%			} %>
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {phoneNum: fnSetTelformat(selrowContent.phoneNum)});
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
//개발시 삭제
function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organClientRegistRequestDetail.sys?branchId=" + selrowContent.branchId + "&clientId=" + selrowContent.clientId+"&_menuId=<%=_menuId %>";
		window.open(popurl, 'okplazaPop', 'width=920, height=700, scrollbars=yes, status=no, resizable=no');
// 	    fnClientSearch();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function fnClientSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcClientNm = $("#srcClientNm").val();
	data.srcRegisterCd = $("#srcRegisterCd").val(); 
	data.srcWorkId = $("#srcWorkId").val(); 
	data.srcAccUser = $("#srcAccUser").val(); 
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function exportExcel() {
	var colLabels = ['법인명','사업자등록번호','고객유형','채권담당자','권역','상태','대표전화번호', '대표자명', '우편번호', '주소', '요청일', '승인일(등록일)'];	//출력컬럼명
	var colIds = ['clientNm','businessNum','workNm','userNm','areaType','registerCd','phoneNum', 'pressentNm', 'postAddrNum', 'addres', 'registerDate', 'confirDate'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "법인 목록";	//sheet 타이틀
	var excelFileName = "RequestClientList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['법인명','사업자등록번호','고객유형','채권담당자','권역','상태','대표전화번호', '대표자명', '우편번호', '주소', '요청일', '승인일(등록일)'];	//출력컬럼명
	var colIds = ['clientNm','businessNum','workNm','userNm','areaType','registerCd','phoneNum', 'pressentNm', 'postAddrNum', 'addres', 'registerDate', 'confirDate'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "법인 목록";	//sheet 타이틀
	var excelFileName = "RequestClientList";	//file명
	
	var actionUrl = "/organ/organClientRegistRequestListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcClientNm';
	fieldSearchParamArray[1] = 'srcRegisterCd';
	fieldSearchParamArray[2] = 'srcAccUser';
	fieldSearchParamArray[3] = 'srcWorkId';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//리턴받은 사업장 아이디로 리스트 로우 삭제
function fnDeleteRow(rtuBranchId){
	var rtuBranchId = rtuBranchId;
	var rowCnt = $("#list").getGridParam('reccount');
	if(rowCnt > 0){
		for(var i=0; i<rowCnt; i++){
			var rowid = $("#list").getDataIDs()[i];
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			var branchId =  selrowContent.branchId;
			if(rtuBranchId == branchId){
				$("#list").delRowData(rowid);
			}
		}
	}
}

</script>

<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
		<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="1500px" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="25" class='ptitle'><%=title%></td>
							<td align="right" class='ptitle'>
<%-- 								<a href="#"> <img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /> </a> --%>
								<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
							</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr><td height="1"></td></tr>
			<tr>
				<td>
					<!-- 컨텐츠 시작 -->
					<table width="1500px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="8" class="table_top_line"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">법인명</td>
							<td class="table_td_contents">
								<input id="srcClientNm" name="srcClientNm" type="text" value="" size="" maxlength="50" style="width: 200px" onkeydown="return fnKeyDownSearch(event)" />
							</td>
							<td width="100" class="table_td_subject">상태</td>
							<td class="table_td_contents">
								<select id="srcRegisterCd" name="srcRegisterCd" class="select" > 
									<option value="">선택하세요</option> 
								</select>
							</td>
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
							<td width="80" class="table_td_subject">채권담당자</td>
							<td class="table_td_contents">
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
						</tr>
						<tr>
							<td colspan="8" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr>
				<td height="5"></td>
			</tr>
<!-- 			<tr> -->
<!-- 				<td align="right"> -->
<%-- 					<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
<%-- 					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
<!-- 				</td> -->
<!-- 			</tr> -->
			<tr>
				<td>
					<table width="1500px" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
						<col width="100%"/>
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
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>