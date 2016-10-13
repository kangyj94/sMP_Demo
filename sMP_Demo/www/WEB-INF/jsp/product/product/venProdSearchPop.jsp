<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<style type="text/css">
.jqmPop {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
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
<body>
	<input type="hidden" id="repreGoodNumbPop" 	name="repreGoodNumbPop"/>
	<input type="hidden" id="vendorIdPop" 		name="vendorIdPop"/>
	<input type="hidden" id="vendorNmPop" 		name="vendorNmPop"/>
	<input type="hidden" id="goodIdenNumbPop" 	name="goodIdenNumbPop"/>
	<input type="hidden" id="addGoodPop" 		name="addGoodPop"/>
	<input type="hidden" id="repreGoodPop" 		name="repreGoodPop"/>
	
    <div id="pdtDetailPop" class="jqmPop">
    	<div>
		  	<div id="divPopup" style="width:800px;">
		  		<div id="popDrag">
			  		<h1>상품상세<a href="#;"><img id="pdtCloseButton1Pop" src="/img/contents/btn_close.png"/></a></h1>
		  		</div>		  		
		    	<div id="pdtContents" class="popcont"></div>
		  	</div>    	
	  	</div>  
  	</div>
  	
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
		      			<a id='newOptionReqButtonPop' 	class="btn btn-warning btn-xs"><i class="fa fa-save"></i>신규옵션요청</a>
		      			<a id='saveOptCartButtonPop'  	class="btn btn-warning btn-xs"><i class="fa fa-save"></i>장바구니 담기</a>
		      			<a id='optionCloseButton2Pop'  class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
		      		</div>
		    	</div>
		  	</div>
	  	</div>  
  	</div>
  	
  	<div id="addDetailPop" class="jqmPop">
    	<div>
  			<div id="divPopup" style="width:600px;">
  				<div id="popDetailDrag2">
	  				<h1>추가상품 선택<a href="#;"><img id="addCloseButton1Pop" src="/img/contents/btn_close.png"/></a></h1>
  				</div>
    			<div class="popcont">
    				<table class="SRCTable" id="addDetailPdtTable"></table>
    				<div class="Ac mgt_10">
		      			<a id='saveAddCartButtonPop'class="btn btn-warning btn-xs"><i class="fa fa-save"></i>장바구니 담기</a>
		      			<a id='addCloseButton2Pop'  class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
    				</div>
    			</div>
  			</div>      
    	</div>
    </div>
    
    <div id="newOptionPop" class="jqmPop">
    	<div>
  			<div id="divPopup" style="width:600px;">
  				<div id="newOptionDrag">
	  				<h1>신규 옵션 요청<a href="#" id="newOptCloseButton1Pop"><img src="/img/contents/btn_close.png"/></a></h1>
  				</div>
  			
    			<div class="popcont">
      				<table class="InputTable">
      					<colgroup>
      						<col width="100px" />
        					<col width="auto" />
      					</colgroup>
        				<tr>
          					<th>규격명</th>
          					<td><input type="text" style="width:450px" /></td>
        				</tr>
        				<tr>
          					<th>요청사항</th>
          					<td><textarea id=" " cols="45" rows="8"  style="width:450px" ></textarea></td>
        				</tr>
      				</table>
      				<div class="Ac mgt_10">
      					<a id='newOptionButtonPop' 		class="btn btn-warning btn-xs"><i class="fa fa-save"></i>신규옵션요청</a>
      					<a id='newOptCloseButton2Pop'  	class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
      				</div>
    			</div>
  			</div>      	
    	</div>
	</div>
</body>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	$('#pdtDetailPop').jqm();	//Dialog 초기화
	$("#pdtCloseButton1Pop").click(function(){$("#pdtDetailPop").jqmHide();});
	$('#pdtDetailPop').jqm().jqDrag('#popDrag');
	
	$('#optionDetailPop').jqm();	//Dialog 초기화
	$("#optionCloseButton1Pop").click(function(){$("#optionDetailPop").jqmHide();});
	$("#optionCloseButton2Pop").click(function(){$("#optionDetailPop").jqmHide();});
	$('#optionDetailPop').jqm().jqDrag('#popDetailDrag1');

	$('#addDetailPop').jqm();	//Dialog 초기화
	$("#addCloseButton1Pop").click(function(){$("#addDetailPop").jqmHide();});
	$("#addCloseButton2Pop").click(function(){$("#addDetailPop").jqmHide();});
	$('#addDetailPop').jqm().jqDrag('#popDetailDrag2');	

	$('#newOptionPop').jqm();	//Dialog 초기화
	$("#newOptCloseButton1Pop").click(function(){$("#newOptionPop").jqmHide();});
	$("#newOptCloseButton2Pop").click(function(){$("#newOptionPop").jqmHide();});
	$('#newOptionPop').jqm().jqDrag('#newOptionDrag');	
	
	
	$("#newOptionReqButtonPop").click(function(){
		$("#newOptionPop").jqmShow();
	});
	
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
	    
	    if(!confirm("해당 옵션 상품을 장바구니에 담으시겠습니까?"))return;
		
	    $.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/setCartInfo.sys',
			{	
	        	kind:"OPT",
				commonOpt:commonOpt,
				goodNumbs:goodNumbs,
	        	repreGoodNumb:repreGoodNumb,
	        	ordQuans:ordQuans,
	        	vendorIds:vendorIds
	        },
			function(arg){
	           	var result = eval('(' + arg + ')').customResponse;
	           	
	           	if(result.success){
	           		if(!confirm("장바구니로 이동하시겠습니까?"))return;
	           		fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
	           	}else{
	           		alert(result.message);
	           	}
	        }
		);			
	});
	
	$("#saveAddCartButtonPop").click(function(){
		var repreGoodNumb = $("#repreGoodNumbPop").val();
		alert(repreGoodNumb);
	    if(repreGoodNumb == ''){
	    	return;
	    }
		
		var ordQuans 		= new Array();			
		var vendorIds 		= new Array();	
		var goodNumbs 		= new Array();	
		
		var selIdx = jQuery('[name=addPdtSelPop]:checked').val();
		
		var repreIdx = $("#repreCntPop_"+selIdx).val();
		
	    if(selIdx == undefined){
	    	alert("추가하실 상품을 선택해주세요.");
	    	return;
	    }
	    
	    vendorIds[0] 	= $("#vendorIdPop").val();
		ordQuans[0] 	= $("#ordQuanPop").val();
		goodNumbs[0] 	= $("#goodIdenNumbPop").val();
		
		vendorIds[1] 	= $("#addVendorIdPop_"+selIdx).val();
		ordQuans[1] 	= $("#addOrdQuanPop_"+selIdx).val();
		goodNumbs[1] 	= $("#addGoodIdenNumbPop_"+selIdx).val();
		
		if(!confirm("해당 추가 상품을 장바구니에 담으시겠습니까?"))return;
		
    	$.post(
   			'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/setCartInfo.sys',
   			{	
               	kind:"ADD",
               	repreGoodNumb:repreGoodNumb,
               	goodNumbs:goodNumbs,
   	        	vendorIds:vendorIds,            	
   	        	ordQuans:ordQuans
   	        },
   			function(arg){
   	           	var result = eval('(' + arg + ')').customResponse;
   	           	
   	           	if(result.success){
   	           		if(!confirm("장바구니로 이동하시겠습니까?"))return;
   	           		fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
   	           	}   	           	
   	        }
   		);	
	});	
});

function fnProductDetailPop(goodIdenNumb, vendorId){
	if(goodIdenNumb == '')return;
    $.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getProductDetailInfoPop.sys',
   		{	
			goodIdenNumb:goodIdenNumb
		},
   		function(arg){
			var resultList = null;
			var temp_good_iden_numb = null;
			try{
                resultList = eval('(' + arg + ')').list[0].info;
				temp_good_iden_numb = eval('(' + arg + ')').GOOD_IDEN_NUMB;
			}catch(exception){
				alert("상품정보 조회에 실패하였습니다.");  
				$("#pdtDetailPop").jqmHide();
				return false;
			}  
        	var venIdx = 0;
        	
        	for(var i = 0 ; i < resultList.length ; i++){
        		if(vendorId == resultList[i].VENDORID){
        			venIdx = i;
        			break;
        		}
        	}
        	
        	var pdtInfo = "";
        	
	      	pdtInfo += "	<div class='deal_img' id='imgPathPop' ><img src='"+resultList[venIdx].IMG_PATH+"' width='380' height='380' />";
	      	pdtInfo += "		<p class='col01 f14 mgt_5'><strong>상품당담자 :</strong> "+resultList[venIdx].PRODUCT_MANAGER+"</p>";
	      	pdtInfo += "	</div>";
	      	pdtInfo += "	<div class='deal_info'>";
	        pdtInfo += "		<p class='tit pdb_10'>";
			if(resultList[venIdx].GOOD_CLAS_CODE == '10'){
		        pdtInfo += "		<span id='appointDivPop' class='appoint'>지정</span>";
			}	        
			if(resultList[venIdx].REPRE_GOOD == 'Y'){
		        pdtInfo += "		<span class='option'>옵션</span>";
			}
			if(resultList[venIdx].ADD_GOOD == 'Y'){
		        pdtInfo += "		<span class='add'>추가</span>";
			}
	        pdtInfo += 				resultList[venIdx].GOOD_NAME;
	        pdtInfo += "		</p>";
	        pdtInfo += "		<table>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>규격</td><td>"+resultList[venIdx].GOOD_SPEC+"</td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>판매가</td><td><span class='f18 col02 bold' id='sellPricePop'>"+fnCommaPop(resultList[venIdx].SELL_PRICE)+" 원</span></td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "		</table>";
	        pdtInfo += "		<table>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>공급사</td>";
	        pdtInfo += "    			<td>";
	        for(var i = 0 ; i < resultList.length ; i++){
	        	var isChecked = "";
	        	if(i == venIdx)isChecked = "checked=\"checked\"";
		        pdtInfo += "      			<p onclick=\"javascript:fnSelectVendorPop('selVendorIdPop_"+i+"', '"+resultList[i].GOOD_IDEN_NUMB+"', '"+resultList[i].VENDORID+"');\">";
		        pdtInfo += "      				<input type='radio' id='selVendorIdPop_"+i+"' name='selVendorIdPop' "+isChecked+"/>"; 
		        pdtInfo += "      				<label>"+resultList[i].VENDORNM+"</label>";
		        pdtInfo += "      			</p>";
	        }
	        pdtInfo += "      			</td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>제조사</td><td id='makeCompNamePop'>"+resultList[venIdx].MAKE_COMP_NAME+"</td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>표준납기일</td><td id='deliMiniDayPop'>"+resultList[venIdx].DELI_MINI_DAY+" 일</td>";
	        pdtInfo += "    		</tr>";
	        if(resultList[0].REPRE_GOOD != 'Y'){
		        pdtInfo += "		<tr>";
		        pdtInfo += "    		<td class='stit'>주문수량</td>";
		        pdtInfo += "    		<td>";
		        pdtInfo += "    			<input id='ordQuanPop' name='ordQuanPop' type='text' value=\""+resultList[venIdx].DELI_MINI_QUAN+"\" style='width:50px; text-align:right;' maxlength=9 onkeydown='return onlyNumberPop(event)'/> 개"; 
		        pdtInfo += "    			<span class='f11 col04' id='goodInventoryCntPop'>(재고수량 :"+resultList[venIdx].GOOD_INVENTORY_CNT+" 개)</span></td>";
		        pdtInfo += "    		</td>";
		        pdtInfo += "    	</tr>";
	        }
	        pdtInfo += "		</table>";
	        pdtInfo += "		<div class='Ac mgt_10'>";
	        
	        if(resultList[venIdx].DISPLAY_YN == "Y"){
	        	
	        pdtInfo += "			<span><a id='pdtDetailCart' class='btn btn-danger btn-sm' onclick='javascript:fnPopCartInfoPop();'><i class=\"fa fa-shopping-cart\"></i> 장바구니담기</a></span>"; 
	        pdtInfo += "			<span><a id='' class='btn btn-warning btn-sm' onclick='javascript:fnPopSetUserGood("+ temp_good_iden_numb +");'><i class=\"fa fa-heart\"></i> 관심상품담기</a></span>"; 
	        
	        }
	        
	        pdtInfo += "			<span><a id='pdtCloseButton2Pop' class='btn btn-default btn-sm' onclick='javascript:$(\"#pdtDetailPop\").jqmHide();' >닫기</a></span>";
	        pdtInfo += "		</div>";
	    	pdtInfo += "	</div>";
	    	pdtInfo += "	<ul class='tab mgt_20'>";
	    	pdtInfo += "		<li>상품정보</li>";
	    	pdtInfo += "	</ul>";
	    	pdtInfo += "	<div id='goodDescPop'>"+resultList[venIdx].GOOD_DESC+"</div>";
	    	
	    	$("#repreGoodPop").val(resultList[venIdx].REPRE_GOOD);
	    	$("#addGoodPop").val(resultList[venIdx].ADD_GOOD);
	    	$("#vendorIdPop").val(resultList[venIdx].VENDORID);
	    	$("#vendorNmPop").val(resultList[venIdx].VENDORNM);
	    	$("#goodIdenNumbPop").val(temp_good_iden_numb);
        	$("#pdtContents").html(pdtInfo);
        	$("#pdtDetailPop").jqmShow();
       	}
   	);	
}
//3자리수마다 콤마
function fnCommaPop(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
	n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

function  fnSelectVendorPop(id, goodIdenNumb, vendorId){
	$.blockUI({});
	$("#" + id).prop("checked", true);
    $.post(  
        '<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getChoiceVendorInfo.sys',
		{	
        	goodIdenNumb:goodIdenNumb,
        	vendorId:vendorId
        },
		function(arg){
           	var resultMap = eval('(' + arg + ')').resultMap;
           	if(resultMap.GOOD_CLAS_CODE == '10'){
           		$("#appointDivPop").show();
           	}else{
           		$("#appointDivPop").hide();
           	}
           	$("#sellPricePop").html(fnCommaPop(resultMap.SELL_PRICE)+" 원");
           	$("#makeCompNamePop").html(resultMap.MAKE_COMP_NAME);
           	$("#deliMiniDayPop").html(resultMap.DELI_MINI_DAY+" 일");
           	$("#goodInventoryCntPop").html("(재고수량 :"+resultMap.GOOD_INVENTORY_CNT+" 개)");
           	$("#goodDescPop").html(resultMap.GOOD_DESC);
           	$("#imgPathPop").html("<img src='"+resultMap.IMG_PATH+"' width='380' height='380' />");
           	
           	$("#vendorIdPop").val(vendorId);
           	$.unblockUI();
    	}
	);	
}

function fnPopCartInfoPop(){
	var vendorId 	 = "";
	var goodIdenNumb = "";
	var quan 		 = "";
	var addGoodYn	 = "";
	var repreGoodYn  = "";

	vendorId 	 = $("#vendorIdPop").val();
	goodIdenNumb = $("#goodIdenNumbPop").val();
	quan 		 = $("#ordQuanPop").val();
	addGoodYn	 = $("#addGoodPop").val();
	repreGoodYn  = $("#repreGoodPop").val();
		
	if(quan == ''){
		alert("수량을 입력해 주세요.");
		return;
	}
	//옵션상품 팝업
	if(repreGoodYn == 'Y'){
		fnOptionSearchPop(goodIdenNumb, vendorId);
	    $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getProductOption.sys',
    		{	
            	goodIdenNumb:goodIdenNumb,
            	vendorId:vendorId
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
	               	
	               	$("#repreGoodNumbPop").val(goodIdenNumb);
              		$("#commonDetailOptTablePop").html(commonOptHtml);
              		$("#optionDetailPop").jqmShow();
               	}
        	}
    	);	
	    return;
	}	
	
	//추가상품 팝업
	if(addGoodYn == 'Y'){
	    $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/product/getAddPdtList/list.sys',
    		{	
            	goodIdenNumb:goodIdenNumb
            },
    		function(arg){
               	var result = eval('(' + arg + ')').list;
               	var commonAddHtml = "";
               	if(result.length > 0){
               		
               		commonAddHtml+="<colgroup>";
               		commonAddHtml+="	<col width='30px'/>";
               		commonAddHtml+="	<col width='auto'/>";
               		commonAddHtml+="</colgroup>";
               		
	               	for(var i = 0 ; i < result.length ; i++){
    					commonAddHtml+="<tr>";
	    				commonAddHtml+="	<td align='center'><input id='addPdtSelPop_"+i+"' name='addPdtSelPop' type='radio' value='"+i+"' /></td>";
	    				commonAddHtml+="	<td class='bgGray'>";
	      				commonAddHtml+="		<dl>";
	      				commonAddHtml+="			<dt><img src='/img/contents/product_photo.jpg' /></dt>";
	      				commonAddHtml+="			<dd>";
	      				commonAddHtml+="				<p class='bold'>"+result[i].GOOD_NAME+"</p>";
	        			commonAddHtml+="				<ul>";
	          			commonAddHtml+="					<li style='width:100%;'>규격 : <strong>"+result[i].GOOD_SPEC+"</strong></li>";
	          			commonAddHtml+="					<li>상품코드 : <strong>"+result[i].GOOD_IDEN_NUMB+"</strong></li>";
	          			commonAddHtml+="					<li>표준납기일 : <strong>"+result[i].DELI_MINI_DAY+" 일</strong></li>";
	          			commonAddHtml+="					<li>공급사 : <strong>"+result[i].VENDORNM+"</strong></li>";
	          			commonAddHtml+="					<input type='hidden' id='addGoodIdenNumbPop_"+i+"' name='addGoodIdenNumbPop_"+i+"' value='"+result[i].GOOD_IDEN_NUMB+"'/>";
	          			commonAddHtml+="					<input type='hidden' id='addVendorIdPop_"+i+"' name='addVendorIdPop_"+i+"' value='"+result[i].VENDORID+"'/>";
	          			commonAddHtml+="					<input type='hidden' id='addOrdQuanPop_"+i+"' name='addOrdQuanPop_"+i+"' value='"+quan+"'/>";
	          			commonAddHtml+="					<input type='hidden' id='repreCntPop_"+i+"' name='repreCntPop_"+i+"' value='"+i+"'/>";
	          			commonAddHtml+="				</ul>";
	        			commonAddHtml+="				<p class='bold'>"+fnComma(result[i].SELL_PRICE)+" 원</p>";
	        			commonAddHtml+="			</dd>";
	      				commonAddHtml+="		</dl>";
	  					commonAddHtml+="	</td>";
	  					commonAddHtml+="</tr>";
	  					
	               	}
	               	$("#repreGoodNumbPop").val(goodIdenNumb);
					$("#addDetailPdtTable").html(commonAddHtml);
					$("#addDetailPop").jqmShow();						
               	}
            }
    	);
	    return;
	}
	

	
	var goodNumbs = new Array();
	var ordQuans  = new Array();
	var vendorIds = new Array();
	
	ordQuans[0]  = quan;
	goodNumbs[0] = goodIdenNumb;
	vendorIds[0] = vendorId;
	
	if(!confirm("해당 상품을 장바구니에 담으시겠습니까?"))return;
	
    $.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/setCartInfo.sys',
		{	
        	kind:"ETC",
			goodNumbs:goodNumbs,
        	ordQuans:ordQuans,
        	vendorIds:vendorIds
        },
		function(arg){
           	var result = eval('(' + arg + ')').customResponse;

           	if(result.success){
           		if(!confirm("장바구니로 이동하시겠습니까?"))return;
           		fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
           	}           	
        }
	);	
}

function fnOptionSearchPop(goodIdenNumb, vendorId){
	$("#pdtDetailPoplist").jqGrid('setGridParam', {url:'/product/getOptionPdtList/list.sys'});
   	var data = $("#pdtDetailPoplist").jqGrid("getGridParam", "postData");
   	data.goodIdenNumb  	= goodIdenNumb;
   	data.vendorId 		= vendorId;
   	$("#pdtDetailPoplist").trigger("reloadGrid");  	
}

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

function fnPopSetUserGood(goodIdenNumb){

	if( ! confirm("해당 상품을 관심상품에 담으시겠습니까?") ){ return;}
	
	$.post(
		'/buyProduct/setUserGood.sys',
		{	
			goodIdenNumb : goodIdenNumb
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;

			if(result.success){
				if(!confirm("관심상품 페이지로 이동하시겠습니까?"))return;
				fnDynamicForm("/buyProduct/getBuyUserGoodList.sys", "","");
			}else{
				var errs = result.message;
				var msg = "";
				for(var i=0 ; i < errs.length; i++){
					msg += errs[i];
				}
				alert(msg);
			}
		}
	);	
	
}

</script>

<script type="text/javascript">
//옵션 그리드
$("#pdtDetailPoplist").jqGrid({
	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
	multiselect:true,
	datatype: "json",
	mtype:'POST',
	colNames:['GOOD_IDEN_NUMB','VENDORID','규격', '단가', '재고', '수량'],
	colModel:[
		{name:'GOOD_IDEN_NUMB',index:'GOOD_IDEN_NUMB',width:200,align:"left",search:false,sortable:true,editable:false, hidden:true },//상품ID
		{name:'VENDORID',index:'VENDORID',width:200,align:"left",search:false,sortable:true,editable:false, hidden:true },//공급사ID
		{name:'GOOD_SPEC',index:'GOOD_SPEC',width:200,align:"left",search:false,sortable:true,editable:false },//규격
		{name:'SELL_PRICE',index:'SELL_PRICE',width:120,align:"right",search:false,sortable:false,
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
		},//단가			
		{name:'GOOD_INVENTORY_CNT',index:'GOOD_INVENTORY_CNT',width:80,align:"right",search:false,sortable:false,
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
		},//수량	
		{name:'SET_QTY', index:'SET_QTY',width:85,align:"center",search:false,sortable:false,editable:false }//수량
	],
	postData: {},
	rowNum:0,rownumbers:false,rowList:[30,50,100,500],
	height:250,width:550,
	sortname:'good_Name',sortorder:'Desc',
	viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
	loadComplete:function() {
		FnUpdatePagerIcons(this);
		var rowCnt = $("#pdtDetailPoplist").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#pdtDetailPoplist").getDataIDs()[i];
				var selrowContent = $("#pdtDetailPoplist").jqGrid('getRowData',rowid);
				var descStr  = "<input type='text' id='setQtyPop_"+rowid+"' name='setQtyPop_"+rowid+"' size='6' maxlength=9 onkeydown='return onlyNumberPop(event)' style='text-align:right;'/>";
				$("#pdtDetailPoplist").jqGrid('setRowData', rowid, {SET_QTY:descStr});
			}
		} 
	},
	ondblClickRow:function(rowid,iRow,iCol,e) {},
	onCellSelect:function(rowid,iCol,cellcontent,target) {},
	afterInsertRow: function(rowid, aData){},
	loadError:function(xhr,st,str) { $("#pdtDetailPoplist").html(xhr.responseText); },
	jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
});
</script>
</html>



