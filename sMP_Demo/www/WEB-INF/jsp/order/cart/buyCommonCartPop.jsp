<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.Map" %>
<%
    LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isBuy	= "BUY".equals(loginUserDto.getSvcTypeCd()) ? true : false;
	boolean result 	= (Boolean) request.getAttribute("result");
	
	String goodIdenNumb	= null;
	String vendorId		= null;
	String quan			= null;
	String addGoodYn	= null;
	String repreGoodYn	= null;
	String goodName	= null;
	String minOrdQuan	= null;

	if( result==true ){
		goodIdenNumb	=	CommonUtils.getString( request.getAttribute("goodIdenNumb") );
		vendorId		=	CommonUtils.getString( request.getAttribute("vendorId"));
		quan			=	CommonUtils.getString( request.getAttribute("quan"));
		addGoodYn		=	CommonUtils.getString( request.getAttribute("addGoodYn"));
		repreGoodYn		=	CommonUtils.getString( request.getAttribute("repreGoodYn"));
		goodName		=	CommonUtils.getString( request.getAttribute("goodName"));
		minOrdQuan	=	CommonUtils.getString( request.getAttribute("deliMiniquan") );
	}

%>
<style type="text/css">

.jqmCartPop1 {
    display: none;
    position: fixed;
    top: 23%;
    left: 55%;
    margin-left: -320px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
}
.jqmCartPop2 {
    display: none;
    position: fixed;
    top: 37%;
    left: 60%;
    margin-left: -320px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
}
.jqmOverlay { background-color: #000; }


</style>
 <%-- 옵션팝업 --%>
	<div id="optionPop" class="jqmCartPop1">
		<div id="optionPopDrag">
			<div id="divPopup" style="width: 600px;">
				<div id="popDrag1">
					<h1>옵션선택<a href="#;"><img id="optionCloseButton1" src="/img/contents/btn_close.png"></a></h1>
				</div>
				<div class="popcont">
					<table class="InputTable" id="commonOptTable"></table>
			 		<div class="GridList">
						<table>
							<tr>
								<td>
									<div id="jqgrid">
										<table id="optionlist"></table>
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div class="Ac mgt_10">
						<a id='newSpecReqButton' 	class="btn btn-xs" style="background-color: #dddddd"><i class="fa fa-save"></i><b>신규규격요청</b></a>
						<a id='saveOptCartButton'  	class="btn btn-danger btn-xs"><i class="fa fa-save"></i>장바구니 담기</a>
						<a id='optionCloseButton2'  class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
					</div>
				</div>
			</div>
		</div>  
	</div>
<%-- /옵션팝업 --%>
<%-- 추가상품팝업 --%>
	<div id="addPop" class="jqmCartPop1">
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
<%-- /추가상품팝업 --%>
<%-- 신규규격요청팝업 --%>
	<div id="newSpecPop" class="jqmCartPop2">
		<form id="newSpecFrm" name="newSpecFrm" onsubmit="return false;">
		<div id="newSpecPopDrag">
			<div id="divPopup" style="width:600px;">
				<div id="popDrag3">
					<h1>신규 규격 요청<a href="#;"><img id="newSpecCloseButton1" src="/img/contents/btn_close.png"></a></h1>
				</div>
				<div class="popcont">
					<table class="InputTable">
						<colgroup>
							<col width="100px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>규격명</th>
							<td>
								<input id="stand_good_spec_desc" name="stand_good_spec_desc" type="text" style="width:450px" />
								<input id="stand_good_name" name="stand_good_name" type="hidden" value="<%=goodName%>">
							</td>
						</tr>
						<tr>
							<th>요청사항</th>
							<td>
								<textarea id="note" name="note"  cols="45" rows="8"  style="width:450px" ></textarea>
							</td>
						</tr>
					</table>
					<div class="Ac mgt_10">
						<a id='saveNewSpecButton' class="btn btn-warning btn-xs"><i class="fa fa-save"></i>요청</a>
						<a id='newSpecCloseButton2'  class="btn btn-default btn-xs"><i class="fa fa-close"></i>닫기</a>
					</div>
				</div>
			</div>
		</div>
		</form>
	</div>
<%-- /신규규격요청팝업 --%>
	<input type="hidden" 	id="repreGoodNumb" 	name="repreGoodNumb" 	/>
<%-- /단일상품  --%>
	<input type="hidden" 	id="tempCartQuan" 	name="tempCartQuan" 	/>
	<input type="hidden" 	id="tempCartGoodIdenNumb" 	name="tempCartGoodIdenNumb" 	/>
	<input type="hidden" 	id="tempCartVendorId" 	name="tempCartVendorId" 	/>
<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">

function fnComma(n) {
    n += '';
    var reg = /(^[+-]?\d+)(\d{3})/;
    while (reg.test(n)){
       n = n.replace(reg, '$1' + ',' + '$2');
    }
    return n;
}
function fnCntCalc(cellvalue, options, rowObject) {
	var returnInvCnt = 0;
	try{
		returnInvCnt  = rowObject.GOOD_INVENTORY_CNT;
		if(Number(returnInvCnt) < 0){ 
            returnInvCnt = 0;
		}else{
			returnInvCnt = fnComma(returnInvCnt);
		}
	}catch(e){
		returnInvCnt = 0;
	}
	return returnInvCnt;
}
//옵션 그리드
$("#optionlist").jqGrid({
	url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/getOptionPdtList/list.sys',
	multiselect:true,
	datatype: "local",
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
			editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },formatter:fnCntCalc
		},//수량	
		{name:'SET_QTY', index:'SET_QTY',align:"center", width:85,search:false,sortable:false, editable:true}//수량
	],
	postData: {},
	rowNum:0,rownumbers:false,
	height:250,width:550,
	sortname:'good_Name',sortorder:'Desc',
	viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
	loadComplete:function() {
		var rowCnt = $("#optionlist").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#optionlist").getDataIDs()[i]
				var selrowContent = $("#optionlist").jqGrid('getRowData',rowid);
				var descStr  = "<input type='text' id='setQty_"+rowid+"' name='setQty_"+rowid+"' value='' size='6' maxlength='9' requirednumber onkeydown='gridSel( event, "+rowid+")' style='text-align:right;' />";
				$("#optionlist").jqGrid('setRowData', rowid, {SET_QTY:descStr});
                $("#setQty_"+rowid).number(true);
			}
		} 
	},
	ondblClickRow:function(rowid,iRow,iCol,e) {},
	onCellSelect:function(rowid,iCol,cellcontent,target) {},
	afterInsertRow: function(rowid, aData){},
	loadError:function(xhr,st,str) { $("#optionlist").html(xhr.responseText); },
	jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
});

</script>
<%-- /추가상품팝업 --%>
<script type="text/javascript">

$(document).on("blur", "input:text[requirednumber]", function(event) { $(this).number(true); });
$(document).on("keyup", "input:text[requirednumber]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

$(document).ready(function(){

	var result = <%=result%>;
	if( result ){
		buyCommonCartPopInit();
	}else{
		alert("장바구니 담기 처리 중 오류가 발생했습니다.");
		$('.jqmClose').click();
		return;
	}
    $("input:text[requirednumber]").number(true);
});


function fnOptionSearch(goodIdenNumb, vendorId){
	var data = $("#optionlist").jqGrid("getGridParam", "postData");
	data.goodIdenNumb  	= goodIdenNumb;
	data.vendorId 		= vendorId;
	$("#optionlist").jqGrid("setGridParam", { postData: data, datatype:"json" });
	$("#optionlist").trigger("reloadGrid");	
	
}

function buyCommonCartPopInit(){
	
	var goodIdenNumb = '<%=goodIdenNumb%>';
	var vendorId	 = '<%=vendorId%>';
	var quan		 = '<%=quan%>';
	var addGoodYn	 = '<%=addGoodYn%>';
	var repreGoodYn	 = '<%=repreGoodYn%>';
	var minOrdQuan	 = '<%=minOrdQuan%>';
	
	//옵션상품 팝업
	if(repreGoodYn == 'Y'){
		fnOptionSearch(goodIdenNumb, vendorId);
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
	               			commonOptHtml+="		<select name='commonOpt_"+optCnt+"' id='commonOpt_"+optCnt+"' style='width:200px;''>";
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
               		commonOptHtml+="				<input type='text' id='commonOptCnt' name='commonOptCnt' value='"+optCnt+"'/>";
               		commonOptHtml+="			</td>";
               		commonOptHtml+="		</tr>";
               	}
               	$("#repreGoodNumb").val(goodIdenNumb);
          		$("#commonOptTable").html(commonOptHtml);
          		$("#optionPop").jqmShow();
        	}
    	);	
// 	    $('.jqmClose').click();
	    return;
	}	
	
	if(quan < Number(minOrdQuan)){
		alert("최소구매수량 "+minOrdQuan+" 개 이상 입력하여 주십시오.");
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
               		
               		var add_good_desc ="";
	               	for(var i = 0 ; i < result.length ; i++){
	               		if(i == 0){
	               			add_good_desc = result[i].ADD_GOOD_DESC; 
	               		}
    					commonAddHtml+="<tr>";
	    				commonAddHtml+="	<td align='center'><input id='addPdtSel_"+i+"' name='addPdtSel' type='radio' value='"+i+"' /></td>";
	    				commonAddHtml+="	<td class='bgGray'>";
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
	          			commonAddHtml+="					<input type='hidden' id='addOrdQuan_"+i+"' name='addOrdQuan_"+i+"' value='"+quan+"'/>";
	          			commonAddHtml+="				</ul>";
	        			commonAddHtml+="				<p class='bold'>"+fnComma(result[i].SELL_PRICE)+" 원</p>";
	        			commonAddHtml+="			</dd>";
	      				commonAddHtml+="		</dl>";
	  					commonAddHtml+="	</td>";
	  					commonAddHtml+="</tr>";
	  					
	               	}
	               	$("#repreGoodNumb").val(goodIdenNumb);
					$("#addPdtTable").html(commonAddHtml);
					$("#addProdDesc").html(add_good_desc);
					$("#addPop").jqmShow();						
               	}
            }
    	);
// 	    $('.jqmClose').click();
	    return;
	}
	$("#tempCartQuan").val(quan);
	$("#tempCartGoodIdenNumb").val(goodIdenNumb);
	$("#tempCartVendorId").val(vendorId);
    confirmMessage("해당 옵션 상품을 장바구니에 담으시겠습니까?", fnSetCartNormalPdt);
	
}
function fnSetCartNormalPdt(){
	var goodNumbs = new Array();
	var ordQuans  = new Array();
	var vendorIds = new Array();
	
	ordQuans[0]  = $("#tempCartQuan").val();
	goodNumbs[0] = $("#tempCartGoodIdenNumb").val();
	vendorIds[0] = $("#tempCartVendorId").val();
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
<%if(isBuy){%>
                $.post(
                    '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/cart/selectCartCount/cartCnt/object.sys',
                    {	
                        branchid:'<%=loginUserDto.getBorgId()%>'
                        ,userid:'<%=loginUserDto.getUserId()%>'
                        ,areaType:'<%=loginUserDto.getAreaType()%>'
                        ,workId:'<%=loginUserDto.getWorkId()%>'
                    },
                    function(arg){
                    	$("#cartCntDivId").html(eval('(' + arg + ')').cartCnt);
                    }
                );
<%}%>
                $("#pdtDetailPop").jqmHide();
                confirmMessage("장바구니로 이동하시겠습니까?", fnMoveCartInfo);
	        }else{
	           	alert(result.message);
           	}
        }
	);	
}
function fnMoveCartInfo(){
    fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
}

</script>

<script type="text/javascript">
$(function() {
	
	$("#commonCartPop").jqDrag('#userDialogHandle');

	$('#optionPop').jqm();	//Dialog 초기화
	$("#optionCloseButton1").click(function(){$("#optionPop").jqmHide();});
	$("#optionCloseButton2").click(function(){$("#optionPop").jqmHide();});
	$('#optionPop').jqm().jqDrag('#popDrag1');

	$('#addPop').jqm();	//Dialog 초기화
	$("#addCloseButton1").click(function(){$("#addPop").jqmHide();});
	$("#addCloseButton2").click(function(){$("#addPop").jqmHide();});
	$('#addPop').jqm().jqDrag('#popDrag2');

	$('#newSpecPop').jqm();	//Dialog 초기화
	$("#newSpecCloseButton1").click(function(){$("#newSpecPop").jqmHide();});
	$("#newSpecCloseButton2").click(function(){$("#newSpecPop").jqmHide();});
	$('#newSpecPop').jqm().jqDrag('#popDrag3');
	
	$("#newSpecReqButton").click(function(){
		$("#stand_good_spec_desc").val("");
		$("#note").val("");
		$("#newSpecPop").jqmShow();
	});
	$("#saveNewSpecButton").click(function(){ fnNewSpecRequest(); });
	
	$("#saveOptCartButton").click(function(){
		var commonOptCnt = Number($("#commonOptCnt").val());
		var commonOpt = "";
		
		for(var i = 0 ; i < commonOptCnt ; i++ ){
			var optVal = $.trim($("#commonOpt_" + i).val());
			if(optVal == ''){
				alert("공통옵션을 선택해 주세요.");
				$("#commonOpt_" + i).focus();
				return;
			}
			if(i == 0)	commonOpt = optVal;
			else		commonOpt += ", "+optVal;
		}
		
		var goodNumbs = new Array();			
		var ordQuans = new Array();			
		var vendorIds = new Array();			
		var chkCnt = 0;
		var id = $("#optionlist").getGridParam('selarrrow');
	    var ids = $("#optionlist").jqGrid('getDataIDs');
	    var repreGoodNumb = $("#repreGoodNumb").val();

	    if(repreGoodNumb == ''){
	    	return;
	    }
	    
	    for (var i = 0; i < ids.length; i++) {
	    	var check = false;
	        $.each(id, function (index, value) {
	        	if (value == ids[i])	check = true;
	        });
	        if (check) {
	        	var rowdata = $("#optionlist").getRowData(ids[i]);
	        	goodNumbs[chkCnt] = rowdata.GOOD_IDEN_NUMB;
	        	vendorIds[chkCnt] = rowdata.VENDORID;
// 	        	alert(vendorIds[chkCnt] = rowdata.VENDORID);
	        	
	        	if($.trim($("#setQty_"+ids[i]).val()) == ''){
	        		alert("["+rowdata.GOOD_SPEC+"] 상품의 수량을 입력해 주세요.");
	        		return;
	        	}
	        	ordQuans[chkCnt] = $("#setQty_"+ids[i]).val();
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
<%if(isBuy){%>
                $.post(
                    '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/cart/selectCartCount/cartCnt/object.sys',
                    {	
                        branchid:'<%=loginUserDto.getBorgId()%>'
                        ,userid:'<%=loginUserDto.getUserId()%>'
                        ,areaType:'<%=loginUserDto.getAreaType()%>'
                        ,workId:'<%=loginUserDto.getWorkId()%>'
                    },
                    function(arg){
                    	$("#cartCntDivId").html(eval('(' + arg + ')').cartCnt);
                    }
                );
<%}%>
	           		if(!confirm("장바구니로 이동하시겠습니까?")){
	           			$("#optionPop").jqmHide();
	           			return;
	           		}
	           		fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
	           	}else{
	           		alert(result.message);
   	           	}
	        }
		);			
	});
	
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
	
		vendorIds[0] 	= '<%=vendorId%>';
		ordQuans[0] 	= '<%=quan%>';
		goodNumbs[0] 	= '<%=goodIdenNumb%>';
		
		vendorIds[1] 	= $("#addVendorId_"+selIdx).val();
		ordQuans[1] 	= $("#addOrdQuan_"+selIdx).val();
		goodNumbs[1] 	= $("#addGoodIdenNumb_"+selIdx).val();
		
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
<%if(isBuy){%>
                $.post(
                    '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/cart/selectCartCount/cartCnt/object.sys',
                    {	
                        branchid:'<%=loginUserDto.getBorgId()%>'
                        ,userid:'<%=loginUserDto.getUserId()%>'
                        ,areaType:'<%=loginUserDto.getAreaType()%>'
                        ,workId:'<%=loginUserDto.getWorkId()%>'
                    },
                    function(arg){
                    	$("#cartCntDivId").html(eval('(' + arg + ')').cartCnt);
                    }
                );
<%}%>
   	           		if(!confirm("장바구니로 이동하시겠습니까?")){
   	           			$("#addPop").jqmHide();
   	           			return;
   	           		}
   	           		fnDynamicForm("/buyCart/buyCartInfo.sys", "","");
	           	}else{
	           		alert(result.message);
   	           	}
   	        }
   		);	
	});
	$('.jqmClose').click(function (e) {
		$("#commonCartPop").html('').jqmHide();
		$("#commonCartPop").remove();
		
	});
});

function fnNewSpecRequest(){
	$.ajax({
		url : "/newProductBidSvc/setNewGoodSpecRequest/save.sys",
		type : "post",
		dataType : "json",
		data : $('#newSpecFrm').serialize(),
		success : function(data){
			var result = data.customResponse;
			if( result.success == true ){
				alert("요청하였습니다.");
				$("#newSpecPop").jqmHide();
			}else{
				var msgs =  result.message;
				var errMsg = "";
				for(var i=0 ; i < msgs.length ; i++ ){
					errMsg += msgs[i];
				}
				alert( errMsg );
			}
		}
	});
}

function gridSel(event, rowid) {
	var selrows = $( "#optionlist" ).jqGrid('getGridParam', 'selarrrow');
	if(selrows.length == 0){
        $( "#optionlist" ).jqGrid('setSelection', rowid);
	}else{
		var chkCntTmp = 0;
		for(var i =0; i < selrows.length; i++){
			var tmpRowId = selrows[i];
			if(tmpRowId == rowid){
				chkCntTmp++;
			}
		}
		if(chkCntTmp == 0 ){
            $( "#optionlist" ).jqGrid('setSelection', rowid);
		}
	}
}

</script>

