<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">단가변경요청<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmPrice">
	<input type="hidden" name="good_iden_numb" value="${param.goodid}"/>
	<input type="hidden" name="vendorid" value="${sessionScope.sessionUserInfoDto.borgId}"/>
    <input type="hidden" name="applt_fix_code" value="20"/>
	<input type="hidden" name="before_price" value="${param.price}"/>
    <table class="InputTable">
    <colgroup>
    	<col width="120px" />
      <col width="auto" />
    </colgroup>
      <tr>
        <th class="check">변경사유</th>
        <td><textarea name="apply_desc" required title="변경사유" style="width:98%;height:77px" maxlength="500"></textarea></td>
      </tr>
      <tr>
        <th class="check">변경가격</th>
        <td><input id="price" name="price"   title="변경가격" type="text" style="width:200px; text-align: right;" requirednumber /></td>
      </tr>
    </table>
    </form>
    <div class="Ac mgt_10">
       <button id="btnSave" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 요청</button>
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
        if (!confirm("단가변경을 요청하시겠습니까?")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/setFixGoodUnitPriceTrans.sys', $('#frmPrice').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  $('.btnPrice[goodid=${param.goodid}]').attr('disabled', true);
                  $('.btnStop[goodid=${param.goodid}]').attr('disabled', true);
            	  alert('단가변경요청을 하였습니다.');
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