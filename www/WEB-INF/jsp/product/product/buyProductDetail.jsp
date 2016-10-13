<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.product.dto.BuyProductDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="kr.co.bitcube.common.dto.BorgDto"%>
<%@ page import="java.util.List"%>
<%
   @SuppressWarnings("unchecked")
   List<ActivitiesDto> roleList  = (List<ActivitiesDto>) request.getAttribute("useActivityList");              // 화면권한가져오기(필수)
   String disp_good_id           = (String) request.getAttribute("disp_good_id");
   String isEdit                 = (String) request.getAttribute("isEdit");
   LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    boolean isBuilder = false;
    for(LoginRoleDto lrd: loginUserDto.getLoginRoleList()){
        if("BUY_BUILDER".equals(lrd.getRoleCd())){
            isBuilder = true;
        }
    }
    
    //운영사만 과거주문 상품을 볼 수 있도록 추가
	boolean isAdmin = false;
	List<BorgDto> belongBorgList = loginUserDto.getBelongBorgList();
	for(BorgDto borgDto:belongBorgList) {
		if("ADM".equals(borgDto.getSvcTypeCd())) {
			isAdmin = true;
			break;
		}
	}
//     for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {
//  	   System.out.println("Constances.PROD_GOOD_SPEC value ["+Constances.PROD_GOOD_SPEC[idx]+"]");
//     }
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<style type="text/css">
	div#prodDesc img {
	display:block;
	width:900px;
}
</style>
<!-- 초기화 스크립트 -->                                                                                                                                                                   
<script type="text/javascript">                    
var jq = jQuery;                                   
$(document).ready(function() {       
	
	// 이벤트 등록 
	$("#addCartBtn").click( function() { fnAddCart(); });
	$("#closeBtn").click( function() { window.close(); });
	
	$("#openDetailViewBtn").click(function() {	$("#prodDesc").css({"display": "inline"});	});
	$("#closeDetailViewBtn").click(function() {	$("#prodDesc").css({"display": "none"});	});
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH%>/product/getProductDetailForBuyer.sys",
		{disp_good_id:'<%=disp_good_id%>'},
		function(arg){ 
			if(fnTransResult(arg, false)){
				var productDetailInfo = eval('(' + arg + ')').productDetailInfo;
				
				var disp_good_id      = productDetailInfo.disp_good_id     ;
				var good_name         = productDetailInfo.good_name        ;
				var good_iden_numb    = productDetailInfo.good_iden_numb   ;
				var borgnm            = productDetailInfo.borgnm+" (Tel."+productDetailInfo.phonenum+")";
				var good_st_spec_desc = productDetailInfo.good_st_spec_desc;
				var good_spec_desc    = productDetailInfo.good_spec_desc   ;
				var orde_clas_code    = productDetailInfo.orde_clas_code   ;
				var sell_price        = productDetailInfo.sell_price       ;
				var ord_unit_cnt      = productDetailInfo.ord_unit_cnt     ;
				var ord_quan          = productDetailInfo.ord_quan         ;
				var ord_unlimit_quan  = productDetailInfo.ord_unlimit_quan ;
				var total_amout       = productDetailInfo.total_amout      ;
				var stand_order_date  = productDetailInfo.stand_order_date ;
				var original_img_path = productDetailInfo.original_img_path;
				var make_comp_name    = productDetailInfo.make_comp_name   ;
				var deli_mini_day     = productDetailInfo.deli_mini_day    ;
				var deli_mini_quan    = productDetailInfo.deli_mini_quan   ;
				var good_desc         = productDetailInfo.good_desc        ;
				var majo_code_name    = productDetailInfo.majo_code_name   ;
				var full_cate_name    = productDetailInfo.full_cate_name   ;
				var isUse             = productDetailInfo.isUse            ;
				var isdisppastgood    = productDetailInfo.isdisppastgood   ; 
				var final_good_sts    = productDetailInfo.final_good_sts   ;
				
				
				sell_price = eval(sell_price);
				
				$('#disp_good_id').val(disp_good_id);
				$("#good_name").html(good_name); 
				$("#good_iden_numb").html(good_iden_numb);
				//if(productDetailInfo.isDistribute=="0") {	//10000005902 상품에 대해서 물량배분을 해도 공급사가 보이도록 설정해 달라고 함(진영준대리 요청 20150805)
				if(productDetailInfo.isDistribute=="0" || (productDetailInfo.isDistribute!='0' && productDetailInfo.is_add_good=='1')) {
					$("#borgnm").html(borgnm);
				} else {
					$("#borgnm").html('SK텔레시스&nbsp;&nbsp;<font color="blue">'+productDetailInfo.product_manager+'</font>');
				}
				$("#orde_clas_code").html(orde_clas_code);
				$("#sell_price").html(sell_price);
				$("#make_comp_name").html(make_comp_name);
				$("#deli_mini_day").html(deli_mini_day);
				$("#deli_mini_quan").html(deli_mini_quan);
				$("#ord_quan").val(deli_mini_quan);
				$("#majo_code_name").html(majo_code_name);
				$("#full_cate_name").html(full_cate_name);
				$("#prodDesc").html(unescape(good_desc));
				$('#isUse').val(isUse); 
				
				if(original_img_path > ' ') {
				    $("#prodView").attr("src",'<%=Constances.SYSTEM_IMAGE_URL%>/upload/image/'+original_img_path);
				    $("#prodViewLink").attr("href",'<%=Constances.SYSTEM_IMAGE_URL%>/upload/image/'+original_img_path);
				}
				//운영사만 과거 상품 주문할 수 있도록 isAdmin 추가 수정
				if(isdisppastgood != '0' && <%= isAdmin%>){
					$('#pastProductInfo').show(); 
				}
				
				// 주문카트담기 Button
				if('<%=isEdit%>' == 'N') {
					$('#addCartBtn').hide();
				}
				
				// 진열상태_최종상품여부
				if(final_good_sts != '1' ) {
					$('#addCartBtn').hide();
				} 
				
				
				fnSetPordSpecComponet(good_st_spec_desc, good_spec_desc); 
				fnGetOnlyNumeric();
				fnCheackIsUseSts(); 
			}
		}
	);
});

// 종료 여부 처리 
function fnCheackIsUseSts(){
    var isUse = $('#isUse').val(); 
    
    // 종료 품목인경우 
    if(isUse == '0'){
        $("#good_name").append("<font color='red'>(종료상품)</font>");    
        $('#pastProductInfo').hide();
        $('#addCartBtn').hide();
    }
}

// 상품 규격 컨퍼넌트 만들기
function fnSetPordSpecComponet(arg, arg2){
	var prodStSpcNm = new Array();
	<% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
        prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
    <% } %>
	
	// 품목 규격 property 추출
	var prodSpcNm = new Array();
    <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
		prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
    <% }                                                                       %>

    // 규격 화면 로드
    var argStArray = arg.split("‡");
	var argArray = arg2.split("‡");
	var prodStSpec = "";
	var prodSpec = "";
	var prodImgPath = '<%=Constances.SYSTEM_IMAGE_URL%>';
	for(var stIdx = 0 ; stIdx < argStArray.length ; stIdx ++ ) {
        if(argStArray[stIdx] > ' ') {
            prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
        }
    }
	
	prodSpec += "\n    <table>";
	if(prodStSpec.length > 0) {
        prodSpec += "\n    <tr>                                                                                                                                      ";
        prodSpec += "\n        <td colspan='2' width='390px' class='dv_td_contents3'>                                                                                ";
        prodSpec += "\n            <img src='"+ prodImgPath +"/img/system/detailView_bullet_01.gif' width='6' height='11' /><font color='red'>"+prodStSpec.substring(0,prodStSpec.length-3)+"</font>  ";
        prodSpec += "\n        </td>                                                                                                                                 ";                
        prodSpec += "\n    </tr>                                                                                                                                     ";
    }
    for(var idx = 0 ; idx < argArray.length ; idx ++ ) {//456
        if(argArray[idx] > " ") {
            if(idx == 0 ) {
                prodSpec += "\n    <tr>                                                                                                                                      ";
                prodSpec += "\n        <td colspan='2' width='390px' class='dv_td_contents3'>                                                                                ";
                prodSpec += "\n            <img src='"+ prodImgPath +"/img/system/detailView_bullet_01.gif' width='6' height='11' />"+argArray[idx]                           ;
                prodSpec += "\n        </td>                                                                                                                                 ";                
                prodSpec += "\n    </tr>                                                                                                                                     ";
			} else {
                prodSpec += "\n    <tr>                                                                                                                                 ";
	            prodSpec += "\n        <td width='70px' class='dv_td_contents3'>                                                                                        ";
	            prodSpec += "\n            <img src='"+ prodImgPath +"/img/system/detailView_bullet_01.gif' width='6' height='11' />"+prodSpcNm[idx]  ;
	            prodSpec += "\n        </td>                                                                                                                            ";
	            prodSpec += "\n        <td width='320px' class='dv_td_contents3'>: "+argArray[idx]+"</td>                                                               ";
	            prodSpec += "\n    </tr>                                                                                                                                ";				
			}
		}
	}
    prodSpec += "\n    </table>";
    document.getElementById("prodSpec").innerHTML = prodSpec;
    
// 	$('#prodSpec').html(prodSpec);
}
// 숫자 표기 포맷 이벤트 
function fnGetOnlyNumeric(){
	 $("#sell_price").html($.number($("#sell_price").html().replace(/,/g , "")));
	 $("#deli_mini_quan").html($.number($("#deli_mini_quan").html().replace(/,/g , "")));
}

//선택 버튼 클릭시 발생 이벤트 
function fnAddCart(){
	
	if($('#ord_quan').val() == "" ){
		$('#dialogSelectRow').html('<p>장바구니 등록시 수량은 필수 입니다. \n확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog();
		return; 
	}
	
	
	if( parseInt($('#ord_quan').val()) < parseInt($("#deli_mini_quan").html())){
		$('#dialogSelectRow').html('<p>최소 주문수량보다 작은 주문수량은 등록 불가합니다. \n확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog();
		return; 
	}
	
	var disp_good_id_Array = new Array(); 
	var ord_quan_Array = new Array (); 
	
	disp_good_id_Array.push($('#disp_good_id').val()); 
	ord_quan_Array.push($('#ord_quan').val());
	
	if(!confirm("장바구니에 담으시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/cart/addProductInCartTransGrid.sys",
		
		{  disp_good_id_Array:disp_good_id_Array
		 , ord_quan_Array:ord_quan_Array
		}
		,function(arg){ 
			if(fnTransResult(arg, false)) {	//성공시
				if(confirm("장바구니에 등록 되었습니다. \n 장바구니 페이지로 이동하시겠습니까?")) {
					opener.fnGoCartPage();
				}
				self.close();
// 				if(confirm("장바구니에 등록 되었습니다. \n 장바구니 페이지로 이동하시겠습니까?")) {
// 					dialogArguments.fnGoCartPage();
// 				}
// 				top.close();
			}
		}
	);
}


</script>
<%
/**------------------------------------ 과거상품 검색 팝업 시작 ---------------------------------
* fnOpenPastProductInfoDial() 을 호출하여 Div팝업을 Display ===
*/
%>
<%@ include file="/WEB-INF/jsp/product/product/buyPastProductInfo.jsp" %>
<!-- 과거 상품 검색 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
   $('#pastProductInfo').click(function(){
         fnOpenPastProductInfoDial(); 
      });
});
</script>

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
         $('#dialogSelectRow').dialog();
         return; 
      }
      
      fnDeliveryAddressManageDialog($('#groupId').val(), $('#clientId').val() , $('#branchId').val() ,"fnCallBackDeliveryAddressManage"); 
   });
});
/**
 * 배송지관리팝업검색 후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressManage() {
   fnGetBuyAddressInfo();
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
         $("#tran_deta_addr_seq").html('');
         for(var i=0;i<deliveryListInfo.length;i++) {
            if(deliveryListInfo[i].isdefault == "1") 
               $("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"' selected >"+deliveryListInfo[i].shippingaddres+"</option>");
            else
               $("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"'>"+deliveryListInfo[i].shippingaddres+"</option>");
         }
      }
   );
}
</script>
<% //------------------------------배송지관리팝업 종료 ----------------------------------- %>

<title>Insert title here</title>
</head>
<body>
<div style="position:absolute;width:980px;height:700px;overflow:auto;" align="center">
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
         <td>
            <input type="hidden" name="disp_good_id" id="disp_good_id" value="" />
            <input type="hidden" name="isUse" id="isUse" value="" />
            
            <!-- 타이틀 시작 -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr valign="top">
                  <td width="20" valign="middle">
                     <input type="hidden" id="groupId"   name="groupId"    value="<%=loginUserDto.getGroupId() %>" />
                     <input type="hidden" id="clientId"  name="clientId"   value="<%=loginUserDto.getClientId() %>" />
                     <input type="hidden" id="branchId"  name="branchId"   value="<%=loginUserDto.getBorgId() %>" />
                     <input type="hidden" id="branchNms" name="branchNms"  value="<%=loginUserDto.getBorgNms() %>" />
                     <input type="hidden" id="orde_user_id"  name="orde_user_id"   value="<%=loginUserDto.getUserId() %>" />
                     <input type="hidden" id="svcTypeCd" name="svcTypeCd" value="<%=loginUserDto.getSvcTypeCd()%>" />
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                  </td>
                  <td height="29" class='ptitle'>상품상세</td>
               </tr>
            </table>
            <!-- 타이틀 끝 -->
         </td>
      </tr>
      <tr>
         <td>
            <!-- 타이틀 시작 -->
            <table width="100%"  border="0" cellpadding="0" cellspacing="0" style="height: 27px">
               <tr>
                  <td width="20" valign="top">
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                  </td>
                  <td class="stitle blue2" id="majo_code_name"></td>
               </tr>
            </table>
            <!-- 타이틀 끝 -->
         </td>
      </tr>
      <tr>
         <td class="table_top_line"></td>
      </tr>
      <tr>
         <td>&nbsp;</td>
      </tr>
      <tr>
         <td align="center">
            <!-- 컨텐츠 시작 -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
                  <td width="360" height="5"></td>
                  <td width="573" height="5"></td>
               </tr>
               <tr>
                  <td width="360" align="center">
                     <!--상품확대이미지 시작-->
                     <table width="236" border="0" cellpadding="0" cellspacing="3" bgcolor="#b0c2cf">
                        <tr>
                           <td align="center" bgcolor="#FFFFFF">
                              <a id="prodViewLink" href="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_p_none.gif" target="_blank">
                                <img id="prodView" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_p_none.gif" width="236" height="235" border="0" />
                              </a>
                           </td>
                        </tr>
                     </table>
                     <!--상품확대이미지 끝-->
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="6px" />
                     <!-- 과거상품 주문여부 -->
                     <img id="pastProductInfo" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_pastSearch.gif" width="80" height="22" border="0" style="cursor: pointer; display: none;" />
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="6px" />
                     <!--요약정보 시작-->
<!--                      <table width="239" border="0" cellspacing="0" cellpadding="0"> -->
<!--                         <tr> -->
<!--                            <td colspan="2"> -->
<%--                               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_01.gif" width="239" height="7" /> --%>
<!--                            </td> -->
<!--                         </tr> -->
<!--                         <tr> -->
<%--                            <td width="67" valign="top" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_02-2.gif);"> --%>
<%--                               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_02.gif" width="67" height="14" /> --%>
<!--                            </td> -->
<%--                            <td width="172" valign="top" class="dv_td_contents" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_03.gif);">요약정보 테스트 입니다. 감사합니다. 텍스트 내용이 길어지면 자동으로 테이블 높이가 늘어나게됩니다.</td> --%>
<!--                         </tr> -->
<!--                         <tr> -->
<!--                            <td colspan="2"> -->
<%--                               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_04.gif" width="239" height="7" /> --%>
<!--                            </td> -->
<!--                         </tr> -->
<!--                      </table> -->
                     <!--요약정보 끝-->
                  </td>
                  <td width="573">
                     <table width="573" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td colspan="3">
                              <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_05.gif" width="573" height="13" />
                           </td>
                        </tr>
                        <tr>
                           <td width="13" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_06.gif);">&nbsp;</td>
                           <td width="544">
                              <!--상세정보 시작-->
                              <table width="544" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_01.gif" alt="분류" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents bold" id="full_cate_name"></td>
                                 </tr>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_02.gif" alt="상품명" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents" id="good_name"></td>
                                 </tr>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_12.gif" alt="상품코드" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents bold" id="good_iden_numb"></td>
                                 </tr>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_13.gif" alt="공급사명" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents" id="borgnm" name="borgnm"></td>
                                 </tr>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 <tr>
                                    <td width="122" valign="top">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_05.gif" alt="대표규격" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents">
                                       <table width="400" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                             <td>
                                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_09.gif" width="400" height="7" />
                                             </td>
                                          </tr>
                                          <tr>
                                             <td align="center" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_10.gif);">
                                                <!--대표규격 시작-->
                                                <span id="prodSpec"></span>
                                                
<!--                                                 <table width="390" border="0" cellspacing="0" cellpadding="0" id="prodSpec" name="prodSpec"> -->
<!--                                                    <tr> -->
<!--                                                       <td width="70px" class="dv_td_contents3"> -->
<%--                                                          <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_bullet_01.gif" width="6" height="11" />대표규격 --%>
<!--                                                       </td> -->
<!--                                                       <td width="320px" class="dv_td_contents3">: KM-NO.1</td> -->
<!--                                                    </tr> -->
<!--                                                    <tr> -->
<!--                                                       <td width="70px" class="dv_td_contents3"> -->
<%--                                                          <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_bullet_01.gif" width="6" height="11" />대표규격 --%>
<!--                                                       </td> -->
<!--                                                       <td width="320px" class="dv_td_contents3">: KM-NO.1</td> -->
<!--                                                    </tr> -->
<!--                                                    <tr> -->
<!--                                                       <td width="70px" class="dv_td_contents3"> -->
<%--                                                          <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_bullet_01.gif" width="6" height="11" />대표규격 --%>
<!--                                                       </td> -->
<!--                                                       <td width="320px" class="dv_td_contents3">: KM-NO.1</td> -->
<!--                                                    </tr> -->
<!--                                                 </table> -->
                                                <!--대표규격 끝-->
                                             </td>
                                          </tr>
                                          <tr>
                                             <td>
                                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_11.gif" width="400" height="7" />
                                             </td>
                                          </tr>
                                       </table>
                                       <!--대표규격 끝-->
                                    </td>
                                 </tr>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_06.gif" alt="제조원" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents" id="make_comp_name">&nbsp;</td>
                                 </tr>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 
                                 
                                 
                                 
                                 
<!--                                  <tr> -->
<!--                                     <td width="122"> -->
<%--                                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_07.gif" alt="원산지" width="122" height="26" /> --%>
<!--                                     </td> -->
<!--                                     <td width="422" class="dv_td_contents">대한민국</td> -->
<!--                                  </tr> -->
<!--                                  <tr class="dv_td_line"> -->
<!--                                     <td width="122"></td> -->
<!--                                     <td width="422"></td> -->
<!--                                  </tr> -->




                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_08.gif" alt="표준납기일" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents" id="deli_mini_day">&nbsp;일</td>
                                 </tr>
                                 <tr class="dv_td_line2">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
 <%if(!isBuilder){%>                                
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_09.gif" alt="단가" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents2 blue bold" id="sell_price">원</td>
                                 </tr>
<%}else{%>
                                 <input type="hidden" id="sell_price" value=""/>
<%}%>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_10.gif" alt="최소주문수량" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents2" id="deli_mini_quan"></td>
                                 </tr>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_14.gif" alt="주문수량" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents2">
                                       <input type="text" class="number" name="ord_quan" id="ord_quan" value="" style="width: 60px;text-align: right;ime-mode:disabled;" maxlength="8" onkeyPress="if ((event.keyCode<48) || (event.keyCode>57)) event.returnValue=false;fnGetOnlyNumeric();" />
                                    </td>
                                 </tr>
                                 <tr class="dv_td_line">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                                 <tr>
                                    <td width="122">
                                       <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_txt_11.gif" alt="주문단위" width="122" height="26" />
                                    </td>
                                    <td width="422" class="dv_td_contents2" id="orde_clas_code"></td>
                                 </tr>
                                 <tr class="dv_td_line3">
                                    <td width="122"></td>
                                    <td width="422"></td>
                                 </tr>
                              </table>
                              <!--상세정보 끝-->
                              <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="6px" />
                           </td>
                           <td width="16" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_07.gif);">&nbsp;</td>
                        </tr>
                        <tr>
                           <td colspan="3">
                              <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_tbl_img_08.gif" width="573" height="13" />
                           </td>
                        </tr>
                     </table>
                  </td>
               </tr>
               <tr>
                  <td width="360">&nbsp;</td>
                  <td width="573" align="left" valign="bottom">
                     <table width="573" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td>
                              <a href="javascript:void(0);" onfocus="this.blur()">
                                 <img id='openDetailViewBtn' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_open.gif" width="99" height="27" border="0" />
                              </a>
                              <a href="javascript:void(0);" onfocus="this.blur()">
                                 <img id='closeDetailViewBtn' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_close2.gif" width="99" height="27" border="0" />
                              </a>
                           </td>
                           <td height="35" align="right" style="padding-right: 5px">
                              <a href="#">
                                 <img id="addCartBtn" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_cart.gif" width="92" height="26" border="0" />
                                 <img id="closeBtn" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/detailView_close.gif" width="65" height="26" hspace="0" border="0" />
                              </a>
                           </td>
                        </tr>
                     </table>
                  </td>
               </tr>
            </table>
            <!-- 컨텐츠 끝 -->
         </td>
      </tr>
      <tr>
         <td>&nbsp;</td>
      </tr>
      <tr>
         <td class="table_top_line"></td>
      </tr>
      <tr>
         <td>&nbsp;</td>
      </tr>
      <tr>
         <td>
            <div id="prodDesc" style="display: inline;"></div>
         </td>
      </tr>
   </table>
</div>
   
   <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>장바구니 등록시 수량을 입력하셔야 합니다.</p>
   </div>
   <div id="dialog" title="Feature not supported" style="display:none;">
      <p>That feature is not supported.</p>
   </div>
</body>
</html>