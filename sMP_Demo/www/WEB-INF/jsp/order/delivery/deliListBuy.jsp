<%@page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList           = (List<ActivitiesDto>) request.getAttribute("useActivityList"); //화면권한가져오기(필수)
	LoginUserDto        userDto            = CommonUtils.getLoginUserDto(request);
	String              _menuId            = CommonUtils.getRequestMenuId(request);
	String              srcStartDate       = CommonUtils.getCustomDay("MONTH", -1);
	String              srcEndDate         = CommonUtils.getCurrentDate();
	String              srcOrderStatusFlag = request.getParameter("srcOrderStatusFlag");
	
	srcOrderStatusFlag = CommonUtils.nvl(srcOrderStatusFlag);
	
	//Quick 메뉴 경로로 들어온 경우 조회 기간 3개월로
	String				linkOper			= request.getParameter("linkOper");
	if( linkOper != null && linkOper.equals("quick")){
		srcStartDate		= CommonUtils.getCustomDay("MONTH", -2);
		srcOrderStatusFlag	= "BB";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


<style type="text/css">
.ui-jqgrid .ui-jqgrid-bdiv {
    position: relative;
    margin: 0em;
    padding: 0;
    overflow: hidden;
}
.popOrderCancel{
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
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script>

$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
	
	$("#ordRejectPop").jqm();
	$("#ordRejectPop").jqm().jqDrag('#divPopupTitleCanc'); 
	
	$("#srcOrderStatusFlag").val("<%=srcOrderStatusFlag%>");
	
	$("#srcOrdeIdenNumb, #srcConsIdenName").keypress(function(e){ if(e.keyCode==13){ 	$("#srcButton").click();} });
	$("#srcButton").click(function(){ fnSearch(); });
	
	//날짜 데이터 초기화
	$("#srcOrdStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcOrdEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
	
	$("#srcButton").click();
});

function fnSearch(){
	$.blockUI({});
	$.ajax({
		type:"POST",
		url:"/order/delivery/selectDeleveryListOfBuy/list.sys",
		data: $('#frmSearch').serializeObject(),
		dataType:"json",
		success: function(data){
			$(".deliTr").remove();
			$("#summaryDiv").html('');
			var summaryCnt = 0;
			var summaryQuan = 0;
			var summaryAmount = 0;
			var list = data.list;
			var str = '';
			if ( list.length > 0){
				var deli, bgColor;
				summaryCnt = list.length;
				for(var i=0; i<list.length; i++){
					deli = list[i];
					
					summaryQuan += deli.PROD_QUAN;
					summaryAmount += deli.REQU_PRIC;
					str += '<tr class="deliTr">';
					if( deli.NUM == 1 ){
						str +='<td rowspan="'+ deli.TOTNUM +'" class="br_l0">';
						str +=	'<p onclick="javascript:fnOrderDetailView(\''+deli.ORDER_NUM+'\',\'<%=_menuId%>\')"><a href="#;">'+deli.ORDER_NUM+'</a></p>';
						str +=	'<p class="f11">'+ deli.CONS_IDEN_NAME +'</p>';
						str +='</td>';
					}
					str +=	'<td>';
                    str +=	'<input type="hidden" id="temp_orde_numb_'+i+'" value="'+list[i].ORDER_NUM+'">';
                    str +=	'<input type="hidden" id="temp_orde_iden_numb_'+i+'" name="temp_orde_iden_numb" value="'+list[i].TEMP_ORDE_IDEN_NUMB+'">';
                    str +=	'<input type="hidden" id="temp_orde_sequ_numb_'+i+'" value="'+list[i].TEMP_ORDE_SEQU_NUMB+'">';
                    str +=	'<input type="hidden" id="temp_purc_iden_numb_'+i+'" value="'+list[i].TEMP_PURC_IDEN_NUMB+'">';
                    str +=	'<input type="hidden" id="temp_deli_iden_numb_'+i+'" value="'+list[i].TEMP_DELI_IDEN_NUMB+'">';
                    str +=	'<input type="hidden" id="deli_type_clas_code_'+i+'" value="'+list[i].DELI_TYPE_CLAS+'">';
                    str +=	'<input type="hidden" id="deli_invo_iden_'+i+'" value="'+list[i].DELI_INVO_IDEN+'">';
					str +=		'<p onclick="fnProductDetailPop(\''+deli.GOOD_IDEN_NUMB+'\',\''+deli.VENDORID+'\')"><a href="#;">'+ deli.GOOD_NAME +'</a></p>';
					str +=		'<div class="f11">';
					str +=			'<p><strong>규격</strong> : '+deli.GOOD_SPEC +'</p>';
					str +=			'<p>' ;
					str +=				'<strong>공급사</strong> : '+deli.VENDORNM ;
					if( deli.MAKE_COMP_NAME ){
						str += 			' (제조사 : '+deli.MAKE_COMP_NAME+')';						
					}
					str +=			'</p>';
					str +=		'</div>';
					str +=	'</td>';
					str +=	'<td class="count">';
					str +=		'<p>'+ fnComma(deli.PROD_QUAN) +'</p>';
					str +=		'<p>('+ fnComma(deli.ORDE_REQU_PRIC) +')</p>';
					str +=		'<p>'+ fnComma(deli.REQU_PRIC) +'</p>';
					str +=	'</td>';
					str +=	'<td align="center" >'+ deli.DELI_SCHE_DATE +'</td>';
					
					bgColor = deli.REGI_DATE_TIME ? "papayawhip" : "none";  
					str +=	'<td align="center" style="background-color:'+ bgColor +';" >'+ deli.REGI_DATE_TIME +'</td>';
					bgColor = deli.PURC_RECE_DATE ? "papayawhip" : "none";  
					str +=	'<td align="center" style="background-color:'+ bgColor +';" >'+ deli.PURC_RECE_DATE +'</td>';
					bgColor = deli.DELI_DEGR_DATE ? "papayawhip" : "none";  
					str +=	'<td align="center" style="background-color:'+ bgColor +';" >'+ deli.DELI_DEGR_DATE +'</td>';
					bgColor = deli.RECE_REGI_DATE ? "papayawhip" : "none";  
					str +=	'<td align="center" style="background-color:'+ bgColor +';" >'+ deli.RECE_REGI_DATE +'</td>';
					str +='<td align="center">';
					if( deli.STAT_FLAG <= 40 ){
						str +=	'<p><button id="" class="btn btn-default btn-xs" style="width:90px;" onclick="javascript:fnOrderCancelProc(\''+i+'\');">주문취소</button></p>';
					}else if( deli.STAT_FLAG == 50 ){
						str +=	'<p><button id="" class="btn btn-default btn-xs" style="width:90px;" onclick="javascript:fnOrderCancelReqProc(\''+i+'\');">주문취소요청</button></p>';
					}else{
						str += '<p><b>'+ deli.STAT_NM + '</b></p>';
					}
					if( deli.DELI_INVO_IDEN ){
						str += '<p><button id="" class="btn btn-darkgray btn-xs" style="width:90px;" onclick="javascript:fnDeliInfoTrace('+i+');">배송추적</button></p>';
					}
					var tempIsPurcPrint = "btn-info";
					if( deli.IS_PURC_PRINT == 'Y'){
                        tempIsPurcPrint = "btn-gray";
					}
					str += '<p><button id="estimateSheetPrintBtn_'+i+'" class="btn '+tempIsPurcPrint+' btn-xs" style="width:90px;" onclick="javascript:fnEstimateSheet('+i+');">발주서</button></p>';
					str +=	'</td>';
					str +='</tr>';
				}

			}else{
				str += '<tr class="deliTr"><td colspan="9" align="center">조회된 데이터가 없습니다.</td></tr>';	
			}
			
			$("#deliTable").append(str);
			$("#summaryDiv").html('총 '+fnComma(summaryCnt)+'건의 주문 총수량 : '+fnComma(summaryQuan)+",  금액합계 : "+fnComma(summaryAmount)+"원");
			$.unblockUI({});
		}
	});
}

function fnEstimateSheet(i){
    var borgNm      = '<%=userDto.getBorgNm()%>';
    var orderNm     = '';
    var skCeoNm     = '<%=Constances.EBILL_COCEO%>';
    var skAddr      = '<%=Constances.EBILL_COADDR%>';
    var skTel       = '<%=Constances.EBILL_TEL%>';
    var skFax       = '<%=Constances.EBILL_FAX%>';
    var payBillType = '';
<%
    String prodSpec = "";

    for(int i = 0 ; i < Constances.PROD_GOOD_SPEC.length ; i++){
        if(i == 0){
        	prodSpec = Constances.PROD_GOOD_SPEC[i];
        }
        else{
        	prodSpec += "‡" + Constances.PROD_GOOD_SPEC[i];
        }
    }
    
    String prodStSpec = "";
    
    for(int i = 0 ; i < Constances.PROD_GOOD_ST_SPEC.length ; i++){
        if(i == 0){
        	prodStSpec = Constances.PROD_GOOD_ST_SPEC[i];
        }
        else{
        	prodStSpec += "‡" + Constances.PROD_GOOD_ST_SPEC[i];
        }
    }                
%>
    var prodSpec    = '<%=prodSpec%>';
    var prodStSpec  = '<%=prodStSpec%>';
    
    var orderIdenNumb = $("#temp_orde_iden_numb_" + i).val();
    
    
	$.blockUI();
	$.post(
		"/buyOrder/updateMrordmIsPurcPrint.sys",
		{
			orderIdenNumb:orderIdenNumb
		},
		function(arg){
			if($.parseJSON(arg).customResponse.success){
				
				$("input[name='temp_orde_iden_numb']").each(function(idx){
					var temp1 = $.trim($(this).val());
					var temp2 = $.trim(orderIdenNumb);
					if(temp1 == temp2){
						$("#estimateSheetPrintBtn_"+idx).attr("class","btn btn-gray btn-xs");
					}
				});
                var oReport = GetfnParamSet(); // 필수
                oReport.rptname = "estimateSheet"; // reb 파일이름
                
                oReport.param("borgNm").value       = borgNm;
                oReport.param("orderNm").value      = orderNm;
                oReport.param("payBillType").value  = payBillType;
                oReport.param("skCeoNm").value      = skCeoNm;
                oReport.param("skAddr").value       = skAddr;
                oReport.param("skTel").value        = skTel;
                oReport.param("skFax").value        = skFax;
                oReport.param("prodSpec").value         = prodSpec;
                oReport.param("prodStSpec").value       = prodStSpec;
                oReport.param("orderIdenNumb").value    = orderIdenNumb;

                oReport.title = "견적서"; // 제목 세팅
                oReport.open();
			}else{
				alert("처리중 오류가 발생하였습니다.");
			}
			$.unblockUI();
		}
	);
    
    
}

function fnOrderCancelProc(index){
	$("#tempTitleName").html("주문취소");
	$("#ordCancIndex").val(index);
	$("#chanReasDescForCanc").val("");
	$("#ordRejectPop").jqmShow();
	$("#popOrdCancBtn").show();
	$("#popOrdCancReqBtn").hide();
}

function procOrdCancel(){
    if(!confirm("주문취소를 진행하시겠습니까?")) return;
	var orde_iden_numb = $("#temp_orde_numb_"+$("#ordCancIndex").val()).val();
	var reason = $("#chanReasDescForCanc").val();
    fnPopCancClose();
	$.blockUI();
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/buyOrder/orderCancel.sys",
        {  
            orde_iden_numb:orde_iden_numb 
        ,	reason:reason
        }
        ,function(arg){ 
            if($.parseJSON(arg).customResponse.success){
                alert("정상적으로 주문취소 처리가 되었습니다.");
                fnSearch();
            }else{
            	var errs = $.parseJSON(arg).customResponse.message;
				var msg = "";
				for(var i=0 ; i < errs.length; i++){
					msg += errs[i];
				}
				alert(msg);
            }
			$.unblockUI();
        }
    );
}
function fnPopCancClose(){
	$("#ordCancIndex").val("");
	$("#chanReasDescForCanc").val("");
	$("#ordRejectPop").jqmHide();
	$("#popOrdCancBtn").hide();
	$("#popOrdCancReqBtn").hide();
}



function fnOrderCancelReqProc(index){
	$("#tempTitleName").html("주문취소요청");
	$("#ordCancIndex").val(index);
	$("#chanReasDescForCanc").val("");
	$("#ordRejectPop").jqmShow();
	$("#popOrdCancReqBtn").show();
	$("#popOrdCancBtn").hide();
}

function procOrdCancelRequest(){
    if(!confirm("주문취소요청을 진행하시겠습니까?")) return;
	var ordeIdenNumb = $("#temp_orde_iden_numb_"+$("#ordCancIndex").val()).val();
	var ordeSequNumb = $("#temp_orde_sequ_numb_"+$("#ordCancIndex").val()).val();
	var purcIdenNumb = $("#temp_purc_iden_numb_"+$("#ordCancIndex").val()).val();
	var reason = $("#chanReasDescForCanc").val();
    fnPopCancReqClose();
	$.blockUI();
    $.post(
        "<%=Constances.SYSTEM_CONTEXT_PATH%>/buyOrder/purcCancStart.sys",
        {  
            ordeIdenNumb:ordeIdenNumb
        ,	ordeSequNumb:ordeSequNumb
        ,	purcIdenNumb:purcIdenNumb
        ,	reason:reason
        }
        ,function(arg){ 
            if($.parseJSON(arg).customResponse.success){
                alert("정상적으로 주문취소요청 처리가 되었습니다.");
                fnSearch();
            }else{
            	var errs = $.parseJSON(arg).customResponse.message;
				var msg = "";
				for(var i=0 ; i < errs.length; i++){
					msg += errs[i];
				}
				alert(msg);
            }
			$.unblockUI();
        }
    );
}
function fnPopCancReqClose(){
	$("#ordCancIndex").val("");
	$("#chanReasDescForCanc").val("");
	$("#ordRejectPop").jqmHide();
	$("#popOrdCancReqBtn").hide();
	$("#popOrdCancBtn").hide();
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
        var orde_iden_numb = $("#temp_orde_numb_"+seq).val();
        var purc_iden_numb = $("#temp_purc_iden_numb_"+seq).val();
        var deli_iden_numb = $("#temp_deli_iden_numb_"+seq).val();
        
        var paramString = "?orde_iden_numb="+orde_iden_numb+"&purc_iden_numb="+purc_iden_numb+"&deli_iden_numb="+deli_iden_numb+"";
        var scrSizeHeight = 0;
        scrSizeHeight = screen.height;
        var windowLeft = (screen.width-900)/2;
        var windowTop = (screen.height-700)/2;
        window.open('<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/clientReceiveDeliInfoPop.sys'+paramString,'배송조회', 'width=500, height=250,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=yes');
    }
}
</script>


<body class="mainBg">
	<div id="divWrap">
		<!-- header -->
		<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
		<!-- /header -->
		<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />

				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">주문 진척도</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;">
						<a href="#;"><img id="srcButton" src="/img/contents/btn_tablesearch.gif" /></a>
					</div>
					<form id="frmSearch" name="frmSearch" onsubmit="return false;">
					<table class="InputTable">
						<colgroup>
							<col width="120px" />
							<col width="auto" />
							<col width="120px" />
							<col width="auto" />
						</colgroup>
						<tr>
							<th>주문번호</th>
							<td><input type="text" id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" style="width:150px;" value=""/></td>
							<th>주문일</th>
							<td>
								<input id="srcOrdStartDate" name="srcOrdStartDate"type="text" style="width:80px;" value="<%=srcStartDate%>"/>
								~<input id="srcOrdEndDate" name="srcOrdEndDate" type="text" style="width:80px;" value="<%=srcEndDate%>"/>
								
						</tr>
						<tr>
							<th>주문명</th>
							<td> <input id="srcConsIdenName" name="srcConsIdenName" type="text" style="width:300px;" value=""/> </td>
							<th>주문상태</th>
							<td>
								<select id="srcOrderStatusFlag" name="srcOrderStatusFlag" style="width:180px" onchange="javascript:changeOrderStatusFlag();">
                                    <option value="" selected="selected">전체</option>
                                    <option value="A">승인/주문요청,주문의뢰</option>
                                    <option value="B">주문접수,주문취소요청</option>
                                    <option value="BB">주문취소요청</option>
                                    <option value="C">배송중</option>
                                    <option value="D">인수완료</option>
                                </select>
							</td>
						</tr>
					</table>
					</form>
					<div style="text-align: left; vertical-align: text-bottom; font-weight: bold;margin-top: 10px;">
						* 발주서가 출력된 경우에는 발주서 버튼이 회색으로 표시됩니다. 
					</div>
					<div id="summaryDiv" style="text-align: right; vertical-align: text-bottom; font-weight: bold;margin-top: -18px;">
						* 총 13건의 주문 총수량:1,223건, 금액합계:343,421원 
					</div>
					<div class="ListTable mgt_5">
						<table id="deliTable">
							<colgroup>
								<col width="130px" />
								<col width="auto" />
								<col width="60px" />
								<col width="84px" />
								<col width="84px" />
								<col width="84px" />
								<col width="84px" />
								<col width="84px" />
								<col width="90px" />
							</colgroup>
							<tr>
								<th rowspan="2" class="br_l0">주문정보<br/>(주문명)</th>
								<th rowspan="2">주문 상품 정보</th>
								<th rowspan="2">수량<br />(단가) <br />주문금액</th>
								<th rowspan="2">납품예정일</th>
								<th colspan="4">주문현황</th>
								<th rowspan="2">주문상태 및<br />처리</th>
							</tr>
							<tr>
								<th>주문</th>
								<th>주문접수</th>
								<th>배송</th>
								<th>인수</th>
							</tr>
						</table>
					</div>
					<div style="height:10px;"></div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
    <div id="ordRejectPop" class="jqmPop" style="font_size: 12px; display: none;">
        <div>
            <div id="divPopup"  style="width:400px;">
                <h1 id="divPopupTitle"><span id="tempTitleName"></span> </h1>
                <div class="popcont">
                    <table class="InputTable">
                        <colgroup>
                            <col width="100px" />
                            <col width="auto" />
                        </colgroup>
                        <tr>
                            <th>사유</th>
                                <td>
                                    <input type="hidden" id="ordCancIndex" value=""/>
                                    <textarea id="chanReasDescForCanc" cols="" rows="" style="width:98%; height: 100px;"></textarea>
                                </td>
                        </tr>
                    </table>
                    <div class="Ac mgt_10">
                        <button id='popOrdCancBtn' class='btn btn-warning btn-xs' onclick="javascript:procOrdCancel();" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>>주문취소</button>
                        <button id='popOrdCancReqBtn' class='btn btn-warning btn-xs' onclick="javascript:procOrdCancelRequest();" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>>주문취소요청</button>
                        <button id='popOrdCancClsBtn' class='btn btn-primary btn-xs' onclick="fnPopCancClose();">닫기</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>
</html>


 

 
 
 
 