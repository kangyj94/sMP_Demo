<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.security.cert.CRL"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.order.dto.OrderDeliDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%	
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");

	String srcOrderStartDate = CommonUtils.nvl((String)request.getAttribute("srcOrderStartDate"), CommonUtils.getCustomDay("MONTH", -1)) ;
	String srcOrderEndDate   = CommonUtils.nvl((String)request.getAttribute("srcOrderEndDate"), CommonUtils.getCurrentDate()) ;
	String _menuId           = CommonUtils.getRequestMenuId(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
</head>
<body class="mainBg">
<div id="divWrap">
	<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
	<hr>
	<div id="divBody">
		<div id="divSub">
			<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
			<div id="AllContainer">                    
				<ul class="Tabarea">
					<li class="on">상품 인수 조회</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
					<a href="javascript:void(0);">
						<img src="/img/contents/btn_tablesearch.gif" id="btnSearch"/>
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
						<th>주문번호</th>
						<td>
							<input type="text" style="width:200px;" id="srcOrdeIdenNumb"/>
						</td>
						<th>공급사</th>
						<td>
							<input type="text" style="width:200px;" id="srcVendorNm"/>
						</td>
					</tr>
					<tr>
						<th>
							<select id="srcDateType">
								<option value="regi">주문일</option>
								<option value="deli" selected="selected">배송일</option>
							</select>
						</th>
						<td colspan="3">
							<input type="text" id="srcOrderStartDate" style="width:80px;" value="<%=srcOrderStartDate%>"/>
							~
							<input type="text" id="srcOrderEndDate" style="width:80px;" value="<%=srcOrderEndDate%>"/>
						</td>
					</tr>
				</table>
				<div class="Ar mgt_20">
					<button id='btnReceiptProcChkBox' class="btn btn-darkgray btn-xs" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>><i class="fa fa-floppy-o"></i> 인수확인</button>
				</div>
				<div class="ListTable mgt_5">
					<table id="orderReciptTable">
						<colgroup>
							<col width="30px" />
							<col width="100px" />
							<col width="220px" />
							<col width="auto" />
							<col width="120px" />
							<col width="100px" />
						</colgroup>
						<tr>
							<th class="br_l0">
								<input type="checkbox" name="chkAllOutputField" id="chkAllOutputField" onclick='javascript:allCheckBoxCtl(event);'/>
								<label for="checkbox"></label>
							</th>
							<th><span class="col02">배송일</span>(주문일)</th>
							<th>주문번호(공사명)</th>
							<th>주문상품정보</th>
							<th>수량정보</th>
							<th>비고</th>
						</tr>
					</table>
				</div>
				<div class="divPageNum" id="pager"></div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
	</div>
	<hr>
</div>
</body>
<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script>
$(document).ready(function() {
	fnInitEvent();
	fnInitDatepicker();
	fnClientReceiveList();
});

function fnInitDatepicker(){
	$("#srcOrderStartDate").datepicker({
		showOn          : "button",
		buttonImage     : "/img/contents/btn_calenda.gif",
		buttonImageOnly : true,
		dateFormat      : "yy-mm-dd"
	});
	
	$("#srcOrderEndDate").datepicker({
		showOn          : "button",
		buttonImage     : "/img/contents/btn_calenda.gif",
		buttonImageOnly : true,
		dateFormat      : "yy-mm-dd"
	});
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;");
}

function fnInitEvent(){
	$("#divGnb").mouseover(function(){
		$("#snb").show();
	});
	
	$("#divGnb").mouseout(function(){
		$("#snb").hide();
	});
	
	$("#snb").mouseover(function(){
		$("#snb").show();
	});
	
	$("#snb").mouseout(function(){
		$("#snb").hide();
	});
	
	$("#btnSearch").click(function(){
        fnClientReceiveList();
    });
	
	$("#srcOrdeIdenNumb").keydown(function(e){
		if(e.keyCode == 13){
			$("#btnSearch").click();
		}
	});
	
	$("#srcVendorNm").keydown(function(e){
		if(e.keyCode == 13){
			$("#btnSearch").click();
		}
	});
	
	$("#srcOrderStartDate").keydown(function(e){
		if(e.keyCode == 13){
			$("#btnSearch").click();
		}
	});
	
	$("#srcOrderEndDate").keydown(function(e){
		if(e.keyCode == 13){
			$("#btnSearch").click();
		}
	});
	   
	$("#btnReceiptProcChkBox").click(function(){
		fnReceiptProc();
	});
}

function fnClientReceiveListClean(){
	var length = $(".orderRecipt").length;
	
    if(length > 0){
        for(var i=0; i<length; i++){
            $("#orderRecipt_"+i).remove();
        }
    }
    
    $("#pager").empty();
}

function fnClientReceiveListCallbackList(list, records){
	var mstCnt     = 0;
	var str        = "";
	var i          = 0;
	var listLength = 0;
	var listInfo   = null;
	var rowspanStr = null;
	
	if(records > 0){
		listLength = list.length;
		
    	for(i = 0; i < listLength; i++){
    		listInfo = list[i];
    		
			var isAddMst         = listInfo.is_add_mst;
			var deliDegrDate     = listInfo.deli_degr_date;
			var regiDateTime     = listInfo.regi_date_time;
			var ordeIdenNumb     = listInfo.orde_iden_numb;
			var consIdenName     = listInfo.cons_iden_name;
			var purcIdenNumb     = listInfo.purc_iden_numb;
			var deliIdenNumb     = listInfo.deli_iden_numb;
			var deliProdQuan     = listInfo.deli_prod_quan;
			var receiptNum       = listInfo.receipt_num;
			var goodSpecDesc     = listInfo.good_spec_desc;
			var deliTypeClasCode = listInfo.deli_type_clas_code;
			var deliInvoIden     = listInfo.deli_invo_iden;
			var goodName         = listInfo.good_name;
			var goodSpecDesc     = listInfo.good_spec_desc;
			var vendorNm         = listInfo.vendornm;
			var purcRequQuan     = listInfo.purc_requ_quan;
			var goodIdenNumb     = listInfo.good_iden_numb;
			var vendorId         = listInfo.vendorId;
			
			str += "<tr class='orderRecipt' id='orderRecipt_" + i + "'>";
			
            if(isAddMst == "Y" ) {
                rowspanStr = "rowspan='2'";
            }
            else{
            	rowspanStr = "";
            }
            
            if(mstCnt == 0 ){
            	str +=	"<td align='center' class='br_l0' " + rowspanStr + ">";
            	str +=		"<input type='checkbox' name='receCbox' id='receCbox_" + i + "' value='" + i + "'/>";
            	str +=	"</td>";
            }
            
            str +=	"<td align='center'>";
            str +=		"<p><span class='col02'>" + deliDegrDate + "</span><br/>(" + regiDateTime + ")</p>";
            str +=	"</td>";
            str +=	"<td>";
            str +=		"<p><a href='#' onclick=\"javascript:fnOrderDetailView('"+ordeIdenNumb+"', '<%=_menuId%>' ,'"+purcIdenNumb+"')\">" + ordeIdenNumb + "</a></p>";
            str +=		"<p class='f11'>(" + consIdenName + ")</p>";
            str +=		"<input type='hidden' id='orde_iden_numb_" + i + "'      name='orde_iden_numb_" + i + "'      value='" + ordeIdenNumb + "'/>";
            str +=		"<input type='hidden' id='purc_iden_numb_" + i + "'      name='purc_iden_numb_" + i + "'      value='" + purcIdenNumb + "'/>";
            str +=		"<input type='hidden' id='deli_iden_numb_" + i + "'      name='deli_iden_numb_" + i + "'      value='" + deliIdenNumb + "'/>";
            str +=		"<input type='hidden' id='deli_prod_quan_" + i + "'      name='deli_prod_quan_" + i + "'      value='" + deliProdQuan + "'/>";
            str +=		"<input type='hidden' id='receipt_num_"    + i + "'      name='receipt_num_"    + i + "'      value='" + receiptNum + "'/>";
            str +=		"<input type='hidden' id='good_spec_desc_" + i + "'      name='good_spec_desc_" + i + "'      value='" + goodSpecDesc + "'/>";
            str +=		"<input type='hidden' id='deli_type_clas_code_" + i + "' name='deli_type_clas_code_" + i + "' value='" + deliTypeClasCode + "'/>";
            str +=		"<input type='hidden' id='deli_invo_iden_" + i + "'      name='deli_invo_iden_" + i + "'      value='" + deliInvoIden + "'/>";
            str +=		"<input type='hidden' id='is_add_mst_" + i + "'          name='is_add_mst_" + i + "'          value='" + isAddMst + "'/>";
            str +=	"</td>";
            str +=	"<td>";
            str +=		"<p>";
            str +=			"<a href='javascript:fnProductDetailPop(\"" + goodIdenNumb + "\", \"" + vendorId + "\");'>" + goodName + "</a>";
            str +=		"</p>";
            str +=		"<div class='f11'>";
            str +=			"<p><strong>규격&nbsp;&nbsp;&nbsp;&nbsp; : </strong>" + goodSpecDesc + "</p>";
            str +=			"<p><strong>공급사 : </strong>" + vendorNm + "</p>";
            str +=		"</div>";
            str +=	"</td>";
            str +=	"<td>";
            str +=		"<p><strong>주문수량 : </strong>" + fnComma(purcRequQuan) + "개</p>";
            str +=		"<p><strong>출하수량 : </strong>" + fnComma(deliProdQuan) + "개</p>";
            str +=	"</td>";
            str +=	"<td align='center' >";
            
            if(mstCnt == 0){
            	str += "<p style='padding-top:1px;padding-bottom:1px;'>";
            	str += 	"<button id='btnReceiptProc' class='btn btn-darkgray btn-xs' style='width:70px;' onclick=\"javascript:fnReceiptProcOne('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>> 인수확인</button>";
            	str += "</p>";
            	str += "<p style='padding-top:1px;padding-bottom:1px;'>";
            	str +=	"<button id='btnDeliInfoTrace' class='btn btn-default btn-xs' style='width:70px;' onclick=\"javascript:fnDeliInfoTrace('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 배송추적</button>";
            	str += "</p>";
				str += "<p style='padding-top:1px;padding-bottom:1px;'>";
				str += 	"<button id='btnReceiptPrint' class='btn btn-default btn-xs' style='width:70px;' onclick=\"javascript:openReceiptPrint('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 인수증출력</button>";
				str += "</p>";
            }
            else{
            	str += "<p style='padding-top:1px;padding-bottom:1px;'>";
            	str +=	"<button id='btnReceiptPrint' class='btn btn-default btn-xs' style='width:70px;' onclick=\"javascript:openReceiptPrint('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 인수증출력</button>";
            	str += "</p>";
            }
            
            str +=	"</td>";
            str += "</tr>";
            
            if(isAddMst == "Y"){
            	mstCnt++;
            }
            else{
            	mstCnt = 0;
            }
		}
	}
	else{
        str += "<tr class='orderRecipt' id='orderRecipt_0'>";
        str +=	"<td class='br_l0' colspan='6' align='center' >조회된 결과가 없습니다.</td>";
        str += "</tr>";
	}
	
	$("#orderReciptTable").append(str);
}

function fnClientReceiveListCallbackPage(currPage, total, records){
	var pageGrp   = null;
	var startPage = 0;
	var endPage   = 0;
	
	if(records > 0){
		pageGrp   = fnPagerInfo(currPage, total, 5);
		startPage = pageGrp.startPage;
		endPage   = pageGrp.endPage;
		
		fnPager(startPage, endPage, currPage, total, "fnClientReceiveList");
	}
}

function fnClientReceiveListCallback(arg){
	var list	 = arg.list;
	var currPage = arg.page;
	var rows	 = arg.rows;
	var total	 = arg.total;
	var records	 = arg.records;
	
	fnClientReceiveListClean();
	fnClientReceiveListCallbackList(list, records);
	fnClientReceiveListCallbackPage(currPage, total, records);
	
	$.unblockUI();
}

function fnClientReceiveList(page){
	var srcOrdeIdenNumb   = $.trim($("#srcOrdeIdenNumb").val());
	var srcVendorNm       = $.trim($("#srcVendorNm").val());
	var srcOrderStartDate = $("#srcOrderStartDate").val();
	var srcOrderEndDate   = $("#srcOrderEndDate").val();
	var srcDateType       = $("#srcDateType").val();
	
	$.blockUI();
	
	$.post(
		"/buyOrder/prodReceiveList.sys",
		{
			srcOrdeIdenNumb   : srcOrdeIdenNumb,
			srcVendorNm       : srcVendorNm,
			srcOrderStartDate : srcOrderStartDate,
			srcOrderEndDate   : srcOrderEndDate,
			page              : page,
			rows              : 8,
			srcDateType       : srcDateType
		},
		function(arg){
			fnClientReceiveListCallback(arg);
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
            }
            else{
                if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
                    $("#"+$("[name=receCbox]")[i].id).attr("checked", false);
                }
            }
        }
    }
}

function fnDeliInfoTrace(seq){
	var deli_invo_iden       = $("#deli_invo_iden_"+seq).val();
	var deliWebAddr          = "";
	var order_deli_type_code = $("#deli_type_clas_code_"+seq).val();
	
    if(order_deli_type_code != 'DIR' && (order_deli_type_code != 'ETC' && order_deli_type_code != 'BUS' && order_deli_type_code != 'TRAIN')){					
        var paramString = "";
        var chkCnt = 0;
        $.post( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/delivery/getDeliVendor.sys',
            {
            	deli_type_clas:order_deli_type_code
            },
            function(arg){
                var codeList= eval('(' + arg + ')').codeList;
                
                for(var i=0;i<codeList.length;i++) {
                    if(codeList[i].codeVal1 == order_deli_type_code){
                        deliWebAddr = codeList[i].codeVal2;
                        
                        if(order_deli_type_code == "DAESIN"){
                            paramString += "?billno1="+deli_invo_iden.substring(0, 4)+"&billno2="+deli_invo_iden.substring(4, 7)+"&billno3="+deli_invo_iden.substring(7, 13);
                        }
                        else if(order_deli_type_code == "HANIPS"){
                            paramString += "&hawb_no="+deli_invo_iden;
                        }
                        else if(order_deli_type_code == "DHL"){
                            paramString += "&slipno="+deli_invo_iden;
                        }
                        else{
                            paramString = deli_invo_iden;
                        }
                        
                        deliWebAddr += paramString;
                        
                        window.open(deliWebAddr,'배송조회', 'width='+screen.width+', height='+screen.height+',left=0,top=0,resizable=yes,menubar=no,status=no,scrollbars=yes');
                        
                        chkCnt++;
                    }
                }   
                
                if(chkCnt == 0){
                    alert("일치하는 택배사가 없습니다.");
                }
            }
        );
    }
    else{
        var orde_iden_numb = $("#orde_iden_numb_"+seq).val();
        var purc_iden_numb = $("#purc_iden_numb_"+seq).val();
        var deli_iden_numb = $("#deli_iden_numb_"+seq).val();
        var paramString    = "?orde_iden_numb="+orde_iden_numb+"&purc_iden_numb="+purc_iden_numb+"&deli_iden_numb="+deli_iden_numb+"";
        var windowLeft     = (screen.width-900)/2;
        var windowTop      = (screen.height-700)/2;
        
        window.open('<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/clientReceiveDeliInfoPop.sys'+paramString,'배송조회', 'width=500, height=250,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=yes');
    }
}

function openReceiptPrint(i){
	var receiptNum = $("#receipt_num_"+i).val();
	
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "receivePrint"; // reb 파일이름
	oReport.param("receipt_num").value = receiptNum; // 매개변수 세팅
	
	oReport.title = "인수증"; // 제목 세팅
	oReport.open();
}

var orde_iden_numb_array;
var purc_iden_numb_array;
var deli_iden_numb_array;
var deli_prod_quan_array;

function fnReceiptProcOne(i){
	var isAddMst = $("#is_add_mst_" + i).val();
	
    orde_iden_numb_array = new Array(); 
    purc_iden_numb_array = new Array();
    deli_iden_numb_array = new Array();
    deli_prod_quan_array = new Array();
    
    isAddMst = $.trim(isAddMst);
    
    $("#receCbox_" + i).attr("checked", "checked");  
    
    orde_iden_numb_array[0] = $("#orde_iden_numb_" + i).val();
    purc_iden_numb_array[0] = $("#purc_iden_numb_" + i).val();
    deli_iden_numb_array[0] = $("#deli_iden_numb_" + i).val();
    deli_prod_quan_array[0] = $("#deli_prod_quan_" + i).val();
    
    if(isAddMst == "Y"){
        orde_iden_numb_array[1] = $("#orde_iden_numb_" + (Number(i) + 1)).val();
        purc_iden_numb_array[1] = $("#purc_iden_numb_" + (Number(i) + 1)).val();
        deli_iden_numb_array[1] = $("#deli_iden_numb_" + (Number(i) + 1)).val();
        deli_prod_quan_array[1] = $("#deli_prod_quan_" + (Number(i) + 1)).val();
    }
    confirmMessage("해당 주문 정보를 인수확인하시겠습니까?", fnReceiptProcProcess);
}

function fnReceiptProc(){
	var arrRowIdx = 0 ;
	var i         = 0;
	
    orde_iden_numb_array = new Array(); 
    purc_iden_numb_array = new Array();
    deli_iden_numb_array = new Array();
    deli_prod_quan_array = new Array();
    
    var receTargetList = new Array();
    $("input[name=receCbox]:checked").each(function() {
    	receTargetList[receTargetList.length] =  $(this).val();
    });
	if(receTargetList.length > 0) {
		for(i = 0; i < receTargetList.length; i++) {
			var receCboxIndex = receTargetList[i];
            orde_iden_numb_array[arrRowIdx] = $("#orde_iden_numb_"+receCboxIndex).val();
            purc_iden_numb_array[arrRowIdx] = $("#purc_iden_numb_"+receCboxIndex).val();
            deli_iden_numb_array[arrRowIdx] = $("#deli_iden_numb_"+receCboxIndex).val();
            deli_prod_quan_array[arrRowIdx] = $("#deli_prod_quan_"+receCboxIndex).val();
            
            arrRowIdx++;
            
            if($.trim($("#is_add_mst_"+receCboxIndex).val()) == "Y"){
                orde_iden_numb_array[arrRowIdx] = $("#orde_iden_numb_"+(Number(receCboxIndex)+1)).val();
                purc_iden_numb_array[arrRowIdx] = $("#purc_iden_numb_"+(Number(receCboxIndex)+1)).val();
                deli_iden_numb_array[arrRowIdx] = $("#deli_iden_numb_"+(Number(receCboxIndex)+1)).val();
                deli_prod_quan_array[arrRowIdx] = $("#deli_prod_quan_"+(Number(receCboxIndex)+1)).val();
                
                arrRowIdx++;
            }
		}
		if (arrRowIdx == 0 ) {
			alert("인수처리 할 주문 정보를 선택 해 주십시오.");

			return; 
		}
		
		confirmMessage("선택된 주문 정보를 인수확인하시겠습니까?", fnReceiptProcProcess);
	}
	else{
        alert("인수처리 할 주문 정보가 없습니다.");
	}
}

function fnReceiptProcProcess(){
	$.blockUI();
	
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
        {
        	orde_iden_numb_array : orde_iden_numb_array,
        	purc_iden_numb_array : purc_iden_numb_array,
        	deli_iden_numb_array : deli_iden_numb_array,
        	orde_stat_flag       : '60'
        },
        function(arg2){
        	fnReceiptProcProcessCallback(arg2);
        }
    );
}

function fnReceiptProcProcessCallback(arg2){
	try{
        if($.parseJSON(arg2).customResponse.success){
        	$.post(
                "<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/orderReceiveProcess.sys",
                {
                	orde_iden_numb_array : orde_iden_numb_array,
                	purc_iden_numb_array : purc_iden_numb_array,
                	deli_iden_numb_array : deli_iden_numb_array,
                	deli_prod_quan_array : deli_prod_quan_array
                },
                function(arg){ 
                    if($.parseJSON(arg).customResponse.success){
                       	alert("인수처리가 정상적으로 처리되었습니다.");
                        fnClientReceiveList();
                    }
                    else{
                        alert("인수 처리가 실패하였습니다.");
                    }
                    
                    $.unblockUI();
                }
            );
        }
        else {
        	alert("인수 처리가 실패하였습니다.");
            $.unblockUI();
            fnClientReceiveList();
        }
	}
	catch(e){
		alert("인수처리 중 오류가 발생하였습니다.");
        $.unblockUI();
	}
}
</script>
</html>