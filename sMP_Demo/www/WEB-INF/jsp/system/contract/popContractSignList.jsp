<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.UserDto" %>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList        = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	LoginUserDto        loginUserDto    = CommonUtils.getLoginUserDto(request);
	String              _menuId			= CommonUtils.getRequestMenuId(request);
	String              listHeight      = "$(window).height()-645 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String              svcTypeCd		= (String)request.getAttribute("svcTypeCd");
	String              contractVersion	= (String)request.getAttribute("contractVersion");
	String              contractNm		= (String)request.getAttribute("contractNm");
	String              contractSpecial	= (String)request.getAttribute("contractSpecial");
	
	contractNm = CommonUtils.decrypt(contractNm);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	fnContractSignList();	//그리드 초기화
	
	<%-- 버튼이벤트--%>
	$("#borgSeachBtn").click(function(){ fnSearch(); });
	$("#borgNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#popCloseBtn").click(function(){
		window.close();
	});
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>
<script type="text/javascript">

<%-- 구매사 계약서 리스트 --%>
function fnContractSignList() {
	$("#list").jqGrid({
		url:'/system/borg/selectContractSignList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['업체명','서명일시','서명자'],
		colModel:[
			{name:'BORGNM',index:'BORGNM', width:150, align:"left",search:false,sortable:true},						//업체명
			{name:'CONTRACT_DATE',index:'CONTRACT_DATE', width:120, align:"center",search:false,sortable:true},	//서명일시
			{name:'USERNM',index:'USERNM', width:120, align:"center",search:false,sortable:true}			//서명자
		],
		postData: {
			svcTypeCd:'<%=svcTypeCd%>',
			contractVersion:'<%=contractVersion%>',
			contractSpecial:'<%=contractSpecial%>',
			borgnNm:$("#borgnNm").val()
		},
		rowNum:15, rownumbers: false,rowList:[15,30,50], pager: '#pager',
		sortname: 'BORGNM', sortorder: 'ASC',
		height: 365,autowidth: true,
		caption:'<%=contractNm%>',
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		rownumbers:true
	});
}

<%-- 업체명 검색 --%>
function fnSearch(){
	$("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.borgNm = $("#borgNm").val();
	$("#list").trigger("reloadGrid");
}


</script>
<title>Insert title here</title>
</head>
<body>
<form id="frm" name="frm" onsubmit="return false;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="vendorDialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
						<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2><%=contractNm%> 서명</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose" id="popCloseBtn">
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
							<!-- 조회조건 -->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="3" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="80">업체명</td>
									<td class="table_td_contents">
										<input id="borgNm" name="borgNm" type="text" value="" size="20" maxlength="20" />
									</td>
									<td align="right">
										<button id="borgSeachBtn" class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
									</td>
								</tr>
								<tr>
									<td colspan="3" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="3" height='8'></td>
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
								<tr>
									<td height='8'></td>
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
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>