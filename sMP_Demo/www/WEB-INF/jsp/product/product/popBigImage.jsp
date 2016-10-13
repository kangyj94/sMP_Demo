<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">상품이미지 크게 보기<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
  	<input type="hidden" id="bigImage" name="bigImage" value="${param.bigImage}"/>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center">
				<img id='bigImageView' style="width: 400px;"/>
			</td>
		</tr>
	</table>
    <div class="Ac mgt_10">
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
	$("#bigImageView").attr('src','<%=Constances.SYSTEM_IMAGE_PATH%>/'+$("#bigImage").val());
	
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
});
</script>