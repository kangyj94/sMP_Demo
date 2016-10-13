<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.BorgDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	//int listWidth = 740;
	String listHeight = "$(window).height()-215 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	@SuppressWarnings("unchecked")	//운영사정보 가져오기
	List<BorgDto> adminBorgList = (List<BorgDto>)request.getAttribute("adminBorgList");
	BorgDto adminBorgDto = new BorgDto();
	for(BorgDto tmpBorgDto:adminBorgList) {
		adminBorgDto = tmpBorgDto;
		break;	//운영사는 한개만 존재한다는 가정
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 사용자검색 스크립트 -->
<script type="text/javascript">
$(function(){
	$('#dialogPop').jqm();	//Dialog 초기화
	$("#saveButton").click(function(){
		$('#dialogPop').jqmShow();	//필수
		$("#srcJqmSvcTypeCd").val('ADM');	//필수
		$("#stcJqmSvcTypeNm").val('운영사');	//필수
		$("#srcJqmUserNm").focus();	//필수

		fnJqmInitSearch();	//조회조건 초기화 조회, 필수
	});
});

/**
 * 사용자검색 Callback Function(반드시 있어야 함)	//필수
 */
function fnSelectUserCallback(userId, borgId, svcTypeNm, userNm, loginId, borgNms) {
	if(!confirm("선택한 운영자을 시스템 사용자로 등록하시겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/userTransGrid.sys", 
		{ oper:"addSys", svcTypeCd:"ADM", id:userId, borgId:<%=adminBorgDto.getBorgId() %>, loginId:loginId },
		function(arg){ 
			$('#dialogPop').jqmHide();
			if(fnAjaxTransResult(arg)) {	//성공시
				$("#list").trigger("reloadGrid");
			}
		}
	);
}
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
	$("#viewButton").click( function() { viewRow(); });
	$("#regButton").click( function() { addRow(); });
	$("#modButton").click( function() { editRow(); });
	$("#colButton").click( function() { $("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
});
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-62 + Number(gridWidthResizePlus));
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var staticNum = 0;	//list 그리드를 한번만 초기화하기 위해
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/borgUserListJQGrid.sys',
		datatype: "json",
		mtype: "POST",
		colNames:['사용자명','사용자ID','패스워드','소속조직','사용권한','전화번호','핸드폰','이메일','활성화여부','사용여부','userId'],
		colModel:[
			{name:'userNm',index:'userNm', width:70,align:"center",sortable:true, 
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20"}},//사용자명
			{name:'loginId',index:'loginId', width:80,align:"left",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//사용자ID
			{name:'pwd',index:'pwd', width:60,align:"left",sortable:false,hidden:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"password",editoptions:{size:"20",maxLength:"20"}},//패스워드
			{name:'borgNmsByUserId',index:'borgNmsByUserId', width:150,align:"left",sortable:true,
				editable:false,editrules:{required:false},formoptions:{rowpos:4,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}},//소속조직
			{name:'roleNms',index:'roleNms', width:200,align:"left",sortable:true,
				editable:false,editrules:{required:false},formoptions:{rowpos:5,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}},//사용권한
			{name:'tel',index:'tel', width:80,align:"left",sortable:true,
				editable:true,editrules:{required:false},formoptions:{rowpos:6,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" 999-999-9999"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//전화번호
			{name:'mobile',index:'mobile', width:80,align:"left",sortable:true,
				editable:true,editrules:{required:false},formoptions:{rowpos:7,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" 999-999-9999"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//핸드폰
			{name:'email',index:'email', width:150,align:"left",sortable:true,
				editable:true,editrules:{required:false,email:true},formoptions:{rowpos:8,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" XXXX@XXX.XXX"},
				editoptions:{size:"30",maxLength:"30",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//이메일
			{name:'isLogin',index:'isLogin', width:70,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:9,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:활성;0:비활성"}},//활성화여부
			{name:'isUse',index:'isUse', width:70,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:10,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}},//사용여부
			
			{name:'userId',index:'userId', hidden:true, key:true} //userId
		],
		postData: { svcTypeCd:'SYS', borgId:<%=adminBorgDto.getBorgId() %>, isLeaf:true, srcIsLogin:'', srcIsUse:'' },
		rowNum:30, rownumbers: true, rowList:[30,50,100,500,1000], pager: '#pager',
	   	height:<%=listHeight%>, autowidth:true,
		sortname: 'userNm', sortorder: "asc",
		caption: "시스템 사용자 조회",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		afterInsertRow: function(rowid, aData){
			if(aData.isUse == "0"){
				jq("#list").setCell(rowid,'userNm','',{color:'red'});
				jq("#list").setCell(rowid,'loginId','',{color:'red'});
				jq("#list").setCell(rowid,'pwd','',{color:'red'});
				jq("#list").setCell(rowid,'borgNmsByUserId','',{color:'red'});
				jq("#list").setCell(rowid,'roleNms','',{color:'red'});
				jq("#list").setCell(rowid,'tel','',{color:'red'});
				jq("#list").setCell(rowid,'mobile','',{color:'red'});
				jq("#list").setCell(rowid,'email','',{color:'red'});
				jq("#list").setCell(rowid,'isLogin','',{color:'red'});
				jq("#list").setCell(rowid,'isUse','',{color:'red'});
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell", id: "userId" }
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/*------------------------------List에 대한 처리-----------------------------------*/
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"500", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function addRow() {
	jq("#list").jqGrid('setColProp', 'pwd',{hidden:false});
	jq("#list").jqGrid(
		'editGridRow', 'new',{
			addCaption:"시스템 사용자 추가",
			bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/userTransGrid.sys", 
			editData: {borgId:<%=adminBorgDto.getBorgId() %>, svcTypeCd:'<%=adminBorgDto.getSvcTypeCd() %>'},
			recreateForm: true,beforeShowForm: function(form) {},
			width:"400",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
	jq("#list").jqGrid('setColProp', 'pwd',{hidden:true});
}
function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
  	if( row != null ){
  		jq("#list").jqGrid('setColProp', 'pwd',{hidden:false});
  		jq("#list").jqGrid('setColProp', 'loginId',{editoptions:{disabled:true}});
  		jq("#list").jqGrid(
  			'editGridRow', row,{ 
  				editCaption: "시스템 사용자 수정",
  				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/userTransGrid.sys",
  				editData: {borgId:<%=adminBorgDto.getBorgId() %>, svcTypeCd:'<%=adminBorgDto.getSvcTypeCd() %>'},
				recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
   				afterSubmit : function(response, postdata){ 
   					return fnJqTransResult(response, postdata);
				}
			}
  		);
  		jq("#list").jqGrid('setColProp', 'pwd',{hidden:true});
  		jq("#list").jqGrid('setColProp', 'loginId',{editoptions:{disabled:false}});
  	} else { jq( "#dialogSelectRow" ).dialog(); }
}
/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['사용자명','사용자ID','소속조직','사용권한','전화번호','핸드폰','이메일','활성화여부','사용여부'];	//출력컬럼명
	var colIds = ['userNm','loginId','borgNmsByUserId','roleNms','tel','mobile','email','isLogin','isUse'];	//출력컬럼ID
	var numColIds = ['isLogin','isUse'];	//숫자표현ID
	var sheetTitle = "시스템 사용자";	//sheet 타이틀
	var excelFileName = "SystemUserList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

</head>
<body>
<form id="frm" name="frm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="25" class='ptitle'>시스템 관리</td>
				</tr>
			</table>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">조직명</td>
					<td class="table_td_contents">
						<%=adminBorgDto.getBorgNm() %>
					</td>
					<td class="table_td_subject" width="100">조직코드</td>
					<td class="table_td_contents">
						<%=adminBorgDto.getBorgCd() %>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="4" height='10'></td>
				</tr>
			</table>
			
			<table width="100%" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" valign="middle">
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="saveButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Boss.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
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
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
		</td>
	</tr>
</table>

<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp" %>
</form>
</body>
</html>