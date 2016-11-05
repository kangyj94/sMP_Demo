<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto" %>
<%@ page import="kr.co.bitcube.common.dto.BorgDto" %>
<%@ page import="java.util.List"%>

<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);

	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-420 + Number(gridHeightResizePlus)";
	String listWidth = "1500";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$.post(	//조회조건의 조직유형 세팅
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
			{codeTypeCd:"SVCTYPECD", isUse:"1"},
			function(arg){
				var codeList = eval('(' + arg + ')').codeList;
				for(var i=0;i<codeList.length;i++) {
					$("#srcSvcTypeCd").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				}
				initList();	//그리드 초기화
			}
		);
	$("#srcButton").click( function() { 
		fnSearch(); 
	});
	$("#srcButton").click( function() { 
		$("#srcUserNm").val($.trim($("#srcUserNm").val()));
		fnSearch(); 
	});
	$("#srcButton").click( function() { 
		$("#srcLoginId").val($.trim($("#srcLoginId").val()));
		fnSearch(); 
	});
	$("#srcSvcTypeCd").keydown(function(e){
		if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcUserNm").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcLoginId").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcIsUse").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#srcButton").click( function() { fnSearch(); });
	$("#modButton").click( function() { editRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
});

//리사이징
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(<%=listWidth%>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemUserManagerListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['서비스유형','사용자명','사용자ID','조직명','상태','로그인여부','전화번호','이동전화번호','Email발송','SMS발송','이메일','등록일','borgId','svcTypeCd','userId'],
		colModel:[
			{name:'svcTypeNm',index:'svcTypeNm', width:60,align:"center",search:false,sortable:true, 
				editable:false 
			},	//서비스유형
			{name:'userNm',index:'userNm', width:60,align:"center",sortable:true, 
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20"}},//사용자명
			{name:'loginId',index:'loginId', width:70,align:"left",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//사용자ID
			{name:'branchNm',index:'branchNm', width:250,align:"left",search:false,sortable:true,
				editable:false 
			},	//조직명
			{name:'isUse',index:'isUse', width:40,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:11,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}},//사용여부
			{name:'isLogin',index:'isLogin', width:60,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:10,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:활성;0:비활성"}},//로그인여부
			{name:'tel',index:'tel', width:70,align:"center",sortable:true,
				editable:true,editrules:{required:false},formoptions:{rowpos:5,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" 999-999-9999"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//전화번호
// 			{name:'tel',index:'tel', width:70,align:"center",sortable:true, editable:false},//전화번호
			{name:'mobile',index:'mobile', width:80,align:"center",sortable:true,
				editable:true,editrules:{required:false},formoptions:{rowpos:6,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" 999-999-9999"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//핸드폰
// 			{name:'mobile',index:'mobile', width:80,align:"center",sortable:true, editable:false},//핸드폰
			{name:'isEmail',index:'isEmail', width:60,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:8,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}},//EMAIL발송
			{name:'isSms',index:'isSms', width:50,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:9,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}},//SMS발송
			{name:'email',index:'email', width:120,align:"left",sortable:true,
				editable:true,editrules:{required:false,email:true},formoptions:{rowpos:7,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" XXXX@XXX.XXX"},
				formatter:'email',editoptions:{size:"30",maxLength:"30",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//이메일
			{name:'createDate',index:'createDate', width:70,align:"center",search:false,sortable:true,
				editable:false 
			},	//등록일
			{name:'borgId',index:'borgId', hidden:true 
			},	//borgId
			{name:'svcTypeCd',index:'svcTypeCd', hidden:true 
			},	//svcTypeCd
			{name:'userId',index:'userId', hidden:true, key:true 
			}	//userId
		],
		postData: {
			srcSvcTypeCd:$("#srcSvcTypeCd").val(),
			srcUserNm:$("#srcUserNm").val(),
			srcLoginId:$("#srcLoginId").val(),
			srcIsUse:$("#srcIsUse").val()
		},
		rowNum:100, rownumbers: false, rowList:[100,3000,5000], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'createDate', sortorder: "desc",
		caption:"사용자 관리", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","editRow();")%>
		},
		afterInsertRow: function(rowid, aData){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {tel: fnSetTelformat(selrowContent.tel)});
			jq("#list").jqGrid('setRowData', rowid, {mobile: fnSetTelformat(selrowContent.mobile)});
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcSvcTypeCd = $("#srcSvcTypeCd").val();
	data.srcUserNm = $("#srcUserNm").val();
	data.srcLoginId = $("#srcLoginId").val();
	data.srcIsUse = $("#srcIsUse").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		if(selrowContent.svcTypeCd == "VEN") {	
			var popurl = "/organ/selectVendorUserDetail.sys?borgId=" + selrowContent.borgId + "&userId=" + selrowContent.userId + "&_menuId=<%=_menuId %>";
			var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
// 		    window.showModalDialog(popurl,self,popproperty);
		    window.open(popurl, 'okplazaPop', 'width=600, height=650, scrollbars=yes, status=no, resizable=no');
		} else if(selrowContent.svcTypeCd == "ADM" || selrowContent.svcTypeCd == "CEN") {	
			var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
			if( row != null ){
		  		jq("#list").jqGrid('setColProp', 'pwd',{hidden:false});
		  		jq("#list").jqGrid('setColProp', 'loginId',{editoptions:{disabled:true}});
		  		jq("#list").jqGrid(
		  			'editGridRow', row,{ 
		  				editCaption: "사용자 수정",
		  				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
		  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/userTransGrid.sys",
		  				editData: {},
						recreateForm: true,beforeShowForm: function(form) {},
						width:"410",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
		   				afterSubmit : function(response, postdata){ 
		   					return fnJqTransResult(response, postdata);
						}
					}
		  		);
		  		jq("#list").jqGrid('setColProp', 'pwd',{hidden:true});
		  		jq("#list").jqGrid('setColProp', 'loginId',{editoptions:{disabled:false}});
		  	} else { jq( "#dialogSelectRow" ).dialog(); }
		 	
		} else if(selrowContent.svcTypeCd == "BUY") {	
			var popurl = "/organ/organUserDetail.sys?borgId=" + selrowContent.borgId + "&userId=" + selrowContent.userId + "&_menuId=<%=_menuId %>";
			var popproperty = "dialogWidth:600px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
// 		    window.showModalDialog(popurl,self,popproperty);
		    window.open(popurl, 'okplazaPop', 'width=600, height=510, scrollbars=yes, status=no, resizable=no');
		} 
	}
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['서비스유형','사용자명','사용자ID','조직명','상태','로그인여부','전화번호','이동전화번호','Email발송','SMS발송','이메일','등록일'];	//출력컬럼명
	var colIds = ['svcTypeNm','userNm','loginId','branchNm','isUse','isLogin','tel','mobile','isEmail','isSms','email','createDate'];	//출력컬럼ID
// 	var numColIds = ['tel','mobile'];	//숫자표현ID
	var numColIds = "";	//숫자표현ID
	var sheetTitle = "사용자 관리";	//sheet 타이틀
	var excelFileName = "systemUserManageList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['서비스유형','사용자명','사용자ID','조직명','상태','로그인여부','전화번호','이동전화번호','Email발송','SMS발송','이메일','등록일'];	//출력컬럼명
	var colIds = ['svcTypeNm','userNm','loginId','branchNm','isUse','isLogin','tel','mobile','isEmail','isSms','email','createDate'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "사용자 관리";	//sheet 타이틀
	var excelFileName = "systemUserManageAllList";	//file명
	var actionUrl = "/system/systemUserManageAllListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcSvcTypeCd';
	fieldSearchParamArray[1] = 'srcUserNm';
	fieldSearchParamArray[2] = 'srcLoginId';
	fieldSearchParamArray[3] = 'srcIsUse';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>

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
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>사용자 관리</td>
						<td align="right">
							<a href="#">
								<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
							</a>
							<a href="#">
								<img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
							</a>
						</td>
					</tr>
				</table> <!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<!-- 컨텐츠 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">서비스유형</td>
						<td class="table_td_contents">
							<select id="srcSvcTypeCd" name="srcSvcTypeCd" class="select"> 
								<option value="">전체</option> 
							</select>
						</td>
						<td class="table_td_subject" width="100">사용자명</td>
						<td class="table_td_contents"><input id="srcUserNm" name="srcUserNm" type="text" size="20" maxlength="50" /></td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">사용자ID</td>
						<td class="table_td_contents">
							<input id="srcLoginId" name="srcLoginId" type="text" size="20" maxlength="50" /> 
						</td> 
						<td class="table_td_subject" width="100">상태</td>
						<td class="table_td_contents">
							<select id="srcIsUse" name="srcIsUse" class="select"> 
								<option value="1">사용</option>
								<option value="0">미사용</option>
								<option value="">전체</option> 
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="table_top_line"></td>
					</tr>
				</table> <!-- 컨텐츠 끝 -->
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="right">
				<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
				<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
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
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
</form>
</body>
</html>