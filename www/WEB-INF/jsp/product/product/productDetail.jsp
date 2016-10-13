<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.product.dto.ProductDto" %>
<%@ page import="java.util.List" %>

<%
   //그리드의 width와 Height을 정의
   int listHeight = 90;
   String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

   @SuppressWarnings("unchecked")
   //화면권한가져오기(필수)
   List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
   //사용자 정보
   LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
   
   ProductDto detailInfo = null;
   String good_Iden_Numb = "";
   String good_Name = "";
   String vtax_Clas_Code = "";
   String sale_Criterion_Type = "";
   String stan_Buying_Rate = "";
   String stan_Buying_Money = "";
   String isDistribute = "";
   String isDispPastGood = "";
   String cate_Id = "";
   String full_Cate_Name = "";
   String deliAreaCdArrayString = "";
   
   detailInfo = (ProductDto)request.getAttribute("detailInfo");
   if(detailInfo != null) {
      good_Iden_Numb = detailInfo.getGood_Iden_Numb();
      good_Name = detailInfo.getGood_Name();
      vtax_Clas_Code = detailInfo.getVtax_Clas_Code();
      sale_Criterion_Type = detailInfo.getSale_Criterion_Type();
      stan_Buying_Rate = detailInfo.getStan_Buying_Rate();
      stan_Buying_Money = detailInfo.getStan_Buying_Money();
      isDistribute = detailInfo.getIsDistribute();
      isDispPastGood = detailInfo.getIsDispPastGood();
      cate_Id = detailInfo.getCate_Id();
      full_Cate_Name = detailInfo.getFull_Cate_Name();
   }
   
   @SuppressWarnings("unchecked")   //권역코드 리스트
   List<CodesDto> deliAreaCodeList = (List<CodesDto>)request.getAttribute("deliAreaCodeList");
   for(CodesDto codesDto : deliAreaCodeList) {
      if("".equals(deliAreaCdArrayString)) deliAreaCdArrayString = codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
      else deliAreaCdArrayString +=  ";" + codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
   }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>

<!-- file Upload 스크립트 -->
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
         $('#textOriginalImgPath').val(result.ORGIN);
         $('#textLargeImgPath').val(result.LARGE);
         $('#textMiddleImgPath').val(result.MEDIUM);
         $('#textSmallImgPath').val(result.SMALL);
      }
   });
});
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
   $.post(  //권역세팅
      '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
      {codeTypeCd:"DELI_AREA_CODE", isUse:"1"},
      function(arg){
         var codeList = eval('(' + arg + ')').codeList;
         for(var i=0;i<codeList.length;i++) {
            $("#selectAreaType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
         }
      }
   );
   $.post(  //단위세팅
      '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
      {codeTypeCd:"ORDERUNIT", isUse:"1"},
      function(arg){
         var codeList = eval('(' + arg + ')').codeList;
         for(var i=0;i<codeList.length;i++) {
            $("#selectOrdeClasCode").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
         }
      }
   );
   $.post(  //주문상품유형
      '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
      {codeTypeCd:"ORDERGOODSTYPE", isUse:"1"},
      function(arg){
         var codeList = eval('(' + arg + ')').codeList;
         for(var i=0;i<codeList.length;i++) {
            $("#selectGoodClasCode").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
         }
      }
   );
   $('#btnSearchCategory').click( function() { fnSearchCategory(); });
   $("#textMajoCodeName").keydown(function(e) { if(e.keyCode==13) { $("#btnSearchCategory").click(); } });
   $("#saveButton").click( function() { saveRow(); });
   $("#regButton2").click( function() { addRow2(); });
   $("#delButton2").click( function() { deleteRow2(); });
   $("#saveButton3").click( function() { saveRow3(); });
   $("#btnVendor").click(function() { fnSearchVendor(); });
   $("#textVendorNm").keydown(function(e) { if(e.keyCode==13) { $("#btnVendor").click(); } });
   $("#textVendorNm").change(function(e){ fnInitGoodVendor(); });
   $("#btnAttachDel").click( function() { attachDel(); });
   $("#regButton4").click( function() { transRow4("add"); });
   $("#modButton4").click( function() { transRow4("edit"); });
});
$(window).bind('resize', function() {
   $("#list").setGridWidth(<%=listWidth %>);
   $("#list2").setGridWidth(<%=listWidth %>);
   $("#list3").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
   jq("#list").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/category/categoryInfoListJQGrid.sys',
      datatype:'json',
      mtype:'POST',
      colNames:['진열카테고리명','진열조직','사용여부'],
      colModel:[
         {name:'cate_Disp_Name',index:'cate_Disp_Name',width:350,align:'left',search:false,sortable:true,
            editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
            editoptions:{size:'20',maxLength:'30'}
         },//진열명
         {name:'borgNms',index:'borgNms',width:400,align:"left",search:false,sortable:true,editable:false },//진열조직
         {name:'is_Disp_Use',index:'is_Disp_Use',width:150,align:'center',search:false,sortable:false,
            editable:true,formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
            edittype:'select',formatter:'select',editoptions:{value:"1:사용;0:미사용"}
         }//사용여부
      ],
      postData: {
         srcCateId:'<%=cate_Id %>'
      },
      rowNum:4,rownumbers:false,rowList:[10,20,30],pager:'#pager',
      height:<%=listHeight %>,autowidth:true,
      sortname:'borgNms',sortorder:'asc',
      caption:"상품진열정보", 
      viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete:function() {},
      onSelectRow:function(rowid,iRow,iCol,e) {},
      ondblClickRow:function(rowid,iRow,iCol,e) {},
      onCellSelect:function(rowid,iCol,cellcontent,target) {},
      loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
      jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
   });
   jq("#list2").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/goodVendorListJQGrid.sys',
      datatype:'json',
      mtype:'POST',
      colNames:['공급업체명','권역','등록일','매입단가','대표자','연락처','대표이미지등록여부','상세설명등록여부','상품코드','공급업체코드'],
      colModel:[
         {name:'vendorNm',index:'vendorNm',width:180,align:'left',search:false,sortable:true,editable:false },//공급업체명
         {name:'areaType',index:'areaType',width:60,align:'center',search:false,sortable:true
            ,editable:false,formatter:"select",editoptions:{value:"<%=deliAreaCdArrayString %>"}
         },//권역
         {name:'regist_Date',index:'regist_Date',width:80,align:'center',search:false,sortable:true,editable:false,formatter:"date" },//등록일
         {name:'sale_Unit_Pric',index:'sale_Unit_Pric',width:80,align:'right',search:false,sortable:false
            ,editable:false,formatter:'currency',formatoptions:{decimalSeparator:'.',thousandsSeparator:',',decimalPlaces:0,prefix:''}
         },//매입단가
         {name:'pressentNm',index:'pressentNm',width:80,align:'center',search:false,sortable:true,editable:false },//대표자
         {name:'phoneNum',index:'phoneNum',width:80,align:'center',search:false,sortable:false,editable:false },//연락처
         {name:'isSetImage',index:'isSetImage',width:100,align:'center',search:false,sortable:false,editable:false },//대표이미지여부
         {name:'isSetDesc',index:'isSetDesc',width:100,align:'center',search:false,sortable:false,editable:false },//상품설명여부
         
         {name:'good_Iden_Numb',index:'good_Iden_Numb',hidden:true,search:false,sortable:false },
         {name:'vendorId',index:'vendorId',hidden:true,search:false,sortable:false,key:true }
      ],
      postData: {
         srcGoodIdenNumb:$('#textGoodIdenNumb').val()
      },
      rowNum:4,rownumbers:false,rowList:[10,20,30],pager:'#pager2',
      height:<%=listHeight%>,autowidth:true,
      sortname:'regist_Date',sortorder:'desc',
      caption:"상품 공급업체 정보",
      viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete:function() {
         var top_rowid = $("#list2").getDataIDs()[0];
         $("#list2").setSelection(top_rowid);
      },
      onSelectRow:function(rowid,iRow,iCol,e) {
         var row = jq("#list2").jqGrid('getGridParam','selrow');
         var selrowContent = jq("#list2").jqGrid('getRowData',row);
         var vendorId = selrowContent.vendorId;
         var goodIdenNumb = selrowContent.good_Iden_Numb;
         if(row != null) {
            if( vendorId != "" ) {
               fnGoodVendorInfo(vendorId,goodIdenNumb);
            } else {
               fnInitGoodVendor();
               fnInitGoodVendor2();
            }
         }
      },
      ondblClickRow:function(rowid,iRow,iCol,e) {},
      onCellSelect:function(rowid,iCol,cellcontent,target) {},
      loadError:function(xhr,st,str) { $("#list2").html(xhr.responseText); },
      jsonReader: { root:"list2",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
   });
   jq("#list3").jqGrid({
      url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/displayGoodListJQGrid.sys',
      datatype:'json',
      mtype:'POST',
      colNames:['진열조직','고객사상품코드','판매단가','계약시작일','계약종료일','진열상태','고객사상품코드','그룹Id','법인Id','사업장Id','상위진열SEQ','과거상품판매여부','공급사Id','상품명','진열SEQ'],
      colModel:[
         {name:'borgNms',index:'borgNms',width:330,align:"left",search:false,sortable:true,editable:false },//진열조직
         {name:'good_Iden_Numb',index:'good_Iden_Numb',width:100,align:"center",search:false,sortable:true,editable:false },//고객사상품코드
         {name:'sell_Price',index:'sell_Price',width:90,align:"right",search:false,sortable:false,
            editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },//판매단가   
         {name:'cont_From_Date',index:'cont_From_Date',width:90,align:"center",search:false,sortable:true,editable:false },//계약시작일
         {name:'cont_To_Date',index:'cont_To_Date',width:90,align:"center",search:false,sortable:true,editable:false },//계약종료일
         {name:'final_Good_Sts',index:'final_Good_Sts',width:90,align:'center',search:false,sortable:false,
            editable:true,formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
            edittype:'select',formatter:'select',editoptions:{value:"1:최종상품;0:이전상품"}
         },//진열상태
         {name:'cust_Good_Iden_Numb',index:'cust_Good_Iden_Numb',width:100,align:"left",search:false,sortable:false,editable:false },//고객사상품코드
         
         {name:'groupId',index:'groupId',hidden:true,search:false },//그룹ID
         {name:'clientId',index:'clientId',hidden:true,search:false },//법인ID
         {name:'branchId',index:'branchId',hidden:true,search:false },//사업장ID
         {name:'ref_Good_Seq',index:'ref_Good_Seq',hidden:true,search:false },//상위진열SEQ
         {name:'ispast_Sell_Flag',index:'ispast_Sell_Flag',hidden:true,search:false },//과거상품판매여부
         {name:'vendorId',index:'vendorId',hidden:true,search:false },//공급사ID
         {name:'good_Name',index:'good_Name',hidden:true,search:false },//상품명
         {name:'disp_Good_Id',index:'cate_Id',hidden:true,search:false,sortable:true,key:true }//진열SEQ
      ],
      postData: {
         goodIdenNumb:$('#textGoodIdenNumb').val()
      },
      rowNum:4,rownumbers:false,rowList:[10,20,30],pager:'#pager3',
      height:<%=listHeight%>,autowidth:true,
      sortname:'disp_Good_Id',sortorder:'desc',
      caption:"현 판가정보", 
      viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete:function() {},
      onSelectRow:function(rowid,iRow,iCol,e) {},
      ondblClickRow:function(rowid,iRow,iCol,e) {
         fnProductSalePriceHistDiv();
      },
      onCellSelect:function(rowid,iCol,cellcontent,target) {},
      loadError:function(xhr,st,str) { $("#list3").html(xhr.responseText); },
      jsonReader: { root:"list3",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
   });
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearchCategory() {
   fnSearchStandardCategoryInfo("3", "fnCallBackStandardCategoryChoice");
}
function fnCallBackStandardCategoryChoice(categortId, categortName, categortFullName) {
   var msg = ""; 
   msg += "\n categortId value ["+categortId+"]"; 
   msg += "\n categortName value ["+categortName+"]";
   msg += "\n categortFullName value ["+categortFullName+"]";
   //alert(msg);
   $('#textCateId').val(categortId);
   $('#textMajoCodeName').val(categortFullName);
   
   //상품진열정보 조회
   var data = jq("#list").jqGrid("getGridParam", "postData");
   data.srcCateId = categortId;
   jq("#list").jqGrid("setGridParam", { "postData": data });
   jq("#list").trigger("reloadGrid");
   
   //컴포넌트 초기화
   fnInitGood();
   jq("#list2").clearGridData();
   fnInitGoodVendor();
   fnInitGoodVendor2();
   jq("#list3").clearGridData();
}
function fnInitGood() {
   $('#textGoodIdenNumb').val("");
   $('#textGoodName').val("");
   $('#textGoodName').focus();
   $('#selectVtaxClasCode').val("");
   $('input:radio[name=radioSaleCriterionType]').filter('input:radio[value=10]').attr('checked', 'checked');
   $('#textStanBuyingRate').attr("disabled",false);
   $('#textStanBuyingMoney').attr("disabled",true);
   $('#textStanBuyingRate').val("");
   $('#textStanBuyingMoney').val("0");
   $('#selectIsDistribute').val("");
   $('#selectIsDisppastGood').val("");
}
function fnInitGoodVendor() {
   $('#textVendorNm').val("");
   $('#textVendorId').val("");
   //$('#textVendorNm').attr("disabled",true);
   $('#btnVendor').attr("disabled",true);
   $('#textVendorCd').val("");
   $('#selectAreaType').val("");
   $('#textPressentNm').val("");
   $('#textPhoneNum').val("");
}
function fnInitGoodVendor2() {
   $('#selectIssubOntract').val("");
   $('#textSaleUnitPric').val("");
   $('#selectOrdeClasCode').val("");
   $('#textDeliMiniQuan').val("");
   $('#textGoodSpecDesc1').val("");
   $('#textGoodSpecDesc2').val("");
   $('#textGoodSpecDesc3').val("");
   $('#textGoodSpecDesc4').val("");
   $('#textGoodSpecDesc5').val("");
   $('#textGoodSpecDesc6').val("");
   $('#textGoodSpecDesc7').val("");
   $('#textDeliMiniDay').val("");
   $('#textMakeCompName').val("");
   $('#selectGoodClasCode').val("");
   $('#textGoodInventoryCnt').val("");
   $('#textOriginalImgPath').val("");
   $('#textLargeImgPath').val("");
   $('#textMiddleImgPath').val("");
   $('#textSmallImgPath').val("");
   $('#SMALL').attr('src','/img/system/imageResize/prod_img_50.gif');
   $('#MEDIUM').attr('src','/img/system/imageResize/prod_img_70.gif');
   $('#LARGE').attr('src','/img/system/imageResize/prod_img_100.gif');
   $('#tx_load_content').val("");
   $('#textGoodSameWord1').val("");
   $('#textGoodSameWord2').val("");
   $('#textGoodSameWord3').val("");
   $('#textGoodSameWord4').val("");
   $('#textGoodSameWord5').val("");
}

function change(rad) {
   var StanBuyingRate = $('#textStanBuyingRate');
   var StanBuyingMoney = $('#textStanBuyingMoney');
   if(rad.value=='10') {   //기준매익률
      StanBuyingRate.attr("disabled",false);
      StanBuyingMoney.attr("disabled",true);
      StanBuyingRate.val('');
      StanBuyingMoney.val('0');
      StanBuyingRate.focus();
   } else if(rad.value=='20') {  //절대매입가
      StanBuyingRate.attr("disabled",true);
      StanBuyingMoney.attr("disabled",false);
      StanBuyingRate.val('0');
      StanBuyingMoney.val('');
      StanBuyingMoney.focus();
   }
}

function saveRow() {
   var textMajoCodeName = $('#textMajoCodeName');
   var textCateId = $('#textCateId');
   var textGoodIdenNumb = $('#textGoodIdenNumb');
   var textGoodName = $('#textGoodName');
   var indexVtaxClasCode = $("#selectVtaxClasCode option").index($("#selectVtaxClasCode option:selected"));
   var selectVtaxClasCode = $("#selectVtaxClasCode option:selected");
   var radioSaleCriterionType = $(':radio[name="radioSaleCriterionType"]:checked');
   var textStanBuyingRate = $("#textStanBuyingRate");
   var textStanBuyingMoney = $("#textStanBuyingMoney");
   var indexIsDistribute = $("#selectIsDistribute option").index($("#selectIsDistribute option:selected"));
   var selectIsDistribute = $("#selectIsDistribute option:selected");
   var indexIsDisppastGood = $("#selectIsDisppastGood option").index($("#selectIsDisppastGood option:selected"));
   var selectIsDisppastGood = $("#selectIsDisppastGood option:selected");
   
   if(textCateId.val() == "") {
      alert("상품카테고리를 선택해 주십시오.");
      textMajoCodeName.focus().select();
      return;
   }
   if(textGoodName.val() == "") {
      alert("상품명을 입력해 주십시오.");
      textGoodName.focus();
      return;
   }
   if(indexVtaxClasCode == 0){
      alert("과세구분을 선택해 주십시오.");
      return;
   }
   if(radioSaleCriterionType.val() == undefined){
      alert("판매가산출옵션을 선택해 주십시오.");
      return;
   } else {
      if(radioSaleCriterionType.val() =="10" && $.number(textStanBuyingRate.val()) > 100) {
         alert("기준매익률이 100보다 큽니다.\n재입력해 주십시오.");
         textStanBuyingRate.focus();
         return;
//       } else if(radioSaleCriterionType.val() =="10" && (textStanBuyingRate.val().split(".")[1]).length > 2)) {
//          alert("기준매익률은 소수점 2자리까지 입력해 주십시오.");
//          textStanBuyingRate.focus();
//          return;
      } else if((radioSaleCriterionType.val() =="10" && textStanBuyingRate.val() == "")) {
         alert("기준매익률을 입력해 주십시오.");
         textStanBuyingRate.focus();
         return;
      } else if(radioSaleCriterionType.val() =="20" && textStanBuyingMoney.val() == "") {
         alert("절대매입가를 입력해 주십시오.");
         textStanBuyingMoney.focus();
         return;
      }
   }
   if(indexIsDistribute == 0){
      alert("물량배분여부를 선택해 주십시오.");
      return;
   }
   if(indexIsDisppastGood == 0){
      alert("상품진열여부를 선택해 주십시오.");
      return;
   }

   if(textGoodIdenNumb.val() == "") {
      if(!confirm("입력한 상품기본정보을 저장하겠습니까?")) return;
   } else {
      if(!confirm("입력한 상품기본정보을 수정하겠습니까?")) return;
   }
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/goodTrans.sys"
      , { good_Iden_Numb:textGoodIdenNumb.val(),good_Name:textGoodName.val(),vtax_Clas_Code:selectVtaxClasCode.val(),sale_Criterion_Type:radioSaleCriterionType.val(),
         stan_Buying_Rate:textStanBuyingRate.val(),stan_Buying_Money:textStanBuyingMoney.val().replace(/,/g,''),isDistribute:selectIsDistribute.val(),
         isDisppastGood:selectIsDisppastGood.val(),cate_Id:textCateId.val() }
      , function(arg) {
         if(fnAjaxTransResult(arg)) {  //성공시
            var msg = eval('(' + arg + ')').msg;
            var good_Iden_Numb = eval('(' + arg + ')').good_Iden_Numb;
            $("#textGoodIdenNumb").val(good_Iden_Numb);
            $("#btnSearchCategory").attr("disabled",true);
            alert(msg);
         }
      }
   );
}

function fnGoodVendorInfo(vendorId, goodIdenNumb) {
   fnInitGoodVendor();
   fnInitGoodVendor2();
   fnGetGoodVendorInfo(vendorId, goodIdenNumb);
   
}
function fnGetGoodVendorInfo(vendorId, goodIdenNumb) {
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/goodVendorDetail.sys"
      , { srcVendorId:vendorId,srcGoodIdenNumb:goodIdenNumb }
      , function(arg) {
         var detailInfo = eval('(' + arg + ')').detailInfo;
         //$('#textVendorNm').attr("readonly",true);
         $('#textVendorNm').val(detailInfo.vendorNm);
         $('#textVendorId').val(detailInfo.vendorId);
         $('#textVendorCd').val(detailInfo.vendorCd);
         $('#selectAreaType').val(detailInfo.areaType);
         $('#textPressentNm').val(detailInfo.pressentNm);
         $('#textPhoneNum').val(detailInfo.phoneNum);
         $('#selectIssubOntract').val(detailInfo.issub_Ontract);
         $('#textSaleUnitPric').val(Number(detailInfo.sale_Unit_Pric));
         $('#selectOrdeClasCode').val(detailInfo.orde_Clas_Code);
         $('#textDeliMiniQuan').val(detailInfo.deli_Mini_Quan);
         $('#textGoodSpecDesc1').val(detailInfo.good_Spec_Desc.split(" ")[0]);
         $('#textGoodSpecDesc2').val(detailInfo.good_Spec_Desc.split(" ")[1]);
         $('#textGoodSpecDesc3').val(detailInfo.good_Spec_Desc.split(" ")[2]);
         $('#textGoodSpecDesc4').val(detailInfo.good_Spec_Desc.split(" ")[3]);
         $('#textGoodSpecDesc5').val(detailInfo.good_Spec_Desc.split(" ")[4]);
         $('#textGoodSpecDesc6').val(detailInfo.good_Spec_Desc.split(" ")[5]);
         $('#textGoodSpecDesc7').val(detailInfo.good_Spec_Desc.split(" ")[6]);
         $('#textDeliMiniDay').val(detailInfo.deli_Mini_Day);
         $('#textMakeCompName').val(detailInfo.make_Comp_Name);
         $('#selectGoodClasCode').val(detailInfo.good_Clas_Code);
         $('#textGoodInventoryCnt').val(Number(detailInfo.good_Inventory_Cnt));
         $('#textOriginalImgPath').val(detailInfo.original_Img_Path);
         if(detailInfo.small_Img_Path == "") {
            $('#SMALL').attr('src',"/img/system/imageResize/prod_img_50.gif");
         } else {
            $('#SMALL').attr('src',"<%=Constances.SYSTEM_IMAGE_PATH%>/"+detailInfo.small_Img_Path);
            $('#textSmallImgPath').val(detailInfo.small_Img_Path);
         }
         if(detailInfo.middle_Img_Path == "") {
            $('#MEDIUM').attr('src',"/img/system/imageResize/prod_img_70.gif");
         } else {
            $('#MEDIUM').attr('src',"<%=Constances.SYSTEM_IMAGE_PATH%>/"+detailInfo.middle_Img_Path);
            $('#textMiddleImgPath').val(detailInfo.middle_Img_Path);
         }
         if(detailInfo.large_Img_Path == "") {
            $('#LARGE').attr('src',"/img/system/imageResize/prod_img_100.gif");
         } else {
            $('#LARGE').attr('src',"<%=Constances.SYSTEM_IMAGE_PATH%>/"+detailInfo.large_Img_Path);
            $('#textLargeImgPath').val(detailInfo.large_Img_Path);
         }
         $('#tx_load_content').val((detailInfo.good_Desc).replaceAll("\r\n", "<BR>"));
         $('#textGoodSameWord1').val(detailInfo.good_Same_Word.split("‡")[0]);
         $('#textGoodSameWord2').val(detailInfo.good_Same_Word.split("‡")[1]);
         $('#textGoodSameWord3').val(detailInfo.good_Same_Word.split("‡")[2]);
         $('#textGoodSameWord4').val(detailInfo.good_Same_Word.split("‡")[3]);
         $('#textGoodSameWord5').val(detailInfo.good_Same_Word.split("‡")[4]);
         
         loadContent();
      }
   );
}

function addRow2() {
   if($("#textMajoCodeName").val() == "") {
      alert("상품카테고리를 먼저 선택해 주십시오.");
      $("#textMajoCodeName").focus();
      return;
   } else if($("#textGoodIdenNumb").val() == "") {
      alert("상품기본정보를 먼저 등록해 주십시오.");
      $("#textGoodName").focus();
      return;
   }
   jq("#list2").addRowData(
      $("#list2").jqGrid('getGridParam','records'),
      { vendorNm:"",areaType:"",regist_Date:"",sale_Unit_Pric:"",pressentNm:"",phoneNum:"",isSetImage:"",isSetDesc:"" }
   );
   var rowCount = jq("#list2").getGridParam("reccount");
   var last_rowid = $("#list2").getDataIDs()[rowCount-1];
   jq("#list2").setSelection(last_rowid);
   jq("#list2").attr("readonly",true);
   $("#regButton2").attr("disabled",true);
   //$("#textVendorNm").attr("disabled",false);
   $('#textVendorNm').attr("readonly",false);
   $("#btnVendor").attr("disabled",false);
   $('#textVendorNm').focus();
   list2SetColProp(false);
}
function list2SetColProp(flag) {
   jq("#list2").jqGrid('setColProp', 'vendorNm',{sortable:flag});
   jq("#list2").jqGrid('setColProp', 'areaType',{sortable:flag});
   jq("#list2").jqGrid('setColProp', 'regist_Date',{sortable:flag});
   jq("#list2").jqGrid('setColProp', 'sale_Unit_Pric',{sortable:flag});
   jq("#list2").jqGrid('setColProp', 'pressentNm',{sortable:flag});
   jq("#list2").jqGrid('setColProp', 'phoneNum',{sortable:flag});
   jq("#list2").jqGrid('setColProp', 'isSetImage',{sortable:flag});
   jq("#list2").jqGrid('setColProp', 'isSetDesc',{sortable:flag});
}

function deleteRow2() {
   var row = jq("#list2").jqGrid('getGridParam','selrow');
   var selrowContent = jq("#list2").jqGrid('getRowData',row);
   var vendorId = selrowContent.vendorId;
   if(row != null) {
      if(vendorId != "") {
         if(!confirm("선택한 정보을 삭제 하시겠습니까?")) return;
         var selrowContent = jq("#list2").jqGrid('getRowData',row);
         var vendorId = selrowContent.vendorId;
         var goodIdenNumb = selrowContent.good_Iden_Numb;
         $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/goodVendorTrans.sys"
            , { vendorId:vendorId,good_Iden_Numb:goodIdenNumb,oper:"del" }
            , function(arg) {
               if(fnAjaxTransResult(arg)) {  //성공시
                  jq("#list2").trigger("reloadGrid");
               }
            }
         );
      } else {
         if(!confirm("등록취소 하시겠습니까?")) return;
         $("#list2").delRowData(row, {});
         jq("#list2").attr("readonly",false);
         jq("#list2").trigger("reloadGrid");
         $("#regButton2").attr("disabled",false);
         //$("#textVendorNm").attr("disabled",true);
         $('#textVendorNm').attr("readonly",true);
         $("#btnVendor").attr("disabled",true);
         list2SetColProp(true);
      }
   } else { jq( "#dialogSelectRow" ).dialog(); }
}

function attachDel() {
   // 이미지 변경
   $('#SMALL').attr('src','/img/system/imageResize/prod_img_50.gif');
   $('#MEDIUM').attr('src','/img/system/imageResize/prod_img_70.gif');
   $('#LARGE').attr('src','/img/system/imageResize/prod_img_100.gif');
   
   // 경로 설정
   $('#textOriginalImgPath').val('');
   $('#textLargeImgPath').val('');
   $('#textMiddleImgPath').val('');
   $('#textSmallImgPath').val('');
   $('#textOriginalImgPath').focus();
}

function saveRow3() {
   if($("#textMajoCodeName").val() == "") {
      alert("상품카테고리를 먼저 선택해 주십시오.");
      $("#textMajoCodeName").focus();
      return;
   } else if($("#textGoodIdenNumb").val() == "") {
      alert("상품기본정보를 먼저 등록해 주십시오.");
      $("#textGoodName").focus();
      return;
   }
   
   $('#selectIssubOntract').val("0"); // 하도급 대상여부 숨김으로 인한 수정
   var textVendorId = $('#textVendorId');//공급사Id
   var textGoodIdenNumb = $('#textGoodIdenNumb').val();//상품코드
   var selectIssubOntract = $('#selectIssubOntract option:selected').val();//하도급대상여부
   var textSaleUnitPric = $('#textSaleUnitPric');//매입단가
   var selectOrdeClasCode = $("#selectOrdeClasCode option:selected").val();//단위
   var textDeliMiniQuan = $('#textDeliMiniQuan');//최소주문수량
   var textGoodSpecDesc = $('#textGoodSpecDesc1').val()+" "+$('#textGoodSpecDesc2').val()+" "+$('#textGoodSpecDesc3').val()
                     +" "+$('#textGoodSpecDesc4').val()+" "+$('#textGoodSpecDesc5').val()+" "+$('#textGoodSpecDesc6').val()
                     +" "+$('#textGoodSpecDesc7').val();//상품규격(재질,크기,무게,색상,TYPE,용도,M미터)
   var textDeliMiniDay = $('#textDeliMiniDay');//납품소요일
   var textMakeCompName = $('#textMakeCompName');//제조사
   var selectGoodClasCode = $("#selectGoodClasCode option:selected").val();//상품구분
   var textGoodInventoryCnt = $('#textGoodInventoryCnt');//제고수량
   var textOriginalImgPath = $('#textOriginalImgPath').val();//대표이지미원본
   var textLargeImgPath = $('#textLargeImgPath').val();//대표이미지대
   var textMiddleImgPath = $('#textMiddleImgPath').val();//대표이미지중
   var textSmallImgPath = $('#textSmallImgPath').val();//대표이미지소
   var message = Editor.getContent();//품목상세내역
   var textGoodSameWord = $('#textGoodSameWord1').val()+"‡"+$('#textGoodSameWord2').val()+"‡"+$('#textGoodSameWord3').val()
                        +"‡"+$('#textGoodSameWord4').val()+"‡"+$('#textGoodSameWord5').val();//상품동의어
   
   if(textVendorId.val() == "") {
      alert("공급사를 선택해 주십시오.");
      $('#textVendorNm').focus().select();
      return;
   }
   if(selectIssubOntract == ""){
      alert("하도급대상여부를 선택해 주십시오.");
      return;
   }
   if(textSaleUnitPric.val() == "") {
      alert("매입단가를 입력해 주십시오.");
      $('#textSaleUnitPric').focus().select();
      return;
   }
   if(selectOrdeClasCode == ""){
      alert("단위를 선택해 주십시오.");
      return;
   }
   if(textDeliMiniQuan.val() == "") {
      alert("최소주문수량을 입력해 주십시오.");
      $('#textDeliMiniQuan').focus().select();
      return;
   }
   if(textGoodSpecDesc == "‡‡‡‡‡‡") {
      alert("상품규격을 입력해 주십시오.");
      $('#textGoodSpecDesc1').focus().select();
      return;
   }
   if(textDeliMiniDay.val() == "") {
      alert("납품소요일을 입력해 주십시오.");
      $('#textDeliMiniDay').focus().select();
      return;
   }
   if(selectGoodClasCode == "") {
      alert("상품구분을 선택해 주십시오.");
      return;
   }
   if(textGoodInventoryCnt.val() == "") {
      alert("제고수량을 입력해 주십시오.");
      $('#textGoodInventoryCnt').focus().select();
      return;
   }
   if(textOriginalImgPath == "") {
      alert("품목이미지를 선택해 주십시오.");
      $('#textOriginalImgPath').focus().select();
      return;
   }
   var validator = new Trex.Validator();
   if (!validator.exists(message)) {
      alert("품목상세내역을 입력해 주십시오.");
      return;
   }
   if(textGoodSameWord == "‡‡‡‡") {
      alert("상품 동의어를 입력해 주십시오.");
      $('#textGoodSameWord1').focus().select();
      return;
   }
   
   var row = jq("#list2").jqGrid('getGridParam','selrow');
   var selrowContent = jq("#list2").jqGrid('getRowData',row);
   var vendorId = selrowContent.vendorId;
   var oper = "";
   if(row != null) {
      if(vendorId != "") {
         oper = "edit";
         if(!confirm("상품공급업체정보를 수정 하시겠습니까?")) return;
      } else {
         oper = "add";
         if(!confirm("상품공급업체정보를 저장 하시겠습니까?")) return;
         var isExists = false;
         var rowCnt = jq("#list2").getGridParam('reccount');
         for(var idx=0; idx<rowCnt; idx++) {
            var rowid = $("#list2").getDataIDs()[idx];
            var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
            if(selrowContent.vendorId == textVendorId.val()) {
               isExists= true;
               break; 
            }
         }
         if(isExists) {
            alert("이미 등록된 공급사 입니다.\n다른 공급사를 선택하십시오.");
            fnInitGoodVendor();
            $('#textVendorNm').attr("readonly",false);
            $('#btnVendor').attr("disabled",false);
            $('#textVendorNm').focus();
            return;
         }
      }
      $.post(
         "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/goodVendorTrans.sys"
         , { oper:oper,good_Iden_Numb:textGoodIdenNumb,vendorId:textVendorId.val(),sale_Unit_Pric:textSaleUnitPric.val()
            ,good_Spec_Desc:textGoodSpecDesc,orde_Clas_Code:selectOrdeClasCode,deli_Mini_Day:textDeliMiniDay.val()
            ,deli_Mini_Quan:textDeliMiniQuan.val(),make_Comp_Name:textMakeCompName.val(),original_Img_Path:textOriginalImgPath
            ,large_Img_Path:textLargeImgPath,middle_Img_Path:textMiddleImgPath,small_Img_Path:textSmallImgPath
            ,good_Same_Word:textGoodSameWord,good_Desc:message,issub_Ontract:selectIssubOntract
            ,good_Clas_Code:selectGoodClasCode,good_Inventory_Cnt:textGoodInventoryCnt.val() }
         , function(arg) {
            if(fnAjaxTransResult(arg)) {  //성공시
               var msg = eval('(' + arg + ')').msg;
               var oper = eval('(' + arg + ')').oper;
               var good_Iden_Numb = eval('(' + arg + ')').good_Iden_Numb;
               alert(msg);
               if(oper == "add") {
                  jq("#list2").attr("readonly",false);
                  $("#regButton2").attr("disabled",false);
                  $('#textVendorNm').attr("readonly",true);
                  $("#btnVendor").attr("disabled",true);
                  list2SetColProp(true);
               }
               var data = jq("#list2").jqGrid("getGridParam", "postData");
               data.srcGoodIdenNumb = good_Iden_Numb;
               jq("#list2").jqGrid("setGridParam", { "postData": data });
               jq("#list2").trigger("reloadGrid");
            }
         }
      );
   } else { jq( "#dialogSelectRow" ).dialog(); }
}

function fnSearchVendor() {
   var vendorNm = $("#textVendorNm").val();
   fnVendorDialog(vendorNm, "fnCallBackVendor");
}
function fnCallBackVendor(vendorId, vendorNm, areaType) {
   $("#textVendorId").val(vendorId);
   $("#textVendorNm").val(vendorNm);
   $("#selectAreaType").val(areaType);
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/vendorDetail.sys"
      , { srcVendorId:vendorId }
      , function(arg) {
         var detailInfo = eval('(' + arg + ')').detailInfo;
         $('#textVendorCd').val(detailInfo.vendorCd);
         $('#textPressentNm').val(detailInfo.pressentNm);
         $('#textPhoneNum').val(detailInfo.phoneNum);
   });
}

function transRow4(oper) {
   var goodIdenNumb = $("#textGoodIdenNumb").val();
   if($("#textMajoCodeName").val() == "") {
      alert("상품카테고리를 먼저 선택해 주십시오.");
      $("#textMajoCodeName").focus();
      return;
   } else if(goodIdenNumb == "") {
      alert("상품기본정보를 먼저 등록해 주십시오.");
      $("#textGoodName").focus();
      return;
   }
   var dispGoodId = "";
   var beforePrice = "";
   var borgNms = "";
   var groupId = "0";
   var clientId = "0";
   var branchId = "0";
   var contFromDate = "";
   var contToDate = "";
   var ispastSellFlag = "";
   var custGoodIdenNumb = "";
   var vendorId = "";
   if(oper == "add") {
      var row = jq("#list2").jqGrid('getGridParam','selrow');
      var selrowContent = jq("#list2").jqGrid('getRowData',row);
      if(selrowContent.vendorId == null || selrowContent.vendorId == "") {
         alert("상품공급업체정보를 먼저 등록해 주십시오.");
         $('#textVendorId').focus();
         return;
      }
   } else {
      var row = jq("#list3").jqGrid('getGridParam','selrow');
      var selrowContent = jq("#list3").jqGrid('getRowData',row);
      if(row != null) {
         dispGoodId = selrowContent.disp_Good_Id;
         beforePrice = selrowContent.sell_Price;
         borgNms = selrowContent.borgNms;
         groupId = selrowContent.groupId;
         clientId = selrowContent.clientId;
         branchId = selrowContent.branchId;
         contFromDate = selrowContent.cont_From_Date;
         contToDate = selrowContent.cont_To_Date;
         ispastSellFlag = selrowContent.ispast_Sell_Flag;
         custGoodIdenNumb = selrowContent.cust_Good_Iden_Numb; 
         vendorId = selrowContent.vendorId;
      } else {
         jq( "#dialogSelectRow" ).dialog();
         return;
      }
   }
   fnProductSalePriceDialog(oper,goodIdenNumb,dispGoodId,beforePrice
                           ,borgNms,groupId,clientId,branchId
                           ,contFromDate,contToDate
                           ,ispastSellFlag,custGoodIdenNumb,vendorId
                           ,"fnCallBackProductSalePrice");
}
function fnCallBackProductSalePrice(oper,dgId,giNumb,gId,cId,bId,ispastSellFlag,vId,custGoodIdenNumb,saleUnitPrice,sellPrice,beforePrice,startDate,endDate) {  //그룹ID,법인ID,사업장ID,과거상품판매여부,공급사ID,매입가,공급사상품코드,판매가,기존단가,계약시작일,계약종료일
   //alert("OPER:"+oper+", 진열SEQ:"+dgId+", 상품코드:"+giNumb+", 그룹ID:"+gId+", 법인ID:"+cId+", 사업장ID:"+bId+", 과거상품판매여부:"+ispastSellFlag+" ,공급사ID:"+vId+" ,공급사상품코드:"+custGoodIdenNumb+" ,매입가:"+saleUnitPrice+" ,판매가:"+sellPrice+" ,기존단가:"+beforePrice+" ,시작일:"+startDate+" ,계약종료일:"+endDate);
   var params;
   var refGoodSeq;
   if(oper == "add") { refGoodSeq = ""; } else { refGoodSeq = dgId; }
   params = {
         oper:oper,
         disp_Good_Id:dgId,
         good_Iden_Numb:giNumb,
         groupId:gId,
         clientId:cId,
         branchId:bId,
         cont_From_Date:startDate,
         cont_To_Date:endDate,
         ispast_Sell_Flag:ispastSellFlag,
         ref_Good_Seq:refGoodSeq,
         sell_Price:sellPrice,
         before_Price:beforePrice,
         sale_Unit_Pric:saleUnitPrice,
         cust_Good_Iden_Numb:custGoodIdenNumb,
         vendorId:vId
   };
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/displayGoodTrans.sys"
      , params
      , function(arg) {
         var msg = eval('(' + arg + ')').msg;
         alert(msg);
         jq("#list3").trigger("reloadGrid");
   });
}

function fnProductSalePriceHistDiv() {
   var row = jq("#list3").jqGrid('getGridParam','selrow');
   var selrowContent = jq("#list3").jqGrid('getRowData',row);
   if(row != null) {
      var goodIdenNumb = selrowContent.good_Iden_Numb;
      var borgNms = selrowContent.borgNms;
      var groupId = selrowContent.groupId;
      var clientId = selrowContent.clientId;
      var branchId = selrowContent.branchId;
      var goodName = selrowContent.good_Name;
      var vendorId = selrowContent.vendorId;
      
      fnProductSalePriceHistDialog(goodIdenNumb,borgNms,groupId,clientId,branchId,goodName,vendorId,"fnCallBackProductSalePriceHist");
   } else { jq( "#dialogSelectRow" ).dialog(); }   
}
function fnCallBackProductSalePriceHist() {
   //123update
}

function check(obj) {
   var frm = document.frm; 
   if(obj.value != "")  return;
   if(obj.id == "srcBorgName" ) {
      frm.srcGroupId.value= "0";
      frm.srcClientId.value= "0";
      frm.srcBranchId.value= "0";
      return false;
   } else if(obj.id == "srcVendorName") {
      frm.srcVendorId.value= "";
      return false;
   }
   return true;
}

function fnGetDisplayGoodInfo(vendorId, goodIdenNumb) {
   //현 판가정보
   var data = jq("#list3").jqGrid("getGridParam", "postData");
   data.srcVendorId = vendorId;
   data.srcGoodIdenNumb = goodIdenNumb;
   jq("#list3").jqGrid("setGridParam", { "postData":data });
   jq("#list3").trigger("reloadGrid");
}
</script>
</head>

<body>
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>
   <td>
      <!-- 타이틀 시작 -->
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr valign="top">
            <td width="20" valign="middle">
               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
            <td height="29" class="ptitle">상품상세</td>
         </tr>
      </table>
      <!-- 타이틀 끝 -->
   </td>
</tr>
<tr>
   <td>
      <table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td width="20" valign="top">
               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
            <td class="stitle">상품카테고리</td>
         </tr>
      </table></td>
</tr>
<tr>
   <td>
      <!-- 타이틀 시작 -->
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td colspan="2" class="table_top_line"></td>
         </tr>
         <tr>
            <td colspan="2" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject" width="100">상품카테고리</td>
            <td colspan="5" class="table_td_contents">
               <input id="textMajoCodeName" name="textMajoCodeName" type="text" value="<%=full_Cate_Name %>" size="" maxlength="50" style="width:400px;" readonly="readonly" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}" />
               <input id="textCateId" name="textCateId" type="hidden" value="<%=cate_Id %>" readonly="readonly" />
<% if("".equals(good_Iden_Numb)) { %>
               <a href="#"><img id="btnSearchCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_inquiry.gif" style="width:40px;height:18px;" align="middle" class="icon_search" /></a>
<% } %>
            </td>
         </tr>
         <tr>
            <td colspan="2" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td colspan="2" class="table_top_line"></td>
         </tr>
      </table>
      <!-- 타이틀 끝 -->
   </td>
</tr>
<tr>
   <td>&nbsp;</td>
</tr>
<tr>
   <td>
      <!-- 타이틀 시작 -->
      <table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td width="20" valign="top">
               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
            <td class="stitle">상품진열카테고리</td>
         </tr>
      </table>
      <!-- 타이틀 끝 -->
   </td>
</tr>
<tr>
   <td>
      <div id="jqgrid">
         <table id="list"></table>
      </div>
   </td>
</tr>
<tr>
   <td>&nbsp;</td>
</tr>
<tr>
   <td>
      <!-- 타이틀 시작 -->
      <table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td width="20" valign="top">
               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
            <td class="stitle">상품기본정보</td>
            <td align="right" class="stitle">
               <a href="#"><img id="saveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Save.gif" width="15" height="15" style="border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" /></a></td>
         </tr>
      </table>
      <!-- 타이틀 끝 -->
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
            <td class="table_td_subject" width="100">상품코드</td>
            <td class="table_td_contents">
               <input id="textGoodIdenNumb" name="textGoodIdenNumb" type="text" value="<%=good_Iden_Numb %>" size="" maxlength="50" readonly="readonly" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}" /></td>
            <td class="table_td_subject" width="100">상품명</td>
            <td class="table_td_contents">
               <input id="textGoodName" name="textGoodName" type="text" value="<%=good_Name %>" size="" maxlength="50" /></td>
            <td class="table_td_subject" width="100">과세구분</td>
            <td class="table_td_contents">
               <select id="selectVtaxClasCode" name="selectVtaxClasCode" class="select">
                  <option value="">선택</option>
                  <option value="10" <%="10".equals(vtax_Clas_Code)?"selected":""%>>과세10%</option>
                  <option value="20" <%="20".equals(vtax_Clas_Code)?"selected":""%>>영세율</option>
                  <option value="30" <%="30".equals(vtax_Clas_Code)?"selected":""%>>면세</option>
               </select></td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">판매가산출옵션</td>
            <td class="table_td_contents">
               <label><input id="radioSaleCriterionType" name="radioSaleCriterionType" type="radio" value="10"
                        <%="10".equals(sale_Criterion_Type)?"checked":""%> class="radio" onchange="change(this)" />매익률</label>
               <label><input id="radioSaleCriterionType" name="radioSaleCriterionType" type="radio" value="20"
                        <%="20".equals(sale_Criterion_Type)?"checked":""%> class="radio" onchange="change(this)" />절대매입가</label></td>
            <td class="table_td_subject">기준매익률</td>
            <td class="table_td_contents">
               <input id="textStanBuyingRate" name="textStanBuyingRate" type="text" value="<%=stan_Buying_Rate %>" size="20" maxlength="10" style="text-align:right;" onkeydown="this.value=this.value.replace(/[^.0-9]/g,'');" />%</td>
            <td class="table_td_subject">절대매입가</td>
            <td class="table_td_contents">
               <input id="textStanBuyingMoney" name="textStanBuyingMoney" type="text" value="<%=CommonUtils.getIntString(stan_Buying_Money) %>" size="20" maxlength="10" style="text-align:right;" onkeydown="this.value=this.value.replace(/[^.0-9]/g,'');" /></td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">물량배분여부</td>
            <td class="table_td_contents">
               <select id="selectIsDistribute" name="selectIsDistribute" class="select">
                  <option value="">선택</option>
                  <option value="0" <%="0".equals(isDistribute)?"selected":""%>>아니오</option>
                  <option value="1" <%="1".equals(isDistribute)?"selected":""%>>예</option>
               </select></td>
            <td class="table_td_subject">상품진열여부</td>
            <td colspan="3" class="table_td_contents">
               <select id="selectIsDisppastGood" name="selectIsDisppastGood" class="select">
                  <option value="">선택</option>
                  <option value="0" <%="0".equals(isDispPastGood)?"selected":""%>>미진열</option>
                  <option value="1" <%="1".equals(isDispPastGood)?"selected":""%>>진열</option>
               </select></td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
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
   <td>
      <!-- 타이틀 시작 -->
      <table width="100%" style="height:27px" border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td width="20" valign="top">
               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
            <td class="stitle">상품공급업체정보</td>
            <td align="right" class="stitle">
               <a href="#"><img id="regButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style="border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" /></a>
               <a href="#"><img id="delButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style="border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" /></a>
            </td>
         </tr>
      </table>
      <!-- 타이틀 끝 -->
   </td>
</tr>
<tr>
   <td>
      <div id="jqgrid">
         <table id="list2"></table>
      </div>
   </td>
</tr>
<tr>
   <td>&nbsp;</td>
</tr>
<tr>
   <td>
      <!-- 타이틀 시작 -->
      <table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td width="20" valign="top">
               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
            <td class="stitle">공급업체 상품이미지 및 상세설명</td>
            <td align="right" class="stitle">
               <a href="#"><img id="saveButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Save.gif" width="15" height="15" style="border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" /></a></td>
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
            <td class="table_td_subject" width="100">공급사</td>
            <td class="table_td_contents">
               <input id="textVendorNm" name="textVendorNm" type="text" value="" size="" maxlength="50" style="width:120px;" readonly="readonly" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}" onchange="check(this)" />
               <input id="textVendorId" name="textVendorId" type="hidden" value="" />
               <a href="#"><img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20;height:18px;border:0;" disabled="true" align="middle" class="icon_search" /></a></td>
            <td class="table_td_subject" width="100">공급사코드</td>
            <td class="table_td_contents">
               <input id="textVendorCd" name="textVendorCd" type="text" value="" size="" maxlength="20" readonly="readonly" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}" /></td>
            <td class="table_td_subject" width="110">권역</td>
            <td class="table_td_contents">
               <select id="selectAreaType" name="selectAreaType" class="select" disabled="disabled" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}">
                  <option value="">선택</option>
               </select></td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">대표자</td>
            <td class="table_td_contents">
               <input id="textPressentNm" name="textPressentNm" type="text" value="" size="" maxlength="50" readonly="readonly" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}" /></td>
            <td class="table_td_subject">연락처</td>
            <td class="table_td_contents" colspan="3">
               <input id="textPhoneNum" name="textPhoneNum" type="text" value="" size="" maxlength="20" readonly="readonly" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}" /></td>
            <td class="table_td_subject" style="display: none;">하도급대상여부</td>
            <td class="table_td_contents" style="display: none;">
               <select id="selectIssubOntract" name="selectIssubOntract" class="select">
                  <option value="">선택</option>
                  <option value="0">아니오</option>
                  <option value="1">예</option>
               </select></td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">매입단가</td>
            <td class="table_td_contents">
               <input id="textSaleUnitPric" name="textSaleUnitPric" type="text" value="" size="" maxlength="18" style="text-align:right;" onkeydown="this.value=this.value.replace(/[^.0-9]/g,'');" /></td>
            <td class="table_td_subject">단위</td>
            <td class="table_td_contents">
               <select id="selectOrdeClasCode" name="selectOrdeClasCode" class="select">
                  <option value="">선택</option>
               </select></td>
            <td class="table_td_subject">최소주문수량</td>
            <td class="table_td_contents">
               <input id="textDeliMiniQuan" name="textDeliMiniQuan" type="text" value="" size="" maxlength="10" style="text-align:right;" onkeydown="this.value=this.value.replace(/[^.0-9]/g,'');" /></td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">상품규격</td>
            <td colspan="3" class="table_td_contents">
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td>재질 <input id="textGoodSpecDesc1" name="textGoodSpecDesc1" type="text" value="" size="5" maxlength="20" style="text-align:right;" /></td>
                     <td>크기 <input id="textGoodSpecDesc2" name="textGoodSpecDesc2" type="text" value="" size="5" maxlength="20" style="text-align:right;" /></td>
                     <td>무게 <input id="textGoodSpecDesc3" name="textGoodSpecDesc3" type="text" value="" size="5" maxlength="20" style="text-align:right;" /></td>
                     <td>색상 <input id="textGoodSpecDesc4" name="textGoodSpecDesc4" type="text" value="" size="5" maxlength="20" style="text-align:right;" /></td>
                     <td>TYPE <input id="textGoodSpecDesc5" name="textGoodSpecDesc5" type="text" value="" size="5" maxlength="20" style="text-align:right;" /></td>
                     <td>용도 <input id="textGoodSpecDesc6" name="textGoodSpecDesc6" type="text" value="" size="5" maxlength="20" style="text-align:right;" /></td>
                     <td>M(미터) <input id="textGoodSpecDesc7" name="textGoodSpecDesc7" type="text" value="" size="5" maxlength="20" style="text-align:right;" /></td>
                  </tr>
               </table></td>
            <td class="table_td_subject">납품소요일</td>
            <td class="table_td_contents">
               <input id="textDeliMiniDay" name="textDeliMiniDay" type="text" value="" size="" maxlength="2" style="text-align:right;" onkeydown="this.value=this.value.replace(/[^.0-9]/g,'');" />일</td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">제조사</td>
            <td class="table_td_contents">
               <input id="textMakeCompName" name="textMakeCompName" type="text" value="" size="" maxlength="50" /></td>
            <td class="table_td_subject">상품구분</td>
            <td class="table_td_contents">
               <select id="selectGoodClasCode" name="selectGoodClasCode" class="select">
                  <option value="">선택</option>
               </select></td>
            <td class="table_td_subject">제고수량</td>
            <td colspan="3" class="table_td_contents">
               <input id="textGoodInventoryCnt" name="textGoodInventoryCnt" type="text" value="" size="" maxlength="18" style="text-align:right;" onkeydown="this.value=this.value.replace(/[^.0-9]/g,'');" /></td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">품목이미지</td>
            <td class="table_td_contents">
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td height="25">
                        <input id="textOriginalImgPath" name="textOriginalImgPath" type="text" value="" size="30" readonly="readonly" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}" />
                        <input id="textLargeImgPath" name="textLargeImgPath" type="hidden" value="" />
                        <input id="textMiddleImgPath" name="textMiddleImgPath" type="hidden" value="" />
                        <input id="textSmallImgPath" name="textSmallImgPath" type="hidden" value="" /></td>
                  </tr>
                  <tr>
                     <td colspan="2" height="25">
                        <a href="#"><img id="btnAttach" name="btnAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageOK.gif" style="width:75px;height:18px;" /></a>
                        <a href="#"><img id="btnAttachDel" name="btnAttachDel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageDelete.gif" style="width:75px;height:18px;" /></a>
                     </td>
                  </tr>
               </table></td>
            <td class="table_td_subject">대표품목이미지</td>
            <td colspan="2" class="table_td_contents4">
               <table>
                  <tr>
                     <td valign="bottom">
                        SMALL<br/>
                        <a href="#"><img id="SMALL" src="/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border: 0px;" /></a>
                     </td>
                     <td valign="bottom">
                        MEDIUM<br/>
                        <a href="#"><img id="MEDIUM" src="/img/system/imageResize/prod_img_70.gif" alt="MEDIUM" style="border: 0px;" /></a>
                     </td>
                     <td valign="bottom">
                        LARGE<br/>
                        <a href="#"><img id="LARGE" src="/img/system/imageResize/prod_img_100.gif" alt="LARGE" style="border: 0px;" /></a>
                     </td>
                  </tr>
               </table>
            </td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">품목상세내역<br /></td>
            <td colspan="5" class="table_td_contents4" style="height:50;">
               <%@ include file = "/daumeditor/editorbox.jsp" %>
               <textarea id="tx_load_content" cols="80" rows="10" style="display:none;"></textarea> <!--  daumEditor 수정 시 내용 가져올 때 필수 조건 -->
            </td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
         </tr>
         <tr>
            <td class="table_td_subject">상품 동의어</td>
            <td colspan="5" class="table_td_contents">
               <table width="98%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td><input id="textGoodSameWord1" name="textGoodSameWord1" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
                     <td><input id="textGoodSameWord2" name="textGoodSameWord2" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
                     <td><input id="textGoodSameWord3" name="textGoodSameWord3" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
                     <td><input id="textGoodSameWord4" name="textGoodSameWord4" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
                     <td><input id="textGoodSameWord5" name="textGoodSameWord5" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
                  </tr>
               </table></td>
         </tr>
         <tr>
            <td colspan="6" height="1" bgcolor="eaeaea"></td>
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
   <td>
      <!-- 타이틀 시작 -->
      <table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td width="20" valign="top">
               <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
            <td class="stitle">현 판가정보</td>
            <td align="right" class="stitle">
               <a href="#"><img id="regButton4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
               <a href="#"><img id="modButton4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
            </td>
         </tr>
      </table>
      <!-- 타이틀 끝 -->
   </td>
</tr>
<tr>
   <td>
      <div id="jqgrid">
         <table id="list3"></table>
   </div>
   </td>
</tr>
<tr>
   <td>&nbsp;</td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
   <p>처리할 데이터를 선택 하십시오!</p>
</div>

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
<%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp" %>
<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp" %>
<%
/**------------------------------------상품판매가상세정보팝업 사용방법---------------------------------
* fnProductSalePriceDialog(goodIdenNumb, callbackString) 을 호출하여 Div팝업을 Display ===
* goodIdenNumb : 상품코드
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(,,) 
*/
%>
<%@ include file="/WEB-INF/jsp/product/product/productSalePriceInfoDiv.jsp" %>
<%
/**------------------------------------과거 판매단가 히스토리팝업 사용방법---------------------------------
* fnProductSalePriceHistDialog(goodIdenNumb, callbackString) 을 호출하여 Div팝업을 Display ===
* goodIdenNumb : 상품코드
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(,,) 
*/
%>
<%@ include file="/WEB-INF/jsp/product/product/productSalePriceHistDiv.jsp" %>

<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>