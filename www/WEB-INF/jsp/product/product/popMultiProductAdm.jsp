<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="org.apache.commons.lang.StringUtils"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="java.util.*"%>
<%
//현재날짜받아오기
String getYear = CommonUtils.getCurrentDate();
int year = Integer.parseInt(getYear.substring(0, 4));
@SuppressWarnings("unchecked") List<CodesDto> vTaxTypeCode      = (List<CodesDto>) request.getAttribute("vTaxTypeCode");   // 과세구분
@SuppressWarnings("unchecked") List<Map> productManager         = (List<Map>) request.getAttribute("productManager");      // 상품담당자
@SuppressWarnings("unchecked") List<CodesDto> orderUnit         = (List<CodesDto>) request.getAttribute("orderUnit");      // 주문단위
@SuppressWarnings("unchecked") List<CodesDto> orderGoodsType    = (List<CodesDto>) request.getAttribute("orderGoodsType"); // 상품구분
@SuppressWarnings("unchecked") List<CodesDto> isdistributeSts  = (List<CodesDto>) request.getAttribute("isdistributeSts"); // 물량배분
LoginUserDto loginUserDto =CommonUtils.getLoginUserDto(request);

@SuppressWarnings("unchecked") List<Object> goodIdenNumb  = (List<Object>) request.getAttribute("goodIdenNumb"); // 물량배분
//@SuppressWarnings("unchecked") List<Object> vendorId  = (List<Object>) request.getAttribute("vendorId"); 

%>
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 상품팝업을 위해 추가한 CSS -->
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Global.css">
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">
<style type="text/css" media="screen">
    th.ui-th-column div{
        white-space:normal !important;
        height:auto !important;
    }
    input[type=radio]{vertical-align: middle;}
</style>
</head>
<body style="width: 900px;">
<div id="divPopup" style="width:900px;">
	<div class="popcont">
		<h2>상품일괄수정</h2>
		<h3>상품기본정보</h3>
		<form id="frmGood">
			
<%
		for(int i = 0 ; i < goodIdenNumb.size() ; i++){
%>
			<input type="hidden" id="good_iden_numbs" name="good_iden_numbs" value="<%=CommonUtils.getString(goodIdenNumb.get(i))%>"/>
<%			
		}
%>
			
			
			<input type="hidden" name="bidid" value=""/>
			<input type="hidden" name="bid_vendorid" value=""/>
			
			<table class="InputTable" style="border: 0px;">
				<colgroup>
					<col width="120px" />
					<col width="*" />
					<col width="100px" />
					<col width="170px" />
					<col width="100px" />
					<col width="170px" />
				</colgroup>
				<tr>
					<th style="width:120px;">상품카테고리</th>
					<td colspan="5">
						<input id="majoCodeName" name="majoCodeName" value="" required title="상품카테고리" type="text" style="width:500px" readonly="readonly"/>
						<input id="cate_id" name="cate_id" value="" type="hidden" readonly="readonly" />
						<a id="btnCate" href="#">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/icon_search.gif" width="20" height="20" />
						</a>
					</td>
				</tr>
				<tr>
					<th style="width:100px;">상품명</th>
					<td colspan="5">
						<input name="good_name" value="" required title="상품명" maxlength="100" type="text" style="width:300px" />
					</td>
				</tr>
				<tr>

					<th>상품규격</th>
					<td colspan="5">
						<input name="good_spec" value="" required title="상품규격" maxlength="100" type="text" style="width:380px" />
						<button id="btnSpec" type="button" class="btn btn-darkgray btn-xs btnSpec" >입력</button>
						<input name="spec_spec" value="" type="hidden" />
						<input name="spec_pi" value="" type="hidden" />
						<input name="spec_width" value="" type="hidden" />
						<input name="spec_deep" value="" type="hidden" />
						<input name="spec_height" value="" type="hidden" />
						<input name="spec_liter" value="" type="hidden" />
						<input name="spec_ton" value="" type="hidden" />
						<input name="spec_meter" value="" type="hidden" />
						<input name="spec_material" value="" type="hidden" />
						<input name="spec_size" value="" type="hidden" />
						<input name="spec_color" value="" type="hidden" />
						<input name="spec_type" value="" type="hidden" />
						<input name="spec_weight_sum" value="" type="hidden" />
						<input name="spec_weight_real" value="" type="hidden" />
					</td>
				</tr>
				<tr id="detail1">
					<th>담당자</th>
					<td>
						<select name="product_manager" required title="담당자" style="width:100px">
							<option value="">선택</option>
<%
	for (Map code : productManager) {
		String managerId   = null;
		String loginUserId = loginUserDto.getUserId();
%>
							<option value="<%=code.get("USERID")%>" <%=code.get("USERID").equals(loginUserId) ? "selected":""%>><%=code.get("USERNM")%></option>
<%
	} 
%>
						</select>
					</td>
					<th>주문단위</th>
					<td>
						<select name="order_unit" required title="주문단위" style="width:100px">
							<option value="">선택</option>
<%
	for (CodesDto code : orderUnit) {
%>
							<option value="<%=code.getCodeVal1()%>"><%=code.getCodeNm1()%></option>
<%
	}
%>
						</select>
					</td>
					<th>상품실적년</th>
					<td>
						<select name="good_reg_year">
							<option selected="selected" value="">선택</option>	
<%
	for (int i=year; i>=2010; i--) {
%>
	              			<option><%=i%></option>
<%
	}
%>
						</select>
					</td>
					
					
				</tr>
				<tr id="detail2">
					<th>상품구분</th>
					<td>
						<label><input type="radio" class="input_none" name="good_type" value="" checked="checked"/> 변경없음</label><br/>
<%
	for (int i=0;i<orderGoodsType.size();i++) {
%>
						<label><input type="radio" class="input_none" name="good_type" value="<%=orderGoodsType.get(i).getCodeVal1()%>"/> <%=orderGoodsType.get(i).getCodeNm1()%></label><br/>
<%
	}
%>
					</td>
					<th>공급사노출</th>
					<td>
						<label><input type="radio" class="input_none" name="vendor_expose" value="" checked="checked"/> 변경없음</label>
						<label><input type="radio" class="input_none" name="vendor_expose" value="Y"  /> 예</label>
						<label><input type="radio" class="input_none" name="vendor_expose" value="N"  /> 아니오</label>
					</td>
					<th>물량배분</th>
					<td>
						<label><input type="radio" class="input_none" name="isdistribute" required title="물량배분" value="" checked="checked"/> 변경없음</label>
<%
	for (int i=0;i<isdistributeSts.size();i++) {
%>
						<label><input type="radio" class="input_none" name="isdistribute" required title="물량배분" value="<%=isdistributeSts.get(i).getCodeVal1()%>"/> <%=isdistributeSts.get(i).getCodeNm1()%></label>
<%
	}
%>
					</td>
				</tr>
				<tr id="detail3">
					<th>재고관리</th>
					<td colspan="5">
						<label><input type="radio" class="input_none" name="stock_mngt" value="" checked="checked" /> 변경없음</label>
						<label><input type="radio" class="input_none" name="stock_mngt" value="Y"/> 예</label>
						<label><input type="radio" class="input_none" name="stock_mngt" value="N"/> 아니오</label>
					</td>
				</tr>
			</table>
		</form>
		<div class="Ac mgt_10">
			<button id="btnSaveGood" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 상품일괄수정</button>
	        <button type="button" class="btn btn-default btn-sm btnClose"><i class="fa fa-times"></i> 닫기</button>  
		</div>
	</div>
</div>
<style type="text/css">
.jqmWindow {
    display: none;
    position: absolute;
    top: 5%;
    left: 3%;
    width: 850px;
    background-color: #EEE;
    color: #333;
    z-index: 1003;
}
.jqmOverlay { background-color: #000; }
</style>
<div class="jqmWindow" id="productPop"></div>
<%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp"%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<script type="text/javascript">
var oEditors = [];
$(function(){
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
			if(this.name!='DISTRI_RATE') {
				alert("0보다 크고 100보다 작아야 합니다."); 
				$(this).val('');
				return;
			}
		}
		if(thisValue.indexOf('.',0)>-1) {
			if((thisValue.substring(thisValue.indexOf('.',0)+1)).length > 1) {
				alert("소수점 1째자리까지 허용합니다."); 
				$(this).val('');
				return;
			}
		}
	});

	$('form').on('submit',function(){ return false; });
    $.ajaxSetup ({cache: false});

    fnCheckGood_type();
    $('input[name=good_type]').click(function () {
    	fnCheckGood_type();
    });
    $('input[name=vendor_expose]').click(function () {
    	fnCheckVendor_expose();
    });
    $('input[name=isdistribute]').click(function () {
        fnCheckIsdistribute();
    });
    $('#productPop').jqm();
    $('#btnCate').click(function()         {   fnCategoryPopOpen();                                                          });
    $("#majoCodeName").keydown(function(e) {   if(e.keyCode==13) { $("#btnCate").click(); }                                  });
	/**************************************
	 * 상품기본정보 - 저장
	 **************************************/
    $('#btnSaveGood').click(function () {
        if (!confirm("상품정보를 일괄 수정시겠습니까?")) return;
        var params = $('#frmGood').serialize();
		$.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/modMultiGood.sys', params,
        	function(msg) {
            	var m = eval('(' + msg + ')');
              	if (m.customResponse.success) {
            	  	alert('상품일괄수정을 완료 하였습니다..');
              	} else {
					alert('수정 중 오류가 발생했습니다.');
              	}
			}
		);  
	});

	$('#btnSpec').click(function (e) {
    	var formData = $("#frmGood").serialize();
        $('#productPop').css({'width':'800px','top':'20%','left':'5%'}).html('')
		.load('/menu/product/product/popProductSpec.sys',formData)
        .jqmShow();
    });
	
    $('.btnClose').click(function () {
    	window.close();
    });
});    

/**
 * 카테고리 팝업 호출  
 */
function fnCategoryPopOpen(){
     fnSearchStandardCategoryInfo("3", "fnCallBackStandardCategoryChoice"); 
}
/**
 * 카테고리 선택 콜백   
 */
function fnCallBackStandardCategoryChoice(categortId , categortName , categortFullName) {
    var msg = ""; 
    $('#cate_id').val(categortId); 
    $('#majoCodeName').val(categortFullName); 
}

function fnCheckGood_type() {
	var good_type = $('input[name=good_type]:checked').val();
	if(good_type != ''){
		if (good_type == '10') {
		    $('input[name=vendor_expose][value=Y]').attr('checked', true);
		    $('input[name=vendor_expose][value=N]').attr('disabled', true);
		} else {
			$('input[name=vendor_expose]').attr('disabled', false);
			$('input[name=stock_mngt][value=Y]').attr('checked', true);
		}
	}else{
		$("input[name=stock_mngt][value='']").attr('checked', true);
		$("input[name=vendor_expose][value='']").attr('checked', true);
		$("input[name=isdistribute][value='']").attr('checked', true);
	}
	fnCheckVendor_expose();
}
function fnCheckVendor_expose() {
    var good_type = $('input[name=good_type]:checked').val();
    var vendor_expose = $('input[name=vendor_expose]:checked').val();
    if (good_type == '10') {
        $('input[name=isdistribute]').attr('checked', false).attr('disabled', true);
        $('input[name=isdistribute][value=0]').attr('checked', true).attr('disabled', false);
    } else if (vendor_expose == 'Y') {
        $('input[name=isdistribute]').attr('disabled', false);
        $('input[name=isdistribute][value=2]').attr('checked', false).attr('disabled', true);
    } else {
    	$('input[name=isdistribute]').attr('disabled', false);
        $('input[name=isdistribute][value=0]').attr('checked', false).attr('disabled', true);
    }
    fnCheckIsdistribute();
}
function fnCheckIsdistribute() {
	var isdistribute = $('input[name=isdistribute]:checked').val();
	if (isdistribute == '0') {
		$('input[name=add_good]').attr('disabled', false);
	} else {
        $('input[name=add_good][value=N]').attr('checked', true).attr('disabled', false);
        $('input[name=add_good][value=Y]').attr('checked', false).attr('disabled', true);
	}
}

</script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/jquery.serializejson.min.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
</body>
</html>