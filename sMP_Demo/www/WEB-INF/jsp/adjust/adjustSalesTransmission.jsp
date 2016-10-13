<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-412 + Number(gridHeightResizePlus)";
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
   
   	$("#srcSalesConfStartDate").val('<%=CommonUtils.getCustomDay("MONTH", -1)%>');
   	$("#srcSalesConfEndDate").val('<%=CommonUtils.getCustomDay("DAY", 0)%>');
   
   	$("#srcButton").click(function(){ fnSearch(); });
   	$("#salesTransferButton").click(function(){ fnSalesTransfer(); });
   	$("#closeDateAppButton").click(function(){ fnCloseDateApp(); });
   
   	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
   	$("#excelButton").click(function(){ exportExcel(); });
    $("#excelAll").click(function(){ exportExcelToSvc(); });
   	
	$("#srcSalesName").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#srcSalesConfStartDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#srcSalesConfEndDate").keydown(function(e){
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
   $("#closeSalesDate").datepicker(
         {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
         }
   );
   $("#srcSalesConfStartDate").datepicker(
         {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
         }
   );
   $("#srcSalesConfEndDate").datepicker(
         {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
         }
   );
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
      mtype: 'POST',
      colNames:['clientId','branchId', 'paym_cond_code','bankCd', 'sale_sequ_numb','loginId','userNm','tel','branchNm','pressentNm','addres','branchBusiClas','branchBusiType','email','good_name', '*계산서일자','정산명','세금계산서고객사','사업자등록번호','매출확정일자','매출금액','고객유형 담당자','부가세','합계','주문제한 만기일','세금계산서 메일' ],
      colModel:[
       {name:'clientId', index:'clientId',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },                
       {name:'branchId', index:'branchId',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },                
       {name:'paym_cond_code',index:'paym_cond_code',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true },
       {name:'bankCd',index:'bankCd',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true },
       {name:'sale_sequ_numb', index:'sale_sequ_numb',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },      
       {name:'loginId', index:'loginId',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },   
       {name:'userNm', index:'userNm',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },   
       {name:'tel', index:'tel',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },   
       {name:'branchNm', index:'branchNm',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },   
       {name:'pressentNm', index:'pressentNm',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },   
       {name:'addres', index:'addres',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },   
       {name:'branchBusiClas', index:'branchBusiClas',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },   
       {name:'branchBusiType', index:'branchBusiType',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },
       {name:'email', index:'email',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },
       {name:'good_name', index:'good_name',width:160,align:"left",search:false,sortable:true, editable:false, hidden:true },
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
               var inputValue = this.value;                                // 입력 날짜
               var rowid = (this.id).split("_")[0];
               jq("#list").restoreRow(rowid);
               jq("#list").jqGrid('setRowData', rowid, {clos_sale_date:inputValue});
            }
         }]
         },
           editrules: {date: false}
       },
         {name:'sale_sequ_name', index:'sale_sequ_name',width:160,align:"left",search:false,sortable:true, editable:false },
         {name:'clientNm',index:'clientNm',width:180,align:"left",search:false,sortable:true, editable:false },
         {name:'businessNum',index:'businessNum',width:90,align:"center",search:false,sortable:true, editable:false },
         {name:'sale_conf_date',index:'sale_conf_date',width:70,align:"center",search:false,sortable:true, editable:false },
         {name:'sale_requ_amou',index:'sale_requ_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
          sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'workInfoUserNm',index:'workInfoUserNm',width:90,align:"center",search:false,sortable:true, editable:false },//고객유형 담당자
         {name:'sale_requ_vtax',index:'sale_requ_vtax',width:70,align:"right",search:false,sortable:true, editable:false , 
          sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'sale_tota_amou',index:'sale_tota_amou',width:90,align:"right",search:false,sortable:true, editable:false , 
          sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
         {name:'autOrderLimitPeriod', index:'autOrderLimitPeriod',search:false,hidden:true },//주문제한 만기일
         {name:'ebillEmail', index:'ebillEmail',search:false,hidden:false }//세금계산서 메일
      ],
      postData: {
         srcSalesName:$("#srcSalesName").val(),
         srcTransStatus:$("#srcTransStatus").val(),
         srcSalesConfStartDate:$("#srcSalesConfStartDate").val(),
         srcSalesConfEndDate:$("#srcSalesConfEndDate").val(),
         srcClientNm:$("#srcClientNm").val(),
         srcBusinessNum:$("#srcBusinessNum").val()
      },
      rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
      height: <%=listHeight%>, width:<%=listWidth%>,
      sortname: 'a.sale_conf_date', sortorder: 'desc',
      caption:"매출회계 전송", 
      viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete: function() {},
      onSelectRow: function (rowid, iRow, iCol, e) {},
      ondblClickRow: function (rowid, iRow, iCol, e) {},
      onCellSelect: function(rowid, iCol, cellcontent, target){
          var cm = $("#list").jqGrid("getGridParam", "colModel");
          var colName = cm[iCol];
          if(colName['index'] == "clos_sale_date"){
        	  jQuery('#list').jqGrid('editRow',rowid,true); 
          }
      },
      loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
      rownumbers:true
   });
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function exportExcel() {
	var colLabels = ['계산서일자','정산명','세금계산서고객사','사업자등록번호','매출확정일자','매출금액','고객유형 담당자','부가세','합계'];	//출력컬럼명
	var colIds = ['clos_sale_date','sale_sequ_name','clientNm','businessNum','sale_conf_date','sale_requ_amou','workInfoUserNm','sale_requ_vtax','sale_tota_amou'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var sheetTitle = "매출회계 전송";	//sheet 타이틀
	var excelFileName = "SalesTransmission";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['계산서일자','정산명','세금계산서고객사','사업자등록번호','매출확정일자','매출금액','공사유향 담당자','부가세','합계'];	//출력컬럼명
	var colIds = ['clos_sale_date','sale_sequ_name','clientNm','businessNum','sale_conf_date','sale_requ_amou','workInfoUserNm','sale_requ_vtax','sale_tota_amou'];	//출력컬럼ID
	var numColIds = ['sale_requ_amou','sale_requ_vtax','sale_tota_amou'];	//숫자표현ID
	var sheetTitle = "매출회계 전송";	//sheet 타이틀
	var excelFileName = "SalesTransmission";	//file명
	
	var actionUrl = "/adjust/adjustSalesTransmissionExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcSalesName';
	fieldSearchParamArray[1] = 'srcTransStatus';
	fieldSearchParamArray[2] = 'srcSalesConfStartDate';
	fieldSearchParamArray[3] = 'srcSalesConfEndDate';
	fieldSearchParamArray[4] = 'srcClientNm';
	fieldSearchParamArray[5] = 'srcBusinessNum';
	fieldSearchParamArray[6] = 'srcIsCollect';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnSearch(){
   jq("#list").jqGrid("setGridParam");
    var data = jq("#list").jqGrid("getGridParam", "postData");
    data.srcSalesName = $("#srcSalesName").val();
    data.srcTransStatus = $("#srcTransStatus").val();
    data.srcSalesConfStartDate = $("#srcSalesConfStartDate").val();
    data.srcSalesConfEndDate = $("#srcSalesConfEndDate").val();
    data.srcClientNm = $("#srcClientNm").val();
    data.srcBusinessNum = $("#srcBusinessNum").val();
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
   if(count == 0) {
      $("#dialog").html("<font size='2'>적용할 데이터를 선택해주세요.</font>");
      $("#dialog").dialog({
         title: 'Fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });          
      return;     
   }  
}

function fnSalesTransfer(){

   var closeDateArr  = new Array();
   var saleSequNumbArr = new Array();
   var saleSequNameArr = new Array();
   var saleRequAmouArr = new Array();
   var saleRequVtaxArr = new Array();
   var businessNumArr  = new Array();
   var paymCondCodeArr = new Array();
   var bankCodeArr 	   = new Array();
   var branchIdArr 	   = new Array();
   
   var loginIdArr		 = new Array();	
   var userNmArr         = new Array();
   var telArr            = new Array();
   var branchNmArr       = new Array();
   var pressentNmArr     = new Array();
   var addresArr         = new Array();
   var branchBusiClasArr = new Array();
   var branchBusiTypeArr = new Array();
   var good_nameArr 	 = new Array();
   var eMailArr 	 	 = new Array();
   var autOrderLimitPeriodArr = new Array(); //주문제한 만기일
   
   var id = $("#list").getGridParam('selarrrow');
   var ids = $("#list").jqGrid('getDataIDs');
   var count = 0;
   var chkCnt = 0;
   var rowNum = 0;
   
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
               closeDateArr[chkCnt]    = rowdata.clos_sale_date;
               saleSequNumbArr[chkCnt] = rowdata.sale_sequ_numb;
               saleSequNameArr[chkCnt] = rowdata.sale_sequ_name;
               saleRequAmouArr[chkCnt] = rowdata.sale_requ_amou;
               saleRequVtaxArr[chkCnt] = rowdata.sale_requ_vtax;
               businessNumArr[chkCnt]  = rowdata.businessNum;
               paymCondCodeArr[chkCnt] = rowdata.paym_cond_code;
               bankCodeArr[chkCnt] = rowdata.bankCd;
               branchIdArr[chkCnt] = rowdata.branchId;
               
               loginIdArr[chkCnt]    	 = rowdata.loginId;
               userNmArr[chkCnt]    	 = fnGetCharByte(rowdata.userNm, 30);
               telArr[chkCnt]    		 = rowdata.tel;
               branchNmArr[chkCnt]    	 = fnGetCharByte(rowdata.branchNm, 70);
               pressentNmArr[chkCnt]     = fnGetCharByte(rowdata.pressentNm, 30);
               addresArr[chkCnt]    	 = fnGetCharByte(rowdata.addres, 150);
               branchBusiClasArr[chkCnt] = fnGetCharByte(rowdata.branchBusiClas, 40);
               branchBusiTypeArr[chkCnt] = fnGetCharByte(rowdata.branchBusiType, 40);
               good_nameArr[chkCnt]      = rowdata.good_name;
               eMailArr[chkCnt]          = rowdata.ebillEmail;//rowdata.email; 세금계산서 이메일 나가는 부분 잠시 보류
               autOrderLimitPeriodArr[chkCnt] = rowdata.autOrderLimitPeriod;
               chkCnt++;
         }else{
            rowNum = ids[i];
         }
         count++;
      }
   }
   
   if(chkCnt != count) {
      $("#dialog").html("<font size='2'>"+rowNum+" 번째 행의 '계산서일자' 를 입력해주세요.</font>");
      $("#dialog").dialog({
         title: 'Fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });          
      return;
   }
   
   if(count == 0){
	   alert("전송할 데이터를 선택해주세요.");
	   return;
   }
   
   if(!confirm("선택하신 데이터를 전송하시겠습니까?")) return;

   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/adjustSalesTransApply.sys", 
      {  
         closeDateArr:closeDateArr,
         saleSequNumbArr:saleSequNumbArr,
         saleSequNameArr:saleSequNameArr,
         saleRequAmouArr:saleRequAmouArr,
         saleRequVtaxArr:saleRequVtaxArr,
         businessNumArr:businessNumArr,
         paymCondCodeArr:paymCondCodeArr,
         loginIdArr:loginIdArr,
         userNmArr:userNmArr,
         telArr:telArr,
         branchNmArr:branchNmArr,
         pressentNmArr:pressentNmArr,
         addresArr:addresArr,
         branchBusiClasArr:branchBusiClasArr,
         branchBusiTypeArr:branchBusiTypeArr,
         good_nameArr:good_nameArr,
         eMailArr:eMailArr,
         branchIdArr:branchIdArr,
         autOrderLimitPeriodArr:autOrderLimitPeriodArr
      },       
   
      function(arg){ 
         if(fnAjaxTransResult(arg)) {  //성공시
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
      <table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
                     </td>
                     <td height="29" class="ptitle">매출전송</td>
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
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                           <option value="10" selected="selected">매출확정</option>
                           <option value="20">매출전송</option>
                        </select>
                     </td>
                     <td class="table_td_subject" width="100">매출확정일자</td>
                     <td class="table_td_contents">
                        <input type="text" name="srcSalesConfStartDate" id="srcSalesConfStartDate" style="width: 75px;vertical-align: middle;"/> 
                           ~ 
                        <input type="text" name="srcSalesConfEndDate" id="srcSalesConfEndDate" style="width: 75px;vertical-align: middle;"/>
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
                     <td colspan="3" class="table_td_contents">
                        <input id="srcBusinessNum" name="srcBusinessNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/> (-없이)
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
         <tr><td height="1"></td></tr>
         <tr>
            <td>
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td class="stitle">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />  계산서일자 일괄적용
                        <input type="text" name="closeSalesDate" id="closeSalesDate" style="width: 75px;" />
                        <button id="closeDateAppButton" name="closeDateAppButton" class="btn btn-info btn-xs">
                           일괄적용
                        </button>
                     </td>
                     <td align="right" valign="middle">
                        <button id="salesTransferButton" name="salesTransferButton" class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
                           매출전송
                        </button>
<%--                <a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15"style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>  --%>
<%--                <a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>  --%>
<%--                <a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>  --%>
<%--                <a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>  --%>
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
</body>
</html>