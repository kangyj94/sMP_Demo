<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%
	//날짜 세팅
	String contractStartDateDiv = CommonUtils.getCurrentDate();
	String contractEndDateDiv = CommonUtils.getCustomDay("DAY", +365);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmProductSalePriceWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 560px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmProductSalePriceWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
   $('#productSalePriceDialogPop').jqm(); 
   $('#productSalePriceDialogPop').jqm().jqDrag('#productSalePriceDialogHandle');
   
   $("#btnBuyBorgDiv").click(function() { fnPrePareForSearchBorg();  });
   $("#srcBorgNameDiv").keydown(function(e) { if(e.keyCode==13) { $("#btnBuyBorgDiv").click(); } });
   $("#srcBorgNameDiv").change(function(e) { fnBuyBorgInit(); });
   //$("#selectVendorDiv").change(function() { fnVendorInit(); });
   $("#productSalePriceSaveButton").click(function(){ fnDisplayGoodTrans(); });
   $("#jqmClose").click(function() { $("#productSalePriceDialogPop").jqmHide(); });
   $("#productSalePriceCloseButton").click(function() { $("#productSalePriceDialogPop").jqmHide(); });
   
	//날짜 조회 및 스타일
	$("#textContractStartDateDiv").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#textContractEndDateDiv").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;");
   
	
	fnInitAreaCodeComponent(); 
});

	var fnProductSalePriceCallback = "";
	var pDisp_good_id = ""; 
	var pGood_iden_numb = ""; 
</script>



<script type="text/javascript">
// openDial   
function fnProductSalePriceDialog(good_iden_numb, disp_good_id) {
    pDisp_good_id = disp_good_id;
    pGood_iden_numb = good_iden_numb ; 
    fnInitSalePriceDialogPage(disp_good_id);
    
    $("#productSalePriceDialogPop").jqmShow();
}
// InitComponent 
function fnInitSalePriceDialogComponent(disp_good_id){
    if(disp_good_id == 0) {
        $("#areaCodeDiv").attr("disabled",false);
        $('#btnBuyBorgDiv').show();
        $("#srcBorgNameDiv").attr("disabled",false);
        $("#selectVendorDiv").attr("disabled",false);
        $("#textSaleUnitPriceDiv").attr("disabled",false);
        $("#textBeforePriceDiv").attr("disabled",false);
        $("#textContractStartDateDiv").attr("disabled",false);
        $("#textContractEndDateDiv").attr("disabled",false);
    }else {
        
        $("#areaCodeDiv").attr("disabled",true);
        $('#btnBuyBorgDiv').hide();
        $("#srcBorgNameDiv").attr("disabled",true);
        $("#selectVendorDiv").attr("disabled",true);
        $("#textSaleUnitPriceDiv").attr("disabled",true);
        $("#textBeforePriceDiv").attr("disabled",true);
        $("#textContractStartDateDiv").attr("disabled",true);
        $("#textContractEndDateDiv").attr("disabled",true);
    }
}



// InitData
function fnInitSalePriceDialogPage(disp_good_id){
    $('#srcBorgNameDiv').val('');
    $('#textGroupIdDiv').val('');
    $('#textClientIdDiv').val('');
    $('#textBranchIdDiv').val('');
    
    // 공급사 정보 조회
    $("#selectVendorDiv option").remove();
    $("#selectVendorDiv").append("<option value=''>선택</option>");
    var rowCnt = jq("#prodVendor").getGridParam('reccount'); 
    var msg = ''; 
 	if(rowCnt > 0){
	    for(var i=0 ; i<rowCnt ; i++) {
	        var venRowid = $("#prodVendor").getDataIDs()[i];
	        var venRowData = jq("#prodVendor").jqGrid('getRowData',venRowid);
	        
	        // 종료요청인 데이터는 Pass 한다
	        if(venRowData['orgisUse'] == '0' || venRowData['orgvendorid'] == '' ) continue;
	        
	        $("#selectVendorDiv").append("<option value='"+venRowData['vendorid']+"'>"+venRowData['vendornm']+"</option>");
	        msg += "\n value ["+venRowData['vendorid']+"] text [" + venRowData['vendornm'] + "]" ; 
	    }
 	}
 	$('#textDispGoodId').val('0');
    $('#textCustGoodIdenNumbDiv').val('');
    $('#textSaleUnitPriceDiv').val('');
    $('#textSellPriceDiv').val('');
    $('#textBeforePriceDiv').val('');
    
	$('#textContractStartDateDiv').val('<%=contractStartDateDiv%>');
    $('#textContractEndDateDiv').val('<%=contractEndDateDiv%>');
    $('#textIspastSellFlagDiv').val('');
    
    if(disp_good_id != 0) {
        fnInitDataSalePriceDialogPage(disp_good_id);
    }else {
     // 권역 정보
        $('#areaCodeDiv').val('');
    }
    
    fnInitSalePriceDialogComponent(disp_good_id);
}

// DataRoad
function fnInitDataSalePriceDialogPage(disp_good_id){
    $('#textDispGoodId').val(disp_good_id);
    
    var rowCnt = jq("#prodDisplay").getGridParam('reccount');
    var rowId = 0; 
    var rowData = new Object();
    
    if(rowCnt > 0){
	    for(var i=0 ; i<rowCnt ; i++) {
	        rowId = $("#prodDisplay").getDataIDs()[i];
	        rowData = jq("#prodDisplay").jqGrid('getRowData',rowId);
	        
	        if(disp_good_id == rowData['disp_good_id']){
	            break;
	        }
	    }
 	}
    
	// 권역 정보
    $('#areaCodeDiv').val(rowData['areatype']); 
 
    
    $('#srcBorgNameDiv').val(rowData['fullborgnms']);
    $('#textGroupIdDiv').val(rowData['groupid']);
    $('#textClientIdDiv').val(rowData['clientid']);
    $('#textBranchIdDiv').val(rowData['branchid']);
    
    
    // 공급사 정보 조회
    $("#selectVendorDiv").val(rowData['vendorid']);
    $('#textCustGoodIdenNumbDiv').val(rowData['cust_good_iden_numb']);
    $('#textSaleUnitPriceDiv').val($.number(rowData['sale_unit_pric']));
    $('#textSellPriceDiv').val($.number(rowData['sell_price']));
    $('#textBeforePriceDiv').val(rowData['sell_price']);
    $('#textContractStartDateDiv').val(rowData['cont_from_date']);
    $('#textContractEndDateDiv').val(rowData['cont_to_date']);
    $('#textIspastSellFlagDiv').val(rowData['ispast_sell_flag']);
    
    $('#textSaleUnitPriceDiv').blur(); 
    $('#textSellPriceDiv').blur();
}

// 공급사 선택시 발생 이벤트 
function fnChangeselectVendorDiv(obj) {
    $.post(  //조회조건의 공급사세팅
      '<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/getGoodVendorListByGoodIdenNumJQGrid.sys',
      {good_iden_numb:pGood_iden_numb,vendorid:$(obj).val()},
      function(arg){
         var vendorList = eval('(' + arg + ')').list;
         if(vendorList.length == 0 ){
             $("#selectVendorDiv option:eq(0)").attr("selected", "selected");
             alert('선택된 공급사는 실제 저장된 데이터가 아닙니다. 마스터 정보 저장후 이용하시기 바랍니다.');
         }else if(vendorList.length == 1){
             
             var mstData = jq("#productMaster").jqGrid('getRowData',$("#productMaster").getGridParam("selrow"));
             var vendorData = jq("#prodVendor").jqGrid('getRowData',$(obj).val());
             var money = 0;
             
             if(mstData['sale_criterion_type'] == '10'){
                 money =    parseInt(vendorData['sale_unit_pric'].replace(/,/g , "")) * (1 + parseInt(mstData['stan_buying_rate'].replace(/,/g , ""))*0.01 ); 
             }else if(mstData['sale_criterion_type'] == '20'){
                 money = mstData['stan_buying_money'].replace(/,/g , "");
             }
             
             $("#textSellPriceDiv").val($.number(money) );
             $("#textSaleUnitPriceDiv").val(vendorList[0].sale_unit_pric);
         }
      }
   );
}

// 권역정보를 코드 테이블에서 조회한다. 
function fnInitAreaCodeComponent(){
    $.post(  //조회조건의 공급사세팅
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:'DELI_AREA_CODE',isUse:'1'},
		function(arg){
           	var codeList = eval('(' + arg + ')').codeList;
          	
           	$("#areaCodeDiv").html("");
			$("#areaCodeDiv").append("<option value=''>선택</option>");
			for(var i=0;i<codeList.length;i++) {
				$("#areaCodeDiv").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}   		 
    	}
	);
} 

// 조직검색 팝업 호출  
function fnPrePareForSearchBorg(){
    if($('#areaCodeDiv').val() == '' ){
        alert('권역 설정후 이용하시기 바랍니다.');
        return; 
	}
    
//     /* if($('#areaCodeDiv').val() == '99'){
//         alert('권역정보를 전국으로 선택시 조직을 선택할수 없습니다.');
//        	return; 
//     }  */
       
    fnSearchBuyBorg();
}

// Validation Div
function fnValidationDispDiv(){
    if($.trim($('#selectVendorDiv').val()) == ''){
        alert('공급사 정보는 필수 입력값 입니다.');
    	return false;
    }
//     alert(Number($('#textSaleUnitPriceDiv').val().replace(/,/g , ""))    );
//     alert(Number($('#textSellPriceDiv').val().replace(/,/g , ""))    );
    
	if(Number($('#textSaleUnitPriceDiv').val().replace(/,/g , ""))    >   Number($('#textSellPriceDiv').val().replace(/,/g ,""))){
		alert('판매가는 매입가보다 작을 수 없습니다.');
		return false;
	}

	return true; 
}

// 진열정보 저장 
function fnDisplayGoodTrans(){
    
    if(!fnValidationDispDiv()){
        return true; 
    }
    
    var params = {
         disp_good_id:$('#textDispGoodId').val()
         ,areatype:$('#areaCodeDiv').val()
         ,good_iden_numb:pGood_iden_numb
         ,groupid:$('#textGroupIdDiv').val()
         ,clientid:$('#textClientIdDiv').val() 
         ,branchid:$('#textBranchIdDiv').val()
         ,cont_from_date:$('#textContractStartDateDiv').val() 
         ,cont_to_date:$('#textContractEndDateDiv').val() 
         ,ispast_sell_flag:$('#textIspastSellFlagDiv').val() 
         ,ref_good_seq:$('#textDispGoodId').val()
         ,sell_price:$('#textSellPriceDiv').val() 
         ,before_price:$('#textBeforePriceDiv').val() 
         ,sale_unit_pric:$('#textSaleUnitPriceDiv').val() 
         ,cust_good_iden_numb:$('#textCustGoodIdenNumbDiv').val() 
         ,vendorid:$('#selectVendorDiv').val()
	};
    
    fnParentDisplayGoodTrans(params);
    
//     $.post(
<%-- 		"<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/displayGoodTrans.sys" --%>
// 		, params
// 		, function(arg) {
// 		    if(fnAjaxTransResult(arg)){
// 		        alert('success fnDisplayGoodTrans Method !');
// 		        $("#productSalePriceDialogPop").jqmHide();
<%-- 		        dialogArguments.fnInitProdDisplayGrid('<%=good_iden_numb %>'); --%>
//         	}
// 		}
// 	);
} 

 function fnDisplayOpenPopClose(){
     $("#productSalePriceDialogPop").jqmHide();
 }

</script>
</head>
<body>
   <div class="jqmProductSalePriceWindow" id="productSalePriceDialogPop">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <input id='textDispGoodId' name='textDispGoodId' type="hidden" value='' />
               <div id="productSalePriceDialogHandle">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                     <tr>
                        <td width="21">
                           <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
                        </td>
                        <td width="22">
                           <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom: 5px;" />
                        </td>
                        <td class="popup_title">상품판매가 상세정보</td>
                        <td width="22" align="right">
                           <a href="#">
                              <img id="jqmClose" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom: 5px;" />
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
                     <td bgcolor="#FFFFFF">
                        <!-- 타이틀 시작 -->
                        <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                           <tr>
                              <td width="20" valign="top">
                                 <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                              </td>
                              <td class="stitle">판매가 상품정보</td>
                           </tr>
                        </table>
                        <!-- 타이틀 끝 -->
                        <!-- 조회조건 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td colspan="4" class="table_top_line"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">권역</td>
                              <td class="table_td_contents" colspan="3"><!-- 789 -->
                                 <select id="areaCodeDiv" name="areaCodeDiv" class="select" onchange="javaScript:void(0);">
                                    <option value="">선택</option>
                                 </select>
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4" height="1" bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">진열조직</td>
                              <td colspan="3" class="table_td_contents">
                                 <input id="srcBorgNameDiv" name="srcBorgNameDiv" type="text" value="" size="" maxlength="50" style="width: 350px; background-color: #eaeaea;"  readonly="readonly" /> 
                                 <input id="textGroupIdDiv" name="textGroupIdDiv" type="hidden" value="0" />
                                 <input id="textClientIdDiv" name="textClientIdDiv" type="hidden" value="0" /> 
                                 <input id="textBranchIdDiv" name="textBranchIdDiv" type="hidden" value="0" />
                                 <img id="btnBuyBorgDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; border: 0;cursor: pointer;" align="middle" class="icon_search" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4" height="1" bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">공급사</td>
                              <td class="table_td_contents">
                                 <select id="selectVendorDiv" name="selectVendorDiv" class="select" style="width: 150px;" onchange="javaScript:fnChangeselectVendorDiv(this);">
                                    <option value="">선택</option>
                                 </select>
                              </td>
                              <td class="table_td_subject" width="80">고객사상품코드</td>
                              <td class="table_td_contents">
                                 <input id="textCustGoodIdenNumbDiv" name="textCustGoodIdenNumbDiv" type="text" value="" style="IME-MODE: disabled" size="20" maxlength="20" style="text-align: left;" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4" height="1" bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject" width="80">매입가</td>
                              <td class="table_td_contents">
                                 <input id="textSaleUnitPriceDiv" name="textSaleUnitPriceDiv" alt='number' type="text" value="" size="20" maxlength="8" style="text-align: right;" readonly="readonly" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);"/>
                              </td>
                              <td class="table_td_subject" width="100">판매가</td>
                              <td class="table_td_contents">
                                 <input id="textSellPriceDiv" name="textSellPriceDiv" alt='number' type="text" value="" size="20" maxlength="10" style="text-align: right;" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);"/>
                                 <input id="textBeforePriceDiv" name="textBeforePriceDiv" type="hidden" value="" size="20" maxlength="20" style="text-align: right;" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4" height="1" bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">계약시작일</td>
                              <td class="table_td_contents">
                                 <input id="textContractStartDateDiv" name="textContractStartDateDiv" type="text" style="width: 75px;" readonly="readonly"/>
                              </td>
                              <td class="table_td_subject">계약종료일</td>
                              <td class="table_td_contents">
                                 <input id="textContractEndDateDiv" name="textContractEndDateDiv" type="text" style="width: 75px;" readonly="readonly"/>
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4" class="table_top_line"></td>
                           </tr>
                           <tr>
                              <td colspan="4" height='8'></td>
                           </tr>
                        </table>
                        <!-- 조회조건 끝 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td align="center">
                                <img id="productSalePriceSaveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_ok.gif" style='border: 0;cursor: pointer;' />
                                <img id="productSalePriceCloseButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border: 0;cursor: pointer;' />
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                  </tr>
                  <tr>
                     <td width="20" height="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" />
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                     <td width="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" />
                     </td>
                  </tr>
               </table>
            </td>
         </tr>
      </table>
   </div>
</body>
</html>