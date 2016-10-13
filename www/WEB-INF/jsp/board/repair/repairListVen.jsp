<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	// 날짜 세팅
	String srcStartDate = CommonUtils.getCustomDay("MONTH", -1);
	String srcEndDate = CommonUtils.getCurrentDate();
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Default.css">
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
<div class="jqmWindow" id="repairPop" style="background: grey; border-style: none; " ></div>

<script type="text/javascript">

$(function(){
    $.ajaxSetup ({
        cache: false
    });
	fnDataInit();
	fnGridInit();
	$('#srcButton').click(function (e) {
		fnSearch();
	});
	$('#regButton').click(function (e) {
		$('#repairPop').html('')
		.load('/menu/board/repair/repairRegPop2.sys')
		.jqmShow();
	});
	
	$("#btnRepairEdit").click(function(){ fnRepairEdit(); });
	
	$("#delButton").click( function() {
		var row = $("#list").jqGrid('getGridParam','selrow');
		var selrowContent = $("#list").jqGrid("getRowData",row);
		if( ! row ){
			alert("처리할 데이터를 선택하시기 바랍니다.");
			return;	
		}
		if(selrowContent.STATE != '0' || selrowContent.STATE != 0 ){
			alert(" '요청' 상태해서만 삭제가 가능합니다.");
			return;
		}

		confirmMessage("선택한 데이터를 삭제하시겠습니까?", fnDelButtonOnClickCallback);
	});
	
	$('#frmSearch').search();
	$('#repairPop').jqm();
});

function fnDelButtonOnClickCallback(){
	var row = $("#list").jqGrid('getGridParam','selrow');
	
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
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcRequEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정

	
	 $.post(  //조회조건의 faq유형 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{
			codeTypeCd:"REPAIR_STAT",
			isUse:"1"
		},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcState").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				$("#state").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			
			fnGetRepairType();
		}
	);  
}

//접수구분 조회
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
		}
	);
}

var subGrid = null;
var selRepairId = "";
//그리드 초기화
function fnGridInit() {
	$("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/selectRepairManage/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:[
			'순번',	'화면명',	'접수구분',	'처리상태',	'요청조직',	
			'요청자',	'접수자',	'처리자',		'state'
		],
        colModel:[
            {name:'REPAIR_ID',         width:35,  align:"center", key:true},//순번
            {name:'VIEW_NM',           width:180},//화면명
            {name:'TYPE_NM',           width:60,   align:'center'},//접수구분
            {name:'STATE_NM',          width:60,  align:'center'},//처리상태
            {name:'REQ_BORG_NAME',     width:150, align:'left'},//요청조직
            
            {name:'REQ_USER_NAME',     width:150, align:'left'},//요청자
            {name:'CONFIRM_USER_NAME', width:150, align:'left'},//접수자
            {name:'HANDLE_USER_NAME',  width:150, align:'left'},//처리자
            {name:'STATE',             hidden:true}//처리자
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:15, rowList:[15,30,50,100], pager: '#pager',
        height:160,width:1000,
        sortname: '', sortorder: '', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        afterInsertRow: function(rowid, aData) {},
        loadComplete: function(data) {
        	//FnUpdatePagerIcons(this);
        	
        	var list = data.list; 
        	
        	if( list.length > 0){
        		if( selRepairId ){ // 수정 후 선택
        			$("#list").setSelection(selRepairId ,true);
        			selRepairId = "";
        		}
        		else{ // 조회.등록 후 선택
	        		$("#list").setSelection(list[0].REPAIR_ID,true); // 첫번째 로우아이디 선택
        		}
        	}
        },
        onSelectRow: function (rowid, iRow, iCol, e) {
        	fnSelDetail(rowid);
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {},
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    })
    
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
				var isWriter = ('<%=userDto.getUserId()%>'  == repair.REQ_USER_ID );
				
				if( isWriter && (repair.STATE == 0 || repair.STATE == '0') ){
					$(".isWriter").show();
					$("#req_contents").removeAttr("disabled");
				}else{
					$(".isWriter").hide();
					$("#req_contents").attr("disabled","disabled");
				}
				
				$("#repairDetail").show();
				 
				$("#confirm_user_nm").html(repair.CONFIRM_USER_NAME);
				$("#handle_user_nm").html(repair.HANDLE_USER_NAME);
				$("#attach_file_name1").html(repair.ATTACH_FILE_NAME1);
				$("#attach_file_name2").html(repair.ATTACH_FILE_NAME2);
				$("#repairId").html(rowid);
				
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

			} else {
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
	
	confirmMessage("수정 내용을 저장하시겠습니까?", fnRepairEditCallback);
}

function fnRepairEditCallback(){
	var repair_id = $("#repair_id").val();
	
	$("#state").removeAttr("disabled");
	$("#type").removeAttr("disabled");
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/updateRepairManage/save.sys',
		$('#frmRepairEdit').serialize(),
		function(msg) {
			$("#state").attr("disabled","disabled");
			$("#type").attr("disabled","disabled");
			
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

<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>

<body class="subBg">
	<div id="divWrap">
		<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
		<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">Okplaza 개선 요청</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;">
						<a href="#;">
							<img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/>
						</a>
					</div>
					<form id="frmSearch" onsubmit="return false;">
						<table class="InputTable">
							<colgroup>
								<col width="100px" />
								<col width="400px" />
								<col width="100px" />
								<col width="400px" />
								<col width="100px" />
								<col width="400px" />
							</colgroup>
							<tr>
								<th>조회일자</th>
								<td>
									<input id="srcRequStartDate" name="srcRequStartDate" value="<%=srcStartDate%>" type="text" style="width: 75px;" /> 
									~ 
									<input id="srcRequEndDate" name="srcRequEndDate" value="<%=srcEndDate%>" type="text" style="width: 75px;" />
								</td>
								<th>접수구분</th>
								<td>
									<select id="srcRepairType" name="srcRepairType" style="min-width:80px;" class="select">
										<option value="">전체</option>
									</select>
								</td>
								<th>처리상태</th>
								<td>
									<select id="srcState" name="srcState" style="min-width:80px;" class="select">
										<option value="">전체</option>
									</select>
								</td>
							</tr>
						</table>
					</form>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td bgcolor="#FFFFFF">
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td style="height: 5px;"></td>
									</tr>
									<tr>
										<td align="right" valign="bottom">
											<button id='regButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
											<button id='delButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash-o"></i> 삭제</button>
										</td>
									</tr>
									<tr>
										<td style="height: 5px;"></td>
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
								<div id="dialog" title="Feature not supported" style="display:none;">
									<p>That feature is not supported.</p>
								</div>
							</td>
						</tr>
						<tr>
							<td style="height: 5px;"></td>
						</tr>
					</table> 
					<form id="frmRepairEdit" name="frmRepairEdit" onsubmit="return false;">
						<input type="hidden" id="oper"      name="oper"      value="edit"/>
						<input type="hidden" id="repair_id" name="repair_id" />
						<input type="hidden" id="is_important" name="is_important" value="N" />
						
						<div class="ListTable"/>
							<table  id="repairDetail"  width="100%"  border="0" cellspacing="0" cellpadding="0" style="display: none;">
								<colgroup>
									<col width="100px" />
									<col width="650px" />
									<col width="100px" />
									<col width="650px" />
								</colgroup>
								<tr>
									<th>순번</th>
									<td >
										<span id="repairId" class="repairHtml"></span>
									</td>
									<th>화면명</th>
									<td>
										<input type="text" id="view_nm" name="view_nm" value="" class="repairVal" style="width: 90%;"/>
									</td>
								</tr>
								<tr>
									<th>접수구분</th>
									<td >
										<select id="type" name="type" disabled="disabled" class="select repairVal"></select>
									</td>
									<th>처리상태</th>
									<td >
										<select id="state" name="state" disabled="disabled" class="select repairVal"></select>
									</td>
								</tr>
								<tr>
									<th>접수</th>
									<td>
										<span id="confirm_user_nm" class="repairHtml"></span>
									</td>
									<th>처리</th>
									<td>
										<span id="handle_user_nm" class="repairHtml"></span>
									</td>
								</tr>
								<tr>
									<th>요청내용</th>
									<td>
										<textarea id="req_contents" name="req_contents" class="repairVal" style="width: 90%;height: 70px;"></textarea>
									</td>
									<th>처리내용</th>
									<td>
										<textarea id="handle_contents" name="handle_contents" style="width: 90%;height: 70px;" class="repairVal" disabled="disabled"></textarea>
									</td>
								</tr>
								<tr>
									<th>첨부1</th>
									<td>
										<input type="hidden" id="file_list1" name="file_list1" value="" class="repairVal"/>
										<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="" class="repairVal"/>
										<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
											<span id="attach_file_name1" class="repairHtml"></span>
										</a>
										<div style="float:right">
											<button id="btnAttach1" type="button" class="btn btn-darkgray btn-xs isWriter">등록</button>
											<button id="btnAttachDel1" type="button" class="btn btn-default btn-xs isWriter">삭제</button>
										</div>
									</td>
									<th>첨부2</th>
									<td>
										<input type="hidden" id="file_list2" name="file_list2" value="" class="repairVal"/>
										<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="" class="repairVal"/>
										<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
											<span id="attach_file_name2" class="repairHtml"></span>
										</a>	
										<div style="float:right">
											<button id="btnAttach2" type="button" class="btn btn-darkgray btn-xs isWriter">등록</button>
											<button id="btnAttachDel2" type="button" class="btn btn-default btn-xs isWriter">삭제</button>
										</div>	
									</td>
								</tr>
								<tr>
									<td colspan="6" style="border-style: none;">
										<div class="Ac mgt_10" align="center">
											<button id="btnRepairEdit" type="button" class="btn btn-darkgray btn-sm isWriter"><i class="fa fa-save"></i>수정</button>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</form>
					<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
						<p>처리할 데이터를 선택 하십시오!</p>
					</div>
				</div>
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>
</html>