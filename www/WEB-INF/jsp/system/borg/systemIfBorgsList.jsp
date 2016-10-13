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
	String listHeight = "$(window).height()-375 + Number(gridHeightResizePlus)";
	String listWidth  = "1500";

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
	initList();	//그리드 초기화
	
	$("#srcButton").click( function() { 
		fnSearch(); 
	});
	
	$("#btnSapTrans").click( function() { 
		fnRequestSapTrans();
	});

	$("#transCd").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#borgNm").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#svcTypeCd").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});
	$("#modButton").click( function() { editRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
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
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemIfBorgsListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['<input id=\"chkAllOutputField\" type=\"checkbox\" style=\"border:0px;\" onclick=\"allCheckBox(event)\" />','조직코드','조직유형','조직명','사업자등록번호','내용','전송일자','SAP처리여부','처리일자','처리자명'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},		          
			{name:'borgId',index:'borgId', width:100,align:"center",search:false,sortable:true, 
				editable:true 
			},	//조직코드
			{name:'svcTypeCd',index:'svcTypeCd', width:70,align:"center",sortable:true,
				editable:false,edittype:"select",formatter:"select",editoptions:{value:"VEN:공급사;BCH:고객사"}},//처리여부				
			{name:'borgNm',index:'borgNm', width:150,align:"left",search:false,sortable:true, 
				editable:true 
			},	//조직명
			{name:'businessNum',index:'businessNum', width:100,align:"center",search:false,sortable:true,
				editable:true 
			},	//사업자등록번호
			{name:'transDesc',index:'transDesc', width:250,align:"left",search:false,sortable:true,
				editable:false 
			},	//내용
			{name:'transDate',index:'transDate', width:80,align:"center",search:false,sortable:true,
				editable:false 
			},	//전송일자
			{name:'transCd',index:'transCd', width:70,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:11,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:미등록;0:등록완료"}},//처리여부			
			{name:'updateDate',index:'updateDate', width:80,align:"center",search:false,sortable:true,
				editable:false 
			},	//처리일자
			{name:'updateUserId',index:'updateUserId', width:100,align:"left",search:false,sortable:true,
				editable:false 
			}
		],
		postData: {
			svcTypeCd:$("#svcTypeCd").val(),
			borgNm:$("#borgNm").val(),
			transCd:$("#transCd").val()
		},
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width:<%=listWidth%>,
		sortname: 'transDate', sortorder: "desc",
// 		caption:"ERP미등록 조직목록", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","editRow();")%>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	}); 
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function checkboxFormatter(cellvalue, options, rowObject) {
	var checkBox = "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' style='border: 0 ; height:30px;' offval='no'  />";
	return checkBox;
}
function fnIsChecked(rowid){
	if($("#isCheck_" + rowid ).prop("checked") == true){
		$("#isCheck_" + rowid ).prop("checked",false);
	}else{
		$("#isCheck_" + rowid ).prop("checked",true);
	}
}
function allCheckBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;
	
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

function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.transCd = $("#transCd").val();
	data.borgNm = $("#borgNm").val();
	data.svcTypeCd = $("#svcTypeCd").val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);
		jq("#list").jqGrid('setColProp', 'borgId',{editoptions:{disabled:true}});
		jq("#list").jqGrid('setColProp', 'borgNm',{editoptions:{disabled:true}});
		jq("#list").jqGrid('setColProp', 'businessNum',{editoptions:{disabled:true}});
  		jq("#list").jqGrid(
  			'editGridRow', row,{ 
  				editCaption: "SAP처리여부 수정",
  				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveIfBorgs.sys",
  				editData: {borgId:selrowContent.borgId},
				recreateForm: true,beforeShowForm: function(form) {},
				width:"410",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
   				afterSubmit : function(response, postdata){ 
   					return fnJqTransResult(response, postdata);
				}
			}
  		);
		jq("#list").jqGrid('setColProp', 'borgId',{editoptions:{disabled:false}});
		jq("#list").jqGrid('setColProp', 'borgNm',{editoptions:{disabled:false}});
		jq("#list").jqGrid('setColProp', 'businessNum',{editoptions:{disabled:false}});
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['조직코드','조직유형','조직명','사업자등록번호','내용','전송일자','SAP처리여부','처리일자','처리자명'];	//출력컬럼명
	var colIds = ['borgId','svcTypeCd','borgNm','businessNum','transDesc','transDate','transCd','updateDate','updateUserId'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "ERP미등록 조직목록";	//sheet 타이틀
	var excelFileName = "systemIfborgsList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function fnRequestSapTrans(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var chkCnt = 0;
		var borgIds 	= new Array();
		var svcTypeCds	= new Array();
		
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			var selrowContent = $("#list").jqGrid('getRowData',rowid);
			if($("#isCheck_" + rowid ).prop("checked")){
				borgIds[chkCnt] 	= selrowContent.borgId; 
				svcTypeCds[chkCnt] 	= selrowContent.svcTypeCd; 
				chkCnt++;
			}
		}
		
		if(chkCnt > 0){
			if(!confirm("전송하시겠습니까?")) return;
		    $.post(
				"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/requestSapTrans.sys",
				{borgIds : borgIds, svcTypeCds : svcTypeCds},
				function(arg){
					var tranDescList = eval('('+arg+')').tranDescList;
					var rtnMsg = "";
					var customResponse = eval('(' + arg + ')').customResponse;

					if (customResponse.success == false) {
			            var errors = "";
			            for (var i = 0; i < customResponse.message.length; i++) { errors +=  customResponse.message[i]; }
			            rtnMsg = errors;
					}else{
						for(var i = 0 ; i < tranDescList.length ; i++){
							rtnMsg += tranDescList[i]+"<br/>";
						}
					}
					
					$("#dialogTransResult").html(rtnMsg);
					$("#dialogTransResult").dialog();
					fnSearch();
				}
			);
		}else{
			$("#dialogSelectRow").dialog();
		}
	}	
}
</script>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
	<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<!-- 타이틀 시작 -->
				<table width="1500px" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
						<td height="29" class='ptitle'>ERP미등록 조직관리</td>
						<td align="right">
							<button id='btnSapTrans' class="btn btn-warning btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-floppy-o"></i> SAP 전송</button>							
							<button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>							
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
						<td class="table_td_subject" width="100">조직유형</td>
						<td class="table_td_contents">
							<select id="svcTypeCd" name="svcTypeCd" class="select" style="width: 80px;"> 
								<option value="">전체</option> 
								<option value="BCH">고객사</option> 
								<option value="VEN">공급사</option> 
							</select>
						</td>
						<td class="table_td_subject" width="100">조직명</td>
						<td class="table_td_contents"><input id="borgNm" name="borgNm" type="text" size="20" maxlength="50" /></td>
					</tr>
					<tr>
						<td colspan="6" height='1' bgcolor="eaeaea"></td>
					</tr>
					<tr>
						<td class="table_td_subject" width="100">SAP처리여부</td>
						<td class="table_td_contents">
							<select id="transCd" name="transCd" class="select" style="width: 80px;"> 
								<option value="1">미등록</option> 
								<option value="0">등록완료</option> 
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
<div id="dialogTransResult" title="Warning" style="display:none;font-size: 12px;color: red;"></div>
</body>
</html>