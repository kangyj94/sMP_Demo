<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List" %>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-240 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String pSrcType 			= (String)request.getParameter("srcType") == null ?   "" : (String)request.getParameter("srcType");
	String pSrcProductInput 	= (String)request.getParameter("srcProductInput") == null ?   "" : (String)request.getParameter("srcProductInput");
	String pSrcCateId	        = (String)request.getParameter("srcCateId") == null ?   "" : (String)request.getParameter("srcCateId");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<!-- 버튼 이벤트 스크립트 -->                                                                                                                                                                   
<script type="text/javascript">                    
var jq = jQuery;                                   
$(document).ready(function() {                     
	$("#cartAdd").click( function() { fnAddCart(); });
	$("#interestGoodDel").click( function() { 	fnInterestGoodDel();	});	
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
});

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);      
	$("#list").setGridWidth(<%=listWidth %>);        
}).trigger('resize');               
</script>                                          

<script type="text/javascript">   
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/buyWishListJQGrid.sys',
		editurl: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",	//활성화된 컬럼정보을 가지고 오기 위한 Dummy controller
		datatype: 'json',
		mtype: 'POST',
		colNames:['선택','상품명','표준규격','상품규격','이미지','상품코드','공급사','고객사상품코드','단위','단가','수량','금액','ord_unlimit_quan','disp_good_id','origin_disp_good_id'],
		colModel:[                                                                                                        
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,
				editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter
			},	//선택
			{name:'good_name',index:'good_name',width:200,align:"left",search:false,sortable:true,
				editable:false
			},	//상품명
			{name:'good_st_spec_desc',index:'good_st_spec_desc',width:250,align:"left",search:false,sortable:false,
				editable:false,hidden:true 
			},//표준규격
			{name:'good_spec_desc',index:'good_spec_desc',width:350,align:"left",search:false,sortable:false,
				editable:false
			},  //상품규격
			{name:'small_img_path',index:'small_img_path',width:38,align:"",search:false,sortable:false,
				editable:false
			},	//이미지                                            
			{name:'good_iden_numb',index:'good_iden_numb',width:75,align:"center",search:false,sortable:true,
				editable:false
			},	//상품코드                                                     
			{name:'borgnm',index:'borgnm',width:100,align:"left",search:false,sortable:true,
				editable:false
			},	//공급사                                                       
			{name:'cust_good_iden_numb',index:'cust_good_iden_numb',width:75,align:"left",search:false,sortable:false,
				editable:false
			},	//고객사 상품코드                                                     
			{name:'orde_clas_code',index:'orde_clas_code',width:60,align:"center",search:false,sortable:false,
				editable:false
			},	//단위                                                         
			{name:'sell_price',index:'sell_price',width:80,align:"right",search:false,sortable:true,
				editable:false,formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//단가                                                         
			{name:'ord_quan',index:'ord_quan', width:60,align:"right",search:false,sortable:false,
					editable:true,formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },
				editoptions:{
					dataInit:function(elem){
						$(elem).numeric();
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "right");
					},
					dataEvents:[{
						type:'change',
						fn:function(e){
							if(e.keyCode!=37 && e.keyCode!=39) {
								var rowid = (this.id).split("_")[0];
								var selrowContent = jq("#list").jqGrid('getRowData',rowid);
								var sell_price 	= Number(selrowContent.sell_price);
								var ordCnt     	= Number(this.value);
								var limitedOrdCnt = Number(selrowContent.ord_unlimit_quan);
										
								var msg = ''; 
								msg += '\n sell_price value ['+sell_price+']'; 
								msg += '\n ordCnt value ['+ordCnt+']'; 
								msg += '\n limitedOrdCnt value ['+limitedOrdCnt+']'; 
								
								if (ordCnt < limitedOrdCnt ){
									alert('최소 주문 수량 보다 주문수량이 작을수 없습니다.'); 
									this.value = limitedOrdCnt;
									jq("#list").restoreRow(rowid);
									jq("#list").jqGrid('setRowData', rowid, {total_amout:(sell_price*limitedOrdCnt),ord_quan:limitedOrdCnt});
									jq("#list").editRow(rowid);
								}else{
									
									jq("#list").jqGrid('setRowData', rowid, {total_amout:(sell_price*ordCnt)});
								}
							}
						}
					}]	// 값 변화시 호출되는 메소드 
   				}
			},	//수량           
			{name:'total_amout',index:'total_amout',width:60,align:"right",search:false,sortable:false,
				editable:false,formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},	//금액
			{name:'ord_unlimit_quan',index:'ord_unlimit_quan',align:"center",hidden:true,search:false
			},	//ord_unlimit_quan
			{name:'disp_good_id',index:'disp_good_id',align:"center",hidden:true,search:false},	//disp_good_id
			{name:'origin_disp_good_id',index:'origin_disp_good_id',align:"center",hidden:true,search:false}	//orgin_disp_good_id
			
		],
		postData: {
			srcType:'<%=pSrcType%>', 
			srcProductInput:'<%=pSrcProductInput%>',
			srcCateId:'<%=pSrcCateId%>'
		},multiselect: false,                                                                        
		rowNum:30, 
		rownumbers: true, 
		rowList:[30,50,100], 
		pager: '#pager',                                                                                     
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),                                                                                                                
		sortname: '', sortorder: '',                                                                                                                            
		caption:"관심상품",                                                                                                                                     
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
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
	                         //prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
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
	            }
		},                                                                                                                            
		onSelectRow: function (rowid, iRow, iCol, e) {},                                                                                                        
		ondblClickRow: function (rowid, iRow, iCol, e) {},                                                                                                      
		onCellSelect: function(rowid, iCol, cellcontent, target){},                                                                                             
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },                                                                               
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});                                                                                                                                                       
});            
</script>
<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/**
 * list 체크박스 포맷제공
 */
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' onclick=\"fnChangeEdit(this , '" + options.rowId + "', this);\" offval='no' />";
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
// 장바구니 이동!
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
			    
			    disp_good_id_Array[arrRowIdx] =	selrowContent.disp_good_id ; 
			    ord_quan_Array[arrRowIdx]	  =	selrowContent.ord_quan ;
			    stand_order_date_Array[arrRowIdx]   = selrowContent.stand_order_date ;
			    
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			$('#dialogSelectRow').html('<p>선택된 상품 정보가 없습니다. \n확인후 이욯사기 바랍니다.</p>');
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
				if(fnAjaxTransResult(arg)) {	//성공시
					
					if(!confirm("장바구니 페이지로 이동하시겠습니까?")) {
						jq("#list").trigger("reloadGrid");
					}else {
						$('#frm').attr('action','/order/cart/cartMstInfo.sys');
   						$('#frm').attr('Target','_self');
   						$('#frm').attr('method','post');
   						$('#frm').submit();
					}
				}
			}
		);
	}
}

/**
 * 관심품목 삭제 
 */
function fnInterestGoodDel(){
	var rowCnt = jq("#list").getGridParam('reccount');
	 
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		var disp_good_id_Array = new Array(); 

		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
				jq('#list').saveRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
// 				disp_good_id_Array[arrRowIdx] =	selrowContent.disp_good_id ;
				disp_good_id_Array[arrRowIdx] =	selrowContent.origin_disp_good_id;
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq( "#dialogSelectRow" ).dialog();
			return; 
		}
		if(!confirm("선택상품을 관심 상품에서 삭제 하시겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/product/delInterestProductTransGrid.sys",
			{disp_good_id_array:disp_good_id_Array}
			,function(arg){ 
				if(fnAjaxTransResult(arg)) {	//성공시
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
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
				if(fnAjaxTransResult(arg)) {	//성공시
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
	var colLabels = ['상품명','상품규격','상품코드','공급사','단위','단가','수량','금액'];	        //출력컬럼명
	var colIds = ['good_name','good_spec_desc','good_iden_numb','borgnm','orde_clas_code','sell_price','ord_quan','total_amout'];	//출력컬럼ID
	var numColIds = ['sell_price','ord_quan','total_amout'];	//숫자표현ID
	var sheetTitle = "관심상품";	//sheet 타이틀
	var excelFileName = "wishList";	//file명
	
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
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "";
	var manualPath = "";
	//관심상품
	header = "관심상품";
	manualPath = "/img/manual/branch/buyWishList.jpg";

	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
	<form id="frm" name="frm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
							</td>
							<td height="29" class="ptitle">관심상품
								&nbsp;<span id="question" class="questionButton">도움말</span>
							</td>
							<td align="right" class="ptitle"></td>
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
							<td colspan="4" class="table_top_line"></td>
						</tr>
						<tr>
							<td colspan="4" height="1" bgcolor="eaeaea"></td>
						</tr>
					</table>
					<!-- 컨텐츠 끝 -->
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td align="right" valign="bottom">
                <img id="cartAdd" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type1_cartAdd1.gif" width="125" height="22" style="cursor: pointer;" />
                <img id="interestGoodDel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_selectDelete.gif" width="75" height="22" style="cursor: pointer;" />
                <img id="colButton" src="/img/system/icon/Equipment.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
                <img id="excelButton" src="/img/system/icon/Table.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
					<!-- <span id="detButton">상품상세</span> -->
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
		<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
			<p>처리할 데이터를 선택 하십시오!</p>
		</div>
		<!-------------------------------- Dialog Div Start -------------------------------->
		<!-------------------------------- Dialog Div End -------------------------------->
	</form>
</body>
</html>