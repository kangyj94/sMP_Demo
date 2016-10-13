<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>

<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> -->
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->

<!-- <head> -->
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script> --%>
<%-- <script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script> --%>
<%-- 
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.layout.js" type="text/javascript"></script> 
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/i18n/grid.locale-kr.js" type="text/javascript"></script> 
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.alphanumeric.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/Validation.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.ui.datepicker-ko.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.formatCurrency-1.4.0.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.maskedinput-1.3.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jshashtable-2.1.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.blockUI.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/custom.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.money.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.number.js" type="text/javascript"></script>
 --%>

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
<!-- </head> -->
<!-- <body>  -->
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
			  		<h1>추가구성상품<a href="#;"><img id="pdtCloseButton1Pop" src="/img/contents/btn_close.png"></a></h1>
		  		</div>		  		
		    	<div id="pdtContents" class="popcont"></div>
		  	</div>    	
	  	</div>  
  	</div>
  	
<!-- </body> -->

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	$('#pdtDetailPop').jqm();	//Dialog 초기화
	$("#pdtCloseButton1Pop").click(function(){$("#pdtDetailPop").jqmHide();});
	$('#pdtDetailPop').jqm().jqDrag('#popDrag');
});

function fnProductDetailPop(ordeIdenNumb, ordeSequNumb){
    $.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/venProduct/selectVenProductDetailInfoPop.sys',
   		{	
			ordeIdenNumb:ordeIdenNumb
			, ordeSequNumb:ordeSequNumb
		},
   		function(arg){
			var resultList = null;
			try{
                resultList = eval('(' + arg + ')').list[0];
			}catch(exception){
				alert("상품정보 조회에 실패하였습니다.");  
				$("#pdtDetailPop").jqmHide();
				return false;
			}  
        	var venIdx = 0;
        	
        	var pdtInfo = "";
        	
	      	pdtInfo += "	<div class='deal_img' id='imgPathPop' ><img src='/upload/image/"+resultList.IMG_PATH+"'   onerror=\"this.src = '/img/layout/img_null.jpg'\"   width='380' height='380' />";
	      	pdtInfo += "		<p class='col01 f14 mgt_5'><strong>상품당담자 :</strong> "+resultList.PRODUCT_MANAGER+"</p>";
	      	pdtInfo += "	</div>";
	      	pdtInfo += "	<div class='deal_info'>";
	        pdtInfo += "		<p class='tit pdb_10'>";
			if(resultList.GOOD_CLAS_CODE == '10'){
		        pdtInfo += "		<span id='appointDivPop' class='appoint'>지정</span>";
			}	        
			if(resultList.REPRE_GOOD == 'Y'){
		        pdtInfo += "		<span class='option'>옵션</span>";
			}
			if(resultList.ADD_GOOD == 'Y'){
		        pdtInfo += "		<span class='add'>추가</span>";
			}
	        pdtInfo += 				resultList.GOOD_NAME;
	        pdtInfo += "		</p>";
	        pdtInfo += "		<table>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>규격</td><td style=\"line-height: 20px;\">"+resultList.GOOD_SPEC+"</td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "		</table>";
	        pdtInfo += "		<table>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>공급사</td>";
	        pdtInfo += "    			<td>";
		    pdtInfo += "      				"+resultList.VENDORNM+"";
	        pdtInfo += "      		</td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>제조사</td><td id='makeCompNamePop'>"+resultList.MAKE_COMP_NAME+"</td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>표준납기일</td><td id='deliMiniDayPop'>"+resultList.DELI_MINI_DAY+" 일</td>";
	        pdtInfo += "    		</tr>";
            pdtInfo += "		<tr>";
            pdtInfo += "    		<td class='stit'>수량</td>";
            pdtInfo += "    		<td>";
            pdtInfo += "    			<span>"+resultList.PURC_REQU_QUAN+" 개</span>";
            pdtInfo += "    		</td>";
            pdtInfo += "    	</tr>";
	        pdtInfo += "		</table>";
	        pdtInfo += "		<div class='Ac mgt_10'>";
	        pdtInfo += "			<span><a id='pdtCloseButton2Pop' class='btn btn-default btn-sm' onclick='javascript:$(\"#pdtDetailPop\").jqmHide();' >닫기</a></span>";
	        pdtInfo += "		</div>";
	    	pdtInfo += "	</div>";
	    	pdtInfo += "	<ul class='tab mgt_20'>";
	    	pdtInfo += "		<li>상품정보</li>";
	    	pdtInfo += "	</ul>";
	    	pdtInfo += "	<div id='goodDescPop'>"+resultList.GOOD_DESC+"</div>";
	    	
	    	$("#repreGoodPop").val(resultList.REPRE_GOOD);
	    	$("#addGoodPop").val(resultList.ADD_GOOD);
	    	$("#vendorIdPop").val(resultList.VENDORID);
	    	$("#vendorNmPop").val(resultList.VENDORNM);
	    	$("#goodIdenNumbPop").val(resultList.GOOD_IDEN_NUMB);
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
</script>

<!-- </html> -->