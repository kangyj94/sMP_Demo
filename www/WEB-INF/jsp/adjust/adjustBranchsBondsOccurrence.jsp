<%@page import="java.util.HashMap"%>
<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.adjust.dto.AdjustDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   //그리드의 width와 Height을 정의
   String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   String listHeight = "$(window).height()-680 + Number(gridHeightResizePlus)";
   String list2Height = "$(window).height()-635 + Number(gridHeightResizePlus)";
   String list3Height = "$(window).height()-630 + Number(gridHeightResizePlus)";
   
   String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

   @SuppressWarnings("unchecked")
   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   
   int EndYear   = 2003;
   int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
   int yearCnt = StartYear - EndYear + 1;
   String[] srcYearArr = new String[yearCnt];
   for(int i = 0 ; i < yearCnt ; i++){
      srcYearArr[i] = (StartYear - i) + "";
   }    
   LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$("#srcButton").click(function(){fnSearch();});
	$("#regButton2").click(function(){fnAddBonds();});
	$("#delButton2").click(function(){fnDelBonds();});
	
	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#colButton3").click( function(){ jq("#list3").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelButton3").click(function(){ exportExcel3(); });
	$("#regButton2").hide();
	$("#delButton2").hide();
});

$(window).bind('resize', function() {
   $("#list").setGridHeight(<%=listHeight %>);
   $("#list3").setGridWidth($(window).width() - 60 + Number(gridWidthResizePlus));
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var isOnLoad = false;   //list2, 그리드를 한번만 초기화하기 위해
var setRowId = "";
jq(function() {
	jq("#list").jqGrid({
    	url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustBranchBondsCompanyListJQGrid.sys',
      	datatype: 'json',
      	mtype: 'POST',
      	colNames:['sale_sequ_numb','accManageUserId','전표번호','사업장명','계산서일자','총채무','입금일자','금액','잔액','구분','만기일','경과월','초과일수'],
      	colModel:[
         	{name:'sale_sequ_numb', index:'sale_sequ_numb',width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },
         	{name:'accManageUserId', index:'accManageUserId',width:60,align:"center",search:false,sortable:true, editable:false, hidden:true },
         	{name:'sap_jour_numb', index:'sap_jour_numb',width:120,align:"center",search:false,sortable:true, editable:false, hidden:true },
         	{name:'branchNm', index:'branchNm',width:150,align:"left",search:false,sortable:true, editable:false },
         	{name:'clos_sale_date', index:'clos_sale_date',width:100,align:"center",search:false,sortable:true, editable:false },
         	{name:'sale_tota_amou', index:'sale_tota_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'alram_date',index:'alram_date',width:100,align:"center",search:false,sortable:true, editable:false },//입금일자
//          	{name:'sale_pay_date',index:'sale_pay_date',width:100,align:"center",search:false,sortable:true, editable:false },//수금완료일자
         	{name:'rece_pay_amou',index:'rece_pay_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//금액
         	{name:'none_coll_amou',index:'none_coll_amou',width:100,align:"right",search:false,sortable:true, editable:false , 
            sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//잔액
         	{name:'tran_status_nm',index:'tran_status_nm',width:60,align:"center",search:false,sortable:true, editable:false },//구분
         	{name:'expiration_date',index:'expiration_date',width:100,align:"center",search:false,sortable:true, editable:false },//만기일
         	{name:'sale_over_month',index:'sale_over_month',width:70,align:"center",search:false,sortable:true, editable:false },//경과월
         	{name:'sale_over_day',index:'over_date',width:70,align:"center",search:false,sortable:true, editable:false }//초과일수
      	],
      	postData: {
         	clientId:'<%=userInfoDto.getClientId()%>',
         	srcPayStat:$("#srcPayStat").val(),       
         	srcTranStat:$("#srcTranStat").val(),      
         	srcClosStartYear:$("#srcClosStartYear").val(), 
         	srcClosStartMonth:$("#srcClosStartMonth").val(), 
         	srcClosEndYear:$("#srcClosEndYear").val(),   
         	srcClosEndMonth:$("#srcClosEndMonth").val(),
         	srcBranchId:"<%=userInfoDto.getSmpBranchsDto().getBranchId()%>"
      	},
      	rowNum:0, rownumbers: false, rowList:[30,50,100], pager: '#pager',
      	height: <%=listHeight%>,autowidth: true,
      	sortname: 'clos_sale_date', sortorder: 'desc',
      	caption:"발생채무별현황", 
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {
        	var sum_sale_tota_amou = 0;
          	var sum_rece_pay_amou = 0;
          	var sum_none_coll_amou = 0;
          	var rowCnt = jq("#list").getGridParam('reccount');
          	if(rowCnt>0) {
          		if(setRowId == ""){
          			setRowId = $("#list").getDataIDs()[0]; //첫번째 로우 아이디 구하기	
          		}

             	for(var i=0; i<rowCnt; i++) {
                	var rowid = $("#list").getDataIDs()[i];
                	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                	sum_sale_tota_amou += parseInt(selrowContent.sale_tota_amou);
                	sum_rece_pay_amou += parseInt(selrowContent.rece_pay_amou);
                	sum_none_coll_amou += parseInt(selrowContent.none_coll_amou);  
             	}
             	isOnLoad = true;
             	jq("#list").setSelection(setRowId);
          	}
          	var userData = jq("#list").jqGrid("getGridParam","userData");
          	userData.clos_sale_date = "합계";
          	userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
          	userData.sale_tota_amou = fnComma(sum_sale_tota_amou);
          	userData.rece_pay_amou = fnComma(sum_rece_pay_amou);
          	userData.none_coll_amou = fnComma(sum_none_coll_amou);
          	jq("#list").jqGrid("footerData","set",userData,false);   
      	},
      	onSelectRow: function (rowid, iRow, iCol, e) {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt > 0) {
  				var id = $("#list").jqGrid('getGridParam', "selrow" );
  				var selrowContent = jq("#list").jqGrid('getRowData',id);
  				fnProdDetail(selrowContent.sale_sequ_numb, isOnLoad);
  				$("#sel_sale_sequ_numb").val(selrowContent.sale_sequ_numb);
  				$("#sel_rece_pay_amou").val(selrowContent.sale_tota_amou);
  				
  				var userId = '<%=userInfoDto.getUserId()%>';
  				
  				if(selrowContent.accManageUserId == userId){
  					$("#regButton2").show();
  					$("#delButton2").show();
  				}else{
  					$("#regButton2").hide();
  					$("#delButton2").hide();
  				}
  				setRowId = id;
			}       		
      	},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){},
      	loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      	jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
      	rownumbers:true,
      	footerrow: true,
      	userDataOnFooter: true
   	});
   	jQuery("#list").jqGrid('setGroupHeaders', {
    	useColSpanStyle: true,
      	groupHeaders:[
        	{startColumnName: 'alram_date', numberOfColumns: 2, titleText: '<em>수금현황</em>'},
         	{startColumnName: 'sale_over_month', numberOfColumns: 3, titleText: '<em>지연현황</em>'}
      	]
   	});

   
	jq("#list3").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['공급사명', '주문구매사명','주문유형','주문번호','발주차수','납품차수','상품명','상품규격','good_st_spec_desc','주문수량','수량','단가','금액','부가세','합계',
		          '매입확정상태', 'vendorId', 'good_iden_numb', 'buyi_sequ_numb'],
		colModel:[
   			{name:'vendorNm',index:'vendorNm',width:150,align:"left",search:false,sortable:true, editable:false },
   			{name:'branchNm',index:'branchNm',width:200,align:"left",search:false,sortable:true, editable:false },
   			{name:'orde_type_clas_nm', index:'orde_type_clas_nm',width:60,align:"center",search:false,sortable:true, editable:false },
            {name:'order_num',index:'order_num',width:100,align:"left",search:false,sortable:true, editable:false },
            {name:'purc_iden_numb',index:'purc_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},
            {name:'deli_iden_numb',index:'deli_iden_numb',width:50,align:"center",search:false,sortable:true, editable:false},            
            {name:'good_name',index:'good_name',width:150,align:"left",search:false,sortable:true, editable:false },
            
            {name:'good_spec_desc',index:'good_spec_desc', width:140,align:"left",search:false,sortable:true, editable:false },//상품규격
            {name:'good_st_spec_desc',index:'good_st_spec_desc',hidden:true },//표준규격
            
            {name:'orde_requ_quan',index:'orde_requ_quan',width:50,align:"right",search:false,sortable:true, editable:false,
             sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'sale_prod_quan',index:'sale_prod_quan',width:50,align:"right",search:false,sortable:true, editable:false,
             sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'sale_prod_pris',index:'sale_prod_pris',width:60,align:"right",search:false,sortable:true, editable:false,
             sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	
            {name:'sale_prod_amou',index:'sale_prod_amou',width:80,align:"right",search:false,sortable:true, editable:false,
             sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},

			{name:'sale_prod_tax',index:'sale_prod_tax',width:60,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//부가세
			{name:'sale_tota_amou',index:'sale_tota_amou',width:80,align:"right",search:false,sortable:true, editable:false,
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},	//합계

            {name:'buyi_stat_yn',index:'buyi_stat_yn',width:100,align:"center",search:false,sortable:true, editable:false, hidden:true}, 
            {name:'vendorId',index:'vendorId',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
            {name:'good_iden_numb',index:'good_iden_numb',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true },
            {name:'buyi_sequ_numb',index:'buyi_sequ_numb',width:150,align:"left",search:false,sortable:true, editable:false, hidden:true }
		],
      	postData: {srcOrdeNumb:$("#srcOrdeNumb").val()},
      	rowNum:0, rownumbers: true, 
      	height: <%=list3Height%>, width: <%=listWidth%>,
      	sortname: 'ORDE_REGI_DATE', sortorder: "DESC",
      	caption:"상품상세목록", 
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {
      		
            //------ 품목 표준 규격 설정 start
            var prodStSpcNm = new Array();
<% 	for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
			prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
<% 	}	%>
			var prodSpcNm = new Array();
<% 	for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
			prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
<%	}	%>
			//------ 품목 표준 규격 설정 end
      		
        	var rowCnt = $("#list3").getGridParam('reccount');
       	 	for(var i=0;i<rowCnt;i++) {
       			var rowid = $("#list3").getDataIDs()[i];
       			var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
       			
//          		jq("#list3").setCell(rowid,'order_num','',{color:'#0000ff'});
//        		 	jq("#list3").setCell(rowid,'order_num','',{cursor:'pointer'});  
//        		 	jq("#list3").setCell(rowid,'good_name','',{color:'#0000ff'});
//        			jq("#list3").setCell(rowid,'good_name','',{cursor:'pointer'});
       			
       			//------ 품목 표준 규격 설정 start
				// 규격 화면 로드
				var argStArray = selrowContent.good_st_spec_desc.split("‡");
				var argArray = selrowContent.good_spec_desc.split("‡");
				var prodStSpec = "";
				var prodSpec = "";
				for(var stIdx = 0 ; stIdx < prodSpcNm.length ; stIdx ++ ) {
				    if(argStArray[stIdx] > ' ') {
				        prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
				    }
				}
				if(prodStSpec.length > 0) {
				    prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
				    prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
				}
				for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
				    if($.trim(argArray[jIdx]) > ' ') {
				         if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
				         else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
				    }
				}
				prodStSpec += prodSpec;
				jq('#list3').jqGrid('setRowData',rowid,{good_spec_desc:prodStSpec});
    			//------ 품목 표준 규격 설정 end
       	 	}
      	},
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){
    	     var cm = $("#list3").jqGrid("getGridParam", "colModel");
    	     var colName = cm[iCol];
    	     var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
//     	     if(colName['index'] == "order_num"){
<%--     	    	 <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, '" +_menuId+ "', selrowContent.purc_iden_numb);")%> --%>
//     	     }         
//     	     if(colName['index'] == "good_name"){
<%--                  <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView('"+_menuId+"',selrowContent.good_iden_numb, selrowContent.vendorId);")%> --%>
//     	     }    	     
      	},
      	loadError : function(xhr, st, str){ $("#list3").html(xhr.responseText); },
//       	jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
      	jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
});

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");

	data.srcPayStat      	= $("#srcPayStat").val();
	data.srcTranStat     	= $("#srcTranStat").val();
	data.srcClosStartYear   = $("#srcClosStartYear").val(); 
	data.srcClosStartMonth  = $("#srcClosStartMonth").val();
	data.srcClosEndYear     = $("#srcClosEndYear").val();
	data.srcClosEndMonth    = $("#srcClosEndMonth").val();
	data.clientId        	= '<%=userInfoDto.getClientId()%>'; 
	data.srcBranchId        = $("#srcBranchId").val(); 
	jq("#list").trigger("reloadGrid");     	
}

function fnProdDetail(sale_sequ_numb, isOnLoad){
	if(isOnLoad){
   		$("#list3").jqGrid('setGridParam', {url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustSalesConfirmDetailListJQGrid.sys'});
   		var data = jq("#list3").jqGrid("getGridParam", "postData");
   		data.sale_sequ_numb = sale_sequ_numb;
   		jq("#list3").jqGrid("setGridParam", { "postData": data });
   		jq("#list3").trigger("reloadGrid");	
	}	
}

function exportExcel() {
	var colLabels = ['사업장명','계산서일자','총채무','입금일자','수금현황 금액','잔액','구분','만기일','지연현황 경과월','지연현황 초과일수'];   //출력컬럼명
   	var colIds = ['branchNm','clos_sale_date','sale_tota_amou','alram_date','rece_pay_amou','none_coll_amou','tran_status_nm','expiration_date','sale_over_month','sale_over_day'];  //출력컬럼ID
   	var numColIds = ['sale_tota_amou','rece_pay_amou','none_coll_amou']; //숫자표현ID
   	var sheetTitle = "발생채무별현황";   //sheet 타이틀
   	var excelFileName = "BondsOccurrenceList";   //file명
   	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcel3() {
	var colLabels = ['공급사명','주문구매사명','주문유형','주문번호','발주차수','납품차수','상품명','상품규격','주문수량','수량','단가','금액','부가세','합계'];	//출력컬럼명
	var colIds = ['vendorNm','branchNm','orde_type_clas_nm','order_num','purc_iden_numb', 'deli_iden_numb','good_name','good_spec_desc','orde_requ_quan','sale_prod_quan','sale_prod_pris','sale_prod_amou','sale_prod_tax','sale_tota_amou'];	//출력컬럼ID
	var numColIds = ['orde_requ_quan','sale_prod_quan','sale_prod_pris','sale_prod_amou','sale_prod_tax','sale_tota_amou'];	//숫자표현ID
	var sheetTitle = "상품상세목록";	//sheet 타이틀
	var excelFileName = "SalesConfirmDetail";	//file명
	
	fnExportExcel(jq("#list3"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
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

function fnAddBonds() {
	var obj = $("#sel_sale_sequ_numb").val();
	if( obj != "" ){
    var popurl = "/adjust/adjustSalesBondsDetailPop.sys?sale_sequ_numb=" + obj + "&_menuId=<%=_menuId%>";
    	var popproperty = "dialogWidth:580px;dialogHeight=470px;scroll=yes;status=no;resizable=no;";
     	//window.showModalDialog(popurl,self,popproperty);
     	window.open(popurl, '', 'width=580, height=440, scrollbars=yes, status=no, resizable=no');
 	} else { jq( "#dialogSelectRow" ).dialog(); }   
}

</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
	//사용자관리
	header = "구매사 세금계산서 확인";
	manualPath = "/img/manual/branch/adjustBranchsBondsOccurrence.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
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
                     <td height="29" class="ptitle">발생채무별현황
                        &nbsp;<span id="question" class="questionButton">도움말</span>
                     </td>
                     <td align="right" class="ptitle">&nbsp;</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
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
                        <a href="#">
                           <img id="srcButton" name="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width: 65px; height: 22px;border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />
                        </a>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="8" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td colspan="8" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">마감일</td>
                     <td class="table_td_contents">
                          <select id="srcClosStartYear" name="srcClosStartYear" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                           <option value='<%=srcYearArr[i]%>' <%="2010".equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                        </select> 년
                        
                        <select id="srcClosStartMonth" name="srcClosStartMonth" class="select" style="width: 40px;">
<%
   for(int i = 0 ; i < 12 ; i++){
%>
                           <option value='<%=i+1%>' <%="1".equals(i+1 + "") ? "selected" : "" %>><%=i+1 %></option>
<%      
   }
%>                        
                        </select> 월 ~                          
                        
                        <select id="srcClosEndYear" name="srcClosEndYear" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
                           <option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
                        </select> 년
                        
                        <select id="srcClosEndMonth" name="srcClosEndMonth" class="select" style="width: 40px;">
<%
   for(int i = 0 ; i < 12 ; i++){
%>
                           <option value='<%=i+1%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=i+1 %></option>
<%      
   }
%>                        
                        </select> 월            
                     </td>
                     
					<td class="table_td_subject" width="100">관리사업장</td>
					<td class="table_td_contents">
                    	<select id="srcBranchId" name="srcBranchId" class="select">
                        	<option value="">전체</option>
<%
	@SuppressWarnings("unchecked")	
	List<HashMap<String, Object>> branchList = (List<HashMap<String, Object>>)request.getAttribute("branchList");
	if(branchList != null && branchList.size() > 0){
		for(HashMap<String, Object> listMap : branchList){
			System.out.println(listMap.get("BORGNM") + " : " + listMap.get("BRANCHID"));
%>
                        	<option value="<%=listMap.get("BRANCHID")%>"><%=listMap.get("BORGNM") %></option>
<%			
			
		}
	}
%>                        	

                        </select>
                   	</td>					
					
                     
                     <td class="table_td_subject" width="100">잔액여부</td>
                     <td class="table_td_contents">
                        <select id="srcPayStat" name="srcPayStat" class="select">
                           <option value="">전체</option>
                           <option value="10" selected="selected">있음</option>
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
                     <td colspan="8" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td colspan="8" class="table_top_line"></td>
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
               <!-- 그리드 분할-->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td align="right" valign="bottom">
                        <a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> 
                        <a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
                     </td>
                  </tr>
                  <tr>
                     <td valign="top">
                        <div id="jqgrid">
                           <table id="list"></table>
                        </div>
                     </td>
                     <td></td>
                  </tr>
               </table>
               <!-- 그리드 분할-->
            </td>
         </tr>
         <tr>
            <td>&nbsp;</td>
         </tr>
         <tr>
            <td align="right" valign="bottom">
               <a href="#"><img id="colButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> 
               <a href="#"><img id="excelButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
            </td>
         </tr>
         <tr>
            <td>
               <div id="jqgrid">
                  <table id="list3"></table>
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
      <div id="dialog" title="Feature not supported" style="display:none;">
         <p>That feature is not supported.</p>
      </div>            
      <!-------------------------------- Dialog Div End -------------------------------->
   </form>
</body>
</html>