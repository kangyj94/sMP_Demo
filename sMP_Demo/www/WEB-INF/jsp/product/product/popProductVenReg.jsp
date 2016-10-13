<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<!-- 상품팝업을 위해 추가한 CSS -->
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Global.css">
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">
<style>
label {padding:0}
input[readonly='readonly']{background-color: #F5F5F5;}
select[disabled] {background: #F5F5F5 !important;}
</style>
</head>
<body id="body">
  <div id="divPopup" style="width:900px; overflow: auto; ">
  <h1>상품등록요청</h1>
    <div class="popcont">
      <h3>공급사 상품등록요청 정보</h3>
      <form id="frm">
      <input id="oper" name="oper" value="${empty good ? 'ins':'upd'}" type="hidden"/>
      <input name="app_sts" value="${empty good ? '0':good.APP_STS}" type="hidden"/>
      <input name="req_good_id" value="${good.REQ_GOOD_ID}" type="hidden"/>
      <input name="vendorid" value="${sessionScope.sessionUserInfoDto.borgId}" type="hidden"/>
      <input id="good_same_word" name="good_same_word" type="hidden"/>
      <table class="InputTable">
      <colgroup>
        <col width="120px" />
        <col width="200px" />
        <col width="100px" />
        <col width="200px" />
        <col width="100px" />
        <col width="auto" />
      </colgroup>
        <tr>
          <th class="check">공급사</th>
          <td><input type="text" style="width:150px" value="${sessionScope.sessionUserInfoDto.borgNm}" readonly="readonly"/></td>
          <th>공급사코드</th>
          <td><input type="text" style="width:150px" value="${sessionScope.sessionUserInfoDto.borgCd}" readonly="readonly"/></td>
          <th>권역</th>
          <td><select name="areatype" style="width:100px" disabled>
            <c:forEach var="code" items="${deliAreaCodeList}">
                <option value="${code.codeVal1}" ${sessionScope.sessionUserInfoDto.areaType eq code.codeVal1 ? 'selected':''}>${code.codeNm1}</option>
            </c:forEach>
          </select></td>
        </tr>
        <tr>
          <th>대표자</th>
          <td><input type="text" style="width:150px" value="${ven.PRESSENTNM}" readonly="readonly"/></td>
          <th>연락처</th>
          <td><input type="text" style="width:150px" value="${ven.PHONENUM}" readonly="readonly"/></td>
          <th>처리상태</th>
          <td><select name="select" style="width:100px" disabled>
            <c:forEach var="code" items="${reqAppSts}">
                <option value="${code.codeVal1}"${good.APP_STS eq code.codeVal1 ? ' selected':''}>${code.codeNm1}</option>
            </c:forEach>
          </select></td>
        </tr>
        <tr>
          <th class="check">상품명</th>
          <td><input name="good_name" value="${good.GOOD_NAME}" required title="상품명" type="text" style="width:150px"/></td>
          <th>상품코드</th>
          <td><input name="good_iden_numb" value="${good.GOOD_IDEN_NUMB}" type="text" style="width:150px" readonly="readonly"/></td>
          <th class="check">단가</th>
          <td><input name="sale_unit_pric" value="<fmt:formatNumber value="${good.SALE_UNIT_PRIC}" pattern="####"/>" required title="단가" type="text" class="Ar" style="width:100px" requirednumber/></td>
        </tr>
        <tr>
          <th class="check">상품규격</th>
          <td colspan="5">
          	<table style="width: 100%">
				<tr>
					<td style="width: 99%">
						규격&nbsp;<input name="spec_spec" value="${good_spec.SPEC_SPEC}" title="상품규격" type="text" style="width:660px;" />
					</td>
				</tr>
				<tr>
					<td style="width: 99%">
						&nbsp;&nbsp;&nbsp;&nbsp;Ø&nbsp;<input name="spec_pi" value="${good_spec.SPEC_PI}" title="Ø" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
						W&nbsp;<input name="spec_width" value="${good_spec.SPEC_WIDTH}" title="W" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
						D&nbsp;<input name="spec_deep" value="${good_spec.SPEC_DEEP}" title="D" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
						H&nbsp;<input name="spec_height" value="${good_spec.SPEC_HEIGHT}" title="H" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
						L&nbsp;<input name="spec_liter" value="${good_spec.SPEC_LITER}" title="L" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
						t&nbsp;<input name="spec_ton" value="${good_spec.SPEC_TON}" title="t" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
						M(미터)&nbsp;<input name="spec_meter" value="${good_spec.SPEC_METER}" title="M(미터)" type="text" style="width:65px;" />&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
				<tr>
					<td style="width: 99%">
						재질&nbsp;<input name="spec_material" value="${good_spec.SPEC_MATERIAL}" title="재질" type="text" style="width:60px;" />&nbsp;&nbsp;
						크기&nbsp;<input name="spec_size" value="${good_spec.SPEC_SIZE}" title="크기" type="text" style="width:60px;" />&nbsp;&nbsp;
						색상&nbsp;<input name="spec_color" value="${good_spec.SPEC_COLOR}" title="색상" type="text" style="width:60px;" />&nbsp;&nbsp;
						TYPE&nbsp;<input name="spec_type" value="${good_spec.SPEC_TYPE}" title="TYPE" type="text" style="width:60px;" />&nbsp;&nbsp;
						총중량(KG,할증포함)&nbsp;<input name="spec_weight_sum" value="${good_spec.SPEC_WEIGHT_SUM}" title="총중량(KG,할증포함)" type="text" style="width:60px;" />&nbsp;&nbsp;
						실중량(KG)&nbsp;<input name="spec_weight_real" value="${good_spec.SPEC_WEIGHT_REAL}" title="실중량(KG)" type="text" style="width:60px;" />
					</td>
				</tr>
          	</table>
          
          </td>
        </tr>
        <tr>
          <th>제조사</th>
          <td><input name="make_comp_name" value="${good.MAKE_COMP_NAME}" type="text" style="width:150px"/></td>
          <th class="check">상품구분</th>
          <td><select name="good_clas_code" required title="상품구분" style="width:100px">
            <option value="">선택</option>
            <c:forEach var="code" items="${orderGoodsType}">
                <option value="${code.codeVal1}"${good.GOOD_TYPE eq code.codeVal1 ? ' selected':''}>${code.codeNm1}</option>
            </c:forEach>
          </select></td>
          <th>재고수량</th>
          <td><input name="good_inventory_cnt" value="<fmt:formatNumber value="${good.GOOD_INVENTORY_CNT}" pattern="####"/>" number title="재고수량" type="text" class="Ar" style="width:50px" requirednumber /></td>
        </tr>
        <tr>
          <th class="check">주문단위</th>
          <td><select id="orde_clas_code" name="orde_clas_code" required title="주문단위" style="width:100px">
            <option value="">선택</option>
            <c:forEach var="code" items="${orderUnit}">
                <option value="${code.codeVal1}"${good.ORDE_CLAS_CODE eq code.codeVal1 ? ' selected':''}>${code.codeNm1}</option>
            </c:forEach>
          </select></td>
          <th class="check">최소구매수량</th>
          <td><input name="deli_mini_quan" value="${good.DELI_MINI_QUAN}" requirednumber title="최소구매수량" type="text" class="Ar" style="width:100px" /></td>
          <th class="check">납품소요일</th>
          <td><input name="deli_mini_day" value="${good.DELI_MINI_DAY}" requirednumber title="납품소요일" type="text" class="Ar" style="width:50px" />
            일</td>
        </tr>
        <tr>
          <th>상품이미지</th>
          <td colspan="5" style="height:60px;">
            <input id="ORIGINAL_IMG_PATH" name="original_img_path" value="${good.ORIGINAL_IMG_PATH}" type="hidden"/>
            <input id="LARGE_IMG_PATH" name="large_img_path" value="${good.LARGE_IMG_PATH}" type="hidden"/>
            <input id="MIDDLE_IMG_PATH" name="middle_img_path" value="${good.MIDDLE_IMG_PATH}" type="hidden"/>
            <input id="SMALL_IMG_PATH" name="small_img_path" value="${good.SMALL_IMG_PATH}" type="hidden"/>
            <c:if test="${empty good.SMALL_IMG_PATH}">
            <img id="img_SMALL_IMG_PATH" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border: 0px;vertical-align:bottom" />
            </c:if>
            <c:if test="${not empty good.SMALL_IMG_PATH}">
            <img id="img_SMALL_IMG_PATH" src="<%=Constances.SYSTEM_IMAGE_PATH%>/${good.SMALL_IMG_PATH}"  alt="SMALL" style="border: 0px;vertical-align:bottom" />
            </c:if>
            <button id="btnAddImg" type="button" class="btn btn-darkgray btn-xs">등록</button>
            <button id="btnDelImg" type="button" class="btn btn-default btn-xs">삭제</button>
          </td>
        </tr>
        <tr>
          <th>상품설명</th>
          <td colspan="5"><textarea id="good_desc" name="good_desc" required title="상품설명" style="height:200px;display:none">${good.GOOD_DESC}</textarea></td>
        </tr>
        <tr>
          <th>동의어</th><c:set var="same_word" value="${fn:split(good.GOOD_SAME_WORD, '‡')}" />
          <td colspan="5"><input id="GOOD_SAME_WORD1" value="${same_word[0]}" type="text" style="width:120px" />
          <input id="GOOD_SAME_WORD2" value="${same_word[1]}" type="text" style="width:120px" />
          <input id="GOOD_SAME_WORD3" value="${same_word[2]}" type="text" style="width:120px" />
          <input id="GOOD_SAME_WORD4" value="${same_word[3]}" type="text" style="width:120px" />
          <input id="GOOD_SAME_WORD5" value="${same_word[4]}" type="text" style="width:120px" /></td>
        </tr>
        <tr>
          <th>공급사상품등록일</th>
          <td>${good.INSERT_DATE}</td>
          <th>상품 확인일</th>
          <td>${good.CREATE_GOOD_DATE}</td>
          <th>담당 운영자</th>
          <td>${good.ADMIN_USER}</td>
        </tr>
      </table>
      </form>
      <div class="Ac mgt_10">
        <c:if test="${empty good or good.APP_STS eq '0'}">
            <button id="btnSaveVen" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
        </c:if>
        <c:if test="${not empty good or good.APP_STS eq '0'}">
            <button id="btnDelVen" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-trash-o"></i> 삭제</button>
        </c:if>
        <button type="button" class="btn btn-default btn-sm btnClose"><i class="fa fa-times"></i> 닫기</button>  
      </div>
    </div>
  </div>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

var thisY = parseInt(document.body.scrollHeight);

if(thisY < 850){
	document.body.scroll = "yes";
	$("#body").css("overflow-x", "hidden");
}

var oEditors = [];
function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
}

$(function(){
    $.ajaxSetup ({cache: false});
    nhn.husky.EZCreator.createInIFrame({
         oAppRef: oEditors,
         elPlaceHolder: "good_desc",
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
    $('#btnDelImg').click(function () {
        $('#img_SMALL_IMG_PATH').attr('src','<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif');
        $('#ORIGINAL_IMG_PATH').val('');
        $('#LARGE_IMG_PATH').val('');
        $('#MIDDLE_IMG_PATH').val('');
        $('#SMALL_IMG_PATH').val('');
        $('#ORIGINAL_IMG_PATH').change();
    });
    $('#btnSaveVen').click(function () {
        oEditors.getById["good_desc"].exec("UPDATE_CONTENTS_FIELD", []);
        if (!$("#frm").validate()) {
            return;
        }
        var sameWord = $('#GOOD_SAME_WORD1').val()+"‡"+$('#GOOD_SAME_WORD2').val()+"‡"+$('#GOOD_SAME_WORD3').val()+"‡"+$('#GOOD_SAME_WORD4').val()+"‡"+$('#GOOD_SAME_WORD5').val();//상품동의어
        $('#good_same_word').val(sameWord);
        if (!confirm("상품 정보를 저장하시겠습니까?")) return;
        
        $('#good_desc').val(fnReplaceAll($("#good_desc").val(), unescape("%uFEFF"), ""));
        
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/vendorReqProductInfoTransGrid.sys', $("#frm").serialize(),
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
    $('#btnDelVen').click(function () {
        if (!confirm("상품 정보를 삭제하시겠습니까?")) return;
        $('#oper').val('del');
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/vendorReqProductInfoTransGrid.sys', $("#frm").serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  alert('상품 정보가 삭제되었습니다.');
                  window.opener.fnReLoadDataGrid();
                  window.close();
              } else {
                  alert('삭제 중 오류가 발생했습니다.');
              }
            }
        );  
    });
    $('.btnClose').click(function () {
        window.close();
    });
    $(document).on("blur", "input:text[requirednumber]", function() {
        $(this).number(true);
    });
    $('#img_SMALL_IMG_PATH').error( function() { $(this).attr("src", '<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif'); });
    
});



function auto_fit_size() {
	window.resizeTo(100, 100);
	var thisX = parseInt(document.body.scrollWidth);
	var thisY = parseInt(document.body.scrollHeight);
	var maxThisX = screen.width - 50;
	var maxThisY = screen.height - 50;
	var marginY = 0;
	//alert(thisX + "===" + thisY);
	//alert("임시 브라우저 확인 : " + navigator.userAgent);
	// 브라우저별 높이 조절. (표준 창 하에서 조절해 주십시오.)
	if (navigator.userAgent.indexOf("MSIE 6") > 0) marginY = 60; // IE 6.x
 	else if(navigator.userAgent.indexOf("MSIE 7") > 0) marginY = 80; // IE 7.x
	else if(navigator.userAgent.indexOf("Firefox") > 0) marginY = 50; // FF
	else if(navigator.userAgent.indexOf("Opera") > 0) marginY = 30; // Opera
	else if(navigator.userAgent.indexOf("Netscape") > 0) marginY = -2; // Netscape

	 if (thisX > maxThisX) {
	 window.document.body.scroll = "yes";
	 thisX = maxThisX;
	 }
	 if (thisY > maxThisY - marginY) {
	 window.document.body.scroll = "yes";
	 thisX += 19;
	 thisY = maxThisY - marginY;
	 }
	 window.resizeTo(thisX+10, thisY+marginY);
	} 




</script>
</body>
</html>