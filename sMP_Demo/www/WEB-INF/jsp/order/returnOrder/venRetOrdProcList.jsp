<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	String srcOrderStartDate = CommonUtils.nvl((String)request.getAttribute("srcOrderStartDate"), CommonUtils.getCustomDay("MONTH", -2)) ;
	String srcOrderEndDate = CommonUtils.nvl((String)request.getAttribute("srcOrderEndDate"), CommonUtils.getCurrentDate()) ;
	
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
    <link rel="stylesheet" type="text/css" href="/css/Global.css">
    <link rel="stylesheet" type="text/css" href="/css/Default.css">
<style type="text/css">
.popOrderReject {
	display: none;
	position: fixed;
	top: 17%;
	left: 50%;
	margin-left: -300px;
	width: 530px;
	background-color: #EEE;
	color: #333;
}
</style>
</head>
<body class="subBg">
<div id="divWrap">
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
	<hr>
	<div id="divBody">
		<div id="divSub">
			<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
			<div id="AllContainer">                    
				<ul class="Tabarea">
					<li class="on">반품신청현황</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
					<a href="#;"><img src="/img/contents/btn_excelDN.gif" id="allExcelButton" name="allExcelButton"></a>
					<a href="javascript:void(0);">
						<img id="btnSearch" src="/img/contents/btn_tablesearch.gif" />
					</a>
				</div>
				<table class="InputTable">
					<colgroup>
						<col width="120px" />
						<col width="auto" />
						<col width="120px" />
						<col width="auto" />
					</colgroup>
					<tr>
						<th>구매사</th>
						<td>
							<input type="text" style="width:200px;" id="srcBranchName"/> 
						</td>
						<th>주문번호</th>
						<td>
							<input type="text" style="width:200px;" id="srcOrdeIdenNumb"/>
						</td>
					</tr>
					<tr>
						<th>
							<select id="srcDateType">
								<option value="regi">주문일</option>
								<option value="retu" selected="selected">반품요청일</option>
							</select>
						</th>
						<td>
							<input type="text" id="srcOrderStartDate" style="width:80px;" value="<%=srcOrderStartDate%>"/>
							~
							<input type="text" id="srcOrderEndDate" style="width:80px;" value="<%=srcOrderEndDate%>"/>
						</td>
						<th>반품 상태</th>
						<td>
							<select name="srcRtnStat" id="srcRtnStat" style="width:100px;">
								<option value="">전체</option>
								<option value="0" selected="selected">반품요청</option>
								<option value="1">반품승인</option>
								<option value="9">반품반려</option>
							</select>
						</td>
					</tr>
				</table>
				<div class="Ar mgt_20">
					<button id='srcAppButton' class="btn btn-darkgray btn-xs" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>><i class="fa fa-circle-o"></i> 반품승인</button>
					<button id='srcRejButton' class="btn btn-darkgray btn-xs" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>><i class="fa fa-times"></i> 반품반려</button>
				</div>
				<div class="ListTable mgt_5">
					<table id="orderHistTable">
						<colgroup>
							<col width="50px" />
							<col width="100px" />
							<col width="250px" />
							<col width="auto" />
							<col width="120px" />
							<col width="120px" />
							<col width="100px" />
						</colgroup>
						<tr>
							<th class="br_l0">
								<input type="checkbox" name="chkAllOutputField" id="chkAllOutputField" onclick='javascript:allCheckBoxCtl(event);'/>
								<label for="checkbox"></label>
							</th>
							<th>
								<p>반품요청일/</p>
								<p>인수일</p>
							</th>
							<th>주문정보</th>
							<th> 주문 상품 정보</th>
							<th>수량정보</th>
							<th>반품사유</th>
							<th>비고</th>
						</tr>
					</table>
				</div>
				<div class="divPageNum" id="pager"></div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
	</div>
	<hr>
</div>
<div id="ordRejectPop" class="jqmPop" style="font_size: 12px; display: none;">
    <div>
        <div id="divPopup" style="width:500px; height: 225px; ">
            <h1 id="divPopupTitle">반품 반려<a href="#" onclick="fnPopClose();"><img src="/img/contents/btn_close.png"/></a></h1>
            <div class="popcont">
                <table class="InputTable">
                    <colgroup>
                        <col width="100px" />
                        <col width="auto" />
                    </colgroup>
                    <tr>
                        <th>사유</th>
                        <td>
                            <textarea id="chanReasDesc" cols="" rows="" style="width:98%; height: 100px;"></textarea>
                        </td>
                    </tr>
                </table>
                <div class="Ac mgt_10">
                    <button id='popOrdPurcBtn' class='btn btn-darkgray btn-sm' onclick="javascript:processOrderReturnReject();" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>>반품반려</button>
                    <button id='popOrdPurcRejectBtn' class='btn btn-default btn-sm' onclick="fnPopClose();">닫기</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script>
$(document).ready(function() {
	fnInitEvent();
	fnInitDatePicker();
	fnInitDivPopup();
    venRetOrdProdList();
    
    $("#allExcelButton").click(function(){
		var colLabels = ["반품요청일","인수일","주문번호","상품코드","상품명","상품규격","상태","업체명","주문수량","인수수량","반품수량","반품사유"];
		var colIds = ["RETU_REGI_DATE","RECE_REGI_DATE","ORDE_IDEN_NUMB","GOOD_IDEN_NUMB","GOOD_NAME","GOOD_SPEC","RETU_STAT_FLAG_NM","ORDE_CLIENT_NAME","ORDE_REQU_QUAN","SALE_PROD_QUAN","RETU_PROD_QUAN","RETU_RESE_TEXT"];
		var numColIds = ["ORDE_REQU_QUAN","SALE_PROD_QUAN","RETU_PROD_QUAN"];
		
		var sheetTitle = "반품신청현황";	//sheet 타이틀
		var excelFileName = "venRetOrdProcList";	//file명
		var fieldSearchParamArray = new Array();
	    fieldSearchParamArray[0] = 'srcBranchName';
	    fieldSearchParamArray[1] = 'srcOrdeIdenNumb';
	    fieldSearchParamArray[2] = 'srcDateType';
	    fieldSearchParamArray[3] = 'srcOrderStartDate';
	    fieldSearchParamArray[4] = 'srcOrderEndDate';
	    fieldSearchParamArray[5] = 'srcRtnStat';
	    fnExportExcelToSvc('', colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray,"/venOrder/getReturnOrdStatListExcel.sys");
	});
});

function fnInitDivPopup(){
	$("#ordRejectPop").jqm();
	$('#ordRejectPop').jqm().jqDrag('#divPopupTitle');
	
    $("#srcAppButton").click(function(){
		orderReturnApproval();
    });
    
    $("#srcRejButton").click(function(){
		fnRejectPopupOpen();
    });
}

function fnInitDatePicker(){
	$("#srcOrderStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("#srcOrderEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;");
}

function fnInitEvent(){
	$("#divGnb").mouseover(function(){
		$("#snb_vdr").show();
	});
	
	$("#divGnb").mouseout(function(){
		$("#snb_vdr").hide();
	});
	
	$("#snb_vdr").mouseover(function(){
		$("#snb_vdr").show();
	});
	
	$("#snb_vdr").mouseout(function (){
		$("#snb_vdr").hide();
	});
	
	$("#btnSearch").click(function(){
        venRetOrdProdList();
    });
    
	$("#srcBranchName").keydown(function(e){
		if(e.keyCode==13){
			$("#btnSearch").click();
		}
	});
	
	$("#srcOrdeIdenNumb").keydown(function(e){
		if(e.keyCode==13){
			$("#btnSearch").click();
		}
	});
	
	$("#srcOrderStartDate").keydown(function(e){
		if(e.keyCode==13){
			$("#btnSearch").click();
		}
	});
	
	$("#srcOrderEndDate").keydown(function(e){
		if(e.keyCode==13){
			$("#btnSearch").click();
		}
	});
	
	$("#srcRtnStat").change(function(e){
		$("#btnSearch").click();
	});
}

function venRetOrdProdListEmpty(){
	var length = $(".trData").length;
	
    if(length > 0){
        for(var i = 0; i < length; i++){
            $("#trData_"+i).remove();
        }
    }
    
    $("#pager").empty();
}

function venRetOrdProdListCallbackPage(currPage, total, records){
	var pageGrp   = null;
	var startPage = 0;
	var endPage   = 0;
	
	if(records > 0){
		pageGrp   = fnPagerInfo(currPage, total, 5);
		startPage = pageGrp.startPage;
		endPage   = pageGrp.endPage;
		
		fnPager(startPage, endPage, currPage, total, "venRetOrdProdList");
	}
}

function venRetOrdProdListCallbackList(list, records){
	var str = "";
	
	if(records > 0){
		for(var i=0; i<list.length; i++){
	        str += "<tr class='trData' id='trData_"+i+"'>                                                          ";
            str += "    <td align=\"center\" class=\"br_l0\">                                       ";
            
            if(list[i].RETU_STAT_FLAG == "0"){
            	
            str += "   	<input type='checkbox' name='receCbox' id='receCbox_"+i+"' value='"+i+"'/> ";
            
            }
            
            str += "   	<input type='hidden' id='retu_iden_num_"+i+"' name='retu_iden_num_"+i+"' value='"+list[i].RETU_IDEN_NUM+"'/> ";
            str += "   	<input type='hidden' id='retu_prod_quan_"+i+"' name='retu_prod_quan_"+i+"' value='"+list[i].RETU_PROD_QUAN+"'/> ";
            str += "   	<input type='hidden' id='orde_iden_numb_"+i+"' name='orde_iden_numb_"+i+"' value='"+list[i].ORDE_IDEN_NUMB+"'/> ";
            str += "   	<input type='hidden' id='purc_iden_numb_"+i+"' name='purc_iden_numb_"+i+"' value='"+list[i].PURC_IDEN_NUMB+"'/>  ";
            str += "   	<input type='hidden' id='deli_iden_numb_"+i+"' name='deli_iden_numb_"+i+"'  value='"+list[i].DELI_IDEN_NUMB+"'/>    ";
            str += "   	<input type='hidden' id='rece_iden_numb_"+i+"' name='rece_iden_numb_"+i+"'  value='"+list[i].RECE_IDEN_NUMB+"'/>    ";
            str += "    </td>                                                                   ";
            str += "    <td align=\"center\">                                                     ";
            str += "    	<p>"+list[i].RETU_REGI_DATE+"</p>                                                  ";
            str += "       <p>"+list[i].RECE_REGI_DATE+"</p>                                                   ";
            str += "    </td>                                                                   ";
            str += "    <td>                                                                    ";
            str += "    	<p>";
            str += 				"<a href=\"javascript:fnOrderDetailView('" + list[i].ORDE_IDEN_NUMB + "', '', '');\">";
            str +=					list[i].ORDE_IDEN_NUMB;
            str +=				"</a>";
            str +=			"</p>                              ";
            str += "        <div class=\"f11\">                                                   ";
            str += "            <p><strong>주문명</strong> : "+list[i].CONS_IDEN_NAME+"</p>  ";
            str += "            <p><strong>구매사</strong> : "+list[i].ORDE_CLIENT_NAME+"</p>                         ";
            str += "        </div>                                                              ";
            str += "    </td>                                                                   ";
            str += "    <td>                                                                    ";
            str += "    	<p><a href='javascript:fnPdtSimpleDetailPop(\""+list[i].GOOD_IDEN_NUMB+"\");"+"'>"+list[i].GOOD_NAME+"</a></p>                          ";
            str += "        <div class=\"f11\">                                                   ";
            str += "            <p><strong>규격</strong> : "+list[i].GOOD_SPEC+" </p>                ";
            str += "        </div>                                                              ";
            str += "    </td>                                                                   ";
            str += "    <td>                                                                    ";
            str += "    	<p><strong>주문수량</strong> : "+list[i].ORDE_REQU_QUAN+"개</p>                                 ";
            str += "        <p><strong>납품수량</strong> : "+list[i].SALE_PROD_QUAN+"개</p>                                 ";
            str += "        <p><strong>반품수량</strong> : "+list[i].RETU_PROD_QUAN+"개</p>                                  ";
            str += "    </td>                                                                   ";
            str += "    <td>                                                                    ";
            str += "    	<p>"+list[i].RETU_RESE_TEXT+"</p>                                                    ";
            str += "    </td>                                                                   ";
            str += "    <td align=\"center\">"+list[i].RETU_STAT_FLAG_NM+"</td>                                              ";
            str += "</tr>                                                                       ";
		}
	}
	else{
        str += " <tr class='trData' id='trData_0'>                                                                                                                                            ";
        str += "   <td class='br_l0' colspan='8' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                          ";
        str += " </tr>                                                                                                                                                         ";
        
	}
	
	$("#orderHistTable").append(str);
}

function venRetOrdProdListCallback(arg){
    var list		= arg.list;
	var currPage	= arg.page;
	var rows		= arg.rows;
	var total		= arg.total;
	var records		= arg.records;
	
	venRetOrdProdListCallbackPage(currPage, total, records);
	venRetOrdProdListCallbackList(list, records);
	
	$.unblockUI();
}

function venRetOrdProdList(page){
	$.blockUI();
	
	venRetOrdProdListEmpty();
	
	$.post(
		"/venOrder/getReturnOrdStatList.sys",
		{
			srcBranchName     : $("#srcBranchName").val(),
			srcOrdeIdenNumb   : $("#srcOrdeIdenNumb").val(),
			srcOrderStartDate : $("#srcOrderStartDate").val(),
			srcOrderEndDate   : $("#srcOrderEndDate").val(),
			srcRtnStat        : $("#srcRtnStat").val(),
			page              : page,
			rows              : 10,
			srcDateType       : $("#srcDateType").val()
		},
		function(arg){
			venRetOrdProdListCallback(arg);
		},
		"json"
	);
}

function allCheckBoxCtl(){
	var rowCnt = $("[name=receCbox]").length;
	
    if(rowCnt>0) {
        for(var i=0; i<rowCnt; i++) {
            if($("#chkAllOutputField").is(':checked')) {
                if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == false){
                    $("#"+$("[name=receCbox]")[i].id).attr("checked", "checked");
                }
            }else{
                if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
                    $("#"+$("[name=receCbox]")[i].id).attr("checked", false);
                }
            }
        }
    }
}

<%-- 반품반려 --%>
function orderReturnReject(){
	var rowCnt = $("[name=receCbox]").length;
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			alert("처리 할 반품 정보를 선택 해 주십시오.");
			return; 
		}
	}
	
	confirmMessage("선택된 반품요청 정보를 반려처리하시겠습니까?", orderReturnRejectCallback);
}

function orderReturnRejectCallback(){
	$("#ordRejectPop").jqmShow();
}

function fnRejectPopupOpen(){
	$("#chanReasDesc").val("");
	var ordPurcChkCnt		= $("input[name=receCbox]:checkbox:checked").length;
	if(ordPurcChkCnt == 0){//체크된 갯수가 0이면 경고창
		alert("처리할 데이터가 없습니다..");
		return;
	}
	$("#ordRejectPop").jqmShow();
}
function processOrderReturnReject(){
	var return_iden_numb_array = new Array();
	//반품거부시 sms보내기 추가
	var orde_iden_numb_array = new Array();
	var purc_iden_numb_array = new Array();
	var deli_iden_numb_array = new Array();
	var rowCnt = $("[name=receCbox]").length;
	var chanReasDesc = $("#chanReasDesc").val();
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
			    orde_iden_numb_array[arrRowIdx] = $("#orde_iden_numb_"+i).val();
			    purc_iden_numb_array[arrRowIdx] = $("#purc_iden_numb_"+i).val();
			    deli_iden_numb_array[arrRowIdx] = $("#deli_iden_numb_"+i).val();
			    return_iden_numb_array[arrRowIdx] = $("#retu_iden_num_"+i).val();
				arrRowIdx++;
			}
		}
        $.blockUI();
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/venOrderReturnRejectTransGrid.sys",
			{  return_iden_numb_array:return_iden_numb_array 
			  ,reason:chanReasDesc
			  ,orde_iden_numb_array:orde_iden_numb_array
			  ,purc_iden_numb_array:purc_iden_numb_array
			  ,deli_iden_numb_array:deli_iden_numb_array
			}
			,function(arg){ 
				if($.parseJSON(arg).customResponse.success){
					alert("정상적으로 반려처리가 되었습니다.");
				} else {
					alert("이미 처리된 반품이 존재합니다.");
				}
				fnPopClose();
				venRetOrdProdList();
				$.unblockUI();
			}
		);
	}
}
function processOrderReturnReject_cancel(){}

function fnPopClose(){
	$("#ordRejectPop").jqmHide();
}

function orderReturnApproval(){
	var rowCnt = $("[name=receCbox]").length;
	var arrRowIdx = 0 ;
	
	if(rowCnt>0) {
		
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
				arrRowIdx++;
			}
		}
		
		if (arrRowIdx == 0 ) {
            alert("처리할 데이터가 없습니다..");
            
			return; 
		}
		
		confirmMessage("선택된 반품요청 정보를 승인처리 하시겠습니까?", orderReturnApprovalCallback);
	}
}

function orderReturnApprovalCallback(){
	var orde_iden_numb_array = new Array();
	var purc_iden_numb_array = new Array();
	var deli_iden_numb_array = new Array();
	var return_iden_numb_array = new Array();
	var retu_prod_quan_array = new Array();
	
	var rowCnt = $("[name=receCbox]").length;
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
			    orde_iden_numb_array[arrRowIdx] = $("#orde_iden_numb_"+i).val();
			    purc_iden_numb_array[arrRowIdx] = $("#purc_iden_numb_"+i).val();
			    deli_iden_numb_array[arrRowIdx] = $("#deli_iden_numb_"+i).val();
			    return_iden_numb_array[arrRowIdx] = $("#retu_iden_num_"+i).val();
			    retu_prod_quan_array[arrRowIdx] = $("#retu_prod_quan_"+i).val();
				arrRowIdx++;
			}
		}
		
		$.blockUI();
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/returnOrder/venOrderReturnApprovalTransGrid.sys",
			{  
				orde_iden_numb_array:orde_iden_numb_array 
			,	purc_iden_numb_array:purc_iden_numb_array 
			,	deli_iden_numb_array:deli_iden_numb_array 
			,	return_iden_numb_array:return_iden_numb_array 
			,	retu_prod_quan_array:retu_prod_quan_array 
			}
			,function(arg){ 
				if($.parseJSON(arg).customResponse.success){
					alert("정상적으로 승인처리가 되었습니다.");
				} else {
					alert("이미 처리된 반품이 존재합니다.");
				}
				venRetOrdProdList();
				$.unblockUI();
			}
		);
	}
}
</script>
</html>