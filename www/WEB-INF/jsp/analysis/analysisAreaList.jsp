<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "250";
	String listHeight2 = "272";
	String listWidth = "500";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String srcResultFromYear = "2010";//날짜 세팅
	String srcResultFromMonth = "01";
	String srcResultToYear = CommonUtils.getCustomDay("MONTH",-1).substring(0, 4);
	String srcResultToMonth = CommonUtils.getCustomDay("MONTH",-1).substring(5, 7);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/jquery.jqChart.css" rel="stylesheet" type="text/css" />
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/excanvas.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqChart.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqRangeSlider.min.js" type="text/javascript"></script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	//Object Event
	$("#srcButton").click( function() { fnSearch(); });
	$('#srcResultFromYear').keydown(function(e){ if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultFromMonth').keydown(function(e){ if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToYear').keydown(function(e){ if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToMonth').keydown(function(e){ if(e.keyCode==13) { $('#srcButton').click(); }});
	
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
		$('#srcResultFromYear').val('<%=srcResultFromYear%>');
		$('#srcResultFromMonth').val('<%=srcResultFromMonth%>');
		$('#srcResultToYear').val('<%=srcResultToYear%>');
		$('#srcResultToMonth').val('<%=srcResultToMonth%>');
		
		initList();	//그리드 초기화
	}
});
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
	$("#list2").setGridHeight(<%=listHeight2 %>);
	$("#list2").setGridWidth($(window).width() - 580 + Number(gridWidthResizePlus));
	$('#jqChart').jqChart('update');
}).trigger('resize');
</script>

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var staticNum = 0;	//list2, 그리드를 한번만 초기화하기 위해
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisAreaListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['권역명','매출금액','매입금액','손익금액','권역코드'],
		colModel:[
			{ name:'areatypenm',index:'areatypenm',width:210,align:"left",search:false,sortable:true,editable:false },//권역명
			{ name:'sale_requ_amou',index:'sale_requ_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매출금액
			{ name:'purc_requ_amou',index:'purc_requ_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매입금액
			{ name:'prof_amou',index:'prof_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//손익금액
			
			{ name:'areatype',index:'areatype',hidden:true,search:false }//권역코드
		],
		postData: {
			srcResultFromYear:$('#srcResultFromYear').val(),
			srcResultFromMonth:$('#srcResultFromMonth').val(),
			srcResultToYear:$('#srcResultToYear').val(),
			srcResultToMonth:$('#srcResultToMonth').val()
		},
		rowNum:0,rownumbers:false,rownumbers:true,
		height:<%=listHeight%>,width:<%=listWidth%>,
		sortname:'',sortorder:'',
		caption:"권역별 손익실적",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		footerrow:true,userDataOnFooter:true,
		loadComplete:function() {
 			var rowCnt = jq("#list").getGridParam('reccount');
 			if(rowCnt>0) {
 				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
 				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
 				var areatype = selrowContent.areatype;
 				if(staticNum==0) {
 					fnInitProductList(areatype);
 					staticNum++;
 				}
 				jq("#list").setSelection(top_rowid);
 				fnTotalAmountSum();
 				fnInitChart(1);//Chart 초기화
 			} else {
 				fnInitProductList();
 				jq("#list2").clearGridData();
 				jq("#list2").jqGrid("setCaption","&nbsp;");
 				fnTotalAmountSum();
 				fnInitChart(0);//Chart 초기화
 			}
 			$("input[name=ranking]").eq(0).attr("checked", true);
		},
		onSelectRow:function(rowid,iRow,iCol,e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var areatype = selrowContent.areatype;
			var areatypenm = selrowContent.areatypenm;
			fnOnClickCustomerProductList(areatype,areatypenm);
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		afterInsertRow:function(rowid, aData) {},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: {root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
}
function fnInitProductList(areatype) {
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisAreaProductListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['상품명','공급사명','매출금액','매입금액','손익금액'],
		colModel:[
			{ name:'good_name',index:'good_name',width:240,align:"left",search:false,sortable:true,editable:false },//품목명
			{ name:'vendornm',index:'vendornm',width:200,align:"left",search:false,sortable:true,editable:false },//공급사명
			{ name:'sale_requ_amou',index:'sale_requ_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매출금액
			{ name:'purc_requ_amou',index:'purc_requ_amou',width:80,align:"right",search:false,sortable:true
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
			areatype:areatype
		},
		rowNum:0,rownumbers:false,rownumbers:true,
		height:<%=listHeight2 %>,width:$(window).width()-580 + Number(gridWidthResizePlus),
		sortname:'',sortorder:'',
		caption:"권역의 상품별 손익실적",
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

<!--------------------------- Chart Start --------------------------->
<script type="text/javascript">
function fnInitChart(ranking) {
	var rank = Number(ranking);
	var rowCnt = jq("#list").getGridParam('reccount');
	var startNm = 0;
	var endNm = 0;
	var saleRequAmouColumn = "";
	var purcProdAmouColumn = "";
	
	if(rowCnt>0) {
		switch (rank) {
			case 1:
				startNm = 1;
				if((rowCnt - (rank*10)) < 0) { endNm = rowCnt; }
				else { endNm = 10; }
				break;
			case 2:
				startNm = 11;
				if(rowCnt<startNm) {
					alert("11위~20위 데이터가 없습니다.");
					fnClearChart();
					return;
				}
				if((rowCnt - (rank*10)) < 0) { endNm = rowCnt; }
				else { endNm = 20; }
				break;
			case 3:
				startNm = 21;
				if(rowCnt<startNm) {
					alert("21위~30위 데이터가 없습니다.");
					fnClearChart();
					return;
				}
				if((rowCnt - (rank*10)) < 0) { endNm = rowCnt; }
				else { endNm = 30; }
				break;
			case 4:
				startNm = 31;
				if(rowCnt<startNm) {
					alert("31위~40위 데이터가 없습니다.");
					fnClearChart();
					return;
				}
				if((rowCnt - (rank*10)) < 0) { endNm = rowCnt; }
				else { endNm = 40; }
				break;
			case 5:
				startNm = 41;
				if(rowCnt<startNm) {
					alert("41위~50위 데이터가 없습니다.");
					fnClearChart();
					return;
				}
				if((rowCnt - (rank*10)) < 0) { endNm = rowCnt; }
				else { endNm = 50; }
				break;
		}
		
		for(var i=startNm; i<endNm+1; i++) {
			var rowid = $("#list").getDataIDs()[i-1];
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
 			saleRequAmouColumn += '[\''+i+'.'+selrowContent.areatypenm+'\','+selrowContent.sale_requ_amou+'],';
 			purcProdAmouColumn += '[\''+i+'.'+selrowContent.areatypenm+'\','+selrowContent.purc_requ_amou+'],';
		}
		
		$('#jqChart').jqChart({
			title: { text: '' },
			animation: { duration: 1 },
			series: [
	 			{ type:'column',title:'매출금액',data: eval('['+saleRequAmouColumn.substring(0,saleRequAmouColumn.length-1)+']') },
	 			{ type:'column',title:'매입금액',data: eval('['+purcProdAmouColumn.substring(0,purcProdAmouColumn.length-1)+']') }
			]
		});
	} else {
		fnClearChart();
	}
}
function fnClearChart() {
	$('#jqChart').jqChart({
		title: { text: '' },
		animation: { duration: 1 },
		series: [
 			{ type:'column',title:'매출금액',data: [] },
 			{ type:'column',title:'매입금액',data: [] }
		]
	});
}
</script>
<!--------------------------- Chart End --------------------------->

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcResultFromYear = $('#srcResultFromYear').val();
	data.srcResultFromMonth = $('#srcResultFromMonth').val();
	data.srcResultToYear = $('#srcResultToYear').val();
	data.srcResultToMonth = $('#srcResultToMonth').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function fnOnClickCustomerProductList(areatype,areatypenm) {
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcResultFromYear = $('#srcResultFromYear').val();
	data2.srcResultFromMonth = $('#srcResultFromMonth').val();
	data2.srcResultToYear = $('#srcResultToYear').val();
	data2.srcResultToMonth = $('#srcResultToMonth').val();
	data2.areatype = areatype;
	jq("#list2").jqGrid("setCaption", "<font color='blue'>["+areatypenm+"]</font>의 상품별 손익실적");
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
					mm = "purc_requ_amou";
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
		jq("#list").jqGrid("footerData","set",{ areatypenm:'합계'
															,sale_requ_amou:fnComma(SumTotalamount[0])
															,purc_requ_amou:fnComma(SumTotalamount[1])
															,prof_amou:fnComma(SumTotalamount[2]) },false);
	} else {
		fnClearTotalAmountSum();
	}
}
function fnClearTotalAmountSum() {
	jq("#list").jqGrid("footerData","set",{ areatypenm:'합계',sale_requ_amou:'0',purc_requ_amou:'0',prof_amou:'0' },false);
}
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)) {
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

function fnChangeRanking() {
	var val = $(":input:radio[name=ranking]:checked").val();
	fnInitChart(val);
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
				<td height="29" class="ptitle">권역별 손익실적</td>
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
				<td colspan="5" class="table_td_contents">
					<select id="srcResultFromYear" name="srcResultFromYear" class="select"></select>년
					<select id="srcResultFromMonth" name="srcResultFromMonth" class="select"></select>월 ~
					<select id="srcResultToYear" name="srcResultToYear" class="select"></select>년
					<select id="srcResultToMonth" name="srcResultToMonth" class="select"></select>월
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
				<td valign="top" width="610">
					<div id="jqgrid">
						<table id="list"></table>
					</div>
				</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td valign="top">
					<div id="jqgrid">
						<table id="list2"></table>
					</div>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
				</td>
				<td class="stitle">권역별 손익실적 그래프</td>
			</tr>
		</table>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
			<tr>
				<td width="20" valign="top">&nbsp;</td>
				<td>
					<input name="ranking" style="border:0px;vertical-align:middle;" type="radio" value="1" onchange="javascript:fnChangeRanking();" checked="checked" />1위~10위
					<input name="ranking" style="border:0px;vertical-align:middle;" type="radio" value="2" onchange="javascript:fnChangeRanking();" />11위~20위
					<input name="ranking" style="border:0px;vertical-align:middle;" type="radio" value="3" onchange="javascript:fnChangeRanking();" />21위~30위
					<input name="ranking" style="border:0px;vertical-align:middle;" type="radio" value="4" onchange="javascript:fnChangeRanking();" />31위~40위
					<input name="ranking" style="border:0px;vertical-align:middle;" type="radio" value="5" onchange="javascript:fnChangeRanking();" />41위~50위
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<div id="jqChart" style="height:220px;"></div>
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