<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="java.util.List"%>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-295 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
    
	//화면권한가져오기(필수)
	String menuId              = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
   
    // requestParameter 
    String srcType             = (String)request.getParameter("srcType") == null ?   ""    : (String)request.getParameter("srcType");             
    String srcProductInput     = (String)request.getParameter("srcProductInput") == null ?   "" : (String)request.getParameter("srcProductInput");
    
    String srcCateId             = (String)request.getParameter("srcCateId") == null ?   ""    : (String)request.getParameter("srcCateId");
    String srcFullCateName      = (String)request.getParameter("srcFullCateName") == null ?   ""    : (String)request.getParameter("srcFullCateName");
    String srcGoodName           = "";
    String srcGoodIdenNumb      = (String)request.getParameter("srcGoodIdenNumb") == null ?   ""    : (String)request.getParameter("srcGoodIdenNumb");

    String srcPopularityProduct = (String)request.getParameter("srcPopularityProduct") == null ?   ""    : (String)request.getParameter("srcPopularityProduct");
    
    String srcBorgName = (String)request.getParameter("srcBorgName") == null ? "" : (String)request.getParameter("srcBorgName");
    String _groupId = (String)request.getParameter("_groupId") == null ? "0" : (String)request.getParameter("_groupId");
    String _clientId = (String)request.getParameter("_clientId") == null ? "0" : (String)request.getParameter("_clientId");
    String _branchId = (String)request.getParameter("_groupId") == null ? "0" : (String)request.getParameter("_branchId");
    
    
    String srcCustGoodIdenNumb = "";
    String srcGoodSpecDesc      = "";
    String srcGoodSameWord      = "";
    
    if(srcType.equals("productName"))      srcGoodName       = srcProductInput;  
    else if(srcType.equals("productCode")) srcGoodIdenNumb  = srcProductInput;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<!-- 버튼 이벤트 스크립트 -->                                                                                                                                                                   
<!-------------------------------- Dialog Div Start -------------------------------->
<%
   /**------------------------------------ 표준카테고리 조회 시작 ---------------------------------
    * fnSearchStandardCategoryInfo(isLastChoice,callbackString ) 을 호출하여 Div팝업을 Display ===
    * 
    * choiceCategoryLevel : 선택가능한 카테고리 레벨을 선택 한다. 
    *                        ex) "1" : 1레벨 부터 하위 래벨 선택 가능 
    *                            "2" : 2레벨 부터 하위 레벨 선택 가능 
    *                            "3" : 3레벨 부터 하위 레벨 선택 가능 
    * callbackString : 콜백 메소드 명을 기입 
    *                  파라미터 정보  (1.categoryseq ,2.카테고리명 ,3.풀카테고리명 )  
    */
%>
<%@ include file="/WEB-INF/jsp/common/product/buyerCategoryInfoAdm.jsp"%>
<script type="text/javascript">
/**
 * 카테고리 팝업 호출  
 */
fnInitStandardCategoryComponent("<%=_groupId %>","<%=_clientId %>","<%=_branchId %>");
function fnCategoryPopOpen(){
     fnSearchStandardCategoryInfo("1", "fnCallBackStandardCategoryChoice"); 
}
 
/**
 * 카테고리 선택 콜백   
 */
function fnCallBackStandardCategoryChoice(categortId , categortName , categortFullName) {
    var msg = ""; 
    msg += "\n categortId value ["+categortId+"]"; 
    msg += "\n categortName value ["+categortName+"]";
    msg += "\n categortFullName value ["+categortFullName+"]";
    $('#srcFullCateName').val(categortFullName);
    $('#srcCateId').val(categortId);
    //$('#srcCateId').val(categortId); 
    //$('#srcMajoCodeName').val(categortFullName);
    
    fnSearch();
}   
</script>
<script type="text/javascript">        

var jq = jQuery;                                   
$(document).ready(function() {
    
    //Component Event 
    $("#cartAdd").click( function() {           fnAddCart();            });
    $("#interestGoodAdd").click( function() {   fnInterestGoodAdd();    });
    $('#srcButton').click( function() {         fnSearch();     });
    $('#btnSearchCategory').click(function()    {   fnCategoryPopOpen();                                                                    });
    $('#btnEraseCategory').click(function()     {   $("#srcFullCateName").val(''); $("#srcCateId").val('0');                                    });
    $("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
    $("#excelButton").click(function(){ exportExcel(); });
    
    if('<%=srcPopularityProduct%>' == 'check'){
        $('#srcPopularityProduct').attr("checked", true); 
    }
    
});                                                

$(window).bind('resize', function() {              
    $("#list").setGridHeight(<%=listHeight %>);      
    $("#list").setGridWidth(<%=listWidth %>);        
}).trigger('resize');               
</script>                                          

<script type="text/javascript">   
jq(function() {
    jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/buyProductListAdmJQGrid.sys',
        editurl: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",    //활성화된 컬럼정보을 가지고 오기 위한 Dummy controller
        datatype: 'json',
        mtype: 'POST',
        colNames:['상품명','표준규격','상품규격','이미지','상품코드','고객사상품코드','공급사','단위','판매단가','매입단가','수량','금액','동의어','ord_unlimit_quan' , 'disp_good_id'],                                                                
        colModel:[
                    {name:'good_name',index:'good_name',width:200,align:"left",search:false,sortable:true,editable:false},
                    {name:'good_st_spec_desc',index:'good_St_Spec_Desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },//규격
                    {name:'good_spec_desc',index:'good_spec_desc',width:160,align:"left",search:false,sortable:false,editable:false},                                                    
                    {name:'small_img_path',index:'small_img_path',width:37,align:"center",search:false,sortable:false,editable:false },//이미지                                      
                    {name:'good_iden_numb',index:'good_iden_numb',width:75,align:"left",search:false,sortable:true,editable:false},                                                     
                    {name:'cust_good_iden_numb',index:'cust_good_iden_numb',width:75,align:"left",search:false,sortable:true,editable:false},
                    {name:'borgnm',index:'borgnm',width:100,align:"left",search:false,sortable:true,editable:false},
                    {name:'orde_clas_code',index:'orde_clas_code',width:60,align:"center",search:false,sortable:false,editable:false},
                    {name:'sell_price',index:'sell_price',width:80,align:"right",search:false,sortable:true,editable:false,formatter:'integer',
                        formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
					{name:'sale_unit_pric',index:'sale_unit_pric',width:80,align:"right",search:false,sortable:true,editable:false,formatter:'integer',
						formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
                    {name:'ord_quan',index:'ord_quan', width:60,align:"right",search:false,sortable:false,editable:true,formatter:'integer',
                        formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},               //
                    {name:'total_amout',index:'total_amout',width:60,align:"right",search:false,sortable:false,editable:false,formatter:'integer',
                        formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
                    {name:'good_same_word',index:'good_same_word',align:"left",search:false}, //good_same_word 
                    {name:'ord_unlimit_quan',index:'ord_unlimit_quan',align:"center",hidden:true,search:false}, //minOrderCnt
                    {name:'disp_good_id',index:'disp_good_id',align:"center",hidden:true,search:false,key:true}
        ],                                                                                                                                                      
        postData: {
            srcCateId:'<%=srcCateId%>'
            ,srcGoodName:'<%=srcGoodName%>'
            ,srcGoodIdenNumb:'<%=srcGoodIdenNumb%>'
            ,srcCustGoodIdenNumb:'<%=srcCustGoodIdenNumb%>'
            ,srcGoodSpecDesc:'<%=srcGoodSpecDesc%>'
            ,srcGoodSameWord:'<%=srcGoodSameWord%>'
            ,srcPopularityProduct:'<%=srcPopularityProduct%>'
            ,_groupId:'<%=_groupId %>'
			,_clientId:'<%=_clientId %>'
			,_branchId:'<%=_branchId %>'
        },
        gridviw:true,
        multiselect: false,
        rowNum:30,
        rownumbers: true,
        rowList:[30,50,100,500,1000],
        pager: '#pager',
        height: <%=listHeight %>,width:$(window).width()-60 + Number(gridWidthResizePlus),
        sortname: '', sortorder: '',
        caption:"상품조회",
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete: function() {
        	// 품목 표준 규격 설정
            var prodStSpcNm = new Array();
            <% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
                prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
            <% } %>
            
            var prodSpcNm = new Array();
            // 품목 규격 property 추출 
           <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
                prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
           <% }                                                                       %>
            
            var rowCnt = jq("#list").getGridParam('reccount');
            for(var idx=0; idx<rowCnt; idx++) {
                var rowid = $("#list").getDataIDs()[idx];
                
                jq("#list").restoreRow(rowid);
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                
                // 규격 화면 로드
                var argStArray = selrowContent.good_st_spec_desc.split("‡");
                var argArray = selrowContent.good_spec_desc.split("‡");
                
                var prodStSpec = "";
                var prodSpec = "";
                
                for(var stIdx = 0 ; stIdx < prodStSpcNm.length ; stIdx ++ ) {
                    if(argStArray[stIdx] > ' ') {
                        prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
                    }
                }
                
                if(prodStSpec.length > 0) {
                    prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
                    prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
                }
                
                for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
                    if($.trim(argArray[jIdx]) > ' ') {
                    	if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
                        else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
                    }
                }
                prodStSpec += prodSpec;
                
                jQuery('#list').jqGrid('setRowData',rowid,{good_spec_desc:prodStSpec});
                
                var imgTag = ""; 
                if($.trim(selrowContent.small_img_path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_img_path+"' style='width:35px;height:35px;' />";   
                else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
                jQuery('#list').jqGrid('setRowData',rowid,{small_img_path:imgTag});
                
                var good_same_word = selrowContent.good_same_word.replace(/‡/gi, " ");
                jQuery('#list').jqGrid('setRowData',rowid,{good_same_word:good_same_word});
            }
            
        },                                                                                                                            
        onCellSelect:function(rowid,iCol,cellcontent,target) {},      
        afterInsertRow: function(rowid, aData){},
        ondblClickRow: function (rowid, iRow, iCol, e) {},                                                                                                      
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },                                                                               
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
    });                                                                                                                                                       
});        


/**
 * 조회버튼 클릭시 발생 이벤트 
 */
function fnSearch(){
    var srcObj = new Object(); 
    srcObj['srcCateId']         =   $('#srcCateId').val();
    srcObj['srcGoodName']       =   $('#srcGoodName').val();
    srcObj['srcGoodIdenNumb']   =   $('#srcGoodIdenNumb').val();
    srcObj['srcCustGoodIdenNumb']=  $('#srcCustGoodIdenNumb').val();
    srcObj['srcGoodSpecDesc']   =   $('#srcGoodSpecDesc').val();
    srcObj['srcGoodSameWord']   =   $('#srcGoodSameWord').val();
    srcObj['srcPopularityProduct']   =   $('#srcPopularityProduct').val();
    
    jq("#list").jqGrid("setGridParam", {"page":1});
    jq("#list").jqGrid("setGridParam", { "postData": srcObj });
    jq("#list").trigger("reloadGrid");
}

</script>
<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/**
 * list 체크박스 포맷제공
 */
function checkboxFormatter(cellvalue, options, rowObject) {
    return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' style='border: 0' onclick=\"fnChangeEdit(this , '" + options.rowId + "', this);\" offval='no' />";
}
/**
 * list 체크박스 클릭 시 EditRow
 */
function fnChangeEdit(obj , rowid, object) {
    if(object.checked) {
        jq("#list").setSelection(rowid);
        jq("#list").editRow(rowid);
    } else {
        jq("#list").restoreRow(rowid);
        jq("#list").setSelection(rowid);
    }
}
// 선택 버튼 클릭시 발생 이벤트 
function fnAddCart(){
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt>0) {
        var arrRowIdx = 0 ;
        
        var disp_good_id_Array = new Array(); 
        var ord_quan_Array   = new Array();
        var stand_order_date_Array  = new Array(); 
        
        for(var i=0; i<rowCnt; i++) {
            var rowid = $("#list").getDataIDs()[i];
            if (jq("#isCheck_"+rowid).attr("checked")) {
                jq('#list').saveRow(rowid);
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                
                disp_good_id_Array[arrRowIdx] = selrowContent.disp_good_id ; 
                ord_quan_Array[arrRowIdx]     = selrowContent.ord_quan ;
                stand_order_date_Array[arrRowIdx]   = selrowContent.stand_order_date ;
                
                arrRowIdx++;
            }
        }
        
        
        var msg = ''; 
        for (var i = 0 ; i  < disp_good_id_Array.length ; i ++ ) 
            msg += '\n ['+disp_good_id_Array[i]+']';
        
        if (arrRowIdx == 0 ) {
            jq( "#dialogSelectRow" ).dialog();
            return; 
        }
        if(!confirm("선택상품을 장바구니에 담으시겠습니까?")) return;
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH%>/order/cart/addProductInCartTransGrid.sys",
            {  disp_good_id_Array:disp_good_id_Array
             , ord_quan_Array:ord_quan_Array
             , stand_order_date_Array:stand_order_date_Array
            }
            ,function(arg){ 
                if(fnTransResult(arg, false)) {    //성공시
                    
                    if(!confirm("장바구니 페이지로 이동하시겠습니까?")) {
                        jq("#list").trigger("reloadGrid");
                    }else {
                        fnGoCartPage();
                    }
                }
            }
        );
    }
}

/**
 * 관심품목 등록 
 */
function fnInterestGoodAdd(){
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt == 0 ) {
        $('#dialogSelectRow').html('<p>선택된 상품 정보가 없습니다. \n확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog();
        return; 
    }

    var arrayCnt = 0 ; 
    var disp_good_id_array = new Array();
    for(var idx=0; idx<rowCnt; idx++){
        var rowIdx = $("#list").getDataIDs()[idx];
        
        if($("#isCheck_"+rowIdx).attr("checked")){
            isCheak = true; 
            var selrowContent = jq("#list").jqGrid('getRowData',rowIdx);
            disp_good_id_array[arrayCnt] = selrowContent.disp_good_id;
            arrayCnt++; 
        }
    }
    
    if(arrayCnt==0) { 
        $('#dialogSelectRow').html('<p>선택된 상품 정보가 없습니다. \n확인후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog(); 
        return; 
    }
    
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/addInterestProductTransGrid.sys", 
        { disp_good_id_array:disp_good_id_array },
        function(arg){
            if(fnTransResult(arg, false)) { //성공시
                // 관심품목 페이지로 이동 
                if(confirm("관심상품 페이지로 이동하시겠습니까?")) {
                    fnGoInterestProduct(); 
                }else {
                    jq("#list").trigger("reloadGrid");  
                }  
            }
        }
    );
}
 
/**
 * 체크된 리스트의 일괄수정 및 삭제(수정:MOD, 삭제:DEL)
 */
function listSaveRow(transFlag) {
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt>0) {
        var codeTypeIdArray = new Array();
        var codeTypeNmArray = new Array();
        var codeFlagArray = new Array();
        var isUseArray = new Array();
        var codeTypeDescArray = new Array();
        var arrayCnt = 0;
        for(var i=0; i<rowCnt; i++) {
            var rowid = $("#list").getDataIDs()[i];
            var isCheckList = jq("#isCheck_"+rowid).attr("checked");
            if(isCheckList) {
                if(!jq('#list').saveRow(rowid)) return;
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                codeTypeIdArray[arrayCnt] = selrowContent.codeTypeId;
                codeTypeNmArray[arrayCnt] = selrowContent.codeTypeNm;
                codeFlagArray[arrayCnt] = selrowContent.codeFlag;
                isUseArray[arrayCnt] = selrowContent.isUse;
                codeTypeDescArray[arrayCnt] = selrowContent.codeTypeDesc;
                jq("#list").editRow(rowid);
                arrayCnt++;
            }
        }
        if(arrayCnt==0) { jq( "#dialogSelectRow" ).dialog(); return; }
        if(!confirm("선택정보을 처리하겠습니까?")) return;
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/codeTypeCheckTransGrid.sys", 
            { transFlag:transFlag, codeTypeIdArray:codeTypeIdArray, codeTypeNmArray:codeTypeNmArray, 
                codeFlagArray:codeFlagArray, isUseArray:isUseArray, codeTypeDescArray:codeTypeDescArray },
            function(arg){ 
                if(fnAjaxTransResult(arg)) {    //성공시
                    jq("#list").trigger("reloadGrid");
                }
            }
        );
    } else jq( "#dialogSelectRow" ).dialog();
}
/**
 * list Excel Export
 */
function exportExcel() {
    var colLabels = ['상품명','상품규격','상품코드','공급사','단위','단가','수량','금액'];          //출력컬럼명
    var colIds = ['good_name','good_spec_desc','good_iden_numb','borgnm','orde_clas_code','sell_price','ord_quan','total_amout'];  //출력컬럼ID
    
    var numColIds = ['sell_price','ord_quan','total_amout'];    //숫자표현ID
    var sheetTitle = "상품검색결과";  //sheet 타이틀
    var excelFileName = "ProductList";  //file명
    
    /*---------------------엑셀출력 체크박스 제한-----------------------*/
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt>0) {
        for(var i=0; i<rowCnt; i++) {
            var rowid = $("#list").getDataIDs()[i];
            var isCheckList = jq("#isCheck_"+rowid).attr("checked");
            if(isCheckList) {
                alert("엑셀 출력은 체크박스을 해제하시고 수행하십시오!");
                return;
            }
        }
    }
    
    fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/**
 * 상품 상세  
 */
function fnProductDetailForBuyer(disp_good_id){
    fnCustProductDetailView('<%=menuId%>', disp_good_id);   
}

/**
 * 장바구니 페이지로 이동 
 */
function fnGoCartPage() {
	$('#frm').attr('action','/order/cart/cartMstInfo.sys');
	$('#frm').attr('Target','_self');
	$('#frm').attr('method','post');
	$('#frm').submit();
}

/**
 * 관심상품 페이지로 이동  
 */
function fnGoInterestProduct(){
    $('#frm').attr('action','/product/buyWishList.sys');
    $('#frm').attr('Target','_self');
    $('#frm').attr('method','post');
    $('#frm').submit(); 
} 
/**
 * 주문 리스트 페이지로 이동 
 */
function fnGoOrderList(){
    $('#frm').attr('action','/order/orderRequest/orderList.sys');
    $('#frm').attr('Target','_self');
    $('#frm').attr('method','post');
    $('#frm').submit(); 
} 
</script>
</head>
<body>
    <form id="frm" name="frm">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top">
                            <td width="20" valign="middle">
                                <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                            </td>
                            <td height="29" class='ptitle' width="150">고객사상품조회</td>
                            <td height="29" valign="middle"> <b>조회 구매사 : </b><%=srcBorgName %></td>
                            <td align="right" class='ptitle'>
                                <img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style='border: 0; cursor: pointer; vertical-align: middle;' />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <!-- 컨텐츠 시작 -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="6" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">카테고리</td>
                            <td class="table_td_contents" colspan="5">
                                <input id="srcFullCateName" name="srcFullCateName" type="text" value="<%=srcFullCateName%>" size="20" maxlength="30" style="width: 400px; width: 60%; background-color: #eaeaea;" disabled="disabled" /> <input
                                    id="srcCateId" name="srcCateId" type="hidden" value="" readonly="readonly" />
                                <img id="btnSearchCategory" src="/img/system/btnCategorySearch.gif" class="icon_search" style="border: 0; vertical-align: middle; cursor: pointer;" />
                                <img id="btnEraseCategory" src="/img/system/btnBegin.gif" class="icon_search" style="border: 0; vertical-align: middle; cursor: pointer;" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">상품명</td>
                            <td class="table_td_contents">
                                <input id="srcGoodName" name="srcGoodName" type="text" value="<%=srcGoodName%>" style="width:  98%; width:120px;" />
                            </td>
                            <td class="table_td_subject" width="100">상품코드</td>
                            <td class="table_td_contents">
                                <input id="srcGoodIdenNumb" name="srcGoodIdenNumb" type="text" value="<%=srcGoodIdenNumb %>" style="width: 98%; width: 120px;" />
                            </td>
                            <td class="table_td_subject">고객사상품코드</td>
                            <td class="table_td_contents">
                                <input id="srcCustGoodIdenNumb" name="srcCustGoodIdenNumb" type="text" style="width: 98%; width: 120px;" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">상품규격</td>
                            <td class="table_td_contents">
                                <input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" style="width: 98%; width: 120px;" />
                            </td>
                            <td width="80" class="table_td_subject">동의어</td>
                            <td class="table_td_contents">
                                <input id="srcGoodSameWord" name="srcGoodSameWord" type="text" style="width: 98%; width: 120px;" />
                            </td>
                            <td width="80" class="table_td_subject">인기상품</td>
                            <td class="table_td_contents" style="text-align: left; vertical-align: middle;">
                                <input style="border: 0;" type="checkbox" name="srcPopularityProduct" id="srcPopularityProduct" value="check" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="table_top_line"></td>
                        </tr>
                    </table>
                    <!-- 컨텐츠 끝 -->
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    <img id="colButton" src="/img/system/icon/Equipment.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
                    <img id="excelButton" src="/img/system/icon/Table.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
                </td>
            </tr>
            <tr>
                <td>
                    <div id="jqgrid">
                        <table id="list"></table>
                        <div id="pager"></div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
    </form>
    <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
        <p>처리할 데이터를 선택 하십시오!</p>
    </div>
    <div id="dialog" title="Feature not supported" style="display: none;">
        <p>That feature is not supported.</p>
    </div>
</body>
</html>