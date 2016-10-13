<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>

<%
	//그리드의 width와 Height을 정의
	String listHeight2 = "$(window).height()-220 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String srcResultFromYear = request.getParameter("srcResultFromYear");
	String srcResultFromMonth = request.getParameter("srcResultFromMonth");
	String srcResultToYear = request.getParameter("srcResultToYear");
	String srcResultToMonth = request.getParameter("srcResultToMonth");
	
	String vendorId = request.getParameter("vendorId");
	String vendorNm = request.getParameter("vendorNm");
	vendorNm = new String(vendorNm.getBytes("8859_1"),"UTF-8");
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/excanvas.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqRangeSlider.min.js" type="text/javascript"></script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	//Object Event
	$("#srcButton").click( function() { fnSearch(); });
	$('#srcResultFromYear').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultFromMonth').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToYear').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToMonth').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	
	// 코드값 조회
	fnInitCodeData();
	
	$("#excelButton2").click(function(){ exportExcel2(); });
	

});
	// Component Data Bind 
function fnInitCodeData() {
	var d = new Date();
	var currentYear = leadingZeros(d.getFullYear(), 4);
	for(var i=currentYear;i><%=srcResultFromYear%>-1;i--) {
		var strYear = i;
		$('#srcResultFromYear').append("<option value='"+strYear+"'>"+strYear+"</option>");
		$('#srcResultToYear').append("<option value='"+strYear+"'>"+strYear+"</option>");
	}
	for(var i=1;i<13;i++) {
		var strMonth = '';
		if(i<10) { strMonth = "0"+i; } else { strMonth = i; }
		$('#srcResultFromMonth').append("<option value='"+strMonth+"'>"+strMonth+"</option>");
		$('#srcResultToMonth').append("<option value='"+strMonth+"'>"+strMonth+"</option>");
	}
	
	// 화면 초기화
	fnInitComponent();
}

// 화면 component 상태 초기화
function fnInitComponent() {
	//실적년월
	$('#srcResultFromYear').val('<%=srcResultToYear%>');
	$('#srcResultFromMonth').val('<%=srcResultFromMonth%>');
	$('#srcResultToYear').val('<%=srcResultToYear%>');
	$('#srcResultToMonth').val('<%=srcResultToMonth%>');
	
	initList();	//그리드 초기화
	}
$(window).bind('resize', function() {
	$("#list2").setGridHeight(<%=listHeight2 %>);
	$("#list2").setGridWidth($(window).width()-50 + Number(gridWidthResizePlus));
}).trigger('resize');
</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList(vendorid) {
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisVendoerProductListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['상품명','매출금액','매입금액','손익금액'],
		colModel:[
			{ name:'good_name',index:'good_name',width:265,align:"left",search:false,sortable:true,editable:false },//품목명
			{ name:'sale_prod_amou',index:'sale_prod_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매출금액
			{ name:'purc_prod_amou',index:'purc_prod_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매입금액
			{ name:'prof_amou',index:'prof_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//손익금액
		],
		postData: {
			srcResultFromYear:$('#srcResultFromYear').val(),
			srcResultFromMonth:$('#srcResultFromMonth').val(),
			srcResultToYear:$('#srcResultToYear').val(),
			srcResultToMonth:$('#srcResultToMonth').val(),
			vendorid:'<%=vendorId%>'
		},
		rowNum:0,rownumbers:false,rownumbers:true,
		height:<%=listHeight2 %>,autowidth:true,
		sortname:'',sortorder:'',
		caption:"<font color='blue'>[<%=vendorNm%>]</font> 상품별 손익실적 (단위: 천원)",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {},
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		afterInsertRow:function(rowid, aData) {},
		loadError:function(xhr,st,str) { $("#list2").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function fnSearch(vendorid,borgnm) {
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcResultFromYear = $('#srcResultFromYear').val();
	data2.srcResultFromMonth = $('#srcResultFromMonth').val();
	data2.srcResultToYear = $('#srcResultToYear').val();
	data2.srcResultToMonth = $('#srcResultToMonth').val();
	jq("#list2").jqGrid("setGridParam", { "postData": data2 });
	jq("#list2").trigger("reloadGrid");
}


function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)) {
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

//사용자 함수
function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	if(n.length < digits) {
		for(var i = 0; i < digits - n.length; i++)
			zero += '0';
	}
	return zero + n;
}

function exportExcel2() {
	var colLabels = ['상품명','매출금액','매입금액','손익금액'];	//출력컬럼명
	var colIds = ['good_name','sale_prod_amou','purc_prod_amou','prof_amou'];	//출력컬럼ID
	var numColIds = ['sale_prod_amou','purc_prod_amou','prof_amou'];	//숫자표현ID
	var sheetTitle = "상품별 손익실적";	//sheet 타이틀
	var excelFileName = "analysisVendorList";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>

<body>
<form id="frm" name="frm" method="post" onsubmit="return false;">
<table width="98%" border="0" cellspacing="0" cellpadding="0" style="margin-left: 5px;">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">공급사별 손익실적</td>
				<td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
					<button id='srcButton' class="btn btn-default btn-sm"><i class="fa fa-search"></i> 조회</button>
				</td>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 컨텐츠 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="4" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="60">실적년월</td>
				<td class="table_td_contents" width="65%">
					<select id="srcResultFromYear" name="srcResultFromYear" class="select"></select>년
					<select id="srcResultFromMonth" name="srcResultFromMonth" class="select"></select>월 
					~
					<select id="srcResultToYear" name="srcResultToYear" class="select"></select>년
					<select id="srcResultToMonth" name="srcResultToMonth" class="select"></select>월
				</td>
				<td class="table_td_subject" width="60">공급사</td>
				<td class="table_td_contents" width="35%">
					<%=vendorNm %>
					<input id="srcVendorId" name="srcVendorId" type="hidden" value="<%=vendorId %>>" />
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td colspan="4" class="table_top_line"></td>
			</tr>
		</table>
		<!-- 컨텐츠 끝 -->
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<col width="450" />
			<col />
			<col width="100%"/>
			<tr>
				<td valign="top" align="right">
					<button id='excelButton2' class="btn btn-default btn-xs"><i class="fa fa fa-file-excel-o"></i> 엑셀</button>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<div id="jqgrid">
						<table id="list2"></table>
					</div>
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>

<!-------------------------------- Dialog Div Start -------------------------------->
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>