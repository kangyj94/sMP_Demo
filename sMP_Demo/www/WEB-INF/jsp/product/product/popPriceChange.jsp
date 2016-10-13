<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">${param.sell_sale_type eq 'SALE' ? '판매가':'매입가'} 변경<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmPrice">
	<input type="hidden" name="good_iden_numb" value="${param.good_iden_numb}"/>
	<input type="hidden" name="vendorid" value="${param.vendorid}"/>
	<input type="hidden" name="sell_sale_type" value="${param.sell_sale_type}"/>
	<input type="hidden" name="buy_rate" value="${param.buy_rate}"/>
    <table class="InputTable">
    <colgroup>
    	<col width="120px" />
      <col width="auto" />
    </colgroup>
      <tr>
        <th class="check">변경사유</th>
        <td><textarea name="chg_reason" required title="변경사유" style="width:98%;height:77px" maxlength="500"></textarea></td>
      </tr>
      <tr>
        <th class="check">변경가격</th>
        <td><input id="chgprice" name="chgprice" requirednumber title="변경가격" type="text" style="width:200px;text-align: right;"/></td>
<!--         <td><input id="chgprice" name="chgprice" requirednumber title="변경가격" type="text" style="width:200px;text-align: right;" onkeyup="fnInputCommaFormat(this)" onchange="fnInputCommaFormat(this)" /></td> -->
      </tr>
    </table>
    </form>
    <div class="Ac mgt_10">
       <button id="btnSave" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
	$(document).on("blur", "input:text[requirednumber]", function() {
	    $(this).number(true);
	});
	
	$('form').on('submit',function(){ return false; });
	
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
    $('#btnSave').click(function () {
    	if (!$("#frmPrice").validate()) {
            return;
        }
    	var isChagneSale = false;	//매입가 변경 시 판매가 변경 여부 
    	if(${param.sell_sale_type eq 'BUY' ? 'true':'false'} && ${param.buy_rate eq '' ? 'false':'true'}){
    		isChagneSale = true;
    	} 
    	
        if(${param.sell_sale_type eq 'SALE' ? 'true':'false'}){	//판매가 변경 시
            if( Number($.trim($("#chgprice").val())) < Number($.trim($("#SALE_UNIT_PRIC").val())) ){
                alert("'판매가'보다 '매입가'를 크게 입력할 수 없습니다.");
                return;
            }
        } else {	//매입가 변경 시
        	if(!isChagneSale) {
	            if( Number($.trim($("#chgprice").val())) > Number($.trim($("#SELL_PRICE").val())) ){
	                alert("'판매가'보다 '매입가'를 크게 입력할 수 없습니다.");
	                return;
	            }
        	}
        }
        
        var sellPrice = 0;
        var params = $('#frmPrice').serialize();
    	if(isChagneSale) {
    		sellPrice = 100*Number($("#chgprice").val())/(100-Number($("#BUY_RATE").val()));
    		var sellPriceString = $.number( sellPrice );
    		if(!confirm("기준매익율["+$("#BUY_RATE").val()+"]%에 따른 판매가는 ["+sellPriceString+"]원으로 변경됩니다.\n변경 하시겠습니까?")) return;
    		sellPrice = Number(sellPrice);
    		params += "&sellPrice="+sellPrice;
    	} else {
    		if (!confirm("${param.sell_sale_type eq 'SALE' ? '판매가':'매입가'}를 변경 하시겠습니까?")) return;
    	}
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/savePrice.sys', params,
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
            	  if(isChagneSale) {
						$('#list2').setCell($('#VENDORID').val(), 'BUY_RATE', $("#BUY_RATE").val());
						$('#list2').setCell($('#VENDORID').val(), 'SELL_PRICE', sellPrice);
						$("#SELL_PRICE").val(sellPrice);
            	  }
            	  fnPriceCallBack($('#chgprice').val());
                  $('#productPop').html('');
                  $('#productPop').jqmHide();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
});
</script>