<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	int listWidth = 460;
	String listHeight = "$(window).height()-150 + Number(gridHeightResizePlus)";
	String list2Height = "$(window).height()-275 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!------------------------------- 다른조직 사용자 추가 ------------------------------->
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<script type="text/javascript">
$(function(){
	$('#dialogPop').jqm();	//Dialog 초기화
	$("#saveButton").click(function(){
		$('#dialogPop').jqmShow();	//필수
// 		fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString, clientId, clientNm);
		fnJqmUserInitSearch("", "", "", "fnSelectUserCallback", "", "");
	});
});

/**
 * 사용자검색 Callback Function(반드시 있어야 함)	//필수
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	var row = $("#treeList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		if(!confirm("선택한 사용자을 등록하시겠습니까?")) return;
		var selrowContent = $("#treeList").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/userTransGrid.sys", 
			{ oper:"addSys", svcTypeCd:"BUY", id:userId, borgId:selrowContent.borgId, loginId:loginId },
			function(arg){ 
				$('#dialogPop').jqmHide();
				if(fnAjaxTransResult(arg)) {	//성공시
					$("#list").trigger("reloadGrid");
				}
			}
		);
	} else {
		$('#dialogPop').jqmHide();
		$("#dialogSelectRow").dialog();
	}	
}
</script>


<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
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
	$("#srcButton").click(function(){
		$("#srcUserNm").val($.trim($("#srcUserNm").val()));
		$("#srcLoginId").val($.trim($("#srcLoginId").val()));
		
		fnSearch();
	});
	$("#regButton").click( function() { addRow(); });
	$("#modButton").click( function() { editRow(); });
	$("#delButton").click( function() { deleteRow(); });

	$("#viewButton").click( function() { viewRow(); });
	$("#colButton").click( function() { $("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
});
$(window).bind('resize', function() { 
	$("#treeList").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth($(window).width()-540 + Number(gridWidthResizePlus));
	$("#list").setGridHeight(<%=list2Height %>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var staticNum = 0;	//list 그리드를 한번만 초기화하기 위해
jq(function() {
	jq("#treeList").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/borgTreeJQGrid.sys',
		datatype: "json",
		mtype: "POST",
	   	colNames:["조직명","조직구분","조직코드","사용여부","treeKey","borgId","borgTypeCd","borgLevel","isLeaf"],
	   	colModel:[
	   		{name:'borgNm',index:'borgNm', width:230,sortable:false,editable:true},//조직명
	   		{name:'borgTypeNm',index:'borgTypeNm', width:70,align:"center",sortable:false},//조직구분
	   		{name:'borgCd',index:'borgCd', width:70,align:"center",sortable:false},//조직코드
	   		{name:'isUse',index:'isUse', width:50,align:"center",sortable:false,editable:true,edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}},//사용여부

	   		{name:'treeKey',index:'treeKey', hidden:true, key:true},//treeKey
	   		{name:'borgId',index:'borgId', hidden:true},//borgId
	   		{name:'borgTypeCd',index:'borgTypeCd', hidden:true},//borgTypeCd
	   		{name:'level',index:'level', hidden:true},//borgLevel
	   		{name:'isLeaf',index:'isLeaf', hidden:true}//isLeaf
	   	],
	   	rowNum:0, rownumbers: false, 
	   	treeGridModel:'adjacency',
	   	height:<%=listHeight%>, width:<%=listWidth%>,
	   	treeGrid: true, hoverrows: false,
		ExpandColumn : 'borgNm',ExpandColClick: true,
		caption: "조직조회",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		jsonReader : { root: "list", repeatitems: false, cell: "cell" },
		loadComplete: function() {
			if(staticNum==0) {
				var rowCnt = jq("#treeList").getGridParam('reccount');
				if(rowCnt>0) {
					var top_rowid = jq("#treeList").getDataIDs()[0];	//첫번째 로우 아이디 구하기
					setTimeout(function() {
						var recordInfo = jq("#treeList").getLocalRow(top_rowid);
						jq("#treeList").expandRow(recordInfo);
						jq("#treeList").expandNode(recordInfo);
					}, 10);
				}
			} else if(staticNum==1) {
				fnInitList('',0,false);
			}
			staticNum++;
			
			var rowIDs = jq("#treeList").getDataIDs(); 
			for (var i=0;i<rowIDs.length;i=i+1){ 
				var rowData=jq("#treeList").getRowData(rowIDs[i]);
				if(rowData.isUse=="0") {
					jq("#treeList").setCell(rowIDs[i],'borgNm','',{color:'red'});
					jq("#treeList").setCell(rowIDs[i],'borgTypeNm','',{color:'red'});
					jq("#treeList").setCell(rowIDs[i],'borgCd','',{color:'red'});
					jq("#treeList").setCell(rowIDs[i],'isUse','',{color:'red'});
				}
			}
		},
		loadError : function(xhr, st, str){ $("#treeList").html(xhr.responseText); },
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_SAVE","editRow();") %>
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#treeList").jqGrid('getRowData',rowid);
			var borgNmHtml = "<font color='blue'>"+selrowContent.borgNm+"</font>";
			$("#staticBorgNm").html(borgNmHtml);
			fnOnClickList(selrowContent.borgTypeCd, selrowContent.borgId, selrowContent.isLeaf);
			$('#saveButton').css("border", "none");
			if(selrowContent.borgTypeCd=="BCH") {
				$('#saveButton').attr("style", "display:");
			} else {
				$('#saveButton').attr("style", "display:none");
			}
		}
	});
});
function fnInitList(borgTypeCd, borgId, isLeaf) {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/borgUserListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['조직명','사용자명','사용자ID','사용권한','핸드폰','활성화여부','사용여부','전화번호','이메일','우편번호','주소','userId'],
		colModel:[
			{name:'borgNms',index:'borgNms', width:300,align:"left",sortable:true,formoptions:{rowpos:1}},//조직명
			{name:'userNm',index:'userNm', width:60,align:"left",sortable:true,formoptions:{rowpos:2}},//사용자명
			{name:'loginId',index:'loginId', width:80,align:"left",sortable:true,formoptions:{rowpos:3}},//사용자ID
			{name:'roleNms',index:'roleNms', width:200,align:"left",sortable:true,formoptions:{rowpos:4}},//사용권한
			{name:'mobile',index:'mobile', width:80,align:"left",sortable:true,formoptions:{rowpos:5}},//핸드폰
			{name:'isLogin',index:'isLogin', width:70,align:"center",sortable:true,formoptions:{rowpos:6},
				edittype:"select",formatter:"select",editoptions:{value:"1:활성;0:비활성"}},//활성화여부
			{name:'isUse',index:'isUse', width:70,align:"center",sortable:true,formoptions:{rowpos:7},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}},//사용여부
			{name:'tel',index:'tel', width:80,align:"left",sortable:true,formoptions:{rowpos:8}},//전화번호
			{name:'email',index:'email', width:120,align:"left",sortable:true,formoptions:{rowpos:9}},//이메일
			{name:'zipCode',index:'zipCode', width:60,align:"center",sortable:false,formoptions:{rowpos:10}},//우편번호
			{name:'address',index:'address', width:100,align:"left",sortable:false,formoptions:{rowpos:11}},//주소
			
			{name:'userId',index:'userId', hidden:true}//userId
		],
		postData: { svcTypeCd:'BUY',borgTypeCd:borgTypeCd, borgId:borgId, isLeaf:isLeaf },
		rowNum:30, rownumbers: true, rowList:[30,50,100,500,1000], pager: '#pager',
		height:<%=list2Height%>,width:$(window).width()-540 + Number(gridWidthResizePlus), 
		sortname: 'borgNms', sortorder: "asc",
		caption:"조직사용자 조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(data) {},
		afterInsertRow: function(rowid, aData){},
		onSelectRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnOnClickList(borgTypeCd, borgId, isLeaf) {
	jq("#list").jqGrid("setGridParam", {"page":1, "rows":30});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.svcTypeCd = 'BUY';
	data.borgTypeCd = borgTypeCd;
	data.borgId = borgId;
	data.isLeaf = isLeaf;
	data.srcUserNm = $("#srcUserNm").val();
	data.srcLoginId = $("#srcLoginId").val();
	data.srcIsLogin = $("#srcIsLogin").val();
	data.srcIsUse = $("#srcIsUse").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
function fnSearch() {
	var row = jq("#treeList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
		var borgTypeCd = selrowContent.borgTypeCd;
		var borgId = selrowContent.borgId;
		var isLeaf = selrowContent.isLeaf;
		fnOnClickList(borgTypeCd, borgId, isLeaf);
	} else { 
		fnOnClickList('',0,false);
	}
}

function addRow() {
	var row = jq("#treeList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
		var tmpLevel = Number(selrowContent.level);
		var addCaption = "";
		var topBorgId = 0;
		var borgTypeCd = "";
		var parBorgId = 0;
		var svcTypeCd = "BUY";
		var groupId = 0;
		var clientId = 0;
		var branchId = 0;
		var deptId = 0;
		var borgLevel = 0;
		if(tmpLevel==0) {
			addCaption = "그룹등록";
			borgTypeCd = "GRP";
			borgLevel = 1;
		} else if(tmpLevel==1) {
			addCaption = "법인등록";
			borgTypeCd = "CLT";
			topBorgId = selrowContent.borgId;
			parBorgId = selrowContent.borgId;
			groupId = selrowContent.borgId;
			borgLevel = 2;
		} else {
			alert("시스템의 조직관리는 그룹과 법인만 등록 및 수정이 가능합니다.");
			return;
		}
		jq("#treeList").jqGrid('setColProp', 'borgCd',{editable:true});
		jq("#treeList").jqGrid(
			'editGridRow', 'new',{
				addCaption: addCaption,
				url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/borgUserTransGrid.sys", 
				editData: {topBorgId:topBorgId, borgTypeCd:borgTypeCd, parBorgId:parBorgId, svcTypeCd:svcTypeCd,
					groupId:groupId, clientId:clientId, branchId:branchId, deptId:deptId, borgLevel:borgLevel},
				recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
				afterSubmit : function(response, postdata){
					if(fnJqTransResult(response, postdata)) {
						staticNum = 0;
					}
					return fnJqTransResult(response, postdata);
				}
			}
		);
		jq("#treeList").jqGrid('setColProp', 'borgCd',{editable:false});
	} else {
		alert("조직의 등록은 상위조직을 선택하셔야 합니다.");
	}
}
function editRow() {
	var row = jq("#treeList").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
  	if( row != null ){
  		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
  		var borgId = selrowContent.borgId;
		var tmpLevel = Number(selrowContent.level);
		var editCaption = "";
		if(tmpLevel==1) {
			editCaption = "그룹수정";
		} else if(tmpLevel==2) {
			editCaption = "법인수정";
		} else {
			alert("시스템의 조직관리는 그룹과 법인만 등록 및 수정이 가능합니다.");
			return;
		}
  		jq("#treeList").jqGrid(
  			'editGridRow', row,{ 
  				editCaption: editCaption,
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/borgUserTransGrid.sys",
  				editData: {borgId:borgId},
				recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
   				afterSubmit : function(response, postdata){ 
   					return fnJqTransResult(response, postdata);
				}
			}
  		);
  	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function deleteRow() {
	var row = jq("#treeList").jqGrid('getGridParam','selrow');
	if( row != null ) {
		var selrowContent = jq("#treeList").jqGrid('getRowData',row);
		var isLeaf = selrowContent.isLeaf;
		if(isLeaf=="false") {
			alert("하위조직이 존재하면 삭제가 불가합니다.");
			return;
		}
		var tmpLevel = Number(selrowContent.level);
		if(!(tmpLevel==1 || tmpLevel==2)) {
			alert("시스템의 조직관리는 그룹과 법인만 등록 및 수정이 가능합니다.");
			return;
		}
		jq("#treeList").jqGrid( 
			'delGridRow', row,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/borgUserTransGrid.sys",
				recreateForm: true,beforeShowForm: function(form) {
					jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
					jq('#pData').hide();jq('#nData').hide();  
				},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
				afterSubmit: function(response, postdata){
					if(fnJqTransResult(response, postdata)[0]) {
						window.location.reload(true);
					} else {
						alert(fnJqTransResult(response, postdata)[1]);
					}
				}
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"550", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['조직명','사용자명','사용자ID','사용권한','핸드폰','활성화여부','사용여부','전화번호','이메일','우편번호','주소'];	//출력컬럼명
	var colIds = ['borgNms','userNm','loginId','roleNms','mobile','isLogin','isUse','tel','email','zipCode','address'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = $("staticBorgNm").val()+" 사용자";	//sheet 타이틀
	var excelFileName = "BorgUserList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/**
 * 엑셀일괄 다운로드
 */
function exportExcelToSvc() {
	var colLabels = ['조직명','사용자명','사용자ID','사용권한','핸드폰','활성화여부','사용여부','전화번호','이메일','우편번호','주소'];	//출력컬럼명
	var colIds = ['borgNms','userNm','loginId','roleNms','mobile','isLogin','isUse','tel','email','zipCode','address'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = $("staticBorgNm").val()+" 사용자";	//sheet 타이틀
	var excelFileName = "BorgUserAllList";	//file명
	var data = jq("#list").jqGrid("getGridParam", "postData");
	$("#svcTypeCd").val('BUY');
	$("#borgTypeCd").val(data.borgTypeCd);
	$("#borgId").val(data.borgId);
	$("#isLeaf").val(data.isLeaf);
	var actionUrl = "/system/BorgUserAllListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcUserNm';
	fieldSearchParamArray[1] = 'rcLoginId';
	fieldSearchParamArray[2] = 'srcIsLogin';
	fieldSearchParamArray[3] = 'srcIsUse';
	fieldSearchParamArray[4] = 'svcTypeCd';
	fieldSearchParamArray[5] = 'borgTypeCd';
	fieldSearchParamArray[6] = 'borgId';
	fieldSearchParamArray[7] = 'isLeaf';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>
</head>
<body>
<form id="frm" name="frm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="25" class='ptitle'>고객사 관리</td>
				</tr>
			</table>
			<table width="100%" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
				<col width="300" />
				<col />
				<col width="100%"/>
				<tr>
					<td>
						<table width="100%">
							<tr>
								<td align="left">
									* 조직의 등록/수정은 그룹과 법인만 가능합니다.
								</td>
								<td align="right">
									<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
									<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
									<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
								</td>
							</tr>
						</table>
						<table id="treeList"></table>
					</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="5">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet01.gif"/></td>
											<td height="25" class='ptitle'>
												<span id="staticBorgNm"></span>
												사용자 조회
											</td>
											<td align="right" class='ptitle'>
												<a href="#">
													<img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
												</a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="5" class="table_top_line"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">사용자명</td>
								<td class="table_td_contents">
									<input id="srcUserNm" name="srcUserNm" type="text" value="" size="20" maxlength="30"/>
								</td>
								<td class="table_td_subject" width="100">사용자ID</td>
								<td colspan="2" class="table_td_contents">
									<input id="srcLoginId" name="srcLoginId" type="text" value="" size="20" maxlength="30"/>
								</td>
							</tr>
							<tr>
								<td colspan="5" height='1' bgcolor="eaeaea"></td>
							</tr>
							<tr>
								<td class="table_td_subject" width="100">활성화여부</td>
								<td class="table_td_contents">
									<select id="srcIsLogin" name="srcIsLogin">
										<option value="1">활성</option>
										<option value="0">비활성</option>
										<option value="">전체</option>
									</select>
								</td>
								<td class="table_td_subject" width="100">사용여부</td>
								<td class="table_td_contents">
									<select id="srcIsUse" name="srcIsUse">
										<option value="1">사용</option>
										<option value="0">미사용</option>
										<option value="">전체</option>
									</select>
								</td>
								<td>
									<a href="#"><img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
								</td>
							</tr>
							<tr>
								<td colspan="5" class="table_top_line"></td>
							</tr>
						</table>
						<br/>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="right">
									<a href="#"><img id="saveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Boss.gif" width="15" height="15" style='border:0;display:none;' /></a>
									<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
								</td>
							</tr>
						</table>
						<div id="jqgrid">
							<table id="list"></table>
							<div id="pager"></div>
						</div>
					</td>
				</tr>
			</table>
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
<form>
	<input type="hidden" id="svcTypeCd" name="svcTypeCd" value=""/>
	<input type="hidden" id="borgTypeCd" name="borgTypeCd" value=""/>
	<input type="hidden" id="borgId" name="borgId" value=""/>
	<input type="hidden" id="isLeaf" name="isLeaf" value=""/>
</form>
</body>
</html>