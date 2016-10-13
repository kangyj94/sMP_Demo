<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>

<%
	String startDate = CommonUtils.getCustomDay("MONTH", -1); // 날짜 세팅
	String endDate   = CommonUtils.getCurrentDate();
	String listHeight   = "$(window).height()-395 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	
	String paramStartDate = CommonUtils.getString(request.getParameter("startDate"));
	startDate = !"".equals(paramStartDate) ? paramStartDate : startDate;
	String paramEndDate = CommonUtils.getString(request.getParameter("endDate"));
	endDate = !"".equals(paramEndDate) ? paramEndDate : endDate;
	
	String bill_flag = CommonUtils.getString(request.getParameter("bill_flag"));
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
<style type="text/css">
.jqmWindow {
    display: none;
    position: absolute;
    top: 5%;
    left: 3%;
    width: 650px;
    background-color: #EEE;
    color: #333;
}
.jqmOverlay { background-color: #000; }
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
	                    <td width="200" class='ptitle'>전자어음 발행상세</td>
	                    <td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
	                        <button id='xlsButton' class="btn btn-success btn-sm" ><i class="fa fa-file-excel-o"></i> 엑셀</button>
	                        <button id='srcButton' class="btn btn-default btn-sm" ><i class="fa fa-search"></i> 조회</button>
	                    </td>
	                </tr>
	            </table>
	            <table width="1500px" border="0" cellspacing="0" cellpadding="0">
	                <tr>
	                    <td colspan="8" class="table_top_line"></td>
	                </tr>
	                <tr>
	                    <td colspan="8" height="1" bgcolor="eaeaea"></td>
	                </tr>
	                <tr>
	                    <td class="table_td_subject" width="100">
	                    	<select id="dateFlag" name="dateFlag" class="select" style="width: 100px;">
	                    		<option value="PUBLIC">발행일</option>
	                    		<option value="EXPIRE">만기일</option>
	                    		<option value="EVIDENCE">증빙일</option>
	                    		<option value="RETURN">결제일</option>
	                    	</select>
	                    </td>
	                    <td class="table_td_contents" width="300">
							<input id="startDate" name="startDate" value="<%=startDate%>" type="text" style="width: 75px;" /> 
							~
							<input id="endDate" name="endDate" value="<%=endDate%>" type="text" style="width: 75px;" />
	                    </td>
	                    <td class="table_td_subject" width="100">결제여부</td>
	                    <td class="table_td_contents" width="150">
	                    	<select id="returnFlag" name="returnFlag" class="select" >
	                    		<option value="">전체</option>
	                    		<option value="1">예</option>
	                    		<option value="0">아니오</option>
	                    	</select>
	                    </td>
	                    <td class="table_td_subject" width="100">사업자번호</td>
	                    <td class="table_td_contents" width="200">
							<input id="src_business_num" name="src_business_num" value="" type="text" style="width: 130px;" /> 
						</td>
	                    <td class="table_td_subject" width="100">전표번호</td>
	                    <td class="table_td_contents">
							<input id="src_sale_num" name="src_sale_num" value="" type="text" style="width: 130px;" /> 
						</td>
	                </tr>
	                <tr>
	                    <td colspan="8" height="1" bgcolor="eaeaea"></td>
	                </tr>
	                <tr>
	                    <td class="table_td_subject">사업자명</td>
	                    <td class="table_td_contents" width="300">
							<input id="src_business_nm" name="src_business_nm" value="" type="text" style="width: 200px;" /> 
	                    </td>
	                    <td class="table_td_subject" width="100">어음구분</td>
	                    <td class="table_td_contents" width="150">
	                    	<select id="src_bill_flag" name="src_bill_flag" class="select" >
	                    		<option value="">전체</option>
	                    		<option value="10" <%=("10".equals(bill_flag)) ? "selected" : "" %>>전자어음</option>
	                    		<option value="20" <%=("20".equals(bill_flag)) ? "selected" : "" %>>전자외담대</option>
	                    	</select>
	                    </td>
	                    <td class="table_td_subject">은행구분</td>
	                    <td class="table_td_contents">
	                    	<select id="src_bankcd" name="src_bankcd" class="select" >
	                    		<option value="">전체</option>
	                    		<option value="04">국민은행</option>
	                    		<option value="03">기업은행</option>
	                    		<option value="20">우리은행</option>
	                    		<option value="81">하나은행</option>
<!-- 	                    		<option value="26">신한은행</option> -->
<!-- 	                    		<option value="23">한국SC은행</option> -->
<!-- 	                    		<option value="02">KDB산업은행</option> -->
<!-- 	                    		<option value="71">우체국</option> -->
<!-- 	                    		<option value="11">농협</option> -->
<!-- 	                    		<option value="07">수협은행</option> -->
<!-- 	                    		<option value="53">씨티은행</option> -->
<!-- 	                    		<option value="27">한미은행</option> -->
<!-- 	                    		<option value="31">대구은행</option> -->
<!-- 	                    		<option value="32">부산은행</option> -->
<!-- 	                    		<option value="34">광주은행</option> -->
<!-- 	                    		<option value="37">전북은행</option> -->
<!-- 	                    		<option value="39">경남은행</option> -->
<!-- 	                    		<option value="HS">한신상호저축은행</option> -->
<!-- 	                    		<option value="DO">도이치은행</option> -->
	                    	</select>
						</td>
	                    <td class="table_td_subject" width="100">참조</td>
	                    <td class="table_td_contents">
							<input id="src_reference" name="src_reference" value="" type="text" style="width: 130px;" /> 
						</td>
	                </tr>
	                <tr>
	                    <td colspan="8" class="table_top_line"></td>
	                </tr>
	                <tr><td height="10"></td></tr>
	            </table>
            </form>
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                	<td align="left" valign="middle" style="padding-left: 20px;">
                		<img src="/img/contents/bullet_01.gif" />
                		<span id="resultTxt" style="font-size: 10pt;"></span>
                	</td>
                	<td align="right" valign="bottom" width="400px;">
                		<button class="btn btn-primary btn-xs" id="btnBillBat"><i class="fa fa-file-excel-o"></i> 일괄 등록/수정</button>
                		<button class="btn btn-primary btn-xs" id="btnBillReg"><i class="fa fa-floppy-o"></i> 등록</button>
                		<button class="btn btn-warning btn-xs" id="btnBillDel"><i class="fa fa-trash-o"></i> 삭제</button>
                	</td>
                </tr>
                <tr><td height="1" colspan="2"></td></tr>
                <tr>
                    <td valign="top" colspan="2">
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
<!-------------------------------- Dialog Div Start -------------------------------->
<div class="jqmWindow" id="dialogUploadPop">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <div id="dialogHandle">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                        <tr>
                            <td width="21">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
                            </td>
                            <td width="22">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom: 5px;" />
                            </td>
                            <td class="popup_title">전자어음 발행 일괄등록/수정</td>
                            <td width="22" align="right">
                                <a href="#" class="jqmClose">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom: 5px;" />
                                </a>
                            </td>
                            <td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
                        </tr>
                    </table>
                </div>
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="20" height="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" />
                        </td>
                        <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
                        <td width="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" />
                        </td>
                    </tr>
                    <tr>
                        <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                        <td bgcolor="#FFFFFF">
                            <!-- 타이틀 -->
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="20">
                                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet01.gif" align="bottom" />
                                    </td>
                                    <td class='ptitle'>사용방법</td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr valign="top">
                                    <td height="23px" class="table_td_contents">1. 샘플파일(양식)을 다운로드 하십시오</td>
                                </tr>
                                <tr valign="top">
                                    <td height="23px" class="table_td_contents">
                                    	2. 등록 및 수정정보를 입력하십시오(* 필수값)<br/>
                                    	&nbsp;&nbsp;&nbsp;&nbsp;
                                    	<font color="red">
                                    		[어음코드]와 [은행코드]는 구분코드 시트의 코드값으로 작성해 주십시오!
                                    	</font>
                                    </td>
                                </tr>
                                <tr valign="top">
                                    <td height="23px" class="table_td_contents">3. 발행코드를 입력하지 않으시면 신규등록, 입력하시면 해당발행코드에 대해 수정됩니다.</td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr valign="top">
                                    <td>
                                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/member_excel.gif" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                            <span id="status" style="color: #FF0000"></span>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td align="center">
                                    	<a href="/upload/sample/BillExcelUploadSample.xls">
											<button id="downButton" type="button" class="btn btn-success btn-sm"><i class="fa fa-file-excel-o"></i> 샘플파일(양식) 다운로드</button>
										</a>
										<button id="importButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> 엑셀업로드</button>
										<button id="closeButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-times"></i> 닫기</button>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="20" height="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" />
                        </td>
                        <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                        <td width="20">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
<div class="jqmWindow" id="billPop"></div>
<script type="text/javascript">
$(function(){
    $("#startDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#endDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
    $('#billPop').jqm();
	
    var btnUpload=$('#importButton');
    var status=$('#status');
    new AjaxUpload(btnUpload, {
        action: '/electronic/billExcelUpload.sys',
        name: 'excelFile',
        data: {},
        onSubmit: function(file, ext){
            if (! (ext && /^(xls|xlsx)$/.test(ext))){
                status.text("엑셀파일만 등록 가능합니다."); // extension is not allowed 
                return false;
            }
            if(!confirm("작성한 엑셀정보을 등록하시겠습니까?")) return false;
            status.text('Uploading...');
        },
        onComplete: function(file, response){
            status.text('');
            $('#dialogUploadPop').jqmHide();
            if(fnTransResult(response,true)) {
            	$("#list").jqGrid("setGridParam", {'postData':$('#frmSearch').serializeObject()}).trigger("reloadGrid");
            }
        }
    });
    $('#dialogUploadPop').jqm();  //Dialog 초기화
    $("#btnBillBat").click(function(){
        $('#dialogUploadPop').jqmShow();
    });
    $("#closeButton").click(function(){ //Dialog 닫기
        $('#dialogUploadPop').jqmHide();
    });
    $('#dialogUploadPop').jqm().jqDrag('#dialogHandle');
    
	$('#btnBillReg').click(function () {	//등록
		fnBillDetail('');
	});
	$('#btnBillDel').click(function () {	//삭제
		var delRow = $("#list").jqGrid('getGridParam','selrow');
	 	if(delRow==null) { alert("삭제하실 Data를 선택 해 주십시오!"); return; }
	 	var selrowContent = $("#list").jqGrid('getRowData',delRow);
	 	if(!confirm("선택한 전표정보를 삭제 하시겠습니까?")) return;
		$.post(
			"/electronic/deleteBill.sys",
			{ bill_id:selrowContent.BILL_ID },
			function(msg) {
				var m = eval('(' + msg + ')');
				if (m.custResponse.success) {
					alert('삭제 되었습니다.');
					$("#srcButton").click();
				} else {
					alert('저장 중 오류가 발생했습니다.');
				}
			}
		);
	});
    
	$("#src_business_num").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#src_sale_num").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#src_business_nm").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#src_reference").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcButton").click(function() {
		$("#list")
		.jqGrid("setGridParam", {'postData':$('#frmSearch').serializeObject()})
		.trigger("reloadGrid");
	});
	$("#xlsButton").click(function() {
		var colLabels = ['발행코드','어음구분','은행','사업자명','사업자번호','전표번호','발행일','증빙일','만기일','물대 발행','초과기간','이자발행','총 어음발행','이자율','결제일','참조'];	//출력컬럼명
		var colIds = ['BILL_ID','BILL_FLAG','BANKCD','BUSINESS_NM','BUSINESS_NUM','SALE_NUM','PUBLIC_DATE','EVIDENCE_DATE','EXPIRE_DATE','PUBLIC_AMOUNT','OVER_PERIOD','INTEREST_AMOUNT','SUM_AMOUNT','INTEREST_RATE','RETURN_DATE','REFERENCE'];	//출력컬럼ID
		var numColIds = ['PUBLIC_AMOUNT','OVER_PERIOD','INTEREST_AMOUNT','SUM_AMOUNT','INTEREST_RATE'];	//숫자표현ID
		var sheetTitle = "전자어음 발행상세";	//sheet 타이틀
		var excelFileName = "BillDetailList";	//file명
		
		fnExportExcel($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
	});
	$("#list").jqGrid({
		url:'/newCate/selectElectronicBill/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['발행코드','어음구분','은행','사업자명','사업자번호','전표번호','발행일','증빙일','만기일','물대 발행','초과기간','이자발행','총 어음발행','이자율','결제일','기본발행일','참조'],
		colModel:[
			{name:'BILL_ID',width:50,align:'center', key:true},//발행코드
			{name:'BILL_FLAG',width:80,align:'center'},//어음구분
			{name:'BANKCD',width:80,align:'center'},//은행
			{name:'BUSINESS_NM',width:100,align:'left'},//사업자명
			{name:'BUSINESS_NUM',width:100,align:'center'},//사업자번호
			{name:'SALE_NUM',width:100,align:'center'},//전표번호
			{name:'PUBLIC_DATE',width:80,align:'center'},//발행일
			{name:'EVIDENCE_DATE',width:80,align:'center'},//증빙일
			{name:'EXPIRE_DATE',width:80,align:'center'},//증빙일
			{name:'PUBLIC_AMOUNT',width:100,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//물대 발행
			{name:'OVER_PERIOD',width:50,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//초과기간
			{name:'INTEREST_AMOUNT',width:90,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//이자발행
			{name:'SUM_AMOUNT',width:110,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//총어음발행
			{name:'INTEREST_RATE',width:60,align:'right',sorttype:'number',formatter:'number',
				formatoptions:{ decimalSeparator:".", thousandsSeparator:",", decimalPlaces: 2, prefix:"" }
			},//이자율
			{name:'RETURN_DATE',width:80,align:'center'},//결제일
			{name:'EXIST_PUBLIC_DATE',width:80,align:'center',hidden:true},//기본발행일
			{name:'REFERENCE',width:150}//참조
		],
		postData: $('#frmSearch').serializeObject(),
		rowNum:0,
        height:<%=listHeight%>,autowidth:true,
        sortname: 'bill_id', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        jsonReader : {root: "list",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	$(this).setCell(rowid,'SALE_NUM','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="SALE_NUM") {
            	fnBillDetail(selrowContent.BILL_ID);
            }
        },   
		loadComplete: function() {
			var rowCnt = $("#list").getGridParam('reccount');
			var sum_sum_amount = 0;
			var sum_return_amount = 0;
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = $("#list").jqGrid('getRowData',rowid);
					sum_sum_amount += Number(selrowContent.SUM_AMOUNT);
					if(selrowContent.RETURN_DATE!='') {
						sum_return_amount += Number(selrowContent.SUM_AMOUNT);
					}
				}
			}
			$("#resultTxt").html(" 총 어음발행 합 : "+$.number(sum_sum_amount)+" 원, &nbsp;&nbsp;&nbsp; 총 결제액 합 : "+$.number(sum_return_amount)+" 원");
			
			var footer_PUBLIC_AMOUNT = $("#list").jqGrid('getCol','PUBLIC_AMOUNT',false,'sum');
			var footer_INTEREST_AMOUNT = $("#list").jqGrid('getCol','INTEREST_AMOUNT',false,'sum');
			var footer_SUM_AMOUNT = $("#list").jqGrid('getCol','SUM_AMOUNT',false,'sum');
			$("#list").jqGrid('footerData','set',{BILL_ID:'합계', PUBLIC_AMOUNT:footer_PUBLIC_AMOUNT, INTEREST_AMOUNT:footer_INTEREST_AMOUNT, SUM_AMOUNT:footer_SUM_AMOUNT});
			
			$('table.ui-jqgrid-ftable tr:first').children('td').css('background-color', '#dfeffc');
			$('table.ui-jqgrid-ftable tr:first td:eq(0), table.ui-jqgrid-ftable tr:first td:eq(4)').children('td').css('padding-top', '8px');
			$('table.ui-jqgrid-ftable tr:first td:eq(0), table.ui-jqgrid-ftable tr:first td:eq(4)').children('td').css('padding-bottom', '8px');
		},
		footerrow:true, userDataOnFooter:true
	});
	// Resizing
	$(window).bind('resize', function() { 
		$("#list").setGridHeight(<%=listHeight %>);
		$("#list").setGridWidth(1500);
	}).trigger('resize');
});

function fnBillDetail(bill_id) {
	$('#billPop').css({'width':'650px','top':'20%','left':'30%'}).html('')
	.load('/menu/electronicBill/popBillMngt.sys?bill_id='+bill_id)
	.jqmShow();
}
</script>

</body>
</html>