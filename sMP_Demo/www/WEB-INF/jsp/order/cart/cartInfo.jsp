<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.order.dto.CartMasterInfoDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.UserDto"%>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%
	//그리드의 width와 Height을 정의
	CartMasterInfoDto cartInfoDto = null ; 
	cartInfoDto = (CartMasterInfoDto)request.getAttribute("cartMasterInfo");
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")
	List<UserDto> userList = (List<UserDto>) request.getAttribute("userList");
	String mana_user_name = "";
	String mana_user_id = "";
	if(userList.size() > 0){
		mana_user_name = userList.get(0).getUserNm();
		mana_user_id = userList.get(0).getUserId();
	}
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isBuilder = false;
	for(LoginRoleDto lrd: loginUserDto.getLoginRoleList()){
		if("BUY_BUILDER".equals(lrd.getRoleCd())){
			isBuilder = true;
		}
	}
	String listHeight = isBuilder ==true ? "$(window).height()-340 + Number(gridHeightResizePlus)-45" : "$(window).height()-435 + Number(gridHeightResizePlus)-45";
	String _menuId              = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String businessNum   = "";
	String orderAuthType = "";
	if(loginUserDto.getSmpBranchsDto() != null){
		businessNum   = CommonUtils.getString(loginUserDto.getSmpBranchsDto().getBusinessNum());
		orderAuthType = CommonUtils.getString(loginUserDto.getSmpBranchsDto().getOrderAuthType());
	}
	boolean isLimit = false;
	if (loginUserDto.getIsLimit() != null && loginUserDto.getIsLimit().equals("1")) {
		isLimit = true;
	}  // 주문제한 여부
	
	//선입금여부
	boolean prePay = false;
// 	if("BUY".equals(loginUserDto.getSvcTypeCd())){
// 		if("1".equals(loginUserDto.getSmpBranchsDto().getPrePay())){
// 			prePay = true;
// 		}
// 	}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<%  if(Constances.COMMON_ISREAL_SERVER) { %>
<%
/**------------------------------------공인인증 등록---------------------------------
  파라미터1 : 법인 (CLT), 공급사 (VEN)
  파라미터2 : 사용구분 (REG : 업체등록, ETC : 기타)
  파라미터3 : 공인인증서 인증상태 (0 : 등록, 1 : 생성, 2 : 무시), 공통함수사용
  파라미터4 : 사업자 등록번호 (인증상태값이 1인 경우에만 사용한다. 1이 아닌경우 '' 으로 넘긴다.)
  파라미터5 : CallBack function명
  파라미터6 : 조직ID (법인일경우 ClientId, 사업장일경우 VendorId) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<script type="text/javascript">
var authStep = "";
function fnAuth(){
<%if(isLimit){%>
	alert("주문제한이 되어 주문을 할 수 없습니다.\n관리자에게 문의바랍니다.");
	return;
<%}%>
	var orderAuthType = '<%=orderAuthType%>';
	if(orderAuthType == "10"){//공인인증
		//fnGetIsExistPublishAuth(svcTypeCd, borgId) - 현재 세션의 공인인증서 인증상태를 확인 (파라미터3 참조)
		authStep = fnGetIsExistPublishAuth('<%=loginUserDto.getSvcTypeCd()%>','<%=loginUserDto.getBorgId()%>');
		fnAuthBusinessNumberDialog("CLT", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=loginUserDto.getClientId()%>');   
	}else if(orderAuthType == "20"){//일반
		fnChkNormProduct();
	}
}

function fnCallBackAuthBusinessNumber(userDn) {
    if((userDn != "" && userDn != null) || authStep == "2"){
        fnChkNormProduct();
    }
}
</script>
<%  }else{ %>
<script type="text/javascript">
function fnAuth(){
<%		if(isLimit){%>
	alert("주문제한이 되어 주문을 할 수 없습니다.\n관리자에게 문의바랍니다.");
	return;
<%		}%>

    fnChkNormProduct();
}
</script>
<%  } %>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------배송지관리팝업 사용방법---------------------------------
* fnDeliveryAddressManageDialog(groupId, clientId, branchId, callbackString) 을 호출하여 Div팝업을 Display ===
* groupId : 고객사 그룹Id
* clientId : 고객사 법인Id
* branchId : 고객사 사업장Id
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 2개(우편번호, 주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/deliveryAddressManageDiv.jsp" %>
<!-- 배송지관리팝업 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
    $("#btnAddDeliveryAddress").click(function(){
        fnDeliveryAddressManageDialog("<%=loginUserDto.getGroupId() %>","<%=loginUserDto.getClientId() %>","<%=loginUserDto.getBorgId() %>","fnCallBackDeliveryAddressManage"); 
    });
    
    $("#orderRequestButton").click(function(){
        fnAuth();   
//      fnChkNormProduct();
    });
});
/**
 * 배송지관리팝업검색 후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressManage(deliId) {
	if(deliId != undefined){
		fnSelectBoxAddressInfo(deliId);
	}else{
        fnGetBuyAddressInfo(deliId);
	}
}
function fnSelectBoxAddressInfo(deliId) {
    $("#tran_deta_addr_seq").val(deliId);
}
</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#firstattachseq").val(), "fnCallBackAttach1"); });
	$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2"); });
	$("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#thirdattachseq").val(), "fnCallBackAttach3"); });
});
/**
 * 첨부파일1 파일관리
 */
function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#firstattachseq").val(rtn_attach_seq);
	$("#attach_file_name1").text(rtn_attach_file_name);
	$("#attach_file_path1").val(rtn_attach_file_path);
}
/**
 * 첨부파일2 파일관리
 */
function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#secondattachseq").val(rtn_attach_seq);
	$("#attach_file_name2").text(rtn_attach_file_name);
	$("#attach_file_path2").val(rtn_attach_file_path);
}
/**
 * 첨부파일3 파일관리
 */
function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	$("#thirdattachseq").val(rtn_attach_seq);
	$("#attach_file_name3").text(rtn_attach_file_name);
	$("#attach_file_path3").val(rtn_attach_file_path);
}
/**
 * 파일다운로드
 */
function fnAttachFileDownload(attach_file_path) {
	var url = "/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}
jQuery.download = function(url, data, method){
	// url과 data를 입력받음
	if( url && data ){ 
		// data 는  string 또는 array/object 를 파라미터로 받는다.
		data = typeof data == 'string' ? data : jQuery.param(data);
		// 파라미터를 form의  input으로 만든다.
		var inputs = '';
		jQuery.each(data.split('&'), function(){ 
			var pair = this.split('=');
			inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
		});
		// request를 보낸다.
		jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>').appendTo('body').submit().remove();
	};
};
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>


<!-- 버튼 이벤트 스크립트 정의 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#delButton").click( function() { fnDeleteCateProduct(); });
	$("#excelButton").click(function(){ exportExcel(); });
	fnGetBuyAddressInfo();
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var lastSelectSelIdx; 
jq(function() {
	jq("#list").jqGrid({
		url:'/order/cart/cartProdInfo.sys',
		editurl: '/order/cart/CartProductInfoByBuyerTransGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['상품명','표준규격','상품규격','이미지','상품코드','공급사','고객사상품코드','단위'<%if(!isBuilder){%>,'단가'<%}%>,'주문수량'<%if(!isBuilder){%>,'주문금액'<%}%>,
		          '표준납기일','납기희망일','상품삭제','deli_mini_quan' , 'disp_good_id','상품구분', 'vendorid','original_img_path','isDistribute','is_add_good'],
		colModel:[
			{name:'good_name'     , index:'good_name'     ,width:210,align:"center",search:false,sortable:false, align:"left",editable:false },
			{name:'good_st_spec_desc',index:'good_st_spec_desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },//표준규격
			{name:'good_spec_desc',index:'good_spec_desc' ,width:180,align:"left",search:false,sortable:false, align:"left",editable:false },
			{name:'small_img_path',index:'small_img_path' ,width:35,align:"center",search:false,sortable:false, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb' ,width:75,align:"center",search:false,sortable:false, editable:false },
			{name:'borgnm'        ,index:'borgnm'         ,width:100,align:"center",search:false,sortable:false, align:"left",editable:false },
			{name:'cust_good_iden_numb',index:'cust_good_iden_numb' ,width:75,align:"center",search:false,sortable:false, align:"left",editable:false },
			{name:'orde_clas_code',index:'orde_clas_code' ,width:50,align:"center",search:false,sortable:false, align:"center",editable:false },
<%if(!isBuilder){%>
			{name:'sell_price'    ,index:'sell_price'     ,width:80,align:"center" , search:false,sortable:false, align:"right", editable:false
				,formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
<%}%>
			{name:'orde_requ_quan',index:'orde_requ_quan', width:60,align:"right",search:false,sortable:false, editable:true,formatter: 'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },
				editoptions:{
					maxlength:7,
					dataInit:function(elem){
						$(elem).numeric();
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "right");
					},  
					dataEvents:[{
						type:'change',
						fn:function(e){
							var rowid = (this.id).split("_")[0];
							var selrowContent = jq("#list").jqGrid('getRowData',rowid);
							var inputVal = Number(this.value);                      // 입력 수량 
							var miniVal = Number(selrowContent.deli_mini_quan); // 상품 최초 구매 수량 
							var sellPrice = Number(selrowContent.sell_price);   // 상품 최초 구매 수량
							var msg = ""; 
							msg += "\n inputVal value =["+inputVal+"]";
							msg += "\n miniVal value =["+miniVal+"]";
							//alert(msg); 
							if(inputVal<miniVal){
								alert("최소주문수량 이하는 신청할 수 없습니다.\n해당 상품의 최소수량은 "+miniVal+" 입니다.");
								jq("#list").restoreRow(rowid);
								jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:miniVal,totalamount:(miniVal*sellPrice)});
								jq('#list').editRow(rowid,true);
							}else {
								jq("#list").restoreRow(rowid);
								jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:inputVal,totalamount:(inputVal*sellPrice)});
								jq('#list').editRow(rowid,true);
							}
							fnSelectAmountSum();
						}
					}]
				}
			},
<%if(!isBuilder){%>
			{name:'totalamount'   ,index:'totalamount'    ,width:70,align:"center",search:false,sortable:false, align:"right", editable:false 
				,formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
<%}%>
			{name:'stan_deli_day' ,index:'stan_deli_day'  ,width:100,align:"center",search:false,sortable:false, align:"center",editable:false },
			{name:'requ_deli_date',index:'requ_deli_date',width:120,align:"center",search:false,sortable:false,
				formatter: 'text',
				editable:true,edittype: 'text',
				editoptions: {
					size: 9,maxlengh: 10,dataInit: function (element) {
					$(element).datepicker({ dateFormat: 'yy-mm-dd' });
				},
				dataEvents:[{
					type:'change',
					fn:function(e){
						if(e.keyCode==13) return;
						var inputValue = this.value;                                            // 입력 날짜
						var rowid = (this.id).split("_")[0];
						jq("#list").restoreRow(rowid);
						jq("#list").jqGrid('setRowData', rowid, {requ_deli_date:inputValue});
						jq('#list').editRow(rowid);
					}
				}]
				},
				editrules: {date: false}
			},//납품요청일
			{name:'btn', index:'btn', width:80,align:"center", search:false,sortable:false, align:"left",editable:false}, 
			{name:'deli_mini_quan', index:'deli_mini_quan', width:210,align:"center",search:false,sortable:false, align:"left", editable:false, hidden:true}, 
			{name:'disp_good_id', index:'disp_good_id', width:210,align:"center", search:false, sortable:false, align:"left", editable:false, hidden:true},
			{name:'good_clas_code', index:'good_clas_code', width:40,align:"center", search:false, sortable:false, align:"left",editable:false, hidden:true},
			{name:'vendorid', index:'vendorid', hidden:true},
			{name:'original_img_path', index:'original_img_path', hidden:true, search:false },	//original_img_path
			{name:'isDistribute', index:'isDistribute', hidden:true, search:false },	//isDistribute
			{name:'is_add_good', index:'is_add_good', hidden:true, search:false }	//is_add_good
			
		],rowNum:0,
		postData: {},
		multiselect: true,
		onSelectAll: function(aRowids, status) {
			fnSelectAmountSum();
		},//체크박스 전체선택
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname: '', sortorder: '',
		caption:"장바구니상품",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					jq("#list").restoreRow(rowid);
					var inputBtn = "<input style='height:22px;width:80px;' type='button' value='상품삭제' onclick=\"fnDeleteCateProductByButton('"+rowid+"');\" />"; 
					jQuery('#list').jqGrid('setRowData',rowid,{btn:inputBtn});
				}
				fnSelectAmountSum();
			} 
			// 품목 표준 규격 설정
			var prodStSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {%>
				prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
			<% } %>
			// 품목 규격 property 추출
			var prodSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {%>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
			<% } %>
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
							if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
							else prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
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
		onSelectRow: function (rowid, iRow, iCol, e) {
			var msg =""; 
			msg += '\n rowid value['+rowid+']';
			msg += '\n iRow  value['+iRow +']';
			msg += '\n iCol  value['+iCol +']';
			//alert (msg );
			if(rowid && rowid!==lastSelectSelIdx){
				jQuery('#list').jqGrid('restoreRow',lastSelectSelIdx);
				jQuery('#list').jqGrid('editRow',rowid,true);
				lastSelectSelIdx=rowid;
			} 
			//장바구니 multiselect 체크한 상품합계
			fnSelectAmountSum();
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'}); 
			
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var isDistribute = selrowContent.isDistribute;
			var is_add_good = selrowContent.is_add_good;
			if(isDistribute!=0 && is_add_good==0) {
				jq("#list").jqGrid('setRowData', rowid, {borgnm:'SK텔레시스'});
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},                                                                                                      
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = $("#list").jqGrid('getGridParam','colModel');
			if(cm[iCol]!=undefined && (cm[iCol].index == 'good_name' )){
				var mstDatas = $("#list").jqGrid('getRowData',rowid);
				fnCustProductDetailView('<%=_menuId%>', mstDatas['disp_good_id']);
			}
			if(cm[iCol]!=undefined && (cm[iCol].index == 'small_img_path')){
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				var orgImgPath = selrowContent.original_img_path;
				if($.trim(orgImgPath).length > 0){
					window.open("<%=Constances.SYSTEM_IMAGE_PATH%>/" + orgImgPath, '','scrollbars=yes, status=no, resizable=yes');
				}
			}
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell", userdata:"userdata"},
<%if(!isBuilder){%>
		footerrow: false,
		userDataOnFooter: true
<%}%>
	});
});
</script>

<!-- 이벤트 처리 스크립트 -->
<script type="text/javascript">
function exportExcel() {
	var colLabels = ['상품명','상품규격','상품코드','공급사','고객사상품코드','단위'<%if(!isBuilder){%>,'단가'<%}%>,'주문수량'<%if(!isBuilder){%>,'주문금액'<%}%>,'표준납기일','납기희망일'];
	var colIds =['good_name', 'good_spec_desc', 'good_iden_numb', 'borgnm', 'cust_good_iden_numb', 'orde_clas_code'<%if(!isBuilder){%>, 'sell_price'<%}%>, 'orde_requ_quan'<%if(!isBuilder){%>, 'totalamount' <%}%>  , 'stan_deli_day' , 'requ_deli_date'];
	var numColIds = [<%if(!isBuilder){%>'sell_price',<%}%> 'orde_requ_quan'<%if(!isBuilder){%>, 'totalamount'<%}%>];
	var sheetTitle = "장바구니";	//sheet 타이틀
	var excelFileName = "CartInfo";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
//3자리수마다 콤마
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

// function fnTotalAmountSum() {
// 	var rowCnt = jq("#list").getGridParam('reccount');
// 	var SumTotalamount = 0;
	
// 	var SumTotalSurtax = 0; /* 공급가액+부가세 */
// 	var Surtax = 0;	/* 부가세*/
	
// 	if(rowCnt>0) {
// 		for(var i=0; i<rowCnt; i++) {
// 			var rowid = $("#list").getDataIDs()[i];
// 			SumTotalamount += Number(jq("#list").jqGrid('getRowData',rowid).totalamount); 
// 		}
// 	}
	
// 	Surtax = Math.floor(SumTotalamount*0.1);	/* 부가세(b) */
// 	SumTotalSurtax = Math.floor(SumTotalamount+Surtax);		/* 공급가액(a)+부가세(b) */
	
// 	SumTotalamount = fnComma(SumTotalamount)+" 원";
// 	SumTotalSurtax = fnComma(SumTotalSurtax)+" 원";
// 	Surtax = fnComma(Surtax)+" 원";
	
	
// 	jq("#list").jqGrid("footerData","set",{totalamount:SumTotalamount+" :: "+SumTotalSurtax+" :: "+Surtax,good_name:"주문합계"},false);
// 	$("#SumTotalamount").html(SumTotalamount);
// 	$("#SumTotalSurtax").html(SumTotalSurtax);
// 	$("#Surtax").html(Surtax);
	
	// jq("#list").jqGrid("footerData","set",{totalamount:SumTotalamount+"(부가세 포함:"+SumTotalSurtax+")",good_name:"공급가액(a)"},false);
	// jq("#list").jqGrid("footerData","set",{totalamount:SumTotalamount+"(부가세 포함:"+SumTotalSurtax+")",good_name:"부가세(b)"},false);
	// jq("#list").jqGrid("footerData","set",{totalamount:SumTotalamount+"(부가세 포함:"+SumTotalSurtax+")",good_name:"계(a+b)"},false);
// }

//장바구니 개별 합계
function fnSelectAmountSum() {
	var tempPric = 0;
	var SumTotalamount = 0;
	
	var SumTotalSurtax = 0; /* 공급가액+부가세 */
	var Surtax = 0;	/* 부가세*/
	var rowidArr = jq("#list").jqGrid('getGridParam', 'selarrrow');
	
	for(var i = 0; i<rowidArr.length; i++){
		tempPric += Number(jq("#list").jqGrid('getRowData', rowidArr[i]).totalamount);
		SumTotalamount += Number(jq("#list").jqGrid('getRowData', rowidArr[i]).totalamount);
		SumTotalSurtax += Number(jq("#list").jqGrid('getRowData', rowidArr[i]).totalamount);
		Surtax += Number(jq("#list").jqGrid('getRowData', rowidArr[i]).totalamount);
		
	}
	
	Surtax = Math.floor(SumTotalamount*0.1);	/* 부가세(b) */
	SumTotalSurtax = Math.floor(SumTotalamount+Surtax);		/* 공급가액(a)+부가세(b) */
	
	SumTotalamount = fnComma(SumTotalamount)+" 원";
	SumTotalSurtax = fnComma(SumTotalSurtax)+" 원";
	Surtax = fnComma(Surtax)+" 원";
	
	tempPric = " 금액 합계 : "+ fnComma(tempPric)+" 원 </b>";
	
	$("#total_amount").html(tempPric);
	$("#SumTotalamount").html(SumTotalamount);
	$("#SumTotalSurtax").html(SumTotalSurtax);
	$("#Surtax").html(Surtax);
}

// 삭제 버튼 클릭시 발생 이벤트 
function fnDeleteCateProduct() {
// 	var row = jq("#list").jqGrid('getGridParam','selrow');
// 	if (row == "" || row == null ){
// 		$('#dialogSelectRow').html('<p>상품선택후 이용하시기 바랍니다.</p>');
// 		$("#dialogSelectRow").dialog({
// 			title:'Warning',modal:true
// 		});
// 		return; 
// 	}
// 	fnDeleteTransaction(row);
	var id = $("#list").getGridParam('selarrrow');
	var ids = $("#list").jqGrid('getDataIDs');
	var disp_good_id_array = new Array();
	if(id.length <= 0) {
		$('#dialogSelectRow').html('<p>상품선택후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#srcBorgName").focus();
		return;
	}
	for(var i=0; i<ids.length; i++){
		var chkCnt = 0;
		for (var i = 0; i < ids.length; i++) {
			var check = false;
			$.each(id, function (index, value) {
				if (value == ids[i]){
					check = true;
				}
			});
			if(check){
				$('#list').saveRow(ids[i]);
				var selrowContent = $("#list").jqGrid('getRowData', ids[i]);
				disp_good_id_array[chkCnt] = selrowContent.disp_good_id;
				chkCnt++;
			}
		}
	}
	$.post(
		"/order/cart/delCartProdInfo.sys",
		{
			disp_good_id_array:disp_good_id_array
		},
		function(arg){
			if(fnAjaxTransResult(arg)){
				$("#list").trigger("reloadGrid");
			}
		}
	);
}

function fnDeleteCateProductByButton(rowIdx) {
	fnDeleteTransaction(rowIdx);
}

function fnDeleteTransaction(rowIdx) {
	if(rowIdx != null) {
		var selrowContent = jq("#list").jqGrid('getRowData',rowIdx);
		var disp_good_id = selrowContent.disp_good_id; 
		jq("#list").jqGrid( 
			'delGridRow',rowIdx, {
				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/cart/CartProductInfoByBuyerTransGrid.sys",
				delData:{ disp_good_id:disp_good_id },
				recreateForm:true,beforeShowForm:function(form) {
					$(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
				},
				reloadAfterSubmit:true,closeAfterDelete:true,
				afterSubmit:function(response, postdata) {
					return fnJqTransResult(response, postdata);
				}
			}
		);
	} else {
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
	}
}

// 장바구니 마스터 정보를 변경한다. 
function fnUpdateCartMstInfo() {
	var cons_iden_name = $("#cons_iden_name").val();// 주문명
	if($.trim(cons_iden_name) == "" ) {
		$('#dialogSelectRow').html('<p>주문명은 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#cons_iden_name").focus();
		return;
	}else{
		var consIdenName_regex = /([!@#$%^&''""])/;
		if(consIdenName_regex.test(cons_iden_name)){
			$("#dialog").html("<font size='2'>주문명에 특수문자[!@#$%^&'"+'"'+"]를 \n제거해 주세요.</font>");
			$("#dialog").dialog({
				title: 'Success',modal: true,
				buttons: {"Ok": function(){$(this).dialog("close");} }
			});
			return false; 
		}
	}
	
	var params; 
	var orde_requ_quan_arr = new Array();
	var disp_good_id_arr = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			jq('#list').saveRow(rowid);
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			orde_requ_quan_arr[i] = selrowContent.orde_requ_quan;
			disp_good_id_arr[i] = selrowContent.disp_good_id;
		} 
	}
	params = {
					comp_iden_name:$('#cons_iden_name').val()           // 주문명 
				,	orde_type_clas:$('#orde_type_clas').val()           // 주문유형
				,	tran_deta_addr_seq:$('#tran_deta_addr_seq').val()   // 배송지주소
				,	tran_user_name:$('#tran_user_name').val()           // 인수자
				,	tran_tele_numb:$('#tran_tele_numb').val()           // 인수자 전화번호
				,	mana_user_name:''
				,	orde_text_desc:$('#orde_text_desc').val()           // 비고 
				,	firstattachseq:$('#firstattachseq').val()           // 첨부파일
				,	secondattachseq:$('#secondattachseq').val()         // 첨부파일 
				,	thirdattachseq:$('#thirdattachseq').val()           // 첨부파일 
				,	orde_requ_quan_arr:orde_requ_quan_arr               // 요청수랑
				,	disp_good_id_arr:disp_good_id_arr
	};
	
	var msg  = ''; 
	for (var porpNm in params){
		msg += '\n '+porpNm+'=['+params[porpNm]+']';
	} 
	$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/cart/updateCartMstInfoTransGrid.sys", 
			params,
			function(arg){ 
				if(fnTransResult(arg, false)){
					alert('장바구니 항목이 변경 되었습니다.');
				}
			}
	);
}

//배송지 정보 조회
function fnGetBuyAddressInfo() {
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getDeliveryAddressByBranchId.sys',
		{
			groupId:'<%=loginUserDto.getGroupId() %>',
			clientId:'<%=loginUserDto.getClientId() %>',
			branchId:'<%=loginUserDto.getBorgId() %>'
		},
		function(arg){
			var deliveryListInfo = eval('(' + arg + ')').deliveryListInfo;
			$("#tran_deta_addr_seq").html("");
			for(var i=0;i<deliveryListInfo.length;i++) {
				if('<%=cartInfoDto.getTran_deta_addr_seq()%>' == deliveryListInfo[i].deliveryid ){
					$("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"' selected>"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");
				}else {
					$("#tran_deta_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"'>"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");    
				}
			}
		}
	);
}

//첨부파일 삭제
function fnAttachDel(file_list, columnName) {
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/order/cart/cartAttachDelete.sys",
        { groupId:'<%=loginUserDto.getGroupId() %>',clientId:'<%=loginUserDto.getClientId() %>',branchId:'<%=loginUserDto.getBorgId() %>' ,userId:'<%=loginUserDto.getUserId() %>'
        , file_list:file_list, columnName:columnName },
        function(arg){
            var result = eval('(' + arg + ')').customResponse;
            var errors = "";
            if (result.success == false) {
                for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
                alert(errors);
            } else {
                if(columnName=='firstattachseq') {
                    $("#firstattachseq").val('');
                    $("#attach_file_name1").text('');
                    $("#attach_file_path1").val('');
                    $("#btnAttachDel1").css("display","none");
                } else if(columnName=='secondattachseq') {
                    $("#secondattachseq").val('');
                    $("#attach_file_name2").text('');
                    $("#attach_file_path2").val('');
                    $("#btnAttachDel2").css("display","none");
                } else if(columnName=='thirdattachseq') {
                    $("#thirdattachseq").val('');
                    $("#attach_file_name3").text('');
                    $("#attach_file_path3").val('');
                    $("#btnAttachDel3").css("display","none");
                }
                alert("처리 하였습니다.");
            }
        }
    );
}

function fnChkNormProduct(){
//     fnOrderRequest();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var disp_good_id_array = new Array();
		var orde_requ_quan_array = new Array();
		var good_clas_code_array = new Array();
		var returnMsg = "";
		var chkCnt = 0;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			jq('#list').saveRow(rowid);
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			disp_good_id_array[i] = selrowContent.disp_good_id;
			orde_requ_quan_array[i] = selrowContent.orde_requ_quan;
			good_clas_code_array[i] = selrowContent.good_clas_code;
		}  
		fnOrderRequest();
//         $.post(
<%--             "<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/orderRequestStockCheck.sys",  --%>
//             {   
//                 disp_good_id_array:disp_good_id_array
//             },
//             function(arg){
//                 var stockQuanChkList = eval('(' + arg + ')').stockQuanChkList;
//                 for(var i=0;i<stockQuanChkList.length;i++) {
//                     for(var j=0;j<disp_good_id_array.length;j++) {
//                         if(disp_good_id_array[j] == stockQuanChkList[i].disp_good_id && good_clas_code_array[i] == '수탁' ){
//                         	var temp_orde_requ_quan = Number($.trim(orde_requ_quan_array[i]));
//                         	var temp_good_inventory_cnt = Number($.trim(stockQuanChkList[i].good_inventory_cnt));
//                         	if( temp_orde_requ_quan > temp_good_inventory_cnt){
//                                 returnMsg += "["+stockQuanChkList[i].vendor_name+"] 공급사의 ["+stockQuanChkList[i].good_name+"] 상품의 재고수량은 "+Number(stockQuanChkList[i].good_inventory_cnt) +" (으)로 주문요청 수량이 재고수량을 초과하였습니다.\n\n";
//                                 chkCnt++;
//                             }
//                         }
//                     }
//                 }
//                 if(chkCnt == 0){
//                     fnOrderRequest();
//                 }else{
//                     alert(returnMsg);
//                     fnTotalAmountSum();
//                 }
//             }
//         );
	} else {
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
    }
}
//주문 신청 버튼 클릭시
function fnOrderRequest(){
	var id = $("#list").getGridParam('selarrrow');
	var ids = $("#list").jqGrid('getDataIDs');
	if(id.length <= 0) {
		$('#dialogSelectRow').html('<p>장바구니에 상품 정보가 없습니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#srcBorgName").focus();
		return;
	}
	var groupid              = '<%=loginUserDto.getGroupId()%>';              // 그룹 ID
	var clientid             = '<%=loginUserDto.getClientId()%>';             // 법인 ID 
	var branchid             = '<%=loginUserDto.getBorgId()%>';               // 사업장 ID
	var cons_iden_name       = $("#cons_iden_name").val();                    // 주문명
	var orde_type_clas       = "10";                                          // 주문유형
	var orde_tele_numb       = $("#orde_tele_numb").val();                    // 주문자 전화번호
	var orde_user_id         = $("#orde_user_id").val();                      // 주문자 ID
	var tran_data_addr       = $("#tran_deta_addr_seq").val();                // 배송지주소
	var tran_user_name       = $("#tran_user_name").val();                    // 인수자
	var tran_tele_numb       = $("#tran_tele_numb").val();                    // 인수자 전화번호
	var adde_text_desc       = $("#orde_text_desc").val();                    // 비고
	var mana_user_name       = "";                                            // 감독명 
	var attach_file_1        = $("#firstattachseq").val();                    // 첨부파일1
	var attach_file_2        = $("#secondattachseq").val();                   // 첨부파일2
	var attach_file_3        = $("#thirdattachseq").val();                    // 첨부파일3
	var disp_good_id_array   = new Array();                                   // 진열 SEQ
	var orde_requ_quan_array = new Array();                                   // 주문수량
	var requ_deli_date_array = new Array();                                   // 납품요청일
	var good_name_array      = new Array();                                   // 상품명
	
	if($.trim(cons_iden_name) == "" ) {
		$('#dialogSelectRow').html('<p>주문명은 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#cons_iden_name").focus();
		return;
	}else{
		consIdenName_regex = /[!@#$%^&]/;
		if(consIdenName_regex.test(cons_iden_name)){
			$("#dialog").html("<font size='2'>주문명에 특수문자[!@#$%^&']를 \n제거해 주세요.</font>");
			$("#dialog").dialog({
				title: 'Success',modal: true,
				buttons: {"Ok": function(){$(this).dialog("close");} }
			});
			return false; 
		}
	}
	if($.trim(orde_user_id) == "" ) {
		$('#dialogSelectRow').html('<p>주문자정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#orde_user_id").focus();
		return;
	}

	if($.trim(tran_user_name) == "" ) {
		$('#dialogSelectRow').html('<p>인수자정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#tran_user_name").focus();
		return;
	}

	if($.trim(tran_tele_numb) == "" ) {
		$('#dialogSelectRow').html('<p>인수자 연락처는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#tran_tele_numb").focus();
		return;
	}

	if($.trim(tran_data_addr) == "" ) {
		$('#dialogSelectRow').html('<p>배송지 주소 정보는 필수 입니다. 확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog({
			title:'Warning',modal:true
		});
		$("#tran_deta_addr_seq").focus();
		return;
	}
	
	//선택된 주문상품의 최소주문수량
	for(var idx=0; idx<ids.length; idx++) {
		var check = false;
		$.each(id, function (index, value) {
			if (value == ids[i]){
				check = true;
			}
		});
		if(check){
			jq('#list').saveRow(ids[idx]);
			var selrowContent = jq("#list").jqGrid('getRowData',ids[idx]);
			if(0 == Number(selrowContent.orde_requ_quan)){
				alert("["+selrowContent.good_name+"] 상품의 최소주문수량은 ["+selrowContent.deli_mini_quan+"] 입니다.");  
				jq("#list").restoreRow(ids[idx]);
				return;
			}
		}
	}
<%if(prePay){%>
	alert("선입금 업체입니다.");
<%}%>
	var tempMsg = "";
	if($("#mana_user_name").val() == ""){
		tempMsg = "해당 상품을 주문요청 하시겠습니까?";
	}else{
		tempMsg = "["+$("#mana_user_name").val()+"] 감독관에게 주문 승인 요청을 하시겠습니까?";
	}
	if(!confirm(tempMsg)){ 
		tempMsg = "";
		return; 
	}
	var chkCnt = 0;
	for (var i = 0; i < ids.length; i++) {
		var check = false;
		$.each(id, function (index, value) {
			if (value == ids[i]){
				check = true;
			}
		});
		if(check){
			$('#list').saveRow(ids[i]);
			var selrowContent = $("#list").jqGrid('getRowData', ids[i]);
			disp_good_id_array[chkCnt] = selrowContent.disp_good_id;
			orde_requ_quan_array[chkCnt] = selrowContent.orde_requ_quan;
			requ_deli_date_array[chkCnt] = selrowContent.requ_deli_date;
			good_name_array[chkCnt] = selrowContent.good_name;
			chkCnt++;
		}
		var params = {
							groupid:groupid
						,	clientid:clientid
						,	branchid:branchid
						,	cons_iden_name:cons_iden_name
						,	orde_type_clas:orde_type_clas
						,	attach_file_1:attach_file_1
						,	attach_file_2:attach_file_2
						,	attach_file_3:attach_file_3
						,	orde_tele_numb:orde_tele_numb
						,	orde_user_id:orde_user_id
						,	tran_data_addr:tran_data_addr
						,	tran_user_name:tran_user_name
						,	tran_tele_numb:tran_tele_numb
						,	adde_text_desc:adde_text_desc
						,	mana_user_name:mana_user_name
						,	disp_good_id_array:disp_good_id_array
						,	orde_requ_quan_array:orde_requ_quan_array
						,	requ_deli_date_array:requ_deli_date_array
						,	good_name_array:good_name_array
		};
	}
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/OrderRequestAddTransGrid.sys", 
			params,
			function(arg){ 
				if(fnTransResult(arg, false)) { //성공시
					alert("주문신청이 성공적으로 완료되었습니다.");
					// 장바구니 삭제
					$.post(
						"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/cart/delCartProdInfo.sys", 
						params,
						function(arg){}
					);
					// 일괄정보 초기화
					$.post(
						"<%=Constances.SYSTEM_CONTEXT_PATH %>/order/cart/updateCartInfoTransGrid.sys", 
						params,
						function(arg){}
					);
					if(!confirm("주문내역 화면으로 이동하시겠습니까?")) {
						window.location.reload();
					}else {
						$('#frm').attr('action','/order/orderRequest/orderList.sys');
						$('#frm').attr('Target','_self');
						$('#frm').attr('method','post');
						$('#frm').submit();
					}
				}
			}
		);

}

/**
 * 주문서 출력 (2013-02-05 : by Kave)
 */
function fnOrderSheet(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt == 0) {
		alert("출력할 내용이 없습니다.");
		return;
	}	
	var borgNm      = '<%=loginUserDto.getBorgNm()%>';
	var orderNm     = '<%=cartInfoDto.getComp_iden_name()%>';
	var skCeoNm     = '<%=Constances.EBILL_COCEO%>';
	var skAddr      = '<%=Constances.EBILL_COADDR%>';
	var skTel       = '<%=Constances.EBILL_TEL%>';
	var skFax       = '<%=Constances.EBILL_FAX%>';
	var payBillType = '<%=cartInfoDto.getPayBillType()%>';
	var orderDesc   = '<%=cartInfoDto.getOrde_text_desc()%>';
	orderDesc += "\n ※ 상기 금액은 공급가임(VAT 별도)";
	
	var groupid     = '<%=loginUserDto.getGroupId()%>';
	var clientid    = '<%=loginUserDto.getClientId()%>';
	var branchid    = '<%=loginUserDto.getBorgId()%>';
	var userid      = '<%=loginUserDto.getUserId()%>';
	<%
		String prodSpec = "";
		for(int i = 0 ; i < Constances.PROD_GOOD_SPEC.length ; i++){
			if(i == 0)  prodSpec = Constances.PROD_GOOD_SPEC[i];
			else        prodSpec += "‡" + Constances.PROD_GOOD_SPEC[i];
		}
		String prodStSpec = "";
		for(int i = 0 ; i < Constances.PROD_GOOD_ST_SPEC.length ; i++){
			if(i == 0)  prodStSpec = Constances.PROD_GOOD_ST_SPEC[i];
			else        prodStSpec += "‡" + Constances.PROD_GOOD_ST_SPEC[i];
		}
	%>
	var prodSpec    = '<%=prodSpec%>';
	var prodStSpec	= '<%=prodStSpec%>';

	var oReport = GetfnParamSet(); // 필수
<%if(!isBuilder){%>
	oReport.rptname = "orderSheet"; // reb 파일이름
<%}else{%>
	oReport.rptname = "orderSheetNoPric"; // reb 파일이름
<%}%>

	oReport.param("borgNm").value       = borgNm;
	oReport.param("orderNm").value      = orderNm;
	oReport.param("payBillType").value  = payBillType;
	oReport.param("skCeoNm").value      = skCeoNm;
	oReport.param("skAddr").value       = skAddr;
	oReport.param("skTel").value        = skTel;
	oReport.param("skFax").value        = skFax;
	oReport.param("orderDesc").value    = orderDesc;
	oReport.param("groupid").value      = groupid;
	oReport.param("clientid").value     = clientid;
	oReport.param("branchid").value     = branchid;
	oReport.param("userid").value       = userid;
	oReport.param("prodSpec").value     = prodSpec;
	oReport.param("prodStSpec").value     = prodStSpec;
	oReport.title = "주문서"; // 제목 세팅
	oReport.open(); 
}

/**
 * 장바구니 페이지로 이동 
 */
function fnGoCartPage() {
    // 비어있는 함수
    $('#frm').attr('action','/order/cart/cartMstInfo.sys');
    $('#frm').attr('Target','_self');
    $('#frm').attr('method','post');
    $('#frm').submit();
}
</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "구매요청/장바구니";
	var manualPath = "/img/manual/branch/cartInfo.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<form id="frm" name="frm" method="post" target="_self">
	<input type="hidden" id="_menuId" name="_menuId" value="13080" />
<!-- 	<input type="hidden" id="total_amount" name="total_amount" value="" /> -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
						</td>
						<td height="29" class='ptitle'>장바구니
							&nbsp;<span id="question" class="questionButton">도움말</span>
						</td>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27;">
					<tr>
						<td width="20" valign="top">
							<img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
						</td>
						<td class="stitle">일괄항목</td>
						<td align="right">
							<a href="javascript:fnOrderSheet();">
								<img src="/img/system/btn_type3_estimate_sheet_print.jpg" style='border:0;vertical-align:middle;height:22px;'/>
<%-- 								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_order_print.jpg" style='border:0;vertical-align:middle;height:22px;'/> --%>
							</a>
							<a href="javascript:fnUpdateCartMstInfo();">
								<img src="/img/system/btn_type3_itemSave.gif" style='border:0;vertical-align:middle;height:22px;'/>
							</a>
						</td>
					</tr>
					<tr><td style="height: 2px"></td></tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100" style="white-space:nowrap">구매사</td>
						<td class="table_td_contents">
							<input id="branch_name" name="branch_name" type="text" value="<%=loginUserDto.getBorgNms() %>" size="" style="width: 205px;width:98%; border-color:white; " readonly="readonly" />
						</td>
						<td class="table_td_subject" width="100" style="white-space:nowrap">주문자</td>
						<td class="table_td_contents">
							<input id="orde_user_id" name= "orde_user_id" type="hidden" value="<%= loginUserDto.getUserId() %>" readonly="readonly" />
							<input id="orde_user_nm" name= "orde_user_nm" type="text" value="<%= loginUserDto.getUserNm() %>" style="width: 205px;width:98%;border-color:white;" readonly="readonly" />
						</td>
						<td class="table_td_subject" width="100" style="white-space:nowrap">주문자 전화번호</td>
						<td class="table_td_contents">
							<input id="orde_tele_numb" name="orde_tele_numb" type="text" value="<% if(null != loginUserDto.getMobile()){out.print(loginUserDto.getMobile());}  %>" size="20" style="width: 150px;ime-mode: disabled; border-color: white" disabled="disabled" maxlength="11"  onkeydown="return onlyNumber(event)" /> 
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100" style="white-space:nowrap">주문명 (주문명)</td>
						<td class="table_td_contents" colspan="3">
							<input id="cons_iden_name" name="cons_iden_name" type="text" value="<%= cartInfoDto.getComp_iden_name() %>" size="" maxlength="250" style="width: 605px;width:98%;" />
							<input id="orde_type_clas" name="orde_type_clas" type="hidden" value="<%= cartInfoDto.getOrde_type_clas() %>" size="" maxlength="250"/>
						</td>
						<td class="table_td_subject" width="100" style="white-space:nowrap">인수자</td>
						<td class="table_td_contents">
							<input id="tran_user_name" name="tran_user_name" type="text" value="<%= cartInfoDto.getTran_user_name() %>" style="width: 150px;" size="20" maxlength="10" />
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100" style="white-space:nowrap">비고</td>
						<td class="table_td_contents" colspan="3">
							<input id="orde_text_desc" name="orde_text_desc" type="text" value="<%= cartInfoDto.getOrde_text_desc() %>" size="" maxlength="1000" style="width: 150px;width:98%;" />&nbsp;
						</td>
						<td class="table_td_subject" width="100" style="white-space:nowrap">인수자 전화번호</td>
						<td class="table_td_contents">
							<input id="tran_tele_numb" name="tran_tele_numb" type="text" value="<%= cartInfoDto.getTran_tele_numb() %>" size="20" maxlength="13" style="width: 150px;" />
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100" style="white-space:nowrap">배송지 주소</td>
						<td class="table_td_contents" colspan="3">
							<select id="tran_deta_addr_seq" name="tran_deta_addr_seq" class="select" style="width: 605px"></select>
								<a href="#">
									<img id="btnAddDeliveryAddress" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_deliveryManage.gif" style='border:0;vertical-align:middle;height:22px;'/>
								</a>
						</td>
						<td class="table_td_subject" width="100" id="vendorSelect1" >감독명(승인자)</td>
						<td class="table_td_contents" id="vendorSelect2" >
							<input id="mana_user_name" name="mana_user_name" type="text" value="<%=mana_user_name %>" size="20" maxlength="10" disabled="disabled" style="border:hidden;"/>&nbsp;
							<input id="mana_user_id" name="mana_user_id" type="hidden" value="<%=mana_user_id %>" />
						</td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" style="white-space:nowrap;">
							<table>
								<tr>
									<td>첨부파일1</td>
									<td>
										<a href="#">
											<img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
										</a>
									</td>
								</tr>
							</table>
						</td>
						<td class="table_td_contents">
							<input type="hidden" id="firstattachseq" name="firstattachseq" value="<%=CommonUtils.getString(cartInfoDto.getFirstattachseq()) %>"/>
							<input type="hidden" id="attach_file_path1" name="attach_file_path1" value="<%=CommonUtils.getString(cartInfoDto.getFirstAttachPath()) %>"/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
									<span id="attach_file_name1"><%=CommonUtils.getString(cartInfoDto.getFirstAttachName()) %></span>
								</a>
<%if(!"".equals(CommonUtils.getString(cartInfoDto.getFirstattachseq()))) {    %>
								<a href="javascript:fnAttachDel('<%=CommonUtils.getString(cartInfoDto.getFirstattachseq()) %>','firstattachseq');">
									<img id="btnAttachDel1" name="btnAttachDel1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
								</a>
<%}%>
						</td>
						<td class="table_td_subject" style="white-space:nowrap">
							<table>
								<tr>
									<td>첨부파일2</td>
									<td>
										<a href="#">
											<img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
										</a>
									</td>
								</tr>
							</table>
						</td>
						<td class="table_td_contents">
							<input type="hidden" id="secondattachseq" name="secondattachseq" value="<%=CommonUtils.getString(cartInfoDto.getSecondattachseq()) %>"/>
							<input type="hidden" id="attach_file_path2" name="attach_file_path2" value="<%=CommonUtils.getString(cartInfoDto.getSecondAttachPath()) %>"/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
									<span id="attach_file_name2"><%=CommonUtils.getString(cartInfoDto.getSecondAttachName()) %></span>
								</a>
<%if(!"".equals(CommonUtils.getString(cartInfoDto.getSecondattachseq()))) {   %>
								<a href="javascript:fnAttachDel('<%=CommonUtils.getString(cartInfoDto.getSecondattachseq()) %>','secondattachseq');">
									<img id="btnAttachDel2" name="btnAttachDel2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
								</a>
<%}%>
						</td>
						<td class="table_td_subject" style="white-space:nowrap">
							<table>
								<tr>
									<td>첨부파일3</td>
									<td>
										<a href="#">
											<img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
										</a>
									</td>
								</tr>
							</table>
						</td>
						<td class="table_td_contents">
							<input type="hidden" id="thirdattachseq" name="thirdattachseq" value="<%=CommonUtils.getString(cartInfoDto.getThirdattachseq()) %>"/>
							<input type="hidden" id="attach_file_path3" name="attach_file_path3" value="<%=CommonUtils.getString(cartInfoDto.getThirdAttachPath()) %>"/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
									<span id="attach_file_name3"><%=CommonUtils.getString(cartInfoDto.getThirdAttachName()) %></span>
								</a>
<%if(!"".equals(CommonUtils.getString(cartInfoDto.getThirdattachseq()))) {    %>
								<a href="javascript:fnAttachDel('<%=CommonUtils.getString(cartInfoDto.getThirdattachseq()) %>','thirdattachseq');">
									<img id="btnAttachDel3" name="btnAttachDel3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_delete.gif" style="border: 0px;vertical-align: bottom;" />
								</a>
<%}%>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="100%" height="27" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right" class="stitle">
							<a href="javascript:void(0);">
							<span id="total_amount"></span>&nbsp;
								<img id="orderRequestButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_order.gif" width="75" height="22"style='border: 0;' />
							</a>
							<a href="javascript:void(0);">
								<img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15"style='border: 0;' />
							</a>
							<a href="javascript:void(0);">
								<img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15"style='border: 0;' />
							</a>
							<a href="javascript:void(0);">
								<img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;'/>
							</a>
						</td>
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
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" height='5'></td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="#79ABFF"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100" style="white-space:nowrap">공급가액</td>
					<td class="table_td_contents" id="SumTotalamount"></td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100" style="white-space:nowrap">부가세</td>
					<td class="table_td_contents" id="Surtax"></td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100" style="white-space:nowrap">계</td>
					<td class="table_td_contents" id="SumTotalSurtax"></td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="#79ABFF"></td>
				</tr>
			</table>
		</tr>
	</table>
	<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
		<p>상품검색을 통해 주문요청할 상품을 선택해주십시오.</p>
	</div>
	<div id="dialog" title="Feature not supported" style="display:none;">
		<p>That feature is not supported.</p>
	</div>
	<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp"%>   
</form>
</body>
</html> 