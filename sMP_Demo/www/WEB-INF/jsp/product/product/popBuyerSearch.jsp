<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">고객사 조회<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <table class="InputTable">
    <colgroup>
    	<col width="120px" />
      <col width="auto" />
      <col width="120px" />
      <col width="auto" />
    </colgroup>
      <tr>
        <th>고객사조직유형</th>
        <td><select name="select" style="width:100px">
          <option>사업장</option>
        </select></td>
        <th>구매사명</th>
        <td><input type="text" style="width:100px" /></td>
      </tr>
      <tr>
        <th>고객유형</th>
        <td colspan="3"><select name="select2" style="width:200px">
          <option>선택</option>
        </select></td>
      </tr>
    </table>
    <div class="Ar mgt_5 mgb_10"><a href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_tablesearch.gif" /></a></div>
    아래와 같은 그리드 넣으시면 됩니다.
    <div class="GridList">
    <table>
      <tr>
        <th><input type="checkbox" /></th>
        <th>조직유형</th>
        <th>구매사명</th>
        <th>권역</th>
      </tr>
      <tr>
        <td align="center"><input type="checkbox" /></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td align="center"><input type="checkbox" /></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
    </table>
    </div>
    <div class="Ac mgt_10">
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
});
</script>