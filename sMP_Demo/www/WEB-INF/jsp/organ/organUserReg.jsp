<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.SrcBorgScopeByRoleDto"%>
<%@page import="kr.co.bitcube.organ.dto.SmpUsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>

<%
   	//그리드의 width와 Height을 정의
   	String listHeight = "50";
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
   	@SuppressWarnings("unchecked")   //화면권한가져오기(필수)
   	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
   
   	String      borgId   = (String)request.getAttribute("borgId");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<%
/**------------------------------------사용자팝업(멀티셀렉트) 사용방법---------------------------------
* fnJqmUserInitSearch(userNm, loginId, svcTypeCd, callbackString, branchId) 을 호출하여 Div팝업을 Display ===
* userNm : 찾고자하는 사용자명
* loginId : 찾고자하는 사용자 Login Id
* svcTypeCd : 찾는사용자의 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영자)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(사용자일련번호, 조직일련번호, 서비스유형명, 사용자명, 로그인아이디, 조직명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/directMngUserListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">
$(function(){
	$("#mngUserAddButton").click(function(){
		if($.trim($("#borgId").val()).length == 0){
			alert("사업장을 선택해주세요.");
			return;
		}
		fnJqmUserInitSearch("", "", "BUY", "fnDirectUserCallBack", $("#borgId").val(), "");
	});
	$("#mngUserDelButton").click(function(){
		var id = $("#list2").jqGrid('getGridParam', "selrow" );
		if(id == null){
			alert("삭제할 항목을 선택해주세요.");
		}
		jQuery("#list2").delRowData(id);
	});
});
/**
 * 사용자검색 Callback Function
 */
function fnDirectUserCallBack(loginIdArr, userIdArr, userNmArr) {
	var rowCnt = $("#list2").getGridParam('reccount');
	var rtnMsg = "";
	var chkCnt = 0;
	var isCheck = false;
	var maxId = new Array();
	for(var i = 0 ; i < loginIdArr.length ; i++){
		if(rowCnt == 0){
			var setRow = i+1;
			jq("#list2").addRowData(setRow, {loginId:loginIdArr[i], userId:userIdArr[i], userNm:userNmArr[i]});
		}else{
			var rowid = "";
		   	for(var j = 0 ; j < rowCnt ; j++) {
				rowid = $("#list2").getDataIDs()[j];
			    var selrowContent = $("#list2").jqGrid('getRowData',rowid);
			    maxId[j] = parseInt(rowid);
			    if(loginIdArr[i] == selrowContent.loginId) { 
			    	rtnMsg += "사용자명["+userNmArr[i]+"]\n";
			    	chkCnt++;
			    	isCheck = true;
			    }
			}
		   	if(!isCheck) {
		   		var setRow = parseInt (maxId.reverse()[0]) + i + 1;
				jq("#list2").addRowData(setRow, {loginId:loginIdArr[i], userId:userIdArr[i], userNm:userNmArr[i]});
		   	}
		   	isCheck = false;
		}
	}
	
	if(chkCnt > 0){
		alert(rtnMsg + "\n는 이미 추가된 사용자입니다.");
	}
}
</script>
<% //------------------------------------------------------------------------------ %>


<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<!-- 고객사검색관련 스크립트 -->

<script type="text/javascript">
$(document).ready(function(){
<%
   String _srcGroupId = "";
   String _srcClientId = "";
   String _srcBranchId = "";
   String _srcBorgNms = "";
   SrcBorgScopeByRoleDto _srcBorgScopeByRoleDto = null;
   if("BUY".equals(loginUserDto.getSvcTypeCd())) {
      _srcBorgScopeByRoleDto = loginUserDto.getSrcBorgScopeByRoleDto();
      _srcGroupId = _srcBorgScopeByRoleDto.getSrcGroupId();
      _srcClientId = _srcBorgScopeByRoleDto.getSrcClientId();
      _srcBranchId = _srcBorgScopeByRoleDto.getSrcBranchId();
      _srcBorgNms = _srcBorgScopeByRoleDto.getSrcBorgNms();
      _srcBorgNms = _srcBorgNms.replaceAll("&gt;", ">");
   }
%>
   $("#clientId").val("<%=_srcClientId %>");
<% if("BUY".equals(loginUserDto.getSvcTypeCd())) { %>
   $("#clientNm").attr("disabled", true);
   $("#srcBorgNmDiv").attr("disabled", true);
   fnCallBackClient('<%=_srcGroupId %>', '<%=_srcClientId %>', '<%=_srcBranchId %>', '<%=_srcBorgNms %>', '');
<% }  %>
});
</script>


<script type="text/javascript">
$(document).ready(function(){
   $("#srcClientBtn").click(function(){
	   fnBuyborgDialogForClientId("BCH", "1", "", "fnCallBackClient", '<%=_srcClientId%>');
   });
   $("#roleAddButton").click(function(){
      fnJqmAddRole();
   });   
   $("#roleDelButton").click(function(){
      fnRoleDel();
   });      
   $("#branchNm").attr("disabled", true);

	//기본적으로 사용자 등록시 SMS 발송이 기본이 되도록. 옵션도 모두 다 체크.
	$("#smsByPurchase").val("1");
	$("#smsByDelivery").val("1");
	$("#smsByRegisterGood").val("1");      		   

	$("#smsByPurchase").attr("checked", true);
	$("#smsByDelivery").attr("checked", true);
	$("#smsByRegisterGood").attr("checked", true);
});
  

/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackClient(groupId, clientId, branchId, borgNm, areaType) {
	if("" != branchId){
		$("#branchNm").val(borgNm);
   		$("#borgId").val(branchId);
	}
}

</script>
<% //------------------------------------------------------------------------------ %>

<%
/**------------------------------------권한팝업 사용방법 시작---------------------------------
* fnJqmAddRoleListInit(svcTypeCd, callbackString) 을 호출하여 Div팝업을 Display ===
* svcTypeCd : 서비스코드("BUY":고객사, "VEN":공급사, "ADM":운영자, "CEN":물류센타)
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 6개(권한ID, 권한코드, 권한명, 기본권한여부, 권한조직범위코드, 권한설명) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/addRoleListDiv.jsp" %>
<!-- 사용자검색 관련 스크립트 -->
<script type="text/javascript">

var jq = jQuery;
var codeList = null;
$(document).ready(function() {
   
   $.post(  //조회조건의 상태
      '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
      {codeTypeCd:"BORGSCOPECD", isUse:"1"},
      function(arg){
         codeList = eval('(' + arg + ')').codeList;
      }
   );    
   
   $("#defaultButton").click(function(){
      fnIsDefault();
   });
});

function fnJqmAddRole() {
   fnJqmAddRoleListInit("BUY","fnAddRoleCallBack");
}
function fnAddRoleCallBack(roleId, roleCd, roleNm, isDefault, borgScopeCd, roleDesc) {
	var rowCnt = $("#list").getGridParam('reccount');
	var maxId = new Array();
	for(var i=0;i<rowCnt;i++) {
		var rowid = $("#list").getDataIDs()[i];
		maxId[i] = parseInt(rowid); 
		var selrowContent = $("#list").jqGrid('getRowData',rowid);
		if(roleId == selrowContent.roleId || roleCd == selrowContent.roleCd) { 
			alert("이미 등록된 권한입니다."); 
			return; 
		}
	}
	var setIsDefault    = "0";
	var setIsDefaultStr  = "아니요";
	if(rowCnt == 0){
		setIsDefault = "1";
		setIsDefaultStr  = "예";
	}
	var borgScopeCdStr = "";

	for(var i = 0 ; i < codeList.length ; i++){
		if(codeList[i].codeVal1 == borgScopeCd){
			borgScopeCdStr = codeList[i].codeNm1;
			break;
		}
	}
	var setRow = rowCnt == 0 ? 1 : parseInt (maxId.reverse()[0]) + 1;
	jq("#list").addRowData(setRow, {isDefaultCd:setIsDefault, isDefault:setIsDefaultStr, roleCd:roleCd, roleNm:roleNm, roleDesc:roleDesc, borgScopeCd:borgScopeCd, roleId:roleId ,borgScopeNm:borgScopeCdStr});   
}
function fnRoleDel(){
   var id = $("#list").jqGrid('getGridParam', "selrow" );
   
    if(id == null){
      $("#dialog").html("<font size='2'>삭제할 항목을 선택해주세요.</font>");
         $("#dialog").dialog({
         title: 'fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
         });      
         return;
      }
      jQuery("#list").delRowData(id);
}

function fnIsDefault(){
   var rowid = $("#list").jqGrid('getGridParam', "selrow" );
   var selrowContent = jq("#list").jqGrid('getRowData',rowid);
   
   if(rowid == null){
      $("#dialog").html("<font size='2'>설정할 항목을 선택해주세요.</font>");
      $("#dialog").dialog({
         title: 'fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });      
      return;
   }
   
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveUserRoles.sys", 
      { oper:'upd', userId:selrowContent.userId, roleId:selrowContent.roleId, borgId:selrowContent.borgId},
      function(arg){
         if(fnAjaxTransResult(arg)) {
            jq("#list").trigger("reloadGrid");  
         }
      }
   ); 
}
</script>
<%//----------------------------------권한팝업 사용방법 끝----------------------------------------%>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
   $("#srcUserNm").keydown(function(e){
      if(e.keyCode==13) {
         $("#srcButton").click();
      }
   });

   $("#saveButton").click(function(){
      fnApply();
   });   
   $("#loginIdConfirm").click( function() {
	  fnLoginIdConfirm(); 
   });   
   $("#loginId").keydown(function(e){ 
	  if(e.keyCode==13) { 
		  $("#loginIdConfirm").click(); 
	  } 
   });   
});
</script>

<!-- 그리드 초기화 스크립트 -->
<%-- to-be :  아래 그리드 부분 적절히 수정할것. --%>
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
    	datatype: 'json',
      	mtype: 'POST',
      	colNames:['권한코드', '권한명', '기본권한여부', '조직허용범위', '권한설명', 'userId', 'roleId', 'borgId', 'isDefaultCd', 'borgScopeCd'],
      	colModel:[
        	{name:'roleCd',index:'roleCd', width:90,align:"left",search:false,sortable:false, editable:false },
         	{name:'roleNm',index:'roleNm', width:200,align:"left",search:false,sortable:false, editable:false },
         	{name:'isDefault',index:'isDefault', width:80,align:"center",search:false,sortable:false, editable:false },
         	{name:'borgScopeNm',index:'borgScopeNm', width:90,align:"center",search:false,sortable:false, editable:false },
         	{name:'roleDesc',index:'roleDesc', width:370,align:"left",search:false,sortable:true, editable:false },
         	{name:'userId',index:'userId', width:200,align:"left",search:false,sortable:true, editable:false, hidden:true },
         	{name:'roleId',index:'roleId', width:200,align:"left",search:false,sortable:true, editable:false, hidden:true },
         	{name:'borgId',index:'borgId', width:200,align:"left",search:false,sortable:true, editable:false, hidden:true },
         	{name:'isDefaultCd',index:'isDefault', width:80,align:"center",search:false,sortable:true, editable:false , hidden:true},
         	{name:'borgScopeCd',index:'borgScopeCd', width:200,align:"left",search:false,sortable:true, editable:false , hidden:true}
      	],
      	postData: {borgId:'<%=borgId%>'},
      	height: 80,width: 295,
      	sortname: 'isDefault', sortorder: "desc",
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {},
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {
        	<%-- // 추후 개발시 참조. CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")--%>
      	},
      	onCellSelect: function(rowid, iCol, cellcontent, target){},
      	loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
      	jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
   	}); 
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
    	datatype: 'json',
      	mtype: 'POST',
      	colNames:['userId', '로그인ID', '사용자명'],
      	colModel:[
         	{name:'userId',index:'userId', width:200,align:"left",search:false,sortable:true, editable:false, hidden:true },
         	{name:'loginId',index:'loginId', width:80,align:"center",search:false,sortable:true, editable:false , hidden:false},
         	{name:'userNm',index:'userNm', width:180,align:"left",search:false,sortable:true, editable:false , hidden:false}
      	],
      	postData: {},
      	height: 80,width: 295,
      	sortname: 'isDefault', sortorder: "desc",
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {},
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {
        	<%-- // 추후 개발시 참조. CommonUtils.isDisplayRole(roleList, "COMM_READ","viewRow();")--%>
      	},
      	onCellSelect: function(rowid, iCol, cellcontent, target){},
      	loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
      	jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
   	}); 	
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnChangeChkValue(obj){
	var chgObj = "$('#" + obj + "')";
	   
   	if(obj == "isEmail"){
    	if(eval(chgObj).val() == "0"){
 		   	$("#emailByPurchase").val("0");
		   	$("#emailByDelivery").val("0");
		   	$("#emailByRegisterGood").val("0");		   
		   
		   	$("#emailByPurchase").attr("checked", false);
		   	$("#emailByDelivery").attr("checked", false);
		   	$("#emailByRegisterGood").attr("checked", false);   	           
      	} else {
 		   	$("#emailByPurchase").val("1");
		   	$("#emailByDelivery").val("1");
		   	$("#emailByRegisterGood").val("1");		   
		   
		   	$("#emailByPurchase").attr("checked", true);
		   	$("#emailByDelivery").attr("checked", true);
		   	$("#emailByRegisterGood").attr("checked", true);   	
      	}
   	}else if(obj == "isSms") {
    	if(eval(chgObj).val() == "0"){
 		   	$("#smsByPurchase").val("0");
		   	$("#smsByDelivery").val("0");
		   	$("#smsByRegisterGood").val("0");      		   

		   	$("#smsByPurchase").attr("checked", false);
		   	$("#smsByDelivery").attr("checked", false);
		   	$("#smsByRegisterGood").attr("checked", false);              
      	} else {
 		   	$("#smsByPurchase").val("1");
		   	$("#smsByDelivery").val("1");
		   	$("#smsByRegisterGood").val("1");      		   

		   	$("#smsByPurchase").attr("checked", true);
		   	$("#smsByDelivery").attr("checked", true);
		   	$("#smsByRegisterGood").attr("checked", true);           
      	}      
   	}

   	if(obj.indexOf("email") != -1) {
   		if(eval(chgObj).val()=="0") eval(chgObj).val("1");
  		else if(eval(chgObj).val()=="1") eval(chgObj).val("0");
      	
  		if($("#isEmail").val() == "0"){
      		$("#isEmail").val("1");
      	}else{
      		if($("#emailByPurchase").val() == "0" 
      		&& $("#emailByDelivery").val() == "0" 
      		&& $("#emailByRegisterGood	").val() == "0"){
      			$("#isEmail").val("0");
      		}
      	}     
   	}else if(obj.indexOf("sms") != -1) {
   		if(eval(chgObj).val()=="0") eval(chgObj).val("1");
  		else if(eval(chgObj).val()=="1") eval(chgObj).val("0");
      	
  		if($("#isSms").val() == "0"){
      		$("#isSms").val("1");
      	}else{
      		if($("#smsByPurchase").val() == "0" 
      		&& $("#smsByDelivery").val() == "0" 
      		&& $("#smsByRegisterGood").val() == "0"){
      			$("#isSms").val("0");
      		}
      	}
   	}
}

function fnIsValidation(){
	var branchId = $.trim($("#borgId").val());
	var userNm = $.trim($("#userNm").val());
	var loginId = $.trim($("#loginId").val());
	var pwd = $.trim($("#pwd").val());
	var pwdConfirm = $.trim($("#pwdConfirm").val());
	var tel = $.trim($("#tel").val());
	var mobile = $.trim($("#mobile").val());
	var eMail = $.trim($("#eMail").val());
	var isUse = $.trim($("#isUse").val());
	var roleCnt = $("#list").getGridParam('reccount');
	
	if(branchId == ""){
		 $("#dialog").html("<font size='2'>사업장을 선택해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }

	 if(userNm == ""){
		 $("#dialog").html("<font size='2'>성명을 입력해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }	
	
	if(loginId == ""){
		 $("#dialog").html("<font size='2'>로그인ID를 입력해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }
	
	 if(!isLoginIdCheck){
		 $("#dialog").html("<font size='2'>로그인ID 중복체크가 필요합니다.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });				 
	 	 return false; 			 
	 }			

	 if(pwd == ""){
		 $("#dialog").html("<font size='2'>비밀번호를 입력해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }

	 if(pwdConfirm == ""){
		 $("#dialog").html("<font size='2'>비밀번호확인을 입력해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }else{
		 if(pwd != pwdConfirm){
	 		 $("#dialog").html("<font size='2'>입력하신 비밀번호가 다릅니다. \n다시확인해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });						 
			 
			 return false;
		 }
	 }

	 if(tel == ""){
		 $("#dialog").html("<font size='2'>전화번호를 입력해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }

	 if(mobile == ""){
		 $("#dialog").html("<font size='2'>이동전화번호를 입력해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }
	 
	 if(eMail == ""){
		 $("#dialog").html("<font size='2'>E-MAIL을 입력해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }else{
		 email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
		 if(!email_regex.test(eMail)){
	 		 $("#dialog").html("<font size='2'>E-MAIL 유형을 확인해주세요.</font>");
			 $("#dialog").dialog({
				 title: 'Success',modal: true,
				 buttons: {"Ok": function(){$(this).dialog("close");} }
			 });				 
		 	 return false; 
		 }
	 }		
	 
	 if(isUse == ""){
		 $("#dialog").html("<font size='2'>상태를 선택해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }	 
	 
	 if(roleCnt == 0) {
		 $("#dialog").html("<font size='2'>1개 이상의 권한을 설정해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;		 
	 }
	 
	 
	 var isDirect  = $.trim($("#isDirect").val());
	 var directCnt = $("#list2").getGridParam('reccount');
	 if(isDirect == "Y" && directCnt == 0){
		 $("#dialog").html("<font size='2'>감독관리사용자를 설정해주세요.</font>");
		 $("#dialog").dialog({
			 title: 'Success',modal: true,
			 buttons: {"Ok": function(){$(this).dialog("close");} }
		 });			 
		 return false;
	 }	 	 
	 
	return true;
}

function fnApply(){
	var isValidation = fnIsValidation();
	if(isValidation == true){
		if(!confirm("입력한 내용을 저장하시겠습니까?")) return;
	    var roleIdArr 			= Array();
	    var isDefaultArr		= Array();
	    var roleCnt          	= jq("#list").getGridParam('reccount');
	    for(var i = 0 ; i < roleCnt ; i++){
	       var rowid = $("#list").getDataIDs()[i];   
	       var selrowContent    = jq("#list").jqGrid('getRowData',rowid);
	       roleIdArr[i] 	= selrowContent.roleId;
	       isDefaultArr[i]	= selrowContent.isDefaultCd;
	    }
	    
	    
	    var userIdArr	= Array();
	    var dirUserCnt  = jq("#list2").getGridParam('reccount');
	    
	    for(var i = 0 ; i < dirUserCnt ; i++){
	    	var rowid = $("#list2").getDataIDs()[i];   
	       	var selrowContent   = jq("#list2").jqGrid('getRowData',rowid);
	       	userIdArr[i] 		= selrowContent.userId;
	    }	    
	    
	    $.post(
	      "<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/saveUserDetail.sys", 
	      {  
	         oper:"add",
	         borgId:$.trim($("#borgId").val()),
	         userId:$.trim($("#userId").val()),
	         userNm:$.trim($("#userNm").val()),
	         loginId:$.trim($("#loginId").val()),
	         pwd:$.trim($("#pwd").val()),
	         tel:$.trim($("#tel").val()),
	         mobile:$.trim($("#mobile").val()),
	         eMail:$.trim($("#eMail").val()),
	         isUse:$.trim($("#isUse").val()),
	         endCauseDesc:$.trim($("#endCauseDesc").val()),
	         userNote:$.trim($("#userNote").val()),
	         isEmail:$.trim($("#isEmail").val()),
	         isSms:$.trim($("#isSms").val()),
	         emailByPurchase:$.trim($("#emailByPurchase").val()),
	         emailByDelivery:$.trim($("#emailByDelivery").val()),
	         emailByRegisterGood:$.trim($("#emailByRegisterGood").val()),
	         smsByPurchase:$.trim($("#smsByPurchase").val()),
	         smsByDelivery:$.trim($("#smsByDelivery").val()),
	         smsByRegisterGood:$.trim($("#smsByRegisterGood").val()),         
	         roleIdArr:roleIdArr,
	         isDefaultArr:isDefaultArr,
	         isDirect:$.trim($("#isDirect").val()),
	         userIdArr:userIdArr
	      },
	      function(arg){
	         if(fnAjaxTransResult(arg)) {
					//var opener = window.dialogArguments;
					window.opener.fnSearch();
					window.close();
	         }
	      }
	   ); 		
	} 	
}

var isLoginIdCheck = false;
function fnLoginIdConfirm(){
	if($.trim($("#loginId").val()) == ""){
		$("#dialog").html("<font size='2'>로그인ID를 입력해주세요.</font>");
		$("#dialog").dialog({
			title: 'Success',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});	
		return;
	}		
	
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/organ/loginIdDupCheck.sys", 
		{ loginId:$("#loginId").val() },
		function(arg){ 
			if(fnTransResult(arg, false)) {
				isLoginIdCheck = true;
				$("#dialog").html("<font size='2'>사용가능합니다.</font>");
				$("#dialog").dialog({
					title: 'Success',modal: true,
					buttons: {"Ok": function(){$(this).dialog("close");} }
				});
			}
		}
	);		
}

</script>

</head>
<body>
   <form id="frm" name="frm" onsubmit="return false;">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td colspan="3">
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
                     </td>
                     <td height="29" class='ptitle'>사용자 상세</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td colspan="3">
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                  <tr>
                     <td width="20" valign="top">
                        <img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">사용자 정보</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td colspan="3">
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="4" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9">사업장</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="branchNm" name="branchNm" type="text" value="" size="" maxlength="50" style="width: 80%" class="input_text_none" />
                        <input id="borgId" name="borgId" type="hidden" value="" size="" maxlength="50" style="width: 80%" class="input_text_none" />
                        <a href="#"> 
                           <img id="srcClientBtn" name="srcClientBtn" src="/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search'style="border: 0px; vertical-align: middle;" />
                        </a>                     
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9">성명</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="userId" name="userId" type="hidden" value="0" size="20" maxlength="30" />
                        <input id="userNm" name="userNm" type="text" value="" size="20" maxlength="30" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">아이디</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="loginId" name="loginId" type="text" value="" size="20" maxlength="30"/>
                        <button id='loginIdConfirm' class="btn btn-darkgray btn-xs" ><i class="fa fa-check"></i>중복확인</button>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">비밀번호</td>
                     <td class="table_td_contents">
                        <input id="pwd" name="pwd" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/>
                     </td>
                     <td class="table_td_subject9" width="100">비밀번호 확인</td>
                     <td class="table_td_contents">
                        <input id="pwdConfirm" name="pwdConfirm" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">전화번호</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="tel" name="tel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9" width="100">이동전화번호</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="mobile" name="mobile" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9">이메일</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="eMail" name="eMail" type="text" value="" size="30" maxlength="30" style="ime-mode: disabled;"/> ex)admin@unpamsbank.com
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject9">상태</td>
                     <td class="table_td_contents">
                        <select class="select" id="isUse" name="isUse">
                           <option value="1" >정상</option>
                           <option value="0" >종료</option>
                        </select>
                     </td>
                     <td class="table_td_subject9">감독유무</td>
                     <td class="table_td_contents">
                        <select class="select" id="isDirect" name="isDirect">
                           <option value="N" >아니요</option>
                           <option value="Y" >예</option>
                        </select>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">종료사유</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="endCauseDesc" name="endCauseDesc" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">참고사항</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="userNote" name="userNote" type="text" value="" size="20" maxlength="30" style="width: 98%" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
                           <tr>
                              <td width="50%">이메일 발송</td>
                              <td>&nbsp;</td>
                              <td>
                               	<select class="select" id="isEmail" name="isEmail" onchange="fnChangeChkValue('isEmail')">
                               		<option value="1" >발송</option>
                               		<option value="0" selected="selected">미발송</option>
                               	</select>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td colspan="3" class="table_td_contents">  
                        <label>
                           <input id="emailByPurchase" name="emailByPurchase" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onclick="javaScript:fnChangeChkValue('emailByPurchase');"/> 발주접수
                        </label> 
                        <label>
                           <input id="emailByDelivery" name="emailByDelivery" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onclick="javaScript:fnChangeChkValue('emailByDelivery');"/> 출하
                        </label> 
                        <label>
                           <input id="emailByRegisterGood" name="emailByRegisterGood" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onclick="javaScript:fnChangeChkValue('emailByRegisterGood');"/> 상품등록처리
                        </label> 
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 15px;">
                           <tr>
                              <td width="50%">SMS 발송</td>
                              <td>&nbsp;</td>
                              <td>
                               	<select class="select" id="isSms" name="isSms" onchange="fnChangeChkValue('isSms')">
                               		<option value="1" selected="selected">발송</option>
                               		<option value="0">미발송</option>
                               	</select>
                              </td>
                           </tr>
                        </table>                     
                     </td>
                     <td colspan="3" class="table_td_contents">
                        <label>
                           <input id="smsByPurchase" name="smsByPurchase" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onclick="javaScript:fnChangeChkValue('smsByPurchase');"/> 발주접수
                        </label> 
                        <label>
                           <input id="smsByDelivery" name="smsByDelivery" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onclick="javaScript:fnChangeChkValue('smsByDelivery');"/> 출하
                        </label> 
                        <label>
                           <input id="smsByRegisterGood" name="smsByRegisterGood" class="input_none radio" 
                                  type="checkbox" value="0" 
                                  onclick="javaScript:fnChangeChkValue('smsByRegisterGood');"/> 상품등록처리
                        </label> 
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" class="table_top_line"></td>
                  </tr>
               </table>
               <!-- 컨텐츠 끝 -->
            </td>
         </tr>
         <tr>
            <td colspan="3">&nbsp;</td>
         </tr>
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                  <tr>
                     <td width="20" valign="top">
                        <img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">권한정보</td>
                     <td width="50" class="stitle" style="vertical-align: middle;">
                        <a href="#">
                           <img id="roleAddButton" name="roleAddButton" src="/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;"/> 
                        </a>
                        <a href="#">
                           <img id="roleDelButton" name="roleDelButton" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;"/>
                        </a>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
            <td>&nbsp;</td>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                  <tr>
                     <td width="20" valign="top">
                        <img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">감독관리사용자</td>
                     <td width="50" class="stitle" style="vertical-align: middle;">
                        <a href="#">
                           <img id="mngUserAddButton" name="mngUserAddButton" src="/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;"/> 
                        </a>
                        <a href="#">
                           <img id="mngUserDelButton" name="mngUserDelButton" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;"/>
                        </a>
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <div id="jqgrid">
                  <table id="list"></table>
               </div>
            </td>
            <td>&nbsp;</td>
            <td>
               <div id="jqgrid">
                  <table id="list2"></table>
               </div>
            </td>            
         </tr>
         <tr>
            <td colspan="3">&nbsp;</td>
         </tr>         
         <tr>
            <td align="center" colspan="3">
               <button id='saveButton' class="btn btn-darkgray btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
               <button id='closeButton' class="btn btn-default btn-sm" onclick="javaScript:window.close();"><i class="fa fa-times"></i> 닫기</button>
            </td>
         </tr>
      </table>
      <div id="dialog" title="Feature not supported" style="display:none;">
         <p>That feature is not supported.</p>
      </div>      
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>
<%--       <%@ include file="/WEB-INF/jsp/common/svcUserListDiv.jsp"%> --%>
   </form>
</body>
</html>