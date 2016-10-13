<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-400 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	int EndYear   = 2008;
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


<style type="text/css">
.evalWindow {
    display: none;
    position: absolute;
    top: 35%;
    left: 40%;
    width: 350px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
    z-index: 1003;
}
.jqmOverlay { background-color: #000; }

* html .bmtWindow {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}

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

<script type="text/javascript">
//////////////////////////////		초기화		/////////////////////////////////
var jq = jQuery;
$(document).ready(function(){
	
	$('#evalView').jqm();	//Dialog 초기화
	$("#standardCloseButton, .jqmClose").click(function(){	//Dialog 닫기
		$("#evalView").jqmHide();
	});
	$('#evalView').jqm().jqDrag('#processDialogHandle'); 	
	
	
	$('#srcButton').click(function (e) {
		fnSearch();
	});
	
	$('#viewButton').click(function (e) {
		$("#evalView").jqmShow();
	});
	
	$('#viewCloseButton').click(function (e) {
		$("#evalView").jqmHide();
	});
	
});
</script>

<script type="text/javascript">
//////////////////////////////		리사이징		/////////////////////////////////
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>
<script type="text/javascript">
//////////////////////////////		JqGrid		/////////////////////////////////
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/quality/selectQualityEvalList/list.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:[ 	'평가일자',			'공급사',		'평가자',		'종합점수',					'일반사항(5)',	'문서및기록관리(5)',	'자제관리(10)',	
		           	'생산공정관리(20)',	'설비관리(20)',	'검사관리(20)', 	'부적합및<br/>재발방지관리(15)',	'기타사항(5)',	'종합의견' ],
		colModel:[
			{name:'APPTYPE'			,index:'APPTYPE'		, width:100,align:"left",search:false,sortable:false, editable:false },
			{name:'VENDORNM'		,index:'VENDORNM'		, width:130,align:"left",search:false,sortable:false, editable:false },
			{name:'SPEC'			,index:'SPEC'			, width:100,align:"left",search:false,sortable:false, editable:false },
			{name:'BUSSINESSNM'		,index:'BUSSINESSNM'	, width:100,align:"left",search:false,sortable:false, editable:false },
			{name:'PRODTYPE1_NM'	,index:'PRODTYPE1_NM'	, width:100,align:"center",search:false,sortable:false, editable:false },
			{name:'PRODTYPE2_NM'	,index:'PRODTYPE2_NM'	, width:100,align:"center",search:false,sortable:false, editable:false },
			{name:'REQNM'			,index:'REQNM'			, width:100,align:"center",search:false,sortable:false, editable:false },
			{name:'APPNM'			,index:'APPNM'			, width:100,align:"center",search:false,sortable:false, editable:false },
			{name:'REQKIND'			,index:'REQKIND'		, width:100,align:"center",search:false,sortable:false, editable:false },
			{name:'APPSTEP'			,index:'APPSTEP'		, width:100,align:"left",search:false,sortable:false, editable:false },
			{name:'CURRSTEP'		,index:'CURRSTEP'		, width:100,align:"left",search:false,sortable:false, editable:false },
			{name:'APPKIND1'		,index:'APPKIND1'		, width:100,align:"left",search:false,sortable:false, editable:false },
			{name:'APPKIND2'		,index:'APPKIND2'		, width:100,align:"left",search:false,sortable:false, editable:false }
		],  
		postData: {
			
		},
		multiselect:false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	
		loadComplete: function() { },
		afterInsertRow: function(rowid, aData){

		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){ },
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	})
	.jqGrid("setLabel", "rn", "순번"); 
});

// $("#list").jqGrid('setGroupHeaders', {
// 	useColSpanStyle: true,
// 	groupHeaders:[
// 		{startColumnName: 'SOURCINGNM', numberOfColumns: 4, titleText: '상품정보'},
// 		{startColumnName: 'QUALITYSTD', numberOfColumns: 5, titleText: '품질정보'}
// 	]
// });
</script>

<script type="text/javascript">
//////////////////////////////		화면 기능		/////////////////////////////////
function fnSearch() {
    $("#list")
    .jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()})
    .trigger("reloadGrid");
}
</script>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frmSearch" name="frmSearch" onsubmit="return false;">
	<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
					<tr valign="top" style="height: 29px">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td class='ptitle'>품질경영평가
						</td>
						<td align="right" class='ptitle'>
							<button id='allExcelButton' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'><i class="fa fa-file-excel-o"></i> 일괄엑셀</button>
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
				<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr> 
					<tr>
						<td class="table_td_subject" width="100">평가년도</td>
						<td class="table_td_contents">
							<select id="srcYear" name="srcYear" class="select" style="width: 70px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
								<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
							</select> 년
						</td>
						<td width="100" class="table_td_subject">공급사</td>
						<td class="table_td_contents">
							<input type="text" name="srcVendorNm" id="srcVendorNm" style="width: 150px;vertical-align: middle;" /> 
						</td>
						<td width="100" class="table_td_subject">평가자</td>
						<td class="table_td_contents">
							<input type="text" name="srcEvalUserNm" id="srcEvalUserNm" style="width: 150px;vertical-align: middle;" /> 
						</td>
					</tr>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td align="right" class='ptitle' >
				<button id='regButton' class="btn btn-primary btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class="fa fa-save"></i> 등록</button>
				<button id='delButton' class="btn btn-warning btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash"></i> 삭제</button>
				<button id='viewButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 평가기준보기</button>
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
	</table>
	<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
		<p>처리할 데이터를 선택 하십시오!</p>
	</div>
	<div id="dialog" title="Feature not supported" style="display:none;">
		<p>That feature is not supported.</p>
	</div>
	<div class="evalWindow evalView" id="evalView">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div id="processDialogHandle">
						<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			      			<tr>
			        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
			        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
			        				<h2>평가기준보기</h1>
			        			</td>
			        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
			        				<a href="#;" class="jqmClose">
			        				<img src="/img/contents/btn_close.png" class="jqmClose"  >
			        				</a>
			        			</td>
			        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
			      			</tr>
						</table>
					</div>
					<table width="100%"  border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
							<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
							<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
						</tr>
						<tr>
							<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
							<td bgcolor="#FFFFFF">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                                <tbody>
	                                	<tr valign="top">
	                                        <td width="20" valign="middle">
	                                            <img width="14" height="15" src="/img/system/bullet_ptitle1.gif">
	                                        </td>
	                                        <td height="29" class="ptitle">평가기준</td>
	                                    </tr>
	                                </tbody>
	                            </table>
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	                                <tr>
	                                    <td colspan="4" class="table_top_line"></td>
	                                </tr>
									<tr style="height: 25px;">
										<td  class="table_td_contents"> <b>A. 프로세스화 되어있고, 관리상태 매우 양호함(1.0)</b></td>
									</tr>
	                                <tr>
	                                    <td colspan="4" class="table_middle_line"></td>
	                                </tr>
									<tr style="height: 25px;">
										<td class="table_td_contents"> <b>B. 프로세스화는 미흡하나, 관리상태 양호함(0.8)</b></td>
									</tr>
	                                <tr>
	                                    <td colspan="4" class="table_middle_line"></td>
	                                </tr>
									<tr style="height: 25px;">
										<td class="table_td_contents"> <b>C.프로세스화는 양호하나, 관리상태 미흡함(0.6)</b></td>
									</tr>
	                                <tr>
	                                    <td colspan="4" class="table_middle_line"></td>
	                                </tr>
									<tr style="height: 25px;">
										<td class="table_td_contents"> <b>D.프로세스화 및 관리상태 모두 미흡함(0.4)</b></td>
									</tr>
	                                <tr>
	                                    <td colspan="4" class="table_middle_line"></td>
	                                </tr>
									<tr style="height: 25px;">
										<td class="table_td_contents"> <b>E.프로세스화 없고 관리상태 미흡함(0.2)</b></td>
									</tr>
	                                <tr>
	                                    <td colspan="4" class="table_middle_line"></td>
	                                </tr>
									<tr style="height: 25px;">
										<td class="table_td_contents"> <b>F.프로세스화 없고 관리되고 있지 않음(0)</b></td>
									</tr>
	                                <tr>
	                                    <td colspan="4" class="table_top_line"></td>
	                                </tr>
								</table>
								
								<p style="height: 5px"></p>
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td align="center">
											<button id="viewCloseButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</button>
										</td>
									</tr>
								</table>
							</td>
							<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
						</tr>
						<tr>
							<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
							<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
							<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>	
	
</form>
</body>
</html>