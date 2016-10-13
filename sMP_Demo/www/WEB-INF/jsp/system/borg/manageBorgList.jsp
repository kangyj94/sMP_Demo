<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.BorgDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
//그리드의 width와 Height을 정의
	int listWidth = 480;
	String listHeight = "$(window).height()-364 + Number(gridHeightResizePlus)";

	int list2Width = 400;
	String list2Height = "$(window).height()-230 + Number(gridHeightResizePlus)";

//	String list3Width = "$(window).width()-980 + Number(gridWidthResizePlus)";
	String list3Width = "605";
	int list3Height = 300;
	
//	String list4Width = "$(window).width()-550 + Number(gridWidthResizePlus)";
	String list4Width = "1010";
	String list4Height = "$(window).height()-710 + Number(gridHeightResizePlus)";


	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	@SuppressWarnings("unchecked")	//운영사정보 가져오기
	List<BorgDto> adminBorgList = (List<BorgDto>)request.getAttribute("adminBorgList");
	BorgDto adminBorgDto = new BorgDto();
	for(BorgDto tmpBorgDto:adminBorgList) {
		adminBorgDto = tmpBorgDto;
		break;	//운영사는 한개만 존재한다는 가정
	}
	
	String workInfoValue = "";
	@SuppressWarnings("unchecked")	//고객유형 가져오기
	List<CodesDto> workInfoList = (List<CodesDto>)request.getAttribute("workInfoList");
	for(CodesDto codesDto:workInfoList) {
		if(!"".equals(workInfoValue)) workInfoValue += ";";
		workInfoValue += codesDto.getCodeVal1()+":"+codesDto.getCodeNm1();
	}
	
	String contractCdValue = "";
	@SuppressWarnings("unchecked")	//계약구분 가져오기
	List<CodesDto> contractCdList = (List<CodesDto>)request.getAttribute("contractCdList");
	for(CodesDto codesDto:contractCdList) {
		if(!"".equals(contractCdValue)) contractCdValue += ";";
		contractCdValue += codesDto.getCodeVal1()+":"+codesDto.getCodeNm1();
	}
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<%
   /**------------------------------------고객사팝업 사용방법---------------------------------
    * fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
    * borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
    * isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
    * borgNm : 찾고자하는 고객사명
    * callbackString : 콜백함수(문자열), 콜백함수파라메타는 4개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String) 
    */
%>
<%@ include file="/WEB-INF/jsp/common/buyMultiBorgListDiv.jsp"%>
<script type="text/javascript">
function fnSearchBuyBorg(){
	$("#connType").val("WRK");
	fnBuyMultiborgDialogForWorkInfo("BCH", "1", "", "1", "");
}

function fnSearchBuyBorgForAcc(){
	$("#connType").val("ACC");
	fnBuyMultiborgDialogForWorkInfo("BCH", "1", "", "", "1");
}

// 멀티선택 
function fnBuyMultiCallBack(rtnArryObj){
    var msg = ''; 
    msg += ''; 
    
    if(rtnArryObj.length > 0){
    	
    	var chkConnInfoArr = new Array();
    	for(var i = 0 ; i < rtnArryObj.length ; i++){
    		var selBorgInfo = rtnArryObj[i];
            chkConnInfoArr[i] = selBorgInfo['borgId'];
    	}
    	
    	if(!confirm("선택한 사업장을 추가하시겠습니까?")) return;
    	
    	var rowId1 = null;
    	var selrowContent1 = null;
    	var listNum = "";
    	
    	if($("#connType").val() == "WRK"){
	    	rowId1 = jq("#list2").jqGrid('getGridParam','selrow');
	    	selrowContent1 = jq("#list2").jqGrid('getRowData',rowId1);	
    		listNum = "3";
    	}else if($("#connType").val() == "ACC"){
    		listNum = "4";
	    	rowId1 = jq("#list").jqGrid('getGridParam','selrow');
	    	selrowContent1 = jq("#list").jqGrid('getRowData',rowId1);    		
    	}
    	
       	$.post(
       		"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveConnBranchs.sys", 
     	   	{	
       			oper:"add", 
       			chkConnInfoArr:chkConnInfoArr, 
       			workId:selrowContent1.workId, 
       			userId:selrowContent1.userId, 
       			connType:$.trim($("#connType").val())
       		},       
     	   	function(arg){ 
     	    	if(fnAjaxTransResult(arg)) {  //성공시
     	    		jq("#list" + listNum).trigger("reloadGrid");   	
     	    	}
     	   	}
     	);       	
    }
}
</script>

<!-- 사용자검색 스크립트 -->
<script type="text/javascript">
$(function(){
	$('#dialogPop').jqm();	//Dialog 초기화
	$("#regButton2").click(function(){
		var listRow = $("#list").jqGrid('getGridParam','selrow');
		if(listRow==null) { alert("좌측의 운영사 관리자가 선택되지 않았습니다."); return; }
		addRow2();
	});
});

/**
 * 조직조회 후 선택 Callback Function(반드시 있어야 함)	//필수
 */
function fnSelectBorgsCallback(borgIds, borgNms) {
	var listRow = $("#list").jqGrid('getGridParam','selrow');
	if(listRow==null) { alert("좌측의 운영사 관리자가 선택되지 않았습니다."); return; }
	var borgIdArray = new Array();
	for(var i=0;i<borgIds.length;i++) {
		var rowCnt = $("#list2").getGridParam('reccount');
		var isSameCnt = 0;
		for(var j=0;j<rowCnt;j++) {
			var list2Id = $("#list2").getDataIDs()[j];
			var list2SelrowContent = jq("#list2").jqGrid('getRowData',list2Id);
			if(Number(borgIds[i]) == Number(list2SelrowContent.manageBorgId)) {
				alert("조직["+borgNms[i]+"]는 이미 등록된 조직입니다.");
				isSameCnt++;
				break;
			}
		}
		if(isSameCnt==0) {
			borgIdArray[borgIdArray.length] = borgIds[i];
		}
	}
	var selrowContent = $("#list").jqGrid('getRowData',listRow);
	var userId = selrowContent.userId;
	if(!confirm("선택정보을 처리하겠습니까?")) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/manageBorgTransGrid.sys", 
		{ manageBorgIdArray:borgIdArray, userId:userId, oper:"add" },
		function(arg){
			$('#dialogPop').jqmHide();
			if(fnAjaxTransResult(arg)) {	//성공시
				jq("#list2").trigger("reloadGrid");
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
	$("#modButton2").click( function() { editRow2(); });
	$("#colButton").click( function() { $("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });

	$("#saveButton2").click( function() { saveWorkInfo(); });

	$("#regButton3").click( function() { fnSearchBuyBorg(); });
	$("#delButton3").click( function() {
		$("#connType").val("WRK");
		delConnBranchs(); 
	});
	$("#viewButton3").click( function() { viewRow3(); });
	$("#colButton3").click( function() { $("#list3").jqGrid('columnChooser'); });
	$("#excelButton3").click(function(){
		var rowid 			= $("#list2").jqGrid('getGridParam','selrow');
		var selrowContent	= jq("#list2").jqGrid('getRowData',rowid);
		$("#excelTxt").val(selrowContent.workNm);
		exportExcel3(); 
	});

	$("#viewButton4").click( function() { viewRow4(); });
	$("#colButton4").click( function() { $("#list4").jqGrid('columnChooser'); });
	$("#excelButton4").click(function(){
		var rowid 			= $("#list").jqGrid('getGridParam','selrow');
		var selrowContent	= jq("#list").jqGrid('getRowData',rowid);
		$("#excelTxt").val(selrowContent.userNm);
		exportExcel4(); 
	});
	$("#regButton4").click( function() { fnSearchBuyBorgForAcc(); });
	$("#delButton4").click( function() {
		$("#connType").val("ACC");
		delConnBranchs(); 
	});
});
$(window).bind('resize', function() { 
	$("#list").setGridHeight(<%=listHeight %>);
    $("#list2").setGridWidth(<%=list2Width %>);
    $("#list3").setGridWidth(<%=list3Width %>);
    $("#list2").setGridHeight(<%=list3Height %>);
    
    $("#list4").setGridWidth(<%=list4Width %>);
    $("#list4").setGridHeight(<%=list4Height %>);
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
		colNames:['사용자명','사용자ID','패스워드','사용권한','전화번호','핸드폰','이메일','Email발송','SMS발송','활성화여부','사용여부','userId'],
		colModel:[
			{name:'userNm',index:'userNm', width:70,align:"center",sortable:true, 
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20"}},//사용자명
			{name:'loginId',index:'loginId', width:80,align:"left",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:2,elmprefix:"<font color='red'>(*)</font>"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//사용자ID
			{name:'password',index:'password', width:60,align:"left",sortable:false,hidden:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:3,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"password",editoptions:{size:"20",maxLength:"20"}},//패스워드
			{name:'roleNms',index:'roleNms', width:200,align:"left",sortable:true,
				editable:false,editrules:{required:false},formoptions:{rowpos:4,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"}},//사용권한
			{name:'tel',index:'tel', width:80,align:"left",sortable:true,
				editable:true,editrules:{required:false},formoptions:{rowpos:5,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" 999-999-9999"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//전화번호
			{name:'mobile',index:'mobile', width:80,align:"left",sortable:true,
				editable:true,editrules:{required:false},formoptions:{rowpos:6,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" 999-999-9999"},
				editoptions:{size:"20",maxLength:"20",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//핸드폰
			{name:'email',index:'email', width:120,align:"left",sortable:true,
				editable:true,editrules:{required:false,email:true},formoptions:{rowpos:7,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;",elmsuffix:" XXXX@XXX.XXX"},
				formatter:'email',editoptions:{size:"30",maxLength:"30",dataInit: function(elem){$(elem).css("ime-mode", "disabled");}}},//이메일
			{name:'isEmail',index:'isEmail', width:70,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:8,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}},//EMAIL발송
			{name:'isSms',index:'isSms', width:70,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:9,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:발송;0:미발송"}},//SMS발송
			{name:'isLogin',index:'isLogin', width:70,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:10,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:활성;0:비활성"}},//활성화여부
			{name:'isUse',index:'isUse', width:70,align:"center",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:11,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"1:사용;0:미사용"}},//사용여부
			
			{name:'userId',index:'userId', hidden:true, key:true} //userId
		],
		postData: { svcTypeCd:'ADM', borgId:<%=adminBorgDto.getBorgId() %>, isLeaf:true, srcIsLogin:'', srcIsUse:'' },
		rowNum:30, rownumbers: true, rowList:[30,50,100,500,1000], pager: '#pager',
	   	height:<%=listHeight%>,width:<%=listWidth%>,
		sortname: 'userNm', sortorder: "asc",
		caption: "운영사 사용자 조회",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			var rowCnt = jq("#list").getGridParam('reccount');
			if(rowCnt>0) {
				var top_rowid = jq("#list").getDataIDs()[0];	//첫번째 로우 아이디 구하기
				var selrowContent = jq("#list").jqGrid('getRowData',top_rowid);
				var userId = selrowContent.userId;
				var userNm = selrowContent.userNm;
				if(staticNum==0) {
					fnInitList(userId, userNm);
					staticNum++;
				}
				jq("#list").setSelection(top_rowid);
			} else {
				if(staticNum>0) {
					jq("#list2").clearGridData();
					jq("#list2").jqGrid("setCaption","&nbsp;");
				} else {
					fnInitList(0, "");
					staticNum++;
				}
			}
		},
		onSelectRow: function (rowid, iRow, iCol, e) {
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var userId = selrowContent.userId;
			var userNm = selrowContent.userNm;
			fnOnClickList(userId, userNm);
		},
		afterInsertRow: function(rowid, aData){
			if(aData.isUse == "0"){
				jq("#list").setCell(rowid,'userNm','',{color:'red'});
				jq("#list").setCell(rowid,'loginId','',{color:'red'});
				jq("#list").setCell(rowid,'pwd','',{color:'red'});
				jq("#list").setCell(rowid,'roleNms','',{color:'red'});
				jq("#list").setCell(rowid,'tel','',{color:'red'});
				jq("#list").setCell(rowid,'mobile','',{color:'red'});
				jq("#list").setCell(rowid,'email','',{color:'red'});
				jq("#list").setCell(rowid,'isEmail','',{color:'red'});
				jq("#list").setCell(rowid,'isSms','',{color:'red'});
				jq("#list").setCell(rowid,'isLogin','',{color:'red'});
				jq("#list").setCell(rowid,'isUse','',{color:'red'});
			}
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {tel: fnSetTelformat(selrowContent.tel)});
			jq("#list").jqGrid('setRowData', rowid, {mobile: fnSetTelformat(selrowContent.mobile)});
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {
			<%=CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();") %>
		},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell", id: "userId" }
	});
});
var staticNum2 = 0;
function fnInitList(userId, userNm) {
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/workInfoListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['workId', 'userId' ,'선택' ,'고객유형명', '담당자명','자재유형', '계약구분', 'isChecked', 'orgChecked'],
		colModel:[
			{name:'workId',index:'workId',align:"center",sortable:false, hidden:true},
			{name:'userId',index:'userId',align:"left",sortable:false, hidden:true},
			{name:'isCheck',index:'isCheck',width:30,align:"center",search:false,sortable:false,editable:false,formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter }, 
			{name:'workNm',index:'workNm', width:170,align:"left",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:1,elmprefix:"<font color='red'>(*)</font>"}},
			{name:'userNm',index:'userNm', width:65,align:"left",sortable:true},
			{name:'mat_kind',index:'mat_kind', width:95,align:"left",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:11,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"<%=workInfoValue %>"}},//자재유형
			{name:'contract_cd',index:'mat_kind', width:95,align:"left",sortable:true,
				editable:true,editrules:{required:true},formoptions:{rowpos:12,elmprefix:"<font color='red'>(*)</font>"},
				edittype:"select",formatter:"select",editoptions:{value:"<%=contractCdValue %>"}},//계약구분
// 			{name:'isSktsManage',index:'isSktsManage', width:70,align:"center",sortable:true,
// 				editable:true,editrules:{required:true},formoptions:{rowpos:11,elmprefix:"<font color='red'>(*)</font>"},
// 				edittype:"select",formatter:"select",editoptions:{value:"1:예;0:아니오"}},//사용여부				
            {name:'isChecked',index:'isChecked', width:65,align:"left",sortable:false, hidden:true},
			{name:'orgChecked',index:'orgChecked', width:65,align:"left",sortable:false, hidden:true}
		],
		postData: { userId:userId },
	   	rowNum:0, rownumbers: false, 
		height:<%=list3Height%>,width: <%=list2Width%>,
		sortname: 'WORKNM', sortorder: "asc",
		caption:"운영사<font color='blue'>["+userNm+"]</font> 와 연결된 고객유형",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(data) {
			var rowCnt = jq("#list2").getGridParam('reccount');
			if(rowCnt>0) {
				var top_rowid = jq("#list2").getDataIDs()[0];	//첫번째 로우 아이디 구하기
				var selrowContent = jq("#list2").jqGrid('getRowData',top_rowid);
				var userId = selrowContent.userId;
				var workId = selrowContent.workId;
				if(staticNum2==0) {
					fnInitList2(userId, workId);
					staticNum++;
				}
				jq("#list2").setSelection(top_rowid);
			} else {
				if(staticNum2>0) {
					jq("#list3").clearGridData();
				} else {
					fnInitList2(0, 0);
					staticNum2++;
				}
			}
		},
		afterInsertRow: function(rowid, aData){
			var listRowid 			= $("#list").jqGrid('getGridParam','selrow');
			var selrowContentList 	= jq("#list").jqGrid('getRowData',listRowid);
			
			jq("#list2").jqGrid('setRowData', rowid, {orgChecked:"0"});
			jq("#list2").jqGrid('setRowData', rowid, {isChecked:"0"});
			
        	if(selrowContentList.userId == aData.userId && aData.userId != '') {
        		$("#isCheck_" + rowid).attr("checked", true);
        		jq("#list2").jqGrid('setRowData', rowid, {isChecked:"1"});
        		jq("#list2").jqGrid('setRowData', rowid, {orgChecked:"1"});
        	} else if(selrowContentList.userId != aData.userId && aData.userId != ''){
				jq("#list2").setCell(rowid,'workNm','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'userNm','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'mat_kind','',{color:'#BFBFBF'});
				jq("#list2").setCell(rowid,'contract_cd','',{color:'#BFBFBF'});
// 				jq("#list2").setCell(rowid,'isSktsManage','',{color:'#BFBFBF'});
				$("#isCheck_" + rowid).attr("disabled", true);
				jq("#list2").jqGrid('setRowData', rowid, {isChecked:"0"});
				jq("#list2").jqGrid('setRowData', rowid, {orgChecked:"0"});
        	} else if(aData.userId == ''){
				jq("#list2").setCell(rowid,'workNm','',{color:'red'});
				jq("#list2").setCell(rowid,'userNm','',{color:'red'});
				jq("#list2").setCell(rowid,'mat_kind','',{color:'red'});
				jq("#list2").setCell(rowid,'contract_cd','',{color:'red'});
// 				jq("#list2").setCell(rowid,'isSktsManage','',{color:'red'});
        		jq("#list2").jqGrid('setRowData', rowid, {isChecked:"0"});
        		jq("#list2").jqGrid('setRowData', rowid, {orgChecked:"0"});
        	}			
		},
		onSelectRow: function (rowId){
			var selrowContent = jq("#list2").jqGrid('getRowData',rowId);
			var workId = selrowContent.workId;
			var workNm = selrowContent.workNm;
			fnOnClickList2(workId, workNm);
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell", id: "borgId" }
	});
	
	jq("#list4").jqGrid({
		multiselect:true,
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/connAccBranchListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['사업장명', '사업자등록번호', '사업장코드', 'branchId', 'isChecked'],
		colModel:[
			{name:'branchNm',index:'branchNm', width:250,align:"left",sortable:false},
			{name:'businessNum',index:'businessNum', width:90,align:"left",sortable:false},
			{name:'branchCd',index:'branchCd', width:90,align:"left",sortable:false},
			{name:'branchId',index:'branchId', width:90,align:"left",sortable:false, hidden:true},
			{name:'isChecked',index:'isChecked', width:90,align:"left",sortable:false, hidden:true}
		],
		postData: { userId:userId },
	   	rowNum:0, rownumbers: false, 
	   	height:<%=list4Height%>,
	   	width:<%=list4Width%>,
		caption:"운영사<font color='blue'>["+userNm+"]</font> 의 관리 채권사업장",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(data) {},
		afterInsertRow: function(rowid, aData){
			jq("#list4").jqGrid('setRowData', rowid, {isChecked:"0"});
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		onSelectRow: function (rowid){
			var selrowContent = jq("#list4").jqGrid('getRowData',rowid);
			if(selrowContent.isChecked == "1")	jq("#list4").jqGrid('setRowData', rowid, {isChecked:"0"});
			else								jq("#list4").jqGrid('setRowData', rowid, {isChecked:"1"});
		},			
		onSelectAll:function (aRowids, status){
			var rowCnt = $("#list4").getGridParam('reccount');
			for(var i = 0 ; i < rowCnt ; i++){
				var rowId = $("#list4").getDataIDs()[i];
				if(status)	jq("#list4").jqGrid('setRowData', rowId, {isChecked:"1"});
				else		jq("#list4").jqGrid('setRowData', rowId, {isChecked:"0"});
			}
		},				
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell", id: "borgId" }
	});		
}

function fnInitList2(userId, workId) {
	jq("#list3").jqGrid({
		multiselect:true,
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/system/connWorkBranchListJQGrid.sys',
		datatype: 'json', mtype: 'POST',
		colNames:['workId', '사업장명', '사업자등록번호', '사업장코드', 'branchId', 'isChecked','권역'],
		colModel:[
			{name:'workId',index:'workId', width:90,align:"left",sortable:false, hidden:true},
			{name:'branchNm',index:'branchNm', width:240,align:"left",sortable:false},
			{name:'businessNum',index:'businessNum', width:80,align:"left",sortable:false},
			{name:'branchCd',index:'branchCd', width:80,align:"left",sortable:false},
			{name:'branchId',index:'branchId', width:90,align:"left",sortable:false, hidden:true},
			{name:'isChecked',index:'isChecked', width:90,align:"left",sortable:false, hidden:true},
			{name:'areaType',index:'areaType', width:40,align:"left",sortable:true}
		],
		postData: { userId:userId, workId:workId },
	   	rowNum:0, rownumbers: false, 
	   	height:<%=list3Height%>,width: <%=list3Width%>,
		caption:"고객유형과 연결된 사업장",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function(data) {
			var rowCnt = $("#list3").getGridParam('reccount');
			var listRowid 			= $("#list2").jqGrid('getGridParam','selrow');
			var selrowContentList 	= jq("#list2").jqGrid('getRowData',listRowid);
			jq("#list3").jqGrid("setCaption","고객유형<font color='blue'>["+selrowContentList.workNm+"]</font> 와 연결된 사업장 <font color='blue'>" + rowCnt + "개</font>");
		},
		afterInsertRow: function(rowid, aData){
			jq("#list3").jqGrid('setRowData', rowid, {isChecked:"0"});
		},
		onSelectRow: function (rowid){
			var selrowContent = jq("#list3").jqGrid('getRowData',rowid);
			if(selrowContent.isChecked == "1")	jq("#list3").jqGrid('setRowData', rowid, {isChecked:"0"});
			else								jq("#list3").jqGrid('setRowData', rowid, {isChecked:"1"});
		},		
		onSelectAll:function (aRowids, status){
			var rowCnt = $("#list3").getGridParam('reccount');
			for(var i = 0 ; i < rowCnt ; i++){
				var rowId = $("#list3").getDataIDs()[i];
				if(status)	jq("#list3").jqGrid('setRowData', rowId, {isChecked:"1"});
				else		jq("#list3").jqGrid('setRowData', rowId, {isChecked:"0"});
			}
		},
		sortname: 'areaType', sortorder: 'asc',
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
		jsonReader : { root: "list", repeatitems: false, cell: "cell", id: "borgId" }
	});	
}

</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' offval='no' style='border:none;' onclick=\"javaScript:fnSetChkVal('"+options.rowId+"')\"/>";
}

function fnSetChkVal(rowId, isChk){
	var selrowContent = jq("#list2").jqGrid('getRowData',rowId);
	
	if(selrowContent.isChecked == "1") {
		jq("#list2").jqGrid('setRowData', rowId, {isChecked:"0"});
	}else{
		jq("#list2").jqGrid('setRowData', rowId, {isChecked:"1"});
	}
}

function saveWorkInfo(){
	var chkCnt = 0;
	var unChkCnt = 0;
	var chkWorkInfoArr = new Array();
	var unChkWorkInfoArr = new Array();
	
	var rowCnt = $("#list2").getGridParam('reccount');
	
	for(var i = 0 ; i < rowCnt ; i++){
		var rowId = $("#list2").getDataIDs()[i];
		var selrowContent = jq("#list2").jqGrid('getRowData',rowId);
		if(selrowContent.orgChecked == "1" && selrowContent.isChecked == "0"){
			unChkWorkInfoArr[unChkCnt] = selrowContent.workId;
			unChkCnt++;
		}else if(selrowContent.orgChecked == "0" && selrowContent.isChecked == "1"){
			chkWorkInfoArr[chkCnt] = selrowContent.workId;
			chkCnt++;
		}
	}
	
	if(unChkCnt == 0 && chkCnt == 0) {
		alert("변경된 내용이 없습니다.");
		return;
	}

	if(!confirm("변경된 내용을 저장하시겠습니까?")) return;
	
	var rowId1 = jq("#list").jqGrid('getGridParam','selrow');
	var selrowContent1 = jq("#list").jqGrid('getRowData',rowId1);	
	
   	$.post(
 		"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveWorkInfo.sys", 
 	   	{chkWorkInfoArr:chkWorkInfoArr, unChkWorkInfoArr:unChkWorkInfoArr, userId:selrowContent1.userId},       
 	   	function(arg){ 
 	    	if(fnAjaxTransResult(arg)) {  //성공시
 	    		jq("#list2").trigger("reloadGrid");   	
 	    	}
 	   	}
 	);  	
}

function delConnBranchs(){
	var listNum = "";
	var unChkCnt = 0;
	var unChkConnInfoArr = new Array();
	
	if($("#connType").val() == "WRK")		listNum = "3";
	else if($("#connType").val() == "ACC")	listNum = "4";
	
	var rowCnt = $("#list" + listNum).getGridParam('reccount');
	
	for(var i = 0 ; i < rowCnt ; i++){
		var rowId = $("#list" + listNum).getDataIDs()[i];
		var selrowContent = jq("#list" +  + listNum).jqGrid('getRowData',rowId);
		if(selrowContent.isChecked == "1"){
			unChkConnInfoArr[unChkCnt] = selrowContent.branchId;
			unChkCnt++;
		}
	}
	
	if(unChkCnt == 0) {
		alert("변경된 내용이 없습니다.");
		return;
	}

	if(!confirm("선택한 항목을 삭제하시겠습니까?")) return;
	
	var rowId1;
	var selrowContent1;
	
	if($("#connType").val() == "WRK"){
		rowId1 = jq("#list2").jqGrid('getGridParam','selrow');
		selrowContent1 = jq("#list2").jqGrid('getRowData',rowId1);
	}else if($("#connType").val() == "ACC"){
		rowId1 = jq("#list").jqGrid('getGridParam','selrow');
		selrowContent1 = jq("#list").jqGrid('getRowData',rowId1);
	}
	
   	$.post(
 		"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/saveConnBranchs.sys", 
 	   	{oper:"del", unChkConnInfoArr:unChkConnInfoArr, workId:selrowContent1.workId, userId:selrowContent1.userId, connType:$.trim($("#connType").val())},       
 	   	function(arg){ 
 	    	if(fnAjaxTransResult(arg)) {  //성공시
 	    		jq("#list" + listNum).trigger("reloadGrid");   	
 	    	}
 	   	}
 	);  	
}

function fnOnClickList(userId, userNm) {
	var data = jq("#list2").jqGrid("getGridParam", "postData");
	data.userId = userId;
	jq("#list2").jqGrid("setCaption","운영사<font color='blue'>["+userNm+"]</font> 와 연결된 고객유형");
	jq("#list2").jqGrid("setGridParam", { "postData": data });
	jq("#list2").trigger("reloadGrid");

	var data = jq("#list4").jqGrid("getGridParam", "postData");
	data.userId = userId;
	jq("#list4").jqGrid("setCaption","운영사<font color='blue'>["+userNm+"]</font> 와 연결된 채권사업장");
	jq("#list4").jqGrid("setGridParam", { "postData": data });
	jq("#list4").trigger("reloadGrid");	
}

function fnOnClickList2(workId, workNm) {
	var data = jq("#list3").jqGrid("getGridParam", "postData");
	data.workId = workId;
	jq("#list3").jqGrid("setGridParam", { "postData": data });
	jq("#list3").trigger("reloadGrid");
}
/*------------------------------List에 대한 처리-----------------------------------*/
function viewRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list").jqGrid( 'viewGridRow', row, { width:"500", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function viewRow3() {
	var row = jq("#list3").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list3").jqGrid( 'viewGridRow', row, { width:"500", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}
function viewRow4() {
	var row = jq("#list4").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		jq("#list4").jqGrid( 'viewGridRow', row, { width:"500", modal:true, closeOnEscape:true } );
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function addRow() {
	jq("#list").jqGrid('setColProp', 'password',{hidden:false});
	jq("#list").jqGrid(
		'editGridRow', 'new',{
			addCaption:"운영사용자 추가",
			bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/userTransGrid.sys", 
			editData: {
				borgId:<%=adminBorgDto.getBorgId() %>, 
				svcTypeCd:'<%=adminBorgDto.getSvcTypeCd() %>'
			},
			recreateForm: true,beforeShowForm: function(form) {},
			width:"400",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
	jq("#list").jqGrid('setColProp', 'password',{hidden:true});
}

function addRow2() {
   	var rowid = $("#list").jqGrid('getGridParam','selrow');
   	var selrowContent = jq("#list").jqGrid('getRowData',rowid);
	
	jq("#list2").jqGrid(
		'editGridRow', 'new',{
			addCaption:"고객유형 추가",
			bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
			url: "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/workInfoTransGrid.sys", 
			editData: {userId:selrowContent.userId},
			recreateForm: true,beforeShowForm: function(form) {},
			width:"300",modal:true,closeAfterAdd: true,reloadAfterSubmit:true,
			afterSubmit : function(response, postdata){ 
				return fnJqTransResult(response, postdata);
			}
		}
	);
}


function editRow() {
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if(row != null){
		$.post(
			"/system/getUserPassword.sys",
			{
				userid:row
			},
			function(arg){
				var password = eval('('+arg+')').password;
				jq("#list").jqGrid('setRowData', row, {password:password});
				jq("#list").jqGrid('setColProp', 'password',{hidden:false});
				jq("#list").jqGrid('setColProp', 'loginId',{editoptions:{disabled:true}});
				var selrowContent = jq("#list").jqGrid('getRowData',row);
				jq("#list").jqGrid(
					'editGridRow', row,{ 
						editCaption: "운영사용자 수정",
						bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
						url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/userTransGrid.sys",
						editData: {
								borgId:<%=adminBorgDto.getBorgId() %>, 
								svcTypeCd:'<%=adminBorgDto.getSvcTypeCd() %>',
						},
						recreateForm: true,beforeShowForm: function(form) {},
						width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
						afterSubmit : function(response, postdata){ 
							return fnJqTransResult(response, postdata);
						}
					}
				);
				jq("#list").jqGrid('setColProp', 'pwd',{hidden:true});
				jq("#list").jqGrid('setColProp', 'loginId',{editoptions:{disabled:false}});
			}
		);
	} else { jq( "#dialogSelectRow" ).dialog(); }
}

function editRow2() {
	var row = jq("#list2").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
  	if( row != null ){
  		var selrowContent = jq("#list2").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
  		jq("#list2").jqGrid(
  			'editGridRow', row,{ 
  				editCaption: "고객유형 수정",
  				bottominfo:"<font color='red'>(*)</font>는 필수 입력정보 입니다.",
  				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/updateWorkInfo.sys",
  				editData: {workId:selrowContent.workId},
				recreateForm: true,beforeShowForm: function(form) {},
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
   				afterSubmit : function(response, postdata){ 
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
	var colLabels = ['조직명','사용자명','사용자ID','사용권한','전화번호','핸드폰','이메일','이메일발송','SMS발송','활성화여부','사용여부'];	//출력컬럼명
	var colIds = ['borgNms','userNm','loginId','roleNms','tel','mobile','email','isEmail','isSms','isLogin','isUse'];	//출력컬럼ID
	var numColIds = ['isEmail','isSms','isLogin','isUse'];	//숫자표현ID
	var sheetTitle = $("staticBorgNm").val()+" 사용자";	//sheet 타이틀
	var excelFileName = "BorgUserList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcel3() {
	var colLabels = ['사업장명','사업장등록번호','사업장코드','권역'];	//출력컬럼명
	var colIds = ['branchNm','businessNum','branchCd','areaType'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "고객유형 '" + $("#excelTxt").val() + "'의 사업장";	//sheet 타이틀
	var excelFileName = "ConnWorkBranchList";	//file명
	fnExportExcel(jq("#list3"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcel4() {
	var colLabels = ['사업장명','사업장등록번호','사업장코드'];	//출력컬럼명
	var colIds = ['branchNm','businessNum','branchCd'];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = $("#excelTxt").val() + "의 채권사업장";	//sheet 타이틀
	var excelFileName = "ConnAccBranchList";	//file명
	fnExportExcel(jq("#list4"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

/*------------------------------List2에 대한 처리-----------------------------------*/
function deleteRow2() {
	var row = jq("#list2").jqGrid('getGridParam','selrow');
	if( row != null ) {
		jq("#list2").jqGrid( 
			'delGridRow', row,{
				url:"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/manageBorgTransGrid.sys",
				width:"400",modal:true,closeAfterEdit: true,reloadAfterSubmit:false,
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
function exportExcel2() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	var userNm = "";
	if(row != null) {
		var selrowContent = jq("#list").jqGrid('getRowData',row);
		userNm = selrowContent.userNm;
	}
	var colLabels = ['조직구분','조직명','사용여부'];	//출력컬럼명
	var colIds = ['borgTypeNm','borgNm','isUse'];	//출력컬럼ID
	var numColIds = ['isUse'];	//숫자표현ID
	var sheetTitle = "운영자 "+userNm+"의 관리조직";	//sheet 타이틀
	var excelFileName = "BorgManageList";	//file명
	fnExportExcel(jq("#list2"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
</script>

</head>
<body>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<form id="frm" name="frm">
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#FFFFFF">
			<!-- 타이틀 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
					<td height="25" class='ptitle'>운영사 관리</td>
				</tr>
			</table>
			<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">조직명</td>
					<td class="table_td_contents"  width="400"><%=adminBorgDto.getBorgNm() %>
						<input type="hidden" id="connType" name="connType"/>
						<input type="hidden" id="excelTxt" name="excelTxt"/>
					</td>
					<td class="table_td_subject" width="100">조직코드</td>
					<td class="table_td_contents" width="400"><%=adminBorgDto.getBorgCd() %></td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="4" height='10'></td>
				</tr>
			</table>
			
			<table width="1500px" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
				<col width="<%=listWidth%>" />
				<col />
				<col width="100%"/>
				<tr>
					<td align="right" valign="middle">
						<a href="#"><img id="viewButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="modButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
					<td>&nbsp;&nbsp;</td>
					<td align="right" valign="middle" width="100%">
						<a href="#"><img id="regButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="modButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Modify.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
						<a href="#"><img id="saveButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Save.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>'  /></a>
					</td>
					<td></td>
					<td align="right" valign="middle" width="100%">
						<a href="#"><img id="viewButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="regButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
		                <a href="#"><img id="delButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
            			<a href="#"><img id="colButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
						<a href="#"><img id="excelButton3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
					</td>
				</tr>
				<tr>
					<td rowspan="2">
						<div id="jqgrid">
							<table id="list"></table>
							<div id="pager"></div>
						</div>
					</td>
					<td>&nbsp;</td>
					<td>
						<div id="jqgrid">
							<table id="list2"></table>
						</div>
					</td>
					<td>&nbsp;</td>
					<td>
						<div id="jqgrid">
							<table id="list3"></table>
						</div>
					</td>					
				</tr>
				<tr>
					<td></td>
					<td colspan="4">
						<table width="100%" style="height: 100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="right" valign="middle" width="100%">
									<a href="#"><img id="viewButton4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Text.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="regButton4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE") %>' /></a>
					                <a href="#"><img id="delButton4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' /></a>
			            			<a href="#"><img id="colButton4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>
									<a href="#"><img id="excelButton4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ") %>' /></a>								
								</td>
							</tr>
							<tr>
								<td>
									<div id="jqgrid">
										<table id="list4"></table>
									</div>					
								</td>
							</tr>						
						</table>
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

<%@ include file="/WEB-INF/jsp/common/svcBorgListDiv.jsp" %>
</form>
</body>
</html>