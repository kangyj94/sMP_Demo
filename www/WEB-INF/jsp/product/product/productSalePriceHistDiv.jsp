<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmProductSalePriceHistWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 550px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmProductSalePriceHistWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
$(function(){
   $('#productSalePriceHistDialogPop').jqm();   //Dialog 초기화
   $('#productSalePriceHistDialogPop').jqm().jqDrag('#productSalePriceHistDialogHandle');
   $('#productSalePriceHistCloseButton').click( function() { fnProductSalePriceHistClose(); });
   $('#jqmHistClose').click( function() { fnProductSalePriceHistClose(); });
   $('#productSalePriceSaveHistButton').click( function() { fnDisplayGoodUpdate(); });
   
});

var isOepnHistDiv = false; 
// openFunction 
function fnProductSalePriceHistDialog(rowid) {
	$("#productSalePriceHistDialogPop").jqmShow();
	fnInitShowPastProductDiv(rowid);
}

// 그리드 정보및 컨퍼넌트 정보를 Load 한다. 
function fnInitShowPastProductDiv(rowid){
    var dispDatas = $("#prodDisplay").jqGrid('getRowData',rowid);
    var mstDatas = $("#productMaster").jqGrid('getRowData',$("#productMaster").getGridParam("selrow"));
    
    $('#areaCode').val(dispDatas['areanm']);
    $('#past_fullborgnms').val(dispDatas['fullborgnms']); 
    $('#past_good_name').val(mstDatas['good_name']); 
    
    // 그리드 데이터 로드 Params                                                              
    var schParamObj = {                                                                       
		disp_good_id:dispDatas['disp_good_id']                                                    
    };       
    
//     var schParamObj = {                                                                       
//     		disp_good_id:'1606'                                                    
//         };  
    
                                                                                              
    if(!isOepnHistDiv){		fnPastDivHistGridInit(schParamObj);		}                             
    else{                                                                                     
        jq("#productSalePriceHistDivList").jqGrid("setGridParam", { "postData":schParamObj });
    	jq("#productSalePriceHistDivList").trigger("reloadGrid");                               
    }                                                                                         
    isOepnHistDiv = true;     
}

// 과거상품 update 
 function fnDisplayGoodUpdate() {
    var rowCnt = jq("#productSalePriceHistDivList").getGridParam('reccount');
    var disp_good_id_array		= new Array();
    var ispast_sell_flag_array 	= new Array(); 
    if(rowCnt>0) {
       for(var i=0; i<rowCnt; i++) {
          var rowid = $("#productSalePriceHistDivList").getDataIDs()[i];
          var selrowContent = jq("#productSalePriceHistDivList").jqGrid('getRowData',rowid);
          disp_good_id_array.push(selrowContent.disp_good_id);
          ispast_sell_flag_array.push($('#orderSelect_'+rowid).val()); 
       }
       
       var params = {disp_good_id_array:disp_good_id_array , ispast_sell_flag_array:ispast_sell_flag_array} ; 
       fnParDisplayGoodUpdate(params);
    } else {
    	alert('과거상품이 없습니다.');
    }
    
    
    
//     $.post(
<%--        "<%=Constances.SYSTEM_CONTEXT_PATH %>/product/displayGoodUpdateTrans.sys",  --%>
//        params,
//        function(arg){ 
//           if(fnTransResult(arg, false)) {//성공시
//              alert('수정 되었습니다.');
//              jq("#list3").trigger("reloadGrid");
//           }
//        }
//     );
//     $("#productSalePriceHistCloseButton").click();
 }

function fnProductSalePriceHistClose() {
	$("#productSalePriceHistDialogPop").jqmHide();
}
</script>

<script type="text/javascript"> 
function fnPastDivHistGridInit(schParamsObj) {
   jq("#productSalePriceHistDivList").jqGrid({
      datatype: 'json', mtype: 'POST',
      url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/productManage/displayGoodHistListJQGrid.sys',
      colNames:['진열시작일','진열종료일','매입가','판매가','진열SEQ','과거상품 판매여부'],
      colModel:[
         { name:'disp_from_date',index:'disp_from_date', width:80,align:"center"},	//진열시작일
         { name:'disp_to_date',index:'disp_to_date', width:80,align:"center"},		//진열종료일
         { name:'sale_unit_pric'     ,index:'sale_unit_pric'     ,width:55,align:"right",formatter: 'integer'
             ,formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }				
		 },            /*매입가 */
         { name:'sell_price'         ,index:'sell_price'         ,width:55,align:"right",formatter: 'integer'
             ,formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }				
		 },
         { name:'disp_good_id',index:'disp_good_id',hidden:true, key:true },														//진열SEQ
         { name:'ispast_sell_flag',index:'ispast_sell_flag',width:120,align:"center",sortable:false,editable:false } 				//과거상품 판매여부
      ],
      postData: schParamsObj,
      rowNum:10,rownumbers:true,rowList:[10,20,30],pager:'#productSalePriceHistDivPager',
      height:150,width:500,
      sortname:'disp_Good_Id',sortorder:"desc",
      caption:'판가 히스토리', 
      viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      loadComplete:function() {
         var rowCnt = jq("#productSalePriceHistDivList").getGridParam('reccount');
         if(rowCnt>0) {
            for(var i=0; i<rowCnt; i++) {
               var rowid = $("#productSalePriceHistDivList").getDataIDs()[i];
               var selrowContent = jq("#productSalePriceHistDivList").jqGrid('getRowData',rowid);
               
               var selbox = "";
               selbox = "<select id='orderSelect_"+rowid+"' >";
               if(selrowContent.ispast_sell_flag == '1') {
                   selbox += "<option value ='1' selected>판매</option><option value ='0'>미판매</option>";
               }
               else{
                   selbox += "<option value ='1'>판매</option><option value ='0' selected>미판매</option>";
               }
               
               jQuery('#productSalePriceHistDivList').jqGrid('setRowData',rowid,{ispast_sell_flag:selbox});
            }
         }
      },
      afterInsertRow:function(rowid,aData) {},
      ondblClickRow:function(rowid,iRow,iCol,e) {
         fnJqmSelectVendor();
      },
      loadError:function(xhr, st, str) { $("#productSalePriceHistDivList").html(xhr.responseText); },
      jsonReader: { root:"productSalePriceHistDivList",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell"}
   });
}
</script>
</head>
<body>
   <div class="jqmProductSalePriceHistWindow" id="productSalePriceHistDialogPop">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <div id="productSalePriceHistDialogHandle">
                  <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                     <tr>
                        <td width="21">
                           <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
                        </td>
                        <td width="22">
                           <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom: 5px;" />
                        </td>
                        <td class="popup_title">과거 판매단가 히스토리</td>
                        <td width="22" align="right">
                           <img id="jqmHistClose" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom: 5px; cursor: pointer;" />
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
                     <td bgcolor="#FFFFFF">
                        <!-- 타이틀 시작 -->
                        <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                           <tr>
                              <td width="20" valign="top">
                                 <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                              </td>
                              <td class="stitle">판매조직 상품정보</td>
                           </tr>
                        </table>
                        <!-- 타이틀 끝 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td colspan="4" class="table_top_line"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">권역</td>
                              <td colspan="3" class="table_td_contents">
                                 <input id="areaCode" name="areaCode" type="text" value="" size="" maxlength="50" style="width: 350px;background-color: #eaeaea;" disabled="disabled" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4" height="1" bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">진열조직</td>
                              <td colspan="3" class="table_td_contents">
                                 <input id="past_fullborgnms" name="past_fullborgnms" type="text" value="" size="" maxlength="50" style="width: 350px;background-color: #eaeaea;" disabled="disabled" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4" height="1" bgcolor="eaeaea"></td>
                           </tr>
                           <tr>
                              <td class="table_td_subject">상품</td>
                              <td colspan="3" class="table_td_contents">
                                 <input id="past_good_name" name="past_good_name" type="text" style="background-color: #eaeaea;" value="" disabled="disabled" />
                              </td>
                           </tr>
                           <tr>
                              <td colspan="4" class="table_top_line"></td>
                           </tr>
                           <tr>
                              <td colspan="4" height='8'></td>
                           </tr>
                        </table>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td>
                                 <div id="jqgrid">
                                    <table id="productSalePriceHistDivList"></table>
                                 </div>
                              </td>
                           </tr>
                           <tr>
                              <td height='8'></td>
                           </tr>
                        </table>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td align="center">
                                 <img id="productSalePriceSaveHistButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_ok.gif" style='border: 0;cursor: pointer;' />&nbsp;&nbsp;
                                 <img id="productSalePriceHistCloseButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border: 0;cursor: pointer;' />
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                  </tr>
                  <tr>
                     <td width="20" height="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" />
                     </td>
                     <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                     <td width="20">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" />
                     </td>
                  </tr>
               </table>
            </td>
         </tr>
      </table>
   </div>
</body>
</html>