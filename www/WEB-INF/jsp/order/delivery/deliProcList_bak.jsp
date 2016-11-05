<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-255 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   
	@SuppressWarnings("unchecked")	// 주문유형
	List<CodesDto> orderTypeCode = (List<CodesDto>)request.getAttribute("orderTypeCode");
	
	@SuppressWarnings("unchecked")	// 택배사
	List<CodesDto> deliveryType = (List<CodesDto>)request.getAttribute("deliveryType");
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	@SuppressWarnings("unchecked")	
	List<SmpUsersDto> workInfoList = (List<SmpUsersDto>)request.getAttribute("workInfoList");
    
    boolean isClient = loginUserDto.getSvcTypeCd().equals("BUY") ? true : false;
    boolean isVendor = loginUserDto.getSvcTypeCd().equals("VEN") ? true : false;
    boolean isAdm = loginUserDto.getSvcTypeCd().equals("ADM") ? true : false;
	// 날짜 세팅
	String srcPurcStartDate = CommonUtils.getCustomDay("MONTH", -1);
	String srcPurcEndDate = CommonUtils.getCurrentDate();
   
	String selBoxDeliType = "0:선택";
	if (deliveryType.size() > 0 ) {
		CodesDto cdData = null;
		for (int i = 0; i < deliveryType.size(); i++) {
			cdData = deliveryType.get(i); 
			selBoxDeliType += ";"+cdData.getCodeVal1()+":"+cdData.getCodeNm1(); 
		}
	}
	boolean isShow = false;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
</head>
<body>
<form id="frm" name="frm" onsubmit="return false;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="29" class='ptitle'>2.배송처리
							</td>
							<td align="right" class='ptitle'>
                                <button id='srcButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
							</td>
						</tr>
					</table> <!-- 타이틀 끝 -->
				</td>
			</tr>
			<tr>
				<td>
					<!-- 컨텐츠 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr> 
						<tr>
							<td class="table_td_subject" width="100">공급사</td>
							<td class="table_td_contents">
								<input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" style="width: 150px" />&nbsp;<img id="btnVendor" src="/img/system/btn_icon_search.gif" width="20" height="18"  style="vertical-align: middle; cursor: pointer;" /><input type="hidden" id="srcVendorId" name="srcVendorId" value=""/></td>
							<td width="100" class="table_td_subject">발주접수일자</td>
							<td class="table_td_contents">
								<input type="text" name="srcPurcStartDate" id="srcPurcStartDate" style="width: 75px;vertical-align: middle;" /> 
								~ 
								<input type="text" name="srcPurcEndDate" id="srcPurcEndDate" style="width: 75px;vertical-align: middle;" />
							</td>
							<td width="100" class="table_td_subject">주문번호</td>
							<td class="table_td_contents"><input id="srcOrdeIdenNumb" name="srcOrdeIdenNumb" type="text" value="" size="" maxlength="50" style="width: 100px" /></td>
						</tr>
						<tr>
							<td colspan="6" height='1' bgcolor="eaeaea"></td>
						</tr>
						<tr>
							<td class="table_td_subject" width="100">주문유형</td>
							<td class="table_td_contents" <%if(isAdm == false){ %>colspan="5"<%} %>>
      							<select id="srcOrdeTypeClas" name="srcOrdeTypeClas" class="select">
                                    <option value="">전체</option>
<%
	if (orderTypeCode.size() > 0 ) {
		CodesDto cdData = null;
		for (int i = 0; i < orderTypeCode.size(); i++) {
			cdData = orderTypeCode.get(i); 
%>                                   
                                    <option value="<%=cdData.getCodeVal1()%>"><%=cdData.getCodeNm1()%></option>
<% }}%>
      							</select>
                            </td>
<%if(isAdm){ %>                  
                             <td class="table_td_subject" width="100">담당자</td>
                             <td class="table_td_contents" colspan="3">
                                <select id="srcWorkInfoUser" name="srcWorkInfoUser" class="select">
                                   <option value="">전체</option>
<% 	
if(isAdm && workInfoList != null){
	if (workInfoList.size() > 0 ) {
		SmpUsersDto sud = null;
		for (int i = 0; i < workInfoList.size(); i++) {
			sud = workInfoList.get(i); 
			String _selected = "";
			if(loginUserDto.getUserId().equals(sud.getUserId())) _selected="selected";
%>
                                   <option value="<%=sud.getUserId()%>" <%=_selected %>><%=sud.getUserNm()%></option>
<% } } } %>
                                </select>
                             </td>
<%}%>                  
						</tr>
						<tr>
							<td colspan="6" class="table_top_line"></td>
						</tr>
					</table> <!-- 컨텐츠 끝 -->
				</td>
			</tr>
            <tr><td height="5"></td></tr>
			<tr>
				<td align="right"> 
                        <button id='btnDeliInfoExcel' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 배송정보 일괄출력</button>
                        <button id='btnSelectedDeliDiv' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-check-square-o"></i> 송장일괄 입력</button>
                        <button id='btnDeliInfoSave' class="btn btn-warning btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-check-square-o"></i> 송장저장 및 배송</button>
                        <button id='btnProcessDelivery' class="btn btn-warning btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-check-square-o"></i> 출하처리</button>
                        <button id='btnDeliReject' class="btn btn-warning btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-check-square-o"></i> 발주의뢰 상태로 변경</button> 
                        <button id='btnPrintDeli' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 인수증 출력</button>
<%--                     <a href="javascript:processDelivery();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_consignment.gif" width="75" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a> --%>
<%--                     <a href="javascript:fnDeliReject();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderChange.gif" width="133" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /> </a> --%>
<%-- 					<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
<%-- 					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
				</td>
			</tr>
            <tr><td height="5"></td></tr>
			<tr>
				<td>
					<div id="jqgrid">
						<table id="list"></table>
						<div id="pager"></div>
					</div>
				</td>
			</tr>
		</table>
        <div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
            <p>처리할 데이터를 선택 하십시오!</p>
        </div>
</form>
<%@ include file="/WEB-INF/jsp/common/svcStatChangeReasonDiv.jsp" %>
<script>
var jq = jQuery;
// 리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);  
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');  

// 화면 초기화
$(document).ready(function(){
<%
	String _srcVendorName = "";
	String _srcVendorId = "";
	if("VEN".equals(loginUserDto.getSvcTypeCd())) {
		_srcVendorName = loginUserDto.getBorgNm();
		_srcVendorId = loginUserDto.getBorgId();
	}
%>
	$("#srcVendorName").val("<%=_srcVendorName%>");
	$("#srcVendorId").val("<%=_srcVendorId%>");
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())) {	%>
	$("#srcVendorName").attr("disabled", true);
	$("#btnVendor").css("display","none");
<%	}	%>

	$("#btnVendor").click(function(){
		var vendorNm = $("#srcVendorName").val();
		fnVendorDialog(vendorNm, "fnCallBackVendor"); 
	});
	$("#srcVendorName").keydown(function(e){ if(e.keyCode==13) { $("#btnVendor").click(); } });
	$("#srcVendorName").change(function(e){
		if($("#srcVendorName").val()=="") {
			$("#srcVendorId").val("");
		}
	});
	
	
	$("#btnProcessDelivery").click(function(){
	});
	$("#btnDeliReject").click(function(){
        fnDeliReject();
	});
	
	// 날짜 세팅
	$("#srcPurcStartDate").val("<%=srcPurcStartDate%>");
	$("#srcPurcEndDate").val("<%=srcPurcEndDate%>");
	
    // 날짜 조회 및 스타일
    $(function(){
        $("#srcPurcStartDate").datepicker({
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        });
        $("#srcPurcEndDate").datepicker({
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        });
        $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
    });
        
});

// jqgrid 설정
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/order/delivery/deliCompleteListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:["<input id='chkAllOutputField' type='checkbox' style='border:0px;' onclick='checkBox(event)' />",'주문일자','납품요청일','주문유형', '고객유형','주문번호', '발주차수', '납품차수', '인수증번호', '상품명', '상품규격', '배송상태',   '출하일','발주수량', '출하수량', '배송유형', '송장(전화)번호', '배송처주소', '주문상태','구매사', '주문자', '인수자', '인수자 연락처', '단가','금액', '발주일', '비고','주문명','첨부1','첨부2','첨부3', '인수완료일시', '공급사'<%if(isShow){ %>, '인수증 파일','인수증 업로드','receipt_img_file', 'receipt_img_file_path'<%} %>, 'disp_good_id', 'good_iden_numb','vendorId', 'tempDeliType', 'tempInvoNumb', 'deli_type_clas_code', 'path1', 'path2', 'path3','good_st_spec_desc','branchId' ], 
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,
				editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				formatter:checkboxFormatter, 
				frozen:true
			},//선택		          
			{name:'regi_date_time',index:'regi_date_time', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'requ_deli_date',index:'requ_deli_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'orde_type_clas',index:'orde_type_clas', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'worknm',index:'worknm', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_iden_numb',index:'orde_iden_numb', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'purc_iden_numb',index:'purc_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'deli_iden_numb',index:'deli_iden_numb', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'receipt_num',index:'receipt_num', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'good_name',index:'good_name', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'good_spec_desc',index:'good_spec_desc', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'isdelivery',index:'isdelivery', width:60,align:"center",search:false,sortable:true, editable:false },
			{name:'deli_degr_date',index:'deli_degr_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'purc_requ_quan',index:'purc_requ_quan', width:70,align:"right",search:false,sortable:true, editable:false,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },
			{name:'deli_prod_quan',index:'deli_prod_quan', width:70,align:"right",search:false,sortable:true, editable:false,sorttype:'integer',formatter:'integer',
					formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },
			{name:'deli_type_clas',index:'deli_type_clas', width:130,align:"center",search:false,sortable:true, editable:true
						, edittype:"select",formatter:"select",
				editoptions:{
					value:"<%=selBoxDeliType%>",
					dataEvents:[{
						type:'change',
						fn:function(e){
							var rowid = (this.id).split("_")[0];
							var inputValue = this.value; // 선택값
							jq("#list").jqGrid('setRowData', rowid, {tempDeliType:$.trim(inputValue)});
						}
					}]
				}
			},
			{name:'deli_invo_iden',index:'deli_invo_iden', width:110,align:"left",search:false,sortable:true, editable:true, 
				editoptions:{
					maxlength:15,
					dataInit:function(elem){
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "left");
						$(elem).keyup(function(){
							var val1 = elem.value;
							var num = new Number(val1);
							var rowid = (this.id).split("_")[0];
							var selrowContent = jq("#list").jqGrid('getRowData',rowid);
							if(selrowContent.tempDeliType != "ETC" && selrowContent.tempDeliType != "BUS" && selrowContent.tempDeliType != "TRAIN"){
								if(isNaN(num)) {
									alert("숫자만 입력해 주십시오.");
									elem.value = "";
								}
							}
							//fnOnlyNumberInert(elem.id,elem.value);
							jq("#list").jqGrid('setRowData', elem.id, {tempInvoNumb:elem.value});
						});
					},	
					dataEvents:[{
						type:'change',
						fn:function(e){
							var rowid = (this.id).split("_")[0];
							var inputValue = Number(this.value);                                            // 입력수량
							//fnOnlyNumberInert(rowid,inputValue);
							jq("#list").jqGrid('setRowData', rowid, {tempInvoNumb:this.value});
						}
					}]
				}
			},
			{name:'tran_data_addr',index:'tran_data_addr', width:250,align:"left",search:false,sortable:true, editable:false },
			{name:'deli_stat_flag',index:'deli_stat_flag', width:100,align:"center",search:false,sortable:true, editable:false },
			{name:'orde_client_name',index:'orde_client_name', width:200,align:"left",search:false,sortable:true, editable:false },
			{name:'orde_user_name',index:'orde_user_name', width:70,align:"left",search:false,sortable:true, editable:false },
			{name:'tran_user_name',index:'tran_user_name', width:70,align:"left",search:false,sortable:true, editable:false },
			{name:'tran_tele_numb',index:'tran_tele_numb', width:90,align:"rigth",search:false,sortable:true, editable:false },
			{name:'sale_unit_pric',index:'sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//단가
			{name:'total_sale_unit_pric',index:'total_sale_unit_pric', width:80,align:"right",search:false,sortable:true, editable:false ,sorttype:'integer',formatter:'integer',
				formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//금액
			{name:'clin_date',index:'clin_date', width:70,align:"center",search:false,sortable:true, editable:false },
			{name:'adde_text_desc',index:'adde_text_desc', width:150,align:"left",search:false,sortable:true, editable:false },
			{name:'cons_iden_name',index:'cons_iden_name', width:170,align:"left",hidden:false, search:false,sortable:true, editable:false },//주문명
			{name:'attach_file_name1',index:'attach_file_name1', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'attach_file_name2',index:'attach_file_name2', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'attach_file_name3',index:'attach_file_name3', width:60,align:"left",search:false,sortable:true, editable:false },
			{name:'purc_proc_date',index:'purc_proc_date', width:120,align:"center",search:false,sortable:true, editable:false },
			{name:'vendornm',index:'vendornm', width:100,align:"left",search:false,sortable:true, editable:false },
<%if(isShow){ %>		
			{name:'receipt_img_file_name',index:'receipt_img_file_name', width:100,align:"left",search:false,sortable:true, editable:false },
			{name:'receipt_img_file_upload',index:'receipt_img_file_upload', width:100,align:"center",search:false,sortable:true, editable:false ,formatter:receiptButton},
			{name:'receipt_img_file',index:'receipt_img_file', hidden:true, search:false,sortable:true, editable:false },
			{name:'receipt_img_file_path',index:'receipt_img_file_path', hidden:true, search:false,sortable:true, editable:false },
<%} %>		
			{name:'disp_good_id',index:'disp_good_id', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_iden_numb',index:'good_iden_numb', hidden:true, search:false,sortable:true, editable:false },
			{name:'vendorId',index:'vendorId', hidden:true, search:false,editable:false },
			{name:'tempDeliType',index:'tempDeliType', hidden:true, search:false,sortable:true, editable:false },
			{name:'tempInvoNumb',index:'tempInvoNumb', hidden:true, search:false,sortable:true, editable:false },
			{name:'deli_type_clas_code',index:'deli_type_clas_code', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path1',index:'attach_file_path1', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path2',index:'attach_file_path2', hidden:true, search:false,sortable:true, editable:false },
			{name:'attach_file_path3',index:'attach_file_path3', hidden:true, search:false,sortable:true, editable:false },
			{name:'good_st_spec_desc',index:'good_st_spec_desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true},
			{name:'branchId',index:'branchId', hidden:true, search:false,editable:false }
		],
		postData: {
			srcVendorId:$('#srcVendorId').val(),
			srcDeliStartDate:$('#srcDeliStartDate').val(),
			srcDeliEndDate:$('#srcDeliEndDate').val(),
			srcIsDelivery:$('#srcIsDelivery').val()
<%	if(isAdm){ 	%>
			,srcWorkInfoUser:$('#srcWorkInfoUser').val()
<%	}	%>


<%
		String srcProdSpec = "";
		for(int i = 0 ; i < Constances.PROD_GOOD_SPEC.length ; i++){
			if(i == 0) 	srcProdSpec = Constances.PROD_GOOD_SPEC[i];
			else		srcProdSpec += "‡" + Constances.PROD_GOOD_SPEC[i];
}
		String srcProdStSpec = "";
		for(int i = 0 ; i < Constances.PROD_GOOD_ST_SPEC.length ; i++){
			if(i == 0)  srcProdStSpec = Constances.PROD_GOOD_ST_SPEC[i];
			else        srcProdStSpec += "‡" + Constances.PROD_GOOD_ST_SPEC[i];
}
%>	
			,prodSpec:"규격" + '<%=srcProdSpec%>'
			,prodStSpec:'<%=srcProdStSpec%>'

		},
		multiselect:false,
		rowNum:30, rownumbers: false, rowList:[30,50,100,200], pager: '#pager',
		sortname: 'regi_date_time', sortorder: "desc",
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		caption:"배송완료", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(selrowContent.deli_type_clas == ""){
					jq('#list').editRow(rowid);
				}
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) { },
		afterInsertRow: function(rowid, aData){
<%if(!isVendor){%>
			jq("#list").setCell(rowid,'orde_iden_numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_iden_numb','',{cursor: 'pointer'});  
<%}%>
			jq("#list").setCell(rowid,'good_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_name','',{cursor: 'pointer'});  
			
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){
				jq("#list").setCell(rowid,'deli_invo_iden','',{color:'#0000ff'});
				jq("#list").setCell(rowid,'deli_invo_iden','',{cursor: 'pointer'});  
			}
			if(selrowContent.orde_type_clas == '선정산'){
				jq("#list").setCell(rowid,'deli_degr_date','',{color:'#0000ff'});
				jq("#list").setCell(rowid,'deli_degr_date','',{cursor: 'pointer'});  
			}
			jq("#list").setCell(rowid,'attach_file_name1','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'attach_file_name2','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'attach_file_name3','',{color:'#0000ff'});
<%if(isShow){ %>
     		jq("#list").setCell(rowid,'receipt_img_file_name','',{color:'#0000ff'});
<%} %>
			if($.trim(selrowContent.attach_file_name1) != '') {
				jq("#list").setCell(rowid,'attach_file_name1','',{cursor: 'pointer'});  
			}
			if($.trim(selrowContent.attach_file_name2) != '') {
				jq("#list").setCell(rowid,'attach_file_name2','',{cursor: 'pointer'});  
			}
			if($.trim(selrowContent.attach_file_name3) != '') {
				jq("#list").setCell(rowid,'attach_file_name3','',{cursor: 'pointer'});  
			}
<%if(isAdm){ %>
			jq("#list").setCell(rowid,'orde_client_name','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'orde_client_name','',{cursor: 'pointer'});
			jq("#list").setCell(rowid,'vendornm','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'vendornm','',{cursor: 'pointer'});
<%} %>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = jq("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(colName != undefined &&colName['index']=="attach_file_name1" && $.trim(selrowContent.attach_file_name1) != '') {fnAttachFileDownload(selrowContent.attach_file_path1);}
			if(colName != undefined &&colName['index']=="attach_file_name2" && $.trim(selrowContent.attach_file_name2) != '') {fnAttachFileDownload(selrowContent.attach_file_path2);}
			if(colName != undefined &&colName['index']=="attach_file_name3" && $.trim(selrowContent.attach_file_name3) != '') {fnAttachFileDownload(selrowContent.attach_file_path3);}
<%if(isShow){ %>		
			if(colName != undefined &&colName['index']=="receipt_img_file_name" && $.trim(selrowContent.receipt_img_file_name) != '') {fnAttachFileDownload(selrowContent.receipt_img_file_path);}
<%} %>		
<%if(!isVendor){%>
			if(colName != undefined &&colName['index']=="orde_iden_numb") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOrderDetailView(cellcontent, "+_menuId+");")%> }
<%}%>
<% if(loginUserDto.getSvcTypeCd().equals("BUY")){ %>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnCustProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%}else if(isVendor){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
<%}else if(isAdm){%>
			if(colName != undefined &&colName['index']=="good_name") { <%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnProductDetailView("+_menuId+", selrowContent.good_iden_numb, selrowContent.vendorId);")%> }
			//구매사 상세 팝업
			if(colName != undefined &&colName['index']=="orde_client_name") {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnBranchDetailView("+_menuId+", selrowContent.branchId);")%>
			}
			//공급사 상세 팝업
			if(colName != undefined &&colName['index']=="vendornm") {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnVendorDetailView("+_menuId+", selrowContent.vendorId);")%>
			}
<%} %>
			if(colName != undefined &&colName['index']=="deli_invo_iden") { 
				if(selrowContent.deli_type_clas_code != 'DIR' && (selrowContent.deli_type_clas_code != 'ETC' && selrowContent.deli_type_clas_code != 'BUS' && selrowContent.deli_type_clas_code != 'TRAIN')){
					fnSearchDeliPopup(selrowContent.deli_type_clas_code, selrowContent.deli_invo_iden);
				}
			}
			if(colName != undefined &&colName['index']=="deli_degr_date") { 
				if(selrowContent.orde_type_clas == '선정산'){
					fnShowDeliHist(selrowContent.orde_iden_numb, selrowContent.purc_iden_numb, selrowContent.deli_iden_numb);
				}
			}
		},
		loadError : function(xhr, st, str){
			alert("에러가 발생하였습니다.");
		},
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
	jQuery("#list").jqGrid('setFrozenColumns');
	
<%if(isShow){ %>
	jQuery("#list").jqGrid('setGroupHeaders', {
		useColSpanStyle: true,
		groupHeaders:[
			{startColumnName: 'receipt_img_file_name', numberOfColumns: 2, titleText: '공급사 인수증 업로드'}
		]
	});
<%} %>
});

function checkboxFormatter(cellvalue, options, rowObject) {
	var checkBox = "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' style='border: 0' offval='no' onclick=\"fnIsChecked('"+options.rowId+"')\" />";
	return checkBox;
}
function fnIsChecked(rowid){

	if($("#isCheck_" + rowid ).prop("checked") == true){
		$("#isCheck_" + rowid ).prop("checked",false);
	}else{
		$("#isCheck_" + rowid ).prop("checked",true);
	}
}
function receiptButton(cellvalue, options, rowObject) {
	var inputBtn = "<input style='height:22px;width:90;' type='button' value='인수증 업로드' onclick=\"fnUploadReceipt('"+options.rowId+"');\" />"; 
	return inputBtn; 	
}

function checkBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;

	if($("#chkAllOutputField").prop("checked") == true){
		$("#chkAllOutputField").prop("checked",false);
	}else{
		$("#chkAllOutputField").prop("checked",true);
	}
	
	if($("#chkAllOutputField").is(':checked')) {
	   var rowCnt = jq("#list").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#list").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:not(checked)').attr("checked", true);
	        }
	    }
   } else {
	    var rowCnt = jq("#list").getGridParam('reccount');
	    if(rowCnt>0) {
	        for(var i=0; i<rowCnt; i++) {
	            var rowid = $("#list").getDataIDs()[i];
	            jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
	        }
	    }
   }
}

function fnAttachFileDownload(attach_file_path) {
	var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys";
	var data = "attachFilePath="+attach_file_path;
	$.download(url,data,'post');
}
jQuery.download = function(url, data, method){
    // url과 data를 입력받음
    if( url && data ){ 
        // data 는  string 또는 array/object 를 파라미터로 받는다.
        data = typeof data == 'string' ? data : jQuery.param(data);
        // 파라미터를 form의  input으로 만든다.
        var inputs = '';
        jQuery.each(data.split('&'), function(){ 
            var pair = this.split('=');  
            inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />'; 
        });
        // request를 보낸다.
        jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
        .appendTo('body').submit().remove();
    }
};
function fnOnlyNumberInert(str1,str2){
	var rowid = str1.split("_")[0];
	var inputValue = str2;  //this.value; 
	jq("#list").jqGrid('setRowData', rowid, {tempInvoNumb:$.trim(inputValue)});
}





</script>
<%-- 인수증 출력 관련 스크립트 시작 --%>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script language="JavaScript">
function fnOpen(receiptNum, i) {
	<%
		String prodSpec = "";
		for(int i = 0 ; i < Constances.PROD_GOOD_SPEC.length ; i++){
			if(i == 0) 	prodSpec = Constances.PROD_GOOD_SPEC[i];
			else		prodSpec += "‡" + Constances.PROD_GOOD_SPEC[i];
		}
        String prodStSpec = "";
        for(int i = 0 ; i < Constances.PROD_GOOD_ST_SPEC.length ; i++){
            if(i == 0)  prodStSpec = Constances.PROD_GOOD_ST_SPEC[i];
            else        prodStSpec += "‡" + Constances.PROD_GOOD_ST_SPEC[i];
        }                
	%>	
	var prodSpec	= '<%=prodSpec%>';
	var prodStSpec	= '<%=prodStSpec%>';
	var oReport = GetfnParamSet(i); // 필수
	oReport.rptname = "receivePrint"; // reb 파일이름
	oReport.param("receipt_num").value = receiptNum; // 매개변수 세팅
	oReport.param("prodSpec").value 	 	 = prodSpec;
	oReport.param("prodStSpec").value 	 	 = prodStSpec;
	oReport.title = "인수증"; // 제목 세팅
	oReport.open();
}
</script>
<%-- 인수증 출력 관련 스크립트 끝 --%>
</body>
</html>