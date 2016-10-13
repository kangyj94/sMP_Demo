<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="java.util.List"%> 
<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "";
	String srcFromDt = CommonUtils.getCustomDay("YEAR", -1);
	String srcEndDt = CommonUtils.getCurrentDate();
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-358 + Number(gridHeightResizePlus)"+categoryHeightMinus;
	String listWidth  = "1500";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %> 

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	//-----------------------------------------------------------
	//처리상태 셀렉트 박스 펑션화 시킬것
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"STAT_FLAG_CODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#sTat_Flag_Code").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
		}
	);
	//처리상태 셀렉트 박스 펑션화 시킬것
	//-----------------------------------------------------------
	
	
	$("#srcTitle").attr('checked', true);
	$("#sTat_Flag_Code").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});

	$("#srcButton").click( function() { fnSearch();}); 
	$("#regButton").click( function() { regist(); });
	$("#modButton").click( function() { modify(); });
	$("#delButton").click( function() { deleteRow(); });
	
	$("#srcFromDt").val("<%=srcFromDt%>");
	$("#srcEndDt").val("<%=srcEndDt%>");
});
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');

$(function(){
	$("#srcFromDt").datepicker(
       	{
	   		showOn: "button",
	   		buttonImage: "/img/system/btn_icon_calendar.gif",
	   		buttonImageOnly: true,
	   		dateFormat: "yy-mm-dd"
       	}
	);
	$("#srcEndDt").datepicker(
       	{
       		showOn: "button",
       		buttonImage: "/img/system/btn_icon_calendar.gif",
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/board/requestImproListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['번호','번호 시퀀스','제목','등록일', '등록자', '접수자', '처리자','우선순위', '처리상태'],
		colModel:[
			{name:'num',index:'num', width:50,align:"center",search:false,sortable:false},	//번호
			{name:'no',index:'no', width:50,align:"center",search:false,sortable:false, hidden:true,
				editable:false, key:true, editrules:{required:true}
			},	//번호 시퀀스
			{name:'title',index:'title', width:580,align:"left",search:false,sortable:true,
				editable:false
			},	//제목
			{name:'requ_User_Date',index:'requ_User_Date', width:90,align:"center",search:false,sortable:true,
				editable:false
			},	// 등록일
			{name:'requ_User_Numb',index:'requ_User_Numb', width:70,align:"center",search:false,sortable:false,
				editable:false
			},	// 등록자
			{name:'hand_User_Numb',index:'hand_User_Numb', width:70,align:"center",search:false,sortable:false,
				editable:false
			},	// 접수자
			{name:'modi_User_Numb',index:'modi_User_Numb', width:70,align:"center",search:false,sortable:false,
				editable:false
			},	// 처리자
			{name:'first',index:'first', width:60,align:"center",search:false,sortable:true,
				editable:false 
			}, //우선순위
			{name:'stat_Flag_Code',index:'stat_Flag_Code', width:60,align:"center",search:false,sortable:true,
				editable:false 
			}//처리상태
		],
		postData: {
			srcFromDt:"<%=srcFromDt%>",
			srcEndDt:"<%=srcEndDt%>",
			//처리상태 셀렉트값
			sTat_Flag_Code:$("#sTat_Flag_Code").val(),
			srcFromDt:$("#srcFromDt").val(),
			srcEndDt:$("#srcEndDt").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'no', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		afterInsertRow: function(rowid, aData) {
			$(this).setCell(rowid,'title','',{color:'#0000ff',cursor:'pointer'});
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},	
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent,target){
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			var cm = $("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			if(colName != undefined &&colName['name']=="title") {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow(selrowContent.no);")%>
			}
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
	jq("#list").setGridParam({datatype:'json'});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcFromDt = $("#srcFromDt").val();
	data.srcEndDt = $("#srcEndDt").val();
	data.sTat_Flag_Code = $("#sTat_Flag_Code").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

//	임시 호출 
function fnClose(){
    
}

function viewRow(no) {	
	var popurl = "/board/improManageDetail.sys?no=" + no+"&_menuId=<%=_menuId%>";
	window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=yes');
}

function regist(){
	var popurl = "/board/improManageReg.sys?_menuId=<%=_menuId%>";
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
	window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}

function modify(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
<%	if(!"ADM".equals(loginUserDto.getSvcTypeCd())) {	%>
		if("<%=loginUserDto.getUserNm() %>"!=selrowContent.requ_User_Numb) {
			alert("작성한 사람만 수정 가능합니다.");
			return;
		}
		if("요청"!=selrowContent.stat_Flag_Code) {
			alert("요청상태인 경우만 수정이 가능합니다.");
			return;
		}
<%	}	%>
		var popurl = "/board/improManageReg.sys?no=" + selrowContent.no;
		window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function deleteRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ) {
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
<%	if(!"ADM".equals(loginUserDto.getSvcTypeCd())) {	%>
		if("<%=loginUserDto.getUserNm() %>"!=selrowContent.requ_User_Numb) {
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
				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/board/improManageTransGrid.sys",
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
    var popurl = "/board/improManageReg.sys?"+params;
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, '', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}
</script>


<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>OKPlaza 개선요청</td>
					<td align="right" class="ptitle">
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
				<tr>
					<td height="1"></td>
				</tr>
			</table>
			<!-- Search Context -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="2" height='1'></td>
			</tr>
			<tr>
				<td width="100" class="table_td_subject">일자</td>
				<td width="230" class="table_td_contents">
					<input type="text" name="srcFromDt" id="srcFromDt" value="" style="width: 75px;" />
						~
					<input type="text" name="srcEndDt" id="srcEndDt" value="" style="width: 75px;" />		
				</td>
				<td width="100" class="table_td_subject">처리상태</td>
				<td width="190" class="table_td_contents">
					<select id="sTat_Flag_Code" name="sTat_Flag_Code" class="select">
						<option value="">전체</option>
					</select>
					</td> 
			</tr>
			<tr>
				<td colspan="2" height='1'></td>
			</tr>
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="6" height='8'></td>
			</tr>
		</table>
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" valign="bottom">
						<button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
						<button id='modButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 수정</button>
						<button id='delButton' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash-o"></i> 삭제</button>
					</td>
				</tr>
				<tr><td style="height: 1px;"></td></tr>
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
</form>
</body>
</html>