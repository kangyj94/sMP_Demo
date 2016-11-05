<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.order.dto.OrderDeliDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	@SuppressWarnings("unchecked")	
	String srcOrderStartDate = CommonUtils.nvl((String)request.getAttribute("srcOrderStartDate"), CommonUtils.getCustomDay("DAY", -7)) ;
	String srcOrderEndDate = CommonUtils.nvl((String)request.getAttribute("srcOrderEndDate"), CommonUtils.getCurrentDate()) ;
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
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
</head>

<body class="subBg">
  <div id="divWrap">
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
    <hr>
        <div id="divBody">
            <div id="divSub">
              <jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
        <!--컨텐츠(S)-->
        <div id="AllContainer">                    
          <ul class="Tabarea">
          <li class="on">주문인수대기 현황 조회</li>
          </ul>
		  <div style="position:absolute; right:0; margin-top:-30px;"><a href="#"><img id="btnSearch" src="/img/contents/btn_tablesearch.gif" /></a></div>
          <table class="InputTable">
            <colgroup>
              <col width="120px" />
              <col width="auto" />
              <col width="120px" />
              <col width="auto" />
            </colgroup>
            <tr>
              <th>구매사명</th>
              <td><input type="text" style="width:200px;" id="srcBranchNm"/></td>
              <th>주문번호</th>
              <td><input type="text" style="width:200px;" id="srcOrdeIdenNumb"/></td>
            </tr>
            <tr>
              <th>배송일</th>
              <td colspan="3">
                    <input type="text" id="srcOrderStartDate" style="width:80px;" value="<%=srcOrderStartDate%>"/>
                    ~
                    <input type="text" id="srcOrderEndDate" style="width:80px;" value="<%=srcOrderEndDate%>"/>
              </td>
            </tr>
          </table>
          <div class="ListTable mgt_20">
          
          
          
            <table id="tableListArea">
              <colgroup>
                <col width="100px" />
                <col width="350px" />
                <col width="auto" />
                <col width="120px" />
                <col width="100px" />
              </colgroup>
              <tr>
                <th class="br_l0"><p>주문일</p>
                <p>(배송일)</p></th>
                <th>주문정보</th>
                <th> 주문 상품 정보</th>
                <th>수량정보</th>
                <th>비고</th>
              </tr>
              
              
            </table>
          </div>
          
          <div class="divPageNum" id="pager"></div>
          
          
        </div>
        <!--컨텐츠(E)-->
        
        </div>
          <jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
        </div>
        <hr>
    </div>
</body>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#divGnb").mouseout(function () {
		$("#snb_vdr").hide();
	});
	$("#snb_vdr").mouseover(function () {
		$("#snb_vdr").show();
	});
	$("#snb_vdr").mouseout(function () {
		$("#snb_vdr").hide();
	});
    
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
        venOrdReceStandByList();
    });
    
    
   $("#srcBranchNm").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcOrdeIdenNumb").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcOrderStartDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcOrderEndDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
    
	venOrdReceStandByList();
});

function venOrdReceStandByList(page){
	$.blockUI();
	var page		= page;
	var rows		= 10;
	var srcBranchNm	= $.trim($("#srcBranchNm").val());
	var srcOrdeIdenNumb	= $.trim($("#srcOrdeIdenNumb").val());
	var srcOrderStartDate	= $.trim($("#srcOrderStartDate").val());
	var srcOrderEndDate	= $.trim($("#srcOrderEndDate").val());
	$.post(
		"/venOrder/getVenOrdReceStandByList.sys",
		{
			srcBranchNm:srcBranchNm,
			srcOrdeIdenNumb:srcOrdeIdenNumb,
			srcOrderStartDate:srcOrderStartDate,
			srcOrderEndDate:srcOrderEndDate,
			page:page,
			rows:rows
		},
		function(arg){
            var length = $(".createdTrInfo").length;
            if(length > 0){
                for(var i=0; i<length; i++){
                    $("#createdTrInfo_"+i).remove();
                }
            }
            $("#pager").empty();
			var list		= arg.list;
			var currPage	= arg.page;
			var rows		= arg.rows;
			var total		= arg.total;
			var records		= arg.records;
			var pageGrp		= Math.ceil(currPage/5);
			var startPage	= (pageGrp-1)*5+1;
			var endPage		= (pageGrp-1)*5+5;
			if(Number(endPage) > Number(total)){
				endPage = total;
			}
			if(records > 0){
				for(var i=0; i<list.length; i++){
					var str = "";
                    str += "<tr class='createdTrInfo' id='createdTrInfo_"+i+"'>                                                                                                                                            ";
                    str += "    <td align=\"center\" class=\"br_l0\">";
                    str += "   	<input type='hidden' id='deli_type_clas_code_"+i+"' name='deli_type_clas_code_"+i+"'  value='"+list[i].DELI_TYPE_CLAS+"'/>                 ";
                    str += "   	<input type='hidden' id='deli_invo_iden_"+i+"' name='deli_invo_iden_"+i+"'  value='"+list[i].DELI_INVO_IDEN+"'/>                 ";
                    str += "   	<input type='hidden' id='receipt_num_"+i+"' name='receipt_num_"+i+"'  value='"+list[i].RECEIPT_NUM+"'/>                 ";
                    str += "   	<input type='hidden' id='good_spec_desc_"+i+"' name='good_spec_desc_"+i+"'  value='"+list[i].GOOD_SPEC+"'/>                 ";
                    
                    str += "   	<input type='hidden' id='orde_iden_numb_"+i+"' name='orde_iden_numb_"+i+"'  value='"+list[i].ORDE_IDEN_NUMB+"'/>                 ";
                    str += "   	<input type='hidden' id='purc_iden_numb_"+i+"' name='purc_iden_numb_"+i+"'  value='"+list[i].PURC_IDEN_NUMB+"'/>                 ";
                    str += "   	<input type='hidden' id='deli_iden_numb_"+i+"' name='deli_iden_numb_"+i+"'  value='"+list[i].DELI_IDEN_NUMB+"'/>                 ";
                    str += "        <p>"+list[i].REGI_DATE_TIME+"</p>                    ";
                    str += "        <p>("+list[i].DELI_DEGR_DATE+")</p>                  ";
                    str += "    </td>                                         ";
                    str += "    <td>                                          ";
                    str += "        <p>";
                    str +=				"<a href=\"javascript:fnOrderDetailView('" + list[i].ORDE_IDEN_NUMB + "', '', '');\">";
                    str +=					list[i].ORDE_IDEN_NUMB;
                    str +=				"</a>";
                    str +=			"</p>";
                    str += "        <div class=\"f11\">                                  ";
                    str += "        <p><strong>주문명</strong> : "+list[i].CONS_IDEN_NAME+"</p>";
                    str += "        <p><strong>구매사</strong> : "+list[i].ORDE_CLIENT_NAME+"</p>";
                    str += "        </div>                                                         ";
                    str += "    </td>                                                              ";
                    str += "    <td>                                                               ";
                    str += "    	<p><a href='javascript:fnPdtSimpleDetailPop(\""+list[i].GOOD_IDEN_NUMB+"\");"+"'>"+list[i].GOOD_NAME+"</a></p>";
                    str += "        <div class=\"f11\">                                                   ";
                    str += "        <p><strong>규격</strong> : "+list[i].GOOD_SPEC+"</p>";
                    str += "        </div>                                                     ";
                    str += "    </td>                                                          ";
                    str += "    <td>                                                           ";
                    str += "    	<p><strong>주문수량</strong> : "+list[i].ORDE_REQU_QUAN+"개</p>        ";
                    str += "        <p><strong>납품수량</strong> : "+list[i].DELI_PROD_QUAN+"개</p>      ";
                    str += "    </td>                                                          ";
                    str += "    <td align=\"center\">                                     ";
                    str += "      <p style=\"padding-top:1px;padding-bottom:1px;\"><button id='btnDeliInfoTrace' class='btn btn-darkgray btn-xs' style='width:80px;' onclick=\"javascript:fnDeliInfoTrace('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 배송추적</button></p>   ";
                    str += "      <p style=\"padding-top:1px;padding-bottom:1px;\"><button id='btnReceiptPrint' class='btn btn-default btn-xs'  style='width:80px;'onclick=\"javascript:openReceiptPrint('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 인수증출력</button></p>     ";
                    str += "   </td>                                                        ";
                    str += "</tr>                                                               ";
					$("#tableListArea").append(str);
				}
				fnPager(startPage, endPage, currPage, total, 'venOrdReceStandByList');	//페이져 호출 함수
				
			}else{
                str += " <tr class='createdTrInfo' id='createdTrInfo_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='8' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                          ";
                str += " </tr>                                                                                                                                                         ";
                $("#tableListArea").append(str);
			}
			$.unblockUI();
		},
		"json"
	);
}
function fnComma(n) {
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
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
                        var windowLeft = 0;
                        var windowTop = 0;
                        window.open(deliWebAddr,'배송조회', 'width='+screen.width+', height='+screen.height+',left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=yes');
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
        window.open('<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/clientReceiveDeliInfoPop.sys'+paramString,'배송조회', 'width=500, height=275,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=yes');
    }
}

function openReceiptPrint(i){
	var receiptNum = $("#receipt_num_"+i).val();
	var prodSpec = $("#good_spec_desc_"+i).val();
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "receivePrint"; // reb 파일이름
	oReport.param("receipt_num").value = receiptNum; // 매개변수 세팅
	oReport.param("prodSpec").value 	 	 = prodSpec;
	oReport.param("prodStSpec").value 	 	 = "";
	oReport.title = "인수증"; // 제목 세팅
	oReport.open();
}
</script>
</html>