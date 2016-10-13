<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>

<%
	int startYear = 2013;
	int publicYear = Integer.parseInt((CommonUtils.getCurrentDate().substring(0, 4)));
	String listHeight = "$(window).height()-300 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css" media="screen">
    th.ui-th-column div{
        white-space:normal !important;
        height:auto !important;
    }
    input[type=radio]{vertical-align: middle;}
</style>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td bgcolor="#FFFFFF">
            <form id="frmSearch" onsubmit="return false;">
            	<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
	                    <td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
	                    <td width="200" class='ptitle'>이자부담 물대현황</td>
	                    <td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
	                        <button id='xlsButton' class="btn btn-success btn-sm" ><i class="fa fa-file-excel-o"></i> 엑셀</button>
	                        <button id='srcButton' class="btn btn-default btn-sm" ><i class="fa fa-search"></i> 조회</button>
	                    </td>
	                </tr>
	            </table>
	            <table width="1500px" border="0" cellspacing="0" cellpadding="0">
	                <tr>
	                    <td colspan="4" class="table_top_line"></td>
	                </tr>
	                <tr>
	                    <td colspan="4" height="1" bgcolor="eaeaea"></td>
	                </tr>
	                <tr>
	                    <td class="table_td_subject" width="100">발행년도</td>
	                    <td class="table_td_contents" colspan="3">
	                    	<select id="public_year" name="public_year" class="select" style="width: 80px;">
<%	for(int i=startYear;i<=(publicYear+1);i++) { %>
								<option value="<%=i %>" <%=(i==publicYear) ? "selected" : "" %>><%=i %></option>
<%	} %>                	
	                    	</select>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="4" class="table_top_line"></td>
	                </tr>
	                <tr><td height="10"></td></tr>
	            </table>
            </form>
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td valign="top">
                        <div id="jqgrid">
                            <table id="list"></table>
                        </div>
                    </td>
                </tr>
            </table>
            <div id="dialog" title="Feature not supported" style="display:none;">
                <p>That feature is not supported.</p>
            </div>
        </td>
    </tr>
</table>

<script type="text/javascript">
$(function(){
	$("#srcButton").click(function() {
		$("#list")
		.jqGrid("setGridParam", {'postData':$('#frmSearch').serializeObject()})
		.trigger("reloadGrid");
	});
	$("#xlsButton").click(function() {
		var colLabels = ['발행월','어음구분','이자부담 물대(단위:천원)','총물대(단위:천원)','비중(%)'];	//출력컬럼명
		var colIds = ['PUBLIC_MONTH','BILL_FLAG','INTEREST_AMOUNT','SUM_AMOUNT','INTEREST_SUM_RATE'];	//출력컬럼ID
		var numColIds = ['INTEREST_AMOUNT','SUM_AMOUNT'];	//숫자표현ID
		var sheetTitle = "이자부담 물대현황";	//sheet 타이틀
		var excelFileName = "InterestBillSummary";	//file명
		
		fnExportExcel($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
	});
	$("#list").jqGrid({
		url:'/newCate/selectElectronicBillSummary2/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['발행월','어음구분','이자부담 물대(단위:천원)','총물대(단위:천원)','비중(%)'],
		colModel:[
			{name:'PUBLIC_MONTH',width:100,align:'center'},//발행월
			{name:'BILL_FLAG',width:100,align:'center'},//어음구분
			{name:'INTEREST_AMOUNT',width:200,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//이자부담물대
			{name:'SUM_AMOUNT',width:200,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//총액
			{name:'INTEREST_SUM_RATE',width:100,align:'right'}//비중
		],
		postData: $('#frmSearch').serializeObject(),
		rowNum:0,
        height:<%=listHeight%>,autowidth:true,
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        jsonReader : {root: "list",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	if((aData.PUBLIC_MONTH).indexOf("월")>0) {
        		$(this).setCell(rowid,'PUBLIC_MONTH','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        	}
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="PUBLIC_MONTH") {
            	var startDate = $("#public_year").val()+'-'+(selrowContent.PUBLIC_MONTH).substring(0,2)+'-'+'01';
            	var dt = new Date($("#public_year").val(), (selrowContent.PUBLIC_MONTH).substring(0,2), 0);
            	var endDate = $("#public_year").val()+'-'+(selrowContent.PUBLIC_MONTH).substring(0,2)+'-'+dt.getDate();
            	var bill_flag = "";
            	if(selrowContent.BILL_FLAG=="전자어음") bill_flag = "10";
            	else if(selrowContent.BILL_FLAG=="전자외담대") bill_flag = "20";
            	if(selrowContent.BILL_FLAG.indexOf("평균")<0) {
            		location.href = "/menu/electronicBill/billDetail.sys?startDate="+startDate+"&endDate="+endDate+"&bill_flag="+bill_flag;
            	}
            }
        }, 
		loadComplete: function() {
			var rowCnt = $("#list").getGridParam('reccount');
			var dash_interest_sum = 0, dash_sum_sum = 0, dash_cnt = 0;
			var interest_10_sum = 0, sum_10_sum = 0, cnt_10 = 0;
			var interest_20_sum = 0, sum_20_sum = 0, cnt_20 = 0;
			var interest_all_sum = 0, sum_all_sum = 0, cnt_all = 0;
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = $("#list").jqGrid('getRowData',rowid);
					if(selrowContent.BILL_FLAG=='-') {
						dash_interest_sum += Number(selrowContent.INTEREST_AMOUNT);
						dash_sum_sum += Number(selrowContent.SUM_AMOUNT);
						dash_cnt++;
					} else if(selrowContent.BILL_FLAG=='전자어음') {
						interest_10_sum += Number(selrowContent.INTEREST_AMOUNT);
						sum_10_sum += Number(selrowContent.SUM_AMOUNT);
						cnt_10++;
					} else if(selrowContent.BILL_FLAG=='전자외담대') {
						interest_20_sum += Number(selrowContent.INTEREST_AMOUNT);
						sum_20_sum += Number(selrowContent.SUM_AMOUNT);
						cnt_20++;
					} else if(selrowContent.BILL_FLAG=='소계') {
						interest_all_sum += Number(selrowContent.INTEREST_AMOUNT);
						sum_all_sum += Number(selrowContent.SUM_AMOUNT);
						cnt_all++;
					}
				}
			}
			var dash_interest_average = (dash_interest_sum/dash_cnt).toFixed(0);
			var dash_sum_average = (dash_sum_sum/dash_cnt).toFixed(0);
			if(dash_interest_average>0 || dash_sum_average>0) {
				var dash_interest_sum_average = (dash_interest_average*100/dash_sum_average).toFixed(1);
		        var newRowId = $("#list").getDataIDs().length+1;
		        $("#list").addRowData(newRowId, {PUBLIC_MONTH:'',BILL_FLAG:'- 평균',INTEREST_AMOUNT:dash_interest_average,SUM_AMOUNT:dash_sum_average,INTEREST_SUM_RATE:dash_interest_sum_average});
			}
			var interest_average_10 = (interest_10_sum/cnt_10).toFixed(0);
			var sum_average_10 = (sum_10_sum/cnt_10).toFixed(0);
			if(interest_average_10>0 || sum_average_10>0) {
				var interest_sum_average_10 = (interest_average_10*100/sum_average_10).toFixed(1);
		        var newRowId = $("#list").getDataIDs().length+1;
		        $("#list").addRowData(newRowId, {PUBLIC_MONTH:'',BILL_FLAG:'전자어음 평균',INTEREST_AMOUNT:interest_average_10,SUM_AMOUNT:sum_average_10,INTEREST_SUM_RATE:interest_sum_average_10});
			}
			var interest_average_20 = (interest_20_sum/cnt_20).toFixed(0);
			var sum_average_20 = (sum_20_sum/cnt_20).toFixed(0);
			if(interest_average_20>0 || sum_average_20>0) {
				var interest_sum_average_20 = (interest_average_20*100/sum_average_20).toFixed(1);
		        var newRowId = $("#list").getDataIDs().length+1;
		        $("#list").addRowData(newRowId, {PUBLIC_MONTH:'',BILL_FLAG:'전자외담대 평균',INTEREST_AMOUNT:interest_average_20,SUM_AMOUNT:sum_average_20,INTEREST_SUM_RATE:interest_sum_average_20});
			}
			var interest_average_all = (interest_all_sum/cnt_all).toFixed(0);
			var sum_average_all = (sum_all_sum/cnt_all).toFixed(0);
			if(interest_average_all>0 || sum_average_all>0) {
				var interest_sum_average_all = (interest_average_all*100/sum_average_all).toFixed(1);
		        var newRowId = $("#list").getDataIDs().length+1;
		        $("#list").addRowData(newRowId, {PUBLIC_MONTH:'',BILL_FLAG:'전체 평균',INTEREST_AMOUNT:interest_average_all,SUM_AMOUNT:sum_average_all,INTEREST_SUM_RATE:interest_sum_average_all});
			}
		}
	});
});
</script>
</body>
</html>