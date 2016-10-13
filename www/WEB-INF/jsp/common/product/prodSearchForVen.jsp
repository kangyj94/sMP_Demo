<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmProductWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 740px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmProductWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
	// Dialog 초기화 
// 	$("#productDialogPop").jqmHide();
	$('#productDialogPop').jqm(); 
	$('#productDialogPop').jqm().jqDrag('#productDialogHandle');
	$("#productListForVendorList").clearGridData();
	
	$("#productSearch").click(function(){	//Dialog 선택
		fnSearchProduct();
	});
	
	$('#btnProductChoiceByVendor').click(function(){
		fnChoiceProductByVendor();
		$("#productDialogPop").jqmHide();
		fnBuyBorgCallback = "";
	});
	
	$("#btnDeliveryManageCloseDiv").click(function(){	//Dialog 닫기
		$("#productDialogPop").jqmHide();
		fnBuyBorgCallback = "";
	});
});


// 초기화 
var pProdVendorGrpupId  = ""; 
var pProdVendorClientId = "";
var pProdVendorBranchId = "";
function fnSearchProductForVendor(pGroupId, pClientId, pBranchId) {
	// 파라미터 초기화 
	fnInitParamsDivVendorProduct(pGroupId, pClientId, pBranchId); 
	fnInitComponentDivVendorProduct(); 
	prodSearchForVenInit();
	jq("#productListForVendorList").jqGrid("setGridParam", { "url":'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys' });
	$("#productDialogPop").jqmShow();
}
function fnInitParamsDivVendorProduct(groupId, clientId, branchId){
	pProdVendorGrpupId                 = groupId;                
	pProdVendorClientId                = clientId;                
	pProdVendorBranchId                = branchId;
}
function fnInitComponentDivVendorProduct(){
	$('#productListForVendorList').jqGrid('clearGridData');
	$('#schGoodName').val('');
	$('#schGoodSpecName').val('');
}

</script>


<script type="text/javascript">
// 공급사 상품 조회 (고객사)
function fnSearchProduct(){
	var data = jq("#productListForVendorList").jqGrid("getGridParam", "postData");
	data.schGoodName = $("#schGoodName").val();
	data.schGoodSpecName = $("#schGoodSpecName").val();
	data.schGroupId  = pProdVendorGrpupId;
	data.schClientId = pProdVendorClientId;
 	data.schBranchId = pProdVendorBranchId;
	jq("#productListForVendorList").jqGrid("setGridParam", { "url":'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/getCommonProductSearchListByVendor.sys' });
	jq("#productListForVendorList").jqGrid("setGridParam", { "postData":data });
	jq("#productListForVendorList").trigger("reloadGrid");
}
// 상품 선택후 처리 
function fnChoiceProductByVendor(){
	var rowCnt = jq("#productListForVendorList").getGridParam('reccount');
	if(rowCnt == 0 ){		// 조회된 데이터가 없을시
		$('#productSearchdivDialog').html('<p>조회된 데이터가 없습니다. \n확인후 이용하시기 바랍니다.</p>'); 
	    $("#productSearchdivDialog").dialog();
	    return;
	}else {
		var rowCnt = $("#productListForVendorList").getGridParam('reccount');
		
		if(rowCnt>0) {
			var dispGoodIdArray = new Array();
			var arrCnt = 0; 
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#productListForVendorList").getDataIDs()[idx];
				var isCheckList = jq("#isCheck_"+rowid).attr("checked");
				if(isCheckList) {
					var selrowContent = jq("#productListForVendorList").jqGrid('getRowData',rowid);
					dispGoodIdArray[arrCnt] = selrowContent.disp_Good_Id;
					arrCnt++; 
				}
			}
			fnCallBackSearchProductForVendor(dispGoodIdArray);
		}
	}
}
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
function prodSearchForVenInit() {
	jq("#productListForVendorList").jqGrid({
		datatype: 'json', 
		mtype: 'POST',
		url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys", 
		colNames:['선택','상품명','상품코드','상품규격','단위','단가','소요일','진열SEQ'],
		colModel:[
            {name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,
            	editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
            	formatter:checkboxFormatter
            },//선택
			{name:'good_Name'      ,index:'good_Name'      ,width:210,align:"center" ,search:false ,sortable:false , align:"left",editable:false },    
			{name:'good_Iden_Numb' ,index:'good_Iden_Numb' ,width:75,align:"center"  ,search:false ,sortable:false , align:"left",editable:false },    
			{name:'good_Spec_Desc' ,index:'good_Spec_Desc' ,width:180,align:"center" ,search:false ,sortable:false , align:"left",editable:false },    
			{name:'orde_Clas_Code' ,index:'orde_Clas_Code' ,width:50,align:"center"  ,search:false ,sortable:false , align:"center",editable:false},
// 			{name:'sale_Unit_Pric' ,index:'sale_Unit_Pric' ,width:80,align:"center"  ,search:false ,sortable:false , align:"right", editable:false},
			{name:'sale_Unit_Pric'         ,index:'sale_Unit_Pric'         ,width:45,align:"right",formatter: 'integer'
                ,formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }              
            },                                                                                                /*판매가 */
			{name:'deli_Mini_Day'  ,index:'deli_Mini_Day'  ,width:100,align:"center" ,search:false ,sortable:false , align:"center",editable:false },
			{name:'disp_Good_Id'   ,index:'disp_Good_Id'  ,width:100,align:"center" ,search:false ,sortable:false , align:"center",editable:false,hidden:true }
		],
		postData: {
			schGoodName:$("#srcGoodName").val(),
			schGoodSpecName:$("#srcGoodSpecName").val(),
			schGroupId:pProdVendorGrpupId,
			schClientId:pProdVendorClientId,
			schBranchId:pProdVendorBranchId
		},
		/* rowNum:10, rownumbers: true, rowList:[10,20,30,50,100,500,1000], pager: '#borgDivPager', */
		multiselect: false, 
		height:250, width:700, 
		sortname: '', sortorder: '',
		caption:'공급사 상품조회', 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(){
		 	// 품목 규격 설정
			var prodSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
			<% }  %>
            
		    
			var rowCnt = jq("#productListForVendorList").getGridParam('reccount');
			if(rowCnt>0) {
			    
			    
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#productListForVendorList").getDataIDs()[i];
					jQuery('#productListForVendorList').jqGrid('setRowData',rowid,{deli_Mini_Quan:jq("#productListForVendorList").jqGrid('getRowData',rowid).deli_Mini_Day + ' 일'});
					
					// 규격 화면 로드
					var argArray = FNgetGridDataObj('productListForVendorList',rowid,'good_Spec_Desc').split("‡");
					var prodSpec = "";
					for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
						if(argArray[jIdx] > ' ') {
							prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
						}
					}
					jQuery('#productListForVendorList').jqGrid('setRowData',rowid,{'good_Spec_Desc':prodSpec});
				} 
			} 
		},
		afterInsertRow: function(rowid, aData){},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#borgDivList").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}

/**
 * list2 체크박스 포맷제공
 */
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' type='checkbox' offval='no' />";
}

</script>
</head>

<body>
   <div class="jqmProductWindow" id="productDialogPop">
      <table width="500" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <div id="productDialogHandle">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                     <tr>
                        <td width="21">
                           <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
                        </td>
                        <td width="22">
                           <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom: 5px" />
                        </td>
                        <td class="popup_title">공급사상품검색</td>
                        <td width="22" align="right">
                           <a href="#" class="jqmClose">
                              <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom: 5px;" />
                           </a>
                        </td>
                        <td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
                     </tr>
                  </table>
               </div>
               <table width="100%" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                     <td width="20" height="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" />
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
                     <td width="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" />
                     </td>
                  </tr>
                  <tr>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                     <td bgcolor="#FFFFFF" align="right">
                        <img id="productSearch" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0; cursor: pointer;'  />
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                  </tr>
                  <tr>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
<!--                      <table width="100%"  border="0" cellspacing="0" cellpadding="0"> -->
<!--                         <tr> -->
<!--                            <td align="right"> -->
<!--                               <a href="#"> -->
<%--                               <img id="srcBuyBorgDivButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;' /> --%>
<!--                               </a> -->
<!--                            </td> -->
<!--                         </tr> -->
<!--                      </table> -->
                     <td valign="top" bgcolor="#FFFFFF">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td colspan="2" class="table_top_line"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject" width="100">상품명 </td>
                              <td class="table_td_contents">
                                 <input type="text" id="schGoodName" name="schGoodName" value="" maxlength="50" style="width: 560px;" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="2" height='1' bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">상품코드</td>
                              <td class="table_td_contents">
                                 <input type="text" id="schGoodSpecName" name="schGoodSpecName" value="" maxlength="50" style="width: 560px;" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="2" class="table_top_line"></td>
                           </tr>
                           <tr>
                              <td colspan="2" height="5"></td>
                           </tr>
                        </table>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td align="center">
                                 <a href="#">
                                 </a>
                              </td>
                           </tr>
                        </table>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td height="5"></td>
                           </tr>
                           <tr>
                              <td align="right">
                                 <table>
                                    <tr>
                                       <td valign="top">
                                       </td>
                                       <td>
                                          <a href="#">
                                          </a>
                                       </td>
                                    </tr>
                                 </table>
                              </td>
                           </tr>
                           <tr>
                              <td valign="top">
                                 <div id="jqgrid">
                                    <table id="productListForVendorList"></table>
                                 </div>
                              </td>
                           </tr>
                        </table>
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space" />
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td align="center">
                                 <a href="#">
                                    <img id="btnProductChoiceByVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_select.gif" style='border: 0;' />
                                 </a>
                                 &nbsp;
                                 <a href="#">
                                    <img id="btnDeliveryManageCloseDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style='border: 0;' />
                                 </a>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                  </tr>
                  <tr>
                     <td>
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" />
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                     <td height="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" />
                     </td>
                  </tr>
               </table>
            </td>
         </tr>
      </table>
   </div>
   <div id="productSearchdivDialog" title="Warning" style="display: none; font-size: 12px; color: red;"></div>
</body>
</html>
