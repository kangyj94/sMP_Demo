<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-389 + Number(gridHeightResizePlus)";
	String listWidth = "1498";
	
	
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcPurchaseClosStartDate").val('<%=CommonUtils.getCustomDay("MONTH", -1)%>');
	$("#srcPurchaseClosEndDate").val('<%=CommonUtils.getCustomDay("DAY", 0)%>');
	
	$("#srcButton").click( function(){ fnSearch(); });
	$("#colButton").click( function(){ jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#paymentConfirmButton").click(function(){ fnPaymentConfirm(); });
	$("#etcExpirationDateTransmission").click(function(){ etcExpirationDateTransmission(); });
	
	
});
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight%>);
	$("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');

//날짜 조회 및 스타일
$(function(){
	$("#srcPurchaseClosStartDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcPurchaseClosEndDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/adjust/adjustPurchaseTransmissionJQGrid.sys',
		multiselect:true,
		datatype: 'json',
		mtype: 'POST',
		colNames:['buyi_sequ_numb','isPayment','지급여부','반제번호','계산서일자','외담대만기도래일','공급사','사업자등록번호','매입확정일자','매입금액','부가세','합계','출금금액','미출금금액','전송상태','SAP전표번호','전송일자','내용','적요','sum_buyi_requ_amou','sum_buyi_requ_vtax','sum_buyi_tota_amou','sum_pay_amou', 'sum_none_coll_amou'],
		colModel:[
			{name:'buyi_sequ_numb', index:'buyi_sequ_numb',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'isPayment', index:'isPayment',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'isPaymentNm', index:'isPaymentNm',width:50,align:"center",search:false,sortable:false, editable:false },
			{name:'pay_amou_numb', index:'pay_amou_numb',width:60,align:"center",search:false,sortable:true, editable:false, hidden:false },
			{name:'clos_buyi_date', index:'clos_buyi_date',width:90,align:"center",search:false,sortable:true, editable:false },
			{name:'etc_expiration_date', index:'etc_expiration_date',width:90,align:"center",search:false,sortable:true, 
				formatter: 'text',
				editable:true,edittype: 'text',
				editoptions: {
					readonly:'readonly',
					size: 9,maxlengh: 10,dataInit: function (element) {
					$(element).datepicker({ dateFormat: 'yy-mm-dd' });
					},
					dataEvents:[{
						type:'change',
						fn:function(e){
							var inputValue = this.value;                                // 입력 날짜
							var rowid = (this.id).split("_")[0];
							jq("#list").restoreRow(rowid);
							jq("#list").jqGrid('setRowData', rowid, {etc_expiration_date:inputValue});
						}
					}]
				},
				editrules: {date: false}
			},//외담대만기도래일
			{name:'vendorNm',index:'vendorNm',width:160,align:"left",search:false,sortable:true, editable:false },
			{name:'businessNum', index:'businessNum',width:100,align:"center",search:false,sortable:true, editable:false },//사업자등록번호
			{name:'buyi_conf_date',index:'buyi_conf_date',width:80,align:"center",search:false,sortable:true, editable:false },//매입확정일자
			{name:'buyi_requ_amou',index:'buyi_requ_amou',width:90,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입금액
			{name:'buyi_requ_vtax',index:'buyi_requ_vtax',width:80,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//부가세
			{name:'buyi_tota_amou',index:'buyi_tota_amou',width:90,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//합계
			{name:'pay_amou',index:'pay_amou',width:90,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//출금금엑
			{name:'none_paym_amou',index:'none_paym_amou',width:90,align:"right",search:false,sortable:true, editable:false , 
				sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//미출금금액
			{name:'tran_status_nm',index:'tran_status_nm',width:70,align:"center",search:false,sortable:true, editable:false },//전송상태
			{name:'sap_jour_numb',index:'sap_jour_numb',width:90,align:"center",search:false,sortable:true, editable:false },//sap전표번호
			{name:'tran_sap_jour_date',index:'tran_sap_jour_date',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'desc',index:'desc',width:80,align:"center",search:false,sortable:true, editable:false },
			{name:'sum_up',index:'sum_up',width:120,align:"center",search:false,sortable:false, editable:false },
			{name:'sum_buyi_requ_amou',index:'sum_buyi_requ_amou',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'sum_buyi_requ_vtax',index:'sum_buyi_requ_vtax',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'sum_buyi_tota_amou',index:'sum_buyi_tota_amou',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'sum_pay_amou',index:'sum_pay_amou',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true },
			{name:'sum_none_coll_amou',index:'sum_none_coll_amou',width:80,align:"center",search:false,sortable:true, editable:false, hidden:true }
		],
		postData: {
			srcTransStatus:"20",
			srcVendorNm:$("#srcVendorNm").val(),
			srcIsPayment:$.trim($("#srcIsPayment").val()),
			srcPurchaseClosStartDate:$("#srcPurchaseClosStartDate").val(),
			srcPurchaseClosEndDate:$("#srcPurchaseClosEndDate").val(),
			srcBusinessNum:$("#srcBusinessNum").val()			
		},
		rowNum:-1,
		height: <%=listHeight%>, width: <%=listWidth%>,
		sortname: 'a.clos_buyi_date', sortorder: 'desc',
		caption:"매입지급처리", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i = 0 ; i < rowCnt ; i++){
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					if(selrowContent.isPayment == "0") {
						jq("#list").jqGrid('setRowData', rowid, {isPaymentNm:"미지급"});
					} else if(selrowContent.isPayment == "1") {
						jq("#list").jqGrid('setRowData', rowid, {isPaymentNm:"지급"});
					}
					var descStr = "<button id='detailView' name='detailView' class='btn btn-primary btn-xs' onClick='javaScript:fnOnDesc("+selrowContent.buyi_sequ_numb+")'>상세보기</button>";
					jq("#list").jqGrid('setRowData', rowid, {desc:descStr});
				}
				var rowid = $("#list").getDataIDs()[0];
				var selrowContent 	= jq("#list").jqGrid('getRowData',rowid);
				var getBuyi_requ_amou = selrowContent.sum_buyi_requ_amou; 
				var getBuyi_requ_vtax = selrowContent.sum_buyi_requ_vtax;
				var getBuyi_tota_amou = selrowContent.sum_buyi_tota_amou;
				var getPay_amou = selrowContent.sum_pay_amou;
				var getNone_coll_amou = selrowContent.sum_none_coll_amou;
				jq("#list").addRowData(rowCnt + 1,
										{	
											clos_sale_date:"",
											etc_expiration_date:" ",
											buyi_conf_date:"합계",
											buyi_requ_amou:getBuyi_requ_amou,
											buyi_requ_vtax:getBuyi_requ_vtax,
											buyi_tota_amou:getBuyi_tota_amou,
											pay_amou:getPay_amou,
											none_paym_amou:getNone_coll_amou}
										);
				//jq("#list").setCell(rowCnt + 1,'sale_requ_amou','',{weightfont:'bold'});
				$("#list").jqGrid('setCell',rowCnt + 1,'buyi_conf_date', '', {color:'black',weightfont:'bold'}); 
				$("#list").jqGrid('setCell',rowCnt + 1,'buyi_requ_amou', '', {color:'black',weightfont:'bold'}); 
				$("#list").jqGrid('setCell',rowCnt + 1,'buyi_requ_vtax', '', {color:'black',weightfont:'bold'}); 
				$("#list").jqGrid('setCell',rowCnt + 1,'buyi_tota_amou', '', {color:'black',weightfont:'bold'});            		
				$("#list").jqGrid('setCell',rowCnt + 1,'pay_amou', '', {color:'black',weightfont:'bold'});            		
				$("#list").jqGrid('setCell',rowCnt + 1,'none_paym_amou', '', {color:'black',weightfont:'bold'});
				
				//체크박스 비활성
				var rowId = $("#list").jqGrid('getDataIDs');
				for(var i=0; i<rowId.length; i++){
					var dataType = $("#list").getRowData(rowId[i]);
					if(dataType['buyi_sequ_numb'] == ''){
						var unCheckBox = $('#jqg_list_'+rowId[i]);
						unCheckBox.attr("disabled", true);//체크박스 비활성화
						unCheckBox.css("visibility", "hidden");//체크박스 모습감추기
					}
				}
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","fnOnDetail(selrowContent.buyi_sequ_numb)")%>			
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){
			var cm = $("#list").jqGrid("getGridParam", "colModel");
			var colName = cm[iCol];
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowid < rowCnt){
				if(colName['index'] == "etc_expiration_date"){
					jQuery('#list').jqGrid('editRow',rowid,true); 
				}
			}
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

function fnSearch(){
	jq("#list").jqGrid("setGridParam");
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorNm = $("#srcVendorNm").val();
	data.srcIsPayment = $.trim($("#srcIsPayment").val());
	data.srcPurchaseClosStartDate = $("#srcPurchaseClosStartDate").val();
	data.srcPurchaseClosEndDate = $("#srcPurchaseClosEndDate").val();
	data.srcBusinessNum = $("#srcBusinessNum").val();
	jq("#list").trigger("reloadGrid");     
}

function fnOnDetail(obj) {
	if(obj != ""){
		var popurl = "/adjust/adjustPurchasePaymentDetailPop.sys?buyi_sequ_numb=" + obj + "&_menuId=<%=_menuId%>";
		var popproperty = "dialogWidth:780px;dialogHeight=260px;scroll=yes;status=no;resizable=no;";
		//window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=780, height=620, scrollbars=yes, status=no, resizable=no');
	}else{
		jq( "#dialogSelectRow" ).dialog();
	}}

function fnOnDesc(obj) {
	if( obj != "" ){
		var popurl = "/adjust/adjustPurchasePaymentDescPop.sys?buyi_sequ_numb=" + obj + "&_menuId=<%=_menuId%>";
		var popproperty = "dialogWidth:580px;dialogHeight=310px;scroll=yes;status=no;resizable=no;";
		window.open(popurl, 'okplazaPop', 'width=570, height=310, scrollbars=yes, status=no, resizable=no');
	}else{
		jq( "#dialogSelectRow" ).dialog();
	}
}

function exportExcel() {
	var colLabels = ['지급여부','반제번호','계산서일자','외담대만기도래일','공급사','사업자등록번호','매입확정일자','매입금액','부가세','합계','출금 금액','미지급금액','전송상태','SAP전표번호','전송일자','적요'];	//출력컬럼명
	var colIds = ['isPaymentNm','pay_amou_numb','clos_buyi_date','etc_expiration_date','vendorNm','businessNum','buyi_conf_date','buyi_requ_amou','buyi_requ_vtax','buyi_tota_amou','pay_amou','none_paym_amou','tran_status_nm','sap_jour_numb','tran_sap_jour_date','sum_up'];	//출력컬럼ID
	var numColIds = ['buyi_requ_amou','buyi_requ_vtax','buyi_tota_amou','pay_amou','none_paym_amou'];	//숫자표현ID
	var figureColIds = ['businessNum'];
	var sheetTitle = "매입지급처리";	//sheet 타이틀
	var excelFileName = "PurcharsePayment";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnPaymentConfirm(){
	var rowCnt = jq("#list").getGridParam('reccount');
	var buyi_sequ_numb_Arr = Array();
	var clos_buyi_date_Arr = Array();
	var rece_pay_amou_Arr  = Array();
	var none_paym_amou_Arr = Array();
	var sap_jour_numb_Arr  = Array();
	var chkCnt = 0;	
	for(var i = 0 ; i < rowCnt-1 ; i++){
		var rowid = $("#list").getDataIDs()[i];	
		var selrowContent 	= jq("#list").jqGrid('getRowData',rowid);
		if(selrowContent.pay_amou_numb == ""){
			buyi_sequ_numb_Arr[chkCnt]   =  selrowContent.buyi_sequ_numb;
			clos_buyi_date_Arr[chkCnt]   =  selrowContent.clos_buyi_date;
			rece_pay_amou_Arr[chkCnt]    =  selrowContent.pay_amou;
			none_paym_amou_Arr[chkCnt]   =  selrowContent.none_paym_amou;
			sap_jour_numb_Arr[chkCnt]	 =  selrowContent.sap_jour_numb;
			chkCnt++;
		}
	}	
	
	if(chkCnt == 0){
		$("#dialog").html("<font size='2'>처리할 데이터가 없습니다.</font>");
		$("#dialog").dialog({
			title: 'Fail',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});			 
		return;
	}

	if(!confirm("출금을 확인하시겠습니까?")) return;
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/salesPaymentConfirm.sys", 
		{
			buyi_sequ_numb_Arr:buyi_sequ_numb_Arr,
			clos_buyi_date_Arr:clos_buyi_date_Arr,
			rece_pay_amou_Arr:rece_pay_amou_Arr,
			none_paym_amou_Arr:none_paym_amou_Arr,
			sap_jour_numb_Arr:sap_jour_numb_Arr
		},
		function(arg){ 
			if(fnAjaxTransResult(arg)) {  //성공시
				fnSearch();
			}else{
				fnSearch();
			}
		}
	); 		
}

//외담대만기도래일 수동 입력
function etcExpirationDateTransmission(){
	var rowId = $("#list").getGridParam('selarrrow');
	var buyiSequNumbArray = new Array();
	var etcExpirationDateArray = new Array();
	var checkCnt = 0;
	for(var i=0; i<rowId.length; i++){
		var selrowContents = jq("#list").jqGrid('getRowData',rowId[i]);
		if(selrowContents.buyi_sequ_numb != null && selrowContents.buyi_sequ_numb != ""){
			buyiSequNumbArray[i] = selrowContents.buyi_sequ_numb;
			etcExpirationDateArray[i] = selrowContents.etc_expiration_date;
			checkCnt++;
		}
	}
	if(checkCnt > 0){
		$.post(
			"/adjust/etcExpirationDateSave.sys",
			{
				buyiSequNumbArray:buyiSequNumbArray,
				etcExpirationDateArray:etcExpirationDateArray
			},
			function(arg){
				if(fnAjaxTransResult(arg)) {	//성공시
					fnSearch();
				}else{
					fnSearch();
				}
			}
		);
	}else{
		alert("체크박스를 선택해 주세요.");
	}
	
}

</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data" onsubmit="return false;">
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">매입반제/지급현황</td>
					<td align="right" class="ptitle">
						<button id="srcButton" name="srcButton" class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>">
							<i class="fa fa-search"></i> 조회
						</button>
					</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">공급사명</td>
					<td class="table_td_contents">
						<input id="srcVendorNm" name="srcVendorNm" type="text" value="" size="20" maxlength="30" />
					</td>
					<td class="table_td_subject" width="100">지급여부</td>
					<td class="table_td_contents">
						<select id="srcIsPayment" name="srcIsPayment" class="select">
							<option value="">선택하세요</option>
							<option value="10">미지급</option>
							<option value="20">지급</option>
						</select>
					</td>
					<td class="table_td_subject" width="100">계산서일자</td>
					<td class="table_td_contents">
						<input type="text" name="srcPurchaseClosStartDate" id="srcPurchaseClosStartDate" style="width: 75px; vertical-align: middle;" />
						~
						<input type="text" name="srcPurchaseClosEndDate" id="srcPurchaseClosEndDate" style="width: 75px; vertical-align: middle;" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">사업자등록번호</td>
					<td colspan="3" class="table_td_contents">
						<input id="srcBusinessNum" name="srcBusinessNum" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumber(event)"/> (-없이)
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td>
			<table width="1500px" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" valign="bottom">
						<font color="red">*</font> 더블클릭하면 수동으로 출금정보을 입력하실 수 있습니다.
					</td>
					<td align="right" valign="bottom">
						<button id="etcExpirationDateTransmission" name="etcExpirationDateTransmission" class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
							외담대만기도래일 등록
						</button>
						<button id='paymentConfirmButton' class="btn btn-danger btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>'>
							출금즉시확인
						</button>
						<button id='excelButton' class="btn btn-success btn-xs" style='<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>'>
							<i class="fa fa-file-excel-o"></i> 엑셀
						</button>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="1"></td></tr>
	<tr>
		<td colspan="2">
			<div id="jqgrid">
				<table id="list"></table>
			</div>
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>      
<!-------------------------------- Dialog Div Start -------------------------------->
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>