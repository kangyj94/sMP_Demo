<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpVendorsDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-220 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(	//조회조건의 권역세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/getCodeList.sys',
		{codeTypeCd:"VEN_AREA_CODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcAreaType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			initList();	//그리드 초기화
		}
	);
	$("#srcVendorNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { 
		$("#srcVendorNm").val($.trim($("#srcVendorNm").val()));
		fnSearch(); 
	});
	$("#srcBusinessNum").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { 
		$("#srcBusinessNum").val($.trim($("#srcBusinessNum").val()));
		fnSearch(); 
	});
	$("#srcAreaType").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcIsUse").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { fnSearch(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	$("#regButton").click(function(){ addRow(); });
	$("#modButton").click(function(){ onDetail(); });
	
<%if(isVendor){%>
    $("#srcVendorNm").attr("disabled", true);
    $("#srcBusinessNum").attr("disabled", true);
    $("#srcAreaType").attr("disabled", true);
    $("#srcIsUse").attr("disabled", true);
<%}%>
	selectReqVendorClassify();//구분
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight%>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organVendorListJQGrid.sys', 
		datatype: 'local',
		mtype: 'POST',
		colNames:['업체코드', <%if(!isVendor){%>'구분',<%}%>'공급사명', '사업자등록번호','주요상품', '소재지', '상태', '대표전화번호', '대표자명', '우편번호', '주소','상세주소','회사샵(#)메일', '등록일', 'vendorId'],
		colModel:[
			{name:'vendorCd',index:'vendorCd', width:75,align:"center",search:false,sortable:true, 
				editable:false 
			},	//업체코드
<%if(!isVendor){%>
			{name:'classify',index:'classify', width:70,align:"center",search:false,sortable:true, 
				editable:false 
			},	//구분
<%}%>
			{name:'vendorNm',index:'vendorNm', width:150,align:"left",search:false,sortable:true, 
				editable:false 
			},	//공급사명
			{name:'businessNum',index:'businessNum', width:90,align:"center",search:false,sortable:true, 
				editable:false 
			},	//사업자등록번호
			{name:'homePage',index:'homePage', width:150,align:"center",search:false,sortable:true, 
				editable:false 
			},	//주요상품(홈페이지)
			{name:'areaTypeNm',index:'areaTypeNm', width:50,align:"center",search:false,sortable:true, 
				editable:false 
			},	//권역
			{name:'isUse',index:'isUse', width:40,align:"center",search:false,sortable:true,
				editable:false 
			},	//상태
			{name:'phoneNum',index:'phoneNum', width:80,align:"center",search:false,sortable:true,
				editable:false
			},	//대표전화번호
			{name:'pressentNm',index:'pressentNm', width:80,align:"center",search:false,sortable:true, 
				editable:false 
			},	//대표자명
			{name:'postAddrNum',index:'postAddrNum', width:50,align:"center",search:false,sortable:true, 
				editable:false 
			},	//우편번호
			{name:'addres',index:'addres', width:200,align:"left",search:false,sortable:true,
				editable:false 
			},	//주소
			{name:'addresDesc',index:'addresDesc', width:200,align:"left",search:false,sortable:true,
				editable:false 
			},	//상세주소
			{name:'sharp_mail',index:'sharp_mail', width:150,align:"left",search:false,sortable:true,
				editable:false 
			},	//상세주소
			{name:'createDate',index:'createDate', width:80,align:"center",search:false,sortable:true, 
				editable:false 
			},	//등록일
			{name:'vendorId',index:'vendorId', hidden:true
			}	//vendorId
		],
		postData: {
			srcVendorNm:$("#srcVendorNm").val(),
			srcBusinessNum:$("#srcBusinessNum").val(),
			srcAreaType:$("#srcAreaType").val(),
<%if(isVendor){out.print("vendorSearchId:'"+loginUserDto.getBorgId()+"',");}%>
			srcIsUse:$("#srcIsUse").val(),
			classify:$("#classify").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000,3000,5000], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'vendorId', sortorder: "desc",
		caption:"공급사 조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","onDetail();")%>
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
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
	data.srcBusinessNum = $("#srcBusinessNum").val();
	data.srcAreaType = $("#srcAreaType").val();
	data.srcVendorNm = $("#srcVendorNm").val();
	data.srcIsUse = $("#srcIsUse").val();
	data.classify = $("#classify").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organVendorDetail.sys?vendorId=" + selrowContent.vendorId + "&_menuId=<%=_menuId%>";
		var popproperty = "dialogWidth:920px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
	    window.open(popurl, 'okplazaPop', 'width=920, height=670, scrollbars=yes, status=no, resizable=no');
// 	    fnSearch();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function addRow(){
	var popurl = "/organ/organVendorReg.sys?_menuId=<%=_menuId%>";
	var popproperty = "dialogWidth:980px;dialogHeight=880px;scroll=auto;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=980, height=880, scrollbars=yes, status=no, resizable=no');
//     fnSearch();	
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['업체코드', <%if(!isVendor){%>'구분',<%}%>'공급사명', '사업자등록번호','주요상품', '소재지', '상태', '대표전화번호', '대표자명', '우편번호', '주소', '상세주소', '회사샵(#)메일', '등록일'];	//출력컬럼명
	var colIds = ['vendorCd',<%if(!isVendor){%>'classify',<%}%>'vendorNm','businessNum','homePage','areaTypeNm','isUse','phoneNum','pressentNm','postAddrNum','addres','addresDesc', 'sharp_mail','createDate'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "공급사 조회";	//sheet 타이틀
	var excelFileName = "organVendorList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH%>", figureColIds); //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['업체코드',<%if(!isVendor){%>'구분',<%}%> '공급사명', '사업자등록번호', '주요상품', '소재지', '상태', '대표전화번호', '대표자명', '우편번호', '주소', '상세주소', '회사샵(#)메일', '등록일'];	//출력컬럼명
	var colIds = ['vendorCd',<%if(!isVendor){%>'classify',<%}%>'vendorNm','businessNum','homePage','areaTypeNm','isUse','phoneNum','pressentNm','postAddrNum','addres','addresDesc', 'sharp_mail','createDate'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "공급사 조회";	//sheet 타이틀
	var excelFileName = "allOrganVendorList";	//file명
	
	var actionUrl = "/organ/organVendorListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcBusinessNum';
	fieldSearchParamArray[1] = 'srcAreaType';
	fieldSearchParamArray[2] = 'srcIsUse';
	fieldSearchParamArray[3] = 'srcVendorNm';
	fieldSearchParamArray[4] = 'classify';
	<%if(isVendor){out.print("fieldSearchParamArray[4] ='"+loginUserDto.getBorgId()+"';");}%>
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//공급사조회
	header = "공급사조회";
	manualPath = "/img/manual/vendor/organVendorList.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
<script type="text/javascript">
//구분
function selectReqVendorClassify(){
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
}
</script>

<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>
</head>
<body>
<form id="frm" name="frm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>공급사 조회
<%if(isVendor){ %>
						&nbsp;<span id="question" class="questionButton">도움말</span>
<%} %>
					</td>
					<td align="right">
						<a href="#"> <img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"> <img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
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
					<td colspan="10" class="table_top_line"></td>
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
					<td colspan="10" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right">
<%if(!isVendor){ %>         
			<a href="#">
				<img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
			</a> 
			<a href="#">
				<img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15"style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
			</a> 
<%} %>
			<a href="#">
				<img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15"style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
			</a> 
			<a href="#">
				<img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15"style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
			</a>
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
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>