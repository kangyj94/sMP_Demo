<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   	//그리드의 width와 Height을 정의
   	String listHeight = "$(window).height()-400 + Number(gridHeightResizePlus)";
//    	String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
   	String listWidth = "1500";

   	@SuppressWarnings("unchecked")
   	//화면권한가져오기(필수)
   	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	
	// 날짜 세팅
	
	int EndYear   = 2009;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
		srcYearArr[i] = (StartYear - i) + "";
	}   	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- file Upload 스크립트 -->

<style type="text/css">
.ui-jqgrid .ui-jqgrid-htable th div {
    height:auto;
    overflow:hidden;
    padding-right:2px;
    padding-left:2px;
    padding-top:4px;
    padding-bottom:4px;
    position:relative;
    vertical-align:text-top;
    white-space:normal !important;
}
/*
.ui-jqgrid tr.jqgrow td {
	font-weight: normal; 
	overflow: hidden; 
	white-space: nowrap; 
	height:50px; 
	padding: 0 2px 0 2px;
	border-bottom-width: 1px; 
	border-bottom-color: inherit; 
	border-bottom-style: solid;
}
*/
</style>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$("#srcButton").click(function(){fnSearch();});
	$("#creditSaveBtn").click(function(){creditSave();});
	
	$("#srcVendorNm").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#excelAll").click(function(){
		var colLabels = ['공급사명',	'매출액',			'평균납기일/납기준수율(%)(누적)',	'지정',			'일반',	
		                 '소계',		'이미지등록율',		'상품설명 등록율',						'BMT 부적합',	'품질검사 부적합',	
				          '품질VOC 발생','신규제안 사례 (채택/등록)',	'스마일 지수',	
				          '거래년수',	'기여금액 (매출이익)',	'신용평가정보']
		var colIds =['VENDORNM',	'BUYI_REQU_AMOU',	'DELI_INFO',		'JIJUNG_CNT',		'ILBAN_CNT',		
		             'GOOD_CNT',	'IMG_REG_RATE',		'DESC_REG_RATE',	'BMT_UNFIT', 		'QUALITY_UNFIT',	
		             'VOC_CNT',		'NEW_MATER_CNT', 	'SMILE_EVAL',		
		             'DEAL_YEAR', 		'CONTRI_AMOU',	'CREDITINFO'];
		
		var numColIds ;
		if( $("#srcMonth").val()){
			numColIds = ['BUYI_REQU_AMOU',	'BMT_UNFIT', 'QUALITY_UNFIT',	 'CONTRI_AMOU'];
		}else{
			numColIds = ['BUYI_REQU_AMOU',	'BMT_UNFIT', 'QUALITY_UNFIT',	 'CONTRI_AMOU'];			
		}

		var sheetTitle = "공급사 평가";
		var excelFileName = "vendorEval";
		var fieldSearchParamArray = new Array();
		fieldSearchParamArray[0] = 'srcYear';
		fieldSearchParamArray[1] = 'srcMonth';
		fieldSearchParamArray[3] = 'srcVendorNm';
		fieldSearchParamArray[4] = 'srcVenIsUse';
		fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,"/organ/getVenEvaluationExcel.sys");
	});
});

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var test =1;
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/getVenEvaluationList.sys',
		datatype: 'local',
		mtype: 'POST',
		colNames:[	'공급사명',	'매출액',	'평균납기일/<br/>납기준수율(%)<br/>(누적)',	'지정',	'일반',	'소계',
		          	'이미지<br>등록율',	'상품설명<br/>등록율',	'BMT<br/>부적합',	'품질검사<br/>부적합',	'품질VOC<br/>발생',	
		          	'신규제안<br/>사례<br/>(채택/등록)',	'스마일<br/>지수',	'거래년수',	'기여금액<br/>(매출이익)',	'평가',
		          	' ','VENDORID'
		   ],
		colModel:[
			{name:'VENDORNM',		index:'VENDORNM',		width:160,align:"left",search:false,sortable:true, editable:false}, //공급사명
			{name:'BUYI_REQU_AMOU',	index:'BUYI_REQU_AMOU',	width:100,align:"right",search:false,sortable:true, editable:false, formatter:fnComma}, //매출액
			{name:'DELI_INFO',		index:'DELI_INFO',		width:150,align:"center",search:false,sortable:true, editable:false}, //평균납기일/납기준수율(%)
			{name:'JIJUNG_CNT',		index:'JIJUNG_CNT',		width:50,align:"right",search:false,sortable:true, editable:false, formatter:fnComma},  //지정
			{name:'ILBAN_CNT',		index:'ILBAN_CNT',		width:50,align:"right",search:false,sortable:true, editable:false, formatter:fnComma},  //일반
			{name:'GOOD_CNT',		index:'GOOD_CNT',		width:50,align:"right",search:false,sortable:true, editable:false, formatter:fnComma},  //소계
			{name:'IMG_REG_RATE',	index:'IMG_REG_RATE',	width:60,align:"center",search:false,sortable:true, editable:false},  //이미지등롤율
			{name:'DESC_REG_RATE',	index:'DESC_REG_RATE',	width:70,align:"center",search:false,sortable:true, editable:false},  //상품설명 등록율
			{name:'BMT_UNFIT', 		index:'BMT_UNFIT',		width:70,align:"center",search:false,sortable:true, editable:false},  //BMT 부적합
			{name:'QUALITY_UNFIT',	index:'QUALITY_UNFIT',	width:70,align:"center",search:false,sortable:true, editable:false},  //품질검사 부적함
			{name:'VOC_CNT',		index:'VOC_CNT',		width:70,align:"center",search:false,sortable:true, editable:false},  //품질VOC발생
			{name:'NEW_MATER_CNT', 	index:'NEW_MATER_CNT',	width:80,align:"center",search:false,sortable:true, editable:false},  //신규제안 사례(채택/등록)
			{name:'SMILE_EVAL',		index:'SMILE_EVAL',		width:60,align:"center",search:false,sortable:true, editable:false},  //스마일지수
			{name:'DEAL_YEAR', 		index:'DEAL_YEAR',		width:80,align:"center",search:false,sortable:true, editable:false},  //거래년수
			{name:'CONTRI_AMOU',	index:'CONTRI_AMOU',	width:80,align:"right",search:false,sortable:true, editable:false, formatter:fnComma},  //기여금액(매출이익)
			{name:'CREDITINFO',	    index:'CREDITINFO',		width:40,align:"center",search:false,sortable:true, editable:false},   //신용평가 정보
			{name:'BTN',	    	index:'BTN',			width:90,align:"center",search:false,sortable:false, editable:false},   //신용평가  정보 버튼
			{name:'VENDORID',		index:'VENDORID',		hidden:true}   //VENDORID
		],
		postData: {
			srcYear  	: $("#srcYear").val() , 
			srcMonth 	: $("#srcMonth").val() , 
			srcVendorNm : $("#srcVendorNm").val(),  
			srcVenIsUse : $("#srcVenIsUse").val()  
		},
		rowNum:0, rownumbers:false, 
		
		height: <%=listHeight%>,width: <%=listWidth %>,
		sortname: 'BUYI_REQU_AMOU', sortorder: "DESC",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = $("#list").getGridParam('reccount');
			for(var i=0;i<rowCnt;i++) {
				var rowid = $("#list").getDataIDs()[i];
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				
				
			}
			var userData = $("#list").jqGrid("getGridParam","userData");
// 			
			$("#list").jqGrid("footerData","set",userData,false);
		},
		afterInsertRow: function(rowid, aData){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var VENDORID =  selrowContent.VENDORID ;
			var creditHtml;
			var btnHtml;
			if( VENDORID ){
				creditHtml =  "<span id='credit_"+VENDORID+"' >"+selrowContent.CREDITINFO + "</span>";
				
				btnHtml = "<button onclick='openCreditDiv(\""+VENDORID+"\");' class='btn btn-danger btn-xs' style='padding-top: 0px;padding-bottom: 0px;border-radius: 5px;'> 등록</button>";
				btnHtml += " <button  class='btn btn-default btn-xs' style='padding-top: 0px;padding-bottom: 0px;border-radius: 5px;'> 조회</button>";				
			}else{
				creditHtml = '-'
			}
			
			jq("#list").setCell(rowid,'CREDITINFO',creditHtml,{});  
			jq("#list").setCell(rowid,'BTN',btnHtml,{});  
			
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell",userdata:"userData"}
	});
	
	jq("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
			groupHeaders:[
				{startColumnName: 'JIJUNG_CNT', numberOfColumns: 3, titleText: '운영상품 (누적)'},
				{startColumnName: 'IMG_REG_RATE', numberOfColumns: 2, titleText: '상품관리 (누적)'},
				{startColumnName: 'BMT_UNFIT', numberOfColumns: 3, titleText: '품질 관리 능력'},
				{startColumnName: 'CREDITINFO', numberOfColumns: 3, titleText: '신용평가정보'}
			]
	});
});

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch(){
	jq("#list").jqGrid("setGridParam", {page:1, datatype:"json"});
   	var data = jq("#list").jqGrid("getGridParam", "postData");
   	data.srcYear    	= $("#srcYear").val();
   	data.srcMonth    	= $("#srcMonth").val();
   	data.srcVendorNm 	= $("#srcVendorNm").val();
   	data.srcVenIsUse 	= $("#srcVenIsUse").val();
   	jq("#list").trigger("reloadGrid");  	
}

function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
	n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}
//송장번호변경 DIV 띄우기 
var selVenId;
function openCreditDiv( vendorId ){
	
	$("#creditInfoDiv").dialog({width:200,height:120});
	$("#creditInfoDiv").dialog("open");
	$("#creditInfo").val('');
	selVenId = vendorId;
}

function creditSave(){
	var creditInfo = $.trim( $("#creditInfo").val() );
	
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/updateCreditInfo/save.sys", 
		{ VENDORID : selVenId, CREDITINFO:creditInfo ,oper:"edit"},
		function(arg){ 
			if(fnTransResult(arg, true)) {	//성공시
				$("#credit_"+selVenId).html(  creditInfo  );
				$("#creditInfo").val("");
				$("#creditInfoDiv").dialog("close");
			}
		}
	);
	
	
}

</script>
</head>

<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<body>
<div id="creditInfoDiv" title="신용평가정보 입력" style="display: none; font_size: 12px; height: 100px;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2" class="table_top_line"></td>
		</tr>
		<tr>
			<td class="table_td_subject">평가</td>
			<td class="table_td_contents">
				<input id="creditInfo" name="creditInfo" type="text" size="10" maxlength="10" />
			</td>
		</tr>
		<tr>
			<td colspan="2" class="table_top_line"></td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<button id='creditSaveBtn' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">입력</button>
			</td>
		</tr>		
		<tr>
			<td colspan="2" height="10"></td>
		</tr>
	</table>
</div>
<!-- <form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data"> -->
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0" style="margin-top: 2px;">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">공급사 현황</td>
					<td align="right" class="ptitle">
						<button id='excelAll' class="btn btn-success btn-xs"><i class="fa fa-file-excel-o"></i> 일괄엑셀</button>
						<button id='srcButton' class="btn btn-primary btn-xs"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="100px;"/>
					<col width="400px;"/>
					<col width="100px;"/>
					<col width="400px;"/>
					<col width="100px;"/>
					<col width="400px;"/>
				</colgroup>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">조회 년/월</td>
					<td class="table_td_contents">
					
						<select id="srcYear" name="srcYear" class="select" style="width: 100px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
							<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
						</select> 년
                        <select id="srcMonth" name="srcMonth" class="select" style="width: 60px;">
                        	<option value="">선택</option>
<%
   for(int i = 0 ; i < 12 ; i++){
	   String monthVal = new Integer(i + 1).toString().length() == 1 ? "0" + new Integer(i + 1) : new Integer(i + 1).toString();
%>
							<option value='<%=monthVal%>' ><%=monthVal %></option>
<%      
   }
%>                        
						</select> 월							

					</td>
					<td class="table_td_subject" width="100">공급사명</td>
					<td class="table_td_contents">
                        <input id="srcVendorNm" name="srcVendorNm" style="width: 300px;height: 23px;"/>
					</td>
					<td class="table_td_subject" width="100">공급사 사용</td>
					<td class="table_td_contents">
                        <select id="srcVenIsUse" name="srcVenIsUse" >
                        	<option value="">전체</option>
                        	<option value="1" selected="selected">사용</option>
                        	<option value="0">종료</option>
                        </select>
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
			<td width="1500px" valign="bottom" align="right" >(금액단위 : 백만원)</td>
         </tr>
         <tr>
            <td>
               <div id="jqgrid" >
                  <table id="list"></table>
                  <div id="pager"></div>
               </div>
            </td>
         </tr>
<!--          <tr> -->
<!--             <td height="10">&nbsp;</td> -->
<!--          </tr> -->
      </table>
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>

      <!-------------------------------- Dialog Div Start -------------------------------->
      <!-------------------------------- Dialog Div End -------------------------------->
<!--    </form> -->
</body>
</html>