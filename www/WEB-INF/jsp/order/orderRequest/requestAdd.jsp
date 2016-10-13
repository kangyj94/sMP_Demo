<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false ;
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-415 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<CodesDto> codeList = (List<CodesDto>) request.getAttribute("codeList");
	LoginUserDto lud = (LoginUserDto) (request.getSession()).getAttribute(Constances.SESSION_NAME);
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

	boolean isFirstPurc = request.getAttribute("isFirstPurc") != null ? true : false ;
	boolean isLimit = false;
	if (lud.getIsLimit() != null && lud.getIsLimit().equals("1")) {
		isLimit = true;
	}  // 주문제한 여부
	boolean isCert = false;
	if (lud.getSmpBranchsDto() != null && lud.getSmpBranchsDto().getOrderAuthType().equals("10")) {
		isCert = true;
	}// 공인인증여부
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
    $("#srcUserNm").keydown(function(e){
        if(e.keyCode==13) {
            $("#srcButton").click();
        }
    });
    $("#srcBorgName").keydown(function(e){ 
        if(e.keyCode==13) { $("#btnBuyBorg").click(); } 
    });
    $("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
    $("#excelButton").click(function(){ exportExcel(); });
    $("#btnSearchProducts").click(function(){fnOpenProdSearchPopForAdmin(); });
    
    $("#orderRequestButton").click(function(){ 
<%if(isLimit){%>
        alert("주문제한이 되어 주문을 할 수 없습니다.\n관리자에게 문의바랍니다.");
        return;
<%}%>
<%if(isCert){%>
        alert("공인인증을 해야 주문이 가능합니다.");
        return;
<%}%>
        $("#srcBranchId").val($.trim($("#srcBranchId").val()));
        $("#orde_type_clas").val($.trim($("#orde_type_clas").val()));
        $("#tran_data_addr_seq").val($.trim($("#tran_data_addr_seq").val()));
        $("#cons_iden_name").val($.trim($("#cons_iden_name").val()));
        $("#branchid").val($.trim($("#branchid").val()));
        $("#orde_tele_numb").val($.trim($("#orde_tele_numb").val()));
        $("#tran_data_addr").val($.trim($("#tran_data_addr").val()));
        $("#tran_user_name").val($.trim($("#tran_user_name").val()));
        $("#tran_tele_numb").val($.trim($("#tran_tele_numb").val()));
        $("#adde_text_desc").val($.trim($("#adde_text_desc").val()));
        $("#mana_user_name").val($.trim($("#mana_user_name").val()));
		fnChkNormProduct();
    });
    
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

//리사이징
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>
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
        if($('#srcBranchId').val() == '' ){
            $('#srcBranchId_warning').html('<p>구매사를 선택 후 배송지를 수정 할 수 있습니다.\n확인후 이용하시기 바랍니다.</p>');
            $('#srcBranchId_warning').dialog();
            return; 
        }
        fnDeliveryAddressManageDialog( $('#srcGroupId').val(), $('#srcClientId').val() , $('#srcBranchId').val() , "fnCallBackDeliveryAddressManage"); 
    });
});
/**
 * 배송지관리팝업검색 후 선택한 값 세팅
 */
function fnCallBackDeliveryAddressManage(deliId) {
	if(deliId != undefined){
		fnSelectBoxAddressInfo(deliId);
	}else{
        fnGetBuyAddressInfo();
	}
}
function fnSelectedAddressInfo() {
    fnGetBuyAddressInfo();
}
function fnSelectBoxAddressInfo(deliId) {
    $("#tran_data_addr_seq").val(deliId);
}
</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp" %>
<!-- 고객사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
var checkChangeBranchId = 0;
    $("#btnBuyBorg").click(function(){
    	if(checkChangeBranchId > 0){
    		if(confirm("고객사를 변경시 상품리스트는 삭제됩니다.\n변경하시겠습니까?")){
                jq("#list").clearGridData();
                $("#orde_tele_numb").val("");
                $("#tran_user_name").val("");
                $("#tran_tele_numb").val("");
                $("#tran_tele_numb").val("");
                $("#orde_user_id").children().remove().end().append('<option selected value="">선택</option>');
                $("#mana_user_name").val("");
                $("#mana_user_id").val("");
    		}else{
    			return;
    		}
    	}
    	checkChangeBranchId++;
        var borgNm = $("#srcBorgName").val();
        fnBuyborgDialog("BCH", "1", borgNm, "fnCallBackBuyBorg"); 
    });
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
//  alert("groupId : "+groupId+", clientId : "+clientId+", branchId : "+branchId+", borgNm : "+borgNm+", areaType : "+areaType);
    $("#srcGroupId").val(groupId);
    $("#srcClientId").val(clientId);
    $("#srcBranchId").val(branchId);
    $("#srcBorgName").val(borgNm);
    fnInitComponent();  
    fnGetBuyerInfo();
    fnGetBuyAddressInfo();
}
//컴퍼넌트초기화 
function fnInitComponent() {
    $("#orde_user_id").children().remove().end().append('<option selected value="">선택</option>');
}
// 조직에 따른 사용자 정보 조회 
function fnGetBuyerInfo() {
    $.post( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getUserInfoListByBranchId.sys',
            {borgId:$("#srcBranchId").val()},
            function(arg){
                var userList = eval('(' + arg + ')').userList;
                for(var i=0;i<userList.length;i++) {
                    $("#orde_user_id").append("<option value='"+userList[i].userId+"'>"+userList[i].userNm+"</option>");
                }   
            }
        );
}
// 배송지 정보 조회
function fnGetBuyAddressInfo() {
	$.post( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getDeliveryAddressByBranchId.sys',
		{
			groupId:$("#srcGroupId").val(),clientId:$("#srcClientId").val(),branchId:$("#srcBranchId").val()
		},
		function(arg){
			var deliveryListInfo = eval('(' + arg + ')').deliveryListInfo;
			$("#tran_data_addr_seq").html("");
			for(var i=0;i<deliveryListInfo.length;i++) {
				$("#tran_data_addr_seq").append("<option value='"+deliveryListInfo[i].deliveryid+"'  >"+deliveryListInfo[i].shippingaddres+" ["+deliveryListInfo[i].shippingplace+"]"+"</option>");
			}
		}
	);
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
   var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
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
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    };
};
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

<%//------------------------------------상품검색 팝업 관련 --------------------------------- %>
<script type="text/javascript">
    /**
     * 고객사 진열 상품 
     */
    function fnOpenProdSearchPopForAdmin() {

        if($.trim($('#srcBranchId').val()) == ''){
            $('#dialogSelectRow').html('<p>사업장 선택후 이용하시기 바랍니다.</p>');
            $("#dialogSelectRow").dialog({
            	title:'Warning',modal:true
            });
            return true;
        }
        
        var menuId = '<%=menuId%>';
        var groupId  = $('#srcGroupId').val();
        var clientId = $("#srcClientId").val();
        var branchId = $('#srcBranchId').val();
        var branchNms = $('#srcBorgName').val();
        var msg = ''; 
        msg += '\ngroupId  ['+groupId  +']';
        msg += '\nclientId ['+clientId +']';
        msg += '\nbranchId ['+branchId +']';
        
       var popurl = "/product/prodSearchForAdmOrde.sys?_menuId="+menuId+"&groupId="+groupId+"&clientId="+clientId+"&branchId="+branchId+"&branchNms="+branchNms;
//        var popproperty = "dialogWidth:950px;dialogHeight=570px;scroll=no;status=no;resizable=no;";
       var popproperty = "width=1000px, height=650px, status=no,resizable=no";
//        var vReturn = window.showModalDialog(popurl,self,popproperty);
       window.open(popurl, 'window', popproperty);
//        var list = productList();
//        alert(list);
//        if(vReturn == undefined || vReturn.isSuccess != "success" ){return;}
//         for(var arrIdx = 0 ; arrIdx < vReturn['objs'].length ; arrIdx++){
//         	var convertGoodClasCode = vReturn['objs'][arrIdx].good_clas_code;
//         	if(convertGoodClasCode == '10'){
//         		convertGoodClasCode = "일반";
//         	}else if(convertGoodClasCode == '20'){
//         		convertGoodClasCode = "지정";
//         	}else if(convertGoodClasCode == '30'){
//         		convertGoodClasCode = "수탁";
//         	}
//         	vReturn['objs'][arrIdx].good_clas_code = convertGoodClasCode;
//             jq("#list").addRowData(vReturn['objs'][arrIdx].disp_good_id,{
//                 disp_good_id:vReturn['objs'][arrIdx].disp_good_id
//                 , good_clas_code:vReturn['objs'][arrIdx].good_clas_code
//                 , good_inventory_cnt:vReturn['objs'][arrIdx].good_inventory_cnt
//                 , vendor_name:vReturn['objs'][arrIdx].borgnm
//                 , good_clas_code:vReturn['objs'][arrIdx].good_clas_code
//                 , good_name: vReturn['objs'][arrIdx].good_name
//                 , good_spec_desc: vReturn['objs'][arrIdx].good_spec_desc
//                 , min_orde_requ_quan: vReturn['objs'][arrIdx].ord_unlimit_quan
//                 , sell_price: vReturn['objs'][arrIdx].sell_price
//                 , orde_requ_quan: vReturn['objs'][arrIdx].ord_quan
//                 , total_sell_price: vReturn['objs'][arrIdx].total_amout
//                 , deli_mini_day: vReturn['objs'][arrIdx].deli_mini_day
//                 , requ_deli_date: vReturn['objs'][arrIdx].deli_mini_day
//             }); 
//         }
//         fnCalcTotalSell();
    }
     
    /**
     *  삼품검색 콜백 
     */
    function fnProdSearchCallBack(good_Iden_Numb , good_Name , full_Cate_Name) {
       var msg = ""; 
       msg += "\n good_Iden_Numb value ["+good_Iden_Numb +"]"; 
       msg += "\n good_Name value ["+good_Name+"]";
       msg += "\n full_Cate_Name value ["+full_Cate_Name +"]";
       //alert(msg);
       $('#good_iden_numb').val(good_Iden_Numb);
       $('#good_Name').val(good_Name);
    }

    /**
    *	주문조회 페이지로 이동한다. 
    */
    function fnGoOrderList(){
        $('#frm').attr('action','/order/orderRequest/orderList.sys');
		$('#frm').attr('Target','_self');
		$('#frm').attr('method','post');
		$('#frm').submit();
    }
   //btn_type2_standardOK
</script>
<%//------------------------------------상품검색 팝업 관련 끝  --------------------------------- %>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var lastsel;
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/orderRequest/orderGoodsListJQGrid.sys', 
		editurl: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",
		datatype: 'json',
		mtype: 'POST',
		colNames:['disp_good_id', '재고수량', '공급사', '주문상품유형', '상품명', '규격','최소구매수량' ,'단가', '수량', '주문금액', '표준납기일', '납품요청일', '상품삭제','vendorid'],
		colModel:[
					{name:'disp_good_id',index:'disp_good_id',hidden:true,search:false,key:true},//진열 SEQ
					{name:'good_inventory_cnt',index:'good_inventory_cnt',hidden:true,search:false},//재고수량
					{name:'vendor_name',index:'vendor_name', width:100,align:"left",search:false,sortable:true, editable:false },//공급사
					{name:'good_clas_code',index:'good_clas_code', width:75,align:"center",search:false,sortable:true, editable:false },//주문상품유형
					{name:'good_name',index:'good_name', width:130,align:"left",search:false,sortable:true, editable:false },//상품명
					{name:'good_spec_desc',index:'good_spec_desc', width:100,align:"center",search:false,sortable:true, editable:false },//규격
					{name:'min_orde_requ_quan',index:'min_orde_requ_quan', hidden:true, search:false,editable:false,formatter: 'integer',
						formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
					},//최소 주문수량 
					{name:'sell_price',index:'sell_price', width:70,align:"right",search:false,sortable:true, editable:false ,formatter: 'integer',
						formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//단가
					{name:'orde_requ_quan',index:'orde_requ_quan', width:60,align:"right",search:false,sortable:true, editable:true,formatter: 'integer',readonly:true,
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
								var inputValue = Number(this.value);                                            // 입력수량
								var chkMinOrderCnt = Number(selrowContent.min_orde_requ_quan);  // 최소 구매 수량
								var stockcnt = Number(selrowContent.good_inventory_cnt);                    // 재고수량 : 주문상품유형이 지정, 수탁일 경우
								var good_clas_code = selrowContent.good_clas_code;                      // 주문상품유형
								var sell_price = selrowContent.sell_price;                                      // 단가
								if(inputValue<chkMinOrderCnt) {
									alert("최소주문수량 이하는 신청할 수 없습니다.\n해당 상품의 최소수량은 "+chkMinOrderCnt+" 입니다.");
									var tempTotalSellPrice  = chkMinOrderCnt * sell_price;
									jq("#list").restoreRow(rowid);
									jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:chkMinOrderCnt});
									jq("#list").jqGrid('setRowData', rowid, {total_sell_price:tempTotalSellPrice});
									fnCalcTotalSell();
									jq('#list').editRow(rowid);
									return;
								}
								// 2013-04-25 : 주문신청시 체크로직이 있으므로 주석처리.
//                             if(good_clas_code == '수탁' && inputValue > stockcnt) {
//                                 alert("재고수량 이상으로 신청할 수 없습니다.\n해당 상품의 재고수량은 "+stockcnt+" 입니다.");
//                                 var tempTotalSellPrice  = chkMinOrderCnt * sell_price;
//                                 jq("#list").restoreRow(rowid);
//                                 jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:chkMinOrderCnt});
//                                 jq("#list").jqGrid('setRowData', rowid, {total_sell_price:tempTotalSellPrice});
//                                 fnCalcTotalSell();
//                                 jq('#list').editRow(rowid);
//                                 return;
//                             }
								var tempTotalSellPrice  = inputValue * sell_price;
								jq("#list").restoreRow(rowid);
								jq("#list").jqGrid('setRowData', rowid, {orde_requ_quan:inputValue});
								jq("#list").jqGrid('setRowData', rowid, {total_sell_price:tempTotalSellPrice});
								fnCalcTotalSell();
								jq('#list').editRow(rowid);
							}
						}]
					}
				},//수량
				{name:'total_sell_price',index:'total_sell_price', width:90,align:"right",search:false,sorttype:'integer',formatter:'integer',
					formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//주문금액
				{name:'deli_mini_day',index:'deli_mini_day', width:70,align:"center",search:false,sorttype:"date", editable:false,formatter:"date" },//표준납기일
				{name:'requ_deli_date',index:'requ_deli_date',width:80,align:"center",search:false,sortable:false,
					formatter: 'text',
					editable:true,edittype: 'text',
					editoptions: {
						size: 9,maxlengh: 10,dataInit: function (element) {
							$(element).datepicker({ dateFormat: 'yy-mm-dd' });
						},
						dataEvents:[{
							type:'change',
							fn:function(e){
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
				{name:'상품삭제',index:'상품삭제', width:70,align:"center",search:false,sortable:false, editable:false,formatter:delButton },//상품 삭제
				{name:'vendorid',index:'vendorid',hidden:true}//vendorid
		],
		postData: { },
		rowNum:0, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
//             var rowCnt = jq("#list").getGridParam('reccount');
//             if(rowCnt>0) {
//                 for(var i=0; i<rowCnt; i++) {
//                     var rowid = $("#list").getDataIDs()[i];
//                     jQuery('#list').jqGrid('editRow',rowid,true);
//                 }
//             }
//             var userData = jq("#list").jqGrid("getGridParam","userData");
//             userData.sell_price = '';
//             userData.orde_requ_quan = fnComma(userData.orde_requ_quan);
//             userData.total_sell_price = fnComma(userData.total_sell_price);
//             jq("#list").jqGrid("footerData","set",userData,false);
		},
		onSelectRow: function (rowid, iRow, iCol, e) { },
		ondblClickRow: function (rowid, iRow, iCol, e) { }, 
		afterInsertRow: function(rowid, aData){
<%if(isAdm){%>
			jq("#list").setCell(rowid,'vendor_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'vendor_name','',{cursor: 'pointer'});
<%}%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
<%if(isAdm){%>
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			//공급사 상세 팝업 호출
			if(colName != undefined &&colName['index']=="vendor_name") {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorid);")%>
			}
<%}%>
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",records: "records",repeatitems: false,cell: "cell", userdata:"userdata" },
		footerrow: true,
		userDataOnFooter: true
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
// 삭제버튼 초기화 
function delButton(cellValue, options, rowObject){
    var str = "<input type='button' value='상품삭제' onclick='javascript:fnDelOrderProduct("+rowObject.disp_good_id+");'>";
    return str;
}

// 삭제
function fnDelOrderProduct(id){
	if(confirm("해당 상품을 삭제하시겠습니까?")){
        jQuery("#list").delRowData(id);
        fnCalcTotalSell();
	}
}

// 3자리수마다 콤마
function fnComma(n) {
     n += '';
     var reg = /(^[+-]?\d+)(\d{3})/;
     while (reg.test(n)){
         n = n.replace(reg, '$1' + ',' + '$2');
     }
     return n;
}

// 수량 변화시 합계 계산
function fnCalcTotalSell(){
	var temp_total_sell_price = 0;
	var temp_total_quan = 0;
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt > 0){
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			jq("#list").restoreRow(rowid);
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			temp_total_sell_price += Number(selrowContent.total_sell_price);
			temp_total_quan += Number(selrowContent.orde_requ_quan);
			jq('#list').editRow(rowid);  
		}
	}
	var userData = jq("#list").jqGrid("getGridParam","userData");
	userData.total_sell_price = fnComma(temp_total_sell_price);
	userData.orde_requ_quan = fnComma(temp_total_quan);
	userData.sell_price = '';
	jq("#list").jqGrid("footerData","set",userData,false);
}

//  list Excel Export
function exportExcel() {
	var colLabels = ['공급사','주문상품유형','상품명','규격','단가','수량','주문금액','납품요청일'];   //출력컬럼명
	var colIds = ['vendor_name','good_clas_code','good_name','good_spec_desc','sell_price','orde_requ_quan','total_sell_price','deli_mini_day'];    //출력컬럼ID
	var numColIds = ['total_sell_price'];   //숫자표현ID
	var sheetTitle = "주문요청 상품리스트";  //sheet 타이틀
	var excelFileName = "OrderRequestList"; //file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

// 주문 유형 SelectBox 관련 부분
function fnOrderKind(){
    var rowCnt = jq("#list").getGridParam('reccount');
    if($("#orde_type_clas").val() == "90" && rowCnt > 0){
        if(confirm("주문유형을 수탁발주로 할 시 주문요청 상품리스트의 조회 결과를 \n삭제하게 됩니다.삭제하시겠습니까?")){
            jq("#list").clearGridData();
            jq( "#product_search_info" ).dialog();
        }else{
            $("#orde_type_clas").val();
            $("#orde_type_clas option:eq(0)").attr("selected", "selected");
        }
        return;
    }
//     if($("#orde_type_clas").val() == "20"){
//         document.getElementById("vendorSelect1").style.display="";
//         document.getElementById("vendorSelect2").style.display="";
//         document.getElementById("mana_user_name").style.display="";
//     }else{
//         document.getElementById("vendorSelect1").style.display="none";
//         document.getElementById("vendorSelect2").style.display="none";
//         document.getElementById("mana_user_name").style.display="none";  
//     }
}


function fnChkNormProduct(){
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
//                         		returnMsg += "["+stockQuanChkList[i].vendor_name+"] 공급사의 ["+stockQuanChkList[i].good_name+"] 상품의 재고수량은 "+Number(stockQuanChkList[i].good_inventory_cnt) +" (으)로 주문요청 수량이 재고수량을 초과하였습니다.\n\n";
//                         		chkCnt++;
//                         	}
//                         }
//                     }
//                 }
//             	if(chkCnt == 0){
//             		fnOrderRequest();
//             	}else{
//             		alert(returnMsg);
//                     fnCalcTotalSell();
//             	}
//             }
//         );
    } else{ jq( "#dialogSelectRow" ).dialog();};
}
// 주문 신청 버튼 클릭시
function fnOrderRequest(){
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt>0) {
        var srcGroupId= $("#srcGroupId").val();
        var srcClientId= $("#srcClientId").val();
        var srcBranchId= $("#srcBranchId").val();
        var tran_data_addr_seq= $("#tran_data_addr_seq").val();
        var cons_iden_name = $("#cons_iden_name").val();
        var orde_type_clas = $("#orde_type_clas").val();
        var orde_tele_numb =    $("#orde_tele_numb").val();
        var orde_user_id =  $("#orde_user_id").val();
        var tran_user_name =$("#tran_user_name").val();
        var tran_tele_numb =    $("#tran_tele_numb").val();
        var adde_text_desc =    $("#adde_text_desc").val();
        var mana_user_name =    $("#mana_user_name").val();
        var firstattachseq =    $("#firstattachseq").val();
        var secondattachseq =   $("#secondattachseq").val();
        var thirdattachseq= $("#thirdattachseq").val();
        if(srcBranchId==""){
            jq( "#srcBranchId_warning" ).dialog();
            $("#srcBorgName").focus();
            return;
        }
        if(orde_user_id==""){
            jq( "#orde_user_id_warning" ).dialog();
            $("#orde_user_id").focus();
            return;
        }
        if(orde_tele_numb== ""){
            jq( "#orde_tele_numb_warning" ).dialog();
            $("#orde_tele_numb").focus();
            return;
        }
        if(cons_iden_name==""){
            jq( "#cons_iden_name_warning" ).dialog();
            $("#cons_iden_name").focus();
            return;
        }
        if(orde_type_clas==""){
            jq( "#orde_type_clas_warning" ).dialog();
            $("#orde_type_clas").focus();
            return;
        }
        if(tran_user_name== ""){
            jq( "#tran_user_name_warning" ).dialog();
            $("#tran_user_name").focus();
            return;
        }
        if(tran_tele_numb== ""){
            jq( "#tran_tele_numb_warning" ).dialog();
            $("#tran_tele_numb").focus();
            return;
        }
        if(tran_data_addr_seq==""){
            jq( "#tran_data_addr_seq_warning" ).dialog();
            $("#tran_data_addr_seq").focus();
            return;
        }
        
        for(var i=0; i<rowCnt; i++) {
            var rowid = $("#list").getDataIDs()[i];
            jq('#list').saveRow(rowid);
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
            if(0 == Number(selrowContent.orde_requ_quan)){
            	alert("["+selrowContent.good_name+"] 상품의 최소주문수량은 ["+selrowContent.min_orde_requ_quan+"] 입니다.");  
                jq("#list").editRow(rowid);
            	return;
            }
        }
        
        var disp_good_id_array = new Array();
        var orde_requ_quan_array = new Array();
        var requ_deli_date_array = new Array();
        var good_name_array = new Array();
        
        if(!confirm("해당 상품을 주문요청 하시겠습니까?")){ return; }
        for(var i=0; i<rowCnt; i++) {
            var rowid = $("#list").getDataIDs()[i];
            jq('#list').saveRow(rowid);
            var selrowContent = jq("#list").jqGrid('getRowData',rowid);
            disp_good_id_array[i] = selrowContent.disp_good_id;
            orde_requ_quan_array[i] = selrowContent.orde_requ_quan;
            requ_deli_date_array[i] = selrowContent.requ_deli_date;
            good_name_array[i] = selrowContent.good_name;
        }
        $.post(
            "<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/OrderRequestAddTransGrid.sys", 
            {   groupid:srcGroupId,clientid:srcClientId,branchid:srcBranchId,cons_iden_name:cons_iden_name, orde_type_clas:orde_type_clas,
                attach_file_1:firstattachseq,attach_file_2:secondattachseq,attach_file_3:thirdattachseq,
                orde_tele_numb:orde_tele_numb, orde_user_id:orde_user_id, tran_data_addr:tran_data_addr_seq,
                tran_user_name:tran_user_name, tran_tele_numb:tran_tele_numb, adde_text_desc:adde_text_desc,mana_user_name:mana_user_name,
                disp_good_id_array:disp_good_id_array, orde_requ_quan_array:orde_requ_quan_array,
                requ_deli_date_array:requ_deli_date_array,
                good_name_array:good_name_array
            },
            function(arg){ 
                if(fnAjaxTransResult(arg)) {    //성공시
                    alert("주문요청이 성공적으로 완료되었습니다.");
                    window.location.reload();
                }
            }
        );
    } else{ jq( "#dialogSelectRow" ).dialog();};
}

function fnDialogSelectClient(){
    jq( "#dialogSelectClient" ).dialog();
}
function fnChnageOrderUser(str){
	var tempUserId = str;
    $.post( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getUserInfoListByBranchId.sys',
            {borgId:$("#srcBranchId").val()},
            function(arg){
                var userList = eval('(' + arg + ')').userList;
                for(var i=0;i<userList.length;i++) {
                    if(tempUserId == userList[i].userId){
                        $("#orde_tele_numb").val(userList[i].mobile);
                        $("#tran_user_name").val(userList[i].userNm);
                        $("#tran_tele_numb").val(userList[i].mobile);
                        fnSearchSupervisor();
                    }
                }      
            }
        );
}

function fnSearchSupervisor(){
    $.post( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/orderRequest/getSupervisorUserInfo.sys',
            {	
            	branchId:$("#srcBranchId").val(),
            	userId:$("#orde_user_id").val() 
            },
            function(arg){
                var userList = eval('(' + arg + ')').userList;
                if( 0 < userList.length){
                    $("#mana_user_name").val(userList[0].userNm);
                    $("#mana_user_id").val(userList[0].userId);
                }else{
                    $("#mana_user_name").val("");
                    $("#mana_user_id").val("");
                }
            }
        );
}
function fnFirstPurc(){
<%if(isFirstPurc){%>
    $("#orde_type_clas").val("20");
	$("#orde_type_clas").attr("disabled", true);
    fnOrderKind();
<%}%>
}
//상품
function productList(producArray){
 	var convertGoodClasCode = "";
	for(var i=0; i<producArray.length; i++){
		var good_clas_code = producArray[i].good_clas_code;
		if(good_clas_code == '10'){
			convertGoodClasCode = "일반";
		}else if(good_clas_code == '20'){
			convertGoodClasCode = "지정";
		}else if(good_clas_code == '30'){
			convertGoodClasCode = "수탁";
		}
		jq("#list").addRowData(producArray[i].disp_good_id,{
			disp_good_id:producArray[i].disp_good_id,
			good_clas_code:producArray[i].good_clas_code,
			good_inventory_cnt:producArray[i].good_inventory_cnt,
			vendor_name:producArray[i].borgnm,
			good_clas_code:convertGoodClasCode,
			good_name: producArray[i].good_name,
			good_spec_desc:producArray[i].good_spec_desc,
			min_orde_requ_quan:producArray[i].ord_unlimit_quan,
			sell_price:producArray[i].sell_price,
			orde_requ_quan:producArray[i].ord_quan,
			total_sell_price:producArray[i].total_amout,
			deli_mini_day:producArray[i].deli_mini_day,
			requ_deli_date:producArray[i].deli_mini_day,
			vendorid:producArray[i].vendorid
		});
// 		alert(producArray.disp_good_id);
	}
	fnCalcTotalSell();
}

</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<body onload="javascript:fnFirstPurc();">
    <form id="frm" name="frm" method="post" onsubmit="return false;">
        <table width="98%" style="margin-left: 10px;" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <!-- 타이틀 시작 -->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top">
                            <td width="20" valign="middle">
                                <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                            </td>
                            <td height="29" class='ptitle'>구매요청</td>
                        </tr>
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
                            <td class="table_td_subject" width="100">구매사</td>
                            <td class="table_td_contents">
                                <input id="srcBorgName" name="srcBorgName" type="text" value="" size="" style="width: 300px;"/> 
                                <img id="btnBuyBorg" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="20" height="18" style='border: 0; cursor: pointer; vertical-align: middle;' /> 
                                <input id="srcGroupId" name="srcGroupId" type="hidden" value="" /> <input id="srcClientId" name="srcClientId" type="hidden" value="" /> 
                                <input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
                            </td>
                            <td class="table_td_subject" width="100">주문자</td>
                            <td class="table_td_contents">
                                <select id="orde_user_id" name="orde_user_id" style="width: 120px" class="select" onchange="javascript:fnChnageOrderUser(this.value)">
                                    <option value="">선택</option>
                                </select>
                            </td>
                            <td class="table_td_subject" width="100">주문자 전화번호</td>
                            <td class="table_td_contents">
                                <input id="orde_tele_numb" name="orde_tele_numb" type="text" value="" size="20" maxlength="11" style="ime-mode: disabled;"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">공사명</td>
                            <td class="table_td_contents">
                                <input id="cons_iden_name" name="cons_iden_name" type="text" value="" size="" maxlength="250" style="width: 205px" />
                            </td>
                            <td class="table_td_subject" width="100">주문 유형</td>
                            <td class="table_td_contents">
                                <select id="orde_type_clas" name="orde_type_clas" class="select" onchange="javascript:fnOrderKind();" style="width: 120px">
                                    <%
                                    	if (codeList.size() > 0) {
                                    		CodesDto cdData = null;
                                    		for (int i = 0; i < codeList.size(); i++) {
                                    			cdData = codeList.get(i);
                                    			if (cdData.getCodeVal1().equals("40"))
                                    				continue;
                                    			if (cdData.getCodeVal1().equals("90"))
                                    				continue;
                                    %>
                                    <option value="<%=cdData.getCodeVal1()%>"><%=cdData.getCodeNm1()%></option>
                                    <% } } %>
                                </select>
                            </td>
                            <td class="table_td_subject" width="100" id="vendorSelect1" >감독명</td>
                            <td class="table_td_contents" id="vendorSelect2" >
                                <input id="mana_user_name" name="mana_user_name" type="text" value="" size="20" maxlength="10" disabled="disabled" style="border:hidden;"/>&nbsp;
                                <input id="mana_user_id" name="mana_user_id" type="hidden" value="" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">비고</td>
                            <td class="table_td_contents">
                                <input id="adde_text_desc" name="adde_text_desc" type="text" value="" size="" maxlength="1000" style="width: 205px" />&nbsp;
                            </td>
                            <td class="table_td_subject" width="100">인수자</td>
                            <td class="table_td_contents">
                                <input id="tran_user_name" name="tran_user_name" type="text" value="" size="20" maxlength="10" />
                            </td>
                            <td class="table_td_subject" width="100">인수자 전화번호</td>
                            <td class="table_td_contents">
                                <input id="tran_tele_numb" name="tran_tele_numb" type="text" value="" size="20" maxlength="11" style="ime-mode: disabled;" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">배송지 주소</td>
                            <td class="table_td_contents" colspan="5">
                                <select id="tran_data_addr_seq" name="tran_data_addr_seq" class="select" style="width: 605px">
                                </select>
                                <a href="javascript:void(0);">
                                    <img id="btnAddDeliveryAddress" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style='border: 0; vertical-align: middle; height: 20px;' />
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="100">
                                <table>
                                    <tr>
                                        <td style="vertical-align: middle;">첨부1</td>
                                    </tr>
                                </table>
                                <a href="#">
                                    <img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                                </a>
                            </td>
                            <td class="table_td_contents">
                                <input type="hidden" id="firstattachseq" name="firstattachseq" value="" /><input type="hidden" id="attach_file_path1" name="attach_file_path1" value="" />
                                <a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
                                    <span id="attach_file_name1"></span>
                                </a>
                            </td>
                            <td class="table_td_subject" width="100">
                                <table>
                                    <tr>
                                        <td style="vertical-align: middle;">첨부2</td>
                                    </tr>
                                </table>
                                <a href="#">
                                    <img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                                </a>
                            </td>
                            <td class="table_td_contents">
                                <input type="hidden" id="secondattachseq" name="secondattachseq" value="" /><input type="hidden" id="attach_file_path2" name="attach_file_path2" value="" />
                                <a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
                                    <span id="attach_file_name2"></span>
                                </a>
                            </td>
                            <td class="table_td_subject" width="100">
                                <table>
                                    <tr>
                                        <td style="vertical-align: middle;">첨부3</td>
                                    </tr>
                                </table>
                                <a href="#">
                                    <img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
                                </a>
                            </td>
                            <td class="table_td_contents">
                                <input type="hidden" id="thirdattachseq" name="thirdattachseq" value="" /><input type="hidden" id="attach_file_path3" name="attach_file_path3" value="" />
                                <a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
                                    <span id="attach_file_name3"></span>
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="table_top_line"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="10"></td>
            </tr>
            <tr>
                <td align="right">
                    <button id='btnSearchProducts' class="btn btn-default btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">상품검색</button>
                    <button id='orderRequestButton' class="btn btn-default btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>">주문신청</button>
                </td>
            </tr>
            <tr>
                <td height="1"></td>
            </tr>
            <tr>
                <td>
                    <div id="jqgrid">
                        <table id="list"></table>
                    </div>
                </td>
            </tr>
        </table>
        <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>상품검색을 통해 주문요청할 상품을 선택해주십시오.</p>
        </div>
        <div id="srcBranchId_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>구매사</b>를 입력해주십시오.
            </p>
        </div>
        <div id="orde_user_id_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>주문자</b>를 입력해주십시오.
            </p>
        </div>
        <div id="tran_data_addr_seq_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>배송지</b>를 입력해주십시오.
            </p>
        </div>
        <div id="orde_type_clas_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>주문유형</b>을 입력해주십시오.
            </p>
        </div>
        <div id="cons_iden_name_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>공사명</b>을 입력해주십시오.
            </p>
        </div>
        <div id="orde_tele_numb_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>주문자 전화번호</b>을 입력해주십시오.
            </p>
        </div>
        <div id="tran_user_name_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>인수자</b>를 입력해주십시오.
            </p>
        </div>
        <div id="tran_tele_numb_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>인수자 전화번호</b>를 입력해주십시오.
            </p>
        </div>
        <div id="mana_user_name_warning" title="Warning" style="display: none; font-size: 12px; color: red;">
            <p>
                <b>감독명</b>을 입력해주십시오.
            </p>
        </div>
        <div id="product_search_info" title="infomation" style="display: none; font-size: 12px; color: black;">
            <p>
                상품요청 상품리스트가 초기화 되었습니다.<br /> <b>상품검색</b>을 다시 해 주십시오.
            </p>
        </div>
        <div id="dialogSelectClient" title="Infomation" style="display: none; font-size: 12px; color: black;">
            <p>준비중</p>
        </div>
    </form>
</body>
</html>