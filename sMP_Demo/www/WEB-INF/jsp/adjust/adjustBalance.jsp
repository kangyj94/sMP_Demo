<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-360 + Number(gridHeightResizePlus)";
	String listWidth = "1500";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	int EndYear   = 2003;
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
	$("#detailView").click( function() { onDetail(); });
	$("#srcButton").click( function() { fnSearch(); });
	
	$("#excelButton").click(function(){ exportExcel(); });
});
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight%> );
	$("#list").setGridWidth(1500);
}).trigger('resize');


//날짜 조회 및 스타일
$(function(){
   $("#srcConfStartDate").datepicker(
         {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm"
         }
   );
   $("#srcConfEndDate").datepicker(
         {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm"
         }
   );
   $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
   jq("#list").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBalanceListJQGrid.sys',
      datatype: 'json',
      mtype: 'POST',
      colNames:['세금계산년월','매출수량','매출금액','매입수량','매입금액','상세'],
      colModel:[
         {name:'sale_conf_date',index:'clos_sale_date',width:100,align:"center",search:false,sortable:true, editable:false, formatter:'date'},
         {name:'sale_prod_quan', index:'sale_prod_quan',width:150,align:"right",search:false,sortable:true, editable:false,
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'sale_prod_amou', index:'sale_prod_amou',width:120,align:"right",search:false,sortable:true, editable:false, hidden:false,
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},  
         {name:'buyi_prod_quan', index:'buyi_prod_quan',width:150,align:"right",search:false,sortable:true, editable:false, 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'buyi_prod_amou', index:'buyi_prod_amou',width:120,align:"right",search:false,sortable:true, editable:false, hidden:false,
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'descYn',index:'descYn',width:100,align:"center",search:false,sortable:true, editable:false}
      ],
      postData: {
        srcConfStartYear:$("#srcConfStartYear").val(), 
      	srcConfStartMonth:$("#srcConfStartMonth").val(),
      	srcConfEndYear:$("#srcConfEndYear").val(),
      	srcConfEndMonth:$("#srcConfEndMonth").val() 
      },
      rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
      height: <%=listHeight%>,width: <%=listWidth%>,
      sortname: 'sale_conf_date', sortorder: 'desc',
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {
         var rowCnt = jq("#list").getGridParam('reccount');
         if(rowCnt>0) {
            for(var i=0; i<rowCnt; i++) {
               var rowid = $("#list").getDataIDs()[i];
               var selrowContent = jq("#list").jqGrid('getRowData',rowid);
               var descStr = "<input type='button' name='detailView' id='detailView' value='상세보기' onClick=\"javaScript:onDetail('" + selrowContent.sale_conf_date +"')\"/>";
               if(selrowContent.descYn == "Y"){
                  jq("#list").jqGrid('setRowData', rowid, {descYn:descStr});
               } else {
                  jq("#list").jqGrid('setRowData', rowid, {descYn:''});
               }
            }
         }        
      },
      onSelectRow: function (rowid, iRow, iCol, e) {},
      ondblClickRow: function (rowid, iRow, iCol, e) {},
      onCellSelect: function(rowid, iCol, cellcontent, target){},
      loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
   });
});

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function onDetail(obj){
	if( obj != "" ){
    	var popurl = "/adjust/adjustBalanceDetailPop.sys?srcConfDate=" + obj + "&_menuId=<%=_menuId%>";
      	var popproperty = "dialogWidth:720px;dialogHeight=480px;scroll=yes;status=no;resizable=no;";
       	//window.showModalDialog(popurl,self,popproperty);
       	window.open(popurl, 'okplazaPop', 'width=720, height=480, scrollbars=yes, status=no, resizable=no');
   	} else { jq( "#dialogSelectRow" ).dialog(); }      
}

function fnSearch(){
   jq("#list").jqGrid("setGridParam");

   var data = jq("#list").jqGrid("getGridParam", "postData");
   data.srcConfStartYear   = $("#srcConfStartYear").val(); 
   data.srcConfStartMonth  = $("#srcConfStartMonth").val();
   data.srcConfEndYear     = $("#srcConfEndYear").val(); 
   data.srcConfEndMonth    = $("#srcConfEndMonth").val(); 
   jq("#list").trigger("reloadGrid");  
}
function exportExcel() {
	var colLabels = ['세금계산년월','매출수량','매출금액','매입수량','매입금액'];	//출력컬럼명
	var colIds = ['sale_conf_date','sale_prod_quan','sale_prod_amou','buyi_prod_quan','buyi_prod_amou'];	//출력컬럼ID
	var numColIds = ['sale_prod_quan','sale_prod_amou','buyi_prod_quan','buyi_prod_amou'];	//숫자표현ID
	var sheetTitle = "정산수불부";	//sheet 타이틀
	var excelFileName = "AdjustBalance";	//file명
	
	var fieldSearchParamArray = new Array();     //파라메타 변수ID
	fieldSearchParamArray[0] = 'srcConfStartYear';
	fieldSearchParamArray[1] = 'srcConfStartMonth';
	fieldSearchParamArray[2] = 'srcConfEndYear';
	fieldSearchParamArray[3] = 'srcConfEndMonth';
	
	fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/adjust/adjustBalanceExcel.sys");
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
                     <td height="25" class="ptitle">정산수불부</td>
                     <td align="right" class="ptitle">
                        <button id="srcButton" name="srcButton" class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
                           <i class="fa fa-search"></i> 조회
                        </button>
                     </td>
                  </tr>
                  <tr><td height="1"></td></tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
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
                     <td class="table_td_subject" width="100">세금계산년월</td>
                     <td colspan="5" class="table_td_contents">
                        <select id="srcConfStartYear" name="srcConfStartYear" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                           <option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", -1).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                        </select> 년
                        
                        <select id="srcConfStartMonth" name="srcConfStartMonth" class="select" style="width: 50px;">
<%
   for(int i = 0 ; i < 12 ; i++){
%>
                           <option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", -1).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%      
   }
%>                        
                        </select> 월 ~                          
                        
                        <select id="srcConfEndYear" name="srcConfEndYear" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                           <option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                        </select> 년
                        
                        <select id="srcConfEndMonth" name="srcConfEndMonth" class="select" style="width: 50px;">
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
            <td height="5"></td>
         </tr>
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                     <td width="20" valign="top">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                     </td>
                     <td class="stitle">정산수불부목록</td>
                     <td align="right" valign="bottom">
                        <button id='excelButton' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
                           <i class="fa fa-file-excel-o"></i> 엑셀
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

      <!-------------------------------- Dialog Div Start -------------------------------->
      <!-------------------------------- Dialog Div End -------------------------------->
   </form>
</body>
</html>