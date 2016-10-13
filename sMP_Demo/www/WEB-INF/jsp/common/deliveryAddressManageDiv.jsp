<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.jqmDeliveryAddresWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 571px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmDeliveryAddresWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<%
/**------------------------------------우편번호검색 사용방법---------------------------------
* fnPostSearchDialog(callbackString) 을 호출하여 Div팝업을 Display ===
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 2개(우편번호, 기본주소) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/postSearchDiv.jsp" %>
<% //------------------------------------------------------------------------------ %>

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
	

$(function(){$("#modButton").click( function() { editRow(); });
	// Dialog Button Event
	$('#deliveryAddressManageDialogPop').jqm();	//Dialog 초기화
	$("#btnDeliveryManageCloseDiv").click(function(){	//Dialog 닫기
		$("#deliveryAddressManageDialogPop").jqmHide();
		$("#shippingPlaceManageDiv").val("");
		$("#shippingPostManageDiv").val("");
		$("#shippingAddressManageDiv").val("");
		$("#shippingAddressDescManageDiv").val("");
		fnDeliveryAddressManageCallback = "";
		_groupId = "";
		_clientId = "";
		_branchId = "";
	});
	$('#btnDeliveryRegDiv').click(function(){
		if($("#shippingPlaceManageDiv").val()=="") { alert("배송지명은 필수입니다."); $("#shippingPlaceManageDiv").focus(); return; }
		if($("#shippingPostManageDiv").val()=="") { alert("우편번호는 필수입니다."); return; }
		if($("#shippingAddressDescManageDiv").val()=="") { alert("배송지 상세주소는 필수입니다."); $("#shippingAddressDescManageDiv").focus(); return; }
		$.post(	//배송지정보 등록
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/saveDeliveryManage.sys',
			{ 
				groupId:_groupId, clientId:_clientId, branchId:_branchId,
				shippingPlace:$("#shippingPlaceManageDiv").val(),
				shippingAddres:$("#shippingPostManageDiv").val()+" "+$("#shippingAddressManageDiv").val()+" "+$("#shippingAddressDescManageDiv").val(),
				isDefault:$("#isDefaultDiv").val(),
				oper:"add"
			},
			function(arg){
				var result = eval('(' + arg + ')').customResponse;
				if (result.success == false) {
					var errors = "";
					for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
					alert(errors);
				} else {
					eval(fnDeliveryAddressManageCallback+"();");
					fnDeliveryGridList();
				}
			}
		);
	});
	$('#deliveryAddressManageDialogPop').jqm().jqDrag('#deliveryAddressManageDialogHandle'); 
	
	$('#btnDeliveryManageDelDiv').click(function(){
		var row = jq("#deliveryDivlist").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
		if( row != null ){
			if(!confirm("선택한 배송지정보를 삭제하시겠습니까?")) return;
			var selrowContent = jq("#deliveryDivlist").jqGrid('getRowData',row);
			$.post(	//배송지정보 삭제
				'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/saveDeliveryManage.sys',
				{ 
					id:selrowContent.deliveryid,
					oper:"del"
				},
				function(arg){
					var result = eval('(' + arg + ')').customResponse;
					if (result.success == false) {
						var errors = "";
						for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
						alert(errors);
					} else {
						eval(fnDeliveryAddressManageCallback+"();");
						fnDeliveryGridList();
					}
				}
			);
		} else { alert("처리할 데이터를 선택 하십시오!"); }
	});

	$('#btnDeliveryManageModDiv').click(function(){
		var row = jq("#deliveryDivlist").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
		if( row != null ){
			if(!confirm("선택한 배송지정보를 기본배송지로 하시겠습니까?")) return;
			var selrowContent = jq("#deliveryDivlist").jqGrid('getRowData',row);
			$.post(	//기본배송지로 변경
				'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/saveDeliveryManage.sys',
				{ 
					groupId:_groupId,
					clientId:_clientId,
					branchId:_branchId,
					id:selrowContent.deliveryid,
					oper:"edit"
				},
				function(arg){
					var result = eval('(' + arg + ')').customResponse;
					if (result.success == false) {
						var errors = "";
						for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
						alert(errors);
					} else {
						eval(fnDeliveryAddressManageCallback+"();");
						fnDeliveryGridList();
					}
				}
			);
		} else { alert("처리할 데이터를 선택 하십시오!"); }
	});
	
});

function editRow() {
	var row = jq("#deliveryDivlist").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#deliveryDivlist").jqGrid('setColProp', 'deliveryid',{editoptions:{
			disabled:true,size:"20",maxLength:"20",
			dataInit: function(elem){
				$(elem).css("ime-mode", "disabled");
				$(elem).css("text-transform","uppercase");
			}
		}}); 
		jq("#deliveryDivlist").jqGrid(
			'editGridRow', row,{ 
				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/common/saveDeliveryManage.sys",
				editData:{},recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
				afterSubmit : function(response, postdata){ 
					return fnJqTransResult(response, postdata);
				}
			}
		);
		jq("#deliveryDivlist").jqGrid('setColProp', 'deliveryid',{editoptions:{
			disabled:false,size:"20",maxLength:"20",
			dataInit: function(elem){
				$(elem).css("ime-mode", "disabled");
				$(elem).css("text-transform","uppercase");
			}
		}}); 
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

var fnDeliveryAddressManageCallback = "";
var _groupId = "";
var _clientId = "";
var _branchId = "";
function fnDeliveryAddressManageDialog(groupId, clientId, branchId, callbackString) {
	$("#deliveryAddressManageDialogPop").jqmShow();
	$("#shippingPlaceManageDiv").val("");
	$("#shippingPostManageDiv").val("");
	$("#shippingAddressManageDiv").val("");
	$("#shippingAddressDescManageDiv").val("");
	fnDeliveryAddressManageCallback = callbackString;
	_groupId = groupId;
	_clientId = clientId;
	_branchId = branchId;
	fnDeliveryGridList();
}

</script>

<%
/**------------------------------------우편번호검색 사용방법---------------------------------
* 1. 우편번호 검색 버튼 클릭 시 발생할 이벤트 적용
* 2. 콜백 후 처리 되는 부분 참조 (그대로 복사)
* 3. 우편번호,주소,상세주소 input 태그에 맞는 id 변경만 처리하면 적용
*/
%>
<!-- 고객사검색관련 스크립트 -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	/*****  1.이벤트 적용*****/
	$("#btnShippingPostManageDiv").click(function(){	fnSetPostCode();	});
	
});

function fnSetPostCode() {
	new daum.Postcode({
		oncomplete: function(data) {
			/*****  2. 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.(콜백)*****/

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var fullAddr = ''; // 최종 주소 변수
			var extraAddr = ''; // 조합형 주소 변수

			// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				fullAddr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				fullAddr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 조합한다.
			if(data.userSelectedType === 'R'){
				//법정동명이 있을 경우 추가한다.
				if(data.bname !== ''){
					extraAddr += data.bname;
				}
				// 건물명이 있을 경우 추가한다.
				if(data.buildingName !== ''){
					extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
				fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
			}
			
			/*****  3. 우편번호와 주소 정보를 해당 필드에 넣는다 (ID매칭 확인) *****/
			document.getElementById('shippingPostManageDiv').value = data.zonecode; //5자리 새우편번호 사용
			document.getElementById('shippingAddressManageDiv').value = fullAddr;
			document.getElementById('shippingAddressDescManageDiv').focus();
		}
	}).open();
}
</script>
<% //------------------------------------------------------------------------------ %>



<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var deliveryManageInitCnt = 0;
function fnDeliveryGridList() {
	if(deliveryManageInitCnt>0) {
		fnDeliveryAddressManageSearch(_groupId, _clientId, _branchId);
		return;
	}
	jq("#deliveryDivlist").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getDeliveryAddressByBranchId.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['배송지명','배송지 주소','기본배송지','deliveryid'],
		colModel:[
			{name:'shippingplace',index:'shippingplace', width:90,align:"left",search:false,sortable:false,
				editable:false
			},	//배송지명
			{name:'shippingaddres',index:'shippingaddres', width:365
				
				,align:"left",search:false,sortable:false,
				editable:false
			},	//배송지 주소
			{name:'isdefault',index:'isdefault', width:60,align:"center",search:false,sortable:false,
				editable:true,
				edittype:"select",formatter:"select",editoptions:{value:"0:아니오;1:예"}
			},	//기본배송지
			{name:'deliveryid',index:'deliveryid', hidden:true, key:true}	//deliveryid
		],
		postData: {
			groupId:_groupId,
			clientId:_clientId,
			branchId:_branchId
		},
		height: 140, width: 530,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { deliveryManageInitCnt++; },
		onSelectRow: function(rowid, iRow, iCol, e) {},	
		ondblClickRow: function (rowid, iRow, iCol, e) {
    		var selrowContent = jq("#deliveryDivlist").jqGrid('getRowData',rowid);
    		var rtn_deliveryid = selrowContent.deliveryid;
    		eval(fnDeliveryAddressManageCallback+"('"+rtn_deliveryid+"');");
    		$("#btnDeliveryManageCloseDiv").click();
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#deliveryDivlist").html(xhr.responseText); },
		jsonReader : {root: "deliveryListInfo",repeatitems: false}
	}); 
}

function fnDeliveryAddressManageSearch() {
	var data = jq("#deliveryDivlist").jqGrid("getGridParam", "postData");
	data.groupId=_groupId;
	data.clientId=_clientId;
	data.branchId=_branchId;
	jq("#deliveryDivlist").jqGrid("setGridParam", { "postData":data });
	jq("#deliveryDivlist").trigger("reloadGrid");
}
function fnDeliverySelected(){
	var rowid  = jq("#deliveryDivlist").getGridParam( "selrow" );
	var selrowContent   =  jq("#deliveryDivlist").getRowData( rowid );
	
	if( ! selrowContent  ){
		alert("배송지 주소를 선택하여 주시기 바랍니다.");
		return;
	}
	
	var rtn_deliveryid = selrowContent.deliveryid;
	eval(fnDeliveryAddressManageCallback+"('"+rtn_deliveryid+"');");

	$("#btnDeliveryManageCloseDiv").click();	
}
</script>
</head>

<body>
<div class="jqmDeliveryAddresWindow" id="deliveryAddressManageDialogPop">
	<table width="570"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="deliveryAddressManageDialogHandle">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
						<tr>
							<td width="21" style="background-color: #ea002c; height: 47px;"></td>
							<td style="background-color: #ea002c; height: 47px;color: #fff;font-size: 20px;font-weight: 700;">배송지팝업</td>
							<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
								<a href="#" class="jqmClose">
									<img src="/img/contents/btn_close.png" class="jqmClose">
								</a>
							</td>
							<td width="10" style="background-color: #ea002c; height: 47px;"></td>
						</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="top" bgcolor="#FFFFFF">
							<table width="100%"  class="InputTable">
								<tr>
									<th width="90">배송지명</th>
									<td >
										<input id="shippingPlaceManageDiv" name="shippingPlaceManageDiv" type="text" size="30" maxlength="50"/>
									</td>
								</tr>
								<tr>
									<th>주소</th>
									<td width="390">
										<table width="100%" style=" line-height:1.0em;border-collapse:inherit;" >
											<tr>
												<td style="border: 0px; padding: 0px;">
													<input id="shippingPostManageDiv" name="shippingPostManageDiv" type="text" size="7" class="input_text_none" disabled="disabled"/>
													<a href="#">
													<img id="btnShippingPostManageDiv" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style='border:0;vertical-align:middle;display: '/>
													</a>
												</td>
											</tr>
											<tr>
												<td style="border: 0px; padding: 2px 2px 2px 0px; ">
													<input id="shippingAddressManageDiv" name="shippingAddressManageDiv" type="text" size="50" class="input_text_none" disabled="disabled" style="width: 405px;;"/>
												</td>
											</tr>
											<tr>
												<td style="border: 0px; padding: 0px;">
													<input id="shippingAddressDescManageDiv" name="shippingAddressDescManageDiv" type="text" size="50" maxlength="50" style=" width: 405px;"/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<th width="90">기본배송지여부</th>
									<td>
										<select class="select" name="isDefaultDiv" id="isDefaultDiv">
											<option value="0">아니오</option>
											<option value="1">예</option>
										</select>
									</td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr><td style="height: 3px;"></td></tr>
								<tr>
									<td align="center">
										<button id="btnDeliveryRegDiv" type="button" class="btn btn-darkgray btn-sm">등록</button>
									</td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td height="5"></td>
								</tr>
								<tr>
									<td align="right">
										<table>
											<tr>
												<td style="padding-bottom:3px;">
													<button id="btnDeliveryManageModDiv" type="button" class="btn btn-darkgray btn-xs">기본배송지로 변경</button>
													<button id="btnDeliveryManageDelDiv" type="button" class="btn btn-default btn-xs">삭제</button>
<%-- 													<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;' /></a> --%>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td valign="top">
										<div id="jqgrid">
											<table id="deliveryDivlist"></table>
										</div>
									</td>
								</tr>
							</table>
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="" onclick="javascript:fnDeliverySelected();" type="button" class="btn btn-darkgray btn-sm">선택</button>
										<button id="btnDeliveryManageCloseDiv" type="button" class="btn btn-default btn-sm">닫기</button>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
