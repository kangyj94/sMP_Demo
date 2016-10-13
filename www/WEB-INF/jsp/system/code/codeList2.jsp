<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	int listWidth = 450;
	String listHeight = "$(window).height()-215 + Number(gridHeightResizePlus)";
	String list2Height = "$(window).height()-190 + Number(gridHeightResizePlus)";

	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>

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
		action: '<%=Constances.SYSTEM_CONTEXT_PATH %>/system/codeExcelUpload.sys',
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
		fnSearch();
	});

	$("#viewButton").click( function() { viewRow(); });
	$("#regButton").click( function() { listAddRow(); });
	$("#modCheckButton").click(function(){ listSaveRow("MOD"); });
	$("#delCheckButton").click(function(){ listSaveRow("DEL"); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });

	$("#viewButton2").click( function() { viewRow2(); });
	$("#regButton2").click( function() { listAddRow2(); });
	$("#modCheckButton2").click(function(){ listSaveRow2("MOD"); });
	$("#delCheckButton2").click(function(){ listSaveRow2("DEL"); });
	$("#colButton2").click( function() { jq("#list2").jqGrid('columnChooser'); });
	$("#excelButton2").click(function(){ exportExcel2(); });
});

$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list2").setGridWidth($(window).width()-530 + Number(gridWidthResizePlus));
    $("#list2").setGridHeight(<%=list2Height %>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var staticNum = 0;	//list2, 그리드를 한번만 초기화하기 위해
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/codeTypeListJQGrid.sys',
		editurl: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",	//활성화된 컬럼정보을 가지고 오기 위한 Dummy controller
		datatype: 'json',
		mtype: 'POST',
		colNames:['선택','유형코드', '유형명','유형구분','사용여부', '유형설명', 'codeTypeId'],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,
				editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				formatter:checkboxFormatter
			},//선택
			{name:'codeTypeCd',index:'codeTypeCd', width:100,align:"left",search:false,sortable:true,
				editable:false,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled");$(elem).css("text-transform","uppercase");}}
			},//유형코드
			{name:'codeTypeNm',index:'codeTypeNm', width:100,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"30"}
			},//유형명
			{name:'codeFlag',index:'codeFlag', width:80,align:"center",search:false,sortable:true,
				editable:true,formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"0:시스템코드;1:사용자정의코드"}
			},//유형구분
			{name:'isUse',index:'isUse', width:60,align:"center",search:false,sortable:true,
				editable:true,formoptions:{rowpos:5,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부
			{name:'codeTypeDesc',index:'codeTypeDesc', width:200,align:"left",search:false,sortable:false,
				editable:true,formoptions:{rowpos:6,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				edittype:"textarea",editoptions:{rows:'3',cols:'40',maxLength:"100"}
			},//유형설명
		
			{name:'codeTypeId',index:'codeTypeId',hidden:true,search:false,key:true}//codeTypeId
		],
		postData: {
			srcCodeTypeCd:$('#srcCodeTypeCd').val(),
			srcCodeTypeNm:$('#srcCodeTypeNm').val(),
			srcCodeFlag:$('#srcCodeFlag').val()
		},
		postData: {},
		rowNum:30, rownumbers: true, rowList:[30,50,100],
		height: <%=listHeight%>,width: <%=listWidth%>, pager: '#pager',
		sortname: 'codeTypeId', sortorder: "desc",
		caption:"코드유형조회", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
				var srcCodeTypeId = selrowContent.codeTypeId;
				var srcCodeTypeNm = selrowContent.codeTypeNm;
				if(staticNum==0) {
					fnInitCodeList(srcCodeTypeId,srcCodeTypeNm);
					staticNum++;
				}
				jq("#list").setSelection(top_rowid);
			} else {
				jq("#list2").clearGridData();
				jq("#list2").jqGrid("setCaption","&nbsp;");
			}
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'codeTypeCd','',{color:'blue'});
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var srcCodeTypeId = selrowContent.codeTypeId;
			var srcCodeTypeNm = selrowContent.codeTypeNm;
			if(srcCodeTypeNm.indexOf("<input")>=0) {	//Row가 edit 상태일 경우 코드타입명을 가져오기
				jq('#list').saveRow(rowid);
				selrowContent = jq("#list").jqGrid('getRowData',rowid);
				srcCodeTypeNm = selrowContent.codeTypeNm;
				jq("#list").editRow(rowid);
			}
			fnOnClickCodeList(srcCodeTypeId,srcCodeTypeNm);
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		onCellSelect: function(rowid, iCol, cellcontent, target){},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
});
var _codeTypeName = "";	//코드값 엑셀 출력 시 선택된 코드타입명을 출력하기 위해
function fnInitCodeList(srcCodeTypeId,srcCodeTypeNm) {
	_codeTypeName = srcCodeTypeNm;
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/codeListJQGrid.sys',
		editurl: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys",	//활성화된 컬럼정보을 가지고 오기 위한 Dummy controller
		datatype: 'json',
		mtype: 'POST',
		colNames:['선택','코드명1', '코드값1', '코드명2', '코드값2','순서', '사용여부','codeId'],
		colModel:[
			{name:'isCheck2',index:'isCheck2', width:30,align:"center",search:false,sortable:false,
				editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				formatter:checkboxFormatter2 
			},//선택
			{name:'codeNm1',index:'codeNm1', width:100,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20"}
			},//코드명1
			{name:'codeVal1',index:'codeVal1', width:80,align:"left",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//코드값1
			{name:'codeNm2',index:'codeNm2', width:100,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:false},formoptions:{rowpos:4,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				editoptions:{size:"20",maxLength:"20"}
			},//코드명2
			{name:'codeVal2',index:'codeVal2', width:80,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:false},formoptions:{rowpos:5,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//코드값2
			{name:'disOrder',index:'disOrder', width:60,align:"center",search:false,sortable:true,
				editable:true,editrules:{required:true,number:true},formoptions:{rowpos:6,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"2",maxLength:"3", dataInit:function(elem){ 
					$(elem).numeric(); $(elem).css("ime-mode", "disabled"); if($(elem).val()=='') $(elem).val(0); } }
			},//순서
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:7,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부

			{name:'codeId',index:'codeSeq',hidden:true,search:false}//코드번호
		],
		postData: { srcCodeTypeId:srcCodeTypeId },
		rowNum:0, rownumbers:false, 
		height:<%=list2Height%>, autowidth: true,
		sortname: 'disOrder', sortorder: "asc",
		caption:"<font color='blue'>["+srcCodeTypeNm+"]</font> 타입의 코드값 리스트", 
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() { },
		ondblClickRow: function (rowid, iRow, iCol, e) { 
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow2();") %>
		},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell", id: "codeId" }
	});
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/**
 * 조회
 */
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcCodeTypeCd = document.getElementById("srcCodeTypeCd").value;
	data.srcCodeTypeNm = document.getElementById("srcCodeTypeNm").value;
	data.srcCodeFlag = document.getElementById("srcCodeFlag").value;
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}
/**
 * List의 Row을 선택 시 List2을 Leload함
 */
function fnOnClickCodeList(srcCodeTypeId,srcCodeTypeNm) {
	_codeTypeName = srcCodeTypeNm;
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcCodeTypeId = srcCodeTypeId;
	jq("#list2").jqGrid("setCaption", "<font color='blue'>["+srcCodeTypeNm+"]</font> 타입의 코드값 리스트");
	jq("#list2").jqGrid("setGridParam", { "postData": data2 });
	jq("#list2").trigger("reloadGrid");
}

/*------------------------------List에 대한 처리-----------------------------------*/
/**
 * list 체크박스 포맷제공
 */
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' type='checkbox' onclick=\"fnChangeEdit('" + options.rowId + "', this);\" offval='no' />";
}
/**
 * list 체크박스 클릭 시 EditRow
 */
function fnChangeEdit(rowid, object) {
	if(object.checked) {
		jq("#list").setSelection(rowid);
		jq("#list").editRow(rowid);
	} else {
		jq("#list").restoreRow(rowid);
		jq("#list").setSelection(rowid);
	}
}
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var rowCnt = jq("#list").getGridParam('reccount');
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			var isCheckList = jq("#isCheck_"+rowid).attr("checked");
			if(isCheckList) {
				alert("체크된 로우가 존재하면 레코드보기을 하실 수 없습니다.");
				return;
			}
		}
		jq("#list").jqGrid('setColProp', 'isCheck',{hidden:true}); 
		jq("#list").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
		jq("#list").jqGrid('setColProp', 'isCheck',{hidden:false});
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
/**
 * List을 등록Div호출 및 등록 처리
 */
function listAddRow() {
	jq("#list").jqGrid('setColProp', 'codeTypeCd',{editable:true}); 
	jq("#list").jqGrid(
		'editGridRow', 'new',{
			bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/codeTypeTransGrid.sys", 
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
	jq("#list").jqGrid('setColProp', 'codeTypeCd',{editable:false});
}
/**
 * 체크된 리스트의 일괄수정 및 삭제(수정:MOD, 삭제:DEL)
 */
function listSaveRow(transFlag) {
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var codeTypeIdArray = new Array();
		var codeTypeNmArray = new Array();
		var codeFlagArray = new Array();
		var isUseArray = new Array();
		var codeTypeDescArray = new Array();
		var arrayCnt = 0;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			var isCheckList = jq("#isCheck_"+rowid).attr("checked");
			if(isCheckList) {
				if(!jq('#list').saveRow(rowid)) return;
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				codeTypeIdArray[arrayCnt] = selrowContent.codeTypeId;
				codeTypeNmArray[arrayCnt] = selrowContent.codeTypeNm;
				codeFlagArray[arrayCnt] = selrowContent.codeFlag;
				isUseArray[arrayCnt] = selrowContent.isUse;
				codeTypeDescArray[arrayCnt] = selrowContent.codeTypeDesc;
				jq("#list").editRow(rowid);
				arrayCnt++;
			}
		}
		if(arrayCnt==0) { jq( "#dialogSelectRow" ).dialog(); return; }
		if(!confirm("선택정보을 처리하겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/codeTypeCheckTransGrid.sys", 
			{ transFlag:transFlag, codeTypeIdArray:codeTypeIdArray, codeTypeNmArray:codeTypeNmArray, 
				codeFlagArray:codeFlagArray, isUseArray:isUseArray, codeTypeDescArray:codeTypeDescArray },
			function(arg){ 
				if(fnAjaxTransResult(arg)) {	//성공시
					jq("#list").trigger("reloadGrid");
				}
			}
		);
	} else jq( "#dialogSelectRow" ).dialog();
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
	
	/*---------------------엑셀출력 체크박스 제한-----------------------*/
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			var isCheckList = jq("#isCheck_"+rowid).attr("checked");
			if(isCheckList) {
				alert("엑셀 출력은 체크박스을 해제하시고 수행하십시오!");
				return;
			}
		}
	}
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/*------------------------------List2에 대한 처리-----------------------------------*/
/**
 * list2 체크박스 포맷제공
 */
function checkboxFormatter2(cellvalue, options, rowObject) {
	return "<input id='isCheck2_"+options.rowId+"' type='checkbox' onclick=\"fnChangeEdit2('" + options.rowId + "', this);\" offval='no' />";
}
/**
 * list2 체크박스 클릭 시 EditRow
 */
function fnChangeEdit2(rowid, object) {
	jq("#list2").setSelection(rowid);
	if(object.checked) jq("#list2").editRow(rowid);
	else jq("#list2").restoreRow(rowid);
}
function viewRow2() {
	var row = jq("#list2").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var rowCnt = jq("#list2").getGridParam('reccount');
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list2").getDataIDs()[i];
			var isCheckList = jq("#isCheck2_"+rowid).attr("checked");
			if(isCheckList) {
				alert("체크된 로우가 존재하면 레코드보기을 하실 수 없습니다.");
				return;
			}
		}
		jq("#list2").jqGrid('setColProp', 'isCheck2',{hidden:true}); 
		jq("#list2").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
		jq("#list2").jqGrid('setColProp', 'isCheck2',{hidden:false}); 
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
/**
 * List2을 등록Div호출 및 등록 처리
 */
function listAddRow2() {
	var typeRow = jq("#list").jqGrid('getGridParam','selrow');
	if(typeRow==null) { alert("좌측의 코드타입이 선택되지 않았습니다."); return; }
	var selrowContent = jq("#list").jqGrid('getRowData',typeRow);
	jq("#list2").jqGrid(
		'editGridRow', 'new',{
			bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/codesTransGrid.sys", 
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
/**
 * 체크된 리스트의 일괄수정 및 삭제(수정:MOD, 삭제:DEL)
 */
function listSaveRow2(transFlag) {
	var typeRow = jq("#list").jqGrid('getGridParam','selrow');
	if(typeRow==null) { alert("좌측의 코드타입이 선택되지 않았습니다."); return; }
	var rowCnt = jq("#list2").getGridParam('reccount');
	if(rowCnt>0) {
		var codeVal1Array = new Array();
		var codeNm1Array = new Array();
		var codeVal2Array = new Array();
		var codeNm2Array = new Array();
		var disOrderArray = new Array();
		var isUseArray = new Array();
		var codeIdArray = new Array();
		var arrayCnt = 0;
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list2").getDataIDs()[i];
			var isCheckList = jq("#isCheck2_"+rowid).attr("checked");
			if(isCheckList) {
				if(!jq('#list2').saveRow(rowid)) return;
				var selrowContent = jq("#list2").jqGrid('getRowData',rowid);
				codeVal1Array[arrayCnt] = selrowContent.codeVal1;
				codeNm1Array[arrayCnt] = selrowContent.codeNm1;
				codeVal2Array[arrayCnt] = selrowContent.codeVal2;
				codeNm2Array[arrayCnt] = selrowContent.codeNm2;
				disOrderArray[arrayCnt] = selrowContent.disOrder;
				isUseArray[arrayCnt] = selrowContent.isUse;
				codeIdArray[arrayCnt] = selrowContent.codeId;
				jq("#list2").editRow(rowid);
				arrayCnt++;
			}
		}
		
		if(arrayCnt==0) { jq( "#dialogSelectRow" ).dialog(); return; }
		if(!confirm("선택정보을 처리하겠습니까?")) return;
		$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/codesCheckTransGrid.sys", 
			{ transFlag:transFlag, codeVal1Array:codeVal1Array, codeNm1Array:codeNm1Array, codeVal2Array:codeVal2Array, 
				codeNm2Array:codeNm2Array, disOrderArray:disOrderArray, isUseArray:isUseArray, codeIdArray:codeIdArray },
			function(arg){ 
				if(fnAjaxTransResult(arg)) {	//성공시
					jq("#list2").trigger("reloadGrid");
				}
			}
		);
	} else jq( "#dialogSelectRow" ).dialog();
}
/**
 * list2 Excel Export
 */
function exportExcel2() {
	var colLabels = ['코드명1','코드값1','코드명2','코드값2','순서','사용여부'];	//출력컬럼명
	var colIds = ['codeNm1','codeVal1','codeNm2','codeVal2','disOrder','isUse'];	//출력컬럼ID
	var numColIds = ['disOrder','isUse'];	//숫자표현ID
	var sheetTitle = _codeTypeName+" 코드값";	//sheet 타이틀
	var excelFileName = "CodeList";	//file명
	
	/*---------------------엑셀출력 체크박스 제한-----------------------*/
	var rowCnt = jq("#list2").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list2").getDataIDs()[i];
			var isCheckList = jq("#isCheck2_"+rowid).attr("checked");
			if(isCheckList) {
				alert("엑셀 출력은 체크박스을 해제하시고 수행하십시오!");
				return;
			}
		}
	}
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
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
						<a href="#"><img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
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
				<col width="450" />
				<col />
				<col width="100%"/>
				<tr>
					<td align="right" valign="bottom">
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="modCheckButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Save.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="delCheckButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td align="right" valign="bottom">
						<a href="#"><img id="viewButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="regButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="modCheckButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Save.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="delCheckButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#">
							<img id="uploadButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Upload.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' />
						</a>
					</td>
				</tr>
				<tr>
					<td>
						<div id="jqgrid">
							<table id="list"></table>
							<div id="pager"></div>
						</div>
					</td>
					<td></td>
					<td>
						<div id="jqgrid">
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

<div id="dialog" title="Feature not supported" style="display:none">
	<p>That feature is not supported.</p>
</div>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialogLoadError" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>데이터 로드 중 에러가 발생하였습니다.!</p>
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
										<a href="#"><img id="importButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type1_excelUpload.gif" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
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