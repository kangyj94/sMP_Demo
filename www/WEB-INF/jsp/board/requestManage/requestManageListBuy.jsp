<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String srcFromDt = CommonUtils.getCustomDay("YEAR", -1);
	String srcEndDt = CommonUtils.getCurrentDate();
	String Session_auth	= null;
	String board_Type = (String)request.getAttribute("board_Type");
	
	String replayFlag = CommonUtils.getString(request.getParameter("replayFlag"));	//답변플래그 Y일경우 답변글
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>

<style type="text/css">
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }

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


<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
});
</script>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(	//조회조건의 유형세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"REQU_STAT_FLAG", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcRequ_Stat_Flag").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
		}
	);
	
	$("#srcTitle").attr('checked', true);
	
	$("#srcRequ_Stat_Flag").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { fnSearch(); });
	$("#regButton").click( function() { regist(); });
	$("#modButton").click( function() { modify(); });
	$("#delButton").click( function() { deleteRow(); });
	
	$("#srcFromDt").val("<%=srcFromDt%>");
	$("#srcEndDt").val("<%=srcEndDt%>");
});

$(function(){
	$("#srcFromDt").datepicker(
       	{
	   		showOn: "button",
	   		buttonImage: "/img/contents/btn_calenda.gif",
	   		buttonImageOnly: true,
	   		dateFormat: "yy-mm-dd"
       	}
	);
	$("#srcEndDt").datepicker(
       	{
       		showOn: "button",
       		buttonImage: "/img/contents/btn_calenda.gif",
       		buttonImageOnly: true,
       		dateFormat: "yy-mm-dd"
       	}
	);
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/board/requestManageListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[
			'번호',		'번호 시퀀스',	'제목',				'유형',				'등록일',
			'답변일',	'처리상태',		'requ_User_Numb',	'modi_User_Numb'
		],
		colModel:[
			{name:'num',            index:'num',            width:50,    align:"center", search:false, sortable:false},	//번호
			{name:'no',             index:'no',             hidden:true, key:true},	//번호 시퀀스
			{name:'title',          index:'title',          width:600,align:"left",   search:false, sortable:true,  editable:false},	//제목
			{name:'requ_Stat_Flag', index:'requ_Stat_Flag', width:60, align:"center", search:false, sortable:false, editable:false},	//유형
			{name:'requ_User_Date', index:'requ_User_Date', width:90, align:"center", search:false, sortable:true,  editable:false},	// 등록일
			{name:'modi_User_Date', index:'modi_User_Date', width:90, align:"center", search:false, sortable:false, editable:false},	// 답변자
			{name:'stat_Flag_Code', index:'stat_Flag_Code', width:60, align:"center", search:false, sortable:true,  editable:false},//처리상태
			{name:'requ_User_Numb', index:'requ_User_Numb', hidden:true},	//requ_User_Numb
			{name:'modi_User_Numb', index:'modi_User_Numb', hidden:true}	//modi_User_Numb
		],
		postData: {
			srcFromDt : "<%=srcFromDt%>",
			srcEndDt  : "<%=srcEndDt%>"
		},
		rowNum:15, rownumbers: false, rowList:[15,30,50,100], pager: '#pager',
		height: 560,autowidth: true,
		sortname: 'no', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			//FnUpdatePagerIcons(this);
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},	
		afterInsertRow: function(rowid, selrowContent, rowelem){
			var requUserDate  = selrowContent.requ_User_Date + "<br/>" + selrowContent.requ_User_Numb;
			var modiUserDate  = "";
			var stat_Flag_Code  = selrowContent.stat_Flag_Code;
			var title         = "&nbsp;&nbsp;" + selrowContent.title;
			
			if(stat_Flag_Code == "처리완료"){
				modiUserDate  = selrowContent.modi_User_Date + "<br/>" + selrowContent.modi_User_Numb;
			}
			
			$(this).setCell(rowid,'title','',{color:'#0000ff',cursor:'pointer'});
			$('#list').jqGrid('setRowData', rowid, {requ_User_Date : requUserDate, modi_User_Date : modiUserDate, title : title});
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			var cm = $("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['name']=="title" ) {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow(rowid);")%>
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
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
	data.srcFromDt = $("#srcFromDt").val();
	data.srcEndDt = $("#srcEndDt").val();
	data.srcRequ_Stat_Flag = $("#srcRequ_Stat_Flag").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

//	임시 호출 
function fnClose(){
    
}

function viewRow(rowid) {
	
	if( rowid != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',rowid);        // 선택된 로우의 데이터 객체 조회
<%	if(!"ADM".equals(userDto.getSvcTypeCd())) {	%>
		if("<%=userDto.getUserNm() %>"!=selrowContent.requ_User_Numb) {
			alert("작성자만 읽기가 가능합니다.");
			return;
		}
<%	}	%>
		var popurl = "/board/requestManageDetail.sys?no=" + selrowContent.no;
		var popproperty = "dialogWidth:720px;dialogHeight=440px;scroll=auto;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
 	    window.open(popurl, 'okplazaPop', 'width=720, height=440, scrollbars=yes, status=no, resizable=yes');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function regist(){
	var popurl = "/board/requestManageWrite.sys";
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}

function modify(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
<%	if(!"ADM".equals(userDto.getSvcTypeCd())) {	%>
		if("<%=userDto.getUserNm() %>"!=selrowContent.requ_User_Numb) {
			alert("작성한 사람만 수정 가능합니다.");
			return;
		}
		if("요청"!=selrowContent.stat_Flag_Code) {
			alert("요청상태인 경우만 수정이 가능합니다.");
			return;
		}
<%	}	%>
		var popurl = "/board/requestManageWrite.sys?no=" + selrowContent.no;
		var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
// 		window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function deleteRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ) {
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
<%	if(!"ADM".equals(userDto.getSvcTypeCd())) {	%>
		if("<%=userDto.getUserNm() %>"!=selrowContent.requ_User_Numb) {
			alert("작성한 사람만 삭제 가능합니다.");
			return;
		}
		if("요청"!=selrowContent.stat_Flag_Code) {
			alert("요청상태인 경우만 삭제 가능합니다.");
			return;
		}
<%	}	%>
		jq("#list").jqGrid( 
			'delGridRow', row,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/board/requestManageTransGrid.sys",
				recreateForm: true,beforeShowForm: function(form) {
					jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
					jq('#pData').hide(); jq('#nData').hide();  
				},
				reloadAfterSubmit:true,closeAfterDelete: true,
				afterSubmit: function(response, postdata){
					return fnJqTransResult(response, postdata);
				}
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
	jq("#list").trigger("reloadGrid");
}

function fnReply(params) {
    var popurl = "/board/requestManageWrite.sys?"+params;
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, '', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}
</script>


<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
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
				<li class="on">Q&A</li>
			</ul>
			<div style="position:absolute; right:0; margin-top:-30px;"><a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="srcButton" name="srcButton"/></a></div>
			<table class="InputTable">
				<colgroup>
					<col width="100px" />
					<col width="260px" />
					<col width="100px" />
					<col width="auto" />
					<col width="100px" />
					<col width="auto" />
				</colgroup>
			
				
				<tr>
					<th>일자</th>
					<td>
						<input type="text" name="srcFromDt" id="srcFromDt" value="" style="width: 75px;" />
							~
						<input type="text" name="srcEndDt" id="srcEndDt" value="" style="width: 75px;" />
					</td>
					<th>유형</th>
					<td colspan="2">
						<select id="srcRequ_Stat_Flag" name="srcRequ_Stat_Flag" class="select">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
			</table>
		
			<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;" >
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			
				<tr>
					<td bgcolor="#FFFFFF">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr><td style="height: 5px;"></td></tr>
							<tr>
								<td align="right" valign="bottom">
									<button id='regButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
									<button id='modButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 수정</button>
									<button id='delButton' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash-o"></i> 삭제</button>
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
						<div id="dialog" title="Feature not supported" style="display:none;">
							<p>That feature is not supported.</p>
						</div>
					</td>
				</tr>
			</table> 
			<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
				<p>처리할 데이터를 선택 하십시오!</p>
			</div>
			<div style="height:10px;"></div>
		</div>
        <!--컨텐츠(E)-->
		</div>
        	<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
</body>
</html>