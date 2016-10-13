<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<style type="text/css">
img {max-width:650px;}
</style>

<div id="divPopup" style="width:700px;">
  <h1 id="userDialogHandle">상품설명 보기<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
  	<input type="hidden" id="good_iden_numb" name="good_iden_numb" value="${param.good_iden_numb}"/>
  	<input type="hidden" id="vendorid" name="vendorid" value="${param.vendorid}"/>
	<table width="680px" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center" id="productDesc" style="width: 680px;"></td>
		</tr>
	</table>
    <div class="Ac mgt_10">
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
	$.post( 
		'/product/selectProductDescByGoodIdenNumb/productDesc/object.sys',
		{ GOOD_IDEN_NUMB:$('#good_iden_numb').val(), VENDORID:$('#vendorid').val() },
		function(arg){
			var result = eval('('+arg+')').productDesc;
			$("#productDesc").html(result.productDesc);
		}
	);
	
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
});
</script>