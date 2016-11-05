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
	List<UserDto> userList = (List<UserDto>) request.getAttribute("userList");
	String mana_user_name = "";
	String mana_user_id = "";
	if(userList.size() > 0){
		mana_user_name = userList.get(0).getUserNm();
		mana_user_id = userList.get(0).getUserId();
	}
	
	LoginUserDto userDto = (LoginUserDto)request.getAttribute("userDto");

	boolean isBuilder = false;
	for(LoginRoleDto lrd: userDto.getLoginRoleList()){
		if("BUY_BUILDER".equals(lrd.getRoleCd())){
			isBuilder = true;
		}
	}
	String listHeight = isBuilder ==true ? "$(window).height()-340 + Number(gridHeightResizePlus)-45" : "$(window).height()-435 + Number(gridHeightResizePlus)-45";
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
<style>
body.mainBg {background:url(/img/FR/blank.gif) no-repeat;}
#divWrap                {position:relative;}

.jqmPop {
    display: none;
    position: fixed;
    top: 1%;
    left: 45%;
    margin-left: -400px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
}
.jqmOverlay { background-color: #000; }
* html .jqmPop {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
</head>
<body class="mainBg"  style="overflow-x:hidden">
<input type="hidden" id="belongBorgId" name="belongBorgId" value="<%=userDto.getBorgId()%>"/>
<input type="hidden" id="belongSvcTypeCd" name="belongSvcTypeCd" value="BUY"/>
<input type="hidden" id="moveUserId" name="moveUserId" value="<%=userDto.getUserId()%>"/>
<input type="hidden" id="repreGoodNumb" name="repreGoodNumb" value=""/>
	<div id="divWrap">
		<hr>
		<div id="divBody">
			<div id="divSub">
				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">일괄 항목</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-32px;">
                        <button id='btnProdSearchDiv' class="btn btn-danger btn-sm" ><i class="fa fa-search"></i> 상품조회</button>
					</div>
					<table class="InputTable"  \>
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
							<td><%=userDto.getBorgNms() %></td>
							<th>주문자</th>
							<td colspan="4">
								<input id="orde_user_id" name= "orde_user_id" type="hidden" value="<%= userDto.getUserId() %>" />
								<%= userDto.getUserNm() %> 
							</td>
							<th>주문자 전화번호</th>
							<td>
								<input id="orde_tele_numb" name="orde_tele_numb" type="text" value="<% if(null != userDto.getMobile()){out.print(userDto.getMobile());}  %>" size="20" style="width: 150px;ime-mode: disabled; border-color: white" disabled="disabled" maxlength="11"  onkeydown="return onlyNumber(event)" />
							</td>
						</tr>
						<tr>
							<th>주문명(주문명)</th>
							<td colspan="6">
								
							<input id="cons_iden_name" name="cons_iden_name" type="text" value="<%= cartInfoDto.getComp_iden_name() %>" size="" maxlength="250" style="width: 400px;" />
							<input id="orde_type_clas" name="orde_type_clas" type="hidden" value="<%= cartInfoDto.getOrde_type_clas() %>" size="" maxlength="250"/>
							</td>
							<th>인수자</th>
							<td>
								<input id="tran_user_name" name="tran_user_name" type="text" value="<%= cartInfoDto.getTran_user_name() %>" style="width: 100px;" size="20" maxlength="10" />
							</td>
						</tr>
						<tr>
							<th>비고</th>
							<td colspan="6">
								<input id="orde_text_desc" name="orde_text_desc" type="text" value="<%= cartInfoDto.getOrde_text_desc() %>" size="" maxlength="1000" style="width: 400px;" />
							</td>
							<th>인수자 전화번호</th>
							<td>
								<input id="tran_tele_numb" name="tran_tele_numb" type="text" value="<%= cartInfoDto.getTran_tele_numb() %>" size="20" maxlength="13" style="width: 150px;" />
							</td>
						</tr>
						<tr>
							<th><button id='btnAddDeliveryAddress' class="btn btn-darkgray btn-xs" style="">배송지관리</button></th>
							<td colspan="6">
								<select name="tran_deta_addr_seq" id="tran_deta_addr_seq" style="width:470px;" ></select>
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
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnSelOrder();">선택 상품 주문신청</a>
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
			if("Y".equals(CommonUtils.getString(cartMap.get("REPRE_GOOD"))) || "".equals(CommonUtils.getString(cartMap.get("REPRE_GOOD_IDEN_NUMB"))) == false ) 		optDispStr = "display";	
%>									
									<div class="label" >
										<span class="add" style="display: <%=addDispStr%>;cursor: text;">추가</span>
										<span class="option" style="display: <%=optDispStr %>;cursor: text;">옵션</span>
										<span class="appoint" style="display: <%=appDispStr %>;cursor: text;">지정</span>
									</div>
									<dl>
                						<dt><img src="/upload/image/<%=CommonUtils.getString(cartMap.get("IMG_PATH")) %>" onerror="this.src = '/img/layout/img_null.jpg'" width="100px;" height="100px;"/></dt>
										<dd>
												<p> <%=CommonUtils.getString(cartMap.get("GOOD_NAME"))%> </p>
											<ul>
												<li>규격&nbsp;&nbsp;&nbsp;&nbsp; : <strong><%=CommonUtils.getString(cartMap.get("GOOD_SPEC"))%></strong></li>
												<li><%=CommonUtils.getString(cartMap.get("COMMON_OPTION"))%></li>
												<li>공급사 : <strong><%=CommonUtils.getString(cartMap.get("VENDORNM"))%></strong></li>
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
									<input id="sellPrice_<%=i %>" name="sellPrice_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("SELL_PRICE"))%>"/>
									<input id="saleUnitPrice_<%=i %>" name="saleUnitPrice_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("SALE_UNIT_PRIC"))%>"/>
									<input id="ordPrice_<%=i %>" name="ordPrice_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("ORD_PRICE"))%>" />								
									<input id="goodIdenNumb_<%=i %>" name="goodIdenNumb_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("GOOD_IDEN_NUMB"))%>" />								
									<input id="vendorId_<%=i %>" name="vendorId_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("VENDORID"))%>" />								
									<input id="goodName_<%=i %>" name="goodName_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("GOOD_NAME"))%>" />								
									<input id="goodSpec_<%=i %>" name="goodSpec_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("GOOD_SPEC")) + ";" + CommonUtils.getString(cartMap.get("COMMON_OPTION"))%>" />								
									<input id="addGoodNumb_<%=i %>" name="addGoodNumb_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))%>" />								
									<input id="repreGoodNumb_<%=i %>" name="repreGoodNumb_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("REPRE_GOOD_IDEN_NUMB"))%>" />								
									<input id="isDispPastGood_<%=i %>" name="isDispPastGood_<%=i %>" type="hidden" value="<%=CommonUtils.getString(cartMap.get("ISDISPPASTGOOD"))%>" style="" />								
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
								</td>
<%			}else if("".equals(CommonUtils.getString(cartMap.get("ADD_REPRE_GOOD_IDEN_NUMB"))) ){ %>
								<td align="center">
									<button id='orderButton' class="btn btn-danger btn-sm" style="" onclick="javascript:fnOneOrder('<%=i%>');">주문</button>
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
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnSetCheckAll();">전체선택</a>
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnCartDelete();">선택 상품 삭제</a>
					</div>
					<div class="floatright mgt_10">
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnAllOrder();">전체 상품 주문신청</a>
						<a class="btn btn-danger btn-sm" style="" onclick="javascript:fnSelOrder();">선택 상품 주문신청</a>
					</div>
					<div style="height:50px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
		</div>
		<hr>
	</div>
	
	
	
	
	
	
	<!-- 상품조회 리스트 레이어 팝업 -->
	<div id="prodSearchPop" class="jqmPop">
    	<div>
		  	<div id="divPopup" style="width: 880px;">
		  		<div id="popPrSrcDrag">
			  		<h1>상품조회<a href="#;"><img id="pdSrcCloseButton1" src="/img/contents/btn_close.png"/></a></h1>
		  		</div>
		    	<div class="popcont">
		    		<table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
		    			<tr>
		    				<td align="right">
                                <button id='btnSearchProdSearchPop' class="btn btn-danger btn-xs" ><i class="fa fa-search"></i> 조회</button>
		    				</td>
		    			</tr>
		    			<tr>
		    				<td style="height: 5px"> </td>
		    			</tr>
		    		</table>
		      		<table class="InputTable">
                        <colgroup>
                            <col width="100px" />
                            <col width="auto" />
                            <col width="100px" />
                            <col width="auto" />
                        </colgroup>
                        <tr>
                            <th>상품명</th>
                            <td><input type="text" style="width:180px;" id="srcGoodName" value=""/></td>
                            <th>상품코드</th>
                            <td><input type="text" style="width:120px;" id="srcGoodIdenNumb" value=""/></td>
                        </tr>
                        <tr>
                            <th>상품구분</th>
                            <td>
                                <input type="radio" name="srcGoodType" id="srcGoodType_0" value=""  checked="checked"/> <label for="srcGoodType_0">전체</label>
                                <input type="radio" name="srcGoodType" id="srcGoodType_1" value="10"/> <label for="srcGoodType_1">일반</label>
                                <input type="radio" name="srcGoodType" id="srcGoodType_2" value="20"/> <label for="srcGoodType_2">지정</label>
                            </td>
                            <th>규격</th>
                            <td><input type="text" style="width:120px;" id="srcGoodSpec" value=""/></td>
                        </tr>
                        <tr>
                            <th>상품유형</th>
                            <td colspan="3">
                                <input type="radio" name="srcRepreGood" id="srcRepreGood_0" value="" checked="checked"/> <label for="srcRepreGood_0">전체</label>
                                <input type="radio" name="srcRepreGood" id="srcRepreGood_1" value="N"/> <label for="srcRepreGood_1">단품</label>
                                <input type="radio" name="srcRepreGood" id="srcRepreGood_2" value="Y"/> <label for="srcRepreGood_2">옵션</label>
                                <input type="radio" name="srcRepreGood" id="srcRepreGood_3" value="A"/> <label for="srcRepreGood_3">추가</label>
                            </td>
                        </tr>
                    </table>
                    
                    
                    <table class="SRCTable mgt_20" id="productList">
                        <colgroup>
                            <col width="459px" />
                            <col width="150px" />
                            <col width="150px" />
                        </colgroup>
                    </table>
                    <div class="divPageNum" id="pager"></div>
                    <div class="Ac mgt_10"> <a id='prSrcCloseButton2'  class="btn btn-default btn-xs"><i class="fa fa-close"></i> 닫기</a> </div>
                    
                    
		    	</div>
		  	</div>
	  	</div>  
  	</div>
	<!-- //상품조회 리스트 레이어 팝업 -->
	
	
	
    <input type="hidden" style="width:200px;" id="repreGoodNumbPop" value=""/>
	<!-- 옵션조회 리스트 레이어 팝업 -->
	<div id="optionDetailPop" class="jqmPop">
    	<div>
		  	<div id="divPopup" style="width: 600px;">
		  		<div id="popDetailDrag1">
			  		<h1>옵션선택<a href="#;"><img id="optionCloseButton1Pop" src="/img/contents/btn_close.png"/></a></h1>
		  		</div>
		    	<div class="popcont">
		      		<table class="InputTable" id="commonDetailOptTablePop"></table>
		      		<div class="GridList">
						<table>
							<tr>
				            	<td>
				               		<div id="jqgrid">
				                  		<table id="pdtDetailPoplist"></table>
				               		</div>
				            	</td>
				         	</tr>		        			
		      			</table>
		      		</div>
		      		<div class="Ac mgt_10">
		      			<a id='saveOptCartButtonPop'  	class="btn btn-danger btn-xs"><i class="fa fa-shopping-cart"></i>장바구니담기</a>
		      			<a id='optionCloseButton2Pop'  class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
		      		</div>
		    	</div>
		  	</div>
	  	</div>  
  	</div>
	<!-- //옵션조회 리스트 레이어 팝업 -->
	
	
	
    <%-- 추가상품 레이어 팝업 --%>
	<div id="addPop" class="jqmPop">
		<div id="addPopDrag">
			<div id="divPopup" style="width:600px;">
				<div id="popDrag2">
					<h1>추가상품 선택<a href="#;"><img id="addCloseButton1" src="/img/contents/btn_close.png"></a></h1>
				</div>
                <table><tr><td style="padding-left: 10px;padding-top: 10px"><font color="black" size="3"><span id="addProdDesc">상품설명</span></font></td></tr></table>
                <div class="Ac mgt_10">
                    <a id='saveAddCartButton'class="btn btn-danger btn-sm"><i class="fa fa-save"></i>장바구니 담기</a>
                    <a id='addCloseButton2'  class="btn btn-default btn-sm"><i class="fa fa-close"></i>닫기</a>
                </div>
                <table><tr><td style="height: 10px;"></td></tr></table>
				<div class="popcont" style=" width:568px; height:600px;overflow-y:scroll">
					<table class="SRCTable" id="addPdtTable"></table>
				</div>
			</div>
		</div>
	</div>  	
    <%-- //추가상품 레이어 팝업 --%>
	
</body>

<script>
$(document).ready(function() {
	$("#cartCheckAll").prop("checked", true);
	fnCheckAll();
	
	
	
	<%-- 상품조회 레이어팝업 관련 --%>
	$('#prodSearchPop').jqm();	//Dialog 초기화
	$("#pdSrcCloseButton1").click(function(){
		$("#prodSearchPop").jqmHide();
		fnProdSearchInit();
	});
	$("#prSrcCloseButton2").click(function(){ 
		$("#prodSearchPop").jqmHide(); 
		fnProdSearchInit();
	});
	$('#prodSearchPop').jqm().jqDrag('#popPrSrcDrag');
	$("#btnProdSearchDiv").click(function(){   
        fnProdSearchInit();
        $("#prodSearchPop").jqmShow();
        fnProdSearch();
	});
	$("#btnSearchProdSearchPop").click(function(){fnProdSearch();});
	
    $("#srcGoodName").keydown(function(e) { if(e.keyCode==13) { fnProdSearch(); } });
    $("#srcGoodIdenNumb").keydown(function(e) { if(e.keyCode==13) { fnProdSearch(); } });
    $("#srcGoodSpec").keydown(function(e) { if(e.keyCode==13) { fnProdSearch(); } });
	<%-- //상품조회 레이어팝업 관련 --%>
    
	<%-- 상품 옵션 조회 레이어팝업 관련 --%>
	$('#optionDetailPop').jqm();	//Dialog 초기화
	$("#optionCloseButton1Pop").click(function(){$("#optionDetailPop").jqmHide();});
	$("#optionCloseButton2Pop").click(function(){$("#optionDetailPop").jqmHide();});
	$('#optionDetailPop').jqm().jqDrag('#popDetailDrag1');
	$("#saveOptCartButtonPop").click(function(){
		var commonOptCnt = Number($("#commonOptCntPop").val());
		var commonOpt = "";
		
		for(var i = 0 ; i < commonOptCnt ; i++ ){
			var optVal = $.trim($("#commonOptPop_" + i).val());
			if(optVal == ''){
				alert("공통옵션을 선택해 주세요.");
				$("#commonOptPop_" + i).focus();
				return;
			}
			if(i == 0)	commonOpt = optVal;
			else		commonOpt += ", "+optVal;
		}
		
		var goodNumbs = new Array();			
		var ordQuans = new Array();			
		var vendorIds = new Array();			
		var chkCnt = 0;
		var id = $("#pdtDetailPoplist").getGridParam('selarrrow');
	    var ids = $("#pdtDetailPoplist").jqGrid('getDataIDs');
	    var repreGoodNumb = $("#repreGoodNumbPop").val();

	    if(repreGoodNumb == ''){
	    	return;
	    }
	    
	    for (var i = 0; i < ids.length; i++) {
	    	var check = false;
	        $.each(id, function (index, value) {
	        	if (value == ids[i])	check = true;
	        });
	        if (check) {
	        	var rowdata = $("#pdtDetailPoplist").getRowData(ids[i]);
	        	goodNumbs[chkCnt] = rowdata.GOOD_IDEN_NUMB;
	        	vendorIds[chkCnt] = rowdata.VENDORID;
	        	
	        	if($.trim($("#setQtyPop_"+ids[i]).val()) == ''){
	        		alert("["+rowdata.GOOD_SPEC+"] 상품의 수량을 입력해 주세요.");
	        		return;
	        	}
	        	ordQuans[chkCnt] = $("#setQtyPop_"+ids[i]).val();
	        	chkCnt++;
	        }
	    }
	    if(chkCnt == 0){
	    	alert("옵션 상품을 선택해 주세요.");
	    	return;
	    }
		if(!confirm("선택한 옵션 상품을 장바구니에 담겠습니까?")){ return false; }
		var belongBorgIdT = $.trim($("#belongBorgId").val());
		var belongSvcTypeCdT = $.trim($("#belongSvcTypeCd").val());
		var moveUserIdT = $.trim($("#moveUserId").val());
	    $.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/order/admCart/setCartInfo.sys',
			{	
	        	kind:"OPT",
				commonOpt:commonOpt,
				goodNumbs:goodNumbs,
	        	repreGoodNumb:repreGoodNumb,
	        	ordQuans:ordQuans,
	        	vendorIds:vendorIds,
	        	
                belongBorgId:belongBorgIdT,
                belongSvcTypeCd:belongSvcTypeCdT,
                moveUserId:moveUserIdT
	        },
			function(arg){
	           	var result = eval('(' + arg + ')').customResponse;
	           	
	           	if(result.success){
					alert("정상적으로 장바구니에 담았습니다.\n화면을 새로고침 합니다.");
                    fnDynamicForm("/order/admCart/admCartInfoIframe.sys?belongBorgId="+$.trim($("#belongBorgId").val())+"&belongSvcTypeCd="+$.trim($("#belongSvcTypeCd").val()) +"&moveUserId="+$.trim($("#moveUserId").val()) ,"" ,"");
	           	}else{
	           		alert(result.message);
                    $("#optionDetailPop").jqmHide();
   	           	}
	        }
		);			
	});
	<%-- //상품 옵션 조회 레이어팝업 관련 --%>
	
	
	<%-- 추가상품 조회 레이어팝업 관련 --%>
	$('#addPop').jqm();	//Dialog 초기화
	$("#addCloseButton1").click(function(){$("#addPop").jqmHide();});
	$("#addCloseButton2").click(function(){$("#addPop").jqmHide();});
	$('#addPop').jqm().jqDrag('#popDrag2');
	$("#saveAddCartButton").click(function(){
		var repreGoodNumb = $("#repreGoodNumb").val();
	    if(repreGoodNumb == ''){
	    	return;
	    }
		
		var ordQuans 		= new Array();			
		var vendorIds 		= new Array();	
		var goodNumbs 		= new Array();	
		
		var selIdx = jQuery('[name=addPdtSel]:checked').val();
		
		if(selIdx == undefined){
			alert("추가하실 상품을 선택해주세요.");
			return;
		}
	
		var tempIndex = $("#addMstIdx_"+selIdx).val();
		vendorIds[0] 	= $("#selVenderId_"+tempIndex).val();
		ordQuans[0] 	= $("#pdtOrdRequQuan_"+tempIndex).val();
		goodNumbs[0] 	= $("#good_iden_numb_"+tempIndex).val();
		
		vendorIds[1] 	= $("#addVendorId_"+selIdx).val();
		ordQuans[1] 	= $("#addOrdQuan_"+selIdx).val();
		goodNumbs[1] 	= $("#addGoodIdenNumb_"+selIdx).val();
		
		if(!confirm("해당 추가 상품을 장바구니에 담으시겠습니까?"))return;
		
		var belongBorgIdT = $.trim($("#belongBorgId").val());
		var belongSvcTypeCdT = $.trim($("#belongSvcTypeCd").val());
		var moveUserIdT = $.trim($("#moveUserId").val());
    	$.post(
   			'<%=Constances.SYSTEM_CONTEXT_PATH %>/order/admCart/setCartInfo.sys',
   			{	
               	kind:"ADD",
               	repreGoodNumb:repreGoodNumb,
               	goodNumbs:goodNumbs,
   	        	vendorIds:vendorIds,	
   	        	ordQuans:ordQuans,
	        	
                belongBorgId:belongBorgIdT,
                belongSvcTypeCd:belongSvcTypeCdT,
                moveUserId:moveUserIdT
   	        },
   			function(arg){
   	           	var result = eval('(' + arg + ')').customResponse;
   	           	
   	           	if(result.success){
					alert("정상적으로 장바구니에 담았습니다.\n화면을 새로고침 합니다.");
                    fnDynamicForm("/order/admCart/admCartInfoIframe.sys?belongBorgId="+$.trim($("#belongBorgId").val())+"&belongSvcTypeCd="+$.trim($("#belongSvcTypeCd").val()) +"&moveUserId="+$.trim($("#moveUserId").val()) ,"" ,"");
	           	}else{
	           		alert(result.message);
   	           	}
   	        }
   		);	
	});
	<%-- //추가상품 조회 레이어팝업 관련 --%>
});

function fnProdSearchInit(){
	$("#srcGoodName").val("");
	$("#srcGoodIdenNumb").val("");
	$("#"+$("input[name=srcGoodType]")[0].id).attr("checked","checked");
	$("#srcGoodSpec").val("");
	$("#"+$("input[name=srcRepreGood]")[0].id).attr("checked","checked");
	
	$("#pager").append("");	
    var length = $(".pdtData").length;
    if(length > 0){
        for(var i=0; i<length; i++){
            $("#pdtData_"+i).remove();
        }
    }
    $("#pager").empty();
}

function fnProdSearch(page){
	$.blockUI();
	var srcGoodName = $("#srcGoodName").val();
	var srcGoodIdenNumb = $("#srcGoodIdenNumb").val();
	var srcGoodType = $(':radio[name="srcGoodType"]:checked').val();
	var srcGoodSpec = $("#srcGoodSpec").val();
	var srcRepreGood = $(':radio[name="srcRepreGood"]:checked').val();
// 	alert( "srcGoodName : "+srcGoodName +"\nsrcGoodIdenNumb : "+srcGoodIdenNumb +"\nsrcGoodType ; "+srcGoodType +"\nsrcGoodSpec : "+srcGoodSpec +"\nsrcRepreGood : "+srcRepreGood);
	var belongBorgId = $("#belongBorgId").val();
	var belongSvcTypeCd = $("#belongSvcTypeCd").val();
	var moveUserId = $("#moveUserId").val();
	
	var page		= page;
	var rows		= 3;
	$.post(
		"/order/admCart/admProdSearch.sys",
		{
			srcGoodName:srcGoodName,
			srcGoodIdenNumb:srcGoodIdenNumb,
			srcGoodType:srcGoodType,
			srcGoodSpec:srcGoodSpec,
			srcRepreGood:srcRepreGood,
			
			belongBorgId:belongBorgId,
			belongSvcTypeCd:belongSvcTypeCd,
			moveUserId:moveUserId,
			
			page:page,
			rows:rows
		},
		function(arg){
            var length = $(".pdtData").length;
            if(length > 0){
                for(var i=0; i<length; i++){
                    $("#pdtData_"+i).remove();
                }
            }
            $("#pager").empty();
			var list		= arg.list;
			var currPage	= arg.page;
			var rows		= arg.rows;
			var total		= arg.total;
			var records		= arg.records;
			var pageGrp		= Math.ceil(currPage/5);
			var startPage	= (pageGrp-1)*5+1;
			var endPage		= (pageGrp-1)*5+5;
			if(Number(endPage) > Number(total)){
				endPage = total;
			}
			if(records > 0){
				<%-- 조회 결과 리스트를 variable 세팅 --%>
				for(var i=0; i<list.length; i++){
					var info = list[i].info[0];
					var str = "";
                    str += "<tr class='pdtData' id='pdtData_"+i+"'>                                                                           ";
                    str += "    <td>                                                                                                                     ";
                    str += "        <dl>                                                                                                                 ";
                    str += "            <dt>                                                                                                             ";
                    str += "                <img src=\"/upload/image/"+info.IMG_PATH+"\"  onerror=\"this.src = '/img/layout/img_null.jpg'\" width=\"100px;\" height=\"100px;\" />                                                ";
                    str += "            </dt>                                                                                                            ";
                    str += "            <dd>                                                                                                             ";
                    str += "                <p class=\"bold\">"+list[i].GOOD_NAME+"</p>                                      ";
                    str += "                <ul>                                                                                                         ";
                    str += "                    <li>규격 : <strong>"+list[i].GOOD_SPEC+"</strong></li>                                      ";
                    str += "                    <li>상품코드 : <strong>"+list[i].GOOD_IDEN_NUMB+"</strong></li>                                            ";
                    str += "                    <li>제조원 : <strong><span id=\"makeCompNameTxt_"+i+"\">"+info.MAKE_COMP_NAME+"</span></strong></li>                                                 ";
                    str += "                    <li>표준납기일 : <strong><span id=\"deliMiniDayTxt_"+i+"\">"+info.DELI_MINI_DAY+"일</span></strong></li>                                                    ";
                    str += "                </ul>                                                                                                        ";
                    str += "                <p class=\"bold\"><span id=\"sellPriceTxt_"+i+"\">"+fnComma(Math.round(info.SELL_PRICE))+" 원</span></p>                                                                     ";
                    str += "            </dd>                                                                                                            ";
                    str += "        </dl>                                                                                                                ";
                    str += "		  <input id=\"add_good_"+i+"\" name=\"add_good_"+i+"\" type=\"hidden\" value=\""+list[i].ADD_GOOD+"\"/>";
                    str += "		  <input id=\"repre_good_"+i+"\" name=\"repre_good_"+i+"\" type=\"hidden\" value=\""+list[i].REPRE_GOOD+"\"/>";
                    str += "		  <input id=\"good_iden_numb_"+i+"\" name=\"good_iden_numb_"+i+"\" type=\"hidden\" value=\""+list[i].GOOD_IDEN_NUMB+"\"/>";
                    str += "        <div class=\"label\">    ";
                    if(list[i].ADD_GOOD == 'Y') {
                    	
                    str += "        	<span class=\"option\" style=\"cursor: text;\">추가</span>";
                    
                    }
                    if(list[i].REPRE_GOOD == 'Y') {
                    	
                    str += "        	<span class=\"option\" style=\"cursor: text;\">옵션</span>                                                                                                                ";
                    
                    }
                    if(list[i].GOOD_TYPE == '20') {
                    	
                    str += "        	<span class=\"appoint\"  style=\"cursor: text;\">지정</span>                                                                                                                ";
                    
                    }
                    str += "        </div>                                                                                                                ";
                    str += "    </td>                                                                                                                    ";
                    str += "    <td>                                                                                                                     ";
                    str += "     	<ul>";
                    
                    if(list[i].info.length > 0){
                    	for(var j = 0; j < list[i].info.length ; j++){
                    		var eVendorId = list[i].GOOD_IDEN_NUMB+"_"+list[i].info[j].VENDORID;
                    		
                    str += "     		<li>";
                    str += "		  		<input id=\"selVenderId_"+i+"\" name=\"selVenderId_"+i+"\" type=\"hidden\" value=\""+list[i].info[j].VENDORID+"\"/>";
                    str += "     			<input type=\"radio\" name=\""+list[i].GOOD_IDEN_NUMB+"\" id=\""+eVendorId+"\" value=\""+eVendorId+"\" "+(j ==0 ? " checked=\"checked\" " : "" )+"  onclick='javascript:fnSelectVendor(\""+eVendorId+"\", \""+i+"\");' />";
                    str += "     			<label for=\"radio\" style=\"cursor: pointer;\" onclick='javascript:fnSelectVendor(\""+eVendorId+"\", \""+i+"\");'>"+list[i].info[j].VENDORNM+"</label>	";
                    str += "     		</li>";
                    
                    	}
                    }
                    str += "     	</ul>";
                    str += "    </td>                                                                                                                    ";
                    str += "    <td class=\"count\">                                                                                               ";
                    str += "        <ul>                                                                                                                 ";
                    str += "            <li>재고 : <span><strong class=\"f16\"><span id=\"goodInvCntTxt_"+i+"\">"+info.GOOD_INVENTORY_CNT+"</span></strong> 개</span></li>                           ";
                    if(list[i].REPRE_GOOD != 'Y') {

                    str += "            <li>수량 : <span> <input name=\"input\" type=\"text\" style=\"width:50px;\" id=\"pdtOrdRequQuan_"+i+"\" value=\""+info.DELI_MINI_QUAN+"\" onkeydown=\"return onlyNumber(event)\" /> 개</span></li>                             ";
                    
                    }
                    str += "            <li class=\"mgt_15\"><button id='btnSearchProdSearchPop' class=\"btn btn-danger btn-xs\" onclick=\"javascript:admOrdPdt('"+i+"')\"><i class=\"fa fa-shopping-cart\"></i> 장바구니담기</button> </li>                               ";
                    str += "        </ul>                                                                                                                ";
                    str += "    </td>                                                                                                                    ";
                    str += "</tr>                                                                                                                        ";
					$("#productList").append(str);
				}
				fnPager(startPage, endPage, currPage, total, 'fnProdSearch');	//페이져 호출 함수

			}else{
                str += " <tr class='pdtData' id='pdtData_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='8' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                          ";
                str += " </tr>                                                                                                                                                         ";
                $("#productList").append(str);
			}
			$.unblockUI();
		},
		"json"
	);
}
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
	n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

function  fnSelectVendor(val, cnt){
	$.blockUI({});

	$("#" + val).prop("checked", true);
	var goodIdenNumb = val.split("_")[0];
	var vendorId 	 = val.split("_")[1];
    
    $.post(  
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getChoiceVendorInfo.sys',
		{	
        	goodIdenNumb:goodIdenNumb,
        	vendorId:vendorId
        },
		function(arg){
           	var resultMap = eval('(' + arg + ')').resultMap;
           	$("#makeCompNameTxt_" + cnt).html(resultMap.MAKE_COMP_NAME);
           	$("#deliMiniDayTxt_"+cnt).html(resultMap.DELI_MINI_DAY + " 일");
           	$("#sellPriceTxt_"+cnt).html(fnComma(resultMap.SELL_PRICE)+" 원");
           	$("#goodInvCntTxt_"+cnt).html(fnComma(resultMap.GOOD_INVENTORY_CNT));
           	$("#selVenderId_"+cnt).val(vendorId);
           	
           	if(resultMap.GOOD_CLAS_CODE == '10'){
           		$("#appointDiv").show();
           	}else{
           		$("#appointDiv").hide();
           	}
           	
           	if(resultMap.REPRE_GOOD != 'Y'){
                $("#inputQuan_"+cnt).val(resultMap.DELI_MINI_QUAN);
           	}
           	
           	$.unblockUI();
    	}
	);	
}

function admOrdPdt(idx){
<%-- 옵션상품인지 여부 조회 --%>
	if( $.trim($("#repre_good_"+idx).val()) == "Y" ){
        $("#pdtDetailPoplist").jqGrid('setGridParam', {url:'/order/admCart/admProdOptList.sys'});
        var tempGoodIdenNumb = $("#good_iden_numb_"+idx).val();
        var tempVendorId 	 = $("#selVenderId_"+idx).val();
        var data = $("#pdtDetailPoplist").jqGrid("getGridParam", "postData");
        data.admGoodIdenNumb=tempGoodIdenNumb;
        data.admVendorId=tempVendorId;
        $("#pdtDetailPoplist").trigger("reloadGrid");  	
        $("#optionDetailPop").jqmShow();
        $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getProductOption.sys',  
            {	
                goodIdenNumb:tempGoodIdenNumb,
                vendorId:tempVendorId
            },
            function(arg){
                var resultMap = eval('(' + arg + ')').resultMap;
                var optList = resultMap.commonOptList;
                var commonOptHtml = "";
                var optCnt = 0;

                if(optList.length > 0 && $.trim(optList[0].OPTION_NAME) != ''){
                    commonOptHtml+="<colgroup>";
                    commonOptHtml+="	<col width='100px'/>";
                    commonOptHtml+="	<col width='auto'/>";
                    commonOptHtml+="	<col width='100px'/>";
                    commonOptHtml+="	<col width='auto'/>";
                    commonOptHtml+="</colgroup>";
                    for(var i = 0 ; i < optList.length ; i++){
                        if($.trim(optList[i].OPTION_NAME) != ''){
                            var optValues = $.trim(optList[i].OPTION_VALUE).split(";");
                            commonOptHtml+="<tr>";
                            commonOptHtml+="	<th>" + $.trim(optList[i].OPTION_NAME) + "</th>";
                            commonOptHtml+="	<td>";
                            commonOptHtml+="		<select name='commonOptPop_"+optCnt+"' id='commonOptPop_"+optCnt+"' style='width:200px;''>";
                            commonOptHtml+="			<option value=''>선택</option>";
                            for(var j = 0 ; j < optValues.length ; j++){
                                commonOptHtml+="		<option value='"+optValues[j]+"'>"+optValues[j]+"</option>";
                            }
                            commonOptHtml+="		</select>";
                            commonOptHtml+="	</td>";
                            commonOptHtml+="</tr>";
                            optCnt++;
                        }
                    }
                    commonOptHtml+="		<tr style='display:none;'>";
                    commonOptHtml+="			<td>";
                    commonOptHtml+="				<input type='text' id='commonOptCntPop' name='commonOptCntPop' value='"+optCnt+"'/>";
                    commonOptHtml+="			</td>";
                    commonOptHtml+="		</tr>";
                }
                $("#repreGoodNumbPop").val(tempGoodIdenNumb);
                $("#commonDetailOptTablePop").html(commonOptHtml);
                $("#optionDetailPop").jqmShow();
            }
        );	
        return false;
	}
	
<%-- 추가상품인지 여부 조회 --%>
	if( $.trim($("#add_good_"+idx).val()) == "Y"){
        var tempGoodIdenNumb = $("#good_iden_numb_"+idx).val();
        var tempVendorId 	 = $("#selVenderId_"+idx).val();
	    $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/admCart/admAddProdList.sys',
    		{	
            	admGoodIdenNumb:tempGoodIdenNumb
            },
    		function(arg){
               	var result = eval('(' + arg + ')').list;
               	var commonAddHtml = "";
               	if(result.length > 0){
               		
               		commonAddHtml+="<colgroup>";
               		commonAddHtml+="	<col width='30px'/>";
               		commonAddHtml+="	<col width='auto'/>";
               		commonAddHtml+="</colgroup>";
               		
               		var add_good_desc ="";
                    var quanTmp  =  $("#pdtOrdRequQuan_"+idx).val();
	               	for(var i = 0 ; i < result.length ; i++){
	               		if(i == 0){
	               			add_good_desc = result[i].ADD_GOOD_DESC; 
	               		}
    					commonAddHtml+="<tr>";
	    				commonAddHtml+="	<td align='center'><input id='addPdtSel_"+i+"' name='addPdtSel' type='radio' value='"+i+"' /></td>";
	    				commonAddHtml+="	<td class='bgGray'>";
	          			commonAddHtml+="		<input type='hidden' id='addMstIdx_"+i+"' name='addMstIdx_"+i+"' value='"+idx+"'/>";
	      				commonAddHtml+="		<dl>";
	      				commonAddHtml+="			<dt><img src='/upload/image/"+result[i].IMG_PATH+"' onerror=\"this.src = '/img/layout/img_null.jpg'\" width=\"100px;\" height=\"100px;\"/></dt>";
	      				commonAddHtml+="			<dd>";
	      				commonAddHtml+="				<p class='bold'>"+result[i].GOOD_NAME+"</p>";
	        			commonAddHtml+="				<ul>";
	          			commonAddHtml+="					<li style='width:100%;'>규격 : <strong>"+result[i].GOOD_SPEC+"</strong></li>";
	          			commonAddHtml+="					<li>상품코드 : <strong>"+result[i].GOOD_IDEN_NUMB+"</strong></li>";
	          			commonAddHtml+="					<li>표준납기일 : <strong>"+result[i].DELI_MINI_DAY+" 일</strong></li>";
	          			commonAddHtml+="					<li>공급사 : <strong>"+result[i].VENDORNM+"</strong></li>";
	          			commonAddHtml+="					<input type='hidden' id='addGoodIdenNumb_"+i+"' name='addGoodIdenNumb_"+i+"' value='"+result[i].GOOD_IDEN_NUMB+"'/>";
	          			commonAddHtml+="					<input type='hidden' id='addVendorId_"+i+"' name='addVendorId_"+i+"' value='"+result[i].VENDORID+"'/>";
	          			commonAddHtml+="					<input type='hidden' id='addOrdQuan_"+i+"' name='addOrdQuan_"+i+"' value='"+quanTmp+"'/>";
	          			commonAddHtml+="				</ul>";
	        			commonAddHtml+="				<p class='bold'>"+fnComma(result[i].SELL_PRICE)+" 원</p>";
	        			commonAddHtml+="			</dd>";
	      				commonAddHtml+="		</dl>";
	  					commonAddHtml+="	</td>";
	  					commonAddHtml+="</tr>";
	  					
	               	}
	               	$("#repreGoodNumb").val(tempGoodIdenNumb);
					$("#addPdtTable").html(commonAddHtml);
					$("#addProdDesc").html(add_good_desc);
					$("#addPop").jqmShow();						
               	}
            }
    	);
	    return false;
	}
	
<%-- 그 외 : 일반상품 조회 --%>
	var goodNumbs = new Array();
	var ordQuans  = new Array();
	var vendorIds = new Array();
	
	ordQuans[0]  = $("#pdtOrdRequQuan_"+idx).val();
	goodNumbs[0] = $("#good_iden_numb_"+idx).val();
	vendorIds[0] = $("#selVenderId_"+idx).val();
	
	if(!confirm("해당 상품을 장바구니에 담으시겠습니까?"))return;
	
    var belongBorgIdT = $.trim($("#belongBorgId").val());
    var belongSvcTypeCdT = $.trim($("#belongSvcTypeCd").val());
    var moveUserIdT = $.trim($("#moveUserId").val());
    $.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/order/admCart/setCartInfo.sys',
		{	
        	kind:"ETC",
			goodNumbs:goodNumbs,
        	ordQuans:ordQuans,
        	vendorIds:vendorIds,
	        	
            belongBorgId:belongBorgIdT,
            belongSvcTypeCd:belongSvcTypeCdT,
            moveUserId:moveUserIdT
        },
		function(arg){
   	        var result = eval('(' + arg + ')').customResponse;
   	        if(result.success){
				alert("정상적으로 장바구니에 담았습니다.\n화면을 새로고침 합니다.");
	           	fnDynamicForm("/order/admCart/admCartInfoIframe.sys?belongBorgId="+$.trim($("#belongBorgId").val())+"&belongSvcTypeCd="+$.trim($("#belongSvcTypeCd").val()) +"&moveUserId="+$.trim($("#moveUserId").val()) ,"" ,"");
	        }else{
	           	alert(result.message);
   	        }
        }
	);	
}




function fnAllOrder(){
	$("#cartCheckAll").prop("checked", true);
	fnCheckAll();
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		return false;
	}
	if(!confirm("전체 상품을 주문하시겠습니까?"))return;
	fnOrder();
}

function fnSelOrder(){
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		return false;
	}
	if(!confirm("선택하신 상품을 주문하시겠습니까?"))return;
	fnOrder();
}

function fnOneOrder(idx){
	var rowCnt = $("input[name=cartChk]:checkbox:checked").length;
	if(rowCnt ==0){
		alert("주문 할 상품을 선택해 주십시오.");
		return false;
	}
	$("#cartCheckAll").prop("checked", false);
	fnCheckAll();
	$("#cartChk_"+idx).prop("checked", true);
	fnCartSummary();	
	if(!confirm("해당 상품을 주문하시겠습니까?"))return;
	fnOrder();
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

	var cons_iden_name  = $("#cons_iden_name").val();                    // 주문명
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
			if($.trim($("#ordQuan_" + idx).val()).length == 0 || isNaN(  Number($.trim($("#ordQuan_" + idx).val())) ) == true ){
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
		alert("["+$.trim($("#goodName_" + errIdx).val()) +"] 상품의 주문수량을 확인하여주십시오.");
		$.unblockUI();
		return false;
	}
	
    var belongBorgIdT = $.trim($("#belongBorgId").val());
    var belongSvcTypeCdT = $.trim($("#belongSvcTypeCd").val());
    var moveUserIdT = $.trim($("#moveUserId").val());
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/order/admCart/setOrderCartInfo.sys',
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
			attach_file_3   	:attach_file_3,
			
            belongBorgId:belongBorgIdT,
            belongSvcTypeCd:belongSvcTypeCdT,
            moveUserId:moveUserIdT
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if(result.success){
				alert("주문이 완료되었습니다.");
                fnDynamicForm("/order/admCart/admCartInfoIframe.sys?belongBorgId="+$.trim($("#belongBorgId").val())+"&belongSvcTypeCd="+$.trim($("#belongSvcTypeCd").val()) +"&moveUserId="+$.trim($("#moveUserId").val()) ,"" ,"");
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

function fnCartDelete(){
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
	
	if(chkCnt == 0){
		alert("삭제할 상품을 선택해주세요.");
		return;
	}
	
	if(!confirm("선택하신 상품을 삭제 하시겠습니까?")) return;
	
	$.blockUI();
    var belongBorgIdT = $.trim($("#belongBorgId").val());
    var belongSvcTypeCdT = $.trim($("#belongSvcTypeCd").val());
    var moveUserIdT = $.trim($("#moveUserId").val());
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/order/admCart/deleteCartPdt.sys',
		{
			goodIdenNumbs:goodIdenNumbs,
			vendorIds:vendorIds,
			
            belongBorgId:belongBorgIdT,
            belongSvcTypeCd:belongSvcTypeCdT,
            moveUserId:moveUserIdT
		},
		function(arg){
			$.unblockUI();
			var result = eval('(' + arg + ')').custResponse;
			if(result.success){
                fnDynamicForm("/order/admCart/admCartInfoIframe.sys?belongBorgId="+$.trim($("#belongBorgId").val())+"&belongSvcTypeCd="+$.trim($("#belongSvcTypeCd").val()) +"&moveUserId="+$.trim($("#moveUserId").val()) ,"" ,"");
			}
		}
	);	
}
</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>



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
        fnDeliveryAddressManageDialog("<%=userDto.getGroupId() %>","<%=userDto.getClientId() %>","<%=userDto.getBorgId() %>","fnCallBackDeliveryAddressManage"); 
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
			branchId	: '<%=userDto.getBorgId() %>',
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
        { branchId:'<%=userDto.getBorgId() %>' ,userId:'<%=userDto.getUserId() %>'
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
</script>
<script type="text/javascript">
//옵션 그리드
$("#pdtDetailPoplist").jqGrid({
	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
	datatype: "json",
	mtype:'POST',
	colNames:['GOOD_IDEN_NUMB','VENDORID','규격', '단가', '재고', '수량'],
	colModel:[
		{name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB',width:200,align:"left",search:false,sortable:true,editable:false, hidden:true },//상품ID
		{name:'VENDORID',index:'VENDORID',width:200,align:"left",search:false,sortable:true,editable:false, hidden:true },//공급사ID
		{name:'GOOD_SPEC',index:'GOOD_SPEC',width:200,align:"left",search:false,sortable:true,editable:false },//규격
		{name:'SALE_UNIT_PRIC',index:'SALE_UNIT_PRIC',width:120,align:"right",search:false,sortable:false,
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
		},//단가			
		{name:'GOOD_INVENTORY_CNT',index:'GOOD_INVENTORY_CNT',width:80,align:"right",search:false,sortable:false,
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
		},//수량	
		{name:'SET_QTY', index:'SET_QTY',width:85,align:"center",search:false,sortable:false,editable:false }//수량
	],
	postData: {},
	multiselect:true, rowNum:0,
	rownumbers:false,
	height:250,width:550,
	sortname:'good_Name',sortorder:'Desc',
	viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
	loadComplete:function() {
		var rowCnt = $("#pdtDetailPoplist").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#pdtDetailPoplist").getDataIDs()[i];
				var selrowContent = $("#pdtDetailPoplist").jqGrid('getRowData',rowid);
				var descStr  = "<input type='text' id='setQtyPop_"+rowid+"' name='setQtyPop_"+rowid+"' size='6' maxlength=9 onkeydown='return onlyNumberPop(event)' style='text-align:right;' value=''/>";
				$("#pdtDetailPoplist").jqGrid('setRowData', rowid, {SET_QTY:descStr});
			}
		} 
	},
	ondblClickRow:function(rowid,iRow,iCol,e) {},
	onCellSelect:function(rowid,iCol,cellcontent,target) {},
	afterInsertRow: function(rowid, aData){},
	loadError:function(xhr,st,str) { $("#pdtDetailPoplist").html(xhr.responseText); },
	jsonReader: { root:"list",total:"total",records:"records",repeatitems:false,cell:"cell" }
});

function onlyNumberPop(event) {
	var key = window.event ? event.keyCode : event.which;
	if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
	|| key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
	|| key  == 8  || key  == 46 || key  == 9) // del, back space, Tab
	) {
		return true;
	}else {
		$("#ordQuanPop").focusout();
		$("#ordQuanPop").val("");
	    return false;
	}    
};
</script>
</html>