<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.board.dto.VocDto"%>
<%@ page import="java.util.List"%>
<%
	//화면권한가져오기(필수)
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String srcFromDt = CommonUtils.getCustomDay("DAY", -6);
	String srcEndDt = CommonUtils.getCurrentDate();
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-260 + Number(gridHeightResizePlus)";
	String rece_type = (String)request.getAttribute("rece_Type");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">

var jq = jQuery;

$(document).ready(function() {
	$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
			{codeTypeCd:"VOC_RECE_TYPE", isUse:"1"},
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
		$("#srcWriter").keydown(function(e){
			if(e.keyCode==13) {
				$("#srcButton").click();
			}
		});
		
		$("#srcUserWriter").keydown(function(e){
			if(e.keyCode == '13'){
				fnSearch();
			}
		});
		
		$("#sTat_Flag_Code").keydown(function(e){
			if(e.keyCode==13) {
				$("#srcButton").click();
			}
		});
		
	$("#srcButton").click( function() { 
		fnSearch(); 
	});
	$("#srcFromDt").val("<%=srcFromDt%>");
	$("#srcEndDt").val("<%=srcEndDt%>");
	
	$(window).bind('resize', function() { 
		$("#list").setGridHeight(<%=listHeight %>);
		$("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
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
	
});
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});  
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcWriter = $("#srcWriter").val();
	data.srcUserWriter = $("#srcUserWriter").val();
	data.sTat_Flag_Code = $("#sTat_Flag_Code").val();
	data.srcFromDt = $("#srcFromDt").val();
	data.srcEndDt = $("#srcEndDt").val();
// 	data.srcTitle = document.getElementById("srcTitle").checked ? document.getElementById("searchText").value : "";
// 	data.srcMessage = document.getElementById("srcMessage").checked ? document.getElementById("searchText").value : "";
//  	data.srcRegi_User_Numb = document.getElementById("srcRegi_User_Numb").checked ? document.getElementById("searchText").value : "";
//  	data.searchText = document.frmFile.searchText.value;
// 	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
</script>

<script type="text/javascript">
function fnBoardDetail(vocNo){
	var popurl = "/voc/vocDetail.sys?voc_No="+vocNo;
	window.open(popurl, 'okplazaPop', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}

</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/voc/vocListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:[ 'voc_no' , '접수유형' , '제목' , '첨부개수', '업체명' , '작성자'  , '전화번호', '이메일', '작성일' ],
		colModel:[
			{name:'voc_no',index:'voc_no', width:90,align:"center",search:false,sortable:false,hidden:true,key:true },	// vocSeq
			{name:'rece_type_nm',index:'rece_type_nm', width:90,align:"center",search:false,sortable:true },	// 접수유형
			{name:'title',index:'title', width:300,align:"left",search:false,sortable:true },	// 제목
			{name:'file_list_cnt',index:'file_list_cnt', width:70,align:"center",search:false,sortable:true },	// 첨부파일
			{name:'borg_string',index:'borg_string', width:350,align:"left",search:false,sortable:true },	// 업체명
			{name:'usernm',index:'usernm', width:80,align:"center",search:false,sortable:true },	// 작성자
			{name:'tel',index:'tel', width:90,align:"center",search:false,sortable:true },	// 전화번호
			{name:'email',index:'email', width:130,align:"center",search:false,sortable:true },	// 이메일
			{name:'regi_date_time',index:'regi_date_time', width:180,align:"center",search:false,sortable:true }	// 등록일
		],
		postData: {
			srcWriter:$("#srcWriter").val(),
			srcUserWriter:$("#srcUserWriter").val(),
			sTat_Flag_Code:$("#sTat_Flag_Code").val(),
			rece_Type:"<%=rece_type%>"
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'voc_no', sortorder: 'desc',
 		caption:"고객의 소리",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			fnBoardDetail(selrowContent.voc_no);
		},	
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
});


function fnReloadGrid() { //페이지 이동 없이 리로드하는 메소드
	jq("#list").trigger("reloadGrid");
}
</script>


</head>
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/>
					</td>
					<td height="29" class='ptitle'>고객의 소리</td>
					<td align="right">
						<a href="#">
							<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;' />
						</a>
					</td>
				</tr>
			</table>
			<!-- Search Context -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="200">
						접수유형
					</td>
					<td class="table_td_contents">
						<select id="sTat_Flag_Code" name="sTat_Flag_Code" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<td class="table_td_subject" width="200">작성일</td>
						
						
				<td width="500" class="table_td_contents">
					<input type="text" name="srcFromDt" id="srcFromDt" value="" style="width: 75px;" />
						~
					<input type="text" name="srcEndDt" id="srcEndDt" value="" style="width: 75px;" />		
				</td>	
					
				</tr>
				<tr>
					<td class="table_td_subject" width="200">
						제목
					</td>
					<td class="table_td_contents">
						<input id="srcWriter" name="srcWriter" type="text" value="" maxlength="30"/>
					</td>
					<td class="table_td_subject" width="200">
						작성자
					</td>
					<td class="table_td_contents">
						<input id="srcUserWriter" name="srcUserWriter" type="text" value="" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
			</table>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
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