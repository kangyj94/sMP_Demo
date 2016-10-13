<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:800px;">
<h1 id="userDialogHandle">상품규격입력<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmSpec">
	<input type="hidden" name="good_iden_numb" value="${param.GOOD_IDEN_NUMB}"/>
	
	<table class="InputTable">
		<tr>
			<td style="width: 99%">
				규격&nbsp;<input id="spec_spec" value="${param.spec_spec}" title="상품규격" type="text" style="width:660px;" />
			</td>
		</tr>
		<tr>
			<td style="width: 99%">
				&nbsp;&nbsp;&nbsp;&nbsp;Ø&nbsp;<input id="spec_pi" value="${param.spec_pi}" title="Ø" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
				W&nbsp;<input id="spec_width" value="${param.spec_width}" title="W" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
				D&nbsp;<input id="spec_deep" value="${param.spec_deep}" title="D" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
				H&nbsp;<input id="spec_height" value="${param.spec_height}" title="H" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
				L&nbsp;<input id="spec_liter" value="${param.spec_liter}" title="L" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
				t&nbsp;<input id="spec_ton" value="${param.spec_ton}" title="t" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
				M(미터)&nbsp;<input id="spec_meter" value="${param.spec_meter}" title="M(미터)" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<td style="width: 99%">
				재질&nbsp;<input id="spec_material" value="${param.spec_material}" title="재질" type="text" style="width:60px;" />&nbsp;&nbsp;
				크기&nbsp;<input id="spec_size" value="${param.spec_size}" title="크기" type="text" style="width:60px;" />&nbsp;&nbsp;
				색상&nbsp;<input id="spec_color" value="${param.spec_color}" title="색상" type="text" style="width:60px;" />&nbsp;&nbsp;
				TYPE&nbsp;<input id="spec_type" value="${param.spec_type}" title="TYPE" type="text" style="width:60px;" />&nbsp;&nbsp;
				총중량(KG,할증포함)&nbsp;<input id="spec_weight_sum" value="${param.spec_weight_sum}" title="총중량(KG,할증포함)" type="text" style="width:60px;" />&nbsp;&nbsp;
				실중량(KG)&nbsp;<input id="spec_weight_real" value="${param.spec_weight_real}" title="실중량(KG)" type="text" style="width:60px;" />
			</td>
		</tr>
	</table>
    </form>
    <div class="Ac mgt_10">
       <button id="btnSave" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 변경</button>
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
    	if (!$("#frmSpec").validate()) {
            return;
        }
    	var formObj;
    	if(parent.frmGood!=undefined) formObj=parent.frmGood;
    	if(parent.frm!=undefined) formObj=parent.frm;
    	
    	formObj.spec_spec.value = $("#spec_spec").val();
    	formObj.spec_pi.value = $("#spec_pi").val();
    	formObj.spec_width.value = $("#spec_width").val();
    	formObj.spec_deep.value = $("#spec_deep").val();
    	formObj.spec_height.value = $("#spec_height").val();
    	formObj.spec_liter.value = $("#spec_liter").val();
    	formObj.spec_ton.value = $("#spec_ton").val();
    	formObj.spec_meter.value = $("#spec_meter").val();
    	formObj.spec_material.value = $("#spec_material").val();
    	formObj.spec_size.value = $("#spec_size").val();
    	formObj.spec_color.value = $("#spec_color").val();
    	formObj.spec_type.value = $("#spec_type").val();
    	formObj.spec_weight_sum.value = $("#spec_weight_sum").val();
    	formObj.spec_weight_real.value = $("#spec_weight_real").val();
    	
    	var specValue = $("#spec_spec").val();
    	if($("#spec_pi").val()!='') specValue+= " Ø:"+$("#spec_pi").val();
    	if($("#spec_width").val()!='') specValue+= " W:"+$("#spec_width").val();
    	if($("#spec_deep").val()!='') specValue+= " D:"+$("#spec_deep").val();
    	if($("#spec_height").val()!='') specValue+= " H:"+$("#spec_height").val();
    	if($("#spec_liter").val()!='') specValue+= " L:"+$("#spec_liter").val();
    	if($("#spec_ton").val()!='') specValue+= " t:"+$("#spec_ton").val();
    	if($("#spec_meter").val()!='') specValue+= " M(미터):"+$("#spec_meter").val();
    	if($("#spec_material").val()!='') specValue+= " 재질:"+$("#spec_material").val();
    	if($("#spec_size").val()!='') specValue+= " 크기:"+$("#spec_size").val();
    	if($("#spec_color").val()!='') specValue+= " 색상:"+$("#spec_color").val();
    	if($("#spec_type").val()!='') specValue+= " TYPE:"+$("#spec_type").val();
    	if($("#spec_weight_sum").val()!='') specValue+= " 총중량(KG,할증포함):"+$("#spec_weight_sum").val();
    	if($("#spec_weight_real").val()!='') specValue+= " 실중량(KG):"+$("#spec_weight_real").val();
    	formObj.good_spec.value = specValue;
    	
		$('#productPop').html('');
		$('#productPop').jqmHide();
    });
});
</script>