<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.order.dto.CartMasterInfoDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.UserDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
	//그리드의 width와 Height을 정의
	CartMasterInfoDto cartInfoDto = null ; 
	cartInfoDto = (CartMasterInfoDto)request.getAttribute("cartMasterInfo");
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")
	List<UserDto> userList = (List<UserDto>) request.getAttribute("userList");
	String mana_user_name = "";
	String mana_user_id = "";
	if(userList.size() > 0){
		mana_user_name = userList.get(0).getUserNm();
		mana_user_id = userList.get(0).getUserId();
	}
	
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	String listHeight = "$(window).height()-435 + Number(gridHeightResizePlus)-45";
	String _menuId              = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String businessNum   = "";
	String orderAuthType = "";
	if(userDto.getSmpBranchsDto() != null){
		businessNum   = CommonUtils.getString(userDto.getSmpBranchsDto().getBusinessNum());
		orderAuthType = CommonUtils.getString(userDto.getSmpBranchsDto().getOrderAuthType());
	}
	boolean isLimit = false;
	if (userDto.getIsLimit() != null && userDto.getIsLimit().equals("1")) {
		isLimit = true;
	}  // 주문제한 여부
	
	//선입금여부
	boolean prePay = false;
// 	if("BUY".equals(userDto.getSvcTypeCd())){
// 		if("1".equals(userDto.getSmpBranchsDto().getPrePay())){
// 			prePay = true;
// 		}
// 	}

	List<Map<String, Object>> cartList = (List<Map<String, Object>>)request.getAttribute("cartList");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
</head>

<body class="mainBg">
	<div id="divWrap">
		<!-- header -->
		<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
		<!-- /header -->
		<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />

				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">일괄 항목</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-32px;">
						<button id='' class="btn btn-darkgray btn-sm" onclick="javascript:fnOrderSheet();"><i class="fa fa-print"></i> 견적서 출력</button>
						<button id='' class="btn btn-darkgray btn-sm" onclick="javascript:fnUpdateCartMstInfo();"><i class="fa fa-save"></i> 일괄항목저장</button>
						
					</div>
					<table class="InputTable">
						<colgroup>
							<col width="120px" />
							<col width="200px" />
							<col width="100px" />
							<col width="20px" />
							<col width="auto" />
							<col width="120px" />
							<col width="60px" />
							<col width="120px" />
							<col width="200px" />
						</colgroup>
						<tr>
							<th>구매사</th>
							<td style="width:380px; "><%=userDto.getBorgNms() %></td>
							<th>주문자</th>
							<td colspan="4" >
								<input id="orde_user_id" name= "orde_user_id" type="hidden" value="<%= userDto.getUserId() %>" onkeydown="javascript:if(event.keyCode==13) return false;"/>
								<%= loginUserDto.getUserNm() %> 
							</td>
							<th>주문자 전화번호</th>
							<td>
								<input id="orde_tele_numb" name="orde_tele_numb" type="text" value="<% if(null != userDto.getMobile()){out.print(userDto.getMobile());}  %>" size="20" style="width: 150px;ime-mode: disabled; border-color: white" disabled="disabled" maxlength="11"   onkeydown="javascript:if(event.keyCode==13) return false;" />
							</td>
						</tr>
						<tr>
							<th>공사명(주문명)</th>
							<td colspan="6">
								
							<input id="cons_iden_name" name="cons_iden_name" type="text" value="<%= cartInfoDto.getComp_iden_name() %>" size="" maxlength="250" style="width: 98%;"  onkeydown="javascript:if(event.keyCode==13) return false;"/>
							<input id="orde_type_clas" name="orde_type_clas" type="hidden" value="<%= cartInfoDto.getOrde_type_clas() %>" size="" maxlength="250"/>
							</td>
							<th>인수자</th>
							<td>
								<input id="tran_user_name" name="tran_user_name" type="text" value="<%= cartInfoDto.getTran_user_name() %>" style="width: 100px;" size="20" maxlength="10"  onkeydown="javascript:if(event.keyCode==13) return false;"/>
							</td>
						</tr>
						<tr>
							<th>비고</th>
							<td colspan="6">
								<input id="orde_text_desc" name="orde_text_desc" type="text" value="<%= cartInfoDto.getOrde_text_desc() %>" size="" maxlength="1000" style="width: 98%;"  onkeydown="javascript:if(event.keyCode==13) return false;"/>
							</td>
							<th>인수자 전화번호</th>
							<td>
								<input id="tran_tele_numb" name="tran_tele_numb" type="text" value="<%= cartInfoDto.getTran_tele_numb() %>" size="20" maxlength="13" style="width: 150px;" onkeydown="return onlyNumber(event)"/>
							</td>
						</tr>
						<tr>
							<th>
								<button id='btnAddDeliveryAddress' class="btn btn-darkgray btn-xs" style="">배송지</button>
							</th>
							<td colspan="6">
								<select name="tran_deta_addr_seq" id="tran_deta_addr_seq" style="width:99%;" ></select>
							</td>
							<th id="vendorSelect1">감독명(승인자)</th>
							<td id="vendorSelect2">
								<%=mana_user_name %>
								<input id="mana_user_id" name="mana_user_id" type="hidden" value="<%=mana_user_id %>" />
							</td>
						</tr>
						<tr>
							<th>첨부파일1</th>
							<td colspan="4">
								<input type="hidden" id="firstattachseq" name="firstattachseq" value="<%=CommonUtils.getString(cartInfoDto.getFirstattachseq()) %>"/>
								<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=CommonUtils.getString(cartInfoDto.getFirstAttachPath()) %>"/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
									<span id="attach_file_name1"><%=CommonUtils.getString(cartInfoDto.getFirstAttachName()) %></span>
								</a>
								<div style="float:right">
								<button id='btnAttach1' class="btn btn-darkgray btn-xs">등록</button>
<%if(!"".equals(CommonUtils.getString(cartInfoDto.getFirstattachseq()))) {    %>
								<button id='btnAttachDel1' class="btn btn-default btn-xs" onclick="javascript:fnAttachDel('<%=CommonUtils.getString(cartInfoDto.getFirstattachseq()) %>','firstattachseq');">삭제</button>
<%}%>
								</div>
							</td>
							<th>첨부파일2</th>
							<td colspan="3">
								<input type="hidden" id="secondattachseq" name="secondattachseq" value="<%=CommonUtils.getString(cartInfoDto.getSecondattachseq()) %>"/>
								<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=CommonUtils.getString(cartInfoDto.getSecondAttachPath()) %>"/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
									<span id="attach_file_name2"><%=CommonUtils.getString(cartInfoDto.getSecondAttachName()) %></span>
								</a>
								<div style="float:right">
								<button id='btnAttach2' class="btn btn-outline btn-darkgray btn-xs" style="">등록</button>
<%if(!"".equals(CommonUtils.getString(cartInfoDto.getSecondattachseq()))) {   %>
								<button id='btnAttachDel2' class="btn btn-default btn-xs" onclick="javascript:fnAttachDel('<%=CommonUtils.getString(cartInfoDto.getSecondattachseq()) %>','secondattachseq');">삭제</button>
<%}%>
								</div>
							</td>
						</tr>
					</table>
					<ul class="Tabarea mgt_20"> <li class="on">장바구니 상품</li> </ul>
					<div style="position:absolute; right:0; margin-top:-35px;">
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnAllOrder();">전체 상품 주문신청</a>
						<a class="btn btn-primary btn-sm" style="" onclick="javascript:fnSelOrder();">선택 상품 주문신청</a>
					</div>
					<div class="ListTable">
						<table>
							<colgroup>
								<col width="30px" />
								<col width="550px" />
								<col width="100px" />
								<col width="100px" />
								<col width="140px" />
								<col width="80px" />
							</colgroup>
							<tr>
								<th class="br_l0"><input id="cartCheckAll" name="cartCheckAll" type="checkbox" value="" onclick="javascript:fnCheckAll();" /></th>
								<th>상품정보</th>
								<th><p>단가<br/>(주문수량)</p></th>
								<th>금액</th>
								<th>납기 희망일<br/>(표준납기일)</th>
								<th>선택주문</th>
							</tr>							
<%	if(cartList != null && cartList.size() > 0){
		for(int i = 0 ; i < cartList.size() ; i++){
			Map<String, Object> cartMap = cartList.get(i);
			
			String paramGoodIdenNumb = "";
			if("Y".equals(CommonUtils.getString(cartMap.get("REPRE_GOOD"))))	paramGoodIdenNumb = CommonUtils.getString(cartMap.get("REPRE_GOOD_IDEN_NUMB"));
			else paramGoodIdenNumb = "".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) ? CommonUtils.getString(cartMap.get("GOOD_IDEN_NUMB")) :  CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"));
%>
							<tr>
								
<%			
			//if("Y".equals(CommonUtils.getString(cartMap.get("ADD_GOOD"))) && CommonUtils.getString(cartMap.get("GOOD_IDEN_NUMB")).equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) ){ 
			if("Y".equals(CommonUtils.getString(cartMap.get("ADD_GOOD"))) && "".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) ){
%>
								<td align="center" class="br_l0" rowspan="2" >
									<input id="cartChk_<%=i %>" name="cartChk" type="checkbox" value="<%=i %>" class="cartCheck" onclick="javascript:fnCartCheck();"/>
									<input type="hidden" id="addMst_<%=i %>" value="Y"/>
								</td>
<%		}else if("".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) ){ %>
								<td align="center" class="br_l0">
									<input id="cartChk_<%=i %>" name="cartChk" type="checkbox" value="<%=i %>" class="cartCheck" onclick="javascript:fnCartCheck();"/>
									<input type="hidden" id="addMst_<%=i %>" value="N"/>
								</td>
<%		} %>								
								<td>
<%			String appDispStr = "none";
			String addDispStr = "none";
			String optDispStr = "none";
			
			if("20".equals(CommonUtils.getString(cartMap.get("GOOD_CLAS_CODE")))) 	appDispStr = "display";
			if("Y".equals(CommonUtils.getString(cartMap.get("ADD_GOOD")))) 			addDispStr = "display";
			boolean isOpt = false;
			if("Y".equals(CommonUtils.getString(cartMap.get("REPRE_GOOD"))) || "".equals(CommonUtils.getString(cartMap.get("REPRE_GOOD_IDEN_NUMB"))) == false ){ 		optDispStr = "display";	 }
%>									
									<div class="label" >
										<span class="add" style="display: <%=addDispStr%>;cursor: text;">추가</span>
										<span class="option" style="display: <%=optDispStr %>;cursor: text;">옵션</span>
										<span class="appoint" style="display: <%=appDispStr %>;cursor: text;">지정</span>
									</div>
									<dl>
                						<dt><img src="/upload/image/<%=CommonUtils.getString(cartMap.get("IMG_PATH")) %>" onerror="this.src = '/img/layout/img_null.jpg'" width="100px;" height="100px;"/></dt>
										<dd>
												
												<p>
												<a href="javascript:fnProductDetailPop('<%=paramGoodIdenNumb%>', '<%= CommonUtils.getString(cartMap.get("VENDORID"))%>');">
												<%=CommonUtils.getString(cartMap.get("GOOD_NAME"))%>
												</a>
												</p>
											<ul>
<%		
			String tmpShowGoodIdenNumb = CommonUtils.getString(cartMap.get("GOOD_IDEN_NUMB"));
			if( "".equals(CommonUtils.getString(cartMap.get("REPRE_GOOD_IDEN_NUMB"))) == false ){
                tmpShowGoodIdenNumb = CommonUtils.getString(cartMap.get("REPRE_GOOD_IDEN_NUMB")); 
			}
%>
												<li>상품코드&nbsp;&nbsp; : <strong><%=tmpShowGoodIdenNumb%></strong></li>
												<li>규격&nbsp;&nbsp;&nbsp;&nbsp; : <strong><%=CommonUtils.getString(cartMap.get("GOOD_SPEC"))%></strong></li>
												<li><%=CommonUtils.getString(cartMap.get("COMMON_OPTION"))%></li>
<%
            if("0".equals(CommonUtils.getString(cartMap.get("DELI_MINI_QUAN"))) == false ){
%> 
												<li>최소구매수량 :  <strong><%=CommonUtils.getString(cartMap.get("DELI_MINI_QUAN"))%></strong></li>
<%
			}
%>
												<li>
													공급사 : <strong><%=CommonUtils.getString(cartMap.get("VENDORNM"))%></strong>
<%		String make_comp_name = CommonUtils.getString(cartMap.get("MAKE_COMP_NAME") ) ; 	
			if( make_comp_name.equals("")==false  ){ 
%>
													<strong>(제조사 : <%=make_comp_name%>)</strong>
<% 		}%>
												</li>
											</ul>
										</dd>
									</dl>
								</td>
								<td class="count">
									<p><%=CommonUtils.getIntString(cartMap.get("SELL_PRICE"))%></p>
<%
		String readOnlyYn = "";
		String styleBgColor = "";
		if("".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) == false){
			readOnlyYn = " readonly='true' ";
			styleBgColor = " background-color: #eeeeee";
		}
%>
									<p><input id="ordQuan_<%=i %>" name="ordQuan_<%=i %>" type="text" style="width:50px; text-align: right; <%=styleBgColor %>" value="<%=CommonUtils.getString(cartMap.get("ORDE_REQU_QUAN"))%>" onkeydown="return onlyNumber(event)" maxlength=9 onkeyup="javascript:fnSetOrdQuan('<%=i %>');" <%=readOnlyYn%> /></p>
<%
        if("".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) == true){
%>
									<p style="height: 2px">&nbsp;</p>
									<p><button id='' class="btn btn-default btn-xs" onclick="javascript:fnOrderQuanUpdate('<%=i%>');" >변경</button></p>
<%
        }
%> 
									<input id="deli_mini_quan_<%=i %>" name="deli_mini_quan_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("DELI_MINI_QUAN"))%>"/>
									<input id="isOpt_<%=i %>" name="isOpt_<%=i %>" type="hidden" value="<%=isOpt%>"/>
									
									<input id="sellPrice_<%=i %>" name="sellPrice_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("SELL_PRICE"))%>"/>
									<input id="saleUnitPrice_<%=i %>" name="saleUnitPrice_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("SALE_UNIT_PRIC"))%>"/>
									<input id="ordPrice_<%=i %>" name="ordPrice_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("ORD_PRICE"))%>" />								
									<input id="goodIdenNumb_<%=i %>" name="goodIdenNumb_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("GOOD_IDEN_NUMB"))%>" />								
									<input id="vendorId_<%=i %>" name="vendorId_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("VENDORID"))%>" />								
									<input id="goodName_<%=i %>" name="goodName_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("GOOD_NAME"))%>" />								
<%-- 									<input id="goodSpec_<%=i %>" name="goodSpec_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("GOOD_SPEC")) + ";" + CommonUtils.getString(cartMap.get("COMMON_OPTION"))%>" /> --%>
									<input id="goodSpec_<%=i %>" name="goodSpec_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("GOOD_SPEC")) %>" />
									<input id="addGoodNumb_<%=i %>" name="addGoodNumb_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))%>" />								
									<input id="repreGoodNumb_<%=i %>" name="repreGoodNumb_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("REPRE_GOOD_IDEN_NUMB"))%>" />								
									<input id="isDispPastGood_<%=i %>" name="isDispPastGood_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("ISDISPPASTGOOD"))%>" style="" />								
									
<%			if("Y".equals(CommonUtils.getString(cartMap.get("ADD_GOOD"))) && "".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) ){ %>
									<input id="addProductYn_<%=i %>" name="addProductYn_<%=i %>" type="hidden" value="Y"/>								
<%			} %>									
									
								</td>
								<td class="count" id="ordPriceTxt_<%=i%>">
									<%=CommonUtils.getIntString(cartMap.get("ORD_PRICE"))%>
								</td>
								<td align="center">
									<p><input id="exDatePicker_<%=i %>" name="exDatePicker_<%=i %>" type="text" style="width:70px;" readonly="readonly" value="<%=CommonUtils.getString(cartMap.get("DELI_DATE"))%>"/></p>
									<p>(<%=CommonUtils.getString(cartMap.get("DELI_DATE"))%>, <%=CommonUtils.getString(cartMap.get("DELI_MINI_DAY")) %>일)</p>
									<script type="text/javascript">
										$("#exDatePicker_<%=i %>").datepicker(
									    {
									    	showOn: "button",
									        buttonImage: "/img/contents/btn_calenda.gif",
									        buttonImageOnly: true,
									        dateFormat: "yy-mm-dd",
									        minDate:0
										});
									  	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정										
									</script>									
								</td>
								
<%			if("Y".equals(CommonUtils.getString(cartMap.get("ADD_GOOD"))) && "".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) ){ %>
								<td align="center" rowspan="2">
									<button id='orderButton' class="btn btn-danger btn-sm" style="" onclick="javascript:fnOneOrder('<%=i%>');">주문</button>
									<button id='orderButton' class="btn btn-gray btn-sm" style="margin-top: 5px" onclick="javascript:fnOneDel('<%=i%>');">삭제</button>
								</td>
<%			}else if("".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) ){ %>
								<td align="center">
									<button id='orderButton' class="btn btn-danger btn-sm" style="" onclick="javascript:fnOneOrder('<%=i%>');">주문</button>
									<button id='orderButton' class="btn btn-gray btn-sm" style="margin-top: 5px" onclick="javascript:fnOneDel('<%=i%>');">삭제</button>
								</td>
<%			} %>									
								
								

							</tr>
<%		}
	}else{ %>
							<tr>
								<td colspan="6" align="center" >등록된 상품이 없습니다.</td>
							</tr>
<%	} %>							
						</table>
					</div>
					<div class="TotalCount">
						<table width="100%">
							<tr>
								<td align="center" class="col01">
									<p>공급가액</p>
									<p id="sumPrice"><strong class="f18">0</strong> 원</p>
								</td>
								<td align="center"><img src="/img/contents/icon_plus.png" /></td>
								<td align="center" class="col01">
									<p>부가세</p>
									<p id="taxPrice"><strong class="f18">0</strong> 원</p>
								</td>
								<td align="center"><img src="/img/contents/icon_same.png" /></td>
								<td align="center" class="col02">
									<p>최종금액</p>
									<p id="totPrice"><strong class="f18">0</strong> 원</p>
								</td>
							</tr>
						</table>
					</div>
					<div class="floatleft mgt_10">
						<button class="btn btn-danger btn-sm" style="" onclick="javascript:fnSetCheckAll();">전체선택</button>
						<button class="btn btn-gray btn-sm" style="" onclick="javascript:fnCartDelete();">선택 상품 삭제</button>
					</div>
					<div class="floatright mgt_10">
						<button class="btn btn-danger btn-sm" style="" onclick="javascript:fnAllOrder();">전체 상품 주문신청</button>
						<button class="btn btn-primary btn-sm" style="" onclick="javascript:fnSelOrder();">선택 상품 주문신청</button>
					</div>
					<div style="height:50px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>  
	<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
		<p>상품검색을 통해 주문요청할 상품을 선택해주십시오.</p>
	</div>
	<div id="dialog" title="Feature not supported" style="display:none;">
		<p>That feature is not supported.</p>
	</div>
</body>

<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
	
	$("#cartCheckAll").prop("checked", true);
	fnCheckAll();
	$("#orde_tele_numb").val(  fnSetTelformat( $("#orde_tele_numb").val() ) );
	$("#tran_tele_numb").val(  fnSetTelformat( $("#tran_tele_numb").val() ) );
	
});

function fnOrderQuanUpdate(idx){
	var vendorids 			= new Array();
	var good_iden_numbs		= new Array();
	var tmpOrdQuan = $("#ordQuan_"+idx).val();
	
	vendorids[0] = $("#vendorId_"+idx).val();
	good_iden_numbs[0] = $("#goodIdenNumb_"+idx).val();
	if($("#addProductYn_"+idx) && $.trim($("#addProductYn_"+idx).val()) == "Y"){
		tmpIdx = Number(idx)+1;
        vendorids[1] =  $("#vendorId_"+tmpIdx).val();
        good_iden_numbs[1] =$("#goodIdenNumb_"+tmpIdx).val();
	}
	
	$.post(
		"/buyCart/updateCartPdtOrdQuan.sys", 
		{
            goodIdenNumbs:good_iden_numbs,
            vendorIds:vendorids,
            ordQuan:tmpOrdQuan
		},
		function(arg){ 
			var result = eval('(' + arg + ')').custResponse;
			if(result.success){
				alert("수량을 변경하였습니다.");
			}else{
				alert(result.message);
			}
		}
	);
}

function fnAllOrder(){
	var cons_iden_name = $("#cons_iden_name").val();// 공사명
	if($.trim(cons_iden_name) == "" ) {
		$('#dialogSelectRow').html('<p>공사명은 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#cons_iden_name").focus();
		return;
	}
	$("#cartCheckAll").prop("checked", true);
	
	fnCheckAll();
	
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		
		return false;
	}
	
	confirmMessage("전체 상품을 주문하시겠습니까?", fnAuth);
}

function fnSelOrder(){
	var cons_iden_name = $("#cons_iden_name").val();// 공사명
	if($.trim(cons_iden_name) == "" ) {
		$('#dialogSelectRow').html('<p>공사명은 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#cons_iden_name").focus();
		return;
	}
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		
		return false;
	}
	
	confirmMessage("선택하신 상품을 주문하시겠습니까?", fnAuth);
}

function fnOneOrder(idx){

	var cons_iden_name = $("#cons_iden_name").val();// 공사명
	if($.trim(cons_iden_name) == "" ) {
		$('#dialogSelectRow').html('<p>공사명은 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#cons_iden_name").focus();
		return;
	}
	
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		
		return false;
	}
	
	$("#cartCheckAll").prop("checked", false);
	
	fnCheckAll();
	
	$("#cartChk_"+idx).prop("checked", true);
	
	fnCartSummary();
	
	confirmMessage("해당 상품을 주문하시겠습니까?", fnAuth);
}

function fnOrder(){
	$.blockUI();
	var ord_quans 			= new Array();
	var vendorids 			= new Array();
	var good_iden_numbs		= new Array();
	var orde_requ_prics		= new Array();
	var sale_unit_prices	= new Array();
	var requ_deli_dates		= new Array();
	var good_names			= new Array();
	var good_specs			= new Array();
	var add_good_numbs		= new Array();
	var repre_good_numbs	= new Array();

	var cons_iden_name  = $("#cons_iden_name").val();                    // 공사명
	var orde_type_clas  = "10";                                          // 주문유형
	var orde_tele_numb  = $("#orde_tele_numb").val();                    // 주문자 전화번호
	var orde_user_id    = $("#orde_user_id").val();                      // 주문자 ID
	var tran_data_addr  = $("#tran_deta_addr_seq").val();                // 배송지주소
	var tran_user_name  = $("#tran_user_name").val();                    // 인수자
	var tran_tele_numb  = $("#tran_tele_numb").val();                    // 인수자 전화번호
	var adde_text_desc  = $("#orde_text_desc").val();                    // 비고
	var mana_user_id  	= $("#mana_user_id").val();                      // 감독명 
	var attach_file_1   = $("#firstattachseq").val();                    // 첨부파일1
	var attach_file_2   = $("#secondattachseq").val();                   // 첨부파일2
	var attach_file_3   = $("#thirdattachseq").val();                    // 첨부파일3	
	
	var cartCnt = Number('<%=cartList.size()%>');
	var chkCnt  = 0;
	
	var errIdx = "";
	for(var idx = 0 ; idx < cartCnt ; idx++){
		var isCheck = false;
		
		if($("#cartChk_" + idx).prop("checked") != undefined){
			isCheck = $("#cartChk_" + idx).prop("checked");
		}else{
			isCheck = $("#cartChk_" + (idx-1)).prop("checked");
		}
		
		if(isCheck){
			if(    $.trim($("#isOpt_" + idx).val()) == "false" && Number($.trim($("#ordQuan_" + idx).val())) < Number($.trim($("#deli_mini_quan_"+ idx).val()))    == true ){
				errIdx = idx;
				break;
			}
			if($.trim($("#ordQuan_" + idx).val()) == "0" || $.trim($("#ordQuan_" + idx).val()).length == 0 || isNaN(  Number($.trim($("#ordQuan_" + idx).val())) ) ){
				errIdx = idx;
				break;
			}
			ord_quans[chkCnt] 	 	= $.trim($("#ordQuan_" + idx).val()); 
			vendorids[chkCnt] 	 	= $.trim($("#vendorId_" + idx).val()); 
			good_iden_numbs[chkCnt] = $.trim($("#goodIdenNumb_" + idx).val());
			orde_requ_prics[chkCnt]	= $.trim($("#sellPrice_" + idx).val());
			sale_unit_prices[chkCnt]= $.trim($("#saleUnitPrice_" + idx).val());
			requ_deli_dates[chkCnt]	= $.trim($("#exDatePicker_" + idx).val());
			good_names[chkCnt]		= $.trim($("#goodName_" + idx).val());
			good_specs[chkCnt]		= $.trim($("#goodSpec_" + idx).val());
			add_good_numbs[chkCnt]	= $.trim($("#addGoodNumb_" + idx).val());
			repre_good_numbs[chkCnt]= $.trim($("#repreGoodNumb_" + idx).val());
			chkCnt++;
		}
	}
	if($.trim(errIdx).length > 0  ){
		alert("["+$.trim($("#goodName_" + errIdx).val()) +"] 상품의 주문수량(최소주문수량)을 확인하여주십시오.");
		$.unblockUI();
		return false;
	}
	
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/setOrderCartInfo.sys',
		{
			ord_quans 			:ord_quans,
			vendorids 			:vendorids,
			good_iden_numbs		:good_iden_numbs,	
			orde_requ_prics		:orde_requ_prics,	
			sale_unit_prices	:sale_unit_prices,	
			requ_deli_dates		:requ_deli_dates,	
			good_names			:good_names,		
			good_specs			:good_specs,		
			add_good_numbs		:add_good_numbs,	
			repre_good_numbs	:repre_good_numbs,
			cons_iden_name  	:cons_iden_name, 
			orde_type_clas  	:orde_type_clas, 
			orde_tele_numb  	:orde_tele_numb, 
			orde_user_id    	:orde_user_id, 
			tran_data_addr  	:tran_data_addr, 
			tran_user_name  	:tran_user_name, 
			tran_tele_numb  	:tran_tele_numb, 
			adde_text_desc  	:adde_text_desc, 
			mana_user_id  		:mana_user_id, 
			attach_file_1   	:attach_file_1, 
			attach_file_2   	:attach_file_2, 
			attach_file_3   	:attach_file_3   
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if(result.success){
				alert("주문이 완료되었습니다.");
				fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/buyCartInfo.sys", "","");				
			}else{
				alert(result.message);
			}
			$.unblockUI();
		}
	);	
}


//3자리수마다 콤마
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
	n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

function fnSetCheckAll(){
	if($('#cartCheckAll').prop('checked')){
		$('#cartCheckAll').prop('checked', false);
	}else{
		$('#cartCheckAll').prop('checked', true);
	}
	fnCheckAll();
}

function fnCheckAll(){
	if($("#cartCheckAll").prop("checked")){
		$(".cartCheck").prop("checked", true);
	}else{
		$(".cartCheck").prop("checked", false);
	}
	fnCartSummary();
}

function fnCartCheck(){
	fnCartSummary();
}

function fnCartSummary(){
	var cartCnt = Number('<%=cartList.size()%>');
	var ordQuan = 0;
	var ordPric = 0;
	
	for(var i = 0 ; i < cartCnt ; i++){
		var isCheck = false;
		
		if($("#cartChk_" + i).prop("checked") != undefined){
			isCheck = $("#cartChk_" + i).prop("checked");
		}else{
			isCheck = $("#cartChk_" + (i-1)).prop("checked");
		}
		
		if(isCheck){
			ordQuan += Number($("#ordQuan_"+i).val());
			ordPric += Number($("#ordPrice_"+i).val());
		}
	}
	
	$("#sumPrice").html("<strong class='f18'>"+fnComma(Math.round(ordPric))+"</strong> 원");
	$("#taxPrice").html("<strong class='f18'>"+fnComma(Math.round((Math.round(ordPric))*0.1))+"</strong> 원");
	$("#totPrice").html("<strong class='f18'>"+fnComma((Math.round(ordPric)) + Math.round((Math.round(ordPric))*0.1))+"</strong> 원");
	
}

function fnSetOrdQuan(idx){
	var ordQuan  = Number($("#ordQuan_"+idx).val() == '' ? 0 : $("#ordQuan_"+idx).val());
	var sellPric = Math.round(Number($("#sellPrice_"+idx).val()));
	var ordPric  = ordQuan * sellPric;
	$("#ordPrice_"+idx).val(ordPric);
	$("#ordPriceTxt_"+idx).html(fnComma(ordPric));
	if($("#addMst_"+idx).val() == "Y"){
		$("#ordQuan_"+(Number(idx)+1)).val($("#ordQuan_"+idx).val());
        var ordQuanTmp  = Number($("#ordQuan_"+(Number(idx)+1)).val() == '' ? 0 : $("#ordQuan_"+(Number(idx)+1)).val());
        var sellPricTmp = Number($("#sellPrice_"+(Number(idx)+1)).val());
        var ordPricTmp  = ordQuanTmp * sellPricTmp;
        $("#ordPrice_"+(Number(idx)+1)).val(ordPricTmp);
        $("#ordPriceTxt_"+(Number(idx)+1)).html(fnComma(ordPricTmp));
	}
	fnCartSummary();
}

function fnOneDel(idx){
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	
	if(rowCnt ==0){
		alert("삭제 할 상품을 선택해 주십시오.");
		
		return false;
	}
	
	$("#cartCheckAll").prop("checked", false);
	
	fnCheckAll();
	
	$("#cartChk_"+idx).prop("checked", true);
	
	confirmMessage("해당 상품을 삭제 하시겠습니까?", fnCartDeleteCallback);
}


function fnCartDelete(){
	var cartCnt = Number('<%=cartList.size()%>');
	var chkCnt = 0;
	
	for(var i = 0 ; i < cartCnt ; i++){
		var isCheck = false;
		
		if($("#cartChk_" + i).prop("checked") != undefined){
			isCheck = $("#cartChk_" + i).prop("checked");
		}else{
			isCheck = $("#cartChk_" + (i-1)).prop("checked");
		}
		
		if(isCheck){
			chkCnt++;
		}
	}
	
	if(chkCnt == 0){
		alert("삭제할 상품을 선택해주세요.");
		
		return;
	}
	
	confirmMessage("선택하신 상품을 삭제 하시겠습니까?", fnCartDeleteCallback);
}

function fnCartDeleteCallback(){
	var cartCnt = Number('<%=cartList.size()%>');
	var goodIdenNumbs = new Array();
	var vendorIds 	  = new Array();
	
	var chkCnt = 0;
	for(var i = 0 ; i < cartCnt ; i++){
		var isCheck = false;
		
		if($("#cartChk_" + i).prop("checked") != undefined){
			isCheck = $("#cartChk_" + i).prop("checked");
		}else{
			isCheck = $("#cartChk_" + (i-1)).prop("checked");
		}
		
		if(isCheck){
			goodIdenNumbs[chkCnt] = $("#goodIdenNumb_" + i).val();
			vendorIds[chkCnt]	  = $("#vendorId_" + i).val();
			chkCnt++;
		}
	}
	
	$.blockUI();
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/deleteCartPdt.sys',
		{
			goodIdenNumbs:goodIdenNumbs,
			vendorIds:vendorIds
		},
		function(arg){
			var result = eval('(' + arg + ')').custResponse;
			if(result.success){
				fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/buyCartInfo.sys", "","");				
			}
            $.unblockUI();
		}
	);	
}
</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>

<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>



<%  
if(Constances.COMMON_ISREAL_SERVER) { 
%>
<%
/**------------------------------------공인인증 등록---------------------------------
  파라미터1 : 법인 (CLT), 공급사 (VEN)
  파라미터2 : 사용구분 (REG : 업체등록, ETC : 기타)
  파라미터3 : 공인인증서 인증상태 (0 : 등록, 1 : 생성, 2 : 무시), 공통함수사용
  파라미터4 : 사업자 등록번호 (인증상태값이 1인 경우에만 사용한다. 1이 아닌경우 '' 으로 넘긴다.)
  파라미터5 : CallBack function명
  파라미터6 : 조직ID (법인일경우 ClientId, 사업장일경우 VendorId) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<script type="text/javascript">
var authStep = "";
function fnAuth(){

    <%if(isLimit){%>
	alert("주문제한이 되어 주문을 할 수 없습니다.\n관리자에게 문의바랍니다.");
	return;
    <%}%>
	var orderAuthType = '<%=orderAuthType%>';
	if(orderAuthType == "10"){//공인인증
		//fnGetIsExistPublishAuth(svcTypeCd, borgId) - 현재 세션의 공인인증서 인증상태를 확인 (파라미터3 참조)
		authStep = fnGetIsExistPublishAuth('<%=loginUserDto.getSvcTypeCd()%>','<%=loginUserDto.getBorgId()%>');
		fnAuthBusinessNumberDialog("CLT", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=loginUserDto.getClientId()%>');   
	}else if(orderAuthType == "20"){//일반
		fnOrder();
	}
}

function fnCallBackAuthBusinessNumber(userDn) {
    if((userDn != "" && userDn != null) || authStep == "2"){
        fnOrder();
    }
}
</script>
<%
}else{ 
%>
<script type="text/javascript">
function fnAuth(){
<%		if(isLimit){%>
	alert("주문제한이 되어 주문을 할 수 없습니다.\n관리자에게 문의바랍니다.");
	return;
<%		}%>
    fnOrder();
}
</script>
<%
} 
%>
<% //------------------------------------------------------------------------------ %>


<%
/**------------------------------------배송지관리팝업 사용방법---------------------------------
* fnDeliveryAddressManageDialog(groupId, clientId, branchId, callbackString) 을 호출하여 Div팝업을 Display ===
* groupId : 고객사 그룹Id
* clientId : 고객사 법인Id
* branchId : 고객사 사업장Id
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 2개(우편번호, 주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/deliveryAddressManageDiv.jsp" %>
<!-- 배송지관리팝업 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
    $("#btnAddDeliveryAddress").click(function(){
        fnDeliveryAddressManageDialog("<%=loginUserDto.getGroupId() %>","<%=loginUserDto.getClientId() %>","<%=loginUserDto.getBorgId() %>","fnCallBackDeliveryAddressManage"); 
    });
    
    $("#orderRequestButton").click(function(){
        fnAuth();   
//      fnChkNormProduct();
    });
});




/**
 * 배송지관리팝업검색 후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressManage(deliId) {
	if(deliId != undefined){
		fnSelectBoxAddressInfo(deliId);
	}else{
        fnGetBuyAddressInfo(deliId);
	}
}
function fnSelectBoxAddressInfo(deliId) {
	$("#tran_deta_addr_seq").val(deliId);
}
</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#firstattachseq").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2"); });
	$("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#thirdattachseq").val(), "fnCallBackAttach3"); });
});
/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#firstattachseq").val(rtn_attach_seq);
	$("#attach_file_name1").text(rtn_attach_file_name);
	$("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#secondattachseq").val(rtn_attach_seq);
	$("#attach_file_name2").text(rtn_attach_file_name);
	$("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#thirdattachseq").val(rtn_attach_seq);
	$("#attach_file_name3").text(rtn_attach_file_name);
	$("#attach_file_path3").val(rtn_attach_file_path);
}
/**
 * 파일다운로드
 */
function fnAttachFileDownload(attach_file_path) {
	var url = "/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}
jQuery.download = function(url, data, method){
	// url과 data를 입력받음
	if( url && data ){ 
		// data 는  string 또는 array/object 를 파라미터로 받는다.
		data = typeof data == 'string' ? data : jQuery.param(data);
		// 파라미터를 form의  input으로 만든다.
		var inputs = '';
		jQuery.each(data.split('&'), function(){ 
			var pair = this.split('=');
			inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
		});
		// request를 보낸다.
		jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>').appendTo('body').submit().remove();
	};
};
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

<script type="text/javascript">
$(document).ready(function() {
	fnGetBuyAddressInfo();
});

//배송지 정보 조회
function fnGetBuyAddressInfo() {
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getDeliveryAddressByBranchId.sys',
		{
			branchId	: '<%=loginUserDto.getBorgId() %>',
		},
		function(arg){
			var deliveryListInfo = eval('(' + arg + ')').deliveryListInfo;
			$("#tran_deta_addr_seq").html("");
			for(var i=0;i<deliveryListInfo.length;i++) {
				if('<%=cartInfoDto.getTran_deta_addr_seq()%>' == deliveryListInfo[i].deliveryid ){
					$("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"' selected>"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");
				}else {
					$("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"'>"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");    
				}
			}
		}
	);
}

//첨부파일 삭제
function fnAttachDel(file_list, columnName) {
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/cartAttachDelete.sys",
        { branchId:'<%=loginUserDto.getBorgId() %>' ,userId:'<%=loginUserDto.getUserId() %>'
        , file_list:file_list, columnName:columnName },
        function(arg){
            var result = eval('(' + arg + ')').customResponse;
            var errors = "";
            if (result.success == false) {
                for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
                alert(errors);
            } else {
                if(columnName=='firstattachseq') {
                    $("#firstattachseq").val('');
                    $("#attach_file_name1").text('');
                    $("#attach_file_path1").val('');
                    $("#btnAttachDel1").css("display","none");
                } else if(columnName=='secondattachseq') {
                    $("#secondattachseq").val('');
                    $("#attach_file_name2").text('');
                    $("#attach_file_path2").val('');
                    $("#btnAttachDel2").css("display","none");
                } else if(columnName=='thirdattachseq') {
                    $("#thirdattachseq").val('');
                    $("#attach_file_name3").text('');
                    $("#attach_file_path3").val('');
                    $("#btnAttachDel3").css("display","none");
                }
            }
        }
    );
}


/**
 * 주문서 출력 (2013-02-05 : by Kave)
 */
function fnOrderSheet(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt == 0) {
		alert("출력할 내용이 없습니다.");
		return;
	}	
	var borgNm		= '<%=loginUserDto.getBorgNm()%>';
	var orderNm		= $("#cons_iden_name").val();
	var skCeoNm	= '<%=Constances.EBILL_COCEO%>';
	var skAddr		= '<%=Constances.EBILL_COADDR%>';
	var skTel			= '<%=Constances.EBILL_TEL%>';
	var skFax			= '<%=Constances.EBILL_FAX%>';
	var payBillType	= '<%=cartInfoDto.getPayBillType()%>';
	var orderDesc	= '<%=cartInfoDto.getOrde_text_desc()%>';
	orderDesc 		+= "\n ※ 상기 금액은 공급가임(VAT 별도)";
	
	var branchid		= '<%=loginUserDto.getBorgId()%>';
	var userid		= '<%=loginUserDto.getUserId()%>';
	var areaType		= '<%= loginUserDto.getAreaType()%>'; 
	var workId		= '<%= loginUserDto.getWorkId()%>'; 
	
	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "orderSheet"; // reb 파일이름
	
	oReport.param("borgNm").value       = borgNm;
	oReport.param("orderNm").value      = orderNm;
	oReport.param("payBillType").value  = payBillType;
	oReport.param("skCeoNm").value      = skCeoNm;
	oReport.param("skAddr").value       = skAddr;
	oReport.param("skTel").value        = skTel;
	oReport.param("skFax").value        = skFax;
	oReport.param("orderDesc").value    = orderDesc;
	oReport.param("areaType").value      = areaType;
	oReport.param("workId").value     = workId;
	oReport.param("branchid").value     = branchid;
	oReport.param("userid").value       = userid;
	oReport.title = "주문서"; // 제목 세팅
	oReport.open(); 
}


//장바구니 마스터 정보를 변경한다. 
function fnUpdateCartMstInfo() {
	var cons_iden_name = $("#cons_iden_name").val();// 공사명
	var consIdenName_regex = /([!@#$%^&''""])/;
    if(consIdenName_regex.test(cons_iden_name)){
        $("#dialog").html("<font size='2'>공사명에 특수문자[!@#$%^&'"+'"'+"]를 \n제거해 주세요.</font>");
        $("#dialog").dialog({
            title: 'Success',modal: true,
            buttons: {"Ok": function(){$(this).dialog("close");} }
        });
        return false; 
    }
	
	var params; 
	var orde_requ_quan_arr = new Array();
	var disp_good_id_arr = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			jq('#list').saveRow(rowid);
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			orde_requ_quan_arr[i] = selrowContent.orde_requ_quan;
			disp_good_id_arr[i] = selrowContent.disp_good_id;
		} 
	}
	params = {
					comp_iden_name:$('#cons_iden_name').val()           // 공사명 
				,	orde_type_clas:$('#orde_type_clas').val()           // 주문유형
				,	tran_deta_addr_seq:$('#tran_deta_addr_seq').val()   // 배송지주소
				,	tran_user_name:$('#tran_user_name').val()           // 인수자
				,	tran_tele_numb:$('#tran_tele_numb').val()           // 인수자 전화번호
				,	mana_user_name:''
				,	orde_text_desc:$('#orde_text_desc').val()           // 비고 
				,	firstattachseq:$('#firstattachseq').val()           // 첨부파일
				,	secondattachseq:$('#secondattachseq').val()         // 첨부파일 
				,	thirdattachseq:$('#thirdattachseq').val()           // 첨부파일 
				,	orde_requ_quan_arr:orde_requ_quan_arr               // 요청수랑
				,	disp_good_id_arr:disp_good_id_arr
	};
	
	var msg  = ''; 
	for (var porpNm in params){
		msg += '\n '+porpNm+'=['+params[porpNm]+']';
	} 
	$.post(
		"/buyCart/updateCartMstInfoTransGrid.sys", 
		params,
		function(arg){ 
			if(fnTransResult(arg, false)){
				alert('장바구니 항목이 변경 되었습니다.');
			}
		}
	);
}


function fnDatepicker(id){
	alert(id);
	$("#" + id).datepicker(
    {
    	showOn: "button",
        buttonImage: "/img/contents/btn_calenda.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd",
        minDate:0
	});
	
  	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}
</script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>
</html>