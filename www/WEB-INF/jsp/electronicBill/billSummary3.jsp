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
	String listHeight = "$(window).height()-350 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
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
	                    <td width="200" class='ptitle'>전자어음 발행명세</td>
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
		var colLabels = ['발행월','물대','이자','총액'];	//출력컬럼명
		var colIds = ['PUBLIC_MONTH','PUBLIC_AMOUNT','INTEREST_AMOUNT','SUM_AMOUNT'];	//출력컬럼ID
		var numColIds = ['PUBLIC_AMOUNT','INTEREST_AMOUNT','SUM_AMOUNT'];	//숫자표현ID
		var sheetTitle = "전자어음 발행명세";	//sheet 타이틀
		var excelFileName = "BillSummary";	//file명
		
		fnExportExcel($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
	});
	$("#list").jqGrid({
		url:'/newCate/selectElectronicBillSummary/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['발행월','물대','이자','총액'],
		colModel:[
			{name:'PUBLIC_MONTH',width:100,align:'center', key:true},//발행월
			{name:'PUBLIC_AMOUNT',width:200,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//물대
			{name:'INTEREST_AMOUNT',width:200,align:'right'},//이자
			{name:'SUM_AMOUNT',width:250,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			}//총액
		],
		postData: $('#frmSearch').serializeObject(),
		rowNum:0,
        height:<%=listHeight%>,autowidth:true,
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        jsonReader : {root: "list",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	$(this).setCell(rowid,'PUBLIC_MONTH','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="PUBLIC_MONTH") {
            	var startDate = $("#public_year").val()+'-'+(selrowContent.PUBLIC_MONTH).substring(0,2)+'-'+'01';
            	var dt = new Date($("#public_year").val(), (selrowContent.PUBLIC_MONTH).substring(0,2), 0);
            	var endDate = $("#public_year").val()+'-'+(selrowContent.PUBLIC_MONTH).substring(0,2)+'-'+dt.getDate();
            	location.href = "/menu/electronicBill/billDetail.sys?startDate="+startDate+"&endDate="+endDate;
            }
        },
		loadComplete: function() {
			var footer_PUBLIC_AMOUNT = $("#list").jqGrid('getCol','PUBLIC_AMOUNT',false,'sum');
			var footer_INTEREST_AMOUNT = $("#list").jqGrid('getCol','INTEREST_AMOUNT',false,'sum');
			var footer_SUM_AMOUNT = $("#list").jqGrid('getCol','SUM_AMOUNT',false,'sum');
			$("#list").jqGrid('footerData','set',{PUBLIC_MONTH:'합계', PUBLIC_AMOUNT:footer_PUBLIC_AMOUNT, INTEREST_AMOUNT:footer_INTEREST_AMOUNT, SUM_AMOUNT:footer_SUM_AMOUNT});
			
			$('table.ui-jqgrid-ftable tr:first').children('td').css('background-color', '#dfeffc');
			$('table.ui-jqgrid-ftable tr:first td:eq(0), table.ui-jqgrid-ftable tr:first td:eq(4)').children('td').css('padding-top', '8px');
			$('table.ui-jqgrid-ftable tr:first td:eq(0), table.ui-jqgrid-ftable tr:first td:eq(4)').children('td').css('padding-bottom', '8px');
		},
		footerrow:true, userDataOnFooter:true
	});
});
</script>
</body>
</html>