<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmPastProductWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 650px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmPastProductWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	// Dialog Init
	$('#pastProductDialogPop').jqm(); 
	$('#pastProductDialogPop').jqm().jqDrag('#pastProductDialogHandle');
	
	// Componet Event 등록  
 	$("#btnCloseDiv").click(function(){ $('#pastProductDialogPop').jqmHide();});
 	$("#btnPastOrderRequest").click(function(){ fnPastOrderRequest(); });
});

function fnOpenPastProductInfoDial(){
	$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/product/getPastProductDetailForBuyer.sys",
			{disp_good_id:$('#disp_good_id').val()
			,comp_branchid:$('#branchId').val()},
			function(arg){ 
				if(fnTransResult(arg, false)){
					var pastProductDetailInfo = eval('(' + arg + ')').pastProductDetailInfo;
					var pastProductPriceInfo  = eval('(' + arg + ')').pastProductPriceInfo;
					
					var good_name        = pastProductDetailInfo.good_name     ;
					var good_spec_desc   = pastProductDetailInfo.good_spec_desc;
					var borgnm           = pastProductDetailInfo.borgnm        ;
					var pressentnm       = pastProductDetailInfo.pressentnm    ;
					var areatypenm       = pastProductDetailInfo.areatypenm    ;

					$('#past_good_name').html(good_name);
					$("#past_borgnm").html(borgnm);
					$('#past_pressentnm').html(pressentnm);
					$('#past_areatypenm').html(areatypenm);
					fnSetDivPordSpecComponet(good_spec_desc);
					$('#past_ord_quan').val(pastProductDetailInfo.deli_mini_quan);
					$('#org_past_ord_quan').val(pastProductDetailInfo.deli_mini_quan);
					$('#branchNms').val(pastProductDetailInfo.comp_iden_name);
					$("#past_disp_good_id").find('option').remove();
					for(var idx=0; idx < pastProductPriceInfo.length ; idx++){
						//var selectText = "매입가:"+$.number(pastProductPriceInfo[idx].sale_unit_pric) + "|| 판매가:"+$.number(pastProductPriceInfo[idx].sell_price);
						var selectText = "판매가:"+$.number(pastProductPriceInfo[idx].sell_price);
						$("#past_disp_good_id").append("<option value='"+pastProductPriceInfo[idx].disp_good_id+"'>"+selectText+"</option>");
					}
				}
			}
		);
	$.post(	//조회조건의 권역세팅
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getDeliveryAddressByBranchId.sys',
			{groupId:$("#groupId").val(),clientId:$("#clientId").val(),branchId:$("#branchId").val()},
			function(arg){
				var deliveryListInfo = eval('(' + arg + ')').deliveryListInfo;
				$("#tran_deta_addr_seq").html('');
				for(var i=0;i<deliveryListInfo.length;i++) {
					$("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"'  >"+deliveryListInfo[i].shippingaddres+"</option>");
				}		
			}
		);
	$("#pastProductDialogPop").jqmShow();
}

//상품 규격 컨퍼넌트 만들기 
function fnSetDivPordSpecComponet(arg){
	var prodSpcNm = new Array();
	// 품목 규격 property 추출 
   <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
		prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
   <% }                                                                       %>

	var argArray = arg.split("‡");
	var prodSpec = ""; 
	for(var idx = 0 ; idx < argArray.length ; idx ++ ) {
		if(argArray[idx] > " ") {
			 prodSpec += "\n	<table>                                                                                                                      		 ";
	         prodSpec += "\n	<tr>                                                                                                                      			 ";
	         prodSpec += "\n 		<td width='320px' class='dv_td_contents3'>"+prodSpcNm[idx]+" : "+argArray[idx]+"</td>                                            ";
	         prodSpec += "\n 	</tr>                                                                                                                                ";
	         prodSpec += "\n	</table>                                                                                                                      		 ";
		}
	}
	
	$('#past_prodSpec').html(prodSpec);
}

// 과거상품 주문 
function fnPastOrderRequest() {
	var groupid            = $("#groupId ").val(); 		  					// 그룹 ID
	var clientid           = $("#clientId").val();		  	    			// 법인 ID 
	var branchid           = $("#branchId").val();		  	    			// 사업장 ID
	var cons_iden_name     = $("#branchNms").val()+' 과거주문';	    		// 주문명
	var orde_type_clas     = "50";		  									// 주문유형
	var orde_tele_numb     = '';							    			// 주문자 전화번호
	var orde_user_id       = $("#orde_user_id").val(); 						// 주문자 ID
	var tran_data_addr     = $("#tran_deta_addr_seq").val();				// 배송지주소
	var tran_user_name     = "";							    			// 인수자  $("#tran_user_name").val();
	var tran_tele_numb     = "";	    									// 인수자 전화번호 $("#tran_tele_numb").val();
	var adde_text_desc     = "";		  									// 비고
	var mana_user_name     = "";	    									// 감독명 
	var attach_file_1      = "";											// 첨부파일1
	var attach_file_2      = "";											// 첨부파일2
	var attach_file_3      = "";											// 첨부파일3
	var disp_good_id_array   = new Array();									// 진열 SEQ
	var orde_requ_quan_array = new Array();									// 주문수량
	var requ_deli_date_array = new Array();									// 납품요청일
	var good_name_array = new Array();									// 상품명
	
	//var org_past_ord_quan  = $("#org_past_ord_quan").val();                 // 최소 구매수량        
	
	if(	Number($("#org_past_ord_quan").val().replace(/,/g , ""))	>	Number($('#past_ord_quan').val().replace(/,/g , ""))		) {
	    alert('최소 주문수량 ['+$('#org_past_ord_quan').val()+'] 보다 작은 주문은 할수 없습니다!' ); 
	    return 
	}
	
// 	if($.trim(orde_user_id) == "" ) {
// 		$('#past_dialogSelectRow').html('<p>주문자정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
// 		$( "#past_dialogSelectRow" ).dialog();
// 		alert('<p>주문자정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>'); 
// 		$("#orde_user_id").focus();
// 		return;
// 	}

// 	if($.trim(tran_user_name) == "" ) {
// // 		$('#past_dialogSelectRow').html('<p>인수자정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
// // 		$( "#past_dialogSelectRow" ).dialog();
// 		alert('<p>인수자정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
// 		$("#tran_user_name").focus();
// 		return;
// 	}
	
// 	if($.trim(tran_tele_numb) == "" ) {
// // 		$('#past_dialogSelectRow').html('<p>인수자 연락처는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
// // 		$( "#past_dialogSelectRow" ).dialog();
// 		alert('<p>인수자 연락처는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
// 		$("#tran_tele_numb").focus();
// 		return;
// 	}
	
	if($.trim(tran_data_addr) == "" ) {
// 		$('#past_dialogSelectRow').html('<p>배송지 정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
// 		$( "#past_dialogSelectRow" ).dialog();
		alert('<p>배송지 정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#tran_deta_addr_seq").focus();
		return;
	}
	
	if(!confirm("해당 상품을 주문요청 하시겠습니까?")){ return; }

	disp_good_id_array.push($('#past_disp_good_id').val());
	orde_requ_quan_array.push($('#past_ord_quan').val());
	requ_deli_date_array.push('');
	good_name_array.push('');
	
	var msg = ""; 
	msg += "\n 그룹 ID        value ["+groupid             +"]"; 
	msg += "\n 법인 ID        value ["+clientid            +"]"; 
	msg += "\n 사업장 ID       value ["+branchid            +"]"; 
	msg += "\n 주문명             	value ["+cons_iden_name      +"]"; 
	msg += "\n 주문유형       		value ["+orde_type_clas      +"]"; 
	msg += "\n 주문자 전화번호 	value ["+orde_tele_numb      +"]"; 
	msg += "\n 주문자 ID       value ["+orde_user_id        +"]"; 
	msg += "\n 배송지주소      	value ["+tran_data_addr      +"]"; 
	msg += "\n 인수자          		value ["+tran_user_name      +"]"; 
	msg += "\n 인수자 전화번호 	value ["+tran_tele_numb      +"]"; 
	msg += "\n 비고            		value ["+adde_text_desc      +"]"; 
	msg += "\n 감독명          		value ["+mana_user_name      +"]"; 
	msg += "\n 첨부파일1       value ["+attach_file_1       +"]"; 
	msg += "\n 첨부파일2       value ["+attach_file_2       +"]"; 
	msg += "\n 첨부파일3       value ["+attach_file_3       +"]"; 
	msg += "\n 진열 SEQ       value ["+disp_good_id_array  +"]"; 
	msg += "\n 주문수량        		value ["+orde_requ_quan_array+"]"; 
	msg += "\n 납품요청일      	value ["+requ_deli_date_array+"]"; 
	//alert(msg); 
	
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
			if(fnTransResult(arg, true)) {	//성공시
				alert("과거상품 주문요청이 성공적으로 완료되었습니다.");
				
				var svcTypeCd = $('#svcTypeCd').val();
				if(svcTypeCd == 'ADM'){
				    if(confirm("주문조회 화면으로 이동하시겠습니까?")) {
				        fnGoOrderList();
						window.dialogArguments.fnGoOrderList();
					}   
				}else {
				    if(confirm("주문리스트 화면으로 이동하시겠습니까?")) {
						window.dialogArguments.fnGoOrderList();
					}    
				}
				
				window.close();
			}
		}
	);
	
} 

</script>


<title>과거상품가격정보</title>
</head>
<body>
   <div class="jqmPastProductWindow" id="pastProductDialogPop">
      <table width="650" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <div id="pastProductDialogHandle">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                     <tr>
                        <td width="21">
                           <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
                        </td>
                        <td width="22">
                           <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom: 5px" />
                        </td>
                        <td class="popup_title">과거상품주문</td>
                        <td width="22" align="right">
                           <a href="#" class="jqmClose">
                              <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom: 5px;" />
                           </a>
                        </td>
                        <td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
                     </tr>
                  </table>
               </div>
               <table width="100%" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                     <td width="20" height="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" />
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
                     <td width="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" />
                     </td>
                  </tr>
                  <tr>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                     <td valign="top" bgcolor="#FFFFFF">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td colspan="6" class="table_top_line"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject" >상품명 </td>
                              <td class="table_td_contents" colspan="5" id="past_good_name"></td>
                           </tr>
                           <tr>
                              <td colspan="6" height='1' bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">상품규격 </td>
                              <td class="table_td_contents" colspan="5" id="past_prodSpec"></td>
                           </tr>
                           <tr>
                              <td colspan="6" height='1' bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject" width="60px" >공급사</td>
                              <td class="table_td_contents" id="past_borgnm"></td>
                              <td class="table_td_subject" width="40px"  >대표자</td>
                              <td class="table_td_contents" id="past_pressentnm"> </td>
                              <td class="table_td_subject" width="40px" >권역 </td>
                              <td class="table_td_contents" id="past_areatypenm"> </td>
                           </tr>
                           <tr>
                              <td colspan="6" height='1' bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">가격정보 </td>
                              <td class="table_td_contents" colspan="5">
                                 <select id="past_disp_good_id">
                                    <option value="">선택</option>
                                 </select>
                              </td>
                           </tr>
                           <tr>
                              <td colspan="6" height='1' bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">주문수량 </td>
                              <td class="table_td_contents" colspan="5">
                                <input type="hidden" id="org_past_ord_quan" name="org_past_ord_quan" value="" />
                                 <input type="text" name="past_ord_quan" id="past_ord_quan" maxlength="6" style="text-align: right;width: 50px;" onkeydown="return onlyNumber(event);" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="6" height='1' bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">배송지주소 </td>
                              <td class="table_td_contents" colspan="5">
                                 <select id="tran_deta_addr_seq"></select>
                                 <a href="javascript:void(0);">
                                    <img id="btnAddDeliveryAddress" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style='border:0;vertical-align:middle;height:20px;'/>
                                 </a>
                              </td>
                           </tr>
                           <tr>
                              <td colspan="6" height='1' bgcolor="eaeaea"></td>
                           </tr>
<!--                            <tr> -->
<!--                               <td class="table_td_subject">인수자</td> 123 -->
<!--                               <td class="table_td_contents"> -->
<!--                                  <input type="text" id="tran_user_name" name="tran_user_name" maxlength="10" value="" /> -->
<!--                               </td> -->
<!--                               <td class="table_td_subject" width="40px"  >인수자 연락처</td> -->
<!--                               <td class="table_td_contents" colspan="3"> -->
<!--                                  <input type="text" id="tran_tele_numb" name="tran_tele_numb" maxlength="13" value="" /> -->
<!--                               </td> -->
<!--                            </tr> -->
<!--                            <tr> -->
<!--                               <td colspan="6" height='1' bgcolor="eaeaea"></td> -->
<!--                            </tr> -->
<!--                            <tr> -->
<!--                               <td colspan="6" height="5"></td> -->
<!--                            </tr> -->
                        </table>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td align="center">
                                 <a href="#">
                                 </a>
                              </td>
                           </tr>
                        </table>
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space" />
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td align="center">
                                 <a href="#">
                                    <img id="btnPastOrderRequest" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_order.gif" style='border: 0;' />
                                 </a>
                                 &nbsp;
                                 <a href="#">
                                    <img id="btnCloseDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style='border: 0;' />
                                 </a>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                  </tr>
                  <tr>
                     <td>
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" />
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                     <td height="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" />
                     </td>
                  </tr>
               </table>
            </td>
         </tr>
      </table>
   </div>
   <div id="past_dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>장바구니 등록시 수량을 입력하셔야 합니다.</p>
   </div>
</body>
</html>