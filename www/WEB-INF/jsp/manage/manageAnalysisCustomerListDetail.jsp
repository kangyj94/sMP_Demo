<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>

<%
	//사업장 손익 실적 디테일
	//그리드의 width와 Height을 정의
	String listHeight = "400";
	String listHeight2 = "400";
	String listWidth = "400";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String srcResultFromYear = request.getParameter("srcResultFromYear");
	String srcResultFromMonth = request.getParameter("srcResultFromMonth");
	String srcResultToYear = request.getParameter("srcResultToYear");
	String srcResultToMonth = request.getParameter("srcResultToMonth");
	
	String clientId = request.getParameter("clientId");
	String clientNm = request.getParameter("clientNm");
	clientNm = new String(clientNm.getBytes("8859_1"),"UTF-8");
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
	$('#srcResultFromYear').keydown(function(e){ if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultFromMonth').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToYear').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToMonth').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	
	// 코드값 조회
	fnInitCodeData();
	
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
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelButton2").click(function(){ exportExcel2(); });
});
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
	$("#list2").setGridHeight(<%=listHeight2 %>);
	$("#list2").setGridWidth($(window).width() - 580 + Number(gridWidthResizePlus));
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var staticNum = 0;	//list2, 그리드를 한번만 초기화하기 위해
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisCustomerListDetailJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['구매사명','매출금액','branchId','매출Id'],
		colModel:[
			{ name:'borgnm',index:'borgnm',width:230,align:"left",search:false,sortable:true,editable:false },//고객사명
			{ name:'sale_requ_amou',index:'sale_requ_amou',width:120,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매출금액
			{ name:'branchid',index:'branchid',hidden:true,search:false },//법인Id
			{ name:'sale_sequ_numb',index:'sale_sequ_numb',hidden:true,search:false }//매출Id
		],
		postData: {
			srcResultFromYear:$('#srcResultFromYear').val(),
			srcResultFromMonth:$('#srcResultFromMonth').val(),
			srcResultToYear:$('#srcResultToYear').val(),
			srcResultToMonth:$('#srcResultToMonth').val(),
			srcClientId:'<%=clientId%>'
		},
		rowNum:0,rownumbers:false,rownumbers:true,
		height:<%=listHeight%>,width:<%=listWidth%>,
		sortname:'',sortorder:'',
		caption:"구매사 매출 현황",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		footerrow:true,userDataOnFooter:true,
		afterInsertRow: function(rowid, aData){},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		loadComplete:function() {
 			var rowCnt = jq("#list").getGridParam('reccount');
 			if(rowCnt>0) {
 				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
 				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
 				var branchid = selrowContent.branchid;
 				if(staticNum==0) {
 					fnInitProductList(branchid);
 					staticNum++;
 				}
 				jq("#list").setSelection(top_rowid);
 				fnTotalAmountSum();
 			} else {
 				jq("#list2").clearGridData();
 				jq("#list2").jqGrid("setCaption","&nbsp;");
 				fnTotalAmountSum();
 			}
		},
		onSelectRow:function(rowid,iRow,iCol,e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var branchid = selrowContent.branchid;
			var borgnm = selrowContent.borgnm;
			fnOnClickCustomerProductList(branchid,borgnm);
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: {root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
}
function fnInitProductList(branchid) {
	jq("#list2").jqGrid({
		url:'/analysis/analysisCustomerProductListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['상품명','매출금액'],
		colModel:[
			{ name:'good_name',index:'good_name',width:200,align:"left",search:false,sortable:true,editable:false },//품목명
			{ name:'sale_prod_amou',index:'sale_prod_amou',width:180,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매출금액
		],
		postData: {
			srcResultFromYear:$('#srcResultFromYear').val(),
			srcResultFromMonth:$('#srcResultFromMonth').val(),
			srcResultToYear:$('#srcResultToYear').val(),
			srcResultToMonth:$('#srcResultToMonth').val(),
			branchid:branchid
		},
		rowNum:30, rownumbers: true, rowList:[30,50,100,500,1000], pager: '#pager',
		height:<%=listHeight2 %>,width:550,
		sortname:'',sortorder:'',
		caption:"사업장의 상품별 손익실적",
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
function fnSearch() {
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcResultFromYear = $('#srcResultFromYear').val();
	data.srcResultFromMonth = $('#srcResultFromMonth').val();
	data.srcResultToYear = $('#srcResultToYear').val();
	data.srcResultToMonth = $('#srcResultToMonth').val();
	data.srcClientId = '<%=clientId%>';
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function fnOnClickCustomerProductList(branchid,borgnm) {
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcResultFromYear = $('#srcResultFromYear').val();
	data2.srcResultFromMonth = $('#srcResultFromMonth').val();
	data2.srcResultToYear = $('#srcResultToYear').val();
	data2.srcResultToMonth = $('#srcResultToMonth').val();
	data2.branchid = branchid;
	jq("#list2").jqGrid("setCaption", "<font color='blue'>["+borgnm+"]</font>의 상품별 매출 현황");
	jq("#list2").jqGrid("setGridParam", { "postData": data2 });
	jq("#list2").trigger("reloadGrid");
}

function fnTotalAmountSum() {
	var rowCnt = jq("#list").getGridParam('reccount');
	var SumTotalamount = [];
	var msg = '';
	if(rowCnt>0) {
		for(var j=1; j<4; j++) {
			var sum = 0 ;
			var mm = "";
			switch (j) {
				case 1:
					mm = "sale_requ_amou";
					break;
				case 2:
					mm = "purc_prod_amou";
					break;
				case 3:
					mm = "prof_amou";
					break;
			}
			
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				sum += Number(jq("#list").jqGrid('getRowData',rowid)[mm]);
			}
			SumTotalamount.push(sum);
 			//msg += '\n ['+j+'] value ['+SumTotalamount[Number(j)-1]+']';
 			//alert(msg);
		}
		jq("#list").jqGrid("footerData","set",{ borgnm:'합계'
															,sale_requ_amou:fnComma(SumTotalamount[0])
															,purc_prod_amou:fnComma(SumTotalamount[1])
															,prof_amou:fnComma(SumTotalamount[2]) },false);
	} else {
		fnClearTotalAmountSum();
	}
}
function fnClearTotalAmountSum() {
	jq("#list").jqGrid("footerData","set",{ borgnm:'합계',sale_requ_amou:'0',purc_prod_amou:'0',prof_amou:'0' },false);
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

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['사업장명','매출금액'];	//출력컬럼명
	var colIds = ['borgnm','sale_requ_amou'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou'];	//숫자표현ID
	var sheetTitle = "사업장 손익실적";	//sheet 타이틀
	var excelFileName = "analysisBranchList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcel2() {
	var colLabels = ['상품명','매출금액'];	//출력컬럼명
	var colIds = ['good_name','sale_prod_amou'];	//출력컬럼ID
	var numColIds = ['sale_prod_amou'];	//숫자표현ID
	var sheetTitle = "상품별 손익실적";	//sheet 타이틀
	var excelFileName = "analysisBranchList";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>

<body>
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">사업장 매출 현황</td>
				<td align="right" class="ptitle">
					<img id="srcButton" src="/img/system/btn_type3_search.gif" style="width:65px;height:22px;cursor:pointer;" /></td>
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
				<td class="table_td_subject" width="80">실적년월</td>
				<td class="table_td_contents" width="300">
					<select id="srcResultFromYear" name="srcResultFromYear" class="select"></select>년
					<select id="srcResultFromMonth" name="srcResultFromMonth" class="select"></select>월 ~
					<select id="srcResultToYear" name="srcResultToYear" class="select"></select>년
					<select id="srcResultToMonth" name="srcResultToMonth" class="select"></select>월
				</td>
				<td class="table_td_subject" width="80">법인명</td>
				<td colspan="3" class="table_td_contents">
					<span id="clientNm"><%=clientNm %></span>
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
	<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<col width="450" />
			<col />
			<col width="100%"/>
			<tr>
				<td valign="top" width="610" height="18" align="right">
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;' /></a>
				</td>
				<td></td>
				<td valign="top" align="right">
					<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;' /></a>
				</td>
			</tr>
			<tr>
				<td valign="top" width="610">
					<div id="jqgrid">
						<table id="list"></table>
					</div>
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td valign="top">
					<div id="jqgrid">
						<table id="list2"></table>
						<div id="pager"></div>
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