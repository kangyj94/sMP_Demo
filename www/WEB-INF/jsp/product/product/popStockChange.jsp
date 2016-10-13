<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">재고 변경<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmStock">
    <input type="hidden" name="good_iden_numb" value="${param.good_iden_numb}"/>
    <input type="hidden" name="vendorid" value="${param.vendorid}"/>
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
        <th class="check">재고증감</th>
        <td><input id="chgStock" name="chgStock" requirednumber title="재고증감" type="text" style="width:50px;text-align: right;" /> 재고감소는 [-]로 입력해 주십시오.</td>
      </tr>
    </table>
    </form>
    <div class="Ac mgt_10">
       <button id="btnSave" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
	$(document).on("blur", "input:text[requirednumber]", function() {
	    $(this).number(true);
	});
	
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
    $('#btnSave').click(function () {
        if (!$("#frmStock").validate()) {
            return;
        }
        if (!confirm("재고를 변경하시겠습니까?")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveStock.sys', $('#frmStock').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
            	  fnStockCallBack($('#chgStock').val());
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