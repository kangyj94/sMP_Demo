<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.order.dto.OrderDeliDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%	
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<ActivitiesDto> roleList          = (List<ActivitiesDto>)request.getAttribute("useActivityList");	
	String              _menuId           = CommonUtils.getRequestMenuId(request);
	String              srcOrderStartDate = CommonUtils.nvl((String)request.getAttribute("srcOrderStartDate"), CommonUtils.getCustomDay("MONTH", -1)) ;
	String              srcOrderEndDate   = CommonUtils.nvl((String)request.getAttribute("srcOrderEndDate"),   CommonUtils.getCurrentDate()) ;
	String              srcReturnStatFlag = request.getParameter("srcReturnStatFlag");
	
	//Quick 메뉴 경로로 들어온 경우 조회 기간 3개월로
	String				linkOper			= request.getParameter("linkOper");
	if( linkOper != null && linkOper.equals("quick")){
		srcOrderStartDate		= CommonUtils.getCustomDay("MONTH", -2);
		srcReturnStatFlag		= "retuReq";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
    <style type="text/css">
    .popOrderReturn {
        display: none;
        position: fixed;
        top: 17%;
        left: 50%;
        margin-left: -300px;
        width: 530px;
        background-color: #ffffff;
        color: #333;
    }
    </style>
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
					<li class="on">반품신청/현황</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
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
							<select id="srcOrderDateType">
								<option value="orde" selected="selected">주문일</option>
								<option value="deli">인수일</option>
							</select>
						</th>
						<td>
							<input type="text" id="srcOrderStartDate" style="width:80px;" value="<%=srcOrderStartDate%>"/>
							~
							<input type="text" id="srcOrderEndDate" style="width:80px;" value="<%=srcOrderEndDate%>"/>
						</td>
						<th>상태</th>
						<td>
							<select name="select" id="srcReturnStatFlag" style="width:120px">
								<option value="rece" selected="selected">인수</option>
								<option value="retuReq">반품요청</option>
								<option value="retuApp">반품승인</option>
								<option value="retuRej">반품반려</option>
							</select>
						</td>
					</tr>
				</table>
				<div class="ListTable mgt_20">
					<table id="orderReciptTable">
						<colgroup>
							<col width="100px" />
							<col width="180px" />
							<col width="auto" />
							<col width="120px" />
							<col width="100px" />
							<col width="100px" />
						</colgroup>
						<tr>
							<th class="br_l0">주문일(인수일)</th>
							<th>주문번호 (주문명)</th>
							<th>주문 상품 정보</th>
							<th>수량정보</th>
							<th>처리상태</th>
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
<div id="ordReturnReqtPop" class="jqmPop" style="font_size: 12px; display: none;">
	<div>
        <div id="divPopup" style="width:500px; height: 330px; z-index: 9999;">
            <h1>반품요청<a href="#" onclick="fnPopClose();"><img src="/img/contents/btn_close.png"></a></h1>
			<div class="popcont">
				<table class="InputTable">
					<colgroup>
						<col width="100px" />
						<col width="auto" />
					</colgroup>
					<tr>
						<th>상품정보</th>
						<td>
							<span id="productHtmlArea"></span>
						</td>
					</tr>
					<tr>
						<th>반품요청 수량</th>
						<td>
							<input type="hidden" id="returnRequValue" value="" size="10"/>
							<input type="text" id="returnRequQuan" style="text-align:right;" value="0" size="10"/>개
						</td>
					</tr>
					<tr>
						<th>사유</th>
						<td>
							<textarea id="chanReasDesc" cols="" rows="" style="width:98%; height: 100px;"></textarea>
						</td>
					</tr>
				</table>
                <div class="Ac mgt_10">
					<button id='popOrdPurcBtn' class='btn btn-darkgray btn-xs' onClick="javascript:returnRequestProcess();" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>>반품요청</button>
					<button id='pop' class='btn btn-default btn-xs' onClick="javascript:fnPopClose();">닫기</button>
                </div>
            </div>
        </div>
	</div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script>
$(document).ready(function() {
	$("#ordReturnReqtPop").jqm();
	
	$("#srcReturnStatFlag").val("<%=srcReturnStatFlag%>");
	
	fnInitEvent();
	fnInitDatepicker();
	fnClientReturnOrderList();
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
        fnClientReturnOrderList();
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
	
	$("#srcReturnStatFlag").change(function(e){
		$("#btnSearch").click();
	});
}
 
function fnClientReturnOrderListClean(){
	var length = $(".orderRecipt").length;
	
    if(length > 0){
        for(var i=0; i<length; i++){
            $("#orderRecipt_"+i).remove();
        }
    }
    
    $("#pager").empty();
}

function fnClientReturnOrderListCallbackList(list, records){
	var mstCnt     = 0;
	var i          = 0;
	var listLength = 0;
	var listInfo   = null;
	var rowSpanStr = null;
	var str        = "";
	
	if(records > 0){
		listLength = list.length;
		
		for(i = 0; i < listLength; i++){
			listInfo = list[i];
			var searchKind       = listInfo.SEARCH_KIND;
			var isAddMst         = listInfo.IS_ADD_MST;
			var purcProcDate     = listInfo.PURC_PROC_DATE;
			var ordeIdenNumb     = listInfo.ORDE_IDEN_NUMB;
			var purcIdenNumb     = listInfo.PURC_IDEN_NUMB;
			var consIdenName     = listInfo.CONS_IDEN_NAME;
			var deliIdenNumb     = listInfo.DELI_IDEN_NUMB;
			var receIdenNumb     = listInfo.RECE_IDEN_NUMB;
			var returnEnableQuan = listInfo.RETURN_ENABLE_QUAN;
			var retuIdenNum      = listInfo.RETU_IDEN_NUM;
			var goodName         = listInfo.GOOD_NAME;
			var goodSpec         = listInfo.GOOD_SPEC;
			var goodIdenNumb     = listInfo.GOOD_IDEN_NUMB;
			var vendorId         = listInfo.VENDORID;
			var vendorNm         = listInfo.VENDORNM;
			var ordeRequQuan     = listInfo.ORDE_REQU_QUAN;
			var deliProdQuan     = listInfo.DELI_PROD_QUAN;
			var retuStatFlag     = listInfo.RETU_STAT_FLAG;
			var retuProdQuan     = listInfo.RETU_PROD_QUAN;
			var retuStatFlagNm   = listInfo.RETU_STAT_FLAG_NM;
			var regiDateTime     = listInfo.REGI_DATE_TIME;
			
			if(searchKind != "1"){
				isAddMst = "";
			}
			
			if(isAddMst == "Y"){
				rowSpanStr = " rowspan='2' ";
			}
			else{
				rowSpanStr = "";
			}
			
            str += "<tr class='orderRecipt' id='orderRecipt_" + i + "'>";
            
            if(mstCnt == 0 ){
            	str += "<td align=\"center\" class=\"br_l0\" " + rowSpanStr + " >";
            	str +=	"<p>" + regiDateTime + "</p>";
            	str +=	"<p>(" + purcProcDate + ")</p>";
            	str += "</td>";
            }
            
            str +=	"<td>";
            str +=		"<p>";
            str +=			"<a href='javascript:fnOrderDetailView(\"" + ordeIdenNumb + "\",\"<%=_menuId%>\",\"" + purcIdenNumb + "\");'>" + ordeIdenNumb + "</a>";
            str +=		"</p>";
            str +=		"<p class=\"f11\">(" + consIdenName + ")</p>";
            str +=		"<input type='hidden' id='orde_iden_numb_" + i + "'     name='orde_iden_numb_" + i + "'     value='" + ordeIdenNumb + "'/>";
            str +=		"<input type='hidden' id='purc_iden_numb_" + i + "'     name='purc_iden_numb_" + i + "'     value='" + purcIdenNumb + "'/>";
            str +=		"<input type='hidden' id='deli_iden_numb_" + i + "'     name='deli_iden_numb_" + i + "'     value='" + deliIdenNumb + "'/>";
            str +=		"<input type='hidden' id='rece_iden_numb_" + i + "'     name='rece_iden_numb_" + i + "'     value='" + receIdenNumb + "'/>";
            str +=		"<input type='hidden' id='return_enable_quan_" + i + "' name='return_enable_quan_" + i + "' value='" + returnEnableQuan + "'/>";
            str +=		"<input type='hidden' id='retu_iden_num_" + i + "'      name='retu_iden_num_" + i + "'      value='" + retuIdenNum + "'/>";
            str +=		"<input type='hidden' id='good_name_" + i + "'          name='good_name_" + i + "'          value='" + goodName + "'/>";
            str +=		"<input type='hidden' id='good_spec_" + i + "'          name='good_spec_" + i + "'          value='" + goodSpec + "'/>";
            str +=		"<input type='hidden' id='is_add_mst_" + i + "'         name='is_add_mst_" + i + "'         value='" + isAddMst + "'/>";
            str +=	"</td>";
            str +=	"<td>";
            str +=		"<p>";
            str +=			"<a href='javascript:fnProductDetailPop(\"" + goodIdenNumb + "\",\"" + vendorId + "\");"+"'>" + goodName + "</a>";
            str +=		"</p>";
            str +=		"<div class=\"f11\">";
            str +=			"<p><strong>규격</strong>&nbsp;&nbsp;&nbsp;&nbsp;: " + goodSpec + "</p>";
            str +=			"<p><strong>공급사</strong> : " + vendorNm + "</p>";
            str +=		"</div>";
            str +=	"</td>";
            str +=	"<td>";
            str +=		"<p><strong>주문수량 : </strong>" + ordeRequQuan + "개</p>";
            str +=		"<p><strong>납품수량 : </strong>" + deliProdQuan + "개</p>";
            
            if(retuStatFlag == "0"){
                str +=		"<p><strong>반품요청수량 : </strong>" + retuProdQuan + "개</p>";
            }
            else if(retuStatFlag == "1"){
            	str +=		"<p><strong>반품승인수량 : </strong>" + retuProdQuan + "개</p>";
            }
            else if(retuStatFlag == "9" ){
            	str +=		"<p><strong>반품반려수량 : </strong>" + retuProdQuan + "개</p>";
            }
            else{
            	str +=		"<p><strong>반품가능수량 : </strong>" + returnEnableQuan + "개</p>";
            }
            
            str +=	"</td>";
            str +=	"<td align=\"center\">";
            str +=		"<p>" + retuStatFlagNm + "</p>";
            str +=	"</td>";
            
            if(mstCnt == 0 ){
            	str +=	"<td align=\"center\" " + rowSpanStr + ">";
            	
				if(retuStatFlag == ""){
                	str += "<p>";
                	str += 	"<button id='btnReceiptPrint' class='btn btn-darkgray btn-xs' onclick=\"javascript:fnRetrunPopupOpen('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>> 반품요청</button>";
                	str += "</p>";
            	}
				else if(retuStatFlag == "1"){
					str += "<p>";
					str += 	"<button id='btnReceiptPrint' class='btn btn-default btn-xs' onclick=\"javascript:openReturnReceiptPrint('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 반품인수인계증</button>";
					str += "</p>";
            	}
				
            	str += "</td>";
            }
            
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

function fnClientReturnOrderListCallbackPage(currPage, total, records){
	var pageGrp   = null;
	var startPage = 0;
	var endPage   = 0;
	
	if(records > 0){
		pageGrp   = fnPagerInfo(currPage, total, 5);
		startPage = pageGrp.startPage;
		endPage   = pageGrp.endPage;
		
		fnPager(startPage, endPage, currPage, total, "fnClientReturnOrderList");
	}
}

function fnClientReturnOrderListCallback(arg){
	var list      = arg.list;
	var currPage  = arg.page;
	var rows      = arg.rows;
	var total     = arg.total;
	var records   = arg.records;
	
	fnClientReturnOrderListCallbackList(list, records); // 리스트 구성
	fnClientReturnOrderListCallbackPage(currPage, total, records); // 페이지 영역 구성
	
	$.unblockUI();
}
 
function fnClientReturnOrderList(page){
	var srcOrdeIdenNumb   = $.trim($("#srcOrdeIdenNumb").val());
	var srcVendorNm       = $.trim($("#srcVendorNm").val());
	var srcOrderStartDate = $("#srcOrderStartDate").val();
	var srcOrderEndDate   = $("#srcOrderEndDate").val();
	var srcReturnStatFlag = $("#srcReturnStatFlag").val();
	var srcOrderDateType  = $("#srcOrderDateType").val();
	
	$.blockUI();
	fnClientReturnOrderListClean(); // 페이지 초기화
	
	$.post(
		"/buyOrder/returnOrderRegistList.sys",
		{
			srcOrdeIdenNumb   : srcOrdeIdenNumb,
			srcVendorNm       : srcVendorNm,
			srcOrderStartDate : srcOrderStartDate,
			srcOrderEndDate   : srcOrderEndDate,
			srcReturnStatFlag : srcReturnStatFlag,
			page              : page,
			rows              : 8,
			srcOrderDateType  : srcOrderDateType
		},
		function(arg){
			fnClientReturnOrderListCallback(arg);
		},
		"json"
	);
}  

function fnRetrunPopupOpen(i){
	$("#chanReasDesc").val("");
	$("#productHtmlArea").html("");
	
	var tmpProdInfo = "<b>"+$("#good_name_"+i).val()+"</b><br/>규격 : "+$("#good_spec_"+i).val();
	
	$("#productHtmlArea").html(tmpProdInfo);
	$("#returnRequValue").val(""+i);
	$("#returnRequQuan").val( $("#return_enable_quan_"+i).val() );
	$("#ordReturnReqtPop").jqmShow();
}

function fnPopClose(){
	$("#ordReturnReqtPop").jqmHide();
}

function returnRequestProcess(){
	var indexStrTmp = $("#returnRequValue").val();
	
	if(Number($.trim($("#return_enable_quan_"+indexStrTmp).val())) < Number($.trim($("#returnRequQuan").val())) ){
		alert("반품가능 수량 "+$.trim($("#return_enable_quan_"+indexStrTmp).val())+" 개를 초과하여 반품신청할 수 없습니다.");
		
		return;
	}
	
	fnPopClose();
	
	confirmMessage("반품요청을 진행하시겠습니까?", returnRequestProcessCallback);
}

function returnRequestProcessCallback(){
	$.blockUI();
	
	var indexStrTmp = $("#returnRequValue").val();
	var reason            = $("#chanReasDesc").val();
	var orde_iden_numb    = $("#orde_iden_numb_"+indexStrTmp).val();
	var purc_iden_numb    = $("#purc_iden_numb_"+indexStrTmp).val(); 
	var deli_iden_numb    = $("#deli_iden_numb_"+indexStrTmp).val();
	var rece_iden_numb    = $("#rece_iden_numb_"+indexStrTmp).val();
	var return_requ_quan  = $("#returnRequQuan").val();
	var returnProdQuanCnt = 0; //반품가능수량 가져오기
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getReturnProdQuanCnt.sys", 
		{ 	orde_iden_numb:orde_iden_numb, 
			purc_iden_numb:purc_iden_numb, 
			deli_iden_numb:deli_iden_numb, 
			rece_iden_numb:rece_iden_numb
		},
		function(arg2){
			returnRequestProcessCallbackCallback(arg2);
		}
	);
}

function returnRequestProcessCallbackCallback(arg2){
	$.unblockUI();
	
	var returnProdQuanCnt = eval('(' + arg2 + ')').returnProdQuan;
	
	var return_requ_quan  = $("#returnRequQuan").val();
	var indexStrTmp = $("#returnRequValue").val();
	var reason            = $("#chanReasDesc").val();
	
	if(Number(returnProdQuanCnt) <= 0) {
		alert("반품이 가능하지 않습니다.");
		
		return;
	}
	
	if(Number(return_requ_quan) > Number(returnProdQuanCnt)) {
		alert("반품가능 수량은 "+returnProdQuanCnt+" 입니다.");
		
		return;
	}
	
    var orde_iden_numb_array = new Array(); 
    var purc_iden_numb_array = new Array(); 
    var deli_iden_numb_array = new Array(); 
    var rece_iden_numb_array = new Array();
    
    orde_iden_numb_array[0] = $("#orde_iden_numb_"+indexStrTmp).val();
    purc_iden_numb_array[0] =$("#purc_iden_numb_"+indexStrTmp).val(); 
    deli_iden_numb_array[0] = $("#deli_iden_numb_"+indexStrTmp).val();
    rece_iden_numb_array[0] = $("#rece_iden_numb_"+indexStrTmp).val();
    
    if($.trim($("#is_add_mst_"+indexStrTmp).val()) == "Y"){
        orde_iden_numb_array[1] = $("#orde_iden_numb_"+(Number(indexStrTmp)+1)).val();
        purc_iden_numb_array[1] = $("#purc_iden_numb_"+(Number(indexStrTmp)+1)).val(); 
        deli_iden_numb_array[1] = $("#deli_iden_numb_"+(Number(indexStrTmp)+1)).val();
        rece_iden_numb_array[1] = $("#rece_iden_numb_"+(Number(indexStrTmp)+1)).val();
    }
	
    $.blockUI();
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH%>/buyOrder/returnOrderProcessTransGrid.sys",
		{  
			orde_iden_numb_array : orde_iden_numb_array,
			purc_iden_numb_array : purc_iden_numb_array,
			deli_iden_numb_array : deli_iden_numb_array,
			rece_iden_numb_array : rece_iden_numb_array,
			return_requ_quan     : return_requ_quan,
			reason               : reason
		},
		function(arg){ 
            if($.parseJSON(arg).customResponse.success){
				alert("정상적으로 처리되었습니다.");
				
                fnClientReturnOrderList();
            }
            else{
            	alert("처리도중 오류가 발생하였습니다.");
            }
            
            $.unblockUI();
		}
	);
}

function openReturnReceiptPrint(i){
	var tmpRtnIdenNum = $("#retu_iden_num_"+i).val();;
	var tmpGoodSpec = $("#good_spec_"+i).val();
// 	alert("tmpRtnIdenNum : "+tmpRtnIdenNum+"\ntmpGoodSpec : "+tmpGoodSpec);
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "returnReceivePrint"; // reb 파일이름
	oReport.param("retu_iden_num").value = tmpRtnIdenNum; // 매개변수 세팅
	oReport.param("prod_spec").value = tmpGoodSpec; // 매개변수 세팅
	oReport.title = "반품인수인계증"; // 제목 세팅
	oReport.open();
}
 </script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
</html>