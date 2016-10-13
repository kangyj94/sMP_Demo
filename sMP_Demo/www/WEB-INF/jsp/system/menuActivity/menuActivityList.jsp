<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%
	//그리드의 width와 Height을 정의
	int listWidth = 1000;
	String listHeight = "$(window).height()-365 + Number(gridHeightResizePlus)";
	String list2Height = "130";
	String list2Width = "490";
	String list3Height = "$(window).height()-615+ Number(gridHeightResizePlus)";
	String list3Width = "490";
	
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	@SuppressWarnings("unchecked")	//서비스타입코드 리스트
	List<CodesDto> svcTypeCodeList = (List<CodesDto>)request.getAttribute("svcTypeCodeList");
	String svcTypeCdArrayString = "";
	for(CodesDto codesDto : svcTypeCodeList) {
		if("".equals(svcTypeCdArrayString)) svcTypeCdArrayString = codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
		else svcTypeCdArrayString +=  ";" + codesDto.getCodeVal1() + ":" + codesDto.getCodeNm1();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#srcButton").click( function() {
		var data = $("#list").jqGrid("getGridParam", "postData");
		data.srcSvcTypeCd = document.getElementById("srcSvcTypeCd").value;
		$("#list").jqGrid("setGridParam", { "postData": data });
		$("#list").trigger("reloadGrid");
	});
	$("#viewButton").click( function() { viewRow(); });
	$("#regButton").click( function() { addRow(); });
	$("#modButton").click( function() { editRow(); });
	$("#delButton").click( function() { deleteRow(); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });

	$("#viewButton2").click( function() { viewRow2(); });
	$("#colButton2").click( function() { jq("#list2").jqGrid('columnChooser'); });
	$("#excelButton2").click(function(){ exportExcel2(); });

	$("#viewButton3").click( function() { viewRow3(); });
	$("#regButton3").click( function() { addRow3(); });
	$("#modButton3").click( function() { editRow3(); });
	$("#delButton3").click( function() { deleteRow3(); });
	$("#colButton3").click( function() { jq("#list3").jqGrid('columnChooser'); });
	$("#excelButton3").click(function(){ exportExcel3(); });
	
	$("#btnUp").click(function(){
		var menuRow = $("#list").jqGrid('getGridParam','selrow');
		if(menuRow==null) {alert("화면권한과 연결하실 메뉴을 좌측 그리드에서 선택하십시오");return;}
		var menuSelrowContent = $("#list").jqGrid('getRowData',menuRow);
		var srcMenuId = 0;
		if(parseInt(menuSelrowContent.menuId)) srcMenuId = menuSelrowContent.menuId;	//key가 Uniq해야 하므로 최상위메뉴는 menuId를 svcTypeCd로 받음 그래서 예외처리함
		if(srcMenuId==0) {alert("최상위메뉴(서비스유형)에는 화면권한을 연결하실 수 없습니다."); return;}
		
		var unActivityRow = $("#list3").jqGrid('getGridParam','selrow');
		if(unActivityRow==null) {alert("메뉴와 연결하실 화면권한을 우측하단 그리드에서 선택하십시오");return;}
		var unActivitySelrowContent = $("#list3").jqGrid('getRowData',unActivityRow);
		var srcActivityId = unActivitySelrowContent.activityId;
		
		var transFlag = "REG";	//연결:REG, 연결삭제:DEL
		var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/menuActivityTransGrid.sys";
		$.post(url,{
				srcMenuId:srcMenuId,
				srcActivityId:srcActivityId,
				transFlag:transFlag
			},function(arg){ 
				if(fnAjaxTransResult(arg)) {
					$("#list3").trigger("reloadGrid");
					$("#list2").trigger("reloadGrid");
				}
			}
		);
	});
	$("#btnDown").click(function(){
		var menuRow = $("#list").jqGrid('getGridParam','selrow');
		if(menuRow==null) {alert("화면권한과 연결해제 하실 메뉴을 좌측 그리드에서 선택하십시오");return;}
		var menuSelrowContent = $("#list").jqGrid('getRowData',menuRow);
		var srcMenuId = 0;
		if(parseInt(menuSelrowContent.menuId)) srcMenuId = menuSelrowContent.menuId;	//key가 Uniq해야 하므로 최상위메뉴는 menuId를 svcTypeCd로 받음 그래서 예외처리함
		if(srcMenuId==0) {alert("최상위메뉴(서비스유형)에는 화면권한을 연결해제 하실 수 없습니다."); return;}
		
		var activityRow = $("#list2").jqGrid('getGridParam','selrow');
		if(activityRow==null) {alert("메뉴와 연결해제 하실 화면권한을 우측상단 그리드에서 선택하십시오");return;}
		var activitySelrowContent = $("#list2").jqGrid('getRowData',activityRow);
		var srcActivityId = activitySelrowContent.activityId;
		var tmpScopeNm = activitySelrowContent.scopeNm;
		var delTransScope = false;	//연결된 영역과의 삭제여부
		if(tmpScopeNm!="") {
			if(confirm("연결된 영역이 존재합니다.\n영역과의 연결도 끊으시겠습니까?")) delTransScope=true;
		}
		var transFlag = "DEL";	//연결:REG, 연결삭제:DEL
		var url = "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/menuActivityTransGrid.sys";
		$.post(url,{
				srcMenuId:srcMenuId,
				srcActivityId:srcActivityId,
				transFlag:transFlag,
				delTransScope:delTransScope
			},function(arg){ 
				if(fnAjaxTransResult(arg)) {
					$("#list2").trigger("reloadGrid");
					$("#list3").trigger("reloadGrid");
				}
			}
		);
	});
});

$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
// 	$("#list2").setGridWidth($(window).width()-770 + Number(gridWidthResizePlus));
// 	$("#list3").setGridWidth($(window).width()-770 + Number(gridWidthResizePlus));
	$("#list3").setGridHeight(<%=list3Height %>);
}).trigger('resize');  
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
var staticNum = 0;	//list2, list3 그리드를 한번만 초기화하기 위해
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/menuListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['상위메뉴명','구분','메뉴코드','메뉴명','서비스유형','출력순서','사용여부','연결된영역','경로URL','고정여부', 'menuId','topMenuId','parMenuId','menuLevel'],
		colModel:[
			{name:'parMenuNm',index:'parMenuNm', width:120,align:"left",hidden:true,search:false,
				editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
				editoptions:{disabled:true,dataInit:function(elem){
					var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
					var selrowContent = jq("#list").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
					$(elem).val(selrowContent.parMenuNm);
				}}
			},//상위메뉴명(등록화면에서 상위메뉴를 보여주기 위해)
			{name:'menuLevelName',index:'menuLevelName', width:90,align:"left",search:false,sortable:false,
				editable:false,formoptions:{rowpos:2,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}
			},//구분
			{name:'menuCd',index:'menuCd', width:170,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//메뉴코드
			{name:'menuNm',index:'menuNm', width:120,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:4,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"30"}
			},//메뉴명
			{name:'svcTypeCd',index:'svcTypeCd', width:70,align:"center",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:5,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"<%=svcTypeCdArrayString %>"}
			},//서비스유형
			{name:'disOrder',index:'disOrder', width:50,align:"center",search:false,sortable:false,
				editable:true,editrules:{required:true,number:true},formoptions:{rowpos:6,elmprefix:"<font color='red'>(*)</font>"},
	        	editoptions:{ size:"5",maxLength:"6", dataInit:function(elem){ 
					$(elem).numeric();
					$(elem).css("ime-mode", "disabled");
					if($(elem).val()=='') $(elem).val(0);
				}}
        	},//출력순서
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:false,
        		editable:true,editrules:{required:true},formoptions:{rowpos:7,elmprefix:"<font color='red'>(*)</font>"},
        		edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
        	},//사용여부
        	{name:'scopeNm',index:'scopeNm', width:150,align:"left",search:false,sortable:false,
        		editable:false,formoptions:{rowpos:8,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}
        	},//연결된영역
        	{name:'fwdPath',index:'fwdPath', width:200,align:"left",search:false,sortable:false,
        		editable:true,formoptions:{rowpos:9,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},
        		editoptions:{size:"50",maxLength:"100"}
        	},//경로URL
        	{name:'isFixed',index:'isFixed', width:50,align:"center",search:false,sortable:false,hidden:true,
        		editable:true,editrules:{required:true},formoptions:{rowpos:10,elmprefix:"<font color='red'>(*)</font>"},
        		edittype:"select",formatter:"select",editoptions:{value:"0:아니오;1:예"}
        	},//고정여부
        	
			{name:'menuId',index:'menuId',hidden:true,search:false,key:true},//menuId	
			{name:'topMenuId',index:'topMenuId',hidden:true,search:false},//topMenuId
			{name:'parMenuId',index:'parMenuId',hidden:true,search:false},//parMenuId
			{name:'menuLevel',index:'menuLevel',hidden:true,search:false}//parMenuId
		],
		postData: { srcSvcTypeCd:$("#srcSvcTypeCd").val() },
		rowNum:0, rownumbers: true, 
		height: <%=listHeight%>,width: <%=listWidth%>, 
		caption:"메뉴조회",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = parseInt(jq("#list").getGridParam('reccount'));
			if(rowCnt>0) {
				var top_rowid = $("#list").getDataIDs()[0];
				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
				var srcMenuId = 0;
				if(parseInt(selrowContent.menuId)) srcMenuId = selrowContent.menuId;	//key가 Uniq해야 하므로 최상위메뉴는 menuId를 svcTypeCd로 받음 그래서 예외처리함
				var srcMenuNm = selrowContent.menuNm;
				if(staticNum==0) {
					fnInitActivityList(srcMenuId,srcMenuNm);
					staticNum++;
				}
				jq("#list").setSelection(top_rowid);
			} else {
				jq("#list2").clearGridData();
				jq("#list2").jqGrid("setCaption","&nbsp;");
				jq("#list3").clearGridData();
				jq("#list3").jqGrid("setCaption","&nbsp;");
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var srcMenuId = 0;
			if(parseInt(selrowContent.menuId)) srcMenuId = selrowContent.menuId;	//key가 Uniq해야 하므로 최상위메뉴는 menuId를 svcTypeCd로 받음 그래서 예외처리함
			var srcMenuNm = selrowContent.menuNm;
			fnOnClickActivityList(srcMenuId,srcMenuNm);
		},
		afterInsertRow: function(rowid, aData){
			if(aData.isUse == "0"){
				$("#list").setCell(rowid,'menuLevelName','',{color:'red'});
				$("#list").setCell(rowid,'menuCd','',{color:'red'});
				$("#list").setCell(rowid,'menuNm','',{color:'red'});
				$("#list").setCell(rowid,'svcTypeCd','',{color:'red'});
				$("#list").setCell(rowid,'disOrder','',{color:'red'});
				$("#list").setCell(rowid,'isUse','',{color:'red'});
				$("#list").setCell(rowid,'fwdPath','',{color:'red'});
				$("#list").setCell(rowid,'isFixed','',{color:'red'});
			}
			var joinImage = "";
			if(Number(aData.menuLevel)>-1) {
				for(var i=0;i<Number(aData.menuLevel);i++) {
					joinImage += "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/empty.gif' style='vertical-align: bottom;'/>";
				}
				joinImage += "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/joinbottom.gif' style='vertical-align: bottom;'/>";
			}
			$("#list").setCell(rowid,'menuLevelName',joinImage+aData.menuLevelName);
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell" }
	});
});
function fnInitActivityList(srcMenuId,srcMenuNm) {
	var connectMenuNm = "<font color='blue'>["+srcMenuNm+"]</font>메뉴와 <font color='red'>연결된</font> 화면권한";
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/activityListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['화면권한코드','화면권한명','사용여부','연결된영역','activityId'],
		colModel:[
			{name:'activityCd',index:'activityCd', width:110,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//화면권한코드
			{name:'activityNm',index:'activityNm', width:100,align:"left",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"30"}
			},//화면권한명
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부
			{name:'scopeNm',index:'scopeNm', width:170,align:"left",search:false,sortable:false,
				editable:false,formoptions:{rowpos:4,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}
			},//연결된영역
			
			{name:'activityId',index:'activityId',hidden:true,search:false,key:true}//activityId	
		],
		postData: { srcMenuId:srcMenuId },
		rowNum:0, rownumbers: false, 
		height: <%=list2Height%>,width: <%=list2Width%>, 
		caption:connectMenuNm,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow2();") %>
		},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell" }
	});
	
	var unConnectMenuNm = "<font color='blue'>["+srcMenuNm+"]</font>메뉴와 <font color='red'>연결 안 된</font> 화면권한";
	jq("#list3").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/unActivityListJQGrid.sys',
		datatype: 'json',
		mtype: 'POST',
		colNames:['화면권한코드','화면권한명','사용여부','사용되는메뉴','activityId'],
		colModel:[
			{name:'activityCd',index:'activityCd', width:110,align:"left",search:true,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){
					$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");}}
			},//화면권한코드
			{name:'activityNm',index:'activityNm', width:100,align:"left",search:true,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"30"}
			},//화면권한명
			{name:'isUse',index:'isUse', width:50,align:"center",search:false,sortable:false,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}
			},//사용여부
			{name:'scopeNm',index:'scopeNm', width:170,align:"left",search:false,sortable:false,
				editable:false,formoptions:{rowpos:4,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}
			},//연결된영역
			
			{name:'activityId',index:'activityId',hidden:true,search:false,key:true}//activityId	
		],
		postData: { srcMenuId:srcMenuId },
		rowNum:10, rownumbers: false, rowList:[10,20,30,50], pager: '#pager3',
		height: <%=list3Height%>,width: <%=list3Width%>, 
		caption:unConnectMenuNm,
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {},
		ondblClickRow: function (rowid, iRow, iCol, e) { 
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow3();") %>
		},
		loadError : function(xhr, st, str){ $("#list3").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
	jq("#list3").jqGrid(
		'navGrid','#pager3',{ edit:false, add:false, del:false, search:true, excel:false },{ },{ },{ },
				//=,   !=,   >,    <,  %like%,like%,%like
		{ sopt:['eq', 'ne', 'lt', 'gt', 'cn', 'bw', 'ew'], closeOnEscape: true, multipleSearch: false, closeAfterSearch: true }
	);
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnOnClickActivityList(srcMenuId,srcMenuNm) {
	var data2 = jq("#list2").jqGrid("getGridParam", "postData");
	data2.srcMenuId = srcMenuId;
	jq("#list2").jqGrid("setCaption", "<font color='blue'>["+srcMenuNm+"]</font>메뉴와 <font color='red'>연결된</font> 화면권한");
	jq("#list2").jqGrid("setGridParam", { "postData": data2 });
	jq("#list2").trigger("reloadGrid");

	var data3 = jq("#list3").jqGrid("getGridParam", "postData");
	data3.filters="";
	data3.searchOper = "";
	data3.searchString = "";
	data3.searchField = "";
	data3._search = "";
	data3.srcMenuId = srcMenuId;
	jq("#list3").jqGrid("setCaption", "<font color='blue'>["+srcMenuNm+"]</font>메뉴와 <font color='red'>연결 안 된</font> 화면권한");
	jq("#list3").jqGrid("setGridParam", { "postData": data3 });
	jq("#list3").trigger("reloadGrid");
}

/*------------------------------List에 대한 처리-----------------------------------*/
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function addRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우
	if(row==null) {
		alert("메뉴등록은 상위메뉴를 선택한 후 등록버튼을 클릭하십시오!");
		return;
	}
	var selrowContent = jq("#list").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
 	if(Number(selrowContent.isFixed)==1 && Number(selrowContent.menuLevel)>-1) {
 		alert("고정메뉴는 하위메뉴을 가질 수 없습니다.");
 		return;
 	}
	var srcMenuId = 0;
	if(parseInt(selrowContent.menuId)) srcMenuId = selrowContent.menuId;	//key가 Uniq해야 하므로 최상위메뉴는 menuId를 svcTypeCd로 받음 그래서 예외처리함
	var tmpSvcTypeCd = "";	//selectbox의 값을 하나로 고정하기 위해 선언
<%	for(CodesDto codesDto : svcTypeCodeList) {	%>
	if(selrowContent.svcTypeCd=="<%=codesDto.getCodeVal1()%>") {
		tmpSvcTypeCd = "<%=codesDto.getCodeVal1()%>:<%=codesDto.getCodeNm1()%>";
	}
<%	}	%>
	jq("#list").jqGrid('setColProp', 'svcTypeCd',{editoptions:{value:tmpSvcTypeCd,disabled:true}});
	if(Number(selrowContent.menuLevel)>0) {	//대메뉴 이하는 동적메뉴만 등록 가능
		jq("#list").jqGrid('setColProp', 'isFixed',{editoptions:{value:"0:아니오"}});
	}
	jq("#list").jqGrid('setColProp', 'parMenuNm',{hidden:false,editable:true});
	jq("#list").jqGrid(
		'editGridRow','new',{
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/menuTransGrid.sys",
			editData: { parMenuId:srcMenuId,parMenuNm:selrowContent.menuNm },
			recreateForm: true, beforeShowForm: function(form){},
			width:"420",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
			beforeSubmit: function (postData) { //대문자로 바꿔서 넘겨줌
			    postData.menuCd = postData.menuCd.toUpperCase(); 
			    return [true, '']; 
			},
			afterSubmit : function(response, postdata){
				return fnJqTransResult(response, postdata);
			}
		}
	);
	jq("#list").jqGrid('setColProp', 'svcTypeCd',{editoptions:{value:"<%=svcTypeCdArrayString %>",disabled:false}});
	if(Number(selrowContent.menuLevel)>0) {
		jq("#list").jqGrid('setColProp', 'isFixed',{editoptions:{value:"0:아니오;1:예"}});
	}
	jq("#list").jqGrid('setColProp', 'parMenuNm',{hidden:true,editable:false});
}
function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	var selrowContent = jq("#list").jqGrid('getRowData',row); // 선택된 로우의 데이터 객체 조회
	var srcMenuId = 0;
	if(parseInt(selrowContent.menuId)) srcMenuId = selrowContent.menuId;	//key가 Uniq해야 하므로 최상위메뉴는 menuId를 svcTypeCd로 받음 그래서 예외처리함
	if(srcMenuId=="0") {
		alert("최상위 메뉴(서비스유형)은 수정이 불가합니다.");
		return;
	}
  	if( row != null ){
  		jq("#list").jqGrid('setColProp', 'menuCd',{editoptions:{
  			disabled:true,size:"20",maxLength:"20",dataInit: function(elem){
				$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");
			}}
  		});
  		jq("#list").jqGrid('setColProp', 'svcTypeCd',{editoptions:{value:"<%=svcTypeCdArrayString %>",disabled:true}});
  		jq("#list").jqGrid('setColProp', 'isFixed',{editoptions:{disabled:true,value:"0:아니오;1:예"}});
  		jq("#list").jqGrid(
  			'editGridRow', row,{ 
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/menuTransGrid.sys",
				editData:{},recreateForm: true,beforeShowForm: function(form) {},
				width:"420",modal:true,closeAfterEdit: true,reloadAfterSubmit:true,
   				afterSubmit : function(response, postdata){ 
   					return fnJqTransResult(response, postdata);
				}
			}
  		);
  		jq("#list").jqGrid('setColProp', 'menuCd',{editoptions:{
  			disabled:false,size:"20",maxLength:"20",dataInit: function(elem){
				$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");
			}}
  		});
  		jq("#list").jqGrid('setColProp', 'svcTypeCd',{editoptions:{value:"<%=svcTypeCdArrayString %>",disabled:false}});
  		jq("#list").jqGrid('setColProp', 'isFixed',{editoptions:{disabled:false,value:"0:아니오;1:예"}});
  	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function deleteRow() {
	var menuRow = jq("#list").jqGrid('getGridParam','selrow');
	var menuSelrowContent = jq("#list").jqGrid('getRowData',menuRow); // 선택된 로우의 데이터 객체 조회
	var srcMenuId = 0;
	if(parseInt(menuSelrowContent.menuId)) srcMenuId = menuSelrowContent.menuId;	//key가 Uniq해야 하므로 최상위메뉴는 menuId를 svcTypeCd로 받음 그래서 예외처리함
	if(srcMenuId=="0") {
		alert("최상위 메뉴(서비스유형)는 삭제가 불가합니다.");
		return;
	}
	var datas = $("#list").getDataIDs();
	var isLowMenu = false;
	for(var i=0;i<datas.length;i++) {
		var tmpSelrowContent = jq("#list").jqGrid('getRowData',datas[i]);
		var tmpParMenuId = tmpSelrowContent.parMenuId;
		if(srcMenuId==tmpParMenuId) { isLowMenu = true; break; }
	}
	if(isLowMenu) { alert("하위메뉴가 존재합니다.\n하위메뉴를 먼저 삭제 하십시오"); return; }
	if( menuRow != null ) {
		var activityCnt = jq("#list2").getGridParam('reccount');
		if(activityCnt>0) {
			alert("해당 메뉴는 우측 그리드 화면권한과 연결되어 있습니다.\n연결해제 후 처리하십시오");
			return;
		}
		jq("#list").jqGrid( 
			'delGridRow', menuRow,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/menuTransGrid.sys",
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
	var colLabels = ['메뉴코드','메뉴명','서비스유형','출력순서','사용여부','연결된영역','경로URL','고정여부'];	//출력컬럼명
	var colIds = ['menuCd','menuNm','svcTypeCd','disOrder','isUse','scopeNm','fwdPath','isFixed'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "메뉴리스트";	//sheet 타이틀
	var excelFileName = "MenuList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/*------------------------------List2에 대한 처리-----------------------------------*/
function viewRow2() {
	var row = jq("#list2").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list2").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
/**
 * list2 Excel Export
 */
function exportExcel2() {
	var colLabels = ['화면권한코드','화면권한명','사용여부','연결된영역'];	//출력컬럼명
	var colIds = ['activityCd','activityNm','isUse','scopeNm'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "연결된화면권한";	//sheet 타이틀
	var excelFileName = "ConnectActivityList";	//file명
	
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}


/*------------------------------List3에 대한 처리-----------------------------------*/
function viewRow3() {
	var row = jq("#list3").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list3").jqGrid( 'viewGridRow', row, { width:"400", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function addRow3() {
	jq("#list3").jqGrid(
		'editGridRow','new',{
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/activityTransGrid.sys",
			editData:{}, recreateForm:true, recreateForm:true, beforeShowForm: function(form){},
			width:"400",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
			beforeSubmit: function (postData) { //대문자로 바꿔서 넘겨줌
			    postData.activityCd = postData.activityCd.toUpperCase(); 
			    return [true, '']; 
			},
			afterSubmit : function(response, postdata){
				return fnJqTransResult(response, postdata);
			}
		}
	);
}
function editRow3() {
	var row = jq("#list3").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
  	if( row != null ){
  		jq("#list3").jqGrid('setColProp', 'activityCd',{editoptions:{
  			disabled:true,size:"20",maxLength:"20",dataInit: function(elem){
				$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");
			}}
  		});
  		jq("#list3").jqGrid(
  			'editGridRow', row,{ 
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/activityTransGrid.sys",
				editData:{},recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:true,
   				afterSubmit : function(response, postdata){ 
   					return fnJqTransResult(response, postdata);
				}
			}
  		);
  		jq("#list3").jqGrid('setColProp', 'activityCd',{editoptions:{
  			disabled:false,size:"20",maxLength:"20",dataInit: function(elem){
				$(elem).css("ime-mode", "disabled"); $(elem).css("text-transform","uppercase");
			}}
  		});
  	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function deleteRow3() {
	var unActivityRow = jq("#list3").jqGrid('getGridParam','selrow');
	var unActivitySelrowContent = jq("#list3").jqGrid('getRowData',unActivityRow); // 선택된 로우의 데이터 객체 조회
	if(unActivitySelrowContent.scopeNm!="") {
		alert("다른메뉴와 연결된 화면권한입니다.\n다른메뉴와의 연결을 모두 끊으시고 삭제하십시오!");
		return;
	}
	if( unActivityRow != null ) {
		jq("#list3").jqGrid( 
			'delGridRow', unActivityRow,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/activityTransGrid.sys",
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
 * list3 Excel Export
 */
function exportExcel3() {
	var colLabels = ['화면권한코드','화면권한명','사용여부','사용되는메뉴'];	//출력컬럼명
	var colIds = ['activityCd','activityNm','isUse','scopeNm'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "연결안된화면권한";	//sheet 타이틀
	var excelFileName = "UnConnectActivityList";	//file명
	
	fnExportExcel(jq("#list3"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

<style type="text/css">
/* 로우에 손가락 모양 */
.ui-jqgrid .ui-jqgrid-btable { cursor : pointer; }
</style>

</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<form id="frm" name="frm">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="29" class='ptitle'>메뉴/화면권한 관리</td>
					<td align="right">
						<a href="#"><img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
				</tr>
			</table>

			<!-- Search Context -->
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="6" height='1'></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">서비스유형</td>
					<td class="table_td_contents" colspan="5">
						<select name="srcSvcTypeCd" id="srcSvcTypeCd">
<%	for(CodesDto codesDto : svcTypeCodeList) { %>
							<option value="<%=codesDto.getCodeVal1() %>"><%=codesDto.getCodeNm1() %></option>
<%	} %>
							<option value="">전체</option>
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

			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<col width="700" />
				<col />
				<col width="100%"/>
				<tr>
					<td align="right" valign="middle">
						* 메뉴등록은 상위메뉴를 선택한 후 등록버튼을 클릭하십시오!&nbsp;
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="delButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
					<td>&nbsp;&nbsp;</td>
					<td>
						<table width="100%">
							<tr>
								<td align="left">* 메뉴의 화면권한 연결은 아래 [▲]와[▽]로 이동</td>
								<td align="right">
									<a href="#"><img id="viewButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="colButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="excelButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td rowspan="4">
						<div id="jqgrid">
							<table id="list"></table>
						</div>
					</td>
					<td rowspan="4"></td>
					<td>
						<div id="jqgrid">
							<table id="list2"></table>
						</div>
					</td>
				</tr>
				<tr>
					<td height="20" align="center">
						<a id="btnUp" href="#"><%=CommonUtils.isDisplayRole(roleList, "COMM_SAVE","▲") %></a>&nbsp;&nbsp;&nbsp;
						<a id="btnDown" href="#"><%=CommonUtils.isDisplayRole(roleList, "COMM_SAVE","▽") %></a>
					</td>
				</tr>
				<tr>
					<td align="right" valign="bottom">
						<a href="#"><img id="viewButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="regButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="modButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="delButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
				</tr>
				<tr>
					<td>
						<div id="jqgrid">
							<table id="list3"></table>
							<div id="pager3"></div>
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
<iframe name="excelFrm" frameborder="0" width="0" height="0"></iframe>	
</form>
</body>
</html>