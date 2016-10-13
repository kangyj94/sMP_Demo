<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.order.dto.OrderDeliDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	@SuppressWarnings("unchecked")	
	String srcOrderStartDate = CommonUtils.nvl((String)request.getAttribute("srcPurcStartDate"), CommonUtils.getCustomDay("MONTH", -2)) ;
	String srcOrderEndDate = CommonUtils.nvl((String)request.getAttribute("srcOrderEndDate"), CommonUtils.getCurrentDate()) ;
	
	@SuppressWarnings("unchecked")  
	List<Object> orderStatusCodeList = (List<Object>)request.getAttribute("orderStatusCodeList");
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String srcIsBill = request.getParameter("srcIsBill");
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
          <li class="on">주문이력 조회</li>
          </ul>
          <div style="position:absolute; right:0; margin-top:-30px;">
          		<a href="#;"><img src="/img/contents/btn_excelDN.gif" id="allExcelButton" name="allExcelButton"/></a>
          		<a href="#;"><img src="/img/contents/btn_tablesearch.gif" id="btnSearch"/></a>
          	</div>
          <table class="InputTable">
            <tr>
              <th>주문번호</th>
              <td><input type="text" style="width:200px;" id="srcOrdeIdenNumb"/></td>
              <th>상품명</th>
              <td><input type="text" style="width:150px;"  id="srcGoodName"/></td>
            </tr>
            <colgroup>
              <col width="120px" />
              <col width="auto" />
              <col width="120px" />
              <col width="auto" />
            </colgroup>
            <tr>
              <th>공사명</th>
              <td><input type="text" style="width:200px;" id="srcConNm"/></td>
              <th>상품코드</th>
              <td><input type="text" style="width:150px;" id="srcGoodIdenNumb"/></td>
            </tr>
            <tr>
              <th>계산서발행여부</th>
              <td>
                  <select name="select" style="width:100px" id="srcIsBill">
                        <option>전체</option>
                        <option value="1">발행</option>
                        <option value="0">미발행</option>
                  </select>
              </td>
              <th>
              	<select  id="srcOrderDateFlag" name="srcOrderDateFlag" style="width:100px">
              		<option value="">주문일</option>
					<option value="3">배송일</option>
					<option value="4">인수일</option>
					<option value="8">계산서 발행일</option>
                </select>
              </th>
              <td>
                    <input type="text" id="srcOrderStartDate" style="width:80px;" value="<%=srcOrderStartDate%>"/>
                    ~
                    <input type="text" id="srcOrderEndDate" style="width:80px;" value="<%=srcOrderEndDate%>"/>
              </td>
            </tr>
            <tr>
              <th>주문상태</th>
              <td>
              		<select name="select2" style="width:100px" id="srcOrdeStat">
                        <option value="">전체</option>
<%
if(orderStatusCodeList != null && orderStatusCodeList.size() > 0){
	for(Object obj : orderStatusCodeList){
		CodesDto cd = (CodesDto) obj;
		try{
			if(Integer.parseInt(cd.getCodeVal1()) < 40){ continue; }
		}catch(Exception e){}
%>
                        <option value="<%=cd.getCodeVal1()%>"><%=cd.getCodeNm1()%></option>
<%
	}
}
%>
					</select>
				</td>
				<th>구매사</th>
				<td>
					<input type="text" id="srcBranchNm" name="srcBranchNm" style="width:200px;" value=""/>
				</td>
            </tr>
          </table>
          
          <div class="ListTable mgt_20">
          
            <table id="orderHistTable">
              <colgroup>
                <col width="180px" />
                <col width="70px" />
                <col width="auto" />
                <col width="60px" />
                <col width="70px" />
                <col width="90px" />
                <col width="90px" />
                <col width="90px" />
                <col width="90px" />
                <col width="50px" />
              </colgroup>
              <tr>
                <th class="br_l0">주문정보</th>
                <th>주문상태</th>
                <th>상품정보</th>
                <th>주문수량<br/>(수량)</th>
                <th>공급가액</th>
                <th>표준납기일<br/>(지연일)</th>
                <th>배송일</th>
                <th>인수일</th>
                <th>계산서발행일</th>
                <th>자동인수여부</th>
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
<%@ include file="/WEB-INF/jsp/product/product/venProductDetailPop.jsp" %>
<script>
$(document).ready(function() {
	$("#allExcelButton").click(function(){ fnAllExcelPrintDown();});
	
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
        venOrderHistList();
    });
    
   $("#srcOrdeIdenNumb").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcConNm").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcGoodName").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcGoodIdenNumb").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcOrderStartDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcOrderEndDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
    $("#srcIsBill").change(function(){ $("#btnSearch").click(); });
    $("#srcOrdeStat").change(function(){ $("#btnSearch").click(); });
    $("#srcRegisterCd").change(function(){ $("#btnSearch").click(); });
    $("#srcOrderDateFlag").change(function(){ $("#btnSearch").click(); });
    $("#srcBranchNm").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
<%
if("0".equals(srcIsBill) ){
%>
    $("#srcIsBill").val("0");
    $("#srcOrderDateFlag").val("4");
<%
}
%>
    
	venOrderHistList();
});

function venOrderHistList(page){
	$.blockUI();
	var page		= page;
	var rows		= 10;
	var srcOrdeIdenNumb	= $.trim($("#srcOrdeIdenNumb").val());
	var srcGoodName	= $.trim($("#srcGoodName").val());
	var srcGoodIdenNumb	= $.trim($("#srcGoodIdenNumb").val());
	var srcIsBill	= $.trim($("#srcIsBill").val());
	var srcOrdeStat	= $.trim($("#srcOrdeStat").val());
	var srcOrderDateFlag	= $.trim($("#srcOrderDateFlag").val());
	var srcOrderStartDate	= $.trim($("#srcOrderStartDate").val());
	var srcOrderEndDate	= $.trim($("#srcOrderEndDate").val());
	var srcConNm	= $.trim($("#srcConNm").val());
	$.post(
		"/venOrder/getVenOrderHistList.sys",
		{
			srcOrdeIdenNumb:srcOrdeIdenNumb,
			srcGoodName:srcGoodName,
			srcGoodIdenNumb:srcGoodIdenNumb,
			srcIsBill:srcIsBill,
			srcOrdeStat:srcOrdeStat,
			srcOrderDateFlag:srcOrderDateFlag,
			srcOrderStartDate:srcOrderStartDate,
			srcOrderEndDate:srcOrderEndDate,
			srcConNm:srcConNm,
			srcBranchNm:$("#srcBranchNm").val(),
			page:page,
			rows:rows
		},
		function(arg){
			var result = arg.custResponse;
			var list		= "" ;
			var currPage	= "" ;
			var rows		= "" ;
			var total		= "" ;
			var records		= "" ;
			var pageGrp		= "" ;
			var startPage	= "" ;
			var endPage		= "" ;
			if( result == false ){
				records = 0;
			}else{
				list		= arg.list;
				currPage	= arg.page;
				rows		= arg.rows;
				total		= arg.total;
				records		= arg.records;
				pageGrp		= Math.ceil(currPage/5);
				startPage	= (pageGrp-1)*5+1;
				endPage		= (pageGrp-1)*5+5;
				if(Number(endPage) > Number(total)){
					endPage = total;
				}
			}
			
            var length = $(".orderRecipt").length;
            if(length > 0){
                for(var i=0; i<length; i++){
                    $("#orderRecipt_"+i).remove();
                }
            }
            $("#pager").empty();
            
			if(records > 0){
				for(var i=0; i<list.length; i++){
					var str = "";
                    str += "<tr class='orderRecipt' id='orderRecipt_"+i+"'>    ";
                    str += 		"<td class=\"br_l0\">";
                    str += 			"<p>";
                    str += 				"<a href=\"javascript:fnOrderDetailView('" + list[i].ORDE_IDEN_NUMB + "', '', '');\">";
                    str +=					list[i].ORDE_IDEN_NUMB;
                    str +=				"</a>";
                    str +=				" ("+list[i].ORDE_TYPE_CLAS+")";
                    str +=			"</p>";
                    str += "    <div class=\"f11\">                                  ";
                    str += "      <p><strong>"+list[i].BRANCHNM+"</strong></p>               ";
                    str += "      <p><strong>주문일</strong> : "+list[i].REGI_DATE_TIME+"</p>         ";
                    str += "      <p><strong>공사명</strong> : "+list[i].CONS_IDEN_NAME;
					if(list[i].ADD_REPRE_SEQU_NUMB != "0"){
					str += "		<input type='hidden' id='add_repre_sequ_numb_"+i+"' name='add_repre_sequ_numb_' value='"+list[i].ADD_REPRE_SEQU_NUMB+"'>";
					str += "		<input type='hidden' id='temp_orde_iden_numb_"+i+"' name='temp_orde_iden_numb_' value='"+list[i].TEMP_ORDE_IDEN_NUMB+"'>";
						
                    str += "    	<button class='btn btn-darkgray btn-xs' onclick='fnVenProductDetail(\""+i+"\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>추가</button>";
                    
					}
                    str += "      </p>                ";
                    str += "  </div></td>                                          ";
                    str += "  <td align=\"center\">"+list[i].ORDER_STAT+"</td>                   ";
                    str += "  <td><p><a href='javascript:fnPdtSimpleDetailPop(\""+list[i].GOOD_IDEN_NUMB+"\");"+"'>"+list[i].GOOD_NAME+"</a> ("+list[i].GOOD_IDEN_NUMB+")</p>              ";
                    str += "    <div class=\"f11\">                                  ";
                    str += "      <p><strong>규격</strong> : "+list[i].GOOD_SPEC+"</p>   ";
                    str += "      <p><strong>단가</strong> : "+fnComma(list[i].SALE_UNIT_PRIC)+" 원</p>            ";
                    str += "      <p><strong>단위</strong> : "+list[i].ORDER_UNIT+"</p>                ";
                    str += "    </div></td>                                        ";
                    str += "  <td align=\"right\">"+fnComma(list[i].ORDE_REQU_QUAN)+"<br/>("+list[i].PURC_REQU_QUAN+")</td>                      ";
                    str += "  <td align=\"right\">"+fnComma(list[i].PURC_PRIC)+"</td>                   ";
                    str += "  <td align=\"center\">"+list[i].DELI_DATE+"<br/>("+list[i].DELAY_DAY+")</td>                   ";
                    str += "  <td align=\"center\">"+list[i].INVOICEDATE+"</td>                   ";
                    str += "  <td align=\"center\">"+list[i].RECE_REGI_DATE+"</td>                   ";
                    str += "  <td align=\"center\">"+list[i].CLOS_BUYI_DATE+"</td>                   ";
                    str += "  <td align=\"center\">"+list[i].AUTO_RECEIVE+"</td>                            ";
                    str += "</tr>    ";
					$("#orderHistTable").append(str);
				}
				
				fnPager(startPage, endPage, currPage, total, 'venOrderHistList');	//페이져 호출 함수

			}else{
                str += " <tr class='orderRecipt' id='orderRecipt_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='10' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                          ";
                str += " </tr>                                                                                                                                                         ";
                $("#orderHistTable").append(str);
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
function fnVenProductDetail(i){
    var ordeIdenNumb = $("#temp_orde_iden_numb_"+i).val()
    var ordeSequNumb = $("#add_repre_sequ_numb_"+i).val()
	fnProductDetailPop(ordeIdenNumb, ordeSequNumb);
}
<%-- 주문접수 엑셀일괄다운--%>
function fnAllExcelPrintDown(){
	var colLabels = ['주문번호', '구매사', '주문일',  '주문상태', '상품명', '공사명',
						'규격', '총중량', '실중량', '단위', '단가', '주문수량','수량', 
						'공급가액', '표준납기일', '지연일', '배송일','인수일',
						'계산서발행일', '자동인수여부','비고' ];
		var colIds = ['ORDE_IDEN_NUMB', 'BRANCHNM', 'REGI_DATE_TIME',  'ORDER_STAT', 'GOOD_NAME', 'CONS_IDEN_NAME',
						'GOOD_SPEC', 'SPEC_WEIGHT_SUM', 'SPEC_WEIGHT_REAL', 'ORDER_UNIT', 'SALE_UNIT_PRIC', 'ORDE_REQU_QUAN', 'PURC_REQU_QUAN',
						'PURC_PRIC',  'DELI_DATE', 'DELAY_DAY','INVOICEDATE','RECE_REGI_DATE',
						'CLOS_BUYI_DATE','AUTO_RECEIVE','DELI_DESC'];	//출력컬럼ID
		var numColIds = [ 'SALE_UNIT_PRIC', 'ORDE_REQU_QUAN', 'PURC_REQU_QUAN', 'PURC_PRIC'];	//숫자표현ID
		var sheetTitle = "주문이력조회";	//sheet 타이틀
		var excelFileName = "venOrderHistList";	//file 명
	
		var fieldSearchParamArray = new Array();     //파라메타 변수ID
		fieldSearchParamArray[0] = 'srcOrdeIdenNumb';
		fieldSearchParamArray[1] = 'srcGoodName';
		fieldSearchParamArray[2] = 'srcGoodIdenNumb';
		fieldSearchParamArray[3] = 'srcIsBill';
		fieldSearchParamArray[4] = 'srcOrdeStat';
		fieldSearchParamArray[5] = 'srcOrderDateFlag';
		fieldSearchParamArray[6] = 'srcOrderStartDate';
		fieldSearchParamArray[7] = 'srcOrderEndDate';
    fieldSearchParamArray[8] = 'srcBranchNm';
		
		fnExportExcelToSvc( "" , colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/venOrder/getVenOrderHistExcelList.sys");  
}

 </script>
</html>