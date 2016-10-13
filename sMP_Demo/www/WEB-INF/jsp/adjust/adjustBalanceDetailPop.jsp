<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   @SuppressWarnings("unchecked")
   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   String srcConfDate = (String) request.getAttribute("srcConfDate");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#excelButton").click(function(){ exportExcel(); });	
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
   jq("#list").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBalanceDetailJQGrid.sys',
      datatype: 'json',
      mtype: 'POST',
      colNames:['주문유형','주문번호','발주차수','납품차수','인수차수','매출수량','매출금액','매입수량','매입금액'],
      colModel:[
         {name:'orde_type_clas_nm',index:'orde_type_clas_nm',width:80,align:"center",search:false,sortable:true, editable:false},
         {name:'order_num',index:'order_num',width:100,align:"center",search:false,sortable:true, editable:false, formatter:'date'},
         {name:'purc_iden_numb',index:'purc_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},
         {name:'deli_iden_numb',index:'deli_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},         
         {name:'rece_iden_numb',index:'rece_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},         
         {name:'sale_prod_quan', index:'sale_prod_quan',width:115,align:"right",search:false,sortable:true, editable:false, 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'sale_prod_amou', index:'sale_prod_amou',width:120,align:"right",search:false,sortable:true, editable:false, 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},  
         {name:'buyi_prod_quan', index:'buyi_prod_quan',width:110,align:"right",search:false,sortable:true, editable:false, 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'buyi_prod_amou', index:'buyi_prod_amou',width:120,align:"right",search:false,sortable:true, editable:false , 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }}
      ],
      postData: {srcConfDate:'<%=srcConfDate%>'},
      rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000], pager: '#pager',
      height: 280,autowidth: true,
      sortname: 'ORDER_NUM', sortorder: 'desc',
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {
       var rowCnt = $("#list").getGridParam('reccount');
       for(var i=0;i<rowCnt;i++) {
          var rowid = $("#list").getDataIDs()[i];
             jq("#list").setCell(rowid,'order_num','',{color:'#0000ff'});
          jq("#list").setCell(rowid,'order_num','',{cursor:'pointer'});  
       }         
      },
      onSelectRow: function (rowid, iRow, iCol, e) {},
      ondblClickRow: function (rowid, iRow, iCol, e) {},
      onCellSelect: function(rowid, iCol, cellcontent, target){
 	     var cm = $("#list").jqGrid("getGridParam", "colModel");
	     var colName = cm[iCol];
	     var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	     if(colName['index'] == "order_num"){
	    	 <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, '" +_menuId+ "', selrowContent.purc_iden_numb);")%>
	     }        
      },
      loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
   });
});

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function exportExcel() {
	var colLabels = ['주문유형','주문번호','발주차수','납품차수','매출수량','매출금액','매입수량','매입금액'];	//출력컬럼명
	var colIds = ['orde_type_clas_nm','order_num','purc_iden_numb', 'deli_iden_numb','sale_prod_quan','sale_prod_amou','buyi_prod_quan','buyi_prod_amou'];	//출력컬럼ID
	var numColIds = ['sale_prod_quan','sale_prod_amou','buyi_prod_quan','buyi_prod_amou'];	//숫자표현ID
	var sheetTitle = "정산수불부상세";	//sheet 타이틀
	var excelFileName = "AdjustBalanceDetail";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>

<body >
   <table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
      <tr>
         <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif);">
               <tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>정산수불부 상세</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose"  onclick="javaScript:window.close();">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
            </table>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" >
               <tr>
                  <td align="right" style="padding: 2px; padding-right: 0px;">
                   <button id='excelButton' class="btn btn-success btn-xs" style='display:inline;'>
                           <i class="fa fa-file-excel-o"></i> 엑셀
                        </button>
                  </td>
               </tr>
               <tr>
                  <td>
                     <div id="jqgrid">
                        <table id="list"></table>
                        <div id="pager"></div>
                     </div>
                  </td>
               </tr>
               <tr>
                  <td>&nbsp;</td>
               </tr>
               <tr>
                  <td align="center">
                  <button id="closeButton" type="button" class="btn btn-default btn-sm isWriter" onclick="javaScript:window.close();"><i class="fa fa-close"></i>닫기</button>
                  </td>
               </tr>
            </table>
         </td>
      </tr>
   </table>
</body>
</html>