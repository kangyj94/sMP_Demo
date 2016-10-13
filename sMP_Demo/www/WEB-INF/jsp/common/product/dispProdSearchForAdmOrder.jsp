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
    List<CategoryDto> buyerCategoryDto = (List<CategoryDto>) request.getAttribute("buyerCategoryDto");      //고객사 진열카테고리
    String isMultiSel = (String)request.getAttribute("isMultiSel");                                         //다중선택여부 
   String groupId  = request.getAttribute("groupId")  != null ? (String)request.getAttribute("groupId")  : "" ; 
   String clientId = request.getAttribute("clientId") != null ? (String)request.getAttribute("clientId") : "" ;
   String branchId = request.getAttribute("branchId") != null ? (String)request.getAttribute("branchId") : "" ;
   String branchNms = request.getAttribute("branchNms") != null ? (String) request.getAttribute("branchNms") : "" ;
   String vendorid = request.getAttribute("vendorid") != null ? (String) request.getAttribute("vendorid") : "" ;
   boolean srcIsCen = request.getAttribute("srcIsCen") != null ? true : false ;
   
	boolean isLimit = false;
	if (userInfoDto.getIsLimit() != null && userInfoDto.getIsLimit().equals("1")) {
		isLimit = true;
	}  // 주문제한 여부
   
    boolean isAdm = false;
    if(userInfoDto.getSvcTypeCd().equals("ADM")){
    	isAdm = true;
    }
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
    buyerCategoryDto = new dTree('buyerCategoryDto','');
	buyerCategoryDto.config.folderLinks = true;
	
<%

	if(buyerCategoryDto != null && buyerCategoryDto.size() > 0){
		for(int i = 0 ; i < buyerCategoryDto.size() ; i++){
			CategoryDto dto = buyerCategoryDto.get(i);
%>
			var cateId = '<%=dto.getCate_Id() %>';
			var cateLv = '<%=dto.getCate_Level() %>';
			var cateFnm = '<%=dto.getFull_Cate_Name()%>';
			var cateNm = '<%=dto.getMajo_Code_Name() %>';
			var cateSeq = '<%=dto.getRef_Cate_Seq() %>';
			var url = "javaScript:void(0);fnChoiceStandardCategory('" + cateId + "','" + cateLv + "','"+cateFnm+"','"+cateNm+"');";
            buyerCategoryDto.add(cateId ,cateSeq ,cateNm ,url,'');			
<%			
		}
%>
		$('#categoryTab_0').append(""+buyerCategoryDto+"");
<%		
	}
%>
	
	
    $("#btnEraseCategory").click( function() { fnEraseCategory(); });
    $("#btnSelect").click(  function() { fnSelectProduct(); });
    $("#btnClose").click(   function() { fnCloseProductPop(); });
    
    $('#btnSearch').click(function() { fnSearch(); });
    $(window).bind('resize', function() {
        $("#list").setGridHeight(<%=listHeight %>);
        $("#list").setGridWidth(<%=listWidth %>);
    }).trigger('resize');
    //fnInitCategoryInfo();
});

// 카테고리 선택시 초기화 
function fnChoiceStandardCategory(cateId,cateLev,cateFullName,cateName) {
	$('#srcMajoCodeName').val(cateFullName); 
    $('#srcCateId').val(cateId);
}

// 조회 버튼 클릭시 발생 이벤트 
function fnSearch() {
    jq("#list").jqGrid("setGridParam", {"page":1});
    var data = new Object();
    data.srcCateId = $('#srcCateId').val();
    data.srcProductName = $('#srcProductName').val();
    data.srcGoodSpecDesc = $('#srcGoodSpecDesc').val();
    data.srcProductCode = $('#srcProductCode').val();
    jq("#list").jqGrid("setGridParam", { "postData": data });
    jq("#list").trigger("reloadGrid");
}

// 카테고리 정보를 초기화 
function fnEraseCategory(){
    $('#srcMajoCodeName').val(''); 
    $('#srcCateId').val('');
}

// 다중선택 여부 설정 
function fnSetMultiSelectEnable(){
     
    if('<%=isMultiSel%>' == '0'){
        // 단일 셀랙트
        jQuery("#list").setGridParam({multiselect:false}).hideCol('cb');    
    }else {
        // 멀티 셀랙트 
        jQuery("#list").setGridParam({multiselect:true}).showCol('cb'); 
        jQuery("#list").setGridParam({multiselect:false});
    }
}


// 선택 
function fnSelectProduct(){
    var msg = ''; 
    msg += 'type of value ['+typeof($("#list").jqGrid('getGridParam','selarrrow'))+']';
    msg += '\n values ['+$("#list").jqGrid('getGridParam','selarrrow')+']';
//     alert(msg);
    
    if($.trim($("#list").jqGrid('getGridParam','selarrrow')) == ''){
        alert('선택된 데이터가 없습니다. 선택후 이용하시기 바랍니다.');
        return; 
    }
    
    var selIds = $.trim($("#list").jqGrid('getGridParam','selarrrow')).split(",");
    var rtnObj = new Object();
    var rtnArrayObj = new Array();
    for(var idx = 0 ; idx < selIds.length ; idx ++){
        var data = jq("#list").jqGrid('getRowData',selIds[idx]);
        rtnArrayObj.push(data);
    }
	opener.productList(rtnArrayObj);
//     rtnObj.isSuccess = "success";
//     rtnObj.objs = rtnArrayObj;
//     window.returnValue=rtnObj;
    
    top.close();
}

// 닫기 
function fnCloseProductPop(){
    var rtnObj = new Object();
    rtnObj.isSuccess = "none";
    window.returnValue=rtnObj;
    top.close();
}

//
function fnGoOrderList(){
    window.dialogArguments.fnGoOrderList();
}

function fnOpenPastProdDiv(disp_good_id){
<%if(isLimit){%>
        alert("주문제한이 되어 주문을 할 수 없습니다.\n관리자에게 문의바랍니다.");
        return;
<%}%>
    $('#disp_good_id').val(disp_good_id); 
    fnOpenPastProductInfoDial();
}
</script>

<%
/**------------------------------------ 과거상품 검색 팝업 시작 ---------------------------------
* fnOpenPastProductInfoDial() 을 호출하여 Div팝업을 Display ===
*/
%>
<%@ include file="/WEB-INF/jsp/product/product/buyPastProductInfo.jsp" %>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
	var jq = jQuery;
	jq(function() {
		jq("#list").jqGrid({
			url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/buyProductListByAdmJQGrid.sys',
			datatype: "json",
			mtype: "POST",
			colNames:['상품코드','상품명','표준규격','상품규격','이미지','단위',
<%	if(isAdm){	%>
					'공급사','판매단가',
<%	}	%>
					'매입단가','수량',
<%	if(isAdm){	%>
					'판매금액',
<%	}	%>
					'매입금액','ord_unlimit_quan','disp_good_id',
                  	'고거상품주문','good_inventory_cnt','good_clas_code','deli_mini_day','stan_deli_day','deli_mini_quan','vendorid','과거상품주문'
                  ],
			colModel:[
				{name:'good_iden_numb',index:'good_iden_numb',width:75,align:"left",search:false,sortable:true,editable:false},
				{name:'good_name',index:'good_name',width:100,align:"left",search:false,sortable:true,editable:false},
				{name:'good_st_spec_desc',index:'good_st_spec_desc',width:180,align:"left",search:false,sortable:false,editable:false,hidden:true },//표준규격
				{name:'good_spec_desc',index:'good_spec_desc',width:160,align:"left",search:false,sortable:false,editable:false},
				{name:'small_img_path',index:'small_img_path',width:37,align:"center",search:false,sortable:false,editable:false },//이미지
				{name:'orde_clas_code',index:'orde_clas_code',width:60,align:"center",search:false,sortable:false,editable:false},
<%	if(isAdm){%>
				{name:'borgnm',index:'borgnm',width:100,align:"left",search:false,sortable:true,editable:false},
				{name:'sell_price',index:'sell_price',width:80,align:"right",search:false,sortable:true,editable:false,formatter:'integer',
						formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
<%	}%>
				{name:'sale_unit_pric',index:'sale_unit_pric',width:80,align:"right",search:false,sortable:true,editable:false,formatter:'integer',
						formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
				{name:'ord_quan',index:'ord_quan', width:60,align:"right",search:false,sortable:false,editable:true,formatter:'integer',
                        formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
<%	if(isAdm){%>
				{name:'total_amout',index:'total_amout',width:60,align:"right",search:false,sortable:false,editable:false,formatter:'integer',
                        formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
				},
<%	}%>
				{name:'total_amout_sale_unit_pric',index:'total_amout_sale_unit_pric',width:60,align:"right",search:false,sortable:false,editable:false,formatter:'integer',
                        formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
				},
				{name:'ord_unlimit_quan',index:'ord_unlimit_quan',align:"center",hidden:true,search:false}, //minOrderCnt
				{name:'disp_good_id',index:'disp_good_id',align:"center",hidden:true,search:false,key:true},
				{name:'isdisppastgood',index:'isdisppastgood',hidden:true},
				{name:'good_inventory_cnt',index:'good_inventory_cnt',hidden:true},
				{name:'good_clas_code',index:'good_clas_code',hidden:true},
				{name:'deli_mini_day',index:'deli_mini_day',hidden:true},
				{name:'stan_deli_day',index:'stan_deli_day',hidden:true},
				{name:'deli_mini_quan',index:'deli_mini_quan',hidden:true},
				{name:'vendorid',index:'vendorid',hidden:true},
				{name:'btnPastProductReq',index:'btnPastProductReq',hidden:true,width:'100px'}
			], 
            postData: {
                groupid:'<%=groupId%>'
                ,clientid:'<%=clientId%>'
                ,branchid:'<%=branchId%>'
                ,vendorid:'<%=vendorid%>'
                ,srcProductName:$('#srcGoodName').val()
                ,srcGoodSpecDesc:$('#srcGoodSpecDesc').val()
                ,srcCateId:$('#srcCateId').val()
<%if(srcIsCen){%>                
                ,srcIsCen:'true'
<%}%>                
            },
            rowNum:30,rownumbers:false,rowList:[30,50,100,500,1000],pager:'#pager',
            height:<%=listHeight%>,width:724,
            sortname:'good_Name',sortorder:'desc',
            caption:"상품정보",
            multiselect:true,
            viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
            loadComplete:function() {
            	
            	// 품목 표준 규격 설정
                var prodStSpcNm = new Array();
                <% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
                    prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
                <% } %>
                
                // 품목 규격 설정 
                var prodSpcNm = new Array();
               <% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
                    prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
               <% }                                                                       %>
                
                var rowCnt = jq("#list").getGridParam('reccount');
                for(var idx=0; idx<rowCnt; idx++) {
                    var rowid = $("#list").getDataIDs()[idx];
                    
                    jq("#list").restoreRow(rowid);
                    var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                    
//                  // 규격 화면 로드 
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
                        if(argArray[jIdx] > ' ') {
                             if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
                             else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
                        }
                    }
                    prodStSpec += prodSpec;
                    
                    jQuery('#list').jqGrid('setRowData',rowid,{good_spec_desc:prodStSpec});
                    
//                  // img 화면 로드 
                    var imgTag = ""; 
                    if($.trim(selrowContent.small_img_path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_img_path+"' style='width:30px;height:30px;' />"; 
                    else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:30px;height:30px;' />";
                    jQuery('#list').jqGrid('setRowData',rowid,{small_img_path:imgTag});
                    
                    
                    // 과거상품 주문 
                    var btnPastProductReq = "";
                    if($.trim(selrowContent.isdisppastgood) == '1'){
                        btnPastProductReq = "<input style='height:22px;width:100px;' type='button' value='과거상품주문' onclick=\"fnOpenPastProdDiv('"+selrowContent.disp_good_id+"');\" />";
                    }else{
                        btnPastProductReq = "";
                    } 
                        
                    jQuery('#list').jqGrid('setRowData',rowid,{btnPastProductReq:btnPastProductReq});
                }
                
//              fnSetMultiSelectEnable(); 
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
                <input type="hidden" id="groupId"   name="groupId"  value="<%=groupId%>" />
                <input type="hidden" id="clientId"  name="clientId" value="<%=clientId%>" />
                <input type="hidden" id="branchId"  name="branchId" value="<%=branchId%>" />
                <input type="hidden" id="branchNms"  name="branchNms" value="<%=branchNms%>" />
                <input type="hidden" id="vendorid"  name="vendorid" value="<%=vendorid%>" />
                <input type="hidden" id="orde_user_id"  name="orde_user_id"   value="<%=userInfoDto.getUserId() %>" />
                <input type="hidden" id="disp_good_id"  name="disp_good_id" value="" />
                <input type="hidden" id="svcTypeCd" name="svcTypeCd" value="<%= userInfoDto.getSvcTypeCd() %>" />
                
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
            <td width="200px" valign="top">
                <!-- 타이틀 시작 -->
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr style="height: 22px">
                        <td width="20" valign="top">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" style="vertical-align: middle;" />
                        </td>
                        <td class="stitle">표준카테고리정보</td>
                        <td align="right" class="stitle">&nbsp;</td>
                    </tr>
                </table>
                <!-- 타이틀 끝 -->
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="table_top_line"></td>
                    </tr>
                    <tr>
                        <!--                   <td id="standardTd" style="padding: 5 0 10 5; vertical-align: top;"> -->
                        <!--                      <div id="categoryLeftDiv" style="TEXT-ALIGN: left; leftMargin: 0; padding: 5px 0px 10px 5px;"> -->
                        <!--                         <div id="categoryTab_0" class="dtree" style="display: block; padding: 0 0 0 0; overflow: auto; height: 480px">123</div> -->
                        <!--                      </div> -->
                        <!--                   </td> -->






                        <td id="standardTd" style="padding: 5 0 10 5; vertical-align: top;">
                            <div id="categoryLeftDiv" style="TEXT-ALIGN: left; leftMargin: 0; padding: 5px 0px 10px 5px;">
                                <!-------------------------------------------------------------------------------------->
                                <!-- 차트 타입 메뉴 구성 -->
                                <!-------------------------------------------------------------------------------------->
                                <div id=categoryTab_0 class="dtree" style="display: block; padding: 0 0 0 0; overflow-y: scroll; width: 200px; height: 450px;"></div>
                            </div>
                        </td>

                    </tr>
                </table>
            </td>
            <td width="10px">&nbsp;</td>
            <td style="vertical-align: middle;">
                <!-- 타이틀 시작 -->
                <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px">
                    <tr style="height: 22px">
                        <td width="20" valign="top">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                        </td>
                        <td class="stitle">상품 검색조건</td>
                        <td align="right" class="stitle">
                            <span class="ptitle"> <img id="btnSearch" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" width="65" height="22" style="cursor:pointer;"/>
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
                            <input id="srcMajoCodeName" name="srcMajoCodeName" type="text" value="" size="20" maxlength="30" style="width: 350px; width: 90%" readonly="readonly" /> 
                            <input id="srcCateId" name="srcCateId" type="hidden" value="" readonly="readonly" />
                            <img id="btnEraseCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_clear.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" height='1' bgcolor="eaeaea"></td>
                    </tr>
                    <tr>
                        <td class="table_td_subject">상품명</td>
                        <td class="table_td_contents">
                        	<table>
                        		<tr>
                        			<td>
                        				<input id="srcProductName" name="srcProductName" type="text" value="" size="" maxlength="50" style="width: 280px;" />
                        			</td>
                        			<td class="table_td_subject">상품코드</td>
                        			<td>
                        				<input id="srcProductCode" name="srcProductCode" type="text" value="" size="" maxlength="20" style="width: 150px;" />
                        			</td>
                        		</tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" height='1' bgcolor="eaeaea"></td>
                    </tr>
                    <tr>
                        <td class="table_td_subject">상품규격</td>
                        <td class="table_td_contents">
                            <input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" style="width: 350px; width: 90%" />
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
                        <td>
                            <div id="jqgrid">
                                <table id="list"></table>
                                <div id="pager"></div>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td>&nbsp;</td>
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