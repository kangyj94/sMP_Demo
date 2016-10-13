<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="kr.co.bitcube.product.dto.CategoryDto"%>

<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-308 + Number(gridHeightResizePlus)";
    String listWidth = "$(window).width()-60 -240 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");           //화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);  //사용자 정보
	@SuppressWarnings("unchecked")
	List<CategoryDto> standCategoryList = (List<CategoryDto>) request.getAttribute("standCategoryListInfo");//표준카테고리 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="StyleSheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree.css" type="text/css"/>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript" src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree.js"></script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
	
	$("#btnEraseCategory").click( function() { fnEraseCategory(); });
	$('#btnSearch').click(function() { fnSearch(); });
	
	$("#btnSelect").click(  function() { fnSelectProduct(); });
    $("#btnClose").click(   function() { fnCloseProductPop(); });
    
	$(window).bind('resize', function() {
		$("#list").setGridHeight(<%=listHeight %>);
		$("#list").setGridWidth(<%=listWidth %>);
	}).trigger('resize');
	
	
	//jQuery("#list").setGridParam({multiselect:false}).hideCol('cb')
	//alert(jQuery("#list").getGridParam('multiselect'));
	
	fnInitCategoryInfo();
});

// 카테고리 초기화 
function fnInitCategoryInfo(){
	$.post(	//조회조건의 권역세팅
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/category/getStandardCategoryTreeJQ.sys',
			{},
			function(arg){
				standardCategory = new dTree('standardCategory','');
               	standardCategory.config.folderLinks = true;
               	
               	var cateInfo = eval('(' + arg + ')').standCategoryListInfo;
               	
				for(var idx=0;idx<cateInfo.length;idx++) {
					standardCategory.add(cateInfo[idx].cate_Id,cateInfo[idx].ref_Cate_Seq,cateInfo[idx].majo_Code_Name,"javascript:void(0);fnChoiceStandardCategory('"+cateInfo[idx].cate_Id+"','"+cateInfo[idx].lev+"','"+cateInfo[idx].full_Cate_Name+"','"+cateInfo[idx].majo_Code_Name+"')",'');	//Home
                }
				$('#categoryTab_0').append(""+standardCategory+"");
			}
		);	
}

// 카테고리 선택시 초기화 
function fnChoiceStandardCategory(cateId,cateLev,cateFullName,cateName) {
	$('#srcMajoCodeName').val(cateFullName); 
	$('#srcCateId').val(cateId);
} 

// 조회 버튼 클릭시 발생 이벤트 
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcCateId = $('#srcCateId').val();
	data.srcGoodName = $('#srcGoodName').val();
	data.srcGoodSpecDesc = $('#srcGoodSpecDesc').val();
	data.srcGoodClasCode = $('#srcGoodClasCode').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

// 카테고리 정보를 초기화 
function fnEraseCategory(){
	$('#srcMajoCodeName').val(''); 
	$('#srcCateId').val('');
}

// 로우 선택 시 발생 이벤트 
function fnChoiceOneRow(rowid){
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
// 	var opener = window.dialogArguments ;
// 	opener.fnProdSearchCallBack(selrowContent.good_Iden_Numb,selrowContent.good_Name,selrowContent.full_Cate_Name);// good_Iden_Numb , good_Name , full_Cate_Name
	window.opener.fnProdSearchCallBack(selrowContent.good_Iden_Numb,selrowContent.good_Name,selrowContent.full_Cate_Name);// good_Iden_Numb , good_Name , full_Cate_Name
	window.close();
	
	
    
}

//선택 
function fnSelectProduct(){
  var msg = ''; 
  msg += 'type of value ['+typeof($("#list").jqGrid('getGridParam','selarrrow'))+']';
  msg += '\n values ['+$("#list").jqGrid('getGridParam','selarrrow')+']';
//   alert(msg);
  
  if($.trim($("#list").jqGrid('getGridParam','selarrrow')) == ''){
      alert('선택된 데이터가 없습니다. 선택후 이용하시기 바랍니다.');
      return; 
  }
  
  var selIds = $.trim($("#list").jqGrid('getGridParam','selarrrow')).split(",");
  var rtnObj = new Object();
  var rtnArrayObj = new Array(); 
  for(var idx = 0 ; idx < selIds.length ; idx ++){
      var data = jq("#list").jqGrid('getRowData',selIds [idx]); 
      
      var rtnData = {};
      for (var propNm in data ){
          rtnData[propNm.toLowerCase()] = data[propNm]; 
      }
      
      rtnArrayObj.push(rtnData);
  }
  rtnObj.isSuccess = "success";
  rtnObj.objs = rtnArrayObj;
  window.returnValue=rtnObj;
  
  top.close();
}

//닫기 
function fnCloseProductPop(){
  var rtnObj = new Object();
  rtnObj.isSuccess = "none";
  window.returnValue=rtnObj;
  top.close();
}
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['상품코드','상품명','이미지','카테고리','규격','과세구분','배분여부','진열여부','매입단가','단위','이미지여부','설명여부','상품구분','cate_Id', 'small_Img_Path','표준 납기일', '최소주문수량', 'vendorId','good_St_Spec_Desc'],
		colModel:[
			{name:'good_Iden_Numb',index:'good_Iden_Numb',width:60,align:"left",search:false,sortable:true,editable:false
			},//상품코드
			{name:'good_Name', index:'good_Name',width:160,align:"left",search:false,sortable:true,editable:false },//상품명
			{name:'good_img', index:'good_img',width:30,align:"center",search:false,sortable:true,editable:false },//이미지
			{name:'full_Cate_Name',index:'full_Cate_Name',width:220,align:'left',search:false,sortable:false,editable:false },//카테고리명
			{name:'good_Spec_Desc',index:'good_Spec_Desc',width:160,align:"left",search:false,sortable:false,editable:false },//규격
			{name:'vtax_Clas_Code',index:'vtax_Clas_Code',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"10:과세10%;20:영세율;30:면세"}
			},//과세구분
			{name:'isDistribute',index:'isDistribute',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"1:Y;0:N"}
			},//물량배분여부
			{name:'isDispPastGood',index:'isDispPastGood',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"1:진열;0:미진열"}
			},//과거상품진열여부
			{name:'sale_Unit_Pric',index:'sale_Unit_Pric',width:60,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },//매입단가
			{name:'orde_Clas_Code',index:'orde_Clas_Code',width:60,align:"center",search:false,sortable:false,editable:false },//단위
			{name:'isSetImage',index:'isSetImage',width:60,align:"center",search:false,sortable:false,editable:false },//대표이미지여부
			{name:'isSetDesc',index:'isSetDesc',width:60,align:"center",search:false,sortable:false,editable:false },//상품설명여부
			{name:'good_Clas_Code',index:'good_Clas_Code',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"10:일반;20:지정;30:수탁"}
			},//상품구분
			{name:'cate_Id',index:'cate_Id',hidden:true,search:false },
			{name:'small_Img_Path',index:'small_Img_Path',hidden:true,search:false },
			{name:'requ_Deli_Date',index:'requ_deli_date',hidden:true},
			{name:'deli_Mini_Quan',index:'deli_Mini_Quan',hidden:true},
			{name:'vendorId',index:'vendorId',hidden:true},
			{name:'good_St_Spec_Desc',index:'good_St_Spec_Desc',hidden:true}
		],
		postData: {
			srcCateId:$('#srcCateId').val(),
			srcGoodName:$('#srcGoodName').val(),
			srcGoodSpecDesc:$('#srcGoodSpecDesc').val(),
			srcGoodClasCode:'30'
			
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight%>,autowidth:true,
		sortname:'good_Name',sortorder:'desc',
		caption:"상품정보",
		multiselect:true,
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
            // 품목 표준 규격 설정
            var prodStSpcNm = new Array();
            <% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
                prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
            <% } %>
            
            // 품목 규격 property 추출
            var prodSpcNm = new Array();
            <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
                prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
            <% }                                                                       %>
            var rowCnt = jq("#list").getGridParam('reccount');
            for(var idx=0; idx<rowCnt; idx++) {
                var rowid = $("#list").getDataIDs()[idx];
                jq("#list").restoreRow(rowid);
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                // 규격 화면 로드
                var argStArray = selrowContent.good_St_Spec_Desc.split("‡");
                var argArray = selrowContent.good_Spec_Desc.split("‡");
                
                var prodStSpec = "";
                var prodSpec = "";
                
                for(var stIdx = 0 ; stIdx < prodSpcNm.length ; stIdx ++ ) {
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
                jQuery('#list').jqGrid('setRowData',rowid,{good_Spec_Desc:prodStSpec});
                
				// img 화면 로드 
				var imgTag = ""; 
				if($.trim(selrowContent.small_Img_Path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_Img_Path+"' style='width:30px;height:30px;' />";	
				else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:30px;height:30px;' />";
				
				jQuery('#list').jqGrid('setRowData',rowid,{good_img:imgTag});
            }
			$(window).bind('resize', function() {
				$("#list").setGridHeight(<%=listHeight %>);
				$("#list").setGridWidth(<%=listWidth %>);
			}).trigger('resize');
// 			fnSetMultiSelectEnable(); 
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
});
</script>

</head>
<body>
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
         <td colspan="3">
            <!-- 타이틀 시작 -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr valign="top">
                  <td width="20" valign="middle">
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                  </td>
                  <td height="29" class='ptitle'>상품검색</td>
               </tr>
            </table>
            <!-- 타이틀 끝 -->
         </td>
      </tr>
      <tr>
         <td width="230" valign="top">
            <!-- 타이틀 시작 -->
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
               <tr style="height: 22px">
                  <td width="20" valign="top">
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" style="vertical-align: middle;" />
                  </td>
                  <td class="stitle" style="height: 27px;">표준카테고리정보</td>
                  <td align="right" class="stitle">&nbsp;</td>
               </tr>
            </table>
            <!-- 타이틀 끝 -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
                  <td class="table_top_line"></td>
               </tr>
               <tr>

<!--                   <td id="standardTd" style="padding:5 0 10 5;vertical-align: top;"> -->
<!--                      <div id="categoryLeftDiv" style="TEXT-ALIGN: left; leftMargin:0; position:relative; width:100%; height:450px; overflow-x:scroll; overflow-y:scroll; border:1px solid; border:#CCCCCC; "> -->
<!--                         <div id="categoryTab_0" class="dtree" style="display:block; padding:0 0 0 0;overflow: auto;"> -->
                        
                    
                    
                <td id="standardTd" style="padding:5 0 10 5;vertical-align: top;">
                    <div id="categoryLeftDiv" style="TEXT-ALIGN: left; leftMargin:0; padding:5px 0px 10px 5px;">
            <!-------------------------------------------------------------------------------------->
            <!-- 차트 타입 메뉴 구성 -->
            <!-------------------------------------------------------------------------------------->
                        <div id=categoryTab_0 class="dtree" style="display:block; padding:0 0 0 0;overflow-y:scroll; width:200px; height:450px;">
                        </div>
                     </div>
                  </td>
               </tr>
            </table>
         </td>
         <td width="10">&nbsp;</td>
         <td style="vertical-align: middle;">
            <!-- 타이틀 시작 -->
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
               <tr style="height: 22px">
                  <td width="20" valign="top">
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                  </td>
                  <td class="stitle">상품 검색조건</td>
                  <td align="right" class="stitle">
                     <span class="ptitle">
                        <img id="btnSearch" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" width="65" height="22" />
                     </span>
                  </td>
               </tr>
            </table>
            <!-- 타이틀 끝 -->
            <!-- 컨텐츠 시작 -->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
                  <td colspan="2" class="table_top_line"></td>
               </tr>
               <tr>
                  <td class="table_td_subject" width="100">카테고리</td>
                  <td class="table_td_contents">
                     <input id="srcMajoCodeName" name="srcMajoCodeName" type="text" value="" size="20" maxlength="30" style="width: 350px ; width: 90%" readonly="readonly" />
                     <input id="srcCateId" name="srcCateId" type="hidden" value="" readonly="readonly" />
                     <img id="btnEraseCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_clear.gif" class="icon_search" style="width:20px;height:18px;border:0; vertical-align: middle;cursor: pointer;" />
                  </td>
               </tr>
               <tr>
                  <td colspan="2" height='1' bgcolor="eaeaea"></td>
               </tr>
               <tr>
                  <td class="table_td_subject">상품명</td>
                  <td class="table_td_contents">
                    <input id="srcGoodClasCode" name="srcGoodClasCode" type="hidden" value="30" />
                     <input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" style="width: 350px ; width: 90%" />
                  </td>
               </tr>
               <tr>
                  <td colspan="2" height='1' bgcolor="eaeaea"></td>
               </tr>
               <tr>
                  <td class="table_td_subject">상품규격</td>
                  <td class="table_td_contents">
                     <input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" style="width: 350px ; width: 90%"/>
                  </td>
               </tr>
               <tr>
                  <td colspan="2" class="table_top_line"></td>
               </tr>
               <tr>
                  <td colspan="2" style="height: 8px;"></td>
               </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
<!--                   <td align="center" bgcolor="#CCCCCC" style="width: 100%; height: 400px" colspan="2">그리드 영역</td> -->
                  <td>
                     <div id="jqgrid">
                        <table id="list"></table>
                        <div id="pager"></div>
                     </div>
                  </tD>
               </tr>
            </table>
         </td>
      </tr>
      <tr>
            <td colspan="3" align="center">
                <img id="btnSelect" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_ok2.gif" class="icon_search" style="width: 65px; height: 22px; border: 0; vertical-align: middle; cursor: pointer;" />
                <img id="btnClose" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_cancel.gif" class="icon_search" style="width: 65px; height: 22px; border: 0; vertical-align: middle; cursor: pointer;" />
            </td>
      </tr>
   </table>
</body>
</html>