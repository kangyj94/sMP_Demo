<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-315 + Number(gridHeightResizePlus)";
	
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!------------------------------- 다른조직 사용자 추가 ------------------------------->
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>

<style>
th.ui-th-column div{
	white-space:normal !important;
	height:auto !important;
	padding:2px;
}
</style>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" onsubmit="return false;">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="25" class='ptitle'>공급사 조회</td>
					<td align="right" class='ptitle'>
						<button id='srcUsrButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 사용자 조회</button>
						<button id='excelButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
						<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
				<tr><td height="1"></td></tr>
			</table>
			
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="12" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">공급사명</td>
					<td class="table_td_contents">
						<input id="srcVendorNm" name="srcVendorNm" type="text" size="20" maxlength="50" value="<%if(isVendor){out.print(loginUserDto.getBorgNm());} %>"/>
					</td>
					<td class="table_td_subject" width="100">사업자등록번호</td>
					<td class="table_td_contents">
						<input id="srcBusinessNum" name="srcBusinessNum" type="text" size="20" maxlength="50" />
					</td>
					<td class="table_td_subject" width="80">대표자명</td>
					<td class="table_td_contents">
						<input id="srcPressentNm" name="srcPressentNm" type="text"/>
					</td>
					<td width="80" class="table_td_subject">소재지</td>
					<td class="table_td_contents">
						<select id="srcAreaType" name="srcAreaType" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<td width="80" class="table_td_subject">상태</td>
					<td class="table_td_contents">
						<select id="srcIsUse" name="srcIsUse" class="select">
							<option value="1">정상</option>
							<option value="0">종료</option>
							<option value="">전체</option>
						</select>
					</td>
<%if(!isVendor){ %>
					<td width="80" class="table_td_subject">구분</td>
					<td class="table_td_contents">
						<select id="classify" name="classify" class="select">
							<option value="">전체</option>
						</select>
					</td>
<%}%>
				</tr>
				<tr>
					<td colspan="12" class="table_top_line"></td>
				</tr>
				<tr>
					<td height="5"></td>
				</tr>
			</table>
			<table width="1500px" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
				<col width="100%"/>
				<tr>
					<td wid>
						<table id="list"></table>
						<div id="pager"></div>
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
<script type="text/javascript">
var jq = jQuery;
<%-- init start --%>
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").jqGrid( 'setGridWidth', 1500);
	
}).trigger('resize');  

$(document).ready(function(){
	$.post(	//조회조건의 권역세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/getCodeList.sys',
		{codeTypeCd:"VEN_AREA_CODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcAreaType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
		}
	);
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"REQVENDOR_CLASSIFY",//신규자재 코드와 같이 사용
			isUse:"1"
		},
		function(arg){
			var reqVendorClassify = eval('('+arg+')').list;
			for(var i=0; i<reqVendorClassify.length; i++){
				$("#classify").append("<option value='"+reqVendorClassify[i].codeVal1+"'>"+reqVendorClassify[i].codeNm1+"</option>");
			}
		}
	);
	
	$("#srcButton").click(function(){
		jq("#list").jqGrid("setGridParam", {"page":1});
		var data = jq("#list").jqGrid("getGridParam", "postData");
		data.srcBusinessNum	= $("#srcBusinessNum").val();				//사업자등록번호
		data.srcAreaType	= $("#srcAreaType").val();					//소재지
		data.srcVendorNm	= $("#srcVendorNm").val();					//공급사명
		data.srcIsUse		= $("#srcIsUse").val();						//상태
		data.classify		= $("#classify").val();						//구분
		data.srcPressentNm	= $("#srcPressentNm").val();				//대표자명
		jq("#list").jqGrid("setGridParam", { "postData": data });
		jq("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
	});
	
	$("#excelButton").click(function(){ 
		$("#srcBusinessNum").val($.trim($("#srcBusinessNum").val()));
		$("#srcAreaType").val($.trim($("#srcAreaType").val()));
		$("#srcVendorNm").val($.trim($("#srcVendorNm").val()));
		$("#srcIsUse").val($.trim($("#srcIsUse").val()));
		$("#classify").val($.trim($("#classify").val()));
		$("#srcPressentNm").val($.trim($("#srcPressentNm").val()));
		fnAllExcelPrintDown();
	});
	
	$("#srcVendorNm").keydown(function(key){
		if(key.keyCode == 13){ $("#srcButton").click(); }
	});
	$("#srcBusinessNum").keydown(function(key){
		if(key.keyCode == 13){ $("#srcButton").click(); }
	});
	$("#srcPressentNm").keydown(function(key){
		if(key.keyCode == 13){ $("#srcButton").click(); }
	});
	
	$("#srcAreaType").change(function(){ $("#srcButton").click(); });
	$("#srcIsUse").change(function(){ $("#srcButton").click(); });
<%
	if(!isVendor){ 
%>
	$("#classify").change(function(){ $("#srcButton").click(); });
<%
	} 
%>
	$("#srcUsrButton").click(function(){
		location.href="/organ/organVendorUserList.sys?_menuId=<%=_menuId %>";
	});
});
<%-- init end --%>



<%-- function start --%>
function fnAllExcelPrintDown(){
	var colLabels		= ['업체코드', <%if(!isVendor){%>'구분'<%}%>,		'공급사명',	'사업자등록번호',	'주요상품',	'소재지',		'상태',	'대표전화번호',	'대표자명',		'우편번호',		'주소',		'상세주소',		'회사샵(#)메일',	'휴면공급사', '계약여부'];
	var colIds			= ['vendorCd', <%if(!isVendor){%> 'classify' <%}%>,	'vendorNm',	'businessNum',		'homePage',	'areaTypeNm',	'isUse','phoneNum',		'pressentNm',	'postAddrNum',	'addres',	'addresDesc',	'sharp_mail',		'userLoginYn', 'contractYn'];
	var numColIds		= [];					//숫자표현ID
	var sheetTitle		= "공급사조회";				//sheet 타이틀
	var excelFileName	= "vendorList";	//file명
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcBusinessNum';
	fieldSearchParamArray[1] = 'srcAreaType';
	fieldSearchParamArray[2] = 'srcVendorNm';
	fieldSearchParamArray[3] = 'srcIsUse';
	fieldSearchParamArray[4] = 'classify';
	fieldSearchParamArray[5] = 'srcPressentNm';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", fieldSearchParamArray,"/organ/organVendorListExcel.sys");
}


function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organVendorDetail.sys?vendorId=" + selrowContent.vendorId + "&_menuId=<%=_menuId%>";
		var popproperty = "dialogWidth:920px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
	    window.open(popurl, 'okplazaPop', 'width=920, height=670, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function userDetail(str){
	var row = $("#"+str).jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = $("#"+str).jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/selectVendorUserDetail.sys?borgId=" + selrowContent.borgId + "&userId=" + selrowContent.userId + "&_menuId=<%=_menuId %>";
		var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
		window.open(popurl, 'okplazaPop', 'width=600, height=440, scrollbars=yes, status=no, resizable=yes');
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}
<%-- function end --%>



<%--    jqgrid start    --%>
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organVendorListJQGrid.sys', 
		datatype: 'local',  
		mtype: 'POST',
		colNames:['업체코드', <%if(!isVendor){%>'구분',<%}%>'공급사명', '사업자등록번호','주요상품', '소재지', '상태', '대표전화번호', '대표자명', '우편번호', '주소','상세주소','회사샵(#)메일', '휴면공급사','계약여부', 'vendorId'],
		colModel:[
			{name:'vendorCd',index:'vendorCd', width:100,align:"center",search:false,sortable:false, 
				editable:false 
			},	//업체코드
<%if(!isVendor){%>
			{name:'classify',index:'classify', width:60,align:"center",search:false,sortable:false, 
				editable:false 
			},	//구분
<%}%>
			{name:'vendorNm',index:'vendorNm', width:180,align:"left",search:false,sortable:false, 
				editable:false 
			},	//공급사명
			{name:'businessNum',index:'businessNum', width:90,align:"center",search:false,sortable:false, 
				editable:false 
			},	//사업자등록번호
			{name:'homePage',index:'homePage', width:100,align:"center",search:false,sortable:false, 
				editable:false 
			},	//주요상품(홈페이지)
			{name:'areaTypeNm',index:'areaTypeNm', width:50,align:"center",search:false,sortable:false, 
				editable:false 
			},	//소재지
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:false,
				editable:false 
			},	//상태
			{name:'phoneNum',index:'phoneNum', width:100,align:"center",search:false,sortable:false,
				editable:false
			},	//대표전화번호
			{name:'pressentNm',index:'pressentNm', width:60,align:"center",search:false,sortable:false, 
				editable:false 
			},	//대표자명
			{name:'postAddrNum',index:'postAddrNum', width:60,align:"center",search:false,sortable:false, 
				editable:false 
			},	//우편번호
			{name:'addres',index:'addres', width:170,align:"left",search:false,sortable:false,
				editable:false 
			},	//주소
			{name:'addresDesc',index:'addresDesc', width:150,align:"left",search:false,sortable:false,
				editable:false 
			},	//상세주소
			{name:'sharp_mail',index:'sharp_mail', width:200,align:"left",search:false,sortable:false,
				editable:false, hidden:true
			},	//회사샾메일주소
			{name:'userLoginYn',index:'userLoginYn', width:80,align:"center",search:false,sortable:false,
				editable:false
			},	//휴면공급사
			{name:'contractYn',index:'contractYn', width:70,align:"center",search:false,sortable:true,editable:false},					//계약여부
			{name:'vendorId',index:'vendorId', hidden:true , key:true}	//vendorId
		],
		postData: {
			srcVendorNm:$("#srcVendorNm").val(),
			srcBusinessNum:$("#srcBusinessNum").val(),
			srcAreaType:$("#srcAreaType").val(),
<%if(isVendor){out.print("vendorSearchId:'"+loginUserDto.getBorgId()+"',");}%>
			srcIsUse:$("#srcIsUse").val(),
			classify:$("#classify").val(),
			srcPressentNm:$("#srcPressentNm").val()
		},
		rowNum:30, rownumbers: true, rowList:[100,150,200], pager: '#pager',
		height: <%=listHeight%>, autowidth:true,
		sortname: 'vendorId', sortorder: "desc",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $(this).getGridParam('reccount');
			if(rowCnt > 0){
				for(var i=0; i<rowCnt; i++){
					var rowid = $(this).getDataIDs()[i];
 					var selrowContent = $(this).jqGrid('getRowData',rowid);
 					var phoneNum = selrowContent.phoneNum;
 					phoneNum = fnSetTelformat(phoneNum);
 					$(this).jqGrid('setRowData',rowid,{phoneNum:phoneNum});
				}
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){ 
<%			if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				var cm = jq("#list").jqGrid("getGridParam", "colModel");
				var colName = cm[iCol];
				if(colName != undefined &&colName['index']=="vendorNm") { 
					jq("#list").setSelection(rowid);
					onDetail();
				}
<%			}%>
		},
		afterInsertRow: function(rowid, aData){
		<% if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
			jq("#list").setCell(rowid,'vendorNm','',{color:'#0000ff'}); 
			jq("#list").setCell(rowid,'vendorNm','',{cursor: 'pointer'});  
			jq("#list").setCell(rowid,'vendorNm','',{'text-decoration':'underline'});  
		<% } %>
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {phoneNum: fnSetTelformat(selrowContent.phoneNum)});
		},
		subGrid:true,
		subGridUrl:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organVendorUserListJQGrid.sys',
		subGridRowExpanded: function (grid_id, rowId) {
			var subgridTableId = grid_id + "_t";
			$("#" + grid_id).html("<table id='" + subgridTableId + "'></table>");
			$("#" + subgridTableId).jqGrid({
				url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organVendorUserListJQGrid.sys',
				datatype: 'json',
				mtype: 'POST',
				postData: {srcVendorId:rowId},
				colNames:['공급사', '소재지', '사용자명', '사용자ID', '사용자상태','공급사상태', '로그인여부', '전화번호', '이동전화번호','Email발송','SMS발송', '휴면여부','등록일', 'userId', 'borgId', 'isUseCd'],
				colModel:[
					{name:'vendorNm',index:'vendorNm', width:150,align:"left",search:false,sortable:false,editable:false ,hidden:true},			//공급사
					{name:'areaTypeNm',index:'areaTypeNm', width:50,align:"center",search:false,sortable:false,editable:false ,hidden:true},	//권역
					{name:'userNm',index:'userNm', width:80,align:"left",search:false,sortable:false,editable:false},							//사용자명.
					{name:'loginId',index:'loginId', width:80,align:"center",search:false,sortable:false,editable:false},						//사용자ID
					{name:'isUse',index:'isUse', width:80,align:"center",search:false,sortable:false,editable:false},							//상태
					{name:'borg_IsUse',index:'borg_IsUse', width:40,align:"center",search:false,sortable:false,editable:false ,hidden:true},	//상태
					{name:'isLogin',index:'isLogin', width:70,align:"center",search:false,sortable:false,editable:false ,hidden:true},			//로그인여부
					{name:'tel',index:'tel', width:90,align:"center",search:false,sortable:false,editable:false},								//전화번호
					{name:'mobile',index:'mobile', width:90,align:"center",search:false,sortable:false,editable:false},							//이동전화번호
					{name:'isEmail',index:'isEmail', width:60,align:"center",sortable:false,
						editable:false,
						edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}
					},																															//EMAIL발송
					{name:'isSms',index:'isSms', width:60,align:"center",sortable:false,
						editable:false,
						edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}
					},																															//SMS발송
					{name:'userLoginYn',index:'userLoginYn', width:80,align:"center",search:false,sortable:false,editable:false},				//휴면여부
					{name:'createDate',index:'createDate', width:80,align:"center",search:false,sortable:false,editable:false,hidden:true},		//등록일
					{name:'userId',index:'userId', hidden:true},	//userId
					{name:'borgId',index:'borgId', hidden:true},																				//borgId
					{name:'isUseCd',index:'isUseCd', hidden:true}
				],
				jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
				height:'100%',
				sortname: 'userNm', sortorder: "asc",
				afterInsertRow: function(rowid, aData) { 
<%					if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
						jq(this).setCell(rowid,'userNm','',{color:'#0000ff'}); 
						jq(this).setCell(rowid,'userNm','',{cursor: 'pointer'});  
						jq(this).setCell(rowid,'userNm','',{'text-decoration':'underline'});  
<%					} %>
					var selrowContent = $(this).jqGrid('getRowData',rowid);
					if(selrowContent.isUse != "정상"){
						$(this).setCell(rowid,'isUse','',{color:'#ff0000'}); 
					}
				},
				onCellSelect: function(rowid, iCol, cellcontent, target) {
<%					if(CommonUtils.isRoleExist(roleList, "COMM_READ")){ %> 
						jq(this).setSelection(rowid);  
						var cm = jq(this).jqGrid("getGridParam", "colModel");
						var colName = cm[iCol];
						if(colName != undefined &&colName['index']=="userNm") {
							userDetail(subgridTableId);
						}
<%					} %>
				},
				loadComplete: function() {
					var rowCnt = $(this).getGridParam('reccount');
					if(rowCnt > 0){
						for(var i=0; i<rowCnt; i++){
							var rowid = $(this).getDataIDs()[i];
		 					var selrowContent = $(this).jqGrid('getRowData',rowid);
		 					var tel = selrowContent.tel;
		 					tel = fnSetTelformat(tel);
		 					var mobile = selrowContent.mobile;
		 					mobile = fnSetTelformat(mobile);
		 					$(this).jqGrid('setRowData',rowid,{tel:tel});
		 					$(this).jqGrid('setRowData',rowid,{mobile:mobile});
						}
					}
				}
			});
		},	
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});
<%--    jqgrid end    --%>
</script>
</html>