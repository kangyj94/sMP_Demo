<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="kr.co.bitcube.organ.dto.SmpVendorsDto"%>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-380 + Number(gridHeightResizePlus)";
	String listWidth  = "500";
	String list2Width = "986";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
    String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>

<!------------------------------- 다른조직 사용자 추가 ------------------------------->
<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
<script type="text/javascript">
$(function(){
	$('#dialogPop').jqm();	//Dialog 초기화
	$("#saveButton").click(function(){
		$('#dialogPop').jqmShow();	//필수
// 		fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString, clientId, clientNm);
		fnJqmUserInitSearch("", "", "", "fnSelectUserCallback", "", "");
	});
});

/**
 * 사용자검색 Callback Function(반드시 있어야 함)	//필수
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	var row = $("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		if(!confirm("선택한 사용자을 등록하시겠습니까?")) return;
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/userTransGrid.sys", 
			{ oper:"addSys", svcTypeCd:"VEN", id:userId, borgId:selrowContent.vendorId, loginId:loginId },
			function(arg){ 
				$('#dialogPop').jqmHide();
				if(fnAjaxTransResult(arg)) {	//성공시
					$("#list2").trigger("reloadGrid");
				}
			}
		);
	} else {
		$('#dialogPop').jqmHide();
		$("#dialogSelectRow").dialog();
	}	
}
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(	//조회조건의 권역세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/getCodeList.sys',
		{codeTypeCd:"DELI_AREA_CODE", isUse:"1"},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			for(var i=0;i<codeList.length;i++) {
				$("#srcAreaType").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
			initList();	//그리드 초기화
		}
	);
	$("#srcVendorNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { 
		$("#srcVendorNm").val($.trim($("#srcVendorNm").val()));
		fnSearch(); 
	});
	$("#srcBusinessNum").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { 
		$("#srcBusinessNum").val($.trim($("#srcBusinessNum").val()));
		fnSearch(); 
	});
	$("#srcAreaType").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcIsUse").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click( function() { fnSearch(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#regButton").click(function(){ addRow(); });
	$("#modButton").click(function(){ onDetail(); });
	
	$("#colButton2").click( function() { jq("#list2").jqGrid('columnChooser'); });
	$("#excelButton2").click(function(){ exportExcel2(); });
	$("#regButton2").click(function(){ addUser2(); });
	$("#modButton2").click(function(){ onDetail2(); });
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight%>);
	$("#list2").setGridWidth(<%=list2Width%>);
	$("#list2").setGridHeight(<%=listHeight %>+25);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
var staticNum = 0;	//list2, 그리드를 한번만 초기화하기 위해
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organVendorListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['업체코드', '공급사명', '사업자등록번호', '권역', '상태', '대표전화번호', '대표자명', '우편번호', '주소', '등록일', 'vendorId'],
		colModel:[
			{name:'vendorCd',index:'vendorCd', width:70,align:"center",search:false,sortable:true, 
				editable:false 
			},	//업체코드
			{name:'vendorNm',index:'vendorNm', width:150,align:"left",search:false,sortable:true, 
				editable:false 
			},	//공급사명
			{name:'businessNum',index:'businessNum', width:90,align:"center",search:false,sortable:true, 
				editable:false 
			},	//사업자등록번호
			{name:'areaTypeNm',index:'areaTypeNm', width:50,align:"center",search:false,sortable:true, 
				editable:false 
			},	//권역
			{name:'isUse',index:'isUse', width:40,align:"center",search:false,sortable:true,
				editable:false 
			},	//상태
			{name:'phoneNum',index:'phoneNum', width:80,align:"center",search:false,sortable:true,
				editable:false
			},	//대표전화번호
			{name:'pressentNm',index:'pressentNm', width:80,align:"center",search:false,sortable:true, 
				editable:false 
			},	//대표자명
			{name:'postAddrNum',index:'postAddrNum', width:50,align:"center",search:false,sortable:true, 
				editable:false 
			},	//우편번호
			{name:'addres',index:'addres', width:200,align:"left",search:false,sortable:true,
				editable:false 
			},	//주소
			{name:'createDate',index:'createDate', width:80,align:"center",search:false,sortable:true, 
				editable:false 
			},	//등록일
			{name:'vendorId',index:'vendorId', hidden:true
			}	//vendorId
		],
		postData: {
			srcVendorNm:$("#srcVendorNm").val(),
			srcBusinessNum:$("#srcBusinessNum").val(),
			srcAreaType:$("#srcAreaType").val(),
			srcIsUse:$("#srcIsUse").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100,500,1000,3000,5000], pager: '#pager',
		height: <%=listHeight%>, width:<%=listWidth%>,
		sortname: 'vendorId', sortorder: "desc",
		caption:"공급사 조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
				var srcVendorId = selrowContent.vendorId;
				var srcVendorNm = selrowContent.vendorNm;
				if(staticNum==0) {
					initUserList(srcVendorId,srcVendorNm);
					staticNum++;
				}
				jq("#list").setSelection(top_rowid);
			} else {
				jq("#list2").clearGridData();
				jq("#list2").jqGrid("setCaption","&nbsp;");
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var srcVendorId = selrowContent.vendorId;
			var srcVendorNm = selrowContent.vendorNm;
			fnOnClickUserList(srcVendorId,srcVendorNm);
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","onDetail();")%>
		},
		afterInsertRow: function(rowid, aData){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {phoneNum: fnSetTelformat(selrowContent.phoneNum)});
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}
var _vendorNm = "";
function initUserList(srcVendorId,srcVendorNm) {
	_vendorNm = srcVendorNm;
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/organ/organVendorUserListJQGrid.sys', 
		datatype: 'json',
		mtype: 'POST',
		colNames:['공급사', '권역', '사용자명', '사용자ID', '상태', '로그인여부', '전화번호', '이동전화번호','Email발송','SMS발송', '등록일', 'userId', 'borgId'],
		colModel:[
			{name:'vendorNm',index:'vendorNm', width:150,align:"left",search:false,sortable:true, 
				editable:false 
			},	//공급사
			{name:'areaTypeNm',index:'areaTypeNm', width:50,align:"center",search:false,sortable:true,
				editable:false 
			},	//권역
			{name:'userNm',index:'userNm', width:60,align:"center",search:false,sortable:true,
				editable:false 
			},	//사용자명.
			{name:'loginId',index:'loginId', width:60,align:"center",search:false,sortable:true,
				editable:false 
			},	//사용자ID
			{name:'isUse',index:'isUse', width:40,align:"center",search:false,sortable:true,
				editable:false 
			},	//상태
			{name:'isLogin',index:'isLogin', width:60,align:"center",search:false,sortable:true,
				editable:false 
			},	//로그인여부
			{name:'tel',index:'tel', width:80,align:"center",search:false,sortable:true,
				editable:false 
			},	//전화번호
			{name:'mobile',index:'mobile', width:80,align:"center",search:false,sortable:true,
				editable:false
			},	//이동전화번호
			{name:'isEmail',index:'isEmail', width:70,align:"center",sortable:true,
				editable:false,
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}
			},	//EMAIL발송
			{name:'isSms',index:'isSms', width:70,align:"center",sortable:true,
				editable:false,
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}
			},	//SMS발송
			{name:'createDate',index:'createDate', width:80,align:"center",search:false,sortable:true,
				editable:false
			},	//등록일
			{name:'userId',index:'userId', hidden:true 
			},	//userId
			{name:'borgId',index:'borgId', hidden:true 
			}	//borgId
		],
		postData: {
			srcVendorId:srcVendorId
		},
		rowNum:0, rownumbers: false,
		height: <%=listHeight%>+25 ,width:<%=list2Width%>,
		sortname: 'userId', sortorder: "desc",
		caption:"<font color='blue'>["+srcVendorNm+"]</font> 공급사 사용자 리스트 ", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","onDetail2();")%>
		},

		afterInsertRow: function(rowid, aData){
			var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
			
			//전화번호 형식으로 변경
			jq("#list2").jqGrid('setRowData', rowid, {tel: fnSetTelformat(selrowContent.tel)});
			jq("#list2").jqGrid('setRowData', rowid, {mobile: fnSetTelformat(selrowContent.mobile)});
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : {root: "list",repeatitems: false,cell: "cell"}
	}); 
}
function fnOnClickUserList(srcVendorId,srcVendorNm) {
	_vendorNm = srcVendorNm;
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcVendorId = srcVendorId;
	jq("#list2").jqGrid("setCaption", "<font color='blue'>["+srcVendorNm+"]</font> 공급사 사용자 리스트 ");
	jq("#list2").jqGrid("setGridParam", { "postData": data2 });
	jq("#list2").trigger("reloadGrid");
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcBusinessNum = $("#srcBusinessNum").val();
	data.srcAreaType = $("#srcAreaType").val();
	data.srcVendorNm = $("#srcVendorNm").val();
	data.srcIsUse = $("#srcIsUse").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organVendorDetail.sys?vendorId=" + selrowContent.vendorId + "&_menuId=<%=_menuId%>";
		var popproperty = "dialogWidth:920px;dialogHeight=550px;scroll=yes;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
		window.open(popurl, 'okplazaPop', 'width=920, height=550, scrollbars=yes, status=no, resizable=no');
// 	    fnSearch();
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function addRow(){
	var popurl = "/organ/organVendorReg.sys?_menuId=<%=_menuId%>";
	var popproperty = "dialogWidth:950px;dialogHeight=880px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=950, height=880, scrollbars=yes, status=no, resizable=no');
//     fnSearch();	
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['업체코드', '공급사명', '사업자등록번호', '권역', '상태', '대표전화번호', '대표자명', '우편번호', '주소', '등록일'];	//출력컬럼명
	var colIds = ['vendorCd','vendorNm','businessNum','areaTypeNm','isUse','phoneNum','pressentNm','postAddrNum','addres','createDate'];	//출력컬럼ID
	var numColIds = ['businessNum','phoneNum','postAddrNum'];	//숫자표현ID
	var sheetTitle = "공급사 조회";	//sheet 타이틀
	var excelFileName = "organVendorList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH%>"); //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}


function onDetail2(){
	var row = jq("#list2").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list2").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/selectVendorUserDetail.sys?borgId=" + selrowContent.borgId + "&userId=" + selrowContent.userId + "&_menuId=<%=_menuId %>";
		var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
// 	    window.showModalDialog(popurl,self,popproperty);
	    window.open(popurl, 'okplazaPop', 'width=600, height=650, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function addUser2(){
	var popurl = "/organ/organVendorUserReg.sys?_menuId=<%=_menuId %>";
	var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
//     window.showModalDialog(popurl,self,popproperty);
	window.open(popurl, 'okplazaPop', 'width=600, height=650, scrollbars=yes, status=no, resizable=no');
    fnSearch();
}

/**
 * list Excel Export
 */
function exportExcel2() {
	var colLabels = ['공급사', '권역', '사용자명', '사용자ID', '상태', '로그인여부', '전화번호', '이동전화번호', 'Email발송', 'SMS발송','등록일'];	//출력컬럼명
	var colIds = ['vendorNm','areaTypeNm','userNm','loginId','isUse','isLogin','tel','mobile','isEmail','isSms','createDate'];	//출력컬럼ID
	var numColIds = ['tel','mobile'];	//숫자표현ID
	var sheetTitle = "공급사 사용자 조회";	//sheet 타이틀
	var excelFileName = "organVendorUserList";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

</head>
<body>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
   <form id="frm" name="frm">
      <table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="1500px" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>공급사 관리</td>
                     <td align="right">
                        <a href="#"> <img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22"
                              style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
                        </a>
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
                     <td colspan="8" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">공급사명</td>
                     <td class="table_td_contents">
                        <input id="srcVendorNm" name="srcVendorNm" type="text" size="20" maxlength="50" />
                     </td>
                     <td class="table_td_subject" width="100">사업자등록번호</td>
                     <td class="table_td_contents">
                        <input id="srcBusinessNum" name="srcBusinessNum" type="text" size="20" maxlength="50" />
                     </td>
                     <td width="80" class="table_td_subject">권역</td>
                     <td class="table_td_contents">
                        <select id="srcAreaType" name="srcAreaType" class="select">
                           <option value="">전체</option>
                        </select>
                     </td>
                     <td width="80" class="table_td_subject">상태</td>
                     <td class="table_td_contents">
                        <select id="srcIsUse" name="srcIsUse" class="select">
                           <option value="1">정상</option>
                           <option value="0">종료</option>
                           <option value="">전체</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="8" class="table_top_line"></td>
                  </tr>
               </table>
               <!-- 컨텐츠 끝 -->
            </td>
         </tr>
         <tr>
            <td height="5"></td>
         </tr>
		<tr>
			<td>
				<table width="1500px" border="0">
					<tr>
			            <td align="right" width="510" valign="bottom">
			               	<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15"
			                    style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> 
							<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" 
								style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a> 
							<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15"
			                    style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a> 
							<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" 
								style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
			            </td>
			            <td align="right" width="100%" valign="bottom">
							<a href="#"><img id="regButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
							<a href="#"><img id="modButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
							<a href="#"><img id="saveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Boss.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
							<a href="#"><img id="colButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
							<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
			            </td>
					</tr>
					<tr>
						<td valign="top">
			               <div id="jqgrid">
			                  <table id="list"></table>
			                  <div id="pager"></div>
			               </div>
			            </td>
						<td valign="top">
							<div id="jqgrid" style="padding-left:10px;">
								<table id="list2"></table>
							</div>
			            </td>
					</tr>
				</table>
				<div id="dialog" title="Feature not supported" style="display:none;">
					<p>That feature is not supported.</p>
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