<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
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
          <li class="on">상품 변경 요청 조회</li>
          </ul>
          <div style="position:absolute; right:0; margin-top:-30px;"><a href="#" onclick="fnSetList(1);"><img src="/img/contents/btn_tablesearch.gif" /></a></div>
          <form id="frmS">
          <input name="goodClasCode" type="hidden" value="" />
          <input name="goodFixDate" type="hidden" value="0" />
          <input id="srcVendorId" name="srcVendorId" type="hidden" value="${sessionScope.sessionUserInfoDto.borgId}" />
          <table class="InputTable">
            <colgroup>
              <col width="100px" />
              <col width="auto" />
              <col width="100px" />
              <col width="auto" />
            </colgroup>
            <tr>
              <th>상품명</th>
              <td><input name="srcGoodName" type="text" style="width:200px;"/></td>
              <th>처리상태</th>
              <td><select id="srcFixAppSts" name="srcFixAppSts" style="width:100px;" class="select">
                  <option value="">전체</option>
              </select></td>
            </tr>
            <tr>
              <th>변경구분</th>
              <td><select id="srcAppltFixCode" name="srcAppltFixCode" style="width:100px;" class="select">
                  <option value="">전체</option>
                  <option value="10">상품등록요청</option>
              </select></td>
              <th>요청일</th>
              <td><input id="srcInsertStartDate" name="srcInsertStartDate" value="<%=srcInsertStartDate%>" type="text" style="width:80px;"/> ~
                <input id="srcInsertEndDate" name="srcInsertEndDate" value="<%=srcInsertEndDate%>" type="text" style="width:80px;"/></td>
            </tr>
          </table>
          </form>
          <div class="ListTable mgt_20">
            <table id="list">
            <colgroup>
              <col width="auto" />
              <col width="80px" />
              <col width="100px" />
              <col width="200px" />
              <col width="100px" />
              <col width="130px" />
              <col width="130px" />
            </colgroup>
            <tr>
              <th rowspan="2" class="br_l0">상품정보</th>
              <th rowspan="2"><p>상품구분</p></th>
              <th rowspan="2">요청내용</th>
              <th rowspan="2">요청 사유</th>
              <th rowspan="2"><p>처리상태</p></th>
              <th colspan="2">승인내역</th>
              </tr>
            <tr>
              <th><p>요청자(요청일)</p></th>
              <th><p>승인자(결재일)</p></th>
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
        {codeTypeCd:"APPLTFIXCODE", isUse:"1"},
        function(arg){
            var codeList = eval('(' + arg + ')').codeList;
            for(var i=1;i<codeList.length;i++) {
                $("#srcAppltFixCode").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
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
    $.post("/product/productRequestDiscontinuanceListJQGrid.sys", $('#frmS').serialize()+'&page='+page+'&rows='+rows,
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
            var str = "";
            var data = "";
            if(records > 0){
                for(var i=0; i<list.length; i++){
                    data = list[i]; 
                    str +='<tr class="trData">';
					str += '  <td class="br_l0"><p><a href="#" onclick="fnListDetail('+i+');">'+ fnNullToSpace( data.good_Name )+'</a></p>';
					str += '    <div class="f11">';
                    str += '      <p><strong>상품코드</strong> : <a href="#" onclick="fnGood('+i+');">'+(data.good_Iden_Numb=='0'?'':data.good_Iden_Numb)+'</a></p>';
					str += '      <p><strong>규격</strong> : '+ fnNullToSpace( data.good_Spec_Desc )+'</p>';
					str += '    </div></td>';
					str += '  <td align="center">'+ fnNullToSpace( data.good_Clas_Code )+'</td>';
					str += '  <td align="center">';
					if (data.applt_Fix_Code == '20') {
						str += '단가변경요청<br/>'+fnComma(data.sale_Unit_Pric)+'>'+fnComma(data.price);
					} else if (data.applt_Fix_Code == '30') {
					   str += '단종요청';	
					} else if (data.applt_Fix_Code == '10') {
                       str += '상품등록요청';   
                    }
					str += '</td>';
					str += '  <td>'+ fnNullToSpace( data.apply_Desc )+'</td>';
					str += '  <td align="center"><p>';
					if (data.fix_App_Sts == '0') {
						str += '요청';
					} else if (data.fix_App_Sts == '2') {
                        str += '승인_처리완료+';
                    } else if (data.fix_App_Sts == '3') {
                        str += '반려';
					}
					str += '</p></td>';
					str += '  <td align="center">'+ fnNullToSpace( data.insert_User_Nm )+'<br/>('+ fnNullToSpace( data.insert_Date )+')</td>';
					if (data.app_User_Id) {
					   str += '  <td align="center">'+ fnNullToSpace( data.app_User_Id )+'<br/>('+ fnNullToSpace( data.app_Date )+')</td>';	
					} else {
                       str += '  <td align="center"> </td>'; 
					}
					str += '</tr>';
                }
                $("#list").append(str);
                
                fnPager(startPage, endPage, currPage, total, 'fnSetList');	//페이져 호출 함수

            } else {
                str += " <tr class='trData' id='trData_0'>                                                                                                                                            ";
                str += "   <td class='br_l0' colspan='7' align='center' >조회된 결과가 없습니다.</td>                                                                                                                                          ";
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
	n = '' + parseInt(n, 10);
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

function fnListDetail(i) {
	if (listDetail[i].applt_Fix_Code == '10') {
	    var url = '/product/popProductVenReg.sys?req_good_id=' + listDetail[i].fix_Good_Id;
	    var win = window.open(url, 'venPop', 'width=917, height=750, scrollbars=auto, status=no, resizable=no');
	    win.focus();
	} else {
	    var url = '/product/popProductVen.sys?good_iden_numb=' + listDetail[i].good_Iden_Numb;
	    var win = window.open(url, 'venPop', 'width=917, height=750, scrollbars=auto, status=no, resizable=no');
	    win.focus();
	}
}

function fnGood(i) {
    var url = '/product/popProductVen.sys?good_iden_numb=' + listDetail[i].good_Iden_Numb;
    var win = window.open(url, 'venPop', 'width=917, height=750, scrollbars=auto, status=no, resizable=no');
    win.focus();
}
</script>
</body>
</html>