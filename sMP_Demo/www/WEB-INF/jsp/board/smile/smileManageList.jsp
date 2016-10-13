<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "(($(window).height()-397) / 2) + Number(gridHeightResizePlus)";
// 	String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
	String listWidth = "1500";
	
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	
	$("#regButton1").click( function() { addRow1(); });
	$("#modButton1").click( function() { editRow1(); });
	$("#delButton1").click( function() { deleteRow1(); });
	
	$("#regButton2").click( function() { addRow2(); });
	$("#modButton2").click( function() { editRow2(); });
	$("#delButton2").click( function() { deleteRow2(); });

});

$(window).bind('resize', function() {
	$("#list1").setGridHeight(<%=listHeight %>);
	$("#list2").setGridHeight(<%=listHeight %>);
	$("#list1").setGridWidth(<%=listWidth %>);
	$("#list2").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">

$(function() {
	$("#list1").jqGrid({
		url:'/board/selectSmileManageList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['순서','대상','내용','사용여부','SMILE_ID'],
		colModel:[
			{name:'EVAL_SORT',index:'EVAL_SORT',width:30,align:"center",search:false,sortable:true, 
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{
					dataInit: function(elem) { 
						$(elem).width(40);
						$(elem).keyup(function(){//숫자만입력
							var num = new Number( $(elem).val() );
							if(isNaN(num)){
								$(elem).val("");
								alert("숫자만 입력 가능합니다.");
								return false;
							}
			
						});
					}
				}
			},//마감번호
			{name:'TARGET_SVCTYPECD', index:'TARGET_SVCTYPECD',width:100,align:"center",search:false,sortable:true,  
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"VEN:공급사;ADM:운영사"}	
			},//대상
			{name:'EVAL_CONTENTS',index:'EVAL_CONTENTS',width:800,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{
					dataInit: function(elem) { 
						$(elem).width(350);
					}
				}
			},//내용
			{name:'ISUSE',index:'ISUSE',width:60,align:"center",search:false,sortable:true,  
				editable:true,editrules:{required:true},formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}	
			},//사용여부
			{name:'SMILE_ID',index:'SMILE_ID',search:false,sortable:false, editable:false, hidden:true, key:true }

		],
		postData: {
			evalSvcTypeCd : "BUY"
		},
		rowNum:30, rownumbers: true,
		height: <%=listHeight%>,width: <%=listWidth %>,
		sortname: '', sortorder: "", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	
	$("#list2").jqGrid({
		url:'/board/selectSmileManageList/list.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['순서','대상','내용','사용여부','SMILE_ID'],
		colModel:[
			{name:'EVAL_SORT',index:'EVAL_SORT',width:30,align:"center",search:false,sortable:true, 
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{
					dataInit: function(elem) { 
						$(elem).width(40);
						$(elem).keyup(function(){//숫자만입력
							var num = new Number( $(elem).val() );
							if(isNaN(num)){
								$(elem).val("");
								alert("숫자만 입력 가능합니다.");
								return false;
							}
			
						});
					}
				}
			},//마감번호
			{name:'TARGET_SVCTYPECD', index:'TARGET_SVCTYPECD',width:100,align:"center",search:false,sortable:true,  
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"ADM:운영사"}	
			},//대상
			{name:'EVAL_CONTENTS',index:'EVAL_CONTENTS',width:800,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{
					dataInit: function(elem) { 
						$(elem).width(350);
					}
				}
			},//내용
			{name:'ISUSE',index:'ISUSE',width:60,align:"center",search:false,sortable:true,  
				editable:true,editrules:{required:true},formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}	
			},//사용여부
			{name:'SMILE_ID',index:'SMILE_ID',search:false,sortable:false, editable:false, hidden:true, key:true }

		],
		postData: {
			evalSvcTypeCd : "VEN"
		},
		rowNum:30, rownumbers: true,
		height: <%=listHeight%>,width: <%=listWidth %>,
		sortname: '', sortorder: "", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});

function addRow1() {
	$("#list1").jqGrid(
		'editGridRow', 'new',{
			addCaption:"고객사 항목 등록",
			url: "/board/insertSmileManage/save.sys", 
			editData: {
				oper			: "add"
			,	idGenSvcNm		: "seqSmile"
			,	EVAL_SVCTYPECD	: "BUY"
			},
			recreateForm: true, beforeShowForm: function(form) {},
			width:"450", modal:true, closeAfterAdd: true, reloadAfterSubmit:true,
			beforeSubmit: function (postData) { //대문자로 바꿔서 넘겨줌
				postData.TARGET_SVCTYPECD = postData.TARGET_SVCTYPECD.toUpperCase(); 
				return [true, '']; 
			},
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}

function editRow1() {
	var row = $("#list1").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if(row==null) { $( "#dialogSelectRow" ).dialog(); return; }
	var selrowContent = $("#list1").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
	
// 	jq("#list").jqGrid('setColProp', 'roleCd',{editoptions:{readonly:true}});

 	$("#list1").jqGrid(
 		'editGridRow', row,{ 
 			url: "/board/updateSmileManage/save.sys", 
 			editData: {
				oper	: "edit"
			,	id		: row
			},
			recreateForm: true, beforeShowForm: function(form) {},
			width:"450", modal:true, closeAfterEdit: true, reloadAfterSubmit:true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
// 	jq("#list").jqGrid('setColProp', 'roleCd',{editoptions:{readonly:false}});
}

function deleteRow1() {
	var row = $("#list1").jqGrid('getGridParam','selrow');
	if(row==null) { $( "#dialogSelectRow" ).dialog(); return; }
	$("#list1").jqGrid( 
		'delGridRow', row,{
			url: "/board/deleteSmileManage/save.sys", 
			beforeShowForm: function(form) {
				$(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택하신 고객사 항목을 삭제하시겠습니까?' + '</span>');
				$('#pData').hide();
				$('#nData').hide();
			},
			recreateForm: true, reloadAfterSubmit:true, closeAfterDelete: true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}

function addRow2() {
	$("#list2").jqGrid(
		'editGridRow', 'new',{
			addCaption:"공급사 항목 등록",
			url: "/board/insertSmileManage/save.sys", 
			editData: {
				oper			: "add"
			,	idGenSvcNm		: "seqSmile"
			,	EVAL_SVCTYPECD	: "VEN"
			},
			recreateForm: true, beforeShowForm: function(form) {},
			width:"450", modal:true, closeAfterAdd: true, reloadAfterSubmit:true,
			beforeSubmit: function (postData) { //대문자로 바꿔서 넘겨줌
				postData.TARGET_SVCTYPECD = postData.TARGET_SVCTYPECD.toUpperCase(); 
				return [true, '']; 
			},
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}

function editRow2() {
	var row = $("#list2").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if(row==null) { $( "#dialogSelectRow" ).dialog(); return; }
	var selrowContent = $("#list1").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
	
// 	jq("#list").jqGrid('setColProp', 'roleCd',{editoptions:{readonly:true}});

 	$("#list2").jqGrid(
 		'editGridRow', row,{ 
 			url: "/board/updateSmileManage/save.sys", 
 			editData: {
				oper	: "edit"
			,	id		: row
			},
			recreateForm: true, beforeShowForm: function(form) {},
			width:"450", modal:true, closeAfterEdit: true, reloadAfterSubmit:true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
// 	jq("#list").jqGrid('setColProp', 'roleCd',{editoptions:{readonly:false}});
}

function deleteRow2() {
	var row = $("#list2").jqGrid('getGridParam','selrow');
	if(row==null) { $( "#dialogSelectRow" ).dialog(); return; }
	$("#list2").jqGrid( 
		'delGridRow', row,{
			url: "/board/deleteSmileManage/save.sys", 
			beforeShowForm: function(form) {
				$(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택하신 고객사 항목을 삭제하시겠습니까?' + '</span>');
				$('#pData').hide();
				$('#nData').hide();
			},
			recreateForm: true, reloadAfterSubmit:true, closeAfterDelete: true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}
</script>


</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
	<form id="frm" name="frm" method="post" onsubmit="return false;"> 
	<input id ="create_borgid" name="create_borgid" type="hidden" />
	<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
						</td>
						<td height="29" class="ptitle">스마일 관리</td>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>

		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" valign="top">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
						</td>
						<td class="stitle">고객사 항목</td>
						<td align="right" valign="bottom" >
							<button id='regButton1' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
							<button id='modButton1' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 수정</button>
							<button id='delButton1' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash-o"></i> 삭제</button>
						</td>
					</tr>
					<tr><td style="height: 5px;" colspan="3"></td></tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list1"></table>
				</div>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" valign="top">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
						</td>
						<td class="stitle">공급사 항목</td>
						<td align="right" valign="bottom" >
							<button id='regButton2' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 등록</button>
							<button id='modButton2' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 수정</button>
							<button id='delButton2' class="btn btn-danger btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-trash-o"></i> 삭제</button>
						</td>
					</tr>
					<tr><td style="height: 5px;" colspan="3"></td></tr>
					</tr>
				</table>
				<!-- 타이틀 끝 -->
			</td>
		</tr>
		<tr>
			<td>
				<div id="jqgrid">
					<table id="list2"></table>
				</div>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	<!-------------------------------- Dialog Div Start -------------------------------->
	<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
		<p>처리할 데이터를 선택 하십시오!</p>
	</div>
	<div id="dialog" title="Feature not supported" style="display:none;">
		<p>That feature is not supported.</p>
	</div>
	<!-------------------------------- Dialog Div End -------------------------------->
	</form>
</body>
</html>