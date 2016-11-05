<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	LoginUserDto lud = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	//주문접수 날짜 세팅
	String startDate	= CommonUtils.getCustomDay("DAY", -7);
	String endDate		= CommonUtils.getCurrentDate();
	@SuppressWarnings("unchecked")  //화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	String srcOrderStatusFlag = request.getParameter("srcOrderStatusFlag") != null && request.getParameter("srcOrderStatusFlag").equals("") == false ? request.getParameter("srcOrderStatusFlag") : "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<style type="text/css">
.popOrderCancReqReject {
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
<script type="text/javascript">
$(document).ready(function() {
	$("#divGnb").mouseover(function () { $("#snb_vdr").show(); });
	$("#divGnb").mouseout(function () { $("#snb_vdr").hide(); });
	$("#snb_vdr").mouseover(function () { $("#snb_vdr").show(); });
	$("#snb_vdr").mouseout(function () { $("#snb_vdr").hide(); });
	
	$("#popOrderReject").jqm();
	$('#popOrderReject').jqm().jqDrag('#divPopupTitle');
	
	<%-- 날짜 데이터 초기화--%> 	
	fnDateInit();
	
	<%-- 발주서 리스트--%>
	fnVenOrderProgressList();
	
	<%-- 엔터 키 이벤트 --%>
	$("#orderNumber").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#startDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	$("#endDate").keydown(function(e){
		if(e.keyCode == '13'){
			fnSearch();
		}
	});
	
	$("#divPopup2").jqm();
	$('#divPopup2').jqm().jqDrag('#divPopupTitle');
	
	$("#srcOrderStatusFlag").val("<%=srcOrderStatusFlag%>");
});

<%-- 날짜 데이터 초기화--%> 
function fnDateInit() {
	$("#startDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#endDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}

<%-- 공급사 주문 진척도 --%>
function fnVenOrderProgressList(page){
	$.blockUI();
	$("#pager").empty();
	$(".venOrderProgress").remove();
	var page			= page;
	var rows			= 10;
	var orderNumber		= $("#orderNumber").val();
	var startDate		= $("#startDate").val();
	var endDate			= $("#endDate").val();
	var srcOrderStatusFlag			= $("#srcOrderStatusFlag").val();
	
	$.post(
		"/venOrder/venOrderProgressList.sys",
		{
			orderNumber:orderNumber,
			startDate:startDate,
			endDate:endDate,
			srcOrderStatusFlag:srcOrderStatusFlag,
			page:page,
			rows:rows
		},
		function(arg){
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
					var deliListCnt	= list[i].orderProgressDeliListCnt;
					var deliList	= list[i].orderProgressDeliList;
					if(deliListCnt > 1){
						var str = "";
						str += "<tr id='venOrderProgress_"+i+"' class='venOrderProgress'>";
						str += "<td rowspan='"+deliListCnt+"' class='br_l0'>";
						str += "<p>"+list[i].ORDE_IDEN_NUMB+"-"+list[i].ORDE_SEQU_NUMB+"</p>";
						str += "<p class='f11'>주문명  : "+list[i].CONS_IDEN_NAME+"</p>";
						str += "<p class='f11'>구매사  : "+list[i].BRANCHNM;
                        if(list[i].ADD_REPRE_SEQU_NUMB != "0"){
                        	
                        str += "		<input type='hidden' id='orde_iden_numb_"+i+"' name='orde_iden_numb_"+i+"' value='"+list[i].ORDE_IDEN_NUMB+"'>";
                        str += "		<input type='hidden' id='add_repre_sequ_numb_"+i+"' name='add_repre_sequ_numb_' value='"+list[i].ADD_REPRE_SEQU_NUMB+"'>";
                        str += "    	<button class='btn btn-warning btn-xs' onclick='fnVenProductDetail(\""+i+"\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>추가</button>";
                        
                        }
						str += "</p></td>";

						var listChk = true;
						for(var j=0; j<deliListCnt; j++){
							if(listChk){
								str += "<td><p><a href='javascript:fnPdtSimpleDetailPop(\""+deliList[j].GOOD_IDEN_NUMB+"\");"+"'>"+deliList[j].GOOD_NAME+"</a></p>";
								str += "<div class='f11'>";
								str += "<p><strong>규&nbsp;&nbsp;&nbsp;&nbsp; 격</strong> : "+deliList[j].GOOD_SPEC+"  </p>";
								str += "<p><strong>공급사</strong> : "+deliList[j].VENDORNM+"</p>";
								str += "</div>";
                                str += "<input type='hidden' id='deli_type_clas_code_"+i+"_"+j+"' name='deli_type_clas_code_"+i+"_"+j+"'  value='"+deliList[j].DELI_TYPE_CLAS_CODE+"'/>                 ";
                                str += "<input type='hidden' id='deli_invo_iden_"+i+"_"+j+"' name='deli_invo_iden_"+i+"_"+j+"'  value='"+deliList[j].DELI_INVO_IDEN+"'/>                 ";
                                
                                str += "<input type='hidden' id='orde_iden_numb_"+i+"_"+j+"' name='orde_iden_numb_"+i+"'  value='"+list[i].TEMP_ORDE_IDEN_NUMB+"'/>                 ";
                                str += "<input type='hidden' id='purc_iden_numb_"+i+"_"+j+"' name='purc_iden_numb_"+i+"'  value='"+list[i].PURC_IDEN_NUMB+"'/>                 ";
                                str += "<input type='hidden' id='deli_iden_numb_"+i+"_"+j+"' name='deli_iden_numb_"+i+"'  value='"+deliList[j].DELI_IDEN_NUMB+"'/>                 ";
                                
								str += "</td>";
								str += "<td class='count'><p>"+fnComma(deliList[j].QUANTITY)+"</p>";
								str += "<p>("+fnComma(deliList[j].SALE_UNIT_PRIC)+")</p></td>";
								str += "<td align='center'>";
								str += 	"<p style='color:red;font-weight:800;''>"+deliList[j].DELI_SCHE_DATE+"</p>";
								str += 	"(<span style='color:red'>"+deliList[j].REQU_DELI_DATE+"</span>)";
								str += "</td>";
								
								var bgcolor = " style='background-color:papayawhip;' "; 
								str += "<td align='center' " + (list[i].REGI_DATE_TIME?bgcolor:"") +">"+list[i].REGI_DATE_TIME+"</td>";
								str += "<td align='center' " + (deliList[j].PURC_RECE_DATE?bgcolor:"") +">"+deliList[j].PURC_RECE_DATE+"</td>";
								str += "<td align='center' " + (deliList[j].DELI_DEGR_DATE?bgcolor:"") +">"+deliList[j].DELI_DEGR_DATE+"</td>";
								str += "<td align='center' " + (deliList[j].PURC_PROC_DATE?bgcolor:"") +">"+deliList[j].PURC_PROC_DATE+"</td>";
								
								if(list[i].ORDE_STAT_FLAG >= 60){
									
                                str += "<td align='center' >";
                                str += "    <button class='btn btn-default btn-xs'  style='width:80px;' onclick='fnDeliInfoTrace(\""+i+"_"+j+"\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>배송추적</button>";
                                str += "</td>";
									
								}else if(list[i].ORDE_STAT_FLAG == 59){
									
                                str += "<td align='center'>";
                                str += "<button class='btn btn-darkgray btn-xs' style='width:80px;' onclick='fnCancReqDivPop(\""+list[i].ORDE_IDEN_NUMB+"\",\""+list[i].ORDE_SEQU_NUMB+"\",\""+list[i].PURC_IDEN_NUMB+"\");'>주문취소요청</button>";
                                str += "</td>";
									
								}else if(list[i].ORDE_STAT_FLAG == 40){
									
                                str += "<td align='center'>";
                                str += "<button id='popOrdPurcRejectBtn' class='btn btn-darkgray btn-xs' onclick='fnRejectPopupOpen();'>주문거부</button>";
                                str += "</td>";
									
								}else{
									
                                str += "<td align='center'></td>";
									
								}
								str += "</tr>";
								listChk = false;
							}else{
								str += "<tr id='venOrderProgress_"+i+"' class='venOrderProgress'>";
								str += "<td>";
								str += "<p><a href='javascript:fnPdtSimpleDetailPop(\""+deliList[j].GOOD_IDEN_NUMB+"\");"+"'>"+deliList[j].GOOD_NAME+"</a></p>";
								str += "<div class='f11'>";
								str += "<p><strong>규&nbsp;&nbsp;&nbsp;&nbsp; 격</strong> : "+deliList[j].GOOD_SPEC+"  </p>";
								str += "<p><strong>공급사</strong> : "+deliList[j].VENDORNM+"</p>";
								str += "</div>";
                                str += "<input type='hidden' id='orde_iden_numb_"+i+"_"+j+"' name='orde_iden_numb_"+i+"'  value='"+list[i].TEMP_ORDE_IDEN_NUMB+"'/>                 ";
                                str += "<input type='hidden' id='purc_iden_numb_"+i+"_"+j+"' name='purc_iden_numb_"+i+"'  value='"+list[i].PURC_IDEN_NUMB+"'/>                 ";
                                str += "<input type='hidden' id='deli_iden_numb_"+i+"_"+j+"' name='deli_iden_numb_"+i+"'  value='"+deliList[j].DELI_IDEN_NUMB+"'/>                 ";
                                str += "<input type='hidden' id='deli_type_clas_code_"+i+"_"+j+"' name='deli_type_clas_code_"+i+"_"+j+"'  value='"+deliList[j].DELI_TYPE_CLAS_CODE+"'/>                 ";
                                str += "<input type='hidden' id='deli_invo_iden_"+i+"_"+j+"' name='deli_invo_iden_"+i+"_"+j+"'  value='"+deliList[j].DELI_INVO_IDEN+"'/>                 ";
								str += "</td>";
								str += "<td class='count'><p>"+fnComma(deliList[j].QUANTITY)+"</p>";
								str += "<p>("+fnComma(deliList[j].SALE_UNIT_PRIC)+")</p></td>";
								str += "<td align='center'>";
								str += 	"<p style='color:red;font-weight:800;''>"+deliList[j].DELI_SCHE_DATE+"</p>";
								str += 	"(<span style='color:red'>"+deliList[j].REQU_DELI_DATE+"</span>)";
								str += "</td>";
								
								var bgcolor = " style='background-color:papayawhip;' "; 
								str += "<td align='center' " + (list[i].REGI_DATE_TIME?bgcolor:"") +">"+list[i].REGI_DATE_TIME+"</td>";
								str += "<td align='center' " + (deliList[j].PURC_RECE_DATE?bgcolor:"") +">"+deliList[j].PURC_RECE_DATE+"</td>";
								str += "<td align='center' " + (deliList[j].DELI_DEGR_DATE?bgcolor:"") +">"+deliList[j].DELI_DEGR_DATE+"</td>";
								str += "<td align='center' " + (deliList[j].PURC_PROC_DATE?bgcolor:"") +">"+deliList[j].PURC_PROC_DATE+"</td>";
								
								if(list[i].ORDE_STAT_FLAG >= 60){
									
                                str += "<td align='center' >";
                                str += "    <button class='btn btn-default btn-xs' style='width:80px;' onclick='fnDeliInfoTrace(\""+i+"_"+j+"\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>배송추적</button>";
                                str += "</td>";
									
								}else if(list[i].ORDE_STAT_FLAG == 59){
									
                                str += "<td align='center'>";
                                str += "<button class='btn btn-darkgray btn-xs' style='width:80px;' onclick='fnCancReqDivPop(\""+list[i].ORDE_IDEN_NUMB+"\",\""+list[i].ORDE_SEQU_NUMB+"\",\""+list[i].PURC_IDEN_NUMB+"\");'>주문취소요청</button>";
                                str += "</td>";
									
								}else if(list[i].ORDE_STAT_FLAG == 40){
									
                                str += "<td align='center'>";
                                str += "<button class='btn btn-darkgray btn-xs' onclick='fnRejectPopupOpen(\""+list[i].ORDE_IDEN_NUMB+"\",\""+list[i].ORDE_SEQU_NUMB+"\",\""+list[i].PURC_IDEN_NUMB+"\");'>주문거부</button>";
                                str += "</td>";
                                
								}else{
									
                                str += "<td align='center'></td>";
									
								}
								str += "</tr>";
							}
						}
					}else{
						var str = "";
						str += "<tr id='venOrderProgress_"+i+"' class='venOrderProgress'>";
						str += "<td rowspan='"+deliListCnt+"' class='br_l0'>";
						str += "<p>"+list[i].ORDE_IDEN_NUMB+"-"+list[i].ORDE_SEQU_NUMB+"</p>";
						str += "<p class='f11'>주문명  : "+list[i].CONS_IDEN_NAME+"</p>";
						str += "<p class='f11'>구매사 : "+list[i].BRANCHNM;
                        if(list[i].ADD_REPRE_SEQU_NUMB != "0"){
                        	
                        str += "		<input type='hidden' id='orde_iden_numb_"+i+"' name='orde_iden_numb_"+i+"' value='"+list[i].ORDE_IDEN_NUMB+"'>";
                        str += "		<input type='hidden' id='add_repre_sequ_numb_"+i+"' name='add_repre_sequ_numb_' value='"+list[i].ADD_REPRE_SEQU_NUMB+"'>";
                        str += "    	<button class='btn btn-darkgray btn-xs' onclick='fnVenProductDetail(\""+i+"\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>추가</button>";
                        
                        }
						str += "</p></td>";
						for(var j=0; j<deliListCnt; j++){
							str += "<td>";
							str += "<p><a href='javascript:fnPdtSimpleDetailPop(\""+deliList[j].GOOD_IDEN_NUMB+"\");"+"'>"+deliList[j].GOOD_NAME+"</a></p>";
							str += "<div class='f11'>";
							str += "<p><strong>규&nbsp;&nbsp;&nbsp;&nbsp; 격</strong> : "+deliList[j].GOOD_SPEC+"  </p>";
							str += "<p><strong>공급사</strong> : "+deliList[j].VENDORNM+"</p>";
							str += "</div>";
                            str += "<input type='hidden' id='orde_iden_numb_"+i+"_"+j+"' name='orde_iden_numb_"+i+"'  value='"+list[i].TEMP_ORDE_IDEN_NUMB+"'/>                 ";
                            str += "<input type='hidden' id='purc_iden_numb_"+i+"_"+j+"' name='purc_iden_numb_"+i+"'  value='"+list[i].PURC_IDEN_NUMB+"'/>                 ";
                            str += "<input type='hidden' id='deli_iden_numb_"+i+"_"+j+"' name='deli_iden_numb_"+i+"'  value='"+deliList[j].DELI_IDEN_NUMB+"'/>                 ";
                            str += "<input type='hidden' id='deli_type_clas_code_"+i+"_"+j+"' name='deli_type_clas_code_"+i+"_"+j+"'  value='"+deliList[j].DELI_TYPE_CLAS_CODE+"'/>                 ";
                            str += "<input type='hidden' id='deli_invo_iden_"+i+"_"+j+"' name='deli_invo_iden_"+i+"_"+j+"'  value='"+deliList[j].DELI_INVO_IDEN+"'/>                 ";
							str += "</td>";
							str += "<td class='count'><p>"+fnComma(deliList[j].QUANTITY)+"</p>";
							str += "<p>("+fnComma(deliList[j].SALE_UNIT_PRIC)+")</p></td>";
							str += "<td align='center'>";
							str += 	"<p style='color:red;font-weight:800;''>"+deliList[j].DELI_SCHE_DATE+"</p>";
							str += 	"(<span style='color:red'>"+deliList[j].REQU_DELI_DATE+"</span>)";
							str += "</td>";
							var bgcolor = " style='background-color:papayawhip;' "; 
							str += "<td align='center' " + (list[i].REGI_DATE_TIME?bgcolor:"") +">"+list[i].REGI_DATE_TIME+"</td>";
							str += "<td align='center' " + (deliList[j].PURC_RECE_DATE?bgcolor:"") +">"+deliList[j].PURC_RECE_DATE+"</td>";
							str += "<td align='center' " + (deliList[j].DELI_DEGR_DATE?bgcolor:"") +">"+deliList[j].DELI_DEGR_DATE+"</td>";
							str += "<td align='center' " + (deliList[j].PURC_PROC_DATE?bgcolor:"") +">"+deliList[j].PURC_PROC_DATE+"</td>";
							if(list[i].ORDE_STAT_FLAG >= 60){
								
                            str += "<td align='center' >";
                            str += "    <button class='btn btn-default btn-xs' style='width:80px;' onclick='fnDeliInfoTrace(\""+i+"_"+j+"\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>배송추적</button>";
                            str += "</td>";
                            
							}else if(list[i].ORDE_STAT_FLAG == 59){
								
                            str += "<td align='center'>";
                            str += "<button class='btn btn-darkgray btn-xs' style='width:80px;' onclick='fnCancReqDivPop(\""+list[i].ORDE_IDEN_NUMB+"\",\""+list[i].ORDE_SEQU_NUMB+"\",\""+list[i].PURC_IDEN_NUMB+"\");'>주문취소요청</button>";
                            str += "</td>";
                            
							}else if(list[i].ORDE_STAT_FLAG == 40){
								
                            str += "<td align='center'>";
                            str += "<button class='btn btn-darkgray btn-xs' style='width:80px;' onclick='fnRejectPopupOpen(\""+list[i].ORDE_IDEN_NUMB+"\",\""+list[i].ORDE_SEQU_NUMB+"\",\""+list[i].PURC_IDEN_NUMB+"\");'>주문거부</button>";
                            str += "</td>";
                            
							}else{
								
                            str += "<td align='center'></td>";
                            
							}
						}
						str += "</tr>";
					}
					$("#venOrderProgressTable").append(str);
				}
				//페이징
				fnPager(startPage, endPage, currPage, total, 'fnVenOrderProgressList');	//페이져 호출 함수
				
			}else{
				$("#venOrderProgressTable").append("<tr id='venOrderProgress_0' class='venOrderProgress'><td colspan='8' align='center' class='br_l0'>Data가 존재 하지 않습니다.</td></tr>");
			}
			$.unblockUI();
		},
		"json"
	);
	
}

<%-- 주문거부 팝업 open--%>
function fnRejectPopupOpen(ordeIdenNumb, ordeSequNumb, purcIdenNumb){
	$("#chanReasDesc").val("");	
	$("#popOrderReject").jqmShow();
	$("#ordeIdenNumb").val(ordeIdenNumb);
	$("#ordeSequNumb").val(ordeSequNumb);
	$("#purcIdenNumb").val(purcIdenNumb);
}

<%-- 주문거부 --%>
function fnOrdPurcReceiveReject(){
	var ordeIdenNumb_Array	= new Array();	//주문번호
	var ordeSequNumb_Array	= new Array();	//주문차수
	var purcIdenNumb_Array	= new Array();	//발주차수
	var chanReasDesc_Array	= new Array();	//주문거부
	
	var chanReasDesc = $("#chanReasDesc").val();
	if(chanReasDesc == ""){
		alert("주문거부 사유를 작성해 주세요.");
		return;
	}
	if(!confirm("주문번호 : "+$("#ordeIdenNumb").val()+"-"+$("#ordeSequNumb").val()+"를 주문거부 하시겠습니까?")){
		return;
	}
	ordeIdenNumb_Array[0] = $("#ordeIdenNumb").val();
	ordeSequNumb_Array[0] = $("#ordeSequNumb").val();
	purcIdenNumb_Array[0] = $("#purcIdenNumb").val();
	chanReasDesc_Array[0] = chanReasDesc;
	
	$("#popOrderReject").jqmHide();
	$.post(
		"/venOrder/ordPurcReceiveReject.sys",
		{
			ordeIdenNumb_Array:ordeIdenNumb_Array,
			ordeSequNumb_Array:ordeSequNumb_Array,
			purcIdenNumb_Array:purcIdenNumb_Array,
			chanReasDesc_Array:chanReasDesc_Array
		},
		function(arg){
			var customResponse = arg.customResponse;
			if(customResponse.success == false){
				alert(customResponse.message);
			}else{
				alert("처리 되었습니다.");
				location.reload(true);
			}
		},
		"json"
	);
}


<%-- 검색--%>
function fnSearch(){
	fnVenOrderProgressList(1);
}

<%-- 팝업 닫기 --%>
function fnPopClose(){
	$("#popOrderReject").jqmHide();
}


function fnPopClose2(){
	$("#divPopup2").jqmHide();
    $("#tempCancelId").val("");
    $("#cancReason").html("");
}

function fnCancReqDivPop(ordeIdenNumb, ordeSequNumb, purcIdenNumb){
	$.post(
		"/venOrder/venSelectCancReqInfo.sys",
		{
			ordeIdenNumb:ordeIdenNumb
			,ordeSequNumb:ordeSequNumb
			,purcIdenNumb:purcIdenNumb
		},
		function(arg){
			var data = eval('(' + arg + ')').data;
            $("#tempCancelId").val(data.CANCEL_ID);
            $("#cancReason").html(data.REQ_REASON);
            $("#procReason").val("");
            $("#divPopup2").jqmShow();
		}
	);
}
function fnOrdCancApp(){
	if($.trim($("#procReason").val()).length == 0){
		alert("사유를 입력해주십시오.");
		return false;
	}
	if(!confirm("주문취소요청을 승인처리 하시겠습니까?")){ return; }
	$.blockUI();
	$.post(
		"/venOrder/purcCancProc.sys",
		{
			cancelId:$("#tempCancelId").val()
			,flag:"1"
			,reason:$("#procReason").val()
		},
		function(arg){
			fnPopClose2();
			if($.parseJSON(arg).customResponse.success){
				alert("정상적으로 처리가 되었습니다.");
                fnVenOrderProgressList(1);
			}else{
				alert("처리중 오류가 발생하였습니다.");
			}
			$.unblockUI();
		}
	);
}
function fnOrdCancRej(){
	if(!confirm("주문취소요청을 반려처리 하시겠습니까?")){ return; }
	$.blockUI();
	$.post(
		"/venOrder/purcCancProc.sys",
		{
			cancelId:$("#tempCancelId").val()
			,flag:"9"
			,reason:$("#procReason").val()
		},
		function(arg){
			fnPopClose2();
			if($.parseJSON(arg).customResponse.success){
				alert("정상적으로 처리가 되었습니다.");
                fnVenOrderProgressList(1);
			}else{
				alert("처리중 오류가 발생하였습니다.");
			}
			$.unblockUI();
		}
	);
}


<%-- 택배사 조회 --%>
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
        window.open('<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/clientReceiveDeliInfoPop.sys'+paramString,'배송조회', 'width=500, height=258,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=auto');
    }
}

function fnVenProductDetail(i){
    var ordeIdenNumb = $("#orde_iden_numb_"+i).val()
    var ordeSequNumb = $("#add_repre_sequ_numb_"+i).val()
	fnProductDetailPop(ordeIdenNumb, ordeSequNumb);
}
</script>
</head>

<body class="subBg">
<div id="divWrap">
	<!--header-->
	<%@include file="/WEB-INF/jsp/system/venHeader.jsp" %>
	<!--//header-->
	<hr>
		<div id="divBody">
			<div id="divSub">
				<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
				<!--컨텐츠(S)-->
				<div id="AllContainer">
					<ul class="Tabarea">
						<li class="on">주문진척도 조회</li>
					</ul>
					<div style="position:absolute; right:0; margin-top:-30px;">
						<a href="#" onclick="fnSearch();"><img src="/img/contents/btn_tablesearch.gif" /></a>
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
							<td><input type="text" id="orderNumber" name="orderNumber" style="width:150px;" value=""/></td>
							<th>주문일</th>
							<td>
								<input type="text" id="startDate" name="startDate" style="width:80px;" value="<%=startDate%>"/>
								~
								<input type="text" id="endDate" name="endDate" style="width:80px;" value="<%=endDate%>"/>
							</td>
						</tr>
						<tr>
							<th>상태</th>
							<td colspan="3">
								<select id="srcOrderStatusFlag" name="srcOrderStatusFlag" style="width:130px">
                                    <option value="" selected="selected">전체</option>
                                    <option value="40">주문의뢰</option>
                                    <option value="50">주문접수</option>
                                    <option value="60">배송중</option>
                                    <option value="70">인수완료</option>
                                </select>
							</td>
						</tr>
					</table>
					<div class="ListTable mgt_20">
						<table id="venOrderProgressTable">
							<colgroup>
								<col width="190px" />
								<col width="auto" />
								<col width="90px" />
								<col width="95px" />
								<col width="85px" />
								<col width="85px" />
								<col width="85px" />
								<col width="85px" />
								<col width="80px" />
							</colgroup>
							<tr>
								<th rowspan="2" class="br_l0">주문정보</th>
								<th rowspan="2">주문 상품 정보</th>
								<th rowspan="2">수량<br />(상품금액)</th>
								<th rowspan="2">납품예정일<br />(납품요청일)</th>
								<th colspan="4">주문현황</th>
								<th rowspan="2">비고</th>
							</tr>
							<tr>
								<th>주문일</th>
								<th>주문접수</th>
								<th>배송일</th>
								<th>인수일</th>
							</tr>
						</table>
					</div>
					<div id="pager" class="divPageNum">
					</div>
				</div>
				<!--컨텐츠(E)-->
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
	<hr>
</div>

<div id="popOrderReject" class="jqmPop" title="주문거부" style="font_size: 12px;">
    <div>
        <div id="divPopup" style="width:500px; height: 225px; ">
            <h1 id="divPopupTitle">주문거부
                <a href="#" onclick="fnPopClose();"><img src="/img/contents/btn_close.png"/></a>
            </h1>
            <div class="popcont">
                <table class="InputTable">
                    <colgroup>
                        <col width="100px" />
                        <col width="auto" />
                    </colgroup>
                    <tr>
                        <th>사유</th>
                            <td><textarea id="chanReasDesc" cols="" rows="" style="width:98%; height: 100px;"></textarea></td>
                    </tr>
                </table>
                <div class="Ac mgt_10">
                        <button id='popOrdPurcRejectBtn' class='btn btn-darkgray btn-sm' onclick="fnOrdPurcReceiveReject();">주문거부</button>
                        <button id='popOrdPurcBtn' class='btn btn-default btn-sm' onclick="fnPopClose()">닫기</button>
                </div>
            </div>
        </div>
    </div>
</div>


<div id="divPopup2" class="popOrderCancReqReject" style="width:500px; height: 240px; ">
	<h1 id="divPopupTitle">주문취소 요청 처리
		<a href="#" onclick="fnPopClose2();"><img src="/img/contents/btn_close.png"/></a>
	</h1>
	<input type="hidden" id="tempCancelId" value=""/>
	<div class="popcont2">
		<table class="InputTable">
			<colgroup>
				<col width="100px" />
				<col width="auto" />
			</colgroup>
			<tr>
				<th>취소요청사유</th>
				<td><span id="cancReason"></span></td>
			</tr>
			<tr>
				<th>처리 사유</th>
				<td><textarea id="procReason" cols="" rows="" style="width:98%; height: 100px;"></textarea></td>
			</tr>
		</table>
		<div class="Ac mgt_10">
				<button id='popOrdApp' class='btn btn-darkgray btn-sm' onclick="fnOrdCancApp();">승인</button>
				<button id='popOrdRej' class='btn btn-darkgray btn-sm' onclick="fnOrdCancRej();">반려</button>
				<button id='popOrdPurcBtn' class='btn btn-default btn-sm' onclick="fnPopClose2()">닫기</button>
		</div>
	</div>
</div>


<form onsubmit="return false;">
	<input type="hidden" id="ordeIdenNumb" name="ordeIdenNumb" value=""/>
	<input type="hidden" id="ordeSequNumb" name="ordeSequNumb" value=""/>
	<input type="hidden" id="purcIdenNumb" name="purcIdenNumb" value=""/>
</form>
</body>
<%@ include file="/WEB-INF/jsp/product/product/venProductDetailPop.jsp" %>
</html>