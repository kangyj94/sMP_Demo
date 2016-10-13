<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "275";
	String listHeight2 = "275";
	String listWidth = "500";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String srcResultFromYear = "2010";//날짜 세팅
	String srcResultFromMonth = "01";
	String srcResultToYear = CommonUtils.getCustomDay("MONTH",-1).substring(0, 4);
	String srcResultToMonth = CommonUtils.getCustomDay("MONTH",0).substring(5, 7);
	/*---------------------*/
	String clientid = request.getParameter("clientid");
	String resultFromYear = request.getParameter("resultFromYear");
	String resultFromMonth = request.getParameter("resultFromMonth");
	String resultToYear = request.getParameter("resultToYear");
	String resultToMonth = request.getParameter("resultToMonth");
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
	$("#srcButton").click( function() {
		$("#srcSaleProdAmouFrom").val($.trim($("#srcSaleProdAmouFrom").val()));
		$("#srcSaleProdAmouEnd").val($.trim($("#srcSaleProdAmouEnd").val()));
		fnSearch(); 
	});
	$('#srcResultFromYear').keydown(function(e){ if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultFromMonth').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToYear').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToMonth').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcBorgName').keydown(function(e) { if(e.keyCode==13) { $('#btnBuyBorg').click(); }});
	$('#srcBorgName').change(function(e) { $('#srcBorgName').val('');	$('#srcGroupId').val('0'); $('#srcClientId').val('0'); $('#srcBranchId').val('0'); });
	$('#btnBuyBorg').click(function() { fnBuyBorgSearchOpenPop(); });
	$('#srcSaleProdAmouFrom').keydown(function(e){ if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcSaleProdAmouEnd').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	
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
		/*************매출상세정보에서 넘어온정보로 검색**************/
		var clientid = "<%=clientid%>";
		if(clientid != "null" && clientid != ""){
			fnSearchResult();
		}
		/*************************************************************/
		initList();	//그리드 초기화
	}
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelButton2").click(function(){ exportExcel2(); });
	
	//jqCahrt 효과
	$('#jqChart').bind('tooltipFormat', function (e, data) {
	    return "<font color='blue'>" + data.x + "</font><br />" +
	          "<font color='black'><b>" +fnComma( data.y ) + "</b>"+" 원</font><br />";
	 });
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
<%
	/**------------------------------------구매사팝업 사용방법---------------------------------
	* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
	* borgType : 구매사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
	* isFixed : 구매사조직유형 고정여부("":아니오, "1":예)
	* borgNm : 찾고자하는 구매사명
	* callbackString : 콜백함수(문자열), 콜백함수파라메타는 4개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String)
	*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<script type="text/javascript">
/**
 * 구매사 팝업 호출
 */
function fnBuyBorgSearchOpenPop() {
	var borgNm = $('#srcBorgName').val();
	fnBuyborgDialog('CLT', '1', borgNm, 'fnCallBackBuyBorg');
}
/**
 * 사업장 콜백
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm) {
	if(groupId=='') groupId = '0';
	if(clientId=='') clientId = '0';
	if(branchId=='') branchId = '0';
	
	$('#srcGroupId').val(groupId);
	$('#srcClientId').val(clientId);
	$('#srcBranchId').val(branchId);
	$('#srcBorgName').val(borgNm);
}
</script>
<!--------------------------- Modal Dialog End --------------------------->

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var staticNum = 0;	//list2, 그리드를 한번만 초기화하기 위해
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisCustomerListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['구매사명','사업자등록번호','매출금액','매입금액','손익금액','순위','법인Id','매출Id'],
		colModel:[
			{ name:'borgnm',index:'borgnm',width:210,align:"left",search:false,sortable:true,editable:false },//구매사명
			{ name:'businessNum',index:'businessNum',width:90,align:"center",search:false,sortable:true,editable:false },//구매사명
			{ name:'sale_requ_amou',index:'sale_requ_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매출금액
			{ name:'purc_prod_amou',index:'purc_prod_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매입금액
			{ name:'prof_amou',index:'prof_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//손익금액
			{ name:'rank',index:'stand_good_spec_desc',hidden:true,width:45,align:"center",search:false,sortable:true,editable:false },//순위
			  
			{ name:'clientid',index:'clientid',hidden:true,search:false },//법인Id
			{ name:'sale_sequ_numb',index:'sale_sequ_numb',hidden:true,search:false }//매출Id
		],
		postData: {
			srcResultFromYear:$('#srcResultFromYear').val(),
			srcResultFromMonth:$('#srcResultFromMonth').val(),
			srcResultToYear:$('#srcResultToYear').val(),
			srcResultToMonth:$('#srcResultToMonth').val(),
			srcClientId:$('#srcClientId').val()
		},
		rowNum:0,rownumbers:false,rownumbers:true,
		height:<%=listHeight%>,width:<%=listWidth%>,
		sortname:'',sortorder:'',
		caption:"구매사별 손익실적",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		footerrow:true,userDataOnFooter:true,
		afterInsertRow: function(rowid, aData){
     		jq("#list").setCell(rowid,'borgnm','',{color:'#0000ff'});
		},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			if(iCol==1) {
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				var srcResultFromYear = $("#srcResultFromYear").val();
				var srcResultFromMonth = $("#srcResultFromMonth").val();
				var srcResultToYear = $("#srcResultToYear").val();
				var srcResultToMonth = $("#srcResultToMonth").val();
				var popurl = "/analysis/analysisCustomerListDetail.sys?clientId="+selrowContent.clientid+"&clientNm="+encodeURIComponent(selrowContent.borgnm)+
						"&srcResultFromYear="+srcResultFromYear+"&srcResultFromMonth="+srcResultFromMonth+"&srcResultToYear="+srcResultToYear+"&srcResultToMonth="+srcResultToMonth;
				var popproperty = "dialogWidth:1000px;dialogHeight=600px;Scroll=auto;status=no;resizable=no;";
				//window.showModalDialog(popurl,window,popproperty);
				window.open(popurl, 'okplazaPop', 'width=1000, height=600, scrollbars=yes, status=no, resizable=no');
			}
		},
		loadComplete:function() {
 			var rowCnt = jq("#list").getGridParam('reccount');
 			if(rowCnt>0) {
 				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
 				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
 				var clientid = selrowContent.clientid;
 				if(staticNum==0) {
 					fnInitProductList(clientid);
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
			var clientid = selrowContent.clientid;
			var borgnm = selrowContent.borgnm;
			fnOnClickCustomerProductList(clientid,borgnm);
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: {root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
}
function fnInitProductList(clientid) {
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisCustomerProductListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['상품명','공급사명','사업자등록번호','매출금액','매입금액','손익금액'],
		colModel:[
			{ name:'good_name',index:'good_name',width:240,align:"left",search:false,sortable:true,editable:false },//품목명
			{ name:'vendornm',index:'vendornm',width:200,align:"left",search:false,sortable:true,editable:false },//공급사명
			{ name:'businessNum',index:'businessNum',width:90,align:"center",search:false,sortable:true,editable:false },//공급사명
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
			clientid:clientid
		},
		rowNum:30, rownumbers: true, rowList:[30,50,100,500,1000], pager: '#pager',
		height:<%=listHeight2 %>,width:$(window).width()-580 + Number(gridWidthResizePlus),
		sortname:'',sortorder:'',
		caption:"구매사의 상품별 손익실적",
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
 			saleRequAmouColumn += '[\''+i+'.'+selrowContent.borgnm+'\','+selrowContent.sale_requ_amou+'],';
 			purcProdAmouColumn += '[\''+i+'.'+selrowContent.borgnm+'\','+selrowContent.purc_prod_amou+'],';
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
	data.srcGroupId = $('#srcGroupId').val();
	data.srcClientId = $('#srcClientId').val();
	data.srcBranchId = $('#srcBranchId').val();
	data.srcSaleProdAmouFrom = $('#srcSaleProdAmouFrom').val();
	data.srcSaleProdAmouEnd = $("#srcSaleProdAmouEnd").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function fnOnClickCustomerProductList(clientid,borgnm) {
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcResultFromYear = $('#srcResultFromYear').val();
	data2.srcResultFromMonth = $('#srcResultFromMonth').val();
	data2.srcResultToYear = $('#srcResultToYear').val();
	data2.srcResultToMonth = $('#srcResultToMonth').val();
	data2.clientid = clientid;
	jq("#list2").jqGrid("setCaption", "<font color='blue'>["+borgnm+"]</font>의 상품별 손익실적");
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

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['구매사명','사업자등록번호','매출금액','매입금액','손익금액'];	//출력컬럼명
	var colIds = ['borgnm','businessNum','sale_requ_amou','purc_prod_amou','prof_amou'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','purc_prod_amou','prof_amou'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "구매사별 손익실적";	//sheet 타이틀
	var excelFileName = "analysisCustomerList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcel2() {
	var colLabels = ['상품명','공급사명','사업자등록번호','매출금액','매입금액','손익금액'];	//출력컬럼명
	var colIds = ['good_name','vendornm','businessNum','sale_prod_amou','purc_prod_amou','prof_amou'];	//출력컬럼ID
	var numColIds = ['sale_prod_amou','purc_prod_amou','prof_amou'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "상품별 손익실적";	//sheet 타이틀
	var excelFileName = "analysisCustomerList";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function fnSearchResult() {
	$('#srcResultFromYear').val("<%=resultFromYear%>");
	$('#srcResultFromMonth').val("<%=resultFromMonth%>");
	$('#srcResultToYear').val("<%=resultToYear%>");
	$('#srcResultToMonth').val("<%=resultToMonth%>");
	$('#srcClientId').val("<%=clientid%>");

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
				<td height="29" class="ptitle">구매사별 손익실적</td>
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
				<td class="table_td_contents" width="250">
					<select id="srcResultFromYear" name="srcResultFromYear" class="select"></select>년
					<select id="srcResultFromMonth" name="srcResultFromMonth" class="select"></select>월 ~
					<select id="srcResultToYear" name="srcResultToYear" class="select"></select>년
					<select id="srcResultToMonth" name="srcResultToMonth" class="select"></select>월
				</td>
				<td class="table_td_subject" width="80">구매사</td>
				<td class="table_td_contents" width="100">
					<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="50" />
					<input id="srcGroupId" name="srcGroupId" type="hidden" value="0"/>
					<input id="srcClientId" name="srcClientId" type="hidden" value="0"/>
					<input id="srcBranchId" name="srcBranchId" type="hidden" value="0"/>
					<img id="btnBuyBorg" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;border:0px;vertical-align:middle;cursor:pointer;" />
				</td>
				<td class="table_td_subject" width="80">매출금액</td>
				<td class="table_td_contents" width="610">
					<input id="srcSaleProdAmouFrom" name="srcSaleProdAmouFrom" type="text" value="" size="15" maxlength="30" style="ime-mode:disabled;" onkeydown="return onlyNumberForSum(event);"/> ~
					<input id="srcSaleProdAmouEnd" name="srcSaleProdAmouEnd" type="text" value="" size="15" maxlength="30" style="ime-mode:disabled;" onkeydown="return onlyNumberForSum(event);"/>
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
					* 법인명을 클릭하시면 법인의 사업장별 손익실적을 조회하실 수 있습니다.&nbsp;
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				</td>
				<td></td>
				<td valign="top" align="right">
					<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
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
				<td class="stitle">
					<table>
						<tr>
							<td>
								구매사별 손익실적 그래프
							</td>
							<td>
								&nbsp;&nbsp;&nbsp;
								<font color="red">*</font>
								(마우스 커서를 그래프 위에 올리시면 상세 내역 확인 가능합니다.)
							</td>
						</tr>
					</table>
				</td>
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