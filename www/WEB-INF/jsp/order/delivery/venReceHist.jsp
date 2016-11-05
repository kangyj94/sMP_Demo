<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	String srcReceStartDate = CommonUtils.nvl((String)request.getAttribute("srcReceStartDate"), CommonUtils.getCustomDay("MONTH", -1)) ;
	String srcReceEndDate = CommonUtils.nvl((String)request.getAttribute("srcReceEndDate"), CommonUtils.getCurrentDate()) ;
	
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
          <li class="on">인수 이력</li>
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
              <td>
              	<input type="text" style="width:200px;" id="srcBranchNm"/>
              </td>
              <th>주문번호</th>
              <td>
              	<input type="text" style="width:200px;" id="srcOrdeIdenNumb"/>
              </td>
            </tr>
            <tr>
              <th>인수일</th>
              <td colspan="3">
                    <input type="text" id="srcReceStartDate" style="width:80px;" value="<%=srcReceStartDate%>"/>
                    ~
                    <input type="text" id="srcReceEndDate" style="width:80px;" value="<%=srcReceEndDate%>"/>
              </td>
            </tr>
          </table>
          
          
          <div class="ListTable mgt_20">
            <table id="venOrdTable">
              <colgroup>
                <col width="100px" />
                <col width="200px" />
                <col width="auto" />
                <col width="120px" />
                <col width="120px" />
                <col width="100px" />
              </colgroup>
              <tr>
                <th class="br_l0">인수일</th>
                <th>주문정보</th>
                <th> 상품 정보</th>
                <th>수량정보</th>
                <th>인수금액</th>
                <th>보기</th>
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
	
	$("#srcReceStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcReceEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); 
	
    $("#btnSearch").click(function(){
        venDeliProcList();
    });
	
   $("#srcBranchNm").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcOrdeIdenNumb").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcReceStartDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcReceEndDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   
    venDeliProcList();
 });
 
 
function venDeliProcList(page){
	$.blockUI();
	var srcBranchNm		= $("#srcBranchNm").val() ;
	var srcOrdeIdenNumb		= $("#srcOrdeIdenNumb").val() ;
	var srcReceStartDate		= $("#srcReceStartDate").val() ;
	var srcReceEndDate		= $("#srcReceEndDate").val() ;
	
	var page		= page;
	var rows		= 10;
	$.post(
		"/venOrder/venReceHistList.sys",
		{
			srcOrdeIdenNumb:srcOrdeIdenNumb,
			srcReceStartDate:srcReceStartDate,
			srcReceEndDate:srcReceEndDate,
			srcBranchNm:srcBranchNm,
			page:page,
			rows:rows
		},
		function(arg){
            var length = $(".trData").length;
            if(length > 0){
                for(var i=0; i<length; i++){
                    $("#trData_"+i).remove();
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
                    str += " <tr class='trData' id='trData_"+i+"'>                                                          ";
                    str += "     <td align=\"center\" class=\"br_l0\">                                                         ";
                    str += "   	<input type='hidden' id='receipt_num_"+i+"' name='receipt_num_"+i+"' value='"+list[i].RECEIPT_NUM+"'/>  ";
                    str += "   	<input type='hidden' id='deli_invo_iden_"+i+"' name='deli_invo_iden_"+i+"' value='"+list[i].DELI_INVO_IDEN+"'/>  ";
                    str += "   	<input type='hidden' id='deli_type_clas_"+i+"' name='deli_type_clas_"+i+"' value='"+list[i].DELI_TYPE_CLAS+"'/>  ";
                    str += "   	<input type='hidden' id='orde_iden_numb_"+i+"' name='orde_iden_numb_"+i+"' value='"+list[i].ORDE_IDEN_NUMB+"'/> ";
                    str += "   	<input type='hidden' id='purc_iden_numb_"+i+"' name='purc_iden_numb_"+i+"' value='"+list[i].PURC_IDEN_NUMB+"'/>  ";
                    str += "   	<input type='hidden' id='deli_iden_numb_"+i+"' name='deli_iden_numb_"+i+"'  value='"+list[i].DELI_IDEN_NUMB+"'/>    ";
                    str += "     	<p>"+list[i].RECE_REGI_DATE+"</p>                                                                      ";
                    str += "     </td>                                                                                     ";
                    str += "     <td>                                                                                      ";
                    str += "     	<p>";
                    str += 				"<a href=\"javascript:fnOrderDetailView('" + list[i].ORDE_IDEN_NUMB + "', '', '');\">";
                    str +=					list[i].ORDE_IDEN_NUMB;
                    str +=				"</a>";
                    str +=			"</p>";
                    str += "         <p class=\"f11\">주문명 : "+list[i].CONS_IDEN_NAME+"</p>                              ";
                    str += "         <p class=\"f11\">구매사 : "+list[i].BRANCHNM+"</p>                              ";
                    str += "     </td>                                                                                     ";
                    str += "     <td>                                                                                      ";
                    str += "     	<p><a href='javascript:fnPdtSimpleDetailPop(\""+list[i].GOOD_IDEN_NUMB+"\");"+"'>"+list[i].GOOD_NAME+"</a></p>                                             ";
                    str += "         <div class=\"f11\">                                                                     ";
                    str += "             <p><strong>규격</strong> : "+list[i].GOOD_SPEC+" </p>                                  ";
                    str += "         </div>                                                                                ";
                    str += "     </td>                                                                                     ";
                    str += "     <td>                                                                                      ";
                    str += "     	  <p><strong>주문수량</strong> : "+list[i].ORDE_REQU_QUAN+"개</p>                                                    ";
                    str += "         <p><strong>납품수량</strong> : "+list[i].DELI_PROD_QUAN+"개</p>                                                   ";
                    str += "         <p><strong>인수수량</strong> : "+list[i].SALE_PROD_QUAN+"개</p>                                                   ";
                    str += "     </td>                                                                                     ";
                    str += "     <td align=\"right\">                                                                        ";
                    str += "     	<p>"+fnComma(list[i].PURC_PROD_AMOU)+"원</p>                                                                      ";
                    str += "     </td>                                                                                     ";
                    str += "     <td align=\"center\">                                                                       ";
                    if(list[i].RECEIPT_NUM.length > 0){
                    	
                    str += "       <p style=\"padding-top:1px;padding-bottom:1px;\"><button id='btnDeliInfoTrace' class='btn btn-darkgray btn-xs' style='width:80px;' onclick=\"javascript:fnDeliInfoTrace('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 배송추적</button></p>   ";
                    str += "       <p style=\"padding-top:1px;padding-bottom:1px;\"><button id='btnReceiptPrint' class='btn btn-default btn-xs' style='width:80px;' onclick=\"javascript:openReceiptPrint('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>> 인수증출력</button></p>     ";
                    
                    }
                    str += "     </td>                                                                                     ";
                    str += " </tr>                                                                                         ";
					$("#venOrdTable").append(str);
				}
				fnPager(startPage, endPage, currPage, total, 'venDeliProcList');	//페이져 호출 함수
			}else{
                str += " <tr class='trData' id='trData_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='8' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                          ";
                str += " </tr>                                                                                                                                                         ";
                $("#venOrdTable").append(str);
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
	var order_deli_type_code = $("#deli_type_clas_"+seq).val();
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
        window.open('<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/clientReceiveDeliInfoPop.sys'+paramString,'배송조회', 'width=500, height=250,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=yes');
    }
}
</script>
<%-- 인수증 출력 관련 스크립트 시작 --%>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script language="JavaScript">
function openReceiptPrint(i){
	var receiptNum = $("#receipt_num_"+i).val();
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "receivePrint"; // reb 파일이름
	oReport.param("receipt_num").value = receiptNum; // 매개변수 세팅
	oReport.title = "인수증"; // 제목 세팅
	oReport.open();
}
</script>
<%-- 인수증 출력 관련 스크립트 끝 --%>
</html>