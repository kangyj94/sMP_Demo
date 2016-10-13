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
.deal_img a img { position:absolute;border:0; }
.deal_img a:hover img { width:600px; height:600px; padding:5px; background:#fff; border:1px solid #000; z-index: 999;} /* 확대했을때 보여질 이미지 */
</style>


<style type="text/css">
.jqmCartPop,.jqmPdtPop {
    display: none;
    position: fixed;
/*     position: absolute; */
    top: 17%;
    left: 50%;
    margin-left: -320px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
}
.jqmOverlay { background-color: #000; }

* html .jqmCartPop, * html .jqmPdtPop {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}

th.ui-th-column div{
    white-space:normal !important;
    height:auto !important;
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
	
	<div id="pdtDetailPop" class="jqmPdtPop">
		<div>
			<div id="divPopup" style="width:800px;">
				<div id="popDrag">
					<h1>상품상세<a href="#;"><img id="pdtCloseButton1Pop" src="/img/contents/btn_close.png"></a></h1>
				</div>
				<div id="pdtContents" class="popcont"></div>
			</div>
		</div>
	</div>
</body>

<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>

<script type="text/javascript">

$(function(){
	$('#pdtDetailPop').jqm();	//Dialog 초기화
	$("#pdtCloseButton1Pop").click(function(){$("#pdtDetailPop").jqmHide();});
	$('#pdtDetailPop').jqm().jqDrag('#popDrag');
});
//장바구니 담기 기능 
function fnBuyCommonCartPop (vendorId, goodIdenNumb, quan){
	
	$('#commonCartPop').remove();
	$("body").append('<div id="commonCartPop" name="commonCartPop" class="jqmCartPop"></div>');
	var queryStr = 	"vendorId="+vendorId+"&goodIdenNumb="+goodIdenNumb+"&quan="+quan;
	$("#commonCartPop").jqm();
	$('#commonCartPop')
		.load('/buyCart/buyCommonCartPop.sys?'+queryStr)
		.jqmShow();
	$(".jqmOverlay").remove();
}

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
        	
	      	pdtInfo += "	<div class='deal_img' id='imgPathPop' >";
	      	
			pdtInfo += "		<a href='#;'>";
			pdtInfo += "			<img src='/upload/image/"+resultList[venIdx].ORIGINAL_IMG_PATH+"' onerror=\"this.src = '/img/layout/img_null.jpg'\" width='380' height='380' />";
			pdtInfo += "		</a>";
			
	      	pdtInfo += "		<p class='col01 f14 mgt_5'><strong>상품당담자 :</strong> "+resultList[venIdx].PRODUCT_MANAGER+"</p>";
	      	pdtInfo += "	</div>";
	      	pdtInfo += "	<div class='deal_info'>";
	        pdtInfo += "		<p class='tit pdb_10'>";
			if(resultList[venIdx].GOOD_CLAS_CODE == '20'){
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
	        pdtInfo += "    			<td class='stit'>규격</td><td style=\"line-height: 20px;\">"+resultList[venIdx].GOOD_SPEC+"</td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>판매가</td><td><span class='f18 col02 bold' id='sellPricePop'>"+fnCommaPop(Math.round(resultList[venIdx].SELL_PRICE))+" 원</span></td>";
	        pdtInfo += "    		</tr>";
	        pdtInfo += "		</table>";
	        pdtInfo += "		<table>";
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>공급사</td>";
	        pdtInfo += "    			<td style=\"line-height: 20px;\">";
	        for(var i = 0 ; i < resultList.length ; i++){
	        	var isChecked = "";
	        	if(i == venIdx)isChecked = "checked=\"checked\"";
		        pdtInfo += "      			<p onclick=\"javascript:fnSelectVendorPop('selVendorIdPop_"+i+"', '"+resultList[i].GOOD_IDEN_NUMB+"', '"+resultList[i].VENDORID+"');\">";
		        pdtInfo += "      				<input type='radio' id='selVendorIdPop_"+i+"' name='selVendorIdPop' "+isChecked+" style='vertical-align:middle;'/>"; 
		        pdtInfo += "      				<label>"+resultList[i].VENDORNM+" ("+fnSetTelformat(resultList[i].PHONENUM)+")</label>";
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
	        pdtInfo += "			<tr>";
	        pdtInfo += "    			<td class='stit'>최소구매수량</td><td id='deliMiniQuanPop'>"+resultList[venIdx].DELI_MINI_QUAN+" 개</td>";
	        pdtInfo += "    		</tr>";
	        if(resultList[0].REPRE_GOOD != 'Y'){
		        pdtInfo += "		<tr>";
		        pdtInfo += "    		<td class='stit'>주문수량</td>";
		        pdtInfo += "    		<td>";
// 		        pdtInfo += "    			<input id='ordQuanPop' name='ordQuanPop' type='text' value=\""+resultList[venIdx].DELI_MINI_QUAN+"\" style='width:50px; text-align:right;' maxlength=9 onkeydown='return onlyNumberPop(event)'/> 개"; 
		        pdtInfo += "    			<input id='ordQuanPop' name='ordQuanPop' type='text' value=\"\" style='width:50px; text-align:right;' maxlength=9 onkeydown='return onlyNumberPop(event)'/> 개"; 
		        pdtInfo += "    			<span class='f11 col04' id='goodInventoryCntPop'>(재고수량 :"+resultList[venIdx].GOOD_INVENTORY_CNT+" 개)</span></td>";
		        pdtInfo += "    		</td>";
		        pdtInfo += "    	</tr>";
	        }
	        pdtInfo += "		</table>";
	        pdtInfo += "		<div class='Ac mgt_10'>";
	        
	        if(resultList[venIdx].DISPLAY_YN == "Y" && resultList[venIdx].SUB_YN == "N"){
	        	
	        pdtInfo += "			<span><a id='pdtDetailCart' class='btn btn-danger btn-sm' onclick='javascript:fnPopCartInfoPop();'><i class=\"fa fa-shopping-cart\"></i> 장바구니담기</a></span>"; 
	        pdtInfo += "			<span><a id='' class='btn btn-warning btn-sm' onclick='javascript:fnPopSetUserGood("+ temp_good_iden_numb +");'><i class=\"fa fa-heart\"></i> 관심상품담기</a></span>"; 
	        
	        }
	        
	        pdtInfo += "			<span><a id='pdtCloseButton2Pop' class='btn btn-default btn-sm' onclick='javascript:$(\"#pdtDetailPop\").jqmHide();' >닫기</a></span>";
	        pdtInfo += "		</div>";
	    	pdtInfo += "	</div>";
	    	pdtInfo += "	<ul class='tab mgt_20'>";
	    	pdtInfo += "		<li>상품정보</li>";
	    	pdtInfo += "	</ul>";
	    	pdtInfo += "	<div id='goodDescPop' style='overflow: auto; height : 200px'>"+resultList[venIdx].GOOD_DESC+"</div>";
	    	//pdtInfo += "	<div id='goodDescPop'>"+resultList[venIdx].GOOD_DESC+"</div>";
	    	
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
           	if(resultMap.GOOD_CLAS_CODE == '20'){
           		$("#appointDivPop").show();
           	}else{
           		$("#appointDivPop").hide();
           	}
           	$("#sellPricePop").html(fnCommaPop(Math.round(resultMap.SELL_PRICE))+" 원");
           	$("#makeCompNamePop").html(resultMap.MAKE_COMP_NAME);
           	$("#deliMiniQuanPop").html(resultMap.DELI_MINI_QUAN+" 개");
           	$("#deliMiniDayPop").html(resultMap.DELI_MINI_DAY+" 일");
           	$("#goodInventoryCntPop").html("(재고수량 :"+resultMap.GOOD_INVENTORY_CNT+" 개)");
           	$("#goodDescPop").html(resultMap.GOOD_DESC);
           	$("#imgPathPop").html("<a href='#;'><img src='/upload/image/"+resultMap.IMG_PATH+"' width='380' height='380' /></a>");
           	$("#vendorIdPop").val(vendorId);
           	$.unblockUI();
    	}
	);	
}

function fnPopCartInfoPop(){
	var vendorId 	 = "";
	var goodIdenNumb = "";
	var quan 		 = "";

	vendorId 	 = $("#vendorIdPop").val();
	goodIdenNumb = $("#goodIdenNumbPop").val();
	quan 		 = $("#ordQuanPop").val();
		
	if(quan == ''){
		alert("수량을 입력해 주세요.");
		return;
	}
	
	fnBuyCommonCartPop(vendorId, goodIdenNumb, quan);
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
if(document.getElementById("pdtDetailPoplist") != null){
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
}
</script>
</html>
