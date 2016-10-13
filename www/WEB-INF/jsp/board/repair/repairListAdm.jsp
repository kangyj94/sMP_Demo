<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList"); //화면권한가져오기(필수)
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	String srcStartDate = CommonUtils.getCustomDay("MONTH", -3); // 날짜 세팅
	String srcEndDate   = CommonUtils.getCurrentDate(); // 날짜 세팅
	String listHeight   = "$(window).height()-550 + Number(gridHeightResizePlus)";
	String listWidth    = "1500";
	String srcState     = request.getParameter("srcState");
	
	srcState = CommonUtils.nvl(srcState);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css" media="screen">
    th.ui-th-column div{
        white-space:normal !important;
        height:auto !important;
    }
</style>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body style="background-color:#ffffff;">
<table width="1500px" style="margin-bottom: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td class='ptitle'>Okplaza 유지보수</td> 
					<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
						<button id='allExcelButton' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							<i class="fa fa-file-excel-o"></i>
							엑셀
						</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i>
							조회
						</button>
					</td>
				</tr>
			</table>
			<form id="frmSearch" onsubmit="return false;">
				<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col width="100px" />
						<col width="400px" />
						<col width="100px" />
						<col width="200px" />
						<col width="100px" />
						<col width="200px" />
						<col width="100px" />
						<col width="300px" />
					</colgroup>
					<tr>
						<td colspan="8" class="table_top_line"></td>
					</tr>
					<tr>
						<td colspan="8" height='1'></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">
							<select id="srcDateType" name="srcDateType" style="min-width:80px;" class="select">
								<option value="confirm">요청일</option>
								<option value="handle">조치일</option>
							</select>
						</td>
						<td class="table_td_contents">
							<input id="srcRequStartDate" name="srcRequStartDate" value="<%=srcStartDate%>" type="text" style="width: 75px;" /> 
							~ 
							<input id="srcRequEndDate" name="srcRequEndDate" value="<%=srcEndDate%>" type="text" style="width: 75px;" />
						</td>
						<td class="table_td_subject" width="100">접수구분</td>
						<td class="table_td_contents">
							<select id="srcRepairType" name="srcRepairType" style="min-width:80px;" class="select">
								<option value="">전체</option>
							</select>
						</td>
						<td class="table_td_subject" width="100">처리상태</td>
						<td class="table_td_contents">
							<select id="srcState" name="srcState" style="min-width:80px;" class="select">
								<option value="">전체</option>
							</select>
						</td>
						<td class="table_td_subject" width="100">요청자</td>
						<td class="table_td_contents">
							<input id="srcReqUserName" name="srcReqUserName" value="" type="text" style="width: 150px;" />
						</td>
					</tr>
					<tr>
						<td colspan="8" height='1'></td>
					</tr>
					<tr>
						<td colspan="8" class="table_top_line"></td>
					</tr>
					<tr>
						<td colspan="8" height='8'></td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
	<tr>
		<td>
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<col width="450" />
				<col />
				<col width="100%"/>
				<tr>
					<td align="right" valign="bottom">
						<button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
							<i class="fa fa-plus"></i>
							등록
						</button>
						<button id='delButton' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">
							<i class="fa fa-trash-o"></i>
							삭제
						</button>
					</td>
				</tr>
				<tr><td style="height: 5px;"></td></tr>
				<tr>
					<td valign="top">
						<div id="jqgrid">
							<table id="list"></table>
							<div id="pager"></div>
						</div>
					</td>
				</tr>
			</table>
			<br/>
		</td>
	</tr>
	<tr>
		<td>
			<form id="frmRepairEdit" onsubmit="return false;">
				<input type="hidden" id="oper"      name="oper"      value="edit"/>
				<input type="hidden" id="repair_id" name="repair_id" />
				<table  id="repairDetail"  width="100%"  border="0" cellspacing="0" cellpadding="0" style="display: none;">
					<colgroup>
						<col width="100px" />
						<col width="950px" />
						<col width="150px" />
						<col width="300px" />
						<col width="100px" />
						<col width="650px" />
						<col width="100px" />
						<col width="650px" />
					</colgroup>
					<tr>
						<td colspan="8" class="table_top_line"></td>
					</tr>
					<tr>
						<td colspan="8" height='1'></td>
					</tr>
					<tr>
						<td class="table_td_subject">순번</td>
						<td class="table_td_contents">
							<span id="repair_id_span" class="repairHtml"></span>
						</td>
						<td class="table_td_subject9" width="100px">우선순위</td>
						<td class="table_td_contents">
							<select id="is_important" name="is_important" class="select repairVal" style="width: 85px;">
								<option value="N">N</option>
								<option value="Y">Y</option>
							</select>
						</td>
						<td class="table_td_subject" width="100px">예상공수</td>
						<td class="table_td_contents">
							<input type="text" id="expect_man_day" name="expect_man_day" value="" class="repairVal" style="width: 85px; text-align: right;"/>
						</td>
						<td class="table_td_subject9" width="100px">처리상태</td>
						<td class="table_td_contents">
							<select id="state" name="state" style="min-width:80px;" class="select repairVal"></select>
						</td>
					</tr>
					<tr>
						<td colspan="8" height='1'></td>
					</tr>
					<tr>
						<td class="table_td_subject9" width="100px">화면명</td>
						<td class="table_td_contents">
							<input type="text" id="view_nm" name="view_nm" value="" class="repairVal" style="width: 90%;"/>
						</td>
						<td class="table_td_subject9" width="100px">접수구분</td>
						<td class="table_td_contents">
							<select id="type" name="type" style="min-width:80px;" class="select repairVal"></select>
						</td>
						<td class="table_td_subject">접수</td>
						<td class="table_td_contents">
							<span id="confirm_user_nm" class="repairHtml"></span>
						</td>
						<td class="table_td_subject">처리</td>
						<td class="table_td_contents">
							<span id="handle_user_nm" class="repairHtml"></span>
						</td>
					</tr>
					
					<tr>
						<td colspan="8" height='1'></td>
					</tr>

					<tr>
						<td class="table_td_subject9" width="100px">요청내용</td>
						<td class="table_td_contents" colspan="3">
							<textarea id="req_contents" name="req_contents" class="repairVal" style="width: 90%;height: 150px;"></textarea>
						</td>
						<td class="table_td_subject">처리내용</td>
						<td class="table_td_contents" colspan="3">
							<textarea id="handle_contents" name="handle_contents" style="width: 90%;height: 150px;" class="repairVal"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="8" height='1'></td>
					</tr>
					<tr>
						<td class="table_td_subject">첨부1</td>
						<td class="table_td_contents" colspan="3">
							<input type="hidden" id="file_list1" name="file_list1" value="" class="repairVal"/>
							<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="" class="repairVal"/>
							<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
								<span id="attach_file_name1" class="repairHtml"></span>
							</a>
							<button id="btnAttach1" type="button" class="btn btn-primary btn-xs">등록</button>
							<button id="btnAttachDel1" type="button" class="btn btn-default btn-xs">삭제</button>
						</td>
						<td class="table_td_subject">첨부2</td>
						<td class="table_td_contents" colspan="3">
							<input type="hidden" id="file_list2" name="file_list2" value="" class="repairVal"/>
							<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="" class="repairVal"/>
							<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
								<span id="attach_file_name2" class="repairHtml"></span>
							</a>		
							<button id="btnAttach2" type="button" class="btn btn-primary btn-xs">등록</button>
							<button id="btnAttachDel2" type="button" class="btn btn-default btn-xs">삭제</button>
						</td>
					</tr>
					<tr>
						<td colspan="8" height='1'></td>
					</tr>
					<tr>
						<td colspan="8" >
							<div class="Ac mgt_10" align="center">
								<button id="btnRepairEdit" type="button" class="btn btn-danger btn-sm"><i class="fa fa-save"></i>저장</button>
							</div>
						</td>
					</tr>
					<tr>
					<td colspan="8">&nbsp;
					</td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
</table>
<style type="text/css">
.jqmWindow {
    display: none;
    position: absolute;
    top: 5%;
    left: 20%;
    width: 600px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
    z-index: 1003;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<div class="jqmWindow" id="repairPop"></div>

<script type="text/javascript">
var subGrid = null;
var selRepairId = "";

$(function(){
    $.ajaxSetup ({
        cache: false
    });
    fnInitEvent();
	fnDataInit();
});

function fnInitEvent(){
	$('#srcButton').click(function(e){
		fnSearch();
	});
	
	$('#regButton').click(function(e){
		$('#repairPop').html('').load('/menu/board/repair/repairRegPop.sys').jqmShow();
	});
	
	$("#btnRepairEdit").click(function(){
		fnRepairEdit();
	});
	
    $("#delButton").click( function() {
    	fnDelButtonOnClick();
    });
    
    $("#allExcelButton").click( function() {
    	fnAllExcelButtonOnClick();
    });
}

function fnAllExcelButtonOnClick(){
	var colLabels = [
		'순번',	'우선',	'화면명',	'접수구분',	'예상공수',
		'처리상태',	'요청조직',	'요청자',	'접수자',	'처리자'
	];
	var colIds = [
		'REPAIR_ID', 'IS_IMPORTANT_DISP', 'VIEW_NM',       'TYPE_NM',           'EXPECT_MAN_DAY',
		'STATE_NM',  'REQ_BORG_NAME',     'REQ_USER_NAME', 'CONFIRM_USER_NAME', 'HANDLE_USER_NAME'
	]; 
	var numColIds             = [];              //숫자표현ID
	var sheetTitle            = "Okplaza 유지보수"; //sheet 타이틀
	var excelFileName         = "RepairList";    //file명
	var fieldSearchParamArray = new Array();
	
	fieldSearchParamArray[0] = 'srcRequStartDate';
	fieldSearchParamArray[1] = 'srcRequEndDate';
	fieldSearchParamArray[2] = 'srcRepairType';
	fieldSearchParamArray[3] = 'srcState';
	fieldSearchParamArray[4] = 'srcReqUserName';
	fieldSearchParamArray[5] = 'srcDateType';
	
	fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/board/repairExcel.sys");
}

function fnDelButtonOnClick(){
	var row = $("#list").jqGrid('getGridParam','selrow');
	
	if( ! row ){
		alert("처리할 데이터를 선택하시기 바랍니다.");
		
		return;	
	}
	
	if (confirm("선택한 데이터를 삭제하시겠습니까?") == false){
		return;    	
	}
	
	$.post(
		"/board/deleteRepairManage/save.sys",
		{
			repair_id	: row,
			oper		: 'del'
		},
		function(args){
			if ( fnAjaxTransResult(args)) {
				fnSearch();
			} 
		}
	);
}

//검색 데이터 초기화 
function fnDataInit(){
	//날짜 데이터 초기화
	$("#srcRequStartDate").datepicker({
		showOn          : "button",
		buttonImage     : "/img/system/btn_icon_calendar.gif",
		buttonImageOnly : true,
		dateFormat      : "yy-mm-dd"
	});
	
	$("#srcRequEndDate").datepicker({
		showOn          : "button",
		buttonImage     : "/img/system/btn_icon_calendar.gif",
		buttonImageOnly : true,
		dateFormat      : "yy-mm-dd"
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정

	
	$.post(  //조회조건의 faq유형 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{
			codeTypeCd : "REPAIR_STAT",
			isUse      : "1"
		},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			
			for(var i=0;i<codeList.length;i++) {
				$("#srcState").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				$("#state").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			
			$("#srcState").val("<%=srcState %>");
			
			fnGetRepairType();
		}
	);  
}

// 접수구분 조회
function fnGetRepairType(){
	
	$.post(  //조회조건의 faq유형 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{
			codeTypeCd : "REPAIR_TYPE",
			isUse      : "1"
		},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			
			for(var i=0;i<codeList.length;i++) {
				$("#srcRepairType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				$("#type").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			
			fnGridInit();
		}
	);
}


//그리드 초기화 
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectRepairManage/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:[
			'순번',			'우선',	'화면명',	'접수구분',	'예상공수',
			'처리상태',			'요청조직',	'요청자',	'접수자',	'처리자',
			'IS_IMPORTANT'
		],
        colModel:[
            {name:'REPAIR_ID',         width:40,  align:"center", key:true},//순번
            {name:'IS_IMPORTANT_DISP', width:40,  align:"center"},//순번
            {name:'VIEW_NM',           width:220},//화면명
            {name:'TYPE_NM',           width:60, align:'center'},//접수구분
            {name:'EXPECT_MAN_DAY',    width:60, align:'right', formatter:'integer', formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//예상공수
            
            {name:'STATE_NM',          width:60,  align:'center'},//처리상태
            {name:'REQ_BORG_NAME',     width:250, align:'left'},//요청조직
            {name:'REQ_USER_NAME',     width:230, align:'left'},//요청자
            {name:'CONFIRM_USER_NAME', width:210, align:'left'},//접수자
            {name:'HANDLE_USER_NAME',  width:210, align:'left'},//처리자
            
            {name:'IS_IMPORTANT',      hidden:true}//IS_IMPORTANT
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager',
        height:<%=listHeight%>,width:<%=listWidth%>,
        sortname: 'REPAIR_ID', sortorder: 'DESC', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        afterInsertRow: function(rowid, aData) {
        	//fnListOnAfterInsertRow(rowid, aData);
        },
        loadComplete: function(data) {
        	fnListOnLoadComplete(data);
        },
        onSelectRow: function (rowid, iRow, iCol, e) {
        	fnSelDetail(rowid);
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {},
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    });
	
    $('#frmSearch').search();
    $('#repairPop').jqm();
}

function fnListOnAfterInsertRow(rowid, aData){
	var selrowContent = $("#list").jqGrid('getRowData', rowid);
	
	if(selrowContent.IS_IMPORTANT == 'Y') {
		$(this).setCell(rowid, 'IS_IMPORTANT_DISP', '', {'color':'#ff0000'});
	}
}

function fnListOnLoadComplete(data){
	var list = data.list;
	
	if( list.length > 0){
		if( selRepairId ){ // 수정 후 선택
			$("#list").setSelection(selRepairId ,true);
			selRepairId = "";
		}
		else{ // 조회.등록 후 선택
    		$("#list").setSelection(list[0].REPAIR_ID, true); // 첫번째 로우아이디 선택
		}
	}
}

function fnSelDetail(rowid){  
	//초기화
	$(".repairHtml").html("");
	$(".repairVal").val("");
	
	$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectRepairManage/list.sys',
		{ repair_id : rowid, isFile: 1 },
		function(arg) {
			var result = eval('(' + arg + ')');
			var list = 	result.list;
			if ( list != null && list.length != 0) {
				var repair = list[0];
				$("#repairDetail").show(); 
				$("#confirm_user_nm").html(repair.CONFIRM_USER_NAME);
				$("#handle_user_nm").html(repair.HANDLE_USER_NAME);
				$("#attach_file_name1").html(repair.ATTACH_FILE_NAME1);
				$("#attach_file_name2").html(repair.ATTACH_FILE_NAME2);
				$("#repair_id_span").html(rowid);
				
				$("#repair_id").val(rowid);
				$("#state").val(repair.STATE);
				$("#type").val(repair.REPAIR_TYPE);
				$("#view_nm").val(repair.VIEW_NM);
				$("#req_contents").val(repair.REQ_CONTENTS);
				$("#file_list1").val( ! repair.ATTACH1_ID ? "" : repair.ATTACH1_ID );
				$("#attach_file_path1").val(repair.ATTACH_FILE_PATH1);
				$("#file_list2").val(! repair.ATTACH2_ID ? "" : repair.ATTACH2_ID );
				$("#attach_file_path2").val(repair.ATTACH_FILE_PATH2);
				$("#handle_contents").val(repair.HANDLE_CONTENTS);
				$("#is_important").val(repair.IS_IMPORTANT);
				$("#expect_man_day").val(repair.EXPECT_MAN_DAY);
				
				$("#expect_man_day").number(true);
			}
			else {
				$("#repairDetail").hide();
				alert('처리 중 오류가 발생했습니다.');
			}
		}
	);  
}

function fnRepairEdit(){
		
	var repair_id		= $("#repair_id").val();
	var state			= $("#state").val();
	var view_nm			= $("#view_nm").val();
	var req_contents	= $("#req_contents").val();
	var file_list1		= $("#file_list1").val();
	var file_list2		= $("#file_list2").val();
	var handle_contents	= $("#handle_contents").val();
	
	if( ! repair_id || isNaN( repair_id)  ){
		alert("수정 데이터 순번을 확인하여 주시기 바랍니다.");
		return;
	}
	
	if( ! state || isNaN( state)  ){
		alert("처리상태를 확인하여 주시기 바랍니다.");
		return;
	}
	
	if( ! view_nm ){
		alert("화면명을 입력하여 주시기 바랍니다.");
		return;
	}		
	if( view_nm.length > 201 ){
		alert("화면명은 최대 200자까지 입력 가능합니다.");
		return;
	}		
	if( ! req_contents ){
		alert("요청내용을 입력하여 주시기 바랍니다.");
		return;
	}		
	if( req_contents.length > 4000 ){
		alert("요청내용은 최대 4000자까지 입력 가능합니다.");
		return;
	}		
	
	if( file_list1 && isNaN(file_list1) ){
		alert("첨부1 파일 정보가 잘못됐습니다.");
		return;
	}		
	
	if( file_list2 && isNaN(file_list2) ){
		alert("첨부2 파일 정보가 잘못됐습니다.");
		return;
	}		
	
	if( handle_contents && handle_contents.length > 4000 ){
		alert("처리내용은 최대 4000자까지 입력 가능합니다.");
		return;
	}	
	

	if (!confirm("수정 내용을 저장하시겠습니까?")) return;
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/updateRepairManage.sys',
		$('#frmRepairEdit').serialize(),
		function(msg) {
			var m = eval('(' + msg + ')');
			if (m.customResponse.success) {
				$("#repairDetail").hide();
				fnSearch();
				selRepairId = repair_id;
			} else {
				alert('저장 중 오류가 발생했습니다.');
			}
		}
	);
}

// Resizing
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight%>);
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');

// 조회 등록/수정/삭제 후에도 처리하기에 꼭 펑션으로 사용함. 
function fnSearch() {
	$("#list")
		.jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()})
		.trigger("reloadGrid");
	$("#repairDetail").hide();
}

</script>

<%----------------------------------  첨부파일  --------------------------------------%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#file_list1").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#file_list2").val(), "fnCallBackAttach2"); });
	$("#btnAttachDel1").click(function(){ fnAttachDel('file_list1'); });
	$("#btnAttachDel2").click(function(){ fnAttachDel('file_list2'); });
	
<%
	if("agent1".equals(loginUserDto.getLoginId()) || "bogeus".equals(loginUserDto.getLoginId()) || "jyb723".equals(loginUserDto.getLoginId())){
%>
	$("#btnRepairEdit").show();
	$("#srcState").attr("disabled", false);
	$("#handle_contents").attr("disabled", false);
<%
	}
	else{
%>
	$("#btnRepairEdit").hide();
	$("#srcState").attr("disabled", true);
	$("#handle_contents").attr("disabled", true);
<%
	}
%>
});

/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list1").val(rtn_attach_seq);
	$("#attach_file_name1").text(rtn_attach_file_name);
	$("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#file_list2").val(rtn_attach_seq);
	$("#attach_file_name2").text(rtn_attach_file_name);
	$("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#ATTACH1_ID").val(rtn_attach_seq);
	$("#attach_file_name3").text(rtn_attach_file_name);
	$("#attach_file_path3").val(rtn_attach_file_path);
}
/**
 * 첨부파일4 파일관리
 */
function fnCallBackAttach4(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#ATTACH2_ID").val(rtn_attach_seq);
	$("#attach_file_name4").text(rtn_attach_file_name);
	$("#attach_file_path4").val(rtn_attach_file_path);
}

/**
 * 파일다운로드
 */
function fnAttachFileDownload(attach_file_path) {
	var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}
jQuery.download = function(url, data, method){
    // url과 data를 입력받음
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};


function fnAttachDel(columnName) {
	if(columnName=='file_list1') {
		$("#file_list1").val('');
		$("#attach_file_name1").text('');
		$("#attach_file_path1").val('');
	} else if(columnName=='file_list2') {
		$("#file_list2").val('');
		$("#attach_file_name2").text('');
		$("#attach_file_path2").val('');
	} else if(columnName=='ATTACH1_ID') {
		$("#ATTACH1_ID").val('');
		$("#attach_file_name3").text('');
		$("#attach_file_path3").val('');
	} else if(columnName=='ATTACH2_ID') {
		$("#ATTACH2_ID").val('');
		$("#attach_file_name4").text('');
		$("#attach_file_path4").val('');
	} 
}

</script>
<%----------------------------------  /첨부파일  --------------------------------------%>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
</body>
</html>