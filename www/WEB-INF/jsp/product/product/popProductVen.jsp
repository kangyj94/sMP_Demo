<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>

<script type="text/javascript">
function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
} 

$(document).ready(function() {
    $('#btnDelImg').click(function () {
        $('#img_SMALL_IMG_PATH').attr('src','<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif');
        $('#ORIGINAL_IMG_PATH').val('');
        $('#LARGE_IMG_PATH').val('');
        $('#MIDDLE_IMG_PATH').val('');
        $('#SMALL_IMG_PATH').val('');
        $('#ORIGINAL_IMG_PATH').change();
    });
    $('#btnSaveVen').click(function () {
        oEditors.getById["GOOD_DESC"].exec("UPDATE_CONTENTS_FIELD", []);
        if (!$("#frm").validate()) {
            return;
        }
        var sameWord = $('#GOOD_SAME_WORD1').val()+"‡"+$('#GOOD_SAME_WORD2').val()+"‡"+$('#GOOD_SAME_WORD3').val()+"‡"+$('#GOOD_SAME_WORD4').val()+"‡"+$('#GOOD_SAME_WORD5').val();//상품동의어
        $('#GOOD_SAME_WORD').val(sameWord);
        if (!confirm("상품 정보를 저장하시겠습니까?")) return;
        
        $('#GOOD_DESC').val(fnReplaceAll($("#GOOD_DESC").val(), unescape("%uFEFF"), ""));
        
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveVen.sys', $("#frm").serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  alert('상품 정보가 저장되었습니다.');
                  window.close();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
    $('.btnClose').click(function (e) {
        window.close();
    });
    $('#productPop').jqm();
    $('.btnSpec').click(function (e) {
    	var formData = $("#frm").serialize();
        $('#productPop').css({'width':'800px','top':'20%','left':'5%'}).html('')
		.load('/menu/product/product/popProductSpec.sys',formData)
        .jqmShow();
    });
    $('.btnPrice').click(function (e) {
        $('#productPop').css({'width':'600px','top':'50%','left':'20%'}).html('')
        .load('/menu/product/product/popPriceRequest.sys?goodid='+$(this).attr('goodid')+'&price='+$(this).attr('price'))
        .jqmShow();
    });
    $('.btnStop').click(function (e) {
        $('#productPop').css({'width':'600px','top':'50%','left':'20%'}).html('')
        .load('/menu/product/product/popStopRequest.sys?goodid='+$(this).attr('goodid'))
        .jqmShow();
    });
    $('.btnStock').click(function (e) {
    	goodid = $(this).attr('goodid');
        $('#productPop').css({'width':'600px','top':'50%','left':'20%'}).html('')
        .load('/menu/product/product/popStockChange.sys?good_iden_numb='+$(this).attr('goodid')+'&vendorid=${sessionScope.sessionUserInfoDto.borgId}')
        .jqmShow();
    });
    $('.btnHist').click(function (e) {
        $('#productPop').css({'width':'600px','top':'50%','left':'20%'}).html('')
        .load('/menu/product/product/popStockChangeHist.sys?good_iden_numb='+$(this).attr('goodid')+'&vendorid=${sessionScope.sessionUserInfoDto.borgId}')
        .jqmShow();
    });
    
    $(document).on("blur", "input:text[requiredNumber]", function() {
    	if($(this).val() != "-"){
    		$(this).number(true);
    	}
	});
	$("#img_SMALL_IMG_PATH").wrap("<a href='javascript:funPopBigImage();'>");
	
	
// 	good_spec
// 	alert(${good.PRODUCT_MANAGER});
});

</script>


<style>
label {padding:0}
input[readonly='readonly']{background-color: #F5F5F5;}
</style>
</head>
<body>
<form id="frm" name="frm" onsubmit="return false;">
  <div id="divPopup" style="width:900px;">
  <h1>상품관리</h1>
    <div class="popcont">
      <h3>${good.REPRE_GOOD eq 'Y'?'옵션':''}상품상세</h3>
      <input name="GOOD_IDEN_NUMB" value="${good.GOOD_IDEN_NUMB}" type="hidden" />
      <input id="GOOD_SAME_WORD" name="GOOD_SAME_WORD" value="${good.GOOD_SAME_WORD}" type="hidden" />
      <table class="InputTable">
      <colgroup>
        <col width="120px" />
        <col width="180px" />
        <col width="100px" />
        <col width="160px" />
        <col width="100px" />
        <col width="auto" />
      </colgroup>
        <tr>
          <th>상품카테고리</th>
          <td colspan="5"><input value="${good.CATE_NM}" type="text" style="width:500px" readonly="readonly"/></td>
        </tr>
        <tr>
          <th>상품코드</th>
          <td>${good.GOOD_IDEN_NUMB}</td>
          <th>상품명</th>
          <td colspan="3"><input value="${good.GOOD_NAME}" type="text" style="width:300px" readonly="readonly"/></td>
        </tr>
        <tr>
          <th>과세구분</th>
          <td><input value="${good.VTAX_CLAS_CODE}" type="text" style="width:100px" readonly="readonly"/></td>
          <th>상품규격</th>
          <td colspan="3">
			<input id="good_spec" name="good_spec" value="${good.GOOD_SPEC}" type="text" style="width:380px" readonly="readonly"/>
			<button id="btnSpec" type="button" class="btn btn-darkgray btn-xs btnSpec" style="display: ${good.PRODUCT_MANAGER eq '김철' ? ';':'none;'}">입력</button>
			<input name="spec_spec" value="${good_spec.SPEC_SPEC}" type="hidden" />
			<input name="spec_pi" value="${good_spec.SPEC_PI}" type="hidden" />
			<input name="spec_width" value="${good_spec.SPEC_WIDTH}" type="hidden" />
			<input name="spec_deep" value="${good_spec.SPEC_DEEP}" type="hidden" />
			<input name="spec_height" value="${good_spec.SPEC_HEIGHT}" type="hidden" />
			<input name="spec_liter" value="${good_spec.SPEC_LITER}" type="hidden" />
			<input name="spec_ton" value="${good_spec.SPEC_TON}" type="hidden" />
			<input name="spec_meter" value="${good_spec.SPEC_METER}" type="hidden" />
			<input name="spec_material" value="${good_spec.SPEC_MATERIAL}" type="hidden" />
			<input name="spec_size" value="${good_spec.SPEC_SIZE}" type="hidden" />
			<input name="spec_color" value="${good_spec.SPEC_COLOR}" type="hidden" />
			<input name="spec_type" value="${good_spec.SPEC_TYPE}" type="hidden" />
			<input name="spec_weight_sum" value="${good_spec.SPEC_WEIGHT_SUM}" type="hidden" />
			<input name="spec_weight_real" value="${good_spec.SPEC_WEIGHT_REAL}" type="hidden" />
          </td>
        </tr>
        <tr>
          <th>납품소요일</th>
          <td><input name="DELI_MINI_DAY" value="<fmt:formatNumber value="${good.DELI_MINI_DAY}" pattern="#,###"/>" title="납품소요일" requirednumber type="text" class="Ar" style="width:100px" maxlength="2" ${good.GOOD_TYPE eq '20'?'readonly="readonly"':''}/></td>
          <th>담당자</th>
          <td><input value="${good.PRODUCT_MANAGER}" type="text" style="width:100px" readonly="readonly"/></td>
          <th>주문단위</th>
          <td><input value="${good.ORDER_UNIT}" type="text" style="width:100px" readonly="readonly"/></td>
        </tr>
        <c:if test="${good.REPRE_GOOD eq 'N'}">
        <tr>
          <th>상품구분</th>
          <td>
          <label><input ${good.GOOD_TYPE eq '10'?'checked':'disabled'} type="radio" style="vertical-align: middle;"/> 일반</label>
          <label><input ${good.GOOD_TYPE eq '20'?'checked':'disabled'} type="radio" style="vertical-align: middle;"/> 지정</label>
          </td>
          <th>재고관리</th>
          <td>
          <label><input ${good.STOCK_MNGT eq 'Y'?'checked':'disabled'} type="radio" style="vertical-align: middle;"/> 예</label>
          <label><input ${good.STOCK_MNGT eq 'N'?'checked':'disabled'} type="radio" style="vertical-align: middle;"/> 아니오</label>
          </td>
          <th>추가구성</th>
          <td>
          <label><input ${good.ADD_GOOD eq 'Y'?'checked':'disabled'} type="radio" style="vertical-align: middle;"/> 예</label>
          <label><input ${good.ADD_GOOD eq 'N'?'checked':'disabled'} type="radio" style="vertical-align: middle;"/> 아니오</label>
          </td>
        </tr>
        <tr>
          <th>최소주문수량</th>
          <td><input name="DELI_MINI_QUAN" value="${good.DELI_MINI_QUAN}" type="text" class="Ar" style="width:100px" value="10" ${good.GOOD_TYPE eq '20'?'readonly':'true'}/></td>
          <th rowspan="2">상품이미지</th>
          <td colspan="3" rowspan="2">
            <input id="ORIGINAL_IMG_PATH" name="ORIGINAL_IMG_PATH" value="${good.ORIGINAL_IMG_PATH}" type="hidden"/>
            <input id="LARGE_IMG_PATH" name="LARGE_IMG_PATH" value="${good.LARGE_IMG_PATH}" type="hidden"/>
            <input id="MIDDLE_IMG_PATH" name="MIDDLE_IMG_PATH" value="${good.MIDDLE_IMG_PATH}" type="hidden"/>
            <input id="SMALL_IMG_PATH" name="SMALL_IMG_PATH" value="${good.SMALL_IMG_PATH}" type="hidden"/>
            <c:if test="${empty good.SMALL_IMG_PATH}">
            <img id="img_SMALL_IMG_PATH" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border: 0px;vertical-align:bottom" />
            </c:if>
            <c:if test="${not empty good.SMALL_IMG_PATH}">
            <img id="img_SMALL_IMG_PATH" src="<%=Constances.SYSTEM_IMAGE_PATH%>/${good.SMALL_IMG_PATH}" alt="SMALL" style="border: 0px;vertical-align:bottom" width="50px"/>
            </c:if>
            <button id="btnAddImg" type="button" class="btn btn-darkgray btn-xs">등록</button>
            <button id="btnDelImg" type="button" class="btn btn-default btn-xs">삭제</button>
          </td>
        </tr>
        <tr>
          <th>제조사</th>
          <td><input name="MAKE_COMP_NAME" value="${good.MAKE_COMP_NAME}" type="text" style="width:120px" ${good.GOOD_TYPE eq '20'?'readonly="readonly"':''}/></td>
        </tr>
        <tr>
          <th>단가</th>
          <td colspan="5">
            <input name="SALE_UNIT_PRIC" value="<fmt:formatNumber value="${good.SALE_UNIT_PRIC}" pattern="#,###"/>" type="text" class="Ar" style="width:100px" readonly="readonly"/>
            <button type="button" goodid="${good.GOOD_IDEN_NUMB}" price="${good.SALE_UNIT_PRIC}" class="btn btn-darkgray btn-xs btnPrice" ${empty good.APPLT_FIX_CODE ? '':'disabled'}>단가변경요청</button>
            <button type="button" goodid="${good.GOOD_IDEN_NUMB}" class="btn btn-default btn-xs btnStop" ${empty good.APPLT_FIX_CODE ? '':'disabled'}>단종요청</button>
            ${good.APPLT_FIX_CODE eq '20' ? '단가변경요청중':''}${good.APPLT_FIX_CODE eq '30' ? '단종요청중':''}
          </td>
        </tr>
        <c:if test="${good.STOCK_MNGT eq 'Y'}">
        <tr>
          <th>재고</th>
          <td colspan="5">
            <input id="stock_${good.GOOD_IDEN_NUMB}" name="GOOD_INVENTORY_CNT" value="<fmt:formatNumber value="${good.GOOD_INVENTORY_CNT}" pattern="#,###"/>" type="text" class="Ar" style="width:100px" readonly="readonly"/>
            <button type="button" goodid="${good.GOOD_IDEN_NUMB}" class="btn btn-primary btn-xs btnStock">재고수량변경</button>
            <button type="button" goodid="${good.GOOD_IDEN_NUMB}" class="btn btn-default btn-xs btnHist">이력</button></td>
        </tr>
        </c:if>
        </c:if>
        <c:if test="${good.REPRE_GOOD eq 'Y'}">
        <tr>
          <th>상품구분</th>
          <td>
          <input ${good.GOOD_TYPE eq '10'?'checked':'disabled'} type="radio"/> <label for="radio">일반</label>
          <input ${good.GOOD_TYPE eq '20'?'checked':'disabled'} type="radio"/> <label for="radio">지정</label>
          </td>
          <th rowspan="2">상품이미지</th>
          <td colspan="3" rowspan="2">
            <input id="ORIGINAL_IMG_PATH" name="ORIGINAL_IMG_PATH" value="${good.ORIGINAL_IMG_PATH}" type="hidden"/>
            <input id="LARGE_IMG_PATH" name="LARGE_IMG_PATH" value="${good.LARGE_IMG_PATH}" type="hidden"/>
            <input id="MIDDLE_IMG_PATH" name="MIDDLE_IMG_PATH" value="${good.MIDDLE_IMG_PATH}" type="hidden"/>
            <input id="SMALL_IMG_PATH" name="SMALL_IMG_PATH" value="${good.SMALL_IMG_PATH}" type="hidden"/>
            <c:if test="${empty good.SMALL_IMG_PATH}">
                <img id="img_SMALL_IMG_PATH" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border: 0px;vertical-align:bottom" />
            </c:if>
            <c:if test="${not empty good.SMALL_IMG_PATH}">
                <img id="img_SMALL_IMG_PATH" src="<%=Constances.SYSTEM_IMAGE_PATH%>/${good.SMALL_IMG_PATH}" alt="SMALL" style="border: 0px;vertical-align:bottom" width="50px"/>
            </c:if>
            <button id="btnAddImg" type="button" class="btn btn-darkgray btn-xs">등록</button>
            <button id="btnDelImg" type="button" class="btn btn-default btn-xs">삭제</button>
          </td>
        </tr>
        <tr>
          <th>재고관리</th>
          <td>
          <input ${good.STOCK_MNGT eq 'Y'?'checked':'disabled'} type="radio" /> <label for="radio">예</label>
          <input ${good.STOCK_MNGT eq 'N'?'checked':'disabled'} type="radio" /> <label for="radio">아니오</label>
          </td>
        </tr>
        </c:if>
        <tr>
          <th>상품설명</th>
          <td colspan="5"><textarea id="GOOD_DESC" name="GOOD_DESC" required title="상품설명" style="height:150px;display:none">${good.GOOD_DESC}</textarea></td>
        </tr>
        <tr>
          <th>동의어</th><c:set var="same_word" value="${fn:split(good.GOOD_SAME_WORD, '‡')}" />
          <td colspan="5"><input id="GOOD_SAME_WORD1" value="${same_word[0]}" type="text" style="width:120px" />
          <input id="GOOD_SAME_WORD2" value="${same_word[1]}" type="text" style="width:120px" />
          <input id="GOOD_SAME_WORD3" value="${same_word[2]}" type="text" style="width:120px" />
          <input id="GOOD_SAME_WORD4" value="${same_word[3]}" type="text" style="width:120px" />
          <input id="GOOD_SAME_WORD5" value="${same_word[4]}" type="text" style="width:120px" /></td>
        </tr>
      </table>
      <div class="Ac mgt_10">
        <button id="btnSaveVen" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
        <button id="btnClose" type="button" class="btn btn-default btn-sm btnClose"><i class="fa fa-times"></i> 닫기</button>  
      </div>
      <c:if test="${good.REPRE_GOOD eq 'Y'}">
      <h3>공통옵션</h3>
      <div class="GridList">
        <table>
        <colgroup>
          <col width="60px" />
          <col width="250px" />
          <col width="auto" />
        </colgroup>
          <tr>
            <th>구분</th>
            <th>옵션명</th>
            <th>옵션값</th>
          </tr>
          <c:forEach var="data" items="${common}">
          <tr>
            <td align="center"><strong>옵션${data.OPTION_TYPE}</strong></td>
            <td align="center"><input type="text" style="width:220px" value="${data.OPTION_NAME}" readonly="readonly"/></td>
            <td align="center"><input type="text" style="width:96%" value="${data.OPTION_VALUE}" readonly="readonly"/></td>
          </tr>
          </c:forEach>
        </table>
      </div>
      <h3>규격옵션</h3>
      <div class="GridList">
        <table>
        <colgroup>
          <col width="auto" />
          <col width="200px" />
          <col width="250px" />
        </colgroup>
          <tr>
            <th>옵션(규격)</th>
            <th>단가</th>
            <th>재고</th>
          </tr>
          <c:forEach var="data" items="${option}">
          <tr>
            <td align="center"><input type="text" style="width:96%" value="${data.GOOD_SPEC}" readonly="readonly"/></td>
            <td align="center">
            <input type="text" class="Ar" style="width:80px" value="<fmt:formatNumber value="${data.SALE_UNIT_PRIC}" pattern="#,###"/>" readonly="readonly"/>
<%--             <button type="button" goodid="${data.GOOD_IDEN_NUMB}" price="${data.SALE_UNIT_PRIC}" class="btn btn-primary btn-xs btnPrice">단가변경요청</button>  --%>
            <button type="button" goodid="${data.GOOD_IDEN_NUMB}" class="btn btn-default btn-xs btnStop">단종요청</button></td>
            <td align="center">
            <input id="stock_${data.GOOD_IDEN_NUMB}" type="text" class="Ar" style="width:60px" value="<fmt:formatNumber value="${data.GOOD_INVENTORY_CNT}" pattern="#,###"/>" readonly="readonly"/>
            <button type="button" goodid="${data.GOOD_IDEN_NUMB}" class="btn btn-primary btn-xs btnStock">재고수량변경</button>
            <button type="button" goodid="${data.GOOD_IDEN_NUMB}" class="btn btn-default btn-xs btnHist">이력</button></td>
          </tr>
          </c:forEach>
        </table>
        </c:if>
      </div>
    </div>
  </div>
  </form>
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
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var oEditors = [];
$(function(){
    $.ajaxSetup ({cache: false});
    nhn.husky.EZCreator.createInIFrame({
         oAppRef: oEditors,
         elPlaceHolder: "GOOD_DESC",
         sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
    });
    new AjaxUpload($('#btnAddImg'), {
       action:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/imageResizeProcess.sys',
       name:'imageFile',
       data:{},
       onSubmit:function(file,ext) {
           if(!(ext && /^(jpg|jpeg|gif)$/.test(ext))) {
               alert('이미지 파일(jpg,jpeg,gif) 파일만 등록 가능합니다.');
              return false;
           }
          if(!confirm("이미지를 등록하시겠습니까?")) {
             return false;
          }
       },
       onComplete: function(file,response) {
          var result  = eval("(" +response + ")");

          var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.SMALL;
          $('#img_SMALL_IMG_PATH').attr('src',imgPathForSMALL);
          $('#ORIGINAL_IMG_PATH').val(result.ORGIN);
          $('#LARGE_IMG_PATH ').val(result.LARGE);
          $('#MIDDLE_IMG_PATH').val(result.MEDIUM);
          $('#SMALL_IMG_PATH ').val(result.SMALL);
          
          // 이미지 Grid 등록
          $('#ORIGINAL_IMG_PATH').change();
          
       }
    });

});
var goodid;
function fnStockCallBack(chgStock) {
	var value = $('#stock_'+goodid).val();
	
	if(value == ""){
		value = "0";
	}
	
	$('#stock_'+goodid).val(parseInt(value, 10) + parseInt(chgStock,10));
}

function funPopBigImage(){
	if($('#ORIGINAL_IMG_PATH').val()=='') {
		alert('이미지가 존재하지 않습니다.'); return;
	}
	$('#productPop').css({'width':'500px','top':'10%','left':'20%'}).html('')
	.load('/menu/product/product/popBigImage.sys?bigImage='+$('#ORIGINAL_IMG_PATH').val())
	.jqmShow(); 
}
</script>

</body>
</html>