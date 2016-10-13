<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.order.dto.CartMasterInfoDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
   String listHeight = "$(window).height()-360 + Number(gridHeightResizePlus)";
   @SuppressWarnings("unchecked")
   List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
   String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   String borgId = loginUserDto.getBorgId();
   boolean isVendor = "VEN".equals(loginUserDto.getSvcTypeCd()) ? true : false;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<!-- 버튼 이벤트 스크립트 정의 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#excelButton").click(function(){ exportExcel(); });
    $("#delButton").click( function() { fnDeleteCateProduct(); });
    $("#orderRequestButton").click( function() { fnOrderRequest(); });
    $("#borgName").keydown(function(e){ if(e.keyCode==13) { $("#searchBorgBtn").click(); }});
    $("#borgName").change(function(e){
    	$("#borgName").val("");
    	$("#groupId").val("");
    	$("#clientId").val("");
    	$("#branchId").val("");
    	$("#cons_iden_name").val("");
    	$("#tran_user_name").val("");
    	$("#orde_text_desc").val("");
    	$("#tran_tele_numb").val("");
    	fnInitComponent();
    });
});
//리사이징
$(window).bind('resize', function() { 
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#searchBorgBtn").click(function(){
		if($("#groupId").val() != "") {
			if(confirm("고객사를 변경시 상품리스트는 삭제됩니다.\n변경하시겠습니까?")){
				$("#borgName").val("");
		        $("#groupId").val("");
		        $("#clientId").val("");
		        $("#branchId").val("");
		        $("#cons_iden_name").val("");
		        $("#tran_user_name").val("");
		        $("#orde_text_desc").val("");
		        $("#tran_tele_numb").val("");
		        $("#orde_userId").val("");
				fnInitComponent();
	        } else {
	            return;
	        }
		}
		var borgNm = $("#borgName").val();
		fnBuyborgDialog("BCH", "1", borgNm, "fnCallBackBuyBorg");
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
   $("#groupId").val(groupId);
   $("#clientId").val(clientId);
   $("#branchId").val(branchId);
   
   $("#borgName").val(borgNm);
   fnInitComponent();
   fnGetBuyerInfo();
   fnGetBuyAddressInfo();
}
//컴퍼넌트초기화 
function fnInitComponent() {
    $("#orde_user_id").children().remove().end().append('<option selected value="">선택</option>');
    $('#tran_deta_addr_seq').children().remove().end().append('<option selected value="">선택</option>');
    $('#list').jqGrid('clearGridData');
}
// 조직에 따른 사용자 정보 조회 
function fnGetBuyerInfo() {
    $.post( //조회조건의 권역세팅
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/getUserInfoListByBranchIdInVendorOrderRequest.sys',
            {borgId:$("#branchId").val()},
            function(arg){
                var userList = eval('(' + arg + ')').userList;
                for(var i=0;i<userList.length;i++) {
                    $("#orde_user_id").append("<option value='"+userList[i].userId+"'>"+userList[i].userNm+"</option>");
                }   
            }
        );
}
// 배송지 정보 조회
function fnGetBuyAddressInfo() {
    $.post( //조회조건의 권역세팅
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getDeliveryAddressByBranchId.sys',
            {groupId:$("#groupId").val(),clientId:$("#clientId").val(),branchId:$("#branchId").val()},
            function(arg){
                var deliveryListInfo = eval('(' + arg + ')').deliveryListInfo;
                for(var i=0;i<deliveryListInfo.length;i++) {
                        $("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"'  >"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");
                }   
            }
        );
}
</script>
<% //----------------------------------조직검색팝업 종료 ------------------------------ %>

<%
/**------------------------------------ 공급사 상품 검색 팝업 시작 ---------------------------------
* fnSearchProductForVendor(groupId, clientId, branchId) 을 호출하여 Div팝업을 Display ===
* groupId : 고객사 그룹Id
* clientId : 고객사 법인Id
* branchId : 고객사 사업장Id
* ※ CallBack function은 고정    --> fnCallBackSearchProductForVendor (obj)
* 콜백 파라미너틑 Arry (상품진열SEQ) 를 던진다. 
*/
%>
<%@ include file="/WEB-INF/jsp/common/product/prodSearchForVen.jsp" %>
<!-- 공급사 상품 검색 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
   $('#btnSearchProduct').click(function(){
      fnOpenProdSearchPopForVendor();
//       if($('#branchId').val() == '' ){
//          $('#dialogSelectRow').html('<p>구매사 선택후 상품 조회가 가능하십니다.<br />확인후 이용하시기 바랍니다.</p>');
//          $("#dialogSelectRow").dialog({
//                  title:'Warning',modal:true
//              });
//          return; 
//       }
//       fnSearchProductForVendor($('#groupId').val(),$('#clientId').val(),$('#branchId').val()); 
   });
});

/**
 *  콜백함수  
 */
function fnCallBackSearchProductForVendor(obj) {
    var rowCnt = $("#list").getGridParam('reccount');
    if(rowCnt>0) {
        for(var arrIdx=0 ; arrIdx<obj.length ; arrIdx++) {
            for(var idx=0; idx<rowCnt; idx++) {
                var rowid = $("#list").getDataIDs()[idx];
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                var msg = ""; 
                msg += "\n obj[arrIdx] value ]["+obj[arrIdx]+"]["; 
                msg += "\n selrowContent.disp_good_id value ]["+selrowContent.disp_Good_Id+"][";
                //alert(msg);
                if(obj[arrIdx] == selrowContent.disp_Good_Id) {
                    obj.splice(arrIdx,1); 
                }
            }   
        }
    }
    if(obj.length > 0 ){
        $.post( //조회조건의 권역세팅
                '<%=Constances.SYSTEM_CONTEXT_PATH %>/product/getChoiceProductListInfoByVendor.sys',
                {disp_good_ids:obj},
                function(arg){
                    var list = eval('(' + arg + ')').list;
                    
                    // 품목 규격 설정
                    var prodSpcNm = new Array();
                    <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
                        prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
                    <% }  %>
                    
                    
                    
                    for(var i=0;i<list.length;i++) {
                        $('#list').addRowData( $('#list').getGridParam("records") , list[i]);
                        var rowIdx = $('#list tbody:last-child tr:last').attr('id');
                        var inputBtn = "<input style='height:22px;width:80px;' type='button' value='상품삭제' onclick=\"fnDeleteCateProductByButton('"+rowIdx+"');\" />";
                        
                        jQuery('#list').jqGrid('setRowData',rowIdx  ,{btn:inputBtn});
                        
                        // img 화면 로드 
                        var imgTag = ""; 
                        if($.trim(list[i].small_img_Path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+list[i].small_img_path+"' style='width:35px;height:35px;' />";   
                        else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
                        
                        jQuery('#list').jqGrid('setRowData',rowIdx,{small_Img_Path:imgTag,vendorNm:list[i].vendorId});
                    }
                    
                    fnTotalAmountSum();
                    
                    var rowCnt = jq("#list").getGridParam('reccount');
                    if(rowCnt>0) {
                        for(var i=0; i<rowCnt; i++) {
                            var rowid = $("#list").getDataIDs()[i];
                            // 규격 화면 로드
                            var argArray = FNgetGridDataObj('list',rowid,'good_Spec_Desc').split("‡");
                            var prodSpec = "";
                            for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
                                if(argArray[jIdx] > ' ') {
                                    prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
                                }
                            }
                            jQuery('#list').jqGrid('setRowData',rowid,{'good_Spec_Desc':prodSpec});
                        }
                    }
                }
            );  
    }
}

/**
 * 고객사 진열 상품 
 */
function fnOpenProdSearchPopForVendor() {
    if($('#branchId').val() == '' ) {
        $('#dialogSelectRow').html('<p>구매사 선택후 상품 조회가 가능하십니다.<br />확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
        return;
    }
    
    var menuId = '<%=menuId%>';
    var groupId  = $('#groupId').val();
    var clientId = $("#clientId").val();
    var branchId = $('#branchId').val();
    var branchNms = $('#borgName').val();
    var vendorid = '<%=borgId%>';
    
    var popurl = "/product/prodSearchForAdmOrde.sys?_menuId="+menuId+"&groupId="+groupId+"&clientId="+clientId+"&branchId="+branchId+"&branchNms="+branchNms+"&vendorid="+vendorid+"&srcIsCen=false";
    var popproperty = "width=1000px, height=650px, status=no,resizable=no";
    window.open(popurl, 'window', popproperty);
//     var popproperty = "dialogWidth:950px;dialogHeight=570px;scroll=no;status=no;resizable=no;";
//     var vReturn = window.showModalDialog(popurl,self,popproperty);
//     if(vReturn == undefined || vReturn.isSuccess != "success" ){return;}
    
//      //중복체크
//     var rowCnt = $("#list").getGridParam('reccount');
//     if(rowCnt>0) {
//         for(var arrIdx=0 ; arrIdx < vReturn['objs'].length ; arrIdx++) {
//             var overlap = "true";
//             for(var idx=0; idx < rowCnt; idx++) {
//                 var rowid = $("#list").getDataIDs()[idx];
//                 var selrowContent = jq("#list").jqGrid('getRowData',rowid);
//                 if(vReturn['objs'][arrIdx].disp_good_id == selrowContent.disp_Good_Id) {
//                     //중복
//                     overlap = "false";
//                     continue;
//                 }
//             }
//             if(overlap == "true") {
//                 //alert("등록 : "+vReturn['objs'][arrIdx].good_name);
//             	jq("#list").addRowData(vReturn['objs'][arrIdx].disp_good_id,{
//                     good_Name:vReturn['objs'][arrIdx].good_name,
//                     small_Img_Path:vReturn['objs'][arrIdx].small_img_path,
//                     good_Iden_Numb:vReturn['objs'][arrIdx].good_iden_numb,
//                     vendorNm:vReturn['objs'][arrIdx].borgnm,
//                     good_Spec_Desc:vReturn['objs'][arrIdx].good_spec_desc,
//                     orde_Clas_Code:vReturn['objs'][arrIdx].orde_clas_code,
//                     sale_Unit_Pric:vReturn['objs'][arrIdx].sale_unit_pric,
//                     ord_Quan:vReturn['objs'][arrIdx].ord_quan,
//                     total_Amout:vReturn['objs'][arrIdx].total_amout_sale_unit_pric,
//                     stan_Deli_Day:vReturn['objs'][arrIdx].stan_deli_day,
//                     deli_Mini_Day:vReturn['objs'][arrIdx].deli_mini_day,
//                     deli_mini_quan:vReturn['objs'][arrIdx].deli_Mini_Quan,
//                     disp_Good_Id:vReturn['objs'][arrIdx].disp_good_id,
//                     deli_Mini_Quan:vReturn['objs'][arrIdx].deli_mini_quan,
//                     vendorId:vReturn['objs'][arrIdx].vendorid
//                 });
//                 var rowIdx = $('#list tbody:last-child tr:last').attr('id');
//                 var inputBtn = "<input style='height:22px;width:80px;' type='button' value='상품삭제' onclick=\"fnDeleteCateProductByButton('"+rowIdx+"');\" />";
                
//                 jQuery('#list').jqGrid('setRowData',rowIdx  ,{btn:inputBtn});
                
//                 // img 화면 로드
//                 var imgTag = "";
//                 if($.trim(vReturn['objs'][arrIdx].small_img_path) > ' ') imgTag = vReturn['objs'][arrIdx].small_img_path;
<%--                 else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />"; --%>
//                 jQuery('#list').jqGrid('setRowData',rowIdx,{small_Img_Path:imgTag});
                
//             }
//         }
//     } else {
//         for(var arrIdx = 0 ; arrIdx < vReturn['objs'].length ; arrIdx++) {
//             jq("#list").addRowData(vReturn['objs'][arrIdx].disp_good_id,{
//                 good_Name:vReturn['objs'][arrIdx].good_name,
//                 small_Img_Path:vReturn['objs'][arrIdx].small_img_path,
//                 good_Iden_Numb:vReturn['objs'][arrIdx].good_iden_numb,
//                 vendorNm:vReturn['objs'][arrIdx].borgnm,
//                 good_Spec_Desc:vReturn['objs'][arrIdx].good_spec_desc,
//                 orde_Clas_Code:vReturn['objs'][arrIdx].orde_clas_code,
//                 sale_Unit_Pric:vReturn['objs'][arrIdx].sale_unit_pric,
//                 ord_Quan:vReturn['objs'][arrIdx].ord_quan,
//                 total_Amout:vReturn['objs'][arrIdx].total_amout_sale_unit_pric,
//                 stan_Deli_Day:vReturn['objs'][arrIdx].stan_deli_day,
//                 deli_Mini_Day:vReturn['objs'][arrIdx].deli_mini_day,
//                 deli_mini_quan:vReturn['objs'][arrIdx].deli_Mini_Quan,
//                 disp_Good_Id:vReturn['objs'][arrIdx].disp_good_id,
//                 deli_Mini_Quan:vReturn['objs'][arrIdx].deli_mini_quan,
//                 vendorId:vReturn['objs'][arrIdx].vendorid
//             });
//             var rowIdx = $('#list tbody:last-child tr:last').attr('id');
//             var inputBtn = "<input style='height:22px;width:80px;' type='button' value='상품삭제' onclick=\"fnDeleteCateProductByButton('"+rowIdx+"');\" />";
            
//             jQuery('#list').jqGrid('setRowData',rowIdx  ,{btn:inputBtn});
            
//             // img 화면 로드
//             var imgTag = "";
//             if($.trim(vReturn['objs'][arrIdx].small_img_path) > ' ') imgTag = vReturn['objs'][arrIdx].small_img_path;
<%--             else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />"; --%>
            
//             jQuery('#list').jqGrid('setRowData',rowIdx,{small_Img_Path:imgTag});
//         }
//     }
//     fnTotalAmountSum();
}

function productList(productArray){
	var rowCnt = $("#list").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i=0; i<productArray.length; i++){
			var overlap = "true";
			for(var idx=0; idx < rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(productArray[i].disp_good_id == selrowContent.disp_Good_Id) {
					//중복
					overlap = "false";
					continue;
				}
			}
			if(overlap == "true") {
				var convertGoodClasCode = "";
				var good_clas_code = productArray[i].good_clas_code;
				if(good_clas_code == '10'){
					convertGoodClasCode = "일반";
				}else if(good_clas_code == '20'){
					convertGoodClasCode = "지정";
				}else if(good_clas_code == '30'){
					convertGoodClasCode = "수탁";
				}
				jq("#list").addRowData(productArray[i].disp_good_id,{
					good_Name:productArray[i].good_name,
					small_Img_Path:productArray[i].small_img_path,
					good_Iden_Numb:productArray[i].good_iden_numb,
					vendorNm:productArray[i].borgnm,
					good_Spec_Desc:productArray[i].good_spec_desc,
					orde_Clas_Code:productArray[i].orde_clas_code,
					sale_Unit_Pric:productArray[i].sale_unit_pric,
					ord_Quan:productArray[i].ord_quan,
					total_Amout:productArray[i].total_amout_sale_unit_pric,
					stan_Deli_Day:productArray[i].stan_deli_day,
					deli_Mini_Day:productArray[i].deli_mini_day,
					deli_mini_quan:productArray[i].deli_Mini_Quan,
					disp_Good_Id:productArray[i].disp_good_id,
					deli_Mini_Quan:productArray[i].deli_mini_quan,
					vendorId:productArray[i].vendorid
				});
				var rowIdx = $('#list tbody:last-child tr:last').attr('id');
				var inputBtn = "<input style='height:22px;width:80px;' type='button' value='상품삭제' onclick=\"fnDeleteCateProductByButton('"+rowIdx+"');\" />";
				jQuery('#list').jqGrid('setRowData',rowIdx  ,{btn:inputBtn});
				// img 화면 로드
				var imgTag = "";
				if($.trim(productArray[i].small_img_path) > ' ') imgTag = productArray[i].small_img_path;
				else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
				jQuery('#list').jqGrid('setRowData',rowIdx,{small_Img_Path:imgTag});
			}
		}
	}else {
		for(var i = 0 ; i < productArray.length ; i++) {
			jq("#list").addRowData(productArray[i].disp_good_id,{
				good_Name:productArray[i].good_name,
				small_Img_Path:productArray[i].small_img_path,
				good_Iden_Numb:productArray[i].good_iden_numb,
				vendorNm:productArray[i].borgnm,
				good_Spec_Desc:productArray[i].good_spec_desc,
				orde_Clas_Code:productArray[i].orde_clas_code,
				sale_Unit_Pric:productArray[i].sale_unit_pric,
				ord_Quan:productArray[i].ord_quan,
				total_Amout:productArray[i].total_amout_sale_unit_pric,
				stan_Deli_Day:productArray[i].stan_deli_day,
				deli_Mini_Day:productArray[i].deli_mini_day,
				deli_mini_quan:productArray[i].deli_Mini_Quan,
				disp_Good_Id:productArray[i].disp_good_id,
				deli_Mini_Quan:productArray[i].deli_mini_quan,
				vendorId:productArray[i].vendorid
			});
			var rowIdx = $('#list tbody:last-child tr:last').attr('id');
			var inputBtn = "<input style='height:22px;width:80px;' type='button' value='상품삭제' onclick=\"fnDeleteCateProductByButton('"+rowIdx+"');\" />";
			jQuery('#list').jqGrid('setRowData',rowIdx  ,{btn:inputBtn});
			// img 화면 로드
			var imgTag = "";
			if($.trim(productArray[i].small_img_path) > ' ') imgTag = productArray[i].small_img_path;
			else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
			jQuery('#list').jqGrid('setRowData',rowIdx,{small_Img_Path:imgTag});
		}
	}
	fnTotalAmountSum();
}
 
/**
 *  삼품검색 콜백 
 */
function fnProdSearchCallBack(good_Iden_Numb , good_Name , full_Cate_Name) {
   var msg = ""; 
   msg += "\n good_Iden_Numb value ["+good_Iden_Numb +"]"; 
   msg += "\n good_Name value ["+good_Name+"]";
   msg += "\n full_Cate_Name value ["+full_Cate_Name +"]";
   //alert(msg);
   $('#good_iden_numb').val(good_Iden_Numb);
   $('#good_Name').val(good_Name);
}

/**
*   주문조회 페이지로 이동한다. 
*/
function fnGoOrderList(){
    $('#frm').attr('action','/order/orderRequest/orderList.sys');
    $('#frm').attr('Target','_self');
    $('#frm').attr('method','post');
    $('#frm').submit();
}
</script>
<% //------------------------------공급사 상품 검색  종료 ----------------------------------- %>


<%
/**------------------------------------배송지관리팝업 사용방법---------------------------------
* fnDeliveryAddressManageDialog(groupId, clientId, branchId, callbackString) 을 호출하여 Div팝업을 Display ===
* groupId : 고객사 그룹Id
* clientId : 고객사 법인Id
* branchId : 고객사 사업장Id
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 2개(우편번호, 주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/deliveryAddressManageDiv.jsp" %>
<!-- 배송지관리팝업 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
   $("#btnAddDeliveryAddress").click(function(){
        if($('#branchId').val() == '' ){
            $('#dialogSelectRow').html('<p>구매사 선택후 배송지를 수정 하실수 있습니다. \n확인후 이용하시기 바랍니다.</p>');
            $("#dialogSelectRow").dialog({
                title:'Warning',modal:true
            });
            return; 
        }
        fnDeliveryAddressManageDialog($('#groupId').val(),$('#clientId').val(),$('#branchId').val(),"fnCallBackDeliveryAddressManage"); 
    });
});
/**
 * 배송지관리팝업검색 후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressManage(deliId) {
    if(deliId != undefined){
        fnSelectBoxAddressInfo(deliId);
    }else{
        fnGetBuyAddressInfo(deliId);
    }
}
function fnSelectBoxAddressInfo(deliId) {
    $("#tran_deta_addr_seq").val(deliId);
}
//배송지 정보 조회
function fnGetBuyAddressInfo() {
    var msg = ""; 
    msg += "\n "+ $('#groupId').val(); 
    msg += "\n "+ $('#clientId').val();
    msg += "\n "+ $('#branchId').val();
    //alert(msg); 
    
    $.post(
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getDeliveryAddressByBranchId.sys',
        {groupId:$('#groupId').val(),clientId:$('#clientId').val(),branchId:$('#branchId').val()},
        function(arg){
            var deliveryListInfo = eval('(' + arg + ')').deliveryListInfo;
            
            for(var i=0;i<deliveryListInfo.length;i++) {
                if(deliveryListInfo[i].isdefault == "1") 
                    $("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"' selected >"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");
                else
                    $("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"'>"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");
            }
        }
    );
}
</script>
<% //------------------------------배송지관리팝업 종료 ----------------------------------- %>

<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
   $("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#firstattachseq").val(), "fnCallBackAttach1"); });
   $("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2"); });
   $("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#thirdattachseq").val(), "fnCallBackAttach3"); });
});
/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#firstattachseq").val(rtn_attach_seq);
   $("#attach_file_name1").text(rtn_attach_file_name);
   $("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#secondattachseq").val(rtn_attach_seq);
   $("#attach_file_name2").text(rtn_attach_file_name);
   $("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
   $("#thirdattachseq").val(rtn_attach_seq);
   $("#attach_file_name3").text(rtn_attach_file_name);
   $("#attach_file_path3").val(rtn_attach_file_path);
}
/**
 * 파일다운로드
 */
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
            var pair = new Array();  
            pair = this.split('=');
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var lastSelectSelIdx; 
jq(function() {
    jq("#list").jqGrid({
        url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys", 
        editurl:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",
        datatype: 'json',
        mtype: 'POST',
        colNames:['상품명','상품규격','이미지','상품코드','공급사','단위','단가','주문수량','주문금액','표준납기일','납기희망일','상품삭제','deli_mini_quan' , 'disp_good_id' , 'deli_Mini_Quan' , '공급사'],
        colModel:[
            {name:'good_Name'     , index:'good_name'     ,width:210,align:"center",search:false,sortable:false, align:"left",editable:false },
            {name:'good_Spec_Desc',index:'good_Spec_Desc' ,width:180,align:"center",search:false,sortable:false, align:"left",editable:false },
            {name:'small_Img_Path',index:'small_img_path' ,width:70,align:"center",search:false,sortable:false, editable:false },    
            {name:'good_Iden_Numb',index:'good_iden_numb' ,width:75,align:"center",search:false,sortable:false, editable:false },    
            {name:'vendorNm'      ,index:'vendorNm'         ,width:100,align:"center",search:false,sortable:false, align:"left",editable:false },    
            {name:'orde_Clas_Code',index:'orde_Clas_Code' ,width:50,align:"center",search:false,sortable:false, align:"center",editable:false },
            {name:'sale_Unit_Pric'    ,index:'sale_Unit_Pric'     ,width:80,align:"center",search:false,sortable:false, align:"right", editable:false
                ,formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},     
            {name:'ord_Quan',index:'ord_Quan', width:60,align:"right",search:false,sortable:true, editable:true,formatter: 'integer',
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
                            //123
                            var rowid = (this.id).split("_")[0];
                            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                            var inputVal = Number(this.value);                      // 입력 수량 
                            var miniVal = Number(selrowContent.deli_Mini_Quan);     // 상품 최초 구매 수량 
                            var sellPrice = Number(selrowContent.sale_Unit_Pric);   // 상품 매입단가 
                            
                            var msg = ""; 
                            msg += "\n inputVal value =["+inputVal+"]";
                            msg += "\n miniVal value =["+miniVal+"]";
                            //alert(msg); 
                            
                            if(inputVal<miniVal){
                                alert("최소주문수량 이하는 신청할 수 없습니다.\n해당 상품의 최소수량은 "+miniVal+" 입니다.");
                                jq("#list").restoreRow(rowid);
                                jq("#list").jqGrid('setRowData', rowid, {ord_Quan:miniVal,total_Amout:(miniVal*sellPrice)});
                                jq('#list').editRow(rowid,true);
                                
                            }else {
                                jq("#list").restoreRow(rowid);
                                jq("#list").jqGrid('setRowData', rowid, {ord_Quan:inputVal,total_Amout:(inputVal*sellPrice)});
                                jq('#list').editRow(rowid,true);
                            }
                            fnTotalAmountSum();
                        }
                    }]
                }
            },
            {name:'total_Amout'   ,index:'total_Amout'    ,width:70,align:"center",search:false,sortable:false, align:"right", editable:false 
                ,formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
            {name:'stan_Deli_Day' ,index:'stan_Deli_Day'  ,width:100,align:"center",search:false,sortable:false, align:"center",editable:false },
            {name:'deli_Mini_Day',index:'deli_Mini_Day',width:120,align:"center",search:false,sortable:false,  // deli_Mini_Day 
                 formatter: 'text',
                 editable:true,edittype: 'text',
                 editoptions: {
                     size: 9,maxlengh: 10,dataInit: function (element) {
                     $(element).datepicker({ dateFormat: 'yy-mm-dd' });
                },
                dataEvents:[{
                    type:'change',
                    fn:function(e){
                        if(e.keyCode==13) return;
                        var inputValue = this.value;                                            // 입력 날짜
                        var rowid = (this.id).split("_")[0];
                        jq("#list").restoreRow(rowid);
                        jq("#list").jqGrid('setRowData', rowid, {deli_Mini_Day:inputValue});
                        jq('#list').editRow(rowid);
                    }
                }]
                },
                editrules: {date: false}
            },//납품요청일
            {name:'btn'     , index:'btn'     ,width:80,align:"center",search:false,sortable:false, align:"left",editable:false},
            {name:'deli_mini_quan'     , index:'deli_mini_quan'     ,width:210,align:"center",search:false,sortable:false, align:"left",editable:false ,hidden:true}, 
            {name:'disp_Good_Id'     , index:'disp_Good_Id'     ,width:210,align:"center",search:false,sortable:false, align:"left",editable:false ,hidden:true},
            {name:'deli_Mini_Quan'   , index:'deli_Mini_Quan'   ,width:210,align:"center",search:false,sortable:false, align:"left",editable:false ,hidden:true},
            {name:'vendorId'   , index:'vendorId'   ,width:210,align:"center",search:false,sortable:false, align:"left",editable:false ,hidden:true}
        ],
        postData: {},
        multiselect: false,    
        rowNum:0, 
 /*       rownumbers: true, 
        rowList:[30,50,100], 
        pager: '#pager',     */                                                                                 
        height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
        sortname: '', sortorder: '',                                                                                                                            
        caption:"역주문 상품 조회",                                                                                                                                     
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {
            
            var rowCnt = jq("#list").getGridParam('reccount');
            
            if(rowCnt>0) {
                for(var i=0; i<rowCnt; i++) {
                    var rowid = $("#list").getDataIDs()[i];
                    jq("#list").restoreRow(rowid);
                    var inputBtn = "<input style='height:22px;width:80px;' type='button' value='상품삭제' onclick=\"fnDeleteCateProductByButton('"+rowid+"');\" />"; 
                    jQuery('#list').jqGrid('setRowData',rowid,{btn:inputBtn});
                    /* jQuery('#list').jqGrid('editRow',rowid,true); */
                    
                } 
                fnTotalAmountSum();
            } 
        },    
        onSelectRow: function (rowid, iRow, iCol, e) {
            if(rowid && rowid!==lastSelectSelIdx){
                jQuery('#list').jqGrid('restoreRow',lastSelectSelIdx);
                jQuery('#list').jqGrid('editRow',rowid,true);
                lastSelectSelIdx=rowid;
            } 
        },                                                                                                        
        ondblClickRow: function (rowid, iRow, iCol, e) {},                                                                                                      
        onCellSelect: function(rowid, iCol, cellcontent, target){},                                                                                             
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },                                                                               
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell", userdata:"userdata"},
        footerrow: true,
        userDataOnFooter: true
    });
});
</script>

<!-- 이벤트 처리 스크립트 -->
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

function fnTotalAmountSum() {
   var rowCnt = jq("#list").getGridParam('reccount');
   var SumTotalamount = 0;  
   if(rowCnt>0) {
      for(var i=0; i<rowCnt; i++) {
         var rowid = $("#list").getDataIDs()[i];
         SumTotalamount += Number(jq("#list").jqGrid('getRowData',rowid).total_Amout); 
      }
   }
   SumTotalamount = fnComma(SumTotalamount);
   jq("#list").jqGrid("footerData","set",{total_Amout:SumTotalamount,good_Name:"주문합계"},false);
}

// 삭제 버튼 클릭시 발생 이벤트 
function fnDeleteCateProduct() {
   var row = jq("#list").jqGrid('getGridParam','selrow');
   if (row == "" || row == null ){
      $('#dialogSelectRow').html('<p>상품선택후 이용하시기 바랍니다.</p>'); 
      $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
      return; 
   }
   
   fnDeleteTransaction(row);
}

function fnDeleteCateProductByButton(rowIdx) {
    fnDeleteTransaction(rowIdx);
}

function fnDeleteTransaction(rowIdx) {
    jQuery("#list").delRowData(rowIdx);
    fnTotalAmountSum();
}

//주문 신청 버튼 클릭시
function fnOrderRequest(){
    var rowCnt = jq("#list").getGridParam('reccount');
    
    if(rowCnt==0 || rowCnt==null ) {
        $('#dialogSelectRow').html('<p>관심 상품 정보가 없습니다. 확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
        $("#srcBorgName").focus();
        return;
    }
    
    var groupid            = $("#groupId ").val();                          // 그룹 ID
    var clientid           = $("#clientId").val();                          // 법인 ID 
    var branchid           = $("#branchId").val();                          // 사업장 ID
    var cons_iden_name     = $("#cons_iden_name").val();                    // 공사명
    var orde_type_clas     = "40";                                          // 주문유형
    var orde_tele_numb     = '';                                            // 주문자 전화번호
    var orde_user_id       = $("#orde_user_id").val();                      // 주문자 ID
    var tran_data_addr     = $("#tran_deta_addr_seq").val();                // 배송지주소
    var tran_user_name     = $("#tran_user_name").val();                    // 인수자
    var tran_tele_numb     = $("#tran_tele_numb").val();                    // 인수자 전화번호
    var adde_text_desc     = $("#orde_text_desc").val();                    // 비고
    var mana_user_name     = "";                                            // 감독명 
    var attach_file_1      = $("#firstattachseq").val();                    // 첨부파일1
    var attach_file_2      = $("#secondattachseq").val();                   // 첨부파일2
    var attach_file_3      = $("#thirdattachseq").val();                    // 첨부파일3
    var disp_good_id_array   = new Array();                                 // 진열 SEQ
    var orde_requ_quan_array = new Array();                                 // 주문수량
    var requ_deli_date_array = new Array();                                 // 납품요청일
    var good_name_array = new Array();                                 		// 상품명
    
    if($.trim(branchid) == "" ) {
        $('#dialogSelectRow').html('<p>구매사 조직정보는 필수 입니다. 설정후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
        $("#cons_iden_name").focus();
        return;
    }
    
    if($.trim(cons_iden_name) == "" ) {
        $('#dialogSelectRow').html('<p>공사명은 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
        $("#cons_iden_name").focus();
        return;
    }
    
    if($.trim(orde_user_id) == "" ) {
        $('#dialogSelectRow').html('<p>주문자정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
        $("#orde_user_id").focus();
        return;
    }

    if($.trim(tran_user_name) == "" ) {
        $('#dialogSelectRow').html('<p>인수자정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
        $("#tran_user_name").focus();
        return;
    }
    
    if($.trim(tran_tele_numb) == "" ) {
        $('#dialogSelectRow').html('<p>인수자 연락처는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
        $("#tran_tele_numb").focus();
        return;
    }
    
    if($.trim(tran_data_addr) == "" ) {
        $('#dialogSelectRow').html('<p>배송지 정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog({
            title:'Warning',modal:true
        });
        $("#tran_deta_addr_seq").focus();
        return;
    }
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt>0) {
        for(var i=0; i<rowCnt; i++) {
            var rowid = $("#list").getDataIDs()[i];
            jq('#list').saveRow(rowid);
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
            if(0 == Number(selrowContent.ord_Quan)){
            	alert("["+selrowContent.good_Name+"] 상품의 최소주문수량은 ["+selrowContent.deli_Mini_Quan+"] 입니다.");  
                jq("#list").restoreRow(rowid);
            	return;
            }
        }  
    }
    if(!confirm("해당 상품을 주문요청 하시겠습니까?")){ return; }
    for(var idx=0; idx<rowCnt; idx++) {
        var rowid = $("#list").getDataIDs()[idx];
        
        jq('#list').saveRow(rowid);
        var selrowContent = jq("#list").jqGrid('getRowData',rowid);
        disp_good_id_array[idx]     = selrowContent.disp_Good_Id;
        orde_requ_quan_array[idx]   = selrowContent.ord_Quan;
        requ_deli_date_array[idx]   = selrowContent.deli_Mini_Day;
        good_name_array[idx] = selrowContent.good_Name;
        
        var msg = ''; 
        msg += 'disp_good_id_array[idx] value ['+disp_good_id_array[idx]+']'; 
        msg += 'orde_requ_quan_array[idx] value ['+orde_requ_quan_array[idx]+']';
        msg += 'requ_deli_date_array[idx] value ['+requ_deli_date_array[idx]+']';
    }
    
    var msg = ""; 
    msg += "\n 그룹 ID        value ["+groupid             +"]"; 
    msg += "\n 법인 ID        value ["+clientid            +"]"; 
    msg += "\n 사업장 ID       value ["+branchid            +"]"; 
    msg += "\n 공사명              value ["+cons_iden_name      +"]"; 
    msg += "\n 주문유형             value ["+orde_type_clas      +"]"; 
    msg += "\n 주문자 전화번호     value ["+orde_tele_numb      +"]"; 
    msg += "\n 주문자 ID       value ["+orde_user_id        +"]"; 
    msg += "\n 배송지주소        value ["+tran_data_addr      +"]"; 
    msg += "\n 인수자                  value ["+tran_user_name      +"]"; 
    msg += "\n 인수자 전화번호     value ["+tran_tele_numb      +"]"; 
    msg += "\n 비고                   value ["+adde_text_desc      +"]"; 
    msg += "\n 감독명                  value ["+mana_user_name      +"]"; 
    msg += "\n 첨부파일1       value ["+attach_file_1       +"]"; 
    msg += "\n 첨부파일2       value ["+attach_file_2       +"]"; 
    msg += "\n 첨부파일3       value ["+attach_file_3       +"]"; 
    msg += "\n 진열 SEQ       value ["+disp_good_id_array  +"]"; 
    msg += "\n 주문수량             value ["+orde_requ_quan_array+"]"; 
    msg += "\n 납품요청일        value ["+requ_deli_date_array+"]"; 
    
    //123
    var params = {
            groupid:groupid
            ,clientid:clientid
            ,branchid:branchid
            ,cons_iden_name:cons_iden_name
            ,orde_type_clas:orde_type_clas
            ,attach_file_1:attach_file_1
            ,attach_file_2:attach_file_2
            ,attach_file_3:attach_file_3
            ,orde_tele_numb:orde_tele_numb
            ,orde_user_id:orde_user_id
            ,tran_data_addr:tran_data_addr
            ,tran_user_name:tran_user_name
            ,tran_tele_numb:tran_tele_numb
            ,adde_text_desc:adde_text_desc
            ,mana_user_name:mana_user_name
            ,disp_good_id_array:disp_good_id_array
            ,orde_requ_quan_array:orde_requ_quan_array
            ,requ_deli_date_array:requ_deli_date_array
            ,good_name_array:good_name_array
    };
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/OrderRequestAddTransGrid.sys", 
        params,
        function(arg){ 
            if(fnAjaxTransResult(arg)) {    //성공시
                alert("주문요청이 성공적으로 완료되었습니다.");
                window.location.reload();
                
//              if(!confirm("발주접수 화면으로 이동하시겠습니까?")) {
//                  window.location.reload();
//              }else {
//                  $('#frm').attr('action','/order/purchase/purchaseList.sys');
//                  $('#frm').attr('Target','_self');
//                  $('#frm').attr('method','post');
//                  $('#frm').submit();
//              }
            }
        }
    );
}
function exportExcel() {
	var colLabels = ['상품명','상품규격','상품코드','공급사','단위','단가','주문수량','주문금액','표준납기일','납기희망일'];
	var colIds =['good_Name', 'good_Spec_Desc', 'good_Iden_Numb', 'vendorNm', 'orde_Clas_Code', 'sale_Unit_Pric', 'ord_Quan', 'total_Amout', 'stan_Deli_Day', 'deli_Mini_Day'];
	var numColIds = ['sale_Unit_Pric','ord_Quan','total_Amout'];
	var sheetTitle = "공급사_역주문";	//sheet 타이틀
	var excelFileName = "OrderRequestByVendor";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnChnageOrderUser(str){
	var tempUserId = str;
    $.post( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getUserInfoListByBranchId.sys',
            {borgId:$("#branchId").val()},
            function(arg){
                var userList = eval('(' + arg + ')').userList;
                for(var i=0;i<userList.length;i++) {
                    if(tempUserId == userList[i].userId){
                        $("#orde_tele_numb").val(userList[i].mobile);
                        $("#tran_user_name").val(userList[i].userNm);
                        $("#tran_tele_numb").val(userList[i].mobile);
                        $("#orde_userId").val(userList[i].userId);
                        fnSearchSupervisor();
                    }
                }      
            }
        );
}

function fnSearchSupervisor(){
    $.post( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/getSupervisorUserInfo.sys',
            {	
            	branchId:$("#branchId").val(),
            	userId:$("#orde_userId").val() 
            },
            function(arg){
                var userList = eval('(' + arg + ')').userList;
                if( 0 < userList.length){
                    $("#mana_user_name").val(userList[0].userNm);
                    $("#mana_user_id").val(userList[0].userId);
                }else{
                    $("#mana_user_name").val("");
                    $("#mana_user_id").val("");
                }
            }
        );
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//공급사 역주문
	header = "공급사 역주문";
	manualPath = "/img/manual/vendor/orderRequestByVendor.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<body>
   <form id="frm" name="frm" method="post">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>공급사역주문
                     <%if(isVendor){ %>
                        &nbsp;<span id="question" class="questionButton">도움말</span>
                     <%} %>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100" style="white-space:nowrap">구매사</td>
                     <td class="table_td_contents" colspan="3">
                        <input id="branchId" name="branchId" type="hidden" value=""/>
                        <input id="clientId" name="clientId" type="hidden" value=""/>
                        <input id="groupId"  name="groupId"  type="hidden" value=""/>
                        <input id="borgName" name="borgName" type="text" value="" size="" style="width: 590px;width:90%;" />
                        <img id="searchBorgBtn" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="22" height="22" style='border: 0;cursor: pointer;vertical-align:middle;' />
                        <input id="orde_userId" name="orde_userId" type="hidden"  value=""/>
                     </td>
                     <td class="table_td_subject" width="100" style="white-space:nowrap">주문자</td>
                     <td class="table_td_contents">
                        <select id="orde_user_id" name="orde_user_id" style="width: 150px;width:98%; " class="select" onchange="javascript:fnChnageOrderUser(this.value)">
                           <option value="">선택</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100" style="white-space:nowrap">공사명</td>
                     <td class="table_td_contents" colspan="3">
                        <input id="cons_iden_name" name="cons_iden_name" type="text" value="" size="" maxlength="250" style="width: 605px;width:98%;" />
                        <input id="orde_type_clas" name="orde_type_clas" type="hidden" value="" size="" maxlength="250"/>
                     </td>
                     <td class="table_td_subject" width="100" style="white-space:nowrap">인수자</td>
                     <td class="table_td_contents">
                        <input id="tran_user_name" name="tran_user_name" type="text" value="" size="20" maxlength="10"  style="width: 150px;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100" style="white-space:nowrap">비고</td>
                     <td class="table_td_contents" colspan="3">
                        <input id="orde_text_desc" name="orde_text_desc" type="text" value=""  maxlength="1000" style="width: 605px;width:98%; " />
                     </td>
                     <td class="table_td_subject" width="100" style="white-space:nowrap">인수자 전화번호</td>
                     <td class="table_td_contents">
                        <input id="tran_tele_numb" name="tran_tele_numb" type="text" value="" size="20" maxlength="11" style="width: 150px;" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100" style="white-space:nowrap">배송지 주소</td>
                     <td class="table_td_contents" colspan="5">
                        <select id="tran_deta_addr_seq" name="tran_deta_addr_seq" class="select" style="width: 605px">
                           <option value="" >선택</option>
                        </select>
                        <a href="javascript:void(0);">
                            <img id="btnAddDeliveryAddress" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style='border: 0; vertical-align: middle; height: 20px;' />
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" style="white-space:nowrap;width:12%;" width="120px">
                        <table>
                           <tr>
                              <td>첨부파일1</td>
                              <td>
                                 <a href="#">
                                 <img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                                 </a>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td class="table_td_contents" style="width: 22%;">
                        <input type="hidden" id="firstattachseq" name="firstattachseq" value=""/>
                        <input type="hidden" id="attach_file_path1" name="attach_file_path1" value=""/>
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
                        <span id="attach_file_name1"></span>
                        </a>
                     </td>
                     <td class="table_td_subject" style="white-space:nowrap; width:12%;" >
                        <table>
                           <tr>
                              <td>첨부파일2</td>
                              <td>
                                 <a href="#">
                                 <img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                                 </a>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td class="table_td_contents" style="width: 21%;">
                        <input type="hidden" id="secondattachseq" name="secondattachseq" value=""/>
                        <input type="hidden" id="attach_file_path2" name="attach_file_path2" value=""/>
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
                        <span id="attach_file_name2"></span>
                        </a>
                     </td>
                     <td class="table_td_subject" style="white-space:nowrap;width:12%;" >
                        <table>
                           <tr>
                              <td>첨부파일3</td>
                              <td>
                                 <a href="#">
                                 <img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                                 </a>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td class="table_td_contents" style="width: 21%;">
                        <input type="hidden" id="thirdattachseq" name="thirdattachseq" value=""/>
                        <input type="hidden" id="attach_file_path3" name="attach_file_path3" value=""/>
                        <a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
                        <span id="attach_file_name3"></span>
                        </a>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
               </table>
            </td>
         </tr>
         <tr>
            <td>&nbsp;</td>
         </tr>
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%"  border="0" cellpadding="0" cellspacing="0" style="height: 27px">
                  <tr>
                     <td align="right" class="stitle">
                        <a href="javascript:void(0);">
                           <img id="btnSearchProduct" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_goodsSearch.gif" style='border: 0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
                        </a>
                        <a href="javascript:void(0);">
                           <img id="orderRequestButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_order.gif" style='border: 0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
                        </a>
                        <a href="javascript:void(0);">
                           <img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15"
                              style='border: 0;' />
                        </a>
                        <a href="javascript:void(0);">
                           <img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15"
                              style='border: 0;' />
                        </a>
                        <a href="javascript:void(0);">
                           <img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;'/>
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
      </table>
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>상품검색을 통해 주문요청할 상품을 선택해주십시오.</p>
      </div>
<%--       <%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp"%> --%>
   </form>
</body>
</html> 