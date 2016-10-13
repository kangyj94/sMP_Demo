<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	String srcType 			= (String)request.getParameter("srcType") == null ?   "productName" : (String)request.getParameter("srcType");
	String srcProductInput 	= (String)request.getParameter("srcProductInput") == null ?   "" : (String)request.getParameter("srcProductInput");
	
	if (userInfoDto.getSvcTypeCd().equals("BUY")) {
%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
 	$(document).ready(function() { 
 		$("#buyProductSearchBtn").click(function() {	fnBuyProdSearch();	});
		$("#openCategory").click(function() {	$("#apDiv2").show();	});
// 		$("#openCategory").hover(function() {	$("#apDiv2").show();	});
		$("#closeCategory").click(function() {	$("#apDiv2").hide();	});
		$("#btnAddMyCategory").click(function() {	fnAddMyCategory();	});
		$("#srcProductInput").keydown(function(e){ if(e.keyCode==13) { $("#buyProductSearchBtn").click(); } });
		
		fnInitBuyerProductSearch();
	});
</script>
<script type="text/javascript">
// 페이지 초기화 
function fnInitBuyerProductSearch(){
	// 진열카테고리 Level1 검색 
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/category/getBuyerDisplayCategoryInfoListJQ.sys", 
		{schRefCateSeq:0},
		
		function(arg){ 
			var displayCategoryListInfo  = eval('(' + arg + ')').displayCategoryListInfo;
			for(var i=0;i<displayCategoryListInfo.length;i++) {
				//alert(displayCategoryListInfo.product_Count); 
				var inHtml = ""; 
				inHtml +="	<table width='200' border='0' cellspacing='0' cellpadding='0'>                                                                                            \n";         
				inHtml +="		<tr>                                                                                                                                                  \n";
				inHtml +="			<td height='27' class='table_td_contents7'>                                                                                                       \n";
				inHtml +='				<a href=\'javascript:void(0);\' id="cateAtagLev1" name="cateAtagLev1" onclick=\'fnClickUserCategoryLev1( this ,"'+displayCategoryListInfo[i].cate_Id+'","'+displayCategoryListInfo[i].full_Cate_Name+'");\' class="category">'+displayCategoryListInfo[i].majo_Code_Name+'</a>';
				inHtml +='				<a href=\'javascript:void(0);\' id="cateProductCntLev1" name="cateProductCntLev1" onclick=\'fnBuyProdSearch("'+displayCategoryListInfo[i].cate_Id+'","'+displayCategoryListInfo[i].full_Cate_Name+'");\' class="category"> ('+displayCategoryListInfo[i].product_Count+') </a>';
				inHtml +="			</td>                                                                                                                                             \n";
				inHtml +="		</tr>                                                                                                                                                 \n";
				inHtml +="		<tr>                                                                                                                                                  \n";
				inHtml +="			<td class='table_middle_line'></td>                                                                                                               \n";
				inHtml +="		</tr>                                                                                                                                                 \n";
				inHtml +="	</table>                                                                                                                                                  \n";
				
				$('#dispCateLev1').append(inHtml);
 			}
		}
		
	);
}

// 대분류 카테고리 선택시 발생 이벤트 
function fnClickUserCategoryLev1(obj,refCateId,fullCateName){
	var msg = ""; 
	msg += "\n obj = ["+obj+"]";
	msg += "\n refCateId = ["+refCateId+"]";
	msg += "\n fullCateName = ["+fullCateName+"]";
	$('a[name^="cateAtagLev1"]').each(function(index) {
		$(this).removeClass("categoryOn");
		$(this).addClass("category");
	});
	$(obj).addClass("categoryOn");
	$('#tdChoiceCateFullName').html(fullCateName);
	$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/category/getBuyerDisplayCategoryInfoListJQ.sys", 
			{schRefCateSeq:refCateId},
			function(arg){
				$('#dispCateLev2').html('');
				$('#dispCateLev3').html('');
				var displayCategoryListInfo  = eval('(' + arg + ')').displayCategoryListInfo;
				for(var i=0;i<displayCategoryListInfo.length;i++) {
					var inHtml = ""; 
					inHtml +="	<table width='200' cellspacing='0' cellpadding='0'>                                                                                            \n";         
					inHtml +="		<tr>                                                                                                                                                  \n";
					inHtml +="			<td height='27' class='table_td_contents7'>                                                                                                       \n";
					inHtml +='				<a href=\'javascript:void(0);\' name="cateAtagLev2" onclick=\'fnClickUserCategoryLev2(this,"'+displayCategoryListInfo[i].cate_Id+'","'+displayCategoryListInfo[i].full_Cate_Name+'");\' class="category">'+displayCategoryListInfo[i].majo_Code_Name+'</a>';
					inHtml +='				<a href=\'javascript:void(0);\' id="cateProductCntLev1" name="cateProductCntLev1" onclick=\'fnBuyProdSearch("'+displayCategoryListInfo[i].cate_Id+'","'+displayCategoryListInfo[i].full_Cate_Name+'");\' class="category"> ('+displayCategoryListInfo[i].product_Count+') </a>';
					inHtml +="			</td>                                                                                                                                             \n";
					inHtml +="		</tr>                                                                                                                                                 \n";
					inHtml +="		<tr>                                                                                                                                                  \n";
					inHtml +="			<td class='table_middle_line'></td>                                                                                                               \n";
					inHtml +="		</tr>                                                                                                                                                 \n";
					inHtml +="	</table>                                                                                                                                                  \n";
					$('#dispCateLev2').append(inHtml);
	 			}
			}
		);
}
//중분류 카테고리 선택시 발생 이벤트 
function fnClickUserCategoryLev2(obj , refCateId,fullCateName){
	var msg = ""; 
	msg += "\n obj = ["+obj+"]";
	msg += "\n refCateId = ["+refCateId+"]";
	msg += "\n fullCateName = ["+fullCateName+"]";
	$('cateAtagLev2').addClass("category");
	$('a[name^="cateAtagLev2"]').each(function(index) {
		$(this).removeClass( ["categoryOn","category"]);
		$(this).addClass("category");
	});
	$(obj).addClass("categoryOn");
	$('#tdChoiceCateFullName').html(fullCateName);
	$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/category/getBuyerDisplayCategoryInfoListJQ.sys", 
			{ schRefCateSeq:refCateId },
			function(arg){
				$('#dispCateLev3').html('');
				var displayCategoryListInfo  = eval('(' + arg + ')').displayCategoryListInfo;
				for(var i=0;i<displayCategoryListInfo.length;i++) {
					var inHtml = ""; 
					inHtml +="	<table width='200' cellspacing='0' cellpadding='0'>                                                                                            \n";         
					inHtml +="		<tr>                                                                                                                                                  \n";
					inHtml +="			<td height='27' class='table_td_contents7'>                                                                                                       \n";
					inHtml +="				<table>																																  \n";
					inHtml +="					<tr>																																  \n";
					inHtml +="						<td>																																  \n";
					inHtml +='							<input type="checkbox" id="lastLevCateId" name="lastLevCateId" style="border:0;" value="'+displayCategoryListInfo[i].cate_Id+'"/>                               ';
					inHtml +="						</td>																															  \n";
					inHtml +="						<td valign='bottom'>																																  \n";
					inHtml +='							<a href=\'javascript:void(0);\' name="cateAtagLev3" onclick=\'fnBuyProdSearch("'+displayCategoryListInfo[i].cate_Id+'","'+displayCategoryListInfo[i].full_Cate_Name+'");\' class="category">'+displayCategoryListInfo[i].majo_Code_Name+'</a>';
					inHtml +='							<a href=\'javascript:void(0);\' id="cateProductCntLev1" name="cateProductCntLev1" onclick=\'fnBuyProdSearch("'+displayCategoryListInfo[i].cate_Id+'","'+displayCategoryListInfo[i].full_Cate_Name+'");\' class="category"> ('+displayCategoryListInfo[i].product_Count+') </a>';
					inHtml +="						</td>																															  \n";
					inHtml +="					</tr>																															  \n";
					inHtml +="				</table>																															  \n";
					inHtml +="			</td>                                                                                                                                             \n";
					inHtml +="		</tr>                                                                                                                                                 \n";
					inHtml +="		<tr>                                                                                                                                                  \n";
					inHtml +="			<td class='table_middle_line'></td>                                                                                                               \n";
					inHtml +="		</tr>                                                                                                                                                 \n";
					inHtml +="	</table>                                                                                                                                                  \n";
					$('#dispCateLev3').append(inHtml);
	 			}
			}
		);
}

function fnClickUserCategoryLev3(obj , refCateId,fullCateName){
	var msg = ""; 
	msg += "\n obj = ["+obj+"]";
	msg += "\n refCateId = ["+refCateId+"]";
	msg += "\n fullCateName = ["+fullCateName+"]";
	fnBuyProdSearch(refCateId); 
}

// 고객사 상품 검색  
function fnBuyProdSearch(srcCateId,srcFullCateName){
	 $('#prdfrm').attr('action','/product/buyProductSearchPriority.sys?_menuId=13610');
	 $('#prdfrm').attr('Target','_self');
	 $('#prdfrm').attr('method','post');	 
	 if(srcCateId != null ){
	     $('#srcCateId').val(srcCateId);
	     $('#srcFullCateName').val(srcFullCateName);
	 }
	 $('#prdfrm').submit();
}

// 마이카테고리등록
function fnAddMyCategory(){
	var chkCnt = 0;
	var cate_id_Array = new Array();
	
	$("input:checkbox[name^=lastLevCateId]").each(function(index) {
		if ( $(this).is(":checked") ) {
			cate_id_Array[chkCnt] = $(this).val(); 
			chkCnt++;
        }
	});
	
	if(chkCnt == 0 ) { 
		$('#dialogSelectRow').html('<p>선택된 카테고리 정보가 없습니다. \n확인후 이용하사기 바랍니다.</p>');
        $('#dialogSelectRow').dialog();
        return; 
	}
	
	if(!confirm("선택된 카테고리를 등록하시겠습니까?")) return;
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/category/addBorgUserCateGoryTranJQ.sys", 
		{cate_id_Array:cate_id_Array},
		function(arg){
			if(fnTransResult(arg, false)) {
				// 마이카테고리 페이지로 이동 
				if(confirm("마이카테고리 페이지로 이동하시겠습니까?")) {
                  $('#frm').attr('action','/category/myCategoryList.sys');
                  $('#frm').attr('Target','_self');
                  $('#frm').attr('method','post');
                  $('#frm').submit();
				}
			}
		}
	);
}

// 닫기 버튼 클릭시 발생 이벤트 
function fnOnClickCloseBuyerCateDiv(){
    $('#apDiv2').hide();
}
</script>
</head>
<body>
	<form id="prdfrm" name="prdfrm">
		<!-- 프론트 상단 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="3">
			<tr>
				<td width="100">
					<img id="openCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/front_btn_category.gif" width="99" height="26" style="cursor: pointer;"/>
				</td>
				<td width="20" align="right">&nbsp;</td>
				<td width="350">
                    <input type="hidden" id="srcCateId" name="srcCateId" value="" />
                    <input type="hidden" id="srcFullCateName" name="srcFullCateName" value="" />
					<select id="srcType" name="srcType" class="select" style="vertical-align: middle;">
                        <option value="productName" <%if(srcType.equals("productName")) { out.println("selected");}%>>상품명</option>
						<option value="productCode" <%if(srcType.equals("productCode")) { out.println("selected");}%>>상품코드</option>
					</select> 
					<input id="srcProductInput" name="srcProductInput" type="text" value="<%=srcProductInput %>" size="20" maxlength="50" style="width: 200px; vertical-align: middle;" />
					<img id="buyProductSearchBtn" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/front_btn_search.gif" width="44" height="22" style="vertical-align: middle; cursor: pointer;" />
				</td>
				<td>
					<label><input class="input_none radio" type="checkbox" name="srcPopularityProduct"  id="srcPopularityProduct" value="check" /> 인기상품 검색</label>
				</td>
			</tr>
		</table>
		<!-- 프론트 상단 -->
		<p></p>
		<div id="apDiv2" style="display:none ;  position: absolute; z-index: 5; left: expression(document.body.clientWidth/ 2 -483); top: 51px;">
			<table width="649" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="649" border="0" cellpadding="0" cellspacing="2" bgcolor="#b8d0ee">
							<tr>
								<td bgcolor="#d7dee6">
									<table width="649" border="0" cellspacing="1" cellpadding="0">
										<tr>
											<td width="214">
												<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/top_category_img_01.gif" width="214" height="34" />
											</td>
											<td width="214">
												<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/top_category_img_02.gif" width="214" height="34" />
											</td>
											<td align="right" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/top_category_img_04.gif);">
												<img id="btnAddMyCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_categoryAdd.gif" width="86" height="20" hspace="5" border="0" style="cursor: pointer;" />
											</td>
										</tr>
										<tr>
											<td id="dispCateLev1" valign="top" bgcolor="#FFFFFF" class="table_td_contents3">
                                            </td>
											<td  id="dispCateLev2" valign="top" bgcolor="#FFFFFF" class="table_td_contents3">
											</td>
											<td  id="dispCateLev3" valign="top" bgcolor="#FFFFFF" class="table_td_contents3">
												<!-- 상품카테고리 상세분류 시작 -->
											</td>
										</tr>
										<tr>
											<td colspan="3" align="right">
												<table width="649" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td align="left" class="table_td_contents6">
                                                            <table>
                                                               <tr>
                                                                  <td>
                                                                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/top_category_img_05.gif" width="105" height="18" style="vertical-align: middle;"/>
                                                                  </td>
                                                                  <td id="tdChoiceCateFullName">
                                                                  </td>
                                                               </tr>
                                                            </table>
														</td>
														<td width="49" align="right">
															<img id="closeCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_layerClose.gif" width="49" height="22" border="0" />
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
         <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>상품검색을 통해 주문요청할 상품을 선택해주십시오.</p>
         </div>
	</form>
</body>
</html>
<%	}	%>