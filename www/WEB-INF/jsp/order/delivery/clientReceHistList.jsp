<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.order.dto.OrderDeliDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	@SuppressWarnings("unchecked")	
	String srcOrderStartDate = CommonUtils.nvl((String)request.getAttribute("srcOrderStartDate"), CommonUtils.getCustomDay("MONTH", -1)) ;
	String srcOrderEndDate = CommonUtils.nvl((String)request.getAttribute("srcOrderEndDate"), CommonUtils.getCurrentDate()) ;
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
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

        <!--컨텐츠(S)-->
        <div id="AllContainer">                    
          <ul class="Tabarea">
          <li class="on">인수 이력 조회</li>
          </ul>
		  <div style="position:absolute; right:0; margin-top:-30px;" ><a href="#"><img id="btnSearch" src="/img/contents/btn_tablesearch.gif" /></a></div> 
		  
		  
          <table class="InputTable">
            <colgroup>
              <col width="120px" />
              <col width="auto" />
              <col width="120px" />
              <col width="auto" />
            </colgroup>
            <tr>
              <th>주문번호</th>
              <td><input type="text" style="width:200px;" id="srcOrdeIdenNumb"/></td>
              <th>공급사</th>
              <td><input type="text" style="width:200px;" id="srcVendorNm"/></td>
            </tr>
            <tr>
              <th>
              	<select id="srcType">
              		<option value="regi" selected="selected">주문일</option>
              		<option value="purc">인수일</option>
              	</select>
              	
              </th>
              <td colspan="3">
                <input type="text" id="srcOrderStartDate" style="width:80px;" value="<%=srcOrderStartDate%>"/>
                ~
                <input type="text" id="srcOrderEndDate" style="width:80px;" value="<%=srcOrderEndDate%>"/>
              </td>
            </tr>
          </table>
          <div class="ListTable mgt_20">
            <table  id="orderReciptTable">
              <colgroup>
                <col width="100px" />
                <col width="180px" />
                <col width="auto" />
                <col width="120px" />
                <col width="100px" />
                <col width="100px" />
                <col width="100px" />
              </colgroup>
              <tr>
                <th class="br_l0">주문일(인수일)</th>
                <th>주문번호(공사명)</th>
                <th>주문 상품 정보</th>
                <th>수량정보</th>
                <th>인수금액</th>
                <th>단가</th>
                <th>비고</th>
              </tr>
            </table>
          </div>
          <div class="divPageNum" id="pager"></div>
        </div>
        <!--컨텐츠(E)-->
        
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
    $("#divGnb").mouseover(function () { $("#snb").show(); });
    $("#divGnb").mouseout(function () { $("#snb").hide(); });
    $("#snb").mouseover(function () { $("#snb").show(); });
    $("#snb").mouseout(function () { $("#snb").hide(); });
    
    
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
	
	
    $("#btnSearch").click(function(){
        fnClientReceHistList();
    });
    
   $("#srcOrdeIdenNumb").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcVendorNm").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcOrderStartDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcOrderEndDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   
	fnClientReceHistList();
 });
 
function fnClientReceHistListClean(){
	var length = $(".orderRecipt").length;
    
    if(length > 0){
        for(var i=0; i<length; i++){
            $("#orderRecipt_"+i).remove();
        }
    }
    
    $("#pager").empty();
}

function fnClientReceHistListCallbackList(list, records){
	var str        = "";
	var i          = 0;
	var listLength = 0;
	var listInfo   = null;
	
	if(records > 0){
		listLength = list.length;
		
		for(i = 0; i < list.length; i++){
			listInfo         = list[i];
			var ordeIdenNumb     = listInfo.ORDE_IDEN_NUMB;
			var purcIdenNumb     = listInfo.PURC_IDEN_NUMB;
			var deliIdenNumb     = listInfo.DELI_IDEN_NUMB;
			var receIdenNumb     = listInfo.RECE_IDEN_NUMB;
			var receiptNum       = listInfo.RECEIPT_NUM;
			var goodSpec         = listInfo.GOOD_SPEC;
			var deliTypeClasCode = listInfo.DELI_TYPE_CLAS_CODE;
			var deliInvoIden     = listInfo.DELI_INVO_IDEN;
			var regiDateTime     = listInfo.REGI_DATE_TIME;
			var purcProcDate     = listInfo.PURC_PROC_DATE;
			var consIdenName     = listInfo.CONS_IDEN_NAME;
			var goodName         = listInfo.GOOD_NAME;
			var goodSpec         = listInfo.GOOD_SPEC;
			var vendorNm         = listInfo.VENDORNM;
			var ordeRequQuan     = fnComma( listInfo.ORDE_REQU_QUAN);
			var deliProdQuan     = fnComma( listInfo.DELI_PROD_QUAN);
			var saleProdPris     = listInfo.SALE_PROD_PRIS;
			var saleProdAmou     = listInfo.SALE_PROD_AMOU;
			var deliStatFlag     = listInfo.DELI_STAT_FLAG;
			var goodIdenNumb     = listInfo.GOOD_IDEN_NUMB;
			var vendorId         = listInfo.VENDORID;
			var saleProdPris     = fnComma(saleProdPris);
			var saleProdAmou     = fnComma(saleProdAmou);
			
            str += "<tr class='orderRecipt' id='orderRecipt_" + i + "'>";
            str += 	"<td align=\"center\" class=\"br_l0\">";
            str += 		"<input type='hidden' id='orde_iden_numb_" + i + "'      name='orde_iden_numb_" + i + "'      value='" + ordeIdenNumb + "'/>";
            str +=		"<input type='hidden' id='purc_iden_numb_" + i + "'      name='purc_iden_numb_" + i + "'      value='" + purcIdenNumb + "'/>";
            str +=		"<input type='hidden' id='deli_iden_numb_" + i + "'      name='deli_iden_numb_" + i + "'      value='" + deliIdenNumb + "'/>";
            str +=		"<input type='hidden' id='rece_iden_numb_" + i + "'      name='rece_iden_numb_" + i + "'      value='" + receIdenNumb + "'/>";
            str +=		"<input type='hidden' id='receipt_num_" + i + "'         name='receipt_num_" + i + "'         value='" + receiptNum + "'/>";
            str +=		"<input type='hidden' id='good_spec_" + i + "'           name='good_spec_" + i + "'           value='" + goodSpec + "'/>";
            str +=		"<input type='hidden' id='deli_type_clas_code_" + i + "' name='deli_type_clas_code_" + i + "' value='" + deliTypeClasCode + "'/>";
            str +=		"<input type='hidden' id='deli_invo_iden_" + i + "'      name='deli_invo_iden_" + i + "'      value='" + deliInvoIden + "'/>";
            str +=		"<p>" + regiDateTime + "</p>";
            str +=		"<p>(" + purcProcDate + ")</p>";
            str +=	"</td>";
            str +=	"<td>";
            str +=		"<p>";
            str +=			"<a href='javascript:fnOrderDetailView(\"" + ordeIdenNumb + "\",\"<%=_menuId%>\",\"" + purcIdenNumb + "\");'>" + ordeIdenNumb + "</a>";
            str +=		"</p>";
            str +=		"<p class=\"f11\">(" + consIdenName + ")</p>";
            str +=	"</td>";
            str +=	"<td>";
            str +=		"<p>";
            str +=			"<a href='javascript:fnProductDetailPop(\"" + goodIdenNumb + "\",\"" + vendorId + "\");"+"'>" + goodName + "</a>";
            str +=		"</p>";
            str +=		"<div class=\"f11\">";
            str +=			"<p><strong>규격</strong> : " + goodSpec + " </p>";
            str +=			"<p><strong>공급사</strong> : " + vendorNm + "</p>";
            str +=		"</div>";
            str +=	"</td>";
            str +=	"<td>";
            str +=		"<p><strong>주문수량</strong> : " + ordeRequQuan + "개</p>                                          ";
            str +=		"<p><strong>납품수량</strong> : " + deliProdQuan + "개</p>";
            str +=	"</td>";
            str +=	"<td align=\"right\">";
            str +=		"<p>" + saleProdAmou + "원</p>";
            str +=	"</td>";
            str +=	"<td align=\"right\">" + saleProdPris + "원</td>                                                ";
            str +=	"<td align=\"center\">                                                   ";

            if(deliStatFlag != "80"){
            	str +=	"<p style='padding-top:5px;'>";
            	str +=		"<button id='btnDeliInfoTrace' class='btn btn-darkgray btn-xs' style='width:80px;' onclick=\"javascript:fnDeliInfoTrace('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 배송추적</button>";
            	str +=	"</p>";
            	str +=	"<p style='padding-top:5px;'>";
            	str +=		"<button id='btnReceiptPrint' class='btn btn-default btn-xs' style='width:80px;' onclick=\"javascript:openReceiptPrint('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 인수증출력</button>";
            	str +=	"</p>";
            }

            str +=	"</td>";
            str +="</tr>";
		}
	}
	else{
		str +="<tr class='orderRecipt' id='orderRecipt_0'>";
        str +=	"<td class='br_l0' colspan='6' align='center' >조회된 결과가 없습니다.</td>";
        str +="</tr>";
	}
	
	$("#orderReciptTable").append(str);
}

function fnClientReceHistListCallbackPage(currPage, total, records){
	var pageGrp   = null;
	var startPage = 0;
	var endPage   = 0;
	
	if(records > 0){
		pageGrp   = fnPagerInfo(currPage, total, 5);
		startPage = pageGrp.startPage;
		endPage   = pageGrp.endPage;
		
		fnPager(startPage, endPage, currPage, total, "fnClientReceHistList");
	}
}

function fnClientReceHistListCallback(arg){
	var list      = arg.list;
	var currPage  = arg.page;
	var rows      = arg.rows;
	var total     = arg.total;
	var records   = arg.records;
	
	fnClientReceHistListCallbackList(list, records); // 리스트 생성
	fnClientReceHistListCallbackPage(currPage, total, records); // 페이지 생성 
	
	$.unblockUI();
}
 
function fnClientReceHistList(page){
	var srcOrdeIdenNumb = $("#srcOrdeIdenNumb").val();
	var srcVendorNm     = $("#srcVendorNm").val();
	
	$.blockUI();
	
	srcOrdeIdenNumb = $.trim(srcOrdeIdenNumb);
	srcVendorNm     = $.trim(srcVendorNm);
	
	fnClientReceHistListClean(); // 리스트 초기화
	
	$.post(
		"/buyOrder/getClientReceHistList.sys",
		{
			srcOrdeIdenNumb   : srcOrdeIdenNumb,
			srcVendorNm       : srcVendorNm,
			srcOrderStartDate : $("#srcOrderStartDate").val(),
			srcOrderEndDate   : $("#srcOrderEndDate").val(),
			page              : page,
			rows              : 8,
			srcType           : $("#srcType").val()
		},
		function(arg){
			fnClientReceHistListCallback(arg); // 콜벡
		},
		"json"
	);
}  
function fnDeliInfoTrace(seq){
	var deli_invo_iden = $("#deli_invo_iden_"+seq).val();
	var deliWebAddr = "";
	var order_deli_type_code = $("#deli_type_clas_code_"+seq).val();
    if(order_deli_type_code != 'DIR' && (order_deli_type_code != 'ETC' && order_deli_type_code != 'BUS' && order_deli_type_code != 'TRAIN')){					
        var paramString = "";
        var chkCnt = 0;
        $.post( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/order/delivery/getDeliVendor.sys',
            {deli_type_clas:order_deli_type_code},
            function(arg){
                var codeList= eval('(' + arg + ')').codeList;
                for(var i=0;i<codeList.length;i++) {
                    if(codeList[i].codeVal1 == order_deli_type_code){
                        deliWebAddr = codeList[i].codeVal2;
                        if(order_deli_type_code == "DAESIN"){
                            paramString += "?billno1="+deli_invo_iden.substring(0, 4)+"&billno2="+deli_invo_iden.substring(4, 7)+"&billno3="+deli_invo_iden.substring(7, 13);
                        }else if(order_deli_type_code == "HANIPS"){
                            paramString += "&hawb_no="+deli_invo_iden;
                        }else if(order_deli_type_code == "DHL"){
                            paramString += "&slipno="+deli_invo_iden;
                        }else{
                            paramString = deli_invo_iden;
                        }
                        deliWebAddr += paramString;
                        var scrSizeHeight = 0;
                        scrSizeHeight = screen.height;
                        var windowLeft = (screen.width-900)/2;
                        var windowTop = (screen.height-700)/2;
                        window.open(deliWebAddr,'택배사조회', 'width=900, height=700,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=yes');
                        chkCnt++;
                    }
                }   
                if(chkCnt == 0){
                    alert("일치하는 택배사가 없습니다.");
                }
            }
        );
    }else{
        var orde_iden_numb = $("#orde_iden_numb_"+seq).val();
        var purc_iden_numb = $("#purc_iden_numb_"+seq).val();
        var deli_iden_numb = $("#deli_iden_numb_"+seq).val();
        var paramString = "?orde_iden_numb="+orde_iden_numb+"&purc_iden_numb="+purc_iden_numb+"&deli_iden_numb="+deli_iden_numb+"";
        var scrSizeHeight = 0;
        scrSizeHeight = screen.height;
        var windowLeft = (screen.width-900)/2;
        var windowTop = (screen.height-700)/2;
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
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}
</script>
</html>