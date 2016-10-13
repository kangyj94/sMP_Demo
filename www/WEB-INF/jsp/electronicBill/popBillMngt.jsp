<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<style type="text/css">
input[readonly] {
    background: #ffffff !important;
}
</style> 
<div id="divPopup" style="width:650px;">
<h1 id="userDialogHandle">전자어음 ${empty param.bill_id ? "등록":"수정"}<a href="#" class="jqmClose"><img src="/img/contents/btn_close.png"></a></h1>
	<form id="frmBill">
	<div class="popcont">
		<h3 style="font-weight: bold;">발행정보</h3>
 		<table class="InputTable">
			<colgroup>
				<col width="100px" />
				<col width="200px" />
				<col width="100px" />
				<col width="200px" />
			</colgroup>
			<tr>
				<th>발행코드</th>
				<td colspan="3">
					<input id="bill_id" name="bill_id" class="hiddenClass" type="text" value="${param.bill_id}" style="border: 0px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>어음구분</th>
				<td>
                   	<select id="bill_flag" name="bill_flag" class="select" >
                   		<option value="">선택</option>
                   		<option value="10">전자어음</option>
                   		<option value="20">전자외담대</option>
                   	</select>
				</td>
				<th>은행구분</th>
				<td>
                   	<select id="bankcd" name="bankcd" class="select" >
                   		<option value="">선택</option>
                   		<option value="04">국민은행</option>
                   		<option value="03">기업은행</option>
	                    <option value="20">우리은행</option>
	                    <option value="81">하나은행</option>
<!--                    		<option value="26">신한은행</option> -->
<!--                    		<option value="23">한국SC은행</option> -->
<!--                    		<option value="02">KDB산업은행</option> -->
<!--                    		<option value="71">우체국</option> -->
<!--                    		<option value="11">농협</option> -->
<!--                    		<option value="07">수협은행</option> -->
<!--                    		<option value="53">씨티은행</option> -->
<!--                    		<option value="27">한미은행</option> -->
<!--                    		<option value="31">대구은행</option> -->
<!--                    		<option value="32">부산은행</option> -->
<!--                    		<option value="34">광주은행</option> -->
<!--                    		<option value="37">전북은행</option> -->
<!--                    		<option value="39">경남은행</option> -->
<!--                    		<option value="HS">한신상호저축은행</option> -->
<!--                    		<option value="DO">도이치은행</option> -->
                   	</select>
				</td>
			</tr>
			<tr>
				<th>사업자명</th>
				<td>
					<input id="business_nm" name="business_nm" type="text" value="" title="사업자명" style="width:100px;text-align: left;" maxlength="30">
				</td>
				<th class="check">사업자번호</th>
				<td>
					<input id="business_num" name="business_num" type="text" value="" required number2 title="사업자번호" style="width:100px;text-align: left;" maxlength="10">
				</td>
			</tr>
			<tr>
				<th class="check">전표번호</th>
				<td>
					<input id="sale_num" name="sale_num" type="text" value="" required number2 title="전표번호" style="width:100px;text-align: left;" maxlength="10">
				</td>
				<th class="check">발행일</th>
				<td>
					<input id="public_date" name="public_date" class="input_date" type="text" value="" required title="발행일" style="width:75px;text-align: center;" maxlength="10">
				</td>
			</tr>
			<tr>
				<th class="check">증빌일</th>
				<td>
					<input id="evidence_date" name="evidence_date" class="input_date" type="text" value="" required title="증빌일" style="width:75px;text-align: center;" maxlength="10">
				</td>
				<th class="check">만기일</th>
				<td>
					<input id="expire_date" name="expire_date" class="input_date" type="text" value="" required title="만기일" style="width:75px;text-align: center;" maxlength="10">
				</td>
			</tr>
			<tr>
				<th class="check">물대발행</th>
				<td>
					<input id="public_amount" name="public_amount" type="text" class="autoCal" value="" requirednumber title="물대발행" style="width:100px;text-align: right;">
				</td>
				<th>초과기간</th>
				<td>
					<input id="over_period" name="over_period" type="text" class="autoCal" value="" number2 title="초과기간" style="width:50px;text-align: right;" maxlength="4">
				</td>
			</tr>
			<tr>
				<th>이자율</th>
				<td>
					<input id="interest_rate" name="interest_rate" type="text" class="autoCal" value="" number2 title="이자율" style="width:60px;text-align: right;" maxlength="5"> %
				</td>
				<th>이자발행</th>
				<td>
					<input id="interest_amount" name="interest_amount" type="text" class="autoCal2" value="" number2 title="이자발행" style="width:80px;text-align: right;">
				</td>
			</tr>
			<tr>
				<th>총 어음발행</th>
				<td colspan="3">
					<input id="sum_amount" name="sum_amount" class="hiddenClass" type="text" value="" requirednumber title="총 어음발행" style="border: 0px;" readonly="readonly">
				</td>
			</tr>
		</table>
		<div style="height: 20px;"></div>
		
		<h3 style="font-weight: bold;">결제정보</h3>
		 		<table class="InputTable">
			<colgroup>
				<col width="100px" />
				<col width="200px" />
				<col width="100px" />
				<col width="200px" />
			</colgroup>
			<tr>
				<th>결제일</th>
				<td colspan="3">
					<input id="return_date" name="return_date" class="input_date" type="text" value="" title="결제일" style="width:75px;text-align: center;" maxlength="10">
				</td>
<!-- 				<th class="check">기존발행일</th> -->
<!-- 				<td> -->
					<input id="exist_public_date" name="exist_public_date" type="hidden" value="" title="기존발행일" style="width:75px;text-align: center;" maxlength="10">
<!-- 				</td> -->
			</tr>
			<tr>
				<th>참조</th>
				<td colspan="3">
					<textarea id="reference" name="reference" title="참조" style="width:100%; height:50px;"></textarea>
				</td>
			</tr>
		</table>
		<div style="height: 20px;"></div>
		
		<div class="Ac mgt_10">
			<button id="btnSave" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
			<button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
		</div>
	</div>
	</form>
</div>
<script type="text/javascript">
$(function() {
	var tmp_bill_id = $("#bill_id").val();
	tmp_bill_id = tmp_bill_id=='' ? '0' : tmp_bill_id
	$.post(
		"/newCate/selectElectronicBill/bill/object.sys",
		{ bill_id:tmp_bill_id },
		function(arg){
			var bill = eval('('+arg+')').bill;
			if(bill!=null) {
				$("#business_num").val(bill.BUSINESS_NUM);
				$("#sale_num").val(bill.SALE_NUM);
				$("#public_date").val(bill.PUBLIC_DATE);
				$("#evidence_date").val(bill.EVIDENCE_DATE);
				$("#expire_date").val(bill.EXPIRE_DATE);
				$("#public_amount").val(bill.PUBLIC_AMOUNT);
				$("#over_period").val(bill.OVER_PERIOD);
				$("#interest_rate").val(bill.INTEREST_RATE);
				$("#interest_amount").val(bill.INTEREST_AMOUNT);
				$("#sum_amount").val(bill.SUM_AMOUNT);
				$("#return_date").val(bill.RETURN_DATE);
				$("#exist_public_date").val(bill.EXIST_PUBLIC_DATE);
				$("#reference").val(bill.REFERENCE);

				$("#bill_flag").val(bill.BILL_FLAG);
				$("#bankcd").val(bill.BANKCD);
				$("#business_nm").val(bill.BUSINESS_NM);
				
				$("#public_amount").number(true);
				$("#over_period").number(true);
				$("#interest_amount").number(true);
				$("#sum_amount").number(true);
// 				$("#public_amount").focus();
// 				$("#over_period").focus();
// 				$("#interest_amount").focus();
			}
		}
	);
	
    $("#billPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#billPop').html('');
        $('#billPop').jqmHide();
    });
    
    $(".input_date").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
    
	$(document).on("blur", "input:text[requirednumber]", function() {
		$(this).number(true);
	});
	$(document).on("blur", "input:text[number2]", function() {
		var thisValue = $(this).val();
		if(thisValue=='') return;
		if(!($.isNumeric(thisValue))) {
			alert("숫자만 입력가능 합니다."); 
			$(this).val('');
			return;
		}
		if(Number(thisValue)>=100 || Number(thisValue)<=0) {
			if(this.name=='interest_rate') {
				alert("0보다 크고 100보다 작아야 합니다."); 
				$(this).val('');
				return;
			}
		}
		if(thisValue.indexOf('.',0)>-1) {
			if((thisValue.substring(thisValue.indexOf('.',0)+1)).length > 2) {
				alert("소수점 2째자리까지 허용합니다."); 
				$(this).val('');
				return;
			}
		}
	});
	
	$(".autoCal").blur(function() {
		var publicAmount = Number($("#public_amount").val());
		var overPeriod = Number($("#over_period").val());
		var interestRate = Number($("#interest_rate").val());
		var tmpAmount = ((publicAmount*overPeriod)/365)*(interestRate/100);
		if(tmpAmount>0) {
			$("#interest_amount").val(Math.floor(tmpAmount));
			$("#interest_amount").number(true);
		}
		var interestAmount = Number($("#interest_amount").val());
		var sumAmount = (publicAmount+interestAmount).toFixed();
		$("#sum_amount").val(sumAmount);
		$("#sum_amount").number(true);
	});
	$(".autoCal2").blur(function() {
		var publicAmount = Number($("#public_amount").val());
		var interestAmount = Number($("#interest_amount").val());
		var sumAmount = (publicAmount+interestAmount).toFixed();
		$("#sum_amount").val(sumAmount);
		$("#sum_amount").number(true);
	});
	
	$('#btnSave').click(function (e) {
		if (!$("#frmBill").validate()) {
			return;
		}
		if(!confirm("입력정보를 저장 하시겠습니까?")) return;
		var params = $('#frmBill').serialize();
		$.post('/electronic/saveBill.sys', params,
			function(msg) {
				var m = eval('(' + msg + ')');
				if (m.custResponse.success) {
					alert('정보가 저장되었습니다.');
					$('.jqmClose').click();
					$("#srcButton").click();
				} else {
					alert('저장 중 오류가 발생했습니다.');
				}
			}
		);
	});
});
</script>