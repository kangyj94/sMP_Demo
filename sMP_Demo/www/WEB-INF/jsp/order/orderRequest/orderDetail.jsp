<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.order.dto.OrderDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%  
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String req_purc_iden_numb = request.getParameter("purc_iden_numb");
    
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-800 + Number(gridHeightResizePlus)";
	String list2Height = "$(window).height()-800 + Number(gridHeightResizePlus)";
	String list3Height = "$(window).height()-800 + Number(gridHeightResizePlus)";
	String list4Height = "$(window).height()-800 + Number(gridHeightResizePlus)";
  
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   
	OrderDto orderDetailInfo = (OrderDto)request.getAttribute("orderDetailInfo");
	boolean is_purc = (Boolean)request.getAttribute("is_purc"); // 발주정보가 있는지 여부
	boolean is_deli = (Boolean)request.getAttribute("is_deli");   // 출하 및 인수 정보가 있는지 여부
   
	// 주문 요청 수량과 발주수량 비교 : 물량배분이 필요한 상태일 경우 해당 그리드 출력 필요
	int temp_orde_requ_quan = Integer.parseInt(orderDetailInfo.getOrde_requ_quan());
	int temp_purc_requ_quan = Integer.parseInt(orderDetailInfo.getPurc_requ_quan());
	boolean is_div = false;
	if(temp_orde_requ_quan != temp_purc_requ_quan){  
		is_div = true;
	}
    // 운영사 인지
    boolean is_adm = false;
    boolean isVen = false;
    LoginUserDto lud = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    if("ADM".equals(lud.getSvcTypeCd())){ 
      is_adm = true;
    }
    else if("VEN".equals(lud.getSvcTypeCd())){ 
    	isVen = true;
      }
    int statFlag = Integer.parseInt(orderDetailInfo.getStat_flag().toString());

    
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<base target="_self" />
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;

$(document).ready(function() {
	$('form').on('submit',function(){ return false; });
	
	$("#excelButton1").click(function(){ excelButton1(); });
	$("#excelButton2").click(function(){ excelButton2(); });
	$("#excelButton3").click(function(){ excelButton3(); });
	$("#excelButton4").click(function(){ excelButton4(); });
	$("#cons_iden_name_ch_btn").click(function(e){ 
		$("#cons_iden_name").val($.trim($("#cons_iden_name").val()));
		fnOrderRequMasterUpdate(1); 
	});
	$("#tran_data_addr_ch_btn").click(function(e){ 
		$("#tran_data_addr").val($.trim($("#tran_data_addr").val()));
		fnOrderRequMasterUpdate(2); 
	});
	$("#div_purc").click(function(e){ 
		$("#cons_iden_name").focus();
    	var rowCnt = jq("#list").getGridParam('reccount');
    	if(rowCnt>0) {
    		var chkQuan = 0;
            for(var i=0; i<rowCnt; i++) {
                var rowidTemp = $("#list").getDataIDs()[i];  
                var selrowContentTemp = jq("#list").jqGrid('getRowData',rowidTemp);
           		jq("#list").restoreRow(rowidTemp);
                chkQuan += Number(selrowContentTemp.temp_orde_quan);
//            		jq('#list').editRow(rowidTemp);
            }
            var tempValue = Number(chkQuan);
        	if(tempValue > <%=orderDetailInfo.getOrder_purc()%>){
        		alert("입력하신 물량배분 수량의 총 합은 "+tempValue+"입니다.\n분배가능한 수량의 총 합은 <%=orderDetailInfo.getOrder_purc()%> 입니다. 다시 입력해주시기 바랍니다.");
            	jq("#list").trigger("reloadGrid");
        		return;
        	}
    	}
		fnOrderRequDivPurc(); 
	});
	$("#orderCancel").click(function(e){ 
		popForOrderCancel();
	});
	$("#tranUserNameImg").click(function(e){ 
		$("#tranUserName").val($.trim($("#tranUserName").val()));
		fnOrderRequMasterUpdate(3); 
	});
	$("#tranTeleNumbImg").click(function(e){ 
		$("#tranTeleNumb").val($.trim($("#tranTeleNumb").val()));
		fnOrderRequMasterUpdate(4); 
	});
	
	$("#orderChangeInfoSaveButton").click(function(){ orderChangeInfoSave(); });
	
	//주문변경정보 셀렉트박스
	orderChangeInfoSelect();
	
	//전화번호 형식으로 변경
	$("#tranTeleNumb").val( fnSetTelformat( $("#tranTeleNumb").val() ) );
	$("#ordTelNumb").html( fnSetTelformat( $("#ordTelNumb").html() ) );
	
});

//리사이징
// $(window).bind('resize', function() { 
<%-- 	$("#list").setGridHeight(<%=listHeight %>); --%>
//     $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
// }).trigger('resize');  
// $(window).bind('resize', function() { 
<%-- 	$("#list2").setGridHeight(<%=list2Height %>); --%>
//     $("#list2").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
// }).trigger('resize');  
// $(window).bind('resize', function() { 
<%-- 	$("#list3").setGridHeight(<%=list3Height %>); --%>
//     $("#list3").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
// }).trigger('resize');  
// $(window).bind('resize', function() { 
<%-- 	$("#list4").setGridHeight(<%=list4Height %>); --%>
//     $("#list4").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
// }).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
<%--
is_div : false ------> 물량배분 그리드 출력 X
is_div : true -------> 물량배분 그리드 출력 O
is_purc : false ------> 발주 정보 출력할 필요 없음
is_purc : true -------> 발주 정보 출력 필요
is_deli : false --------> 출하, 인수정보 출력할 필요 없음
is_deli : true --------> 출력할 필요 있음.
--%>
<%	if(is_div && is_adm && !orderDetailInfo.getOrder_status_flag().equals("승인요청")){ %>
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/purchaseForDivOrder.sys', 
        editurl: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",
		datatype: 'json',
		mtype: 'POST',
		colNames:['공급사명', '수량', '판매단가', '판매금액', '매입단가', '매입금액', '발주년금액(%)', '발주월금액(%)', '적용년금액(%)','purc_price_year','vendorid','temp_orde_purc_pric','temp_orde_quan'],
		colModel:[
			{name:'vendorname',index:'vendorname',resizable:false , width:145,align:"left",search:false,sortable:false, editable:false },
			{name:'orde_requ_quan',index:'orde_requ_quan',resizable:false, width:60,align:"right",search:false,sortable:false, editable:true,formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
				,editoptions:{
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
							var orde_requ_pric = selrowContent.orde_requ_pric;							// 판매단가
							var sale_unit_pric = selrowContent.sale_unit_pric;								// 매입단가
							var temp_orde_requ_pric  = inputValue * orde_requ_pric;					// 판매금액
							var temp_sale_unit_pric  = inputValue * sale_unit_pric;						// 매입금액
							var purc_year_price = Number(selrowContent.purc_year_price); 			// 발주년금액
                  			var temp_purc_year_price = temp_sale_unit_pric +purc_year_price;
                   			jq("#list").restoreRow(rowid);
							jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:inputValue});
							jq("#list").jqGrid('setRowData', rowid, {temp_orde_quan:inputValue});
							jq("#list").jqGrid('setRowData', rowid, {total_orde_requ_pric:temp_orde_requ_pric});
							jq("#list").jqGrid('setRowData', rowid, {total_sale_unit_pric:temp_sale_unit_pric});
							jq("#list").jqGrid('setRowData', rowid, {temp_orde_purc_pric:temp_purc_year_price});
// 							jq('#list').editRow(rowid);
							fnCalcChangeYearsPrice();
						}
					}]
				}
            },
			{name:'orde_requ_pric',index:'orde_requ_pric',resizable:false, width:60,align:"right",search:false,sortable:false, editable:false ,formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }		},
			{name:'total_orde_requ_pric',index:'total_orde_requ_pric',resizable:false, width:70,align:"right",search:false,sortable:false, editable:false ,formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }		},
			{name:'sale_unit_pric',index:'sale_unit_pric',resizable:false, width:60,align:"right",search:false,sortable:false, editable:false ,formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }		},
			{name:'total_sale_unit_pric',index:'total_sale_unit_pric',resizable:false, width:70,align:"right",search:false,sortable:false, editable:false ,formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }		},
			{name:'purc_price_year_str',index:'purc_price_year_str',resizable:false, width:120,align:"right",search:false,sortable:false, editable:false },
			{name:'purc_price_month_str',index:'purc_price_month_str',resizable:false, width:120,align:"right",search:false,sortable:false, editable:false },
			{name:'purc_change_price_year',index:'purc_change_price_year',resizable:false, width:120,align:"right",search:false,sortable:false, editable:false },
			{name:'purc_year_price',index:'purc_year_price', hidden:true},
			{name:'vendorid',index:'vendorid', hidden:true},
			{name:'temp_orde_purc_pric',index:'temp_orde_purc_pric', hidden:true},
			{name:'temp_orde_quan',index:'temp_orde_quan', hidden:true}
		],
		postData: {
			orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>",
			good_iden_numb:"<%=orderDetailInfo.getGood_iden_numb()%>"
		},
		height: 100,width: 870 ,
// 		caption:"발주정보[물량배분]", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
<% 		if(!orderDetailInfo.getOrder_status_flag().equals("주문취소")){ %>
			fnListSetRow(jq("#list"));
<%		} %>
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var i = 0; i < rowCnt; i++) {
				var tempRowid = $("#list").getDataIDs()[i];
				jq("#list").jqGrid('setRowData', tempRowid, {orde_requ_quan:0});
			}
			jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:<%=orderDetailInfo.getOrde_requ_quan() %>});
			fnListSetRow(jq("#list"));
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){
			alert("물량배분 리스트에 에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	}); 
});
function fnListSetRow(gridId) {
	var rowCnt = gridId.getGridParam('reccount');
	if(rowCnt>0) {
		for(var i = 0; i < rowCnt; i++) { 
			var rowid = gridId.getDataIDs()[i];
   			var selrowContent = gridId.jqGrid('getRowData',rowid);
			var inputValue = selrowContent.orde_requ_quan;							//수량
			var orde_requ_pric = selrowContent.orde_requ_pric;							// 판매단가
			var sale_unit_pric = selrowContent.sale_unit_pric;								// 매입단가
			var temp_orde_requ_pric  = inputValue * orde_requ_pric;					// 판매금액
			var temp_sale_unit_pric  = inputValue * sale_unit_pric;						// 매입금액
			var purc_year_price = Number(selrowContent.purc_year_price); 			// 발주년금액
			
   			var rowCntTemp = gridId.getGridParam('reccount');
			var sum_purc_year_price = 0;
   			if(rowCntTemp>0) {
   				for(var k=0; k<rowCntTemp; k++) {
   					var rowidTemp = gridId.getDataIDs()[k];
         			var selrowContentTemp = gridId.jqGrid('getRowData',rowidTemp);
         			sum_purc_year_price += Number(selrowContentTemp.purc_year_price);		// 발주년금액
   				}
   			}
   			var temp_purc_year_price = temp_sale_unit_pric +purc_year_price;
   			gridId.restoreRow(rowid);
   			gridId.jqGrid('setRowData', rowid, {orde_requ_quan:inputValue});
   			gridId.jqGrid('setRowData', rowid, {total_orde_requ_pric:temp_orde_requ_pric});
   			gridId.jqGrid('setRowData', rowid, {total_sale_unit_pric:temp_sale_unit_pric});
   			gridId.jqGrid('setRowData', rowid, {temp_orde_purc_pric:temp_purc_year_price});
   			gridId.jqGrid('setRowData', rowid, {temp_orde_quan:inputValue});
//				gridId.editRow(rowid);
			fnCalcChangeYearsPrice();
		}
	}
}


<% 	}
	if(is_purc){  
%>
var staticNum = 0;	//list2, 그리드를 한번만 초기화하기 위해
var is_adm = <%=is_adm%>;
jq(function() {
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/purchase/purchaseForOrderDetail.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['주문번호', '발주차수', '공급사명', '발주수량', '납품수량', 
<%	if(!isVen){	%>
		        '판매단가', '판매금액',
<%	}	%>
<%	if(is_adm || isVen){	%>
				'매입단가', '매입금액',
<%	}	%> 
				'상태','purc_stat_flag'
		],
		colModel:[
			{name:'orde_iden_numb',index:'orde_iden_numb',resizable:false, width:110,align:"center",search:false,sortable:false, editable:false },
			{name:'purc_iden_numb',index:'purc_iden_numb',resizable:false, width:70,align:"center",search:false,sortable:false, editable:false },
			{name:'vendorname',index:'vendorname',resizable:false, width:140,align:"left",search:false,sortable:false, editable:false },
			{name:'purc_requ_quan',index:'purc_requ_quan',resizable:false, width:60,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'deli_prod_quan',index:'deli_prod_quan',resizable:false, width:60,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer',
					formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
<%	if(!isVen){	%>
			{name:'orde_requ_pric',index:'orde_requ_pric',resizable:false, width:70,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'total_orde_requ_pric',index:'total_orde_requ_pric',resizable:false, width:70,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
<%	}	%>
<%	if(is_adm || isVen){	%>
			{name:'sale_unit_pric',index:'sale_unit_pric',resizable:false, width:70,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'total_sale_unit_pric',index:'total_sale_unit_pric',resizable:false, width:70,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
<%	}	%>				
			{name:'purc_stat_flag_name',index:'purc_stat_flag_name',resizable:false, width:100,align:"center",search:false,sortable:false, editable:false},
			{name:'purc_stat_flag',index:'purc_stat_flag', hidden:true}
		],
		postData: {
			orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>"
		},
		height: 70,width:870,
		sortname: 'purc_iden_numb', sortorder: "asc",
// 		caption:"발주정보", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
<%			if(!orderDetailInfo.getOrder_status_flag().equals("주문취소")){ %>
				var rowCnt = jq("#list2").getGridParam('reccount');
				if(rowCnt>0) {
					var firstRowId =$("#list2").getDataIDs()[0]; 
					for(var i=0; i<rowCnt; i++) {
						var rowid = $("#list2").getDataIDs()[i];
						var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
<%					if(is_deli){%>
						if(selrowContent.purc_iden_numb == '<%=req_purc_iden_numb%>'){
							if(staticNum == 0){
								staticNum++;
								fnInitDeliList(selrowContent.orde_iden_numb,selrowContent.purc_iden_numb);
								jq("#list2").setSelection(rowid);
							}
						}
						if(i == rowCnt-1  && staticNum == 0){
							staticNum++;
							var selrowContentFirst = jq("#list2").jqGrid('getRowData',firstRowId);
							fnInitDeliList(selrowContentFirst.orde_iden_numb,selrowContentFirst.purc_iden_numb);
							jq("#list2").setSelection(firstRowId);
						}
<%					} %>
						var purc_stat_flag = selrowContent.purc_stat_flag;
						var purc_requ_quan = selrowContent.purc_requ_quan;
						var deli_prod_quan = selrowContent.deli_prod_quan;
						if(Number(purc_stat_flag) == 40 || Number(purc_stat_flag) == 50) {	//발주정보에서 중지나 취소가 아닐 경우
							if(Number(deli_prod_quan)==0) {
								var selbox = "<select id='orderSelect_"+rowid+"' onchange='javascript:popForOrderStatFlag("+rowid+",this.value,"+purc_stat_flag+")'<%if(!CommonUtils.isRoleExist(roleList, "COMM_SAVE")){out.print(" disabled");}%>>";
								if(<%=is_div%>){ selbox += "<option value ='10'>주문요청</option>"; }
								if(purc_stat_flag == 40) {	//발주 의뢰 상태일 경우
									selbox += "<option value ='40' selected>주문의뢰</option>";
									selbox += "<option value ='91'>주문의뢰중지</option>";
								} else if(purc_stat_flag == 50) {	//발주접수상태일 경우
									selbox += "<option value ='40'>주문의뢰</option>";
									selbox += "<option value ='50' selected>주문접수</option>";
									selbox += "<option value ='92'>주문접수중지</option>";
								}
								selbox += "</select>";
								jq('#list2').jqGrid('setRowData',rowid,{purc_stat_flag_name:selbox});
							} else if(Number(purc_requ_quan) == Number(deli_prod_quan)) {	//납품하고 납품할 수량이 남았을 경우
								jq('#list2').jqGrid('setRowData',rowid,{purc_stat_flag_name:""});
							} else {
								jq('#list2').jqGrid('setRowData',rowid,{purc_stat_flag_name:"주문접수"});
							}
						}
					}
				}
<%			}// 주문취소 관련 if문%>
			
			//발주의뢰 보다 상태값이 클 경우 구매사 셀렉트 박스 disabled
			<% if("BUY".equals(lud.getSvcTypeCd())){%>
				var rowCnt = jq("#list2").getGridParam('reccount');
				for(var i=0; i<rowCnt; i++){
					var rowid = $("#list2").getDataIDs()[i];
					var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
					if(Number(selrowContent.purc_stat_flag) >= 50){
						$("#orderSelect_"+rowid).attr("disabled", true);
					}
				}
			<%}%>
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
<%		if(is_deli){%>
			var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
			var srcOrdeIdenNumb = selrowContent.orde_iden_numb;
			var srcPurcIdenNumb = selrowContent.purc_iden_numb;
			fnOnClickPurcList(srcOrdeIdenNumb,srcPurcIdenNumb);
<%		}%>
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){
			alert("주문정보 리스트에 에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
});
<% 	}
	if(is_deli){
%>
function fnInitDeliList(srcOrdeIdenNumb, srcPurcIdenNumb) {
	jq("#list3").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/deliveryListForOrderDetail.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['납품차수','인수차수', '납품수량','인수수량' ,'납품일시', '인수자', '인수일시', '주문상태', '배송완료여부', '운송수단', '송장번호', 'isdelivery', 'orde_iden_numb' , 'purc_iden_numb', 'deli_stat_flag', 'deli_type_clas_code'],
		colModel:[
			{name:'deli_iden_numb',index:'deli_iden_numb',resizable:false, width:50,align:"center",search:false,sortable:false, editable:false },
			{name:'rece_iden_numb',index:'rece_iden_numb',resizable:false, width:50,align:"center",search:false,sortable:false, editable:false },
			{name:'deli_prod_quan',index:'deli_prod_quan',resizable:false, width:70,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'rece_prod_quan',index:'rece_prod_quan',resizable:false, width:70,align:"right",search:false,sortable:false, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
			{name:'deli_degr_date',index:'deli_degr_date',resizable:false, width:70,align:"center",search:false,sortable:false, editable:false },
			{name:'rece_proc_id',index:'rece_proc_id',resizable:false, width:70,align:"left",search:false,sortable:false, editable:false },
			{name:'purc_proc_date',index:'purc_proc_date',resizable:false, width:70,align:"center",search:false,sortable:false, editable:false },
			{name:'deli_stat_flag_name',index:'deli_stat_flag_name',resizable:false, width:110,align:"center",search:false,sortable:false, editable:false },
			{name:'isdelivery_name',index:'isdelivery_name',resizable:false, width:80,align:"center",search:false,sortable:false, editable:false },
			{name:'deli_type_clas',index:'deli_type_clas',resizable:false, width:90,align:"center",search:false,sortable:false, editable:false },
			{name:'deli_invo_iden',index:'deli_invo_iden',resizable:false, width:85,align:"center",search:false,sortable:false, editable:false },
			{name:'isdelivery',index:'isdelivery', hidden:true},
			{name:'orde_iden_numb',index:'orde_iden_numb', hidden:true},
			{name:'purc_iden_numb',index:'purc_iden_numb', hidden:true},
			{name:'deli_stat_flag',index:'deli_stat_flag', hidden:true},
			{name:'deli_type_clas_code',index:'deli_type_clas_code', hidden:true}
		],
		postData: { srcOrdeIdenNumb:srcOrdeIdenNumb, srcPurcIdenNumb:srcPurcIdenNumb },
		height:70, width:870, 
		caption:"납품정보", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { 
<%			if(!orderDetailInfo.getOrder_status_flag().equals("주문취소") && is_adm){ %>
				var rowCnt = jq("#list3").getGridParam('reccount');
				if(rowCnt>0) {
					for(var i=0; i<rowCnt; i++) {
						var rowid = $("#list3").getDataIDs()[i];
						var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
						var isdelivery = selrowContent.isdelivery;
						var deli_stat_flag = selrowContent.deli_stat_flag;
						if(deli_stat_flag == "60"){ 
							selbox = "<select id='deliSelect_"+rowid+"' onchange='javascript:popForDeliStatFlag("+rowid+",this.value,"+deli_stat_flag+")'>";
							selbox += "<option value ='60' selected>배송중</option>";
							selbox += "<option value ='93'>배송취소</option>";
							selbox += "</select>";
							jq('#list3').jqGrid('setRowData',rowid,{deli_stat_flag_name:selbox});
						}
					}
				}
<%			}%>
		},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		afterInsertRow: function(rowid, aData){
			var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
			if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){            	
				jq("#list3").setCell(rowid,'deli_invo_iden','',{color:'#0000ff'});
				jq("#list3").setCell(rowid,'deli_invo_iden','',{cursor: 'pointer'});  
			}
			if(<%=orderDetailInfo.getOrde_type_clas()%> == '30'){
				jq("#list3").setCell(rowid,'deli_degr_date','',{color:'#0000ff'});
				jq("#list3").setCell(rowid,'deli_degr_date','',{cursor: 'pointer'});  
			}
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list3").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="deli_invo_iden") { 
				if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){					
					fnSearchDeliPopup(selrowContent.deli_type_clas_code, selrowContent.deli_invo_iden);
				}
			}
			if(colName != undefined &&colName['index']=="deli_degr_date") { 
				if(<%=orderDetailInfo.getOrde_type_clas()%>== '30'){
					fnShowDeliHist(selrowContent.orde_iden_numb, selrowContent.purc_iden_numb, selrowContent.deli_iden_numb);
				}
			}
		},
		loadError : function(xhr, st, str){
			alert("납품정보 리스트에 에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	});
}
<% 	} %>
jq(function() {
	jq("#list4").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderHistList.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['변경일시', '변경내용', '변경자', '변경사유'],
		colModel:[
			{name:'regi_user_date',index:'regi_user_date',resizable:false, width:130,align:"center",search:false,sortable:false, editable:false },
			{name:'chan_cont_desc',index:'chan_cont_desc',resizable:false, width:250,align:"center",search:false,sortable:false, editable:false },
			{name:'regi_user_id',index:'regi_user_id',resizable:false, width:90,align:"center",search:false,sortable:false, editable:false },
			{name:'chan_reas_desc',index:'chan_reas_desc',resizable:false, width:340,align:"left",search:false,sortable:false, editable:false }
		],
		postData: {
			orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>"
		},
		height: 200,width:870,
		//caption:"주문변경정보", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		sortname: 'regi_user_date', sortorder: "desc",
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){
			alert("주문변경정보 리스트에 에러가 발생하였습니다.");
		},
		jsonReader : {root: "list4",repeatitems: false,cell: "cell"}
	}); 
});  
</script>

<!-- 그리드 이벤트 스크립트 -->   
<script type="text/javascript">
// 3자리수마다 콤마
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

function fnOrderRequDivPurc(){
	var rowId = $("#list").jqGrid('getGridParam','selrow');
	if(rowId==null) { alert("주문의뢰 할 공급사를 선택하지 않았습니다."); return false; }
	var selrowContent = $("#list").jqGrid('getRowData',rowId);
	if(!confirm("["+selrowContent.vendorname+"] 업체로 주문 하시겠습니까?"))  return false;
	var temp_vendor_id = new Array();
	var temp_order_unit_price = new Array();
	var temp_sale_unit_price = new Array();
	var temp_purc_quan = new Array();
	temp_vendor_id[0] = selrowContent.vendorid;
	temp_order_unit_price[0] = selrowContent.orde_requ_quan;
	temp_sale_unit_price[0] = selrowContent.orde_requ_pric;
	temp_purc_quan[0] = selrowContent.sale_unit_pric;
	$.post(
		"/order/purchase/orderDivPurcAddTransGrid.sys", {
			orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>",
			good_iden_numb:"<%=orderDetailInfo.getGood_iden_numb() %>", 
			vendorid_array:temp_vendor_id, 
			orde_requ_quan_array:temp_order_unit_price, 
			orde_requ_pric_array:temp_sale_unit_price, 
			sale_unit_pric_array:temp_purc_quan
		},
		function(arg){
			if(fnAjaxTransResult(arg)) {	//성공시
				refreshThisPage();
			}else{
				fnAjaxTransResult(arg);
				refreshThisPage();
			}
		}
	);
	/*
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		if(confirm("지정한 수량으로 물량배분을 한 상품을 발주하시겠습니까?")){
			var temp_vendor_id = new Array();
			var temp_order_unit_price = new Array();
			var temp_sale_unit_price = new Array();
			var temp_purc_quan = new Array();
			var div_orde_cnt = 0;
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(Number(selrowContent.orde_requ_quan) >= 1){
					temp_vendor_id[div_orde_cnt] = selrowContent.vendorid;
					temp_order_unit_price[div_orde_cnt] = selrowContent.orde_requ_quan;
					temp_sale_unit_price[div_orde_cnt] = selrowContent.orde_requ_pric;
					temp_purc_quan[div_orde_cnt] = selrowContent.sale_unit_pric;
					div_orde_cnt++;
				}
			}
			if(div_orde_cnt == 0){
				alert("발주의뢰 수량을 확인하여 주시기 바랍니다.");
				return;
			}
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/purchase/orderDivPurcAddTransGrid.sys", 
				{
					orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>",
					good_iden_numb:"<%=orderDetailInfo.getGood_iden_numb() %>", 
					vendorid_array:temp_vendor_id, 
					orde_requ_quan_array:temp_order_unit_price, 
					orde_requ_pric_array:temp_sale_unit_price, 
					sale_unit_pric_array:temp_purc_quan
				},
				function(arg){
					if(fnAjaxTransResult(arg)) {	//성공시
						refreshThisPage();
					}else{
						fnAjaxTransResult(arg);
						refreshThisPage();
					}
				}
			);
      	}
   	} else{ jq( "#dialogSelectRow" ).dialog();};
   	*/
}

function fnOrderRequMasterUpdate(num){
	if(num == 1){
		var data =$("#cons_iden_name").val();
		if('' == data){
			jq( "#dialogWriteConsIdenName" ).dialog();
			$("#cons_iden_name").focus();
			return;
		}
		if(confirm("공사명을 수정하시겠습니까?")){
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/OrderRequestUpdateTransGrid.sys", 
				{   
					orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>",
					cons_iden_name:data 
				},
				function(arg){ 
					if(fnAjaxTransResult(arg)) {	//성공시
						alert("공사명이 수정 되었습니다.");
						refreshThisPage();
					}
				}
			);
		}
	}
	if(num == 2){
		var data =$("#tran_data_addr").val();
		if('' == data){
			jq( "#dialogWriteTranDataAddr" ).dialog();
			$("#tran_data_addr").focus();
			return;
		}
		if(confirm("물품도착지를 수정하시겠습니까?")){
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/OrderRequestUpdateTransGrid.sys", 
				{   
					orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>",
					tran_data_addr:data,
					phoneNum:"<%=orderDetailInfo.getPhonenum()%>"
				},
				function(arg){ 
					if(fnAjaxTransResult(arg)) {	//성공시
						alert("물품도착지가 수정 되었습니다.");
						refreshThisPage();
					}
				}
			);
		}
	}
	if(num == 3){
		var data =$("#tranUserName").val();
		if('' == data){
			jq( "#dialogWriteTranUserName" ).dialog();
			$("#tranUserName").focus();
			return;
		}
		if(confirm("인수자를 수정하시겠습니까?")){
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/OrderRequestUpdateTransGrid.sys", 
				{   
					orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>",
					tranUserName:data,
					phoneNum:"<%=orderDetailInfo.getPhonenum()%>"
				},
				function(arg){ 
					if(fnAjaxTransResult(arg)) {	//성공시
						alert("인수자가 수정 되었습니다.");
						refreshThisPage();
					}
				}
			);
		}
	}
	if(num == 4){
		var data =$("#tranTeleNumb").val();
		if('' == data){
			jq( "#dialogWriteTranTeleNumb" ).dialog();
			$("#tranTeleNumb").focus();
			return;
		}
		if(confirm("인수자 전화번호를 수정하시겠습니까?")){
			$.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/OrderRequestUpdateTransGrid.sys", 
				{
					orde_iden_numb:"<%=orderDetailInfo.getOrde_iden_numb()%>",
					tranTeleNumb:data,
					phoneNum:"<%=orderDetailInfo.getPhonenum()%>"
				},
				function(arg){ 
					if(fnAjaxTransResult(arg)) {	//성공시
						alert("인수자 전화번호가 수정 되었습니다.");
						refreshThisPage();
					}
				}
			);
		}
	}
}

var changedRowId = "";
var orderStatFlagValue = "";
function popForOrderStatFlag(str,str2,purc_stat_flag){
	changedRowId = str;
	orderStatFlagValue = str2;
	if(confirm("주문의 상태를 변경하시겠습니까?")){
		var selrowContent = jq("#list2").jqGrid('getRowData',changedRowId);
		var orde_iden_numb_array = new Array();
		var purc_iden_numb_array = new Array();
		orde_iden_numb_array[0] = selrowContent.orde_iden_numb;
		purc_iden_numb_array[0] = selrowContent.purc_iden_numb;
		
		var order_select_id  = "#orderSelect_"+changedRowId;
		
		//발주차수가 1보다 크고 주문의뢰상태로 변경할시에는 '임시저장' 기능을 이용한걸로 생각하고, 주문의뢰상태로 변경을 막는다.
		if(orderStatFlagValue=='40' && purc_iden_numb_array[0] > 1){ 
			alert("공급사에 임시저장 기능을 이용 발주차수가\n분리된 경우에는 주문의뢰 상태로 변경이 불가능 합니다.\n주문의뢰로 변경이 필요할 시에 OKPlaza 유지보수 게시판에\n문의바랍니다.");
			$(order_select_id).val("50");
			return;
		}
		
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{ orde_iden_numb_array:orde_iden_numb_array,purc_iden_numb_array:purc_iden_numb_array,orde_stat_flag:purc_stat_flag },
			function(arg2){ 
				if(fnTransResult(arg2, false)) {	//성공시
					fnStatChangeReasonDialog("purcOrderStatusChange");
				} else {
					refreshThisPage();
				}
			}
		);
	}else{
		purcOrderStatusChange_cancel();
	}
}
function purcOrderStatusChange(reason){
	var selrowContent = jq("#list2").jqGrid('getRowData',changedRowId);
	var orde_iden_numb = selrowContent.orde_iden_numb; 
	var purc_iden_numb = selrowContent.purc_iden_numb; 
	var purc_stat_flag =orderStatFlagValue;
	$.post(
 			"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/purchase/purcOrderStatusUpdate.sys", 
 			{   
    			orde_iden_numb:orde_iden_numb,
    			purc_iden_numb:purc_iden_numb,
    			purc_stat_flag:purc_stat_flag,
    			reason:reason
 			},
 			function(arg){ 
 				if(fnAjaxTransResult(arg)) {	//성공시
 					alert("주문상태가 성공적으로 변경되었습니다.");
                  	refreshThisPage();
 				}
 			}
 	);
	changedRowId = "";
	orderStatFlagValue = "";
}

function purcOrderStatusChange_cancel(){
      	var selrowContent = jq("#list2").jqGrid('getRowData',changedRowId);
      	var temp_order_stat = selrowContent.purc_stat_flag;
		var temp_order_select_id  = "#orderSelect_"+changedRowId;
		$(temp_order_select_id).val(temp_order_stat);
      	changedRowId = "";
      	orderStatFlagValue = "";
}

function popForOrderCancel(){
	if(confirm("주문을 취소하시겠습니까?")){
      	fnStatChangeReasonDialog("fnOrderCancel");
	}
}
function fnOrderCancel(reason){
	var orde_iden_numb =$("#orde_iden_numb").val();
	var orderStatFlag = '';
	$.post(
 			"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/orderCancel.sys", 
 			{   
    			orde_iden_numb:orde_iden_numb,
    			reason:reason
 			},
 			function(arg){
                if(arg.customResponse.success){
                     if(arg.orderStatFlag.indexOf('승인요청') >= 0 || arg.orderStatFlag.indexOf('주문요청') >= 0 || arg.orderStatFlag.indexOf('주문의뢰') >= 0 && arg.orderStatFlag.indexOf('주문접수') < 0 && arg.orderStatFlag.indexOf('배송중') < 0) { //성공시
                         alert("주문이 성공적으로 취소되었습니다.");
                          refreshThisPage();
                     }else{
                         alert(arg.orderStatFlag+" 상태이므로 주문을 취소 할수없습니다.");
                         refreshThisPage();
                     }
                }else{
                    var errs = arg.customResponse.message;
                    var msg = "";
                    for(var i=0 ; i < errs.length; i++){
                        msg += errs[i];
                    }
                    alert(msg);
                }
 			},
 			"json"
 	);
}
function fnOrderCancel_cancel(){}

/**
 * List2의 Row을 선택 시 List3을 reload함
 */
function fnOnClickPurcList(srcOrdeIdenNumb,srcPurcIdenNumb) {
	var data3 = jq("#list3").jqGrid("getGridParam", "postData");
	data3.srcOrdeIdenNumb = srcOrdeIdenNumb;
	data3.srcPurcIdenNumb = srcPurcIdenNumb;
	jq("#list3").jqGrid("setCaption", "<font color='blue'>주문번호["+srcOrdeIdenNumb+"] 발주차수["+srcPurcIdenNumb+"]</font>의 납품정보");  
	jq("#list3").jqGrid("setGridParam", { "postData": data3 });
	jq("#list3").trigger("reloadGrid");
}

var deliChangedRowId = "";
var deliStatFlagValue = "";
function popForDeliStatFlag(str,str2,deli_stat_flag){
	deliChangedRowId = str;
	deliStatFlagValue = str2;
	if(confirm("주문의 상태를 변경하시겠습니까?")){
		var selrowContent = jq("#list3").jqGrid('getRowData',deliChangedRowId);
		var orde_iden_numb_array = new Array();
		var purc_iden_numb_array = new Array();
		var deli_iden_numb_array = new Array();
		orde_iden_numb_array[0] = selrowContent.orde_iden_numb;
		purc_iden_numb_array[0] = selrowContent.purc_iden_numb;
		deli_iden_numb_array[0] = selrowContent.deli_iden_numb;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{ orde_iden_numb_array:orde_iden_numb_array,purc_iden_numb_array:purc_iden_numb_array,deli_iden_numb_array:deli_iden_numb_array,orde_stat_flag:deli_stat_flag },
			function(arg2){ 
				if(fnTransResult(arg2, false)) {	//성공시
					fnStatChangeReasonDialog("deliOrderStatusChange");
				} else {
					refreshThisPage();
				}
			}
		);
	}else{
		deliOrderStatusChange_cancel();
	}
}
function deliOrderStatusChange(reason){
	var selrowContent = jq("#list3").jqGrid('getRowData',deliChangedRowId);
	var orde_iden_numb = selrowContent.orde_iden_numb; 
	var purc_iden_numb = selrowContent.purc_iden_numb; 
	var deli_iden_numb = selrowContent.deli_iden_numb; 
	var tempDeliStatFlagValue = deliStatFlagValue;
	$.post(
 			"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/delivery/deliveryStatusChange.sys", 
 			{   
    			orde_iden_numb:orde_iden_numb,
    			purc_iden_numb:purc_iden_numb,
    			deli_iden_numb:deli_iden_numb,
    			deliStatFlagValue:tempDeliStatFlagValue,
    			reason:reason
 			},
 			function(arg){ 
 				if(fnAjaxTransResult(arg)) {	//성공시
                  	refreshThisPage();
 				}
 			}
 	);
	deliChangedRowId = "";
	deliStatFlagValue = "";
}
function deliOrderStatusChange_cancel(){
	var temp_deli_select_id  = "#deliSelect_"+deliChangedRowId;
	$(temp_deli_select_id).val("60");
   	deliChangedRowId = "";
   	deliStatFlagValue = "";
}

function fnAttachFileDownload(attach_file_path) {
	var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}
jQuery.download = function(url, data, method){
    // url과 data를 입력받음
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');  
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    }
};
function refreshThisPage(){
	document.getElementById('goLocation').href = "<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/orderDetail.sys?orde_iden_numb=<%=orderDetailInfo.getOrde_iden_numb()%>&_menuId=<%=_menuId%>";
	document.getElementById('goLocation').click();
}

function excelButton1(){
	var colLabels = ['공급사명', '수량', '판매단가', '판매금액', '매입단가', '매입금액', '발주년금액(%)', '발주월금액(%)', '적용년금액(%)'];	
	var colIds = ['vendorname','orde_requ_quan', 'orde_requ_pric', 'total_orde_requ_pric', 'sale_unit_pric', 'total_sale_unit_pric', 'purc_price_year_str', 'purc_price_month_str', 'purc_change_price_year'];	
	var numColIds = ['orde_requ_quan','orde_requ_pric','total_orde_requ_pric','sale_unit_pric','total_sale_unit_pric'];	
	var sheetTitle = "물량배분";	
	var excelFileName = "OrderDiv";
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function excelButton2(){
	var colLabels = ['주문번호', '발주차수', '공급사명', '발주수량', '납품수량', '판매단가', '판매금액'<%if(is_adm){%>, '매입단가', '매입금액'<%}%>];	//출력컬럼명
	var colIds = ['orde_iden_numb', 'purc_iden_numb', 'vendorname', 'purc_requ_quan', 'deli_prod_quan', 'orde_requ_pric', 'total_orde_requ_pric', 'sale_unit_pric', 'total_sale_unit_pric'];	//출력컬럼ID
	var numColIds = ['purc_requ_quan', 'deli_prod_quan', 'orde_requ_pric', 'total_orde_requ_pric', 'sale_unit_pric', 'total_sale_unit_pric'];	//숫자표현ID
	var sheetTitle = "발주정보";	//sheet 타이틀
	var excelFileName = "OrderPurchase";	//file명
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
	
}
function excelButton3(){
	var colLabels = ['납품차수', '납품수량', '납품일시', '인수자', '인수일시', '주문상태', '배송완료여부', '운송수단', '송장번호'];	//출력컬럼명
	var colIds = ['deli_iden_numb', 'deli_prod_quan', 'deli_degr_date', 'rece_proc_id', 'purc_proc_date', 'deli_stat_flag_name', 'isdelivery_name', 'deli_type_clas', 'deli_invo_iden'];	//출력컬럼ID
	var numColIds = ['deli_prod_quan'];	//숫자표현ID
	var sheetTitle = "납품정보";	//sheet 타이틀
	var excelFileName = "OrderDelivery";	//file명
	fnExportExcel(jq("#list3"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
function excelButton4(){
	var colLabels = ['변경일시', '변경내용', '변경자', '변경사유'];	//출력컬럼명
	var colIds = ['regi_user_date', 'chan_cont_desc', 'regi_user_id', 'chan_reas_desc'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "주문변경이력";	//sheet 타이틀
	var excelFileName = "OrderHistory";	//file명
	fnExportExcel(jq("#list4"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//택배사 조회
function fnSearchDeliPopup(deli_type_clas_code, deli_invo_iden){
	var deliWebAddr = "";
	var order_deli_type_code = deli_type_clas_code;
	var paramString = "";
	var chkCnt = 0;
    $.post( 
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/delivery/getDeliVendor.sys',
        {deli_type_clas:order_deli_type_code},
        function(arg){
            var codeList= eval('(' + arg + ')').codeList;
            for(var i=0;i<codeList.length;i++) {
            	if(codeList[i].codeVal1 == order_deli_type_code){
            		deliWebAddr = codeList[i].codeVal2;
            		if(order_deli_type_code == "DAESIN"){
            			paramString += "?billno1="+deli_invo_iden.substring(0, 4)+"&billno2="+deli_invo_iden.substring(4, 7)+"&billno3="+deli_invo_iden.substring(7, 13);
            		}else if(order_deli_type_code == "HANIPS"){
            			paramString += "&hawb_no="+deli_invo_iden;
            		}else if(order_deli_type_code == "DHL"){
            			paramString += "&slipno="+deli_invo_iden;
            		}else{
            			paramString = deli_invo_iden;
            		}
            		deliWebAddr += paramString;
                	var scrSizeHeight = 0;
                	scrSizeHeight = screen.height;
                	var windowLeft = (screen.width-900)/2;
                	var windowTop = (screen.height-700)/2;
                	window.open(deliWebAddr,'택배사조회', 'width=900, height=700,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=yes');
                	chkCnt++;
            	}
            }   
            if(chkCnt == 0){
            	alert("일치하는 택배사가 없습니다.");
            }
        }
	);
}

function fnShowDeliHist(str1, str2, str3){
  	var popurl = "/order/delivery/deliShowHistPop.sys?orde_iden_numb="+str1+"&purc_iden_numb="+str2+"&deli_iden_numb="+str3;
  	var popproperty = "dialogWidth:550px;dialogHeight=500px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);
    window.open(popurl, 'okplazaPop', 'width=550, height=500, scrollbars=yes, status=no, resizable=no');
}

function fncRoundPrecision(num, scale){
	var ex = Math.pow(10,scale);
	var result = Math.round(num*ex)/ex;
	return result;
}
function fnCalcChangeYearsPrice(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i = 0; i < rowCnt; i++) { 
			var rowid = $("#list").getDataIDs()[i];
   			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var purc_year_price = Number(selrowContent.temp_orde_purc_pric) ; 			//발주년금액
			var sum_purc_year_price = 0;
			
   			var rowCntTemp = jq("#list").getGridParam('reccount');
   			if(rowCntTemp>0) {
   				for(var k=0; k<rowCntTemp; k++) {
   					var rowidTemp = $("#list").getDataIDs()[k];
         			var selrowContentTemp = jq("#list").jqGrid('getRowData',rowidTemp);
         			sum_purc_year_price += Number(selrowContentTemp.temp_orde_purc_pric);		// 발주년금액 합
   				}
   			}
   			var per_purc_year_price = purc_year_price/sum_purc_year_price * 100;
			jq("#list").jqGrid('setRowData', rowid, {purc_change_price_year:fnComma(purc_year_price)+" ("+fncRoundPrecision(per_purc_year_price,2)+"%)"});
		}
	}
}
function fnCalcOrdeRequQuan(cnt){
	var chkQuan = 0;
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i = 0; i < rowCnt; i++) { 
			var rowid = $("#list").getDataIDs()[i];
			jq("#list").restoreRow(rowid);
   			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
            chkQuan += Number(selrowContent.orde_requ_quan);
			jq('#list').editRow(rowid);
		}
	}
	alert(chkQuan+cnt);
	if(chkQuan+cnt > <%=orderDetailInfo.getOrder_purc()%>){
		alert("분배가능한 수량의 총 합은 <%=orderDetailInfo.getOrder_purc()%> 입니다. 다시 입력해주시기 바랍니다.");
		return;
	}
}
function orderChangeInfoSelect(){
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"ORDER_CHANGE_INFO",
			isUse:"1"
		},
		function(arg){
			var list = eval('('+arg+')').list;
			for(var i=0; i<list.length; i++){
				$("#chanConfDesc").append("<option value="+list[i].codeNm1+">"+list[i].codeNm1+"</option>");
			}
		}
	);
}

function orderChangeInfoSave(){
	var chanConfDesc = $("#chanConfDesc").val();	//변경내용
	var chanReasDesc = $("#chanReasDesc").val();		//변경사유
	if(chanConfDesc == ""){
		alert("주문변경 내용을 선택해 주세요.");
		$("#chanConfDesc").focus();
		return;
	}
	if(chanReasDesc == ""){
		alert("주문변경 사유를 입력해 주세요.");
		$("#chanReasDesc").focus();
		return;
	}
	$.post(
		"/orderRequestSvc/insertOrderChageInfo/save.sys",
		{
			oper:"add",
			idGenSvcNm:"seqMrgoodsvendorHistService",
			ordeNumb:"<%=orderDetailInfo.getOrde_iden_numb() %>",
			chanConfDesc:chanConfDesc,
			chanReasDesc:chanReasDesc
		},
		function(arg){
			if(fnAjaxTransResult(arg)) {	//성공시
				refreshThisPage();
			}else{
				refreshThisPage();
			}
		}
	);
} 
</script>
</head>
<body style="overflow-x:hidden">
<a href="" id="goLocation" style="display: none;"></a>
<form id="frm" name="frm">
<input type="hidden" id="orde_iden_numb" value="<%=orderDetailInfo.getOrde_iden_numb()%>"/>
<input type="hidden" id="_menuId" value="<%=_menuId%>"/>
		<table width="870px" style="margin-left:10px;" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="870px" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="29" class='ptitle'>주문상세조회</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="870px" border="0" cellpadding="0" cellspacing="0" style="height: 27px"> 
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
							<td class="stitle">주문자 정보</td>
							<td width="20" style="text-align: right;"><span><button class="btn btn-darkgray btn-xs" onclick="javascript:window.print();"><i class="fa fa-print"></i> 페이지출력</button></span></td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 컨텐츠 시작 -->
					<table width="870px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">고객사</td>
							<td class="table_td_contents" width="200"><%=orderDetailInfo.getOrde_client_name() %></td>
							<td class="table_td_subject" width="100">주문자</td>
							<td class="table_td_contents" width="150"><%=orderDetailInfo.getOrde_user_name() %></td>
							<td class="table_td_subject" width="100">주문자 전화번호</td>
							<td class="table_td_contents" width="150" id="ordTelNumb"><%=orderDetailInfo.getOrde_tele_numb() %></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">권역</td>
							<td class="table_td_contents"><%=orderDetailInfo.getAreatype()==null ? "": orderDetailInfo.getAreatype()%></td>
							<td class="table_td_subject" width="100">인수자</td>
                             <td class="table_td_contents">
<%
	if(isVen){
%>
                             <%=orderDetailInfo.getTran_user_name()%>
<%
	}
	else{
%>
                                <input type="text" id="tranUserName" name="tranUserName" size="10" value="<%=orderDetailInfo.getTran_user_name()%>"/> 
<%		if(statFlag < 60) { %>
                             <a href="#"> <img id="tranUserNameImg" src="/img/system/btn_type2_change.gif" width="40" height="18"  style="vertical-align: middle;border:0;"/> </a>
<%
		}
	}
%>

                             </td>
							<td class="table_td_subject" width="100">인수자 전화번호</td>
   							<td class="table_td_contents">
<%
	if(isVen){
%>
								<input type="text" id="tranTeleNumb" name="tranTeleNumb" style="width:90%" value="<%=orderDetailInfo.getTran_tele_numb() %>" readonly="readonly"/>
<%
	}
	else{
%>
								<input type="text" id="tranTeleNumb" name="tranTeleNumb" size="14" value="<%=orderDetailInfo.getTran_tele_numb() %>"/>
<%	
		if(statFlag < 60) {
%>
   							<a href="#"><img id="tranTeleNumbImg" src="/img/system/btn_type2_change.gif" width="40" height="18"  style="vertical-align: middle;border:0;"/> </a>
<%
		}
	}
%>

   							</td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">공사명</td>
							<td class="table_td_contents">
<%
	if(isVen){
%>
								<%=orderDetailInfo.getCons_iden_name()%>
<%
	}
	else{
%>
								<input id="cons_iden_name" name="cons_iden_name" type="text" value="<%=orderDetailInfo.getCons_iden_name()%>" size="21" maxlength="50" />
<%
		if(!orderDetailInfo.getOrder_status_flag().equals("주문취소")) {
%>
								<a href="#"> <img id="cons_iden_name_ch_btn" src="/img/system/btn_type2_change.gif" width="40" height="18" style="vertical-align: middle;border:0;"/> </a>
<%
		}
	}
%>

                            </td>
							<td class="table_td_subject" width="100">물품도착지</td>
							<td colspan="3" class="table_td_contents">
<%
	if(isVen){
%>
								<%=orderDetailInfo.getTran_data_addr() %>
<%
	}
	else{
%>
								<input id="tran_data_addr" name="tran_data_addr" type="text" value="<%=orderDetailInfo.getTran_data_addr() %>" size="24" maxlength="70" style="width: 88%" />
<%
		if(statFlag < 60) {
%>
								<a href="#"> <img id="tran_data_addr_ch_btn" src="/img/system/btn_type2_change.gif" width="40" height="18"  style="vertical-align: middle;border:0;"/> </a>
<%
		}
	}
%>
                            </td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">비고</td>
							<td colspan="3" class="table_td_contents">
								<textarea style="width: 98%;height: 45px;" readonly="readonly"><%=orderDetailInfo.getAdde_text_desc()%></textarea>
							</td>
							<td class="table_td_subject" width="100">감독관</td>
							<td class="table_td_contents"><%=orderDetailInfo.getDirectorname() == null ? "": orderDetailInfo.getDirectorname()%></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
                        <tr>
                           <td class="table_td_subject" width="100">첨부파일1</td>   
                           <td class="table_td_contents"> 
                              <input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=orderDetailInfo.getAttach_file_path1() %>"/>
                              <a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
                              <span id="attach_file_name1"><%if(null != orderDetailInfo.getAttach_file_name1()){out.print(orderDetailInfo.getAttach_file_name1());} %></span>
                              </a>
                           </td>
                           <td class="table_td_subject" width="100">첨부파일2</td>  
                           <td class="table_td_contents">
                              <input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=orderDetailInfo.getAttach_file_path2() %>"/>
                              <a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
                              <span id="attach_file_name2"><%if(null != orderDetailInfo.getAttach_file_name2()){out.print(orderDetailInfo.getAttach_file_name2());} %></span>
                              </a>
                           </td>
                           <td class="table_td_subject" width="100">첨부파일3</td>
                           <td class="table_td_contents">
                              <input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=orderDetailInfo.getAttach_file_path3() %>"/>
                              <a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
                              <span id="attach_file_name3"><%if(null != orderDetailInfo.getAttach_file_name3()){out.print(orderDetailInfo.getAttach_file_name3());} %></span>
                              </a>
                           </td>
                        </tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="870px" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" /></td>
							<td class="stitle">주문상품(<b><%if(null != orderDetailInfo.getGood_clas_code()){out.print(orderDetailInfo.getGood_clas_code());} %></b>)</td>
							<td align="right" class="stitle">
<%	if(!orderDetailInfo.getOrder_status_flag().equals("주문취소")&&!is_deli && orderDetailInfo.getOrder_status_flag().indexOf("주문접수") < 0 ) { %>
								<button id='orderCancel' class="btn btn-darkgray btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class="fa fa-stop-circle-o"></i> 주문취소</button>
<%	} %>
                            </td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 컨텐츠 시작 -->
					<table width="870px" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">주문번호</td>
							<td class="table_td_contents" width="200"><%=orderDetailInfo.getOrde_iden_numb() %></td>
							<td class="table_td_subject" width="100">상품코드</td>
							<td class="table_td_contents" width="145"><%=orderDetailInfo.getGood_iden_numb() %></td>
							<td class="table_td_subject" width="100">상품명</td>
							<td class="table_td_contents" width="155"><%=orderDetailInfo.getGood_iden_name() %></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">규격</td>
							<td class="table_td_contents">
	        <% 
            String result = "";
            try{
                int cnt = 0;
                String[] tempGoodStSpecDesc = new String[Constances.PROD_GOOD_ST_SPEC.length]; 
                for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {
    	        	tempGoodStSpecDesc[idx] = Constances.PROD_GOOD_ST_SPEC[idx];
                }
                
                if(null != orderDetailInfo.getGood_spec_desc()){
                    String[] tempGoodStSpecDescArray = orderDetailInfo.getGood_st_spec_desc().split("‡");
                    for(int idx = 0 ; idx < tempGoodStSpecDescArray.length ; idx++) {
                        if(tempGoodStSpecDescArray[idx].toString().trim().length()  > 0) {
                             result += tempGoodStSpecDesc[idx]+":"+ tempGoodStSpecDescArray[idx] + " ";
                             cnt++;
                        }
                    }
                }
                if(cnt>0){
                    result = "<font color='red'><b>["+result+"]</font></b>";
                }
                
                String[] tempGoodSpecDesc = new String[Constances.PROD_GOOD_SPEC.length]; 
                for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {
    	        	tempGoodSpecDesc[idx] = Constances.PROD_GOOD_SPEC[idx];
                }
                if(null != orderDetailInfo.getGood_spec_desc()){
                    String[] tempGoodSpecDescArray = orderDetailInfo.getGood_spec_desc().split("‡");
                    for(int idx = 0 ; idx < tempGoodSpecDescArray.length ; idx++) {
                        if(tempGoodSpecDescArray[idx].toString().trim().length()  > 0) {
                             if(idx == 0 ) {
                            	 result += "  "+ tempGoodSpecDescArray[idx] + "  ";
                             } else {
                            	 result += tempGoodSpecDesc[idx]+":"+ tempGoodSpecDescArray[idx] + " ";
                             }
                        }
                    }
                }
            }catch(Exception e){result="";}
            %>
                            <%=result%>
                            </td>
							<td class="table_td_subject" width="100">표준납기일</td>
							<td class="table_td_contents"><%=orderDetailInfo.getDeli_mini_day() %> 일</td>
							<td class="table_td_subject" width="100">단위</td>
							<td class="table_td_contents"><%=orderDetailInfo.getOrde_clas_code() %></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">주문상태</td>
							<td class="table_td_contents"><%=orderDetailInfo.getOrder_status_flag() %></td>
							<td class="table_td_subject" width="100">납품요청일</td>
							<td class="table_td_contents"><%=orderDetailInfo.getRequ_deli_date() %></td>
							<td class="table_td_subject" width="100">주문수량</td>
							<td class="table_td_contents"><%=orderDetailInfo.getOrde_requ_quan() %></td>
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
<%	if(is_div && is_adm && !orderDetailInfo.getOrder_status_flag().equals("승인요청") && !orderDetailInfo.getOrder_status_flag().equals("승인반려")){ %>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" style="vertical-align: middle;"/></td>
							<td class="stitle">주문의뢰</td>
							<td align="right" >
<% 		if(!orderDetailInfo.getOrder_status_flag().equals("주문취소")){ %>
								<button id='div_purc' class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'><i class="fa fa-sign-in"></i> 주문의뢰</button>
<%		}	%>
                            </td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list"></table>
					</div>
				</td>
			</tr>
<% 	}
	if(is_purc){
%>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" style="vertical-align: middle;"/></td>
							<td class="stitle">발주정보</td>
<%-- 							<td align="right"><a href="#"> <img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;' /> </a></td> --%>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list2"></table>
					</div>
				</td>
			</tr>
<% 	}
	if(is_deli){
%>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" style="vertical-align: middle;"/></td>
							<td class="stitle">배송정보</td>
<%-- 							<td align="right"><a href="#"> <img id="excelButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;' /> </a></td> --%>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list3"></table>
					</div>
				</td>
			</tr>
<%	} %>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>  
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
						<tr>
							<td width="20" valign="top"><img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" style="vertical-align: middle;"/></td>
							<td class="stitle">주문변경정보</td>
							<%-- <td align="right"><a href="#"> <img id="excelButton4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;' /> </a></td> --%>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list4"></table>
					</div>
				</td>
			</tr>
<%
	if(is_adm){
%>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" bordercolor=#85b5d9 style="border-width: 1px; border-style: solid;">
						<tr>
							<td width="120" align="center" valign="center">
								<select id="chanConfDesc"  name="chanConfDesc">
									<option value="">선택</option>
								</select>
							</td>
							<td style="padding:2px 2px 2px 2px;">
								<textarea id="chanReasDesc" name="chanReasDesc" rows="4" cols="120" style="height: 52px;"></textarea>
							</td>
							<td width="62px" align="center" style="cursor: pointer;" id="orderChangeInfoSaveButton">
								<button id='' class="btn btn-darkgray btn-sm" style="width:50px;hieght:50px;"> 저 장</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
<%
	}
%>
		</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialogWriteConsIdenName" title="Warning" style="display:none;font-size: 12px;color: red;">
   <p>공사명을 입력해주십시오.</p>
</div>
<div id="dialogWriteTranDataAddr" title="Warning" style="display:none;font-size: 12px;color: red;">
   <p>물품도착지를 입력해주십시오.</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
<%@ include file="/WEB-INF/jsp/common/svcStatChangeReasonDiv.jsp" %>
</form>
</body>
</html>