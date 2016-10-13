<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-215 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>

<!--------------------------- Modal Dialog Start --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmWindow {
    display: none;
    
    position: fixed;
    top: 17%;
    left: 50%;
    
    margin-left: -300px;
    width: 600px;
    
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
$(function(){
	var btnUpload=$('#importButton');
	var status=$('#status');
	new AjaxUpload(btnUpload, {
		action: '<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codeExcelUpload.sys',
		name: 'excelFile',
		data: {},
		onSubmit: function(file, ext){
		 	var typeRow = $("#list").jqGrid('getGridParam','selrow');
		 	if(typeRow==null) { alert("코드유형이 선택되지 않았습니다."); return; }
		 	var selrowContent = jq("#list").jqGrid('getRowData',typeRow);
		 	var codeTypeId = selrowContent.codeTypeId;
		 	var codeTypeCd = selrowContent.codeTypeCd;
		 	this.setData({
		 		'codeTypeId':codeTypeId,
		 		'codeTypeCd':codeTypeCd
		 	});
			if (! (ext && /^(xls|xlsx)$/.test(ext))){
				status.text("엑셀파일만 등록 가능합니다.");	// extension is not allowed 
				return false;
			}
			if(!confirm("작성한 엑셀정보을 등록하시겠습니까?")) return false;
			status.text('Uploading...');
		},
		onComplete: function(file, response){
			status.text('');
			$('#dialogPop').jqmHide();
			fnTransResult(response);
			$("#list").trigger("reloadGrid");
		}
	});
	
	// Dialog Button Event
	$('#dialogPop').jqm();	//Dialog 초기화
	$("#uploadButton2").click(function(){
		$('#dialogPop').jqmShow();
	});
	$("#closeButton").click(function(){	//Dialog 닫기
		$('#dialogPop').jqmHide();
	});
	$('#dialogPop').jqm().jqDrag('#dialogHandle'); 
});
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#srcCodeTypeCd").css("ime-mode", "disabled");
	$("#srcCodeTypeCd").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcCodeTypeNm").keydown(function(e){
		if(e.keyCode==13) {
			$("#srcButton").click();
		}
	});
	$("#srcButton").click(function(){
		$("#srcCodeTypeCd").val($.trim($("#srcCodeTypeCd").val()));
		$("#srcCodeTypeNm").val($.trim($("#srcCodeTypeNm").val()));
	});
	
	$("#srcButton").click( function() { fnSearch(); });

	$("#viewButton").click( function() { viewRow(); });
	$("#regButton").click( function() { addRow(); });
	$("#modButton").click( function() { editRow(); });
	$("#delButton").click( function() { deleteRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	
});

$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth($(window).width()-60 + Number(gridWidthResizePlus));
}).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var subClickFlag = false;	//서브그리드의 더블클릭 시 메인그리드의 함수호출을 막기위한 플래그
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codeTypeListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['유형코드', '유형명','유형구분','사용여부', '유형설명', 'codeTypeId'],
		colModel:[
			{name:'codeTypeCd',index:'codeTypeCd', width:130,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//유형코드
			{name:'codeTypeNm',index:'codeTypeNm', width:150,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"30"}
			},//유형명
			{name:'codeFlag',index:'codeFlag', width:120,align:"center",search:false,sortable:true,
				editable:true,formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"0:시스템코드;1:사용자정의코드"}
			},//유형구분
			{name:'isUse',index:'isUse', width:80,align:"center",search:false,sortable:true,
				editable:true,formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부
			{name:'codeTypeDesc',index:'codeTypeDesc', width:500,align:"left",search:false,sortable:false,
				editable:true,formoptions:{rowpos:5,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				edittype:"textarea",editoptions:{rows:'3',cols:'40',maxLength:"100"}
			},//유형설명
		
			{name:'codeTypeId',index:'codeTypeId',hidden:true,search:false,key:true}//codeTypeId	
		],
		postData: {
			srcCodeTypeCd:$('#srcCodeTypeCd').val(),
			srcCodeTypeNm:$('#srcCodeTypeNm').val(),
			srcCodeFlag:$('#srcCodeFlag').val()
		},
		postData: {},subGrid: true,
		rowNum:30, rownumbers: false, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,autowidth: true,
		sortname: 'codeTypeId', sortorder: "desc",
		caption:"코드유형조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		onSelectRow: function (rowid, iRow, iCol, e) {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			if(!subClickFlag) {
				<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")%>
			}
			subClickFlag = false;
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
		subGridRowExpanded: function(subgrid_id, row_id) {
			var selrowContent = jq("#list").jqGrid('getRowData',row_id);
			var srcCodeTypeId = selrowContent.codeTypeId;
			var subgrid_table_id, pager_id;
			subgrid_table_id = subgrid_id+"_t";
			pager_id = "p_"+subgrid_table_id;
			$("#"+subgrid_id).html("<table id='"+subgrid_table_id+"' class='scroll'></table><div id='"+pager_id+"' class='scroll'></div>");
			$("#"+subgrid_table_id).jqGrid({
				url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codeListJQGrid.sys',
				datatype: 'json',
				mtype: 'POST',
				colNames:['코드명1', '코드값1', '코드명2', '코드값2','순서', '사용여부','codeId'],
				colModel:[
					{name:'codeNm1',index:'codeNm1', width:120,align:"left",search:false,sortable:true,
						editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
						editoptions:{size:"20",maxLength:"20"}
					},//코드명1
					{name:'codeVal1',index:'codeVal1', width:100,align:"left",search:false,sortable:true,
						editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
						editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
							$(elem).css("ime-mode", "disabled");$(elem).css("text-transform","uppercase");}}
					},//코드값1
					{name:'codeNm2',index:'codeNm2', width:120,align:"left",search:false,sortable:false,
						editable:true,editrules:{required:false},formoptions:{rowpos:3,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
						editoptions:{size:"20",maxLength:"20"}
					},//코드명2
					{name:'codeVal2',index:'codeVal2', width:100,align:"left",search:false,sortable:false,
						editable:true,editrules:{required:false},formoptions:{rowpos:4,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
						editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
							$(elem).css("ime-mode", "disabled");$(elem).css("text-transform","uppercase");}}
					},//코드값2
					{name:'disOrder',index:'disOrder', width:60,align:"center",search:false,sortable:true,
						editable:true,editrules:{required:true,number:true},formoptions:{rowpos:5,elmprefix:"<font color='red'>(*)</font>"},
						editoptions:{size:"2",maxLength:"3",dataInit:function(elem){ 
							$(elem).numeric(); $(elem).css("ime-mode", "disabled"); if($(elem).val()=='') $(elem).val(0);}}
					},//순서
					{name:'isUse',index:'isUse', width:80,align:"center",search:false,sortable:true,
						editable:true,editrules:{required:true},formoptions:{rowpos:6,elmprefix:"<font color='red'>(*)</font>"},
						edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
					},//사용여부

					{name:'codeId',index:'codeSeq',hidden:true,search:false}//코드번호
				],
				postData: { srcCodeTypeId:srcCodeTypeId },
				rowNum:0, rownumbers:false,height: '100%',
				sortname: 'disOrder', sortorder: "asc",
				viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
				pager: pager_id, pginput: false, pgbuttons: false,
				ondblClickRow: function (rowid, iRow, iCol, e) {
					subClickFlag = true;
					<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow2($('#'+subgrid_table_id), rowid);")%>
				},
				loadComplete: function() {},
				onSelectRow: function (rowid, iRow, iCol, e) {},
				loadError : function(xhr, st, str){ $("#"+subgrid_table_id).html(xhr.responseText); },
				jsonReader : { root: "list", repeatitems: false, cell: "cell", id: "codeId" }
			});
			$("#"+subgrid_table_id).jqGrid('navGrid',"#"+pager_id,{ 
				view:true, edit:true, add:true, del:true, search:false, excel:true, 
				viewfunc:function(rowid){
					viewRow2($("#"+subgrid_table_id), rowid);
				}, addfunc:function() {
					addRow2($("#"+subgrid_table_id), row_id);
				}, editfunc:function(rowid) {
					editRow2($("#"+subgrid_table_id), rowid);
				}, delfunc:function(rowid) {
					deleteRow2($("#"+subgrid_table_id), rowid);
				}
			});
			$("#"+subgrid_table_id).jqGrid('navButtonAdd',"#"+pager_id,{ 
				caption: "", buttonicon: "ui-icon-print", 
				onClickButton:function() {
					exportExcel2($("#"+subgrid_table_id), row_id);
				}	 
		    });
			$("#"+subgrid_table_id).jqGrid('navButtonAdd',"#"+pager_id,{ 
				caption: "", buttonicon: "ui-icon-transfer-e-w", 
				onClickButton:function() { $('#dialogPop').jqmShow(); }
		    });
		},
		subGridRowColapsed: function(subgrid_id, row_id) {
			var subgrid_table_id;
			subgrid_table_id = subgrid_id+"_t";
			$("#"+subgrid_table_id).remove();
		}
	}); 
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcCodeTypeCd = document.getElementById("srcCodeTypeCd").value;
	data.srcCodeTypeNm = document.getElementById("srcCodeTypeNm").value;
	data.srcCodeFlag = document.getElementById("srcCodeFlag").value;
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

/*------------------------------List에 대한 처리-----------------------------------*/
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function addRow() {
	jq("#list").jqGrid(
		'editGridRow', 'new',{
			bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
			url: "<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codeTypeTransGrid.sys", 
			editData: {},recreateForm: true,beforeShowForm: function(form) {},
			width:"400",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
			beforeSubmit: function (postData) { //대문자로 바꿔서 넘겨줌
			    postData.codeTypeCd = postData.codeTypeCd.toUpperCase(); 
			    return [true, '']; 
			},
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}
function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
  	if( row != null ){
  		jq("#list").jqGrid('setColProp', 'codeTypeCd',{editoptions:{
  			disabled:true,size:"20",maxLength:"20",
  			dataInit: function(elem){
  				$(elem).css("ime-mode", "disabled");
  				$(elem).css("text-transform","uppercase");
  			}
  		}}); 
//   		jq("#list").jqGrid('setColProp', 'codeFlag',{hidden:true});
  		jq("#list").jqGrid(
  			'editGridRow', row,{ 
  				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codeTypeTransGrid.sys",
				editData:{},recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
   				afterSubmit : function(response, postdata){ 
   					return fnJqTransResult(response, postdata);
				}
			}
  		);
  		jq("#list").jqGrid('setColProp', 'codeTypeCd',{editoptions:{
  			disabled:false,size:"20",maxLength:"20",
  			dataInit: function(elem){
  				$(elem).css("ime-mode", "disabled");
  				$(elem).css("text-transform","uppercase");
  			}
  		}}); 
//   		jq("#list").jqGrid('setColProp', 'codeFlag',{hidden:false});
  	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function deleteRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	if( row != null ) {
		jq("#list").jqGrid( 
			'delGridRow', row,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codeTypeTransGrid.sys",
				recreateForm: true,beforeShowForm: function(form) {
					jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
					jq('#pData').hide();jq('#nData').hide();  
				},
				reloadAfterSubmit:true,closeAfterDelete: true,
				afterSubmit: function(response, postdata){
					return fnJqTransResult(response, postdata);
				}
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['유형코드','유형명','유형구분','사용여부','유형설명'];	//출력컬럼명
	var colIds = ['codeTypeCd','codeTypeNm','codeFlag','isUse','codeTypeDesc'];	//출력컬럼ID
	var numColIds = ['codeFlag','isUse'];	//숫자표현ID
	var sheetTitle = "코드유형";	//sheet 타이틀
	var excelFileName = "CodeTypeList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/*------------------------------List2에 대한 처리-----------------------------------*/
function viewRow2(selSubGridObj, selSubGirdRowId) {
	selSubGridObj.jqGrid( 'viewGridRow', selSubGirdRowId, { width:"400", modal:true, closeOnEscape:true } );
}
function addRow2(selSubGridObj, selGridRowId) {
	var selrowContent = jq("#list").jqGrid('getRowData',selGridRowId);
	selSubGridObj.jqGrid(
		'editGridRow', 'new',{
			bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
			url: "<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codesTransGrid.sys", 
			editData: {codeTypeId:selrowContent.codeTypeId, codeTypeCd:selrowContent.codeTypeCd},
			recreateForm: true,beforeShowForm: function(form) {},
			width:"400",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
			beforeSubmit: function (postData) { //대문자로 바꿔서 넘겨줌
			    postData.codeVal1 = postData.codeVal1.toUpperCase(); 
			    postData.codeVal2 = postData.codeVal2.toUpperCase(); 
			    return [true, '']; 
			},
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}
function editRow2(selSubGridObj, selSubGirdRowId) {
	selSubGridObj.jqGrid(
		'editGridRow', selSubGirdRowId,{ 
			bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
			url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codesTransGrid.sys",
			editData:{},recreateForm: true,beforeShowForm: function(form) {},
			width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}
function deleteRow2(selSubGridObj, selSubGirdRowId) {
	selSubGridObj.jqGrid(
		'delGridRow', selSubGirdRowId,{
			url:"<%=Constances.SYSTEM_CONTEXT_PATH%>/system/codesTransGrid.sys",
			recreateForm: true,beforeShowForm: function(form) {
				jq(".delmsg").replaceWith('<span style="white-space: pre;">' + '선택한 데이터를 삭제 하시겠습니까?' + '</span>');
				jq('#pData').hide();jq('#nData').hide();  
			},
			reloadAfterSubmit:true,closeAfterDelete: true,
			afterSubmit: function(response, postdata){
				return fnJqTransResult(response, postdata);
			}
		}
	);
}
/**
 * list2 Excel Export
 */
function exportExcel2(selSubGridObj, selGridRowId) {
	var selrowContent = jq("#list").jqGrid('getRowData',selGridRowId);
	var tmpCodeTypeNm = selrowContent.codeTypeNm;
	
	var colLabels = ['코드명1','코드값1','코드명2','코드값2','순서','사용여부'];	//출력컬럼명
	var colIds = ['codeNm1','codeVal1','codeNm2','codeVal2','disOrder','isUse'];	//출력컬럼ID
	var numColIds = ['disOrder','isUse'];	//숫자표현ID
	var sheetTitle = tmpCodeTypeNm + " 상세 코드값";	//sheet 타이틀
	var excelFileName = "CodeList";	//file명
	
	fnExportExcel(selSubGridObj, colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>
</head>

<body>
<form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>코드관리</td>
					<td align="right">
						<a href="#"><img id="srcButton"
									src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif"
									height="22"
									style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
					</td>
				</tr>
			</table>
			
			<!-- Search Context -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">유형코드</td>
					<td class="table_td_contents">
						<input id="srcCodeTypeCd" name="srcCodeTypeCd" type="text" value="" size="20" maxlength="20"/>
					</td>
					<td class="table_td_subject" width="100">유형명</td>
					<td class="table_td_contents">
						<input id="srcCodeTypeNm" name="srcCodeTypeNm" type="text" value="" size="20" maxlength="30"/>
					</td>
					<td class="table_td_subject" width="100">코드구분</td>
					<td class="table_td_contents">
						<select name="srcCodeFlag" id="srcCodeFlag">
							<option value="">전체</option>
							<option value="0">시스템코드</option>
							<option value="1">사용자정의코드</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='8'></td>
				</tr>
			</table>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="right" valign="bottom">
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
						<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
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
			<div id="dialog" title="Feature not supported" style="display:none;">
				<p>That feature is not supported.</p>
			</div>
			
		</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<!-------------------------------- Dialog Div Start -------------------------------->
<div class="jqmWindow" id="dialogPop">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="dialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
		        			<td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
		        			<td class="popup_title">코드정보 일괄업로드</td>
		        			<td width="22" align="right">
		        				<a href="#" class="jqmClose">
		        				<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;" />
		        				</a>
		        			</td>
		        			<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							<!-- 타이틀 -->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet01.gif" align="bottom"/></td>
									<td class='ptitle'>사용방법</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr valign="top">
									<td height="23px" class="table_td_contents">1. 첫번째 Row의 필드는 [코드명1], [코드값1], [코드명2], [코드값2], [순서], [사용여부] 입니다.</td>
								</tr>
								<tr valign="top">
									<td height="23px" class="table_td_contents">2. 두번째 Row 이상은 실제 입력값이 들어갑니다. 첫번째 필드명의 Data에 맞게 입력하십시오.</td>
								</tr>
								<tr valign="top">
									<td height="23px" class="table_td_contents">3. 필수입력요소는 [코드명1], [코드값1], [순서], [사용여부] 입니다. <br />&nbsp;&nbsp;&nbsp;사용여부의 코드값은 1 이 사용, 0 이 미사용입니다.</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr valign="top">
									<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/member_excel.gif" /></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
							<span id="status" style="color: #FF0000"></span>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<a href="#"><img id="importButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type1_excelUpload.gif" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
										<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border:0;' /></a>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>