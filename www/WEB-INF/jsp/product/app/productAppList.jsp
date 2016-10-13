<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-328 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");			// 화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);	// 사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));												// 메뉴Id
	String srcConfirmStartDate = CommonUtils.getCustomDay("DAY", -7);										// 날짜 세팅
	String srcConfirmEndDate = CommonUtils.getCurrentDate();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	// 코드 데이터 조회
	fnDataInit();
	
	// 이벤트 등록
	$("#srcButton").click(function() {
		$("#srcVendorId").val($.trim($("#srcVendorId").val()));
		$("#srcGoodName").val($.trim($("#srcGoodName").val()));
		$("#srcConfirmStartDate").val($.trim($("#srcConfirmStartDate").val()));
		$("#srcConfirmEndDate").val($.trim($("#srcConfirmEndDate").val()));
		$("#srcChnPriceClas").val($.trim($("#srcChnPriceClas").val()));
		$("#srcAppStsFlag").val($.trim($("#srcAppStsFlag").val()));
	});
	$("#srcButton").click(function() { fnSearch(); });
	$("#srcVendorNm").keydown(function(e) { if(e.keyCode==13) { $("#btnVendor").click(); }});
	$("#srcVendorNm").change(function(e) {	$("#srcVendorNm").val(""); $("#srcVendorId").val(""); });
	$("#btnVendor").click(function() { fnSearchVendor(); });
	$("#srcGoodName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcConfirmStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcConfirmEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcChnPriceClas").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcAppStsFlag").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	
	$("#appButton").click(function() { fnApproval(1); });
	$("#retButton").click(function() { fnApproval(2); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function() { exportExcel(); });
	
	// DataPicker 등록
	$("#srcConfirmStartDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcConfirmEndDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;");
});
//리싸이즈 설정
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").jqGrid( 'setGridWidth', $("#navbar-container").width());
}).trigger('resize');

//코드 데이터 초기화
function fnDataInit() {
	$.post( //조회조건의 단가변경타입 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/getCodeList.sys',
		{codeTypeCd:"APPLTFIXCODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcChnPriceClas").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
		}
	);
	$.post( //조회조건의 승인상태 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"APPROVALSTATE", isUse:"1"},
		function(arg) {
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				if(codeList[i].codeVal1=='0') {
					$("#srcAppStsFlag").append("<option value='"+codeList[i].codeVal1+"' selected>"+codeList[i].codeNm1+"</option>");
				} else {
					$("#srcAppStsFlag").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				}
			}
			initComponent();
		}
	);
}

//컨퍼넌트 초기화
function initComponent() {
	$("#srcConfirmStartDate").val("<%=srcConfirmStartDate%>");
	$("#srcConfirmEndDate").val("<%=srcConfirmEndDate%>");
	
	// 그리드 조회
	fnInitJqGridComponent();
}
</script>

<!-- 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcVendorId = $('#srcVendorId').val();
	data.srcGoodName = $('#srcGoodName').val();
	data.srcConfirmStartDate = $('#srcConfirmStartDate').val();
	data.srcConfirmEndDate = $('#srcConfirmEndDate').val();
	data.srcChnPriceClas = $('#srcChnPriceClas').val();
	data.srcAppStsFlag = $('#srcAppStsFlag').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function fnApproval(AppStsFlag) {
	var msg = "";
	if(AppStsFlag == "1") {
		//승인
		msg = "처리완료";
	} else if(AppStsFlag == "2") {
		//반려
		msg = "반려";
	}
	
	var app_good_id_array = new Array();
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if(jq("#isCheck_"+rowid).attr("checked")) {
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				if(selrowContent.app_sts_flag != "0") {
					alert("승인상태가 '요청'인 것만 처리가 가능합니다.");
					return;
				}
				app_good_id_array[arrRowIdx] = selrowContent.app_good_id;
				arrRowIdx++;
			}
		}
		if (arrRowIdx == 0 ) {
			jq("#dialogSelectRow").dialog();
			return; 
		}
		if(!confirm("선택된 요청정보를 "+msg+" 하시겠습니까?")) return;
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH%>/productApp/productAppStatusTransGrid.sys',
			{ app_good_id_array:app_good_id_array
			, app_sts_flag:AppStsFlag }
			,function(arg) {
				if(fnAjaxTransResult(arg)) {
					alert("정상적으로 "+msg+" 처리가 되었습니다.");
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	}
}

// 새로고침 
function fnReLoadDataGrid() {
    jq("#list").trigger("reloadGrid");
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['단가변경요청','상품명','상품코드','단가변경타입','기존단가','변경단가','변경사유','승인상태',
							'등록자','등록일','확인자','확인일','승인자','승인일','단가변경타입Cd','승인상태Cd',
							'공급사','공급사Id','등록자Id','확인자Id','승인자Id','요청Seq','진열Seq'];//출력컬럼명
	var colIds = ['app_good_id','good_name','good_iden_numb','apptypenm','before_price','after_price','change_reason','appstsnm',
						'register_usernm','register_date','confirm_usernm','confirm_date','app_usernm','app_date','chn_price_clas','app_sts_flag',
						'vendornm','vendorid','register_userid','confirm_userid','app_userid','fix_good_id','disp_good_id'];//출력컬럼ID
	var numColIds = ['app_good_id','good_iden_numb','before_price','after_price','fix_good_id','disp_good_id'];//숫자표현ID
	var sheetTitle = "단가변경요청승인정보";//sheet 타이틀
	var excelFileName = "AppGoodPriceList";//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<!-------------------------------- Dialog Div Start -------------------------------->
<%
/**------------------------------------공급사팝업 사용방법---------------------------------
 * fnBuyborgDialog(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
 * borgNm : 찾고자하는 공급사명
 * callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
 */
%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp"%>
<script type="text/javascript">
/**
 * 공급사 검색
 */
function fnSearchVendor() {
 	var vendorNm = $("#srcVendorNm").val();
 	fnVendorDialog(vendorNm, "fnCallBackVendor");
}
/**
 * 공급사 선택 콜백
 */
function fnCallBackVendor(vendorId, vendorNm, areaType) {
	$("#srcVendorId").val(vendorId);
	$("#srcVendorNm").val(vendorNm);
}
</script>
<!-------------------------------- Dialog Div End -------------------------------->

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function fnInitJqGridComponent() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/productApp/productAppListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['선택','변경요청번호','상품명','상품코드','단가변경타입','기존단가','변경단가','변경사유','승인상태'
					,'등록자','등록일','확인자','확인일','승인자','승인일','단가변경타입Cd','승인상태Cd','공급사','공급사Id','등록자Id','확인자Id','승인자Id','요청Seq','진열Seq'],
		colModel:[
			{ name:'isCheck',index:'isCheck',width:30,align:"center",search:false,sortable:false,editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter },
			{ name:'app_good_id',index:'app_good_id',width:80,align:"left",search:false,sortable:false,editable:false,key:true },//상품변경요청Seq
			{ name:'good_name',index:'good_name',width:240,align:"left",search:false,sortable:true,editable:false },//상품명
			{ name:'good_iden_numb',index:'good_iden_numb',width:60,align:"center",search:false,sortable:true,editable:false },//상품코드
			{ name:'apptypenm',index:'apptypenm',width:80,align:"center",search:false,sortable:false,editable:false },//단가변경타입
			{ name:'before_price',index:'before_price',width:70,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" }
			},//기존단가
			{ name:'after_price',index:'after_price',width:70,align:"right",search:false,sortable:false
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"",thousandsSeparator:",",decimalPlaces:0,prefix:"" }
			},//변경단가
			{ name:'change_reason',index:'change_reason',width:240,align:"left",search:false,sortable:false,editable:false },//변경사유
			{ name:'appstsnm',index:'appstsnm',width:60,align:"center",search:false,sortable:false,editable:false },//승인상태
			{ name:'register_usernm',index:'register_usernm',width:60,align:"center",search:false,sortable:true,editable:false },//등록자
			{ name:'register_date',index:'register_date',width:60,align:"center",search:false,sortable:true
				,editable:false,formatter:"date"
			},//등록일
			{ name:'confirm_usernm',index:'confirm_usernm',width:60,align:"center",search:false,sortable:true,editable:false },//확인자
			{ name:'confirm_date',index:'confirm_date',width:60,align:"center",search:false,sortable:true
				,editable:false,formatter:"date"
			},//확인일
			{ name:'app_usernm',index:'app_usernm',width:60,align:"center",search:false,sortable:true,editable:false },//승인자
			{ name:'app_date',index:'app_date',width:60,align:"center",search:false,sortable:true
				,editable:false,formatter:"date"
			},//승인일
			
			{ name:'chn_price_clas',index:'chn_price_clas',hidden:true,search:false },//단가변경타입Cd
			{ name:'app_sts_flag',index:'app_sts_flag',hidden:true,search:false },//승인상태Cd
			{ name:'vendornm',index:'vendornm',hidden:true,search:false },//공급사
			{ name:'vendorid',index:'vendorid',hidden:true,search:false },//공급사Id
			{ name:'register_userid',index:'register_userid',hidden:true,search:false },//등록자Id
			{ name:'confirm_userid',index:'confirm_userid',hidden:true,search:false },//확인자Id
			{ name:'app_userid',index:'app_userid',hidden:true,search:false },//승인자Id
			{ name:'fix_good_id',index:'fix_good_id',hidden:true,search:false },//요청Seq
			{ name:'disp_good_id',index:'disp_good_id',hidden:true,search:false }//진열Seq
		],
		postData: {
			srcVendorId:$('#srcVendorId').val(),
			srcGoodName:$('#srcGoodName').val(),
			srcConfirmStartDate:$('#srcConfirmStartDate').val(),
			srcConfirmEndDate:$('#srcConfirmEndDate').val(),
			srcChnPriceClas:$('#srcChnPriceClas').val(),
			srcAppStsFlag:$('#srcAppStsFlag').val()
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight%>,autowidth:true,
		sortname:'good_name',sortorder:'desc',
		caption:"상품승인조회",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {},
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			var cm = $("#list").jqGrid('getGridParam','colModel');
			if(cm[iCol]!=undefined && cm[iCol].index == 'app_good_id') {
			    fnAppGoodView('<%=menuId%>',cellcontent);
			}
		},
		afterInsertRow:function(rowid,aData) {
			jq("#list").setCell(rowid,'app_good_id','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'app_good_id','',{cursor:'pointer'});
		},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
};
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' offval='no' style='border:none;'/>";
}
//그리드 커서
function pointercursor(cellvalue, options, rowObject) {
	var new_formatted_cellvalue = '<span class="pointer">' + cellvalue + '</span>';
	return new_formatted_cellvalue;
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm" method="post" onsubmit="return false;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">상품승인조회</td>
				<td align="right" class="ptitle">
					<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
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
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="6" class="table_top_line"></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">공급사</td>
				<td class="table_td_contents">
					<input id="srcVendorNm" name="srcVendorNm" type="text" value="" size="" maxlength="50" style="width:120px;" />
					<input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
					<img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20;height:18px;border:0;" align="middle" class="icon_search" /></td>
				<td class="table_td_subject" width="100">상품명</td>
				<td class="table_td_contents">
					<input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" /></td>
				<td class="table_td_subject" width="100">확인일자</td>
				<td class="table_td_contents">
					<input id="srcConfirmStartDate" name="srcConfirmStartDate" type="text" style="width: 75px;" /> ~
					<input id="srcConfirmEndDate" name="srcConfirmEndDate" type="text" style="width: 75px;" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">단가변경타입</td>
				<td class="table_td_contents">
					<select id="srcChnPriceClas" name="srcChnPriceClas" style="width:120px;" class="select">
						<option value="">전체</option>
					</select></td>
				<td class="table_td_subject">승인상태</td>
				<td colspan="3" class="table_td_contents">
					<select id="srcAppStsFlag" name="srcAppStsFlag" style="width:120px;" class="select">
						<option value="">전체</option>
					</select></td>
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
<tr>
	<td height="5"></td>
</tr>
<tr>
	<td height="27px" align="right" valign="bottom">
<%-- 		<img id="appButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_approve.gif" style="width:65px;height:22px;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" /> --%>
<%-- 		<img id="retButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type4_return.gif" style="width:65px;height:22px;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" /> --%>
		<button id='appButton' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>">승인</button>
		<button id='retButton' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>">반려</button>
<%-- 		<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> --%>
<%-- 		<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 		<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
<%-- 		<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> --%>
	</td>
</tr>
<tr><td height="1"></td></tr>
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
</body>
</html>