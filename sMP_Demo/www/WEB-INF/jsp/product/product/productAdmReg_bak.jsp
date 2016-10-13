<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%
    //그리드의 width와 Height을 정의
    // 파라미터 설정
    
    String width = "$(window).width()-60 + Number(gridWidthResizePlus)";
    
    String good_iden_numb = request.getAttribute("good_iden_numb") == null ? "": (String) request.getAttribute("good_iden_numb");
    String cate_id = request.getAttribute("cate_id") == null ? ""              : (String) request.getAttribute("cate_id");
    String bidid = request.getAttribute("bidid") == null ? ""                  : (String) request.getAttribute("bidid");
    String vendorid = request.getAttribute("vendorid") == null ? ""            : (String) request.getAttribute("vendorid");
    String bid_vendorid = request.getAttribute("bid_vendorid") == null ? ""    : (String) request.getAttribute("bid_vendorid");
    String req_good_id = request.getAttribute("req_good_id") == null ? ""    : (String) request.getAttribute("req_good_id");
    LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
    @SuppressWarnings("unchecked")
    //화면권한가져오기(필수)
    List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
    
    @SuppressWarnings("unchecked") List<CodesDto> deliAreaCodeList  = (List<CodesDto>) request.getAttribute("deliAreaCodeList");
    @SuppressWarnings("unchecked") List<CodesDto> vTaxTypeCode      = (List<CodesDto>) request.getAttribute("vTaxTypeCode");
    @SuppressWarnings("unchecked") List<CodesDto> orderGoodsType    = (List<CodesDto>) request.getAttribute("orderGoodsType");
    @SuppressWarnings("unchecked") List<CodesDto> orderUnit        = (List<CodesDto>) request.getAttribute("orderUnit");
    @SuppressWarnings("unchecked") List<CodesDto> reqAppSts        = (List<CodesDto>) request.getAttribute("reqAppSts");
    @SuppressWarnings("unchecked") List<CodesDto> isdistributeSts  = (List<CodesDto>) request.getAttribute("isdistributeSts");
    
    //현재날짜받아오기
    String getYear = CommonUtils.getCurrentDate();
    getYear = getYear.substring(0, 4);
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>운영사 상품 상세</title>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>

<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<%
/**------------------------------------공급사  사용방법---------------------------------
* fnProductSalePriceDialog(goodIdenNumb, callbackString) 을 호출하여 Div팝업을 Display ===
* goodIdenNumb : 상품코드
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(,,) 
*/
%>
<script type="text/javascript">
// 공급사 조회 
function fnSearchVendor() {
    var rowId       = $("#prodVendor").getGridParam("selrow");
    if(rowId == null){
        $('#dialogSelectRow').html('<p>선택된 공급사 정보가 없습니다.\n공급사 선택후 이용하시기 바랍니다.</p>');
        $("#dialogSelectRow").dialog();
        return;
    }
    var vendorNm = $("#textVendorNm").val();
    fnVendorDialog(vendorNm, "fnCallBackVendor");
}

// 공급사 선택시 CallBack Function 
function fnCallBackVendor(vendorId, vendorNm, areaType) {
    
    //공급사 선택시 기존 공급사 존재여부 
    if(fnIsExistVendorInfo('prodVendor', vendorId)){
        $('#dialogSelectRow').html('<p>이미 추가된 공급사 정보입니다.</p>');
        $("#vtax_clas_code").focus();
        $("#dialogSelectRow").dialog();
        return true; 
    }
        
    $("#vendorid").val(vendorId);
    $("#vendornm").val(vendorNm);
    $("#areatype").val(areaType);
    $('#make_comp_name').val(vendorNm);
    
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/vendorDetail.sys"
        , { srcVendorId:vendorId }
        , function(arg) {
           var detailInfo = eval('(' + arg + ')').detailInfo;
           $('#vendorcd').val(detailInfo.vendorCd);
           $('#pressentnm').val(detailInfo.pressentNm);
           $('#phonenum').val(detailInfo.phoneNum);
           
           // 변경 이벤트 발생 
           $("#vendorid").change();
           $('#vendorcd').change();
           $("#vendornm").change();
           $("#areatype").change();
           $('#phonenum').change();
           $('#pressentnm').change();
           $('#make_comp_name').change();
     });
 }
</script>
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
<%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp" %>
<script type="text/javascript">
// 카테고리 Div팝업 호출  
function fnSearchCategory() {
    fnSearchStandardCategoryInfo("3", "fnCallBackStandardCategoryChoice");
}
// 카테고리 Call Back 실행  
function fnCallBackStandardCategoryChoice(categortId, categortName, categortFullName) {
    var msg = ""; 
    msg += "\n categortId value ["+categortId+"]"; 
    msg += "\n categortName value ["+categortName+"]";
    msg += "\n categortFullName value ["+categortFullName+"]";
    
    if($('#cate_id').val(categortId)){
        $("#cate_id").change();    
    };
    $('#full_cate_name').val(categortFullName);
    
    //상품진열정보 조회 
    var data = jq("#dispCategory").jqGrid("getGridParam", "postData");
    data.cate_id = categortId;
    jq("#dispCategory").jqGrid("setGridParam", { "postData": data });
    jq("#dispCategory").trigger("reloadGrid");
}
</script>

<%/**------------------------------------ 이미지 파일 추가 시작 ---------------------------------*/%>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<% /*------------------------------------Img File Upload 스크립트--------------------------------- */ %>
<script type="text/javascript">
$(function() {
   var btnUpload=$('#btnAttach');
   var status=$('#status');
   new AjaxUpload(btnUpload, {
      action:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/imageResizeProcess.sys',
      name:'imageFile',
      data:{},
      onSubmit:function(file,ext) {
          if(!(ext && /^(jpg|jpeg|gif)$/.test(ext))) {
              alert('이미지 파일(jpg,jpeg,gif) 파일만 등록 가능합니다.');
             //status.text("이미지 파일만 등록 가능합니다.");   // extension is not allowed
             return false;
          }
         if(!confirm("이미지를 등록하시겠습니까?")) {
            return false;
         }
         status.text('Uploading...');
      },
      onComplete: function(file,response) {
         status.text('');
         var result  = eval("(" +response + ")");
         
         var imgPathForORGIN = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + result.ORGIN;
         var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.SMALL;
         var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.MEDIUM;
         var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.LARGE;
         

         // 이미지 변경  
         $('#SMALL').attr('src',imgPathForSMALL);
         $('#MEDIUM').attr('src',imgPathForMEDIUM);
         $('#LARGE').attr('src',imgPathForLARGE);
         
         // 경로 설정
         $('#original_img_path').val(result.ORGIN);
         $('#large_img_path ').val(result.LARGE);
         $('#middle_img_path').val(result.MEDIUM);
         $('#small_img_path ').val(result.SMALL);
         
         
         var msg = ""; 
         msg = '\n imgPathForORGIN  value['+imgPathForORGIN +']'; 
         msg = '\n imgPathForSMALL  value['+imgPathForSMALL +']'; 
         msg = '\n imgPathForMEDIUM value['+imgPathForMEDIUM+']'; 
         msg = '\n imgPathForLARGE  value['+imgPathForLARGE +']'; 
         // 이미지 Grid 등록
         $('#original_img_path').change();
         $('#large_img_path ').change();
         $('#middle_img_path').change();
         $('#small_img_path ').change();
         
      }
   });
});

function attachDel() {
    // 이미지 변경
    $('#SMALL').attr('src','/img/system/imageResize/prod_img_50.gif');
    $('#MEDIUM').attr('src','/img/system/imageResize/prod_img_70.gif');
    $('#LARGE').attr('src','/img/system/imageResize/prod_img_100.gif');
    
    // 경로 설정
    $('#original_img_path').val('');
    $('#large_img_path').val('');
    $('#middle_img_path').val('');
    $('#small_img_path').val('');
    $('#original_img_path').focus();
}
</script>
<%/**------------------------------------ 이미지 파일 추가 끝 ---------------------------------*/%>
<script type="text/javascript">
$(window).bind('resize', function() { 
    $("#dispCategory").setGridWidth(<%=width %>);
    $("#prodVendor").setGridWidth(<%=width %>);
    $("#prodDisplay").setGridWidth(<%=width %>);
}).trigger('resize');
</script>
<%
/**------------------------------------상품판매가상세정보팝업 사용방법---------------------------------
* () 을 호출하여 Div팝업을 Display ===
* goodIdenNumb : 상품코드
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(,,) 
*/
%>
<%@ include file="/WEB-INF/jsp/product/product/productSalePriceInfoDiv.jsp" %>
<script type="text/javascript">
    // 진열정보 수정및 등록 처리시
    function fnInitSalePriceDialog(mod){
        var rowId       = $("#productMaster").getGridParam("selrow");
        var mstGridData = jq("#productMaster").jqGrid('getRowData',rowId);
        
        if($.trim(mstGridData['good_iden_numb']) == ''){
            $('#dialogSelectRow').html('<p>상품 기본정보 저장후 이용하시기 바랍니다.</p>');
            $("#dialogSelectRow").dialog();
            return true;
        }
        
        // 존재여부
        var isBe = false;
        var rowCnt = jq("#prodVendor").getGridParam('reccount'); 
        if(rowCnt > 0){
            for(var i=0 ; i<rowCnt ; i++) {
                var venRowid = $("#prodVendor").getDataIDs()[i];
                var venRowData = jq("#prodVendor").jqGrid('getRowData',venRowid);
                
                if($.trim(venRowData['orgvendorid']) != '' ){
                    isBe = true;                
                }
            }
        }
        
        if(!isBe) {
            $('#dialogSelectRow').html('<p>유효한 공급사 정보가 없습니다. 공급사 등록후 이용하시기 바랍니다.</p>');
            $("#dialogSelectRow").dialog();
            return true;
        }
        
        // 진열SEQ
        
        var mstGridData = jq("#productMaster").jqGrid('getRowData',$("#productMaster").getGridParam("selrow"));
        var good_iden_numb = mstGridData['good_iden_numb']; 
        var disp_good_id =0;
        
        if(mod == 'add'){
            fnProductSalePriceDialog(good_iden_numb, disp_good_id);
        }else{
            // 수정 및 삭제 
            var rowid = $("#prodDisplay").getGridParam("selrow");
            if(rowid == null){
                $('#dialogSelectRow').html('<p>진열정보 선택후 이용하시기 바랍니다.</p>');
                $("#dialogSelectRow").dialog();
                window.setTimeout(function(){ $("#dialogSelectRow").dialog("close");},500); 
                return true;
            }
            
            var gridData = jq("#prodDisplay").jqGrid('getRowData',rowid);
            disp_good_id = gridData['disp_good_id']; 
            
            if(mod == 'mod' ){
               fnProductSalePriceDialog(good_iden_numb,disp_good_id);
            }else if(mod == 'del' ){
                if(!confirm("선택한 진열정보를 삭제 하시겠습니까?")) return false;
                //555
                var params = {disp_good_id:disp_good_id};
                $.post(
                    "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/prodSalePriceDelTransGrid.sys",
                    params,
                    function(arg) {
                        var msg = eval('(' + arg + ')').msg;
                        if($.trim(msg) != '' ){
                            $("#dialog").html(msg);
                            $("#dialog").dialog({
                                title: 'Fail',modal: true,
                                buttons: {"Ok": function(){$(this).dialog("close");} }
                            });
                        }else {
                            $("#dialog").html("처리하였습니다.");
                            $("#dialog").dialog({
                                title: 'Success',modal: true,
                                buttons: {"Ok": function(){$(this).dialog("close");} }
                            });
                        }
                        window.setTimeout(function(){ $("#dialog").dialog("close");},500); 
                        var mstGridData = jq("#productMaster").jqGrid('getRowData',$("#productMaster").getGridParam("selrow"));
                        jq("#prodDisplay").jqGrid("setGridParam", { "postData": {good_iden_numb:mstGridData['good_iden_numb']}});
                        jq("#prodDisplay").trigger("reloadGrid");
                        fnDisplayOpenPopClose();
                    }
                );
            }
        }
    }
</script>

<%
/**------------------------------------상품판매가상세정보팝업 사용방법---------------------------------
* () 을 호출하여 Div팝업을 Display ===
* goodIdenNumb : 상품코드
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(,,) 
*/
%>
<%@ include file="/WEB-INF/jsp/product/product/productInsSalePriceInfoDiv.jsp" %>
<script type="text/javascript">

</script>

<%
   /**------------------------------------고객사팝업 사용방법---------------------------------
    * fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
    * borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
    * isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
    * borgNm : 찾고자하는 고객사명
    * callbackString : 콜백함수(문자열), 콜백함수파라메타는 4개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String) 
    */
%>
<%@ include file="/WEB-INF/jsp/common/buyMultiBorgListDiv.jsp"%>
<script type="text/javascript">
function fnSearchBuyBorg() {
   var borgNm = $("#srcBorgNameDiv").val();
   fnBuyMultiborgDialog("CLT", "", "");
}

// 멀티선택 
function fnBuyMultiCallBack(rtnArryObj){
    var msg = ''; 
    msg += ''; 
    
    for(var idx = 0 ; idx < rtnArryObj.length ; idx ++) {
        var selBorgInfo = rtnArryObj[idx];
        var rowCnt = jq("#insDispBorg").getGridParam('reccount');
        
        var isExists = false; 
        for(var i=0 ; i<rowCnt ; i++) {
            var gridRowId = $("#insDispBorg").getDataIDs()[i];
            var exData = jq("#insDispBorg").jqGrid('getRowData',gridRowId);
            if(exData['borgId'] == selBorgInfo['borgId'])   isExists = true; 
        }
        
        if(!isExists){
            $("#insDispBorg").addRowData(selBorgInfo['borgId'],selBorgInfo);    
        }
    }
}
</script>
<%
   /**------------------------------------고객사팝업 사용방법---------------------------------
    * fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
    * borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
    * isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
    * borgNm : 찾고자하는 고객사명
    * callbackString : 콜백함수(문자열), 콜백함수파라메타는 4개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String) 
    */
%>
<%@ include file="/WEB-INF/jsp/product/product/productSalePriceHistDiv.jsp" %>
<script type="text/javascript">
//Div Open
function fnShowDispProductInfoPastInfo(rowid){
     
    fnProductSalePriceHistDialog(rowid);
}

//과거상품 저장
function fnParDisplayGoodUpdate(paramObj){
    if(!confirm("과거상품 진열 여부를 저장하시겠습니까?")) return;
    
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/displayGoodUpdateTrans.sys", 
        paramObj,
        function(arg){ 
            if(fnTransResult(arg, true)) {
                fnProductSalePriceHistClose();
            }
        }
    );
} 

</script>







<script type="text/javascript">
    //존재 여부에 확인 funtion 
    jQuery.fn.exists = function(){return ($(this).length > 0);} ; 
    
    var jq = jQuery;                            // jQuery  설정 
    var reqParamObj = new Object();             // RequestParameter 설정
    
//      var defObj = new jQuery.Deferred();         // Deferred() 를 이용하여 비동기 적 실행을 동기적 실행 방식으로 변경한다.
//      defObj.progress(
//          function(insMod ){
//              if(insMod == 'setPramsDone'){
//                 fnInitDispCategoryGrid();                   // 카테고리 정보 조회
//                 //fnLoadDisplayDataSet();                     // 진열정보
//                 //fnLoadCodeDataSet( );                       // 코드 정보 조회
// //                 fnInitCodeDataSet();
//             }else if(insMod == 'codeDataDone'){
//                 fnLoadProductMasterDataSet();               // 마스터 정보 조회
//                 fnLoadProductVendorDataSet();               // 공급사 정보 
//                 fnLoadDisplayDataSet();
//              }else if(insMod =='loadProductVendorDataDone'){
//                  fnLoadDisplayDataSet();                             //  진열정보 위치변경 
//              }else if(insMod =='loadDisplayDataDone'){
//                  defObj.resolve();
//              }
//          }
//      ).done(function(){
//      });
    
//     var vendorDef = new jQuery.Deferred();          // Deferred() 를 이용하여 비동기 적 실행을 동기적 실행 방식으로 변경한다.
//     vendorDef.progress(
//         function(insMod ){
//             if(insMod == 'loadPrdVendorDataDone'){
//                 fnLoadBidVendorInfo();                  //  
//             }else if(insMod =='loadBidDataDone'){
//              fnLoadNewProductInfo();
//             }else if(insMod =='loadNewProductDataDone'){
//                 vendorDef.resolve();
//             }
//         }
//     ).done(function(){ 
//         fnSetProdVendorComponent(); 
//          defObj.notify('loadProductVendorDataDone');
//     });
    
    
    
    $(document).ready(function() {
        // component 이벤트 등록 
        $('#btnSearchCategory').click( function() { fnSearchCategory(); });
        $('#btnProdVendorCopy').click( function() { fnProdVendorCopy(); });
        $('#btnProdVendorAdd').click(  function() { fnProdVendorAdd(); });
        $('#btnProdVendorDel').click(  function() { fnProdVendorDelOrdeCheck(); });
        $('#btnProdMstSave')  .click(  function() { fnSaveProductInfo(); });
        $('#btnCommonClose')  .click(  function() { fnThisPageClose(); });
        $("#btnVendor")       .click(  function() { fnSearchVendor(); });   
        
        // 매입단가 변경 
        $('#btnAlterPrice').click( function()       { if($("#divSoldOut").css('display') == 'none') { fnOepnChagePriceDiv(); } });
        $('#btnReqestChangePrice').click(function() { fnReqestChangePrice(); });
        $('#btnSoldOut').click( function()          { if($("#divReqChangePrice").css('display') == 'none') { fnOepnSoldOutDiv(); } });
        $('#btnReqSoldOut').click( function()       {   fnRequestSoldOut()  ;   });
        $('#btnChnUseSts').click( function()        {   fnUseStatsModify()  ;   });
        
        //판가 정보 
        $("#btnDispAdd")   .click(    function() { fnProdInsDiv();  }); /* fnInitSalePriceDialog('add'); */
        $("#btnDispModify").click(    function() { fnInitSalePriceDialog('mod' );});
        $("#btnDispTrash") .click(    function() { fnInitSalePriceDialog('del' ); });
        
        // 엑셀 다운로드 
        $("#btnCategoryExcel").click(   function() { fnCategoryExcell();    });
        $("#btnVendorExcel")  .click(   function() { fnVendorExcell();  });
        $("#btnDispExcel")  .click(     function() { fnDispExcell();    });
        
        //이미지 정보 
        $("#btnAttachDel").click( function() { attachDel(); });
        
        // 금액필드 Mask 설정 
        //$("#stan_buying_rate").mask("99.99");
        Editor.getCanvas().setCanvasSize({height:250}); //daum editor height 지정
        
        // 상품설명 Edit 설정 
        Editor.getCanvas().observeJob(Trex.Ev.__CANVAS_PANEL_KEYUP, function(e) {
            fnSetProductDescContents(Editor.getContent());
        });
        
        
        fnSetRequestParmas();
        fnInitCodeDataSet();
        fnInitDispCategoryGrid();                   // 카테고리 정보 조회
        fnLoadProductMasterDataSet();               // 마스터 정보 조회
        fnLoadProductVendorDataSet();               // 공급사 정보 
        fnLoadDisplayDataSet();
        goodRegYear();                  //상품실적년도
        selectProductManager();         //상품담당자
        
    });
</script>

<script type="text/javascript">
var fnInitCodeDataSet = function () {
     // 상품과세구분 
   $("#vtax_clas_code").html("");
   $("#vtax_clas_code").append("<option value=''>선택</option>");
<%  for(int i=0; i<vTaxTypeCode.size() ;i++) { %>
       $("#vtax_clas_code").append("<option value="+<%=vTaxTypeCode.get(i).getCodeVal1()%>+">"+"<%=vTaxTypeCode.get(i).getCodeNm1()%>"+"</option>");
<%  }%>          
   
//    // 주문단위 
   $("#orde_clas_code").html("");
   $("#orde_clas_code").append("<option value=''>선택</option>");
<%  for(int i=0; i<orderUnit.size() ;i++) { 
%>
            $("#orde_clas_code").append("<option value='"+"<%=orderUnit.get(i).getCodeVal1()%>"+"'>"+"<%=orderUnit.get(i).getCodeNm1()%>"+"</option>");
<%  }%>


//    // 상품구분 
   $("#good_clas_code").html("");
<%  for(int i=0; i<orderGoodsType.size() ;i++) {
        if(!"30".equals(orderGoodsType.get(i).getCodeVal1())){ %>
            $("#good_clas_code").append("<option value='"+<%=orderGoodsType.get(i).getCodeVal1()%>+"'>"+"<%=orderGoodsType.get(i).getCodeNm1()%>"+"</option>");
<%      }
    }%>
   
//    // 소재지 deliAreaCodeList  
   $("#areatype").append("<option value=''>선택</option>");
<%  for(int i=0; i<deliAreaCodeList.size() ;i++) { %>
       $("#areatype").append("<option value='"+<%=deliAreaCodeList.get(i).getCodeVal1()%>+"'>"+"<%=deliAreaCodeList.get(i).getCodeNm1()%>"+"</option>");
<%  }%>
   
//    // 물량배분여부   isdistributeSts
   $("#isdistribute").html("");
   $("#isdistribute").append("<option value=''>선택</option>");
<%  for(int i=0; i<isdistributeSts.size() ;i++) { %>
       $("#isdistribute").append("<option value='"+<%=isdistributeSts.get(i).getCodeVal1()%>+"'>"+"<%=isdistributeSts.get(i).getCodeNm1()%>"+"</option>");
<%  }%>
   
       
       
    };
</script>

<script type="text/javascript">

    /**
     * Object 객체 안에 파라미터를 설정한다. 
     * 파라미터 설정후 순차적 처리를 위해 notify Method 를 호출한다.  
     */    
    var fnSetRequestParmas = function(){
        reqParamObj['good_iden_numb']   = '<%=good_iden_numb%>';
        reqParamObj['cate_id']          = '<%=cate_id%>';
        reqParamObj['vendorid']         = '<%=vendorid%>';
        reqParamObj['bidid']            = '<%=bidid%>';
        reqParamObj['bid_vendorid']     = '<%=bid_vendorid%>';
        reqParamObj['req_good_id']      = '<%=req_good_id%>';
        
          
//         defObj.notify('setPramsDone');
    };
    
    /**
     * Code Data를 처리한다. 
     */    
    var fnLoadCodeDataSet = function () {
        $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/product/initDetailCodeInfo.sys',
            {},
            function(arg){
                if(fnTransResult(arg, false)){
                    // 상품과세구분 
                    var vTaxTypeCode = eval('(' + arg + ')').vTaxTypeCode;
                    $("#vtax_clas_code").html("");
                    $("#vtax_clas_code").append("<option value=''>선택</option>");
                    for(var i=0;i<vTaxTypeCode.length;i++) {
                        $("#vtax_clas_code").append("<option value='"+vTaxTypeCode[i].codeVal1+"'>"+vTaxTypeCode[i].codeNm1+"</option>");
                    }            
                    
                    // 주문단위 
                    var orderUnit = eval('(' + arg + ')').orderUnit;
                    $("#orde_clas_code").html("");
                    $("#orde_clas_code").append("<option value=''>선택</option>");
                    for(var i=0;i<orderUnit.length;i++) {
                        $("#orde_clas_code").append("<option value='"+orderUnit[i].codeVal1+"'>"+orderUnit[i].codeNm1+"</option>");
                    }
                 
                    // 상품구분 
                    var orderGoodsType = eval('(' + arg + ')').orderGoodsType;
                    $("#good_clas_code").html("");
                    for(var i=0;i<orderGoodsType.length;i++) {
                        $("#good_clas_code").append("<option value='"+orderGoodsType[i].codeVal1+"'>"+orderGoodsType[i].codeNm1+"</option>");
                    }
                    
                    // 소재지 
                    var deliAreaCodeList = eval('(' + arg + ')').deliAreaCodeList;
                    $("#areatype").html("");
                    $("#areatype").append("<option value=''>선택</option>");
                    for(var i=0;i<deliAreaCodeList.length;i++) {
                        $("#areatype").append("<option value='"+deliAreaCodeList[i].codeVal1+"'>"+deliAreaCodeList[i].codeNm1+"</option>");
                    }
                    
                    // 물량배분여부  
                    var isdistributeSts = eval('(' + arg + ')').isdistributeSts;
                    
                    $("#isdistribute").html("");
                    $("#isdistribute").append("<option value=''>선택</option>");
                    for(var i=0;i<isdistributeSts.length;i++) {
                        $("#isdistribute").append("<option value='"+isdistributeSts[i].codeVal1+"'>"+isdistributeSts[i].codeNm1+"</option>");
                    }
                    
//                     defObj.notify('codeDataDone');
                }
            }
        );
    };
    
    /**
    *   마스터 정보를 조회한다. 
    */
    var fnLoadProductMasterDataSet = function(){
    
        var params = {good_iden_numb:reqParamObj['good_iden_numb']};
    
        jq("#productMaster").jqGrid({
            url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/getMasterProductListJQGrid.sys',
<%--             url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys', --%>
            datatype:'json',
            mtype:'POST',
            colNames:[
                      /*  디비  데이터 */
                      'isModify','good_iden_numb','cate_id','good_name','vtax_clas_code',
                      'sale_criterion_type','stan_buying_rate','stan_buying_money','isdistribute','isdisppastgood',
                      'insert_user_id','insert_date','full_cate_name','product_maanger'
            ],
            colModel:[
                      {name:'isModify',index:'isModify',width:100 },
                      {name:'good_iden_numb',index:'good_iden_numb',width:100,key:true},          
                      {name:'cate_id',index:'cate_id',width:100},                         
                      {name:'good_name',index:'good_name',width:100},                     
                      {name:'vtax_clas_code',index:'vtax_clas_code',width:100},           
                      {name:'sale_criterion_type',index:'sale_criterion_type',width:100}, 
                      {name:'stan_buying_rate',index:'stan_buying_rate',width:100},       
                      {name:'stan_buying_money',index:'stan_buying_money',width:100},     
                      {name:'isdistribute',index:'isdistribute',width:100},               
                      {name:'isdisppastgood',index:'isdisppastgood',width:100},           
                      {name:'insert_user_id',index:'insert_user_id',width:100},           
                      {name:'insert_date',index:'insert_date',width:100},
                      {name:'full_cate_name',index:'Full_cate_name',width:100},
                      {name:'product_manager',index:'product_manager',width:100}
            ],
            postData: params,
            rownumbers:false,
            height:150,
            width:1000,
            sortname:'borgNms',sortorder:'asc',
            caption:"상품진열정보", 
            viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
            loadComplete:function() {
                
                var selRowId;
                if(jq("#productMaster").getGridParam('reccount') > 0){
                    var selRowId = $("#productMaster").getDataIDs()[0];
//                  selRowId = jq("#productMaster").jqGrid('getRowData',rowid);
                }else{
                    var addRowDataSet = {
                            good_iden_numb:'0'
                           ,cate_id:'0'
                           ,vtax_clas_code:'10'
                           ,sale_criterion_type:'10'
                           ,stan_buying_rate:'0'
                           ,stan_buying_money:'0'
                           ,isdistribute:'0'
                           ,isdisppastgood:'0'
                           ,product_manager:''};
                    selRowId = '0';
                    $("#productMaster").addRowData(selRowId, addRowDataSet);   
                }
                
                // 수정여부 컬럼에 데이터 설정 
                FNAlterGridDataProValue('productMaster' , selRowId , 'isModify' , '0');
//                 FNCopyOrgRowData('productMaster', selRowId , 'org');  
                $("#productMaster").setSelection(selRowId);
                
                // girdDataSet 명을 기준으로 해당 컨퍼넌트를 찾아 바인드 처리한다.
                FNSetComponentValByGridDataObject( jQuery("#productMaster").jqGrid('getRowData',selRowId) );
                
                // 컨퍼넌트 설정
                fnSetProdMasterComponentAble();
                
                // 카테고리 정보를 조회한다. 위치변경 
                //fnInitDispCategoryGrid(); 
                
                var selrow = $('#productMaster').getGridParam("selrow");
            },
            onSelectRow:function(rowid,iRow,iCol,e) {},
            ondblClickRow:function(rowid,iRow,iCol,e) {},
            onCellSelect:function(rowid,iCol,cellcontent,target) {},
            loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
            jsonReader: { root:"list",total:"total",records:"records",repeatitems:false,cell:"cell"}
        
        });
    };
    
    
    /**
    *   카테고리 정보를 조회한다. 
    */
    var fnInitDispCategoryGrid = function(){
    
        var rowid = $('#productMaster').getGridParam("selrow");
        var params = {cate_id:FNgetGridDataObj('productMaster',rowid,'cate_id')};
        jq("#dispCategory").jqGrid({
            url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/categoryInfoListByCateIdJQGrid.sys',
<%--             url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys', --%>
            datatype:'json',
            mtype:'POST',
            colNames:['진열카테고리명','진열조직','사용여부','진열설명'],
            colModel:[
                {name:'cate_Disp_Name',index:'cate_Disp_Name',width:150,align:'left',sortable:false},      //진열명
                {name:'borgNms',index:'borgNms',width:390,align:"left",sortable:false},      //진열조직
                {name:'is_Disp_Use',index:'is_Disp_Use',width:60,align:"center",sortable:false},       //사용여부 
                {name:'cate_Disp_Desc',index:'cate_Disp_Desc',width:400,align:'left',sortable:false}       //사용여부
            ],
            postData: reqParamObj,
            qridview:true,
            rowNum:0,rownumbers:false,
            height:150,
<%  if(("".equals(good_iden_numb)) || ("0".equals(good_iden_numb))) {%>
            width:<%=width%>,   
<%  }else{%>
            width:1000,
<%  }%>
            sortname:'borgNms',sortorder:'asc',
            caption:"상품진열정보", 
            viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
            loadComplete:function() {},
            onSelectRow:function(rowid,iRow,iCol,e) {},
            ondblClickRow:function(rowid,iRow,iCol,e) {},
            onCellSelect:function(rowid,iCol,cellcontent,target) {},
            loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
            jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
        });
    };
    
    
    var fnLoadProductVendorDataSet = function(){
        var t1 = +new Date;

        var rowid = $('#productMaster').getGridParam("selrow");
        var params = {good_iden_numb: reqParamObj['good_iden_numb']};
        
        jq("#prodVendor").jqGrid({
            url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/getGoodVendorListByGoodIdenNumJQGrid.sys',
            datatype:'json',
            mtype:'POST',
            colNames:[
                    /* 수정여부 */
                    '수정여무',
                    /* 디비 */
                    '상품코드', '공급사ID', '공급사코드', '공급사명', '대표자명'
                    ,'대표연락처'
                    , '소재지',  '상품등록요청SEQ', '매입단가','물량배분 %', 
                    '규격', '표준규격', '규격1','규격2','규격3',
                    '규격4','규격5','규격6','규격7','규격8',
                    '표준규격1','표준규격2','표준규격3','표준규격4','표준규격5',
                    '표준규격6', '단위', '납품소요일수', '최소구매수량', '제조사', 
                    '이미지', '대표이미지원본', '대표이미지대', '대표이미지중', '대표이미지소', 
                    '동의어', '동의어1','동의어2','동의어3','동의어4',
                    '동의어5', '상품설명등록여부', '상품설명', '하도급법대상여부', '상품구분', 
                    '재고수량', '등록일','bidid','bid_vendorid', '고객사상품등록요청SEQ', 
                    '승인여부(종료,매입가변경)' ,'요청여부(종료,매입가변경)', '정상여부',
                    
                    /* 복사본 원본 데이터 */
                    '원본매입단가',
                    '상품실적년도',
                    '상품우선순위'
            ],
            colModel:[
                  /*수정모드*/      
                 {name:'isModify',index:'',hidden:true},     /*수정여부 [0 : 무수정, 1 : 수정] Default Val = 0 */
                  /*디비  데이터*/
                 {name:'good_iden_numb',index:'good_iden_numb',hidden:true,sortable:false},           /*상품코드*/     /* true */
                 {name:'vendorid',index:'vendorid',hidden:true , key:true ,sortable:false},           /*공급사ID*/    /* true */
                 {name:'vendorcd',index:'vendorcd',hidden:true,sortable:false},                       /*공급사코드*/   /* true */
                 {name:'vendornm',index:'vendornm',hidden:false,sortable:false},                      /*공급사명O*/
                 {name:'pressentnm',index:'pressentnm',width:90,hidden:false,sortable:false},         /*대표자명O*/
                 
                 {name:'phonenum',index:'phonenum',width:90,hidden:false,sortable:false},             /*대표연락처O*/
                 {name:'areatype',index:'areatype',width:60,hidden:false,sortable:false},             /*소재지O*/
                 {name:'req_good_id',index:'req_good_id',hidden:true,sortable:false},                 /*상품등록요청SEQ*/
                 {name:'sale_unit_pric',index:'sale_unit_pric',width:80,hidden:false,align:"right",formatter: 'integer' ,sortable:false
                     ,formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }                
                 },                                                                    /*매입단가O*/
                 {name:'distri_rate',index:'distri_rate',align:"right",width:70,hidden:false,sortable:false},/*  배분율     */
                 
                 {name:'good_spec_desc',index:'good_spec_desc',hidden:true,sortable:false},           /*규격*/
                 {name:'good_st_spec_desc',index:'good_st_spec_desc',hidden:true,sortable:false},     /*표준규격*/
                 {name:'good_spec_desc1',index:'good_spec_desc1',hidden:true,sortable:false},         /*규격1*/
                 {name:'good_spec_desc2',index:'good_spec_desc2',hidden:true,sortable:false},         /*규격2*/
                 {name:'good_spec_desc3',index:'good_spec_desc3',hidden:true,sortable:false},         /*규격3*/
                 
                 {name:'good_spec_desc4',index:'good_spec_desc4',hidden:true,sortable:false},         /*규격4*/
                 {name:'good_spec_desc5',index:'good_spec_desc5',hidden:true,sortable:false},         /*규격5*/
                 {name:'good_spec_desc6',index:'good_spec_desc6',hidden:true,sortable:false},         /*규격6*/
                 {name:'good_spec_desc7',index:'good_spec_desc7',hidden:true,sortable:false},         /*규격7*/
                 {name:'good_spec_desc8',index:'good_spec_desc8',hidden:true,sortable:false},         /*규격8*/
                 
                 {name:'good_st_spec_desc1',index:'good_st_spec_desc1',hidden:true,sortable:false},         /*표준규격1*/
                 {name:'good_st_spec_desc2',index:'good_st_spec_desc2',hidden:true,sortable:false},         /*표준규격2*/
                 {name:'good_st_spec_desc3',index:'good_st_spec_desc3',hidden:true,sortable:false},         /*표준규격3*/
                 {name:'good_st_spec_desc4',index:'good_st_spec_desc4',hidden:true,sortable:false},         /*표준규격4*/
                 {name:'good_st_spec_desc5',index:'good_st_spec_desc5',hidden:true,sortable:false},         /*표준규격5*/
                 
                 {name:'good_st_spec_desc6',index:'good_st_spec_desc6',hidden:true,sortable:false},         /*표준규격6*/
                 {name:'orde_clas_code',index:'orde_clas_code',hidden:true,sortable:false},           /*단위*/
                 {name:'deli_mini_day',index:'deli_mini_day',width:80,hidden:false,align:"right",formatter: 'integer',sortable:false
                     ,formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }                
                 },     /*납품소요일수*/
                 {name:'deli_mini_quan',index:'deli_mini_quan',width:74,hidden:false,align:"right",formatter: 'integer',sortable:false
                     ,formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }                
                 }, /*최소구매수량*/
                 {name:'make_comp_name',index:'make_comp_name',hidden:true,sortable:false},        /*제조사*/
                 
                 {name:'isexistimg',index:'isexistimg',width:45,hidden:false,sortable:false},      /*이미지등록여부O*/
                 {name:'original_img_path',index:'original_img_path',hidden:true,sortable:false},  /*대표이미지원본 */ 
                 {name:'large_img_path',index:'large_img_path',hidden:true,sortable:false},        /*대표이미지대*/
                 {name:'middle_img_path',index:'middle_img_path',hidden:true,sortable:false},      /*대표이미지중*/
                 {name:'small_img_path',index:'small_img_path',hidden:true,sortable:false},        /*대표이미지소*/
                 
                 {name:'good_same_word',index:'good_same_word',hidden:true,sortable:false},        /*동의어*/
                 {name:'good_same_word1',index:'good_same_word1',hidden:true,sortable:false},      /*동의어*/
                 {name:'good_same_word2',index:'good_same_word2',hidden:true,sortable:false},      /*동의어*/
                 {name:'good_same_word3',index:'good_same_word3',hidden:true,sortable:false},      /*동의어*/
                 {name:'good_same_word4',index:'good_same_word4',hidden:true,sortable:false},      /*동의어*/
                 
                 {name:'good_same_word5',index:'good_same_word5',hidden:true,sortable:false},      /*동의어*/
                 {name:'isexistgooddesc',index:'isexistgooddesc',width:100,hidden:false,sortable:false},        /*상품설명등록여부O*/
                 {name:'good_desc',index:'good_desc',hidden:true,sortable:false},                              /*상품설명*/
                 {name:'issub_ontract',index:'issub_ontract',hidden:true,sortable:false},                      /*하도급법대상여부*/
                 {name:'good_clas_code',index:'good_clas_code',hidden:false,sortable:false},                    /*상품구분*/
                 
                 {name:'good_inventory_cnt',index:'good_inventory_cnt',hidden:true,sortable:false},            /*재고수량*/
                 {name:'regist_date',index:'regist_date',align:"center",width:75,hidden:false,sortable:false}, /*등록일O*/
                 {name:'bidid',index:'bidid',align:"center",width:95,hidden:true,sortable:false},           
                 {name:'bid_vendorid',index:'bid_vendorid',align:"center",width:95,hidden:true,sortable:false},
                 {name:'req_good_id',index:'req_good_id',align:"center",width:95,hidden:true,sortable:false},  /*  고객사상품등록요청 */ 
                 
                 {name:'prodvendorappflag',index:'prodvendorappflag',align:"center",width:95,hidden:true,sortable:false},  /*  승인여부(종료,매입가변경)    */
                 {name:'chageproductrequest',index:'chageproductrequest',align:"center",width:95,hidden:true,sortable:false},  /*  요청여부(종료,매입가변경)    */
                 {name:'isUse',index:'isUse',align:"center",width:70,sortable:false},                                      /*  정상여부    */      
                 

                 {name:'orgsale_unit_pric',index:'orsale_unit_pric',hidden:true,sortable:false},  /*매입단가O*/
                 {name:'good_reg_year',index:'good_reg_year',hidden:true,sortable:false},  /*상품실적년도*/
                 {name:'vendor_priority',index:'vendor_priority',hidden:false,sortable:false}  /*상품우선순위*/

            ],
            gridview:true,
            postData:params,
            rowNum:0,rownumbers:false,
            height:150,
<%  if(("".equals(good_iden_numb)) || ("0".equals(good_iden_numb))) {%>
            width:<%=width%>,   
<%  }else{%>
            width:1000,
<%  }%>        
            sortname:'',sortorder:'',
            caption:"상품 공급업체 정보",
            viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
            loadComplete:function() {
                if($.trim(reqParamObj['vendorid']).length > 0 ) 
                    jQuery("#prodVendor").setSelection(reqParamObj['vendorid']);
                
                    fnLoadBidVendorInfo();
                    fnLoadNewProductInfo();
                    fnSetProdVendorComponent();
                    var t2 = +new Date;
                    //alert((t2 - t1) + ' milliseconds');
            },
            onSelectRow:function(rowid,iRow,iCol,e) {
                // Grid 데이터를 기준으로 component를 초기화 한다.
                fnSetProdVendorComponent();
            },
            ondblClickRow:function(rowid,iRow,iCol,e) {},
            onCellSelect:function(rowid,iCol,cellcontent,target) {
                
                // 에디터 데이터 보호를 위해 이벤트 발생
                fnSetProductDescContents(Editor.getContent());
            },
            loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
            jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell"}
        });
    };
</script>

<script type="text/javascript">
    /**
     *  keyVal에 해당한 데이터 존재 여부를 확인한다. 
     *  존재시 True 미존재시 False           
     */
    var fnIsExistVendorInfo = function(gridId,keyVal) {
        var rtn = false; 
        var rowCnt = jq("#"+gridId).getGridParam('reccount') ;
        for(var ii=0; ii<rowCnt; ii++) {
            var rowid   = $("#prodVendor").getDataIDs()[ii];
            var rowData = jq("#prodVendor").jqGrid('getRowData',rowid);
            if(rowData['vendorid'] == keyVal)    rtn = true;
        }
        
        return rtn; 
    };
    
    /**
     *  투찰 공급사 상품을 조회한다. 
     */
    var fnLoadBidVendorInfo = function(){

        
        
        var isAbleReqBid = true; 
        // 파라미터가 유효한지
        if($.trim(reqParamObj['bidid']).length == 0 || $.trim(reqParamObj['bid_vendorid']).length == 0){
            var msg = 'bidid length['+$.trim(reqParamObj['bidid']).length+']   bid_vendorid ['+$.trim(reqParamObj['bid_vendorid']).length+']';
             
            isAbleReqBid = false; 
        }
        
        // 공급사 존재여부
        if(fnIsExistVendorInfo('prodVendor',reqParamObj['bid_vendorid'])){
            isAbleReqBid = false;
        }
        
        if(!isAbleReqBid){
//             vendorDef.notify('loadBidDataDone');
            
            var msg = ''; 
            msg += 'bidid]['+reqParamObj['bidid'];
            msg += 'bid_vendorid]['+reqParamObj['bid_vendorid'];
            
            return;
        }
        
        var params = {good_iden_numb:reqParamObj['good_iden_numb'], bidid:reqParamObj['bidid'] , bid_vendorid:reqParamObj['bid_vendorid']};
        
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/getVendorAutionInfoForInsProduct.sys"
            , params
            , function(arg) {
                if(fnTransResult(arg, false)){
                    
                    var addProdVendorInfo = eval('(' + arg + ')').addProdVendorInfo[0];
                    $("#prodVendor").addRowData(addProdVendorInfo['vendorid'],addProdVendorInfo);
                    $("#prodVendor").setSelection(addProdVendorInfo['vendorid']);
                    $('#prodVendor').jqGrid('setRowData',addProdVendorInfo['vendorid'],{isModify:1});
                    
//                     vendorDef.notify('loadBidDataDone');
                    
                    //alert("addProdVendorInfo['good_name'] : "+addProdVendorInfo['good_name']);
                    if($("#good_name").val() == "") {
                        $("#good_name").val(addProdVendorInfo['good_name']);
                        var setRowId = '0';
                        var setRowDataSet = { good_name:addProdVendorInfo['good_name'] };
                        $("#productMaster").jqGrid('setRowData', setRowId, setRowDataSet);
                    }
                }
         });
    };
    
    /**
    *   공급사 신규 상품 요청 데이터를 로드한다. 
    */
    var fnLoadNewProductInfo = function(){
        
        if($.trim(reqParamObj['req_good_id']) == ''){
//             vendorDef.notify('loadNewProductDataDone');
        }else {
            var params = {req_good_id:reqParamObj['req_good_id']};
            $.post(
                '<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/getReqProductDetailInfoJQGrid.sys'
                , params
                , function(arg) {
                    
                    var addRowData = eval('(' + arg + ')').list[0];
                    
                    // 해당 상품에 대한 공급사 중복여부
//                     var isBe = false;
//                     var rowCnt = jq("#prodVendor").getGridParam('reccount');
//                     if(rowCnt > 0) {
//                      for(var i=0 ; i<rowCnt ; i++) {
//                          var venRowid = $("#prodVendor").getDataIDs()[i];
//                          var venRowData = jq("#prodVendor").jqGrid('getRowData',venRowid);
                            
//                          alert("venRowData['vendorid'] : "+venRowData['vendorid']+", addRowData['vendorid'] : "+addRowData['vendorid']);
//                          if($.trim(venRowData['vendorid']) == addRowData['vendorid'] ) {
//                              isBe = true;
//                              continue;
//                          }
//                      }
//                     }
                    
//                     if(isBe) {
//                      alert("기상품에 이미 해당 공급사가 등록되어 있습니다.확인하시기 바랍니다.");
//                      fnThisPageClose();
//                     }
                    
                    if($("#good_name").val() == "") {
                        $("#good_name").val(addRowData['good_name']);
                        var setRowId = '0';
                        var setRowDataSet = { good_name:addRowData['good_name'] };
                        $("#productMaster").jqGrid('setRowData', setRowId, setRowDataSet); 
                    }
                    $("#prodVendor").addRowData(addRowData['vendorid'],addRowData);
                    $("#prodVendor").setSelection(addRowData['vendorid']);
                    $('#prodVendor').jqGrid('setRowData',addRowData['vendorid'],{isModify:1});
                }
            );    
        }
    };
    
    
    /**
    *   상품 진열 정보를 로드한다. 
    */
    var fnLoadDisplayDataSet = function(){
        
        var rowid = $('#productMaster').getGridParam("selrow");
        var params = {good_iden_numb: reqParamObj['good_iden_numb']};
        
        jq("#prodDisplay").jqGrid({
            url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/getDisplayGoodListJQGrid.sys',
            datatype:'json',
            mtype:'POST',
            colNames:[
                   'disp_good_id'         /*진열SEQ*/
                   ,'areacode'            /*areacode*/
                   ,'소재지'                 /*areavalue*/
                   ,'groupid'             /*그룹id */
                   ,'groupnm'             /*그룹명 */
                   ,'clientid'            /*법인id*/
                   ,'clientnm'            /*법인명 */
                   ,'branchid'            /*사업장id*/ 
                   ,'branchnm'            /*사업장명 */
                   ,'진열고객사명'            /*고객사 조직명 */
                   ,'진열고객사 상품코드'        /*고객사 상품코드*/
                   ,'vendorid'            /*공급사 ID*/
                   ,'판매가'                /*판매가 */
                   ,'매입가'                 /*매입가*/
                   ,'공급사명'               /*공급사명 */
                   ,'계약시작일'              /*계약시작일*/
                   ,'계약종료일'              /*계약종료일*/
                   ,'ispast_sell_flag'    /*과거상품판매여부*/
                   ,'과거 진열 조회' /*과거 이력조회*/
            ],
            colModel:[
                   {name:'disp_good_id'        ,index:'disp_good_id'       ,width:150,align:"left",hidden:true,key:true}    /*진열SEQ*/        
                   ,{name:'areatype'           ,index:'areatype'           ,width:330,align:"left",hidden:true}             /*소재지코드 */
                   ,{name:'areanm'             ,index:'areanm'             ,width:70,align:"left",hidden:false}             /*소재지명*/
                   ,{name:'groupid'            ,index:'groupid'            ,width:330,align:"left",hidden:true}             /*그룹id */        
                   ,{name:'groupnm'            ,index:'groupnm'            ,width:330,align:"left",hidden:true}             /*그룹명 */        
                   ,{name:'clientid'           ,index:'clientid'           ,width:330,align:"left",hidden:true}             /*법인id*/         
                   ,{name:'clientnm'           ,index:'clientnm'           ,width:330,align:"left",hidden:true}             /*법인명 */        
                   ,{name:'branchid'           ,index:'branchid'           ,width:330,align:"left",hidden:true}             /*사업장id*/       
                   ,{name:'branchnm'           ,index:'branchnm'           ,width:330,align:"left",hidden:true}             /*사업장명 */      
                   ,{name:'fullborgnms'        ,index:'fullborgnms'        ,width:300,align:"left"}                         /*고객사 조직명 */
                   ,{name:'cust_good_iden_numb',index:'cust_good_iden_numb',width:130,align:"left"}                         /*고객사 상품코드*/
                   ,{name:'vendorid'           ,index:'vendorid'           ,width:100,align:"left",hidden:true}             /*공급사 ID*/
                   ,{name:'sell_price'         ,index:'sell_price'         ,width:45,align:"right",formatter: 'integer'
                       ,formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }              
                    }                                                                                                       /*판매가 */
                   ,{name:'sale_unit_pric'     ,index:'sale_unit_pric'     ,width:45,align:"right",formatter: 'integer'
                       ,formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }              
                    }                                                                                                       /*매입가 */
                   ,{name:'vendornm'           ,index:'vendornm'           ,width:150,align:"left"}                         /*공급사명 */      
                   ,{name:'cont_from_date'     ,index:'cont_from_date'     ,width:80,align:"center"}                        /*계약시작일*/     
                   ,{name:'cont_to_date'       ,index:'cont_to_date'       ,width:80,align:"center"}                        /*계약종료일*/     
                   ,{name:'ispast_sell_flag'   ,index:'ispast_sell_flag'   ,width:330,align:"left",hidden:true}             /*과거상품판매여부*/
                   ,{name:'btn'                ,index:'btn'                ,width:80 ,align:"left",hidden:false}            /*과거 이력조회*/
            ],
            gridview:true,
            postData: params,
            rowNum:0,rownumbers:false,
            height:200,
<%  if(("".equals(good_iden_numb)) || ("0".equals(good_iden_numb))) {%>
            width:<%=width%>,   
<%  }else{%>
            width:1000,
<%  }%>            
            sortname:'disp_Good_Id',sortorder:'desc',
            caption:"현 판가정보", 
            viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
            loadComplete:function() {
                // 히스토리 버튼을 로드한다. 
                var rowCnt = jq("#prodDisplay").getGridParam('reccount');
                if(rowCnt>0) {
                    for(var i=0; i<rowCnt; i++) {
                        var rowid = $("#prodDisplay").getDataIDs()[i];
                        var rowData = jq("#prodDisplay").jqGrid('getRowData',rowid);
                        var inputBtn = "<input style='height:22px;width:80px;' type='button' value='이력조회' onclick=\"fnShowDispProductInfoPastInfo('"+rowid+"');\" />";
                        FNAlterGridDataProValue('prodDisplay' , rowid , 'btn' , inputBtn);
                    }
                } 
                
//                 defObj.notify('loadDisplayDataDone');
            },
            onSelectRow:function(rowid,iRow,iCol,e) {},
            ondblClickRow:function(rowid,iRow,iCol,e) {},
            onCellSelect:function(rowid,iCol,cellcontent,target) { 
                //fnSetProdVendorComponent();
            },
            loadError:function(xhr,st,str) { $("#list3").html(xhr.responseText); },
            jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell"}
        });        
    };
</script>

<script type="text/javascript">

    // 상품 마스터 컨퍼넌트 설정을 한다. 
    var fnSetProdMasterComponentAble = function() {
        var selrow = $('#productMaster').getGridParam("selrow");
        var rowData = jQuery("#productMaster").jqGrid('getRowData',selrow);
        
        if($.trim(rowData['good_iden_numb'])=='0'){
            // 등록일때
            $('#btnSearchCategory').show();
            $('#btnCommonClose').hide();
        }else {
            // 수정일때 
            $('#btnSearchCategory').hide();
            $('#btnCommonClose').show();
        }
        $('input:radio[name=sale_criterion_type]:input[value='+rowData['sale_criterion_type']+']').attr("checked", true);
        
        fnChangeCriterion();
    };
    
    // 판매가산출옵션 변경에 따른 처리Evnet
    var fnChangeCriterion = function() {
        
        var rowId       = $("#productMaster").getGridParam("selrow");
        var val = $(":input:radio[name=sale_criterion_type]:checked").val();
        FNAlterGridDataProValue('productMaster' , rowId , 'sale_criterion_type' , val); 
        
        if(val=='10') {   //기준매익률
            $('#stan_buying_rate').attr("disabled",false);
            $('#stan_buying_money').attr("disabled",true);
            $('#stan_buying_money').val('0');
            $('#stan_buying_rate').focus();
        }else if(val=='20') {  //절대매입가
            $('#stan_buying_rate').attr("disabled",true);
            $('#stan_buying_money').attr("disabled",false);
            $('#stan_buying_rate').val('0');
            $('#stan_buying_money').focus();
        }
    };
    
    
    //  girdDataSet 명을 기준으로 해당 컨퍼넌트를 찾아 바인드 처리한다.  
    var fnSetProdVendorComponent = function() {
        
        var selrow = $('#prodVendor').getGridParam("selrow");
        
        // 선택된 공급사 존재시 
        if(selrow != null){
            
            var rowData = jQuery("#prodVendor").jqGrid('getRowData',selrow);
            var getYear = '<%=getYear%>';
            // Component Value Setting      
            FNSetComponentValByGridDataObject( rowData );
            
            if($('#good_reg_year').val() == ""){
                $('#good_reg_year').val(getYear);
            }
            // 상세설명 
            if($.trim(rowData['good_desc']) > ' '){
                
                var gooddesc = unescape(rowData['good_desc']);
                
                $('#tx_load_content').val(gooddesc); 
            }
            
            loadContent();
            
            // img 설정
            if(rowData['isexistimg'] == 'Y'){
                var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + rowData['small_img_path'];
                var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + rowData['middle_img_path'];
                var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/"  + rowData['large_img_path'];
                
                var msg = '';
                msg += '\n imgPathForSMALL  value ['+imgPathForSMALL +']'; 
                msg += '\n imgPathForMEDIUM value ['+imgPathForMEDIUM+']'; 
                msg += '\n imgPathForLARGE  value ['+imgPathForLARGE +']'; 
                
                $('#SMALL').attr('src',imgPathForSMALL);
                $('#MEDIUM').attr('src',imgPathForMEDIUM);
                $('#LARGE').attr('src',imgPathForLARGE);
            }
            
            // 규격 설정
            if($.trim(rowData['good_spec_desc']) > ' '){
                $('#good_spec_desc1').val(rowData['good_spec_desc'].split("‡")[0]); 
                $('#good_spec_desc2').val(rowData['good_spec_desc'].split("‡")[1]);
                $('#good_spec_desc3').val(rowData['good_spec_desc'].split("‡")[2]);
                $('#good_spec_desc4').val(rowData['good_spec_desc'].split("‡")[3]);
                $('#good_spec_desc5').val(rowData['good_spec_desc'].split("‡")[4]);
                $('#good_spec_desc6').val(rowData['good_spec_desc'].split("‡")[5]);
                $('#good_spec_desc7').val(rowData['good_spec_desc'].split("‡")[6]);    
                $('#good_spec_desc8').val(rowData['good_spec_desc'].split("‡")[7]);
            }
            
            // 규격 설정
            if($.trim(rowData['good_st_spec_desc']) > ' '){
                
                $('#good_st_spec_desc1').val(rowData['good_st_spec_desc'].split("‡")[0]); 
                $('#good_st_spec_desc2').val(rowData['good_st_spec_desc'].split("‡")[1]);
                $('#good_st_spec_desc3').val(rowData['good_st_spec_desc'].split("‡")[2]);
                $('#good_st_spec_desc4').val(rowData['good_st_spec_desc'].split("‡")[3]);
                $('#good_st_spec_desc5').val(rowData['good_st_spec_desc'].split("‡")[4]);
                $('#good_st_spec_desc6').val(rowData['good_st_spec_desc'].split("‡")[5]);
            }
         
            
            // 동의어 설정
            if($.trim(rowData['good_same_word']) > ' ' ){
                $('#good_same_word1').val(rowData['good_same_word'].split("‡")[0]);
                $('#good_same_word2').val(rowData['good_same_word'].split("‡")[1]);
                $('#good_same_word3').val(rowData['good_same_word'].split("‡")[2]);
                $('#good_same_word4').val(rowData['good_same_word'].split("‡")[3]);
                $('#good_same_word5').val(rowData['good_same_word'].split("‡")[4]);    
            }
        
            // Default Value setting 
            if($.trim(rowData['issub_ontract']) == '') {
                $('#issub_ontract').val('0');
                $('#issub_ontract').change(); 
            }
            
            if($.trim(rowData['good_clas_code']) == '') {
                $('#good_clas_code').val('10');
                $('#good_clas_code').change(); 
            }
            
            // Default Setting
            if(<%=Constances.PROD_APPROVAL_FLAG %>== true)  $('#btnSoldOut').attr('src',"<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_end.gif");    
            
            
            $('#btnChnUseSts').hide();
            
            // 공급사 id 존재 여부에 따른 버튼 설정  
            if( rowData['regist_date'] != '' ){
                
                
                if($.trim(rowData['orgisUse']) == '0')  $('#btnChnUseSts').show();
                
                // 등록된 공급사인경우
                if($.trim(rowData['vendorid'])  != ''){
                    $('#btnVendor').hide();
                    $('#btnAlterPrice').show();
                    $('#btnSoldOut').show();
                    $('#sale_unit_pric').prop('disabled', true);
                   
                    $('#sale_unit_pric').blur();
                    $('#deli_mini_quan').blur();
                    $('#deli_mini_quan').blur();
                }else {
                    $('#btnVendor').show();
                    $('#btnAlterPrice').hide();
                    $('#btnSoldOut').hide();
                    $('#sale_unit_pric').prop('disabled', false);
                    
                }
            }else {
                // 등록되지 않은 공급사인 경우 
                $('#btnVendor').show();
                $('#btnAlterPrice').hide();
                $('#btnSoldOut').hide();
                $('#sale_unit_pric').prop('disabled', false);
            }
            
            
            // 정상여부에 따른 버튼 설정 
            if($.trim(rowData['orgisUse']) == '0') {
                $('#btnAlterPrice').hide();
                $('#btnSoldOut').hide();
            }
            
        }
    };
    
    // 값 변경에 따른 dataSet 수정  
    var fnSetChangeComponentData = function(obj,e,gridId,preWord){
        
        if(gridId == 'prodVendor'){
            var rowId       = $("#prodVendor").getGridParam("selrow");
            if(rowId == null){
                $('#dialogSelectRow').html('<p>선택된 공급사 정보가 없습니다. 공급사 선택후 이용하시기 바랍니다.</p>');
                $(obj).val('');
                $("#dialogSelectRow").dialog();
                return;
            } 
        }
        
         
        
        var rowId = $('#'+gridId).getGridParam("selrow");
        var colNm = $(obj).attr('id');
        var type = $(":input[name="+colNm+"]").attr('type');
        var orgVal = jq("#"+gridId).jqGrid('getRowData',rowId)[colNm];
        var modVal = '';
        
        var msg = '' ; 
        msg += '\n colNm value '+colNm  ; 
        msg += '\n type value '+type ;
       msg += '\n modVal value '+$(obj).val();
        
       //alert(msg);
       
        //if(type == 'text' || type == 'select-one' ){
            modVal = $(obj).val();
        //}
//      else if (colNm == 'stan_buying_rate') {
//          modVal = $("input[name='sale_criterion_type']:checked").val();
//          orgVal = jq("#"+gridId).jqGrid('getRowData',rowId)[colNm];
            
//          alert('modVal value ['+orgVal+']\n orgVal value ['+orgVal+']');
//      }
        
        if($.trim(orgVal) != $.trim(modVal)){
            var dataSet = new Object();
            dataSet[colNm] = modVal;
            dataSet["isModify"] = "1";
            $('#'+gridId).jqGrid('setRowData',rowId,dataSet);
        }       
    };
    
    
    // 판매가 산출 옵션 변경에 따른 컨퍼넌트 설정
    var fnSetEnableInventoryComponent = function(){
        var good_clas_code_val = $('#good_clas_code').val();
        if(good_clas_code_val == '10' ){            // 일반
            $('#good_inventory_cnt').attr("disabled",true);
        }else if(good_clas_code_val == '20'){       // 지정
            $('#good_inventory_cnt').attr("disabled",false);
        }else if(good_clas_code_val == '30'){       // 수탁
            $('#good_inventory_cnt').attr("disabled",false);
        }
    };
    
    
    // 공급사 정보 복사 
    var fnProdVendorCopy = function (){
        if( jq("#prodVendor").getGridParam('reccount') == 0 ){
            $('#dialogSelectRow').html('<p>공급사 정보가 존재하지 않습니다.</p>'); 
            $("#dialogSelectRow").dialog();
            return;
        }
        
        var rowId = $("#prodVendor").getGridParam("selrow");
        if(rowId == null){
            $('#dialogSelectRow').html('<p>선택된 공급사 정보가 존재하지 않습니다. </p>'); 
            jq( "#dialogSelectRow" ).dialog();
            return;
        }

        
        var copyColNms = new Array("sale_unit_pric","good_spec_desc","orde_clas_code","deli_mini_day","deli_mini_quan","make_comp_name","isexistimg","original_img_path","large_img_path","middle_img_path","small_img_path","good_same_word","isexistgooddesc","good_desc","issub_ontract","good_clas_code","good_reg_year","vendor_priority");
        var addDataSet = new Object(); 
        var orgDataSet = jq("#prodVendor").jqGrid('getRowData',rowId);
        
        for(var ii = 0 ; ii < copyColNms.length ; ii++ ){
            addDataSet[copyColNms[ii]] = orgDataSet[copyColNms[ii]] ; 
        }
        
        var newRowId = $("#prodVendor").getDataIDs().length+1;
        jQuery("#prodVendor").addRowData(newRowId,addDataSet);
        jQuery("#prodVendor").setSelection(newRowId);
        fnSetProdVendorComponent();
    };
    
    // 공급사 추가  
    var fnProdVendorAdd = function(){
        var newRowId = $("#prodVendor").getDataIDs().length+1;
        jQuery("#prodVendor").addRowData(newRowId, {issub_ontract:'0',good_clas_code:'10',deli_mini_quan:'1',deli_mini_day:'3',vendor_priority:'0', good_reg_year:'<%=getYear%>'});
                                                    //issub_ontract
        jQuery("#prodVendor").setSelection(newRowId);
        fnSetProductDescContents(Editor.getContent());
        fnSetProdVendorComponent();
    };
    
    
    // 공급사 삭제
    var fnProdVendorDel = function (){
        var rowId = $("#prodVendor").getGridParam("selrow");
        if(rowId == null){
            $('#dialogSelectRow').html('<p>선택된 공급사 정보가 존재하지 않습니다. </p>'); 
            $("#dialogSelectRow").dialog();
            return;
        }

        var params = new Object();
        params["vendorid"] = jq("#prodVendor").jqGrid('getRowData',rowId)['vendorid']; 
        params["good_iden_numb"] = jq("#productMaster").jqGrid('getRowData',$("#productMaster").getDataIDs()[0])['good_iden_numb'];
        
        if(FNgetGridDataObj('prodVendor',rowId,'orgregist_date') == ''){
            $('#prodVendor').jqGrid('delRowData',rowId);
        }else {
            
            if(FNgetGridDataObj('prodVendor',rowId,'orgisUse') == '1') {
                $('#dialogSelectRow').html('<p>선택된 공급사는 삭제할수 없습니다.<br />단종처리 후 삭제 처리 하시기 바랍니다.</p>');
                $("#dialogSelectRow").dialog();
                return;    
            }
            
            jq("#prodVendor").jqGrid(
                'delGridRow'
                ,rowId
                , { url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/prodVendorTransGrid.sys"
                   ,delData:params
                   ,recreateForm:true
                   ,beforeShowForm:function(form) {$(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 공급사를 삭제 하시겠습니까?' + '</span>');}
                   ,reloadAfterSubmit:false
                   ,closeAfterDelete:true
                   ,afterSubmit:function(response, postdata) {
                        //alert('성공적으로 처리 하였습니다. ');
                   
                        if(typeof(window.dialogArguments) != 'undefined'){
                            window.returnValue='success';
                        }
                       
                            return fnJqTransResult(response, postdata);
                       
                    }
                }
            );
        }       
    };
    
    // 물량 배분 설정시 상품 공급들 물량 배분 여부는 0 보다 커야한다.  
    function fnCheakdistri_rateInfo() {
        
        var rowId       = $("#productMaster").getGridParam("selrow");
        
        if(FNgetGridDataObj('productMaster',rowId,'isdistribute') == '2'){
            
            var rowCnt = jq("#prodVendor").getGridParam('reccount');
            
            if(rowCnt > 0){
                var totalRate = 0; 
                for(var i=0 ; i<rowCnt ; i++) {
                    var venRowid = $("#prodVendor").getDataIDs()[i];
                    
                    
                    if(FNgetGridDataObj('prodVendor',venRowid,'orgisUse') != '0' ){
                            if(FNgetGridDataObj('prodVendor',venRowid,'distri_rate') == '' ) 
                                FNAlterGridDataProValue('prodVendor',venRowid,'distri_rate', '0');
                            
                            totalRate += parseFloat(FNgetGridDataObj('prodVendor',venRowid,'distri_rate'));
                    }
                }
                //alert(totalRate);
                
                if(!(totalRate > 0 )) {
                    alert('물량 배분 설정시 상품공급사 물량배분율 합계는 0 보다 커야합니다.'); 
                    return false;
                }
            }
        }
        return true; 
    }
    
    //상품 마스터 및 공급사 정보 저장   
    var  fnSaveProductInfo = function(){
        
        //Validation 채크
        if(!fnCheakValidationProdInfo())    return ;
        if(!fnCheakValidationProdVendorInfo())  return ; 
        if(!fnCheakdistri_rateInfo())  return ; // 물량배분여부 
        
        // 상세 설명 관련 이벤트 
        fnSetProductDescContents(Editor.getContent());
        
        /*
        *  javaScript Object properties 설정    
        *  mstParamNms : 상품기본정보 Properties    
        *  vendorParamNms : 상품   Properties
        */
        var mstParamNms     = new Array('isModify','good_iden_numb','cate_id','good_name','vtax_clas_code','sale_criterion_type','stan_buying_rate','stan_buying_money','isdistribute','isdisppastgood','isdisppastgood','product_manager');
        var vendorParamNms  = new Array('vendorid','sale_unit_pric','orde_clas_code','deli_mini_day','deli_mini_quan','make_comp_name','original_img_path','large_img_path','middle_img_path','small_img_path','good_desc','issub_ontract','good_clas_code','good_inventory_cnt','orgsale_unit_pric','bidid','bid_vendorid' , 'req_good_id','distri_rate','good_spec_desc','good_st_spec_desc','good_same_word','good_reg_year','vendor_priority');
        var lastWord        = '_array';
        
        // Parameter Object 
        var params          = new Object(); 
        
        // 수정 여부 
        var isModyfy        = false; 
        var rowId       = $("#productMaster").getGridParam("selrow");
        var mstGridData = jq("#productMaster").jqGrid('getRowData',rowId); 
        
        // 수정 여부에 따른 mstParamNms 파라미터 설정 
        if(mstGridData["isModify"] == '1' ){
            isModyfy = true; 
        }
        for(var ii = 0 ; ii < mstParamNms.length ; ii++ ){
            params[mstParamNms[ii]] = mstGridData[mstParamNms[ii]];  
        }       
        
        // 수정 여부에 따른 mstParamNms 파라미터 설정
        for(var ii = 0 ; ii < vendorParamNms.length ; ii++ ){
            var colVals = new Array();
            
            for(var jj = 0 ; jj < jq("#prodVendor").getGridParam('reccount') ; jj ++){
                var prodVendrowId = $("#prodVendor").getDataIDs()[jj];
                if(jq("#prodVendor").jqGrid('getRowData',prodVendrowId)['isModify'] == '1'){
                    colVals.push(jq("#prodVendor").jqGrid('getRowData',prodVendrowId)[vendorParamNms[ii]]);
                }
            }
            
            if(colVals != null ) {
                params[vendorParamNms[ii]+lastWord] = colVals;    
            }
        }
        
        
        if(params['vendorid'] != 'undefined'){
            isModyfy = true;    
        }
        
        if(!isModyfy){
            $('#dialogSelectRow').html('<p>수정및 추가된 정보가 없습니다. 확인후 이용하시기 바랍니다.</p>');
            $("#vtax_clas_code").focus();
            $("#dialogSelectRow").dialog();
            return;
        }
        
        if(!confirm("입력 및 수정하신 내용을 저장하시겠습니까?")) return;
        
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/prodyctInfoTransGrid.sys", 
            params,
            function(arg){ 
                if(  fnTransResult(arg, false) ) {
                    
                    var msg = eval('(' + arg + ')').msg;
                    
                    if((typeof(msg) != 'undefined') && $.trim(msg).length > 0  ){
                        $("#dialog").html("<font size='2'>"+msg+"</font>");
                        $("#dialog").dialog({
                            title: 'Success',modal: true,
                            buttons: {"Ok": function(){$(this).dialog("close");} }
                        });
                    }else {
                        alert("처리 하였습니다.");
//                         $("#dialog").html("<font size='2'>처리 하였습니다.</font>");
//                         $("#dialog").dialog({
//                             title: 'Success',modal: true,
//                             buttons: {"Ok": function(){
//                                 $(this).dialog("close"); 
//                                 }}
//                         });

                        var venRowid   = $("#prodVendor").getGridParam("selrow");
                        var venRowData = jq("#prodVendor").jqGrid('getRowData',venRowid);
                        
                        reqParamObj['vendorid']         = venRowData['vendorid'];
                        reqParamObj['bidid']            = '';
                        reqParamObj['bid_vendorid']     = '';
                        reqParamObj['req_good_id']      = '';
                        
                        var good_iden_numb = eval('(' + arg + ')').good_iden_numb;
                        if($('#good_iden_numb').val(good_iden_numb)){
                            
                            //상품진열정보 조회   
                            var data = {good_iden_numb:good_iden_numb};
                            jq("#productMaster").jqGrid("setGridParam", { "postData": data });
                            jq("#productMaster").trigger("reloadGrid");
                            
                            $('#prodVendor').jqGrid('clearGridData');
                            jq("#prodVendor").jqGrid("setGridParam", { "postData": data });
                            jq("#prodVendor").trigger("reloadGrid");
                            
                            jq("#prodDisplay").jqGrid("setGridParam", { "postData": data });
                            jq("#prodDisplay").trigger("reloadGrid");
                            
                            if(typeof(window.dialogArguments) != 'undefined'){
                                window.returnValue='success';
                            }
                        }
                    }
                    
                    
                    
                    
//                     var msg = '';
//                     msg += '\n' + typeof(window.dialogArguments) ;
//                     msg += '\n'+typeof(window.dialogArguments) == 'undefined'; 
                    
//                     alert(msg);
                    // 등록일 경우와  상세일 경우 닫기 버튼 처리
                    if(typeof(window.dialogArguments) != 'Object'){
                            $('#btnCommonClose').hide();
                    }
                }
            }
        );
    };
    
    /**
     * 해당 Page 닫기
     */
    var fnThisPageClose = function() {
        this.close();
//         if(typeof(window.dialogArguments) == 'object') {
//             top.close();
//         }
    };
    
    // 상품 Validation 
    var fnCheakValidationProdInfo = function(){
        
        var rowId = $("#productMaster").getGridParam("selrow");
        var mstGridData = jq("#productMaster").jqGrid('getRowData',rowId);
        
        // 카테고리
        if( $.trim(mstGridData['cate_id']) == '' || $.trim(mstGridData['cate_id']) == '0' ){
            $('#dialogSelectRow').html('<p>카테고리 정보가 존재하지 않습니다..</p>');
            $("#dialogSelectRow").dialog();
            return false;
        }
        
        // 상품명 123
        if( $.trim(mstGridData['good_name']) == '' ){
            $('#dialogSelectRow').html('<p>상품명은 필수 값입니다.</p>');
            $("#good_name").focus();
            $("#dialogSelectRow").dialog();
            return false;
        }
        
        // 과세구분 
        if( $.trim(mstGridData['vtax_clas_code']) == '' ){
            $('#dialogSelectRow').html('<p>상품 과세구분 정보가 존재하지 않습니다.</p>');
            $("#vtax_clas_code").focus();
            $("#dialogSelectRow").dialog();
            return false;
        }
        
        // 판매가산출옵션 
        if( !($.trim(mstGridData['sale_criterion_type']) == '10' || $.trim(mstGridData['sale_criterion_type']) == '20')){
            $('#dialogSelectRow').html('<p>상품 판매가산출옵션 정보가 존재하지 않습니다.</p>');
            $("#sale_criterion_type").focus();
            $("#dialogSelectRow").dialog();
            return false;
        }

        // 절대판매가 
        if( $.trim(mstGridData['sale_criterion_type']) == '20' ){
            if(( $('#sale_unit_pric').val().length > 0 && parseFloat($('#sale_unit_pric').val()) > 0) &&  parseFloat($('#sale_unit_pric').val().replace(/,/g , "")) > $.trim(mstGridData['stan_buying_money'])){
            $('#dialogSelectRow').html('<p>매입단가는 절대판매가보다 큰 값을 입력할수 없습니다. </p>');
            $("#dialogSelectRow").dialog();
            return false; 
            }
        }
        
        // 기준매익률 
        if( $.trim(mstGridData['sale_criterion_type']) == '10' ){
            if( ($('#stan_buying_rate').val().length > 0 && parseFloat($('#stan_buying_rate').val()) > 0) && parseFloat($('#stan_buying_rate').val().replace(/,/g , "")) == 0){
                $('#dialogSelectRow').html('<p>기준매익률은 0보다 큰 값이여야 합니다. </p>');
                $("#dialogSelectRow").dialog();
                return false; 
            }
            
            if(( $('#stan_buying_rate').val().length > 0 && parseFloat($('#stan_buying_rate').val()) > 0) &&  parseFloat($('#stan_buying_rate').val().replace(/,/g , "")) > 100){
                $('#dialogSelectRow').html('<p>기준매익률은 100보다 큰 값을 입력할수 없습니다. </p>');
                $("#dialogSelectRow").dialog();
                return false; 
            }
        }
        
        //물량배분여부
        if( $.trim(mstGridData['isdistribute']) == ''){
            $('#dialogSelectRow').html('<p>상품 물량배분여부 정보가 존재하지 않습니다.</p>');
            $("#isdistribute").focus();
            $("#dialogSelectRow").dialog();
            return false;    
            
        }
        
      //물량배분여부
        if( $.trim(mstGridData['isdistribute']) == ''){
            $('#dialogSelectRow').html('<p>상품 물량배분여부 정보가 존재하지 않습니다.</p>');
            $("#isdistribute").focus();
            $("#dialogSelectRow").dialog();
            return false;    
            
        }
        
   
        
        return true;
    };
    
    
    // 상품 공급사 Validation 
    var fnCheakValidationProdVendorInfo = function(){

        var rowCnt = jq("#prodVendor").getGridParam('reccount'); 
        if(rowCnt > 0){
            for(var i=0 ; i<rowCnt ; i++) {
                var venRowid = $("#prodVendor").getDataIDs()[i];
                var venRowData = jq("#prodVendor").jqGrid('getRowData',venRowid);
                
                // 공급사 
                if($.trim(venRowData["vendorid"]) == '') {
                    $('#dialogSelectRow').html('<p>' +parseInt(i+1)+ '번째 상품공급사 정보가 존재하지 않습니다.</p>');
                    $("#dialogSelectRow").dialog();
                    return false; 
                }
                
                //하도급대상여부 
                //alert(venRowData["issub_ontract"]); 
//                 if($.trim(venRowData["issub_ontract"]) == '') {
//                     $('#dialogSelectRow').html('<p>' +parseInt(i+1)+ '번째 상품공급사 하도급대상여부 정보가 존재하지 않습니다.</p>');
//                     $("#dialogSelectRow").dialog();
//                     return false; 
//                 }

                // 매입단가
                if($.trim(venRowData["sale_unit_pric"]) == '' || $.number(venRowData["sale_unit_pric"]) == '0') {
                    $('#dialogSelectRow').html('<p>' +parseInt(i+1)+ '번째 상품공급사 매입단가 정보가 존재하지 않습니다.</p>');
                    $("#dialogSelectRow").dialog();
                    return false; 
                }

                
                // 단위
                if($.trim(venRowData["orde_clas_code"]) == '') {
                    $('#dialogSelectRow').html('<p>' +parseInt(i+1)+ '번째 상품공급사 주문 단위 정보가 존재하지 않습니다.</p>');
                    $("#dialogSelectRow").dialog();
                    return false; 
                }
                
                //최소주문수량
                if($.trim(venRowData["deli_mini_quan"]) == '' || $.trim(venRowData["deli_mini_quan"]) == '0') {
                    $('#dialogSelectRow').html('<p>' +parseInt(i+1)+ '번째 상품공급사 최소주문수량 정보가 존재하지 않습니다.</p>');
                    $("#dialogSelectRow").dialog();
                    return false; 
                }
                
                // 납품소요일
                if($.trim(venRowData["deli_mini_day"]) == '' || $.number(venRowData["deli_mini_day"]) == '0') {
                    $('#dialogSelectRow').html('<p>' +parseInt(i+1)+ '번째 상품공급사 납품소요일 정보가 존재하지 않습니다.</p>');
                    $("#dialogSelectRow").dialog();
                    return false; 
                }
             // 상품실적년도
                if($.trim(venRowData["good_reg_year"]) == '') {
                    $('#dialogSelectRow').html('<p>상품실적년도 선택이 되어있지 않습니다.</p>');
                    $("#dialogSelectRow").dialog();
                    return false; 
                }
                
             // 상품이미지
//                 if($.trim(venRowData["original_img_path"]) == '' || $.number(venRowData["original_img_path"]) == '0') {
//                     $('#dialogSelectRow').html('<p>' +parseInt(i+1)+ '번째 상품이미지가 존재하지 않습니다.</p>');
//                     $("#dialogSelectRow").dialog();
//                     return false; 
//                 }
            }
        }
        
        
        // 물량배분시  공급사별 
        return true; 
    };
    
    
    
    // NumberPormatOption 
    var numFormatType = new Array(
               {numType:'persent',  option:{decimalSymbol: '.',digitGroupSymbol:'',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:2}},
               {numType:'number',   option:{decimalSymbol: '.',digitGroupSymbol:',',dropDecimals:false,groupDigits:true,symbol:'',roundToDecimalPlace:0}}
        );

    // 컨퍼넌트 변화에 따른 Formatting 
    var fnSetFormatCurrency =  function(obj){
        var colNm = $(obj).attr('id');
        var altNm = $(obj).attr('alt');
        var modVal = '';
        
        for(var formatIdx = 0 ; formatIdx < numFormatType.length ; formatIdx++){
            if(numFormatType[formatIdx].numType == altNm)   
                $(obj).formatCurrency(numFormatType[formatIdx].option);
        }
    };
    
    
    
    // 진열정보 등록
    var fnDispInsGoodTrans = function(tranObj){
    
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/displayInsGoodTrans.sys"
            , tranObj
            , function(arg) {
                if(fnTransResult(arg, false)){
                   var msg = eval('(' + arg + ')').msg;
                   
                   var mstGridData = jq("#productMaster").jqGrid('getRowData',$("#productMaster").getGridParam("selrow"));
                   jq("#prodDisplay").jqGrid("setGridParam", { "postData": {good_iden_numb:mstGridData['good_iden_numb']}});
                   jq("#prodDisplay").trigger("reloadGrid");
                   fnInsDisplayOpenPopClose();
                   
                    alert('진열 정보가 추가 되었습니다. ');
                }
            }
        );  
    };
    
    // 진열정보 수정 
    var fnParentDisplayGoodTrans = function(paramObj){
        //중복체크 
        var areatype       = paramObj['areatype'];                  //  소재지 
        var sale_unit_pric = $.number(paramObj['sale_unit_pric']);  //  판매단가 sale_unit_pric
        var sell_price     = $.number(paramObj['sell_price']);      //  매입단가 sell_price
        var ref_good_seq   = paramObj['ref_good_seq'];
        var groupid        = paramObj['groupid'];
        var clientid       = paramObj['clientid'];
        var branchid       = paramObj['branchid'];
        var vendorid       = paramObj['vendorid'];
        
        if(groupid.length==0)       {groupid = '0'; paramObj['groupid']  = '0';}  
        if(clientid.length==0)  {clientid = '0'; paramObj['clientid']= '0';}
        if(branchid.length==0)  {branchid = '0'; paramObj['branchid']='0'; }
        
        
        if(areatype == ''){
            alert('소재지 정보는 필수 입력 사항 입니다. '); 
            return ;
        }
        
        // 등록일시 중복채크 
        if(ref_good_seq == '0'){
            
            var rowCnt = jq("#prodDisplay").getGridParam('reccount'); 
            if(rowCnt > 0){
                for(var i=0 ; i<rowCnt ; i++) {
                    var dispRowid = $("#prodDisplay").getDataIDs()[i];
                    var dispRowData = jq("#prodDisplay").jqGrid('getRowData',dispRowid);
                    
                    
                    
                    var msg = ''; 
                    msg += '\n groupid    first:['+groupid+'] second:['+dispRowData['groupid']+']'; 
                    msg += '\n clientid    first:['+clientid+'] second:['+dispRowData['clientid']+']';
                    msg += '\n branchid   first:['+branchid+'] second:['+dispRowData['branchid']+']';
                    msg += '\n vendorid    first:['+vendorid+'] second:['+dispRowData['vendorid']+']';
                    msg += '\n areatype    first:['+areatype+'] second:['+dispRowData['areatype']+']';
                    
                    //alert(msg);
                    
                    
                    
                    
                    if(groupid == dispRowData['groupid'] && clientid == dispRowData['clientid']&& branchid == dispRowData['branchid']&& vendorid ==  dispRowData['vendorid'] && areatype == dispRowData['areatype'] ) {
                       
                        alert('이미 해당 소재지에 해당하는 사업장진열정보가 존재합니다.\n확인후 이용하시기 바랍니다. '); 
                        return ; 
                    }
                }
            }
        }
        
        var msg = ''; 
        for (var propNm in paramObj){
            msg += '\n '+propNm+' =[' + paramObj[propNm] + '] ';
        }
          
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/displayGoodTrans.sys"
            , paramObj
            , function(arg) {
                if(fnTransResult(arg, false)){
                   var msg = eval('(' + arg + ')').msg;
                   if($.trim(msg) != '' ){
                        $("#dialog").html("<font size='2'>"+msg+"</font>");
                        $("#dialog").dialog({
                            title: 'Fail',modal: true,
                            buttons: {"Ok": function(){$(this).dialog("close");} }
                        });
                    
                   }else {
                        $("#dialog").html("<font size='2'>처리 하였습니다.</font>");
                        $("#dialog").dialog({
                            title: 'Success',modal: true,
                            buttons: {"Ok": function(){$(this).dialog("close");} }
                        });
                   }
                    window.setTimeout(function(){ $("#dialog").dialog("close");},500); 
                    var mstGridData = jq("#productMaster").jqGrid('getRowData',$("#productMaster").getGridParam("selrow"));
                    jq("#prodDisplay").jqGrid("setGridParam", { "postData": {good_iden_numb:mstGridData['good_iden_numb']}});
                    jq("#prodDisplay").trigger("reloadGrid");
                    fnDisplayOpenPopClose();
                }
            }
        );
    };
    
    /**
    * 단가 변경 요청 팝업을 연다 
    */
    var fnOepnChagePriceDiv =function(){
        var rowid = $('#prodVendor').getGridParam("selrow");
        if(rowid == null) {
           $("#prodVendor").setSelection($("#prodVendor").getDataIDs()[0]);
           rowid = $('#prodVendor').getGridParam("selrow");
        }
        var rowData = jq('#prodVendor').jqGrid('getRowData',rowid);
        
        if(rowData['prodvendorappflag']=='Y'){
            $('#dialogSelectRow').html('<p>매입단가 변경및 종료 요청중인 상태입니다. \n확인후 이용하시기 바랍니다.</p>');
            $("#dialogSelectRow").dialog();
            return false; 
        }
        
        $('#org_sale_unit_pric').val(rowData['orgsale_unit_pric']); 
        $('#org_sale_unit_pric').blur();
        $('#divReqChangePrice').attr("style", "position:absolute; top:700px; left:300px;z-index: 200;display:inline;");
    };
    
    
    /**
    *   공급사 매입단가 변경 요청
    */
    var fnReqestChangePrice = function(){

        var rowid = $('#prodVendor').getGridParam("selrow");
        if(rowid == null) {
           $("#prodVendor").setSelection($("#prodVendor").getDataIDs()[0]);
           rowid = $('#prodVendor').getGridParam("selrow");
        }
        var rowData = jq('#prodVendor').jqGrid('getRowData',rowid);
        
        if(rowData['orgprodvendorappflag'] == 'Y'){
            $('#dialogSelectRow').html('<p>이미 승인요청중인 데이터 입니다.<br>확인후 이용하시기 바랍니다. </p>');
            $("#dialogSelectRow").dialog();
            return false; 
        }
        
        if(rowData['orgchageproductrequest'] == 'Y'){
            $('#dialogSelectRow').html('<p>이미 변경요청중인 데이터 입니다.<br>확인후 이용하시기 바랍니다. </p>');
            $("#dialogSelectRow").dialog();
            return false; 
        }
        
        // 변경 매입단가. 
        if(parseInt($('#price').val().replace(/,/g , "")) == '0'){
            $('#dialogSelectRow').html('<p>변경매입단가는 0보다 큰 값이여야 합니다. </p>');
            $("#dialogSelectRow").dialog();
            return false; 
        }
        
        // 공급사 
        if($.trim($('#apply_desc').val()) == '') {
            $('#dialogSelectRow').html('매입단가 변경요청시 사유는 필수로 입력하셔야 합니다.');
            $("#dialogSelectRow").dialog();
            return false; 
        }
    
        if(!confirm("입력하신 변경 단가금액을 요청하시겠습니까?")) return;
        
        var sumbitObj = new Object(); 
        sumbitObj['good_iden_numb'] = rowData['good_iden_numb'];
        sumbitObj['vendorid']       = rowData['vendorid'];
        sumbitObj['applt_fix_code'] = '20';
        sumbitObj['apply_desc']     = $.trim($('#apply_desc').val()); 
        sumbitObj['price']          = $.trim($('#price').val());
        sumbitObj['before_price']   = $.trim($('#org_sale_unit_pric').val());
        
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/setFixGoodUnitPriceTrans.sys", 
            sumbitObj,
            function(arg){
                if(fnAjaxTransResult(arg)){
                    $('#divReqChangePrice').attr("style", "position:absolute; top:700px; left:300px;z-index: 200;display:none;");
                    jq("#prodVendor").trigger("reloadGrid");
                    jq("#prodDisplay").trigger("reloadGrid");
                }
            }
        );
    };
    
    /**
    * 종료요청 버튼 클릭시 발생 이벤트 
    */
    var fnOepnSoldOutDiv = function() {
        var rowid = $('#prodVendor').getGridParam("selrow");
        if(rowid == null) {
           $("#prodVendor").setSelection($("#prodVendor").getDataIDs()[0]);
           rowid = $('#prodVendor').getGridParam("selrow");
        }
        var rowData = jq('#prodVendor').jqGrid('getRowData',rowid);
        
        if(rowData['prodvendorappflag']=='Y'){
            $('#dialogSelectRow').html('<p>매입단가 변경및 종료 요청중인 상태입니다. \n확인후 이용하시기 바랍니다.</p>');
            $("#dialogSelectRow").dialog();
            return false; 
        }
        
        $('#divSoldOut').attr("style", "position:absolute; top:700px; left:300px;z-index: 200;display:inline;");
    };
    
    /**
    * 종료요청 버튼 클릭시 발생이벤트 
    */
    var fnRequestSoldOut = function () {
        var rowid = $('#prodVendor').getGridParam("selrow");
        if(rowid == null) {
           $("#prodVendor").setSelection($("#prodVendor").getDataIDs()[0]);
           rowid = $('#prodVendor').getGridParam("selrow");
        }
        var rowData = jq('#prodVendor').jqGrid('getRowData',rowid);
        
        if(rowData['orgprodvendorappflag'] == 'Y'){
            $('#dialogSelectRow').html('<p>이미 승인요청중인 데이터 입니다.<br>확인후 이용하시기 바랍니다. </p>');
            $("#dialogSelectRow").dialog();
            return false; 
        }
        
        if(rowData['orgchageproductrequest'] == 'Y'){
            $('#dialogSelectRow').html('<p>이미 변경요청중인 데이터 입니다.<br>확인후 이용하시기 바랍니다. </p>');
            $("#dialogSelectRow").dialog();
            return false; 
        }
        
        if($.trim($('#sold_out_desc').val())==''){
            $('#dialogSelectRow').html('<p>종료요청시 사유는 필수 입니다..</p>');
            $("#dialogSelectRow").dialog();
            return false; 
        }
        
        
        
        if(!confirm("종료 요청하시겠습니까?")) return;
        
        var rowid = $('#prodVendor').getGridParam("selrow");
        if(rowid == null) {
           $("#prodVendor").setSelection($("#prodVendor").getDataIDs()[0]);
           rowid = $('#prodVendor').getGridParam("selrow");
        }
        var rowData = jq('#prodVendor').jqGrid('getRowData',rowid);
        
        var sumbitObj = new Object(); 
        sumbitObj['good_iden_numb'] = rowData['good_iden_numb'];
        sumbitObj['vendorid']       = rowData['vendorid'];
        sumbitObj['applt_fix_code'] = '30';
        sumbitObj['apply_desc']     = $.trim($('#sold_out_desc').val()); 
        sumbitObj['price']          = '';
        sumbitObj['before_price']   = rowData['sale_unit_pric'];
        
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/setFixGoodUnitPriceTrans.sys", 
            sumbitObj,
            function(arg){
                if(fnAjaxTransResult(arg)){
                    $('#divSoldOut').attr("style", "position:absolute; top:700px; left:300px;z-index: 200;display:none;");
                    jq("#prodVendor").trigger("reloadGrid");
                    jq("#prodDisplay").trigger("reloadGrid");
                }
            }
        );
        
    };
    
    /**
    *   상세설명 수정시 발생 이벤트 
    */
    var  fnSetProductDescContents = function(contents){
        var rowId = $("#prodVendor").getGridParam("selrow");
        if(rowId == null){
            return ; 
        }
        
        contents = escape(contents);
        
        FNAlterGridDataProValue('prodVendor',rowId,'good_desc', contents);
        FNAlterGridDataProValue('prodVendor',rowId,'isModify', '1');
    };
    
    /**
    *   규격 수정시 발생 이벤트 
    */
    var fnSetChangeGoodSpecDesc = function() {
        var rowId       = $("#prodVendor").getGridParam("selrow");
        
        if(rowId != null ){
            var good_spec_desc =
                $('#good_spec_desc1').val()+'‡'+ 
                $('#good_spec_desc2').val()+'‡'+
                $('#good_spec_desc3').val()+'‡'+
                $('#good_spec_desc4').val()+'‡'+
                $('#good_spec_desc5').val()+'‡'+
                $('#good_spec_desc6').val()+'‡'+
                $('#good_spec_desc7').val()+'‡'+
                $('#good_spec_desc8').val();
                
            FNAlterGridDataProValue('prodVendor',rowId,'isModify', '1');
            FNAlterGridDataProValue('prodVendor',rowId,'good_spec_desc', good_spec_desc);    
        }
    };
    
    /**
     *   표준 규격 수정시 발생 이벤트 
     */
     var fnSetChangeGoodStSpecDesc = function() {
         var rowId       = $("#prodVendor").getGridParam("selrow");
         
         if(rowId != null ){
             var good_st_spec_desc =
                 $('#good_st_spec_desc1').val()+'‡'+ 
                 $('#good_st_spec_desc2').val()+'‡'+
                 $('#good_st_spec_desc3').val()+'‡'+
                 $('#good_st_spec_desc4').val()+'‡'+
                 $('#good_st_spec_desc5').val()+'‡'+
                 $('#good_st_spec_desc6').val();
                 
             FNAlterGridDataProValue('prodVendor',rowId,'isModify', '1');
             FNAlterGridDataProValue('prodVendor',rowId,'good_st_spec_desc', good_st_spec_desc);    
         }
     };
     
    
    /**
    *   동의어 수정시 발생 이벤트  
    */
    var fnSetChangeSameWord = function() {
        var rowId       = $("#prodVendor").getGridParam("selrow");
        
        if(rowId != null ){
            var good_same_word =
                $('#good_same_word1').val()+'‡'+ 
                $('#good_same_word2').val()+'‡'+
                $('#good_same_word3').val()+'‡'+
                $('#good_same_word4').val()+'‡'+
                $('#good_same_word5').val();
                
            FNAlterGridDataProValue('prodVendor',rowId,'isModify', '1');
            FNAlterGridDataProValue('prodVendor',rowId,'good_same_word', good_same_word);    
        }
    };
    

    /**
    *   종료 취소 처리
    */
    var fnUseStatsModify = function(){
        var rowId   = $("#prodVendor").getGridParam("selrow");
        
        if(!confirm("종료상태를 변경 하시겠습니까?"))    return false;
        
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/setModifyUseState.sys"
            , {good_iden_numb:$('#good_iden_numb').val(),vendorid:FNgetGridDataObj('prodVendor', rowId , 'vendorid' )}
            , function(arg) {
                if(fnAjaxTransResult(arg)){
                    $('#divSoldOut').attr("style", "position:absolute; top:700px; left:300px;z-index: 200;display:none;");
                    jq("#prodVendor").trigger("reloadGrid");
                    jq("#prodDisplay").trigger("reloadGrid");
                }
            }
        );
    };
</script>
<script type="text/javascript">
    //카테고리 Excell 
    function fnCategoryExcell(){
        var colLabels = ['진열카테고리명','진열조직','사용여부','진열설명'];   //출력컬럼명
        var colIds = ['cate_Disp_Name','borgNms','is_Disp_Use','cate_Disp_Desc'];   //출력컬럼ID
        var numColIds = ""; //숫자표현ID
        var sheetTitle = "진열카테고리";  //sheet 타이틀
        var excelFileName = "DisplayCategory";  //file명
        
        fnExportExcel(jq("#dispCategory"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
    }
    // 공급사 Excell 
    function fnVendorExcell(){
        var colLabels = ['공급사명','대표자명','대표연락처','소재지','매입단가','납품소요일수','최소구매수량','이미지등록여부','상품설명등록여부','등록일'];   //출력컬럼명
        var colIds = ['vendornm','pressentnm','phonenum','areatype','sale_unit_pric','deli_mini_day','deli_mini_quan','isexistimg','isexistgooddesc','regist_date'];    //출력컬럼ID
        var numColIds = ['sale_unit_pric','deli_mini_day']; //숫자표현ID
        var sheetTitle = "상품공급사";   //sheet 타이틀
        var excelFileName = "prodVendorInfo";   //file명
        
        fnExportExcel(jq("#prodVendor"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");  //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
    }
    
    //진열 Excell 
    function fnDispExcell(){
        var colLabels = ['진열고객사명','고객사 상품코드','판매가','매입가','공급사명','계약시작일','계약종료일'];   //출력컬럼명
        var colIds = ['fullborgnms','cust_good_iden_numb','sell_price','sale_unit_pric','vendornm','cont_from_date','cont_to_date'];    //출력컬럼ID
        var numColIds = ['sell_price','sale_unit_pric'];    //숫자표현ID
        var sheetTitle = "진열정보";    //sheet 타이틀
        var excelFileName = "ㅇdisplayProductInfo";  //file명
        
        fnExportExcel(jq("#prodDisplay"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>"); //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
    }
    
    function fnProdVendorDelOrdeCheck(){
        var rowId = $("#prodVendor").getGridParam("selrow");
        if(rowId == null){
            $('#dialogSelectRow').html('<p>선택된 공급사 정보가 존재하지 않습니다. </p>'); 
            $("#dialogSelectRow").dialog();
            return;
        }
        var selrowContent = jq("#prodVendor").jqGrid('getRowData',rowId);
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/prodVendorOrdeCntSearch.sys",
            {  
                vendorId:selrowContent.vendorid
                , goodIdenNumb:selrowContent.good_iden_numb
            },
            function(arg){
                var orderCnt = eval('(' + arg + ')').orderCnt;
                if( 0 < Number(orderCnt.ORDERPURCCNT)){
                    $('#dialogSelectRow').html('<p>기존에 주문이 존재하여 삭제할 수 없습니다.</p>'); 
                    $("#dialogSelectRow").dialog();
                    return;
                }else{
                    fnProdVendorDel();
                }
            }
        );
    }
    
    //실적년도 날짜세팅
    function goodRegYear() {
        var getYear = '<%=getYear%>';
        var selectYN = "";
        for(var i=getYear; i>=2010;i--){
            if(i==getYear){
                selectYN = "selected";
            }
            else{
                selectYN = "";
            }
            $("#good_reg_year").append("<option value="+i+" "+selectYN+">"+i+"년</option>");
        }
        $("#good_reg_year").val(getYear);
    }

    
</script>

<script type="text/javascript">
//상품담당자 셀렉트박스
//B2B권한
function selectProductManager(){
    $.post(
        "/product/selectProductManager/list.sys",
        {},
        function(arg){
            var productManagetList = eval('('+arg+')').list;
            for(var i=0; i<productManagetList.length; i++){
                $("#product_manager").append("<option value='"+productManagetList[i].USERID+"'>"+productManagetList[i].USERNM+"</option>");
            }
            if($("#productMaster").getGridParam('reccount') > 0){
                var rowId = $("#productMaster").getDataIDs()[0];
                var selrowContent = jq("#productMaster").jqGrid('getRowData',rowId);
                $("#product_manager").val(selrowContent.product_manager);
            }
        }
    );
}
</script>
</head>
<body>
<%-- <%if (!good_iden_numb.equals("0")) {out.print("style='position:absolute;top:0;left:0;width:1050px;height:800px;overflow:auto;'");}%>  --%>
    <div>
        <form id="frm" name="frm" method="post">
            <table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                    <td>
                        <!-- 타이틀 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr valign="top">
                                <td width="20" valign="middle">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                                </td>
                                <td height="29" class='ptitle'>상품등록</td>
                            </tr>
                        </table>
                        <!-- 타이틀 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="20" valign="top">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                                </td>
                                <td class="stitle">상품카테고리</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="2" class="table_top_line"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject9" width="100">상품카테고리</td>
                                <td class="table_td_contents">
                                    <input id="full_cate_name" name="full_cate_name" type="text" value="" size="" maxlength="50" style="width: 250px; width: 50%;" class="blue" disabled="disabled" />
                                    <input id="cate_id" name="cate_id" type="text" style="display: none;" value="" onchange="javascript:fnSetChangeComponentData(this,event,'productMaster','org');" />
                                    <img id='btnSearchCategory' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_inquiry.gif" width="40" height="18" class='icon_search' style="vertical-align: middle;" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="table_top_line"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
                            <tr>
                                <td width="20" valign="top">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                                </td>
                                <td class="stitle">상품진열카테고리</td>
                                <td align="right" class="stitle">
                                    <!-- btnAdd -->
                                    <img id="btnCategoryExcel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="jqgrid">
                            <table id="dispCategory"></table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <!-- 타이틀 시작 -->
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                            <tr>
                                <td width="20" valign="top">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                                </td>
                                <td class="stitle">상품기본정보</td>
                            </tr>
                        </table>
                        <!-- 타이틀 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="jqgrid" style="display: none;">
                            <table id="productMaster"></table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <!-- 상품기본정보 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td colspan="6" class="table_top_line"></td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject" width="100">상품코드</td>
                                <td class="table_td_contents">
                                    <input id="good_iden_numb" name="good_iden_numb" type="text" value="" style="background-color: #eaeaea;" maxlength="50" readonly="readonly" />
                                </td>
                                <td class="table_td_subject9" width="100">상품명</td>
                                <td class="table_td_contents">
                                    <input id="good_name" name="good_name" type="text" maxlength="50" onchange="javascript:fnSetChangeComponentData(this,event,'productMaster','org');" />
                                </td>
                                <td class="table_td_subject9" width="100">과세구분</td>
                                <td class="table_td_contents">
                                    <select id='vtax_clas_code' name="vtax_clas_code" class="select" onchange="javascript:fnSetChangeComponentData(this,event,'productMaster','org');">
                                        <option value="">선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject9">판매가산출옵션</td>
                                <td class="table_td_contents">
                                    <input name="sale_criterion_type" style="border: 0px;" type="radio" value="10" onchange="javascript:fnChangeCriterion(); " />매익률 <!--  fnSetChangeComponentData(this,event,'productMaster','org'); -->
                                    <input name="sale_criterion_type" style="border: 0px;" type="radio" value="20" onchange="javascript:fnChangeCriterion(); " />절대판매가 <!--  fnSetChangeComponentData(this,event,'productMaster','org'); -->
                                </td>
                                <td class="table_td_subject">기준매익률</td>
                                <td class="table_td_contents">
                                    <input id="stan_buying_rate" name="stan_buying_rate" alt='persent' type="text" value="" size="5" maxlength="5" style="text-align: right;"
                                        onchange="javascript:fnSetChangeComponentData(this,event,'productMaster','org');" />%
                                    <!-- onblur="javascript:fnSetFormatCurrency(this);" -->
                                </td>
                                <td class="table_td_subject">절대판매가</td>
                                <td class="table_td_contents">
                                    <input id="stan_buying_money" name="stan_buying_money" alt='number' type="text" value="" size="20" maxlength="10" style="text-align: right;"
                                        onchange="javascript:fnSetChangeComponentData(this,event,'productMaster','org');" onfocus="javascript:fnSetFormatCurrency(this);" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="javaScript:return onlyNumber(event);"/>
                                    <!-- onblur="javascript:fnSetFormatCurrency(this);" onkeydown="javaScript:return onlyNumber(event);" -->
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject9">물량배분여부</td>
                                <td class="table_td_contents">
                                    <select id="isdistribute" name="isdistribute" class="select" onchange="javascript:fnSetChangeComponentData(this,event,'productMaster','org');">
                                    </select>
                                </td>
                                <td class="table_td_subject9">과거상품주문</td>
                                <td class="table_td_contents">
                                    <select id="isdisppastgood" name="isdisppastgood" class="select" onchange="javascript:fnSetChangeComponentData(this,event,'productMaster','org');">
                                        <option value="0">아니오</option>
                                        <option value="1">예</option>
                                    </select>
                                </td>
                                <td class="table_td_subject9">상품담당자</td>
                                <td class="table_td_contents">
                                    <select id="product_manager" name="product_manager" class="select" onchange="javascript:fnSetChangeComponentData(this,event,'productMaster','org');">
                                        <option value="">선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td colspan="6" class="table_top_line"></td>
                            </tr>
                        </table>
                        <!-- 상품기본정보 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <!-- 타이틀 시작 -->
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                            <tr>
                                <td width="20" valign="top">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                                </td>
                                <td class="stitle">상품 공급업체 정보</td>
                                <td align="right" class="stitle">
                                    <!-- btnAdd -->
<!--                                     <input id="btnProdVendorCopy" type="button" value="공급사정보복사" style="cursor: pointer;" /> -->
<!--                                     <input id="btnProdVendorAdd" type="button" value="공급사정보추가" style="cursor: pointer;" /> -->
<!--                                     <input id="btnProdVendorDel" type="button" value="공급사삭제" style="cursor: pointer;" /> -->
                                    
                                    <!-- 공급사정보복사 -->
                                    <img id="btnProdVendorCopy" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_provideCopy.gif" width="112" height="22" style='border: 0; cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
                                    <!-- 공급사정보추가  -->
                                    <img id="btnProdVendorAdd" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_provideAdd.gif" width="112" height="22" style='border: 0; cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
                                    <!-- 공급사삭제 종료요청으로 데처 -->
                                    <img id="btnProdVendorDel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_provideDelete.gif" width="112" height="22" style='border: 0; cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
                                    <img id="btnVendorExcel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
                                </td>
                            </tr>
                        </table>
                        <!-- 타이틀 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="jqgrid">
                            <table id="prodVendor"></table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <!-- 타이틀 시작 -->
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                            <tr>
                                <td width="20" valign="top">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                                </td>
                                <td class="stitle">공급업체 상품상세설명</td>
                                <td align="right" class="stitle">&nbsp;</td>
                            </tr>
                        </table>
                        <!-- 타이틀 시작 -->
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
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject9" width="100">공급사</td>
                                <td class="table_td_contents">
                                    <input id="vendornm" name="vendornm" type="text" value="" size="" maxlength="50" style="width: 120px; background-color: #eaeaea;" disabled="disabled"
                                        onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" /> <input id="vendorid" name="vendorid" type="text" style="visibility: hidden; width: 0px;" value=""
                                        onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" />
                                    <img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20; height: 18px; border: 0; cursor: pointer;" align="middle" class="icon_search" />
                                </td>
                                <td class="table_td_subject" width="100">공급사코드</td>
                                <td class="table_td_contents">
                                    <input id="vendorcd" name="vendorcd" type="text" value="" style="background-color: #eaeaea;" maxlength="20" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" disabled="disabled" />
                                </td>
                                <td class="table_td_subject" width="110">소재지</td>
                                <td class="table_td_contents" width="150">
                                    <select id="areatype" name="areatype" class="select" style="background-color: #eaeaea;" disabled="disabled" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');">
                                        <option value="">선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">대표자</td>
                                <td class="table_td_contents">
                                    <input id="pressentnm" name="pressentnm" type="text" value="" style="background-color: #eaeaea;" maxlength="50" disabled="disabled" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" />
                                </td>
                                <td class="table_td_subject">연락처</td>
                                <td class="table_td_contents">
                                    <input id="phonenum" name="phonenum" type="text" value="" style="background-color: #eaeaea;" maxlength="20" disabled="disabled" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" />
                                </td>
                                <td class="table_td_subject9">하도급대상여부</td>
                                <td class="table_td_contents">
                                    <select id="issub_ontract" name="issub_ontract" class="select" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');">
                                        <option value="0">아니오</option>
                                        <option value="1">예</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject9">매입단가</td>
                                <td class="table_td_contents">
                                    <input id="sale_unit_pric" name="sale_unit_pric" alt='number' type="text" value="" size="10" maxlength="10" style="text-align: right;" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                                    <img id="btnAlterPrice" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_priceChange.gif" width="62" height="18" style="cursor: pointer; display:none; vertical-align: middle;<%=CommonUtils.getVisibilityRoleButton(roleList, "COMM_SAVE")%>"/>
                                    <img id="btnSoldOut"    src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_discontinue.gif" width="62" height="18" style="cursor: pointer; display:none; vertical-align: middle;<%=CommonUtils.getVisibilityRoleButton(roleList, "COMM_SAVE")%>"/>
                                    <img id="btnChnUseSts"    src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_priceCancel.gif" width="62" height="18" style="cursor: pointer; display:none; vertical-align: middle;<%=CommonUtils.getVisibilityRoleButton(roleList, "COMM_SAVE")%>"/>
                                </td>
                                <td class="table_td_subject9">단위</td>
                                <td class="table_td_contents">
                                    <select id="orde_clas_code" name="orde_clas_code" class="select" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');">
                                        <option value="">선택</option>
                                    </select>
                                </td>
                                <td class="table_td_subject9">최소주문수량</td>
                                <td class="table_td_contents">
                                    <input id="deli_mini_quan" name="deli_mini_quan" alt='number' type="text" value="" size="5" maxlength="4" style="text-align: right;" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');"
                                        onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">상품규격</td>
                                <td colspan="3">
                                    규격: <input id="good_spec_desc1" name="good_spec_desc1" type="text" value="" size="25" maxlength="40" style="text-align: right;" onchange="javascript:fnSetChangeGoodSpecDesc();"/>
                                    Ø: <input id="good_st_spec_desc1" name="good_st_spec_desc1" type="text" value="" size="7" maxlength="40" style="text-align: right;" onchange="javascript:fnSetChangeGoodStSpecDesc();"/>
                                    W: <input id="good_st_spec_desc2" name="good_st_spec_desc2" type="text" value="" size="7" maxlength="40" style="text-align: right;" onchange="javascript:fnSetChangeGoodStSpecDesc();"/>
                                    D: <input id="good_st_spec_desc3" name="good_st_spec_desc3" type="text" value="" size="7" maxlength="40" style="text-align: right;" onchange="javascript:fnSetChangeGoodStSpecDesc();"/>
                                    H: <input id="good_st_spec_desc4" name="good_st_spec_desc4" type="text" value="" size="7" maxlength="40" style="text-align: right;" onchange="javascript:fnSetChangeGoodStSpecDesc();"/>
                                    L: <input id="good_st_spec_desc5" name="good_st_spec_desc5" type="text" value="" size="7" maxlength="40" style="text-align: right;" onchange="javascript:fnSetChangeGoodStSpecDesc();"/>
                                    t: <input id="good_st_spec_desc6" name="good_st_spec_desc6" type="text" value="" size="7" maxlength="40" style="text-align: right;" onchange="javascript:fnSetChangeGoodStSpecDesc();"/>
                                    <br/>
                                    M(미터): <input id="good_spec_desc8" name="good_spec_desc8" type="text" value="" size="7" maxlength="20" style="text-align: right;" onchange="javascript:fnSetChangeGoodSpecDesc();"/>
                                    재질: <input id="good_spec_desc2" name="good_spec_desc2" type="text" value="" size="7" maxlength="20" style="text-align: right;" onchange="javascript:fnSetChangeGoodSpecDesc();"/> 
                                    크기: <input id="good_spec_desc3" name="good_spec_desc3" type="text" value="" size="7" maxlength="20" style="text-align: right;" onchange="javascript:fnSetChangeGoodSpecDesc();"/> 
                                    총중량(할증포함): <input id="good_spec_desc4" name="good_spec_desc4" type="text" value="" size="7" maxlength="20" style="text-align: right;" onchange="javascript:fnSetChangeGoodSpecDesc();"/> 
                                    색상: <input id="good_spec_desc5" name="good_spec_desc5" type="text" value="" size="7" maxlength="20" style="text-align: right;" onchange="javascript:fnSetChangeGoodSpecDesc();"/> 
                                    TYPE: <input id="good_spec_desc6" name="good_spec_desc6" type="text" value="" size="7" maxlength="20" style="text-align: right;" onchange="javascript:fnSetChangeGoodSpecDesc();"/> 
                                    실중량kg: <input id="good_spec_desc7" name="good_spec_desc7" type="text" value="" size="7" maxlength="20" style="text-align: right;" onchange="javascript:fnSetChangeGoodSpecDesc();"/>
                                </td>
<!--                                 <td class="table_td_subject9">납품소요일</td> -->
<!--                                 <td class="table_td_contents"> -->
<!--                                     <input id="deli_mini_day" name="deli_mini_day" alt='number' type="text" value="" size="4" maxlength="2" style="text-align: right;" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" -->
<!--                                         onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />일 -->
<!--                                 </td> -->
                                <td class="table_td_subject9">상품실적년도</td>
                                <td class="table_td_contents">
                                    <select class="select" id="good_reg_year" name="good_reg_year" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');">
                                        <option value="">선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td colspan="6" height="0"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject9">납품소요일</td>
                                <td class="table_td_contents">
                                    <input id="deli_mini_day" name="deli_mini_day" alt='number' type="text" value="" size="4" maxlength="2" style="text-align: right;" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');"
                                        onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />일
                                </td>
                                <td class="table_td_subject9">상품구분</td>
                                <td class="table_td_contents">
                                    <select id="good_clas_code" name="good_clas_code" class="select" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');fnSetEnableInventoryComponent();">
                                    </select>
                                </td>
                                <td class="table_td_subject">재고수량</td>
                                <td class="table_td_contents">
                                    <input id="good_inventory_cnt" name="good_inventory_cnt" alt='number' type="text" value="" size="5" maxlength="5" style="text-align: right;"
                                        onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                
                                <td class="table_td_subject">제조사</td>
                                <td class="table_td_contents">
                                    <input id="make_comp_name" name="make_comp_name" type="text" value="" size="" maxlength="50" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" />
                                </td>
                                <td class="table_td_subject" rowspan="5" >대표상품이미지</td>
                                <td colspan="3" class="table_td_contents4" rowspan="5">
                                    <table>
                                        <tr>
                                            <td valign="bottom">
                                                SMALL<br />
                                                <img id="SMALL" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border: 0px;" />
                                            </td>
                                            <td valign="bottom">
                                                MEDIUM<br />
                                                <img id="MEDIUM" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_70.gif" alt="MEDIUM" style="border: 0px;" />
                                            </td>
                                            <td valign="bottom">
                                                LARGE<br />
                                                <img id="LARGE" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_100.gif" alt="LARGE" style="border: 0px;" />

                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject" height="27px">물량배분 %</td>
                                <td class="table_td_contents" >
                                    <input id="distri_rate" name="distri_rate" alt='number' type="text" value="" size="5" maxlength="2" style="text-align: right;" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />%
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">상품이미지</td>
                                <td class="table_td_contents">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td height="25">
                                                <input id="original_img_path" name="original_img_path" type="text" value="" style="background-color: #eaeaea;" disabled="disabled"
                                                    onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" /> <input id="large_img_path" name="large_img_path" type="text" style="display: none;" value=""
                                                    onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" /> <input id="middle_img_path" name="middle_img_path" type="text" style="display: none;" value=""
                                                    onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" /> <input id="small_img_path" name="small_img_path" type="text" style="display: none;" value=""
                                                    onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" height="25">
                                                <img id="btnAttach" name="btnAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageOK.gif" style="width: 75px; height: 18px; cursor: pointer;" />
                                                <img id="btnAttachDel" name="btnAttachDel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageDelete.gif" style="width: 75px; height: 18px; cursor: pointer;" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">상품설명</td>
                                <td colspan="5" height="10" class="table_td_contents4">
                                    <%@ include file="/daumeditor/editorbox.jsp"%>
                                    <!--                        <textarea id="tx_load_content" cols="20" rows="10" style="display: none;"></textarea> -->
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td class="table_td_subject">상품 동의어</td>
                                <!-- good_same_word -->
                                <td colspan="5" class="table_td_contents">
                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td>
                                                <input id="good_same_word1" name="good_same_word1" type="text" value="" size="20" maxlength="20" style="width: 95%;" onchange="javascript:fnSetChangeSameWord();" />
                                            </td>
                                            <td>
                                                <input id="good_same_word2" name="good_same_word2" type="text" value="" size="20" maxlength="20" style="width: 95%;" onchange="javascript:fnSetChangeSameWord();" />
                                            </td>
                                            <td>
                                                <input id="good_same_word3" name="good_same_word3" type="text" value="" size="20" maxlength="20" style="width: 95%;" onchange="javascript:fnSetChangeSameWord();" />
                                            </td>
                                            <td>
                                                <input id="good_same_word4" name="good_same_word4" type="text" value="" size="20" maxlength="20" style="width: 95%;" onchange="javascript:fnSetChangeSameWord();" />
                                            </td>
                                            <td>
                                                <input id="good_same_word5" name="good_same_word5" type="text" value="" size="20" maxlength="20" style="width: 95%;" onchange="javascript:fnSetChangeSameWord();" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="6" height="1" bgcolor="eaeaea"></td>
                            </tr>
                            <tr>
                                <td colspan="6" class="table_top_line"></td>
                            </tr>
                            <tr>
                                <td height="8px" colspan="6"></td>
                            </tr>
                            <tr>
                                <td colspan="6">
                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">

                                        <tr>
                                            <td align="center" class="stitle" style="text-align: center;">
                                                <!-- 공급사정보추가  -->
                                                <img id="btnProdMstSave" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_masterSave.gif" width="125" height="23" style='border: 0; cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
<%--                                                 <img id="btnCommonClose" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style="width:65px;height:23px;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />   <!-- 닫기 --> --%>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <!-- 컨텐츠 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <!-- 타이틀 시작 -->
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                            <tr>
                                <td width="20" valign="top">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                                </td>
                                <td class="stitle">현 판가정보</td>
                                <td align="right" class="stitle">
                                    <img id='btnDispAdd' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style="cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" />
<%--                                     <img id='btnDispModify' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style="cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" /> --%>
<%--                                     <img id='btnDispTrash' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style="cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" /> --%>
                                    <!-- btnAdd -->
                                    <img id="btnDispExcel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
                                </td>
                            </tr>
                        </table>
                        <!-- 타이틀 끝 -->
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="jqgrid">
                            <table id="prodDisplay">
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
            </table>
            <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
                <p></p>
            </div>
<!--             <div id="dialog" title="Feature not supported" style="display: inline;"> -->
            <div id="dialog" title="Feature not supported" style="display: none; font-size: 12px;">
                <p></p>
            </div>
            <textarea id="tx_load_content" cols="20" rows="2" style="display: none;"></textarea>
            
                       
        </form>
    </div>
    
    <div id="divReqChangePrice" style="display:none;"> <!--  position:absolute; top:0px; left:0px;z-index: 999; -->
        <table width="450" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="20" height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" />
                            </td>
                            <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif);" >&nbsp;</td>
                            <td width="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif);"   >&nbsp;</td>
                            <td bgcolor="#FFFFFF">
                                <table width="100%" cellpadding="0" cellspacing="0" style="height: 27px; border: 0;">
                                    <tr>
                                        <td width="20" valign="top">
                                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/>
                                        </td>
                                        <td class="stitle">단가 변경 요청</td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="2" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height='1'></td>
                                    </tr>
                                    <tr>
                                        <td width="90" class="table_td_subject">기존 매입단가</td>
                                        <td class="table_td_contents">
                                            <input id="org_sale_unit_pric" name="org_sale_unit_pric" alt='number' type="text" value="" size="7" maxlength="18" disabled="disabled" style="text-align: right;background-color: #eaeaea;" onblur="javascript:fnSetFormatCurrency(this);" /> </br>
                                        </td>
                                    </tr>
                                    <tr style="height: 1px" >
                                        <td></td>
                                        <td bgcolor="#EAEAEA"></td>
                                    </tr>
                                    <tr>
                                        <td width="70" class="table_td_subject">변경 매입단가</td>
                                        <td class="table_td_contents">
                                            <input id="price" name="price" alt='number' type="text" value="" size="10" maxlength="8" style="text-align: right;" onchange="javascript:fnSetChangeComponentData(this,event,'prodVendor','org');" onblur="javascript:fnSetFormatCurrency(this);" onkeydown="return onlyNumber(event);" />
                                        </td>
                                    </tr>
                                    <tr style="height: 1px" >
                                        <td></td>
                                        <td bgcolor="#EAEAEA"></td>
                                    </tr>
                                    <tr>
                                        <td width="70" class="table_td_subject">변경 사유</td>
                                        <td class="table_td_contents">
                                            <input id="apply_desc" name="apply_desc" type="text" style="width: 250px; width: 98%;" maxlength="100"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height="2" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/table_bottom_line.gif);"  ></td>
                                    </tr>
                                </table>
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' class="space" />
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="center">
                                            <img id="btnReqestChangePrice" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_request.gif" width="65" height="22" border="0" style="cursor: pointer;"/>
                                            <img id="btnCloseChangePrice" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_cancel2.gif" width="65" height="22" border="0" style="cursor: pointer;" onclick="javascript: $('#divReqChangePrice').attr('style', 'display:none;');"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif);" >&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/>
                            </td>
                            <td style="background-image:url( <%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif);" >&nbsp;</td>
                            <td height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div> 
    <div id="divSoldOut" style="position:relative; top:250px; left:300px;z-index: 100;display: none;">
        <table width="450" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="20" height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/>
                            </td>
                            <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif);" >&nbsp;</td>
                            <td width="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif);"   >&nbsp;</td>
                            <td bgcolor="#FFFFFF">
                                <table width="100%" height="27" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="20" valign="top">
                                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle"/>
                                        </td>
                                        <td class="stitle">종료 요청</td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="2" class="table_top_line"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height='1'></td>
                                    </tr>
                                    <tr>
                                        <td width="90" class="table_td_subject">종료 요청사유</td>
                                        <td class="table_td_contents">
                                            <input id="sold_out_desc" name="sold_out_desc" type="text" style="width: 250px; width: 98%;" maxlength="100"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" height="2" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/table_bottom_line.gif);"  ></td>
                                    </tr>
                                </table>
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' class="space"/>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="center">
                                            <img id="btnReqSoldOut" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_request.gif" width="65" height="22" border="0" style="cursor: pointer;"/>
                                            <img id="btnCloseSoldOut" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_cancel2.gif" width="65" height="22" border="0" style="cursor: pointer;" onclick="javascript: $('#divSoldOut').attr('style', 'display:none;');"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif);" >&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/>
                            </td>
                            <td style="background-image:url( <%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif);" >&nbsp;</td>
                            <td height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>

</body>
</html>