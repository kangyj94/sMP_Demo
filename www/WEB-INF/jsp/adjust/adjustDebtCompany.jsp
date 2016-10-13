<%@page import="kr.co.bitcube.adjust.dto.AdjustDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   //그리드의 width와 Height을 정의
   String listHeight = "$(window).height()-340 + Number(gridHeightResizePlus)";
   String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

   @SuppressWarnings("unchecked")
   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   AdjustDto detailInfo = (AdjustDto)request.getAttribute("detailInfo");

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
	$("#buyi_tota_amou").val($.number("<%=detailInfo.getBuyi_tota_amou()%>"));
	$("#balance_amou").val($.number("<%=detailInfo.getBalance_amou()%>"));
	$("#avg_day").val($.number("<%=detailInfo.getAvg_day()%>", 2));	
	
	$("#srcButton").click(function(){fnSearch();});
	
   	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
   	$("#excelButton").click(function(){ exportExcel(); });  
   	
   	$("#phoneNum").val( fnSetTelformat( $("#phoneNum").val() ) );
});
$(window).bind('resize', function() {
   $("#list").setGridHeight(<%=listHeight %>);
   $("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
   	jq("#list").jqGrid({
	url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustDebtCompanyListJQGrid.sys',
    datatype: 'json',
    mtype: 'POST',
    colNames:['계산서일자','전자외담발행일','총채무','지급완료일자','지급액','잔액','구분','만기일','초과일수'],
    colModel:[
    	{name:'clos_buyi_date', index:'clos_buyi_date',width:110,align:"center",search:false,sortable:true, editable:false },
    	{name:'ele_etc_date', index:'ele_etc_date',width:110,align:"center",search:false,sortable:true, editable:false, hidden:false },
       	{name:'buyi_tota_amou', index:'buyi_tota_amou',width:110,align:"right",search:false,sortable:true, editable:false , 
        sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
       	{name:'buyi_pay_date',index:'buyi_pay_date',width:110,align:"center",search:false,sortable:true, editable:false, hidden:true },
       	{name:'rece_pay_amou',index:'rece_pay_amou',width:110,align:"right",search:false,sortable:true, editable:false , 
        sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
       	{name:'none_paym_amou',index:'none_paym_amou',width:110,align:"right",search:false,sortable:true, editable:false , 
        sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
       	{name:'tran_status_nm',index:'tran_status_nm',width:90,align:"center",search:false,sortable:true, editable:false, hidden:true },
       	{name:'expiration_date',index:'expiration_date',width:110,align:"center",search:false,sortable:true, editable:false, hidden:true },
       	{name:'buyi_over_day',index:'buyi_over_day',width:90,align:"center",search:false,sortable:true, editable:false, hidden:true }
    ],
    postData: {
       	vendorId:'<%=detailInfo.getVendorId()%>',
       	srcPayStat:$("#srcPayStat").val(),       
       	srcTranStat:$("#srcTranStat").val(),      
       	srcClosStartYear:$("#srcClosStartYear").val(), 
       	srcClosStartMonth:$("#srcClosStartMonth").val(), 
       	srcClosEndYear:$("#srcClosEndYear").val(),   
       	srcClosEndMonth:$("#srcClosEndMonth").val()   
    },
    rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
    height: <%=listHeight%>,autowidth: true,
    sortname: 'clos_buyi_date', sortorder: 'asc',
    caption:"", 
    viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
    loadComplete: function() {
       	var sum_buyi_tota_amou = 0;
       	var sum_rece_pay_amou = 0;
       	var sum_none_paym_amou = 0;
       	var rowCnt = jq("#list").getGridParam('reccount');
       	if(rowCnt>0) {
          	for(var i=0; i<rowCnt; i++) {
             	var rowid = $("#list").getDataIDs()[i];
             	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
             	sum_buyi_tota_amou += parseInt(selrowContent.buyi_tota_amou);
             	sum_rece_pay_amou += parseInt(selrowContent.rece_pay_amou);
             	sum_none_paym_amou += parseInt(selrowContent.none_paym_amou);  
          	}
       	}	
       
       	var userData = jq("#list").jqGrid("getGridParam","userData");
       	userData.clos_buyi_date = "합계";
       	userData.buyi_tota_amou = fnComma(sum_buyi_tota_amou);
       	userData.buyi_tota_amou = fnComma(sum_buyi_tota_amou);
       	userData.rece_pay_amou = fnComma(sum_rece_pay_amou);
       	userData.none_paym_amou = fnComma(sum_none_paym_amou);
    	jq("#list").jqGrid("footerData","set",userData,false);   
    },
    onSelectRow: function (rowid, iRow, iCol, e) {},
    ondblClickRow: function (rowid, iRow, iCol, e) {},
    onCellSelect: function(rowid, iCol, cellcontent, target){},
    loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
    jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell", userdata:"userdata" },
    rownumbers:true,
    footerrow: true,
    userDataOnFooter: true
   	});
//    	jQuery("#list").jqGrid('setGroupHeaders', {
//     	useColSpanStyle: true,
//       	groupHeaders:[
//          	{startColumnName: 'buyi_pay_date', numberOfColumns: 2, titleText: '<em>지급현황</em>'},
//          	{startColumnName: 'buyi_over_day', numberOfColumns: 1, titleText: '<em>지연현황</em>'}
//       	]
//    	});
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

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
    var data = jq("#list").jqGrid("getGridParam", "postData");
      
    data.srcPayStat      = $("#srcPayStat").val();
    data.srcTranStat     = $("#srcTranStat").val();
    data.srcClosStartYear   = $("#srcClosStartYear").val(); 
    data.srcClosStartMonth  = $("#srcClosStartMonth").val();
    data.srcClosEndYear     = $("#srcClosEndYear").val();
    data.srcClosEndMonth    = $("#srcClosEndMonth").val();
    data.vendorId        = '<%=detailInfo.getVendorId()%>'; 
    jq("#list").trigger("reloadGrid");     
}

function exportExcel() {
   var colLabels = ['계산서일자','총채무','지급액','잔액'];   //출력컬럼명
   var colIds = ['clos_buyi_date','buyi_tota_amou','rece_pay_amou','none_paym_amou'];  //출력컬럼ID
   var numColIds = ['buyi_tota_amou','rece_pay_amou','none_paym_amou']; //숫자표현ID
   var sheetTitle = "업체별채권현황";   //sheet 타이틀
   var excelFileName = "DebtCompanyList";   //file명
   fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>

<body>
   <form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
                     </td>
                     <td height="29" class="ptitle">업체별채무현황</td>
                     <td align="right" class="ptitle">&nbsp;</td>
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
                     <td class="table_td_subject" width="100">회사명</td>
                     <td class="table_td_contents">
                        <input id="vendorNm" name="vendorNm" type="text" value="<%=CommonUtils.getString(detailInfo.getVendorNm())%>" size="" maxlength="50" readonly="readonly" class="input_none" />
                     </td>
                     <td class="table_td_subject" width="100">사업자등록번호</td>
                     <td class="table_td_contents">
                        <input id="businessNum" name="businessNum" type="text" value="<%=CommonUtils.getString(detailInfo.getBusinessNum())%>" size="" maxlength="50" readonly="readonly"
                           class="input_none" />
                     </td>
                     <td class="table_td_subject" width="100">총채무액</td>
                     <td class="table_td_contents">
                        <input id="buyi_tota_amou" name="buyi_tota_amou" type="text" value="" size="" maxlength="50" readonly="readonly" class="input_none" style="text-align: right;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">주소</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="addres" name="addres" type="text" value="<%=CommonUtils.getString(detailInfo.getAddres())%>" size="" maxlength="50" style="width: 408px" readonly="readonly"
                           class="input_none" />
                     </td>
                     <td class="table_td_subject">총채무잔액</td>
                     <td class="table_td_contents">
                        <input id="balance_amou" name="balance_amou" type="text" value="" size="" maxlength="50" readonly="readonly" class="input_none" style="text-align: right;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">대표자</td>
                     <td class="table_td_contents">
                        <input id="pressentNm" name="pressentNm" type="text" value="<%=CommonUtils.getString(detailInfo.getPressentNm())%>" size="" maxlength="50" readonly="readonly"
                           class="input_none" />
                     </td>
                     <td class="table_td_subject">전화번호</td>
                     <td class="table_td_contents">
                        <input id="phoneNum" name="phoneNum" type="text" value="<%=CommonUtils.getString(detailInfo.getPhoneNum())%>" size="" maxlength="50" readonly="readonly" class="input_none" />
                     </td>
                     <td class="table_td_subject">평균지급기일</td>
                     <td class="table_td_contents">
                        <input id="avg_day" name="avg_day" type="text" value="" size="" maxlength="50" readonly="readonly" class="input_none" style="text-align: right;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">결재은행</td>
                     <td class="table_td_contents">
                        <input id="bankNm" name="bankNm" type="text" value="<%=CommonUtils.getString(detailInfo.getBankNm())%>" size="" maxlength="50" readonly="readonly" class="input_none" />
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
               <!-- 타이틀 시작 -->
               <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                     <td width="20" valign="top">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                     </td>
                     <td class="stitle">채무목록</td>
                     <td align="right" class="stitle">
                         <a id='srcButton' class='btn btn-primary btn-sm' style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>;'><i class="fa fa-search"></i> 조 회</a>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">마감년월</td>
                     <td class="table_td_contents">
                        <select id="srcClosStartYear" name="srcClosStartYear" class="select" style="width: 60px;">
<%
   for (int i = 0; i < srcYearArr.length; i++) {
%>
                           <option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : ""%>><%=srcYearArr[i]%></option>
<%
	}
%>
                        </select> 년 <select id="srcClosStartMonth" name="srcClosStartMonth" class="select" style="width: 40px;">
<%
	for (int i = 0; i < 12; i++) {
%>
                           <option value='<%=i + 1%>' <%="1".equals(i + 1 + "") ? "selected" : ""%>><%=i + 1%></option>
<%
	}
%>
                        </select> 월 ~ <select id="srcClosEndYear" name="srcClosEndYear" class="select" style="width: 60px;">
<%
	for (int i = 0; i < srcYearArr.length; i++) {
%>
                           <option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : ""%>><%=srcYearArr[i]%></option>
<%
	}
%>
                        </select> 년 <select id="srcClosEndMonth" name="srcClosEndMonth" class="select" style="width: 40px;">
<%
	for (int i = 0; i < 12; i++) {
%>
                           <option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%
	}
%>
                        </select> 월
                     </td>
                     <td class="table_td_subject" width="100">잔액여부</td>
                     <td class="table_td_contents">
                        <select id="srcPayStat" name="srcPayStat" class="select">
                           <option value="">전체</option>
                           <option value="10">있음</option>
                           <option value="20">없음</option>
                        </select>
                     </td>
                     <td class="table_td_subject" width="100">구분</td>
                     <td class="table_td_contents">
                        <select id="srcTranStat" name="srcTranStat" class="select">
                           <option value="">전체</option>
                           <option value="0">정상</option>
                           <option value="1">관리</option>
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
            <td height="20px" align="right" valign="bottom"></td>
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
      </table>
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>

      <!-------------------------------- Dialog Div Start -------------------------------->
      <!-------------------------------- Dialog Div End -------------------------------->
   </form>
</body>
</html>