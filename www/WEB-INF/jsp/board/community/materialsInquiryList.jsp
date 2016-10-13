<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	
	String board_Type = (String)request.getAttribute("board_Type");
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "";
	
	//그리드의 width와 Height을 정의
// 	String listHeight = "$(window).height()-221 + Number(gridHeightResizePlus)"+categoryHeightMinus;
	String listHeight = "$(window).height()-350 + Number(gridHeightResizePlus)";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcTitle").attr('checked', true);
	$("#searchText").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { 
		$("#searchText").val($.trim($("#searchText").val()));
		fnSearch(); 
	});
	$("#viewButton").click( function() {
		var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
		if( row != null ){
			var selrowContent = jq("#list").jqGrid('getRowData',row);
			fnBoardDetailWrite(selrowContent.board_No, selrowContent.regi_User_Numb);
		} else { jq( "#dialogSelectRow" ).dialog(); }
	});
	$("#regButton").click( function() { 
		fnBoardDetailWrite("", "REG");
	});
	$("#modButton").click( function() { 
		var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
		if( row != null ){
			var selrowContent = jq("#list").jqGrid('getRowData',row);
			fnBoardDetailWrite(selrowContent.board_No, "REG");
		} else { jq( "#dialogSelectRow" ).dialog(); }
	});
	$("#delButton").click( function() { deleteRow(); });
	$("#excelButton").click(function(){ exportExcel(); });
	
	//규격서/절차서 구분 코드리스트
	stadardClassifySelect();
});

//Resizing
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);
//     $("#list").setGridWidth($(window).width()-52 + Number(gridWidthResizePlus));
    $("#list").setGridWidth(1500);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/board/boardListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['번호','번호시퀀스','구분','상품명','규격','첨부개수','등록일','작성자','조회수','Lev'],
		colModel:[
			{name:'num',index:'num', width:50,align:"center",search:false,sortable:false},	//번호
			{name:'board_No',index:'board_No', width:50,align:"center",search:false,sortable:false, hidden:true,
				editable:false, key:true, editrules:{required:true}
			},	//번호 시퀀스
			{name:'classify',index:'classify', width:60,align:"center",search:false,sortable:false,editable:false},//구분
			{name:'title',index:'title', width:490,align:"left",search:false,sortable:false,
				editable:false, formatter:image1
			},	//상품명
			{name:'standard',index:'standard', width:200,align:"left",search:false,sortable:false,editable:false},//규격
			{name:'file_list_cnt',index:'file_list_cnt', width:70,align:"center",search:false,sortable:false,
				editable:false
			},	//첨부개수
			{name:'regi_Date_Time',index:'regi_Date_Time', width:110,align:"center",search:false,sortable:false,
				editable:false
			},	// 등록일
			{name:'regi_User_Numb',index:'regi_User_Numb', width:110,align:"center",search:false,sortable:false,
				editable:false
			},	// 작성자
			{name:'hit_No',index:'hit_No', width:60,align:"center",search:false,sortable:false,
				editable:false 
			},//조회수
			{name:'Lev',index:'Lev', width:60,align:"center",search:false,sortable:false,
				editable:false ,hidden:true
			}//조회수
		],
		postData: { 
			board_Type:"<%=board_Type%>",
			classify:$("#classify").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>, autowidth:true,
		sortname: '', sortorder: '',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			fnBoardDetailWrite(selrowContent.board_No, selrowContent.regi_User_Numb);
		},	
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
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
	data.srcTitle = document.getElementById("srcTitle").checked ? document.getElementById("searchText").value : "";
	data.srcMessage = document.getElementById("srcMessage").checked ? document.getElementById("searchText").value : "";
	data.srcRegi_User_Numb = document.getElementById("srcRegi_User_Numb").checked ? document.getElementById("searchText").value : "";
	data.searchText = document.frmFile.searchText.value;
	data.classify = $("#classify").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function fnBoardDetailWrite(boareNo,regi_User_Numb) {
	var moveFlag = "D";
	var popproperty = "dialogWidth:720px;dialogHeight=500px;scroll=auto;status=no;resizable=no;";
	if("<%=loginUserDto.getUserNm() %>"==regi_User_Numb || regi_User_Numb=="REG") {
		moveFlag = "W";
		popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
	}
<%	if("ADM".equals(loginUserDto.getSvcTypeCd())) {	%>	
// 	moveFlag = "W";
<%	}	%>
	var popurl = "/board/boardDetailWrite.sys?board_No="+boareNo+"&moveFlag="+moveFlag+"&board_Type=<%=board_Type%>";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=720, height=630, scrollbars=yes, status=no, resizable=no');
}

function deleteRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ) {
		jq("#list").jqGrid( 
			'delGridRow', row,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/board/boardTransGrid.sys",
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

<%
/**
 * 답변에 뿌려질 그림 데이터
 */
%>
function image1(cellValue, options, rowObject){
	var space  = "";
	var space2 = "";
	var img    = "<img src='/img/system/icon_reply.gif' border='0'/>";
	for (var i = 0; i<rowObject.lev; i++) {
		space += "&nbsp;&nbsp;&nbsp;";
	}
	if (rowObject.parent_Board_No == 0){
		space2 = space + rowObject.title;
	}else {
		space2 = space + img + rowObject.title;
	}
	return space2;
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['번호','구분',,'상품명','규격 ','첨부개수','등록일','작성자','조회수'];	//출력컬럼명
	var colIds = ['board_No','classify','title','standard','file_list_cnt','regi_Date_Time','regi_User_Numb','hit_No'];	//출력컬럼ID
	var numColIds = ['board_No','hit_No','file_list_cnt'];	//숫자표현ID
	var sheetTitle = "자재관련문의";	//sheet 타이틀
	var excelFileName = "materialsInquiryList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<script type="text/javascript">
//규격서/절차서 구분
function stadardClassifySelect(){
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"PROPOSAL_SUGGEST",//신규자재 코드와 같이 사용
			isUse:"1"
		},
		function(arg){
			var codeList= eval('('+arg+')').list;
			for(var i=0; i < codeList.length; i++){
				$("#classify").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
		}
	);
}

</script>
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
				<tr>
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="25" class='ptitle'>규격서/절차서</td>
					<td align="right" class='ptitle'>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i> 조회
						</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<!-- Search Context -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="4" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="200">
						<table>
							<tr>
								<td style="width:20px"><input id="srcTitle" name="srcTitle" type="checkbox" style="border:0px;" /></td>
								<td style="width:50px">상품명</td>
								<td style="width:20px"><input id="srcMessage" name="srcMessage" type="checkbox" style="border: 0" /></td> 
								<td style="width:50px">내용</td>
								<td style="width:20px"><input id="srcRegi_User_Numb" name="srcRegi_User_Numb" type="checkbox" style="border: 0" /></td> 
								<td style="width:50px">작성자</td>
							</tr>
						</table>
					</td>
					<td class="table_td_contents" width="550px">
						<input id="searchText" name="searchText" type="text" value="" size="80" maxlength="30"/>
					</td>
					<td class="table_td_subject" width="30px">
						구분
					</td>
					<td class="table_td_contents">
						<select id="classify" name="classify" class="select">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1'></td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="4" height='8'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" valign="bottom">
<%-- 						<button id='excelButton' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 엑셀</button> --%>
						<button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
						<button id='modButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 수정</button>
						<button id='delButton' class="btn btn-default btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-times"></i> 삭제</button>
					</td>
				</tr>
				<tr><td height="1"></td></tr>
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
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>