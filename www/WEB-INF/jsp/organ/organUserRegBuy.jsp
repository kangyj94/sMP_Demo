<%@page import="kr.co.bitcube.common.dto.BorgDto"%>
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
   	
	List<Object> branchList = (List<Object>) request.getAttribute( "branchList" );
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>

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
    isLoginIdCheck = false;
	  if(e.keyCode==13) { 
		  $("#loginIdConfirm").click(); 
	  } 
   });   
});
</script>


<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">

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
	         userNote:$.trim($("#userNote").val()),
	         isDirect:$.trim($("#isDirect").val()),
	         userIdArr:userIdArr,
	         isSms:"1",
	         smsByPurchase:"1",
	         smsByDelivery:"1",
	         smsByRegisterGood:"1",
	         roleIdArr: new Array('13131','13081'),  
	      	 isDefaultArr: new Array('1','0')
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
	
	var beforeBorgId = $("#borgId").val() ; 
	$("#borgId").change(function(){
		if( $("#isDirect").val()=='N' ){ 
			$("#list2").jqGrid('clearGridData'); 
			return; 
		}
		//감독관 여부가 Y 일 경우 
		var rowCnt = $("#list2").getGridParam('reccount');
		if( rowCnt > 0 ){
			var str = "사업장이 변경되면 등록된 감독 관리 사용자가 삭제됩니다. \n 그래도 변경하시겠습니까?";
			if( confirm( str )==true ){
				$("#list2").jqGrid('clearGridData');
				beforeBorgId = $("#borgId").val() ;
			}else{
				$("#borgId").val( beforeBorgId  );
			}
		}
	});
	
	$("#isDirect").change(function(){
		if( $("#isDirect").val() == 'Y' ){
			$("#mngUserAddButton").show();
			$("#mngUserDelButton").show();
		}else{
			$("#mngUserAddButton").hide();
			$("#mngUserDelButton").hide();
		}
	});
	
	jq("#list2").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/system/getBlank.sys',
    	datatype: 'json',
      	mtype: 'POST',
      	colNames:['userId', '로그인ID', '사용자명'],
      	colModel:[
         	{name:'userId',index:'userId', width:200,align:"left",search:false,sortable:true, editable:false, hidden:true },
         	{name:'loginId',index:'loginId', width:180,align:"center",search:false,sortable:true, editable:false , hidden:false},
         	{name:'userNm',index:'userNm', width:180,align:"left",search:false,sortable:true, editable:false , hidden:false}
      	],
      	postData: {},
      	height: 80, autowidth:true, 
      	sortname: 'isDefault', sortorder: "desc",
      	viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
      	loadComplete: function() {},
      	onSelectRow: function (rowid, iRow, iCol, e) {},
      	ondblClickRow: function (rowid, iRow, iCol, e) {},
      	onCellSelect: function(rowid, iCol, cellcontent, target){},
      	loadError : function(xhr, st, str){ $("#list2").html(xhr.responseText); },
      	jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
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
                     <td height="29" class='ptitle'>사용자 등록</td>
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
                     <td class="table_td_subject"  style="background-color:darkgray;">사업장</td>
                     <td colspan="3" class="table_td_contents">
                         <select id="borgId" name="borgId" >
<%	
	if( branchList != null && branchList.size()>0){
		String selected = "";
		for( int i=0 ; i<branchList.size() ; i++){
			BorgDto borgInfo = (BorgDto) branchList.get(i);
			if( loginUserDto.getBorgId().equals( borgInfo.getBranchId()) == true){selected = "selected";}
			else{	selected = ""; }
%>
								<option value="<%=borgInfo.getBranchId()%>" <%=selected %>><%=borgInfo.getBorgNms()%></option>
<%	} // end of for
	}//end of if	
%>
                         </select>
<!--                         <input id="branchNm" name="branchNm" type="text" value="" size="" maxlength="50" style="width: 80%" class="input_text_none" /> -->
<!--                         <input id="borgId" name="borgId" type="hidden" value="" size="" maxlength="50" style="width: 80%" class="input_text_none" /> -->
<!--                         <a href="#">  -->
<!--                            <img id="srcClientBtn" name="srcClientBtn" src="/img/system/btn_icon_search.gif" width="20" height="18" class='icon_search'style="border: 0px; vertical-align: middle;" /> -->
<!--                         </a>                      -->
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject"  style="background-color:darkgray;">성명</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="userId" name="userId" type="hidden" value="0" size="20" maxlength="30" />
                        <input id="userNm" name="userNm" type="text" value="" size="20" maxlength="30" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100"  style="background-color:darkgray;">아이디</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="loginId" name="loginId" type="text" value="" size="20" maxlength="30"/>
                        <button id='loginIdConfirm' class="btn btn-darkgray btn-xs" ><i class="fa fa-check"></i>중복확인</button>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100"  style="background-color:darkgray;">비밀번호</td>
                     <td class="table_td_contents">
                        <input id="pwd" name="pwd" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/>
                     </td>
                     <td class="table_td_subject" width="100"  style="background-color:darkgray;">비밀번호 확인</td>
                     <td class="table_td_contents">
                        <input id="pwdConfirm" name="pwdConfirm" type="password" value="" size="20" maxlength="30" style="ime-mode: disabled;"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100"  style="background-color:darkgray;">전화번호</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="tel" name="tel" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100"  style="background-color:darkgray;">이동전화번호</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="mobile" name="mobile" type="text" value="" size="20" maxlength="30" onkeydown="return onlyNumberForSum(event)"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject"  style="background-color:darkgray;">이메일</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="eMail" name="eMail" type="text" value="" size="44" maxlength="44" style="ime-mode: disabled;"/> ex)admin@unpamsbank.com
                     </td>
                  </tr>
                  <tr>
                     <td colspan="4" height='1' bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject"  style="background-color:darkgray;">상태</td>
                     <td class="table_td_contents">
                        <select class="select" id="isUse" name="isUse" disabled="disabled">
                           <option value="1"  selected="selected">정상</option>
                           <option value="0" >종료</option>
                        </select>
                     </td>
                     <td class="table_td_subject"  style="background-color:darkgray;">감독유무</td>
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
                     <td class="table_td_subject">참고사항</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="userNote" name="userNote" type="text" value="" size="20" maxlength="30" style="width: 98%" />
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
         	<td colspan="3">
         	<!-- 타이틀 시작 -->
               <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                  <tr>
                     <td width="20" valign="top">
                        <img src="/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                     </td>
                     <td class="stitle">감독관리사용자</td>
                     <td width="50" class="stitle" style="vertical-align: middle;">
                        <a href="#">
                           <img id="mngUserAddButton" name="mngUserAddButton" src="/img/system/btn_icon_plus.gif" width="20" height="18" style="border: 0px; vertical-align: middle; display: none;"/> 
                        </a>
                        <a href="#">
                           <img id="mngUserDelButton" name="mngUserDelButton" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;display: none;"/>
                        </a>
                     </td>
                  </tr>
               </table>
         	</td>
         </tr>
         <tr>
         	<td colspan="3">
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