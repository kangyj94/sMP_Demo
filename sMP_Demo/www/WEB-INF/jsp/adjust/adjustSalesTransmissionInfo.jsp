<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-385 + Number(gridHeightResizePlus)";
	String listWidth = "1500";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$("#closeSalesDate").val('<%=CommonUtils.getCustomDay("DAY", 0)%>');
	
	$("#srcSalesTransStartDate").val('<%=CommonUtils.getCustomDay("MONTH", -1)%>');
	$("#srcSalesTransEndDate").val('<%=CommonUtils.getCustomDay("DAY", 0)%>');
	
	$("#srcButton").click(function(){ fnSearch(); });
	$("#salesTransferCancelButton").click(function(){ fnSalesTransferCancel(); });
	$("#closeDateAppButton").click(function(){ fnCloseDateApp(); });
	
	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });   	
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	
	$("#srcSalesName").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#srcSalesTransStartDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#srcSalesTransEndDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#srcClientNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#srcBusinessNum").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
});


$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight%>);
	$("#list").setGridWidth(1500);

}).trigger('resize');

//날짜 조회 및 스타일
$(function(){
   $("#closeSalesDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcSalesTransStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcSalesTransEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
   jq("#list").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustSalesTransmissionJQGrid.sys',
      datatype: 'json',
      multiselect:true,
      recordpos:'left',
      mtype: 'POST',
      colNames:['sale_sequ_numb','전표번호','*계산서일자','정산명','세금계산서고객사','사업자등록번호','매출확정일자','고객유형 담당자','매출금액','부가세','합계', 'paym_cond_code' , 'sum_sale_requ_amou', 'sum_sale_requ_vtax', 'sum_sale_tota_amou'],
      colModel:[
		 {name:'sale_sequ_numb', index:'sale_sequ_numb',width:80,align:"left",search:false,sortable:true, editable:false, hidden:true },                
         {name:'sap_jour_numb',index:'sap_jour_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:false },
		 {name:'clos_sale_date',index:'clos_sale_date',width:80,align:"center",search:false,sortable:false,
			 formatter: 'text',
			 editable:true,edittype: 'text',
			 editoptions: {
				 readonly:'readonly',
				 size: 9,maxlengh: 10,dataInit: function (element) {
				 $(element).datepicker({ dateFormat: 'yy-mm-dd' });
			},
			dataEvents:[{
				type:'change',
				fn:function(e){
					var inputValue = this.value; 											// 입력 날짜
					var rowid = (this.id).split("_")[0];
					jq("#list").restoreRow(rowid);
					jq("#list").jqGrid('setRowData', rowid, {clos_sale_date:inputValue});
				}
			}]
			},
	        editrules: {date: false}
		 },
         {name:'sale_sequ_name', index:'sale_sequ_name',width:260,align:"left",search:false,sortable:true, editable:false },
         {name:'clientNm',index:'clientNm',width:230,align:"left",search:false,sortable:true, editable:false },
         {name:'businessNum',index:'businessNum',width:90,align:"center",search:false,sortable:true, editable:false },
         {name:'sale_conf_date',index:'sale_conf_date',width:70,align:"center",search:false,sortable:true, editable:false },
         {name:'workInfoUserNm',index:'workInfoUserNm',width:90,align:"center",search:false,sortable:true, editable:false },//고객유형 담당자
         {name:'sale_requ_amou',index:'sale_requ_amou',width:75,align:"right",search:false,sortable:true, editable:false , 
          sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'sale_requ_vtax',index:'sale_requ_vtax',width:75,align:"right",search:false,sortable:true, editable:false , 
          sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//부가세
         {name:'sale_tota_amou',index:'sale_tota_amou',width:90,align:"right",search:false,sortable:true, editable:false , 
          sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'paym_cond_code',index:'paym_cond_code',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'sum_sale_requ_amou',index:'sum_sale_requ_amou',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'sum_sale_requ_vtax',index:'sum_sale_requ_vtax',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true },
         {name:'sum_sale_tota_amou',index:'sum_sale_tota_amou',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true }
      ],
      postData: {
         srcSalesName:$("#srcSalesName").val(),
         srcTransStatus:$("#srcTransStatus").val(),
         srcSalesTransStartDate:$("#srcSalesTransStartDate").val(),
         srcSalesTransEndDate:$("#srcSalesTransEndDate").val(),
         srcClientNm:$("#srcClientNm").val(),
         srcBusinessNum:$("#srcBusinessNum").val(),
         srcDateCalc:$("#dateCalc").val(),
         srcUserNm:$("#userNm").val()
      },
      rowNum:500, rownumbers: false, rowList:[30,50,100,500,1000], pager: '#pager',
      height: <%=listHeight%>,autowidth: true,
      sortname: 'a.clos_sale_date', sortorder: 'desc', 
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {
          var rowCnt = jq("#list").getGridParam('reccount');
          if(rowCnt > 0){
// 	          var rowid = $("#list").getDataIDs()[0];
// 	          var selrowContent 	= jq("#list").jqGrid('getRowData',rowid);
// 	          var getSale_requ_amou = selrowContent.sum_sale_requ_amou; 
// 	          var getSale_requ_vtax = selrowContent.sum_sale_requ_vtax;
// 	          var getSale_tota_amou = selrowContent.sum_sale_tota_amou;
	          
	          var getSale_requ_amou2 = 0;
	          var getSale_requ_vtax2 = 0;
	          var getSale_tota_amou2 = 0;
	          for(var i=0; i<rowCnt; i++){
	        	  var rowId = $("#list").getDataIDs()[i];
	        	  var selrowContent2 = jq("#list").jqGrid('getRowData',rowId);
	        	  getSale_requ_amou2 += parseInt(selrowContent2.sale_requ_amou);
	        	  getSale_requ_vtax2 += parseInt(selrowContent2.sale_requ_vtax);
	        	  getSale_tota_amou2 += parseInt(selrowContent2.sale_tota_amou);
	          }
// 	          jq("#list").addRowData(rowCnt + 1,
// 	        		  					{clos_sale_date:"",
// 	        	  						sale_conf_date:"합계",
// 	        	  						sale_requ_amou:getSale_requ_amou,
// 	        	  						sale_requ_vtax:getSale_requ_vtax,
// 	        	  						sale_tota_amou:getSale_tota_amou}
// 	          						);
// 	          rowCnt = jq("#list").getGridParam('reccount');
	          jq("#list").addRowData(rowCnt + 1,
	  					{clos_sale_date:"",
						sale_conf_date:"합계",
						sale_requ_amou:getSale_requ_amou2,
						sale_requ_vtax:getSale_requ_vtax2,
						sale_tota_amou:getSale_tota_amou2}
					);
	          //jq("#list").setCell(rowCnt + 1,'sale_requ_amou','',{weightfont:'bold'});
	          $("#list").jqGrid('setCell',rowCnt + 1,'sale_conf_date', '', {color:'black',weightfont:'bold'}); 
	          $("#list").jqGrid('setCell',rowCnt + 1,'sale_requ_amou', '', {color:'black',weightfont:'bold'}); 
	          $("#list").jqGrid('setCell',rowCnt + 1,'sale_requ_vtax', '', {color:'black',weightfont:'bold'}); 
	          $("#list").jqGrid('setCell',rowCnt + 1,'sale_tota_amou', '', {color:'black',weightfont:'bold'}); 
          }
      },
      onSelectRow: function (rowid, iRow, iCol, e) {},
      ondblClickRow: function (rowid, iRow, iCol, e) {},
      onCellSelect: function(rowid, iCol, cellcontent, target){},
      loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
      rownumbers:true
   });
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

//3자리수마다 콤마
function fnComma(n) {
   n += '';
   var reg = /(^[+-]?\d+)(\d{3})/;
   while (reg.test(n)){
      n = n.replace(reg, '$1' + ',' + '$2');
   }
   return n;
}

function exportExcel() {
	var colLabels = ['전표번호','계산서일자','정산명','세금계산서고객사','사업자등록번호','매출확정일자','고객유형 담당자','매출금액','부가세','합계'];	//출력컬럼명
	var colIds = ['sap_jour_numb','clos_sale_date','sale_sequ_name','clientNm','businessNum','sale_conf_date','workInfoUserNm','sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "매출회계 전송내역";	//sheet 타이틀
	var excelFileName = "SalesTransmissionInfo";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['전표번호','계산서일자','정산명','세금계산서고객사','사업자등록번호','매출확정일자','고객유형 담당자','매출금액','부가세','합계'];	//출력컬럼명
	var colIds = ['sap_jour_numb','clos_sale_date','sale_sequ_name','clientNm','businessNum','sale_conf_date','workInfoUserNm','sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "매출회계 전송내역";	//sheet 타이틀
	var excelFileName = "AllSalesTransmissionInfo";	//file명
	
	var actionUrl = "/adjust/adjustSalesTransmissionExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcSalesName';
	fieldSearchParamArray[1] = 'srcTransStatus';
	fieldSearchParamArray[2] = 'srcSalesTransStartDate';
	fieldSearchParamArray[3] = 'srcSalesTransEndDate';
	fieldSearchParamArray[4] = 'srcClientNm';
	fieldSearchParamArray[5] = 'srcBusinessNum';
	fieldSearchParamArray[6] = 'srcIsCollect';
	fieldSearchParamArray[7] = 'srcUserNm';
	fieldSearchParamArray[8] = 'dateCalc';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
    var data = jq("#list").jqGrid("getGridParam", "postData");
    data.srcSalesName = $("#srcSalesName").val();
    data.srcTransStatus = $("#srcTransStatus").val();
    data.srcSalesTransStartDate = $("#srcSalesTransStartDate").val();
    data.srcSalesTransEndDate = $("#srcSalesTransEndDate").val();
    data.srcClientNm = $("#srcClientNm").val();
    data.srcBusinessNum = $("#srcBusinessNum").val();
    data.srcDateCalc = $("#dateCalc").val();
    data.srcUserNm = $("#srcUserNm").val();
    jq("#list").trigger("reloadGrid");     
}

function fnCloseDateApp(){
	var id = $("#list").getGridParam('selarrrow');
	var ids = $("#list").jqGrid('getDataIDs');
	var count = 0;
	for (var i = 0; i < ids.length; i++) {
    	var check = false;
    	$.each(id, function (index, value) {
			if (value == ids[i]){
				check = true;
			}
		});
		if (check) {
			jq("#list").jqGrid('setRowData', ids[i], {clos_sale_date:$("#closeSalesDate").val()});
			count++;
		}
	}	
}

function fnSalesTransferCancel(){

	var closeDateArr 	= new Array();
	var saleSequNumbArr = new Array();
	var sapJourNumbArr  = new Array();
	var saleSequNameArr = new Array();
	var saleRequAmouArr = new Array();
	
	var id = $("#list").getGridParam('selarrrow');
	var ids = $("#list").jqGrid('getDataIDs');
	var count = 0;
	var chkCnt = 0;
	//var rowNum = 0;
	
	for (var i = 0; i < ids.length; i++) {
    	var check = false;
    	$.each(id, function (index, value) {
			if (value == ids[i]){
				check = true;
			}
		});
		if (check) {
			var rowdata = $("#list").getRowData(ids[i]);
   			if($.trim(rowdata.clos_sale_date) != ""){
      			closeDateArr[chkCnt] 	= rowdata.clos_sale_date;
      			saleSequNumbArr[chkCnt]	= rowdata.sale_sequ_numb;
      			sapJourNumbArr[chkCnt]	= rowdata.sap_jour_numb;
      			saleSequNameArr[chkCnt]	= rowdata.sale_sequ_name;
      			saleRequAmouArr[chkCnt]	= rowdata.sale_requ_amou;
      			chkCnt++;
			}else{
				//rowNum = ids[i];
			}
			count++;
		}
	}
	
	if(chkCnt == 0) {
		$("#dialog").html("<font size='2'>전송취소를 처리할 데이터를 선택해주세요.</font>");
		$("#dialog").dialog({
 			title: 'Fail',modal: true,
 			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return;
	}
	
	if(!confirm("선택하신 데이터를 전송취소 하시겠습니까?")) return;

	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/adjustSalesTransCancel.sys", 
		{	
			closeDateArr:closeDateArr,
			saleSequNumbArr:saleSequNumbArr,
			sapJourNumbArr:sapJourNumbArr,
			saleSequNameArr:saleSequNameArr,
			saleRequAmouArr:saleRequAmouArr
		},			
	
		function(arg){ 
			if(fnAjaxTransResult(arg)) {	//성공시
				fnSearch();
			}else{
				fnSearch();
			}
		}
	);		
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;">
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">매출전송내역</td>
					<td align="right" class="ptitle">
						<button id='excelAll' class="btn btn-success btn-sm" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							<i class="fa fa-file-excel-o"></i> 엑셀
						</button>
						<button id="srcButton" name="srcButton" class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i> 조회
						</button>
					</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">정산명</td>
					<td class="table_td_contents">
						<input id="srcSalesName" name="srcSalesName" type="text" value="" size="20" maxlength="30" />
					</td>
					<td class="table_td_subject" width="100">전송상태</td>
					<td class="table_td_contents">
						<select id="srcTransStatus" name="srcTransStatus" class="select" disabled="disabled">
							<option value="10">매출확정</option>
							<option value="20" selected="selected">매출전송</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">계산서일자
						<input type="hidden" id="dateCalc" value="transDate"/>
					</td>
					<td class="table_td_contents">
						<input type="text" name="srcSalesTransStartDate" id="srcSalesTransStartDate" style="width: 75px;vertical-align: middle;"/> 
						~ 
						<input type="text" name="srcSalesTransEndDate" id="srcSalesTransEndDate" style="width: 75px;vertical-align: middle;"/>
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">고객사명</td>
					<td class="table_td_contents">
						<input id="srcClientNm" name="srcClientNm" type="text" value="" size="20" maxlength="30" />
					</td>
					<td class="table_td_subject">사업자등록번호</td>
					<td class="table_td_contents">
						<input id="srcBusinessNum" name="srcBusinessNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/> (-없이)
					</td>
					<td class="table_td_subject">고객유형 담당자</td>
					<td class="table_td_contents">
						<input type="text" id="srcUserNm" value=""/>
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
	<tr><td height="5"></td></tr>
	<tr>
		<td>
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="stitle" />
						매출회계 전송내역
					</td>
					<td align="right" valign="middle">
						<button id="salesTransferCancelButton" name="salesTransferCancelButton" class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							전송취소
						</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<div id="jqgrid">
				<table id="list"></table>
				<div id="pager"></div>
			</div>
		</td>
	</tr>
</table>
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>
      <div id="dialog" title="Feature not supported" style="display:none;">
         <p>That feature is not supported.</p>
      </div>          
   </form>
</body>
</html>