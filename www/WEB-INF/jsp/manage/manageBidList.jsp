<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");

	//사용자 정보
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	//메뉴Id
		String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId")); 
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-274 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	
	//날짜 세팅
	String srcInsert_FromDt = CommonUtils.getCustomDay("DAY", -7);
	String srcInsert_EndDt = CommonUtils.getCurrentDate();

%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$.post(	//조회조건의 입찰상태 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"BIDSTATE", isUse:"1"},
		function(arg) {
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcBidState").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			getBidClassifyCodeList();//입찰구분 코드리스트
			
		}
	);
	
	
	//버튼이벤트
	$("#srcButton").click( function() { 
		$("#srcBidid").val($.trim($("#srcBidid").val()));
		$("#srcBidname").val($.trim($("#srcBidname").val()));
		$("#srcBidState").val($.trim($("#srcBidState").val()));
		$("#srcStand_good_name").val($.trim($("#srcStand_good_name").val()));
		$("#srcStand_good_spec_desc").val($.trim($("#srcStand_good_spec_desc").val()));
		fnSearch();
	});
	
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	
	$("#srcBidid").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcBidname").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcBidState").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcStand_good_name").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcInsert_FromDt").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcInsert_EndDt").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcStand_good_spec_desc").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function() { exportExcel(); });
	
	//날짜 세팅
	$("#srcInsert_FromDt").val("<%=srcInsert_FromDt%>");
	$("#srcInsert_EndDt").val("<%=srcInsert_EndDt%>");
	
	
	

	
});

//날짜 조회 및 스타일
$(function() {
	$("#srcInsert_FromDt").datepicker( {
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcInsert_EndDt").datepicker( {
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});	

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcBidid = $("#srcBidid").val();
	data.srcBidname = $("#srcBidname").val();
	data.srcBidState = $("#srcBidState").val();
	data.srcStand_good_name = $("#srcStand_good_name").val();
	data.srcInsert_FromDt = $("#srcInsert_FromDt").val();
	data.srcInsert_EndDt = $("#srcInsert_EndDt").val();
	data.srcStand_good_spec_desc = $("#srcStand_good_spec_desc").val();
	data.bidClassify = $("#bidClassify").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['입찰번호','구분','입찰명','상품명','대표상품규격','입찰상태','시작일자','종료일자','등록자'];//출력컬럼명
	var colIds = ['bidid','bid_classify','bidname','stand_good_name','stand_good_spec_desc','bidstateNm','insert_date','bidenddate','insert_user_id'];//출력컬럼ID
	var numColIds = ['bidid'];//숫자표현ID
	var sheetTitle = "입찰조회";//sheet 타이틀
	var excelFileName = "newProductBidList";//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['입찰번호','구분','입찰명','상품명','대표상품규격','입찰상태','시작일자','종료일자','등록자'];//출력컬럼명
	var colIds = ['bidid','bid_classify','bidname','stand_good_name','stand_good_spec_desc','bidstateNm','insert_date','bidenddate','insert_user_id'];//출력컬럼ID
	var numColIds = ['bidid'];//숫자표현ID
	var sheetTitle = "입찰조회";//sheet 타이틀
	var excelFileName = "newProductBidList";//file명
	
	var actionUrl = "/product/newProductBidListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcBidid';
	fieldSearchParamArray[1] = 'srcBidname';
	fieldSearchParamArray[2] = 'srcBidState';
	fieldSearchParamArray[3] = 'srcStand_good_name';
	fieldSearchParamArray[4] = 'srcInsert_FromDt';
	fieldSearchParamArray[5] = 'srcInsert_EndDt';
	fieldSearchParamArray[6] = 'srcStand_good_spec_desc';
	fieldSearchParamArray[7] = 'srcVendorid';
	fieldSearchParamArray[8] = 'bidClassify';

	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//구분 코드리스트
function getBidClassifyCodeList(){
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"bid_classify",
			isUse:"1"
		},
		function(arg){
			var list = eval('('+arg+')').list;
			for(var i=0; i<list.length; i++){
				$("#bidClassify").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
			}
			initList();	//그리드 초기화
		}
	);
}

//입찰의 상세 페이지
function editRow(rowid) {
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	var bidid = selrowContent.bidid;
	var bidstate = selrowContent.bidstate;
	var popurl = "/manage/manageBidDdetail.sys?_menuId="+<%=menuId%>+"&bidid="+bidid+"&bidstate="+bidstate;
	window.open(popurl, 'okplazaPop', 'width=900, height=580, scrollbars=yes, status=no, resizable=no');
}
</script>

<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/newProductBidListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['입찰번호','구분','입찰명','상품명','대표규격','입찰상태','시작일자','종료일자','등록자','투찰여부','bidstate'],
		colModel:[
			{name:'bidid',index:'bidid',width:60,align:"center",search:false,sortable:true,editable:false},//입찰번호
			{name:'bid_classify',index:'bid_classify',width:60,align:"center",search:false,sortable:true,editable:false},//입찰구분
			{name:'bidname',index:'bidname',width:160,align:"left",search:false,sortable:true,editable:false },//입찰명
			{name:'stand_good_name',index:'stand_good_name',width:200,align:"left",search:false,sortable:true,editable:false },//상품명
			{name:'stand_good_spec_desc',index:'stand_good_spec_desc',width:200,align:"left",search:false,sortable:true,editable:false },//대표상품규격
			{name:'bidstateNm',index:'bidstateNm',width:70,align:"center",search:false,sortable:false,editable:false },//입찰상태
			{name:'insert_date',index:'insert_date',width:100,align:"center",search:false,sortable:false,editable:false },//시작일자
			{name:'bidenddate',index:'bidenddate',width:100,align:"center",search:false,sortable:false,editable:false },//종료일자
			{name:'insert_user_id',index:'insert_user_id',width:60,align:"center",search:false,sortable:false,editable:false },//등록자
			{name:'vendorbidstate',index:'vendorbidstate',width:60,align:"center",search:false,sortable:false ,editable:false,formatter:"select",editoptions:{value:"10:미투찰;15:투찰;50:투찰"} },//투찰,낙찰상태
			{name:'bidstate',index:'bidstate',width:60,align:"center",search:false,sortable:false ,editable:false, hidden:true }
		],
		postData: {
			srcInsert_FromDt:$("#srcInsert_FromDt").val(),
			srcInsert_EndDt:$("#srcInsert_EndDt").val(),
			bidClassify:$("#bidClassify").val()
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight %>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname:'insert_date',sortorder:'desc',
		caption:'입찰조회',
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() { },
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var cm = $("#list").jqGrid('getGridParam','colModel');
			if(cm[iCol]!=undefined && cm[iCol].index == 'bidid') {
				if(selrowContent.vendorbidstate == '10' || 'ADM'=='<%=userInfoDto.getSvcTypeCd() %>') {
					editRow(rowid);
				}
			}
		},
		afterInsertRow:function(rowid, aData) {
				jq("#list").setCell(rowid,'bidid','',{color:'#0000ff'});
				jq("#list").setCell(rowid,'bidid','',{cursor:'pointer'});  
		},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: {root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { manageManual(); });	//메뉴얼호출
});

function manageManual(){
	var header = "";
	var manualPath = "";
	//입찰조회
	header = "입찰조회";
	manualPath = "/img/manual/manage/manageBidListManual.JPG";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" />
					</td>
					<td height="29" class="ptitle">입찰조회
						&nbsp;<span id="question" class="questionButton">도움말</span>
					</td>
					<td align="right" class="ptitle">
						<a href="#">
							<img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
						</a>
						<img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style="cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" /></td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">입찰번호</td>
					<td class="table_td_contents">
						<input id="srcBidid" name="srcBidid" type="text" value="" size="" maxlength="50" /></td>
					<td class="table_td_subject" width="100">입찰명</td>
					<td class="table_td_contents">
						<input id="srcBidname" name="srcBidname" type="text" value="" size="" maxlength="50" /></td>
					<td colspan="1" class="table_td_subject" width="100">입찰상태</td>
					<td class="table_td_contents">
						<select id="srcBidState" name="srcBidState" class="select">
							<option value="">전체</option>
						</select></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">상품명</td>
					<td colspan="3" class="table_td_contents">
						<input id="srcStand_good_name" name="srcStand_good_name" type="text" value="" size="" maxlength="50" style="width:400px" /></td>
					<td colspan="1" class="table_td_subject">시작일</td>
					<td class="table_td_contents">
						<input type="text" name="srcInsert_FromDt" id="srcInsert_FromDt" style="width: 75px;vertical-align: middle;" /> ~ 
						<input type="text" name="srcInsert_EndDt" id="srcInsert_EndDt" style="width: 75px;vertical-align: middle;" /></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">상품규격</td>
					<td colspan="3" class="table_td_contents">
						<input id="srcStand_good_spec_desc" name="srcStand_good_spec_desc" type="text" value="" size="" maxlength="50" style="width:400px" />
					</td>
					<td class="table_td_subject">구분</td>
					<td class="table_td_contents">
						<select id="bidClassify" name="bidClassify">
							<option value="">전체</option>
						</select>
						
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="bottom">
			<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
			<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
		</td>
	</tr>
	<tr>
		<td>
			<div id="jqgrid">
				<table id="list"></table>
				<div id="pager"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

</body>
</html>