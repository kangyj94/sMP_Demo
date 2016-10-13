<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="kr.co.bitcube.evaluate.dto.EvaluateDto"%>
<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%
	//그리드의 width와 Height을 정의
	
	String listHeight =	"$(window).height()-248 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	@SuppressWarnings("unchecked")
	List<EvaluateDto> evalRow = (List<EvaluateDto>) request.getAttribute("evalRow");
	
	@SuppressWarnings("unchecked")
	List<EvaluateDto> evalCol = (List<EvaluateDto>) request.getAttribute("evalCol");
	
	String colStr = "";
	String rowStr = "";
	String colNmStr = "";
	
	if(evalRow != null && evalRow.size() > 0){
		for(EvaluateDto dto : evalRow){
			colStr += ",'" + dto.getEvalTypeNm() + "'";
			rowStr += "{name:'evalTypeCd_"+dto.getEvalTypeCd()+"',index:'evalTypeCd_"+dto.getEvalTypeCd()+"', width:80,align:'center',search:false,sortable:false,editable:false},";
			colNmStr += ",'evalTypeCd_" + dto.getEvalTypeCd() + "'";
		}
	}

	String excelColStr = "";
	String excelCol = "";
			
	if(evalCol != null && evalCol.size() > 0){
		for(EvaluateDto dto : evalCol){
			excelColStr += ",'" + dto.getEvalselNm() + "'";
			excelCol += ",'evalSelCd_" + dto.getEvalselCd() + "'";
		}
	}
	
    int EndYear   = 2003;
    int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
    int yearCnt = StartYear - EndYear + 1;
    String[] srcYearArr = new String[yearCnt];
    for(int i = 0 ; i < yearCnt ; i++){
    	srcYearArr[i] = (StartYear - i) + "";
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
	initList();
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	$("#srcButton").click(function(){ fnSearch(); });
	$("#srcBranchNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch()();
		}
	});	
	
	$("#srcUserNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch()();
		}
	});	
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/evaluate/evaluateListJQgrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['사업장명', '고객유형', '평가자', '운영담당자' <%=colStr%>, '평가일'],
		colModel:[
			{name:'branchNm',index:'branchNm', width:250,align:"left",search:false,sortable:true,
				editable:false 
			},	//고객사
			{name:'workNm',index:'workNm', width:90,align:"center",search:false,sortable:true,
				editable:false 
			},	//고객유형
			{name:'userNm',index:'userNm', width:90,align:"center",search:false,sortable:true,
				editable:false 
			},	//평가자
			{name:'evalUserNm',index:'evalUserNm', width:80,align:"center",search:false,sortable:true,
				editable:false 
			},	//운영담당자
			<%=rowStr%>
			{name:'evalDate',index:'evalDate', width:80,align:"center",search:false,sortable:true,
				editable:false 
			}	//등록일
		],
		postData: {
			srcBranchNm:$("#srcBranchNm").val(),
			srcEvalUserNm:$("#srcEvalUserNm").val(),
			srcWorkId:$("#srcWorkId").val(),
			srcUserNm:$("#srcUserNm").val(),
			srcEvalYear:$("#srcEvalYear").val(),
			srcEvalMonth:$("#srcEvalMonth").val()			
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000,5000], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'evalDate', sortorder: "desc",
		caption:"평가내역 조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcBranchNm = $("#srcBranchNm").val();
	data.srcEvalUserNm = $("#srcEvalUserNm").val();
	data.srcWorkId = $("#srcWorkId").val();
	data.srcUserNm = $("#srcUserNm").val();
	data.srcEvalYear = $("#srcEvalYear").val();
	data.srcEvalMonth = $("#srcEvalMonth").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['사업장명', '고객유형', '평가자', '운영담당자' <%=colStr%>, '평가일'];	//출력컬럼명
	var colIds = ['branchNm', 'workNm', 'userNm', 'evalUserNm' <%=colNmStr%>, 'evalDate'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "평가내역 조회";	//sheet 타이틀
	var excelFileName = "evaluateList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['사업장명', '고객유형', '평가자', '운영담당자','평가항목' <%=excelColStr%>, '평가일', '평가사유'];	//출력컬럼명
	var colIds = ['branchNm', 'workNm', 'userNm', 'evalUserNm','evalTypeNm' <%=excelCol%>, 'evalDate', 'evalDesc'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "평가내역 조회";	//sheet 타이틀
	var excelFileName = "evaluateList";	//file명
	
	var actionUrl = "/evaluate/admEvaluateListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcBranchNm';
	fieldSearchParamArray[1] = 'srcEvalUserNm';
	fieldSearchParamArray[2] = 'srcWorkId';
	fieldSearchParamArray[3] = 'srcUserNm';
	fieldSearchParamArray[4] = 'srcEvalYear';
	fieldSearchParamArray[5] = 'srcEvalMonth';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

</script>

</head>
<body>
<form id="frm" name="frm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>평가내역 조회</td>
						<td align="right">
							<a href="#">
								<img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
								<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
							</a>
						</td>
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
						<td class="table_td_subject" width="100">평가고객사</td>
						<td class="table_td_contents">
							<input id="srcBranchNm" name="srcBranchNm" type="text" value="" size="20" maxlength="30" />
    					</td>
						<td width="80" class="table_td_subject">운영담당자</td>
						<td class="table_td_contents">
		                	<select id="srcEvalUserNm" name="srcEvalUserNm" class="select" style="width: 120px;">
                            	<option value="">전체</option>
<%
   @SuppressWarnings("unchecked")
   List<EvaluateDto> admUserList = (List<EvaluateDto>) request.getAttribute("admUserList");

   if(admUserList != null && admUserList.size() > 0){

      for(EvaluateDto userDto : admUserList){
%>                              
                                 <option value="<%=userDto.getUserId()%>"><%=userDto.getUserNm()%></option>
<%
      }
   }
%>                              
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
					</tr>
					<tr>
						<td colspan="6" height="1" bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">평가자명</td>
						<td class="table_td_contents">
							<input id="srcUserNm" name="srcUserNm" type="text" value="" size="20" maxlength="30" />
    					</td>
						<td class="table_td_subject" width="100">평가년월</td>
						<td class="table_td_contents">
                        	<select id="srcEvalYear" name="srcEvalYear" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                           		<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                        	</select> 년                   	
                        	<select id="srcEvalMonth" name="srcEvalMonth" class="select" style="width: 40px;">
<%
   for(int i = 0 ; i < 12 ; i++){
	   String strMonth = "";
	   if(i + 1 < 10) { strMonth = "0" + (i + 1); } else { strMonth = (i + 1) + ""; }
%>
                           		<option value='<%=strMonth%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=strMonth %></option>
<%      
   }
%>                        
                        	</select> 월
    					</td>
					</tr>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table> <!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="right">
				<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
				<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
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
</form>
</body>
</html>