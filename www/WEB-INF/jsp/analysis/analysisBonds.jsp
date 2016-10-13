<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   //그리드의 width와 Height을 정의
   String listHeight = "(($(window).height()-590) / 2) + Number(gridHeightResizePlus)";
   String listHeight2 = "(($(window).height()-140) / 2) + Number(gridHeightResizePlus)";
   String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
   
   @SuppressWarnings("unchecked")
   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   String pDate = (String)request.getAttribute("pDate");
   
   int EndYear   = 2003;
   int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
   int yearCnt = StartYear - EndYear + 1;
   String[] srcYearArr = new String[yearCnt];
   for(int i = 0 ; i < yearCnt ; i++){
      srcYearArr[i] = (StartYear - i) + "";
   }
   
   String[] colNames = null;
   if (pDate != null){
	   colNames = pDate.split("\\,");
   }
   
   String srcDate = CommonUtils.getCustomDay("MONTH", 0);
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
var _colName = new Array();
$(document).ready(function() {
	$("#srcDate").val("<%=srcDate%>");
	$("#srcButton2").click(function(){ fnSearch2(); });
   	$("#srcButton").click(function(){ fnSearch();});
   	$("#excelAll1").click(function(){ exportExcel(); });
   	$("#excelAll2").click(function(){ exportExcel2(); });
});

//날짜 조회 및 스타일
$(function(){
   $("#srcDate").datepicker(
      {
         showOn: "button",
         buttonImage: "/img/system/btn_icon_calendar.gif",
         buttonImageOnly: true,
         dateFormat: "yy-mm-dd"
      }
   );
   $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});


$(window).bind('resize', function() {
   $("#list").setGridHeight(<%=listHeight %>);
   $("#list2").setGridHeight(<%=listHeight2 %>);
   $("#list").setGridWidth(<%=listWidth %>);
   $("#list2").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var isOnLoad = false;
var _sale_sequ_numb = "";
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisBondsListJQGrid.sys',
      	datatype: 'json',
      	mtype: 'POST',
      	colNames:['구분','세금계산서 건수','잔액','잔액 비중'],
      	colModel:[
			{name:'rece_name',index:'rece_name',width:100,align:"center",search:false,sortable:false, editable:false },//공급사명	
            {name:'sale_cnt',index:'sale_cnt',width:90,align:"right",search:false,sortable:false, editable:false,
               sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'sum_amou',index:'sum_amou',width:90,align:"right",search:false,sortable:false, editable:false,
               sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'percent',index:'percent',width:90,align:"right",search:false,sortable:false, editable:false,
               sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 2, prefix:"" }}
      	],
		postData: {
			srcDate:$("#srcDate").val()
		},
		rowNum:0,
		height: <%=listHeight%>,autowidth: true,
		caption:"전체채권현황", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
        	var rowCnt = $("#list").getGridParam('reccount');
        	var totCnt = 0;
        	var totAmou = 0;
        	var amouArr = new Array();
       	 	for(var i=0;i<rowCnt;i++) {
       			var rowid = $("#list").getDataIDs()[i];
       			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
       			amouArr[i] = Number(selrowContent.sum_amou);
       			
       			totCnt += Number(selrowContent.sale_cnt);
       			totAmou += Number(selrowContent.sum_amou);
       			
       	 	}
       	 	var totPercent = 0;
       	 	for(var i=0;i<rowCnt;i++) {
       	 		var rowid = $("#list").getDataIDs()[i];
       	 		var percent = Number(amouArr[i]) / Number(totAmou) * 100;
	      		jq("#list").jqGrid('setRowData', rowid, {percent:percent});
	      		totPercent += Number(percent);
       	 	}
       	  	
      		jq("#list").addRowData(rowCnt + 1,{rece_name:"합계", sale_cnt:totCnt, sum_amou:totAmou, percent:totPercent});
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
	
	jq("#list2").jqGrid({
		datatype: 'json',
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisBondsDetailJQGrid.sys',
		mtype: 'POST',
		colNames:['pDate','구분','','','','','','','','','','','',''],
		colModel:[
   			{name:'PDATE',index:'PDATE',width:100,align:"left",search:false,sortable:true, editable:false,hidden:true },
   			{name:'bondsType',index:'bondsType',width:100,align:"left",search:false,sortable:true, editable:false },
           	{name:'M11',index:'M11',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M10',index:'M10',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M9',index:'M9',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M8',index:'M8',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M7',index:'M7',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M6',index:'M6',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M5',index:'M5',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M4',index:'M4',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M3',index:'M3',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M2',index:'M2',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M1',index:'M1',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
           	{name:'M0',index:'M0',width:100,align:"right",search:false,sortable:false, editable:false,
	            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }}
		],
		postData: {
			srcYear1:$("#srcYear1").val(),
			srcMonth1:$("#srcMonth1").val()
		},
      	rowNum:0,
      	height: <%=listHeight2%>,autowidth: true,
      	caption:"월별채권현황", 
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {
      		jq("#list2").jqGrid('setRowData', 1, {bondsType:"1개월 채권"});
      		jq("#list2").jqGrid('setRowData', 2, {bondsType:"2개월 채권"});
      		jq("#list2").jqGrid('setRowData', 3, {bondsType:"3개월 채권"});
      		jq("#list2").jqGrid('setRowData', 4, {bondsType:"4개월 채권"});
      		jq("#list2").jqGrid('setRowData', 5, {bondsType:"5개월 채권"});
      		jq("#list2").jqGrid('setRowData', 6, {bondsType:"6개월 채권"});
      		jq("#list2").jqGrid('setRowData', 7, {bondsType:"7개월 이상채권"});
      		
      		var selrowContent = jq("#list2").jqGrid('getRowData',1);
      		var pDateArr = selrowContent.PDATE.replace(/S/g,"").replace(/\[/g,"").replace(/\]/g,"").split(",");
      		
      		var colIdx = 0;
    		var colModel = jq("#list2").jqGrid('getGridParam', 'colModel');
    		_colName[0] = "구분";
      		for(var i = pDateArr.length-1 ; i >= 0 ; i--){
      			var colStr = pDateArr[i].substring(0,4)+'년 '+Number(pDateArr[i].substring(4,6))+'월기준';
      			jq("#list2").jqGrid("setLabel", colModel[colIdx+2]['name'], colStr);
      			
      			_colName[colIdx+1] = colStr;
      			colIdx++;
      		}
      		//############################20140218 합계###################################
      		var rowCnt = $("#list2").getGridParam('reccount');
      		var totM0 = 0;
   			var totM1 = 0;
   			var totM2 = 0;
   			var totM3 = 0;
   			var totM4 = 0;
   			var totM5 = 0;
   			var totM6 = 0;
   			var totM7 = 0;
   			var totM8 = 0;
   			var totM9 = 0;
   			var totM10 = 0;
   			var totM11 = 0;
        	var amouArr = new Array();
       	 	for(var i=0;i<rowCnt;i++) {
       			var rowid = $("#list2").getDataIDs()[i];
       			var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
       			amouArr[i] = Number(selrowContent.M11);
       			
       			//----------
       			totM0 += Number(selrowContent.M0);
       			totM1 += Number(selrowContent.M1);
       			totM2 += Number(selrowContent.M2);
       			totM3 += Number(selrowContent.M3);
       			totM4 += Number(selrowContent.M4);
       			totM5 += Number(selrowContent.M5);
       			totM6 += Number(selrowContent.M6);
       			totM7 += Number(selrowContent.M7);
       			totM8 += Number(selrowContent.M8);
       			totM9 += Number(selrowContent.M9);
       			totM10 += Number(selrowContent.M10);
       			totM11 += Number(selrowContent.M11);
       			
       	 	}
      		jq("#list2").addRowData(rowCnt + 1,{bondsType:"합계", M11:totM11, M10:totM10, M9:totM9, M8:totM8, M7:totM7, M6:totM6, M5:totM5, M4:totM4, M3:totM3, M2:totM2, M1:totM1, M0:totM0});
      	},
      //############################20140218 합계###################################
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	onSelectAll: function(aRowids,status) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){},
      	loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
      	jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
});

function fnSearch() {
	$("#list").jqGrid('setGridParam');
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcDate = $("#srcDate").val();
	jq("#list").trigger("reloadGrid");
	
}

function fnSearch2() {
	$("#list2").jqGrid('setGridParam');
	var data = jq("#list2").jqGrid("getGridParam", "postData");
	data.srcYear1 = $("#srcYear1").val();
	data.srcMonth1 = $("#srcMonth1").val();
	jq("#list2").trigger("reloadGrid");
}

function exportExcel() {
	   var colLabels = ['구분','세금계산서 건수','잔액','잔액 비중']; //출력컬럼명
	   var colIds = ['rece_name','sale_cnt','sum_amou','percent'];  //출력컬럼ID
	   var numColIds = ['sale_cnt','sum_amou','percent'];  //숫자표현ID
	   var sheetTitle = "전체채권현황"; //sheet 타이틀
	   var excelFileName = "analysisBonds"; //file명
	   fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcel2() {
	   var colLabels = _colName; //출력컬럼명
	   var colIds = ['bondsType','M11','M10','M9','M8','M7','M6','M5','M4','M3','M2','M1','M0'];  //출력컬럼ID
	   var numColIds = ['M11','M10','M9','M8','M7','M6','M5','M4','M3','M2','M1','M0'];  //숫자표현ID
	   var sheetTitle = "월별채권현황"; //sheet 타이틀
	   var excelFileName = "analysisBondsDetail"; //file명
	   fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>
<body>
   <form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
                     </td>
                     <td height="29" class="ptitle">채권관리</td>
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
                     <td colspan="10" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">채권기준일자</td>
                     <td class="table_td_contents">
                     	<input type="text" name="srcDate" id="srcDate" style="width: 75px; vertical-align: middle;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="10" height="1" bgcolor="eaeaea"></td>
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
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                     <td width="20" valign="top">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                     </td>
                     <td class="stitle">전체채권현황</td>
                     <td align="right" class="stitle">
                        <a href="#">
                           <img id="excelAll1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;vertical-align: middle;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
                        </a>
                        <a href="#">
                           <img id="srcButton" name="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width: 65px; height: 22px; border: 0px; vertical-align: middle;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />
                        </a>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         
         <tr>
            <td>
               <div id="jqgrid">
                  <table id="list"></table>
               </div>
            </td>
         </tr>
         <tr>
            <td>&nbsp;</td>
         </tr>
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                     <td width="20" valign="top">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                     </td>
                     <td class="stitle">월별채권현황</td>
                     <td align="right" class="stitle">
                        <a href="#">
                           <img id="excelAll2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;vertical-align: middle;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
                        </a>
                        <a href="#">
                           <img id="srcButton2" name="srcButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width: 65px; height: 22px; border: 0px; vertical-align: middle;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />
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
                     <td colspan="10" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">채권기준년월</td>
                     <td class="table_td_contents">
                        <select id="srcYear1" name="srcYear1" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                           <option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", -1).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                        </select> 년
                        
                        <select id="srcMonth1" name="srcMonth1" class="select" style="width: 40px;">
<%
   for(int i = 0 ; i < 12 ; i++){
%>
                           <option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%      
   }
%>                        
                        </select> 월                        
                        
                     </td>
                  </tr>
                  <tr>
                     <td colspan="10" height="1" bgcolor="eaeaea"></td>
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
            <td>
               <div id="jqgrid">
                  <table id="list2"></table>
               </div>
            </td>
         </tr>
         <tr>
            <td>&nbsp;</td>
         </tr>
      </table>
      <!-------------------------------- Dialog Div Start -------------------------------->
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>
      <div id="dialog" title="Feature not supported" style="display:none;">
         <p>That feature is not supported.</p>
      </div>        
      <!-------------------------------- Dialog Div End -------------------------------->
   </form>
</body>
</html>