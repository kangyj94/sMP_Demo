<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>
<%
	//그리드의 width와 Height을 정의        
	String listHeight = "$(window).height()-180 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<CodesDto> codeList = (List<CodesDto>)request.getAttribute("codeList");
    LoginUserDto lud = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    //메뉴Id
  	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcUserNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcBorgName").keydown(function(e){ 
		if(e.keyCode==13) { $("#btnBuyBorg").click(); } 
	});
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$('#btnSearchProductForCenter').click( function(){ fnOpenProdSearchPopForAdmin(); });
	
	$("#excelButton").click(function(){ exportExcel(); });
	$("#orderRequestButton").click(function(){ 
		fnOrderRequest(); 
	});
	
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var lastsel;
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderGoodsListJQGrid.sys', 
		editurl: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",
		datatype: 'json',
		mtype: 'POST',
		colNames:['상품명', '규격','최소구매수량' ,'단가', '수량', '주문금액', '표준납기일', '납품요청일', '상품삭제', 'good_Iden_Numb', 'vendorId','tempKey'],
		colModel:[
			{name:'good_name',index:'good_name', width:180,align:"left",search:false,sortable:true, editable:false },//상품명
			{name:'good_spec_desc',index:'good_spec_desc', width:180,align:"left",search:false,sortable:true, editable:false },//규격
			{name:'min_orde_requ_quan',index:'min_orde_requ_quan', hidden:true, search:false,editable:false,formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },				
			},//최소 주문수량 
			{name:'sell_price',index:'sell_price', width:70,align:"right",search:false,sortable:true, editable:false ,formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//단가
			{name:'orde_requ_quan',index:'orde_requ_quan', width:60,align:"right",search:false,sortable:true, editable:true,formatter: 'integer',readonly:true,
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },				
				editoptions:{
					maxlength:7,
					dataInit:function(elem){
						$(elem).numeric();
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "right");
					},	
					dataEvents:[{
						type:'change',
						fn:function(e){
							var rowid = (this.id).split("_")[0];
							var selrowContent = jq("#list").jqGrid('getRowData',rowid);
							var inputValue = Number(this.value); 											// 입력수량
							var chkMinOrderCnt = Number(selrowContent.min_orde_requ_quan); 	// 최소 구매 수량
							var sell_price = selrowContent.sell_price;										// 단가
							if(inputValue<chkMinOrderCnt) {
								alert("최소주문수량 이하는 신청할 수 없습니다.\n해당 상품의 최소수량은 "+chkMinOrderCnt+" 입니다.");
								var tempTotalSellPrice  = chkMinOrderCnt * sell_price;
								jq("#list").restoreRow(rowid);
								jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:chkMinOrderCnt});
								jq("#list").jqGrid('setRowData', rowid, {total_sell_price:tempTotalSellPrice});
								fnCalcTotalSell();
								jq('#list').editRow(rowid);
								return;
							}
							var tempTotalSellPrice  = inputValue * sell_price;
							jq("#list").restoreRow(rowid);
							jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:inputValue});
							jq("#list").jqGrid('setRowData', rowid, {total_sell_price:tempTotalSellPrice});
							fnCalcTotalSell();
							jq('#list').editRow(rowid);
						}
					}]
				}
			},//수량
			{name:'total_sell_price',index:'total_sell_price', width:90,align:"right",search:false,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//주문금액
			{name:'deli_mini_day',index:'deli_mini_day', width:70,align:"center",search:false,sorttype:"date", editable:false,formatter:"date" },//표준납기일
			{name:'requ_deli_date',index:'requ_deli_date',width:100,align:"center",search:false,sortable:false,
				 formatter: 'text',
				 editable:true,edittype: 'text',
				 editoptions: {
					 size: 11,maxlengh: 10,dataInit: function (element) {
					 $(element).datepicker({ dateFormat: 'yy-mm-dd' });
				},
				dataEvents:[{
					type:'change',
					fn:function(e){
						var inputValue = this.value; 											// 입력 날짜
						var rowid = (this.id).split("_")[0];
						jq("#list").restoreRow(rowid);
						jq("#list").jqGrid('setRowData', rowid, {requ_deli_date:inputValue});
						jq('#list').editRow(rowid);
					}
				}]
				},
		        editrules: {date: false}
			},//납품요청일
			{name:'상품삭제',index:'상품삭제', width:70,align:"center",search:false,sortable:false, editable:false,formatter:delButton },//상품 삭제
			{name:'good_iden_numb',index:'good_iden_numb',hidden:true},//상품코드
			{name:'vendorid',index:'vendorid',hidden:true},//공급사코드
			{name:'tempKey',index:'tempKey',hidden:true, key:true}//키값
		],  
		postData: {isSearch:"true"},
		rowNum:0, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		caption:"주문요청 상품리스트", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { }, 
		onCellSelect: function(rowid, iCol, cellcontent, target){ },
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell", userdata:"userdata" },
		footerrow: true,
	    userDataOnFooter: true
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
// 삭제버튼 초기화 
function delButton(cellValue, options, rowObject){
	var str = "<input type='button' value='상품삭제' onclick='javascript:fnDelOrderProduct("+rowObject.tempKey+");'>";
	return str;
}

// 삭제
function fnDelOrderProduct(tempKey){
	if(confirm("해당 상품을 주문요청 리스트에서 삭제하시겠습니까?")){
    	jq("#list").delRowData(tempKey);
    	fnCalcTotalSell();
	}
}

// 3자리수마다 콤마
function fnComma(n) {
	 n += '';
	 var reg = /(^[+-]?\d+)(\d{3})/;
	 while (reg.test(n)){
		 n = n.replace(reg, '$1' + ',' + '$2');
	 }
	 return n;
}

// 수량 변화시 합계 계산
function fnCalcTotalSell(){
	var temp_total_sell_price = 0;
	var temp_total_quan = 0;
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt > 0){
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			jq("#list").restoreRow(rowid);
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(selrowContent.orde_requ_quan == 0){
    			var sell_price = selrowContent.sell_price;										
    			var tempTotalSellPrice_unit  = Number(selrowContent.min_orde_requ_quan) * sell_price;
				jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:selrowContent.min_orde_requ_quan});
				jq("#list").jqGrid('setRowData', rowid, {total_sell_price:tempTotalSellPrice_unit});
    			temp_total_sell_price += Number(tempTotalSellPrice_unit);
    			temp_total_quan += Number(selrowContent.min_orde_requ_quan);
			}
			temp_total_sell_price += Number(selrowContent.total_sell_price);
			temp_total_quan += Number(selrowContent.orde_requ_quan);
			jq('#list').editRow(rowid);  
		}
	}
	var userData = jq("#list").jqGrid("getGridParam","userData");
	userData.total_sell_price = fnComma(temp_total_sell_price);
	userData.orde_requ_quan = fnComma(temp_total_quan);
	userData.sell_price = '';
	jq("#list").jqGrid("footerData","set",userData,false);
}
  
//  list Excel Export
function exportExcel() {
	var colLabels = ['공급사','주문상품유형','상품명','규격','단가','수량','주문금액','표준납기일'];	//출력컬럼명
	var colIds = ['vendor_name','good_clas_code','good_name','good_spec_desc','sell_price','orde_requ_quan','total_sell_price','deli_mini_day'];	//출력컬럼ID
	var numColIds = ['total_sell_price'];	//숫자표현ID
	var sheetTitle = "주문요청 상품리스트";	//sheet 타이틀
	var excelFileName = "OrderRequestList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

// 주문 신청 버튼 클릭시
function fnOrderRequest(){
	var groupid= $("#groupid").val();
	var clientid= $("#clientid").val();
	var branchid= $("#branchid").val();
	var tran_data_addr= $("#tran_data_addr").val();
	var cons_iden_name = $("#cons_iden_name").val();
	var orde_type_clas = $("#orde_type_clas").val();
	var orde_tele_numb =	$("#orde_tele_numb").val();
	var orde_user_id =	$("#orde_user_id").val();
	var tran_user_name =$("#tran_user_name").val();
	var tran_tele_numb =	$("#tran_tele_numb").val();
	var adde_text_desc =	$("#adde_text_desc").val();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var orde_requ_quan_array = new Array();
		var requ_deli_date_array = new Array();
		var good_iden_numb_array= new Array();
		var vendorid_array= new Array();
		
		if(!confirm("해당 상품을 주문요청 하시겠습니까?")){ return; }
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			jq('#list').saveRow(rowid);
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			orde_requ_quan_array[i] = selrowContent.orde_requ_quan;
			requ_deli_date_array[i] = selrowContent.requ_deli_date;
			good_iden_numb_array[i] = selrowContent.good_iden_numb;
			vendorid_array[i] = selrowContent.vendorid;
		}  
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/cenOrderRequestAddTransGrid.sys", 
			{   groupid:groupid,clientid:clientid,branchid:branchid,cons_iden_name:cons_iden_name, orde_type_clas:orde_type_clas,
				orde_tele_numb:orde_tele_numb, orde_user_id:orde_user_id, tran_data_addr:tran_data_addr,
				tran_user_name:tran_user_name, tran_tele_numb:tran_tele_numb, adde_text_desc:adde_text_desc,
				orde_requ_quan_array:orde_requ_quan_array,
				good_iden_numb_array:good_iden_numb_array,
				vendorid_array:vendorid_array,
				requ_deli_date_array:requ_deli_date_array
			},
			function(arg){ 
				if(fnAjaxTransResult(arg)) {	//성공시
					alert("주문요청이 성공적으로 완료되었습니다.");
					window.location.reload();
				}
			}
		);
	} else{ jq( "#dialogSelectRow" ).dialog();};
}

</script>
<%
/**------------------------------------운영사 상품검색 팝업 --------------------------------- 789 
* fnOpenProdSearchPopForAdmin()을 호출하여 Div팝업을 Display ===
*/
%>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
	/**
	 * 
	 */
	function fnOpenProdSearchPopForAdmin() {
	    var popurl = "/product/productSearchForCenter.sys?_menuId="+<%=menuId%>;
	    var popproperty = "dialogWidth:950px;dialogHeight=570px;scroll=no;status=no;resizable=no;";
	    var vReturn = window.showModalDialog(popurl,self,popproperty);
// 		window.open(popurl, 'okplazaPop', 'width=950, height=570, scrollbars=yes, status=no, resizable=no');
	    
       if(vReturn == undefined || vReturn.isSuccess != "success" ){return;}
        for(var arrIdx = 0 ; arrIdx < vReturn['objs'].length ; arrIdx++){
            jq("#list").addRowData(arrIdx,{
                 good_name: vReturn['objs'][arrIdx].good_name
                , good_spec_desc: vReturn['objs'][arrIdx].good_spec_desc
                , sell_price: vReturn['objs'][arrIdx].sale_unit_pric
                , deli_mini_day: vReturn['objs'][arrIdx].requ_deli_date
                , requ_deli_date: vReturn['objs'][arrIdx].requ_deli_date
                , min_orde_requ_quan: vReturn['objs'][arrIdx].deli_mini_quan
                , vendorid: vReturn['objs'][arrIdx].vendorid
                , good_iden_numb: vReturn['objs'][arrIdx].good_iden_numb
                , tempKey:arrIdx
            }); 
        }
        fnCalcTotalSell();
	}
	
	// Call Back
	function fnProdSearchCallBack(good_Iden_Numb , good_Name , full_Cate_Name) {
		var msg = ""; 
		msg += "\n good_Iden_Numb value ["+good_Iden_Numb +"]"; 
		msg += "\n good_Name value ["+good_Name+"]";
		
		msg += "\n full_Cate_Name value ["+full_Cate_Name +"]";
		//alert(msg);
		$('#good_iden_numb').html(good_Iden_Numb);
		$('#good_Name').val(good_Name);
	}
</script>
</head>
<body>
   <form id="frm" name="frm" method="post">
   <input type="hidden" id="groupid" name="groupid" value="<%=lud.getGroupId()%>"/>
   <input type="hidden" id="clientid" name="clientid" value="<%=lud.getClientId()%>"/>
   <input type="hidden" id="branchid" name="branchid" value="<%=lud.getBorgId()%>"/>
   <input type="hidden" id="cons_iden_name" name="cons_iden_name" value="물류센터 수탁발주"/>
   <input type="hidden" id="orde_type_clas" name="orde_type_clas" value="90"/>
   <input type="hidden" id="orde_tele_numb" name="orde_tele_numb" value="<%=lud.getTel()%>"/>
   <input type="hidden" id="orde_user_id" name="orde_user_id" value="<%=lud.getUserId()%>"/>
   <input type="hidden" id="tran_data_addr" name="tran_data_addr" value="34"/>
   <input type="hidden" id="tran_user_name" name="tran_user_name" value="<%=lud.getUserNm()%>"/>
   <input type="hidden" id="tran_tele_numb" name="tran_tele_numb" value="<%=lud.getTel()%>"/>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>주문요청</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27">
                  <tr>
                     <td align="right" class="stitle">
                        <a href="#">   <img id="btnSearchProductForCenter" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_goodsSearch.gif" width="75" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a>
                        <a href="#"><img id="orderRequestButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_order.gif" width="75" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
                        <a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
                        <a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
                        </a>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td >
               <div id="jqgrid">
                  <table id="list"></table>
               </div>
            </td>
         </tr>
      </table>
   </form>
</body>
</html>