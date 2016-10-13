<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">옵션 ${empty param.rowid?'등록':'수정'}<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmOption">
	<input type="hidden" name="repre_good_iden_numb" value="${param.good_iden_numb}"/>
    <input type="hidden" id="opt_good_iden_numb" name="good_iden_numb"/>
    <table class="InputTable">
      <colgroup>
        <col width="120px" />
        <col width="auto" />
      </colgroup>
        <tr>
          <th>옵션코드</th>
          <td id="td_opt_good_iden_numb"></td>
        </tr>
        <tr>
          <th class="check">옵션</th>
          <td><p>
            <input id="good_spec" name="good_spec" required title="옵션" type="text" style="width:200px" />
          </p></td>
        </tr>
        <tr>
          <th class="check">단가코드</th>
          <td><input id="pims" name="pims" requirednumber title="단가코드" type="text" style="width:100px" /></td>
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
	$('#good_spec').focus();
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
    
    var selrowContent = $('#list5').jqGrid('getRowData','${param.rowid}');
    $('#opt_good_iden_numb').val(selrowContent.GOOD_IDEN_NUMB);
    $('#td_opt_good_iden_numb').html(selrowContent.GOOD_IDEN_NUMB);
    $('#good_spec').val(selrowContent.GOOD_SPEC);
    $('#display_order').val(selrowContent.DISPLAY_ORDER);
    $('#pims').val(selrowContent.PIMS);
    
    $('#btnSave').click(function () {
    	if (!$("#frmOption").validate()) {
            return;
        }
        if (!confirm("옵션을 ${empty param.rowid?'등록':'수정'}하시겠습니까?")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveOption.sys', $('#frmOption').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
            	  if (m.customResponse.newIdx) {
                      var newRowId = $("#list5").getDataIDs().length+1;
//                       $("#list5").addRowData(newRowId, {GOOD_IDEN_NUMB:m.customResponse.newIdx,GOOD_SPEC:$('#good_spec').val(),PIMS:$('#pims').val()});
						reloadList5();
                      $('#optOption').append("<option value='"+m.customResponse.newIdx+"'>"+$('#good_spec').val()+"</option>");
            	  } else {
	            	  var data = {GOOD_IDEN_NUMB:$('#opt_good_iden_numb').val(),GOOD_SPEC:$('#good_spec').val(),PIMS:$('#pims').val()};
// 	                  $('#list5').jqGrid('setRowData','${param.rowid}',data);
						reloadList5();
	                  $('#optOption option[value='+$('#opt_good_iden_numb').val()+']').text($('#good_spec').val());
            	  }
            	  reloadList6();
//                   $('#list6').trigger("reloadGrid");
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