<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%
	String _menuId              = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	System.out.println();
	System.out.println();
	System.out.println();
	System.out.println();
	System.out.println();
	System.out.println("_menuId : "+_menuId);
	System.out.println();
	System.out.println();
	System.out.println();
	System.out.println();
%>
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
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
});
</script>
</head>
<body class="subBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
  	<!-- /header -->
    <hr>
		<div id="divBody">
        	<div id="divSub">
            	<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
            	<!--카테고리(S)-->
			
		<!--컨텐츠(S)-->
<%
String srcInsertStartDate = CommonUtils.getCustomDay("DAY", -7);    // 날짜 세팅
String srcInsertEndDate = CommonUtils.getCurrentDate();
%>
        <div id="AllContainer">                    
          <ul class="Tabarea">
          <li class="on">입찰</li>
          </ul>
          <div style="position:absolute; right:0; margin-top:-30px;"><a href="#" onclick="fnSetList(1);"><img src="/img/contents/btn_tablesearch.gif" /></a></div>
          <form id="frmS">
		  <input name="srcVendorid" type="hidden" value="${sessionScope.sessionUserInfoDto.borgId}" />
          <table class="InputTable">
            <colgroup>
              <col width="100px" />
              <col width="auto" />
              <col width="100px" />
              <col width="auto" />
            </colgroup>
            <tr>
              <th>입찰명</th>
              <td><input name="srcBidname" type="text" style="width:200px;"/></td>
              <th>입찰상태</th>
              <td><select id="srcBidState" name="srcBidState" style="width:100px;" class="select">
                  <option value="">전체</option>
              </select></td>
            </tr>
            <tr>
              <th>상품명</th>
              <td><input name="srcStand_good_name" type="text" style="width:200px;"/></td>
              <th>시작일</th>
              <td><input id="srcInsertStartDate" name="srcInsert_FromDt" value="<%=srcInsertStartDate%>" type="text" style="width:80px;"/> ~
                <input id="srcInsertEndDate" name="srcInsert_EndDt" value="<%=srcInsertEndDate%>" type="text" style="width:80px;"/></td>
            </tr>
            <tr>
              <th>상품규격</th>
              <td><input name="srcStand_good_spec_desc" type="text" style="width:200px;"/></td>
              <th>구분</th>
              <td><select id="bidClassify" name="bidClassify" style="width:100px;" class="select">
                  <option value="">전체</option>
              </select></td>
            </tr>
          </table>
          </form>
          <div class="ListTable mgt_20">
            <table id="list">
              <colgroup>
                <col width="60px" />
                <col width="60px" />
                <col width="150px" />
                <col width="auto" />
                <col width="80px" />
                <col width="120px" />
                <col width="120px" />
                <col width="80px" />
                <col width="80px" />
              </colgroup>
              <tr>
                <th class="br_l0">입찰번호</th>
                <th>구분</th>
                <th>입찰명</th>
                <th>상품명</th>
                <th>입찰상태</th>
                <th>시작일자</th>
                <th>종료일자</th>
                <th>등록자</th>
                <th>투찰여부</th>
              </tr>
            </table>
          </div>
          <div id="pager" class="divPageNum"></div>     
		</div>
        <!--컨텐츠(E)-->
 </div>

                <jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
<script type="text/javascript">
//코드 데이터 초기화
function fnDataInit() {
    $.post( //조회조건의 변경구분 세팅
        '<%=Constances.SYSTEM_CONTEXT_PATH%>/common/getCodeList.sys',
        {codeTypeCd:"BIDSTATE", isUse:"1"},
        function(arg){
            var codeList = eval('(' + arg + ')').codeList;
            for(var i=0;i<codeList.length;i++) {
                $("#srcBidState").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
            }
        }
    );
    $.post(
        "/common/etc/selectCodeList/list.sys",
        {
            codeTypeCd:"bid_classify",
            isUse:"1"
        },
        function(arg){
            var list = eval('('+arg+')').list;
            for(var i=0; i<list.length; i++){
                $("#bidClassify").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
            }
        }
    );
}
/* 달력 UI 초기화 */
function fnInitDate() {
    $("#srcInsertStartDate").datepicker({
        showOn: "button",
        buttonImage: "/img/contents/btn_calenda.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
    });
    $("#srcInsertEndDate").datepicker({
        showOn: "button",
        buttonImage: "/img/contents/btn_calenda.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
    });
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}
$(function() {
    $.ajaxSetup ({cache: false});
    fnDataInit();
    fnInitDate();
    $('#frmS input').keypress(function (e) {
    	if( e.keyCode = 13 ){
    		fnSetList(1);
    	}
    });
    fnSetList(1);
});
</script>
<script type="text/javascript">
<%-- 신규상품 리스트--%>
var listDetail;
function fnSetList(page){
    $.blockUI();
    $(".trData").remove();
    $("#pager").empty();
    listDetail = "";
    var page        = page;
    var rows        = 10;
    
    $.post("/product/newProductBidListJQGrid.sys", $('#frmS').serialize()+'&page='+page+'&rows='+rows,
        function(arg){
            var list        = arg.list;
            listDetail      = arg.list;
            var currPage    = arg.page;
            var rows        = arg.rows;
            var total       = arg.total;
            var records     = arg.records;
            var pageGrp     = Math.ceil(currPage/5);
            var startPage   = (pageGrp-1)*5+1;
            var endPage     = (pageGrp-1)*5+5;
            if(Number(endPage) > Number(total)){
                endPage = total;
            }
            if(records > 0){
                var str = "";
                var data = "";
                for(var i=0; i<list.length; i++){
                    data = list[i]; 
                    str +='<tr class="trData">';
					str += '    <td class="br_l0" align="center"><p><a href="#" onclick="fnListDetail('+i+');">'+fnNullToSpace( data.bidid )+'</a></p>';
                    str += '    <td align="center">'+fnNullToSpace( data.bid_classify )+'</td>';
                    str += '    <td>'+fnNullToSpace( data.bidname )+'</td>';
                    str += '    <td><p>'+fnNullToSpace( data.stand_good_name )+'</p>';
                    str += '      <div class="f11">';
                    str += '        <p><strong>규격</strong> : '+fnNullToSpace( data.stand_good_spec_desc )+'</p>';
                    str += '      </div></td>';
                    str += '    <td align="center">'+fnNullToSpace( data.bidstateNm )+'</td>';
                    str += '    <td align="center">'+fnNullToSpace( data.insert_date )+'</td>';
                    str += '    <td align="center">'+fnNullToSpace( data.bidenddate )+'</td>';
                    str += '    <td align="center">'+fnNullToSpace( data.insert_user_id )+'</td>';
                    str += '    <td align="center">';
                    if (data.vendorbidstate == 10) {
                    	str += '미투찰';
                    } else if (data.vendorbidstate == 15) {                        
                        str += '투찰';
                    } else if (data.vendorbidstate == 50) {                        
                        str += '투찰';
                    }
                    str += '</td>';
                    str += '</tr>';
                }
                $("#list").append(str);
                fnPager(startPage, endPage, currPage, total, 'venDeliProcList');	//페이져 호출 함수
               
            } else {
                str += " <tr class='trData' id='trData_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='9' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                           ";
                str += " </tr>                                                                                                                                                         ";
                $("#list").append(str);
            }
            $.unblockUI();
        },
        "json"
    );
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
function fnNullToSpace( data ){
    if( !data ){
        data = "" ;
    }
    return data;
}
function fnSuccessBidAuctionProcess() {
    fnSetList(1);
}

function fnListDetail(i) {
        url = "/product/venProductTendorRegist.sys?_menuId=<%=_menuId%>&bidid="+listDetail[i].bidid+"&vendorid=${sessionScope.sessionUserInfoDto.borgId}&bidstate="+listDetail[i].bidstate;
    var win = window.open(url, 'venPop', 'width=880, height=700, scrollbars=yes, status=no, resizable=no');
    win.focus();
}
</script>
</body>
</html>