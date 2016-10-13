<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
    //그리드의 width와 Height을 정의
    String listHeight = "$(window).height()-420 + Number(gridHeightResizePlus)";
//     String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
    String listWidth = "1500";

    @SuppressWarnings("unchecked")
    List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");           // 화면권한가져오기(필수)
    LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);  // 사용자 정보
    String vendorid = "";
    String vendornm = "";
    String svcTypeCd = userInfoDto.getSvcTypeCd();
    if(svcTypeCd.equals("VEN")) {
        vendorid = userInfoDto.getBorgId();
        vendornm = userInfoDto.getBorgNm();
    }
    String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
    String srcInsertStartDate = CommonUtils.getCustomDay("DAY", -7);    // 날짜 세팅
    String srcInsertEndDate = CommonUtils.getCurrentDate();
    String checkAllFlag = "false";
    boolean isVendor = "VEN".equals(userInfoDto.getSvcTypeCd()) ? true : false;
    

	String startDate = CommonUtils.getString(request.getParameter("startDate"));
	String endDate = CommonUtils.getString(request.getParameter("endDate"));
	String appltFixCode = CommonUtils.getString(request.getParameter("flag1"));
	String fixAppSts = CommonUtils.getString(request.getParameter("flag2"));
	
	
	// 2016-03-09 상품변경요청 조회 기간 변경 :  1주 --> 1년  
	boolean isExistSrcFlag = false;
	try{
		isExistSrcFlag	=	Boolean.parseBoolean(CommonUtils.getString(request.getParameter("srcFlag")));
	}catch(Exception e){
		isExistSrcFlag = false;
	}
	if(isExistSrcFlag){
		srcInsertStartDate 	= CommonUtils.getCustomDay("YEAR", -1);
		srcInsertEndDate 	= CommonUtils.getCurrentDate();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css" media="screen">
    th.ui-th-column div{
        white-space:normal !important;
        height:auto !important;
    }
    input[type=radio]{vertical-align: middle;}
</style>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
    // 코드 데이터 조회 
    fnDataInit();
    
    // 이벤트 등록
    /*--------------------검색에 대한 처리--------------------*/
    $("#srcButton").click(function() {
        $("#srcVendorId").val($.trim($("#srcVendorId").val()));
        $("#srcGoodName").val($.trim($("#srcGoodName").val()));
        $("#srcInsertStartDate").val($.trim($("#srcInsertStartDate").val()));
        $("#srcInsertEndDate").val($.trim($("#srcInsertEndDate").val()));
        $("#srcAppltFixCode").val($.trim($("#srcAppltFixCode").val()));
        $("#srcFixAppSts").val($.trim($("#srcFixAppSts").val()));
    });
    
    $("#srcButton").click(function() { fnSearch(); });
    $("#srcVendorNm").keydown(function(e) { if(e.keyCode==13) { $("#btnVendor").click(); }});
    $("#srcVendorNm").change(function(e) {  $("#srcVendorNm").val(""); $("#srcVendorId").val(""); });
    $("#srcGoodName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
    $("#srcInsertStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
    $("#srcInsertEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
    $("#srcAppltFixCode").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
    $("#srcFixAppSts").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
    
    $("#btnVendor").click(function() { fnSearchVendor(); });
    $("#appButton").click(function() { fnConfirmation(1); });
    $("#retButton").click(function() { fnRequestCancelReason(); });
    
    $("#excelAll").click(function(){ exportExcelToSvc(); });
    
    // DataPicker 등록
    $("#srcInsertStartDate").datepicker( {
        showOn: "button",
        buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
    });
    $("#srcInsertEndDate").datepicker( {
        showOn: "button",
        buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
    });
    $("img.ui-datepicker-trigger").attr("style", "margin-left:3px;vertical-align:middle;cursor:pointer;");
    
    goodClasCodeSelect();//상품구분 셀렉트박스 호출
    selectProductManager();
});

function selectProductManager() {
    //상품담당자 셀렉트박스
    //B2B권한
    $.post(
        "/product/selectProductManager/list.sys",
        {},
        function(arg){
            var productManagetList = eval('('+arg+')').list;
            for(var i=0; i<productManagetList.length; i++){
                $("#srcProductManager").append("<option value='"+productManagetList[i].USERID+"'>"+productManagetList[i].USERNM+"</option>");
            }
        }
    );
}

//리싸이즈 설정
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');

function checkBox(e) {
    e = e||event;/* get IE event ( not passed ) */
    e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
   if($("#chkAllOutputField").is(':checked')) {
       var rowCnt = jq("#list").getGridParam('reccount');
        if(rowCnt>0) {
            for(var i=0; i<rowCnt; i++) {
                var rowid = $("#list").getDataIDs()[i];
                jq('input:checkbox[name=isCheck_'+rowid+']:not(checked)').attr("checked", true);
            }
        }
   } else {
        var rowCnt = jq("#list").getGridParam('reccount');
        if(rowCnt>0) {
            for(var i=0; i<rowCnt; i++) {
                var rowid = $("#list").getDataIDs()[i];
                jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
            }
        }
   }
}

//코드 데이터 초기화
function fnDataInit() {
	$.post( //조회조건의 변경구분 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/getCodeList.sys',
		{codeTypeCd:"APPLTFIXCODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=1;i<codeList.length;i++) {
				$("#srcAppltFixCode").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			//메인 파라미터처리
			var appltFixCode = "<%=appltFixCode%>";
			if(appltFixCode != ""){
				$("#srcAppltFixCode").val(appltFixCode);
			}
		}
	);
	$.post( //조회조건의 상품변경요청 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"REQFIXAPPSTATE", isUse:"1"},
		function(arg) {
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcFixAppSts").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			initComponent();
		}
	);
}

//컨퍼넌트 초기화
function initComponent() {
    $("#srcVendorNm").val('<%=vendornm%>');
    $("#srcVendorId").val('<%=vendorid%>');
    if('<%=svcTypeCd%>' == "VEN") {
        $("#srcVendorNm").attr("disabled", true);
        $('#srcVendorNm').attr("class","input_text_none");
        $("#btnVendor").css("display","none");
        $('#appButton').hide();
        $('#retButton').hide();
    }
  //메인 파라미터처리
	var fixAppSts = "<%=fixAppSts%>";
	if(fixAppSts != ""){
		$("#srcInsertStartDate").val("<%=startDate%>");
		$("#srcInsertEndDate").val("<%=endDate%>");
		$("#srcFixAppSts").val(fixAppSts);
	}else{
		$("#srcInsertStartDate").val("<%=srcInsertStartDate%>");
		$("#srcInsertEndDate").val("<%=srcInsertEndDate%>");
		$("#srcFixAppSts").val('0');
	}
	
	// 그리드 조회
	fnInitJqGridComponent();
}
</script>

<!-- 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
    jq("#list").jqGrid("setGridParam", {"page":1});
    var data = jq("#list").jqGrid("getGridParam", "postData");
    data.srcVendorId = $('#srcVendorId').val();
    data.srcGoodName = $('#srcGoodName').val();
    data.srcInsertStartDate = $('#srcInsertStartDate').val();
    data.srcInsertEndDate = $('#srcInsertEndDate').val();
    data.srcAppltFixCode = $('#srcAppltFixCode').val();
    data.srcFixAppSts = $('#srcFixAppSts').val();
    data.goodFixDate = $('#goodFixDate').val();
    data.goodClasCode = $('#goodClasCode').val();
    data.srcProductManager = $('#srcProductManager').val();
    jq("#list").jqGrid("setGridParam", { "postData": data });
    jq("#list").trigger("reloadGrid");
    jq("#chkAllOutputField").attr("checked", false);
}

function fnConfirmation(state) {
    var fixAppSts = "";
    var msg = "";
    var cancelReason = "";
    if(state == "1" || state == "2") {
        if(<%=Constances.PROD_APPROVAL_FLAG%>) {
            //확인
            fixAppSts = "1";
            msg = "품의요청";
        } else {
            //승인
            fixAppSts = "2";
            msg = "처리완료";
        }
    } else if(state == "3") {
        //반려
        fixAppSts = "3";
        msg = "반려";
        cancelReason = $.trim($('#cancel_reason').val());
    }
    
    var fix_good_id_array = new Array();
    var good_iden_numb_array = new Array();
    var vendorid_array = new Array();
    var applt_fix_code_array = new Array();
    var sale_unit_pric_array = new Array();
    var price_array = new Array();
    var apply_desc_array = new Array();
    var insert_user_id_array = new Array();
    var insert_date_array = new Array();
    var target_price_array = new Array();
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt>0) {
        var arrRowIdx = 0;
        var chkRate = 0;
        for(var i=0; i<rowCnt; i++) {
            var rowid = $("#list").getDataIDs()[i];
            if(jq("#isCheck_"+rowid).attr("checked")) {
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                if(selrowContent.fix_App_Sts != "0") {
                    alert("처리상태가 '요청'인 것만 처리가 가능합니다.");
                    return;
                }
                if(selrowContent.applt_Fix_Code=='20' && state != "3") {	//매입단가변경일때
                	if(Number(selrowContent.buy_rate)<=0) {
                		chkRate++;
//                 		alert("["+selrowContent.good_Name+"] 상품은 기준이익율이 설정되어 있지 않습니다.\n상품상세에서 기준이익율을 설정하시고 승인처리 하십시오!");
//                 		return;
                	}
                	if(Number(selrowContent.price) >= Number(selrowContent.sell_Price)) {
                		alert("["+selrowContent.good_Name+"] 상품은 판매단가보다 매입단가가 더 크거나 같습니다. 상품상세에서 판매단가를 수정 또는 기준이익율을 설정 하시고 승인처리 하십시오!");
                		return;
                	}
                }
                fix_good_id_array[arrRowIdx] = selrowContent.fix_Good_Id;
                good_iden_numb_array[arrRowIdx] = selrowContent.good_Iden_Numb;
                vendorid_array[arrRowIdx] = selrowContent.vendorId;
                applt_fix_code_array[arrRowIdx] = selrowContent.applt_Fix_Code;
                sale_unit_pric_array[arrRowIdx] = selrowContent.sale_Unit_Pric;
                price_array[arrRowIdx] = selrowContent.price;
                apply_desc_array[arrRowIdx] = selrowContent.apply_Desc;
                insert_user_id_array[arrRowIdx] = selrowContent.insert_User_Id;
                insert_date_array[arrRowIdx] = selrowContent.insert_Date;
                target_price_array[arrRowIdx] = selrowContent.target_price;
                
                arrRowIdx++;
            }
        }
        if (arrRowIdx == 0 ) {
            jq("#dialogSelectRow").dialog({modal:true});
            return; 
        }
        if(state != "3") {
        	if(chkRate>0) {
        		if(!confirm("승인처리 상품 중 매입가보다 판매가는 크지만 기준이익율이 설정되지 않은 상품이 있습니다.\n승인처리 하시겠습니까?")) return;
        	} else {
        		if(!confirm("선택된 요청정보를 "+msg+" 하시겠습니까?")) return;
        	}
        }
        $.post(
            '<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productRequestDiscontinuanceStatusTransGrid.sys',
            { fix_good_id_array:fix_good_id_array
            , good_iden_numb_array:good_iden_numb_array
            , vendorid_array:vendorid_array
            , applt_fix_code_array:applt_fix_code_array
            , sale_unit_pric_array:sale_unit_pric_array
            , price_array:price_array
            , apply_desc_array:apply_desc_array
            , insert_user_id_array:insert_user_id_array
            , insert_date_array:insert_date_array
            , target_price_array:target_price_array
            , cancel_reason:cancelReason
            , fix_app_sts:fixAppSts }
            ,function(arg) {
                if(fnTransResult(arg,false)) {
                    alert("정상적으로 "+msg+" 처리가 되었습니다.");
                    jq("#list").trigger("reloadGrid");
                }
            }
        );
    }
}

/**
 * 운영사 상품종료(단가변경)요청 승인상태(반려) 변경
 */
function fnRequestCancelReason() {
    var rowCnt = jq("#list").getGridParam('reccount');
    if(rowCnt>0) {
        var arrRowIdx = 0;
        for(var i=0; i<rowCnt; i++) {
            var rowid = $("#list").getDataIDs()[i];
            if(jq("#isCheck_"+rowid).attr("checked")) {
                var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                if(selrowContent.fix_App_Sts != "0") {
                    alert("처리상태가 '요청'인 것만 처리가 가능합니다.");
                    return;
                }
                arrRowIdx++;
            }
        }
        if (arrRowIdx == 0 ) {
            jq("#dialogSelectRow").dialog({modal:true});
            return; 
        }
        
        fnCancelReasonDialog("fnCallBackCancelReason");
    }
}

function exportExcelToSvc() {
    var colLabels = ['상품변경요청','상품명','상품코드','상품구분','공급사','담당자','변경구분','기존매입가','변경요청매입가',
                     '변경예정판매가','현재매입가','현재판매가','현재기준이익율',
                     '요청사유','처리상태','등록자','등록일','승인자','승인일','공급사Id'];//출력컬럼명
    var colIds = ['fix_Good_Id','good_Name','good_Iden_Numb','good_Clas_Code','vendorNm','product_manager','applt_Fix_Code','sale_Unit_Pric','price',
                  'target_price','sale_price','sell_Price','buy_rate',
                  'apply_Desc','app_Sts','insert_User_Nm','insert_Date','app_User_Id','app_Date','vendorId'];//출력컬럼ID
    var numColIds = ['sale_Unit_Pric','price'];//숫자표현ID
    var sheetTitle = "상품종료(단가변경)요청조회";//sheet 타이틀
    var excelFileName = "GoodRequestDiscontinuanceList";//file명
	
	var actionUrl = "/product/productRequestDiscontinuanceListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcVendorId';
	fieldSearchParamArray[1] = 'srcGoodName';
	fieldSearchParamArray[2] = 'srcInsertStartDate';
	fieldSearchParamArray[3] = 'srcInsertEndDate';
	fieldSearchParamArray[4] = 'srcAppltFixCode';
	fieldSearchParamArray[5] = 'srcFixAppSts';
	fieldSearchParamArray[6] = 'goodFixDate';
	fieldSearchParamArray[7] = 'goodClasCode';
	fieldSearchParamArray[8] = 'srcProductManager';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<!-------------------------------- Dialog Div Start -------------------------------->
<%
/**------------------------------------공급사팝업 사용방법---------------------------------
 * fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
 * borgNm : 찾고자하는 공급사명
 * callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
 */
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp"%>
<script type="text/javascript">
/**
 * 공급사 검색
 */
function fnSearchVendor() {
    var vendorNm = $("#srcVendorNm").val();
    fnVendorDialog(vendorNm, "fnCallBackVendor");
}
/**
 * 공급사 선택 콜백
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
    $("#srcVendorId").val(vendorId);
    $("#srcVendorNm").val(vendorNm);
}
</script>

<%
/**------------------------------------운영사 반려(취소)팝업 사용방법---------------------------------//123
 * fnCancelReasonDialog(callbackString) 을 호출하여 Div팝업을 Display ===
 * callbackString : 콜백함수(문자열), 콜백함수파라메타는 1개(반려(취소) 사유) 
 */
%>
<%@ include file="/WEB-INF/jsp/product/product/productCancelReasonDiv.jsp"%>
<script type="text/javascript">
/**
 * 운영사 반려(취소) 정보 콜백
 */
function fnCallBackCancelReason(cancelReason) {
	$('#cancel_reason').val(cancelReason);
	fnConfirmation(3);
}
</script>
<!-------------------------------- Dialog Div End -------------------------------->

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function fnInitJqGridComponent() {
    jq("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productRequestDiscontinuanceListJQGrid.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'변경요청<br/>번호','상품명','상품코드','상품구분','공급사','담당자','변경구분','기존<br/>매입가',
                  '변경요청<br/>매입가','변경예정<br/>판매가','현재<br/>매입가','현재<br/>판매가','현재<br/>기준이익율','요청사유','처리상태','요청자','요청일','승인자','승인일','공급사Id','등록자Id','applt_Fix_Code_Nm','fix_App_Sts_Nm'],
        colModel:[
            { name:'isCheck',index:'isCheck',width:30,align:"center",search:false,sortable:false,editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
            { name:'fix_Good_Id',index:'fix_Good_Id',width:60,align:"left",search:false,sortable:false,editable:false,key:true },//상품변경요청Seq
            { name:'good_Name',index:'good_Name',width:160,align:"left",search:false,sortable:true,editable:false },//상품명
            { name:'good_Iden_Numb',index:'good_Iden_Numb',width:80,align:"left",search:false,sortable:true,editable:false },//상품코드
            { name:'good_Clas_Code',index:'good_Clas_Code',width:50,align:"center",search:false,sortable:true,editable:false },//상품구분
            { name:'vendorNm',index:'vendorNm',width:100,align:"left",search:false,sortable:true,editable:false },//공급사
            { name:'product_manager',index:'product_manager',width:100,align:"left",search:false,sortable:true,editable:false },//담당자
            { name:'applt_Fix_Code',index:'applt_Fix_Code',width:75,align:"center",search:false,sortable:false
                ,editable:false,formatter:"select",editoptions:{ value:"20:매입단가변경;30:종료요청" }
            },//변경구분
            { name:'sale_Unit_Pric',index:'sale_Unit_Pric',width:55,align:"right",search:false,sortable:false
                ,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" }
            },//기존매입가
            { name:'price',index:'price',width:60,align:"right",search:false,sortable:false
                ,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" }
            },//변경요청매입가
            { name:'target_price',index:'target_price',width:60,align:"right",search:false,sortable:false
                ,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" }
            },//변경예정판매가
            { name:'sale_price',index:'sale_price',width:60,align:"right",search:false,sortable:false
                ,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" } 
            },//현재매입가
            { name:'sell_Price',index:'sell_Price',width:60,align:"right",search:false,sortable:false
                ,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" } 
            },//현재판매가
            { name:'buy_rate',index:'buy_rate',width:60,align:"right",search:false,sortable:false},	//현재기준이익율
            { name:'apply_Desc',index:'apply_Desc',width:180,align:"left",search:false,sortable:false,editable:false },//요청사유
            { name:'fix_App_Sts',index:'fix_App_Sts',width:60,align:"center",search:false,sortable:false
                ,editable:false,formatter:"select",editoptions:{ value:"0:요청;1:확인_품의요청;2:승인_처리완료+;3:반려" }
            },//처리상태
            { name:'insert_User_Nm',index:'insert_User_Nm',width:50,align:"center",search:false,sortable:true,editable:false },//등록자이름
            { name:'insert_Date',index:'insert_Date',width:70,align:"center",search:false,sortable:false
                ,editable:false,formatter:"date"
            },//등록일
            { name:'app_User_Id', index:'app_User_Id', width:50, align:"center", search:false },//승인자
            { name:'app_Date',index:'app_Date',width:70,align:"center",search:false,sortable:false
                ,editable:false,formatter:"date"
            },//승인일
            { name:'vendorId',index:'vendorId',hidden:true,search:false },//공급사Id
            { name:'insert_User_Id',index:'insert_User_Id',hidden:true,search:false },//등록자Id
            { name:'applt_Fix_Code_Nm',index:'applt_Fix_Code_Nm',hidden:true,search:false },//엑셀변경구분
            { name:'fix_App_Sts_Nm',index:'fix_App_Sts_Nm',hidden:true,search:false }//엑셀처리상태
        ],
        postData: {
            srcVendorId:$('#srcVendorId').val(),
            srcGoodName:$('#srcGoodName').val(),
            srcInsertStartDate:$('#srcInsertStartDate').val(),
            srcInsertEndDate:$('#srcInsertEndDate').val(),
            srcGoodSpecDesc:$('#srcAppltFixCode').val(),
            srcFixAppSts:$('#srcFixAppSts').val(),
            goodFixDate:$('#goodFixDate').val(),
            goodClasCode:$('#goodClasCode').val(),
            srcAppltFixCode:$("#srcAppltFixCode").val(),
            srcProductManager:$("#srcProductManager").val()
        },multiselect:false,
        rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
        height:<%=listHeight%>,width:$(window).width()-50 + Number(gridWidthResizePlus),
        sortname:'fix_Good_Id',sortorder:'desc',
        viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
        loadComplete:function() {
        	var rowCnt = jq("#list").getGridParam('reccount');
        	if(rowCnt==0) {
        		jq("#chkAllOutputField").attr("checked", false);
        	}
        },
        onSelectRow:function(rowid,iRow,iCol,e) {},
        ondblClickRow:function(rowid,iRow,iCol,e) {},
        onCellSelect:function(rowid,iCol,cellcontent,target) {
            var cm = $("#list").jqGrid('getGridParam','colModel');
            if(cm[iCol]!=undefined && (cm[iCol].index == 'good_Iden_Numb' || cm[iCol].index == 'good_Name' )) {
                //var mstDatas = $("#list").jqGrid('getRowData',rowid);
                
                var good_Iden_Numb = FNgetGridDataObj('list' , rowid , 'good_Iden_Numb') ; 
                var vendorId = FNgetGridDataObj('list' , rowid , 'vendorId') ;
                
                // 공급사 사용자 
                if('<%=svcTypeCd%>' == "VEN") {
                
                    if(good_Iden_Numb != '' ){
                        fnVendorProductDetailView('<%=menuId%>' , good_Iden_Numb , vendorId);
                    }else{
                        var selrowContent = jq("#list").jqGrid('getRowData',rowid);
                        var req_Good_Id = selrowContent.req_Good_Id;
                        fnReqProductDetailView('<%=menuId%>',req_Good_Id);
                    }
                    
                // 운영사 사용자 
<%--                 }else if('<%=svcTypeCd%>' == "ADM") { --%>
//                     if(FNgetGridDataObj('list' , rowid , 'good_Iden_Numb') != '' ){
<%--                     	fnProductDetailView('<%= menuId %>' , good_Iden_Numb , vendorId ); --%>
//                     }else{
//                     	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
//                         var req_Good_Id = selrowContent.req_Good_Id;
<%--                         fnReqProductDetailView('<%=menuId%>',req_Good_Id); --%>
//                     }
//                 }
                }else if('<%=svcTypeCd%>' == "ADM") {
                    if(FNgetGridDataObj('list' , rowid , 'good_Iden_Numb') != '' ){
                    	var price = FNgetGridDataObj('list' , rowid , 'price') ;
                    	var target_price = FNgetGridDataObj('list' , rowid , 'target_price') ;
                    	fnProductDisPop('<%= menuId %>' , good_Iden_Numb , vendorId , price , target_price );
                    }
                }
            }
        },
        afterInsertRow:function(rowid,aData) {
            jq("#list").setCell(rowid,'good_Iden_Numb','',{color:'#0000ff',cursor: 'pointer'});
            jq("#list").setCell(rowid,'good_Name','',{color:'#0000ff',cursor: 'pointer'});
            
            var applt_Fix_Code_Nm = '';
            var fix_App_Sts_Nm = '';
            if(aData.applt_Fix_Code == "20") {
				applt_Fix_Code_Nm = '매입단가변경';
            } else if(aData.applt_Fix_Code == "30") {
            	applt_Fix_Code_Nm = '종료요청';
            }
            jQuery('#list').jqGrid('setRowData',rowid,{applt_Fix_Code_Nm:applt_Fix_Code_Nm});
            
            if (aData.fix_App_Sts == "0") {
            	fix_App_Sts_Nm = '요청';
            } else if (aData.fix_App_Sts == "1") {
            	fix_App_Sts_Nm = '확인';
            } else if (aData.fix_App_Sts == "2") {
            	fix_App_Sts_Nm = '승인_처리완료+';
            } else if (aData.fix_App_Sts == "3") {
            	fix_App_Sts_Nm = '반려';
            }
            jQuery('#list').jqGrid('setRowData',rowid,{fix_App_Sts_Nm:fix_App_Sts_Nm});
        },
        loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
        jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
    });
    jQuery("#list").jqGrid('setGridWidth', 1500);
};
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnProductDisPop(menuId , productCode, vendorId, price, target_price ) {

	var popurl = "/product/popProductAdm.sys?_menuId="+menuId;
	var popproperty = "width=917,height=800,scrollbars=yes,status=no,resizable=no";
	
    if(productCode != undefined)    popurl+="&good_iden_numb="+productCode; 
    if(vendorId != undefined)       popurl+="&vendorid="+vendorId;            
    if(price != undefined)       	popurl+="&price="+price;            
    if(target_price != undefined)   popurl+="&target_price="+target_price;            
    
	var win = window.open(popurl,'window',popproperty);
	win.focus();
}


function checkboxFormatter(cellvalue, options, rowObject) {
    if('<%=svcTypeCd%>' == "ADM") {
        return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' offval='no' style='border:none;'/>";
    } else if('<%=svcTypeCd%>' == "VEN") {
        return "";
    }
}

//그리드 커서
function pointercursor(cellvalue, options, rowObject) {
    var new_formatted_cellvalue = '<span class="pointer">' + cellvalue + '</span>';
    return new_formatted_cellvalue;
}

//상세페이지 이동 
function editRow(goodIdenNumb ,vendorId) {
    //fnProductDetailView(<%=menuId %>,goodIdenNumb, vendorId);
    fnVendorProductDetailView(<%=menuId %>,goodIdenNumb, vendorId);
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { vendorManual(); });	//메뉴얼호출
});

function vendorManual(){
	var header = "";
	var manualPath = "";
	//상품종료(단가변경)요청조회
	header = "상품종료(단가변경)요청조회";
	manualPath = "/img/manual/vendor/productRequestDiscontinuanceList.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

<script type="text/javascript">
function goodClasCodeSelect() {
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"ORDERGOODSTYPE",
			isUse:"1"
		},
		function(arg){
			var goodClasCodeList = eval('('+arg+')').list;
			for(var i=0; i<goodClasCodeList.length; i++){
				$("#goodClasCode").append("<option value='"+goodClasCodeList[i].codeVal1+"'>"+goodClasCodeList[i].codeNm1+"</option>");
			}
		}
		
	);
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" method="post">
<input id="cancel_reason" name="cancel_reason" type="hidden" value="" />
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
	<tr>
		<td colspan="2">
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
					<td height="29" class="ptitle">상품종료(단가변경)요청조회
					<%if(isVendor){ %>
						&nbsp;<span id="question" class="questionButton">도움말</span>
					<%} %>
					</td>
                    <td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
                        <button id='excelAll' type='button' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
                        <button id='srcButton' type='button' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
					</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">공급사</td>
					<td class="table_td_contents">
						<input id="srcVendorNm" name="srcVendorNm" type="text" value="" size="" maxlength="50" />
						<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
						<img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;border:0px;vertical-align:middle;cursor:pointer;" /></td>
					<td class="table_td_subject" width="100">상품명</td>
					<td class="table_td_contents">
						<input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" /></td>
					<td class="table_td_subject" width="100">
						<select id="goodFixDate">
							<option value="0">요청일자</option>
							<option value="1">승인일자</option>
						</select>
					</td>
					<td class="table_td_contents">
						<input id="srcInsertStartDate" name="srcInsertStartDate" type="text" style="width:75px;" /> ~
						<input id="srcInsertEndDate" name="srcInsertEndDate" type="text" style="width:75px;" /></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">변경구분</td>
					<td class="table_td_contents">
						<select id="srcAppltFixCode" name="srcAppltFixCode" style="width:100px;" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<td class="table_td_subject">처리상태</td>
					<td class="table_td_contents">
						<select id="srcFixAppSts" name="srcFixAppSts" style="width:100px;" class="select">
							<option value="">전체</option>
						</select>
					</td>
					<td class="table_td_subject">상품구분</td>
					<td colspan="3" class="table_td_contents">
						<select id="goodClasCode" name="goodClasCode" style="width:100px;" class="select">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">상품담당자</td>
	                <td class="table_td_contents">
	                	<select class="select" id="srcProductManager" name="srcProductManager">
	                    	<option value="">전체</option>
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
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr><td colspan="2" height="10"></td></tr>
	<tr>
		<td align="left" width="60%">
			<font color='red'>* 상품상세 팝업에서 판매가를 수정하신 경우 현재 판매가를 읽어오기 위해 다시 조회를 해 주시기 바랍니다.</font>
		</td>
		<td height="27px" align="right" valign="bottom" width="40%">
		    <button id='appButton' type='button' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>">승인</button>
            <button id='retButton' type='button' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>">반려</button>
		</td>
	</tr>
    <tr><td colspan="2" height="1"></td></tr>
	<tr>
		<td colspan="2">
			<div id="jqgrid">
				<table id="list"></table>
				<div id="pager"></div>
			</div>
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size:12px;color:red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>