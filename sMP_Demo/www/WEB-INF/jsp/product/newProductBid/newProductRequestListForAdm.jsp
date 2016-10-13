<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto"%>
<%@ page import="kr.co.bitcube.common.dto.UserDto"%>
<%@ page import="java.util.List"%>
<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");				// 사용자 권한
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);	// 사용자 정보
	String strTitle = "";
	if("ADM".equals(loginUserDto.getSvcTypeCd())) {
		strTitle = "구매사상품등록요청 조회";
	} else {
		strTitle = "구매사상품등록요청 이력";
	}
	
	//그리드의 width와 Height을 정의
	String categoryHeightMinus = loginUserDto.getSvcTypeCd().equals("BUY") ? "-45" : "+0";
	String listHeight = "$(window).height()-390 + Number(gridHeightResizePlus)"+categoryHeightMinus;
	String listWidth = "$(window).width()-55 + Number(gridWidthResizePlus)";
	
	//메뉴Id
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	// 날짜 세팅
	String srcInsert_FromDt = CommonUtils.getCustomDay("DAY", -7);
	String srcInsert_EndDt = CommonUtils.getCurrentDate();
	
	String state = CommonUtils.getString(request.getParameter("flag1"));
	String startDate = CommonUtils.getString(request.getParameter("startDate"));
	String endDate = CommonUtils.getString(request.getParameter("endDate"));
	
	// 2016-03-09 상품등록 요청 조회 조건 - 진행상태 : 전체 -> 요청 , 요청일자 1주 --> 1년  
	boolean isExistSrcFlag = false;
	try{
		isExistSrcFlag	=	Boolean.parseBoolean(CommonUtils.getString(request.getParameter("srcFlag")));
	}catch(Exception e){
		isExistSrcFlag = false;
	}
	if(isExistSrcFlag){
		state 		= "10";
		startDate 	= CommonUtils.getCustomDay("YEAR", -1);
		endDate 	= CommonUtils.getCurrentDate();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<%
/**------------------------------------구매사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 구매사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 구매사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 구매사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<!-- 구매사검색관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
<%
	String _srcGroupId = "";
	String _srcClientId = "";
	String _srcBranchId = "";
	String _srcBorgNms = "";
	SrcBorgScopeByRoleDto srcBorgScopeByRoleDto = null;
	String _srcInsertUserId = "";
	String _srcBorgNmsDisabled = "false";
	String _srcBorgNmsCalss = "input_text";
	String _btnBuyBorgDisplay = "false";
	if("BUY".equals(loginUserDto.getSvcTypeCd()) || "VEN".equals(loginUserDto.getSvcTypeCd())) {
		srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
		_srcGroupId = srcBorgScopeByRoleDto.getSrcGroupId();
		_srcClientId = srcBorgScopeByRoleDto.getSrcClientId();
		_srcBranchId = srcBorgScopeByRoleDto.getSrcBranchId();
		_srcBorgNms = srcBorgScopeByRoleDto.getSrcBorgNms();
		_srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
		_srcInsertUserId = loginUserDto.getUserId();
		if(Integer.parseInt(srcBorgScopeByRoleDto.getBorgScopeCd()) <= 6000) {
			_btnBuyBorgDisplay = "none";
			_srcBorgNmsDisabled = "true";
			_srcBorgNmsCalss = "input_text_none";
		}
	}
%>
	$("#srcGroupId").val("<%=_srcGroupId %>");
	$("#srcClientId").val("<%=_srcClientId %>");
	$("#srcBranchId").val("<%=_srcBranchId %>");
	$("#srcInsertUserId").val("<%=_srcInsertUserId %>");
	$("#srcBorgName").val("<%=_srcBorgNms %>");
	if('<%=_srcBorgNmsDisabled %>' == "true") {
		$("#srcBorgName").attr("disabled", '<%=_srcBorgNmsDisabled %>');
		$("#srcBorgName").attr("class", '<%=_srcBorgNmsCalss %>');
		$("#btnBuyBorg").css("display","<%=_btnBuyBorgDisplay %>");
	}
	
	$("#btnBuyBorg").click(function() {
		var borgNm = $("#srcBorgName").val(); 
		fnBuyborgDialog("", "", borgNm, "fnCallBackBuyBorg"); 
	});
});
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm, areaType) {
// 	alert("groupId : "+groupId+", clientId : "+clientId+", branchId : "+branchId+", borgNm : "+borgNm+", areaType : "+areaType);
	$("#srcGroupId").val(groupId);
	$("#srcClientId").val(clientId);
	$("#srcBranchId").val(branchId);
	$("#srcBorgName").val(borgNm);
}
</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------사용자팝업 사용방법---------------------------------
* fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* userNm : 찾고자하는 사용자명
* loginId : 찾고자하는 사용자 Login Id
* svcTypeCd : 찾는사용자의 서비스코드("BUY":구매사, "VEN":공급사, "ADM":운영사, "CEN":물륫센타)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(사용자일련번호, 조직일련번호, 서비스유형명, 사용자명, 로그인아이디, 조직명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(document).ready(function(){
	$("#btnUser").click(function(){
		var userNm = $("#srcInsertUserName").val();
		var loginId = "";
		var svcTypeCd = "BUY";
		fnJqmUserInitSearch(userNm, loginId, svcTypeCd, "fnSelectUserCallback");
	});
	$("#srcInsertUserName").keydown(function(e) { if(e.keyCode==13) { $("#btnUser").click(); } });
	$("#srcInsertUserName").change(function(e) {	$("#srcInsertUserName").val(""); $("#srcInsertUserId").val(""); });
});
/**
 * 사용자검색 Callback Function
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	$("#srcInsertUserName").val(userNm);
	$("#srcInsertUserId").val(userId);
}
</script>
<% //------------------------------------------------------------------------------ %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcBorgName").keydown(function(e){ if(e.keyCode==13) { $("#btnBuyBorg").click(); }});
	$('#srcBorgName').change(function(e) { $('#srcBorgName').val('');	$('#srcGroupId').val('0'); $('#srcClientId').val('0'); $('#srcBranchId').val('0'); });
	$("#srcStand_good_name").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcState").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcStand_good_spec_desc").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#addButton").click(function() { fnReqProductInsert(); });
	
	$.post(  //조회조건의 구매사상품등록요청상태 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{codeTypeCd:"NEW_PROD_STATE", isUse:"1"},
		function(arg) {
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcState").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			var state = "<%=state%>";
			if(state != ""){
 				$("#srcState").val(state);
			}
			initList(); //그리드 초기화
		}
	);
	
	
	$("#srcBorgName").change(function(e) {
		if($("#srcBorgName").val()=="") {
			$("#srcGroupId").val("0");
			$("#srcClientId").val("0");
			$("#srcBranchId").val("0");
		}
	});

	$("#srcButton").click( function() {
		$("#srcStand_good_name").val($.trim($("#srcStand_good_name").val()));
		$("#srcStand_good_spec_desc").val($.trim($("#srcStand_good_spec_desc").val()));
		fnSearch();
	});
	
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	
	// 날짜 세팅
	<%if(!"".equals(state)){ %>
		$("#srcInsert_FromDt").val("<%=startDate%>");
		$("#srcInsert_EndDt").val("<%=endDate%>");
	<%}else{%>
		$("#srcInsert_FromDt").val("<%=srcInsert_FromDt%>");
		$("#srcInsert_EndDt").val("<%=srcInsert_EndDt%>");
	<%}%>
});

//날짜 조회 및 스타일
$(function() {
	$("#srcInsert_FromDt").datepicker( {
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcInsert_EndDt").datepicker( {
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
<%-- 	$("#list").setGridWidth(<%=listWidth %>); --%>
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/newProductRequestListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['요청번호','상품명','상품규격','요청일자','진행상태','상품코드','요청조직','요청조직id','요청자','진행상태Cd'],
		colModel:[
			{ name:'newgoodid',index:'newgoodid',width:60,align:"center",search:false,sortable:true,classes:'pointer' },//요청번호
			{ name:'stand_good_name',index:'stand_good_name',width:200,align:"left",search:false,sortable:true,editable:false },//상품명
			{ name:'stand_good_spec_desc',index:'stand_good_spec_desc',width:200,align:"left",search:false,sortable:true,editable:false },//상품규격
			{ name:'insert_date',index:'insert_date',width:70,align:"center",search:false,sortable:true,editable:false },//요청일자
			{ name:'stateNm',index:'stateNm',width:80,align:"center",search:false,sortable:true,editable:false },//진행상태
			{ name:'good_iden_numb',index:'good_iden_numb',width:80,align:"center",search:false,sortable:true,editable:false },//상품코드
			{ name:'userBorgNm',index:'userBorgNm',width:240,align:"left",search:false,sortable:true,editable:false },//등록조직
			{ name:'insert_borgid',index:'insert_borgid',hidden:true},//등록조직id
			{ name:'userId',index:'userId',width:60,align:"center",search:false,sortable:true,editable:false },//등록자
			
			{ name:'state',index:'state',align:'center',search:false,hidden:true }//진행상태Cd
		],
		postData: {
			srcInsert_FromDt:$("#srcInsert_FromDt").val(),
			srcInsert_EndDt:$("#srcInsert_EndDt").val(),
			srcGroupId:'<%=_srcGroupId %>',
			srcClientId:'<%=_srcClientId %>',
			srcBranchId:'<%=_srcBranchId %>',
			srcInsertUserId:'<%=_srcInsertUserId %>',
			srcState:$("#srcState").val()
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:<%=listHeight%>,width:$(window).width()-55 + Number(gridWidthResizePlus),
		sortname:'newgoodid',sortorder:'desc',
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				for(var i=0; i<rowCnt; i++) {
					var rowid = $("#list").getDataIDs()[i];
					var selrowContent = jq("#list").jqGrid('getRowData',rowid);
					var bidid = selrowContent.bidid;
					if(bidid==0) {
						jq("#list").jqGrid('setRowData', rowid, {bidid:""});
					}
				}
			}
		},
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			var cm = $("#list").jqGrid('getGridParam','colModel');
			var newgoodid = FNgetGridDataObj('list' , rowid , 'newgoodid');
			
			if(cm[iCol]!=undefined && cm[iCol].index == 'newgoodid') {
				fnReqProductDetail(rowid);
			}
			if(cm[iCol]!=undefined && cm[iCol].index == 'good_iden_numb') {
				fnProductDetail(rowid);
			}
			
			if(cm[iCol]!=undefined && cm[iCol].index == 'bidid'){
				var bidid = FNgetGridDataObj('list' , rowid , 'bidid');
				if(bidid != '') {
					editRow(rowid ,'');
				}
			}
		},
		afterInsertRow:function(rowid, aData) {
			jq("#list").setCell(rowid,'newgoodid','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'newgoodid','',{cursor:'pointer'});
			
			jq("#list").setCell(rowid,'bidid','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'bidid','',{cursor:'pointer'});
			
			jq("#list").setCell(rowid,'good_iden_numb','',{color:'#0000ff'});
			jq("#list").setCell(rowid,'good_iden_numb','',{cursor:'pointer'});
		},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
		
	}); 
	jQuery("#list").jqGrid('setGridWidth', 1500);
}
</script>
<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
// 신규 품목 요청 
function fnReqProductInsert() {
	var popurl = "/product/newProductRequestDetail.sys?_menuId="+<%=menuId %>;
	var popproperty = "dialogWidth:900px;dialogHeight=350px;scroll=yes;status=no;resizable=yes;";
// 	window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=900, height=350, scrollbars=yes, status=no, resizable=no');
}

// 구매사상품등록요청 상세 
function fnReqProductDetail(pRowid) {
	var selrowContent = jq("#list").jqGrid('getRowData',pRowid);
	var newgoodid = selrowContent.newgoodid;
	var popurl = "/product/newProductRequestDetail.sys?_menuId="+<%=menuId %>+"&newgoodid="+newgoodid;
	var popproperty = "dialogWidth:1000px;dialogHeight=520px;scroll=yes;status=no;resizable=no;";
	window.open(popurl, 'okplazaPop', 'width=1000, height=520, scrollbars=yes, status=no, resizable=no');
// 	window.showModalDialog(popurl,self,popproperty);
}
function fnCreateBidProcess(newgoodid) {
	var popurl = "/product/newProductBidRegist.sys?_menuId="+<%=menuId %>+"&newgoodid="+newgoodid;
	var popproperty = "dialogWidth:1000px;dialogHeight=600px;scroll=yes;status=no;resizable=no;";
	window.open(popurl, 'okplazaPop', 'width=1000, height=600, scrollbars=yes, status=no, resizable=no');
// 	window.showModalDialog(popurl,self,popproperty);
}

// 입찰 상세 페이지 호출 
function editRow(rowid, vendorid) {
    
	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	var bidid = selrowContent.bidid;
	var popurl = "";
	if(vendorid == "") {
		popurl = "/product/venProductTendorRegist.sys?_menuId="+<%=menuId%>+"&bidid="+bidid;
	} else {
		popurl = "/product/venProductTendorRegist.sys?_menuId="+<%=menuId%>+"&bidid="+bidid+"&vendorid="+vendorid;
	}
	var popproperty = "dialogWidth:930px;dialogHeight=700px;scroll=yes;status=no;resizable=no;";
	window.showModalDialog(popurl,self,popproperty);
// 	window.open(popurl, 'okplazaPop', 'width=930, height=700, scrollbars=yes, status=no, resizable=no');
}

function fnSuccessBidProcess() {
	jq("#list").trigger("reloadGrid");

}

// 신규 상품 요청의 상품코드
function fnProductDetail(pRowid) {
 	var selrowContent = jq("#list").jqGrid('getRowData',pRowid);
 	var good_iden_numb = selrowContent.good_iden_numb;
 	if(good_iden_numb == "") { return; }
 	
	if('<%=loginUserDto.getSvcTypeCd()%>' == 'ADM') {
		fnProductDetailView('<%=menuId %>',good_iden_numb,'','','');
	} else if('<%=loginUserDto.getSvcTypeCd()%>' == 'BUY') {
	 	$('#frm').attr('action','/product/buyProductSearch.sys');
	 	$('#frm').attr('Target','_self');
	 	$('#frm').attr('method','post');
	 	$('#srcType').val('productCode');
	 	$('#srcCateId').val('0');
	 	$('#srcGoodIdenNumb').val(good_iden_numb);
	 	$('#frm').submit();
	}
}

function fnSuccessBidAuctionProcess() {
	jq("#list").trigger("reloadGrid");
}

function fnSuccessProductDetailView(menuId,good_iden_numb,vendorid,bidid,vendorid) {
	fnProductDetailView(menuId,good_iden_numb,vendorid,bidid,vendorid);
}

//상품등록후 그리드 다시 그리기
function fnReLoadDataGrid() {
	jq("#list").trigger("reloadGrid");
}

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcBorgName = $("#srcBorgName").val();
	data.srcGroupId = $("#srcGroupId").val();
	data.srcClientId = $("#srcClientId").val();
	data.srcBranchId = $("#srcBranchId").val();
	data.srcInsert_FromDt = $("#srcInsert_FromDt").val();
	data.srcInsert_EndDt = $("#srcInsert_EndDt").val();
	data.srcStand_good_name = $("#srcStand_good_name").val();
	data.srcState = $("#srcState").val();
	data.srcStand_good_spec_desc = $("#srcStand_good_spec_desc").val();
	data.srcInsertUserId = $("#srcInsertUserId").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function exportExcelToSvc() {
	var colLabels = ['상품명','상품규격','요청일자','진행상태','상품코드','요청조직','요청자']; //출력컬럼명
	var colIds = ['stand_good_name','stand_good_spec_desc','insert_date','stateNm','good_iden_numb','userBorgNm','userId']; //출력컬럼ID
	var numColIds = []; //숫자표현ID
	var sheetTitle = "구매사상품등록요청 조회"; //sheet 타이틀
	var excelFileName = "newProductRequestList"; //file명
	
	var actionUrl = "/product/newProductRequestListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcBorgName';
	fieldSearchParamArray[1] = 'srcGroupId';
	fieldSearchParamArray[2] = 'srcClientId';
	fieldSearchParamArray[3] = 'srcBranchId';
	fieldSearchParamArray[4] = 'srcInsert_FromDt';
	fieldSearchParamArray[5] = 'srcInsert_EndDt';
	fieldSearchParamArray[6] = 'srcStand_good_name';
	fieldSearchParamArray[7] = 'srcState';
	fieldSearchParamArray[8] = 'srcStand_good_spec_desc';
	fieldSearchParamArray[9] = 'srcInsertUserId';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<%@ include file="/WEB-INF/jsp/common/front/productSearch.jsp"%>
<form id="frm" name="frm">
<input id="srcType" name="srcType" type="hidden" value="" />
<input id="srcProductInput" name="srcProductInput" type="hidden" value="" />
<input id="srcGoodIdenNumb" name="srcGoodIdenNumb" type="hidden" value="" />
<input id="srcCateId" name="srcCateId" type="hidden" value="" />
    <table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" />
						</td>
						<td height="29" class="ptitle"><%=strTitle%></td>
                        <td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
	                        <button id='excelAll' type='button' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
	                        <button id='srcButton' type='button' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
						</td>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="4" class="table_top_line"></td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="10%">구매사</td>
						<td class="table_td_contents" width="50%">
							<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="30" style="width: 375px" />
							<input id="srcGroupId" name="srcGroupId" type="hidden" value=""/>
							<input id="srcClientId" name="srcClientId" type="hidden" value=""/>
							<input id="srcBranchId" name="srcBranchId" type="hidden" value=""/>
							<img id="btnBuyBorg" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align:middle;border:0px;cursor:pointer;" />
						</td>
						<td class="table_td_subject" width="10%">요청일자</td>
						<td class="table_td_contents" width="30%">
							<input type="text" name="srcInsert_FromDt" id="srcInsert_FromDt" style="width: 75px; vertical-align: middle;" /> ~ <input type="text" name="srcInsert_EndDt" id="srcInsert_EndDt" style="width: 75px; vertical-align: middle;" />
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject">상품명</td>
						<td class="table_td_contents">
							<input id="srcStand_good_name" name="srcStand_good_name" type="text" value="" size="" maxlength="50" style="width: 400px" />
						</td>
						<td class="table_td_subject">진행상태</td>
						<td class="table_td_contents">
							<select id="srcState" name="srcState" class="select" style="width:130px">
								<option value="">전체</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject">상품규격</td>
						<td class="table_td_contents">
							<input id="srcStand_good_spec_desc" name="srcStand_good_spec_desc" type="text" value="" size="" maxlength="50" style="width: 400px" />
						</td>
						<td class="table_td_subject">요청자</td>
						<td class="table_td_contents">
<%	
	if(srcBorgScopeByRoleDto != null) {
		List<UserDto> _srcUserList = srcBorgScopeByRoleDto.getSrcUserList();
%>
							<select id="srcInsertUserId" name="srcInsertUserId" class="select">
<%		if(Integer.parseInt(srcBorgScopeByRoleDto.getBorgScopeCd()) != 1000) { %>
								<option value="">전체</option>
<%
		}
		for(UserDto userDto:_srcUserList) {
			String _selected = "";
			if(loginUserDto.getUserId().equals(userDto.getUserId())) _selected="selected";
%>
								<option value="<%=userDto.getUserId() %>" <%=_selected %>><%=userDto.getUserNm() %></option>
<%		} %>
							</select>
<%	} else {	%>
							<input id="srcInsertUserName" name="srcInsertUserName" type="text" value="" size="20" maxlength="30" style="width: 100px" />
							<input id="srcInsertUserId" name="srcInsertUserId" type="hidden" value="" size="20" maxlength="30" style="width: 100px" />
							<a href="#">
							<img id="btnUser" src="/img/system/btn_icon_search.gif" width="20" height="18" style="vertical-align: middle;border:0px;" />
							</a>
<%	}	%>
							
						</td>
					</tr>
					<tr>
						<td colspan="4" height="1" bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td colspan="4" class="table_top_line"></td>
					</tr>
                    <tr><td height="10"></td></tr>
				</table>
				<!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list"></table>
					<div id="pager"></div>
				</div>
			</td>
		</tr>
	</table>
	<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
		<p>처리할 데이터를 선택 하십시오!</p>
	</div>
</form>
</body>
</html>