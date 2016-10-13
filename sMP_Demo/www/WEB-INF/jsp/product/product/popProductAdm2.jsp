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

Map good = (Map) request.getAttribute("good"); 
String skts_img = null;
if (good != null && good.get("SKTS_SMALL_IMG_PATH") != null && !good.get("SKTS_SMALL_IMG_PATH").equals("")) {
    skts_img = Constances.SYSTEM_IMAGE_PATH + "/" + good.get("SKTS_SMALL_IMG_PATH");
} else {
    skts_img = Constances.SYSTEM_IMAGE_URL + "/img/system/imageResize/prod_img_50.gif";
}
String repre_good = "N";
if ((request.getParameter("opt") != null) || (good != null && good.get("REPRE_GOOD").toString().equals("Y"))) {
	repre_good = "Y";			
}
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
    <h2><%=repre_good.equals("Y")?"옵션":""%>상품${empty good ? "등록":"수정"}</h2>
      <h3>상품기본정보</h3>
      <form id="frmGood">
	  <input type="hidden" name="req_good_id" value="${good.REQ_GOOD_ID}"/>
      <input type="hidden" id="good_iden_numb" name="good_iden_numb" value="${good.GOOD_IDEN_NUMB eq '0'?'':good.GOOD_IDEN_NUMB}"/>
	  <input type="hidden" name="repre_good" value="<%=repre_good%>"/>
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
          <th class="check" style="width:120px;">상품카테고리</th>
          <td colspan="5">
            <input id="majoCodeName" name="majoCodeName" value="${good.CATE_NM}" required title="상품카테고리" type="text" style="width:500px" readonly="readonly"/>
            <input id="cate_id" name="cate_id" value="${good.CATE_ID}" type="hidden" readonly="readonly" />
            <a id="btnCate" href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/icon_search.gif" width="20" height="20" /></a>
          </td>
        </tr>
        <tr>
          <th class="check">상품코드</th>
          <td id="td_good_iden_numb">${good.GOOD_IDEN_NUMB eq '0'?'':good.GOOD_IDEN_NUMB}</td>
          <th class="check" style="width:100px;">상품명</th>
          <td colspan="3"><input name="good_name" value="${good.GOOD_NAME}" required title="상품명" maxlength="100" type="text" style="width:300px" /></td>
        </tr>
        <tr>
          <th class="check">상품실적년/신규사업</th>
          <td>
	          <select name="good_reg_year">
	          <% for (int i=year; i>=2010; i--) { String reg_year = null; if (good != null) { reg_year = (String)good.get("GOOD_REG_YEAR"); } %>
	              <option <%=StringUtils.isNotEmpty(reg_year) ? i==Integer.parseInt(reg_year) ? "selected":"" : "" %>><%=i%></option>
	          <% } %>
	          </select>
            /
            <select name="new_busi" disabled="disabled">
              <option <%=good != null && "N".equals((String)good.get("NEW_BUSI")) ? "selected":""%>>N</option>
              <option <%=good != null && "Y".equals((String)good.get("NEW_BUSI")) ? "selected":""%>>Y</option>
            </select>
          </td>
          <th class="check">상품규격</th>
          <td colspan="3"><input name="good_spec" value="${good.GOOD_SPEC}" required title="상품규격" maxlength="100" type="text" style="width:300px" /></td>
        </tr>
        <tr>
          <th class="check">과세구분</th>
          <td>
	          <select name="vtax_clas_code" style="width:100px">
	            <% for (CodesDto code : vTaxTypeCode) { %>
	            <option value="<%=code.getCodeVal1()%>" <%=good != null && code.getCodeVal1().equals((String)good.get("VTAX_CLAS_CODE")) ? "selected":""%>><%=code.getCodeNm1()%></option>
	            <% } %>
	          </select>
	      </td>
          <th class="check">담당자</th>
          <td>
	          <select name="product_manager" required title="담당자" style="width:100px">
                <option value="">선택</option>
                <% for (Map code : productManager) { %>
                <option value="<%=code.get("USERID")%>" <%=good != null && code.get("USERID").equals((String)good.get("PRODUCT_MANAGER")) ? "selected":""%>><%=code.get("USERNM")%></option>                
	            <% } %>
	          </select>
	      </td>
          <th class="check">주문단위</th>
          <td>
              <select name="order_unit" required title="주문단위" style="width:100px">
                <option value="">선택</option>
                <% for (CodesDto code : orderUnit) { %>
                <option value="<%=code.getCodeVal1()%>" <%=good != null && code.getCodeVal1().equals((String)good.get("ORDER_UNIT")) ? "selected":""%>><%=code.getCodeNm1()%></option>
                <% } %>
              </select>
        </td>
        </tr>
        <tr>
          <th class="check">상품구분</th>
          <td>
              <% for (int i=0;i<orderGoodsType.size();i++) { %>
	          <label><input type="radio" class="input_none" name="good_type" value="<%=orderGoodsType.get(i).getCodeVal1()%>" <%=good != null ? (orderGoodsType.get(i).getCodeVal1().equals((String)good.get("GOOD_TYPE")) ? "checked":"") : (i==0?" checked":"")%>/> <%=orderGoodsType.get(i).getCodeNm1()%></label>
	          <% } %>
          </td>
          <th class="check">공급사노출</th>
          <td>
              <label><input type="radio" class="input_none" name="vendor_expose" value="Y" <%=good != null ? ("Y".equals((String)good.get("VENDOR_EXPOSE")) ? "checked":"") : "checked"%>/> 예</label>
              <label><input type="radio" class="input_none" name="vendor_expose" value="N" <%=good != null ? ("N".equals((String)good.get("VENDOR_EXPOSE")) ? "checked":"") : ""%>/> 아니오</label>
          </td>
          <th class="check">물량배분</th>
          <td>
              <% for (int i=0;i<isdistributeSts.size();i++) { %>
              <label><input type="radio" class="input_none" name="isdistribute" required title="물량배분" value="<%=isdistributeSts.get(i).getCodeVal1()%>" <%=good != null ? (isdistributeSts.get(i).getCodeVal1().equals((String)good.get("ISDISTRIBUTE")) ? "checked":"") : (i==0?" checked":"")%>/> <%=isdistributeSts.get(i).getCodeNm1()%></label>
              <% } %>
          </td>
        </tr>
        <tr>
          <th class="check">재고관리</th>
          <td>
              <label><input type="radio" class="input_none" name="stock_mngt" value="N" <%=good != null ? ("N".equals((String)good.get("STOCK_MNGT")) ? "checked":"") : "checked"%>/> 아니오</label>
              <label><input type="radio" class="input_none" name="stock_mngt" value="Y" <%=good != null ? ("Y".equals((String)good.get("STOCK_MNGT")) ? "checked":"") : ""%>/> 예</label>
          </td>
          <th rowspan="2" class="check">SKTS 이미지관리</th>
          <td colspan="3" rowspan="2">
          <div style="float:left;height:54px">
              <label><input type="radio" class="input_none" name="skts_img" value="N" <%=good != null ? ("N".equals((String)good.get("SKTS_IMG")) ? "checked":"") : "checked"%>/> 아니오</label>
              <label><input type="radio" class="input_none" name="skts_img" value="Y" <%=good != null ? ("Y".equals((String)good.get("SKTS_IMG")) ? "checked":"") : ""%>/> 예</label>
          </div>
          <div id="skts_img" style="float:right<%=good != null && "Y".equals((String)good.get("SKTS_IMG")) ? "":";display:none"%>">
            <img id="img_SKTS_SMALL_IMG_PATH" src="<%=skts_img%>" alt="SMALL" style="border: 0px;vertical-align:bottom" />
            <input id="SKTS_ORIGNAL_IMG_PATH" name="SKTS_ORIGNAL_IMG_PATH" value="${good.SKTS_ORIGNAL_IMG_PATH}" type="hidden"/>
            <input id="SKTS_LARGE_IMG_PATH" name="SKTS_LARGE_IMG_PATH" value="${good.SKTS_LARGE_IMG_PATH}" type="hidden"/>
            <input id="SKTS_MIDDLE_IMG_PATH" name="SKTS_MIDDLE_IMG_PATH" value="${good.SKTS_MIDDLE_IMG_PATH}" type="hidden"/>
            <input id="SKTS_SMALL_IMG_PATH" name="SKTS_SMALL_IMG_PATH" value="${good.SKTS_SMALL_IMG_PATH}" type="hidden"/>
            <textarea id="skts_good_desc" name="skts_good_desc" style="display:none">${good.SKTS_GOOD_DESC}</textarea>
            <button id="btnAddSKTSImg" type="button" class="btn btn-primary btn-xs">등록</button>
            <button id="btnDelSKTSImg" type="button" class="btn btn-default btn-xs">삭제</button>
            <button id="btnSKTSMngt" type="button" class="btn btn-default btn-xs"><i class="fa fa-cog"></i> 관리</button>
          </div>
          </td>
        </tr>
        <% if (!repre_good.equals("Y")) { %>
        <tr>
          <th class="check">추가구성</th>
          <td>
              <label><input type="radio" class="input_none" name="add_good" value="N" <%=good != null ? ("N".equals((String)good.get("ADD_GOOD")) ? "checked":"") : "checked"%>/> 아니오</label>
              <label><input type="radio" class="input_none" name="add_good" value="Y" <%=good != null ? ("Y".equals((String)good.get("ADD_GOOD")) ? "checked":"") : ""%>/> 예</label>
          </td>
        </tr>
        
        <tr id="add_good" <%=good != null && "Y".equals((String)good.get("ADD_GOOD")) ? "":"style='display:none'"%>>
			<th class="check">추가상품
				<div style="position:inherit; z-index:99;">
					<button id="btnAddGood" type="button" class="btn btn-gray btn-xs">추가</button>
					<button id="btnDelGood" type="button" class="btn btn-default btn-xs">삭제</button>
				</div>
			</th>
			<td colspan="5">
				<table width="100%">
					<tr>
						<th style="width: 100px;">설명</th>
						<td><input name="add_good_desc" value="${good.ADD_GOOD_DESC}" type="text" style="width:98%"/></td>
					</tr>
				</table>
				<div>
					<table id="list1" ></table>
				</div>
			</td>
		</tr>
        <% } %>
      </table>
      </form>
      <div class="Ac mgt_10">
        <button id="btnSaveGood" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 기본정보 저장</button>
        <button type="button" class="btn btn-default btn-sm btnClose"><i class="fa fa-times"></i> 닫기</button>  
      </div>
      <% if (repre_good.equals("Y")) { %>
      <form id="frmVendor">
      <input type="hidden" name="req_good_id" value="${good.REQ_GOOD_ID}"/>
      <input type="hidden" name="repre_good" value="<%=repre_good%>"/>
      <h3 style="float:left;margin-top:-1px">상품공급사</h3>
      <p class="Ar" style="margin-bottom:1px">
      	<button id="btnModVen" type="button" class="btn btn-primary btn-xs">보기/감추기</button>
        <button id="btnAddVen" type="button" class="btn btn-primary btn-xs">추가</button>
        <button id="btn1Ven" type="button" class="btn btn-default btn-xs" disabled>정상</button>
        <button id="btn0Ven" type="button" class="btn btn-default btn-xs" disabled>종료</button>
        <button id="btnDelVen" type="button" class="btn btn-default btn-xs" disabled>삭제</button>
      </p>
      <div>
      	<table id="list2" class="InputTable" style="padding:0;border:0"></table>
      </div>
      <table><tr><td height="5px;"></td></tr></table>
      <div id="goodVendorInput" style="display: none;">
	      <table id="tab-Input" class="InputTable" style="padding:0;border:0">
	      <colgroup>
	        <col width="10%" />
	        <col width="20%" />
	        <col width="10%" />
	        <col width="30%" />
	        <col width="10%" />
	        <col width="20%" />
	      </colgroup>
	        <tr>
	          <th class="check">공급사</th>
	          <td>
	              <input id="VENDORNM" name="VENDORNM" required title="공급사" type="text" style="width:130px" value="" readonly="readonly" />
	              <input id="ISNEW" name="ISNEW" type="hidden"/> 
	              <input id="ISCHANGE" name="ISCHANGE" type="hidden"/> 
	              <input id="VENDORID" name="VENDORID" type="hidden"/> 
	              <input id="AREATYPENM" name="AREATYPENM" type="hidden"/> 
	              <input id="PRESSENTNM" name="PRESSENTNM" type="hidden"/> 
	              <input id="PHONENUM" name="PHONENUM" type="hidden"/> 
	              <input id="ISUSE" name="ISUSE" type="hidden"/>
	              <a id="btnVendor" href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/icon_search.gif" width="20" height="20" /></a>
	          </td>
	          <th>연락처</th>
	          <td id="td_PHONENUM"></td>
	          <th class="check">표준납기</th>
	          <td><input id="DELI_MINI_DAY" name="DELI_MINI_DAY" requirednumber title="표준납기" type="text" style="width:50px;text-align: right;" value="" />일</td>
	        </tr>
	        <tr>
	          <th>물량배분율</th>
	          <td><input id="DISTRI_RATE" name="DISTRI_RATE" number title="물량배분율" type="text" style="width:50px;text-align: right;" value="" /> %</td>
	          <th>기본금액</th>
	          <td>
				판매가&nbsp;<input id="SELL_PRICE" name="SELL_PRICE" title="판매가" requirednumber type="text" style="width:70px;text-align: right;" />&nbsp;
				매입가&nbsp;<input id="SALE_UNIT_PRIC" name="SALE_UNIT_PRIC" title="매입가" requirednumber type="text" style="width:70px;text-align: right;" />&nbsp;             
	          </td>
	          <th rowspan=2>이미지</th>
	          <td rowspan=2>
	            <input id="ORIGINAL_IMG_PATH" name="ORIGINAL_IMG_PATH" type="hidden"/>
	            <input id="LARGE_IMG_PATH" name="LARGE_IMG_PATH" type="hidden"/>
	            <input id="MIDDLE_IMG_PATH" name="MIDDLE_IMG_PATH" type="hidden"/>
	            <input id="SMALL_IMG_PATH" name="SMALL_IMG_PATH" type="hidden"/>
	            <img id="img_SMALL_IMG_PATH" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border: 0px;vertical-align:bottom" />
	            <button id="btnAddImg" type="button" class="btn btn-gray btn-xs">등록</button>
	            <button id="btnDelImg" type="button" class="btn btn-default btn-xs">삭제</button>
	          </td>
	        </tr>
	        <tr>
	          <th>진열순위</th>
	          <td><input id="VENDOR_PRIORITY" name="VENDOR_PRIORITY" number title="진열순위" type="text" style="width:50px;text-align: right;" value="" /></td>
	          <th>추가금액</th>
	          <td>
				판매가&nbsp;<input id="SELL_ADD" name="SELL_ADD" title="판매가" requirednumber type="text" style="width:70px;text-align: right;" />&nbsp;
				매입가&nbsp;<input id="SALE_ADD" name="SALE_ADD" title="매입가" requirednumber type="text" style="width:70px;text-align: right;" />&nbsp;       
	          </td>
	        </tr>
	        <tr>
	          <th><button id="btnDesc" type="button" class="btn btn-gray btn-xs">상품설명</button></th>
	          <td colspan=5><div id="wrap_desc" style="height:0;overflow:hidden"><textarea id="GOOD_DESC" name="GOOD_DESC" required title="상세설명" style="height:200px;display:none;width: 100%;"></textarea></div></td>
	        </tr>
	        <tr>
	          <th>동의어</th>
	          <td colspan=5>
	            <input id="GOOD_SAME_WORD" name="GOOD_SAME_WORD" type="hidden" />
	            <input id="GOOD_SAME_WORD1" maxlength="90" type="text" style="width:100px" />
	            <input id="GOOD_SAME_WORD2" maxlength="90" type="text" style="width:100px" />
	            <input id="GOOD_SAME_WORD3" maxlength="90" type="text" style="width:100px" />
	            <input id="GOOD_SAME_WORD4" maxlength="90" type="text" style="width:100px" />
	            <input id="GOOD_SAME_WORD5" maxlength="90" type="text" style="width:100px" />
	          </td>
	        </tr>
	      </table>
	      <div class="Ac mgt_10">
	        <button id="btnSaveVendor" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 상품공급사 저장</button>
	        <button type="button" class="btn btn-default btn-sm btnClose"><i class="fa fa-times"></i> 닫기</button>  
	      </div>
      </div>
      <% } else { %>
      <h3>상품공급사</h3>
      <form id="frmVendor">
      <input type="hidden" name="req_good_id" value="${good.REQ_GOOD_ID}"/>
      <input type="hidden" name="repre_good" value="<%=repre_good%>"/>
      <table id="tab_vendor" width="100%">
      <colgroup>
        <col width="40%" />
        <col width="60%" />
      </colgroup>
        <tr>
          <td valign="top">
	          <p class="Ar" style="margin-bottom:1px">
	            <button id="btnAddVen" type="button" class="btn btn-primary btn-xs">추가</button>
	            <button id="btnCopyVen" type="button" class="btn btn-primary btn-xs" disabled>복사</button>
	            <button id="btn1Ven" type="button" class="btn btn-default btn-xs" disabled>정상</button>
	            <button id="btn0Ven" type="button" class="btn btn-default btn-xs" disabled>종료</button>
	            <button id="btnDelVen" type="button" class="btn btn-default btn-xs" disabled>삭제</button>
	          </p>
	          <div>
		          <table id="list2"></table>
	          </div>
          </td>
          <td rowspan="2" valign="top" class="pdl_10">
          	  <table><tr><td height="24px"></td></tr></table>
	          <table id="tab-Input" class="InputTable" style="border: 0px;">
	          <colgroup>
	            <col width="80px" />
	            <col width="auto" />
	            <col width="80px" />
	            <col width="auto" />
	          </colgroup>
	            <tr>
	              <th class="check">공급사</th>
	              <td>
	                  <input id="VENDORNM" name="VENDORNM" required title="공급사" type="text" style="width:130px" value="" readonly="readonly" />
	                  <input id="ISNEW" name="ISNEW" type="hidden"/> 
	                  <input id="ISCHANGE" name="ISCHANGE" type="hidden"/> 
	                  <input id="VENDORID" name="VENDORID" type="hidden"/> 
	                  <input id="AREATYPENM" name="AREATYPENM" type="hidden"/> 
	                  <input id="PRESSENTNM" name="PRESSENTNM" type="hidden"/> 
	                  <input id="PHONENUM" name="PHONENUM" type="hidden"/> 
	                  <input id="ISUSE" name="ISUSE" type="hidden"/>
	                  <a id="btnVendor" href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/icon_search.gif" width="20" height="20" /></a>
	              </td>
	              <th>소재지</th>
	              <td id="td_AREATYPENM"></td>
	            </tr>
	            <tr>
	              <th>대표자</th>
	              <td id="td_PRESSENTNM"></td>
	              <th>연락처</th>
	              <td id="td_PHONENUM"></td>
	            </tr>
	            <tr>
	              <th class="check">판매가</th>
	              <td>
	                <input id="SELL_PRICE" name="SELL_PRICE" title="판매가" requirednumber type="text" style="width:70px;text-align: right;" readonly="readonly" />
	                <button type="button" class="btn btn-gray btn-xs btnPriceChange" alt="SALE" disabled>변경</button>
	                <button type="button" class="btn btn-default btn-xs btnPriceChangeHist" alt="SALE" disabled>이력</button>
	              </td>
	              <th class="check">매입가</th>
	              <td>
	                <input id="SALE_UNIT_PRIC" name="SALE_UNIT_PRIC" title="매입가" requirednumber type="text" style="width:70px;text-align: right;" readonly="readonly" />
	                <button type="button" class="btn btn-gray btn-xs btnPriceChange" alt="BUY" disabled>변경</button>
	                <button type="button" class="btn btn-default btn-xs btnPriceChangeHist" alt="BUY" disabled>이력</button>
	              </td>
	            </tr>
	            <tr>
	              <th>이익율</th>
	              <td id="td_RATE">0%</td>
	              <th>진열순위</th>
	              <td><input id="VENDOR_PRIORITY" name="VENDOR_PRIORITY" number title="진열순위" type="text" style="width:50px;text-align: right;" value="" /></td>
	            </tr>
	            <tr>
	              <th class="check">최소주문수량</th>
	              <td><input id="DELI_MINI_QUAN" name="DELI_MINI_QUAN" requirednumber title="최소주문수량" type="text" style="width:50px;text-align: right;" value="" /></td>
	              <th class="check">재고</th>
	              <td>
	                <input id="GOOD_INVENTORY_CNT" name="GOOD_INVENTORY_CNT" title="재고" requirednumber type="text" style="width:70px;text-align: right;" readonly="readonly" />
	                <button id="btnStockChange" type="button" class="btn btn-gray btn-xs" disabled>변경</button>
	                <button id="btnStockChangeHist" type="button" class="btn btn-default btn-xs" disabled>이력</button>
	              </td>
	            </tr>
	            <tr>
	              <th class="check">표준납기</th>
	              <td><input id="DELI_MINI_DAY" name="DELI_MINI_DAY" requirednumber title="표준납기" type="text" style="width:50px;text-align: right;" value="" />일</td>
	              <th>물량배분율</th>
	              <td><input id="DISTRI_RATE" name="DISTRI_RATE" number title="물량배분율" type="text" style="width:50px;text-align: right;" value="" />
	                %</td>
	            </tr>
	            <tr>
	              <th>제조사</th>
	              <td colspan="3"><input id="MAKE_COMP_NAME" name="MAKE_COMP_NAME" type="text" style="width:150px" /></td>
	              <th class="check" style="display: none;">하도급</th>
	              <td style="display: none;">
	                <select id="ISSUB_ONTRACT" name="ISSUB_ONTRACT">
	                  <option value="0">아니오</option>
	                  <option value="1">예</option>
	              </select></td>
	            </tr>
	          </table>
          </td>
        </tr>
        <tr>
          <td valign="top" class="pdt_10">
          <table class="InputTable" style="border: 0px;">
            <colgroup>
              <col width="80px" />
              <col width="auto" />
            </colgroup>
            <tr>
              <th>이미지</th>
              <td>
                <input id="ORIGINAL_IMG_PATH" name="ORIGINAL_IMG_PATH" type="hidden"/>
                <input id="LARGE_IMG_PATH" name="LARGE_IMG_PATH" type="hidden"/>
                <input id="MIDDLE_IMG_PATH" name="MIDDLE_IMG_PATH" type="hidden"/>
                <input id="SMALL_IMG_PATH" name="SMALL_IMG_PATH" type="hidden"/>
                <img id="img_SMALL_IMG_PATH" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border: 0px;vertical-align:bottom" />
	            <button id="btnAddImg" type="button" class="btn btn-gray btn-xs">등록</button>
	            <button id="btnDelImg" type="button" class="btn btn-default btn-xs">삭제</button>
              </td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td colspan="2" class="pdt_10">
          <table class="InputTable" style="border: 0px;">
            <colgroup>
              <col width="80px" />
              <col width="auto" />
            </colgroup>
            <tr>
              <th><button id="btnDesc" type="button" class="btn btn-gray btn-xs">상품설명</button></th>
              <td><div id="wrap_desc" style="height:0;overflow:hidden"><textarea id="GOOD_DESC" name="GOOD_DESC" required title="상세설명" style="height:200px;display:none;width: 100%"></textarea></div></td>
            </tr>
            <tr>
              <th>동의어</th>
              <td>
                <input id="GOOD_SAME_WORD" name="GOOD_SAME_WORD" type="hidden" />
                <input id="GOOD_SAME_WORD1" maxlength="90" type="text" style="width:100px" />
                <input id="GOOD_SAME_WORD2" maxlength="90" type="text" style="width:100px" />
                <input id="GOOD_SAME_WORD3" maxlength="90" type="text" style="width:100px" />
                <input id="GOOD_SAME_WORD4" maxlength="90" type="text" style="width:100px" />
                <input id="GOOD_SAME_WORD5" maxlength="90" type="text" style="width:100px" />
              </td>
            </tr>
          </table></td>
        </tr>
      </table>
      <div class="Ac mgt_10">
        <button id="btnSaveVendor" type="button" class="btn btn-warning btn-sm"><i class="fa fa-floppy-o"></i> 상품공급사 저장</button>
        <button type="button" class="btn btn-default btn-sm btnClose"><i class="fa fa-times"></i> 닫기</button>  
      </div>
      <% } %>
      </form>
      <% if (repre_good.equals("Y")) { %>
      <h3>상품옵션</h3>
      <table width="100%">
        <colgroup>
          <col width="58%" />
          <col width="5px;" />
          <col width="40%" />
        </colgroup>
        <tr>
          <td valign="top">
	          <h4>규격관리</h4>
	          <div style="position:relative; margin-top:-23px; width:100%; text-align:right;margin-bottom:1px;">
	                <button id="btnAddOption" type="button" class="btn btn-primary btn-xs">추가</button>
	                <button id="btnRegOption" type="button" class="btn btn-primary btn-xs">등록</button>
	                <button id="btnOptionAll" type="button" class="btn btn-primary btn-xs">일괄등록</button>
                    <button id="btnUpdOption" type="button" class="btn btn-default btn-xs">수정</button>
	                <button id="btnDelOption" type="button" class="btn btn-default btn-xs">삭제</button>
	                &nbsp;&nbsp;&nbsp;
	          </div>
	          <div>
	              <table id="list5"></table>
	          </div>
          </td>
          <td></td>
          <td valign="top">
          	<h4>주문옵션</h4>
          	<div style="position:relative; margin-top:-23px; width:100%; text-align:right;margin-bottom:1px;">
          		<button id="btnSaveCommon" type="button" class="btn btn-warning btn-xs"><i class="fa fa-floppy-o"></i> 저장</button>
          		&nbsp;
          	</div>
            <div>
              <form id="frmCommon">
              <table id="list4" style="border: 0px;"></table>
              </form>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="3" valign="top" style="text-align: left;">
	          <h4 style="margin-top: 10px;">규격별 가격/재고관리</h4>
	          <div style="position:relative; margin-top:-25px; width:100%; text-align:right; margin-bottom:1px">
	          <select id="optVendor">
	            <option value="">공급사 조회</option>
	          </select>
	          <select id="optOption">
	            <option value="">옵션 조회</option>
	          </select>
	          <button id="btnOptionPriceAll" type="button" class="btn btn-primary btn-xs" style="margin-bottom: 3px;">일괄등록</button>
	          </div>
	          <div>
	            <table id="list6"></table>
	          </div>
          </td>
        </tr>
      </table>
      <% } %>
      <h3>상품진열</h3>
      <div>
        <table id="list3"></table>
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
		
	$('form').on('submit',function(){ return false; });
    $.ajaxSetup ({cache: false});
    nhn.husky.EZCreator.createInIFrame({
         oAppRef: oEditors,
         elPlaceHolder: "GOOD_DESC",
         sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
    });
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
	$('input[name=add_good]').click(function () {
		fnCheckAdd_good();
	});
    
    fnGridInit();
    $('#productPop').jqm();
    $('#btnCate').click(function()         {   fnCategoryPopOpen();                                                          });
    $("#majoCodeName").keydown(function(e) {   if(e.keyCode==13) { $("#btnCate").click(); }                                  });
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

     /**************************************
      * 상품기본정보 - SKTS이미지관리
      ***************************************/
    $('input[name=skts_img]').click(function () {
    	if ($(this).val() == 'Y') {
    		$('#skts_img').show();
    	} else {
            $('#skts_img').hide();
    		
    	}
    });
    $('#btnSKTSMngt').click(function () { // SKTS 이미지 관리
        $('#productPop').css({'width':'850px','top':'5%','left':'3%'}).html('')
        .load('/menu/product/product/popSktsImgMngt.sys')
        .jqmShow();
    });
    new AjaxUpload($('#btnAddSKTSImg'), {
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
           $('#img_SKTS_SMALL_IMG_PATH').attr('src',imgPathForSMALL);
           $('#SKTS_ORIGNAL_IMG_PATH').val(result.ORGIN);
           $('#SKTS_LARGE_IMG_PATH ').val(result.LARGE);
           $('#SKTS_MIDDLE_IMG_PATH').val(result.MEDIUM);
           $('#SKTS_SMALL_IMG_PATH ').val(result.SMALL);
        }
     });
     
     $('#btnDelSKTSImg').click(function () {
         $('#img_SKTS_SMALL_IMG_PATH').attr('src','<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif');
         $('#SKTS_ORIGNAL_IMG_PATH').val('');
         $('#SKTS_LARGE_IMG_PATH').val('');
         $('#SKTS_MIDDLE_IMG_PATH').val('');
         $('#SKTS_SMALL_IMG_PATH').val('');
     });
     <% if (!repre_good.equals("Y")) { %>
     /**************************************
      * 상품기본정보 - 추가구성
      **************************************/
      $('#btnAddGood').click(function () { // 추가상품 추가
          $('#productPop').css({'width':'600px','top':'30%','left':'3%'}).html('')
          .load('/menu/product/product/popProductSearch.sys')
          .jqmShow();
      });
      $('#btnDelGood').click(function () { // 추가상품 삭제
          var ids = $("#list1").jqGrid('getGridParam','selarrrow');
          if (ids.length == 0) {
              alert('선택한 상품이 없습니다.');
              return;
          }
          for (var i=ids.length;i>=0;i--) {
              $("#list1").delRowData(ids[i]);
          }
      });
    <% } %>
	/**************************************
	 * 상품기본정보 - 저장
	 **************************************/
    $('#btnSaveGood').click(function () {
    	if (!$("#frmGood").validate()) {
            return;
        }
        if (!confirm("상품기본정보를 저장하시겠습니까?")) return;
        var params = $('#frmGood').serialize();
        var params2 = "";
        var datas = $("#list1").jqGrid('getGridParam', 'data');
        for (var i in datas) {
        	params2 = params2 + "&add_good_iden_numb=" + datas[i].GOOD_IDEN_NUMB + "&vendorid=" + datas[i].VENDORID;    
        }
        params = params + params2;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveGood.sys', params,
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
            	  if (m.customResponse.newIdx) {
	            	  $('#good_iden_numb').val(m.customResponse.newIdx);
	                  $('#td_good_iden_numb').html(m.customResponse.newIdx);
            	  }
            	  alert('상품기본정보가 저장되었습니다.');
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
	
    /**************************************
     * 상품공급사 - 공급사 수정/추가/수정/삭제
     **************************************/
	$('#btnModVen').click(function (e) {
		var row = $("#list2").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
		if(row==null) { alert("수정 하실 상품공급사를 선택해 주십시오"); return; }
		$("#goodVendorInput").toggle();
	});
    $('#btnAddVen').click(function (e) {
        if (!checkProduct(e)) return false;
        if (!checkChange()) return false;
        var newRowId = $("#list2").getDataIDs().length+1;
        $("#list2").addRowData(newRowId, {VENDOR_PRIORITY:'0',DELI_MINI_QUAN:'1',DELI_MINI_DAY:'3',DISTRI_RATE:'0',GOOD_INVENTORY_CNT:'0',ISNEW:'A',ISUSE:'1'});
        $("#list2").setSelection(newRowId);
        fnSearchVendor(); 
        $("#ISCHANGE").val('C');
    });
    $('#btnCopyVen').click(function (e) {
        if (!checkVendor(e)) return false;
        if (!checkChange()) return false;
        var row = $('#list2').jqGrid('getGridParam','selrow');
        var data = $("#list2").jqGrid('getRowData',row);
        var newRowId = $("#list2").getDataIDs().length+1;
        data.VENDORID = '';
        data.VENDORNM = '';
        data.ISNEW = 'A';
        $("#list2").addRowData(newRowId, data);
        $("#list2").setSelection(newRowId);
        fnSearchVendor(); 
    });
    $('#btn1Ven').click(function (e) {
        if (!checkVendor(e)) return false;
        if (!checkChange()) return false;
        var row = $('#list2').jqGrid('getGridParam','selrow');
        var isUse = $('#list2').getCell(row, 'ISUSE');
        if (isUse == '1') {
        	alert("현재 '정상' 상태입니다.");
        	return;
        }
        var isnew = $('#ISNEW').val();
        if (isnew == 'A') {
            alert("먼저 상품공급사 정보를 저장해주세요.");
            return;
        }
        if (!confirm("정말로 상태를 '정상'으로 변경하시겠습니까?")) return;        
        var params = "good_iden_numb=" + $('#good_iden_numb').val() + '&vendorid=' + $('#VENDORID').val() + '&use=1';
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/chgVendor.sys', params,
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
            	  $('#list2').setCell(row, 'ISUSE', '1');
                  $('#btn0Ven').attr('disabled',false);
                  $('#btn1Ven').attr('disabled',true);
                  $('#btnDelVen').attr('disabled',true);
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
    $('#btn0Ven').click(function (e) {
        if (!checkVendor(e)) return false;
        if (!checkChange()) return false;
        var row = $('#list2').jqGrid('getGridParam','selrow');
        var isUse = $('#list2').getCell(row, 'ISUSE');
        if (isUse == '0') {
            alert("현재 '종료' 상태입니다.");
            return;
        }
        var isnew = $('#ISNEW').val();
        if (isnew == 'A') {
            alert("먼저 상품공급사 정보를 저장해주세요.");
            return;
        }
        if (!confirm("정말로 상태를 '종료'로 변경하시겠습니까?")) return;        
        var params = "good_iden_numb=" + $('#good_iden_numb').val() + '&vendorid=' + $('#VENDORID').val() + '&use=0';
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/chgVendor.sys', params,
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  $('#list2').setCell(row, 'ISUSE', '0');
                  $('#btn0Ven').attr('disabled',true);
                  $('#btn1Ven').attr('disabled',false);
                  $('#btnDelVen').attr('disabled', false);
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
    $('#btnDelVen').click(function (e) {
        if (!checkVendor(e)) return false;
        if (!confirm("정말로 선택한 공급사를 삭제하시겠습니까?")) return;
        var isnew = $('#ISNEW').val();
        var row = $('#list2').jqGrid('getGridParam','selrow');
        if (isnew == 'A') {
            $("#list2").delRowData(row);
            $('#frmVendor').find('input,select,textarea').val('');
            $('#td_AREATYPENM, #td_PRESSENTNM, #td_PHONENUM').html('');
            g_rowid = -1;
            $("#list2").setSelection(row-1);
        } else {
	        var params = "good_iden_numb=" + $('#good_iden_numb').val() + '&vendorid=' + $('#VENDORID').val() + '&repre_good=<%=repre_good%>';
	        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/delVendor.sys', params,
	            function(msg) {
	              var m = eval('(' + msg + ')');
	              if (m.customResponse.success) {
	                  $("#list2").delRowData(row);
                      <% if (repre_good.equals("Y")) { %>
                        $('#optVendor option[value='+$('#VENDORID').val()+']').remove();
                        reloadList6();
                      <% } %>
	                  $('#frmVendor').find('input,select,textarea').val('');
	                  $('#td_AREATYPENM, #td_PRESSENTNM, #td_PHONENUM').html('');
	                  $("input[name='repre_good']").val('<%=repre_good%>');
	                  g_rowid = -1;
	                  $("#list2").setSelection(row-1);
                      $('#list3').setGridParam({"postData":$('#frmGood').serializeObject()}).trigger("reloadGrid");
	              } else {
	                  alert('저장 중 오류가 발생했습니다.');
	              }
	            }
	        );  
        }
        $('#btnAddVen').attr('disabled', false);
        var cnt = $("#list2").jqGrid('getDataIDs').length;
        if (cnt == 0) {
            $('#btn1Ven').attr('disabled', true);
            $('#btn0Ven').attr('disabled', true);
            $('#btnCopyVen').attr('disabled', true);
            $('#btnDelVen').attr('disabled', true);
        }
    });
    $('#frmVendor').find('input,select,textarea').keypress(function (e) {
        if (!checkVendor(e)) return false;
    });
    $('#frmVendor').find('input,select,textarea').change(function (e) {
        if (!checkVendor(e)) return false;
        $('#ISCHANGE').val('C');    
    });
    $("#btnVendor").click(  function(e) { 
        if (!checkVendor(e)) return false;
        fnSearchVendor(); 
    });   
    $('.btnPriceChange').click(function (e) { // 가격변경
        if (!checkVendor(e)) return false;
        priceType = $(this).attr('alt');
        $('#productPop').css({'width':'600px','top':'50%','left':'20%'}).html('')
        .load('/menu/product/product/popPriceChange.sys?good_iden_numb='+$('#good_iden_numb').val()+'&vendorid='+$('#VENDORID').val()+'&sell_sale_type='+priceType)
        .jqmShow();
    });
    $('.btnPriceChangeHist').click(function (e) { // 가격변경이력조회
        if (!checkVendor(e)) return false;
        priceType = $(this).attr('alt');
        $('#productPop').css({'width':'600px','top':'50%','left':'20%'}).html('')
        .load('/menu/product/product/popPriceChangeHist.sys?good_iden_numb='+$('#good_iden_numb').val()+'&vendorid='+$('#VENDORID').val()+'&sell_sale_type='+priceType)
        .jqmShow();
    });
    $('#btnStockChange').click(function (e) { // 재고변경
        if (!checkVendor(e)) return false;
        stockType = 'LIST2';
        $('#productPop').css({'width':'600px','top':'60%','left':'20%'}).html('')
        .load('/menu/product/product/popStockChange.sys?good_iden_numb='+$('#good_iden_numb').val()+'&vendorid='+$('#VENDORID').val())
        .jqmShow();
    });
    $('#btnStockChangeHist').click(function (e) { // 재고변경이력조회
        if (!checkVendor(e)) return false;
        $('#productPop').css({'width':'600px','top':'60%','left':'20%'}).html('')
        .load('/menu/product/product/popStockChangeHist.sys?good_iden_numb='+$('#good_iden_numb').val()+'&vendorid='+$('#VENDORID').val())
        .jqmShow();
    });
    
    /**************************************
     * 상품공급사 - 저장
     **************************************/
    $('#btnSaveVendor').click(function (e) {
        if (!checkVendor(e)) return false;
    	oEditors.getById["GOOD_DESC"].exec("UPDATE_CONTENTS_FIELD", []);
    	if (!$("#frmVendor").validate()) {
            return;
        }
    	var sameWord = $('#GOOD_SAME_WORD1').val()+"‡"+$('#GOOD_SAME_WORD2').val()+"‡"+$('#GOOD_SAME_WORD3').val()+"‡"+$('#GOOD_SAME_WORD4').val()+"‡"+$('#GOOD_SAME_WORD5').val();//상품동의어
    	$('#GOOD_SAME_WORD').val(sameWord);
        if (!confirm("상품공급사 정보를 저장하시겠습니까?")) return;
        
        $('#GOOD_DESC').val(fnReplaceAll($("#GOOD_DESC").val(), unescape("%uFEFF"), ""));
        
        var params = "good_iden_numb=" + $('#good_iden_numb').val() + '&' + $('#frmVendor').serialize();
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveVendor.sys', params,
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  $('#ISCHANGE').val('');
                  var data = $('#frmVendor').find('input,select,textarea').serializeJSON();
                  $("#list2").jqGrid('setRowData',$("#list2").getGridParam("selrow"), data);
                  $('#list3').setGridParam({"postData":$('#frmGood').serializeObject()}).trigger("reloadGrid");
                  $('#btnCopyVen').attr('disabled', false);
                  <% if (!repre_good.equals("Y")) { %>
		          $('#SELL_PRICE').attr('readonly', true);
		          $('#SALE_UNIT_PRIC').attr('readonly', true);
		          <% } %>
		          $('#GOOD_INVENTORY_CNT').attr('readonly', true);
		          $('#tab-Input button').attr('disabled', false);
		          $('#btnAddVen').attr('disabled', false);
		          if ($('#ISUSE').val() == '1') {
		              $('#btn0Ven').attr('disabled', false);
		              $('#btn1Ven').attr('disabled', true);
		              $('#btnDelVen').attr('disabled',true);
		          } else if ($('#ISUSE').val() == '0') {
		              $('#btn0Ven').attr('disabled', true);
		              $('#btn1Ven').attr('disabled', false);
                      $('#btnDelVen').attr('disabled',false);
		          } 
	              <% if (repre_good.equals("Y")) { %>
	              if ($('#ISNEW').val()=='A') {
                    $('#optVendor').append("<option value='"+$('#VENDORID').val()+"'>"+$('#VENDORNM').val()+"</option>");
	              }
                  reloadList6();
                  <% } %>
                  $('#ISNEW').val('U');
                  alert('상품공급사 정보가 저장되었습니다.');
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        ).fail(function() {
		    alert( "동일한 공급사가 존재합니다. 공급사를 확인해주세요." );
		});  
    });
    $('.btnClose').click(function () {
    	window.close();
    });
    
    /**************************************
     * 상품옵션 - 공통옵션 저장
     **************************************/
    $('#btnSaveCommon').click(function (e) {
        if (!checkProduct(e)) return false;
        var params = "good_iden_numb=" + $('#good_iden_numb').val() + '&' + $('#frmCommon').serialize();
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveCommon.sys', params,
            function(msg) {
                var m = eval('(' + msg + ')');
                if (m.customResponse.success) {
                    alert('공통옵션이 저장되었습니다.');
                } else {
                    alert('저장 중 오류가 발생했습니다.');
                }
            }
        );  
    });
    
    /**************************************
     * 상품옵션 - 규격옵션 
     **************************************/
    $('#btnAddOption').click(function () { // 상품옵션 추가
        $('#productPop').css({'width':'600px','top':'90%','left':'3%'}).html('')
        .load('/menu/product/product/popOptionProductSearch.sys?good_iden_numb='+$('#good_iden_numb').val())
        .jqmShow();
    });
    $('#btnUpdOption').click(function () { // 상품옵션 수정
        var ids = $("#list5").jqGrid('getGridParam','selarrrow');
        if (ids.length == 0) {
            alert('선택한 규격옵션이 없습니다.');
            return;
        }
        var params = "repre_good_iden_numb=" + $('#good_iden_numb').val();
        for (var id in ids) {
            var data = $("#list5").jqGrid('getRowData',ids[id]);
            var good_spec = $('#' + ids[id] + '_GOOD_SPEC').val();
            if (good_spec == '') {
                alert('옵션(규격)을 입력해주세요.');
                $('#' + ids[id] + '_GOOD_SPEC').focus();
                return;
            }
            var pims = $('#' + ids[id] + '_PIMS').val();
            if (pims == '') {
                alert('단가코드를 입력해주세요.');
                $('#' + ids[id] + '_PIMS').focus();
                return;
            }
            if(isNaN(pims)) {
                alert('단가코드를 숫자로만 입력해주세요.');
                $('#' + ids[id] + '_PIMS').focus();
                return;
            }
            params = params + "&good_iden_numb=" + data.GOOD_IDEN_NUMB + "&good_spec=" + good_spec + "&pims=" + pims;
        }
        if (!confirm("정말로 선택한 규격옵션을 수정하시겠습니까?")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/updOption.sys', params,
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  reloadList5();
                  reloadList6();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );
    });
    $('#btnDelOption').click(function () { // 상품옵션 삭제
        var ids = $("#list5").jqGrid('getGridParam','selarrrow');
        if (ids.length == 0) {
            alert('선택한 규격옵션이 없습니다.');
            return;
        }
        if (!confirm("정말로 선택한 규격옵션을 삭제하시겠습니까?")) return;
        var params = "r=1";
        for (var i=0;i<ids.length;i++) {
            var data = $("#list5").jqGrid('getRowData',ids[i]);
            params = params + "&good_iden_numb=" + data.GOOD_IDEN_NUMB;
        }
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/delOption.sys', params,
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  for (var i=ids.length;i>=0;i--) {
                      var data = $("#list5").jqGrid('getRowData',ids[i]);
                      $('#optOption option[value='+data.GOOD_IDEN_NUMB+']').remove();
                      $("#list5").delRowData(ids[i]);
                  }
                  reloadList6();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );
    });
     // 상세설명
     $('#btnDesc').click(function () {
    	 if ($('#wrap_desc').css('height') == '0px') {
            $('#wrap_desc').css('height', 'inherit'); 
    	 } else {
    		$('#wrap_desc').css('height', '0'); 
    	 }
     });
    
    <% if (repre_good.equals("Y")) { %>
    $('#btnRegOption').click(function () {
	    $('#productPop').css({'width':'600px','top':'90%','left':'3%'}).html('')
        .load('/menu/product/product/popOptionChange.sys?good_iden_numb='+$('#good_iden_numb').val())
	    .jqmShow();	
    });
    $('#optVendor').change(function () {
    	reloadList6();
    });
    $('#optOption').change(function () {
    	reloadList6();
    });
    $('#btnOptionPriceAll').click(function () {
        $('#productPop').css({'width':'600px','top':'90%','left':'20%'}).html('')
        .load('/menu/product/product/popOptionPriceAll.sys?good_iden_numb='+$('#good_iden_numb').val())
        .jqmShow(); 
    });
    $('#btnOptionAll').click(function () {
        $('#productPop').css({'width':'600px','top':'90%','left':'20%'}).html('')
        .load('/menu/product/product/popOptionAll.sys?good_iden_numb='+$('#good_iden_numb').val())
        .jqmShow(); 
    });
    <% } %>
});
function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
} 

var g_rowid = -1;
//그리드 초기화
function fnGridInit() {
    $("#list1").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectAddGoodList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['상품코드','상품명','상품규격','공급사','판매가','매입가',''],
        colModel:[
            {name:'GOOD_IDEN_NUMB',width:80,align:'center',sortable:false},//상품코드
            {name:'GOOD_NAME',width:160,sortable:false},//상품명
            {name:'GOOD_SPEC',width:150},//상품규격
            {name:'VENDORNM',width:100},//공급사
            {name:'SELL_PRICE',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//판매가
            {name:'SALE_UNIT_PRIC',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//매입가
            {name:'VENDORID',hidden:true}
        ],
        rowNum:0,
        postData: $('#frmGood').serializeObject(),
        height:100,width:690,
        sortname: 'GOOD_IDEN_NUMB', sortorder: 'desc', multiselect: true,
        viewrecords:true, emptyrecords:'Empty records', loadonce: true, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list1").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    });
    $("#list2").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectGoodVendorListFor${empty good.REQ_GOOD_ID and empty good.BIDID?"New":""}${empty good.REQ_GOOD_ID?"":"Req"}${empty good.BIDID?"":"Bid"}/list.sys',
        datatype: 'json',
        mtype: 'POST',
        <% if (repre_good.equals("Y")) { %>
        colNames:['순위','공급사','물량<br/>배분율(%)','상태','연락처','납품<br/>소요일','이미지','판매가','매입가','판매가','매입가','','','','','','','','','','','','','','',''],
        colModel:[
            {name:'VENDOR_PRIORITY',width:30,align:'center',sortable:false},//순위
            {name:'VENDORNM',width:150,sortable:false},//공급사
            {name:'DISTRI_RATE',width:70,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//배분율
            {name:'ISUSE',width:40,align:'center',sortable:false,formatter:'select',editoptions:{value:"0:종료;1:정상;2:대기"}},//상태
            {name:'PHONENUM',width:110,align:'center'},//연락처
            {name:'DELI_MINI_DAY',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//표준납기
            {name:'IMAGE_YN',width:50,align:'center',sortable:false},//이미지
            {name:'SELL_PRICE',width:70,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//판매가
            {name:'SALE_UNIT_PRIC',width:70,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//매입가
            {name:'SELL_ADD',width:70,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//판매가
            {name:'SALE_ADD',width:70,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//매입가
            {name:'VENDORID',hidden:true},
            {name:'AREATYPENM',hidden:true},
            {name:'PRESSENTNM',hidden:true},
            {name:'DELI_MINI_QUAN',hidden:true},
            {name:'DELI_MINI_DAY',hidden:true},
            {name:'GOOD_INVENTORY_CNT',hidden:true},
            {name:'MAKE_COMP_NAME',hidden:true},
            {name:'ISSUB_ONTRACT',hidden:true},
            {name:'ORIGINAL_IMG_PATH',hidden:true},
            {name:'SMALL_IMG_PATH',hidden:true},
            {name:'MIDDLE_IMG_PATH',hidden:true},
            {name:'LARGE_IMG_PATH',hidden:true},
            {name:'GOOD_DESC',hidden:true},
            {name:'GOOD_SAME_WORD',hidden:true},
            {name:'ISNEW',hidden:true}
        ],
        afterInsertRow: function(rowid, aData) {
        	var data = $(this).jqGrid('getRowData',rowid);
        	if(aData.ORIGINAL_IMG_PATH) {
        		$(this).setCell(rowid, 'IMAGE_YN', "Y");
        	}
        },
        <% } else { %>
        colNames:['순위','공급사','판매가','매입가','배분율(%)','상태','','','','','','','','','','','','','','','','',''],
        colModel:[
            {name:'VENDOR_PRIORITY',width:30,align:'center',sortable:false},//순위
            {name:'VENDORNM',width:90,sortable:false},//공급사
            {name:'SELL_PRICE',width:48,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//판매가
            {name:'SALE_UNIT_PRIC',width:48,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//매입가
            {name:'DISTRI_RATE',width:57,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//배분율
            {name:'ISUSE',width:40,align:'center',sortable:false,formatter:'select',editoptions:{value:"0:종료;1:정상;2:대기"}},//상태
            {name:'VENDORID',hidden:true},
            {name:'AREATYPENM',hidden:true},
            {name:'PRESSENTNM',hidden:true},
            {name:'PHONENUM',hidden:true},
            {name:'DELI_MINI_QUAN',hidden:true},
            {name:'DELI_MINI_DAY',hidden:true},
            {name:'GOOD_INVENTORY_CNT',hidden:true},
            {name:'DELI_MINI_DAY',hidden:true},
            {name:'MAKE_COMP_NAME',hidden:true},
            {name:'ISSUB_ONTRACT',hidden:true},
            {name:'ORIGINAL_IMG_PATH',hidden:true},
            {name:'SMALL_IMG_PATH',hidden:true},
            {name:'MIDDLE_IMG_PATH',hidden:true},
            {name:'LARGE_IMG_PATH',hidden:true},
            {name:'GOOD_DESC',hidden:true},
            {name:'GOOD_SAME_WORD',hidden:true},
            {name:'ISNEW',hidden:true}
        ],
        <% } %>
        rowNum:0,
        postData: $('#frmGood').serializeObject(),
        height:130,width:<%=repre_good.equals("Y")?"868":"347"%>,
        sortname: 'VENDOR_PRIORITY', sortorder: 'asc',
        loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        beforeSelectRow:function(rowid,e) {
            if (g_rowid == rowid) return true;
        	if (!checkChange()) {
        		return false;
        	}
            return true;
        },
        onSelectRow:function(rowid,iRow,iCol,e) {
            if (g_rowid == rowid) return true;
        	g_rowid = rowid;
            var data = $(this).jqGrid('getRowData',rowid);
            bindVendor(data);
        },
        loadComplete: function() {
            var $this = $(this), ids = $this.jqGrid('getDataIDs'), i, l = ids.length;
            for (i = 0; i < l; i++) {
                var selrowContent = $this.jqGrid('getRowData',ids[i]);
                <% if (repre_good.equals("Y")) { %>
                $('#optVendor').append("<option value='"+selrowContent.VENDORID+"'>"+selrowContent.VENDORNM+"</option>");
                <% } %>
                if (selrowContent.VENDORID == '${not empty good.VENDORID ? good.VENDORID : param.vendorid}') {
                    $this.setSelection(ids[i]);
                }
            }    
        }
    });
    <% if (repre_good.equals("Y")) { %>
    $("#list2").jqGrid('setGroupHeaders', {
	  useColSpanStyle: true, 
	  groupHeaders:[
	    {startColumnName: 'SELL_PRICE', numberOfColumns: 2, titleText: '기본금액'},
	    {startColumnName: 'SELL_ADD', numberOfColumns: 2, titleText: '추가금액'}
	  ]
	});
    <% } %>
    $("#list3").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectGoodVendorListForMngt/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['공급사','관리','권역','고객유형','사업장',''],
        colModel:[
            {name:'VENDORNM',width:130,sortable:false},//공급사
            {name:'MNGT',width:40,align:'center',sortable:false},//관리
            {name:'DELI',width:100},//권역
            {name:'WORK',width:200},//고객유형
            {name:'BRANCH',width:360},//사업장
            {name:'VENDORID',hidden:true}
        ],
        rowNum:0,
        postData: $('#frmGood').serializeObject(),
        height:100,width:868,
        sortname: 'VENDOR_PRIORITY', sortorder: 'asc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list3").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	$(this).setCell(rowid, 'MNGT', "<button type='button' class='btn btn-default btn-xs'>관리</button>");
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
            var selrowContent = $(this).jqGrid('getRowData',rowid);
            var cm = $(this).jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="MNGT") {
            	popVendorNm = selrowContent.VENDORNM;
                $('#productPop').css({'width':'600px','top':'70%','left':'20%'}).html('')
                .load('/product/popDisplayMngt.sys?good_iden_numb='+$('#good_iden_numb').val()+'&vendorid='+selrowContent.VENDORID)
                .jqmShow();
            }
        }
    });
    <% if (repre_good.equals("Y")) { %>
    $("#list4").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectCommonOptionList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['구분','옵션명','옵션값(“;” 로 구분)',''],
        colModel:[
            {name:'OPTION_TYPE',width:60,align:'center',sortable:false,formatter:'select',editoptions:{value:"1:옵션1;2:옵션2;3:옵션3"}},//구분
            {name:'OPTION_NAME',width:100,sortable:false,editable:true,editoptions:{size:"14",maxlength:"30"}},//옵션명
            {name:'OPTION_VALUE',width:180,sortable:false,editable:true,edittype:"textarea", editoptions:{rows:"2",cols:"30"}},//옵션값
            {name:'GOOD_COMMON_OPTION_ID',hidden:true,editable:true}
        ],
        rowNum:0,
        postData: $('#frmGood').serializeObject(),
        height:135,width:360,
        sortname: 'OPTION_TYPE', sortorder: 'asc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: true, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list4").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	$(this).setCell(rowid,'OPTION_VALUE','',{height:'43px'});
        },
        loadComplete: function () {
            var $this = $(this), ids = $this.jqGrid('getDataIDs'), i, l = ids.length;
            for (i = 0; i < l; i++) {
                $this.jqGrid('editRow', ids[i], true);
            }
            $('input[name=good_name]').focus();
        }
    });
    $("#list5").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectSpecOptionList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['옵션코드','옵션(규격)','단가코드'],
        colModel:[
            {name:'GOOD_IDEN_NUMB',width:100,align:'center',sortable:false},//옵션코드
            {name:'GOOD_SPEC',width:280,sortable:false,editable:true},//옵션명
            {name:'PIMS',width:60,align:'center',sortable:false,editable:true}//PIMS
        ],
        rowNum:0,
        postData: $('#frmGood').serializeObject(),
        height:135,width:500,multiselect: true,
        sortname: '', sortorder: 'asc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list5").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
            //$(this).setCell(rowid,'GOOD_IDEN_NUMB','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        },
        onSelectRow: function(id, status) {
          if (status) {
           $('#list5').editRow(id, status);
          } else {
           $('#list5').restoreRow(id, status);      
          }
            var selrowContent = $(this).jqGrid('getRowData',rowid);
        	$(this).jqGrid('editRow', selrowContent, true);
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
        	return;
            var cm = $(this).jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="GOOD_IDEN_NUMB") {
                $('#productPop').css({'width':'600px','top':'90%','left':'3%'}).html('')
                .load('/menu/product/product/popOptionChange.sys?good_iden_numb='+$('#good_iden_numb').val()+'&rowid='+rowid)
                .jqmShow();
            }
        },
        loadComplete: function() {
            var $this = $(this), ids = $this.jqGrid('getDataIDs'), i, l = ids.length;
            for (i = 0; i < l; i++) {
                var selrowContent = $this.jqGrid('getRowData',ids[i]);
                $('#optOption').append("<option value='"+selrowContent.GOOD_IDEN_NUMB+"'>"+selrowContent.GOOD_SPEC+"</option>");
            }
        }
    });
    $("#list6").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectSpecOptionVendorList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['옵션(규격)','공급사','판매가','변경/이력','매입가','변경/이력','재고','변경/이력','',''],
        colModel:[
            {name:'GOOD_SPEC',width:200,align:'left',sortable:false},//옵션(규격)
            {name:'VENDORNM',width:120,sortable:false},//공급사
            {name:'SELL_PRICE',width:80,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//판매가
            {name:'SELL_PRICE_MNGT',width:80,align:'center',sortable:false},//판매가관리
            {name:'SALE_UNIT_PRIC',width:80,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//매입가
            {name:'SALE_UNIT_PRIC_MNGT',width:80,align:'center',sortable:false},//매입가관리
            {name:'GOOD_INVENTORY_CNT',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//재고
            {name:'GOOD_INVENTORY_CNT_MNGT',width:80,align:'center',sortable:false},//재고관리
            {name:'VENDORID',hidden:true},//옵션코드
            {name:'GOOD_IDEN_NUMB',hidden:true}//옵션코드
        ],
        rowNum:0,
        postData: $('#frmGood').serializeObject(),
        height:300,width:870,
        sortname: '', sortorder: 'asc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list6").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
            $(this).setCell(rowid,'SELL_PRICE_MNGT',"<button onclick='fnSetBtn(1);' type='button' class='btn btn-gray btn-xs' style='padding-top:0px;padding-bottom:0px;'>변경</button>&nbsp;<button onclick='fnSetBtn(2);' type='button' class='btn btn-default btn-xs' style='padding-top:0px;padding-bottom:0px;'>이력</button>");
//             $(this).setCell(rowid,'SELL_PRICE_MNGT',"<button onclick='fnSetBtn(1);' type='button' class='btn btn-gray btn-xs'><i class='fa fa-krw'></i></button><button onclick='fnSetBtn(2);' type='button' class='btn btn-default btn-xs'><i class='fa fa-th-list'></i></button>");
            $(this).setCell(rowid,'SALE_UNIT_PRIC_MNGT',"<button onclick='fnSetBtn(1);' type='button' class='btn btn-gray btn-xs' style='padding-top:0px;padding-bottom:0px;'>변경</button>&nbsp;<button onclick='fnSetBtn(2);' type='button' class='btn btn-default btn-xs' style='padding-top:0px;padding-bottom:0px;'>이력</button>");
//             $(this).setCell(rowid,'SALE_UNIT_PRIC_MNGT',"<button onclick='fnSetBtn(1);' type='button' class='btn btn-gray btn-xs'><i class='fa fa-krw'></i></button><button onclick='fnSetBtn(2);' type='button' class='btn btn-default btn-xs'><i class='fa fa-th-list'></i></button>");
            $(this).setCell(rowid,'GOOD_INVENTORY_CNT_MNGT',"<button onclick='fnSetBtn(1);' type='button' class='btn btn-gray btn-xs' style='padding-top:0px;padding-bottom:0px;'>변경</button>&nbsp;<button onclick='fnSetBtn(2);' type='button' class='btn btn-default btn-xs' style='padding-top:0px;padding-bottom:0px;'>이력</button>");
//             $(this).setCell(rowid,'GOOD_INVENTORY_CNT_MNGT',"<button onclick='fnSetBtn(1);' type='button' class='btn btn-gray btn-xs'><i class='fa fa-exchange'></i></button><button onclick='fnSetBtn(2);' type='button' class='btn btn-default btn-xs'><i class='fa fa-th-list'></i></button>");
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
            var selrowContent = $(this).jqGrid('getRowData',rowid);
            var cm = $(this).jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="SELL_PRICE_MNGT") {
            	if (btnNum == 1) {
            		priceType = 'LIST6_SALE';
	                $('#productPop').css({'width':'600px','top':'90%','left':'20%'}).html('')
	                .load('/menu/product/product/popPriceChange.sys?good_iden_numb='+selrowContent.GOOD_IDEN_NUMB+'&vendorid='+selrowContent.VENDORID+'&sell_sale_type=SALE')
	                .jqmShow();
            	} else {
            		$('#productPop').css({'width':'600px','top':'90%','left':'20%'}).html('')
                    .load('/menu/product/product/popPriceChangeHist.sys?good_iden_numb='+selrowContent.GOOD_IDEN_NUMB+'&vendorid='+selrowContent.VENDORID+'&sell_sale_type=SALE')
                    .jqmShow();
            	}
            }
            if(colName != undefined &&colName['name']=="SALE_UNIT_PRIC_MNGT") {
                if (btnNum == 1) {
                    priceType = 'LIST6_BUY';
                    $('#productPop').css({'width':'600px','top':'90%','left':'20%'}).html('')
                    .load('/menu/product/product/popPriceChange.sys?good_iden_numb='+selrowContent.GOOD_IDEN_NUMB+'&vendorid='+selrowContent.VENDORID+'&sell_sale_type=BUY')
                    .jqmShow();
                } else {
                    $('#productPop').css({'width':'600px','top':'90%','left':'20%'}).html('')
                    .load('/menu/product/product/popPriceChangeHist.sys?good_iden_numb='+selrowContent.GOOD_IDEN_NUMB+'&vendorid='+selrowContent.VENDORID+'&sell_sale_type=BUY')
                    .jqmShow();
                }
            }
            if(colName != undefined &&colName['name']=="GOOD_INVENTORY_CNT_MNGT") {
                if (btnNum == 1) {
                    stockType = 'LIST6';
	                $('#productPop').css({'width':'600px','top':'90%','left':'20%'}).html('')
	                .load('/menu/product/product/popStockChange.sys?good_iden_numb='+selrowContent.GOOD_IDEN_NUMB+'&vendorid='+selrowContent.VENDORID)
	                .jqmShow();
                } else {
	                $('#productPop').css({'width':'600px','top':'90%','left':'20%'}).html('')
	                .load('/menu/product/product/popStockChangeHist.sys?good_iden_numb='+selrowContent.GOOD_IDEN_NUMB+'&vendorid='+selrowContent.VENDORID)
	                .jqmShow();
                }
            }
        }
    });
    <% } %>
}
var popVendorNm;

var btnNum = 1;
function fnSetBtn(num) {
	btnNum = num; 
}
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
// 공급사 조회 
function fnSearchVendor() {
	/*
    var rowId       = $("#prodVendor").getGridParam("selrow");
    if(rowId == null){
        $('#dialogSelectRow').html('<p>선택된 공급사 정보가 없습니다.\n공급사 선택후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog();
        return;
    }
    */
    var vendorNm = $("#VENDORNM").val();
    fnVendorDialog(vendorNm, "fnCallBackVendor");
}

// 공급사 선택시 CallBack Function 
function fnCallBackVendor(vendorId, vendorNm, areaType) {
    /*
    //공급사 선택시 기존 공급사 존재여부 
    if(fnIsExistVendorInfo('prodVendor', vendorId)){
        $('#dialogSelectRow').html('<p>이미 추가된 공급사 정보입니다.</p>');
        $("#vtax_clas_code").focus();
        $("#dialogSelectRow").dialog();
        return true; 
    }
    */
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectVendorDetail/vendor/object.sys"
        , { srcVendorId:vendorId }
        , function(arg) {
			var vendor = eval('(' + arg + ')').vendor;
			bindVendor(vendor, true);
			$('#VENDORNM').change();
			if($("#goodVendorInput").css("display") == "none"){
					$("#goodVendorInput").show();
			}
		}
	);
}

var numberFormat = {decimalSymbol: '.',digitGroupSymbol:',',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:0};
function bindVendor(vendor, opt) {
     for (var k in vendor) {
    	 $("#" + k).val(vendor[k]);
     }
     $('#td_AREATYPENM').html(vendor.AREATYPENM);
     $('#td_PRESSENTNM').html(vendor.PRESSENTNM);
     $('#td_PHONENUM').html(vendor.PHONENUM);
          
     if (opt) return; // 공급사 팝업 선택시 종료
     
     if (vendor.ISNEW == 'U') {
    	 $('#btnVendor').hide();
    	 <% if (!repre_good.equals("Y")) { %>
         $('#SELL_PRICE').attr('readonly', true);
         $('#SALE_UNIT_PRIC').attr('readonly', true);
         <% } %>
         $('#GOOD_INVENTORY_CNT').attr('readonly', true);
         $('#tab-Input button').attr('disabled', false);
	     // Format
	     //$('#SALE_UNIT_PRIC').formatCurrency(numberFormat);
	     //$('#SELL_PRICE').formatCurrency(numberFormat);
	     //$('#GOOD_INVENTORY_CNT').formatCurrency(numberFormat);
     } else {
         $('#btnVendor').show();
         // 상품등록요청에 의한 공급사 조회시만 해당
         if (vendor.VENDORID == '') {
        	 $('#ISCHANGE').val('C');
         };
         $('#SELL_PRICE').attr('readonly', false);
         $('#SALE_UNIT_PRIC').attr('readonly', false);
         $('#GOOD_INVENTORY_CNT').attr('readonly', false);
         $('#tab-Input button').attr('disabled', true);
     }
     
     //판매가 - 매입가 = 이익금
     //이익금 / 판매가 = 이익률 x 100
     var rate = (vendor.SELL_PRICE - vendor.SALE_UNIT_PRIC) / vendor.SELL_PRICE * 100;
     if (isNaN(rate)) {
        $('#td_RATE').html('0%');
     } else {
         $('#td_RATE').html(rate.toFixed(1) + '%');
     }
     
     var sameWord = vendor.GOOD_SAME_WORD.split("‡");
     $('#GOOD_SAME_WORD1').val(sameWord[0]);
     $('#GOOD_SAME_WORD2').val(sameWord[1]);
     $('#GOOD_SAME_WORD3').val(sameWord[2]);
     $('#GOOD_SAME_WORD4').val(sameWord[3]);
     $('#GOOD_SAME_WORD5').val(sameWord[4]);

     // 이미지 변경 
     if (vendor.SMALL_IMG_PATH == null || vendor.SMALL_IMG_PATH == "") {
         $('#img_SMALL_IMG_PATH').attr('src','<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif');
         $('#img_MIDDLE_IMG_PATH').attr('src','<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_70.gif');
         $('#img_LARGE_IMG_PATH').attr('src','<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_100.gif');
     } else {
         var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + vendor.SMALL_IMG_PATH;
         var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + vendor.MIDDLE_IMG_PATH;
         var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + vendor.LARGE_IMG_PATH;
         $('#img_SMALL_IMG_PATH').attr('src',imgPathForSMALL);
         $('#img_MIDDLE_IMG_PATH').attr('src',imgPathForMEDIUM);
         $('#img_LARGE_IMG_PATH').attr('src',imgPathForLARGE);
     }
     // 상세설명
     if (oEditors.length > 0) {
    	 $('#GOOD_DESC').val(unescape(vendor.GOOD_DESC));
    	 oEditors.getById["GOOD_DESC"].exec("LOAD_CONTENTS_FIELD");
     }
     
     if (vendor.ISNEW == 'U') {
         $('#btnAddVen').attr('disabled', false);
         $('#btnCopyVen').attr('disabled', false);	
// 	     if (vendor.ISUSE == 1) {
// 	         $('#btn0Ven').attr('disabled', false);
// 	         $('#btn1Ven').attr('disabled', true);
// 	         $('#btnDelVen').attr('disabled',true);
// 	     } else if (vendor.ISUSE == 0) {
// 	         $('#btn0Ven').attr('disabled', true);
// 	         $('#btn1Ven').attr('disabled', false);
// 	         $('#btnDelVen').attr('disabled', false);
// 	     }
         $('#btnDelVen').attr('disabled', vendor.ISUSE != '2');
     } else {
         $('#btnAddVen').attr('disabled', true);
    	 $('#btnCopyVen').attr('disabled', true);
//          $('#btn0Ven').attr('disabled', true);
//          $('#btn1Ven').attr('disabled', true);
//          $('#btnDelVen').attr('disabled', false);
     }
 	
     if (vendor.ISUSE == 1) {
         $('#btn0Ven').attr('disabled', false);
         $('#btn1Ven').attr('disabled', true);
         $('#btnDelVen').attr('disabled',true);
     } else if (vendor.ISUSE == 0) {
         $('#btn0Ven').attr('disabled', true);
         $('#btn1Ven').attr('disabled', false);
         $('#btnDelVen').attr('disabled', false);
     }
     $("input:text[requirednumber]").number(true);
 }
 function checkChange() {
	 if ($('#ISCHANGE').val() == 'C') {
         if (!confirm("변경된 내용이 존재합니다. 변경 내용을 취소하시겠습니까?")) {
             return false;
         }
	     // 추가한 행일 경우 바로 삭제 처리함. 
	     var isnew = $('#ISNEW').val();
	     if (isnew == 'A') {
	         var row = $('#list2').jqGrid('getGridParam','selrow');
	         $("#list2").delRowData(row);
	     }
     }
     $('#ISCHANGE').val('');
	 return true;
 }
 function checkProduct(e) {
     if ($('#good_iden_numb').val() == '') {
         alert('상품 기본정보를 저장 후 단계를 진행하세요.');
         if (e) e.preventDefault();
         return false;
     }
     return true;
 }
 function checkVendor(e) {
	 if (!checkProduct(e)) return false;
	 
	 if ($('#list2').jqGrid('getGridParam','selrow') < 1) {
         alert('선택된 공급사 정보가 없습니다. 공급사 선택후 이용하시기 바랍니다.');
         if (e) e.preventDefault();
         return false;
     }
	 return true;
 }
 var priceType;
 function fnPriceCallBack(chgPrice) {
     if (priceType == 'SALE') {
         var row = $('#list2').jqGrid('getGridParam','selrow');
    	 $('#list2').setCell(row, 'SELL_PRICE', chgPrice);
    	 g_rowid = -1;
         $('#list2').setSelection(row);
     } else if (priceType == 'LIST6_SALE') {
         var row = $('#list6').jqGrid('getGridParam','selrow');
         $('#list6').setCell(row, 'SELL_PRICE', chgPrice);
     } else if (priceType == 'BUY') {
         var row = $('#list2').jqGrid('getGridParam','selrow');
         $('#list2').setCell(row, 'SALE_UNIT_PRIC', chgPrice);
         g_rowid = -1;
         $('#list2').setSelection(row);
     } else if (priceType == 'LIST6_BUY') {
         var row = $('#list6').jqGrid('getGridParam','selrow');
         $('#list6').setCell(row, 'SALE_UNIT_PRIC', chgPrice);
     }
 }
 var stockType;
 function fnStockCallBack(chgStock) {
     if (stockType == 'LIST2') {
         var row = $('#list2').jqGrid('getGridParam','selrow');
         $('#list2').setCell(row, "GOOD_INVENTORY_CNT", parseInt($('#GOOD_INVENTORY_CNT').val(),10) + parseInt(chgStock,10));
         g_rowid = -1;
         $('#list2').setSelection(row);
     } else if (stockType == 'LIST6') {
         var row = $('#list6').jqGrid('getGridParam','selrow');
         var selrowContent = $('#list6').jqGrid('getRowData',row);
         $('#list6').setCell(row, "GOOD_INVENTORY_CNT", parseInt(selrowContent.GOOD_INVENTORY_CNT,10) + parseInt(chgStock,10));
     }
 }
 function fnCheckGood_type() {
	var good_type = $('input[name=good_type]:checked').val();
	if (good_type == '10') {
	    $('input[name=vendor_expose][value=Y]').attr('checked', true);
	    $('input[name=vendor_expose][value=N]').attr('disabled', true);
	} else {
	    $('input[name=vendor_expose]').attr('disabled', false);
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
	fnCheckAdd_good();
}
function fnCheckAdd_good() {
    if ($('input[name=add_good]:checked').val() == 'Y') {
        $('#add_good').show();
    } else {
        $('#add_good').hide();
    }
}
function reloadList5() {
    var data = $("#list5").jqGrid("getGridParam", "postData");
    data.good_iden_numb   = $("#good_iden_numb").val(); 
    $('#list5').trigger("reloadGrid");
}
function reloadList6() {
	var data = $("#list6").jqGrid("getGridParam", "postData");
	data.good_iden_numb   = $("#good_iden_numb").val(); 
	data.optVendor        = $("#optVendor").val();
	data.optOption        = $("#optOption").val(); 
	$('#list6').trigger("reloadGrid");
}
function optionPriceAllExcel() {
    var colLabels = ['옵션코드','옵션(규격)','공급사ID','공급사','판매가','매입가','재고증감','변경사유'];   //출력컬럼명
    var colIds = ['GOOD_IDEN_NUMB','GOOD_SPEC','VENDORID','VENDORNM','SELL_PRICE','SALE_UNIT_PRIC','GOOD_INVENTORY_CNT',''];   //출력컬럼ID
    var numColIds = ['SELL_PRICE','SALE_UNIT_PRIC','GOOD_INVENTORY_CNT'];  //숫자표현ID
    var sheetTitle = "규격옵션 가격(재고) 설정"; //sheet 타이틀
    var excelFileName = "optionPriceList";  //file명

    fnExportExcel($("#list6"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
};
</script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/jquery.serializejson.min.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>
</body>
</html>