<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%
	String srcPurcStartDate = CommonUtils.nvl((String)request.getAttribute("srcPurcStartDate"), CommonUtils.getCustomDay("MONTH", -2)) ;
	String srcPurcEndDate = CommonUtils.nvl((String)request.getAttribute("srcPurcEndDate"), CommonUtils.getCurrentDate()) ;
	
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	@SuppressWarnings("unchecked")	// 배송유형
	List<CodesDto> deliveryType = (List<CodesDto>)request.getAttribute("deliveryType");
	
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
	<input type="hidden" id="trimSuccessMassage" value=""/>
	<hr>
	<div id="divBody">
		<div id="divSub">
			<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeVen.jsp" flush="false" />
			<div id="AllContainer">                    
				<ul class="Tabarea">
					<li class="on">배송처리 정보 조회</li>
				</ul>
				<div style="position:absolute; right:0; margin-top:-30px;">
					<a href="javascript:void(0);">
						<img src="/img/contents/btn_excelDN.gif" id="allExcelButton" />
					</a>
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
						<th>구매사명</th>
						<td>
							<input type="text" style="width:200px;" id="srcBranchNm"/>
						</td>
					</tr>
					<tr>
						<th>주문접수일</th>
						<td >
							<input type="text" id="srcPurcStartDate" style="width:80px;" value="<%=srcPurcStartDate%>"/>
							~
							<input type="text" id="srcPurcEndDate" style="width:80px;" value="<%=srcPurcEndDate%>"/>
						</td>
						<th>상품명</th>
						<td >
							<input type="text" style="width:200px;"  id="srcGoodName"/>
						</td>
					</tr>
				</table>
				<div class="Ar mgt_20">
					* 인수증이 출력된 정보는 색깔이 표시됩니다.
					<button id='btnTempDeliSave' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-floppy-o"></i> 임시저장</button>
					<button id='btnSelectedDeliDiv' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-check-square-o"></i> 송장일괄 입력</button>
					<button id='btnDeliInfoSave' class="btn btn-darkgray btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-floppy-o"></i> 배송처리</button>
					<button id='btnBeforeRecePrint' class="btn btn-info btn-xs" ><i class="fa fa-print"></i> 인수증출력</button>
					<div class="ListTable mgt_5">
						<table id="venOrdTable">
							<colgroup>
								<col width="50px" />
								<col width="180px" />
								<col width="100px" />
								<col width="auto" />
								<col width="100px" />
								<col width="210px" />
								<col width="150px" />
							</colgroup>
							<tr>
								<th class="br_l0">
									<input type="checkbox" name="chkAllOutputField" id="chkAllOutputField" onclick='javascript:allCheckBoxCtl(event);'/>
									<label for="checkbox"></label>
								</th>
								<th>주문정보</th>
								<th>
									<p>납품예정일</p>
									<p>(납품요청일)</p>
								</th>
								<th> 주문 상품 정보</th>
								<th>
									<p>주문수량</p>
									<p>(배송수량)</p>
								</th>
								<th>배송정보</th>
								<th>기타요청사항</th>
							</tr>
						</table>
					</div>
					<div class="divPageNum" id="pager"></div>
				</div>
			</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeVen.jsp"  flush="false" />
		</div>
		<hr>
	</div>
	<div id="RegiDeliNum" class="jqmPop" title="송장일괄입력" style="font_size: 12px;">
		<div>
			<div id="divPopup"  style="width:400px;">
				<div id="RegiDeliNumDrag">
					<h1>송장일괄입력<a href="javascript:void(0);"><img id="RegiDeliNumCloseButton" src="/img/contents/btn_close.png"></a></h1>
				</div>		  		
				<div class="popcont">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="2" class="table_top_line"></td>
						</tr>
						<tr>
							<td class='stit'>택배사</td>
							<td>
								<select id="deli_type_clas" name="deli_type_clas">
									<option value='0'>선택</option>
<%
	if(deliveryType.size() > 0){
		CodesDto cdData = null;
		
		for(int i = 0; i < deliveryType.size(); i++){
			cdData = deliveryType.get(i);
%>
									<option value='<%=cdData.getCodeVal1()%>'><%=cdData.getCodeNm1()%></option>
<%
		}
	}
%>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="height: 10px;"></td>
						</tr>
						<tr>
							<td class='stit'>송장(전화)번호</td>
							<td>
								<input id="deli_invo_iden" name="deli_invo_iden" type="text" maxlength="15" style="width: 80%"/>
							</td>
						</tr>
						<tr>
							<td colspan="2" height="20">&nbsp;</td>
						</tr>
						<tr>
							<td align="center" colspan="2">
								<button id='divDeliBtn' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">입력</button>
							</td>
						</tr>
					</table>
				</div>
			</div>    	
		</div>
	</div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/product/product/venProductDetailPop.jsp" %>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
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
    
    
	$("#srcPurcStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcPurcEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/contents/btn_calenda.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); 
    
    $("#btnSearch").click(function(){
        venDeliProcList();
    });
    
    $("#allExcelButton").click(function(){
    	fnAllExcelPrintDown();
    });
    
   $("#srcOrdeIdenNumb").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcBranchNm").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcPurcStartDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcPurcEndDate").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   $("#srcGoodName").keydown(function(e) { if(e.keyCode==13) { $("#btnSearch").click(); } });
   
    venDeliProcList();
    
	$("#btnSelectedDeliDiv").click(function(){ 
		div_deli_nums();
	});
	$("#divDeliBtn").click(function(){ 
		regi_deli_nums();
	});
	
	$("#btnTempDeliSave").click(function(){ 
		deliTempSave();
	});
	
	$("#btnDeliInfoSave").click(function(){ 
		processDelivery();
	});
	
	$("#btnBeforeRecePrint").click(function(){ 
		beforeRecePrint();
	});
	
	$("#RegiDeliNumCloseButton").click(function(){$("#RegiDeliNum").jqmHide();});
	$('#RegiDeliNum').jqm().jqDrag('#RegiDeliNumDrag');
});

function deliTempSave(){
	var temp_to_do_deli_prod_quan_array = new Array();
	var to_do_deli_prod_quan_array = new Array();
	var tempErrorProd_array =  new Array();
	var rowCnt = $("[name=receCbox]").length;
    var arrRowIdx = 0 ;
	if(rowCnt>0) {
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
            	var temp1 = $.trim($("#temp_to_do_deli_prod_quan_"+$("#"+$("[name=receCbox]")[i].id).val()).val());
            	var temp2 = $.trim($("#to_do_deli_prod_quan_"+$("#"+$("[name=receCbox]")[i].id).val()).val());
				if(temp1 == temp2 || temp2 == 0){
					tempErrorProd_array[tempErrorProd_array.length] = $("#orde_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val();
				}
			    temp_to_do_deli_prod_quan_array[arrRowIdx] = temp1;
			    to_do_deli_prod_quan_array[arrRowIdx] =	 temp2
			    arrRowIdx++;
			}
		}
	}
	if(tempErrorProd_array.length > 0){
		var errorMsgTemp = "";
		for(var i =0; i < tempErrorProd_array.length; i++){
			if(i == 0){
				errorMsgTemp = "["+tempErrorProd_array[i]+"]"
			}else{
				errorMsgTemp += ", ["+tempErrorProd_array[i]+"]"
			}
		}
		errorMsgTemp += "\n위 주문번호는 배송수량을 확인하여주십시오.";
		alert(errorMsgTemp);
		return;
	}
    if (arrRowIdx == 0 ) {
        alert("배송처리 할 주문정보를 선택해주십시오.");
        return; 
    }
    confirmMessage("선택된 주문 정보를 임시저장 하시겠습니까?", processDeliTempSave);
}
function processDeliTempSave(){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var to_do_deli_prod_quan_array = new Array();
	var rowCnt = $("[name=receCbox]").length;
    var arrRowIdx = 0 ;
	if(rowCnt>0) {
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
			    orde_iden_numb_array[arrRowIdx] = $("#orde_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val();
			    purc_iden_numb_array[arrRowIdx] =	 $("#purc_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val();
			    to_do_deli_prod_quan_array[arrRowIdx] =	 $.trim($("#to_do_deli_prod_quan_"+$("#"+$("[name=receCbox]")[i].id).val()).val());
			    arrRowIdx++;
			}
		}
	}
	$.blockUI();
	$.post(
        "/venOrder/tempDeliSave.sys",
        {
            orde_iden_numb_array:orde_iden_numb_array,
            purc_iden_numb_array:purc_iden_numb_array,
            to_do_deli_prod_quan_array:to_do_deli_prod_quan_array
        },
        function(arg){
			if($.parseJSON(arg).customResponse.success){
				alert("처리가 완료되었습니다.");
				venDeliProcList();
			}else{
				var errorMsg = "";
				for(var i =0; i < $.parseJSON(arg).customResponse.message.length;i++){
					if(i==0){
                        errorMsg = $.parseJSON(arg).customResponse.message[i];
					}else{
                        errorMsg += "\n"+$.parseJSON(arg).customResponse.message[i];
					}
				}
				alert(errorMsg);
			}
            $.unblockUI();
        }
	);
}

function fnAllExcelPrintDown(){
	var colLabels             = ['주문번호',	'납품예정일',	'상품명',	'주문수량',	'배송지정보', '기타요청사항', '추가구성정보'];
	var colIds                = ['orde_iden_numb', 'deli_sche_date', 'good_name', 'to_do_deli_prod_quan', 'tran_data_addr','adde_text_desc','add_prod'];
	var numColIds             = ['to_do_deli_prod_quan'];	//숫자표현ID
	var sheetTitle            = "배송처리 정보조회";	//sheet 타이틀
	var excelFileName         = "deliProcList";	//file 명
	var fieldSearchParamArray = new Array();     //파라메타 변수ID
	
	fieldSearchParamArray[0] = 'srcBranchNm';
	fieldSearchParamArray[1] = 'srcOrdeIdenNumb';
	fieldSearchParamArray[2] = 'srcPurcStartDate';
	fieldSearchParamArray[3] = 'srcPurcEndDate';
	fieldSearchParamArray[4] = 'srcGoodName';
		
	fnExportExcelToSvc( "" , colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/venOrder/deliProcExcel.sys");  
}

function venDeliProcListClear(){
	var length = $(".trData").length;
    if(length > 0){
        for(var i=0; i<length; i++){
            $("#trData_"+i).remove();
        }
    }
    $("#pager").empty();
}

function venDeliProcList(page){
	var srcBranchNm		    = $("#srcBranchNm").val() ;
	var srcOrdeIdenNumb		= $("#srcOrdeIdenNumb").val() ;
	var srcPurcStartDate	= $("#srcPurcStartDate").val() ;
	var srcPurcEndDate		= $("#srcPurcEndDate").val() ;
	var srcGoodName  		= $("#srcGoodName").val() ;
	
	venDeliProcListClear();
	
	$.blockUI();
	$.post(
		"/venOrder/deliProcQGrid.sys",
		{
			srcOrdeIdenNumb:srcOrdeIdenNumb,
			srcPurcStartDate:srcPurcStartDate,
			srcPurcEndDate:srcPurcEndDate,
			srcBranchNm:srcBranchNm,
			srcGoodName:srcGoodName,
			page:page,
			rows:10
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
					var str = "";
                    str += "<tr class='trData' id='trData_"+i+"'>                                                          ";
                    var tmpColor = "";
                    if($.trim(list[i].isPurcPrint) == "Y"  ){
                        tmpColor = "style=\"background-color:skyblue;\"";
                    }
                    str += "    <td align=\"center\" class=\"br_l0\" "+tmpColor+"   id='tdData_"+i+"' >";
                    if($.trim(list[i].is_add_mst) == "Y" &&  $.trim(list[i].add_receive_yn) == "N" ){
                    }else{
                    str += "   	<input type='checkbox' name='receCbox' id='receCbox_"+i+"' value='"+i+"' /> ";
                    }
                    str += "   	<input type='hidden' id='orde_iden_numb_"+i+"' name='orde_iden_numb_"+i+"' value='"+list[i].orde_iden_numb+"'/> ";
                    str += "   	<input type='hidden' id='purc_iden_numb_"+i+"' name='purc_iden_numb_"+i+"' value='"+list[i].purc_iden_numb+"'/>  ";
                    str += "   	<input type='hidden' id='vendorId_"+i+"' name='vendorId_"+i+"' value='"+list[i].vendorId+"'/>  ";
                    str += "   	<input type='hidden' id='temp_orde_iden_numb_"+i+"' name='temp_orde_iden_numb_"+i+"' value='"+list[i].temp_orde_iden_numb+"'/>  ";
                    str += "   	<input type='hidden' id='add_repre_sequ_numb_"+i+"' name='add_repre_sequ_numb_"+i+"' value='"+list[i].add_repre_sequ_numb+"'/>  ";
                    str += "   	<input type='hidden' id='mst_orde_sequ_numb_"+i+"' name='mst_orde_sequ_numb_"+i+"' value='"+list[i].mst_orde_sequ_numb+"'/>  ";
                    str += "    </td>                                                                                                            ";
                    str += "    <td align=\"left\" >                                                                                                             ";
                    str += "    	<p>";
                    str += 				"<a href=\"javascript:fnOrderDetailView('" + list[i].orde_iden_numb + "', '', '" + list[i].purc_iden_numb + "')\">";
                    str += 					list[i].orde_iden_numb;
                    str +=				"</a>                                                                       ";
                    str +=			"</p>                                                                       ";
                    str += "        <div >                                                                                            ";
                    str += "            <p><strong>구매사</strong>&nbsp;&nbsp;&nbsp;&nbsp;: "+list[i].orde_client_name+"</p>                                                                  ";
                    str += "            <p><strong>주문일</strong> : "+list[i].regi_date_time+"</p>                                                                ";
                    str += "            <p><strong>주문유형 </strong>: "+list[i].orde_type_clas;
					if(list[i].add_repre_sequ_numb != "0"){
						
                    str += "    		  <button class='btn btn-darkgray btn-xs' onclick='fnVenProductDetail(\""+i+"\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>추가</button>";
                    str += "            </p>";
                    
					}else if(list[i].mst_orde_sequ_numb != "" && list[i].mst_orde_sequ_numb != "0"){
                    str += "    		  <button class='btn btn-darkgray btn-xs' onclick='fnVenProductMstDetail(\""+i+"\");' <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>추가</button>";
                    str += "            </p>";
                    
					}else{
                    str += "            </p>";
					}
                    str += "        </div>                                                                                                       ";
                    str += "    </td>                                                                                                            ";
                    str += "    <td align=\"center\">                                                                                              ";
                    str += "        <p style='font-weight:800; color:red;'>"+list[i].deli_sche_date+"</p>                                                                                            ";
                    str += "        (<span  style='color:red;'>"+list[i].requ_deli_date+"</span>)";
                    str += "    </td>                                                                                                            ";
                    str += "    <td align=\"left\" >                                                                                                             ";
                    str += "        <p><a href='javascript:fnPdtSimpleDetailPop(\""+list[i].good_iden_numb+"\");"+"'>"+list[i].good_name+"</a></p>                                                                          ";
                    str += "        <div class=\"f11\">                                                                                            ";
                    str += "            <p><strong>규격</strong> : "+list[i].good_spec_desc+"</p>                                                        ";
                    str += "            <p><strong>단가 </strong>: "+fnComma(list[i].sale_unit_pric)+"원</p>                                                                     ";
                    str += "        </div>                                                                                                       ";
                    str += "    </td>                                                                                                            ";
                    str += "    <td align=\"right\">                                                                                               ";
                    str += "       <input type=\"hidden\" style=\"width:50px;\" class=\"Ar\" id=\"temp_to_do_deli_prod_quan_"+i+"\"  value=\""+list[i].to_do_deli_prod_quan+"\" /> </p>                                                 ";
                    str += "    	<p>"+fnComma(list[i].purc_requ_quan)+"</p>                                                                                                   ";
					if($.trim(list[i].add_receive_yn) !=""){
                    str += "       <p> <input type=\"text\" style=\"width:50px; background-color: #eeeeee;\" class=\"Ar\" id=\"to_do_deli_prod_quan_"+i+"\"  value=\""+list[i].to_do_deli_prod_quan+"\" readonly='true' /> </p>";
					}else{
                    str += "       <p> <input type=\"text\" style=\"width:50px;\" class=\"Ar\" id=\"to_do_deli_prod_quan_"+i+"\"  value=\""+list[i].to_do_deli_prod_quan+"\"   onkeydown=\"javascript:fnInputTextKeyDown('"+i+"');\" /> </p> ";
					}
                    str += "    </td>                                                                                                            ";
                    str += "    <td align='left'>                                                                                                             ";
                    str += "        <p>                                                                                                          ";
                    str += "        <strong>배송유형 &nbsp;&nbsp;:</strong>                                                                                      ";
                    str += "        <select name=\"deli_type_clas_"+i+"\" id=\"deli_type_clas_"+i+"\" style=\"width:135px;\"  onchange=\"javascript:fnSelectBoxChanged('"+i+"');\">                                                       ";
                    str += "            <option value=\"\">선택</option>                                                                                      ";
<%
	if (deliveryType.size() > 0 ) {
		CodesDto cdData = null;
		
		for (int i = 0; i < deliveryType.size(); i++) {
			cdData = deliveryType.get(i);
%>
                    str += "            <option value=\"<%=cdData.getCodeVal1()%>\"><%=cdData.getCodeNm1()%></option>                                                                                      ";

<%
		}
	}
%>
                    str += "        </select>                                                                                                    ";
                    str += "        </p>                                                                                                         ";
                    str += "        <p class=\"mgt_5\"><strong>송장(전화) :</strong> <input type=\"text\" style=\"width:125px;\" class=\"Ar\" name=\"deli_invo_iden_"+i+"\" id=\"deli_invo_iden_"+i+"\" value=\""+list[i].deli_invo_iden+"\"  onkeydown=\"javascript:fnInputTextKeyDown('"+i+"');\"/></p>           ";
                    str += "        <p class=\"mgt_5\"><strong>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고 :</strong> <textarea style=\"width:68%;\" name=\"deli_desc_"+i+"\" id=\"deli_desc_"+i+"\" value=\"\" /></p>           ";
                    str += "        <p class=\"mgt_5\" style=\"text-align:right;\"><button id='srcCallDeliInfoPop' title='"+list[i].tran_data_addr+"' class=\"btn btn-darkgray btn-xs\" onclick=\"javascript:fnVenDeliInfoPop('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>배송지정보</button> </p>                                                                                 ";

                    str += "    </td>                                                                                                            ";
                    str += "    <td align='left'>";
                    if($.trim(list[i].add_prod_prefix) != ""){
                    var tmpMstNm = "";
//                     var tmpMstNm = list[i].mst_good_name != "" ? "<br/>("+list[i].mst_good_name+")" : "";
                    str += "<br/><font color='red'><b>"+list[i].add_prod_prefix+list[i].add_prod_vendornm+"</b></font><font color='gray'>"+tmpMstNm+"</font>";
                    
                    }
                    if($.trim(list[i].is_add_mst) == "Y" &&  $.trim(list[i].add_receive_yn) == "N"){
                    	if($.trim(list[i].sub_add_receive_yn) == "Y"){
                    str += "<br/><button id='btnAddProdReceive' class=\"btn btn-darkgray btn-xs\" onclick=\"javascript:fnAddProdReceive('"+i+"');\" <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>>인수</button>";
                    	}

                    }
                    str += "    </td>";
                    str += "</tr>";
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

function allCheckBoxCtl(){
	var rowCnt = $("[name=receCbox]").length;
    if(rowCnt>0) {
        for(var i=0; i<rowCnt; i++) {
            if($("#chkAllOutputField").is(':checked')) {
                if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == false){
                    $("#"+$("[name=receCbox]")[i].id).attr("checked", "checked");
                }
            }else{
                if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
                    $("#"+$("[name=receCbox]")[i].id).attr("checked", false);
                }
            }
        }
    }
}

//송장번호일괄입력DIV
var sel_id_array ; // #list의 선택된 rowid 배열 담기
var deli_invo_rowid; // #list의 선택된 rowid 담기
var divFlag; // 0:송장번호 일괄입력, 1: 송정번호 수정

function div_deli_nums(){
	var rowCnt = $("[name=receCbox]").length;
	sel_id_array = new Array();
	if(rowCnt == 0){
		return;
	}
	for(var i = 0; i < rowCnt; i++){
        if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
			sel_id_array[sel_id_array.length] = $("#"+$("[name=receCbox]")[i].id).val();
        }
	}
	if(sel_id_array.length == 0){ //선택된 row가 없는 경우
		alert("처리할 데이터를 선택 하십시오!");
		return;
	}
	deli_invo_rowid = null;
	divFlag         = 0; 
 	regiDeliNumOpen(); //div 띄우기
}





//송장번호변경 DIV 띄우기 
function regiDeliNumOpen(){
	$('#RegiDeliNum').jqmShow();
	$("#deli_invo_iden").val('');
	$("#deli_type_clas > option[value=0]").attr("selected",true);
}

//송장번호일괄입력
function regi_deli_nums(){
	var deli_type_clas = $("#deli_type_clas option:selected").val();
	var deli_invo_iden = $("#deli_invo_iden").val();
	
	if(deli_type_clas==0 || deli_invo_iden==""){
		alert("택배사 또는 송장번호의 데이터가 없습니다");
		return;
	}
    for(var i=0; i<sel_id_array.length ; i++){
        var rowId = sel_id_array[i];
        $("#deli_type_clas_"+rowId+" > option[value="+deli_type_clas+"]").attr("selected",true);
        $("#deli_invo_iden_"+rowId+"").val(deli_invo_iden);
    }
	$("#deli_invo_iden").val("");
	$("#RegiDeliNum").jqmHide();
}

function fnInputTextKeyDown(index){
    $("#receCbox_"+index).attr("checked", "checked");
}
function fnSelectBoxChanged(index){
    $("#receCbox_"+index).attr("checked", "checked");
}

function processDelivery(){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var to_do_deli_prod_quan_array = new Array();
	var vendorIdArray = new Array();
	var deliveryType_array = new Array();
	var deliveryNumber_array = new Array();
	var deliDesc_array = new Array();
	var rowCnt = $("[name=receCbox]").length;
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
            	
         		if("" == $.trim($("#to_do_deli_prod_quan_"+$("#"+$("[name=receCbox]")[i].id).val()).val())){
         			alert("주문번호["+$("#orde_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val()+"] 의 배송처리 할 수량을 입력해주십시오.");
         			return;
         		}
         		
         		if(Number($.trim($("#temp_to_do_deli_prod_quan_"+$("#"+$("[name=receCbox]")[i].id).val()).val())) < Number($.trim($("#to_do_deli_prod_quan_"+$("#"+$("[name=receCbox]")[i].id).val()).val())) ){
         			alert("주문번호["+$("#orde_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val()+"] 의 최대 배송수량은 "+Number($.trim($("#temp_to_do_deli_prod_quan_"+$("#"+$("[name=receCbox]")[i].id).val()).val()))+"입니다.");
         			return;
         		}
         		
         		if("" == $.trim($("#deli_type_clas_"+$("#"+$("[name=receCbox]")[i].id).val()).val()) || "0" == Number($("#deli_type_clas_"+$("#"+$("[name=receCbox]")[i].id).val()).val()) ){
      				alert("택배사를 선택해주십시오.");
      				return;
      			}
				
         		if("" == $.trim($("#deli_invo_iden_"+$("#"+$("[name=receCbox]")[i].id).val()).val()) || "0" == Number($("#deli_invo_iden_"+$("#"+$("[name=receCbox]")[i].id).val()).val()) ){
      				alert("송장번호를 입력하여주십시오.");
      				return;
      			}
         		
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			alert("배송처리 할 주문정보를 선택해주십시오.");
			return; 
		}
		
		confirmMessage("선택된 주문 정보를 배송처리 하시겠습니까?", processDeliveryCallback);
	}
}

function processDeliveryCallback(){
	var orde_iden_numb_array = new Array(); 
	var purc_iden_numb_array = new Array();
	var to_do_deli_prod_quan_array = new Array();
	var vendorIdArray = new Array();
	var deliveryType_array = new Array();
	var deliveryNumber_array = new Array();
	var deliDesc_array = new Array();
	var rowCnt = $("[name=receCbox]").length;
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
			    orde_iden_numb_array[arrRowIdx] = $("#orde_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val();
			    purc_iden_numb_array[arrRowIdx] =	 $("#purc_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val();
         		
			    to_do_deli_prod_quan_array[arrRowIdx] =	 $.trim($("#to_do_deli_prod_quan_"+$("#"+$("[name=receCbox]")[i].id).val()).val());
			    vendorIdArray[arrRowIdx] =	 $.trim($("#vendorId_"+$("#"+$("[name=receCbox]")[i].id).val()).val());
			    deliveryType_array[arrRowIdx] =	 $.trim($("#deli_type_clas_"+$("#"+$("[name=receCbox]")[i].id).val()).val());
			    deliveryNumber_array[arrRowIdx] = $.trim($("#deli_invo_iden_"+$("#"+$("[name=receCbox]")[i].id).val()).val());
			    
			    deliDesc_array[arrRowIdx] = $.trim($("#deli_desc_"+$("#"+$("[name=receCbox]")[i].id).val()).val());
			    
			    arrRowIdx++;
			}
		}
		
        $.blockUI();
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/comOrd/getOrderStatus.sys", 
			{ 
				orde_iden_numb_array:orde_iden_numb_array, 
				purc_iden_numb_array:purc_iden_numb_array, 
				prod_quan_array:to_do_deli_prod_quan_array, 
				orde_stat_flag:'50' 
			},
			function(arg){ 
				if($.parseJSON(arg).customResponse.success){
					$.post(
						"<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/insertDeliProc.sys",
						{  
                                orde_iden_numb_array:orde_iden_numb_array
                             , purc_iden_numb_array:purc_iden_numb_array
                             , to_do_deli_prod_quan_array:to_do_deli_prod_quan_array
                             , vendorIdArray:vendorIdArray
                             , deliveryType_array:deliveryType_array
                             , deliveryNumber_array:deliveryNumber_array
                             , deliDesc_array:deliDesc_array
						},
						function(arg2){
			            	var result = $.parseJSON(arg2).customResponse;
			            	if (result.success == false) {
			                  	var errors = "";
			            		for (var i = 0; i < result.message.length; i++) {
			            			errors +=  result.message[i] + "<br/>";
			            		}
			            		alert(errors);
			            	} else {
			            		var successMassage = "";
			            		for (var i = 0; i < result.message.length; i++) {
			            			successMassage +=  result.message[i];
			            		}
			            		var trim_successMassage = $.trim(successMassage);
			                  	if(trim_successMassage !=''){
			                  		$("#trimSuccessMassage").val(trim_successMassage);
			                  		
			                  		confirmMessage("인수증을 출력 하시겠습니까?", fnTrimSuccessMassageCallback);
			                  	}
			            	}
                            venDeliProcList();
                            $.unblockUI();
						}
					);
				} else {
					alert("처리중 오류가 발생했습니다.\n입력하신 정보를 다시 확인해주십시오.");
                    venDeliProcList();
                    $.unblockUI();
				}
			}
		);
	}
}

function fnTrimSuccessMassageCallback(){
	var trim_successMassage = $("#trimSuccessMassage").val();
	
	if(trim_successMassage.length == 1){
  		fnOpen(trim_successMassage,0);
  	}
	else{
  		var receiptNumArry = trim_successMassage.split(",");
  		
  		for(var k = 0 ; k < receiptNumArry.length; k++){
      		fnOpen(receiptNumArry[k],k);
  		}
  	}
}

function fnVenDeliInfoPop(index){
    var orde_iden_numb = $("#orde_iden_numb_"+index).val();
    var paramString = "?orde_iden_numb="+orde_iden_numb+"";
    var scrSizeHeight = 0;
    scrSizeHeight = screen.height;
    var windowLeft = (screen.width-900)/2;
    var windowTop = (screen.height-700)/2;
    window.open('<%=Constances.SYSTEM_CONTEXT_PATH %>/venOrder/venReceiveDeliInfoPop.sys'+paramString,'배송지정보', 'width=500, height=285,left='+windowLeft+',top='+windowTop+',resizable=yes,menubar=no,status=no,scrollbars=auto');
}


function fnVenProductDetail(i){
    var ordeIdenNumb = $("#temp_orde_iden_numb_"+i).val();
    var ordeSequNumb = $("#add_repre_sequ_numb_"+i).val();
	fnProductDetailPop(ordeIdenNumb, ordeSequNumb);
}

function fnVenProductMstDetail(i){
    var ordeIdenNumb = $("#temp_orde_iden_numb_"+i).val();
    var ordeSequNumb = $("#mst_orde_sequ_numb_"+i).val();
	fnProductDetailPop(ordeIdenNumb, ordeSequNumb);
}

var reciveIndex = null;

function fnAddProdReceive(i){
	reciveIndex = i;
	
	confirmMessage("추가상품을 인수처리 하시겠습니까?", fnAddProdReceiveCallback);
}

function fnAddProdReceiveCallback(){
	$.post(
		"/venOrder/venAddProdReceive.sys",
		{
			orde_iden_numb:$("#orde_iden_numb_"+reciveIndex).val()
			,purc_iden_numb:$("#purc_iden_numb_"+reciveIndex).val()
		},
		function(arg){
			if($.parseJSON(arg).customResponse.success){
				alert("처리가 완료되었습니다.");
				venDeliProcList();
			}else{
				alert("처리중 오류가 발생하였습니다.");
			}
		}
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
</script>
<%-- 인수증 출력 관련 스크립트 시작 --%>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script language="JavaScript">
function fnOpen(receiptNum, i) {
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "receivePrint"; // reb 파일이름
	oReport.param("receipt_num").value = receiptNum; // 매개변수 세팅
	oReport.title = "인수증"; // 제목 세팅
	oReport.open();
}

function beforeRecePrint(receiptNum, i) {
	var rowCnt = $("[name=receCbox]").length;
	var arrRowIdx = 0 ;
	var mst_orde_iden_numb_arr = new Array();
	var orde_sequ_purt_arr = new Array();
	
	var orde_iden_numb_arr = new Array();
	if(rowCnt>0) {
		for(var i=0; i<rowCnt; i++) {
            if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
            	var orde_iden_numb_temp = $("#orde_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val();
            	var orde_iden_numb = orde_iden_numb_temp.split("-")[0];
                orde_iden_numb_arr[orde_iden_numb_arr.length] = orde_iden_numb;
                arrRowIdx++;
            }
		}
	}	
    if (arrRowIdx == 0 ) {
        alert("배송처리 할 주문정보를 선택해주십시오.");
        return; 
    }
    
	$.blockUI();
    <%-- 중복제거 --%>
    $.each(orde_iden_numb_arr, function(i, el){
    	if($.inArray(el, mst_orde_iden_numb_arr) === -1) mst_orde_iden_numb_arr.push(el);
    });
    for(var i=0; i<rowCnt; i++) {
        if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
            var orde_iden_numb_temp = $("#orde_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val();
            var orde_iden_numb = orde_iden_numb_temp.split("-")[0];
            for(var j = 0; j < mst_orde_iden_numb_arr.length ; j++){
            	if(orde_iden_numb == mst_orde_iden_numb_arr[j]){
                    purc_iden_numb_temp =	 $("#purc_iden_numb_"+$("#"+$("[name=receCbox]")[i].id).val()).val();
                    <%-- 주문번호-주문차수-발주차수 형태로  --%>
                    if(orde_sequ_purt_arr[j] == null){
                        orde_sequ_purt_arr[j] = "'"+orde_iden_numb_temp+"-"+purc_iden_numb_temp+"'";
                    }else{
                        orde_sequ_purt_arr[j] += ",'"+orde_iden_numb_temp+"-"+purc_iden_numb_temp+"'";
                    }
            	}
            }
        }
    }
    
	$.post(
		"/venOrder/updateIsPurcPrint.sys",
		{
			orde_sequ_purt_arr:orde_sequ_purt_arr
		},
		function(arg){
			if($.parseJSON(arg).customResponse.success){
                for(var i=0; i<rowCnt; i++) {
                    if( $("#"+$("[name=receCbox]")[i].id).is(':checked') == true){
                    	var index = $("#"+$("[name=receCbox]")[i].id).val();
                        $("#tdData_"+index).css("background-color","skyblue");
                    }
                }
                for(var i = 0; i < mst_orde_iden_numb_arr.length; i++){
                    fnBeforeOpen(mst_orde_iden_numb_arr[i], orde_sequ_purt_arr[i], i);
                }
			}else{
				alert("처리중 오류가 발생하였습니다.");
			}
			$.unblockUI();
		}
	);
	
}
function fnBeforeOpen(mst, sub , i) {
// alert( i+"번째 mst 정보 : "+ mst +" , 서브리스트 : "+sub);
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "beforeReceivePrint"; // reb 파일이름
	oReport.param("mst_orde_iden_numb").value = mst; // 매개변수 세팅
	oReport.param("orde_sequ_purt_arr").value = sub; // 매개변수 세팅
	oReport.param("vendorid").value = '<%=loginUserDto.getBorgId()%>'; // 매개변수 세팅
	oReport.title = "인수증"; // 제목 세팅
	oReport.open();
}


</script>
<%-- 인수증 출력 관련 스크립트 끝 --%>
</html>